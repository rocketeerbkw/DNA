<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet exclude-result-prefixes="msxsl local s dt" version="1.0" xmlns:dt="urn:schemas-microsoft-com:datatypes" xmlns:local="#local-functions" xmlns:msxsl="urn:schemas-microsoft-com:xslt"
        xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
        <xsl:template name="NODETAILS_FORM">
                <table border="0" cellpadding="0" cellspacing="0" class="submistablebg" width="635">
                        <tr>
                                <td colspan="3" valign="bottom" width="635">
                                        <img alt="" class="tiny" height="57" src="{$imagesource}furniture/submission/submissiontop.gif" width="635"/>
                                </td>
                        </tr>
                        <tr>
                                <td class="subleftcolbg" valign="top" width="88">
                                        <img alt="" height="29" src="{$imagesource}furniture/submission/submissiontopleftcorner.gif" width="88"/>
                                </td>
                                <td class="submistablebg" valign="top" width="459">
                                        <!-- begin submission steps -->
                                        <table border="0" cellpadding="0" cellspacing="0" width="459">
                                                <tr>
                                                        <td valign="top">
                                                                <div class="step1">
                                                                        <strong>step 1 : film details</strong>
                                                                </div>
                                                        </td>
                                                        <td valign="top" width="17">
                                                                <img alt="" height="26" src="{$imagesource}furniture/submission/stepsarrow.gif" width="17"/>
                                                        </td>
                                                        <td valign="top">
                                                                <div class="step2selected">
                                                                        <strong>step 2 : contact details</strong>
                                                                </div>
                                                        </td>
                                                        <td valign="top" width="17">
                                                                <img alt="" height="26" src="{$imagesource}furniture/submission/stepsarrow.gif" width="17"/>
                                                        </td>
                                                        <td valign="top">
                                                                <div class="step2">
                                                                        <strong>step 3 : complete</strong>
                                                                </div>
                                                        </td>
                                                </tr>
                                        </table>
                                        <!-- end submission steps -->
                                        <!-- 2px Black rule -->
                                        <table border="0" cellpadding="0" cellspacing="0" width="459">
                                                <tr>
                                                        <td height="8"/>
                                                </tr>
                                                <tr>
                                                        <td class="darkestbg" height="2"/>
                                                </tr>
                                                <tr>
                                                        <td height="8"/>
                                                </tr>
                                        </table>
                                        <!-- END 2px Black rule -->
                                        <div>
                                                <img alt="film submission: step 2" height="28" src="{$imagesource}furniture/filmsubmitstep2header.gif" width="288"/>
                                        </div>
                                        <!-- spacer -->
                                        <table border="0" cellpadding="0" cellspacing="0" width="459">
                                                <tr>
                                                        <td height="8"/>
                                                </tr>
                                        </table>
                                        <!-- END spacer -->
                                        <!-- SUBMISSION LIST -->
                                        <div class="textmedium">Fill in the form below. Please complete all the <span class="alert">required fields*</span>. Once you are happy , click next.</div>
                                        <!-- END SUBMISSION LIST -->
                                        <!-- 2px Black rule -->
                                        <table border="0" cellpadding="0" cellspacing="0" width="459">
                                                <tr>
                                                        <td height="8"/>
                                                </tr>
                                                <tr>
                                                        <td class="darkestbg" height="2"/>
                                                </tr>
                                                <tr>
                                                        <td height="8"/>
                                                </tr>
                                        </table>
                                        <!-- spacer -->
                                        <table border="0" cellpadding="0" cellspacing="0" width="459">
                                                <tr>
                                                        <td height="8"/>
                                                </tr>
                                        </table>
                                        <!-- END spacer -->
                                        <!-- BEGIN Contact Details -->
                                        <div class="textxlarge">contact details</div>
                                        <div class="textmedium">This information will be used by the BBC for the purposes of this film submission (e.g. to contact you to obtain a broadcast quality
                                                copy of your film and stills etc.) and to let you know your film has been published. Your name (but not your other details) will be included on the
                                                related film page. We will not contact you for any other reason and will not pass your details on to anyone outside the BBC. For more infomation see our <strong>
                                                        <a href="/privacy">privacy policy</a>
                                                </strong>.</div>
                                        <!-- END Contact Details -->
                                        <!-- Grey line spacer -->
                                        <table border="0" cellpadding="0" cellspacing="0" width="459">
                                                <tr>
                                                        <td height="17">
                                                                <img alt="" class="tiny" height="1" src="{$imagesource}furniture/wherebeenbar.gif" width="459"/>
                                                        </td>
                                                </tr>
                                        </table>
                                        <!-- BEGIN Error Msg -->
                                        <div id="validatemsg">
                                                <strong>error</strong>
                                                <BR/>
                                                <strong>You may have forgotten to fill in one of the required fields. Fields with a star are required. Please fill them in and click 'next'.</strong>
                                                <br/>
                                        </div>
                                        <!-- END Error Msg -->
                                        <form action="http://www.bbc.co.uk/cgi-bin/cgiemail/filmnetwork/includes/submission_details.txt" method="post" name="debugform"
                                                onSubmit="return validate(this);">
                                                <input name="success" type="hidden" value="{$dna_server}/dna/filmnetwork/A{/H2G2/ARTICLE/ARTICLEINFO/H2G2ID}&amp;s_details=yes&amp;s_print=1"/>
                                                <input name="subject" type="hidden"
                                                        value="A{/H2G2/ARTICLE/ARTICLEINFO/H2G2ID} - {/H2G2/ARTICLE/SUBJECT} - {/H2G2/ARTICLE/ARTICLEINFO/PAGEAUTHOR/EDITOR/USER/FIRSTNAMES} {/H2G2/ARTICLE/ARTICLEINFO/PAGEAUTHOR/EDITOR/USER/LASTNAME}"/>
                                                <input id="required" name="required" type="hidden" value="firstname,surname,address,postcode,telephone,email"/>
                                                <table border="0" cellpadding="0" cellspacing="0" width="459">
                                                        <tr>
                                                                <td>
                                                                        <div class="formtitle">
                                                                                <span id="firstname"><strong>first name:</strong> *</span>
                                                                        </div>
                                                                </td>
                                                                <td colspan="4">
                                                                        <input class="formboxwidthmedium" name="firstname" type="text"/>
                                                                </td>
                                                        </tr>
                                                        <tr>
                                                                <td>
                                                                        <div class="formtitle">
                                                                                <span id="surname"><strong>surname:</strong> *</span>
                                                                        </div>
                                                                </td>
                                                                <td colspan="4">
                                                                        <input class="formboxwidthmedium" name="surname" type="text"/>
                                                                </td>
                                                        </tr>
                                                        <tr>
                                                                <td>
                                                                        <div class="formtitle">
                                                                                <span id="address"><strong>address:</strong> *</span>
                                                                        </div>
                                                                </td>
                                                                <td colspan="4">
                                                                        <input class="formboxwidthmedium" name="address" type="text"/>
                                                                </td>
                                                        </tr>
                                                        <tr>
                                                                <td>
                                                                        <div class="formtitle">&nbsp;</div>
                                                                </td>
                                                                <td colspan="4">
                                                                        <input class="formboxwidthmedium" name="address2" type="text"/>
                                                                </td>
                                                        </tr>
                                                        <tr>
                                                                <td>
                                                                        <div class="formtitle">&nbsp;</div>
                                                                </td>
                                                                <td colspan="4">
                                                                        <input class="formboxwidthmedium" name="address3" type="text"/>
                                                                </td>
                                                        </tr>
                                                        <tr>
                                                                <td>
                                                                        <div class="formtitle">
                                                                                <span id="postcode"><strong>postcode:</strong> *</span>
                                                                        </div>
                                                                </td>
                                                                <td colspan="4">
                                                                        <input class="formboxwidthmedium" name="postcode" type="text"/>
                                                                </td>
                                                        </tr>
                                                        <tr>
                                                                <td>
                                                                        <div class="formtitle">
                                                                                <span id="telephone"><strong>telephone:</strong> *</span>
                                                                        </div>
                                                                </td>
                                                                <td colspan="4">
                                                                        <input class="formboxwidthmedium" name="telephone" type="text"/>
                                                                </td>
                                                        </tr>
                                                        <tr>
                                                                <td>
                                                                        <div class="formtitle">
                                                                                <span id="email"><strong>email address:</strong> *</span>
                                                                        </div>
                                                                </td>
                                                                <td colspan="4">
                                                                        <input class="formboxwidthmedium" name="email" type="text"/>
                                                                </td>
                                                        </tr>
                                                </table>
                                                <!-- 2px Black rule -->
                                                <!-- spacer -->
                                                <table border="0" cellpadding="0" cellspacing="0" width="459">
                                                        <tr>
                                                                <td height="8"/>
                                                        </tr>
                                                </table>
                                                <!-- END spacer -->
                                                <table border="0" cellpadding="0" cellspacing="0" width="459">
                                                        <tr>
                                                                <td height="8"/>
                                                        </tr>
                                                        <tr>
                                                                <td class="darkestbg" height="2"/>
                                                        </tr>
                                                        <tr>
                                                                <td height="8"/>
                                                        </tr>
                                                </table>
                                                <div class="finalsubmit">
                                                        <input src="{$imagesource}furniture/next1.gif" type="image"/>
                                                </div>
                                        </form>
                                </td>
                                <td class="subrightcolbg" valign="top" width="88">
                                        <img alt="" class="tiny" height="30" src="/f/t.gif" width="88"/>
                                </td>
                        </tr>
                        <tr>
                                <td class="subrowbotbg" height="10"/>
                                <td class="subrowbotbg"/>
                                <td class="subrowbotbg"/>
                        </tr>
                </table>
        </xsl:template>
        <!-- show the contract form  3nd step in submitting a film -->
        <xsl:template name="FILM_CONTRACT_FORM">
                <table border="0" cellpadding="0" cellspacing="0" width="635">
                        <tr>
                                <td height="10">
                                        <div class="pagehead">submission</div>
                                </td>
                        </tr>
                </table>
                <table border="0" cellpadding="0" cellspacing="0" class="submistablebg" width="635">
                        <tr>
                                <td colspan="3" valign="bottom" width="635">
                                        <img alt="" class="tiny" height="57" src="{$imagesource}furniture/submission/submissiontop.gif" width="635"/>
                                </td>
                        </tr>
                        <tr>
                                <td class="subleftcolbg" valign="top" width="88">
                                        <img alt="" height="29" src="{$imagesource}furniture/submission/submissiontopleftcorner.gif" width="88"/>
                                </td>
                                <td class="submistablebg" valign="top" width="459">
                                        <!-- begin submission steps -->
                                        <table border="0" cellpadding="0" cellspacing="0" width="459">
                                                <tr>
                                                        <td valign="top">
                                                                <div class="step1">
                                                                        <strong>step 1 : fill in form</strong>
                                                                </div>
                                                        </td>
                                                        <td valign="top" width="17">
                                                                <img alt="" height="26" src="{$imagesource}furniture/submission/stepsarrow.gif" width="17"/>
                                                        </td>
                                                        <td valign="top">
                                                                <div class="step2">
                                                                        <strong>step 2 : preview</strong>
                                                                </div>
                                                        </td>
                                                        <td valign="top" width="17">
                                                                <img alt="" height="26" src="{$imagesource}furniture/submission/stepsarrow.gif" width="17"/>
                                                        </td>
                                                        <td valign="top">
                                                                <div class="step3selected">
                                                                        <strong>step 3 : complete</strong>
                                                                </div>
                                                        </td>
                                                </tr>
                                        </table>
                                        <!-- end submission steps -->
                                        <!-- 2px Black rule -->
                                        <table border="0" cellpadding="0" cellspacing="0" width="459">
                                                <tr>
                                                        <td class="darkestbg" height="2"/>
                                                </tr>
                                        </table>
                                        <!-- END 2px Black rule -->
                                        <!-- submission complete -->
                                        <div class="subcomplete">
                                                <img alt="submission complete" height="35" src="{$imagesource}furniture/submission/submissioncomplete.gif" width="271"/>
                                        </div>
                                        <!-- END submission complete -->
                                        <!-- Grey line spacer -->
                                        <table border="0" cellpadding="0" cellspacing="0" width="459">
                                                <tr>
                                                        <td height="1">
                                                                <img alt="" class="tiny" height="1" src="{$imagesource}furniture/wherebeenbar.gif" width="459"/>
                                                        </td>
                                                </tr>
                                        </table>
                                        <!-- END Grey line spacer -->
                                        <!-- begin large text para -->
                                        <div class="bigpara">you have now completed the first stage of the submission process, there are now a couple of things left to do:</div>
                                        <!-- END large text para -->
                                        <!-- read the contract -->
                                        <div class="readcontract">
                                                <strong>1. Read the contract, print it out and sign it</strong>
                                        </div>
                                        <!-- END read the contract -->
                                        <!-- open contract image -->
                                        <div class="opencontract">
                                                <a href="{$root}A{/H2G2/ARTICLE/ARTICLEINFO/H2G2ID}?s_print=1&amp;s_type=pop"
                                                        onclick="popupwindow(this.href,this.target,'width=655,height=600,resizable=yes,scrollbars=yes, location=no,directories=no,status=no,');return false;"
                                                        onmouseout="swapImage('opencontract', '{$imagesource}furniture/submission/opencontract1.gif')"
                                                        onmouseover="swapImage('opencontract', '{$imagesource}furniture/submission/opencontract2.gif')" target="printpopup">
                                                        <img alt="open contract" border="0" height="83" name="opencontract" src="{$imagesource}furniture/submission/opencontract1.gif" width="459"/>
                                                </a>
                                        </div>
                                        <!-- END open contract image -->
                                        <!-- post a copy header -->
                                        <div class="textmedium">
                                                <strong>2. Post a copy of:</strong>
                                        </div>
                                        <!-- END post a copy header -->
                                        <!-- post requirements list -->
                                        <div class="textmedium">
                                                <ul class="centcolsubmitlist">
                                                        <li>your film [ preferably DVD ]</li>
                                                        <li>the signed contract</li>
                                                </ul>
                                        </div>
                                        <!-- END post requirements list -->
                                        <!-- address header -->
                                        <div class="submitaddressheader alert">
											<strong>(Please note we have recently changed address)<br/><br/> to: </strong>
                                        </div>
                                        <!-- END address header -->
                                        <!-- address -->
                                        <div class="submitaddress alert">
                                                <xsl:copy-of select="$m_BBCaddress"/>
                                        </div>
                                        <!-- END address -->
                                        <!-- submission appear -->
                                        <div class="textmedium">This submission will now appear on <strong>
                                                        <a href="{$root}U{/H2G2/ARTICLE/ARTICLEINFO/PAGEAUTHOR/EDITOR/USER/USERID}">your profile page</a>
                                                </strong> where you will be able to follow the progress of your submission.</div>
                                        <!-- END submission appear -->
                                        <!-- 15px Spacer table -->
                                        <table border="0" cellpadding="0" cellspacing="0" width="459">
                                                <tr>
                                                        <td height="15"/>
                                                </tr>
                                        </table>
                                        <!-- END 15px Spacer table -->
                                        <!-- remember -->
                                        <div class="textmedium">Remember we cannot return tapes or stills and that we do not guarantee to publish your film.</div>
                                        <!-- END remember -->
                                        <!-- 40px Spacer table -->
                                        <table border="0" cellpadding="0" cellspacing="0" width="459">
                                                <tr>
                                                        <td height="40"/>
                                                </tr>
                                        </table>
                                        <!-- END 10px Spacer table -->
                                        <!-- 2px Black rule -->
                                        <table border="0" cellpadding="0" cellspacing="0" width="459">
                                                <tr>
                                                        <td class="darkestbg" height="2"/>
                                                </tr>
                                        </table>
                                        <!-- END 2px Black rule -->
                                        <!-- final submit -->
                                        <div class="finalsubmit">
                                                <a href="{$root}A{/H2G2/ARTICLE/ARTICLEINFO/H2G2ID}" onmouseout="swapImage('finalsub', '{$imagesource}furniture/submission/seefinalsubmission1.gif')"
                                                        onmouseover="swapImage('finalsub', '{$imagesource}furniture/submission/seefinalsubmission2.gif')">
                                                        <img alt="see final submission" border="0" height="26" name="finalsub" src="{$imagesource}furniture/submission/seefinalsubmission1.gif"
                                                                width="157"/>
                                                </a>
                                        </div>
                                        <!-- END final submit -->
                                </td>
                                <td class="subrightcolbg" valign="top" width="88">
                                        <img alt="" class="tiny" height="30" src="/f/t.gif" width="88"/>
                                </td>
                        </tr>
                        <tr>
                                <td class="subrowbotbg" height="10"/>
                                <td class="subrowbotbg"/>
                                <td class="subrowbotbg"/>
                        </tr>
                </table>
        </xsl:template>
        <!-- used to resubmit details are taken etc and send to film nonapproved view -->
        <xsl:template name="FILM_TRANSFER_PAGE">
                <table border="0" cellpadding="0" cellspacing="0" width="100%">
                        <tr>
                                <td width="135">
                                        <img alt="" height="1" src="/f/t.gif" width="135"/>
                                </td>
                                <td>
                                        <!-- main table -->
                                        <!-- name="setDetails"  -->
                                        <form action="{$root}TypedArticle" method="post" name="setDetails" xsl:use-attribute-sets="fMULTI-STAGE_c_article">
                                                <input name="_msstage" type="hidden" value="1"/>
                                                <input name="s_typedarticle" type="hidden" value="edit"/>
                                                <input name="s_showcontract" type="hidden" value="yes"/>
                                                <input name="s_fromedit" type="hidden" value="1"/>
                                                <input name="h2g2id" type="hidden" value="{/H2G2/ARTICLE/ARTICLEINFO/H2G2ID}"/>
                                                <table bgcolor="#000000" border="0" cellpadding="0" cellspacing="0" width="635">
                                                        <xsl:call-template name="FILM_SUBMISSION_EDITFORM_HIDDEN"/>
                                                        <tr>
                                                                <td>
                                                                        <br/>
                                                                        <img alt="film network - short films from new British filmmakers" height="80"
                                                                                src="{$imagesource}furniture/banner_filmnetwork.gif" width="382"/>
                                                                        <br/>
                                                                        <br/>
                                                                </td>
                                                        </tr>
                                                </table>
                                                <table border="0" cellpadding="0" cellspacing="0" width="635">
                                                        <tr>
                                                                <td height="10">
                                                                        <div class="crumbtop">
                                                                                <span class="textxlarge">film submission</span>
                                                                        </div>
                                                                </td>
                                                        </tr>
                                                </table>
                                                <table border="0" cellpadding="0" cellspacing="0" width="635">
                                                        <!-- Spacer row -->
                                                        <tr>
                                                                <td>
                                                                        <img alt="" class="tiny" height="1" src="/f/t.gif" width="371"/>
                                                                </td>
                                                                <td>
                                                                        <img alt="" class="tiny" height="1" src="/f/t.gif" width="20"/>
                                                                </td>
                                                                <td>
                                                                        <img alt="" class="tiny" height="1" src="/f/t.gif" width="244"/>
                                                                </td>
                                                        </tr>
                                                        <tr>
                                                                <td valign="top" width="371">
                                                                        <table border="0" cellpadding="0" cellspacing="0" width="371">
                                                                                <tr>
                                                                                        <td class="topbg" height="69" valign="top">
                                                                                                <img alt="" height="10" src="/f/t.gif" width="1"/>
                                                                                                <div class="biogname">
                                                                                                    <strong>Film Network is processing your submission.</strong>
                                                                                                </div>
                                                                                                <div class="whattodotitle">
                                                                                                    <noscript> If nothing happens click update <input name="aupdate" type="submit" value="update"/>
                                                                                                    </noscript>
                                                                                                    <strong>
                                                                                                    <input name="aupdate" type="hidden" value="update"/>
                                                                                                    <br/>
                                                                                                    </strong>
                                                                                                </div>
                                                                                        </td>
                                                                                </tr>
                                                                        </table>
                                                                </td>
                                                                <td class="topbg" valign="top" width="20"/>
                                                                <td class="topbg" valign="top"> </td>
                                                        </tr>
                                                        <tr>
                                                                <td colspan="3" valign="top" width="635">
                                                                        <img height="27" src="{$imagesource}furniture/writemessage/topboxangle.gif" width="635"/>
                                                                </td>
                                                        </tr>
                                                </table>
                                        </form>
                                        <br/>
                                        <br/>
                                        <br/>
                                        <br/>
                                        <br/>
                                        <br/>
                                        <br/>
                                        <br/>
                                        <br/>
                                        <br/>
                                        <br/>
                                        <br/>
                                        <br/>
                                        <br/>
                                        <br/>
                                        <br/>
                                        <xsl:call-template name="FILM_DISCLAIMER"/>
                                        <!--DETAILS=Complete the form for resending the Article so that we can set DETAILS to complete -->
                                </td>
                        </tr>
                </table>
        </xsl:template>
        <!-- 
     #####################################################################################
	   preview for standard member and viewing mode non approved submissions 
     ##################################################################################### 
