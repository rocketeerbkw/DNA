<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	version="1.0" 
	xmlns:msxsl="urn:schemas-microsoft-com:xslt"  
	xmlns:doc="http://www.bbc.co.uk/dna/documentation" 
	exclude-result-prefixes="msxsl doc">
   
    <doc:documentation>
        <doc:purpose>
            Site specific master include file.
        </doc:purpose>
        <doc:context>
            Included at the top of the kick-off page (e.g. output.xsl)
        </doc:context>
        <doc:notes>
            Pulls in site specific configuration, page and object
            markup files and all common skin-wide XSL logic.
        </doc:notes>
    </doc:documentation>
   
    <xsl:include href="../../../common/configuration.xsl"/>
    <xsl:include href="../configuration.xsl"/>
    
    <xsl:variable name="configuration" select="msxsl:node-set($skin)/configuration" />
    
    <xsl:include href="../../../common/1/includes.xsl" />
    
    <xsl:include href="utils.xsl"/>
    
    <xsl:include href="pages/frontpage.xsl" />
    <xsl:include href="pages/blogsummary.xsl" />
    <xsl:include href="pages/morecomments.xsl" />
	<xsl:include href="pages/moreposts.xsl" />
    <xsl:include href="pages/commentbox.xsl" />
    <xsl:include href="pages/multiposts.xsl" />
    <xsl:include href="pages/morearticlesubscriptions.xsl"/>
    <xsl:include href="pages/morelinks.xsl"/>
	<xsl:include href="pages/threads.xsl"/>
    
    <xsl:include href="objects/commentforum-item.xsl" />
	<xsl:include href="objects/list.xsl" />
	<xsl:include href="objects/post/generic.xsl" />
	<xsl:include href="objects/post/first.xsl" />
	<xsl:include href="objects/thread/thread.xsl" />
	<xsl:include href="objects/user/inline.xsl" />
	
    
</xsl:stylesheet>