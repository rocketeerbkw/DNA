<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<!--
	<xsl:template name="SYSTEMMESSAGEMAILBOX_HEADER">
	Author:		Andy Harris
	Context:      H2G2
	Purpose:	 Creates the title for the page which sits in the html header
	-->
	<xsl:template name="SYSTEMMESSAGEMAILBOX_HEADER">
		<xsl:apply-templates mode="header" select=".">
			<xsl:with-param name="title">
				<xsl:value-of select="$m_pagetitlestart"/>
				<xsl:text>System Message Mailbox</xsl:text>
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>
	<!--
	<xsl:template name="SYSTEMMESSAGEMAILBOX_SUBJECT">
	Author:		Tom Whitehouse
	Context:      H2G2
	Purpose:	 Creates the text for the subject
	-->
	<xsl:template name="SYSTEMMESSAGEMAILBOX_SUBJECT">
		<xsl:call-template name="SUBJECTHEADER">
			<xsl:with-param name="text">
				<xsl:text>System Message Mailbox</xsl:text>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="SYSTEMMESSAGEMAILBOX" mode="c_systemmessagemailbox">
		<xsl:apply-templates select="." mode="r_systemmessagemailbox"/>
	</xsl:template>
	
	<xsl:template match="SYSTEMMESSAGEMAILBOX" mode="c_pagination">
		<xsl:apply-templates select="." mode="r_pagination"/>
	</xsl:template>
	
	<xsl:template match="SYSTEMMESSAGEMAILBOX" mode="t_pagination_pagecount">
		<xsl:text>Page </xsl:text>
		<xsl:value-of select="floor(@SKIP div @SHOW) + 1"/>
		<xsl:text> of </xsl:text>
		<xsl:value-of select="ceiling(@TOTALCOUNT div @SHOW)"/>
	</xsl:template>

	
	<xsl:template match="SYSTEMMESSAGEMAILBOX" mode="t_pagination_firstpage">
		<xsl:if test="(@TOTALCOUNT &gt; @SHOW) and not(@SKIP = 0)">
			<a href="SMM?userid={@USERID}&amp;skip=0&amp;show={@SHOW}">
				<xsl:text>&lt; &lt;</xsl:text>
			</a>
			<xsl:text> | </xsl:text>
		</xsl:if>
	</xsl:template>

	<xsl:template match="SYSTEMMESSAGEMAILBOX" mode="t_pagination_prevpage">
		<xsl:if test="@SKIP &gt; 0">
			<a href="SMM?userid={@USERID}&amp;show={@SHOW}&amp;skip={@SKIP - @SHOW}">
				<xsl:text>&lt;</xsl:text>
			</a>
			<xsl:text> | </xsl:text>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="SYSTEMMESSAGEMAILBOX" mode="t_pagination_nextpage">
		<xsl:if test="(@SKIP + @SHOW) &lt; @TOTALCOUNT">
			<xsl:text> | </xsl:text>
			<a href="SMM?userid={@USERID}&amp;show={@SHOW}&amp;skip={@SKIP + @SHOW}">
				<xsl:text>&gt;</xsl:text>
			</a>
		</xsl:if>
	</xsl:template>

	<xsl:template match="SYSTEMMESSAGEMAILBOX" mode="t_pagination_lastpage">
		<xsl:if test="not(@SKIP + @SHOW &gt;= @TOTALCOUNT)">
			<xsl:text> | </xsl:text>
			<a href="SMM?userid={@USERID}&amp;show={@SHOW}&amp;skip={((ceiling(@TOTALCOUNT div @SHOW) * @SHOW) - @SHOW)}">
				<xsl:text>&gt; &gt;</xsl:text>
			</a>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="MESSAGE" mode="c_systemmessagemailbox">
		<xsl:apply-templates select="." mode="r_systemmessagemailbox"/>
	</xsl:template>
	
	<xsl:template match="BODY" mode="c_systemmessagemailbox">
		<xsl:apply-templates select="." mode="r_systemmessagemailbox"/>
	</xsl:template>
	
	<xsl:template match="DATEPOSTED" mode="c_systemmessagemailbox">
		<xsl:apply-templates select="." mode="r_systemmessagemailbox"/>
	</xsl:template>
	
	<xsl:template match="DATE" mode="c_systemmessagemailbox">
		<xsl:apply-templates select="." mode="r_systemmessagemailbox"/>
	</xsl:template>
	
	<xsl:template match="@MSGID" mode="c_systemmessagemailbox">
		<xsl:apply-templates select="." mode="r_systemmessagemailbox"/>
	</xsl:template>

	<xsl:template match="@MSGID" mode="t_deletesystemmessage">
		<a xsl:use-attribute-sets="maMSGID_t_deletesystemmessage" href="{$root}SMM?cmd=delete&amp;msgid={.}">
			<xsl:text>Delete message</xsl:text>
		</a>
	</xsl:template>
	<xsl:attribute-set name="maMSGID_t_deletesystemmessage"/>
</xsl:stylesheet>


