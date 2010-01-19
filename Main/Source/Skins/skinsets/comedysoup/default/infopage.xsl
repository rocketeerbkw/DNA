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
		<xsl:with-param name="message">INFO_MAINBODY</xsl:with-param>
		<xsl:with-param name="pagename">infopage.xsl</xsl:with-param>
	</xsl:call-template>
	<!-- DEBUG -->
	
		<table width="100%" cellpadding="0" cellspacing="0" border="0">
			<tr>
				<td>
					<font xsl:use-attribute-sets="mainfont">
						<xsl:apply-templates select="INFO" mode="c_info"/>
					</font>
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
		<table cellpadding="5" cellspacing="0" border="0">
			<tr>
				<td>
					<font xsl:use-attribute-sets="mainfont">
						<strong>
							<xsl:value-of select="$m_totalregusers"/>
						</strong>
						<br/>
						<strong><xsl:value-of select="TOTALREGUSERS"/></strong>
						<xsl:text> </xsl:text>
						<xsl:value-of select="$m_usershaveregistered"/>
						<br/>
						<br/>
						<strong>
							<xsl:value-of select="$m_editedentries"/>
						</strong>
						<br/>
						<xsl:value-of select="$m_therearecurrently"/>
						<xsl:text> </xsl:text>
						<strong><xsl:value-of select="APPROVEDENTRIES"/></strong>
						<xsl:text> </xsl:text>
						<xsl:value-of select="$m_editedinguide"/>
					</font>
				</td>
			</tr>
			<tr>
				<td>
				<font xsl:use-attribute-sets="mainfont">	<xsl:apply-templates select="PROLIFICPOSTERS" mode="c_info"/></font>
				</td>
			</tr>
			<tr>
				<td>
		<font xsl:use-attribute-sets="mainfont">	<xsl:apply-templates select="ERUDITEPOSTERS" mode="c_info"/></font>
				</td>
			</tr>
			<tr>
				<td>
					<xsl:apply-templates select="RECENTCONVERSATIONS" mode="c_info"/>
				</td>
			</tr>
			<tr>
				<td>
					<xsl:apply-templates select="FRESHESTARTICLES" mode="c_info"/>
				</td>
			</tr>
		</table>
	</xsl:template>
	<!--
	<xsl:template match="PROLIFICPOSTERS" mode="r_info">
	Description: Presentation of the object holding the PROLIFICPOSTERS
		and its title text
	 -->
	<xsl:template match="PROLIFICPOSTERS" mode="r_info">
		
			<strong>
				<xsl:value-of select="$m_toptenprolific"/>
			</strong>
			<br/>
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
		<font xsl:use-attribute-sets="mainfont">
			<strong>
				<xsl:value-of select="$m_toptenerudite"/>
			</strong>
			<br/>
			<xsl:apply-templates select="ERUDITEPOSTER" mode="c_info"/>
		</font>
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
		<font xsl:use-attribute-sets="mainfont">
			<strong>
				<xsl:value-of select="$m_toptwentyupdated"/>
			</strong>
			<br/>
			<xsl:apply-templates select="RECENTCONVERSATION" mode="c_info"/>
		</font>
	</xsl:template>
	<!--
	<xsl:template match="RECENTCONVERSATION" mode="r_info">
	Description: Presentation of the RECENTCONVERSATION object
	 -->
	<xsl:template match="RECENTCONVERSATION" mode="r_info">
		<xsl:apply-templates select="." mode="t_info"/>
		<font size="1">
			(<xsl:apply-templates select="DATEPOSTED/DATE" mode="t_info"/>)
		</font>
		<br/>
	</xsl:template>
	<!--
	<xsl:template match="FRESHESTARTICLES" mode="r_info">
	Description: Presentation of the object holding the FRESHESTARTICLES
		and its title text
	 -->
	<xsl:template match="FRESHESTARTICLES" mode="r_info">
		<font xsl:use-attribute-sets="mainfont">
			<strong>
				<xsl:value-of select="$m_toptenupdatedarticles"/>
			</strong>
			<br/>
			<xsl:apply-templates select="RECENTARTICLE" mode="c_info"/>
		</font>
	</xsl:template>
	<!--
	<xsl:template match="RECENTARTICLE" mode="r_info">
	Description: Presentation of the RECENTARTICLE object
	 -->
	<xsl:template match="RECENTARTICLE" mode="r_info">
	<font xsl:use-attribute-sets="mainfont">	<xsl:value-of select="H2G2ID"/>
		<xsl:text> </xsl:text>
		<xsl:apply-templates select="." mode="t_info"/>
		<font size="1">
			(<xsl:apply-templates select="DATEUPDATED/DATE" mode="t_info"/>)
			<xsl:apply-templates select="STATUS" mode="t_info"/>
		</font>
		<br/></font>
	</xsl:template>
</xsl:stylesheet>
