<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	version="1.0" 
	xmlns:doc="http://www.bbc.co.uk/dna/documentation"  
	exclude-result-prefixes="doc">
	
	<doc:documentation for="/sites/MySite/objects/post/generic.xsl">
		<doc:purpose>
			Holds the generic XML construction of a post
		</doc:purpose>
		<doc:context>
			Called by object-post (_common/_logic/_objects/post.xsl)
		</doc:context>
		<doc:notes>
			
		</doc:notes>
	</doc:documentation>
	
	
	<xsl:template match="THREAD" mode="object_thread">
		
		<item>
			<title>
				<xsl:value-of select="SUBJECT"/>
			</title>
			<description>  
				<xsl:value-of select="TOTALPOSTS"/>
				<xsl:text> post</xsl:text><xsl:if test="TOTALPOSTS != 1">s</xsl:if>
				<xsl:text>, last updated </xsl:text>
				<xsl:value-of select="LASTPOST/DATE/@RELATIVE"/>
			</description>   
			<link><xsl:value-of select="concat($server, $root, '/F', parent::FORUMTHREADS/@FORUMID, '?thread=', @THREADID)"/></link>
		</item>
		
	</xsl:template>
</xsl:stylesheet>