-->
        <xsl:template name="FILM_NONAPPROVED">
                <table border="0" cellpadding="0" cellspacing="0" width="635">
                        <tr>
                                <td height="10"/>
                        </tr>
                </table>
                <xsl:if test="/H2G2/PARAMS/PARAM[NAME = 's_print']/VALUE = '1' and /H2G2/PARAMS/PARAM[NAME = 's_type']/VALUE = 'pop'">
                        <table border="0" cellpadding="0" cellspacing="0" class="popupbg" width="635">
                                <tr>
                                        <td valign="bottom">
                                                <div class="beebpad">
                                                        <span class="textmedium">&nbsp;<a class="rightcollight" href="http://www.bbc.co.uk">
                                                                        <strong>bbc.co.uk</strong>
                                                                </a></span>
                                                </div>
                                        </td>
                                        <td valign="bottom" width="210">
                                                <img height="64" src="{$imagesource}furniture/popuplogo.gif" width="210"/>
                                        </td>
                                        <td align="right" valign="bottom">
                                                <div class="closepad">
                                                        <span class="textmedium"><a class="rightcol" href="#" onclick="window.close();"><strong>close window</strong>&nbsp;<img height="10"
                                                                                src="{$imagesource}furniture/popupclose.gif" width="10"/></a>&nbsp;</span>
                                                </div>
                                        </td>
                                </tr>
                        </table>
                </xsl:if>
                <table border="0" cellpadding="0" cellspacing="0" class="submistablebg" width="635">
                        <tr>
                                <td colspan="3" valign="bottom" width="635">
                                        <img alt="" class="tiny" height="57" src="{$imagesource}furniture/submission/submissiontop.gif" width="635"/>
                                </td>
                        </tr>
                        <tr>
                                <td class="subleftcolbg" valign="top" width="88">
                                        <img alt="" height="29" src="{$imagesource}furniture/submission/submissiontopleftcorner.gif" width="88"/>
                                </td>
                                <td class="submistablebg" valign="top" width="459">
                                        <!-- appear on top of Article to remind user to submit contact details -->
                                        <xsl:if test="/H2G2/ARTICLE/GUIDE/DETAILS != 'yes' and not(/H2G2/PARAMS/PARAM[NAME= 's_print']/VALUE = 1) and /H2G2/ARTICLE/ARTICLEINFO/STATUS/@TYPE = 3">
                                                <div class="searchhead">
                                                        <span class="alert">
                                                                <br/>
                                                                <font color="red">
                                                                        <strong>Please remember to give us your <a href="{$root}A{/H2G2/ARTICLE/ARTICLEINFO/H2G2ID}&amp;s_details=no">contact
                                                                                        details</a></strong>
                                                                </font>
                                                        </span>
                                                        <br/>
                                                        <br/>
                                                </div>
                                        </xsl:if>
                                        <div>
                                                <xsl:if test="/H2G2/PARAMS/PARAM[NAME = 's_print']/VALUE = '1' and /H2G2/PARAMS/PARAM[NAME = 's_type']/VALUE = 'pop'">
                                                        <table border="0" cellpadding="0" cellspacing="0" width="459">
                                                                <tr>
                                                                        <td height="8"/>
                                                                </tr>
                                                                <tr>
                                                                        <td align="right">
                                                                                <strong>
                                                                                        <a href="#" onclick="print();">
                                                                                                <img alt="" class="tiny" height="22" src="{$imagesource}furniture/print.gif" width="100"/>
                                                                                        </a>
                                                                                </strong>
                                                                        </td>
                                                                </tr>
                                                                <tr>
                                                                        <td height="8"/>
                                                                </tr>
                                                        </table>
                                                </xsl:if>
                                                <xsl:choose>
                                                        <xsl:when test="/H2G2/ARTICLE/EXTRAINFO/TYPE/@ID=31">
                                                                <img alt="drama film submission" height="29" src="{$imagesource}furniture/comedyfilmsubmissheader.gif" width="314"/>
                                                        </xsl:when>
                                                        <xsl:when test="/H2G2/ARTICLE/EXTRAINFO/TYPE/@ID=32">
                                                                <img alt="drama film submission" height="29" src="{$imagesource}furniture/documentaryfilmsubmissheader.gif" width="383"/>
                                                        </xsl:when>
                                                        <xsl:when test="/H2G2/ARTICLE/EXTRAINFO/TYPE/@ID=33">
                                                                <img alt="drama film submission" height="29" src="{$imagesource}furniture/animationfilmsubmissheader.gif" width="342"/>
                                                        </xsl:when>
                                                        <xsl:when test="/H2G2/ARTICLE/EXTRAINFO/TYPE/@ID=34">
                                                                <img alt="drama film submission" height="29" src="{$imagesource}furniture/experimentalfilmsubmissheader.gif" width="383"/>
                                                        </xsl:when>
                                                        <xsl:when test="/H2G2/ARTICLE/EXTRAINFO/TYPE/@ID=35">
                                                                <img alt="music film submission" height="23" src="{$imagesource}furniture/musicfilmsubmissheader.gif" width="298"/>
                                                        </xsl:when>
                                                        <xsl:otherwise>
                                                                <img alt="drama film submission" height="23" src="{$imagesource}furniture/dramafilmsubmissheader.gif" width="298"/>
                                                        </xsl:otherwise>
                                                </xsl:choose>
                                        </div>
                                        <!-- 2px Black rule -->
                                        <table border="0" cellpadding="0" cellspacing="0" width="459">
                                                <tr>
                                                        <td height="8"/>
                                                </tr>
                                                <tr>
                                                        <td class="darkestbg" height="2"/>
                                                </tr>
                                                <tr>
                                                        <td height="8"/>
                                                </tr>
                                        </table>
                                        <!-- END 2px Black rule -->
                                        <div>
                                                <img alt="submission information" height="34" src="{$imagesource}furniture/submissinfoheader.gif" width="337"/>
                                        </div>
                                        <!-- Grey line spacer -->
                                        <table border="0" cellpadding="0" cellspacing="0" width="459">
                                                <tr>
                                                        <td height="17">
                                                                <img alt="" class="tiny" height="1" src="{$imagesource}furniture/wherebeenbar.gif" width="459"/>
                                                        </td>
                                                </tr>
                                        </table>
                                        <!-- END Grey line spacer -->
                                        <!-- BEGIN submission status -->
                                        <div class="textmedium">
                                                <ul class="centcollist">
                                                        <li>submission status: <xsl:choose>
                                                                        <!-- when the film submission has been declined (ID=50-51) -->
                                                                        <xsl:when test="EXTRAINFO/TYPE/@ID[substring(.,1,1) = '5']"> declined </xsl:when>
                                                                        <!-- otherwise, it is assumed that the film is a new submission -->
                                                                        <xsl:otherwise> new submission </xsl:otherwise>
                                                                </xsl:choose>
                                                        </li>
                                                        <li>submission reference number: A<xsl:value-of select="ARTICLEINFO/H2G2ID"/></li>
                                                        <li>submission author: U<xsl:value-of select="ARTICLEINFO/PAGEAUTHOR/EDITOR/USER/USERID"/></li>
                                                        <li>submission date: <xsl:value-of select="ARTICLEINFO/DATECREATED/DATE/@DAY"/>&nbsp;<xsl:value-of
                                                                        select="ARTICLEINFO/DATECREATED/DATE/@MONTHNAME"/>&nbsp;<xsl:value-of select="ARTICLEINFO/DATECREATED/DATE/@YEAR"/>
                                                        </li>
                                                </ul>
                                        </div>
                                        <!-- END submission status -->
                                        <!-- 2px Black rule -->
                                        <xsl:if
                                                test="/H2G2/ARTICLE/GUIDE/DETAILS = 'yes' and  not(/H2G2/PARAMS/PARAM[NAME= 's_print']/VALUE = 1) and /H2G2/ARTICLE/ARTICLEINFO/STATUS/@TYPE = 3 and $article_type_group !='credit' and $article_type_group !='declined'">
                                                <div class="bigpara">make sure you have:</div>
                                                <!-- END large text para -->
                                                <!-- read the contract -->
                                                <div class="readcontract">
                                                        <strong>1. Read the contract, printed it out and signed it</strong>
                                                </div>
                                                <table border="0" cellpadding="0" cellspacing="0" width="459">
                                                        <tr>
                                                                <td height="8"/>
                                                        </tr>
                                                </table>
                                                <div class="opencontract">
                                                        <a href="{$root}A{/H2G2/ARTICLE/ARTICLEINFO/H2G2ID}?s_print=1&amp;s_type=pop"
                                                                onclick="popupwindow(this.href,this.target,'width=655,height=600,resizable=yes,scrollbars=yes, location=no,directories=no,status=no,menubar=yes');return false;"
                                                                onmouseout="swapImage('opencontract', '{$imagesource}furniture/submission/opencontract1.gif')"
                                                                onmouseover="swapImage('opencontract', '{$imagesource}furniture/submission/opencontract2.gif')" target="printpopup">
                                                                <img alt="open contract" border="0" height="83" name="opencontract" src="{$imagesource}furniture/submission/opencontract1.gif"
                                                                        width="459"/>
                                                        </a>
                                                </div>
                                                <div class="textmedium">
                                                        <strong>2. Posted a copy of:</strong>
                                                </div>
                                                <!-- END post a copy header -->
                                                <!-- post requirements list -->
                                                <div class="textmedium">
                                                        <ul class="centcolsubmitlist">
                                                                <li>your film [ preferably DVD ]</li>
                                                                <li>the signed contract</li>
                                                        </ul>
                                                </div>
                                                <!-- END post requirements list -->
                                                <!-- address header -->
                                                <div class="submitaddressheader">
                                                        <span class="alert">
                                                                <strong>to: Film Network Submission</strong>
                                                        </span>
                                                </div>
                                                <!-- END address header -->
                                                <!-- address -->
                                                <div class="submitaddress">
                                                        <span class="alert">
                                                                <xsl:copy-of select="$m_BBCaddress"/>
                                                        </span>
                                                </div>
                                                <!-- END address -->
                                        </xsl:if>
                                        <!-- if film is declined, tell user why and allow user to change submission to a credit -->
                                        <xsl:if test="EXTRAINFO/TYPE/@ID[substring(.,1,1)=5]">
                                                <table border="0" cellpadding="0" cellspacing="0" width="459">
                                                        <tr>
                                                                <td height="8"/>
                                                        </tr>
                                                </table>
                                                <!-- if editors add text into WHYDECLINED node, then it will appear here -->
                                                <xsl:if test="string-length(GUIDE/WHYDECLINED)">
                                                        <div class="textmedium">
                                                                <span class="alert">
                                                                        <br/>
                                                                        <font color="red">
                                                                                <strong>Sorry, your submission has been declined for the following reasons:</strong>
                                                                        </font>
                                                                </span>
                                                                <br/>
                                                                <xsl:value-of select="GUIDE/WHYDECLINED"/>
                                                        </div>
                                                </xsl:if>
                                                <div class="textmedium">
                                                        <span class="alert">
                                                                <br/>
                                                                <font color="red">
                                                                        <a href="{$root}TypedArticle?aedit=new&amp;type={$current_article_type}&amp;h2g2id={/H2G2/ARTICLE/ARTICLEINFO/H2G2ID}">
                                                                                <strong>Turn declined film into a credit</strong>
                                                                        </a>
                                                                </font>
                                                        </span>&nbsp;<img alt="" height="7" src="{$imagesource}furniture/myprofile/arrowdark.gif" width="4"/><br/>
                                                </div>
                                        </xsl:if>
                                        <table border="0" cellpadding="0" cellspacing="0" width="459">
                                                <tr>
                                                        <td height="8"/>
                                                </tr>
                                                <tr>
                                                        <td class="darkestbg" height="2"/>
                                                </tr>
                                                <tr>
                                                        <td height="8"/>
                                                </tr>
                                        </table>
                                        <!-- END 2px Black rule -->
                                        <!-- NEW GRAPHIC REQUIRED -->
                                        <div>
                                                <img alt="film information" height="34" src="{$imagesource}furniture/submissfilminfoheader.gif" width="248"/>
                                        </div>
                                        <!-- END NEW GRAPHIC REQUIRED -->
                                        <!-- Grey line spacer -->
                                        <table border="0" cellpadding="0" cellspacing="0" width="459">
                                                <tr>
                                                        <td height="17">
                                                                <img alt="" class="tiny" height="1" src="{$imagesource}furniture/wherebeenbar.gif" width="459"/>
                                                        </td>
                                                </tr>
                                        </table>
                                        <!-- END Grey line spacer -->
                                        <!-- TITLE OF MOVIE -->
                                        <div class="textxxlarge">
                                                <strong>
                                                        <xsl:apply-templates select="SUBJECT"/>
                                                </strong>
                                        </div>
                                        <!-- END TITLE OF MOVIE -->
                                        <!-- MOVIE DETAILS -->
                                        <div class="textmedium"> director: <strong>
                                                        <xsl:apply-templates select="GUIDE/DIRECTORSNAME"/>
                                                </strong><br/> genre: <strong>
                                                        <xsl:value-of select="msxsl:node-set($type)/type[@number=$current_article_type or @selectnumber=$current_article_type]/@subtype"/>
                                                </strong><br/> film length: <strong><xsl:apply-templates select="GUIDE/FILMLENGTH_MINS"/>&nbsp;min&nbsp;&nbsp;<xsl:apply-templates
                                                                select="GUIDE/FILMLENGTH_SECS"/>&nbsp;sec</strong><br/> tape format: <strong>
                                                        <xsl:apply-templates select="GUIDE/TAPEFORMAT"/>
                                                </strong><br/> original format: <strong>
                                                        <xsl:apply-templates select="GUIDE/ORIGINALFORMAT"/>
                                                </strong><br/> year of production: <strong>
                                                        <xsl:apply-templates select="GUIDE/YEARPRODUCTION"/>
                                                </strong><br/> region: <strong>
                                                        <xsl:choose>
                                                                <xsl:when test="GUIDE/REGION-OTHER != '' and GUIDE/REGION = 'non-UK'">
                                                                        <xsl:apply-templates select="GUIDE/REGION-OTHER"/>
                                                                </xsl:when>
                                                                <xsl:otherwise>
                                                                        <xsl:apply-templates select="GUIDE/REGION"/>
                                                                </xsl:otherwise>
                                                        </xsl:choose>
                                                </strong><br/> language: <strong>
                                                        <xsl:choose>
                                                                <xsl:when test="GUIDE/LANGUAGE-OTHER != '' and GUIDE/LANGUAGE = 'other'">
                                                                        <xsl:apply-templates select="GUIDE/LANGUAGE-OTHER"/>
                                                                </xsl:when>
                                                                <xsl:otherwise>
                                                                        <xsl:apply-templates select="GUIDE/LANGUAGE"/>
                                                                </xsl:otherwise>
                                                        </xsl:choose>
                                                </strong>
                                        </div>
                                        <!-- END MOVIE DETAILS -->
                                        <!-- Grey line spacer -->
                                        <table border="0" cellpadding="0" cellspacing="0" width="459">
                                                <tr>
                                                        <td height="17">
                                                                <img alt="" class="tiny" height="1" src="{$imagesource}furniture/wherebeenbar.gif" width="459"/>
                                                        </td>
                                                </tr>
                                        </table>
                                        <!-- END Grey line spacer -->
                                        <!-- HEADER , TEXT/LIST, GREY UNDERLINE -->
                                        <div class="centcolheaders">
                                                <strong>description</strong>
                                        </div>
                                        <div class="textmedium">
                                                <xsl:apply-templates select="GUIDE/DESCRIPTION"/>
                                        </div>
                                        <!-- Grey line spacer -->
                                        <table border="0" cellpadding="0" cellspacing="0" width="459">
                                                <tr>
                                                        <td height="17">
                                                                <img alt="" class="tiny" height="1" src="{$imagesource}furniture/wherebeenbar.gif" width="459"/>
                                                        </td>
                                                </tr>
                                        </table>
                                        <!-- END Grey line spacer -->
                                        <!-- END HEADER , TEXT/LIST, GREY UNDERLINE -->
                                        <!-- HEADER , TEXT/LIST, GREY UNDERLINE -->
                                        <div class="centcolheaders">
                                                <strong>synopsis</strong>
                                        </div>
                                        <div class="textmedium">
                                                <xsl:apply-templates select="GUIDE/BODY"/>
                                        </div>
                                        <!-- Grey line spacer -->
                                        <table border="0" cellpadding="0" cellspacing="0" width="459">
                                                <tr>
                                                        <td height="17">
                                                                <img alt="" class="tiny" height="1" src="{$imagesource}furniture/wherebeenbar.gif" width="459"/>
                                                        </td>
                                                </tr>
                                        </table>
                                        <!-- END Grey line spacer -->
                                        <!-- END HEADER , TEXT/LIST, GREY UNDERLINE -->
                                        <!-- new 8.12.2004 -->
                                        <!-- HEADER , TEXT/LIST, GREY UNDERLINE -->
                                        <div class="centcolheaders">
                                                <strong>short fact</strong>
                                        </div>
                                        <div class="textmedium">
                                                <xsl:apply-templates select="GUIDE/FILMMAKERSCOMMENTS"/>
                                        </div>
                                        <!-- Grey line spacer -->
                                        <table border="0" cellpadding="0" cellspacing="0" width="459">
                                                <tr>
                                                        <td height="17">
                                                                <img alt="" class="tiny" height="1" src="{$imagesource}furniture/wherebeenbar.gif" width="459"/>
                                                        </td>
                                                </tr>
                                        </table>
                                        <!-- END Grey line spacer -->
                                        <!-- END HEADER , TEXT/LIST, GREY UNDERLINE -->
                                        <!-- HEADER , TEXT/LIST, GREY UNDERLINE -->
                                        <div class="centcolheaders">
                                                <strong>distribution details</strong>
                                        </div>
                                        <div class="textmedium">
                                                <xsl:apply-templates select="GUIDE/DISTDETAILS"/>
                                        </div>
                                        <!-- Grey line spacer -->
                                        <table border="0" cellpadding="0" cellspacing="0" width="459">
                                                <tr>
                                                        <td height="17">
                                                                <img alt="" class="tiny" height="1" src="{$imagesource}furniture/wherebeenbar.gif" width="459"/>
                                                        </td>
                                                </tr>
                                        </table>
                                        <!-- END Grey line spacer -->
                                        <!-- END HEADER , TEXT/LIST, GREY UNDERLINE -->
                                        <!-- HEADER , TEXT/LIST, GREY UNDERLINE -->
                                        <div class="centcolheaders">
                                                <strong>funding details/production company</strong>
                                        </div>
                                        <div class="textmedium">
                                                <xsl:apply-templates select="GUIDE/FUNDINGDETAILS"/>
                                        </div>
                                        <!-- Grey line spacer -->
                                        <table border="0" cellpadding="0" cellspacing="0" width="459">
                                                <tr>
                                                        <td height="17">
                                                                <img alt="" class="tiny" height="1" src="{$imagesource}furniture/wherebeenbar.gif" width="459"/>
                                                        </td>
                                                </tr>
                                        </table>
                                        <!-- END Grey line spacer -->
                                        <!-- END HEADER , TEXT/LIST, GREY UNDERLINE -->
                                        <!-- HEADER , TEXT/LIST, GREY UNDERLINE -->
                                        <div class="centcolheaders">
                                                <strong>budget</strong>
                                        </div>
                                        <div class="textmedium">
                                                <xsl:apply-templates select="GUIDE/BUDGETCOST"/>
                                        </div>
                                        <!-- Grey line spacer -->
                                        <table border="0" cellpadding="0" cellspacing="0" width="459">
                                                <tr>
                                                        <td height="17">
                                                                <img alt="" class="tiny" height="1" src="{$imagesource}furniture/wherebeenbar.gif" width="459"/>
                                                        </td>
                                                </tr>
                                        </table>
                                        <!-- END Grey line spacer -->
                                        <!-- END HEADER , TEXT/LIST, GREY UNDERLINE -->
                                        <!-- HEADER , TEXT/LIST, GREY UNDERLINE -->
                                        <div class="centcolheaders">
                                                <strong>useful links</strong>
                                        </div>
                                        <div class="textmedium">
                                                <ul class="centcollist">
                                                        <xsl:if test="string-length(GUIDE/USEFULLINKS1) > 0">
                                                                <li>
                                                                        <xsl:choose>
                                                                                <xsl:when test="string-length(GUIDE/USEFULLINKS1_TEXT) > 0">
                                                                                        <xsl:value-of select="GUIDE/USEFULLINKS1_TEXT"/>
                                                                                </xsl:when>
                                                                                <xsl:otherwise>
                                                                                        <xsl:value-of select="GUIDE/USEFULLINKS1"/>
                                                                                </xsl:otherwise>
                                                                        </xsl:choose>
                                                                </li>
                                                        </xsl:if>
                                                        <xsl:if test="string-length(GUIDE/USEFULLINKS2) > 0">
                                                                <li>
                                                                        <xsl:choose>
                                                                                <xsl:when test="string-length(GUIDE/USEFULLINKS2_TEXT) > 0">
                                                                                        <xsl:value-of select="GUIDE/USEFULLINKS2_TEXT"/>
                                                                                </xsl:when>
                                                                                <xsl:otherwise>
                                                                                        <xsl:value-of select="GUIDE/USEFULLINKS2"/>
                                                                                </xsl:otherwise>
                                                                        </xsl:choose>
                                                                </li>
                                                        </xsl:if>
                                                        <xsl:if test="string-length(GUIDE/USEFULLINKS3) > 0">
                                                                <li>
                                                                        <xsl:choose>
                                                                                <xsl:when test="string-length(GUIDE/USEFULLINKS3_TEXT) > 0">
                                                                                        <xsl:value-of select="GUIDE/USEFULLINKS3_TEXT"/>
                                                                                </xsl:when>
                                                                                <xsl:otherwise>
                                                                                        <xsl:value-of select="GUIDE/USEFULLINKS3"/>
                                                                                </xsl:otherwise>
                                                                        </xsl:choose>
                                                                </li>
                                                        </xsl:if>
                                                        <!-- show extra links to editors only -->
                                                        <xsl:if test="$test_IsEditor">
                                                                <xsl:if test="string-length(GUIDE/USEFULLINKS4) > 0">
                                                                        <li>
                                                                                <xsl:choose>
                                                                                        <xsl:when test="string-length(GUIDE/USEFULLINKS4_TEXT) > 0">
                                                                                                <xsl:value-of select="GUIDE/USEFULLINKS4_TEXT"/>
                                                                                        </xsl:when>
                                                                                        <xsl:otherwise>
                                                                                                <xsl:value-of select="GUIDE/USEFULLINKS4"/>
                                                                                        </xsl:otherwise>
                                                                                </xsl:choose>
                                                                        </li>
                                                                </xsl:if>
                                                                <xsl:if test="string-length(GUIDE/USEFULLINKS5) > 0">
                                                                        <li>
                                                                                <xsl:choose>
                                                                                        <xsl:when test="string-length(GUIDE/USEFULLINKS5_TEXT) > 0">
                                                                                                <xsl:value-of select="GUIDE/USEFULLINKS5_TEXT"/>
                                                                                        </xsl:when>
                                                                                        <xsl:otherwise>
                                                                                                <xsl:value-of select="GUIDE/USEFULLINKS5"/>
                                                                                        </xsl:otherwise>
                                                                                </xsl:choose>
                                                                        </li>
                                                                </xsl:if>
                                                                <xsl:if test="string-length(GUIDE/USEFULLINKS6) > 0">
                                                                        <li>
                                                                                <xsl:choose>
                                                                                        <xsl:when test="string-length(GUIDE/USEFULLINKS6_TEXT) > 0">
                                                                                                <xsl:value-of select="GUIDE/USEFULLINKS6_TEXT"/>
                                                                                        </xsl:when>
                                                                                        <xsl:otherwise>
                                                                                                <xsl:value-of select="GUIDE/USEFULLINKS6"/>
                                                                                        </xsl:otherwise>
                                                                                </xsl:choose>
                                                                        </li>
                                                                </xsl:if>
                                                        </xsl:if>
                                                </ul>
                                        </div>
                                        <!-- Grey line spacer -->
                                        <table border="0" cellpadding="0" cellspacing="0" width="459">
                                                <tr>
                                                        <td height="17">
                                                                <img alt="" class="tiny" height="1" src="{$imagesource}furniture/wherebeenbar.gif" width="459"/>
                                                        </td>
                                                </tr>
                                        </table>
                                        <!-- END Grey line spacer -->
                                        <!-- END HEADER TEXT/LIST GREY BAR UNDERLINE -->
                                        <!-- grey HEADER , TEXT/LIST, GREY UNDERLINE -->
                                        <table border="0" cellpadding="0" cellspacing="0" width="459">
                                                <tr>
                                                        <td class="alerteditors" valign="top">
                                                                <div class="alerteditorhead">
                                                                        <strong>crew</strong>
                                                                </div>
                                                        </td>
                                                </tr>
                                                <tr>
                                                        <td height="8"/>
                                                </tr>
                                        </table>
                                        <div class="textmedium">
                                                <ul class="centcollist">
                                                        <li>
                                                                <strong>director: <xsl:apply-templates select="GUIDE/CREW_DIRECTOR"/></strong>
                                                        </li>
                                                        <li>
                                                                <strong>writer: <xsl:apply-templates select="GUIDE/CREW_WRITER"/></strong>
                                                        </li>
                                                        <li>
                                                                <strong>producer: <xsl:apply-templates select="GUIDE/CREW_PRODUCER"/></strong>
                                                        </li>
                                                        <li>
                                                                <strong>editor: <xsl:apply-templates select="GUIDE/CREW_EDITOR"/></strong>
                                                        </li>
                                                        <li>
                                                                <strong>director of photography: <xsl:apply-templates select="GUIDE/CREW_CAMERA"/></strong>
                                                        </li>
                                                        <li>
                                                                <strong>sound: <xsl:apply-templates select="GUIDE/CREW_SOUND"/></strong>
                                                        </li>
                                                        <li>
                                                                <strong>music: <xsl:apply-templates select="GUIDE/CREW_MUSIC"/></strong>
                                                        </li>
                                                </ul>
                                        </div>
                                        <br/>
                                        <div class="centcolheaders">
                                                <strong>other crew details:</strong>
                                        </div>
                                        <div class="textmedium">
                                                <xsl:apply-templates select="GUIDE/CREW_OTHER_DETAILS"/>
                                        </div>
                                        <!-- Grey line spacer -->
                                        <table border="0" cellpadding="0" cellspacing="0" width="371">
                                                <tr>
                                                        <td height="17">
                                                                <img alt="" class="tiny" height="1" src="{$imagesource}furniture/wherebeenbar.gif" width="459"/>
                                                        </td>
                                                </tr>
                                        </table>
                                        <!-- END Grey line spacer -->
                                        <!-- END grey HEADER , TEXT/LIST, GREY UNDERLINE -->
                                        <!-- grey HEADER , TEXT/LIST, GREY UNDERLINE -->
                                        <table border="0" cellpadding="0" cellspacing="0" width="459">
                                                <tr>
                                                        <td class="alerteditors" valign="top">
                                                                <div class="alerteditorhead">
                                                                        <strong>cast</strong>
                                                                </div>
                                                        </td>
                                                </tr>
                                                <tr>
                                                        <td height="8"/>
                                                </tr>
                                        </table>
                                        <xsl:choose>
                                                <xsl:when test="GUIDE/ORIGINALCREDIT = 'yes'">
                                                        <div class="textmedium">
                                                                <xsl:apply-templates select="GUIDE/CAST_OTHER_DETAILS"/>
                                                        </div>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                        <xsl:if
                                                                test="string-length(GUIDE/CAST1_NAME) > 0 or string-length(GUIDE/CAST2_NAME) > 0 or string-length(GUIDE/CAST3_NAME) > 0 or string-length(GUIDE/CAST4_NAME) > 0 or string-length(GUIDE/CAST5_NAME) > 0 or string-length(GUIDE/CAST6_NAME) > 0 or string-length(GUIDE/CAST7_NAME) > 0 or string-length(GUIDE/CAST_OTHER_DETAILS) > 0">
                                                                <div class="textmedium">
                                                                        <ul class="centcollist">
                                                                                <xsl:if test="string-length(GUIDE/CAST1_NAME) > 0">
                                                                                        <li>
                                                                                                <strong>
                                                                                                    <xsl:apply-templates select="GUIDE/CAST1_NAME"/>
                                                                                                </strong>
                                                                                                <xsl:text> </xsl:text>
                                                                                                <xsl:apply-templates select="GUIDE/CAST1_CHARACTER_NAME"/>
                                                                                        </li>
                                                                                </xsl:if>
                                                                                <xsl:if test="string-length(GUIDE/CAST2_NAME) > 0">
                                                                                        <li>
                                                                                                <strong>
                                                                                                    <xsl:apply-templates select="GUIDE/CAST2_NAME"/>
                                                                                                </strong>
                                                                                                <xsl:text> </xsl:text>
                                                                                                <xsl:apply-templates select="GUIDE/CAST2_CHARACTER_NAME"/>
                                                                                        </li>
                                                                                </xsl:if>
                                                                                <xsl:if test="string-length(GUIDE/CAST3_NAME) > 0">
                                                                                        <li>
                                                                                                <strong>
                                                                                                    <xsl:apply-templates select="GUIDE/CAST3_NAME"/>
                                                                                                </strong>
                                                                                                <xsl:text> </xsl:text>
                                                                                                <xsl:apply-templates select="GUIDE/CAST3_CHARACTER_NAME"/>
                                                                                        </li>
                                                                                </xsl:if>
                                                                                <xsl:if test="string-length(GUIDE/CAST4_NAME) > 0">
                                                                                        <li>
                                                                                                <strong>
                                                                                                    <xsl:apply-templates select="GUIDE/CAST4_NAME"/>
                                                                                                </strong>
                                                                                                <xsl:text> </xsl:text>
                                                                                                <xsl:apply-templates select="GUIDE/CAST4_CHARACTER_NAME"/>
                                                                                        </li>
                                                                                </xsl:if>
                                                                                <xsl:if test="string-length(GUIDE/CAST5_NAME) > 0">
                                                                                        <li>
                                                                                                <strong>
                                                                                                    <xsl:apply-templates select="GUIDE/CAST5_NAME"/>
                                                                                                </strong>
                                                                                                <xsl:text> </xsl:text>
                                                                                                <xsl:apply-templates select="GUIDE/CAST5_CHARACTER_NAME"/>
                                                                                        </li>
                                                                                </xsl:if>
                                                                                <xsl:if test="string-length(GUIDE/CAST6_NAME) > 0">
                                                                                        <li>
                                                                                                <strong>
                                                                                                    <xsl:apply-templates select="GUIDE/CAST6_NAME"/>
                                                                                                </strong>
                                                                                                <xsl:text> </xsl:text>
                                                                                                <xsl:apply-templates select="GUIDE/CAST6_CHARACTER_NAME"/>
                                                                                        </li>
                                                                                </xsl:if>
                                                                                <xsl:if test="string-length(GUIDE/CAST7_NAME) > 0">
                                                                                        <li>
                                                                                                <strong>
                                                                                                    <xsl:apply-templates select="GUIDE/CAST7_NAME"/>
                                                                                                </strong>
                                                                                                <xsl:text> </xsl:text>
                                                                                                <xsl:apply-templates select="GUIDE/CAST7_CHARACTER_NAME"/>
                                                                                        </li>
                                                                                </xsl:if>
                                                                                <xsl:if test="string-length(GUIDE/CAST8_NAME) > 0">
                                                                                        <li>
                                                                                                <strong>
                                                                                                    <xsl:apply-templates select="GUIDE/CAST8_NAME"/>
                                                                                                </strong>
                                                                                                <xsl:text> </xsl:text>
                                                                                                <xsl:apply-templates select="GUIDE/CAST8_CHARACTER_NAME"/>
                                                                                        </li>
                                                                                </xsl:if>
                                                                                <xsl:if test="string-length(GUIDE/CAST9_NAME) > 0">
                                                                                        <li>
                                                                                                <strong>
                                                                                                    <xsl:apply-templates select="GUIDE/CAST9_NAME"/>
                                                                                                </strong>
                                                                                                <xsl:text> </xsl:text>
                                                                                                <xsl:apply-templates select="GUIDE/CAST9_CHARACTER_NAME"/>
                                                                                        </li>
                                                                                </xsl:if>
                                                                                <xsl:if test="string-length(GUIDE/CAST10_NAME) > 0">
                                                                                        <li>
                                                                                                <strong>
                                                                                                    <xsl:apply-templates select="GUIDE/CAST10_NAME"/>
                                                                                                </strong>
                                                                                                <xsl:text> </xsl:text>
                                                                                                <xsl:apply-templates select="GUIDE/CAST10_CHARACTER_NAME"/>
                                                                                        </li>
                                                                                </xsl:if>
                                                                                <xsl:if test="string-length(GUIDE/CAST11_NAME) > 0">
                                                                                        <li>
                                                                                                <strong>
                                                                                                    <xsl:apply-templates select="GUIDE/CAST11_NAME"/>
                                                                                                </strong>
                                                                                                <xsl:text> </xsl:text>
                                                                                                <xsl:apply-templates select="GUIDE/CAST11_CHARACTER_NAME"/>
                                                                                        </li>
                                                                                </xsl:if>
                                                                                <xsl:if test="string-length(GUIDE/CAST12_NAME) > 0">
                                                                                        <li>
                                                                                                <strong>
                                                                                                    <xsl:apply-templates select="GUIDE/CAST12_NAME"/>
                                                                                                </strong>
                                                                                                <xsl:text> </xsl:text>
                                                                                                <xsl:apply-templates select="GUIDE/CAST12_CHARACTER_NAME"/>
                                                                                        </li>
                                                                                </xsl:if>
                                                                                <xsl:if test="string-length(GUIDE/CAST13_NAME) > 0">
                                                                                        <li>
                                                                                                <strong>
                                                                                                    <xsl:apply-templates select="GUIDE/CAST13_NAME"/>
                                                                                                </strong>
                                                                                                <xsl:text> </xsl:text>
                                                                                                <xsl:apply-templates select="GUIDE/CAST13_CHARACTER_NAME"/>
                                                                                        </li>
                                                                                </xsl:if>
                                                                                <xsl:if test="string-length(GUIDE/CAST14_NAME) > 0">
                                                                                        <li>
                                                                                                <strong>
                                                                                                    <xsl:apply-templates select="GUIDE/CAST14_NAME"/>
                                                                                                </strong>
                                                                                                <xsl:text> </xsl:text>
                                                                                                <xsl:apply-templates select="GUIDE/CAST14_CHARACTER_NAME"/>
                                                                                        </li>
                                                                                </xsl:if>
                                                                                <xsl:if test="string-length(GUIDE/CAST15_NAME) > 0">
                                                                                        <li>
                                                                                                <strong>
                                                                                                    <xsl:apply-templates select="GUIDE/CAST15_NAME"/>
                                                                                                </strong>
                                                                                                <xsl:text> </xsl:text>
                                                                                                <xsl:apply-templates select="GUIDE/CAST15_CHARACTER_NAME"/>
                                                                                        </li>
                                                                                </xsl:if>
                                                                                <xsl:if test="string-length(GUIDE/CAST16_NAME) > 0">
                                                                                        <li>
                                                                                                <strong>
                                                                                                    <xsl:apply-templates select="GUIDE/CAST16_NAME"/>
                                                                                                </strong>
                                                                                                <xsl:text> </xsl:text>
                                                                                                <xsl:apply-templates select="GUIDE/CAST16_CHARACTER_NAME"/>
                                                                                        </li>
                                                                                </xsl:if>
                                                                                <xsl:if test="string-length(GUIDE/CAST17_NAME) > 0">
                                                                                        <li>
                                                                                                <strong>
                                                                                                    <xsl:apply-templates select="GUIDE/CAST17_NAME"/>
                                                                                                </strong>
                                                                                                <xsl:text> </xsl:text>
                                                                                                <xsl:apply-templates select="GUIDE/CAST17_CHARACTER_NAME"/>
                                                                                        </li>
                                                                                </xsl:if>
                                                                                <xsl:if test="string-length(GUIDE/CAST18_NAME) > 0">
                                                                                        <li>
                                                                                                <strong>
                                                                                                    <xsl:apply-templates select="GUIDE/CAST18_NAME"/>
                                                                                                </strong>
                                                                                                <xsl:text> </xsl:text>
                                                                                                <xsl:apply-templates select="GUIDE/CAST18_CHARACTER_NAME"/>
                                                                                        </li>
                                                                                </xsl:if>
                                                                                <xsl:if test="string-length(GUIDE/CAST19_NAME) > 0">
                                                                                        <li>
                                                                                                <strong>
                                                                                                    <xsl:apply-templates select="GUIDE/CAST19_NAME"/>
                                                                                                </strong>
                                                                                                <xsl:text> </xsl:text>
                                                                                                <xsl:apply-templates select="GUIDE/CAST19_CHARACTER_NAME"/>
                                                                                        </li>
                                                                                </xsl:if>
                                                                                <xsl:if test="string-length(GUIDE/CAST20_NAME) > 0">
                                                                                        <li>
                                                                                                <strong>
                                                                                                    <xsl:apply-templates select="GUIDE/CAST20_NAME"/>
                                                                                                </strong>
                                                                                                <xsl:text> </xsl:text>
                                                                                                <xsl:apply-templates select="GUIDE/CAST20_CHARACTER_NAME"/>
                                                                                        </li>
                                                                                </xsl:if>
                                                                        </ul>
                                                                        <br/>
                                                                </div>
                                                        </xsl:if>
                                                        <div class="centcolheaders">
                                                                <strong>other cast details:</strong>
                                                        </div>
                                                        <div class="textmedium">
                                                                <xsl:apply-templates select="GUIDE/CAST_OTHER_DETAILS"/>
                                                        </div>
                                                </xsl:otherwise>
                                        </xsl:choose>
                                        <!-- END grey HEADER , TEXT/LIST -->
                                        <!-- 2px Black rule -->
                                        <table border="0" cellpadding="0" cellspacing="0" width="459">
                                                <tr>
                                                        <td height="8"/>
                                                </tr>
                                                <tr>
                                                        <td class="darkestbg" height="2"/>
                                                </tr>
                                        </table>
                                        <br/>
                                        <!-- END 2px Black rule -->
                                        <div class="centcolheaders">
                                                <strong>festival, awards and screenings:</strong>
                                        </div>
                                        <div class="textmedium">
                                                <xsl:if test="GUIDE/*[starts-with(name(.), 'FESTIVAL') and string-length(.) > 0]">
                                                        <xsl:choose>
                                                                <xsl:when test="GUIDE/*[starts-with(name(), 'FESTIVAL') and string-length() > 0 and name() != 'FESTIVALAWARDS']">
                                                                        <ul class="centcollist">
                                                                                <xsl:for-each select="GUIDE/*[starts-with(name(), 'FESTIVAL') and (substring-after(name(), '_') = 'AWARD')]">
                                                                                        <xsl:sort data-type="number"
                                                                                                select="number(substring-after(substring-before(name(.), '_'), 'FESTIVAL'))"/>
                                                                                        <xsl:variable name="name" select="concat('FESTIVAL', position(), '_NAME')"/>
                                                                                        <xsl:variable name="place" select="concat('FESTIVAL', position(), '_PLACE')"/>
                                                                                        <xsl:variable name="year" select="concat('FESTIVAL', position(), '_YEAR')"/>
                                                                                        <xsl:if
                                                                                                test="string-length() > 0 or string-length(../*[name() = $name]) > 0 or string-length(../*[name() = $place]) > 0 or string-length(../*[name() = $year]) > 0">
                                                                                                <li>
                                                                                                    <xsl:if test="string-length() > 0">
                                                                                                            <xsl:value-of select="."/>
                                                                                                            <xsl:if test="string-length(../*[name() = $name]) > 0 or string-length(../*[name() = $place]) > 0 or string-length(../*[name() = $year]) > 0">
                                                                                                                    <xsl:text>, </xsl:text>
                                                                                                            </xsl:if>
                                                                                                    </xsl:if>
                                                                                                    <xsl:if test="string-length(../*[name() = $name]) > 0">
                                                                                                            <xsl:value-of select="../*[name() = $name]"/>
                                                                                                            <xsl:if test="string-length(../*[name() = $place]) > 0 or string-length(../*[name() = $year]) > 0">
                                                                                                                    <xsl:text>, </xsl:text>
                                                                                                            </xsl:if>
                                                                                                    </xsl:if>
                                                                                                    <xsl:if test="string-length(../*[name() = $place]) > 0">
                                                                                                            <xsl:value-of select="../*[name() = $place]"/>
                                                                                                            <xsl:if test="string-length(../*[name() = $year]) > 0">
                                                                                                                    <xsl:text>, </xsl:text>
                                                                                                            </xsl:if>
                                                                                                    </xsl:if>
                                                                                                    <xsl:if test="string-length(../*[name() = $year]) > 0">
                                                                                                            <xsl:value-of select="../*[name() = $year]"/>
                                                                                                    </xsl:if>
                                                                                                </li>
                                                                                        </xsl:if>
                                                                                </xsl:for-each>
                                                                        </ul>
                                                                </xsl:when>
                                                                <xsl:otherwise>
                                                                        <xsl:apply-templates select="GUIDE/FESTIVALAWARDS"/>
                                                                </xsl:otherwise>
                                                        </xsl:choose>
                                                </xsl:if>
                                        </div>
                                        <!-- 2px Black rule -->
                                        <table border="0" cellpadding="0" cellspacing="0" width="459">
                                                <tr>
                                                        <td height="8"/>
                                                </tr>
                                                <tr>
                                                        <td class="darkestbg" height="2"/>
                                                </tr>
                                        </table>
                                        <br/>
                                        <!-- END 2px Black rule -->
                                        <!-- final submit -->
                                        <!-- END final submit -->
                                        <xsl:if test="/H2G2/PARAMS/PARAM[NAME = 's_print']/VALUE = '1' and /H2G2/PARAMS/PARAM[NAME = 's_type']/VALUE = 'pop'">
                                                <style media="screen">
	body {margin:0px; background:#fff; color:#5e5d5d;}
	</style>
                                                <table border="0" cellpadding="0" cellspacing="0" width="459">
                                                        <tr>
                                                                <td height="8"/>
                                                        </tr>
                                                </table>
                                                <div>
                                                        <img alt="film information" height="34" src="{$imagesource}furniture/submissionrules.gif" width="264"/>
                                                </div>
                                                <!-- Grey line spacer -->
                                                <table border="0" cellpadding="0" cellspacing="0" width="371">
                                                        <tr>
                                                                <td height="17">
                                                                        <img alt="" class="tiny" height="1" src="{$imagesource}furniture/wherebeenbar.gif" width="459"/>
                                                                </td>
                                                        </tr>
                                                </table>
                                                <!-- END Grey line spacer -->
                                                <div class="textxsmall">
                                                        <ol>
                                                                <li>You agree, by submitting your film, to grant the BBC during the licence period a non-exclusive, free licence to digitize, encode and
                                                                        publish your film on the BBC Film Network Website on the BBC's online service and for such other purposes (such as publicity
                                                                        related to the BBC Film Network Website) as are expressly provided for in these rules.<br/><br/></li>
                                                                <li>The licence period shall commence from the date you submit your film and shall continue for a 5 year period from the date of first
                                                                        publication of your film on the BBC Film Network Website.<br/><br/></li>
                                                                <li>During the licence period the BBC has a non-exclusive right to make your film available through streaming technology and by way of
                                                                        download provided that the download mechanism employed by the BBC has digital rights management features and the downloaded
                                                                        films shall self-destruct within one month from the date of download by a user.<br/><br/></li>
                                                                <li>In addition, you grant the BBC the right to sub-license your film during the licence period for the purpose of syndication of the
                                                                        BBC Film Network Website for use on a third party website or service (for example the BBC may permit publication of content from
                                                                        the BBC Film Network Website on the UK Film Council website). The BBC will not charge any fee to the third party in return for
                                                                        such syndication.<br/><br/></li>
                                                                <li>If your contribution is published by the BBC you permit the BBC to make and retain both during and after the licence period a copy
                                                                        of your film as may be required or recommended by any regulatory authority for the BBC's own archival purposes.<br/><br/></li>
                                                                <li>If you do not want to grant to the BBC the rights set out above, please do not submit your film to the BBC.<br/><br/></li>
                                                                <li>The BBC reserves the right to not make use of your film for any reason at its absolute discretion.<br/><br/></li>
                                                                <li>You should retain a master copy of your film because the BBC will not return the tapes or stills that you submit.<br/><br/></li>
                                                                <li>Your film must be your own original work and you agree that your film will not infringe the copyright or any other rights of any
                                                                        third party.<br/><br/></li>
                                                                <li>By submitting your film to the BBC, you: <dl>
                                                                                <dt>10.1 warrant that your film;<br/><br/>
                                                                                        <dl>
                                                                                                <dt>10.1.1 is your own original work and that you have the right to make it available to the BBC for all
                                                                                                    the purposes specified above; and<br/><br/></dt>
                                                                                                <dt>10.1.2 does not infringe any law;<br/><br/></dt>
                                                                                        </dl>
                                                                                </dt>
                                                                                <dt>10.2 agree to indemnify the BBC against all legal fees, damages and other expenses that may be incurred by the BBC
                                                                                        as a result of your breach of the above warranties; and<br/><br/></dt>
                                                                                <dt>10.3 waive any moral rights in your film for all the purposes specified above, including its submission to and
                                                                                        publication by the BBC.<br/><br/></dt>
                                                                        </dl>
                                                                </li>
                                                                <li>Submission of your film to the BBC amounts to acceptance of these rules.<br/><br/></li>
                                                                <li>If you enter into an agreement with a third party, such as a distribution agreement, and the agreement does not permit you to
                                                                        showcase your film on the BBC Film Network Website, you can request that your film be removed from the site, provided you give
                                                                        the BBC at least 7 days' written notice.<br/><br/></li>
                                                                <li>Your film is made at your own expense and the BBC shall not be liable to reimburse you for any expenses you incur in submitting your
                                                                        film.<br/><br/></li>
                                                                <li>Your film must not contain defamatory, obscene, unlawful or objectionable material.<br/><br/></li>
                                                                <li>You must be a resident of the United Kingdom.<br/><br/></li>
                                                                <li>Wherever used, we agree to credit your film to you with the appropriate copyright acknowledgment.<br/><br/></li>
                                                                <li>The BBC will use the personal data you submit about yourself to contact you for the purposes of this submission and to inform you
                                                                        when your film has been published on the BBC Film Network Website. The BBC will include your name (but not any other details) on
                                                                        the page on which your film is featured.<br/><br/></li>
                                                                <li>You agree that by providing the names of third parties such as the director, cast, crew and others that those third parties have
                                                                        consented to you providing such personal data to the BBC and that they are aware that the BBC will use the personal data for the
                                                                        purpose of including the third party's name on the page on which your film is featured.<br/><br/></li>
                                                                <li>The BBC does not accept any responsibility for any lost films. Proof of sending is not proof of receipt.<br/><br/></li>
                                                                <li>These rules are governed by the laws of England and Wales whose courts shall be courts of competent jurisdiction.<br/><br/></li>
                                                        </ol>
                                                </div>
                                                <!-- 2px Black rule -->
                                                <table border="0" cellpadding="0" cellspacing="0" width="459">
                                                        <tr>
                                                                <td height="8"/>
                                                        </tr>
                                                        <tr>
                                                                <td class="darkestbg" height="2"/>
                                                        </tr>
                                                        <tr>
                                                                <td height="16"/>
                                                        </tr>
                                                </table>
                                                <!-- END 2px Black rule -->
                                                <table border="0" cellpadding="0" cellspacing="0" width="459">
                                                        <tr>
                                                                <td align="right" nowrap="nowrap">
                                                                        <div class="textmedium"><strong>your signature:</strong>&nbsp;</div>
                                                                </td>
                                                                <td width="85%">
                                                                        <div class="textmedium"> __________________________________________</div>
                                                                </td>
                                                        </tr>
                                                        <tr>
                                                                <td colspan="2" height="8"/>
                                                        </tr>
                                                        <tr>
                                                                <td align="right" nowrap="nowrap">
                                                                        <div class="textmedium"><strong>date:</strong>&nbsp;</div>
                                                                </td>
                                                                <td width="85%">
                                                                        <div class="textmedium"> __________________________________________</div>
                                                                </td>
                                                        </tr>
                                                </table>
                                                <table border="0" cellpadding="0" cellspacing="0" width="371">
                                                        <tr>
                                                                <td height="17">
                                                                        <img alt="" class="tiny" height="1" src="{$imagesource}furniture/wherebeenbar.gif" width="459"/>
                                                                </td>
                                                        </tr>
                                                </table>
                                                <div class="textxsmall">
                                                        <br/> Film Network Submissions <br/>
                                                        <xsl:copy-of select="$m_BBCaddress"/><br/><br/> *We regret that we cannot return tapes or stills and we do not guarantee to publish your film. </div>
                                                <!-- 2px Black rule -->
                                                <table border="0" cellpadding="0" cellspacing="0" width="459">
                                                        <tr>
                                                                <td height="18"/>
                                                        </tr>
                                                        <tr>
                                                                <td align="right">
                                                                        <strong>
                                                                                <a href="#" onclick="print();">
                                                                                        <img alt="" class="tiny" height="22" src="{$imagesource}furniture/print.gif" width="100"/>
                                                                                </a>
                                                                        </strong>
                                                                </td>
                                                        </tr>
                                                        <tr>
                                                                <td height="8"/>
                                                        </tr>
                                                </table>
                                                <!-- END 2px Black rule -->
                                        </xsl:if>
                                        <xsl:if test="$test_IsEditor">
                                                <div class="textmedium">
                                                        <br/>
                                                        <b>read subbmission rules:</b>
                                                        <xsl:apply-templates select="GUIDE/DECLARATION_READSUBBMISSION"/><br/>
                                                        <b>read clearance procedure:</b>
                                                        <xsl:apply-templates select="GUIDE/DECLARATION_CLEARANCEPROCEDURE"/><br/>
                                                        <b>agree no return tape:</b>
                                                        <xsl:apply-templates select="GUIDE/DECLARATION_NORETURNTAPE"/><br/>
                                                        <b>streaming:</b><br/>
                                                        <xsl:if test="GUIDE/STREAMING_NARROW = 'on'"><b>Narrow</b> Selected<br/></xsl:if>
                                                        <xsl:if test="GUIDE/STREAMING_BROADBAND = 'on'"><b>Broadband</b> Selected<br/></xsl:if>
                                                        <xsl:if test="GUIDE/WINPLAYER = 'on'"><b>Windows player</b> Selected<br/></xsl:if>
                                                        <xsl:if test="GUIDE/REALPLAYER = 'on'"><b>Real player</b> Selected</xsl:if><br/>
                                                        <b>player size:</b>
                                                        <xsl:apply-templates select="GUIDE/PLAYER_SIZE"/><br/>
                                                        <b>available until:</b><br/>
                                                        <xsl:if test="string-length(GUIDE/AVAIL_DAY) > 0">
                                                                <xsl:apply-templates select="GUIDE/AVAIL_DAY"/>&nbsp;<xsl:call-template name="getAvailableMonth">
                                                                        <xsl:with-param name="filmmonth">
                                                                                <xsl:apply-templates select="GUIDE/AVAIL_MONTH"/>
                                                                        </xsl:with-param>
                                                                </xsl:call-template>&nbsp;<xsl:apply-templates select="GUIDE/AVAIL_YEAR"/><br/>
                                                        </xsl:if>
                                                        <b>hi-res download:</b>&nbsp;&nbsp;<xsl:if test="GUIDE/HI_RES_DOWNLOAD = 'on'">Yes</xsl:if><br/><br/>
                                                        <b>stills gallery:</b>&nbsp;&nbsp;<xsl:if test="GUIDE/STILLS_GALLERY = 'on'">Yes</xsl:if><br/><br/>
                                                        <b>adult content:</b><br/>
                                                        <xsl:apply-templates select="GUIDE/STANDARD_WARNING"/><BR/><BR/>
                                                        <b>additional warning:</b><br/>
                                                        <xsl:apply-templates select="GUIDE/ADDITIONAL_WARNING"/>
                                                </div>
                                                <table>
                                                        <tr>
                                                                <td><strong>Short1:</strong>&nbsp;&nbsp;</td>
                                                                <td>
                                                                        <b>Short title</b>
                                                                </td>
                                                                <td>
                                                                        <b>a-number</b>
                                                                </td>
                                                                <td>
                                                                        <b>length</b>
                                                                </td>
                                                                <td/>
                                                                <td>
                                                                        <b>genre</b>
                                                                </td>
                                                        </tr>
                                                        <tr>
                                                                <td/>
                                                                <td>
                                                                        <xsl:apply-templates select="GUIDE/SHORT1_TITLE"/> &nbsp;&nbsp;</td>
                                                                <td>
                                                                        <xsl:value-of select="GUIDE/SHORT1_ANUMBER"/> &nbsp;&nbsp;</td>
                                                                <td>
                                                                        <xsl:value-of select="GUIDE/SHORT1_LENGTH_MIN"/> &nbsp;&nbsp;</td>
                                                                <td>
                                                                        <xsl:value-of select="GUIDE/SHORT1_LENGTH_SEC"/> &nbsp;&nbsp;</td>
                                                                <td>
                                                                        <xsl:value-of select="GUIDE/SHORT1_GENRE"/> &nbsp;&nbsp;</td>
                                                        </tr>
                                                        <tr>
                                                                <td><strong>Short2:</strong>&nbsp;&nbsp;</td>
                                                                <td>
                                                                        <b>Short title</b>
                                                                </td>
                                                                <td>
                                                                        <b>a-number</b>
                                                                </td>
                                                                <td>
                                                                        <b>length</b>
                                                                </td>
                                                                <td/>
                                                                <td>
                                                                        <b>genre</b>
                                                                </td>
                                                        </tr>
                                                        <tr>
                                                                <td/>
                                                                <td>
                                                                        <xsl:value-of select="GUIDE/SHORT2_TITLE"/> &nbsp;&nbsp;</td>
                                                                <td>
                                                                        <xsl:value-of select="GUIDE/SHORT2_ANUMBER"/> &nbsp;&nbsp;</td>
                                                                <td>
                                                                        <xsl:value-of select="GUIDE/SHORT2_LENGTH_MIN"/> &nbsp;&nbsp;</td>
                                                                <td>
                                                                        <xsl:value-of select="GUIDE/SHORT2_LENGTH_SEC"/> &nbsp;&nbsp;</td>
                                                                <td>
                                                                        <xsl:value-of select="GUIDE/SHORT2_GENRE"/> &nbsp;&nbsp;</td>
                                                        </tr>
                                                        <tr>
                                                                <td><strong>Short3:</strong>&nbsp;&nbsp;</td>
                                                                <td>
                                                                        <b>Short title</b>
                                                                </td>
                                                                <td>
                                                                        <b>a-number</b>
                                                                </td>
                                                                <td>
                                                                        <b>length</b>
                                                                </td>
                                                                <td/>
                                                                <td>
                                                                        <b>genre</b>
                                                                </td>
                                                        </tr>
                                                        <tr>
                                                                <td/>
                                                                <td>
                                                                        <xsl:value-of select="GUIDE/SHORT3_TITLE"/> &nbsp;&nbsp;</td>
                                                                <td>
                                                                        <xsl:value-of select="GUIDE/SHORT3_ANUMBER"/> &nbsp;&nbsp;</td>
                                                                <td>
                                                                        <xsl:value-of select="GUIDE/SHORT3_LENGTH_MIN"/> &nbsp;&nbsp;</td>
                                                                <td>
                                                                        <xsl:value-of select="GUIDE/SHORT3_LENGTH_SEC"/> &nbsp;&nbsp;</td>
                                                                <td>
                                                                        <xsl:value-of select="GUIDE/SHORT3_GENRE"/> &nbsp;&nbsp;</td>
                                                        </tr>
                                                </table>
                                                <div class="textmedium">
                                                        <strong>film promo</strong>
                                                        <BR/>
                                                        <BR/>
                                                        <xsl:value-of select="GUIDE/FILM_PROMO"/>
                                                        <BR/>
                                                </div>
                                        </xsl:if>
                                        <xsl:if test="$test_IsEditor or ((/H2G2/ARTICLE/ARTICLEINFO/STATUS/@TYPE = 3) and $ownerisviewer=1) and  not(/H2G2/PARAMS/PARAM[NAME= 's_print']/VALUE = 1)">
                                                <div class="textmedium">
                                                        <br/>
                                                        <br/>
                                                        <a href="{$root}TypedArticle?aedit=new&amp;type={$current_article_type}&amp;h2g2id={/H2G2/ARTICLE/ARTICLEINFO/H2G2ID}">
                                                                <img alt="Edit" height="22" src="{$imagesource}furniture/editfilm.gif" width="81"/>
                                                        </a>
                                                        <br/>
                                                        <br/>
                                                </div>
                                        </xsl:if>
                                </td>
                                <td class="subrightcolbg" valign="top" width="88">
                                        <img alt="" class="tiny" height="30" src="/f/t.gif" width="88"/>
                                </td>
                        </tr>
                        <tr>
                                <td class="subrowbotbg" height="10"/>
                                <td class="subrowbotbg"/>
                                <td class="subrowbotbg"/>
                        </tr>
                </table>
        </xsl:template>
        <!-- 
     ################################################################################
	  preview mode for editors and viewing mode for approved submissions  
	 ################################################################################
