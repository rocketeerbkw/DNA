<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<xsl:import href="../base-newuserspage.xsl"/>
	<!-- 
	
	-->
<xsl:template name="NEWUSERS_RSS">
		<xsl:apply-templates select="NEWUSERS-LISTING/USER-LIST/USER" mode="rss91"/>
	</xsl:template>
	<!-- 
	
	-->
	<xsl:template match="USER" mode="rss91">
		<item>
			<title>
				<xsl:apply-templates select="." mode="username"/>
			</title>
			<description>
				<xsl:value-of select="DATE-JOINED/DATE/@RELATIVE"/>
			</description>
			<link>
				<xsl:value-of select="$thisserver"/>
				<xsl:value-of select="$root"/>U<xsl:value-of select="USERID"/>
			</link>
		</item>
	</xsl:template>
</xsl:stylesheet>
