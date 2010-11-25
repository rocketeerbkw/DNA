<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">
    
    <doc:documentation>
        <doc:purpose>
            HTML format of smiley objects
        </doc:purpose>
        <doc:context>
            Applied by _common/_library/Post.xsl
        </doc:context>
        <doc:notes>
            For some reason the outputted html doesn't close the tag with a / to make it unary.
             - this was the xml output setting
            
        </doc:notes>
    </doc:documentation>
    
    <xsl:template match="SMILEY | smiley" mode="library_Post">
        <img alt="smiley - {@TYPE}" title="{@TYPE}">
			<xsl:attribute name="class">
				<xsl:text>smiley</xsl:text>
			</xsl:attribute>
			<xsl:attribute name="src">
                <xsl:value-of select="$configuration/assetPaths/smileys"/>
                <xsl:value-of select="@TYPE"/>
                <xsl:text>.gif</xsl:text>
            </xsl:attribute>
        </img>
    </xsl:template>
</xsl:stylesheet>