<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-	microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<xsl:import href="../../../base/base-infopage.xsl"/>
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
									Page - Level  template
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<xsl:template name="INFO_MAINBODY">
	
	<!-- DEBUG -->
	<xsl:call-template name="TRACE">
	<xsl:with-param name="message">INFO_MAINBODY<xsl:value-of select="$current_article_type" /></xsl:with-param>
	<xsl:with-param name="pagename">infopage.xsl</xsl:with-param>
	</xsl:call-template>
	<!-- DEBUG -->
	

<div class="generic-u">
	<xsl:element name="{$text.subheading}" use-attribute-sets="text.subheading">
	<strong>
		<xsl:choose>
			<xsl:when test="INFO/@MODE='articles'"><xsl:value-of select="$m_toptenupdatedarticles"/></xsl:when>
			<xsl:when test="INFO/@MODE='conversations'"><xsl:value-of select="$m_toptwentyupdated"/></xsl:when>
		</xsl:choose>
	</strong>
	</xsl:element>
</div>
<div class="myspace-b-b">
		<xsl:choose>
			<xsl:when test="INFO/@MODE='articles'"><xsl:copy-of select="$myspace.conversations.white" /></xsl:when>
			<xsl:when test="INFO/@MODE='conversations'"><xsl:copy-of select="$myspace.portfolio.white" /></xsl:when>
		</xsl:choose>
		&nbsp;
	<xsl:element name="{$text.subheading}" use-attribute-sets="text.subheading">
	<strong>
		<xsl:choose>
			<xsl:when test="INFO/@MODE='articles'">new member reviews and pages</xsl:when>
			<xsl:when test="INFO/@MODE='conversations'">updated conversations</xsl:when>
		</xsl:choose>
	</strong>
	</xsl:element>
</div>



		<table cellpadding="0" cellspacing="0" border="0">
		<tr>
<!-- * column 1 -->
		<xsl:element name="td" use-attribute-sets="column.1">

		<!-- PREVIOUS AND NEXT -->
		<div class="next-back"><xsl:apply-templates select="INFO" mode="prev_next"/></div>
		<!-- INFO LIST -->
		<xsl:apply-templates select="INFO" mode="c_info"/>
		<!-- PREVIOUS AND NEXT -->
		<div class="next-back"><xsl:apply-templates select="INFO" mode="prev_next"/></div>
	
		<xsl:element name="img" use-attribute-sets="column.spacer.1" />
		</xsl:element>
