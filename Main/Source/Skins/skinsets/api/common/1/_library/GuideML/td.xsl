<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">
    
    <doc:documentation>
        <doc:purpose>
            Coverts TD nodes to HTML TD
        </doc:purpose>
        <doc:context>
            Applied by _common/_library/GuideML.xsl
        </doc:context>
        <doc:notes>
            
        </doc:notes>
    </doc:documentation>
    
    <xsl:template match="TD | td" mode="library_GuideML">
        <td>
			<xsl:if test="@STYLE | @style">
				<xsl:attribute name="style">
					<xsl:value-of select="@STYLE | @style"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:if test="@BGCOLOR | @bgcolor">
				<xsl:attribute name="bgcolor">
					<xsl:value-of select="@BGCOLOR | @bgcolor"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:if test="@WIDTH | @width">
				<xsl:attribute name="width">
					<xsl:value-of select="@WIDTH | @width"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:if test="@HEIGHT | @height">
				<xsl:attribute name="height">
					<xsl:value-of select="@HEIGHT | @height"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates mode="library_GuideML"/>
        </td>
    </xsl:template>
		
</xsl:stylesheet>