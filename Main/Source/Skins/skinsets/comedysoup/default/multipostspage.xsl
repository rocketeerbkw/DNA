<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<xsl:import href="../../../base/base-multipostspage.xsl"/>
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
									Page - Level  template
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<xsl:template name="MULTIPOSTS_MAINBODY">
		
	<!-- DEBUG -->
	<xsl:call-template name="TRACE">
		<xsl:with-param name="message">MULTIPOSTS_MAINBODY</xsl:with-param>
		<xsl:with-param name="pagename">multipostspage.xsl</xsl:with-param>
	</xsl:call-template>
	<!-- DEBUG -->
	
	<div class="soupContent">
	<xsl:choose>
		<xsl:when test="/H2G2/VIEWING-USER/USER/USERID=/H2G2/FORUMSOURCE/USERPAGE/USER/USERID">
			<h1><img src="{$imagesource}/h1_yourmessages.gif" alt="your messages" width="187" height="26" /></h1>
		</xsl:when>
		<xsl:otherwise>
			<h1><img src="{$imagesource}/h1_theirmessages.gif" alt="their messages" width="187" height="26" /><span class="userName"><xsl:value-of select="/H2G2/FORUMSOURCE/USERPAGE/USER/FIRSTNAMES"/><xsl:text> </xsl:text><xsl:value-of select="/H2G2/FORUMSOURCE/USERPAGE/USER/LASTNAME"/></span><span class="clr"></span></h1>
		</xsl:otherwise>
	</xsl:choose>
	
	
	<div id="yourPortfolio" class="personalspace">
		<div class="inner">
			<div class="col1">
				<div class="margins">
					<h2 class="standardHeader"><xsl:value-of select="/H2G2/FORUMTHREADPOSTS/FIRSTPOSTSUBJECT"/></h2>
					
					
					<!-- pagination block -->
					<xsl:call-template name="POSTS_PAGINATION_BLOCK" />
					
					<!-- posts -->				
					<xsl:apply-templates select="FORUMTHREADPOSTS" mode="c_multiposts"/>
					
					
					<!-- pagination block -->
					<xsl:call-template name="POSTS_PAGINATION_BLOCK" />
					
					<br />
					<xsl:apply-templates select="FORUMTHREADPOSTS/POST[@INDEX=0]/@POSTID" mode="c_replytopost"/>
					<br />
					<br />
					<div class="backArrow"><xsl:apply-templates select="FORUMTHREADPOSTS" mode="t_allthreads"/></div>
				
				</div>
			</div><!--// col1 -->
		
			<div class="col2">
				<div class="margins">
					<div class="contentBlock">
						<!-- Arrow list component -->
						<ul class="arrowList">
						<xsl:variable name="userid" select="/H2G2/FORUMSOURCE/USERPAGE/USER/USERID" />
						
						<xsl:choose>
								<xsl:when test="/H2G2/VIEWING-USER/USER/USERID=/H2G2/FORUMSOURCE/USERPAGE/USER/USERID">
									<li class="backArrow"><a href="{$root}U{$userid}">Back to your personal space</a></li>
									<li class="arrow"><a href="UAMA{$userid}?s_display=submissionlog">Submission Log</a></li>
									<li class="arrow"><a href="UAMA{$userid}?ContentType=3">All your video</a></li>
									<li class="arrow"><a href="UAMA{$userid}?ContentType=1">All your images</a></li>
									<li class="arrow"><a href="UAMA{$userid}?ContentType=2">All your audio</a></li>
									<!-- <li class="arrow"><a href="UAMA{$userid}?s_display=programmechallenges">All your challenges</a></li> -->
									<li class="arrow"><a href="Watch{$userid}">Contacts</a></li>
								</xsl:when>
								<xsl:otherwise>
									<li class="backArrow"><a href="{$root}U{$userid}">Back to their personal space</a></li>
									<li class="arrow"><a href="UAMA{$userid}?ContentType=3">All their video</a></li>
									<li class="arrow"><a href="UAMA{$userid}?ContentType=1">All their images</a></li>
									<li class="arrow"><a href="UAMA{$userid}?ContentType=2">All their audio</a></li>
									<!-- <li class="arrow"><a href="UAMA{$userid}?s_display=programmechallenges">All their challenges</a></li> -->
									<li class="arrow"><a href="Watch{$userid}">Contacts</a></li>
								</xsl:otherwise>
							</xsl:choose>
						<li class="arrow"><a href="{$root}yourspace">Help</a></li>
					</ul>	
					<!--// Arrow list component -->
					</div>

					<div class="contentBlock">
						<p><img src="{$imagesource}icon_complain_white.gif" alt="" width="16" height="16" /> Click this button on a message that you think breaks the house rules</p>
					</div>
					<a href="{$root}submityourstuff" class="button twoline"><span><span><span>Get your stuff on ComedySoup</span></span></span></a>
				</div>
			</div><!--// col2 -->
			<div class="clr"></div>
		</div>
	</div>
		
	</div>
	
	</xsl:template>
	<xsl:variable name="m_returntothreadspage">Go back to list of messages</xsl:variable>
	
	<!-- 
	<xsl:template match="FORUMTHREADPOSTS" mode="r_postblocks">
	Use: Container for the complete list of post blocks
	-->
	<xsl:template match="FORUMTHREADPOSTS" mode="r_postblocks">
		<xsl:apply-templates select="." mode="c_postblock"/>
	</xsl:template>
	<!-- 
	<xsl:template match="FORUMTHREADPOSTS" mode="off_postblock">
	Use: Display of non-current post block  - eg 'show posts 21-40'
		  The range parameter must be present to show the numeric value of the posts
		  It is common to also include a test - for example add a br tag after every 5th post block - 
		  this test must be replicated in m_postblockoff
	-->
	<xsl:template match="FORUMTHREADPOSTS" mode="off_postblock">
		<xsl:param name="range"/>
		<xsl:param name="currentpost" select="substring-before($range, ' ')"/>
		<xsl:if test="$currentpost mod 100 = 1">
			<!-- Test goes here!!!! -->
		</xsl:if>
		<xsl:value-of select="concat($alt_show, ' ', $range)"/>
		<br/>
	</xsl:template>
	<!-- 
	<xsl:template match="FORUMTHREADPOSTS" mode="on_postblock">
	Use: Display of current post block  - eg 'now showing posts 21-40'
		  The range parameter must be present to show the numeric value of the post you are on
		  Use the same test as in m_postblockoff
	-->
	<xsl:template match="FORUMTHREADPOSTS" mode="on_postblock">
		<xsl:param name="range"/>
		<xsl:param name="currentpost" select="substring-before($range, ' ')"/>
		<xsl:if test="$currentpost mod 100 = 1">
			<!-- Test goes here!!!! -->
		</xsl:if>
		<xsl:value-of select="concat($alt_nowshowing, ' ', $range)"/>
		<br/>
	</xsl:template>
	<!--
	<xsl:template match="FORUMTHREADPOSTS" mode="r_subcribemultiposts">
	Use: Presentation of subscribe / unsubscribe button 
	 -->
	<xsl:template match="FORUMTHREADPOSTS" mode="r_subcribemultiposts">
		<xsl:apply-imports/>
	</xsl:template>
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
		<ul class="messagesList">
			<xsl:apply-templates select="POST" mode="c_multiposts"/>
		</ul>
	</xsl:template>
	<!-- 
	<xsl:template match="POST" mode="r_multiposts">
	Use: Presentation of a single post
	-->
	<xsl:template match="POST" mode="r_multiposts">
	<li class="firstMessage">
		<xsl:choose>
			<xsl:when test="@INDEX=0">
				<xsl:attribute name="class">firstMessage</xsl:attribute>
			</xsl:when>
			<xsl:when test="@INDEX mod 2 = 0">
				<xsl:attribute name="class">even</xsl:attribute>
			</xsl:when>
			<xsl:otherwise>
				<xsl:attribute name="class">odd</xsl:attribute>
			</xsl:otherwise>
		</xsl:choose>
		
		<div class="headerRow"><xsl:apply-templates select="@POSTID" mode="t_createanchor"/>
			<h3 class="standardHeader"><xsl:apply-templates select="." mode="t_postsubjectmp"/></h3>
			<div class="complain"><xsl:apply-templates select="@HIDDEN" mode="c_complainmp"/></div>
			<div class="clr"></div>
		</div>
		<div class="detailsRow">
			<div class="author">Left by: <xsl:apply-templates select="USER/USERNAME" mode="c_multiposts"/>
			<xsl:if test="@INDEX=0">
				<span class="replies"><xsl:value-of select="number(../@TOTALPOSTCOUNT)-1" /> replies</span>
			</xsl:if>
			</div>
			<div class="date"><xsl:apply-templates select="DATEPOSTED/DATE" mode="t_postdatemp"/></div>
			<div class="clr"></div>
		</div>
		<div class="hozDots"></div>							
		<p><xsl:apply-templates select="." mode="t_postbodymp"/></p>
			

		<xsl:if test="$test_IsEditor">
			<div class="editbox">
				<xsl:apply-templates select="@POSTID" mode="c_editmp"/><br/>
				<xsl:apply-templates select="@POSTID" mode="c_linktomoderate"/>
			</div>
		</xsl:if>
	</li>
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
	 <!--
	<xsl:template match="USERNAME" mode="r_multiposts">
		<xsl:value-of select="$m_by"/>
		<xsl:apply-imports/>
	</xsl:template>
	-->
	<xsl:template match="USERNAME" mode="r_multiposts">
		<a target="_top" href="{$root}U{../USERID}" xsl:use-attribute-sets="mUSERNAME_multiposts">
			<xsl:apply-templates select="../FIRSTNAMES"/>&nbsp;<xsl:apply-templates select="../LASTNAME"/>
		</a>
	</xsl:template>	
	<xsl:template match="USERNAME" mode="t_multiposts_nolink">
		<xsl:apply-templates select="../FIRSTNAMES"/>&nbsp;<xsl:apply-templates select="../LASTNAME"/>
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
		
		<xsl:param name="embodiment" select="$alt_complain"/>
		<a href="comments/UserComplaintPage?PostID={../@POSTID}&amp;s_start=1" target="ComplaintPopup" onClick="popupwindow('comments/UserComplaintPage?PostID={../@POSTID}&amp;s_start=1', 'ComplaintPopup', 'status=1,resizable=1,scrollbars=1,width=640,height=480')" xsl:use-attribute-sets="maHIDDEN_r_complainmp">
			<span><xsl:copy-of select="$embodiment"/></span>
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
		<a target="_top" class="button">
			<xsl:attribute name="href"><xsl:apply-templates select=".." mode="sso_post_signin"/></xsl:attribute>
			<xsl:call-template name="ApplyAttributes">
				<xsl:with-param name="attributes" select="$attributes"/>
			</xsl:call-template>
			<span><span><span>
			Reply to this message
			</span></span></span>
		</a>
	</xsl:template>

	<!-- overridden from base skin -->
	<xsl:template match="POST|FIRSTPOST|LASTPOST" mode="sso_post_signin">
		<xsl:choose>
			<xsl:when test="/H2G2/VIEWING-USER/USER">
				<xsl:choose>
					<xsl:when test="/H2G2[@TYPE='MULTIPOSTS' or @TYPE='USERPAGE' or @TYPE='MESSAGEFRAME' or @TYPE='JOURNAL']">
						<xsl:value-of select="concat($root, 'AddThread?inreplyto=', @POSTID)"/>
					</xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="concat($sso_rootlogin, 'AddThread?inreplyto=', @POSTID)"/>
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
		Last Thread: <xsl:apply-imports/>
		<br/>
	</xsl:template>
	<!-- 
	<xsl:template match="THREAD" mode="r_next">
	use: presentation of the next link
	-->
	<xsl:template match="THREAD" mode="r_next">
		Next Thread: <xsl:apply-imports/>
		<br/>
	</xsl:template>
	<!-- 
	<xsl:template match="THREAD" mode="PreviousThread">
	use: inserts link to the previous thread
	-->
	<xsl:template match="THREAD" mode="PreviousThread">
		Last Thread: <xsl:apply-imports/>
		<br/>
	</xsl:template>
	<!-- 
	<xsl:template match="THREAD" mode="NextThread">
	use: inserts link to the next thread
	-->
	<xsl:template match="THREAD" mode="NextThread">
		Next Thread: <xsl:apply-imports/>
		<br/>
	</xsl:template>
	<!-- 
	<xsl:template match="@SKIPTO" mode="navbuttons">
	use: html containing the beginning / next / prev / latest buttons
	-->
	<xsl:template match="@SKIPTO" mode="r_navbuttons">
		<xsl:apply-templates select="." mode="c_gotobeginning"/>
		<xsl:text> </xsl:text>
		<br/>
		<xsl:apply-templates select="." mode="c_gotoprevious"/>
		<xsl:text> </xsl:text>
		<br/>
		<xsl:apply-templates select="." mode="c_gotonext"/>
		<xsl:text> </xsl:text>
		<br/>
		<xsl:apply-templates select="." mode="c_gotolatest"/>
	</xsl:template>
	<!-- 
	<xsl:template match="@SKIPTO" mode="r_gotobeginning">
	use: Skip to the beginning of the conversation embodiment
	-->
	<xsl:template match="@SKIPTO" mode="link_gotobeginning">
		<xsl:apply-imports/>
	</xsl:template>
	<xsl:variable name="alt_showoldestconv">first</xsl:variable>
	
	<!-- 
	<xsl:template match="@SKIPTO" mode="r_gotoprevious">
	use: Skip to the previous page of the conversation embodiment
	-->
	<xsl:template match="@SKIPTO" mode="link_gotoprevious">
		<a href="{$root}F{../@FORUMID}?thread={../@THREADID}&amp;skip={(.) - (../@COUNT)}&amp;show={../@COUNT}" xsl:use-attribute-sets="maSKIPTO_link_gotoprevious">
			previous
			<!-- <xsl:value-of select="concat($alt_showpostings, (.) - (../@COUNT) + 1, $alt_to, .)"/> -->
		</a>
	</xsl:template>
	<!-- 
	<xsl:template match="@SKIPTO" mode="r_gotonext">
	use: Skip to the next page of the conversation embodiment
	-->
	<xsl:template match="@SKIPTO" mode="link_gotonext">
		<a href="{$root}F{../@FORUMID}?thread={../@THREADID}&amp;skip={(.) + (../@COUNT)}&amp;show={../@COUNT}" xsl:use-attribute-sets="maSKIPTO_link_gotonext">
			next
			<!-- <xsl:value-of select="concat($alt_showpostings, ((.) + (../@COUNT) + 1), $alt_to, ((.) + (../@COUNT) + (../@COUNT)))"/> -->
		</a>
	</xsl:template>
	<!-- 
	<xsl:template match="@SKIPTO" mode="r_gotolatest">
	use: Skip to the end of the conversation embodiment
	-->
	<xsl:template match="@SKIPTO" mode="link_gotolatest">
		<xsl:apply-imports/>
	</xsl:template>
	<xsl:variable name="alt_shownewest">latest</xsl:variable>
	
	<!-- 
	<xsl:template match="@SKIPTO" mode="r_gotobeginning">
	use: Skip to the beginning of the conversation embodiment
	-->
	<xsl:template match="@SKIPTO" mode="text_gotobeginning">
		first
	</xsl:template>
	<!-- 
	<xsl:template match="@SKIPTO" mode="r_gotoprevious">
	use: Skip to the previous page of the conversation embodiment
	-->
	<xsl:template match="@SKIPTO" mode="text_gotoprevious">
		previous
	</xsl:template>
	<!-- 
	<xsl:template match="@SKIPTO" mode="r_gotonext">
	use: Skip to the next page of the conversation embodiment
	-->
	<xsl:template match="@SKIPTO" mode="text_gotonext">
		next
	</xsl:template>
	<!-- 
	<xsl:template match="@SKIPTO" mode="r_gotolatest">
	use: Skip to the end of the conversation embodiment
	-->
	<xsl:template match="@SKIPTO" mode="text_gotolatest">
		latest
	</xsl:template>
	
	
	
	<!-- TODO: make this into a recursive templates that goes up to any number -->
	<xsl:template name="POSTS_PAGINATION_BLOCK">		
		<div class="paginationBlock">
		
		<!-- previous -->
		<xsl:choose>
			<xsl:when test="/H2G2/FORUMTHREADPOSTS/@SKIPTO != 0">
				<span class="prev_active">
				<a href="{$root}F{/H2G2/FORUMTHREADPOSTS/@FORUMID}?thread={/H2G2/FORUMTHREADPOSTS/@THREADID}&amp;skip={/H2G2/FORUMTHREADPOSTS/@SKIPTO - 20}&amp;show=20">
					<b>previous</b>
				</a>
				|</span>
			</xsl:when>
			<xsl:otherwise>
				<span class="prev_dormant">
					<b>previous</b>
				|</span>
			</xsl:otherwise>
		</xsl:choose>
		
		
		<xsl:choose>
			<xsl:when test="/H2G2/FORUMTHREADPOSTS/@SKIPTO != 0">
				<a href="{$root}F{/H2G2/FORUMTHREADPOSTS/@FORUMID}?thread={/H2G2/FORUMTHREADPOSTS/@THREADID}&amp;skip=0&amp;show=20">
					1
				</a>
			</xsl:when>
			<xsl:otherwise>
				1
			</xsl:otherwise>
		</xsl:choose>
		
		<xsl:choose>
			<xsl:when test="/H2G2/FORUMTHREADPOSTS/@SKIPTO != 20 and /H2G2/FORUMTHREADPOSTS/@TOTALPOSTCOUNT > 20">
				<xsl:text> </xsl:text><a href="{$root}F{/H2G2/FORUMTHREADPOSTS/@FORUMID}?thread={/H2G2/FORUMTHREADPOSTS/@THREADID}&amp;skip=20&amp;show=20">
				2
				</a>
			</xsl:when>
			<xsl:when test="/H2G2/FORUMTHREADPOSTS/@TOTALPOSTCOUNT > 20">
				 2
			</xsl:when>
		</xsl:choose>
		
		<xsl:choose>
			<xsl:when test="/H2G2/FORUMTHREADPOSTS/@SKIPTO != 40 and /H2G2/FORUMTHREADPOSTS/@TOTALPOSTCOUNT > 40">
				<xsl:text> </xsl:text><a href="{$root}F{/H2G2/FORUMTHREADPOSTS/@FORUMID}?thread={/H2G2/FORUMTHREADPOSTS/@THREADID}&amp;skip=40&amp;show=20">
				3
				</a>
			</xsl:when>
			<xsl:when test="/H2G2/FORUMTHREADPOSTS/@TOTALPOSTCOUNT > 40">
				 3
			</xsl:when>
		</xsl:choose>
		
		<xsl:choose>
			<xsl:when test="/H2G2/FORUMTHREADPOSTS/@SKIPTO != 60 and /H2G2/FORUMTHREADPOSTS/@TOTALPOSTCOUNT > 60">
				<xsl:text> </xsl:text><a href="{$root}F{/H2G2/FORUMTHREADPOSTS/@FORUMID}?thread={/H2G2/FORUMTHREADPOSTS/@THREADID}&amp;skip=60&amp;show=20">
				4
				</a>
			</xsl:when>
			<xsl:when test="/H2G2/FORUMTHREADPOSTS/@TOTALPOSTCOUNT > 60">
				 4
			</xsl:when>
		</xsl:choose>
		
		<xsl:choose>
			<xsl:when test="/H2G2/FORUMTHREADPOSTS/@SKIPTO != 80 and /H2G2/FORUMTHREADPOSTS/@TOTALPOSTCOUNT > 80">
				<xsl:text> </xsl:text><a href="{$root}F{/H2G2/FORUMTHREADPOSTS/@FORUMID}?thread={/H2G2/FORUMTHREADPOSTS/@THREADID}&amp;skip=80&amp;show=20">
				5
				</a>
			</xsl:when>
			<xsl:when test="/H2G2/FORUMTHREADPOSTS/@TOTALPOSTCOUNT > 80">
				 5
			</xsl:when>
		</xsl:choose>
		
		<xsl:choose>
			<xsl:when test="/H2G2/FORUMTHREADPOSTS/@SKIPTO != 100 and /H2G2/FORUMTHREADPOSTS/@TOTALPOSTCOUNT > 100">
				<xsl:text> </xsl:text><a href="{$root}F{/H2G2/FORUMTHREADPOSTS/@FORUMID}?thread={/H2G2/FORUMTHREADPOSTS/@THREADID}&amp;skip=100&amp;show=20">
				6
				</a>
			</xsl:when>
			<xsl:when test="/H2G2/FORUMTHREADPOSTS/@TOTALPOSTCOUNT > 100">
				 6
			</xsl:when>
		</xsl:choose>
		
		<xsl:choose>
			<xsl:when test="/H2G2/FORUMTHREADPOSTS/@SKIPTO != 120 and /H2G2/FORUMTHREADPOSTS/@TOTALPOSTCOUNT > 120">
				<xsl:text> </xsl:text><a href="{$root}F{/H2G2/FORUMTHREADPOSTS/@FORUMID}?thread={/H2G2/FORUMTHREADPOSTS/@THREADID}&amp;skip=120&amp;show=20">
				7
				</a>
			</xsl:when>
			<xsl:when test="/H2G2/FORUMTHREADPOSTS/@TOTALPOSTCOUNT > 120">
				 7
			</xsl:when>
		</xsl:choose>
		
		<xsl:choose>
			<xsl:when test="/H2G2/FORUMTHREADPOSTS/@SKIPTO != 140 and /H2G2/FORUMTHREADPOSTS/@TOTALPOSTCOUNT > 140">
				<xsl:text> </xsl:text><a href="{$root}F{/H2G2/FORUMTHREADPOSTS/@FORUMID}?thread={/H2G2/FORUMTHREADPOSTS/@THREADID}&amp;skip=140&amp;show=20">
				8
				</a>
			</xsl:when>
			<xsl:when test="/H2G2/FORUMTHREADPOSTS/@TOTALPOSTCOUNT > 140">
				 8
			</xsl:when>
		</xsl:choose>
		
		<xsl:choose>
			<xsl:when test="/H2G2/FORUMTHREADPOSTS/@SKIPTO != 160 and /H2G2/FORUMTHREADPOSTS/@TOTALPOSTCOUNT > 160">
				<xsl:text> </xsl:text><a href="{$root}F{/H2G2/FORUMTHREADPOSTS/@FORUMID}?thread={/H2G2/FORUMTHREADPOSTS/@THREADID}&amp;skip=160&amp;show=20">
				9
				</a>
			</xsl:when>
			<xsl:when test="/H2G2/FORUMTHREADPOSTS/@TOTALPOSTCOUNT > 160">
				 9
			</xsl:when>
		</xsl:choose>
		
		<xsl:choose>
			<xsl:when test="/H2G2/FORUMTHREADPOSTS/@SKIPTO != 180 and /H2G2/FORUMTHREADPOSTS/@TOTALPOSTCOUNT > 180">
				<xsl:text> </xsl:text><a href="{$root}F{/H2G2/FORUMTHREADPOSTS/@FORUMID}?thread={/H2G2/FORUMTHREADPOSTS/@THREADID}&amp;skip=180&amp;show=20">
				10
				</a>
			</xsl:when>
			<xsl:when test="/H2G2/FORUMTHREADPOSTS/@TOTALPOSTCOUNT > 180">
				 10
			</xsl:when>
		</xsl:choose>
		
		
		<!-- next -->
		<xsl:choose>
			<xsl:when test="/H2G2/FORUMTHREADPOSTS/@MORE = 1">
				<span class="next_active">|
				<a href="{$root}F{/H2G2/FORUMTHREADPOSTS/@FORUMID}?thread={/H2G2/FORUMTHREADPOSTS/@THREADID}&amp;skip={/H2G2/FORUMTHREADPOSTS/@SKIPTO + 20}&amp;show=20">
					<b>next</b>
				</a>
				</span>
			</xsl:when>
			<xsl:otherwise>
				<span class="next_dormant">|
					<b>next</b>
				</span>
			</xsl:otherwise>
		</xsl:choose>
		
	</div>
	</xsl:template>
</xsl:stylesheet>
