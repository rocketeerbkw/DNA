<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<xsl:variable name="sitedisplayname">Film Network</xsl:variable>
	<xsl:variable name="sitename">filmnetwork</xsl:variable>
	<xsl:variable name="root">/dna/filmnetwork/</xsl:variable>
	<xsl:variable name="sso_serviceid_link">filmnetwork</xsl:variable>
	<xsl:variable name="sso_assets_path">/filmnetwork/sso_resources</xsl:variable>
	<xsl:variable name="imagesource">http://www.bbc.co.uk<!-- <xsl:value-of select="$site_server" /> -->/filmnetwork/images/</xsl:variable>
	<xsl:variable name="smileysource" select="'http://www.bbc.co.uk/filmnetwork/images/smileys/'"/>
	<xsl:variable name="graphics" select="$imagesource"/>
	
	<xsl:variable name="name">
		<xsl:choose>
			<xsl:when test="/H2G2/PAGE-OWNER/USER/FIRSTNAMES/text() and /H2G2/PAGE-OWNER/USER/LASTNAME/text()">
				<xsl:value-of select="/H2G2/PAGE-OWNER/USER/FIRSTNAMES" />&nbsp;<xsl:value-of select="/H2G2/PAGE-OWNER/USER/LASTNAME" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="/H2G2/PAGE-OWNER/USER/USERNAME" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	
	<!--===============   SERVER    =====================-->
	<xsl:variable name="development_server">OPS-DNA1</xsl:variable>
	<xsl:variable name="staging_server">NMSDNA0</xsl:variable>
		
	<xsl:variable name="site_server">http://www.bbc.co.uk</xsl:variable>	
	<xsl:variable name="dna_server">
		<xsl:choose>
			<xsl:when test="/H2G2/SERVERNAME=$development_server">http://dnadev.national.core.bbc.co.uk</xsl:when>
			<xsl:when test="/H2G2/SERVERNAME=$staging_server">http://www0.bbc.co.uk</xsl:when>
			<xsl:otherwise>http://www.bbc.co.uk</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<xsl:variable name="server">
		<xsl:choose>
			<xsl:when test="/H2G2/SERVERNAME=$development_server">dev</xsl:when>
			<xsl:when test="/H2G2/SERVERNAME=$staging_server">stage</xsl:when>
			<xsl:otherwise>live</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<xsl:variable name="test_IsDev" select="/H2G2/SERVERNAME=$development_server"/>
	<xsl:variable name="test_IsStage" select="/H2G2/SERVERNAME=$staging_server"/>
	
</xsl:stylesheet>
