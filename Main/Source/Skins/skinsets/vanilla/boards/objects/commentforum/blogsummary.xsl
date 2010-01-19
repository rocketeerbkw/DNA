<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">
    
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
    
    
    <xsl:template match="COMMENTFORUM" mode="object_commentforum_blogsummary">
        <xsl:call-template name="library_ssi_escaped">
            <xsl:with-param name="statement">
                <xsl:text>#set var="dna.blogsummary.</xsl:text>
                <xsl:value-of select="@UID"/>
                <xsl:text>" value="</xsl:text>
                <xsl:value-of select="@FORUMPOSTCOUNT"/>
                <xsl:text>"</xsl:text>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>
</xsl:stylesheet> 