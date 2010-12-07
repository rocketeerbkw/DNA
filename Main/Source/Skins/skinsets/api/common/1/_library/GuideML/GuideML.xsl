<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">
    
    <doc:documentation>
        <doc:properties common="true" />
        <doc:purpose>
            Library function for user entered text blocks
        </doc:purpose>
        <doc:context>
            Called using:
            xsl:apply-templates select="TEXT" mode="library_GuideML"
        </doc:context>
        <doc:notes>
            Currently matches links, smileys, p's, headers and subheaders
            --NEEDS UPDATING
            
            this is basically the GuideML stuff and should be renamed to reflect that
            
        </doc:notes>
    </doc:documentation>
    
    <xsl:template match="TEXT | BODY | RICHPOST | PREVIEWBODY" mode="library_GuideML" >
        <xsl:apply-templates select="* | text()" mode="library_GuideML" />
    	<xsl:if test="descendant::FOOTNOTE">
    		<div class="footnotes">
    			<xsl:apply-templates select="descendant::FOOTNOTE" mode="library_footnotes"/>
    		</div>
    	</xsl:if>
    </xsl:template>
	
	<xsl:template match="TEXT | BODY | RICHPOST | PREVIEWBODY" mode="library_GuideML_rss" >
		<xsl:apply-templates select="* | text()" mode="library_GuideML_rss" />
	</xsl:template>
    
</xsl:stylesheet>