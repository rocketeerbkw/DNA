<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<xsl:import href="../base-threadspage.xsl"/>
	<!-- 
	
	-->
<xsl:template name="THREADS_RSS">
		<xsl:apply-templates select="FORUMTHREADS/THREAD" mode="rss91_threadspage"/>
	</xsl:template>
	<!-- 
	
	-->
	<xsl:template match="THREAD" mode="rss91_threadspage">
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
</xsl:stylesheet>
