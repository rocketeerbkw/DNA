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
	<xsl:with-param name="message"></xsl:with-param>
	<xsl:with-param name="pagename">multipostspage.xsl</xsl:with-param>
	</xsl:call-template>
	<!-- DEBUG -->
	

	<xsl:choose>
	<xsl:when test="/H2G2/FORUMSOURCE/@TYPE='reviewforum'">
	<!-- THIS IS THE LAYOUT FOR THE REVIEW INTRO -->
	<!-- start of table -->
	<xsl:element name="table" use-attribute-sets="html.table.container">
	<tr>
	<xsl:element name="td" use-attribute-sets="column.1">
	
	<div class="banner3">
	<table width="400" border="0" cellspacing="0" cellpadding="0">
	<tr>
	<td valign="top"><img src="{$imagesource}reviewcircle/pic_intro.gif" alt="Intro" width="205" height="153" border="0"/></td>
	<td valign="top">
	<div class="MainPromo2">
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	THIS IS AN INTRODUCTION FOR:
	</xsl:element>
	
	<div class="heading3">
		<xsl:element name="{$text.headinglarge}" use-attribute-sets="text.headinglarge">
	<a href="{FORUMTHREADPOSTS/POST/TEXT/LINK}"><xsl:value-of select="substring-after(FORUMTHREADPOSTS/POST/SUBJECT,'- ')" /></a>
	</xsl:element>
	</div>
	</div>
	</td>
	</tr>
	</table>
	</div>
	<img src="{$graphics}/backgrounds/back_papertop.gif" alt="" width="400" height="26" border="0" />
	<div class="PageContent">
	<div class="box">
	<table width="390" border="0" cellspacing="0" cellpadding="2">
	<tr>
	<td class="boxheading">
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	<span class="heading1">
	<xsl:value-of select="substring-after(FORUMTHREADPOSTS/POST/SUBJECT,'- ')" />
	</span>
	</xsl:element>
	</td>
	</tr>
	<tr>
	<td>
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	<span class="credit2">by</span>&nbsp; <a href="U{FORUMTHREADPOSTS/POST/USER/USERID}"><xsl:value-of select="FORUMTHREADPOSTS/POST/USER/USERNAME" /></a></xsl:element><br/>

	<xsl:variable name="userid" select="concat('- U', FORUMTHREADPOSTS/POST/USER/USERID)" />
	<br/>
	<xsl:element name="{$text.base}" use-attribute-sets="text.base">
	<xsl:value-of select="substring-after(FORUMTHREADPOSTS/POST/TEXT, $userid)"/>
	</xsl:element>	
	<br/><br/>
	</td>
	</tr>
	</table>
	
	<table width="390" border="0" cellspacing="0" cellpadding="0">
	<tr>
	<td align="right" class="boxactionback1">
	<!-- COMPLAIN ABOUT THIS POST -->
	<a href="UserComplaint?PostID={FORUMTHREADPOSTS/POST/@POSTID}" target="ComplaintPopup" onClick="popupwindow('UserComplaint?PostID={FORUMTHREADPOSTS/POST/@POSTID}', 'ComplaintPopup', 'status=1,resizable=1,scrollbars=1,width=640,height=480')" xsl:use-attribute-sets="maHIDDEN_r_complainmp">
	<xsl:copy-of select="$alt_complain"/>
	</a>
	</td>
	</tr>
	</table>
	</div>
	
	</div>
	
	</xsl:element>
	<xsl:element name="td" use-attribute-sets="column.2">
	
	</xsl:element>
	</tr>
	</xsl:element>
	<!-- end of table -->	
	
	
	</xsl:when>
	<xsl:otherwise>
	
	<!-- start of table -->
	<xsl:element name="table" use-attribute-sets="html.table.container">
	<tr>
	<xsl:element name="td" use-attribute-sets="column.1">
	
	<xsl:element name="{$text.base}" use-attribute-sets="text.base">
	

	<div class="banner3">
	<table width="398" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td valign="top">
		<img src="{$imagesource}talk/pic_talk.gif" alt="Conversation" width="205" height="153" border="0"/>
		</td>
		<td valign="top">
		<div class="MainPromo2">
	<xsl:choose>
	<xsl:when test="/H2G2/FORUMSOURCE/@TYPE='clubjournal'">
	
			<span class="heading2">
			<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
			THIS GROUP DISCUSSION IS RELATED TO
			</xsl:element></span>
			<div class="heading3">
			<xsl:element name="{$text.headinglarge}" use-attribute-sets="text.headinglarge">
			<a href="G{FORUMSOURCE/CLUB/@ID}"><xsl:value-of select="FORUMSOURCE/CLUB/NAME" /></a>
			</xsl:element>
			</div>
	
	</xsl:when>
	<xsl:when test="/H2G2/FORUMSOURCE/@TYPE='journal'">
	
			<span class="heading2">
			<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
			THIS IS THE WEBLOG OF
			</xsl:element></span>
			<div class="heading3">
			<xsl:element name="{$text.headinglarge}" use-attribute-sets="text.headinglarge">
			<a href="U{FORUMSOURCE/JOURNAL/USER/USERID}"><xsl:value-of select="FORUMSOURCE/JOURNAL/USER/USERNAME" /></a>
			</xsl:element>
			</div>
			
	</xsl:when>
	<xsl:when test="/H2G2/FORUMSOURCE/@TYPE='userpage'">
	
			<span class="heading2">
			<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
			THIS IS A MESSAGE FOR
			</xsl:element></span>
			<div class="heading3">
			<xsl:element name="{$text.headinglarge}" use-attribute-sets="text.headinglarge">
			<a href="U{FORUMSOURCE/USERPAGE/USER/USERID}"><xsl:value-of select="FORUMSOURCE/USERPAGE/USER/USERNAME" /></a>
			</xsl:element>
			</div>
		
	</xsl:when>
	<xsl:otherwise>
		
			<xsl:element name="{$text.base}" use-attribute-sets="text.base">
			<span class="heading2">THIS CONVERSATION IS RELATED TO</span> <br/>
			</xsl:element>
			
			<div class="heading3">
			<xsl:element name="{$text.headinglarge}" use-attribute-sets="text.headinglarge">
			<a href="A{FORUMSOURCE/ARTICLE/ARTICLEINFO/H2G2ID}"><xsl:value-of select="FORUMSOURCE/ARTICLE/SUBJECT" /></a></xsl:element><br/>
			<xsl:element name="{$text.base}" use-attribute-sets="text.base">
			
			in 
			<xsl:choose>
			<xsl:when test="/H2G2/FORUMSOURCE/ARTICLE/ARTICLEINFO/STATUS/@TYPE='9'">help</xsl:when>
			<xsl:otherwise><xsl:value-of select="$forumsubtype" /></xsl:otherwise>
			</xsl:choose>
			 section
			
			</xsl:element>
			</div>
		
			<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">	
			<div class="arrow3"><xsl:apply-templates select="FORUMTHREADPOSTS" mode="t_allthreads"/></div>
			
			</xsl:element>
			
	</xsl:otherwise>
	</xsl:choose>		
		</div>
		</td>
	</tr>
	</table>
	</div>


		
	</xsl:element>
	<img src="{$graphics}/backgrounds/back_papertop.gif" alt="" width="400" height="26" border="0" />
	<div class="PageContent">
	<!-- PREV AND NEXT -->
	<xsl:apply-templates select="FORUMTHREADPOSTS/@SKIPTO" mode="c_navbuttons"/>
	
	<!-- POSTS -->
	<xsl:apply-templates select="FORUMTHREADPOSTS" mode="c_multiposts"/>
	
	<!-- PREV AND NEXT -->
	<xsl:apply-templates select="FORUMTHREADPOSTS/@SKIPTO" mode="c_navbuttons"/>
	


	<xsl:if test="$test_IsEditor"><!-- removed for site pulldown -->
	<div class="boxactionback">
	<div class="arrow1">
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	<xsl:apply-templates select="FORUMTHREADPOSTS" mode="c_subcribemultiposts"/>
	</xsl:element>
	</div>
	</div>
	<!-- removed for site pulldown --></xsl:if>



	</div>	
	</xsl:element>
	<xsl:element name="td" use-attribute-sets="column.2">
	
	<div class="NavPromoOuter">
	<div class="NavPromo">	
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	<xsl:copy-of select="$key.tips" />
	</xsl:element>
	</div>
	</div>
	
	<xsl:if test="$test_IsEditor"><!-- removed for site pulldown -->
		<div class="rightnavboxheaderhint">
		<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
		HINTS AND TIPS
		</xsl:element>
		</div>
		<div class="rightnavbox">
		<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
		<xsl:copy-of select="$conversation.tips" />
		</xsl:element>
		</div>
		<!-- removed for site pulldown -->
	</xsl:if>

