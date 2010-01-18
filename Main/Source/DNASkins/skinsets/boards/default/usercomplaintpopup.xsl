<!DOCTYPE xsl:stylesheet [
  <!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
  <xsl:import href="../../../base/base-usercomplaintpopup.xsl"/>
  <xsl:template name="USERCOMPLAINT_JAVASCRIPT">
    <script type="text/javascript">
      function CheckEmailFormat(email)
      {
      if (  '<xsl:value-of select="/H2G2/VIEWING-USER/USER/USERID"/>' &gt; 0 &amp;&amp; '<xsl:value-of select="/H2G2/SITE/SITEOPTIONS/SITEOPTION[SITEID=/H2G2/CURRENTSITE and NAME='IsKidsSite']/VALUE"></xsl:value-of>' == 1 )
      {
        return true;
      }

      if (email.length &lt; 5)	
        {
          return false;
        }

        var atIndex = email.indexOf('@');

        if (atIndex &lt; 1)
        {
          return false;
        }

        var lastDotIndex = email.lastIndexOf('.');

        if (lastDotIndex &lt; atIndex + 2)
      {
      return false;
      }

      return true;
      }

      function checkUserComplaintForm()
      {
        var text = document.UserComplaintForm.ComplaintText.value;

        // if user leaves text unchanged or blank then ask them for some details
        if (text == '' || text == '<xsl:value-of select="$m_ucdefaultcomplainttext"/>')
        {
          alert('<xsl:value-of select="$m_ucnodetailsalert"/>');
          return false;
        }

        //email should be specified and be of correct format aa@bb.cc
        if (!CheckEmailFormat(document.UserComplaintForm.EmailAddress.value))
        {
          alert('<xsl:value-of select="$m_ucinvalidemailformat"/>');
          document.UserComplaintForm.EmailAddress.focus();
          return false;
        }
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
    <table width="615" cellpadding="0" cellspacing="0" border="0" id="main">
      <tr>
        <td class="pageheader">
          <table width="615" border="0" cellpadding="0" cellspacing="0">
            <tr>
              <td id="subject">
                <h1>
                  <xsl:choose>
                    <xsl:when test="/H2G2/USER-COMPLAINT-FORM/ERROR">
                      Complain about a message
                    </xsl:when>
                    <xsl:when test="/H2G2/PARAMS/PARAM[NAME='s_start']/VALUE=1">
                      BBC Complaints
                    </xsl:when>
                    <xsl:when test="/H2G2/PARAMS/PARAM[NAME='s_start']/VALUE=2">
                      Complain about a message - 	Step 1 of 2
                    </xsl:when>
                    <xsl:when test="/H2G2/PARAMS/PARAM[NAME='s_start']/VALUE=3">
                      Complain about a message - 	Step 2 of 2
                    </xsl:when>
                    <xsl:when test="/H2G2/USER-COMPLAINT-FORM/MESSAGE/@TYPE='SUBMIT-SUCCESSFUL'">
                      Your complaint has been sent
                    </xsl:when>
                    <xsl:otherwise>
                      BBC Complaints
                    </xsl:otherwise>
                  </xsl:choose>
                </h1>
              </td>
              <td id="rulesHelp" width="150">
                &nbsp;
              </td>
            </tr>
          </table>
        </td>
      </tr>
      <tr>
        <td width="615" align="right">
          <table width="610" cellpadding="0" cellspacing="0" border="0">
            <tr>
              <td valign="top" width="500">
                <xsl:apply-templates select="/H2G2/USER-COMPLAINT-FORM" mode="form_complaint"/>
              </td>
              <td valign="top" width="110">
                &nbsp;
              </td>
            </tr>
          </table>
        </td>
      </tr>
    </table>
  </xsl:template>
  
  <xsl:template match="USER-COMPLAINT-FORM" mode="form_complaint">
    <xsl:choose>
      <xsl:when test="/H2G2/PARAMS/PARAM[NAME='s_start']/VALUE = 1">
        <table cellspacing="0" cellpadding="0" border="0" width="500" id="contentForm">
          <tr>
            <td id="tablenavbarForm" width="500">
              <p>Complain about a message</p>
            </td>
          </tr>
          <tr>
            <td id="formBg">
              <div class="textfield">
                <p>This form is only for serious complaints about specific content that breaks the site's <a href="{$houserulespopupurl}">House Rules</a>, such as unlawful, harassing, defamatory, abusive, threatening, harmful, obscene, profane, sexually oriented, racially offensive, or otherwise objectionable material.</p>
                <p>If you have a general comment or question please do not use this form - post a message to the discussion.</p>
                <p>The message you complain about will be sent to a moderator, who will decide whether it breaks the <a href="{$houserulespopupurl}">House Rules</a>. You will be informed of their decision by email.</p>
              </div>
              <br/>
              <div class="buttons">
                <a href="#" onclick="window.close()">
                  <img src="{$imagesource}cancel_button.gif" alt="Cancel" width="104" height="23" border="0"/>
                </a>
                &nbsp;
                <a href="{$root}UserComplaint?PostID={POST-ID}&amp;s_start=2">
                  <img src="{$imagesource}next_button.gif" alt="Next" width="103" height="23" border="0"/>
                </a>
              </div>
            </td>
          </tr>
        </table>
      </xsl:when>
      <xsl:when test="/H2G2/PARAMS/PARAM[NAME='s_start']/VALUE = 2">
        <form action="{$root}/UserComplaint" method="get"> 
          <table cellspacing="0" cellpadding="0" border="0" width="500" id="contentForm">
            <tr>
              <td id="tablenavbarForm" width="500">
                <p>Reason for your complaint</p>
              </td>
            </tr>
            <tr>
              <td id="formBg">
                <div class="textfield">
                  <h3 style="display:none;">I believe this post may break one of the <a href="{$houserulespopupurl}">House Rules</a> because it:</h3>
                  <p class="options">
                    <input type="radio" id="dnaacs-cq-1" value="Is defamatory or libellous" name="s_complaintText"/><label for="dnaacs-cq-1">Is defamatory or libellous</label><br/>
                    <input type="radio" id="dnaacs-cq-2" value="Is in contempt of court" name="s_complaintText"/><label for="dnaacs-cq-2">Is in contempt of court</label><br/>
                    <input type="radio" id="dnaacs-cq-3" value="Incites people to commit a crime" name="s_complaintText"/><label for="dnaacs-cq-3">Incites people to commit a crime</label><br/>
                    <input type="radio" id="dnaacs-cq-4" value="Breaks a court injunction" name="s_complaintText"/><label for="dnaacs-cq-4">Breaks a court injunction</label><br/>
                    <input type="radio" id="dnaacs-cq-5" value="Is in breach of copyright (plagiarism)" name="s_complaintText"/><label for="dnaacs-cq-5">Is in breach of copyright (plagiarism)</label><br/>
                    <input type="radio" id="dnaacs-cq-7" value="Contains offensive language" name="s_complaintText"/><label for="dnaacs-cq-7">Contains offensive language</label><br/>
                    <input type="radio" id="dnaacs-cq-8" value="Is spam" name="s_complaintText"/><label for="dnaacs-cq-8">Is spam</label><br/>
                    <input type="radio" id="dnaacs-cq-9" value="Is off-topic chat that is completely unrelated to the discussion topic" name="ComplainText"/><label for="dnaacs-cq-9">Is off-topic chat that is completely unrelated to the discussion topic</label><br/>
                    <input type="radio" id="dnaacs-cq-10" value="Contains personal information such as a phone number or personal email address" name="s_complaintText"/><label for="dnaacs-cq-10">Contains personal information such as a phone number or personal email address</label><br/>
                    <input type="radio" id="dnaacs-cq-11" value="Advertises or promotes products or services" name="s_complaintText"/><label for="dnaacs-cq-11">Advertises or promotes products or services</label><br/>
                    <input type="radio" id="dnaacs-cq-12" value="Is not in English" name="s_complaintText"/><label for="dnaacs-cq-12">Is not in English</label><br/>
                    <input type="radio" id="dnaacs-cq-13" value="Contains a link to an external website which breaks our editorial guidelines" name="s_complaintText"/><label for="dnaacs-cq-13">Contains a link to an external website which breaks our <a href="http://www.bbc.co.uk/messageboards/newguide/popup_editorial_guidelines.html">Editorial Guidelines</a></label><br/>
                    <input type="radio" id="dnaacs-cq-14" value="Contains an inappropriate username" name="s_complaintText"/><label for="dnaacs-cq-14">Contains an inappropriate username</label><br/>
                    <input type="radio" id="dnaacs-cq-6" value="Is unlawful, harassing, defamatory, abusive, threatening, harmful, obscene, profane, sexually explicit or racially offensive" name="s_complaintText"/><label for="dnaacs-cq-6">Is unlawful, harassing, defamatory, abusive, threatening, harmful, obscene, profane, sexually explicit or racially offensive</label><br/>
                    <input type="radio" id="dnaacs-cq-15" value="Other" name="s_complaintText"/><label for="dnaacs-cq-15">Other, provide details of the reason on the next page</label><br/>
                  </p>
                </div>
                <input type="hidden" value="{POST-ID}" name="PostID"/>
                <input type="hidden" name="s_ptrt" value="{/H2G2/PARAMS/PARAM[NAME = 's_ptrt']/VALUE}"/>
                <input type="hidden" name="s_start" value="3"/>
                <input type="hidden" value="{POST-ID}" name="s_postid"/>
                <div class="buttons">
                  <xsl:apply-templates select="." mode="t_cancel"/>
                  &nbsp;
                  <xsl:apply-templates select="." mode="t_next"/>
                </div>
              </td>
            </tr>
          </table>
        </form>
      </xsl:when>
      <xsl:when test="/H2G2/PARAMS/PARAM[NAME='s_start']/VALUE = 3">
        <form id="UserComplaintForm" action="{$root}/UserComplaint" method="post"> 
          <table cellspacing="0" cellpadding="0" border="0" width="500" id="contentForm">
            <tr>
              <td id="tablenavbarForm" width="500">
                <p>Please fill out the form and when you have finished, click on Send Complaint</p>
              </td>
            </tr>
            <tr>
              <td id="formBg">
                <div class="textfield">
                  <p>
                    <xsl:choose>
                      <xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_complaintText']/VALUE and /H2G2/PARAMS/PARAM[NAME = 's_complaintText']/VALUE != 'Other'">
                        <xsl:text>I believe this post </xsl:text>
                        <em><xsl:value-of select="/H2G2/PARAMS/PARAM[NAME = 's_complaintText']/VALUE"/></em>
                        <xsl:text> for the following reason:</xsl:text>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:text>I wish to complain about this post for the following reason:</xsl:text>
                      </xsl:otherwise>
                    </xsl:choose>
                  </p>
                  <textarea id="reason" rows="10" cols="40" name="complainttext" class="textarea"></textarea>
                </div>
                <xsl:choose>
                  <xsl:when test="/H2G2/VIEWING-USER/USER/EMAIL-ADDRESS">
                    <input type="hidden" name="emailaddress" id="emailaddress" value="{/H2G2/VIEWING-USER/USER/EMAIL-ADDRESS}"/>
                  </xsl:when>
                  <xsl:otherwise>
                      <div class="textfield">
                        <p>
                          <em>We need your email address to identify your complaint and also provide you with updates.</em>
                        </p>
                        <p>
                          <label for="emailaddress">Email address:</label><xsl:text> </xsl:text>
                          <input type="text" name="emailaddress" id="emailaddress" value="" class="textbox"/>
                        </p>
                      </div>
                  </xsl:otherwise>
                </xsl:choose>
                <xsl:if test="(/H2G2/VIEWING-USER/USER/GROUPS/EDITOR) or (/H2G2/VIEWING-USER/USER/STATUS = 2)">
                  <div class="textfield">
                    <p>
                      <input type="checkbox" value="1" name="hidepost" id="hidePost"/>
                      <label for="hidePost"> Hide this message instantly</label>.
                    </p>
                  </div>
                </xsl:if>
                <input type="hidden" name="complaintreason" value="{/H2G2/PARAMS/PARAM[NAME = 's_complaintText']/VALUE}"/>
                <input type="hidden" name="s_complaintText" value="{/H2G2/PARAMS/PARAM[NAME = 's_complaintText']/VALUE}"/>
                <input type="hidden" name="s_ptrt" value="{/H2G2/PARAMS/PARAM[NAME = 's_ptrt']/VALUE}"/>
                <input type="hidden" name="s_start" value="{/H2G2/PARAMS/PARAM[NAME = 's_start']/VALUE}"/>
                <input type="hidden" value="{POST-ID}" name="postid"/>
                <input type="hidden" value="{POST-ID}" name="s_postid"/>
                 <div class="buttons">
                  <xsl:apply-templates select="." mode="t_cancel"/>
                  &nbsp;
                  <xsl:apply-templates select="." mode="t_submit"/>
                </div>
              </td>
            </tr>
          </table> 
        </form>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="USER-COMPLAINT-FORM[MESSAGE/@TYPE='SUBMIT-SUCCESSFUL']" mode="form_complaint">
    <table cellspacing="0" cellpadding="0" border="0" width="500" id="contentForm">
      <tr>
        <td id="formBg">
          <div class="textfield">
            <p>The message you complained about will be sent to a moderator, who will decide whether it breaks the House Rules. You will be informed of their decision by email.</p>
            <br/>
            <p>
              <xsl:text>Your complaint reference number is:</xsl:text>
              <xsl:value-of select="MODERATION-REFERENCE"/>
            </p>
          </div>
          <br/>
          <div class="buttons">
            <xsl:apply-templates select="." mode="t_close"/>
          </div>
        </td>
      </tr>
    </table>
  </xsl:template>
  
  <xsl:template match="USER-COMPLAINT-FORM[ERROR][ERROR/@TYPE = 'EMAILNOTALLOWED']" mode="form_complaint">
    <table cellspacing="0" cellpadding="0" border="0" width="500" id="contentForm">
      <tr>
        <td id="tablenavbarForm" width="500">
          <p>Please read before continuing with your complaint</p>
        </td>
      </tr>
      <tr>
        <td id="formBg">
          <div class="textfield">
            <p>
              You have been restricted from using the online complaints system. If you wish to report a defamatory or illegal post or other serious breach of the BBC Editorial Guidelines, please write to:
            </p>
            <p>
              <b>
                Central Communities Team<br/>
                Broadcast Centre<br/>
                201 Wood Lane<br/>
                London<br/>
                W12 7TP<br/>
              </b>
            </p>
            <p>
              Please make a note of the <xsl:choose>
                <xsl:when test="@TYPE ='ARTICLE'">
                  article number <b>
                    <xsl:value-of select="H2G2-ID"/>
                  </b>
                </xsl:when>
                <xsl:when test="@TYPE='POST'">
                  post number <b>
                    <xsl:value-of select="POST-ID"/>
                  </b>
                </xsl:when>
                <xsl:when test="@TYPE='GENERAL'">
                  URL <b>
                    <xsl:value-of select="USER-COMPLAINT-FORM/URL"/>
                  </b>
                </xsl:when>
                <xsl:otherwise>
                  item
                </xsl:otherwise>
              </xsl:choose> and include it in your complaint. If you would like a response, please ensure that you include your full name, address and post code.
            </p>
          </div>
          <br/>
          <div class="buttons">
            <a href="#" onclick="window.close()">
              <img src="{$imagesource}cancel_button.gif" alt="Cancel" width="104" height="23" border="0"/>
            </a>
          </div>
        </td>
      </tr>
    </table>
  </xsl:template>
  
  <xsl:template match="USER-COMPLAINT-FORM[ERROR]" mode="form_complaint">
    <div class="textField">
      <xsl:value-of select="ERROR"/>
    </div>
    <div class="buttons">
      <xsl:if test="/H2G2/PARAMS/PARAM">
        <xsl:choose>
          <xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_complaintText']/VALUE = ''">
            <a href="{$root}/UserComplaint?PostId={/H2G2/PARAMS/PARAM[NAME = 's_postid']/VALUE}&amp;s_start=2">Back</a>
          </xsl:when>
          <xsl:otherwise>
            <a href="{$root}/UserComplaint?PostId={/H2G2/PARAMS/PARAM[NAME = 's_postid']/VALUE}&amp;s_start=3&amp;s_complaintText={/H2G2/PARAMS/PARAM[NAME = 's_complainttext']/VALUE}">Back</a>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:if>
    </div>
  </xsl:template>
  
  <xsl:template match="USER-COMPLAINT-FORM" mode="t_textarea">
    <textarea name="ComplaintText" xsl:use-attribute-sets="mUSER-COMPLAINT-FORM_t_textarea"/>
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
    <xsl:attribute name="value">
      <xsl:choose>
        <xsl:when test="/H2G2/VIEWING-USER/USER/EMAIL-ADDRESS">
          <xsl:value-of select="/H2G2/VIEWING-USER/USER/EMAIL-ADDRESS"/>
        </xsl:when>
        <xsl:otherwise>Enter your email address here</xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
  </xsl:attribute-set>
  <xsl:attribute-set name="mUSER-COMPLAINT-FORM_t_submit">
    <xsl:attribute name="type">image</xsl:attribute>
    <xsl:attribute name="src">
      <xsl:value-of select="$imagesource"/>send_complaint_button.gif
    </xsl:attribute>
    <xsl:attribute name="alt">Send complaint</xsl:attribute>
    <xsl:attribute name="name">Submit</xsl:attribute>
    <xsl:attribute name="value">
      <xsl:value-of select="$m_complaintsformsubmitbuttonlabel"/>
    </xsl:attribute>
    <xsl:attribute name="width">162</xsl:attribute>
    <xsl:attribute name="height">23</xsl:attribute>
    <xsl:attribute name="onClick">return checkUserComplaintForm()</xsl:attribute>
  </xsl:attribute-set>
  <xsl:attribute-set name="mUSER-COMPLAINT-FORM_t_next">
    <xsl:attribute name="type">image</xsl:attribute>
    <xsl:attribute name="src">
      <xsl:value-of select="$imagesource"/>next_button.gif
    </xsl:attribute>
    <xsl:attribute name="name">Next</xsl:attribute>
    <xsl:attribute name="alt">Next</xsl:attribute>
    <xsl:attribute name="value">
      <xsl:value-of select="$m_complaintsformnextbuttonlabel"/>
    </xsl:attribute>
    <xsl:attribute name="width">102</xsl:attribute>
    <xsl:attribute name="height">23</xsl:attribute>
  </xsl:attribute-set>
  <xsl:attribute-set name="mUSER-COMPLAINT-FORM_t_cancel">
    <xsl:attribute name="type">image</xsl:attribute>
    <xsl:attribute name="src">
      <xsl:value-of select="$imagesource"/>cancel_button.gif
    </xsl:attribute>
    <xsl:attribute name="alt">Cancel</xsl:attribute>
    <xsl:attribute name="name">Cancel</xsl:attribute>
    <xsl:attribute name="onClick">window.close()</xsl:attribute>
    <xsl:attribute name="value">
      <xsl:value-of select="$m_complaintsformcancelbuttonlabel"/>
    </xsl:attribute>
    <xsl:attribute name="width">104</xsl:attribute>
    <xsl:attribute name="height">23</xsl:attribute>
  </xsl:attribute-set>
  <xsl:attribute-set name="mUSER-COMPLAINT-FORM_t_close">
    <xsl:attribute name="src">
      <xsl:value-of select="$imagesource"/>close_window_button.gif
    </xsl:attribute>
    <xsl:attribute name="name">Close</xsl:attribute>
    <xsl:attribute name="value">Close</xsl:attribute>
    <xsl:attribute name="alt">Close</xsl:attribute>
    <xsl:attribute name="onClick">javascript:window.close()</xsl:attribute>
    <xsl:attribute name="width">122</xsl:attribute>
    <xsl:attribute name="height">19</xsl:attribute>
  </xsl:attribute-set>
</xsl:stylesheet>
