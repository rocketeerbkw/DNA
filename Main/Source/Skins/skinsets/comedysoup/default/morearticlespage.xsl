<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
	<!ENTITY space "<xsl:text xmlns:xsl='http://www.w3.org/1999/XSL/Transform'> </xsl:text>">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<xsl:import href="../../../base/base-morearticlespage.xsl"/>
	<!--
	MOREPAGES_MAINBODY
		insert-showeditedlink
		insert-shownoneditedlink
		insert-showcancelledlink
		ARTICLE-LIST
		- - - -  defined in userpage.xsl - - - - - 
		
		insert-prevmorepages
		insert-nextmorepages
		insert-backtouserpagelink
	-->
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
									Page - Level  template
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<xsl:template name="MOREPAGES_MAINBODY">
	<!-- DEBUG -->
	<xsl:call-template name="TRACE">
		<xsl:with-param name="message">MOREPAGES_MAINBODY</xsl:with-param>
		<xsl:with-param name="pagename">morearticlespage.xsl</xsl:with-param>
	</xsl:call-template>
	<!-- DEBUG -->
	
		<table width="100%" cellpadding="5" cellspacing="0" border="0">
			<tr>
				<td valign="top" class="postmain" width="60%"><h3>MY PORTFOLIO: ALL ARTICLES</h3>
					
				</td>
				<td valign="top" class="postside" width="40%">
						<!--<font xsl:use-attribute-sets="mainfont">
						<xsl:apply-templates select="ARTICLES" mode="t_showeditedlink"/>
						<br/>
						<xsl:apply-templates select="ARTICLES" mode="t_shownoneditedlink"/>
						<br/>
						<xsl:apply-templates select="ARTICLES" mode="c_showcancelledlink"/>
					</font>-->
				</td>
			</tr>
		</table>
	</xsl:template>
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
							ARTICLE-LIST Object
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<!--
	<xsl:template match="ARTICLES/ARTICLE-LIST" mode="r_morearticlespage">
	Description: Presentation of the object holding the list of articles
	 -->
	<xsl:template match="ARTICLES/ARTICLE-LIST" mode="r_morearticlespage">
		<xsl:apply-templates select="ARTICLE" mode="c_morearticlespage"/>
	</xsl:template>
	<!--
	<xsl:template match="ARTICLE" mode="r_morearticlespage">
	Description: Presentation of each of the ARTCLEs in the ARTICLE-LIST
	 -->
	<xsl:template match="ARTICLE" mode="r_morearticlespage">
		<table width="100%" cellpadding="5" cellspacing="0" border="0" class="post">
			<tr>
				<td class="head">
				<!--
					<font xsl:use-attribute-sets="mainfont">From:&nbsp;<xsl:apply-templates select="SITEID" mode="t_morearticlespage"/>
					</font>
				-->
				</td>
			</tr>
			<tr>
				<td class="body">
					<font xsl:use-attribute-sets="mainfont">
						<xsl:apply-templates select="H2G2-ID" mode="t_morearticlespage"/><br/>
						<xsl:apply-templates select="SUBJECT" mode="t_morearticlespage"/>
						<br/>
						<xsl:apply-templates select="DATE-CREATED" mode="t_morearticlespage"/>
					</font>
				</td>
			</tr>
		</table>
		<br/>
		
	</xsl:template>
	<!-- 
	<xsl:template match="ARTICLES" mode="r_previouspages">
	Use: Creates a 'More recent' link if appropriate
	-->
	<xsl:template match="ARTICLES" mode="r_previouspages">
		<xsl:apply-imports/>
		<br/>
	</xsl:template>
	<!-- 
	<xsl:template match="ARTICLES" mode="r_morepages">
	Use: Creates a 'Older' link if appropriate
	-->
	<xsl:template match="ARTICLES" mode="r_morepages">
		<xsl:apply-imports/>
		<br/>
	</xsl:template>
	<!-- 
	<xsl:template match="ARTICLES" mode="r_showcancelledlink">
	Use: Creates a link to load a morepages page showing only cancelled entries
		  created by the viewer
	-->
		<!-- <xsl:template match="ARTICLES" mode="r_showcancelledlink">
		<xsl:apply-imports/>
		<br/>
	</xsl:template>	-->
</xsl:stylesheet>
