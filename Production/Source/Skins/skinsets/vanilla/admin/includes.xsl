<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:msxsl="urn:schemas-microsoft-com:xslt"  xmlns:doc="http://www.bbc.co.uk/dna/documentation" exclude-result-prefixes="msxsl doc">
   
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

  <xsl:variable name="configuration" select="msxsl:node-set($skin)/configuration" />

  <xsl:include href="../../../common/2/includes.xsl" />

  <xsl:include href="pages/messageboardadmin.xsl"/>
  <xsl:include href="pages/mbbackuprestore.xsl"/>
  <xsl:include href="pages/messageboardadmin_design.xsl"/>
  <xsl:include href="pages/messageboardadmin_assets.xsl"/>
  <xsl:include href="pages/topicbuilder.xsl"/>
  <!-- xsl:include href="pages/frontpagelayout.xsl"/ -->
  <xsl:include href="pages/lightboxes.xsl"/>
  <xsl:include href="pages/error.xsl"/>
  <xsl:include href="pages/messageboardschedule.xsl"/>
  <xsl:include href="pages/commentforumlist.xsl"/>

  <xsl:include href="objects/topiclist.xsl"/>
    
</xsl:stylesheet>