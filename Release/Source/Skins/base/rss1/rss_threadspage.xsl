<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" exclude-result-prefixes="msxsl local s dt">
	<!-- 
	
	-->
	
	<!-- 
	
	-->
	<xsl:template name="THREADS_RSS1">
		<xsl:param name="mod"/>
		<xsl:choose>
			<xsl:when test="$mod='items'">
				<items xmlns="http://purl.org/rss/1.0/">
					<rdf:Seq>
						<xsl:apply-templates select="FORUMTHREADS/THREAD" mode="rdf_resource_threadspage"/>
					</rdf:Seq>
				</items>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="FORUMTHREADS/THREAD" mode="rss1_threadspage"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- 
	
	-->
	<xsl:template match="THREAD" mode="rdf_resource_threadspage">
		<rdf:li rdf:resource="{$thisserver}{$root}F{@FORUMID}?thread={@THREADID}"/>
	</xsl:template>
	<!-- 
	
	-->
	<xsl:template match="THREAD" mode="rss1_threadspage">

		<item rdf:about="{concat($thisserver, $root, 'F', @FORUMID, '?thread=', @THREADID)}" xmlns="http://purl.org/rss/1.0/">
			<title>
				<xsl:value-of select="SUBJECT"/>
			</title>
			<description>
				<xsl:value-of select="FIRSTPOST/TEXT"/>
			</description>
			<link>
				<xsl:value-of select="$thisserver"/>
				<xsl:value-of select="$root"/>F<xsl:value-of select="@FORUMID"/>?thread=<xsl:value-of select="@THREADID"/>&amp;latest=1#p<xsl:value-of select="LASTPOST/@POSTID"/>
			</link>
			<dc:date>
				<xsl:apply-templates select="LASTPOST/DATE" mode="dc"/>
			</dc:date>
		</item>
	</xsl:template>
</xsl:stylesheet>
