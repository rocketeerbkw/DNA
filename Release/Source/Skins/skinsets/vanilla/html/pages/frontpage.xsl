<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
	xmlns="http://www.w3.org/1999/xhtml" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	version="1.0" 
	xmlns:doc="http://www.bbc.co.uk/dna/documentation"  
	exclude-result-prefixes="doc">


    <doc:documentation>
        <doc:purpose>
            Page layout for a DNA front page
        </doc:purpose>
        <doc:context>
            Applied by the kick off file  (e.g. /html.xsl, /rss.xsl etc)
        </doc:context>
        <doc:notes>
            Used here to output the correct HTML for a BBC Homepage module
        </doc:notes>
    </doc:documentation>
    
    
    
    <xsl:template match="/H2G2[@TYPE = 'FRONTPAGE']" mode="page">
    	<xsl:apply-templates select="TOP-FIVES" mode="object_top-fives-frontpage" />
    	<xsl:apply-templates select="ARTICLE" mode="object_article_frontpage" />
    </xsl:template>

</xsl:stylesheet>