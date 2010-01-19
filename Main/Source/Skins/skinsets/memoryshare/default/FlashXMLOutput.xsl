<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
    <!--
        Produces simplified xml for use by flash clients
    -->
	<xsl:include href="flashxml_articlesearch.xsl"/>	

    <xsl:template match="H2G2[key('xmltype', 'flash')]">
		<xsl:variable name="flash_astotal">
			<xsl:choose>
				<xsl:when test="/H2G2/ARTICLESEARCH/@COUNT &lt; /H2G2/ARTICLESEARCH/@SHOW">
					<xsl:value-of select="count(/H2G2/ARTICLESEARCH/ARTICLES/ARTICLE[DATERANGESTART/DATE])"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="/H2G2/ARTICLESEARCH/@TOTAL"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

        <H2G2>
			<xsl:choose>
				<xsl:when test="/H2G2/@TYPE='ARTICLESEARCH'">
					<xsl:attribute name="total"><xsl:value-of select="$flash_astotal"/></xsl:attribute>
					<xsl:attribute name="show"><xsl:value-of select="/H2G2/ARTICLESEARCH/@COUNT"/></xsl:attribute>
					<xsl:attribute name="skip"><xsl:value-of select="/H2G2/ARTICLESEARCH/@SKIPTO"/></xsl:attribute>
				</xsl:when>
			</xsl:choose>
            <xsl:call-template name="type-check">
                <xsl:with-param name="content">FLASHXML</xsl:with-param>
            </xsl:call-template>
        </H2G2>
    </xsl:template>
</xsl:stylesheet>
