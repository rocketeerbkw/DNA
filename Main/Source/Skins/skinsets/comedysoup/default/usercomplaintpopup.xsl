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
	<!-- DEBUG -->
	<xsl:call-template name="TRACE">
		<xsl:with-param name="message">USERCOMPLAINT_MAINBODY</xsl:with-param>
		<xsl:with-param name="pagename">usercomplaintpopup.xsl</xsl:with-param>
	</xsl:call-template>
	<!-- DEBUG -->
	
	<div id="popupBanner">
		<img src="{$imagesource}popup_banner.gif" width="600" height="75" alt="ComedySoup - watch funny stuff" />
	</div>
	
	
	<div class="soupContent">
	<h1 id="registeracomplaint"><img src="{$imagesource}h1_registeracomplaint.gif" width="238" height="26" alt="register a complaint" /></h1>
		<xsl:apply-templates select="USER-COMPLAINT-FORM" mode="c_complaint"/>
	</div>
	
	
	</xsl:template>
	
	<xsl:template name="m_complaintpopupseriousnessproviso">
This form is only for serious complaints about specific content that breaks the site's <A xsl:use-attribute-sets="nm_complaintpopupseriousnessproviso" HREF="{$root}HouseRules">House Rules</A>, such as unlawful, harassing, defamatory, abusive, threatening, harmful, obscene, profane, sexually oriented, racially offensive, or otherwise objectionable material.
<br/>
		<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
		<br/>
For general comments please post to the relevant <xsl:value-of select="$m_thread"/> on the site.
<div class="hozDots"></div>
		<br/>
	</xsl:template>
	
	
	<xsl:template match="USER-COMPLAINT-FORM" mode="form_complaint">
		<div class="popupContent">
			<xsl:apply-templates select="." mode="t_introduction"/>
		</div>
		<xsl:apply-templates select="." mode="c_form"/>
	</xsl:template>
	
	<xsl:template match="USER-COMPLAINT-FORM" mode="r_form">
		<div class="popupContent">
			<xsl:apply-templates select="." mode="t_textarea"/>
			<br/>
			<xsl:call-template name="m_complaintpopupemailaddresslabel"/>
			<br/>
			<xsl:apply-templates select="." mode="t_email"/>
			<br/>
			<xsl:apply-templates select="." mode="t_submit"/>
		</div>
		
		<div id="popupClose">
			<xsl:apply-templates select="." mode="t_cancel"/>
		</div>
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
	
	
	<xsl:attribute-set name="mUSER-COMPLAINT-FORM_t_email">
		<xsl:attribute name="id">emailInput</xsl:attribute>
		<xsl:attribute name="type">text</xsl:attribute>
		<xsl:attribute name="size">20</xsl:attribute>
		<xsl:attribute name="value"><xsl:value-of select="/H2G2/VIEWING-USER/USER/EMAIL-ADDRESS"/></xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="mUSER-COMPLAINT-FORM_t_submit">
		<xsl:attribute name="type">submit</xsl:attribute>
		<xsl:attribute name="name">Submit</xsl:attribute>
		<xsl:attribute name="value">send</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="mUSER-COMPLAINT-FORM_t_cancel">
		<xsl:attribute name="type">button</xsl:attribute>
		<xsl:attribute name="name">Cancel</xsl:attribute>
		<xsl:attribute name="onClick">window.close()</xsl:attribute>
		<xsl:attribute name="value">close</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="mUSER-COMPLAINT-FORM_t_close">
		<xsl:attribute name="type">button</xsl:attribute>
		<xsl:attribute name="name">Close</xsl:attribute>
		<xsl:attribute name="value">Close</xsl:attribute>
		<xsl:attribute name="onClick">javascript:window.close()</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:template name="USERCOMPLAINT_JAVASCRIPT">
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
	</xsl:template>
</xsl:stylesheet>
