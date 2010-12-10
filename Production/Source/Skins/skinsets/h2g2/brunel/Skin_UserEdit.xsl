<?xml version='1.0' encoding='iso-8859-1' ?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
			  version="1.0"
			  xmlns:msxsl="urn:schemas-microsoft-com:xslt"
			  xmlns:local="#local-functions"
			  xmlns:s="urn:schemas-microsoft-com:xml-data"
			  xmlns:dt="urn:schemas-microsoft-com:datatypes">

	<!-- Need the following doctype to get the map pushpin info boxes to display in the correct position -->
	<xsl:output method="xml" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"
			 doctype-public="W3C//DTD XHTML 1.0 Transitional//EN"/>

	<xsl:template name="USEREDIT_TITLE">
	<title>
		<xsl:choose>
			<xsl:when test="INREVIEW">
				<xsl:value-of select="$m_articleisinreviewtext"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$m_editpagetitle"/>
			</xsl:otherwise>
		</xsl:choose>
	</title>
	<xsl:call-template name="EnhEditorJS" />
</xsl:template>

<xsl:template name="USEREDIT_SUBJECT">
	<xsl:call-template name="SUBJECTHEADER">
		<xsl:with-param name="text">
			<A NAME="top"/>
			<xsl:choose>
				<xsl:when test="number(ARTICLE-EDIT-FORM/H2G2ID) = 0 and ARTICLE-EDIT-FORM/MASTHEAD != 0"><xsl:value-of select="$m_AddHomePageHeading"/></xsl:when>
				<xsl:when test="number(ARTICLE-EDIT-FORM/H2G2ID) = 0 and ARTICLE-EDIT-FORM/MASTHEAD = 0"><xsl:value-of select="$m_AddGuideEntryHeading"/></xsl:when>
				<xsl:when test="number(ARTICLE-EDIT-FORM/H2G2ID) != 0 and ARTICLE-EDIT-FORM/MASTHEAD != 0"><xsl:value-of select="$m_EditHomePageHeading"/></xsl:when>
				<xsl:when test="number(ARTICLE-EDIT-FORM/H2G2ID) != 0 and ARTICLE-EDIT-FORM/MASTHEAD = 0"><xsl:value-of select="$m_EditGuideEntryHeading"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="$m_EditGuideEntryHeading"/></xsl:otherwise>
			</xsl:choose>
		</xsl:with-param>
	</xsl:call-template>
</xsl:template>

<xsl:template name="USEREDIT_BAR">
	<xsl:call-template name="nuskin-homelinkbar">
		<xsl:with-param name="barcolour">000000</xsl:with-param>
		<xsl:with-param name="bardata">
			<table width="100%" cellspacing="0" cellpadding="0" border="0">
				<tr>
					<td width="14" rowspan="4"><img src="{$imagesource}t.gif" width="14" height="1" alt="" /></td>
					<td width="100%"><img src="{$imagesource}t.gif" width="611" height="30" alt="" /></td>
					<td width="14" rowspan="4"><img src="{$imagesource}t.gif" width="14" height="1" alt="" /></td>
				</tr>
				<tr>
					<td>
						<font xsl:use-attribute-sets="subheaderfont">
							<b>
								<xsl:choose>
									<xsl:when test="INREVIEW"><xsl:value-of select="$m_articleisinreviewsubject"/></xsl:when>
									<xsl:when test="ARTICLE-PREVIEW/ARTICLE/SUBJECT"><xsl:value-of select="$m_urnow"/> editing: <b><xsl:value-of select="ARTICLE-PREVIEW/ARTICLE/SUBJECT"/></b></xsl:when>
									<xsl:when test="number(ARTICLE-EDIT-FORM/H2G2ID) = 0 and ARTICLE-EDIT-FORM/MASTHEAD != 0"><xsl:value-of select="$m_urnow"/><xsl:value-of select="$m_AddHomePageHeading_sub"/></xsl:when>
									<xsl:when test="number(ARTICLE-EDIT-FORM/H2G2ID) = 0 and ARTICLE-EDIT-FORM/MASTHEAD = 0"><xsl:value-of select="$m_urnow"/><xsl:value-of select="$m_AddGuideEntryHeading_sub"/></xsl:when>
									<xsl:when test="number(ARTICLE-EDIT-FORM/H2G2ID) != 0 and ARTICLE-EDIT-FORM/MASTHEAD != 0"><xsl:value-of select="$m_urnow"/><xsl:value-of select="$m_EditHomePageHeading_sub"/></xsl:when>
									<xsl:when test="number(ARTICLE-EDIT-FORM/H2G2ID) != 0 and ARTICLE-EDIT-FORM/MASTHEAD = 0"><xsl:value-of select="$m_urnow"/><xsl:value-of select="$m_EditGuideEntryHeading_sub"/></xsl:when>
									<xsl:otherwise><xsl:value-of select="$m_articleisnew"/></xsl:otherwise>
								</xsl:choose>
							</b>
						</font>
					</td>
				</tr>
				<tr><td><img src="{$imagesource}t.gif" width="1" height="5" alt="" /></td></tr>
				<tr><td><img src="{$imagesource}t.gif" width="1" height="8" alt="" /></td></tr>
			</table>
		</xsl:with-param>
	</xsl:call-template>
