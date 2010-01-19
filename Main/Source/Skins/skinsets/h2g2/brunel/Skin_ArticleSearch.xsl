<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0" 
                xmlns:msxsl="urn:schemas-microsoft-com:xslt" 
                xmlns:local="#local-functions" 
                xmlns:s="urn:schemas-microsoft-com:xml-data" 
                xmlns:dt="urn:schemas-microsoft-com:datatypes">
	
<!-- Need the following doctype to get the map pushpin info boxes to display in the correct position -->
<xsl:output method="xml" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"
		 doctype-public="W3C//DTD XHTML 1.0 Transitional//EN"/>

	<xsl:template name="ARTICLESEARCH_SUBJECT">
		<font xsl:use-attribute-sets="headerfont">
			<xsl:attribute name="size">6</xsl:attribute>
			<b>	Article Search Page</b>
		</font> 
	</xsl:template>
	

	<xsl:template name="ARTICLESEARCH_MAINBODY">
		<xsl:choose>
			<xsl:when test="$use-maps=1">
				<xsl:apply-templates select="ARTICLESEARCH"/>
			</xsl:when>
			<xsl:otherwise>You do not have the required permissions for this page.</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="ARTICLESEARCH">
		<font xsl:use-attribute-sets="headerfont">
			<xsl:attribute name="size">4</xsl:attribute>
			Search for Entries associated with a particular place or postcode.
		</font>		
		<style type="text/css">
			.titleStyle
			{
				font-family:Verdana;
				font-size:12pt;
				font-weight:bold;
			}
			.iconStyle
			{
				position:relative;
				top:-15px;
			}
			.detailsStyle
			{
				font-family:Verdana;
				font-size:10pt;
				font-weight:normal;
				text-align:left;
				color:black;
			}
			label
			{
				width:100px;
				position:relative;
			}
			label input
			{
				position: absolute;
				right: 0px;
			}
			.pinTitle
			{
				color:black;
			}
			.pinDetails
			{
				color:black;
			}

		</style>

		<form id="ArticleSearchForm" name="ArticleSearchForm"  action="{$root}ArticleSearch">
			<input type="hidden" name="contenttype" value="-1"/>
			<input type="hidden" name="articlesortby" value="Range"/>
			<table>
				<tr>
					<td colspan="3">
						<input type="radio" name="locationsearchtype" value="latlon" checked="true">Latitude / Longitude</input>
						<input type="radio" name="locationsearchtype" value="postcode">Postcode</input>
						<input type="radio" name="locationsearchtype" value="placename">Place name</input>
					</td>
				</tr>
				<tr>
					<td>
						<label for="latitude">Latitude</label>
					</td>
					<td>
						<input type="text" name="latitude" id="latitude">
							<xsl:attribute name="value">
								<xsl:value-of select="@LATITUDE"/>
							</xsl:attribute>
						</input>
					</td>
					<td>
						<label for="longitude">Longitude</label>
					</td>
					<td>
						<input type="text" name="longitude" id="longitude">
							<xsl:attribute name="value">
								<xsl:value-of select="@LONGITUDE"/>
							</xsl:attribute>
						</input>
					</td>
				</tr>
				<tr>
					<td>
						<label for="postcode">Postcode</label>
					</td>
					<td>
						<input type="text" name="postcode" id="postcode">
							<xsl:attribute name="value">
								<xsl:value-of select="@POSTCODE"/>
							</xsl:attribute>
						</input>
					</td>
				</tr>
				<tr>
					<td>
						<label for="placename">Place Name</label>
					</td>
					<td>
						<input type="text" name="placename" id="placename">
							<xsl:attribute name="value">
								<xsl:value-of select="@PLACENAME"/>
							</xsl:attribute>
						</input>
					</td>
				</tr>
				<tr>
					<td>
						<label for="range">Range</label>
					</td>
					<td>
						<input type="text" name="range" id="range">
							<xsl:attribute name="value">
								<xsl:choose>
									<xsl:when test="@RANGE=0">
										<xsl:value-of select="30"/>
									</xsl:when>
									<xsl:when test="@RANGE!=0">
										<xsl:value-of select="@RANGE"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="30"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:attribute>
						</input>
					</td>
					<td>
						<input type="button" onclick="ArticleSearchPerformSearch();return false;" value="Search"/>
					</td>
				</tr>
			</table>
		</form>
		<br/>
		<div>
			<div id="myMap" style="position:relative; width:800px; height:500px;" />
		</div>
		<div>
			<div id="disambigResultDiv" style="position:relative; width:400px; top:40px;"></div>
		</div>
		<br/>
		<xsl:apply-templates select="." mode="previousnext"/>
		<xsl:apply-templates select="ARTICLES" mode="resultsset"/>
		<br/>
		<xsl:call-template name="MapScripts2"/>
		<xsl:call-template name="FullMap2"/>

		<br/>

	</xsl:template>

	<xsl:template match="ARTICLESEARCH" mode="previousnext">
		<div class="morepages">
			<xsl:if test="@SKIPTO &gt; 0">
				<a href="{$root}ArticleSearch?contenttype=-1&amp;latitude={@LATITUDE}&amp;longitude={@LONGITUDE}&amp;articlesortby=Range&amp;range={@RANGE}&amp;skip={number(@SKIPTO)-number(@SHOW)}&amp;show={@SHOW}&amp;locationsearchtype=latlon">&lt;&lt; Previous</a>
			</xsl:if>
			<xsl:if test="@SKIPTO + @SHOW &lt; @TOTAL">
				<a href="{$root}ArticleSearch?contenttype=-1&amp;latitude={@LATITUDE}&amp;longitude={@LONGITUDE}&amp;articlesortby=Range&amp;range={@RANGE}&amp;skip={number(@SKIPTO)+number(@SHOW)}&amp;show={@SHOW}&amp;locationsearchtype=latlon">Next &gt;&gt;</a>
			</xsl:if>
		</div>

	</xsl:template>

	<xsl:template match="ARTICLESEARCH/ARTICLES[not(ARTICLE)]" mode="resultsset">
		<p>None of our articles match your search.</p>
	</xsl:template>
	
	<xsl:template match="ARTICLESEARCH/ARTICLES[ARTICLE]" mode="resultsset">
		<table border="1">
			<xsl:apply-templates select="." mode="ArticleSearchList_TableHeader"/>
			<xsl:apply-templates select="ARTICLE" mode="ArticleSearchList_Rows"/>
		</table>
	</xsl:template>

	<xsl:template match="ARTICLESEARCH/ARTICLES" mode="ArticleSearchList_TableHeader">
		<!-- Columns for this table are outputted dynamically so choose headings carefully! -->
		<th>Title</th>
		<th>Subject</th>
		<th>Author</th>
		<xsl:choose>
			<xsl:when test="ARTICLE[ZEITGEIST]">
				<th>Zeitgeist</th>
			</xsl:when>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="ARTICLE[NUMBEROFPOSTS]">
				<th>Number Of Posts</th>
			</xsl:when>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="ARTICLE[LATITUDE]">
				<th>Location</th>
			</xsl:when>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="ARTICLE[DISTANCE]">
				<th>Distance</th>
			</xsl:when>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="ARTICLE" mode="SubjectHref">
		<xsl:param name="url" select="'A'" />
		<xsl:param name="target">_top</xsl:param>
		<xsl:element name="a">
			<xsl:attribute name="href">
				<xsl:value-of select="$root"/>
				<xsl:value-of select="$url"/>
				<xsl:value-of select="@H2G2ID"/>
			</xsl:attribute>
			<xsl:attribute name="target">
				<xsl:value-of select="$target"/>
			</xsl:attribute>
			<xsl:apply-templates select="SUBJECT" mode="nosubject"/>
		</xsl:element>
	</xsl:template>


	<xsl:template match="ARTICLE" mode="ArticleSearchList_Rows">
		<xsl:param name="url" select="'A'" />
		<xsl:param name="target">_top</xsl:param>
		<tr>
			<xsl:apply-templates select="LOCATIONTITLE"/>
			<td>
				<xsl:apply-templates select="." mode="SubjectHref">
					<xsl:with-param name="url" select="$url"/>
					<xsl:with-param name="target" select="$target"/>
				</xsl:apply-templates>
			</td>
			<td>
				<xsl:value-of select="EDITOR/USER/USERNAME"/>
			</td>
			<xsl:apply-templates select="ZEITGEIST"/>
			<xsl:apply-templates select="NUMBEROFPOSTS"/>
			<xsl:apply-templates select="LATITUDE" mode="location"/>
			<xsl:apply-templates select="DISTANCE"/>
		</tr>
	</xsl:template>

	<xsl:template match="ARTICLE/ZEITGEIST">
		<td>
			<xsl:value-of select="SCORE"/>
		</td>
	</xsl:template>
	
	<xsl:template match="ARTICLE/LOCATIONTITLE">
		<td>
			<xsl:value-of select="."/>
		</td>
	</xsl:template>

	<xsl:template match="ARTICLE/NUMBEROFPOSTS">
		<td>
			<xsl:value-of select="."/>
		</td>
	</xsl:template>

	<xsl:template match="LATITUDE" mode="location">
		<td>
			<a>
				<xsl:attribute name="href">
					ArticleSearch?contenttype=-1&amp;latitude=<xsl:value-of select="."/>&amp;longitude=<xsl:value-of select="following-sibling::LONGITUDE"/>&amp;articlesortby=Range&amp;range=<xsl:value-of select="/H2G2/ARTICLESEARCH/@RANGE"/>&amp;locationsearchtype=latlon
				</xsl:attribute>
				<xsl:value-of select="."/>, <xsl:value-of select="following-sibling::LONGITUDE"/>
			</a>

		</td>
	</xsl:template>

	<xsl:template match="DISTANCE">
		<td>
			<xsl:value-of select="."/>
		</td>
	</xsl:template>

	<xsl:template match="SUBJECT" mode="nosubject">
		<xsl:choose>
			<xsl:when test=".=''">
				No subject
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="."/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="FullMap2">
		<script type="text/javascript">
			<![CDATA[
      
      var mapPoints = new Array();
      var tmpObj;
        ]]><![CDATA[
        ]]>
			<xsl:for-each select="/H2G2/ARTICLESEARCH/ARTICLES/ARTICLE">
				<![CDATA[
        tmpObj = new Object();
        tmpObj.lat = ]]><xsl:value-of select="LATITUDE"/><![CDATA[;
        tmpObj.lng = ]]><xsl:value-of select="LONGITUDE"/><![CDATA[;
        tmpObj.articleid = "]]><xsl:value-of select="@H2G2ID"/><![CDATA[";
        tmpObj.title = "]]><xsl:value-of select="LOCATIONTITLE"/><![CDATA[";
        tmpObj.subject = "]]><xsl:value-of select="SUBJECT"/><![CDATA[";
        tmpObj.description = "]]><xsl:value-of select="LOCATIONDESCRIPTION"/><![CDATA[";
        ]]>
				<xsl:text>mapPoints[</xsl:text>
				<xsl:value-of select="position()-1"/>
				<xsl:text>] = tmpObj;
        </xsl:text>
			</xsl:for-each>
			<![CDATA[
      
      ]]>
		</script>
	</xsl:template>

	<xsl:template name="MapScripts2">
		<xsl:call-template name="VEscripts2"/>
	</xsl:template>

	<xsl:template name="VEscripts2">
		<script type="text/javascript" src="http://dev.virtualearth.net/mapcontrol/mapcontrol.ashx?v=6.1&amp;mkt=en-GB"/>
		<script>
			<![CDATA[
                var msmap;                  
                var pinID = 1;
                var _mouseX = 0;
                var _mouseY = 0;
                var _latitude = 0;
                var _longitude = 0;
                
            function ArticleSearchAddPin(pinShapes, latitude, longitude, title, articleid, subject, description)
            {   
				var HTMLDescription = description + "<br/><div class='pinAnchor'><a class='pos' href='/dna/h2g2/A" + articleid +"' target='_blank' style='color:gray:'>Click to go to " + subject + "</a></div>"
			
				var shape = new VEShape(VEShapeType.Pushpin, new VELatLong(latitude, longitude));
					shape.SetTitle("<div class='pinTitle'>" + title + "</div>");
					shape.SetDescription("<div class='pinDetails'>" + HTMLDescription + "</div>");
                    pinID++;
					//shape.SetCustomIcon("<div class='iconStyle'><img src='/dnaimages/mapping/pushpins/015.bmp'> </div>");
                    pinShapes.push(shape); 					
            }
			
			function ArticleSearchLoadMap(latitude, longitude, zoom)
			{    
                var bounds = new Array();
                for (i=0; i < mapPoints.length; i++)
                {
                  bounds[i] = new VELatLong(mapPoints[i].lat, mapPoints[i].lng);
                }
				//If we only have one point then make sure we don't zoom in too far so it looks silly
				if(mapPoints.length == 1)
				{
                  bounds[1] = new VELatLong(latitude, longitude);
				  zoom = 12;
				}
				
				if (!msmap)
                {
					msmap = new VEMap('myMap');
                }
				if (latitude == 0)
				{
					latitude = 51.5144914891806;
					longitude = -0.229428112506878;
					zoom = 4;
                    bounds[0] = new VELatLong(51.5157934336253, -0.23869514465332);
                    bounds[1] = new VELatLong(51.5062316209586, -0.219211578369143);
				}
				
				var mapcenter = new VELatLong(latitude, longitude)
				
				msmap.AttachEvent("ondoubleclick", ArticleSearchDoSearch);

				msmap.LoadMap(mapcenter, zoom, 'h', false, VEMapMode.Mode2D, true);
                msmap.SetMapView(bounds);
				msmap.SetCenter(mapcenter);
				
                var pinShapes = new Array();
				for (i=0; i < mapPoints.length; i++)
				{			      
					ArticleSearchAddPin(pinShapes, 
										mapPoints[i].lat, 
										mapPoints[i].lng, 
										mapPoints[i].title,  
										mapPoints[i].articleid, 
										mapPoints[i].subject,
										mapPoints[i].description);
				}                    
				var myPinLayer = new VEShapeLayer();
         		msmap.AddShapeLayer(myPinLayer);
				myPinLayer.AddShape(pinShapes);
				if(mapPoints.length == 1)
				{
					msmap.SetZoomLevel(zoom);
				}
			}
			                                         			
            function ArticleSearchDoSearch(e)         
            {
				var x = e.mapX;
				var y = e.mapY;
								
				var xmap = msmap.GetLeft();
				var ymap = msmap.GetTop();
							
				var scrollX, scrollY;

				if (document.all)
				{
					if (!document.documentElement.scrollLeft)
						scrollX = document.body.scrollLeft;
					else
						scrollX = document.documentElement.scrollLeft;
					   
					if (!document.documentElement.scrollTop)
						scrollY = document.body.scrollTop;
					else
						scrollY = document.documentElement.scrollTop;
				}   
				else
				{
					scrollX = window.pageXOffset;
					scrollY = window.pageYOffset;
				}
			
				pixel = new VEPixel(x + scrollX, y + scrollY);
				var LL = msmap.PixelToLatLong(pixel);
			
				input_box=confirm("Click OK to Search around this point - " +  LL.Latitude + "," + LL.Longitude);
				if (input_box==true)
				{ 
					// Redirect when OK is clicked
					window.location = "/dna/h2g2/brunel/ArticleSearch?contenttype=-1&latitude="+LL.Latitude+";&longitude="+ LL.Longitude +"&range="+document.getElementById('range').value + "&locationsearchtype=latlon&articlesortby=Range"
				}
				return true;
			}    
			
			function ArticleSearchFindResults(layer, resultsArray, places, hasMore, veErrorMessage)
			{
				if (places) 
				{
				
					if (places.length > 0)
					{
						document.ArticleSearchForm.locationsearchtype[0].checked = true;
						document.ArticleSearchForm.latitude.value = places[0].LatLong.Latitude;
						document.ArticleSearchForm.longitude.value = places[0].LatLong.Longitude;

						document.getElementById('latitude').value = places[0].LatLong.Latitude; 
						document.getElementById('longitude').value = places[0].LatLong.Longitude; 
						
						document.ArticleSearchForm.submit();
					}
					
					/*
					if (places.length > 1)
					{
						var results="More than one location was returned. Please select the location you were looking for:<br>";
						for (x=0; x<places.length; x++)
						{
							results += "<a href='/dna/h2g2/brunel/ArticleSearch?contenttype=-1&latitude=" + places[x].LatLong.Latitude + "&longitude=" + places[x].LatLong.Longitude + "&range=" + document.getElementById('range').value + "&locationsearchtype=latlon&articlesortby=Range" + "\");'>" + places[x].Name + "</a><br>";
						}
						alert(results);
						document.getElementById('disambigResultDiv').innerHTML=results;
					}
					else
					{
						document.ArticleSearchForm.locationsearchtype[0].checked = true;
						document.ArticleSearchForm.latitude.value = places[0].LatLong.Latitude;
						document.ArticleSearchForm.longitude.value = places[0].LatLong.Longitude;

						document.getElementById('latitude').value = places[0].LatLong.Latitude; 
						document.getElementById('longitude').value = places[0].LatLong.Longitude; 
						
						document.ArticleSearchForm.submit();
					}
					*/
				}
			}
			
            function ArticleSearchFindPostCodeLatLon(postcode)         
            {
				msmap.Find(null, postcode, null, null, 1, 10, false, false, false, false, ArticleSearchFindResults);
			}    
			
            function ArticleSearchFindPlacenameLatLon(placename)         
            {
				msmap.Find(null, placename, null, null, 1, 10, false, false, false, false, ArticleSearchFindResults);
			}    
						
            function ArticleSearchPerformSearch()         
            {	
				var locationsearchtypeval="";
				for (var i=0; i < document.ArticleSearchForm.locationsearchtype.length; i++)
				{
					if (document.ArticleSearchForm.locationsearchtype[i].checked)
					{
						locationsearchtypeval = document.ArticleSearchForm.locationsearchtype[i].value;
					}
				}
				
				if (locationsearchtypeval == 'postcode')
				{
					ArticleSearchFindPostCodeLatLon(document.getElementById('postcode').value);  
				}
				else if (locationsearchtypeval == 'placename')
				{
					ArticleSearchFindPlacenameLatLon(document.getElementById('placename').value); 
				}
				else
				{
					document.getElementById('ArticleSearchForm').submit();
				}					
			}                                    
]]>
		</script>
	</xsl:template>
</xsl:stylesheet>