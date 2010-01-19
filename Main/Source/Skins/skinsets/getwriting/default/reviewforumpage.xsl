<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
	<!ENTITY space "<xsl:text xmlns:xsl='http://www.w3.org/1999/XSL/Transform'> </xsl:text>">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<xsl:import href="../../../base/base-reviewforumpage.xsl"/>
		<xsl:variable name="reviewcirclename" select="/H2G2/REVIEWFORUM/FORUMNAME" />
	<xsl:variable name="reviewcircleurl" select="/H2G2/REVIEWFORUM/URLFRIENDLYNAME" />
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
									Page - Level  template
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->

	
	<xsl:template name="REVIEWFORUM_MAINBODY">


	<!-- DEBUG -->
	<xsl:call-template name="TRACE">
	<xsl:with-param name="message"></xsl:with-param>
	<xsl:with-param name="pagename">reviewforumpage.xsl</xsl:with-param>
	</xsl:call-template>
	<!-- DEBUG -->
	
	
	<!-- start of table -->
		<xsl:element name="table" use-attribute-sets="html.table.container">
		<tr>
		<xsl:element name="td" use-attribute-sets="column.1">
		
		<div class="PageContent">
		<table width="390" border="0" cellspacing="0" cellpadding="0">
		<tr>
		<td valign="top">
		<img src="{$imagesource}/reviewcircle/rcircle_{$reviewcircleurl}.gif" alt="{$reviewcirclename}" width="200" height="130"  border="0" />
		</td>
		<td>
		<xsl:apply-templates select="/H2G2/ARTICLE/GUIDE/BODY" mode="c_reviewforum"/>
		</td>
		</tr>
		</table>
		<xsl:apply-templates select="REVIEWFORUM/REVIEWFORUMTHREADS" mode="c_reviewforum"/>
		</div>
		<br/>
		
		
		<div class="ReviewForumNav">
		<div class="heading1">
		<xsl:element name="{$text.base}" use-attribute-sets="text.base">
		Select other read and review below
		</xsl:element>
		</div>
			
		
		<table border="0" cellspacing="0" cellpadding="3">
		<tr>
		<td><xsl:element name="{$text.medium}" use-attribute-sets="text.medium"><a href="{root}shortfiction" id="tabbodyarrowon">Short Fiction</a></xsl:element></td> 
		<td rowspan="3">&nbsp;</td>
		<td><xsl:element name="{$text.medium}" use-attribute-sets="text.medium"><a href="{root}poetry" id="tabbodyarrowon">Poetry</a></xsl:element></td>
		<td rowspan="3">&nbsp;</td>
		<td><xsl:element name="{$text.medium}" use-attribute-sets="text.medium"><a href="{root}forchildren" id="tabbodyarrowon">For Children</a></xsl:element></td>
		</tr>
		<tr>
		<td><xsl:element name="{$text.medium}" use-attribute-sets="text.medium"><a href="{root}nonfiction" id="tabbodyarrowon">Non-Fiction</a></xsl:element></td>
		<td><xsl:element name="{$text.medium}" use-attribute-sets="text.medium"><a href="{root}dramascripts" id="tabbodyarrowon">Drama Scripts</a></xsl:element></td>
		<td><xsl:element name="{$text.medium}" use-attribute-sets="text.medium"><a href="{root}extendedwork" id="tabbodyarrowon">Extended Work</a></xsl:element></td>
		</tr>
		<tr>
		<td><xsl:element name="{$text.medium}" use-attribute-sets="text.medium"><a href="{root}scifi" id="tabbodyarrowon">Sci-Fi &amp; Fantasy</a></xsl:element></td>
		<td><xsl:element name="{$text.medium}" use-attribute-sets="text.medium"><a href="{root}crimethriller" id="tabbodyarrowon">Crime &amp; Thriller</a></xsl:element></td>
		<td><xsl:element name="{$text.medium}" use-attribute-sets="text.medium"><a href="{root}comedyscripts" id="tabbodyarrowon">Comedy Scripts</a></xsl:element></td>
		</tr>
		</table>

		</div>
		
		<xsl:apply-templates select="/H2G2/SITECONFIG/SUBPROMO1" />
		
		</xsl:element>
		<xsl:element name="td" use-attribute-sets="column.2">
		
		
		<div>
		<xsl:attribute name="class">
		<xsl:if test="descendant::NAVPROMO/@TYPE">NavPromoOuter</xsl:if>
		</xsl:attribute>
		<div>
		<xsl:attribute name="class">
		<xsl:value-of select="descendant::NAVPROMO/@TYPE" />
		</xsl:attribute>
		<xsl:apply-templates select="/H2G2/ARTICLE/GUIDE/SUBPROMO2"/>
		</div>
		</div>
		
		<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
		<div class="rightnavboxheader">READ AND REVIEW TIPS</div>
		<div class="rightnavbox">
		<xsl:copy-of select="$page.reviewcircle.tips" />
		</div>
		</xsl:element>
		

		<br/>	
		<xsl:apply-templates select="/H2G2/ARTICLE/GUIDE/SUBPROMO3"/>
				
		<xsl:apply-templates select="/H2G2/ARTICLE/GUIDE/SUBPROMO4"/>
		
			
		</xsl:element>
		</tr>
		</xsl:element>
	<!-- end of table -->	
		
		<xsl:if test="$test_IsEditor">
		<div class="editbox">
