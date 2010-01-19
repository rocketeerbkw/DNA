<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
	<!ENTITY arrow "&#9658;">
]>
<xsl:stylesheet exclude-result-prefixes="msxsl local s dt" version="1.0" xmlns:dt="urn:schemas-microsoft-com:datatypes" xmlns:local="#local-functions" xmlns:msxsl="urn:schemas-microsoft-com:xslt"
        xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
        <!--===============Imported Files=====================-->
        <xsl:import href="../../../base/base-extra.xsl"/>
        <!--===============End Imported Files=====================-->
        <!--===============Included Files=====================-->
        <xsl:include href="collective-sitevars.xsl"/>
        <xsl:include href="collectivetext.xsl"/>
        <xsl:include href="collectiveicons.xsl"/>
        <xsl:include href="collectivetips.xsl"/>
        <xsl:include href="collectivebuttons.xsl"/>
        <xsl:include href="categories.xsl"/>
        <xsl:include href="debug.xsl"/>
        <xsl:include href="promos.xsl"/>
        <xsl:include href="seealsopromos.xsl"/>
        <xsl:include href="siteconfigpromos.xsl"/>
        <xsl:include href="guideml.xsl"/>
        <xsl:include href="types.xsl"/>
        <xsl:include href="addjournalpage.xsl"/>
        <xsl:include href="addthreadpage.xsl"/>
        <xsl:include href="articlepage.xsl"/>
        <xsl:include href="categorypage.xsl"/>
        <xsl:include href="editcategorypage.xsl"/>
        <xsl:include href="frontpage.xsl"/>
        <xsl:include href="indexpage.xsl"/>
        <xsl:include href="infopage.xsl"/>
        <xsl:include href="journalpage.xsl"/>
        <xsl:include href="miscpage.xsl"/>
        <xsl:include href="monthpage.xsl"/>
        <xsl:include href="morearticlespage.xsl"/>
        <xsl:include href="morepostspage.xsl"/>
        <xsl:include href="multipostspage.xsl"/>
        <xsl:include href="myconversationspopup.xsl"/>
        <xsl:include href="newuserspage.xsl"/>
        <xsl:include href="registerpage.xsl"/>
        <xsl:include href="searchpage.xsl"/>
        <xsl:include href="siteconfigpage.xsl"/>
        <xsl:include href="tagitempage.xsl"/>
        <xsl:include href="threadspage.xsl"/>
        <xsl:include href="typedarticlepage.xsl"/>
        <xsl:include href="usercomplaintpopup.xsl"/>
        <xsl:include href="userdetailspage.xsl"/>
        <xsl:include href="usereditpage.xsl"/>
        <xsl:include href="userpage.xsl"/>
        <!--===============End Included Files=====================-->
        <!-- VARIABLES -->
        <xsl:variable name="skinname">collective</xsl:variable>
        <xsl:variable name="scopename">collective</xsl:variable>
        <xsl:variable name="environment_colour">#ff00000</xsl:variable>
        <xsl:variable name="environment_text">Beta</xsl:variable>
        <xsl:variable name="server" select="/H2G2/SERVERNAME"/>
        <xsl:variable name="domain">
                <xsl:choose>
                        <xsl:when test="$server = 'OPS-DNA1'">http://ideweb-dev.national.core.bbc.co.uk/</xsl:when>
                        <xsl:otherwise>http://www.bbc.co.uk/</xsl:otherwise>
                </xsl:choose>
        </xsl:variable>
        <xsl:variable name="baseURL">
                <xsl:value-of select="concat($domain, 'collective/')"/>
        </xsl:variable>
        <xsl:variable name="includesURL">
                <xsl:value-of select="concat($baseURL, 'includes/')"/>
        </xsl:variable>
        <xsl:variable name="dnaBaseURL">
                <xsl:value-of select="concat($domain, 'dna/collective/')"/>
        </xsl:variable>
        <xsl:variable name="imagesource" select="concat($baseURL, 'dnafurniture/')"/>
        <xsl:variable name="photosource" select="concat($baseURL, 'dnaimages/')"/>
        <xsl:variable name="promos" select="concat($baseURL, 'dnapromos/')"/>
        <xsl:variable name="smileysource" select="concat($baseURL, 'dnasmileys/')"/>
        <xsl:variable name="pagetype" select="/H2G2/@TYPE"/>
        <xsl:output doctype-public="-//W3C//DTD HTML 4.01 Transitional//EN" encoding="iso-8859-1" indent="yes" method="html" omit-xml-declaration="yes" standalone="yes" version="4.0"/>
        <!-- CSS -->
        <xsl:variable name="csslink">
                <link href="{$includesURL}base.css" rel="stylesheet" title="default" type="text/css"/>
                <style type="text/css">
                        <xsl:comment>
                                @import "<xsl:value-of select="$includesURL" />complete.css";
	    /* TODO 5 these (below) can probably be merged back in to above
                                @import "<xsl:value-of select="$includesURL" />DEBUG_style_debug.css";
                                @import "<xsl:value-of select="$includesURL" />DEBUG_style_page.css";
                                @import "<xsl:value-of select="$includesURL" />DEBUG_style_icon.css";
                                */
                        </xsl:comment>
                </style>
                <xsl:call-template name="insert-css"/>
        </xsl:variable>
        <!-- JAVASCRIPT -->
        <xsl:variable name="scriptlink">
                <script src="{$includesURL}collective.js" type="text/javascript"/>
                <xsl:call-template name="insert-javascript"/>
                <script type="text/javascript">
                        //<![CDATA[ 
                                window.name="main";
                                        function aodpopup(URL){
window.open(URL,'aod','width=693,height=525,toolbar=no,personalbar=no,location=no,directories=no,statusbar=no,menubar=no,status=no,resizable=yes,left=60,screenX=60,top=100,screenY=100');
                                }
                                if(location.search.substring(1)=="focuswin"){
                                        window.focus();
                                }
                        //]]>
                </script>
        </xsl:variable>
        <xsl:variable name="meta-tags">
                <!--  this is for the RSS meta link which enables RSS readers to know there is a feed on the page. You need the link and the page title - hence the fiddly code below...perhaps one day this can be rewriiten in a better way? -->
                <!-- this is the rss feed link -->
                <xsl:variable name="rsspagefeed">
                        <xsl:choose>
                                <xsl:when test="/H2G2/@TYPE='JOURNAL'">http://www.bbc.co.uk/dna/collective/xml/MJ<xsl:value-of select="/H2G2/JOURNAL/@USERID"/>?Journal=<xsl:value-of
                                                select="/H2G2/JOURNAL/JOURNALPOSTS/@FORUMID"/>&amp;s_xml=rss</xsl:when>
                                <xsl:when test="/H2G2/INFO/@MODE='articles'">http://www.bbc.co.uk/dna/collective/xml/info?cmd=art&amp;s_xml=rss</xsl:when>
                                <xsl:when test="/H2G2/INFO/@MODE='conversations'">http://www.bbc.co.uk/dna/collective/xml/info?cmd=conv&amp;s_xml=rss</xsl:when>
                                <xsl:when test="/H2G2/FORUMSOURCE/@TYPE='article'">http://www.bbc.co.uk/dna/collective/xml/F<xsl:value-of select="/H2G2/FORUMTHREADPOSTS/@FORUMID"
                                                />?thread=<xsl:value-of select="/H2G2/FORUMTHREADPOSTS/@THREADID"/>&amp;latest=1&amp;s_xml=rss</xsl:when>
                                <xsl:when test="/H2G2/FORUMSOURCE/@TYPE='journal'">http://www.bbc.co.uk/dna/collective/xml/F<xsl:value-of select="/H2G2/FORUMTHREADPOSTS/@FORUMID"
                                                />?thread=<xsl:value-of select="/H2G2/FORUMTHREADPOSTS/@THREADID"/>&amp;latest=1&amp;s_xml=rss</xsl:when>
                                <xsl:when test="/H2G2/@TYPE='THREADS'">http://www.bbc.co.uk/dna/collective/xml/F<xsl:value-of select="/H2G2/FORUMTHREADS/@FORUMID"/>?s_xml=rss</xsl:when>
                                <xsl:when test="$article_subtype = 'features'">http://www.bbc.co.uk/dna/collective/xml/features?s_xml=rss</xsl:when>
                                <xsl:when test="$article_subtype ='reviews'">http://www.bbc.co.uk/dna/collective/xml/reviews?s_xml=rss</xsl:when>
                                <xsl:when test="/H2G2/@TYPE='MOREPOSTS'">http://www.bbc.co.uk/dna/collective/xml/MP<xsl:value-of select="/H2G2/POSTS/POST-LIST/USER/USERID"/>?s_xml=rss</xsl:when>
                        </xsl:choose>
                </xsl:variable>
                <!-- this is the rss header -->
                <xsl:variable name="rssheader">
                        <xsl:value-of select="$m_pagetitlestart"/>
                        <xsl:choose>
                                <xsl:when test="/H2G2/@TYPE='JOURNAL'">
                                        <xsl:value-of select="$m_h2g2journaltitle"/>
                                </xsl:when>
                                <xsl:when test="/H2G2/INFO/@MODE='articles'">new member reviews and pages</xsl:when>
                                <xsl:when test="/H2G2/INFO/@MODE='conversations'">updated conversations</xsl:when>
                                <xsl:when test="/H2G2/FORUMSOURCE/@TYPE='article'">
                                        <xsl:value-of select="/H2G2/FORUMSOURCE/ARTICLE/SUBJECT"/>
                                </xsl:when>
                                <xsl:when test="/H2G2/FORUMSOURCE/@TYPE='journal'">
                                        <xsl:value-of select="/H2G2/FORUMSOURCE/JOURNAL/USER/USERNAME"/>
                                </xsl:when>
                                <xsl:when test="/H2G2/@TYPE='THREADS'">
                                        <xsl:apply-templates mode="t_threadspage" select="SUBJECT"/>
                                </xsl:when>
                                <xsl:when test="$article_subtype = 'features'">Features</xsl:when>
                                <xsl:when test="$article_subtype ='reviews'">Reviews</xsl:when>
                                <xsl:when test="/H2G2/@TYPE='MOREPOSTS'">
                                        <xsl:value-of select="/H2G2/POSTS/POST-LIST/USER/USERNAME"/>
                                </xsl:when>
                        </xsl:choose>
                </xsl:variable>
                <!-- this is the RSS meta link -->
                <link href="{$rsspagefeed}" rel="alternative" title="{$rssheader}" type="application/rdf+xml"/>
                <!-- favorite icon inclusion -->
                <link href="http://www.bbc.co.uk/collective/favicon.ico?2" rel="icon" type="image/x-icon"/>
                <link href="http://www.bbc.co.uk/collective/favicon.ico?2" rel="shortcut icon" type="image/x-icon"/>
                <!-- meta tags for search engines -->
                <meta name="description">
                        <xsl:attribute name="content">
                                <xsl:choose>
                                        <xsl:when test="/H2G2/ARTICLE/EXTRAINFO/DESCRIPTION">
                                                <xsl:value-of select="/H2G2/ARTICLE/EXTRAINFO/DESCRIPTION"/>
                                        </xsl:when>
                                        <xsl:when test="/H2G2/@TYPE='FRONTPAGE'">
                                                <xsl:value-of select="/H2G2/ARTICLE/FRONTPAGE/DESCRIPTION"/>
                                        </xsl:when>
                                        <xsl:when test="$article_type_user='member'">
                                                <xsl:value-of select="/H2G2/ARTICLE/GUIDE/HEADLINE"/>
                                        </xsl:when>
                                </xsl:choose>
                        </xsl:attribute>
                </meta>
                <meta name="keywords">
                        <xsl:attribute name="content">
                                <xsl:choose>
                                        <xsl:when test="/H2G2/ARTICLE/GUIDE/KEYWORDS">
                                                <xsl:value-of select="/H2G2/ARTICLE/GUIDE/KEYWORDS"/>
                                        </xsl:when>
                                        <xsl:when test="/H2G2/@TYPE='FRONTPAGE'">
                                                <xsl:value-of select="/H2G2/ARTICLE/FRONTPAGE/KEYWORDS"/>
                                        </xsl:when>
                                </xsl:choose>
                        </xsl:attribute>
                </meta>
        </xsl:variable>
        <!-- SSO -->
        <xsl:variable name="sso_serviceid_path">collective</xsl:variable>
        <xsl:variable name="create_old_article">TypedArticle?acreate=new&amp;type=1</xsl:variable>
        <xsl:variable name="create_member_article">TypedArticle?acreate=new&amp;type=2</xsl:variable>
        <xsl:variable name="create_editor_article">TypedArticle?acreate=new&amp;type=3</xsl:variable>
        <xsl:variable name="create_frontpage_article">TypedArticle?acreate=new&amp;type=5</xsl:variable>
        <xsl:variable name="create_member_review">TypedArticle?acreate=new&amp;type=10</xsl:variable>
        <xsl:variable name="create_member_feature">TypedArticle?acreate=new&amp;type=120</xsl:variable>
        <xsl:variable name="create_editor_review">TypedArticle?acreate=new&amp;type=40</xsl:variable>
        <xsl:variable name="create_feature">TypedArticle?acreate=new&amp;type=55</xsl:variable>
        <xsl:variable name="create_interview">TypedArticle?acreate=new&amp;type=70</xsl:variable>
        <xsl:variable name="create_column">TypedArticle?acreate=new&amp;type=85</xsl:variable>
        <!-- BARLEY : SITE -->
        <xsl:variable name="bbcpage_bgcolor">899DC2</xsl:variable>
        <xsl:variable name="bbcpage_nav">yes</xsl:variable>
        <xsl:variable name="bbcpage_navwidth">125</xsl:variable>
        <xsl:variable name="bbcpage_navgraphic">yes</xsl:variable>
        <xsl:variable name="bbcpage_navgutter">no</xsl:variable>
        <xsl:variable name="bbcpage_contentwidth">635</xsl:variable>
        <xsl:variable name="bbcpage_contentalign">left</xsl:variable>
        <xsl:variable name="bbcpage_language">english</xsl:variable>
        <xsl:variable name="bbcpage_searchcolour">666666</xsl:variable>
        <xsl:variable name="bbcpage_topleft_bgcolour">738BB4</xsl:variable>
        <xsl:variable name="bbcpage_topleft_linkcolour">ffffff</xsl:variable>
        <xsl:variable name="bbcpage_topleft_textcolour">ffffff</xsl:variable>
        <xsl:variable name="bbcpage_lang"/>
        <xsl:variable name="bbcpage_variant"/>
        <!-- BARLEY : CRUMB -->
        <xsl:variable name="crumb-content"/>
        <!-- BARLEY : LOCAL -->
        <xsl:template name="local-content">
                <xsl:variable name="view">
                        <xsl:value-of select="/H2G2/PARAMS/PARAM[NAME = 's_view']/VALUE"/>
                </xsl:variable>
                <div class="navWrapperGraphic">
                        <!-- frontpage -->
                        <div class="navWrapper">
                                <div class="navLink">
                                        <xsl:if test="/H2G2[@TYPE='FRONTPAGE']">
                                                <xsl:attribute name="id">active</xsl:attribute>
                                        </xsl:if>
                                        <a href="{$root}" target="_top">
                                                <xsl:if test="/H2G2[@TYPE='FRONTPAGE']">
                                                        <xsl:attribute name="id">active</xsl:attribute>
                                                </xsl:if>
                                                <xsl:value-of select="$alt_frontpage"/>
                                                <xsl:if test="/H2G2[@TYPE='FRONTPAGE']">&nbsp;</xsl:if>
                                        </a>
                                </div>
                        </div>
                        <!-- category front pages -->
                        <div class="navBlock">
                                <xsl:variable name="categoryid">
                                        <xsl:value-of select="/H2G2/HIERARCHYDETAILS/@NODEID"/>
                                </xsl:variable>
                                <div class="navLink">
                                        <xsl:if test="$categoryid = $musicCat and $view != 'archive'">
                                                <xsl:attribute name="id">active</xsl:attribute>
                                        </xsl:if>
                                        <a href="{$root}C{$musicCat}"><xsl:if test="$categoryid = $musicCat and $view != 'archive'">
                                                        <xsl:attribute name="id">active</xsl:attribute>
                                        </xsl:if>music<xsl:if test="$categoryid = $musicCat and $view != 'archive'">&nbsp;</xsl:if></a>
                                </div>
                                <div class="navLink">
                                        <xsl:if test="$categoryid = $filmCat and $view != 'archive'">
                                                <xsl:attribute name="id">active</xsl:attribute>
                                        </xsl:if>
                                        <a href="{$root}C{$filmCat}"><xsl:if test="$categoryid = $filmCat and $view != 'archive'">
                                                        <xsl:attribute name="id">active</xsl:attribute>
                                        </xsl:if>film<xsl:if test="$categoryid = $filmCat and $view != 'archive'">&nbsp;</xsl:if></a>
                                </div>
                                <div class="navLink">
                                        <xsl:if test="$categoryid = $artCat and $view != 'archive'">
                                                <xsl:attribute name="id">active</xsl:attribute>
                                        </xsl:if>
                                        <a href="{$root}C{$artCat}"><xsl:if test="$categoryid = $artCat and $view != 'archive'">
                                                        <xsl:attribute name="id">active</xsl:attribute>
                                        </xsl:if>art<xsl:if test="$categoryid = $artCat and $view != 'archive'">&nbsp;</xsl:if></a>
                                </div>
                                <div class="navLink">
                                        <xsl:if test="$categoryid = $booksCat and $view != 'archive'">
                                                <xsl:attribute name="id">active</xsl:attribute>
                                        </xsl:if>
                                        <a href="{$root}C{$booksCat}"><xsl:if test="$categoryid = $booksCat and $view != 'archive'">
                                                        <xsl:attribute name="id">active</xsl:attribute>
                                        </xsl:if>books<xsl:if test="$categoryid = $booksCat and $view != 'archive'">&nbsp;</xsl:if></a>
                                </div>
                                <div class="navLink">
                                        <xsl:if test="$categoryid = $gamesCat and $view != 'archive'">
                                                <xsl:attribute name="id">active</xsl:attribute>
                                        </xsl:if>
                                        <a href="{$root}C{$gamesCat}"><xsl:if test="$categoryid = $gamesCat and $view != 'archive'">
                                                        <xsl:attribute name="id">active</xsl:attribute>
                                        </xsl:if>games<xsl:if test="$categoryid = $gamesCat and $view != 'archive'">&nbsp;</xsl:if></a>
                                </div>
                                <div class="navLink">
                                        <xsl:if test="$categoryid=945 or $view = 'archive'">
                                                <xsl:attribute name="id">active</xsl:attribute>
                                        </xsl:if>
                                        <a href="{$root}browse"><xsl:if test="$categoryid=945 or $view = 'archive'">
                                                        <xsl:attribute name="id">active</xsl:attribute>
                                        </xsl:if>archive<xsl:if test="$categoryid=945 or $view = 'archive'">&nbsp;</xsl:if></a>
                                </div>
                        </div>
                        <div class="navBlock">
                                <div class="navLink">
                                        <a href="{$root}talk"><xsl:if test="/H2G2/ARTICLE/ARTICLEINFO/NAME='talk' or /H2G2/ARTICLE/ARTICLEINFO/H2G2ID=823934">
                                                        <xsl:attribute name="id">active</xsl:attribute>
                                                </xsl:if>community<xsl:if test="/H2G2/ARTICLE/ARTICLEINFO/NAME='talk' or /H2G2/ARTICLE/ARTICLEINFO/H2G2ID=823934">&nbsp;</xsl:if></a>
                                </div>
                        </div>
                        <div class="navBlock">
                                <div class="navLink">
                                        <a href="{$root}about"><xsl:if test="/H2G2/ARTICLE/ARTICLEINFO/NAME='about'">
                                                        <xsl:attribute name="id">active</xsl:attribute>
                                                </xsl:if>about collective<xsl:if test="/H2G2/ARTICLE/ARTICLEINFO/NAME='about'">&nbsp;</xsl:if></a>
                                </div>
                                <div class="navLink">
                                        <a href="{$root}helpfaqs"><xsl:if test="/H2G2/ARTICLE/ARTICLEINFO/NAME='helpfaqs'">
                                                        <xsl:attribute name="id">active</xsl:attribute>
                                                </xsl:if>help and faq's<xsl:if test="/H2G2/ARTICLE/ARTICLEINFO/NAME='helpfaqs'">&nbsp;</xsl:if></a>
                                </div>
                        </div>
                        <!-- newsletter -->
                        <div class="navBox">
                                <div class="navBoxHeader">newsletter</div>
                                <div class="navBoxText">Receive our weekly email roundups.<br/>
                                        <a href="{$root}newsletter"><img alt="" border="0" height="7" src="{$imagesource}/icons/arrow_right.gif" width="9"/> sign up</a>
                                </div>
                        </div>
                </div>
        </xsl:template>
        <!-- 
	<xsl:template match="H2G2" mode="r_userpage">
	Use: Presentation of the User page link
	-->
        <xsl:template match="H2G2" mode="r_userpage">
                <xsl:apply-imports/>
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
        <!-- BARLEY: BANNER -->
        <xsl:variable name="banner-content">
                <div class="banner-wrapper">
                        <div class="banner" style="padding-bottom:10px;">
                                <div class="banner-inner">
                                        <div id="banner-title">
                                        	<a href="{$root}"><img alt="collective" height="54" src="{$imagesource}collective_closing.gif" width="613" border="0" /></a>
                                                
                                        </div>
                                        <div id="banner-crumb">
                                                <table border="0" cellpadding="0" cellspacing="0" width="600">
                                                        <tr>
                                                                <td align="right" class="banner-search" colspan="2">
                                                                        <form action="{$root}search"><input name="searchtype" type="hidden" value="article"/><label for="banner-search-box">search 1000s
                                                                                        of reviews, interviews and features:</label>&nbsp;<input id="banner-search-box" name="searchstring"
                                                                                        size="10" type="text"/>&nbsp;<input border="0" height="19" id="banner-search-submit"
                                                                                        src="{$imagesource}buttons/banner_search_submit.gif" type="image" value="go" width="19"/>&nbsp;</form>
                                                                </td>
                                                        </tr>
                                                </table>
                                        </div>
                                </div>
                        </div>
                </div>
        </xsl:variable>
        <!-- PRIMARY TEMPLATE -->
        <xsl:template name="primary-template">
                <html>
                        <xsl:call-template name="insert-header"/>
                        <body leftmargin="0" marginheight="0" marginwidth="0" onLoad="init();" topmargin="0">
                                <xsl:apply-templates mode="c_bodycontent" select="/H2G2"/>
                        </body>
                </html>
        </xsl:template>
        <!-- BODY CONTENT -->
        <xsl:template match="H2G2" mode="r_bodycontent">
                <div class="page-wrapper">
                        <div class="page">
                                <div class="page-inner">
                                        <div class="page-content" id="page">
                                                <xsl:call-template name="insert-mainbody"/>
                                        </div>
                                        <div class="page-az"/>
                                        <div class="page-history">
                                                <xsl:call-template name="whereyouhavebeen"/>
                                        </div>
                                </div>
                        </div>
                </div>
                <div class="footer-wrapper">
                        <div class="footer">
                                <div class="footer-inner">
                                        <div class="footer-content">&nbsp;</div>
                                        <div class="footer-disclaimer">
                                                <xsl:element name="{$text.base}" use-attribute-sets="text.base">
                                                        <hr class="footer-disclaimer"/>
                                                        <xsl:copy-of select="$m_footerdisclaimer"/>
                                                </xsl:element>
                                        </div>
                                </div>
                        </div>
                </div>
                <xsl:if test="$test_IsEditor">
                        <div id="editor-box">
                                <h3>Editor Box</h3>
                                <xsl:if test="/H2G2/@TYPE = 'CATEGORY'">
                                        <a href="{concat($root, 'TypedArticle?aedit=new&amp;type=4001&amp;h2g2id=', /H2G2/HIERARCHYDETAILS/H2G2ID)}">Edit this category page</a>
                                </xsl:if>
                                <a href="{concat($root, 'siteconfig')}">Edit site config</a>
                                <a href="{concat($root, 'editcategory')}">Edit categories</a>
                                <a href="{concat($root, 'editfrontpage')}">Edit home page</a>
                                <a href="{concat($root, 'dlct')}">Edit dynamic lists</a>
                        </div>
                </xsl:if>
                <xsl:if test="$VARIABLETEST=1">
                        <xsl:call-template name="VARIABLEDUMP"/>
                </xsl:if>
                <xsl:if test="$TESTING=1">
                        <xsl:call-template name="ERRORFORM"/>
                </xsl:if>
        </xsl:template>
        <!-- POPUP -->
        <xsl:template name="popup-template">
                <html>
                        <xsl:call-template name="insert-header"/>
                        <body leftmargin="0" marginheight="0" marginwidth="0" topmargin="0">
                                <xsl:call-template name="insert-mainbody"/>
                        </body>
                </html>
        </xsl:template>
        <!--===============Global Alpha Index=====================-->
        <xsl:template match="PARSEERRORS" mode="r_typedarticle">
                <b>Error in the XML</b>
                <br/>
                <xsl:apply-templates/>
        </xsl:template>
        <!-- XML ERROR -->
        <xsl:template match="XMLERROR">
                <b>
                        <xsl:value-of select="."/>
                </b>
        </xsl:template>
        <!-- DATE -->
        <xsl:template match="DATE" mode="collective_long">
                <xsl:value-of select="translate(@DAYNAME, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz')"/>
                <xsl:text> </xsl:text>
                <xsl:value-of select="translate(@DAY, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz')"/>
                <xsl:text> </xsl:text>
                <xsl:value-of select="translate(@MONTHNAME, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz')"/>
                <xsl:text> </xsl:text>
                <xsl:value-of select="substring(@YEAR, 3, 4)"/>
        </xsl:template>
        <xsl:template match="DATE" mode="collective_med">
                <xsl:value-of select="translate(@DAY, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz')"/>
                <xsl:text> </xsl:text>
                <xsl:value-of select="translate(@MONTHNAME, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz')"/>
                <xsl:text> </xsl:text>
                <xsl:value-of select="substring(@YEAR, 3, 4)"/>
        </xsl:template>
        <xsl:template match="DATE" mode="collective_short">
                <xsl:value-of select="translate(@DAY, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz')"/>
                <xsl:text> </xsl:text>
                <xsl:value-of select="translate(substring(@MONTHNAME, 1, 3), 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz')"/>
                <xsl:text> </xsl:text>
                <xsl:value-of select="substring(@YEAR, 3, 4)"/>
        </xsl:template>
        <xsl:template match="DATE" mode="short1">
                <xsl:value-of select="@DAYNAME"/>&nbsp;<xsl:value-of select="@DAY"/>&nbsp;<xsl:value-of select="@MONTHNAME"/>&nbsp;<xsl:value-of select="@YEAR"/>
        </xsl:template>
        <!--
	<xsl:template name="article_subtype">
	Description: Presentation of the subtypes in search, index, category and userpage lists
	 -->
        <xsl:template name="article_subtype">
                <xsl:param name="num" select="EXTRAINFO/TYPE/@ID"/>
                <xsl:param name="status"/>
                <xsl:param name="pagetype"/>
                <xsl:param name="searchtypenum"/>
                <!-- match with lookup table type.xsl -->
                <!-- subtype label -->
                <xsl:variable name="label">
                        <xsl:value-of select="msxsl:node-set($type)/type[@number=$num or @selectnumber=$num]/@label"/>
                </xsl:variable>
                <!-- user type - member or editor -->
                <xsl:variable name="usertype">
                        <xsl:value-of select="msxsl:node-set($type)/type[@number=$num or @selectnumber=$num]/@user"/>
                </xsl:variable>
                <xsl:choose>
                        <!-- old reviews by editors -->
                        <xsl:when test="$num=1 and $status=1">editorial</xsl:when>
                        <!-- old reviews by members -->
                        <xsl:when test="$num=1 and $status=3">member review </xsl:when>
                        <xsl:when test="$num=$searchtypenum">
                                <xsl:if test="msxsl:node-set($type)/type[@selectnumber=$num]">selected</xsl:if>
                                <!-- dont show anything for member indexs by type e.g. member film reviews list -->
                        </xsl:when>
                        <!-- for index and userpage where no user prefix is required -->
                        <xsl:when test="$pagetype='nouser'">
                                <xsl:if test="msxsl:node-set($type)/type[@selectnumber=$num]">selected</xsl:if>
                                <xsl:text>  </xsl:text>
                                <xsl:value-of select="$label"/>
                        </xsl:when>
                        <xsl:when test="$num=3001">member's page</xsl:when>
                        <!-- selected member's film review layout or member's portfoilio page-->
                        <xsl:otherwise>
                                <!-- if selected -->
                                <xsl:if test="msxsl:node-set($type)/type[@selectnumber=$num]">selected</xsl:if>
                                <!-- editor's or member's -->
                                <xsl:if test="not(contains($label,'interview') or contains($label,'column') or contains($label,'feature'))">
                                        <xsl:value-of select="$usertype"/>'s </xsl:if>
                                <!-- label name i.e. film review -->
                                <xsl:value-of select="$label"/>
                        </xsl:otherwise>
                </xsl:choose>
        </xsl:template>
        <!-- WHERE YOU HAVE BEEN -->
        <xsl:template name="whereyouhavebeen">
                <table border="0" cellpadding="0" cellspacing="0">
                        <tr>
                                <xsl:element name="td" use-attribute-sets="column.1"/>
                                <xsl:element name="td" use-attribute-sets="column.3"/>
                                <xsl:element name="td" use-attribute-sets="column.2">
                                        <div class="promo-type">
                                                <xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall">
                                                        <xsl:call-template name="RANDOMCROSSREFERAL"/>
                                                </xsl:element>
                                        </div>
                                </xsl:element>
                        </tr>
                </table>
                <!-- DEBUG -->
                <xsl:if test="$DEBUG = 1 or (/H2G2/PARAMS/PARAM[NAME = 's_debug']/VALUE = '1' and $test_IsEditor=1)">
                        <xsl:apply-templates mode="debug" select="/H2G2"/>
                </xsl:if>
                <!-- /DEBUG -->
        </xsl:template>
        <!-- ******************************************************************************************************* -->
        <!-- TODO Temporary templates - added so skins can be uploaded to staging server 25/03/2004 -->
        <!--                             Can be remove when these templates are on live - Thomas Whitehouse                          -->
        <!-- ******************************************************************************************************* -->
        <xsl:attribute-set name="it_searchstring"/>
        <xsl:attribute-set name="it_submitsearch"/>
        <xsl:attribute-set name="fc_search_dna"/>
        <xsl:template name="t_searchstring">
                <input name="searchstring" type="text" xsl:use-attribute-sets="it_searchstring"/>
        </xsl:template>
        <xsl:template name="t_submitsearch">
                <input name="dosearch" xsl:use-attribute-sets="it_submitsearch">
                        <xsl:attribute name="value">
                                <xsl:value-of select="$m_searchtheguide"/>
                        </xsl:attribute>
                </input>
        </xsl:template>
        <xsl:template name="c_search_dna">
                <form action="{$root}Search" method="get" xsl:use-attribute-sets="fc_search_dna">
                        <xsl:call-template name="r_search_dna"/>
                </form>
        </xsl:template>
</xsl:stylesheet>