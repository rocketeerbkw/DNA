<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:dna="BBC.Dna.Api"
	xmlns:doc="http://www.bbc.co.uk/dna/documentation"
	xmlns="http://www.w3.org/1999/xhtml"
	exclude-result-prefixes="xs dna doc"
	xpath-default-namespace="BBC.Dna.Api"
	version="2.0">
	
	<doc:documentation>
		<doc:purpose>
			Style a commentsList
		</doc:purpose>
		<doc:context>
			
		</doc:context>
		<doc:notes>
			returns A ul containing all information about this commentsList
		</doc:notes>
		<doc:author>
			Laura Porter
		</doc:author>
	</doc:documentation>
	
	<xsl:include href="paging.xsl"/>
	
	<xsl:template match="commentsList | ratingsList">
		<xsl:if test="not(lower-case(filterBy) = 'none')">
			<p id="dna-filtered-total {lower-case(filterBy)}">
				<xsl:value-of select="concat(totalCount, ' comment', if (total = 1) then '' else 's')"/>
			</p>
		</xsl:if>
		<ul id="dna-{lower-case(local-name())}">
			<xsl:apply-templates/>
		</ul>
		<xsl:call-template name="paging"/>
	</xsl:template>

</xsl:stylesheet>
