<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
	xmlns="http://www.w3.org/1999/xhtml" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	version="1.0" 
	xmlns:doc="http://www.bbc.co.uk/dna/documentation"  
	exclude-result-prefixes="doc">
	
	<xsl:output omit-xml-declaration="yes"/>


    <doc:documentation>
        <doc:purpose>
            Page layout for server too busy page
        </doc:purpose>
        <doc:context>
            Applied by the kick off file  (e.g. /html.xsl, /rss.xsl etc)
        </doc:context>
        <doc:notes>
            Does not show anything - this message should be handled by dna.commentbox.maitenanceMode SSSI variable
        </doc:notes>
    </doc:documentation>
    
    <xsl:template match="/H2G2[@TYPE = 'SERVERTOOBUSY']" mode="page">        
 
    </xsl:template>
    
    

</xsl:stylesheet>