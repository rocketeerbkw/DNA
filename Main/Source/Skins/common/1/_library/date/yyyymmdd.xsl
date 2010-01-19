<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"  xmlns:doc="http://www.bbc.co.uk/dna/documentation" xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="doc msxsl">

    <doc:documentation>
        <doc:purpose>
            Convert DATE node to human readable, longer format
        </doc:purpose>
        <doc:context>
            Applied in multiple places
        </doc:context>
        <doc:notes>
            
            
        </doc:notes>
    </doc:documentation>
  
    
    <xsl:template match="DATE" mode="library_date_yyyymmdd">        
        <xsl:value-of select="LOCAL/@YEAR"/>
        <xsl:value-of select="format-number(LOCAL/@MONTH, '00')"/>
        <xsl:value-of select="format-number(LOCAL/@DAY, '00')"/>
    </xsl:template>
    
    
    
    
</xsl:stylesheet>