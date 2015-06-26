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
			Style a commentForum OR a ratingForum
		</doc:purpose>
		<doc:context>
			Applied directly to the output from commentForum/ratingForum API call
		</doc:context>
		<doc:notes>
			returns A div containing all information about this commentForum/ratingForum
		</doc:notes>
		<doc:author>
			Laura Porter
		</doc:author>
	</doc:documentation>

	<xsl:output indent="yes" omit-xml-declaration="yes" method="xhtml" version="1.0" encoding="UTF-8"/>
	
	<xsl:include href="commentssummary.xsl"/>
	<xsl:include href="commentslist.xsl"/>
	<xsl:include href="commentinfo.xsl"/>
	<xsl:include href="common.xsl"/>
	
	<xsl:template match="/">
		<xsl:apply-templates/>
	</xsl:template>
	
	<xsl:template match="commentForum | ratingForum">
		<a name="dna-comments-top"></a>
		<div id="dna-{lower-case(local-name())}">
			<xsl:apply-templates select="commentsSummary | ratingsSummary"/>
			<xsl:apply-templates select="commentsList | ratingsList"/>
		</div>
	</xsl:template>
	
	<xsl:template match="comments | ratings">
		<xsl:apply-templates/>
	</xsl:template>
	
</xsl:stylesheet>
