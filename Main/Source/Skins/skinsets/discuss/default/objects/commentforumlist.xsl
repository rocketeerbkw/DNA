<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">
    
    <doc:documentation>
        <doc:purpose>
            HTML for a Commentforum list set
        </doc:purpose>
        <doc:context>
            
        </doc:context>
        <doc:notes>
            
        </doc:notes>
    </doc:documentation>
    
    
    <xsl:template match="COMMENTFORUMLIST" mode="object_commentforumlist">
        
        <div class="commentforumlist large-panel module">
            <h2>Comments</h2>
            
            <p>No comments have been created for the '<xsl:value-of select="/H2G2/EDITOR-SITE-LIST/SITE-LIST/SITE[@ID = current()/@REQUESTEDSITEID]/SHORTNAME"/>' site.</p>
        </div>
    </xsl:template>
    
    <xsl:template match="COMMENTFORUMLIST[COMMENTFORUM]" mode="object_commentforumlist">
        
        <div class="commentforumlist large-panel module">
            <h2>Comments</h2>
            
            <xsl:apply-templates select="." mode="library_pagination_commentforumlist" />
            
            <xsl:apply-templates select="COMMENTFORUM" mode="object_commentforum" >
                <xsl:sort select="LASTUPDATED/DATE/@SORT" order="descending"/>
            </xsl:apply-templates>
            
            <xsl:apply-templates select="." mode="library_pagination_commentforumlist" />
        </div>
    </xsl:template>
</xsl:stylesheet>