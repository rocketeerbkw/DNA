<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<xsl:template name="SUBBED-ARTICLE-STATUS_SUBJECT">
		<xsl:call-template name="SUBJECTHEADER">
			<xsl:with-param name="text">Subbed Article Status</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template name="SUBBED-ARTICLE-STATUS_MAINBODY">
		<xsl:if test="ERROR">
		No details were found for the article ID <xsl:value-of select="ERROR/@H2G2ID"/>
			<br/>
		</xsl:if>
		<xsl:apply-templates select="SUBBED-ARTICLES"/>
	</xsl:template>
	<xsl:template match="SUBBED-ARTICLES">
	<TABLE>
<xsl:for-each select="ARTICLEDETAILS">
	<TR>
	<TD>ID:</TD>
	<TD><A href="{$root}A{H2G2ID}" TARGET="_blank">A<xsl:value-of select="H2G2ID"/></A></TD>
	</TR>
	<TR>
	<TD>Subject: </TD>
	<TD><xsl:value-of select="SUBJECT"/></TD>
	</TR>
	<TR>
	<TD>Based on:</TD>
	<TD><A href="{$root}A{ORIGINALH2G2ID}" TARGET="_blank">A<xsl:value-of select="ORIGINALH2G2ID"/></A></TD>
	</TR>
	<TR>
	<TD>Accepted by:</TD>
	<TD><A href="{$root}InspectUser?UserID={ACCEPTOR/USERID}" TARGET="_blank"><xsl:value-of select="ACCEPTOR/USERNAME"/></A></TD>
	</TR>
	<TR>
	<TD>Allocated by:</TD>
	<TD><A href="{$root}InspectUser?UserID={ALLOCATOR/USERID}" TARGET="_blank"><xsl:value-of select="ALLOCATOR/USERNAME"/></A></TD>
	</TR>
	<TR>
	<TR>
	<TD>SubEditor:</TD>
	<TD><A href="{$root}InspectUser?UserID={SUBEDITOR/USERID}" TARGET="_blank"><xsl:value-of select="SUBEDITOR/USERNAME"/></A></TD>
	</TR>
	<TD>Date allocated</TD>
	<TD>
	<xsl:choose>
		<xsl:when test="DATEALLOCATED">
			<xsl:apply-templates select="DATEALLOCATED/DATE"/>
		</xsl:when>
		<xsl:otherwise>
			Not yet allocated
		</xsl:otherwise>
	</xsl:choose>
	</TD>
	</TR>
	<TR>
	<TD>Date returned</TD>
	<TD>
	<xsl:choose>
		<xsl:when test="DATERETURNED">
			<xsl:apply-templates select="DATERETURNED/DATE"/>
		</xsl:when>
		<xsl:otherwise>
			Not yet returned
		</xsl:otherwise>
	</xsl:choose>
	</TD>
	</TR>
	<TR>
	<TD>Notification sent:</TD>
	<TD>
	<xsl:choose>
		<xsl:when test="NOTIFICATION=1">
			Yes
		</xsl:when>
		<xsl:otherwise>
			No
		</xsl:otherwise>
	</xsl:choose>
	</TD>
	</TR>
	<TR>
	<TD>Status:</TD>
	<TD>
	<xsl:choose>
		<xsl:when test="STATUS=1">
			Accepted
		</xsl:when>
		<xsl:when test="STATUS=2">
			Allocated
		</xsl:when>
		<xsl:when test="STATUS=3">
			Returned
		</xsl:when>
		<xsl:otherwise>
			Unknown status (<xsl:value-of select="STATUS"/>)
		</xsl:otherwise>
	</xsl:choose>
	</TD>
	</TR>
	<TR>
	<TD>
		Comments:
	</TD>
	<TD>
		<xsl:value-of select="COMMENTS"/>
	</TD>
	</TR>
</xsl:for-each>
	</TABLE>
</xsl:template>
</xsl:stylesheet>