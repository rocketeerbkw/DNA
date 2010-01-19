<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">
    
    <doc:documentation>
        <doc:purpose>
            List of sites that dna currently has knowledge of
        </doc:purpose>
        <doc:context>
            Use in admin pages
        </doc:context>
        <doc:notes>
            
        </doc:notes>
    </doc:documentation>
    
    
    <xsl:template match="SITE" mode="object_site_option">
        <option value="{@ID}">
            <xsl:if test="@ID = /H2G2/COMMENTFORUMLIST/@REQUESTEDSITEID">
                <xsl:attribute name="selected">
                    <xsl:text>selected</xsl:text>
                </xsl:attribute>
            </xsl:if>     
            <xsl:value-of select="SHORTNAME"/>
        </option>
    </xsl:template>
    
</xsl:stylesheet>