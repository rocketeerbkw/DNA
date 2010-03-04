<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<xsl:import href="../../../base/base-multipostspage.xsl"/>
	<!-- Creates link to CSS for each topic area -->
	<xsl:template name="MULTIPOSTS_CSS">
		<xsl:if test="string-length(/H2G2/FORUMSOURCE/ARTICLE/GUIDE/AREACSS) &gt; 0">
			<LINK TYPE="text/css" REL="stylesheet" HREF="{/H2G2/FORUMSOURCE/ARTICLE/GUIDE/AREACSS/node()}"/>
		</xsl:if>
		<!--<style type="text/css">		  	
      		#commentList p {float: left; margin: 5px 0 0 0; width: 635px;}      
      		#commentList img {float: left; margin: 5px 5px 5px 0;}
      		#commentList h2.firstArticle {border: 0;}
      		#commentList p.firstArticle {width: 350px; margin: 5px; width: 410px;}      
      		#commentList img.firstArticle {}
      		#commentList a.firstArticle {float: left; margin: 5px;}
      		#commentList .comment {clear: both; padding: 10px 0 0 0; margin: 5px 0 0 0; border-top: 1px dotted #999999;}
      		#commentList .reply {float: left; width: 200px; padding-bottom: 5px;}
      		#commentList .complain {float: right; width: 200px; text-align: right; padding-bottom: 5px;}
      		#commentList .reply img {float: none; width: auto;}
      		#commentList .complain img {float: none; width: auto;}
      		#commentList .closedTitle {float: none; clear: both; background: #ffffff; color: #fc7302; font-weight: bold; padding: 3px; width: 100%; border: 1px solid #fc7302; margin: 0px;}
      		#commentList .commentTitle {float: none; clear: both; background: #fc7302; color: #000000; font-weight: bold; padding: 3px; width: 100%; margin: 0px; border: 1px solid #fc7302;}
      		#commentList .tablenavtext {clear:both; border-top: 1px #fc7302 dotted; border-bottom: 1px #fc7302 dotted; padding: 5px; margin: 5px;}
      		#commentList .clear {clear:both;}
    	</style>-->
	</xsl:template>
	<!--
	<xsl:template name="FRONTPAGE_HEADER">
	Author:		Andy Harris
	Context:      /H2G2
	Purpose:	 Creates the title for the page which sits in the html header
	-->
	<xsl:template name="MULTIPOSTS_HEADER">
		<xsl:apply-templates mode="header" select=".">
			<xsl:with-param name="title">
				BBC - MESSAGE BOARDS - <xsl:value-of select="/H2G2/SITECONFIG/BOARDNAME"/> - <xsl:value-of select="/H2G2/FORUMTHREADPOSTS/POST[1]/SUBJECT"/> - Conversation
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
									Page - Level  template
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<xsl:template name="MULTIPOSTS_MAINBODY">
		<xsl:if test="((/H2G2/VIEWING-USER/USER/GROUPS/EDITOR and /H2G2/VIEWING-USER/USER/GROUPS/MODERATOR)  or ($superuser = 1)) and (/H2G2/CURRENTSITEURLNAME = 'mb606' or /H2G2/CURRENTSITEURLNAME = 'mbtms' or /H2G2/CURRENTSITEURLNAME = 'mbfansforum' or /H2G2/CURRENTSITEURLNAME = 'mbscrumv')">
			<script type="text/javascript">
				<xsl:comment>
					function moderatePost(eventObj)
					{
						// Get the div associated with the post that is going to contain the moderation ui.
						var modDiv = eventObj.parentNode;
						var sElementID = modDiv.getAttribute('id');
			
						// Get the postid of the post on which the moderate button was pressed.
						var iPostID = sElementID.substr(sElementID .lastIndexOf('_')+1);
			
						// Get the moderation form.
						var objModerationForm = document.getElementById('failpostform');
			
						// Update form's postid
						var hiddenInputPostId = document.getElementById('failpost_postid');
						hiddenInputPostId.setAttribute('value', iPostID);
						
						// Make the form visible and insert it into the post's moderation div.
						changeObjectDisplayStyle('emailtype', 'block')
						modDiv.appendChild(objModerationForm);
					}
					function processEmailType(eventObj)
					{
						
						return changeObjectDisplayStyle('failpostprocessbutton', 'block');
					}
					function changeObjectDisplayStyle(objectId, newDisplayStyle) 
					{
					 	// first get the object's stylesheet
					   var styleObject = document.getElementById(objectId).style;
					
					    // then if we find a stylesheet, set its display style as requested
					    if (styleObject) {
						styleObject.display = newDisplayStyle;
						return true;
					    } else {
						return false;
					    }
					}
				</xsl:comment>
			</script>
			<xsl:apply-templates select="FORUMTHREADPOSTS" mode="r_failpostform"/>
		</xsl:if>
		<xsl:if test="(/H2G2/TOPICLIST/TOPIC[FORUMID=/H2G2/FORUMTHREADPOSTS/@FORUMID]) or (not(/H2G2/TOPICLIST/TOPIC[FORUMID=/H2G2/FORUMTHREADPOSTS/@FORUMID]) and (/H2G2/FORUMTHREADPOSTS/@DEFAULTCANWRITE = 0))">
			<!--<xsl:choose>
				<xsl:when test="/H2G2/FORUMSOURCE/ARTICLE/GUIDE/BODY/EDITORONLY">
					<div id="commentList">
						<h2 class="firstArticle">
							<xsl:value-of select="FORUMTHREADPOSTS/POST[position() = 1]/SUBJECT"/>
						</h2>
						<img src="http://newsimg.bbc.co.uk/media/images/41412000/jpg/_41412049_freddie203.jpg" alt="" width="203" height="152" class="firstArticle"/>
						<p class="firstArticle">
							<xsl:apply-templates select="FORUMTHREADPOSTS/POST[position() = 1]" mode="t_postbodymp"/>
						</p>
						<xsl:apply-templates select="FORUMTHREADPOSTS/POST[position() = 1]/@POSTID" mode="c_replytopost"/>
						<xsl:if test="(/H2G2/FORUMTHREADPOSTS/@CANWRITE = 0) and (/H2G2/VIEWING-USER/USER)">
							<p class="closedTitle">
								<xsl:text>THIS CONVERSATION IS CLOSED</xsl:text>
							</p>
						</xsl:if>
						<p class="commentTitle">
							<xsl:text>COMMENTS</xsl:text>
						</p>
						<xsl:apply-templates select="FORUMTHREADPOSTS/POST[not(position() = 1)]" mode="editoronly_commentlist"/>
						<xsl:choose>
							<xsl:when test="FORUMTHREADPOSTS/@TOTALPOSTCOUNT &lt; FORUMTHREADPOSTS/@COUNT">&nbsp;</xsl:when>
							<xsl:otherwise>
								<div class="tablenavtext">
									<xsl:choose>
										<xsl:when test="FORUMTHREADPOSTS/@TOTALPOSTCOUNT &lt; FORUMTHREADPOSTS/@COUNT * 3">
											<xsl:apply-templates select="FORUMTHREADPOSTS/@SKIPTO" mode="c_gotoprevious"/>
											<xsl:apply-templates select="FORUMTHREADPOSTS" mode="c_postblocks"/>
											<xsl:apply-templates select="FORUMTHREADPOSTS/@SKIPTO" mode="c_gotonext"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:apply-templates select="FORUMTHREADPOSTS/@SKIPTO" mode="c_gotobeginning"/>
											<xsl:text> | </xsl:text>
											<xsl:apply-templates select="FORUMTHREADPOSTS/@SKIPTO" mode="c_gotoprevious"/>
											<xsl:apply-templates select="FORUMTHREADPOSTS" mode="c_postblocks"/>
											<xsl:apply-templates select="FORUMTHREADPOSTS/@SKIPTO" mode="c_gotonext"/>
											<xsl:text> | </xsl:text>
											<xsl:apply-templates select="FORUMTHREADPOSTS/@SKIPTO" mode="c_gotolatest"/>
										</xsl:otherwise>
									</xsl:choose>
								</div>
							</xsl:otherwise>
						</xsl:choose>
					</div>
				</xsl:when>
				<xsl:otherwise>-->
			<table width="635" cellpadding="0" cellspacing="0" border="0" id="main">
				<tr>
					<td id="crumbtrail">
						<h5>
							<xsl:text>You are here &gt; </xsl:text>
							<a href="{$homepage}">
								<xsl:value-of select="/H2G2/SITECONFIG/BOARDNAME"/> message boards</a> &gt; <a href="{$root}F{/H2G2/FORUMTHREADS/@FORUMID}">
								<xsl:value-of select="FORUMSOURCE/ARTICLE/SUBJECT"/>
							</a> &gt; <xsl:value-of select="/H2G2/FORUMTHREADPOSTS/FIRSTPOSTSUBJECT"/>
						</h5>
					</td>
				</tr>
				<tr>
					<td class="pageheader">
						<table width="635" border="0" cellpadding="0" cellspacing="0">
							<tr>
								<td id="subject">
									<h1>
										<xsl:value-of select="FORUMSOURCE/ARTICLE/SUBJECT"/>
									</h1>
								</td>
								<td id="rulesHelp">
									<p>
										<a href="{$houserulespopupurl}" onclick="popupwindow('{$houserulespopupurl}', 'popwin', 'status=1,resizable=1,scrollbars=1,width=440,height=380');return false;" target="popwin" title="This link opens in a new popup window">House rules</a>  | <a href="{$faqpopupurl}" onclick="popupwindow('{$faqpopupurl}', 'popwin', 'status=1,resizable=1,scrollbars=1,toolbar=1,width=550,height=380');return false;" target="popwin" title="This link opens in a new popup window">Help</a>
									</p>
								</td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td align="right" class="pageheader">
						<div>
							<xsl:choose>
								<xsl:when test="/H2G2/FORUMTHREADPOSTS/@DEFAULTCANWRITE = 1">
									<xsl:if test="(/H2G2/VIEWING-USER/USER/GROUPS/EDITOR)  or ($superuser = 1)">
										<a href="{$root}F{/H2G2/FORUMTHREADPOSTS/@FORUMID}?thread={/H2G2/FORUMTHREADPOSTS/@THREADID}&amp;cmd=closethread">
											<img src="http://www.bbc.co.uk/dnaimages/boards/images/button_close.gif" alt="Close this thread" width="137" height="23" border="0" vspace="5" hspace="5"/>
										</a>
									</xsl:if>
								</xsl:when>
								<xsl:when test="/H2G2/FORUMTHREADPOSTS/@DEFAULTCANWRITE = 0">
									<img src="http://www.bbc.co.uk/dnaimages/boards/images/button_closed.gif" alt="This thread has been closed" width="183" height="23" border="0" vspace="5" hspace="5"/>
									<xsl:if test="(/H2G2/VIEWING-USER/USER/GROUPS/EDITOR)  or ($superuser = 1)">
										<a href="{$root}F{/H2G2/FORUMTHREADPOSTS/@FORUMID}?thread={/H2G2/FORUMTHREADPOSTS/@THREADID}&amp;cmd=reopenthread">
											<img src="http://www.bbc.co.uk/dnaimages/boards/images/button_open.gif" alt="Open this thread" width="139" height="23" border="0" vspace="5" hspace="0"/>
										</a>
										<br clear="all"/>
										<p>(If you are an editor you will still see the reply buttons) &nbsp;</p>
									</xsl:if>
								</xsl:when>
							</xsl:choose>
						</div>
					</td>
				</tr>
				<tr>
					<td width="635" align="right">
						<table width="630" cellpadding="0" cellspacing="0" border="0">
							<tr>
								<td valign="bottom" width="500">
									<table cellspacing="0" cellpadding="0" border="0" width="500">
										<tr>
											<td id="discussionTitle">
												<br/>
												<p>Discussion:</p>
												<h2>
													<xsl:choose>
														<xsl:when test="string-length(/H2G2/FORUMTHREADPOSTS/FIRSTPOSTSUBJECT) = 0">
															<xsl:text>No Discussion Title</xsl:text>
														</xsl:when>
														<xsl:otherwise>
															<xsl:value-of select="/H2G2/FORUMTHREADPOSTS/FIRSTPOSTSUBJECT"/>
															<br/>
														</xsl:otherwise>
													</xsl:choose>
												</h2>
											</td>
											<td valign="bottom" class="discussions">
												<h4>
													<span class="strong">Messages</span>  &nbsp;<xsl:value-of select="FORUMTHREADPOSTS/@SKIPTO + FORUMTHREADPOSTS/POST[1]/@INDEX + 1"/> - <xsl:value-of select="FORUMTHREADPOSTS/@SKIPTO + FORUMTHREADPOSTS/POST[position()=last()]/@INDEX + 1"/> of <xsl:value-of select="FORUMTHREADPOSTS/@TOTALPOSTCOUNT"/>
												</h4>
											</td>
										</tr>
									</table>
								</td>
								<td width="130">&nbsp;</td>
							</tr>
							<tr>
								<td valign="top" width="500">
									<table cellspacing="0" cellpadding="0" border="0" width="500" id="content">
										<tr>
											<td class="tablenavbarTop" width="500" colspan="3">
												<div class="tablenavtext">
													<xsl:choose>
														<xsl:when test="FORUMTHREADPOSTS/@TOTALPOSTCOUNT &lt; FORUMTHREADPOSTS/@COUNT">&nbsp;</xsl:when>
														<xsl:otherwise>
															<xsl:choose>
																<xsl:when test="FORUMTHREADPOSTS/@TOTALPOSTCOUNT &lt; FORUMTHREADPOSTS/@COUNT * 3">
																	<xsl:apply-templates select="FORUMTHREADPOSTS/@SKIPTO" mode="c_gotoprevious"/>
																	<xsl:apply-templates select="FORUMTHREADPOSTS" mode="c_postblocks"/>
																	<xsl:apply-templates select="FORUMTHREADPOSTS/@SKIPTO" mode="c_gotonext"/>
																</xsl:when>
																<xsl:otherwise>
																	<xsl:apply-templates select="FORUMTHREADPOSTS/@SKIPTO" mode="c_gotobeginning"/>
																	<xsl:text> | </xsl:text>
																	<xsl:apply-templates select="FORUMTHREADPOSTS/@SKIPTO" mode="c_gotoprevious"/>
																	<xsl:apply-templates select="FORUMTHREADPOSTS" mode="c_postblocks"/>
																	<xsl:apply-templates select="FORUMTHREADPOSTS/@SKIPTO" mode="c_gotonext"/>
																	<xsl:text> | </xsl:text>
																	<xsl:apply-templates select="FORUMTHREADPOSTS/@SKIPTO" mode="c_gotolatest"/>
																</xsl:otherwise>
															</xsl:choose>
														</xsl:otherwise>
													</xsl:choose>
												</div>
											</td>
										</tr>
										<tr>
											<th colspan="3">
												<xsl:text>&nbsp;</xsl:text>
											</th>
										</tr>
										<xsl:apply-templates select="FORUMTHREADPOSTS" mode="c_multiposts"/>
										<tr>
											<td class="tablenavbarBtm" colspan="3">
												<div class="tablenavtext">
													<xsl:choose>
														<xsl:when test="FORUMTHREADPOSTS/@TOTALPOSTCOUNT &lt; FORUMTHREADPOSTS/@COUNT">&nbsp;</xsl:when>
														<xsl:otherwise>
															<xsl:choose>
																<xsl:when test="FORUMTHREADPOSTS/@TOTALPOSTCOUNT &lt; FORUMTHREADPOSTS/@COUNT * 3">
																	<xsl:apply-templates select="FORUMTHREADPOSTS/@SKIPTO" mode="c_gotoprevious"/>
																	<xsl:apply-templates select="FORUMTHREADPOSTS" mode="c_postblocks"/>
																	<xsl:apply-templates select="FORUMTHREADPOSTS/@SKIPTO" mode="c_gotonext"/>
																</xsl:when>
																<xsl:otherwise>
																	<xsl:apply-templates select="FORUMTHREADPOSTS/@SKIPTO" mode="c_gotobeginning"/>
																	<xsl:text> | </xsl:text>
																	<xsl:apply-templates select="FORUMTHREADPOSTS/@SKIPTO" mode="c_gotoprevious"/>
																	<xsl:apply-templates select="FORUMTHREADPOSTS" mode="c_postblocks"/>
																	<xsl:apply-templates select="FORUMTHREADPOSTS/@SKIPTO" mode="c_gotonext"/>
																	<xsl:text> | </xsl:text>
																	<xsl:apply-templates select="FORUMTHREADPOSTS/@SKIPTO" mode="c_gotolatest"/>
																</xsl:otherwise>
															</xsl:choose>
														</xsl:otherwise>
													</xsl:choose>
												</div>
											</td>
										</tr>
									</table>
								</td>
								<td valign="top" id="promoArea">
									<xsl:if test="not(/H2G2/CURRENTSITEURLNAME = 'mbcbbc' or /H2G2/CURRENTSITEURLNAME = 'mbnewsround')">
										<table cellspacing="0" cellpadding="1" border="0" width="120" class="promoTable">
											<tr>
												<td class="blockSide" colspan="2"/>
												<td>
													<img src="http://www.bbc.co.uk/f/t.gif" width="1" height="1" alt=""/>
												</td>
											</tr>
											<tr>
												<td class="blockSide"/>
												<td class="blockMain">
													<img src="http://www.bbc.co.uk/dnaimages/boards/images/help_icon_involved.gif" width="15" height="15" alt="Getting Involved help:" title="Getting Involved help:" align="top" border="0"/>
													<xsl:text> How to </xsl:text>
													<a href="http://www.bbc.co.uk/messageboards/newguide/popup_reply_message.html" onclick="popupwindow('http://www.bbc.co.uk/messageboards/newguide/popup_reply_message.html', 'popwin', 'status=1,resizable=1,scrollbars=1,width=440,height=380');return false;" target="popwin">
														<xsl:text>reply to messages</xsl:text>
														<img src="http://www.bbc.co.uk/dnaimages/boards/images/popup.gif" width="20" height="15" alt="This link opens in a new popup window" title="" align="top" border="0"/>
													</a>
												</td>
												<td class="blockShadow"/>
											</tr>
											<tr>
												<td>
													<img src="http://www.bbc.co.uk/f/t.gif" width="1" height="1" alt=""/>
												</td>
												<td class="blockShadow" colspan="2"/>
											</tr>
										</table>
										<table cellspacing="0" cellpadding="1" border="0" width="120" class="promoTable">
											<tr>
												<td class="blockSide" colspan="2"/>
												<td>
													<img src="http://www.bbc.co.uk/f/t.gif" width="1" height="1" alt=""/>
												</td>
											</tr>
											<tr>
												<td class="blockSide"/>
												<td class="blockMain">
													<img src="http://www.bbc.co.uk/dnaimages/boards/images/complain_icon_small.gif" width="23" height="16" alt="Complain help:" title="Complain help:" align="top" border="0"/>
													<xsl:text> </xsl:text>
													<a href="http://www.bbc.co.uk/messageboards/newguide/popup_complaints.html" onclick="popupwindow('http://www.bbc.co.uk/messageboards/newguide/popup_complaints.html', 'popwin', 'status=1,resizable=1,scrollbars=1,width=440,height=380');return false;" target="popwin">
														<xsl:text>Alert us about a message</xsl:text>
														<img src="http://www.bbc.co.uk/dnaimages/boards/images/popup.gif" width="20" height="15" alt="This link opens in a new popup window" title="" align="top" border="0"/>
													</a>
												</td>
												<td class="blockShadow"/>
											</tr>
											<tr>
												<td>
													<img src="http://www.bbc.co.uk/f/t.gif" width="1" height="1" alt=""/>
												</td>
												<td class="blockShadow" colspan="2"/>
											</tr>
										</table>
										<table cellspacing="0" cellpadding="1" border="0" width="120" class="promoTable">
											<tr>
												<td class="blockSide" colspan="2"/>
												<td>
													<img src="http://www.bbc.co.uk/f/t.gif" width="1" height="1" alt=""/>
												</td>
											</tr>
											<tr>
												<td class="blockSide"/>
												<td class="blockMain">
													<img src="http://www.bbc.co.uk/dnaimages/boards/images/help_icon_safety.gif" width="15" height="15" alt="Online Safety help:" title="Online Safety help:" align="top" border="0"/>
													<xsl:text> Are you being </xsl:text>
													<a href="http://www.bbc.co.uk/messageboards/newguide/popup_online_safety.html" onclick="popupwindow('http://www.bbc.co.uk/messageboards/newguide/popup_online_safety.html', 'popwin', 'status=1,resizable=1,scrollbars=1,width=440,height=380');return;false;" target="popwin">
														<xsl:text>safe online?</xsl:text>
														<img src="http://www.bbc.co.uk/dnaimages/boards/images/popup.gif" width="20" height="15" alt="This link opens in a new popup window" title="" align="top" border="0"/>
													</a>
												</td>
												<td class="blockShadow"/>
											</tr>
											<tr>
												<td>
													<img src="http://www.bbc.co.uk/f/t.gif" width="1" height="1" alt=""/>
												</td>
												<td class="blockShadow" colspan="2"/>
											</tr>
										</table>
									</xsl:if>
									<xsl:apply-templates select="FORUMSOURCE/ARTICLE/BOARDPROMO" mode="choose_promotype"/>
								</td>
							</tr>
							<tr>
								<td class="discussions" valign="top" width="500">
									<h4>
										<span class="strong">Messages</span>  &nbsp;<xsl:value-of select="FORUMTHREADPOSTS/@SKIPTO + FORUMTHREADPOSTS/POST[1]/@INDEX + 1"/> - <xsl:value-of select="FORUMTHREADPOSTS/@SKIPTO + FORUMTHREADPOSTS/POST[position()=last()]/@INDEX + 1"/> of <xsl:value-of select="FORUMTHREADPOSTS/@TOTALPOSTCOUNT"/>
									</h4>
								</td>
								<td width="130">&nbsp;<br/>
									<br/>
								</td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
			<!--</xsl:otherwise>
			</xsl:choose>-->
		</xsl:if>
	</xsl:template>
	<xsl:variable name="mpsplit" select="10"/>
	<!-- 
	<xsl:template match="FORUMTHREADPOSTS" mode="r_postblocks">
	Use: Container for the complete list of post blocks
	-->
	<xsl:template match="FORUMTHREADPOSTS" mode="r_postblocks">
		<xsl:apply-templates select="." mode="c_blockdisplayprev"/>
		<xsl:apply-templates select="." mode="c_blockdisplay"/>
		<xsl:apply-templates select="." mode="c_blockdisplaynext"/>
	</xsl:template>
	<!-- 
	<xsl:template match="FORUMTHREADPOSTS" mode="r_blockdisplayprev">
	Use: Presentation of previous link
	-->
	<xsl:template match="FORUMTHREADPOSTS" mode="r_blockdisplayprev">
		<xsl:apply-imports/>
	</xsl:template>
	<!-- 
	<xsl:template match="FORUMTHREADPOSTS" mode="r_blockdisplaynext">
	Use: Presentation of next link
	-->
	<xsl:template match="FORUMTHREADPOSTS" mode="r_blockdisplaynext">
		<xsl:apply-imports/>
	</xsl:template>
	<!-- STOLEN FROM BASE TO GET SPACES IN
	<xsl:template match="FORUMTHREADPOSTS" mode="r_blockdisplaynext">
	Author:		Andy Harris
	Context:      /H2G2/FORUMTHREADPOSTS
	Purpose:	 Creates the next link in the thread blocks navigation
	-->
	<xsl:template match="FORUMTHREADPOSTS" mode="r_blockdisplaynext">
		<a href="{$root}F{@FORUMID}?thread={@THREADID}&amp;skip={$mp_upperrange + @COUNT}&amp;show={@COUNT}" xsl:use-attribute-sets="mFORUMTHREADPOSTS_r_blockdisplaynext">
			<xsl:copy-of select="$m_postblocknext"/>
		</a>&nbsp;
	</xsl:template>
	<!-- 
	<xsl:template match="FORUMTHREADS" mode="on_blockdisplay">
	Use: Controls the display of the block (outside the link) which is currently appearing on the page
	-->
	<xsl:template match="FORUMTHREADPOSTS" mode="on_blockdisplay">
		<xsl:param name="url"/>
		<xsl:copy-of select="$url"/>&nbsp;
	</xsl:template>
	<!-- 
	<xsl:template name="t_ontabcontent">
	Use: Controls the content of the link for the currently visible page
	-->
	<xsl:template name="t_ontabcontent">
		<xsl:param name="range"/>
		<xsl:param name="pagenumber"/>
		<xsl:value-of select="$pagenumber"/>
	</xsl:template>
	<!-- 
	<xsl:template match="FORUMTHREADS" mode="off_blockdisplay">
	Use: Controls the display of the block (outside the link) which is not currently on the page
	-->
	<xsl:template match="FORUMTHREADPOSTS" mode="off_blockdisplay">
		<xsl:param name="url"/>
		<xsl:copy-of select="$url"/>&nbsp;
	</xsl:template>
	<!-- 
	<xsl:template name="t_offtabcontent">
	Use: Controls the content of the link for other pages in the currently visible range
	-->
	<xsl:template name="t_offtabcontent">
		<xsl:param name="range"/>
		<xsl:param name="pagenumber"/>
		<xsl:value-of select="$pagenumber"/>
	</xsl:template>
	<xsl:attribute-set name="mFORUMTHREADPOSTS_on_blockdisplay">
		<xsl:attribute name="id">active</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="mFORUMTHREADPOSTS_off_blockdisplay">
		<xsl:attribute name="class">inactive</xsl:attribute>
	</xsl:attribute-set>
	<!--
	THE FOLLOWING IS THE OLD WAY OF MAKING THE POST BLOCKS THAT ALLOW YOU
	TO NAVIGATE AROUND ONE THREAD. THEY ARE PROBABLY STILL VIABLE BUT
	THE NEW VERSION SHOULD BE USED IF AT ALL POSSIBLE
	-->
	<!-- 
	<xsl:template match="FORUMTHREADPOSTS" mode="r_postblocks">
	Use: Container for the complete list of post blocks
	-->
	<!--<xsl:template match="FORUMTHREADPOSTS" mode="r_postblocks">
		<xsl:apply-templates select="." mode="c_postblock"/>
	</xsl:template>-->
	<!-- 
	<xsl:template match="FORUMTHREADPOSTS" mode="off_postblock">
	Use: Display of non-current post block  - eg 'show posts 21-40'
		  The range parameter must be present to show the numeric value of the posts
		  It is common to also include a test - for example add a br tag after every 5th post block - 
		  this test must be replicated in m_postblockoff
	-->
	<!--<xsl:template match="FORUMTHREADPOSTS" mode="off_postblock">
		<xsl:param name="range"/>
		<xsl:param name="currentpost" select="substring-before($range, ' ')"/>
		<xsl:if test="$currentpost mod 100 = 1">
			
		</xsl:if>
		<xsl:value-of select="concat($alt_show, ' ', $range)"/>
		<br/>
	</xsl:template>-->
	<!-- 
	<xsl:template match="FORUMTHREADPOSTS" mode="on_postblock">
	Use: Display of current post block  - eg 'now showing posts 21-40'
		  The range parameter must be present to show the numeric value of the post you are on
		  Use the same test as in m_postblockoff
	-->
	<!--<xsl:template match="FORUMTHREADPOSTS" mode="on_postblock">
		<xsl:param name="range"/>
		<xsl:param name="currentpost" select="substring-before($range, ' ')"/>
		<xsl:if test="$currentpost mod 100 = 1">
			
		</xsl:if>
		<xsl:value-of select="concat($alt_nowshowing, ' ', $range)"/>
		<br/>
	</xsl:template>-->
	<!--
	<xsl:template match="FORUMTHREADPOSTS" mode="r_subcribemultiposts">
	Use: Presentation of subscribe / unsubscribe button 
	 -->
	<!--<xsl:template match="FORUMTHREADPOSTS" mode="r_subcribemultiposts">
		<xsl:apply-imports/>
	</xsl:template>-->
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
						FORUMTHREADPOSTS Object
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<!-- 
	<xsl:template match="FORUMTHREADPOSTS" mode="r_multiposts">
	Use: Logical container for the list of posts
	-->
	<xsl:template match="FORUMTHREADPOSTS" mode="r_multiposts">
		<xsl:apply-templates select="POST" mode="c_multiposts"/>
	</xsl:template>
	<!-- 
	<xsl:template match="POST" mode="r_multiposts">
	Use: Presentation of a single post
	-->
	<xsl:template match="POST" mode="r_multiposts">
		<!--<xsl:choose>
			<xsl:when test="@HIDDEN &gt; 0"/>
			<xsl:otherwise>-->
		<tr>
			<td colspan="3" class="post">
				<p>
					<a name="p{@POSTID}">
						<a href="{$root}F{../@FORUMID}?thread={../@THREADID}&amp;skip={../@SKIPTO}&amp;show={../@COUNT}#p{@POSTID}">
							Message <xsl:apply-templates select="." mode="t_postnumber"/>
						</a>
					</a>
					<xsl:choose>
						<xsl:when test="not(@HIDDEN = 0)"/>
						<xsl:when test="USER/EDITOR = 1">
							<xsl:text> - posted by </xsl:text>
							<a href="{$root}MP{USER/USERID}">
								<span class="editorName">
									<em>
										<xsl:apply-templates select="USER" mode="username" />
										(U<xsl:value-of select="USER/USERID"/>)
									</em>
								</span>
							</a>
						</xsl:when>
						<xsl:when test="USER/NOTABLE = 1">
							<xsl:text> - posted by </xsl:text>
							<a href="{$root}MP{USER/USERID}">
								<span class="notableName">
									<xsl:apply-templates select="USER" mode="username" />
									(U<xsl:value-of select="USER/USERID"/>)
									<xsl:if test="USER/TITLE[string()]">
										<xsl:text>&#8722;</xsl:text>
										<xsl:value-of select="USER/TITLE"/>
									</xsl:if>
								</span>
							</a>
						</xsl:when>
						<xsl:otherwise>
							<xsl:text> - posted by </xsl:text>
							<a href="{$root}MP{USER/USERID}">
								<xsl:apply-templates select="USER" mode="username" />
								(U<xsl:value-of select="USER/USERID"/>)
							</a>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:apply-templates select="USER" mode="c_onlineflagmp"/>, <xsl:apply-templates select="DATEPOSTED/DATE" mode="t_postdatemp"/>
				</p>
				<xsl:choose>
					<xsl:when test="count(preceding-sibling::POST) mod 2 = 0">
						<div class="postContentOne">
							<xsl:apply-templates select="." mode="t_postbodymp"/>
						</div>
					</xsl:when>
					<xsl:otherwise>
						<div class="postContentTwo">
							<xsl:apply-templates select="." mode="t_postbodymp"/>
						</div>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:if test="@INREPLYTO">
					<p class="quotefrom">
						<xsl:text>This is a reply to </xsl:text>
						<xsl:choose>
							<xsl:when test="@INREPLYTO = ../POST/@POSTID">
								<a href="#p{@INREPLYTO}">
									<xsl:text>this message</xsl:text>
								</a>
							</xsl:when>
							<xsl:otherwise>
								<a href="F{../@FORUMID}?thread={../@THREADID}&amp;post={@INREPLYTO}#p{@INREPLYTO}">
									<xsl:text>this message</xsl:text>
								</a>
							</xsl:otherwise>
						</xsl:choose>
					</p>
				</xsl:if>
				<xsl:if test="((/H2G2/VIEWING-USER/USER/GROUPS/EDITOR and /H2G2/VIEWING-USER/USER/GROUPS/MODERATOR)  or ($superuser = 1)) and (/H2G2/CURRENTSITEURLNAME = 'mb606' or /H2G2/CURRENTSITEURLNAME = 'mbtms' or /H2G2/CURRENTSITEURLNAME = 'mbfansforum' or /H2G2/CURRENTSITEURLNAME = 'mbscrumv')">
					<xsl:apply-templates select="." mode="r_streamlinedmoderation"/>
				</xsl:if>
			</td>
		</tr>
		<tr class="postBottom">
			<td width="35">
        <xsl:variable name="authorIsEditor" select="USER/GROUPS/EDITOR or USER/STATUS = 2"/>
        <xsl:variable name="viewerIsEditor" select="/H2G2/VIEWING-USER/USER/GROUPS/EDITOR or /H2G2/VIEWING-USER/USER/STATUS = 2"/>
        <xsl:if test="not($authorIsEditor or USER/GROUPS/NOTABLES ) or (USER/GROUPS/NOTABLES and $viewerIsEditor)">
          <xsl:apply-templates select="@HIDDEN" mode="c_complainmp"/>
        </xsl:if>
        <xsl:text>&nbsp;</xsl:text>
			</td>
			<td width="200">
				<xsl:apply-templates select="@POSTID" mode="c_replytopost"/>
				<xsl:text>&nbsp;</xsl:text>
			</td>
			<td width="265" align="right">
				<span style="font-size:8pt;">
					&nbsp;
					<xsl:if test="/H2G2/VIEWING-USER/USER/GROUPS/MODERATOR">
						<xsl:apply-templates select="@POSTID" mode="r_postmod"/>
					</xsl:if>
					&nbsp;
          <xsl:choose>
            <xsl:when test="$superuser = 1">
              <xsl:apply-templates select="@POSTID" mode="r_editmp"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:if test="@HIDDEN = 1 and /H2G2/VIEWING-USER/USER/GROUPS/EDITOR">
                <xsl:apply-templates select="@POSTID" mode="r_editmp"/>
              </xsl:if>
            </xsl:otherwise>
          </xsl:choose>
				</span>
			</td>
		</tr>
		<!--</xsl:otherwise>
		</xsl:choose>-->
	</xsl:template>
	<xsl:template match="FORUMTHREADPOSTS/POST" mode="r_streamlinedmoderation">
		<div>
			<xsl:attribute name="id">streamlinedmoderationdiv_<xsl:value-of select="@POSTID"/></xsl:attribute>
			<a>
				<xsl:attribute name="href">#<xsl:value-of select="@POSTID"/></xsl:attribute>
				<xsl:attribute name="onclick">return moderatePost(this);</xsl:attribute>
				<img src="{$imagesource}moderate_message_button.gif" alt="Moderate the message" width="142" height="22" border="0" vspace="5" hspace="2"/>
			</a>
		</div>
	</xsl:template>
	<xsl:variable name="failmessagefields_allowemptycustomtextinternalnotes"><![CDATA[<MULTI-INPUT>
		<REQUIRED NAME='FORUMID'/>
		<REQUIRED NAME='THREADID'/>
		<REQUIRED NAME='POSTID'/>
		<REQUIRED NAME='EMAILTYPE'><VALIDATE TYPE='NEQ' VALUE='none'/></REQUIRED>
		<REQUIRED NAME='CUSTOMTEXT'/>
		<REQUIRED NAME='EMAILTEXTPREVIEW' ESCAPED='1'/>
		<REQUIRED NAME='INTERNALNOTES'/>
	</MULTI-INPUT>]]></xsl:variable>
	<xsl:template match="FORUMTHREADPOSTS" mode="r_failpostform">
		<form action="{$root}FailMessage" id="failpostform">
			<input type="hidden" name="forumid" value="{@FORUMID}"/>
			<input type="hidden" name="threadid" value="{@THREADID}"/>
			<input type="hidden" name="postid" id="failpost_postid" value=""/>
			<!-- value populated via javascript -->
			<input type="hidden" name="_msxml" value="{$failmessagefields_allowemptycustomtextinternalnotes}"/>
			<input type="hidden" name="internalnotes" value="Front end: "/>
			<select style="display:none;margin-left:2px;margin-top:10px;margin-bottom:10px" name="emailtype" id="emailtype">
				<xsl:attribute name="onchange">return processEmailType(this);</xsl:attribute>
				<option value="None" selected="1">Failure reason:</option>
				<option value="OffensiveInsert">Offensive</option>
				<option value="LibelInsert">Libellous</option>
				<option value="URLInsert">Unsuitable/Broken URL</option>
				<option value="PersonalInsert">Personal Details</option>
				<option value="AdvertInsert">Advertising</option>
				<option value="CopyrightInsert">Copyright Material</option>
				<option value="PoliticalInsert">Contempt Of Court</option>
				<option value="IllegalInsert">Illegal Activity</option>
				<option value="SpamInsert">Spam</option>
			</select>
			<div style="display:none;" name="customtextdiv" id="customtextdiv">
				Custom text:
				<textarea name="customtext" id="customtext" cols="20" rows="4"/>
			</div>
			<input style="display:none;margin-left:2px;" type="submit" value="Process" name="failpostprocessbutton" id="failpostprocessbutton"/>
			<input type="hidden" name="_msfinish" value="yes"/>
			<input type="hidden" name="redirect" value="F{@FORUMID}?thread={@THREADID}"/>
		</form>
	</xsl:template>
	<!-- 
	<xsl:template match="@NEXTINDEX" mode="r_multiposts">
	Use: Presentation of the 'next posting' link
	-->
	<xsl:template match="@NEXTINDEX" mode="r_multiposts">
		<xsl:apply-imports/>
	</xsl:template>
	<!-- 
	<xsl:template match="@PREVINDEX" mode="r_multiposts">
	Use: Presentation of the 'previous posting' link
	-->
	<xsl:template match="@PREVINDEX" mode="r_multiposts">
		<xsl:apply-imports/>
	</xsl:template>
	<!--
	<xsl:template match="USERNAME" mode="r_multiposts">
	Use: Presentation if the user name is to be displayed
	 -->
	<xsl:template match="USERNAME" mode="r_multiposts">
		<xsl:value-of select="$m_by"/>
		<xsl:apply-imports/>
	</xsl:template>
	<!--
	<xsl:template match="USER" mode="r_onlineflagmp">
	Use: Presentation of the flag to display if a user is online or not
	 -->
	<xsl:template match="USER" mode="r_onlineflagmp">
		<xsl:copy-of select="$m_useronlineflagmp"/>
	</xsl:template>
	<!--
	<xsl:template match="@INREPLYTO" mode="r_multiposts">
	Use: Presentation of the 'this is a reply tothis post' link
	 -->
	<xsl:template match="@INREPLYTO" mode="r_multiposts">
		<xsl:value-of select="$m_inreplyto"/>
		<xsl:apply-imports/>
	</xsl:template>
	<!--
	<xsl:template match="POST" mode="r_gadgetmp">
	Use: Presentation of gadget container
	 -->
	<xsl:template match="POST" mode="r_gadgetmp">
		<xsl:apply-imports/>
	</xsl:template>
	<!--
	<xsl:template match="@FIRSTCHILD" mode="r_multiposts">
	Use: Presentation if the 'first reply to this'
	 -->
	<xsl:template match="@FIRSTCHILD" mode="r_multiposts">
		<xsl:value-of select="$m_readthe"/>
		<xsl:apply-imports/>
	</xsl:template>
	<!-- 
	<xsl:template match="@POSTID" mode="r_linktomoderate">
	use: Moderation link. Will appear only if editor or moderator.
	-->
	<xsl:template match="@POSTID" mode="r_linktomoderate">
		<xsl:apply-imports/>
	</xsl:template>
	<!-- 
	<xsl:template match="@HIDDEN" mode="r_complainmp">
	use: alert our moderation team link
	-->
	<xsl:template match="@HIDDEN" mode="r_complainmp">
		<xsl:param name="attributes"/>
		<xsl:param name="embodiment" select="$alt_complain"/>
		<!--<xsl:choose>
			<xsl:when test="/H2G2/FORUMSOURCE/ARTICLE/GUIDE/BODY/EDITORONLY">
				<p class="complain">
					<a href="UserComplaint?PostID={../@POSTID}&amp;s_start=1" target="ComplaintPopup" onClick="popupwindow('UserComplaint?PostID={../@POSTID}', 'ComplaintPopup', 'status=1,resizable=1,scrollbars=1,width=640,height=540')" xsl:use-attribute-sets="maHIDDEN_r_complainmp">
						<img src="{$imagesource}{/H2G2/SITECONFIG/ASSETCOMPLAIN}" alt="Complain about a message" width="29" height="20" border="0"/>
					</a>
				</p>
			</xsl:when>
			<xsl:otherwise>-->
		<a href="comments/UserComplaintPage?PostID={../@POSTID}&amp;s_start=1" target="ComplaintPopup" onClick="popupwindow('comments/UserComplaintPage?PostID={../@POSTID}&amp;s_start=1', 'ComplaintPopup', 'status=1,resizable=1,scrollbars=1,width=640,height=540')" xsl:use-attribute-sets="maHIDDEN_r_complainmp">
			<img src="{$imagesource}{/H2G2/SITECONFIG/ASSETCOMPLAIN}" alt="Complain about a message" width="29" height="20" border="0"/>
		</a>
		<!--</xsl:otherwise>
		</xsl:choose>-->
	</xsl:template>
	<!-- 
	<xsl:template match="@POSTID" mode="r_editmp">
	use: editors or moderators can edit a post
	-->
	<xsl:template match="@POSTID" mode="r_editmp">
		<xsl:apply-imports/>
	</xsl:template>
	<!-- 
	<xsl:template match="@POSTID" mode="r_replytopost">
	use: 'reply to this post' link
	-->
	<xsl:template match="@POSTID" mode="r_replytopost">
		<xsl:param name="attributes"/>
		<xsl:param name="embodiment" select="$m_replytothispost"/>
		<!--<xsl:choose>
			<xsl:when test="/H2G2/FORUMSOURCE/ARTICLE/GUIDE/BODY/EDITORONLY">
				<xsl:choose>
					<xsl:when test="(/H2G2/FORUMTHREADPOSTS/@CANWRITE = 0) and (/H2G2/VIEWING-USER/USER)"/>
					<xsl:otherwise>
						<p class="reply">
							<a target="_top" xsl:use-attribute-sets="maPOSTID_r_replytopost">
								<xsl:attribute name="href"><xsl:apply-templates select=".." mode="sso_post_signin"/></xsl:attribute>
								<xsl:call-template name="ApplyAttributes">
									<xsl:with-param name="attributes" select="$attributes"/>
								</xsl:call-template>								
								Post Comment
							</a>
						</p>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>-->
		<xsl:choose>
			<xsl:when test="(/H2G2/FORUMTHREADPOSTS/@CANWRITE = 0) and (/H2G2/VIEWING-USER/USER)">
				<img src="{$imagesource}discussion_board_closed_button.gif" alt="Board Closed" width="142" height="22" border="0"/>
			</xsl:when>
			<xsl:otherwise>
				<a target="_top" xsl:use-attribute-sets="maPOSTID_r_replytopost">
					<xsl:attribute name="href"><xsl:apply-templates select=".." mode="sso_post_signin"/></xsl:attribute>
					<xsl:call-template name="ApplyAttributes">
						<xsl:with-param name="attributes" select="$attributes"/>
					</xsl:call-template>
					<img src="{$imagesource}reply_to_this_message_button.gif" alt="Reply to this message" width="142" height="22" border="0"/>
				</a>
			</xsl:otherwise>
		</xsl:choose>
		<!--</xsl:otherwise>
		</xsl:choose>-->
	</xsl:template>
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
								Prev / Next threads
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<!-- 
	<xsl:template match="FORUMTHREADS" mode="r_otherthreads">
	use: inserts links to the previous and next threads
	-->
	<xsl:template match="FORUMTHREADS" mode="r_otherthreads">
		<xsl:apply-templates select="/H2G2/FORUMTHREADS/THREAD[@FORUMID=/H2G2/FORUMTHREADPOSTS/@FORUMID and @THREADID = /H2G2/FORUMTHREADPOSTS/@THREADID]/preceding-sibling::THREAD[1]" mode="c_previous"/>
		<xsl:apply-templates select="/H2G2/FORUMTHREADS/THREAD[@FORUMID=/H2G2/FORUMTHREADPOSTS/@FORUMID and @THREADID = /H2G2/FORUMTHREADPOSTS/@THREADID]/following-sibling::THREAD[1]" mode="c_next"/>
	</xsl:template>
	<!-- 
	<xsl:template match="THREAD" mode="r_previous">
	use: presentation of the previous link
	-->
	<xsl:template match="THREAD" mode="r_previous">
		previous <xsl:apply-imports/>
	</xsl:template>
	<!-- 
	<xsl:template match="THREAD" mode="r_next">
	use: presentation of the next link
	-->
	<xsl:template match="THREAD" mode="r_next">
		next: <xsl:apply-imports/>
	</xsl:template>
	<!-- 
	<xsl:template match="THREAD" mode="PreviousThread">
	use: inserts link to the previous thread
	-->
	<xsl:template match="THREAD" mode="PreviousThread">
		Last Thread: <xsl:apply-imports/>
	</xsl:template>
	<!-- 
	<xsl:template match="THREAD" mode="NextThread">
	use: inserts link to the next thread
	-->
	<xsl:template match="THREAD" mode="NextThread">
		Next Thread: <xsl:apply-imports/>
	</xsl:template>
	<!-- 
	<xsl:template match="@SKIPTO" mode="navbuttons">
	use: html containing the beginning / next / prev / latest buttons
	-->
	<xsl:template match="@SKIPTO" mode="r_navbuttons">
		<xsl:apply-templates select="." mode="c_gotobeginning"/>
		<xsl:text>Beginning </xsl:text>
		<xsl:apply-templates select="." mode="c_gotoprevious"/>
		<xsl:text>Previous</xsl:text>
		<xsl:apply-templates select="." mode="c_gotonext"/>
		<xsl:text>Next</xsl:text>
		<xsl:apply-templates select="." mode="c_gotolatest"/>
		<xsl:text>Latest</xsl:text>
	</xsl:template>
	<!-- 
	<xsl:template match="@SKIPTO" mode="r_gotobeginning">
	use: Skip to the beginning of the conversation embodiment
	-->
	<xsl:template match="@SKIPTO" mode="link_gotobeginning">
		<xsl:apply-imports/>
	</xsl:template>
	<!-- 
	<xsl:template match="@SKIPTO" mode="r_gotoprevious">
	use: Skip to the previous page of the conversation embodiment
	-->
	<xsl:template match="@SKIPTO" mode="link_gotoprevious">
		<a href="{$root}F{../@FORUMID}?thread={../@THREADID}&amp;skip={(.) - (../@COUNT)}&amp;show={../@COUNT}" xsl:use-attribute-sets="maSKIPTO_link_gotoprevious">&lt; Previous </a>
	</xsl:template>
	<!-- 
	<xsl:template match="@SKIPTO" mode="r_gotonext">
	use: Skip to the next page of the conversation embodiment
	-->
	<xsl:template match="@SKIPTO" mode="link_gotonext">
		<a href="{$root}F{../@FORUMID}?thread={../@THREADID}&amp;skip={(.) + (../@COUNT)}&amp;show={../@COUNT}" xsl:use-attribute-sets="maSKIPTO_link_gotonext"> Next &gt;</a>
	</xsl:template>
	<!-- 
	<xsl:template match="@SKIPTO" mode="r_gotolatest">
	use: Skip to the end of the conversation embodiment
	-->
	<xsl:template match="@SKIPTO" mode="link_gotolatest">
		<xsl:apply-imports/>
	</xsl:template>
	<!-- 
	<xsl:template match="@SKIPTO" mode="r_gotobeginning">
	use: Skip to the beginning of the conversation embodiment
	-->
	<xsl:template match="@SKIPTO" mode="text_gotobeginning">
		<xsl:apply-imports/>
	</xsl:template>
	<!-- 
	<xsl:template match="@SKIPTO" mode="r_gotoprevious">
	use: Skip to the previous page of the conversation embodiment
	-->
	<xsl:template match="@SKIPTO" mode="text_gotoprevious">
		<xsl:apply-imports/>
	</xsl:template>
	<!-- 
	<xsl:template match="@SKIPTO" mode="r_gotonext">
	use: Skip to the next page of the conversation embodiment
	-->
	<xsl:template match="@SKIPTO" mode="text_gotonext">
		<xsl:apply-imports/>
	</xsl:template>
	<!-- 
	<xsl:template match="@SKIPTO" mode="r_gotolatest">
	use: Skip to the end of the conversation embodiment
	-->
	<xsl:template match="@SKIPTO" mode="text_gotolatest">
		<xsl:apply-imports/>
	</xsl:template>
	<xsl:template match="POST" mode="editoronly_commentlist">
		<p class="comment">
			<xsl:apply-templates select="." mode="t_postbodymp"/>
		</p>
		<p>
			<xsl:text>Comment by </xsl:text>
			<xsl:choose>
				<xsl:when test="not(@HIDDEN = 0)"/>
				<xsl:when test="USER/EDITOR = 1">
					<a href="{$root}MP{USER/USERID}">
						<span class="editorName">
							<em>
								<xsl:apply-templates select="USER" mode="username" />
								(U<xsl:value-of select="USER/USERID"/>)
							</em>
						</span>
					</a>
				</xsl:when>
				<xsl:when test="USER/NOTABLE = 1">
					<a href="{$root}MP{USER/USERID}">
						<span class="notableName">
							<xsl:apply-templates select="USER" mode="username" />
							(U<xsl:value-of select="USER/USERID"/>)
							<xsl:if test="USER/TITLE[string()]">
								<xsl:text>&#8722;</xsl:text>
								<xsl:value-of select="USER/TITLE"/>
							</xsl:if>
						</span>
					</a>
				</xsl:when>
				<xsl:otherwise>
					<a href="{$root}MP{USER/USERID}">
						<xsl:apply-templates select="USER" mode="username" />
						(U<xsl:value-of select="USER/USERID"/>)
					</a>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:apply-templates select="USER" mode="c_onlineflagmp"/>
			<xsl:text> </xsl:text>
			<xsl:apply-templates select="DATEPOSTED/DATE" mode="t_postdatemp"/>
		</p>
    <xsl:apply-templates select="/H2G2/FORUMTHREADPOSTS/POST[position() = 1]/@POSTID" mode="c_replytopost"/>
      <xsl:apply-templates select="@HIDDEN" mode="c_complainmp"/>
		<xsl:if test="((/H2G2/VIEWING-USER/USER/GROUPS/EDITOR and /H2G2/VIEWING-USER/USER/GROUPS/MODERATOR)  or ($superuser = 1)) and (/H2G2/CURRENTSITEURLNAME = 'mb606' or /H2G2/CURRENTSITEURLNAME = 'mbtms' or /H2G2/CURRENTSITEURLNAME = 'mbfansforum' or /H2G2/CURRENTSITEURLNAME = 'mbscrumv')">
			<xsl:apply-templates select="." mode="r_streamlinedmoderation"/>
		</xsl:if>
		<span class="clear"/>
	</xsl:template>
</xsl:stylesheet>
