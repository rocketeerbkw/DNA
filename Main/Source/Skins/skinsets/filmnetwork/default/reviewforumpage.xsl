<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
	<!ENTITY space "<xsl:text xmlns:xsl='http://www.w3.org/1999/XSL/Transform'> </xsl:text>">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<xsl:import href="../../../base/base-reviewforumpage.xsl"/>
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
									Page - Level  template
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<xsl:template name="REVIEWFORUM_MAINBODY">
		<xsl:apply-templates select="/H2G2/ARTICLE/GUIDE/BODY" mode="c_reviewforum"/>
		<xsl:apply-templates select=".//FOOTNOTE" mode="c_reviewforum"/>
		<xsl:apply-templates select="REVIEWFORUM/REVIEWFORUMTHREADS" mode="c_reviewforum"/>
		<xsl:apply-templates select="REVIEWFORUM" mode="c_info"/>
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
		<br/>
		<br/>
	</xsl:template>
	<!--
	<xsl:template match="FOOTNOTE" mode="number_reviewforum">
	Description: Presentation of the numeral within the footnote object
	 -->
	<xsl:template match="FOOTNOTE" mode="number_reviewforum">
		<font size="1">
			<sup>
				<xsl:apply-imports/>
			</sup>
		</font>
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
		<xsl:value-of select="$m_rft_articlesinreviewheader"/>
		<br/>
		<xsl:apply-templates select="." mode="c_threadnavigation"/>
		<xsl:apply-templates select="." mode="c_headers"/>
		<xsl:apply-templates select="THREAD" mode="c_reviewforum"/>
		<xsl:apply-templates select="." mode="c_moreentries"/>
		<xsl:apply-templates select="." mode="c_subscribe"/>
	</xsl:template>
	<!-- 
	<xsl:template match="REVIEWFORUMTHREADS" mode="r_threadnavigation">
	Use: Display of the thread navigation, this only appears on a page where the article doesn't
	-->
	<xsl:template match="REVIEWFORUMTHREADS" mode="r_threadnavigation">
		<xsl:apply-templates select="." mode="c_rfthreadblocks"/>
		<xsl:apply-templates select="." mode="c_firstpage"/>
		<xsl:apply-templates select="." mode="c_lastpage"/>
		<xsl:apply-templates select="." mode="c_previouspage"/>
		<xsl:apply-templates select="." mode="c_nextpage"/>
		<br/>
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
		<br/>
	</xsl:template>
	<!-- 
	<xsl:template match="REVIEWFORUMTHREADS" mode="off_postblock">
	Use: Display of current post block  - eg 'now showing posts 21-40'
		  The range parameter must be present to show the numeric value of the thread you are on
	-->
	<xsl:template match="REVIEWFORUMTHREADS" mode="off_rfpostblock">
		<xsl:param name="range"/>
		<xsl:value-of select="concat($alt_show, ' ', $range, ' ')"/>
		<br/>
	</xsl:template>
	<!-- 
	<xsl:template match="REVIEWFORUMTHREADS" mode="r_headers">
	Use: Display of the thread order links which are also column headers
	-->
	<xsl:template match="REVIEWFORUMTHREADS" mode="r_headers">
		<xsl:apply-templates select="." mode="t_h2g2idheader"/>
		&nbsp;
		<xsl:apply-templates select="." mode="t_subjectheader"/>
		&nbsp;
		<xsl:apply-templates select="." mode="t_dateenteredheader"/>
		&nbsp;
		<xsl:apply-templates select="." mode="t_lastpostedheader"/>
		&nbsp;
		<xsl:apply-templates select="." mode="t_authorheader"/>
		&nbsp;
		<xsl:apply-templates select="." mode="t_authoridheader"/>
		<br/>
		<br/>
	</xsl:template>
	<!-- 
	<xsl:template match="THREAD" mode="r_reviewforum">
	Use: Presentation of an individual thread in the thread list
	-->
	<xsl:template match="THREAD" mode="r_reviewforum">
		<xsl:apply-templates select="." mode="t_h2g2id"/>
		<br/>
		<xsl:apply-templates select="." mode="t_subject">
			<xsl:with-param name="maxlength">58</xsl:with-param>
		</xsl:apply-templates>
		<br/>
		<xsl:apply-templates select="." mode="t_dateentered"/>
		<br/>
		<xsl:apply-templates select="." mode="t_lastposted"/>
		<br/>
		<xsl:apply-templates select="." mode="t_author"/>
		<br/>
		<xsl:apply-templates select="." mode="t_authorid"/>
		<br/>
		<xsl:apply-templates select="." mode="c_removefromforum"/>
		<br/>
	</xsl:template>
	<!-- 
	<xsl:template match="THREAD" mode="r_removefromforum">
	Use: Presentation of the remove from forum link
	-->
	<xsl:template match="THREAD" mode="r_removefromforum">
		<xsl:apply-imports/>
		<br/>
	</xsl:template>
	<!-- 
	<xsl:template match="REVIEWFORUMTHREADS" mode="r_moreentries">
	Use: Presentation of the more entries link
	-->
	<xsl:template match="REVIEWFORUMTHREADS" mode="r_moreentries">
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
		<br/>
	</xsl:template>
	<!-- 
	<xsl:template match="REVIEWFORUMTHREADS" mode="link_lastpage">
	Use: Presentation of the 'Last Page' link
	-->
	<xsl:template match="REVIEWFORUMTHREADS" mode="link_lastpage">
		<xsl:apply-imports/>
		<br/>
	</xsl:template>
	<!-- 
	<xsl:template match="REVIEWFORUMTHREADS" mode="link_previouspage">
	Use: Presentation of the 'Previous Page' link
	-->
	<xsl:template match="REVIEWFORUMTHREADS" mode="link_previouspage">
		<xsl:apply-imports/>
		<br/>
	</xsl:template>
	<!-- 
	<xsl:template match="REVIEWFORUMTHREADS" mode="link_nextpage">
	Use: Presentation of the 'Next Page' link
	-->
	<xsl:template match="REVIEWFORUMTHREADS" mode="link_nextpage">
		<xsl:apply-imports/>
		<br/>
	</xsl:template>
	<!-- 
	<xsl:template match="REVIEWFORUMTHREADS" mode="text_firstpage">
	Use: Presentation of the 'On First Page' message
	-->
	<xsl:template match="REVIEWFORUMTHREADS" mode="text_firstpage">
		<xsl:apply-imports/>
		<br/>
	</xsl:template>
	<!-- 
	<xsl:template match="REVIEWFORUMTHREADS" mode="text_lastpage">
	Use: Presentation of the 'On Last Page' message
	-->
	<xsl:template match="REVIEWFORUMTHREADS" mode="text_lastpage">
		<xsl:apply-imports/>
		<br/>
	</xsl:template>
	<!-- 
	<xsl:template match="REVIEWFORUMTHREADS" mode="text_previouspage">
	Use: Presentation of the 'No Previous Page' message
	-->
	<xsl:template match="REVIEWFORUMTHREADS" mode="text_previouspage">
		<xsl:apply-imports/>
		<br/>
	</xsl:template>
	<!-- 
	<xsl:template match="REVIEWFORUMTHREADS" mode="text_nextpage">
	Use: Presentation of the 'No Next Page' message
	-->
	<xsl:template match="REVIEWFORUMTHREADS" mode="text_nextpage">
		<xsl:apply-imports/>
		<br/>
	</xsl:template>
</xsl:stylesheet>
