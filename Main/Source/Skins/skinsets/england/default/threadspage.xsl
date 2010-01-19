<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<xsl:import href="../../../base/base-threadspage.xsl"/>
	<!-- Creates link to CSS for each topic area -->
	<xsl:template name="THREADS_CSS">
		<xsl:if test="string-length(/H2G2/FORUMSOURCE/ARTICLE/GUIDE/AREACSS) &gt; 0">
			<LINK TYPE="text/css" REL="stylesheet" HREF="{/H2G2/FORUMSOURCE/ARTICLE/GUIDE/AREACSS/node()}"/>
		</xsl:if>
	</xsl:template>
	<!--
	THREADS_MAINBODY
				
	-->
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
									Page - Level  template
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<xsl:template name="THREADS_MAINBODY">
		<table width="635" cellpadding="0" cellspacing="0" border="0" id="main">
			<!--tr>
				<td id="crumbtrail">
					<h5>You are here &gt; <a href="{$homepage}">
							<xsl:value-of select="/H2G2/SITECONFIG/BOARDNAME"/> messageboard</a> &gt; <xsl:value-of select="FORUMSOURCE/ARTICLE/SUBJECT"/>
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
				<td>
					<p class="intro">
						<xsl:apply-templates select="FORUMSOURCE/ARTICLE/GUIDE/BODY"/>
					</p>
					<p id="newconversation">
						<xsl:apply-templates select="FORUMTHREADS" mode="c_newconversation"/>
					</p>
				</td>
			</tr>
			<tr>
				<td width="635" align="right">
					<table width="630" cellpadding="0" cellspacing="0" border="0">
						<tr>
							<td class="discussions" width="500">
								<h4>
									<span class="strong">Discussions</span>  &nbsp;<xsl:value-of select="FORUMTHREADS/@SKIPTO + FORUMTHREADS/THREAD[1]/@INDEX + 1"/> - <xsl:value-of select="FORUMTHREADS/@SKIPTO + FORUMTHREADS/THREAD[position()=last()]/@INDEX + 1"/> of <xsl:value-of select="FORUMTHREADS/@TOTALTHREADS"/>
								</h4>
							</td>
							<td width="130">&nbsp;</td>
						</tr>
						<tr>
							<td valign="top" width="500">
								<table cellspacing="0" cellpadding="0" border="0" width="500" id="content">
									<tr>
										<td class="tablenavbarTop" width="500" colspan="4">
											<div class="tablenavtext">
												<xsl:choose>
													<xsl:when test="FORUMTHREADS/@TOTALTHREADS &lt; FORUMTHREADS/@COUNT">&nbsp;</xsl:when>
													<xsl:otherwise>
														<xsl:choose>
															<xsl:when test="FORUMTHREADS/@TOTALTHREADS &lt; FORUMTHREADS/@COUNT * 3">
																<xsl:apply-templates select="FORUMTHREADS" mode="c_previouspage"/>
																<xsl:apply-templates select="FORUMTHREADS" mode="c_threadblocks"/>
																<xsl:apply-templates select="FORUMTHREADS" mode="c_nextpage"/>
															</xsl:when>
															<xsl:otherwise>
																<xsl:apply-templates select="FORUMTHREADS" mode="c_firstpage"/> | 
																<xsl:apply-templates select="FORUMTHREADS" mode="c_previouspage"/>
																<xsl:apply-templates select="FORUMTHREADS" mode="c_threadblocks"/>
																<xsl:apply-templates select="FORUMTHREADS" mode="c_nextpage"/> | 
																<xsl:apply-templates select="FORUMTHREADS" mode="c_lastpage"/>
															</xsl:otherwise>
														</xsl:choose>
													</xsl:otherwise>
												</xsl:choose>
											</div>
										</td>
									</tr>
									<tr>
										<th id="thDiscussion">
											<p class="thText">Discussion</p>
										</th>
										<th id="thReplies">
											<p class="thText">Replies</p>
										</th>
										<th id="thStarted">
											<p class="thText">Started by</p>
										</th>
										<th id="thLatest">
											<p class="thText">Latest reply</p>
										</th>
									</tr>
									<xsl:apply-templates select="FORUMTHREADS" mode="c_threadspage"/>
									<tr>
										<td class="tablenavbarBtm" colspan="4">
											<div class="tablenavtext">
												<xsl:choose>
													<xsl:when test="FORUMTHREADS/@TOTALTHREADS &lt; FORUMTHREADS/@COUNT">&nbsp;</xsl:when>
													<xsl:otherwise>
														<xsl:choose>
															<xsl:when test="FORUMTHREADS/@TOTALTHREADS &lt; FORUMTHREADS/@COUNT * 3">
																<xsl:apply-templates select="FORUMTHREADS" mode="c_previouspage"/>
																<xsl:apply-templates select="FORUMTHREADS" mode="c_threadblocks"/>
																<xsl:apply-templates select="FORUMTHREADS" mode="c_nextpage"/>
															</xsl:when>
															<xsl:otherwise>
																<xsl:apply-templates select="FORUMTHREADS" mode="c_firstpage"/> | 
																<xsl:apply-templates select="FORUMTHREADS" mode="c_previouspage"/>
																<xsl:apply-templates select="FORUMTHREADS" mode="c_threadblocks"/>
																<xsl:apply-templates select="FORUMTHREADS" mode="c_nextpage"/> | 
																<xsl:apply-templates select="FORUMTHREADS" mode="c_lastpage"/>
															</xsl:otherwise>
														</xsl:choose>
													</xsl:otherwise>
												</xsl:choose>
											</div>
										</td>
									</tr>
								</table>
							</td>
							<td valign="top" id="promoArea" rowspan="2" width="130">
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
											<a href="http://www.bbc.co.uk/messageboards/newguide/popup_membership.html" onclick="popupwindow('http://www.bbc.co.uk/messageboards/newguide/popup_membership.html', 'popwin', 'status=1,resizable=1,scrollbars=1,width=440,height=380');return false;" target="popwin" title="This link opens in a new popup window"><img src="http://www.bbc.co.uk/dnaimages/boards/images/help_icon_registration.gif" width="15" height="15" alt="membership and nicknames" title="membership and nicknames" align="top" border="0"/></a> &nbsp;<a href="http://www.bbc.co.uk/messageboards/newguide/popup_membership.html" onclick="popupwindow('http://www.bbc.co.uk/messageboards/newguide/popup_membership.html', 'popwin', 'status=1,resizable=1,scrollbars=1,width=440,height=380');return false;" target="popwin" title="This link opens in a new popup window">Register for membership<img src="http://www.bbc.co.uk/dnaimages/boards/images/popup.gif" width="20" height="15" alt="popup icon" title="" align="top" border="0"/>
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
											<a href="http://www.bbc.co.uk/messageboards/newguide/popup_start_discussion.html" onclick="popupwindow('http://www.bbc.co.uk/messageboards/newguide/popup_start_discussion.html', 'popwin', 'status=1,resizable=1,scrollbars=1,width=440,height=380');return false;" target="popwin" title="This link opens in a new popup window"><img src="http://www.bbc.co.uk/dnaimages/boards/images/help_icon_involved.gif" width="15" height="15" alt="getting involved" title="getting involved" align="top" border="0"/></a> How to <a href="http://www.bbc.co.uk/messageboards/newguide/popup_start_discussion.html" onclick="popupwindow('http://www.bbc.co.uk/messageboards/newguide/popup_start_discussion.html', 'popwin', 'status=1,resizable=1,scrollbars=1,width=440,height=380');return false;" target="popwin" title="This link opens in a new popup window">start a discussion<img src="http://www.bbc.co.uk/dnaimages/boards/images/popup.gif" width="20" height="15" alt="popup icon" title="" align="top" border="0"/>
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
											<a href="http://www.bbc.co.uk/messageboards/newguide/popup_nicknames.html" onclick="popupwindow('http://www.bbc.co.uk/messageboards/newguide/popup_nicknames.html', 'popwin', 'status=1,resizable=1,scrollbars=1,width=440,height=380');return false;" target="popwin" title="This link opens in a new popup window"><img src="http://www.bbc.co.uk/dnaimages/boards/images/help_icon_registration.gif" width="15" height="15" alt="membership and nicknames" title="membership and nicknames" align="top" border="0"/></a> How to <a href="http://www.bbc.co.uk/messageboards/newguide/popup_nicknames.html" onclick="popupwindow('http://www.bbc.co.uk/messageboards/newguide/popup_nicknames.html', 'popwin', 'status=1,resizable=1,scrollbars=1,width=440,height=380');return false;" target="popwin" title="This link opens in a new popup window">change your nickname<img src="http://www.bbc.co.uk/dnaimages/boards/images/popup.gif" width="20" height="15" alt="popup icon" title="" align="top" border="0"/>
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
								<br/>
								<br/>
								<br/>
								<br/>
								<br/>
								<br/>
							</td>
						</tr>
						<tr>
							<td class="discussions" valign="top" width="500">
								<h4>
									<span class="strong">Discussions</span>  &nbsp;<xsl:value-of select="FORUMTHREADS/@SKIPTO + FORUMTHREADS/THREAD[1]/@INDEX + 1"/> - <xsl:value-of select="FORUMTHREADS/@SKIPTO + FORUMTHREADS/THREAD[position()=last()]/@INDEX + 1"/> of <xsl:value-of select="FORUMTHREADS/@TOTALTHREADS"/>
								</h4>
								<br/>
								<br/>
							</td>
						</tr>
					</table>
				</td>
			</tr-->
			<xsl:if test="/H2G2/VIEWING-USER/USER/GROUPS/EDITOR or ($superuser = 1)">
				<tr>
					<td colspan="2">
						<xsl:apply-templates select="FORUMTHREADS/MODERATIONSTATUS" mode="c_threadspage"/>
					</td>
				</tr>
			</xsl:if>
		</table>
	</xsl:template>
	<!--
	<xsl:template match="MODERATIONSTATUS" mode="r_threadspage">
	Description: moderation status of the thread
	 -->
	<xsl:template match="MODERATIONSTATUS" mode="r_threadspage">
		<xsl:apply-imports/>
	</xsl:template>
	<!--
	<xsl:template match="FORUMSOURCE/ARTICLE/GUIDE/FORUMTHREADINTRO|FORUMSOURCE/ARTICLE/GUIDE/FORUMINTRO" mode="r_threadspage">
	Use: Presentation of FORUMINTRO if the ARTICLE has one
	 -->
	<xsl:template match="FORUMSOURCE/ARTICLE/GUIDE/FORUMTHREADINTRO|FORUMSOURCE/ARTICLE/GUIDE/FORUMINTRO" mode="r_threadspage">
		<xsl:value-of select="."/>
	</xsl:template>
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
					THREAD Logical Container Template
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<xsl:template match="FORUMTHREADS" mode="r_threadspage">
		<xsl:apply-templates select="THREAD" mode="c_threadspage"/>
	</xsl:template>
	<!--
	<xsl:template match="THREAD" mode="r_threadspage">
	Use: Presentation of an individual thread in a THREADS page
	 -->
	<xsl:template match="THREAD" mode="r_threadspage">
		<xsl:choose>
			<xsl:when test="count(preceding-sibling::THREAD) mod 2 = 0">
				<tr class="rowOne">
					<td class="discussion">
						<p>
							<xsl:apply-templates select="SUBJECT" mode="t_threadspage"/>
							<br/>
							<xsl:value-of select="substring(FIRSTPOST/TEXT, 1, 40)"/>...
						</p>
					</td>
					<td class="replies" width="50">
						<p>
							<xsl:apply-templates select="TOTALPOSTS" mode="t_numberofreplies"/>
						</p>
					</td>
					<td class="startedby" width="120">
						<p>
							<xsl:choose>
								<xsl:when test="FIRSTPOST/USER/TITLE[string()]">
									<xsl:apply-templates select="FIRSTPOST/USER/USERNAME" mode="c_threadspage"/>
									<span class="notable"> &#8722; <xsl:value-of select="FIRSTPOST/USER/TITLE"/>
									</span>
								</xsl:when>
								<xsl:otherwise>
									<xsl:apply-templates select="FIRSTPOST/USER/USERNAME" mode="c_threadspage"/>
								</xsl:otherwise>
							</xsl:choose>
						</p>
					</td>
					<td class="latestreply" width="85">
						<p>
							<a href="{$root}F{@FORUMID}?thread={@THREADID}&amp;latest=1#p{LASTPOST/@POSTID}">
								<xsl:value-of select="LASTPOST/DATE/@RELATIVE"/>
							</a>
						</p>
					</td>
				</tr>
			</xsl:when>
			<xsl:otherwise>
				<tr class="rowTwo">
					<td class="discussion">
						<p>
							<xsl:apply-templates select="SUBJECT" mode="t_threadspage"/>
							<br/>
							<xsl:value-of select="substring(FIRSTPOST/TEXT, 1, 40)"/>...
						</p>
					</td>
					<td class="replies" width="50">
						<p>
							<xsl:apply-templates select="TOTALPOSTS" mode="t_numberofreplies"/>
						</p>
					</td>
					<td class="startedby" width="120">
						<p>
							<xsl:choose>
								<xsl:when test="FIRSTPOST/USER/TITLE[string()]">
									<xsl:apply-templates select="FIRSTPOST/USER/USERNAME" mode="c_threadspage"/>
									<span class="notable"> &#8722; <xsl:value-of select="FIRSTPOST/USER/TITLE"/>
									</span>
								</xsl:when>
								<xsl:otherwise>
									<xsl:apply-templates select="FIRSTPOST/USER/USERNAME" mode="c_threadspage"/>
								</xsl:otherwise>
							</xsl:choose>
						</p>
					</td>
					<td class="latestreply" width="85">
						<p>
							<a href="{$root}F{@FORUMID}?thread={@THREADID}&amp;latest=1#p{LASTPOST/@POSTID}">
								<xsl:value-of select="LASTPOST/DATE/@RELATIVE"/>
							</a>
						</p>
					</td>
				</tr>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:apply-templates select="@THREADID" mode="c_movethreadgadget"/>
		<!--<xsl:apply-templates select="." mode="c_hidethread"/>-->
	</xsl:template>
	<!--
	<xsl:template match="FIRSTPOST" mode="r_threadspage">
	Use: Presentation of the FIRSTPOST object
	 -->
	<xsl:template match="FIRSTPOST" mode="r_threadspage">
		First Post:
		<br/>
		Content: <xsl:apply-templates select="TEXT" mode="t_firstposttp"/>
		<br/>
		User: <xsl:apply-templates select="USER" mode="t_firstposttp"/>
		<br/>
		Posted: <xsl:apply-templates select="DATE"/>
	</xsl:template>
	<!--
	<xsl:template match="LASTPOST" mode="r_threadspage">
	Use: Presentation of the LASTPOST object
	 -->
	<xsl:template match="LASTPOST" mode="r_threadspage">
		Last Post:
		<br/>
		Content: <xsl:apply-templates select="TEXT" mode="t_lastposttp"/>
		<br/>
		User: <xsl:apply-templates select="USER" mode="t_lastposttp"/>
		<br/>
		Posted: <xsl:apply-templates select="DATE"/>
	</xsl:template>
	<!--
	<xsl:template match="@THREADID" mode="r_movethreadgadget">
	Use: Presentation of the move thread editorial tool link
	 -->
	<xsl:template match="@THREADID" mode="r_movethreadgadget">
		<tr>
			<td colspan="4" align="right">
				<p>
					<xsl:apply-imports/>&nbsp;&nbsp;
				</p>
			</td>
		</tr>
	</xsl:template>
	<!--
	<xsl:template match="@THREADID" mode="r_hidethread">
	Use: Presentation of the hide thread editorial tool link
	 -->
	<xsl:template match="THREAD" mode="r_hidethread">
		<xsl:apply-imports/>
	</xsl:template>
	<!--
	<xsl:template match="FORUMTHREADS" mode="r_subscribe">
	Use: Presentation of the subscribe / unsubscribe button
	 -->
	<xsl:template match="FORUMTHREADS" mode="r_subscribe">
		<font xsl:use-attribute-sets="mainfont">
			<xsl:apply-imports/>
		</font>
	</xsl:template>
	<!-- 
	<xsl:template match="FORUMTHREADPOSTS" mode="r_postblocks">
	Use: Container for the complete list of post blocks
	-->
	<xsl:template match="FORUMTHREADS" mode="r_threadblocks">
		<xsl:apply-templates select="." mode="c_threadblockdisplayprev"/>
		<xsl:apply-templates select="." mode="c_threadblockdisplay"/>
		<xsl:apply-templates select="." mode="c_threadblockdisplaynext"/>
	</xsl:template>
	<!-- Older versions?
	<xsl:template match="FORUMTHREADS" mode="r_threadblocks">
	Use: Presentation of the thread block container
	
	<xsl:template match="FORUMTHREADS" mode="r_threadblocks">
		<xsl:apply-templates select="." mode="c_threadblockdisplayprev"/>
		<xsl:apply-templates select="." mode="c_threadblockdisplay"/>
		<xsl:apply-templates select="." mode="c_threadblockdisplaynext"/>
	</xsl:template>
	-->
	<!-- 
	<xsl:template match="FORUMTHREADPOSTS" mode="r_blockdisplayprev">
	Use: Presentation of previous link
	-->
	<xsl:template match="FORUMTHREADS" mode="r_threadblockdisplayprev">
		<xsl:apply-imports/>
	</xsl:template>
	<!-- 
	<xsl:template match="FORUMTHREADPOSTS" mode="r_blockdisplaynext">
	Use: Presentation of next link
	-->
	<xsl:template match="FORUMTHREADS" mode="r_threadblockdisplaynext">
		<xsl:apply-imports/>
	</xsl:template>
	<!--
	<xsl:template match="FORUMTHREADS" mode="on_blockdisplay">
	Use: Controls the display of the block (outside the link) which is currently appearing on the page
	-->
	<xsl:template match="FORUMTHREADS" mode="on_threadblockdisplay">
		<xsl:param name="url"/>
		<xsl:copy-of select="$url"/>&nbsp;
	</xsl:template>
	<!-- 
	<xsl:template name="t_ontabcontent">
	Use: Controls the content of the link for the currently visible page
	-->
	<xsl:template name="t_threadontabcontent">
		<xsl:param name="range"/>
		<xsl:param name="pagenumber"/>
		<xsl:value-of select="$pagenumber"/>
	</xsl:template>
	<!-- 
	<xsl:template match="FORUMTHREADS" mode="off_blockdisplay">
	Use: Controls the display of the block (outside the link) which is not currently on the page
	-->
	<xsl:template match="FORUMTHREADS" mode="off_threadblockdisplay">
		<xsl:param name="url"/>
		<xsl:copy-of select="$url"/>&nbsp;
	</xsl:template>
	<!-- 
	<xsl:template name="t_offtabcontent">
	Use: Controls the content of the link for other pages in the currently visible range
	-->
	<xsl:template name="t_threadofftabcontent">
		<xsl:param name="range"/>
		<xsl:param name="pagenumber"/>
		<xsl:value-of select="$pagenumber"/>
	</xsl:template>
	<!-- 
	Use: Attribute sets for the links themselves
	-->
	<xsl:attribute-set name="mFORUMTHREADS_on_threadblockdisplay">
		<xsl:attribute name="id">active</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="mFORUMTHREADS_off_threadblockdisplay">
		<xsl:attribute name="class">inactive</xsl:attribute>
	</xsl:attribute-set>
	<!-- 
	<xsl:template match="FORUMTHREADS" mode="r_newconversation">
	Use: Presentation of the 'New Conversation' link
	-->
	<xsl:template match="FORUMTHREADS" mode="r_newconversation">
		<xsl:choose>
			<xsl:when test="(@CANWRITE = 0) and (/H2G2/VIEWING-USER/USER)">
				<img src="{$imagesource}topic_board_closed_button.gif" alt="Board Closed" border="0"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-imports/>
				<xsl:if test="not(/H2G2/VIEWING-USER/USER)">
					<span class="small">
						<xsl:text> (requires sign in)</xsl:text>
					</span>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- 
	<xsl:template match="FORUMTHREADS" mode="link_firstpage">
	Use: Presentation of the 'First Page' link
	-->
	<xsl:template match="FORUMTHREADS" mode="link_firstpage">
		<xsl:apply-imports/>
	</xsl:template>
	<!-- 
	<xsl:template match="FORUMTHREADS" mode="link_lastpage">
	Use: Presentation of the 'Last Page' link
	-->
	<xsl:template match="FORUMTHREADS" mode="link_lastpage">
		<xsl:apply-imports/>
	</xsl:template>
	<!-- 
	<xsl:template match="FORUMTHREADS" mode="link_previouspage">
	Use: Presentation of the 'Previous Page' link
	-->
	<xsl:template match="FORUMTHREADS" mode="link_previouspage">
		<xsl:apply-imports/>
	</xsl:template>
	<!-- 
	<xsl:template match="FORUMTHREADS" mode="link_nextpage">
	Use: Presentation of the 'Next Page' link
	-->
	<xsl:template match="FORUMTHREADS" mode="link_nextpage">
		<xsl:apply-imports/>
	</xsl:template>
	<!-- 
	<xsl:template match="FORUMTHREADS" mode="text_firstpage">
	Use: Presentation of the 'On First Page' message
	-->
	<xsl:template match="FORUMTHREADS" mode="text_firstpage">
		<xsl:apply-imports/>
	</xsl:template>
	<!-- 
	<xsl:template match="FORUMTHREADS" mode="text_lastpage">
	Use: Presentation of the 'On Last Page' message
	-->
	<xsl:template match="FORUMTHREADS" mode="text_lastpage">
		<xsl:apply-imports/>
	</xsl:template>
	<!-- 
	<xsl:template match="FORUMTHREADS" mode="text_previouspage">
	Use: Presentation of the 'No Previous Page' message
	-->
	<xsl:template match="FORUMTHREADS" mode="text_previouspage">
		<xsl:apply-imports/>
	</xsl:template>
	<!-- 
	<xsl:template match="FORUMTHREADS" mode="text_nextpage">
	Use: Presentation of the 'No Next Page' message
	-->
	<xsl:template match="FORUMTHREADS" mode="text_nextpage">
		<xsl:apply-imports/>
	</xsl:template>
	<!-- NAUGHTY stolen from base to enable limiting size of subject text -->
	<!--
	<xsl:template match="SUBJECT" mode="t_threadspage">
	Author:		Andy Harris
	Context:      /H2G2/FORUMTHREADS/THREAD/SUBJECT
	Purpose:	 Creates the SUBJECT link for the THREAD
	-->
	<xsl:template match="SUBJECT" mode="t_threadspage">
		<a href="{$root}F{../@FORUMID}?thread={../@THREADID}" xsl:use-attribute-sets="mSUBJECT_t_threadspage">
			<xsl:choose>
				<xsl:when test="string-length(.) = 0">
					No Discussion Title
				</xsl:when>
				<xsl:otherwise>
					<xsl:choose>
						<xsl:when test="string-length(.) &gt; 40">
							<xsl:value-of select="substring(., 1, 40)"/>...</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="."/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
		</a>
	</xsl:template>
</xsl:stylesheet>
