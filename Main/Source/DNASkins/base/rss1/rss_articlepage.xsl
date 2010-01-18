<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:tom="http://purl.org/rss/1.0/" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" exclude-result-prefixes="msxsl local s dt tom">

	<!-- 
	
	-->
	<xsl:template name="ARTICLE_RSS1">
		<xsl:param name="mod"/>
		<xsl:choose>
			<xsl:when test="$mod='items'">
				<items xmlns="http://purl.org/rss/1.0/">
					<rdf:Seq>
						<xsl:apply-templates select="msxsl:node-set($syn_article)/SYNDICATION/ITEM" mode="rdf_resource_articlepage"/>						
					</rdf:Seq>
				</items>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="msxsl:node-set($syn_article)/SYNDICATION/ITEM" mode="rss1_articlepage"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="ITEM" mode="rdf_resource_articlepage">
		<rdf:li rdf:resource="{tom:link}"/>
	</xsl:template>
	<!-- 
	
	-->
	<!--xsl:template match="tom:title" mode="rdf_resource_articlepage">
		<rdf:li rdf:resource="{following-sibling::tom:link}"/>
	</xsl:template-->
	<!-- 
	
	-->
	<xsl:template match="ITEM" mode="rss1_articlepage">
		<item rdf:about="{tom:link}" xmlns="http://purl.org/rss/1.0/">
			<xsl:for-each select="*">
				<xsl:copy-of select="."/>
			</xsl:for-each>
	

		</item>
	</xsl:template>
	<!--xsl:template match="tom:title" mode="rss1_articlepage">
		<item rdf:about="{following-sibling::tom:link}" xmlns="http://purl.org/rss/1.0/">
			<xsl:apply-templates select="." mode="syndication_item_children">
				<xsl:with-param name="first" select="'yes'"/>
			</xsl:apply-templates>
			
		</item>
	</xsl:template>
	<xsl:template match="*" mode="syndication_item_children">
		<xsl:param name="first"/>
		<xsl:if test="(name() = 'title' and $first = 'yes') or (name() != 'title')">
	
			<xsl:copy-of select="."/>
			<xsl:apply-templates select="following-sibling::*[1]" mode="syndication_item_children"/>
		</xsl:if>
	</xsl:template-->
</xsl:stylesheet>