-->
        <xsl:template name="FILM_APPROVED">
                <!-- Header information (film title, director, date, etc) for approved film or credit -->
                <xsl:choose>
                        <!-- If page is a credit -->
                        <xsl:when test="$article_type_group = 'credit'">
                                <xsl:call-template name="FILM_APPROVED_CREDITHEAD"/>
                        </xsl:when>
                        <!-- otherwise, assume page is an approved film -->
                        <xsl:otherwise>
                                <xsl:call-template name="FILM_APPROVED_FILMHEAD"/>
                        </xsl:otherwise>
                </xsl:choose>
                <!-- BEGIN Grey line spacer -->
                <table border="0" cellpadding="0" cellspacing="0" width="635">
                        <tr>
                                <td height="14"/>
                        </tr>
                </table>
                <!-- END Grey line spacer -->
                <!-- BEGIN MAIN BODY -->
                <table border="0" cellpadding="0" cellspacing="0" width="635">
                        <!-- Spacer row -->
                        <tr>
                                <td>
                                        <img alt="" class="tiny" height="1" src="/f/t.gif" width="371"/>
                                </td>
                                <td>
                                        <img alt="" class="tiny" height="1" src="/f/t.gif" width="20"/>
                                </td>
                                <td>
                                        <img alt="" class="tiny" height="1" src="/f/t.gif" width="244"/>
                                </td>
                        </tr>
                        <tr>
                                <td height="300" valign="top">
                                        <!-- Series shorts -->
                                        <xsl:if test="GUIDE/IS_SERIES = 'on'">
                                                <div id="series-episodes">
                                                        <ul>
                                                                <xsl:for-each select="GUIDE/*[starts-with(local-name(), 'EPISODE') and  contains(local-name(), 'TITLE') and string-length() > 0]">
                                                                        <xsl:call-template name="episode-list">
                                                                                <xsl:with-param name="episode-no" select="substring(local-name(), 8, string-length(local-name()) - 13) "/>
                                                                        </xsl:call-template>
                                                                </xsl:for-each>
                                                        </ul>
                                                </div>
                                        </xsl:if>
                                        <!-- End series shorts -->
                                        <!-- BEGIN Grey line spacer -->
                                        <table border="0" cellpadding="0" cellspacing="0" width="371">
                                                <tr>
                                                        <td height="11" valign="top">
                                                                <img alt="" class="tiny" height="1" src="{$imagesource}furniture/wherebeenbar.gif" width="371"/>
                                                        </td>
                                                </tr>
                                        </table>
                                        <!-- END Grey line spacer -->
                                        <!-- BEGIN synopsis -->
                                        <div class="centcolheaders">
                                                <strong>synopsis</strong>
                                        </div>
                                        <div class="textmedium">
                                                <xsl:apply-templates select="GUIDE/BODY"/>
                                        </div>
                                        <!-- END synopsis -->
                                        <!-- BEGIN filmmakers comments: if processed as a credit do not include -->
                                        <xsl:if test="string-length(GUIDE/FILMMAKERSCOMMENTS) > 0 and $article_type_group != 'credit'">
                                                <!-- BEGIN Grey line spacer -->
                                                <table border="0" cellpadding="0" cellspacing="0" width="371">
                                                        <tr>
                                                                <td height="15"/>
                                                        </tr>
                                                        <tr>
                                                                <td height="11" valign="top">
                                                                        <img alt="" class="tiny" height="1" src="{$imagesource}furniture/wherebeenbar.gif" width="371"/>
                                                                </td>
                                                        </tr>
                                                </table>
                                                <!-- END Grey line spacer -->
                                                <!-- Link to filmmaker's notes (title, text) -->
                                                <div class="centcolheaders">
                                                        <strong>short fact</strong>
                                                </div>
                                                <div class="textmedium">
                                                        <xsl:apply-templates select="GUIDE/FILMMAKERSCOMMENTS"/>
                                                </div>
                                        </xsl:if>
                                        <!-- END filmmakers comments -->
                                        <!-- BEGIN Notes Link: don't show link for notes if isn't an id set -->
                                        <xsl:if test="string-length(GUIDE/NOTESID) > 5">
                                                <div class="viewFilmNote">
                                                        <a href="{$root}{GUIDE/NOTESID}">view filmmaker's notes</a>
                                                        <img alt="" border="0" height="7" src="{$imagesource}furniture/linkgraphic.gif" width="10"/>
                                                </div>
                                        </xsl:if>
                                        <!-- END Notes Link -->
                                        <!-- BEGIN Cast and Crew Section: included for both approved film and credit pages -->
                                        <xsl:if test="GUIDE/*[starts-with(name(.), 'CREW') and string-length(.) > 0] or GUIDE/*[starts-with(name(.), 'CREW') and string-length(.) > 0]">
                                                <!-- Grey line spacer -->
                                                <table border="0" cellpadding="0" cellspacing="0" width="371">
                                                        <tr>
                                                                <td height="15"/>
                                                        </tr>
                                                        <tr>
                                                                <td height="1">
                                                                        <img alt="" class="tiny" height="1" src="{$imagesource}furniture/wherebeenbar.gif" width="371"/>
                                                                </td>
                                                        </tr>
                                                </table>
                                                <!-- END Grey line spacer -->
                                        </xsl:if>
                                        <!-- BEGIN crew -->
                                        <xsl:if test="GUIDE/*[starts-with(name(.), 'CREW') and string-length(.) > 0]">
                                                <table border="0" cellpadding="0" cellspacing="0" style="margin-top:10px;" width="371">
                                                        <tr>
                                                                <td valign="top" width="175">
                                                                        <div class="centcolheaders">
                                                                                <strong>crew</strong>
                                                                        </div>
                                                                </td>
                                                        </tr>
                                                        <tr>
                                                                <td valign="top" width="371">
                                                                        <div class="textmedium">
                                                                                <ul class="centcollist">
                                                                                        <xsl:if test="string-length(GUIDE/CREW_DIRECTOR) > 0">
                                                                                                <li>director <strong>
                                                                                                    <xsl:apply-templates select="GUIDE/CREW_DIRECTOR"/>
                                                                                                    </strong></li>
                                                                                        </xsl:if>
                                                                                        <xsl:if test="string-length(GUIDE/CREW_WRITER) > 0">
                                                                                                <li>writer <strong>
                                                                                                    <xsl:apply-templates select="GUIDE/CREW_WRITER"/>
                                                                                                    </strong></li>
                                                                                        </xsl:if>
                                                                                        <xsl:if test="string-length(GUIDE/CREW_PRODUCER) > 0">
                                                                                                <li>producer <strong>
                                                                                                    <xsl:apply-templates select="GUIDE/CREW_PRODUCER"/>
                                                                                                    </strong></li>
                                                                                        </xsl:if>
                                                                                        <xsl:if test="string-length(GUIDE/CREW_EDITOR) > 0">
                                                                                                <li>editor <strong>
                                                                                                    <xsl:apply-templates select="GUIDE/CREW_EDITOR"/>
                                                                                                    </strong></li>
                                                                                        </xsl:if>
                                                                                        <xsl:if test="string-length(GUIDE/CREW_CAMERA) > 0">
                                                                                                <li>director of photography <strong>
                                                                                                    <xsl:apply-templates select="GUIDE/CREW_CAMERA"/>
                                                                                                    </strong></li>
                                                                                        </xsl:if>
                                                                                        <xsl:if test="string-length(GUIDE/CREW_SOUND) > 0">
                                                                                                <li>sound <strong>
                                                                                                    <xsl:apply-templates select="GUIDE/CREW_SOUND"/>
                                                                                                    </strong></li>
                                                                                        </xsl:if>
                                                                                        <xsl:if test="string-length(GUIDE/CREW_MUSIC) > 0">
                                                                                                <li>music <strong>
                                                                                                    <xsl:apply-templates select="GUIDE/CREW_MUSIC"/>
                                                                                                    </strong></li>
                                                                                        </xsl:if>
                                                                                        <xsl:for-each
                                                                                                select="GUIDE/*[starts-with(name(.), 'CREW') and             (substring-after(name(.), '_OTHER_') = 'NAME')]">
                                                                                                <xsl:sort data-type="number"
                                                                                                    select="number(substring-after(substring-before(name(.), '_'),              'CREW'))"/>
                                                                                                <xsl:variable name="role" select="concat('CREW', position(), '_OTHER_ROLE')"/>
                                                                                                <xsl:if test="string-length() > 0 or ../*[(name() = $role) and              (string-length() > 0)]">
                                                                                                    <li>
                                                                                                    <xsl:value-of select="../*[name(.) = $role]"/>
                                                                                                    <xsl:text> </xsl:text>
                                                                                                    <strong>
                                                                                                    <xsl:value-of select="."/>
                                                                                                    </strong>
                                                                                                    </li>
                                                                                                </xsl:if>
                                                                                        </xsl:for-each>
                                                                                </ul>
                                                                                <xsl:if test="string-length(GUIDE/CREW_OTHER_DETAILS) > 0">
                                                                                        <xsl:apply-templates select="GUIDE/CREW_OTHER_DETAILS"/>
                                                                                </xsl:if>
                                                                        </div>
                                                                </td>
                                                        </tr>
                                                </table>
                                        </xsl:if>
                                        <!-- END crew -->
                                        <!-- BEGIN cast -->
                                        <xsl:if test="GUIDE/*[starts-with(name(.), 'CAST') and string-length(.) > 0]">
                                                <table border="0" cellpadding="0" cellspacing="0" style="margin-top:10px" width="371">
                                                        <tr>
                                                                <td valign="top" width="371">
                                                                        <div class="centcolheaders">
                                                                                <strong>cast</strong>
                                                                        </div>
                                                                </td>
                                                        </tr>
                                                        <tr>
                                                                <td valign="top" width="371">
                                                                        <div class="textmedium">
                                                                                <ul class="centcollist">
                                                                                        <xsl:for-each
                                                                                                select="GUIDE/*[starts-with(name(), 'CAST') and             (substring-after(name(), '_CHARACTER_') = 'NAME')]">
                                                                                                <xsl:sort data-type="number"
                                                                                                    select="number(substring-after(substring-before(name(), '_'),              'CAST'))"/>
                                                                                                <xsl:variable name="name" select="concat('CAST', position(), '_NAME')"/>
                                                                                                <xsl:if test="string-length() > 0 or ../*[(name() = $name) and              (string-length() > 0)]">
                                                                                                    <li>
                                                                                                    <xsl:value-of select="."/>
                                                                                                    <xsl:text> </xsl:text>
                                                                                                    <strong>
                                                                                                    <xsl:value-of select="../*[name(.) = $name]"/>
                                                                                                    </strong>
                                                                                                    </li>
                                                                                                </xsl:if>
                                                                                        </xsl:for-each>
                                                                                </ul>
                                                                                <xsl:if test="string-length(GUIDE/CAST_OTHER_DETAILS) > 0">
                                                                                        <xsl:apply-templates select="GUIDE/CAST_OTHER_DETAILS"/>
                                                                                </xsl:if>
                                                                        </div>
                                                                </td>
                                                        </tr>
                                                </table>
                                        </xsl:if>
                                        <!-- END cast -->
                                        <!-- END Cast and Crew Section -->
                                        <!-- BEGIN Festvals, Awards and Screenings: included for both approved film and credit pages -->
                                        <!-- Grey line spacer -->
                                        <table border="0" cellpadding="0" cellspacing="0" width="371">
                                                <tr>
                                                        <td height="15"/>
                                                </tr>
                                                <tr>
                                                        <td height="1">
                                                                <img alt="" class="tiny" height="1" src="{$imagesource}furniture/wherebeenbar.gif" width="371"/>
                                                        </td>
                                                </tr>
                                                <tr>
                                                        <td height="10"/>
                                                </tr>
                                        </table>
                                        <!-- END Grey line spacer -->
                                        <xsl:if test="GUIDE/*[starts-with(name(.), 'FESTIVAL') and string-length(.) > 0]">
                                                <!-- festivals and awards (title and text) -->
                                                <div class="centcolheaders">
                                                        <strong>festivals, awards and screenings include:</strong>
                                                </div>
                                                <div class="textmedium">
                                                        <xsl:choose>
                                                                <xsl:when test="GUIDE/*[starts-with(name(), 'FESTIVAL') and string-length() > 0 and name() != 'FESTIVALAWARDS']">
                                                                        <ul class="centcollist">
                                                                                <xsl:for-each select="GUIDE/*[starts-with(name(), 'FESTIVAL') and (substring-after(name(), '_') = 'AWARD')]">
                                                                                        <xsl:sort data-type="number"
                                                                                                select="number(substring-after(substring-before(name(.), '_'), 'FESTIVAL'))"/>
                                                                                        <xsl:variable name="name" select="concat('FESTIVAL', position(), '_NAME')"/>
                                                                                        <xsl:variable name="place" select="concat('FESTIVAL', position(), '_PLACE')"/>
                                                                                        <xsl:variable name="year" select="concat('FESTIVAL', position(), '_YEAR')"/>
                                                                                        <xsl:if
                                                                                                test="string-length() > 0 or string-length(../*[name() = $name]) > 0 or string-length(../*[name() = $place]) > 0 or             string-length(../*[name() = $year]) > 0">
                                                                                                <li>
                                                                                                    <xsl:if test="string-length() > 0">
                                                                                                    <xsl:value-of select="."/>
                                                                                                    <xsl:text>, </xsl:text>
                                                                                                    </xsl:if>
                                                                                                    <xsl:if test="string-length(../*[name() = $name]) > 0">
                                                                                                    <xsl:value-of select="../*[name() = $name]"/>
                                                                                                    <xsl:text>, </xsl:text>
                                                                                                    </xsl:if>
                                                                                                    <xsl:if test="string-length(../*[name() = $place]) > 0">
                                                                                                    <xsl:value-of select="../*[name() = $place]"/>
                                                                                                    <xsl:text>, </xsl:text>
                                                                                                    </xsl:if>
                                                                                                    <xsl:if test="string-length(../*[name() = $year]) > 0">
                                                                                                    <xsl:value-of select="../*[name() = $year]"/>
                                                                                                    </xsl:if>
                                                                                                </li>
                                                                                        </xsl:if>
                                                                                </xsl:for-each>
                                                                        </ul>
                                                                </xsl:when>
                                                                <xsl:otherwise>
                                                                        <xsl:apply-templates select="GUIDE/FESTIVALAWARDS"/>
                                                                </xsl:otherwise>
                                                        </xsl:choose>
                                                </div>
                                        </xsl:if>
                                        <!-- END Festvals, Awards and Screenings -->
                                        <xsl:if test="$article_type_group = 'film'">
                                                <!-- BEGIN Bugdet and Format Section -->
                                                <xsl:if test="string-length(GUIDE/BUDGETCOST) > 0 or string-length(GUIDE/ORIGINALFORMAT) > 0 and $article_type_group != 'credit'">
                                                        <!-- Grey line spacer -->
                                                        <table border="0" cellpadding="0" cellspacing="0" width="371">
                                                                <tr>
                                                                        <td height="15"/>
                                                                </tr>
                                                                <tr>
                                                                        <td height="1">
                                                                                <img alt="" class="tiny" height="1" src="{$imagesource}furniture/wherebeenbar.gif" width="371"/>
                                                                        </td>
                                                                </tr>
                                                                <tr>
                                                                        <td height="10"/>
                                                                </tr>
                                                        </table>
                                                        <!-- END Grey line spacer -->
                                                        <!-- format and budget -->
                                                        <table border="0" cellpadding="0" cellspacing="0" width="371">
                                                                <tr>
                                                                        <xsl:if test="string-length(GUIDE/ORIGINALFORMAT) > 0">
                                                                                <td>
                                                                                        <div class="centcolheaders">
                                                                                                <strong>format</strong>
                                                                                        </div>
                                                                                        <div class="textmedium">
                                                                                                <xsl:apply-templates select="GUIDE/ORIGINALFORMAT"/>
                                                                                        </div>
                                                                                </td>
                                                                        </xsl:if>
                                                                        <xsl:if test="string-length(GUIDE/BUDGETCOST) > 0 and string-length(GUIDE/ORIGINALFORMAT) > 0">
                                                                                <td background="{$imagesource}furniture/wherebeenbar.gif" width="1"/>
                                                                                <td width="15"/>
                                                                        </xsl:if>
                                                                        <xsl:if test="string-length(GUIDE/BUDGETCOST) > 0">
                                                                                <td>
                                                                                        <div class="centcolheaders">
                                                                                                <strong>budget</strong>
                                                                                        </div>
                                                                                        <div class="textmedium">
                                                                                                <xsl:apply-templates select="GUIDE/BUDGETCOST"/>
                                                                                        </div>
                                                                                </td>
                                                                        </xsl:if>
                                                                </tr>
                                                        </table>
                                                        <!-- END format and budget -->
                                                </xsl:if>
                                                <!-- BEGIN Copyright -->
                                                <xsl:if test="string-length(GUIDE/COPYRIGHT) > 0">
                                                        <table border="0" cellpadding="0" cellspacing="0" width="371">
                                                                <tr>
                                                                        <td height="15"/>
                                                                </tr>
                                                                <tr>
                                                                        <td height="1">
                                                                                <img alt="" class="tiny" height="1" src="{$imagesource}furniture/wherebeenbar.gif" width="371"/>
                                                                        </td>
                                                                </tr>
                                                                <tr>
                                                                        <td height="10"/>
                                                                </tr>
                                                        </table>
                                                        <div class="textxsmall">&#169;&nbsp;<xsl:value-of select="/H2G2/ARTICLE/GUIDE/YEARPRODUCTION"/>&nbsp;<xsl:value-of
                                                                        select="/H2G2/ARTICLE/GUIDE/COPYRIGHT"/></div>
                                                </xsl:if>
                                                <!-- END Copyright -->
                                        </xsl:if>
                                        <!-- Mesage, Comments and alert editor: only include in a film page -->
                                        <xsl:if test="$article_type_group = 'film'">
                                                <xsl:comment>film comments</xsl:comment>
                                                <a name="comments"/>
                                                <xsl:apply-templates mode="discussions_and_comments" select="../ARTICLEFORUM"/>
                                        </xsl:if>
                                        <xsl:if test="$article_type_group = 'credit'">
                                                <!-- back to profile page link-->
                                                <br/>
                                                <xsl:choose>
                                                        <xsl:when test="$ownerisviewer = 1">
                                                                <div class="textmedium"><strong>
                                                                                <a><xsl:attribute name="href">
                                                                                                <xsl:value-of select="concat($root,'U',/H2G2/ARTICLE/ARTICLEINFO/PAGEAUTHOR/EDITOR/USER/USERID)"/>
                                                                                        </xsl:attribute>back to my profile</a>
                                                                        </strong>&nbsp;<img alt="" height="7" src="{$imagesource}furniture/myprofile/arrowdark.gif" width="4"/><br/><br/></div>
                                                        </xsl:when>
                                                        <xsl:otherwise>
                                                                <div class="textmedium"><strong>
                                                                                <a><xsl:attribute name="href">
                                                                                                <xsl:value-of select="concat($root,'U',/H2G2/ARTICLE/ARTICLEINFO/PAGEAUTHOR/EDITOR/USER/USERID)"/>
                                                                                        </xsl:attribute>back to <xsl:choose>
                                                                                                <xsl:when test="string-length(/H2G2/ARTICLE/ARTICLEINFO/PAGEAUTHOR/EDITOR/USER/FIRSTNAMES) &gt; 0">
                                                                                                    <xsl:value-of select="/H2G2/ARTICLE/ARTICLEINFO/PAGEAUTHOR/EDITOR/USER/FIRSTNAMES"/>&nbsp;
                                                                                                    <xsl:value-of select="/H2G2/ARTICLE/ARTICLEINFO/PAGEAUTHOR/EDITOR/USER/LASTNAME"/>
                                                                                                </xsl:when>
                                                                                                <xsl:otherwise>
                                                                                                    <xsl:value-of select="/H2G2/ARTICLE/ARTICLEINFO/PAGEAUTHOR/EDITOR/USER/USERNAME"/>
                                                                                                </xsl:otherwise>
                                                                                        </xsl:choose> 's profile</a>
                                                                        </strong>&nbsp;<img alt="" height="7" src="{$imagesource}furniture/myprofile/arrowdark.gif" width="4"/><br/><br/></div>
                                                        </xsl:otherwise>
                                                </xsl:choose>
                                        </xsl:if>
                                </td>
                                <td><!-- 20px spacer column --></td>
                                <td valign="top">
                                        <!-- BEGIN right side content (useful links, poll, stills, related features, etc) -->
                                        <xsl:choose>
                                                <!-- If page is a credit -->
                                                <xsl:when test="$article_type_group = 'credit'">
                                                        <xsl:call-template name="FILM_APPROVED_CREDITRIGHT"/>
                                                </xsl:when>
                                                <!-- otherwise, assume page is an approved film -->
                                                <xsl:otherwise>
                                                        <xsl:call-template name="FILM_APPROVED_FILMRIGHT"/>
                                                </xsl:otherwise>
                                        </xsl:choose>
                                        <!-- END right side content -->
                                </td>
                        </tr>
                </table>
                <xsl:apply-templates mode="c_articlefootnote" select=".//FOOTNOTE"/>
        </xsl:template>
        <!-- 
     #####################################################################################
	   defines the header (img, title, info) for an approved film 
     ##################################################################################### 
