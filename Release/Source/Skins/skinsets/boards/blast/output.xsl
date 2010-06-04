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
	
	<xsl:variable name="serverPath">
		<xsl:choose>
			<xsl:when test="contains(/H2G2/SERVERNAME, 'OPS') or contains(/H2G2/SERVERNAME, 'VP-DEV-DNA-WEB')">
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
          <xsl:text>BBC - Blast Message Board - </xsl:text>
          <xsl:apply-templates select="." mode="head_title_page" />
        </title>
        <meta content="Blast aims to inspire and motivate young people to develop their creative talents and showcase their art, dance, film, music, writing, games and fashion on a range of digital platforms." name="description"/>
        <meta content="BBC, blast, teens, art, dance, film, music, writing, games, fashion games, mobile, downloads, message boards, creative, tips, tools, ideas, inspiration, careers, workshops, interviews, free, things to do, events, tutorials, mentors, advice, help" name="keywords"/>
        <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1"/>
        <link rel="schema.dcterms" href="http://purl.org/dc/terms/" />
        <meta name="dcterms.created" content="2008-06-15" />
        
        <xsl:comment>#set var="blq_identity" value="on"</xsl:comment>
        <xsl:comment>#set var="blq_nav_color" value="teal"</xsl:comment>
        <xsl:comment>#set var="blq_footer_color" value="black"</xsl:comment>
        <xsl:comment>#set var="bbcpage_survey" value="no"</xsl:comment>
        
        <xsl:comment>#include virtual="/includes/blq/include/blq_head.sssi"</xsl:comment>
      
      <script type="text/javascript" src="http://www.bbc.co.uk/glow/gloader.js">
        <xsl:text> </xsl:text>
      </script>
      <script type="text/javascript" src="/dnaimages/javascript/DNA.js">
        <xsl:text> </xsl:text>
      </script>
      
      <script type="text/javascript">
        if (identity.cta) {
           identity.cta.parseLinks = function() {}
        }
      </script>
      
      <link type="text/css" media="screen" rel="stylesheet">
	<xsl:choose>
		<xsl:when test="contains(/H2G2/SERVERNAME, 'OPS') or contains(/H2G2/SERVERNAME, 'VP-DEV-DNA-WEB')">
			<xsl:attribute name="href"><xsl:value-of select="/H2G2/SITECONFIG/PATHDEV"/><xsl:value-of select="/H2G2/SITECONFIG/CSSLOCATION"/></xsl:attribute>
		</xsl:when>
		<xsl:otherwise>
			<xsl:attribute name="href"><xsl:value-of select="/H2G2/SITECONFIG/PATHLIVE"/><xsl:value-of select="/H2G2/SITECONFIG/CSSLOCATION"/></xsl:attribute>
		</xsl:otherwise>
	</xsl:choose>
      </link>
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
               <h1 id="logo">
                
               </h1>
            <div id="blq-global-nav">
              <xsl:comment>#include virtual="/blast/msgbd_v2/inc/global_nav.sssi"</xsl:comment>
            </div>
            <div id="tagline">
              <p>This message board is  <a class="popup" href="http://www.bbc.co.uk/messageboards/newguide/popup_checking_messages.html#B" target="_blank">pre-moderated</a> - that means your messages get looked at by moderators before posting.</p>
            </div>
              <div id="openingtimes">
              <p>Opening times:</p>
              <p>Monday - Friday: 09:00 - 21:00</p>
              <p>Saturday - Sunday: 10:00 - 18:00</p>
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
                  <a href="{$root}">
                    <xsl:if test="/H2G2/@TYPE = 'FRONTPAGE' or /H2G2/@TYPE = 'USERDETAILS' or /H2G2/@TYPE = 'MOREPOSTS'">
                      <xsl:attribute name="class"><xsl:text>current-section</xsl:text></xsl:attribute>
                    </xsl:if>
                    <xsl:text>Message Board Topics</xsl:text>
                  </a>
                </li>
              </ul>
          </li>
          <li class="sidePanel">
            <ul id="nav">
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
              <li>
                <a href="http://www.bbc.co.uk/messageboards/newguide/popup_online_safety.html" class="popup" target="_blank">
                  Are you being safe online?
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
