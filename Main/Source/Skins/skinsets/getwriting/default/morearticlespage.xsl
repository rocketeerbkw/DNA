<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
	<!ENTITY space "<xsl:text xmlns:xsl='http://www.w3.org/1999/XSL/Transform'> </xsl:text>">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<xsl:import href="../../../base/base-morearticlespage.xsl"/>
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
	

		<table border="0" cellspacing="0" cellpadding="0">
		<tr>
		<!-- column 1 -->
		<xsl:element name="td" use-attribute-sets="column.1">
		<div class="PageContent">
		<div class="prevnextbox">
		<table width="390" border="0" cellspacing="0" cellpadding="4">
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
				
		<div class="box">
		<xsl:apply-templates select="ARTICLES/ARTICLE-LIST" mode="c_morearticlespage"/>
		</div>
				
		<div class="prevnextbox">
		<table width="390" border="0" cellspacing="0" cellpadding="4">
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
		
		<xsl:apply-templates select="ARTICLES" mode="t_backtouserpage"/>
		<xsl:apply-templates select="ARTICLES" mode="c_showcancelledlink"/>
		</div>

	
		<xsl:element name="img" use-attribute-sets="column.spacer.1" />
		</xsl:element>
		<xsl:element name="td" use-attribute-sets="column.3"><xsl:element name="img" use-attribute-sets="column.spacer.3" /></xsl:element>
		<xsl:element name="td" use-attribute-sets="column.2">
		
		<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
		<div class="rightnavboxheaderhint">HINTS AND TIPS</div>
		<div class="rightnavbox">
		<xsl:copy-of select="$allmyportfolio.tips" />
		</div>
		</xsl:element>
		<br/>
		
		
		
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
	
	<div>
	<div class="boxheading">
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	<strong>CREATIVE WRITING</strong>
	</xsl:element></div>
	<xsl:apply-templates select="ARTICLE[SITEID=15][EXTRAINFO/TYPE/@ID &gt;= 30 and EXTRAINFO/TYPE/@ID &lt;= 40 or EXTRAINFO/TYPE/@ID='1' or EXTRAINFO/TYPE/@ID &gt;= 80 and EXTRAINFO/TYPE/@ID &lt;= 90]" mode="c_morearticlespage"/>
	</div>
	
	<div>
	<div class="boxheading">
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	<strong>ADVICE</strong>
	</xsl:element>
	</div>
	<xsl:apply-templates select="ARTICLE[EXTRAINFO/TYPE/@ID='41']" mode="c_morearticlespage"/>
	</div>
	
	<div>
	<div class="boxheading">
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	<strong>CHALLENGES</strong>
	</xsl:element>
	</div>
	<xsl:apply-templates select="ARTICLE[EXTRAINFO/TYPE/@ID='42']" mode="c_morearticlespage"/>
	</div>
	
	</xsl:when>
	
	<xsl:when test="@TYPE='USER-RECENT-APPROVED'">
		<div><strong><xsl:value-of select="$m_memberormy"/> editorial</strong></div>
		<xsl:apply-templates select="ARTICLE" mode="c_morearticlespage"/>	
	</xsl:when>
	<xsl:when test="@TYPE='USER-RECENT-CANCELLED'">
		<div><strong><xsl:value-of select="$m_memberormy"/> deleted pages</strong></div>
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
			<xsl:when test="count(preceding-sibling::ARTICLE) mod 2 = 0">colourbar2</xsl:when>
			<xsl:otherwise>colourbar1</xsl:otherwise>
			</xsl:choose>
			</xsl:attribute>
			<table cellspacing="0" cellpadding="0" border="0" width="380">
			<tr>
			<td rowspan="2" width="25">&nbsp;</td>
			<td>
			<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
				<strong><xsl:apply-templates select="SUBJECT" mode="t_morearticlespage"/></strong>
			</xsl:element>
			</td>
			<td align="right">
			</td>
			</tr><tr>
			<td>
			<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
				<xsl:apply-templates select="DATE-CREATED"/>
			</xsl:element>
			</td>
			<td align="right">
			<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
			<xsl:apply-templates select="H2G2-ID" mode="c_editarticle"/>
			<xsl:if test="STATUS = 7 and $ownerisviewer = 1">
			<a href="{$root}UserEdit{H2G2-ID}?cmd=undelete">
			<xsl:copy-of select="$button.retrieve" /></a>
			</xsl:if>
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
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
		<xsl:choose>
		<xsl:when test="ARTICLE-LIST[@SKIPTO &gt; 0]">
		<xsl:copy-of select="$previous.arrow" /> <xsl:apply-imports/>
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
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
		<xsl:choose>
		<xsl:when test="ARTICLE-LIST[@MORE=1]">
			<xsl:apply-imports/><xsl:text>  </xsl:text><xsl:copy-of select="$next.arrow" />
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
		<div class="boxactionback1">
		<div class="arrow1">
		<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
		<xsl:apply-imports/>
		</xsl:element>
		</div>
		</div>
	</xsl:template>
	
	<xsl:template match="ARTICLES" mode="t_backtouserpage">
		<div class="boxactionback">
		<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
		<div class="arrow1">
		<a href="{$root}U{@USERID}" xsl:use-attribute-sets="mARTICLES_t_backtouserpage">
			<xsl:copy-of select="$m_FromMAToPSText"/>
		</a>		
		</div>
		</xsl:element>
		</div>
	</xsl:template>
	
</xsl:stylesheet>
