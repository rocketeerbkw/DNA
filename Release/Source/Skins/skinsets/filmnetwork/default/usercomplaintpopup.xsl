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
<style media="screen">
	body {margin:0px; background:#fff; color:#5e5d5d;}
</style>
<table width="620" border="0" cellspacing="0" cellpadding="0" class="popupbg">
  <tr>
  <td valign="top"><div class="beebpad"><span class="textmedium"><a href="http://www.bbc.co.uk" class="rightcollight" target="new"><strong>bbc.co.uk</strong></a></span></div></td>
    <td width="210" valign="top"><img src="{$imagesource}furniture/popuplogo.gif" width="210" height="64" /></td>
  <td align="right" valign="top"><div class="closepad"><span class="textmedium"><a href="#" onclick="window.close();" class="rightcol"><strong>close window</strong>&nbsp;<img src="{$imagesource}furniture/popupclose.gif" width="10" height="10" /></a></span></div></td>
  </tr>
</table>
		<xsl:apply-templates select="USER-COMPLAINT-FORM" mode="c_complaint"/>
	
	</xsl:template>
	<xsl:template match="USER-COMPLAINT-FORM" mode="form_complaint">
	<table width="620" border="0" cellspacing="0" cellpadding="0" class="popupbg2">
<tr><td colspan="4" height="8"></td></tr>
  <tr>
    <td width="44"></td>
	<td width="29"><img src="{$imagesource}furniture/drama/commentsexclam.gif" width="29" height="28" alt="!" /></td>
    <td width="503"><div class="textxlarge">register complaint</div></td>
    <td width="44"></td>
  </tr>
</table>
<table width="620" border="0" cellspacing="0" cellpadding="0" class="popupbg2">
  <tr>
  <td width="44"></td>
  <td width="532" valign="top"><div class="textmedium"><xsl:apply-templates select="." mode="t_introduction"/></div></td>
  <td></td>
  </tr>
   <tr>
  	<td colspan="3" height="8"></td>
	</tr>

</table>
		
		<xsl:apply-templates select="." mode="c_form"/>
	</xsl:template>
	<xsl:template match="USER-COMPLAINT-FORM" mode="r_form">
	<table width="620" border="0" cellspacing="0" cellpadding="0" class="popupbg3">
  <tr>
  	<td height="8" colspan="2"></td>
	</tr>
  <tr>
    <td width="20"></td>
    <td>
		<xsl:apply-templates select="." mode="t_textarea"/>
		<br/>
	</td>
  </tr>
  
  <tr>
  	<td  height="4" colspan="2"></td>
	</tr>
  <tr>
  <td width="20"></td>
	<td><div class="textmedium">
		<xsl:call-template name="m_complaintpopupemailaddresslabel"/>
		<br/></div>
		</td>
  </tr>
  <tr>
  	<td  height="8" colspan="2"></td>
	</tr>
  <tr><td width="20"></td>
  	<td>
		<xsl:apply-templates select="." mode="t_email"/>
		<br/>
		</td>
  </tr>
  <tr>
  	<td height="8" colspan="2"></td>
	</tr>
	<tr>
	<td align="right" colspan="2"><xsl:apply-templates select="." mode="t_submit"/>&nbsp;&nbsp;&nbsp;<xsl:apply-templates select="." mode="t_cancel"/></td>
	</tr>
	<tr>
  	<td height="16" colspan="2"></td>
	</tr>
</table>
		
		
	</xsl:template>

	<xsl:template match="USER-COMPLAINT-FORM" mode="t_submit">
		<input type="image" src="{$imagesource}furniture/submitcomplaint1.gif" name="Submit" value="Submit Complaint" />
	</xsl:template>
	<xsl:template match="USER-COMPLAINT-FORM" mode="t_cancel">
		<a href="#" onclick="window.close();"><img src="{$imagesource}furniture/cancel1.gif" width="52" height="16" alt="cancel" /></a>
	</xsl:template>


	<xsl:template match="USER-COMPLAINT-FORM" mode="success_complaint">
<table width="620" border="0" cellspacing="0" cellpadding="0" class="popupbg2">
  <tr>
  <td width="44"></td>
  <td width="532" valign="top"><div class="textmedium"><br /><br />
<xsl:value-of select="$m_complaintsuccessfullyregisteredmessage"/>
		<br/>
		<xsl:text>Your complaint reference number is:</xsl:text>
		<br/>
		<xsl:value-of select="MODERATION-REFERENCE"/>
		<br/><br />
		<xsl:apply-templates select="." mode="t_close"/>
		</div></td>
  <td></td>
  </tr>
   <tr>
  	<td colspan="3" height="8"></td>
	</tr>

</table>
		
	</xsl:template>
	
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


	<xsl:attribute-set name="mUSER-COMPLAINT-FORM_t_email">
		<xsl:attribute name="type">text</xsl:attribute>
		<xsl:attribute name="size">40</xsl:attribute>
		<xsl:attribute name="value"><xsl:value-of select="/H2G2/VIEWING-USER/USER/EMAIL-ADDRESS"/></xsl:attribute>
	</xsl:attribute-set>


	<xsl:variable name="m_postingcomplaintdescription">
		Fill in this form to register a complaint about the <xsl:value-of select="$m_posting"/> '<xsl:value-of select="/H2G2/USER-COMPLAINT-FORM/SUBJECT"/>', written by <xsl:apply-templates select="/H2G2/USER-COMPLAINT-FORM/AUTHOR/USER" mode="usercomplaint"/>.
	</xsl:variable>

	<xsl:template match="/H2G2/USER-COMPLAINT-FORM/AUTHOR/USER" mode="usercomplaint">
		<a target="_new" href="{$root}U{USERID}"><xsl:value-of select="USERNAME" /></a>
	</xsl:template>


	<xsl:attribute-set name="mUSER-COMPLAINT-FORM_t_textarea">
		<xsl:attribute name="wrap">virtual</xsl:attribute>
		<xsl:attribute name="id">ComplaintText</xsl:attribute>
		<xsl:attribute name="cols">70</xsl:attribute>
		<xsl:attribute name="rows">8</xsl:attribute>
	</xsl:attribute-set>
</xsl:stylesheet>

