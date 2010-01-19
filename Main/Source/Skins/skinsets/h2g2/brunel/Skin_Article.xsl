<?xml version='1.0' encoding='ISO-8859-1' ?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]><xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0" 
                xmlns:msxsl="urn:schemas-microsoft-com:xslt" 
                xmlns:local="#local-functions" 
                xmlns:s="urn:schemas-microsoft-com:xml-data" 
                xmlns:dt="urn:schemas-microsoft-com:datatypes">
	
	<!-- Need the following doctype to get the map pushpin info boxes to display in the correct position -->
	<xsl:output method="xml" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"
			 doctype-public="W3C//DTD XHTML 1.0 Transitional//EN"/>

	<!--IL start - this probably should be in the main -->
<xsl:attribute-set name="pageauthorsfont">
	<xsl:attribute name="class">norm</xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="mH2G2ID_RemoveSelf">
	<xsl:attribute name="class">pos</xsl:attribute>
</xsl:attribute-set>
<!--IL end-->

<xsl:template name="ARTICLE_TITLE">
	<title><xsl:value-of select="$m_pagetitlestart"/>
	<xsl:choose>
	<xsl:when test="/H2G2/ARTICLE/SUBJECT">
		<xsl:value-of select="/H2G2/ARTICLE/SUBJECT"/>
	</xsl:when>
	<xsl:otherwise>
	<xsl:copy-of select="$m_nosuchguideentry"/>
	</xsl:otherwise>
	</xsl:choose>
	</title>
</xsl:template>

<xsl:template name="ARTICLE_TITLEDATA">
	<xsl:if test="ARTICLE/ARTICLEINFO">
	<font xsl:use-attribute-sets="smallfont"><b><xsl:value-of select="$m_guideid"/></b> A<xsl:value-of select="ARTICLE/ARTICLEINFO/H2G2ID"/>
		<xsl:text> </xsl:text>
		<xsl:choose>
			<xsl:when test="ARTICLE/ARTICLEINFO/STATUS[@TYPE='1']"><xsl:value-of select="$m_edited" /></xsl:when>
			<xsl:when test="ARTICLE/ARTICLEINFO/STATUS[@TYPE='9']"><xsl:value-of select="$m_helppage" /></xsl:when>
			<xsl:when test="ARTICLE/ARTICLEINFO/STATUS[@TYPE='4']"><xsl:value-of select="$m_entrydatarecommendedstatus" /></xsl:when>
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</font>
	</xsl:if>
	<br clear="ALL" /><img src="{$imagesource}t.gif" width="1" height="8" alt="" /><br clear="ALL" />
</xsl:template>

<xsl:template name="ARTICLE_SUBJECT">
	<xsl:call-template name="SUBJECTHEADER">
		<xsl:with-param name="text">
			<xsl:choose>
				<xsl:when test="ARTICLE/ARTICLEINFO[HIDDEN='1']"><xsl:value-of select="$m_articlehiddentitle"/></xsl:when>
				<xsl:when test="ARTICLE/ARTICLEINFO[HIDDEN='2']"><xsl:value-of select="$m_articlereferredtitle"/>	</xsl:when>
				<xsl:when test="ARTICLE/ARTICLEINFO[HIDDEN='3']"><xsl:value-of select="$m_articleawaitingpremoderationtitle"/></xsl:when>
				<xsl:when test="ARTICLE/ARTICLEINFO[HIDDEN='4']"><xsl:value-of select="$m_legacyarticleawaitingmoderationtitle"/></xsl:when>
				<xsl:when test="/H2G2/ARTICLE/ARTICLEINFO/STATUS[@TYPE='7']"><xsl:value-of select="$m_articledeletedsubject"/></xsl:when>
				<xsl:when test="/H2G2/ARTICLE/ARTICLEINFO/STATUS[@TYPE='9']"><xsl:value-of select="$m_HelpPageStatusName"/></xsl:when>
				<xsl:when test="/H2G2/ARTICLE/ARTICLEINFO/STATUS[@TYPE='4']">Recommended Guide Entry</xsl:when>
				<xsl:when test="/H2G2/ARTICLE/ARTICLEINFO/STATUS[@TYPE='13']">Guide Entry Awaiting Approval</xsl:when>
				<xsl:when test="/H2G2/ARTICLE/ARTICLEINFO/STATUS[@TYPE='1']">Edited Guide Entry</xsl:when>
				<xsl:otherwise><xsl:value-of select="$m_article"/></xsl:otherwise>
			</xsl:choose>
		</xsl:with-param>
	</xsl:call-template>
</xsl:template>
<xsl:template match="CRUMBTRAILS" mode="articlepage">
	<!--xsl:choose>
		<xsl:when test="/H2G2/PARAMS/PARAM/NAME='s_category'">
			<xsl:apply-templates select="CRUMBTRAIL[.//NAME = /H2G2/PARAMS/PARAM[NAME='s_category']/VALUE]/ANCESTOR" mode="articlepage"/>
		</xsl:when>
		<xsl:otherwise>
			
		</xsl:otherwise>
	</xsl:choose-->
		<xsl:apply-templates select="CRUMBTRAIL" mode="articlepage">
			<xsl:sort select="ANCESTOR[2]/NAME"/>
			<xsl:sort select="ANCESTOR[3]/NAME"/>
			<xsl:sort select="ANCESTOR[4]/NAME"/>
			<xsl:sort select="ANCESTOR[5]/NAME"/>
			<xsl:sort select="ANCESTOR[6]/NAME"/>
			<!-- To be replaced by generic function that sorts with an unknown number of sort keys. -->
		</xsl:apply-templates>


</xsl:template>
<xsl:template match="CRUMBTRAIL" mode="articlepage">
	<img src="{$imagesource}t.gif" width="10" height="1" alt="" />
	<xsl:apply-templates select="ANCESTOR[position() &gt; 1]" mode="articlepage"/>
	<br/>
</xsl:template>
<xsl:template match="ANCESTOR" mode="articlepage">
	<font xsl:use-attribute-sets="textfont" size="1">
		<a href="C{NODEID}" class="pos">
			<xsl:value-of select="NAME"/>
		</a>
		<xsl:if test="not(position() = last())">
			<xsl:text> / </xsl:text>
		</xsl:if>
	</font>
</xsl:template>

<xsl:template name="ARTICLE_BAR">
	<xsl:call-template name="nuskin-homelinkbar">
		<xsl:with-param name="bardata">
			<table width="100%" cellspacing="0" cellpadding="0" border="0" bgcolor="#000000" class="postable">
				<tr>
					<td width="100%">	<img src="{$imagesource}t.gif" width="439" height="5" alt="" /></td>
					<td width="200"><img src="{$imagesource}t.gif" width="200" height="5" alt="" /></td>
				</tr>
				<xsl:if test="/H2G2/ARTICLE/ARTICLEINFO/CRUMBTRAILS/CRUMBTRAIL and /H2G2[@TYPE='ARTICLE']">
					<tr valign="top">
						<td align="left">
							
							<xsl:apply-templates select="/H2G2/ARTICLE/ARTICLEINFO/CRUMBTRAILS" mode="articlepage"/>
						</td>
						<td/>
					</tr>
				</xsl:if>
				<tr valign="top">
					<td align="left">
						<img src="{$imagesource}t.gif" width="1" height="5" alt="" /><br clear="all"/><img src="{$imagesource}t.gif" width="10" height="1" alt="" />
						
						<xsl:if test="/H2G2/ARTICLE/ARTICLEINFO">
						<font xsl:use-attribute-sets="textsmallfont"><xsl:value-of select="$m_created"/><xsl:apply-templates mode="CREATEDATE" select="/H2G2/ARTICLE/ARTICLEINFO/DATECREATED/DATE"/></font>
						</xsl:if>
					</td>
					<td><img src="{$imagesource}t.gif" height="35" alt="" /></td>
				</tr>
				<tr>
					<td align="left" valign="bottom" colspan="2">
						<img src="{$imagesource}t.gif" width="10" height="1" alt="" />
						<font xsl:use-attribute-sets="textheaderfont"><b>
						<xsl:choose>
						<xsl:when test="/H2G2/ARTICLE/ARTICLEINFO">
	<xsl:choose>
		<xsl:when test="/H2G2/ARTICLE/ARTICLEINFO[HIDDEN='1']">
		<xsl:value-of select="$m_articlehiddentitle"/>
		</xsl:when>
		<xsl:when test="/H2G2/ARTICLE/ARTICLEINFO[HIDDEN='2']">
		<xsl:value-of select="$m_articlereferredtitle"/>
		</xsl:when>
		<xsl:when test="/H2G2/ARTICLE/ARTICLEINFO[HIDDEN='3']">
		<xsl:value-of select="$m_articleawaitingpremoderationtitle"/>
		</xsl:when>
		<xsl:when test="/H2G2/ARTICLE/ARTICLEINFO[HIDDEN='4']">
		<xsl:value-of select="$m_legacyarticleawaitingmoderationtitle"/>
		</xsl:when>
		<xsl:when test="/H2G2/ARTICLE/ARTICLEINFO/STATUS[@TYPE='7']">
		<xsl:value-of select="$m_articledeletedsubject"/>
		</xsl:when>
		<xsl:when test="not(/H2G2/ARTICLE/SUBJECT)">
		<xsl:copy-of select="$m_nosuchguideentry"/>
		</xsl:when>
	<xsl:otherwise>
		<xsl:value-of select="/H2G2/ARTICLE/SUBJECT"/>
	</xsl:otherwise>
	</xsl:choose>
						</xsl:when>
						<xsl:otherwise>
							<xsl:copy-of select="$m_nosuchguideentry"/>
						</xsl:otherwise>
						</xsl:choose>
						</b></font>
					</td>
				</tr>
				<tr>
					<td colspan="2"><img src="{$imagesource}t.gif" width="1" height="5" alt="" /></td>
				</tr>
			</table>	
		</xsl:with-param>
	</xsl:call-template>
