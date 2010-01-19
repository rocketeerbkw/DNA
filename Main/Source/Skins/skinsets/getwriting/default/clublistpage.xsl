<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
	<!ENTITY space "<xsl:text xmlns:xsl='http://www.w3.org/1999/XSL/Transform'> </xsl:text>">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">


	<xsl:template name="CLUBLIST_HEADER">
	<!-- DEBUG -->
	<xsl:call-template name="TRACE">
	<xsl:with-param name="message">CLUBLIST_HEADER</xsl:with-param>
	<xsl:with-param name="pagename">clublistpage.xsl</xsl:with-param>
	</xsl:call-template>
	<!-- DEBUG -->
	
	<xsl:apply-templates mode="header" select=".">
		<xsl:with-param name="title">club list</xsl:with-param>
	</xsl:apply-templates>
		
	</xsl:template>
	
	<xsl:template name="CLUBLIST_MAINBODY">
    <!-- DEBUG -->
	<xsl:call-template name="TRACE">
	<xsl:with-param name="message">CLUBLIST_MAINBODY</xsl:with-param>
	<xsl:with-param name="pagename">clubpage.xsl</xsl:with-param>
	</xsl:call-template>
	<!-- DEBUG -->
	
		<font size="2">
			Clubs: <xsl:value-of select="CLUBLIST/@COUNT"/>
			<br/>
			<xsl:apply-templates select="CLUBLIST/CLUB" mode="clublist">
				<xsl:sort select="@ID" order="descending" data-type="number"/>
			</xsl:apply-templates>
		</font>
		
	</xsl:template>
	
	<xsl:template match="CLUB" mode="clublist">
		<font size="3">
			<b>
				<a href="{$root}G{@ID}">
					<xsl:value-of select="NAME"/>
				</a>
			</b>
			(Club <xsl:value-of select="@ID"/>)
		</font>
		<br/>
		<b>Date created: </b>
		<xsl:value-of select="@DATECREATED"/>
		<br/>
		<b>Description:</b>
		<xsl:apply-templates select="EXTRAINFO/AUTODESCRIPTION"/>
		<br/>
<!-- 		<b>Why they want it:</b>
		<xsl:apply-templates select="EXTRAINFO/REASON"/> -->
		<br/>
		<br/>
	</xsl:template>
	
</xsl:stylesheet>
