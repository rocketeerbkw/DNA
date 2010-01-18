<?xml version="1.0" encoding="ISO-8859-1"?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" xmlns:image="http://purl.org/rss/1.0/modules/image/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:dc="http://purl.org/dc/elements/1.1/" exclude-result-prefixes="msxsl local s dt">
	<xsl:import href="../rss1/RSSOutput.xsl"/>
	<!--xsl:import href="../atom/AtomOutput.xsl"/-->
	<xsl:include href="types.xsl"/>
	<xsl:include href="sitevars.xsl"/>
	<!-- 
	
	-->
	<!--
	<xsl:variable name="syn_article">
		<SYNDICATION>
			<xsl:choose>
				<xsl:when test="key('pagetype', 'FRONTPAGE') and key('feedtype', 'mwshorts')">
					<xsl:for-each select="/H2G2/SITECONFIG/MOSTWATCHED/MWSHORT">
						<ITEM>
							<xsl:element name="title" namespace="{$thisnamespace}">
								<xsl:value-of select="LINK"/>
							</xsl:element>
							<xsl:element name="description" namespace="{$thisnamespace}">
								<xsl:value-of select="CREDIT"/>
							</xsl:element>
							<xsl:element name="link" namespace="{$thisnamespace}">
								<xsl:value-of select="concat($thisserver, $root, LINK/@DNAID)"/>
							</xsl:element>
							<image:item rdf:about="{$graphics}{IMG/@NAME}">
								<dc:title>
									<xsl:value-of select="IMG/@ALT"/>
								</dc:title>
								<image:width>
									<xsl:value-of select="IMG/@WIDTH"/>
								</image:width>
								<image:height>
									<xsl:value-of select="IMG/@HEIGHT"/>
								</image:height>
       						 </image:item>

						</ITEM>
					</xsl:for-each>
				</xsl:when>
				
			</xsl:choose>
		</SYNDICATION>
	</xsl:variable>
	-->
	<!--
	<xsl:variable name="rss_frontpage_description_default">The most watched short films on Film Network, the BBCs showcase for new British filmmakers.</xsl:variable>
	<xsl:variable name="rss_frontpage_title_default" select="/H2G2/SITECONFIG/MOSTWATCHED/HEADER"/>
	-->
	
	<xsl:variable name="rss_title">BBC British Film</xsl:variable>
	<xsl:variable name="rss_description">comment debate create</xsl:variable>
	
	<xsl:variable name="rss_rdf_resource_image">
		<xsl:element name="image" namespace="{$thisnamespace}">
			<xsl:attribute name="rdf:resource">http://www.bbc.co.uk/britishfilm/2/images/pop_banner.gif</xsl:attribute>
		</xsl:element>
	</xsl:variable>
	<xsl:variable name="rss_image">
		<xsl:element name="image" namespace="{$thisnamespace}">
			<xsl:attribute name="rdf:about">http://www.bbc.co.uk/britishfilm/2/images/pop_banner.gif</xsl:attribute>
			<xsl:element name="title" namespace="{$thisnamespace}">britishfilm</xsl:element>
			<xsl:element name="url" namespace="{$thisnamespace}">NA</xsl:element>
			<xsl:element name="link" namespace="{$thisnamespace}">NA</xsl:element>
			<!--
			<xsl:element name="width" namespace="{$thisnamespace}">140</xsl:element>
			<xsl:element name="height" namespace="{$thisnamespace}">36</xsl:element>
			-->
		</xsl:element>
	</xsl:variable>
</xsl:stylesheet>
