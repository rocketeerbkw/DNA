<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
	<!ENTITY space "<xsl:text xmlns:xsl='http://www.w3.org/1999/XSL/Transform'> </xsl:text>">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<!--
	<xsl:template name="MONTHSUMMARY_HEADER">
	Author:		Andy Harris
	Context:      /H2G2
	Purpose:	 Creates the title for the page which sits in the html header
	-->
	<xsl:template name="MONTHSUMMARY_HEADER">
		<xsl:apply-templates mode="header" select=".">
			<xsl:with-param name="title">
				<xsl:value-of select="$m_pagetitlestart"/>
				<xsl:value-of select="$alt_MonthSummarySub"/>
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>
	<!--
	<xsl:template name="MONTHSUMMARY_SUBJECT">
	Author:		Andy Harris
	Context:      /H2G2
	Purpose:	 Creates the text for the subject
	-->
	<xsl:template name="MONTHSUMMARY_SUBJECT">
		<xsl:value-of select="$alt_MonthSummarySub"/>
	</xsl:template>
	<!--
	<xsl:template match="MONTHSUMMARY" mode="c_month">
	Author:		Andy Harris
	Context:      /H2G2
	Purpose:	 Calls the container for the MONTHSUMMARY object
	-->
	<xsl:template match="MONTHSUMMARY" mode="c_month">
		<xsl:apply-templates select="." mode="r_month"/>
	</xsl:template>
	<!--
	<xsl:template match="GUIDEENTRY" mode="c_month">
	Author:		Andy Harris
	Context:      /H2G2/MONTHSUMMARY
	Purpose:	 Calls the container for each GUIDEENTRY object
	-->
	<xsl:template match="GUIDEENTRY" mode="c_month">
		<xsl:apply-templates select="." mode="r_month"/>
	</xsl:template>
	<!--
	<xsl:template match="DATE" mode="c_month">
	Author:		Andy Harris
	Context:      /H2G2/MONTHSUMMARY/GUIDEENTRY/DATE
	Purpose:	 Creates the date for each day block of GUIDENTRYs
	-->
	<xsl:template match="DATE" mode="c_month">
		<xsl:if test="not(./@DAY = preceding::GUIDEENTRY[1]/DATE/@DAY)">
			<xsl:apply-templates select="." mode="r_month"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="DATE" mode="r_month">
	Author:		Andy Harris
	Context:      /H2G2/MONTHSUMMARY/GUIDEENTRY/DATE
	Purpose:	 Creates the DATE text
	-->
	<xsl:template match="DATE" mode="r_month">
		<xsl:value-of select="./@DAY"/>
		<xsl:text> </xsl:text>
		<xsl:value-of select="./@MONTHNAME"/>
		<xsl:text> </xsl:text>
		<xsl:value-of select="./@YEAR"/>
	</xsl:template>
	<!--
	<xsl:template match="SUBJECT" mode="c_month">
	Author:		Andy Harris
	Context:      /H2G2/MONTHSUMMARY/GUIDEENTRY/SUBJECT
	Purpose:	 Calls the container for the SUBJECT
	-->
	<xsl:template match="SUBJECT" mode="c_month">
		<xsl:apply-templates select="." mode="r_month"/>
	</xsl:template>
	<!--
	<xsl:template match="SUBJECT" mode="r_month">
	Author:		Andy Harris
	Context:      H2G2
	Purpose:	 Creates the SUBJECT link
	-->
	<xsl:template match="SUBJECT" mode="r_month">
		<a href="{$root}A{../@H2G2ID}" xsl:use-attribute-sets="mSUBJECT_r_month">
			<xsl:value-of select="."/>
		</a>
	</xsl:template>
</xsl:stylesheet>
