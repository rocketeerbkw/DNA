<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
	<!ENTITY copy "&#169;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<!--===============Imported Files=====================-->
	<xsl:import href="../../../base/base-extra.xsl"/>
	<!--===============Imported Files=====================-->
	<!--===============Included Files=====================-->

	<xsl:include href="addthreadpage.xsl"/>
	<xsl:include href="articlepage.xsl"/>
	<xsl:include href="articlepage_templates.xsl"/>
	<!--<xsl:include href="articlesearchphrase.xsl"/>-->
  <xsl:include href="articlesearch.xsl"/>
  
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
	<xsl:include href="registerpage.xsl"/>
	<xsl:include href="searchpage.xsl"/>
	<!-- <xsl:include href="siteconfigpage.xsl"/> -->
	
	<xsl:include href="text.xsl"/>
	<xsl:include href="threadspage.xsl"/>
	<xsl:include href="typedarticlepage.xsl"/>
	<xsl:include href="typedarticlepage_templates.xsl"/>
	<xsl:include href="typedarticlepage_templates_combined.xsl"/>
	<xsl:include href="typedarticlepage_templates_shared.xsl"/>
	<xsl:include href="usercomplaintpopup.xsl"/>
	<xsl:include href="userdetailspage.xsl"/>
	<xsl:include href="usereditpage.xsl"/>
	<xsl:include href="userpage.xsl"/>
	<xsl:include href="watcheduserspage.xsl"/>
	
	<!-- xtra -->
	<xsl:include href="debug.xsl"/>
	<xsl:include href="sitevars.xsl"/>
	<xsl:include href="team_data.xsl"/>
	<xsl:include href="types.xsl"/>
	
	<xsl:include href="XHTMLOutput.xsl"/>
	
	<!-- from other sites -->
	<xsl:include href="../../boards/default/boardopeningschedulepage.xsl"/>
	
	<!-- no base file -->
	<xsl:include href="editrecentpostpage.xsl"/>
	
	<!-- phase 2 -->
	<!-- <xsl:include href="addjournalpage.xsl"/> -->
	<!-- <xsl:include href="journalpage.xsl"/> -->
	
	<xsl:key name="xmltype" match="/H2G2/PARAMS/PARAM[NAME='s_xml']" use="VALUE"/>
	
	<!--===============Included Files=====================-->
	<!--===============Output Setting=====================-->
	<xsl:output method="html" version="4.0" omit-xml-declaration="yes" standalone="yes" indent="no" encoding="ISO8859-1" doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd" />
	<!--===============Output Setting=====================-->
	<!--===============        SSO       =====================-->
	
	<!--===============        SSO       =====================-->
	
	<xsl:variable name="development_asset_root">http://www.bbc.co.uk/606/2/</xsl:variable>
	<xsl:variable name="staging_asset_root">http://www.bbc.co.uk/606/2/</xsl:variable>
	<xsl:variable name="live_asset_root">http://www.bbc.co.uk/606/2/</xsl:variable>	
	
		<!--===============CSS=====================-->
	<xsl:variable name="csslink">
		<xsl:if test="not(/H2G2/@TYPE='USER-COMPLAINT')">
            <xsl:choose>
                <xsl:when test="/H2G2/@TYPE='ARTICLE' and /H2G2/ARTICLE/EXTRAINFO/TYPE/@ID=4">
                    <link type="text/css" rel="stylesheet" href="http://www.bbc.co.uk/606/2/css/1/popup.css"/>
                    <link type="text/css" rel="stylesheet" href="{$development_asset_root}606/css/1/editor.css"/>
                </xsl:when>
                <xsl:otherwise>
                    <link type="text/css" rel="stylesheet" href="{$live_asset_root}refresh/css/1/styles.css?20061116"/>
                    <link type="text/css" rel="stylesheet" href="{$live_asset_root}refresh/css/1/editor.css"/>
                    <style type="text/css">
                        #commentheadbox .links a {color: #009; }
                    </style>
                </xsl:otherwise>
            </xsl:choose>
		</xsl:if>
	
		<xsl:call-template name="insert-css"/>
		
		<link type="text/css" rel="stylesheet" href="/dnaimages/boards/includes/login.css"/>
		<link type="text/css" rel="stylesheet" href="/dnaimages/boards/includes/login2.css"/>
	</xsl:variable>
	<!--===============CSS=====================-->
	<!--===============Attribute-sets Settings=====================-->
	<xsl:attribute-set name="mainfont">
		<xsl:attribute name="size">2</xsl:attribute>
	</xsl:attribute-set>
	<!--===============Attribute-sets Settings=====================-->
	<!--===============Javascript=====================-->
	<xsl:variable name="scriptlink">
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
		<script src="http://www.bbc.co.uk/cs/jst/mod/1/jst_cookies.js" type="text/javascript" language="JavaScript"></script>
		<script src="http://www.bbc.co.uk/cs/jst/mod/1/jst_http.js" type="text/javascript" language="JavaScript"></script>
		<script src="http://www.bbc.co.uk/cs/jst/mod/1/jst_dom.js" type="text/javascript" language="JavaScript"></script>

		<xsl:comment>
			#####################
			End JSTools includes.
			#####################
		</xsl:comment>
	
		<xsl:if test="/H2G2/@TYPE='TYPED-ARTICLE'">
			<xsl:choose>
				<xsl:when test="/H2G2/SERVERNAME = $development_server">
					<script type="text/javascript" src="{$development_asset_root}606/js/hideothers.js"></script>
					<script type="text/javascript" src="{$development_asset_root}606/js/form_counter.js"></script>
					<script type="text/javascript" src="{$development_asset_root}606/js/create.js"></script>
				</xsl:when>
				<xsl:when test="/H2G2/SERVERNAME = $staging_server">
					<script type="text/javascript" src="{$staging_asset_root}refresh/js/hideothers.js"></script>
					<script type="text/javascript" src="{$staging_asset_root}refresh/js/form_counter.js"></script>
					<script type="text/javascript" src="{$staging_asset_root}refresh/js/create.js"></script>
				</xsl:when>
				<xsl:otherwise>
					<script type="text/javascript" src="{$live_asset_root}refresh/js/hideothers.js"></script>
					<script type="text/javascript" src="{$live_asset_root}refresh/js/form_counter.js"></script>
					<script type="text/javascript" src="{$live_asset_root}refresh/js/create.js"></script>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>

		<!-- script for a/v console -->
		<script src="http://newsimg.bbc.co.uk/sol/shared/js/sol3.js" language="JavaScript" type="text/javascript"></script>
		
		<xsl:call-template name="insert-javascript"/>
		
		<script type="text/javascript">
			<xsl:comment>
				<![CDATA[
				function popupwindow(link, target, parameters) {
					popupWin = window.open(link,target,parameters);
				}
				function popusers(link) {
					popupWin = window.open(link,'popusers','status=1,resizable=1,scrollbars=1,width=165,height=340');
				}
				
				function popmailwin(x, y) {window.open(x,y,'status=no,scrollbars=yes,resizable=yes,width=350,height=400');}
				]]>
				<xsl:text>//</xsl:text>
			</xsl:comment>
		</script>

		<xsl:choose>
			<xsl:when test="/H2G2/SERVERNAME = $development_server">
				<!--===============CSS for Javascript enabled clients=====================-->
				<script type="text/javascript">
					<xsl:comment>
						document.write('&lt;' + 'link rel="stylesheet" href="<xsl:value-of select="$development_asset_root"/>606/css/1/606Js.css" type="text/css" media="screen, handheld"' + '/&gt;');
					//</xsl:comment>
				</script>
			</xsl:when>
			<xsl:when test="/H2G2/SERVERNAME = $staging_server">
				<!--===============CSS for Javascript enabled clients=====================-->
				<script type="text/javascript">
					<xsl:comment>
						document.write('&lt;' + 'link rel="stylesheet" href="<xsl:value-of select="$staging_asset_root"/>refresh/css/1/606Js.css" type="text/css" media="screen, handheld"' + '/&gt;');
					//</xsl:comment>
				</script>
			</xsl:when>
			<xsl:otherwise>
				<!--===============CSS for Javascript enabled clients=====================-->
				<script type="text/javascript">
					<xsl:comment>
						document.write('&lt;' + 'link rel="stylesheet" href="<xsl:value-of select="$live_asset_root"/>refresh/css/1/606Js.css" type="text/css" media="screen, handheld"' + '/&gt;');
					//</xsl:comment>
				</script>
			</xsl:otherwise>
		</xsl:choose>
		
		<xsl:if test="/H2G2/@TYPE='ADDTHREAD' and /H2G2/POSTTHREADFORM/SECONDSBEFOREREPOST">
			<script type="text/javascript" language="javascript">
			<xsl:comment>
			<![CDATA[
			function countDown() {
				var minutesSpan = document.getElementById("minuteValue");
				var secondsSpan = document.getElementById("secondValue");

				var minutes = new Number(minutesSpan.childNodes[0].nodeValue);
				var seconds = new Number(secondsSpan.childNodes[0].nodeValue);

				var inSeconds = (minutes*60) + seconds;
				var timeNow = inSeconds - 1;			

				if (timeNow >= 0){
					var scratchPad = timeNow / 60;
					var minutesNow = Math.floor(scratchPad);
					var secondsNow = (timeNow - (minutesNow * 60));			

					var minutesText = document.createTextNode(minutesNow);
					var secondsText = document.createTextNode(secondsNow);

					minutesSpan.removeChild(minutesSpan.childNodes[0]);
					secondsSpan.removeChild(secondsSpan.childNodes[0]);

					minutesSpan.appendChild(minutesText);
					secondsSpan.appendChild(secondsText);
				}
			}
			]]>
			//</xsl:comment>
			</script>

		</xsl:if>
	</xsl:variable>
	<!--===============Javascript=====================-->
	
	
	<!--===============Variable Settings=====================-->
	<xsl:variable name="bbcpage_bgcolor"/>
	<xsl:variable name="bbcpage_nav">yes</xsl:variable>
	<xsl:variable name="bbcpage_navwidth">121</xsl:variable>
	<xsl:variable name="bbcpage_navgraphic">yes</xsl:variable>
	<xsl:variable name="bbcpage_navgutter">yes</xsl:variable>
	<xsl:variable name="bbcpage_contentwidth">629</xsl:variable>
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
		<xsl:choose>
			<xsl:when test="/H2G2/SERVERNAME = $development_server">
				<div class="banner">
					<a href="http://news.bbc.co.uk/sport"><img src="/dnaimages/606/606_close_760.gif" border="0" width="760" height="66" alt="The 606 website is no longer open to comments and is not being maintained." id="banner" /></a>
				</div>
			</xsl:when>
			<xsl:otherwise>
				<div class="banner">
					<a href="http://news.bbc.co.uk/sport"><img src="/dnaimages/606/606_close_760.gif" border="0" width="760" height="66" alt="The 606 website is no longer open to comments and is not being maintained." id="banner" /></a>
				</div>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<!--===============Banner Template (Banner Area Stuff)=====================-->
	<!--===============Crumb Template (Crumb Navigation Stuff)=====================-->
	<xsl:variable name="crumb-content">
		<font size="2">
			<strong>
				<a target="_top" href="{$root}">
					<xsl:value-of select="$alt_frontpage"/>
				</a>
			</strong>
		</font>
	</xsl:variable>
	<!--===============Crumb Template (Crumb Navigation Stuff)=====================-->
	<!--===============Local Template (Local Navigation Stuff)=====================-->
	<xsl:template name="local-content">
		<div class="lhs">
		<h3 class="hide">Main links</h3>  
		<ul>
			<li class="home"><a class="lhsnl" href="http://news.bbc.co.uk/sport/default.stm">Sport Homepage</a></li>
		</ul>
		<div class="lhsdl">---------------</div>
		
		<ul>
			<li><a class="lhsnl" href="{$cpshome}">606 Homepage</a></li>
			<li>
				<xsl:if test="@TYPE='USERPAGE' and $ownerisviewer">
					<xsl:attribute name="class">lhssq</xsl:attribute>
				</xsl:if>
				<xsl:choose>		
					<xsl:when test="/H2G2/VIEWING-USER/USER">
						<a href="{$root}U{VIEWING-USER/USER/USERID}" class="lhsnl">
							Member Page
						</a>
					</xsl:when>
					<xsl:otherwise>
						<a href="{$sso_signinlink}" class="lhsnl">Member Page</a>
					</xsl:otherwise>
				</xsl:choose>
			</li>
		</ul>
		<div class="lhsdl">---------------</div>
		
		<ul>
			<li>
				<xsl:if test="/H2G2/@TYPE='INFO' and /H2G2/INFO/@MODE='articles'">
					<xsl:attribute name="class">lhssq</xsl:attribute>
				</xsl:if>
				<a href="{$root}info?cmd=art&amp;show=50" class="lhsnl">
					Most recent...
				</a>
			</li>
			<li>
				<xsl:if test="/H2G2/ARTICLE/ARTICLEINFO/NAME='favourites'">
					<xsl:attribute name="class">lhssq</xsl:attribute>
				</xsl:if>
				<a href="{$root}favourites" class="lhsnl">	
					Best of...
				</a>
			</li>
		</ul>
		
		<div class="lhsdl">---------------</div>
		
		<ul>
			<li>
				<xsl:if test="/H2G2/@TYPE='ARTICLESEARCH' and /H2G2/ARTICLESEARCH/PHRASES/@COUNT='1' and /H2G2/ARTICLESEARCH/PHRASES/PHRASE/NAME='article'">
					<xsl:attribute name="class">lhssq</xsl:attribute>
				</xsl:if>
				<a href="{$root}ArticleSearch?phrase=article&amp;contenttype=-1&amp;show=20" class="lhsnl">
					Articles
				</a>
			</li>
			<li>
				<xsl:if test="/H2G2/@TYPE='ARTICLESEARCH' and /H2G2/ARTICLESEARCH/PHRASES/@COUNT='1' and /H2G2/ARTICLESEARCH/PHRASES/PHRASE/NAME='report'">
					<xsl:attribute name="class">lhssq</xsl:attribute>
				</xsl:if>
				<a href="{$root}ArticleSearch?phrase=report&amp;contenttype=-1&amp;show=20" class="lhsnl">	
					Reports
				</a>
			</li>
			<li>
				<xsl:if test="/H2G2/@TYPE='ARTICLESEARCH' and /H2G2/ARTICLESEARCH/PHRASES/@COUNT='1' and /H2G2/ARTICLESEARCH/PHRASES/PHRASE/NAME='profile'">
					<xsl:attribute name="class">lhssq</xsl:attribute>
				</xsl:if>
				<a href="{$root}ArticleSearch?phrase=profile&amp;contenttype=-1&amp;show=20" class="lhsnl">
					Profiles
				</a>
			</li>
		</ul>
		
		<div class="lhsdl">---------------</div>
		
		<ul>
			<li>
				<xsl:if test="/H2G2/@TYPE='ONLINE'">
					<xsl:attribute name="class">lhssq</xsl:attribute>
				</xsl:if>
				<a href="{$root}online?thissite=1&amp;orderby=name" class="lhsnl">
					Members online
				</a>
			</li>
		</ul>
		
		<div class="lhsdl">---------------</div>
		<h3 class="hide">Service links</h3>  
		<ul>
		<li>
			<xsl:if test="/H2G2/ARTICLE/ARTICLEINFO/NAME='searchhelp'">
				<xsl:attribute name="class">lhssq</xsl:attribute>
			</xsl:if>
			<a class="lhsnl" href="{$root}searchhelp">Tag search</a>
		</li>
		<li><a class="lhsnl" href="http://news.bbc.co.uk/sport1/hi/front_page/5255800.stm">Help</a></li>
		<li><a class="lhsnl" href="http://news.bbc.co.uk/sport1/hi/front_page/5341886.stm">About this site</a></li>
		<li><a class="lhsnl" href="http://news.bbc.co.uk/sport1/hi/front_page/5257104.stm">FAQ</a></li>
		<li><a class="lhsnl" href="http://news.bbc.co.uk/sport1/hi/front_page/5341958.stm">Feedback</a></li>
		<li>
			<xsl:if test="/H2G2/ARTICLE/ARTICLEINFO/NAME='houserules'">
				<xsl:attribute name="class">lhssq</xsl:attribute>
			</xsl:if>
			<a class="lhsnl" href="{$root}houserules">House rules</a>
		</li>
		</ul>
		
		<div class="lhsdl">---------------</div>
		<h3 class="hide">podcast</h3> 
		<ul>
		
		<li><a class="lhsnl" href="http://www.bbc.co.uk/fivelive/programmes/606.shtml">Phone-in podcasts</a></li>
		</ul>
		
		<div class="lhsdl">---------------</div>
		<h3 class="hide">Other sites links</h3> 
		<ul>
		<li><a class="lhsnl" href="http://www.bbc.co.uk/fivelive/ ">Radio Five Live</a></li>
		</ul>
		
		<xsl:call-template name="EDITOR_TOOLS"/>		
		
		</div>
		
		<!-- debug -->
		<xsl:call-template name="VARIABLEDUMP"/>
		<!-- DEBUG -->
		
		<br />
		<br />
		<br />
	</xsl:template>
	
	<xsl:template name="EDITOR_TOOLS">
		<!-- editor/host tools -->
		<xsl:if test="$test_IsEditor">
			<div id="editornav" class="lhs">
			<ul>
				<li>
				<xsl:choose>		
						<xsl:when test="/H2G2/@TYPE='ARTICLE' or /H2G2/@TYPE='USERPAGE'">
							<!-- logged in user. -->
							<a>
								<xsl:attribute name="href">
									<xsl:value-of select="$root"/>
									<xsl:text>TypedArticle?aedit=new</xsl:text>
									<xsl:text>&amp;type=</xsl:text>
									<xsl:value-of select="$current_article_type"/>
									<xsl:if test="$current_article_type = 1">
										<xsl:text>&amp;s_editorial=1</xsl:text>
									</xsl:if>
									<xsl:text>&amp;h2g2id=</xsl:text>
									<xsl:value-of select="/H2G2/ARTICLE/ARTICLEINFO/H2G2ID"/>
								</xsl:attribute>
								<xsl:text>edit page</xsl:text>
							</a>
						</xsl:when>
						<xsl:otherwise>
							edit page
						</xsl:otherwise>
					</xsl:choose>
				</li>
				<li><a href="{$root}inspectuser">edit user</a></li>
				<li><a href="{$root}Moderate">moderate</a></li>

				<li>
					<a>
						<xsl:attribute name="href">
							<xsl:choose>
								<xsl:when test="/H2G2/SERVERNAME = $development_server">
									<xsl:value-of select="concat($root,'dlct')"/>
								</xsl:when>
								<xsl:otherwise>http://www0.bbc.co.uk/dna/606/dlct</xsl:otherwise>
							</xsl:choose>
						</xsl:attribute>
						dynamic list
					</a>
				</li>
			</ul>
			<br />
			<ul>
				<li><a href="{$root}info?cmd=conv">recent conv.</a></li>
				<li><a href="{$root}newusers">new users</a></li>
				<li><a href="{$root}ArticleSearch?contenttype=-1&amp;s_show=members&amp;show=100">member pages</a></li>
			</ul>
			<br />
			<ul>
				<li><a href="{$root}siteschedule">opening/closing</a></li>
				<li><a href="{$root}ArticleSearch?contenttype=-1">search tags</a></li>
				<li><a href="{$root}ArticleSearch?contenttype=-1&amp;s_show=predefinedtags">predefined tags</a></li>
				<li><a href="{$root}ArticleSearch?contenttype=-1&amp;s_show=top100">top 100 tags</a></li>
			</ul>
			<br />
			<ul>
				<li>
						<a>
						<xsl:attribute name="href">
						<xsl:call-template name="sso_typedarticle_signin">
						<xsl:with-param name="type" select="15"/>
						</xsl:call-template>
						</xsl:attribute>
						create staff article
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
					<li>
						<a>
						<xsl:attribute name="href">
						<xsl:call-template name="sso_typedarticle_signin">
							<xsl:with-param name="type" select="2"/>
						</xsl:call-template>
						</xsl:attribute>
						create info page
						</a>
					</li>
					<li><a href="{$root}NamedArticles">name articles</a></li>
					<li><a href="{$root}TypedArticle?aedit=new&amp;type=4&amp;h2g2id=5933720">Edit badges popup</a></li>
			</ul>

			</div>
		</xsl:if>
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
				<script language="javascript" type="text/javascript">
					bbcjs.addOnLoadItem("setInterval('countDown()', 1000)");
				</script>
			</xsl:if>
			<xsl:if test="/H2G2/@TYPE='TYPED-ARTICLE'">
				<script language="javascript" type="text/javascript">
					bbcjs.addOnLoadItem("combinedFormsOnLoad()");
				</script>
			</xsl:if>
			
			<!--
			<xsl:if test="/H2G2/@TYPE='MULTIPOSTS'">
				<xsl:attribute name="onload">stripeLists();</xsl:attribute>
			</xsl:if>
			-->
			<xsl:call-template name="layout-template"/>
			
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
        <xsl:choose>
            <xsl:when test="/H2G2/@TYPE='ARTICLE' and /H2G2/ARTICLE/EXTRAINFO/TYPE/@ID=4">
                <xsl:call-template name="insert-mainbody"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                	<xsl:when test="/H2G2/SITE/IDENTITYSIGNIN = 0">
                		<div id="sso"><xsl:call-template name="sso_statusbar"/></div>
                	</xsl:when>
                	<xsl:otherwise>
                		<xsl:choose>
	                		<xsl:when test="not(/H2G2/@TYPE = 'ONLINE')">
	                			<!-- <xsl:call-template name="identity_statusbar"/> -->
	                		</xsl:when>
	                		<xsl:otherwise>
	                			<div id="sso">&#160;</div>
	                		</xsl:otherwise>
                		</xsl:choose>
                	</xsl:otherwise>
                </xsl:choose>
                <xsl:call-template name="insert-mainbody"/>
            </xsl:otherwise>
		</xsl:choose>
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
	
	
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
						EXTRAINFO
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	
	<xsl:template match="EXTRAINFO/MANAGERSPICK/text()">
	<xsl:param name="oddoreven"/>
		<div class="managerspick"><img src="{$imagesource}managerpick/{$oddoreven}.gif" width="17" height="17" alt=""/>Managers pick</div>
	</xsl:template>
	
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
                <xsl:variable name="href">
                    <xsl:value-of select="$root" />
                    <xsl:text>ArticleSearch?contenttype=-1&amp;phrase=</xsl:text>
                    <xsl:value-of select="translate(., ' ', '+')" />
                    <xsl:choose>
                        <xsl:when test="../../SPORT='Othersport'">
                            <xsl:text>&amp;phrase=</xsl:text>
                            <xsl:value-of select="../../OTHERSPORT"/>
                        </xsl:when>
                        <xsl:when test="../../SPORT">
                            <xsl:text>&amp;phrase=</xsl:text>
                            <xsl:value-of select="../../SPORT"/>
                        </xsl:when>
                    </xsl:choose>
                </xsl:variable>
				<a>
					<xsl:attribute name="href"><xsl:value-of select="$href"/></xsl:attribute>
					<xsl:value-of select="." />
				</a>
			</xsl:when>
			<xsl:otherwise>
                <xsl:variable name="href">
                    <xsl:value-of select="$root" />
                    <xsl:text>ArticleSearch?contenttype=-1&amp;phrase=</xsl:text>
                    <xsl:value-of select="translate(../following-sibling::OTHERCOMPETITION/text(), ' ', '+')" />
                    <xsl:choose>
                        <xsl:when test="../../SPORT='Othersport'">
                            <xsl:text>&amp;phrase=</xsl:text>
                            <xsl:value-of select="../../OTHERSPORT"/>
                        </xsl:when>
                        <xsl:when test="../../SPORT">
                            <xsl:text>&amp;phrase=</xsl:text>
                            <xsl:value-of select="../../SPORT"/>
                        </xsl:when>
                    </xsl:choose>
                </xsl:variable>
				<a>
					<xsl:attribute name="href"><xsl:value-of select="$href"/></xsl:attribute>
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
	
	<!-- override from base sso.xsl -->
	<xsl:template name="sso_typedarticle_signin">
		<!-- its a template as their needs to be a param variable for the type, it cannot hold the full, can change text easily as well -->
		<xsl:param name="type"/>
		<xsl:param name="sport"/>
		
		<xsl:choose>
			<xsl:when test="/H2G2/VIEWING-USER/USER or /H2G2/VIEWING-USER/SSO/SSOLOGINNAME">
				<xsl:value-of select="concat($root, 'TypedArticle?acreate=new')"/>
				<xsl:if test="$type">
					<xsl:value-of select="concat('&amp;type=', $type)"/>
					<xsl:if test="$type = 1">
						<xsl:text>&amp;s_editorial=1</xsl:text>
					</xsl:if>
					
					<xsl:if test="$sport">
						<xsl:value-of select="concat('&amp;s_sport=', $sport)"/>
					</xsl:if>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="concat($sso_rootlogin, 'SSO%3Fpa=editpage%26pt=category%26category=', /H2G2/HIERARCHYDETAILS/@NODEID)"/>
				<xsl:if test="$type">
					<xsl:value-of select="concat('%26pt=type%26type=', $type)"/>
					<xsl:if test="$type = 1">
						<xsl:text>%26s_editorial=1</xsl:text>
					</xsl:if>
					
					<xsl:if test="$sport">
						<xsl:value-of select="concat('%26s_sport=', $sport)"/>
					</xsl:if>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="siteclosed">
		<div class="commenterror">
			Sorry, you can only contribute to 606 during opening hours. These are 0900-2300 UK time, seven days a week, but may vary to accommodate sporting events and UK public holidays.
		</div>
	</xsl:template>
	
	<!-- used on userpage and typedarticle -->
	<xsl:template name="USERPAGE_BANNER">
		<div id="mainbansec">
			<div class="banartical"><h3>Member page</h3></div>		
			<xsl:call-template name="SEARCHBOX" />
			<div class="clear"></div>
			
			<h3 class="memberhead">
                <xsl:value-of select="/H2G2/ARTICLE/ARTICLEINFO/PAGEAUTHOR/EDITOR/USER/USERNAME" />
                <xsl:if test="/H2G2/ARTICLE/ARTICLEINFO/PAGEAUTHOR/EDITOR/USER/USERNAME != concat('U', /H2G2/ARTICLE/ARTICLEINFO/PAGEAUTHOR/EDITOR/USER/USERID)">
                    <xsl:text> </xsl:text>
                    <span class="uid">(U<xsl:value-of select="/H2G2/ARTICLE/ARTICLEINFO/PAGEAUTHOR/EDITOR/USER/USERID"/>)</span>
                </xsl:if>
			</h3>
			<div class="memberdate">
				member since:<xsl:text> </xsl:text><xsl:value-of select="/H2G2/ARTICLE/ARTICLEINFO/DATECREATED/DATE/@DAYNAME" /> <xsl:text> </xsl:text><xsl:value-of select="/H2G2/ARTICLE/ARTICLEINFO/DATECREATED/DATE/@DAY" /><xsl:text> </xsl:text><xsl:value-of select="/H2G2/ARTICLE/ARTICLEINFO/DATECREATED/DATE/@MONTHNAME" /><xsl:text> </xsl:text><xsl:value-of select="/H2G2/ARTICLE/ARTICLEINFO/DATECREATED/DATE/@YEAR" />
			</div>
		</div>
	</xsl:template>
	
	<xsl:template name="CREATE_ARTICLES_LISTALL">
	<xsl:if test="/H2G2/SITE-CLOSED=0 or $test_IsEditor">
	<ul class="arrow">
		<li>
			<xsl:choose>
				<xsl:when test="$test_IsEditor">
					<a>
						<xsl:attribute name="href">
							<xsl:call-template name="sso_typedarticle_signin">
								<xsl:with-param name="type" select="15"/>
							</xsl:call-template>
						</xsl:attribute>
						Write an article
					</a>
				</xsl:when>
				<xsl:otherwise>
				<a>
					<xsl:attribute name="href">
						<xsl:call-template name="sso_typedarticle_signin">
							<xsl:with-param name="type" select="10"/>
						</xsl:call-template>
					</xsl:attribute>
					Write an article
				</a>
				</xsl:otherwise>
			</xsl:choose>
		</li>
		<li><a>
				<xsl:attribute name="href">
					<xsl:call-template name="sso_typedarticle_signin">
						<xsl:with-param name="type" select="11"/>
					</xsl:call-template>
				</xsl:attribute>
				Write a match report
			</a>
		</li>
		<li><a>
				<xsl:attribute name="href">
					<xsl:call-template name="sso_typedarticle_signin">
						<xsl:with-param name="type" select="12"/>
					</xsl:call-template>
				</xsl:attribute>
				Write an event report
			</a>
		</li>
		<li><a>
				<xsl:attribute name="href">
					<xsl:call-template name="sso_typedarticle_signin">
						<xsl:with-param name="type" select="13"/>
					</xsl:call-template>
				</xsl:attribute>
				Write a player profile
			</a>
		</li>
		<li><a>
				<xsl:attribute name="href">
					<xsl:call-template name="sso_typedarticle_signin">
						<xsl:with-param name="type" select="14"/>
					</xsl:call-template>
				</xsl:attribute>
				Write a team profile
			</a>
		</li>			
	</ul>
	</xsl:if>
	</xsl:template>
	
	
	<xsl:template name="SEARCHBOX">
		<!--[FIXME: remove]
		<div class="bandropdown">
			<form action="http://www.bbc.co.uk/apps/ifl/openurl" method="GET" onSubmit="self.location=this.link.options[this.link.selectedIndex].value; return false;" id="sportdropdown">
			<select name="link">
				<option value="#">More 606 sports</option>
				<option value="http://news.bbc.co.uk/sport1/hi/football/606/default.stm">Football</option>
				<option value="http://news.bbc.co.uk/sport1/hi/cricket/606/default.stm">Cricket</option>
				<option value="http://news.bbc.co.uk/sport1/hi/rugby_union/606/default.stm">Rugby union</option>
				<option value="http://news.bbc.co.uk/sport1/hi/rugby_league/606/default.stm">Rugby league</option>
				<option value="http://news.bbc.co.uk/sport1/hi/tennis/606/default.stm">Tennis</option>
				<option value="http://news.bbc.co.uk/sport1/hi/golf/606/default.stm">Golf</option>
				<option value="http://news.bbc.co.uk/sport1/hi/motorsport/606/default.stm">Motorsport</option>
				<option value="http://news.bbc.co.uk/sport1/hi/boxing/606/default.stm">Boxing</option>
				<option value="http://news.bbc.co.uk/sport1/hi/athletics/606/default.stm">Athletics</option>
				<option value="http://news.bbc.co.uk/sport1/hi/other_sports/snooker/606/default.stm">Snooker</option>
				<option value="http://news.bbc.co.uk/sport1/hi/other_sports/horse_racing/606/default.stm">Horse racing</option>
				<option value="http://news.bbc.co.uk/sport1/hi/other_sports/cycling/606/default.stm">Cycling</option>
				<option value="http://news.bbc.co.uk/sport1/hi/other_sports/disability_sport/606/default.stm">Disability sport</option>
				<option value="http://news.bbc.co.uk/sport1/hi/other_sports/606/default.stm">Other Sport</option>
			</select>
			<input type="submit" value="go" />
			</form>			
		</div>
		-->
	</xsl:template>
	
	
	<xsl:template name="ADVANCED_SEARCH">
	<br clear="all" class="clearall" />
		<div class="advsearchbox">
			<div class="advsearchheadbox"><h3>SEARCH OTHER CONTENT ON 606</h3> <p class="links"><a href="{$root}searchhelp">I need help</a></p></div> 
			<form method="POST" action="{$root}ArticleSearch">
			<input type="hidden" name="contenttype" value="-1" />
			<input type="hidden" name="articlesortby" value="DateCreated" />
			<div class="advancedsearch">
			<p>
			<label for="advsearch">TAG SEARCH</label>
			<input type="text" name="phrase" id="advsearch" class="advsearch">
				<xsl:if test="/H2G2/ARTICLESEARCH/PHRASES/PHRASE">
				<xsl:attribute name="value">
					<xsl:for-each select="/H2G2/ARTICLESEARCH/PHRASES/PHRASE">
						<xsl:value-of select="TERM"/>
						<xsl:if test="not(position() = last())">
							<xsl:text> </xsl:text>
						</xsl:if>
					</xsl:for-each>
				</xsl:attribute>
			</xsl:if>
			</input>
			<select name="phrase" class="select">
				<option value="">all</option>
				<option value="article">articles</option>
				<option value="report">reports</option>
				<option value="profile">profiles</option>		
			</select><input type="image" alt="go" src="{$imagesource}go.gif" class="go" />
			</p>
			<p>
			I am looking for eg: <span class="eg">England football, England cricket, Bradford football, Bradford rugby league</span>
			</p>			
			</div>						
			</form>
		</div>	
	</xsl:template>
	
	
	<!-- over ride barley -->
	<xsl:template name="layout-template">
        <xsl:choose>
            <xsl:when test="/H2G2/@TYPE='ARTICLE' and /H2G2/ARTICLE/EXTRAINFO/TYPE/@ID=4">
                <xsl:apply-templates select="." mode="r_bodycontent"/>
            </xsl:when>
            <xsl:otherwise>
                <a name="top" id="top"/>
                <xsl:call-template name="toolbar-template"/>
                <xsl:copy-of select="$banner-content"/>
                    
                <table cellspacing="0" border="0" cellpadding="0" width="760">
                    <tr>
                    <td valign="top" width="131">
                        <!-- left hand nav-->
                        <!--[FIXME: adapt]
                        <xsl:call-template name="local-content"/>
                        -->
                        <div id="navWrapper">
                            <xsl:call-template name="GENERATE_LEFT_HAND_NAV"/>
                        </div>
                    </td>
                    <td valign="top" width="629">
                        <!-- main content -->
                        <xsl:apply-templates select="." mode="r_bodycontent"/>
                    </td>
                    </tr>
                </table>
                
                <xsl:if test="/H2G2/@TYPE != 'TYPED-ARTICLE'">
                    <xsl:call-template name="SPORTS_DROPDOWN" />
                </xsl:if>
                
                <xsl:call-template name="SPORTFOOTER"/>
            </xsl:otherwise>
        </xsl:choose>
	</xsl:template>
	
	<!-- NEW 606 templates -->
	<xsl:template name="SPORTFOOTER">
		<div id="footer">
			<div id="BBCDate">&copy; BBC MMVIII</div>
			<div id="footerNav">
				<ul class="footerList">
					<li>
						<a href="{$root}houserules">House rules</a>
						<xsl:text> | </xsl:text>
					</li>
					<li>
						<a href="http://news.bbc.co.uk/sport1/hi/606/5341886.stm">About 606</a>
						<xsl:text> | </xsl:text>
					</li>
					<li>
						<a href="http://news.bbc.co.uk/sport1/hi/606/5257104.stm">FAQs and feedback</a>
						<xsl:text> | </xsl:text>
					</li>
					<li>
						<a href="http://www.bbc.co.uk/privacy/">Privacy and cookies policy</a>
					</li>
				</ul>
			</div>
			<div class="clear"></div>
		</div>
	</xsl:template>
	
	<xsl:template name="GENERATE_LEFT_HAND_NAV">
		<div id="homeNav">
			<ul class="homeList">
				<li>
					<a class="lhsnl" href="{$cpshome}">606 Homepage</a>
				</li>
			</ul>
		</div>
		
		<!-- <div id="my606Nav">
			<div class="inner">
				<h3>My 606</h3>
				<ul class="my606List">
					<li class="strong">
						<xsl:if test="@TYPE='USERPAGE' and $ownerisviewer">
							<xsl:attribute name="class">selected</xsl:attribute>
						</xsl:if>
						<xsl:choose>		
							<xsl:when test="/H2G2/VIEWING-USER/USER">
								<a href="{$root}U{VIEWING-USER/USER/USERID}">
									<xsl:text>My member page</xsl:text>
								</a>
							</xsl:when>
							<xsl:otherwise>
								<a href="{$signinlink}">My member page</a>
							</xsl:otherwise>
						</xsl:choose>
					</li>
					<li>
						<a href="{$root}online?thissite=1&amp;orderby=name">Members online</a>
					</li>
				</ul>
			</div>
			<div class="bot"></div>
		</div> -->
		
		<!-- hide rest of nav when in typed article -->
		<xsl:if test="/H2G2/@TYPE != 'TYPED-ARTICLE'">
			<!-- <div id="createNav">
				<ul class="createList">
					<li>
						<a>
							<xsl:attribute name="href">
								<xsl:choose>
									<xsl:when test="/H2G2/SITE/IDENTITYSIGNIN = 0">
										<xsl:call-template name="sso_typedarticle_signin"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:call-template name="id_typedarticle_signin"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:attribute>
							<xsl:text>Create 606</xsl:text>
						</a>
					</li>
				</ul> 
			</div> -->
		
			<div id="browseNav">
				<xsl:call-template name="GENERATE_LEFT_HAND_NAV_BROWSE"/>
			</div>

			<div id="searchNav">
				<ul class="searchList">
					<li>
						<a href="{$root}ArticleSearch?s_show=searchbox">Search 606</a>
					</li>
				</ul>
			</div>

			<div id="moreNav">
				<div class="inner">
					<h3>More...</h3>
					<ul class="moreList">
						<li>
							<a href="http://www.bbc.co.uk/fivelive/programmes/606.shtml">Phone-in podcasts</a>
						</li>
					</ul>
					<div class="divider">---------------</div>
					<ul class="moreList">	
						<li>
							<a href="http://news.bbc.co.uk/sport">BBC Sport</a>
						</li>
						<li>
							<a href="http://www.bbc.co.uk/fivelive/">Radio Five Live</a>
						</li>
					</ul>
				</div>
				<div class="bot"></div>
			</div>
		</xsl:if>
		
		<xsl:call-template name="EDITOR_TOOLS"/>
		
	</xsl:template>
	
	<xsl:template name="GENERATE_LEFT_HAND_NAV_BROWSE">
		<div class="inner">
			<h3>Browse 606...</h3>
			<ul class="browseNavList">
				<li class="strong">
					<!--[FIXME: do we need this?]
					<xsl:if test="/H2G2/@TYPE='INFO' and /H2G2/INFO/@MODE='articles'">
						<xsl:attribute name="class">selected</xsl:attribute>
					</xsl:if>
					-->
					<a href="{$root}info?cmd=art&amp;show=50">
						Most recent...
					</a>
				</li>
			</ul>
			<div class="divider">---------------</div>

			<!-- 'main' sports -->
			<ul class="browseNavList">
				<xsl:for-each select="msxsl:node-set($MasterSports)/sports/sport[@main='yes']">
					<li class="strong">
						<a href="{$root}ArticleSearch?phrase={@phrase}&amp;contenttype=-1&amp;show=20">
							<xsl:value-of select="name"/>
						</a>
						<ul>
							<li>
								<a href="{$root}ArticleSearch?s_show=browsePage&amp;s_sport={@phrase}">- Teams</a>
							</li>
						</ul>
					</li>
				</xsl:for-each>
			</ul>
			<div class="divider">---------------</div>

			<!-- other sports -->
			<ul class="browseNavList">
				<xsl:for-each select="msxsl:node-set($MasterSports)/sports/sport[not(@main='yes')]">
					<li>
						<a href="{$root}ArticleSearch?phrase={@phrase}&amp;contenttype=-1&amp;show=20">
							<xsl:value-of select="name"/>
						</a>
					</li>
				</xsl:for-each>
				<li>
					<a href="{$root}ArticleSearch?s_show=browsePage&amp;s_sport=OtherSport">Other sport</a>
				</li>
			</ul>
		</div>
		<div class="bot"></div>
	</xsl:template>
	
	<xsl:template name="SPORTS_DROPDOWN">
		<div id="sportsDropDownPanel">
			<div class="inner">
				<form method="GET" action="{$root}ArticleSearch">
					<input type="hidden" name="contenttype" value="-1" />
					<input type="hidden" name="articlesortby" value="DateCreated" />

					<label for="sportSelector">Quick link to 606 sports</label>
					<xsl:call-template name="GENERATE_SPORTS_DROPDOWN"/>
					<input type="submit" value="Go"/>
				</form>
			</div>
		</div>
	</xsl:template>
	
	<xsl:template name="GENERATE_SPORTS_DROPDOWN">
		<select name="phrase" id="sportSelector">
			<option value="">----Select a sport----</option>
			<xsl:for-each select="msxsl:node-set($MasterSports)/sports/sport">
				<option value="{@phrase}"><xsl:value-of select="name"/></option>
			</xsl:for-each>
		</select>
	</xsl:template>
</xsl:stylesheet>
