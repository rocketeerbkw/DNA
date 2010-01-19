<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" exclude-result-prefixes="msxsl local s dt">
	<!-- 
	
	-->	
	
	<!-- 
	
	-->
	<xsl:template name="NEWUSERS_RSS1">
		<xsl:param name="mod"/>
		<xsl:choose>
			<xsl:when test="$mod='items'">
				<items xmlns="http://purl.org/rss/1.0/">
					<rdf:Seq>
						<xsl:apply-templates select="NEWUSERS-LISTING/USER-LIST/USER" mode="rdf_resource_threadspage"/>
					</rdf:Seq>
				</items>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="NEWUSERS-LISTING/USER-LIST/USER" mode="rss1_newuserspage"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- 
	
	-->
	<xsl:template match="USER" mode="rdf_resource_threadspage">
		<rdf:li rdf:resource="{$thisserver}{$root}U{USERID}"/>
	</xsl:template>
	<!-- 
	
	-->
	<xsl:template match="USER" mode="rss1_newuserspage">
		<item rdf:about="{$thisserver}{$root}U{USERID}" xmlns="http://purl.org/rss/1.0/">
		<xsl:element name="title" namespace="{$thisnamespace}">
			<xsl:value-of select="USERNAME"/>
		</xsl:element>
		<xsl:element name="description" namespace="{$thisnamespace}">
			<xsl:text>Joined </xsl:text>
			<xsl:value-of select="DATE-JOINED/DATE/@RELATIVE"/>
		</xsl:element>
		<xsl:element name="link" namespace="{$thisnamespace}">
			<xsl:value-of select="$thisserver"/>
			<xsl:value-of select="$root"/>U<xsl:value-of select="USERID"/>
		</xsl:element>
			<dc:date>
				<xsl:apply-templates select="DATE-JOINED/DATE" mode="dc"/>
			</dc:date>
		</item>
	</xsl:template>
</xsl:stylesheet>
