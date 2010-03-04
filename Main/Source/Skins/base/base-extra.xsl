<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<xsl:import href="base-pagetype.xsl"/>
	<xsl:include href="../admin/admin-failmessagepage.xsl"/>
	<!--<xsl:include href="../admin/admin-moderationemailpage.xsl"/>-->
	<!--<xsl:include href="../admin/admin-moderatormanagementpage.xsl"/>-->
	<!--xsl:include href="admin-openingschedulepage.xsl"/-->
	<!--<xsl:include href="../admin/admin-profanityadminpage.xsl"/>-->
	<xsl:include href="base-attributesets.xsl"/>
	<xsl:include href="base-guideml.xsl"/>
	<xsl:include href="basetext.xsl"/>
	<xsl:include href="site.xsl"/>
	<xsl:include href="lists.xsl"/>
	<xsl:include href="toolbar.xsl"/>
	<xsl:include href="attributesets.xsl"/>
	<xsl:include href="../admin/editorstools.xsl"/>
	<xsl:include href="sso.xsl"/>
  <xsl:output method="html" version="4.0" omit-xml-declaration="yes" standalone="yes" indent="yes"/>

	<!--***************************************************************************************************************************************************************-->
	<!--**********************************************************************Page Creation Templates***************************************************************-->
	<!--***************************************************************************************************************************************************************-->
	<!--===============Variable Settings=====================-->
	<xsl:variable name="bbcpage_bgcolor">ffffff</xsl:variable>
	<xsl:variable name="bbcpage_nav">yes</xsl:variable>
	<xsl:variable name="bbcpage_navwidth">110</xsl:variable>
	<xsl:variable name="bbcpage_navgraphic">no</xsl:variable>
	<xsl:variable name="bbcpage_navgutter">yes</xsl:variable>
	<xsl:variable name="bbcpage_contentwidth">100%</xsl:variable>
	<xsl:variable name="bbcpage_contentalign">left</xsl:variable>
	<xsl:variable name="bbcpage_language">english</xsl:variable>
	<xsl:variable name="bbcpage_searchcolour">00cc00</xsl:variable>
	<xsl:variable name="bbcpage_topleft_bgcolour"/>
	<xsl:variable name="bbcpage_topleft_linkcolour"/>
	<xsl:variable name="bbcpage_topleft_textcolour"/>
	<xsl:variable name="bbcpage_lang"/>
	<xsl:variable name="bbcpage_variant"/>
	<xsl:variable name="bbcpage_disabletracking">no</xsl:variable>
	<xsl:variable name="meta-tags"/>
	<!--===============Variable Settings=====================-->
	<!--===============Global Template (Header Stuff)=====================-->
	<xsl:template name="global-template">	
		
		<link type="text/css" rel="stylesheet" href="http://www.bbc.co.uk/dnaimages/boards/includes/login.css"/>
		<link type="text/css" rel="stylesheet" href="http://www.bbc.co.uk/dnaimages/boards/includes/login2.css"/>
		
		<xsl:comment>#set var="bbcpage_bgcolor" value="<xsl:value-of select="$bbcpage_bgcolor"/>" </xsl:comment>
		<xsl:comment>#set var="bbcpage_nav" value="<xsl:value-of select="$bbcpage_nav"/>" </xsl:comment>
		<xsl:comment>#set var="bbcpage_navwidth" value="<xsl:value-of select="$bbcpage_navwidth"/>" </xsl:comment>
		<xsl:comment>#set var="bbcpage_navgraphic" value="<xsl:value-of select="$bbcpage_navgraphic"/>" </xsl:comment>
		<xsl:comment>#set var="bbcpage_navgutter" value="<xsl:value-of select="$bbcpage_navgutter"/>" </xsl:comment>
		<xsl:comment>#set var="bbcpage_contentwidth" value="<xsl:value-of select="$bbcpage_contentwidth"/>" </xsl:comment>
		<xsl:comment>#set var="bbcpage_contentalign" value="<xsl:value-of select="$bbcpage_contentalign"/>" </xsl:comment>
		<xsl:comment>#set var="bbcpage_language" value="<xsl:value-of select="$bbcpage_language"/>" </xsl:comment>
		<xsl:comment>#set var="bbcpage_searchcolour" value="<xsl:value-of select="$bbcpage_searchcolour"/>" </xsl:comment>
		<xsl:if test="/H2G2/@TYPE = 'FRONTPAGE'">
			<xsl:choose>
				<xsl:when test="/H2G2/CURRENTSITEURLNAME = 'actionnetwork'">
				  <xsl:comment>#set var="bbcpage_survey" value="yes" </xsl:comment>
				  <xsl:comment>#set var="bbcpage_surveysite" value="actionnetwork" </xsl:comment>
        </xsl:when>
				<xsl:when test="/H2G2/CURRENTSITEURLNAME = 'filmnetwork'">
				  <xsl:comment>#set var="bbcpage_survey" value="yes" </xsl:comment>
				  <xsl:comment>#set var="bbcpage_surveysite" value="filmnetwork" </xsl:comment>
        </xsl:when>
				<xsl:when test="/H2G2/CURRENTSITEURLNAME = 'collective'">
				  <xsl:comment>#set var="bbcpage_survey" value="yes" </xsl:comment>
				  <xsl:comment>#set var="bbcpage_surveysite" value="collective" </xsl:comment>
        </xsl:when>
				<xsl:when test="/H2G2/CURRENTSITEURLNAME = 'comedysoup'">
				  <xsl:comment>#set var="bbcpage_survey" value="yes" </xsl:comment>
				  <xsl:comment>#set var="bbcpage_surveysite" value="comedysoup" </xsl:comment>
        </xsl:when>
				<xsl:otherwise><xsl:comment>#set var="bbcpage_survey" value="no" </xsl:comment></xsl:otherwise>
			</xsl:choose>			
		</xsl:if>
		<style type="text/css">
			body {margin:0;} form {margin:0;padding:0;} .bbcpageShadow {background-color:#828282;} .bbcpageShadowLeft {border-left:2px solid #828282;} .bbcpageBar {background:#999999 url(/images/v.gif) repeat-y;} .bbcpageSearchL {background:#<xsl:value-of select="$bbcpage_searchcolour"/> url(/images/sl.gif) no-repeat;} .bbcpageSearch {background:#<xsl:value-of select="$bbcpage_searchcolour"/> url(/images/st.gif) repeat-x;} .bbcpageSearch2 {background:#<xsl:value-of select="$bbcpage_searchcolour"/> url(/images/st.gif) repeat-x 0 0;} .bbcpageSearchRa {background:#999999 url(/images/sra.gif) no-repeat;} .bbcpageSearchRb {background:#999999 url(/images/srb.gif) no-repeat;} .bbcpageBlack {background-color:#000000;} .bbcpageGrey, .bbcpageShadowLeft {background-color:#999999;} .bbcpageWhite,font.bbcpageWhite,a.bbcpageWhite,a.bbcpageWhite:link,a.bbcpageWhite:hover,a.bbcpageWhite:visited {color:#ffffff;text-decoration:none;font-family:verdana,arial,helvetica,sans-serif;padding:1px 4px;}
				<xsl:if test="$bbcpage_topleft_bgcolour and $bbcpage_topleft_linkcolour and $bbcpage_topleft_textcolour"> .bbcpageTopleftlink,a.bbcpageTopleftlink,a:link.bbcpageTopleftlink,a:hover.bbcpageTopleftlink,a:visited.bbcpageTopleftlink {background:#<xsl:value-of select="$bbcpage_topleft_bgcolour"/>;color:#<xsl:value-of select="$bbcpage_topleft_linkcolour"/>;text-decoration:underline;} .bbcpageToplefttd {background:#<xsl:value-of select="$bbcpage_topleft_bgcolour"/>;color:#<xsl:value-of select="$bbcpage_topleft_textcolour"/>;} </xsl:if>	
		</style>
		<xsl:if test="/H2G2/@TYPE = 'FRONTPAGE'">
			<xsl:comment>#if expr="$bbcpage_survey = yes &amp;&amp; $HTTP_COOKIE = /BBC-UID=/"</xsl:comment>
				<xsl:comment>#include virtual="/includes/blq/include/pulse/core.sssi" </xsl:comment>
				<xsl:comment>#if expr="$pulse_go = 1"</xsl:comment>
			
					<xsl:comment>#include virtual="/includes/blq/include/pulse/bbcpage.sssi" </xsl:comment>
				<xsl:comment>#endif </xsl:comment>
			<xsl:comment>#endif </xsl:comment>
		</xsl:if>	
		<xsl:if test="/H2G2/@TYPE = 'SITEOPTIONS'"> 
			<link type="text/css" rel="stylesheet" href="http://www.bbc.co.uk/dnaimages/boards/includes/admin.css"/>
		</xsl:if>
		
		<xsl:choose>
			<xsl:when test="/H2G2/CURRENTSITE = 67 or /H2G2/SITE/@ID = 67">
				<xsl:comment><![CDATA[[if IE]><![if gte IE 6]><![endif]]]></xsl:comment><!--[if IE]><![if gte IE 6]><![endif]--><style type="text/css">
					@import '/dnaimages/bbcpage/v3-0/toolbar.xhtml-transitional.css';
				</style><!--[if IE]><![endif]><![endif]--><xsl:comment><![CDATA[[if IE]><![endif]><![endif]]]></xsl:comment>
						
				<xsl:comment><![CDATA[[if IE 7]><style type="text/css" media="screen">#bbcpageExplore a {height:18px;}</style><![endif]]]></xsl:comment>
			</xsl:when>
			<xsl:otherwise>
				<xsl:comment><![CDATA[[if IE]><![if gte IE 6]><![endif]]]></xsl:comment><!--[if IE]><![if gte IE 6]><![endif]--><style type="text/css">
					@import '/includes/bbcpage/v3-0/toolbar.css';
				
					body #toolbarContainer a {font:75% verdana,helvetica,arial,sans-serif;}
				</style><!--[if IE]><![endif]><![endif]--><xsl:comment><![CDATA[[if IE]><![endif]><![endif]]]></xsl:comment>
						
				<xsl:comment><![CDATA[[if gte IE 6]><style type="text/css" media="screen">#bbcpageExplore a {height:22px;}</style><![endif]]]></xsl:comment>
			</xsl:otherwise>
		</xsl:choose>
		
		
		<!--
			RH - These are ugly but I've not got time to wait for non existant CSDs on the
			     DNA customer side.
			     
			     roll on Barlesque & PAL.
		-->
		
		<!-- fix some global css on filmnetwork -->
		<xsl:if test="/H2G2/CURRENTSITE = 20">
			<style type="text/css">
				body #toolbarContainer p {margin:0;}
			</style>
		</xsl:if>
		
		<!-- collective's base.css messes up the font on the search button -->			
		<xsl:if test="/H2G2/CURRENTSITE = 9">
			<style type="text/css">
				body #toolbarContainer input {font-family:arial,sans-serif; font-size:84%;}
			</style>
		</xsl:if>
		
		<!-- messageboards fontsizing is out -->
		<xsl:if test="/H2G2/SITECONFIG/BOARDNAME != ''">
			<style type="text/css">
				body #toolbarContainer a {font-size:91%}
			</style>
		</xsl:if>
		
	</xsl:template>
	<!--===============Global Template (Header Stuff)=====================-->
	<!--===============Toolbar Template (Toolbar Stuff)=====================-->
	<xsl:template name="toolbar-template">
		<xsl:choose>
			<xsl:when test="$bbcpage_variant = 'international'">
				<table border="0" cellpadding="0" cellspacing="0" width="100%">
					<tr bgcolor="#003399" valign="top">
						<td width="558">
							<img src="http://www.bbc.co.uk/worldservice/images/furniture/bbc_bar.gif" width="558" height="33" border="0" alt="" usemap="#GlobalNavigationMap"/>
						</td>
						<td valign="top" bgcolor="#003399" width="201">
							<img src="http://www.bbc.co.uk/worldservice/images/furniture/bbc_bar_2.gif" alt="" width="201" height="6" align="top" border="0"/>
							<br/>
							<form action="/cgi-bin/search/results.pl" method="get" id="searchbox">
								<table width="201" border="0" cellpadding="0" cellspacing="0">
									<tr valign="top" bgcolor="#003399">
										<td valign="top">
											<img src="http://www.bbc.co.uk/worldservice/images/furniture/clear.gif" width="5" height="6" border="0" alt=""/>
										</td>
										<td valign="top">
											<img src="http://www.bbc.co.uk/worldservice/images/furniture/clear.gif" width="1" height="4" border="0" alt=""/>
											<br/>
											<input type="text" name="q" size="9" class="wsnav" style="width:126px;height:19px;"/>
										</td>
										<td valign="top">
											<img src="http://www.bbc.co.uk/worldservice/images/furniture/clear.gif" width="5" height="6" border="0" alt=""/>
										</td>
										<td valign="top">
											<img src="http://www.bbc.co.uk/worldservice/images/furniture/clear.gif" width="1" height="5" border="0" alt=""/>
											<br/>
											<input type="hidden" name="uri" value="/worldservice/"/>
											<input type="image" src="http://www.bbc.co.uk/worldservice/images/furniture/toolbar_search.gif" width="58" height="19" border="0" alt="Go"/>&nbsp;</td>
									</tr>
								</table>
							</form>
						</td>
						<td valign="top" bgcolor="#FFFFFF" width="2" align="left">
							<img src="http://www.bbc.co.uk/worldservice/images/furniture/bbc_bar_3.gif" alt="" width="2" height="36" border="0"/>
						</td>
						<td bgcolor="#FFFFFF" width="100%" style="BACKGROUND: url(http://www.bbc.co.uk/worldservice/images/furniture/bbc_bar_toppix1.gif) #FFFFFF repeat-x;">
							<img src="http://www.bbc.co.uk/worldservice/images/furniture/clear.gif" width="1" height="1" border="0" alt=""/>
						</td>
					</tr>
				</table>
				<map name="GlobalNavigationMap" id="GlobalNavigationMap">
					<area shape="rect" coords="239,2,279,32" href="http://news.bbc.co.uk/2/hi/default.stm" alt="BBC World News"/>
					<area shape="rect" coords="281,2,323,32" href="http://news.bbc.co.uk/sport2/hi/default.stm" alt="BBC Sport"/>
					<area shape="rect" coords="325,2,388,32" href="http://www.bbc.co.uk/weather/world/index.shtml" alt="BBC World Weather"/>
					<area shape="rect" coords="390,2,480,32" href="http://www.bbc.co.uk/worldservice/" alt="BBC World Service"/>
					<area shape="rect" coords="482,2,556,32" href="http://www.bbc.co.uk/worldservice/us/languages.shtml" alt="BBC Worldservice Languages"/>
					<area shape="rect" coords="10,10,50,22" href="http://www.bbc.co.uk/" alt="BBC Homepage"/>
				</map>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="/H2G2/CURRENTSITE = 67 or /H2G2/SITE/@ID = 67">
						<ul class="bbcpageHide">
							<li><a href="#startcontent" accesskey="2">Skip to main content</a></li>
							<li><a href="/cgi-bin/education/betsie/parser.pl">Text Only version of this page</a></li>
							<li><a href="/accessibility/accesskeys/keys.shtml" accesskey="0">Access keys help</a></li>
						</ul>
						<div id="toolbarContainer" class="bbcpageblue">
							<p>
								<a accesskey="1" href="http://www.bbc.co.uk/go/toolbar/-/home/d/"><img width="77" vspace="0" hspace="2" height="22" border="0" alt="BBC" src="/images/bbcpage/v3-0/bbc.gif"/> Home</a>
							</p>
							
							<form accept-charset="utf-8" action="http://www.bbc.co.uk/cgi-bin/search/results.pl" method="get">
								<p>
									<input type="hidden" value="/barleytest/" name="uri"/>
									<input type="text" accesskey="4" title="BBC Search" name="q" id="bbcpageSearch"/>
									<input type="submit" id="bbcpageSearchButton" value="Search" name="Search"/>
								</p>
							</form>
							
							
							<p id="bbcpageExplore">
								<a href="/go/toolbar/-/a-z/">Explore the BBC</a>
							</p>
						</div>
					</xsl:when>
					<xsl:otherwise>
						<ul class="bbcpageHide">
							<li><a href="#startcontent" accesskey="2">Skip to main content</a></li>
							<li><a href="/cgi-bin/education/betsie/parser.pl">Text Only version of this page</a></li>
							<li><a href="/accessibility/accesskeys/keys.shtml" accesskey="0">Access keys help</a></li>
						</ul>
						
						<div id="toolbarContainer">
							<table id="bbcpageToolbarTable" width="100%" cellpadding="0" cellspacing="0" border="0" lang="en">
								<tr valign="middle">
									
									<td width="200" id="bbcpageBlocks"><p><a href="http://www.bbc.co.uk/go/toolbar/-/home/d/" accesskey="1"><img src="/images/bbcpage/v3-0/bbc.gif" width="77" height="22" alt="BBC" border="0" hspace="2" vspace="0" /> Home</a></p></td>
									
									<form method="get" action="http://www.bbc.co.uk/cgi-bin/search/results.pl" accept-charset="utf-8">
										<td width="295" align="right">
											
											<xsl:if test="$bbcpage_variant = 'kids' or $bbcpage_variant = 'cbbc'">
												<input type="hidden" name="scope" value="cbbc" />
											</xsl:if>
											
											<input type="hidden" name="uri">
												<xsl:attribute name="value">
													<xsl:text disable-output-escaping="yes">&lt;!--#echo var='REQUEST_URI'--></xsl:text>
												</xsl:attribute>
											</input>
												
											<input type="text" id="bbcpageSearch" name="q" title="BBC Search" accesskey="4" />
										</td>
										
										<td width="105">
											<input type="submit" name="Search" value="Search" id="bbcpageSearchButton" /><input type="hidden" name="uri" value="/{$scopename}/"/>
										</td>
									</form>
									
									<td width="170" align="right" class="bbcpageblue">
										<p id="bbcpageExplore">
											
											<a href="#">
												<xsl:attribute name="href">
													<xsl:text>/go/toolbar/-/</xsl:text>
													<xsl:choose>
														<xsl:when test="$bbcpage_variant = 'schools'">
															<xsl:text>schools/a-z</xsl:text>
														</xsl:when>
														<xsl:when test="$bbcpage_variant = 'kids'">
															<xsl:text>cbbc/a-z</xsl:text>
														</xsl:when>
														<xsl:when test="$bbcpage_variant = 'cbeebies'">
															<xsl:text>cbeebies/a-z</xsl:text>
														</xsl:when>
														<xsl:otherwise>
															<xsl:text>a-z</xsl:text>
														</xsl:otherwise>
													</xsl:choose>
												</xsl:attribute>
												<xsl:text>Explore the BBC</xsl:text>
											</a>
										</p>
									</td>
								</tr>
							</table>
						</div>
					</xsl:otherwise>
				</xsl:choose>
				<!-- toolbar 1.42 header.page -->
				<!--
				<table width="100%" cellpadding="0" cellspacing="0" border="0" lang="en">
					<tr>
						<td class="bbcpageShadow" colspan="2">
							<a href="#startcontent" accesskey="2">
								<img src="/f/t.gif" width="590" height="2" alt="Skip to main content" title="" border="0"/>
							</a>
						</td>
						<td class="bbcpageShadow">
							<a href="/cgi-bin/education/betsie/parser.pl">
								<img src="/f/t.gif" width="1" height="1" alt="Text Only version of this page" title="" border="0"/>
							</a>
							<br/>
							<a href="/accessibility/accesskeys/keys.shtml" accesskey="0">
								<img src="/f/t.gif" width="1" height="1" alt="Access keys help" title="" border="0"/>
							</a>
						</td>
					</tr>
					<form action="http://www.bbc.co.uk/cgi-bin/search/results.pl">
						<tr>
							<td class="bbcpageShadowLeft" width="94">
								<a href="http://www.bbc.co.uk/go/toolbar/-/home/d/" accesskey="1">
									<img src="/images/logo042.gif" width="90" height="30" alt="bbc.co.uk" border="0" hspace="2" vspace="0"/>
								</a>
							</td>
							<td class="bbcpageGrey" align="right">
								<table cellpadding="0" cellspacing="0" border="0" style="float:right">
									<tr>
										<td>
											<font size="1">
												<b>
													<a href="http://www.bbc.co.uk/go/toolbar/text/-/home/d/" class="bbcpageWhite">Home</a>
												</b>
											</font>
										</td>
										<td class="bbcpageBar" width="6">
											<br/>
										</td>
										<xsl:choose>
											<xsl:when test="$bbcpage_variant = 'schools'">
												<td>
													<font size="1">
														<b>
															<a href="http://www.bbc.co.uk/go/toolbar/-/tv/d/" class="bbcpageWhite">TV</a>
														</b>
													</font>
												</td>
												<td class="bbcpageBar" width="6">
													<br/>
												</td>
												<td>
													<font size="1">
														<b>
															<a href="http://www.bbc.co.uk/go/toolbar/-/radio/d/" class="bbcpageWhite">Radio</a>
														</b>
													</font>
												</td>
												<td class="bbcpageBar" width="6">
													<br/>
												</td>
												<td>
													<font size="1">
														<b>
															<a href="/go/toolbar/-/schools/communities/communicate/" class="bbcpageWhite">Talk</a>
														</b>
													</font>
												</td>
												<td class="bbcpageBar" width="6">
													<br/>
												</td>
												<td>
													<font size="1">
														<b>
															<a href="/go/toolbar/-/schools/" class="bbcpageWhite">Schools</a>
														</b>
													</font>
												</td>
												<td class="bbcpageBar" width="6">
													<br/>
												</td>
												<td>
													<font size="1">
														<b>
															<a href="/go/toolbar/-/schools/a-z/" class="bbcpageWhite" accesskey="3">A-Z&nbsp;Index</a>
														</b>
													</font>
												</td>
											</xsl:when>
											<xsl:when test="$bbcpage_variant = 'kids'">
												<td>
													<font size="1">
														<b>
															<a href="http://www.bbc.co.uk/go/toolbar/-/tv/d/" class="bbcpageWhite">TV</a>
														</b>
													</font>
												</td>
												<td class="bbcpageBar" width="6">
													<br/>
												</td>
												<td>
													<font size="1">
														<b>
															<a href="http://www.bbc.co.uk/go/toolbar/-/radio/d/" class="bbcpageWhite">Radio</a>
														</b>
													</font>
												</td>
												<td class="bbcpageBar" width="6">
													<br/>
												</td>
												<td>
													<font size="1">
														<b>
															<a href="/go/toolbar/-/cbbc/contact/messageboard.shtml" class="bbcpageWhite">Talk</a>
														</b>
													</font>
												</td>
												<td class="bbcpageBar" width="6">
													<br/>
												</td>
												<td>
													<font size="1">
														<b>
															<a href="/go/toolbar/-/whereilive/" class="bbcpageWhite">Where&nbsp;I&nbsp;Live</a>
														</b>
													</font>
												</td>
												<td class="bbcpageBar" width="6">
													<br/>
												</td>
												<td>
													<nobr>
														<font size="1">
															<b>
																<a href="/go/toolbar/-/cbbc/a-z/" class="bbcpageWhite" accesskey="3">A-Z&nbsp;Index</a>
															</b>
														</font>
													</nobr>
												</td>
											</xsl:when>
											<xsl:when test="$bbcpage_variant = 'cbeebies'">
												<td>
													<font size="1">
														<b>
															<a href="http://www.bbc.co.uk/go/toolbar/-/tv/d/" class="bbcpageWhite">TV</a>
														</b>
													</font>
												</td>
												<td class="bbcpageBar" width="6">
													<br/>
												</td>
												<td>
													<font size="1">
														<b>
															<a href="http://www.bbc.co.uk/go/toolbar/-/radio/d/" class="bbcpageWhite">Radio</a>
														</b>
													</font>
												</td>
												<td class="bbcpageBar" width="6">
													<br/>
												</td>
												<td>
													<font size="1">
														<b>
															<a href="/go/toolbar/-/cbeebies/grownups/" class="bbcpageWhite">Talk</a>
														</b>
													</font>
												</td>
												<td class="bbcpageBar" width="6">
													<br/>
												</td>
												<td>
													<font size="1">
														<b>
															<a href="/go/toolbar/-/whereilive/" class="bbcpageWhite">Where&nbsp;I&nbsp;Live</a>
														</b>
													</font>
												</td>
												<td class="bbcpageBar" width="6">
													<br/>
												</td>
												<td>
													<font size="1">
														<b>
															<a href="/go/toolbar/-/cbeebies/a-z/" class="bbcpageWhite" accesskey="3">A-Z&nbsp;Index</a>
														</b>
													</font>
												</td>
											</xsl:when>
											<xsl:otherwise>
												<td>
													<font size="1">
														<b>
															<a href="http://www.bbc.co.uk/go/toolbar/-/tv/d/" class="bbcpageWhite">TV</a>
														</b>
													</font>
												</td>
												<td class="bbcpageBar" width="6">
													<br/>
												</td>
												<td>
													<font size="1">
														<b>
															<a href="http://www.bbc.co.uk/go/toolbar/-/radio/d/" class="bbcpageWhite">Radio</a>
														</b>
													</font>
												</td>
												<td class="bbcpageBar" width="6">
													<br/>
												</td>
												<td>
													<font size="1">
														<b>
															<a href="/go/toolbar/-/talk/" class="bbcpageWhite">Talk</a>
														</b>
													</font>
												</td>
												<td class="bbcpageBar" width="6">
													<br/>
												</td>
												<td>
													<font size="1">
														<b>
															<a href="/go/toolbar/-/whereilive/" class="bbcpageWhite">Where&nbsp;I&nbsp;Live</a>
														</b>
													</font>
												</td>
												<td class="bbcpageBar" width="6">
													<br/>
												</td>
												<td>
													<font size="1">
														<b>
															<a href="/go/toolbar/-/a-z/" class="bbcpageWhite" accesskey="3">A-Z&nbsp;Index</a>
														</b>
													</font>
												</td>
											</xsl:otherwise>
										</xsl:choose>
										<td class="bbcpageSearchL" width="8">
											<br/>
										</td>
										<td class="bbcpageSearch2" width="100">
											<input type="text" id="bbcpageSearchbox" name="q" size="6" style="margin:3px 0 0;font-family:arial,helvetica,sans-serif;width:100px;" title="BBC Search" accesskey="4"/>
										</td>
										<td class="bbcpageSearch">
											<input type="image" src="/images/srchb2.gif" name="go" value="go" alt="Search" width="64" height="25" border="0"/>
										</td>
										<td class="bbcpageSearchRa" width="1">
											<img src="/f/t.gif" width="1" height="30" alt=""/>
										</td>
									</tr>
								</table>
							</td>
							<td class="bbcpageSearchRb">
								<img src="/f/t.gif" width="1" height="1" alt=""/>
								<input type="hidden" name="uri" value="/{$scopename}/"/>
							</td>
						</tr>
					</form>
					<tr>
						<xsl:choose>
							<xsl:when test="($bbcpage_contentwidth = '100%' or $bbcpage_contentwidth = 'centre')">
								<td class="bbcpageBlack" colspan="3">
									<img src="/f/t.gif" width="1" height="1" alt=""/>
								</td>
							</xsl:when>
							<xsl:otherwise>
								<td class="bbcpageBlack" colspan="2">
									<table cellpadding="0" cellspacing="0" border="0">
										<tr>
											<xsl:if test="$bbcpage_nav != 'no'">
												<td width="{$bbcpage_navwidth}">
													<img src="/f/t.gif" width="{$bbcpage_navwidth}" height="1" alt=""/>
												</td>
												<xsl:if test="$bbcpage_navgutter != 'no'">
													<td width="10">
														<img src="/f/t.gif" width="10" height="1" alt=""/>
													</td>
												</xsl:if>
											</xsl:if>
											<td id="bbcpageblackline" width="{$bbcpage_contentwidth}">
												<img src="/f/t.gif" width="{$bbcpage_contentwidth}" height="1" alt=""/>
											</td>
										</tr>
									</table>
								</td>
								<td class="bbcpageBlack" width="100%">
									<img src="/f/t.gif" width="1" height="1" alt=""/>
								</td>
							</xsl:otherwise>
						</xsl:choose>
					</tr>
				</table>
				-->
				<!-- end toolbar 1.42 -->
			</xsl:otherwise>
		</xsl:choose>
		<xsl:if test="/H2G2/@TYPE = 'FRONTPAGE'">
			<xsl:comment>#if expr='$bbcpage_survey_go = 1' </xsl:comment>
			<xsl:comment>#include virtual="/includes/survey_bar.sssi" </xsl:comment>
			<xsl:comment>#endif </xsl:comment>
		</xsl:if>
	</xsl:template>
	<!--===============Toolbar Template (Toolbar Stuff)=====================-->
	<!--===============Date Template (Todays Date Stuff)=====================-->
	<xsl:template name="date-template" match="DATE" mode="titlebar">
		<xsl:param name="append">
			<xsl:choose>
				<xsl:when test="@DAY=1 or @DAY=21 or @DAY=31">st</xsl:when>
				<xsl:when test="@DAY=2 or @DAY=22">nd</xsl:when>
				<xsl:when test="@DAY=3 or @DAY=23">rd</xsl:when>
				<xsl:otherwise>th</xsl:otherwise>
			</xsl:choose>
		</xsl:param>
		<!--xsl:if test="not($bbcpage_variant = 'radio' or $bbcpage_variant = 'music')">
			<xsl:value-of select="@DAYNAME"/>
			<br/>
		</xsl:if-->
		<xsl:value-of select="concat(number(@DAY), $append, ' ', @MONTHNAME, ' ', @YEAR)"/>
	</xsl:template>
	<xsl:template match="DATE" mode="dc">
    <xsl:value-of select="concat(@YEAR, '-', @MONTH, '-', @DAY, 'T', @HOURS, ':', @MINUTES, ':', @SECONDS)"/>
		<!--<xsl:value-of select="concat(@YEAR, '-', @MONTH, '-', @DAY)"/>-->
	</xsl:template>
	<!--===============Date Template (Todays Date Stuff)=====================-->
	<!--===============Navigation Template (Nav Stuff)=====================-->
	<xsl:template name="navigation-template">
		<tr>
			<td class="bbcpageCrumb" width="8">
				<img src="/f/t.gif" width="8" height="1" alt=""/>
			</td>
			<td class="bbcpageCrumb" width="{number($bbcpage_navwidth)-10}">
				<img src="/f/t.gif" width="{number($bbcpage_navwidth)-10}" height="1" alt=""/>
				<br clear="all"/>
				<font face="arial, helvetica,sans-serif" size="2">
					<xsl:if test="not($bbcpage_variant = 'radio' or $bbcpage_variant = 'music')">
						<a class="bbcpageCrumb" href="/" lang="en">BBC Homepage</a>
						<br/>
					</xsl:if>
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
					<td class="bbcpageLocal" colspan="3">
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
							<xsl:call-template name="local-content"/> &nbsp;</font>
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
							<!--a class="bbcpageServices" href="/info/">About the BBC</a>
							<br/>
							<br/-->
              <!--<xsl:choose>
                <xsl:when test="/H2G2[CURRENTSITEURLNAME='mbiplayer']">
                  <a class="bbcpageServices" href="/iplayer/feedback/form.shtml">Contact Us</a>
                </xsl:when>
                <xsl:otherwise>-->
                  <a class="bbcpageServices" href="/feedback/">Contact Us</a>
                <!--</xsl:otherwise>
              </xsl:choose>-->
							<br/>
							<br/>
							<!--a class="bbcpageServices" href="/help/">Help</a>
							<br/>
							<br/-->
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
	<!--===============Footer Template (Footer Stuff)=====================-->
	<xsl:template name="footer-template">
		<xsl:choose>
			<xsl:when test="$bbcpage_nav != 'no'">
				<table cellpadding="0" cellspacing="0" border="0" lang="en">
					<tr>
						<td class="bbcpageFooterMargin" width="{$bbcpage_navwidth}">
							<img src="/f/t.gif" width="{$bbcpage_navwidth}" height="1" alt=""/>
						</td>
						<xsl:if test="$bbcpage_navgutter != 'no'">
							<td class="bbcpageFooterGutter" width="10">
								<img src="/f/t.gif" width="10" height="1" alt=""/>
							</td>
						</xsl:if>
						<td class="bbcpageFooter" width="{$bbcpage_contentwidth}" align="center">
							<xsl:choose>
								<xsl:when test="($bbcpage_contentwidth = '100%')">
									<img src="/f/t.gif" width="1" height="1" alt=""/>
								</xsl:when>
								<xsl:otherwise>
									<img src="/f/t.gif" width="{$bbcpage_contentwidth}" height="1" alt=""/>
								</xsl:otherwise>
							</xsl:choose>
							<br/>
							<font face="arial, helvetica, sans-serif" size="1">
								<a class="bbcpageFooter" href="/info/">About the BBC</a> | <a class="bbcpageFooter" href="/help/">Help</a> | <a class="bbcpageFooter" href="/terms/">Terms of Use</a> | <a class="bbcpageFooter" href="/privacy/">Privacy &amp; Cookies Policy</a>
								<br/>&nbsp;</font>
							<!--xsl:choose>
							
								
								<xsl:when test="$bbcpage_lang = 'alba'">
									<font face="arial, helvetica, sans-serif" size="1">
										<a class="bbcpageFooter" href="/info/">Mun BhBC</a> | <a class="bbcpageFooter" href="/help/">Taic</a> | <a class="bbcpageFooter" href="/terms/">Terms of Use</a> | <a class="bbcpageFooter" href="/privacy/">Privacy &amp; Cookies Policy</a>
										<br/>&nbsp;</font>
								</xsl:when>
								<xsl:when test="$bbcpage_lang = 'cymru'">
									<font face="arial, helvetica, sans-serif" size="1">
										<a class="bbcpageFooter" href="/cymru/arolwg2001/">Arolwg 2001</a> | <a class="bbcpageFooter" href="/cymru/cymorth">Cymorth</a> | <a class="bbcpageFooter" href="/terms/">Terms of Use</a> | <a class="bbcpageFooter" href="/privacy/">Privacy &amp; Cookies Policy</a>
										<br/>&nbsp;</font>
								</xsl:when>
								<xsl:otherwise>
									<font face="arial, helvetica, sans-serif" size="1">
										<a class="bbcpageFooter" href="/info/">About the BBC</a> | <a class="bbcpageFooter" href="/help/">Help</a> | <a class="bbcpageFooter" href="/terms/">Terms of Use</a> | <a class="bbcpageFooter" href="/privacy/">Privacy &amp; Cookies Policy</a>
										<br/>&nbsp;</font>
								</xsl:otherwise>
							</xsl:choose-->
						</td>
					</tr>
				</table>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="$bbcpage_contentwidth = '770'">
						<table width="{$bbcpage_contentwidth}" cellpadding="0" cellspacing="0" border="0" style="margin:0px; float:left;" lang="en">
							<tr>
								<td class="bbcpageFooter" width="{$bbcpage_contentwidth}" align="center">
									<img src="/f/t.gif" width="{$bbcpage_contentwidth}" height="1" alt=""/>
									<br/>
									<font face="arial, helvetica, sans-serif" size="1">
										<a class="bbcpageFooter" href="/terms/">Terms of Use</a> | <a class="bbcpageFooter" href="/privacy/">Privacy &amp; Cookies Policy</a>
										<br/>&nbsp;</font>
								</td>
							</tr>
						</table>
					</xsl:when>
					<xsl:otherwise>
						<table width="{$bbcpage_contentwidth}" cellpadding="0" cellspacing="0" border="0" lang="en">
							<tr>
								<td class="bbcpageFooter" width="{$bbcpage_contentwidth}" align="center">
									<img src="/f/t.gif" width="1" height="1" alt=""/>
									<br/>
									<font face="arial, helvetica, sans-serif" size="1">
										<a class="bbcpageFooter" href="/terms/">Terms of Use</a> | <a class="bbcpageFooter" href="/privacy/">Privacy &amp; Cookies Policy</a>
										<br/>&nbsp;</font>
								</td>
							</tr>
						</table>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:if test="$bbcpage_disabletracking != 'yes'">
			<script src="http://www.bbc.co.uk/includes/linktrack.js" type="text/javascript">
				<xsl:text> </xsl:text>
			</script>
		</xsl:if>
		<!--
		<xsl:if test="/H2G2/@TYPE = 'FRONTPAGE'">
			<xsl:comment>#if expr="$bbcpage_survey_go = 1" </xsl:comment>
			<xsl:comment>#include virtual="/survey/survey.sssi" </xsl:comment>
			<xsl:comment>#endif </xsl:comment>
		</xsl:if>
			 -->
		<xsl:if test="/H2G2/@TYPE = 'FRONTPAGE'">
			<xsl:comment>#if expr="$pulse_go = 1" </xsl:comment>
			<font size="2">
				<xsl:comment>#include virtual="/includes/blq/include/pulse/panel.sssi"</xsl:comment>
			</font>
			<xsl:comment>#endif </xsl:comment>
		</xsl:if>
	</xsl:template>
	<!--===============Footer Template (Footer Stuff)=====================-->
	<!--===============Align Template (Content Align Stuff)=====================-->
	<xsl:template name="align-template">
		<xsl:choose>
			<xsl:when test="$bbcpage_contentalign = 'centre'">
				<div align="center">
					<xsl:apply-templates select="." mode="r_bodycontent"/>
				</div>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="." mode="r_bodycontent"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--===============Align Template (Content Align Stuff)=====================-->
	<!--===============Checking Template (Variable Checks)=====================-->
	<xsl:template match="H2G2" mode="c_bodycontent">
		<xsl:if test="(($bbcpage_contentwidth != '480') and ($bbcpage_contentwidth != '620') and ($bbcpage_contentwidth != '635') and ($bbcpage_contentwidth != '650') and ($bbcpage_contentwidth != '770') and ($bbcpage_contentwidth != '100%'))">
			<h1>Bad Content Width Specified</h1>
		</xsl:if>
		<xsl:if test="($bbcpage_nav = 'yes') and (($bbcpage_navwidth != '110') and ($bbcpage_navwidth != '125') and ($bbcpage_navwidth != '140'))">
			<h1>Bad Nav Width Specified</h1>
		</xsl:if>
		<xsl:if test="(($bbcpage_navwidth = '40') and ($bbcpage_contentwidth &gt; '620'))">
			<h1>Page Is Too Wide</h1>
		</xsl:if>
		<xsl:if test="(($bbcpage_navwidth = '125') and ($bbcpage_contentwidth &gt; '635'))">
			<h1>Page Is Too Wide</h1>
		</xsl:if>
		<xsl:if test="(($bbcpage_nav = 'no') and (($bbcpage_contentwidth != '770') and ($bbcpage_contentwidth != '100%')))">
			<h1>Content width must be 770 or 100%</h1>
		</xsl:if>
		<xsl:call-template name="layout-template"/>
	</xsl:template>
	<!--===============Checking Template (Variable Checks)=====================-->
	<!--===============Layout Template (Body Stuff)=====================-->
	<xsl:template name="layout-template">
		<xsl:if test="not(/H2G2/PARAMS/PARAM[NAME= 's_print']/VALUE = 1)">
			<a name="top" id="top"/>
			<xsl:call-template name="toolbar-template"/>
			<table cellspacing="0" cellpadding="0" border="0" width="100%">
				<tr>
					<xsl:if test="$bbcpage_nav != 'no'">
						<xsl:choose>
							<xsl:when test="($bbcpage_variant = 'radio') or ($bbcpage_variant = 'music') or ($bbcpage_variant = 'kids')">
								<td class="bbcpageToplefttd" width="{$bbcpage_navwidth}" valign="top">
									<table cellspacing="0" cellpadding="0" border="0">
										<tr>
											<td width="8">
												<img src="/f/t.gif" width="8" height="1" alt=""/>
											</td>
											<td width="{number($bbcpage_navwidth)-8}">
												<img src="/f/t.gif" width="{number($bbcpage_navwidth)-8}" height="1" alt=""/>
												<br clear="all"/>
												<font face="arial, helvetica, sans-serif" size="1" class="bbcpageToplefttd">
													<img src="/f/t.gif" width="1" height="6" alt=""/>
													<br clear="all"/>
													<!--xsl:apply-templates select="/H2G2/DATE" mode="titlebar"/>
													<br/-->
													<a class="bbcpageTopleftlink" style="text-decoration:underline;" href="/accessibility/">Accessibility help</a>
													<br/>
													<a class="bbcpageTopleftlink" style="text-decoration:underline;" href="/cgi-bin/education/betsie/parser.pl">Text only</a>
													<br/>
													<a href="/" class="bbcpageTopleftlink" style="text-decoration:underline;" lang="en">BBC Homepage</a>
													<br/>
													<xsl:choose>
														<xsl:when test="$bbcpage_variant = 'radio'">
															<a href="/radio/" class="bbcpageTopleftlink" style="text-decoration:underline;">BBC Radio</a>
														</xsl:when>
														<xsl:when test="$bbcpage_variant = 'music'">
															<a href="/music/" class="bbcpageTopleftlink" style="text-decoration:underline;">BBC Music</a>
														</xsl:when>
													</xsl:choose>
												</font>
											</td>
										</tr>
									</table>
								</td>
							</xsl:when>
							<xsl:otherwise>
								<td class="bbcpageToplefttd" width="{$bbcpage_navwidth}">
									<table cellspacing="0" cellpadding="0" border="0">
										<tr>
											<td width="8">
												<img src="/f/t.gif" width="8" height="1" alt=""/>
											</td>
											<td width="{number($bbcpage_navwidth)-8}">
												<img src="/f/t.gif" width="{number($bbcpage_navwidth)-8}" height="1" alt=""/>
												<br clear="all"/>
												<font face="arial, helvetica, sans-serif" size="1" class="bbcpageToplefttd">
													<xsl:apply-templates select="/H2G2/DATE" mode="titlebar"/>
													<br/>
													<a class="bbcpageTopleftlink" style="text-decoration:underline;" href="/accessibility/">Accessibility help</a>
													<br/>
													<a class="bbcpageTopleftlink" style="text-decoration:underline;" href="/cgi-bin/education/betsie/parser.pl">Text only</a>
												</font>
											</td>
										</tr>
									</table>
								</td>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
					<td valign="top">
						<xsl:copy-of select="$banner-content"/>
					</td>
				</tr>
			</table>
		</xsl:if>
		<xsl:choose>
			<xsl:when test="$bbcpage_nav = 'no' or /H2G2/PARAMS/PARAM[NAME= 's_print']/VALUE = 1">
				<xsl:choose>
					<xsl:when test="$bbcpage_contentwidth = '100%'">
						<table width="100%" cellpadding="0" cellspacing="0" border="0">
							<tr>
								<td valign="top" width="100%">
									<a name="startcontent" id="startcontent"/>
									<xsl:call-template name="align-template"/>
								</td>
							</tr>
						</table>
					</xsl:when>
					<xsl:otherwise>
						<table width="{$bbcpage_contentwidth}" cellspacing="0" cellpadding="0" border="0" style="margin:0px; float:left;">
							<tr>
								<td>
									<a name="startcontent" id="startcontent"/>
									<xsl:call-template name="align-template"/>
								</td>
							</tr>
						</table>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="$bbcpage_contentwidth = '100%'">
						<table width="100%" cellpadding="0" cellspacing="0" border="0">
							<tr>
								<td valign="top" width="{$bbcpage_navwidth}">
									<table cellspacing="0" cellpadding="0" border="0" width="100%">
										<xsl:call-template name="navigation-template"/>
									</table>
									<!-- swapped-->
								</td>
								<td valign="top" width="100%">
									<a name="startcontent" id="startcontent"/>
									<xsl:call-template name="align-template"/>
								</td>
							</tr>
						</table>
					</xsl:when>
					<xsl:otherwise>
						<table style="margin:0px;" cellspacing="0" cellpadding="0" border="0" align="left" width="{$bbcpage_navwidth}">
							<xsl:call-template name="navigation-template"/>
						</table>
						<table width="{$bbcpage_contentwidth}" cellspacing="0" cellpadding="0" border="0" style="margin:0px; float:left;">
							<tr>
								<td>
									<a name="startcontent" id="startcontent"/>
									<xsl:call-template name="align-template"/>
								</td>
							</tr>
						</table>
						<br clear="all"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:call-template name="footer-template"/>
		<br clear="all"/>
	</xsl:template>
	<!--===============Layout Template (Body Stuff)=====================-->
	<!--===============Banner Template (Banner Area Stuff)=====================-->
	<xsl:variable name="banner-content"> Banner Goes Here!! </xsl:variable>
	<!--===============Banner Template (Banner Area Stuff)=====================-->
	<!--===============Crumb Template (Crumb Navigation Stuff)=====================-->
	<xsl:variable name="crumb-content"> Crumbtrail Goes Here!! </xsl:variable>
	<!--===============Crumb Template (Crumb Navigation Stuff)=====================-->
	<!--===============Local Template (Local Navigation Stuff)=====================-->
	<xsl:template name="local-content">
		<font size="2">
			<xsl:apply-templates select="/H2G2" mode="c_register"/>
			<xsl:apply-templates select="/H2G2" mode="c_login"/>
			<xsl:apply-templates select="/H2G2" mode="c_userpage"/>
			<xsl:apply-templates select="/H2G2" mode="c_contribute"/>
			<xsl:apply-templates select="/H2G2" mode="c_preferences"/>
			<xsl:apply-templates select="/H2G2" mode="c_logout"/>
		</font>
	</xsl:template>
	<!--xsl:template match="H2G2" mode="r_register">
		<xsl:apply-imports/>
		<br/>
	</xsl:template>
	<xsl:template match="H2G2" mode="r_login">
		<xsl:apply-imports/>
		<br/>
	</xsl:template>
	<xsl:template match="H2G2" mode="r_userpage">
		<xsl:apply-imports/>
		<br/>
	</xsl:template>
	<xsl:template match="H2G2" mode="r_contribute">
		<xsl:apply-imports/>
		<br/>
	</xsl:template>
	<xsl:template match="H2G2" mode="r_preferences">
		<xsl:apply-imports/>
		<br/>
	</xsl:template>
	<xsl:template match="H2G2" mode="r_logout">
		<xsl:apply-imports/>
		<br/>
	</xsl:template-->
	<!--===============Local Template (Local Navigation Stuff)=====================-->
	<!--===============Primary Template (Page Stuff)=====================-->
	<xsl:template name="primary-template">
	<xsl:choose>
		<xsl:when test="/H2G2/@TYPE = 'SITEOPTIONS'">
				<html>
					<xsl:call-template name="insert-header"/>
					<body>
						<xsl:attribute name="id">adminBody</xsl:attribute>
						<div id="topNav">
							<div id="bbcLogo">
								<img src="http://www.bbc.co.uk/dnaimages/adminsystem/images/bbc_logo.gif" alt="BBC"/>
							</div>
							<h2>Message boards admin - <xsl:value-of select="/H2G2/SITECONFIG/BOARDNAME/node()"/>
							</h2>
						</div>
						<div style="width:770px;">
							<xsl:call-template name="sso_statusbar-admin"/>
						</div>
						<xsl:call-template name="insert-mainbody"/>
					</body>
				</html>
		</xsl:when>
		<xsl:otherwise>
		<html>
			<xsl:call-template name="insert-header"/>
			<body bgcolor="#ffffff" text="#000000" link="#000099" vlink="#ff0000" alink="#ff0000" marginheight="0" marginwidth="0" topmargin="0" leftmargin="0">
				<xsl:apply-templates select="/H2G2" mode="c_bodycontent"/>
			</body>
		</html>
		</xsl:otherwise>
	</xsl:choose>


	</xsl:template>
	<!--===============Primary Template (Page Stuff)=====================-->
	<!--===============Body Content Template (Global Content Stuff)=====================-->
	<xsl:template name="insert-bodycontent">
		<table width="100%" cellpadding="0" cellspacing="5" border="0">
			<tr>
				<td>
					<xsl:call-template name="insert-subject"/>
				</td>
			</tr>
			<tr>
				<td>
					<xsl:call-template name="insert-mainbody"/>
				</td>
			</tr>
		</table>
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
	<!--===============Subject Template (Global Subject Heading Stuff)=====================-->
	<xsl:template match="SUBJECT" mode="nosubject">
		<xsl:choose>
			<xsl:when test=".=''">
				<xsl:value-of select="$m_nosubject"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="."/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--===============Subject Template (Global Subject Heading Stuff)=====================-->
	<!--==================HEADER BASE TEMPLATE===================-->
	<xsl:template name="insert-header">
		<xsl:call-template name="type-check">
			<xsl:with-param name="content">HEADER</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template name="DEFAULT_HEADER">
		<xsl:apply-templates mode="header" select=".">
			<xsl:with-param name="title">
				<xsl:value-of select="$m_h2g2"/>
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>
	<xsl:template match="H2G2" mode="header">
		<xsl:param name="title">h2g2</xsl:param>
		<head>
			<title>
				<xsl:value-of select="$title"/>
			</title>
			<meta name="robots" content="{$robotsetting}"/>
			<xsl:copy-of select="$csslink"/>
			<xsl:copy-of select="$scriptlink"/>
			<xsl:if test="/H2G2/PREVIEWMODE=1 and $test_IsEditor">
				<script type="text/javascript">
					<xsl:comment><![CDATA[ 
		
	function previewmode()
	{
		// add a hidden preview element to all forms
		var flen = document.forms.length;
		for (i=0;i<flen;i++)
		{
			var f = document.forms[i];
			var newel = document.createElement('input');
			newel.setAttribute('type', 'hidden');
			newel.setAttribute('name', '_previewmode');
			newel.setAttribute('value', 1);	
			f.appendChild(newel);
		}

		// add the preview mode param to all dna links		
		var alen = document.links.length;
		for (i=0;i<alen;i++)
		{
			var l = document.links[i];
			var shref = l.href.toLowerCase();
			// check the link is a dna link
			if (shref.indexOf("/dna/") >= 0)
			{
				var iqm = l.href.indexOf("?");
				var iamp = l.href.lastIndexOf("&");
				
				if (iqm >= 0)
				{
					// we have a "?" so add the param immediately after it
					var s1 = l.href.substring(0,iqm+1);
					var s2 = l.href.substring(iqm+1);
					l.href = s1+"_previewmode=1&"+s2;
				}
				else
				{
					var ihash = l.href.lastIndexOf("#");
					if (ihash >= 0)
					{
						// there's no "?" but there is a "#", so add immediately before "#"
						var s1 = l.href.substring(0,ihash);
						var s2 = l.href.substring(ihash);
						l.href = s1+"?_previewmode=1"+s2;
					}
					else
					{
						// no "?" or "#", so add as the first param on the url
						l.href = l.href+"?_previewmode=1";
					}
				}
			}
		}
	}
 ]]></xsl:comment>
				</script>
			</xsl:if>
			<xsl:copy-of select="$meta-tags"/>
			<xsl:call-template name="global-template"/>
			<!--The following is used on the myconversationspopup-->
			<xsl:if test="/H2G2/@TYPE='MOREPOSTS' and /H2G2/PARAMS/PARAM[NAME='s_type']/VALUE='pop'">
				<xsl:variable name="target" select="/H2G2/PARAMS/PARAM[NAME='s_target']/VALUE"/>
				<xsl:variable name="skipparams">skip=<xsl:value-of select="/H2G2/POSTS/POST-LIST/@SKIPTO"/>&amp;show=<xsl:value-of select="/H2G2/POSTS/POST-LIST/@COUNT"/>&amp;</xsl:variable>
				<xsl:variable name="userid">
					<xsl:value-of select="/H2G2/POSTS/@USERID"/>
				</xsl:variable>
				<meta http-equiv="REFRESH">
					<xsl:attribute name="content">120;url=MP<xsl:value-of select="$userid"/>?<xsl:value-of select="$skipparams"/>s_type=pop<xsl:apply-templates select="/H2G2/PARAMS/PARAM[NAME='s_t']" mode="ThreadRead"/>&amp;s_target=<xsl:value-of select="$target"/></xsl:attribute>
				</meta>
			</xsl:if>
			<!--The above is used on the myconversationspopup-->			
		</head>
	</xsl:template>
	<xsl:variable name="csslink"/>
	<xsl:variable name="scriptlink"/>
	<!--==================HEADER BASE TEMPLATE===================-->
	<!--==================SUBJECT BASE TEMPLATE===================-->
	<xsl:template name="insert-subject">
		<xsl:call-template name="type-check">
			<xsl:with-param name="content">SUBJECT</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<!--==================SUBJECT BASE TEMPLATE===================-->
	<!--==================MAINBODY BASE TEMPLATE===================-->
	<xsl:template name="insert-mainbody">
		<xsl:call-template name="type-check">
			<xsl:with-param name="content">MAINBODY</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<!--==================MAINBODY BASE TEMPLATE===================-->
	<!--==================CSS BASE TEMPLATE===================-->
	<xsl:template name="insert-css">
		<xsl:call-template name="type-check">
			<xsl:with-param name="content">CSS</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<!--==================CSS BASE TEMPLATE===================-->
	<!--==================JAVASCRIPT BASE TEMPLATE===================-->
	<xsl:template name="insert-javascript">
		<xsl:call-template name="type-check">
			<xsl:with-param name="content">JAVASCRIPT</xsl:with-param>
		</xsl:call-template>
		<!--Mandatory Javascript goes here!-->
		<script type="text/javascript">
			<xsl:comment> function popmailwin(x, y) {window.open(x,y,'status=no,scrollbars=yes,resizable=yes,width=350,height=400');} </xsl:comment>
		</script>
	</xsl:template>
	<!--==================JAVASCRIPT BASE TEMPLATE===================-->
	<!--
	<xsl:template match="H2G2" mode="c_register">
	Author:		Andy Harris
	Purpose:		Calls the container for the register link
	-->
	<xsl:template match="H2G2" mode="c_register">
		<xsl:if test="not(VIEWING-USER/USER)">
			<xsl:apply-templates select="." mode="r_register"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="H2G2" mode="r_register">
	Author:		Andy Harris
	Purpose:		Creates the register link
	-->
	<xsl:template match="H2G2" mode="r_register">
		<a href="{$root}register">
			<xsl:copy-of select="$m_registernav"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="H2G2" mode="c_login">
	Author:		Andy Harris
	Purpose:		Calls the container for the login link
	-->
	<xsl:template match="H2G2" mode="c_login">
		<xsl:if test="not(VIEWING-USER/USER)">
			<xsl:apply-templates select="." mode="r_login"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="H2G2" mode="r_login">
	Author:		Andy Harris
	Purpose:		Creates the login link
	-->
	<xsl:template match="H2G2" mode="r_login">
		<a href="{$root}login">
			<xsl:copy-of select="$m_loginnav"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="H2G2" mode="c_userpage">
	Author:		Andy Harris
	Purpose:		Calls the container for the userpage link
	-->
	<xsl:template match="H2G2" mode="c_userpage">
		<xsl:if test="VIEWING-USER/USER">
			<xsl:apply-templates select="." mode="r_userpage"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="H2G2" mode="r_userpage">
	Author:		Andy Harris
	Purpose:		Creates the userpage link
	-->
	<xsl:template match="H2G2" mode="r_userpage">
		<a href="{$root}U{VIEWING-USER/USER/USERID}">
			<xsl:copy-of select="$m_userpagenav"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="H2G2" mode="c_contribute">
	Author:		Andy Harris
	Purpose:		Calls the container for the contribute link
	-->
	<xsl:template match="H2G2" mode="c_contribute">
		<xsl:apply-templates select="." mode="r_contribute"/>
	</xsl:template>
	<!--
	<xsl:template match="H2G2" mode="r_contribute">
	Author:		Andy Harris
	Purpose:		Creates the contribute link
	-->
	<xsl:template match="H2G2" mode="r_contribute">
		<a href="{$root}useredit">
			<xsl:copy-of select="$m_contributenav"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="H2G2" mode="c_preferences">
	Author:		Andy Harris
	Purpose:		Calls the container for the preferences link
	-->
	<xsl:template match="H2G2" mode="c_preferences">
		<xsl:if test="VIEWING-USER/USER">
			<xsl:apply-templates select="." mode="r_preferences"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="H2G2" mode="r_prerferences">
	Author:		Andy Harris
	Purpose:		Creates the preferences link
	-->
	<xsl:template match="H2G2" mode="r_preferences">
		<a href="{$root}UserDetails">
			<xsl:copy-of select="$m_preferencesnav"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="H2G2" mode="c_logout">
	Author:		Andy Harris
	Purpose:		Calls the container for the logout link
	-->
	<xsl:template match="H2G2" mode="c_logout">
		<xsl:if test="VIEWING-USER/USER">
			<xsl:apply-templates select="." mode="r_logout"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="H2G2" mode="r_logout">
	Author:		Andy Harris
	Purpose:		Creates the logout link
	-->
	<xsl:template match="H2G2" mode="r_logout">
		<a href="{$root}Logout">
			<xsl:copy-of select="$m_logoutnav"/>
		</a>
	</xsl:template>
	<!--***************************************************************************************************************************************************************-->
	<!--**********************************************************************Page Creation Templates***************************************************************-->
	<!--***************************************************************************************************************************************************************-->
	<!--***************************************************************************************************************************************************************-->
	<!--**********************************************************************Templates used across DNA***********************************************************-->
	<!--***************************************************************************************************************************************************************-->
	<!--
	<xsl:template match="/">
	Author:		Thomas Whitehouse
	Purpose:		Initialises the template matching
	-->
	<xsl:template match="/">
		<xsl:apply-templates select="H2G2"/>
	</xsl:template>
	<!--
	<xsl:template match="H2G2">
	Author:		Thomas Whitehouse
	Purpose:		Chooses the correct format of page
	-->
	<xsl:template match="H2G2">
		<xsl:choose>
			<xsl:when test="(@TYPE = 'USERS-HOMEPAGE') or (@TYPE = 'USER-DETAILS-PAGE') or (@TYPE = 'POST-MODERATION') or (@TYPE = 'MEDIAASSET-MODERATION') or (@TYPE = 'NICKNAME-MODERATION') or (@TYPE = 'MANAGE-FAST-MOD') or (@TYPE = 'DISTRESSMESSAGESADMIN') or (@TYPE = 'ARTICLE' and CURRENTSITEURLNAME = 'moderation') or (@TYPE = 'MODERATION-HISTORY') or (@TYPE='SITESUMMARY') or (@TYPE='MEMBERDETAILS') or (@TYPE='SITEMANAGER') or (@TYPE='LINKS-MODERATION')">
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
			<xsl:otherwise>
				<xsl:call-template name="primary-template"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- 
	Author: 	Rich Caudle
	Purpose:	Acts as catch-all requests for SSI feeds
	-->
	<xsl:template match="/H2G2[PARAMS/PARAM[NAME='s_ssi'][VALUE = 'ssi']]">
		<p>This feed is not currently implemented.</p>
	</xsl:template>
	<!--
	<xsl:template match="DATEPOSTED">
	Author:		Thomas Whitehouse
	Purpose:		Displays date
	-->
	<xsl:template match="DATEPOSTED">
		<xsl:apply-templates/>
	</xsl:template>
	<!--
	<xsl:template match="DATE">
	Author:		Thomas Whitehouse
	Purpose:		Displays date
	-->
	<xsl:template match="DATE">
		<xsl:choose>
			<xsl:when test="@RELATIVE">
				<xsl:value-of select="@RELATIVE"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="." mode="absolute"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="DATE" mode="absolute">
	Author:		Thomas Whitehouse
	Purpose:		Displays date in the absolute format
	-->
	<xsl:template match="DATE" mode="absolute">
		<xsl:value-of select="@DAYNAME"/>&nbsp; <xsl:value-of select="@DAY"/>&nbsp; <xsl:value-of select="@MONTHNAME"/>&nbsp; <xsl:value-of select="@YEAR"/>,&nbsp; <xsl:value-of select="@HOURS"/>:<xsl:value-of select="@MINUTES"/> GMT </xsl:template>
	<!--
	<xsl:template match="DATE" mode="shortened">
	Author:		Thomas Whitehouse
	Purpose:		Displays date in the shortened format
	-->
	<xsl:template match="DATE" mode="short">
		<nobr>
			<xsl:value-of select="@DAY"/>
			<xsl:value-of select="$m_ShortDateDelimiter"/>
			<xsl:value-of select="@MONTH"/>
			<xsl:value-of select="$m_ShortDateDelimiter"/>
			<xsl:value-of select="@YEAR"/>
		</nobr>
	</xsl:template>
	<!--
	<xsl:template name="DATE" mode="short1">
	Author:		Igor Loboda
	Purpose:		Displays date in the following format:28 March 2002
	-->
	<xsl:template match="DATE" mode="short1">
		<xsl:value-of select="@DAY"/> &nbsp; <xsl:value-of select="@MONTHNAME"/> &nbsp; <xsl:value-of select="@YEAR"/>
	</xsl:template>
	<!-- Search settings -->
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
	<xsl:attribute-set name="it_searchstring"/>
	<xsl:attribute-set name="it_submitsearch"/>
	<xsl:attribute-set name="fc_search_dna"/>
	<xsl:template name="t_searchstring">
		<input type="text" name="searchstring" xsl:use-attribute-sets="it_searchstring"/>
	</xsl:template>
	<xsl:template name="t_submitsearch">
		<input type="submit" name="dosearch" xsl:use-attribute-sets="it_submitsearch">
			<xsl:attribute name="value"><xsl:value-of select="$m_searchtheguide"/></xsl:attribute>
		</input>
	</xsl:template>
	<xsl:template name="c_search_dna">
		<form method="get" action="{$root}Search" xsl:use-attribute-sets="fc_search_dna">
			<xsl:call-template name="r_search_dna"/>
		</form>
	</xsl:template>
	<!--
	<xsl:template name="alphaindex">
	Author:		Thomas Whitehouse
	Purpose:		Creates the alpha index
	-->
	<xsl:template name="alphaindex">
		<!-- swith this to the above moethodology for XSLT 2.0 where its possible to use with-param with apply-imports -->
		<xsl:variable name="alphabet">
			<letter>*</letter>
			<letter>A</letter>
			<letter>B</letter>
			<letter>C</letter>
			<letter>D</letter>
			<letter>E</letter>
			<letter>F</letter>
			<letter>G</letter>
			<letter>H</letter>
			<letter>I</letter>
			<letter>J</letter>
			<letter>K</letter>
			<letter>L</letter>
			<letter>M</letter>
			<letter>N</letter>
			<letter>O</letter>
			<letter>P</letter>
			<letter>Q</letter>
			<letter>R</letter>
			<letter>S</letter>
			<letter>T</letter>
			<letter>U</letter>
			<letter>V</letter>
			<letter>W</letter>
			<letter>X</letter>
			<letter>Y</letter>
			<letter>Z</letter>
		</xsl:variable>
		<xsl:for-each select="msxsl:node-set($alphabet)/letter">
			<xsl:apply-templates select="." mode="alpha"/>
		</xsl:for-each>
	</xsl:template>
	<!--
	<xsl:template match="letter" mode="alpha">
	Author:		Thomas Whitehouse
	Purpose:		Creates each of the letter links
	-->
	<xsl:template match="letter" mode="alpha">
		<xsl:variable name="showtype">
			<xsl:apply-templates select="/H2G2/INDEX/@APPROVED"/>
			<xsl:apply-templates select="/H2G2/INDEX/@UNAPPROVED"/>
			<xsl:apply-templates select="/H2G2/INDEX/@SUBMITTED"/>
		</xsl:variable>
		<a xsl:use-attribute-sets="nalphaindex" href="{$root}Index?submit=new{$showtype}&amp;let={.}">
			<xsl:call-template name="alphaindexdisplay">
				<xsl:with-param name="letter" select="."/>
			</xsl:call-template>
		</a>
	</xsl:template>
	<!--
	<xsl:template name="alphaindexdisplay">
	Author:		Thomas Whitehouse
	Purpose:		Adds <br/> after M
	-->
	<xsl:template name="alphaindexdisplay">
		<xsl:param name="letter"/>
		<xsl:copy-of select="$letter"/>
		<xsl:choose>
			<xsl:when test="$letter = 'M'">
				<br/>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template name="href_u">
	Author:		Thomas Whitehouse
	Purpose:		Creates the Userid link 
	-->
	<xsl:template name="href_u">
		<xsl:value-of select="concat('U', USERID)"/>
	</xsl:template>
	<!--
	<xsl:template match="USER" mode="default">
	Author:		Thomas Whitehouse
	Purpose:		Creates the Userid link 
	-->
	<xsl:template match="USER" mode="default">
		<a href="{$root}U{USERID}" xsl:use-attribute-sets="mUSER_default">
			<xsl:apply-templates select="USERNAME"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="USER">
	Author:		Thomas Whitehouse
	Purpose:		Creates the Userid link 
	-->
	<xsl:template match="USER">
		<a href="{$root}U{USERID}" xsl:use-attribute-sets="mUSER_default">
			<xsl:apply-templates select="USERNAME"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="USER">
	Author:		Thomas Whitehouse
	Purpose:		Creates the USERNAME text
	-->
	<xsl:template match="USERNAME">
		<xsl:choose>
			<xsl:when test="text()">
				<xsl:value-of select="."/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy-of select="$m_unnameduser"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="BODY">
	Author:		Thomas Whitehouse
	Purpose:		Handles the BODY tag
	-->
	<xsl:template match="BODY">
		<xsl:apply-templates/>
	</xsl:template>
	<!--
	<xsl:template match="FORUMSOURCE" mode="article_forumsource">
	Author:		Thomas Whitehouse
	Purpose:		Creates the correct link and text used in the FORUMSOURCE title with an article source
	-->
	<xsl:template match="FORUMSOURCE" mode="article_forumsource">
		<a xsl:use-attribute-sets="mFORUMSOURCEARTICLE" href="{$root}A{ARTICLE/H2G2ID}" target="_top">
			<xsl:apply-templates mode="nosubject" select="ARTICLE/SUBJECT"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="FORUMSOURCE" mode="journal_forumsource">
	Author:		Thomas Whitehouse
	Purpose:		Creates the correct link and text used in the FORUMSOURCE title with a journal source
	-->
	<xsl:template match="FORUMSOURCE" mode="journal_forumsource">
		<a xsl:use-attribute-sets="mFORUMSOURCEJOURNAL" href="{$root}U{JOURNAL/USER/USERID}" target="_top">
			<!-- <xsl:value-of select="JOURNAL/USER/USERNAME"/> -->
			<xsl:apply-templates select="JOURNAL/USER" mode="username" />
		</a>
	</xsl:template>
	<!--
	<xsl:template match="FORUMSOURCE" mode="userpage_forumsource">
	Author:		Thomas Whitehouse
	Purpose:		Creates the correct link and text used in the FORUMSOURCE title with a userpage source
	-->
	<xsl:template match="FORUMSOURCE" mode="userpage_forumsource">
		<a xsl:use-attribute-sets="mFORUMSOURCEUSERPAGE" href="{$root}U{USERPAGE/USER/USERID}" target="_top">
			<!-- <xsl:value-of select="USERPAGE/USER/USERNAME"/> -->
			<xsl:apply-templates select="USERPAGE/USER" mode="username" />
		</a>
	</xsl:template>
	<!--
	<xsl:template match="FORUMSOURCE" mode="club_forumsource">
	Author:		Thomas Whitehouse
	Purpose:		Creates the correct link and text used in the FORUMSOURCE title with a club source
	-->
	<xsl:template match="FORUMSOURCE" mode="club_forumsource">
		<a xsl:use-attribute-sets="mFORUMSOURCEREVIEWFORUM" target="_top" href="{$root}G{CLUB/@ID}">
			<xsl:value-of select="CLUB/NAME"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="FORUMSOURCE" mode="reviewforum_forumsource">
	Author:		Thomas Whitehouse
	Purpose:		Creates the correct link and text used in the FORUMSOURCE title with a review forum source
	-->
	<xsl:template match="FORUMSOURCE" mode="reviewforum_forumsource">
		<a xsl:use-attribute-sets="mFORUMSOURCEREVIEWFORUM" href="{$root}RF{REVIEWFORUM/@ID}" target="_top">
			<xsl:value-of select="REVIEWFORUM/REVIEWFORUMNAME"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="FORUMSOURCE" mode="privateuser_forumsource">
	Author:		Thomas Whitehouse
	Purpose:		Creates the correct link and text used in the FORUMSOURCE title with a private user source
	-->
	<xsl:template match="FORUMSOURCE" mode="privateuser_forumsource">
		<a xsl:use-attribute-sets="mFORUMSOURCE_privateuser_forumsource" href="{$root}U{USERPAGE/USER/USERID}" target="_top">
			<!-- <xsl:value-of select="USERPAGE/USER/USERNAME"/> -->
			<xsl:apply-templates select="USERPAGE/USER" mode="username" />
		</a>
	</xsl:template>
	<!--
	<xsl:template match="ARTICLE" mode="c_clip">
	Author:		Tom Whitehouse
	Context:      /H2G2
	Purpose:	 Calls the 'save as clippings' link container
	-->
	<xsl:template match="ARTICLE | PAGE-OWNER | HIERARCHYDETAILS | CLUB" mode="c_clip">
		<xsl:if test="$registered=1">
			<xsl:apply-templates select="." mode="r_clip"/>
		</xsl:if>
	</xsl:template>
	<xsl:template match="HIERARCHYDETAILS" mode="c_clipissue">
		<xsl:if test="$registered=1">
			<xsl:apply-templates select="." mode="r_clipissue"/>
		</xsl:if>
	</xsl:template>
	<xsl:template match="XMLERROR">
		<xsl:value-of select="."/>
	</xsl:template>
	<!--
	<xsl:template name="regpassthroughhref">
	Author:		Thomas Whitehouse
	Purpose:		Used in login process
	-->
	<xsl:template name="regpassthroughhref">
		<xsl:param name="url">Login</xsl:param>
		<xsl:choose>
			<xsl:when test="/H2G2/NEWREGISTER/REGISTER-PASSTHROUGH">
				<xsl:attribute name="href"><xsl:value-of select="$root"/><xsl:value-of select="$url"/><xsl:for-each select="/H2G2/NEWREGISTER/REGISTER-PASSTHROUGH"><xsl:text>?pa=</xsl:text><xsl:value-of select="@ACTION"/><xsl:for-each select="PARAM"><xsl:text>&amp;pt=</xsl:text><xsl:value-of select="@NAME"/><xsl:text>&amp;</xsl:text><xsl:value-of select="@NAME"/>=<xsl:value-of select="."/></xsl:for-each></xsl:for-each></xsl:attribute>
			</xsl:when>
			<xsl:otherwise>
				<xsl:attribute name="HREF"><xsl:value-of select="$root"/><xsl:value-of select="$url"/></xsl:attribute>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template name="ApplyAttributes">
	Author:		Tom Whitehouse
	Purpose:		Generates <xsl:attributes> element from given parameter
	-->
	<xsl:template name="ApplyAttributes">
		<xsl:param name="attributes"/>
		<xsl:for-each select="msxsl:node-set($attributes)/attribute">
			<xsl:attribute name="{@name}"><xsl:value-of select="@value"/></xsl:attribute>
		</xsl:for-each>
	</xsl:template>
	<!--
	<xsl:template name="scenarios">
	Author:		Tom Whitehouse
	Purpose:		Uses a param test to choose a particular scenario
	-->
	<xsl:template name="scenarios">
		<xsl:param name="ownerfull"/>
		<xsl:param name="viewerfull"/>
		<xsl:param name="ownerempty"/>
		<xsl:param name="viewerempty"/>
		<xsl:param name="test"/>
		<xsl:choose>
			<xsl:when test="$ownerisviewer=1">
				<xsl:choose>
					<xsl:when test="$test">
						<xsl:copy-of select="$ownerfull"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:copy-of select="$ownerempty"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="$test">
						<xsl:copy-of select="$viewerfull"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:copy-of select="$viewerempty"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template name="SUBJECTHEADER">
	Author:		Tom Whitehouse
	Purpose:		Makes sure there is some SUBJECT text (default being ?????)
	-->
	<xsl:template name="SUBJECTHEADER">
		<xsl:param name="text">?????</xsl:param>
		<xsl:value-of select="$text"/>
	</xsl:template>
	<!--
	<xsl:template name="space-to-nbsp">
	Author:		Tom Whitehouse
	Purpose:		Converts ordinary spaces into &nbsp; elements 
	-->
	<xsl:template name="space-to-nbsp">
		<xsl:param name="phrase"/>
		<xsl:param name="result"/>
		<xsl:choose>
			<xsl:when test="$result = ' '">&nbsp;</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$result"/>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:if test="string-length($phrase) &gt; 0">
			<xsl:call-template name="space-to-nbsp">
				<xsl:with-param name="result" select="substring($phrase, 1, 1)"/>
				<xsl:with-param name="phrase" select="substring($phrase, 2)"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	
	<!--
	<xsl:template name="cr-to-br">
	Author:		Manjit Rekhi
	Purpose:		Converts line break cariage returns to <br> tags.
	-->
	<!--xsl:template name="cr-to-br">
        <xsl:param name="text"/>
        <xsl:choose>
                <xsl:when test="substring($text, 1, 1) = '&#xa;'">
                        <br />
                </xsl:when>
                <xsl:otherwise>
                        <xsl:value-of select="substring($text, 1, 1)"/>
                </xsl:otherwise>
        </xsl:choose>
        <xsl:if test="($text != '')">
                <xsl:call-template name="cr-to-br">
                        <xsl:with-param name="text" select="substring($text, 2)"/>
                </xsl:call-template>
        </xsl:if>
</xsl:template-->
<xsl:template name="cr-to-br">
    <xsl:param name="text"/>
    <xsl:choose>
        <xsl:when test="contains($text, '&#xa;')">
            <xsl:value-of select="substring-before($text, '&#xa;')"/><br />
            <xsl:call-template name="cr-to-br">
                <xsl:with-param name="text" select="substring-after($text, '&#xa;')"/>
            </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
            <xsl:value-of select="$text"/>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

  <xsl:variable name="houserulespopupurl">
    <xsl:choose>
      <xsl:when test="/H2G2/SITE/IDENTITYSIGNIN='1' and /H2G2/SITE/IDENTITYPOLICY='http://identity/policies/dna/over13'">
        <xsl:text>http://www.bbc.co.uk/messageboards/newguide/popup_house_rules_teens.html</xsl:text>
      </xsl:when>
      <xsl:when test="/H2G2/SITE/IDENTITYSIGNIN='1' and /H2G2/SITE/IDENTITYPOLICY='http://identity/policies/dna/schools'">
        <xsl:text>http://www.bbc.co.uk/messageboards/newguide/popup_house_rules_schools.html</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <!-- Default to adult -->
        <xsl:text>http://www.bbc.co.uk/messageboards/newguide/popup_house_rules.html</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="faqpopupurl">
    <xsl:text>http://www.bbc.co.uk/messageboards/newguide/popup_faq_index.html</xsl:text>
  </xsl:variable>
  
	<xsl:template name="chooseassetsuffix">
		<xsl:param name="mimetype"/>
		<xsl:choose>
			<xsl:when test="$mimetype='image/jpg'">jpg</xsl:when>
			<xsl:when test="$mimetype='image/jpeg'">jpg</xsl:when>
			<xsl:when test="$mimetype='image/pjpeg'">jpg</xsl:when>
			<xsl:when test="$mimetype='image/gif'">gif</xsl:when>
			<xsl:when test="$mimetype='avi'">avi</xsl:when>
			<xsl:when test="$mimetype='mp1'">mp1</xsl:when>
			<xsl:when test="$mimetype='mp2'">mp2</xsl:when>
			<xsl:when test="$mimetype='mp3'">mp3</xsl:when>
			<xsl:when test="$mimetype='mov'">mov</xsl:when>
			<xsl:when test="$mimetype='wav'">wav</xsl:when>
			<xsl:when test="$mimetype='wmv'">wmv</xsl:when>
		</xsl:choose>
	</xsl:template>
	<!--***************************************************************************************************************************************************************-->
	<!--**********************************************************************Templates used across DNA***********************************************************-->
	<!--***************************************************************************************************************************************************************-->
	<!--***************************************************************************************************************************************************************-->
	<!--***********************************************************************Variables used across DNA************************************************************-->
	<!--***************************************************************************************************************************************************************-->
	<!--
	Default values for site specific variables
	-->
	<xsl:variable name="sitename">h2g2</xsl:variable>
	<xsl:variable name="scopename">h2g2</xsl:variable>
	<xsl:variable name="realmediadir">http://www.bbc.co.uk/h2g2/ram/</xsl:variable>
	<xsl:variable name="root">/dna/h2g2/</xsl:variable>
	<xsl:variable name="rootbase">/dna/</xsl:variable>
	<xsl:variable name="imagesource">/h2g2/skins/Alabaster/images/</xsl:variable>
	<xsl:variable name="toolbarsource">http://www.bbc.co.uk/images/</xsl:variable>
	<xsl:variable name="imagesource2">/h2g2/skins/Alabaster/images/</xsl:variable>
	<xsl:variable name="skingraphics">/h2g2/skins/Alabaster/images/</xsl:variable>
	<xsl:variable name="graphics">/h2g2/skins/Alabaster/images/</xsl:variable>
	<xsl:variable name="smileysource">
		<xsl:value-of select="$imagesource"/>
	</xsl:variable>
	<xsl:variable name="skinname">Simple</xsl:variable>
	<xsl:variable name="skinlist">
		<SKINDEFINITION>
			<NAME>Alabaster</NAME>
			<DESCRIPTION>Alabaster</DESCRIPTION>
		</SKINDEFINITION>
		<SKINDEFINITION>
			<NAME>Classic</NAME>
			<DESCRIPTION>Classic GOO</DESCRIPTION>
		</SKINDEFINITION>
		<SKINDEFINITION>
			<NAME>brunel</NAME>
			<DESCRIPTION>Brunel</DESCRIPTION>
		</SKINDEFINITION>
		<SKINDEFINITION>
			<NAME>tom</NAME>
			<DESCRIPTION>Tom</DESCRIPTION>
		</SKINDEFINITION>
		<SKINDEFINITION>
			<NAME>andy</NAME>
			<DESCRIPTION>Andy</DESCRIPTION>
		</SKINDEFINITION>
		<SKINDEFINITION>
			<NAME>ki</NAME>
			<DESCRIPTION>Ki</DESCRIPTION>
		</SKINDEFINITION>
		<SKINDEFINITION>
			<NAME>boards</NAME>
			<DESCRIPTION>message boards</DESCRIPTION>
		</SKINDEFINITION>
	</xsl:variable>
	<xsl:variable name="subbadges">
		<GROUPBADGE NAME="SUBS">
			<a href="{$root}SubEditors">
				<xsl:value-of select="$m_subgroup"/>
			</a>
		</GROUPBADGE>
		<GROUPBADGE NAME="ACES">
			<a href="{$root}Aces">
				<xsl:value-of select="$m_acesgroup"/>
			</a>
		</GROUPBADGE>
		<GROUPBADGE NAME="FIELDRESEARCHERS">
			<a href="{$root}University">
				<xsl:value-of select="$m_researchersgroup"/>
			</a>
		</GROUPBADGE>
		<GROUPBADGE NAME="SECTIONHEADS">
			<a href="{$root}SectionHeads">
				<xsl:value-of select="$m_sectionheadgroup"/>
			</a>
		</GROUPBADGE>
		<GROUPBADGE NAME="GURUS">
			<a href="{$root}Gurus">
				<xsl:value-of select="$m_GurusGroup"/>
			</a>
		</GROUPBADGE>
		<GROUPBADGE NAME="SCOUTS">
			<a href="{$root}Scouts">
				<xsl:value-of select="$m_ScoutsGroup"/>
			</a>
		</GROUPBADGE>
		<GROUPBADGE NAME="EDITOR">
			<a href="{$root}editor">Editor</a>
		</GROUPBADGE>
	</xsl:variable>
	<xsl:variable name="mymessage">
		<xsl:if test="$ownerisviewer=1">
			<xsl:text>My </xsl:text>
		</xsl:if>
	</xsl:variable>
	<!--
	Generated variables used across DNA
	-->
	<xsl:variable name="ptype" select="'single'"/>
	<xsl:variable name="uppercase">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>
	<xsl:variable name="lowercase">abcdefghijklmnopqrstuvwxyz</xsl:variable>
	<xsl:variable name="showtreegadget">
		<xsl:choose>
			<xsl:when test="number(/H2G2/VIEWING-USER/USER/USER-MODE) = 1">1</xsl:when>
			<xsl:otherwise>0</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="curdate" select="concat(/H2G2/DATE/@YEAR,/H2G2/DATE/@MONTH,/H2G2/DATE/@DAY,/H2G2/DATE/@HOURS,/H2G2/DATE/@MINUTES,/H2G2/DATE/@SECONDS)"/>
	<xsl:variable name="curday" select="/H2G2/DATE/@DAYNAME"/>
	<xsl:variable name="robotsetting">
		<xsl:choose>
			<xsl:when test="/H2G2[@TYPE='ARTICLE']">nofollow</xsl:when>
			<xsl:when test="/H2G2[@TYPE='USERPAGE']">nofollow</xsl:when>
			<xsl:when test="/H2G2[@TYPE='FRONTPAGE']">nofollow</xsl:when>
      <xsl:when test="/H2G2[@TYPE='MULTIPOSTS'] and number(/H2G2/ALLOWROBOTS) = number(1)">
      </xsl:when>
      <xsl:when test="/H2G2[@TYPE='THREADS'] and number(/H2G2/ALLOWROBOTS) = number(1)">
      </xsl:when>
			<xsl:otherwise>noindex,nofollow</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="viewerid">
		<xsl:value-of select="/H2G2/VIEWING-USER/USER/USERID"/>
	</xsl:variable>
	<xsl:variable name="ownerisviewer">
		<xsl:choose>
			<xsl:when test="/H2G2[@TYPE='USERPAGE'] and number(/H2G2/VIEWING-USER/USER/USERID) = number(/H2G2/PAGE-OWNER/USER/USERID)">1</xsl:when>
			<xsl:when test="/H2G2[@TYPE='MOREPOSTS'] and number(/H2G2/VIEWING-USER/USER/USERID) = number(/H2G2/POSTS/@USERID)">1</xsl:when>
			<xsl:when test="/H2G2[@TYPE='ARTICLE'] and number(/H2G2/ARTICLE/ARTICLEINFO/STATUS/@TYPE) = 3 and number(/H2G2/VIEWING-USER/USER/USERID) = number(/H2G2/ARTICLE/ARTICLEINFO/PAGEAUTHOR/EDITOR/USER/USERID)">1</xsl:when>
			<xsl:when test="/H2G2[@TYPE='JOURNAL'] and number(/H2G2/JOURNAL/@USERID) = number(/H2G2/VIEWING-USER/USER/USERID)">1</xsl:when>
			<xsl:when test="/H2G2[@TYPE='CLUB'] and /H2G2/VIEWING-USER/USER/USERID = /H2G2/CLUB/POPULATION/TEAM[@TYPE='OWNER']/MEMBER/USER/USERID">1</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="number(/H2G2/VIEWING-USER/USER/USERID) = number(/H2G2/PAGE-OWNER/USER/USERID)">1</xsl:when>
					<xsl:otherwise>0</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
  <xsl:variable name="complaint_url">
		<xsl:choose>
			<xsl:when test="/H2G2/ARTICLE/ARTICLEINFO/H2G2ID &gt; 0">javascript:popupwindow('/dna/<xsl:value-of select="/H2G2/CURRENTSITEURLNAME"/>/comments/UserComplaintPage?s_start=1&amp;h2g2ID=<xsl:value-of select="/H2G2/ARTICLE/ARTICLEINFO/H2G2ID"/>', 'ComplaintPopup', 'status=1,resizable=1,scrollbars=1,width=640,height=480')</xsl:when>
			<xsl:when test="/H2G2/CLUB/ARTICLE/ARTICLEINFO/H2G2ID &gt; 0">javascript:popupwindow('/dna/<xsl:value-of select="/H2G2/CURRENTSITEURLNAME"/>/comments/UserComplaintPage?s_start=1&amp;h2g2ID=<xsl:value-of select="/H2G2/CLUB/ARTICLE/ARTICLEINFO/H2G2ID"/>', 'ComplaintPopup', 'status=1,resizable=1,scrollbars=1,width=640,height=480')</xsl:when>
			<xsl:otherwise>javascript:popupwindow('/dna/<xsl:value-of select="/H2G2/CURRENTSITEURLNAME"/>/comments/UserComplaintPage?URL=' + escape(window.location.href)&amp;s_start=1, 'ComplaintPopup', 'status=1,resizable=1,scrollbars=1,width=640,height=480')</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="registered">
		<xsl:choose>
			<xsl:when test="/H2G2/VIEWING-USER/USER">1</xsl:when>
			<xsl:otherwise>0</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="fpregistered">
		<xsl:choose>
			<xsl:when test="/H2G2/FRONTPAGE-EDIT-FORM/REGISTERED">
				<xsl:value-of select="/H2G2/FRONTPAGE-EDIT-FORM/REGISTERED"/>
			</xsl:when>
			<xsl:when test="/H2G2/VIEWING-USER/USER">
				<xsl:text>1</xsl:text>
			</xsl:when>
			<xsl:otherwise>0</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="superuser">
		<xsl:choose>
			<xsl:when test="/H2G2/VIEWING-USER/USER/STATUS = 2">1</xsl:when>
			<xsl:otherwise>0</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="premoderated">
		<xsl:choose>
			<xsl:when test="/H2G2/VIEWING-USER/USER/MODERATIONSTATUS[@NAME='PREMODERATED']">1</xsl:when>
			<xsl:otherwise>0</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="restricted">
		<xsl:choose>
			<xsl:when test="/H2G2/VIEWING-USER/USER/MODERATIONSTATUS[@NAME='RESTRICTED']">1</xsl:when>
			<xsl:otherwise>0</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="thisnamespace">
		<xsl:choose>
			<xsl:when test="/H2G2/PARAMS/PARAM[NAME='s_xml']/VALUE='rss'">http://purl.org/rss/1.0/</xsl:when>
			<xsl:when test="/H2G2/PARAMS/PARAM[NAME='s_xml']/VALUE='atom'">http://purl.org/atom/ns#</xsl:when>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="list_of_regions">
		<xsl:for-each select="/H2G2/THREADSEARCHPHRASE/SITEKEYPHRASES/KEYPHRASE/NAME">
			<region>
				<xsl:value-of select="."/>
			</region>
		</xsl:for-each>
		<region>England</region>
	</xsl:variable>
	<xsl:variable name="currentRegion">
		<xsl:if test="/H2G2/THREADSEARCHPHRASE/PHRASES/PHRASE/NAME = msxsl:node-set($list_of_regions)/region">
			<xsl:text>&amp;phrase=</xsl:text>
			<xsl:value-of select="/H2G2/THREADSEARCHPHRASE/PHRASES/PHRASE/TERM[../NAME = msxsl:node-set($list_of_regions)/region]"/>
		</xsl:if>
		<!--xsl:choose>
			<xsl:when test="/H2G2/@TYPE='MULTIPOSTS'">
				<xsl:if test="/H2G2/THREADSEARCHPHRASE/THREADPHRASELIST/PHRASES/PHRASE/NAME = msxsl:node-set($list_of_regions)/region">
					<xsl:text>&amp;phrase=</xsl:text>
					<xsl:value-of select="/H2G2/THREADSEARCHPHRASE/THREADPHRASELIST/PHRASES/PHRASE/TERM[../NAME = msxsl:node-set($list_of_regions)/region]"/>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<xsl:if test="/H2G2/THREADSEARCHPHRASE/PHRASES/PHRASE/NAME = msxsl:node-set($list_of_regions)/region">
					<xsl:text>&amp;phrase=</xsl:text>
					<xsl:value-of select="/H2G2/THREADSEARCHPHRASE/PHRASES/PHRASE/TERM[../NAME = msxsl:node-set($list_of_regions)/region]"/>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose-->
	</xsl:variable>
	<!--***************************************************************************************************************************************************************-->
	<!--***********************************************************************Variables used across DNA************************************************************-->
	<!--***************************************************************************************************************************************************************-->
	<!-- LEAVE THESE!!!! -->
	<xsl:template name="insert-bottomnav"/>
	<xsl:template name="insert-takeactiontable"/>
	<xsl:template name="insert-userrhn"/>
	<xsl:template name="insert-emailtoafriend"/>
	<xsl:variable name="locationnode"/>
	<xsl:variable name="createarticle"/>
	<xsl:variable name="createguide"/>
	<xsl:variable name="createcasestudy"/>
	<xsl:variable name="createddbarticle"/>
	<!-- LEAVE THESE!!!! -->
</xsl:stylesheet>