<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">
    
    <doc:documentation>
        <doc:purpose>
            Coverts TEXTAREA nodes to HTML text block
        </doc:purpose>
        <doc:context>
            Applied by _common/_library/GuideML.xsl
        </doc:context>
        <doc:notes>
            
        </doc:notes>
    </doc:documentation>
    
    <xsl:template match="TEXTAREA | textarea" mode="library_GuideML">
		<textarea>
			<xsl:if test="@NAME | @name">
				<xsl:attribute name="name">
					<xsl:value-of select="@NAME | @name"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:if test="@COLS | @cols">
				<xsl:attribute name="cols">
					<xsl:value-of select="@COLS | @cols"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:if test="@ROWS | @rows">
				<xsl:attribute name="rows">
					<xsl:value-of select="@ROWS | @rows"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:if test="@WRAP | @wrap">
				<xsl:attribute name="wrap">
					<xsl:value-of select="@WRAP | @wrap"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates select="text()" mode="library_GuideML"/>
		</textarea>
    </xsl:template>
</xsl:stylesheet>