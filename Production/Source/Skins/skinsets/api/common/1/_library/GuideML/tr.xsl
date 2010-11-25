<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">
    
    <doc:documentation>
        <doc:purpose>
            Coverts TR nodes to HTML TR
        </doc:purpose>
        <doc:context>
            Applied by _common/_library/GuideML.xsl
        </doc:context>
        <doc:notes>
            
        </doc:notes>
    </doc:documentation>
    
    <xsl:template match="TR | tr" mode="library_GuideML">
        <tr>
			<xsl:if test="@ALIGN | @align">
				<xsl:attribute name="align">
					<xsl:value-of select="@ALIGN | @align"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:if test="@VALIGN | @valign">
				<xsl:attribute name="valign">
					<xsl:value-of select="@VALIGN | @valign"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates mode="library_GuideML"/>
        </tr>
    </xsl:template>
		
</xsl:stylesheet>