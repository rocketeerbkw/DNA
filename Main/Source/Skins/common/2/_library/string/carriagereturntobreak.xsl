<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">
    
    <doc:documentation>
        <doc:purpose>
            to change any carriage returns in data to break tags and replace
        </doc:purpose>
        <doc:context>
            Skin wide
        </doc:context>
        <doc:notes>
            To use simply select the text and apply e.g.
            
        </doc:notes>
    </doc:documentation>

	<xsl:template name="cr-to-br">
	    <xsl:param name="text"/>
    
	    <xsl:choose>
	        <xsl:when test="contains($text, '&#xa;')">
	            <xsl:value-of select="substring-before($text, '&#xa;')"/><br />
	            <xsl:call-template name="cr-to-br">
	                <xsl:with-param name="text" select="substring-after($text, '&#xa;')"/>
	            </xsl:call-template>
	        </xsl:when>
	        <xsl:otherwise>
	            <xsl:value-of select="$text"/>
	        </xsl:otherwise>
	    </xsl:choose>
	</xsl:template>
   
</xsl:stylesheet>