<!-- * column 2 -->
		<xsl:element name="td" use-attribute-sets="column.3"><xsl:element name="img" use-attribute-sets="column.spacer.3" /></xsl:element>
		<xsl:element name="td" use-attribute-sets="column.2">
		
		
			
	
		
		<div class="morepost-h">
			<div class="myspace-r">
				<xsl:copy-of select="$myspace.tips" />&nbsp;
				<xsl:element name="{$text.subheading}" use-attribute-sets="text.subheading">
					<strong class="white">hints and tips</strong>
				</xsl:element>
			</div>			
			<xsl:choose>
				<xsl:when test="INFO/@MODE='articles'"><xsl:copy-of select="$tips_infopage_articles" /></xsl:when>
				<xsl:when test="INFO/@MODE='conversations'"><xsl:copy-of select="$tips_infopage_conversations" /></xsl:when>
			</xsl:choose>
		<br />
		</div>
		<!-- RANDOM PROMO -->
		<xsl:call-template name="RANDOMPROMO" />
		<xsl:element name="img" use-attribute-sets="column.spacer.2" /></xsl:element>
		</tr></table>
	</xsl:template>
	
	<!--
	<xsl:template name="INFO_HEADER">
	Author:		Andy Harris
	Context:      H2G2
	Purpose:	 Creates the title for the page which sits in the html header
	-->
	<xsl:template name="INFO_HEADER">
		<xsl:apply-templates mode="header" select=".">
			<xsl:with-param name="title">
				<xsl:value-of select="$m_pagetitlestart"/>
			<xsl:element name="{$text.subheading}" use-attribute-sets="text.subheading">
			<strong>
				<xsl:choose>
					<xsl:when test="INFO/@MODE='articles'">new member reviews and pages</xsl:when>
					<xsl:when test="INFO/@MODE='conversations'">updated conversations</xsl:when>
				</xsl:choose>
			</strong>
			</xsl:element>
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>

	<!--
	<xsl:template match="INFO" mode="prev_next">
	Description: previous and next block
	 -->
	<xsl:template match="INFO" mode="prev_next">
	
	<xsl:variable name="info_type">
	<xsl:choose>
		<xsl:when test="@MODE='articles'">art</xsl:when>
		<xsl:when test="@MODE='conversations'">conv</xsl:when>
	</xsl:choose>
	</xsl:variable>
	
	
	<xsl:variable name="skip_next">
	<xsl:choose>
	<xsl:when test="@SKIPTO=''">20</xsl:when>
	<xsl:otherwise>
	<xsl:value-of select="@SKIPTO + 20" />
	</xsl:otherwise>
	</xsl:choose>
	</xsl:variable>
	
	<xsl:variable name="skip_previous">
	<xsl:choose>
	<xsl:when test="@SKIPTO=0"></xsl:when>
	<xsl:otherwise>
	<xsl:value-of select="@SKIPTO - 20" />
	</xsl:otherwise>
	</xsl:choose>
	</xsl:variable>
	
		<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
		<tr>
		<xsl:if test="not(@SKIPTO=0)">
		<td width="105">
		<font size="2">
		<xsl:copy-of select="$arrow.first" />&nbsp;
		<a href="info?cmd={$info_type}&amp;show=20">most recent</a>
		</font>	&nbsp;|
		</td>
		</xsl:if>
		<td align="left">
		<font size="2">
		<xsl:copy-of select="$arrow.previous" />&nbsp;
		<xsl:choose>
			<xsl:when test="not($skip_previous='')">
			<a href="info?cmd={$info_type}&amp;show=20&amp;skip={$skip_previous}">previous</a>
			</xsl:when>
			<xsl:otherwise>
			previous
			</xsl:otherwise>
		</xsl:choose>
		</font></td>
		<td align="right"><font size="2">
		
		<!-- need to tab through all pages to see if this is true -->
		<xsl:choose>
			<xsl:when test="not(count(RECENTCONVERSATIONS/RECENTCONVERSATION)&lt;@COUNT) or not(count(FRESHESTARTICLES/RECENTARTICLE)&lt;@COUNT)">
			<a href="info?cmd={$info_type}&amp;show=20&amp;skip={$skip_next}">next</a>
			</xsl:when>
			<xsl:otherwise>
			next 
			</xsl:otherwise>
		</xsl:choose>
		&nbsp;<xsl:copy-of select="$arrow.next" /></font>
		</td>
		</tr>
		</table>
	
	</xsl:template>
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
							INFO Object
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<!--
	<xsl:template match="INFO" mode="r_info">
	Description: Presentation of the object holding the four different INFO blocks, the 
		TOTALREGUSERS and the APPROVEDENTRIES info with their respective text
	 -->
	<xsl:template match="INFO" mode="r_info">
	<!-- 
	<xsl:value-of select="$m_totalregusers"/>
	<xsl:value-of select="TOTALREGUSERS"/>
	<xsl:value-of select="$m_usershaveregistered"/>
	<xsl:value-of select="$m_editedentries"/>
	<xsl:value-of select="$m_therearecurrently"/>
	<xsl:value-of select="APPROVEDENTRIES"/>
	<xsl:value-of select="$m_editedinguide"/>
	<xsl:apply-templates select="PROLIFICPOSTERS" mode="c_info"/>
	<xsl:apply-templates select="ERUDITEPOSTERS" mode="c_info"/>
	
 -->
	
	<xsl:apply-templates select="RECENTCONVERSATIONS" mode="c_info"/>
	<xsl:apply-templates select="FRESHESTARTICLES" mode="c_info"/>
	
	</xsl:template>
	<!--
	<xsl:template match="PROLIFICPOSTERS" mode="r_info">
	Description: Presentation of the object holding the PROLIFICPOSTERS
		and its title text
	 -->
	<xsl:template match="PROLIFICPOSTERS" mode="r_info">
		<xsl:value-of select="$m_toptenprolific"/>
		<xsl:apply-templates select="PROLIFICPOSTER" mode="c_info"/>
	</xsl:template>
	<!--
	<xsl:template match="PROLIFICPOSTER" mode="r_info">
	Description: Presentation of the PROLIFICPOSTER object
	 -->
	<xsl:template match="PROLIFICPOSTER" mode="r_info">
	<xsl:apply-templates select="USER" mode="t_info"/>
		<xsl:text> </xsl:text>
		<xsl:value-of select="COUNT"/>
		<xsl:apply-templates select="COUNT" mode="t_average"/>
		<xsl:value-of select="AVERAGESIZE"/>
		<br/>
	</xsl:template>
	<!--
	<xsl:template match="ERUDITEPOSTERS" mode="r_info">
	Description: Presentation of the object holding the ERUDITEPOSTERS
		and its title text
	 -->
	<xsl:template match="ERUDITEPOSTERS" mode="r_info">
		<xsl:value-of select="$m_toptenerudite"/>
		<xsl:apply-templates select="ERUDITEPOSTER" mode="c_info"/>
	</xsl:template>
	<!--
	<xsl:template match="ERUDITEPOSTER" mode="r_info">
	Description: Presentation of the ERUDITEPOSTER object
	 -->
	<xsl:template match="ERUDITEPOSTER" mode="r_info">
		<xsl:apply-templates select="USER" mode="t_info"/>
		<xsl:text> </xsl:text>
		<xsl:value-of select="COUNT"/>
		<xsl:apply-templates select="COUNT" mode="t_average"/>
		<xsl:value-of select="AVERAGESIZE"/>
		<br/>
	</xsl:template>
	<!--
	<xsl:template match="RECENTCONVERSATIONS" mode="r_info">
	Description: Presentation of the object holding the RECENTCONVERSATIONS
		and its title text
	 -->
	<xsl:template match="RECENTCONVERSATIONS" mode="r_info">
		<xsl:apply-templates select="RECENTCONVERSATION" mode="c_info"/>
	</xsl:template>




	<!--
	<xsl:template match="RECENTCONVERSATION" mode="r_info">
	Description: Presentation of the RECENTCONVERSATION object
	 -->
	<xsl:template match="RECENTCONVERSATION" mode="r_info">
		<div>
			<xsl:attribute name="class">
			<xsl:choose>
			<xsl:when test="count(preceding-sibling::RECENTCONVERSATION) mod 2 = 0">myspace-e-1</xsl:when><!-- alternate colours, MC -->
			<xsl:otherwise>myspace-e-2</xsl:otherwise>
			</xsl:choose>
			</xsl:attribute>
			<table cellspacing="0" cellpadding="0" border="0" width="395">
			<tr>
			<td rowspan="2" width="25" class="myspace-e-3">&nbsp;</td>
			<td class="brown">
			<xsl:element name="{$text.base}" use-attribute-sets="text.base">
				<strong><xsl:apply-templates select="." mode="t_info"/></strong>
			</xsl:element>
			</td>
			<td align="right">
				&nbsp;
			</td>
			</tr><tr>
			<td colspan="2" class="orange">
			<xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall">
			
				last comment: <a href="{$root}F{FORUMID}?thread={THREADID}&amp;latest=1"><xsl:apply-templates select="DATEPOSTED/DATE"/></a>

			</xsl:element>
			</td>
			</tr>
			</table>
		</div>
		</xsl:template>








	<!--
	<xsl:template match="FRESHESTARTICLES" mode="r_info">
	Description: Presentation of the object holding the FRESHESTARTICLES
		and its title text
	 -->
	<xsl:template match="FRESHESTARTICLES" mode="r_info">
		<xsl:apply-templates select="RECENTARTICLE[STATUS!=1]" mode="c_info"/>
	</xsl:template>
	<!--
	<xsl:template match="RECENTARTICLE" mode="r_info">
	Description: Presentation of the RECENTARTICLE object
	 -->
	<xsl:template match="RECENTARTICLE" mode="r_info">
		<div>
			<xsl:attribute name="class">
			<xsl:choose>					<!-- [STATUS=!1] as base does not select the type 1 articles -->
			<xsl:when test="count(preceding-sibling::RECENTARTICLE[STATUS!=1]) mod 2 = 0">myspace-e-1</xsl:when><!-- alternate colours, MC -->
			<xsl:otherwise>myspace-e-2</xsl:otherwise>
			</xsl:choose>
			</xsl:attribute>
			<table cellspacing="0" cellpadding="0" border="0" width="395">
			<tr>
			<td rowspan="2" width="25" class="myspace-e-3">&nbsp;</td>
			<td class="brown">
			<xsl:element name="{$text.base}" use-attribute-sets="text.base">
				<strong><xsl:apply-templates select="." mode="t_info"/></strong>
			</xsl:element>
			</td>
			<td align="right">
				&nbsp;
			</td>
			</tr><tr>
			<td colspan="2" class="orange">
			<xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall">
				last updated: <xsl:apply-templates select="DATEUPDATED/DATE" />
			</xsl:element>
			</td>
			</tr>
			</table>
		</div>
	</xsl:template>



</xsl:stylesheet>
