// Map code for DNA
                var map;                  
                var pinID = 1;
                var locationID = 0;
                var listItemID = 0;
                var mouseX = 0;
                var mouseY = 0;
                var locations = new Array();
                var mapleft = 0;
                var maptop = 0;

                function SetMapOffsets(obj) 
                {
                    if (obj.offsetParent) 
                    {
                        mapleft = obj.offsetLeft
                        maptop = obj.offsetTop
                        while (obj = obj.offsetParent) 
                        {
                            mapleft += obj.offsetLeft
                            maptop += obj.offsetTop
                        }
                    }
                }
                
                function GetMap(latitude, longitude)      
                {    
                    if (!map)
                    {
                      map = new VEMap('myMap');
                    }
                    map.LoadMap(new VELatLong(latitude, longitude), 19, 'h', false, VEMapMode.Mode2D, true);
                    map.AttachEvent("ondoubleclick", ReCenterMap);
                }
                
                function PositionMap(latitude, longitude, zoom)
                {
                    //shiftMap();
                    if (!map)
                    {
                        map = new VEMap('myMap');
                    }
                    var mapCenter = new VELatLong(latitude, longitude)
                    map.LoadMap(mapCenter, zoom, 'h', false, VEMapMode.Mode2D, true);
                    map.AttachEvent("onclick", MouseClick);
                    map.AttachEvent("ondoubleclick", ReCenterMap);
                    SetMapOffsets(document.getElementById("myMap"));
                    
                    if(locations.length > 0)
                    {
                        LoadExistingLocations();
                        mapCenter = new VELatLong(locations[0].latlong.Latitude, locations[0].latlong.Longitude);
                    }
                    map.SetCenter(mapCenter);
                    ClearValues();
                }
                
                function PositionMap2(latitude, longitude, zoom)
                {
                    unhideMap();
                    var mapdiv = document.getElementById('mapContainer');
                    if (!map)
                    {
                        map = new VEMap('myMap');
                    }
                    var mapCenter = new VELatLong(latitude, longitude)
                    map.LoadMap(mapCenter, zoom, 'h', false, VEMapMode.Mode2D, true);
                    map.AttachEvent("onclick", MouseClick);
                    //map.AttachEvent("ondoubleclick", ReCenterMap);
                    SetMapOffsets(document.getElementById("myMap"));
                    
                    if(locations.length > 0)
                    {
                        LoadExistingLocations();
                        mapCenter = new VELatLong(locations[0].latlong.Latitude, locations[0].latlong.Longitude);
                    }
                    map.SetCenter(mapCenter);
                    ClearValues();
                }
                
                function ClearValues()
                {
                    document.getElementById("linksaved").style.display = 'none';
                    document.getElementById('txtWhere').value = "";
                    document.getElementById('maplinktitle').value = "";
                    document.getElementById('maplinkdescription').value = "";
                }
                
                function CleanStrings(input)
                {
                    //trying to cater for input links such as <a href="#">Test</a>
                    input = input.replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;").replace(/"/g, "&quot;");
                    
                    //input = input.replace(/[\"\'][\s]*javascript:(.*)[\"\']/gi, "\"\"");
                    //input = input.replace(/script(.*)/gi, "");    
                    //input = input.replace(/eval\((.*)\)/gi, "");

                    //input = input.replaceAll("<", "&lt;").replaceAll(">", "&gt;");
                    //input = input.replaceAll("eval\\((.*)\\)", "");
                    //input = input.replaceAll("[\\\"\\\'][\\s]*((?i)javascript):(.*)[\\\"\\\']", "\"\"");
                    //input = input.replaceAll("((?i)script)", "");
                    //input = escape(input);
                    return input;
                }
                
                function RevertStrings(input)
                {
                   input = unescape(input);
                   return input;
                }
                
                function AddLocationListEntry(latlong, title, description, locationid)
                {                   
                    document.getElementById('locationlist').style.display = 'block';

                    var liparent = document.getElementById('locationSummary');
                    var newLI = document.createElement('LI');
                    newLI.id = "li_" + listItemID++;
                    var showmapanchor = "<a href='#' onclick='PositionMap2(" + latlong.Latitude + "," + latlong.Longitude + ",12);return false;'>" + title + "</a>";
                    var delmapanchor  = "<a href='#' onclick=\"RemoveLocation('" + latlong.Latitude + "','" + latlong.Longitude + "','" + title + "','" + description + "','" + locationid + "','" + newLI.id + "');return false;\"> Remove this location </a>";

                    newLI.innerHTML = showmapanchor + " - " + delmapanchor;
                    
                    liparent.appendChild(newLI);                    
                }
                
                function RemoveLocationListEntry(listItemID)
                {
                    var listItem = document.getElementById(listItemID);
                    var liparent = document.getElementById('locationSummary');
                    liparent.removeChild(listItem);
                }
                
                function GenerateLocationXML()
                {
                    document.getElementById('LocationXML').value = "";
                    for (i=0; i < locations.length; i++)
                    {
                        var locationText = '<location locationid="' + locations[i].id + '"><lat>' + locations[i].latlong.Latitude + '</lat><long>' + locations[i].latlong.Longitude +'</long><title>' + locations[i].title + '</title><description>' + locations[i].description + '</description><zoomlevel>0</zoomlevel></location>';
                        document.getElementById('LocationXML').value += locationText;
                    }
                }
                
                function RemoveLocation(latitude, longitude, title, description, locationid, listItemID)
                {
                    var cleantitle = CleanStrings(title);
                    var cleandescription = CleanStrings(description);
                    
                    for (i=0; i < locations.length; i++)
                    {
					    if (locations[i].latlong.Latitude == latitude && locations[i].latlong.Longitude == longitude && locations[i].title == cleantitle && locations[i].description == cleandescription)
					    {
						    locations.splice(i, 1);
						    break;
					    }                       
                    }     
                    RemoveLocationListEntry(listItemID);  
                    PositionMap2(51.601322, -0.102913, 10);         
                }
                
                function AddLocationToArray(latlong, title, description, locationID)
                {
                    var tmpObj = new Object();
				    tmpObj.id = locationID;
				    tmpObj.latlong = latlong;
				    tmpObj.title = title;
				    tmpObj.description = description;

				    locations.push(tmpObj);	
                }
                                
                function AddLocation()
                {
                    var title = document.getElementById('maplinktitle').value;
                    var description = document.getElementById('maplinkdescription').value;
                    
                    var cleantitle = CleanStrings(title);
                    var cleandescription = CleanStrings(description);
                                        
                    var latlong = map.GetCenter();
                    
                    AddLocationToArray(latlong, cleantitle, cleandescription, 0);
                    AddLocationListEntry(latlong, cleantitle, cleandescription, 0);
                    AddPushpin(latlong, cleantitle, cleandescription);
                }
              
                function LoadExistingLocations()
                {
                    for (i=0; i < locations.length; i++)
                    {
                        AddPushpin(locations[i].latlong, locations[i].title, locations[i].description);
                    }
                }

                function RepositionMap(latitude, longitude, zoom)
                {          
                    if(!map)
                    {
                        FullMap3();
                    } 
                    else
                    {
                        unhideMap();
                    }
                    document.getElementById('resultDiv').innerHTML = "";         
                    document.getElementById("resultDiv").style.display = 'none';
                    document.getElementById("mapContainer").style.height = '600px';
					map.SetCenterAndZoom(new VELatLong(latitude, longitude), zoom);
                	return false;
                }
                
                function HandleKeyDown(dofind)
                {
                    // process only the Enter key
                    if (event.keyCode == 13)
                    {
                        // cancel the default submit
                        event.returnValue=false;
                        event.cancel = true;
                        
                        if (dofind==true)
                        {
                            // do our find location
                            document.getElementById('findlocationbtn').click();
                        }
                    }
                }
                                
                function MouseClick(e)
                {
                    return false;
                }                
                
                function ReCenterMap(e)
                {
                   var viewportwidth;
                   var viewportheight;
                   
                   // the more standards compliant browsers (mozilla/netscape/opera/IE7) use window.innerWidth and window.innerHeight
                   
                   if (typeof window.innerWidth != 'undefined')
                   {
                        viewportwidth = window.innerWidth,
                        viewportheight = window.innerHeight
                   }
                   
                  // IE6 in standards compliant mode (i.e. with a valid doctype as the first line in the document)

                   else if (typeof document.documentElement != 'undefined'
                       && typeof document.documentElement.clientWidth !=
                       'undefined' && document.documentElement.clientWidth != 0)
                   {
                         viewportwidth = document.documentElement.clientWidth,
                         viewportheight = document.documentElement.clientHeight
                   }
                   
                   // older versions of IE
                   
                   else
                   {
                         viewportwidth = document.getElementsByTagName('body')[0].clientWidth,
                         viewportheight = document.getElementsByTagName('body')[0].clientHeight
                   }
                   
                    var x,y;
                    if (self.pageYOffset) // all except Explorer
                    {
	                    x = self.pageXOffset;
	                    y = self.pageYOffset;
                    }
                    else if (document.documentElement && document.documentElement.scrollTop)
	                    // Explorer 6 Strict
                    {
	                    x = document.documentElement.scrollLeft;
	                    y = document.documentElement.scrollTop;
                    }
                    else if (document.body) // all other Explorers
                    {
	                    x = document.body.scrollLeft;
	                    y = document.body.scrollTop;
                    }
                    
                    var pixel;
					if (document.all)
					{
                        pixel = new VEPixel(e.mapX + x, e.mapY + y);
                    }    
                    else
                    {
                        pixel = new VEPixel(e.mapX, e.mapY);
                    }                                    
                    var latlong = map.PixelToLatLong(pixel);
                    
				    var zoom = map.GetZoomLevel();
				    map.SetCenterAndZoom(latlong, zoom + 1);
                }
                
                function PositionMapWithPin(latitude, longitude, zoom, title, description)
                {
                    PositionMap2(latitude, longitude, zoom);
                    AddPin((new VELatLong(latitude, longitude)), title, description);
                }
                
                function AddPin(latlong, title, description)
                {               
                    var pin = new VEPushpin(               
                        pinID,                
                        latlong,                
                        null,                
                        title,                
                        description               
                    );            
                    map.AddPushpin(pin);            
                    pinID++;         
                }
                function FindNear()         
                {            
                    map.FindNearby(document.getElementById('txtWhat').value, '1', onFoundResults);         
                }
                         
                function FindLoc()         
                {  
                    if (document.getElementById('txtWhere').value != "")
                    {   
                        var UKWhere = document.getElementById('txtWhere').value;
                               
                        document.getElementById("linksaved").style.display = 'none';
                        CancelMapLink();
                        //VEMap.Find(what, where, findType, shapeLayer, startIndex, numberOfResults, showResults, createResults, useDefaultDisambiguation, setBestMapView, callback);
                        map.Find(null, UKWhere, null, null, 0, 5, false, false, false, false, onFoundLocationResults);         
                    }
                }
                         
                function onFoundLocationResults(layer, resultsArray, places, hasMore, veErrorMessage)         
                {            
                    var results="More than one location was returned. Please select the location you were looking for:<br>";            
                    if (places != null)
                    {
                        for (x=0; x<places.length; x++)            
                        {               
                            results+="<a class='pos' href='#' onclick='RepositionMap("+places[x].LatLong.Latitude+","+places[x].LatLong.Longitude+",12);return false;'>"+places[x].Name+"</a><br>";            
                        }            
                        document.getElementById('resultDiv').innerHTML = results;         
                        document.getElementById("resultDiv").style.display = 'block';
                        document.getElementById("mapContainer").style.height = '800px';
                    }
                }
                            
                function onFoundResults(findResults)         
                {            
                    var results="Find Results:\n";            
                    for (r=0; r < findResults.length; r++)            
                    {                  
                        results += findResults[r].Name + ", ";                  
                        results += findResults[r].Description + ": ";                  
                        results += findResults[r].Phone + "\n";            
                    }            
                    alert(results);         
                }
                
                function GetRoute()         
                {            
                    map.GetRoute(document.getElementById('txtFrom').value, 
                                   document.getElementById('txtTo').value, 
                                   VEDistanceUnit.Miles,                     
                                   VERouteType.Shortest);         
                }
                
                function DeletePin(id)         
                {              
                    try            
                    {                 
                        if (id)                
                        {                
                            map.DeletePushpin(id);                
                        }                
                        else                
                        {                
                            map.DeleteAllPushpins();                
                        }            
                    }            
                    catch (err)            
                    {                
                        alert(err.message);            
                    }         
                } 
                function fnTrackMouse()
                {
                   mouseX = event.clientX; 
                   mouseY = event.clientY;
                   
                   DoPixelToLL(mouseX, mouseY);  
                }
                   
                              
                function DoPixelToLL(x,y)         
                {            
                    var ll = map.PixelToLatLong(x,y);
                    document.getElementById('LatLon').value = ll.toString();            
                }         
                function DoLLToPixel()         
                {            
                    var center = map.LatLongToPixel(map.GetCenter());            
                }    
                function GetLatLong()         
                {
                    DoPixelToLL(mouseX, mouseY);            
                }
                function GetCurrentMap()
                {
                    var latlong = map.GetCenter();
                    var mycode = "<MAP-LOCATION LATITUDE='" + latlong.Latitude + "' LONGITUDE='" + latlong.Longitude + "' ZOOM='" + map.GetZoomLevel() + "'>"
                    + document.getSelection() + "</MAP-LOCATION>";
                    document.getElementById('guideml').innerText = mycode;
                    
                }
                
                // Show the description field and buttons
                function MakeMapLink()
                {
                  document.getElementById("makemaplink").style.display = 'none';
                  document.getElementById("maplinktitled").style.display = 'inline';
                  document.getElementById("maplinkdescriptiond").style.display = 'inline';
                  document.getElementById("maplinktitledhelper").style.display = 'inline';
                  document.getElementById("maplinkdescriptiondhelper").style.display = 'inline';
                  document.getElementById("savemaplink").style.display = 'inline';
                  document.getElementById("cancelmaplink").style.display = 'inline';
                  document.getElementById("linksaved").style.display = 'none';
                  
                  document.getElementById("myMap").style.width ='900px';
                  document.getElementById("mapContainer").style.width ='900px';
                  document.getElementById("findheaderbartable").style.width ='900px';

                  
                }
                
                function CancelMapLink()
                {
                  document.getElementById("linksaved").style.display = 'none';
                  HideMapLinkUI();
                }
                
                function HideMapLinkUI()
                {
                  document.getElementById("makemaplink").style.display = 'inline';
                  document.getElementById("maplinktitled").style.display = 'none';
                  document.getElementById("maplinkdescriptiond").style.display = 'none';
                  document.getElementById("maplinktitledhelper").style.display = 'none';
                  document.getElementById("maplinkdescriptiondhelper").style.display = 'none';
                  document.getElementById("savemaplink").style.display = 'none';
                  document.getElementById("cancelmaplink").style.display = 'none';
                  document.getElementById("myMap").style.width ='728px';
                  document.getElementById("mapContainer").style.width ='728px';
                  document.getElementById("findheaderbartable").style.width ='728px';
                }
                
                function HideMapShowSaved()
                {
                  HideMapLinkUI();
                  document.getElementById("linksaved").style.display = 'inline';
                }
                
                var savedLinks = new Array(); 
                
                savedLinks[0] = new Object();
                savedLinks[1] = new Object();
                savedLinks[0].linkdata = '<something/>';
                savedLinks[1].linkdata = 'else';
                
                function insertLink(linkid)
                {
                  var linkdata = savedLinks[linkid];
                  insertAtCursor(document.getElementById("bodyText"),linkdata.linkdata);
                }
                
                function showLocations()
                {
                  document.getElementById("savedlinks").style.display = 'block';
                  document.getElementById("showsavedlocations").style.display = 'none';
                  document.getElementById("hidesavedlocations").style.display = 'inline';
                }
                
                function hideLocations()
                {
                  document.getElementById("savedlinks").style.display = 'none';
                  document.getElementById("showsavedlocations").style.display = 'inline';
                  document.getElementById("hidesavedlocations").style.display = 'none';
                }
                function SaveMapLink()
                {
                    alert("Remember to click Add or Update Guide Entry to fix these saved locations to the Entry when you close/hide the map.");
                    HideMapShowSaved();
                    AddLocation();
                }
                
                // save some variables for when we insert a map link
                                

