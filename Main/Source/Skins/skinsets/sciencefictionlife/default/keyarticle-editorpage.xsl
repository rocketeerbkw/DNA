<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	
	<xsl:template name="KEYARTICLE-EDITOR_MAINBODY">
		<style type="text/css">
		<xsl:comment>
		@import url(http://www.bbc.co.uk/mysciencefictionlife/includes/sciencefiction.css);	
		</xsl:comment>
		</style>

<!-- v3 ADDED CSS CODE PER LUKE'S REQUEST -->
		<xsl:comment>[if lte IE 6]&gt;

			<style media="all" type="text/css">
			@import url(http://www.bbc.co.uk/mysciencefictionlife/includes/sciencefiction_ie6.css);
			</style>

		&lt;![endif]</xsl:comment>
		<xsl:apply-templates select="KEYARTICLEFORM"/>
		<br/>
		<xsl:apply-templates select="KEYARTICLELIST"/>
	</xsl:template>
	

</xsl:stylesheet>