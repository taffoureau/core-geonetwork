//=====================================================================================
//===
//=== View (type:csw)
//===
//=====================================================================================

csw.View = function(xmlLoader)
{
	HarvesterView.call(this);	
	
	var searchTransf = new XSLTransformer('harvesting/csw/client-search-row.xsl', xmlLoader);
	var searchCapTransf = new XSLTransformer('harvesting/csw/client-search-capability.xsl', xmlLoader);
	var searchTempTransf = new XSLTransformer('harvesting/csw/client-search-temp.xsl', xmlLoader);
	var privilTransf = new XSLTransformer('harvesting/csw/client-privil-row.xsl', xmlLoader);
	var resultTransf = new XSLTransformer('harvesting/csw/client-result-tip.xsl', xmlLoader);
	
	var loader = xmlLoader;
	var valid  = new Validator(loader);
	var shower = null;
	
	var searchtemp;
	
	var currSearchId = 0;
	
	this.setPrefix('csw');
	this.setPrivilTransf(privilTransf);
	this.setResultTransf(resultTransf);
	
	//--- public methods
	
	this.init           = init;
	this.setEmpty       = setEmpty;
	this.setData        = setData;
	this.getData        = getData;
	this.isDataValid    = isDataValid;
	this.clearIcons     = clearIcons;
	this.addIcon        = addIcon;		
	this.addEmptySearch = addEmptySearch;
	this.removeSearch   = removeSearch;

	Event.observe('csw.icon', 'change', ker.wrap(this, updateIcon));

//=====================================================================================
//===
//=== API methods
//===
//=====================================================================================

function init()
{
	valid.add(
	[
		{ id:'csw.name',        type:'length',   minSize :1,  maxSize :200 },
		{ id:'csw.capabUrl',    type:'length',   minSize :1,  maxSize :200 },
		{ id:'csw.capabUrl',    type:'url' },
		{ id:'csw.username',    type:'length',   minSize :0,  maxSize :200 },
		{ id:'csw.password',    type:'length',   minSize :0,  maxSize :200 }
	]);

	shower = new Shower('csw.useAccount', 'csw.account');
}

//=====================================================================================

function setEmpty()
{
	this.setEmptyCommon();
	
	removeAllSearch();
	
	$('csw.capabUrl').value = '';
	
	var icons = $('csw.icon').options;
	
	for (var i=0; i<icons.length; i++)
		if (icons[i].value == 'default.gif')
		{
			icons[i].selected = true;
			break;
		}

	shower.update();
	updateIcon();
}

//=====================================================================================

function setData(node)
{
	this.setDataCommon(node);

	var site     = node.getElementsByTagName('site')    [0];
	var searches = node.getElementsByTagName('searches')[0];

	hvutil.setOption(site, 'capabilitiesUrl', 'csw.capabUrl');
	hvutil.setOption(site, 'icon',            'csw.icon');
	
	//--- add search entries
	
	var list = searches.getElementsByTagName('search');
	
	removeAllSearch();
	
	for (var i=0; i<list.length; i++)
		addSearch(list[i]);

	//--- add privileges entries
	
	this.removeAllGroupRows();
	this.addGroupRows(node);
	
	//--- set categories

	this.unselectCategories();
	this.selectCategories(node);	
	
	shower.update();
	updateIcon();
}

//=====================================================================================

function getData()
{
	var data = this.getDataCommon();
	
	data.CAPAB_URL = $F('csw.capabUrl');
	data.ICON      = $F('csw.icon');
	
	//--- retrieve search information
	
	var searchData = [];
	var searchList = xml.children($('csw.searches'));
	
	for(var i=0; i<searchList.length; i++)
	{
		var divElem = searchList[i];
		
		searchData.push(
		{
			//ANY_TEXT : xml.getElementById(divElem, 'csw.anytext') .value,
			RevisionDate : xml.getElementById(divElem, 'csw.RevisionDate').value,
			AlternateTitle : xml.getElementById(divElem, 'csw.AlternateTitle').value
			
		});
	}
	
	data.SEARCH_LIST = searchData;
	data.SEARCH_TEMP = searchtemp;
	
	//--- retrieve privileges and categories information
	
	data.PRIVILEGES = this.getPrivileges();
	data.CATEGORIES = this.getSelectedCategories();
		
	return data;
}

//=====================================================================================

function isDataValid()
{
	if (!valid.validate())
		return false;
		
	return this.isDataValidCommon();
}

//=====================================================================================

function clearIcons() 
{ 
	$('csw.icon').options.length = 0;
}

//=====================================================================================

function addIcon(file)
{
	gui.addToSelect('csw.icon', file, file);
}

//=====================================================================================

function updateIcon()
{
	var icon = $F('csw.icon');
	var image= $('csw.icon.image');
	
	image.setAttribute('src', Env.url +'/images/harvesting/'+icon);
}

//=====================================================================================
//=== Search methods
//=====================================================================================

function addEmptySearchOld()
{
		var doc    = Sarissa.getDomDocument();	
		var search = doc.createElement('search');

		addSearch(search);
}


function addEmptySearch()
{
	var url = $('csw.capabUrl').value;
	OpenLayers.ProxyHostURL = '../../../proxy?url='+encodeURIComponent(url);
	console.log(OpenLayers.ProxyHostURL);
		 
	OpenLayers.Request.GET({
		url: OpenLayers.ProxyHostURL,
   		success: function(response) {
   			
   			var doc    = Sarissa.getDomDocument();	
   			var search = doc.createElement('search');
   			var searchtmp = doc.createElement('search');
   			
            console.log("starting to parse returned XML ... ");
            
    		var format = new OpenLayers.Format.XML();
    		var doc = format.read(response.responseText);
    		var nodes = format.getElementsByTagNameNS(doc, '*', 'Constraint');
			for(var i=0; i < nodes.length; i++) {
				if (nodes[i].attributes[0].value =='SupportedISOQueryables' || nodes[i].attributes[0].value =='AdditionalQueryables')
				for(var j=0; j < nodes[i].childNodes.length; j++) {
					if (nodes[i].childNodes[j].nodeName == 'ows:Value'){
						var sub = doc.createElement(nodes[i].childNodes[j].firstChild.nodeValue);
						search.appendChild(sub);
						
						var text = doc.createTextNode('{'+nodes[i].childNodes[j].firstChild.nodeValue +'}');
						var subtmp = doc.createElement(nodes[i].childNodes[j].firstChild.nodeValue);
						subtmp.appendChild(text);
						searchtmp.appendChild(subtmp);
	
					}
				}
			}
			
			addSearchTemp(searchtmp);
			
			addSearchCap(search);
			
    	},
    	failure: function(result) {
            console.log("failure");
    	}
	});

	
}

//=====================================================================================

function addSearchCap(search)
{
	var id = ''+ currSearchId++;
	search.setAttribute('id', id);
	
	var html = searchCapTransf.transformToText(search);
	
	//--- add the new search in list
	new Insertion.Bottom('csw.searches', html);
	
}


function addSearchTemp(searchtmp)
{
	searchtemp = searchTempTransf.transformToText(searchtmp);
	
	console.log(searchtemp);
	
}


//=====================================================================================

function addSearch(search)
{
	var id = ''+ currSearchId++;
	search.setAttribute('id', id);
	

	var html = searchTransf.transformToText(search);

	
	//--- add the new search in list
	new Insertion.Bottom('csw.searches', html);
	
	
	valid.add(
	[
		{ id:'csw.anytext',  type:'length',   minSize :0,  maxSize :200 },
		{ id:'csw.title',    type:'length',   minSize :0,  maxSize :200 },
		{ id:'csw.abstract', type:'length',   minSize :0,  maxSize :200 },
		{ id:'csw.subject',  type:'length',   minSize :0,  maxSize :200 },
		{ id:'csw.minscale', type:'length',   minSize :0,  maxSize :200 },
		{ id:'csw.maxscale', type:'length',   minSize :0,  maxSize :200 }
	], id);
}

//=====================================================================================

function removeSearch(id)
{
	valid.removeByParent(id);
	Element.remove(id);
}

//=====================================================================================

function removeAllSearch()
{
	$('csw.searches').innerHTML = '';
	valid.removeByParent();	
}

//=====================================================================================
}

