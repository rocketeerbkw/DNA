<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<xsl:import href="../../../base/base-watcheduserspage.xsl"/>
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
									Page - Level  template
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<xsl:template name="WATCHED-USERS_MAINBODY">
	
	<!-- DEBUG -->
	<xsl:call-template name="TRACE">
		<xsl:with-param name="message">WATCHED-USERS_MAINBODY</xsl:with-param>
		<xsl:with-param name="pagename">watcheduserpage.xsl</xsl:with-param>
	</xsl:call-template>
	<!-- DEBUG -->
	
	<xsl:choose>
		<xsl:when test="$ownerisviewer = 1">
			<h1><img src="{$imagesource}h1_yourcontacts.gif" alt="your contacts" width="166" height="26" /></h1>
		</xsl:when>
		<xsl:otherwise>
			<h1><img src="{$imagesource}h1_theircontacts.gif" alt="their contacts" width="161" height="26" /><span class="userName"><xsl:value-of select="/H2G2/PAGE-OWNER/USER/FIRSTNAMES"/><xsl:text> </xsl:text><xsl:value-of select="/H2G2/PAGE-OWNER/USER/LASTNAME"/></span><span class="clr"></span></h1>
		</xsl:otherwise>
	</xsl:choose>
	
 	<div id="yourPortfolio" class="personalspace">
		<div class="inner">
			<div class="col1">
				<div class="margins">
					
				<!-- Results list component -->
					<xsl:apply-templates select="WATCHED-USER-LIST" mode="c_wupage"/>
					
				</div>
			</div><!--// col1 -->
		
			<div class="col2">
				<div class="margins">
					<!-- Arrow list component -->
					<ul class="arrowList">
						<xsl:variable name="userid" select="PAGE-OWNER/USER/USERID"/>
						<xsl:variable name="forumid" select="ARTICLE/ARTICLEINFO/FORUMID"/>
						<xsl:choose>
								<xsl:when test="$ownerisviewer = 1">
									<li class="backArrow"><a href="{$root}U{$userid}">Back to your personal space</a></li>
									<li class="arrow"><a href="UAMA{$userid}?s_display=submissionlog&amp;s_fid={ARTICLE/ARTICLEINFO/FORUMID}">Submission Log</a></li>
									<li class="arrow"><a href="UAMA{$userid}?ContentType=3&amp;s_fid={ARTICLE/ARTICLEINFO/FORUMID}">All your video</a></li>
									<li class="arrow"><a href="UAMA{$userid}?ContentType=1&amp;s_fid={ARTICLE/ARTICLEINFO/FORUMID}">All your images</a></li>
									<li class="arrow"><a href="UAMA{$userid}?ContentType=2&amp;s_fid={ARTICLE/ARTICLEINFO/FORUMID}">All your audio</a></li>
									<!-- <li class="arrow"><a href="UAMA{$userid}?s_display=programmechallenges">All your challenges</a></li> -->
									<li class="arrow"><a href="F{$forumid}">Messages</a></li>
								</xsl:when>
								<xsl:otherwise>
									<li class="backArrow"><a href="{$root}U{$userid}">Back to their personal space</a></li>
									<li class="arrow"><a href="UAMA{$userid}?ContentType=3&amp;s_fid={$forumid}">All their video</a></li>
									<li class="arrow"><a href="UAMA{$userid}?ContentType=1&amp;s_fid={$forumid}">All their images</a></li>
									<li class="arrow"><a href="UAMA{$userid}?ContentType=2&amp;s_fid={$forumid}">All their audio</a></li>
									<!-- <li class="arrow"><a href="UAMA{$userid}?s_display=programmechallenges">All their challenges</a></li> -->
									<li class="arrow"><a href="F{$forumid}">Messages</a><xsl:text> </xsl:text><xsl:apply-templates select="/H2G2/ARTICLEFORUM/FORUMTHREADS/@FORUMID" mode="c_leaveamessage"/></li>
								</xsl:otherwise>
							</xsl:choose>
						<li class="arrow"><a href="{$root}yourspace">Help</a></li>
					</ul>
					<!--// Arrow list component -->
					<a href="{$root}submityourstuff" class="button"><span><span><span>Get your stuff on ComedySoup</span></span></span></a>
				</div>
			</div><!--// col2 -->
			<div class="clr"></div>
		</div>
	</div>
	</xsl:template>
	<!--
	<xsl:template match="WATCH-USER-RESULT" mode="r_wupage">
	Description: Presentation of the WATCH-USER-RESULT object
	 -->
	<xsl:template match="WATCH-USER-RESULT" mode="r_wupage">
		<xsl:apply-imports/>
	</xsl:template>
	<!--
	<xsl:template match="WATCHED-USER-LIST" mode="r_wupage">
	Description: Presentation of the WATCHED-USER-LIST object
	 -->
	<xsl:template match="WATCHED-USER-LIST" mode="r_wupage">
	<ul class="contactsList">
		<xsl:apply-templates select="USER" mode="c_wupwatcheduser"/>
	</ul>
	</xsl:template>
	<!--
	<xsl:template match="USER" mode="r_wupwatcheduser">
	Description: Presentation of the WATCHED-USER-LIST/USER object
	 -->
	<xsl:template match="USER" mode="r_wupwatcheduser">
	<li>
		<div class="name">
		<a href="{$root}U{USERID}">
		<xsl:choose>
			<xsl:when test="FIRSTNAMES/text() and LASTNAME/text()">
				<xsl:value-of select="FIRSTNAMES"/><xsl:text> </xsl:text><xsl:value-of select="LASTNAME"/>
			</xsl:when>
			<xsl:otherwise>
			<xsl:value-of select="USERNAME"/>
			</xsl:otherwise>
		</xsl:choose>
		</a></div>
		
		<xsl:apply-templates select="." mode="c_watcheduserdelete"/>
		<div class="job">&nbsp;<!-- &nbsp; is required for the layout --></div> 
	</li>
	</xsl:template>
	
	
	<!--
	<xsl:template match="USER" mode="r_watcheduserdelete">
	Context:      /H2G2/WATCHED-USER-LIST/USER
	Purpose:	 Creates the 'Delete this user from list' link
	-->
	<xsl:template match="USER" mode="r_watcheduserdelete">
		<div class="option">(<a href="{$root}Watch{../@USERID}?delete=yes&amp;duser={USERID}" xsl:use-attribute-sets="mUSER_r_watcheduserdelete">
			<xsl:copy-of select="$m_delete"/>
		</a>)</div>
	</xsl:template>
	
	<!--
	<xsl:template match="USER" mode="r_wupwatcheduserdelete">
	Description: Presentation of the 'Delete' link
	 -->
	<xsl:template match="USER" mode="r_wupwatcheduserdelete">
		<xsl:apply-imports/>
	</xsl:template>
	<!--
	<xsl:template match="WATCHED-USER-LIST" mode="r_wupfriendsjournals">
	Description: Presentation of the 'Views friends journals' link
	 -->
	<xsl:template match="WATCHED-USER-LIST" mode="r_wupfriendsjournals">
		<xsl:apply-imports/>
		<br/>
	</xsl:template>
	<!--
	<xsl:template match="WATCHED-USER-LIST" mode="r_wupdeletemany">
	Description: Presentation of the 'Delete many friends' link
	 -->
	<xsl:template match="WATCHED-USER-LIST" mode="r_wupdeletemany">
		<xsl:apply-imports/>
		<br/>
	</xsl:template>
	<!--
	<xsl:template match="WATCHING-USER-LIST" mode="r_wupage">
	Description: Presentation of the WATCHING-USER-LIST object
	 -->
	<xsl:template match="WATCHING-USER-LIST" mode="r_wupage">
		<xsl:apply-templates select="." mode="t_wupwatchingintroduction"/>
		<br/>
		<xsl:apply-templates select="USER" mode="c_wupwatchinguser"/>
	</xsl:template>
	<!--
	<xsl:template match="USER" mode="r_wupwatchinguser">
	Description: Presentation of the WATCHING-USER-LIST/USER object
	 -->
	<xsl:template match="USER" mode="r_wupwatchinguser">
		<xsl:apply-templates select="." mode="t_watchingusername"/>
		<br/>
		<xsl:apply-templates select="." mode="t_watchinguserpage"/>
		<br/>
		<xsl:apply-templates select="." mode="t_watchinguserjournal"/>
		<br/>
	</xsl:template>
	<!--
	<xsl:template match="WATCHED-USER-POSTS" mode="r_wupage">
	Description: Presentation of the WATCHED-USER-POSTS object
	 -->
	<xsl:template match="WATCHED-USER-POSTS" mode="r_wupage">
		<xsl:apply-templates select="." mode="c_firstpage"/>
		<xsl:apply-templates select="." mode="c_lastpage"/>
		<xsl:apply-templates select="." mode="c_previouspage"/>
		<xsl:apply-templates select="." mode="c_nextpage"/>
		<xsl:apply-templates select="." mode="c_threadblocks"/>
		<xsl:apply-templates select="." mode="t_backwatcheduserpage"/>
		<br/>
		<br/>
		<xsl:apply-templates select="WATCHED-USER-POST" mode="c_wupage"/>
	</xsl:template>
	<!-- 
	<xsl:template match="WATCHED-USER-POSTS" mode="link_firstpage">
	Use: Presentation of the 'First Page' link
	-->
	<xsl:template match="WATCHED-USER-POSTS" mode="link_firstpage">
		<xsl:apply-imports/>
		<br/>
	</xsl:template>
	<!-- 
	<xsl:template match="WATCHED-USER-POSTS" mode="link_lastpage">
	Use: Presentation of the 'Last Page' link
	-->
	<xsl:template match="WATCHED-USER-POSTS" mode="link_lastpage">
		<xsl:apply-imports/>
		<br/>
	</xsl:template>
	<!-- 
	<xsl:template match="WATCHED-USER-POSTS" mode="link_previouspage">
	Use: Presentation of the 'Previous Page' link
	-->
	<xsl:template match="WATCHED-USER-POSTS" mode="link_previouspage">
		<xsl:apply-imports/>
		<br/>
	</xsl:template>
	<!-- 
	<xsl:template match="WATCHED-USER-POSTS" mode="link_nextpage">
	Use: Presentation of the 'Next Page' link
	-->
	<xsl:template match="WATCHED-USER-POSTS" mode="link_nextpage">
		<xsl:apply-imports/>
		<br/>
	</xsl:template>
	<!-- 
	<xsl:template match="WATCHED-USER-POSTS" mode="text_firstpage">
	Use: Presentation of the 'On First Page' message
	-->
	<xsl:template match="WATCHED-USER-POSTS" mode="text_firstpage">
		<xsl:apply-imports/>
		<br/>
	</xsl:template>
	<!-- 
	<xsl:template match="WATCHED-USER-POSTS" mode="text_lastpage">
	Use: Presentation of the 'On Last Page' message
	-->
	<xsl:template match="WATCHED-USER-POSTS" mode="text_lastpage">
		<xsl:apply-imports/>
		<br/>
	</xsl:template>
	<!-- 
	<xsl:template match="WATCHED-USER-POSTS" mode="text_previouspage">
	Use: Presentation of the 'No Previous Page' message
	-->
	<xsl:template match="WATCHED-USER-POSTS" mode="text_previouspage">
		<xsl:apply-imports/>
		<br/>
	</xsl:template>
	<!-- 
	<xsl:template match="WATCHED-USER-POSTS" mode="text_nextpage">
	Use: Presentation of the 'No Next Page' message
	-->
	<xsl:template match="WATCHED-USER-POSTS" mode="text_nextpage">
		<xsl:apply-imports/>
		<br/>
	</xsl:template>
	<!--
	<xsl:template match="WATCHED-USER-POSTS" mode="r_threadblocks">
	Use: Presentation of the thread block container
	 -->
	<xsl:template match="WATCHED-USER-POSTS" mode="r_threadblocks">
		<xsl:apply-templates select="." mode="c_postblock"/>
		<br/>
	</xsl:template>
	<!-- 
	<xsl:template match="WATCHED-USER-POSTS" mode="on_postblock">
	Use: Display of current thread block  - eg 'now showing 21-40'
		  The range parameter must be present to show the numeric value of the thread you are on
	-->
	<xsl:template match="WATCHED-USER-POSTS" mode="on_postblock">
		<xsl:param name="range"/>
		<xsl:value-of select="concat($alt_nowshowing, ' ', $range, ' ')"/>
		<br/>
	</xsl:template>
	<!-- 
	<xsl:template match="WATCHED-USER-POSTS" mode="off_postblock">
	Use: Display of current post block  - eg 'now showing posts 21-40'
		  The range parameter must be present to show the numeric value of the thread you are on
	-->
	<xsl:template match="WATCHED-USER-POSTS" mode="off_postblock">
		<xsl:param name="range"/>
		<xsl:value-of select="concat($alt_show, ' ', $range, ' ')"/>
		<br/>
	</xsl:template>
	<!--
	<xsl:template match="WATCHED-USER-POST" mode="post_wupage">
	Description: Presentation of the WATCHED-USER-POST object
	 -->
	<xsl:template match="WATCHED-USER-POST" mode="post_wupage">
		<xsl:copy-of select="$m_postedby"/>
		<xsl:apply-templates select="USER/USERNAME" mode="t_wupost"/>
		<xsl:copy-of select="$m_on"/>
		<xsl:apply-templates select="DATEPOSTED/DATE" mode="t_wupost"/>
		<br/>
		<xsl:copy-of select="$m_fsubject"/>
		<xsl:apply-templates select="SUBJECT" mode="t_wupost"/>
		<br/>
		<br/>
		<xsl:apply-templates select="BODY" mode="t_wupost"/>
		<br/>
		<xsl:apply-templates select="." mode="t_wupostreplies"/>
		<br/>
		<xsl:apply-templates select="@POSTID" mode="t_wupostreply"/>
		<br/>
		<br/>
	</xsl:template>
	<!--
	<xsl:template match="WATCHED-USER-POST" mode="nopost_wupage">
	Description: Presentation of the 'No posts' message
	 -->
	<xsl:template match="WATCHED-USER-POST" mode="nopost_wupage">
		<xsl:copy-of select="$m_noentriestodisplay"/>
		<br/>
	</xsl:template>
</xsl:stylesheet>
