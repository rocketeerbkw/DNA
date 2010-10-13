<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">
    
    <doc:documentation>
        <doc:purpose>
            Handles USER node for itemdetail, uses library user template for HTML
        </doc:purpose>
        <doc:context>
            Applied by _common/_library/itemdetail.xsl
        </doc:context>
        <doc:notes>
            Should be improved to include an xsl-param for specifying the 'Posted by' text.
        </doc:notes>
    </doc:documentation>
    
    <xsl:template match="USER" mode="library_itemdetail">
        <span class="dna-inivisble">
            Posted by
        </span>
        <xsl:apply-templates select="." mode="library_user_linked"/>
    </xsl:template>
</xsl:stylesheet>