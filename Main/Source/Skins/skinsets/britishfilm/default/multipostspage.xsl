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
	
	<xsl:call-template name="ARTICLE_COMMENTS" /> <!-- shares template with threadspage.xsl -->
	
	</xsl:template>
	
	
	
<xsl:template name="ARTICLE_COMMENTS">
<h1 class="yourfilms"><img src="{$imagesource}title_comment.jpg" alt="Comment" /></h1>
<div id="mainintro">
		
	<div class="text">
							
							<h2><a class="filename" href="{$root}A{/H2G2/FORUMSOURCE/ARTICLE/ARTICLEINFO/H2G2ID}"><xsl:value-of select="/H2G2/FORUMSOURCE/ARTICLE/SUBJECT" /></a></h2>
		
							
							<div class="filmlinks">
							<xsl:for-each select="/H2G2/FORUMSOURCE/ARTICLE/GUIDE/GENRE01 | /H2G2/FORUMSOURCE/ARTICLE/GUIDE/GENRE02 | /H2G2/FORUMSOURCE/ARTICLE/GUIDE/GENRE03">
								<xsl:if test=".!=''">
									<a href="{$root}ArticleSearch?contenttype=-1&amp;phrase={.}&amp;articlestatus=1&amp;articlesortby=DateUploaded&amp;show=20"><xsl:call-template name="CONVERTGENRENAME">
										<xsl:with-param name="searchterm">
											<xsl:value-of select="." />
										</xsl:with-param>
									</xsl:call-template></a> |
								</xsl:if>
							</xsl:for-each>	
							<a href="{$root}ArticleSearch?contenttype=-1&amp;phrase={/H2G2/FORUMSOURCE/ARTICLE/GUIDE/THEME}&amp;articlestatus=1&amp;articlesortby=DateUploaded&amp;show=20"><xsl:call-template name="CONVERTGENRENAME">
										<xsl:with-param name="searchterm">
											<xsl:value-of select="/H2G2/FORUMSOURCE/ARTICLE/GUIDE/THEME" />
										</xsl:with-param>
									</xsl:call-template></a>		
							</div>
							<div class="filmblurb"><xsl:value-of select="/H2G2/FORUMSOURCE/ARTICLE/GUIDE/BODY" /></div>
							<div class="filminfo">
							<xsl:value-of select="/H2G2/FORUMSOURCE/ARTICLE/GUIDE/DIRECTOR" /> | <xsl:value-of select="/H2G2/FORUMSOURCE/ARTICLE/GUIDE/LENGTH_MIN" /> minutes <xsl:value-of select="/H2G2/FORUMSOURCE/ARTICLE/GUIDE/LENGTH_SEC" /> seconds
							</div>
						</div>
</div>

	<xsl:apply-templates select="FORUMTHREADPOSTS/@SKIPTO" mode="c_navbuttons"/>
<!-- <hr/>	 -->			
<div id="articlewrapper">
		<div id="talking">
	<xsl:apply-templates select="FORUMTHREADPOSTS" mode="c_multiposts"/>
	</div>
	</div>					
	<xsl:apply-templates select="FORUMTHREADPOSTS/@SKIPTO" mode="c_navbuttons"/>

