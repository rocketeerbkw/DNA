<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
	<!ENTITY space "<xsl:text xmlns:xsl='http://www.w3.org/1999/XSL/Transform'> </xsl:text>">
]>
<xsl:stylesheet exclude-result-prefixes="msxsl local s dt" version="1.0" xmlns:dt="urn:schemas-microsoft-com:datatypes"
        xmlns:local="#local-functions" xmlns:msxsl="urn:schemas-microsoft-com:xslt"
        xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
        <xsl:import href="../../../base/base-monthpage.xsl"/>
        <!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
									Page - Level  template
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
        <xsl:template name="MONTHSUMMARY_MAINBODY">
                <!-- DEBUG -->
                <xsl:call-template name="TRACE">
                        <xsl:with-param name="message">MONTHSUMMARY_MAINBODY test variable = <xsl:value-of
                                        select="$current_article_type"/></xsl:with-param>
                        <xsl:with-param name="pagename">monthpage.xsl</xsl:with-param>
                </xsl:call-template>
                <!-- DEBUG -->
                <table border="0" cellpadding="5" cellspacing="0" width="100%">
                        <tr>
                                <td valign="top">
                                        <xsl:call-template name="m_monthsummaryblurb"/>
                                        <xsl:apply-templates mode="c_month" select="MONTHSUMMARY"/>
                                </td>
                        </tr>
                </table>
        </xsl:template>
        <!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
							MONTH SUMMARY Object
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
        <!--
	<xsl:template match="MONTHSUMMARY" mode="r_month">
	Description: Presentation of the object holding the summary of articles
		added in the past month
	 -->
        <xsl:template match="MONTHSUMMARY" mode="r_month">
                <xsl:apply-templates mode="c_month" select="GUIDEENTRY"/>
        </xsl:template>
        <!--
	<xsl:template match="GUIDEENTRY" mode="r_month">
	Description: Presentation of each GUIDEENTRY in the month list
	 -->
        <xsl:template match="GUIDEENTRY" mode="r_month">
                <xsl:apply-templates mode="c_month" select="DATE"/>
                <xsl:apply-templates mode="c_month" select="SUBJECT"/>
        </xsl:template>
        <!--
	<xsl:template match="DATE" mode="r_month">
	Description: Presentation of the DATE at the top of each GUIDEENTRY
		block
	 -->
        <xsl:template match="DATE" mode="r_month">
                <br/>
                <b>
                        <xsl:apply-imports/>
                </b>
                <br/>
        </xsl:template>
        <!--
	<xsl:template match="SUBJECT" mode="r_month">
	Description: Presentation of the SUBJECT within the GUIDEENTRY
	 -->
        <xsl:template match="SUBJECT" mode="r_month">
                <xsl:apply-imports/>
                <br/>
        </xsl:template>
</xsl:stylesheet>
