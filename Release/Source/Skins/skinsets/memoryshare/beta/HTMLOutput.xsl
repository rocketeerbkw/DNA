<?xml version="1.0" encoding="iso-8859-1"?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" 
	xmlns:xhtml="http://www.w3.org/1999/xhtml"
	xmlns="http://www.w3.org/1999/xhtml"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:msxsl="urn:schemas-microsoft-com:xslt" 
	xmlns:local="#local-functions" 
	xmlns:s="urn:schemas-microsoft-com:xml-data" 
	xmlns:dt="urn:schemas-microsoft-com:datatypes" 
	xmlns:vbs="urn:schemas-sqlxml-org:vbs"
	exclude-result-prefixes="msxsl local s dt xhtml vbs">
	<!--===============Imported Files=====================-->
	<xsl:import href="../../../base/base-extra.xsl"/>
	<!--===============Imported Files=====================-->
	
	<!--===============Included Files=====================-->
	<xsl:include href="addthreadpage.xsl"/>
	<xsl:include href="articlepage.xsl"/>
	<xsl:include href="articlepage_templates.xsl"/>
	<xsl:include href="articlesearch.xsl"/>
	
	<!--[FIXME: redundant?]
	<xsl:include href="articlesearchphrase.xsl"/>
	-->

	<xsl:include href="boomboom.xsl"/>
	
	<xsl:include href="dynamiclist.xsl"/>
	
	<!--[FIXME: is this needed?]
	<xsl:include href="extrainfo.xsl"/>
	-->
	
	<!-- Magnetic North moved -->
	<xsl:include href="text.xsl"/>
	
	<xsl:include href="frontpage.xsl"/>
	<xsl:include href="guideml.xsl"/>
	<xsl:include href="indexpage.xsl"/>
	<xsl:include href="infopage.xsl"/>
	<xsl:include href="inspectuserpage.xsl"/>
	
	<xsl:include href="mediaassetpage.xsl"/>
	<xsl:include href="miscpage.xsl"/>
	<xsl:include href="morearticlespage.xsl"/>
	<xsl:include href="morepostspage.xsl"/>
	<xsl:include href="multipostspage.xsl"/>
	<xsl:include href="newuserspage.xsl"/>
	<xsl:include href="onlinepage.xsl"/>
	
	<!--[NOTE: this is imported in types.xsl]
	<xsl:include href="pagetype.xsl"/>
	-->
	<xsl:include href="redirectpage.xsl"/>
	<xsl:include href="registerpage.xsl"/>
	<xsl:include href="searchpage.xsl"/>
	<!--[FIXME: why is this excluded?]
	<xsl:include href="siteconfigpage.xsl"/> 
	-->
		
	<xsl:include href="threadspage.xsl"/>
	<xsl:include href="typedarticlepage.xsl"/>
	<xsl:include href="typedarticlepage_templates.xsl"/>
	<xsl:include href="usercomplaintpopup.xsl"/>
	<xsl:include href="userdetailspage.xsl"/>
	<xsl:include href="usereditpage.xsl"/>
	<xsl:include href="userpage.xsl"/>
	<xsl:include href="utils.xsl"/>
	<xsl:include href="watcheduserspage.xsl"/>
	
	<!-- xtra -->
	<xsl:include href="debug.xsl"/>
	<xsl:include href="sitevars.xsl"/>
	<xsl:include href="sso.xsl"/>
	<xsl:include href="types.xsl"/>
	
	<!-- from other sites -->
	<xsl:include href="../../boards/default/boardopeningschedulepage.xsl"/>
	
	<!-- no base file -->
	<xsl:include href="editrecentpostpage.xsl"/>
	
	<!--[FIXME: not needed]
	<xsl:include href="addjournalpage.xsl"/>
	<xsl:include href="journalpage.xsl"/>
	-->

	<!--[FIXME: redundant]	
	<xsl:variable name="kdevelopment_asset_root">http://dnadev.national.core.bbc.co.uk/dna/-/skins/memoryshare/_trans/</xsl:variable>
	
	<xsl:variable name="staging_asset_root">http://bbc.e3hosting.net/memoryshare/</xsl:variable>
	<xsl:variable name="staging_asset_root">/memoryshare/</xsl:variable>
	<xsl:variable name="staging_asset_root">http://www0.bbc.co.uk/memoryshare/</xsl:variable>
	<xsl:variable name="staging_asset_root">http://dnadev.national.core.bbc.co.uk/dna/-/skins/memoryshare/_trans/</xsl:variable>

	<xsl:variable name="kstaging_asset_root">http://www0.bbc.co.uk/memoryshare/_staging/</xsl:variable>
	<xsl:variable name="klive_asset_root">http://www.bbc.co.uk/memoryshare/</xsl:variable>
	
	<xsl:variable name="kbarley_root">/englandcms/</xsl:variable>
	-->
	
	<!--===============Included Files=====================-->
	
	<!--===============Output Setting=====================-->
	<!--xsl:output
		method="xml"
		encoding="ISO8859-1"
		omit-xml-declaration="yes"
		indent="yes"
		media-type="text/xml" /-->	
	<xsl:output
		method="xml"
		encoding="ISO8859-1"
		omit-xml-declaration="yes"
		indent="yes"
		doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"
        doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"/>

	<xsl:template match="/">
		<xsl:apply-templates select="H2G2"/>
	</xsl:template>

	<xsl:template match="H2G2">
		<xsl:choose>
			<xsl:when test="(@TYPE = 'USERS-HOMEPAGE') or (@TYPE = 'USER-DETAILS-PAGE') or (@TYPE = 'POST-MODERATION') or (@TYPE = 'MEDIAASSET-MODERATION') or (@TYPE = 'NICKNAME-MODERATION') or (@TYPE = 'MANAGE-FAST-MOD') or (@TYPE = 'DISTRESSMESSAGESADMIN') or (@TYPE = 'ARTICLE' and CURRENTSITEURLNAME = 'moderation') or (@TYPE = 'MODERATION-HISTORY') or (@TYPE='SITESUMMARY') or (@TYPE='MEMBERDETAILS') or (@TYPE='SITEMANAGER')">
				<xsl:call-template name="newmod-template"/>
			</xsl:when>
			<xsl:when test="(@TYPE = 'MODERATOR-MANAGEMENT') or (@TYPE = 'MANAGE-FAST-MOD') or (@TYPE = 'MOD-EMAIL-MANAGEMENT') or (@TYPE = 'PROFANITYADMIN') or (@TYPE = 'URLFILTERADMIN') or (@TYPE = 'COMMENTFORUMLIST')">
				<xsl:call-template name="admin-template"/>
			</xsl:when>
			<xsl:when test="PARAMS/PARAM[NAME='s_popup']/VALUE = 1">
				<xsl:call-template name="popup-template"/>
			</xsl:when>
			<xsl:when test="@TYPE = 'ONLINE'">
				<xsl:call-template name="popup-template"/>
			</xsl:when>
			<xsl:when test="@TYPE = 'USER-COMPLAINT' and not(PARAMS/PARAM[NAME='s_pop']/VALUE = 0)">
				<xsl:call-template name="popup-template"/>
			</xsl:when>
			<xsl:when test="@TYPE='MOREPOSTS' and PARAMS/PARAM[NAME='s_type']/VALUE='pop'">
				<xsl:call-template name="popup-template"/>
			</xsl:when>
			<xsl:when test="/H2G2/PARAMS/PARAM[NAME= 's_print']/VALUE = 1 and PARAMS/PARAM[NAME='s_type']/VALUE='pop'">
				<xsl:call-template name="popup-template"/>
			</xsl:when>
			<xsl:when test="/H2G2/PARAMS/PARAM[NAME= 's_boom']/VALUE = 'boom'">
				<xsl:call-template name="boomboom-template"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="primary-template"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>	
	
	<!--===============Output Setting=====================-->
	
	<!--===============        SSO       =====================-->
	
	<!--===============        SSO       =====================-->
	
	
	<!--===============CSS=====================-->
	<xsl:variable name="csslink">
		<!--xsl:if test="not(/H2G2/@TYPE='USER-COMPLAINT')"-->
			<!-- include client specific css from $client data table -->
			
			<!-- Magnetic North Removed - 12/02/09  -->
			<!-- xsl:apply-templates select="msxsl:node-set($clients)/list/item[client=$client]/css/list" mode="client_specific_css"/-->

			<!-- Magnetic North Added  -->
			<link href="/memoryshare/assets/css/screen.css" rel="stylesheet" type="text/css" />
			<link href="/memoryshare/assets/css/icons.css" rel="stylesheet" type="text/css" />
			<xsl:text disable-output-escaping="yes">
			&lt;!--[if IE 6]&gt;
			&lt;link href="/memoryshare/assets/css/ie6.css" rel="stylesheet" type="text/css" /&gt;
      &lt;link href="/memoryshare/assets/css/ie6_icons.css" rel="stylesheet" type="text/css" /&gt;
			&lt;![endif]--&gt;
			</xsl:text>
			
			<!-- calendar widget css from live -->
			<style type="text/css">
				@import 'http://www.bbc.co.uk/cs/util/calendar/1/cal.css';
			</style>
			<script type="text/javascript">
				<xsl:text disable-output-escaping="yes">
				// &lt;![CDATA[
				
				document.write('&lt;link rel="StyleSheet" href="</xsl:text>
				<xsl:value-of select="$asset_root"/>
				<xsl:text disable-output-escaping="yes">css/memoryshareJavascript.css" type="text/css" media="screen" /&gt;');
				
				//]]&gt;
				</xsl:text>
			</script>
		<!--/xsl:if-->
	
		<xsl:call-template name="insert-css"/>
	</xsl:variable>
	<!--===============CSS=====================-->
	
	<!--===============Attribute-sets Settings=====================-->
	<xsl:attribute-set name="mainfont">
		<xsl:attribute name="size">2</xsl:attribute>
	</xsl:attribute-set>
	

	
	<!--===============Attribute-sets Settings=====================-->
	<!--===============Javascript=====================-->
	<!-- override from base-extra.xsl -->
	<xsl:template name="insert-javascript">
		<xsl:call-template name="type-check">
			<xsl:with-param name="content">JAVASCRIPT</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	
	<xsl:variable name="scriptlink">
		<xsl:call-template name="ssi-set-var">
			<xsl:with-param name="name">bbcjst_inc</xsl:with-param>
			<xsl:with-param name="value">plugins</xsl:with-param>
		</xsl:call-template>
		
		<!-- [FIXME: do we need this in?] 
		temporarily take out until installed on dev
		<xsl:call-template name="ssi-include-virtual">
			<xsl:with-param name="path">/cs/jst/jst.sssi</xsl:with-param>
		</xsl:call-template>
		-->

		<!-- convert s params into javascript variables -->
		<script type="text/javascript">
			<xsl:text disable-output-escaping="yes">
// &lt;![CDATA[
</xsl:text>
			<xsl:comment> s_params JS goes here </xsl:comment>
			<xsl:text>
			</xsl:text>
			<xsl:for-each select="/H2G2/PARAMS/PARAM">
				<xsl:text>var </xsl:text>
				<xsl:value-of select="NAME"/>
				<xsl:text> = '</xsl:text>
				<xsl:call-template name="REPLACE_STRING">
					<xsl:with-param name="s" select="VALUE"/>
					<xsl:with-param name="what">'</xsl:with-param>
					<xsl:with-param name="replacement">\'</xsl:with-param>
				</xsl:call-template>
				<xsl:text>';
				</xsl:text>
			</xsl:for-each>
			<xsl:text disable-output-escaping="yes">
//]]&gt;
</xsl:text>
		</script>
		
		<xsl:comment> Begin JSTools includes - $Revision: 1.35 </xsl:comment>
		<xsl:text disable-output-escaping="yes">
		&lt;script src="http://www.bbc.co.uk/cs/jst/mod/1/jst_core.js" type="text/javascript"&gt;&lt;/script&gt;</xsl:text>
		<xsl:text disable-output-escaping="yes">
		&lt;script src="http://www.bbc.co.uk/cs/jst/mod/1/jst_math.js" type="text/javascript"&gt;&lt;/script&gt;</xsl:text>
		<xsl:text disable-output-escaping="yes">
		&lt;script src="http://www.bbc.co.uk/cs/jst/mod/1/jst_date.js" type="text/javascript"&gt;&lt;/script&gt;</xsl:text>
		<xsl:text disable-output-escaping="yes">&lt;script src="http://www.bbc.co.uk/cs/jst/mod/1/jst_cookies.js" type="text/javascript"
		&gt;&lt;/script&gt;</xsl:text>
		<xsl:text disable-output-escaping="yes">
		&lt;script src="http://www.bbc.co.uk/cs/jst/mod/1/jst_plugins.js" type="text/javascript"&gt;&lt;/script&gt;</xsl:text>
		<!-- xsl:text disable-output-escaping="yes">
		<&lt;script src="http://www.bbc.co.uk/cs/jst/mod/1/jst_http.js" type="text/javascript"&gt;&lt;/script&gt;</xsl:text> 
		<xsl:text disable-output-escaping="yes">
		&lt;script src="http://www.bbc.co.uk/cs/jst/mod/1/jst_dom.js" type="text/javascript"&gt;&lt;/script&gt;</xsl:text> -->
		<xsl:comment> End JSTools includes </xsl:comment>


		<!--script type="text/javascript" src="{$asset_root}js/memoryshare.js"></script-->
		<xsl:text disable-output-escaping="yes">
		&lt;script type="text/javascript" src="/memoryshare/js/memoryshare.js"&gt;&lt;/script&gt;</xsl:text>

		<!-- NEW JAVASCRIPT - START -->
		<xsl:text disable-output-escaping="yes">
			&lt;script type="text/javascript" src="/memoryshare/assets/js/jquery.js"&gt;&lt;/script&gt;</xsl:text>

		<xsl:text disable-output-escaping="yes">
		&lt;script src="/memoryshare/assets/js/jquery.scrollTo.js" type="text/javascript"&gt;&lt;/script&gt;</xsl:text>
		<xsl:text disable-output-escaping="yes">
		&lt;script src="/memoryshare/assets/js/jquery.localScroll.js" type="text/javascript" charset="utf-8"&gt;&lt;/script&gt;</xsl:text>
		<xsl:text disable-output-escaping="yes">
		&lt;script src="/memoryshare/assets/js/jquery.serialScroll.js" type="text/javascript" charset="utf-8"&gt;&lt;/script&gt;</xsl:text>		

		<xsl:text disable-output-escaping="yes">
			&lt;script type="text/javascript" src="/memoryshare/assets/js/ms2009.js"&gt;&lt;/script&gt;</xsl:text>

		<xsl:if test="/H2G2/@TYPE='ARTICLE'">
			<xsl:text disable-output-escaping="yes">
			&lt;script src="/memoryshare/assets/js/jquery.truncate.js" type="text/javascript"&gt;&lt;/script&gt;</xsl:text>
		</xsl:if>

		<xsl:if test="/H2G2/@TYPE='FRONTPAGE' or /H2G2/@TYPE='ARTICLESEARCH' or /H2G2/@TYPE='SEARCH' or /H2G2/@TYPE='MOREPAGES'">
			<xsl:text disable-output-escaping="yes">
			&lt;script src="/memoryshare/assets/js/swfobject/swfobject.js" type="text/javascript" charset="utf-8"&gt;&lt;/script&gt;
			&lt;script src="/memoryshare/assets/js/swfobject/swfmacmousewheel2.js" type="text/javascript" charset="utf-8"&gt;&lt;/script&gt;
			</xsl:text>
		</xsl:if>

		<xsl:if test="/H2G2/@TYPE='TYPED-ARTICLE' or /H2G2/@TYPE='ARTICLESEARCH' or /H2G2/@TYPE='SEARCH' or /H2G2/@TYPE='MOREPAGES'">
			<xsl:if test="/H2G2/@TYPE='TYPED-ARTICLE'">
				<!--script type="text/javascript" src="{$asset_root}js/maxlength.js"></script-->
				<xsl:text disable-output-escaping="yes">
				&lt;script type="text/javascript" src="/memoryshare/js/maxlength.js"&gt;&lt;/script&gt;</xsl:text>
			</xsl:if>
			<!--script type="text/javascript" src="{$asset_root}js/datefields.js"></script-->
			<xsl:text disable-output-escaping="yes">
			&lt;script type="text/javascript" src="/memoryshare/js/datefields.js"&gt;&lt;/script&gt;</xsl:text>

			<xsl:if test="/H2G2/@TYPE='TYPED-ARTICLE'">
				<xsl:text disable-output-escaping="yes">
				&lt;script src="/memoryshare/assets/js/date.js" type="text/javascript"&gt;&lt;/script&gt;</xsl:text>
				<xsl:text disable-output-escaping="yes">
				&lt;script src="/memoryshare/assets/js/jquery.datePicker.js" type="text/javascript"&gt;&lt;/script&gt;</xsl:text>				
				<xsl:text disable-output-escaping="yes">
				&lt;script src="/memoryshare/assets/js/jquery.codaSlider.js" type="text/javascript" charset="utf-8"&gt;&lt;/script&gt;</xsl:text>
				<xsl:text disable-output-escaping="yes">
				&lt;script src="/memoryshare/assets/js/jquery.dynacloud.js" type="text/javascript"&gt;&lt;/script&gt;</xsl:text>
			</xsl:if>
			
			<!-- NEW JAVASCRIPT - END -->
			
			<!-- calendar widget from live -->
			<xsl:text disable-output-escaping="yes">
			&lt;script type="text/javascript" src="http://www.bbc.co.uk/cs/util/calendar/1/cal.js"&gt;&lt;/script&gt;</xsl:text>
		</xsl:if>
			
		<!-- script for a/v console -->
		<!--[FIXME: is this needed?]
		<script src="http://newsimg.bbc.co.uk/sol/shared/js/sol3.js" language="JavaScript" type="text/javascript"></script>
		-->
		
		<xsl:call-template name="insert-javascript"/>

		
		<!-- pass some variables from DNA -> javascript -->
		<script type="text/javascript">
			<xsl:text disable-output-escaping="yes">
// &lt;![CDATA[
</xsl:text>

			var client = '<xsl:value-of select="$client"/>';
			var root = '<xsl:value-of select="$root"/>';
			var trueroot = '<xsl:value-of select="$trueroot"/>';
			var feedroot = '<xsl:value-of select="$feedroot"/>';
			var dna_articlesearch_total = '<xsl:value-of select="/H2G2/ARTICLESEARCH/@TOTAL"/>';

			<xsl:text disable-output-escaping="yes">
//]]&gt;
</xsl:text>
		</script>
			
		<script type="text/javascript">
			<xsl:text disable-output-escaping="yes">
// &lt;![CDATA[
</xsl:text>
			function popupwindow(link, target, parameters) {
			popupWin = window.open(link,target,parameters);
			}
			function popusers(link) {
			popupWin = window.open(link,'popusers','status=1,resizable=1,scrollbars=1,width=165,height=340');
			}

			function popmailwin(x, y) {window.open(x,y,'status=no,scrollbars=yes,resizable=yes,width=350,height=400');}
			<xsl:text disable-output-escaping="yes">
//]]&gt;
</xsl:text>
		</script>
	</xsl:variable>
	
	<xsl:variable name="meta-tags">
		<!-- dcterms temporal meta data -->
		<xsl:if test="/H2G2/@TYPE = 'ARTICLE'">
			<xsl:apply-templates select="/H2G2/ARTICLE" mode="dcterms_temporal"/>
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

	<xsl:variable name="banner-content">
		<h1><xsl:value-of select="$sitedisplayname"/>: <xsl:value-of select="$client"/></h1>
	</xsl:variable>
	
	<!--===============Local Template (Local Navigation Stuff)=====================-->
	<xsl:template name="local-content">
		<div id="topNav">
			<h3 class="hide">Main links</h3>
			<ul>
				<!--[FIXME: not needed?]
				<li>
					<a href="{$root}">
						<xsl:if test="/H2G2/@TYPE='FRONTPAGE'">
							<xsl:attribute name="class">selected</xsl:attribute>
						</xsl:if>
						Home
					</a>
				</li>
				-->
				<li id="addMem">
					<xsl:if test="/H2G2/@TYPE='TYPED-ARTICLE' or /H2G2/@TYPE='TYPED-ARTICLE-PREVIEW'">
						<xsl:attribute name="class">selected</xsl:attribute>
					</xsl:if>
					<a>
						<xsl:attribute name="href">
							<xsl:call-template name="sso_typedarticle_signin"/>
						</xsl:attribute>
						<xsl:text>Add a memory</xsl:text>
					</a>
				</li>
				<li id="viewMem">
					<xsl:if test="/H2G2/@TYPE='ARTICLESEARCH' or /H2G2/@TYPE = 'SEARCH' or /H2G2/PARAMS/PARAM[NAME='s_view_mode']/VALUE = 'list'">
						<xsl:attribute name="class">selected</xsl:attribute>
					</xsl:if>
					<a href="{$articlesearchroot}">
						<xsl:text>View memories</xsl:text>
					</a>
				</li>
				<xsl:if test="/H2G2/VIEWING-USER/USER">
					<li id="yourMem">
						<xsl:if test="/H2G2/@TYPE='USERPAGE' and /H2G2/VIEWING-USER/USER/USERID=/H2G2/PAGE-OWNER/USER/USERID">
							<xsl:attribute name="class">selected</xsl:attribute>
						</xsl:if>
						<a>
							<xsl:attribute name="href">
								<xsl:value-of select="concat($root, 'U', /H2G2/VIEWING-USER/USER/USERID)"/>
							</xsl:attribute>
							Your memories
						</a>
					</li>
				</xsl:if>
				<xsl:if test="/H2G2/VIEWING-USER/USER">
					<li id="yourPrefs">
						<xsl:if test="/H2G2/@TYPE='USERDETAILS'">
							<xsl:attribute name="class">selected</xsl:attribute>
						</xsl:if>
						<a href="{$root}userdetails">
							Your preferences
						</a>
					</li>
				</xsl:if>
			</ul>
		</div>
		
		<!-- debug -->
		<xsl:call-template name="VARIABLEDUMP"/>
		<!-- DEBUG -->
	</xsl:template>
	
	<xsl:template name="editor-tools">
		<!-- admin user tools -->
		<xsl:if test="$test_IsAdminUser">
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
					<li><a href="{$root}inspectuser">edit user</a></li>
					<li><a href="/dna/moderation/moderate?newstyle=1">moderate</a></li>

					<li>
						<a>
							<xsl:attribute name="href">
								<xsl:value-of select="concat($root,'dlct')"/>
							</xsl:attribute>
							dynamic list
						</a>
					</li>
				</ul>
				<br />
				<ul>
					<li><a href="{$root}info?cmd=conv">recent conv.</a></li>
					<li><a href="{$root}newusers">new users</a></li>
					<!--[FIXME: remove]
					<li><a href="{$articlesearchservice}?contenttype=-1&amp;phrase=_profile&amp;show=100">member pages</a></li>
					-->
				</ul>
				<br />
				<ul>
					<li><a href="{$root}siteschedule">opening/closing</a></li>
					<!--[FIXME: remove]
					<li><a href="{$articlesearchservice}?contenttype=-1">search tags</a></li>
					<li><a href="{$articlesearchservice}?contenttype=-1&amp;s_show=predefinedtags">predefined tags</a></li>
					<li><a href="{$articlesearchservice}?contenttype=-1&amp;s_show=top100">top 100 tags</a></li>
					-->
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
								create staff memory
							</a>
						</li>
						<li>
							<a>
								<xsl:attribute name="href">
									<xsl:call-template name="sso_typedarticle_signin">
										<xsl:with-param name="type" select="2"/>
									</xsl:call-template>
								</xsl:attribute>
								create editorial article
							</a>
						</li>
						<li><a href="{$root}NamedArticles">name articles</a></li>
				</ul>
				<br/>
				<h4>Originating client searches</h4>
				<ul>
					<xsl:for-each select="msxsl:node-set($clients)/list/item">
						<li>
							<a>
								<xsl:attribute name="href">
									<xsl:value-of select="$articlesearchroot"/>
									<xsl:text>&amp;phrase=</xsl:text>
									<xsl:value-of select="concat($client_keyword_prefix, client)"/>
								</xsl:attribute>
								<xsl:value-of select="name"/>
							</a>
						</li>
					</xsl:for-each>
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

	<xsl:template match="H2G2" mode="header">
		<xsl:param name="title">Memoryshare</xsl:param>
		<xsl:param name="rsstype">SEARCH</xsl:param>
		<head>

			<title>
				<xsl:value-of select="$title"/>
				<xsl:if test="$test_IsAdminUser">
					<xsl:text> - </xsl:text>
					<xsl:value-of select="/H2G2/SERVERNAME"/>
				</xsl:if>
			</title>
			<meta http-equiv="Content-Type" content="text/html; charset=ISO8859-1"/>
			<meta name="robots" content="{$robotsetting}"/>
			
			<xsl:copy-of select="$scriptlink"/>
			<xsl:copy-of select="$meta-tags"/>

			<xsl:call-template name="global-template"/>

			<!--The following is used on the myconversationspopup-->
			<xsl:if test="/H2G2/@TYPE='MOREPOSTS' and /H2G2/PARAMS/PARAM[NAME='s_type']/VALUE='pop'">
				<xsl:variable name="target" select="/H2G2/PARAMS/PARAM[NAME='s_target']/VALUE"/>
				<xsl:variable name="skipparams">
					skip=<xsl:value-of select="/H2G2/POSTS/POST-LIST/@SKIPTO"/>&amp;show=<xsl:value-of select="/H2G2/POSTS/POST-LIST/@COUNT"/>&amp;
				</xsl:variable>
				<xsl:variable name="userid">
					<xsl:value-of select="/H2G2/POSTS/@USERID"/>
				</xsl:variable>
				<meta http-equiv="REFRESH">
					<xsl:attribute name="content">
						120;url=MP<xsl:value-of select="$userid"/>?<xsl:value-of select="$skipparams"/>s_type=pop<xsl:apply-templates select="/H2G2/PARAMS/PARAM[NAME='s_t']" mode="ThreadRead"/>&amp;s_target=<xsl:value-of select="$target"/>
					</xsl:attribute>
				</meta>
			</xsl:if>

			<xsl:choose>
				<xsl:when test="$rsstype = 'FORUM'">
					<xsl:call-template name="FORUM_RSS_FEED_META"/>
				</xsl:when>
				<xsl:when test="$rsstype = 'FULLTEXT_SEARCH'">
					<xsl:call-template name="FULLTEXT_SEARCH_RSS_FEED_META"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="SEARCH_RSS_FEED_META"/>
				</xsl:otherwise>
			</xsl:choose>

			<xsl:if test="$test_IsAdminUser">
				<xsl:comment>
					<xsl:value-of select="/H2G2/SERVERNAME"/>
				</xsl:comment>
			</xsl:if>

			<!-- add onload handlers -->
			<xsl:choose>
				<xsl:when test="/H2G2/@TYPE='TYPED-ARTICLE'">
					<xsl:choose>
						<xsl:when test="$current_article_type='10' or $current_article_type='15' or $current_article_type='3001'">
							<xsl:choose>
								<xsl:when test="/H2G2/MULTI-STAGE/@TYPE='TYPED-ARTICLE-EDIT' or /H2G2/MULTI-STAGE/@TYPE='TYPED-ARTICLE-EDIT-PREVIEW'">
									<script type="text/javascript">
										<xsl:text disable-output-escaping="yes">
// &lt;![CDATA[
</xsl:text>
										bbcjs.addOnLoadItem("init(ARTICLE_EDIT_INIT)");
										<xsl:text disable-output-escaping="yes">
//]]&gt;
</xsl:text>
									</script>
								</xsl:when>
								<xsl:otherwise>
									<script type="text/javascript">
										<xsl:text disable-output-escaping="yes">
// &lt;![CDATA[
</xsl:text>
										bbcjs.addOnLoadItem("init(ARTICLE_INIT)");
										<xsl:text disable-output-escaping="yes">
//]]&gt;
</xsl:text>
									</script>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
					</xsl:choose>
				</xsl:when>
				<xsl:when test="/H2G2/@TYPE='ARTICLESEARCH' or /H2G2/@TYPE='SEARCH'">
					<script type="text/javascript">
						<xsl:text disable-output-escaping="yes">
// &lt;![CDATA[
</xsl:text>
						bbcjs.addOnLoadItem("init(SEARCH_INIT)");
						<xsl:text disable-output-escaping="yes">
//]]&gt;
</xsl:text>
					</script>
				</xsl:when>
				<xsl:otherwise>
					<script type="text/javascript">
						<xsl:text disable-output-escaping="yes">
// &lt;![CDATA[
</xsl:text>
						bbcjs.addOnLoadItem("init()");
						<xsl:text disable-output-escaping="yes">
//]]&gt;
</xsl:text>
					</script>
				</xsl:otherwise>
			</xsl:choose>

			<xsl:if test="/H2G2/SITE/IDENTITYSIGNIN = 1">
				<xsl:comment>#set var="blq_identity" value="on"</xsl:comment>
				<xsl:comment>#set var="identity_target_resource" value="<xsl:value-of select="/H2G2/SITE/IDENTITYPOLICY" />"</xsl:comment>
			</xsl:if>
			<xsl:comment>#set var="blq_nav_color" value="blue"</xsl:comment>
			<xsl:comment>#set var="blq_footer_color" value="black"</xsl:comment>
			<xsl:comment>#include virtual="/includes/blq/include/blq_head.sssi"</xsl:comment>

			<xsl:text disable-output-escaping="yes">
&lt;script type="text/javascript" src="http://www.bbc.co.uk/glow/gloader.js"&gt;&lt;/script&gt;
			</xsl:text>

			<xsl:if test="/H2G2/@TYPE='TYPED-ARTICLE'">
			<script type="text/javascript">
			<xsl:text disable-output-escaping="yes">
			// &lt;![CDATA[
			</xsl:text>
  				gloader.load(["glow", "1", "glow.dom", "glow.events", "glow.widgets.Overlay"]);	
			<xsl:text disable-output-escaping="yes">
			//]]&gt;
			</xsl:text>
			</script>				
			</xsl:if>		
			<script type="text/javascript" src="http://www.bbc.co.uk/dnaimages/javascript/DNA.js"><xsl:text> </xsl:text></script>
			<xsl:copy-of select="$csslink"/>
		</head>
	</xsl:template>
	
	<xsl:template name="global-template">
		<xsl:if test="/H2G2/@TYPE = 'SITEOPTIONS'"> 
			<link type="text/css" rel="stylesheet" href="http://www.bbc.co.uk/dnaimages/boards/includes/admin.css"/>
		</xsl:if>
		
		<!-- Magenetic North removed -->
		<!--xsl:text disable-output-escaping="yes">
		&lt;style type="text/css"&gt;
			@import '/includes/tbenh.css';
		&lt;/style&gt;
		</xsl:text-->

		<!-- global lincludes from $clients data table -->
		<!-- xsl:apply-templates select="msxsl:node-set($clients)/list/item[client=$client]/includes/global/list" mode="client_specific_includes"/-->
	</xsl:template>	
	
	<!--===============Primary Template (Page Stuff)=====================-->
	<xsl:template name="primary-template">
		<!--xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"&gt;
		</xsl:text-->
		<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
			<xsl:call-template name="insert-header" />			
			<body>
				<xsl:comment>#include virtual="/includes/blq/include/blq_body_first.sssi"</xsl:comment>
				<div id="blq-content">
					<xsl:choose>
						<xsl:when test="/H2G2/PARAMS/PARAM[NAME= 's_special']/VALUE = 'clientlist'">
							<xsl:call-template name="clientlist-template"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:call-template name="layout-template"/>
						</xsl:otherwise>
					</xsl:choose>
				</div>
				<!-- DEBUG -->
				<xsl:if test="$DEBUG = 1 or /H2G2/PARAMS/PARAM[NAME = 's_debug']/VALUE = '1'">
					<xsl:apply-templates select="/H2G2" mode="debug"/>
				</xsl:if>
				<!-- /DEBUG -->
				<xsl:comment>#include virtual="/includes/blq/include/blq_body_last.sssi"</xsl:comment>

				<xsl:if test="/H2G2/@TYPE='ARTICLE' and ($article_subtype = 'user_memory' or $article_subtype = 'staff_memory')">
					<xsl:comment> Sub type: <xsl:value-of select="$article_subtype" /> </xsl:comment>
					<script type="text/javascript">
					<xsl:text disable-output-escaping="yes">
					// &lt;![CDATA[
					
					$(document).ready(function () {
						initArticle();
					});

					//]]&gt;
					</xsl:text>
					</script>
					
				</xsl:if>
			</body>
		</html>
	</xsl:template>
	<!--===============Primary Template (Page Stuff)=====================-->
	
	<!--===============Body Content Template (Global Content Stuff)=====================-->
	<xsl:template match="H2G2" mode="r_bodycontent">
		<xsl:call-template name="insert-mainbody"/>
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
				<body id="ms-popup">
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
	############################################
		templates used on multiple pages 
	############################################
	-->
	
	
	<xsl:template name="siteclosed">
		<div class="commenterror">
			<!--[FIXME: adapt]
			Sorry, but you can only contribute to 606 during opening hours. These are 09:00 until 23:00 GMT, seven days a week.
			-->
			CLOSED
		</div>
	</xsl:template>
	
	<xsl:template name="wrapper_attributes">
		<xsl:attribute name="class"><xsl:value-of select="$client"/></xsl:attribute>
	</xsl:template>
	
	<!-- override barley -->
	<xsl:template name="layout-template">
		<!-- Magnetic N Removed - Might need to put breadcrumb back in somewhere? -->
		
		<!--div class="home-page-image" id="grid-columns">

			<div class="titleArea">
				<h1>Memoryshare</h1>
				<p class="section-heading">Memoryshare - the days of your life</p> 
				<p class="crumbtrail">
					<xsl:text> You are in: </xsl:text>
					<a>
						<xsl:attribute name="href">
							<xsl:value-of select="msxsl:node-set($clients)/list/item[client=$client]/url"/>
						</xsl:attribute>
						<xsl:value-of select="msxsl:node-set($clients)/list/item[client=$client]/name"/>
					</a>
					<xsl:text> &gt; </xsl:text>
					<xsl:text>Memoryshare</xsl:text>
				</p>
			</div-->

			<!--START MAIN_CONTENT_WRAPPER-->
			<div id="memoryshare">
				<!--xsl:value-of select="vbs:getResults('test')" /-->
				<div id="memoryshare-header">
					<div id="memoryshare-logo">
						<a href="/dna/memoryshare/" title="BBC Memoryshare"><img src="/memoryshare/assets/images/memoryshareLogo.png" alt="BBC Memoryshare" /></a>
					</div>
					<xsl:choose>
						<xsl:when test="/H2G2/@TYPE='ARTICLESEARCH'">
						<div id="memoryshare-top-line">
							<xsl:variable name="viewName">
								<xsl:call-template name="VIEW_NAME"/>
							</xsl:variable>
							<p>							
								<xsl:choose>
									<xsl:when test="$viewName=''">
										<xsl:apply-templates select="/H2G2/ARTICLESEARCH" mode="results_total">
											<xsl:with-param name="all">true</xsl:with-param>
										</xsl:apply-templates>
									</xsl:when>
									<xsl:otherwise>
										<xsl:apply-templates select="/H2G2/ARTICLESEARCH" mode="results_total" />
										<xsl:value-of disable-output-escaping="yes" select="$viewName" />
									</xsl:otherwise>
								</xsl:choose>
							</p>
						</div>
						</xsl:when>
						<xsl:when test="/H2G2/@TYPE='MOREPAGES'">
						<div id="memoryshare-top-line">
							<p>
								<xsl:call-template name="MOREPAGES_PAGE_TITLE">
									<xsl:with-param name="doBold">true</xsl:with-param>
								</xsl:call-template>
							</p>
						</div>
						</xsl:when>
						<xsl:otherwise>
						<div id="memoryshare-top-line">
							<p>A place to share and explore memories</p>
						</div>						
						</xsl:otherwise>						
					</xsl:choose>	
					<div id="memoryshare-add-memory">
						<a title="Add a Memory">
							<xsl:attribute name="href">
								<!-- Magnetic North - added a new template that sends user straight to add a memory after login -->
								<xsl:call-template name="sso_typedarticle_signin2"/>
							</xsl:attribute>
							<xsl:text>Add a Memory</xsl:text>
						</a>
					</div>
				</div>

				<div id="memoryshare-login">
					<xsl:call-template name="sso_statusbar"/>
				</div>

				<div id="memoryshare-content">

					<!-- Most pages will have this apart from the search pages ... -->
					<xsl:if test="not(/H2G2/@TYPE='FRONTPAGE' or /H2G2/@TYPE='ARTICLESEARCH' or /H2G2/@TYPE='MOREPAGES')">
						<div id="back-to-timeline">
							<a>
								<xsl:attribute name="href">
									<xsl:choose>
										<xsl:when test="/H2G2/PARAMS/PARAM[NAME='s_fromSearch']">
											<xsl:value-of select="/H2G2/PARAMS/PARAM[NAME='s_fromSearch']/VALUE" />
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="$articlesearchroot" />
										</xsl:otherwise>
									</xsl:choose>									
								</xsl:attribute>
							<span><xsl:comment> </xsl:comment></span>Return to timeline</a>
						</div>
					</xsl:if>
					
					<!-- Magnetic North - removed topNav -->
					<!-- topNav -->
					<!-- xsl:call-template name="local-content"/ -->

					<xsl:apply-templates select="." mode="r_bodycontent"/>

					<xsl:call-template name="editor-tools"/>

					<!--[FIXME: on every page?]
					<xsl:if test="/H2G2/@TYPE='ARTICLESEARCH' or /H2G2/@TYPE = 'SEARCH' or /H2G2/PARAMS/PARAM[NAME='s_view_mode']/VALUE = 'list' or /H2G2/@TYPE='ARTICLE'">
					-->
						<div class="disclaimerText">
							<h4>Disclaimer</h4>
							<p>
							Much of the content on Memoryshare is created by Memoryshare contributors, who are members of the public. The views expressed are theirs and unless specifically stated are not those of the BBC. The BBC is not responsible for the content of any external sites referenced.
							</p>
						</div>
					<!--[FIXME: on every page?]
					</xsl:if>
					-->
				</div>
				<div id="memoryshare-footer">
					<div id="memoryshare-inner-footer">
						<ul>
							<li class="ms-rss"><a href="{$root}rss-feeds">RSS</a></li>
							<li><a href="http://faq.external.bbc.co.uk/questions/bbc_online/rss">What is RSS?</a></li>
							<li><a href="{$root}about">About Memoryshare</a></li>
							<li><a href="{$root}help">Memoryshare Help</a></li>
							<li class="final-footer-link"><a href="{$root}houserules">House Rules</a></li>
						</ul>
					</div>
				</div>
			</div>
			<!--END MAIN_CONTENT_WRAPPER-->
		<!-- Magnetic N removed close tag -->
		<!--/div-->
	</xsl:template>
	
	<!-- client specific data table helper templates -->
	<xsl:template match="list" mode="client_specific_css">
		<style type="text/css">
			<xsl:for-each select="item">
				<xsl:choose>
					<xsl:when test="starts-with(., '/')">
						<xsl:text>@import '</xsl:text>
						<xsl:value-of select="."/>
						<xsl:text>'; 
						</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>@import '</xsl:text>
						<xsl:value-of select="$asset_root"/>
						<xsl:value-of select="."/>
						<xsl:text>';
						</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>
		</style>
	</xsl:template>

	<xsl:template match="list" mode="client_specific_includes">
		<xsl:for-each select="item">
			<xsl:comment>#include virtual="<xsl:value-of select="."/>" </xsl:comment>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="clientlist-template">
		<ul>
			<xsl:for-each select="msxsl:node-set($clients)/list/item">
				<li>
					<xsl:attribute name="style">
						<xsl:text>float:left;</xsl:text>
					</xsl:attribute>
					<a>
						<xsl:attribute name="href">
							<xsl:value-of select="url"/>
						</xsl:attribute>
						<img>
							<xsl:attribute name="alt">
								<xsl:value-of select="name"/>
							</xsl:attribute>
							<xsl:attribute name="src">
								<xsl:text>/memoryshare/assets/images/</xsl:text><xsl:value-of select="logo1"/>
							</xsl:attribute>
						</img>
					</a>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>

	<xsl:template name="flash-timeline-script">
		<xsl:param name="layerId">memoryshare-timeline</xsl:param>
		<xsl:param name="checkCookie">false</xsl:param>
		<xsl:param name="search"><xsl:value-of select="$articlesearchbase" /></xsl:param>

		<!--xsl:variable name="searchPhraseString">
			<xsl:text>_memory</xsl:text>			
			<xsl:for-each select="/H2G2/ARTICLESEARCH/PHRASES/PHRASE">
				<xsl:if test="not(starts-with(NAME, '_')) and not(NAME = 'user_memory') and not(NAME = 'staff_memory')">
					<xsl:text>,</xsl:text>
					<xsl:value-of select="NAME"/>
				</xsl:if>
			</xsl:for-each>
		</xsl:variable-->

		<!-- Must escape single quotes or it breaks the js when we pass it through to the Flash -->
		<xsl:variable name="cleanSearch">
			<xsl:call-template name="REPLACE_STRING">
				<xsl:with-param name="s" select="$search"/>
				<xsl:with-param name="what">'</xsl:with-param>
				<xsl:with-param name="replacement">\'</xsl:with-param>
			</xsl:call-template>
		</xsl:variable>
			
		<script type="text/javascript">
		<xsl:text disable-output-escaping="yes">
		// &lt;![CDATA[
		
		</xsl:text>
		<xsl:if test="$checkCookie='true'">
			<xsl:text>
            if (!getViewHTMLCookie()) {
			</xsl:text>
		</xsl:if>
		<xsl:text disable-output-escaping="yes">var vars = { query:escape('</xsl:text>
		<xsl:value-of disable-output-escaping="yes" select="$cleanSearch" />
		<!--xsl:if test="$search and $search != ''">
			<xsl:text disable-output-escaping="yes">',serviceoverride:'</xsl:text>
			<xsl:value-of disable-output-escaping="yes" select="$search" />
		</xsl:if-->
		<xsl:text disable-output-escaping="yes">') };
				var params = { allowScriptAccess:'always' };
				params.base = "/memoryshare/assets/swf/";

				var attributes = { id:'memorySpiral', name:'memorySpiral' }; // give an id to the flash object

				swfobject.embedSWF("/memoryshare/assets/swf/Memoryshare.swf", "</xsl:text>
				<xsl:value-of select="$layerId" />
				<xsl:text disable-output-escaping="yes">", "946", "392", "9.0.0", "/memoryshare/assets/js/swfobject/expressInstall.swf", vars, params, attributes );
				if (swfmacmousewheel != null)
				{
					swfmacmousewheel.registerObject(attributes.id);
				}
		</xsl:text>
		<xsl:if test="$checkCookie='true'">
			<xsl:text>
            }
			</xsl:text>
		</xsl:if>			
		<xsl:text disable-output-escaping="yes">		
		//]]&gt;
		</xsl:text>
		</script>
	</xsl:template>
		
	<xsl:template name="feature-pod">
		<!-- If there is a featured inc specified in the clients file use it otherwise use the default -->
		<xsl:choose>
			<xsl:when test="msxsl:node-set($clients)/list/item[client=$client]/featuredinc">
				<xsl:comment>#include virtual="<xsl:value-of select="msxsl:node-set($clients)/list/item[client=$client]/featuredinc" />"</xsl:comment>
			</xsl:when>
			<xsl:otherwise>
				<xsl:comment>#include virtual="/memoryshare/includes/featured.sssi"</xsl:comment>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="client-pod">
		<xsl:param name="outerDivId">client-pod</xsl:param>
		<xsl:param name="innerDivClass">ms-right-pod-top-1</xsl:param>
		<div class="ms-right-pod">
			<xsl:attribute name="id">
				<xsl:value-of select="$outerDivId" />
			</xsl:attribute>
			<div>
				<xsl:attribute name="class">
					<xsl:value-of select="$innerDivClass" />
				</xsl:attribute>
				<div class="ms-pod-content">
					<h3>Memoryshare on</h3>
					<xsl:comment>#include virtual="/memoryshare/includes/clientpod.sssi"</xsl:comment>
					<div class="clearer"><xsl:comment> clearer </xsl:comment></div>
				</div>
			</div>
			<div class="ms-right-pod-bottom-1">
				<xsl:comment> ms-right-pod-bottom-1 </xsl:comment>
			</div>
		</div>
	</xsl:template>
		
	<msxsl:script language="VBScript" implements-prefix="vbs">
	<![CDATA[

	function GetWeekDay(dateString)
		GetWeekDay = WeekDay(CDate(dateString), 2)
	end Function

	function getResults(dataUrl)

	end Function

	]]>
	</msxsl:script>

</xsl:stylesheet>