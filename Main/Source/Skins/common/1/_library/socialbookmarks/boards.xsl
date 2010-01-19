<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	version="1.0" 
	xmlns:doc="http://www.bbc.co.uk/dna/documentation"  
	xmlns="http://www.w3.org/1999/xhtml"
	exclude-result-prefixes="doc">
	
	<doc:documentation>
		<doc:purpose>
			Displays the social networking toolbar for a messageboard
		</doc:purpose>
		<doc:context>
			Called on request by skin
		</doc:context>
		<doc:notes>
			
		</doc:notes>
	</doc:documentation>
	
	<xsl:template name="library_socialbookmarks">
		<xsl:param name="title"/>
		<xsl:comment>#set var="blq_bookmarks" value="1"</xsl:comment>
		<xsl:comment>#set var="blq_bookmark_title" value="<xsl:value-of select="$title"/>"</xsl:comment>
	</xsl:template>

</xsl:stylesheet>
