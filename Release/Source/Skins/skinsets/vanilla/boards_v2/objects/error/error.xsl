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
    
    
    <xsl:template match="ERROR" mode="object_error">
        <xsl:choose>
        	<xsl:when test="/H2G2/@TYPE != 'SEARCHTHREADPOSTS'">
		       	<div class="error">
		            <h4>There has been a problem</h4>
		            <xsl:apply-templates select="ERRORMESSAGE" mode="object_error_errormessage" />
		        </div>
		   </xsl:when>
		   <xsl:otherwise><xsl:apply-templates select="ERRORMESSAGE" mode="object_error_errormessage" /></xsl:otherwise>
        
        </xsl:choose>
        
    </xsl:template>
    
    <xsl:template match="ERROR[@TYPE = 'XmlParseError']" mode="object_error">
        <div class="error">
            <h4>There has been a problem...</h4>
            <p>Your comment contains some HTML that has been mistyped.</p>
            <xsl:apply-templates select="ERRORMESSAGE" mode="object_error_errormessage" />
            
        </div>
    </xsl:template>
    
</xsl:stylesheet>