<!-- 	<xsl:call-template name="popupconversationslink">
		<xsl:with-param name="content">
			<xsl:copy-of select="$arrow.right" />
			<xsl:value-of select="$alt_myconversations" />
		</xsl:with-param>
	</xsl:call-template> -->

	<xsl:apply-templates select="/H2G2/SITECONFIG/IMGPROMO1" />

	<xsl:apply-templates select="/H2G2/SITECONFIG/IMGPROMO2" />
	
	<xsl:apply-templates select="/H2G2/SITECONFIG/IMGPROMO3" />
	
	
	</xsl:element>
	</tr>
	</xsl:element>
	
	</xsl:otherwise>
	</xsl:choose>
	
	</xsl:template>
	
	<xsl:variable name="mpsplit" select="8"/> 
	
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
		<span class="urlon"><xsl:copy-of select="$url"/></span>
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
		<span class="urloff"><xsl:copy-of select="$url"/></span>
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
	
	<xsl:if test="count(/H2G2/FORUMTHREADPOSTS/POST) = @INDEX + 1"><a name="last" id="last"></a></xsl:if>
	<xsl:apply-templates select="@POSTID" mode="t_createanchor"/>
	<div class="box">
		<table width="390" border="0" cellspacing="0" cellpadding="0">
		<tr><td class="boxheading">
		<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
		<strong><xsl:apply-templates select="." mode="t_postsubjectmp"/></strong>
		</xsl:element>
		</td><td align="right" class="boxheading">
		<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
		post <xsl:apply-templates select="." mode="t_postnumber"/>
		</xsl:element>	
		</td></tr></table>
		
		<div class="boxback2">
		<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
		<xsl:if test="@HIDDEN='0'">
		<!-- POST INFO -->
		<span class="credit2"><xsl:copy-of select="$m_posted"/></span>&nbsp;
		<xsl:apply-templates select="USER/USERNAME" mode="c_multiposts"/>&nbsp; 
		<xsl:apply-templates select="USER" mode="c_onlineflagmp"/>|  
		<span class="credit2">posted
		<xsl:apply-templates select="DATEPOSTED/DATE" mode="t_postdatemp"/>
		<xsl:apply-templates select="." mode="c_gadgetmp"/></span>
		</xsl:if>
		</xsl:element>
		<div class="postbody">
		<xsl:element name="{$text.base}" use-attribute-sets="text.base">
		<xsl:apply-templates select="." mode="t_postbodymp"/>
		</xsl:element>
		</div>
		</div>
		</div>	
		<table width="392" border="0" cellspacing="0" cellpadding="0">
		<tr>
		<td valign="top" class="boxactionbottom">
		<!-- REPLY OR ADD COMMENT -->
		
		<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
		<xsl:if test="$test_IsEditor"><!-- removed for site pulldown -->
		<xsl:apply-templates select="@POSTID" mode="c_replytopost"/>
		</xsl:if>
		&nbsp;</xsl:element>
		
		</td>
		<td align="right" class="boxactionbottom">
		<!-- COMPLAIN ABOUT THIS POST -->
		<xsl:apply-templates select="@HIDDEN" mode="c_complainmp"/>
		</td>
		</tr>
		</table>
			
		<!-- EDIT AND MODERATION HISTORY -->
		<xsl:if test="$test_IsEditor">
		<div class="moderationbox">
		<div align="right"><img src="{$graphics}icons/icon_editorsedit.gif" alt="" width="23" height="21" border="0" align="left"/>
		<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
		<xsl:apply-templates select="@POSTID" mode="c_editmp"/>
		<xsl:text>  </xsl:text> | <xsl:text>  </xsl:text>
		<xsl:apply-templates select="@POSTID" mode="c_linktomoderate"/>
		</xsl:element>
		</div>
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
		<div class="arrow1"><xsl:apply-imports/></div>
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
	
		<div class="prevnextbox">
			
			<table width="390" border="0" cellspacing="0" cellpadding="0">
			<tr>			
			<td colspan="3">
			<xsl:element name="{$text.medium}" use-attribute-sets="text.medium"><!-- totalposts -->
			<strong>You are looking at page <xsl:value-of select="$pagenumber" /> of <xsl:value-of select="$pagetotal" /></strong>
			</xsl:element>
			</td></tr>
			<tr>
			<td align="left">
			<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
			<xsl:copy-of select="$arrow.first" />
			&nbsp;<xsl:apply-templates select="." mode="c_gotobeginning"/> | 
			<xsl:copy-of select="$arrow.previous" />
			&nbsp;<xsl:apply-templates select="." mode="c_gotoprevious"/> 
			</xsl:element>
			</td>
			<td align="center" class="next-back">
			<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
			<xsl:apply-templates select="/H2G2/FORUMTHREADPOSTS" mode="c_postblocks"/>
			</xsl:element>
			</td>
			<td align="right">
			<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
			<xsl:apply-templates select="." mode="c_gotonext"/>
			&nbsp;<xsl:copy-of select="$arrow.next" /> | 
			<xsl:apply-templates select="." mode="c_gotolatest"/>
			&nbsp;<xsl:copy-of select="$arrow.latest" /></xsl:element>
			</td>
			</tr>
			</table>
		</div>
		<br/>
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
