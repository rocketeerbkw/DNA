<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">
    
    <doc:documentation>
        <doc:purpose>
            Passes DATECREATED nodes to library_date_longformat
        </doc:purpose>
        <doc:context>
            Applied by _common/_library/itemdetail.xsl
        </doc:context>
        <doc:notes>
            Should be improved to include an xsl-param for specifying the 'Created on' text.
        </doc:notes>
    </doc:documentation>
    
    <xsl:template match="DATECREATED" mode="library_itemdetail">
        <span class="dna-invisible">
            on 
        </span>
        <xsl:apply-templates select="DATE" mode="library_date_longformat">
            <xsl:with-param name="label"></xsl:with-param>
        </xsl:apply-templates>
    </xsl:template>
</xsl:stylesheet>