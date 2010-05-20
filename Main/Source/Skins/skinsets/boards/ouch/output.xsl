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
	
	<xsl:template match="H2G2[@TYPE = 'USERCOMPLAINTPAGE']">
		<xsl:apply-templates select="." mode="page"/>
	</xsl:template> 
	    
  <xsl:template match="H2G2">
    <html lang="en" xmlns="http://www.w3.org/1999/xhtml" xml:lang="en">
      <head>
        <title>
          <xsl:text>BBC - Ouch! (disability) - Messageboard </xsl:text>
          <xsl:apply-templates select="." mode="head_title_page" />
        </title>
        <meta name="description" content="The BBC&#39;s disability site: razor sharp, funny, interesting and friendly - a community you&#39;ll want to be part of." />
        <meta name="keywords" content="disabled, disability, disabilities, disability magazine, disability webzine, disabled people, people with disabilities, disabled columnists, disabled writers, equal opportunities, diversity" />
        <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1"/>
        <meta content="width = 974" name="viewport"/>
        <link rel="schema.dcterms" href="http://purl.org/dc/terms/" />
        <link href="/ouch/rss/articles/latest/" rel="alternate" type="application/rss+xml" title="RSS feed of latest articles" />
        <meta name="dcterms.created" content="2008-06-15" />
        
        <xsl:comment>#set var="blq_identity" value="off"</xsl:comment>
        <xsl:comment>#set var="blq_nav_color" value="blue"</xsl:comment>
        <xsl:comment>#set var="blq_footer_color" value="grey"</xsl:comment>
        <xsl:comment>#set var="bbcpage_survey" value="no"</xsl:comment>
        <xsl:comment>#set var="hide_community_msgboard" value="true"</xsl:comment>
        
       <xsl:comment>#set var="bbcjst_inc" value="dom, cookies, plugins, forms" </xsl:comment>
        <xsl:comment>#include virtual="/cs/jst/jst.sssi" </xsl:comment>
        
        <xsl:comment>#include virtual="/includes/blq/include/blq_head.sssi"</xsl:comment>
        <xsl:comment>#include virtual="/ouch/includes/access_widget_head.sssi"</xsl:comment>
        
        <script type="text/javascript" src="/dnaimages/javascript/DNA.js"><xsl:text> </xsl:text></script>
        <script type="text/javascript" src="/ouch/js/home.js"><xsl:text> </xsl:text></script>
        <script type="text/javascript" src="/webwise/support.js"><xsl:text> </xsl:text></script>
        
        <link type="text/css" media="screen" rel="stylesheet" href="http://www.bbc.co.uk/ouch/css/generic.css"></link>
        <link type="text/css" media="screen" rel="stylesheet" href="http://www.bbc.co.uk/ouch/css/home.css"></link>

      	<xsl:text disable-output-escaping="yes">
        <!-- themes placed here so they can be switched using access widget -->
        <![CDATA[
        <script type="text/javascript">
			  document.write('<link id="current-messageboard-theme" type="text/css" media="screen" rel="stylesheet" href="/dnaimages/ouch/style/<!--#echo var='ouchTheme' -->.css" />');
	        document.write('<link id="current-theme" href="http://www.bbc.co.uk/ouch/css/themes/<!--#echo var='ouchTheme' -->.css" rel="stylesheet" type="text/css" />');

		  </script>
		  ]]>
		</xsl:text>

        <!-- Include alternate themes for non-js users -->
        <noscript>
          <link type="text/css" media="screen" rel="stylesheet" href="/dnaimages/ouch/style/theme-default.css"/>
          <link href="/dnaimages/ouch/style/theme-blue.css" title="Blue theme" rel="alternate stylesheet" type="text/css" />
          <link href="/dnaimages/ouch/style/theme-hiviz.css" title="High visibility theme" rel="alternate stylesheet" type="text/css" />
          <link href="/dnaimages/ouch/style/theme-soft.css" title="Soft theme" rel="alternate stylesheet" type="text/css" />

          <link href="http://www.bbc.co.uk/ouch/css/themes/theme-default.css" rel="stylesheet" type="text/css" />
			 <link href="http://www.bbc.co.uk/ouch/css/themes/theme-blue.css" title="Blue theme" rel="alternate stylesheet" type="text/css" />
          <link href="http://www.bbc.co.uk/ouch/css/themes/theme-hiviz.css" title="High visibility theme" rel="alternate stylesheet" type="text/css" />
          <link href="http://www.bbc.co.uk/ouch/css/themes/theme-soft.css" title="Soft theme" rel="alternate stylesheet" type="text/css" />
        </noscript>

        <link href="/dnaimages/ouch/style/theme.css" rel="stylesheet" type="text/css"></link>
        
        <script type="text/javascript">if (document.documentElement){bbcjs.dom.addClassName(document.documentElement,"js");}</script> 

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
  <div id="banner">
    <div id="logo">
      <a href="/ouch"><img src="http://www.bbc.co.uk/f/t.gif" width="230" height="117" alt="Ouch!" /></a>
      <div id="strapline"><p>It's a disability thing!</p></div>
    </div>
    <xsl:comment>#include virtual="/ouch/includes/access_widget.ssi"</xsl:comment>
    <p id="membership">
      <xsl:apply-templates select="VIEWING-USER" mode="library_memberservice_status" />
    </p>
  </div>