</xsl:template>

<xsl:template name="USEREDIT_MAINBODY">
	<td width="100%" bgcolor="#000000" class="postable">
		<table width="100%" cellspacing="0" cellpadding="8" border="0">
			<tr>
				<td>
					<font xsl:use-attribute-sets="textfont">				
						<xsl:choose>
							<xsl:when test="INREVIEW">
								<xsl:call-template name="m_inreviewtextandlink" /></xsl:when>
							<xsl:otherwise>
                <xsl:if test="$use-maps=1">
                  <xsl:call-template name="MapScripts"/>
                </xsl:if>
                <SCRIPT LANGUAGE="JavaScript">
									<xsl:comment>
									submit=0;
									function runSubmit () {
										submit+=1;
										if(submit>2) {alert("<xsl:value-of select="$m_donotpress"/>"); return (false);}
										if(submit>1) {alert("<xsl:value-of select="$m_atriclesubmitted"/>"); return (false);}
										return(true);
									}
									//</xsl:comment>
								</SCRIPT>
								<xsl:if test="ARTICLE-PREVIEW/ARTICLE/GUIDE">
									<table width="100%" cellpadding="0" cellspacing="6" border="0">
										<tr>
											<td colspan="2"><font xsl:use-attribute-sets="mainfont" class="postxt"><b><xsl:value-of select="$m_previewurentry"/></b></font></td>
										</tr>
										<tr>
											<td><font xsl:use-attribute-sets="smallfont" class="postxt"><xsl:value-of select="$m_whatentrylooklike"/></font></td>
											<td align="right"><font xsl:use-attribute-sets="smallfont" class="postxt"><nobr><a href="#edit" class="pos"><b><xsl:value-of select="$m_jumptoedit"/></b></a></nobr></font></td>
										</tr>
										<tr>
											<td colspan="2" background="{$imagesource}dotted_line_ssml_grey.jpg" style="background-repeat:repeat-x"><img src="{$imagesource}t.gif" width="599" height="1" alt="" /></td>
										</tr>
										<tr>
											<td colspan="2">
												<font xsl:use-attribute-sets="textfont">
													<img src="{$imagesource}t.gif" width="1" height="10" alt="" /><br clear="all" />
													<xsl:apply-templates select="ARTICLE-PREVIEW/ARTICLE/GUIDE/BODY"/>
													<xsl:if test=".//FOOTNOTE">
														<blockquote>
															<font xsl:use-attribute-sets="textsmallfont">
																<hr xsl:use-attribute-sets="nu_hr" />
																<xsl:apply-templates mode="display" select=".//FOOTNOTE"/>
															</font>
														</blockquote>
													</xsl:if>
													<br clear="all" /><img src="{$imagesource}t.gif" width="1" height="10" alt="" />
												</font>
											</td>
										</tr>
										<tr>
											<td colspan="2" background="{$imagesource}dotted_line_ssml_grey.jpg" style="background-repeat:repeat-x"><img src="{$imagesource}t.gif" width="1" height="1" alt="" /></td>
										</tr>
									</table>
								</xsl:if>
								<xsl:apply-templates select="ARTICLE-EDIT-FORM"/>
							</xsl:otherwise>
						</xsl:choose>
						<br /><br />
					</font>
          
				</td>
			</tr>
		</table>
		<script type="text/javascript" language="JavaScript">
			<xsl:comment>
				var domPath = document.theForm.body;
			//</xsl:comment>
		</script>
	</td>
</xsl:template>

<xsl:template match="ARTICLE-EDIT-FORM">
	<table width="611" cellpadding="5" cellspacing="1" border="0">
		<form name="theForm" method="POST" action="{$root}Edit" onsubmit="return runSubmit()" title="Article Editing Form">
			<tr>
				<td>
				<xsl:if test="@PROFANITYTRIGGERED = 1">
          <font xsl:use-attribute-sets="mainfont" class="postxt">
            <p style="padding-left:20px;background-image: url(/dnaimages/boards/images/warning.gif); background-repeat: no-repeat; background-position-y: 3px;">This entry has been blocked as it contains a word which other users may find offensive. Please edit your entry and post it again.</p>
          </font>
        </xsl:if>	
<!-- IL start -->
					<font xsl:use-attribute-sets="mainfont" class="postxt"><xsl:call-template name="articlepremoderationmessage"/></font>