-->
        <xsl:template name="FILM_APPROVED_FILMHEAD">
                <xsl:if test="$DEBUG = 1 or /H2G2/PARAMS/PARAM[NAME = 's_debug']/VALUE = '1'">
                        <div class="debug">
                                <strong>This is an approved film</strong><br/>
                                <br/> Film title = <xsl:value-of select="SUBJECT"/><br/> Director = <xsl:value-of select="GUIDE/DIRECTORSNAME"/><br/> Genre = <xsl:value-of
                                        select="/H2G2/ARTICLE/EXTRAINFO/TYPE/@ID"/><br/> Year = <xsl:value-of select="/H2G2/ARTICLE/GUIDE/YEARPRODUCTION"/><br/> Region = <xsl:value-of
                                        select="EXTRAINFO/REGION"/><br/> Duration = <xsl:value-of select="GUIDE/FILMLENGTH_MINS"/>:<xsl:value-of select="GUIDE/FILMLENGTH_SECS"/><br/>
                                <br/> Page Author = <a href="{root}U{/H2G2/ARTICLE/ARTICLEINFO/PAGEAUTHOR/EDITOR/USER/USERID}">
                                        <xsl:value-of select="/H2G2/ARTICLE/ARTICLEINFO/PAGEAUTHOR/EDITOR/USER/USERNAME"/>
                                </a><br/> Filmmakers notes: <a href="{root}{GUIDE/NOTESID}">
                                        <xsl:value-of select="GUIDE/NOTESID"/>
                                </a><br/>
                                <br/> $test_IsEditor ( <xsl:choose>
                                        <xsl:when test="$test_IsEditor">true</xsl:when>
                                        <xsl:otherwise>false</xsl:otherwise>
                                </xsl:choose>)<br/> $article_type_group = 'film' ( <xsl:choose>
                                        <xsl:when test="$article_type_group = 'film'">true</xsl:when>
                                        <xsl:otherwise>false</xsl:otherwise>
                                </xsl:choose>)<br/> not(/H2G2/ARTICLE/EXTRAINFO/NOTESID[text()]) ( <xsl:choose>
                                        <xsl:when test="not(/H2G2/ARTICLE/EXTRAINFO/NOTESID[text()])">true</xsl:when>
                                        <xsl:otherwise>false</xsl:otherwise>
                                </xsl:choose>) <br/>
                        </div>
                </xsl:if>
                <xsl:variable name="article_header_gif">
                        <xsl:choose>
                                <xsl:when test="$showfakegifs = 'yes'">A4144196_large.jpg</xsl:when>
                                <xsl:otherwise>A<xsl:value-of select="ARTICLEINFO/H2G2ID"/>_large.jpg</xsl:otherwise>
                        </xsl:choose>
                </xsl:variable>
                <style>
			.dramaintroimagebg {background:url(<xsl:value-of select="$imagesource"/><xsl:value-of select="$gif_assets"/><xsl:value-of select="$article_header_gif"/>) top left no-repeat;}
		</style>
                <!-- BEGIN background image for an approved film page -->
                <table border="0" cellpadding="0" cellspacing="0" style="margin-top:10px;" width="635">
                        <tr>
                                <td class="dramaintroimagebg" height="195" valign="top" width="635"/>
                        </tr>
                </table>
                <!-- END background image -->
                <!-- BEGIN 19px Spacer table -->
                <table border="0" cellpadding="0" cellspacing="0" width="635">
                        <tr>
                                <td height="19"/>
                        </tr>
                </table>
                <!-- END 19px Spacer table -->
                <!-- Intro -->
                <table border="0" cellpadding="0" cellspacing="0" width="635">
                        <!-- Spacer row -->
                        <tr>
                                <td>
                                        <img alt="" class="tiny" height="1" src="/f/t.gif" width="371"/>
                                </td>
                                <td>
                                        <img alt="" class="tiny" height="1" src="/f/t.gif" width="10"/>
                                </td>
                                <td>
                                        <img alt="" class="tiny" height="1" src="/f/t.gif" width="10"/>
                                </td>
                                <td>
                                        <img alt="" class="tiny" height="1" src="/f/t.gif" width="244"/>
                                </td>
                        </tr>
                        <tr>
                                <!-- Film Title -->
                                <xsl:variable name="filmTitle">A<xsl:value-of select="ARTICLEINFO/H2G2ID"/>_title</xsl:variable>
                                <td align="right" valign="top">
                                        <img border="0" name="newmovietitle" src="{$imagesource}{$gif_assets}{$filmTitle}.gif">
                                                <xsl:attribute name="alt">
                                                        <xsl:value-of select="/H2G2/ARTICLE/SUBJECT"/>
                                                </xsl:attribute>
                                        </img>
                                        <br/>
                                        <!-- Director's Name: The link to the director's page is built using guideML -->
                                        <span class="textxxlarge">
                                                <strong>
                                                        <xsl:apply-templates select="GUIDE/DIRECTORSNAME"/>
                                                </strong>
                                        </span>
                                        <!-- BEGIN poll average votes -->
                                        <!-- check option list means it has been voted for at least 5 time and isn't a hidden poll -->
                                        <xsl:if test="$votes_cast &gt; 0">
                                                <xsl:apply-templates mode="average_vote" select="/H2G2/POLL-LIST/POLL/OPTION-LIST[../@HIDDEN=0]"/>
                                        </xsl:if>
                                        <!-- END poll average votes -->
                                        <div class="intocredit">
                                                <div class="intodetails">
                                                        <!-- BEGIN crumbtrail -->
                                                        <!-- Category Stamp: Link points to main category page and not complete genre listing -->
                                                        <a class="textdark">
                                                                <xsl:attribute name="href"><xsl:value-of select="$root"/>C<xsl:value-of
                                                                                select="/H2G2/ARTICLE/ARTICLEINFO/CRUMBTRAILS/CRUMBTRAIL[ANCESTOR/NODEID = $byGenrePage]/ANCESTOR[position()=last()]/NODEID"
                                                                        /></xsl:attribute>
                                                                <xsl:value-of select="/H2G2/ARTICLE/ARTICLEINFO/CRUMBTRAILS/CRUMBTRAIL[ANCESTOR/NODEID = $byGenrePage]/ANCESTOR[position()=last()]/NAME"
                                                                />
                                                        </a> | <!-- Date Stamp: Year only -->
                                                        <xsl:apply-templates select="GUIDE/YEARPRODUCTION"/>
                                                        <!-- Location Stamp -->
                                                        <!-- generates the link to category by using a mapping variable defined in HTMLOutput.xsl. The variable looks up string value of GUIDE/REGION that is set by the user and maps the appropriate category ID -->
                                                        <xsl:if test="GUIDE/REGION != ''"> | <xsl:choose>
                                                                        <xsl:when test="GUIDE/REGION-OTHER != '' and GUIDE/REGION = 'non-UK'">
                                                                                <xsl:value-of select="GUIDE/REGION-OTHER"/>
                                                                        </xsl:when>
                                                                        <xsl:when test="GUIDE/REGION = 'non-UK'">
                                                                                <xsl:text>non-UK</xsl:text>
                                                                        </xsl:when>
                                                                        <xsl:otherwise>
                                                                                <a class="textdark">
                                                                                        <xsl:attribute name="href"><xsl:value-of select="$root"/>C<xsl:value-of select="$mapToRegion"/></xsl:attribute>
                                                                                        <xsl:value-of select="GUIDE/REGION"/>
                                                                                </a>
                                                                        </xsl:otherwise>
                                                                </xsl:choose>
                                                        </xsl:if>
                                                        <!-- Language -->
                                                        <xsl:if test="GUIDE/LANGUAGE != '' and GUIDE/LANGUAGE != 'English'"> | <xsl:choose>
                                                                        <xsl:when test="GUIDE/LANGUAGE-OTHER != '' and GUIDE/LANGUAGE = 'other'">
                                                                                <xsl:value-of select="GUIDE/LANGUAGE-OTHER"/>
                                                                        </xsl:when>
                                                                        <xsl:otherwise>
                                                                                <xsl:value-of select="GUIDE/LANGUAGE"/>
                                                                        </xsl:otherwise>
                                                                </xsl:choose>
                                                        </xsl:if> | <!-- Minute Stamp -->
                                                        <xsl:choose>
                                                                <xsl:when test="GUIDE/IS_SERIES = 'on'">
                                                                        <xsl:value-of select="GUIDE/SERIES_LENGTH"/>
                                                                </xsl:when>
                                                                <xsl:otherwise>
                                                                        <a class="textdark">
                                                                                <xsl:attribute name="href"><xsl:value-of select="$root"/>C<xsl:value-of
                                                                                                select="/H2G2/ARTICLE/ARTICLEINFO/CRUMBTRAILS/CRUMBTRAIL[ANCESTOR/NODEID = $byLengthPage]/ANCESTOR[position()=last()]/NODEID"
                                                                                        /></xsl:attribute>
                                                                                <xsl:choose>
                                                                                        <xsl:when test="GUIDE/FILMLENGTH_MINS > 0">
                                                                                                <xsl:choose>
                                                                                                    <xsl:when test="GUIDE/FILMLENGTH_SECS > 30">
                                                                                                    <xsl:value-of select="GUIDE/FILMLENGTH_MINS + 1"/>
                                                                                                    </xsl:when>
                                                                                                    <xsl:otherwise>
                                                                                                    <xsl:value-of select="GUIDE/FILMLENGTH_MINS"/>
                                                                                                    </xsl:otherwise>
                                                                                                </xsl:choose> min </xsl:when>
                                                                                        <xsl:otherwise>
                                                                                                <xsl:value-of select="GUIDE/FILMLENGTH_SECS"/> secs </xsl:otherwise>
                                                                                </xsl:choose>
                                                                        </a>
                                                                </xsl:otherwise>
                                                        </xsl:choose>
                                                        <!-- END crumbtrail -->
                                                </div>
                                                <!-- Film description and published date stamp --> Published <xsl:value-of select="ARTICLEINFO/DATECREATED/DATE/@DAY"/>&nbsp;<xsl:value-of
                                                        select="substring(ARTICLEINFO/DATECREATED/DATE/@MONTHNAME, 1,3)"/>&nbsp;<xsl:value-of
                                                        select="substring(ARTICLEINFO/DATECREATED/DATE/@YEAR, 3,4)"/><br/>
                                                <xsl:apply-templates select="GUIDE/DESCRIPTION"/>
                                        </div>
                                        <!-- BEGIN Send to a friend -->
                                        <div class="textmedium">
                                                <strong>
                                                        <img alt="" class="tiny" height="5" src="/f/t.gif" width="1"/>
                                                        <a href="/cgi-bin/navigation/mailto.pl?GO=1" onClick="popmailwin('/cgi-bin/navigation/mailto.pl?GO=1','Mailer')" target="Mailer"><img
                                                                        alt="email icon" height="11" src="{$imagesource}furniture/emailicon.gif" width="21"/>send to a friend</a>
                                                </strong>
                                                <img alt="" border="0" height="7" src="{$imagesource}furniture/linkgraphic.gif" width="10"/>
                                        </div>
                                        <!-- END Send to a friend -->
                                </td>
                                <td><!-- 10px spacer column --></td>
                                <td class="introdivider"><!-- 10px spacer column -->&nbsp;</td>
                                <xsl:choose>
                                        <xsl:when test="GUIDE/IS_SERIES = 'on'">
                                                <td class="series-rhn" valign="top"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                                <td valign="top">
                                                        <!-- BEGIN Show Video -->
                                                        <!-- Variable to establish wether to show video by dates -->
                                                        <xsl:variable name="ShowVideo">
                                                                <xsl:choose>
                                                                        <xsl:when test="string-length(GUIDE/AVAIL_DAY) > 0">
                                                                                <xsl:call-template name="checkDateOK">
                                                                                        <xsl:with-param name="checkday" select="GUIDE/AVAIL_DAY"/>
                                                                                        <xsl:with-param name="checkmonth" select="GUIDE/AVAIL_MONTH"/>
                                                                                        <xsl:with-param name="checkyear" select="GUIDE/AVAIL_YEAR"/>
                                                                                </xsl:call-template>
                                                                        </xsl:when>
                                                                        <xsl:otherwise>
                                                                                <xsl:call-template name="checkDateOK">
                                                                                        <xsl:with-param name="checkday" select="ARTICLEINFO/DATECREATED/DATE/@DAY"/>
                                                                                        <xsl:with-param name="checkmonth" select="ARTICLEINFO/DATECREATED/DATE/@MONTH"/>
                                                                                        <xsl:with-param name="checkyear" select="ARTICLEINFO/DATECREATED/DATE/@YEAR + 5"/>
                                                                                </xsl:call-template>
                                                                        </xsl:otherwise>
                                                                </xsl:choose>
                                                        </xsl:variable>
                                                        <!-- if film is out of date, show expired text -->
                                                        <xsl:if test="$ShowVideo = 'no'">
                                                            <h3>The license to this film has expired and can no longer be viewed on film network</h3>
                                                        </xsl:if>
                                                        <xsl:if test="$ShowVideo='yes'">
                                                                <xsl:variable name="mediaselectorlink">?size=<xsl:value-of select="GUIDE/PLAYER_SIZE"/>&amp;bgc=<xsl:choose>
                                                                                <xsl:when test="GUIDE/SUBTITLED = 'on'">FF3300</xsl:when>
                                                                                <xsl:otherwise>C0C0C0</xsl:otherwise>
                                                                        </xsl:choose>
                                                                        <xsl:if test="GUIDE/STREAMING_NARROW = 'on' and GUIDE/WINPLAYER = 'on'">&amp;nbwm=1</xsl:if>
                                                                        <xsl:if test="GUIDE/STREAMING_BROADBAND = 'on' and GUIDE/WINPLAYER = 'on'">&amp;bbwm=1</xsl:if>
                                                                        <xsl:if test="GUIDE/STREAMING_NARROW = 'on' and GUIDE/REALPLAYER = 'on'">&amp;nbram=1</xsl:if>
                                                                        <xsl:if test="GUIDE/STREAMING_BROADBAND = 'on' and GUIDE/REALPLAYER = 'on'">&amp;bbram=1</xsl:if>
                                                                        <xsl:if test="GUIDE/SUBTITLED = 'on'">&amp;st=1</xsl:if>
                                                                </xsl:variable>
                                                                <xsl:variable name="multimedialink">
                                                                        <xsl:choose>
                                                                                <xsl:when test="string-length(GUIDE/ADDITIONAL_WARNING) > 0 or GUIDE/CONTENT_FLASHINGIMAGES= 'on' ">
                                                                                                http://www.bbc.co.uk/filmnetwork/mediaselector_interstitial.shtml<xsl:value-of
                                                                                                select="$mediaselectorlink"/>&amp;clipname=A<xsl:value-of select="ARTICLEINFO/H2G2ID"/><xsl:if
                                                                                                test="GUIDE/CONTENT_FLASHINGIMAGES= 'on'">&amp;flashingimages=yes</xsl:if><xsl:if
                                                                                                test="string-length(GUIDE/ADDITIONAL_WARNING) > 0">&amp;warning=<xsl:value-of
                                                                                                    select="GUIDE/ADDITIONAL_WARNING"/></xsl:if>
                                                                                </xsl:when>
                                                                                <xsl:otherwise>
                                                                                        <xsl:text>http://www.bbc.co.uk/mediaselector/check/filmnetwork/media/shorts/A</xsl:text>
                                                                                        <xsl:value-of select="ARTICLEINFO/H2G2ID"/>
                                                                                        <xsl:value-of select="$mediaselectorlink"/>
                                                                                </xsl:otherwise>
                                                                        </xsl:choose>
                                                                </xsl:variable>
                                                                <!-- BEGIN play now -->
                                                                <a href="{$multimedialink}" onclick="window.open(this.href,this.target,'status=no,scrollbars=yes,resizable=yes,width=384,height=283')"
                                                                        onmouseout="swapImage('dramawatch', '{$imagesource}furniture/drama/playnow.gif')"
                                                                        onmouseover="swapImage('dramawatch', '{$imagesource}furniture/drama/playnow_ro2.gif')" target="avaccesswin">
                                                                        <img alt="PLAY NOW" height="31" name="dramawatch" src="{$imagesource}furniture/drama/playnow.gif" width="121"/>
                                                                </a>
                                                                <!-- Text pointing to media players -->
                                                                <table border="0" cellpadding="0" cellspacing="0" width="244">
                                                                        <tr>
                                                                                <td width="39"/>
                                                                                <td>
                                                                                        <div class="textxsmall">Requires <strong>
                                                                                                    <a href="http://www.bbc.co.uk/webwise/categories/plug/winmedia/winmedia.shtml?intro"
                                                                                                    onClick="popwin(this.href, this.target, 420, 400, 'scroll', 'resize'); return false;"
                                                                                                    target="webwise">windows media player</a>
                                                                                                </strong>&nbsp;or<br/><strong>
                                                                                                    <a href="http://www.bbc.co.uk/webwise/categories/plug/real/real.shtml?intro"
                                                                                                    onClick="popwin(this.href, this.target, 420, 400, 'scroll', 'resize'); return false;"
                                                                                                    target="webwise">real player</a>
                                                                                                </strong>.</div>
                                                                                </td>
                                                                        </tr>
                                                                </table>
                                                                <!-- END play now -->
                                                        </xsl:if>
                                                        <!--BEGIN hi-res now -->
                                                        <xsl:if test="GUIDE/HI_RES_DOWNLOAD = 'on'">
                                                                <a href="{$root}downloads" onmouseout="swapImage('hiresdownload', '{$imagesource}furniture/drama/hi_res_download.gif')"
                                                                        onmouseover="swapImage('hiresdownload', '{$imagesource}furniture/drama/hi_res_download_ro2.gif')">
                                                                        <img alt="HI-RES DOWNLOAD" height="31" name="hiresdownload" src="{$imagesource}furniture/drama/hi_res_download.gif" width="187"
                                                                        />
                                                                </a>
                                                                <table border="0" cellpadding="0" cellspacing="0" width="244">
                                                                        <tr>
                                                                                <td width="39"/>
                                                                                <td>
                                                                                        <div class="textxsmall"><strong>
                                                                                                    <a href="{$root}downloads">About hi-res download</a>
                                                                                                </strong>.</div>
                                                                                </td>
                                                                        </tr>
                                                                </table>
                                                        </xsl:if>
                                                        <!-- END hi-res now -->
                                                        <xsl:if test="$test_IsEditor"> </xsl:if>
                                                        <!-- BEGIN content advise -->
                                                        <xsl:if test="string-length(GUIDE/STANDARD_WARNING) > 0">
                                                                <img alt="" class="tiny" height="10" src="/f/t.gif" width="1"/>
                                                                <table border="0" cellpadding="0" cellspacing="0" width="244">
                                                                        <tr>
                                                                                <td width="39"/>
                                                                                <td>
                                                                                        <img alt="" height="14" src="{$imagesource}furniture/drama/contentadvice.gif" width="106"/>
                                                                                        <br/>
                                                                                        <img alt="" class="tiny" height="5" src="/f/t.gif" width="1"/>
                                                                                        <div class="textxsmall">
                                                                                                <xsl:value-of select="GUIDE/STANDARD_WARNING"/>
                                                                                        </div>
                                                                                </td>
                                                                        </tr>
                                                                </table>
                                                        </xsl:if>
                                                        <!-- END content advise -->
                                                        <!-- BEGIN subtitle text -->
                                                        <xsl:if test="GUIDE/SUBTITLED = 'on'">
                                                                <img alt="" class="tiny" height="10" src="/f/t.gif" width="1"/>
                                                                <table border="0" cellpadding="0" cellspacing="0" width="244">
                                                                        <tr>
                                                                                <td width="39"/>
                                                                                <td>
                                                                                        <img alt="" height="15" src="{$imagesource}furniture/drama/subtitlesavailable.gif " width="140"/>
                                                                                        <br/>
                                                                                        <img alt="" class="tiny" height="5" src="/f/t.gif" width="1"/>
                                                                                        <div class="textxsmall">Click <strong>'subtitles on'</strong> in the Media Player. Watch more <a
                                                                                                    href="/dna/filmnetwork/C55747">
                                                                                                    <strong>subtitled shorts here</strong>
                                                                                                </a></div>
                                                                                </td>
                                                                        </tr>
                                                                </table>
                                                        </xsl:if>
                                                        <!-- END subtitle text -->
                                                </td>
                                        </xsl:otherwise>
                                </xsl:choose>
                        </tr>
                </table>
                <!-- END Intro -->
        </xsl:template>
        <!-- 
     #####################################################################################
	   defines the header (img, title, info) for a credit
     ##################################################################################### 
