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
  
    
    <xsl:template match="DATE" mode="library_date_shortformat">
        <xsl:param name="text" />
        
        <xsl:value-of select="text"/>            
        <xsl:value-of select="format-number(LOCAL/@DAY, '00')"/>
        <xsl:text> </xsl:text>    
        <xsl:value-of select=" substring(LOCAL/@MONTHNAME, 1, 3)"/>
        <xsl:text> </xsl:text>
        <xsl:value-of select="LOCAL/@YEAR"/>
        
    </xsl:template>
    
    <!--
    <xsl:template match="DATE[/H2G2/SITECONFIG/BSTTIMEFIX = 1]" mode="library_date_shortformat">
        <xsl:param name="text"/>
        
        <xsl:variable name="node">
            <xsl:apply-templates select="." mode="library_date_converttobst" />
        </xsl:variable>
        
        <xsl:apply-templates select="msxsl:node-set($node)/DATE" mode="library_date_shortformat" >
            <xsl:with-param name="text" select="$text"/>
        </xsl:apply-templates>
    </xsl:template>
    -->
    
    
    
    
</xsl:stylesheet>