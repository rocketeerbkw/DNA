<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:msxsl="urn:schemas-microsoft-com:xslt"  xmlns:doc="http://www.bbc.co.uk/dna/documentation" exclude-result-prefixes="msxsl doc">
   
    <doc:documentation>
        <doc:purpose>
            Site specific master include file.
        </doc:purpose>
        <doc:context>
            Included at the top of the kick-off page (e.g. /html.xsl, /rss.xsl etc)
        </doc:context>
        <doc:notes>
            Pulls in site specific configuration, page and object
            markup files and all common skin-wide XSL logic.
        </doc:notes>
    </doc:documentation>
    
      
    <!-- =================================================================================== Required === --> 
    <xsl:include href="../../../common/configuration.xsl"/>
    <xsl:include href="../configuration.xsl"/>
    <xsl:variable name="configuration" select="msxsl:node-set($skin)/configuration"></xsl:variable>
    
    <xsl:include href="../../../common/1/includes.xsl" />
    
    
    
    <!-- ===================================================================================== Markup === -->
    <!--   =============================================================== Pages ===                      -->
    
    <xsl:include href="pages/commentbox.xsl" />
    <xsl:include href="pages/commentforumlist.xsl" />
    
    <!--   ============================================================= Objects ===                      -->
    <xsl:include href="objects/post/comment.xsl" />
    <xsl:include href="objects/forumthreadposts.xsl" />
    <xsl:include href="objects/error/error.xsl" />    
    
    
    <!-- ===================================================================================== Special === -->
    <xsl:template match="*" mode="page" />
    
</xsl:stylesheet>