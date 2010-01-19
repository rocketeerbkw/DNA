<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">

	<xsl:variable name="toolbar_images">/images</xsl:variable>
	<xsl:variable name="toolbar_searchcolour">#999999</xsl:variable>
	<xsl:variable name="toolbar_width" select="''"/>
	<xsl:template name="toolbarcss">
		<!-- toolbar 1.4 header page -->
		<style type="text/css">
			<xsl:comment>
				body {margin:0;}
				form {margin:0;padding:0;}
				.bbcpageShadow {background-color:#828282;}
				.bbcpageShadowLeft {border-left:2px solid #828282;}
				.bbcpageBar {background:#999999 url(<xsl:value-of select="$toolbar_images"/>/v.gif) repeat-y;}
				.bbcpageSearchL {background:<xsl:value-of select="$toolbar_searchcolour"/> url(<xsl:value-of select="$toolbar_images"/>/sl.gif) no-repeat;}
				.bbcpageSearch {background:<xsl:value-of select="$toolbar_searchcolour"/> url(<xsl:value-of select="$toolbar_images"/>/st.gif) repeat-x;}
				.bbcpageSearch2 {background:<xsl:value-of select="$toolbar_searchcolour"/> url(<xsl:value-of select="$toolbar_images"/>/st.gif) repeat-x 0 0;}
				.bbcpageSearchRa {background:#999999 url(<xsl:value-of select="$toolbar_images"/>/sra.gif) no-repeat;}
				.bbcpageSearchRb {background:#999999 url(<xsl:value-of select="$toolbar_images"/>/srb.gif) no-repeat;}
				.bbcpageBlack {background-color:#000000;}
				.bbcpageGrey, .bbcpageShadowLeft {background-color:#999999;}
				.bbcpageWhite,font.bbcpageWhite,a.bbcpageWhite,a.bbcpageWhite:link,a.bbcpageWhite:hover,a.bbcpageWhite:visited {color:#ffffff;text-decoration:none;font-family:verdana,arial,helvetica,sans-serif;padding:1px 4px;}
			</xsl:comment>
			
			<xsl:if test="/H2G2/@TYPE = 'FRONTPAGE'">
				<xsl:comment>#if expr='${bbcpage_survey_go} = 1' </xsl:comment>
				<xsl:comment>#include virtual="/includes/survey_css.sssi" </xsl:comment>
				<xsl:comment>#endif </xsl:comment>
			</xsl:if>
		</style>
		
		<xsl:choose>
			<xsl:when test="$skinname = 'brunel'">
				<xsl:comment><![CDATA[[if IE]><![if gte IE 6]><![endif]]]></xsl:comment><!--[if IE]><![if gte IE 6]><![endif]--><style type="text/css">
					@import '/dnaimages/bbcpage/v3-0/toolbar.xhtml-transitional.css';
				</style><!--[if IE]><![endif]><![endif]--><xsl:comment><![CDATA[[if IE]><![endif]><![endif]]]></xsl:comment>
				
				<xsl:comment><![CDATA[[if IE 7]><style type="text/css" media="screen">#bbcpageExplore a {height:18px;}</style><![endif]]]></xsl:comment>				
			</xsl:when>
			
			<xsl:otherwise>
				
		<xsl:comment><![CDATA[[if IE]><![if gte IE 6]><![endif]]]></xsl:comment><!--[if IE]><![if gte IE 6]><![endif]--><style type="text/css">
			@import '/includes/bbcpage/v3-0/toolbar.css';
			
			#toolbarContainer a {font-size:75%;}
		</style><!--[if IE]><![endif]><![endif]--><xsl:comment><![CDATA[[if IE]><![endif]><![endif]]]></xsl:comment>
		<xsl:comment><![CDATA[[if gte IE 6]><style type="text/css" media="screen">#bbcpageExplore a {height:22px;}</style><![endif]]]></xsl:comment>
				
				
			</xsl:otherwise>
			
		</xsl:choose>
		<link type="text/css" rel="stylesheet" href="http://www.bbc.co.uk/dnaimages/boards/includes/login.css"/>
	</xsl:template>
	<xsl:template name="bbcitoolbar">
		
		<xsl:choose>
			<xsl:when test="$skinname = 'brunel'">
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
							<input type="text" id="bbcpageSearch" name="q" style="font-family:arial,helvetica,sans-serif;" title="BBC Search" accesskey="4" />
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
		
		<xsl:if test="/H2G2/@TYPE = 'FRONTPAGE'">
			<xsl:comment>#if expr="$bbcpage_survey = yes &amp;&amp; $HTTP_COOKIE = /BBC-UID=/"</xsl:comment>
				<xsl:comment>#include virtual="/includes/blq/include/pulse/core.sssi" </xsl:comment>
				<xsl:comment>#if expr="$pulse_go = 1"</xsl:comment>
				
					<xsl:comment>#include virtual="/includes/blq/include/pulse/bbcpage.sssi" </xsl:comment>
				<xsl:comment>#endif </xsl:comment>
			<xsl:comment>#endif </xsl:comment>
		</xsl:if>
		
	</xsl:template>
</xsl:stylesheet>
