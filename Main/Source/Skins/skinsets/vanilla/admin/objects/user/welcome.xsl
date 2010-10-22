<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	version="1.0"
	xmlns:doc="http://www.bbc.co.uk/dna/documentation"
	xmlns="http://www.w3.org/1999/xhtml"
	exclude-result-prefixes="doc">

	<xsl:template match="USER" mode="objects_user_welcome">
		<div class="dna-fl dna-main-left">
			<p>Hello, <xsl:value-of select="USERNAME" />! Which <xsl:value-of select="$dashboardtype" /> do you want to see?</p>
		</div>
	</xsl:template>
</xsl:stylesheet>
