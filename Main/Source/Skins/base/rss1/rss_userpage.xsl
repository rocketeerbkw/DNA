<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" exclude-result-prefixes="msxsl local s dt">
	
	<!-- 
	
	-->
	<xsl:template name="USERPAGE_RSS1">
		<xsl:param name="mod"/>
		<xsl:choose>
			<xsl:when test="$mod='items'">
				<items xmlns="http://purl.org/rss/1.0/">
					<rdf:Seq>
						<xsl:apply-templates select="ARTICLEFORUM/FORUMTHREADS/THREAD" mode="rdf_resource_userpage"/>
						<!--xsl:if test="key('feedtype', 'convs')">
							<xsl:apply-templates select="RECENT-POSTS/POST-LIST/POST" mode="rdf_resource_userpageposts"/>
						</xsl:if>
						<xsl:if test="key('feedtype', 'journal')">
							<xsl:apply-templates select="JOURNAL/JOURNALPOSTS/POST" mode="rdf_resource_userpagejournal"/>
						</xsl:if-->
					</rdf:Seq>
				</items>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="ARTICLEFORUM/FORUMTHREADS/THREAD" mode="rss1_userpage"/>
				<!--xsl:if test="key('feedtype', 'convs')">
					<xsl:apply-templates select="RECENT-POSTS/POST-LIST/POST" mode="rss1_userpageposts"/>
				</xsl:if>
				<xsl:if test="key('feedtype', 'journal')">
					<xsl:apply-templates select="JOURNAL/JOURNALPOSTS/POST" mode="rss1_userpagejournal"/>
				</xsl:if-->
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- 
	
	-->
	<xsl:template match="THREAD" mode="rdf_resource_userpage">
		<rdf:li rdf:resource="{$thisserver}{$root}F{@FORUMID}?thread={@THREADID}"/>
	</xsl:template>
	<!-- 
	
	-->
	<xsl:template match="THREAD" mode="rss1_userpage">
		<item rdf:about="{$thisserver}{$root}F{@FORUMID}?thread={@THREADID}" xmlns="http://purl.org/rss/1.0/">
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
			<dc:date>
				<xsl:apply-templates select="LASTPOST/DATE" mode="dc"/>
			</dc:date>
		</item>
	</xsl:template>
	<!--xsl:template match="POST" mode="rdf_resource_userpagejournal">
		<rdf:li rdf:resource="{$thisserver}{$root}MJ{/H2G2/PAGE-OWNER/USER/USERID}?Journal={../@FORUMID}#{@POSTID}"/>
	</xsl:template>
	
	<xsl:template match="POST" mode="rss1_userpagejournal">
		<item rdf:about="{$thisserver}{$root}MJ{/H2G2/PAGE-OWNER/USER/USERID}?Journal={../@FORUMID}#{@POSTID}" xmlns="http://purl.org/rss/1.0/">
			<xsl:apply-templates select="." mode="rss_userpagejournal"/>
			<dc:date>
				<xsl:apply-templates select="DATEPOSTED/DATE" mode="dc"/>
			</dc:date>
		</item>
	</xsl:template-->
	<!--xsl:template match="POST" mode="rdf_resource_userpageposts">
		<rdf:li rdf:resource="{$thisserver}{$root}F{THREAD/@FORUMID}?thread={THREAD/@THREADID}"/>
	</xsl:template>
	
	<xsl:template match="POST" mode="rss1_userpageposts">
		<item rdf:about="{$thisserver}{$root}F{THREAD/@FORUMID}?thread={THREAD/@THREADID}" xmlns="http://purl.org/rss/1.0/">
			<xsl:apply-templates select="." mode="rss_userpageposts"/>
			<dc:date>
				<xsl:apply-templates select="THREAD/REPLYDATE/DATE" mode="dc"/>
			</dc:date>
		</item>
	</xsl:template-->
</xsl:stylesheet>
