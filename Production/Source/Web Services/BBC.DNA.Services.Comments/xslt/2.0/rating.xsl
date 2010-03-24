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
	
	<xsl:import href="ratinginfo.xsl"/>
	<xsl:include href="createdupdated.xsl"/>
	<xsl:include href="user.xsl"/>
	
	<doc:documentation>
		<doc:purpose>
			Style a rating in a thread
		</doc:purpose>
		<doc:context>
			The rating we're styling.
		</doc:context>
		<doc:notes>
			returns A rating (as contained in a thread of ratings)
		</doc:notes>
		<doc:author>
			Laura Porter
		</doc:author>
	</doc:documentation>
	
	<xsl:template match="rating">
		<xsl:choose>
			<xsl:when test="parent::thread">
				<div class="dna-rating">
					<xsl:apply-templates select="created">
						<xsl:with-param name="element" select="'span'"/>
					</xsl:apply-templates>
					<xsl:text> by </xsl:text>
					<xsl:apply-templates select="user">
						<xsl:with-param name="element" select="'span'"/>
					</xsl:apply-templates>
				</div>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-imports/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>
