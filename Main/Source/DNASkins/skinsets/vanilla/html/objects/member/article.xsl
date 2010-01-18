<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
	xmlns="http://www.w3.org/1999/xhtml"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	version="1.0" 
	xmlns:doc="http://www.bbc.co.uk/dna/documentation"  
	exclude-result-prefixes="doc">
	
    <doc:documentation>
        <doc:purpose>
            Defines HTML for article link on the categories page
        </doc:purpose>
        <doc:context>
            Applied in objects/collections/members.xsl
        </doc:context>
        <doc:notes>
            
        </doc:notes>
    </doc:documentation>
    
    
    <xsl:template match="ARTICLEMEMBER" mode="object_member">
        
        <li class="article">
            <!-- Add the stripe class -->
            <xsl:call-template name="library_listitem_stripe"/>
            
            <a href="A{H2G2ID}">
                <xsl:value-of select="STRIPPEDNAME"/>
                <xsl:apply-templates select="LASTUPDATED/DATE" mode="library_date_longformat"/>
            </a>
        </li>
        
    </xsl:template>
</xsl:stylesheet>