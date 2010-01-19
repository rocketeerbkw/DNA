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
	<xsl:with-param name="message">THREADS_MAINBODY<xsl:value-of select="$current_article_type" /></xsl:with-param>
	<xsl:with-param name="pagename">threadspage.xsl</xsl:with-param>
	</xsl:call-template>
	<!-- DEBUG -->
	
		<!-- <xsl:apply-templates select="POSTS/POST-LIST/USER/USERNAME" /> -->

		<xsl:element name="table" use-attribute-sets="html.table.container">
		<tr>
		<xsl:element name="td" use-attribute-sets="column.1">
		
		<div class="PageContent">
		<xsl:call-template name="THREADS_SUBJECT" />
		<xsl:call-template name="NEXT_BACK" />
		<xsl:apply-templates select="FORUMTHREADS" mode="c_threadspage"/>
		<xsl:call-template name="NEXT_BACK" />
		</div>
		
		</xsl:element>
		<xsl:element name="td" use-attribute-sets="column.2">
		

		<xsl:if test="$test_IsEditor"><!-- removed for site pulldown -->
		<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
		<div class="rightnavboxheaderhint">HINTS AND TIPS</div>
		<div class="rightnavbox">
		<xsl:copy-of select="$threads.tips" />
		</div>
		</xsl:element>
		</xsl:if>



		
		<!-- RANDOM PROMO -->


		<xsl:element name="img" use-attribute-sets="column.spacer.2" />
		</xsl:element>
		</tr>
		</xsl:element>				
<!-- TODO not in the design 	
		<xsl:if test="not(FORUMSOURCE/@TYPE='journal')">
	<div class="box">
	start a new conversation<br />
	Lorem ipsum Dorem sit amet<br />
	<xsl:apply-templates select="FORUMTHREADS" mode="c_newconversation"/>
	</div>
	
	<div class="box">
	ADD TO MY CONVERSATION LIST  
	<xsl:apply-templates select="FORUMTHREADS" mode="c_subscribe"/>
	</div> </xsl:if>	-->
	
	<!-- MODERATION TOOLBAR -->
	<div>
	<xsl:apply-templates select="FORUMTHREADS/MODERATIONSTATUS" mode="c_threadspage"/>
	</div>
	</xsl:template>

<!-- next back -->
	<xsl:template name="NEXT_BACK">
		<div class="prevnextbox">
		<table width="390" border="0" cellspacing="0" cellpadding="0">
		<tr>
		<td height="30">
		<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
		<xsl:copy-of select="$arrow.first" />&nbsp;<xsl:apply-templates select="FORUMTHREADS" mode="c_firstpage"/>&nbsp; | <xsl:copy-of select="$arrow.previous" />&nbsp;<xsl:apply-templates select="FORUMTHREADS" mode="c_previouspage"/>
		</xsl:element>
		</td>
		<td align="center" class="next-back">
		<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
		<xsl:apply-templates select="FORUMTHREADS" mode="c_threadblocks"/>
		</xsl:element>
		</td>
		<td align="right"><xsl:element name="{$text.medium}" use-attribute-sets="text.medium"> | <xsl:apply-templates select="FORUMTHREADS" mode="c_nextpage"/>&nbsp;<xsl:copy-of select="$arrow.next" /> | <xsl:apply-templates select="FORUMTHREADS" mode="c_lastpage"/>&nbsp;<xsl:copy-of select="$arrow.latest" />
		</xsl:element>
		</td>
		</tr>
		</table>
		</div>
	</xsl:template>