<!-- IL end -->
					<table width="580" cellpadding="0" cellspacing="0" border="0">
						<tr>
							<td width="320"><img src="{$imagesource}t.gif" width="320" height="1" alt="" /></td>
							<td width="10" rowspan="2"><img src="{$imagesource}t.gif" width="10" height="1" alt="" /></td>
							<td width="250"><img src="{$imagesource}t.gif" width="250" height="1" alt="" /></td>
						</tr>
						<tr>
							<td colspan="3"><font xsl:use-attribute-sets="mainfont" class="postxt"><b><xsl:value-of select="$m_edentry_title"/></b></font><br clear="all" /><img src="{$imagesource}t.gif" width="612" height="4" alt="" /></td>
						</tr>
						<tr>
							<td colspan="2">
								<xsl:apply-templates select="." mode="Params"/>
								<xsl:apply-templates select="." mode="subject"/>
							</td>
							<td><font xsl:use-attribute-sets="smallfont" class="postxt"><b><xsl:call-template name="m_enheditorhelp" /></b>
                <xsl:if test="$use-maps=1">
                <!--<br/>
                <a href="#" onclick="showMap(51.601322, -0.102913,12);return false;" class="pos">show map</a>
                  <br/><a href="#" onclick="insertAtCursor(document.getElementById('bodyText'),'Hello there');return false;">test insert</a>
                  <br/>
                  <a id="showsavedlocations"  href="#" onclick="showLocations();return false;">Show Saved Locations</a>
                  <a id="hidesavedlocations"  href="#" onclick="hideLocations();return false;" style="display:none">Hide Saved Locations</a>
                  <div id="savedlinks" style="display:none">
                    <ul id="savedlinkslist">
                    </ul>
                  </div>-->
                </xsl:if>
              </font>
                
              </td>
						</tr>
					</table>
				</td>
			</tr>
			<tr>
				<td><font xsl:use-attribute-sets="mainfont" class="postxt"><b><xsl:value-of select="$m_edentry_body"/></b></font><br clear="all" /><img src="{$imagesource}t.gif" width="1" height="4" alt="" /><br clear="all" />
					<xsl:if test="FORMAT=1">
					<script type="text/javascript" language="JavaScript">
					<xsl:comment>
						drawTools(checkType());
					//</xsl:comment>
					</script><br clear="all" /><img src="{$imagesource}t.gif" width="1" height="3" alt="" /><br clear="all" />
					<noscript><font xsl:use-attribute-sets="mainfont" class="postxt"><xsl:value-of select="$m_enherrornojs"/></font></noscript>
					</xsl:if>
					<textarea id="bodyText" rows="25" cols="72" name="body" style="width:600;" wrap="soft" title="{$alt_contentofguideentry}"><xsl:value-of select="CONTENT"/></textarea>
				</td>
			</tr>
			<tr>
				<td>
					<table width="601" cellspacing="0" cellpadding="0" border="0">
						<tr>
							<td colspan="3" background="{$imagesource}dotted_line_ssml_grey.jpg"><img src="{$imagesource}t.gif" width="601" height="1" alt="" /></td>
						</tr>
						<tr valign="top">
							<td width="220">
								<img src="{$imagesource}t.gif" width="220" height="5" alt="" /><br clear="all" />
								<table width="220" cellspacing="0" cellpadding="0" border="0">
									<tr>
										<td>
											<input type="submit" name="preview" value="Preview" alt="Preview" border="0" title="{$alt_previewhowlook}">
												<xsl:attribute name="VALUE">
													<xsl:value-of select="$m_preview"/>
												</xsl:attribute>
											</input>
<!--
											<input type="Image" src="{$imagesource}preview_inv.gif" name="preview" value="Preview" alt="Preview" border="0" title="{$alt_previewhowlook}">
												<xsl:attribute name="VALUE">
													<xsl:value-of select="$m_preview"/>
												</xsl:attribute>
											</input>
-->
                      <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
										</td>
										<td><font xsl:use-attribute-sets="mainfont" class="postxt"> in </font><SELECT NAME="skin"><xsl:call-template name="skindropdown"/></SELECT></td>
									</tr>
									<tr>
										<td colspan="2"><img src="{$imagesource}t.gif" width="1" height="5" alt="" /><br clear="all" />
											<xsl:apply-templates select="FUNCTIONS/ADDENTRY"/>
											<xsl:apply-templates select="FUNCTIONS/UPDATE"/>

											<xsl:if test="$test_IsEditor or ($superuser=1)">
												<xsl:apply-templates select="STATUS" mode="ArticleEdit"/>
												<xsl:apply-templates select="EDITORID" mode="ArticleEdit"/>
											</xsl:if>

											<xsl:if test="FUNCTIONS/HIDE">
												<br clear="all" /><img src="{$imagesource}t.gif" width="1" height="5" alt="" /><br clear="all" />
												<input type="checkbox" name="Hide" value="1">
													<xsl:if test="number(HIDDEN) = 1">
														<xsl:attribute name="checked">checked</xsl:attribute>
													</xsl:if>
												</input>
												<font xsl:use-attribute-sets="mainfont" class="postxt"><xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text><xsl:value-of select="$m_HideEntry"/></font>
											</xsl:if>
											<xsl:apply-templates select="FUNCTIONS/CHANGE-SUBMITTABLE"/>
											
										</td>
									</tr>
								</table>
								<img src="{$imagesource}t.gif" width="1" height="5" alt="" />
							</td>
							<td width="1" background="{$imagesource}dotted_line_ssmlv_grey.jpg"><img src="{$imagesource}t.gif" width="17" height="1" alt="" /></td>
							<td width="380"><img src="{$imagesource}t.gif" width="1" height="5" alt="" /><br clear="all" />
								<font xsl:use-attribute-sets="smallfont" class="postxt">
