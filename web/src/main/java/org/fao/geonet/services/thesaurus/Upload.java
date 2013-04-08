//=============================================================================
//===	Copyright (C) 2001-2005 Food and Agriculture Organization of the
//===	United Nations (FAO-UN), United Nations World Food Programme (WFP)
//===	and United Nations Environment Programme (UNEP)
//===
//===	This program is free software; you can redistribute it and/or modify
//===	it under the terms of the GNU General Public License as published by
//===	the Free Software Foundation; either version 2 of the License, or (at
//===	your option) any later version.
//===
//===	This program is distributed in the hope that it will be useful, but
//===	WITHOUT ANY WARRANTY; without even the implied warranty of
//===	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
//===	General Public License for more details.
//===
//===	You should have received a copy of the GNU General Public License
//===	along with this program; if not, write to the Free Software
//===	Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
//===
//===	Contact: Jeroen Ticheler - FAO - Viale delle Terme di Caracalla 2,
//===	Rome - Italy. email: GeoNetwork@fao.org
//==============================================================================

package org.fao.geonet.services.thesaurus;

import java.io.File;
import java.io.FileOutputStream;
import java.net.URI;

import jeeves.exceptions.BadParameterEx;
import jeeves.exceptions.OperationAbortedEx;
import jeeves.interfaces.Service;
import jeeves.server.ServiceConfig;
import jeeves.server.context.ServiceContext;
import jeeves.utils.Log;
import jeeves.utils.Util;
import jeeves.utils.Xml;
import jeeves.utils.XmlRequest;

import org.fao.geonet.GeonetContext;
import org.fao.geonet.constants.Geonet;
import org.fao.geonet.constants.Params;
import org.fao.geonet.kernel.DataManager;
import org.fao.geonet.kernel.Thesaurus;
import org.fao.geonet.kernel.ThesaurusManager;
import org.fao.geonet.lib.Lib;
import org.jdom.Document;
import org.jdom.Element;

/**
 * Upload one thesaurus file using file upload or file URL. <br/>
 * Thesaurus may be in W3C SKOS format with an RDF extension. Optionnaly an XSL
 * transformation could be run to convert the thesaurus to SKOS.
 * 
 */
public class Upload implements Service {
	static String FS = System.getProperty("file.separator", "/");

	private String stylePath;

	public void init(String appPath, ServiceConfig params) throws Exception {
		this.stylePath = appPath + FS + Geonet.Path.STYLESHEETS + FS;
	}

	/**
	 * Load a thesaurus to GeoNetwork codelist directory.
	 * 
	 * @param params
	 *            <ul>
	 *            <li>fname: if set, do a file upload</li>
	 *            <li>url: if set, try to download from the Internet</li>
	 *            <li>type: local or external (default)</li>
	 *            <li>dir: type of thesaurus, usually one of the ISO thesaurus
	 *            type codelist value. Default is theme.</li>
	 *            <li>stylesheet: XSL to be use to convert the thesaurus before
	 *            load. Default _none_.</li>
	 *            </ul>
	 * 
	 */
	public Element exec(Element params, ServiceContext context)
			throws Exception {
		long start = System.currentTimeMillis();
		Element uploadResult;

		uploadResult = upload(params, context);

		long end = System.currentTimeMillis();
		long duration = (end - start) / 1000;

        if(Log.isDebugEnabled("Thesaurus")) Log.debug("Thesaurus", "Uploaded in " + duration + " s.");

		Element response = new Element("response");
		response.setAttribute("time", duration + "");
		if (uploadResult != null)
			response.addContent(uploadResult);
		return response;

	}

