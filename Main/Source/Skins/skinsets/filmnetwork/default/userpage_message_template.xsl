<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
	<!ENTITY space "<xsl:text xmlns:xsl='http://www.w3.org/1999/XSL/Transform'> </xsl:text>">
]>
<xsl:stylesheet exclude-result-prefixes="msxsl local s dt" version="1.0"
	xmlns:dt="urn:schemas-microsoft-com:datatypes" xmlns:local="#local-functions"
	xmlns:msxsl="urn:schemas-microsoft-com:xslt"
	xmlns:s="urn:schemas-microsoft-com:xml-data"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<!-- 
     #####################################################################################
	   MESSAGE section of a user page
     ##################################################################################### 
	-->
	<xsl:template name="USER_MESSAGES">
		<a name="messages" />
		<table border="0" cellpadding="0" cellspacing="0" class="profileTitle"
			width="371">
			<tr>
				<td valign="top" width="371">
					<h2>
						<img alt="messages" height="24"
							src="{$imagesource}furniture/myprofile/heading_messages.gif"
							width="130" />
					</h2>
				</td>
			</tr>
		</table>
		<table border="0" cellpadding="0" cellspacing="0" width="371">
			<!-- Spacer row -->
			<tr>
				<td>
					<img alt="" class="tiny" height="1" src="/f/t.gif" width="371" />
				</td>
			</tr>
			<tr>
				<td valign="top">
					<div class="textmedium">
						<strong>
							<!-- email alerts box -->
							<xsl:if test="$ownerisviewer = 1 and $isIndustryProf != 1 ">
								<table border="0" cellpadding="0" cellspacing="0"
									class="largeEmailBox">
									<tr class="textMedium manageEmails">
										<td class="emailImageCell">
											<img alt="" height="20" id="manageIcon"
												src="http://www.bbc.co.uk/filmnetwork/images/furniture/manage_alerts.gif"
												width="25" />
										</td>
										<td>
											<strong>
												<a
													href="F{/H2G2/ARTICLEFORUM/FORUMTHREADS/@FORUMID}?s_alertsRefresh=4"
														>subscribe/unsubscribe to receive email alerts<br />when new messages are left for you&nbsp;<img
														alt="" height="7"
														src="http://www.bbc.co.uk/filmnetwork/images/furniture/myprofile/arrowdark.gif"
														width="4" /></a>
											</strong>
										</td>
									</tr>
									<tr class="profileMoreAbout moreEmails">
										<td class="emailInfoImage">
											<img alt="" height="18"
												src="http://www.bbc.co.uk/filmnetwork/images/furniture/more_alerts.gif"
												width="18" />
										</td>
										<td>
											<a href="sitehelpemailalerts"
													>more about email alerts&nbsp;<img
													alt="" height="7"
													src="http://www.bbc.co.uk/filmnetwork/images/furniture/myprofile/arrowdark.gif"
													width="4" />
											</a>
										</td>
									</tr>
								</table>
								<br />
							</xsl:if>
							<xsl:choose>
								<xsl:when test="count(/H2G2/RECENT-POSTS/POST-LIST/POST) > 0">
									<xsl:choose>
										<xsl:when test="$ownerisviewer = 1 and $isIndustryProf=1"
											>Below are replies to messages you have left for Film Network members. To reply, click on the message title.</xsl:when>
										<xsl:when test="$isIndustryProf=1"> </xsl:when>
										<xsl:otherwise>Below is a list of messages left for
											<xsl:choose>
												<xsl:when
													test="string-length(/H2G2/PAGE-OWNER/USER/FIRSTNAMES) &gt; 0">
													<xsl:value-of
														select="/H2G2/PAGE-OWNER/USER/FIRSTNAMES"
														 />&nbsp;
													<xsl:value-of
														select="/H2G2/PAGE-OWNER/USER/LASTNAME" />
												</xsl:when>
												<xsl:otherwise>
													<xsl:choose>
														<xsl:when
															test="string-length(/H2G2/PAGE-OWNER/USER/FIRSTNAMES) &gt; 0">
															<xsl:value-of
																select="/H2G2/PAGE-OWNER/USER/FIRSTNAMES"
																 />&nbsp;
															<xsl:value-of
																select="/H2G2/PAGE-OWNER/USER/LASTNAME" />
														</xsl:when>
														<xsl:otherwise>
															<xsl:value-of
																select="/H2G2/PAGE-OWNER/USER/USERNAME" />
														</xsl:otherwise>
													</xsl:choose>
												</xsl:otherwise>
											</xsl:choose> by other members. Click the subject to read the message.
										</xsl:otherwise>
									</xsl:choose>
									<!-- 12px Spacer table -->
									<table border="0" cellpadding="0" cellspacing="0" width="371">
										<tr>
											<td height="12" />
										</tr>
									</table>
									<!-- END 12px Spacer table -->
									<!-- messages content table -->
									<xsl:apply-templates mode="c_userpage" select="ARTICLEFORUM" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:choose>
										<xsl:when test="$ownerisviewer = 1 and $isIndustryProf=1"
											>This is where replies to messages you leave for Film Network members will appear. To leave someone a message, click on the person's name and then click "leave me a message" on their profile page. Members are unable to leave you messages.</xsl:when>
										<xsl:when test="$ownerisviewer = 1"
											>Links to messages left by other members will appear here</xsl:when>
										<xsl:otherwise>
											<xsl:choose>
												<xsl:when
													test="string-length(/H2G2/PAGE-OWNER/USER/FIRSTNAMES) &gt; 0">
													<xsl:value-of
														select="/H2G2/PAGE-OWNER/USER/FIRSTNAMES"
														 />&nbsp;
													<xsl:value-of
														select="/H2G2/PAGE-OWNER/USER/LASTNAME" />
												</xsl:when>
												<xsl:otherwise>
													<xsl:value-of select="/H2G2/PAGE-OWNER/USER/USERNAME"
													 />
												</xsl:otherwise>
											</xsl:choose> currently has no messages.
										</xsl:otherwise>
									</xsl:choose>
								</xsl:otherwise>
							</xsl:choose>
						</strong>
					</div>
					<xsl:choose>
						<xsl:when test="$ownerisviewer != 1">
							<xsl:apply-templates mode="c_leaveamessage"
								select="/H2G2/ARTICLEFORUM/FORUMTHREADS/@FORUMID" />
						</xsl:when>
					</xsl:choose>
					<div class="profileMoreAbout">
						<a href="{$root}SiteHelpProfile#messages"
								>more about messages&nbsp;<img alt="" height="7"
								src="{$imagesource}furniture/myprofile/arrowdark.gif" width="4"
							 /></a>
					</div>
				</td>
			</tr>
		</table>
		<!-- END more messages table -->
	</xsl:template>

	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
						ARTICLEFORUM Object for the userpage 
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<xsl:template match="ARTICLEFORUM" mode="r_userpage">
		<!-- all my messages list -->
		<xsl:apply-templates mode="c_userpage" select="FORUMTHREADS" />
		<!-- all my messages links -->
		<xsl:if test="FORUMTHREADS/@TOTALTHREADS > 5">
			<!-- more messages table -->
			<table border="0" cellpadding="0" cellspacing="0" width="371">
				<tr>
					<td valign="top" width="371">
						<div class="morecommments"><strong>
								<xsl:apply-templates mode="r_viewallthreadsup" select="." />
							</strong>&nbsp;<img alt="" height="7"
								src="{$imagesource}furniture/myprofile/arrowdark.gif" width="4"
							 /></div>
					</td>
				</tr>
			</table>
		</xsl:if>
	</xsl:template>

	<!--
	<xsl:template match="FORUMTHREADS" mode="c_userpage">
	Author:		Tom Whitehouse
	Context:      /H2G2/ARTICLEFORUM/FORUMTHREADS
	Purpose:	 Calls the correct FORUMTHREADS container or 'Register' text
	-->
	<xsl:template match="FORUMTHREADS" mode="c_userpage">
		<xsl:choose>
			<xsl:when test="THREAD">
				<xsl:apply-templates mode="full_userpage" select="." />
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="$registered=1">
						<xsl:apply-templates mode="empty_userpage" select="." />
						<br />
					</xsl:when>
					<xsl:otherwise>
						<xsl:copy-of select="$m_registertodiscussuserpage" />
						<br />
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>


	<!--
	<xsl:template match="@FORUMID" mode="c_leaveamessage">
	Author:		Tom Whitehouse
	Context:      /H2G2/ARTICLEFORUM/FORUMTHREADS/@FORUMID
	Purpose:	 leave me a message
	-->
	<xsl:template match="@FORUMID" mode="c_leaveamessage">
		<!-- leave a message -->
		<table border="0" cellpadding="0" cellspacing="0" width="371">
			<tr>
				<td valign="top" width="371">
					<div class="morecommments"><strong>
							<a>
								<xsl:attribute name="href">
									<xsl:call-template name="sso_message_signin" />
								</xsl:attribute>leave me a message</a>
						</strong>&nbsp;<img alt="" height="7"
							src="{$imagesource}furniture/myprofile/arrowdark.gif" width="4"
					 /></div>
				</td>
			</tr>
		</table>
	</xsl:template>
	
	<!--
	<xsl:template match="ARTICLEFORUM" mode="r_viewallthreadsup">
	Description: Presentation of the 'Click to see more conversations' link
	 $m_clickmoreuserpageconv -->
	<xsl:template match="ARTICLEFORUM" mode="r_viewallthreadsup">
		<a href="{$root}F{FORUMTHREADS/@FORUMID}"
			xsl:use-attribute-sets="maFORUMID_MoreConv">
			<xsl:copy-of select="$m_clickmoreuserpageconv" />
		</a>
	</xsl:template>
	
	<!--
	<xsl:template match="FORUMTHREADS" mode="empty_userpage">
	Description: Presentation of the 'Be the first person to talk about this article' link 
	 -->
	<xsl:template match="FORUMTHREADS" mode="empty_userpage">
		<xsl:choose>
			<xsl:when test="$ownerisviewer = 1">
				<div class="box2">
					<xsl:copy-of select="$m_nomessagesowner" />
				</div>
			</xsl:when>
			<xsl:otherwise>
				<div class="box2">
					<xsl:copy-of select="$m_nomessages" />
				</div>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!--
	<xsl:template match="FORUMTHREADS" mode="full_userpage">
	Description: Presentation of the forum threads if some do indeed exist
	 -->
	<xsl:template match="FORUMTHREADS" mode="full_userpage">
		<table border="0" cellpadding="0" cellspacing="0" width="371">
			<xsl:for-each select="THREAD[position() &lt;=$articlelimitentries]">
				<tr>
					<td class="lightband" valign="top" width="371">
						<xsl:attribute name="class">
							<xsl:choose>
								<xsl:when test="position() mod 2 = 0">lightband</xsl:when>
								<xsl:otherwise>darkband</xsl:otherwise>
							</xsl:choose>
						</xsl:attribute>
						<div class="titlecentcol">
							<img align="absmiddle" alt="" height="5"
								src="{$imagesource}furniture/myprofile/bullett.gif" width="5" />
							<strong>&nbsp;<xsl:apply-templates mode="c_userpage"
									select="." /></strong>
							<xsl:if
								test="LASTPOST/USER/USERID = /H2G2/PAGE-OWNER/USER/USERID and $ownerisviewer=1"
									>&nbsp;<img align="middle" alt="" height="11"
									src="{$imagesource}furniture/drama/reply.gif" width="18"
							 /></xsl:if>
						</div>
						<div class="smallsubmenu2">message from <xsl:apply-templates
								mode="t_userposter" select="." /> | left <xsl:apply-templates
								mode="short1" select="FIRSTPOST/DATE"
								 /> | last reply <xsl:apply-templates
								mode="t_threaddatepostedlinkup" select="@THREADID"
							 />
						</div>
					</td>
				</tr>
			</xsl:for-each>
		</table>
	</xsl:template>

	<!--
	<xsl:template match="@THREADID" mode="t_threaddatepostedlinkup">
	Context:      /H2G2/ARTICLEFORUM/FORUMTHREADS/THREAD/@THREADID
	Purpose:	 Creates 'Date posted' link
	-->
	<xsl:template match="@THREADID" mode="t_threaddatepostedlinkup">
		<a class="textdark">
			<xsl:attribute name="HREF"><xsl:value-of select="$root" />F<xsl:value-of
					select="." />?thread=<xsl:value-of select="../@THREADID"
					 />&amp;post=<xsl:value-of select="../LASTPOST/@POSTID"
					 />#p<xsl:value-of select="../LASTPOST/@POSTID" /></xsl:attribute>
			<xsl:apply-templates mode="short1" select="../DATEPOSTED" />
		</a>
	</xsl:template>

	<!--
 	<xsl:template match="THREAD" mode="r_userpage">
 	Presentation of each individual thread listed at the bottom of the article
 	-->
	<xsl:template match="THREAD" mode="r_userpage">
		<xsl:apply-templates mode="t_threadtitlelinkup" select="@THREADID" />
	</xsl:template>
	
	<!--
	Author:	Trent Williams
	Context: Get username of message poster
 	<xsl:template match="THREAD" mode="t_userposter">
 	-->
	<xsl:template match="THREAD" mode="t_userposter">
		<a class="textdark">
			<xsl:attribute name="href"><xsl:value-of select="$root" />U<xsl:value-of
					select="FIRSTPOST/USER/USERID" /></xsl:attribute>
			<xsl:choose>
				<xsl:when test="string-length(FIRSTPOST/USER/FIRSTNAMES) &gt; 0">
					<xsl:value-of select="FIRSTPOST/USER/FIRSTNAMES"
						 />&nbsp;
			<xsl:value-of select="FIRSTPOST/USER/LASTNAME" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="FIRSTPOST/USER/USERNAME" />
				</xsl:otherwise>
			</xsl:choose>
		</a>
	</xsl:template>
	
	<!--
	<xsl:template match="@THREADID" mode="t_threadtitlelinkup">
	Author:		Tom Whitehouse
	Context:      /H2G2/ARTICLEFORUM/FORUMTHREADS/THREAD/@THREADID
	Purpose:	 Creates the SUBJECT link for the THREAD
	-->
	<xsl:template match="@THREADID" mode="t_threadtitlelinkup">
		<a>
			<xsl:attribute name="href"><xsl:value-of select="$root" />F<xsl:value-of
					select="../@FORUMID" />?thread=<xsl:value-of select="." /></xsl:attribute>
			<xsl:apply-templates mode="nosubject" select="../SUBJECT" />
		</a>
	</xsl:template>

</xsl:stylesheet>