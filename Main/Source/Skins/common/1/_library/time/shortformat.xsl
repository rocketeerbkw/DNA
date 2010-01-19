<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:doc="http://www.bbc.co.uk/dna/documentation" exclude-result-prefixes="doc msxsl">

    <doc:documentation>
        <doc:purpose>
            Convert DATE node to human readable, longer format
        </doc:purpose>
        <doc:context>
            Applied in multiple places
        </doc:context>
        <doc:notes>
            
            #
            # At 02:51 PM on 21 Dec 2007
        </doc:notes>
    </doc:documentation>
    
    <xsl:template match="DATE" mode="library_time_shortformat">
        <xsl:param name="text" />
            
            <xsl:value-of select="text"/>
            <xsl:apply-templates select="LOCAL/@HOURS" mode="library_time_12hour" />
            <xsl:text>:</xsl:text>
            <xsl:value-of select="LOCAL/@MINUTES"/>            
            <xsl:apply-templates select="LOCAL/@HOURS" mode="library_time_ampm"/>
    </xsl:template>
 
</xsl:stylesheet>