<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">
    
    <doc:documentation>
        <doc:purpose>
            Coverts MARQUEE to marquee tag
        </doc:purpose>
        <doc:context>
            Applied by _common/_library/GuideML.xsl
        </doc:context>
        <doc:notes>
            
        </doc:notes>
    </doc:documentation>
    
    <xsl:template match="MARQUEE | marquee" mode="library_GuideML">
		<marquee>
			<xsl:if test="@BEHAVIOR | @behavior">
				<xsl:attribute name="behavior">
					<xsl:value-of select="@BEHAVIOR | @behavior"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:if test="@SCROLLAMOUNT | @scrollamount">
				<xsl:attribute name="scrollamount">
					<xsl:value-of select="@SCROLLAMOUNT | @scrollamount"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:if test="@SCROLLDELAY | @scrolldelay">
				<xsl:attribute name="scrolldelay">
					<xsl:value-of select="@SCROLLDELAY | @scrolldelay"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:if test="@DIRECTION | @direction">
				<xsl:attribute name="direction">
					<xsl:value-of select="@DIRECTION | @direction"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:if test="@WIDTH | @width">
				<xsl:attribute name="width">
					<xsl:value-of select="@WIDTH | @width"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:if test="@HEIGHT | @height">
				<xsl:attribute name="height">
					<xsl:value-of select="@HEIGHT | @height"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates mode="library_GuideML"/>
		</marquee>
	</xsl:template>
	
</xsl:stylesheet>