<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">
	
	<doc:documentation>
		<doc:purpose>
			Transforms textbox into to a promo!
		</doc:purpose>
		<doc:context>
			Applied on frontpage
		</doc:context>
		<doc:notes>
		</doc:notes>
	</doc:documentation>
	
	
	<xsl:template match="TEXTBOX" mode="object_textbox">
		<xsl:if test="TEXT">
			<div class="dna-promocontainer frontpage">
				<xsl:copy-of select="TEXT/node()"/>
			</div>
		</xsl:if>
	</xsl:template>
	
</xsl:stylesheet>