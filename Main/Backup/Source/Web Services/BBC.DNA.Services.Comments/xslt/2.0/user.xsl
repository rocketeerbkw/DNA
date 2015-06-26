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
			Style a user node.
		</doc:purpose>
		<doc:context>
			The node we're styling.
		</doc:context>
		<doc:notes>
			param $avatarWidth The desired width of the avatar image (default: 50).
			param $avatarHeight The desired height of the avatar image (default: 50).
			returns A div containing the user's details.
		</doc:notes>
		<doc:author>
			Laura Porter
		</doc:author>
	</doc:documentation>
	
	<xsl:output indent="yes" omit-xml-declaration="yes" method="xhtml" version="1.0" encoding="UTF-8"/>
	
	<xsl:template match="user">
		<xsl:param name="avatarHeight" select="50"/>
		<xsl:param name="avatarWidth" select="50"/>
		<xsl:param name="element" select="'div'"/>
		<xsl:element name="{$element}">
			<xsl:attribute name="class" select="concat('dna-user ', if (editor = 'true') then 'editor' else '', if (notable = 'true') then 'notable' else '')"/>
			<!--<a href="/blogs/profile?userid={userId}" class="dna-user {if (editor = 'true') then 'editor' else ''} {if (notable = 'true') then 'notable' else ''}">
				<xsl:if test="exists(avatar) and avatar/text()">
					<img src="{avatar}" alt="{displayName}" width="{$avatarWidth}" height="{$avatarHeight}"/>
				</xsl:if>
				<span><xsl:value-of select="displayName"/></span>
			</a>-->
			<span><xsl:value-of select="displayName"/></span>
		</xsl:element>
	</xsl:template>

</xsl:stylesheet>