<div class="arrow2"><a href="TypedArticle?aedit=new&amp;type=1&amp;h2g2id={/H2G2/REVIEWFORUM/H2G2ID}">Edit the Review Circle article</a></div>
 <div class="arrow2"><a href="EditReview?id={/H2G2/REVIEWFORUM/@ID}">Edit the Review Circle details</a> </div>
		</div>
		</xsl:if>
		
		
		<!-- 
		<xsl:apply-templates select="REVIEWFORUM" mode="c_info"/>
		<xsl:apply-templates select=".//FOOTNOTE" mode="c_reviewforum"/> -->
	</xsl:template>
	<!--
	<xsl:template match="BODY" mode="r_reviewforum">
	Description: Presentation of the article BODY 
	 -->
	<xsl:template match="BODY" mode="r_reviewforum">
	
		<xsl:apply-imports/>
		
	</xsl:template>
	<!--
	<xsl:template match="FOOTNOTE" mode="object_reviewforum">
	Description: Presentation of the footnote object 
	 -->
	<xsl:template match="FOOTNOTE" mode="object_reviewforum">
		<xsl:apply-imports/>
	</xsl:template>
	<!--
	<xsl:template match="FOOTNOTE" mode="number_reviewforum">
	Description: Presentation of the numeral within the footnote object
	 -->
	<xsl:template match="FOOTNOTE" mode="number_reviewforum">
				<xsl:apply-imports/>
	</xsl:template>
	<!--
	<xsl:template match="FOOTNOTE" mode="text_reviewforum">
	Description: Presentation of the text within the footnote object
	 -->
	<xsl:template match="FOOTNOTE" mode="text_reviewforum">
		<xsl:apply-imports/>
	</xsl:template>
	<!--
	<xsl:template match="REVIEWFORUMTHREADS" mode="empty_reviewforum">
	Description: Presentation of an empty review forum
	 -->
	<xsl:template match="REVIEWFORUMTHREADS" mode="empty_reviewforum">
		<xsl:value-of select="$m_rftnoarticlesinreviewforum"/>
	</xsl:template>
	<!--
	<xsl:template match="REVIEWFORUMTHREADS" mode="full_reviewforum">
	Description: Presentation of a review forum with content
	 -->
	<xsl:template match="REVIEWFORUMTHREADS" mode="full_reviewforum">
<!-- 	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
		<strong>Reviewing quick tips</strong><br/>
		Be polite<br/>
		Dont be<br/>
		Spelling &amp; Grammar<br/>
	</xsl:element> -->
	
		<br/>
		<xsl:apply-templates select="." mode="c_threadnavigation"/>
		
		<div class="box">
		<table width="390" border="0" cellspacing="0" cellpadding="0">
		<xsl:apply-templates select="." mode="c_headers"/>
		<xsl:apply-templates select="THREAD" mode="c_reviewforum"/>
		</table>
		</div>
		
		
		
		<div class="boxactionback"><div class="arrow1">
		<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
		<xsl:apply-templates select="." mode="c_moreentries"/>
		</xsl:element>
		</div></div>
		
