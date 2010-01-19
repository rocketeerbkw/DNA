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
			Style a commentsSummary OR ratingsSummary node.
		</doc:purpose>
		<doc:context>
			The node we're styling.
		</doc:context>
		<doc:notes>
			
		</doc:notes>
		<doc:author>
			Laura Porter
		</doc:author>
	</doc:documentation>
	
	<xsl:output indent="yes" omit-xml-declaration="yes" method="xhtml" version="1.0" encoding="UTF-8"/>
	
	<xsl:template match="commentsSummary">
		<xsl:choose>
			<xsl:when test="not(lower-case(../commentsList/filterBy) = 'none')">
				<!-- don't output, we're using the filterby count instead anything -->
			</xsl:when>
			<xsl:otherwise>
				<p id="dna-commentsSummary">
					<xsl:value-of select="concat(total, ' comment', if (total = 1) then '' else 's')"/>
				</p>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="ratingsSummary">
		<p id="dna-ratingsSummary">
			<xsl:text>Average rating: </xsl:text>
			<span class="average"><xsl:value-of select="total"/></span>
			<xsl:text> out of </xsl:text>
			<span class="outof">5</span>
		</p>
	</xsl:template>

</xsl:stylesheet>
