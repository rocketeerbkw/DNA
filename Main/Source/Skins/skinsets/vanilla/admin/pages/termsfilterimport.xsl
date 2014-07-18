<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	version="1.0"
	xmlns:doc="http://www.bbc.co.uk/dna/documentation"
	xmlns="http://www.w3.org/1999/xhtml"
	exclude-result-prefixes="doc">

  <xsl:template match="H2G2[@TYPE = 'TERMSFILTERIMPORT']" mode="page">

    <xsl:call-template name="objects_links_breadcrumb">
      <xsl:with-param name="pagename" >Terms Filter Import</xsl:with-param>
    </xsl:call-template>
    <div class="dna-mb-intro blq-clearfix">
      Add new terms for moderation class -  <a href="termsfilteradmin" style="color:#CC6600">return to Term Filter Administration</a>

      <xsl:call-template name="refresh-cache" />

    </div>
    <xsl:variable name="termId" select="/H2G2/PARAMS/PARAM[NAME='s_termid']/VALUE" />
    <div class="dna-main dna-main-bg dna-main-pad blq-clearfix">
      <div class="dna-fl dna-main-full">
        <div class="dna-box">
          <h3>Import/Edit Terms</h3>
          <form action="termsfilterimport?s_termid={$termId}" method="post" onsubmit="return dnaterms_validateForm(this);">
            <input type="hidden" value="UPDATETERMS" name="action" />
            <div class="dna-fl">
              <p style="margin-bottom:0px; color:#000000; font-weight:bold;">
                Terms: (Enter one per line)
              </p>
              <xsl:choose>
                <xsl:when test="/H2G2/ERROR/@TYPE = 'UPDATETERMMISSINGTERM'">
                  <textarea id="termtext" name="termtext" cols="15" rows="20" style="border: 2px solid red">
                    <xsl:value-of select="/H2G2/TERMDETAILS/@TERM"/>
                  </textarea>
                </xsl:when>
                <xsl:otherwise>
                  <textarea id="termtext" name="termtext" cols="15" rows="20">
                    <xsl:value-of select="/H2G2/TERMDETAILS/@TERM"/>
                  </textarea>
                </xsl:otherwise>
              </xsl:choose>
              <br/>
              <p style="margin-bottom:0px; color:#000000; font-weight:bold;">
                Reason:
              </p>
              <xsl:choose>
                <xsl:when test="/H2G2/ERROR/@TYPE = 'UPDATETERMMISSINGDESCRIPTION'">
                  <textarea id="reason" name="reason" cols="15" rows="3" style="border: 2px solid red">
                    <xsl:text> </xsl:text>
                  </textarea>
                </xsl:when>
                <xsl:otherwise>
                  <textarea id="reason" name="reason" cols="15" rows="3">
                    <xsl:text> </xsl:text>
                  </textarea>
                </xsl:otherwise>
              </xsl:choose>

            </div>
            <div class="dna-fl dna-main-left">
              <p style="margin-bottom:10px; color:#000000; font-weight:bold;">Moderation Classes</p>
              <table class="dna-termslist">
                <tr>
                  <td>&#160;</td>
                  <td width="100px">
                    Ask user <br />to re-edit
                  </td>
                  <td width="100px">
                    Send to <br />moderator
                  </td>
                  <td width="100px">
                    No Action
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
                    <input type="radio" name="action_modclassid_all" value="ReEdit" onclick="dnaterms_markAllRadio('ReEdit');"></input>
                  </td>
                  <td>
                    <input type="radio" name="action_modclassid_all" value="Refer" onclick="dnaterms_markAllRadio('Refer');"></input>
                  </td>
                  <td>
                    <input type="radio" name="action_modclassid_all" value="NoAction" onclick="dnaterms_markAllRadio('NoAction');"></input>
                  </td>

                </tr>
                <xsl:apply-templates select="MODERATION-CLASSES/MODERATION-CLASS" mode="mainArea" />

              </table>
              <input type="submit" value="Apply"></input>
              <xsl:apply-templates select="TERMDETAILS" mode="lastupdate" />

              <div id="dnaTermErrorDiv" name="dnaTermErrorDiv" style="clear:both; float:left; margin-top:10px;border: 1px solid red;display: none;"></div>


              <div style="clear: both">
                <xsl:choose>
                  <xsl:when test="/H2G2/RESULT/MESSAGE != ''">
                    <xsl:if test="/H2G2/RESULT/@TYPE='TermsUpdateSuccess'">
                      <script type="text/javascript">
                        <xsl:comment>
                          <![CDATA[ 
								                alert("Please refresh the Live Cache, so that the updated/new term(s) can go live immediately.\n\n Thank you.");
							            ]]>
                        </xsl:comment>
                      </script>
                    </xsl:if>
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


              </div>
            </div>
          </form>
        </div>
      </div>
    </div>

  </xsl:template>

  <xsl:template match="MODERATION-CLASS" mode="mainArea">
    <xsl:variable name="classId" select="@CLASSID"/>
    <tr>
      <xsl:if test="position() mod 2 = 1">
        <xsl:attribute name="class">odd</xsl:attribute>
      </xsl:if>
      <td>
        <a href="termsfilteradmin?modclassid={$classId}">
          <xsl:value-of select="NAME"/>
        </a>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="/H2G2/TERMSLISTS/TERMSLIST[@MODCLASSID=$classId]/TERMDETAILS/@ACTION='ReEdit'">
            <input type="radio" name="action_modclassid_{@CLASSID}" value="ReEdit" checked="checked" />
          </xsl:when>
          <xsl:otherwise>
            <input type="radio" name="action_modclassid_{@CLASSID}" value="ReEdit" onclick="dnaterms_unMarkAllRadioButtons();" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="/H2G2/TERMSLISTS/TERMSLIST[@MODCLASSID=$classId]/TERMDETAILS/@ACTION='Refer'">
            <input type="radio" name="action_modclassid_{@CLASSID}" value="Refer" checked="checked"  onclick="dnaterms_unMarkAllRadioButtons();"/>
          </xsl:when>
          <xsl:otherwise>
            <input type="radio" name="action_modclassid_{@CLASSID}" value="Refer"  onclick="dnaterms_unMarkAllRadioButtons();"/>
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

  <xsl:template match="TERMDETAILS" mode="lastupdate">

    <div>
      <strong>Last Update</strong>
      <br />
      <xsl:choose>
        <xsl:when test="REASON = 'Reason Unknown'">
        </xsl:when>
        <xsl:otherwise>
          "<xsl:value-of select="REASON"/>"
        </xsl:otherwise>
      </xsl:choose>

      <xsl:choose>
        <xsl:when test="REASON = 'Reason Unknown'">
        </xsl:when>
        <xsl:otherwise>
          <br />by <a href="memberdetails?userid={@USERID}">
            <xsl:value-of select="USERNAME"/>
          </a>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:choose>
        <xsl:when test="REASON = 'Reason Unknown'">
        </xsl:when>
        <xsl:otherwise>
          (<xsl:value-of select="UPDATEDDATE/DATE/@RELATIVE"/>)
        </xsl:otherwise>
      </xsl:choose>

    </div>


  </xsl:template>

</xsl:stylesheet>
