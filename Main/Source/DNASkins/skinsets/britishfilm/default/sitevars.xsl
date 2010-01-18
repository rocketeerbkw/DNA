<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<xsl:variable name="sitedisplayname">British Film</xsl:variable>
	<xsl:variable name="sitename">britishfilm</xsl:variable>
	<xsl:variable name="skinname">britishfilm</xsl:variable>
	
	<xsl:variable name="root">/dna/britishfilm/</xsl:variable>
	
	<!-- 
	<xsl:variable name="root">/dna/britishfilm/</xsl:variable>
	-->
	
	<xsl:variable name="sso_serviceid_path">britishfilm</xsl:variable>
	<xsl:variable name="sso_serviceid_link">britishfilm</xsl:variable>
	
	<!-- CV delete this variable (sso_assets) when taking site live -->
	<!-- <xsl:variable name="sso_assets">http://######.illumina.co.uk/britishfilm/sso_resources</xsl:variable> -->
	<xsl:variable name="sso_assets">http://www.bbc.co.uk/britishfilm/sso_resources</xsl:variable>
	
	<xsl:variable name="sso_ptrt" select="concat('SSO?s_return=', $referrer)"/>

	<!-- CV turn this back on when site goes live
	<xsl:variable name="sso_assets_path">/britishfilm/2/sso_resources</xsl:variable> -->
	
	<xsl:variable name="enable_rss">N</xsl:variable>
	
	<!-- <xsl:variable name="imagesource">http://#####.illumina.co.uk/britishfilm/images/</xsl:variable> -->
	<xsl:variable name="imagesource">http://www.bbc.co.uk/britishfilm/images/</xsl:variable>
	
	
	
	<xsl:variable name="smileysource" select="'http://www.bbc.co.uk/dnaimages/boards/images/emoticons/'"/>
	<!-- for smileys see: http://www.bbc.co.uk/messageboards/newguide/popup_smiley.html -->
	
	<xsl:variable name="graphics" select="$imagesource"/>
	<xsl:variable name="site_number">
		<xsl:value-of select="/H2G2/SITE-LIST/SITE[NAME='britishfilm']/@ID" />
	</xsl:variable>
	
	<xsl:variable name="test_IsHost" select="/H2G2/VIEWING-USER/USER/GROUPS/HOST or ($superuser = 1)"/>
	
	<xsl:variable name="articlesearchlink">ArticleSearchPhrase?contenttype=-1&amp;articlesortby=DateUploaded&amp;phrase=</xsl:variable>
	

	<xsl:variable name="pagetype">
	<xsl:choose>
		<xsl:when test="/H2G2/@TYPE='ARTICLE'">
		article
		</xsl:when>
		<xsl:when test="/H2G2/@TYPE='MULTIPOSTS'">
		multiposts
		</xsl:when>
	</xsl:choose>
	</xsl:variable>
	
		
	<!--===============   SERVER    =====================-->
	<xsl:variable name="site_server">http://www.bbc.co.uk</xsl:variable>
<!-- 	<xsl:variable name="dna_server">http://dnadev.national.bu.bbc.co.uk</xsl:variable>
 -->	
 	<xsl:variable name="dna_server">http://dnadev.bu.bbc.co.uk</xsl:variable>
	<xsl:variable name="development_server">OPS-DNA1</xsl:variable>
	<xsl:variable name="staging_server">NMSDNA0</xsl:variable>
	
	
	




	
	
</xsl:stylesheet>
