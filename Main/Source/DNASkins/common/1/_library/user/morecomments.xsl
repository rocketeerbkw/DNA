<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">
    
    <doc:documentation>
        <doc:purpose>
            Generates a username in an anchor pointing to their profile page
        </doc:purpose>
        <doc:context>
            Applied by _common/_library/itemdetail.xsl
        </doc:context>
        <doc:notes>
            Passes responsibility onto site specific skin template object/user/linked
            
            I don't want to lock developers out of being able to do this, hence why
            it is being delegated.
        </doc:notes>
    </doc:documentation>
    
    <xsl:template match="USER" mode="library_user_morecomments">
        <xsl:param name="url" />
        <xsl:param name="additional-classnames" />
        
        <a>
            <xsl:attribute name="href">
                <xsl:choose>
                    <xsl:when test="$url != ''">
                        <xsl:value-of select="$url"/>
                        <xsl:text>?userid=</xsl:text>
                        <xsl:value-of select="USERID"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$root"/>
                        <xsl:text>/MC</xsl:text>
                        <xsl:value-of select="USERID"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            
            <xsl:if test="$additional-classnames">
                <xsl:attribute name="class">
                    <xsl:value-of select="$additional-classnames"/>
                </xsl:attribute>
            </xsl:if>
            
            <xsl:value-of select="USERNAME"/>
            <xsl:if test="/H2G2/SITE/SITEOPTIONS/SITEOPTION[NAME = 'IsMessageboard'] and /H2G2/SITE/SITEOPTIONS/SITEOPTION[NAME = 'IsMessageboard']/VALUE = 1">
              <xsl:text> (U</xsl:text><xsl:value-of select="USERID"/><xsl:text>)</xsl:text>
            </xsl:if>
        </a>
    </xsl:template>
</xsl:stylesheet>