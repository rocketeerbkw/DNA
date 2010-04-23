<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"  xmlns:doc="http://www.bbc.co.uk/dna/documentation" exclude-result-prefixes="doc">

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
    
    <xsl:template match="@HOURS" mode="library_time_12hour">
        <xsl:choose>
            <xsl:when test=". > 12">
                <xsl:value-of select=". - 12"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="."/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
</xsl:stylesheet>