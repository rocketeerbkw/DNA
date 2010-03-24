<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<xsl:template name="ARTCHECK_MAINBODY">
		<xsl:for-each select="FAILED">
Failed article: 
<A target="_blank" href="{$root}A{@ID}">A<xsl:value-of select="@ID"/>
			</A>
 (<A target="_blank" HREF="http://bbc.h2g2.com/A{@ID}">old code</A>) 
<br/>
		</xsl:for-each>
	</xsl:template>
</xsl:stylesheet>