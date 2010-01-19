<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<xsl:import href="../../../base/base-usercomplaintpopup.xsl"/>
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
									Page - Level  template
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->

	
	<xsl:template name="USERCOMPLAINT_MAINBODY">
		<xsl:apply-templates select="USER-COMPLAINT-FORM" mode="c_complaint"/>
	</xsl:template>
	<xsl:template match="USER-COMPLAINT-FORM" mode="form_complaint">
		<xsl:apply-templates select="." mode="t_introduction"/>
		<xsl:apply-templates select="." mode="c_form"/>
	</xsl:template>
	<xsl:template match="USER-COMPLAINT-FORM" mode="r_form">
		<xsl:apply-templates select="." mode="t_textarea"/>
		<br/>
		<xsl:call-template name="m_complaintpopupemailaddresslabel"/>
		<br/>
		<xsl:apply-templates select="." mode="t_email"/>
		<br/>
		<xsl:apply-templates select="." mode="t_submit"/>
		<br/>
		<xsl:apply-templates select="." mode="t_cancel"/>
	</xsl:template>
	<xsl:template match="USER-COMPLAINT-FORM" mode="success_complaint">
		<xsl:value-of select="$m_complaintsuccessfullyregisteredmessage"/>
		<br/>
		<xsl:text>Your complaint reference number is:</xsl:text>
		<br/>
		<xsl:value-of select="MODERATION-REFERENCE"/>
		<br/>
		<xsl:apply-templates select="." mode="t_close"/>
	</xsl:template>
	
	<xsl:template name="USERCOMPLAINT_JAVASCRIPT">
	<script type="text/javascript">
	<xsl:comment>
	function CheckEmailFormat(email){
		if (email.length &lt; 5)	{
			return false;
		}

		var atIndex = email.indexOf('@');
	
		if (atIndex &lt; 1){
			return false;
		}

		var lastDotIndex = email.lastIndexOf('.');
		
		if (lastDotIndex &lt; atIndex + 2){
			return false;
		}
		
		return true;
	}

	function checkUserComplaintForm(){
		var text = document.UserComplaintForm.ComplaintText.value;

		// if user leaves text unchanged or blank then ask them for some details
		if (text == '' || text == '<xsl:value-of select="$m_ucdefaultcomplainttext"/>'){
			alert('<xsl:value-of select="$m_ucnodetailsalert"/>');
			return false;
		}

		//email should be specified and be of correct format aa@bb.cc
		if (!CheckEmailFormat(document.UserComplaintForm.EmailAddress.value)){
			alert('<xsl:value-of select="$m_ucinvalidemailformat"/>');
			document.UserComplaintForm.EmailAddress.focus();
			return false;
		}

		return true;
	}
	</xsl:comment>
	</script>
	</xsl:template>
</xsl:stylesheet>
