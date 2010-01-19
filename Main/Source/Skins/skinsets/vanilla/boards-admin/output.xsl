<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation" exclude-result-prefixes="doc">
    
    <xsl:import href="../../boards/default/output.xsl"/>
    
    <doc:documentation>
        <doc:purpose>
            Kick off stylesheet called directly by DNA 
        </doc:purpose>
        <doc:context>
            n/a
        </doc:context>
        <doc:notes>
            Bridges the jump between the old skin architecture and the new.
        </doc:notes>
    </doc:documentation>
    
    
    <xsl:variable name="root">
        <xsl:choose>
            <xsl:when test="/H2G2/SITECONFIG/BOARDROOT/node()">
                <xsl:text>/dna/</xsl:text>
                <xsl:copy-of select="/H2G2/SITECONFIG/BOARDROOT/node()"/>
                <xsl:text>boards-admin/</xsl:text>
            </xsl:when>
            <xsl:otherwise/>
        </xsl:choose>
    </xsl:variable>
    
</xsl:stylesheet>