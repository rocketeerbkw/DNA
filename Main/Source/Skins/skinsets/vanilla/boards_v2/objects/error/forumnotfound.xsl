<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">
    
    <doc:documentation>
        <doc:purpose>
            Transforms a collection of posts to HTML 
        </doc:purpose>
        <doc:context>
            Used by a MULTIPOSTS page
        </doc:context>
        <doc:notes>
            
        </doc:notes>
    </doc:documentation>
    
    
    <xsl:template match="ERROR" mode="objects_error_forumnotfound">
	    <h2>There has been a problem...</h2>
	    <div class="servertoobusy"> 
	   		<p>An error has occurred with your request. <xsl:value-of select="ERRORMESSAGE"/>. </p>
	    </div>
	    
	      
    </xsl:template>
    
</xsl:stylesheet>