-->
        <xsl:template name="FILM_APPROVED_CREDITHEAD">
                <xsl:if test="$DEBUG = 1 or /H2G2/PARAMS/PARAM[NAME = 's_debug']/VALUE = '1'">
                        <div class="debug">
                                <strong>This is a film credit</strong><br/>
                                <br/> Film title = <xsl:value-of select="SUBJECT"/><br/> Director = <xsl:value-of select="GUIDE/DIRECTORSNAME"/><br/> Genre = <xsl:value-of
                                        select="/H2G2/ARTICLE/EXTRAINFO/TYPE/@ID"/><br/> Year = <xsl:value-of select="/H2G2/ARTICLE/GUIDE/YEARPRODUCTION"/><br/> Region = <xsl:value-of
                                        select="EXTRAINFO/REGION"/><br/> Duration = <xsl:value-of select="GUIDE/FILMLENGTH_MINS"/>:<xsl:value-of select="GUIDE/FILMLENGTH_SECS"/><br/>
                                <br/> Page Author = <a href="{root}U{/H2G2/ARTICLE/ARTICLEINFO/PAGEAUTHOR/EDITOR/USER/USERID}">
                                        <xsl:value-of select="/H2G2/ARTICLE/ARTICLEINFO/PAGEAUTHOR/EDITOR/USER/USERNAME"/>
                                </a><br/>
                        </div>
                </xsl:if>
                <!-- crumbtrail -->
                <div class="crumbtop">
                        <span class="textmedium"><a href="{root}U{/H2G2/ARTICLE/ARTICLEINFO/PAGEAUTHOR/EDITOR/USER/USERID}">
                                        <xsl:value-of select="/H2G2/ARTICLE/ARTICLEINFO/PAGEAUTHOR/EDITOR/USER/USERNAME"/>
                                </a> |</span>
                        <span class="textxlarge">film credit</span>
                </div>
                <!-- intro table -->
                <table border="0" cellpadding="0" cellspacing="0" width="635">
                        <tr>
                                <td>
                                        <img alt="" class="tiny" height="1" src="f/t.gif" width="371"/>
                                </td>
                                <td>
                                        <img alt="" class="tiny" height="1" src="f/t.gif" width="20"/>
                                </td>
                                <td>
                                        <img alt="" class="tiny" height="1" src="f/t.gif" width="244"/>
                                </td>
                        </tr>
                        <tr>
                                <td class="topbg creditDetails" height="97" valign="top">
                                        <div class="creditFilm">
                                                <xsl:value-of select="/H2G2/ARTICLE/SUBJECT"/>
                                        </div>
                                        <div class="creditDirector">
                                                <xsl:apply-templates select="GUIDE/DIRECTORSNAME"/>
                                        </div>
                                        <div class="creditCrumb">
                                                <!-- genre -->
                                                <xsl:call-template name="GENRE_TITLE"/> | <!-- minutes or seconds -->
                                                <xsl:choose>
                                                        <xsl:when test="GUIDE/FILMLENGTH_MINS > 0">
                                                                <xsl:call-template name="LINK_MINUTES">
                                                                        <xsl:with-param name="minutes">
                                                                                <xsl:value-of select="GUIDE/FILMLENGTH_MINS"/>
                                                                        </xsl:with-param>
                                                                        <xsl:with-param name="class">textdark</xsl:with-param>
                                                                </xsl:call-template> | </xsl:when>
                                                        <xsl:otherwise>
                                                                <a class="textdark" href="{$root}C{$length2}"><xsl:value-of select="GUIDE/FILMLENGTH_SECS"/> sec</a> | </xsl:otherwise>
                                                </xsl:choose>
                                                <!-- year -->
                                                <xsl:value-of select="GUIDE/YEARPRODUCTION"/> | <!-- place -->
                                                <xsl:call-template name="LINK_REGION">
                                                        <xsl:with-param name="region">
                                                                <xsl:value-of select="GUIDE/REGION"/>
                                                        </xsl:with-param>
                                                        <xsl:with-param name="class">textdark</xsl:with-param>
                                                </xsl:call-template></div>
                                        <div class="creditParticipation">participation: <xsl:value-of select="GUIDE/YOUR_ROLE"/>
                                        </div>
                                        <div class="creditDescription">
                                                <xsl:value-of select="GUIDE/DESCRIPTION"/>
                                        </div>
                                </td>
                                <td class="verticaldivider" valign="top">
                                        <img alt="" height="30" src="{$imagesource}furniture/myprofile/verticalcap.gif" width="20"/>
                                </td>
                                <td class="topbg" id="creditIcon" valign="top">
                                        <img alt="" height="76" src="{$imagesource}furniture/icon_credit.gif" width="76"/>
                                        <xsl:if test="$test_IsEditor or $ownerisviewer = 1">
                                                <div id="editCredit"><a
                                                                href="{root}TypedArticle?aedit=new&amp;type={$current_article_type}&amp;h2g2id={/H2G2/ARTICLE/ARTICLEINFO/H2G2ID}&amp;s_editcredit=1"
                                                                >edit film credit</a>&nbsp;<img alt="" height="7" src="{$imagesource}furniture/myprofile/arrow.gif" width="4"/></div>
                                        </xsl:if>
                                </td>
                        </tr>
                </table>
                <img alt="" height="27" src="{$imagesource}furniture/writemessage/topboxangle.gif" width="635"/>
                <br/>
        </xsl:template>
        <!-- 
     #####################################################################################
	   defines the right side of content (related features, stills gallery, etc) for a film
     ##################################################################################### 
