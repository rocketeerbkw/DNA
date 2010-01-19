<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet exclude-result-prefixes="msxsl local s dt" version="1.0" xmlns:dt="urn:schemas-microsoft-com:datatypes" xmlns:local="#local-functions" xmlns:msxsl="urn:schemas-microsoft-com:xslt"
        xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
        <!-- GLOBAL VARIABLES -->
        <!-- root of the XML doc -->
        <xsl:variable name="xmlRoot" select="/"/>
        <!-- crew member names -->
        <xsl:variable name="crewMembers">
                <member name="director" nameUC="DIRECTOR" order="1"/>
                <member name="writer" nameUC="WRITER" order="2"/>
                <member name="producer" nameUC="PRODUCER" order="3"/>
                <member articleTypeGroup="film" name="editor" nameUC="EDITOR" order="4"/>
                <member articleTypeGroup="film" name="driector of photography" nameUC="CAMERA" order="5"/>
                <member articleTypeGroup="film" name="sound" nameUC="SOUND" order="6"/>
                <member articleTypeGroup="film" name="music" nameUC="MUSIC" order="7"/>
        </xsl:variable>
        <!-- months -->
        <xsl:variable name="months">
                <month name="January" value="01"/>
                <month name="February" value="02"/>
                <month name="March" value="03"/>
                <month name="April" value="04"/>
                <month name="May" value="05"/>
                <month name="June" value="06"/>
                <month name="July" value="07"/>
                <month name="August" value="08"/>
                <month name="September" value="09"/>
                <month name="October" value="10"/>
                <month name="November" value="11"/>
                <month name="December" value="12"/>
        </xsl:variable>
        <!-- regions -->
        <xsl:variable name="regions">
                <region name="Scotland"/>
                <region name="North East"/>
                <region name="North West"/>
                <region name="Northern Ireland"/>
                <region name="Yorkshire &amp; Humber"/>
                <region name="Wales"/>
                <region name="West Midlands"/>
                <region name="East Midlands"/>
                <region name="East of England"/>
                <region name="South West"/>
                <region name="South East"/>
                <region name="London"/>
                <region name="non-UK"/>
        </xsl:variable>
        <!-- format -->
        <xsl:variable name="formats"> </xsl:variable>
        <!-- TEMPLATES -->
        <xsl:template name="FILM_SUBMISSION_EDITFORM">
                <!-- DEBUG -->
                <xsl:call-template name="TRACE">
                        <xsl:with-param name="message">FILM_SUBMISSION</xsl:with-param>
                        <xsl:with-param name="pagename">formfilmsubmission.xsl</xsl:with-param>
                </xsl:call-template>
                <!-- DEBUG -->
                <!-- FORM -->
                <input name="_msfinish" type="hidden" value="yes"/>
                <xsl:choose>
                        <xsl:when test="$article_type_group = 'credit' or $article_type_group = 'declined'">
                                <input name="_msxml" type="hidden" value="{$addcredit}"/>
                        </xsl:when>
                        <xsl:when test="$article_type_group = 'film'">
                                <input name="_msxml" type="hidden" value="{$filmsubmissionfields}"/>
                        </xsl:when>
                </xsl:choose>
                <input name="ARTICLEFORUMSTYLE" type="hidden" value="1"/>
                <xsl:choose>
                        <xsl:when test="/H2G2/ARTICLE/ARTICLEINFO/DATECREATED">
                                <input name="DATECREATED" type="hidden" value="{/H2G2/ARTICLE/ARTICLEINFO/DATECREATED/DATE/@SORT}"/>
                        </xsl:when>
                        <xsl:otherwise>
                                <!-- if article does not have a DATECREATED then it must be being created so capture current date -->
                                <input name="DATECREATED" type="hidden" value="{/H2G2/DATE/@SORT}"/>
                        </xsl:otherwise>
                </xsl:choose>
                <xsl:choose>
                        <xsl:when test="/H2G2/ARTICLE/ARTICLEINFO/PAGEAUTHOR">
                                <input name="SUBMITTEDBYNAME" type="hidden" value="{/H2G2/ARTICLE/ARTICLEINFO/PAGEAUTHOR//USER/USERNAME}"/>
                                <input name="SUBMITTEDBYID" type="hidden" value="{/H2G2/ARTICLE/ARTICLEINFO/PAGEAUTHOR//USER/USERID}"/>
                        </xsl:when>
                        <xsl:otherwise>
                                <input name="SUBMITTEDBYNAME" type="hidden" value="{/H2G2/VIEWING-USER/USER/FIRSTNAMES} {/H2G2/VIEWING-USER/USER/LASTNAME}"/>
                                <input name="SUBMITTEDBYID" type="hidden" value="{/H2G2/VIEWING-USER/USER/USERID}"/>
                        </xsl:otherwise>
                </xsl:choose>
                <!-- extra info fields test -->
                <!-- hard code add poll to every film submission -->
                <input name="polltype1" type="hidden" value="3"/>
                <input name="details" type="hidden">
                        <xsl:attribute name="value">
                                <xsl:choose>
                                        <xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_details']/VALUE = 'yes'">yes</xsl:when>
                                        <xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_details']/VALUE = 'no'">no</xsl:when>
                                        <xsl:otherwise>
                                                <xsl:value-of select="MULTI-ELEMENT[@NAME='DETAILS']/VALUE-EDITABLE"/>
                                                <xsl:value-of select="GUIDE/DETAILS"/>
                                        </xsl:otherwise>
                                </xsl:choose>
                        </xsl:attribute>
                </input>
                <input name="originalcredit" type="hidden">
                        <xsl:attribute name="value">
                                <xsl:choose>
                                        <xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_credit']/VALUE = 1">yes</xsl:when>
                                        <xsl:otherwise>
                                                <xsl:value-of select="MULTI-ELEMENT[@NAME='ORIGINALCREDIT']/VALUE-EDITABLE"/>
                                                <xsl:value-of select="GUIDE/ORIGINALCREDIT"/>
                                        </xsl:otherwise>
                                </xsl:choose>
                        </xsl:attribute>
                </input>
                <table border="0" cellpadding="0" cellspacing="0" class="submistablebg topmargin" width="635">
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
                                        <!-- submission steps - only display when not a credit or when user is creating a credit -->
                                        <xsl:choose>
                                                <xsl:when
                                                        test="$article_type_group = 'credit' or $article_type_group = 'declined'        or /H2G2/PARAMS/PARAM[NAME = 's_type' and VALUE =        'useredit']">
                                                        <table border="0" cellpadding="0" cellspacing="0" width="459">
                                                                <tr>
                                                                        <td>
                                                                                <div class="step1selected">
                                                                                        <strong>&nbsp;</strong>
                                                                                </div>
                                                                        </td>
                                                                </tr>
                                                        </table>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                        <table border="0" cellpadding="0" cellspacing="0" width="459">
                                                                <tr>
                                                                        <td valign="top">
                                                                                <div class="step1selected">
                                                                                        <strong>step 1 : film details</strong>
                                                                                </div>
                                                                        </td>
                                                                        <td valign="top" width="17">
                                                                                <img alt="" height="26" src="{$imagesource}furniture/submission/stepsarrow.gif" width="17"/>
                                                                        </td>
                                                                        <td valign="top">
                                                                                <div class="step2">
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
                                                </xsl:otherwise>
                                        </xsl:choose>
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
                                        <!--film/credit header image -->
                                        <div>
                                                <xsl:choose>
                                                        <xsl:when test="$article_type_group = 'credit' or $article_type_group = 'declined'">
                                                                <img alt="add credit" height="29" src="{$imagesource}furniture/title_add_credit.gif" width="459"/>
                                                        </xsl:when>
                                                        <xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_type' and VALUE =         'useredit']">
                                                                <img alt="edit your film details" height="28" src="{$imagesource}furniture/edit_your_film_details.gif" width="254"/>
                                                        </xsl:when>
                                                        <xsl:otherwise>
                                                                <img alt="film submission: step 1" height="28" src="{$imagesource}furniture/filmsubmitstep1header.gif" width="288"/>
                                                        </xsl:otherwise>
                                                </xsl:choose>
                                        </div>
                                        <!-- spacer -->
                                        <table border="0" cellpadding="0" cellspacing="0" width="459">
                                                <tr>
                                                        <td height="8"/>
                                                </tr>
                                        </table>
                                        <!-- BEGIN intro text -->
                                        <xsl:choose>
                                                <xsl:when test="count(/H2G2/MULTI-STAGE/MULTI-ELEMENT[child::ERRORS]) &gt; 0">
                                                        <xsl:apply-templates mode="c_typedarticle" select="/H2G2/MULTI-STAGE/MULTI-ELEMENT[ERRORS/ERROR][1]/ERRORS/ERROR"/>
                                                </xsl:when>
                                                <xsl:when test="count(/H2G2/MULTI-STAGE/MULTI-REQUIRED[child::ERRORS]) &gt; 0">
                                                        <xsl:apply-templates mode="c_typedarticle" select="/H2G2/MULTI-STAGE/MULTI-REQUIRED[ERRORS/ERROR][1]/ERRORS/ERROR"/>
                                                </xsl:when>
                                                <xsl:when test="$article_type_group = 'credit' or $article_type_group = 'declined'">
                                                        <div class="textmedium">Add details about the film below. You only need to fill out the fields with a "*", all other info is optional. You may
                                                                preview your credit before you add it and you can edit it anytime you want.</div>
                                                </xsl:when>
                                                <xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_type' and VALUE =        'useredit']">
                                                        <div class="textmedium">Edit your film details below. Please do not use capitals.</div>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                        <div class="textmedium">Fill in the form below. Please complete all the <span class="alert">required fields*</span>. Please don't use capital
                                                                letters. Once you are happy, click next.</div>
                                                </xsl:otherwise>
                                        </xsl:choose>
                                        <!-- END intro text -->
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
                                        <!-- conditional so this isn't displayed if eiting film details-->
                                        <xsl:choose>
                                                <xsl:when test="not(/H2G2/PARAMS/PARAM[NAME = 's_type' and VALUE =        'useredit'])">
                                                        <!-- film details header (only if film, not credit) -->
                                                        <xsl:if test="$article_type_group != 'credit' and $article_type_group != 'declined'">
                                                                <div>
                                                                        <img alt="film details" height="13" src="{$imagesource}furniture/filmdetails.gif" width="83"/>
                                                                </div>
                                                                <!-- spacer -->
                                                                <table border="0" cellpadding="0" cellspacing="0" width="459">
                                                                        <tr>
                                                                                <td height="8"/>
                                                                        </tr>
                                                                </table>
                                                                <!-- end spacer -->
                                                                <div class="textmedium">This information will appear on the finished film page. Please check that all details and names are spelt
                                                                        correctly. We reserve the right to edit for the purposes of accuracy and clarity.</div>
                                                                <!-- Grey line spacer -->
                                                                <table border="0" cellpadding="0" cellspacing="0" width="459">
                                                                        <tr>
                                                                                <td height="17">
                                                                                        <img alt="" class="tiny" height="1" src="{$imagesource}furniture/wherebeenbar.gif" width="459"/>
                                                                                </td>
                                                                        </tr>
                                                                </table>
                                                        </xsl:if>
                                                        <!-- film details -->
                                                        <table border="0" cellpadding="0" cellspacing="0" width="459">
                                                                <tr>
                                                                        <td width="150">
                                                                                <xsl:apply-templates mode="c_error_class" select="MULTI-REQUIRED[@NAME='TITLE']"/>
                                                                                <div class="formtitle"><strong>film title:</strong>&nbsp;*</div>
                                                                        </td>
                                                                        <td colspan="4">
                                                                                <xsl:apply-templates mode="t_articletitle" select="."/>
                                                                        </td>
                                                                </tr>
                                                                <xsl:if test="$article_type_group = 'credit' or $article_type_group = 'declined'">
                                                                        <tr>
                                                                                <td width="150">
                                                                                        <xsl:apply-templates mode="c_error_class" select="MULTI-ELEMENT[@NAME='YOUR_ROLE']"/>
                                                                                        <div class="formtitle"><strong>your role:</strong>&nbsp;*</div>
                                                                                </td>
                                                                                <td colspan="4">
                                                                                        <input name="YOUR_ROLE" type="text">
                                                                                                <xsl:attribute name="value">
                                                                                                    <xsl:value-of select="MULTI-ELEMENT[@NAME='YOUR_ROLE']/VALUE-EDITABLE"/>
                                                                                                </xsl:attribute>
                                                                                                <xsl:attribute name="class">formboxwidthmedium</xsl:attribute>
                                                                                        </input>
                                                                                </td>
                                                                        </tr>
                                                                </xsl:if>
                                                                <tr>
                                                                        <td>
                                                                                <xsl:apply-templates mode="c_error_class" select="MULTI-ELEMENT[@NAME='DIRECTORSNAME']"/>
                                                                                <div class="formtitle"><strong>director's name:</strong>&nbsp;*</div>
                                                                        </td>
                                                                        <td colspan="4">
                                                                                <input name="DIRECTORSNAME" type="text">
                                                                                        <xsl:attribute name="value">
                                                                                                <xsl:value-of select="MULTI-ELEMENT[@NAME='DIRECTORSNAME']/VALUE-EDITABLE"/>
                                                                                        </xsl:attribute>
                                                                                        <xsl:attribute name="class">formboxwidthmedium</xsl:attribute>
                                                                                </input>
                                                                        </td>
                                                                </tr>
                                                                <xsl:if test="$article_type_group != 'declined'">
                                                                        <tr>
                                                                                <!-- BEGIN genre selection -->
                                                                                <td>
                                                                                        <xsl:apply-templates mode="c_error_class" select="MULTI-REQUIRED[@NAME='TYPE']"/>
                                                                                        <div class="formtitle"><strong>genre:</strong>&nbsp;*</div>
                                                                                </td>
                                                                                <td colspan="4">
                                                                                        <xsl:apply-templates mode="r_articletype" select=".">
                                                                                                <xsl:with-param name="group" select="$article_type_group"/>
                                                                                                <xsl:with-param name="user" select="$article_type_user"/>
                                                                                        </xsl:apply-templates>
                                                                                </td>
                                                                                <!-- END genre selection -->
                                                                        </tr>
                                                                </xsl:if>
                                                                <xsl:if test="$article_type_group = 'declined'">
                                                                        <tr>
                                                                                <td>
                                                                                        <xsl:apply-templates mode="c_error_class" select="MULTI-REQUIRED[@NAME='TYPE']"/>
                                                                                        <div class="formtitle"><strong>genre:</strong>&nbsp;*</div>
                                                                                </td>
                                                                                <td colspan="4">
                                                                                        <select name="type">
                                                                                                <option value="">choose...</option>
                                                                                                <option value="70"><xsl:if test="MULTI-REQUIRED[@NAME='TYPE']/VALUE-EDITABLE = 50">
                                                                                                    <xsl:attribute name="selected">selected</xsl:attribute>
                                                                                                    </xsl:if>drama</option>
                                                                                                <option value="71"><xsl:if test="MULTI-REQUIRED[@NAME='TYPE']/VALUE-EDITABLE = 51">
                                                                                                    <xsl:attribute name="selected">selected</xsl:attribute>
                                                                                                    </xsl:if>comedy</option>
                                                                                                <option value="72"><xsl:if test="MULTI-REQUIRED[@NAME='TYPE']/VALUE-EDITABLE = 52">
                                                                                                    <xsl:attribute name="selected">selected</xsl:attribute>
                                                                                                    </xsl:if>documentary</option>
                                                                                                <option value="73"><xsl:if test="MULTI-REQUIRED[@NAME='TYPE']/VALUE-EDITABLE = 53">
                                                                                                    <xsl:attribute name="selected">selected</xsl:attribute>
                                                                                                    </xsl:if>animation</option>
                                                                                                <option value="74"><xsl:if test="MULTI-REQUIRED[@NAME='TYPE']/VALUE-EDITABLE = 54">
                                                                                                    <xsl:attribute name="selected">selected</xsl:attribute>
                                                                                                    </xsl:if>experimental</option>
                                                                                                <option value="75"><xsl:if test="MULTI-REQUIRED[@NAME='TYPE']/VALUE-EDITABLE = 55">
                                                                                                    <xsl:attribute name="selected">selected</xsl:attribute>
                                                                                                    </xsl:if>music</option>
                                                                                        </select>
                                                                                </td>
                                                                        </tr>
                                                                </xsl:if>
                                                                <tr>
                                                                        <td>
                                                                                <xsl:choose>
                                                                                        <!-- test both mins and secs boxes here -->
                                                                                        <xsl:when test="string-length(MULTI-ELEMENT[@NAME='FILMLENGTH_MINS']) = 0">
                                                                                                <xsl:apply-templates mode="c_error_class" select="MULTI-ELEMENT[@NAME='FILMLENGTH_MINS']"/>
                                                                                        </xsl:when>
                                                                                        <xsl:otherwise>
                                                                                                <xsl:apply-templates mode="c_error_class" select="MULTI-ELEMENT[@NAME='FILMLENGTH_SECS']"/>
                                                                                        </xsl:otherwise>
                                                                                </xsl:choose>
                                                                                <div class="formtitle"><strong>film length:</strong>&nbsp;*</div>
                                                                        </td>
                                                                        <td width="28">
                                                                                <input class="formboxwidthxsmall" name="FILMLENGTH_MINS" type="text">
                                                                                        <xsl:attribute name="value">
                                                                                                <xsl:value-of select="MULTI-ELEMENT[@NAME='FILMLENGTH_MINS']/VALUE-EDITABLE"/>
                                                                                        </xsl:attribute>
                                                                                </input>
                                                                        </td>
                                                                        <td width="99">
                                                                                <div class="textmedium">&nbsp;&nbsp;<strong>minutes</strong></div>
                                                                        </td>
                                                                        <td width="28">
                                                                                <input class="formboxwidthxsmall" name="FILMLENGTH_SECS" type="text">
                                                                                        <xsl:attribute name="value">
                                                                                                <xsl:value-of select="MULTI-ELEMENT[@NAME='FILMLENGTH_SECS']/VALUE-EDITABLE"/>
                                                                                        </xsl:attribute>
                                                                                </input>
                                                                        </td>
                                                                        <td width="154">
                                                                                <div class="textmedium">&nbsp;&nbsp;<strong>seconds</strong></div>
                                                                        </td>
                                                                </tr>
                                                                <tr>
                                                                        <td colspan="5">
                                                                                <div class="formtitle">Both minutes and seconds boxes must be filled in, ie: 1 minutes 46 secs</div>
                                                                        </td>
                                                                </tr>
                                                                <tr>
                                                                        <!-- only display if a film, not a credit -->
                                                                        <xsl:if test="$article_type_group = 'film'">
                                                                                <td>
                                                                                        <xsl:apply-templates mode="c_error_class" select="MULTI-ELEMENT[@NAME='TAPEFORMAT']"/>
                                                                                        <div class="formtitle"><strong>tape format:</strong>&nbsp;*</div>
                                                                                </td>
                                                                                <td colspan="4">
                                                                                        <select class="formboxwidthsmall" name="TAPEFORMAT">
                                                                                                <option value="">choose...</option>
                                                                                                <option name="VHS"><xsl:if test="MULTI-ELEMENT[@NAME='TAPEFORMAT']/VALUE-EDITABLE = 'VHS'">
                                                                                                    <xsl:attribute name="selected">selected</xsl:attribute>
                                                                                                    </xsl:if>VHS</option>
                                                                                                <option name="DVD"><xsl:if test="MULTI-ELEMENT[@NAME='TAPEFORMAT']/VALUE-EDITABLE = 'DVD'">
                                                                                                    <xsl:attribute name="selected">selected</xsl:attribute>
                                                                                                    </xsl:if>DVD</option>
                                                                                        </select>
                                                                                </td>
                                                                        </xsl:if>
                                                                </tr>
                                                                <tr>
                                                                        <!-- only display if a film, not a credit -->
                                                                        <xsl:if test="$article_type_group = 'film'">
                                                                                <td>
                                                                                        <xsl:apply-templates mode="c_error_class" select="MULTI-ELEMENT[@NAME='ORIGINALFORMAT']"/>
                                                                                        <div class="formtitle"><strong>original format:</strong>&nbsp;*</div>
                                                                                </td>
                                                                                <td colspan="4">
                                                                                        <select class="formboxwidthsmall" name="ORIGINALFORMAT">
                                                                                                <option value="">choose...</option>
                                                                                                <option name="HD"><xsl:if test="MULTI-ELEMENT[@NAME='ORIGINALFORMAT']/VALUE-EDITABLE = 'HD'">
                                                                                                    <xsl:attribute name="selected">selected</xsl:attribute>
                                                                                                    </xsl:if>HD</option>
                                                                                                <option name="digital"><xsl:if test="MULTI-ELEMENT[@NAME='ORIGINALFORMAT']/VALUE-EDITABLE = 'digital'">
                                                                                                    <xsl:attribute name="selected">selected</xsl:attribute>
                                                                                                    </xsl:if>digital</option>
                                                                                                <option name="Super 8"><xsl:if test="MULTI-ELEMENT[@NAME='ORIGINALFORMAT']/VALUE-EDITABLE = 'Super 8'">
                                                                                                    <xsl:attribute name="selected">selected</xsl:attribute>
                                                                                                    </xsl:if>Super 8</option>
                                                                                                <option name="16mm/Super 16"><xsl:if
                                                                                                    test="MULTI-ELEMENT[@NAME='ORIGINALFORMAT']/VALUE-EDITABLE = '16mm/Super 16'">
                                                                                                    <xsl:attribute name="selected">selected</xsl:attribute>
                                                                                                    </xsl:if>16mm/Super 16</option>
                                                                                                <option name="35mm/Super 35"><xsl:if
                                                                                                    test="MULTI-ELEMENT[@NAME='ORIGINALFORMAT']/VALUE-EDITABLE = '35mm/Super 35'">
                                                                                                    <xsl:attribute name="selected">selected</xsl:attribute>
                                                                                                    </xsl:if>35mm/Super 35</option>
                                                                                                <option name="other"><xsl:if test="MULTI-ELEMENT[@NAME='ORIGINALFORMAT']/VALUE-EDITABLE = 'other'">
                                                                                                    <xsl:attribute name="selected">selected</xsl:attribute>
                                                                                                    </xsl:if>other</option>
                                                                                        </select>
                                                                                </td>
                                                                        </xsl:if>
                                                                </tr>
                                                                <tr>
                                                                        <td>
                                                                                <xsl:apply-templates mode="c_error_class" select="MULTI-ELEMENT[@NAME='YEARPRODUCTION']"/>
                                                                                <div class="formtitle"><strong>year of production:</strong>&nbsp;*</div>
                                                                        </td>
                                                                        <td colspan="4">
                                                                                <select class="formboxwidthsmall" name="YEARPRODUCTION">
                                                                                        <option value="">choose...</option>
                                                                                        <xsl:call-template name="yearOfProduction"/>
                                                                                </select>
                                                                        </td>
                                                                </tr>
                                                                <!-- ===========================Darren: added two extra information fields=========================== -->
                                                                <tr>
                                                                        <td>
                                                                                <xsl:apply-templates mode="c_error_class" select="MULTI-ELEMENT[@NAME='REGION']"/>
                                                                                <div class="formtitle"><strong>region:</strong>&nbsp;*</div>
                                                                        </td>
                                                                        <td colspan="4">
                                                                                <select class="formboxwidthsmall" name="REGION" onchange="dropDown(this, 'nonUK')">
                                                                                        <option value="">choose...</option>
                                                                                        <xsl:for-each select="msxsl:node-set($regions)/region">
                                                                                                <xsl:sort case-order="upper-first" select="@name"/>
                                                                                                <xsl:call-template name="region"/>
                                                                                        </xsl:for-each>
                                                                                </select>
                                                                        </td>
                                                                </tr>
                                                                <tr class="jsHidden" id="nonUK">
                                                                        <td>
                                                                                <div class="formtitle"><strong>if non-UK:</strong>&nbsp;</div>
                                                                        </td>
                                                                        <td colspan="4">
                                                                                <input name="REGION-OTHER" type="text">
                                                                                        <xsl:attribute name="value">
                                                                                                <xsl:value-of select="MULTI-ELEMENT[@NAME='REGION-OTHER']/VALUE-EDITABLE"/>
                                                                                        </xsl:attribute>
                                                                                        <xsl:attribute name="class">formboxwidthmedium</xsl:attribute>
                                                                                </input>
                                                                        </td>
                                                                </tr>
                                                                <tr>
                                                                        <td>
                                                                                <xsl:apply-templates mode="c_error_class" select="MULTI-ELEMENT[@NAME='LANGUAGE']"/>
                                                                                <div class="formtitle"><strong>language:</strong>&nbsp;*</div>
                                                                        </td>
                                                                        <td colspan="4">
                                                                                <select class="formboxwidthsmall" name="LANGUAGE" onchange="dropDown(this, 'ifOther')">
                                                                                        <option value="">choose...</option>
                                                                                        <option value="English"><xsl:if test="MULTI-ELEMENT[@NAME='LANGUAGE']/VALUE-EDITABLE = 'English'">
                                                                                                    <xsl:attribute name="selected">selected</xsl:attribute>
                                                                                                </xsl:if>English</option>
                                                                                        <option value="non-dialogue"><xsl:if test="MULTI-ELEMENT[@NAME='LANGUAGE']/VALUE-EDITABLE = 'non-dialogue'">
                                                                                                    <xsl:attribute name="selected">selected</xsl:attribute>
                                                                                                </xsl:if>non-dialogue</option>
                                                                                        <option value="other"><xsl:if test="MULTI-ELEMENT[@NAME='LANGUAGE']/VALUE-EDITABLE = 'other'">
                                                                                                    <xsl:attribute name="selected">selected</xsl:attribute>
                                                                                                </xsl:if>other</option>
                                                                                </select>
                                                                        </td>
                                                                </tr>
                                                                <tr class="jsHidden" id="ifOther">
                                                                        <td>
                                                                                <div class="formtitle"><strong>if other:</strong>&nbsp;</div>
                                                                        </td>
                                                                        <td colspan="4">
                                                                                <input name="LANGUAGE-OTHER" type="text">
                                                                                        <xsl:attribute name="value">
                                                                                                <xsl:value-of select="MULTI-ELEMENT[@NAME='LANGUAGE-OTHER']/VALUE-EDITABLE"/>
                                                                                        </xsl:attribute>
                                                                                        <xsl:attribute name="class">formboxwidthmedium</xsl:attribute>
                                                                                </input>
                                                                        </td>
                                                                </tr>
                                                                <!--<tr>
                                                                        <td>
                                                                                <div class="formtitle"><strong>choose up to 5 tags to describe your film:</strong>&nbsp;</div>
                                                                        </td>
                                                                        <td colspan="4">
                                                                                <input name="TAGS" type="text"/>
                                                                        </td>
                                                                </tr>-->
                                                                <!-- ====================================================================================== -->
                                                                <tr>
                                                                        <td colspan="5">
                                                                                <!-- Grey line spacer -->
                                                                                <table border="0" cellpadding="0" cellspacing="0" width="459">
                                                                                        <tr>
                                                                                                <td height="1">
                                                                                                    <img alt="" class="tiny" height="1" src="{$imagesource}furniture/wherebeenbar.gif" width="459"/>
                                                                                                </td>
                                                                                        </tr>
                                                                                </table>
                                                                                <!-- END Grey line spacer -->
                                                                        </td>
                                                                </tr>
                                                                <tr>
                                                                        <td colspan="5">
                                                                                <!-- begin description -->
                                                                                <table border="0" cellpadding="0" cellspacing="0" width="459">
                                                                                        <tr>
                                                                                                <td>
                                                                                                    <xsl:apply-templates mode="c_error_class" select="MULTI-ELEMENT[@NAME='DESCRIPTION']"/>
                                                                                                    <div class="formtitle"><strong>log line (short description):</strong>&nbsp;*</div>
                                                                                                </td>
                                                                                                <td align="right">
                                                                                                    <div class="formtitle">approx 20 words</div>
                                                                                                </td>
                                                                                        </tr>
                                                                                </table>
                                                                                <!-- END begin description -->
                                                                        </td>
                                                                </tr>
                                                                <!-- description TEXT AREA -->
                                                                <tr>
                                                                        <td colspan="5">
                                                                                <textarea class="formboxwidthlarge" name="DESCRIPTION" rows="3">
                                                                                        <xsl:value-of select="MULTI-ELEMENT[@NAME='DESCRIPTION']/VALUE-EDITABLE"/>
                                                                                </textarea>
                                                                        </td>
                                                                </tr>
                                                                <!-- END description TEXT AREA -->
                                                                <tr>
                                                                        <td colspan="5" height="10"/>
                                                                </tr>
                                                                <tr>
                                                                        <td colspan="5" height="1">
                                                                                <img alt="" class="tiny" height="1" src="{$imagesource}furniture/wherebeenbar.gif" width="459"/>
                                                                        </td>
                                                                </tr>
                                                                <!-- end GREY rule -->
                                                                <tr>
                                                                        <td colspan="5">
                                                                                <!-- begin synopsis -->
                                                                                <table border="0" cellpadding="0" cellspacing="0" width="459">
                                                                                        <tr>
                                                                                                <td>
                                                                                                    <xsl:apply-templates mode="c_error_class" select="MULTI-REQUIRED[@NAME='BODY']"/>
                                                                                                    <div class="formtitle"><strong>synopsis:</strong>&nbsp;*</div>
                                                                                                </td>
                                                                                                <td align="right">
                                                                                                    <div class="formtitle">approx 100 words</div>
                                                                                                </td>
                                                                                        </tr>
                                                                                </table>
                                                                                <!-- end synopsis -->
                                                                        </td>
                                                                </tr>
                                                                <!-- synopsis text area -->
                                                                <tr>
                                                                        <td colspan="5">
                                                                                <textarea class="formboxwidthlarge" name="body" rows="5">
                                                                                        <xsl:value-of select="MULTI-REQUIRED[@NAME='BODY']/VALUE-EDITABLE"/>
                                                                                </textarea>
                                                                        </td>
                                                                </tr>
                                                                <!-- END synopsis text area -->
                                                                <!-- BEGIN short fact about film -->
                                                                <!-- only display if a film, not a credit -->
                                                                <xsl:if test="$article_type_group = 'film'">
                                                                        <!-- GREY rule -->
                                                                        <tr>
                                                                                <td colspan="5" height="8"/>
                                                                        </tr>
                                                                        <tr>
                                                                                <td colspan="5">
                                                                                        <!-- Grey line spacer -->
                                                                                        <table border="0" cellpadding="0" cellspacing="0" width="459">
                                                                                                <tr>
                                                                                                    <td height="1">
                                                                                                    <img alt="" class="tiny" height="1" src="{$imagesource}furniture/wherebeenbar.gif"
                                                                                                    width="459"/>
                                                                                                    </td>
                                                                                                </tr>
                                                                                        </table>
                                                                                        <!-- END Grey line spacer -->
                                                                                </td>
                                                                        </tr>
                                                                        <tr>
                                                                                <td colspan="5">
                                                                                        <div class="formtitlea">
                                                                                                <strong>short fact: this is your chance to say something about your film, why you made it, what was the
                                                                                                    biggest challenge etc.</strong>
                                                                                        </div>
                                                                                </td>
                                                                        </tr>
                                                                        <tr>
                                                                                <td align="right" colspan="5">
                                                                                        <div class="formtitleb">approx 100 words</div>
                                                                                </td>
                                                                        </tr>
                                                                        <!-- BEGIN description TEXT AREA -->
                                                                        <tr>
                                                                                <td colspan="5">
                                                                                        <textarea class="formboxwidthlarge" name="FILMMAKERSCOMMENTS" rows="5">
                                                                                                <xsl:value-of select="MULTI-ELEMENT[@NAME='FILMMAKERSCOMMENTS']/VALUE-EDITABLE"/>
                                                                                        </textarea>
                                                                                </td>
                                                                        </tr>
                                                                </xsl:if>
                                                                <!-- END short fact about film -->
                                                                <!-- END begin character count -->
                                                                <tr>
                                                                        <td colspan="5" height="8"/>
                                                                </tr>
                                                                <!-- GREY RULE -->
                                                                <tr>
                                                                        <td colspan="5" height="8"/>
                                                                </tr>
                                                                <tr>
                                                                        <td colspan="5" height="1">
                                                                                <img alt="" class="tiny" height="1" src="{$imagesource}furniture/wherebeenbar.gif" width="459"/>
                                                                        </td>
                                                                </tr>
                                                                <!-- END GREY RULE -->
                                                                <!-- begin festival screenings -->
                                                                <tr>
                                                                        <td colspan="5">
                                                                                <div class="formtitlea">
                                                                                        <strong>please give details of any distribution deals you have e.g. Dazzle, Shorts International (formerly Brit
                                                                                                Shorts), Short Circuit Films:</strong>
                                                                                </div>
                                                                        </td>
                                                                </tr>
                                                                <tr>
                                                                        <td align="right" colspan="5">
                                                                                <div class="formtitleb">
                                                                                        <img alt="" class="tiny" height="1" src="/f/t.gif" width="1"/>
                                                                                        <!-- approx 100 words -->
                                                                                </div>
                                                                        </td>
                                                                </tr>
                                                                <!-- end festival screenings -->
                                                                <!-- festival screenings text area -->
                                                                <tr>
                                                                        <td colspan="5">
                                                                                <textarea class="formboxwidthlarge" name="DISTDETAILS" rows="5">
                                                                                        <xsl:value-of select="MULTI-ELEMENT[@NAME='DISTDETAILS']/VALUE-EDITABLE"/>
                                                                                </textarea>
                                                                        </td>
                                                                </tr>
                                                                <!-- END estival screenings text area -->
                                                                <!-- GREY RULE -->
                                                                <tr>
                                                                        <td colspan="5" height="8"/>
                                                                </tr>
                                                                <tr>
                                                                        <td colspan="5" height="1">
                                                                                <img alt="" class="tiny" height="1" src="{$imagesource}furniture/wherebeenbar.gif" width="459"/>
                                                                        </td>
                                                                </tr>
                                                                <!-- END GREY RULE -->
                                                                <!-- begin organisation details -->
                                                                <tr>
                                                                        <td colspan="5">
                                                                                <div class="formtitle">
                                                                                        <strong>please give details of any funding you received and any production companies you worked with:</strong>
                                                                                </div>
                                                                        </td>
                                                                </tr>
                                                                <!-- end organisation details -->
                                                                <!-- organisation details textarea -->
                                                                <tr>
                                                                        <td colspan="5">
                                                                                <!-- make input area bigger for editors -->
                                                                                <textarea alt="" class="formboxwidthlarge" name="FUNDINGDETAILS" rows="3">
                                                                                        <xsl:if test="$test_IsEditor= 1">
                                                                                                <xsl:attribute name="style">height:200px</xsl:attribute>
                                                                                        </xsl:if>
                                                                                        <xsl:value-of select="MULTI-ELEMENT[@NAME='FUNDINGDETAILS']/VALUE-EDITABLE"/>
                                                                                </textarea>
                                                                        </td>
                                                                </tr>
                                                                <!-- END organisation details textarea -->
                                                                <!-- grey line spacer -->
                                                                <tr>
                                                                        <td colspan="5" height="8"/>
                                                                </tr>
                                                                <tr>
                                                                        <td colspan="5" height="1">
                                                                                <img alt="" class="tiny" height="1" src="{$imagesource}furniture/wherebeenbar.gif" width="459"/>
                                                                        </td>
                                                                </tr>
                                                                <!-- end grey line spacer -->
                                                                <!-- BEGIN budget: only display if a film, not a credit -->
                                                                <xsl:if test="$article_type_group = 'film'">
                                                                        <tr>
                                                                                <td colspan="5" height="8"/>
                                                                        </tr>
                                                                        <tr>
                                                                                <td colspan="5">
                                                                                        <div class="formtitle"><strong>budget (optional):</strong>&nbsp; <input name="BUDGETCOST" type="text">
                                                                                                    <xsl:attribute name="value">
                                                                                                    <xsl:value-of select="MULTI-ELEMENT[@NAME='BUDGETCOST']/VALUE-EDITABLE"/>
                                                                                                    </xsl:attribute>
                                                                                                </input>
                                                                                        </div>
                                                                                </td>
                                                                        </tr>
                                                                        <!-- BEGIN grey line spacer -->
                                                                        <tr>
                                                                                <td colspan="5" height="1">
                                                                                        <img alt="" class="tiny" height="1" src="{$imagesource}furniture/wherebeenbar.gif" width="459"/>
                                                                                </td>
                                                                        </tr>
                                                                        <!-- END grey line spacer -->
                                                                </xsl:if>
                                                                <!-- END budget -->
                                                                <!-- begin URLs -->
                                                                <tr>
                                                                        <td colspan="5">
                                                                                <div class="formtitle">
                                                                                        <strong>please give addresses (URLs) of any websites relevant to your film (eg your own website, a funder's or a
                                                                                                production company's website etc):</strong>
                                                                                </div>
                                                                        </td>
                                                                </tr>
                                                                <!-- end  URLs -->
                                                                <!-- URLs of relevenat website(s) -->
                                                                <xsl:choose>
                                                                        <xsl:when test="$article_type_group='credit'or $article_type_group='declined'">
                                                                                <tr>
                                                                                        <td colspan="5">
                                                                                                <div class="textmedium">
                                                                                                    <strong>Useful link title</strong>
                                                                                                    <br/>
                                                                                                    <input class="formboxwidthlarge" name="USEFULLINKS1_TEXT" type="text">
                                                                                                    <xsl:attribute name="value">
                                                                                                    <xsl:value-of select="MULTI-ELEMENT[@NAME='USEFULLINKS1_TEXT']/VALUE-EDITABLE"/>
                                                                                                    </xsl:attribute>
                                                                                                    </input>
                                                                                                </div>
                                                                                        </td>
                                                                                </tr>
                                                                                <tr>
                                                                                        <td colspan="5">
                                                                                                <div class="textmedium">
                                                                                                    <strong>Useful link URL</strong>
                                                                                                    <br/>
                                                                                                    <input class="formboxwidthlarge" name="USEFULLINKS1" type="text">
                                                                                                    <xsl:attribute name="value">
                                                                                                    <xsl:value-of select="MULTI-ELEMENT[@NAME='USEFULLINKS1']/VALUE-EDITABLE"/>
                                                                                                    </xsl:attribute>
                                                                                                    </input>
                                                                                                </div>
                                                                                                <br/>
                                                                                        </td>
                                                                                </tr>
                                                                        </xsl:when>
                                                                        <xsl:otherwise>
                                                                                <xsl:call-template name="usefulLinks">
                                                                                        <xsl:with-param name="maxRows" select="3"/>
                                                                                </xsl:call-template>
                                                                                <!-- show extra 3 links for editors only -->
                                                                                <xsl:if test="$test_IsEditor">
                                                                                        <xsl:call-template name="usefulLinks">
                                                                                                <xsl:with-param name="maxRows" select="6"/>
                                                                                                <xsl:with-param name="currentRow" select="4"/>
                                                                                        </xsl:call-template>
                                                                                </xsl:if>
                                                                        </xsl:otherwise>
                                                                </xsl:choose>
                                                        </table>
                                                        <!-- END film details -->
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
                                                        <!-- END FILM DETAILS SECTION -->
                                                </xsl:when>
                                                <xsl:otherwise>
                                                        <xsl:for-each
                                                                select="*[not(starts-with(@NAME, 'CREW') or starts-with(@NAME,         'CAST') or starts-with(@NAME, 'AWARDS')) and string-length(VALUE) > 0]">
                                                                <input name="{@NAME}" type="hidden" value="{VALUE}"/>
                                                        </xsl:for-each>
                                                </xsl:otherwise>
                                        </xsl:choose>
                                        <!-- BEGIN CAST AND CREW  DETAILS SECTION-->
                                        <div>
                                                <img alt="cast &amp; crew detail" height="13" src="{$imagesource}furniture/castcrewdetail.gif" width="157"/>
                                        </div>
                                        <!-- END film details header -->
                                        <!-- spacer -->
                                        <table border="0" cellpadding="0" cellspacing="0" width="459">
                                                <tr>
                                                        <td height="8"/>
                                                </tr>
                                        </table>
                                        <!-- end spacer -->
                                        <xsl:if test="$article_type_group='film'">
                                                <div class="textmedium">This information will appear on the finished film page. Leave fields blank if they do not apply. If there are cast / crew that
                                                        you would like to be credited that do not fit into the standard boxes, please give details in the other crew / cast section. Please make sure
                                                        you have your cast and crew's permission to publish their names on BBC Film Network and do not include any of their personal details e.g. email
                                                        address.</div>
                                        </xsl:if>
                                        <!-- Grey line spacer -->
                                        <table border="0" cellpadding="0" cellspacing="0" width="459">
                                                <tr>
                                                        <td height="17">
                                                                <img alt="" class="tiny" height="1" src="{$imagesource}furniture/wherebeenbar.gif" width="459"/>
                                                        </td>
                                                </tr>
                                        </table>
                                        <!-- END Grey line spacer -->
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
                                        <!-- begin CREW details -->
                                        <table border="0" cellpadding="0" cellspacing="0" width="459">
                                                <xsl:choose>
                                                        <xsl:when test="$article_type_group='film'">
                                                                <xsl:for-each select="msxsl:node-set($crewMembers)/member">
                                                                        <xsl:sort select="order"/>
                                                                        <xsl:call-template name="crewRows">
                                                                                <xsl:with-param name="crewMember" select="@name"/>
                                                                                <xsl:with-param name="crewMemberUC" select="@nameUC"/>
                                                                                <xsl:with-param name="root" select="$xmlRoot"/>
                                                                        </xsl:call-template>
                                                                </xsl:for-each>
                                                        </xsl:when>
                                                        <xsl:otherwise>
                                                                <xsl:for-each select="msxsl:node-set($crewMembers)/member[@articleTypeGroup !=          'film']">
                                                                        <xsl:sort select="order"/>
                                                                        <xsl:call-template name="crewRows">
                                                                                <xsl:with-param name="crewMember" select="@name"/>
                                                                                <xsl:with-param name="crewMemberUC" select="@nameUC"/>
                                                                                <xsl:with-param name="root" select="$xmlRoot"/>
                                                                        </xsl:call-template>
                                                                </xsl:for-each>
                                                        </xsl:otherwise>
                                                </xsl:choose>
                                                <xsl:if test="not(/H2G2/PARAMS/PARAM[NAME = 's_type' and VALUE =         'useredit'])">
                                                        <tr>
                                                                <!-- other crew details -->
                                                                <td colspan="5">
                                                                        <div class="formtitle"><strong>other crew details:</strong> please give names and roles</div>
                                                                </td>
                                                        </tr>
                                                        <tr>
                                                                <td colspan="5">
                                                                        <textarea class="formboxwidthlarge" name="CREW_OTHER_DETAILS" rows="5">
                                                                                <xsl:value-of select="MULTI-ELEMENT[@NAME='CREW_OTHER_DETAILS']/VALUE-EDITABLE"/>
                                                                        </textarea>
                                                                </td>
                                                        </tr>
                                                </xsl:if>
                                        </table>
                                        <!-- END CREW details -->
                                        <!-- other crew details -->
                                        <xsl:if test="/H2G2/PARAMS/PARAM[NAME = 's_type' and VALUE =       'useredit']">
                                                <table id="otherCrew">
                                                        <thead>
                                                                <tr>
                                                                        <th colspan="4">other crew details: please give names and roles</th>
                                                                </tr>
                                                        </thead>
                                                        <tbody>
                                                                <xsl:call-template name="otherCrewRows">
                                                                        <xsl:with-param name="maxRows" select="10"/>
                                                                </xsl:call-template>
                                                        </tbody>
                                                </table>
                                        </xsl:if>
                                        <!-- Grey line spacer -->
                                        <table border="0" cellpadding="0" cellspacing="0" width="459">
                                                <tr>
                                                        <td height="17">
                                                                <img alt="" class="tiny" height="1" src="{$imagesource}furniture/wherebeenbar.gif" width="459"/>
                                                        </td>
                                                </tr>
                                        </table>
                                        <!-- END Grey line spacer -->
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
                                        <!-- begin CAST details -->
                                        <table border="0" cellpadding="0" cellspacing="0" width="459">
                                                <tr>
                                                        <td width="150"/>
                                                        <td width="144">
                                                                <div class="textsmall">
                                                                        <strong>character name</strong>
                                                                </div>
                                                        </td>
                                                        <td width="21"/>
                                                        <td width="144">
                                                                <div class="textsmall">
                                                                        <strong>name</strong>
                                                                </div>
                                                        </td>
                                                </tr>
                                                <xsl:call-template name="castRows">
                                                        <xsl:with-param name="maxRows" select="15"/>
                                                </xsl:call-template>
                                                <xsl:if test="$article_type_group = 'film' and not(/H2G2/PARAMS/PARAM[NAME = 's_type' and VALUE =        'useredit'])">
                                                        <tr>
                                                                <td colspan="5">
                                                                        <div class="formtitle"><strong>other cast details:</strong> please give character name and name</div>
                                                                </td>
                                                        </tr>
                                                        <tr>
                                                                <td colspan="5">
                                                                        <textarea class="formboxwidthlarge" name="CAST_OTHER_DETAILS" rows="5">
                                                                                <xsl:value-of select="MULTI-ELEMENT[@NAME='CAST_OTHER_DETAILS']/VALUE-EDITABLE"/>
                                                                        </textarea>
                                                                </td>
                                                        </tr>
                                                </xsl:if>
                                                <!-- END cast details text area -->
                                        </table>
                                        <!-- END CAST details -->
                                        <div id="festivalScreenings">
                                                <h3><span></span>Festivals, Screenings and Awards</h3>
                                                <p>Please fill in the applicable boxes. <span class="em">Please do NOT use capital letters.</span></p>
                                                <table>
                                                        <thead>
                                                                <tr>
                                                                        <th>award/commendation</th>
                                                                        <th>festivals/screenings</th>
                                                                        <th>place</th>
                                                                        <th>year</th>
                                                                </tr>
                                                        </thead>
                                                        <tbody>
                                                                <xsl:call-template name="festivalRows">
                                                                        <xsl:with-param name="maxRows" select="20"/>
                                                                </xsl:call-template>
                                                        </tbody>
                                                </table>
                                        </div>
                                        <xsl:if test="not(/H2G2/PARAMS/PARAM[NAME = 's_type']/VALUE = 'useredit')">
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
                                                <!-- ENDCAST AND CREW  DETAILS SECTION-->
                                                <!-- BEGIN CONTRACT DECLARATION SECTION-->
                                                <xsl:if test="$article_type_group != 'credit' and $article_type_group != 'declined'">
                                                        <div>
                                                                <img alt="contract declarations" height="13" src="{$imagesource}furniture/contractdeclarations.gif" width="157"/>
                                                        </div>
                                                        <!-- END film details header -->
                                                        <!-- spacer -->
                                                        <table border="0" cellpadding="0" cellspacing="0" width="459">
                                                                <tr>
                                                                        <td height="8"/>
                                                                </tr>
                                                        </table>
                                                        <!-- end spacer -->
                                                        <div class="textmedium">Please read the <a href="{$root}Rules" target="_new">
                                                                        <strong>submission rules</strong>
                                                                </a> and <a href="{$root}Clearance" target="_new">
                                                                        <strong>clearance procedures</strong>
                                                                </a> before you submit your film and tick the boxes below.</div>
                                                        <table border="0" cellpadding="0" cellspacing="0" width="459">
                                                                <tr>
                                                                        <td height="8"/>
                                                                </tr>
                                                                <tr>
                                                                        <td valign="top">
                                                                                <xsl:if test="//MULTI-ELEMENT[@NAME='DECLARATION_READSUBBMISSION']/VALUE-EDITABLE != 'on'">
                                                                                        <span class="alert">*</span>
                                                                                </xsl:if>
                                                                                <xsl:if test="count(//MULTI-ELEMENT[@NAME='DECLARATION_READSUBBMISSION']) = 0">*</xsl:if>
                                                                        </td>
                                                                        <td valign="top">
                                                                                <input class="formboxwidthxsmall" name="DECLARATION_READSUBBMISSION" type="checkbox">
                                                                                        <xsl:if test="MULTI-ELEMENT[@NAME='DECLARATION_READSUBBMISSION']/VALUE-EDITABLE = 'on'">
                                                                                                <xsl:attribute name="checked">checked</xsl:attribute>
                                                                                        </xsl:if>
                                                                                </input>
                                                                                <input name="DECLARATION_READSUBBMISSION" type="hidden"/>
                                                                        </td>
                                                                        <td>
                                                                                <xsl:if test="//MULTI-ELEMENT[@NAME='DECLARATION_READSUBBMISSION']/VALUE-EDITABLE != 'on'">
                                                                                        <xsl:attribute name="class">alert</xsl:attribute>
                                                                                </xsl:if>
                                                                                <div class="textmedium">I have read the <a href="{$root}Rules" target="_new">
                                                                                                <strong>submission rules</strong>
                                                                                        </a>, agree with them and confirm that my film conforms to them. (tick box)</div>
                                                                        </td>
                                                                </tr>
                                                                <tr>
                                                                        <td height="8"/>
                                                                </tr>
                                                                <tr>
                                                                        <td valign="top">
                                                                                <xsl:if test="//MULTI-ELEMENT[@NAME='DECLARATION_CLEARANCEPROCEDURE']/VALUE-EDITABLE != 'on'">
                                                                                        <span class="alert">*</span>
                                                                                </xsl:if>
                                                                                <xsl:if test="count(//MULTI-ELEMENT[@NAME='DECLARATION_CLEARANCEPROCEDURE']) = 0">*</xsl:if>
                                                                        </td>
                                                                        <td valign="top">
                                                                                <input class="formboxwidthxsmall" name="DECLARATION_CLEARANCEPROCEDURE" type="checkbox">
                                                                                        <xsl:if test="MULTI-ELEMENT[@NAME='DECLARATION_CLEARANCEPROCEDURE']/VALUE-EDITABLE = 'on'">
                                                                                                <xsl:attribute name="checked">checked</xsl:attribute>
                                                                                        </xsl:if>
                                                                                </input>
                                                                                <input name="DECLARATION_CLEARANCEPROCEDURE" type="hidden"/>
                                                                        </td>
                                                                        <td>
                                                                                <xsl:if test="//MULTI-ELEMENT[@NAME='DECLARATION_CLEARANCEPROCEDURE']/VALUE-EDITABLE != 'on'">
                                                                                        <xsl:attribute name="class">alert</xsl:attribute>
                                                                                </xsl:if>
                                                                                <div class="textmedium">I have read the <a href="{$root}Clearance" target="_new">
                                                                                                <strong>clearance procedures</strong>
                                                                                        </a>, agree with them and confirm that my film conforms to them. (tick box)</div>
                                                                        </td>
                                                                </tr>
                                                                <tr>
                                                                        <td height="8"/>
                                                                </tr>
                                                                <tr>
                                                                        <td valign="top">
                                                                                <xsl:if test="//MULTI-ELEMENT[@NAME='DECLARATION_NORETURNTAPE']/VALUE-EDITABLE != 'on'">
                                                                                        <span class="alert">*</span>
                                                                                </xsl:if>
                                                                                <xsl:if test="count(//MULTI-ELEMENT[@NAME='DECLARATION_NORETURNTAPE']) = 0">*</xsl:if>
                                                                        </td>
                                                                        <td valign="top">
                                                                                <input class="formboxwidthxsmall" name="DECLARATION_NORETURNTAPE" type="checkbox">
                                                                                        <xsl:if test="MULTI-ELEMENT[@NAME='DECLARATION_NORETURNTAPE']/VALUE-EDITABLE = 'on'">
                                                                                                <xsl:attribute name="checked">checked</xsl:attribute>
                                                                                        </xsl:if>
                                                                                </input>
                                                                                <input name="DECLARATION_NORETURNTAPE" type="hidden"/>
                                                                        </td>
                                                                        <td>
                                                                                <xsl:if test="//MULTI-ELEMENT[@NAME='DECLARATION_NORETURNTAPE']/VALUE-EDITABLE != 'on'">
                                                                                        <xsl:attribute name="class">alert</xsl:attribute>
                                                                                </xsl:if>
                                                                                <div class="textmedium">I agree that the BBC will not be able to return my film, nor does it guarantee to publish it.
                                                                                        (tick box)</div>
                                                                        </td>
                                                                </tr>
                                                        </table>
                                                        <!-- END CONTRACT DECLARATION SECTION-->
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
                                                </xsl:if>
                                        </xsl:if>
                                        <!-- BEGIN EDITORS ONLY SECTION-->
                                        <xsl:choose>
                                                <xsl:when test="$test_IsEditor and $article_type_group = 'film'">
                                                        <div class="filmedit">
                                                                <table border="0" cellpadding="3" cellspacing="3" width="459">
                                                                        <tr>
                                                                                <td bgcolor="#CAE4ED">
                                                                                        <div class="textxlarge">Editors only section</div>
                                                                                </td>
                                                                        </tr>
                                                                        <tr>
                                                                                <td bgcolor="#CAE4ED">
                                                                                        <div class="textmedium">
                                                                                                <strong>Why Declined:</strong>
                                                                                                <br/>
                                                                                                <textarea cols="30" name="WHYDECLINED" rows="3">
                                                                                                    <xsl:value-of select="MULTI-ELEMENT[@NAME='WHYDECLINED']/VALUE-EDITABLE"/>
                                                                                                </textarea>
                                                                                        </div>
                                                                                </td>
                                                                        </tr>
                                                                        <tr>
                                                                                <td bgcolor="#CAE4ED">
                                                                                        <div class="textmedium"><strong>streaming:</strong>&nbsp;&nbsp;Narrow&nbsp;&nbsp;<input
                                                                                                    name="STREAMING_NARROW" type="checkbox">
                                                                                                    <xsl:if test="MULTI-ELEMENT[@NAME='STREAMING_NARROW']/VALUE-EDITABLE = 'on'">
                                                                                                    <xsl:attribute name="checked">checked</xsl:attribute>
                                                                                                    </xsl:if>
                                                                                                </input>&nbsp;&nbsp;Broadband&nbsp;&nbsp;<input name="STREAMING_BROADBAND"
                                                                                                    type="checkbox">
                                                                                                    <xsl:if test="MULTI-ELEMENT[@NAME='STREAMING_BROADBAND']/VALUE-EDITABLE = 'on'">
                                                                                                    <xsl:attribute name="checked">checked</xsl:attribute>
                                                                                                    </xsl:if>
                                                                                                </input></div>
                                                                                </td>
                                                                        </tr>
                                                                        <tr>
                                                                                <td bgcolor="#CAE4ED">
                                                                                        <div class="textmedium"><strong>Media type:</strong>&nbsp;&nbsp;Windows&nbsp;&nbsp;<input
                                                                                                    name="WINPLAYER" type="checkbox">
                                                                                                    <xsl:if test="MULTI-ELEMENT[@NAME='WINPLAYER']/VALUE-EDITABLE = 'on'">
                                                                                                    <xsl:attribute name="checked">checked</xsl:attribute>
                                                                                                    </xsl:if>
                                                                                                </input>&nbsp;&nbsp;Real&nbsp;&nbsp;<input name="REALPLAYER" type="checkbox">
                                                                                                    <xsl:if test="MULTI-ELEMENT[@NAME='REALPLAYER']/VALUE-EDITABLE = 'on'">
                                                                                                    <xsl:attribute name="checked">checked</xsl:attribute>
                                                                                                    </xsl:if>
                                                                                                </input></div>
                                                                                </td>
                                                                        </tr>
                                                                        <tr>
                                                                                <td bgcolor="#CAE4ED">
                                                                                        <div class="textmedium"><strong>subtitled:</strong>&nbsp;&nbsp;<input name="SUBTITLED" type="checkbox">
                                                                                                    <xsl:if test="MULTI-ELEMENT[@NAME='SUBTITLED']/VALUE-EDITABLE = 'on'">
                                                                                                    <xsl:attribute name="checked">checked</xsl:attribute>
                                                                                                    </xsl:if>
                                                                                                </input></div>
                                                                                </td>
                                                                        </tr>
                                                                        <tr>
                                                                                <td bgcolor="#CAE4ED">
                                                                                        <div class="textmedium"><strong>Player size:</strong>&nbsp;&nbsp;4x3&nbsp;&nbsp;<input
                                                                                                    name="PLAYER_SIZE" type="radio" value="4x3">
                                                                                                    <xsl:if test="MULTI-ELEMENT[@NAME='PLAYER_SIZE']/VALUE-EDITABLE = '4x3'">
                                                                                                    <xsl:attribute name="checked">checked</xsl:attribute>
                                                                                                    </xsl:if>
                                                                                                </input>&nbsp;&nbsp;16x9&nbsp;&nbsp;<input name="PLAYER_SIZE" type="radio" value="16x9">
                                                                                                    <xsl:if test="MULTI-ELEMENT[@NAME='PLAYER_SIZE']/VALUE-EDITABLE = '16x9'">
                                                                                                    <xsl:attribute name="checked">checked</xsl:attribute>
                                                                                                    </xsl:if>
                                                                                                </input></div>
                                                                                </td>
                                                                        </tr>
                                                                        <tr>
                                                                                <td bgcolor="#CAE4ED">
                                                                                        <div class="textmedium"><strong>available until:</strong>&nbsp;&nbsp;Day&nbsp;&nbsp; <input
                                                                                                    class="formboxwidthxsmall" name="AVAIL_DAY" type="text">
                                                                                                    <xsl:attribute name="value">
                                                                                                    <xsl:value-of select="MULTI-ELEMENT[@NAME='AVAIL_DAY']/VALUE-EDITABLE"/>
                                                                                                    </xsl:attribute>
                                                                                                </input>&nbsp;&nbsp;Month&nbsp;&nbsp; <select class="formboxwidthanumber"
                                                                                                    name="AVAIL_MONTH">
                                                                                                    <option value="">choose...</option>
                                                                                                    <xsl:for-each select="msxsl:node-set($months)/month">
                                                                                                    <xsl:sort select="@value"/>
                                                                                                    <option value="{@value}">
                                                                                                    <xsl:if
                                                                                                    test="$xmlRoot/H2G2/MULTI-STAGE/MULTI-ELEMENT[@NAME='AVAIL_MONTH']/VALUE-EDITABLE                 = current()/@value">
                                                                                                    <xsl:attribute name="selected">selected</xsl:attribute>
                                                                                                    </xsl:if>
                                                                                                    <xsl:value-of select="@name"/>
                                                                                                    </option>
                                                                                                    </xsl:for-each>
                                                                                                </select> &nbsp;&nbsp;Year&nbsp;&nbsp;<input class="formboxwidthanumber"
                                                                                                    name="AVAIL_YEAR" type="text">
                                                                                                    <xsl:attribute name="value">
                                                                                                    <xsl:value-of select="MULTI-ELEMENT[@NAME='AVAIL_YEAR']/VALUE-EDITABLE"/>
                                                                                                    </xsl:attribute>
                                                                                                </input></div>
                                                                                </td>
                                                                        </tr>
                                                                        <tr>
                                                                                <td bgcolor="#CAE4ED">
                                                                                        <div class="textmedium"><strong>hi-res download:</strong>&nbsp;&nbsp;<input name="HI_RES_DOWNLOAD"
                                                                                                    type="checkbox">
                                                                                                    <xsl:if test="MULTI-ELEMENT[@NAME='HI_RES_DOWNLOAD']/VALUE-EDITABLE = 'on'">
                                                                                                    <xsl:attribute name="checked">checked</xsl:attribute>
                                                                                                    </xsl:if>
                                                                                                </input></div>
                                                                                </td>
                                                                        </tr>
                                                                        <tr>
                                                                                <td bgcolor="#CAE4ED">
                                                                                        <div class="textmedium"><strong>stills gallery:</strong>&nbsp;&nbsp;<input name="STILLS_GALLERY"
                                                                                                    type="checkbox">
                                                                                                    <xsl:if test="MULTI-ELEMENT[@NAME='STILLS_GALLERY']/VALUE-EDITABLE = 'on'">
                                                                                                    <xsl:attribute name="checked">checked</xsl:attribute>
                                                                                                    </xsl:if>
                                                                                                </input></div>
                                                                                </td>
                                                                        </tr>
                                                                        <tr>
                                                                                <td bgcolor="#CAE4ED">
                                                                                        <div class="textmedium">
                                                                                                <strong>Copyright:</strong>&nbsp;&nbsp;<input name="COPYRIGHT" size="30" type="text">
                                                                                                    <xsl:attribute name="value">
                                                                                                    <xsl:value-of select="MULTI-ELEMENT[@NAME='COPYRIGHT']/VALUE-EDITABLE"/>
                                                                                                    </xsl:attribute>
                                                                                                </input>
                                                                                        </div>
                                                                                </td>
                                                                        </tr>
                                                                        <!--  ADULT CONTENT input box  -->
                                                                        <tr>
                                                                                <td bgcolor="#CAE4ED">
                                                                                        <div class="textmedium">
                                                                                                <strong>adult content:</strong>
                                                                                                <br/>
                                                                                                <textarea cols="50" name="STANDARD_WARNING" rows="7">
                                                                                                    <xsl:value-of select="MULTI-ELEMENT[@NAME='STANDARD_WARNING']/VALUE-EDITABLE"/>
                                                                                                </textarea>
                                                                                        </div>
                                                                                </td>
                                                                        </tr>
                                                                        <!-- ADDITIONAL WARNING input box -->
                                                                        <tr>
                                                                                <td bgcolor="#CAE4ED">
                                                                                        <div class="textmedium">
                                                                                                <strong>additional warning:</strong>
                                                                                                <br/>
                                                                                                <textarea cols="50" name="ADDITIONAL_WARNING" rows="7">
                                                                                                    <xsl:value-of select="MULTI-ELEMENT[@NAME='ADDITIONAL_WARNING']/VALUE-EDITABLE"/>
                                                                                                </textarea>
                                                                                        </div>
                                                                                </td>
                                                                        </tr>
                                                                        <!-- REPETITIVE FLASH IMAGES checkbox -->
                                                                        <tr>
                                                                                <td bgcolor="#CAE4ED">
                                                                                        <div class="textmedium"><strong>Repetitive Flashing Images</strong>&nbsp;&nbsp;<input
                                                                                                    name="CONTENT_FLASHINGIMAGES" type="checkbox">
                                                                                                    <xsl:if test="MULTI-ELEMENT[@NAME='CONTENT_FLASHINGIMAGES']/VALUE-EDITABLE = 'on'">
                                                                                                    <xsl:attribute name="checked">checked</xsl:attribute>
                                                                                                    </xsl:if>
                                                                                                </input>
                                                                                        </div>
                                                                                </td>
                                                                        </tr>
                                                                        <!-- FILM PROMO BOX input box -->
                                                                        <tr>
                                                                                <td bgcolor="#CAE4ED">
                                                                                        <div class="textxlarge">
                                                                                                <strong>Film Promo Box</strong>
                                                                                                <br/>
                                                                                                <textarea cols="50" name="FILM_PROMO" rows="7">
                                                                                                    <xsl:value-of select="MULTI-ELEMENT[@NAME='FILM_PROMO']/VALUE-EDITABLE"/>
                                                                                                </textarea>
                                                                                        </div>
                                                                                </td>
                                                                        </tr>
                                                                        <!-- RELATED FEATURES input box -->
                                                                        <tr>
                                                                                <td bgcolor="#CAE4ED">
                                                                                        <div class="textxlarge">
                                                                                                <strong>Related Features</strong>
                                                                                                <br/>
                                                                                                <textarea cols="50" name="RELATED_FEATURES" rows="7">
                                                                                                    <xsl:value-of select="MULTI-ELEMENT[@NAME='RELEATED_FEATURES']/VALUE-EDITABLE"/>
                                                                                                </textarea>
                                                                                        </div>
                                                                                </td>
                                                                        </tr>
                                                                </table>
                                                        </div>
                                                </xsl:when>
                                                <!-- list hidden tags to keep variables on page else you lose them, -->
                                                <xsl:otherwise>
                                                        <xsl:apply-templates select="MULTI-ELEMENT"/>
                                                </xsl:otherwise>
                                        </xsl:choose>
                                        <xsl:choose>
                                                <xsl:when test="$test_IsEditor and $article_type_group = 'film'">
                                                        <div class="filmedit">
                                                                <xsl:call-template name="shorts_output">
                                                                        <xsl:with-param name="short_total" select="8"/>
                                                                </xsl:call-template>
                                                                <!--NOTES ID -->
                                                                <table border="0" cellpadding="3" cellspacing="3" width="459">
                                                                        <tr>
                                                                                <td bgcolor="#CAE4ED">
                                                                                        <table border="0" cellpadding="1" cellspacing="0">
                                                                                                <tr>
                                                                                                    <td bgcolor="#CAE4ED" colspan="5">
                                                                                                    <div class="textmedium">
                                                                                                    <strong>Notes Article ID (e.g. A1912899):</strong>
                                                                                                    </div>
                                                                                                    </td>
                                                                                                </tr>
                                                                                                <tr>
                                                                                                    <td bgcolor="#CAE4ED">
                                                                                                    <input class="formboxwidthsmaller" name="NOTESID" type="text">
                                                                                                    <xsl:attribute name="value">
                                                                                                    <xsl:value-of select="MULTI-ELEMENT[@NAME='NOTESID']/VALUE-EDITABLE"/>
                                                                                                    </xsl:attribute>
                                                                                                    </input>
                                                                                                    </td>
                                                                                                </tr>
                                                                                        </table>
                                                                                </td>
                                                                        </tr>
                                                                </table>
                                                                <!-- END NOTES ID -->
                                                                <!-- SERIES -->
                                                                <div id="series">
                                                                        <h3>Series</h3>
                                                                        <label>Is this a series? <input id="series-checkbox" name="IS_SERIES" onclick="showEpisodes(this);" type="checkbox">
                                                                                        <xsl:if test="MULTI-ELEMENT[@NAME='IS_SERIES']/VALUE-EDITABLE = 'on'">
                                                                                                <xsl:attribute name="checked">checked</xsl:attribute>
                                                                                        </xsl:if>
                                                                                </input>
                                                                        </label>
                                                                        <div id="episodes">
                                                                                <label>Length<input name="SERIES_LENGTH" type="text">
                                                                                                <xsl:attribute name="value">
                                                                                                    <xsl:value-of select="MULTI-ELEMENT[@NAME='SERIES_LENGTH']/VALUE-EDITABLE"/>
                                                                                                </xsl:attribute>
                                                                                        </input>
                                                                                </label>
                                                                                <xsl:call-template name="series_output">
                                                                                        <xsl:with-param name="episode_total" select="10"/>
                                                                                </xsl:call-template>
                                                                        </div>
                                                                        <script type="text/javascript">
                                                                                //<![CDATA[
                                                                                        (function(){
                                                                                                var checkbox = document.getElementById('series-checkbox');
                                                                                                showEpisodes(checkbox);
                                                                                        })()
                                                                                
                                                                                        function showEpisodes(checkbox){
                                                                                                var episodesDiv = document.getElementById('episodes');
                                                                                                if(checkbox.checked){
                                                                                                        episodesDiv.style.display = '';
                                                                                                }
                                                                                                else{
                                                                                                        episodesDiv.style.display = 'none';
                                                                                                }
                                                                                        }
                                                                                //]]>
                                                                        </script>
                                                                </div>
                                                                <!-- END SERIES -->
                                                        </div>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                        <!-- show hidden for user or you lose variables -->
                                                        <xsl:apply-templates select="MULTI-ELEMENT"/>
                                                </xsl:otherwise>
                                        </xsl:choose>
                                        <div class="finalsubmit">
                                                <xsl:choose>
                                                        <!-- 'add credit' graphic that updates an article -->
                                                        <xsl:when test="$article_type_group = 'declined' or /H2G2/PARAMS/PARAM[NAME = 's_editcredit']/VALUE = '1'">
                                                                <input alt="add credit" height="22" name="aupdate" src="{$imagesource}furniture/btnlink_add_credit.gif" type="image" width="178"
                                                                        xsl:use-attribute-sets="mMULTI-STAGE_r_articleeditbutton"/>
                                                        </xsl:when>
                                                        <!-- 'add credit' graphic that creates an article -->
                                                        <xsl:when test="$article_type_group = 'credit'">
                                                                <input alt="add credit" height="22" name="acreate" src="{$imagesource}furniture/btnlink_add_credit.gif" type="image" width="178"
                                                                        xsl:use-attribute-sets="mMULTI-STAGE_r_articleeditbutton"/>
                                                        </xsl:when>
                                                        <!-- 'next' graphic that creates an article -->
                                                        <xsl:otherwise>
                                                                <xsl:apply-templates mode="c_articleeditbutton" select="."/>
                                                                <xsl:apply-templates mode="c_articlecreatebutton" select="."/>
                                                        </xsl:otherwise>
                                                </xsl:choose>
                                        </div>
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
        <!-- ##########################################################################################
	editors 
 ############################################################################################-->
        <xsl:template name="FILM_SUBMISSION_EDITFORM_HIDDEN">
                <!-- FORM -->
                <input name="_msfinish" type="hidden" value="yes"/>
                <input name="_msxml" type="hidden" value="{$filmsubmissionfields}"/>
                <input name="details" type="hidden">
                        <xsl:attribute name="value">
                                <xsl:choose>
                                        <xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_details']/VALUE = 'yes'">yes</xsl:when>
                                        <xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_details']/VALUE = 'no'">no</xsl:when>
                                        <xsl:otherwise>
                                                <xsl:value-of select="MULTI-ELEMENT[@NAME='DETAILS']/VALUE-EDITABLE"/>
                                                <xsl:value-of select="GUIDE/DETAILS"/>
                                        </xsl:otherwise>
                                </xsl:choose>
                        </xsl:attribute>
                </input>
                <input name="title" type="hidden">
                        <xsl:attribute name="value">
                                <xsl:value-of select="MULTI-REQUIRED[@NAME='TITLE']/VALUE-EDITABLE"/>
                                <xsl:value-of select="SUBJECT"/>
                        </xsl:attribute>
                </input>
                <input name="originalcredit" type="hidden">
                        <xsl:attribute name="value">
                                <xsl:value-of select="MULTI-REQUIRED[@NAME='ORIGINALCREDIT']/VALUE-EDITABLE"/>
                                <xsl:value-of select="ORIGINALCREDIT"/>
                        </xsl:attribute>
                </input>
                <input name="your_role" type="hidden">
                        <xsl:attribute name="value">
                                <xsl:value-of select="MULTI-REQUIRED[@NAME='YOUR_ROLE']/VALUE-EDITABLE"/>
                                <xsl:value-of select="YOUR_ROLE"/>
                        </xsl:attribute>
                </input>
                <input name="TYPE" type="hidden">
                        <xsl:attribute name="value">
                                <xsl:value-of select="/H2G2/ARTICLE/EXTRAINFO/TYPE/@ID"/>
                        </xsl:attribute>
                </input>
                <xsl:apply-templates select="MULTI-ELEMENT"/>
                <xsl:apply-templates select="GUIDE"/>
        </xsl:template>
        <!-- Two templates to create hidden fields -->
        <xsl:template match="MULTI-ELEMENT">
                <input name="{@NAME}" type="hidden">
                        <xsl:attribute name="value">
                                <xsl:value-of select="VALUE-EDITABLE"/>
                        </xsl:attribute>
                </input>
        </xsl:template>
        <xsl:template match="GUIDE">
                <xsl:for-each select="./*">
                        <input name="{name()}" type="hidden">
                                <xsl:if test=". = ('FILMLENGTH_MINS' or 'FILMLENGTH_SECS' or 'TAPE_FORMAT'      or 'ORIGINAL FORMAT' or 'YEAR_PRODUCTION')">
                                        <xsl:attribute name="size">4</xsl:attribute>
                                </xsl:if>
                                <xsl:attribute name="value">
                                        <xsl:value-of select="."/>
                                </xsl:attribute>
                        </input>
                </xsl:for-each>
        </xsl:template>
        <!-- END -->
        <xsl:template name="FRONTPAGE_EDITFORM">
                <xsl:apply-templates mode="c_typedarticle" select="/H2G2/MULTI-STAGE/MULTI-REQUIRED/ERRORS/ERROR | /H2G2/MULTI-STAGE/MULTI-ELEMENT/ERRORS/ERROR"/>
                <input name="_msfinish" type="hidden" value="yes"/>
                <input name="_msxml" type="hidden" value="{$frontpagefields}"/>
                <h3>FRONTPAGE</h3>
                <strong>Title:</strong>
                <br/>
                <xsl:apply-templates mode="t_articletitle" select="."/>
                <p/>
                <strong>Main content:</strong>
                <br/>
                <textarea cols="75" name="body" rows="40">
                        <xsl:value-of select="MULTI-REQUIRED[@NAME='BODY']/VALUE-EDITABLE"/>
                </textarea>
                <br/>
                <br/>
        </xsl:template>
        <xsl:template name="shorts_output">
                <xsl:param name="short_total"/>
                <xsl:param name="short" select="1"/>
                <xsl:if test="$short &lt;= $short_total">
                        <table border="0" cellpadding="3" cellspacing="3" width="459">
                                <tr>
                                        <td bgcolor="#CAE4ED">
                                                <table border="0" cellpadding="1" cellspacing="0">
                                                        <tr>
                                                                <td bgcolor="#CAE4ED" colspan="5">
                                                                        <div class="textmedium">
                                                                                <strong>
                                                                                        <xsl:value-of select="concat('Short ', $short , ':')"/>
                                                                                </strong>
                                                                        </div>
                                                                </td>
                                                        </tr>
                                                        <tr>
                                                                <td bgcolor="#CAE4ED">
                                                                        <div class="textmedium">
                                                                                <strong>Short title</strong>
                                                                        </div>
                                                                </td>
                                                                <td bgcolor="#CAE4ED">
                                                                        <div class="textmedium">
                                                                                <strong>a-number</strong>
                                                                        </div>
                                                                </td>
                                                                <td bgcolor="#CAE4ED">
                                                                        <div class="textmedium">
                                                                                <strong>length</strong>
                                                                        </div>
                                                                </td>
                                                                <td bgcolor="#CAE4ED"/>
                                                                <td bgcolor="#CAE4ED">
                                                                        <div class="textmedium">
                                                                                <strong>genre</strong>
                                                                        </div>
                                                                </td>
                                                        </tr>
                                                        <tr>
                                                                <td bgcolor="#CAE4ED">
                                                                        <input class="formboxwidthsmaller" name="{concat('SHORT', $short,          '_TITLE')}" type="text">
                                                                                <xsl:attribute name="value">
                                                                                        <xsl:value-of select="MULTI-ELEMENT[@NAME = concat('SHORT', $short, '_TITLE')]/VALUE-EDITABLE"/>
                                                                                </xsl:attribute>
                                                                        </input>
                                                                </td>
                                                                <td bgcolor="#CAE4ED">
                                                                        <input class="formboxwidthanumber" name="{concat('SHORT', $short,          '_ANUMBER')}" type="text">
                                                                                <xsl:attribute name="value">
                                                                                        <xsl:value-of select="MULTI-ELEMENT[@NAME = concat('SHORT', $short,            '_ANUMBER')]/VALUE-EDITABLE"/>
                                                                                </xsl:attribute>
                                                                        </input>
                                                                </td>
                                                                <td bgcolor="#CAE4ED">
                                                                        <input class="formboxwidthxsmall" name="{concat('SHORT', $short,          '_LENGTH_MIN')}" type="text">
                                                                                <xsl:attribute name="value">
                                                                                        <xsl:value-of select="MULTI-ELEMENT[@NAME = concat('SHORT', $short,            '_LENGTH_MIN')]/VALUE-EDITABLE"/>
                                                                                </xsl:attribute>
                                                                        </input>
                                                                </td>
                                                                <td bgcolor="#CAE4ED">
                                                                        <input class="formboxwidthxsmall" name="{concat('SHORT', $short,          '_LENGTH_SEC')}" type="text">
                                                                                <xsl:attribute name="value">
                                                                                        <xsl:value-of select="MULTI-ELEMENT[@NAME = concat('SHORT', $short,            '_LENGTH_SEC')]/VALUE-EDITABLE"/>
                                                                                </xsl:attribute>
                                                                        </input>
                                                                </td>
                                                                <td bgcolor="#CAE4ED">
                                                                        <select class="formboxwidthsmaller" name="{concat('SHORT', $short,          '_GENRE')}">
                                                                                <option value="">choose...</option>
                                                                                <option value="drama"><xsl:if test="MULTI-ELEMENT[@NAME = concat('SHORT', $short, '_GENRE')]/VALUE-EDITABLE = 'drama'">
                                                                                                <xsl:attribute name="selected">selected</xsl:attribute>
                                                                                        </xsl:if>drama</option>
                                                                                <option value="comedy"><xsl:if test="MULTI-ELEMENT[@NAME = concat('SHORT', $short, '_GENRE')]/VALUE-EDITABLE = 'comedy'">
                                                                                                <xsl:attribute name="selected">selected</xsl:attribute>
                                                                                        </xsl:if>comedy</option>
                                                                                <option value="documentary"><xsl:if
                                                                                                test="MULTI-ELEMENT[@NAME = concat('SHORT', $short, '_GENRE')]/VALUE-EDITABLE = 'documentary'">
                                                                                                <xsl:attribute name="selected">selected</xsl:attribute>
                                                                                        </xsl:if>documentary</option>
                                                                                <option value="animation"><xsl:if
                                                                                                test="MULTI-ELEMENT[@NAME = concat('SHORT', $short, '_GENRE')]/VALUE-EDITABLE = 'animation'">
                                                                                                <xsl:attribute name="selected">selected</xsl:attribute>
                                                                                        </xsl:if>animation</option>
                                                                                <option value="experimental"><xsl:if
                                                                                                test="MULTI-ELEMENT[@NAME = concat('SHORT', $short, '_GENRE')]/VALUE-EDITABLE = 'experimental'">
                                                                                                <xsl:attribute name="selected">selected</xsl:attribute>
                                                                                        </xsl:if>experimental</option>
                                                                                <option value="music"><xsl:if test="MULTI-ELEMENT[@NAME = concat('SHORT', $short, '_GENRE')]/VALUE-EDITABLE = 'music'">
                                                                                                <xsl:attribute name="selected">selected</xsl:attribute>
                                                                                        </xsl:if>music</option>
                                                                        </select>
                                                                </td>
                                                        </tr>
                                                </table>
                                        </td>
                                </tr>
                        </table>
                        <xsl:call-template name="shorts_output">
                                <xsl:with-param name="short_total" select="$short_total"/>
                                <xsl:with-param name="short" select="$short + 1"/>
                        </xsl:call-template>
                </xsl:if>
        </xsl:template>
        <xsl:template name="series_output">
                <xsl:param name="episode_total"/>
                <xsl:param name="episode_no" select="1"/>
                <xsl:if test="$episode_no &lt;= $episode_total">
                        <div class="episode">
                                <h4>
                                        <xsl:value-of select="concat('Episode ', $episode_no, ':')"/>
                                </h4>
                                <div class="episode-info">
                                        <label for="{concat('EPISODE', $episode_no, '_TITLE')}">Episode Title</label>
                                        <input id="{concat('EPISODE', $episode_no, '_TITLE')}" name="{concat('EPISODE', $episode_no, '_TITLE')}" type="text">
                                                <xsl:attribute name="value">
                                                        <xsl:value-of select="MULTI-ELEMENT[@NAME = concat('EPISODE', $episode_no, '_TITLE')]/VALUE-EDITABLE"/>
                                                </xsl:attribute>
                                        </input>
                                </div>
                                <div class="episode-info">
                                        <label for="{concat('EPISODE', $episode_no, '_ANUMBER')}">A-Number</label>
                                        <input id="{concat('EPISODE', $episode_no, '_ANUMBER')}" name="{concat('EPISODE', $episode_no, '_ANUMBER')}" type="text">
                                                <xsl:attribute name="value">
                                                        <xsl:value-of select="MULTI-ELEMENT[@NAME = concat('EPISODE', $episode_no, '_ANUMBER')]/VALUE-EDITABLE"/>
                                                </xsl:attribute>
                                        </input>
                                </div>
                                <div class="episode-info">
                                        <label for="{concat('EPISODE', $episode_no, '_IMAGE')}">Image Source</label>
                                        <input id="{concat('EPISODE', $episode_no, '_IMAGE')}" name="{concat('EPISODE', $episode_no, '_IMAGE')}" type="text">
                                                <xsl:attribute name="value">
                                                        <xsl:value-of select="MULTI-ELEMENT[@NAME = concat('EPISODE', $episode_no, '_IMAGE')]/VALUE-EDITABLE"/>
                                                </xsl:attribute>
                                        </input>
                                </div>
                                <div class="episode-info">
                                        <label for="{concat('EPISODE', $episode_no, '_DESCRIPTION')}">Description</label>
                                        <textarea cols="30" id="{concat('EPISODE', $episode_no, '_DESCRIPTION')}" name="{concat('EPISODE', $episode_no, '_DESCRIPTION')}" rows="5">
                                                <xsl:value-of select="MULTI-ELEMENT[@NAME = concat('EPISODE', $episode_no, '_DESCRIPTION')]/VALUE-EDITABLE"/>
                                        </textarea>
                                </div>
                        </div>
                        <xsl:call-template name="series_output">
                                <xsl:with-param name="episode_total" select="$episode_total"/>
                                <xsl:with-param name="episode_no" select="$episode_no + 1"/>
                        </xsl:call-template>
                </xsl:if>
        </xsl:template>
        <!-- INPUT BOXES -->
        <!-- year of production -->
        <xsl:template name="yearOfProduction">
                <xsl:param name="year" select="2000"/>
                <option value="{$year}">
                        <xsl:if test="MULTI-ELEMENT[@NAME='YEARPRODUCTION']/VALUE-EDITABLE = $year">
                                <xsl:attribute name="selected">selected</xsl:attribute>
                        </xsl:if>
                        <xsl:value-of select="$year"/>
                </option>
                <xsl:if test="$year &lt;  /H2G2/DATE/@YEAR">
                        <xsl:call-template name="yearOfProduction">
                                <xsl:with-param name="year" select="$year + 1"/>
                        </xsl:call-template>
                </xsl:if>
        </xsl:template>
        <!-- region input boxes -->
        <xsl:template name="region">
                <option value="{@name}">
                        <xsl:if test="$xmlRoot/H2G2/MULTI-STAGE/MULTI-ELEMENT[@NAME =    'REGION']/VALUE-EDITABLE = current()/@name">
                                <xsl:attribute name="selected">selected</xsl:attribute>
                        </xsl:if>
                        <xsl:value-of select="@name"/>
                </option>
        </xsl:template>
        <!-- useful links input boxes -->
        <xsl:template name="usefulLinks">
                <xsl:param name="maxRows"/>
                <xsl:param name="currentRow" select="1"/>
                <xsl:if test="$test_IsEditor">
                        <tr>
                                <td colspan="5">
                                        <div class="textmedium">
                                                <strong>Link <xsl:value-of select="$currentRow"/> title</strong>
                                                <br/>
                                                <input class="formboxwidthlarge" name="USEFULLINKS{$currentRow}_TEXT" type="text">
                                                        <xsl:attribute name="value">
                                                                <xsl:value-of select="MULTI-ELEMENT[@NAME = concat('USEFULLINKS', $currentRow,          '_TEXT')]/VALUE-EDITABLE"/>
                                                        </xsl:attribute>
                                                </input>
                                        </div>
                                </td>
                        </tr>
                </xsl:if>
                <tr>
                        <td colspan="5">
                                <div class="textmedium">
                                        <strong>Link <xsl:value-of select="$currentRow"/></strong>
                                        <br/>
                                        <input class="formboxwidthlarge" name="USEFULLINKS{$currentRow}" type="text">
                                                <xsl:attribute name="value">
                                                        <xsl:value-of select="MULTI-ELEMENT[@NAME = concat('USEFULLINKS', $currentRow)]/VALUE-EDITABLE"/>
                                                </xsl:attribute>
                                        </input>
                                </div>
                                <br/>
                        </td>
                </tr>
                <xsl:if test="$currentRow &lt; $maxRows">
                        <xsl:call-template name="usefulLinks">
                                <xsl:with-param name="maxRows" select="$maxRows"/>
                                <xsl:with-param name="currentRow" select="$currentRow + 1"/>
                        </xsl:call-template>
                </xsl:if>
        </xsl:template>
        <!-- output crew input boxes -->
        <xsl:template name="crewRows">
                <xsl:param name="crewMember"/>
                <xsl:param name="crewMemberUC"/>
                <xsl:param name="root"/>
                <tr>
                        <td width="189">
                                <div class="formtitle">
                                        <strong><xsl:value-of select="$crewMember"/>:</strong>
                                </div>
                        </td>
                        <td colspan="4">
                                <input class="formboxwidthmedium2" name="CREW_{$crewMemberUC}" size="30" type="text">
                                        <xsl:attribute name="value">
                                                <xsl:value-of select="$root//H2G2/MULTI-STAGE/MULTI-ELEMENT[@NAME = concat('CREW_', $crewMemberUC)]/VALUE-EDITABLE"/>
                                        </xsl:attribute>
                                </input>
                        </td>
                </tr>
        </xsl:template>
        <!-- output other crew input boxes -->
        <xsl:template name="otherCrewRows">
                <xsl:param name="maxRows"/>
                <xsl:param name="currentRow" select="1"/>
                <tr>
                        <td>
                                <input name="CREW{$currentRow}_OTHER_NAME" size="33" type="text">
                                        <xsl:attribute name="value">
                                                <xsl:value-of select="MULTI-ELEMENT[@NAME = concat('CREW', $currentRow,        '_OTHER_NAME')]/VALUE-EDITABLE"/>
                                        </xsl:attribute>
                                </input>
                        </td>
                        <td>
                                <input name="CREW{$currentRow}_OTHER_ROLE" size="33" type="text">
                                        <xsl:attribute name="value">
                                                <xsl:value-of select="MULTI-ELEMENT[@NAME = concat('CREW', $currentRow,        '_OTHER_ROLE')]/VALUE-EDITABLE"/>
                                        </xsl:attribute>
                                </input>
                        </td>
                </tr>
                <xsl:if test="$currentRow &lt; $maxRows">
                        <xsl:call-template name="otherCrewRows">
                                <xsl:with-param name="maxRows" select="$maxRows"/>
                                <xsl:with-param name="currentRow" select="$currentRow + 1"/>
                        </xsl:call-template>
                </xsl:if>
        </xsl:template>
        <!-- output cast input boxes -->
        <xsl:template name="castRows">
                <xsl:param name="maxRows"/>
                <xsl:param name="currentRow" select="1"/>
                <tr>
                        <td width="150">
                                <div class="formtitle">
                                        <strong>cast <xsl:value-of select="$currentRow"/>:</strong>
                                </div>
                        </td>
                        <td width="144">
                                <input class="formboxwidthsmaller" name="CAST{$currentRow}_CHARACTER_NAME" size="30" type="text">
                                        <xsl:attribute name="value">
                                                <xsl:value-of select="MULTI-ELEMENT[@NAME = concat('CAST', $currentRow,        '_CHARACTER_NAME')]/VALUE-EDITABLE"/>
                                        </xsl:attribute>
                                </input>
                        </td>
                        <td width="21"/>
                        <td width="144">
                                <input class="formboxwidthsmaller" name="CAST{$currentRow}_NAME" size="30" type="text">
                                        <xsl:attribute name="value">
                                                <xsl:value-of select="MULTI-ELEMENT[@NAME = concat('CAST', $currentRow, '_NAME')]/VALUE-EDITABLE"/>
                                        </xsl:attribute>
                                </input>
                        </td>
                </tr>
                <xsl:if test="$currentRow &lt; $maxRows">
                        <xsl:call-template name="castRows">
                                <xsl:with-param name="maxRows" select="$maxRows"/>
                                <xsl:with-param name="currentRow" select="$currentRow + 1"/>
                        </xsl:call-template>
                </xsl:if>
        </xsl:template>
        <!-- output festival, screenings and awards input boxes -->
        <xsl:template name="festivalRows">
                <xsl:param name="maxRows"/>
                <xsl:param name="currentRow" select="1"/>
                <tr>
                        <td>
                                <input name="FESTIVAL{$currentRow}_AWARD" size="18" type="text">
                                        <xsl:attribute name="value">
                                                <xsl:value-of select="MULTI-ELEMENT[@NAME = concat('FESTIVAL', $currentRow, '_AWARD')]/VALUE-EDITABLE"/>
                                        </xsl:attribute>
                                </input>
                        </td>
                        <td>
                                <input name="FESTIVAL{$currentRow}_NAME" size="17" type="text">
                                        <xsl:attribute name="value">
                                                <xsl:value-of select="MULTI-ELEMENT[@NAME = concat('FESTIVAL', $currentRow, '_NAME')]/VALUE-EDITABLE"/>
                                        </xsl:attribute>
                                </input>
                        </td>
                        <td>
                                <input name="FESTIVAL{$currentRow}_PLACE" size="17" type="text">
                                        <xsl:attribute name="value">
                                                <xsl:value-of select="MULTI-ELEMENT[@NAME = concat('FESTIVAL', $currentRow, '_PLACE')]/VALUE-EDITABLE"/>
                                        </xsl:attribute>
                                </input>
                        </td>
                        <td>
                                <input name="FESTIVAL{$currentRow}_YEAR" size="4" type="text">
                                        <xsl:attribute name="value">
                                                <xsl:value-of select="MULTI-ELEMENT[@NAME = concat('FESTIVAL', $currentRow, '_YEAR')]/VALUE-EDITABLE"/>
                                        </xsl:attribute>
                                </input>
                        </td>
                </tr>
                <xsl:if test="$currentRow &lt; $maxRows">
                        <xsl:call-template name="festivalRows">
                                <xsl:with-param name="maxRows" select="$maxRows"/>
                                <xsl:with-param name="currentRow" select="$currentRow + 1"/>
                        </xsl:call-template>
                </xsl:if>
        </xsl:template>
</xsl:stylesheet>
