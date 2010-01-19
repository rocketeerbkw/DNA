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
	<xsl:with-param name="message">MULTIPOSTS_MAINBODY<xsl:value-of select="$current_article_type" /></xsl:with-param>
	<xsl:with-param name="pagename">multipostspage.xsl</xsl:with-param>
	</xsl:call-template>
	<!-- DEBUG -->

		<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
		<xsl:element name="td" use-attribute-sets="column.1">
	
		<div class="morepost-a">
		<xsl:element name="{$text.base}" use-attribute-sets="text.base">
		
		<xsl:choose>
		<xsl:when test="/H2G2/FORUMSOURCE/@TYPE='journal'">
		this is the weblog of
		<br />
	    <xsl:element name="{$text.heading}" use-attribute-sets="text.heading">
		<strong class="brown"><a href="U{FORUMSOURCE/JOURNAL/USER/USERID}"><xsl:value-of select="FORUMSOURCE/JOURNAL/USER/USERNAME" /></a></strong></xsl:element>
		</xsl:when>
		<xsl:when test="/H2G2/FORUMSOURCE/@TYPE='userpage'">
		this is a message for
		<br />
	    <xsl:element name="{$text.heading}" use-attribute-sets="text.heading">
		<strong class="brown"><a href="U{FORUMSOURCE/USERPAGE/USER/USERID}"><xsl:value-of select="FORUMSOURCE/USERPAGE/USER/USERNAME" /></a></strong></xsl:element>
		</xsl:when>
		<xsl:otherwise>
		this conversation is related to a page called
		<br />
	    <xsl:element name="{$text.heading}" use-attribute-sets="text.heading">
		<strong class="brown"><a href="A{FORUMSOURCE/ARTICLE/ARTICLEINFO/H2G2ID}"><xsl:value-of select="FORUMSOURCE/ARTICLE/SUBJECT" /></a></strong></xsl:element>
		
		</xsl:otherwise>
		</xsl:choose>


		</xsl:element>
		</div><table cellpadding="0" cellspacing="0" width="410" border="0" class="generic-n"><tr><!-- TODO abstract table attrs to a att-set -->
	<td class="generic-n-1"><xsl:element name="{$text.base}" use-attribute-sets="text.base"><xsl:copy-of select="$arrow.right" /><xsl:apply-templates select="FORUMTHREADPOSTS" mode="t_allthreads"/></xsl:element></td>
	
	</tr></table>
	
	
  	<!-- OTHER RELATED CONVERSATIONS -->
	<!-- ADD TO MY CONVERSATIONS -->
	<!-- PREV AND NEXT -->
	<xsl:apply-templates select="FORUMTHREADPOSTS/@SKIPTO" mode="c_navbuttons"/>
	<!-- POSTS -->
	<xsl:apply-templates select="FORUMTHREADPOSTS" mode="c_multiposts"/>
	<!-- PREV AND NEXT -->
	<xsl:apply-templates select="FORUMTHREADPOSTS/@SKIPTO" mode="c_navbuttons"/>
