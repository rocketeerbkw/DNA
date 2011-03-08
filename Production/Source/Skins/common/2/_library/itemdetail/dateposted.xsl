<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">
    
    <doc:documentation>
        <doc:purpose>
            Passes DATEPOSTED nodes to library_date_longformat
        </doc:purpose>
        <doc:context>
            Applied by _common/_library/itemdetail.xsl
        </doc:context>
        <doc:notes>
            
        </doc:notes>
    </doc:documentation>
    
    <xsl:template match="DATEPOSTED" mode="library_itemdetail">
        <xsl:if test="parent::POST/@HIDDEN = 0 or parent::POST/@HIDDEN = ''">
	        <span><xsl:text> on </xsl:text></span>
	        <xsl:apply-templates select="DATE" mode="library_date_longformat">
	            <xsl:with-param name="longformat_label">Posted on </xsl:with-param>
	        </xsl:apply-templates>
        </xsl:if>
    </xsl:template>
</xsl:stylesheet>