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
			<xsl:comment>#if expr='$bbcpage_survey_go = 1' </xsl:comment>
			<xsl:comment>#include virtual="/includes/survey_css.sssi" </xsl:comment>
			<xsl:comment>#endif </xsl:comment>
		</style>
		<style type="text/css">
			@import '/includes/tbenh.css';
		</style>
	</xsl:template>
	<xsl:template name="bbcitoolbar">
		<!-- toolbar 1.44 header.page -->
		<table width="100%" cellpadding="0" cellspacing="0" border="0" lang="en">
			<tr>
				<td class="bbcpageShadow" colspan="2">
					<a href="#startcontent" accesskey="2">
						<img src="/f/t.gif" width="590" height="2" alt="Skip to main content" title="" border="0" />
					</a>
				</td>
				<td class="bbcpageShadow">
					<a href="/cgi-bin/education/betsie/parser.pl">
						<img src="/f/t.gif" width="1" height="1" alt="Text Only version of this page" title="" border="0" />
					</a>
					<br />
					<a href="/accessibility/accesskeys/keys.shtml" accesskey="0">
						<img src="/f/t.gif" width="1" height="1" alt="Access keys help" title="" border="0" />
					</a>
				</td>
			</tr>
			<form action="http://www.bbc.co.uk/cgi-bin/search/results.pl">
				<tr>
					<td class="bbcpageShadowLeft" width="94">
						<a href="http://www.bbc.co.uk/go/toolbar/-/home/d/" accesskey="1">
							<img src="/images/logo042.gif" width="90" height="30" alt="bbc.co.uk" border="0" hspace="2" vspace="0" />
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
									<nobr>
										<font size="1">
											<b>
												<a href="/go/toolbar/-/a-z/" class="bbcpageWhite" accesskey="3">A-Z&nbsp;Index</a>
											</b>
										</font>
									</nobr>
								</td>
								<td class="bbcpageSearchL" width="8">
									<br/>
								</td>
								<td class="bbcpageSearch2" width="100">
									<input type="text" id="bbcpageSearchbox" name="q" size="6" style="margin:3px 0 0;font-family:arial,helvetica,sans-serif;width:100px;" title="BBC Search" accesskey="4" />
								</td>
								<td class="bbcpageSearch">
									<input type="image" src="{$toolbar_images}/srchb2.gif" name="go" value="go" alt="Search" width="64" height="25" border="0"/>
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
					<xsl:when test="$toolbar_width = ''">
					<!--xsl:when test="($bbcpage_contentwidth = '100%' or $bbcpage_contentwidth = 'centre')"-->
						<td class="bbcpageBlack" colspan="3">
							<img src="/f/t.gif" width="1" height="1" alt=""/>
						</td>
					</xsl:when>
					<xsl:otherwise>
						<td class="bbcpageBlack" colspan="2">
							<table cellpadding="0" cellspacing="0" border="0">
								<tr>
									<!--xsl:if test="$bbcpage_nav != 'no'"-->
										<td width="110">
											<img src="/f/t.gif" width="110" height="1" alt=""/>
										</td>
										<!--xsl:if test="$bbcpage_navgutter != 'no'"-->
											<td width="10">
												<img src="/f/t.gif" width="10" height="1" alt=""/>
											</td>
										<!--/xsl:if-->
									<!--/xsl:if-->
									<td id="bbcpageblackline" width="{$toolbar_width - 110}">
										<img src="/f/t.gif" width="{$toolbar_width - 110}" height="1" alt=""/>
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
		<!-- end toolbar 1.44 -->
		<xsl:comment>#if expr='$bbcpage_survey_go = 1' </xsl:comment>
		<xsl:comment>#include virtual="/includes/survey_bar.sssi" </xsl:comment>
		<xsl:comment>#endif </xsl:comment>
	</xsl:template>
</xsl:stylesheet>
