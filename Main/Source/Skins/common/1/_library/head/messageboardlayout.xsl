<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">
    
    <doc:documentation>
        <doc:purpose>
            Creates text for the title of the document, commonly used in the HTML title element.
        </doc:purpose>
        <doc:context>
            Often applied in a kick-off file (e.g. /html.xsl, /rss.xsl)
        </doc:context>
        <doc:notes>
            
        </doc:notes>
    </doc:documentation>
    
    
    <!-- 
        
    -->
    <xsl:template match="PAGE-LAYOUT[LAYOUT = 2]" mode="head_messageboardlayout">
        <style>
            ul.topiclist {}
            ul.topiclist li { width: 306px; float:left; margin:0 14px 0 0;}
        </style>
    
    <!-- 
        some css in here for columns etc
    -->
        
        
    </xsl:template>
    
</xsl:stylesheet>