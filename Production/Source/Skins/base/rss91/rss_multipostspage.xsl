<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<xsl:import href="../base-multipostspage.xsl"/>
	<!-- 
	
	-->
	<xsl:template name="MULTIPOSTS_RSS">
		<xsl:apply-templates select="FORUMTHREADPOSTS/POST" mode="rss91"/>
	</xsl:template>
	<!-- 
	
	-->
	<xsl:template match="POST" mode="rss91">
		<item>
			<title>
				<xsl:value-of select="SUBJECT"/>
			</title>
			<description>
				<xsl:value-of select="TEXT"/>
			</description>
			<link>
				<xsl:value-of select="$thisserver"/>
				<xsl:value-of select="$root"/>F<xsl:value-of select="/H2G2/FORUMTHREADPOSTS/@FORUMID"/>?thread=<xsl:value-of select="/H2G2/FORUMTHREADPOSTS/@THREADID"/>#p<xsl:value-of select="@POSTID"/>
			</link>
		</item>
	</xsl:template>
</xsl:stylesheet>
