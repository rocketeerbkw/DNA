<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<!--

	<xsl:template match='H2G2[@TYPE="REDIRECT"]'>

	Generic:	Yes
	Purpose:	uses META-refresh to redirect. Usually not needed.

-->
	<xsl:template match='H2G2[@TYPE="REDIRECT"]'>
		<html>
			<head>
				<meta>
					<xsl:attribute name="content">0;url=<xsl:value-of select="REDIRECT-TO"/></xsl:attribute>
					<xsl:attribute name="http-equiv">REFRESH</xsl:attribute>
				</meta>
			</head>
			<body bgcolor="{$bgcolour}" text="{$boxfontcolour}" MARGINHEIGHT="0" MARGINWIDTH="0" TOPMARGIN="0" LEFTMARGIN="0" link="{$linkcolour}" vlink="{$vlinkcolour}" alink="{$alinkcolour}">
				<FONT face="{$fontface}" SIZE="2">
Please wait, while your call is transferred...
</FONT>
			</body>
		</html>
	</xsl:template>

</xsl:stylesheet>