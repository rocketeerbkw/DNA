<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">

    <doc:documentation>
        <doc:purpose>
            HTML representation of user node set
        </doc:purpose>
        <doc:context>
            Used inline other objects / block elements
        </doc:context>
        <doc:notes>
            
        </doc:notes>
    </doc:documentation>
    
    <xsl:template match="ONLINEUSERS" mode="object_user_online">
    	<xsl:param name="username" />
    	
    	<xsl:if test="$username = ONLINEUSER/USER/USERNAME">
    		<span> ** </span>
    	</xsl:if>
    </xsl:template>
    
</xsl:stylesheet>