<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
	<!ENTITY darr "&#8595;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-	microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<!--
	*******************************************************************************************
	*******************************************************************************************
	This xsl file controls the functionality of the board promos area of the config system. This includes creating, editing, deleting
	and specifying the location of board promos for the board
	*******************************************************************************************
	*******************************************************************************************
	-->
	<!--
	*******************************************************************************************
	*******************************************************************************************
	The included js file runs the buttons used in the text box area that add bold, underline and italic tags to the content text.
	
	The first piece of javascript opens the popups for the previews.
	
	The second function adds alerts to the deleting process.
	
	The final javascript below is used in the board promo location process. It enables and disables the default selection system.
	*******************************************************************************************
	*******************************************************************************************
	-->
	<xsl:template name="MESSAGEBOARDPROMOPAGE_JAVASCRIPT">
		<script language="JavaScript" src="http://www.bbc.co.uk/dnaimages/adminsystem/includes/textboxapp.js"/>
		<script type="text/javascript">
		function openSamplePreview(type) {
			openPreview('http://www.bbc.co.uk/dnaimages/boards/images/' + type + '_sample.gif', 400, 400);	
			return false;	
		}
		
		function deleteConfirm(name, id, key) {			
			var answer = confirm("Are you sure you want to delete this promo?")
			if (answer){
				alert(name + " deleted");
				window.location = '<xsl:value-of select="$root"/>boardpromos?action=delete&amp;promoid=' + id + '&amp;editkey=' + key;
			}
       		else {
       			return false;
       		}       		
		}
		
		function defaultEnable() {
			for(i=0;i &lt; document.setdefaultpromo.defaultpromoid.length; i++){
				if (document.setdefaultpromo.defaultpromoid[i].disabled == true) {
					document.setdefaultpromo.defaultpromoid[i].disabled = false;
					document.getElementById('promolist').style.background = '#ffffff';
				}else {
					document.setdefaultpromo.defaultpromoid[i].disabled = true;
					document.getElementById('promolist').style.background = '#dddddd';
				}
			}
		}
		</script>
	</xsl:template>
	<!--
	<xsl:template name="MESSAGEBOARDPROMOPAGE_HEADER">
	Author:		Andy Harris
	Context:      H2G2
	Purpose:	 Creates the title for the page which sits in the html header
	-->
	<xsl:template name="MESSAGEBOARDPROMOPAGE_HEADER">
		<xsl:apply-templates mode="header" select=".">
			<xsl:with-param name="title">
				<xsl:value-of select="$m_pagetitlestart"/>
				Board Promos
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>
	<!--
	<xsl:template name="MESSAGEBOARDPROMOPAGE_SUBJECT">
	Author:		Andy Harris
	Context:      H2G2
	Purpose:	 Creates the text for the subject
	-->
	<xsl:template name="MESSAGEBOARDPROMOPAGE_SUBJECT">
		<xsl:call-template name="SUBJECTHEADER">
			<xsl:with-param name="text">
				Board Promos
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
									Page - Level  template
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<!--
	*******************************************************************************************
	*******************************************************************************************
	The MAINBODY template checks the value of the PAGE attribute and selects the appropriate template for the stage of the
	process that the editor is in.
	
	It also includes the call to the error template which is contained in the HTMLOutput file.
	*******************************************************************************************
	*******************************************************************************************
	-->
	<xsl:template name="MESSAGEBOARDPROMOPAGE_MAINBODY">
		<xsl:choose>
			<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_view']/VALUE = 'setdefault'">
				<xsl:apply-templates select="BOARDPROMOPAGE/BOARDPROMOLIST" mode="choose_default"/>
			</xsl:when>
			<xsl:when test="BOARDPROMOPAGE/@PAGE='boardpromolist'">
				<xsl:apply-templates select="BOARDPROMOPAGE/BOARDPROMOLIST" mode="promolist"/>
			</xsl:when>
			<xsl:when test="BOARDPROMOPAGE/@PAGE='promoname'">
				<xsl:apply-templates select="BOARDPROMOPAGE/BOARDPROMOLIST/BOARDPROMO[@EDITSTATUS = 'ACTIVE']" mode="choose_name"/>
			</xsl:when>
			<xsl:when test="BOARDPROMOPAGE/@PAGE='choosetype'">
				<xsl:apply-templates select="BOARDPROMOPAGE/BOARDPROMOLIST/BOARDPROMO[@EDITSTATUS = 'ACTIVE']" mode="choose_type"/>
			</xsl:when>
			<xsl:when test="BOARDPROMOPAGE/@PAGE='choosetemplate'">
				<xsl:apply-templates select="BOARDPROMOPAGE/BOARDPROMOLIST/BOARDPROMO[@EDITSTATUS = 'ACTIVE']" mode="choose_template"/>
			</xsl:when>
			<xsl:when test="BOARDPROMOPAGE/@PAGE='textandimage'">
				<xsl:apply-templates select="BOARDPROMOPAGE/BOARDPROMOLIST/BOARDPROMO[@EDITSTATUS = 'ACTIVE']" mode="choose_text"/>
			</xsl:when>
			<xsl:when test="BOARDPROMOPAGE/@PAGE='setlocation'">
				<xsl:apply-templates select="BOARDPROMOPAGE/BOARDPROMOLIST/BOARDPROMO[@EDITSTATUS = 'ACTIVE']" mode="choose_location"/>
			</xsl:when>
		</xsl:choose>
		<xsl:apply-templates select="ERROR" mode="error_popup"/>
	</xsl:template>
	<!--
	<xsl:template match="BOARDPROMOLIST" mode="choose_default">
	Author:		Andy Harris
	Context:      H2G2/BOARDPROMOPAGE/BOARDPROMOLIST
	Purpose:	 Creates the page where you select the default promo
	-->
	<xsl:template match="BOARDPROMOLIST" mode="choose_default">
		<form name="setdefaultpromo" method="post" action="{$root}boardpromos">
			<div id="subNav" style="background:#f4ebe4 url({$adminimagesource}icon_content.gif) 0px 2px no-repeat;">
				<div id="subNavText">
					<h1>Board Promos - set a default promo</h1>
				</div>
			</div>
			<div id="instructional">
				<p>The default promo will appear on all message boards pages that have no other promos assigned to them.</p>
			</div>
			<div id="contentArea">
				<div class="centralAreaRight">
					<div class="header">
						<img src="{$adminimagesource}t_l.gif" alt=""/>
					</div>
					<div class="centralArea">
						<input type="hidden" name="action" value="setdefaultpromo"/>
						<input type="hidden" name="s_finishreturnto" value="{/H2G2/PARAMS/PARAM[NAME = 's_finishreturnto']/VALUE}"/>
						<input type="checkbox" name="enabledefault" id="enabledefault" onclick="defaultEnable();">
							<xsl:if test="BOARDPROMO/DEFAULTSITEPROMO = 1">
								<xsl:attribute name="checked">checked</xsl:attribute>
							</xsl:if>
						</input> Enable default promo<br/>
						<br/>
						<br/>
						<h3 class="adminFormHeader">Promo name</h3>
						<br/>
						<br/>
						<div id="promolist">
							<xsl:for-each select="BOARDPROMO">
								<input type="radio" name="defaultpromoid" value="{ELEMENTID}">
									<xsl:if test="DEFAULTSITEPROMO = 1"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if>
								</input>
								<xsl:text> </xsl:text>
								<xsl:value-of select="NAME"/>
								<br/>
							</xsl:for-each>
						</div>
						<br/>
						<br/>
						<xsl:if test="not(BOARDPROMO/DEFAULTSITEPROMO = 1)">
							<script type="text/javascript">
								defaultEnable();
							</script>
						</xsl:if>
					</div>
					<div class="footer">
						<div class="shadedDivider">
							<hr/>
						</div>
						<span class="buttonLeftA">						
							<div class="buttonThreeD">
								<a href="{$root}boardpromos">&lt; &lt; Back</a>
							</div>
						</span>
							<input type="submit" value="Save default promo settings &gt;&gt;" class="buttonThreeD" id="buttonRightInput"/>
						<br /><br />
						
						<img src="{$adminimagesource}b_l.gif" alt=""/>
					</div>
				</div>
			</div>
		</form>
	</xsl:template>
	<!--
	<xsl:template match="BOARDPROMOLIST" mode="promolist">
	Author:		Andy Harris
	Context:      H2G2/BOARDPROMOPAGE/BOARDPROMOLIST
	Purpose:	 Creates the default board promo page which is a list of promos
	-->
	<xsl:template match="BOARDPROMOLIST" mode="promolist">
		<div id="subNav" style="background:#f4ebe4 url({$adminimagesource}icon_content.gif) 0px 2px no-repeat;">
			<div id="subNavText">
				<h1>Board Promos</h1>
			</div>
		</div>
		<div id="instructional">
			<p>Board promos appear on topic and discussion pages.</p>
			<p>You can create different promos for each topic area.</p>
		</div>
		<div id="contentArea">
			<div class="centralAreaRight">
				<div class="header">
					<img src="{$adminimagesource}t_l.gif" alt=""/>
				</div>
				<div class="centralArea">
					<table border="0" class="dataStriped" summary="Features that can be enabled on the board" style="width:720px;">
						<thead>
							<tr>
								<th scope="col">
									Promo name
								</th>
								<th class="dataStatus">
									Status
								</th>
								<th>
									Location
								</th>
								<th class="dataStatus">
									Edit?
								</th>
								<th>
									Delete?
								</th>
							</tr>
						</thead>
						<tbody>
							<xsl:choose>
								<xsl:when test="BOARDPROMO">
									<xsl:apply-templates select="BOARDPROMO" mode="promolist"/>
								</xsl:when>
								<xsl:otherwise>
									<tr class="stripeOne">
										<td scope="row">
											Currently there are no promos
										</td>
										<td class="dataStatus">
											&nbsp;
										</td>
										<td>
											&nbsp;
										</td>
										<td class="dataStatus">
											&nbsp;
										</td>
										<td>
											&nbsp;
										</td>
									</tr>
								</xsl:otherwise>
							</xsl:choose>
						</tbody>
					</table><br />
					<div class="buttonThreeD" style="margin-left:538px;">
							<a href="{$root}boardpromos?s_view=setdefault">Default promo settings..</a>
						</div>
				</div>
				<div class="footer">
					<div class="shadedDivider">
						<hr/>
					</div>					
					<span class="buttonLeftA">	
						<div class="buttonThreeD">
							<a href="{$root}messageboardadmin">&lt; &lt; Back</a>
						</div>
					</span>
						<span class="buttonRightA">
						<div class="buttonThreeD">
							<a href="{$root}boardpromos?promoid=0&amp;page=promoname">Add new promo &gt; &gt;</a>
						</div>
						</span>
					<br /><br />					<img src="{$adminimagesource}b_l.gif" alt=""/>
				</div>
			</div>
		</div>
	</xsl:template>
	<!--
	<xsl:template match="BOARDPROMO" mode="promolist">
	Author:		Andy Harris
	Context:      H2G2/BOARDPROMOPAGE/BOARDPROMOLIST/BOARDPROMO
	Purpose:	 Deals with the appearance of each promo on the promo list
	-->
	<xsl:template match="BOARDPROMO" mode="promolist">
		<xsl:choose>
			<xsl:when test="count(preceding-sibling::BOARDPROMO) mod 2 = 0">
				<tr class="stripeOne">
					<td scope="row">
						<xsl:value-of select="NAME"/>
					</td>
					<td class="dataStatus" style="text-align:left;">
						<xsl:choose>
							<xsl:when test="DEFAULTSITEPROMO = 1">Default promo</xsl:when>
							<xsl:when test="string-length(TOPICLOCATIONS) = 0">Unassigned</xsl:when>
							<xsl:otherwise>
								<xsl:for-each select="TOPICLOCATIONS/TOPICID">
									<xsl:value-of select="/H2G2/BOARDPROMOPAGE/TOPICLIST/TOPIC[TOPICID = current()]/TITLE"/>
									<xsl:if test="following-sibling::TOPICID">
										<xsl:text>, </xsl:text>
									</xsl:if>
								</xsl:for-each>
							</xsl:otherwise>
						</xsl:choose>
					</td>
					<td>
						<a href="{$root}boardpromos?page=setlocation&amp;promoid={ELEMENTID}" style="color:#000000;">
							Set Location...
						</a>
					</td>
					<td class="dataStatus" style="text-align:left;">
						<a href="{$root}boardpromos?page=promoname&amp;promoid={ELEMENTID}" style="color:#000000;">
							Edit...
						</a>
					</td>
					<td>
						<a href="#" onclick="deleteConfirm('{NAME}', '{ELEMENTID}', '{EDITKEY}');" style="color:#000000;">
							Delete
						</a>
					</td>
				</tr>
			</xsl:when>
			<xsl:otherwise>
				<tr class="stripeTwo">
					<td scope="row">
						<xsl:value-of select="NAME"/>
					</td>
					<td class="dataStatus" style="text-align:left;">
						<xsl:choose>
							<xsl:when test="DEFAULTSITEPROMO = 1">Default promo</xsl:when>
							<xsl:when test="string-length(TOPICLOCATIONS) = 0">Unassigned</xsl:when>
							<xsl:otherwise>
								<xsl:for-each select="TOPICLOCATIONS/TOPICID">
									<xsl:value-of select="/H2G2/BOARDPROMOPAGE/TOPICLIST/TOPIC[TOPICID = current()]/TITLE"/>
									<xsl:if test="following-sibling::TOPICID">
										<xsl:text>, </xsl:text>
									</xsl:if>
								</xsl:for-each>
							</xsl:otherwise>
						</xsl:choose>
					</td>
					<td>
						<a href="{$root}boardpromos?page=setlocation&amp;promoid={ELEMENTID}" style="color:#000000;">
							Set Location...
						</a>
					</td>
					<td class="dataStatus" style="text-align:left;">
						<a href="{$root}boardpromos?page=promoname&amp;promoid={ELEMENTID}" style="color:#000000;">
							Edit...
						</a>
					</td>
					<td>
						<a href="#" onclick="deleteConfirm('{NAME}', '{ELEMENTID}', '{EDITKEY}');" style="color:#000000;">
							Delete
						</a>
					</td>
				</tr>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="BOARDPROMO" mode="choose_name">
	Author:		Andy Harris
	Context:    H2G2/BOARDPROMOPAGE/BOARDPROMOLIST/BOARDPROMO
	Purpose:	 Form for setting the name of the promo.
	-->
	<xsl:template match="BOARDPROMO" mode="choose_name">
		<form name="choosename" method="post" action="{$root}boardpromos">
			<div id="subNav" style="background:#f4ebe4 url({$adminimagesource}icon_content.gif) 0px 2px no-repeat;">
				<div id="subNavText">
					<h1>Board Promos - Add New Board Promo - Name</h1>
				</div>
			</div>
			<br/>
			<div id="contentArea">
				<div class="centralAreaRight">
					<div class="header">
						<img src="{$adminimagesource}t_l.gif" alt=""/>
					</div>
					<div class="centralArea">
						<h3 class="adminFormHeader">Enter promo name</h3> (this is only used internally)<br/>
						<input type="hidden" name="promoid" value="{ELEMENTID}"/>
						<input type="hidden" name="editkey" value="{EDITKEY}"/>
						<input type="hidden" name="action" value="setname"/>
						<input type="hidden" name="page" value="choosetype"/>
						<input type="hidden" name="s_finishreturnto" value="{/H2G2/PARAMS/PARAM[NAME = 's_finishreturnto']/VALUE}"/>
						<!--<input type="hidden" name="skin" value="purexml"/>-->
						<input name="promoname" size="50">
							<xsl:attribute name="value"><xsl:value-of select="NAME"/></xsl:attribute>
						</input>
					</div>
					<div class="footer">
						<div class="shadedDivider">
							<hr/>
						</div>
							<span class="buttonLeftA"><div class="buttonThreeD">
								<a href="{$root}boardpromos">&lt; &lt; Back</a>
							</div></span>
							<input type="submit" value="Next &gt;&gt;" class="buttonThreeD" id="buttonRightInput"/>
							<br /><br />
						<img src="{$adminimagesource}b_l.gif" alt=""/>
					</div>
				</div>
			</div>
		</form>
	</xsl:template>
	<!--
	<xsl:template match="BOARDPROMO" mode="choose_type">
	Author:		Andy Harris
	Context:    H2G2/BOARDPROMOPAGE/BOARDPROMOLIST/BOARDPROMO
	Purpose:	 Form for changing the boardpromo type.
	-->
	<xsl:template match="BOARDPROMO" mode="choose_type">
		<form name="choosetype" method="post" action="{$root}boardpromos">
			<div id="subNav" style="background:#f4ebe4 url({$adminimagesource}icon_content.gif) 0px 2px no-repeat;">
				<div id="subNavText">
					<h1>Board Promos - Add New Board Promo - Type</h1>
				</div>
			</div>
			<br/>
			<div id="contentArea">
				<div class="centralAreaRight">
					<div class="header">
						<img src="{$adminimagesource}t_l.gif" alt=""/>
					</div>
					<div class="centralArea">
						<h2 class="adminFormHeader ">
							Board Promo: <xsl:value-of select="NAME"/> - Choose Type
						</h2>
						<br/>
						<br/>
						<input type="hidden" name="promoid" value="{ELEMENTID}"/>
						<input type="hidden" name="editkey" value="{EDITKEY}"/>
						<input type="hidden" name="action" value="choosetype"/>
						<xsl:choose>
							<xsl:when test="TEXTBOXTYPE = 3">
								<input type="hidden" name="page" value="textandimage"/>
							</xsl:when>
							<xsl:otherwise>
								<input type="hidden" name="page" value="choosetemplate"/>
							</xsl:otherwise>
						</xsl:choose>
						<input type="hidden" name="s_finishreturnto" value="{/H2G2/PARAMS/PARAM[NAME = 's_finishreturnto']/VALUE}"/>
						<p>
							<input type="radio" name="type" value="1" onclick="promoSelected();">
								<xsl:if test="TEXTBOXTYPE=1">
									<xsl:attribute name="checked">checked</xsl:attribute>
								</xsl:if>
							</input>
							<span style="font-weight:bold;" class="adminText">Promo box</span>
							<br/>
							(text, images, links, quote boxes, etc)
						</p>
						<!--<p>
							<input type="radio" name="type" value="2">
								<xsl:if test="TEXTBOXTYPE=2">
									<xsl:attribute name="checked">checked</xsl:attribute>
								</xsl:if>
							</input>
							<span style="font-weight:bold;" class="adminText">DNA-generated box</span>
							<br/>
							(busiest conversations, editors pick, etc)
						</p>-->
						<p>
							<input type="radio" name="type" value="3" onclick="guideMLSelected();">
								<xsl:if test="TEXTBOXTYPE=3">
									<xsl:attribute name="checked">checked</xsl:attribute>
								</xsl:if>
							</input>
							<span style="font-weight:bold;" class="adminText">Code your own in GuideML</span>
							<a href="http://www.bbc.co.uk/dnaimages/boards/guideml_popup.html" target="_blank" onclick="openPreview('http://www.bbc.co.uk/dnaimages/boards/guideml_popup.html', 600, 400); return false;">
								<img src="{$adminimagesource}questionmark.gif" alt="Whats this?" width="20" height="20" border="0" hspace="5"/>
							</a>
							<br/>
						</p>
						<br/>
					</div>
					<div class="footer">
						<div class="shadedDivider">
							<hr/>
						</div>
							<span class="buttonLeftA"><div class="buttonThreeD">
								<a href="{$root}boardpromos?promoid={ELEMENTID}&amp;page=promoname">&lt; &lt; Back</a>
							</div></span>
							<input type="submit" value="Next &gt;&gt;" class="buttonThreeD" id="buttonRightInput"/>
							<br /><br />
						<img src="{$adminimagesource}b_l.gif" alt=""/>
					</div>
				</div>
			</div>
		</form>
	</xsl:template>
	<!--
	<xsl:template name="BOARDPROMO">
	Author:		Andy Harris
	Context:    H2G2/BOARDPROMOPAGE/BOARDPROMOLIST/BOARDPROMO
	Purpose:	 Form for changing the boardpromo template.
	-->
	<xsl:template match="BOARDPROMO" mode="choose_template">
		<form name="choosetemplate" method="post" action="{$root}boardpromos">
			<div id="subNav" style="background:#f4ebe4 url({$adminimagesource}icon_content.gif) 0px 2px no-repeat;">
				<div id="subNavText">
					<h1>Board Promos - Add New Board Promo - Choose Template</h1>
				</div>
			</div>
			<br/>
			<div id="contentArea">
				<div class="centralAreaRight">
					<div class="header">
						<img src="{$adminimagesource}t_l.gif" alt=""/>
					</div>
					<div class="centralArea">
						<input type="hidden" name="promoid" value="{ELEMENTID}"/>
						<input type="hidden" name="editkey" value="{EDITKEY}"/>
						<input type="hidden" name="action" value="choosetemplate"/>
						<input type="hidden" name="s_finishreturnto" value="{/H2G2/PARAMS/PARAM[NAME = 's_finishreturnto']/VALUE}"/>
						<xsl:choose>
							<xsl:when test="TEXTBOXTYPE = 2">
								<input type="hidden" name="_redirect" value="boardpromos"/>
							</xsl:when>
							<xsl:otherwise>
								<input type="hidden" name="page" value="textandimage"/>
							</xsl:otherwise>
						</xsl:choose>
						<xsl:choose>
							<xsl:when test="TEXTBOXTYPE = 1">
								<h2 class="adminText">
									<xsl:value-of select="NAME"/> - Choose promo box template
								</h2>
								<br/>
								<div style="text-align:center;">
									<div style="display:inline;margin-right:40px;">
										<input type="radio" name="template" value="1">
											<xsl:if test="TEMPLATETYPE=1">
												<xsl:attribute name="checked">checked</xsl:attribute>
											</xsl:if>
										</input>
										<img src="{$adminimagesource}textbox_layout1.gif" width="111" height="117" alt="textbox layout 1" align="top"/>
									</div>
									<div style="display:inline;margin:0px 40px;">
										<input type="radio" name="template" value="2">
											<xsl:if test="TEMPLATETYPE=2">
												<xsl:attribute name="checked">checked</xsl:attribute>
											</xsl:if>
										</input>
										<img src="{$adminimagesource}textbox_layout2.gif" width="111" height="117" alt="textbox layout 2" align="top"/>
									</div>
									<div style="display:inline;margin-left:40px;">
										<input type="radio" name="template" value="3">
											<xsl:if test="TEMPLATETYPE=3">
												<xsl:attribute name="checked">checked</xsl:attribute>
											</xsl:if>
										</input>
										<img src="{$adminimagesource}textbox_layout3.gif" width="111" height="117" alt="textbox layout 3" align="top"/>
									</div>
									<br/>
									<br/>
									<div style="display:inline;margin-right:40px;">
										<input type="radio" name="template" value="4">
											<xsl:if test="TEMPLATETYPE=4">
												<xsl:attribute name="checked">checked</xsl:attribute>
											</xsl:if>
										</input>
										<img src="{$adminimagesource}textbox_layout4.gif" width="111" height="117" alt="textbox layout 4" align="top"/>
									</div>
									<div style="display:inline;margin:0px 40px;">
										<input type="radio" name="template" value="5">
											<xsl:if test="TEMPLATETYPE=5">
												<xsl:attribute name="checked">checked</xsl:attribute>
											</xsl:if>
										</input>
										<img src="{$adminimagesource}textbox_layout5.gif" width="111" height="117" alt="textbox layout 5" align="top"/>
									</div>
									<div style="display:inline;margin-left:40px;">
										<input type="radio" name="template" value="6">
											<xsl:if test="TEMPLATETYPE=6">
												<xsl:attribute name="checked">checked</xsl:attribute>
											</xsl:if>
										</input>
										<img src="{$adminimagesource}textbox_layout6.gif" width="111" height="117" alt="textbox layout 6" align="top"/>
									</div>
								</div>
							</xsl:when>
							<xsl:when test="TEXTBOXTYPE = 2">
								<h2 class="adminText">
									<xsl:value-of select="NAME"/> - Choose DNA-generated box template:
								</h2>
								<br/>
								<p>
									<input type="radio" name="template" value="1">
										<xsl:if test="TEMPLATETYPE=1">
											<xsl:attribute name="checked">checked</xsl:attribute>
										</xsl:if>
									</input>
									<span style="font-weight:bold;" class="adminText">Top 5 busiest topics</span>
									<br/>
									(calculated on total number of messages in the last 12 hours)
									<p class="small">
										<a href="http://www.bbc.co.uk/dnaimages/boards/images/busiest_sample.gif" onclick="return openSamplePreview('busiest');" target="_blank">See sample preview</a>
									</p>
								</p>
								<br/>
								<p>
									<input type="radio" name="template" value="2">
										<xsl:if test="TEMPLATETYPE=2">
											<xsl:attribute name="checked">checked</xsl:attribute>
										</xsl:if>
									</input>
									<span style="font-weight:bold;" class="adminText">Top 5 most recently created discussions</span>
									<br/>
									(calculated on discussions started in the last 1 hour)	
									<p class="small">
										<a href="http://www.bbc.co.uk/dnaimages/boards/images/recent_sample.gif" onclick="return openSamplePreview('recent');" target="_blank">See sample preview</a>
									</p>
								</p>
								<br/>
								<p>
									<input type="radio" name="template" value="3">
										<xsl:if test="TEMPLATETYPE=3">
											<xsl:attribute name="checked">checked</xsl:attribute>
										</xsl:if>
									</input>
									<span style="font-weight:bold;" class="adminText">Top 5 busiest discussions</span>
									<br/>
									(calculated on total number of messages in the last 1 hour)
									<p class="small">
										<a href="http://www.bbc.co.uk/dnaimages/boards/images/busiest_hour_sample.gif" onclick="return openSamplePreview('busiest_hour');" target="_blank">See sample preview</a>
									</p>
								</p>
							</xsl:when>
						</xsl:choose>
						<br/>
					</div>
					<div class="footer">
						<div class="shadedDivider">
							<hr/>
						</div>
						<span class="buttonLeftA"><div class="buttonThreeD">
								<a href="{$root}boardpromos?promoid={ELEMENTID}&amp;page=choosetype">&lt; &lt; Back</a>
							</div></span>
							<input type="submit" value="Next &gt;&gt;" class="buttonThreeD" id="buttonRightInput"/>
							<br /><br />						
						<img src="{$adminimagesource}b_l.gif" alt=""/>
					</div>
				</div>
			</div>
		</form>
	</xsl:template>
	<!--
	<xsl:template match="BOARDPROMO" mode="choose_text">
	Author:		Andy Harris
	Context:    H2G2/BOARDPROMOPAGE/BOARDPROMOLIST/BOARDPROMO
	Purpose:	 Form for changing the boardpromo text.
	-->
	<xsl:template match="BOARDPROMO" mode="choose_text">
		<form name="textandimage" method="post" action="{$root}boardpromos">
			<div id="subNav" style="background:#f4ebe4 url({$adminimagesource}icon_content.gif) 0px 2px no-repeat;">
				<div id="subNavText">
					<h1>Board Promos - Add New Board Promo -<br/> Promo Text</h1>
				</div>
			</div>
			<br/>
			<div id="contentArea">
				<div class="centralAreaRight">
					<div class="header">
						<img src="{$adminimagesource}t_l.gif" alt=""/>
					</div>
					<div class="centralArea">
						<xsl:variable name="fields">
							<xsl:choose>
								<xsl:when test="TEXTBOXTYPE = 3 or TEMPLATETYPE = 1"><![CDATA[<MULTI-INPUT>
					<REQUIRED NAME='TITLE'></REQUIRED>
					<REQUIRED NAME='TEXT'><VALIDATE TYPE='EMPTY'/></REQUIRED>
					<REQUIRED NAME='IMAGENAME'></REQUIRED>	
					<REQUIRED NAME='IMAGEWIDTH'></REQUIRED>
					<REQUIRED NAME='IMAGEHEIGHT'></REQUIRED>	
					<REQUIRED NAME='IMAGEALTTEXT'></REQUIRED>			
					</MULTI-INPUT>]]></xsl:when>
								<xsl:when test="TEMPLATETYPE = 2"><![CDATA[<MULTI-INPUT>
					<REQUIRED NAME='TITLE'></REQUIRED>
					<REQUIRED NAME='TEXT'></REQUIRED>
					<REQUIRED NAME='IMAGENAME'><VALIDATE TYPE='EMPTY'/></REQUIRED>
					<REQUIRED NAME='IMAGEWIDTH'><VALIDATE TYPE='EMPTY'/></REQUIRED>
					<REQUIRED NAME='IMAGEHEIGHT'><VALIDATE TYPE='EMPTY'/></REQUIRED>
					<REQUIRED NAME='IMAGEALTTEXT'><VALIDATE TYPE='EMPTY'/></REQUIRED>
					</MULTI-INPUT>]]></xsl:when>
								<xsl:otherwise><![CDATA[<MULTI-INPUT>
					<REQUIRED NAME='TITLE'></REQUIRED>
					<REQUIRED NAME='TEXT'><VALIDATE TYPE='EMPTY'/></REQUIRED>
					<REQUIRED NAME='IMAGENAME'><VALIDATE TYPE='EMPTY'/></REQUIRED>
					<REQUIRED NAME='IMAGEWIDTH'><VALIDATE TYPE='EMPTY'/></REQUIRED>
					<REQUIRED NAME='IMAGEHEIGHT'><VALIDATE TYPE='EMPTY'/></REQUIRED>
					<REQUIRED NAME='IMAGEALTTEXT'><VALIDATE TYPE='EMPTY'/></REQUIRED>
					</MULTI-INPUT>]]></xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<h2 class="adminFormHeader ">
							<xsl:value-of select="NAME"/> - Promo Text
						</h2>
						<br/>
						<br/>
						<!--<input type="hidden" name="skin" value="purexml"/>-->
						<input type="hidden" name="promoid" value="{ELEMENTID}"/>
						<input type="hidden" name="editkey" value="{EDITKEY}"/>
						<input type="hidden" name="action" value="textandimage"/>
						<input type="hidden" name="s_finishreturnto" value="{/H2G2/PARAMS/PARAM[NAME = 's_finishreturnto']/VALUE}"/>
						<input type="hidden" name="s_returnto" value="{/H2G2/PARAMS/PARAM[NAME = 's_finishreturnto']/VALUE}"/>
						<input type="hidden" name="_msxml" value="{$fields}"/>
						<input type="hidden" name="_msfinish" value="yes"/>
						
						<xsl:choose>
							<xsl:when test="TEXTBOXTYPE = 3">
								<xsl:apply-templates select="/H2G2/BOARDPROMOPAGE/MULTI-STAGE/MULTI-REQUIRED[@NAME='TEXT']/ERRORS"/>
								<textarea name="text" cols="50" rows="5" class="inputBG">
									<xsl:value-of select="/H2G2/BOARDPROMOPAGE/MULTI-STAGE/MULTI-REQUIRED[@NAME='TEXT']/VALUE-EDITABLE"/>
								</textarea>
								<br/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:if test="not(TEMPLATETYPE = 2)">
									<h3 class="adminFormHeader">Enter text (no character limit):</h3>
									<br/>
									<xsl:apply-templates select="/H2G2/BOARDPROMOPAGE/MULTI-STAGE/MULTI-REQUIRED[@NAME='TEXT']/ERRORS"/>
									<textarea name="text" cols="50" rows="5" class="inputBG">
										<xsl:value-of select="/H2G2/BOARDPROMOPAGE/MULTI-STAGE/MULTI-REQUIRED[@NAME='TEXT']/VALUE-EDITABLE"/>
									</textarea>
									<br/>
									<div class="buttonThreeD" style="margin-left:0px;">
										<a href="#" onclick="format('strong','openclose')">
											<b>B</b>
										</a>
									</div>
									<div class="buttonThreeD">
										<a href="#" onclick="format('em','openclose')">
											<em>I</em>
										</a>
									</div>
									<div class="buttonThreeD">
										<a href="#" onclick="format('u','openclose')">
											<u>U</u>
										</a>
									</div>
									<div class="buttonThreeD">
										<a href="#" onclick="format('a','link')">
											Insert hyperlink...
										</a>
									</div>
									<div class="buttonThreeD">
										<a href="#" onclick="format('titletext','openclose')">
											Title text
										</a>
									</div>
									<a href="http://www.bbc.co.uk/dnaimages/boards/titletext_popup.html" target="_blank" onclick="openPreview('http://www.bbc.co.uk/dnaimages/boards/titletext_popup.html', 600, 400); return false;">
										<img src="{$adminimagesource}questionmark.gif" alt="Whats this?" width="20" height="20" border="0" hspace="5"/>
									</a>
									<br/>
									<br/>
								</xsl:if>
								<xsl:if test="not(TEMPLATETYPE = 1)">
									<h3 class="adminFormHeader">Enter image filename:</h3>
									<br/>
									<em>This image should be published in your dev web space to ensure you can preview it here.</em>
									<br/>
									<xsl:apply-templates select="/H2G2/BOARDPROMOPAGE/MULTI-STAGE/MULTI-REQUIRED[@NAME='IMAGENAME']/ERRORS"/>
									<input name="imagename" size="50" class="inputBG">
										<xsl:attribute name="value"><xsl:value-of select="/H2G2/BOARDPROMOPAGE/MULTI-STAGE/MULTI-REQUIRED[@NAME='IMAGENAME']/VALUE-EDITABLE"/></xsl:attribute>
									</input>
									<br/>
									<br/>
									<h3 class="adminFormHeader">Image dimensions</h3> (max width is 120px)<br/>
										These need to be entered in order to comply to BBC coding standards<br/>
									<br/>
									<h3 class="adminFormHeader">Width:</h3> &nbsp;
									<input name="imagewidth" size="10" class="inputBG">
										<xsl:attribute name="value"><xsl:value-of select="/H2G2/BOARDPROMOPAGE/MULTI-STAGE/MULTI-REQUIRED[@NAME='IMAGEWIDTH']/VALUE-EDITABLE"/></xsl:attribute>
									</input> pixels<br/>
									<h3 class="adminFormHeader">Height:</h3> &nbsp; 
									<input name="imageheight" size="10" class="inputBG">
										<xsl:attribute name="value"><xsl:value-of select="/H2G2/BOARDPROMOPAGE/MULTI-STAGE/MULTI-REQUIRED[@NAME='IMAGEHEIGHT']/VALUE-EDITABLE"/></xsl:attribute>
									</input> pixels<br/>
									<xsl:apply-templates select="/H2G2/BOARDPROMOPAGE/MULTI-STAGE/MULTI-REQUIRED[@NAME='IMAGEWIDTH']/ERRORS"/>
									<xsl:apply-templates select="/H2G2/BOARDPROMOPAGE/MULTI-STAGE/MULTI-REQUIRED[@NAME='IMAGEHEIGHT']/ERRORS"/>
									<br/>
									<h3 class="adminFormHeader">Image alt text:</h3>
									<br/>
									<xsl:apply-templates select="/H2G2/BOARDPROMOPAGE/MULTI-STAGE/MULTI-REQUIRED[@NAME='IMAGEALTTEXT']/ERRORS"/>
									<input name="imagealttext" size="50" class="inputBG">
										<xsl:attribute name="value"><xsl:value-of select="/H2G2/BOARDPROMOPAGE/MULTI-STAGE/MULTI-REQUIRED[@NAME='IMAGEALTTEXT']/VALUE-EDITABLE"/></xsl:attribute>
									</input>
								</xsl:if>
								<br/>
								<br/>
							</xsl:otherwise>
						</xsl:choose>
						<h3 class="adminFormHeader">Preview</h3>
						<br/>
						<div style="padding:5px; border:dashed #000000 1px; width: 140px">
							<xsl:if test="/H2G2/BOARDPROMOPAGE/MULTI-STAGE/@CANCEL = 'YES'">
								<xsl:choose>
									<xsl:when test="/H2G2/BOARDPROMOPAGE/BOARDPROMO-PREVIEW/BOARDPROMO/TEXTBOXTYPE = 3">
										<xsl:apply-templates select="TEXT"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:choose>
											<xsl:when test="/H2G2/BOARDPROMOPAGE/BOARDPROMO-PREVIEW/BOARDPROMO/TEMPLATETYPE = 1">
												<p>
													<xsl:apply-templates select="/H2G2/BOARDPROMOPAGE/BOARDPROMO-PREVIEW/BOARDPROMO/TEXT"/>
												</p>
											</xsl:when>
											<xsl:when test="TEMPLATETYPE = 2">
												<img src="{$imagesource}{/H2G2/BOARDPROMOPAGE/BOARDPROMO-PREVIEW/BOARDPROMO/IMAGENAME}" width="{/H2G2/BOARDPROMOPAGE/BOARDPROMO-PREVIEW/BOARDPROMO/IMAGEWIDTH}" height="{/H2G2/BOARDPROMOPAGE/BOARDPROMO-PREVIEW/BOARDPROMO/IMAGEHEIGHT}" alt="{/H2G2/BOARDPROMOPAGE/BOARDPROMO-PREVIEW/BOARDPROMO/IMAGEALTTEXT}"/>
											</xsl:when>
											<xsl:when test="TEMPLATETYPE = 3">
												<img src="{$imagesource}{/H2G2/BOARDPROMOPAGE/BOARDPROMO-PREVIEW/BOARDPROMO/IMAGENAME}" width="{/H2G2/BOARDPROMOPAGE/BOARDPROMO-PREVIEW/BOARDPROMO/IMAGEWIDTH}" height="{/H2G2/BOARDPROMOPAGE/BOARDPROMO-PREVIEW/BOARDPROMO/IMAGEHEIGHT}" alt="{/H2G2/BOARDPROMOPAGE/BOARDPROMO-PREVIEW/BOARDPROMO/IMAGEALTTEXT}"/>
												<p>
													<xsl:apply-templates select="/H2G2/BOARDPROMOPAGE/BOARDPROMO-PREVIEW/BOARDPROMO/TEXT"/>
												</p>
											</xsl:when>
											<xsl:when test="TEMPLATETYPE = 4">
												<p>
													<xsl:apply-templates select="/H2G2/BOARDPROMOPAGE/BOARDPROMO-PREVIEW/BOARDPROMO/TEXT"/>
												</p>
												<img src="{$imagesource}{/H2G2/BOARDPROMOPAGE/BOARDPROMO-PREVIEW/BOARDPROMO/IMAGENAME}" width="{/H2G2/BOARDPROMOPAGE/BOARDPROMO-PREVIEW/BOARDPROMO/IMAGEWIDTH}" height="{/H2G2/BOARDPROMOPAGE/BOARDPROMO-PREVIEW/BOARDPROMO/IMAGEHEIGHT}" alt="{/H2G2/BOARDPROMOPAGE/BOARDPROMO-PREVIEW/BOARDPROMO/IMAGEALTTEXT}"/>
											</xsl:when>
											<xsl:when test="TEMPLATETYPE = 5">
												<img src="{$imagesource}{/H2G2/BOARDPROMOPAGE/BOARDPROMO-PREVIEW/BOARDPROMO/IMAGENAME}" width="{/H2G2/BOARDPROMOPAGE/BOARDPROMO-PREVIEW/BOARDPROMO/IMAGEWIDTH}" height="{/H2G2/BOARDPROMOPAGE/BOARDPROMO-PREVIEW/BOARDPROMO/IMAGEHEIGHT}" alt="{/H2G2/BOARDPROMOPAGE/BOARDPROMO-PREVIEW/BOARDPROMO/IMAGEALTTEXT}" align="left"/>	
												<p>
													<xsl:apply-templates select="/H2G2/BOARDPROMOPAGE/BOARDPROMO-PREVIEW/BOARDPROMO/TEXT"/>
												</p>
											</xsl:when>
											<xsl:when test="TEMPLATETYPE = 6">
												<img src="{$imagesource}{/H2G2/BOARDPROMOPAGE/BOARDPROMO-PREVIEW/BOARDPROMO/IMAGENAME}" width="{/H2G2/BOARDPROMOPAGE/BOARDPROMO-PREVIEW/BOARDPROMO/IMAGEWIDTH}" height="{/H2G2/BOARDPROMOPAGE/BOARDPROMO-PREVIEW/BOARDPROMO/IMAGEHEIGHT}" alt="{/H2G2/BOARDPROMOPAGE/BOARDPROMO-PREVIEW/BOARDPROMO/IMAGEALTTEXT}" align="right"/>
												<p>
													<xsl:apply-templates select="/H2G2/BOARDPROMOPAGE/BOARDPROMO-PREVIEW/BOARDPROMO/TEXT"/>
												</p>
											</xsl:when>
										</xsl:choose>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:if>
							<br clear="all"/>
						</div>
						<br/>
						<input type="submit" name="_mscancel" value="Preview promo" class="buttonThreeD" style="margin-left:265px;"/>
						<br/><br/>
						<xsl:if test="/H2G2/TEXTBOXPAGE/MULTI-STAGE/MULTI-REQUIRED[@NAME='TEXT']/ERRORS">
							Parse Errors : 
							<br/>
							<xsl:apply-templates select="/H2G2/BOARDPROMOPAGE/MULTI-STAGE/MULTI-REQUIRED[@NAME='TEXT']/ERRORS/ERROR"/>
						</xsl:if>
					</div>
					<div class="footer">
						<div class="shadedDivider">
							<hr/>
						</div>						
							<xsl:choose>
								<xsl:when test="TEXTBOXTYPE = 3">
									<span class="buttonLeftA"><div class="buttonThreeD">
										<a href="{$root}boardpromos?promoid={ELEMENTID}&amp;page=choosetype">&lt; &lt; Back</a>
									</div></span>
								</xsl:when>
								<xsl:otherwise>
									<span class="buttonLeftA"><div class="buttonThreeD">
										<a href="{$root}boardpromos?promoid={ELEMENTID}&amp;page=choosetemplate">&lt; &lt; Back</a>
									</div></span>
								</xsl:otherwise>
							</xsl:choose>
							<input type="submit" value="Save board promo &gt;&gt;" class="buttonThreeD" id="buttonRightInput"/>
							<br /><br />						
						<img src="{$adminimagesource}b_l.gif" alt=""/>
					</div>
				</div>
			</div>
		</form>
	</xsl:template>
	<!--
	<xsl:template match="BOARDPROMO" mode="choose_promotype">
	Author:		Andy Harris
	Context:    H2G2/BOARDPROMOPAGE/BOARDPROMOLIST/BOARDPROMO
	Purpose:	 Selects the correct board promo type for displaying the promos on the user facing pages themselves
	-->
	<xsl:template match="BOARDPROMO" mode="choose_promotype">
		<div id="promoContent">
			<xsl:choose>
				<xsl:when test="TEXTBOXTYPE = 3">
					<xsl:apply-templates select="TEXT"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:choose>
						<xsl:when test="TEMPLATETYPE = 1">
							<p>
								<xsl:apply-templates select="TEXT"/>
							</p>
						</xsl:when>
						<xsl:when test="TEMPLATETYPE = 2">
							<img src="{$imagesource}{IMAGENAME}" width="{IMAGEWIDTH}" height="{IMAGEHEIGHT}" alt="{IMAGEALTTEXT}"/>
						</xsl:when>
						<xsl:when test="TEMPLATETYPE = 3">
							<img src="{$imagesource}{IMAGENAME}" width="{IMAGEWIDTH}" height="{IMAGEHEIGHT}" alt="{IMAGEALTTEXT}"/>
							<p>
								<xsl:apply-templates select="TEXT"/>
							</p>
						</xsl:when>
						<xsl:when test="TEMPLATETYPE = 4">
							<p>
								<xsl:apply-templates select="TEXT"/>
							</p>
							<img src="{$imagesource}{IMAGENAME}" width="{IMAGEWIDTH}" height="{IMAGEHEIGHT}" alt="{IMAGEALTTEXT}"/>
						</xsl:when>
						<xsl:when test="TEMPLATETYPE = 5">
							<img src="{$imagesource}{IMAGENAME}" width="{IMAGEWIDTH}" height="{IMAGEHEIGHT}" alt="{IMAGEALTTEXT}"/>
							<p>
								<xsl:apply-templates select="TEXT"/>
							</p>
						</xsl:when>
						<xsl:when test="TEMPLATETYPE = 6">
							<img src="{$imagesource}{IMAGENAME}" width="{IMAGEWIDTH}" height="{IMAGEHEIGHT}" alt="{IMAGEALTTEXT}"/>
							<p>
								<xsl:apply-templates select="TEXT"/>
							</p>
						</xsl:when>
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
		</div>
	</xsl:template>
	<!--
	<xsl:template match="BOARDPROMO" mode="choose_location">
	Author:		Andy Harris
	Context:    H2G2/BOARDPROMOPAGE/BOARDPROMOLIST/BOARDPROMO
	Purpose:	 Form for changing the boardpromo location.
	-->
	<xsl:template match="BOARDPROMO" mode="choose_location">
		<form name="choosetype" method="post" action="{$root}boardpromos">
			<div id="subNav" style="background:#f4ebe4 url({$adminimagesource}icon_content.gif) 0px 2px no-repeat;">
				<div id="subNavText">
					<h1>Board Promos - Set Location for <xsl:value-of select="NAME"/>
					</h1>
				</div>
			</div>
			<div id="instructional">
				<p>
					Choose where you would like this promo to appear
				</p>
			</div>
			<div id="contentArea">
				<div class="centralAreaRight">
					<div class="header">
						<img src="{$adminimagesource}t_l.gif" alt=""/>
					</div>
					<div class="centralArea">
						<div style="width:200px;padding:5px;border:1px #000000 solid;">
							<h3 class="adminFormHeader">Topics</h3>
							<br/>
							<br/>
							<div style="border:1px #000000 solid;padding:5px;">
								<input type="hidden" name="promoid" value="{ELEMENTID}"/>
								<input type="hidden" name="editkey" value="{EDITKEY}"/>
								<input type="hidden" name="action" value="setlocation"/>
								<input type="hidden" name="s_finishreturnto" value="{/H2G2/PARAMS/PARAM[NAME = 's_finishreturnto']/VALUE}"/>
								<xsl:for-each select="/H2G2/BOARDPROMOPAGE/TOPICLIST/TOPIC">
									<p>
										<input type="checkbox" name="topicid" value="{TOPICID}">
											<xsl:if test="/H2G2/BOARDPROMOPAGE/BOARDPROMOLIST/BOARDPROMO[@EDITSTATUS = 'ACTIVE']/TOPICLOCATIONS/TOPICID = TOPICID">
												<xsl:attribute name="checked">checked</xsl:attribute>
											</xsl:if>
										</input>
										<xsl:value-of select="TITLE"/>
									</p>
								</xsl:for-each>
							</div>
						</div>
					</div>
					<div class="footer">
						<div class="shadedDivider">
							<hr/>
						</div>
							<span class="buttonLeftA"><div class="buttonThreeD">
								<a href="{$root}boardpromos">&lt; &lt; Back</a>
							</div></span>
							<input type="submit" value="Save promo location &gt;&gt;" class="buttonThreeD" id="buttonRightInput"/>
							<br /><br />
						<img src="{$adminimagesource}b_l.gif" alt=""/>
					</div>
				</div>
			</div>
		</form>
	</xsl:template>
</xsl:stylesheet>
