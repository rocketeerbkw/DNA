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
        <link href="/dnaimages/ouch/style/theme.css" rel="stylesheet" type="text/css"></link>

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
		<a href="/ouch">Ouch!<span></span></a>
		<span id="strapline">It's a disability thing</span>
    </div>
    <xsl:comment>#include virtual="/ouch/includes/access_widget.ssi"</xsl:comment>
   </div>

<div id="content">
  
	<div id="float-layout">	
		<div id="float-top"><xsl:comment><xsl:text> </xsl:text></xsl:comment></div>
		<div id="blq-local-nav">
				<xsl:comment>#include virtual="/ouch/includes/nav.sssi"</xsl:comment>
				<li class="messageboards">
				  <a href="/ouch/messageboards/">Message boards</a>
				  <ul class="topics">
            <xsl:apply-templates select="TOPICLIST/TOPIC" mode="object_topic_title">
                <xsl:sort data-type="number" select="TOPICID" order="ascending"/>
              </xsl:apply-templates>
                                  </ul>
                       		</li>			

	<xsl:comment>#include virtual="/ouch/includes/nav_end.sssi"</xsl:comment>

      
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
   <p id="membership">
      <xsl:apply-templates select="VIEWING-USER" mode="library_memberservice_status" />
    </p>
          <xsl:apply-templates select="." mode="page"/>

<div id="mb-help">
	<h2>Information and Tips on using Message Boards</h2>
	<div class="mbbar">
		<ul>
<xsl:choose>
<xsl:when test="/H2G2/VIEWING-USER/USER">

			<li class="mb-mydiscussion col1">
				<a href="MP{/H2G2/VIEWING-USER/USER/USERID}">My Discussions<span></span></a><br />
				View a list of all your posts and comments.
			</li>

			<li class="mb-houserules">
				<a href="{$houserulespopupurl}" class="popup" target="_blank">House Rules<span></span></a><br />
				BBC message board Dos and Don'ts.
			</li>

			<li class="mb-faq col1">
				<a href="{$faqpopupurl}" class="popup" target="_blank">Message Board FAQs<span></span></a><br />
				Frequently asked questions about BBC message boards.
			</li>
			
			<li class="mb-smileyguide">
				<a class="popup" href="http://www.bbc.co.uk/messageboards/newguide/popup_smiley.html" target="_blank">Smiley Guide<span></span></a><br />
				Learn how to add smiley graphic emotions in your messages.
			</li>
<xsl:call-template name="library_userstate_editor">
        <xsl:with-param name="loggedin">
            <li class="col1">
              <a href="{$root}/boards-admin/messageboardadmin">Messageboard Admin</a>
            </li>
            <xsl:if test="/H2G2/VIEWING-USER/USER/STATUS = 2" >
              <li>
                <a href="{$root}/boards-admin/siteoptions">Site Options</a>
              </li>
            </xsl:if>
        </xsl:with-param>
      </xsl:call-template>

</xsl:when>
<xsl:otherwise>

			<li class="mb-houserules col1">
				<a href="{$houserulespopupurl}" class="popup" target="_blank">House Rules<span></span></a><br />
				BBC message board Dos and Don'ts.
			</li>

			<li class="mb-faq">
				<a href="{$faqpopupurl}" class="popup" target="_blank">Message Board FAQs<span></span></a><br />
				Frequently asked questions about BBC message boards.
			</li>
			
			<li class="mb-smileyguide col1">
				<a class="popup" href="http://www.bbc.co.uk/messageboards/newguide/popup_smiley.html" target="_blank">Smiley Guide<span></span></a><br />
				Learn how to add smiley graphic emotions in your messages.
			</li>
</xsl:otherwise>
</xsl:choose>
		</ul>
	</div>
</div>
        </div>  
        
      </div>
    </div>
    <xsl:comment>#include virtual="/ouch/includes/community_panel_content.sssi"</xsl:comment>

		<div id="float-end"><xsl:comment><xsl:text> </xsl:text></xsl:comment></div>

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
