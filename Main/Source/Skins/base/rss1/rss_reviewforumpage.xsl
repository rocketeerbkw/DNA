<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" exclude-result-prefixes="msxsl local s dt">
	<!-- 
	
	-->
	
	<!-- 
	
	-->
	<xsl:template name="REVIEWFORUM_RSS1">
		<xsl:param name="mod"/>
		<xsl:choose>
			<xsl:when test="$mod='items'">
				<items xmlns="http://purl.org/rss/1.0/">
					<rdf:Seq>
						<xsl:apply-templates select="REVIEWFORUM/REVIEWFORUMTHREADS/THREAD" mode="rdf_resource_reviewforumpage"/>
					</rdf:Seq>
				</items>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="REVIEWFORUM/REVIEWFORUMTHREADS/THREAD" mode="rss1_reviewforumpage"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- 
	
	-->
	<xsl:template match="THREAD" mode="rdf_resource_reviewforumpage">
		<rdf:li rdf:resource="{$thisserver}{$root}A{H2G2ID}"/>
	</xsl:template>
	<!-- 
	
	-->
	<xsl:template match="THREAD" mode="rss1_reviewforumpage">
		<item rdf:about="{$thisserver}{$root}A{H2G2ID}" xmlns="http://purl.org/rss/1.0/">
			<xsl:element name="title" namespace="{$thisnamespace}">
				<xsl:value-of select="SUBJECT"/>
			</xsl:element>
			<xsl:element name="link" namespace="{$thisnamespace}">
				<xsl:value-of select="$thisserver"/>
				<xsl:value-of select="$root"/>A<xsl:value-of select="H2G2ID"/>
			</xsl:element>
			<dc:date>
				<xsl:apply-templates select="DATEENTERED/DATE" mode="dc"/>
			</dc:date>
		</item>
	</xsl:template>
</xsl:stylesheet>
