<!DOCTYPE xsl:stylesheet [
  <!ENTITY nbsp "&#160;">
  <!ENTITY darr "&#8595;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-	microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
  <xsl:import href="../../../base/base-addthreadpage.xsl"/>
  <xsl:template name="ADDTHREAD_JAVASCRIPT">
    <script type="text/javascript">
      function check(location) {
      if (confirm("Are you sure?")) {
      location.href = "<xsl:value-of select="$returnlocation"/>";
      }
      else {
      location.href = "#";
      }
      }

      function countDown() {
      var minutesSpan = document.getElementById("minuteValue");
      var secondsSpan = document.getElementById("secondValue");

      var minutes = new Number(minutesSpan.childNodes[0].nodeValue);
      var seconds = new Number(secondsSpan.childNodes[0].nodeValue);

      var inSeconds = (minutes*60) + seconds;
      var timeNow = inSeconds - 1;

      if (timeNow >= 0){
      var scratchPad = timeNow / 60;
      var minutesNow = Math.floor(scratchPad);
      var secondsNow = (timeNow - (minutesNow * 60));

      var minutesText = document.createTextNode(minutesNow);
      var secondsText = document.createTextNode(secondsNow);

      minutesSpan.removeChild(minutesSpan.childNodes[0]);
      secondsSpan.removeChild(secondsSpan.childNodes[0]);

      minutesSpan.appendChild(minutesText);
      secondsSpan.appendChild(secondsText);
      }
      }
    </script>
  </xsl:template>
  <xsl:variable name="returnlocation">
    <xsl:choose>
      <xsl:when test="@INREPLYTO &gt; 0">
        <xsl:value-of select="$root"/>F<xsl:value-of select="/H2G2/POSTTHREADFORM/@FORUMID"/>?thread=<xsl:value-of select="/H2G2/POSTTHREADFORM/@THREADID"/>&amp;post=<xsl:value-of select="/H2G2/POSTTHREADFORM/@INREPLYTO"/>#p<xsl:value-of select="/H2G2/POSTTHREADFORM/@INREPLYTO"/>
    </xsl:when>
    <xsl:when test="RETURNTO">
      <xsl:value-of select="$root"/>A<xsl:value-of select="/H2G2/POSTTHREADFORM/RETURNTO/H2G2ID"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$root"/>F<xsl:value-of select="/H2G2/POSTTHREADFORM/@FORUMID"/>?thread=<xsl:value-of select="/H2G2/POSTTHREADFORM/@THREADID"/>&amp;post=<xsl:value-of select="/H2G2/POSTTHREADFORM/@INREPLYTO"/>#p<xsl:value-of select="/H2G2/POSTTHREADFORM/@INREPLYTO"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <!--
	ADDTHREAD_MAINBODY
	-->
  <!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
									Page - Level  template
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
  <xsl:template name="ADDTHREAD_MAINBODY">
    <table width="635" cellpadding="0" cellspacing="0" border="0" id="main">
      <tr>
        <xsl:choose>
          <xsl:when test="POSTPREMODERATED/@FORUM or POSTQUEUED/@FORUM">
            <td id="crumbtrail">
              <h5>
                <xsl:text>You are here &gt; </xsl:text>
                <a href="{$homepage}">
                  <xsl:value-of select="/H2G2/SITECONFIG/BOARDNAME"/>message boards
                </a> &gt; <a href="{$root}F{/H2G2/FORUMSOURCE/ARTICLE/ARTICLEINFO/FORUMID}">
                  <xsl:value-of select="FORUMSOURCE/ARTICLE/SUBJECT"/>
                </a>
              </h5>
            </td>
          </xsl:when>
          <xsl:otherwise>
            <td id="crumbtrail">
              <h5>
                <xsl:text>You are here &gt; </xsl:text>
                <a href="{$homepage}">
                  <xsl:value-of select="/H2G2/SITECONFIG/BOARDNAME"/>message boards
                </a>
                <xsl:text> &gt; </xsl:text>
                <a href="{$root}F{/H2G2/POSTTHREADFORM/@FORUMID}">
                  <xsl:value-of select="FORUMSOURCE/ARTICLE/SUBJECT"/>
                </a>
                <xsl:choose>
                  <xsl:when test="POSTTHREADFORM/@INREPLYTO = 0"> &gt; Start a new discussion</xsl:when>
                  <xsl:otherwise>
                    <xsl:text> &gt; </xsl:text>
                    <a href="{$root}F{/H2G2/POSTTHREADFORM/@FORUMID}?thread={POSTTHREADFORM/@THREADID}">
                      <xsl:value-of select="/H2G2/POSTTHREADFORM/SUBJECT"/>
                    </a>
                    <xsl:text> &gt; Reply to a post</xsl:text>
                  </xsl:otherwise>
                </xsl:choose>
              </h5>
            </td>
          </xsl:otherwise>
        </xsl:choose>
      </tr>
      <tr>
        <td class="pageheader">
          <table width="635" border="0" cellpadding="0" cellspacing="0">
            <tr>
              <td id="subject">
                <h1>
                  <xsl:choose>
                    <xsl:when test="POSTPREMODERATED/@FORUM or POSTQUEUED/@FORUM or //VIEWING-USER/PROMPTSETUSERNAME = 1">
                      <xsl:text>Message sent</xsl:text>
                    </xsl:when>
                    <xsl:when test="POSTTHREADFORM/@INREPLYTO = 0">
                      <!-- When it is start a new discussion... -->
                      <xsl:text>Start a new discussion</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                      <!-- When it is a reply... -->
                      <xsl:text>Reply to a message</xsl:text>
                    </xsl:otherwise>
                  </xsl:choose>
                </h1>
              </td>
              <td id="rulesHelp">
                <p>
                  <a href="{$houserulespopupurl}" onclick="popupwindow('{$houserulespopupurl}', 'popwin', 'status=1,resizable=1,scrollbars=1,width=440,height=380');return false;" target="popwin" title="This link opens in a new popup window">House rules</a>  | <a href="{$faqpopupurl}" onclick="popupwindow('{$faqpopupurl}', 'popwin', 'status=1,resizable=1,scrollbars=1,toolbar=1,width=550,height=380');return false;" target="popwin" title="This link opens in a new popup window">Help</a>
                </p>
              </td>
            </tr>
          </table>
        </td>
      </tr>
      <tr>
        <td width="635" align="right">
          <table width="630" cellpadding="0" cellspacing="0" border="0">
            <tr>
              <td valign="top">
                <table width="500" cellpadding="0" cellspacing="0" border="0" id="contentForm">
                  <tr>
                    <td id="tablenavbarForm" width="500">
                      <p>
                        <xsl:choose>
                          <xsl:when test="POSTTHREADFORM/@INREPLYTO = 0">
                            <!-- When it is start a new discussion... -->
                            <xsl:choose>
                              <xsl:when test="string-length(/H2G2/POSTTHREADFORM/BODY) = 0 or /H2G2/PARAMS/PARAM[NAME='s_edit']">
                                <xsl:text>To create a new discussion, just fill out the form below</xsl:text>
                              </xsl:when>
                              <xsl:otherwise>
                                <xsl:text>If you are not satisfied with your message, you can click 'edit' to go back</xsl:text>
                              </xsl:otherwise>
                            </xsl:choose>
                          </xsl:when>
                          <xsl:otherwise>
                            <!-- When it is a reply... -->
                            <xsl:choose>
                              <xsl:when test="POSTPREMODERATED/@FORUM or POSTQUEUED/@FORUM">
                              </xsl:when>
                              <xsl:when test="not(/H2G2/POSTTHREADFORM/PREVIEWBODY) or /H2G2/PARAMS/PARAM[NAME='s_edit'] or /H2G2/POSTTHREADFORM/QUOTEADDED = 1">
                                <!-- When you're back editing the message again -->
                                <xsl:text>Just fill out the form below.</xsl:text>
                                <!--If you want to include the message you are replying to, click on 'Add original message'-->
                              </xsl:when>
                              <xsl:otherwise>
                                <!-- When you're not.. -->
                                <xsl:text>If you are unhappy with the message, click 'Edit' to change it</xsl:text>
                              </xsl:otherwise>
                            </xsl:choose>
                          </xsl:otherwise>
                        </xsl:choose>
                      </p>
                    </td>
                  </tr>
                  <tr>
                    <td valign="top" width="500" id="formArea">
                      <!-- xsl:apply-templates select="FORUMSOURCE/ARTICLE/GUIDE/ADDTHREADINTRO" mode="c_addthread"/ -->
                      <xsl:apply-templates select="POSTTHREADFORM" mode="c_addthread"/>
                      <xsl:apply-templates select="POSTTHREADUNREG" mode="c_addthread"/>
                      <xsl:apply-templates select="POSTPREMODERATED" mode="c_addthread"/>
                      <xsl:apply-templates select="POSTQUEUED" mode="c_addthread"/>
                      <xsl:apply-templates select="ERROR" mode="c_addthread"/>
                      <xsl:if test="POSTPREMODERATED/@FORUM or POSTQUEUED/@FORUM or POSTTHREADFORM/@FORUM or POSTTHREADUNREG/@FORUM">
                        <xsl:apply-templates select="/H2G2/VIEWING-USER/USER/PROMPTSETUSERNAME" mode="c_addthread"/>
                      </xsl:if>
                    </td>
                  </tr>
                  <tr>
                    <td id="previewArea">
                      <xsl:choose>
                        <xsl:when test="not(/H2G2/POSTTHREADFORM/PREVIEWBODY) or /H2G2/PARAMS/PARAM[NAME='s_edit'] or /H2G2/POSTTHREADFORM/QUOTEADDED = 1">
                          <xsl:choose>
                            <xsl:when test="/H2G2/POSTTHREADFORM/@INREPLYTO = 0">
                              <span style="visibility:hidden">.</span>
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:apply-templates select="/H2G2/POSTTHREADFORM/INREPLYTO" mode="c_addthread"/>
                            </xsl:otherwise>
                          </xsl:choose>
                          <!--xsl:choose>
														<xsl:when test="POSTTHREADFORM/PREVIEWBODY">
															<div style="margin-top:5px;margin-bottom:5px;">
																<font size="5">Your message will look like this</font>
															</div>
														</xsl:when>
														<xsl:otherwise>
															<div style="margin-top:5px;margin-bottom:5px;">
																<font size="5">Start a new discussion</font>
															</div>
														</xsl:otherwise>
													</xsl:choose-->
                        </xsl:when>
                        <xsl:otherwise>
                          <span style="visibility:hidden">.</span>
                        </xsl:otherwise>
                      </xsl:choose>
                    </td>
                  </tr>
                </table>
              </td>
              <td valign="top" width="130" id="promoArea">
                <xsl:choose>
                  <xsl:when test="POSTTHREADFORM/@INREPLYTO = 0">
                    <!-- When it is start a new discussion... -->
                    <br/>
                    <br/>
                    <xsl:if test="not(/H2G2/CURRENTSITEURLNAME = 'mbcbbc' or /H2G2/CURRENTSITEURLNAME = 'mbnewsround')">
                      <xsl:if test="not(/H2G2/FORUMSOURCE/ARTICLE/GUIDE/BODY/EDITORONLY)">
                        <table cellspacing="0" cellpadding="1" border="0" width="120" class="promoTable">
                          <tr>
                            <td class="blockSide" colspan="2"/>
                            <td>
                              <img src="http://www.bbc.co.uk/f/t.gif" width="1" height="1" alt=""/>
                            </td>
                          </tr>
                          <tr>
                            <td class="blockSide"/>
                            <td class="blockMain">
                              <img src="http://www.bbc.co.uk/dnaimages/boards/images/help_icon_involved.gif" width="15" height="15" alt="Getting Involved help:" title="Getting Involved help:" align="top" border="0"/>
                              <xsl:text> How to </xsl:text>
                              <a href="http://www.bbc.co.uk/messageboards/newguide/popup_start_discussion.html" onclick="popupwindow('http://www.bbc.co.uk/messageboards/newguide/popup_start_discussion.html', 'popwin', 'status=1,resizable=1,scrollbars=1,width=440,height=380');return false;" target="popwin">
                                <xsl:text>start a discussion</xsl:text>
                                <img src="http://www.bbc.co.uk/dnaimages/boards/images/popup.gif" width="20" height="15" alt="This link opens in a new popup window" title="" align="top" border="0"/>
                              </a>
                            </td>
                            <td class="blockShadow"/>
                          </tr>
                          <tr>
                            <td>
                              <img src="http://www.bbc.co.uk/f/t.gif" width="1" height="1" alt=""/>
                            </td>
                            <td class="blockShadow" colspan="2"/>
                          </tr>
                        </table>
                      </xsl:if>
                      <table cellspacing="0" cellpadding="1" border="0" width="120" class="promoTable">
                        <tr>
                          <td class="blockSide" colspan="2"/>
                          <td>
                            <img src="http://www.bbc.co.uk/f/t.gif" width="1" height="1" alt=""/>
                          </td>
                        </tr>
                        <tr>
                          <td class="blockSide"/>
                          <td class="blockMain">
                            <img src="http://www.bbc.co.uk/dnaimages/boards/images/help_icon_writing.gif" width="15" height="15" alt="Writing messages help:" title="Writing messages help:" align="top" border="0"/>
                            <xsl:text> </xsl:text>
                            <a href="http://www.bbc.co.uk/messageboards/newguide/popup_rules_guidelines.html" onclick="popupwindow('http://www.bbc.co.uk/messageboards/newguide/popup_rules_guidelines.html', 'popwin', 'status=1,resizable=1,scrollbars=1,width=440,height=380');return false;" target="popwin">
                              <xsl:text>Rules and guidelines</xsl:text>
                              <img src="http://www.bbc.co.uk/dnaimages/boards/images/popup.gif" width="20" height="15" alt="This link opens in a new popup window" title="" align="top" border="0"/>
                            </a>
                          </td>
                          <td class="blockShadow"/>
                        </tr>
                        <tr>
                          <td>
                            <img src="http://www.bbc.co.uk/f/t.gif" width="1" height="1" alt=""/>
                          </td>
                          <td class="blockShadow" colspan="2"/>
                        </tr>
                      </table>
                      <table cellspacing="0" cellpadding="1" border="0" width="120" class="promoTable">
                        <tr>
                          <td class="blockSide" colspan="2"/>
                          <td>
                            <img src="http://www.bbc.co.uk/f/t.gif" width="1" height="1" alt=""/>
                          </td>
                        </tr>
                        <tr>
                          <td class="blockSide"/>
                          <td class="blockMain">
                            <img src="http://www.bbc.co.uk/dnaimages/boards/images/help_icon_features.gif" width="15" height="15" alt="Message boards Features help:" title="Message boards Features help:" align="top" border="0"/>
                            <xsl:text> Add </xsl:text>
                            <a href="http://www.bbc.co.uk/messageboards/newguide/popup_smiley.html" onclick="popupwindow('http://www.bbc.co.uk/messageboards/newguide/popup_smiley.html', 'popwin', 'status=1,resizable=1,scrollbars=1,width=440,height=380');return false;" target="popwin">
                              <xsl:text>smileys </xsl:text>
                              <img src="http://www.bbc.co.uk/dnaimages/boards/images/f_biggrin.gif" width="16" height="16" alt="smiley" align="top" border="0"/>
                            </a>
                            <xsl:text> to messages </xsl:text>
                            <a href="http://www.bbc.co.uk/messageboards/newguide/popup_smiley.html" onclick="popupwindow('http://www.bbc.co.uk/messageboards/newguide/popup_smiley.html', 'popwin', 'status=1,resizable=1,scrollbars=1,width=440,height=380');return false;" target="popwin">
                              <img src="http://www.bbc.co.uk/dnaimages/boards/images/popup.gif" width="20" height="15" alt="This link opens in a new popup window" title="" align="top" border="0"/>
                            </a>
                          </td>
                          <td class="blockShadow"/>
                        </tr>
                        <tr>
                          <td>
                            <img src="http://www.bbc.co.uk/f/t.gif" width="1" height="1" alt=""/>
                          </td>
                          <td class="blockShadow" colspan="2"/>
                        </tr>
                      </table>
                      <table cellspacing="0" cellpadding="1" border="0" width="120" class="promoTable">
                        <tr>
                          <td class="blockSide" colspan="2"/>
                          <td>
                            <img src="http://www.bbc.co.uk/f/t.gif" width="1" height="1" alt=""/>
                          </td>
                        </tr>
                        <tr>
                          <td class="blockSide"/>
                          <td class="blockMain">
                            <img src="http://www.bbc.co.uk/dnaimages/boards/images/help_icon_features.gif" width="15" height="15" alt="Message boards Features help:" title="Message boards Features help:" align="top" border="0"/>
                            <xsl:text> Add </xsl:text>
                            <a href="http://www.bbc.co.uk/messageboards/newguide/popup_editorial_guidelines.html" onclick="popupwindow('http://www.bbc.co.uk/messageboards/newguide/popup_editorial_guidelines.html', 'popwin', 'status=1,resizable=1,scrollbars=1,width=440,height=380');return false;" target="popwin">
                              <xsl:text>web links</xsl:text>
                            </a>
                            <xsl:text> to messages </xsl:text>
                            <a href="http://www.bbc.co.uk/messageboards/newguide/popup_editorial_guidelines.html" onclick="popupwindow('http://www.bbc.co.uk/messageboards/newguide/popup_editorial_guidelines.html', 'popwin', 'status=1,resizable=1,scrollbars=1,width=440,height=380');return false;" target="popwin">
                              <img src="http://www.bbc.co.uk/dnaimages/boards/images/popup.gif" width="20" height="15" alt="This link opens in a new popup window" title="" align="top" border="0"/>
                            </a>
                          </td>
                          <td class="blockShadow"/>
                        </tr>
                        <tr>
                          <td>
                            <img src="http://www.bbc.co.uk/f/t.gif" width="1" height="1" alt=""/>
                          </td>
                          <td class="blockShadow" colspan="2"/>
                        </tr>
                      </table>
                    </xsl:if>
                  </xsl:when>
                  <xsl:otherwise>
                    <!-- When it is a reply... -->
                    <br/>
                    <br/>
                    <xsl:if test="not(/H2G2/CURRENTSITEURLNAME = 'mbcbbc' or /H2G2/CURRENTSITEURLNAME = 'mbnewsround')">
                      <table cellspacing="0" cellpadding="1" border="0" width="120" class="promoTable">
                        <tr>
                          <td class="blockSide" colspan="2"/>
                          <td>
                            <img src="http://www.bbc.co.uk/f/t.gif" width="1" height="1" alt=""/>
                          </td>
                        </tr>
                        <tr>
                          <td class="blockSide"/>
                          <td class="blockMain">
                            <img src="http://www.bbc.co.uk/dnaimages/boards/images/help_icon_involved.gif" width="15" height="15" alt="Getting Involved help:" title="Getting Involved help:" align="top" border="0"/>
                            <xsl:text> How to </xsl:text>
                            <a href="http://www.bbc.co.uk/messageboards/newguide/popup_reply_message.html" onclick="popupwindow('http://www.bbc.co.uk/messageboards/newguide/popup_reply_message.html', 'popwin', 'status=1,resizable=1,scrollbars=1,width=440,height=380');return false;" target="popwin">
                              <xsl:text>reply to messages</xsl:text>
                              <img src="http://www.bbc.co.uk/dnaimages/boards/images/popup.gif" width="20" height="15" alt="This link opens in a new popup window" title="" align="top" border="0"/>
                            </a>
                          </td>
                          <td class="blockShadow"/>
                        </tr>
                        <tr>
                          <td>
                            <img src="http://www.bbc.co.uk/f/t.gif" width="1" height="1" alt=""/>
                          </td>
                          <td class="blockShadow" colspan="2"/>
                        </tr>
                      </table>
                      <table cellspacing="0" cellpadding="1" border="0" width="120" class="promoTable">
                        <tr>
                          <td class="blockSide" colspan="2"/>
                          <td>
                            <img src="http://www.bbc.co.uk/f/t.gif" width="1" height="1" alt=""/>
                          </td>
                        </tr>
                        <tr>
                          <td class="blockSide"/>
                          <td class="blockMain">
                            <img src="http://www.bbc.co.uk/dnaimages/boards/images/help_icon_features.gif" width="15" height="15" alt="Message boards Features help:" title="Message boards Features help:" align="top" border="0"/>
                            <xsl:text> Add </xsl:text>
                            <a href="http://www.bbc.co.uk/messageboards/newguide/popup_smiley.html" onclick="popupwindow('http://www.bbc.co.uk/messageboards/newguide/popup_smiley.html', 'popwin', 'status=1,resizable=1,scrollbars=1,width=440,height=380');return false;" target="popwin">
                              <xsl:text>smileys </xsl:text>
                              <img src="http://www.bbc.co.uk/dnaimages/boards/images/f_biggrin.gif" width="16" height="16" alt="smiley" align="top" border="0"/>
                            </a>
                            <xsl:text> to messages </xsl:text>
                            <a href="http://www.bbc.co.uk/messageboards/newguide/popup_smiley.html" onclick="popupwindow('http://www.bbc.co.uk/messageboards/newguide/popup_smiley.html', 'popwin', 'status=1,resizable=1,scrollbars=1,width=440,height=380');return false;" target="popwin">
                              <img src="http://www.bbc.co.uk/dnaimages/boards/images/popup.gif" width="20" height="15" alt="This link opens in a new popup window" title="" align="top" border="0"/>
                            </a>
                          </td>
                          <td class="blockShadow"/>
                        </tr>
                        <tr>
                          <td>
                            <img src="http://www.bbc.co.uk/f/t.gif" width="1" height="1" alt=""/>
                          </td>
                          <td class="blockShadow" colspan="2"/>
                        </tr>
                      </table>
                      <table cellspacing="0" cellpadding="1" border="0" width="120" class="promoTable">
                        <tr>
                          <td class="blockSide" colspan="2"/>
                          <td>
                            <img src="http://www.bbc.co.uk/f/t.gif" width="1" height="1" alt=""/>
                          </td>
                        </tr>
                        <tr>
                          <td class="blockSide"/>
                          <td class="blockMain">
                            <img src="http://www.bbc.co.uk/dnaimages/boards/images/help_icon_features.gif" width="15" height="15" alt="Message boards Features help:" title="Message boards Features help:" align="top" border="0"/>
                            <xsl:text> Add </xsl:text>
                            <a href="http://www.bbc.co.uk/messageboards/newguide/popup_editorial_guidelines.html" onclick="popupwindow('http://www.bbc.co.uk/messageboards/newguide/popup_editorial_guidelines.html', 'popwin', 'status=1,resizable=1,scrollbars=1,width=440,height=380');return false;" target="popwin">
                              <xsl:text>web links</xsl:text>
                            </a>
                            <xsl:text> to messages </xsl:text>
                            <a href="http://www.bbc.co.uk/messageboards/newguide/popup_editorial_guidelines.html" onclick="popupwindow('http://www.bbc.co.uk/messageboards/newguide/popup_editorial_guidelines.html', 'popwin', 'status=1,resizable=1,scrollbars=1,width=440,height=380');return false;" target="popwin">
                              <img src="http://www.bbc.co.uk/dnaimages/boards/images/popup.gif" width="20" height="15" alt="This link opens in a new popup window" title="" align="top" border="0"/>
                            </a>
                          </td>
                          <td class="blockShadow"/>
                        </tr>
                        <tr>
                          <td>
                            <img src="http://www.bbc.co.uk/f/t.gif" width="1" height="1" alt=""/>
                          </td>
                          <td class="blockShadow" colspan="2"/>
                        </tr>
                      </table>
                      <table cellspacing="0" cellpadding="1" border="0" width="120" class="promoTable">
                        <tr>
                          <td class="blockSide" colspan="2"/>
                          <td>
                            <img src="http://www.bbc.co.uk/f/t.gif" width="1" height="1" alt=""/>
                          </td>
                        </tr>
                        <tr>
                          <td class="blockSide"/>
                          <td class="blockMain">
                            <img src="http://www.bbc.co.uk/dnaimages/boards/images/help_icon_writing.gif" width="15" height="15" alt="Writing messages help:" title="Writing messages help:" align="top" border="0"/>
                            <xsl:text> </xsl:text>
                            <a href="http://www.bbc.co.uk/messageboards/newguide/popup_rules_guidelines.html" onclick="popupwindow('http://www.bbc.co.uk/messageboards/newguide/popup_rules_guidelines.html', 'popwin', 'status=1,resizable=1,scrollbars=1,width=440,height=380');return false;" target="popwin">
                              <xsl:text>Rules and guidelines</xsl:text>
                              <img src="http://www.bbc.co.uk/dnaimages/boards/images/popup.gif" width="20" height="15" alt="This link opens in a new popup window" title="" align="top" border="0"/>
                            </a>
                          </td>
                          <td class="blockShadow"/>
                        </tr>
                        <tr>
                          <td>
                            <img src="http://www.bbc.co.uk/f/t.gif" width="1" height="1" alt=""/>
                          </td>
                          <td class="blockShadow" colspan="2"/>
                        </tr>
                      </table>
                    </xsl:if>
                  </xsl:otherwise>
                </xsl:choose>
              </td>
            </tr>
          </table>
        </td>
      </tr>
    </table>
  </xsl:template>
  <!-- 
	<xsl:template match="ADDTHREADINTRO" mode="r_addthread">
	Use: Presentation of an introduction to a particular thread - defined in the article XML
	-->
  <xsl:template match="ADDTHREADINTRO" mode="r_addthread">
    <xsl:apply-templates/>
  </xsl:template>
  <!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
						POSTTHREADFORM Object
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
  <!-- 
	<xsl:template match="POSTTHREADFORM" mode="r_addthread">
	Use: The presentation of the form that generates a post. It has a preview area - ie what the post
	will look like when submitted, and a form area.
	-->
  <xsl:template match="POSTTHREADFORM" mode="r_addthread">
    <xsl:apply-templates select="." mode="c_form"/>
  </xsl:template>
  <!-- 
	<xsl:template match="POSTTHREADFORM" mode="r_preview">
	Use: The presentation of the preview - this can either be an error or a normal display
	-->
  <xsl:template match="POSTTHREADFORM" mode="r_preview">
    <xsl:apply-templates select="PREVIEWERROR" mode="c_addthread"/>
    <xsl:apply-templates select="." mode="c_previewbody"/>
  </xsl:template>
  <!-- 
	<xsl:template match="PREVIEWERROR" mode="r_addthread">
	Use: presentation of the preview if it is an error
	-->
  <xsl:template match="PREVIEWERROR" mode="r_addthread">
    <tr>
      <td class="body">
        <xsl:apply-imports/>
      </td>
    </tr>
  </xsl:template>
  <!-- 
	<xsl:template match="POSTTHREADFORM" mode="r_previewbody">
	Use: presentation of the preview if it is not an error. 
	-->
  <xsl:template match="POSTTHREADFORM" mode="r_previewbody">
    <xsl:if test="not(/H2G2/PARAMS/PARAM[NAME='s_edit'])  and not(/H2G2/POSTTHREADFORM/QUOTEADDED = 1)">
      <table cellpadding="0" cellspacing="0" border="0" id="previewTableTwo">
        <tr>
          <th>
            <p>Your message looks like this:</p>
            <p class="instructional">
              <xsl:choose>
                <xsl:when test="string(/H2G2/SITECONFIG/EXTEXTPREVIEW)">
                  <xsl:value-of select="/H2G2/SITECONFIG/EXTEXTPREVIEW"/>
                </xsl:when>
                <xsl:otherwise>
                  If you are satisfied with your message, proceed by clicking on Post message.
                </xsl:otherwise>
              </xsl:choose>
            </p>
            <xsl:if test="SECONDSBEFOREREPOST">
              <p>
                <xsl:attribute name="class">
                  <xsl:choose>
                    <xsl:when test="@POSTEDBEFOREREPOSTTIMEELAPSED">countdownWarning</xsl:when>
                    <xsl:otherwise>countdown</xsl:otherwise>
                  </xsl:choose>
                </xsl:attribute>
                <xsl:text>You must wait </xsl:text>
                <span id="minuteValue">
                  <xsl:number value="floor(SECONDSBEFOREREPOST div 60)"/>
                </span>
                <xsl:text> minutes </xsl:text>
                <span id="secondValue">
                  <xsl:number value="SECONDSBEFOREREPOST - floor(SECONDSBEFOREREPOST div 60)*60"/>
                </span>
                <xsl:text> secs before you can post again</xsl:text>
              </p>
            </xsl:if>
          </th>
        </tr>
        <tr>
          <td class="postPreview">
            <xsl:if test="/H2G2/POSTTHREADFORM/@INREPLYTO = 0">
              <p class="strong">
                <xsl:choose>
                  <xsl:when test="string-length(SUBJECT) = 0">
                    No Discussion Title
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="SUBJECT"/>
                  </xsl:otherwise>
                </xsl:choose>
              </p>
            </xsl:if>
            <div class="postContentOne">
              <xsl:apply-templates select="PREVIEWBODY" mode="t_addthread"/>
            </div>
          </td>
        </tr>
        <tr>
          <td colspan="2" align="right">
            <div class="buttonsTwo">
              <xsl:apply-templates select="/H2G2/POSTTHREADFORM" mode="t_returntoconversation"/>
              &nbsp;
              <input type="image" src="{$imagesource}edit_button.gif" alt="Edit" width="94" height="23" name="preview"/>
              &nbsp;
              <xsl:apply-templates select="." mode="t_submitpost"/>
            </div>
            <input type="hidden" name="s_edit" value="yes"/>
          </td>
        </tr>
      </table>
    </xsl:if>
  </xsl:template>
  <!-- 
	<xsl:template match="POSTTHREADFORM" mode="r_form">
	Use: presentation of the post submission form and surrounding data
	-->
  <xsl:template match="POSTTHREADFORM" mode="r_form">
    <!--<input type="hidden" name="skin" value="purexml"/>-->
    <xsl:if test="@PROFANITYTRIGGERED = 1">
      <input type="hidden" name="profanitytriggered" value="1"/>
    </xsl:if>
    <xsl:apply-templates select="." mode="c_preview"/>
    <xsl:apply-templates select="." mode="c_premoderationmessage"/>
    <xsl:apply-templates select="." mode="c_contententry"/>
    <!-- xsl:copy-of select="$m_UserEditHouseRulesDiscl"/ -->
  </xsl:template>
  <!-- NAUGHTY - - - needed to overrride base functionality -->
  <xsl:template match="RETURNTO/H2G2ID">
    <a xsl:use-attribute-sets="mRETURNTOH2G2ID">
      <xsl:attribute name="HREF">
        <xsl:value-of select="$root"/>F<xsl:value-of select="/H2G2/POSTTHREADFORM/@FORUMID"/>
      </xsl:attribute>
      <xsl:copy-of select="$m_returntoconv"/>
    </a>
  </xsl:template>
  <!-- 
	<xsl:template match="POSTTHREADFORM" mode="user_premoderationmessage">
	Use: Executed if the User is being premoderated
	-->
  <xsl:template match="POSTTHREADFORM" mode="user_premoderationmessage">
    <xsl:copy-of select="$m_userpremodmessage"/>
  </xsl:template>
  <!-- 
	<xsl:template match="POSTTHREADFORM" mode="site_premoderationmessage">
	Use: Executed if the site is under premoderation
	-->
  <xsl:template match="POSTTHREADFORM" mode="site_premoderationmessage">
    <xsl:copy-of select="$m_PostSitePremod"/>
  </xsl:template>
  <!-- 
	<xsl:template match="INREPLYTO" mode="r_addthread">
	Use: presentation of the 'This is a reply to' section, it contains the author and the body of that post
	-->
  <xsl:template match="INREPLYTO" mode="r_addthread">
    <table cellpadding="0" cellspacing="0" border="0" id="previewTable">
      <tr>
        <th>
          <p>You are replying to:</p>
        </th>
      </tr>
      <tr>
        <td class="post">
          <p>
            <a name="p{@POSTID}">
              <a href="{$root}F{../@FORUMID}?thread={../@THREADID}&amp;#p{@POSTID}">Message</a>
            </a>  posted by <xsl:apply-templates select="." mode="username" />
            <xsl:apply-templates select="USER" mode="c_onlineflagmp"/>
          </p>
          <div class="postContentOne">
            <xsl:apply-templates select="BODY"/>
          </div>
        </td>
      </tr>
    </table>
  </xsl:template>
  <!-- 
	<xsl:template match="POSTTHREADFORM" mode="r_contententry">
	Use: presentation of the form input fields
	-->
  <xsl:template match="POSTTHREADFORM" mode="r_contententry">
    <xsl:choose>
      <xsl:when test="not(PREVIEWBODY) or /H2G2/PARAMS/PARAM[NAME='s_edit'] or /H2G2/POSTTHREADFORM/QUOTEADDED = 1">
        <table cellpadding="0" cellspacing="0" border="0" class="message">
          <tr>
            <td>
              <xsl:if test="@PROFANITYTRIGGERED = 1">
                <p style="color:#000000; font-weight:bold; padding-left:20px; background-image: url(http://www.bbc.co.uk/dnaimages/boards/images/warning.gif); background-repeat: no-repeat; background-position-y: 3px;">Your message contains a word, phrase or website address which is blocked from being posted on this website. Please edit your message before trying to post again.</p>
              </xsl:if>
              <xsl:if test="@NONALLOWEDURLSTRIGGERED = 1">
                <p style="color:#000000; font-weight:bold; padding-left:20px; background-image: url(http://www.bbc.co.uk/dnaimages/boards/images/warning.gif); background-repeat: no-repeat; background-position-y: 3px;">This message has been blocked as it contains a URL. Please edit your message and post it again.</p>
              </xsl:if>
              <xsl:if test="@NONALLOWEDEMAILSTRIGGERED = 1">
                <p style="color:#000000; font-weight:bold; padding-left:20px; background-image: url(http://www.bbc.co.uk/dnaimages/boards/images/warning.gif); background-repeat: no-repeat; background-position-y: 3px;">This message has been blocked as it contains an email address. Please edit your message and post it again.</p>
              </xsl:if>
              <xsl:if test="@INREPLYTO = 0">
                <br/>
                <h3>Your discussion title:</h3>
                <p class="instructional">
                  <xsl:choose>
                    <xsl:when test="string(/H2G2/SITECONFIG/EXTEXTTITLE)">
                      <xsl:value-of select="/H2G2/SITECONFIG/EXTEXTTITLE"/>
                    </xsl:when>
                    <xsl:otherwise>
                      Write a short snappy title to kick off a discussion. e.g. What's the best gig you've been to?
                    </xsl:otherwise>
                  </xsl:choose>
                </p>
                <xsl:apply-templates select="." mode="t_subjectfield"/>
                <br/>
                <br/>
              </xsl:if>
              <!--<td>
							<font xsl:use-attribute-sets="mainfont">
								<xsl:copy-of select="$m_UserEditWarning"/>
							</font>
						</td>-->
              <xsl:if test="SECONDSBEFOREREPOST">
                <p>
                  <xsl:attribute name="class">
                    <xsl:choose>
                      <xsl:when test="@POSTEDBEFOREREPOSTTIMEELAPSED">countdownWarning</xsl:when>
                      <xsl:otherwise>countdown</xsl:otherwise>
                    </xsl:choose>
                  </xsl:attribute>
                  <xsl:text>You must wait </xsl:text>
                  <span id="minuteValue">
                    <xsl:number value="floor(SECONDSBEFOREREPOST div 60)"/>
                  </span>
                  <xsl:text> minutes </xsl:text>
                  <span id="secondValue">
                    <xsl:number value="SECONDSBEFOREREPOST - floor(SECONDSBEFOREREPOST div 60)*60"/>
                  </span>
                  <xsl:text> secs before you can post again</xsl:text>
                </p>
              </xsl:if>
              <xsl:if test="SITECLOSED=1">
                <p>
                  <b>
                    <img src="{$imagesource}warning.gif" alt="Board Closed" border="0"/>
                    <xsl:text>The site has closed.</xsl:text>
                  </b>
                </p>
              </xsl:if>
              <xsl:choose>
                <xsl:when test="@INREPLYTO = 0">
                  <h3>Type your message in the box below:</h3>
                  <p class="instructional">
                    <xsl:choose>
                      <xsl:when test="string(/H2G2/SITECONFIG/EXTEXTBODY)">
                        <xsl:value-of select="/H2G2/SITECONFIG/EXTEXTBODY"/>
                      </xsl:when>
                      <xsl:otherwise>
                        To create paragraphs, just press Return on your keyboard when needed.
                      </xsl:otherwise>
                    </xsl:choose>
                  </p>
                </xsl:when>
                <xsl:otherwise>
                  <br/>
                  <h3>Type your message in the box below</h3>
                  <p class="instructional">
                    <xsl:choose>
                      <xsl:when test="string(/H2G2/SITECONFIG/EXTEXTBODY)">
                        <xsl:value-of select="/H2G2/SITECONFIG/EXTEXTBODY"/>
                      </xsl:when>
                      <xsl:otherwise>
                        To create paragraphs, just press Return on your keyboard when needed.
                      </xsl:otherwise>
                    </xsl:choose>
                  </p>
                </xsl:otherwise>
              </xsl:choose>
              <xsl:apply-templates select="." mode="t_bodyfield"/>
              <xsl:choose>
                <xsl:when test="@INREPLYTO = 0">
                  <div class="buttonsTwo">
                    <table width="405">
                      <tr>
                        <td>
                          <xsl:apply-templates select="/H2G2/POSTTHREADFORM" mode="t_returntoconversation"/>
                        </td>
                        <td align="right">
                          <xsl:apply-templates select="." mode="t_previewpost"/>
                        </td>
                      </tr>
                      <tr>
                        <td colspan="2" align="right">
                          <xsl:apply-templates select="." mode="t_submitpost"/>
                        </td>
                      </tr>
                    </table>
                  </div>
                </xsl:when>
                <xsl:otherwise>
                  <div class="buttonsTwo">
                    <table width="410">
                      <tr>
                        <td align="right">
                          <xsl:apply-templates select="/H2G2/POSTTHREADFORM" mode="t_returntoconversation"/>
                          <!--&nbsp;
													<input type="image" src="{$imagesource}add_original_message_button.gif" alt="Add original message" width="180" height="23" name="AddQuote" value="Add Quote"/>
													<input type="hidden" name="AddQuoteUser" value="USERNAME"/>-->
                          &nbsp;
                          <xsl:apply-templates select="." mode="t_previewpost"/>
                        </td>
                      </tr>
                      <tr>
                        <td align="right">
                          <xsl:apply-templates select="." mode="t_submitpost"/>
                        </td>
                      </tr>
                    </table>
                  </div>
                </xsl:otherwise>
              </xsl:choose>
            </td>
          </tr>
        </table>
      </xsl:when>
      <xsl:otherwise>
        <input type="hidden" name="subject" value="{/H2G2/POSTTHREADFORM/SUBJECT}"/>
        <input type="hidden" name="body" value="{/H2G2/POSTTHREADFORM/BODY}"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:attribute-set name="mRETURNTOH2G2ID">
    <xsl:attribute name="onclick">check(this);</xsl:attribute>
  </xsl:attribute-set>
  <xsl:attribute-set name="maFORUMID_ReturnToConv">
    <xsl:attribute name="onclick">check(this);</xsl:attribute>
  </xsl:attribute-set>
  <xsl:attribute-set name="maFORUMID_ReturnToConv1">
    <xsl:attribute name="onclick">check(this);</xsl:attribute>
  </xsl:attribute-set>
  <!--
	<xsl:attribute-set name="fPOSTTHREADFORM_c_contententry"/>
	Use: presentation attributes on the <form> element
	 -->
  <xsl:attribute-set name="fPOSTTHREADFORM_c_contententry"/>
  <!--
	<xsl:attribute-set name="iPOSTTHREADFORM_t_subjectfield"/>
	Use: Presentation attributes for the subject <input> box
	 -->
  <xsl:attribute-set name="iPOSTTHREADFORM_t_subjectfield">
    <xsl:attribute name="size">40</xsl:attribute>
  </xsl:attribute-set>
  <!--
	<xsl:attribute-set name="iPOSTTHREADFORM_Subject"/>
	Use: Presentation attributes for the body <textarea> box
	 -->
  <xsl:attribute-set name="iPOSTTHREADFORM_t_bodyfield">
    <xsl:attribute name="cols">50</xsl:attribute>
    <xsl:attribute name="rows">15</xsl:attribute>
  </xsl:attribute-set>
  <!--
	<xsl:attribute-set name="iPOSTTHREADFORM_t_previewpost">
	Use: Presentation attributes for the preview submit button
	 -->
  <xsl:attribute-set name="iPOSTTHREADFORM_t_previewpost">
    <xsl:attribute name="type">image</xsl:attribute>
    <xsl:attribute name="src">
      <xsl:value-of select="$imagesource"/>preview_button.gif
    </xsl:attribute>
    <xsl:attribute name="alt">Preview</xsl:attribute>
    <xsl:attribute name="value">Preview Message</xsl:attribute>
    <xsl:attribute name="name">preview</xsl:attribute>
    <xsl:attribute name="width">108</xsl:attribute>
    <xsl:attribute name="height">23</xsl:attribute>
  </xsl:attribute-set>
  <!--
	<xsl:attribute-set name="iPOSTTHREADFORM_t_submitpost">
	Use: Presentation attributes for the submit button
	 -->
  <xsl:attribute-set name="iPOSTTHREADFORM_t_submitpost">
    <xsl:attribute name="type">image</xsl:attribute>
    <xsl:attribute name="src">
      <xsl:value-of select="$imagesource"/>post_message_button.gif
    </xsl:attribute>
    <xsl:attribute name="alt">Post message button</xsl:attribute>
    <xsl:attribute name="width">149</xsl:attribute>
    <xsl:attribute name="height">23</xsl:attribute>
  </xsl:attribute-set>
  <!--
	<xsl:template match="POSTTHREADUNREG" mode="r_addthread">
	Use: Message displayed if reply is attempted when unregistered
	 -->
  <xsl:template match="POSTTHREADUNREG" mode="r_addthread">
    <tr>
      <td>
        <xsl:apply-imports/>
      </td>
    </tr>
  </xsl:template>
  <!--
	<xsl:template match="POSTPREMODERATED" mode="r_addthread">
	Use: Presentation of the 'Post has been premoderated' text
	 -->
  <xsl:template match="POSTPREMODERATED" mode="r_addthread">
    <xsl:call-template name="m_posthasbeenpremoderated"/>
  </xsl:template>
  <!--
	<xsl:template match="POSTPREMODERATED" mode="r_autopremod">
	Use: Presentation of the 'Post has been auto premoderated' text
	 -->
  <xsl:template match="POSTPREMODERATED" mode="r_autopremod">
    <xsl:call-template name="m_posthasbeenautopremoderated"/>
  </xsl:template>
  <!--
	<xsl:template match="POSTQUEUED" mode="r_addthread">
	Use: Presentation of the 'Post has been premoderated' text
	 -->
  <xsl:template match="POSTQUEUED" mode="r_addthread">
    <xsl:call-template name="m_posthasbeenqueued"/>
  </xsl:template>
  <!--
	<xsl:template match="ERROR" mode="r_addthread">
	Use: Presentation of error message
	 -->
  <xsl:template match="ERROR" mode="r_addthread">
    <xsl:apply-imports/>
  </xsl:template>
  <!--
  <xsl:template match="PROMPTSETUSERNAME" mode="r_addthread">
  Use : Presentation of Users Nickname not set
  -->
  <xsl:template match="PROMPTSETUSERNAME" mode="r_addthread">
      <xsl:call-template name="m_usernamenotsetyet"/>
  </xsl:template>

</xsl:stylesheet>
