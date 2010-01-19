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
    
    <xsl:template match="A | a" mode="library_Richtext">
        <xsl:param name="escapeapostrophe"/>
        <a>
            <xsl:if test="@HREF | @href">
                <xsl:attribute name="href">
                        
                        <xsl:call-template name="library_string_searchandreplace">
                            <xsl:with-param name="str">
                                <xsl:if test="not(starts-with((@HREF | @href), 'http://')) and not(starts-with((@HREF | @href), 'https://'))">
                                    <xsl:text>http://</xsl:text>
                                </xsl:if>
                                <xsl:value-of select="@HREF | @href"/>
                            </xsl:with-param>
                            <xsl:with-param name="search" select="'javascript:'" />
                            <xsl:with-param name="replace" select="''" />
                        </xsl:call-template>
                </xsl:attribute>
            </xsl:if>
            
            
               
            
            <xsl:apply-templates mode="library_Richtext">
                <xsl:with-param name="escapeapostrophe" select="$escapeapostrophe"/>
            </xsl:apply-templates>
        </a>
    </xsl:template>
</xsl:stylesheet>