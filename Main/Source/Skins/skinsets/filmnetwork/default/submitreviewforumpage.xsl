<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
	<!ENTITY space "<xsl:text xmlns:xsl='http://www.w3.org/1999/XSL/Transform'> </xsl:text>">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<xsl:import href="../../../base/base-submitreviewforumpage.xsl"/>
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
									Page - Level  template
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<xsl:template name="SUBMITREVIEWFORUM_MAINBODY">
		<xsl:apply-templates select="SUBMIT-REVIEW-FORUM" mode="c_srfpage"/>
	</xsl:template>
	<!-- 
	<xsl:template match="SUBMIT-REVIEW-FORUM" mode="reviewforums_srfpage">
	Use: Container for the text and calls to the form and any error messages
	-->
	<xsl:template match="SUBMIT-REVIEW-FORUM" mode="reviewforums_srfpage">
		<xsl:apply-templates select="ERROR" mode="c_errormessage"/>
		<xsl:copy-of select="$m_srfinitialtext"/>
		<br/>
		<br/>
		<xsl:apply-templates select="." mode="c_submitform"/>
		<br/>
		<xsl:copy-of select="$m_srffinaltext"/>
	</xsl:template>
	<!-- 
	<xsl:template match="ERROR" mode="r_errormessage">
	Use: Container for any error messages that appear with the submission form
	-->
	<xsl:template match="ERROR" mode="r_errormessage">
		<xsl:apply-imports/>
	</xsl:template>
	<!-- 
	<xsl:template match="ERROR" mode="r_errormessage">
	Use: Container for the submission form
	-->
	<xsl:template match="SUBMIT-REVIEW-FORUM" mode="r_submitform">
		<xsl:apply-templates select="REVIEWFORUMS" mode="t_forumselect"/>
		<br/>
		<xsl:apply-templates select="." mode="t_responsetext"/>
		<br/>
		<xsl:apply-templates select="." mode="t_submit"/>
	</xsl:template>
	<!-- 
	<xsl:template match="SUBMIT-REVIEW-FORUM" mode="newthread_srfpage">
	Use: Container for the new thread message
	-->
	<xsl:template match="SUBMIT-REVIEW-FORUM" mode="newthread_srfpage">
		<xsl:call-template name="m_entrysubmittedtoreviewforum"/>
	</xsl:template>
	<!-- 
	<xsl:template match="SUBMIT-REVIEW-FORUM" mode="error_srfpage">
	Use: Container for the error message without submission form
	-->
	<xsl:template match="SUBMIT-REVIEW-FORUM" mode="error_srfpage">
		<xsl:apply-templates select="ERROR" mode="c_error"/>
	</xsl:template>
	<!-- 
	<xsl:template match="SUBMIT-REVIEW-FORUM" mode="error_srfpage">
	Use: Container for the bad h2g2 id error message
	-->
	<xsl:template match="ERROR" mode="badh2g2id_error">
		<xsl:value-of select="$m_followingerror"/>
		<xsl:value-of select="MESSAGE"/>
		<xsl:apply-templates select="." mode="t_badh2g2idlink"/>
	</xsl:template>
	<!-- 
	<xsl:template match="ERROR" mode="badrfid_error">
	Use: Container for the bad review forum id error message
	-->
	<xsl:template match="ERROR" mode="badrfid_error">
		<xsl:value-of select="$m_followingerror"/>
		<xsl:value-of select="MESSAGE"/>
		<xsl:apply-templates select="." mode="t_badrfidlink"/>
	</xsl:template>
	<!-- 
	<xsl:template match="ERROR" mode="default_error">
	Use: Container for any default error messages
	-->
	<xsl:template match="ERROR" mode="default_error">
		<xsl:value-of select="$m_followingerror"/>
		<xsl:value-of select="MESSAGE"/>
		<xsl:apply-templates select="." mode="t_defaultlink"/>
	</xsl:template>
	<!-- 
	<xsl:template match="SUBMIT-REVIEW-FORUM" mode="movedthread_srfpage">
	Use: Container for the thread moved message
	-->
	<xsl:template match="SUBMIT-REVIEW-FORUM" mode="movedthread_srfpage">
		<xsl:call-template name="m_removefromreviewsuccesslink"/>
	</xsl:template>
	<!-- 
	<xsl:attribute-set name="fSUBMIT-REVIEW-FORUM_c_submitform"/>
	Use: Attribute set for the form element
	-->
	<xsl:attribute-set name="fSUBMIT-REVIEW-FORUM_c_submitform"/>
	<!-- 
	<xsl:attribute-set name="sREVIEWFORUMS_t_forumselect"/>
	Use: Attribute set for the select element
	-->
	<xsl:attribute-set name="sREVIEWFORUMS_t_forumselect"/>
	<!-- 
	<xsl:attribute-set name="oREVIEWFORUMS_t_forumselect"/>
	Use: Attribute set for the option element
	-->
	<xsl:attribute-set name="oREVIEWFORUMS_t_forumselect"/>
	<!-- 
	<xsl:attribute-set name="iSUBMIT-REVIEW-FORUM_t_responsetext">
	Use: Attribute set for the textarea element
	-->
	<xsl:attribute-set name="iSUBMIT-REVIEW-FORUM_t_responsetext">
		<xsl:attribute name="cols">15</xsl:attribute>
		<xsl:attribute name="rows">5</xsl:attribute>
	</xsl:attribute-set>
	<!-- 
	<xsl:attribute-set name="iSUBMIT-REVIEW-FORUM_t_submit">
	Use: Attribute set for the submit element
	-->
	<xsl:attribute-set name="iSUBMIT-REVIEW-FORUM_t_submit">
		<xsl:attribute name="value"><xsl:value-of select="$m_submittoreviewforumbutton"/></xsl:attribute>
		<xsl:attribute name="type">submit</xsl:attribute>
		<xsl:attribute name="title"><xsl:value-of select="$alt_submittoreviewforumbutton"/></xsl:attribute>
	</xsl:attribute-set>
</xsl:stylesheet>
