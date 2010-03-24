<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" exclude-result-prefixes="msxsl local s dt">
	<!-- 
	
	-->
	<xsl:template name="JOURNAL_RSS1">
		<xsl:param name="mod"/>
		<xsl:choose>
			<xsl:when test="$mod='items'">
				<items xmlns="http://purl.org/rss/1.0/">
					<rdf:Seq>
				
						<xsl:apply-templates select="JOURNAL/JOURNALPOSTS/POST" mode="rdf_resource_journal"/>
					</rdf:Seq>
				</items>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="JOURNAL/JOURNALPOSTS/POST" mode="rss1_journal"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- 
	
	-->
	<xsl:template match="POST" mode="rdf_resource_journal">
		<rdf:li rdf:resource="{$thisserver}{$root}MJ{/H2G2/JOURNAL/@USERID}?Journal={../@FORUMID}#p{@POSTID}"/>
	</xsl:template>
	<!-- 
	
	-->

	<xsl:template match="POST" mode="rss1_journal">
		<item rdf:about="{$thisserver}{$root}MJ{/H2G2/JOURNAL/@USERID}?Journal={../@FORUMID}#p{@POSTID}" xmlns="http://purl.org/rss/1.0/">
			<title>
				<xsl:value-of select="SUBJECT"/>
			</title>
			<description>
				<xsl:variable name="current_post">
					<xsl:copy-of select="TEXT/node()"/>
				</xsl:variable>
				<xsl:apply-templates select="msxsl:node-set($current_post)//text()[not(preceding::BR)]" mode="first_line"/>
				<!-- Only the text before the fist br tag. Use a variable so the 'preceding' axis is local to the current TEXT element -->
			</description>
			<link>
				<xsl:value-of select="$thisserver"/>
				<xsl:value-of select="$root"/>MJ<xsl:value-of select="/H2G2/JOURNAL/@USERID"/>?Journal=<xsl:value-of select="../@FORUMID"/>#p<xsl:value-of select="@POSTID"/>
			</link>
			<dc:date>
				<xsl:apply-templates select="DATEPOSTED/DATE" mode="dc"/>
			</dc:date>
		</item>
	</xsl:template>
</xsl:stylesheet>
