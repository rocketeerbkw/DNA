<?xml version="1.0" encoding="iso-8859-1"?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:tom="http://purl.org/rss/1.0/" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:dcterms="http://purl.org/dc/terms/" exclude-result-prefixes="msxsl local s dt tom">

	<!-- 
	
	-->
	<xsl:template name="ARTICLESEARCH_RSS1">
		<xsl:param name="mod"/>
		<xsl:choose>
			<xsl:when test="$mod='items'">
				<items xmlns="http://purl.org/rss/1.0/">
					<rdf:Seq>
						<xsl:apply-templates select="/H2G2/ARTICLESEARCH/ARTICLES/ARTICLE" mode="rdf_resource_articlesearch"/>
					</rdf:Seq>
				</items>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="/H2G2/ARTICLESEARCH/ARTICLES/ARTICLE" mode="rss1_articlesearch"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="ARTICLESEARCH_RSS2">
		<xsl:param name="mod"/>
		<xsl:apply-templates select="/H2G2/ARTICLESEARCH/ARTICLES/ARTICLE" mode="rss2_articlesearch"/>
	</xsl:template>
	
	<!-- 
	
	-->
	<xsl:template match="ARTICLE" mode="rdf_resource_articlesearch">
		<rdf:li rdf:resource="{$thisserver}{$root}A{@H2G2ID}"/>
	</xsl:template>
	<!-- 
	
	-->
	<xsl:template match="ARTICLE" mode="rss1_articlesearch">
		<item rdf:about="{$thisserver}{$root}A{@H2G2ID}" xmlns="http://purl.org/rss/1.0/">
			<title>
				<xsl:value-of select="SUBJECT"/>
			</title>
			<description>
				<xsl:value-of select="EXTRAINFO/AUTODESCRIPTION"/>
			</description>
			<link>
				<xsl:value-of select="$thisserver"/>
				<xsl:value-of select="$root"/>A<xsl:value-of select="@H2G2ID"/>
			</link>
			<dc:date>
				<xsl:apply-templates select="LASTUPDATED/DATE" mode="dc"/>
			</dc:date>
			<dcterms:temporal>
				<xsl:apply-templates select="." mode="rss_dcterms_temporal"/>
			</dcterms:temporal>
		</item>
	</xsl:template>
	
	<xsl:template match="ARTICLE" mode="rss2_articlesearch">
		<item>
			<title>
				<xsl:value-of select="SUBJECT"/>
			</title>
			<description>
				<xsl:value-of select="EXTRAINFO/AUTODESCRIPTION"/>
			</description>
			<author>
				<xsl:value-of select="EDITOR/USERNAME"/>
				<xsl:if test="EXTRAINFO/ALTNAME != ''">
					<xsl:text> on belhalf of </xsl:text>
					<xsl:value-of select="EXTRAINFO/ALTNAME"/>
				</xsl:if>
			</author>
			<link>
				<xsl:value-of select="$thisserver"/>
				<xsl:value-of select="$root"/>A<xsl:value-of select="@H2G2ID"/>
			</link>
			<dc:date>
				<xsl:apply-templates select="LASTUPDATED/DATE" mode="dc"/>
			</dc:date>
			<dcterms:temporal>
				<xsl:apply-templates select="." mode="rss_dcterms_temporal"/>
			</dcterms:temporal>
		</item>
	</xsl:template>
	
</xsl:stylesheet>
