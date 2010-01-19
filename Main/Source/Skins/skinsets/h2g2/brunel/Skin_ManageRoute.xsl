<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0" 
                xmlns:msxsl="urn:schemas-microsoft-com:xslt" 
                xmlns:local="#local-functions" 
                xmlns:s="urn:schemas-microsoft-com:xml-data" 
                xmlns:dt="urn:schemas-microsoft-com:datatypes">

	<xsl:template name="MANAGEROUTE_SUBJECT">
		<font xsl:use-attribute-sets="headerfont">
			<xsl:attribute name="size">6</xsl:attribute>
			<b>Manage Route Page</b>
		</font> 
	</xsl:template>
	
	<xsl:template name="MANAGEROUTE_MAINBODY">
		<xsl:choose>
			<xsl:when test="$use-maps=1">
				<xsl:apply-templates select="ROUTEPAGE"/>
			</xsl:when>
			<xsl:otherwise>You do not have the required permissions for this page.</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="ROUTEPAGE">
		<h2>
			Manage a Route
		</h2>
		
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


			ul, li{margin:0;padding:0;}

			ul.pmenu {
			position:absolute;
			margin: 0;
			padding: 1px;
			list-style: none;
			width: 150px; /* Width of Menu Items */
			border: 1px solid #ccc;
			background:gray;
			display:none;
			z-index:10;
			}

			ul.pmenu li {
			position: relative;
			}

			ul.pmenu li ul {
			position: absolute;
			left: 150px; /* Set 1px less than menu width */
			top: 0;
			display: none;
			z-index:10;
			}

			/* Styles for Menu Items */
			ul.pmenu li a {
			display: block;
			text-decoration: none;
			color: black;
			padding: 2px 5px 2px 20px;
			}

			ul.pmenu li a:hover {
			background:#335EA8;
			color:white;
			}

			ul.pmenu li a.parent {
			background:url('./dnaimages/drop_down_triangle.gif') no-repeat 140px 4px;
			}
			ul.pmenu li a.parent:hover {
			background:#335EA8 url('./dnaimages/drop_down_triangle_hover.gif') no-repeat 140px 4px;
			}

			/* IE \*/
			* html ul.pmenu li { float: left; height: 1%; }
			* html ul.pmenu li a { height: 1%; }
			* html ul.pmenu li ul {left:147px;}
			/* End */

			ul.pmenu li:hover ul, ul.pmenu li.over ul { display: block; } /* The magic */
			ul.pmenu li ul{left:150px;}

		</style>

		<form id="ManageRouteForm" name="ManageRouteForm" action="{$root}ManageRoute">	
			<label for="routeid">Route ID</label>
			<input type="text" name="routeid" id="routeid">
				<xsl:attribute name="value">
					<xsl:value-of select="ROUTE/@ROUTEID"/>
				</xsl:attribute>
			</input>
			<input type="submit" name="submit" id="submit" value="Retrieve Route"/>
		</form>
		<br/>
		<div>
			<div id="myMap" style="position:relative; width:800px; height:500px;" />
		</div>
		<br/>
		<xsl:call-template name="MapScripts3"/>
		<xsl:call-template name="FullMap3"/>
		<br/>
		<div id="ContextMenu">
			<ul id="popupmenu" class="pmenu">
				<li>
					<a href="#" onclick="AddWayPoint();RemoveMenu();">Add WayPoint</a>
				</li>
				<li>
					<a href="#" onclick="DeleteWayPoint();RemoveMenu();">Remove Waypoint</a>
				</li>
			</ul>
		</div>
		<br/>
		<xsl:call-template name="RouteLocationsForm"/>
		<br/>

	</xsl:template>
	
	<xsl:template name="RouteLocationsForm">
		<form method="post" id="UpdateManageRouteForm" name="UpdateManageRouteForm" onsubmit="return validateOnSubmit();" action="{$root}ManageRoute">
			<font xsl:use-attribute-sets="subheaderfont">
				<label for="routetitle">Route Title</label>
			</font>
			<input type="text" name="routetitle" id="routetitle" maxlength="255" size="50">
				<xsl:attribute name="value">
					<xsl:value-of select="/H2G2/ROUTEPAGE/ROUTE/ROUTETITLE"/>
				</xsl:attribute>
			</input>
			<br/>
			<font xsl:use-attribute-sets="subheaderfont">
				<label for="routedescription">Route Description</label>
			</font>
			<input type="text" name="routedescription" id="routedescription" maxlength="255" size="100">
				<xsl:attribute name="value">
					<xsl:value-of select="/H2G2/ROUTEPAGE/ROUTE/ROUTEDESCRIPTION"/>
				</xsl:attribute>
			</input>
			<br/>
			<font xsl:use-attribute-sets="mainfont">
				<label for="linkh2g2id">Describing Article ID</label>
			</font>
			<input type="text" name="linkh2g2id" id="linkh2g2id" size="10">
				<xsl:attribute name="value">
					<xsl:value-of select="/H2G2/ROUTEPAGE/ROUTE/DESCRIBINGARTICLEID"/>
				</xsl:attribute>
			</input>
			<br/>
			<br/>
			<input type="hidden" name="routeid">
				<xsl:attribute name="value">
					<xsl:value-of select="/H2G2/ROUTEPAGE/ROUTE/@ROUTEID"/>
				</xsl:attribute>
			</input>
			<table id="resultstable" border="1">
			</table>
			<xsl:choose>
				<xsl:when test="/H2G2/ROUTEPAGE/ROUTE/@ROUTEID!=0">
					<input type="submit" name="update" id="update" value="Update Route"/>
					<input type="hidden" name="action" value="update"/>
				</xsl:when>
				<xsl:otherwise>
					<input type="submit" name="create" id="create" value="Create Route"/>
					<input type="hidden" name="action" value="create"/>
				</xsl:otherwise>
			</xsl:choose>
		</form>
	</xsl:template>


	<xsl:template name="FullMap3">
		<script type="text/javascript">
			<xsl:if test="/H2G2/ROUTEPAGE/ROUTE/@ROUTEID!=0">
				<xsl:if test="/H2G2/ROUTEPAGE/ROUTE/LOCATIONS">
					<xsl:for-each select="/H2G2/ROUTEPAGE/ROUTE/LOCATIONS/LOCATION">
						<![CDATA[
						var tmpObj;
						tmpObj = new Object();
						tmpObj.locationid = ]]><xsl:value-of select="@LOCATIONID"/><![CDATA[;
						tmpObj.lat = ]]><xsl:value-of select="LATITUDE"/><![CDATA[;
						tmpObj.lng = ]]><xsl:value-of select="LONGITUDE"/><![CDATA[;
						tmpObj.title = "]]><xsl:value-of select="LOCATIONTITLE"/><![CDATA[";
						tmpObj.description = "]]><xsl:value-of select="LOCATIONDESCRIPTION"/><![CDATA[";
						]]>
						<xsl:text>_mapPoints[</xsl:text>
						<xsl:value-of select="position()-1"/>
						<xsl:text>] = tmpObj;</xsl:text>
					</xsl:for-each>
				</xsl:if>
			</xsl:if>
			<![CDATA[
      
      ]]>
		</script>
		<script type="text/javascript">
			<xsl:if test="/H2G2/ROUTEPAGE/ROUTE/@ROUTEID!=0">
				<xsl:if test="/H2G2/ROUTEPAGE/ROUTE/LOCATIONS">
					<![CDATA[
					tmpRoute.title = "]]><xsl:value-of select="/H2G2/ROUTEPAGE/ROUTE/ROUTETITLE"/><![CDATA[";
					tmpRoute.description = "]]><xsl:value-of select="/H2G2/ROUTEPAGE/ROUTE/ROUTEDESCRIPTION"/><![CDATA[";
				]]>
				</xsl:if>
			</xsl:if>
			<![CDATA[
			  ]]>
		</script>
	</xsl:template>

	<xsl:template name="MapScripts3">
		<xsl:call-template name="VEscripts3"/>
	</xsl:template>

	<xsl:template name="VEscripts3">
		<script type="text/javascript" src="http://dev.virtualearth.net/mapcontrol/mapcontrol.ashx?v=6.1&amp;mkt=en-GB"/>
	</xsl:template>

	<xsl:template name="test">
		<script type="text/javascript">
			<![CDATA[
			alert('test');
		  ]]>
		</script>
	</xsl:template>

</xsl:stylesheet>