-->
        <xsl:template name="FILM_APPROVED_FILMRIGHT">
                <!-- poll -->
                <xsl:apply-templates mode="c_articlepage" select="/H2G2/POLL-LIST"/>
                <!-- check there is something for this right hand column -->
                <xsl:if test="GUIDE/STILLS_GALLERY = 'on' or string-length(GUIDE/SHORT1_TITLE) > 0 or string-length(GUIDE/USEFULLINKS1) > 0 or string-length(GUIDE/FUNDINGDETAILS) > 0">
                        <!-- Spacer -->
                        <table border="0" cellpadding="0" cellspacing="0" width="244">
                                <tr>
                                        <td height="10"/>
                                </tr>
                        </table>
                        <!-- Stills Gallery -->
                        <xsl:choose>
                                <xsl:when test="GUIDE/STILLS_GALLERY = 'on'">
                                        <table border="0" cellpadding="0" cellspacing="0" width="244">
                                                <tr>
                                                        <td class="rightcolstills" width="244">
                                                                <!--  class="rightcolbgtop" -->
                                                                <div class="textlightmedium"><!-- NOTE: called again below --><strong>stills gallery</strong>&nbsp;</div>
                                                        </td>
                                                </tr>
                                        </table>
                                </xsl:when>
                                <xsl:otherwise>
                                        <!-- make space above text -->
                                        <table border="0" cellpadding="0" cellspacing="0" width="244">
                                                <tr>
                                                        <td class="rightcolstills" height="8" width="244"> </td>
                                                </tr>
                                        </table>
                                </xsl:otherwise>
                        </xsl:choose>
                        <!-- END Stills Gallery -->
                </xsl:if>
                <div class="rightcolboxspecial">
                        <xsl:if test="GUIDE/STILLS_GALLERY = 'on'">
                                <!-- view gallery -->
                                <table border="0" cellpadding="0" cellspacing="0" width="196">
                                        <tr>
                                                <td valign="top" width="41">
                                                        <img alt="" height="30" src="{$imagesource}shorts/A{ARTICLEINFO/H2G2ID}_small.jpg" width="31"/>
                                                </td>
                                                <td valign="top">
                                                        <div class="textlightmedium">
                                                                <strong>
                                                                        <a class="rightcol" href="{$site_server}/filmnetwork/gallery/index.shtml?gallery=A{ARTICLEINFO/H2G2ID}"
                                                                                onclick="popupwindow(this.href,this.target,'width=398,height=346,resizable=yes,scrollbars=no');return false;"
                                                                                target="player" title="view gallery">view<br/>gallery</a>
                                                                        <img alt="" height="9" src="{$imagesource}furniture/drama/rightarrow.gif" width="9"/>
                                                                </strong>
                                                        </div>
                                                </td>
                                        </tr>
                                </table>
                                <!-- end view gallery -->
                                <!-- dashed underline -->
                                <table border="0" cellpadding="0" cellspacing="0" width="196">
                                        <tr>
                                                <td height="13" valign="middle" width="196">
                                                        <img alt="" height="1" src="{$imagesource}furniture/drama/rightcoldashunderline.gif" width="196"/>
                                                </td>
                                        </tr>
                                </table>
                                <!-- end dashed underline -->
                        </xsl:if>
                        <xsl:if test="string-length(GUIDE/SHORT1_TITLE) > 0">
                                <!-- other films by this director -->
                                <div class="textlightmedium">
                                        <strong>other films by this director</strong>
                                </div>
                                <table border="0" cellpadding="0" cellspacing="0" width="196">
                                        <tr>
                                                <td height="6" valign="top" width="36">
                                                        <img alt="" class="tiny" height="6" src="/f/t.gif" width="36"/>
                                                </td>
                                                <td valign="top" width="160">
                                                        <img alt="" class="tiny" height="6" src="/f/t.gif" width="160"/>
                                                </td>
                                        </tr>
                                        <tr>
                                                <td valign="top" width="36">
                                                        <img alt="{GUIDE/SHORT2_TITLE}" height="30" src="{$imagesource}shorts/{GUIDE/SHORT1_ANUMBER}_small.jpg" width="31"/>
                                                </td>
                                                <td valign="top">
                                                        <div class="textlightsmall">
                                                                <strong>
                                                                        <a class="rightcol" href="{$root}{GUIDE/SHORT1_ANUMBER}" title="{GUIDE/SHORT1_TITLE}">
                                                                                <xsl:value-of select="GUIDE/SHORT1_TITLE"/>
                                                                        </a>
                                                                </strong>
                                                                <br/>
                                                                <xsl:value-of select="GUIDE/SHORT1_GENRE"/>
                                                        </div>
                                                </td>
                                        </tr>
                                        <xsl:if test="string-length(GUIDE/SHORT2_TITLE) > 0">
                                                <tr>
                                                        <td height="10" valign="top" width="36">
                                                                <img alt="" class="tiny" height="10" src="/f/t.gif" width="1"/>
                                                        </td>
                                                        <td valign="top" width="160">
                                                                <img alt="" class="tiny" height="1" src="/f/t.gif" width="160"/>
                                                        </td>
                                                </tr>
                                                <tr>
                                                        <td valign="top" width="36">
                                                                <img alt="{GUIDE/SHORT2_TITLE}" height="30" src="{$imagesource}shorts/{GUIDE/SHORT2_ANUMBER}_small.jpg" width="31"/>
                                                        </td>
                                                        <td valign="top">
                                                                <div class="textlightsmall">
                                                                        <strong>
                                                                                <a class="rightcol" href="{$root}{GUIDE/SHORT2_ANUMBER}" title="{GUIDE/SHORT2_TITLE}">
                                                                                        <xsl:value-of select="GUIDE/SHORT2_TITLE"/>
                                                                                </a>
                                                                        </strong>
                                                                        <br/>
                                                                        <xsl:value-of select="GUIDE/SHORT2_GENRE"/>
                                                                </div>
                                                        </td>
                                                </tr>
                                        </xsl:if>
                                        <xsl:if test="string-length(GUIDE/SHORT3_TITLE) > 0">
                                                <tr>
                                                        <td height="10" valign="top" width="36">
                                                                <img alt="" class="tiny" height="10" src="/f/t.gif" width="1"/>
                                                        </td>
                                                        <td valign="top" width="160">
                                                                <img alt="" class="tiny" height="1" src="/f/t.gif" width="160"/>
                                                        </td>
                                                </tr>
                                                <tr>
                                                        <td valign="top" width="36">
                                                                <img alt="{GUIDE/SHORT2_TITLE}" height="30" src="{$imagesource}shorts/{GUIDE/SHORT3_ANUMBER}_small.jpg" width="31"/>
                                                        </td>
                                                        <td valign="top">
                                                                <div class="textlightsmall">
                                                                        <strong>
                                                                                <a class="rightcol" href="{$root}{GUIDE/SHORT3_ANUMBER}" title="{GUIDE/SHORT3_TITLE}">
                                                                                        <xsl:value-of select="GUIDE/SHORT3_TITLE"/>
                                                                                </a>
                                                                        </strong>
                                                                        <br/>
                                                                        <xsl:value-of select="GUIDE/SHORT3_GENRE"/>
                                                                </div>
                                                        </td>
                                                </tr>
                                        </xsl:if>
                                </table>
                                <!-- END other films by this director -->
                                <!-- dashed underline -->
                                <table border="0" cellpadding="0" cellspacing="0" width="196">
                                        <tr>
                                                <td height="13" valign="middle" width="196">
                                                        <img alt="" height="1" src="{$imagesource}furniture/drama/rightcoldashunderline.gif" width="196"/>
                                                </td>
                                        </tr>
                                </table>
                                <!-- end dashed underline -->
                        </xsl:if>
                        <xsl:if test="string-length(GUIDE/USEFULLINKS1) > 0">
                                <!-- useful links -->
                                <div class="textlightmedium">
                                        <strong>useful links</strong>
                                </div>
                                <div class="textbrightsmall">
                                        <ul class="rightcollistround">
                                                <li>
                                                        <a class="rightcol" target="_new">
                                                                <xsl:attribute name="href">
                                                                        <xsl:choose>
                                                                                <xsl:when
                                                                                        test="starts-with(GUIDE/USEFULLINKS1, 'http://') and not(starts-with(GUIDE/USEFULLINKS1, 'http://news.bbc.co.uk')or starts-with(GUIDE/USEFULLINKS1, 'http://www.bbc.co.uk'))"
                                                                                                >http://www.bbc.co.uk/go/dna/filmnetwork/ext/ide1/-/<xsl:value-of select="GUIDE/USEFULLINKS1"/></xsl:when>
                                                                                <xsl:otherwise>
                                                                                        <xsl:value-of select="GUIDE/USEFULLINKS1"/>
                                                                                </xsl:otherwise>
                                                                        </xsl:choose>
                                                                </xsl:attribute>
                                                                <xsl:choose>
                                                                        <xsl:when test="string-length(GUIDE/USEFULLINKS1_TEXT) > 0">
                                                                                <xsl:attribute name="title">
                                                                                        <xsl:value-of select="GUIDE/USEFULLINKS1_TEXT"/>
                                                                                </xsl:attribute>
                                                                                <xsl:value-of select="GUIDE/USEFULLINKS1_TEXT"/>
                                                                        </xsl:when>
                                                                        <xsl:otherwise>
                                                                                <xsl:attribute name="title">
                                                                                        <xsl:value-of select="GUIDE/USEFULLINKS1"/>
                                                                                </xsl:attribute>
                                                                                <xsl:value-of select="GUIDE/USEFULLINKS1"/>
                                                                        </xsl:otherwise>
                                                                </xsl:choose>
                                                        </a>
                                                </li>
                                                <xsl:if test="string-length(GUIDE/USEFULLINKS2) > 0">
                                                        <li>
                                                                <a class="rightcol" target="_new">
                                                                        <xsl:attribute name="href">
                                                                                <xsl:choose>
                                                                                        <xsl:when
                                                                                                test="starts-with(GUIDE/USEFULLINKS2, 'http://') and not(starts-with(GUIDE/USEFULLINKS2, 'http://news.bbc.co.uk')or starts-with(GUIDE/USEFULLINKS2, 'http://www.bbc.co.uk'))"
                                                                                                    >http://www.bbc.co.uk/go/dna/filmnetwork/ext/ide1/-/<xsl:value-of select="GUIDE/USEFULLINKS2"/></xsl:when>
                                                                                        <xsl:otherwise>
                                                                                                <xsl:value-of select="GUIDE/USEFULLINKS2"/>
                                                                                        </xsl:otherwise>
                                                                                </xsl:choose>
                                                                        </xsl:attribute>
                                                                        <xsl:choose>
                                                                                <xsl:when test="string-length(GUIDE/USEFULLINKS2_TEXT) > 0">
                                                                                        <xsl:attribute name="title">
                                                                                                <xsl:value-of select="GUIDE/USEFULLINKS2_TEXT"/>
                                                                                        </xsl:attribute>
                                                                                        <xsl:value-of select="GUIDE/USEFULLINKS2_TEXT"/>
                                                                                </xsl:when>
                                                                                <xsl:otherwise>
                                                                                        <xsl:attribute name="title">
                                                                                                <xsl:value-of select="GUIDE/USEFULLINKS2"/>
                                                                                        </xsl:attribute>
                                                                                        <xsl:value-of select="GUIDE/USEFULLINKS2"/>
                                                                                </xsl:otherwise>
                                                                        </xsl:choose>
                                                                </a>
                                                        </li>
                                                </xsl:if>
                                                <xsl:if test="string-length(GUIDE/USEFULLINKS3) > 0">
                                                        <li>
                                                                <a class="rightcol" target="_new">
                                                                        <xsl:attribute name="href">
                                                                                <xsl:choose>
                                                                                        <xsl:when
                                                                                                test="starts-with(GUIDE/USEFULLINKS3, 'http://') and not(starts-with(GUIDE/USEFULLINKS3, 'http://news.bbc.co.uk')or starts-with(GUIDE/USEFULLINKS3, 'http://www.bbc.co.uk'))"
                                                                                                    >http://www.bbc.co.uk/go/dna/filmnetwork/ext/ide1/-/<xsl:value-of select="GUIDE/USEFULLINKS3"/></xsl:when>
                                                                                        <xsl:otherwise>
                                                                                                <xsl:value-of select="GUIDE/USEFULLINKS3"/>
                                                                                        </xsl:otherwise>
                                                                                </xsl:choose>
                                                                        </xsl:attribute>
                                                                        <xsl:choose>
                                                                                <xsl:when test="string-length(GUIDE/USEFULLINKS3_TEXT) > 0">
                                                                                        <xsl:attribute name="title">
                                                                                                <xsl:value-of select="GUIDE/USEFULLINKS3_TEXT"/>
                                                                                        </xsl:attribute>
                                                                                        <xsl:value-of select="GUIDE/USEFULLINKS3_TEXT"/>
                                                                                </xsl:when>
                                                                                <xsl:otherwise>
                                                                                        <xsl:attribute name="title">
                                                                                                <xsl:value-of select="GUIDE/USEFULLINKS3"/>
                                                                                        </xsl:attribute>
                                                                                        <xsl:value-of select="GUIDE/USEFULLINKS3"/>
                                                                                </xsl:otherwise>
                                                                        </xsl:choose>
                                                                </a>
                                                        </li>
                                                </xsl:if>
                                                <xsl:if test="string-length(GUIDE/USEFULLINKS4) > 0">
                                                        <li>
                                                                <a class="rightcol" target="_new">
                                                                        <xsl:attribute name="href">
                                                                                <xsl:choose>
                                                                                        <xsl:when
                                                                                                test="starts-with(GUIDE/USEFULLINKS4, 'http://') and not(starts-with(GUIDE/USEFULLINKS4, 'http://news.bbc.co.uk')or starts-with(GUIDE/USEFULLINKS4, 'http://www.bbc.co.uk'))"
                                                                                                    >http://www.bbc.co.uk/go/dna/filmnetwork/ext/ide1/-/<xsl:value-of select="GUIDE/USEFULLINKS4"/></xsl:when>
                                                                                        <xsl:otherwise>
                                                                                                <xsl:value-of select="GUIDE/USEFULLINKS4"/>
                                                                                        </xsl:otherwise>
                                                                                </xsl:choose>
                                                                        </xsl:attribute>
                                                                        <xsl:choose>
                                                                                <xsl:when test="string-length(GUIDE/USEFULLINKS4_TEXT) > 0">
                                                                                        <xsl:attribute name="title">
                                                                                                <xsl:value-of select="GUIDE/USEFULLINKS4_TEXT"/>
                                                                                        </xsl:attribute>
                                                                                        <xsl:value-of select="GUIDE/USEFULLINKS4_TEXT"/>
                                                                                </xsl:when>
                                                                                <xsl:otherwise>
                                                                                        <xsl:attribute name="title">
                                                                                                <xsl:value-of select="GUIDE/USEFULLINKS4"/>
                                                                                        </xsl:attribute>
                                                                                        <xsl:value-of select="GUIDE/USEFULLINKS4"/>
                                                                                </xsl:otherwise>
                                                                        </xsl:choose>
                                                                </a>
                                                        </li>
                                                </xsl:if>
                                                <xsl:if test="string-length(GUIDE/USEFULLINKS5) > 0">
                                                        <li>
                                                                <a class="rightcol" target="_new">
                                                                        <xsl:attribute name="href">
                                                                                <xsl:choose>
                                                                                        <xsl:when
                                                                                                test="starts-with(GUIDE/USEFULLINKS5, 'http://') and not(starts-with(GUIDE/USEFULLINKS5, 'http://news.bbc.co.uk')or starts-with(GUIDE/USEFULLINKS5, 'http://www.bbc.co.uk'))"
                                                                                                    >http://www.bbc.co.uk/go/dna/filmnetwork/ext/ide1/-/<xsl:value-of select="GUIDE/USEFULLINKS5"/></xsl:when>
                                                                                        <xsl:otherwise>
                                                                                                <xsl:value-of select="GUIDE/USEFULLINKS5"/>
                                                                                        </xsl:otherwise>
                                                                                </xsl:choose>
                                                                        </xsl:attribute>
                                                                        <xsl:choose>
                                                                                <xsl:when test="string-length(GUIDE/USEFULLINKS5_TEXT) > 0">
                                                                                        <xsl:attribute name="title">
                                                                                                <xsl:value-of select="GUIDE/USEFULLINKS5_TEXT"/>
                                                                                        </xsl:attribute>
                                                                                        <xsl:value-of select="GUIDE/USEFULLINKS5_TEXT"/>
                                                                                </xsl:when>
                                                                                <xsl:otherwise>
                                                                                        <xsl:attribute name="title">
                                                                                                <xsl:value-of select="GUIDE/USEFULLINKS5"/>
                                                                                        </xsl:attribute>
                                                                                        <xsl:value-of select="GUIDE/USEFULLINKS5"/>
                                                                                </xsl:otherwise>
                                                                        </xsl:choose>
                                                                </a>
                                                        </li>
                                                </xsl:if>
                                                <xsl:if test="string-length(GUIDE/USEFULLINKS6) > 0">
                                                        <li>
                                                                <a class="rightcol" target="_new">
                                                                        <xsl:attribute name="href">
                                                                                <xsl:choose>
                                                                                        <xsl:when
                                                                                                test="starts-with(GUIDE/USEFULLINKS6, 'http://') and not(starts-with(GUIDE/USEFULLINKS6, 'http://news.bbc.co.uk')or starts-with(GUIDE/USEFULLINKS6, 'http://www.bbc.co.uk'))"
                                                                                                    >http://www.bbc.co.uk/go/dna/filmnetwork/ext/ide1/-/<xsl:value-of select="GUIDE/USEFULLINKS6"/></xsl:when>
                                                                                        <xsl:otherwise>
                                                                                                <xsl:value-of select="GUIDE/USEFULLINKS6"/>
                                                                                        </xsl:otherwise>
                                                                                </xsl:choose>
                                                                        </xsl:attribute>
                                                                        <xsl:choose>
                                                                                <xsl:when test="string-length(GUIDE/USEFULLINKS6_TEXT) > 0">
                                                                                        <xsl:attribute name="title">
                                                                                                <xsl:value-of select="GUIDE/USEFULLINKS6_TEXT"/>
                                                                                        </xsl:attribute>
                                                                                        <xsl:value-of select="GUIDE/USEFULLINKS6_TEXT"/>
                                                                                </xsl:when>
                                                                                <xsl:otherwise>
                                                                                        <xsl:attribute name="title">
                                                                                                <xsl:value-of select="GUIDE/USEFULLINKS6"/>
                                                                                        </xsl:attribute>
                                                                                        <xsl:value-of select="GUIDE/USEFULLINKS6"/>
                                                                                </xsl:otherwise>
                                                                        </xsl:choose>
                                                                </a>
                                                        </li>
                                                </xsl:if>
                                        </ul>
                                </div>
                                <!-- END useful links -->
                                <!-- dashed underline -->
                                <table border="0" cellpadding="0" cellspacing="0" width="196">
                                        <tr>
                                                <td height="13" valign="middle" width="196">
                                                        <img alt="" height="1" src="{$imagesource}furniture/drama/rightcoldashunderline.gif" width="196"/>
                                                </td>
                                        </tr>
                                </table>
                                <!-- end dashed underline -->
                        </xsl:if>
                        <xsl:if test="string-length(GUIDE/FUNDINGDETAILS) > 0">
                                <xsl:apply-templates select="GUIDE/FUNDINGDETAILS"/>
                        </xsl:if>
                </div>
                <!-- related features -->
                <xsl:if test="GUIDE/RELATED_FEATURES/node()">
                        <xsl:apply-templates select="GUIDE/RELATED_FEATURES"/>
                </xsl:if>
                <!-- more shorts with similar themes 
		Alistair: could change this to an apply-templates
		-->
                <xsl:if test="/H2G2/ARTICLE/ARTICLEINFO/CRUMBTRAILS/CRUMBTRAIL/ANCESTOR/NAME[text()='by theme']">
                        <table border="0" cellpadding="0" cellspacing="0">
                                <tr>
                                        <td height="10"/>
                                </tr>
                        </table>
                        <div class="box catalogue">
                                <div class="boxTitle">
                                        <strong>more shorts with similar themes</strong>
                                </div>
                                <p>This film is included in the film catalogue under the following themes:</p>
                                <ul>
                                        <xsl:for-each select="/H2G2/ARTICLE/ARTICLEINFO/CRUMBTRAILS/CRUMBTRAIL/ANCESTOR/NAME[text()='by theme']">
                                                <li>
                                                        <a href="C{../following-sibling::ANCESTOR/NODEID/text()}">
                                                                <xsl:value-of select="../following-sibling::ANCESTOR/NAME/text()"/>
                                                        </a>
                                                </li>
                                        </xsl:for-each>
                                </ul>
                        </div>
                </xsl:if>
                <!-- film promo gif -->
                <xsl:apply-templates select="GUIDE/FILM_PROMO"/>
                <!-- hide/display 'rate this film' - editors only  -->
                <xsl:apply-templates mode="hide_articlepage_poll" select="/H2G2/POLL-LIST"/>
        </xsl:template>
        <!-- 
     #####################################################################################
	   defines the right side of content for a credit
     ##################################################################################### 
