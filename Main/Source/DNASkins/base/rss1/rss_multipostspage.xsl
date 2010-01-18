<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" exclude-result-prefixes="msxsl local s dt">
	<!-- 
	
	-->
	<!-- 
	
	-->
	<xsl:template name="MULTIPOSTS_RSS1">
		<xsl:param name="mod"/>
		<xsl:choose>
			<xsl:when test="$mod='items'">
				<items xmlns="http://purl.org/rss/1.0/">
					<rdf:Seq>
						<xsl:apply-templates select="FORUMTHREADPOSTS/POST" mode="rdf_resource_multipostspage"/>
					</rdf:Seq>
				</items>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="FORUMTHREADPOSTS/POST" mode="rss1_multipostspage"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- 
	
	-->
	<xsl:template match="POST" mode="rdf_resource_multipostspage">
		<rdf:li rdf:resource="{$thisserver}{$root}F{/H2G2/FORUMTHREADPOSTS/@FORUMID}?thread={/H2G2/FORUMTHREADPOSTS/@THREADID}#p{@POSTID}"/>
	</xsl:template>
	<!-- 
	
	-->
	<xsl:template match="POST" mode="rss1_multipostspage">
		<item rdf:about="{$thisserver}{$root}F{/H2G2/FORUMTHREADPOSTS/@FORUMID}?thread={/H2G2/FORUMTHREADPOSTS/@THREADID}#p{@POSTID}" xmlns="http://purl.org/rss/1.0/">
			<xsl:element name="title" namespace="{$thisnamespace}">
				<xsl:call-template name="validChars">
					<xsl:with-param name="string" select="SUBJECT"/>
				</xsl:call-template>

			</xsl:element>
			<xsl:element name="description" namespace="{$thisnamespace}">
				<xsl:call-template name="validChars">
					<xsl:with-param name="string" select="TEXT"/>
				</xsl:call-template>
			</xsl:element>
			<xsl:element name="link" namespace="{$thisnamespace}">
				<xsl:value-of select="$thisserver"/>
				<xsl:value-of select="$root"/>F<xsl:value-of select="/H2G2/FORUMTHREADPOSTS/@FORUMID"/>?thread=<xsl:value-of select="/H2G2/FORUMTHREADPOSTS/@THREADID"/>#p<xsl:value-of select="@POSTID"/>
			</xsl:element>
			<dc:date>
				<xsl:apply-templates select="DATEPOSTED/DATE" mode="dc"/>
			</dc:date>
		</item>
	</xsl:template>
</xsl:stylesheet>
