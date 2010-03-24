<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<xsl:import href="../../../base/base-threadspage.xsl"/>
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
	<!-- DEBUG -->
	<xsl:call-template name="TRACE">
		<xsl:with-param name="message">THREADS_MAINBODY</xsl:with-param>
		<xsl:with-param name="pagename">threadspage.xsl</xsl:with-param>
	</xsl:call-template>
	<!-- DEBUG -->
	
	<div class="soupContent">
	<xsl:choose>
		<xsl:when test="/H2G2/VIEWING-USER/USER/USERID=/H2G2/FORUMSOURCE/USERPAGE/USER/USERID">
			<h1><img src="{$imagesource}h1_yourmessages.gif" alt="your messages" width="187" height="26" /></h1>
		</xsl:when>
		<xsl:otherwise>
			<h1><img src="{$imagesource}h1_theirmessages.gif" alt="their messages" width="187" height="26" /><span class="userName"><xsl:value-of select="/H2G2/FORUMSOURCE/USERPAGE/USER/FIRSTNAMES"/><xsl:text> </xsl:text><xsl:value-of select="/H2G2/FORUMSOURCE/USERPAGE/USER/LASTNAME"/></span><span class="clr"></span></h1>
		</xsl:otherwise>
	</xsl:choose>
	
	<div id="yourPortfolio" class="personalspace">
		<div class="inner">
			<div class="col1">
				<div class="margins">
					<xsl:choose>
						<xsl:when test="/H2G2/VIEWING-USER/USER/USERID=/H2G2/FORUMSOURCE/USERPAGE/USER/USERID">
							<h2>Messages left for you by other members</h2>
						</xsl:when>
						<xsl:otherwise>
							<h2>Messages left for this person by other members</h2>
						</xsl:otherwise>
					</xsl:choose>
				
					<!-- pagination block -->
					<div class="paginationBlock">
						<xsl:apply-templates select="FORUMTHREADS" mode="c_previouspage"/>
							<xsl:apply-templates select="FORUMTHREADS" mode="c_threadblocks"/>
						<xsl:apply-templates select="FORUMTHREADS" mode="c_nextpage"/>
					</div>
					
					<!-- threads-->
					<ul class="messagesList allMessages">
						<xsl:apply-templates select="FORUMTHREADS" mode="c_threadspage"/>
					</ul>
					
					<!-- pagination block -->
					<div class="paginationBlock">
						<xsl:apply-templates select="FORUMTHREADS" mode="c_previouspage"/>
							<xsl:apply-templates select="FORUMTHREADS" mode="c_threadblocks"/>
						<xsl:apply-templates select="FORUMTHREADS" mode="c_nextpage"/>
					</div>
										
				</div>
			</div><!--// col1 -->
		
			<div class="col2">
				<div class="margins">
					<div class="contentBlock">
						<!-- Arrow list component -->
						<ul class="arrowList">
						<xsl:variable name="userid" select="/H2G2/FORUMSOURCE/USERPAGE/USER/USERID" />
						<xsl:variable name="forumid" select="/H2G2/FORUMSOURCE/ARTICLE/ARTICLEINFO/FORUMID" />
						<xsl:choose>
								<xsl:when test="/H2G2/VIEWING-USER/USER/USERID=$userid">
									<li class="backArrow"><a href="{$root}U{$userid}">Back to your personal space</a></li>
									<li class="arrow"><a href="UAMA{$userid}?s_display=submissionlog&amp;s_fid={$forumid}">Submission Log</a></li>
									<li class="arrow"><a href="UAMA{$userid}?ContentType=3&amp;s_fid={$forumid}">All your video</a></li>
									<li class="arrow"><a href="UAMA{$userid}?ContentType=1&amp;s_fid={$forumid}">All your images</a></li>
									<li class="arrow"><a href="UAMA{$userid}?ContentType=2&amp;s_fid={$forumid}">All your audio</a></li>
									<!-- <li class="arrow"><a href="UAMA{$userid}?s_display=programmechallenges">All your challenges</a></li> -->
									<li class="arrow"><a href="Watch{$userid}">Contacts</a></li>
									<li class="arrow"><a href="{$root}yourspace">Help</a></li>
								</xsl:when>
								<xsl:otherwise>
									<li class="backArrow"><a href="{$root}U{$userid}">Back to their personal space</a></li>
									<li class="arrow"><a href="UAMA{$userid}?ContentType=3&amp;s_fid={$forumid}">All their video</a></li>
									<li class="arrow"><a href="UAMA{$userid}?ContentType=1&amp;s_fid={$forumid}">All their images</a></li>
									<li class="arrow"><a href="UAMA{$userid}?ContentType=2&amp;s_fid={$forumid}">All their audio</a></li>
									<!-- <li class="arrow"><a href="UAMA{$userid}?s_display=programmechallenges">All their challenges</a></li> -->
									<li class="arrow"><a href="Watch{$userid}">Contacts</a></li>
									<li class="arrow"><a href="{$root}yourspace">Help</a></li>
								</xsl:otherwise>
							</xsl:choose>
						</ul>
						<!--// Arrow list component -->
					</div>
					
					
					<xsl:if test="/H2G2/VIEWING-USER/USER/USERID!=/H2G2/FORUMSOURCE/USERPAGE/USER/USERID">
						<div class="contentBlock">
							<h2>Leave a message</h2>							
							<p>If you want to leave this person a brand new message <a><xsl:attribute name="href"><xsl:call-template name="sso_addcomment_signin"/></xsl:attribute>click here</a></p>
						</div>
					</xsl:if>
					<a href="{$root}submityourstuff" class="button twoline"><span><span><span>Get your stuff on ComedySoup</span></span></span></a>
				</div>
			</div><!--// col2 -->
			<div class="clr"></div>
		</div>
	</div>
	</div>


	<xsl:if test="$test_IsEditor">
		<div class="editbox">
			<xsl:apply-templates select="FORUMTHREADS/MODERATIONSTATUS" mode="c_threadspage"/>
		</div>
	</xsl:if>
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
		<li class="forumThread">
			<div class="headerRow">
				<h3 class="standardHeader"><xsl:apply-templates select="SUBJECT" mode="t_threadspage"/><xsl:if test="SUBJECT=''"><a href="{$root}F{@FORUMID}?thread={@THREADID}">No Subject</a></xsl:if></h3>
				<div class="complain"></div>
				<div class="clr"></div>
			</div>
			<div class="detailsRow">
				<xsl:apply-templates select="LASTPOST" mode="c_threadspage"/>
				<div class="clr"></div>
			</div>
			
			<xsl:if test="$test_IsEditor">
				<div class="editbox">
					<xsl:apply-templates select="@THREADID" mode="c_movethreadgadget"/>
					<xsl:apply-templates select="." mode="c_hidethread"/>
				</div>
			</xsl:if>
		</li>
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
		<div class="author">Updated by: <xsl:apply-templates select="USER" mode="t_lastposttp"/></div>
		<div class="date"><xsl:value-of select="DATE/@DAYNAME"/><xsl:text> </xsl:text><xsl:value-of select="DATE/@DAY"/><xsl:text> </xsl:text><xsl:value-of select="DATE/@MONTHNAME"/><xsl:text> </xsl:text><xsl:value-of select="substring(DATE/@YEAR, 3, 2)"/><xsl:text> </xsl:text></div>
	</xsl:template>
	
	<xsl:template match="USER" mode="t_lastposttp">
		<a href="{$root}U{USERID}" xsl:use-attribute-sets="mUSER_t_lastposttp">
			<xsl:value-of select="FIRSTNAMES"/>&nbsp;<xsl:value-of select="LASTNAME"/>
		</a>
	</xsl:template>
	
	<!--
	<xsl:template match="@THREADID" mode="r_movethreadgadget">
	Use: Presentation of the move thread editorial tool link
	 -->
	<xsl:template match="@THREADID" mode="r_movethreadgadget">
		<xsl:apply-imports/>
		<br/>
	</xsl:template>
	<!--
	<xsl:template match="@THREADID" mode="r_hidethread">
	Use: Presentation of the hide thread editorial tool link
	 -->
	<xsl:template match="THREAD" mode="r_hidethread">
		<xsl:apply-imports/>
		<br/>
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
	<xsl:template match="FORUMTHREADS" mode="r_threadblocks">
	Use: Presentation of the thread block container
	 -->
	<xsl:template match="FORUMTHREADS" mode="r_threadblocks">
		<xsl:apply-templates select="." mode="c_threadblockdisplayprev"/>
		<xsl:apply-templates select="." mode="c_threadblockdisplay"/>
		<xsl:apply-templates select="." mode="c_threadblockdisplaynext"/>
	</xsl:template>
	
	
	<!-- override base file to add value of 'no' to $onlink -->
	<xsl:template match="FORUMTHREADS" mode="c_threadblockdisplay">
		<xsl:param name="onlink" select="'no'" />
		<xsl:param name="skip" select="$tp_lowerrange"/>
		<xsl:apply-templates select="." mode="displayblocktp">
			<xsl:with-param name="skip" select="$skip"/>
			<xsl:with-param name="onlink" select="$onlink"/>
		</xsl:apply-templates>
		<xsl:if test="(($skip + @COUNT) &lt; @TOTALTHREADS) and ($skip &lt; $tp_upperrange)">
			<xsl:apply-templates select="." mode="c_threadblockdisplay">
				<xsl:with-param name="skip" select="$skip + @COUNT"/>
				<xsl:with-param name="onlink" select="$onlink"/>
			</xsl:apply-templates>
		</xsl:if>
	</xsl:template>
	
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
		<xsl:copy-of select="$url"/><xsl:text> </xsl:text>
	</xsl:template>
	<!-- 
	<xsl:template name="t_ontabcontent">
	Use: Controls the content of the link for the currently visible page
	-->
	<xsl:template name="t_threadontabcontent">
		<xsl:param name="range"/>
		<xsl:param name="pagenumber"/>
		<xsl:value-of select="$pagenumber"/><xsl:text> </xsl:text>
	</xsl:template>
	<!-- 
	<xsl:template match="FORUMTHREADS" mode="off_blockdisplay">
	Use: Controls the display of the block (outside the link) which is not currently on the page
	-->
	<xsl:template match="FORUMTHREADS" mode="off_threadblockdisplay">
		<xsl:param name="url"/>
		<xsl:copy-of select="$url"/><xsl:text> </xsl:text>
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
	<xsl:attribute-set name="mFORUMTHREADS_on_threadblockdisplay"/>
	<xsl:attribute-set name="mFORUMTHREADS_off_threadblockdisplay"/>
	<!-- 
	<xsl:template match="FORUMTHREADS" mode="r_newconversation">
	Use: Presentation of the 'New Conversation' link
	-->
	<xsl:template match="FORUMTHREADS" mode="r_newconversation">
		<xsl:apply-imports/>
	</xsl:template>
	<!-- 
	<xsl:template match="FORUMTHREADS" mode="link_firstpage">
	Use: Presentation of the 'First Page' link
	-->
	<xsl:template match="FORUMTHREADS" mode="link_firstpage">
		<xsl:apply-imports/>
		<br/>
	</xsl:template>
	<!-- 
	<xsl:template match="FORUMTHREADS" mode="link_lastpage">
	Use: Presentation of the 'Last Page' link
	-->
	<xsl:template match="FORUMTHREADS" mode="link_lastpage">
		<xsl:apply-imports/>
		<br/>
	</xsl:template>
	<!-- 
	<xsl:template match="FORUMTHREADS" mode="link_previouspage">
	Use: Presentation of the 'Previous Page' link
	-->
	<xsl:template match="FORUMTHREADS" mode="link_previouspage">
		<span class="prev_active"><b><a href="{$root}F{@FORUMID}?show={@COUNT}&amp;skip={number(@SKIPTO) - number(@COUNT)}" xsl:use-attribute-sets="mFORUMTHREADS_link_previouspage">
			<xsl:copy-of select="$m_previouspagethreads"/>
		</a></b>|</span>
	</xsl:template>
	<!-- 
	<xsl:template match="FORUMTHREADS" mode="link_nextpage">
	Use: Presentation of the 'Next Page' link
	-->
	<xsl:template match="FORUMTHREADS" mode="link_nextpage">
		<span class="next_active">|<b><a href="{$root}F{@FORUMID}?show={@COUNT}&amp;skip={number(@SKIPTO) + number(@COUNT)}" xsl:use-attribute-sets="mFORUMTHREADS_link_nextpage">
			<xsl:copy-of select="$m_nextpagethreads"/>
		</a></b></span>
	</xsl:template>
	
	<!-- 
	<xsl:template match="FORUMTHREADS" mode="text_firstpage">
	Use: Presentation of the 'On First Page' message
	-->
	<xsl:template match="FORUMTHREADS" mode="text_firstpage">
		<xsl:apply-imports/>
		<br/>
	</xsl:template>
	<!-- 
	<xsl:template match="FORUMTHREADS" mode="text_lastpage">
	Use: Presentation of the 'On Last Page' message
	-->
	<xsl:template match="FORUMTHREADS" mode="text_lastpage">
		<xsl:apply-imports/>
		<br/>
	</xsl:template>
	<!-- 
	<xsl:template match="FORUMTHREADS" mode="text_previouspage">
	Use: Presentation of the 'No Previous Page' message
	-->
	<xsl:template match="FORUMTHREADS" mode="text_previouspage">
		<span class="prev_dormant">previous<span>|</span></span>
	</xsl:template>
	<!-- 
	<xsl:template match="FORUMTHREADS" mode="text_nextpage">
	Use: Presentation of the 'No Next Page' message
	-->
	<xsl:template match="FORUMTHREADS" mode="text_nextpage">
		<span class="next_dormant">|<b>next</b></span>
	</xsl:template>
	
	<!-- override base files as don't want current page to be a link -->
	
	
	<!--==                                                         ==-->
	<!--== SLIGHT VARIATION ON THREADS FOR PERSONAL SPACE MESSAGES ==-->
	<!--==                                                         ==-->
	<xsl:template match="FORUMTHREADS" mode="t_threadspage_userpage">
		<xsl:choose>
			<xsl:when test="count(THREAD) &gt; 0">
				<xsl:apply-templates select="THREAD" mode="t_threadspage_userpage"/>
			</xsl:when>
			<xsl:otherwise>
				There currently are no messages.
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="THREAD" mode="t_threadspage_userpage">
	Use: Presentation of an individual thread in a THREADS page
	 -->
	<xsl:template match="THREAD" mode="t_threadspage_userpage">
		<xsl:if test="position() &lt;= $userpage_max_threads">
			<li class="forumThreadUserpage">
				<div class="headerRow">
					<h3 class="standardHeader starIcon"><xsl:apply-templates select="SUBJECT" mode="t_threadspage"/><xsl:if test="SUBJECT=''"><a href="{$root}F{@FORUMID}?thread={@THREADID}">No Subject</a></xsl:if></h3>
					<div class="complain"></div>
					<div class="clr"></div>
				</div>
				<div class="detailsRow">
					<xsl:apply-templates select="FIRSTPOST" mode="t_threadspage_userpage"/>
					<div class="clr"></div>
				</div>

				<xsl:if test="$test_IsEditor">
					<div class="editbox">
						<xsl:apply-templates select="@THREADID" mode="c_movethreadgadget"/>
						<xsl:apply-templates select="." mode="c_hidethread"/>
					</div>
				</xsl:if>
			</li>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="DATE" mode="r_userpagepostdate">
		<xsl:apply-templates select="."/>
	</xsl:template>
	
	<xsl:template match="FIRSTPOST" mode="t_threadspage_userpage">
		<div class="author">Left by: <xsl:apply-templates select="USER/USERNAME" mode="c_multiposts"/></div>
		<div class="date">| <xsl:value-of select="DATE/@DAYNAME"/><xsl:text> </xsl:text><xsl:value-of select="DATE/@DAY"/><xsl:text> </xsl:text><xsl:value-of select="DATE/@MONTHNAME"/><xsl:text> </xsl:text><xsl:value-of select="substring(DATE/@YEAR, 3, 2)"/><xsl:text> </xsl:text></div>
	</xsl:template>
	
	
</xsl:stylesheet>
