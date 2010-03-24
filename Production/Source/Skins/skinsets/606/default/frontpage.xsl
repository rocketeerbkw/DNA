<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
	<!ENTITY space "<xsl:text xmlns:xsl='http://www.w3.org/1999/XSL/Transform'> </xsl:text>">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
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
	
	
	<!-- checking if viewer is signed in - if they are take them to their userpage otherwise take them to sign in page -->
	
	<xsl:choose>
		<xsl:when test="/H2G2/VIEWING-USER/USER/USERID">
			<meta http-equiv="refresh" content="0;url={$root}U{/H2G2/VIEWING-USER/USER/USERID}"/>
			<p>You are about to be taken to <a href="{$root}U{/H2G2/VIEWING-USER/USER/USERID}">your member page</a></p>
		</xsl:when>
		<xsl:otherwise>
			<xsl:choose>
				<xsl:when test="/H2G2/SITE/IDENTITYSIGNIN = 0">
					<meta http-equiv="refresh" content="0;url={$signinlink}"/>
					You are about to be taken to the <a href="{$signinlink}">sign in page</a>
				</xsl:when>
				<xsl:otherwise>
					<!-- <meta http-equiv="refresh" content="0;url={$signinlink}"/> --> 
					You need to be signed in to view this page - <a href="{$cpshome}">return to the 606 homepage</a>.
				</xsl:otherwise>
			</xsl:choose>
		</xsl:otherwise>
	</xsl:choose>
	
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
