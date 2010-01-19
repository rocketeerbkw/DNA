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
	<xsl:with-param name="message">USERCOMPLAINT_MAINBODY test variable = <xsl:value-of select="$current_article_type" /></xsl:with-param>
	<xsl:with-param name="pagename">usercomplainpopup.xsl</xsl:with-param>
	</xsl:call-template>
	<!-- DEBUG -->
	
	<div class="popup-banner"><img src="{$imagesource}banner_logo.gif" width="146" height="39" alt="collective" border="0" hspace="7" vspace="0" /></div>
	<xsl:call-template name="icon.heading">
	<xsl:with-param name="icon.heading.icon" select="0" />
	<xsl:with-param name="icon.heading.text">register a complaint</xsl:with-param>
	<xsl:with-param name="icon.heading.colour">DA8A42</xsl:with-param>
	</xsl:call-template>
	<div class="popup-page">
		<div class="popup-inner">
			<xsl:element name="{$text.base}" use-attribute-sets="text.base">
			<xsl:apply-templates select="USER-COMPLAINT-FORM" mode="c_complaint"/>
			</xsl:element>
		</div>
	</div>
	<div class="popup-footer">
		<div class="popup-footer-close">
			<a href="#" onClick="self.close()">close <img src="{$imagesource}icons/close_window_green.gif" alt="close this window" height="16" width="16" border="" /></a><!--TODO hide from non script -->
		</div>
	</div>
	</xsl:template>

	<xsl:template match="USER-COMPLAINT-FORM" mode="form_complaint">
		<xsl:apply-templates select="." mode="t_introduction"/>
		<xsl:apply-templates select="." mode="c_form"/>
	</xsl:template>

	<xsl:template match="USER-COMPLAINT-FORM" mode="r_form">
	
	<!-- <input type="hidden" name="skin" value="purexml"/> -->
		<xsl:apply-templates select="." mode="t_textarea"/><!-- TODO this needs a label -->
		<br/>
		<xsl:call-template name="m_complaintpopupemailaddresslabel"/>
		<br/>
		<xsl:apply-templates select="." mode="t_email"/>
		<br />
		<xsl:apply-templates select="." mode="t_submit"/> <!-- TODO confirm whether this is needed <xsl:apply-templates select="." mode="t_cancel"/> -->
	</xsl:template>

	<xsl:template match="USER-COMPLAINT-FORM" mode="success_complaint">
		<xsl:value-of select="$m_complaintsuccessfullyregisteredmessage"/>
		<xsl:text>Your complaint reference number is: </xsl:text>
		<strong><xsl:value-of select="MODERATION-REFERENCE"/></strong>
		<br/>
		<!-- TODO confirm whether this is needed <xsl:apply-templates select="." mode="t_cancel"/> -->
	</xsl:template>


	<xsl:template name="m_complaintpopupemailaddresslabel">
	Please enter <label for="complaint-email" class="complaint-text">your email address</label> here, so we can contact you with details of the action taken:
	</xsl:template>

	<!-- attribute set for textarea box -->
	<xsl:attribute-set name="mUSER-COMPLAINT-FORM_t_textarea">
		<xsl:attribute name="wrap">virtual</xsl:attribute>
		<xsl:attribute name="id">complaint-text</xsl:attribute>
		<xsl:attribute name="name">ComplainText</xsl:attribute>
		<xsl:attribute name="rows">5</xsl:attribute>
		<xsl:attribute name="cols">20</xsl:attribute>
		<xsl:attribute name="class">complaint-text</xsl:attribute>
	</xsl:attribute-set>

	<!-- attribute set for email address -->
	<xsl:attribute-set name="mUSER-COMPLAINT-FORM_t_email">
		<xsl:attribute name="type">text</xsl:attribute>
		<xsl:attribute name="size">20</xsl:attribute>
		<xsl:attribute name="value"><xsl:value-of select="/H2G2/VIEWING-USER/USER/EMAIL-ADDRESS"/></xsl:attribute>
		<xsl:attribute name="class">complaint-email</xsl:attribute>
		<xsl:attribute name="id">complaint-email</xsl:attribute>
	</xsl:attribute-set>

	<!-- attribute set for submit -->
	<xsl:attribute-set name="mUSER-COMPLAINT-FORM_t_submit">
		<xsl:attribute name="type">image</xsl:attribute>
		<xsl:attribute name="name">Submit</xsl:attribute>
		<xsl:attribute name="src"><xsl:value-of select="concat($imagesource,'buttons/send.gif')" /></xsl:attribute>
		<xsl:attribute name="width">74</xsl:attribute>
		<xsl:attribute name="height">23</xsl:attribute>		
		<xsl:attribute name="alt">send</xsl:attribute>
	</xsl:attribute-set>
	
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
