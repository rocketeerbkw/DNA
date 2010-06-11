<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns="http://www.w3.org/1999/xhtml" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    version="1.0" 
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" 
    xmlns:doc="http://www.bbc.co.uk/dna/documentation" 
    exclude-result-prefixes="msxsl doc">
    
  <xsl:include href="includes.xsl"/>
  
  <xsl:output
    method="xml"
    version="1.0"
    omit-xml-declaration="yes"
    standalone="yes"
    indent="yes"
    encoding="ISO8859-1"
    doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"
    doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"/>
	
	<xsl:variable name="discussion">
		<xsl:choose>
			<xsl:when test="/H2G2/SITECONFIG/TEXTVARIANTS/DISCUSSION/text()">
				<xsl:value-of select="/H2G2/SITECONFIG/TEXTVARIANTS/DISCUSSION"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>discussion</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<xsl:variable name="message">
		<xsl:choose>
			<xsl:when test="/H2G2/SITECONFIG/TEXTVARIANTS/MESSAGE/text()">
				<xsl:value-of select="/H2G2/SITECONFIG/TEXTVARIANTS/MESSAGE"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>message</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<xsl:variable name="reply">
		<xsl:choose>
			<xsl:when test="/H2G2/SITECONFIG/TEXTVARIANTS/REPLY/text()">
				<xsl:value-of select="/H2G2/SITECONFIG/TEXTVARIANTS/REPLY"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>reply</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<xsl:variable name="replies">
		<xsl:choose>
			<xsl:when test="/H2G2/SITECONFIG/TEXTVARIANTS/REPLIES/text()">
				<xsl:value-of select="/H2G2/SITECONFIG/TEXTVARIANTS/REPLIES"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>replies</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
    
  <xsl:template match="H2G2">
    <html lang="en" xmlns="http://www.w3.org/1999/xhtml" xml:lang="en">
      <head>
        <title>
          <xsl:text>BBC - The Apprentice Message Board - </xsl:text>
          <xsl:apply-templates select="." mode="head_title_page" />
        </title>
        <meta content="The Apprentice and Alan Sugar return for another series in 2009 on BBC Two" name="description"/>
        <meta content="Apprentice, Alan Sugar, contestants, Comic Relief, News Alert, Mash up Clip, The Firings" name="keywords"/>
        <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1"/>
        <link rel="schema.dcterms" href="http://purl.org/dc/terms/" />
        <meta name="dcterms.created" content="2008-06-15" />
        
        <xsl:comment>#set var="blq_identity" value="off"</xsl:comment>
        <xsl:comment>#set var="blq_nav_color" value="blue"</xsl:comment>
        <xsl:comment>#set var="blq_footer_color" value="grey"</xsl:comment>
        <xsl:comment>#set var="bbcpage_survey" value="no"</xsl:comment>
        
        <xsl:comment>#include virtual="/includes/blq/include/blq_head.sssi"</xsl:comment>
      
      <script type="text/javascript" src="http://www.bbc.co.uk/glow/gloader.js"></script>
      <script type="text/javascript" src="/dnaimages/javascript/DNA.js"></script>
      
      <link type="text/css" rel="stylesheet" href="http://www.bbc.co.uk/apprentice/styles/apprentice.css"/>
      <link type="text/css" media="screen" rel="stylesheet" href="/dnaimages/apprentice/style/apprentice_messageboard.css"/>
      
      
      <xsl:text disable-output-escaping="yes">
     <![CDATA[    
     <!--[if IE 7]>
     <style>
      #blq-main #header {
        height: 190px;
      }
       </style>
      <![endif]-->
    ]]>
    </xsl:text>
   
      
   </head>
<xsl:text disable-output-escaping="yes">
<![CDATA[    
<!--[if IE]>
  <body class="ie">
<![endif]-->    
<!--[if !IE]>-->
]]>
</xsl:text>

  <body>
  <xsl:attribute name="id"><xsl:apply-templates select="/H2G2/@TYPE" mode="library_string_stringtolower"/></xsl:attribute>
