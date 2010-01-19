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
	
		
		<div id="complainpopup">
			<div id="popban">
			<img src="{$imagesource}banner_popup.jpg" alt="Mini movies made by you" />
				<!-- <img src="{$imagesource}banner_popup.gif" width="412" height="45" alt="Britishfilm: comment - debate - create" id="banner"/> --><br />
			</div>
			
			<h1>Register a complaint</h1>
			
			<div id="popupbody">
				<xsl:apply-templates select="USER-COMPLAINT-FORM" mode="c_complaint"/>
			</div>
			<div id="popfoot">
			<a href="http://www.bbc.co.uk/terms/" target="_blank">Terms of Use</a>
			<script type="text/javascript">
			<xsl:comment>
			<![CDATA[
			document.write('| <A href="javascript:self.close()">c\lose window</a>&nbsp;&nbsp;')
			]]>
			</xsl:comment>
			</script>
			</div>
		</div>
	</xsl:template>
	
	<xsl:template match="USER-COMPLAINT-FORM" mode="form_complaint">
	
		<xsl:apply-templates select="." mode="t_introduction"/>
		
		<xsl:apply-templates select="." mode="c_form"/>
	</xsl:template>
	
	
	<xsl:template match="USER-COMPLAINT-FORM" mode="r_form">
		<xsl:apply-templates select="." mode="t_textarea"/>
		
		<p><xsl:call-template name="m_complaintpopupemailaddresslabel"/></p>
		
		<xsl:apply-templates select="." mode="t_email"/>
		
		<div class="fl"><xsl:apply-templates select="." mode="t_submit"/></div>
		<div class="flr"><xsl:apply-templates select="." mode="t_cancel"/></div>
		<div class="clear"></div>
				
	</xsl:template>
	
	
	<xsl:template match="USER-COMPLAINT-FORM" mode="success_complaint">
		<p><xsl:value-of select="$m_complaintsuccessfullyregisteredmessage"/></p>
		
		<p><xsl:text>Your complaint reference number is:</xsl:text></p>
		
		<p><xsl:value-of select="MODERATION-REFERENCE"/></p>
		
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
		<xsl:attribute name="id">ComplaintText</xsl:attribute>
		<xsl:attribute name="class">popinput</xsl:attribute>
		<xsl:attribute name="cols">10</xsl:attribute>
		<xsl:attribute name="rows">15</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="mUSER-COMPLAINT-FORM_t_email">
		<xsl:attribute name="type">text</xsl:attribute>
		<xsl:attribute name="class">popinput</xsl:attribute>
		<xsl:attribute name="size">20</xsl:attribute>
		<xsl:attribute name="value"><xsl:value-of select="/H2G2/VIEWING-USER/USER/EMAIL-ADDRESS"/></xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="mUSER-COMPLAINT-FORM_t_submit">
		<xsl:attribute name="type">submit</xsl:attribute>
		<xsl:attribute name="name">Submit</xsl:attribute>
		<xsl:attribute name="class">formbutton2</xsl:attribute>
		<xsl:attribute name="value">SUBMIT COMPLAINT</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="mUSER-COMPLAINT-FORM_t_cancel">
		<xsl:attribute name="type">button</xsl:attribute>
		<xsl:attribute name="name">Cancel</xsl:attribute>
		<xsl:attribute name="class">formbutton2</xsl:attribute>
		<xsl:attribute name="onClick">window.close()</xsl:attribute>
		<xsl:attribute name="value">CANCEL</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="mUSER-COMPLAINT-FORM_t_close">
		<xsl:attribute name="type">button</xsl:attribute>
		<xsl:attribute name="name">Close</xsl:attribute>
		<xsl:attribute name="value">Close</xsl:attribute>
		<xsl:attribute name="class">formbutton2</xsl:attribute>
		<xsl:attribute name="onClick">javascript:window.close()</xsl:attribute>
	</xsl:attribute-set>
	
</xsl:stylesheet>
