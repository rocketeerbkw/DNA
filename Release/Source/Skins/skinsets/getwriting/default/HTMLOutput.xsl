<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
	<!ENTITY arrow "&#9658;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<!--===============Imported Files=====================-->
	<xsl:import href="../../../base/base-extra.xsl"/>
	<xsl:include href="XPaths.xsl"/>
	<!--===============Imported Files=====================-->
	<!--===============Included Files=====================-->
	<xsl:include href="addjournalpage.xsl"/>
	<xsl:include href="addthreadpage.xsl"/>
	<xsl:include href="articlepage.xsl"/>
	<xsl:include href="categorypage.xsl"/>
	<xsl:include href="clubpage.xsl"/>
	<xsl:include href="clublistpage.xsl"/>

	<xsl:include href="frontpage.xsl"/>
	<xsl:include href="getwritingbuttons.xsl"/>
	<xsl:include href="getwritingicons.xsl"/>
	<xsl:include href="getwritingtext.xsl"/>
	<xsl:include href="getwritingtips.xsl"/>
	<xsl:include href="guideml.xsl"/>
	<xsl:include href="indexpage.xsl"/>
	<xsl:include href="infopage.xsl"/>
	<xsl:include href="journalpage.xsl"/>
	<xsl:include href="miscpage.xsl"/>
	
	<xsl:include href="morearticlespage.xsl"/>
	<xsl:include href="morepostspage.xsl"/>
	<xsl:include href="multipostspage.xsl"/>
	<xsl:include href="newuserspage.xsl"/>

	<xsl:include href="registerpage.xsl"/>	
	<xsl:include href="reviewforumpage.xsl"/>
	<xsl:include href="siteconfigpage.xsl"/>
	<xsl:include href="searchpage.xsl"/>
	<xsl:include href="submitreviewforumpage.xsl"/>
	<xsl:include href="tabnavigation.xsl"/>
	<xsl:include href="tabnavigationtext.xsl"/>

	<xsl:include href="threadspage.xsl"/>
	<xsl:include href="typedarticlepage.xsl"/>
	<xsl:include href="types.xsl"/>
	<xsl:include href="usercomplaintpopup.xsl"/>
	<xsl:include href="userdetailspage.xsl"/>
	<xsl:include href="usereditpage.xsl"/>
	<xsl:include href="usermyclubspage.xsl"/>
	<xsl:include href="userpage.xsl"/>
	<xsl:include href="watcheduserspage.xsl"/>
	
	<!--===============Variables=====================-->
	<xsl:variable name="reviewforum" select="7"/>
	<xsl:variable name="sitedisplayname">Get Writing</xsl:variable>
	<xsl:variable name="sitename">getwriting</xsl:variable> 
	<xsl:variable name="realmediadir">http://www.bbc.co.uk/h2g2/ram/</xsl:variable>
	<xsl:variable name="smileysource">http://www.bbc.co.uk/h2g2/skins/Alabaster/images/Smilies/</xsl:variable>
	<xsl:variable name="voteurl">http://www.bbc.co.uk:80/cgi-perl/polling/poll.pl</xsl:variable>
	
	
 	<xsl:variable name="imagesource"><xsl:value-of select="$site_server" />/getwriting/images/</xsl:variable> 
	<xsl:variable name="graphics"><xsl:value-of select="$site_server" />/getwriting/furniture/</xsl:variable>
	<xsl:variable name="jscriptsource"><xsl:value-of select="$site_server" />/getwriting/images/</xsl:variable> 
	
	<!--===============   SERVER    =====================-->
	<!-- http://132.185.106.242:8080 -->
	<xsl:variable name="site_server">http://www.bbc.co.uk</xsl:variable>
	<!-- <xsl:variable name="site_server">http://www.bbc.co.uk</xsl:variable> -->
	<!--===============  SERVER       =====================-->


	<!-- meta tags -->
	<xsl:variable name="meta-tags">
	<meta name="description">
		<xsl:attribute name="content">
		<xsl:choose>
			<xsl:when test="$tabgroups='home'">Explore and develop your creative writing skills with the BBC. Get advice from the experts, publish your writing online, and meet fellow writers in the huge online community.</xsl:when>
			<xsl:when test="$tabgroups='write'">Publish your stories, poems and scripts online and get feedback on your work from other community members.</xsl:when>
			<xsl:when test="$tabgroups='groups'">Join an online writing group for support and feedback on your work, or form your own group.</xsl:when>
			<xsl:when test="$tabgroups='learn'">Learn about creative writing from top-name authors, take a mini-course to improve your writing skills and use the interactive tools to spark your imagination.</xsl:when>
			<xsl:when test="$tabgroups='talk'">Discuss the art of creative writing with other writers in the community. Share your advice on writing techniques, or ask other people for their ideas and suggestions.</xsl:when>
			<xsl:when test="$tabgroups='readreview'">Submit your stories, poems or scripts for other community members to review. Browse the Review Circles and find work from other writers to read and comment on.</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
				<xsl:when test="/H2G2/ARTICLE/EXTRAINFO/DESCRIPTION">
				<xsl:value-of select="/H2G2/ARTICLE/EXTRAINFO/DESCRIPTION" />
				</xsl:when>
				<xsl:otherwise>
				<xsl:value-of select="/H2G2/ARTICLE/EXTRAINFO/AUTODESCRIPTION" />
				</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
		</xsl:attribute>
	</meta>
	
	<meta name="keywords">
		<xsl:attribute name="content">
		<xsl:choose>
			<xsl:when test="$tabgroups='home'">BBC Get Writing, Get Writing, creative writing, writing, community, BBC learning, publish your writing, short stories, poetry, short fiction, scriptwriting, online community</xsl:when>
			<xsl:when test="$tabgroups='write'">Write, publish, publish on the BBC, share advice, writing challenges, writing competitions, feedback, short stories, poems, scriptwriting, scripts, short fiction</xsl:when>
			<xsl:when test="$tabgroups='groups'">Groups, critiquing groups, writing groups, feedback, group member, form a group, join a group</xsl:when>
			<xsl:when test="$tabgroups='learn'">Learn, Mini-Courses, Tools, Quizzes, Events &amp; Video, Events and Video, expert advice, creative writing, interactive tools, Course Finder, find a writing course, find a writing group</xsl:when>
			<xsl:when test="$tabgroups='talk'">Talk, Talk Craft, WordPlay, Newbies' Room, creative writing, community, online community, discussion forum, conversation boards, discuss</xsl:when>
			<xsl:when test="$tabgroups='readreview'">Read and Review, Read &amp; Review, read, review, short stories, scripts, poems, crime, thriller, science fiction, fantasy, drama scripts, comedy scripts, non-fiction, children, feedback, anthology, Review Circle</xsl:when>
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
		</xsl:attribute>
	</meta>
	
	</xsl:variable> 
	
	
	<!--===============CSS=====================-->
  <xsl:variable name="csslink">

	<!-- <link type="text/css" rel="stylesheet" title="default" href="{$site_server}/getwriting/includes/getwriting.css"/> -->
	<link type="text/css" rel="stylesheet" title="default" href="http://www.bbc.co.uk/getwriting/includes/getwriting.css"/>

	<xsl:if test="$test_IsEditor and /H2G2/@TYPE='TYPED-ARTICLE' or $test_IsEditor and /H2G2/@TYPE='SITECONFIG-EDITOR'">
	<link type="text/css" rel="stylesheet" title="default" href="http://www.bbc.co.uk/getwriting/includes/editor.css"/>
	</xsl:if>

	<xsl:call-template name="insert-css"/>
	</xsl:variable> 
	<!--===============CSS=====================-->
	
	
	<!--===============Included Files=====================-->
	<!--===============Output Setting=====================-->
	<xsl:output method="html" version="4.0" omit-xml-declaration="yes" standalone="yes" indent="yes" encoding="ISO8859-1"/>
	<!--===============Output Setting=====================-->
	<!--===============        SSO       =====================-->
	<xsl:variable name="sso_assets_path">/getwriting/sso_resources</xsl:variable>
	<xsl:variable name="sso_serviceid_path">getwriting</xsl:variable>
	<xsl:variable name="sso_serviceid_link">getwriting</xsl:variable>
	
	<!--===============        SSO       =====================-->
	<!--===============Attribute-sets Settings=====================-->
	<xsl:attribute-set name="mainfont">
		<xsl:attribute name="size">2</xsl:attribute>
	</xsl:attribute-set>
	<!--===============Attribute-sets Settings=====================-->
	<!--===============Javascript=====================-->
	<xsl:variable name="scriptlink">
		<script type="text/javascript" src="{$jscriptsource}smiley_javascript.js" language="JavaScript"></script>
	
		<xsl:call-template name="insert-javascript"/>
		<script type="text/javascript">
			<xsl:comment>
				
				function aodpopup(URL){
				
				window.open(URL,'aod','width=662,height='+high+',top=0,toolbar=no,personalbar=no,location=no,directories=no,statusbar=no,menubar=no,status=no,resizable=yes,left=60,screenX=60,top=100,screenY=100');
				}
				window.name="main";
				
				if(location.search.substring(1)=="focuswin"){
				window.focus();
				}
				
				function popwin(aPage, aTarget, w, h, var1, var2){
			       window.open(aPage,aTarget,'status=no,top=0,left=0,scrollbars=' +((var1=='scroll' || var2=='scroll')? 'yes' : 'no')+ ',resizable=' +((var1=='resize' || var2=='resize')? 'yes' : 'no')+ ',width='+w+',height='+h);
					}	
					
				function printwin(aPage, aTarget, w, h, var1, var2){
			       window.open(aPage,aTarget,'status=no,top=0,toolbar=yes,left=0,scrollbars=' +((var1=='scroll' || var2=='scroll')? 'yes' : 'no')+ ',resizable=' +((var1=='resize' || var2=='resize')? 'yes' : 'no')+ ',width='+w+',height='+h);
					}	

				function popupwindow(link, target, parameters) {
					popupWin = window.open(link,target,parameters);
				}
				function popusers(link) {
					popupWin = window.open(link,'popusers','status=1,resizable=1,scrollbars=1,width=165,height=340');
				}
				<xsl:text>//</xsl:text>
			</xsl:comment>
		</script>
	</xsl:variable>
	<!--===============Javascript=====================-->
	<!--===============Variable Settings=====================-->
	<xsl:variable name="root">/dna/getwriting/</xsl:variable>
	<xsl:variable name="skinname">getwriting</xsl:variable>
	<xsl:variable name="bbcpage_bgcolor">ffffff</xsl:variable>
	<xsl:variable name="bbcpage_nav">yes</xsl:variable>
	<xsl:variable name="bbcpage_navwidth">125</xsl:variable>
	<xsl:variable name="bbcpage_navgraphic">yes</xsl:variable>
	<xsl:variable name="bbcpage_navgutter">no</xsl:variable>
	<xsl:variable name="bbcpage_contentwidth">635</xsl:variable>
	<xsl:variable name="bbcpage_contentalign">left</xsl:variable>
	<xsl:variable name="bbcpage_language">english</xsl:variable>
	<xsl:variable name="bbcpage_searchcolour">747474</xsl:variable>
	<xsl:variable name="bbcpage_topleft_bgcolour"/>
	<xsl:variable name="bbcpage_topleft_linkcolour"/>
	<xsl:variable name="bbcpage_topleft_textcolour"/>
	<xsl:variable name="bbcpage_lang"/>
	<xsl:variable name="bbcpage_variant"/>
	
	<!--===============Navigation Template (Nav Stuff)=====================-->
	<!-- NOTE  having to override the base template as the bbcpage_navgraphic stick in a redundant br tag that spoils the design. the br tags is not part of the barely templates -->
	<xsl:template name="navigation-template">
		<tr>
			<td class="bbcpageCrumb" width="8"> 
				<img src="/f/t.gif" width="8" height="1" alt=""/>
			</td>
			<td class="bbcpageCrumb" width="{number($bbcpage_navwidth)-10}">
				<img src="/f/t.gif" width="{number($bbcpage_navwidth)-10}" height="1" alt=""/>
				<br clear="all"/>
				<font face="arial, helvetica,sans-serif" size="2">
					<a class="bbcpageCrumb" href="/">BBC Homepage</a>
					<br/>
					<xsl:copy-of select="$crumb-content"/>
				</font>
			</td>
			<td width="2" class="bbcpageCrumb">
				<img src="/f/t.gif" width="2" height="1" alt=""/>
			</td>
			<xsl:if test="$bbcpage_navgutter != 'no'">
				<td class="bbcpageGutter" valign="top" width="10" rowspan="4">
					<img src="/f/t.gif" width="10" height="1" vspace="0" hspace="0" alt="" align="left"/>
				</td>
			</xsl:if>
		</tr>
		<xsl:choose>
			<xsl:when test="$bbcpage_navgraphic = 'yes'">
				<tr>
					<td colspan="3" class="bbcpageLocal">
						<xsl:call-template name="local-content"/>
					</td>
				</tr>
				<tr>
					<td class="bbcpageLocal" colspan="3">
						<img src="/f/t.gif" width="1" height="5" alt=""/>
					</td>
				</tr>
			</xsl:when>
			<xsl:otherwise>
				<tr>
					<td class="bbcpageLocal" colspan="3">
						<img src="/f/t.gif" width="1" height="7" alt=""/>
					</td>
				</tr>
				<tr>
					<td class="bbcpageLocal" width="8" valign="top" align="right">
						<font size="1">&#187;</font>
					</td>
					<td class="bbcpageLocal" valign="top">
						<font face="arial, helvetica,sans-serif" size="2">
							<xsl:call-template name="local-content"/>
				&nbsp;</font>
					</td>
					<td class="bbcpageLocal" width="2">
						<img src="/f/t.gif" width="1" height="1" alt=""/>
					</td>
				</tr>
			</xsl:otherwise>
		</xsl:choose>
		<tr>
			<td class="bbcpageServices">
				<img src="/f/t.gif" width="1" height="1" alt=""/>
			</td>
			<td class="bbcpageServices">
				<hr width="50" align="left"/>
				<font face="arial, helvetica, sans-serif" size="2">
					<xsl:choose>
						<xsl:when test="$bbcpage_lang = 'alba'">
							<a class="bbcpageServices" href="/info/">Mun BhBC</a>
							<br/>
							<br/>
							<a class="bbcpageServices" href="/feedback/">Ur Beachdan</a>
							<br/>
							<br/>
							<a class="bbcpageServices" href="/help/">Taic</a>
							<br/>
							<br/>
							<br/>
							<font size="1">An toil leat an duilleag-sa?<br/>
								<a class="bbcpageServices" onclick="popmailwin('/cgi-bin/navigation/mailto.pl?GO=1','Mailer')" href="/cgi-bin/navigation/mailto.pl?GO=1" target="Mailer">Cuir gu caraid i!</a>
							</font>
						</xsl:when>
						<xsl:when test="$bbcpage_lang = 'cymru'">
							<a class="bbcpageServices" href="/cymru/arolwg2001/">Arolwg 2001</a>
							<br/>
							<br/>
							<a class="bbcpageServices" href="/cymru/gwybodaeth/adborth.shtml">Ymateb</a>
							<br/>
							<br/>
							<a class="bbcpageServices" href="/cymru/cymorth">Cymorth</a>
							<br/>
							<br/>
							<br/>
							<font size="1">Wedi mwynhau'r ddalen hon?<br/>
								<a class="bbcpageServices" onclick="popmailwin('/cgi-bin/navigation/mailto.pl?GO=1','Mailer')" href="/cgi-bin/navigation/mailto.pl?GO=1" target="Mailer">Anfonwch hi i gyfaill!</a>
							</font>
						</xsl:when>
						<xsl:otherwise>
							<a class="bbcpageServices" href="/info/">About the BBC</a>
							<br/>
							<br/>
							<a class="bbcpageServices" href="/feedback/">Contact Us</a>
							<br/>
							<br/>
							<a class="bbcpageServices" href="/help/">Help</a>
							<br/>
							<br/>
							<br/>
							<font size="1">Like this page?<br/>
								<a class="bbcpageServices" xsl:use-attribute-sets="sendtoafriendlink">Send it to a friend!</a>
							</font>
						</xsl:otherwise>
					</xsl:choose>
					<br/>&nbsp;</font>
			</td>
			<td class="bbcpageServices">
				<img src="/f/t.gif" width="1" height="1" alt=""/>
			</td>
		</tr>
	</xsl:template>
	<!--===============Navigation Template (Nav Stuff)=====================-->
	<!--===============Variable Settings=====================-->
	<!--===============Banner Template (Banner Area Stuff)=====================-->
	<xsl:variable name="banner-content">
		<!-- <div>&nbsp;</div>
	<div class="bannerLink"><img src="/f/t.gif" width="1" height="11" border="0"/> --><!-- <a href="{$root}guidedtour">New to the site? Take our guided tour&nbsp;<img src="/getwriting/furniture/icons/arrow_next_white.gif" width="7" height="11" alt="white arrow" border="0" /></a> --><!-- </div> -->		
	</xsl:variable>
	<!--===============Banner Template (Banner Area Stuff)=====================-->
	<!--===============Crumb Template (Crumb Navigation Stuff)=====================-->
	<xsl:variable name="crumb-content"></xsl:variable>
	<!--===============Crumb Template (Crumb Navigation Stuff)=====================-->
	<!--===============Local Template (Local Navigation Stuff)=====================-->
	<xsl:template name="local-content">
	<div class="navWrapperGraphic">
	<div class="navWrapper">
		<div class="navBreak"><xsl:if test="$tabgroups='home'"><xsl:attribute name="id">active</xsl:attribute></xsl:if><a target="_top" href="{$root}"><xsl:if test="$tabgroups='home'"><xsl:attribute name="id">active</xsl:attribute></xsl:if>GW Home</a></div>
	</div>
	<div class="navBreak">
	<xsl:if test="$tabgroups='myspace'"><xsl:attribute name="id">active</xsl:attribute></xsl:if>
	<a>
	<xsl:if test="$tabgroups='myspace'"><xsl:attribute name="id">active</xsl:attribute></xsl:if>
	<xsl:attribute name="href">
	<xsl:choose>
	<xsl:when test="PAGEUI/MYHOME[@VISIBLE=1]"><xsl:value-of select="concat($root,'U',VIEWING-USER/USER/USERID)" /></xsl:when>
	<xsl:otherwise><xsl:value-of select="$sso_signinlink" /></xsl:otherwise>
	</xsl:choose>
	</xsl:attribute>My Space
    </a>
	</div>
	<div class="navLink"><xsl:if test="$tabgroups='readreview'"><xsl:attribute name="id">active</xsl:attribute></xsl:if><a href="{$root}read"><xsl:if test="$tabgroups='readreview'"><xsl:attribute name="id">active</xsl:attribute></xsl:if>Read</a></div>


	<div class="navLink"><xsl:if test="$tabgroups='learn'"><xsl:attribute name="id">active</xsl:attribute></xsl:if><a href="{$root}toolsandquizzes"><xsl:if test="$tabgroups='learn'"><xsl:attribute name="id">active</xsl:attribute></xsl:if>Tools &amp; Quizzes</a></div>

	<div class="navLink"><xsl:if test="$tabgroups='minicourse'"><xsl:attribute name="id">active</xsl:attribute></xsl:if><a href="{$root}minicourse"><xsl:if test="$tabgroups='minicourse'"><xsl:attribute name="id">active</xsl:attribute></xsl:if>Mini-Courses</a></div>

	<div class="navLink"><xsl:if test="$tabgroups='craft'"><xsl:attribute name="id">active</xsl:attribute></xsl:if><a href="{$root}thecraft"><xsl:if test="$tabgroups='craft'"><xsl:attribute name="id">active</xsl:attribute></xsl:if>The Craft</a></div>

	<!-- <div class="navLink"><xsl:if test="$tabgroups='write'"><xsl:attribute name="id">active</xsl:attribute></xsl:if><a href="{$root}write"><xsl:if test="$tabgroups='write'"><xsl:attribute name="id">active</xsl:attribute></xsl:if>Write</a></div> -->
	<!-- <div class="navLink"><xsl:if test="$tabgroups='learn'"><xsl:attribute name="id">active</xsl:attribute></xsl:if><a href="{$root}learn"><xsl:if test="$tabgroups='learn'"><xsl:attribute name="id">active</xsl:attribute></xsl:if>Learn</a></div> -->
	<!-- <div class="navLink"><xsl:if test="$tabgroups='talk'"><xsl:attribute name="id">active</xsl:attribute></xsl:if><a href="{$root}talk"><xsl:if test="$tabgroups='talk'"><xsl:attribute name="id">active</xsl:attribute></xsl:if>Talk</a></div> -->
	<!-- <div class="navBreak"><xsl:if test="$tabgroups='group'"><xsl:attribute name="id">active</xsl:attribute></xsl:if><a href="{$root}groups"><xsl:if test="$tabgroups='group'"><xsl:attribute name="id">active</xsl:attribute></xsl:if>Groups</a></div> -->
	<!-- <div class="navLink"><xsl:if test="$tabgroups='search'"><xsl:attribute name="id">active</xsl:attribute></xsl:if><a href="{$root}browse"><xsl:if test="$tabgroups='search'"><xsl:attribute name="id">active</xsl:attribute></xsl:if>Search &amp; Browse</a></div> -->
	<div class="navBreak"><xsl:if test="$tabgroups='eventsvideo'"><xsl:attribute name="id">active</xsl:attribute></xsl:if><a href="{$root}watchandlisten"><xsl:if test="$tabgroups='eventsvideo'"><xsl:attribute name="id">active</xsl:attribute></xsl:if>Watch &amp; Listen</a></div>
	<!-- <div class="navLink"><a href="{$root}newsletter">Newsletter</a></div> -->
	<div class="navLink"><a href="{$root}help">Site Help</a></div>
	<div class="navBreak"><a href="{$root}links">Useful Links</a></div>
	<div class="navLink"><div id="relatedTitle">RELATED LINKS</div></div>
	<div class="navLink"><a href="http://www.bbc.co.uk/arts" id="related">Arts</a></div>
	<div class="navLink"><a href="http://www.bbc.co.uk/drama" id="related">Drama</a></div>
	<div class="navLink"><a href="http://www.bbc.co.uk/radio4" id="related">Radio 4</a></div>
	<div class="navLink"><a href="http://www.bbc.co.uk/writersroom" id="related">writersroom</a></div>
	</div>

		
