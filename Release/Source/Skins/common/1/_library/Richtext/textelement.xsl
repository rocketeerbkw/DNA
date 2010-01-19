<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	version="1.0" 
	xmlns:doc="http://www.bbc.co.uk/dna/documentation"  
	exclude-result-prefixes="doc">
    
    <doc:documentation>
        <doc:purpose>
            Capture all XML text nodes and outputs plain text.
        </doc:purpose>
        <doc:context>
            Applied by _common/_library/GuideML.xsl
        </doc:context>
        <doc:notes>
            This is the last point of the GuideML fomatting chain. It acts as
            a catch all for the text, meaning the GuideML transforms should be
            completely recursive. 
        </doc:notes>
    </doc:documentation>
    
    <xsl:template match="text()" mode="library_Richtext">
        <xsl:param name="escapeapostrophe"/>
        
        <xsl:choose>
            <xsl:when test="$escapeapostrophe">
                <xsl:call-template name="library_string_escapeapostrophe">
                    <xsl:with-param name="str">
                        <xsl:value-of select="."/>
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="."/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>