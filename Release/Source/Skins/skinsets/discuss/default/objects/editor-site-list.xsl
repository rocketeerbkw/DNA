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
    
    
    <xsl:template match="EDITOR-SITE-LIST" mode="object_editor-site-list">
        
        <select name="dnasiteid" id="dna-siteid">
            <xsl:apply-templates select="SITE-LIST/SITE" mode="object_site_option" >
                <xsl:sort select="SHORTNAME" data-type="text" order="ascending"/>
            </xsl:apply-templates>
        </select>
        
    </xsl:template>
    
</xsl:stylesheet>