</xsl:template>

<xsl:template name="ARTICLE_MAINBODY">
	<table width="100%" cellspacing="0" cellpadding="10" border="0" bgcolor="#000000" class="postable">
		<tr>
			<td>
				<font xsl:use-attribute-sets="textfont" >
					<xsl:choose>
						<xsl:when test="/H2G2/ARTICLE/ARTICLEINFO[HIDDEN='1']">
							<xsl:call-template name="m_articlehiddentext" /><br/>
						</xsl:when>
						<xsl:when test="/H2G2/ARTICLE/ARTICLEINFO[HIDDEN='2']">
							<xsl:call-template name="m_articlereferredtext" />
						</xsl:when>
						<xsl:when test="/H2G2/ARTICLE/ARTICLEINFO[HIDDEN='3']">
							<xsl:call-template name="m_articleawaitingpremoderationtext" />
						</xsl:when>
						<xsl:when test="/H2G2/ARTICLE/ARTICLEINFO[HIDDEN='4']">
							<xsl:call-template name="m_legacyarticleawaitingmoderationtext" />
						</xsl:when>
						<xsl:when test="/H2G2/ARTICLE/ARTICLEINFO/STATUS[@TYPE='7']">
							<xsl:call-template name="m_articledeletedbody"/><br/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:if test="/H2G2/ARTICLE/GUIDE/INTRO">
								<xsl:apply-templates select="/H2G2/ARTICLE/GUIDE/INTRO" />
							</xsl:if>
							<xsl:apply-templates select="/H2G2/ARTICLE/GUIDE/BODY" />
							<xsl:if test=".//FOOTNOTE">
								<blockquote>
									<font xsl:use-attribute-sets="textsmallfont">
										<hr xsl:use-attribute-sets="nu_hr" />
										<xsl:apply-templates mode="display" select=".//FOOTNOTE"/>
									</font>
								</blockquote>
							</xsl:if>

							<xsl:if test="$use-maps=1">
								<xsl:if test="/H2G2/ARTICLE/MAP-LOCATIONS/MAP-LOCATION">					
									<br/>
									<!--<xsl:if test="/H2G2/ARTICLE/MAP-LOCATTIONS">-->
									<xsl:call-template name="MapScripts"/>
									<xsl:call-template name="FullMap"/>
									<xsl:call-template name="MapLocations"/>
									<input type="hidden" id="LocationXML" name="LocationXML" />
									<img src='/dnaimages/mapping/pushpins/015.bmp'/><a class="pos" href="#" onclick="FullMap3();return false;"><b>Click here to see map locations associated with this Entry</b></a>

									<br/>
									<lo>
									<xsl:for-each select="/H2G2/ARTICLE/MAP-LOCATIONS/MAP-LOCATION">
										<li>
										<a>
											<xsl:attribute name="class">
												pos
											</xsl:attribute>
											<xsl:attribute name="href">
												#
											</xsl:attribute>
											<xsl:attribute name="onclick">
												<xsl:text>javascript:RepositionMap(</xsl:text>
												<xsl:value-of select="LATITUDE"/>
												<xsl:text>,</xsl:text>
												<xsl:value-of select="LONGITUDE"/>
												<xsl:text>,12);return(false);</xsl:text>
											</xsl:attribute>
											<xsl:choose>
												<xsl:when test="string-length(./TITLE) &gt; 0">
													<xsl:value-of select="./TITLE"/>
												</xsl:when>
												<xsl:otherwise>Click to see location</xsl:otherwise>
											</xsl:choose>
										</a>
										</li>
									</xsl:for-each>
									</lo>	
									<br/>
									<div id="mapContainer" style="display:none;position:relative; width:728px; height:550px; left:7px; top: 7px;">
										<table id="findheaderbartable" style="background:#ccc;position:relative; width:728px; height:50px; left: 0px; top: 0px;">
											<tr>
												<td align="right">
													<font xsl:use-attribute-sets="mainfont" class="postxt">
														<a class="pos" href="#" onclick="hideMap();return false;">Hide Map</a>
													</font>
												</td>
											</tr>
										</table>
										<div id='myMap' style="position:relative; width:728px; height:499px; left: 0px; top: 0px;" ></div>
									</div>
									<div id="resultDiv" style="width:200;height:200;display:none;"/>							
								</xsl:if>
							</xsl:if>
						</xsl:otherwise>
					</xsl:choose>
					<br /><br />
				</font>
			</td>
		</tr>
	</table>
