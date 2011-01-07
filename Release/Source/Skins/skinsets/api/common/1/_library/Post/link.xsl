<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">
    
    <doc:documentation>
        <doc:purpose>
            Coverts link nodes to HTML anchors
        </doc:purpose>
        <doc:context>
            Applied by _common/_library/Post.xsl
        </doc:context>
        <doc:notes>
            HREF attribute denotes an external link
            BIO attribute denotes a DNA User Id link
            H2G2 attribute denotes an internal DNA link
        </doc:notes>
    </doc:documentation>

	<xsl:template match="LINK | link" mode="library_Post">
        <a>
            <xsl:attribute name="href">
				<xsl:choose>
					<xsl:when test="@HREF | @href">
						<xsl:value-of select="@HREF | @href"/>
					</xsl:when>
					<xsl:when test="@BIO | @bio">
						<xsl:value-of select="$aerian-base-user"/>
						<xsl:value-of select="@BIO | @bio"/>
					</xsl:when>
					<xsl:when test="@H2G2 | @h2g2 | @H2g2">
						<xsl:value-of select="$aerian-base-entry"/>
						<xsl:value-of select="@H2G2 | @h2g2 | @H2g2"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$aerian-base-entry"/>
						<xsl:value-of select="@h2g2"/>
					</xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
			<xsl:if test="@TITLE | @title">
				<xsl:attribute name="title">
					<xsl:value-of select="@TITLE | @title"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:attribute name="class">
				<xsl:choose>
					<xsl:when test="@CLASS | @class">
						<xsl:value-of select="@CLASS | @class"/>
					</xsl:when>
					<xsl:otherwise>pos</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:attribute name="target">
				<xsl:choose>
					<xsl:when test="@TARGET | @target">
						<xsl:value-of select="@TARGET | @target"/>
					</xsl:when>
					<xsl:otherwise>_top</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:choose>
				<xsl:when test="string-length(.) = 0">
					<xsl:choose>
						<xsl:when test="@HREF | @href">
							<xsl:value-of select="@HREF | @href"/>
						</xsl:when>
						<xsl:when test="@BIO | @bio">
							<xsl:value-of select="@BIO | @bio"/>
						</xsl:when>
						<xsl:when test="@H2G2 | @h2g2 | @H2g2">
							<xsl:value-of select="@H2G2 | @h2g2 | @H2g2"/>
						</xsl:when>
						<xsl:otherwise>&#160;</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates mode="library_Post"/>
				</xsl:otherwise>
			</xsl:choose>
			<!--        	<xsl:choose>
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
			-->
        </a>
    </xsl:template>
	
</xsl:stylesheet>