<!-- 	<div class="boxactionback"><div class="arrow1">
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	<xsl:apply-templates select="." mode="c_subscribe"/>
	</xsl:element>
	</div> </div>-->
		
		
	</xsl:template>
	<!-- 
	<xsl:template match="REVIEWFORUMTHREADS" mode="r_threadnavigation">
	Use: Display of the thread navigation, this only appears on a page where the article doesn't
	-->
	<xsl:template match="REVIEWFORUMTHREADS" mode="r_threadnavigation">
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
	
			<div class="prevnextbox">
			
			<table width="390" border="0" cellspacing="0" cellpadding="0">
<!-- 			<tr>			
			<td  colspan="3">
			<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
			<strong>You are looking at page <xsl:value-of select="$pagenumber" /> of <! <xsl:value-of select="$pagetotal" /></strong>
			</xsl:element>
			</td></tr> -->
			<tr>
			<td align="left">
			<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
			<xsl:copy-of select="$arrow.first" />
			&nbsp;<xsl:apply-templates select="." mode="c_firstpage"/> | 
			<xsl:copy-of select="$arrow.previous" />
			&nbsp;<xsl:apply-templates select="." mode="c_previouspage"/>
			</xsl:element>
			</td>
			<td align="center">
			<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
			<xsl:apply-templates select="." mode="c_rfthreadblocks"/>
			</xsl:element>
			</td>
			<td align="right">
			<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
			<xsl:apply-templates select="." mode="c_nextpage"/>
			&nbsp;<xsl:copy-of select="$arrow.next" /> | 
			<xsl:apply-templates select="." mode="c_lastpage"/>
			&nbsp;<xsl:copy-of select="$arrow.latest" /></xsl:element>
			</td>
			</tr>
			</table>
		</div>

	</xsl:template>
	<!-- 
	<xsl:template match="REVIEWFORUMTHREADS" mode="r_rfthreadblocks">
	Use: Display of the thread navigation block
	-->
	<xsl:template match="REVIEWFORUMTHREADS" mode="r_rfthreadblocks">
		<xsl:apply-templates select="." mode="c_rfpostblock"/>
	</xsl:template>
	<!-- 
	<xsl:template match="REVIEWFORUMTHREADS" mode="on_postblock">
	Use: Display of current thread block  - eg 'now showing 21-40'
		  The range parameter must be present to show the numeric value of the thread you are on
	-->
	<xsl:template match="REVIEWFORUMTHREADS" mode="on_rfpostblock">
		<xsl:param name="range"/>
		<xsl:value-of select="concat($alt_nowshowing, ' ', $range, ' ')"/>
		
	</xsl:template>
	<!-- 
	<xsl:template match="REVIEWFORUMTHREADS" mode="off_postblock">
	Use: Display of current post block  - eg 'now showing posts 21-40'
		  The range parameter must be present to show the numeric value of the thread you are on
	-->
	<xsl:template match="REVIEWFORUMTHREADS" mode="off_rfpostblock">
		<xsl:param name="range"/>
		<xsl:value-of select="concat($alt_show, ' ', $range, ' ')"/>
	
	</xsl:template>
	<!-- 
	<xsl:template match="REVIEWFORUMTHREADS" mode="r_headers">
	Use: Display of the thread order links which are also column headers
	-->
	<xsl:template match="REVIEWFORUMTHREADS" mode="r_headers">
	
	
	<tr>
	<td class="boxheading">
	<!-- m_rft_subject -->
	<xsl:element name="{$text.small}" use-attribute-sets="text.small">
	<xsl:apply-templates select="." mode="t_subjectheader"/>
	</xsl:element>
	</td>
	<td class="boxheading">
	<!-- m_rft_dateentered -->
	<xsl:element name="{$text.small}" use-attribute-sets="text.small">
	<xsl:apply-templates select="." mode="t_dateenteredheader"/>
	</xsl:element>
	</td>
	<td class="boxheading">
	<!-- m_rft_author -->
	<xsl:element name="{$text.small}" use-attribute-sets="text.small">
	<xsl:apply-templates select="." mode="t_authorheader"/>
	</xsl:element>
	</td>
	<td class="boxheading">
	<xsl:element name="{$text.small}" use-attribute-sets="text.small">
	AUTHORS INTRO
	</xsl:element>
	</td>
	</tr>


	</xsl:template>
	<!-- 
	<xsl:template match="THREAD" mode="r_reviewforum">
	Use: Presentation of an individual thread in the thread list
	-->
	<xsl:template match="THREAD" mode="r_reviewforum">

	<tr>
		<xsl:attribute name="class">
		<xsl:choose>
		<xsl:when test="count(preceding-sibling::THREAD) mod 2 = 0">colourbar1</xsl:when>
		<xsl:otherwise>colourbar2</xsl:otherwise>
		</xsl:choose>
		</xsl:attribute>
	<td>
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	<xsl:apply-templates select="." mode="t_subject">
		<xsl:with-param name="maxlength">20</xsl:with-param>
	</xsl:apply-templates>
	<br/>
	<xsl:apply-templates select="." mode="c_removefromforum"/>
	</xsl:element>
	</td>
	<td>
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	<xsl:apply-templates select="." mode="r_dateentered"/>
	</xsl:element>
	</td>
	<td>
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	<xsl:apply-templates select="." mode="t_author"/>
	</xsl:element>
	</td>
	<td>
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	<xsl:apply-templates select="." mode="r_readintro"/>
	</xsl:element>
	</td>
	</tr>

	
	</xsl:template>
	<!--
	<xsl:template match="THREAD" mode="t_dateentered">
	Author:		Andy Harris
	Context:      /H2G2/REVIEWFORUM/REVIEWFORUMTHREADS/THREAD
	Purpose:	 Creates the date entered link for a THREAD
	-->
	<xsl:template match="THREAD" mode="r_readintro">
		<a>
			<xsl:attribute name="href">F<xsl:value-of select="../@FORUMID"/>?thread=<xsl:value-of select="THREADID"/></xsl:attribute>
			<xsl:copy-of select="$button.read" />
		</a>
	</xsl:template>
	<!-- 
	<xsl:template match="THREAD" mode="r_removefromforum">
	Use: Presentation of the remove from forum link
	-->
	<xsl:template match="THREAD" mode="r_removefromforum">
		<xsl:if test="/H2G2/VIEWING-USER/USER/GROUPS/EDITOR or /H2G2/VIEWING-USER/USER/USERID=./AUTHOR/USER/USERID or /H2G2/VIEWING-USER/USER/USERID=./SUBMITTER/USER/USERID">
			<a>
				<xsl:attribute name="href"><xsl:value-of select="$root"/>SubmitReviewForum?action=removethread&amp;rfid=<xsl:value-of select="../../@ID"/>&amp;h2g2id=<xsl:value-of select="H2G2ID"/></xsl:attribute>
				<xsl:attribute name="onclick">return window.confirm('Remove entry from Review Forum?');</xsl:attribute>
				<xsl:copy-of select="$button.remove" />
			</a>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="THREAD" mode="t_dateentered">
	Author:		Stacey Zariffis
	Context:      /H2G2/REVIEWFORUM/REVIEWFORUMTHREADS/THREAD
	Purpose:	 Creates the date entered link for a THREAD
	-->
	<xsl:template match="THREAD" mode="r_dateentered">
			<xsl:value-of select="DATEENTERED/DATE/@RELATIVE"/>
	</xsl:template>
	<!-- 
	<xsl:template match="REVIEWFORUMTHREADS" mode="r_moreentries">
	Use: Presentation of the more entries link 
	-->
	<xsl:template match="REVIEWFORUMTHREADS" mode="r_moreentries">
	<!-- m_clickmorereviewentries -->
	<xsl:apply-imports/>
		<br/>
	</xsl:template>
	<!-- 
	<xsl:template match="REVIEWFORUMTHREADS" mode="r_subscribe">
	Use: Presentation of the subscribe and unsubscribe links
	-->
	<xsl:template match="REVIEWFORUMTHREADS" mode="r_subscribe">
		<xsl:apply-imports/>
		<br/>
	</xsl:template>
	<!-- 
	<xsl:template match="REVIEWFORUM" mode="r_info">
	Use: Presentation of review forum information block
	-->
	<xsl:template match="REVIEWFORUM" mode="r_info">
		<xsl:value-of select="$m_reviewforuminfoheader"/>
		<br/>
		Name: <xsl:apply-templates select="." mode="t_name"/>
		<br/>
		URL: <xsl:apply-templates select="." mode="t_url"/>
		<br/>
		<xsl:apply-templates select="." mode="c_recommendable"/>
		<xsl:apply-templates select="." mode="c_editorinfo"/>
	</xsl:template>
	<!-- 
	<xsl:template match="REVIEWFORUM" mode="false_recommendable">
	Use: Presentation of 'not a recommendable review forum' text
	-->
	<xsl:template match="REVIEWFORUM" mode="false_recommendable">
		<xsl:value-of select="$m_notrecommendablereviewforum"/>
	</xsl:template>
	<!-- 
	<xsl:template match="REVIEWFORUM" mode="true_recommendable">
	Use: Presentation of 'recommendable review forum' text
	-->
	<xsl:template match="REVIEWFORUM" mode="true_recommendable">
		<xsl:value-of select="$m_recommendablereviewforum"/>
		<br/>
		<xsl:apply-templates select="." mode="t_incubate"/>
	</xsl:template>
	<!-- 
	<xsl:template match="REVIEWFORUM" mode="r_editorinfo">
	Use: Presentation of information that only appears to an editor
	-->
	<xsl:template match="REVIEWFORUM" mode="r_editorinfo">
		<xsl:apply-templates select="." mode="t_h2g2id"/>
		<xsl:apply-templates select="." mode="t_dataedit"/>
	</xsl:template>
	<!-- 
	<xsl:template match="REVIEWFORUMTHREADS" mode="link_firstpage">
	Use: Presentation of the 'First Page' link
	-->
	<xsl:template match="REVIEWFORUMTHREADS" mode="link_firstpage">
		<xsl:apply-imports/>
	</xsl:template>
	<!-- 
	<xsl:template match="REVIEWFORUMTHREADS" mode="link_lastpage">
	Use: Presentation of the 'Last Page' link
	-->
	<xsl:template match="REVIEWFORUMTHREADS" mode="link_lastpage">
		<xsl:apply-imports/>
	</xsl:template>
	<!-- 
	<xsl:template match="REVIEWFORUMTHREADS" mode="link_previouspage">
	Use: Presentation of the 'Previous Page' link
	-->
	<xsl:template match="REVIEWFORUMTHREADS" mode="link_previouspage">
		<xsl:apply-imports/>
	</xsl:template>
	<!-- 
	<xsl:template match="REVIEWFORUMTHREADS" mode="link_nextpage">
	Use: Presentation of the 'Next Page' link
	-->
	<xsl:template match="REVIEWFORUMTHREADS" mode="link_nextpage">
		<xsl:apply-imports/>
	</xsl:template>
	<!-- 
	<xsl:template match="REVIEWFORUMTHREADS" mode="text_firstpage">
	Use: Presentation of the 'On First Page' message
	-->
	<xsl:template match="REVIEWFORUMTHREADS" mode="text_firstpage">
		<xsl:apply-imports/>
		
	</xsl:template>
	<!-- 
	<xsl:template match="REVIEWFORUMTHREADS" mode="text_lastpage">
	Use: Presentation of the 'On Last Page' message
	-->
	<xsl:template match="REVIEWFORUMTHREADS" mode="text_lastpage">
		<xsl:apply-imports/>
		
	</xsl:template>
	<!-- 
	<xsl:template match="REVIEWFORUMTHREADS" mode="text_previouspage">
	Use: Presentation of the 'No Previous Page' message
	-->
	<xsl:template match="REVIEWFORUMTHREADS" mode="text_previouspage">
		<xsl:apply-imports/>
		
	</xsl:template>
	<!-- 
	<xsl:template match="REVIEWFORUMTHREADS" mode="text_nextpage">
	Use: Presentation of the 'No Next Page' message
	-->
	<xsl:template match="REVIEWFORUMTHREADS" mode="text_nextpage">
		<xsl:apply-imports/>
		
	</xsl:template>
</xsl:stylesheet>
