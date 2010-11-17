<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:doc="http://www.bbc.co.uk/dna/documentation" exclude-result-prefixes="doc msxsl">

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
    
    <xsl:template match="DATE" mode="library_date_longformat">
        <xsl:param name="label" />
        <xsl:param name="additional-classnames" />
        <span>
            <xsl:attribute name="class">
                <xsl:text>date longformat</xsl:text>
                <xsl:text> </xsl:text>
                <xsl:value-of select="$additional-classnames"/>
            </xsl:attribute>
            
            <xsl:value-of select="$label"/>
            
            <xsl:value-of select="LOCAL/@DAYNAME"/>
            <xsl:text>, </xsl:text>
            <xsl:apply-templates select="LOCAL/@DAY" mode="library_date_daysuffix"/>
            <xsl:text> </xsl:text>    
            <xsl:value-of select="LOCAL/@MONTHNAME"/>
            <xsl:text> </xsl:text>
            <xsl:value-of select="LOCAL/@YEAR"/>
        	<xsl:if test="contains(@RELATIVE, 'Minutes') or contains(@RELATIVE, 'Hours') or contains(@RELATIVE, 'Just Now')">
        		<span class="ago"><xsl:text> (</xsl:text>
        		<xsl:value-of select="@RELATIVE"/>
        		<xsl:text>)</xsl:text></span>
        	</xsl:if>
        </span>
    </xsl:template>
    
    <!--
    <xsl:template match="DATE[/H2G2/SITECONFIG/BSTTIMEFIX = 1]" mode="library_date_longformat">
        <xsl:param name="label"/>
        
        <xsl:variable name="node">
            <xsl:apply-templates select="." mode="library_date_converttobst" />
        </xsl:variable>
        
        <xsl:apply-templates select="msxsl:node-set($node)/DATE" mode="library_date_longformat" >
            <xsl:with-param name="label" select="$label"/>
        </xsl:apply-templates>
    </xsl:template>
    -->
    
</xsl:stylesheet>