//myField accepts an object reference, myValue accepts the text strint to add
                
                function insertAtCursor(myField, myValue)
                {
                                  //IE support
                  if (myField.selectionStart || myField.selectionStart == '0') 
                 {
                    myField.focus();
                    //Here we get the start and end points of the
                    //selection. Then we create substrings up to the
                    //start of the selection and from the end point
                    //of the selection to the end of the field value.
                    //Then we concatenate the first substring, myValue,
                    //and the second substring to get the new value.
                    var startPos = myField.selectionStart;
                    var endPos = myField.selectionEnd;
                    myField.value = myField.value.substring(0, startPos)+ myValue+ myField.value.substring(endPos, myField.value.length);
                  } 

                  //Mozilla/firefox/Netscape 7+ support
                  else if (document.selection)
                   {
                    myField.focus();

                    //in effect we are creating a text range with zero
                    //length at the cursor location and replacing it
                    //with myValue
                    sel = document.selection.createRange();
                     
                   sel.text = myValue;
                  }
                  else 
                  {
                    myField.value += myValue;
                  }

                }
                
                function olderinsertAtCursor(myField, myValue) 
                {
                   //IE support
                  if (document.selection) 
                  {
                    myField.focus();
                    var sel = document.selection.createRange();
                    sel.text = myValue;
                  }
                  //MOZILLA/NETSCAPE support
                  else if (myField.selectionStart || myField.selectionStart == '0') 
                  {
                    var startPos = myField.selectionStart;
                    var endPos = myField.selectionEnd;
                    myField.value = myField.value.substring(0, startPos)
                    + myValue
                    + myField.value.substring(endPos, myField.value.length);
                  } 
                  else 
                  {
                    myField.value += myValue;
                  }
                }
                
                function shiftMap()
                {
                   var viewportwidth;
                   var viewportheight;
                   
                   // the more standards compliant browsers (mozilla/netscape/opera/IE7) use window.innerWidth and window.innerHeight
                   
                   if (typeof window.innerWidth != 'undefined')
                   {
                        viewportwidth = window.innerWidth,
                        viewportheight = window.innerHeight
                   }
                   
                  // IE6 in standards compliant mode (i.e. with a valid doctype as the first line in the document)

                   else if (typeof document.documentElement != 'undefined'
                       && typeof document.documentElement.clientWidth !=
                       'undefined' && document.documentElement.clientWidth != 0)
                   {
                         viewportwidth = document.documentElement.clientWidth,
                         viewportheight = document.documentElement.clientHeight
                   }
                   
                   // older versions of IE
                   
                   else
                   {
                         viewportwidth = document.getElementsByTagName('body')[0].clientWidth,
                         viewportheight = document.getElementsByTagName('body')[0].clientHeight
                   }
                   
                     var x,y;
                    if (self.pageYOffset) // all except Explorer
                    {
	                    x = self.pageXOffset;
	                    y = self.pageYOffset;
                    }
                    else if (document.documentElement && document.documentElement.scrollTop)
	                    // Explorer 6 Strict
                    {
	                    x = document.documentElement.scrollLeft;
	                    y = document.documentElement.scrollTop;
                    }
                    else if (document.body) // all other Explorers
                    {
	                    x = document.body.scrollLeft;
	                    y = document.body.scrollTop;
                    }

                  unhideMap();
                  var mapdiv = document.getElementById('mapContainer');
                  mapdiv.style.position = 'absolute';
                  mapdiv.style.top = y + (viewportheight / 2) - (mapdiv.clientHeight / 2);
                  mapdiv.style.left = x + (viewportwidth / 2) - (mapdiv.clientWidth / 2);
                  
                }
                
                function hideMap()
                {
                  document.getElementById('mapContainer').style.display = 'none';
                }
                
                function unhideMap()
                {
                    document.getElementById('mapContainer').style.display = 'block';
                
                }
                function showMap(latitude,longitude,zoom)
                {
                  if (!map)
                  {
                      PositionMap(latitude,longitude,zoom);
                  }
                  else
                  {
                    //shiftMap();
                  }
                  unhideMap();
               }
               
               
              function FullMap()
              {
                var bounds = new Array();
                for (i=0; i < mapPoints.length; i++)
                {
                  bounds[i] = new VELatLong(mapPoints[i].lat,mapPoints[i].lng);
                }
                //shiftMap();
                if (!map)
                {
                  map = new VEMap('myMap');
                }
                map.SetMapView(bounds);
                for (i=0; i < mapPoints.length; i++)
                {
                  AddPin(new VELatLong(mapPoints[i].lat,mapPoints[i].lng),mapPoints[i].description,'');
                }                    
              }
              
              function AddPushpin(latlng, title, description)
              {
                var shape = new VEShape(VEShapeType.Pushpin, latlng);
                
                var cleantitle = title;
                var cleandescription = description;
                
                //var cleantitle = CleanStrings(title);
                //var cleandescription = CleanStrings(description);

                shape.SetTitle(cleantitle);
                shape.SetDescription(cleandescription);
                pinID++;
                
                //shape.ShowDetailOnMouseOver = false;
                //shape.OnMouseOverCallback = MyShowDetailOnMouseOver(x, y, title, details)

                map.AddShape(shape);
              }
              
              function OnMouseClick(e)
              {
                var viewportwidth;
                var viewportheight;
                   
                // the more standards compliant browsers (mozilla/netscape/opera/IE7) use window.innerWidth and window.innerHeight
                   
                if (typeof window.innerWidth != 'undefined')
                {
                   viewportwidth = window.innerWidth,
                   viewportheight = window.innerHeight
                }
               
                  // IE6 in standards compliant mode (i.e. with a valid doctype as the first line in the document)

                   else if (typeof document.documentElement != 'undefined'
                       && typeof document.documentElement.clientWidth !=
                       'undefined' && document.documentElement.clientWidth != 0)
                   {
                         viewportwidth = document.documentElement.clientWidth,
                         viewportheight = document.documentElement.clientHeight
                   }                   
                   // older versions of IE                   
                   else
                   {
                         viewportwidth = document.getElementsByTagName('body')[0].clientWidth,
                         viewportheight = document.getElementsByTagName('body')[0].clientHeight
                   }
               
                    var x,y;
                    if (self.pageYOffset) // all except Explorer
                    {
                        x = self.pageXOffset;
                        y = self.pageYOffset;
                    }
                    else if (document.documentElement && document.documentElement.scrollTop)
                        // Explorer 6 Strict
                    {
                        x = document.documentElement.scrollLeft;
                        y = document.documentElement.scrollTop;
                    }
                    else if (document.body) // all other Explorers
                    {
                        x = document.body.scrollLeft;
                        y = document.body.scrollTop;
                    }
                    var locationDetailsDiv = document.getElementById('locationDetails');
                    locationDetailsDiv.style.display = 'block';
                    locationDetailsDiv.style.position = 'absolute';
                    locationDetailsDiv.style.top = y + (viewportheight / 2) - (locationDetailsDiv.clientHeight / 2);
                    locationDetailsDiv.style.left = x + (viewportwidth / 2) - (locationDetailsDiv.clientWidth / 2);
                
              }
              
              function FullMap2()
              {
                getPushpins();
                //shiftMap();
                if (!map)
                {
                  map = new VEMap('myMap');
                }
                map.LoadMap();
                map.SetMapView(points);
                
                //If we only have one point then make sure we don't zoom in too far so it looks silly
				if(points.length == 1)
				{
					map.SetZoomLevel(12);
				}
    
                for (i=0; i < mapPoints.length; i++)
                {
                  AddPushpin(mapPoints[i].latlng, mapPoints[i].title, mapPoints[i].description);
                }                    
              }
              
              function FullMap3()
              {
                getPushpins();
                
                unhideMap();
                                
                if (!map)
                {
                  map = new VEMap('myMap');
                }
                map.LoadMap(null, null, VEMapStyle.Hybrid, false, VEMapMode.Mode2D, true);
                map.SetMapView(points);
                
                //If we only have one point then make sure we don't zoom in too far so it looks silly
				if(points.length == 1)
				{
					map.SetZoomLevel(12);
				}
    
                for (i=0; i < mapPoints.length; i++)
                {
                  AddPushpin(mapPoints[i].latlng, mapPoints[i].title, mapPoints[i].description);
                }                    
              }
                
                
                
 /*
*************************************************************************************************************************************************
Stuff for the ManageRoutePage
*************************************************************************************************************************************************
 */               
            var msmap;                  
            var _pinID = 1;
            var _mouseX = 0;
            var _mouseY = 0;
            var _latitude = 0;
            var _longitude = 0;
            var _elementid = 0;
            var _mapPoints = new Array();
		    var tmpRoute = new Object();
		    
            function ManageRouteAddPin(pinShapes, latitude, longitude, title, description)
            {   
				var HTMLDescription = description;
				var shape = new VEShape(VEShapeType.Pushpin, new VELatLong(latitude, longitude));
					shape.SetTitle("<div class='pinTitle'>" + title + "</div>");
					shape.SetDescription("<div class='pinDetails'>" + HTMLDescription + "</div>");
                    _pinID++;
					//shape.SetCustomIcon("<div class='iconStyle'><img src='/dnaimages/mapping/pushpins/015.bmp'> </div>");
                    pinShapes.push(shape); 					
            }
            
			function RemoveMenu()
			{
				var menu = document.getElementById('popupmenu');
				if (menu)
				{
				    menu.style.display='none'; 
				}
			}
			
			function ShowMenu(e)
			{
				if (e.rightMouseButton)
				{				
					var mapX = e.mapX;
					var mapY = e.mapY;
					var xmap = msmap.GetLeft();
					var ymap = msmap.GetTop();
					var scrollX;
					var scrollY;
                    var x;
                    var y;
					var tempX;
					var tempY;
                    
                    if (!document.all) // all except Explorer
                    {
                        //alert("1");
					    scrollX = self.pageXOffset;
					    scrollY = self.pageYOffset;

	                    tempX = mapX;
	                    tempY = mapY;
                    }
                    else if (document.documentElement && document.documentElement.scrollTop)
	                    // Explorer 6 Strict
                    {
                        //alert("2");
	                    x = document.documentElement.scrollLeft;
	                    y = document.documentElement.scrollTop;
					    scrollX = document.documentElement.scrollLeft;
					    scrollY = document.documentElement.scrollTop;
	                    tempX = e.clientX + x;
	                    tempY = e.clientY + y;
                    }
                    else if (document.body) // all other Explorers
                    {
                        //alert("3");
	                    x = document.body.scrollLeft;
	                    y = document.body.scrollTop;
					    scrollX = document.body.scrollLeft;
					    scrollY = document.body.scrollTop;
	                    tempX = e.clientX + x;
	                    tempY = e.clientY + y;
                    }
                    
					var menu = document.getElementById('popupmenu');
					if (document.all)
					{
					    //alert("tempX" + tempX + ", tempY" + tempY);
					    //alert("scrollX" + scrollX + ", scrollY" + scrollY);
					   // alert("xmap" + xmap + ", ymap" + ymap);
					    //alert("mapX" + mapX + ", mapY" + mapY);
					    //alert("x" + x + ", y" + y);
					    menu.style.left = mapX + x + "px"; //Positioning the menu
					    menu.style.top = mapY + y + "px"; //Positioning the menu
                        pixel = new VEPixel(e.mapX + x, e.mapY + y);
                    }    
                    else
                    {
					    menu.style.left = xmap + tempX + "px"; //Positioning the menu
					    menu.style.top = ymap + tempY + "px"; //Positioning the menu
                        pixel = new VEPixel(e.mapX, e.mapY);
                    }                                    
				
					var LL = msmap.PixelToLatLong(pixel);
					_latitude = LL.Latitude;
					_longitude = LL.Longitude;
					_elementid = e.elementID;
					menu.style.zIndex = 800; //put it in top					
					menu.style.display='block'; //Showing the menu					
				}
				else
				{
					RemoveMenu();
				}
			}
			
            function AddWayPoint()
            {   
				RemoveMenu();
				tmpObj = new Object();
				tmpObj.id = _pinID;
				tmpObj.locationid = 0;
				tmpObj.lat = _latitude;
				tmpObj.lng = _longitude;
				tmpObj.title = "New Location " + _pinID;
				tmpObj.description = "Description for Location " + _pinID;
				if(_pinID == 1)
				{
				    tmpRoute = new Object();
				    tmpRoute.title = "My new Route";
				    tmpRoute.description = "My new Route description";
				}
				_pinID++;
				_mapPoints.push(tmpObj);	
				ManageRouteLoadMap(_latitude, _longitude, 4);					
			}
			
            function DeleteWayPoint()
            {  
				shape = msmap.GetShapeByID(_elementid);
				var pts = shape.GetPoints();
				var title = shape.GetTitle(); 
				var latitude = pts[0].Latitude; 
				var longitude = pts[0].Longitude; 
                for (i=0; i < _mapPoints.length; i++)
                {
					if (_mapPoints[i].lat == latitude && _mapPoints[i].lng == longitude && title == "<div class='pinTitle'>" + _mapPoints[i].title + "</div>")
					{
						_mapPoints.splice(i, 1);
						break;
					}
				}
				ManageRouteLoadMap(_latitude, _longitude, 4);					
			}
			function PrepMenu()
			{
				navRoot = document.getElementById("popupmenu");
				var items = navRoot.getElementsByTagName('li');
				for (i=0; i<items.length; i++)
				{
					node = items[i];
					if (node.nodeName=="LI")
					{
						node.onmouseover = function()
						{
							this.className+=" over"; //Show the submenu
						}
						node.onmouseout=function()
						{
							if (this.className.indexOf('pmenu') > 0)
							{
								this.className="pmenu";
							}
							else 
							{
								this.className = "";
							}
						}
					}
				}
			}
			function ManageRouteLoadMap(latitude, longitude, zoom)
			{
				_pinID = 1;
                var bounds = new Array();
				var routePoints = new Array();
                if (!_mapPoints)
                {
					_mapPoints = new Array();
                }
                if (!tmpRoute)
                {
					tmpRoute = new Object();
                }
                for (i=0; i < _mapPoints.length; i++)
                {
                    bounds[i] = new VELatLong(_mapPoints[i].lat, _mapPoints[i].lng);
					routePoints[i] = new VELatLong(_mapPoints[i].lat, _mapPoints[i].lng, 0, VEAltitudeMode. RelativeToGround);
                }
                if (!msmap)
                {
					msmap = new VEMap('myMap');
                }
				msmap.AttachEvent("onclick", ShowMenu);
				if (_mapPoints.length == 0)
				{
					latitude = 51.5144914891806;
					longitude = -0.229428112506878;
					zoom = 4;
                    bounds[0] = new VELatLong(51.5157934336253, -0.23869514465332);
                    bounds[1] = new VELatLong(51.5062316209586, -0.219211578369143);
				}
				var mapcenter = new VELatLong(latitude, longitude)
				msmap.LoadMap(mapcenter, zoom, 'h', false, VEMapMode.Mode2D, true);
                msmap.SetMapView(bounds);
				msmap.SetCenter(mapcenter);
                var pinShapes = new Array();
				if (_mapPoints.length > 0)
				{
					for (i=0; i < _mapPoints.length; i++)
					{			      
						ManageRouteAddPin(pinShapes, 
											_mapPoints[i].lat, 
											_mapPoints[i].lng, 
											_mapPoints[i].title,  
											_mapPoints[i].description);
					}  
					var myPinLayer = new VEShapeLayer();
         			msmap.AddShapeLayer(myPinLayer);
					myPinLayer.AddShape(pinShapes);
					if (_mapPoints.length > 1)
					{
						var myRouteLayer = new VEShapeLayer();
         				msmap.AddShapeLayer(myRouteLayer);
						var myRoute = new VEShape(VEShapeType.Polyline, routePoints);
						myRouteLayer.AddShape(myRoute);
						if (tmpRoute)
						{
						    if(tmpRoute.title)
						    {
						        myRoute.SetTitle(tmpRoute.title);
						        myRoute.SetDescription(tmpRoute.description);	
						    }
						}
						else
						{
							tmpRoute = new Object();
							tmpRoute.title = "My new Route";
							tmpRoute.description = "My new Route description";
					        myRoute.SetTitle(tmpRoute.title);
					        myRoute.SetDescription(tmpRoute.description);	
						}
					}
					//var shapeLayer = new VEShapeLayer();
					//var shapeSpec = new VEShapeSourceSpecification(VEDataType.ImportXML,"http://local.bbc.co.uk/RouteInfo/nationalparks.kml", shapeLayer);
					//msmap.ImportShapeLayerData(shapeSpec);
				}
				PrepMenu();
				DisplayTable();
			}	
			function DisplayTable()
			{
				table = document.getElementById("resultstable");
				var lastRow = table.rows.length;
				if (lastRow > 0)
				{
					for (i=lastRow; i > 0; i--)
					{
						table.deleteRow(i-1);
					}
					lastRow = table.rows.length;
				}
				row = table.insertRow(0);
				if (_mapPoints.length > 0)
				{					
					var header = row.insertCell(0);
					var textNode = document.createTextNode('Title');
					header.appendChild(textNode);
					header = row.insertCell(1);
					textNode = document.createTextNode('Description');
					header.appendChild(textNode);
					header = row.insertCell(2);
					textNode = document.createTextNode('Latitude');
					header.appendChild(textNode);
					header = row.insertCell(3);
					textNode = document.createTextNode('Longitude');
					header.appendChild(textNode);
					lastRow = table.rows.length;			
					for (i=0; i < _mapPoints.length; i++)
					{	
						row = table.insertRow(lastRow+i);
						var cellTitle = row.insertCell(0);
						var el = document.createElement('input');
						el.type = 'hidden';
						el.name = 'locationID';
						el.id = 'locationID';
						el.value = _mapPoints[i].locationid;
						cellTitle.appendChild(el);
						var el = document.createElement('input');
						el.type = 'hidden';
						el.name = 'order';
						el.id = 'order';
						el.value = i;
						cellTitle.appendChild(el);
						el = document.createElement('input');
						el.type = 'text';
						el.name = 'title';
						el.id = 'title';
						el.size = 20;
						el.value = _mapPoints[i].title;
						cellTitle.appendChild(el);
						var cellDescription = row.insertCell(1);
						el = document.createElement('input');
						el.type = 'text';
						el.name = 'description';
						el.id = 'description';
						el.size = 40;
						el.value = _mapPoints[i].description;
						cellDescription.appendChild(el);
						var cellLatitude = row.insertCell(2);
						textNode = document.createTextNode(_mapPoints[i].lat);
						cellLatitude.appendChild(textNode);
						el = document.createElement('input');
						el.type = 'hidden';
						el.name = 'latitude';
						el.id = 'latitude';
						el.value = _mapPoints[i].lat;
						cellLatitude.appendChild(el);
						var cellLongitude = row.insertCell(3);
						textNode = document.createTextNode(_mapPoints[i].lng);
						cellLongitude.appendChild(textNode);
						el = document.createElement('input');
						el.type = 'hidden';
						el.name = 'longitude';
						el.id = 'longitude';
						el.value = _mapPoints[i].lng;
						cellLongitude.appendChild(el);
					}
				}
				else
				{
					var noLocationsText = row.insertCell(0);
					var textNode = document.createTextNode('No locations for this route, please add them via the right mouse-click menu on the map.');
					noLocationsText.appendChild(textNode);
				}
			}	
			function validateOnSubmit()
			{
				var routeTitle = document.getElementById("routetitle");
				var routeDescription = document.getElementById("routedescription");
				if (routeTitle.value.length == 0)
				{
					alert("The Route Title must be filled in");
					routeTitle.focus(); // set the focus to this input
					return false;
				}
				if (routeDescription.value.length == 0)
				{
					alert("The Route Description must be filled in");
					routeDescription.focus(); // set the focus to this input
					return false;
				}					
				return true;
			}



