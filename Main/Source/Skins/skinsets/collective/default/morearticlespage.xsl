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
	<xsl:with-param name="message">MOREPAGES_MAINBODY test variable = <xsl:value-of select="$current_article_type" /></xsl:with-param>
	<xsl:with-param name="pagename">morearticles.xsl</xsl:with-param>
	</xsl:call-template>
	<!-- DEBUG -->

		<xsl:call-template name="box.heading">
			<xsl:with-param name="box.heading.value"><xsl:apply-templates select="/H2G2/PAGE-OWNER" mode="c_usertitle"/></xsl:with-param>			
		</xsl:call-template>

		<div class="myspace-b-b">
			<xsl:copy-of select="$myspace.portfolio.white" />&nbsp;
			<xsl:element name="{$text.subheading}" use-attribute-sets="text.subheading"><strong>all <xsl:value-of select="$m_memberormy"/> portfolio</strong></xsl:element>
		</div>

		<table  border="0" cellspacing="0" cellpadding="0">
		<tr>
<!-- column 1 -->
		<xsl:element name="td" use-attribute-sets="column.1">

		<div class="next-back">
		<table width="100%" border="0" cellspacing="0" cellpadding="4">
		<tr>
			<td>
		<!-- back to newest -->
		<xsl:apply-templates select="ARTICLES" mode="r_previouspages"/>
			</td>
			<td align="right">
		<!-- back to oldest -->
		<xsl:apply-templates select="ARTICLES" mode="r_morepages"/>		
			</td>
		</tr>
		</table>
		</div>	
		
		<xsl:apply-templates select="ARTICLES/ARTICLE-LIST" mode="c_morearticlespage"/>
		
		
		<div class="next-back">
		<table width="100%" border="0" cellspacing="0" cellpadding="4">
		<tr>
			<td>
		<!-- back to newest -->
		<xsl:apply-templates select="ARTICLES" mode="r_previouspages"/>
			</td>
			<td align="right">
		<!-- back to oldest -->
		<xsl:apply-templates select="ARTICLES" mode="r_morepages"/>		
			</td>
		</tr>
		</table>
		</div>	
	
		<!-- back to my space -->
		<xsl:apply-templates select="ARTICLES" mode="t_backtouserpage"/>
		

		<br />
		<xsl:element name="img" use-attribute-sets="column.spacer.1" />
		</xsl:element>
		<xsl:element name="td" use-attribute-sets="column.3"><xsl:element name="img" use-attribute-sets="column.spacer.3" /></xsl:element>
		<xsl:element name="td" use-attribute-sets="column.2">
<!-- column 2 -->
		<div class="morepost-h">
			<div class="myspace-r">
				<xsl:copy-of select="$myspace.tips" />&nbsp;
				<xsl:element name="{$text.subheading}" use-attribute-sets="text.subheading">
					<strong class="white">hints and tips</strong>
				</xsl:element>
			</div>

		</div>
		<br />
		<xsl:element name="img" use-attribute-sets="column.spacer.2" />
		</xsl:element>
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
	
	<xsl:choose>
	<xsl:when test="@TYPE='USER-RECENT-NORMALANDAPPROVED'">
		<xsl:apply-templates select="ARTICLE" mode="c_morearticlespage"/>
	</xsl:when>
	<xsl:when test="@TYPE='USER-RECENT-APPROVED'">
		<div class="myspace-j"><strong><xsl:value-of select="$m_memberormy"/> editorial</strong></div>
		<xsl:apply-templates select="ARTICLE" mode="c_morearticlespage"/>	
	</xsl:when>
	<xsl:when test="@TYPE='USER-RECENT-CANCELLED'">
		<div class="myspace-j"><strong><xsl:value-of select="$m_memberormy"/> deleted pages</strong></div>
		<xsl:apply-templates select="ARTICLE[position() &lt;=$articlelimitentries]" mode="c_morearticlespage"/>
	</xsl:when>
	</xsl:choose>

		
	</xsl:template>
	<!--
	<xsl:template match="ARTICLE" mode="r_morearticlespage">
	Description: Presentation of each of the ARTCLEs in the ARTICLE-LIST
	 -->
	 
