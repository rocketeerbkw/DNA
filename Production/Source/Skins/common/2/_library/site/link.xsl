<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">
	
	<doc:documentation>
		<doc:purpose>
			Site name and link to site
		</doc:purpose>
		<doc:context>
			Called on request by skin
		</doc:context>
		<doc:notes>
			
		</doc:notes>
	</doc:documentation>
	
	<xsl:template match="SITEID" mode="library_site_link">
		<xsl:variable name="siteId" select="."/>
		<a href="{concat($host, '/dna/', /H2G2/SITE-LIST/SITE[@ID = $siteId]/NAME)}"><xsl:value-of select="/H2G2/SITE-LIST/SITE[@ID = $siteId]/SHORTNAME"/></a>
	</xsl:template>

</xsl:stylesheet>
