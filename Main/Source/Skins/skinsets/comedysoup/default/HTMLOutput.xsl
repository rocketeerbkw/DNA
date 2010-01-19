<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<!--===============Imported Files=====================-->
	<xsl:import href="../../../base/base-extra.xsl"/>
		
	<!--===============Included Files=====================-->
	
	
	<xsl:include href="addthreadpage.xsl"/>
	<xsl:include href="articlepage.xsl"/>
	<xsl:include href="articlepage_templates.xsl"/>
	<xsl:include href="articlesearch.xsl"/> 	
	<xsl:include href="categorypage.xsl"/>
	<xsl:include href="comedysouphelptext.xsl"/>
	<xsl:include href="comedysoup-sitevars.xsl"/>
	<xsl:include href="comedysouptext.xsl"/>
	<xsl:include href="debug.xsl"/>					
	<xsl:include href="editcategorypage.xsl"/>
	<xsl:include href="frontpage.xsl"/>
	<xsl:include href="guideml.xsl"/>
	<xsl:include href="indexpage.xsl"/>
	<xsl:include href="infopage.xsl"/>
	<xsl:include href="inspectuserpage.xsl"/> 
	<xsl:include href="keyarticle-editorpage.xsl"/>
	<xsl:include href="masppage.xsl"/>				
	<xsl:include href="mediaassetpage.xsl"/>		
	<xsl:include href="miscpage.xsl"/>
	<xsl:include href="morearticlespage.xsl"/>
	<xsl:include href="morepostspage.xsl"/>
	<xsl:include href="multipostspage.xsl"/>
	<xsl:include href="newuserspage.xsl"/>
	<xsl:include href="registerpage.xsl"/>	
	<xsl:include href="searchpage.xsl"/>
	<xsl:include href="siteconfigpage.xsl"/>
	<xsl:include href="threadspage.xsl"/>
	<xsl:include href="typedarticlepage.xsl"/>
	<xsl:include href="typedarticlepage_templates.xsl"/>	
	<xsl:include href="types.xsl"/>
	<xsl:include href="usercomplaintpopup.xsl"/>
	<xsl:include href="userdetailspage.xsl"/>		
	<xsl:include href="usereditpage.xsl"/>
	<xsl:include href="usermediaasset.xsl"/>		
	<xsl:include href="userpage.xsl"/>
	<xsl:include href="watcheduserspage.xsl"/>
	
	
	<!--===============Included Files=====================-->
	<!--===============Output Setting=====================-->
	<xsl:output method="html" version="4.0" omit-xml-declaration="yes" standalone="yes" indent="yes" encoding="ISO8859-1"/>
	<!--===============CSS=====================-->
	<xsl:variable name="csslink">
		<xsl:choose>
			<xsl:when test="/H2G2/SERVERNAME = $development_server or /H2G2/SERVERNAME = 'NMSDNA0'">
				<link type="text/css" rel="stylesheet" href="http://chrysalis.tv.bbc.co.uk/soup/css/styles.css"/>
				<link type="text/css" rel="stylesheet" href="http://chrysalis.tv.bbc.co.uk/soup/css/editorial_tools.css"/>	
			</xsl:when>
			<xsl:otherwise>
				<link type="text/css" rel="stylesheet" href="http://www.bbc.co.uk/comedysoup/css/styles.css"/>
				<link type="text/css" rel="stylesheet" href="http://www.bbc.co.uk/comedysoup/css/editorial_tools.css"/>	
			</xsl:otherwise>
		</xsl:choose>
		
		
		
		
	</xsl:variable>
	<!--===============CSS=====================-->
	<!--===============Attribute-sets Settings=====================-->
	<xsl:attribute-set name="mainfont">
		<xsl:attribute name="size">2</xsl:attribute>
	</xsl:attribute-set>
	<!--===============Attribute-sets Settings=====================-->
	<!--===============Javascript=====================-->
	<xsl:variable name="scriptlink">
		<xsl:call-template name="ssi-set-var">
			<xsl:with-param name="name">bbcjst_inc</xsl:with-param>
			<xsl:with-param name="value">plugins</xsl:with-param>
		</xsl:call-template>
		
		<!-- temporarily take out until installed on dev
		<xsl:call-template name="ssi-include-virtual">
			<xsl:with-param name="path">/cs/jst/jst.sssi</xsl:with-param>
		</xsl:call-template>
		-->
		
		<xsl:comment>
			##########################################
			Begin JSTools includes - $Revision: 1.35 
			##########################################
		</xsl:comment>
		<script type="text/javascript" language="JavaScript">
		<!-- //
			if(!document.getElementById && document.all)
			document.getElementById = function(id) {return document.all[id];}
		// -->
		</script>
		<script src="http://www.bbc.co.uk/cs/jst/mod/1/jst_core.js" type="text/javascript" language="JavaScript"></script>
		<script type="text/javascript" language="JavaScript">
		<!-- //
			bbcjs.client_ip = "10.162.38.105";
			bbcjs.today = new Date(2006, (09-1), 20);
		// -->
		</script>
		<script src="http://www.bbc.co.uk/cs/jst/mod/1/jst_plugins.js" type="text/javascript" language="JavaScript"></script>








		<script LANGUAGE="JavaScript" type="text/javascript">
		<xsl:comment>

		/* Webwise guides functionality for help on plugins... */

		function openWindow(file){
			popupWin = window.open(file, 'popup', 'scrollbars=yes,status=0,menubar=no,resizable=no,width=618,height=450');
		myTimer=setTimeout("popupWin.focus()",1000);
		}

		var wwguides = 
		{
			flash	: "/webwise/categories/plug/flash/flash.shtml?intro",
			real	: "/webwise/categories/plug/real/real.shtml?intro",
			acrobat : "/webwise/categories/plug/acrobat/acrobat.shtml?intro",
			cortona	: "/webwise/categories/plug/cortona/cortona.shtml?intro",
			ipix    : "/webwise/categories/plug/ipix/ipix.shtml?intro",
			quicktime : "/webwise/categories/plug/quicktime/quicktime.shtml?intro",
			shockwave : "/webwise/categories/plug/shockwave/shockwave.shtml?intro",
			winmedia  : "/webwise/categories/plug/winmedia/winmedia.shtml?intro"

		}


		//New webwise guide function, you only need to specify the guide you wish to open, e.g. "flash", "real" etc
		function wwguide(g)
		{
			if (typeof(wwguides[g])!="undefined")
			{
				openWindow(wwguides[g]);
				return false;
			}
			else return true;
		}

		//</xsl:comment>
		</script>


		<xsl:comment>
			#####################
			End JSTools includes.
			#####################
		</xsl:comment>
		
		
		<script type="text/javascript">
			<xsl:call-template name="insert-javascript"/>
			<xsl:comment>
				<!--Site wide Javascript goes here-->
				function popupwindow(link, target, parameters) {
					popupWin = window.open(link,target,parameters);
				}
				function popusers(link) {
					popupWin = window.open(link,'popusers','status=1,resizable=1,scrollbars=1,width=165,height=340');
				}
				function popmailwin(x, y) {window.open(x,y,'status=no,scrollbars=yes,resizable=yes,width=350,height=400');}
				<xsl:text>//</xsl:text>
			</xsl:comment>
		</script>
	</xsl:variable>
	<!--===============Javascript=====================-->
	
	<xsl:variable name="meta-tags">
		<link href="{$root}xml/ArticleSearch?articlesortby=DateUploaded&amp;s_xml=rss" rel="alternate" type="application/rss+xml" title="BBC Comedy Soup" />		
	</xsl:variable>
	
	<!--===============Variable Settings=====================-->
	<xsl:variable name="skinname">comedysoup</xsl:variable>
	<xsl:variable name="bbcpage_bgcolor"/>
	<xsl:variable name="bbcpage_nav">yes</xsl:variable>
	<xsl:variable name="bbcpage_navwidth">125</xsl:variable>
	<xsl:variable name="bbcpage_navgraphic">yes</xsl:variable>
	<xsl:variable name="bbcpage_navgutter">yes</xsl:variable>
	<xsl:variable name="bbcpage_contentwidth">635</xsl:variable>
	<xsl:variable name="bbcpage_contentalign">left</xsl:variable>
	<xsl:variable name="bbcpage_language">english</xsl:variable>
	<xsl:variable name="bbcpage_searchcolour">efefef</xsl:variable>
	<xsl:variable name="bbcpage_topleft_bgcolour"/>
	<xsl:variable name="bbcpage_topleft_linkcolour"/>
	<xsl:variable name="bbcpage_topleft_textcolour"/>
	<xsl:variable name="bbcpage_lang"/>
	<xsl:variable name="bbcpage_variant"/>
	<!--===============Variable Settings=====================-->
	<!--===============Banner Template (Banner Area Stuff)=====================-->
	<xsl:variable name="banner-content">
	
		<xsl:variable name="bannerimage">
			<xsl:choose><!-- grey when when looking at someone elses personal space  - should create reusable test as used in 2 places -->
				<xsl:when test="(/H2G2/@TYPE='USERPAGE' and $ownerisviewer=0) or (/H2G2/MEDIAASSETBUILDER/ARTICLEMEDIAASSETINFO/ACTION='showusersarticleswithassets' and /H2G2/VIEWING-USER/USER/USERID!=/H2G2/MEDIAASSETBUILDER/ARTICLEMEDIAASSETINFO/USERSID) or (/H2G2/@TYPE='WATCHED-USERS' and $ownerisviewer=0) or (/H2G2/@TYPE='THREADS' and /H2G2/VIEWING-USER/USER/USERID!=/H2G2/FORUMSOURCE/USERPAGE/USER/USERID) or (/H2G2/@TYPE='ADDTHREAD' and /H2G2/VIEWING-USER/USER/USERID!=/H2G2/FORUMSOURCE/USERPAGE/USER/USERID) or (/H2G2/@TYPE='MULTIPOSTS' and /H2G2/VIEWING-USER/USER/USERID!=/H2G2/FORUMSOURCE/USERPAGE/USER/USERID)">
				banner_grey
				</xsl:when>
				<xsl:otherwise>
				banner_black
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<div class="banner"><img src="{$imagesource}{$bannerimage}.gif" width="435" height="83" alt="ComedySoup - watch funny stuff" /></div>
	</xsl:variable>
	<!--===============Banner Template (Banner Area Stuff)=====================-->
	<!--===============Crumb Template (Crumb Navigation Stuff)=====================-->
	<xsl:variable name="crumb-content">
		<a class="bbcpageCrumb" href="/comedy/">Comedy</a><br />
	</xsl:variable>
	
	<!-- helper templates to output a server-side include statements -->
	<xsl:template name="ssi-include-virtual">
		<xsl:param name="path"/>
		<xsl:comment>#include virtual="<xsl:value-of select="$path"/>"</xsl:comment>
	</xsl:template>
	
	<xsl:template name="ssi-set-var">
		<xsl:param name="name"/>
		<xsl:param name="value"/>
		<xsl:comment>#set var="<xsl:value-of select="$name"/>" value="<xsl:value-of select="$value"/>"</xsl:comment>
	</xsl:template>
	
	<!--===============Crumb Template (Crumb Navigation Stuff)=====================-->
	<!--===============Local Template (Local Navigation Stuff)=====================-->
	<xsl:template name="local-content">
		<ul class="navList">
			<li><xsl:if test="/H2G2/@TYPE='FRONTPAGE'">
					<xsl:attribute name="class">selected</xsl:attribute>
				</xsl:if>
				<a href="{$root}"><span>Comedy Soup home</span></a>
			</li>
			<li>
				<h2><img src="{$imagesource}navh2_watch.gif" alt="watch" /></h2>
				<ul class="navSubList">
					<!-- <li><xsl:if test="/H2G2/ARTICLENAME='thelatest'">
							<xsl:attribute name="class">selected</xsl:attribute>
						</xsl:if>
						<a href="{$root}thelatest"><span>The Latest</span></a>
					</li> -->
					<li><xsl:if test="/H2G2/ARTICLESEARCH/@CONTENTTYPE=3">
							<xsl:attribute name="class">selected</xsl:attribute>
						</xsl:if>
						<a href="{$root}ArticleSearch?contenttype=3"><span>Video &amp; Animation</span></a>
					</li>
					<li><xsl:if test="/H2G2/ARTICLESEARCH/@CONTENTTYPE=1">
							<xsl:attribute name="class">selected</xsl:attribute>
						</xsl:if>
						<a href="{$root}ArticleSearch?contenttype=1"><span>Images</span></a>
					</li>
					<li><xsl:if test="/H2G2/ARTICLESEARCH/@CONTENTTYPE=2">
							<xsl:attribute name="class">selected</xsl:attribute>
						</xsl:if>
						<a href="{$root}ArticleSearch?contenttype=2"><span>Audio</span></a>
					</li>
				</ul>
			</li>
			
			<li>
				<h2><img src="{$imagesource}navh2_make.gif" alt="make" /></h2>
				<ul class="navSubList">
					<li><xsl:if test="@TYPE='USERPAGE' or /H2G2/MEDIAASSETBUILDER/ARTICLEMEDIAASSETINFO/ACTION='showusersarticleswithassets'">
							<xsl:attribute name="class">selected</xsl:attribute>
						</xsl:if>
						<xsl:choose>		
							<xsl:when test="/H2G2/VIEWING-USER/USER">
								<!-- i.e. logged in user. -->
								<a href="{$root}U{VIEWING-USER/USER/USERID}">
										<span>Personal space</span>
									</a>
							</xsl:when>
							<xsl:otherwise>
								<!-- i.e. not a logged in user. -->
								<a href="{$sso_signinlink}"><span>Personal space</span></a>
							</xsl:otherwise>
						</xsl:choose>
					</li>
					<li><xsl:if test="/H2G2/ARTICLE/ARTICLEINFO/NAME='assetlibrary-index' or /H2G2/MEDIAASSETSEARCHPHRASE">
							<xsl:attribute name="class">selected</xsl:attribute>
						</xsl:if>
						<a href="/dna/comedysoup/assetlibrary-index"><span>Get raw material</span></a>
					</li>
					<li><xsl:if test="/H2G2/ARTICLE/ARTICLEINFO/NAME='submityourstuff'">
							<xsl:attribute name="class">selected</xsl:attribute>
						</xsl:if>
						<a href="{$root}submityourstuff"><span>Submit your stuff</span></a>
					</li>
					<li><xsl:if test="/H2G2/ARTICLE/ARTICLEINFO/NAME='programmechallenges'">
							<xsl:attribute name="class">selected</xsl:attribute>
						</xsl:if>
						<a href="{$root}challenges"><span>Challenges</span></a>
					</li>
				</ul>
			</li>
			
			<li>
				<h2><img src="{$imagesource}navh2_lost.gif" alt="lost?" /></h2>
				<ul class="navSubList">
					<li><xsl:if test="/H2G2/ARTICLE/ARTICLEINFO/NAME='about'">
							<xsl:attribute name="class">selected</xsl:attribute>
						</xsl:if>
						<a href="{$root}about"><span>About Comedy Soup</span></a>
					</li>
					<li><xsl:if test="/H2G2/ARTICLE/ARTICLEINFO/NAME='help'">
							<xsl:attribute name="class">selected</xsl:attribute>
						</xsl:if>
						<a href="{$root}help"><span>Help &amp; tips</span></a>
					</li>
				</ul>
			</li>
			
			<li>
				<h2><img src="{$imagesource}navh2_relatedlinks.gif" alt="related links" /></h2>
				<ul class="navSubList">
					<li><a href="/comedy/"><span>Comedy</span></a></li>
					<li><a href="/bbcthree/"><span>BBC THREE</span></a></li>
				</ul>
			</li>
		</ul>
		<!-- debug -->
			<xsl:call-template name="VARIABLEDUMP"/>
		<!-- DEBUG -->	
	</xsl:template>
	<!-- 
	<xsl:template name="r_search_dna">
	Use: Presentation of the global search box
	-->
	<xsl:template name="r_search_dna">
		<input type="hidden" name="type" value="1"/>
		<!-- or other types -->
		<input type="hidden" name="searchtype" value="article"/>
		<!-- or forum or user -->
		<input type="hidden" name="showapproved" value="1"/>
		<!-- status 1 articles -->
		<input type="hidden" name="showsubmitted" value="1"/>
		<!-- articles in a review forum -->
		<input type="hidden" name="shownormal" value="1"/>
		<!-- user articles -->
		
		<xsl:call-template name="t_searchstring"/>
		<xsl:call-template name="t_submitsearch"/>
	</xsl:template>
	<!--
	<xsl:attribute-set name="it_searchstring"/>
	Use: Presentation attributes for the search input field
	 -->
	<xsl:attribute-set name="it_searchstring"/>
	<!--
	<xsl:attribute-set name="it_submitsearch"/>
	Use: Presentation attributes for the search submit button
	 -->
	<xsl:attribute-set name="it_submitsearch"/>
	<!--
	<xsl:attribute-set name="fc_search_dna"/>
	Use: Presentation attributes for the search form element
	 -->
	<xsl:attribute-set name="fc_search_dna"/>
	<!-- 
	<xsl:template match="H2G2" mode="r_register">
	Use: Presentation of the Register link
	-->
	<xsl:template match="H2G2" mode="r_register">
		<xsl:apply-imports/>
		<br/>
	</xsl:template>
	<!-- 
	<xsl:template match="H2G2" mode="r_login">
	Use: Presentation of the Login link
	-->
	<xsl:template match="H2G2" mode="r_login">
		<xsl:apply-imports/>
		<br/>
	</xsl:template>
	<!-- 
	<xsl:template match="H2G2" mode="r_userpage">
	Use: Presentation of the User page link
	-->
	<xsl:template match="H2G2" mode="r_userpage">
		<a href="{$root}U{VIEWING-USER/USER/USERID}">
			<span>Personal space</span>
		</a>
	</xsl:template>
	<!-- 
	<xsl:template match="H2G2" mode="r_contribute">
	Use: Presentation of the Contribute link
	-->
	<xsl:template match="H2G2" mode="r_contribute">
		<xsl:apply-imports/>
		<br/>
	</xsl:template>
	<!-- 
	<xsl:template match="H2G2" mode="r_preferences">
	Use: Presentation of the Preferences link
	-->
	<xsl:template match="H2G2" mode="r_preferences">
		<xsl:apply-imports/>
		<br/>
	</xsl:template>
	<!-- 
	<xsl:template match="H2G2" mode="r_logout">
	Use: Presentation of the Logout link
	-->
	<xsl:template match="H2G2" mode="r_logout">
		<xsl:apply-imports/>
		<br/>
	</xsl:template>
	<!--===============Local Template (Local Navigation Stuff)=====================-->
	<!--===============Primary Template (Page Stuff)=====================-->
	<xsl:template name="primary-template">
		<html>
			<xsl:call-template name="insert-header"/>
			<body marginheight="0" marginwidth="0" topmargin="0" leftmargin="0">
			<xsl:if test="(/H2G2/@TYPE='USERPAGE' and $ownerisviewer=0) or (/H2G2/MEDIAASSETBUILDER/ARTICLEMEDIAASSETINFO/ACTION='showusersarticleswithassets' and /H2G2/VIEWING-USER/USER/USERID!=/H2G2/MEDIAASSETBUILDER/ARTICLEMEDIAASSETINFO/USERSID) or (/H2G2/@TYPE='WATCHED-USERS' and $ownerisviewer=0) or (/H2G2/@TYPE='THREADS' and /H2G2/VIEWING-USER/USER/USERID!=/H2G2/FORUMSOURCE/USERPAGE/USER/USERID) or (/H2G2/@TYPE='ADDTHREAD' and /H2G2/VIEWING-USER/USER/USERID!=/H2G2/FORUMSOURCE/USERPAGE/USER/USERID) or (/H2G2/@TYPE='MULTIPOSTS' and /H2G2/VIEWING-USER/USER/USERID!=/H2G2/FORUMSOURCE/USERPAGE/USER/USERID)">
				<xsl:attribute name="class">viewerIsNotOwner</xsl:attribute>
			</xsl:if><!-- grey when when looking at someone elses personal space  - should create reusable test as used in 2 places -->
					<xsl:apply-templates select="/H2G2" mode="c_bodycontent"/>
			
			<!-- DEBUG -->
			<xsl:if test="$DEBUG = 1 or /H2G2/PARAMS/PARAM[NAME = 's_debug']/VALUE = '1'">
				<xsl:apply-templates select="/H2G2" mode="debug"/>
			</xsl:if>
			<!-- /DEBUG -->
			</body>
		</html>
	</xsl:template>
	<!--===============Primary Template (Page Stuff)=====================-->
	<!--===============Body Content Template (Global Content Stuff)=====================-->
	<xsl:template match="H2G2" mode="r_bodycontent">
	
	<div id="ssoWrapper">
		<xsl:call-template name="sso_statusbar"/>
	</div>
		
		
		<xsl:if test="$test_IsEditor">
			<br /><xsl:call-template name="quickedit"/>
		</xsl:if>

		<div class="soupContent">
		<xsl:choose> 
		<!--  This is for the site password see <xsl:template name="INVITEUSER">  -->
		<xsl:when test="/H2G2/@TYPE='UNAUTHORISED'"> 	
			<xsl:call-template name="INVITEUSER" /> 
		</xsl:when> 
		<xsl:otherwise> 
			<xsl:call-template name="insert-mainbody"/> 
		</xsl:otherwise> 
		</xsl:choose> 
		</div>
		
		<!-- this is the error form -->
		<xsl:if test="$TESTING=1"><xsl:call-template name="ERRORFORM" /></xsl:if>	
		
		<!-- this is the editorial tools box -->
		<xsl:if test="$test_IsEditor and /H2G2/@TYPE='FRONTPAGE'">
			<br /><xsl:call-template name="editorialtools"/>
		</xsl:if>
		
		
		<div class="hozDots"></div>
		<p id="disclaimer">Some of the content on Comedy Soup is generated by members of the public. The views expressed are theirs and unless specifically stated are not those of the BBC. The BBC is not responsible for the content of any external sites referenced. If you consider this content to be in breach of the <a href="houserules">house rules</a> please alert our moderators.</p>
		
		
	</xsl:template>
	<!--===============Body Content Template (Global Content Stuff)=====================-->
	<!--===============Popup Template (Popup page Stuff)=====================-->
	<xsl:template name="popup-template">
		<html>
			<xsl:call-template name="insert-header"/>
			<body bgcolor="#ffffff" text="#000000" link="#000099" vlink="#ff0000" alink="#ff0000" marginheight="0" marginwidth="0" topmargin="0" leftmargin="0">
				<xsl:call-template name="insert-mainbody"/>
			</body>
		</html>
	</xsl:template>
	<!--===============Popup Template (Popup page Stuff)=====================-->
	<!--===============Global Alpha Index=====================-->
	<xsl:template match="letter" mode="alpha">
		<xsl:text> </xsl:text>
		<xsl:apply-imports/>
	</xsl:template>
	<xsl:template name="alphaindexdisplay">
		<xsl:param name="letter"/>
		<xsl:copy-of select="$letter"/>
		<xsl:choose>
			<xsl:when test="$letter = 'M'">
				<br/>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="PARSEERRORS" mode="r_typedarticle">
		<font size="2">
		<b>Error in the XML</b>
		<br/>
		<xsl:apply-templates/>
		</font>
	</xsl:template>
	<xsl:template match="XMLERROR">
		<font color="red">
			<b>
				<xsl:value-of select="."/>
			</b>
		</font>
	</xsl:template>
	
	<!-- Thia is for the site password - the template is called in 
	<xsl:template match="H2G2" mode="r_bodycontent"> -->
	<xsl:template name="INVITEUSER"> 
	<xsl:choose> 
	<xsl:when test="REASON/@TYPE=1"> 
