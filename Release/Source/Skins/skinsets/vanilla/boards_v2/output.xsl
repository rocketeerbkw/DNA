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
	
	<xsl:variable name="socialbookmark_title" select="concat('BBC - ', /H2G2/SITECONFIG/BOARDNAME, ' Messageboard - ', $page_title)"/>
	
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
      		
      		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1" />
      		<meta name="robots" content="{$robotsetting}"/>
      		<meta name="description"><xsl:attribute name="content">BBC message board for <xsl:value-of select="SITECONFIG/BOARDNAME"/></xsl:attribute></meta>
      		<meta name="keywords" content="" />
      		<link rel="schema.dcterms" href="http://purl.org/dc/terms/" />
      		<link type="image/x-icon" href="/favicon.ico" rel="icon"/>
      		<meta name="DCTERMS.created" content="2006-09-15T12:00:00Z" />
      		<meta name="DCTERMS.modified" content="2006-09-15T12:35:00Z" />
      		
      		<xsl:choose>
      			<xsl:when test="SITE/IDENTITYSIGNIN = 1">
      				<xsl:comment>#set var="blq_identity" value="on"</xsl:comment>
      			</xsl:when>
      			<xsl:otherwise>
      				<xsl:comment>#set var="blq_identity" value="off"</xsl:comment>
      			</xsl:otherwise>
      		</xsl:choose>
      		
      		<xsl:choose>
      			<xsl:when test="SITECONFIG/V2_BOARDS/HEADER_COLOUR != ''">
      				<xsl:comment>#set var="blq_nav_color" value="<xsl:value-of select="SITECONFIG/V2_BOARDS/HEADER_COLOUR"/>"</xsl:comment>
      			</xsl:when>
      			<xsl:otherwise>
      				<xsl:comment>#set var="blq_nav_color" value="blue"</xsl:comment>
      			</xsl:otherwise>
      		</xsl:choose>

			<xsl:if test="SITE[@ID='$currentSite']/SITEOPTIONS/SITEOPTION[NAME='MothBallSite']/VALUE='1'" />
			<!--<xsl:if test="SITE/URLNAME = 'mbgardening'">-->
				<xsl:comment>#set var="blq_mothball" value="1"</xsl:comment>
			</xsl:if>

			<xsl:if test="SITECONFIG/V2_BOARDS/FOOTER/COLOUR">
      			<xsl:comment>#set var="blq_footer_color" value="<xsl:value-of select="SITECONFIG/V2_BOARDS/FOOTER/COLOUR"/>"</xsl:comment>
      		</xsl:if>

      		<xsl:if test="$blq_header_siteoption != ''">
      			<xsl:call-template name="loopstring">
      				<xsl:with-param name="value" select="$blq_header_siteoption" />
      			</xsl:call-template>
      		</xsl:if>
      				
      		<xsl:comment>#include virtual="/includes/blq/include/blq_head.sssi"</xsl:comment>
      		
      		<script type="text/javascript" src="/glow/gloader.js"><xsl:text> </xsl:text></script>
      		<script type="text/javascript" src="/dnaimages/javascript/DNA.js"><xsl:text> </xsl:text></script>
      		<xsl:if test="PREVIEWMODE = 1"><script type="text/javascript" src="/dnaimages/dna_messageboard/javascript/previewmode.js"><xsl:text> </xsl:text></script></xsl:if>
      		
      		<!-- disable Identity JavaScript for now -->
      		<script type="text/javascript">
      			if (identity.cta) {
      			identity.cta.parseLinks = function() {}
      			}
      		</script>
      		
      		<link type="text/css" rel="stylesheet" href="/dnaimages/dna_messageboard/style/generic_messageboard_v2.css"/>
          	<link type="text/css" media="print" rel="stylesheet" href="/dnaimages/dna_messageboard/style/generic_messageboard_print.css"/>
      		
      		<xsl:if test="SITECONFIG/V2_BOARDS/CSS_LOCATION and SITECONFIG/V2_BOARDS/CSS_LOCATION != ''">
      			<link type="text/css" media="screen" rel="stylesheet" href="{SITECONFIG/V2_BOARDS/CSS_LOCATION}"/>
      		</xsl:if> 

      	</head>
      	<xsl:text disable-output-escaping="yes">
      		<![CDATA[    
				<!--[if IE 6]>
					<body class="ie6">
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
      		
      		<!-- horrible hack for error pages -->
      		<xsl:if test="/H2G2/SITECONFIG">
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
      		</xsl:if>
      		
			<xsl:if test="SITECONFIG/V2_BOARDS/HORIZONTAL_NAV_SSI and SITECONFIG/V2_BOARDS/HORIZONTAL_NAV_SSI != ''">
				<div id="global-nav">
					<xsl:comment>#include virtual="<xsl:value-of select="SITECONFIG/V2_BOARDS/HORIZONTAL_NAV_SSI"/>"</xsl:comment>
				</div> 
			</xsl:if>      		
      		
      		<div style="clear:both;"> <xsl:comment> leave this </xsl:comment> </div>
      		 
      		<!-- hack for error pages - this needs to be revisited  --> 
      		<xsl:if test="/H2G2/SITECONFIG">
	      		<div id="blq-local-nav">
	      			
	      			<xsl:if test="SITECONFIG/V2_BOARDS/LEFT_NAV_SSI != ''">
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
	      					<li class="topic-parent"><a href="{$root}/">Messageboard</a></li>
	      					<xsl:apply-templates select="TOPICLIST/TOPIC" mode="object_topic_title"/>
	      					<li class="hr"><hr /></li>
		      				<xsl:if test="/H2G2/VIEWING-USER/USER">
		      					<li id="mydiscussions">
		      						<a href="{$root}/MP{/H2G2/VIEWING-USER/USER/USERID}">My Discussions</a>
		      					</li>
		      				</xsl:if>
		      				<li>
		      					<a href="{$houserulesurl}" class="popup">House Rules</a>
		      				</li>
		      				<li>
		      					<a href="{$faqsurl}" class="popup">FAQs</a>
		      				</li>
		      				<xsl:variable name="currentSite" select="CURRENTSITE"/>
		      				<xsl:if test="SITE[@ID='$currentSite']/SITEOPTIONS/SITEOPTION[NAME='IsKidsSite']/VALUE='1'">
		      					<li>
		      						<a href="/messageboards/newguide/popup_online_safety.html" class="popup">Are you being safe online?</a>
		      					</li>
		      				</xsl:if>   
		      				<xsl:if test="/H2G2/SITE/SITEOPTIONS/SITEOPTION[NAME = 'UseSystemMessages']/VALUE = '1'">
	      						<xsl:variable name="sitename">
					                <xsl:choose>
					                    <xsl:when test="/H2G2/SITE/NAME">
					                        <xsl:value-of select="/H2G2/SITE/NAME"/>
					                    </xsl:when>
					                    <xsl:otherwise>
					                        <xsl:value-of select="/H2G2/CURRENTSITEURLNAME"/>
					                    </xsl:otherwise>
					                </xsl:choose>		      						
	      						</xsl:variable>
		      					<li>
		      						<a href="SMM">Moderation Notifications</a>
		      					</li>		      					
	      					</xsl:if>
	      				</ul>
	      			</xsl:if>
	      			
	      			<xsl:if test="/H2G2/@TYPE = 'SYSTEMMESSAGEMAILBOX'"> 
	      				<ul class="navigation topics">
	      					<li>
	      						<a>
		      						<xsl:attribute name="href">
		      							<xsl:choose>
		      								<xsl:when test="contains(SITE/NAME, 'mbcbbc')">/cbbc/mb/</xsl:when>
		      								<xsl:otherwise>/dna/<xsl:value-of select="SITE/URLNAME" />/</xsl:otherwise>
		      							</xsl:choose>
		      						</xsl:attribute>
	      							Back to messageboard front page
	      						</a>
	      					</li>
	      				</ul>
	      			</xsl:if>
	      			
	      			<xsl:call-template name="library_userstate_editor">
	      				<xsl:with-param name="loggedin">
	      					<ul class="navigation admin">
	      						<li>
	      							<xsl:choose>
	      								<xsl:when test="contains(/H2G2/SERVERNAME, 'NARTHUR5')">
	      									<a href="http://dna-extdev.bbc.co.uk/dna/{SITECONFIG/BOARDROOT}admin/messageboardadmin">Messageboard Admin</a>
	      								</xsl:when>
	      								<xsl:otherwise>
	      									<a href="{$root}/admin/mbadmin">Messageboard Admin</a>
	      								</xsl:otherwise>
	      							</xsl:choose>
	      						</li>
	      						<xsl:if test="/H2G2/VIEWING-USER/USER/STATUS = 2" >
	      							<li>
	      								<a href="{$root}/boards-admin/siteoptions">Site Options</a>
	      							</li>
	      						</xsl:if>
	      					</ul>
	      				</xsl:with-param>
	      			</xsl:call-template>
	      			<xsl:comment>close div</xsl:comment>
	      		</div>
      		</xsl:if>
      		
      		<div id="blq-content">
      			<xsl:attribute name="class">
      				<xsl:choose>
	      				<xsl:when test="/H2G2/SITECONFIG">
	      					<xsl:apply-templates select="/H2G2/@TYPE" mode="library_string_stringtolower"/>
	      				</xsl:when>
	      				<xsl:otherwise>
	      					<xsl:text>problem</xsl:text>
	      				</xsl:otherwise>
      				</xsl:choose>
      			</xsl:attribute>
   				
   				<!--  is it the front page or an error page (siteconfig hack for error page) -->
   				<xsl:if test="/H2G2/@TYPE = 'FRONTPAGE' and /H2G2/SITECONFIG">
   					<xsl:choose>
   						<xsl:when test="SITECONFIG/V2_BOARDS/WELCOME_MESSAGE != ''">
   							<h2><xsl:value-of select="SITECONFIG/V2_BOARDS/WELCOME_MESSAGE" disable-output-escaping="yes"/></h2>
   						</xsl:when>
   						<xsl:otherwise><h2>Welcome</h2></xsl:otherwise>
   					</xsl:choose>
   				</xsl:if>
      			<xsl:apply-templates select="." mode="page"/>
      		</div>  
      		
      		<xsl:if test="/H2G2/SITECONFIG">
	      		<div id="dna-boardpromo"> 
	      			<h3>About this Board</h3>
	      			<div id="dna-about-board">
	      				<p><xsl:value-of select="SITECONFIG/V2_BOARDS/ABOUT_MESSAGE" disable-output-escaping="yes" /></p>
      					<xsl:apply-templates select="/H2G2/VIEWING-USER" mode="library_identity_cta">
      						<xsl:with-param name="signin-text"><xsl:value-of select="$signin-discussion-text" /></xsl:with-param>
    					</xsl:apply-templates>
	      				<hr />
	      				<xsl:call-template name="boardtimes"/>
	      				<xsl:choose>
	      					<xsl:when test="/H2G2/SITE/MODERATIONSTATUS = 1">
	      						<p>This messageboard is <a href="{$moderationinfourl}" class="popup">post-moderated</a>.</p>
	      					</xsl:when>
	      					<xsl:when test="/H2G2/SITE/MODERATIONSTATUS = 2">
	      						<p>This messageboard is <a href="{$moderationinfourl}" class="popup">pre-moderated</a>.</p>
	      					</xsl:when>
	      					<xsl:otherwise>
	      						<p>This messageboard is <a href="{$moderationinfourl}" class="popup">reactively moderated</a>.</p>
	      					</xsl:otherwise>
	      				</xsl:choose>
	      				<p>Find out more about this board's <a href="{$houserulesurl}" class="popup">House Rules</a></p>
	      			</div>
	      			
		      		<xsl:if test="/H2G2/SITE/SITEOPTIONS/SITEOPTION[NAME = 'EnableSearch']/VALUE = '1'">
		      			<h3>Search this Board</h3>
		      			<div id="searchbox">
							<form action="{$root}/searchposts" method="get" id="dna-searchform">
								<fieldset>
									<label for="searchtext" class="dna-invisible">Search</label>
									<input id="searchtext" name="searchtext" maxlength="100">
										<xsl:attribute name="value">
											<xsl:value-of select="/H2G2/SEARCHTHREADPOSTS/@SEARCHTERM"/>
										</xsl:attribute>
									</input>
									<input type="submit" value="Search" class="dna-button" />
								</fieldset>
							</form>
						</div>
		      		</xsl:if>      			
		      			
	      			<!-- Recent Discussions -->
	      			<xsl:if test="/H2G2/SITECONFIG/V2_BOARDS/RECENTDISCUSSIONS = 'true' and (/H2G2/RECENTACTIVITY/MOSTRECENTCONVERSATIONS/FORUM or /H2G2/TOP-FIVES/TOP-FIVE)"> 
	      				<h3>Recent Discussions</h3>
	      				<div>
	      					<ul class="topfives">
	      						<xsl:if test="/H2G2/TOP-FIVES/TOP-FIVE">
	      							<xsl:apply-templates select="/H2G2/TOP-FIVES/TOP-FIVE[@NAME = 'MostRecentConversations']/TOP-FIVE-FORUM" mode="object_top-fives_top-five-forum"/>
	      						</xsl:if>
	      						<xsl:if test="/H2G2/RECENTACTIVITY/MOSTRECENTCONVERSATIONS">
	      							<xsl:apply-templates select="/H2G2/RECENTACTIVITY/MOSTRECENTCONVERSATIONS/FORUM" mode="object_recentactivity_most-recent-conversations"/>
	      						</xsl:if>
	      					</ul>
	      				</div>
	      			</xsl:if>
	      			<xsl:apply-templates select="SITECONFIG/V2_BOARDS/MODULES/LINKS" mode="modules" />
	      		</div>
      		</xsl:if>
      		
      		<xsl:if test="/H2G2/SITECONFIG/V2_BOARDS/SOCIALTOOLBAR = 'true'">
	      		<xsl:call-template name="library_socialbookmarks">
	      			<xsl:with-param name="title" select="$socialbookmark_title"/>
	      		</xsl:call-template>
      		</xsl:if>

      		<xsl:comment>#include virtual="/includes/blq/include/blq_body_last.sssi"</xsl:comment>

      	</body>
      </html>
      
    </xsl:template>
    
    <xsl:template name="boardtimes">
		<xsl:if test="$boardClosed = 'true'">
			<p id="boardclosed">The message board is currently closed for posting.</p>
		</xsl:if>
		<p><xsl:value-of select="SITECONFIG/V2_BOARDS/OPENCLOSETIMES_TEXT" disable-output-escaping="yes" /></p>
	</xsl:template>
	
	<xsl:template match="LINK" mode="modules">
		<xsl:comment>#include virtual="<xsl:value-of select="."/>"</xsl:comment>
	</xsl:template>
	
	<!-- 
		For custom barleque header options
		loop for custombarlesquepath site option, each ssi variable must be added as a site option and delimited by a |  
	-->
	<xsl:template name="loopstring">
		<xsl:param name="value"/>
		
		<xsl:choose>
			<xsl:when test="contains($value,'|')">
				<xsl:call-template name="setvariable">
					<xsl:with-param name="this" select="substring-before($value,'|')"/>
				</xsl:call-template>
				<xsl:call-template name="loopstring">
					<xsl:with-param name="value" select="substring-after($value,'|')"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="setvariable">
					<xsl:with-param name="this" select="$value"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
 
	 <xsl:template name="setvariable">
	 	<xsl:param name="this"/>
	 	<xsl:comment>#set <xsl:value-of select="$this" /></xsl:comment>
	 </xsl:template>

</xsl:stylesheet>
