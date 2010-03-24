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
			Style a ratingsList
		</doc:purpose>
		<doc:context>
			
		</doc:context>
		<doc:notes>
			Just imports commentslist.xsl. Builder expects an XSLT with the same name as the class it's transforming. 
		</doc:notes>
		<doc:author>
			Laura Porter
		</doc:author>
	</doc:documentation>
	
	<xsl:include href="commentslist.xsl"/>

</xsl:stylesheet>