<div id="content">
  
	<div id="float-layout">
		<div id="blq-local-nav">
			<h3 class="nav-top">Sections</h3>
			<ul>
				<xsl:comment>#include virtual="/ouch/includes/nav.sssi"</xsl:comment>
			</ul>	
			<h3>Community</h3>
			<ul>
				<li>
				  <a href="/ouch/messageboards/">Message boards</a>
				  <ul class="topics">
            <xsl:apply-templates select="TOPICLIST/TOPIC" mode="object_topic_title">
                <xsl:sort data-type="number" select="TOPICID" order="ascending"/>
              </xsl:apply-templates>
				  </ul>
				</li>
				<li><a href="/ouch/blogs.shtml">Blogs</a></li>
			</ul> 
			
			<ul class="navigation general">
        <xsl:if test="/H2G2/VIEWING-USER/USER">
          <li>
            <a href="MP{/H2G2/VIEWING-USER/USER/USERID}">My Discussions</a>
          </li>
        </xsl:if>
        <li>
          <a href="{$houserulespopupurl}" class="popup" target="_blank">House Rules</a>
        </li>
        <li>
          <a href="{$faqpopupurl}" class="popup" target="_blank">Message Board FAQs</a>
        </li>
		<li>
			<a class="popup" href="http://www.bbc.co.uk/messageboards/newguide/popup_smiley.html" target="_blank">Smiley Guide</a>
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
			
			<p><a href="/ouch/about.shtml">About Ouch!</a></p>
			<p><a href="/go/blq/foot/contact/-/feedback/">Contact Us</a></p>
			
			<div id="promo">
        <xsl:comment>#include virtual="/ouch/includes/cps/lh-promos.ssi"</xsl:comment>
      </div>
      
    </div>	
    
    <div id="content-column">
      <div id="blq-content">
        <xsl:attribute name="class">
          <xsl:apply-templates select="@TYPE" mode="library_string_stringtolower"/>
        </xsl:attribute>  
        <div>
        <xsl:if test="@TYPE = 'FRONTPAGE'">
          <p id="ouch-crumb">
            <xsl:text>Ouch! Messageboards</xsl:text>
          </p>
        </xsl:if>
          <xsl:apply-templates select="." mode="page"/>
        </div>  
        
      </div>
    </div>
    <xsl:comment>#include virtual="/ouch/includes/community_panel_content.sssi"</xsl:comment>
    </div>
    
    </div>

<xsl:comment>#include virtual="/includes/blq/include/blq_body_last.sssi"</xsl:comment>

</body>
</html>
</xsl:template>
	
	<xsl:template name="boardclosed">
			<xsl:choose>
				<xsl:when test="$boardClosed = 'true'">
					<!--The <xsl:value-of select="/H2G2/SITECONFIG/BOARDNAME"/> message board is currently closed for posting. It is open daily from 8am - 10pm-->
				</xsl:when>
				<xsl:otherwise>
					<!--<xsl:comment>This message board is open daily from 8am - 10pm-->
				</xsl:otherwise>
			</xsl:choose>
	</xsl:template>
	
</xsl:stylesheet>