<!-- 	<xsl:apply-templates select="/H2G2" mode="c_register"/>
	<xsl:apply-templates select="/H2G2" mode="c_login"/>
	<xsl:apply-templates select="/H2G2" mode="c_userpage"/>
	<xsl:apply-templates select="/H2G2" mode="c_contribute"/>
	<xsl:apply-templates select="/H2G2" mode="c_preferences"/>
	<xsl:apply-templates select="/H2G2" mode="c_logout"/> -->	

	</xsl:template>
	<!-- 
	<xsl:template name="r_search_dna">
	Use: Presentation of the global search box
	-->
	<xsl:template name="r_search_dna">
		<input type="hidden" name="type" value="1"/>
		<!-- or forum or user -->
		<input type="hidden" name="showapproved" value="1"/>
		<!-- status 1 articles -->
		<input type="hidden" name="showsubmitted" value="1"/>
		<!-- articles in a review forum -->
		<input type="hidden" name="shownormal" value="1"/>
		<!-- user articles -->
		
		<xsl:call-template name="t_searchstring"/>
		<!-- or other types -->
		<select name="searchtype">
		<option value="article">works</option>
		<option value="forum">conversations</option>
		<option value="user">members</option>
		</select>
		
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
	<xsl:attribute-set name="it_submitsearch" use-attribute-sets="form.search"/>
	
	<xsl:template name="t_submitsearch">
		<input type="image" name="dosearch" src="{$graphics}buttons/button_search.gif"/>
	</xsl:template>
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
			<body bgcolor="#ffffff" text="#000000" link="#000099" vlink="#ff0000" alink="#ff0000" marginheight="0" marginwidth="0" topmargin="0" leftmargin="0" class="{$tabgroups}topbanner">
				<xsl:apply-templates select="/H2G2" mode="c_bodycontent"/>
			</body>
		</html>
	</xsl:template>
	<!--===============Primary Template (Page Stuff)=====================-->
	<!--===============Body Content Template (Global Content Stuff)=====================-->
	<xsl:template match="H2G2" mode="r_bodycontent">
	<xsl:if test="not(/H2G2/PARAMS/PARAM[NAME= 's_print']/VALUE = 1)">
	   <table cellpadding="0" cellspacing="0" border="0">
		<tr>
		<td>
		<div class="topnav"><img src="/f/t.gif" width="1" height="14" border="0"/>
		<!-- <xsl:element name="{$text.small}" use-attribute-sets="text.small">
		<a href="{$root}shortfiction" class="genericlink2">Short fiction</a> |  
		<a href="{$root}poetry" class="genericlink2">Poetry</a> |   
		<a href="{$root}dramascripts" class="genericlink2">Drama</a> |   
		<a href="{$root}comedyscripts" class="genericlink2">Comedy</a> |   
		<a href="{$root}nonfiction" class="genericlink2">Non-Fiction</a> |  
		<a href="{$root}Index?submit=new&amp;user=on&amp;type=41&amp;let=all" class="genericlink2">Writing Advice</a> |  
		<a href="{$root}readandreview" class="genericlink2">more...</a>
		</xsl:element> -->
		</div>
		</td>
		<td>
		<!-- <div class="searchbox"><img src="/f/t.gif" width="1" height="15" border="0"/> -->
		<!-- <xsl:element name="{$text.base}" use-attribute-sets="text.base">
		<form action="{$root}search">
		<input type="hidden" name="type" value="1"/>
		 or forum or user
		<input type="hidden" name="showapproved" value="1"/>
		 status 1 articles
		<input type="hidden" name="showsubmitted" value="1"/>
		 articles in a review forum
		<input type="hidden" name="shownormal" value="1"/>
		<input type="hidden" name="searchtype" value="article"/>
		<img src="{$graphics}/titles/t_searchtop.gif" width="51" height="15" alt="Search"/><input type="text" size="10" name="searchstring"/>
		<input type="image" src="{$graphics}buttons/button_go.gif" height="17" width="17" border="0" value="go" />
		</form>
		</xsl:element>	 -->
		<!-- </div> -->
		</td>
		</tr>
		</table>

		<xsl:choose>
			<xsl:when test="$registered=1">
				<div class="page-sso"><xsl:call-template name="sso_statusbar"/></div>
			</xsl:when>
			<xsl:otherwise>
				 <!-- <div class="page-sso"><img src="/f/t.gif" width="1" height="30" border="0"/></div>  -->
			</xsl:otherwise>
		</xsl:choose>
		

		</xsl:if>
		<!-- <xsl:call-template name="insert-subject"/> -->
		<table cellpadding="0" cellspacing="0" border="0">
			<xsl:attribute name="width">
			<xsl:choose>
			<xsl:when test="/H2G2/PARAMS/PARAM[NAME= 's_print']/VALUE = 1">550</xsl:when>
			<xsl:otherwise>635</xsl:otherwise>
			</xsl:choose>
			</xsl:attribute>
			<tr>
				<td>
					<xsl:attribute name="class">
						<xsl:choose>
						<xsl:when test="/H2G2/PARAMS/PARAM[NAME= 's_print']/VALUE = 1">printbody</xsl:when>
						<xsl:when test="$current_article_type=53">mainbody</xsl:when>
						<xsl:otherwise>mainbody</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
				<div>
						<xsl:attribute name="class">
						<xsl:choose>
						<xsl:when test="$current_article_type=53"></xsl:when>
						<xsl:otherwise>maincolumn</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
				<xsl:if test="not(/H2G2/PARAMS/PARAM[NAME= 's_print']/VALUE = 1)">	
				<xsl:call-template name="TABNAVIGATIONBOX" />
				</xsl:if>
				<xsl:call-template name="insert-mainbody"/>
				</div>
				</td>
			</tr>
			<tr>
				<td><br/>
				<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
				<xsl:copy-of select="$m_complainttext"/>
				</xsl:element>
				</td>
			</tr>
		</table>
		<xsl:if test="$VARIABLETEST=1"><xsl:call-template name="VARIABLEDUMP"/></xsl:if>	
		<xsl:if test="$TESTING=1 and not(/H2G2/PARAMS/PARAM[NAME= 's_print']/VALUE = 1)">
		<div class="editbox"><xsl:call-template name="ERRORFORM" /></div>
		</xsl:if>		
	</xsl:template>
	<!--===============Body Content Template (Global Content Stuff)=====================-->
	<!--===============Popup Template (Popup page Stuff)=====================-->
	<xsl:template name="popup-template">
	<html>
	<xsl:call-template name="insert-header"/>
	<body bgcolor="#ffffff" text="#000000" link="#000099" vlink="#ff0000" alink="#ff0000" marginheight="0" marginwidth="0" topmargin="0" leftmargin="0">

	<xsl:if test="/H2G2/PARAMS/PARAM[NAME= 's_print']/VALUE = 1">
	<div class="printheader">
	<table width="550" border="0" cellspacing="0" cellpadding="0">
	<tr>
	<td><img src="{$graphics}logo_getwriting.gif" width="151" height="47" alt="Get Writing"/></td>
	<td align="right"><img src="{$graphics}logo_bbc.gif" width="70" height="24" alt="BBC"/></td>
	</tr>
	</table>
	</div>
	</xsl:if>
	
	<xsl:call-template name="insert-mainbody"/>
	
	<xsl:if test="/H2G2/PARAMS/PARAM[NAME= 's_print']/VALUE = 1">
	<div class="printheader">
	<table width="550" border="0" cellspacing="0" cellpadding="0">
	<tr>
	<td></td>
	<td align="right"><img src="{$graphics}logo_bbc.gif" width="70" height="24" alt="BBC"/></td>
	</tr>
	</table>
	</div>
	</xsl:if>
	
	</body>
	</html>
	</xsl:template>
	

	
	<!--===============Popup Template (Popup page Stuff)=====================-->
	<!--===============Global Alpha Index=====================-->
	
		<!--
	<xsl:template name="alphaindex">
	Author:		Thomas Whitehouse
	Purpose:		Creates the alpha index
	-->
	<xsl:template name="alphaindex">
		<xsl:param name="type" />
		<xsl:param name="showtype" />
		<xsl:param name="imgtype" />
		<!-- switch this to the above methodology for XSLT 2.0 where its possible to use with-param with apply-imports -->
		<xsl:variable name="alphabet">
			<!-- <letter>*</letter> -->
			<letter>a</letter>
			<letter>b</letter>
			<letter>c</letter>
			<letter>d</letter>
			<letter>e</letter>
			<letter>f</letter>
			<letter>g</letter>
			<letter>h</letter>
			<letter>i</letter>
			<letter>j</letter>
			<letter>k</letter>
			<letter>l</letter>
			<letter>m</letter>
			<letter>n</letter>
			<letter>o</letter>
			<letter>p</letter>
			<letter>q</letter>
			<letter>r</letter>
			<letter>s</letter>
			<letter>t</letter>
			<letter>u</letter>
			<letter>v</letter>
			<letter>w</letter>
			<letter>x</letter>
			<letter>y</letter>
			<letter>z</letter>
		</xsl:variable>
		
		<xsl:for-each select="msxsl:node-set($alphabet)/letter">
			<xsl:apply-templates select="." mode="alpha">
			<xsl:with-param name="type" select="$type" />
			<xsl:with-param name="showtype" select="$showtype" />
			<xsl:with-param name="imgtype" select="$imgtype" />
			</xsl:apply-templates>
		</xsl:for-each>
	</xsl:template>
	<!--
	<xsl:template match="letter" mode="alpha">
	Author:		Thomas Whitehouse
	Purpose:	Creates each of the letter links
	-->
	<xsl:template match="letter" mode="alpha">
	<xsl:param name="imgtype" />
	<xsl:param name="type" />
	<xsl:param name="showtype" />
	<a xsl:use-attribute-sets="nalphaindex" href="{$root}Index?submit=new{$showtype}&amp;let={.}{$type}">
	<xsl:choose>
	<xsl:when test="$imgtype='small'">
	<img src="{$graphics}icons/az/small/small_{.}.gif" height="20" alt="" border="0" />
	</xsl:when>
	<xsl:otherwise>
	<img src="{$graphics}icons/az/{.}.gif"  height="26" alt="" border="0" />
	<xsl:if test=".= 'm'">
			<BR/>
		</xsl:if>
	</xsl:otherwise>
	</xsl:choose>
	</a>
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
	<!--===============End Global Alpha Index=====================-->
	
	<!-- TRACE/DEBUG -->
	<xsl:template name="TRACE">
	<xsl:param name="message" />
	<xsl:param name="pagename" />
	<xsl:if test="$DEBUG = 1">
	<div class="debug">
	Template name: <b><xsl:value-of select="$message" /></b>	<br />
	Stylesheet name: <b><xsl:value-of select="$pagename" /></b>
	</div>
	</xsl:if> 
	</xsl:template>

	<!-- TRACE/DEBUG : VARIABLE -->
	<xsl:template name="VARIABLEDUMP">

	<div class="debug">
	
		<div class="text">Current type number is: 
		<b><xsl:value-of select="$current_article_type" /></b></div>
		<div class="text">PREPROCESSED NUMBER: <br/>
		<b><xsl:value-of select="/H2G2/ARTICLE/ARTICLEINFO/PREPROCESSED" /></b></div>
		<div class="text">article_type_group is: 
		<b><xsl:value-of select="$article_type_group" /></b></div>
		<div class="text">article_type_user is: 
		<b><xsl:value-of select="$article_type_user" /></b></div>
		<div class="text">edit preview mode is: 
		<b><xsl:value-of select="/H2G2/MULTI-STAGE/@TYPE" /></b></div>
		<div class="text">Stage is: 
		<b><xsl:value-of select="/H2G2/MULTI-STAGE/@STAGE" /></b></div>
		<div class="text">Status is: 
		<b><xsl:value-of select="/H2G2/MULTI-STAGE/MULTI-REQUIRED[@NAME='STATUS']/VALUE-EDITABLE" /></b></div>
		
		<xsl:if test="$test_IsEditor">YOU ARE AN EDITOR</xsl:if>
	
	</div>
	</xsl:template>
	
	<!--
	<xsl:template name="article_subtype">
	Description: Presentation of the subtypes in search, index, category and userpage lists
	 -->
	<xsl:template name="article_subtype">
	<xsl:param name="num" select="EXTRAINFO/TYPE/@ID"/>
	<xsl:param name="status"/>
	<xsl:param name="pagetype"/>
	<xsl:param name="searchtypenum" />
	
	<!-- match with lookup table type.xsl -->	
	<!-- subtype label -->
	<xsl:variable name="label">
	<xsl:value-of select="msxsl:node-set($type)/type[@number=$num or @selectnumber=$num]/@label" />
	</xsl:variable>
	
	<!-- user type - member or editor -->
	<xsl:variable name="usertype">
	<xsl:value-of select="msxsl:node-set($type)/type[@number=$num or @selectnumber=$num]/@user" />
	</xsl:variable>
	
	<xsl:choose>
	<xsl:when test="$num=$searchtypenum">
	<xsl:if test="msxsl:node-set($type)/type[@selectnumber=$num]">selected</xsl:if>
	</xsl:when>
	<xsl:otherwise>
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	<div class="type"><xsl:value-of select="$label" /></div>
	</xsl:element>
	</xsl:otherwise> 
	</xsl:choose>
	</xsl:template>
	
	<xsl:template name="article_selected">
	<xsl:param name="num" select="EXTRAINFO/TYPE/@ID"/>
	<xsl:param name="status"/>
	<xsl:param name="pagetype"/>
	<xsl:param name="searchtypenum" />
	<xsl:param name="img" />
	
	<xsl:choose>
	<xsl:when test="msxsl:node-set($type)/type[@selectnumber=$num]">
	<img src="{$graphics}icons/icon_{$img}.gif" alt="Editor's Pick" width="100" height="30" border="0"/>
	</xsl:when>
	<xsl:otherwise>
		<xsl:choose>
		<xsl:when test="/H2G2/@TYPE='USERPAGE'"></xsl:when>
		<xsl:otherwise>
		<img src="/f/t.gif" width="1" height="30" border="0"/>
		</xsl:otherwise>
		</xsl:choose>
	</xsl:otherwise>
	</xsl:choose>

	
	</xsl:template>
	
	


	<!-- TRACE/DEBUG : ERROR INPUT FORM -->
	<xsl:template name="ERRORFORM">
	<div id="DEBUG">
	<h3>REPORT A BUG</h3>
		<form method="post" action="/cgi-bin/cgiemail/getwriting/includes/error_form.txt" name="debugform">
