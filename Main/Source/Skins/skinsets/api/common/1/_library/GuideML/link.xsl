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

	<xsl:template match="LINK | link" mode="library_GuideML">
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
						<xsl:choose>
							<xsl:when test="@H2G2='categories' or @h2g2='categories' or @H2g2='categories'">
								<xsl:value-of select="$aerian-base"/>
								<xsl:value-of select="@H2G2 | @h2g2 | @H2g2"/>
							</xsl:when>
							<xsl:when test="@H2G2='peer_review' or @h2g2='peer_review' or @H2g2='peer_review'">
								<xsl:value-of select="$aerian-base"/>
								<xsl:value-of select="@H2G2 | @h2g2 | @H2g2"/>
							</xsl:when>
							<xsl:when test="@H2G2='search' or @h2g2='search' or @H2g2='search'">
								<xsl:value-of select="$aerian-base"/>
								<xsl:value-of select="@H2G2 | @h2g2 | @H2g2"/>
							</xsl:when>
							<xsl:when test="@H2G2='coming_up' or @h2g2='coming_up' or @H2g2='coming_up'">
								<xsl:value-of select="$aerian-base"/>
								<xsl:value-of select="@H2G2 | @h2g2 | @H2g2"/>
							</xsl:when>
							<xsl:when test="@H2G2='info' or @h2g2='info' or @H2g2='info'">
								<xsl:value-of select="$aerian-base"/>
								<xsl:value-of select="@H2G2 | @h2g2 | @H2g2"/>
							</xsl:when>
							<xsl:when test="@H2G2='solo' or @h2g2='solo' or @H2g2='solo'">
								<xsl:value-of select="$aerian-base"/>
								<xsl:value-of select="@H2G2 | @h2g2 | @H2g2"/>
							</xsl:when>
							<xsl:when test="@H2G2='month' or @h2g2='month' or @H2g2='month'">
								<xsl:value-of select="$aerian-base"/>
								<xsl:value-of select="@H2G2 | @h2g2 | @H2g2"/>
							</xsl:when>
							<xsl:when test="@H2G2='scout_picks' or @h2g2='scout_picks' or @H2g2='scout_picks'">
								<xsl:value-of select="$aerian-base"/>
								<xsl:value-of select="@H2G2 | @h2g2 | @H2g2"/>
							</xsl:when>
							<xsl:when test="(starts-with(@H2G2,'A') and number(substring(@H2G2,2)) > 0) or (starts-with(@h2g2,'A') and number(substring(@h2g2,2)) > 0) or (starts-with(@H2g2,'A') and number(substring(@H2g2,2)) > 0)">
								<xsl:value-of select="$aerian-base-entry"/>
								<xsl:value-of select="@H2G2 | @h2g2 | @H2g2"/>
							</xsl:when>
							<xsl:when test="(starts-with(@H2G2,'U') and number(substring(@H2G2,2)) > 0) or (starts-with(@h2g2,'U') and number(substring(@h2g2,2)) > 0) or (starts-with(@H2g2,'U') and number(substring(@H2g2,2)) > 0)">
								<xsl:value-of select="$aerian-base-user"/>
								<xsl:value-of select="@H2G2 | @h2g2 | @H2g2"/>
							</xsl:when>
							<xsl:when test="(starts-with(@H2G2,'C') and number(substring(@H2G2,2)) > 0) or (starts-with(@h2g2,'C') and number(substring(@h2g2,2)) > 0) or (starts-with(@H2g2,'C') and number(substring(@H2g2,2)) > 0)">
								<xsl:value-of select="$aerian-base-categories"/>
								<xsl:value-of select="@H2G2 | @h2g2 | @H2g2"/>
							</xsl:when>
							<xsl:when test="starts-with(@H2G2,'&#35;') or starts-with(@h2g2,'&#35;') or starts-with(@H2g2,'&#35;')">
								<xsl:value-of select="@H2G2 | @h2g2 | @H2g2"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$aerian-base-entry"/>
								<xsl:value-of select="@H2G2 | @h2g2 | @H2g2"/>
							</xsl:otherwise>
						</xsl:choose>
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
			<xsl:choose>
				<xsl:when test="@CLASS | @class">
					<xsl:attribute name="class">
						<xsl:value-of select="@CLASS | @class"/>
					</xsl:attribute>
				</xsl:when>
				<!--<xsl:otherwise>pos</xsl:otherwise>-->
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="@TARGET | @target">
					<xsl:attribute name="target">
						<xsl:value-of select="@TARGET | @target"/>
					</xsl:attribute>
				</xsl:when>
				<!--<xsl:otherwise>_top</xsl:otherwise>-->
			</xsl:choose>
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
						<xsl:otherwise>
							<xsl:comment>anchor</xsl:comment>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates mode="library_GuideML"/>
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

	<xsl:template match="LINK | link" mode="library_GuideML_rss">
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