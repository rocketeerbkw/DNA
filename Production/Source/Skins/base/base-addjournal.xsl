<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<!--
	<xsl:template name="ADDJOURNAL_HEADER">
	Author:		Andy Harris
	Context:      H2G2
	Purpose:	 Creates the title for the page which sits in the html header
	-->
	<xsl:template name="ADDJOURNAL_HEADER">
		<xsl:apply-templates mode="header" select=".">
			<xsl:with-param name="title">
				<xsl:value-of select="$m_pagetitlestart"/>
				<xsl:value-of select="$m_addjournal"/>
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>
	<!--
	<xsl:template name="ADDJOURNAL_SUBJECT">
	Author:		Tom Whitehouse
	Context:      H2G2
	Purpose:	 Creates the text for the subject
	-->
	<xsl:template name="ADDJOURNAL_SUBJECT">
		<xsl:call-template name="SUBJECTHEADER">
			<xsl:with-param name="text">
				<xsl:value-of select="$m_addjournal"/>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<!--
	<xsl:template match="POSTJOURNALUNREG" mode="c_addjournal">
	Author:		Andy Harris
	Context:      /H2G2/POSTJOURNALUNREG
	Purpose:	 Calls the container for the POSTJOURNALUNREG
	-->
	<xsl:template match="POSTJOURNALUNREG" mode="c_addjournal">
		<xsl:apply-templates select="." mode="r_addjournal"/>
	</xsl:template>
	<!--
	<xsl:template match="POSTJOURNALUNREG" mode="r_addjournal">
	Author:		Andy Harris
	Context:      /H2G2/POSTJOURNALUNREG
	Purpose:	 Chooses the correct rerason for the inability to post
	-->
	<xsl:template match="POSTJOURNALUNREG" mode="r_addjournal">
		<xsl:choose>
			<xsl:when test="@RESTRICTED = 1">
				<xsl:call-template name="m_cantpostrestricted"/>
			</xsl:when>
			<xsl:when test="@REGISTERED = 1">
				<xsl:copy-of select="$m_cantpostagreedterms"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy-of select="$m_cantpostnotregistered"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="POSTJOURNALUNREG" mode="r_addjournal">
	Author:		Andy Harris
	Context:      /H2G2/POSTJOURNALFORM
	Purpose:	 Calls the container for the POSTJOURNALFORM
	-->
	<xsl:template match="POSTJOURNALFORM" mode="c_addjournal">
		<xsl:apply-templates select="." mode="r_addjournal"/>
	</xsl:template>
	<!--
	<xsl:template match="POSTJOURNALFORM" mode="c_journalformheader">
	Author:		Andy Harris
	Context:      /H2G2/POSTJOURNALFORM
	Purpose:	 Calls the correct container for the POSTJOURNALFORM header
	-->
	<xsl:template match="POSTJOURNALFORM" mode="c_journalformheader">
		<xsl:choose>
			<xsl:when test="WARNING">
				<xsl:apply-templates select="." mode="r_journalformheaderwarning"/>
			</xsl:when>
			<xsl:when test="PREVIEWBODY">
				<xsl:apply-templates select="." mode="r_journalformheaderpreview"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="." mode="r_journalformheaderintro"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="POSTJOURNALFORM" mode="c_journalform">
	Author:		Andy Harris
	Context:      /H2G2/POSTJOURNALFORM
	Purpose:	 Creates the form element for the add journal entry form
	-->
	<xsl:template match="POSTJOURNALFORM" mode="c_journalform">
		<form action="{$root}PostJournal" method="post" name="theForm" xsl:use-attribute-sets="fPOSTJOURNALFORM_r_journalform">
			<xsl:apply-templates select="." mode="r_journalform"/>
		</form>
	</xsl:template>
	<!--
	<xsl:template match="SUBJECT" mode="t_addjournalpage">
	Author:		Andy Harris
	Context:      /H2G2/POSTJOURNALFORM/SUBJECT
	Purpose:	 Creates the subject text entry element for the add journal entry form
	-->
	<xsl:template match="SUBJECT" mode="t_addjournalpage">
		<input name="subject" type="text" xsl:use-attribute-sets="iSUBJECT_t_addjournalpage">
			<xsl:attribute name="value"><xsl:value-of select="."/></xsl:attribute>
		</input>
	</xsl:template>
	<!--
	<xsl:template match="BODY" mode="t_addjournalpage">
	Author:		Andy Harris
	Context:      /H2G2/POSTJOURNALFORM/BODY
	Purpose:	 Creates the body text entry element for the add journal entry form
	-->
	<xsl:template match="BODY" mode="t_addjournalpage">
		<textarea xsl:use-attribute-sets="iBODY_t_addjournalpage" name="body">
			<xsl:value-of select="."/>
		</textarea>
	</xsl:template>
	<!--
	<xsl:template match="POSTJOURNALFORM" mode="t_previewbutton">
	Author:		Andy Harris
	Context:      /H2G2/POSTJOURNALFORM
	Purpose:	 Creates the preview button element for the add journal entry form
	-->
	<xsl:template match="POSTJOURNALFORM" mode="t_previewbutton">
		<input name="preview" xsl:use-attribute-sets="iPOSTJOURNALFORM_t_previewbutton"/>
	</xsl:template>
	<!--
	<xsl:template match="POSTJOURNALFORM" mode="t_submitbutton">
	Author:		Andy Harris
	Context:      /H2G2/POSTJOURNALFORM
	Purpose:	 Creates the submit button element for the add journal entry form
	-->
	<xsl:template match="POSTJOURNALFORM" mode="t_submitbutton">
		<input name="post" xsl:use-attribute-sets="iPOSTJOURNALFORM_t_submitbutton"/>
	</xsl:template>
	<xsl:attribute-set name="fPOSTJOURNALFORM_r_journalform"/>
	<xsl:attribute-set name="iSUBJECT_t_addjournalpage"/>
	<xsl:attribute-set name="iBODY_t_addjournalpage"/>
	<xsl:attribute-set name="iPOSTJOURNALFORM_t_previewbutton"/>
	<xsl:attribute-set name="iPOSTJOURNALFORM_t_submitbutton"/>
</xsl:stylesheet>
