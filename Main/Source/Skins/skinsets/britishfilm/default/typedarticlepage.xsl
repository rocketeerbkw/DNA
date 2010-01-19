<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<xsl:import href="../../../base/base-typedarticle.xsl"/>
	<xsl:import href="typedarticlepage_multiinputs.xsl"/>
	
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
								Page - Level  template
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<xsl:template name="TYPED-ARTICLE_MAINBODY">
	
	<table width="635" border="0" cellpadding="0" cellspacing="0" id="contentstructure">
  		<tr>
  			<td>
		
					<!-- DEBUG -->
					<xsl:call-template name="TRACE">
						<xsl:with-param name="message">TYPED-ARTICLE_MAINBODY</xsl:with-param>
						<xsl:with-param name="pagename">typedarticlepage.xsl</xsl:with-param>
					</xsl:call-template>
					<!-- DEBUG -->
					
					<xsl:apply-templates select="PARSEERRORS" mode="c_typedarticle"/>
					<xsl:apply-templates select="ERROR" mode="c_typedarticle"/>
					<xsl:apply-templates select="DELETED" mode="c_article"/>
						
						
					<xsl:apply-templates select="MULTI-STAGE" mode="heading_intro"/>
					<xsl:apply-templates select="MULTI-STAGE" mode="errors"/>
					<xsl:apply-templates select="MULTI-STAGE" mode="c_article"/>
		
				 </td>
		  </tr>

		</table>
		
	</xsl:template>
	
	
	<xsl:template match="MULTI-STAGE" mode="heading_intro">
		
		
					<xsl:choose>
						<!-- REMOVED:	<xsl:when test="$current_article_type=3001"></xsl:when> -->

						<!-- CREATE FILM ARTICLE HEADER -->
						<xsl:when test="$article_subtype = 'user_article'">
    					<h1><img src="{$imagesource}title_submissionform.gif" alt="submission form" width="627" height="30" /></h1>
        		</xsl:when>


						<!-- CREATE ALL OTHER ARTICLE TYPES HEADER: EDITORS ONLY -->
						<xsl:otherwise>
							<xsl:if test="$test_IsEditor">
								<h1>Create Generic Article</h1>
							</xsl:if>
						</xsl:otherwise>
				</xsl:choose>
			<div class="submission">
          <!-- <p>For full details see requirement doc.</p> -->
          <!-- <div class="steps">
						<img src="images/step1.gif" alt="">
						<img src="images/step1.gif" alt="">
						<img src="images/step1.gif" alt="">
					</div> -->

          <p>Fill in the form below. Please complete all the <strong>required fields*</strong>. Once you are happy, click next.</p>
          <p>This information will appear on the finished film page. Please check that all details and names are spelt correctly. We reserve the right to edit for the purposes of accuracy and clarity.</p>
          <div class="divider2"></div>
      </div>
	</xsl:template>
	
	

	<xsl:template match="MULTI-STAGE" mode="errors">
		<xsl:if test="*/ERRORS or /H2G2/PROFANITYERRORINFO">
			<div class="warningBox">
				<p class="warning">
					<strong>ERROR</strong><br />
					<xsl:if test="/H2G2/PROFANITYERRORINFO">
						Your information contains a blocked phrase. You must remove any profanities before your item can be submitted.<br />
					</xsl:if>
					<xsl:choose>
						<xsl:when test="$current_article_type=3001"><!-- REMOVED : SEE 6 0 6 TO INCLUDE --></xsl:when>

						<xsl:when test="starts-with($current_article_type,'10')">	
							<xsl:if test="MULTI-ELEMENT[@NAME='FIRSTNAME']/ERRORS/ERROR/@TYPE='VALIDATION-ERROR-EMPTY'">
								You must provide your first name<br />
							</xsl:if>
							<xsl:if test="MULTI-ELEMENT[@NAME='SURNAME']/ERRORS/ERROR/@TYPE='VALIDATION-ERROR-EMPTY'">
								You must provide your surname<br />
							</xsl:if>
							<xsl:if test="MULTI-ELEMENT[@NAME='EMAIL']/ERRORS/ERROR/@TYPE='VALIDATION-ERROR-EMPTY'">
								You must provide your email address<br />
							</xsl:if>
							<xsl:if test="MULTI-REQUIRED[@NAME='TITLE']/ERRORS/ERROR/@TYPE='VALIDATION-ERROR-EMPTY'">
								You must provide a title for your film<br />
							</xsl:if>
							<xsl:if test="MULTI-ELEMENT[@NAME='VIDEOLINK']/ERRORS/ERROR/@TYPE='VALIDATION-ERROR-EMPTY' and MULTI-ELEMENT[@NAME='BBCVIDEOLINK']/ERRORS/ERROR/@TYPE='VALIDATION-ERROR-EMPTY'">
								You must provide the URL for an embedded video<br />
							</xsl:if>
							<xsl:if test="MULTI-ELEMENT[@NAME='DIRECTOR']/ERRORS/ERROR/@TYPE='VALIDATION-ERROR-EMPTY'">
								You must provide the director's name<br />
							</xsl:if>
							<xsl:if test="MULTI-ELEMENT[@NAME='GENRE']/ERRORS/ERROR/@TYPE='VALIDATION-ERROR-EMPTY'">
								You must select at least one genre<br />
							</xsl:if>
							<xsl:if test="MULTI-ELEMENT[@NAME='TAGLINE']/ERRORS/ERROR/@TYPE='VALIDATION-ERROR-EMPTY'">
								You must provide a tagline for your submission<br />
							</xsl:if>
							<xsl:if test="MULTI-ELEMENT[@NAME='SCENE']/ERRORS/ERROR/@TYPE='VALIDATION-ERROR-EMPTY'">
								You must select a scene<br />
							</xsl:if>
							<xsl:if test="MULTI-ELEMENT[@NAME='LENGTH_MIN']/ERRORS/ERROR/@TYPE='VALIDATION-ERROR-EMPTY'">
								You must enter the film length in minutes<br />
							</xsl:if>
							<xsl:if test="MULTI-ELEMENT[@NAME='LENGTH_SEC']/ERRORS/ERROR/@TYPE='VALIDATION-ERROR-EMPTY'">
								You must enter the film length in seconds<br />
							</xsl:if>
							<xsl:if test="MULTI-ELEMENT[@NAME='PUB_DAY']/ERRORS/ERROR/@TYPE='VALIDATION-ERROR-EMPTY' or MULTI-ELEMENT[@NAME='PUB_MONTH']/ERRORS/ERROR/@TYPE='VALIDATION-ERROR-EMPTY' or MULTI-ELEMENT[@NAME='PUB_YEAR']/ERRORS/ERROR/@TYPE='VALIDATION-ERROR-EMPTY'">
								You must enter the full date of publication<br />
							</xsl:if>
							<xsl:if test="MULTI-REQUIRED[@NAME='BODY']/ERRORS/ERROR/@TYPE='VALIDATION-ERROR-EMPTY'">
								You must provide a synopsis for the film<br />
							</xsl:if>
							<xsl:if test="MULTI-ELEMENT[@NAME='TAGLINE']/ERRORS/ERROR/@TYPE='VALIDATION-ERROR-EMPTY'">
								You must provide the log line<br />
							</xsl:if>
						</xsl:when>
						
						<xsl:otherwise>
							<!-- article for dynamic lists -->		
							<xsl:if test="MULTI-REQUIRED[@NAME='TITLE']/ERRORS/ERROR/@TYPE='VALIDATION-ERROR-EMPTY'">
								You must provide a title for your article<br />
							</xsl:if>
							<xsl:if test="MULTI-REQUIRED[@NAME='BODY']/ERRORS/ERROR/@TYPE='VALIDATION-ERROR-EMPTY'">
								You must provide text for your article<br />
							</xsl:if>
						</xsl:otherwise> 
					</xsl:choose>	
				</p>
				
				<xsl:apply-templates select="MULTI-REQUIRED/ERRORS/ERROR[@TYPE='VALIDATION-ERROR-PARSE']" mode="validation_error_parse"/>
				
			</div>
		</xsl:if>
	</xsl:template>
	
	<!--
	<xsl:template match="MULTI-STAGE" mode="create_article">
	Use: Presentation of the create / edit article functionality
	 -->
	<xsl:template match="MULTI-STAGE" mode="r_article">
		<input type="hidden" name="_msfinish" value="yes"/>
		
		<!-- PASS HIDDEN VALUES @CV@ update later-->
		<xsl:choose>
			<xsl:when test="/H2G2/MULTI-STAGE/@TYPE='TYPED-ARTICLE-EDIT' or /H2G2/MULTI-STAGE/@TYPE='TYPED-ARTICLE-EDIT-PREVIEW'">
				<!-- when editing - use page author -->
				<input type="hidden" name="AUTHORNAME" value="{/H2G2/ARTICLE/ARTICLEINFO/PAGEAUTHOR/EDITOR/USER/FIRSTNAMES} {/H2G2/ARTICLE/ARTICLEINFO/PAGEAUTHOR/EDITOR/USER/LASTNAME}"/>
				<input type="hidden" name="AUTHORUSERID" value="{/H2G2/ARTICLE/ARTICLEINFO/PAGEAUTHOR/EDITOR/USER/USERID}"/>
				<input type="hidden" name="AUTHORUSERNAME" value="{/H2G2/ARTICLE/ARTICLEINFO/PAGEAUTHOR/EDITOR/USER/USERNAME}"/>
				
				<xsl:choose>
					<xsl:when test="/H2G2/MULTI-STAGE/@TYPE='TYPED-ARTICLE-EDIT-PREVIEW'">
						<!-- during TYPED-ARTICLE-EDIT-PREVIEW the /H2G2/ARTICLE/ARTICLEINFO/DATECREATED/DATE/@SORT seems hold the value of the current date so need to reuse the created date -->
						<input type="hidden" name="DATECREATED" value="{/H2G2/ARTICLE/GUIDE/DATECREATED}"/>
					</xsl:when>
					<xsl:otherwise>
						<input type="hidden" name="DATECREATED" value="{/H2G2/ARTICLE/ARTICLEINFO/DATECREATED/DATE/@SORT}"/>
					</xsl:otherwise>
				</xsl:choose>
				
				<input type="hidden" name="LASTUPDATED" value="{/H2G2/DATE/@SORT}"/>
				<xsl:comment>editing</xsl:comment>
			</xsl:when>

			<xsl:when test="/H2G2/MULTI-STAGE/@TYPE='TYPED-ARTICLE-CREATE' or /H2G2/MULTI-STAGE/@TYPE='TYPED-ARTICLE-PREVIEW'">
				<!-- when creating - use viewer -->
				<input type="hidden" name="AUTHORNAME" value="{/H2G2/VIEWING-USER/USER/FIRSTNAMES} {/H2G2/VIEWING-USER/USER/LASTNAME}"/>
				<input type="hidden" name="AUTHORUSERID" value="{/H2G2/VIEWING-USER/USER/USERID}"/>
				<input type="hidden" name="AUTHORUSERNAME" value="{/H2G2/VIEWING-USER/USER/USERNAME}"/>
				<input type="hidden" name="DATECREATED" value="{/H2G2/DATE/@SORT}"/>
				<input type="hidden" name="LASTUPDATED" value="{/H2G2/DATE/@SORT}"/>
				<xsl:comment>creating</xsl:comment>
			</xsl:when>
		</xsl:choose>
		
		<!-- preview -->
		<xsl:apply-templates select="." mode="c_preview"/>
		
		<!-- BULK OF ARTICLE FORM  -->
		<xsl:choose>	
			<xsl:when test="starts-with($current_article_type,'10')">
				<xsl:if test="$test_IsEditor">
					<xsl:call-template name="ARTICLE_FORM" />
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<xsl:if test="$test_IsEditor">		
					<xsl:call-template name="EDITORIAL_ARTICLE_FORM" /><!-- all non film entry article pages -->
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	
				
		<xsl:if test="$test_IsEditor">
			<br clear="all"/>
			<div id="typedarticle_editorbox">
				Editor Tools
				<br />
				<br />
				
				<!-- Editors Tools -->
				<xsl:apply-templates select="." mode="c_permissionchange"/>
				<xsl:apply-templates select="." mode="c_articlestatus"/>
				<xsl:apply-templates select="." mode="c_articletype"/>
				<xsl:apply-templates select="." mode="c_makearchive"/>
				<xsl:apply-templates select="." mode="c_deletearticle"/>
				<xsl:apply-templates select="." mode="c_hidearticle"/>
				<xsl:apply-templates select="." mode="c_poll"/>
						
				
				<!-- CV 
				<div>
				<input type="checkbox" name="RIGHTCOL_BROWSE" class="formboxwidthxsmall">
					<xsl:if test="MULTI-ELEMENT[@NAME='RIGHTCOL_BROWSE']/VALUE-EDITABLE = 'on'">
						<xsl:attribute name="checked">checked</xsl:attribute>
					</xsl:if>	
				</input>
				<input type="hidden" name="RIGHTCOL_BROWSE"/>
				Turn on BROWSE in right column. (tick box).
				</div>

				<div>
				<input type="checkbox" name="RIGHTCOL_TIPS" class="formboxwidthxsmall">
					<xsl:if test="MULTI-ELEMENT[@NAME='RIGHTCOL_TIPS']/VALUE-EDITABLE = 'on'">
						<xsl:attribute name="checked">checked</xsl:attribute>
					</xsl:if>	
				</input>
				<input type="hidden" name="RIGHTCOL_TIPS"/>
				Turn on TIPS in right column. (tick box).
				</div>

				<div>
				<input type="checkbox" name="RIGHTCOL_LINKS" class="formboxwidthxsmall">
					<xsl:if test="MULTI-ELEMENT[@NAME='RIGHTCOL_LINKS']/VALUE-EDITABLE = 'on'">
						<xsl:attribute name="checked">checked</xsl:attribute>
					</xsl:if>	
				</input>
				<input type="hidden" name="RIGHTCOL_LINKS"/>
				Turn on LINKS in right column. (tick box).
				</div>

				<div>
				<input type="checkbox" name="DYNAMICLIST" class="formboxwidthxsmall">
					<xsl:if test="MULTI-ELEMENT[@NAME='DYNAMICLIST']/VALUE-EDITABLE = 'on'">
						<xsl:attribute name="checked">checked</xsl:attribute>
					</xsl:if>	
				</input>
				<input type="hidden" name="DYNAMICLIST"/>
				Turn on the Top 5 dynamic list. (tick box).
				</div>

				<div>
				<input type="checkbox" name="RIGHTCOL_SUBMIT" class="formboxwidthxsmall">
					<xsl:if test="MULTI-ELEMENT[@NAME='RIGHTCOL_SUBMIT']/VALUE-EDITABLE = 'on'">
						<xsl:attribute name="checked">checked</xsl:attribute>
					</xsl:if>	
				</input>
				<input type="hidden" name="RIGHTCOL_SUBMIT"/>
				Turn on the SUBMIT your film. (tick box).
				</div>
			
			-->
			</div>
		</xsl:if>
	</xsl:template>
		
	<!--
	<xsl:template match="MULTI-STAGE" mode="r_permissionchange">
	Use: Presentation of the article edit permissions functionality
	 -->
	<xsl:template match="MULTI-STAGE" mode="r_permissionchange">
		Editable by:			
		<ul>
			<li>
				<xsl:apply-templates select="." mode="t_permissionowner"/> Owner only
			</li>
			<li>
				<xsl:apply-templates select="." mode="t_permissionall"/> Everybody
			</li>
		</ul>
	</xsl:template>
	
	<!--
	<xsl:template match="MULTI-STAGE" mode="r_articlestatus">
	Use: Presentation of the article status functionality
	 -->
	<xsl:template match="MULTI-STAGE" mode="r_articlestatus">
		<br/>
		<!-- Article status: <xsl:apply-imports/> -->
		Article status: <select name="status">
					<option value="3"><xsl:if test="@TYPE='TYPED-ARTICLE-CREATE'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>submission</option>		
					<option value="1"><xsl:if test="MULTI-REQUIRED[@NAME='STATUS']/VALUE-EDITABLE = 1"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>approved</option>
		</select>
		<br/>
	</xsl:template>
	
	<!--
	<xsl:template match="MULTI-STAGE" mode="r_articletype">
	Use: Presentation of the article type functionality
	 -->
	<xsl:template match="MULTI-STAGE" mode="r_articletype">
		Article type: <xsl:apply-templates select="." mode="t_articletype"/>
	</xsl:template>
	
	<!--
	<xsl:template match="MULTI-STAGE" mode="r_makearchive">
	Use: Presentation of the archive article functionality
	 -->
	<xsl:template match="MULTI-STAGE" mode="r_makearchive">
		<br/>Archive this forum?: <xsl:apply-templates select="." mode="t_makearchive"/>
		<br/>
	</xsl:template>
	
	<!--
	<xsl:template match="MULTI-STAGE" mode="r_preview">
	Use: Presentation of the preview area
	 -->
	<xsl:template match="MULTI-STAGE" mode="r_preview">
	<div id="preview">
		<xsl:choose>
		<!-- @CV@ better define these when statements using only type number or subtypes -->
			<xsl:when test="$article_subtype = 'user_article'">
				<xsl:call-template name="ARTICLE" />
			</xsl:when>
			<xsl:when test="/H2G2/MULTI-STAGE/MULTI-REQUIRED[@NAME='TYPE']/VALUE=3001">
				<xsl:call-template name="USERPAGE_MAINBODY" />
			</xsl:when>
			<xsl:otherwise>				
				<xsl:call-template name="EDITORIAL_ARTICLE" />
			</xsl:otherwise>
		</xsl:choose>
	</div>
	</xsl:template>
	
	<!--
	<xsl:template match="MULTI-STAGE" mode="r_deletearticle">
	Use: Presentation of the delete article functionality
	 -->
	<xsl:template match="MULTI-STAGE" mode="r_deletearticle">
		<xsl:apply-imports/><br />
	</xsl:template>
	
	<!--
	<xsl:template match="MULTI-STAGE" mode="r_hidearticle">
	Use: Presentation of the hide article functionality
	 -->
	<xsl:template match="MULTI-STAGE" mode="r_hidearticle">
		Hide this article: <xsl:apply-templates select="." mode="t_hidearticle"/>
	</xsl:template>
	
	<!--
	<xsl:template match="MULTI-STAGE" mode="r_authorlist">
	Use: Presentation of the authorlist functionality
	 -->
	<!--<xsl:template match="MULTI-STAGE" mode="r_authorlist">
		Authors: <xsl:apply-templates select="." mode="t_authorlist"/>
	</xsl:template>-->
	
	<!--
	<xsl:template match="ERROR" mode="r_typedarticle">
	Use: Presentation information for the error reports
	 -->
	<xsl:template match="ERROR" mode="r_typedarticle">
		<xsl:choose>
			<xsl:when test="/H2G2/ERROR/@TYPE='SITECLOSED'">
				<xsl:call-template name="siteclosed" />
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="ERROR" mode="r_typedarticle">
		<xsl:choose>
			<xsl:when test="/H2G2/ERROR/@TYPE='SITECLOSED'">
				<xsl:call-template name="siteclosed" />
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="ERROR" mode="validation_error_parse">
		<div id="displayXMLerror">
				<xsl:apply-templates select="*|@*|text()"/>
			</div>
	</xsl:template>
	
	<!--
	<xsl:template match="DELETED" mode="r_deleted">
	Use: Template invoked after deleting an article
	 -->
	<xsl:template match="DELETED" mode="r_article">
		This article has been deleted. If you want to restore any deleted articles you can view them <xsl:apply-imports/>
	</xsl:template>
	
	<!--
	<xsl:template match="MULTI-ELEMENT" mode="r_poll">
	Use: Template invoked for the 'create a poll' functionality
	 -->
	<xsl:template match="MULTI-STAGE" mode="r_poll">
		<br /><xsl:apply-templates select="." mode="c_content_rating"/>
	</xsl:template>
	<!--
	<xsl:template match="MULTI-ELEMENT" mode="r_content_rating">
	Use: Create a poll box
	 -->
	<xsl:template match="MULTI-STAGE" mode="r_content_rating">
		<xsl:text>Create a poll for this article: </xsl:text>
		<xsl:apply-templates select="." mode="t_content_rating_box"/>
		<br/>
	</xsl:template>
	
	<!-- 
	<xsl:template match="MULTI-STAGE" mode="r_assettags">	
	Use: presentation of the 'choose some tags' box
	-->
	<xsl:template match="MULTI-STAGE" mode="r_assettags">
		<div class="formRow">
			<label for="keyPhrases">Add some key phrases to this article</label><br />
			<input type="hidden" name="HasKeyPhrases" value="1"/>
			<textarea name="mediaassetkeyphrases" cols="50" rows="4" id="keyPhrases" xsl:use-attribute-sets="iMULTI-STAGE_r_assettags">
				<xsl:value-of select="MULTI-REQUIRED[@NAME='MEDIAASSETKEYPHRASES']/VALUE-EDITABLE"/>
			</textarea>
		</div>
	</xsl:template>
		
	<xsl:attribute-set name="fMULTI-STAGE_c_article">
		<xsl:attribute name="id">typedarticle</xsl:attribute>
	</xsl:attribute-set>	
	
	<xsl:attribute-set name="iMULTI-STAGE_t_articletitle">
		<xsl:attribute name="size">30</xsl:attribute>
		<xsl:attribute name="class">inputone</xsl:attribute>
		<xsl:attribute name="id">title</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="mMULTI-STAGE_t_articlebody">
		<xsl:attribute name="cols">15</xsl:attribute>
		<xsl:attribute name="rows">10</xsl:attribute>
		<xsl:attribute name="class">inputone</xsl:attribute>
		<xsl:attribute name="id">body</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="mMULTI-STAGE_t_articlepreview"/>
	<xsl:attribute-set name="mMULTI-STAGE_t_articlecreate"/>
	<xsl:attribute-set name="iMULTI-STAGE_t_makearchive"/>
	<xsl:attribute-set name="mMULTI-STAGE_t_hidearticle"/>
	
</xsl:stylesheet>
