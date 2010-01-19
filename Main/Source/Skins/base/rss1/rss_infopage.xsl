<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" exclude-result-prefixes="msxsl local s dt">
	
	<!--
		<xsl:variable name="rss1_infopagecomments">
		Author:		Rich Caudle
		Puprose:	This variable will contain the list of comments to be output in the feed
	-->
	<xsl:variable name="rss1_infopagecomments">
		
		<xsl:for-each select="/H2G2/INFO/RECENTCONVERSATIONS/RECENTCONVERSATION[FIRSTSUBJECT='No subject']">
			<xsl:sort order="descending" select="DATEPOSTED/DATE/@SORT" />
			<xsl:copy-of select="."/>
		</xsl:for-each>	
		
	</xsl:variable>
	
	<!-- 
	
	-->
	<xsl:template name="INFO_RSS1">
		<xsl:param name="mod"/>
		<xsl:choose>
			<xsl:when test="$mod='items'">
				<items xmlns="http://purl.org/rss/1.0/">
					<rdf:Seq>
						<xsl:choose>
							<!-- Comments feed -->
							<xsl:when test="key('feedtype', 'editorial-comments')">
								<xsl:apply-templates select="msxsl:node-set($rss1_infopagecomments)/*[position() &lt;= $rss_maxitems]" mode="rdf_resource_infopage"/>
							</xsl:when>
							<xsl:when test="INFO/RECENTCONVERSATIONS/RECENTCONVERSATION">
								<xsl:apply-templates select="INFO/RECENTCONVERSATIONS/RECENTCONVERSATION" mode="rdf_resource_infopage"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:apply-templates select="INFO/FRESHESTARTICLES/RECENTARTICLE" mode="rdf_resource_infopage"/>
							</xsl:otherwise>
						</xsl:choose>
					</rdf:Seq>
				</items>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<!-- Comments feed -->
					<xsl:when test="key('feedtype', 'editorial-comments')">
						<xsl:apply-templates select="msxsl:node-set($rss1_infopagecomments)/*[position() &lt;= $rss_maxitems]" mode="rss1_infopage"/>
					</xsl:when>
					<xsl:when test="INFO/RECENTCONVERSATIONS/RECENTCONVERSATION">
						<xsl:apply-templates select="INFO/RECENTCONVERSATIONS/RECENTCONVERSATION" mode="rss1_infopage"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="INFO/FRESHESTARTICLES/RECENTARTICLE" mode="rss1_infopage"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- 
	
	-->
	<xsl:template match="RECENTCONVERSATION" mode="rdf_resource_infopage">
		<rdf:li rdf:resource="{$thisserver}{$root}F{FORUMID}?thread={THREADID}"/>
	</xsl:template>
	<!-- 
	
	-->
	<xsl:template match="RECENTARTICLE" mode="rdf_resource_infopage">
		<rdf:li rdf:resource="{$thisserver}{$root}A{H2G2ID}"/>
	</xsl:template>
	<!-- 
	
	-->
	<xsl:template match="RECENTCONVERSATION" mode="rss1_infopage">
		<item rdf:about="{$thisserver}{$root}F{FORUMID}?thread={THREADID}" xmlns="http://purl.org/rss/1.0/">
			<title>
				<xsl:call-template name="validChars">
					<xsl:with-param name="string" select="FIRSTSUBJECT"/>
				</xsl:call-template>
		
			</title>
			<link>
				<xsl:value-of select="concat($thisserver, $root, 'F', FORUMID, '?thread=', THREADID)"/>
			</link>
			<dc:date>
				
				<xsl:apply-templates select="DATEPOSTED/DATE" mode="dc"/>
			</dc:date>
		</item>

	</xsl:template>
	<!-- 
	
	-->
	<xsl:template match="RECENTARTICLE" mode="rss1_infopage">
		<item rdf:about="{$thisserver}{$root}A{H2G2ID}" xmlns="http://purl.org/rss/1.0/">
			<title>
				<xsl:call-template name="validChars">
					<xsl:with-param name="string" select="SUBJECT"/>
				</xsl:call-template>
				
			</title>
			<link>
				<xsl:value-of select="concat($thisserver, $root, 'A', H2G2ID)"/>
			</link>
			<dc:date>
			
				<xsl:apply-templates select="DATEUPDATED/DATE" mode="dc"/>
			</dc:date>
		</item>
	</xsl:template>
</xsl:stylesheet>
