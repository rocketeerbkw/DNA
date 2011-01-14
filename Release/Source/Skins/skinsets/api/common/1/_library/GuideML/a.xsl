<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">
    
    <doc:documentation>
        <doc:purpose>
            Coverts A nodes to HTML anchor tags
        </doc:purpose>
        <doc:context>
            Applied by _common/_library/GuideML.xsl
        </doc:context>
        <doc:notes>
            
        </doc:notes>
    </doc:documentation>
    
    <xsl:template match="A | a" mode="library_GuideML">
        <a>
            <xsl:if test="@HREF | @href">
                <xsl:attribute name="href">                   
                    <xsl:call-template name="library_string_searchandreplace">
                        <xsl:with-param name="str">
                            <xsl:if test="not(starts-with((@HREF | @href), 'http://')) and not(starts-with((@HREF | @href), 'https://'))">
                                <xsl:text>http://</xsl:text>
                            </xsl:if>
                            <xsl:value-of select="@HREF | @href"/>
                        </xsl:with-param>
                        <xsl:with-param name="search" select="'javascript:'" />
                        <xsl:with-param name="replace" select="''" />
                    </xsl:call-template>
                </xsl:attribute>
            </xsl:if>
			<xsl:if test="@CLASS | @class">
				<xsl:attribute name="class">
					<xsl:value-of select="@CLASS | @class"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:if test="@TARGET | @target">
				<xsl:attribute name="target">
					<xsl:value-of select="@TARGET | @target"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:if test="@NAME | @name">
				<xsl:attribute name="name">
					<xsl:value-of select="@NAME | @name"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:choose>
				<xsl:when test="string-length(.) = 0">&#160;</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates mode="library_GuideML"/>
				</xsl:otherwise>
			</xsl:choose>
        </a>
    </xsl:template>
	
	<xsl:template match="A | a" mode="library_GuideML_rss">
		<xsl:apply-templates mode="library_GuideML_rss"/>
		<xsl:text> (</xsl:text>
		<xsl:if test="@HREF | @href">
			<xsl:call-template name="library_string_searchandreplace">
				<xsl:with-param name="str">
					<xsl:if test="not(starts-with((@HREF | @href), 'http://')) and not(starts-with((@HREF | @href), 'https://'))">
						<xsl:text>http://</xsl:text>
					</xsl:if>
					<xsl:value-of select="@HREF | @href"/>
				</xsl:with-param>
				<xsl:with-param name="search" select="'javascript:'" />
				<xsl:with-param name="replace" select="''" />
			</xsl:call-template>
		</xsl:if>
		<xsl:text>) </xsl:text>
	</xsl:template>
</xsl:stylesheet>