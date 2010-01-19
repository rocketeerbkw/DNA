<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">
    
    <doc:documentation>
        <doc:purpose>
            HTML for a full DNA article
        </doc:purpose>
        <doc:context>
            Applied by logic layer (common/logic/objects/article.xsl)
        </doc:context>
        <doc:notes>
            
        </doc:notes>
    </doc:documentation>
    
    <xsl:template match="COMMENTFORUM" mode="object_commentforum_quicklist">
        <li>
            <xsl:call-template name="library_listitem_stripe" />
            <a href="#{@UID}">
                <xsl:value-of select="TITLE"/>
                
            </a>
        </li>
    </xsl:template>
</xsl:stylesheet>