//=============================================================================
//===	Copyright (C) 2001-2010 Food and Agriculture Organization of the
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
//===	Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301, USA
//===
//===	Contact: Jeroen Ticheler - FAO - Viale delle Terme di Caracalla 2,
//===	Rome - Italy. email: geonetwork@osgeo.org
//==============================================================================
package org.fao.geonet.guiservices.csw.virtual;

import jeeves.constants.Jeeves;
import jeeves.interfaces.Service;
import jeeves.resources.dbms.Dbms;
import jeeves.server.ServiceConfig;
import jeeves.server.UserSession;
import jeeves.server.context.ServiceContext;
import org.fao.geonet.GeonetContext;
import org.fao.geonet.constants.Geonet;
import org.fao.geonet.constants.Params;
import org.fao.geonet.kernel.setting.SettingManager;
import org.jdom.Element;


/** Retrieves a particular service
 */
public class Get implements Service {

	public void init(String appPath, ServiceConfig params) throws Exception {}

	public Element exec(Element params, ServiceContext context) throws Exception {
		
		
		String id = params.getChildText(Params.ID);

		Dbms dbms = (Dbms) context.getResourceManager().open (Geonet.Res.MAIN_DB);

		Element elService = 
			dbms.select ("SELECT * FROM Services WHERE id=?", Integer.valueOf(id));

		//--- retrieve filter parameters
		//elParameters.addContent(dbms.select("SELECT name, value FROM ServiceParameters WHERE service =?", Integer.valueOf(id)).getChildren());
		
		Element elParameters = new Element(Geonet.Elem.FILTER);
		
		  java.util.List list = 
				dbms.select("SELECT name, value FROM ServiceParameters WHERE service =?", Integer.valueOf(id)).getChildren();
			
		  for(int i=0; i<list.size(); i++){			
			  
			Element filter = (Element)list.get(i);
			String filterId = filter.getChildText("id");
			//elParameters.addContent(new Element(Geonet.Elem.ID).setText(id).setAttribute("value", filter.getChildText("value")));
			//elParameters.addContent(new Element(Geonet.Elem.FILTER).setText(filter.getChildText(Geonet.Elem.VALUE)).setAttribute(attribute));
			
			elParameters.addContent(new Element(filter.getChildText("name")).setText(filter.getChildText("value")));
			
		}

		elService.addContent(elParameters);
		
		
		return elService;
        
	}

}