<!-- headings -->
		<!--
	<xsl:template name="THREADS_SUBJECT">
	Author:		Tom Whitehouse
	Context:      H2G2
	Purpose:	 Creates the text for the subject
	-->
	<xsl:template name="THREADS_SUBJECT">
	<xsl:if test="not(FORUMSOURCE/@TYPE='userpage')">
	<div class="banner3">
	<table width="398" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td valign="top">
		<img src="{$imagesource}talk/pic_talk.gif" alt="Conversation" width="205" height="153" border="0"/>
		</td>
		<td valign="top">
		<div class="MainPromo2">
		
			<xsl:choose>
			<xsl:when test="FORUMSOURCE/@TYPE='journal'">
			
			<xsl:element name="{$text.base}" use-attribute-sets="text.base">
			<span class="heading2">THIS CONVERSATION IS RELATED TO</span> <br/>
			</xsl:element>
			<div class="heading3">
			<xsl:element name="{$text.headinglarge}" use-attribute-sets="text.headinglarge">
			<xsl:apply-templates select="FORUMSOURCE" mode="journal_forumsource"/></xsl:element><br/>
			<xsl:element name="{$text.base}" use-attribute-sets="text.base">in <xsl:value-of select="$forumsubtype" /> section</xsl:element>
			</div>
			
			</xsl:when>
			<xsl:when test="FORUMSOURCE/@TYPE='reviewforum'">
			
			<xsl:element name="{$text.base}" use-attribute-sets="text.base">
			<span class="heading2">THIS CONVERSATION IS RELATED TO</span> <br/>
			</xsl:element>
			<div class="heading3">
			<xsl:element name="{$text.headinglarge}" use-attribute-sets="text.headinglarge">
			<xsl:apply-templates select="FORUMSOURCE" mode="reviewforum_forumsource"/></xsl:element><br/>
			<xsl:element name="{$text.base}" use-attribute-sets="text.base">in <xsl:value-of select="$forumsubtype" /> section</xsl:element>
			</div>
	   			
		
			</xsl:when>
			<xsl:when test="FORUMSOURCE/@TYPE='club'">
			
			<xsl:element name="{$text.base}" use-attribute-sets="text.base">
			<span class="heading2">THIS CONVERSATION IS RELATED TO</span> <br/>
			</xsl:element>
			<div class="heading3">
			<xsl:element name="{$text.headinglarge}" use-attribute-sets="text.headinglarge">
			<xsl:apply-templates select="FORUMSOURCE" mode="club_forumsource"/></xsl:element><br/>
			<xsl:element name="{$text.base}" use-attribute-sets="text.base">in <xsl:value-of select="$forumsubtype" /> section</xsl:element>
			</div>
	   	
	
			</xsl:when>
			<xsl:otherwise>
			
			<xsl:element name="{$text.base}" use-attribute-sets="text.base">
			<span class="heading2">THIS CONVERSATION IS RELATED TO</span> <br/>
			</xsl:element>
			<div class="heading3">
			<xsl:element name="{$text.headinglarge}" use-attribute-sets="text.headinglarge">
			<xsl:apply-templates select="FORUMSOURCE" mode="article_forumsource"/></xsl:element><br/>
			<xsl:element name="{$text.base}" use-attribute-sets="text.base">in <xsl:value-of select="$forumsubtype" /> section</xsl:element>
			</div>

			</xsl:otherwise>
		</xsl:choose>

		</div>
		</td>
	</tr>
	</table>
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
		<div class="box"><xsl:apply-templates select="THREAD" mode="c_threadspage"/></div>
	</xsl:template>
	<!--
	<xsl:template match="THREAD" mode="r_threadspage">
	Use: Presentation of an individual thread in a THREADS page
	 -->
	<xsl:template match="THREAD" mode="r_threadspage">
   	
	<xsl:choose>
	<xsl:when test="/H2G2/FORUMSOURCE/@TYPE='userpage'">
	<div>
	<xsl:attribute name="class">
	<xsl:choose>
	<xsl:when test="count(preceding-sibling::THREAD) mod 2 = 0">colourbar1</xsl:when>
	<xsl:otherwise>colourbar2</xsl:otherwise>
	</xsl:choose>
	</xsl:attribute>
	<table cellspacing="0" cellpadding="0" border="0" width="390">
	<tr>
	<td colspan="2">
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	<strong><xsl:apply-templates select="." mode="c_userpage"/></strong>
	</xsl:element>
	</td>
	</tr>
	<tr>
	<td>
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	first post: <xsl:apply-templates select="FIRSTPOST/DATE" mode="short"/> | 
	latest reply: <xsl:apply-templates select="@THREADID" mode="t_threaddatepostedlinkup"/>
	</xsl:element>
	
	
	</td>
	<td>
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	<xsl:apply-templates select="@THREADID" mode="c_movethreadgadget"/>
	</xsl:element>
	</td>
	</tr>
	</table>
	</div>
	
	</xsl:when>
	<xsl:otherwise>
	
		<div>
			<xsl:attribute name="class">
			<xsl:choose>
			<xsl:when test="count(preceding-sibling::THREAD) mod 2 = 0">colourbar1</xsl:when>
			<xsl:otherwise>colourbar2</xsl:otherwise>
			</xsl:choose>
			</xsl:attribute>
			<table cellspacing="0" cellpadding="0" border="0" width="390">
			<tr>
			<td>
			<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
				<strong><xsl:apply-templates select="SUBJECT" mode="t_threadspage"/></strong>
				<xsl:if test="SUBJECT=''"><a href="{$root}F{@FORUMID}?thread={@THREADID}" xsl:use-attribute-sets="mSUBJECT_t_threadspage">No Subject</a></xsl:if>
				</xsl:element>
			</td>
			</tr><tr>
			<td>
			<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
				<xsl:apply-templates select="TOTALPOSTS" mode="t_numberofreplies" /> comments | <a href="{$root}F{@FORUMID}?thread={@THREADID}&amp;post={LASTPOST/@POSTID}#p{LASTPOST/@POSTID}">last comment</a> | <xsl:apply-templates select="DATEPOSTED/DATE"/>
			</xsl:element>
			</td>
			<td align="right">
			<!-- MESSAGES MOVE THREAD -->
			<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
			<xsl:apply-templates select="@THREADID" mode="c_movethreadgadget"/><xsl:text>  </xsl:text>
			</xsl:element>
			</td>
			</tr>
			</table>
		</div>
	
	</xsl:otherwise>
	</xsl:choose>

	</xsl:template>
	<!--
	<xsl:template match="LASTPOST" mode="c_threadspage">
	Context:      /H2G2/FORUMTHREADS/THREAD/LASTPOST
	Purpose:	 Calls the container for the LASTPOST object
	-->
	<xsl:template match="LASTPOST" mode="r_threadspage">
		<a href="U{USER/USERID}"><xsl:value-of select="USER/USERNAME" /></a>
	</xsl:template>
	
	<!--
	<xsl:template match="@THREADID" mode="r_movethreadgadget">
	Use: Presentation of the move thread editorial tool link
	 -->
	<xsl:template match="@THREADID" mode="r_movethreadgadget">
		<xsl:apply-imports/>
	</xsl:template>
	<!--
	<xsl:template match="FORUMTHREADS" mode="r_subscribe">
	Use: Presentation of the subscribe / unsubscribe button
	 -->
	<xsl:template match="FORUMTHREADS" mode="r_subscribe">
		<xsl:apply-imports/>
	</xsl:template>
	<!--
	<xsl:template match="@THREADID" mode="r_movethreadgadget">
	Use: Presentation of the move thread editorial tool link
	 -->
	<xsl:template match="@THREADID" mode="r_movethreadgadget">
		<xsl:apply-imports/>
	</xsl:template>
	<xsl:variable name="tpsplit" select="8"/>
	<!-- 
	<xsl:template match="FORUMTHREADPOSTS" mode="r_postblocks">
	Use: Container for the complete list of post blocks
	-->
	<xsl:template match="FORUMTHREADS" mode="r_threadblocks">
		<!-- <xsl:apply-templates select="." mode="c_threadblockdisplayprev"/> -->
		<xsl:apply-templates select="." mode="c_threadblockdisplay"/>
	<!-- 	<xsl:apply-templates select="." mode="c_threadblockdisplaynext"/> -->
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
		<span class="urlon"><xsl:copy-of select="$url"/></span>
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
		<span class="urloff"><xsl:copy-of select="$url"/></span>
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
		<xsl:attribute name="class">active</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="mFORUMTHREADS_off_threadblockdisplay">
		<xsl:attribute name="class">inactive</xsl:attribute>
	</xsl:attribute-set>
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
		<span class="previous">
			<xsl:apply-imports/>
		</span>
	</xsl:template>
	<!-- 
	<xsl:template match="FORUMTHREADS" mode="link_nextpage">
	Use: Presentation of the 'Next Page' link
	-->
	<xsl:template match="FORUMTHREADS" mode="link_nextpage">
		<span class="next">
			<xsl:apply-imports/>
		</span>
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
	<!-- 
	<xsl:template match="@SKIPTO" mode="r_gotobeginning">
	use: Skip to the beginning of the conversation embodiment
	-->
	<xsl:template match="@SKIPTO" mode="link_tpgotobeginning">
		<font size="2">
			<xsl:apply-imports/>
		</font>
	</xsl:template>
	<!-- 
	<xsl:template match="@SKIPTO" mode="r_gotoprevious">
	use: Skip to the previous page of the conversation embodiment
	-->
	<xsl:template match="@SKIPTO" mode="link_tpgotoprevious">
		<font size="2">
			<a href="{$root}F{../@FORUMID}?thread={../@THREADID}&amp;skip={(.) - (../@COUNT)}&amp;show={../@COUNT}" xsl:use-attribute-sets="maSKIPTO_link_tpgotoprevious">Previous</a>
		</font>
	</xsl:template>
	<!-- 
	<xsl:template match="@SKIPTO" mode="r_gotonext">
	use: Skip to the next page of the conversation embodiment
	-->
	<xsl:template match="@SKIPTO" mode="link_tpgotonext">
		<font size="2">
			<a href="{$root}F{../@FORUMID}?thread={../@THREADID}&amp;skip={(.) + (../@COUNT)}&amp;show={../@COUNT}" xsl:use-attribute-sets="maSKIPTO_link_tpgotonext">Next</a>
		</font>
	</xsl:template>
	<!-- 
	<xsl:template match="@SKIPTO" mode="r_gotolatest">
	use: Skip to the end of the conversation embodiment
	-->
	<xsl:template match="@SKIPTO" mode="link_tpgotolatest">
		<font size="2">
			<xsl:apply-imports/>
		</font>
	</xsl:template>
	<!-- 
	<xsl:template match="@SKIPTO" mode="r_gotobeginning">
	use: Skip to the beginning of the conversation embodiment
	-->
	<xsl:template match="@SKIPTO" mode="text_tpgotobeginning">
		<font size="2">
			<xsl:apply-imports/>
		</font>
	</xsl:template>
	<!-- 
	<xsl:template match="@SKIPTO" mode="r_gotoprevious">
	use: Skip to the previous page of the conversation embodiment
	-->
	<xsl:template match="@SKIPTO" mode="text_tpgotoprevious">
		<font size="2">
			<xsl:apply-imports/>
		</font>
	</xsl:template>
	<!-- 
	<xsl:template match="@SKIPTO" mode="r_gotonext">
	use: Skip to the next page of the conversation embodiment
	-->
	<xsl:template match="@SKIPTO" mode="text_tpgotonext">
		<font size="2">
			<xsl:apply-imports/>
		</font>
	</xsl:template>
	<!-- 
	<xsl:template match="@SKIPTO" mode="r_gotolatest">
	use: Skip to the end of the conversation embodiment
	-->
	<xsl:template match="@SKIPTO" mode="text_tpgotolatest">
		<font size="2">
			<xsl:apply-imports/>
		</font>
	</xsl:template>
	
</xsl:stylesheet>
