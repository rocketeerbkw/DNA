<?xml version="1.0" encoding="ISO-8859-1"?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" xmlns:image="http://purl.org/rss/1.0/modules/image/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:dc="http://purl.org/dc/elements/1.1/" exclude-result-prefixes="msxsl local s dt">
	<xsl:import href="../../../base/rss1/RSSOutput.xsl"/>
	<!--xsl:import href="../atom/AtomOutput.xsl"/-->
	
	<!--
	<xsl:include href="XHTMLOutput.xsl"/>
	-->
	
	<xsl:include href="basic-debug.xsl"/>
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
	
	<xsl:variable name="rss_title">
		<xsl:text>BBC 606</xsl:text>
		<xsl:choose>
			<xsl:when test="/H2G2[@TYPE='ARTICLESEARCHPHRASE']">
				<xsl:text> - </xsl:text>
				<xsl:for-each select="/H2G2/ARTICLESEARCHPHRASE/PHRASES/PHRASE">
					<xsl:choose>
						<xsl:when test="TERM='article'">Articles</xsl:when>
						<xsl:when test="TERM='report'">Reports</xsl:when>
						<xsl:when test="TERM='profile'">Profiles</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="TERM"/>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:if test="position() != last()">
						<xsl:text> + </xsl:text>
					</xsl:if>
				</xsl:for-each>
			</xsl:when>
			<xsl:when test="/H2G2[@TYPE='INFO']">
				<xsl:text> - </xsl:text>
				Most recent...
			</xsl:when>
      
      <xsl:when test="/H2G2[@TYPE='ARTICLESEARCH']">
        <xsl:text> - </xsl:text>
        <xsl:for-each select="/H2G2/ARTICLESEARCH/PHRASES/PHRASE">
          <xsl:choose>
            <xsl:when test="TERM='article'">Articles</xsl:when>
            <xsl:when test="TERM='report'">Reports</xsl:when>
            <xsl:when test="TERM='profile'">Profiles</xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="TERM"/>
            </xsl:otherwise>
          </xsl:choose>
          <xsl:if test="position() != last()">
            <xsl:text> + </xsl:text>
          </xsl:if>
        </xsl:for-each>
      </xsl:when>
      <xsl:when test="/H2G2[@TYPE='INFO']">
        <xsl:text> - </xsl:text>
        Most recent...
      </xsl:when>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="rss_description">comment debate create</xsl:variable>
	
	<xsl:variable name="rss_rdf_resource_image">
		<xsl:element name="image" namespace="{$thisnamespace}">
			<xsl:attribute name="rdf:resource">http://www.bbc.co.uk/606/2/images/pop_banner.gif</xsl:attribute>
		</xsl:element>
	</xsl:variable>
	<xsl:variable name="rss_image">
		<xsl:element name="image" namespace="{$thisnamespace}">
			<xsl:attribute name="rdf:about">http://www.bbc.co.uk/606/2/images/pop_banner.gif</xsl:attribute>
			<xsl:element name="title" namespace="{$thisnamespace}">606</xsl:element>
			<xsl:element name="url" namespace="{$thisnamespace}">http://news.bbc.co.uk/sport1/hi/606/default.stm</xsl:element>
			<xsl:element name="link" namespace="{$thisnamespace}">http://news.bbc.co.uk/sport1/hi/606/default.stm</xsl:element>
			<!--
			<xsl:element name="width" namespace="{$thisnamespace}">140</xsl:element>
			<xsl:element name="height" namespace="{$thisnamespace}">36</xsl:element>
			-->
		</xsl:element>
	</xsl:variable>
</xsl:stylesheet>
