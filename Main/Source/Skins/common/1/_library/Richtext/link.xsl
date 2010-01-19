<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	version="1.0" 
	xmlns:doc="http://www.bbc.co.uk/dna/documentation"  
	exclude-result-prefixes="doc">
    
    <doc:documentation>
        <doc:purpose>
            Coverts link nodes to HTML anchors
        </doc:purpose>
        <doc:context>
            Applied by _common/_library/GuideML.xsl
        </doc:context>
        <doc:notes>
            HREF attribute denotes an external link
            BIO attribute denotes a DNA User Id link
            H2G2 attribute denotes an internal DNA link
        </doc:notes>
    </doc:documentation>
    
    <xsl:template match="LINK | link" mode="library_Richtext">
        <xsl:param name="escapeapostrophe"/>
        <a>
            <xsl:attribute name="href">
                
                <xsl:choose>
                    <xsl:when test="@HREF">
                        <xsl:value-of select="@HREF"/>  
                    </xsl:when>
                    <xsl:when test="@BIO">
                        <xsl:value-of select="@BIO"/>  
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="@H2G2"/>
                    </xsl:otherwise>
                </xsl:choose>
                
            </xsl:attribute>
            <xsl:apply-templates mode="library_Richtext">
                <xsl:with-param name="escapeapostrophe" select="$escapeapostrophe"/>
            </xsl:apply-templates>
        </a>
    </xsl:template>
</xsl:stylesheet>