<!-- IL start -->
									<xsl:copy-of select="$m_UserEditWarning"/>
<!-- IL end -->
									<br /><br />
<!-- IL start -->
									<xsl:copy-of select="$m_UserEditHouseRulesDiscl"/>
<!-- IL end -->
									<xsl:if test="FUNCTIONS/CHANGE-SUBMITTABLE">
										<br /><br />
										<xsl:call-template name="m_notforreview_explanation" />
									</xsl:if>
								</font>
								<br clear="all" /><img src="{$imagesource}t.gif" width="1" height="5" alt="" />
							</td>
						</tr>
						<tr>
							<td colspan="3" background="{$imagesource}dotted_line_ssml_grey.jpg"><img src="{$imagesource}t.gif" width="1" height="1" alt="" /></td>
						</tr>
					</table>
				</td>
			</tr>
			<tr>
				<td>
					<font xsl:use-attribute-sets="mainfont" class="postxt">
						<xsl:apply-templates select="./FORMAT"/>
						<input type="submit" name="reformat" value="{$m_changestyle}" alt="Change Style"/>
<!--
						<input type="Image" src="{$imagesource}changestyle_inv.gif" name="reformat" border="0" alt="Change Style">
							<xsl:attribute name="VALUE"><xsl:value-of select="$m_changestyle"/></xsl:attribute>
						</input>
