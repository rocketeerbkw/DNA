<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
	<!ENTITY space "<xsl:text xmlns:xsl='http://www.w3.org/1999/XSL/Transform'> </xsl:text>">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<xsl:import href="../../../base/base-frontpage.xsl"/>
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
									Page - Level  template
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<xsl:template name="FRONTPAGE_MAINBODY">
	
	<!-- DEBUG -->
	<xsl:call-template name="TRACE">
	<xsl:with-param name="message">FRONTPAGE_MAINBODY<xsl:value-of select="$current_article_type" /></xsl:with-param>
	<xsl:with-param name="pagename">frontpage.xsl</xsl:with-param>
	</xsl:call-template>
	<!-- DEBUG -->
	
	<xsl:apply-templates select="ARTICLE/FRONTPAGE/BANNER"/>
	<br />
	<xsl:if test="parent::FRONTPAGE">
	<xsl:attribute name="name">image-filter-613</xsl:attribute>
	</xsl:if>
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
	<xsl:element name="td" use-attribute-sets="column.1">
	<!--  EDITORIAL -->
	<xsl:apply-templates select="ARTICLE" mode="c_frontpage"/>
	</xsl:element>
	<xsl:element name="td" use-attribute-sets="column.3" />
	<xsl:element name="td" use-attribute-sets="column.2">
<!-- apply templates to user-generated content area -->
	<xsl:apply-templates select="ARTICLE/FRONTPAGE/RIGHTNAV"/>
	
