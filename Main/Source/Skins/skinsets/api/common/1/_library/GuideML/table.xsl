<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">
    
    <doc:documentation>
        <doc:purpose>
            Coverts TABLE nodes to HTML table
        </doc:purpose>
        <doc:context>
            Applied by _common/_library/GuideML.xsl
        </doc:context>
        <doc:notes>
            
        </doc:notes>
    </doc:documentation>
    
    <xsl:template match="TABLE" mode="library_GuideML">
        <table>
			<xsl:if test="@BORDER=1">
				<xsl:attribute name="class">border1</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates mode="library_GuideML"/>
        </table>
    </xsl:template>
		
</xsl:stylesheet>