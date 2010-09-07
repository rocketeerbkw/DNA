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
 
    doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"
    doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"/>
	
	<xsl:variable name="serverPath">
		<xsl:choose>
			<xsl:when test="contains(/H2G2/SERVERNAME, 'OPS')">
				<xsl:value-of select="/H2G2/SITECONFIG/PATHDEV"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="/H2G2/SITECONFIG/PATHLIVE"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
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
          <xsl:text>BBC - iPlayer Message Board - </xsl:text>
          <xsl:apply-templates select="." mode="head_title_page" />
        </title>
        <meta name="description" content="Search and browse frequently asked questions"/>
        <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1"/>
        <link rel="schema.dcterms" href="http://purl.org/dc/terms/" />
        <meta name="dcterms.created" content="2008-06-15" />
        
        <xsl:comment>#set var="blq_identity" value="on"</xsl:comment>
        <xsl:comment>#set var="blq_nav_color" value="magenta"</xsl:comment>
        <xsl:comment>#set var="blq_footer_color" value="black"</xsl:comment>
        <xsl:comment>#set var="bbcpage_survey" value="no"</xsl:comment>
        <xsl:comment>#include virtual="/includes/blq/include/blq_head.sssi"</xsl:comment>

  <xsl:text disable-output-escaping="yes">
    <![CDATA[
    
    <!--[if IE]><![if (IE 6)|(IE 7)]><![endif]-->
<link rel="stylesheet" href="http://iplayerhelp.external.bbc.co.uk/clients/bbciplayer/main.css" type="text/css" />
<!--[if IE]><![endif]><![endif]-->
<!--[if (IE 6)|(IE 7)]><style type="text/css" media="screen">
html {font-size:125%;}
body {font-size:50%;}
</style><![endif]-->
<!--[if IE]><![if gte IE 6]><![endif]-->
<style type="text/css">@import 'http://iplayerhelp.external.bbc.co.uk/clients/bbciplayer/iplayer_styles.css'; </style>
<!--[if IE]><![endif]><![endif]-->

<link rel="stylesheet" type="text/css" media="print" href="http://iplayerhelp.external.bbc.co.uk/clients/bbciplayer/iplayer_print.css"/>
<!--[if lt IE 7]>
<link rel="stylesheet" type="text/css" media="screen" href="http://iplayerhelp.external.bbc.co.uk/clients/bbciplayer/iplayer_ie.css" />
<![endif]-->
<!--[if IE 5]>
<link rel="stylesheet" type="text/css" media="screen" href="http://iplayerhelp.external.bbc.co.uk/clients/bbciplayer/iplayer_ie5.css" />
<![endif]-->
<!--[if IE 7]>
<link rel="stylesheet" type="text/css" media="screen" href="http://iplayerhelp.external.bbc.co.uk/clients/bbciplayer/iplayer_ie7.css" />
<![endif]-->

    ]]>
  </xsl:text>
  
      <script type="text/javascript" src="http://www.bbc.co.uk/glow/gloader.js"><xsl:text> </xsl:text></script>
      <script type="text/javascript" src="/dnaimages/javascript/DNA.js"><xsl:text> </xsl:text></script>
      
      <link type="text/css" media="screen" rel="stylesheet" href="/dnaimages/iplayer/dna_messageboard/style/iplayer_messageboard.2.0.rc2.css"/>
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
<xsl:text disable-output-escaping="yes">
<![CDATA[    
<!--<![endif]-->
]]>
</xsl:text>

    <xsl:comment>#include virtual="/includes/blq/include/blq_body_first.sssi"</xsl:comment>
  	
 	
          <div id="header">
            <p id="membership">
            <xsl:if test="SITE/IDENTITYSIGNIN != 1">
              <xsl:apply-templates select="VIEWING-USER" mode="library_memberservice_status" />
            </xsl:if>
            </p>
               <h1>
                  <a href="http://www.bbc.co.uk/iplayer">
                    <img id="logo" src="http://www.bbc.co.uk/iplayer/img/iplayer_logo.gif" alt="BBC iPlayer" width="99" height="32" />
                  </a>
               </h1>
            <div id="tagline">
              <h2><xsl:call-template name="boardclosed"/></h2>
              <p>This message board is  <a class="popup" href="http://www.bbc.co.uk/messageboards/newguide/popup_checking_messages.html#B" target="_blank">post-moderated</a></p>
            </div>
          </div>   
          <div id="searchNav">
          <ul class="breadcrumbs">
            <xsl:apply-templates select="." mode="breadcrumbs"/>
          </ul>
        </div>
        
        <div id="blq-local-nav">
          <ul>
            <li class="sidePanel">
              <ul class="globalNav">
                <li>
                  <a href="http://www.bbc.co.uk/iplayer/">iPlayer Home</a>
                </li>
                <li id="modNav">
                  <a href="http://iplayerhelp.external.bbc.co.uk/help/" >iPlayer Help and FAQ</a>
                </li>
              </ul>
          </li>
          <li class="sidePanel">
            <ul id="nav">
            	<li>
            		<a href="{$root}">
            			<xsl:if test="/H2G2/@TYPE = 'FRONTPAGE' or /H2G2/@TYPE = 'USERDETAILS' or /H2G2/@TYPE = 'MOREPOSTS'">
            				<xsl:attribute name="class"><xsl:text>current-section</xsl:text></xsl:attribute>
            			</xsl:if>
            			<xsl:text>Message Board Topics</xsl:text>
            		</a>
            	</li>
              <xsl:apply-templates select="TOPICLIST/TOPIC" mode="object_topic_title">
                <xsl:sort data-type="number" select="TOPICID" order="ascending"/>
              </xsl:apply-templates>
            </ul>
          </li>
          <xsl:if test="/H2G2/VIEWING-USER/USER">
            <li class="sidePanel">
              <ul id="nav">
                <li>
                  <a href="{$root}/MP{/H2G2/VIEWING-USER/USER/USERID}">
                    My Discussions
                  </a>
                </li>
              </ul>
            </li>
          </xsl:if>
          <li class="sidePanel">
            <ul id="extraNav">
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
          </li>
          <xsl:call-template name="library_userstate_editor">
            <xsl:with-param name="loggedin">
              <li class="sidePanel">
                
                <ul class="globalNav">
                  <li>
                    <a href="{$root}/boards-admin/messageboardadmin">Messageboard Admin</a>
                  </li>
                  <xsl:if test="/H2G2/VIEWING-USER/USER/STATUS = 2" >
                    <li>
                      <a href="{$root}/boards-admin/siteoptions">Site Options</a>
                    </li>
                  </xsl:if>
                </ul>
              </li>  
            </xsl:with-param>
          </xsl:call-template>
      </ul>
    </div>
<!--left hand column Content - ends-->
<!-- maincontent begins -->
    <div id="blq-content">
      <xsl:attribute name="class">
        <xsl:apply-templates select="/H2G2/@TYPE" mode="library_string_stringtolower"/>
      </xsl:attribute>  
      
      <div id="theContent">
        <xsl:apply-templates select="." mode="page"/>
      </div>    <!--  closes thecontent  -->
      
    </div>    <!--  closes maincontent  -->

<xsl:comment>#include virtual="/includes/blq/include/blq_body_last.sssi"</xsl:comment>

  <script type="text/javascript">
    if (identity.cta) {
       identity.cta.parseLinks = function() {}
    }
  </script>

</body>
</html>
</xsl:template>
	
	<xsl:template name="boardclosed">
		<xsl:choose>
			<xsl:when test="$boardClosed = 'true'">
				The <xsl:value-of select="/H2G2/SITECONFIG/BOARDNAME"/> message board is currently closed for posting. It is open daily from 8am - 10pm
			</xsl:when>
			<xsl:otherwise>
				This message board is open daily from 8am - 10pm
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
</xsl:stylesheet>
