<?xml version="1.0" encoding="iso-8859-1"?>
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
	<xsl:template name="TYPED-ARTICLE_HEADER">
		<xsl:choose>
			<xsl:when test="/H2G2/DELETED">
				<xsl:apply-templates mode="header" select=".">
					<xsl:with-param name="title">
						<xsl:value-of select="$m_pagetitlestart"/>
						<xsl:value-of select="$m_articlehiddentitle"/>
					</xsl:with-param>
					<xsl:with-param name="rsstype">SEARCH</xsl:with-param>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:when test="INREVIEWTESTGOESHERE">
				<xsl:apply-templates mode="header" select=".">
					<xsl:with-param name="title">
						<xsl:value-of select="$m_pagetitlestart"/>
						<xsl:value-of select="$m_articleisinreviewtext"/>
					</xsl:with-param>
					<xsl:with-param name="rsstype">SEARCH</xsl:with-param>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates mode="header" select=".">
					<xsl:with-param name="title">
						<xsl:value-of select="$m_pagetitlestart"/>
						<xsl:choose>
							<xsl:when test="/H2G2/MULTI-STAGE/@TYPE='TYPED-ARTICLE-EDIT' or /H2G2/MULTI-STAGE/@TYPE='TYPED-ARTICLE-EDIT-PREVIEW'">
								<xsl:text>Edit memory</xsl:text>
							</xsl:when>
							<xsl:otherwise>
								<xsl:text>Add memory</xsl:text>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:with-param>
					<xsl:with-param name="rsstype">SEARCH</xsl:with-param>
				</xsl:apply-templates>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="TYPED-ARTICLE_MAINBODY">
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
		<xsl:apply-templates select="MULTI-STAGE" mode="c_article"/>
	</xsl:template>
	
	<xsl:template match="MULTI-STAGE" mode="heading_intro"></xsl:template>
	
	<xsl:template match="ERROR" mode="errors">
		<p>
			<xsl:value-of select="../../@NAME"/>:<br/>
			<xsl:value-of select="./ERROR"/> (<xsl:value-of select="@TYPE"/>)
		</p>
	</xsl:template>
	
	<xsl:template match="MULTI-STAGE" mode="errors">
		<xsl:if test="(*/ERRORS or /H2G2/PROFANITYERRORINFO) and not(@CANCEL='YES')">
				<div class="alert">
					<h4>ERROR</h4>
					<xsl:choose>
						<xsl:when test="/H2G2/PROFANITYERRORINFO">
							<p>
							Your information contains a blocked phrase. You must remove any profanities before your item can be submitted.
							</p>
						</xsl:when>
						<xsl:otherwise>
							<p>
								There has been a problem with your submission.<br/>
								Please review the form below.
							</p>
						</xsl:otherwise>
					</xsl:choose>

					<!--[FIXME: adapt]-->
					<!--[FIXME: moved to less detailed]
					<xsl:choose>
						<xsl:when test="$current_article_type=3001">		
							<xsl:if test="MULTI-REQUIRED[@NAME='BODY']/ERRORS/ERROR/@TYPE='VALIDATION-ERROR-EMPTY'">
								You must provide information about yourself<br />
							</xsl:if>
						</xsl:when>
						<xsl:when test="$article_type_group='memory'">
							<xsl:if test="MULTI-ELEMENT[@NAME='LOCATION']/ERRORS/ERROR/@TYPE='VALIDATION-ERROR-EMPTY'">
								You must select a location<br />
							</xsl:if>
							<xsl:if test="MULTI-REQUIRED[@NAME='TITLE']/ERRORS/ERROR/@TYPE='VALIDATION-ERROR-EMPTY'">
								You must provide a title for your memory<br />
							</xsl:if>
							<xsl:if test="MULTI-REQUIRED[@NAME='BODY']/ERRORS/ERROR/@TYPE='VALIDATION-ERROR-EMPTY'">
								You must provide text for your memory<br />
							</xsl:if>
							<xsl:if test="MULTI-REQUIRED[@NAME='STARTDATE']/ERRORS/ERROR/@TYPE='VALIDATION-ERROR-EMPTY'">
								You must provide a start date<br/>
							</xsl:if>
							<xsl:if test="MULTI-REQUIRED[@NAME='STARTDAY']/ERRORS/ERROR/@TYPE='VALIDATION-ERROR-CUSTOM'">
								<xsl:value-of select="MULTI-REQUIRED[@NAME='STARTDAY']/ERRORS/ERROR[@TYPE='VALIDATION-ERROR-CUSTOM']/ERROR"/><br/>
							</xsl:if>
							<xsl:if test="MULTI-REQUIRED[@NAME='ENDDATE']/ERRORS/ERROR/@TYPE='VALIDATION-ERROR-EMPTY'">
								You must provide an end date<br/>
							</xsl:if>
							<xsl:if test="MULTI-REQUIRED[@NAME='ENDDAY']/ERRORS/ERROR/@TYPE='VALIDATION-ERROR-CUSTOM'">
								<xsl:value-of select="MULTI-REQUIRED[@NAME='ENDDAY']/ERRORS/ERROR[@TYPE='VALIDATION-ERROR-CUSTOM']/ERROR"/><br/>
							</xsl:if>
							<xsl:if test="MULTI-ELEMENT[@NAME='KEYWORDS']/ERRORS/ERROR/@TYPE='VALIDATION-ERROR-EMPTY'">
								You must provide one or more keywords<br />
							</xsl:if>
						</xsl:when>
						<xsl:otherwise>
							<xsl:if test="MULTI-REQUIRED[@NAME='TITLE']/ERRORS/ERROR/@TYPE='VALIDATION-ERROR-EMPTY'">
								You must provide a title for your article<br />
							</xsl:if>
							<xsl:if test="MULTI-REQUIRED[@NAME='BODY']/ERRORS/ERROR/@TYPE='VALIDATION-ERROR-EMPTY'">
								You must provide text for your article<br />
							</xsl:if>
						</xsl:otherwise>
					</xsl:choose>
					-->

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
		<!-- <input type="hidden" name="skin" value="purexml"/> -->
		
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
		<xsl:if test="not(*/ERRORS or /H2G2/PROFANITYERRORINFO)">
			<xsl:apply-templates select="." mode="c_preview"/>
		</xsl:if>

		<xsl:choose>
			<!-- create / edit biog  -->
			<xsl:when test="$current_article_type=3001">
				<xsl:call-template name="PROFILE_FORM" />
			</xsl:when>
			<xsl:when test="$article_type_group='memory'">
				<xsl:call-template name="ARTICLE_FORM" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:if test="$test_IsAdminUser">
					<xsl:call-template name="EDITORIAL_ARTICLE_FORM" />
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
		
				
		<xsl:if test="$test_IsAdminUser">
			<br clear="all"/>
			<div id="typedarticle_editorbox">
				<!-- Admin Tools -->
				<xsl:apply-templates select="." mode="c_permissionchange"/>
				<xsl:apply-templates select="." mode="c_articlestatus"/>
				<xsl:apply-templates select="." mode="c_articletype"/>
				<xsl:apply-templates select="." mode="c_makearchive"/>
				<xsl:apply-templates select="." mode="c_deletearticle"/>
				<xsl:apply-templates select="." mode="c_hidearticle"/>
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
		Article status:
		<xsl:apply-imports/>
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
			<xsl:when test="$article_subtype = 'user_memory'">
				<xsl:call-template name="ARTICLE" />
			</xsl:when>
			<xsl:when test="$article_subtype = 'staff_memory'">
				<xsl:call-template name="ARTICLE" />
			</xsl:when>
			<xsl:when test="$article_subtype = 'profile'">
				<xsl:call-template name="USERPAGE_MAINBODY" />
			</xsl:when>
			<xsl:when test="$article_subtype = 'editorial'">
				<xsl:call-template name="EDITORIAL_ARTICLE" />
			</xsl:when>
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
	 <!--[FIXME: duplicated?]
	<xsl:template match="ERROR" mode="r_typedarticle">
		<xsl:choose>
			<xsl:when test="/H2G2/ERROR/@TYPE='SITECLOSED'">
				<xsl:call-template name="siteclosed" />
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	-->
	
	<xsl:template match="ERROR" mode="r_typedarticle">
		<div id="topPage">
			<!--[FIXME: redundant?]
			<h2>Memoryshare</h2>
			-->
			<p>
				<xsl:choose>
					<xsl:when test="@TYPE='UNREGISTERED'">
						<xsl:text>You must be signed in to add a memory.</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="text()"/>
					</xsl:otherwise>
				</xsl:choose>
			</p>
		</div>
		<div class="tear"><hr/></div>
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
		<p>
		This memory has been deleted. 
		</p>
		<p>
		If you want to restore any deleted memories you can view them <xsl:apply-imports/>
		</p>
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
			<textarea name="keywords" cols="50" rows="4" id="keyPhrases" xsl:use-attribute-sets="iMULTI-STAGE_r_assettags">
				<xsl:value-of select="MULTI-ELEMENT[@NAME='KEYWORDS']/VALUE-EDITABLE"/>
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

	<!-- OVERRIDE admin-redirect.xsl -->
	<!--[FIXME: moved to redirectpage.xsl]
	<xsl:template match='H2G2[@TYPE="REDIRECT"]'>
		<html>
			<head>
				<meta>
					<xsl:attribute name="content">0;url=<xsl:value-of select="REDIRECT-TO"/></xsl:attribute>
					<xsl:attribute name="http-equiv">REFRESH</xsl:attribute>
				</meta>
			</head>
			<body bgcolor="{$bgcolour}" text="{$boxfontcolour}" MARGINHEIGHT="0" MARGINWIDTH="0" TOPMARGIN="0" LEFTMARGIN="0" link="{$linkcolour}" vlink="{$vlinkcolour}" alink="{$alinkcolour}">
			</body>
		</html>
	</xsl:template>
	-->

</xsl:stylesheet>
