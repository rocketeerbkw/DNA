<?xml version="1.0" encoding="iso-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" xmlns:image="http://purl.org/rss/1.0/modules/image/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:dc="http://purl.org/dc/elements/1.1/" exclude-result-prefixes="msxsl local s dt">
	<xsl:import href="../../../base/rss1/RSSOutput.xsl"/>
	<xsl:include href="rss_articlesearch.xsl"/>
	<xsl:include href="rss_morepages.xsl"/>
	<xsl:include href="rss_searchpage.xsl"/>
	
	<xsl:variable name="rss_title">
		<xsl:value-of select="$m_frontpagetitle"/>
		<xsl:choose>
			<xsl:when test="/H2G2[@TYPE='ARTICLESEARCH']">
				<xsl:text> - </xsl:text>
				<xsl:call-template name="VIEW_NAME"/>
			</xsl:when>
		</xsl:choose>
	</xsl:variable>
	
	<!--[FIXME: update]-->
	<xsl:variable name="rss_description">memoryshare description</xsl:variable>
	
	<xsl:variable name="rss_rdf_resource_image">
		<xsl:element name="image" namespace="{$thisnamespace}">
			<!--[FIXME: update/fix]-->
			<xsl:attribute name="rdf:resource">http://www.bbc.co.uk/memoryshare/images/bbc_memoryshare_rss_banner.gif</xsl:attribute>
		</xsl:element>
	</xsl:variable>
	
	<xsl:variable name="rss_image">
		<xsl:element name="image" namespace="{$thisnamespace}">
			<!--[FIXME: update/fix]-->
			<xsl:attribute name="rdf:about">http://www.bbc.co.uk/feeds/images/syndication/bbc_logo.gif</xsl:attribute>
			<xsl:element name="title" namespace="{$thisnamespace}"><xsl:value-of select="$m_frontpagetitle"/></xsl:element>
			<xsl:element name="url" namespace="{$thisnamespace}">http://www.bbc.co.uk/dna/memoryshare/<xsl:value-of select="$client_url_param"/></xsl:element>
			<xsl:element name="link" namespace="{$thisnamespace}">http://www.bbc.co.uk/dna/memoryshare/<xsl:value-of select="$client_url_param"/></xsl:element>
			<!--[FIXME: remove?]
			<xsl:element name="width" namespace="{$thisnamespace}">140</xsl:element>
			<xsl:element name="height" namespace="{$thisnamespace}">36</xsl:element>
			-->
		</xsl:element>
	</xsl:variable>
	
	<xsl:template match="H2G2[key('xmltype', 'rss1') or key('xmltype', 'rss')]">
		<xsl:processing-instruction name="xml-stylesheet">
			<xsl:text>title="XSL_formatting" type="text/xsl"</xsl:text>
			<xsl:text> </xsl:text>
			<xsl:text>href="/memoryshare/xsl/rss1.xsl"</xsl:text>
			<xsl:text> </xsl:text>
		</xsl:processing-instruction>
		<rdf:RDF xmlns="http://purl.org/rss/1.0/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:dc="http://purl.org/dc/elements/1.1/"
xmlns:content="http://purl.org/rss/1.0/modules/content/">
			<channel rdf:about="{$thisserver}{$root}{$referrer}">
				<title>
					<xsl:value-of select="$rss_title"/>
				</title>
				<link>
					<xsl:value-of select="$rss_link"/>
				</link>
				<description>
					<xsl:value-of select="$rss_description"/>
				</description>
				<dc:date>
					<xsl:apply-templates select="DATE" mode="dc"/>
				</dc:date>
				<dc:rights>
					<xsl:text>Copyright: (C) British Broadcasting Corporation, see http://www.bbc.co.uk/feedfactory/terms.shtml for terms and conditions of reuse</xsl:text>
				</dc:rights>
				<xsl:copy-of select="$rss_rdf_resource_image"/>
	
				<xsl:call-template name="type-check">
					<xsl:with-param name="content">RSS1</xsl:with-param>
					<xsl:with-param name="mod">items</xsl:with-param>
				</xsl:call-template>
			</channel>
			<xsl:copy-of select="$rss_image"/>
			<xsl:call-template name="type-check">
				<xsl:with-param name="content">RSS1</xsl:with-param>
			</xsl:call-template>
		</rdf:RDF>
	</xsl:template>	
	
	<xsl:template match="H2G2[key('xmltype', 'rss2')]">
		<!--
		<xsl:processing-instruction name="xml-stylesheet">
			<xsl:text>title="XSL_formatting" type="text/xsl"</xsl:text>
			<xsl:text> </xsl:text>
			<xsl:text>href="</xsl:text>
			<xsl:value-of select="$asset_root"/>
			<xsl:text>xsl/nolsol3.xsl"</xsl:text>
			<xsl:text> </xsl:text>
		</xsl:processing-instruction>
		-->
		<rss version="2.0" xmlns="http://purl.org/rss/1.0/" 
			xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" 
			xmlns:dc="http://purl.org/dc/elements/1.1/"
			xmlns:content="http://purl.org/rss/1.0/modules/content/">
			<channel>			
				<title>
					<xsl:value-of select="$rss_title"/>
				</title>
				<link>
					<xsl:value-of select="$rss_link"/>
				</link>
				<description>
					<xsl:value-of select="$rss_description"/>
				</description>
				<dc:date>
					<xsl:apply-templates select="DATE" mode="dc"/>
				</dc:date>
				<copyright>
					<xsl:text>
						Copyright: (C) British Broadcasting Corporation, 
						see http://www.bbc.co.uk/feedfactory/terms.shtml for terms and conditions of reuse
					</xsl:text>
				</copyright>

				<xsl:copy-of select="$rss_image"/>

				<xsl:call-template name="type-check">
					<xsl:with-param name="content">RSS2</xsl:with-param>
				</xsl:call-template>
			</channel>
		</rss>
	</xsl:template>	
	
</xsl:stylesheet>
