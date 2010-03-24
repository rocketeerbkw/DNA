<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" exclude-result-prefixes="msxsl local s dt">
	<!-- 
	
	-->
	<xsl:template name="MOREPOSTS_RSS1">
		<xsl:param name="mod"/>
		<xsl:choose>
			<xsl:when test="$mod='items'">
				<items xmlns="http://purl.org/rss/1.0/">
					<rdf:Seq>
				
						<xsl:apply-templates select="POSTS/POST-LIST/POST" mode="rdf_resource_moreposts"/>
					</rdf:Seq>
				</items>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="POSTS/POST-LIST/POST" mode="rss1_moreposts"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- 
	
	-->
	<xsl:template match="POST" mode="rdf_resource_moreposts">
		<rdf:li rdf:resource="{$thisserver}{$root}F{THREAD/@FORUMID}?thread={THREAD/@THREADID}"/>
	</xsl:template>
	<!-- 
	
	-->
	<xsl:template match="POST" mode="rss1_moreposts">
		<item rdf:about="{$thisserver}{$root}F{THREAD/@FORUMID}?thread={THREAD/@THREADID}" xmlns="http://purl.org/rss/1.0/">
			<title>
				<xsl:value-of select="THREAD/SUBJECT"/>
			</title>

			<link>
				<xsl:value-of select="$thisserver"/>
				<xsl:value-of select="$root"/>F<xsl:value-of select="THREAD/@FORUMID"/>?thread=<xsl:value-of select="THREAD/@THREADID"/>
			</link>
			<dc:date>
				<xsl:apply-templates select="THREAD/REPLYDATE/DATE" mode="dc"/>
			</dc:date>
		</item>
	</xsl:template>
</xsl:stylesheet>
