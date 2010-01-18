<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
	<!ENTITY space "<xsl:text xmlns:xsl='http://www.w3.org/1999/XSL/Transform'> </xsl:text>">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<xsl:import href="../../../base/base-cominguppage.xsl"/>
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
									Page - Level  template
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<xsl:template name="COMING-UP_MAINBODY">
		<xsl:apply-templates select="RECOMMENDATIONS" mode="c_comingup"/>
	</xsl:template>
	<!-- 
	<xsl:template match="RECOMMENDATIONS" mode="r_comingup">
	Use: Container for the RECOMMENDATIONS object
	-->
	<xsl:template match="RECOMMENDATIONS" mode="r_comingup">
		<xsl:call-template name="m_comingupintro"/>
		<xsl:apply-templates select="." mode="c_scouted"/>
		<xsl:apply-templates select="." mode="c_witheditor"/>
		<xsl:apply-templates select="." mode="c_returned"/>
	</xsl:template>
	<!-- 
	<xsl:template match="RECOMMENDATIONS" mode="r_scouted">
	Use: Container for the scouted RECOMMENDATIONS object
	-->
	<xsl:template match="RECOMMENDATIONS" mode="r_scouted">
		<xsl:copy-of select="$m_cominguprecheader"/>
		<xsl:call-template name="m_cominguprecintro"/>
		<xsl:apply-templates select="RECOMMENDATION" mode="c_scouted"/>
	</xsl:template>
	<!-- 
	<xsl:template match="RECOMMENDATION" mode="r_scouted">
	Use: Container for the scouted RECOMMENDATION object
	-->
	<xsl:template match="RECOMMENDATION" mode="r_scouted">
		<xsl:apply-templates select="ORIGINAL/H2G2ID" mode="t_entryid"/>
		<br/>
		<xsl:apply-templates select="SUBJECT" mode="t_subject"/>
		<br/>
	</xsl:template>
	<!-- 
	<xsl:template match="RECOMMENDATIONS" mode="r_witheditor">
	Use: Container for the with editor RECOMMENDATIONS object
	-->
	<xsl:template match="RECOMMENDATIONS" mode="r_witheditor">
		<xsl:copy-of select="$m_comingupwitheditorheader"/>
		<xsl:call-template name="m_comingupwitheditorintro"/>
		<xsl:apply-templates select="RECOMMENDATION" mode="c_witheditor"/>
	</xsl:template>
	<!-- 
	<xsl:template match="RECOMMENDATION" mode="r_witheditor">
	Use: Container for the with editor RECOMMENDATION object
	-->
	<xsl:template match="RECOMMENDATION" mode="r_witheditor">
		<xsl:apply-templates select="ORIGINAL/H2G2ID" mode="t_entryid"/>
		<br/>
		<xsl:apply-templates select="SUBJECT" mode="t_subject"/>
		<br/>
	</xsl:template>
	<!-- 
	<xsl:template match="RECOMMENDATIONS" mode="r_returned">
	Use: Container for the returned RECOMMENDATIONS object
	-->
	<xsl:template match="RECOMMENDATIONS" mode="r_returned">
		<xsl:copy-of select="$m_comingupreturnheader"/>
		<xsl:call-template name="m_comingupreturnintro"/>
		<xsl:apply-templates select="RECOMMENDATION" mode="c_returned"/>
	</xsl:template>
	<!-- 
	<xsl:template match="RECOMMENDATION" mode="r_returned">
	Use: Container for the returned RECOMMENDATION object
	-->
	<xsl:template match="RECOMMENDATION" mode="r_returned">
		<xsl:apply-templates select="EDITED/H2G2ID" mode="t_entryid"/>
		<br/>
		<xsl:apply-templates select="SUBJECT" mode="t_subject"/>
		<br/>
	</xsl:template>
</xsl:stylesheet>
