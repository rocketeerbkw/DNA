<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	version="1.0"  
	xmlns:doc="http://www.bbc.co.uk/dna/documentation"  
	exclude-result-prefixes="doc">
	
	<doc:documentation>
		<doc:purpose>
			HTML Layout for pages of type 'threads'
		</doc:purpose>
		<doc:context>
			Called by output.xsl
		</doc:context>
		<doc:notes>
			Output from here ends up between the document body tag 
		</doc:notes>
	</doc:documentation>
	

	<xsl:template match="/H2G2[@TYPE = 'THREADS']" mode="page">        
		<title><xsl:value-of select="FORUMSOURCE/ARTICLE/SUBJECT"/></title>
		<description><xsl:value-of select="FORUMSOURCE/ARTICLE/SUBJECT"/> - forum threads</description>
		<link><xsl:value-of select="concat($server, $root, '/F', FORUMTHREADS/@FORUMID)"/></link>
		<docs>http://www.bbc.co.uk/dna/documentation/</docs>
		<ttl>60</ttl>
		<language>en-gb</language>
		<lastBuildDate>Wed, 4 Jul 2007 08:02:48 GMT</lastBuildDate>
		<xsl:apply-templates select="FORUMTHREADS/THREAD" mode="object_thread" />
	</xsl:template>
	
	
</xsl:stylesheet>
