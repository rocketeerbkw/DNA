<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	version="1.0"
	xmlns:doc="http://www.bbc.co.uk/dna/documentation"
	xmlns="http://www.w3.org/1999/xhtml"
	exclude-result-prefixes="doc">

	<xsl:template match="ACTIONITEM" mode="objects_moderator_actionitemtotal">
		<span class="dna-actionitem-total">(<xsl:value-of select="TOTAL" />)</span>
	</xsl:template>

  <xsl:template match="ACTIONITEMS" mode="objects_moderator_allactionitemtotal">
  	<xsl:variable name="total" select="ACTIONITEM[TYPE = 'EmbeddedComments']/TOTAL + ACTIONITEM[TYPE = 'Community']/TOTAL + ACTIONITEM[TYPE = 'Messageboard']/TOTAL + ACTIONITEM[TYPE = 'Blog']/TOTAL" />
  	<span class="dna-actionitem-total">(<xsl:value-of select="$total" />)</span>
  </xsl:template>

  
	
</xsl:stylesheet>