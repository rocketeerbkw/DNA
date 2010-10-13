<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">
	
	<doc:documentation>
		<doc:purpose>
			String url encode
		</doc:purpose>
		<doc:context>
			Skin wide
		</doc:context>
		<doc:notes>
			Horrible and clunky, but the best you can do in XSLT1.0
			
		</doc:notes>
	</doc:documentation>
	
	
	<xsl:template name="library_string_urlencode">
		<xsl:param name="string"/>
		<xsl:choose>
			<xsl:when test="starts-with($string, 'http://')">
				<xsl:call-template name="library_string_searchandreplace">
					<xsl:with-param name="str" select="concat('http%3A%2F%2F', substring-after($string, 'http://'))"/>
					<xsl:with-param name="search" select="'/'"/>
					<xsl:with-param name="replace" select="'%2F'"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="starts-with($string, 'https://')">
				<xsl:call-template name="library_string_searchandreplace">
					<xsl:with-param name="str" select="concat('https%3A%2F%2F', substring-after($string, 'https://'))"/>
					<xsl:with-param name="search" select="'/'"/>
					<xsl:with-param name="replace" select="'%2F'"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="library_string_searchandreplace">
					<xsl:with-param name="str" select="$string"/>
					<xsl:with-param name="search" select="'/'"/>
					<xsl:with-param name="replace" select="'%2F'"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>
