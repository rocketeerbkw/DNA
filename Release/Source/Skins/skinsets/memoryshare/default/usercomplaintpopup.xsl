<?xml version="1.0" encoding="iso-8859-1"?>
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
	<xsl:template name="USERCOMPLAINT_HEADER">
		<xsl:apply-templates mode="header" select=".">
			<xsl:with-param name="title">
				<xsl:value-of select="$m_pagetitlestart"/>
				<xsl:text>Register a complaint</xsl:text>
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>
	
	<xsl:template name="USERCOMPLAINT_MAINBODY">
	<!--[FIXME: remove]
    <xsl:text>We can get right in the top...</xsl:text>
	-->
	<!-- DEBUG -->
	<xsl:call-template name="TRACE">
		<xsl:with-param name="message">USERCOMPLAINT_MAINBODY</xsl:with-param>
		<xsl:with-param name="pagename">usercomplaintpopup.xsl</xsl:with-param>
	</xsl:call-template>
	<!-- DEBUG -->
	
		<style type="text/css" media="all">
			<xsl:choose>
				<xsl:when test="/H2G2/SERVERNAME = $development_server">
					@import "http://dnadev.national.core.bbc.co.uk/dna/-/skins/memoryshare/_trans/css/popup.css";
				</xsl:when>
				<xsl:when test="/H2G2/SERVERNAME = $staging_server">
					@import "http://bbc.e3hosting.net/memoryshare/css/popup.css";
				</xsl:when>
				<xsl:otherwise>
					@import "http://www.bbc.co.uk/memoryshare/css/popup.css";		
				</xsl:otherwise>
			</xsl:choose>
		</style>
		
		<h1>Register a complaint</h1>
		<div class="outer">
			<div class="inner">
				<xsl:apply-templates select="USER-COMPLAINT-FORM" mode="c_complaint"/>

				<div id="popfoot">
					<a href="http://www.bbc.co.uk/terms/" target="_blank">Terms of use </a>
					<script type="text/javascript">
						<xsl:comment>
						<![CDATA[
						document.write('| <a href="javascript:self.close()">C\lose window</a>&nbsp;&nbsp;')
						]]>
						</xsl:comment>
					</script>
				</div>
			</div>
		</div>
		<!--[FIXME: what is this?]
	    <xsl:text>and right down to the bottom</xsl:text>
		-->
	</xsl:template>
	
	<xsl:template match="USER-COMPLAINT-FORM" mode="form_complaint">
		<xsl:apply-templates select="." mode="t_introduction"/>
		<xsl:apply-templates select="." mode="c_form"/>
	</xsl:template>
	
	
	<xsl:template match="USER-COMPLAINT-FORM" mode="r_form">
		<xsl:apply-templates select="." mode="t_textarea"/>
		
		<p><xsl:call-template name="m_complaintpopupemailaddresslabel"/></p>
		
		<xsl:apply-templates select="." mode="t_email"/>
		
		<div class="rAlign">
			<xsl:apply-templates select="." mode="t_submit"/>
			<xsl:apply-templates select="." mode="t_cancel"/>
		</div>
	</xsl:template>

	<xsl:template match="USER-COMPLAINT-FORM" mode="t_textarea">
		<!--<label for="textArea">Maecenas sit amet lorem. Donec ut enim. In non diam sed nibh pulvinar 
		tincidunt. Curabitur fringilla semper nulla. Morbi eget pede. Integer lacus 
		nisl, lobortis in.</label>--><br/>
		
		<textarea name="ComplaintText" xsl:use-attribute-sets="mUSER-COMPLAINT-FORM_t_textarea">
			<xsl:value-of select="$m_defaultcomplainttext"/>
		</textarea>
	</xsl:template>

	<xsl:template name="m_complaintpopupemailaddresslabel">
		<label for="email">Please enter your email address here, so we can contact you with details of the action taken:</label><br/>
	</xsl:template>

	<xsl:template match="USER-COMPLAINT-FORM" mode="t_email">
		<input name="EmailAddress" xsl:use-attribute-sets="mUSER-COMPLAINT-FORM_t_email"/>
	</xsl:template>

	<xsl:template match="USER-COMPLAINT-FORM" mode="t_close">
		<!--[FIXME: redundant]
		<form>
			<div class="rAlign">
				<script language="javascript" type="text/javascript">
				<![CDATA[
					document.write('<input type="button" name="Close" value="Close" onclick="javascript:window.close()" class="submit"/>');
				]]>
				</script>
			</div>
		</form>
		-->
	</xsl:template>
	
	
	<xsl:template match="USER-COMPLAINT-FORM" mode="success_complaint">
		<p><xsl:value-of select="$m_complaintsuccessfullyregisteredmessage"/></p>
		
		<p><xsl:text>Your complaint reference number is:</xsl:text></p>
		
		<p><xsl:value-of select="MODERATION-REFERENCE"/></p>
		
		<xsl:apply-templates select="." mode="t_close"/>
	</xsl:template>
	
	
	<xsl:template name="USERCOMPLAINT_JAVASCRIPT">
		<script language="javascript" type="text/javascript">
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
		</script>	
	</xsl:template>
	
	
	<xsl:template match="USER-COMPLAINT-FORM" mode="t_introduction">
		<p><xsl:call-template name="m_complaintpopupseriousnessproviso"/></p>
		<!-- then insert any messages requested within the form XML -->
		<p><xsl:choose>
			<xsl:when test="MESSAGE/@TYPE='ALREADY-HIDDEN'">
				<xsl:value-of select="$m_contentalreadyhiddenmessage"/>
			</xsl:when>
			<xsl:when test="MESSAGE/@TYPE='DELETED'">
				<xsl:value-of select="$m_contentcancelledmessage"/>
			</xsl:when>
			<xsl:otherwise>
				<!-- otherwise insert some appropriate preamble -->
				<xsl:choose>
					<xsl:when test="@TYPE='ARTICLE'">
						<xsl:copy-of select="$m_articlecomplaintdescription"/>
					</xsl:when>
					<xsl:when test="@TYPE='POST'">
						<xsl:copy-of select="$m_postingcomplaintdescription"/>
					</xsl:when>
					<xsl:when test="@TYPE='GENERAL'">
						<xsl:copy-of select="$m_generalcomplaintdescription"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:copy-of select="$m_generalcomplaintdescription"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose></p>
	</xsl:template>
	
	
	<xsl:attribute-set name="mUSER-COMPLAINT-FORM_t_textarea">
		<xsl:attribute name="wrap">virtual</xsl:attribute>
		<xsl:attribute name="id">textArea</xsl:attribute>
		<xsl:attribute name="class">popinput</xsl:attribute>
		<xsl:attribute name="cols">50</xsl:attribute>
		<xsl:attribute name="rows">5</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="mUSER-COMPLAINT-FORM_t_email">
		<xsl:attribute name="type">text</xsl:attribute>
		<xsl:attribute name="id">email</xsl:attribute>
		<xsl:attribute name="class">txt</xsl:attribute>
		<xsl:attribute name="value"><xsl:value-of select="/H2G2/VIEWING-USER/USER/EMAIL-ADDRESS"/></xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="mUSER-COMPLAINT-FORM_t_submit">
		<xsl:attribute name="type">submit</xsl:attribute>
		<xsl:attribute name="name">Submit</xsl:attribute>
		<xsl:attribute name="class">submit</xsl:attribute>
		<xsl:attribute name="value">Submit</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="mUSER-COMPLAINT-FORM_t_cancel">
		<xsl:attribute name="type">button</xsl:attribute>
		<xsl:attribute name="name">Cancel</xsl:attribute>
		<xsl:attribute name="class">submit</xsl:attribute>
		<xsl:attribute name="onClick">window.close()</xsl:attribute>
		<xsl:attribute name="value">Cancel</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="mUSER-COMPLAINT-FORM_t_close">
		<xsl:attribute name="type">button</xsl:attribute>
		<xsl:attribute name="name">Close</xsl:attribute>
		<xsl:attribute name="value">Close</xsl:attribute>
		<xsl:attribute name="class">submit</xsl:attribute>
		<xsl:attribute name="onClick">javascript:window.close()</xsl:attribute>
	</xsl:attribute-set>
	
</xsl:stylesheet>
