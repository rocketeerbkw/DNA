<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
	<!ENTITY space "<xsl:text xmlns:xsl='http://www.w3.org/1999/XSL/Transform'> </xsl:text>">
]>
<xsl:stylesheet exclude-result-prefixes="msxsl local s dt" version="1.0" xmlns:dt="urn:schemas-microsoft-com:datatypes" xmlns:local="#local-functions" xmlns:msxsl="urn:schemas-microsoft-com:xslt"
        xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
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
                        <xsl:with-param name="message">FRONTPAGE_MAINBODY<xsl:value-of select="$current_article_type"/></xsl:with-param>
                        <xsl:with-param name="pagename">frontpage.xsl</xsl:with-param>
                </xsl:call-template>
                <!-- DEBUG -->
                <xsl:apply-templates select="ARTICLE/FRONTPAGE/BANNER-CARROUSEL"/>
                <xsl:if test="parent::FRONTPAGE">
                        <xsl:attribute name="name">image-filter-613</xsl:attribute>
                </xsl:if>
                <table border="0" cellpadding="0" cellspacing="0" width="100%">
                        <tr>
                                <xsl:element name="td" use-attribute-sets="column.1">
                                        <!--  EDITORIAL -->
                                        <xsl:apply-templates mode="c_frontpage" select="ARTICLE"/>
                                </xsl:element>
                                <xsl:element name="td" use-attribute-sets="column.3"/>
                                <xsl:element name="td" use-attribute-sets="column.2">
                                        <!-- apply templates to user-generated content area -->
                                        <xsl:apply-templates select="ARTICLE/FRONTPAGE/RIGHTNAV"/>
                                </xsl:element>
                        </tr>
                </table>
        </xsl:template>
        <!--
	<xsl:template match="ARTICLE" mode="r_frontpage">
	Use: Apply's templates to the root of the editorially-generated content area (GuideML)
	 -->
        <xsl:template match="ARTICLE" mode="r_frontpage">
                <xsl:apply-templates select="FRONTPAGE/MAIN-SECTIONS/EDITORIAL"/>
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
        <xsl:template match="EDITORIAL">
                <xsl:for-each select="EDITORIAL-ITEM">
                        <div class="frontpage-item">
                                <xsl:choose>
                                        <xsl:when test="HEADER/@TYPE = 'link'">
                                                <h3>
                                                        <xsl:variable name="category" select="HEADER/@CATEGORY" />
                                                        <a>
                                                                <xsl:choose>
                                                                        <xsl:when test="HEADER/@HREF">
                                                                                <xsl:attribute name="href">
                                                                                        <xsl:value-of select="HEADER/@HREF"/>
                                                                                </xsl:attribute>
                                                                        </xsl:when>
                                                                        <xsl:otherwise>
                                                                                <xsl:attribute name="href">
                                                                                        <xsl:value-of select="concat($root, 'C', msxsl:node-set($categories)/category[@name=$category]/server[@name=$server_type]/@cnum)"/>
                                                                                </xsl:attribute>
                                                                        </xsl:otherwise>
                                                                </xsl:choose>
                                                                <xsl:value-of select="HEADER"/>
                                                        </a>
                                                </h3>
                                        </xsl:when>
                                        <xsl:otherwise>
                                                <h3>
                                                        <xsl:value-of select="HEADER"/>
                                                </h3>
                                        </xsl:otherwise>
                                </xsl:choose>
                                <xsl:apply-templates select="ALSO-LINK" />
                                <xsl:choose>
                                        <xsl:when test="@TYPE = 'ALSOLINKS'">
                                        </xsl:when>
                                        <xsl:otherwise>
                                                <xsl:apply-templates select="IMG"/>
                                                <h4>
                                                        <a href="{$root}{LINK/@DNAID}">
                                                                <xsl:value-of select="LINK"/>
                                                        </a>
                                                </h4>
                                                <h5>
                                                        <xsl:value-of select="TYPE"/>
                                                </h5>
                                                <p>
                                                        <xsl:value-of select="BODY"/>
                                                </p>
                                                
                                        </xsl:otherwise>
                                </xsl:choose>
                        </div>
                        <xsl:if test="position() mod 2 = 0">
                                <span class="clear"></span>
                        </xsl:if>
                </xsl:for-each>
        </xsl:template>
        <xsl:template match="ALSO-LINK">
                <div class="also-link">
                        <xsl:variable name="hrefValue">
                        <xsl:choose>
                                <xsl:when test="@HREF">
                                        <xsl:value-of select="@HREF"/>
                                </xsl:when>
                                <xsl:when test="@DNAID">
                                        <xsl:value-of select="concat($root, @DNAID)"/>
                                </xsl:when>
                        </xsl:choose>
                        </xsl:variable>
                        <a href="{$hrefValue}"><img width="64" height="36" alt="{IMG/ALT}" src="{$photosource}{IMG/@NAME}" /></a>
                        <h4><a href="{$hrefValue}"><xsl:value-of select="HEADER"/></a></h4>
                        <p><xsl:value-of select="BODY"/></p>
                </div>
        </xsl:template>
        <xsl:template match="ROW">
                <!-- determine the background colour of the box -->
                <xsl:variable name="row_colour">
                        <xsl:choose>
                                <xsl:when test="@TYPE='beigebox'">beigebox</xsl:when>
                                <xsl:when test="@TYPE='green'">page-box-FBF5E7</xsl:when>
                                <xsl:when test="@TYPE='brown'">page-box-FBF5E7</xsl:when>
                                <xsl:otherwise>
                                        <xsl:value-of select="@TYPE"/>
                                </xsl:otherwise>
                        </xsl:choose>
                </xsl:variable>
                <xsl:variable name="width">
                        <xsl:choose>
                                <xsl:when test="@TYPE"/>
                                <xsl:when test="$current_article_type=5"/>
                                <xsl:otherwise>100%</xsl:otherwise>
                        </xsl:choose>
                </xsl:variable>
                <div class="{$row_colour}">
                        <table border="0" cellpadding="0" cellspacing="0" width="{$width}">
                                <tr>
                                        <xsl:choose>
                                                <xsl:when test="/H2G2/ARTICLE/ARTICLEINFO/PREPROCESSED=1">
                                                        <xsl:apply-templates select="*[not(self::BR)]"/>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                        <xsl:apply-templates/>
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
                                <xsl:when test="@TYPE='greenorangebox'"/>
                                <xsl:when test="@TYPE='greenorangeboxlarge'"/>
                                <xsl:when test="@TYPE='greenorangeboxfixed'"/>
                                <xsl:when test="@TYPE='greenbox'">greenbox</xsl:when>
                                <xsl:when test="@TYPE='orangebox'">orangebox</xsl:when>
                                <xsl:when test="@TYPE='greenboxa'">greenboxa</xsl:when>
                                <xsl:when test="@TYPE='greenboxb'">greenboxb</xsl:when>
                                <xsl:otherwise>
                                        <xsl:value-of select="@TYPE"/>
                                </xsl:otherwise>
                        </xsl:choose>
                </xsl:variable>
                <xsl:variable name="bridge_colour">
                        <xsl:choose>
                                <xsl:when test="@TYPE='greenboxa'">greenboxbridge</xsl:when>
                        </xsl:choose>
                </xsl:variable>
                <td class="{$column}" id="{$cell_colour}" valign="top">
                        <xsl:choose>
                                <!-- this is a bodge to accomodate the design!!  -->
                                <xsl:when test="contains(@TYPE, 'box') and @TYPE='greenorangebox' or @TYPE='greenorangeboxlarge' or @TYPE='greenorangeboxfixed'">
                                        <div class="greenorangetitle">
                                                <xsl:element name="{$text.subheading}" use-attribute-sets="text.subheading">
                                                        <strong>
                                                                <xsl:apply-templates select="HEADER/IMG"/>
                                                                <xsl:value-of select="HEADER"/>
                                                        </strong>
                                                </xsl:element>
                                        </div>
                                        <div id="{@TYPE}">
                                                <xsl:choose>
                                                        <xsl:when test="/H2G2/ARTICLE/ARTICLEINFO/PREPROCESSED=1">
                                                                <xsl:apply-templates select="*[not(self::BR)]"/>
                                                        </xsl:when>
                                                        <xsl:otherwise>
                                                                <xsl:apply-templates/>
                                                        </xsl:otherwise>
                                                </xsl:choose>
                                        </div>
                                </xsl:when>
                                <xsl:when test="@TYPE = 'ALSOLINKS'">
                                        <div class="generic-x">
                                                <div id="also-links">
                                                        <xsl:apply-templates/>
                                                </div>
                                        </div>
                                </xsl:when>
                                <xsl:when test="contains(/H2G2/@TYPE, 'FRONTPAGE')">
                                        <div class="generic-x">
                                                <xsl:apply-templates/>
                                        </div>
                                </xsl:when>
                                <xsl:when test="contains(@TYPE, 'box') or @WIDTH='large' or preceding-sibling::EDITORIAL-ITEM/@WIDTH='large' or child::COMMENT">
                                        <xsl:choose>
                                                <xsl:when test="/H2G2/ARTICLE/ARTICLEINFO/PREPROCESSED=1">
                                                        <xsl:apply-templates select="*[not(self::BR)]"/>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                        <xsl:apply-templates/>
                                                </xsl:otherwise>
                                        </xsl:choose>
                                </xsl:when>
                                <xsl:otherwise>
                                        <div class="generic-x">
                                                <xsl:if test="@TYPE">
                                                        <xsl:attribute name="class">
                                                                <xsl:value-of select="@TYPE"/>
                                                        </xsl:attribute>
                                                </xsl:if>
                                                <xsl:choose>
                                                        <xsl:when test="/H2G2/ARTICLE/ARTICLEINFO/PREPROCESSED=1">
                                                                <xsl:apply-templates select="*[not(self::BR)]"/>
                                                        </xsl:when>
                                                        <xsl:otherwise>
                                                                <xsl:apply-templates/>
                                                        </xsl:otherwise>
                                                </xsl:choose>
                                        </div>
                                </xsl:otherwise>
                        </xsl:choose>
                </td>
        </xsl:template>
</xsl:stylesheet>
