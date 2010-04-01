<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<!--
	<xsl:template name="MOREPAGES_HEADER">
	Author:		Andy Harris
	Context:      H2G2
	Purpose:	 Creates the title for the page which sits in the html header
	-->
	<xsl:template name="MOREPAGES_HEADER">
		<xsl:apply-templates mode="header" select=".">
			<xsl:with-param name="title">
				<xsl:value-of select="$m_pagetitlestart"/>
				<xsl:value-of select="$m_morepagestitle"/>
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>
	<!--
	<xsl:template name="MOREPAGES_SUBJECT">
	Author:		Andy Harris
	Context:      H2G2
	Purpose:	 Creates the text for the subject
	-->
	<xsl:template name="MOREPAGES_SUBJECT">
		<xsl:call-template name="SUBJECTHEADER">
			<xsl:with-param name="text">
				<xsl:choose>
					<xsl:when test="ARTICLES[@WHICHSET=1]">
						<xsl:value-of select="$m_editedentries"/>
					</xsl:when>
					<xsl:when test="ARTICLES[@WHICHSET=2]">
						<xsl:value-of select="$m_guideentries"/>
					</xsl:when>
					<xsl:when test="ARTICLES[@WHICHSET=3]">
						<xsl:value-of select="$m_cancelledentries"/>
					</xsl:when>
				</xsl:choose>
				<xsl:value-of select="$m_by"/>
				<xsl:apply-templates select="ARTICLES/USER" mode="username" />
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<!--
	<xsl:template match="ARTICLES/ARTICLE-LIST" mode="c_morearticlespage">
	Author:		Andy Harris
	Context:      /H2G2/ARTICLES/ARTICLE-LIST
	Purpose:	 Calls the container for the ARTICLE-LIST object
	-->
	<xsl:template match="ARTICLES/ARTICLE-LIST" mode="c_morearticlespage">
		<xsl:apply-templates select="." mode="r_morearticlespage"/>
	</xsl:template>
	<!--
	<xsl:template match="ARTICLE" mode="c_morearticlespage">
	Author:		Andy Harris
	Context:      /H2G2/ARTICLES/ARTICLE-LIST/ARTICLE
	Purpose:	 Calls the container for the ARTICLE object
	-->
	<xsl:template match="ARTICLE" mode="c_morearticlespage">
		<xsl:if test="not(EXTRAINFO/TYPE/@ID = 1001)">
		<xsl:apply-templates select="." mode="r_morearticlespage"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="H2G2-ID" mode="t_morearticlespage">
	Author:		Andy Harris
	Context:      /H2G2/ARTICLES/ARTICLE-LIST/ARTICLE/H2G2-ID
	Purpose:	 Creates the link to the ARTICLE page using the H2G2-ID
	-->
	<xsl:template match="H2G2-ID" mode="t_morearticlespage">
		<a href="{$root}A{.}" xsl:use-attribute-sets="mH2G2-ID_t_morearticlespage">
			<xsl:value-of select="."/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="SUBJECT" mode="t_morearticlespage">
	Author:		Andy Harris
	Context:      /H2G2/ARTICLES/ARTICLE-LIST/ARTICLE/SUBJECT
	Purpose:	 Creates the link to the ARTICLE page using the SUBJECT
	-->
	<xsl:template match="SUBJECT" mode="t_morearticlespage">
		<a href="{$root}A{../H2G2-ID}" xsl:use-attribute-sets="mSUBJECT_t_morearticlespage">
			<xsl:choose>
				<xsl:when test="./text()">
					<xsl:value-of select="."/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:copy-of select="$m_subjectempty"/>
				</xsl:otherwise>
			</xsl:choose>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="SITEID" mode="t_morearticlespage">
	Author:		Andy Harris
	Context:      /H2G2/ARTICLES/ARTICLE-LIST/ARTICLE/SITEID
	Purpose:	 Creates the link to the originating site using the SITEID
	-->
	<xsl:template match="SITEID" mode="t_morearticlespage">
		<a href="{concat(substring-before($root, $sitename), ../../../../SITE-LIST/SITE[@ID=current()]/NAME, '/')}" xsl:use-attribute-sets="mSITEID_t_morearticlespage">
			<xsl:value-of select="../../../../SITE-LIST/SITE[@ID=current()]/SHORTNAME"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="DATE-CREATED" mode="t_morearticlespage">
	Author:		Andy Harris
	Context:      /H2G2/ARTICLES/ARTICLE-LIST/ARTICLE/DATECREATED
	Purpose:	 Creates the DATE text
	-->
	<xsl:template match="DATE-CREATED" mode="t_morearticlespage">
		<xsl:apply-templates select="DATE"/>
	</xsl:template>
	<!--
	<xsl:template match="ARTICLES" mode="c_previouspages">
	Author:		Andy Harris
	Context:      /H2G2/ARTICLES
	Purpose:	 Calls the container for the 'previous pages' link if it is needed
	-->
	<xsl:template match="ARTICLES" mode="c_previouspages">
		<xsl:if test="ARTICLE-LIST[@SKIPTO &gt; 0]">
			<xsl:apply-templates select="." mode="r_previouspages"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="ARTICLES" mode="r_previouspages">
	Author:		Andy Harris
	Context:      /H2G2/ARTICLES
	Purpose:	 Creates the 'previous pages' link
	-->
	<xsl:template match="ARTICLES" mode="r_previouspages">
		<a xsl:use-attribute-sets="mARTICLES_r_previouspages">
			<xsl:attribute name="HREF"><xsl:value-of select="$root"/>MA<xsl:value-of select="@USERID"/>?show=<xsl:value-of select="ARTICLE-LIST/@COUNT"/>&amp;skip=<xsl:value-of select="number(ARTICLE-LIST/@SKIPTO) - number(ARTICLE-LIST/@COUNT)"/>&amp;type=<xsl:value-of select="@WHICHSET"/></xsl:attribute>
			<xsl:copy-of select="$m_newerentries"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="ARTICLES" mode="c_morepages">
	Author:		Andy Harris
	Context:      /H2G2/ARTICLES
	Purpose:	 Calls the container for the 'next pages' link if it is needed
	-->
	<xsl:template match="ARTICLES" mode="c_morepages">
		<xsl:if test="ARTICLE-LIST[@MORE=1]">
			<xsl:apply-templates select="." mode="r_morepages"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="ARTICLES" mode="r_morepages">
	Author:		Andy Harris
	Context:      /H2G2/ARTICLES
	Purpose:	 Creates the 'next pages' link
	-->
	<xsl:template match="ARTICLES" mode="r_morepages">
		<a xsl:use-attribute-sets="mARTICLES_r_morepages">
			<xsl:attribute name="HREF"><xsl:value-of select="$root"/>MA<xsl:value-of select="@USERID"/>?show=<xsl:value-of select="ARTICLE-LIST/@COUNT"/>&amp;skip=<xsl:value-of select="number(ARTICLE-LIST/@SKIPTO) + number(ARTICLE-LIST/@COUNT)"/>&amp;type=<xsl:value-of select="@WHICHSET"/></xsl:attribute>
			<xsl:copy-of select="$m_olderentries"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="ARTICLES" mode="t_backtouserpage">
	Author:		Andy Harris
	Context:      /H2G2/ARTICLES
	Purpose:	 Creates the 'back to the userpage' link
	-->
	<xsl:template match="ARTICLES" mode="t_backtouserpage">
		<a href="{$root}U@USERID" xsl:use-attribute-sets="mARTICLES_t_backtouserpage">
			<xsl:copy-of select="$m_FromMAToPSText"/>
		</a>
	</xsl:template>
	<!--
	<xsl:variable name="m_FromMAToPSText">
	Author:		Andy Harris
	Context:      none
	Purpose:	 Creates the 'back to the userpage' text
	-->
	<xsl:variable name="m_FromMAToPSText">
		<xsl:copy-of select="$m_MABackTo"/>
		<xsl:apply-templates select="/H2G2/PAGE-OWNER/USER" mode="username" />
		<xsl:copy-of select="$m_MAPSpace"/>
	</xsl:variable>
	<!--
	<xsl:template match="ARTICLES" mode="t_showeditedlink">
	Author:		Andy Harris
	Context:      /H2G2/ARTICLES
	Purpose:	 Creates the 'show edited entries' link
	-->
	<xsl:template match="ARTICLES" mode="t_showeditedlink">
		<a xsl:use-attribute-sets="mARTICLES_t_showeditedlink">
			<xsl:attribute name="HREF"><xsl:value-of select="$root"/>MA<xsl:value-of select="@USERID"/>?show=<xsl:value-of select="ARTICLE-LIST/@COUNT"/>&amp;type=1</xsl:attribute>
			<xsl:copy-of select="$m_showeditedentries"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="ARTICLES" mode="t_shownoneditedlink">
	Author:		Andy Harris
	Context:      /H2G2/ARTICLES
	Purpose:	 Creates the 'show non-edited entries' link
	-->
	<xsl:template match="ARTICLES" mode="t_shownoneditedlink">
		<a xsl:use-attribute-sets="mARTICLES_t_shownoneditedlink">
			<xsl:attribute name="HREF"><xsl:value-of select="$root"/>MA<xsl:value-of select="@USERID"/>?show=<xsl:value-of select="ARTICLE-LIST/@COUNT"/>&amp;type=2</xsl:attribute>
			<xsl:copy-of select="$m_showguideentries"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="ARTICLES" mode="c_showcancelledlink">
	Author:		Andy Harris
	Context:      /H2G2/ARTICLES
	Purpose:	 Calls the 'show cancelled entries' link if the viewer is entitled to see it
	-->
	<xsl:template match="ARTICLES" mode="c_showcancelledlink">
		<xsl:if test="$test_MayShowCancelledEntries">
			<xsl:apply-templates select="." mode="r_showcancelledlink"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="ARTICLES" mode="r_showcancelledlink">
	Author:		Andy Harris
	Context:      /H2G2/ARTICLES
	Purpose:	 Creates the 'show cancelled entries' link
	-->
	<xsl:template match="ARTICLES" mode="r_showcancelledlink">
		<a xsl:use-attribute-sets="mARTICLES_r_showcancelledlink">
			<xsl:attribute name="HREF"><xsl:value-of select="$root"/>MA<xsl:value-of select="@USERID"/>?show=<xsl:value-of select="ARTICLE-LIST/@COUNT"/>&amp;type=3</xsl:attribute>
			<xsl:copy-of select="$m_showcancelledentries"/>
		</a>
	</xsl:template>
</xsl:stylesheet>
