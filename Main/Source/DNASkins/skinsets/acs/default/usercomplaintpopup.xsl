<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<xsl:import href="../../../base/base-usercomplaintpopup.xsl"/>
	<xsl:template name="USERCOMPLAINT_CSS">
	<style>
	label {display:block;}
	h1 {font-size:100%;}
	
	</style>
	</xsl:template>
	<xsl:template name="USERCOMPLAINT_JAVASCRIPT">
		<script type="text/javascript">
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

      function checkUserComplaintForm()
      {
      
      //Go throught the options
      var text;
      for (i= UserComplaintForm.ComplaintText.length-2; i > -1; i--)
      {
        if ( UserComplaintForm.ComplaintText[i].checked )
        {
        text = UserComplaintForm.ComplaintText[i].value;
        i = -1;
        }
      }

      // Get custom text.
      if ( text == 'Other' )
      {
        text = UserComplaintForm.ComplaintText[UserComplaintForm.ComplaintText.length-1].value;
      }

      //if user leaves text unchanged or blank then ask them for some details
      if ( text == undefined || text == '' || text == '<xsl:value-of select="$m_ucdefaultcomplainttext"/>' )
      {
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
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
									Page - Level  template
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<xsl:template name="USERCOMPLAINT_MAINBODY">
								<h1>
									<xsl:choose>
										<xsl:when test="/H2G2/PARAMS/PARAM[NAME='s_start']/VALUE=1">									
											Complain about a message - 	Step 1 of 2
										</xsl:when>
										<xsl:when test="/H2G2/USER-COMPLAINT-FORM/MESSAGE/@TYPE='SUBMIT-SUCCESSFUL'">
											Your complaint has been sent
										</xsl:when>
                    <xsl:when test="/H2G2/USER-COMPLAINT-FORM/ERROR">
                      <xsl:value-of select="/H2G2/USER-COMPLAINT-FORM/ERROR"/>
                    </xsl:when>
										<xsl:otherwise>
											Complain about a message - 	Step 2 of 2
										</xsl:otherwise>
									</xsl:choose>
								</h1>
								<xsl:choose>
									<xsl:when test="/H2G2/PARAMS/PARAM[NAME='s_start']/VALUE=1">
													<p>Please read before continuing with your complaint</p>
													<div class="textfield">
														<p>This form is only to be used for serious complaints about specific content that breaks the BBC House Rules, such as unlawful, harassing, abusive, threatening, obscene, sexually explicit, racially offensive, or otherwise objectionable material.</p>
														<p>If you have a general comment or question please do not use this form, post a message to the discussion.</p>
														<p>The message you complain about will be sent to a moderator, who will decide whether it breaks the House Rules. You will be informed of their decision by email.</p>
													</div>
													<!--<br/>-->
													<div class="buttons">
														<a href="#" onclick="window.close()">
															<img src="{$imagesource}cancel_button.gif" alt="Cancel" width="104" height="23" border="0"/>
														</a>
														&nbsp;			
														<a href="{$root}UserComplaint?PostID={/H2G2/USER-COMPLAINT-FORM/POST-ID}">
															<img src="{$imagesource}next_button.gif" alt="Next" width="103" height="23" border="0"/>
														</a>
													</div>
									</xsl:when>
									<xsl:otherwise>
										<!--<table cellspacing="0" cellpadding="0" border="0" width="500" id="contentForm">-->
											<xsl:choose>
												<xsl:when test="/H2G2/USER-COMPLAINT-FORM/MESSAGE/@TYPE='SUBMIT-SUCCESSFUL'">
											</xsl:when>
												<xsl:otherwise>
													<!--<tr>
														<td id="tablenavbarForm" width="500">-->
															<p>Please fill in the form and when you have finished, click on Submit Complaint</p>
														<!--</td>
													</tr>-->
												</xsl:otherwise>
											</xsl:choose>
											<!--<tr>
												<td id="formBg">-->
													<xsl:apply-templates select="USER-COMPLAINT-FORM" mode="c_complaint"/>
													<!--<br/>
													<br/>-->
												<!--</td>
											</tr>
										</table>-->
									</xsl:otherwise>
								</xsl:choose>
	</xsl:template>
	<!-- The complaint form -->
	<xsl:template match="USER-COMPLAINT-FORM" mode="form_complaint">
		<p>
			<xsl:apply-templates select="." mode="t_introduction"/>
		</p>
		<xsl:apply-templates select="." mode="c_form"/>
	</xsl:template>
	<xsl:template match="USER-COMPLAINT-FORM" mode="r_form">
		<div class="theForm">
			<!--<h3>Reason for complaint:</h3>
			<select>
				<option value="AdvertInsert">Advertising</option>
				<option value="BadLanguageInsert">Bad language</option>
				<option value="LegalInsert">Illegal</option>
				<option value="UrlInsert">Inappropriate web link</option>
				<option value="OffensiveInsert">Offensive to others</option>
				<option value="AttackInsert">Racist, sexist or homophobic</option>
				<option value="PersonalDetailsInsert">Reveals personal details</option>
				<option value="SpamInsert">Spam</option>
				<option value="NotEnglishInsert">Uses foreign language</option>
			</select>
			<br/>
			<br/>-->
			<h3>I believe this post may break one of the <a href="{$houserulespopupurl}" target="_blank">House Rules</a> because it:</h3>
			<xsl:apply-templates select="." mode="t_questions"/>
			<!--<br/>
			<br/>-->
			<h3>Your email address:</h3>
			<p class="instructional">We need your email address so we can provide you with updates about your complaint</p>
			<xsl:apply-templates select="." mode="t_email"/>
			<xsl:apply-templates select="." mode="c_hidepost"/>
		</div>
		<!--<br/>
		<br/>-->
		<div class="buttons">
			<xsl:apply-templates select="." mode="t_cancel"/> 
			&nbsp;			
			<xsl:apply-templates select="." mode="t_submit"/>
		</div>
	</xsl:template>
	<xsl:template match="USER-COMPLAINT-FORM" mode="success_complaint">
		<div class="textfield">
			<p>The message you complained about will be sent to a moderator, who will decide whether it breaks the House Rules. You will be informed of their decision by email.</p>
			<!--<br/>-->
			<p>
				<xsl:text>Your complaint reference number is:</xsl:text>
				<xsl:value-of select="MODERATION-REFERENCE"/>
			</p>
		</div>
		<!--<br/>-->
		<div class="buttons">
			<xsl:apply-templates select="." mode="t_close"/>
		</div>
	</xsl:template>
<xsl:template match="USER-COMPLAINT-FORM" mode="t_questions">
<label for="dnaacs-cq-1"><input name="ComplaintText" value="Is defamatory or libellous" type="radio" id="dnaacs-cq-1" />Is defamatory or libellous</label>
<label for="dnaacs-cq-2"><input name="ComplaintText" value="Is in contempt of court" type="radio" id="dnaacs-cq-2" />Is in contempt of court</label>
<label for="dnaacs-cq-3"><input name="ComplaintText" value="Incites people to commit a crime" type="radio" id="dnaacs-cq-3" />Incites people to commit a crime</label>
<label for="dnaacs-cq-4"><input name="ComplaintText" value="Breaks a court injunction" type="radio" id="dnaacs-cq-4" />Breaks a court injunction</label>
<label for="dnaacs-cq-5"><input name="ComplaintText" value="Is in breach of copyright (plagiarism)" type="radio" id="dnaacs-cq-5" />Is in breach of copyright (plagiarism)</label>
<label for="dnaacs-cq-6"><input name="ComplaintText" value="Is unlawful, harassing, defamatory, abusive, threatening, harmful, obscene, profane, sexually explicit or racially offensive" type="radio" id="dnaacs-cq-6" />Is unlawful, harassing, defamatory, abusive, threatening, harmful, obscene, profane, sexually explicit or racially offensive</label>
<label for="dnaacs-cq-7"><input name="ComplaintText" value="Contains offensive language" type="radio" id="dnaacs-cq-7" />Contains offensive language</label>
<label for="dnaacs-cq-8"><input name="ComplaintText" value="Is spam" type="radio" id="dnaacs-cq-8" />Is spam</label>
<label for="dnaacs-cq-9"><input name="ComplainText" value="Is off-topic chat that is completely unrelated to the discussion topic" type="radio" id="dnaacs-cq-9" />Is off-topic chat that is completely unrelated to the discussion topic</label>
<label for="dnaacs-cq-10"><input name="ComplaintText" value="Contains personal information such as a phone number or personal email address" type="radio" id="dnaacs-cq-10" />Contains personal information such as a phone number or personal email address</label>
<label for="dnaacs-cq-11"><input name="ComplaintText" value="Advertises or promotes products or services" type="radio" id="dnaacs-cq-11" />Advertises or promotes products or services</label>
<label for="dnaacs-cq-12"><input name="ComplaintText" value="Is not in English" type="radio" id="dnaacs-cq-12" />Is not in English</label>
<label for="dnaacs-cq-13"><input name="ComplaintText" value="Contains a link to an external website which breaks our editorial guidelines" type="radio" id="dnaacs-cq-13" />Contains a link to an external website which breaks our <a href="http://www.bbc.co.uk/messageboards/newguide/popup_editorial_guidelines.html" target="_blank">Editorial Guidelines</a></label>
<label for="dnaacs-cq-14"><input name="ComplaintText" value="Contains an inappropriate username" type="radio" id="dnaacs-cq-14" />Contains an inappropriate username</label>
  <label for="dnaacs-cq-15"><input name="ComplaintText" value="Other" type="radio" id="dnaacs-cq-15" checked="checked" />Other</label>
If your reason for complaint is not listed, choose 'Other' and give your brief reason here. <input name="ComplaintText" type="text" />
<p>If you disagree with a comment please <strong>do not</strong> submit a complaint. You should  <b>Add your comment</b> to the discussion.</p>
	</xsl:template>	
	<xsl:template match="USER-COMPLAINT-FORM" mode="r_hidepost">
		<p>
			<xsl:apply-templates select="." mode="t_hidepostcheck"/> Hide this message instantly.
		</p>
		<p>Use in editorial emergencies only, e.g. breach of court order, web link to pornography.</p>
	</xsl:template>
	<xsl:attribute-set name="mUSER-COMPLAINT-FORM_c_form">
		<xsl:attribute name="onSubmit"/>
	</xsl:attribute-set>
	<xsl:attribute-set name="mUSER-COMPLAINT-FORM_t_textarea">
		<xsl:attribute name="wrap">virtual</xsl:attribute>
		<xsl:attribute name="id">ComplaintText</xsl:attribute>
		<xsl:attribute name="cols">45</xsl:attribute>
		<xsl:attribute name="rows">10</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="mUSER-COMPLAINT-FORM_t_email">
		<xsl:attribute name="type">text</xsl:attribute>
		<xsl:attribute name="size">40</xsl:attribute>
		<xsl:attribute name="value"><xsl:choose><xsl:when test="/H2G2/VIEWING-USER/USER/EMAIL-ADDRESS"><xsl:value-of select="/H2G2/VIEWING-USER/USER/EMAIL-ADDRESS"/></xsl:when><xsl:otherwise>Enter your email address here</xsl:otherwise></xsl:choose></xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="mUSER-COMPLAINT-FORM_t_submit">
		<xsl:attribute name="type">submit</xsl:attribute>
		<xsl:attribute name="name">Submit</xsl:attribute>
		<xsl:attribute name="value"><xsl:value-of select="$m_complaintsformsubmitbuttonlabel"/></xsl:attribute>
    <xsl:attribute name="onClick">return checkUserComplaintForm()</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="mUSER-COMPLAINT-FORM_t_cancel">
		<xsl:attribute name="type">button</xsl:attribute>
		<xsl:attribute name="name">Cancel</xsl:attribute>
		<xsl:attribute name="onClick">window.close()</xsl:attribute>
		<xsl:attribute name="value"><xsl:value-of select="$m_complaintsformcancelbuttonlabel"/></xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="mUSER-COMPLAINT-FORM_t_close">
		<xsl:attribute name="type">button</xsl:attribute>
		<xsl:attribute name="name">Close</xsl:attribute>
		<xsl:attribute name="value">Close</xsl:attribute>
		<xsl:attribute name="onClick">javascript:window.close()</xsl:attribute>
	</xsl:attribute-set>
</xsl:stylesheet>