<!-- Main content -->
<div class="soupContent">
	<div  class="default">
		<div class="col1">
		<div class="margins">
				
<p>Comedy Soup is the BBC's online breeding ground for new comedy talent. </p>

<p>You can enjoy other people's comedy and showcase your own work, whether it be video, audio, animation or images.</p> 

<p>And it's not all just take, take, take. You'll be able to download and work with a whole heap of images, sound and video clips from the BBC's archive to make your funny stuff too.</p>

<p>You take over BBC comedy. Show us how it should be done.</p>

<p><strong>Coming Spring 2006</strong></p>

<p><strong>
If you have been invited to test the site, you need to <a href="{$dna_server}/cgi-perl/signon/mainscript.pl?service=comedysoup&amp;c=register&amp;ptrt={$dna_server}/dna/comedysoup/SSO?s_return=logout" class="rightcol"> create your membership</a>
</strong></p>
				</div>
			</div>
		</div>
		</div>
	</xsl:when> 
	<xsl:otherwise> 
	<div class="soupContent">
	<div  class="default">
		<div class="col1">
		<div class="margins">
	
		<p>You have now created your membership</p>
		<p> <strong> Please click the button below to request access to ComedySoup from the site editors.</strong> </p> 
		<br/>  			
		<form method="post" action="http://www0.bbc.co.uk/cgi-bin/cgiemail/comedysoup/includes/invite_user.txt" name="inviteuser"> 
		<input type="hidden" name="success" value="http://www.bbc.co.uk/comedysoup/inviteuser_thanks.shtml"/> 
		<input type="hidden" name="firstname" value="{/H2G2/VIEWING-USER/USER/FIRSTNAMES}"/> 
		<input type="hidden" name="surname" value="{/H2G2/VIEWING-USER/USER/LASTNAME}"/> 
		<input type="hidden" name="userid" value="{/H2G2/VIEWING-USER/USER/USERID}"/> 
		<input type="hidden" name="username" value="{/H2G2/VIEWING-USER/USER/USERNAME}"/> 
		 <input type="submit" name="submit" value="request access"/> 
		</form> 
		
			</div>
			</div>
		</div>
		</div>
	</xsl:otherwise> 
	</xsl:choose> 	
</xsl:template>

	
	<!--===============End Global Alpha Index=====================-->
</xsl:stylesheet>