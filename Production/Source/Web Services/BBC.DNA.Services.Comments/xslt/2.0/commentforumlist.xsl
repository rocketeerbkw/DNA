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
			Style a commentForumList OR ratingForumList
		</doc:purpose>
		<doc:context>
			Applied directly to the output from commentForumList/ratingForumList API call
		</doc:context>
		<doc:notes>
			returns A div containing all information about this commentForumList/ratingForumList
		</doc:notes>
		<doc:author>
			Laura Porter
		</doc:author>
	</doc:documentation>
	
	<xsl:include href="paging.xsl"/>
	<xsl:include href="createdUpdated.xsl"/>
	<xsl:include href="commentssummary.xsl"/>
	
	<xsl:output indent="yes" omit-xml-declaration="yes" method="xhtml" version="1.0" encoding="UTF-8"/>
	
	<xsl:template match="/">
		<xsl:apply-templates select="commentForumList | ratingForumList"/>
	</xsl:template>
	
	<xsl:template match="commentForumList | ratingForumList">
		<div id="dna-commentForumList">
			<ul>
				<xsl:apply-templates select="commentForums | ratingForums"/>
			</ul>
			<xsl:call-template name="paging"/>
		</div>
	</xsl:template>
	
	<xsl:template match="commentForums | ratingForums">
		<xsl:apply-templates select="commentForum | ratingForum"/>
	</xsl:template>
	
	<xsl:template match="commentForum | ratingForum">
		<li class="dna-{local-name()} {if (isClosed = 'true') then ' closed' else ''}" id="{id}">
			<a href="{normalize-space(parentUri)}">
				<xsl:value-of select="title"/>
			</a>
			<div class="dna-{local-name()}Info">
				<xsl:apply-templates select="commentsSummary | ratingsSummary"/>
				<xsl:apply-templates select="created"/>
				<xsl:apply-templates select="updated"/>
				<xsl:apply-templates select="isClosed"/>
			</div>
		</li>
	</xsl:template>
	
	<xsl:template match="isClosed">
		<xsl:if test=". = 'true'">
			<p id="dna-{local-name()}Closed">
				This forum is closed.
			</p>	
		</xsl:if>
	</xsl:template>

</xsl:stylesheet>
