<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">
    
    <doc:documentation>
        <doc:purpose>
            Coverts BR nodes to HTML line breaks
        </doc:purpose>
        <doc:context>
            Applied by _common/_library/GuideML.xsl
        </doc:context>
        <doc:notes>
            Could be improved further to not create double BR elements in a row
            e.g self::*/preceding-sibling::* something something
        </doc:notes>
    </doc:documentation>
    
    <xsl:template match="BR | br" mode="library_GuideML">
		<!--		
		<xsl:if test="preceding-sibling::*[1][local-name()='BR']">
			<xsl:if test="not(parent::*[1][local-name()='UL'])">
				<xsl:if test="not(position()=1)">-->
					<br/>
<!--				</xsl:if>
			</xsl:if>
		</xsl:if>-->
    </xsl:template>
	
	<xsl:template match="BR | br" mode="library_GuideML_rss">
		<xsl:text>		
		</xsl:text>
	</xsl:template>
	
</xsl:stylesheet>