<!-- 	<div class="rssModule">
	<xsl:element name="A">
	<xsl:attribute name="HREF"><xsl:value-of select="$dna_server" />/dna/collective/xml/</xsl:attribute>
	<img src="{$graphics}icons/logo_rss.gif" alt="RSS" class="mr10" border="0"/>	
	</xsl:element>
	
    <a class="font-base" href="http://www.bbc.co.uk/dna/collective/A5319380" target="_blank">What is RSS?</a>
	<p>Choose your own feeds from collective</p>
	</div> -->
	
	</xsl:element>
	</tr>
	</table>
	
	</xsl:template>
	<!--
	<xsl:template match="ARTICLE" mode="r_frontpage">
	Use: Apply's templates to the root of the editorially-generated content area (GuideML)
	 -->
		
	<xsl:template match="ARTICLE" mode="r_frontpage">
	<xsl:apply-templates select="FRONTPAGE/MAIN-SECTIONS/EDITORIAL/ROW"/>
	</xsl:template>
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
							TOP-FIVES Object
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<!--
	<xsl:template match="TOP-FIVE" mode="r_frontpage">
	Use: Presentation of one individual top five
	 -->
	<xsl:template match="TOP-FIVES">
	
			<xsl:choose>
			<xsl:when test="contains(@TYPE,'Conversations')">
			<xsl:apply-templates select="/H2G2/TOP-FIVES/TOP-FIVE[@NAME='MostRecentConversations']/TOP-FIVE-FORUM[position() &lt;=3]"/> 
			</xsl:when>
			<xsl:when test="contains(@TYPE,'MostRecentUser')">
			<xsl:apply-templates select="/H2G2/TOP-FIVES/TOP-FIVE[@NAME='MostRecentUser']/TOP-FIVE-ARTICLE[position() &lt;=3]"/> 
			</xsl:when>
			</xsl:choose>
	

	<!-- list of converations/reviews -->
   <!--  <xsl:apply-templates select="TOP-FIVE-ARTICLE[position() &lt;=5]|TOP-FIVE-FORUM[position() &lt;=5]" mode="c_frontpage"/> -->

	<!--  more conversation/reviews link -->
	<!-- <xsl:apply-templates select="/H2G2/ARTICLE/FRONTPAGE/MAIN-SECTIONS/RIGHTNAV/TOP-FIVES/AUTO-TOP-FIVE[@TYPE=current()/@NAME]/INFOBOX"/>  <br /><br />
 -->

	</xsl:template>
	<!--
	<xsl:template match="TOP-FIVE-ARTICLE" mode="r_frontpage">
	Use: Presentation of one article link within a top five
	 -->
	<xsl:template match="TOP-FIVE-ARTICLE">
		<div class="icon-bullet">		
		<xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall">
		<a href="{$root}A{H2G2ID}" xsl:use-attribute-sets="mTOP-FIVE-ARTICLE">
			<xsl:value-of select="SUBJECT"/>
		</a>
		</xsl:element>
		</div>
	</xsl:template>
		
	<!--
	<xsl:template match="TOP-FIVE-FORUM" mode="r_frontpage">
	Author:		Tom Whitehouse
	Context:      /H2G2/TOP-FIVES/TOP-FIVE/TOP-FIVE-FORUM
	Purpose:	 Creates the link for the TOP-FIVE-FORUM object
	-->
	<xsl:template match="TOP-FIVE-FORUM">
	<div class="icon-bullet">
	<xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall">
		<a href="{$root}F{FORUMID}?thread={THREADID}" xsl:use-attribute-sets="mTOP-FIVE-FORUM">
			<xsl:value-of select="SUBJECT"/>
		</a>
	</xsl:element>
	</div>
	</xsl:template>

	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
					Frontpage only GuideML tags
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<xsl:template match="ROW">
	
	<!-- determine the background colour of the box -->
	<xsl:variable name="row_colour">
		<xsl:choose>
		<xsl:when test="@TYPE='beigebox'">beigebox</xsl:when>
		<xsl:when test="@TYPE='green'">page-box-FBF5E7</xsl:when>
		<xsl:when test="@TYPE='brown'">page-box-FBF5E7</xsl:when>
		<xsl:otherwise><xsl:value-of select="@TYPE" /></xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<xsl:variable name="width">
		<xsl:choose>
		<xsl:when test="@TYPE"></xsl:when>
		<xsl:when test="$current_article_type=5"></xsl:when>
		<xsl:otherwise>100%</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<div class="{$row_colour}">
		<table width="{$width}" border="0" cellspacing="0" cellpadding="0">	
		<tr>
		<xsl:choose>
		<xsl:when test="/H2G2/ARTICLE/ARTICLEINFO/PREPROCESSED=1">
		<xsl:apply-templates select="*[not(self::BR)]" /> 
		</xsl:when>
		<xsl:otherwise>
		<xsl:apply-templates /> 
		</xsl:otherwise>
		</xsl:choose>
		</tr>
		</table>
	</div>
	
	</xsl:template>
	
	<!--
	<xsl:template match="EDITORIAL-ITEM">
	Use: Currently used as a frontpage XML tag on many existing sites
	 -->
	<xsl:template match="EDITORIAL-ITEM">
		
	<!-- set the width for the table -->
	<xsl:variable name="column">
		<xsl:choose>
		<xsl:when test="@WIDTH='large'">page-column-1</xsl:when>
		<xsl:when test="@WIDTH='full'">page-column-5</xsl:when>
		<xsl:otherwise>page-column-2</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<!-- determine the background colour of the box -->
	<xsl:variable name="cell_colour">
		<xsl:choose>
		<xsl:when test="@TYPE='greenorangebox'"></xsl:when>
		<xsl:when test="@TYPE='greenorangeboxlarge'"></xsl:when>
		<xsl:when test="@TYPE='greenorangeboxfixed'"></xsl:when>
		<xsl:when test="@TYPE='greenbox'">greenbox</xsl:when>
		<xsl:when test="@TYPE='orangebox'">orangebox</xsl:when>
		<xsl:when test="@TYPE='greenboxa'">greenboxa</xsl:when>
		<xsl:when test="@TYPE='greenboxb'">greenboxb</xsl:when>
		<xsl:otherwise><xsl:value-of select="@TYPE" /></xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<xsl:variable name="bridge_colour">
	<xsl:choose>
	<xsl:when test="@TYPE='greenboxa'">greenboxbridge</xsl:when>
	</xsl:choose>
	</xsl:variable>
	
	
	<td valign="top" class="{$column}" id="{$cell_colour}">

	<xsl:choose>
	<!-- this is a bodge to accomodate the design!!  -->
	<xsl:when test="contains(@TYPE, 'box') and @TYPE='greenorangebox' or @TYPE='greenorangeboxlarge' or @TYPE='greenorangeboxfixed'">
		
		<div class="greenorangetitle"><xsl:element name="{$text.subheading}" use-attribute-sets="text.subheading"><strong><xsl:apply-templates select="HEADER/IMG"/><xsl:value-of select="HEADER" /></strong></xsl:element></div>
		<div id="{@TYPE}">
		<xsl:choose>
		<xsl:when test="/H2G2/ARTICLE/ARTICLEINFO/PREPROCESSED=1">
		<xsl:apply-templates select="*[not(self::BR)]" /> 
		</xsl:when>
		<xsl:otherwise>
		<xsl:apply-templates /> 
		</xsl:otherwise>
		</xsl:choose>
		</div>
		
	</xsl:when>
	<xsl:when test="contains(/H2G2/@TYPE, 'FRONTPAGE')">
		<div class="generic-x"><xsl:apply-templates /></div>
	</xsl:when>
	<xsl:when test="contains(@TYPE, 'box') or @WIDTH='large' or preceding-sibling::EDITORIAL-ITEM/@WIDTH='large' or child::COMMENT">
		<xsl:choose>
		<xsl:when test="/H2G2/ARTICLE/ARTICLEINFO/PREPROCESSED=1">
		<xsl:apply-templates select="*[not(self::BR)]" /> 
		</xsl:when>
		<xsl:otherwise>
		<xsl:apply-templates /> 
		</xsl:otherwise>
		</xsl:choose>
	</xsl:when>
	
	<xsl:otherwise>
		<div class="generic-x">
		<xsl:if test="@TYPE">
		<xsl:attribute name="class"><xsl:value-of select="@TYPE" /></xsl:attribute>
		</xsl:if>
		<xsl:choose>
		<xsl:when test="/H2G2/ARTICLE/ARTICLEINFO/PREPROCESSED=1">
		<xsl:apply-templates select="*[not(self::BR)]" /> 
		</xsl:when>
		<xsl:otherwise>
		<xsl:apply-templates /> 
		</xsl:otherwise>
		</xsl:choose>
		</div>
	</xsl:otherwise>
	</xsl:choose>
	
	</td>
	<xsl:if test="position() != last() and not(contains(@TYPE,'dotted'))">
	<td valign="top" width="15" id="{$bridge_colour}">&nbsp;</td>
	</xsl:if> 
	</xsl:template>
	
	

	<!--
	<xsl:template match="EDITORIAL-ITEM">
	Use: Currently used as a frontpage XML tag on many existing sites
	 -->
<!--  	<xsl:template match="ITEM">
	<xsl:apply-templates/>
	</xsl:template>  -->
	
</xsl:stylesheet>
