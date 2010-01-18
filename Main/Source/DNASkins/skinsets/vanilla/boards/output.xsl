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
      encoding="UTF-8"
      doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"
      doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"
    />
	
	<xsl:variable name="abc" select="'abcdefghijklmnopqrstuvwxyz'"/>
	<xsl:variable name="ABC" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>
    
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
	
	<xsl:variable name="ptrt">
		<xsl:apply-templates select="/H2G2" mode="library_memberservice_ptrt"/>
	</xsl:variable>
	
	<xsl:variable name="page_title">
		<xsl:apply-templates select="/H2G2" mode="head_title_page"/>
	</xsl:variable>
	
	<xsl:variable name="socialbookmark_title" select="concat('BBC - ', /H2G2/SITECONFIG/BOARDNAME, ' messageboards - ', $page_title)"/>
	
	<xsl:variable name="smileys">
		<xsl:choose>
			<xsl:when test="/H2G2/EMOTICONLOCATION = 1">
				<xsl:value-of select="concat($serverPath, 'images/emoticons/f_')"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$configuration/assetPaths/smileys"/>
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
      		
      		<xsl:if test="SITECONFIG/BLQ-FOOTER-LINKS">
      			<xsl:for-each select="SITECONFIG/BLQ-FOOTER-LINKS/*">
      				<xsl:comment>#set var="<xsl:value-of select="translate(translate(local-name(), '-', '_'), $ABC, $abc)"/>" value="<xsl:value-of select="translate(translate(., '-', '_'), $ABC, $abc)"/>"</xsl:comment>
      			</xsl:for-each>
      		</xsl:if>
      		<!-- eg: -->
      		<!--#set var="blq_footer_link_url_1" value="/site_url1/" -->
      		<!--#set var="blq_footer_link_text_1" value="First local link" -->
      		
      		<xsl:comment>#include virtual="/includes/blq/include/blq_head.sssi"</xsl:comment>
      		
      		<script type="text/javascript" src="http://www.bbc.co.uk/glow/gloader.js"><xsl:text> </xsl:text></script>
      		<script type="text/javascript" src="http://www.bbc.co.uk/dnaimages/javascript/DNA.js"><xsl:text> </xsl:text></script>
      		<script type="text/javascript" src="http://www.bbc.co.uk/dnaimages/javascript/previewmode.js"><xsl:text> </xsl:text></script>
      		
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

      		
      		<div id="header">
      			<h1 id="logo" class="banner">
      			<xsl:choose>
      				<xsl:when test="SITECONFIG/HEADER and SITECONFIG/HEADER/text()">
	      				<xsl:comment>#include virtual="<xsl:value-of select="SITECONFIG/HEADER"/>"</xsl:comment>
      				</xsl:when>
      				<xsl:otherwise>
      					<span><xsl:value-of select="SITECONFIG/BOARDNAME"/></span>
      				</xsl:otherwise>
      			</xsl:choose>
      			</h1>
      		</div>
      		
      		<xsl:if test="not(/H2G2/@TYPE = 'FRONTPAGE')">
      			<div class="breadcrumbs">
	      			<ul class="breadcrumbs">
	      				<xsl:apply-templates select="." mode="breadcrumbs"/>
	      			</ul>
	      		</div>
      		</xsl:if>
      		
      		
      		<div style="clear:both;"> <xsl:comment> leave this </xsl:comment> </div>
      		
      		<div id="blq-local-nav">
      			
      			<xsl:choose>
      				<xsl:when test="SITECONFIG/NAVLHN/* or SITECONFIG/LOCALNAV/*">
      					<!-- deprecated; use the next match -->
      					<div class="extranav horizontalnav">
	      					<xsl:copy-of select="(SITECONFIG/LOCALNAV/* | SITECONFIG/NAVLHN/*)[1]"/>
	      				</div>
      				</xsl:when>
      				<xsl:when test="SITECONFIG/NAVHORIZONTAL">
      					<xsl:comment>#include virtual="<xsl:value-of select="SITECONFIG/NAVHORIZONTAL"/>"</xsl:comment>
      				</xsl:when>
      			</xsl:choose>
      			
      			<xsl:if test="SITECONFIG/LHN1 and SITECONFIG/LHN1/text()">
      				<xsl:comment>#include virtual="<xsl:value-of select="SITECONFIG/LHN1"/>"</xsl:comment>
      			</xsl:if>
      			
      			<xsl:if test="TOPICLIST/TOPIC">
      				<ul class="navigation topics">
      					<li class="navhome">Messageboard Home</li>
      					<xsl:apply-templates select="TOPICLIST/TOPIC" mode="object_topic_title"/>
      				</ul>
      			</xsl:if>
      			
      			<ul class="navigation general">
      				<xsl:if test="/H2G2/VIEWING-USER/USER">
      					<li id="mydiscussions">
      						<a href="{$root}/MP{/H2G2/VIEWING-USER/USER/USERID}">My <xsl:value-of select="$discussion"/>s</a>
      					</li>
      				</xsl:if>
      				<li>
      					<a href="{$houserulespopupurl}" class="popup" target="_blank">House Rules</a>
      				</li>
      				<li>
      					<a href="{$faqpopupurl}" class="popup" target="_blank">FAQs</a>
      				</li>
      				<xsl:variable name="currentSite" select="CURRENTSITE"/>
      				<xsl:if test="SITE[@ID='$currentSite']/SITEOPTIONS/SITEOPTION[NAME='IsKidsSite']/VALUE='1'">
      					<li>
      						<a href="http://www.bbc.co.uk/messageboards/newguide/popup_online_safety.html" class="popup" target="_blank">Are you being safe online?</a>
      					</li>
      				</xsl:if>
      			</ul>
      			
      			<xsl:if test="SITECONFIG/LHN2 and SITECONFIG/LHN2/text()">
      				<xsl:comment>#include virtual="<xsl:value-of select="SITECONFIG/LHN2"/>"</xsl:comment>
      			</xsl:if>
      			
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
      		
      		<div id="dna-about">
      			<h3>About this Board</h3>
      			<p>
      				<xsl:value-of select="SITECONFIG/ABOUTMESSAGE"/>
      			</p>
      			<div>
      				<xsl:call-template name="library_userstate">
      					<xsl:with-param name="loggedin">
      						<p>
      							You are currently signed in as <xsl:apply-templates select="/H2G2/VIEWING-USER/USER" mode="library_user_linked"/>.
      						</p>
      					</xsl:with-param>
      					<xsl:with-param name="unauthorised">
      						<xsl:text>You are currently signed in</xsl:text> 
      						<xsl:if test="/H2G2/VIEWING-USER/SIGNINNAME and /H2G2/VIEWING-USER/SIGNINNAME/text() != ''">
      							<xsl:text> as </xsl:text><xsl:value-of select="/H2G2/VIEWING-USER/SIGNINNAME"/>
      						</xsl:if>
      						<xsl:text> but have not yet completed the registration process. </xsl:text>
      						<a class="id-cta">
      							<xsl:call-template name="library_memberservice_require">
      								<xsl:with-param name="ptrt" select="$ptrt"/>
      							</xsl:call-template>
      							<xsl:text>Click here</xsl:text>
      						</a>
      						<xsl:text> to complete the registration process.</xsl:text>
      					</xsl:with-param>
      					<xsl:with-param name="loggedout">
      						<a class="id-cta identity-login">
      							<xsl:call-template name="library_memberservice_require">
      								<xsl:with-param name="ptrt" select="$ptrt"/>
      							</xsl:call-template>
      							<xsl:text>Sign in</xsl:text>
      						</a>
      						<xsl:text> or </xsl:text>
      						<a>
      							<xsl:attribute name="href">
      								<xsl:apply-templates select="/H2G2/VIEWING-USER" mode="library_memberservice_registerurl">
      									<xsl:with-param name="ptrt" select="$ptrt"/>
      								</xsl:apply-templates>
      							</xsl:attribute>
      							<xsl:text>register</xsl:text>
      						</a>
      						<xsl:text> to take part in </xsl:text><xsl:value-of select="$discussion"/><xsl:text>s.</xsl:text>
      					</xsl:with-param>
      				</xsl:call-template>
      			</div>
      			<hr> </hr>
      			<p>
      				<xsl:value-of select="SITECONFIG/OPENINGHOURS"/>
      			</p>
      		</div>
      		
      		<div id="dna-recentdiscussions">
      			<xsl:apply-templates select="TOP-FIVES" mode="object_top-fives_rhn">
      				<xsl:with-param name="name" select="'RecentDiscussions'"/>
      			</xsl:apply-templates>
      		</div>
      		
      		<!-- promos not needed any more? -->
      		<!--<div id="dna-boardpromo">
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
      		</div>-->
      		
      		<xsl:for-each select="SITECONFIG/PROMOS/*">
      			<xsl:comment>#include virtual="<xsl:value-of select="."/>"</xsl:comment>
      		</xsl:for-each>
      		
      		
      		<xsl:if test="SERVERNAME = 'NARTHUR5' or not(contains(SERVERNAME, 'NARTHUR'))">
	      		<xsl:if test="SITE/SITEOPTIONS/SITEOPTION[NAME = 'IsKidsSite']/VALUE != 1"> <!-- or add test for on/off switch -->
		      		<xsl:call-template name="library_socialbookmarks">
		      			<xsl:with-param name="title" select="$socialbookmark_title"/>
		      		</xsl:call-template>
	      		</xsl:if>
      		</xsl:if>
      		
      		<xsl:comment>#include virtual="/includes/blq/include/blq_body_last.sssi"</xsl:comment>
      		
      	</body>
      </html>
      
    </xsl:template>
    
    <xsl:template name="boardclosed">
			<xsl:choose>
				<xsl:when test="$boardClosed = 'true'">
					<p id="boardclosed">The messageboard is currently closed for posting.</p>
				</xsl:when>
				<xsl:otherwise>
					<!-- Board open message goes here if desired -->
				</xsl:otherwise>
			</xsl:choose>
	</xsl:template>
    
</xsl:stylesheet>
