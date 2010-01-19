<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<!--
	template: Status Page
	This template matches the output of the status page and ensures that the output
	is kept as simple as possible, i.e. no graphics or javascript
	Generic
	-->
	<xsl:template match='H2G2[@TYPE="STATUSPAGE"]'>
		<html>
			<head>
				<title>Ripley Status Report</title>
			</head>
			<body>
				<h1>Status: <xsl:value-of select="/H2G2/STATUS-REPORT/STATUS"/>
				</h1>
				<b>
					<xsl:value-of select="/H2G2/STATUS-REPORT/MESSAGE"/>
					<br/>
			Computer name: <xsl:value-of select="/H2G2/SERVERNAME"/>
				</b>
			</body>
		</html>
	</xsl:template>

</xsl:stylesheet>