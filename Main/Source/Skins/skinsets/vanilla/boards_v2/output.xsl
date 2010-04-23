<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
	xmlns="http://www.w3.org/1999/xhtml" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	version="1.0" 
	xmlns:msxsl="urn:schemas-microsoft-com:xslt"
	xmlns:doc="http://www.bbc.co.uk/dna/documentation"
	xmlns:dt="urn:schemas-microsoft-com:datatypes" 
	exclude-result-prefixes="msxsl doc dt">
	
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
      			<xsl:when test="SITECONFIG/V2_BOARDS/HEADER_COLOUR">
      				<xsl:comment>#set var="blq_nav_color" value="<xsl:value-of select="SITECONFIG/V2_BOARDS/HEADER_COLOUR"/>"</xsl:comment>
      			</xsl:when>
      			<xsl:otherwise>
      				<xsl:comment>#set var="blq_nav_color" value="blue"</xsl:comment>
      			</xsl:otherwise>
      		</xsl:choose>
      		
      		<xsl:if test="SITECONFIG/V2_BOARDS/FOOTER/COLOUR">
      			<xsl:comment>#set var="blq_footer_color" value="<xsl:value-of select="SITECONFIG/V2_BOARDS/FOOTER/COLOUR"/>"</xsl:comment>
      		</xsl:if>
      		
      		<xsl:if test="SITE/SITEOPTIONS/SITEOPTION[NAME = 'IsKidsSite']/VALUE = 1">
      			<xsl:comment>#set var="blq_variant" value="cbbc" </xsl:comment>
      			<xsl:comment>#set var="blq_search_scope" value="cbbc" </xsl:comment>
      		</xsl:if>
      		
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
      		
      		<link type="text/css" media="screen" rel="stylesheet" href="/dna/dna_messageboard/css/generic_messageboard_v2.css"/>
      		<!-- <xsl:if test="SITECONFIG/CSSLOCATION and SITECONFIG/CSSLOCATION != ''">
      			<xsl:choose>
      				<xsl:when test="starts-with(SITECONFIG/CSSLOCATION, '/dnaimages/')">
      					 LPorter: this is a mini-hack. Basically, if the CSSLOCATION starts with '/dnaimages/', it means that we've put in a full path to a location we (at DNA) have access to. ie. we've developed the CSS ourselves.
      						If it doesn't, then assume the messageboard owners are hosting the CSS file on their own dev/live spaces
      					<link type="text/css" media="screen" rel="stylesheet" href="{SITECONFIG/CSSLOCATION}"/>
      				</xsl:when>
      				<xsl:otherwise>
      					<link type="text/css" media="screen" rel="stylesheet" href="{$serverPath}{SITECONFIG/CSSLOCATION}"/>
      				</xsl:otherwise>
      			</xsl:choose>
      		</xsl:if> -->
      		
      		<style type="text/css">    
      			div#blqx-bookmark {        
      				background-color:#fff; margin:0; border-top:1px solid #ccc    
      			}    
      			div#blqx-bookmark a, div#blqx-bookmark p {        
      				font-weight:normal; color: #000   
      			}    
      			div#blqx-bookmark a:hover {        
      				font-weight:normal; color: #666    
      			}</style>
      		
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
      		
      		<!-- <xsl:if test="SERVERNAME = 'NARTHUR5' or not(contains(SERVERNAME, 'NARTHUR'))">
      			<div id="logintrouble">
      				Having trouble logging in? <a href="{$root}/MP0?s_mode=login">Log in here</a>.
      			</div>
      		</xsl:if> -->
      		
      		<div id="header">
      			<div id="banner">
      				<xsl:choose>
      					<xsl:when test="SITECONFIG/V2_BOARDS/BANNER_SSI and SITECONFIG/V2_BOARDS/BANNER_SSI != ''"> 
      						<xsl:comment>#include virtual="<xsl:value-of select="SITECONFIG/V2_BOARDS/BANNER_SSI"/>"</xsl:comment>
      					</xsl:when>
      					<xsl:otherwise>
			      			<h1>Messageboards</h1>   					
      					</xsl:otherwise>
      				</xsl:choose>
      			</div>
      		</div>
      		
			<xsl:if test="SITECONFIG/V2_BOARDS/HORIZONTAL_NAV_SSI and SITECONFIG/V2_BOARDS/HORIZONTAL_NAV_SSI != ''">
				<div id="global-nav">
					<xsl:comment>#include virtual="<xsl:value-of select="SITECONFIG/V2_BOARDS/HORIZONTAL_NAV_SSI"/>"</xsl:comment>
				</div> 
			</xsl:if>      		
      		
      		<!-- <div class="breadcrumbs">
      			<ul class="breadcrumbs">
      				<xsl:apply-templates select="." mode="breadcrumbs"/>
      			</ul>
      		</div> -->
      		
      		<div style="clear:both;"> <xsl:comment> leave this </xsl:comment> </div>
      		 
      		<div id="blq-local-nav">
      			
      			<xsl:if test="SITECONFIG/V2_BOARDS/LEFT_NAV_SSI">
      				<xsl:comment>#include virtual="<xsl:value-of select="SITECONFIG/V2_BOARDS/LEFT_NAV_SSI"/>"</xsl:comment>
      			</xsl:if>
				
				<!-- what is this used for? -->
      			<xsl:if test="SITECONFIG/SITEHOME and SITECONFIG/SITEHOME != ''">
      				<ul class="navigation sitehome">
      					<li>
      						<a href="{SITECONFIG/SITEHOME}"><xsl:value-of select="SITECONFIG/BOARDNAME"/> Home</a>
      					</li>
      				</ul>
      			</xsl:if>
      			
      			<xsl:if test="TOPICLIST/TOPIC">
      				<ul class="navigation topics">
      					<li class="topic-parent"><a href="/dna/mbiplayer">Messageboard</a></li>
      					<xsl:apply-templates select="TOPICLIST/TOPIC" mode="object_topic_title"/>
      					
	      				<xsl:if test="/H2G2/VIEWING-USER/USER">
	      					<li id="mydiscussions">
	      						<a href="{$root}/MP{/H2G2/VIEWING-USER/USER/USERID}">My Discussions</a>
	      					</li>
	      				</xsl:if>
	      				<li>
	      					<a href="http://www.bbc.co.uk/messageboards/newguide/popup_house_rules.html" class="popup">House Rules</a>
	      				</li>
	      				<li>
	      					<a href="http://www.bbc.co.uk/messageboards/newguide/popup_faq_index.html" class="popup">Message Board FAQs</a>
	      				</li>
	      				<xsl:variable name="currentSite" select="CURRENTSITE"/>
	      				<xsl:if test="SITE[@ID='$currentSite']/SITEOPTIONS/SITEOPTION[NAME='IsKidsSite']/VALUE='1'">
	      					<li>
	      						<a href="http://www.bbc.co.uk/messageboards/newguide/popup_online_safety.html" class="popup">Are you being safe online?</a>
	      					</li>
	      				</xsl:if>      					
      				</ul>
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
   				
   				<xsl:if test="/H2G2/@TYPE = 'FRONTPAGE'">
   					<h2><xsl:value-of select="SITECONFIG/V2_BOARDS/WELCOME_MESSAGE" /></h2>
   				</xsl:if>
   				
      			<xsl:apply-templates select="." mode="page"/>
      		</div>  
      		
      		<div id="dna-boardpromo"> 
      			<h3>About this Board</h3>
      			<div id="dna-about-board">
      				<p><xsl:value-of select="SITECONFIG/V2_BOARDS/ABOUT_MESSAGE" /></p>
      				
      				<xsl:if test="not(/H2G2/VIEWING-USER/USER/USERNAME)">
      					<xsl:call-template name="id-signin" />
      				</xsl:if>
      				<hr />
      				<xsl:call-template name="boardtimes"/>
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
      				
      				<p>Find out more about this board <a href="http://www.bbc.co.uk/messageboards/newguide/popup_house_rules.html" class="popup">House Rules</a></p>
      			</div>
      			
      			<!-- Recent Discussions -->
      			<xsl:if test="/H2G2/SITECONFIG/V2_BOARDS/RECENTDISCUSSIONS = 'true'"> 
      				<h3>Recent Discussions</h3>
      				<div>
      					<xsl:choose>
      						<xsl:when test="H2G2/TOP-FIVES/TOP-FIVE[@NAME = 'MostRecentConversations']/TOP-FIVE-FORUM != ''"> 
      							<!-- <xsl:apply-templates></xsl:apply-templates> -->
      						</xsl:when>
      						<xsl:otherwise>
      							<p>This top 5 will be empty until the board is launched.</p>
      						</xsl:otherwise>
      					</xsl:choose>
      				</div>
      			</xsl:if>
      			
      			<xsl:apply-templates select="SITECONFIG/V2_BOARDS/MODULES/LINKS" mode="modules" />
      		</div>
      		
      		<xsl:if test="/H2G2/SITECONFIG/V2_BOARDS/SOCIALTOOLBAR = 'true'">
	      		<xsl:call-template name="library_socialbookmarks">
	      			<xsl:with-param name="title" select="$socialbookmark_title"/>
	      		</xsl:call-template>
      		</xsl:if>
      		
      		<xsl:comment>#include virtual="/includes/blq/include/blq_body_last.sssi"</xsl:comment>
      		
      	</body>
      </html>
      
    </xsl:template>
    
    <xsl:template name="id-signin">
    	<div class="id-wrap blq-clearfix">
	    	<a href="#" class="id-signin">Sign in</a>
	    	<p> or <a href="#">register</a> to take part in discussions.</p>
    	</div>
    </xsl:template>
    
    <xsl:template name="boardtimes">
		<xsl:choose>
			<xsl:when test="$boardClosed = 'true'">
				<p id="boardclosed">The message board is currently closed for posting.</p>
			</xsl:when>
			<xsl:otherwise>
				<p><xsl:value-of select="SITECONFIG/V2_BOARDS/OPENCLOSETIMES_TEXT" /></p>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="LINK" mode="modules">
		<xsl:comment>#include virtual="<xsl:value-of select="."/>"</xsl:comment>
	</xsl:template>
	
    
</xsl:stylesheet>
