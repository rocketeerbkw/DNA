<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">

]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">

	<!--===============Imported Files=====================-->
	<xsl:import href="../../../base/base-extra.xsl"/>
	<!--===============Imported Files=====================-->
	<!--===============Included Files=====================-->
	<xsl:include href="addthreadpage.xsl"/>
	<xsl:include href="articlepage.xsl"/>
	<xsl:include href="articlepage_templates.xsl"/>
	<xsl:include href="articlesearchphrase.xsl"/>
	
	
	<xsl:include href="frontpage.xsl"/>
	<xsl:include href="guideml.xsl"/>
	<xsl:include href="indexpage.xsl"/>
	<xsl:include href="infopage.xsl"/>
	<xsl:include href="inspectuserpage.xsl"/>
	
	<xsl:include href="miscpage.xsl"/>
	<xsl:include href="morearticlespage.xsl"/>
	<xsl:include href="morepostspage.xsl"/>
	<xsl:include href="multipostspage.xsl"/>
	<xsl:include href="newuserspage.xsl"/>
	<xsl:include href="onlinepage.xsl"/>
	<xsl:include href="pagetype.xsl"/>
	<xsl:include href="registerpage.xsl"/>
	<xsl:include href="searchpage.xsl"/>
	<xsl:include href="siteconfigpage.xsl"/>
	
	<xsl:include href="text.xsl"/>
	<xsl:include href="threadspage.xsl"/>
	<xsl:include href="typedarticlepage.xsl"/>
	<xsl:include href="typedarticlepage_templates.xsl"/>
	<xsl:include href="usercomplaintpopup.xsl"/>
	<xsl:include href="userdetailspage.xsl"/>
	<xsl:include href="usereditpage.xsl"/>
	<xsl:include href="userpage.xsl"/>
	<xsl:include href="watcheduserspage.xsl"/>
	
	<!-- xtra -->
	<xsl:include href="debug.xsl"/>
	<xsl:include href="sitevars.xsl"/>
	<xsl:include href="types.xsl"/>
	

	
	<!-- no base file -->
	<xsl:include href="editrecentpostpage.xsl"/>	
	<!--===============Included Files=====================-->
	<!--===============Output Setting=====================-->
		<xsl:output method="html" version="4.0" omit-xml-declaration="yes" standalone="yes" indent="yes" encoding="ISO8859-1"/>

	<!--===============Output Setting=====================-->
	<!--===============        SSO       =====================-->
	
	<!--===============        SSO       =====================-->
	<!--===============CSS=====================-->
	<xsl:variable name="csslink">
	
			<style type="text/css">
			body {margin:0;}
			form {margin:0;padding:0;}
			a.bbcpageFooter, a.bbcpageFooter:link, a.bbcpageFooter:visited {color:#673416; text-decoration:none;}
			a.bbcpageFooter:hover {color:#673416; text-decoration:underline;}
			.bbcpageFooter {color:#673416;}
			.bbcpageCrumb {font-weight:normal; text-align:left;}
			a.bbcpageCrumb { margin:0; padding:0; color:#000;}
			td.bbcpageCrumb {background:url(/images/breadcrumb_bg.gif); height:40px; vertical-align:top; padding-top:6px;}
			a.bbcpageCrumb, a.bbcpageCrumb:link,a.bbcpageCrumb:visited  { color:#000;text-decoration:none;}
			a.bbcpageCrumb:hover {text-decoration:underline;}
			a.bbcpageTopleftlink {color:#673416;}
			a.bbcpageTopleftlink:link {color:#673416;}
			.bbcpageServices {background:#FFF;font-family:Arial, Verdana, sans-serif; color:#673416;}
			.bbcpageServices hr {display:none;}
			a.bbcpageServices {color:#673416; text-decoration:none;}
			a.bbcpageServices:link {color:#673416;}
			a.bbcpageServices:hover {color:#673416; text-decoration:underline;}
			.bbcpageToplefttd {background: transparent; font-family:Arial, Verdana, sans-serif;}
			.bbcpageFooterMargin {background:#FFF;}
			.bbcpageLocal {background:#FFF;}
			.bbcpageShadow {background-color:#828282;}
			.bbcpageShadowLeft {border-left:2px solid #828282;}
			.bbcpageBar {background:#999999 url(/images/v.gif) repeat-y;}
			.bbcpageSearchL {background:#747474 url(/images/sl.gif) no-repeat;}
			.bbcpageSearch {background:#747474 url(/images/st.gif) repeat-x;}
			.bbcpageSearch2 {background:#747474 url(/images/st.gif) repeat-x 0 0;}
			.bbcpageSearchRa {background:#999999 url(/images/sra.gif) no-repeat;}
			.bbcpageSearchRb {background:#999999 url(/images/srb.gif) no-repeat;}
			.bbcpageBlack {background-color:#0000} 
			.bbcpageGrey, .bbcpageShadowLeft {background-color:#999999}
			.bbcpageWhite, font.bbcpageWhite, a.bbcpageWhite, a.bbcpageWhite:link, a.bbcpageWhite:hover, a.bbcpageWhite:visited {color:#ffffff;text-decoration:none;font-family:arial,verdana,helvetica,sans-serif;padding:1px 4px;}
			.bbcpageGutter {background:url(/images/gutter_bg.gif) repeat-x;}
			
			<!-- CV I don't think it is common practice to change these class names. 
			        All BBC pages seem to use bbcpageToplefttd which is defined in 
			        base-extra.xsl. For now I have defined only one bbcpageToplefttd
			        until further discussion/investigation
			
			.bbcpageToplefttd1 {background:#738BB4;color:#ffffff;}
			.bbcpageToplefttd2 {font-family:Arial, Verdana, sans-serif; color:#673416;}
			td.bbcpageToplefttd2 {background:url(http://www.bbc.co.uk/britishfilm/images/topleft_bg.gif);}
			-->
			
			.bbcpageToplefttd {font-family:Arial, Verdana, sans-serif; color:#673416;}
			td.bbcpageToplefttd {background:url(http://www.bbc.co.uk/britishfilm/images/topleft_bg.gif);}
			
			.bbcpageCrumb1 {font-weight:bold; text-align:right;}
			.bbcpageLocal1 {background:#a3a3a3;}
			.bbcpageServices1 {background:#fff;font-family:Arial, Verdana, sans-serif; color:#575656;}
			
			#editornav {font-size: 9pt; font-weight:normal; border: 1px gray solid; margin-left:5px}
			#editornav li{padding: 1px;}
			#typedarticle_editorbox {border: 1px gray solid; padding: 10px; background:#FFCC99;}
			</style>
			
			<style type="text/css">
				@import 'http://www.bbc.co.uk/britishfilm/includes/tbenh.css';
			</style>
			
			<style type="text/css">
				@import 'http://www.bbc.co.uk/britishfilm/css/base.css';
			</style>	
			

			
			<style type="text/css">
				<xsl:comment>
				 body {margin:0;} form {margin:0;padding:0;} .bbcpageShadow {background-color:#828282;} .bbcpageShadowLeft {border-left:2px solid #828282;} .bbcpageBar {background:#999999 url(/images/v.gif) repeat-y;} .bbcpageSearchL {background:#747474 url(/images/sl.gif) no-repeat;} .bbcpageSearch {background:#747474 url(/images/st.gif) repeat-x;} .bbcpageSearch2 {background:#747474 url(/images/st.gif) repeat-x 0 0;} .bbcpageSearchRa {background:#999999 url(/images/sra.gif) no-repeat;} .bbcpageSearchRb {background:#999999 url(/images/srb.gif) no-repeat;} .bbcpageBlack {background-color:#000000;} .bbcpageGrey, .bbcpageShadowLeft {background-color:#999999;} .bbcpageWhite,font.bbcpageWhite,a.bbcpageWhite,a.bbcpageWhite:link,a.bbcpageWhite:hover,a.bbcpageWhite:visited {color:#ffffff;text-decoration:none;font-family:verdana,arial,helvetica,sans-serif;padding:1px 4px;}
				</xsl:comment>
			</style>
			
			
			<xsl:comment><![CDATA[[if IE]>
			<style media="all" type="text/css" >
				@import url(http://www.bbc.co.uk/britishfilm/css/base_win_ie.css);
			</style>
			<![endif]]]></xsl:comment>			
			<xsl:comment><![CDATA[[if lte IE 6]>
			<style media="all" type="text/css" >
				@import url(http://www.bbc.co.uk/britishfilm/css/base_win_ie6andbelow.css);
			</style>
			<![endif]]]></xsl:comment>
			<xsl:comment><![CDATA[[if lte IE 5.5000]>
			<style media="all" type="text/css" >
				@import url(http://www.bbc.co.uk/britishfilmcss/base_win_ie55andbelow.css);
			</style>
			<![endif]]]></xsl:comment>
					
	</xsl:variable>
	<!--===============CSS=====================-->
	<!--===============Attribute-sets Settings=====================-->
	<xsl:attribute-set name="mainfont">
		<xsl:attribute name="size">2</xsl:attribute>
	</xsl:attribute-set>
	<!--===============Attribute-sets Settings=====================-->
	<!--===============Javascript=====================-->
	
	<xsl:variable name="scriptlink">
		<script language="JavaScript1.1" src="{$site_server}/britishfilm/includes/dynamichtml.js" type="text/javascript"></script>
		
	    <script type="text/javascript">
	        <xsl:call-template name="insert-javascript" />
			<xsl:comment>
				<!--Site wide Javascript goes here-->
				function popupwindow(link, target, parameters) {
					popupWin = window.open(link,target,parameters);
					if (window.focus) {popupWin.focus();}
				}
				function popusers(link) {
					popupWin = window.open(link,'popusers','status=1,resizable=1,scrollbars=1,width=165,height=340');
				}
				function submitForm(){
				document.setDetails.submit();
				}
				function popmailwin(x, y){
					window.open(x,y,'status=no,scrollbars=yes,resizable=yes,width=350,height=400');
				}
			//	function rsubmitFormNow(){
			//		Id = window.setTimeout("submitFormNow();",1000);
			//	} 

				<xsl:text>//</xsl:text>
				
			function validate(form)	{	
				flag = true;
				var reqfields
				reqfields=document.getElementById('required').value.split(',');
				
				for(i=0;i&lt;reqfields.length;i++){
				
					if (form.elements(reqfields[i]).value == ""){
						flag = false;
						document.getElementById(reqfields[i]).style.color='#FF0000';
						document.getElementById('validatemsg').style.visibility='visible';
						//return false;
					} else {
						document.getElementById(reqfields[i]).style.color='#5E5D5D';
					}

				}
				
				//if any fields are empty don't submit
				if (flag == false){
					return false;
				}
				
				
				//if email address is invalid alert he user
				if (form.email) {
					var str = form.email.value;
					var re = /^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$/;	
					if (!str.match(re)) {
						alert("Please check you have typed your email address correctly.");
						return false; 
					}
				}
				
			return true;
			}
			
			</xsl:comment>
		</script>

	</xsl:variable>
	<!--===============Javascript=====================-->
	<!--===============Variable Settings=====================-->
	<xsl:variable name="bbcpage_bgcolor">ffffff</xsl:variable>
	<xsl:variable name="bbcpage_nav">yes</xsl:variable>
	<xsl:variable name="bbcpage_navwidth">125</xsl:variable>
	<xsl:variable name="bbcpage_navgraphic">yes</xsl:variable>
	<xsl:variable name="bbcpage_navgutter">yes</xsl:variable>
	<xsl:variable name="bbcpage_contentwidth">635</xsl:variable>
	<xsl:variable name="bbcpage_contentalign">left</xsl:variable>
	<xsl:variable name="bbcpage_language">english</xsl:variable>
	<xsl:variable name="bbcpage_searchcolour">747474</xsl:variable>
	<xsl:variable name="bbcpage_topleft_bgcolour"/>
	<xsl:variable name="bbcpage_topleft_linkcolour"/>
	<xsl:variable name="bbcpage_topleft_textcolour"/>
	<xsl:variable name="bbcpage_lang"/>
	<xsl:variable name="bbcpage_variant"/>
	<!--===============Variable Settings=====================-->
	<!--===============Banner Template (Banner Area Stuff)=====================-->
	<xsl:variable name="banner-content">
		<xsl:choose>
			<xsl:when test="/H2G2/SERVERNAME = $development_server">
				<div class="banner"><img src="{$imagesource}minimoviesmadebyyou.jpg" alt="Mini movies made by you" width="645" height="100" /></div> 
			</xsl:when>
			<xsl:otherwise>
				<div class="banner"><img src="{$imagesource}minimoviesmadebyyou.jpg" alt="Mini movies made by you" width="645" height="100" /></div> 
				
				<!--<div class="crumb"><a href="http://news.bbc.co.uk/sport1/hi/2809419.stm">Help</a></div>-->
				
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<!--===============Banner Template (Banner Area Stuff)=====================-->
	<!--===============Crumb Template (Crumb Navigation Stuff)=====================-->
	<xsl:variable name="crumb-content">
		<!-- CV We are not using any crumbtrails, so I left this variable blank. It is called in base-extra.xsl -->
	</xsl:variable>
	<!--===============Crumb Template (Crumb Navigation Stuff)=====================-->
	<!--===============Local Template (Local Navigation Stuff)=====================-->
	<xsl:template name="local-content"> 
	
	<!-- CV Currently each link has a 'current page' class defined. I left that in for now,
	        in case this functionality was overlooked. If need be we can strip these 
	        classes out.
	-->
		<ul>
			<!-- Film Forever Homepage Link-->
			<li>
				<a href="{$root}" ><xsl:if test="@TYPE='FRONTPAGE'"><xsl:attribute name="class">leftnav_selected</xsl:attribute></xsl:if><span>home</span></a>
			</li>
			
			<!-- Submit Link -->
			<li>				
				<a href="{$root}Articlesubmit" ><xsl:if test="/H2G2/ARTICLE/ARTICLEINFO/NAME = 'Articlesubmit'"><xsl:attribute name="class">leftnav_selected</xsl:attribute></xsl:if><span>submit</span></a>
			</li>
			
			<!-- Browse Link -->
			<li>
				<a href="{$root}ArticleSearch?phrase=film&amp;contenttype=-1&amp;articlestatus=1&amp;articlesortby=DateUploaded&amp;show=20" ><xsl:if test="/H2G2/@TYPE='ARTICLESEARCH'"><xsl:attribute name="class">leftnav_selected</xsl:attribute></xsl:if><span>browse</span></a>
			</li>
			
			<!-- Tips Link -->
			<li>				
				<a href="{$root}tips"><xsl:if test="/H2G2/ARTICLE/ARTICLEINFO/NAME='tips'"><xsl:attribute name="class">leftnav_selected</xsl:attribute></xsl:if><span>tips</span></a>
			</li>

			<!-- summer of british film Link -->
			<li>
				<xsl:if test="ARTICLE/ARTICLEINFO/NAME='summer'"><xsl:attribute name="class">leftnav_selectedlast</xsl:attribute></xsl:if>
				<a href="{$root}summer"><span>summer of british film</span></a>
			</li>
		</ul>
		
		
		<!-- editor/host tools -->
		<xsl:if test="$test_IsEditor">
		<div id="editornav">
		<ul>
			<li>
			<xsl:choose>		
					<xsl:when test="/H2G2/@TYPE='ARTICLE' or /H2G2/@TYPE='USERPAGE'">
						<!-- logged in user. -->
						<a href="{$root}TypedArticle?aedit=new&amp;type={$current_article_type}&amp;h2g2id={/H2G2/ARTICLE/ARTICLEINFO/H2G2ID}">edit page</a>
					</xsl:when>
					<xsl:otherwise>
						edit page
					</xsl:otherwise>
				</xsl:choose>
			</li>
			<li><a href="{$root}editfrontpage">edit homepage</a></li>
			<li><a href="{$root}inspectuser">edit user</a></li>
			<li><a href="{$root}Moderate">moderate</a></li>
			<li><a href="{$root}ArticleSearch?contenttype=-1&amp;articlestatus=3&amp;articlesortby=DateUploaded&amp;show=20&amp;phrase=film">browse submitted</a></li>
			
			<li>
				<a>
					<xsl:attribute name="href">
						<xsl:choose>
							<xsl:when test="/H2G2/SERVERNAME = $staging_server">http://www0.bbc.co.uk/dna/britishfilm/dlct</xsl:when>
							<xsl:otherwise>http://www.bbc.co.uk/dna/britishfilm/dlct</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
					dynamic list
				</a>
			</li>
		</ul>
	
		<ul>
			<li><a href="{$root}info?cmd=conv">recent conv.</a></li>
			<li><a href="{$root}newusers">new users</a></li>
			<li><a href="{$root}ArticleSearch?contenttype=-1&amp;s_show=members&amp;show=100">member pages</a></li>
		</ul>
	
		<ul>
			<li><a href="{$root}siteschedule">opening/closing</a></li>
			<li><a href="{$root}ArticleSearch?contenttype=-1">search tags</a></li>
			<li><a href="{$root}ArticleSearch?contenttype=-1&amp;s_show=top100">top 100 tags</a></li>
		</ul>
	
		<ul>
			<li>
					<a>
					<xsl:attribute name="href">
					<xsl:call-template name="sso_typedarticle_signin">
					<xsl:with-param name="type" select="10"/>
					</xsl:call-template>
					</xsl:attribute>
					new film article
					</a>
				</li>
				<li>
					<a>
					<xsl:attribute name="href">
					<xsl:call-template name="sso_typedarticle_signin">
					<xsl:with-param name="type" select="12"/>
					</xsl:call-template>
					</xsl:attribute>
					new tip article
					</a>
				</li>
				<li>
					<a>
					<xsl:attribute name="href">
					<xsl:call-template name="sso_typedarticle_signin">
					<xsl:with-param name="type" select="13"/>
					</xsl:call-template>
					</xsl:attribute>
					new article (general)
					</a>
				</li>
				<li>
					<a>
					<xsl:attribute name="href">
					<xsl:call-template name="sso_typedarticle_signin">
					<xsl:with-param name="type" select="1"/>
					</xsl:call-template>
					</xsl:attribute>
					create dlist page
					</a>
				</li>
				<li><a href="{$root}NamedArticles">name articles</a></li>
		</ul>
	
		<ul>
				<li>
					<a href="{$root}TypedArticle?aedit=new&amp;h2g2id=A5917737">
					edit submit page
					</a>
				</li>
				<li>
					<a href="{$root}TypedArticle?aedit=new&amp;h2g2id=A5917746">
					edit tip index
					</a>
				</li>
		</ul>
		
		</div>
		</xsl:if>
		
		
				<div class="image"><img src="{$imagesource}bbc2logo.gif" alt="BBC TWO" /></div>

				<div class="faq"><a href="/bbctwo/help/faq">BBC TWO FAQ</a></div>
		
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
		<br/>
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
		<xsl:apply-imports/>
		<br/>
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
			<xsl:if test="/H2G2/@TYPE='ADDTHREAD' and /H2G2/POSTTHREADFORM/SECONDSBEFOREREPOST">
				<xsl:attribute name="onload">setInterval('countDown()', 1000);</xsl:attribute>
			</xsl:if>
			
			<!--
			<xsl:if test="/H2G2/@TYPE='MULTIPOSTS'">
				<xsl:attribute name="onload">stripeLists();</xsl:attribute>
			</xsl:if>
			-->
			
			<xsl:apply-templates select="/H2G2" mode="c_bodycontent"/>
			
			
			<xsl:if test="$TESTING=1 and not(/H2G2/@TYPE='UNAUTHORISED')"><xsl:call-template name="ERRORFORM" /></xsl:if>
			
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
	
		<!--<div id="sso">-->
		<xsl:call-template name="sso_statusbar"/>
		<!--</div>-->
		<table width="635" border="0" cellpadding="0" cellspacing="0" id="contentstructure">
			<tr>
				<!-- start of middle column -->
				<td width="411">
					<xsl:choose>
						<xsl:when test="/H2G2[@type='ARTICLESEARCH']"><xsl:attribute name="class">contentfull</xsl:attribute></xsl:when>
						<xsl:otherwise><xsl:attribute name="class">contentleft</xsl:attribute></xsl:otherwise>
					</xsl:choose>
					<xsl:call-template name="insert-mainbody"/>
				</td>
				<!-- end of middle column -->			
			
					<xsl:variable name="AID"><xsl:value-of select="/H2G2/ARTICLE/ARTICLEINFO/H2G2ID" /></xsl:variable>				
				
				
				<xsl:if test="/H2G2[@type!='ARTICLESEARCH'] | /H2G2[@TYPE!='TYPED-ARTICLE']">
				<td width="224" class="contentright">
					<div> 
					<xsl:choose>
						<xsl:when test="/H2G2/@TYPE ='FRONTPAGE'"><xsl:attribute name="class">share first</xsl:attribute></xsl:when>
						<xsl:otherwise><xsl:attribute name="class">rightcontainer top5films first</xsl:attribute></xsl:otherwise>
					</xsl:choose>
					<!-- CV Use dynamic list and have conditional to determine which one to use (if you like this OR top5) -->
					

									
					<xsl:choose>
					
						<!-- TOP 5 -->
						<xsl:when test="$current_article_type=13 or $current_article_type=12"> <!-- all except articles except film articles PAGE /H2G2/ARTICLE/ARTICLEINFO/NAME='tips' -->
						<h2><img src="{$imagesource}top5films.gif" alt="Top 5 Films" width="126" height="33" /></h2>
						<ul>
							<xsl:for-each select="/H2G2/DYNAMIC-LISTS/LIST[@LISTNAME='topfive']/ITEM-LIST/ITEM[position() &lt; 6]">
								<li><a>
									<xsl:attribute name="href"><xsl:value-of select="concat($root, 'A', ARTICLE-ITEM/@H2G2ID)" /></xsl:attribute><xsl:value-of select="ARTICLE-ITEM/SUBJECT" /></a></li>
							</xsl:for-each>
						</ul>		
						</xsl:when>
						
						<!-- LATEST -->
						<xsl:when test="/H2G2/ARTICLE/ARTICLEINFO/NAME = 'Articlesubmit'">
						<h2><img src="{$imagesource}latest5films.gif" alt="Latest films" width="149" height="33" /></h2>
						<ul>
							<xsl:for-each select="/H2G2/DYNAMIC-LISTS/LIST[@LISTNAME='latest']/ITEM-LIST/ITEM[position() &lt; 6]">
								<li><a>
									<xsl:attribute name="href"><xsl:value-of select="concat($root, 'A', ARTICLE-ITEM/@H2G2ID)" /></xsl:attribute><xsl:value-of select="ARTICLE-ITEM/SUBJECT" /></a></li>
							</xsl:for-each>
						</ul>		
						</xsl:when>
						
						<!-- IF YOU LIKE THIS -->
						<xsl:when test="$current_article_type=10 or /H2G2/@TYPE = 'ADDTHREAD'"><!-- and count(/H2G2/DYNAMIC-LISTS/LIST[@LISTNAME=/H2G2/ARTICLE/GUIDE/GENRE01]/ITEM-LIST/ITEM) &gt; 1 -->
						<h2><img src="{$imagesource}right/ifyoulikethis.jpg" alt="If you like this..." width="180" height="32" /></h2>
						<ul>
							<xsl:for-each select="/H2G2/DYNAMIC-LISTS/LIST[@LISTNAME=/H2G2/ARTICLE/GUIDE/GENRE01]/ITEM-LIST/ITEM[position() &lt; 6]">
							<xsl:if test="/H2G2/ARTICLE/ARTICLEINFO/H2G2ID != ARTICLE-ITEM/@H2G2ID">
								<li><a>
									<xsl:attribute name="href"><xsl:value-of select="concat($root, 'A', ARTICLE-ITEM/@H2G2ID)" /></xsl:attribute><xsl:value-of select="ARTICLE-ITEM/SUBJECT" /></a></li>
							</xsl:if>
							</xsl:for-each>
						</ul>						
						</xsl:when>
					</xsl:choose>
					</div>
									
					<xsl:if test="($current_article_type=13 and /H2G2/ARTICLE/ARTICLEINFO/NAME!='Articlesubmit') or $current_article_type=12 or $current_article_type=10 or /H2G2/@TYPE = 'ADDTHREAD' or /H2G2/@TYPE ='FRONTPAGE'">
					<div class="share">
						<a href="{$root}Articlesubmit" class="banner"><img src="{$imagesource}shareyourfilms.jpg" alt="share you films" /></a>
					</div>
					</xsl:if>
					
					<xsl:if test="$current_article_type=13 or $current_article_type=12 or $current_article_type=10 or /H2G2/@TYPE = 'ADDTHREAD' or /H2G2/@TYPE ='FRONTPAGE'">
					<div class="rate">
						<a href="{$root}ArticleSearch?phrase=film&amp;contenttype=-1&amp;articlestatus=1&amp;articlesortby=DateUploaded&amp;show=20"  class="banner"><img src="{$imagesource}browsewatchrate.jpg" alt="browse watch &amp; rate" /></a>
					</div>
					</xsl:if>
					
					<xsl:if test="$current_article_type=10 or $current_article_type=13">
					<div class="tips">
						<a href="{$root}tips" class="banner"><img src="{$imagesource}tipsandinspiration.jpg" alt="tips &amp; inspiration" /></a>
					</div>
					</xsl:if>
				
				
					<!-- DYNAMIC LISTS FOR FRONTPAGE -->
					
					<xsl:if test="/H2G2/@TYPE ='FRONTPAGE'">
						
						<!-- LATEST -->
						<div class="rightcontainer latest">
						<h2><img src="{$imagesource}right/latestfilms.jpg" alt="Latest films" /></h2>
						<ul>
							<xsl:for-each select="/H2G2/DYNAMIC-LISTS/LIST[@LISTNAME='latest']/ITEM-LIST/ITEM[position() &lt; 6]">
								<li><a>
									<xsl:attribute name="href"><xsl:value-of select="concat($root, 'A', ARTICLE-ITEM/@H2G2ID)" /></xsl:attribute><xsl:value-of select="ARTICLE-ITEM/SUBJECT" />
								</a></li>
							</xsl:for-each>
						</ul>
						</div>
						
						
						<!-- TOP 5 -->
						<div class="rightcontainer mostpopular">
						<h2><img src="{$imagesource}right/mostpopular.jpg" alt="Most popular" /></h2>
						<ul>
							<xsl:for-each select="/H2G2/DYNAMIC-LISTS/LIST[@LISTNAME='topfive']/ITEM-LIST/ITEM[position() &lt; 6]">
								<li><a>
									<xsl:attribute name="href"><xsl:value-of select="concat($root, 'A', ARTICLE-ITEM/@H2G2ID)" /></xsl:attribute><xsl:value-of select="ARTICLE-ITEM/SUBJECT" />
								</a></li>
							</xsl:for-each>
						</ul>
						</div>

						
						<!-- CLASSICS REQUESTED REMOVED BY MORWEENA AS NOT APPROVAL FOR CLASSIC FILMS -->
						<!-- <div class="rightcontainer clips">
						<h2><img src="{$imagesource}right/classicclips.jpg" alt="Classic clips" /></h2>
						<ul>
							<xsl:for-each select="/H2G2/DYNAMIC-LISTS/LIST[@LISTNAME='classics']/ITEM-LIST/ITEM[position() &lt; 5]">
								<li><a>
									<xsl:attribute name="href"><xsl:value-of select="concat($root, 'A', ARTICLE-ITEM/@H2G2ID)" /></xsl:attribute><xsl:value-of select="ARTICLE-ITEM/SUBJECT" />
								</a></li>
							</xsl:for-each>
						</ul>
						</div>			 -->			
		
					</xsl:if>
	
				</td>
				</xsl:if>
			</tr>
		</table>
		
		<xsl:if test="/H2G2[@TYPE!='TYPED-ARTICLE']">
		<xsl:comment>#include virtual="/britishfilm/includes/promo.sssi" </xsl:comment>
		<!-- <div class="divider2"></div>
		<div id="baselinks">			
			<div class="linkbox map">
				<h2>MAP</h2>
				<p><img src="{$imagesource}base/map.gif" alt="" />Lorem ipsum dolor sit amet, cons adipiscing elit. Aenean scelerisq.</p>
			</div>
			<div class="linkbox promo">
				<h2>PROMO BOX</h2>

				<p><img src="{$imagesource}base/promotemp.jpg" alt="" />Lorem ipsum dolor sit amet, cons adipiscing</p>
			</div>
			<div class="linkbox links">
				<h2>LIST OF LINKS</h2>
				<ul>
					<li>Lorem ipsum dolor sit</li>
					<li>Ipsum dolor sit</li>

					<li>Cons adipiscing elit</li>
					<li>Aenean scelerisq</li>
				</ul>
			</div>
		</div>
		<div id="disclaimer">
			   <p>Some of the content on British Mini Movies is generated by members of the public. The views expressed are theirs and unless specifically stated are not those of the BBC. The BBC is not responsible for the content of any external sites referenced. If you consider this content to be in breach of the <a href="/dna/britishfilm/houserules/" title="House Rules">House Rules</a> please alert our moderators</p>
			</div> -->
		</xsl:if>
		
	</xsl:template>
	<!--===============Body Content Template (Global Content Stuff)=====================-->
	<!--===============Popup Template (Popup page Stuff)=====================-->
	<xsl:template name="popup-template">
		<xsl:choose>
			<xsl:when test="/H2G2/@TYPE='ONLINE'">
				<xsl:call-template name="primary-template"/>
			</xsl:when>
			<xsl:otherwise>
			<html>
				<xsl:call-template name="insert-header"/>
				<body bgcolor="#ffffff" text="#000000" link="#000099" vlink="#ff0000" alink="#ff0000" marginheight="0" marginwidth="0" topmargin="0" leftmargin="0">
					<xsl:call-template name="insert-mainbody"/>
					
				<!-- DEBUG -->
				<xsl:if test="$DEBUG = 1 or /H2G2/PARAMS/PARAM[NAME = 's_debug']/VALUE = '1'">
					<xsl:apply-templates select="/H2G2" mode="debug"/>
				</xsl:if>
				<!-- /DEBUG -->
				</body>
			</html>
			</xsl:otherwise>
		</xsl:choose>
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
		<xsl:text> </xsl:text>
		<span class="alert">
			<strong>
				<xsl:value-of select="."/>
			</strong>
		</span>
		<xsl:text> </xsl:text>
	</xsl:template>
	<!--===============End Global Alpha Index=====================-->

		
	<xsl:template match="INCLUDE">
			<xsl:comment>#include virtual="<xsl:value-of select="@SRC" />"</xsl:comment>
	</xsl:template>
	
	
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
						EXTRAINFO
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	
	
	<xsl:template match="EXTRAINFO/SPORT">
		<xsl:choose>
			<!-- is it one of the 13 sports? -->
			<xsl:when test="text() and not(text()='Othersport')">
				<a>
					<xsl:attribute name="href">
						<xsl:value-of select="$articlesearchlink" /><xsl:value-of select="." />
					</xsl:attribute>
					<xsl:value-of select="." />
				</a>
			</xsl:when>
			<!-- is it one of the 33 sports -->
			<xsl:when test="../OTHERSPORT/text()">
				<xsl:choose>
					<!-- no -->
					<xsl:when test="../OTHERSPORT/text()='Othersportusers'">
						<a>
							<xsl:attribute name="href">
								<xsl:value-of select="$articlesearchlink" /><xsl:apply-templates select="../OTHERSPORTUSERS"/>
							</xsl:attribute>
							<xsl:apply-templates select="../OTHERSPORTUSERS"/>
						</a>
					</xsl:when>
					<!-- yes -->
					<xsl:otherwise>
						<a>
							<xsl:attribute name="href">
								<xsl:value-of select="$articlesearchlink" /><xsl:apply-templates select="../OTHERSPORT"/>
							</xsl:attribute>
							<xsl:apply-templates select="../OTHERSPORT"/>
						</a>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<!-- must be something else -->
			<xsl:otherwise>
				<a>
					<xsl:attribute name="href">
						<xsl:value-of select="$articlesearchlink" /><xsl:apply-templates select="../OTHERSPORTUSERS"/>
					</xsl:attribute>
					<xsl:apply-templates select="../OTHERSPORTUSERS"/>
				</a>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="EXTRAINFO/OTHERSPORT">
		<xsl:choose>
			<xsl:when test="text()">
				<xsl:value-of select="." />
			</xsl:when>
			<xsl:otherwise>
				Other Sport
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="EXTRAINFO/OTHERSPORTUSERS">
		<xsl:value-of select="."/>
	</xsl:template>
	
	
	<xsl:template match="EXTRAINFO/COMPETITION/text()">
		<xsl:text> | </xsl:text>
		<xsl:choose>
			<xsl:when test="not(.='Othercompetition')">
				<a>
					<xsl:attribute name="href">
						<xsl:value-of select="$articlesearchlink" /><xsl:value-of select="." />
					</xsl:attribute>
					<xsl:value-of select="." />
				</a>
			</xsl:when>
			<xsl:otherwise>
				<a>
					<xsl:attribute name="href">
						<xsl:value-of select="$articlesearchlink" /><xsl:value-of select="../following-sibling::OTHERCOMPETITION/text()" />
					</xsl:attribute>
					<xsl:value-of select="../following-sibling::OTHERCOMPETITION/text()" />
				</a>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	
	<xsl:template match="EXTRAINFO/TYPE">
		<xsl:variable name="this_type" select="@ID"/>
		| 
		<a>
			<xsl:attribute name="href">
				<xsl:value-of select="$articlesearchlink" /><xsl:value-of select="msxsl:node-set($type)/type[@number=$this_type]/@label" />
			</xsl:attribute>
			<xsl:value-of select="msxsl:node-set($type)/type[@number=$this_type]/@label" />
		</a>
	</xsl:template>
	
	
	<xsl:template match="EXTRAINFO/DATECREATED">
		<!-- test for article type - and display date created and last updated accordingly - convert 20060808173251 into readable date -->
		
		<xsl:variable name="year"><xsl:value-of select="substring(., 1, 4)"/></xsl:variable>
		<xsl:variable name="month"><xsl:value-of select="substring(., 5, 2)"/></xsl:variable>
		<xsl:variable name="monthname">
			<xsl:choose>
				<xsl:when test="$month = 01">January</xsl:when>
				<xsl:when test="$month = 02">February</xsl:when>
				<xsl:when test="$month = 03">March</xsl:when>
				<xsl:when test="$month = 04">April</xsl:when>
				<xsl:when test="$month = 05">May</xsl:when>
				<xsl:when test="$month = 06">June</xsl:when>
				<xsl:when test="$month = 07">July</xsl:when>
				<xsl:when test="$month = 08">August</xsl:when>
				<xsl:when test="$month = 09">September</xsl:when>
				<xsl:when test="$month = 10">October</xsl:when>
				<xsl:when test="$month = 11">November</xsl:when>
				<xsl:when test="$month = 12">December</xsl:when>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="day"><xsl:value-of select="substring(., 7, 2)"/></xsl:variable>
		
		<div><xsl:value-of select="$day"/><xsl:text> </xsl:text><xsl:value-of select="$monthname"/> <xsl:text> </xsl:text><xsl:value-of select="$year"/></div>	
	</xsl:template>
	
	<xsl:template match="EXTRAINFO/LASTUPDATED">
		<xsl:value-of select="."/>
	</xsl:template>
	
	<xsl:template match="EXTRAINFO/AUTHORUSERID">
		<div class="articleauthor">by <a href="{$root}U{.}"><xsl:value-of select="../AUTHORUSERNAME"/></a></div>
	</xsl:template>
	
	<xsl:template match="EXTRAINFO/AUTHORUSERNAME">
		<xsl:value-of select="text()"/>
	</xsl:template>
				
	<xsl:template match="EXTRAINFO/AUTODESCRIPTION/text()">
		<div class="articletext"><xsl:value-of select="."/></div>
	</xsl:template>
	
	
	
	<!--
	############################################
		templates used on multiple pages 
	############################################
	-->
	
	
	<xsl:template name="siteclosed">
		<div class="commenterror">
			Sorry, but you can only contribute to British Film when the site is not closed.
		</div>
	</xsl:template>
	
	<!-- used on userpage and typedarticle -->
	<xsl:template name="USERPAGE_BANNER">
		<div id="mainbansec">
			<div class="banartical"><h3>Member page</h3></div>		
			<div class="clear"></div>
			
			<h3 class="memberhead">
			<xsl:value-of select="/H2G2/ARTICLE/ARTICLEINFO/PAGEAUTHOR/EDITOR/USER/USERNAME" />
			</h3>
			<div class="memberdate">
				member since:<xsl:text> </xsl:text><xsl:value-of select="/H2G2/ARTICLE/ARTICLEINFO/DATECREATED/DATE/@DAYNAME" /> <xsl:text> </xsl:text><xsl:value-of select="/H2G2/ARTICLE/ARTICLEINFO/DATECREATED/DATE/@DAY" /><xsl:text> </xsl:text><xsl:value-of select="/H2G2/ARTICLE/ARTICLEINFO/DATECREATED/DATE/@MONTHNAME" /><xsl:text> </xsl:text><xsl:value-of select="/H2G2/ARTICLE/ARTICLEINFO/DATECREATED/DATE/@YEAR" />
			</div>
		</div>
	</xsl:template>


	<!-- 
		CONVERTGENRENAME
		used to resolve search ters to readable words
	-->
	<xsl:template name="CONVERTGENRENAME">
		<xsl:param name="searchterm"/>
		<!-- only changing words with spaces as others are already in correct lowercase format -->
		<xsl:choose>
			<xsl:when test="$searchterm = 'scifi'">sci-fi</xsl:when>
			<xsl:when test="$searchterm = 'soundtrack'">great soundtrack</xsl:when>
			<xsl:when test="$searchterm = 'peculiar'">funny peculiar</xsl:when>
			<xsl:when test="$searchterm = 'technical'">technical wizardry</xsl:when>
			<xsl:when test="$searchterm = 'costumedrama'">costume drama</xsl:when>
			<xsl:when test="$searchterm = 'socialrealism'">social realism</xsl:when>
			<xsl:when test="$searchterm = 'tale'">twist in the tale</xsl:when>
			<xsl:when test="$searchterm = 'hotlead'">hot lead</xsl:when>
			<xsl:when test="$searchterm = 'urbantale'">urban tale</xsl:when>
			<xsl:when test="$searchterm = 'blackcomedy'">black comedy</xsl:when>
			<xsl:when test="$searchterm = 'datingdisaster'">dating disaster</xsl:when>
			<xsl:when test="$searchterm = 'hollywoodending'">hollywood ending</xsl:when>
			<xsl:when test="$searchterm = 'loverat'">love rat</xsl:when>
			<xsl:otherwise><xsl:value-of select="$searchterm" /></xsl:otherwise>
		</xsl:choose>
		



	</xsl:template>
		
	<xsl:template name="ADVANCED_SEARCH">
	<!-- SWAP CSS -->
		<!-- <br clear="all" class="clearall" /> -->
		<div id="searchbgnewtop"></div>
		<div id="searchboxnew">
			<div id="searchboxnewinner">
				<img class="topbotinner" src="{$imagesource}search/topinner.jpg" alt="" />
				<div id="searchboxnewformwrap">



		
	
			<form method="POST" action="{$root}ArticleSearch" name='jumpto' >
				<h2><img src="{$imagesource}search/searchby.jpg" alt="Search by:" /></h2>
<BR/>
			<input type="hidden" name="contenttype" value="-1" />
			<input type="hidden" name="articlesortby" value="Rating" />
			<input type="hidden" name="articlestatus" value="1" />

			
			<noscript>You must enable JavaScript to use dropdown menus to navigate.</noscript>
			<!-- <br /> -->
			<!-- DROP DOWNS FOR TAG SEARCH -->


			<div class="selectlist">
			<script type="text/javascript" language="JavaScript">
			<xsl:comment>
			<![CDATA[ 


				document.write('<label for="genre"><span class="hidden">Genre</span></label>')
document.write('<select id="genre" name="mylist1" onchange="window.location.href=document.jumpto.mylist1.options[document.jumpto.mylist1.selectedIndex].value;">');
			
							document.write('<option value="]]><xsl:value-of select="$root"/><![CDATA[ArticleSearch?phrase=film&amp;contenttype=-1&amp;rticlesortby=DateUploaded&amp;show=20&amp;articlestatus=1">Genre</option>');
							document.write('<option value="]]><xsl:value-of select="$root"/><![CDATA[ArticleSearch?phrase=film&amp;contenttype=-1&amp;articlesortby=DateUploaded&amp;show=20&amp;articlestatus=1">all</option>');
							document.write('<option value="]]><xsl:value-of select="$root"/><![CDATA[ArticleSearch?contenttype=-1&amp;articlestatus=1&amp;articlesortby=DateUploaded&amp;show=20&amp;phrase=comedy">Comedy</option>');
							document.write('<option value="]]><xsl:value-of select="$root"/><![CDATA[ArticleSearch?contenttype=-1&amp;articlestatus=1&amp;articlesortby=DateUploaded&amp;show=20&amp;phrase=peculiar">Funny Peculiar</option>');
							document.write('<option value="]]><xsl:value-of select="$root"/><![CDATA[ArticleSearch?contenttype=-1&amp;articlestatus=1&amp;articlesortby=DateUploaded&amp;show=20&amp;phrase=love">Love</option>');
							document.write('<option value="]]><xsl:value-of select="$root"/><![CDATA[ArticleSearch?contenttype=-1&amp;articlestatus=1&amp;articlesortby=DateUploaded&amp;show=20&amp;phrase=scifi">Sci-fi</option>');
							document.write('<option value="]]><xsl:value-of select="$root"/><![CDATA[ArticleSearch?contenttype=-1&amp;articlestatus=1&amp;articlesortby=DateUploaded&amp;show=20&amp;phrase=thriller">Thriller</option>');
							document.write('<option value="]]><xsl:value-of select="$root"/><![CDATA[ArticleSearch?contenttype=-1&amp;articlestatus=1&amp;articlesortby=DateUploaded&amp;show=20&amp;phrase=chilling">Chilling</option>');
							document.write('<option value="]]><xsl:value-of select="$root"/><![CDATA[ArticleSearch?contenttype=-1&amp;articlestatus=1&amp;articlesortby=DateUploaded&amp;show=20&amp;phrase=costumedrama">Costume Drama</option>');
							document.write('<option value="]]><xsl:value-of select="$root"/><![CDATA[ArticleSearch?contenttype=-1&amp;articlestatus=1&amp;articlesortby=DateUploaded&amp;show=20&amp;phrase=socialrealism">Social Realism</option>');
							document.write('<option value="]]><xsl:value-of select="$root"/><![CDATA[ArticleSearch?contenttype=-1&amp;articlestatus=1&amp;articlesortby=DateUploaded&amp;show=20&amp;phrase=gritty">Gritty</option>');
							document.write('<option value="]]><xsl:value-of select="$root"/><![CDATA[ArticleSearch?contenttype=-1&amp;articlestatus=1&amp;articlesortby=DateUploaded&amp;show=20&amp;phrase=horror">Horror</option>');
							document.write('<option value="]]><xsl:value-of select="$root"/><![CDATA[ArticleSearch?contenttype=-1&amp;articlestatus=1&amp;articlesortby=DateUploaded&amp;show=20&amp;phrase=soundtrack">Great Soundtrack</option>');
							document.write('<option value="]]><xsl:value-of select="$root"/><![CDATA[ArticleSearch?contenttype=-1&amp;articlestatus=1&amp;articlesortby=DateUploaded&amp;show=20&amp;phrase=technical">Technical Wizardry</option>');
							document.write('<option value="]]><xsl:value-of select="$root"/><![CDATA[ArticleSearch?contenttype=-1&amp;articlestatus=1&amp;articlesortby=DateUploaded&amp;show=20&amp;phrase=war">War</option>');
				document.write('</select>');
				]]>
			</xsl:comment>
			</script>
				<noscript>
					<ul>
						<li><a href="{$root}ArticleSearch?phrase=film&amp;contenttype=-1&amp;articlesortby=DateUploaded&amp;show=20">all</a></li>
						<li><a href="{$root}ArticleSearch?contenttype=-1&amp;articlestatus=1&amp;articlesortby=DateUploaded&amp;show=20&amp;phrase=comedy">Comedy</a></li>
						<li><a href="{$root}ArticleSearch?contenttype=-1&amp;articlestatus=1&amp;articlesortby=DateUploaded&amp;show=20&amp;phrase=peculiar">Funny Peculiar</a></li>
						<li><a href="{$root}ArticleSearch?contenttype=-1&amp;articlestatus=1&amp;articlesortby=DateUploaded&amp;show=20&amp;phrase=love">Love</a></li>
						<li><a href="{$root}ArticleSearch?contenttype=-1&amp;articlestatus=1&amp;articlesortby=DateUploaded&amp;show=20&amp;phrase=scifi">Sci-fi</a></li>
						<li><a href="{$root}ArticleSearch?contenttype=-1&amp;articlestatus=1&amp;articlesortby=DateUploaded&amp;show=20&amp;phrase=thriller">Thriller</a></li>
						<li><a href="{$root}ArticleSearch?contenttype=-1&amp;articlestatus=1&amp;articlesortby=DateUploaded&amp;show=20&amp;phrase=chilling">chilling</a></li>
						<li><a href="{$root}ArticleSearch?contenttype=-1&amp;articlestatus=1&amp;articlesortby=DateUploaded&amp;show=20&amp;phrase=costumedrama">Costume Drama</a></li>
						<li><a href="{$root}ArticleSearch?contenttype=-1&amp;articlestatus=1&amp;articlesortby=DateUploaded&amp;show=20&amp;phrase=socialrealism">Social Realism</a></li>
						<li><a href="{$root}ArticleSearch?contenttype=-1&amp;articlestatus=1&amp;articlesortby=DateUploaded&amp;show=20&amp;phrase=gritty">Gritty</a></li>
						<li><a href="{$root}ArticleSearch?contenttype=-1&amp;articlestatus=1&amp;articlesortby=DateUploaded&amp;show=20&amp;phrase=horror">Horror</a></li>
						<li><a href="{$root}ArticleSearch?contenttype=-1&amp;articlestatus=1&amp;articlesortby=DateUploaded&amp;show=20&amp;phrase=soundtrack">Great Soundtrack</a></li>
						<li><a href="{$root}ArticleSearch?contenttype=-1&amp;articlestatus=1&amp;articlesortby=DateUploaded&amp;show=20&amp;phrase=technical">Technical Wizardry</a></li>
						<li><a href="{$root}ArticleSearch?contenttype=-1&amp;articlestatus=1&amp;articlesortby=DateUploaded&amp;show=20&amp;phrase=war">War</a></li>
					</ul>
				</noscript>

				</div>
				<div class="or">or</div>
			
			
			<div class="selectlist">
			<script type="text/javascript" language="JavaScript">
			<xsl:comment>
			<![CDATA[ 

			document.write('<label for="theme"><span class="hidden">Theme</span></label>');
			document.write('<select id="theme" name="mylist2" onchange="window.location.href=document.jumpto.mylist2.options[document.jumpto.mylist2.selectedIndex].value;">');
						document.write('<option value="]]><xsl:value-of select="$root"/><![CDATA[ArticleSearch?phrase=film&amp;contenttype=-1&amp;articlesortby=DateUploaded&amp;show=20">Theme</option>');
						document.write('<option value="]]><xsl:value-of select="$root"/><![CDATA[ArticleSearch?phrase=film&amp;contenttype=-1&amp;articlesortby=DateUploaded&amp;show=20">all</option>');
						document.write('<option value="]]><xsl:value-of select="$root"/><![CDATA[ArticleSearch?contenttype=-1&amp;articlestatus=1&amp;articlesortby=DateUploaded&amp;show=20&amp;phrase=tale">Twist in the Tale</option>');
						document.write('<option value="]]><xsl:value-of select="$root"/><![CDATA[ArticleSearch?contenttype=-1&amp;articlestatus=1&amp;articlesortby=DateUploaded&amp;show=20&amp;phrase=hotlead">Hot Lead</option>');
						document.write('<option value="]]><xsl:value-of select="$root"/><![CDATA[ArticleSearch?contenttype=-1&amp;articlestatus=1&amp;articlesortby=DateUploaded&amp;show=20&amp;phrase=urbantale">Urban Tale</option>');
						document.write('<option value="]]><xsl:value-of select="$root"/><![CDATA[ArticleSearch?contenttype=-1&amp;articlestatus=1&amp;articlesortby=DateUploaded&amp;show=20&amp;phrase=blackcomedy">Black Comedy</option>');
						document.write('<option value="]]><xsl:value-of select="$root"/><![CDATA[ArticleSearch?contenttype=-1&amp;articlestatus=1&amp;articlesortby=DateUploaded&amp;show=20&amp;phrase=random">Random</option>');
						document.write('<option value="]]><xsl:value-of select="$root"/><![CDATA[ArticleSearch?contenttype=-1&amp;articlestatus=1&amp;articlesortby=DateUploaded&amp;show=20&amp;phrase=experimental">Experimental</option>');
						document.write('<option value="]]><xsl:value-of select="$root"/><![CDATA[ArticleSearch?contenttype=-1&amp;articlestatus=1&amp;articlesortby=DateUploaded&amp;show=20&amp;phrase=datingdisaster">Dating Disaster</option>');
						document.write('<option value="]]><xsl:value-of select="$root"/><![CDATA[ArticleSearch?contenttype=-1&amp;articlestatus=1&amp;articlesortby=DateUploaded&amp;show=20&amp;phrase=hollywoodending">Hollywood Ending</option>');
						document.write('<option value="]]><xsl:value-of select="$root"/><![CDATA[ArticleSearch?contenttype=-1&amp;articlestatus=1&amp;articlesortby=DateUploaded&amp;show=20&amp;phrase=sick">Sick</option>');
						document.write('<option value="]]><xsl:value-of select="$root"/><![CDATA[ArticleSearch?contenttype=-1&amp;articlestatus=1&amp;articlesortby=DateUploaded&amp;show=20&amp;phrase=loverat">Love Rat</option>');
			document.write('</select>');
			]]>
			</xsl:comment>
			</script>
			
			<noscript>
							<ul>
								<li><a href="{$root}ArticleSearch?phrase=film&amp;contenttype=-1&amp;articlesortby=DateUploaded&amp;show=20">all</a></li>
								<li><a href="{$root}ArticleSearch?contenttype=-1&amp;articlesortby=DateUploaded&amp;show=20&amp;articlestatus=1&amp;phrase=tale">Twist in the Tale</a></li>
								<li><a href="{$root}ArticleSearch?contenttype=-1&amp;articlesortby=DateUploaded&amp;show=20&amp;articlestatus=1&amp;phrase=hotlead">Hot Lead</a></li>
								<li><a href="{$root}ArticleSearch?contenttype=-1&amp;articlesortby=DateUploaded&amp;show=20&amp;articlestatus=1&amp;phrase=urbantale">Urban Tale</a></li>
								<li><a href="{$root}ArticleSearch?contenttype=-1&amp;articlesortby=DateUploaded&amp;show=20&amp;articlestatus=1&amp;phrase=blackcomedy">Black Comedy</a></li>
								<li><a href="{$root}ArticleSearch?contenttype=-1&amp;articlesortby=DateUploaded&amp;show=20&amp;articlestatus=1&amp;phrase=random">Random</a></li>
								<li><a href="{$root}ArticleSearch?contenttype=-1&amp;articlesortby=DateUploaded&amp;show=20&amp;articlestatus=1&amp;phrase=experimental">Experimental</a></li>
								<li><a href="{$root}ArticleSearch?contenttype=-1&amp;articlesortby=DateUploaded&amp;show=20&amp;articlestatus=1&amp;phrase=datingdisaster">Dating Disaster</a></li>
								<li><a href="{$root}ArticleSearch?contenttype=-1&amp;articlesortby=DateUploaded&amp;show=20&amp;articlestatus=1&amp;phrase=hollywoodending">Hollywood Ending</a></li>
								<li><a href="{$root}ArticleSearch?contenttype=-1&amp;articlesortby=DateUploaded&amp;show=20&amp;articlestatus=1&amp;phrase=sick">Sick</a></li>
								<li><a href="{$root}ArticleSearch?contenttype=-1&amp;articlesortby=DateUploaded&amp;show=20&amp;articlestatus=1&amp;phrase=loverat">Love Rat</a></li>
							</ul>
						</noscript>
			</div>
			<div class="or">or</div>


			<div class="selectlist">
			<script type="text/javascript" language="JavaScript">
			<xsl:comment>
			<![CDATA[ 
			document.write('<label for="other"><span class="hidden">Other</span></label>');
			document.write('<select id="other" name="mylist3" onchange="window.location.href=document.jumpto.mylist3.options[document.jumpto.mylist3.selectedIndex].value;">');
			document.write('<option value="">Other</option>');
						document.write('<option value="]]><xsl:value-of select="$root"/><![CDATA[ArticleSearch?phrase=film&amp;contenttype=-1&amp;articlesortby=DateUploaded&amp;show=20">all</option>');
						document.write('<option value="]]><xsl:value-of select="$root"/><![CDATA[ArticleSearch?contenttype=-1&amp;articlesortby=DateUploaded&amp;show=20&amp;articlestatus=1&amp;phrase=mobile">mobile</option>');
						document.write('<option value="]]><xsl:value-of select="$root"/><![CDATA[ArticleSearch?contenttype=-1&amp;articlesortby=DateUploaded&amp;show=20&amp;articlestatus=1&amp;phrase=video">video</option>');
						document.write('<option value="]]><xsl:value-of select="$root"/><![CDATA[ArticleSearch?contenttype=-1&amp;articlesortby=DateUploaded&amp;show=20&amp;articlestatus=1&amp;phrase=animation">animation</option>');
						document.write('<option value="]]><xsl:value-of select="$root"/><![CDATA[ArticleSearch?contenttype=-1&amp;articlesortby=DateUploaded&amp;show=20&amp;articlestatus=1&amp;phrase=puppets">puppets</option>');
			document.write('</select>');
			]]>
			</xsl:comment>
			</script>
			<noscript>
					<ul title="Other">
						<li><a href="{$root}ArticleSearch?phrase=film&amp;contenttype=-1&amp;articlestatus=1&amp;articlesortby=DateUploaded&amp;show=20">all</a></li>
						<li><a href="{$root}ArticleSearch?contenttype=-1&amp;articlesortby=DateUploaded&amp;show=20&amp;articlestatus=1&amp;phrase=mobile">mobile</a></li>
						<li><a href="{$root}ArticleSearch?contenttype=-1&amp;articlesortby=DateUploaded&amp;show=20&amp;articlestatus=1&amp;phrase=video">video</a></li>
						<li><a href="{$root}ArticleSearch?contenttype=-1&amp;articlesortby=DateUploaded&amp;show=20&amp;articlestatus=1&amp;phrase=animation">animation</a></li>
						<li><a href="{$root}ArticleSearch?contenttype=-1&amp;articlesortby=DateUploaded&amp;show=20&amp;articlestatus=1&amp;phrase=puppets">puppets</a></li>

					</ul>
				</noscript>
		
			</div>
			</form>
		</div>	
			



			<!-- CV sort by -->
			<div id="sortresultsby"><BR/>
		 	<h2><img src="{$imagesource}search/sortby.jpg" alt="Sort results by:" /></h2><BR/>
			
			
		 		<xsl:variable name="searchterm">
						<xsl:for-each select="/H2G2/ARTICLESEARCH/PHRASES/PHRASE"><xsl:value-of select="NAME"/><xsl:if test="position() != last()"><xsl:text> </xsl:text></xsl:if></xsl:for-each>
				</xsl:variable>
				<xsl:variable name="params">
						<xsl:for-each select="/H2G2/PARAMS/PARAM">&amp;<xsl:value-of select="NAME"/>=<xsl:value-of select="VALUE"/></xsl:for-each>&amp;show=<xsl:value-of select="@COUNT"/>
				</xsl:variable>


				<div class="sortlist">
				<xsl:choose>
				  <xsl:when test="@SORTBY='DateUploaded' or not(@SORTBY)"><a class="sortselected">most recent films first</a></xsl:when>
					<xsl:otherwise><a href="?phrase={$searchterm}&amp;contenttype=-1&amp;articlestatus=1&amp;articlesortby=DateUploaded{$params}">most recent films first</a></xsl:otherwise>
				</xsl:choose>
				</div>

				
				<div class="sortlist">
		 		<xsl:choose>
					<xsl:when test="@SORTBY='Caption'"><a class="sortselected">by title</a></xsl:when>
					<xsl:otherwise><a href="?phrase={$searchterm}&amp;contenttype=-1&amp;articlestatus=1&amp;articlesortby=Caption{$params}">by title</a></xsl:otherwise>
				</xsl:choose>
				</div>
				
									
			  <xsl:if test="not(/H2G2/PARAMS/PARAM[NAME='s_show']/VALUE='members')"><!-- hide when displaying member pages as will not have ratings to sort by -->
				
				<!-- <xsl:text> | </xsl:text> -->
				
				<div class="sortlist">
				<xsl:choose>
					<xsl:when test="@SORTBY='Rating'"><a class="sortselected">highest rated first</a></xsl:when>
					<xsl:otherwise><a href="?phrase={$searchterm}&amp;contenttype=-1&amp;articlestatus=1&amp;articlesortby=Rating{$params}">highest rated first</a></xsl:otherwise>
				</xsl:choose>
				</div>
				<!-- <div class="browsespacer" style="height:40px; "> </div> -->
				</xsl:if>


				<xsl:choose>
					<xsl:when test="$test_IsEditor">
						<xsl:variable name="sort">
							<xsl:if test="ARTICLESEARCH/@SORTBY">
								&amp;articlesortby=<xsl:value-of select="ARTICLESEARCH/@SORTBY"/>
							</xsl:if>
						</xsl:variable>
					</xsl:when>
				</xsl:choose>
				
			</div>
					<img class="topbotinner" src="{$imagesource}search/botinner.jpg" alt="" />
				</div>
			</div>
			<div id="searchbgnewbot"></div>
		
			<!-- <input type="image" alt="sort" src="{$imagesource}search/sort.jpg" class="button" /> -->
					
			

	</xsl:template>
    
    <xsl:template name="sso_statusbar">
    </xsl:template>
	
	




</xsl:stylesheet>