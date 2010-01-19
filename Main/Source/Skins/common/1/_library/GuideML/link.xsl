<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">
    
    <doc:documentation>
        <doc:purpose>
            Coverts link nodes to HTML anchors
        </doc:purpose>
        <doc:context>
            Applied by _common/_library/GuideML.xsl
        </doc:context>
        <doc:notes>
            HREF attribute denotes an external link
            BIO attribute denotes a DNA User Id link
            H2G2 attribute denotes an internal DNA link
        </doc:notes>
    </doc:documentation>
    
    <xsl:template match="LINK" mode="library_GuideML">
        <a>
            <xsl:attribute name="href">
                <xsl:choose>
                    <xsl:when test="@HREF">
                        <xsl:value-of select="@HREF"/>  
                    </xsl:when>
                    <xsl:when test="@BIO">
                        <xsl:value-of select="@BIO"/>  
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="@H2G2"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            <xsl:if test="@TITLE">
                <xsl:attribute name="title"><xsl:value-of select="@TITLE"/></xsl:attribute>                
            </xsl:if>
        	<xsl:choose>
        		<xsl:when test="not(*) and string-length(.) &gt; 23">
        			<xsl:choose>
        				<xsl:when test="starts-with(., 'http://')">
        					<xsl:value-of select="concat(substring(substring(., 8), 1, 20), '...')"/>
        				</xsl:when>
        				<xsl:otherwise>
        					<xsl:value-of select="concat(substring(., 0, 20), '...')"/>
        				</xsl:otherwise>
        			</xsl:choose>
        		</xsl:when>
        		<xsl:otherwise>
        			<xsl:apply-templates mode="library_GuideML"/>
        		</xsl:otherwise>
        	</xsl:choose>
        </a>
    </xsl:template>
	
	<xsl:template match="LINK" mode="library_GuideML_rss">
		<xsl:apply-templates mode="library_GuideML_rss"/>
		<xsl:text> (</xsl:text>
		<xsl:choose>
			<xsl:when test="@HREF">
				<xsl:value-of select="@HREF"/>  
			</xsl:when>
			<xsl:when test="@BIO">
				<xsl:value-of select="@BIO"/>  
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="@H2G2"/>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:text>) </xsl:text>
	</xsl:template>
	
</xsl:stylesheet>