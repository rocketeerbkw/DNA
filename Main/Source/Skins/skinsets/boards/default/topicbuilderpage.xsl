<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
	<!ENTITY darr "&#8595;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-	microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<!--
	*******************************************************************************************
	*******************************************************************************************
	This xsl file controls the functionality of the topicbuilder area of the config system. This includes creating, editing, deleting
	and changing the order of the topics for the board
	*******************************************************************************************
	*******************************************************************************************
	-->
	<!--
	*******************************************************************************************
	*******************************************************************************************
	The javascript below is used in the topic ordering process. It highlights the selected topic and changes the URL of the 
	two links so that the order can be changed.
	
	The second function adds alerts to the deleting and archiving processes.
	*******************************************************************************************
	*******************************************************************************************
	-->
	<xsl:template name="TOPICBUILDER_JAVASCRIPT">
		<script type="text/javascript">
		function change_move(topicID, editKey) {
			topicArray = [<xsl:for-each select="/H2G2/TOPIC_PAGE/TOPICLIST/TOPIC[not(TOPICSTATUS = 4)]"><xsl:value-of select="TOPICID"/><xsl:text>,</xsl:text></xsl:for-each>];
			document.getElementById('uplink').href = 'TopicBuilder?cmd=move&amp;page=positionpage&amp;direction=0&amp;editkey=' + editKey + '&amp;topicid=' + topicID + '&amp;s_finishreturnto=<xsl:value-of select="/H2G2/PARAMS/PARAM[NAME = 's_finishreturnto']/VALUE"/>';
			document.getElementById('downlink').href = 'TopicBuilder?cmd=move&amp;page=positionpage&amp;direction=1&amp;editkey=' + editKey + '&amp;topicid=' + topicID + '&amp;s_finishreturnto=<xsl:value-of select="/H2G2/PARAMS/PARAM[NAME = 's_finishreturnto']/VALUE"/>';
			for (i=0; i&lt;topicArray.length; i++) {		
				document.getElementById('topicBox' + topicArray[i]).style.background = '#ffffff';
			}
			document.getElementById('topicBox' + topicID).style.background = '#cccccc';
		}
		
		function deleteConfirm(name, id, key, path, action) {			
			if (action == "unarchive") {				
				var command = 'unarchive';
			}
			else {
				var command = 'delete';
			}
			
			var answer = confirm("Are you sure you want to " + action + " this topic?")
			
			if (answer){
				alert(name + " " + action + "d");
				window.location = '<xsl:value-of select="$root"/>topicbuilder?cmd=' + command + '&amp;topicid=' + id + '&amp;editkey=' + key + '&amp;s_finishreturnto=' + path;
			}
       		else {
       			return false;
       		}       		
		}
		</script>
	</xsl:template>
	<!--
	<xsl:template name="TOPICBUILDER_HEADER">
	Author:		Andy Harris
	Context:      H2G2
	Purpose:	 Creates the title for the page which sits in the html header
	-->
	<xsl:template name="TOPICBUILDER_HEADER">
		<xsl:apply-templates mode="header" select=".">
			<xsl:with-param name="title">
				<xsl:value-of select="$m_pagetitlestart"/>
				Topic Builder
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>
	<!--
	<xsl:template name="TOPICBUILDER_SUBJECT">
	Author:		Andy Harris
	Context:      H2G2
	Purpose:	 Creates the text for the subject
	-->
	<xsl:template name="TOPICBUILDER_SUBJECT">
		<xsl:call-template name="SUBJECTHEADER">
			<xsl:with-param name="text">
				Topic Builder
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:variable name="FrontPageTopicFields"><![CDATA[
		<MULTI-INPUT>
			<REQUIRED NAME='TITLE'><VALIDATE TYPE='EMPTY' /></REQUIRED>
			<REQUIRED NAME='DESCRIPTION' ESCAPED='texttype'><VALIDATE TYPE='EMPTY' /></REQUIRED>
			<REQUIRED NAME='TEXTTYPE' ></REQUIRED>		
			<REQUIRED NAME='TOPICID'></REQUIRED>	
			<REQUIRED NAME='EDITKEY'></REQUIRED>	
		</MULTI-INPUT>
	]]></xsl:variable>
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
									Page - Level  template
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<xsl:template name="TOPICBUILDER_MAINBODY">
		<!-- <xsl:apply-templates select="TOPIC_PAGE/ACTION" mode="recent_action"/> -->
		<xsl:choose>
			<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_view']/VALUE = 'confirmation'">
				<xsl:apply-templates select="TOPIC_PAGE" mode="confirmationpage"/>
			</xsl:when>
			<xsl:when test="TOPIC_PAGE/@PAGE='topiclist'">
				<xsl:apply-templates select="TOPIC_PAGE" mode="topiclist"/>
			</xsl:when>
			<xsl:when test="TOPIC_PAGE/@PAGE='createpage' ">
				<xsl:apply-templates select="TOPIC_PAGE" mode="topiccreate"/>
			</xsl:when>
			<xsl:when test="TOPIC_PAGE/@PAGE='editpage' ">
				<xsl:apply-templates select="TOPIC_PAGE" mode="topicedit"/>
			</xsl:when>
			<xsl:when test="TOPIC_PAGE/@PAGE='positionpage' ">
				<xsl:apply-templates select="TOPIC_PAGE" mode="topicposition"/>
			</xsl:when>
		</xsl:choose>
		<xsl:apply-templates select="ERROR" mode="error_popup"/>
	</xsl:template>
	<!--
	<xsl:template match="ACTION" mode="recent_action">
	Author:		Andy Harris
	Context:     
	Purpose:	 Displays what the last action performed by the topic builder was
	-->
	<xsl:template match="ACTION" mode="recent_action">
		<p>
			<xsl:value-of select="TYPE"/>&nbsp;&nbsp;<xsl:value-of select="OBJECT"/>
		</p>
	</xsl:template>
	<!--
	<xsl:template match="ACTION" mode="confirmationpage">
	Author:		Andy Harris
	Context:     
	Purpose:	 Displays confirmation page which allows the user to jump into the promo creation process
	-->
	<xsl:template match="TOPIC_PAGE" mode="confirmationpage">
		<div id="subNav" style="background:#f4ebe4 url({$adminimagesource}icon_content.gif) 0px 2px no-repeat;">
			<div id="subNavText">
				<h1>Topic Management / Add New Topic</h1>
			</div>
		</div>
		<br/>
		<div id="contentArea">
			<div class="centralAreaRight">
				<div class="header">
					<img src="{$adminimagesource}t_l.gif" alt=""/>
				</div>
				<div class="centralArea">
					<strong>Your topic has been created.</strong>
					<br/>
				</div>
				<div class="footer">
					<div class="shadedDivider">
						<hr/>
					</div>
					<span class="buttonLeftA">
						<div class="buttonThreeD">
							<a href="{/H2G2/PARAMS/PARAM[NAME = 's_finishreturnto']/VALUE}">&lt;&lt; Back</a>
						</div>
					</span>
					<xsl:choose>
						<xsl:when test="/H2G2/FRONTPAGE/PAGE-LAYOUT/LAYOUT &lt; 4">
							<span class="buttonRightA">
								<div class="buttonThreeD">
									<xsl:apply-templates select="TOPICLIST/TOPIC[position() = last()]" mode="makepromolink">
										<xsl:sort select="UPDATEDBY/LASTUPDATED/DATE/@SORT"/>
									</xsl:apply-templates>
								</div>
							</span>
						</xsl:when>
						<xsl:otherwise/>
					</xsl:choose>
					<br/>
					<br/>
					<img src="{$adminimagesource}b_l.gif" alt=""/>
				</div>
			</div>
		</div>
	</xsl:template>
	<xsl:template match="TOPIC" mode="makepromolink">
		<a href="{$root}frontpagetopicelementbuilder?page=createpage&amp;topicid={TOPICID}&amp;s_finishreturnto={/H2G2/PARAMS/PARAM[NAME = 's_finishreturnto']/VALUE}">Create topic promo</a>
	</xsl:template>
	<!--
	<xsl:template match="TOPIC_PAGE" mode="topiclist">
	Author:		Andy Harris
	Context:      H2G2/TOPIC_PAGE
	Purpose:	 Displays a list of the topics
	-->
	<xsl:template match="TOPIC_PAGE" mode="topiclist">
		<div id="subNav" style="background:#f4ebe4 url({$adminimagesource}icon_content.gif) 0px 2px no-repeat;">
			<div id="subNavText">
				<h1>Content Management / Topic Management</h1>
			</div>
		</div>
		<div id="instructional">
			<p>This area allows you to add, edit, and delete topics for the message boards and choose a topic promo template.</p>
			<p>Each topic has a promo which will appear on the message boards homepage.</p>
		</div>
		<div id="contentArea">
			<div class="centralAreaRight">
				<div class="header">
					<img src="{$adminimagesource}t_l.gif" alt=""/>
				</div>
				<div class="centralArea">
					<table class="dataStriped" summary="Features that can be enabled on the board" width="720">
						<thead>
							<tr class="dataHeader">
								<th scope="col">
									Topic Name
								</th>
								<th scope="col" colspan="3" style="padding-left:37px;">
									Status
								</th>
							</tr>
						</thead>
						<tbody>
							<xsl:apply-templates select="TOPICLIST/TOPIC" mode="topiclist">
								<xsl:sort select="POSITION" order="ascending"/>
							</xsl:apply-templates>
						</tbody>
					</table>
					<div style="text-align:center;padding-top:10px;">
						<div class="buttonThreeD" style="width:200px;">
							<a href="{$root}topicbuilder?page=positionpage&amp;s_finishreturnto=topicbuilder">Edit topic display order</a>
						</div>
						<br/>
						<br/>
						<div class="buttonThreeD" style="width:200px;">
							<a href="{$root}topicbuilder?page=createpage&amp;s_finishreturnto=topicbuilder">Add new topic &gt;&gt;</a>
						</div>
						<br/>
						<br/>
						<xsl:if test="not(../FRONTPAGE/PAGE-LAYOUT/ELEMTEMPLATE)">
							<div class="buttonThreeD" style="width:200px;">
								<a href="{$root}FrontPageLayout?s_updatelayout=yes&amp;s_finishreturnto=topicbuilder">Select topic promo template</a>
							</div>
						</xsl:if>
					</div>
				</div>
				<div class="footer">
					<div class="shadedDivider">
						<hr/>
					</div>
					<div style="padding:10px;text-align:right;">
						<div class="buttonThreeD">
							<a>
								<xsl:attribute name="href"><xsl:choose><xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_finishreturnto'] and not(/H2G2/PARAMS/PARAM[NAME = 's_finishreturnto']/VALUE = '') and not(/H2G2/PARAMS/PARAM[NAME = 's_finishreturnto']/VALUE = 'topicbuilder')"><xsl:value-of select="/H2G2/PARAMS/PARAM[NAME = 's_finishreturnto']/VALUE"/></xsl:when><xsl:otherwise>messageboardadmin</xsl:otherwise></xsl:choose></xsl:attribute>
								Exit Topic Management &gt;&gt;
							</a>
						</div>
					</div>
					<img src="{$adminimagesource}b_l.gif" alt=""/>
				</div>
			</div>
		</div>
	</xsl:template>
	<!--
	<xsl:template match="TOPIC" mode="topiclist">
	Author:		Andy Harris
	Context:      H2G2/TOPIC_PAGE/TOPICLIST/TOPIC
	Purpose:	 Displays an individual topic
	-->
	<xsl:template match="TOPIC" mode="topiclist">
		<xsl:choose>
			<xsl:when test="count(preceding-sibling::TOPIC) mod 2 = 0">
				<tr class="stripeOne">
					<td>
						<xsl:value-of select="TITLE"/>
					</td>
					<td class="dataStatus">
						<xsl:choose>
							<xsl:when test="(TOPICSTATUS = 1) and TOPICLINKID and not(TOPICLINKID = 0)">Live</xsl:when>
							<xsl:when test="TOPICSTATUS = 4">Archived</xsl:when>
							<xsl:otherwise>Published</xsl:otherwise>
						</xsl:choose>
					</td>
					<td class="dataCenter">
						<xsl:choose>
							<xsl:when test="TOPICSTATUS = 4">&nbsp;</xsl:when>
							<xsl:otherwise>
								<a href="{$root}topicbuilder?page=editpage&amp;topicid={TOPICID}&amp;s_finishreturnto=topicbuilder" style="color:#000000;">Edit</a>
							</xsl:otherwise>
						</xsl:choose>
					</td>
					<td class="dataLeftLine" style="text-align:center;">
						<a href="#">
							<xsl:attribute name="onclick">deleteConfirm(&quot;<xsl:value-of select="TITLE"/>&quot;,&quot;<xsl:value-of select="TOPICID"/>&quot;,&quot;<xsl:value-of select="EDITKEY"/>&quot;,&quot;<xsl:choose><xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_finishreturnto']/VALUE"><xsl:value-of select="/H2G2/PARAMS/PARAM[NAME = 's_finishreturnto']/VALUE"/></xsl:when><xsl:otherwise><xsl:value-of select="$root"/></xsl:otherwise></xsl:choose>&quot;, &quot;<xsl:choose><xsl:when test="(TOPICSTATUS = 1) and TOPICLINKID and not(TOPICLINKID = 0)">archive</xsl:when><xsl:when test="TOPICSTATUS = 4">unarchive</xsl:when><xsl:otherwise>Delete</xsl:otherwise></xsl:choose>&quot;);</xsl:attribute>
							<xsl:choose>
								<xsl:when test="(TOPICSTATUS = 1) and TOPICLINKID and not(TOPICLINKID = 0)">Archive</xsl:when>
								<xsl:when test="TOPICSTATUS = 4">Unarchive</xsl:when>
								<xsl:otherwise>Delete</xsl:otherwise>
							</xsl:choose>
						</a>
					</td>
				</tr>
			</xsl:when>
			<xsl:otherwise>
				<tr class="stripeTwo">
					<td>
						<xsl:value-of select="TITLE"/>
					</td>
					<td class="dataStatus">
						<xsl:choose>
							<xsl:when test="(TOPICSTATUS = 1) and TOPICLINKID and not(TOPICLINKID = 0)">Live</xsl:when>
							<xsl:when test="TOPICSTATUS = 4">Archived</xsl:when>
							<xsl:otherwise>Published</xsl:otherwise>
						</xsl:choose>
					</td>
					<td class="dataCenter">
						<xsl:choose>
							<xsl:when test="TOPICSTATUS = 4">&nbsp;</xsl:when>
							<xsl:otherwise>
								<a href="{$root}topicbuilder?page=editpage&amp;topicid={TOPICID}&amp;s_finishreturnto=topicbuilder" style="color:#000000;">Edit</a>
							</xsl:otherwise>
						</xsl:choose>
					</td>
					<td class="dataLeftLine" style="text-align:center;">
						<a href="#">
							<xsl:attribute name="onclick">deleteConfirm(&quot;<xsl:value-of select="TITLE"/>&quot;,&quot;<xsl:value-of select="TOPICID"/>&quot;,&quot;<xsl:value-of select="EDITKEY"/>&quot;,&quot;<xsl:choose><xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_finishreturnto']/VALUE"><xsl:value-of select="/H2G2/PARAMS/PARAM[NAME = 's_finishreturnto']/VALUE"/></xsl:when><xsl:otherwise><xsl:value-of select="$root"/></xsl:otherwise></xsl:choose>&quot;, &quot;<xsl:choose><xsl:when test="(TOPICSTATUS = 1) and TOPICLINKID and not(TOPICLINKID = 0)">archive</xsl:when><xsl:when test="TOPICSTATUS = 4">unarchive</xsl:when><xsl:otherwise>Delete</xsl:otherwise></xsl:choose>&quot;);</xsl:attribute>
							<xsl:choose>
								<xsl:when test="(TOPICSTATUS = 1) and TOPICLINKID and not(TOPICLINKID = 0)">Archive</xsl:when>
								<xsl:when test="TOPICSTATUS = 4">Unarchive</xsl:when>
								<xsl:otherwise>Delete</xsl:otherwise>
							</xsl:choose>
						</a>
					</td>
				</tr>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="TOPIC_PAGE" mode="topiccreate">
	Author:		Andy Harris
	Context:      H2G2/TOPIC_PAGE
	Purpose:	 Form for entering topic information
	-->
	<xsl:template match="TOPIC_PAGE" mode="topiccreate">
		<form action="TopicBuilder" method="post">
			<div id="subNav" style="background:#f4ebe4 url({$adminimagesource}icon_content.gif) 0px 2px no-repeat;">
				<div id="subNavText">
					<h1>Topic Management / Add New Topic</h1>
				</div>
			</div>
			<br/>
			<div id="contentArea">
				<div class="centralAreaRight">
					<div class="header">
						<img src="{$adminimagesource}t_l.gif" alt=""/>
					</div>
					<div class="centralArea">
						<p>
							<xsl:apply-templates select="MULTI-STAGE/MULTI-REQUIRED/ERRORS"/>
						</p>
						<!--<input type="hidden" name="skin" value="purexml"/>-->
						<input type="hidden" name="_msfinish" value="yes"/>
						<input type="hidden" name="_msstage" value="1"/>
						<input type="hidden" name="_msxml" value="{$FrontPageTopicFields}"/>
						<input type="hidden" name="texttype" value="1"/>
						<input type="hidden" name="cmd" value="create"/>
						<input type="hidden" name="s_returnto" value="topicbuilder?s_view=confirmation"/>
						<input type="hidden" name="s_finishreturnto" value="{/H2G2/PARAMS/PARAM[NAME = 's_finishreturnto']/VALUE}"/>
						Enter topic title<br/>
						<input type="text" name="title" size="80" class="inputBG">
							<xsl:attribute name="value"><xsl:value-of select="MULTI-STAGE/MULTI-REQUIRED[@NAME='TITLE']/VALUE-EDITABLE"/></xsl:attribute>
						</input>
						<br/>
						<br/>
						Topic description (appears at top of topic list page)
						<textarea name="text" cols="70" rows="4" class="inputBG">
							<xsl:value-of select="MULTI-STAGE/MULTI-REQUIRED[@NAME='TEXT']/VALUE-EDITABLE"/>
						</textarea>
					</div>
					<div class="footer">
						<div class="shadedDivider">
							<hr/>
						</div>
						<span class="buttonLeftA">
							<div class="buttonThreeD">
								<a href="{/H2G2/PARAMS/PARAM[NAME = 's_finishreturnto']/VALUE}">&lt;&lt; Back</a>
							</div>
						</span>
						<input type="submit" name="save" value="Save topic &gt;&gt;" class="buttonThreeD" id="buttonRightInput"/>
						<br/>
						<br/>
						<img src="{$adminimagesource}b_l.gif" alt=""/>
					</div>
				</div>
			</div>
		</form>
	</xsl:template>
	<!--
	<xsl:template match="TOPIC_PAGE" mode="topiccreate">
	Author:		Andy Harris
	Context:      H2G2/TOPIC_PAGE
	Purpose:	 Form for editing topic information
	-->
	<xsl:template match="TOPIC_PAGE" mode="topicedit">
		<form action="TopicBuilder" method="post">
			<div id="subNav" style="background:#f4ebe4 url({$adminimagesource}icon_content.gif) 0px 2px no-repeat;">
				<div id="subNavText">
					<h1>Topic Management / Edit Topic</h1>
				</div>
			</div>
			<br/>
			<div id="contentArea">
				<div class="centralAreaRight">
					<div class="header">
						<img src="{$adminimagesource}t_l.gif" alt=""/>
					</div>
					<div class="centralArea">
						<strong>
							<xsl:apply-templates select="MULTI-STAGE/MULTI-REQUIRED/ERRORS"/>
						</strong>
						<!--<input type="hidden" name="skin" value="purexml"/>-->
						<input type="hidden" name="_msfinish" value="yes"/>
						<input type="hidden" name="_msstage" value="1"/>
						<input type="hidden" name="_msxml" value="{$FrontPageTopicFields}"/>
						<input type="hidden" name="texttype" value="1"/>
						<input type="hidden" name="cmd" value="edit"/>
						<xsl:choose>
							<xsl:when test="not(TOPIC/FP_ELEMENTID = 0)">
								<input type="hidden" name="s_returnto" value="frontpagetopicelementbuilder?page=editpage&amp;elementid={TOPIC/FP_ELEMENTID}&amp;s_finishreturnto={/H2G2/PARAMS/PARAM[NAME = 's_finishreturnto']/VALUE}">
									<xsl:choose>
										<xsl:when test="/H2G2/FRONTPAGE/PAGE-LAYOUT/LAYOUT &lt; 4">
											<xsl:attribute name="value">frontpagetopicelementbuilder?page=editpage&amp;elementid=<xsl:value-of select="TOPIC/FP_ELEMENTID"/>&amp;s_finishreturnto=<xsl:value-of select="/H2G2/PARAMS/PARAM[NAME = 's_finishreturnto']/VALUE"/></xsl:attribute>
										</xsl:when>
										<xsl:otherwise>
											<xsl:attribute name="value"><xsl:value-of select="/H2G2/PARAMS/PARAM[NAME = 's_finishreturnto']/VALUE"/></xsl:attribute>
										</xsl:otherwise>
									</xsl:choose>
								</input>
							</xsl:when>
							<xsl:otherwise>
								<input type="hidden" name="s_returnto" value="frontpagetopicelementbuilder?page=createpage&amp;topicid={TOPIC/TOPICID}&amp;s_finishreturnto={/H2G2/PARAMS/PARAM[NAME = 's_finishreturnto']/VALUE}"/>
							</xsl:otherwise>
						</xsl:choose>
						<input type="hidden" name="s_finishreturnto" value="{/H2G2/PARAMS/PARAM[NAME = 's_finishreturnto']/VALUE}"/>
						<input type="hidden" name="editkey">
							<xsl:attribute name="value"><xsl:choose><xsl:when test="MULTI-STAGE"><xsl:value-of select="MULTI-STAGE/MULTI-REQUIRED[@NAME='EDITKEY']/VALUE-EDITABLE"/></xsl:when><xsl:otherwise><xsl:value-of select="TOPIC/EDITKEY"/></xsl:otherwise></xsl:choose></xsl:attribute>
						</input>
						<input type="hidden" name="topicid">
							<xsl:attribute name="value"><xsl:choose><xsl:when test="MULTI-STAGE"><xsl:value-of select="MULTI-STAGE/MULTI-REQUIRED[@NAME='TOPICID']/VALUE-EDITABLE"/></xsl:when><xsl:otherwise><xsl:value-of select="TOPIC/TOPICID"/></xsl:otherwise></xsl:choose></xsl:attribute>
						</input>
						Enter topic title<br/>
						<input type="text" name="title" size="80" class="inputBG">
							<xsl:attribute name="value"><xsl:choose><xsl:when test="MULTI-STAGE"><xsl:value-of select="MULTI-STAGE/MULTI-REQUIRED[@NAME='TITLE']/VALUE-EDITABLE"/></xsl:when><xsl:otherwise><xsl:value-of select="TOPIC/TITLE"/></xsl:otherwise></xsl:choose></xsl:attribute>
						</input>
						<br/>
						<br/>
						Topic description (appears at top of topic list page)
						<textarea name="text" cols="70" rows="4" class="inputBG">
							<xsl:choose>
								<xsl:when test="MULTI-STAGE">
									<xsl:value-of select="MULTI-STAGE/MULTI-REQUIRED[@NAME='TEXT']/VALUE-EDITABLE"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="TOPIC/TEXT"/>
								</xsl:otherwise>
							</xsl:choose>
						</textarea>
						<br/>
					</div>
					<div class="footer">
						<div class="shadedDivider">
							<hr/>
						</div>
						<span class="buttonLeftA">
							<div class="buttonThreeD">
								<a href="{$root}topicbuilder?s_finishreturnto={/H2G2/PARAMS/PARAM[NAME = 's_finishreturnto']/VALUE}">&lt;&lt; Back</a>
							</div>
						</span>
						<input type="submit" name="save" value="Save topic &gt;&gt;" class="buttonThreeD" id="buttonRightInput"/>
						<br/>
						<br/>
						<img src="{$adminimagesource}b_l.gif" alt=""/>
					</div>
				</div>
			</div>
		</form>
	</xsl:template>
	<!--
	<xsl:template match="TOPIC_PAGE" mode="topicposition">
	Author:		Andy Harris
	Context:      H2G2/TOPIC_PAGE
	Purpose:	 Form for changing the topic position information
	-->
	<xsl:template match="TOPIC_PAGE" mode="topicposition">
		<div id="subNav" style="background:#f4ebe4 url({$adminimagesource}icon_content.gif) 0px 2px no-repeat;">
			<div id="subNavText">
				<h1>Topic Management / Edit Topic Display Order</h1>
			</div>
		</div>
		<div id="instructional">
			<p>Choose the order that topics will be displayed on the message boards home and in the navigation bar.</p>
		</div>
		<div id="contentArea">
			<div class="centralAreaRight">
				<div class="header">
					<img src="{$adminimagesource}t_l.gif" alt=""/>
				</div>
				<div class="centralArea">
					<div style="border:1px solid #000000;width:175px;padding:5px;">
						<div style="border:1px solid #000000;padding:5px;">
							<xsl:apply-templates select="TOPICLIST/TOPIC[not(TOPICSTATUS = 4)]" mode="move_list"/>
						</div>
						<a href="#" id="uplink">
							<img src="{$adminimagesource}topic_up.gif" alt="Up" width="25" height="26" border="0" style="margin-top:5px;display:inline;"/>
						</a>
						<a href="#" id="downlink">
							<img src="{$adminimagesource}topic_down.gif" alt="Down" width="25" height="26" border="0" style="margin:5px 0px 0px 113px;"/>
						</a>
					</div>
				</div>
				<div class="footer">
					<div class="shadedDivider">
						<hr/>
					</div>
					<div style="padding:10px;margin-left:320px;">
						<div class="buttonThreeD">
							<a href="{$root}topicbuilder?s_finishreturnto={/H2G2/PARAMS/PARAM[NAME = 's_finishreturnto']/VALUE}">&lt;&lt; Back</a>
						</div>
					</div>
					<img src="{$adminimagesource}b_l.gif" alt=""/>
				</div>
			</div>
		</div>
	</xsl:template>
	<!--
	<xsl:template match="TOPIC_PAGE" mode="topicposition">
	Author:		Andy Harris
	Context:      H2G2/TOPIC_PAGE/TOPICLIST/TOPIC
	Purpose:	 Individual topics on the move list
	-->
	<xsl:template match="TOPIC" mode="move_list">
		<div id="topicBox{TOPICID}" onclick="change_move({TOPICID}, '{EDITKEY}');">
			<xsl:value-of select="TITLE"/>
		</div>
	</xsl:template>
</xsl:stylesheet>
