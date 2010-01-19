<?xml version="1.0" encoding="ISO-8859-1"?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" xmlns:image="http://purl.org/rss/1.0/modules/image/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:dc="http://purl.org/dc/elements/1.1/" exclude-result-prefixes="msxsl local s dt">
	<xsl:import href="../rss1/RSSOutput.xsl"/>
	<!--xsl:import href="../atom/AtomOutput.xsl"/-->
	<xsl:include href="comedysoup-sitevars.xsl"/>
	<!-- 
	
	-->
	<xsl:variable name="syn_article"/>

	<xsl:variable name="rss_title">Comedy Soup 
		<xsl:if test="/H2G2/PARAMS/PARAM[NAME='s_name']/VALUE">
			| <xsl:value-of select="/H2G2/PARAMS/PARAM[NAME='s_name']/VALUE"/>
		</xsl:if>
		<xsl:choose>
			<xsl:when test="/H2G2/PARAMS/PARAM[NAME='s_feedtype']/VALUE='image'">
				| Most recent image submissions
			</xsl:when>
			<xsl:when test="/H2G2/PARAMS/PARAM[NAME='s_feedtype']/VALUE='audio'">
				| Most recent audio submissions
			</xsl:when>
			<xsl:when test="/H2G2/PARAMS/PARAM[NAME='s_feedtype']/VALUE='video'">
				| Most recent video &amp; animation submissions
			</xsl:when>
			<xsl:otherwise>
				| Most recent submissions
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="rss_description">All the latest funny stuff from BBC Comedy Soup.</xsl:variable>
	<!--
	<xsl:variable name="rss_frontpage_description_default">Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Nullam volutpat tempus lorem. In tempor, metus placerat tincidunt vestibulum, elit leo volutpat tortor, eu dapibus dolor enim eget tortor. Phasellus ipsum est, imperdiet nec, pulvinar id, volutpat et, odio. Cras nibh nulla, vulputate et, venenatis sed, semper vel, odio.</xsl:variable>
	<xsl:variable name="rss_frontpage_title_default" select="$sitedisplayname"/>
	-->
	<xsl:variable name="rss_rdf_resource_image">
		<xsl:element name="image" namespace="{$thisnamespace}">
			<xsl:attribute name="rdf:resource">http://www.bbc.co.uk/comedysoup/images/newsletter/banner.gif</xsl:attribute>
		</xsl:element>
	</xsl:variable>
	<xsl:variable name="rss_image">
		<xsl:element name="image" namespace="{$thisnamespace}">
			<xsl:attribute name="rdf:about">http://www.bbc.co.uk/comedysoup/images/newsletter/banner.gif</xsl:attribute>
			<xsl:element name="title" namespace="{$thisnamespace}">Comedy Soup</xsl:element>
			<xsl:element name="url" namespace="{$thisnamespace}">http://www.bbc.co.uk/comedysoup/images/newsletter/banner.gif</xsl:element>
			<xsl:element name="link" namespace="{$thisnamespace}">http://www.bbc.co.uk/dna/comedysoup/</xsl:element>
			<!--xsl:element name="width" namespace="{$thisnamespace}">140</xsl:element>
			<xsl:element name="height" namespace="{$thisnamespace}">36</xsl:element-->
		</xsl:element>
	</xsl:variable>

	<!-- override templates -->
	<!-- from rss1/rss_articlesearchphrase.xsl -->
	<xsl:template match="ARTICLE" mode="rss1_articlesearchphrase">
		<item rdf:about="{$thisserver}{$root}A{@H2G2ID}" xmlns="http://purl.org/rss/1.0/">
			<title>
				<xsl:value-of select="SUBJECT"/>
			</title>
			<description>
				<xsl:choose>
					<xsl:when test="/H2G2/ARTICLESEARCHPHRASE/ARTICLESEARCH/@CONTENTTYPE=1">
						Image<br/><br/>
					</xsl:when>
					<xsl:when test="/H2G2/ARTICLESEARCHPHRASE/ARTICLESEARCH/@CONTENTTYPE=2">
						Audio<br/><br/>
					</xsl:when>
					<xsl:when test="/H2G2/ARTICLESEARCHPHRASE/ARTICLESEARCH/@CONTENTTYPE=3">
						Video &amp; animation<br/><br/>
					</xsl:when>
				</xsl:choose>	
				<xsl:value-of select="EXTRAINFO/AUTODESCRIPTION"/>
			</description>
			<link>
				<xsl:value-of select="$thisserver"/>
				<xsl:value-of select="$root"/>A<xsl:value-of select="@H2G2ID"/>
			</link>
			<dc:date>
				<xsl:apply-templates select="LASTUPDATED/DATE" mode="dc"/>
			</dc:date>
		</item>
	</xsl:template>
	
	
	<!-- overridden from rss1/RSSOutput.xsl, used for mediaasset rss -->
	<xsl:template match="H2G2[key('xmltype', 'rss1') or key('xmltype', 'rss')]">
		<xsl:choose>
			<xsl:when test="/H2G2/@TYPE='MEDIAASSET'">
				<rdf:RDF xmlns="http://purl.org/rss/1.0/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:dc="http://purl.org/dc/elements/1.1/"
		xmlns:content="http://purl.org/rss/1.0/modules/content/">
					<channel rdf:about="{$thisserver}{$root}{$referrer}">
						<title>
							<xsl:value-of select="$rss_title"/>
						</title>
						<!--xsl:element name="link" namespace="{$thisnamespace}">
							<xsl:value-of select="$rss_link"/>
						</xsl:element-->
						<link>
							<xsl:value-of select="$rss_link"/>
						</link>
						<description>
							<xsl:value-of select="$rss_description"/>
						</description>
						<dc:date>
							<xsl:apply-templates select="DATE" mode="dc"/>
						</dc:date>
						<xsl:copy-of select="$rss_rdf_resource_image"/>

						<xsl:call-template name="MEDIAASSET_RSS1">
							<xsl:with-param name="mod">items</xsl:with-param>
						</xsl:call-template>
					</channel>
					<xsl:copy-of select="$rss_image"/>
					<xsl:call-template name="MEDIAASSET_RSS1" />
				</rdf:RDF>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-imports />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	
	<!-- at the moment highjjacks the articlesearchphrase templates -->
	<xsl:template name="MEDIAASSET_RSS1">
		<xsl:param name="mod"/>
		<xsl:choose>
			<xsl:when test="$mod='items'">
				<items xmlns="http://purl.org/rss/1.0/">
					<rdf:Seq>
						<xsl:apply-templates select="/H2G2/MEDIAASSETBUILDER/ARTICLEMEDIAASSETINFO/ARTICLE" mode="rdf_resource_articlesearchphrase"/>
					</rdf:Seq>
				</items>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="/H2G2/MEDIAASSETBUILDER/ARTICLEMEDIAASSETINFO//ARTICLE" mode="rss1_articlesearchphrase"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
					
</xsl:stylesheet>
