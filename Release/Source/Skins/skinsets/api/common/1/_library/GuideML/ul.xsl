<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">
    
    <doc:documentation>
        <doc:purpose>
            Coverts UL nodes to HTML unsorted lists
        </doc:purpose>
        <doc:context>
            Applied by _common/_library/GuideML.xsl
        </doc:context>
        <doc:notes>
            
        </doc:notes>
    </doc:documentation>
    
    <xsl:template match="UL | ul" mode="library_GuideML">
        <ul>
			<xsl:if test="@TYPE | @type">
				<xsl:attribute name="type">
					<xsl:value-of select="@TYPE | @type"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates  mode="library_GuideML"/>
        </ul>
    </xsl:template>
</xsl:stylesheet>