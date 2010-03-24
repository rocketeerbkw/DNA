<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<xsl:variable name="sitename">collective</xsl:variable>
	<xsl:variable name="root">/dna/collective/</xsl:variable>
	<xsl:variable name="sso_serviceid_link">collective</xsl:variable>
	<xsl:variable name="sso_assets_path">/collective/sso_resources</xsl:variable>
	<!--===============   SERVER    =====================-->
	<xsl:variable name="site_server">http://www.bbc.co.uk</xsl:variable>
	<xsl:variable name="dna_server">http://dnadev.bu.bbc.co.uk</xsl:variable>
	<xsl:variable name="graphics" select="'http://www.bbc.co.uk/collective/dnaimages/'"/>
	<xsl:variable name="sitedisplayname">collective</xsl:variable>
</xsl:stylesheet>