-->
						<BR/><BR/>
						<xsl:choose>
							<xsl:when test="$use-maps=1">
								<xsl:choose>
									<xsl:when test="/H2G2/HELP[@TOPIC='GuideML']">
										<a class="pos" target="_blank" alt="{$alt_mapclickhereguidehelpentry}" title="{$alt_mapclickhereguidehelpentry}">
											<xsl:attribute name="HREF">
												<xsl:value-of select="$m_WritingGuideMLHelpLink"/>
											</xsl:attribute>
											<xsl:value-of select="$alt_mapclickhereguidehelpentry"/>
										</a>
									</xsl:when>
									<xsl:when test="/H2G2/HELP[@TOPIC='PlainText']">
										<a class="pos" target="_blank" alt="{$alt_mapclickhereplaintexthelpentry}" title="{$alt_mapclickhereplaintexthelpentry}">
											<xsl:attribute name="HREF">
												<xsl:value-of select="$m_WritingPlainTextHelpLink"/>
											</xsl:attribute>
											<xsl:value-of select="$alt_mapclickhereplaintexthelpentry"/>
										</a>
									</xsl:when>
								</xsl:choose>
								<br />
								<br />
								<a class="pos" target="_blank" alt="{$alt_mapclickheremaphelpentry}" title="{$alt_mapclickheremaphelpentry}">
									<xsl:attribute name="HREF">
										<xsl:value-of select="$m_MapLocationsHelpLink"/>
									</xsl:attribute>
									<xsl:value-of select="$alt_mapclickheremaphelpentry"/>
								</a>
								<br />
								<br />
								<b>
									<xsl:value-of select="$m_mapnoneofthese"/>
									<xsl:choose>
										<xsl:when test="MASTHEAD[.='1']">
											<xsl:choose>
												<xsl:when test="FUNCTIONS/ADDENTRY">
													<xsl:value-of select="$m_addintroduction"/>
												</xsl:when>
												<xsl:when test="FUNCTIONS/UPDATE">
													<xsl:value-of select="$m_updateintroduction"/>
												</xsl:when>
												<xsl:otherwise>
													<xsl:value-of select="$m_updateintroduction"/>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:when>
										<xsl:otherwise>
											<xsl:choose>
												<xsl:when test="FUNCTIONS/ADDENTRY">
													<xsl:value-of select="$m_addguideentry"/>
												</xsl:when>
												<xsl:when test="FUNCTIONS/UPDATE">
													<xsl:value-of select="$m_updateentry"/>
												</xsl:when>
												<xsl:otherwise>
													<xsl:value-of select="$m_updateentry"/>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:otherwise>
									</xsl:choose>
									<xsl:value-of select="$m_button"/>
								</b>
							</xsl:when>
							<xsl:otherwise>
								<a class="pos" target="_blank" alt="{$alt_clickherehelpentry}" title="{$alt_clickherehelpentry}">
									<xsl:attribute name="HREF">
										<xsl:choose>
											<xsl:when test="/H2G2/HELP[@TOPIC='GuideML']">
												<xsl:value-of select="$m_WritingGuideMLHelpLink"/>
											</xsl:when>
											<xsl:when test="/H2G2/HELP[@TOPIC='PlainText']">
												<xsl:value-of select="$m_WritingPlainTextHelpLink"/>
											</xsl:when>
										</xsl:choose>
									</xsl:attribute>
									<xsl:value-of select="$alt_clickherehelpentry"/>
								</a>
								<br /><br />
								<xsl:value-of select="$m_noneofthese"/>
									<xsl:choose>
										<xsl:when test="MASTHEAD[.='1']">
											<xsl:choose>
												<xsl:when test="FUNCTIONS/ADDENTRY"><xsl:value-of select="$m_addintroduction"/></xsl:when>
												<xsl:when test="FUNCTIONS/UPDATE"><xsl:value-of select="$m_updateintroduction"/></xsl:when>
												<xsl:otherwise><xsl:value-of select="$m_updateintroduction"/></xsl:otherwise>
											</xsl:choose>
										</xsl:when>
										<xsl:otherwise>
											<xsl:choose>
												<xsl:when test="FUNCTIONS/ADDENTRY"><xsl:value-of select="$m_addguideentry"/></xsl:when>
												<xsl:when test="FUNCTIONS/UPDATE"><xsl:value-of select="$m_updateentry"/></xsl:when>
												<xsl:otherwise><xsl:value-of select="$m_updateentry"/></xsl:otherwise>
											</xsl:choose>
										</xsl:otherwise>
									</xsl:choose>
								<xsl:value-of select="$m_button"/>
							</xsl:otherwise>
						</xsl:choose>
						<xsl:if test="$use-maps=1">
				<br/>
				<br/>
				<img src='/dnaimages/mapping/pushpins/015.bmp'/><a class="pos" href="#" onclick="PositionMap2(51.601322, -0.102913,12);return false;">Add map locations to this Entry.</a>
				<div id="locationDetails" style="width:200; height:150;display:none;background:#ccc;z-index:100">
					<div>
						Title:<input type="text" id="LocationTitle"></input>
					</div>
					<br/>
					<div>
						Description:<input type="text" id="LocationDescription"></input>
					</div>
					<input type="button" onclick="AddLocation()" value="Add Location"></input>
				</div>
              <br/>
              <input type="hidden" id="LatLon"/>
              <input type="hidden" id="LocationXML" name="LocationXML" />
              <br/>
              <div id="mapContainer" style="display:none;position:relative; width:728px; height:600px; left:0px; top: 0px;">
				  <table id="findheaderbartable" style="background:#ccc;position:relative; width:728px; height:50px; left: 0px; top: 0px;">
					  <tr>
						  <td>
							  <input type="text" id="txtWhere" onKeyDown="HandleKeyDown(true);"/>
							  <input type="button" onclick="FindLoc();return false;" value="Pinpoint Location" id="findlocationbtn"/>
						  </td>
						  <td>
						  </td>
						  <td>
							  <font xsl:use-attribute-sets="mainfont" class="postxt">
								  <span id="linksaved" style="display:none">Link Saved</span>
							  </font>
						  </td>
						  <td>
							  <input type="button"  id="makemaplink" onclick="MakeMapLink();return false;" value="Now Make Map Link"/>
						  </td>
						  <td>
							<font xsl:use-attribute-sets="mainfont" class="postxt">
								<div style="display:none" id="maplinktitled">
								  Title:<input type="text" id="maplinktitle" onKeyDown="HandleKeyDown(false);"/>
								</div>
							</font>
						  </td>
						  <td>
							<font xsl:use-attribute-sets="mainfont" class="postxt">
								<div style="display:none" id="maplinkdescriptiond">
								  Description:<input type="text" id="maplinkdescription" onKeyDown="HandleKeyDown(false);"/>
								</div>
							</font>
						  </td>
						  <td>
							  <input type="button" style="display:none" id="savemaplink" value="Save" onclick="SaveMapLink();return false;"/>
						  </td>
						  <td>
							  <input type="button" style="display:none" id="cancelmaplink" value="Cancel" onclick="CancelMapLink();return false;"/>
						  </td>
						  <td>
							  <font xsl:use-attribute-sets="mainfont" class="postxt">
								  <a class="pos" href="#" onclick="hideMap();return false;">Hide Map</a>
							  </font>
						  </td>
					  </tr>
					  <tr>
						  <td>
							  <font xsl:use-attribute-sets="xsmallfont" class="postxt">
								  Type in place or postcode (eg, East Kilbride or G74)
							  </font>
						  </td>
						  <td></td>
						  <td></td>
						  <td></td>
						  <td>
							  <div style="display:none" id="maplinktitledhelper">
								  <font xsl:use-attribute-sets="xsmallfont" class="postxt">
									  Give your map link a name
								  </font>
							  </div>
						  </td>
						  <td>
							  <div style="display:none" id="maplinkdescriptiondhelper">
								  <font xsl:use-attribute-sets="xsmallfont" class="postxt">
									  Provide more details (max. 200 words) then click save
								  </font>
							  </div>
						  </td>
						  <td></td>
						  <td></td>
						  <td></td>
					  </tr>
				  </table>
				  <div id="resultDiv" style="background:#ccc;display:none; position:relative;width:728px; height:100px; left: 0px; top: 0px;"/>
				  <div id='myMap' style="position:relative; width:728px; height:500px; left: 0px; top: 0px;" ></div>
			  </div>
				<div style="display:none;position:relative;" id="locationlist">
					<font class="postxt">
						Entry Locations
					</font>
					<ol id="locationSummary" name="LocationSummary" bgcolor="#000000">
					</ol>
				</div>
				<script type="text/javascript">
					<![CDATA[     
					  var tmpObj;
					  var latlon;
						]]><![CDATA[
						]]>
							<xsl:for-each select="/H2G2/ARTICLE-EDIT-FORM/MAP-LOCATIONS/MAP-LOCATION">
								<![CDATA[
									latlon = new VELatLong(]]><xsl:value-of select="LATITUDE"/><![CDATA[,]]><xsl:value-of select="LONGITUDE"/><![CDATA[);
									AddLocationToArray(latlon, "]]><xsl:value-of select="TITLE"/><![CDATA[", "]]><xsl:value-of select="DESCRIPTION"/><![CDATA[", ]]><xsl:value-of select="LOCATIONID"/><![CDATA[);										
									AddLocationListEntry(latlon, "]]><xsl:value-of select="TITLE"/><![CDATA[", "]]><xsl:value-of select="DESCRIPTION"/><![CDATA[", ]]><xsl:value-of select="LOCATIONID"/><![CDATA[);	
								]]>
							</xsl:for-each>
						<![CDATA[				      
					  ]]>
				</script>
			</xsl:if>
		</font>

	</td>
			</tr>
		<xsl:if test="MASTHEAD = 0">
				<xsl:variable name="MaxResearchersShown">10</xsl:variable>
				<xsl:variable name="MaxUsernameChars">20</xsl:variable>
					<xsl:if test="FUNCTIONS/ADD-RESEARCHERS">
					<tr>
						<td>
							<table width="601" cellspacing="0" cellpadding="0" border="0">
								<tr>
									<td background="{$imagesource}dotted_line_ssml_grey.jpg"><img src="{$imagesource}t.gif" width="601" height="1" alt="" /></td>
								</tr>
							</table>
						</td>
					</tr>
					<tr>
						<td>
							<font xsl:use-attribute-sets="mainfont" class="postxt">
								<font xsl:use-attribute-sets="subheaderfont" class="postxt"><b><xsl:value-of select="$m_edittheresearcherlisttext"/></b></font><br /><br />
								<xsl:for-each select="RESEARCHERS/USER-LIST/USER">
									<xsl:sort select="USERNAME" data-type="text" order="ascending"/>
										<xsl:choose>
											<xsl:when test="string-length(USERNAME) &gt; $MaxUsernameChars">
												<xsl:value-of select="substring(USERNAME, 1, $MaxUsernameChars - 3)"/>...
											</xsl:when>
											<xsl:otherwise><xsl:value-of select="USERNAME"/></xsl:otherwise>
										</xsl:choose>
									<xsl:text> (U</xsl:text><xsl:value-of select="USERID"/>)<br/>
								</xsl:for-each>
								<xsl:value-of select="$m_ResListEdit"/><br/>
								<textarea name="ResearcherList" rows="5" cols="72" style="width:600;" wrap="soft">
									<xsl:for-each select="RESEARCHERS/USER-LIST/USER">
										<xsl:sort select="USERNAME" data-type="text" order="ascending"/>
										<xsl:value-of select="USERID"/><xsl:text>,</xsl:text>
									</xsl:for-each>
								</textarea>
								<br/><IMG src="{$imagesource}t.gif" WIDTH="1" HEIGHT="5" ALT="" /><br />
								<input type="submit" name="SetResearchers" value="Set Researchers" border="0" alt="Set Researchers" />
