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
import jeeves.server.context.ServiceContext;
import jeeves.utils.Util;
import org.fao.geonet.GeonetContext;
import org.fao.geonet.constants.Geonet;
import org.fao.geonet.kernel.csw.domain.CswCapabilitiesInfo;
import org.fao.geonet.kernel.setting.SettingManager;
import org.fao.geonet.lib.Lib;
import org.jdom.Element;

import java.util.Map;


public class Add implements Service {

	
	public void init(String appPath, ServiceConfig params) throws Exception {}

	
	public Element exec(Element params, ServiceContext context) throws Exception {
	    GeonetContext gc = (GeonetContext) context.getHandlerContext(Geonet.CONTEXT_NAME);
        Dbms dbms = (Dbms) context.getResourceManager().open (Geonet.Res.MAIN_DB);

        // 
        String serviceName = Util.getParam(params, "service");
        String className = Util.getParam(params, "class");
       
        int serviceId = context.getSerialFactory().getSerial(dbms, "Services");
        
        
        String query = "INSERT INTO Services(id, name, class) VALUES (?, ?, ?)";
        
        dbms.execute(query, serviceId, serviceName, className);
        
		
        //String paramName = Util.getParam(params, "paramName");
        //String paramValue = Util.getParam(params, "paramValue"); 
        //int paramId = context.getSerialFactory().getSerial(dbms, "ServiceParameters");
        
        //String query = "INSERT INTO ServiceParameters(id, name, value) VALUES (?, ?, ?)";
		//dbms.execute(query, 1, serviceName, className);
        //dbms.execute(query, paramId, paramName, paramValue);
        
        		
        // Build response
        return new Element(Jeeves.Elem.RESPONSE).setText("ok");
	}


}