-->
        <xsl:template name="FILM_APPROVED_CREDITRIGHT">
                <xsl:if test="string-length(GUIDE/USEFULLINKS1) > 0 or string-length(GUIDE/FUNDINGDETAILS) > 0 or string-length(GUIDE/DISTDETAILS) > 0">
                        <div class="rightcolboxcredit" width="244">
                                <table border="0" cellpadding="0" cellspacing="0">
                                        <tr>
                                                <td height="10"/>
                                        </tr>
                                </table>
                                <!-- Call to template for useful links -->
                                <xsl:call-template name="USEFUL_LINKS"/>
                                <!-- BEGIN funders and production companies -->
                                <xsl:if test="string-length(GUIDE/FUNDINGDETAILS) > 0">
                                        <div class="textlightmedium">
                                                <strong>funders/production companies</strong>
                                        </div>
                                        <div class="textbrightsmall">
                                                <xsl:apply-templates select="GUIDE/FUNDINGDETAILS"/>
                                        </div>
                                </xsl:if>
                                <!-- END funders and production companies -->
                                <!-- BEGIN Spacer -->
                                <table border="0" cellpadding="0" cellspacing="0">
                                        <tr>
                                                <td height="20"/>
                                        </tr>
                                </table>
                                <!-- END Spacer -->
                                <!-- BEGIN distribution/sales agent -->
                                <xsl:if test="string-length(GUIDE/DISTDETAILS) > 0">
                                        <div class="textlightmedium">
                                                <strong>distribution/sales agent</strong>
                                        </div>
                                        <div class="textbrightsmall">
                                                <xsl:apply-templates select="GUIDE/DISTDETAILS"/>
                                        </div>
                                </xsl:if>
                                <!-- END distribution/sales agent -->
                        </div>
                </xsl:if>
        </xsl:template>
        <!-- 
     #####################################################################################
	   determines if useful links exist and if so displays them
     ##################################################################################### 
