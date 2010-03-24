<?xml version="1.0" encoding="iso-8859-1"?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<xsl:import href="../../../base/base-indexpage.xsl"/>
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
									Page - Level  template
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<xsl:template name="INDEX_MAINBODY">
	<!-- DEBUG -->
	<xsl:call-template name="TRACE">
		<xsl:with-param name="message">INDEX_MAINBODY</xsl:with-param>
		<xsl:with-param name="pagename">indexpage.xsl</xsl:with-param>
	</xsl:call-template>
	<!-- DEBUG -->
	
		<table width="100%" cellpadding="5" cellspacing="0" border="0">
			<tr>
				<td valign="top">
					<font size="2">
						<xsl:call-template name="alphaindex"/>
						<br/>
						<br/>
						<xsl:apply-templates select="INDEX" mode="c_index"/>
					</font>
				</td>
			</tr>
		</table>
	</xsl:template>
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
							INDEX Object
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<xsl:template match="INDEX" mode="r_index">
		<xsl:apply-templates select="." mode="c_indexstatus"/>
		<br/>
		<br/>
		<table width="100%" cellspacing="0" cellpadding="0" border="0">
			<xsl:apply-templates select="INDEXENTRY" mode="c_index"/>
		</table>
		<br/>
		<br/>
		<xsl:apply-templates select="@SKIP" mode="c_index"/>
		<xsl:text> | </xsl:text>
		<xsl:apply-templates select="@MORE" mode="c_index"/>
	</xsl:template>
	<!--
	<xsl:template match="INDEXENTRY" mode="approved_index">
	Description: Presentation of the individual entries 	for the 
		approved articles index
	 -->
	<xsl:template match="INDEXENTRY" mode="approved_index">
		<tr valign="top">
			<td>
				<font xsl:use-attribute-sets="mainfont">A<xsl:apply-templates select="H2G2ID" mode="t_index"/>
				</font>
			</td>
			<td style="padding-left:10px;">
				<font xsl:use-attribute-sets="mainfont">
					<xsl:apply-templates select="SUBJECT" mode="t_index"/>
				</font>
			</td>
		</tr>
	</xsl:template>
	<!--
	<xsl:template match="INDEXENTRY" mode="unapproved_index">
	Description: Presentation of the individual entries 	for the 
		unapproved articles index
	 -->
	<xsl:template match="INDEXENTRY" mode="unapproved_index">
		<tr valign="top">
			<td>
				<font xsl:use-attribute-sets="mainfont">
					<xsl:apply-templates select="H2G2ID" mode="t_index"/>
				</font>
			</td>
			<td style="padding-left:10px;">
				<font xsl:use-attribute-sets="mainfont">
					<xsl:apply-templates select="SUBJECT" mode="t_index"/>
				</font>
			</td>
		</tr>
	</xsl:template>
	<!--
	<xsl:template match="INDEXENTRY" mode="submitted_index">
	Description: Presentation of the individual entries 	for the 
		submitted articles index
	 -->
	<xsl:template match="INDEXENTRY" mode="submitted_index">
		<tr valign="top">
			<td>
				<font xsl:use-attribute-sets="mainfont">
					<xsl:apply-templates select="H2G2ID" mode="t_index"/>
				</font>
			</td>
			<td style="padding-left:10px;">
				<font xsl:use-attribute-sets="mainfont">
					<xsl:apply-templates select="SUBJECT" mode="t_index"/>
				</font>
			</td>
		</tr>
	</xsl:template>
	<!--
	<xsl:template match="@MORE" mode="more_index">
	Description: Presentation of the 'Next Page' link
	 -->
	<xsl:template match="@MORE" mode="more_index">
		<xsl:apply-imports/>
	</xsl:template>
	<!--
	<xsl:template match="@MORE" mode="nomore_index">
	Description: Presentation of the 'No more pages' text
	 -->
	<xsl:template match="@MORE" mode="nomore_index">
		<xsl:apply-imports/>
	</xsl:template>
	<!--
	<xsl:template match="@SKIP" mode="previous_index">
	Description: Presentation of the 'Previous Page' link
	 -->
	<xsl:template match="@SKIP" mode="previous_index">
		<xsl:apply-imports/>
	</xsl:template>
	<!--
	<xsl:template match="@SKIP" mode="noprevious_index">
	Description: Presentation of the 'No previous pages' text
	 -->
	<xsl:template match="@SKIP" mode="noprevious_index">
		<xsl:apply-imports/>
	</xsl:template>
	<!--
	<xsl:template match="INDEX" mode="r_indexstatus">
	Description: Presentation of the index type selection area
	 -->
	<xsl:template match="INDEX" mode="r_indexstatus">
		<xsl:apply-templates select="." mode="t_approvedbox"/>
		<xsl:copy-of select="$m_editedentries"/>
		<xsl:text> </xsl:text>
		<xsl:apply-templates select="." mode="t_unapprovedbox"/>
		<xsl:value-of select="$m_guideentries"/>
		<xsl:text> </xsl:text>
		<xsl:apply-templates select="." mode="t_submittedbox"/>
		<xsl:value-of select="$m_awaitingappr"/>
		<xsl:text> </xsl:text>
		<xsl:apply-templates select="." mode="t_submit"/>
	</xsl:template>
	<!--
	<xsl:attribute-set name="iINDEX_t_approvedbox"/>
	Description: Attiribute set for the 'Approved' checkbox
	 -->
	<xsl:attribute-set name="iINDEX_t_approvedbox"/>
	<!--
	<xsl:attribute-set name="iINDEX_t_unapprovedbox"/>
	Description: Attiribute set for the 'Unapproved' checkbox
	 -->
	<xsl:attribute-set name="iINDEX_t_unapprovedbox"/>
	<!--
	<xsl:attribute-set name="iINDEX_t_submittedbox"/>
	Description: Attiribute set for the 'Submitted' checkbox
	 -->
	<xsl:attribute-set name="iINDEX_t_submittedbox"/>
	<!--
	<xsl:attribute-set name="iINDEX_t_submit"/>
	Description: Attiribute set for the submit button
	 -->
	<xsl:attribute-set name="iINDEX_t_submit">
		<xsl:attribute name="type">submit</xsl:attribute>
		<xsl:attribute name="value"><xsl:copy-of select="$m_refresh"/></xsl:attribute>
	</xsl:attribute-set>
</xsl:stylesheet>
