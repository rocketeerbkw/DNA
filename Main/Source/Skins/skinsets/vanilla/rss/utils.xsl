<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	version="1.0" 
	xmlns:doc="http://www.bbc.co.uk/dna/documentation"  
	exclude-result-prefixes="doc">

    <doc:documentation>
        <doc:purpose>
            Utilities file
        </doc:purpose>
        <doc:context>
            Used everywhere
        </doc:context>
        <doc:notes>
          Repository for all the utility-type instructions used in multiple places.
        </doc:notes>
    </doc:documentation>
    
    <xsl:template match="DATE" mode="utils">
      <xsl:if test="LOCAL">
        <xsl:value-of select="concat(substring(@DAYNAME, 1, 3), ' ', @DAY, ' ', substring(@MONTHNAME, 1, 3), ' ', @YEAR, ' ', @HOURS, ':', @MINUTES, ':', @SECONDS, ' GMT+1')"/>
      </xsl:if>
    </xsl:template>
    
</xsl:stylesheet>
