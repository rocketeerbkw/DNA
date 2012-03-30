<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0" 
                xmlns:msxsl="urn:schemas-microsoft-com:xslt" 
                xmlns:local="#local-functions" 
                xmlns:s="urn:schemas-microsoft-com:xml-data" 
                xmlns:dt="urn:schemas-microsoft-com:datatypes">

<xsl:variable name="usenodeset">1</xsl:variable>
<!--<xsl:variable name="bbcregscript">/cgi-perl/h2g2/reg.pl</xsl:variable>-->
<xsl:variable name="bbcregscript"><xsl:value-of select="$root"/>RegProcess</xsl:variable>
<xsl:variable name="frontpageurl">/h2g2/guide/</xsl:variable>
<xsl:variable name="ripleybanner">1</xsl:variable>
  <xsl:variable name="dna_root_path">/dna/</xsl:variable>
  <!-- staging_root should contain staging/ if we're on staging-->
  <xsl:variable name="staging_root"></xsl:variable>
  <xsl:variable name="bannerurl">/dna/h2g2/A516052</xsl:variable>
<xsl:variable name="bannersrc"><xsl:value-of select="$imagesource"/>banners/whats_changed.gif</xsl:variable>
<xsl:variable name="thisserver">http://local.bbc.co.uk</xsl:variable>
<xsl:variable name="foreignserver">http://local.bbc.co.uk</xsl:variable>
<xsl:variable name="sso_resources">http://ops-dev14.national.core.bbc.co.uk</xsl:variable>
<xsl:variable name="sso_script">/cgi-perl/signon/mainscript.pl</xsl:variable>
<xsl:variable name="sso_redirectserver">http://local.bbc.co.uk</xsl:variable>
<xsl:variable name="assetlibrary">
	<xsl:choose>
		<xsl:when test="/H2G2/SERVERNAME='OPS-DNA1'"><!-- dnadev -->
		http://downloads.bbc.co.uk/dnauploads/test/
		</xsl:when>
		<xsl:when test="/H2G2/SERVERNAME='NMSDNA0'"><!-- www0/stage -->
		http://downloads.bbc.co.uk/dnauploads/staging/
		</xsl:when>
		<xsl:otherwise><!-- www/live -->
		http://downloads.bbc.co.uk/dnauploads/
		</xsl:otherwise>
	</xsl:choose>
</xsl:variable>
</xsl:stylesheet>