<!--							<input type="Image" src="{$imagesource}set_researchers_inv.gif" name="SetResearchers" value="Set Researchers" border="0" alt="Set Researchers" /> -->
							</font>
						</td>
					</tr>
				</xsl:if>
			</xsl:if>
		</form>
		<xsl:if test="FUNCTIONS/MOVE-TO-SITE">
			<tr>
				<td>
					<table width="601" cellspacing="0" cellpadding="0" border="0">
						<tr>
							<td background="{$imagesource}dotted_line_ssml_grey.jpg"><img src="{$imagesource}t.gif" width="601" height="1" alt="" /></td>
						</tr>
					</table>
				</td>
			</tr>
			<tr>
				<td>
					<font xsl:use-attribute-sets="mainfont" class="postxt">
						<h3>
				<xsl:value-of select="$m_MoveToSite"/>
						</h3>
						<xsl:apply-templates select="SITEID" mode="MoveToSite">
							<xsl:with-param name="objectID" select="H2G2ID"/>
						</xsl:apply-templates>
					</font>
				</td>
			</tr>
		</xsl:if>
		<xsl:if test="./FUNCTIONS/DELETE">
			<tr>
				<td>
					<table width="601" cellspacing="0" cellpadding="0" border="0">
						<tr>
							<td background="{$imagesource}dotted_line_ssml_grey.jpg"><img src="{$imagesource}t.gif" width="601" height="1" alt="" /></td>
						</tr>
					</table>
				</td>
			</tr>
			<tr>
				<td>
					<font xsl:use-attribute-sets="mainfont" class="postxt">
						<font xsl:use-attribute-sets="subheaderfont" class="postxt"><b><xsl:value-of select="$m_deletethisentry"/></b></font><br /><br />
						<P><xsl:value-of select="$m_deletebypressing"/></P>
						<table width="601" cellspacing="0" cellpadding="0" border="0">
							<FORM METHOD="GET" action="{$root}Edit" ONSUBMIT="return confirm('{$m_ConfirmDeleteEntry}')">
								<tr>
									<td>
										<font xsl:use-attribute-sets="mainfont" class="postxt">
											<INPUT TYPE="hidden" NAME="id"><xsl:attribute name="VALUE"><xsl:value-of select="H2G2ID"/></xsl:attribute></INPUT>
											<INPUT TYPE="hidden" NAME="masthead"><xsl:attribute name="VALUE"><xsl:value-of select="MASTHEAD"/></xsl:attribute></INPUT>
											<INPUT TYPE="hidden" NAME="cmd" VALUE="delete"/>
											<input name="button" xsl:use-attribute-sets="iDeleteArticle"/>
											<!--<input type="Image" src="{$imagesource}delete_inv.gif" name="button" border="0" alt="Delete"><xsl:attribute name="VALUE"><xsl:value-of select="$m_delete"/></xsl:attribute></input>-->
										</font>
									</td>
								</tr>
							</FORM>
						</table>
					</font>
				</td>
			</tr>
		</xsl:if>
		<xsl:if test="MASTHEAD[. != '1']">
			<tr>
				<td>
					<table width="601" cellspacing="0" cellpadding="0" border="0">
						<tr>
							<td background="{$imagesource}dotted_line_ssml_grey.jpg"><img src="{$imagesource}t.gif" width="601" height="1" alt="" /></td>
						</tr>
					</table>
				</td>
			</tr>
			<tr>
				<td>
					<font xsl:use-attribute-sets="mainfont" class="postxt">
						<font xsl:use-attribute-sets="subheaderfont" class="postxt"><b><xsl:value-of select="$m_recommendtitle"/></b></font><br /><br />
						<xsl:call-template name="m_recommendtext" />
					</font>
				</td>
			</tr>
		</xsl:if>
		<xsl:if test="./FUNCTIONS/UNCONSIDER">
			<tr>
				<td>
					<table width="601" cellspacing="0" cellpadding="0" border="0">
						<tr>
							<td background="{$imagesource}dotted_line_ssml_grey.jpg"><img src="{$imagesource}t.gif" width="601" height="1" alt="" /></td>
						</tr>
					</table>
				</td>
			</tr>
			<tr>
				<td>
					<font xsl:use-attribute-sets="mainfont" class="postxt">
						<xsl:call-template name="m_submitentryblurb"/>
						<FORM METHOD="post" action="{$root}Edit" ONSUBMIT="return runSubmit()">
							<INPUT TYPE="hidden" NAME="id"><xsl:attribute name="VALUE"><xsl:value-of select="H2G2ID"/></xsl:attribute></INPUT>
							<INPUT TYPE="hidden" NAME="masthead"><xsl:attribute name="VALUE"><xsl:value-of select="MASTHEAD"/></xsl:attribute></INPUT>
							<INPUT TYPE="hidden" NAME="cmd" VALUE="unconsider"/>
							<input type="submit" name="button" alt="{$m_unsubmit}" VALUE="{$m_unsubmit}"/>