</xsl:template>

  <xsl:template name="FullMap">
    <script type="text/javascript">
      <![CDATA[
      
      var mapPoints = new Array();
      var tmpObj;
        ]]><![CDATA[
        ]]>
      <xsl:for-each select="/H2G2/ARTICLE/GUIDE//MAP-LOCATION">
        <![CDATA[
        tmpObj = new Object();
        tmpObj.lat = ]]><xsl:value-of select="@LATITUDE"/><![CDATA[;
        tmpObj.lng = ]]><xsl:value-of select="@LONGITUDE"/><![CDATA[;
        tmpObj.description = "]]><xsl:value-of select="."/><![CDATA[";
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

  <xsl:template name="MapLocations">
    <!--<div id="mapLocations" style="visibility:hidden">
	<xsl:copy-of select="/H2G2/ARTICLE/MAP-LOCATIONS"/>
	</div>-->
    <script type="text/javascript">
      <![CDATA[
  var mapPoints = new Array();
  var points = new Array();
  var tmpObj;
  function getPushpins()
  { 
    ]]>
      <xsl:for-each select="/H2G2/ARTICLE/MAP-LOCATIONS/MAP-LOCATION">
        <![CDATA[
      tmpObj = new Object();
      tmpObj.latlng = new VELatLong(]]><xsl:value-of select="LATITUDE"/><![CDATA[,]]><xsl:value-of select="LONGITUDE"/><![CDATA[);
      points[]]><xsl:value-of select="position()-1"/><![CDATA[] = tmpObj.latlng;
      tmpObj.description = "]]><xsl:value-of select="DESCRIPTION"/><![CDATA[";
      tmpObj.title = "]]><xsl:value-of select="TITLE"/><![CDATA[";
      mapPoints[]]><xsl:value-of select="position()-1"/><![CDATA[] = tmpObj;
      ]]>
      </xsl:for-each>
      <![CDATA[}]]>
    </script>
  </xsl:template>

  <xsl:template name="MapScripts">
    <xsl:choose>
      <xsl:when test="/H2G2/PARAMS/PARAM[NAME='s_map' and VALUE='google']">
        <xsl:call-template name="GoogleScripts"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="VEscripts"/>
      </xsl:otherwise>
    </xsl:choose>

  </xsl:template>

  <xsl:template name="GoogleScripts">
    <script src="http://maps.google.com/maps?file=api&amp;v=2&amp;key=ABQIAAAADlMxp9O63ZGHVuQVij6DKhR5mJxxp2o6KSE3CNjdEdZtxz6WkhSXrDT3iKvRMVgMIdFhY_628avGYQ"
  type="text/javascript"></script>
    <script type="text/javascript" src="/h2g2/skins/brunel/gmapscripts.js"></script>
  </xsl:template>
  
  <xsl:template name="VEscripts">
	<script type="text/javascript" src="http://dev.virtualearth.net/mapcontrol/mapcontrol.ashx?v=6.1&amp;mkt=en-GB"/>
    <script type="text/javascript" src="/h2g2/skins/brunel/vescripts.js"></script>
  </xsl:template>
  
  
  <xsl:template match="MAP-LOCATION">
          <xsl:value-of select="."/>&#160;
    <xsl:choose>
      <xsl:when test="@TITLE">
     <a class="pos" style="font-size:small;" href="#" onclick="PositionMapWithPin({@LATITUDE},{@LONGITUDE},{@ZOOM},'{@TITLE}','{@DESCRIPTION}');return false;">[map]</a>
       
      </xsl:when>
      <xsl:otherwise>
     <a class="pos" style="font-size:small;" href="#" onclick="PositionMap({@LATITUDE},{@LONGITUDE},{@ZOOM});return false;">[map]</a>
       
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

<xsl:template name="ARTICLE_SIDEBAR">
	<table width="200" cellspacing="0" cellpadding="0" border="0" bgcolor="#000000">
		<xsl:choose>
			<xsl:when test="/H2G2/PAGEUI/EDITPAGE/@VISIBLE = 1 or /H2G2/ARTICLE/ARTICLEINFO/SUBMITTABLE[@TYPE='YES'] or /H2G2/ARTICLE/ARTICLEINFO/RECOMMENDENTRY or /H2G2/VIEWING-USER/USER/GROUPS/GROUP/NAME='EDITOR' or $test_MayRemoveFromResearchers or $test_ShowEntrySubbedLink or (/H2G2/ARTICLE/GUIDE/ENTRYOFTHEMONTH and /H2G2/ARTICLE/ARTICLEINFO/STATUS[@TYPE=1])">
				<tr valign="top">
					<td width="1" rowspan="3" style="background:#000000"><img src="{$imagesource}t.gif" width="1" height="1" alt="" /></td>
					<td width="1" class="postable"><img src="{$imagesource}t.gif" width="1" height="1" alt="" /></td>
					<td width="197">
						<table width="197" cellspacing="5" cellpadding="0" border="0" class="postable" bgcolor="#000000">
              <xsl:apply-templates select="/H2G2/ARTICLE/GUIDE/ENTRYOFTHEMONTH"/>
              <xsl:if test="/H2G2/PAGEUI/EDITPAGE/@VISIBLE = 1">
								<tr>
									<td><font xsl:use-attribute-sets="mainfont"><img src="{$imagesource}arrowh_pos.gif" width="3" height="9" alt="" border="0" hspace="3" /><b>
										<a class="pos">
											<xsl:attribute name="href"><xsl:value-of select="$root"/><xsl:value-of select="$pageui_editpage"/></xsl:attribute>
											<xsl:value-of select="$m_editentrylinktext"/>
										</a>
									</b></font></td>
								</tr>
							</xsl:if>
							<xsl:if test="/H2G2/ARTICLE/ARTICLEINFO/SUBMITTABLE[@TYPE='YES'] or (/H2G2/ARTICLE/ARTICLEINFO/SUBMITTABLE[@TYPE='NO'] and /H2G2/VIEWING-USER/USER/GROUPS/GROUP/NAME='EDITOR')">
								<tr>
									<td><font xsl:use-attribute-sets="mainfont"><img src="{$imagesource}arrowh_pos.gif" width="3" height="9" alt="" border="0" hspace="3" /><b>
										<a class="pos">
											<xsl:attribute name="HREF"><xsl:value-of select="$root"/>SubmitReviewForum?action=submitrequest&amp;h2g2id=<xsl:value-of select="/H2G2/ARTICLE/ARTICLEINFO/H2G2ID"/></xsl:attribute>
											<xsl:call-template name="m_submitforreviewbutton"/>
										</a>
									</b></font></td>
								</tr>
							</xsl:if>
							<xsl:if test="not($ownerisviewer=1 and /H2G2/VIEWING-USER/USER/GROUPS/GROUP/NAME='SCOUTS')">
								<xsl:choose>
									<xsl:when test="/H2G2/ARTICLE/ARTICLEINFO/RECOMMENDENTRY">
										<xsl:apply-templates select="/H2G2/ARTICLE/ARTICLEINFO/RECOMMENDENTRY"/>
									</xsl:when>
									<xsl:when test="/H2G2/VIEWING-USER/USER/GROUPS/GROUP/NAME='EDITOR' and /H2G2/ARTICLE/ARTICLEINFO/STATUS/@TYPE=3">
										<tr>
											<td><font xsl:use-attribute-sets="mainfont"><img src="{$imagesource}arrowh_pos.gif" width="3" height="9" alt="" border="0" hspace="3" /><b>
												<xsl:call-template name="DISPLAY-RECOMMENDENTRY"/>
											</b></font></td>
										</tr>
									</xsl:when>
								</xsl:choose>
							</xsl:if>
							<xsl:if test="/H2G2/VIEWING-USER/USER/GROUPS/GROUP/NAME='EDITOR'">
								<tr>
									<td><font xsl:use-attribute-sets="mainfont"><img src="{$imagesource}arrowh_pos.gif" width="3" height="9" alt="" border="0" hspace="3" /><b>
										<a class="pos" href="{$root}EditCategory?activenode={H2G2ID}&amp;nodeid=0&amp;action=navigatearticle"><xsl:value-of select="$m_Categorise"/></a>
									</b></font></td>
								</tr>
							</xsl:if>
							<xsl:if test="$test_MayRemoveFromResearchers">
								<tr>
									<td><font xsl:use-attribute-sets="mainfont"><img src="{$imagesource}arrowh_pos.gif" width="3" height="9" alt="" border="0" hspace="3" /><b>
									<xsl:apply-templates select="/H2G2/ARTICLE/ARTICLEINFO/H2G2ID" mode="RemoveSelf"/>
									</b></font>
									</td>
								</tr>
							</xsl:if>
							<xsl:if test="$test_ShowEntrySubbedLink">
								<tr>
									<td><font xsl:use-attribute-sets="mainfont"><img src="{$imagesource}arrowh_pos.gif" width="3" height="9" alt="" border="0" hspace="3" /><b>
										<xsl:apply-templates select="/H2G2/PAGEUI/ENTRY-SUBBED/@VISIBLE" mode="RetToEditors">
										</xsl:apply-templates>
									</b></font>
									</td>
								</tr>
							</xsl:if>
							<tr>
								<td style="border-top:1px solid black">
									<font xsl:use-attribute-sets="mainfont" color="#800080">
										<img src="{$imagesource}arrowh_pos.gif" width="3" height="9" alt="" border="0" hspace="3" />
										<b>
											<a class="pos">
												<xsl:attribute name="HREF">
													<xsl:value-of select="$root"/>A<xsl:value-of select="/H2G2/ARTICLE/ARTICLEINFO/H2G2ID"/>&amp;clip=1
												</xsl:attribute>
												Clip/Bookmark this page
											</a>
										</b>
									</font>
								</td>
							</tr>
							<tr>
								<td style="border-top:1px solid black">
									<!-- Removed for now as it wasn't being updated when clipped due to the article caching
									<font xsl:use-attribute-sets="mainfont" color="#800080">
										<b>
											<xsl:choose>											
												<xsl:when test="not(/H2G2/ARTICLE/BOOKMARKCOUNT) or (/H2G2/ARTICLE[BOOKMARKCOUNT=0])">
													This article has not been bookmarked.
												</xsl:when>
												<xsl:when test="/H2G2/ARTICLE[BOOKMARKCOUNT=1]">
													This article has been bookmarked once.
												</xsl:when>
												<xsl:otherwise>
													This article has been bookmarked <xsl:value-of select="/H2G2/ARTICLE/BOOKMARKCOUNT"/> times.
												</xsl:otherwise>
											</xsl:choose>
										</b>
									</font>
									-->
								</td>
							</tr>
						</table>
					</td>
					<td width="1" rowspan="3" bgcolor="#333333" style="background:#CCCCCC"><img src="{$imagesource}t.gif" width="1" height="1" alt="" /></td>
				</tr>
				<tr>
					<td colspan="2"><img src="{$imagesource}t.gif" width="1" height="1" alt="" /></td>
				</tr>
			</xsl:when>
			<xsl:otherwise> 
			<tr valign="top">
					<td width="1" rowspan="2">
						<img src="{$imagesource}t.gif" width="1" height="1" alt="" />
					</td>
					<td width="1" style="background:#CCCCCC">
						<img src="{$imagesource}t.gif" width="1" height="1" alt="" />
					</td>
					<td width="197">
						<table width="197" cellspacing="5" cellpadding="0" border="0" class="postable" bgcolor="#000000">
							<tr>
								<td>
									<font xsl:use-attribute-sets="mainfont" color="#800080">
										<img src="{$imagesource}arrowh_pos.gif" width="3" height="9" alt="" border="0" hspace="3" />
										<b>
											<a class="pos">
												<xsl:attribute name="HREF">
													<xsl:value-of select="$root"/>A<xsl:value-of select="/H2G2/ARTICLE/ARTICLEINFO/H2G2ID"/>&amp;clip=1
												</xsl:attribute>
												Clip/Bookmark this page
											</a>
										</b>
									</font>
								</td>
							</tr>
							<tr>
								<td style="border-top:1px solid black">
									<font xsl:use-attribute-sets="mainfont" color="#800080">
										<b>
											<xsl:choose>
												<xsl:when test="not(/H2G2/ARTICLE/BOOKMARKCOUNT) or (/H2G2/ARTICLE[BOOKMARKCOUNT=0])">
													This article has not been bookmarked.
												</xsl:when>
												<xsl:when test="/H2G2/ARTICLE[BOOKMARKCOUNT=1]">
													This article has been bookmarked once.
												</xsl:when>
												<xsl:otherwise>
													This article has been bookmarked <xsl:value-of select="/H2G2/ARTICLE/BOOKMARKCOUNT"/> times.
												</xsl:otherwise>
											</xsl:choose>
										</b>
									</font>
								</td>
							</tr>
						</table>
					</td>
					<td width="1" rowspan="2" style="background:#CCCCCC">
						<img src="{$imagesource}t.gif" width="1" height="1" alt="" />
					</td>
				</tr>
			</xsl:otherwise>
		</xsl:choose> 
		<tr valign="top">
			<td bgcolor="#333333" style="background:#CCCCCC"><img src="{$imagesource}t.gif" width="1" height="260" alt="" /></td>
			<td><xsl:apply-templates select="ARTICLE/ARTICLEINFO"/></td>




		</tr>
	</table>
	<br /><br />

</xsl:template>

  <xsl:template match="ENTRYOFTHEMONTH">
    <xsl:if test="/H2G2/ARTICLE/ARTICLEINFO/STATUS[@TYPE=1]">
    <tr>
      <td align="center">
        <a href="EntryOfTheMonth"><img border="0" src="{$h2g2graphics}Edited-Entry-Month.jpg" alt="Edited Entry of the Month"/></a>
        <br />
        <font xsl:use-attribute-sets="mainfont" class="postxt">
          <xsl:value-of select="concat(@MONTH,' ',@YEAR)"/>
        </font>
      </td>
    </tr>
    </xsl:if>
  </xsl:template>

<xsl:template name="ARTICLE_MIDDLE">
	<table width="100%" cellspacing="0" cellpadding="0" border="0" style="margin:0px;">
		<tr valign="top">
			<xsl:call-template name="nuskin-dummynav"/>
			<td width="100%" bgcolor="#000000">
				<xsl:if test="/H2G2/ARTICLEFORUM">
					<table width="100%" cellspacing="0" cellpadding="0" border="0" bgcolor="#000000">
						<tr>
							<td><img src="{$imagesource}t.gif" width="1" height="1" alt="" /></td>
						</tr>
					</table>
					<table width="100%" cellspacing="0" cellpadding="6" border="0" bgcolor="#333333" style="background:#CCCCCC">
						<tr>
							<td>
								<font xsl:use-attribute-sets="smallfont" class="postxt">
									<b><xsl:value-of select="$m_entry_convtopics"/></b>
								</font>
								<br clear="all" />
								<img src="{$imagesource}t.gif" width="628" height="1" alt="" />
							</td>
						</tr>
					</table>
					<xsl:apply-templates select="/H2G2/ARTICLEFORUM/FORUMTHREADS" />
				</xsl:if>
				<xsl:if test="/H2G2/ARTICLE-MODERATION-FORM">
					<table width="100%" cellspacing="0" cellpadding="0" border="0" bgcolor="#000000">
						<tr>
							<td><img src="{$imagesource}t.gif" width="1" height="1" alt="" /></td>
						</tr>
					</table>
					<table width="100%" cellspacing="0" cellpadding="6" border="0" bgcolor="#333333" style="background:#CCCCCC">
						<tr>
							<td>
								<font xsl:use-attribute-sets="smallfont" class="postxt">
									<b><xsl:value-of select="$m_entry_moderate"/></b>
								</font>
								<br clear="all" />
								<img src="{$imagesource}t.gif" width="628" height="1" alt="" />
							</td>
						</tr>
					</table>
					<table width="100%" cellspacing="0" cellpadding="13" border="0">
						<tr>
							<td><xsl:apply-templates select="/H2G2/ARTICLE-MODERATION-FORM"/></td>
						</tr>
					</table>
				</xsl:if>
				<br /><br />
			</td>
		</tr>
	</table>
</xsl:template>

<xsl:template match="ARTICLEINFO/RECOMMENDENTRY">
	<xsl:if test="not(../HIDDEN)">
		<xsl:if test="/H2G2/VIEWING-USER/USER/GROUPS/GROUP/NAME='SCOUTS' or /H2G2/VIEWING-USER/USER/GROUPS/GROUP/NAME='EDITOR'">
			<tr>
				<td><font xsl:use-attribute-sets="mainfont"><img src="{$imagesource}arrowh_pos.gif" width="3" height="9" alt="" border="0" hspace="3" /><b>
					<xsl:call-template name="DISPLAY-RECOMMENDENTRY"/>
				</b></font></td>
			</tr>	
		</xsl:if>
	</xsl:if>
</xsl:template>

<xsl:template name="DISPLAY-RECOMMENDENTRY">
	<a class="pos">
		<xsl:attribute name="HREF">javascript:popupwindow('<xsl:value-of select="$root"/>RecommendEntry?h2g2ID=<xsl:value-of select="/H2G2/ARTICLE/ARTICLEINFO/H2G2ID"/>&amp;mode=POPUP','RecommendEntry','resizable=1,scrollbars=1,width=375,height=300');</xsl:attribute>
		<xsl:call-template name="m_recommendentrybutton"/>
	</a>
</xsl:template>

<xsl:template match="ARTICLEINFO">
	<table width="197" cellspacing="0" cellpadding="3" border="0" background="">
		<tr>
			<td colspan="3" bgcolor="#333333" style="background:#CCCCCC"><font xsl:use-attribute-sets="smallfont" class="postxt"><b><xsl:value-of select="$m_entry_data"/></b></font><br clear="all" /><img src="{$imagesource}t.gif" width="191" height="1" alt="" /></td>
		</tr>
		<tr>
			<td colspan="3"><img src="{$imagesource}t.gif" width="1" height="1" alt="" /></td>
		</tr>
		<xsl:apply-templates select="SUBMITTABLE" />
		<xsl:apply-templates select="PAGEAUTHOR" />
<!--IL start-->
		<xsl:if test="not(/H2G2/@TYPE='USERPAGE')">
			<xsl:call-template name="REFERENCES-SEPERATOR" />
		</xsl:if>
		<xsl:apply-templates select="REFERENCES"/>
			<xsl:apply-templates select="/H2G2/ARTICLE/GUIDE/CREDITS[../../ARTICLEINFO/STATUS/@TYPE=1]"/>
<!--IL end-->
	<tr>
		<td width="14"><img src="{$imagesource}t.gif" width="14" height="1" alt="" border="0" /></td>
		<td width="161"><img src="{$imagesource}t.gif" width="161" height="3" alt="" /></td>
		<td width="4"><img src="{$imagesource}t.gif" width="4" height="1" alt="" /></td>
	</tr>
	</table>
</xsl:template> 

<xsl:template match="USER">
	<xsl:element name="a">
		<xsl:attribute name="class">norm</xsl:attribute>
		<xsl:attribute name="href"><xsl:value-of select="$root"/>U<xsl:value-of select="USERID"/></xsl:attribute>
		<xsl:value-of select="USERNAME"/>
	</xsl:element>
</xsl:template>

<xsl:template match="PAGEAUTHOR">
	<xsl:if test="RESEARCHERS/USER">
		<tr valign="top">
			<td rowspan="2"><img src="{$imagesource}bullet_fake_white.gif" width="14" height="14" alt="" border="0" /></td>
			<td>
				<font xsl:use-attribute-sets="smallfont">
					<b>Written and Researched by:</b><br /><br />
					<xsl:for-each select="RESEARCHERS/USER">
						<xsl:if test="USERID!=../../EDITOR/USER/USERID">
							<xsl:apply-templates select="."/><br />
						</xsl:if>
					</xsl:for-each>
					<br />
				</font>
			</td>
			<td width="4" rowspan="2"><img src="{$imagesource}t.gif" width="4" height="1" alt="" /></td>
		</tr>
		<tr><td background="{$imagesource}dotted_line_inv.jpg"><img src="{$imagesource}t.gif" width="1" height="3" alt="" /></td></tr>
	</xsl:if>
	<tr valign="top">
		<td><img src="{$imagesource}bullet_fake_white.gif" width="14" height="14" alt="" border="0" /></td>
		<td>
			<font xsl:use-attribute-sets="smallfont">
				<b>Edited by:</b><br /><br />
				<xsl:apply-templates select="EDITOR/USER" mode="ArticleInfo"/>
				<br /><br />
			</font>
		</td>
		<td><img src="{$imagesource}t.gif" width="4" height="1" alt="" /></td>
	</tr>
</xsl:template>

<xsl:template match="ARTICLEINFO/SUBMITTABLE">
	<xsl:if test="not(../HIDDEN) and /H2G2/VIEWING-USER/USER and not(@TYPE='YES')">
		<tr valign="top">
			<td width="14" rowspan="2"><img src="{$imagesource}bullet_fake_white.gif" width="14" height="14" alt="" border="0" /></td>
			<td width="161">
				<font xsl:use-attribute-sets="smallfont">
					<xsl:choose>
						<xsl:when test="@TYPE='IN'">
							<b><xsl:call-template name="m_currentlyinreviewforum"/></b><br /><br />
							<a class="norm">
								<xsl:attribute name="HREF"><xsl:value-of select="$root"/>F<xsl:value-of select="FORUM/@ID"/>?thread=<xsl:value-of select="THREAD/@ID"/></xsl:attribute>
								<xsl:call-template name="m_submittedtoreviewforumbutton"/>
							</a>
						</xsl:when>
						<xsl:otherwise>
							<b><xsl:call-template name="m_notforreviewbutton"/></b>
						</xsl:otherwise>
					</xsl:choose>
					<br /><br />
				</font>
			</td>
			<td width="4" rowspan="2"><img src="{$imagesource}t.gif" width="4" height="1" alt="" /></td>
		</tr>
		<tr>
			<td background="{$imagesource}dotted_line_inv.jpg"><img src="{$imagesource}t.gif" width="1" height="3" alt="" /></td>
		</tr>
	</xsl:if>
</xsl:template>

<!--IL start
<xsl:template match="REFERENCES" mode="articleinfo">
	<xsl:if test="not(/H2G2/@TYPE='USERPAGE')">
		<xsl:call-template name="REFERENCES-SEPERATOR" />
	</xsl:if>
	<xsl:apply-templates select="ENTRIES" />
	<xsl:if test="/H2G2/ARTICLE/ARTICLEINFO/REFERENCES/ENTRIES and (/H2G2/ARTICLE/ARTICLEINFO/REFERENCES/USERS or /H2G2/ARTICLE/ARTICLEINFO/REFERENCES/EXTERNAL)">
		<xsl:call-template name="REFERENCES-SEPERATOR" />
	</xsl:if>
	<xsl:apply-templates select="USERS" />
	<xsl:if test="/H2G2/ARTICLE/ARTICLEINFO/REFERENCES/USERS and /H2G2/ARTICLE/ARTICLEINFO/REFERENCES/EXTERNAL">
		<xsl:call-template name="REFERENCES-SEPERATOR" />
	</xsl:if>
	<xsl:apply-templates select="EXTERNAL"/>
</xsl:template>
IL end-->


<xsl:template name="REFERENCES-SEPERATOR">
	<tr>
		<td><img src="{$imagesource}t.gif" width="14" height="1" alt="" border="0" /></td>
		<td background="{$imagesource}dotted_line_inv.jpg"><img src="{$imagesource}t.gif" width="1" height="3" alt="" /></td>
		<td><img src="{$imagesource}t.gif" width="4" height="1" alt="" /></td>
	</tr>
</xsl:template>

<xsl:template match="CREDITS[/H2G2/ARTICLE/ARTICLEINFO/STATUS/@TYPE=1]">
	<tr valign="top">
		<td><img src="{$imagesource}bullet_fake_white.gif" width="14" height="14" alt="" border="0" /></td>
		<td>
			<font xsl:use-attribute-sets="smallfont">
				<b>
					<xsl:value-of select="@TITLE"/>
				</b>
				<br />
				<br />
<!--IL start-->
				<table width="100%" cellspacing="0" cellpadding="0" border="0">
					<xsl:for-each select="LINK">
						<tr>
							<td align="left" valign="top">
								<font xsl:use-attribute-sets="smallfont">
									<xsl:apply-templates select="." />
									<br/>
								</font>
								<img src="{$imagesource}t.gif" width="1" height="3" alt="" />
							</td>
						</tr>

					</xsl:for-each>
				</table>
				<br/>
<!--IL end-->
			</font>
		</td>
		<td><img src="{$imagesource}t.gif" width="4" height="1" alt="" /></td>
	</tr>
<!--IL start-->
	<xsl:call-template name="REFERENCES-SEPERATOR" />


</xsl:template>

<xsl:template match="REFERENCES/ENTRIES">
	<tr valign="top">
		<td><img src="{$imagesource}bullet_fake_white.gif" width="14" height="14" alt="" border="0" /></td>
		<td>
			<font xsl:use-attribute-sets="smallfont">
				<b><xsl:value-of select="$m_entry_referenced"/></b><br /><br />
<!--IL start-->
				<table width="100%" cellspacing="0" cellpadding="0" border="0"><xsl:apply-templates select="ENTRYLINK"/></table>
				<BR/>
<!--IL end-->
			</font>
		</td>
		<td><img src="{$imagesource}t.gif" width="4" height="1" alt="" /></td>
	</tr>
<!--IL start-->
	<xsl:call-template name="REFERENCES-SEPERATOR" />
<!--IL end-->
</xsl:template>


<!--IL start-->
<xsl:template match="REFERENCES/ENTRIES/ENTRYLINK" mode="UI">
	<tr><td align="left" valign="top"><font xsl:use-attribute-sets="smallfont"><xsl:apply-templates select="." mode="JustLink" /><BR/></font><img src="{$imagesource}t.gif" width="1" height="3" alt="" /></td></tr>
</xsl:template>

<xsl:template match="REFERENCES/USERS/USERLINK" mode="UI">
	<tr><td align="left" valign="top"><font xsl:use-attribute-sets="smallfont"><xsl:apply-templates select="." mode="JustLink" /><BR/></font><img src="{$imagesource}t.gif" width="1" height="3" alt="" /></td></tr>
</xsl:template>
<!--IL end-->

<xsl:template match="REFERENCES/USERS">
	<tr valign="top">
		<td><img src="{$imagesource}bullet_fake_white.gif" width="14" height="14" alt="" border="0" /></td>
		<td>
			<font xsl:use-attribute-sets="smallfont">
				<b><xsl:value-of select="$m_entry_referencedusers"/></b><br /><br />
<!--IL start-->
				<table width="100%" cellspacing="0" cellpadding="0" border="0"><xsl:apply-templates select="USERLINK"/></table>
				<BR/>
<!--IL end-->
			</font>
		</td>
		<td><img src="{$imagesource}t.gif" width="4" height="1" alt="" /></td>
	</tr>
<!--IL start-->
		<xsl:call-template name="REFERENCES-SEPERATOR" />
<!--IL end-->
</xsl:template>

<xsl:template match="REFERENCES/EXTERNAL" mode="BBCSites">
	<tr valign="top">
		<td><img src="{$imagesource}bullet_fake_white.gif" width="14" height="14" alt="" border="0" /></td>
		<td>
			<font xsl:use-attribute-sets="smallfont">
				<b><xsl:value-of select="$m_otherbbcsites"/>:</b><br /><br />
<!--IL start-->
				<table width="100%" cellspacing="0" cellpadding="0" border="0"><xsl:call-template name="ExLinksBBCSites"/></table>
				<BR/>
<!--IL end-->
			</font>
		</td>
		<td><img src="{$imagesource}t.gif" width="4" height="1" alt="" /></td>
	</tr>
<!--IL start-->
	<xsl:call-template name="REFERENCES-SEPERATOR" />
<!--IL end-->
</xsl:template>

	<xsl:template match="REFERENCES/EXTERNAL/EXTERNALLINK" mode="BBCSitesUI">
		<tr><td align="left" valign="top"><font xsl:use-attribute-sets="smallfont"><xsl:apply-templates select="." mode="justlink"/><BR/></font><img src="{$imagesource}t.gif" width="1" height="3" alt="" /></td></tr>
	</xsl:template>

	<xsl:template match="REFERENCES/EXTERNAL/EXTERNALLINK" mode="NONBBCSitesUI">
		<tr><td align="left" valign="top"><font xsl:use-attribute-sets="smallfont"><xsl:apply-templates select="." mode="justlink"/><br/></font><img src="{$imagesource}t.gif" width="1" height="3" alt="" /></td></tr>
	</xsl:template>

<xsl:template match="REFERENCES/EXTERNAL" mode="NONBBCSites">
	<tr valign="top">
		<td><img src="{$imagesource}bullet_fake_white.gif" width="14" height="14" alt="" border="0" /></td>
		<td>
			<font xsl:use-attribute-sets="smallfont">
				<b><xsl:value-of select="$m_refsites"/>:</b><br /><br />
<!--IL start-->
				<table width="100%" cellspacing="0" cellpadding="0" border="0"><xsl:call-template name="ExLinksNONBBCSites"/></table>
<!--IL end-->
				<br />
				<xsl:value-of select="$m_referencedsitesdisclaimer"/>
				<BR/>
			</font>
		</td>
		<td><img src="{$imagesource}t.gif" width="4" height="1" alt="" /></td>
	</tr>
<!--IL start-->
	<xsl:call-template name="REFERENCES-SEPERATOR" />
<!--IL end-->
</xsl:template>

<xsl:template match="EXTERNALLINK" mode="justlink">
	<xsl:element name="a">
		<xsl:if test="starts-with(OFFSITE,'http://')">
			<xsl:attribute name="TARGET">_blank</xsl:attribute>
		</xsl:if>
		<xsl:attribute name="class">norm</xsl:attribute>
		<xsl:attribute name="href"><xsl:apply-templates select="OFFSITE" mode="applyroot"/></xsl:attribute>
		<xsl:value-of select="substring(TITLE,1,25)"/>
		<xsl:if test="string-length(TITLE) &gt; 25">...</xsl:if>
	</xsl:element>
</xsl:template>

<xsl:template match="ARTICLE-MODERATION-FORM">
	<script language="JavaScript">
		<![CDATA[
		<!-- 
			function checkArticleModerationForm() {
				if (ArticleModerationForm.Decision.selectedIndex == 1 && ArticleModerationForm.EmailType.selectedIndex == 0) {
					alert('You must select a reason when failing content');
					return false;
				}
				else if (ArticleModerationForm.EmailType.options[ArticleModerationForm.EmailType.selectedIndex].value == 'Custom' && ArticleModerationForm.CustomEmailText.value == '') {
					alert('You must specify the content for a custom email.');
					return false;
				}
				else return true;
			}
		// stop hiding -->
		]]>
	</script>
	<xsl:if test="/H2G2/ARTICLE/ERROR[@TYPE='XML-PARSE-ERROR']">
		<font xsl:use-attribute-sets="mainfont" color="#ff6666">
			<b><xsl:value-of select="$m_entry_errorinarticle"/></b><br/><xsl:value-of select="$m_entry_errorinarticlefail"/>
		</font>
	</xsl:if>
	<xsl:if test="ERROR">
		<font xsl:use-attribute-sets="mainfont" color="#ff6666">
			<xsl:for-each select="ERROR">
				<b><xsl:value-of select="."/></b>
			</xsl:for-each>
			<br/>
		</font>
	</xsl:if>
	<xsl:if test="MESSAGE">
		<font xsl:use-attribute-sets="mainfont">
			<xsl:choose>
				<xsl:when test="MESSAGE/@TYPE = 'NONE-LOCKED'">
					<b><xsl:value-of select="$m_entry_errornotypealloc"/></b><br/>
				</xsl:when>
				<xsl:when test="MESSAGE/@TYPE = 'EMPTY-QUEUE'">
					<b><xsl:value-of select="$m_entry_errornotypeawait"/></b><br/>
				</xsl:when>
				<xsl:when test="MESSAGE/@TYPE = 'NO-ARTICLE'">
					<b><xsl:value-of select="$m_entry_errornotypeallocreq"/></b><br/>
				</xsl:when>
				<xsl:otherwise>
					<b><xsl:value-of select="MESSAGE"/></b><br/>
				</xsl:otherwise>
			</xsl:choose>
		</font>
	</xsl:if>
	<!-- if the article has extra information in it then display it -->
		<xsl:if test="/H2G2/ARTICLE/GUIDE/*[not(self::BODY)]">
			<br/>
			<table bgColor="lightblue">
				<tr>
					<td>
						<b>Other information</b>
					</td>
				</tr>
				<xsl:for-each select="/H2G2/ARTICLE/GUIDE/*[not(self::BODY)]">
				<tr>
					<td>
						<xsl:choose>
							<xsl:when test="substring(.,1,7) = 'http://'"><a href="{.}"><xsl:value-of select="."/></a></xsl:when>
							<xsl:otherwise><xsl:value-of select="."/></xsl:otherwise>
						</xsl:choose>
						
					</td>
				</tr>
				</xsl:for-each>
			</table>
		</xsl:if>
	<form action="{$root}ModerateArticle" method="POST" name="ArticleModerationForm" onSubmit="return checkArticleModerationForm()">
		<input type="hidden" name="h2g2ID"><xsl:attribute name="value"><xsl:value-of select="ARTICLE/H2G2-ID"/></xsl:attribute></input>
		<input type="hidden" name="ModID"><xsl:attribute name="value"><xsl:value-of select="ARTICLE/MODERATION-ID"/></xsl:attribute></input>
		<input type="hidden" name="SiteID" value="{../ARTICLE/ARTICLEINFO/SITEID}"/>
			<font xsl:use-attribute-sets="mainfont">
				<table width="100%">
					<tr>
						<td>
							<font xsl:use-attribute-sets="mainfont">
								<xsl:if test="@REFERRALS = 1"><xsl:value-of select="$m_entry_referredby"/>
									<xsl:choose>
										<xsl:when test="number(ARTICLE/REFERRED-BY/USER/USERID) > 0">
											<xsl:apply-templates select="ARTICLE/REFERRED-BY/USER"/>
										</xsl:when>
										<xsl:otherwise>
											<font color="#ff6666"><xsl:value-of select="$m_entry_autoreferral"/></font>
										</xsl:otherwise>
									</xsl:choose>
									<br/>
								</xsl:if>
							</font>
						</td>
						<td align="right">
							<font xsl:use-attribute-sets="mainfont">
								<a class="norm" target="ArticleModerationHistoryWindow" href="{$root}ModerationHistory?h2g2ID={ARTICLE/H2G2-ID}"><xsl:value-of select="$m_entry_showhistory"/></a>
							</font>
						</td>
					</tr>
					<tr>
						<td colspan="2">
							<font xsl:use-attribute-sets="mainfont">
								<xsl:if test="@TYPE='COMPLAINTS'">
									<input type="hidden" name="ComplainantID" value="{ARTICLE/COMPLAINANT-ID}"/>
									<input type="hidden" name="CorrespondenceEmail" value="{ARTICLE/CORRESPONDENCE-EMAIL}"/><xsl:value-of select="$m_entry_complaintfrom"/>
									<xsl:choose>
										<xsl:when test="string-length(ARTICLE/CORRESPONDENCE-EMAIL) > 0"><a class="norm" href="mailto:{ARTICLE/CORRESPONDENCE-EMAIL}"><xsl:value-of select="ARTICLE/CORRESPONDENCE-EMAIL"/></a></xsl:when>
										<xsl:when test="number(ARTICLE/COMPLAINANT-ID) > 0"><xsl:value-of select="$m_entry_researcher"/><a class="norm" href="{$root}U{ARTICLE/COMPLAINANT-ID}">U<xsl:value-of select="ARTICLE/COMPLAINANT-ID"/></a></xsl:when>
										<xsl:otherwise><xsl:value-of select="$m_entry_anoncomplaint"/></xsl:otherwise>
									</xsl:choose>
									<br/>
									<textarea name="ComplaintText" cols="60" rows="10" wrap="virtual"><xsl:value-of select="ARTICLE/COMPLAINT-TEXT"/></textarea>
									<br/>
								</xsl:if>
							</font>
						</td>
					</tr>
				</table>
			<xsl:value-of select="$m_entry_notes"/><br/>
			<textarea cols="60" name="notes" rows="10" wrap="virtual"><xsl:value-of select="ARTICLE/NOTES"/></textarea><br/>
			<input type="hidden" name="Referrals">
				<xsl:attribute name="value"><xsl:value-of select="@REFERRALS"/></xsl:attribute>
			</input>
			<input type="hidden" name="Show">
				<xsl:attribute name="value"><xsl:value-of select="@TYPE"/></xsl:attribute>
			</input>
			<select name="Decision">
				<option value="3" selected="selected">Pass</option>
				<option value="4">Fail</option>
				<option value="2">Refer</option>
				<xsl:if test="/H2G2/VIEWING-USER/USER/GROUPS/GROUP/NAME='EDITOR' and @REFERRALS = 1">
					<option value="5">Unrefer</option>
				</xsl:if>
			</select>
			<xsl:text> </xsl:text>
			<select name="ReferTo" onChange="javascript:if (selectedIndex != 0) Decision.selectedIndex = 2">
				<option value="0" selected="selected">Refer to:</option>
				<option value="0" >Anyone</option>
				<xsl:for-each select="REFEREE-LIST/REFEREE/USER">
					<option value="{USERID}"><xsl:value-of select="USERNAME"/></option>
				</xsl:for-each>
			</select>
			<xsl:text> </xsl:text>
			<select name="EmailType" onChange="javascript:if (selectedIndex != 0) ArticleModerationForm.Decision.selectedIndex = 1" title="Select a reason if you are failing this content">
				<xsl:call-template name="m_ModerationFailureMenuItems"/>
			</select>
			<br/><br/>
			<input type="submit" name="Next" value="Process" title="Process this Entry and then fetch the next one"/>
			<xsl:text> </xsl:text>
			<input type="submit" name="Done" value="Process &amp; Exit" title="Process this Entry and then exit"/><br/><br/>
			<a class="norm" href="{$root}Moderate"><xsl:value-of select="$m_entry_modhome"/></a><br/>
			<xsl:choose>
				<xsl:when test="/H2G2/VIEWING-USER/USER/GROUPS/GROUP/NAME='EDITOR'">
					<br/><xsl:value-of select="$m_entry_textcustomemail"/><br/>
				</xsl:when>
				<xsl:otherwise>
					<br/><xsl:value-of select="$m_entry_brokenurllist"/>.<br/>
				</xsl:otherwise>
			</xsl:choose>
			<textarea cols="60" name="CustomEmailText" rows="10" wrap="virtual"></textarea><br/>
		</font>
	</form>
</xsl:template>

<xsl:template match="FORUMTHREADS">
	<table width="100%" cellspacing="0" cellpadding="6" border="0">
		<tr>
			<td>
				<table width="100%" cellspacing="0" cellpadding="0" border="0">
					<xsl:choose>
						<xsl:when test="THREAD">
							<xsl:if test="not(/H2G2[@TYPE='USERPAGE'] or /H2G2[@TYPE='THREADS'])">
								<tr>
									<td colspan="3" bgcolor="#000000">
										<img src="{$imagesource}t.gif" width="1" height="5" alt="" /><br clear="all" />
										<img src="{$imagesource}t.gif" width="1" height="1" alt="" />
										<font xsl:use-attribute-sets="mainfont">
											<b>
												<xsl:apply-templates select="@FORUMID" mode="AddThread">
													<xsl:with-param name="img">
														<img src="{$imagesource}arrowh.gif" width="3" height="9" alt="" border="0" hspace="" /><img src="{$imagesource}t.gif" width="3" height="9" border="0" alt="" /><xsl:value-of select="$m_entry_discuss"/>
													</xsl:with-param>
												</xsl:apply-templates>
											</b>
										</font>
										<br clear="all" /><img src="{$imagesource}t.gif" width="1" height="8" alt="" /><br clear="all" />
									</td>
								</tr>	
								<tr>
									<td colspan="3" bgcolor="#000000">
										<font xsl:use-attribute-sets="smallfont"><xsl:value-of select="$m_peopletalking"/></font>
									</td>
								</tr>
								<tr>
									<td colspan="3" background="{$imagesource}dotted_line_inv.jpg">
										<img src="{$imagesource}t.gif" width="10" height="9" alt="" />
									</td>
								</tr>
							</xsl:if>
							<xsl:if test="/H2G2[@TYPE='THREADS']">
								<tr>
									<td colspan="3" bgcolor="#000000">
										<table width="100%" cellspacing="0" cellpadding="0" border="0">
										<tr valign="top">
											<td width="150">
												<font xsl:use-attribute-sets="nullsmallfont">
													<xsl:call-template name="threadnavbuttons">
														<xsl:with-param name="URL">F</xsl:with-param>
													</xsl:call-template>
													<font color="#ffffff"><xsl:value-of select="$skipdivider"/></font>
													<br clear="all" /><img src="{$imagesource}t.gif" width="150" height="1" alt="" />
												</font>
											</td>
											<td width="100%">
												<xsl:call-template name="forumpostblocks">
													<xsl:with-param name="forum" select="/H2G2/FORUMTHREADS/@FORUMID"/>
													<xsl:with-param name="skip" select="0"/>
													<xsl:with-param name="show" select="/H2G2/FORUMTHREADS/@COUNT"/>
													<xsl:with-param name="blocklimit" select="'20'"/>
													<xsl:with-param name="objectname" select="$m_threads"/>
													<xsl:with-param name="total" select="/H2G2/FORUMTHREADS/@TOTALTHREADS"/>
													<xsl:with-param name="this" select="/H2G2/FORUMTHREADS/@SKIPTO"/>
												</xsl:call-template>
											</td>
										</tr>
										</table>
										<br />
									</td>
								</tr>
								<tr>
									<td colspan="3" background="{$imagesource}dotted_line_inv.jpg">
										<img src="{$imagesource}t.gif" width="10" height="9" alt="" />
									</td>
								</tr>
							</xsl:if>
							<tr valign="bottom">
								<xsl:choose>
									<xsl:when test="/H2G2[@TYPE='USERPAGE']">
										<td bgcolor="#000000">
											<font xsl:use-attribute-sets="mainfont">
												<b>
													<xsl:apply-templates select="@FORUMID" mode="AddThread">
														<xsl:with-param name="img">
															<img src="{$imagesource}arrowh.gif" width="3" height="9" alt="" border="0" hspace="3" /><xsl:value-of select="$m_entry_leavemsg"/>
														</xsl:with-param>
													</xsl:apply-templates>
												</b>
											</font>
										</td>
									</xsl:when>
									<xsl:otherwise>
										<td bgcolor="#000000">
											<img src="{$imagesource}t.gif" width="1" height="7" alt="" /><br clear="all" />
											<font xsl:use-attribute-sets="smallfont">
												<b><xsl:value-of select="$m_threadstable_title"/></b>
											</font>
										</td>
									</xsl:otherwise>
								</xsl:choose>
								<td/>
								<td bgcolor="#000000">
									<font xsl:use-attribute-sets="smallfont">
										<b><xsl:value-of select="$m_threadstable_last"/></b>
									</font>
								</td>
							</tr>
							<tr>
								<td width="100%"><img src="{$imagesource}t.gif" width="506" height="10" alt="" /></td>
								<td width="6"><img src="{$imagesource}t.gif" width="6" height="1" alt="" /></td>
								<td width="100"><img src="{$imagesource}t.gif" width="100" height="10" alt="" /></td>
							</tr>
							<xsl:for-each select="THREAD">
								<tr>
									<td bgcolor="#000000" valign="top">
										<font xsl:use-attribute-sets="mainfont">
<!-- IL start -->
											<xsl:apply-templates select="@THREADID" mode="THREADS_MAINBODY"/>
											<xsl:if test="$test_IsEditor">
												<font size="1">
												&nbsp;&nbsp;&nbsp;
												(<xsl:apply-templates select="@THREADID" mode="movethreadgadget"/>)
												</font>
											</xsl:if>
										</font>
									</td>
									<td/>
									<td bgcolor="#000000" valign="top">
										<font xsl:use-attribute-sets="mainfont">
											<xsl:apply-templates select="@FORUMID" mode="THREADS_MAINBODY_Date"/>
<!-- IL end -->
										</font>
									</td>
								</tr>
							</xsl:for-each>
							<tr>
								<td colspan="3">
									<img src="{$imagesource}t.gif" width="1" height="7" alt="" />
								</td>
							</tr>
							<tr>
								<td colspan="3" background="{$imagesource}dotted_line_inv.jpg">
									<img src="{$imagesource}t.gif" width="10" height="9" alt="" />
								</td>
							</tr>
							<xsl:if test="not(/H2G2[@TYPE='THREADS'])">
								<tr>
									<td colspan="3" bgcolor="#000000">
										<img src="{$imagesource}t.gif" width="1" height="4" alt="" /><br clear="all" />
										<font xsl:use-attribute-sets="smallfont">
											<b>
												<xsl:if test="@MORE=1">
													<a class="norm"><xsl:attribute name="HREF"><xsl:value-of select="$root"/>F<xsl:value-of select="@FORUMID"/></xsl:attribute>
														<xsl:choose>
															<xsl:when test="/H2G2/@TYPE='USERPAGE'"><nobr><xsl:value-of select="$m_threadstable_prevmsg"/></nobr></xsl:when>
															<xsl:otherwise><nobr><xsl:value-of select="$m_threadstable_nextmsg"/></nobr></xsl:otherwise>
														</xsl:choose>
													</a>
													<xsl:if test="$registered=1"><xsl:value-of select="$skipdivider"/></xsl:if>
												</xsl:if>
												<xsl:call-template name="subscribearticleforum"/>
												<br clear="all" />
											</b>
										</font>
									</td>
								</tr>
							</xsl:if>
							<xsl:if test="/H2G2[@TYPE='THREADS']">
								<tr>
									<td colspan="3" bgcolor="#000000">
										<font xsl:use-attribute-sets="smallfont">
											<br />
											<table width="100%" cellspacing="0" cellpadding="0" border="0">
											<tr valign="top">
												<td width="150">
													<font xsl:use-attribute-sets="nullsmallfont">
														<xsl:call-template name="threadnavbuttons">
															<xsl:with-param name="URL">F</xsl:with-param>
														</xsl:call-template>
														<font color="#ffffff"><xsl:value-of select="$skipdivider"/></font>
														<br clear="all" /><img src="{$imagesource}t.gif" width="150" height="1" alt="" />
													</font>
												</td>
												<td width="100%">
													<xsl:call-template name="forumpostblocks">
														<xsl:with-param name="forum" select="/H2G2/FORUMTHREADS/@FORUMID"/>
														<xsl:with-param name="skip" select="0"/>
														<xsl:with-param name="show" select="/H2G2/FORUMTHREADS/@COUNT"/>
														<xsl:with-param name="objectname" select="$m_threads"/>
														<xsl:with-param name="total" select="/H2G2/FORUMTHREADS/@TOTALTHREADS"/>
														<xsl:with-param name="this" select="/H2G2/FORUMTHREADS/@SKIPTO"/>
														<xsl:with-param name="blocklimit" select="20"/>
													</xsl:call-template>
												</td>
											</tr>
											</table>
											<br />
										</font>
									</td>
								</tr>
							</xsl:if>
						</xsl:when>
						<xsl:otherwise>
							<tr>
								<td colspan="2">
									<font xsl:use-attribute-sets="mainfont">
										<xsl:choose>
											<xsl:when test="/H2G2/@TYPE='USERPAGE'">
												<xsl:call-template name="forum-empty">
													<xsl:with-param name="addlink"><xsl:value-of select="$m_leavemessage"/></xsl:with-param>
													<xsl:with-param name="addmessage"><xsl:value-of select="$m_firsttoleavemessage"/></xsl:with-param>
												</xsl:call-template>
											</xsl:when>
											<xsl:otherwise>
												<xsl:call-template name="forum-empty">
													<xsl:with-param name="addlink"><xsl:value-of select="$m_discussentry"/></xsl:with-param>
													<xsl:with-param name="addmessage"><xsl:value-of select="$m_firsttotalk"/></xsl:with-param>
												</xsl:call-template>
											</xsl:otherwise>
										</xsl:choose>
										<br/>
									</font>
									<font xsl:use-attribute-sets="smallfont">
										<img src="{$imagesource}t.gif" width="10" height="1" alt="" /><b><xsl:call-template name="subscribearticleforum"/></b>
									</font>
								</td>
							</tr>
						</xsl:otherwise>
					</xsl:choose>
				</table>
			</td>
		</tr>
	</table>
</xsl:template>

<xsl:template name="forum-empty">
	<xsl:param name="addlink" />
	<xsl:param name="addmessage" />
	<img src="{$imagesource}t.gif" width="1" height="8" alt="" /><br clear="all" />
	<img src="{$imagesource}t.gif" width="1" height="1" alt="" />
	<xsl:choose>
		<xsl:when test="not(/H2G2/ARTICLE) and /H2G2/@TYPE='USERPAGE'">
			<img src="{$imagesource}t.gif" width="10" height="1" alt="" /><xsl:value-of select="$m_threadstable_noaboutme"/>
			<br /><br />
			<img src="{$imagesource}t.gif" width="10" height="1" alt="" /><xsl:value-of select="$m_threadstable_checklater"/>
			<br/><br/>
		</xsl:when>
		<xsl:otherwise>
			<b>
				<a class="norm">
					<xsl:attribute name="href">
						<xsl:choose>
							<xsl:when test="/H2G2/SITE/IDENTITYSIGNIN = 0">
								<xsl:value-of select="$root"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$signinlink"/>
							</xsl:otherwise>
						</xsl:choose>
						<xsl:choose>
							<xsl:when test="/H2G2/PAGEUI/DISCUSS[@VISIBLE='1']">
								<xsl:value-of select="$pageui_discuss"/>
							</xsl:when>
							<xsl:otherwise>/AddThread?forum=<xsl:value-of select="@FORUMID"/></xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
					<img src="{$imagesource}arrowh.gif" width="3" height="9" alt="" border="0" hspace="3" /><xsl:copy-of select="$addlink"/>
				</a>
			</b>
			<br /><br clear="all" />
			<img src="{$imagesource}t.gif" width="10" height="1" alt="" /><xsl:copy-of select="$addmessage"/>
		</xsl:otherwise>
	</xsl:choose>
	<br />
</xsl:template>

<xsl:template name="subscribearticleforum">
	<xsl:param name="ForumID" select="@FORUMID"/>
	<xsl:param name="URL">A</xsl:param>
	<xsl:param name="ID" select="/H2G2/ARTICLE/ARTICLEINFO/H2G2ID"/>
	<xsl:param name="Desc" select="$alt_subreturntoarticle"/>
	<xsl:if test="$registered=1">
		<nobr><a class="norm"><xsl:attribute name="HREF"><xsl:value-of select="$root"/>FSB<xsl:value-of select="$ForumID"/>?cmd=subscribeforum&amp;page=normal&amp;desc=<xsl:value-of select="$Desc"/>&amp;return=<xsl:value-of select="$URL"/><xsl:value-of select="$ID"/></xsl:attribute><xsl:value-of select="$m_threadstable_alertme"/></a></nobr>
		<xsl:value-of select="$skipdivider"/>
		<nobr><a class="norm"><xsl:attribute name="HREF"><xsl:value-of select="$root"/>FSB<xsl:value-of select="$ForumID"/>?cmd=unsubscribeforum&amp;page=normal&amp;desc=<xsl:value-of select="$Desc"/>&amp;return=<xsl:value-of select="$URL"/><xsl:value-of select="$ID"/></xsl:attribute><xsl:value-of select="$m_threadstable_alertmestop"/></a></nobr>
	</xsl:if>
</xsl:template>

<xsl:template match="POPUPCONVERSATIONS">
	<xsl:variable name="userid">
		<xsl:choose>
			<xsl:when test="@USERID">
				<xsl:value-of select="@USERID"/>
			</xsl:when>
			<xsl:when test="$registered=1">
				<xsl:value-of select="/H2G2/VIEWING-USER/USER/USERID"/>
			</xsl:when>
			<xsl:otherwise>0</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:if test="$userid > 0">
		<xsl:variable name="target">
			<xsl:choose>
				<xsl:when test="@TARGET"><xsl:value-of select="@TARGET"/></xsl:when>
				<xsl:otherwise><xsl:text>conversation</xsl:text></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="width">
			<xsl:choose>
				<xsl:when test="@WIDTH"><xsl:value-of select="@WIDTH"/></xsl:when>
				<xsl:otherwise><xsl:text>170</xsl:text></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="height">
			<xsl:choose>
				<xsl:when test="@HEIGHT"><xsl:value-of select="@HEIGHT"/></xsl:when>
				<xsl:otherwise><xsl:text>400</xsl:text></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="poptarget">
			<xsl:choose>
				<xsl:when test="@POPTARGET"><xsl:value-of select="@POPTARGET"/></xsl:when>
				<xsl:otherwise><xsl:text>popupconv</xsl:text></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<a class="pos" onClick="popupwindow('{$root}MP{$userid}?skip={@SKIPTO}&amp;show={@COUNT}&amp;s_type=pop&amp;s_upto={@UPTO}&amp;s_target={$target}','{$poptarget}','width={$width},height={$height},resizable=yes,scrollbars=yes')" href="{$root}MP{$userid}?skip={@SKIPTO}&amp;show={@COUNT}&amp;s_type=pop&amp;s_upto={@UPTO}&amp;s_target={$target}" target="{$poptarget}">
			<xsl:value-of select="."/>
		</a>
	</xsl:if>
</xsl:template>

	<xsl:template name="escape-javascript">
		<xsl:param name="string" />
		<xsl:choose>
			<xsl:when test='contains($string, "&apos;")'>
				<xsl:call-template name="escape-javascript">
					<xsl:with-param name="string"
					  select='substring-before($string, "&apos;")' />
				</xsl:call-template>
				<xsl:text>\'</xsl:text>
				<xsl:call-template name="escape-javascript">
					<xsl:with-param name="string"
					  select='substring-after($string, "&apos;")' />
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="contains($string, '&#xA;')">
				<xsl:call-template name="escape-javascript">
					<xsl:with-param name="string"
					  select="substring-before($string, '&#xA;')" />
				</xsl:call-template>
				<xsl:text>\n</xsl:text>
				<xsl:call-template name="escape-javascript">
					<xsl:with-param name="string"
					  select="substring-after($string, '&#xA;')" />
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="contains($string, '\')">
				<xsl:value-of select="substring-before($string, '\')" />
				<xsl:text>\\</xsl:text>
				<xsl:call-template name="escape-javascript">
					<xsl:with-param name="string"
					  select="substring-after($string, '\')" />
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$string" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>