<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	version="1.0" 
	xmlns:doc="http://www.bbc.co.uk/dna/documentation" 
	xmlns="http://www.w3.org/1999/xhtml" 
	exclude-result-prefixes="doc">
    
    <doc:documentation>
        <doc:purpose>
            Kick off stylesheet called directly by DNA 
        </doc:purpose>
        <doc:context>
            n/a
        </doc:context>
        <doc:notes>
            Bridges the jump between the old skin architecture and the new.
            Combines the Messageboard admin tool and the Host Dashboard skins.
        </doc:notes>
    </doc:documentation>
	
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
	
	<xsl:variable name="smileys" select="''"/>
    
	<xsl:template match="H2G2">
		<html xml:lang="en-GB" lang="en-GB">
		
		  <head profile="http://dublincore.org/documents/dcq-html/">
		    <title>DNA Site Admin | moderation</title>
		    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
		    <meta name="description" content="" />
		    <meta name="keywords" content="" />
		    <link rel="schema.dcterms" href="http://purl.org/dc/terms/" />
		    <link type="image/x-icon" href="/favicon.ico" rel="icon" />
		    <meta name="DCTERMS.created" content="2006-09-15T12:00:00Z" />
		    <meta name="DCTERMS.modified" content="2006-09-15T12:35:00Z" />
		    <link rel="schema.dcterms" href="http://purl.org/dc/terms/" />  
		    <link rel="index" href="http://www.bbc.co.uk/a-z/" title="A to Z" /> 
		    <link rel="help" href="http://www.bbc.co.uk/help/" title="BBC Help" /> 
		    <link rel="copyright" href="http://www.bbc.co.uk/terms/" title="Terms of Use" /> 
		    <link rel="icon" href="http://www.bbc.co.uk/favicon.ico" type="image/x-icon" />  
		    <meta name="viewport" content="width = 974" />    
		    <link rel="stylesheet" type="text/css" href="http://static.int.bbc.co.uk/frameworks/barlesque/1.36.0/desktop/2.7/style/main.css"  />      
		    <script type="text/javascript"> if (! window.gloader) { window.gloader = [ "glow", {map: "https://ssl.bbc.co.uk/glow/glow/map.1.7.7.js"}]; } </script>  
		    <script type="text/javascript" src="https://ssl.bbc.co.uk/glow/gloader.0.1.6.js"><xsl:text> </xsl:text></script>   
		    <script type="text/javascript" src="https://static.int.bbc.co.uk/frameworks/requirejs/0.11.1/sharedmodules/require.js"><xsl:text> </xsl:text></script> 
		    <script type="text/javascript">  bbcRequireMap = {"jquery-1":"https://static.int.bbc.co.uk/frameworks/jquery/0.1.8/sharedmodules/jquery-1.6.2", "jquery-1.4":"https://static.int.bbc.co.uk/frameworks/jquery/0.1.8/sharedmodules/jquery-1.4", "swfobject-2":"https://static.int.bbc.co.uk/frameworks/swfobject/0.1.4/sharedmodules/swfobject-2", "demi-1":"https://static.int.bbc.co.uk/frameworks/demi/0.9.2/sharedmodules/demi-1", "gelui-1":"https://static.int.bbc.co.uk/frameworks/gelui/0.9.3/sharedmodules/gelui-1", "cssp!gelui-1/overlay":"https://static.int.bbc.co.uk/frameworks/gelui/0.9.3/sharedmodules/gelui-1/overlay.css", "istats-1":"https://static.int.bbc.co.uk/frameworks/istats/0.8.1/modules/istats-1", "relay-1":"https://static.int.bbc.co.uk/frameworks/relay/0.2.1/sharedmodules/relay-1", "clock-1":"https://static.int.bbc.co.uk/frameworks/clock/0.1.5/sharedmodules/clock-1", "canvas-clock-1":"https://static.int.bbc.co.uk/frameworks/clock/0.1.5/sharedmodules/canvas-clock-1", "cssp!clock-1":"https://static.int.bbc.co.uk/frameworks/clock/0.1.5/sharedmodules/clock-1.css", "jssignals-1":"https://static.int.bbc.co.uk/frameworks/jssignals/0.3.3/modules/jssignals-1", "jcarousel-1":"https://static.int.bbc.co.uk/frameworks/jcarousel/0.1.8/modules/jcarousel-1"}; require({ baseUrl: 'http://static.int.bbc.co.uk/', paths: bbcRequireMap, waitSeconds: 30 }); </script>      
		    <script type="text/javascript" src="http://static.int.bbc.co.uk/frameworks/barlesque/1.36.0/desktop/2.7/script/blq_core.js"><xsl:text> </xsl:text></script>
			<!--[if (IE 6)|(IE 7)|(IE 8)]> <style type="text/css"> html{font-size:125%} body{font-size:50%} .blq-tooltipped:hover {background-position:0 0} #blq-autosuggest ul li { zoom:normal; } #blq-mast-home { background: transparent;  -ms-filter: "progid:DXImageTransform.Microsoft.gradient(startColorstr=#CC000000,endColorstr=#CC000000)"; /* IE8 */ filter: progid:DXImageTransform.Microsoft.gradient(startColorstr=#CC000000,endColorstr=#CC000000); } .skylightTheme #blq-mast-home, .doveTheme #blq-mast-home, .tealTheme #blq-mast-home, .aquaTheme #blq-mast-home, .greenTheme #blq-mast-home, .violetTheme #blq-mast-home, .purpleTheme #blq-mast-home, .pinkTheme #blq-mast-home, .oliveTheme #blq-mast-home, .suedeTheme #blq-mast-home, .redTheme #blq-mast-home, .orangeTheme #blq-mast-home { filter: none; -ms-filter: ""; } #blq-nav-main { background-position: 96% 17px; } </style> <![endif]--> <!--[if IE 7]> <style type="text/css"> .blq-clearfix {display: inline-block} </style> <![endif]-->  <!--[if IE 6]> <link rel="stylesheet" href="http://static.int.bbc.co.uk/frameworks/barlesque/1.36.0/desktop/2.7/style/ie6.css" type="text/css" /> <style type="text/css"> .blq-js #blq-nav-foot div {filter:progid:DXImageTransform.Microsoft.AlphaImageLoader(src='http://static.int.bbc.co.uk/frameworks/barlesque/1.36.0/desktop/2.7/img/panel.png', sizingMethod='image');margin-top:-139px}  #blq-container {height: 15%} #blq-mast-home span.blq-home { filter:progid:DXImageTransform.Microsoft.AlphaImageLoader(enabled=true, sizingMethod='crop', src='http://static.int.bbc.co.uk/frameworks/barlesque/1.36.0/desktop/2.7/img/blocks.png');} </style>  <script type="text/javascript"> try { document.execCommand("BackgroundImageCache",false,true); } catch(e) {} </script> <![endif]-->  <script type="text/javascript"> blq.assetPath="http://static.int.bbc.co.uk/frameworks/barlesque/1.36.0/desktop/2.7/"; blqOnDomReady(function() {  blq.suggest_short = false; blq.addAutoSuggest(); });  blq.setEnvironment('int');   </script>
			<link type="text/css" rel="stylesheet" media="screen" href="https://static.int.bbc.co.uk/modules/identity/statusbar/3.23.7/style/id-gel.css" /> <!--[if IE]> <style type="text/css" media="screen"> body .panel-identity .hd h2{ background-image: url(https://static.int.bbc.co.uk/modules/identity/statusbar/3.23.7/img/panel/logo-bbcid.gif); /* Even 8bit alpha transparent PNGs are no good here */ } .panel-id-hint .panel-bd, .panel-id-hint .panel-hd, .panel-id-hint .panel-ft{ background-image: url(https://static.int.bbc.co.uk/modules/identity/statusbar/3.23.7/img/panel/bg-hint.gif); } </style> <![endif]--> <!--[if lte IE 6]> <style type="text/css" media="screen"> /* Secure Glow fixes */ div.panel-identity .infoPanel-pointerT { filter:progid:DXImageTransform.Microsoft.AlphaImageLoader(src='http://www.bbc.co.uk/glow/1.0.2/widgets/images/darkpanel/at.png', sizingMethod='crop'); } div.panel-identity .infoPanel-pointerR { filter:progid:DXImageTransform.Microsoft.AlphaImageLoader(src='http://www.bbc.co.uk/glow/1.0.2/widgets/images/darkpanel/ar.png', sizingMethod='crop'); } div.panel-identity .infoPanel-pointerB { filter:progid:DXImageTransform.Microsoft.AlphaImageLoader(src='http://www.bbc.co.uk/glow/1.0.2/widgets/images/darkpanel/ab.png', sizingMethod='crop'); } div.panel-identity .infoPanel-pointerL { filter:progid:DXImageTransform.Microsoft.AlphaImageLoader(src='http://www.bbc.co.uk/glow/1.0.2/widgets/images/darkpanel/al.png', sizingMethod='crop'); } /* min-height fixes */ body .panel-identity .hd h2{ height: 26px; } #blq-main a.id-cta-button{ height: 22px; } #blq-main a.id-cta-button span{ height: 12px; } /* other */ div.panel-identity .c{ zoom: 1; } /* Transparent PNG replacements */ .blq-toolbar-transp #id-status .idUsername{ background-image: url(https://static.int.bbc.co.uk/modules/identity/statusbar/3.23.7/img/palettes/transp/status-id-logo-noprofile.gif); } .blq-toolbar-transp #id-status .idSignin, .blq-toolbar-transp #id-status .idUsernameWithProfile{ background-image: url(https://static.int.bbc.co.uk/modules/identity/statusbar/3.23.7/img/palettes/dark/status-id-logo.gif); } </style> <![endif]--> <!--[if lte IE 7]> <style type="text/css" media="screen"> .panel-identity form .text, .panel-identity form .password { zoom: 1; } .panel-identity form .text p { margin: 0; } .panel-identity form .password p { margin: 0 0 18px 0; } .panel-identity p.id-registerlink a.id-register { zoom: 1; padding-top: 3px; padding-bottom: 3px; top: 3px; } </style> <![endif]--> <!--[if lte IE 8]> <style type="text/css" media="screen"> /* Custom PNG corners for lightbox */ div.panel-identity .pc .tr { filter:progid:DXImageTransform.Microsoft.AlphaImageLoader(src='https://static.int.bbc.co.uk/modules/identity/statusbar/3.23.7/img/panel/ctr.png', sizingMethod='crop'); } div.panel-identity .pc .tl { filter:progid:DXImageTransform.Microsoft.AlphaImageLoader(src='https://static.int.bbc.co.uk/modules/identity/statusbar/3.23.7/img/panel/ctl.png', sizingMethod='crop'); } div.panel-identity .pc .bl { filter:progid:DXImageTransform.Microsoft.AlphaImageLoader(src='https://static.int.bbc.co.uk/modules/identity/statusbar/3.23.7/img/panel/cbl.png', sizingMethod='crop'); } div.panel-identity .pc .br { filter:progid:DXImageTransform.Microsoft.AlphaImageLoader(src='https://static.int.bbc.co.uk/modules/identity/statusbar/3.23.7/img/panel/cbr.png', sizingMethod='crop'); } </style> <![endif]--> <script type="text/javascript"> if(typeof identity == 'undefined'){ identity = {}; } idProperties = { 'env': 'int', 'staticServer': 'http://', 'dynamicServer': 'http://id.int.bbc.co.uk', 'secureServer': 'https://id.int.bbc.co.uk', 'assetVersion': '3.23.7', 'assetPath': 'https://static.int.bbc.co.uk/modules/identity/statusbar/3.23.7/' }; </script> 
			<script type="text/javascript" src="https://static.int.bbc.co.uk/modules/identity/statusbar/3.23.7/script/id-core.js"><xsl:text> </xsl:text></script> 
			<script type="text/javascript" src="https://static.int.bbc.co.uk/modules/identity/statusbar/3.23.7/script/id.js"><xsl:text> </xsl:text></script> 	
			<script type="text/javascript" src="/dnaimages/dna_messageboard/javascript/admin.js"><xsl:text> </xsl:text></script>
		    <link type="text/css" rel="stylesheet" href="/dnaimages/dna_messageboard/style/admin.css" />
		  </head>
			
			<body>
				<xsl:attribute name="class">
					<xsl:choose>
						<xsl:when test="@TYPE='ERROR' or @TYPE = 'MBADMIN' or @TYPE = 'MBADMINDESIGN'">
							<xsl:text>boardsadmin</xsl:text> 
						</xsl:when>
						<xsl:otherwise>dna-dashboard</xsl:otherwise>
					</xsl:choose>
					<xsl:text> </xsl:text>
					<xsl:value-of select="$dashboardtype" />
				</xsl:attribute>
				
				<!-- <xsl:comment>#include virtual="/includes/blq/include/blq_body_first.sssi"</xsl:comment> -->
				
				<script type="text/javascript">/*<![CDATA[*/ bbcFlagpoles_istats = 'ON'; istatsTrackingUrl = '//sa.bbc.co.uk/bbc/int/s?name=frameworks.barlesque.webservice.ssi.page&pal_route=webservices&ml_name=barlesque&app_type=web&language=en-GB&ml_version=0.8.1&pal_webapp=barlesque&prod_name=frameworks&app_name=frameworks'; if ( /\bIDENTITY=/.test(document.cookie) ) { istatsTrackingUrl += '&bbc_identity=1'; } /*]]>*/</script>  
				<div id="blq-container" class="blq-lang-en-GB blq-gvl-2-7"> 
					<div id="blq-pre-mast" lang="en-GB"> <!-- Pre mast -->  </div> 
					<div id="blq-container-inner" lang="en-GB">  
						<div id="blq-acc" class="blq-rst">  
							<p id="blq-mast-home" class="blq-no-images"><a href="/" hreflang="en-GB"> <span class="blq-home">British Broadcasting Corporation</span><img src="http://static.int.bbc.co.uk/frameworks/barlesque/1.36.0/desktop/2.7/img/blocks.png" alt="BBC" id="blq-blocks" width="84" height="24" /><span class="blq-span">Home</span></a></p> 
							<p class="blq-hide"><strong><a id="page-top">Accessibility links</a></strong></p> 
							<ul id="blq-acc-links">   
								<li class="blq-hide"><a href="#blq-content">Skip to content</a></li>  
								<li class="blq-hide"><a href="#blq-local-nav">Skip to local navigation</a></li>  
								<li class="blq-hide"><a href="#blq-nav-main">Skip to bbc.co.uk navigation</a></li> 
								<li class="blq-hide"><a href="#blq-search">Skip to bbc.co.uk search</a></li>   
								<li id="blq-acc-help" class="blq-hide"> <a href="/help/">Help</a> </li>   
								<li class="blq-hide"><a href="/accessibility/">Accessibility Help</a></li>   
							</ul>  
						</div>   
						<div id="blq-main" class="blq-clearfix">   				
					
							<div id="blq-local-nav" class="nav blq-clearfix">
								<xsl:apply-templates select="." mode="objects_title"/>
								<xsl:call-template name="objects_title" />
								<xsl:call-template name="objects_links_tabs" />
							</div>
			   
							<div id="blq-content">
								<xsl:if test="/H2G2[@TYPE = 'MBADMIN' or @TYPE = 'MBADMINDESIGN' or @TYPE = 'MESSAGEBOARDSCHEDULE']">
									<xsl:choose>
										<xsl:when test="SITE/SITEOPTIONS/SITEOPTION[NAME='IsMessageboard']/VALUE='0'">
											<xsl:call-template name="emergency-stop"><xsl:with-param name="type" select="'SITE'" /></xsl:call-template>
										</xsl:when>
										<xsl:otherwise>
											<xsl:call-template name="emergency-stop"><xsl:with-param name="type" select="'BOARD'" /></xsl:call-template>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:if>
								
								<xsl:apply-templates select="/H2G2[@TYPE != 'ERROR']/ERROR" mode="page"/>
								<xsl:apply-templates select="/H2G2/RESULT" mode="page"/>
								<xsl:apply-templates select="." mode="page"/>
							</div>
							
					</div>
				</div>
			</div>
			</body>
		</html>
	</xsl:template>
	
	<xsl:template name="emergency-stop">
		<xsl:param name="type"></xsl:param>
		<div class="dna-emergency-stop">
			<xsl:choose>
				<xsl:when test="/H2G2/SITE/SITECLOSED[@EMERGENCYCLOSED = '0']">
					<p>
						<a href="{$root}/MessageBoardSchedule?action=CloseSite&amp;confirm=1" class="dna-stop">
						<strong>CLOSE <xsl:value-of select="$type"/>
						</strong>
						Board closed to all new posts,<br />except from editor accounts
						</a>
					</p>
				</xsl:when>
				<xsl:otherwise>
					<p>
						<a href="{$root}/MessageBoardSchedule?action=OpenSite&amp;confirm=1" class="dna-go">
						<strong>RE-OPEN <xsl:value-of select="@type"/></strong>
						Allow all posts to this messageboard
						</a>
					</p>
				</xsl:otherwise>
			</xsl:choose>
		</div>
	</xsl:template>
    
</xsl:stylesheet>