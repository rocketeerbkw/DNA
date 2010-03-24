<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
	<!ENTITY space "<xsl:text xmlns:xsl='http://www.w3.org/1999/XSL/Transform'> </xsl:text>">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<xsl:import href="../../../base/base-addjournal.xsl"/>
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
									Page - Level  template
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<xsl:template name="ADDJOURNAL_MAINBODY">
	<!-- DEBUG -->
	<xsl:call-template name="TRACE">
	<xsl:with-param name="message">ADDJOURNAL_MAINBODY</xsl:with-param>
	<xsl:with-param name="pagename">addjournalpage.xsl</xsl:with-param>
	</xsl:call-template>
	<!-- DEBUG -->
		<table width="100%" cellpadding="5" cellspacing="0" border="0">
			<tr>
				<td>
					<font xsl:use-attribute-sets="mainfont">
						<xsl:apply-templates select="POSTJOURNALUNREG" mode="c_addjournal"/>
						<xsl:apply-templates select="POSTJOURNALFORM" mode="c_addjournal"/>
					</font>
				</td>
			</tr>
		</table>
	</xsl:template>
	<xsl:template match="POSTJOURNALUNREG" mode="r_addjournal">
		<xsl:apply-imports/>
	</xsl:template>
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
					POSTJOURNALFORM Logical Container Template
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<!-- 
	<xsl:template match="POSTJOURNALFORM">
	Use: Container for the header (preview / warning / intro) and the actual form. May contain
	a post / pre moderation message
	-->
	<xsl:template match="POSTJOURNALFORM" mode="r_addjournal">
		<xsl:apply-templates select="." mode="c_journalformheader"/>
		<!--<xsl:call-template name="postpremoderationmessage"/>-->
		<xsl:apply-templates select="." mode="c_journalform"/>
	</xsl:template>
	<!-- 
	<xsl:template match="POSTJOURNALFORM" mode="r_journalformheaderwarning">
	Use: Used if the header contains a warning
	-->
	<xsl:template match="POSTJOURNALFORM" mode="r_journalformheaderwarning">
		<xsl:value-of select="$m_warningcolon"/>
		<xsl:value-of select="WARNING"/>
	</xsl:template>
	<!-- 
	<xsl:template match="POSTJOURNALFORM" mode="r_journalformheaderpreview">
	Use: Used if the header contains a preview
	-->
	<xsl:template match="POSTJOURNALFORM" mode="r_journalformheaderpreview">
		<font size="2">
			<br/>
			<xsl:value-of select="$m_journallooklike"/>
			<br/>
			<strong>
				<xsl:value-of select="SUBJECT"/>
			</strong>
			&nbsp;
			<font size="1">(<xsl:value-of select="$m_soon"/>)</font>
			<br/>
			<xsl:value-of select="PREVIEWBODY"/>
			<br/>
			<br/>
		</font>
	</xsl:template>
	<!-- 
	<xsl:template match="POSTJOURNALFORM" mode="intro">
	Use: Used if the header contains an intro
	-->
	<xsl:template match="POSTJOURNALFORM" mode="r_journalformheaderintro">
		<xsl:copy-of select="$m_journalintroUI"/>
	</xsl:template>
	<!-- 
	<xsl:template match="POSTJOURNALFORM" mode="Form">
	Use: container for the actual jornal posting form
	-->
	<xsl:template match="POSTJOURNALFORM" mode="r_journalform">
		<font size="2">
			<strong>
				<xsl:value-of select="$m_fsubject"/>
			</strong>
			<br/>
			<xsl:apply-templates select="SUBJECT" mode="t_addjournalpage"/>
			<br/>
			<xsl:apply-templates select="BODY" mode="t_addjournalpage"/>
			<br/>
			<div align="right">
				<xsl:apply-templates select="." mode="t_previewbutton"/>
				<br/>
				<xsl:apply-templates select="." mode="t_submitbutton"/>
			</div>
		</font>
	</xsl:template>
	<!--
	<xsl:attribute-set name="fPOSTJOURNALFORM_r_journalform"/>
	Use: Presentation attributes for the journal submit <form> element
	        (may be required for JavaScript)
	 -->
	<xsl:attribute-set name="fPOSTJOURNALFORM_r_journalform"/>
	<!--
	<xsl:attribute-set name="iSUBJECT_t_addjournalpage"/>
	Use: Presentation attributes for the Journal Subject <input> field
	 -->
	<xsl:attribute-set name="iSUBJECT_t_addjournalpage"/>
	<!--
	<xsl:attribute-set name="iBODY_t_addjournalpage"/>
	Use: Presentation attributes for the Journal Body <textarea> field
	 -->
	<xsl:attribute-set name="iBODY_t_addjournalpage">
		<xsl:attribute name="cols">70</xsl:attribute>
		<xsl:attribute name="rows">15</xsl:attribute>
		<xsl:attribute name="wrap">VIRTUAL</xsl:attribute>
	</xsl:attribute-set>
	<!--
	<xsl:attribute-set name="sPOSTJOURNALFORM_t_previewbutton"/>
	Use: Presentation attributes for the journal preview submit button
	 -->
	<xsl:attribute-set name="iPOSTJOURNALFORM_t_previewbutton">
		<xsl:attribute name="type">submit</xsl:attribute>
		<xsl:attribute name="value"><xsl:value-of select="$m_previewjournal"/></xsl:attribute>
	</xsl:attribute-set>
	<!--
	<xsl:attribute-set name="sPOSTJOURNALFORM_t_submitbutton"/>
	Use: Presentation attributes for the journal submit button
	 -->
	<xsl:attribute-set name="iPOSTJOURNALFORM_t_submitbutton">
		<xsl:attribute name="type">submit</xsl:attribute>
		<xsl:attribute name="value"><xsl:value-of select="$m_storejournal"/></xsl:attribute>
	</xsl:attribute-set>
</xsl:stylesheet>