<input type="hidden" name="success" value="http://www.bbc.co.uk/getwriting/includes/thanks.shtml"/>
		<table cellpadding="10">
		<tr><td>From:</td><td><input type="text" name="from" /></td></tr>
		<tr><td>Subject:</td><td><input type="text" name="subject" /></td></tr>
		<tr><td>Error Class:</td><td><select name="class" size="4" multiple="multiple">
				<option></option>
				<option value="design">Design</option>
				<option value="functionality">Functionality</option>
				<option value="content">Content</option>
				</select></td></tr>
		<tr><td>Error description:</td><td><textarea cols="25" rows="8" name="description"></textarea></td></tr>
		<tr><td>URL</td><td><input type="text" name="url" value="" /></td></tr>
		<tr><td>DNA UID</td><td><input type="text" name="dnaid" value="{/H2G2/VIEWING-USER/USER/USERID}" /></td></tr>
		<tr><td>Browser O/S</td><td><input type="text" name="browseros" value="" /></td></tr>
		<tr><td>Date</td><td><input type="text" name="date" value="{/H2G2/DATE/@DAY} {/H2G2/DATE/@MONTHNAME} {/H2G2/DATE/@YEAR}" /></td></tr>
		<tr><td></td><td><input type="submit" name="submit" /></td></tr>
		</table>		
		<script type="text/javascript">
		document.debugform.browseros.value = navigator.appName + ', ' + navigator.appVersion + ', ' + navigator.platform;
		document.debugform.url.value = location.href;
		</script>
	</form>
	</div>

	</xsl:template>	

	<!-- POPUPCONVERSATIONS LINK -->
	<xsl:variable name="popupconvheight">340</xsl:variable>
	<xsl:variable name="popupconvwidth">277</xsl:variable>
	<xsl:template name="popupconversationslink">
		<xsl:param name="content" select="."/>
		<xsl:variable name="userid">
			<xsl:choose>
				<xsl:when test="@USERID">
					<xsl:value-of select="@USERID"/>
				</xsl:when>
				<xsl:when test="$registered=1">
					<xsl:value-of select="/H2G2/VIEWING-USER/USER/USERID"/>
				</xsl:when>
				<xsl:otherwise>0</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:if test="$userid > 0">
			<xsl:variable name="upto">
				<xsl:choose>
					<xsl:when test="@UPTO">
						<xsl:value-of select="@UPTO"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$curdate"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="target">
				<xsl:choose>
					<xsl:when test="@TARGET">
						<xsl:value-of select="@TARGET"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>conversation</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="width">
				<xsl:choose>
					<xsl:when test="$popupconvwidth">
						<xsl:value-of select="$popupconvwidth"/>
					</xsl:when>
					<xsl:when test="@WIDTH">
						<xsl:value-of select="@WIDTH"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>170</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="height">
				<xsl:choose>
					<xsl:when test="$popupconvheight">
						<xsl:value-of select="$popupconvheight"/>
					</xsl:when>
					<xsl:when test="@HEIGHT">
						<xsl:value-of select="@HEIGHT"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>400</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="poptarget">
				<xsl:choose>
					<xsl:when test="@POPTARGET">
						<xsl:value-of select="@POPTARGET"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>popupconv</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<a onClick="popupwindow('{$root}MP{$userid}?skip={@SKIPTO}&amp;show={@COUNT}&amp;s_type=pop&amp;s_upto={$upto}&amp;s_target={$target}&amp;s_allread=1','{$poptarget}','width={$width},height={$height},resizable=yes,scrollbars=yes');return false;" href="{$root}MP{$userid}?skip={@SKIPTO}&amp;show={@COUNT}&amp;s_type=pop&amp;s_upto={$upto}&amp;s_target={$target}&amp;s_allread=1" target="{$poptarget}">
				<xsl:copy-of select="$content"/>
			</a>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="DATE" mode="short">
		<xsl:value-of select="translate(@DAY, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz')"/>
		<xsl:text> </xsl:text>
		<xsl:value-of select="translate(substring(@MONTHNAME, 1, 3), 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz')"/>
		<xsl:text> </xsl:text>
		<xsl:value-of select="substring(@YEAR, 3, 4)"/>
	</xsl:template>
	
	<xsl:template match="DATE" mode="short1">
		<xsl:value-of select="@DAYNAME"/>&nbsp;<xsl:value-of select="@DAY"/>&nbsp;<xsl:value-of select="@MONTHNAME"/>&nbsp;<xsl:value-of select="@YEAR"/>
	</xsl:template>
	
	<xsl:template match="DATE" mode="short2">
		<xsl:value-of select="@DAY"/>&nbsp;<xsl:value-of select="@MONTHNAME"/>&nbsp;<xsl:value-of select="@YEAR"/>
	</xsl:template>
	
	<!-- breaks long links -->
	
	<!-- LONG LINKS BREAK-->
	<xsl:template match="*" mode="long_link">
	
	<xsl:choose>
	<xsl:when test="starts-with(.,'http://')">
	<xsl:value-of select="substring(./text(),1,45)" />...
	</xsl:when>
	<xsl:otherwise>
	<xsl:value-of select="./text()" />
	</xsl:otherwise>
	</xsl:choose>
	
	</xsl:template>
	
		
	<!-- DEBUG toggles -->
	<xsl:variable name="DEBUG">0</xsl:variable>
	<xsl:variable name="VARIABLETEST">0</xsl:variable>
	<xsl:variable name="TESTING">0</xsl:variable>
	
</xsl:stylesheet>
