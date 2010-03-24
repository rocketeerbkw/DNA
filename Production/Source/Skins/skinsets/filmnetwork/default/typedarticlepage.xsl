<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet exclude-result-prefixes="msxsl local s dt" version="1.0" xmlns:dt="urn:schemas-microsoft-com:datatypes" xmlns:local="#local-functions" xmlns:msxsl="urn:schemas-microsoft-com:xslt"
        xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
        <!-- #################################################
     ARTICLE PAGE TEMPLATE TYPES
	 discussion page: discussion_index_page  articlepage.xsl
					  DISCUSSION_INDEX_PAGE_EDITFORM  filmsubmission.xsl
	 
	 flim submission: filmsubmission_approved   articlepage.xsl
				 	  filmsubmission_nonapproved   articlepage.xsl
					  FILM_SUBMISSION_EDITFORM    filmsubmission.xsl

     ############################################### -->
        <xsl:import href="../../../base/base-typedarticle.xsl"/>
        <xsl:import href="formeditintro.xsl"/>
        <xsl:import href="formfilmsubmission.xsl"/>
        <xsl:import href="formnotessubmission.xsl"/>
        <xsl:variable name="userintrofields">
                <![CDATA[
		<MULTI-INPUT>
			<REQUIRED NAME='TYPE'></REQUIRED>
			<REQUIRED NAME='BODY'><VALIDATE TYPE='EMPTY'/></REQUIRED>
			<REQUIRED NAME='TITLE'></REQUIRED>
			<ELEMENT NAME='BACKGROUND'></ELEMENT>
			<ELEMENT NAME='PROJECTINDEVELOPMENT'></ELEMENT>
			<ELEMENT NAME='FAVFILMS'></ELEMENT>
			<ELEMENT NAME='PUBLISH_INDUSTRY_IMG'></ELEMENT>
			<ELEMENT NAME='NUMBEROFAPPROVEDFILMS' EI='add'></ELEMENT>
			<ELEMENT NAME='LOCATION' EI='add'></ELEMENT>
			<ELEMENT NAME='LOCATION_ID' EI='add'></ELEMENT>
			<ELEMENT NAME='SPECIALISM1' EI='add'></ELEMENT>
			<ELEMENT NAME='SPECIALISM2' EI='add'></ELEMENT>
			<ELEMENT NAME='SPECIALISM3' EI='add'></ELEMENT>
			<ELEMENT NAME='SPECIALISM1_ID' EI='add'></ELEMENT>
			<ELEMENT NAME='SPECIALISM2_ID' EI='add'></ELEMENT>
			<ELEMENT NAME='SPECIALISM3_ID' EI='add'></ELEMENT>
			<ELEMENT NAME='TBC'></ELEMENT>
			<ELEMENT NAME='ORGINFO'></ELEMENT>
			<ELEMENT NAME='MYLINKS1'></ELEMENT>
			<ELEMENT NAME='MYLINKS1_TEXT'></ELEMENT>
			<ELEMENT NAME='MYLINKS2'></ELEMENT>
			<ELEMENT NAME='MYLINKS2_TEXT'></ELEMENT>
			<ELEMENT NAME='MYLINKS3'></ELEMENT>
			<ELEMENT NAME='MYLINKS3_TEXT'></ELEMENT>
			<ELEMENT NAME='TEST' EI='add'></ELEMENT>
		</MULTI-INPUT>
		]]>
        </xsl:variable>
        <xsl:variable name="articlefields">
                <![CDATA[
		<MULTI-INPUT>
			<REQUIRED NAME='TYPE'></REQUIRED>
			<REQUIRED NAME='BODY'></REQUIRED>
			<REQUIRED NAME='TITLE'></REQUIRED>
		</MULTI-INPUT>
		]]>
        </xsl:variable>
        <xsl:variable name="magazinearticlefields">
                <![CDATA[
		<MULTI-INPUT>
			<REQUIRED NAME='TYPE'></REQUIRED>
			<REQUIRED NAME='BODY'></REQUIRED>
			<REQUIRED NAME='TITLE'></REQUIRED>
			<ELEMENT NAME='DESCRIPTION'><VALIDATE TYPE='EMPTY'/></ELEMENT>
			<ELEMENT NAME='CATEGORYNAME' EI='add'></ELEMENT>
			<ELEMENT NAME='CATEGORYNUMBER' EI='add'></ELEMENT>
			<ELEMENT NAME='TEST' EI='add'></ELEMENT>
		</MULTI-INPUT>
		]]>
        </xsl:variable>
        <xsl:variable name="frontpagefields">
                <![CDATA[
		<MULTI-INPUT>
			<REQUIRED NAME='TYPE'></REQUIRED>
			<REQUIRED NAME='BODY'></REQUIRED>
			<REQUIRED NAME='TITLE'></REQUIRED>
		</MULTI-INPUT>
		]]>
        </xsl:variable>
        <xsl:variable name="filmsubmissionfields">
                <![CDATA[
		<MULTI-INPUT>
			<REQUIRED NAME='TYPE'></REQUIRED>
			<REQUIRED NAME='BODY'><VALIDATE TYPE='EMPTY'/></REQUIRED>
			<REQUIRED NAME='TITLE'><VALIDATE TYPE='EMPTY'/></REQUIRED>
			<ELEMENT NAME='ARTICLEFORUMSTYLE'></ELEMENT>
			<ELEMENT NAME='DIRECTORSNAME' EI='add'><VALIDATE TYPE='EMPTY'/></ELEMENT>
			<ELEMENT NAME='FILMLENGTH_MINS' EI='add'><VALIDATE TYPE='EMPTY'/></ELEMENT>
			<ELEMENT NAME='FILMLENGTH_SECS' EI='add'><VALIDATE TYPE='EMPTY'/></ELEMENT>
			<ELEMENT NAME='YEARPRODUCTION'><VALIDATE TYPE='EMPTY'/></ELEMENT>
			<ELEMENT NAME='TAPEFORMAT'><VALIDATE TYPE='EMPTY'/></ELEMENT>
			<ELEMENT NAME='ORIGINALFORMAT'></ELEMENT><!-- <VALIDATE TYPE='EMPTY'/> -->
			<ELEMENT NAME='REGION' EI='add'><VALIDATE TYPE='EMPTY'/></ELEMENT>
			<ELEMENT NAME='REGION-OTHER' EI='add'></ELEMENT>
			<ELEMENT NAME='LANGUAGE' EI='add'><VALIDATE TYPE='EMPTY'/></ELEMENT>
			<ELEMENT NAME='LANGUAGE-OTHER' EI='add'></ELEMENT>
			<ELEMENT NAME='DESCRIPTION'><VALIDATE TYPE='EMPTY'/></ELEMENT>
			<ELEMENT NAME='DECLARATION_READSUBBMISSION'><VALIDATE TYPE='EMPTY'/></ELEMENT>
			<ELEMENT NAME='DECLARATION_CLEARANCEPROCEDURE'><VALIDATE TYPE='EMPTY'/></ELEMENT>
			<ELEMENT NAME='DECLARATION_NORETURNTAPE'><VALIDATE TYPE='EMPTY'/></ELEMENT>
			<ELEMENT NAME='FILMMAKERSCOMMENTS'></ELEMENT>
			<ELEMENT NAME='NOTESID' EI='add'></ELEMENT>
			<ELEMENT NAME='FILM_STATUS_MSG' EI='add'></ELEMENT>
			<ELEMENT NAME='DETAILS'></ELEMENT>
			<ELEMENT NAME='ORIGINALCREDIT'></ELEMENT>
			<ELEMENT NAME='POLLTYPE1'></ELEMENT>
			<ELEMENT NAME='STILLS_GALLERY'></ELEMENT>
			<ELEMENT NAME='SUBTITLED'></ELEMENT>
			<ELEMENT NAME='HI_RES_DOWNLOAD'></ELEMENT>
			<ELEMENT NAME='AVAIL_DAY'></ELEMENT>
			<ELEMENT NAME='AVAIL_MONTH'></ELEMENT>
			<ELEMENT NAME='AVAIL_YEAR'></ELEMENT>
			<ELEMENT NAME='STREAMING_NARROW'></ELEMENT>
			<ELEMENT NAME='STREAMING_BROADBAND'></ELEMENT>
			<ELEMENT NAME='WHYDECLINED' EI='add'></ELEMENT>
			<ELEMENT NAME='WINPLAYER'></ELEMENT>
			<ELEMENT NAME='REALPLAYER'></ELEMENT>
			<ELEMENT NAME='PLAYER_SIZE' EI='add'></ELEMENT>
			<ELEMENT NAME='CONTENT_VIOLENCE'></ELEMENT>
			<ELEMENT NAME='CONTENT_LANGUAGE'></ELEMENT>
			<ELEMENT NAME='CONTENT_SEXUAL'></ELEMENT>
			<ELEMENT NAME='CONTENT_DISTURBING'></ELEMENT>
			<ELEMENT NAME='CONTENT_VIOLENCE_ADDITIONAL'></ELEMENT>
			<ELEMENT NAME='CONTENT_LANGUAGE_ADDITIONAL'></ELEMENT>
			<ELEMENT NAME='CONTENT_SEXUAL_ADDITIONAL'></ELEMENT>
			<ELEMENT NAME='CONTENT_DISTURBING_ADDITIONAL'></ELEMENT>
			<ELEMENT NAME='CONTENT_FLASHINGIMAGES'></ELEMENT>
			<ELEMENT NAME='PUBLISH_INDUSTRY_IMG'></ELEMENT>
			<ELEMENT NAME='STANDARD_WARNING' EI='add'></ELEMENT>
			<ELEMENT NAME='ADDITIONAL_WARNING'></ELEMENT>
			<ELEMENT NAME='FESTIVALAWARDS'></ELEMENT>
			<ELEMENT NAME='DISTDETAILS'></ELEMENT>
			<ELEMENT NAME='FUNDINGDETAILS'></ELEMENT>
			<ELEMENT NAME='CREW_DIRECTOR'></ELEMENT>
			<ELEMENT NAME='CREW_WRITER'></ELEMENT>
			<ELEMENT NAME='CREW_PRODUCER'></ELEMENT>
			<ELEMENT NAME='CREW_EDITOR'></ELEMENT>
			<ELEMENT NAME='CREW_CAMERA'></ELEMENT>
			<ELEMENT NAME='CREW_SOUND'></ELEMENT>
			<ELEMENT NAME='CREW_MUSIC'></ELEMENT>
			<ELEMENT NAME='CREW_OTHER_DETAILS'></ELEMENT>
			<ELEMENT NAME='CAST_OTHER_DETAILS'></ELEMENT>
			<ELEMENT NAME='FILM_PROMO'></ELEMENT>
			<ELEMENT NAME='RELATED_FEATURES'></ELEMENT>
			<ELEMENT NAME='COPYRIGHT'></ELEMENT>	
			<ELEMENT NAME='BUDGETCOST'></ELEMENT>
			<ELEMENT NAME='UPDATEDATECREATED'></ELEMENT>
			<ELEMENT NAME='DATECREATED' EI='add'></ELEMENT>
			<ELEMENT NAME='SUBMITTEDBYNAME' EI='add'></ELEMENT>
			<ELEMENT NAME='SUBMITTEDBYID' EI='add'></ELEMENT>
			<ELEMENT NAME='IS_SERIES' EI='add'></ELEMENT>
			<ELEMENT NAME='SERIES_LENGTH' EI='add'></ELEMENT>
			<ELEMENT NAME='TAGS'  ACTION='KEYPHRASE' ESCAPE="1"></ELEMENT>
		]]>
                <xsl:call-template name="multiInputLinks">
                        <xsl:with-param name="maxNo" select="6"/>
                </xsl:call-template>
                <xsl:call-template name="multiInputCast">
                        <xsl:with-param name="maxNo" select="15"/>
                </xsl:call-template>
                <xsl:call-template name="multiInputCrewOther">
                        <xsl:with-param name="maxNo" select="10"/>
                </xsl:call-template>
                <xsl:call-template name="multiInputShorts">
                        <xsl:with-param name="maxNo" select="8"/>
                </xsl:call-template>
                <xsl:call-template name="multiInputFestivals">
                        <xsl:with-param name="maxNo" select="20"/>
                </xsl:call-template>
                <xsl:call-template name="multiInputEpisode">
                        <xsl:with-param name="maxNo" select="10"/>
                </xsl:call-template>
                <![CDATA[
			</MULTI-INPUT>
		]]>
        </xsl:variable>
        <xsl:variable name="addcredit">
                <!-- Alistair: delete those that are not needed -->
                <![CDATA[
		<MULTI-INPUT>
			<REQUIRED NAME='TYPE'></REQUIRED>
			<REQUIRED NAME='BODY'><VALIDATE TYPE='EMPTY'/></REQUIRED>
			<REQUIRED NAME='TITLE'><VALIDATE TYPE='EMPTY'/></REQUIRED>
			<ELEMENT NAME='ARTICLEFORUMSTYLE'></ELEMENT>
			<ELEMENT NAME='DIRECTORSNAME' EI='add'><VALIDATE TYPE='EMPTY'/></ELEMENT>
			<ELEMENT NAME='FILMLENGTH_MINS' EI='add'><VALIDATE TYPE='EMPTY'/></ELEMENT>
			<ELEMENT NAME='FILMLENGTH_SECS' EI='add'><VALIDATE TYPE='EMPTY'/></ELEMENT>
			<ELEMENT NAME='YEARPRODUCTION'><VALIDATE TYPE='EMPTY'/></ELEMENT>
			<ELEMENT NAME='TAPEFORMAT'></ELEMENT>
			<ELEMENT NAME='ORIGINALFORMAT'></ELEMENT>
			<ELEMENT NAME='REGION' EI='add'><VALIDATE TYPE='EMPTY'/></ELEMENT>
			<ELEMENT NAME='DESCRIPTION'><VALIDATE TYPE='EMPTY'/></ELEMENT>
			<ELEMENT NAME='DECLARATION_READSUBBMISSION'></ELEMENT>
			<ELEMENT NAME='DECLARATION_CLEARANCEPROCEDURE'></ELEMENT>
			<ELEMENT NAME='DECLARATION_NORETURNTAPE'></ELEMENT>
			<ELEMENT NAME='FILMMAKERSCOMMENTS'></ELEMENT>
			<ELEMENT NAME='NOTESID' EI='add'></ELEMENT>
			<ELEMENT NAME='FILM_STATUS_MSG' EI='add'></ELEMENT>
			<ELEMENT NAME='DETAILS'></ELEMENT>
			<ELEMENT NAME='ORIGINALCREDIT'></ELEMENT>
			<ELEMENT NAME='YOUR_ROLE' EI='add'><VALIDATE TYPE='EMPTY'/></ELEMENT>
			<ELEMENT NAME='POLLTYPE1'></ELEMENT>
			<ELEMENT NAME='STILLS_GALLERY'></ELEMENT>
			<ELEMENT NAME='AVAIL_DAY'></ELEMENT>
			<ELEMENT NAME='AVAIL_MONTH'></ELEMENT>
			<ELEMENT NAME='AVAIL_YEAR'></ELEMENT>
			<ELEMENT NAME='STREAMING_NARROW'></ELEMENT>
			<ELEMENT NAME='STREAMING_BROADBAND'></ELEMENT>
			<ELEMENT NAME='WHYDECLINED'></ELEMENT>
			<ELEMENT NAME='WINPLAYER'></ELEMENT>
			<ELEMENT NAME='REALPLAYER'></ELEMENT>
			<ELEMENT NAME='PLAYER_SIZE' EI='add'></ELEMENT>
			<ELEMENT NAME='CONTENT_VIOLENCE'></ELEMENT>
			<ELEMENT NAME='CONTENT_LANGUAGE'></ELEMENT>
			<ELEMENT NAME='CONTENT_SEXUAL'></ELEMENT>
			<ELEMENT NAME='CONTENT_DISTURBING'></ELEMENT>
			<ELEMENT NAME='CONTENT_VIOLENCE_ADDITIONAL'></ELEMENT>
			<ELEMENT NAME='CONTENT_LANGUAGE_ADDITIONAL'></ELEMENT>
			<ELEMENT NAME='CONTENT_SEXUAL_ADDITIONAL'></ELEMENT>
			<ELEMENT NAME='CONTENT_DISTURBING_ADDITIONAL'></ELEMENT>
			<ELEMENT NAME='CONTENT_FLASHINGIMAGES'></ELEMENT>
			<ELEMENT NAME='PUBLISH_INDUSTRY_IMG'></ELEMENT>
			<ELEMENT NAME='STANDARD_WARNING' EI='add'></ELEMENT>
			<ELEMENT NAME='ADDITIONAL_WARNING'></ELEMENT>
			<ELEMENT NAME='FESTIVALAWARDS'></ELEMENT>
			<ELEMENT NAME='DISTDETAILS'></ELEMENT>
			<ELEMENT NAME='FUNDINGDETAILS'></ELEMENT>
			<ELEMENT NAME='CREW_DIRECTOR'></ELEMENT>
			<ELEMENT NAME='CREW_WRITER'></ELEMENT>
			<ELEMENT NAME='CREW_PRODUCER'></ELEMENT>
			<ELEMENT NAME='CREW_EDITOR'></ELEMENT>
			<ELEMENT NAME='CREW_CAMERA'></ELEMENT>
			<ELEMENT NAME='CREW_SOUND'></ELEMENT>
			<ELEMENT NAME='CREW_MUSIC'></ELEMENT>
			<ELEMENT NAME='CREW_OTHER_DETAILS'></ELEMENT>
			<ELEMENT NAME='CAST_OTHER_DETAILS'></ELEMENT>			
			<ELEMENT NAME='FILM_PROMO'></ELEMENT>
			<ELEMENT NAME='RELATED_FEATURES'></ELEMENT>
			<ELEMENT NAME='COPYRIGHT'></ELEMENT>	
			<ELEMENT NAME='BUDGETCOST'></ELEMENT>	
			<ELEMENT NAME='UPDATEDATECREATED'></ELEMENT>
		</MULTI-INPUT>
		]]>
                <xsl:call-template name="multiInputLinks">
                        <xsl:with-param name="maxNo" select="6"/>
                </xsl:call-template>
                <xsl:call-template name="multiInputCast">
                        <xsl:with-param name="maxNo" select="15"/>
                </xsl:call-template>
                <xsl:call-template name="multiInputShorts">
                        <xsl:with-param name="maxNo" select="8"/>
                </xsl:call-template>
                <![CDATA[
			</MULTI-INPUT>
		]]>
        </xsl:variable>
        <!-- NOTES - CONTACT are editorial only -->
        <!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
									Page - Level  template
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
        <xsl:template name="TYPED-ARTICLE_MAINBODY">
                <!-- DEBUG -->
                <xsl:call-template name="TRACE">
                        <xsl:with-param name="message">TYPED-ARTICLE_MAINBODY</xsl:with-param>
                        <xsl:with-param name="pagename">typedarticlepage.xsl</xsl:with-param>
                </xsl:call-template>
                <!-- DEBUG -->
                <xsl:apply-templates mode="c_typedarticle" select="PARSEERRORS"/>
                <xsl:apply-templates mode="c_typedarticle" select="ERROR"/>
                <xsl:apply-templates mode="c_article" select="DELETED"/>
                <xsl:apply-templates mode="c_article" select="MULTI-STAGE"/>
        </xsl:template>
        <!--
	<xsl:template match="MULTI-STAGE" mode="create_article">
	Use: Presentation of the create / edit article functionality
	 -->
        <!-- ###################################################################################

	 SHOW EDIT BOXES etc after preview  with or without preview pending status

	 ################################################################################-->
        <xsl:template match="MULTI-STAGE" mode="r_article">
                <xsl:apply-templates mode="c_article" select="/H2G2/DELETED"/>
                <xsl:apply-templates mode="c_preview" select="."/>
                <xsl:choose>
                        <!-- add biog / edit biog / edit intro -->
                        <xsl:when test="$current_article_type=3001">
                                <xsl:call-template name="EDIT_INTRO"/>
                        </xsl:when>
                        <!-- film submission, convert to credit and add credit -->
                        <xsl:when test="$article_type_group='film' or $article_type_group='credit' or $article_type_group='declined'">
                                <xsl:if
                                        test="/H2G2/MULTI-STAGE/@TYPE='TYPED-ARTICLE-CREATE' or /H2G2/PARAMS/PARAM[NAME = 's_details']/VALUE = 'no' or /H2G2/MULTI-ELEMENT[@NAME='DETAILS']/VALUE-EDITABLE !='yes'">
                                        <input name="s_details" type="hidden" value="no"/>
                                </xsl:if>
                                <xsl:call-template name="FILM_SUBMISSION_EDITFORM"/>
                        </xsl:when>
                        <xsl:when test="$article_type_group='notes'">
                                <xsl:call-template name="FILM__NOTE_SUBMISSION_EDITFORM"/>
                        </xsl:when>
                        <xsl:when test="$article_type_group='frontpage'">
                                <xsl:if test="$test_IsEditor"> frontpage<xsl:call-template name="FRONTPAGE_EDITFORM"/>
                                </xsl:if>
                        </xsl:when>
                        <xsl:when test="$article_type_group='article'">
                                <xsl:if test="$test_IsEditor"> article<xsl:call-template name="FRONTPAGE_EDITFORM"/>
                                </xsl:if>
                        </xsl:when>
                        <xsl:when test="$current_article_type=63">
                                <!-- magazine article -->
                                <xsl:if test="$test_IsEditor">
                                        <xsl:apply-templates mode="c_typedarticle" select="/H2G2/MULTI-STAGE/MULTI-REQUIRED/ERRORS/ERROR | /H2G2/MULTI-STAGE/MULTI-ELEMENT/ERRORS/ERROR"/>
                                        <input name="_msfinish" type="hidden" value="yes"/>
                                        <input name="_msxml" type="hidden" value="{$magazinearticlefields}"/>
                                        <input name="CATEGORYNAME" type="hidden" value="{/H2G2/ARTICLE/ARTICLEINFO/CRUMBTRAILS/CRUMBTRAIL/ANCESTOR[position()=3]/NAME/text()}"/>
                                        <input name="CATEGORYNUMBER" type="hidden" value="{/H2G2/ARTICLE/ARTICLEINFO/CRUMBTRAILS/CRUMBTRAIL/ANCESTOR[position()=3]/NODEID/text()}"/>
                                        <input name="ARTICLEFORUMSTYLE" type="hidden" value="0"/> Title:<br/>
                                        <xsl:apply-templates mode="t_articletitle" select="."/>
                                        <br/>
                                        <div class="formtitle"><strong><xsl:apply-templates mode="c_error_class" select="MULTI-ELEMENT[@NAME='DESCRIPTION']"/> article description:</strong>&nbsp;*</div>
                                        <input name="DESCRIPTION" type="text">
                                                <xsl:attribute name="value">
                                                        <xsl:value-of select="MULTI-ELEMENT[@NAME='DESCRIPTION']/VALUE-EDITABLE"/>
                                                </xsl:attribute>
                                                <xsl:attribute name="class">formboxwidthmedium</xsl:attribute>
                                        </input>
                                        <br/> content:<br/>
                                        <textarea cols="75" name="body" rows="40">
                                                <xsl:value-of select="MULTI-REQUIRED[@NAME='BODY']/VALUE-EDITABLE"/>
                                        </textarea>
                                </xsl:if>
                        </xsl:when>
                        <xsl:otherwise>
                                <xsl:if test="$test_IsEditor">
                                        <xsl:apply-templates mode="c_typedarticle" select="/H2G2/MULTI-STAGE/MULTI-REQUIRED/ERRORS/ERROR | /H2G2/MULTI-STAGE/MULTI-ELEMENT/ERRORS/ERROR"/>
                                        <input name="_msfinish" type="hidden" value="yes"/>
                                        <input name="_msxml" type="hidden" value="{$articlefields}"/> Title:<br/>
                                        <xsl:apply-templates mode="t_articletitle" select="."/>
                                        <br/>
                                        <textarea cols="75" name="body" rows="40">
                                                <xsl:value-of select="MULTI-REQUIRED[@NAME='BODY']/VALUE-EDITABLE"/>
                                        </textarea>
                                </xsl:if>
                        </xsl:otherwise>
                </xsl:choose>
                <!-- EDITOR ONLY BOX: the following will be for editors only -->
                <xsl:if test="$test_IsEditor">
                        <br/>
                        <br/>
                        <div class="filmedit">
                                <table border="0" cellpadding="3" cellspacing="3" width="100%">
                                        <tr>
                                                <td bgcolor="#CAE4ED">
                                                        <xsl:apply-templates mode="r_articlestatus" select="."/>
                                                </td>
                                        </tr>
                                        <tr>
                                                <td bgcolor="#CAE4ED">
                                                        <div class="textmedium">Article type:<xsl:apply-templates mode="t_articletype" select="."/></div>
                                                </td>
                                        </tr>
                                        <tr>
                                                <td bgcolor="#CAE4ED">
                                                        <div class="textmedium">Film Status Message: <select class="formboxwidthsmaller" name="FILM_STATUS_MSG">
                                                                        <option value="">choose...</option>
                                                                        <option value="withdrawn">
                                                                                <xsl:if test="MULTI-ELEMENT[@NAME='FILM_STATUS_MSG']/VALUE-EDITABLE = 'withdrawn'">
                                                                                        <xsl:attribute name="selected">selected</xsl:attribute>
                                                                                </xsl:if>withdrawn </option>
                                                                        <option value="accepted">
                                                                                <xsl:if test="MULTI-ELEMENT[@NAME='FILM_STATUS_MSG']/VALUE-EDITABLE = 'accepted'">
                                                                                        <xsl:attribute name="selected">selected</xsl:attribute>
                                                                                </xsl:if>accepted </option>
                                                                        <option value="on hold">
                                                                                <xsl:if test="MULTI-ELEMENT[@NAME='FILM_STATUS_MSG']/VALUE-EDITABLE = 'on hold'">
                                                                                        <xsl:attribute name="selected">selected</xsl:attribute>
                                                                                </xsl:if>on hold </option>
                                                                        <option value="declined">
                                                                                <xsl:if test="MULTI-ELEMENT[@NAME='FILM_STATUS_MSG']/VALUE-EDITABLE = 'declined'">
                                                                                        <xsl:attribute name="selected">selected</xsl:attribute>
                                                                                </xsl:if>declined </option>
                                                                        <option value="tape received">
                                                                                <xsl:if test="MULTI-ELEMENT[@NAME='FILM_STATUS_MSG']/VALUE-EDITABLE = 'tape received'">
                                                                                        <xsl:attribute name="selected">selected</xsl:attribute>
                                                                                </xsl:if> tape received</option>
                                                                        <option value="awaiting tape">
                                                                                <xsl:if test="MULTI-ELEMENT[@NAME='FILM_STATUS_MSG']/VALUE-EDITABLE = 'awaiting tape'">
                                                                                        <xsl:attribute name="selected">selected</xsl:attribute>
                                                                                </xsl:if> awaiting tape </option>
                                                                </select>
                                                        </div>
                                                </td>
                                        </tr>
                                        <!-- PUBLISH INDUSTRY PROF IMG checkbox -->
                                        <tr>
                                                <td bgcolor="#CAE4ED">
                                                        <div class="textmedium"> Publish Industry Professional Image Images &nbsp;&nbsp; <input name="PUBLISH_INDUSTRY_IMG" type="checkbox">
                                                                        <xsl:if test="MULTI-ELEMENT[@NAME='PUBLISH_INDUSTRY_IMG']/VALUE-EDITABLE = 'on'">
                                                                                <xsl:attribute name="checked">checked</xsl:attribute>
                                                                        </xsl:if>
                                                                </input>
                                                        </div>
                                                </td>
                                        </tr>
                                        <tr>
                                                <td bgcolor="#CAE4ED">
                                                        <div class="textmedium">
                                                                <xsl:apply-templates mode="c_makearchive" select="."/>
                                                        </div>
                                                </td>
                                        </tr>
                                        <tr>
                                                <td bgcolor="#CAE4ED">
                                                        <div class="textmedium">
                                                                <xsl:apply-templates mode="c_hidearticle" select="."/>
                                                        </div>
                                                </td>
                                        </tr>
                                        <tr>
                                                <td bgcolor="#CAE4ED">
                                                        <div class="textmedium">update the submission date to today: <input name="updatedatecreated" type="checkbox" value="1"/></div>
                                                </td>
                                        </tr>
                                        <tr>
                                                <td bgcolor="#CAE4ED"><xsl:apply-templates mode="t_articlepreviewbutton" select="."/>&nbsp;&nbsp;<xsl:apply-templates mode="c_articleeditbutton"
                                                                select="."/><xsl:apply-templates mode="c_articlecreatebutton" select="."/> &nbsp;&nbsp;<xsl:apply-templates
                                                                mode="c_deletearticle" select="."/></td>
                                        </tr>
                                </table>
                        </div>
                </xsl:if>
        </xsl:template>
        <xsl:template match="MULTI-STAGE" mode="r_articlecreatebutton">
                <input name="acreate" src="{$imagesource}furniture/next1.gif" type="image" value="create"/>
        </xsl:template>
        <xsl:template match="MULTI-STAGE" mode="r_authorlist"> Authors: <xsl:apply-templates mode="t_authorlist" select="."/>
        </xsl:template>
        <xsl:attribute-set name="mMULTI-STAGE_t_authorlist"/>
        <!--
	<xsl:template match="MULTI-STAGE" mode="r_hidearticle">
	Use: Presentation of the hide article functionality
	 -->
        <xsl:template match="MULTI-STAGE" mode="r_hidearticle"> Hide this article: <xsl:apply-templates mode="t_hidearticle" select="."/>
        </xsl:template>
        <!--
	<xsl:attribute-set name="mMULTI-STAGE_t_hidearticle"/>
	Use: Presentation attributes for the Hide article input box
	 -->
        <xsl:attribute-set name="mMULTI-STAGE_t_hidearticle"/>
        <xsl:template match="MULTI-STAGE" mode="r_articlestatus">
                <br/>
                <xsl:choose>
                        <xsl:when test="$article_type_group='film'">
                                <div class="textmedium">Article Status: <select name="status">
                                                <option value="3"><xsl:if test="@TYPE='TYPED-ARTICLE-CREATE'">
                                                                <xsl:attribute name="selected">selected</xsl:attribute>
                                                        </xsl:if>submission</option>
                                                <option value="1"><xsl:if test="MULTI-REQUIRED[@NAME='STATUS']/VALUE-EDITABLE = 1">
                                                                <xsl:attribute name="selected">selected</xsl:attribute>
                                                        </xsl:if>approved</option>
                                                <option value="9"><xsl:if test="MULTI-REQUIRED[@NAME='STATUS']/VALUE-EDITABLE = 5">
                                                                <xsl:attribute name="selected">selected</xsl:attribute>
                                                        </xsl:if>help</option>
                                        </select>
                                </div>
                        </xsl:when>
                        <xsl:when test="$current_article_type=63">
                                <input name="STATUS" type="hidden" value="1"/>
                                <div class="textmedium">Article Status: 1 </div>
                        </xsl:when>
                        <xsl:otherwise>
                                <div class="textmedium">Article Status: <input name="status" type="text" xsl:use-attribute-sets="iMULTI-STAGE_r_articlestatus">
                                                <xsl:attribute name="value">
                                                        <xsl:value-of select="MULTI-REQUIRED[@NAME='STATUS']/VALUE-EDITABLE"/>
                                                </xsl:attribute>
                                        </input></div>
                        </xsl:otherwise>
                </xsl:choose>
                <p/>
        </xsl:template>
        <!--
	<xsl:template match="MULTI-STAGE" mode="r_articletype">
	Use: Presentation of the type dropdown - types defined in types.xsl
		 Used for the 'genre:' dropdown on the film/credit submission page
	 -->
        <xsl:template match="MULTI-STAGE" mode="r_articletype">
                <xsl:param name="group"/>
                <xsl:param name="user"/>
                <select name="type">
                        <xsl:choose>
                                <!-- editors are provided with a full drop down menu -->
                                <xsl:when test="$test_IsEditor">
                                        <xsl:apply-templates mode="c_articletype" select="msxsl:node-set($type)/type[@group='film' and @user=$user]"/>
                                        <xsl:apply-templates mode="c_articletype" select="msxsl:node-set($type)/type[@group='credit' and @user=$user]">
                                                <xsl:with-param name="exttext">&nbsp;credit</xsl:with-param>
                                        </xsl:apply-templates>
                                        <xsl:apply-templates mode="c_articletype" select="msxsl:node-set($type)/type[@group='declined' and @user=$user]">
                                                <xsl:with-param name="exttext">&nbsp;declined</xsl:with-param>
                                        </xsl:apply-templates>
                                </xsl:when>
                                <!-- credit or first time original credit drop down menu-->
                                <xsl:when test="$current_article_type='credit' or /H2G2/PARAMS/PARAM[NAME = 's_credit']/VALUE = 1">
                                        <xsl:apply-templates mode="c_articletype" select="msxsl:node-set($type)/type[@group='credit' and @user=$user]"/>
                                </xsl:when>
                                <!-- declined drop down menu -->
                                <xsl:when test="$current_article_type='declined'">
                                        <xsl:apply-templates mode="c_articletype" select="msxsl:node-set($type)/type[@group='credit' and @user=$user]"/>
                                </xsl:when>
                                <!-- otherwise, default film drop down menu [types 30 -35] -->
                                <xsl:otherwise>
                                        <xsl:apply-templates mode="c_articletype" select="msxsl:node-set($type)/type[@group=$group and @user=$user]"/>
                                </xsl:otherwise>
                        </xsl:choose>
                </select>
        </xsl:template>
        <xsl:template match="type" mode="c_articletype">
                <xsl:param name="exttext"/>
                <!-- use either selected number or normal number depending on status -->
                <xsl:variable name="articletype_number">
                        <xsl:choose>
                                <xsl:when test="$selected_status='on'">
                                        <xsl:value-of select="@selectnumber"/>
                                </xsl:when>
                                <xsl:otherwise>
                                        <xsl:value-of select="@number"/>
                                </xsl:otherwise>
                        </xsl:choose>
                </xsl:variable>
                <option value="{$articletype_number}">
                        <xsl:if test="$current_article_type=$articletype_number">
                                <xsl:attribute name="selected">selected</xsl:attribute>
                        </xsl:if>
                        <xsl:value-of select="@label"/>
                        <xsl:value-of select="$exttext"/>
                </option>
        </xsl:template>
        <xsl:template match="MULTI-STAGE" mode="r_makearchive">
                <br/>Archive this forum?: <xsl:apply-templates mode="t_makearchive" select="."/>
                <br/>
        </xsl:template>
        <!--
	<xsl:template match="MULTI-STAGE" mode="r_preview">
	Use: Presentation of the preview area
	 -->
        <xsl:template match="MULTI-STAGE" mode="r_preview">
                <xsl:choose>
                        <xsl:when test="$current_article_type=3001">
                                <xsl:choose>
                                        <xsl:when test="/H2G2/MULTI-STAGE/@TYPE='TYPED-ARTICLE-EDIT-PREVIEW'">
                                                <table border="0" cellpadding="0" cellspacing="0" width="635">
                                                        <tr>
                                                                <td height="10">
                                                                        <!-- crumb menu -->
                                                                        <div class="crumbtop">
                                                                                <span class="textmedium"><a>
                                                                                                <xsl:attribute name="href"><xsl:value-of select="$root"/>U<xsl:value-of
                                                                                                    select="/H2G2/ARTICLE/ARTICLEINFO/PAGEAUTHOR/EDITOR/USER/USERID"/></xsl:attribute>
                                                                                                <strong>my profile</strong>
                                                                                        </a> |</span>
                                                                                <span class="textxlarge">preview biography</span>
                                                                        </div>
                                                                        <!-- END crumb menu -->
                                                                </td>
                                                        </tr>
                                                </table>
                                                <table border="0" cellpadding="0" cellspacing="0" width="635">
                                                        <tr>
                                                                <td class="darkboxbg" height="100" valign="top" width="635">
                                                                        <div class="biogname">
                                                                                <strong>
                                                                                        <xsl:value-of select="/H2G2/ARTICLE/ARTICLEINFO/PAGEAUTHOR/EDITOR/USER/USERNAME"/>
                                                                                </strong>
                                                                        </div>
                                                                        <div class="topboxcopy">If you are happy with your introduction, click send. If not, edit the boxes below.</div>
                                                                </td>
                                                        </tr>
                                                        <tr>
                                                                <td valign="top" width="635">
                                                                        <img height="27" src="{$imagesource}furniture/writemessage/topboxangle.gif" width="635"/>
                                                                </td>
                                                        </tr>
                                                </table>
                                        </xsl:when>
                                        <xsl:otherwise> </xsl:otherwise>
                                </xsl:choose>
                                <xsl:apply-templates mode="userpage_bio" select="/H2G2/ARTICLE/GUIDE"/>
                        </xsl:when>
                        <xsl:when test="$article_type_group='film' and not($test_IsEditor)">
                                <!-- not editor view of preview -->
                                <!-- Don't show edit boxes in preview mode for film submission -->
                                <!-- show user different preview pending on is it's approved or not -->
                                <xsl:choose>
                                        <xsl:when test="/H2G2/MULTI-STAGE/MULTI-REQUIRED[@NAME='STATUS']/VALUE-EDITABLE = 1">
                                                <xsl:apply-templates mode="filmsubmission_approved" select="/H2G2/ARTICLE"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                                <xsl:apply-templates mode="filmsubmission_nonapproved" select="/H2G2/ARTICLE"/>
                                        </xsl:otherwise>
                                </xsl:choose>
                        </xsl:when>
                        <xsl:when test="$current_article_type=10">
                                <xsl:apply-templates mode="c_articlepage" select="/H2G2/ARTICLE"/>
                        </xsl:when>
                        <xsl:when test="$article_type_group='film' and $test_IsEditor">
                                <!-- edit view of preview, view approved style -->
                                <!-- Don't show edit boxes in preview mode for film submission -->
                                <xsl:apply-templates mode="filmsubmission_approved" select="/H2G2/ARTICLE"/>
                        </xsl:when>
                        <xsl:otherwise>
                                <table border="0" cellpadding="0" cellspacing="0" width="410">
                                        <tr>
                                                <td>
                                                        <div class="PageContent">
                                                                <xsl:apply-templates mode="c_articlepage" select="/H2G2/ARTICLE"/>
                                                        </div>
                                                </td>
                                        </tr>
                                </table>
                        </xsl:otherwise>
                </xsl:choose>
        </xsl:template>
        <xsl:template match="MULTI-STAGE" mode="r_deletearticle">
                <xsl:apply-imports/>
        </xsl:template>
        <xsl:template match="ERROR" mode="r_typedarticle">
                <xsl:choose>
                        <xsl:when test="$test_IsEditor">
                                <div class="textmedium">
                                        <span class="alert">
                                                <strong>You may have forgotten to fill in one of the required fields. Fields with a red star are required. Please fill them in and click
                                                'next'.</strong>
                                        </span>
                                        <br/>
                                        <xsl:apply-templates select="*|@*|text()"/>
                                        <br/>
                                        <strong> </strong>
                                </div>
                        </xsl:when>
                        <xsl:otherwise>
                                <div class="textmedium">
                                        <strong>
                                                <span class="alert">error</span>
                                        </strong>
                                        <br/>
                                        <strong class="alert"> You may have forgotten to fill in one of the required fields. Fields with a red star are required. Please fill them in and click
                                        'next'.</strong>
                                </div>
                        </xsl:otherwise>
                </xsl:choose>
        </xsl:template>
        <!--
	<xsl:template match="DELETED" mode="r_deleted">
	Use: Template invoked after deleting an article
	 -->
        <xsl:template match="DELETED" mode="r_article">
                <!-- head section -->
                <table border="0" cellpadding="5" cellspacing="0" width="371">
                        <tr>
                                <td height="10"/>
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
                                                                <div class="whattodotitle">
                                                                        <strong>Your submission has been removed</strong>
                                                                </div>
                                                                <div class="topboxcopy">The declined submission has been removed from your profile page.</div>
                                                        </td>
                                                </tr>
                                        </table>
                                </td>
                                <td class="topbg" valign="top" width="20"/>
                                <td class="topbg" valign="top"> </td>
                        </tr>
                </table>
                <img height="27" src="{$imagesource}furniture/writemessage/topboxangle.gif" width="635"/>
                <br/>
                <div class="textmedium" style="margin-top:10px">
                        <a><xsl:attribute name="href">
                                        <xsl:value-of select="concat($root,'U',/H2G2/VIEWING-USER/USER/USERID)"/>
                                </xsl:attribute>
                                <strong>back to my profile</strong>&nbsp;<xsl:copy-of select="$next.arrow"/>
                        </a>
                </div>
        </xsl:template>
        <!--
	<xsl:attribute-set name="fMULTI-STAGE_c_article"/>
	Use: 
	 -->
        <xsl:attribute-set name="fMULTI-STAGE_c_article">
                <xsl:attribute name="name">typedarticle</xsl:attribute>
        </xsl:attribute-set>
        <!--
	<xsl:attribute-set name="iMULTI-STAGE_t_articletitle"/>
	Use: 
	 -->
        <xsl:attribute-set name="iMULTI-STAGE_t_articletitle"/>
        <xsl:attribute-set name="mMULTI-STAGE_t_articlebody"/>
        <xsl:attribute-set name="mMULTI-STAGE_t_articlepreview"/>
        <xsl:attribute-set name="mMULTI-STAGE_t_articlecreate"/>
        <xsl:attribute-set name="iMULTI-STAGE_t_makearchive"/>
        <xsl:template match="MULTI-STAGE" mode="t_articletitle">
                <input class="formboxwidthmedium" name="title" type="text" value="{MULTI-REQUIRED[@NAME='TITLE']/VALUE-EDITABLE}"/>
                <!-- xsl:use-attribute-sets="iMULTI-STAGE_t_articletitle" -->
        </xsl:template>
        <xsl:template match="MULTI-STAGE" mode="r_articleeditbutton">
                <input name="aupdate" src="{$imagesource}furniture/submit.gif" type="image" xsl:use-attribute-sets="mMULTI-STAGE_r_articleeditbutton"/>
        </xsl:template>
        <!-- show red * after error come back -->
        <xsl:template match="MULTI-REQUIRED|MULTI-ELEMENT" mode="c_error">
                <xsl:choose>
                        <xsl:when test="ERRORS/ERROR/@TYPE='VALIDATION-ERROR-EMPTY'">
                                <font color="#FF0000">*</font>
                        </xsl:when>
                        <xsl:otherwise>*</xsl:otherwise>
                </xsl:choose>
        </xsl:template>
        <xsl:template match="MULTI-REQUIRED|MULTI-ELEMENT" mode="c_error_class">
                <xsl:choose>
                        <xsl:when test="ERRORS/ERROR/@TYPE='VALIDATION-ERROR-EMPTY'">
                                <xsl:attribute name="class">alert</xsl:attribute>
                        </xsl:when>
                        <xsl:otherwise/>
                </xsl:choose>
        </xsl:template>
        <!-- insert alert into a class after error come back -->
        <xsl:template match="MULTI-REQUIRED[@NAME='TITLE']" mode="c_error_insert_class">
                <xsl:choose>
                        <xsl:when test="ERRORS/ERROR/@TYPE='VALIDATION-ERROR-EMPTY'">
                                <div class="formtitle alert"><strong>film title:</strong>&nbsp;*</div>
                        </xsl:when>
                        <xsl:otherwise>
                                <div class="formtitle"><strong>film title:</strong>&nbsp;*</div>
                        </xsl:otherwise>
                </xsl:choose>
        </xsl:template>
        <!-- show red * after error come back -->
        <xsl:template match="MULTI-REQUIRED|MULTI-ELEMENT" mode="c_errorbiog">
                <xsl:choose>
                        <xsl:when test="ERRORS/ERROR/@TYPE='VALIDATION-ERROR-EMPTY'">
                                <font color="#FF0000">* <strong>You must write something in your biog.</strong></font>
                        </xsl:when>
                        <xsl:otherwise/>
                </xsl:choose>
        </xsl:template>
        <!--
       <xsl:template match="MULTI-ELEMENT" mode="r_poll">
       Use: Template invoked for the 'create a poll' functionality
	-->
        <xsl:template match="MULTI-STAGE" mode="r_poll">
                <xsl:apply-templates mode="c_content_rating" select="."/>
        </xsl:template>
        <!--
       <xsl:template match="MULTI-ELEMENT" mode="r_content_rating">
       Use: Create a poll box
	-->
        <xsl:template match="MULTI-STAGE" mode="r_content_rating">
                <xsl:text>Create a poll for this article: </xsl:text>
                <xsl:apply-templates mode="t_content_rating_box" select="."/>
                <br/>
        </xsl:template>
        <!-- templates for outputtinug CDATA sections -->
        <xsl:template name="multiInputLinks">
                <xsl:param name="maxNo"/>
                <xsl:param name="no" select="1"/> &lt;ELEMENT NAME='USEFULLINKS<xsl:value-of select="$no"/>'>&lt;/ELEMENT> &lt;ELEMENT NAME='USEFULLINKS<xsl:value-of select="$no"
                />_TEXT'>&lt;/ELEMENT> <xsl:if test="$no &lt; $maxNo">
                        <xsl:call-template name="multiInputLinks">
                                <xsl:with-param name="maxNo" select="$maxNo"/>
                                <xsl:with-param name="no" select="$no + 1"/>
                        </xsl:call-template>
                </xsl:if>
        </xsl:template>
        <xsl:template name="multiInputCast">
                <xsl:param name="maxNo"/>
                <xsl:param name="no" select="1"/> &lt;ELEMENT NAME='CAST<xsl:value-of select="$no"/>_NAME'>&lt;/ELEMENT> &lt;ELEMENT NAME='CAST<xsl:value-of select="$no"
                />_CHARACTER_NAME'>&lt;/ELEMENT> <xsl:if test="$no &lt; $maxNo">
                        <xsl:call-template name="multiInputCast">
                                <xsl:with-param name="maxNo" select="$maxNo"/>
                                <xsl:with-param name="no" select="$no + 1"/>
                        </xsl:call-template>
                </xsl:if>
        </xsl:template>
        <xsl:template name="multiInputCrewOther">
                <xsl:param name="maxNo"/>
                <xsl:param name="no" select="1"/> &lt;ELEMENT NAME='CREW<xsl:value-of select="$no"/>_OTHER_NAME'>&lt;/ELEMENT> &lt;ELEMENT NAME='CREW<xsl:value-of select="$no"
                />_OTHER_ROLE'>&lt;/ELEMENT> <xsl:if test="$no &lt; $maxNo">
                        <xsl:call-template name="multiInputCrewOther">
                                <xsl:with-param name="maxNo" select="$maxNo"/>
                                <xsl:with-param name="no" select="$no + 1"/>
                        </xsl:call-template>
                </xsl:if>
        </xsl:template>
        <xsl:template name="multiInputShorts">
                <xsl:param name="maxNo"/>
                <xsl:param name="no" select="1"/> &lt;ELEMENT NAME='SHORT<xsl:value-of select="$no"/>_TITLE'>&lt;/ELEMENT> &lt;ELEMENT NAME='SHORT<xsl:value-of select="$no"
                />_ANUMBER'>&lt;/ELEMENT> &lt;ELEMENT NAME='SHORT<xsl:value-of select="$no"/>_LENGTH_MIN'>&lt;/ELEMENT> &lt;ELEMENT NAME='SHORT<xsl:value-of select="$no"
                />_LENGTH_SEC'>&lt;/ELEMENT> &lt;ELEMENT NAME='SHORT<xsl:value-of select="$no"/>_GENRE'>&lt;/ELEMENT> <xsl:if test="$no &lt; $maxNo">
                        <xsl:call-template name="multiInputShorts">
                                <xsl:with-param name="maxNo" select="$maxNo"/>
                                <xsl:with-param name="no" select="$no + 1"/>
                        </xsl:call-template>
                </xsl:if>
        </xsl:template>
        <xsl:template name="multiInputFestivals">
                <xsl:param name="maxNo"/>
                <xsl:param name="no" select="1"/> &lt;ELEMENT NAME='FESTIVAL<xsl:value-of select="$no"/>_NAME'>&lt;/ELEMENT> &lt;ELEMENT NAME='FESTIVAL<xsl:value-of select="$no"
                />_AWARD'>&lt;/ELEMENT> &lt;ELEMENT NAME='FESTIVAL<xsl:value-of select="$no"/>_PLACE'>&lt;/ELEMENT> &lt;ELEMENT NAME='FESTIVAL<xsl:value-of select="$no"
                />_YEAR'>&lt;/ELEMENT> <xsl:if test="$no &lt; $maxNo">
                        <xsl:call-template name="multiInputFestivals">
                                <xsl:with-param name="maxNo" select="$maxNo"/>
                                <xsl:with-param name="no" select="$no + 1"/>
                        </xsl:call-template>
                </xsl:if>
        </xsl:template>
        <xsl:template name="multiInputEpisode">
                <xsl:param name="maxNo"/>
                <xsl:param name="no" select="1"/> &lt;ELEMENT NAME='EPISODE<xsl:value-of select="$no"/>_TITLE'>&lt;/ELEMENT> &lt;ELEMENT NAME='EPISODE<xsl:value-of select="$no"
                />_DESCRIPTION'>&lt;/ELEMENT> &lt;ELEMENT NAME='EPISODE<xsl:value-of select="$no"/>_ANUMBER'>&lt;/ELEMENT> &lt;ELEMENT NAME='EPISODE<xsl:value-of select="$no"
                />_IMAGE'>&lt;/ELEMENT> <xsl:if test="$no &lt; $maxNo">
                        <xsl:call-template name="multiInputEpisode">
                                <xsl:with-param name="maxNo" select="$maxNo"/>
                                <xsl:with-param name="no" select="$no + 1"/>
                        </xsl:call-template>
                </xsl:if>
        </xsl:template>
</xsl:stylesheet>