<!--
							<input type="Image" src="{$imagesource}unsubmitentry_inv.gif" name="button" border="0" alt="{$m_unsubmit}">
								<xsl:attribute name="VALUE"><xsl:value-of select="$m_unsubmit"/></xsl:attribute>
							</input>
-->
							<BR/>
						</FORM>
					</font>
				</td>
			</tr>
		</xsl:if>
	</table>
</xsl:template>

<xsl:template match="ARTICLE-EDIT-FORM" mode="Params">
	<INPUT TYPE="hidden" NAME="id"><xsl:attribute name="VALUE"><xsl:value-of select="H2G2ID"/></xsl:attribute></INPUT>
	<INPUT TYPE="hidden" NAME="masthead"><xsl:attribute name="VALUE"><xsl:value-of select="MASTHEAD"/></xsl:attribute></INPUT>
	<INPUT TYPE="hidden" NAME="format"><xsl:attribute name="VALUE"><xsl:value-of select="FORMAT"/></xsl:attribute></INPUT>
	<INPUT TYPE="hidden" NAME="cmd" VALUE="submit"/>
</xsl:template>

<xsl:template match="ARTICLE-EDIT-FORM" mode="subject">
	<INPUT>
		<xsl:attribute name="name">subject</xsl:attribute>
		<xsl:attribute name="title">Subject of your Guide Entry</xsl:attribute>
		<xsl:attribute name="type">text</xsl:attribute>
		<xsl:attribute name="size">39</xsl:attribute>
		<xsl:attribute name="style">width:300px;</xsl:attribute>
		<xsl:attribute name="value"><xsl:value-of select="SUBJECT"/></xsl:attribute>
	</INPUT>