<xsl:text disable-output-escaping="yes">
<![CDATA[    
<!--<![endif]-->
]]>
</xsl:text>

    <xsl:comment>#include virtual="/includes/blq/include/blq_body_first.sssi"</xsl:comment>
          <div id="header">
               <h1 id="logo">
                
               </h1>
               <div id="app-content">
                <xsl:comment>#include virtual="/apprentice/series5/includes/mb_localnav.sssi"</xsl:comment>
               </div>
               
              <div id="membership-top"></div>
              <div id="membership">
                <xsl:apply-templates select="VIEWING-USER" mode="library_memberservice_status" />
              </div>
              <div id="membership-bottom"></div>
              
            <div id="tagline">
              <p> Opening hours: 8am until 12pm everyday (The message board is <a class="popup" href="http://www.bbc.co.uk/messageboards/newguide/popup_checking_messages.html#B" target="_blank">reactively moderated</a>)</p>
            </div>
          </div>   
          <div id="searchNav">
          <ul class="breadcrumbs">
            <xsl:apply-templates select="." mode="breadcrumbs"/>
          </ul>
        </div>
        
        <div id="blq-local-nav">
          <div class="app-right-pod-top"></div>
          <ul class="navigation">
              <li>
                <a href="{$root}">
                  <xsl:if test="/H2G2/@TYPE = 'FRONTPAGE' or /H2G2/@TYPE = 'USERDETAILS' or /H2G2/@TYPE = 'MOREPOSTS'">
                    <xsl:attribute name="class"><xsl:text>current-section</xsl:text></xsl:attribute>
                  </xsl:if>
                  <xsl:text>Message Board Topics</xsl:text>
                </a>
                <ul>
                  <xsl:apply-templates select="TOPICLIST/TOPIC" mode="object_topic_title">
                    <xsl:sort data-type="number" select="TOPICID" order="ascending"/>
                  </xsl:apply-templates>
                </ul>
              </li>
            </ul>
          <div class="app-right-pod-foot"></div>
            
          <div class="app-right-pod-top"></div>
            <ul class="navigation">
              <xsl:if test="/H2G2/VIEWING-USER/USER">
                <li>
                  <a href="{$root}/MP{/H2G2/VIEWING-USER/USER/USERID}">
                    My Discussions
                  </a>
                </li>
              </xsl:if>
              <li>
                <a href="{$houserulespopupurl}" class="popup" target="_blank">
                  House Rules
                </a>
              </li>
              <li>
                <a href="{$faqpopupurl}" class="popup" target="_blank">
                  Message Board FAQs
                </a>
              </li>
            </ul>
          <div class="app-right-pod-foot"></div>
            
           
            <xsl:call-template name="library_userstate_editor">
              <xsl:with-param name="loggedin">
                <ul class="admin-navigation">
                  <li>
                    <a href="{$root}/boards-admin/messageboardadmin">Messageboard Admin</a>
                  </li>
                  <xsl:if test="/H2G2/VIEWING-USER/USER/STATUS = 2" >
                    <li>
                      <a href="{$root}/boards-admin/siteoptions">Site Options</a>
                    </li>
                  </xsl:if>
                </ul>
              </xsl:with-param>
            </xsl:call-template>
          
    </div>

    <div id="blq-content">
      <xsl:attribute name="class">
        <xsl:apply-templates select="/H2G2/@TYPE" mode="library_string_stringtolower"/>
      </xsl:attribute>  
      
        <xsl:apply-templates select="." mode="page"/>
      
    </div>  

<xsl:comment>#include virtual="/includes/blq/include/blq_body_last.sssi"</xsl:comment>

</body>
</html>
</xsl:template>
	
  <xsl:template name="boardclosed">
    <xsl:choose>
      <xsl:when test="$boardClosed = 'true'">
        The <xsl:value-of select="/H2G2/SITECONFIG/BOARDNAME"/> message board is currently closed for posting.
      </xsl:when>
      <xsl:otherwise>
        <!-- Board open message goes here if desired -->
      </xsl:otherwise>
    </xsl:choose>
</xsl:template>
	
</xsl:stylesheet>
