<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<!--===============Output Setting=====================-->
	<xsl:import href="../base-extra.xsl"/>
	<xsl:output method="xml" version="1.0" standalone="yes" indent="yes" omit-xml-declaration="no"/>
	<xsl:include href="rss_threadspage.xsl"/>
	<xsl:include href="rss_clubpage.xsl"/>
	<xsl:include href="rss_multipostspage.xsl"/>
	<xsl:include href="rss_userpage.xsl"/>
	<xsl:include href="rss_reviewforumpage.xsl"/>
	<xsl:include href="rss_newusers.xsl"/>
	<!--===============Output Setting=====================-->
	<xsl:key name="feedtype" match="/H2G2/PARAMS/PARAM[NAME='s_feed']" use="VALUE"/>
	
	
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
						Temporary RSS templates
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
					RSS Logical Container Template
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<xsl:template match="H2G2">
		<xsl:variable name="html_header">
			<xsl:call-template name="insert-header"/>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="/H2G2/PARAMS/PARAM[NAME='s_xml']/VALUE='rss'">
				<rss version="0.91">
					<channel>
						<title>
							<xsl:value-of select="$sitedisplayname"/>
						</title>
						<link>
							<xsl:value-of select="concat('http://www.bbc.co.uk/go/syn/public/dna_', $sitename, '/-', $root, $referrer)"/>
						</link>
						<description>
						
							<xsl:value-of select="msxsl:node-set($html_header)/head/title"/>
						</description>
						<language>en-gb</language>
						<image>
							<title>BBC</title>
							<url>http://www.bbc.co.uk/images/logo04.gif</url>
							<link>http://www.bbc.co.uk</link>
							<width>50</width>
							<height>20</height>
						</image>
						<xsl:call-template name="type-check">
							<xsl:with-param name="content">RSS</xsl:with-param>
						</xsl:call-template>
					</channel>
				</rss>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
						Temporary RSS templates
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
</xsl:stylesheet>
