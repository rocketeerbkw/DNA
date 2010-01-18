<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<!--
	<xsl:template name="COMING-UP_HEADER">
	Author:		Andy Harris
	Context:      H2G2
	Purpose:	 Creates the title for the page which sits in the html header
	-->
	<xsl:template name="COMING-UP_HEADER">
		<xsl:apply-templates mode="header" select=".">
			<xsl:with-param name="title">
				<xsl:value-of select="$m_pagetitlestart"/>
				<xsl:value-of select="$m_whatscomingupheader"/>
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>
	<!--
	<xsl:template name="COMING-UP_SUBJECT">
	Author:		Andy Harris
	Context:      H2G2
	Purpose:	 Creates the text for the subject
	-->
	<xsl:template name="COMING-UP_SUBJECT">
		<xsl:call-template name="SUBJECTHEADER">
			<xsl:with-param name="text">
				<xsl:value-of select="$m_whatscomingupheader"/>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<!--
	<xsl:template match="RECOMMENDATIONS" mode="c_comingup">
	Author:		Andy Harris
	Context:      H2G2/RECOMMENDATIONS
	Purpose:	 Calls the container for the RECOMMENDATIONS object
	-->
	<xsl:template match="RECOMMENDATIONS" mode="c_comingup">
		<xsl:apply-templates select="." mode="r_comingup"/>
	</xsl:template>
	<!--
	<xsl:template match="RECOMMENDATIONS" mode="c_scouted">
	Author:		Andy Harris
	Context:      H2G2/RECOMMENDATIONS
	Purpose:	 Calls the container for the scouted recommendations if there are any
	-->
	<xsl:template match="RECOMMENDATIONS" mode="c_scouted">
		<xsl:if test="RECOMMENDATION[ACCEPTEDSTATUS = 1 and GUIDESTATUS = 4]">
			<xsl:apply-templates select="." mode="r_scouted"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="RECOMMENDATIONS" mode="c_witheditor">
	Author:		Andy Harris
	Context:      H2G2/RECOMMENDATIONS
	Purpose:	 Calls the container for the with editor recommendations if there are any
	-->
	<xsl:template match="RECOMMENDATIONS" mode="c_witheditor">
		<xsl:if test="RECOMMENDATION[ACCEPTEDSTATUS = 2 and GUIDESTATUS = 4]">
			<xsl:apply-templates select="." mode="r_witheditor"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="RECOMMENDATIONS" mode="c_returned">
	Author:		Andy Harris
	Context:      H2G2/RECOMMENDATIONS
	Purpose:	 Calls the container for the returned recommendations if there are any
	-->
	<xsl:template match="RECOMMENDATIONS" mode="c_returned">
		<xsl:if test="RECOMMENDATION[ACCEPTEDSTATUS = 3 and (GUIDESTATUS = 6 or GUIDESTATUS = 13)]">
			<xsl:apply-templates select="." mode="r_returned"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="RECOMMENDATION" mode="c_scouted">
	Author:		Andy Harris
	Context:      H2G2/RECOMMENDATIONS/RECOMMENDATION
	Purpose:	 Calls the container for the each scouted recommendation
	-->
	<xsl:template match="RECOMMENDATION" mode="c_scouted">
		<xsl:if test="ACCEPTEDSTATUS = 1 and GUIDESTATUS = 4">
			<xsl:apply-templates select="." mode="r_scouted"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="RECOMMENDATION" mode="c_witheditor">
	Author:		Andy Harris
	Context:      H2G2/RECOMMENDATIONS/RECOMMENDATION
	Purpose:	 Calls the container for the each with editor recommendation
	-->
	<xsl:template match="RECOMMENDATION" mode="c_witheditor">
		<xsl:if test="ACCEPTEDSTATUS = 2 and GUIDESTATUS = 4">
			<xsl:apply-templates select="." mode="r_witheditor"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="RECOMMENDATION" mode="c_returned">
	Author:		Andy Harris
	Context:      H2G2/RECOMMENDATIONS/RECOMMENDATION
	Purpose:	 Calls the container for the each returned recommendation
	-->
	<xsl:template match="RECOMMENDATION" mode="c_returned">
		<xsl:if test="ACCEPTEDSTATUS = 3 and (GUIDESTATUS = 6 or GUIDESTATUS = 13)">
			<xsl:apply-templates select="." mode="r_returned"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="H2G2ID" mode="t_entryid">
	Author:		Andy Harris
	Context:      H2G2/RECOMMENDATIONS/RECOMMENDATION/ORGINAL/H2G2ID or H2G2/RECOMMENDATIONS/RECOMMENDATION/EDITED/H2G2ID
	Purpose:	 Creates the H2G2ID link
	-->
	<xsl:template match="H2G2ID" mode="t_entryid">
		<a href="{$root}A{.}">
			A<xsl:value-of select="."/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="SUBJECT" mode="t_subject">
	Author:		Andy Harris
	Context:      H2G2/RECOMMENDATIONS/RECOMMENDATION/SUBJECT
	Purpose:	 Creates the SUBJECT link
	-->
	<xsl:template match="SUBJECT" mode="t_subject">
		<xsl:choose>
			<xsl:when test="../ACCEPTEDSTATUS = 3 and (../GUIDESTATUS = 6 or ../GUIDESTATUS = 13)">
				<a href="{$root}A{../EDITED/H2G2ID}">
					<xsl:value-of select="."/>
				</a>
			</xsl:when>
			<xsl:otherwise>
				<a href="{$root}A{../ORIGINAL/H2G2ID}">
					<xsl:value-of select="."/>
				</a>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