</xsl:template>

<xsl:template match="FUNCTIONS/ADDENTRY">
	<input type="submit" name="addentry" border="0" alt="Publish" title="{$alt_storethis}" onclick="GenerateLocationXML();">
		<xsl:choose>
			<xsl:when test="../../MASTHEAD[.='1']"><xsl:attribute name="VALUE"><xsl:value-of select="$m_addintroduction"/></xsl:attribute></xsl:when>
			<xsl:otherwise><xsl:attribute name="VALUE"><xsl:value-of select="$m_addguideentry"/></xsl:attribute></xsl:otherwise>
		</xsl:choose>
	</input>
<!--
	<input type="Image" src="{$imagesource}publish_inv.gif" name="addentry" border="0" alt="Publish" title="{$alt_storethis}">
		<xsl:choose>
			<xsl:when test="MASTHEAD[.='1']"><xsl:attribute name="VALUE"><xsl:value-of select="$m_addintroduction"/></xsl:attribute></xsl:when>
			<xsl:otherwise><xsl:attribute name="VALUE"><xsl:value-of select="$m_addguideentry"/></xsl:attribute></xsl:otherwise>
		</xsl:choose>
	</input>
-->
</xsl:template>

<xsl:template match="FUNCTIONS/UPDATE">
	<br clear="all" /><img src="{$imagesource}t.gif" width="1" height="10" alt="" /><br clear="all" />
	<input type="submit" name="update" border="0" alt="Update" title="{$m_storechanges}" onclick="GenerateLocationXML();">
		<xsl:choose>
			<xsl:when test="../../MASTHEAD[.='1']"><xsl:attribute name="VALUE"><xsl:value-of select="$m_updateintroduction"/></xsl:attribute></xsl:when>
			<xsl:otherwise><xsl:attribute name="VALUE"><xsl:value-of select="$m_updateentry"/></xsl:attribute></xsl:otherwise>
		</xsl:choose>
	</input>
<!--
	<input type="Image" src="{$imagesource}update_inv.gif" name="update" border="0" alt="Update" title="{$m_storechanges}">
		<xsl:choose>
			<xsl:when test="MASTHEAD[.='1']"><xsl:attribute name="VALUE"><xsl:value-of select="$m_updateintroduction"/></xsl:attribute></xsl:when>
			<xsl:otherwise><xsl:attribute name="VALUE"><xsl:value-of select="$m_updateentry"/></xsl:attribute></xsl:otherwise>
		</xsl:choose>
	</input>
-->
</xsl:template>

<xsl:template match="FUNCTIONS/CHANGE-SUBMITTABLE">
	<br clear="all" /><img src="{$imagesource}t.gif" width="1" height="5" alt="" /><br clear="all" />
	<xsl:apply-templates select="/H2G2/ARTICLE-EDIT-FORM/SUBMITTABLE"/>
	<font xsl:use-attribute-sets="mainfont" class="postxt"><xsl:value-of select="$m_notforreviewtext"/></font>
	<input type="hidden" name="CanSubmit" value="1"/>
</xsl:template>

<xsl:template match="FORMAT">
	<xsl:choose>
		<xsl:when test='.="1"'>
			<INPUT TYPE="radio" NAME="newformat" VALUE="2"/><xsl:value-of select="$m_plaintext"/>
			<INPUT TYPE="radio" NAME="newformat" VALUE="1" CHECKED="yes"/><xsl:value-of select="$m_guideml"/>
		</xsl:when>
		<xsl:when test='.="2"'>
			<INPUT TYPE="radio" NAME="newformat" VALUE="2" CHECKED="yes"/><xsl:value-of select="$m_plaintext"/>
			<INPUT TYPE="radio" NAME="newformat" VALUE="1"/><xsl:value-of select="$m_guideml"/>
		</xsl:when>
	</xsl:choose>
</xsl:template>

<xsl:template match="ARTICLE-EDIT-FORM/STATUS" mode="ArticleEdit">
<br/>
<font xsl:use-attribute-sets="mainfont" class="pos">Status: <input type="text" name="status" value="{.}"/></font>
</xsl:template>

<xsl:template match="ARTICLE-EDIT-FORM/EDITORID" mode="ArticleEdit">
<br/>
<font xsl:use-attribute-sets="mainfont" class="pos">Editor: <input type="text" name="editor" value="{.}"/></font>
</xsl:template>



</xsl:stylesheet>
