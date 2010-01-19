<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<xsl:variable name="sitename">mysciencefictionlife</xsl:variable>
	<xsl:variable name="root">/dna/mysciencefictionlife/</xsl:variable>
	<xsl:variable name="imageRoot">/mysciencefictionlife/</xsl:variable>  <!-- @cv@ only in for testing -->
	<xsl:variable name="sso_serviceid_link">mysciencefictionlife</xsl:variable>
	<xsl:variable name="sso_assets_path">/mysciencefictionlife/sso_resources</xsl:variable>
	<!--===============   SERVER    =====================-->
	<xsl:variable name="site_server">http://www.bbc.co.uk</xsl:variable>
	<xsl:variable name="dna_server">http://dnadev.bu.bbc.co.uk</xsl:variable>
	<xsl:variable name="graphics" select="'http://www.bbc.co.uk/mysciencefictionlife/images/'"/>
	<xsl:variable name="sitedisplayname">My Science Fiction Life</xsl:variable>
	<xsl:variable name="siteID"><xsl:value-of select="/H2G2/CURRENTSITE" /></xsl:variable> <!-- 62 for dev, 68 for live -->
	<xsl:variable name="is_logged_in" select="boolean(/H2G2/VIEWING-USER/USER/USERNAME)"/>
</xsl:stylesheet>
