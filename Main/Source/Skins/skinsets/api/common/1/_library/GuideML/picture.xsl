<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">
    
    <doc:documentation>
        <doc:purpose>
            Coverts PICTURE to image tag
        </doc:purpose>
        <doc:context>
            Applied by _common/_library/GuideML.xsl
        </doc:context>
        <doc:notes>
            
        </doc:notes>
    </doc:documentation>
	
	<xsl:template match="PICTURE" mode="library_GuideML">
    	<xsl:variable name="pictureTag">
    		<img src="{$blobs-root}{@H2G2IMG}" alt="{@ALT}" title="{@ALT}">
				<xsl:if test="@HEIGHT">
					<xsl:attribute name="height">
						<xsl:value-of select="@HEIGHT"/>
					</xsl:attribute>
				</xsl:if>
				<xsl:if test="@WIDTH">
					<xsl:attribute name="width">
						<xsl:value-of select="@WIDTH"/>
					</xsl:attribute>
				</xsl:if>
				<xsl:if test="@EMBED">
					<xsl:attribute name="class">
						<xsl:value-of select="@EMBED"/>
					</xsl:attribute>
				</xsl:if>
			</img>
    	</xsl:variable>

		<xsl:choose>
    		<xsl:when test="@BLOB and @BLOB != ''">
				<img src="{$blob-gif-root}{@BLOB}white.gif" alt="{@ALT}" title="{@ALT}">
					<xsl:if test="@HEIGHT">
						<xsl:attribute name="height">
							<xsl:value-of select="@HEIGHT"/>
						</xsl:attribute>
					</xsl:if>
					<xsl:if test="@WIDTH">
						<xsl:attribute name="width">
							<xsl:value-of select="@WIDTH"/>
						</xsl:attribute>
					</xsl:if>
					<xsl:if test="@EMBED">
						<xsl:attribute name="class">
							<xsl:value-of select="@EMBED"/>
						</xsl:attribute>
					</xsl:if>
				</img>
			</xsl:when>
    		<xsl:otherwise>
    			<xsl:copy-of select="$pictureTag"/>
    		</xsl:otherwise>
    	</xsl:choose>
		
    </xsl:template>
	
	<xsl:template match="PICTURE" mode="library_GuideML_rss">
		[<xsl:value-of select="concat($root, @H2G2IMG)"/>]
	</xsl:template>
	
</xsl:stylesheet>