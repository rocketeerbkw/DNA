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
	exclude-result-prefixes="msxsl local s dt xhtml">
	<xsl:import href="../../../base/base-frontpage.xsl"/>
	<!--

	-->
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
									Page - Level  template
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<xsl:template name="FRONTPAGE_MAINBODY">
		<!-- DEBUG -->
		<xsl:call-template name="TRACE">
			<xsl:with-param name="message">FRONTPAGE_MAINBODY</xsl:with-param>
			<xsl:with-param name="pagename">frontpage.xsl</xsl:with-param>
		</xsl:call-template>
		<!-- DEBUG -->

		<script type="text/javascript">
		<xsl:text disable-output-escaping="yes">
		// &lt;![CDATA[
		var fpArticleSearchRoot = "</xsl:text>
		<xsl:value-of disable-output-escaping="yes" select="$articlesearchroot" />
		<xsl:text disable-output-escaping="yes">";
		//]]&gt;
		</xsl:text>
		</script>		
		
		<form method="get" action="{$articlesearchservice}" id="browseForm">
			<div id="ms-list-timeline">
				<div id="ms-list-timeline-header">
					<xsl:comment> ms-list-timeline-header </xsl:comment>
				</div>
				<noscript>
					<ul>
						<li>
							<p>What would you like to do?</p>
						</li>
						<li>
							<p>
								<a href="{$articlesearchroot}" title="Browse memories">Browse memories</a>
							</p>
						</li>
						<li>
							<p>
								<a title="Add a memory">
									<xsl:attribute name="href">
										<!-- Magnetic North - added a new template that sends user straight to add a memory after login -->
										<xsl:call-template name="sso_typedarticle_signin2"/>
									</xsl:attribute>
									<xsl:text>Add a memory</xsl:text>
								</a>
							</p>							
						</li>
					</ul>
				</noscript>
				<div id="ms-list-timeline-footer">
					<xsl:comment> ms-list-timeline-footer </xsl:comment>
				</div>				
			</div>
			<xsl:call-template name="flash-timeline-script">
				<xsl:with-param name="layerId">ms-list-timeline</xsl:with-param>
				<xsl:with-param name="search"><xsl:value-of select="$articlesearchbase" /></xsl:with-param>
			</xsl:call-template>
			<div id="ms-post-timline">
				<input type="hidden" name="contenttype" value="-1"/>
				<input type="hidden" name="phrase" value="_memory"/>
				<input type="hidden" name="s_from" value="drill_down"/>
				<input type="hidden" name="show" value="8"/>				
				<div id="ms-search">
					<div id="ms-search-form">
						<input type="text" name="phrase" id="k_phrase" class="text" />
						<input type="image" src="/memoryshare/assets/images/search-button-1.png" class="search-button" />
					</div>				
				</div>
			</div>
			<script type="text/javascript">
			<xsl:text disable-output-escaping="yes">
			// &lt;![CDATA[

				$(document).ready(function () {
					initFrontPage();
				});

			//]]&gt;
			</xsl:text>
			</script>
			<div id="ms-features">
				<xsl:call-template name="feature-pod" />
				<xsl:call-template name="client-pod" />
			</div>
		</form>
	</xsl:template>
	
	<xsl:template name="FRONTPAGE_HEADER">
		<xsl:apply-templates mode="header" select=".">
			<xsl:with-param name="title">
				<xsl:value-of select="$m_frontpagetitle"/>
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>

	<!--
	<xsl:template match="ARTICLE" mode="r_frontpage">
	Use: Apply's templates to the root of the editorially-generated content area (GuideML)
	 -->
	<xsl:template match="ARTICLE" mode="r_frontpage">
		<xsl:apply-templates select="FRONTPAGE"/>
	</xsl:template>
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
							TOP-FIVES Object
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<!--
	<xsl:template match="TOP-FIVES" mode="r_frontpage">
	Use: Logical container for area containing the top fives.
	 -->
	<xsl:template match="TOP-FIVES" mode="r_frontpage">
		<xsl:apply-templates select="TOP-FIVE" mode="c_frontpage"/>
	</xsl:template>
	<!--
	<xsl:template match="TOP-FIVE" mode="r_frontpage">
	Use: Presentation of one individual top five
	 -->
	<xsl:template match="TOP-FIVE" mode="r_frontpage">
		<b>
			<xsl:value-of select="TITLE"/>
		</b>
		<br/>
		<xsl:apply-templates select="TOP-FIVE-ARTICLE[position() &lt;=5]|TOP-FIVE-FORUM[position() &lt;=5]" mode="c_frontpage"/>
		<br/>
	</xsl:template>
	<!--
	<xsl:template match="TOP-FIVE-ARTICLE" mode="r_frontpage">
	Use: Presentation of one article link within a top five
	 -->
	<xsl:template match="TOP-FIVE-ARTICLE" mode="r_frontpage">
		<xsl:apply-imports/>
		<br/>
	</xsl:template>
	<!--
	<xsl:template match="TOP-FIVE-FORUM" mode="r_frontpage">
	Use: Presentation of one forum link within a top five
	 -->
	<xsl:template match="TOP-FIVE-FORUM" mode="r_frontpage">
		<xsl:apply-imports/>
		<br/>
	</xsl:template>
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
					Frontpage only GuideML tags
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<!--
	<xsl:template match="EDITORIAL-ITEM">
	Use: Currently used as a frontpage XML tag on many existing sites
	 -->
	<xsl:template match="EDITORIAL-ITEM">
		<xsl:if test="(not(@TYPE)) or (@TYPE='REGISTERED' and $fpregistered=1) or (@TYPE='UNREGISTERED' and $fpregistered=0)">
			<xsl:value-of select="SUBJECT"/>
			<br/>
			<xsl:apply-templates select="BODY"/>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>