<xsl:template match="ARTICLE" mode="r_morearticlespage">

		<div>
			<xsl:attribute name="class">
			<xsl:choose>
			<xsl:when test="count(preceding-sibling::ARTICLE) mod 2 = 0">myspace-e-1</xsl:when><!-- alternate colours, MC -->
			<xsl:otherwise>myspace-e-2</xsl:otherwise>
			</xsl:choose>
			</xsl:attribute>
			<table cellspacing="0" cellpadding="0" border="0" width="395">
			<tr>
			<td rowspan="2" width="25" class="myspace-e-3">&nbsp;</td>
			<td class="brown">
			<xsl:element name="{$text.base}" use-attribute-sets="text.base">
				<strong><xsl:apply-templates select="SUBJECT" mode="t_morearticlespage"/></strong>
			</xsl:element>
			</td>
			<td align="right" class="orange">
			
			<xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall">
					<strong>
					<xsl:choose>
						<xsl:when test="EXTRAINFO/TYPE/@ID='2'">portfolio page</xsl:when>
						<xsl:otherwise>
						<xsl:call-template name="article_subtype">
						<xsl:with-param name="status" select="STATUS" />
						</xsl:call-template>
						</xsl:otherwise>
					</xsl:choose>
					</strong>
			</xsl:element>
			</td>
			</tr><tr>
			<td class="orange">
			<xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall">
				<xsl:apply-templates select="DATE-CREATED" mode="collective_long"/>
			</xsl:element>
			</td>
			<td align="right">
			<xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall">
				<xsl:apply-templates select="H2G2-ID" mode="c_editarticle"/>
			</xsl:element>
			</td>
			</tr>
			</table>
		</div>
		
<!-- <xsl:apply-templates select="H2G2-ID" mode="t_morearticlespage"/> -->
<!-- <xsl:apply-templates select="SITEID" mode="t_morearticlespage"/> -->
	
	</xsl:template>
	<!-- 
	<xsl:template match="ARTICLES" mode="r_previouspages">
	Use: Creates a 'More recent' link if appropriate
	-->
	<xsl:template match="ARTICLES" mode="r_previouspages">
	<xsl:element name="{$text.base}" use-attribute-sets="text.base">
		<xsl:choose>
		<xsl:when test="ARTICLE-LIST[@SKIPTO &gt; 0]">
		<xsl:apply-imports/> <xsl:copy-of select="$arrow.left" />
		</xsl:when>
		<xsl:otherwise>
			<xsl:copy-of select="$m_newerentries"/>
		</xsl:otherwise>
		</xsl:choose>
	</xsl:element>
	</xsl:template>
	
	<!-- 
	<xsl:template match="ARTICLES" mode="r_morepages">
	Use: Creates a 'Older' link if appropriate
	-->
	<xsl:template match="ARTICLES" mode="r_morepages">
	<xsl:element name="{$text.base}" use-attribute-sets="text.base">
		<xsl:choose>
		<xsl:when test="ARTICLE-LIST[@MORE=1]">
			<xsl:apply-imports/> <xsl:copy-of select="$arrow.right" />
		</xsl:when>
		<xsl:otherwise>
			<xsl:copy-of select="$m_olderentries"/>
		</xsl:otherwise>
		</xsl:choose>
	</xsl:element>
	</xsl:template>

	<!-- 
	<xsl:template match="ARTICLES" mode="r_showcancelledlink">
	Use: Creates a link to load a morepages page showing only cancelled entries
		  created by the viewer
	-->
	<xsl:template match="ARTICLES" mode="r_showcancelledlink">
		<xsl:apply-imports/>
	</xsl:template>
	
	<xsl:template match="ARTICLES" mode="t_backtouserpage">
		<div class="myspace-b">
		<xsl:element name="{$text.base}" use-attribute-sets="text.base">
		<xsl:copy-of select="$arrow.right" />&nbsp;
		<a href="{$root}U{@USERID}" xsl:use-attribute-sets="mARTICLES_t_backtouserpage">
			<xsl:copy-of select="$m_FromMAToPSText"/>
		</a>
		</xsl:element>
		</div>
	</xsl:template>
	
</xsl:stylesheet>