<table cellpadding="0" cellspacing="0" width="410" border="0" class="generic-n"><tr><!-- TODO abstract table attrs to a att-set -->
	<td class="generic-n-1"><xsl:element name="{$text.base}" use-attribute-sets="text.base"><xsl:copy-of select="$arrow.right" /><xsl:apply-templates select="FORUMTHREADPOSTS" mode="t_allthreads"/></xsl:element></td>
	<td class="generic-n-2" align="right"><xsl:element name="{$text.base}" use-attribute-sets="text.base"><xsl:apply-templates select="FORUMTHREADPOSTS" mode="c_subcribemultiposts"/></xsl:element></td>
	</tr></table>

						
	</xsl:element>
	<xsl:element name="td" use-attribute-sets="column.3" />
	<xsl:element name="td" use-attribute-sets="column.2">
	
	
	<xsl:call-template name="RANDOMPROMO" />
	<!-- <div class="bodytext"><xsl:apply-templates select="FORUMTHREADS" mode="c_otherthreads"/></div>
	<div class="bodytext"> </div>
	<div class="bodytext"><xsl:apply-templates select="FORUMTHREADPOSTS" mode="c_postblocks"/> </div>
	</div>		
	-->
	<!-- <xsl:copy-of select="$m_forumpostingsdisclaimer"/> -->
	</xsl:element>
	</tr>
	</table>

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
	<xsl:template match="FORUMTHREADPOSTS" mode="off_postblock">
	Use: Display of non-current post block  - eg 'show posts 21-40'
		  The range parameter must be present to show the numeric value of the posts
		  It is common to also include a test - for example add a br tag after every 5th post block - 
		  this test must be replicated in m_postblockoff
	-->
	<!--xsl:template match="FORUMTHREADPOSTS" mode="off_postblock">
		<xsl:param name="range"/>
		<xsl:param name="currentpost" select="substring-before($range, ' ')"/>
		<xsl:if test="$currentpost mod 100 = 1">
			
		</xsl:if>
		<xsl:value-of select="concat($alt_show, ' ', $range)"/>
		<br/>
	</xsl:template-->
	<!-- 
	<xsl:template match="FORUMTHREADPOSTS" mode="on_postblock">
	Use: Display of current post block  - eg 'now showing posts 21-40'
		  The range parameter must be present to show the numeric value of the post you are on
		  Use the same test as in m_postblockoff
	-->
	<!--xsl:template match="FORUMTHREADPOSTS" mode="on_postblock">
		<xsl:param name="range"/>
		<xsl:param name="currentpost" select="substring-before($range, ' ')"/>
		<xsl:if test="$currentpost mod 100 = 1">
			
		</xsl:if>
		<xsl:value-of select="concat($alt_nowshowing, ' ', $range)"/>
		<br/>
	</xsl:template-->
	<!--
	<xsl:template match="FORUMTHREADPOSTS" mode="r_subcribemultiposts">
	Use: Presentation of subscribe / unsubscribe button 
	 -->
	<xsl:template match="FORUMTHREADPOSTS" mode="r_subcribemultiposts">
	<xsl:if test="$registered=1">
		<xsl:copy-of select="$arrow.right" />
	</xsl:if>
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
		<xsl:apply-templates select="POST" mode="c_multiposts"/>
	</xsl:template>
	<!-- 
	<xsl:template match="POST" mode="r_multiposts">
	Use: Presentation of a single post
	-->
	<xsl:template match="POST" mode="r_multiposts">
	<xsl:apply-templates select="@POSTID" mode="t_createanchor"/>
	
		<!-- POST TITLE	 -->

		<div class="multi-title">
			<table cellpadding="0" cellspacing="0" border="0" width="390">
			<tr><td>
			<xsl:element name="{$text.base}" use-attribute-sets="text.base">
			<strong><xsl:apply-templates select="." mode="t_postsubjectmp"/></strong>
			</xsl:element>
			</td><td align="right">
			<xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall">
			<span class="orange"><span class="bold">post <xsl:apply-templates select="." mode="t_postnumber"/></span></span>
			</xsl:element>	
			</td></tr></table>
		</div>

		<div class="posted-by">
		<xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall">
		<xsl:if test="@HIDDEN='0'">
		<!-- POST INFO -->
		<xsl:copy-of select="$m_posted"/>
		<xsl:apply-templates select="USER/USERNAME" mode="c_multiposts"/>&nbsp; 
		<xsl:apply-templates select="USER" mode="c_onlineflagmp"/>&nbsp; 
		<xsl:apply-templates select="DATEPOSTED/DATE" mode="t_postdatemp"/>
		<xsl:apply-templates select="." mode="c_gadgetmp"/>
		</xsl:if>
		</xsl:element>
		</div>
		<!-- POST BODY -->
		<xsl:element name="{$text.base}" use-attribute-sets="text.base"><xsl:apply-templates select="." mode="t_postbodymp"/></xsl:element>
		
		<div class="add-comment">
		<table cellpadding="0" cellspacing="0" width="390" border="0"><tr>
		<td valign="top"></td>
		<td align="right">
		<!-- COMPLAIN ABOUT THIS POST -->
		<xsl:apply-templates select="@HIDDEN" mode="c_complainmp"/></td>
		</tr></table>
		</div>
				
		<!-- EDIT AND MODERATION HISTORY -->
		
		<xsl:if test="$test_IsEditor">
		<div align="right"><img src="{$imagesource}icons/white/icon_edit.gif" alt="" width="17" height="17" border="0"/>&nbsp;
		<xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall">
		<xsl:apply-templates select="@POSTID" mode="c_editmp"/>
		<xsl:text>  </xsl:text> | <xsl:text>  </xsl:text>
		<xsl:apply-templates select="@POSTID" mode="c_linktomoderate"/>
		</xsl:element>
		</div>
		</xsl:if>
			
		<!-- 
		or read first reply
		<xsl:if test="@FIRSTCHILD"> / </xsl:if>
		<xsl:apply-templates select="@FIRSTCHILD" mode="c_multiposts"/> -->
		
	
	
<!-- 	in reply to	<xsl:if test="@INREPLYTO">
			(<xsl:apply-templates select="@INREPLYTO" mode="c_multiposts"/>)
		</xsl:if> -->
	
		
