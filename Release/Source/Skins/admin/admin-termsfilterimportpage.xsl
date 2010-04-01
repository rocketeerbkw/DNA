<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<xsl:template name="TERMSFILTERIMPORT_MAINBODY">
    <xsl:variable name="termId" select="/H2G2/PARAMS/PARAM[NAME='s_termid']/VALUE" />
		<div id="topNav">
			<div id="bbcLogo">
				<img src="{$dnaAdminImgPrefix}/images/config_system/shared/bbc_logo.gif" alt="BBC"/>
			</div>
			<h1>DNA admin</h1>
		</div>
    <div style="width:770px; float:left;">
      <div id="subNav" style="background:#f4ebe4 url({$dnaAdminImgPrefix}/images/config_system/shared/icon_mod_man.gif) 0px 2px no-repeat;">
        <div id="subNavText">
          <h2>
            <a href="termsfilteradmin" style="color:#CC6600">Term Filter Administration</a>
          </h2>
        </div>
      </div>
        
      
      <form action="termsfilterimport" method="post" onsubmit="return validateForm(this);">
        <input type="hidden" value="UPDATETERMS" name="action" />
        <input type="hidden" value="s_termid" name="{$termId}" />
        <div style="clear:both;">
          <div style="float:left; margin: 20px">
            <p style="margin-bottom:0px; color:#000000; font-weight:bold;">
              Terms:
            </p>
            <xsl:choose>
              <xsl:when test="/H2G2/ERROR/@TYPE = 'UPDATETERMMISSINGTERM'">
                <textarea id="termtext" name="termtext" cols="20" rows="20" style="border: 2px solid red">
                  <xsl:value-of select="/H2G2/TERM"/>
                </textarea>
              </xsl:when>
              <xsl:otherwise>
                <textarea id="termtext" name="termtext" cols="20" rows="20">
                  <xsl:value-of select="/H2G2/TERM"/>
                </textarea>
              </xsl:otherwise>
            </xsl:choose>
            <br/>
            <p style="margin-bottom:0px; color:#000000; font-weight:bold;">
              Reason:
            </p>
            <xsl:choose>
              <xsl:when test="/H2G2/ERROR/@TYPE = 'UPDATETERMMISSINGDESCRIPTION'">
                <textarea id="reason" name="reason" cols="20" rows="3" style="border: 2px solid red"></textarea>
              </xsl:when>
              <xsl:otherwise>
                <textarea id="reason" name="reason" cols="20" rows="3"></textarea>
              </xsl:otherwise>
            </xsl:choose>

          </div>
          <div style="float:left; padding: 20px">
            <p style="margin-bottom:10px; color:#000000; font-weight:bold;">Moderation Classes</p>
            <table>
              <tr>
                <td>&nbsp;</td>
                <td width="120px">
                  Ask user <br />to re-edit
                </td>
                <td width="120px">
                  Send to <br />moderator
                </td>
                <td width="120px">
                  No Action
                </td>
              </tr>
              <tr>
                <td colspan="4">
                  <hr />
                </td>
              </tr>
              <tr>
                <td>
                  All
                  <noscript>
                    <input type="hidden" name="no_js" value="1"></input>
                  </noscript>
                </td>
                <td>
                  <input type="radio" name="action_modclassid_all" value="ReEdit" onclick="markAllRadio('ReEdit');"></input>
                </td>
                <td>
                  <input type="radio" name="action_modclassid_all" value="Refer" onclick="markAllRadio('Refer');"></input>
                </td>
                <td>
                  <input type="radio" name="action_modclassid_all" value="NoAction" onclick="markAllRadio('NoAction');"></input>
                </td>

              </tr>
              <tr>
                <td colspan="4">
                  <hr />
                </td>
              </tr>
              <xsl:apply-templates select="MODERATION-CLASSES/MODERATION-CLASS" mode="mainArea" />

            </table>
            <input type="submit" value="Apply"></input>

            <div style="clear:both;margin:0px; padding:0px;">
              <xsl:choose>
                <xsl:when test="/H2G2/RESULT/MESSAGE != ''">
                  <div id="serverResponse" name="serverResponse" style="float:left; margin-top:10px; border: 1px solid green;">
                    <p>
                      <xsl:value-of select="/H2G2/RESULT/MESSAGE"/>
                    </p>
                  </div>
                </xsl:when>
                <xsl:when test="/H2G2/ERROR/ERRORMESSAGE != ''">
                  <div id="serverResponse" name="serverResponse" style="float:left; margin-top:10px; border: 1px solid red;">
                    <p>
                      <b>An error has occurred:</b>
                      <BR/>
                      <xsl:value-of select="/H2G2/ERROR/ERRORMESSAGE"/>
                    </p>
                  </div>
                </xsl:when>
                <xsl:otherwise>

                </xsl:otherwise>
              </xsl:choose>

              <div id="errorDiv" name="errorDiv" style="float:left; margin-top:10px;border: 1px solid red;display: none;"></div>
            </div>

          </div>
        </div>
      </form>
		</div>
	</xsl:template>
	<xsl:template match="MODERATION-CLASS" mode="mainArea">
    <xsl:variable name="classId" select="@CLASSID"/>
    <tr>
      <td>
        <a href="termsfilteradmin?modclassid={$classId}"><xsl:value-of select="NAME"/></a>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="/H2G2/TERMSLISTS/TERMSLIST[@MODCLASSID=$classId]/TERM/@ACTION='ReEdit'">
            <input type="radio" name="action_modclassid_{@CLASSID}" value="ReEdit" checked="checked" />
          </xsl:when>
          <xsl:otherwise>
            <input type="radio" name="action_modclassid_{@CLASSID}" value="ReEdit" onclick="unMarkAllRadioButtons();" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="/H2G2/TERMSLISTS/TERMSLIST[@MODCLASSID=$classId]/TERM/@ACTION='Refer'">
            <input type="radio" name="action_modclassid_{@CLASSID}" value="Refer" checked="checked"  onclick="unMarkAllRadioButtons();"/>
          </xsl:when>
          <xsl:otherwise>
            <input type="radio" name="action_modclassid_{@CLASSID}" value="Refer"  onclick="unMarkAllRadioButtons();"/>
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="/H2G2/TERMSLISTS/TERMSLIST[@MODCLASSID=$classId]">
            
            <input type="radio" name="action_modclassid_{@CLASSID}" value="NoAction"  onclick="unMarkAllRadioButtons();"/>
          </xsl:when>
          <xsl:otherwise>
            <input type="radio" name="action_modclassid_{@CLASSID}" value="NoAction" checked="checked"  onclick="unMarkAllRadioButtons();"/>
          </xsl:otherwise>
        </xsl:choose>
        
      </td>

    </tr>
    
	</xsl:template>

  <xsl:template name="TERMSFILTERIMPORT_JAVASCRIPT">
    <script language="Javascript">
      function markAllRadio(type)
      {
      var inputs = document.getElementsByTagName("input");
      for(var index=0; index &lt; inputs.length; index++)
      {
      if(inputs[index].type == 'radio' &amp;&amp; inputs[index].value==type)
      {
      inputs[index].checked='checked';
      }


      }
      }

      function unMarkAllRadioButtons()
      {
      var inputs = document.getElementsByTagName("input");
      for(var index=0; index &lt; inputs.length; index++)
      {
      if(inputs[index].name == 'action_modclassid_all')
      {
      inputs[index].checked=false;
      }


      }
      }

      function validateForm(theForm)
      {
      var errorStyle="2px solid red";
      var error = document.getElementById("errorDiv");
      var serverResponse = document.getElementById("serverResponse");
      if(serverResponse != null)
      {
      serverResponse.style.display="none";
      }

      with(theForm)
      {
      if(reason.value == '')
      {
      error.innerHTML = "<p>Import reason cannot be empty.</p>";
      reason.style.border = errorStyle;
      error.style.display ="block";
      return false;
      }

      if(termtext.value == '')
      {
      error.innerHTML = "<p>Terms cannot be empty.</p>";
      termtext.style.border = errorStyle;
      error.style.display ="block";

      return false;
      }

      }

      reason.style.border = "";
      termtext.style.border = "";
      error.style.display ="none";
      return confirm("Are you sure you want make this update?");
      }

    </script>
  </xsl:template>
  
</xsl:stylesheet>
