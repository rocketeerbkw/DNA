<?xml version="1.0" encoding="iso-8859-1"?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">

	<xsl:template match="H2G2[@TYPE='REDIRECT']" priority="2">
		<html>
			<head>
				<meta http-equiv="Cache-Control" content="no cache"/>
				<meta http-equiv="Pragma" content="no cache"/>
				<meta http-equiv="Expires" content="0"/>
				<!--[FIXME: deos not work? web server sendnig back 302 header anyway?]
				<xsl:choose>
					<xsl:when test="contains(REDIRECT-TO, 's_fromedit')">
						<meta>
							<xsl:attribute name="content">
								<xsl:text>0;</xsl:text>
								<xsl:text>url=</xsl:text>
								<xsl:value-of select="$typedarticle_thankyou_page"/>
							</xsl:attribute>
							<xsl:attribute name="http-equiv">REFRESH</xsl:attribute>
						</meta>
					</xsl:when>
					<xsl:otherwise>
						<meta>
							<xsl:attribute name="content">0;url=<xsl:value-of select="REDIRECT-TO"/></xsl:attribute>
							<xsl:attribute name="http-equiv">REFRESH</xsl:attribute>
						</meta>
					</xsl:otherwise>
				</xsl:choose>
				-->
				<meta>
					<xsl:attribute name="content">0;url=<xsl:value-of select="REDIRECT-TO"/></xsl:attribute>
					<xsl:attribute name="http-equiv">REFRESH</xsl:attribute>
				</meta>
				<title>
					<xsl:value-of select="$m_frontpagetitle"/>
				</title>
			</head>
			<body>
				Please wait while you are redirected...
			</body>
		</html>
	</xsl:template>
</xsl:stylesheet>