-->
        <xsl:template name="USEFUL_LINKS">
                <xsl:if test="string-length(GUIDE/USEFULLINKS1) > 0">
                        <!-- useful links -->
                        <div class="textlightmedium">
                                <strong>useful links</strong>
                        </div>
                        <div class="textbrightsmall">
                                <ul class="rightcollistround">
                                        <xsl:choose>
                                                <xsl:when test="$article_type_group = 'credit' and string-length(GUIDE/USEFULLINKS2) = 0">
                                                        <!-- if the page is a credit and only has one link - 
						then the link could have been added by a user rather than a editor - 
						so need to check if it needs to be turned into a working link - 
						SHOULD CONVERT THIS INTO A REUSABLE NAMED TEMPLATE TO USE WITH EACH USEFULLINKS -->
                                                        <xsl:variable name="usefullink" select="GUIDE/USEFULLINKS1"/>
                                                        <xsl:variable name="usefullinkchecked">
                                                                <xsl:choose>
                                                                        <xsl:when
                                                                                test="starts-with($usefullink,'http://') or starts-with($usefullink,'#') or starts-with($usefullink,'mailto:') or (starts-with($usefullink,'/') and contains(substring-after($usefullink,'/'),'/'))">
                                                                                <xsl:value-of select="$usefullink"/>
                                                                        </xsl:when>
                                                                        <xsl:when test="starts-with($usefullink,'/') and string-length($usefullink) &gt; 1">
                                                                                <xsl:value-of select="concat('http:/',$usefullink)"/>
                                                                        </xsl:when>
                                                                        <xsl:when test="starts-with($usefullink,'www') and string-length($usefullink) &gt; 1">
                                                                                <xsl:value-of select="concat('http://',$usefullink)"/>
                                                                        </xsl:when>
                                                                        <xsl:otherwise>
                                                                                <xsl:value-of select="concat('http://www.', $usefullink)"/>
                                                                        </xsl:otherwise>
                                                                </xsl:choose>
                                                        </xsl:variable>
                                                        <li>
                                                                <a class="rightcol" target="_new">
                                                                        <xsl:attribute name="href">
                                                                                <xsl:value-of select="$usefullinkchecked"/>
                                                                        </xsl:attribute>
                                                                        <xsl:choose>
                                                                                <xsl:when test="string-length(GUIDE/USEFULLINKS1_TEXT) > 0">
                                                                                        <xsl:attribute name="title">
                                                                                                <xsl:value-of select="GUIDE/USEFULLINKS1_TEXT"/>
                                                                                        </xsl:attribute>
                                                                                        <xsl:value-of select="GUIDE/USEFULLINKS1_TEXT"/>
                                                                                </xsl:when>
                                                                                <xsl:otherwise>
                                                                                        <xsl:attribute name="title">
                                                                                                <xsl:value-of select="GUIDE/USEFULLINKS1"/>
                                                                                        </xsl:attribute>
                                                                                        <xsl:value-of select="GUIDE/USEFULLINKS1"/>
                                                                                </xsl:otherwise>
                                                                        </xsl:choose>
                                                                </a>
                                                        </li>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                        <li>
                                                                <a class="rightcol" target="_new">
                                                                        <xsl:attribute name="href">
                                                                                <xsl:choose>
                                                                                        <xsl:when
                                                                                                test="starts-with(GUIDE/USEFULLINKS1, 'http://') and not(starts-with(GUIDE/USEFULLINKS1, 'http://news.bbc.co.uk')or starts-with(GUIDE/USEFULLINKS1, 'http://www.bbc.co.uk'))"
                                                                                                    >http://www.bbc.co.uk/go/dna/filmnetwork/ext/ide1/-/<xsl:value-of select="GUIDE/USEFULLINKS1"/></xsl:when>
                                                                                        <xsl:otherwise>
                                                                                                <xsl:value-of select="GUIDE/USEFULLINKS1"/>
                                                                                        </xsl:otherwise>
                                                                                </xsl:choose>
                                                                        </xsl:attribute>
                                                                        <xsl:choose>
                                                                                <xsl:when test="string-length(GUIDE/USEFULLINKS1_TEXT) > 0">
                                                                                        <xsl:attribute name="title">
                                                                                                <xsl:value-of select="GUIDE/USEFULLINKS1_TEXT"/>
                                                                                        </xsl:attribute>
                                                                                        <xsl:value-of select="GUIDE/USEFULLINKS1_TEXT"/>
                                                                                </xsl:when>
                                                                                <xsl:otherwise>
                                                                                        <xsl:attribute name="title">
                                                                                                <xsl:value-of select="GUIDE/USEFULLINKS1"/>
                                                                                        </xsl:attribute>
                                                                                        <xsl:value-of select="GUIDE/USEFULLINKS1"/>
                                                                                </xsl:otherwise>
                                                                        </xsl:choose>
                                                                </a>
                                                        </li>
                                                </xsl:otherwise>
                                        </xsl:choose>
                                        <xsl:if test="string-length(GUIDE/USEFULLINKS2) > 0">
                                                <xsl:variable name="usefullink" select="GUIDE/USEFULLINKS2"/>
                                                <li>
                                                        <a class="rightcol" target="_new">
                                                                <xsl:attribute name="href">
                                                                        <xsl:choose>
                                                                                <xsl:when
                                                                                        test="starts-with(GUIDE/USEFULLINKS2, 'http://') and not(starts-with(GUIDE/USEFULLINKS2, 'http://news.bbc.co.uk')or starts-with(GUIDE/USEFULLINKS2, 'http://www.bbc.co.uk'))"
                                                                                                >http://www.bbc.co.uk/go/dna/filmnetwork/ext/ide1/-/<xsl:value-of select="GUIDE/USEFULLINKS2"/></xsl:when>
                                                                                <xsl:otherwise>
                                                                                        <xsl:value-of select="GUIDE/USEFULLINKS2"/>
                                                                                </xsl:otherwise>
                                                                        </xsl:choose>
                                                                </xsl:attribute>
                                                                <xsl:choose>
                                                                        <xsl:when test="string-length(GUIDE/USEFULLINKS2_TEXT) > 0">
                                                                                <xsl:attribute name="title">
                                                                                        <xsl:value-of select="GUIDE/USEFULLINKS2_TEXT"/>
                                                                                </xsl:attribute>
                                                                                <xsl:value-of select="GUIDE/USEFULLINKS2_TEXT"/>
                                                                        </xsl:when>
                                                                        <xsl:otherwise>
                                                                                <xsl:attribute name="title">
                                                                                        <xsl:value-of select="GUIDE/USEFULLINKS2"/>
                                                                                </xsl:attribute>
                                                                                <xsl:value-of select="GUIDE/USEFULLINKS2"/>
                                                                        </xsl:otherwise>
                                                                </xsl:choose>
                                                        </a>
                                                </li>
                                        </xsl:if>
                                        <xsl:if test="string-length(GUIDE/USEFULLINKS3) > 0">
                                                <li>
                                                        <a class="rightcol" target="_new">
                                                                <xsl:attribute name="href">
                                                                        <xsl:choose>
                                                                                <xsl:when
                                                                                        test="starts-with(GUIDE/USEFULLINKS3, 'http://') and not(starts-with(GUIDE/USEFULLINKS3, 'http://news.bbc.co.uk')or starts-with(GUIDE/USEFULLINKS3, 'http://www.bbc.co.uk'))"
                                                                                                >http://www.bbc.co.uk/go/dna/filmnetwork/ext/ide1/-/<xsl:value-of select="GUIDE/USEFULLINKS3"/></xsl:when>
                                                                                <xsl:otherwise>
                                                                                        <xsl:value-of select="GUIDE/USEFULLINKS3"/>
                                                                                </xsl:otherwise>
                                                                        </xsl:choose>
                                                                </xsl:attribute>
                                                                <xsl:choose>
                                                                        <xsl:when test="string-length(GUIDE/USEFULLINKS3_TEXT) > 0">
                                                                                <xsl:attribute name="title">
                                                                                        <xsl:value-of select="GUIDE/USEFULLINKS3_TEXT"/>
                                                                                </xsl:attribute>
                                                                                <xsl:value-of select="GUIDE/USEFULLINKS3_TEXT"/>
                                                                        </xsl:when>
                                                                        <xsl:otherwise>
                                                                                <xsl:attribute name="title">
                                                                                        <xsl:value-of select="GUIDE/USEFULLINKS3"/>
                                                                                </xsl:attribute>
                                                                                <xsl:value-of select="GUIDE/USEFULLINKS3"/>
                                                                        </xsl:otherwise>
                                                                </xsl:choose>
                                                        </a>
                                                </li>
                                        </xsl:if>
                                        <xsl:if test="string-length(GUIDE/USEFULLINKS4) > 0">
                                                <li>
                                                        <a class="rightcol" target="_new">
                                                                <xsl:attribute name="href">
                                                                        <xsl:choose>
                                                                                <xsl:when
                                                                                        test="starts-with(GUIDE/USEFULLINKS4, 'http://') and not(starts-with(GUIDE/USEFULLINKS4, 'http://news.bbc.co.uk')or starts-with(GUIDE/USEFULLINKS4, 'http://www.bbc.co.uk'))"
                                                                                                >http://www.bbc.co.uk/go/dna/filmnetwork/ext/ide1/-/<xsl:value-of select="GUIDE/USEFULLINKS4"/></xsl:when>
                                                                                <xsl:otherwise>
                                                                                        <xsl:value-of select="GUIDE/USEFULLINKS4"/>
                                                                                </xsl:otherwise>
                                                                        </xsl:choose>
                                                                </xsl:attribute>
                                                                <xsl:choose>
                                                                        <xsl:when test="string-length(GUIDE/USEFULLINKS4_TEXT) > 0">
                                                                                <xsl:attribute name="title">
                                                                                        <xsl:value-of select="GUIDE/USEFULLINKS4_TEXT"/>
                                                                                </xsl:attribute>
                                                                                <xsl:value-of select="GUIDE/USEFULLINKS4_TEXT"/>
                                                                        </xsl:when>
                                                                        <xsl:otherwise>
                                                                                <xsl:attribute name="title">
                                                                                        <xsl:value-of select="GUIDE/USEFULLINKS4"/>
                                                                                </xsl:attribute>
                                                                                <xsl:value-of select="GUIDE/USEFULLINKS4"/>
                                                                        </xsl:otherwise>
                                                                </xsl:choose>
                                                        </a>
                                                </li>
                                        </xsl:if>
                                        <xsl:if test="string-length(GUIDE/USEFULLINKS5) > 0">
                                                <li>
                                                        <a class="rightcol" target="_new">
                                                                <xsl:attribute name="href">
                                                                        <xsl:choose>
                                                                                <xsl:when
                                                                                        test="starts-with(GUIDE/USEFULLINKS5, 'http://') and not(starts-with(GUIDE/USEFULLINKS5, 'http://news.bbc.co.uk')or starts-with(GUIDE/USEFULLINKS5, 'http://www.bbc.co.uk'))"
                                                                                                >http://www.bbc.co.uk/go/dna/filmnetwork/ext/ide1/-/<xsl:value-of select="GUIDE/USEFULLINKS5"/></xsl:when>
                                                                                <xsl:otherwise>
                                                                                        <xsl:value-of select="GUIDE/USEFULLINKS5"/>
                                                                                </xsl:otherwise>
                                                                        </xsl:choose>
                                                                </xsl:attribute>
                                                                <xsl:choose>
                                                                        <xsl:when test="string-length(GUIDE/USEFULLINKS5_TEXT) > 0">
                                                                                <xsl:attribute name="title">
                                                                                        <xsl:value-of select="GUIDE/USEFULLINKS5_TEXT"/>
                                                                                </xsl:attribute>
                                                                                <xsl:value-of select="GUIDE/USEFULLINKS5_TEXT"/>
                                                                        </xsl:when>
                                                                        <xsl:otherwise>
                                                                                <xsl:attribute name="title">
                                                                                        <xsl:value-of select="GUIDE/USEFULLINKS5"/>
                                                                                </xsl:attribute>
                                                                                <xsl:value-of select="GUIDE/USEFULLINKS5"/>
                                                                        </xsl:otherwise>
                                                                </xsl:choose>
                                                        </a>
                                                </li>
                                        </xsl:if>
                                        <xsl:if test="string-length(GUIDE/USEFULLINKS6) > 0">
                                                <li>
                                                        <a class="rightcol" target="_new">
                                                                <xsl:attribute name="href">
                                                                        <xsl:choose>
                                                                                <xsl:when
                                                                                        test="starts-with(GUIDE/USEFULLINKS6, 'http://') and not(starts-with(GUIDE/USEFULLINKS6, 'http://news.bbc.co.uk')or starts-with(GUIDE/USEFULLINKS6, 'http://www.bbc.co.uk'))"
                                                                                                >http://www.bbc.co.uk/go/dna/filmnetwork/ext/ide1/-/<xsl:value-of select="GUIDE/USEFULLINKS6"/></xsl:when>
                                                                                <xsl:otherwise>
                                                                                        <xsl:value-of select="GUIDE/USEFULLINKS6"/>
                                                                                </xsl:otherwise>
                                                                        </xsl:choose>
                                                                </xsl:attribute>
                                                                <xsl:choose>
                                                                        <xsl:when test="string-length(GUIDE/USEFULLINKS6_TEXT) > 0">
                                                                                <xsl:attribute name="title">
                                                                                        <xsl:value-of select="GUIDE/USEFULLINKS6_TEXT"/>
                                                                                </xsl:attribute>
                                                                                <xsl:value-of select="GUIDE/USEFULLINKS6_TEXT"/>
                                                                        </xsl:when>
                                                                        <xsl:otherwise>
                                                                                <xsl:attribute name="title">
                                                                                        <xsl:value-of select="GUIDE/USEFULLINKS6"/>
                                                                                </xsl:attribute>
                                                                                <xsl:value-of select="GUIDE/USEFULLINKS6"/>
                                                                        </xsl:otherwise>
                                                                </xsl:choose>
                                                        </a>
                                                </li>
                                        </xsl:if>
                                </ul>
                        </div>
                        <!-- END useful links -->
                        <!-- dashed underline -->
                        <table border="0" cellpadding="0" cellspacing="0" width="196">
                                <tr>
                                        <td height="13" valign="middle" width="196">
                                                <img alt="" height="1" src="{$imagesource}furniture/drama/rightcoldashunderline.gif" width="196"/>
                                        </td>
                                </tr>
                        </table>
                        <!-- end dashed underline -->
                </xsl:if>
        </xsl:template>
        <!-- 
     #####################################################################################
	   short template to determine the genre based on the type number
     ##################################################################################### 
-->
        <xsl:template name="GENRE_TITLE">
                <!-- ALISTAIR: add class style for link color -->
                <xsl:if test="EXTRAINFO/TYPE/@ID[substring(.,2,1)='0']">
                        <a href="{$root}filmnetwork/drama">Drama</a>
                </xsl:if>
                <xsl:if test="EXTRAINFO/TYPE/@ID[substring(.,2,1)='1']">
                        <a href="{$root}filmnetwork/comedy">Comedy</a>
                </xsl:if>
                <xsl:if test="EXTRAINFO/TYPE/@ID[substring(.,2,1)='2']">
                        <a href="{$root}filmnetwork/documentary">Documentary</a>
                </xsl:if>
                <xsl:if test="EXTRAINFO/TYPE/@ID[substring(.,2,1)='3']">
                        <a href="{$root}filmnetwork/animation">Animation</a>
                </xsl:if>
                <xsl:if test="EXTRAINFO/TYPE/@ID[substring(.,2,1)='4']">
                        <a href="{$root}filmnetwork/experimental">Experimental</a>
                </xsl:if>
                <xsl:if test="EXTRAINFO/TYPE/@ID[substring(.,2,1)='5']">
                        <a href="{$root}filmnetwork/music">Music</a>
                </xsl:if>
        </xsl:template>
        <!-- 
     #####################################################################################
	   short template for snippet of code for links at the bottom of the 'rate this film' box
     ##################################################################################### 
-->
        <xsl:template name="RATING_COMMENTS">
                <table border="0" cellpadding="0" cellspacing="0" width="196">
                        <tr>
                                <td height="15" valign="middle" width="196">
                                        <img alt="" height="1" src="{$imagesource}furniture/drama/rightcoldashunderline.gif" width="196"/>
                                </td>
                        </tr>
                </table>
                <div class="textlightmedium"><strong>
                                <a class="rightcol" href="#comments">see comments on this film</a>
                        </strong>&nbsp;<img alt="" height="9" src="{$imagesource}furniture/drama/rightarrow.gif" width="9"/></div>
                <div class="textlightmedium">
                        <strong>
                                <a class="rightcol" xsl:use-attribute-sets="maFORUMID_empty_article">
                                        <xsl:attribute name="href">
                                                <xsl:call-template name="sso_addcomment_signin"/>
                                        </xsl:attribute> add your comments </a>
                        </strong>&nbsp;<img alt="" height="9" src="{$imagesource}furniture/drama/rightarrow.gif" width="9"/>
                </div>
        </xsl:template>
        <!-- list of series episodes -->
        <xsl:template name="episode-list">
                <xsl:param name="episode-no"/>
                <li class="episode">
                        <img alt="{parent::GUIDE/*[local-name() = concat('EPISODE', $episode-no, '_TITLE')]}" height="57"
                                src="/filmnetwork/images/shorts/{parent::GUIDE/*[local-name() = concat('EPISODE', $episode-no, '_IMAGE')]}" width="115"> </img>
                        <a onclick="window.open(this.href,this.target,'status=no,scrollbars=yes,resizable=yes,width=384,height=283')"
                                onmouseout="swapImage(this.getElementsByTagName('img')[0], 'http://www.bbc.co.uk/filmnetwork/images/furniture/drama/playnow.gif')"
                                onmouseover="swapImage(this.getElementsByTagName('img')[0], 'http://www.bbc.co.uk/filmnetwork/images/furniture/drama/playnow_ro2.gif')" target="avaccesswin">
                                <xsl:attribute name="href">
                                        <xsl:choose>
                                                <xsl:when test="string-length(parent::GUIDE/ADDITIONAL_WARNING) > 0 or parent::GUIDE/CONTENT_FLASHINGIMAGES= 'on' ">
                                                        <xsl:text>http://www.bbc.co.uk/filmnetwork/mediaselector_interstitial.shtml?clipname=</xsl:text>
                                                        <xsl:value-of select="parent::GUIDE/*[local-name() = concat('EPISODE', $episode-no, '_ANUMBER')]"/>
                                                        <xsl:if test="parent::GUIDE/CONTENT_FLASHINGIMAGES= 'on'">&amp;flashingimages=yes</xsl:if>
                                                        <xsl:if test="string-length(parent::GUIDE/ADDITIONAL_WARNING) > 0">&amp;warning=<xsl:value-of select="parent::GUIDE/ADDITIONAL_WARNING"/></xsl:if>
                                                        <xsl:text>&amp;</xsl:text>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                        <xsl:text>http://www.bbc.co.uk/mediaselector/check/filmnetwork/media/shorts/</xsl:text>
                                                        <xsl:value-of select="parent::GUIDE/*[local-name() = concat('EPISODE', $episode-no, '_ANUMBER')]"/>
                                                        <xsl:text>?</xsl:text>
                                                </xsl:otherwise>
                                        </xsl:choose>
                                        <xsl:text>size=</xsl:text>
                                        <xsl:value-of select="parent::GUIDE/PLAYER_SIZE"/>
                                        <xsl:text>&amp;bgc=</xsl:text>
                                        <xsl:choose>
                                                <xsl:when test="parent::GUIDE/SUBTITLED = 'on'">FF3300</xsl:when>
                                                <xsl:otherwise>C0C0C0</xsl:otherwise>
                                        </xsl:choose>
                                        <xsl:if test="parent::GUIDE/STREAMING_NARROW = 'on' and parent::GUIDE/WINPLAYER = 'on'">&amp;nbwm=1</xsl:if>
                                        <xsl:if test="parent::GUIDE/STREAMING_BROADBAND = 'on' and parent::GUIDE/WINPLAYER = 'on'">&amp;bbwm=1</xsl:if>
                                        <xsl:if test="parent::GUIDE/STREAMING_NARROW = 'on' and parent::GUIDE/REALPLAYER = 'on'">&amp;nbram=1</xsl:if>
                                        <xsl:if test="parent::GUIDE/STREAMING_BROADBAND = 'on' and parent::GUIDE/REALPLAYER = 'on'">&amp;bbram=1</xsl:if>
                                        <xsl:if test="parent::GUIDE/SUBTITLED = 'on'">&amp;st=1</xsl:if>
                                </xsl:attribute>
                                <img alt="Play Now" height="31" name="dramawatch" src="http://www.bbc.co.uk/filmnetwork/images/furniture/drama/playnow.gif" width="121"/>
                        </a>
                        <h3>
                                <xsl:value-of select="."/>
                        </h3>
                        <p>
                                <xsl:value-of select="parent::GUIDE/*[local-name() = concat('EPISODE', $episode-no, '_DESCRIPTION')]"/>
                        </p>
                </li>
        </xsl:template>
</xsl:stylesheet>
