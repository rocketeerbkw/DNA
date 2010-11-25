<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">
    
    <doc:documentation>
        <doc:purpose>
            Coverts FONT to font tag
        </doc:purpose>
        <doc:context>
            Applied by _common/_library/GuideML.xsl
        </doc:context>
        <doc:notes>
            
        </doc:notes>
    </doc:documentation>
    
    <xsl:template match="FONT | font" mode="library_GuideML">
		<font>
			<xsl:if test="@SIZE | @size">
				<xsl:attribute name="size">
					<xsl:value-of select="@SIZE | @size"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:if test="@FACE | @face">
				<xsl:attribute name="face">
					<xsl:value-of select="@FACE | @face"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:if test="@COLOR | @color">
				<xsl:attribute name="color">
					<xsl:value-of select="@COLOR | @color"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates mode="library_GuideML"/>
		</font>
	</xsl:template>
	
</xsl:stylesheet>