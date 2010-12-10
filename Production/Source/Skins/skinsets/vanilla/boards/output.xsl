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
      method="html"
      version="4.0"
      omit-xml-declaration="yes"
      standalone="yes"
      indent="yes"
      encoding="ISO8859-1"
      doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"
      doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"
    />
    
	<xsl:variable name="serverPath">
		<xsl:choose>
			<xsl:when test="contains(/H2G2/SERVERNAME, 'OPS')">
				<xsl:value-of select="/H2G2/SITECONFIG/PATHDEV"/>
			</xsl:when>
			<xsl:when test="contains(/H2G2/SERVERNAME, 'NARTHUR5')">
				<xsl:value-of select="/H2G2/SITECONFIG/PATHDEV"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="/H2G2/SITECONFIG/PATHLIVE"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<xsl:variable name="socialbookmark_url">
		<xsl:apply-templates select="/H2G2" mode="library_memberservice_ptrt"/>
	</xsl:variable>
	
	<xsl:variable name="page_title">
		<xsl:apply-templates select="/H2G2" mode="head_title_page"/>
	</xsl:variable>
	
	<xsl:variable name="socialbookmark_title" select="concat('BBC - ', /H2G2/SITECONFIG/BOARDNAME, ' messageboards - ', $page_title)"/>
	
	<xsl:template match="H2G2[PARAMS/PARAM[NAME = 's_partial']/VALUE = 1]">
		<xsl:apply-templates select="." mode="page"/>
	</xsl:template>
	
    <xsl:template match="H2G2">
      <xsl:variable name="lower_sitename">
        <xsl:apply-templates select="SITECONFIG/BOARDNAME" mode="library_string_stringtolower"/>
      </xsl:variable>
    	
      <html xml:lang="en-GB" lang="en-GB">
      	<head profile="http://dublincore.org/documents/dcq-html/">
      		
      		<title>
      			<xsl:value-of select="$socialbookmark_title" />
      		</title>
      		
      		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
      		<meta name="description" content="" />
      		<meta name="keywords" content="" />
      		<link rel="schema.dcterms" href="http://purl.org/dc/terms/" />
      		<link type="image/x-icon" href="/favicon.ico" rel="icon"/>
      		<meta name="DCTERMS.created" content="2006-09-15T12:00:00Z" />
      		<meta name="DCTERMS.modified" content="2006-09-15T12:35:00Z" />
      		<meta name="Author"><xsl:attribute name="content"><xsl:value-of select="$configuration/general/skinAuthor"/></xsl:attribute></meta>
      		
      		<xsl:choose>
      			<xsl:when test="SITE/IDENTITYSIGNIN = 1">
      				<xsl:comment>#set var="blq_identity" value="on"</xsl:comment>
      			</xsl:when>
      			<xsl:otherwise>
      				<xsl:comment>#set var="blq_identity" value="off"</xsl:comment>
      			</xsl:otherwise>
      		</xsl:choose>
      		
      		<xsl:choose>
      			<xsl:when test="SITECONFIG/BLQ-NAV-COLOR">
      				<xsl:comment>#set var="blq_nav_color" value="<xsl:value-of select="SITECONFIG/BLQ-NAV-COLOR"/>"</xsl:comment>
      			</xsl:when>
      			<xsl:otherwise>
      				<xsl:comment>#set var="blq_nav_color" value="blue"</xsl:comment>
      			</xsl:otherwise>
      		</xsl:choose>
      		
      		<xsl:if test="SITECONFIG/BLQ-FOOTER-COLOR">
      			<xsl:comment>#set var="blq_footer_color" value="<xsl:value-of select="SITECONFIG/BLQ-FOOTER-COLOR"/>"</xsl:comment>
      		</xsl:if>
      		
      		<xsl:if test="SITE/SITEOPTIONS/SITEOPTION[NAME = 'IsKidsSite']/VALUE = 1">
      			<xsl:comment>#set var="blq_variant" value="cbbc" </xsl:comment>
      			<xsl:comment>#set var="blq_search_scope" value="cbbc" </xsl:comment>
      		</xsl:if>
      		
      		<xsl:comment>#include virtual="/includes/blq/include/blq_head.sssi"</xsl:comment>
      		
      		<script type="text/javascript" src="http://www.bbc.co.uk/glow/gloader.js"><xsl:text> </xsl:text></script>
      		<script type="text/javascript" src="/dnaimages/javascript/DNA.js"><xsl:text> </xsl:text></script>
      		<script type="text/javascript" src="/dnaimages/javascript/previewmode.js"><xsl:text> </xsl:text></script>
      		
      		<!-- disable Identity JavaScript for now -->
      		<script type="text/javascript">
      			if (identity.cta) {
      			identity.cta.parseLinks = function() {}
      			}
      		</script>
      		
      		<link type="text/css" media="screen" rel="stylesheet" href="/dnaimages/dna_messageboard/style/generic_messageboard.css"/>
      		<xsl:if test="SITECONFIG/CSSLOCATION and SITECONFIG/CSSLOCATION != ''">
      			<xsl:choose>
      				<xsl:when test="starts-with(SITECONFIG/CSSLOCATION, '/dnaimages/')">
      					<!-- LPorter: this is a mini-hack. Basically, if the CSSLOCATION starts with '/dnaimages/', it means that we've put in a full path to a location we (at DNA) have access to. ie. we've developed the CSS ourselves.
      						If it doesn't, then assume the messageboard owners are hosting the CSS file on their own dev/live spaces -->
      					<link type="text/css" media="screen" rel="stylesheet" href="{SITECONFIG/CSSLOCATION}"/>
      				</xsl:when>
      				<xsl:otherwise>
      					<link type="text/css" media="screen" rel="stylesheet" href="{$serverPath}{SITECONFIG/CSSLOCATION}"/>
      				</xsl:otherwise>
      			</xsl:choose>
      		</xsl:if>
      		
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
      		<xsl:if test="PREVIEWMODE = 1">
      			<xsl:attribute name="onload">previewmode();</xsl:attribute>
      		</xsl:if>
      		
      		<xsl:text disable-output-escaping="yes">
      			<![CDATA[    
<!--<![endif]-->
]]>
      		</xsl:text>
      		
      		<xsl:comment>#include virtual="/includes/blq/include/blq_body_first.sssi"</xsl:comment>
      		
      		<xsl:if test="SERVERNAME = 'NARTHUR5' or not(contains(SERVERNAME, 'NARTHUR'))">
      			<div id="logintrouble">
      				Having trouble logging in? <a href="{$root}/MP0?s_mode=login">Log in here</a>.
      			</div>
      		</xsl:if>
      		
      		<div id="header">
      			<h1 id="logo">
      				<xsl:choose>
      					<xsl:when test="SITECONFIG/SITELOGO and SITECONFIG/SITELOGO != ''">
      						<img src="{SITECONFIG/SITELOGO}" alt="{SITECONFIG/BOARDNAME}">
      							<xsl:attribute name="height">
      								<xsl:choose>
      									<xsl:when test="SITECONFIG/SITELOGOHEIGHT and SITECONFIG/SITELOGOHEIGHT != ''"><xsl:value-of select="SITECONFIG/SITELOGOHEIGHT"/></xsl:when>
      									<xsl:otherwise>34</xsl:otherwise>
      								</xsl:choose>
      							</xsl:attribute>
      						</img>
      					</xsl:when>
      					<xsl:when test="SITECONFIG/IMAGEBANNER and SITECONFIG/IMAGEBANNER != ''">
      						<img src="{SITECONFIG/IMAGEBANNER}" alt="{SITECONFIG/BOARDNAME}"/>
      					</xsl:when>
      					<xsl:when test="SITECONFIG/BOARDNAME and SITECONFIG/BOARDNAME != ''">
      						<span><xsl:value-of select="SITECONFIG/BOARDNAME"/></span>
      					</xsl:when>
      				</xsl:choose>
      			</h1>
      			<div class="openingtimes">
      				<xsl:call-template name="boardclosed"/>
      				<xsl:choose>
      					<xsl:when test="/H2G2/SITE/MODERATIONSTATUS = 1">
      						<p>This message board is <a href="http://www.bbc.co.uk/messageboards/newguide/popup_checking_messages.html#B" class="popup">post-moderated</a>.</p>
      					</xsl:when>
      					<xsl:when test="/H2G2/SITE/MODERATIONSTATUS = 2">
      						<p>This message board is <a href="http://www.bbc.co.uk/messageboards/newguide/popup_checking_messages.html#B" class="popup">pre-moderated</a>.</p>
      					</xsl:when>
      					<xsl:otherwise>
      						<p>This message board is <a href="http://www.bbc.co.uk/messageboards/newguide/popup_checking_messages.html#B" class="popup">reactively moderated</a>.</p>
      					</xsl:otherwise>
      				</xsl:choose>
      			</div>
      		</div>
      		
      		<div class="breadcrumbs">
      			<ul class="breadcrumbs">
      				<xsl:apply-templates select="." mode="breadcrumbs"/>
      			</ul>
      		</div>
      		
      		<div style="clear:both;"> <xsl:comment> leave this </xsl:comment> </div>
      		
      		<div id="blq-local-nav">
      			
      			<xsl:if test="SITECONFIG/NAVLHN/* or SITECONFIG/LOCALNAV/*">
      				<div class="extranav">
      					<xsl:copy-of select="(SITECONFIG/LOCALNAV/* | SITECONFIG/NAVLHN/*)[1]"/>
      				</div>
      			</xsl:if>

      			<xsl:if test="SITECONFIG/SITEHOME and SITECONFIG/SITEHOME != ''">
      				<ul class="navigation sitehome">
      					<li>
      						<a href="{SITECONFIG/SITEHOME}"><xsl:value-of select="SITECONFIG/BOARDNAME"/> Home</a>
      					</li>
      				</ul>
      			</xsl:if>
      			
      			<xsl:if test="TOPICLIST/TOPIC">
      				<ul class="navigation topics">
      					<xsl:apply-templates select="TOPICLIST/TOPIC" mode="object_topic_title"/>
      				</ul>
      			</xsl:if>
      			
      			
      			<ul class="navigation general">
      				<xsl:if test="/H2G2/VIEWING-USER/USER">
      					<li id="mydiscussions">
      						<a href="{$root}/MP{/H2G2/VIEWING-USER/USER/USERID}">My Discussions</a>
      					</li>
      				</xsl:if>
      				<li>
      					<a href="http://www.bbc.co.uk/messageboards/newguide/popup_house_rules.html" class="popup" target="_blank">House Rules</a>
      				</li>
      				<li>
      					<a href="http://www.bbc.co.uk/messageboards/newguide/popup_faq_index.html" class="popup" target="_blank">Message Board FAQs</a>
      				</li>
      				<xsl:variable name="currentSite" select="CURRENTSITE"/>
      				<xsl:if test="SITE[@ID='$currentSite']/SITEOPTIONS/SITEOPTION[NAME='IsKidsSite']/VALUE='1'">
      					<li>
      						<a href="http://www.bbc.co.uk/messageboards/newguide/popup_online_safety.html" class="popup" target="_blank">Are you being safe online?</a>
      					</li>
      				</xsl:if>
      			</ul>
      			
      			<xsl:call-template name="library_userstate_editor">
      				<xsl:with-param name="loggedin">
      					<ul class="navigation admin">
      						<li>
      							<xsl:choose>
      								<xsl:when test="contains(/H2G2/SERVERNAME, 'NARTHUR5')">
      									<a href="http://dna-extdev.bbc.co.uk/dna/{SITECONFIG/BOARDROOT}boards-admin/messageboardadmin">Messageboard Admin</a>
      								</xsl:when>
      								<xsl:otherwise>
      									<a href="/dna/{SITECONFIG/BOARDROOT}boards-admin/messageboardadmin">Messageboard Admin</a>
      								</xsl:otherwise>
      							</xsl:choose>
      						</li>
      						<xsl:if test="/H2G2/VIEWING-USER/USER/STATUS = 2" >
      							<li>
      								<a href="/dna/{SITECONFIG/BOARDROOT}boards-admin/siteoptions">Site Options</a>
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
      		
      		<div id="dna-boardpromo">
      			<xsl:choose>
      				<xsl:when test="FORUMSOURCE/ARTICLE/BOARDPROMO">
	      				<xsl:apply-templates select="FORUMSOURCE/ARTICLE/BOARDPROMO" mode="object_promo"/>
      				</xsl:when>
      				<xsl:when test="TEXTBOXLIST/TEXTBOX[TEXT]">
      					<xsl:apply-templates select="TEXTBOXLIST/TEXTBOX" mode="object_textbox">
      						<xsl:sort select="FRONTPAGEPOSITION" data-type="number"/>
      					</xsl:apply-templates>
      				</xsl:when>
      			</xsl:choose>
      			<xsl:comment> promo </xsl:comment>
      		</div>
      		
      		<xsl:if test="SERVERNAME = 'NARTHUR5' or not(contains(SERVERNAME, 'NARTHUR'))">
	      		<xsl:call-template name="library_socialbookmarks">
	      			<xsl:with-param name="title" select="$socialbookmark_title"/>
	      		</xsl:call-template>
      		</xsl:if>
      		
      		<xsl:comment>#include virtual="/includes/blq/include/blq_body_last.sssi"</xsl:comment>
      		
      	</body>
      </html>
      
    </xsl:template>
    
    <xsl:template name="boardclosed">
			<xsl:choose>
				<xsl:when test="$boardClosed = 'true'">
					<p id="boardclosed">The message board is currently closed for posting.</p>
				</xsl:when>
				<xsl:otherwise>
					<!-- Board open message goes here if desired -->
				</xsl:otherwise>
			</xsl:choose>
	</xsl:template>
    
</xsl:stylesheet>
