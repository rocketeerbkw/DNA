<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<xsl:import href="../base-userpage.xsl"/>
	<xsl:variable name="userpage_url" select="concat($foreignserver, $root, 'U', /H2G2/PAGE-OWNER/USER/USERID)"/>
	<!-- The following templates need to be removed but are required here so they are compatible with base -->
	<!-- The following templates need to be removed but are required here so they are compatible with base -->
	<!-- The following templates need to be removed but are required here so they are compatible with base -->
	<xsl:template name="r_createnewarticle"/>
	<xsl:template name="noJournalReplies"/>
	<!-- The previous templates need to be removed but are required here so they are compatible with base -->
	<!-- The previous templates need to be removed but are required here so they are compatible with base -->
	<!-- The previous templates need to be removed but are required here so they are compatible with base -->
	
	
	<xsl:template name="USERPAGE_RSS">
		
			<xsl:if test="key('feedtype', 'messages')">
				<xsl:apply-templates select="ARTICLEFORUM" mode="rss91"/>
			</xsl:if>
			<xsl:if test="key('feedtype', 'convs')">
				<xsl:apply-templates select="RECENT-POSTS" mode="rss91"/>
			</xsl:if>
			<xsl:if test="key('feedtype', 'journal')">
				<xsl:apply-templates select="JOURNAL" mode="rss91"/>
			</xsl:if>
			
	</xsl:template>
	
	<!-- 
	
	-->
	<xsl:template match="ARTICLEFORUM" mode="rss91">
		<xsl:apply-templates select="FORUMTHREADS/THREAD" mode="rss91_userpage"/>
	</xsl:template>
	<!-- 
	
	-->
	<xsl:template match="THREAD" mode="rss91_userpage">
		<item>
			<title>
				<xsl:value-of select="SUBJECT"/>
			</title>
			<description>
				<xsl:value-of select="FIRSTPOST/TEXT"/>
			</description>
			<link>
				<xsl:value-of select="$thisserver"/>
				<xsl:value-of select="$root"/>F<xsl:value-of select="@FORUMID"/>?thread=<xsl:value-of select="@THREADID"/>
			</link>
		</item>
	</xsl:template>
	<!-- 
	
	-->
	<xsl:template match="RECENT-POSTS" mode="rss91">
		<xsl:apply-templates select="POST-LIST/POST" mode="rss91_userpageposts"/>
	</xsl:template>
	
	<!-- 
	
	-->
	<xsl:template match="POST" mode="rss91_userpageposts">
		<item>
			<title>
				<xsl:value-of select="THREAD/SUBJECT"/>
			</title>
			<description>Latest post: <xsl:value-of select="THREAD/LASTUSERPOST/DATEPOSTED/DATE/@RELATIVE"/>
			</description>
			<link>
				<xsl:value-of select="$thisserver"/>
				<xsl:value-of select="$root"/>F<xsl:value-of select="THREAD/@FORUMID"/>?thread=<xsl:value-of select="THREAD/@THREADID"/>
			</link>
		</item>
	</xsl:template>
	<!-- 
	
	-->
	<xsl:template match="JOURNAL" mode="rss91">
		<xsl:apply-templates select="JOURNALPOSTS/POST" mode="rss91_userpagejournal"/>
	</xsl:template>
	<!-- 
	
	-->
	<xsl:template match="POST" mode="rss91_userpagejournal">
		<item>
			<title>
				<xsl:value-of select="SUBJECT"/>
			</title>
			<description>
				<xsl:value-of select="TEXT"/>
			</description>
			<link>
				<xsl:value-of select="$thisserver"/>
				<xsl:value-of select="$root"/>MJ<xsl:value-of select="/H2G2/PAGE-OWNER/USER/USERID"/>?Journal=<xsl:value-of select="../@FORUMID"/>
			</link>
		</item>

	</xsl:template>
</xsl:stylesheet>
