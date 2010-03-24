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
	</xsl:template>
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
									Page - Level  template
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<xsl:template name="MULTIPOSTS_MAINBODY">
		<table width="635" cellpadding="0" cellspacing="0" border="0" id="main">
			<tr>
				<td id="crumbtrail">
					<!--h5>
						<a href="{$homepage}{translate($currentRegion, '&amp;', '?')}">Back to discussion list</a>
					</h5-->
				</td>
			</tr>
			<tr>
				<td class="pageheader">
				<div align="right">
				<xsl:choose>				
					<xsl:when test="/H2G2/FORUMTHREADPOSTS/@DEFAULTCANWRITE = 1">
						<xsl:if test="(/H2G2/VIEWING-USER/USER/GROUPS/EDITOR)  or ($superuser = 1)">
							<a href="{$root}F{/H2G2/FORUMTHREADPOSTS/@FORUMID}?thread={/H2G2/FORUMTHREADPOSTS/@THREADID}&amp;cmd=closethread">
							<img src="http://www.bbc.co.uk/dnaimages/boards/images/button_close.gif" alt="Close this thread" width="137" height="23" border="0" vspace="5" hspace="5"/></a><br clear="all"/>
						</xsl:if>				
					</xsl:when>
					<xsl:when test="/H2G2/FORUMTHREADPOSTS/@DEFAULTCANWRITE = 0">
					<img src="http://www.bbc.co.uk/dnaimages/boards/images/button_closed.gif" alt="This thread has been closed" width="183" height="23" border="0" vspace="5" hspace="5"/>				
						<xsl:if test="(/H2G2/VIEWING-USER/USER/GROUPS/EDITOR)  or ($superuser = 1)">
							<a href="{$root}F{/H2G2/FORUMTHREADPOSTS/@FORUMID}?thread={/H2G2/FORUMTHREADPOSTS/@THREADID}&amp;cmd=reopenthread">
							<img src="http://www.bbc.co.uk/dnaimages/boards/images/button_open.gif" alt="Open this thread" width="139" height="23" border="0" vspace="5" hspace="0"/></a><br clear="all"/>
							<p>(If you are an editor you will still see the reply buttons) &nbsp;</p><br clear="all"/>
						</xsl:if>
					</xsl:when>					
				</xsl:choose>
				</div>				
					<table width="635" border="0" cellpadding="0" cellspacing="0">
						<tr>
							<!--td id="subject">
								<h1>
									<xsl:value-of select="FORUMSOURCE/ARTICLE/SUBJECT"/>
								
								</h1>
							</td-->
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
													<xsl:when test="string-length(/H2G2/FORUMTHREADS/THREAD[@FORUMID = /H2G2/FORUMTHREADPOSTS/@FORUMID]/SUBJECT) = 0">
											No Discussion Title
										</xsl:when>
													<xsl:otherwise>
														<xsl:value-of select="/H2G2/FORUMTHREADS/THREAD[@THREADID = /H2G2/FORUMTHREADPOSTS/@THREADID]/SUBJECT"/>
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
																<xsl:apply-templates select="FORUMTHREADPOSTS/@SKIPTO" mode="c_gotobeginning"/> |						
																<xsl:apply-templates select="FORUMTHREADPOSTS/@SKIPTO" mode="c_gotoprevious"/>
																<xsl:apply-templates select="FORUMTHREADPOSTS" mode="c_postblocks"/>
																<xsl:apply-templates select="FORUMTHREADPOSTS/@SKIPTO" mode="c_gotonext"/>	|					
																<xsl:apply-templates select="FORUMTHREADPOSTS/@SKIPTO" mode="c_gotolatest"/>
															</xsl:otherwise>
														</xsl:choose>
													</xsl:otherwise>
												</xsl:choose>
											</div>
										</td>
									</tr>
									<tr>
										<th colspan="3">&nbsp;
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
																<xsl:apply-templates select="FORUMTHREADPOSTS/@SKIPTO" mode="c_gotobeginning"/> |						
																<xsl:apply-templates select="FORUMTHREADPOSTS/@SKIPTO" mode="c_gotoprevious"/>
																<xsl:apply-templates select="FORUMTHREADPOSTS" mode="c_postblocks"/>
																<xsl:apply-templates select="FORUMTHREADPOSTS/@SKIPTO" mode="c_gotonext"/>	|					
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
								<xsl:apply-templates select="/H2G2/THREADSEARCHPHRASE/THREADPHRASELIST" mode="c_multiposts"/>
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
											<a href="http://www.bbc.co.uk/messageboards/newguide/popup_reply_message.html" onclick="popupwindow('http://www.bbc.co.uk/messageboards/newguide/popup_reply_message.html', 'popwin', 'status=1,resizable=1,scrollbars=1,width=440,height=380');return false;" target="popwin" title="This link opens in a new popup window">
												<img src="http://www.bbc.co.uk/dnaimages/boards/images/help_icon_involved.gif" width="15" height="15" alt="getting involved" title="getting involved" align="top" border="0"/>
											</a> How to <a href="http://www.bbc.co.uk/messageboards/newguide/popup_reply_message.html" onclick="popupwindow('http://www.bbc.co.uk/messageboards/newguide/popup_reply_message.html', 'popwin', 'status=1,resizable=1,scrollbars=1,width=440,height=380');return false;" target="popwin" title="This link opens in a new popup window">reply to messages<img src="http://www.bbc.co.uk/dnaimages/boards/images/popup.gif" width="20" height="15" alt="popup icon" title="" align="top" border="0"/>
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
											<a href="http://www.bbc.co.uk/messageboards/newguide/popup_complaints.html" onclick="popupwindow('http://www.bbc.co.uk/messageboards/newguide/popup_complaints.html', 'popwin', 'status=1,resizable=1,scrollbars=1,width=440,height=380');return false;" target="popwin" title="This link opens in a new popup window">
												<img src="http://www.bbc.co.uk/dnaimages/boards/images/complain_icon_small.gif" width="23" height="16" alt="complain" title="complain" align="top" border="0"/>
											</a>&nbsp; <a href="http://www.bbc.co.uk/messageboards/newguide/popup_complaints.html" onclick="popupwindow('http://www.bbc.co.uk/messageboards/newguide/popup_complaints.html', 'popwin', 'status=1,resizable=1,scrollbars=1,width=440,height=380');return false;" target="popwin" title="This link opens in a new popup window">Alert us about a message<img src="http://www.bbc.co.uk/dnaimages/boards/images/popup.gif" width="20" height="15" alt="popup icon" title="" align="top" border="0"/>
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
											<a href="http://www.bbc.co.uk/messageboards/newguide/popup_online_safety.html" onclick="popupwindow('http://www.bbc.co.uk/messageboards/newguide/popup_online_safety.html', 'popwin', 'status=1,resizable=1,scrollbars=1,width=440,height=380');return false;" target="popwin" title="This link opens in a new popup window">
												<img src="http://www.bbc.co.uk/dnaimages/boards/images/help_icon_safety.gif" width="15" height="15" alt="online safety" title="online safety" align="top" border="0"/>
											</a> Are you being <a href="http://www.bbc.co.uk/messageboards/newguide/popup_online_safety.html" onclick="popupwindow('http://www.bbc.co.uk/messageboards/newguide/popup_online_safety.html', 'popwin', 'status=1,resizable=1,scrollbars=1,width=440,height=380');return;false;" target="popwin" title="This link opens in a new popup window">safe online?<img src="http://www.bbc.co.uk/dnaimages/boards/images/popup.gif" width="20" height="15" alt="popup icon" title="" align="top" border="0"/>
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
										<xsl:value-of select="USER/USERNAME"/>
									</em>
								</span>
							</a>
						</xsl:when>
						<xsl:when test="USER/NOTABLE = 1">
							<xsl:text> - posted by </xsl:text>
							<a href="{$root}MP{USER/USERID}">
								<span class="notableName">
									<xsl:value-of select="USER/USERNAME"/>
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
								<xsl:value-of select="USER/USERNAME"/>
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
			</td>
		</tr>
		<tr class="postBottom">
			<td width="35">
				<xsl:apply-templates select="@HIDDEN" mode="c_complainmp"/>&nbsp;
					</td>
			<td width="200">
				<xsl:apply-templates select="@POSTID" mode="c_replytopost"/>&nbsp;
					</td>
			<td width="265">
				<!--xsl:choose>
					<xsl:when test="(/H2G2/VIEWING-USER/USER/GROUPS/EDITOR and /H2G2/VIEWING-USER/USER/GROUPS/MODERATOR)  or ($superuser = 1)">
						<xsl:apply-templates select="@POSTID" mode="c_failmessagelink"/>
					</xsl:when>
					<xsl:otherwise>&nbsp;</xsl:otherwise>
				</xsl:choose-->&nbsp;&nbsp;
			</td>
		</tr>
		<!--</xsl:otherwise>
		</xsl:choose>-->
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
	<xsl:template match="@POSTID" mode="r_linktomoderate">
	use: Moderation link. Will appear only if editor or moderator.
	-->
	<xsl:template match="@POSTID" mode="r_failmessagelink">
		<a target="_top" href="{$root}FailMessage?forumid={../../@FORUMID}&amp;threadid={../../@THREADID}&amp;postid={.}&amp;_msxml={$failmessageparameters}" xsl:use-attribute-sets="maPOSTID_r_failmessagelink">
			<img src="{$imagesource}fail_this_message_button.gif" alt="Fail this message" width="117" height="20" border="0"/>
		</a>
	</xsl:template>
	<!-- 
	<xsl:template match="@HIDDEN" mode="r_complainmp">
	use: alert our moderation team link
	-->
	<xsl:template match="@HIDDEN" mode="r_complainmp">
		<xsl:param name="attributes"/>
		<xsl:param name="embodiment" select="$alt_complain"/>
		<a href="/dna/{/H2G2/CURRENTSITEURLNAME}/comments/UserComplaintPage?PostID={../@POSTID}&amp;s_start=1" target="ComplaintPopup" onClick="popupwindow('/dna/{/H2G2/CURRENTSITEURLNAME}/comments/UserComplaintPage?PostID={../@POSTID}&amp;s_start=1', 'ComplaintPopup', 'status=1,resizable=1,scrollbars=1,width=640,height=440')" xsl:use-attribute-sets="maHIDDEN_r_complainmp">
			<img src="{$imagesource}{/H2G2/SITECONFIG/ASSETCOMPLAIN}" alt="Complain about a message" width="29" height="20" border="0"/>
		</a>
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
	<xsl:template match="THREADPHRASELIST" mode="r_multiposts">
		<xsl:if test="PHRASES/PHRASE">
			<table cellspacing="0" cellpadding="1" border="0" width="120" class="phraseTable">
				<tr>
					<td class="blockPhraseSide" colspan="2"/>
					<td>
						<img src="http://www.bbc.co.uk/f/t.gif" width="1" height="1" alt=""/>
					</td>
				</tr>
				<tr>
					<td class="blockPhraseSide"/>
					<td class="blockPhrase">
						<p>
							<xsl:text>This discussion is tagged with:</xsl:text>
							<br/>
							<xsl:apply-templates select="PHRASES/PHRASE" mode="c_multiposts"/>
							<xsl:apply-templates select="PHRASES" mode="t_submitremovetags"/>
						</p>
					</td>
					<td/>
				</tr>
				<tr>
					<td>
						<img src="http://www.bbc.co.uk/f/t.gif" width="1" height="1" alt=""/>
					</td>
					<td colspan="2"/>
				</tr>
			</table>
		</xsl:if>
		
						
							
			<xsl:apply-templates select="." mode="c_addtag"/>
							
	
	</xsl:template>
	<xsl:template match="THREADPHRASELIST" mode="r_addtag">
		<div class="complainPhrase">
			<span class="addTag">
				<xsl:apply-imports/>
			</span>
		</div>
	</xsl:template>
	
	
	<xsl:template match="PHRASE" mode="r_multiposts">
		<xsl:text> - </xsl:text>
		<xsl:apply-imports/>
		<br/>
		<xsl:apply-templates select="." mode="t_removetag"/>
	
	</xsl:template>
	
</xsl:stylesheet>
