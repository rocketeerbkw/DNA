<?xml version="1.0" encoding="ISO-8859-1"?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
	<!ENTITY raquo "&#187;">
]>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<xsl:template name="NOTFOUND_CSS">
		<LINK href="{$csssource}life.css" rel="stylesheet"/>
	</xsl:template>
	<xsl:template name="NOTFOUND_MAINBODY">
		<div class="chapter">Page not found</div>
		<div class="content">
			<p>Tim Berners-Lee is widely credited with inventing the <a href="{$root}A157466">Internet</a>. Strangely, no one seems to know who invented the PAGE NOT FOUND error message, which is a shame as we should probably thank him or her for at least taking the trouble to explain that something isn't how it should be.</p>
<p>Not entirely coincidentally, we're sorry to say we're unable to bring you the entry you were looking for at this time.</p>

<p>Please try later - we apologise for the inconvenience.</p>
		</div>
	</xsl:template>

</xsl:stylesheet>