	/**
	 * 
	 * @param params
	 * @param context
	 * @return
	 * @throws Exception
	 */
	private Element upload(Element params, ServiceContext context)
			throws Exception {
		String uploadDir = context.getUploadDir();
		Element uploadResult = null;

		// Upload RDF file
		String fname = null;
		String url = null;
		File rdfFile = null;

		Element param = params.getChild(Params.FNAME);
		if (param == null) {
			url = Util.getParam(params, "url", "");

			// -- get the rdf file from the net
			if (!"".equals(url)) {
                if(Log.isDebugEnabled("Thesaurus")) Log.debug("Thesaurus", "Uploading thesaurus: " + url);

				URI uri = new URI(url);
				rdfFile = File.createTempFile("thesaurus", ".rdf");

				XmlRequest httpReq = new XmlRequest(uri.getHost(),
						uri.getPort());
				httpReq.setAddress(uri.getPath());

				Lib.net.setupProxy(context, httpReq);

				httpReq.executeLarge(rdfFile);

				fname = url.substring(url.lastIndexOf("/") + 1, url.length());
				
				// File with no extension in URL
				if (fname.lastIndexOf('.') == -1) {
					fname += ".rdf"; 
				}
			} else {
                if(Log.isDebugEnabled("Thesaurus"))
                    Log.debug("Thesaurus", "No URL or file name provided for thesaurus upload.");
			}
		} else {
	                fname = param.getTextTrim();
			if (fname.contains("..")) {
				throw new BadParameterEx("Invalid character found in thesaurus name.", fname);
			}
			
			rdfFile = new File(uploadDir, fname);
		}

		if (fname == null || "".equals(fname)) {
			throw new OperationAbortedEx(
					"File upload from URL or file return null.");
		}

		long fsize = 0;
		if (rdfFile.exists()) {
			fsize = rdfFile.length();
		} else {
			throw new OperationAbortedEx("Thesaurus file doesn't exist");
		}

		// -- check that the archive actually has something in it
		if (fsize == 0) {
			throw new OperationAbortedEx("Thesaurus file has zero size");
		}

		// Thesaurus Type (local, external)
		String type = Util.getParam(params, Params.TYPE, "external");

		// Thesaurus directory - one of the ISO theme (Discipline, Place,
		// Stratum, Temporal, Theme)
		String dir = Util.getParam(params, Params.DIR, "theme");

		// no XSL to be applied
		String style = Util.getParam(params, Params.STYLESHEET, "_none_");

		Element eTSResult;

		int extensionIdx = fname.lastIndexOf('.');
		String extension = fname.substring(extensionIdx)
				.toLowerCase();
		if (extension.equals(".rdf") || extension.equals(".xml")) {

            if(Log.isDebugEnabled("Thesaurus")) Log.debug("Thesaurus", "Uploading thesaurus: " + fname);
			
			// Rename .xml to .rdf for all thesaurus
			fname = fname.substring(0, extensionIdx) + ".rdf";
			eTSResult = UploadThesaurus(rdfFile, style, context, fname, type,
					dir);
		} else {
            if(Log.isDebugEnabled("Thesaurus"))
                Log.debug("Thesaurus", "Incorrect extension for thesaurus named: " + fname);
			throw new Exception("Incorrect extension for thesaurus named: "
					+ fname);
		}

		uploadResult = new Element("record").setText("Thesaurus uploaded");
		uploadResult.addContent(eTSResult);

		return uploadResult;
	}

	/**
	 * Load a thesaurus in the catalogue and optionnaly convert it using XSL.
	 * 
	 * @return Element thesaurus uploaded
	 * @throws Exception
	 */
	private Element UploadThesaurus(File rdfFile, String style,
			ServiceContext context, String fname, String type, String dir)
			throws Exception {

		Element TS_xml = null;
		Element xml = Xml.loadFile(rdfFile);
		xml.detach();

		if (!style.equals("_none_")) {
			TS_xml = Xml.transform(xml, stylePath + "/" + style);
			TS_xml.detach();
		} else
			TS_xml = xml;

		// Load document and check namespace
		if (TS_xml.getNamespacePrefix().equals("rdf")
				&& TS_xml.getName().equals("RDF")) {

			GeonetContext gc = (GeonetContext) context
					.getHandlerContext(Geonet.CONTEXT_NAME);
			ThesaurusManager thesaurusMan = gc.getThesaurusManager();
			DataManager dm = gc.getDataManager();

			// copy to directory according to type
			String path = thesaurusMan.buildThesaurusFilePath(fname, type, dir);
			File newFile = new File(path);
			Xml.writeResponse(new Document(TS_xml), new FileOutputStream(
					newFile));

			Thesaurus gst = new Thesaurus(fname, type, dir, newFile, dm.getSiteURL());
			thesaurusMan.addThesaurus(gst, false);
		} else {
			rdfFile.delete();
			throw new Exception("Unknown format (Must be in SKOS format).");
		}

		return new Element("Thesaurus").setText(fname);
	}
}
