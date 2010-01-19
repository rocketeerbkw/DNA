<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
	xmlns="http://www.w3.org/1999/xhtml" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	version="1.0" 
	xmlns:doc="http://www.bbc.co.uk/dna/documentation"  
	exclude-result-prefixes="doc">
    
    <doc:documentation>
        <doc:purpose>
            Generates a username in an anchor pointing to their profile page
        </doc:purpose>
        <doc:context>
            Applied by _common/_library/itemdetail.xsl
        </doc:context>
        <doc:notes>
            
        </doc:notes>
    </doc:documentation>
    
    <xsl:template match="USER" mode="object_user_linked">
        
        <a href="U{USERID}" class="user linked">
           <xsl:value-of select="USERNAME"/>  
        </a>
        
    </xsl:template>
</xsl:stylesheet>