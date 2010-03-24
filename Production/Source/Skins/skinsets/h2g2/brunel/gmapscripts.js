// Google Maps scripts

      var map=null;
      var geocoder = null;
      function CreateMap()
      {
        if (map == null)
        {
          if (GBrowserIsCompatible())
          {
            map = new GMap2(document.getElementById('myMap'));
            map.addControl(new GSmallMapControl());
            map.addControl(new GMapTypeControl());
            map.enableDoubleClickZoom();
            map.enableContinuousZoom();
            map.setCenter(new GLatLng(51.747744186712666, -0.45522451400757635), 16, G_HYBRID_MAP); //'' LONGITUDE='' ZOOM='17'
            geocoder = new GClientGeocoder();
          }
        }
        if (map != null)
        {
          map.clearOverlays();
        }
        return (map != null);
      }
      
      function PositionMap(latitude, longitude, zoom)
      {
        if (CreateMap())
        {
            shiftMap();
            map.checkResize();
      			map.setCenter(new GLatLng(latitude,longitude),zoom);
        }
        
      }
      
      function PositionMapWithPin(latitude, longitude, zoom, title, description)
      {
          PositionMap(latitude, longitude, zoom);
          map.addOverlay(createMarker(new GLatLng(latitude, longitude), title, description));
      }

      
      function createMarker(point, title, description) 
      {  
          var marker = new GMarker(point);  
          GEvent.addListener(marker, "click", function() 
          {   
              marker.openInfoWindowHtml("<font class='postxt'><b>" + title + "</b><br />" + description + "</font>");  
          });
          return marker;
      }

      
      function FindLoc()
      {
        if (geocoder)
        {
          var address = document.getElementById('txtWhere').value;
          geocoder.getLatLng(
          address,
          function(point) 
          {
            if (!point) 
            {
              alert(address + " not found");
            } 
            else 
            {
              map.setCenter(point, 13);
              var marker = new GMarker(point);
              map.addOverlay(marker);
              marker.openInfoWindowHtml(address);
            }
          });
        }
      }
      
                function MakeMapLink(txtArea)
                {
                    var seltext = txtArea.value.substring(txtArea.selectionStart,txtArea.selectionEnd);
                    
                    var latlong = map.getCenter();
                    var mycode = "<MAP-LOCATION LATITUDE='" + latlong.lat() + "' LONGITUDE='" + latlong.lng() + "' ZOOM='" + map.getZoom() + "'>"
                    + seltext + "</MAP-LOCATION>";
                    insertAtCursor(txtArea, mycode);
                }
                


                //myField accepts an object reference, myValue accepts the text strint to add
                function insertAtCursor(myField, myValue) 
                {
                  //IE support
                  if (myField.selectionStart || myField.selectionStart == '0') 
                 {

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
                     alert('document.selection '+sel.text);
                   sel.text = myValue;
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
                  //alert('x: ' + x 
                  //    + ' y: ' + y 
                  //    + ' w:' + viewportwidth 
                  //    + 'h:' + viewportheight
                  //   + ' cw:' + mapdiv.clientWidth
                  //    + ' ch:' + mapdiv.clientHeight
                  //    );
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
                  if (map == null)
                  {
                      PositionMap(latitude,longitude,zoom);
                  }
                  else
                  {
                    shiftMap();
                  }
                  unhideMap();
               }
                
      function FullMap()
      {
        var bounds = GetEmptyBounds();
        for (i = 0; i < mapPoints.length; i++)
        {
          AddPointToBounds(bounds, mapPoints[i].lat, mapPoints[i].lng);
        }
        if (CreateMap())
        {
          map.setZoom(map.getBoundsZoomLevel(bounds));
          map.setCenter(bounds.getCenter());
        }
        
        for (i=0; i < mapPoints.length; i++)
        {
          map.addOverlay(createMarker(new GLatLng(mapPoints[i].lat, mapPoints[i].lng), mapPoints[i].description,''));
        }
        
      }
      
      function GetEmptyBounds()
      {
        return new GLatLngBounds();
      }
      
      function AddPointToBounds(bounds, lat, lng)
      {
        var pt = new GLatLng(lat,lng);
        bounds.extend(pt);
      }
                


