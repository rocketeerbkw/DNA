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
			Style a created or updated node from a commentForumList or commentList etc
		</doc:purpose>
		<doc:context>
			The node whose updated/created dates we're styling. This assumes the context has a child node named at.
		</doc:context>
		<doc:notes>
			param $context Pass in a node to style, otherwise this template uses the context it was called against.
			param $dateTimeFormat The picture string the time will be formatted against (XSLT2.0 picture format).
			param $text The text to be used in the output, e.g. "Created on", "Last updated on".
			returns A p containing when the context item was last updated/created, and how long ago (if it was created/updated less than a month ago).
		</doc:notes>
		<doc:author>
			Laura Porter
		</doc:author>
	</doc:documentation>
	
	<xsl:output indent="yes" omit-xml-declaration="yes" method="xhtml" version="1.0" encoding="UTF-8"/>
	
	<xsl:include href="formatDateTime.xsl"/>
	
	<xsl:variable name="now" select="current-dateTime()"/>
	
	<xsl:template match="created | updated">
		<xsl:param name="context" select="."/>
		<xsl:param name="dateTimeFormat" select="'[D]/[M]/[Y], [H01]:[m01]'"/>
		<xsl:param name="text" select="if (local-name($context) = 'created') then 'Created on' else 'Last updated on'"/>
		<xsl:param name="element" select="'p'"/>
		<xsl:element name="{$element}">
			<xsl:attribute name="id" select="concat('dna-', local-name($context))"/>
			<xsl:variable name="time" select="dna:formatDateTime($context/at)"/>
			<xsl:value-of select="$text"/><xsl:text> </xsl:text><xsl:value-of select="format-dateTime($time, $dateTimeFormat)"/>
			<xsl:if test="ago and not(empty(ago))">
				<xsl:text> </xsl:text><span class="ago"><xsl:value-of select="concat('(', ago, ')')"/></span>
			</xsl:if>
		</xsl:element>
	</xsl:template>

</xsl:stylesheet>