</xsl:template>
	
	
	
	<xsl:variable name="mpsplit" select="5"/>
	<!-- 
	<xsl:template match="FORUMTHREADPOSTS" mode="r_postblocks">
	Use: Container for the complete list of post blocks
	-->
	
	<xsl:template match="FORUMTHREADPOSTS" mode="r_postblocks">
		<!-- <xsl:apply-templates select="." mode="c_blockdisplayprev"/> -->
		<xsl:apply-templates select="." mode="c_blockdisplay"/>
		<!-- <xsl:apply-templates select="." mode="c_blockdisplaynext"/> -->
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
	<!-- 
	<xsl:template match="FORUMTHREADS" mode="on_blockdisplay">
	Use: Controls the display of the block (outside the link) which is currently appearing on the page
	-->
	<xsl:template match="FORUMTHREADPOSTS" mode="on_blockdisplay">
		<xsl:param name="url"/>
		<xsl:copy-of select="$url"/>
		<xsl:text> </xsl:text>
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
		<xsl:copy-of select="$url"/>
		<xsl:text> </xsl:text>
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
		<xsl:attribute name="class">next-back-on</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="mFORUMTHREADPOSTS_off_blockdisplay">
		<xsl:attribute name="class">next-back-off</xsl:attribute>
	</xsl:attribute-set>

	<!--
	<xsl:template match="FORUMTHREADPOSTS" mode="r_subcribemultiposts">
	Use: Presentation of subscribe / unsubscribe button 
	 -->
	<xsl:template match="FORUMTHREADPOSTS" mode="r_subcribemultiposts">
	<xsl:if test="$registered=1">
		subscribe
	</xsl:if>
	<xsl:apply-imports/>
	</xsl:template>
	
	<xsl:variable name="alt_showoldestconv">first post</xsl:variable>
	<xsl:variable name="alt_showingoldest">first post</xsl:variable>
	
	<xsl:variable name="alt_shownewest">latest post</xsl:variable>
	<xsl:variable name="alt_nonewerpost">latest post</xsl:variable>
	
	<xsl:variable name="alt_nonewconvs">next</xsl:variable>
	<xsl:variable name="alt_shownext">next</xsl:variable>
	
	<xsl:variable name="m_noolderconv">previous</xsl:variable>
	<xsl:variable name="alt_showprevious">previous</xsl:variable>
	
	
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
	<xsl:if test="not(@HIDDEN = 1) or $test_IsEditor">
	
		<xsl:apply-templates select="@POSTID" mode="t_createanchor"/>
		
		
			<xsl:choose>
				<xsl:when test="@HIDDEN = 1 and $test_IsEditor">
				<div class="commenth">
					COMMENT REMOVED BY EDITOR/MODERATOR
				</div>
				</xsl:when>
				<xsl:when test="@HIDDEN = 2 and $test_IsEditor">
				<div class="commenth">
					COMMENT AWAITING MODERATION
				</div>
				</xsl:when>
				<xsl:when test="@HIDDEN = 3 and $test_IsEditor">
				<div class="commenth">
					COMMENT AWAITING PRE-MODERATION
				</div>
				</xsl:when>
				<xsl:when test="@HIDDEN = 7 and $test_IsEditor">
				<div class="commenth">
					AUTHOR OF ARTICLE DELETED COMMENT
				</div>
				</xsl:when>
				<xsl:when test="@HIDDEN = 0">
				<!-- <div class="commenth">
					<xsl:apply-templates select="." mode="check_user_namebox"/>
					<xsl:apply-templates select="USER/USERNAME" mode="c_multiposts"/><xsl:apply-templates select="@HIDDEN" mode="c_complainmp"/>
				</div> -->
				</xsl:when>
			</xsl:choose>
		 
		
		
			<!-- <xsl:apply-templates select="." mode="check_user_textbox"/>
			<p class="posted">posted <xsl:apply-templates select="DATEPOSTED/DATE" mode="t_postdatemp"/></p> -->
			
			<xsl:choose>
				<xsl:when test="@HIDDEN = 1">
					<!-- comment removed by editor/moderator  -->
					<p><xsl:call-template name="m_postremoved"/></p>
				</xsl:when>
				<xsl:when test="@HIDDEN = 2">
					<p><xsl:call-template name="m_postawaitingmoderation"/></p>
				</xsl:when>
				<xsl:when test="@HIDDEN = 3">
					<!-- comment in moderation  -->
					<p><xsl:call-template name="m_postawaitingpremoderation"/></p>
				</xsl:when>
				<xsl:when test="@HIDDEN = 7">
					<!-- comment in moderation  -->
					<p>The author of this article has deleted this comment.</p>
				</xsl:when>
				<xsl:otherwise>

								
					<xsl:for-each select=".">
					<!-- Comment -->
					<div class="quote">
					<!-- <div class="quote last"> -->
						<h3>
						<span>Comment by <strong><xsl:value-of select="USER/USERNAME" /></strong></span>
						<xsl:apply-templates select="@HIDDEN" mode="c_complainmp"/></h3>
						<p class="posted">posted <xsl:apply-templates select="DATEPOSTED/DATE" mode="t_postdatemp"/></p>
						<p class="commenttext"><xsl:value-of select="TEXT" /></p>
					</div>
					</xsl:for-each>


					<!-- <p><xsl:apply-templates select="TEXT/node()"/></p> -->
					
						
						
						<!-- complain -->
						<!-- <xsl:apply-templates select="@HIDDEN" mode="c_complainmp"/>  -->
						
						<!-- owner delete -->
						<!-- <xsl:if test="(/H2G2/FORUMSOURCE/ARTICLE/ARTICLEINFO/PAGEAUTHOR/EDITOR/USER/USERID=/H2G2/VIEWING-USER/USER/USERID or $ownerisviewer=1 ) and not(USER/EDITOR=1)">	<p class="commentl">					
						<a href="{$root}EditRecentPost?PostID={@POSTID}&amp;H2G2ID={//ARTICLE/ARTICLEINFO/H2G2ID}&amp;s_h2g2id={//ARTICLE/ARTICLEINFO/H2G2ID}&amp;s_return={$pagetype}">delete this comment</a>
						</p></xsl:if> -->
					
				</xsl:otherwise>
			</xsl:choose>		
					
			<!-- editors links -->	
			<xsl:if test="$test_IsEditor">
				<p class="commentl">
					<xsl:apply-templates select="@POSTID" mode="c_editmp"/> | <xsl:apply-templates select="@POSTID" mode="c_linktomoderate"/>
				</p>
			</xsl:if>
		
		<!-- <hr/> -->
	</xsl:if>
	</xsl:template>
	
	
	<xsl:template match="POST" mode="check_user_namebox">
	<xsl:if test="USER/EDITOR=1"><xsl:attribute name="class">commenth2</xsl:attribute></xsl:if>
	</xsl:template>
	
	<xsl:template match="POST" mode="check_user_textbox">
	<xsl:if test="USER/EDITOR=1"><xsl:attribute name="class">commentbox2</xsl:attribute></xsl:if>
	</xsl:template>
	<xsl:variable name="m_replytothispost">add comment</xsl:variable>
	<xsl:variable name="alt_complain"><img border="0" src="{$imagesource}reportcomment.gif" alt="!" /></xsl:variable>
	
	
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
		comment by <xsl:value-of select="../USERNAME"/>
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
		<xsl:apply-imports/>
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
		<xsl:if test="/H2G2/SITE-CLOSED=0 or $test_IsEditor">
			<xsl:apply-imports/>
		</xsl:if>
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
		<xsl:variable name="pagenumber">
			<xsl:value-of select="floor(/H2G2/FORUMTHREADPOSTS/@SKIPTO div 20) + 1" />
		</xsl:variable>
		
		<xsl:variable name="pagetotal">
	  	  <xsl:value-of select="ceiling(/H2G2/FORUMTHREADPOSTS/@TOTALPOSTCOUNT div 20)" />
		</xsl:variable>
				
				
		
		<div class="page">
			<p><B>page <xsl:value-of select="$pagenumber" /> of <xsl:value-of select="$pagetotal" /></B></p>
			<div class="links">
				<div class="pagecol1"><xsl:apply-templates select="." mode="c_gotobeginning"/> | <xsl:apply-templates select="." mode="c_gotoprevious"/> </div>
				<div class="pagecol2"><xsl:apply-templates select="/H2G2/FORUMTHREADPOSTS" mode="c_postblocks"/></div>   
				<div class="pagecol3"><xsl:apply-templates select="." mode="c_gotonext"/> | <xsl:apply-templates select="." mode="c_gotolatest"/></div>
				<a href="#"></a>
			</div>
			<div class="clear"></div>
		</div>
		<div class="verticalspacer10px"> </div>
		<div class="verticalspacer10px"> </div>
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
		<a href="{$root}F{../@FORUMID}?thread={../@THREADID}&amp;skip={(.) - (../@COUNT)}&amp;show={../@COUNT}" xsl:use-attribute-sets="maSKIPTO_link_gotoprevious">
			previous
		</a>
	</xsl:template>
	<!-- 
	<xsl:template match="@SKIPTO" mode="r_gotonext">
	use: Skip to the next page of the conversation embodiment
	-->
	<xsl:template match="@SKIPTO" mode="link_gotonext">
		<a href="{$root}F{../@FORUMID}?thread={../@THREADID}&amp;skip={(.) + (../@COUNT)}&amp;show={../@COUNT}" xsl:use-attribute-sets="maSKIPTO_link_gotonext">
			next
		</a>
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
</xsl:stylesheet>
