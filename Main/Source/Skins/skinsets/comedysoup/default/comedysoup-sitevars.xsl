<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<xsl:variable name="sitedisplayname">ComedySoup</xsl:variable>
	<xsl:variable name="sitename">comedysoup</xsl:variable>
	<xsl:variable name="root">/dna/comedysoup/</xsl:variable>
	<xsl:variable name="sso_statbar_type">kids</xsl:variable>
	<xsl:variable name="sso_serviceid_path">comedysoup</xsl:variable>
	<xsl:variable name="sso_serviceid_link">comedysoup</xsl:variable>
	<xsl:variable name="sso_assets_path">/comedysoup/sso_resources</xsl:variable>
	<xsl:variable name="development_server">OPS-DNA1</xsl:variable>
	<xsl:variable name="staging_server">NMSDNA0</xsl:variable>
	
	<!-- override $sso_resources in base file if not on dnadev server 
	- otherwise transforms not done off bbc server revert to http://ops-dev14.national.core.bbc.co.uk 
	- which means E3 (external agency) get borken images and links for SSO -->
	<xsl:variable name="sso_resources">
		<xsl:choose>
				<xsl:when test="/H2G2/SERVERNAME=$development_server">http://ops-dev14.national.core.bbc.co.uk</xsl:when>
				<xsl:otherwise>http://www.bbc.co.uk</xsl:otherwise>
		</xsl:choose>
	</xsl:variable> 
	<xsl:variable name="imagesource">http://www.bbc.co.uk/comedysoup/images/</xsl:variable>
	<xsl:variable name="smileysource" select="'http://www.bbc.co.uk/comedysoup/images/smileys/'"/>
	<xsl:variable name="graphics" select="$imagesource"/>
	
	<xsl:variable name="user_is_assetmoderator">
		<xsl:choose>
			<xsl:when test="/H2G2/VIEWING-USER/USER/GROUPS/ASSETMODERATOR">1</xsl:when>
			<xsl:otherwise>0</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<xsl:variable name="user_is_moderator">
		<xsl:choose>
			<xsl:when test="/H2G2/VIEWING-USER/USER/GROUPS/MODERATOR">1</xsl:when>
			<xsl:otherwise>0</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	
	<!-- maximum number of messages displayed on personal space landing page -->
	<xsl:variable name="userpage_max_threads" select="5"/>

	<!-- base urls for embedded video services -->
	<xsl:variable name="youtube_video_base_url" select="'http://www.youtube.com/v/'"/>
	<xsl:variable name="google_video_base_url" select="'http://video.google.com/googleplayer.swf?docId='"/>
	<xsl:variable name="myspace_video_base_url" select="'http://lads.myspace.com/videos/vplayer.swf'"/>
	
	<xsl:variable name="fileextension">
		<xsl:choose>
			<xsl:when test="/H2G2/MEDIAASSETBUILDER/MEDIAASSETINFO/MEDIAASSET/MIMETYPE='image/gif'">.gif</xsl:when>
			<xsl:when test="/H2G2/MEDIAASSETBUILDER/MEDIAASSETINFO/MEDIAASSET/MIMETYPE='image/pjpeg'">.jpg</xsl:when>
		</xsl:choose>
	</xsl:variable>
	
	<xsl:variable name="moderationsuffix">
		<xsl:if test="/H2G2/MEDIAASSETINFO/MEDIAASSET/HIDDEN">.mod</xsl:if>
	</xsl:variable>
	
	<xsl:variable name="contenttype">
		<xsl:choose>
				<xsl:when test="/H2G2/MULTI-STAGE/MULTI-REQUIRED[@NAME='TYPE']/VALUE-EDITABLE=10">1</xsl:when>
				<xsl:when test="/H2G2/MULTI-STAGE/MULTI-REQUIRED[@NAME='TYPE']/VALUE-EDITABLE=11">2</xsl:when>
				<xsl:when test="/H2G2/MULTI-STAGE/MULTI-REQUIRED[@NAME='TYPE']/VALUE-EDITABLE=12">3</xsl:when>
			</xsl:choose>
	</xsl:variable>
	
	<xsl:variable name="libraryurl">
		<xsl:value-of select="concat($assetlibrary,'library/')"/>
	</xsl:variable>
	
	<xsl:variable name="suffix">
		<xsl:call-template name="chooseassetsuffix">
			<xsl:with-param name="mimetype" select="/H2G2/MEDIAASSETBUILDER/MEDIAASSETINFO/MEDIAASSET/MIMETYPE"></xsl:with-param>
		</xsl:call-template>
	</xsl:variable>
	
	<xsl:template name="chooseassetsuffix">
	<xsl:param name="mimetype"></xsl:param>
		<xsl:choose>			
			<xsl:when test="$mimetype='image/jpg'">jpg</xsl:when>
			<xsl:when test="$mimetype='image/jpeg'">jpg</xsl:when>
			<xsl:when test="$mimetype='image/pjpeg'">jpg</xsl:when>
			
			<xsl:when test="$mimetype='image/gif'">gif</xsl:when>
			
			<xsl:when test="$mimetype='image/bmp'">bmp</xsl:when>
			
			<xsl:when test="$mimetype='image/png'">png</xsl:when>
			
			<xsl:when test="$mimetype='avi'">avi</xsl:when>
			<xsl:when test="$mimetype='video/avi'">avi</xsl:when>
			
			<xsl:when test="$mimetype='mp1'">mp1</xsl:when>
			<xsl:when test="$mimetype='audio/mp1'">mp1</xsl:when>
			
			<xsl:when test="$mimetype='mp2'">mp2</xsl:when>
			<xsl:when test="$mimetype='audio/mp2'">mp2</xsl:when>
			
			<xsl:when test="$mimetype='mp3'">mp3</xsl:when>
			<xsl:when test="$mimetype='audio/mpeg'">mp3</xsl:when>
			<xsl:when test="$mimetype='audio/mp3'">mp3</xsl:when>
			
			<xsl:when test="$mimetype='mov'">mov</xsl:when>
			
			<xsl:when test="$mimetype='application/octet-stream'">mov</xsl:when>
			<xsl:when test="$mimetype='video/quicktime'">mov</xsl:when>
			
			<xsl:when test="$mimetype='video/mpeg'">mpg</xsl:when>
			
			<xsl:when test="$mimetype='wav'">wav</xsl:when>
			
			<xsl:when test="$mimetype='audio/aud'">aud</xsl:when>
			<xsl:when test="$mimetype='wmv'">wmv</xsl:when>
			<xsl:when test="$mimetype='video/x-ms-wmv'">wmv</xsl:when>
			
			<xsl:when test="$mimetype='audio/x-ms-wma'">wma</xsl:when>
			
			<xsl:when test="$mimetype='rm'">rm</xsl:when>
			<xsl:when test="$mimetype='application/vnd.rn-realmedia'">rm</xsl:when>
			
			<xsl:when test="$mimetype='audio/x-pn-realaudio '">ra</xsl:when>
			
			<xsl:when test="$mimetype='application/x-shockwave-flash'">swf</xsl:when>
			
			<xsl:when test="$mimetype='video/x-flv'">flv</xsl:when>
		</xsl:choose>
	</xsl:template>
	
	
	
	<!--===============   SERVER    =====================-->
	<xsl:variable name="site_server">http://www.bbc.co.uk</xsl:variable>
	<xsl:variable name="dna_server">http://www0.bbc.co.uk</xsl:variable>
	<xsl:variable name="site_number">
		<xsl:value-of select="/H2G2/SITE-LIST/SITE[NAME='comedysoup']/@ID" />
	</xsl:variable>
</xsl:stylesheet>