<!-- 		<xsl:apply-templates select="@PREVINDEX" mode="c_multiposts"/>
		<xsl:if test="@PREVINDEX and @NEXTINDEX"> | </xsl:if>
		<xsl:apply-templates select="@NEXTINDEX" mode="c_multiposts"/> -->
			

	</xsl:template>
		<!--
	<xsl:template match="POST" mode="t_postsubjectmp">
	Author:		Tom Whitehouse
	Context:      /H2G2/FORUMTHREADPOSTS/POST
	Purpose:	 Creates the SUBJECT text 
	-->
	<xsl:template match="POST" mode="t_postsubjectmp">
		<xsl:choose>
			<xsl:when test="@HIDDEN = 1">
				<xsl:copy-of select="$m_postsubjectremoved"/>
			</xsl:when>
			<xsl:when test="@HIDDEN = 2">
				<xsl:copy-of select="$m_awaitingmoderationsubject"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="SUBJECT"/>
			</xsl:otherwise>
		</xsl:choose>
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
	<xsl:template match="USERNAME">
	Context:    checks for EDITOR
	Generic:	Yes
	Purpose:	Displays a username (in bold/italic if necessary)
	-->
	<xsl:template match="USERNAME">
	<xsl:choose>
	<xsl:when test="../EDITOR = 1">
		<B><I><xsl:apply-templates/></I></B>
	</xsl:when>
	<xsl:otherwise>
		<xsl:apply-templates/>
	</xsl:otherwise>
	</xsl:choose>
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
		<xsl:apply-imports/>
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
	
	<!-- DEFINE PAGE NUMBER -->
	<xsl:variable name="pagenumber">
		<xsl:choose>
		<xsl:when test=".='0'">
		 1
		</xsl:when>
		<xsl:when test=".='20'">
		 2
		</xsl:when>
		<xsl:otherwise>
		<xsl:value-of select="round(. div 20 + 1)" /><!-- TODO -->
		</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<!-- DEFINE NUMBER OF PAGES-->
	<xsl:variable name="pagetotal">
    <xsl:value-of select="ceiling(/H2G2/FORUMTHREADPOSTS/@TOTALPOSTCOUNT div 20)" />
	</xsl:variable>
	<!-- TODO not in design (<xsl:value-of select="/H2G2/FORUMTHREADPOSTS/@TOTALPOSTCOUNT" /> posts) -->
	
		<div class="next-back">
			<xsl:element name="{$text.base}" use-attribute-sets="text.base"><!-- totalposts -->
			page <xsl:value-of select="$pagenumber" /> of <xsl:value-of select="$pagetotal" />
			</xsl:element><br />
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
			<td><xsl:element name="{$text.base}" use-attribute-sets="text.base"><xsl:copy-of select="$arrow.first" />&nbsp;<xsl:apply-templates select="." mode="c_gotobeginning"/> | <xsl:copy-of select="$arrow.previous" />&nbsp;<xsl:apply-templates select="." mode="c_gotoprevious"/> </xsl:element></td>
			<td align="center" class="next-back"><xsl:element name="{$text.base}" use-attribute-sets="text.base"><xsl:apply-templates select="/H2G2/FORUMTHREADPOSTS" mode="c_postblocks"/></xsl:element></td>
			<td align="right"><xsl:element name="{$text.base}" use-attribute-sets="text.base"><xsl:apply-templates select="." mode="c_gotonext"/>&nbsp;<xsl:copy-of select="$arrow.next" /> | <xsl:apply-templates select="." mode="c_gotolatest"/>&nbsp;<xsl:copy-of select="$arrow.latest" /></xsl:element></td>
			</tr>
			</table>
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
	<xsl:template match="@SKIPTO" mode="link_gotoprevious">
	Author:		Tom Whitehouse
	Context:      /H2G2/FORUMTHREADPOSTS/@SKIPTO
	Purpose:	 Creates 'previous' link
	-->
	<xsl:template match="@SKIPTO" mode="link_gotoprevious">
		<a href="{$root}F{../@FORUMID}?thread={../@THREADID}&amp;skip={(.) - (../@COUNT)}&amp;show={../@COUNT}" xsl:use-attribute-sets="maSKIPTO_link_gotoprevious">
			<xsl:value-of select="$alt_showprevious"/>
		</a>
	</xsl:template>
	
		<!--
	<xsl:template match="@SKIPTO" mode="link_gotonext">
	Author:		Tom Whitehouse
	Context:      /H2G2/FORUMTHREADPOSTS/@SKIPTO
	Purpose:	 Creates the 'next' link
	-->
	<xsl:template match="@SKIPTO" mode="link_gotonext">
		<a href="{$root}F{../@FORUMID}?thread={../@THREADID}&amp;skip={(.) + (../@COUNT)}&amp;show={../@COUNT}" xsl:use-attribute-sets="maSKIPTO_link_gotonext">
			<xsl:value-of select="$alt_shownext"/>
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
