<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet exclude-result-prefixes="msxsl local s dt" version="1.0" xmlns:dt="urn:schemas-microsoft-com:datatypes" xmlns:local="#local-functions" xmlns:msxsl="urn:schemas-microsoft-com:xslt"
        xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
        <xsl:template name="FILM__NOTE_SUBMISSION_EDITFORM">
                <!-- DEBUG -->
                <xsl:call-template name="TRACE">
                        <xsl:with-param name="message">FILM_NOTE_SUBMISSION</xsl:with-param>
                        <xsl:with-param name="pagename">formnotessubmission.xsl</xsl:with-param>
                </xsl:call-template>
                <!-- DEBUG -->
                <!-- FORM -->
                <input name="_msxml" type="hidden" value="{$filmmakersnotes}"/>
                <input type="hidden" name="_msstage" value="1" />
                <input type="hidden" name="HID" value="{/H2G2/MULTI-STAGE/MULTI-ELEMENT[@NAME='HID']/VALUE}" />
                <!-- this is the type number of the article you want to create -->
                <xsl:choose>
                        <xsl:when test="$current_article_type = 30">
                                <input name="type" type="hidden" value="90"/>
                        </xsl:when>
                        <xsl:when test="$current_article_type = 31">
                                <input name="type" type="hidden" value="91"/>
                        </xsl:when>
                        <xsl:when test="$current_article_type = 32">
                                <input name="type" type="hidden" value="92"/>
                        </xsl:when>
                        <xsl:when test="$current_article_type = 33">
                                <input name="type" type="hidden" value="93"/>
                        </xsl:when>
                        <xsl:when test="$current_article_type = 34">
                                <input name="type" type="hidden" value="94"/>
                        </xsl:when>
                        <xsl:when test="$current_article_type = 35">
                                <input name="type" type="hidden" value="95"/>
                        </xsl:when>
                </xsl:choose>
                <input name="_msfinish" type="hidden" value="yes"/>
                <!-- then need to make notes form and notes viewing template -->
                <input name="title" type="hidden" value="{/H2G2/MULTI-STAGE/MULTI-REQUIRED[@NAME='TITLE']/VALUE}"/>
                <input name="body" type="hidden" value="{/H2G2/MULTI-STAGE/MULTI-REQUIRED[@NAME='BODY']/VALUE}"/>
                <!-- these are the nodes that you want to copy -->
                <input name="DIRECTORSNAME" type="hidden" value="{/H2G2/MULTI-STAGE/MULTI-ELEMENT[@NAME='DIRECTORSNAME']/VALUE}"/>
                <input name="FILMLENGTH_MINS" type="hidden" value="{/H2G2/MULTI-STAGE/MULTI-ELEMENT[@NAME='FILMLENGTH_MINS']/VALUE}"/>
                <input name="YEARPRODUCTION" type="hidden" value="{/H2G2/MULTI-STAGE/MULTI-ELEMENT[@NAME='YEARPRODUCTION']/VALUE}"/>
                <input name="REGION" type="hidden" value="{/H2G2/MULTI-STAGE/MULTI-ELEMENT[@NAME='REGION']/VALUE}"/>
                <input name="DESCRIPTION" type="hidden" value="{/H2G2/MULTI-STAGE/MULTI-ELEMENT[@NAME='DESCRIPTION']/VALUE}"/>
                <input name="STATUS" type="hidden" value="3"/>
                <input name="ARTICLEFORUMSTYLE" type="hidden" value="0"/>
                <table border="0" cellpadding="0" cellspacing="0" class="submistablebg topmargin editbiog" width="635">
                        <tr>
                                <td colspan="3" valign="bottom" width="635">
                                        <img alt="" class="tiny" height="57" src="{$imagesource}furniture/submission/submissiontop.gif" width="635"/>
                                </td>
                        </tr>
                        <tr>
                                <td class="subleftcolbg" valign="top" width="88">
                                        <img alt="" height="29" src="{$imagesource}furniture/submission/submissiontopleftcorner.gif" width="88"/>
                                </td>
                                <td valign="top" width="459">
                                        <table border="0" cellpadding="0" cellspacing="0" class="steps4">
                                                <tr>
                                                        <td class="currentStep">&nbsp;</td>
                                                </tr>
                                        </table>
                                        <h1 class="image">
                                                <img alt="add filmmakers' notes" height="29" src="{$imagesource}furniture/title_add_fillmmakers_notes.gif" width="283"/>
                                        </h1>
                                        <p class="textmedium">This is your chance to tell other users more about the background of your film and to offer other filmmakers any tips that you have learnt
                                                through the experience of making it. All the fields are optional, fill out whatever you like and use the general box to add anything else you think is
                                                relevant.</p>
                                        <div class="hr2"/>
                                        <h3>What is your name? What was your role on this short?</h3>
                                        <textarea class="formboxwidthlarge" name="NOTE_TEXT1" rows="5">
                                                <xsl:value-of select="MULTI-ELEMENT[@NAME='NOTE_TEXT1']/VALUE-EDITABLE"/>
                                        </textarea>
                                        <div class="hr"/>
                                        <h3>What was the inspiration for your short and what ideas were you exploring?</h3>
                                        <textarea class="formboxwidthlarge" name="NOTE_TEXT2" rows="5">
                                                <xsl:value-of select="MULTI-ELEMENT[@NAME='NOTE_TEXT2']/VALUE-EDITABLE"/>
                                        </textarea>
                                        <div class="hr"/>
                                        <h3>Where did you find your cast and crew?</h3>
                                        <textarea class="formboxwidthlarge" name="NOTE_TEXT3" rows="5">
                                                <xsl:value-of select="MULTI-ELEMENT[@NAME='NOTE_TEXT3']/VALUE-EDITABLE"/>
                                        </textarea>
                                        <div class="hr"/>
                                        <h3>What was the biggest challenge in making your short?</h3>
                                        <textarea class="formboxwidthlarge" name="NOTE_TEXT4" rows="5">
                                                <xsl:value-of select="MULTI-ELEMENT[@NAME='NOTE_TEXT4']/VALUE-EDITABLE"/>
                                        </textarea>
                                        <div class="hr"/>
                                        <h3>If you could go back, what would you do differently?</h3>
                                        <textarea class="formboxwidthlarge" name="NOTE_TEXT5" rows="5">
                                                <xsl:value-of select="MULTI-ELEMENT[@NAME='NOTE_TEXT5']/VALUE-EDITABLE"/>
                                        </textarea>
                                        <div class="hr"/>
                                        <h3>What opportunities has this short opened up for you?</h3>
                                        <textarea class="formboxwidthlarge" name="NOTE_TEXT6" rows="5">
                                                <xsl:value-of select="MULTI-ELEMENT[@NAME='NOTE_TEXT6']/VALUE-EDITABLE"/>
                                        </textarea>
                                        <div class="hr"/>
                                        <h3>What advice would you give to other filmmakers?</h3>
                                        <textarea class="formboxwidthlarge" name="NOTE_TEXT7" rows="5">
                                                <xsl:value-of select="MULTI-ELEMENT[@NAME='NOTE_TEXT7']/VALUE-EDITABLE"/>
                                        </textarea>
                                        <div class="hr"/>
                                        <h3>Any further comments or information about your short?</h3>
                                        <textarea class="formboxwidthlarge" name="NOTE_TEXT8" rows="5">
                                                <xsl:value-of select="MULTI-ELEMENT[@NAME='NOTE_TEXT8']/VALUE-EDITABLE"/>
                                        </textarea>
                                        <div class="hr"/>
                                        <div class="formBtnLink">
                                                <input alt="publish filmmaker's notes" height="23" name="acreate" src="{$imagesource}furniture/btnlink_publish_notes.gif" type="image" width="437"
                                                        xsl:use-attribute-sets="mMULTI-STAGE_r_articleeditbutton">
                                                        <xsl:attribute name="name">
                                                                <xsl:choose>
                                                                        <xsl:when test="/H2G2/MULTI-STAGE/@TYPE = 'TYPED-ARTICLE-CREATE'">acreate</xsl:when>
                                                                        <xsl:otherwise>aupdate</xsl:otherwise>
                                                                </xsl:choose>
                                                        </xsl:attribute>
                                                </input>
                                        </div>
                                        <!--
		<div class="finalsubmit">
			<xsl:apply-templates select="." mode="c_articleeditbutton"/>
			<xsl:apply-templates select="." mode="c_articlecreatebutton"/>
		</div>
		-->
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
</xsl:stylesheet>
