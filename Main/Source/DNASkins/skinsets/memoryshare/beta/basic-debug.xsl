<?xml version="1.0" encoding="iso-8859-1"?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">

	<!-- DEBUG toggles -->
	<xsl:variable name="DEBUG">0</xsl:variable>
	<xsl:variable name="VARIABLETEST">0</xsl:variable>
	<xsl:variable name="TESTING">0</xsl:variable>


	<!-- TRACE/DEBUG -->
	<xsl:template name="TRACE">
	<xsl:param name="message" />
	<xsl:param name="pagename" />
	<xsl:if test="$DEBUG = 1 or /H2G2/PARAMS/PARAM[NAME = 's_debug']/VALUE = '1'">
	<div class="debug">
	Template name: <b><xsl:value-of select="$message" /></b><br />
	Stylesheet name: <b><xsl:value-of select="$pagename" /></b><br />
	page type: <strong><xsl:value-of select="/H2G2/@TYPE" /></strong>
	<xsl:if test="/H2G2/@TYPE='ARTICLE'">
	(type = <xsl:value-of select="/H2G2/ARTICLE/EXTRAINFO/TYPE/@ID"/>, status = <xsl:value-of select="/H2G2/ARTICLE/ARTICLEINFO/STATUS/@TYPE"/> )
	</xsl:if>
	</div>
	</xsl:if>
	</xsl:template>
</xsl:stylesheet>
