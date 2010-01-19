<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
	<!ENTITY space "<xsl:text xmlns:xsl='http://www.w3.org/1999/XSL/Transform'> </xsl:text>">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<xsl:import href="../../../base/base-teamlistpage.xsl"/>
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
									Page - Level  template
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<xsl:template name="TEAMLIST_MAINBODY">
		<xsl:apply-templates select="TEAMLIST" mode="c_teamlist"/>
	</xsl:template>
	<!-- 
	<xsl:template match="TEAMLIST" mode="r_teamlist">
	Use: Presentation of the TEAMLIST object
	-->
	<xsl:template match="TEAMLIST" mode="r_teamlist">
		<xsl:apply-templates select="." mode="t_clubname"/>
		<br/>
		<br/>
		<xsl:apply-templates select="TEAM" mode="c_teamlist"/>
		<xsl:apply-templates select="." mode="c_previouspage"/>
		<xsl:apply-templates select="." mode="c_nextpage"/>
	</xsl:template>
	<!-- 
	<xsl:template match="TEAM" mode="r_teamlist">
	Use: Presentation of the TEAM object
	-->
	<xsl:template match="TEAM" mode="r_teamlist">
		<xsl:apply-templates select="." mode="t_introduction"/>
		<br/>
		<br/>
		<xsl:apply-templates select="MEMBER" mode="c_teamlist"/>
		<br/>
	</xsl:template>
	<!-- 
	<xsl:template match="MEMBER" mode="r_teamlist">
	Use: Presentation of the MEMBER object
	-->
	<xsl:template match="MEMBER" mode="r_teamlist">
		<xsl:apply-templates select="USER" mode="t_username"/>
		<xsl:apply-templates select="." mode="c_role"/>
		<br/>
	</xsl:template>
	<!-- 
	<xsl:template match="MEMBER" mode="r_role">
	Use: Presentation of the ROLE text
	-->
	<xsl:template match="MEMBER" mode="r_role">
		(<xsl:value-of select="ROLE"/>)
	</xsl:template>
	<!-- 
	<xsl:template match="TEAMLIST" mode="link_previouspage">
	Use: Presentation of the 'Previous Page' link
	-->
	<xsl:template match="TEAMLIST" mode="link_previouspage">
		<xsl:apply-imports/>
		<br/>
	</xsl:template>
	<!-- 
	<xsl:template match="TEAMLIST" mode="link_nextpage">
	Use: Presentation of the 'Next Page' link
	-->
	<xsl:template match="TEAMLIST" mode="link_nextpage">
		<xsl:apply-imports/>
		<br/>
	</xsl:template>
	<!-- 
	<xsl:template match="TEAMLIST" mode="text_previouspage">
	Use: Presentation of the 'No Previous Page' message
	-->
	<xsl:template match="TEAMLIST" mode="text_previouspage">
		<xsl:apply-imports/>
		<br/>
	</xsl:template>
	<!-- 
	<xsl:template match="TEAMLIST" mode="text_nextpage">
	Use: Presentation of the 'No Next Page' message
	-->
	<xsl:template match="TEAMLIST" mode="text_nextpage">
		<xsl:apply-imports/>
		<br/>
	</xsl:template>
</xsl:stylesheet>
