<?xml version="1.0" encoding="iso-8859-1"?>
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
	<xsl:template name="MULTIPOSTS_HEADER">
		<xsl:apply-templates mode="header" select=".">
			<xsl:with-param name="title">
				<xsl:value-of select="$m_pagetitlestart"/>
				<xsl:text>Comments</xsl:text>
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>
	
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
    <div id="topPage">
      <h2>All comments</h2>

		  <xsl:if test="/H2G2/FORUMSOURCE/@TYPE='article'">
			  <p>
				  <xsl:choose>
					  <xsl:when test="/H2G2/FORUMTHREADPOSTS/@TOTALPOSTCOUNT=1">
						  This comment is related to an article called:
					  </xsl:when>
					  <xsl:otherwise>
						  These <xsl:value-of select="/H2G2/FORUMTHREADPOSTS/@TOTALPOSTCOUNT"/> comments are related to an article called:
					  </xsl:otherwise>
				  </xsl:choose>
			  </p>
			  <h4><a href="{$root}A{/H2G2/FORUMSOURCE/ARTICLE/ARTICLEINFO/H2G2ID}"><xsl:value-of select="/H2G2/FORUMSOURCE/ARTICLE/SUBJECT" /></a></h4>
		  </xsl:if>
    </div>
    
    <div class="tear">
      <hr/>
    </div>

    <div class="padWrapper">
      <div id="comments">
      <xsl:apply-templates select="FORUMTHREADPOSTS/@SKIPTO" mode="c_navbuttons"/>
      <div class="barPale">
        <h3 class="left">Comments</h3>
      </div>

      <!--[FIXME: remove? link to this page doesn't include number of comments to display on the page]-->
      
      
      <div class="resultsList">
        <xsl:apply-templates select="FORUMTHREADPOSTS" mode="c_multiposts"/>
      </div>

      <!--[FIXME: remove? link to this page doesn't include number of comments to display on the page]-->

        <xsl:call-template name="navpages" />

      </div>
    </div>
    <p id="rssBlock">
      <a class="rssLink" id="rssLink">
        <xsl:attribute name="href">
          <xsl:call-template name="url"></xsl:call-template>
        </xsl:attribute>
        <xsl:text>Latest comments </xsl:text>
      </a>
      <xsl:text> | </xsl:text>
      <a>
        <xsl:attribute name="href">
          <xsl:value-of select="msxsl:node-set($clients)/list/item[client=$client]/rsshelp"/>
        </xsl:attribute>
        What is RSS?
      </a>
	<xsl:text> | </xsl:text>
	<a href="{$root}help#feeds">
		<xsl:text>Memoryshare RSS feeds</xsl:text>
	</a>
    </p>
    
	</xsl:template>

  <xsl:template name="url">
    <xsl:value-of select="$feedroot"/>
    <xsl:text>xml/F</xsl:text>
    <xsl:value-of select="/H2G2/ARTICLEFORUM/FORUMTHREADPOSTS/@FORUMID"/>
    <xsl:text>&amp;thread=</xsl:text>
    <xsl:value-of select="/H2G2/ARTICLEFORUM/FORUMTHREADPOSTS/POST/@THREAD"/>
    <xsl:text>&amp;s_xml=</xsl:text>
    <xsl:value-of select="$rss_param"/>
    <xsl:text>&amp;s_client='</xsl:text>
    <xsl:value-of select="$client"/>
    <xsl:text>&amp;show='</xsl:text>
    <xsl:value-of select="$rss_show"/>
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
		<ul class="resultList">
			<xsl:choose>
				<xsl:when test="$test_IsAdminUser">
					<!-- using mode r_multiposts directly because otherwise position() always returns 1 -->
					<xsl:apply-templates select="POST" mode="r_multiposts">
						<xsl:sort select="@INDEX" order="descending"/>
					</xsl:apply-templates>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="POST[not(@HIDDEN = 1)]" mode="r_multiposts">
						<xsl:sort select="@INDEX" order="descending"/>
					</xsl:apply-templates>
				</xsl:otherwise>
			</xsl:choose>
		</ul>
	</xsl:template>
	<!-- 
	<xsl:template match="POST" mode="r_multiposts">
	Use: Presentation of a single post
	-->
	<xsl:template match="POST" mode="r_multiposts">
		<li>
			<xsl:attribute name="class">
				<xsl:choose>
					<xsl:when test="position() mod 2 = 0">
						<xsl:text>even</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>odd</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			
			<xsl:apply-templates select="@POSTID" mode="t_createanchor"/>

			<xsl:choose>
				<xsl:when test="@HIDDEN = 1 and $test_IsAdminUser">
				<div class="commenth">
					COMMENT REMOVED BY EDITOR/MODERATOR
				</div>
				</xsl:when>
				<xsl:when test="@HIDDEN = 2 and $test_IsAdminUser">
				<div class="commenth">
					COMMENT AWAITING MODERATION
				</div>
				</xsl:when>
				<xsl:when test="@HIDDEN = 3 and $test_IsAdminUser">
				<div class="commenth">
					COMMENT AWAITING PRE-MODERATION
				</div>
				</xsl:when>
				<xsl:when test="@HIDDEN = 7 and $test_IsAdminUser">
				<div class="commenth">
					AUTHOR OF ARTICLE DELETED COMMENT
				</div>
				</xsl:when>
				<xsl:when test="@HIDDEN = 0">
				<h4>
					<xsl:apply-templates select="." mode="check_user_namebox"/>
					<xsl:apply-templates select="USER/USERNAME" mode="c_multiposts"/>
				</h4>
				</xsl:when>
			</xsl:choose>

			<xsl:apply-templates select="." mode="check_user_textbox"/>
			<p class="posted">posted <xsl:apply-templates select="DATEPOSTED/DATE" mode="t_postdatemp"/></p>

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
					<p>
						<xsl:variable name="body_rendered">
							<xsl:apply-templates select="TEXT/node()"/>
						</xsl:variable>
						<xsl:apply-templates select="msxsl:node-set($body_rendered)" mode="convert_urls_to_links"/>
						<!--[FIXME: not needed?]
						<xsl:apply-templates select="TEXT/node()"/>
						-->
					</p>
					<p class="commentl">
						<!-- add a comment -->
						<!--[FIXME: take out?]
						<xsl:choose>
							<xsl:when test="/H2G2/@TYPE='ARTICLE'">
								<xsl:if test="/H2G2/ARTICLEFORUM/FORUMTHREADPOSTS/@DEFAULTCANWRITE=1">
									<a href="#commentbox">add comment</a> | 
								</xsl:if>
							</xsl:when>
							<xsl:otherwise>
								<xsl:apply-templates select="@POSTID" mode="c_replytopost"/> | 
							</xsl:otherwise>
						</xsl:choose>
						-->
						<a href="houserules">House rules</a>
						
						<!-- complain (only if comment author is not an editor, or is not the current user) -->
						<xsl:if test="not(USER/GROUPS/EDITOR) and not(/H2G2/VIEWING-USER/USER/USERID=USER/USERID)">
							<xsl:text> | </xsl:text>
							<xsl:apply-templates select="@HIDDEN" mode="c_complainmp"/>
						</xsl:if>
						
						<!-- owner delete -->
						<xsl:variable name="articleOwner">
							<xsl:choose>
								<xsl:when test="/H2G2/FORUMSOURCE/ARTICLE/ARTICLEINFO/PAGEAUTHOR/EDITOR/USER">
									<xsl:value-of select="/H2G2/FORUMSOURCE/ARTICLE/ARTICLEINFO/PAGEAUTHOR/EDITOR/USER/USERID"/>
								</xsl:when>
								<xsl:when test="/H2G2/ARTICLE/ARTICLEINFO/PAGEAUTHOR/EDITOR/USER">
									<xsl:value-of select="/H2G2/ARTICLE/ARTICLEINFO/PAGEAUTHOR/EDITOR/USER/USERID"/>
								</xsl:when>
							</xsl:choose>
						</xsl:variable>
						<xsl:if test="$articleOwner=/H2G2/VIEWING-USER/USER/USERID and not($articleOwner=USER/USERID) and not(USER/GROUPS/EDITOR)">
							<xsl:text> | </xsl:text>
							<a href="{$root}EditRecentPost?PostID={@POSTID}&amp;H2G2ID={//ARTICLE/ARTICLEINFO/H2G2ID}&amp;s_h2g2id={//ARTICLE/ARTICLEINFO/H2G2ID}&amp;s_return={$pagetype}">Delete this comment</a>
						</xsl:if>
					</p>
				</xsl:otherwise>
			</xsl:choose>		

			<!-- editors links -->	
			<xsl:if test="$test_IsAdminUser">
				<div class="editbox">
					<xsl:apply-templates select="@POSTID" mode="c_editmp"/> | <xsl:apply-templates select="@POSTID" mode="c_linktomoderate"/>
				</div>
			</xsl:if>
		</li>
	</xsl:template>
	
	
	<xsl:template match="POST" mode="check_user_namebox">
	<xsl:if test="USER/EDITOR=1"><xsl:attribute name="class">commenth2</xsl:attribute></xsl:if>
	</xsl:template>
	
	<xsl:template match="POST" mode="check_user_textbox">
	<xsl:if test="USER/EDITOR=1"><xsl:attribute name="class">commentbox2</xsl:attribute></xsl:if>
	</xsl:template>
	<xsl:variable name="m_replytothispost">Add comment</xsl:variable>
	<xsl:variable name="alt_complain">Complain about this <xsl:value-of select="$m_posting"/></xsl:variable>
	
	
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
    <xsl:text>Comment from </xsl:text>
		<a target="_top" href="{$root}U{../USERID}" xsl:use-attribute-sets="mUSERNAME_r_multiposts">
			<xsl:apply-templates select="."/>			
		</a>
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
		<xsl:if test="/H2G2/SITE-CLOSED=0 or $test_IsAdminUser">
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
    
    <!--<xsl:text>page </xsl:text>
    <xsl:value-of select="$pagenumber" />
    <xsl:text>of </xsl:text>
    <xsl:value-of select="$pagetotal" />

    <xsl:text> </xsl:text>-->

    <div class="barStrong">
      <p class="left">
        <xsl:apply-templates select="." mode="c_gotobeginning"/> | <xsl:apply-templates select="." mode="c_gotoprevious"/>
      </p>
      <p class="right">
        <xsl:apply-templates select="." mode="c_gotonext"/> | <xsl:apply-templates select="." mode="c_gotolatest"/>
      </p>
    </div>

    <xsl:call-template name="navpages" />
    
  </xsl:template>

  <xsl:template name="navpages">
    <div class="barMid">
      <p class="rightPagination">
        <xsl:text>Page: </xsl:text>
        <xsl:apply-templates select="/H2G2/FORUMTHREADPOSTS" mode="c_postblocks"/>
      </p>
    </div>
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
			Previous
		</a>
	</xsl:template>
	<!-- 
	<xsl:template match="@SKIPTO" mode="r_gotonext">
	use: Skip to the next page of the conversation embodiment
	-->
	<xsl:template match="@SKIPTO" mode="link_gotonext">
		<a href="{$root}F{../@FORUMID}?thread={../@THREADID}&amp;skip={(.) + (../@COUNT)}&amp;show={../@COUNT}" xsl:use-attribute-sets="maSKIPTO_link_gotonext">
			Next
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
