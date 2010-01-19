<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<xsl:template name="DIAGNOSE_SUBJECT">
		<xsl:call-template name="SUBJECTHEADER">
			<xsl:with-param name="text">
				<xsl:value-of select="ARTICLE/SUBJECT"/>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template name="DIAGNOSE_MAINBODY">
		<font face="{$fontface}" color="{$mainfontcolour}">
			<DIV>
				<xsl:apply-templates select="/H2G2/ARTICLE/GUIDE/BODY"/>
			</DIV>
		</font>
	</xsl:template>
</xsl:stylesheet>