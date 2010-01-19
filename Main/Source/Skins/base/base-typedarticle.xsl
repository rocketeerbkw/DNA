<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<xsl:attribute-set name="mMULTI-STAGE_t_permissionowner"/>
	<xsl:attribute-set name="mMULTI-STAGE_t_permissionall"/>
	<xsl:attribute-set name="mDELETED_r_deleted" use-attribute-sets="typedarticlepagelinks"/>
	<xsl:attribute-set name="mMULTI-STAGE_r_deletearticle" use-attribute-sets="typedarticlepagelinks"/>
	<xsl:attribute-set name="typedarticlepagelinks" use-attribute-sets="linkatt"/>
	<xsl:attribute-set name="fMULTI-STAGE_c_article"/>
	<xsl:attribute-set name="iMULTI-STAGE_t_articletitle">
		<xsl:attribute name="size">30</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="mMULTI-STAGE_t_articlebody">
		<xsl:attribute name="cols">40</xsl:attribute>
		<xsl:attribute name="rows">8</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="mMULTI-STAGE_t_hidearticle"/>
	<xsl:variable name="createtype"><![CDATA[<MULTI-INPUT>
								<REQUIRED NAME='TYPE'><VALIDATE TYPE='EMPTY'/></REQUIRED>
							</MULTI-INPUT>]]></xsl:variable>
	<xsl:variable name="articlefields"><![CDATA[<MULTI-INPUT>
						<REQUIRED NAME='TYPE'><VALIDATE TYPE='EMPTY'/></REQUIRED>
						<REQUIRED NAME='BODY'><VALIDATE TYPE='EMPTY'/></REQUIRED>
						<REQUIRED NAME='TITLE'><VALIDATE TYPE='EMPTY'/></REQUIRED>					
						<REQUIRED NAME='HIDEARTICLE'><VALIDATE TYPE='EMPTY'/></REQUIRED>
				</MULTI-INPUT>]]></xsl:variable>
	<!--
	<xsl:template name="TYPED-ARTICLE_HEADER">
	Author:		Tom Whitehouse
	Context:      /H2G2
	Purpose:	 Creates the title for the page which sits in the html header
	-->
	<xsl:template name="TYPED-ARTICLE_HEADER">
		<xsl:choose>
			<!-- 
		****************** DO THIS!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
		-->
			<xsl:when test="/H2G2/DELETED">
				<xsl:apply-templates mode="header" select=".">
					<xsl:with-param name="title">
						<xsl:value-of select="$m_articlehiddentitle"/>
					</xsl:with-param>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:when test="INREVIEWTESTGOESHERE">
				<xsl:apply-templates mode="header" select=".">
					<xsl:with-param name="title">
						<xsl:value-of select="$m_articleisinreviewtext"/>
					</xsl:with-param>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates mode="header" select=".">
					<xsl:with-param name="title">
						<xsl:value-of select="$m_editpagetitle"/>
					</xsl:with-param>
				</xsl:apply-templates>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--
	************************
	NEEDS DOING
	**********************
	 -->
	<xsl:template name="TYPED-ARTICLE_SUBJECT">Needs a subject!
		<xsl:choose>
			<xsl:when test="INREVIEW">
				<xsl:call-template name="SUBJECTHEADER">
					<xsl:with-param name="text">needs a subject!
						<xsl:value-of select="$m_articleisinreviewtext"/>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<A NAME="top"/>
				<xsl:if test="ARTICLE-PREVIEW/ARTICLE/SUBJECT">
					<xsl:call-template name="SUBJECTHEADER">
						<xsl:with-param name="text">needs a subject!
							<xsl:value-of select="ARTICLE-PREVIEW/ARTICLE/SUBJECT"/>
						</xsl:with-param>
					</xsl:call-template>
					<BR/>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="MULTI-STAGE" mode="c_article">
	Author:		Tom Whitehouse
	Context:      /H2G2
	Purpose:	
	-->
	<xsl:variable name="article_type_val">
		<xsl:choose>
			<xsl:when test="/H2G2/MULTI-STAGE[@TYPE='TYPED-ARTICLE-CREATE' or @TYPE='TYPED-ARTICLE-PREVIEW']">
				<xsl:value-of select="/H2G2/MULTI-STAGE/MULTI-REQUIRED[@NAME='TYPE']/VALUE"/>
			</xsl:when>
			<xsl:when test="/H2G2/MULTI-STAGE[@TYPE='TYPED-ARTICLE-EDIT' or @TYPE='TYPED-ARTICLE-EDIT-PREVIEW']">
				<xsl:choose>
					<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_change']/VALUE=1">
						<xsl:value-of select="/H2G2/MULTI-STAGE/MULTI-REQUIRED[@NAME='TYPE']/VALUE"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="/H2G2/ARTICLE/EXTRAINFO/TYPE/@ID"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
		</xsl:choose>
	</xsl:variable>
	<xsl:template match="MULTI-STAGE" mode="c_article">
		<form method="post" action="{$root}TypedArticle" xsl:use-attribute-sets="fMULTI-STAGE_c_article">



			<!--input type="hidden" name="skin" value="purexml"/-->
			<xsl:if test="@TYPE='TYPED-ARTICLE-EDIT' or @TYPE='TYPED-ARTICLE-EDIT-PREVIEW'">
				<input type="hidden" name="s_typedarticle" value="edit"/>
			</xsl:if>
			<xsl:choose>
				<xsl:when test="@TYPE='TYPED-ARTICLE-CREATE' or @TYPE='TYPED-ARTICLE-PREVIEW'">
					<!--input type="hidden" name="type" value="{MULTI-REQUIRED[@NAME='TYPE']/VALUE}"/-->
					<input type="hidden" name="_msstage" value="{@STAGE}"/>
					<xsl:apply-templates select="." mode="r_article"/>					
				</xsl:when>
				<xsl:when test="@TYPE='TYPED-ARTICLE-EDIT' or @TYPE='TYPED-ARTICLE-EDIT-PREVIEW'">
					<!--xsl:choose>
							<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_change']/VALUE=1">
								<input type="hidden" name="type" value="{MULTI-REQUIRED[@NAME='TYPE']/VALUE}"/>
							</xsl:when>
							<xsl:otherwise>
								<input type="hidden" name="type" value="{/H2G2/ARTICLE/EXTRAINFO/TYPE/@ID}"/>
							</xsl:otherwise>
						</xsl:choose-->
					<input type="hidden" name="_msstage" value="{@STAGE}"/>
					<input type="hidden" name="h2g2id" value="{/H2G2/ARTICLE/ARTICLEINFO/H2G2ID}"/>
					<xsl:apply-templates select="." mode="r_article"/>
				</xsl:when>
			</xsl:choose>
		</form>
	</xsl:template>
	<!--
	<xsl:template match="MULTI-STAGE" mode="t_articletitle">
	Author:		Tom Whitehouse
	Context:      /H2G2
	Purpose:	
	-->
	<xsl:template match="MULTI-STAGE" mode="t_articletitle">
		<input type="text" name="title" value="{MULTI-REQUIRED[@NAME='TITLE']/VALUE-EDITABLE}" xsl:use-attribute-sets="iMULTI-STAGE_t_articletitle"/>
	</xsl:template>
	<!--
	<xsl:template match="MULTI-STAGE" mode="t_articlebody">
	Author:		Tom Whitehouse
	Context:      /H2G2
	Purpose:	
	-->
	<xsl:template match="MULTI-STAGE" mode="t_articlebody">
		<textarea name="body" xsl:use-attribute-sets="mMULTI-STAGE_t_articlebody">
			<xsl:value-of select="MULTI-REQUIRED[@NAME='BODY']/VALUE-EDITABLE"/>
		</textarea>
	</xsl:template>
	<!--
	<xsl:template match="MULTI-STAGE" mode="t_articlepreview">
	Author:		Tom Whitehouse
	Context:      /H2G2
	Purpose:	
	-->
	<xsl:template match="MULTI-STAGE" mode="t_articlepreviewbutton">
		<input name="apreview" xsl:use-attribute-sets="mMULTI-STAGE_t_articlepreviewbutton"/>
	</xsl:template>
	<xsl:attribute-set name="mMULTI-STAGE_t_articlepreviewbutton">
		<xsl:attribute name="type">submit</xsl:attribute>
		<xsl:attribute name="value">preview</xsl:attribute>
	</xsl:attribute-set>
	<!--
	<xsl:template match="MULTI-STAGE" mode="t_articlecreate">
	Author:		Tom Whitehouse
	Context:      /H2G2
	Purpose:	
	-->
	<xsl:template match="MULTI-STAGE" mode="c_articlecreatebutton">
		<xsl:if test="@TYPE='TYPED-ARTICLE-CREATE' or @TYPE='TYPED-ARTICLE-PREVIEW'">
			<xsl:apply-templates select="." mode="r_articlecreatebutton"/>
		</xsl:if>
	</xsl:template>
	<xsl:attribute-set name="mMULTI-STAGE_r_articlecreatebutton">
		<xsl:attribute name="type">submit</xsl:attribute>
		<xsl:attribute name="value">create</xsl:attribute>
	</xsl:attribute-set>
	<xsl:template match="MULTI-STAGE" mode="r_articlecreatebutton">
		<input name="acreate" xsl:use-attribute-sets="mMULTI-STAGE_r_articlecreatebutton"/>
	</xsl:template>
	<xsl:template match="MULTI-STAGE" mode="c_articleeditbutton">
		<xsl:if test="@TYPE='TYPED-ARTICLE-EDIT' or @TYPE='TYPED-ARTICLE-EDIT-PREVIEW'">
			<xsl:apply-templates select="." mode="r_articleeditbutton"/>
		</xsl:if>
	</xsl:template>
	<xsl:attribute-set name="mMULTI-STAGE_r_articleeditbutton">
		<xsl:attribute name="type">submit</xsl:attribute>
		<xsl:attribute name="value">update</xsl:attribute>
	</xsl:attribute-set>
	<xsl:template match="MULTI-STAGE" mode="r_articleeditbutton">
		<input name="aupdate" xsl:use-attribute-sets="mMULTI-STAGE_r_articleeditbutton"/>
	</xsl:template>
	<!--xsl:template match="MULTI-STAGE" mode="c_articlecreatebutton">
		<xsl:choose>
			<xsl:when test="@TYPE='TYPED-ARTICLE-EDIT'">
				<input name="aedit" xsl:use-attribute-sets="mMULTI-STAGE_t_articlecreatebutton"/>
			</xsl:when>
			<xsl:otherwise>
				
			</xsl:otherwise>
		</xsl:choose>
		
	</xsl:template-->
	<!--
	<xsl:template match="MULTI-STAGE" mode="c_preview">
	Author:		Tom Whitehouse
	Context:      /H2G2
	Purpose:	
	-->
	<xsl:template match="MULTI-STAGE" mode="c_preview">
		<xsl:if test="@TYPE='TYPED-ARTICLE-PREVIEW' or @TYPE='TYPED-ARTICLE-EDIT-PREVIEW'">
			<xsl:apply-templates select="." mode="r_preview"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="DELETED" mode="c_deleted">
	Author:		Tom Whitehouse
	Context:      /H2G2
	Purpose:	
	-->
	<xsl:template match="DELETED" mode="c_article">
		<xsl:apply-templates select="." mode="r_article"/>
	</xsl:template>
	<!--
	<xsl:template match="DELETED" mode="r_deleted">
	Author:		Tom Whitehouse
	Context:      /H2G2
	Purpose:	
	-->
	<xsl:template match="DELETED" mode="r_article">
		<a href="{$root}MA{/H2G2/VIEWING-USER/USER/USERID}?type=3" xsl:use-attribute-sets="mDELETED_r_deleted">
			<xsl:copy-of select="$m_deletedarticleslink"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="DELETED" mode="r_deleted">
	Author:		Tom Whitehouse
	Context:      /H2G2
	Purpose:	
	-->
	<xsl:template match="MULTI-STAGE" mode="c_deletearticle">
		<xsl:if test="/H2G2/MULTI-STAGE[@TYPE='TYPED-ARTICLE-EDIT' or @TYPE='TYPED-ARTICLE-EDIT-PREVIEW']">
			<xsl:apply-templates select="." mode="r_deletearticle"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="DELETED" mode="r_deleted">
	Author:		Tom Whitehouse
	Context:      /H2G2
	Purpose:	
	-->
	<xsl:template match="MULTI-STAGE" mode="r_deletearticle">
		<a href="{$root}typedarticle?adelete=delete&amp;h2g2id={/H2G2/ARTICLE/ARTICLEINFO/H2G2ID}" xsl:use-attribute-sets="mMULTI-STAGE_r_deletearticle">
			<xsl:copy-of select="$m_delete"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="MULTI-STAGE" mode="c_hidearticle">
	Author:		Tom Whitehouse
	Context:      /H2G2
	Purpose:	Decides if the hide article functionality should exist
	-->
	<xsl:template match="MULTI-STAGE" mode="c_hidearticle">
		<xsl:if test="MULTI-REQUIRED[@NAME='HIDEARTICLE']">
			<xsl:apply-templates select="." mode="r_hidearticle"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="MULTI-STAGE" mode="t_hidearticle">
	Author:		Tom Whitehouse
	Context:      /H2G2
	Purpose:	Creates the Hide article functionality on the article page
	-->
	<xsl:template match="MULTI-STAGE" mode="t_hidearticle">
		<input type="checkbox" name="HIDEARTICLE" value="1" xsl:use-attribute-sets="mMULTI-STAGE_t_hidearticle">
			<xsl:if test="MULTI-REQUIRED[@NAME='HIDEARTICLE']/VALUE = 1">
				<xsl:attribute name="checked">checked</xsl:attribute>
			</xsl:if>
		</input>
	</xsl:template>
	<!--xsl:template match="MULTI-STAGE" mode="c_authorlist">
		<xsl:if test="TestGoesHere">
			<xsl:apply-templates select="." mode="r_authorlist"/>
		</xsl:if>
	</xsl:template>
	<xsl:attribute-set name="mMULTI-STAGE_t_authorlist">
		<xsl:attribute name="cols">60</xsl:attribute>
		<xsl:attribute name="rows">3</xsl:attribute>
	</xsl:attribute-set>
	<xsl:template match="MULTI-STAGE" mode="t_authorlist">
		<textarea name="ResearcherList" xsl:use-attribute-sets="mMULTI-STAGE_t_authorlist">
			<xsl:for-each select="USER">
				<xsl:sort select="USERNAME" data-type="text" order="ascending"/>
				<xsl:value-of select="USERID"/>
				<xsl:text> </xsl:text>
			</xsl:for-each>
		</textarea>
	</xsl:template-->
	<!--
	<xsl:template match="ERROR" mode="c_typedarticle">
	Author:		Tom Whitehouse
	Context:      /H2G2
	Purpose:	
	-->
	<xsl:template match="ERROR" mode="c_typedarticle">
		<xsl:apply-templates select="." mode="r_typedarticle"/>
	</xsl:template>
	<!--
	<xsl:template match="ERROR" mode="r_typedarticle">
	Author:		Tom Whitehouse
	Context:      /H2G2
	Purpose:	
	-->
	<xsl:template match="ERROR" mode="r_typedarticle">
		<xsl:choose>
			<xsl:when test="@TYPE='UNREGISTERED'">
				<xsl:copy-of select="$m_unregisteredtypedarticle"/>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="PARSEERRORS" mode="c_typedarticle">
		<xsl:apply-templates select="." mode="r_typedarticle"/>
	</xsl:template>
	<xsl:template match="MULTI-STAGE" mode="c_permissionchange">
		<xsl:choose>
			<xsl:when test="/H2G2/ARTICLE/@CANCHANGEPERMISSIONS = '1' or @TYPE='TYPED-ARTICLE-CREATE'">
				<xsl:apply-templates select="." mode="r_permissionchange"/>
			</xsl:when>
			<xsl:otherwise>
				<input type="hidden" name="whocanedit" value="{MULTI-REQUIRED[@NAME='WHOCANEDIT']/VALUE}"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- not implemented yet:
	<li><input type="radio" name="whocanedit" value="userlist" /> These users: <input type="text" name="whocanedit_userlist" /></li>
	<li><input type="radio" name="whocanedit" value="teamlist" /> These teams: <input type="text" name="whocanedit_teamlist" /></li>
	-->
	<xsl:template match="MULTI-STAGE" mode="t_permissionowner">
		<input type="radio" name="whocanedit" value="me" xsl:use-attribute-sets="mMULTI-STAGE_t_permissionowner">
			<xsl:if test="MULTI-REQUIRED[@NAME='WHOCANEDIT']/VALUE = 'me'">
				<xsl:attribute name="checked">checked</xsl:attribute>
			</xsl:if>
		</input>
	</xsl:template>
	<xsl:template match="MULTI-STAGE" mode="t_permissionall">
		<input type="radio" name="whocanedit" value="all" xsl:use-attribute-sets="mMULTI-STAGE_t_permissionall">
			<xsl:if test="MULTI-REQUIRED[@NAME='WHOCANEDIT']/VALUE = 'all'">
				<xsl:attribute name="checked">checked</xsl:attribute>
			</xsl:if>
		</input>
	</xsl:template>
	<!--
	<xsl:template match="STATUS" mode="c_articlestatus">
	Author:		Tom Whitehouse
	Context:      /H2G2/ARTICLE-EDIT-FORM/STATUS
	Purpose:	 Calls the STATUS container (if allowed) for the ARTICLE-EDIT-FORM
	-->
	<xsl:template match="MULTI-STAGE" mode="c_articlestatus">
		<xsl:if test="$test_IsEditor or ($superuser=1)">
			<xsl:apply-templates select="." mode="r_articlestatus"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="ARTICLE-EDIT-FORM/STATUS" mode="r_articlestatus">
	Author:		Tom Whitehouse
	Context:      /H2G2/ARTICLE-EDIT-FORM/STATUS
	Purpose:	 Creates the STATUS input area for the ARTICLE-EDIT-FORM
	-->
	<xsl:template match="MULTI-STAGE" mode="r_articlestatus">
		<xsl:choose>
			<xsl:when test="@TYPE='TYPED-ARTICLE-CREATE'">
				<input type="text" name="status" value="1" xsl:use-attribute-sets="iMULTI-STAGE_r_articlestatus"/>
			</xsl:when>
			<xsl:otherwise>
				<input type="text" name="status" value="{MULTI-REQUIRED[@NAME='STATUS']/VALUE-EDITABLE}" xsl:use-attribute-sets="iMULTI-STAGE_r_articlestatus"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:attribute-set name="iMULTI-STAGE_r_articlestatus"/>
	<xsl:template match="MULTI-STAGE" mode="c_articletype">
		<xsl:choose>
			<xsl:when test="$test_IsEditor or ($superuser=1)">
				<xsl:apply-templates select="." mode="r_articletype"/>
			</xsl:when>
			<xsl:otherwise>
				<input type="hidden" name="type" value="{$article_type_val}"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:variable name="current_article_type">
		<xsl:value-of select="/H2G2/MULTI-STAGE/MULTI-REQUIRED[@NAME='TYPE']/VALUE-EDITABLE"/>
		<!--xsl:choose>
			<xsl:when test="/H2G2/MULTI-STAGE[@TYPE='TYPED-ARTICLE-CREATE' or @TYPE='TYPED-ARTICLE-PREVIEW']">
				<xsl:value-of select="/H2G2/MULTI-STAGE/MULTI-REQUIRED[@NAME='TYPE']/VALUE"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="/H2G2/ARTICLE/EXTRAINFO/TYPE/@ID"/>
			</xsl:otherwise>
		</xsl:choose-->
	</xsl:variable>
	<xsl:attribute-set name="iMULTI-STAGE_t_articletype">
		<xsl:attribute name="type">text</xsl:attribute>
		<xsl:attribute name="name">type</xsl:attribute>
		<xsl:attribute name="value"><xsl:value-of select="$current_article_type"/></xsl:attribute>
	</xsl:attribute-set>
	<xsl:template match="MULTI-STAGE" mode="t_articletype">
		<input xsl:use-attribute-sets="iMULTI-STAGE_t_articletype"/>
	</xsl:template>
	<!--
	<xsl:template match="MULTI-STAGE" mode="c_makearchive">
	Author:		Wendy Mann
	Context:      /H2G2/MULTI-STAGE/MULTI-REQUIRED/
	Purpose:	Calls the make an archive checkbox
	-->
	<xsl:template match="MULTI-STAGE" mode="c_makearchive">
		<xsl:if test="$test_IsEditor or ($superuser=1)">
			<xsl:apply-templates select="." mode="r_makearchive"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="MULTI-STAGE" mode="t_makearchive">
	Author:		Wendy Mann
	Context:     	 /H2G2/MULTI-STAGE/MULTI-REQUIRED/
	Purpose:	 Creates the ARCHIVE checkbox for the ARTICLE-EDIT-FORM
	-->
	<xsl:template match="MULTI-STAGE" mode="t_makearchive">
		<xsl:choose>
			<xsl:when test="MULTI-REQUIRED[@NAME='ARCHIVE']/VALUE-EDITABLE=1">
				<input type="radio" name="archive" value="1" xsl:use-attribute-sets="iMULTI-STAGE_t_makearchive" checked="checked"/> Yes 
			<input type="radio" name="archive" value="0" xsl:use-attribute-sets="iMULTI-STAGE_t_makearchive"/> No				
	</xsl:when>
			<xsl:otherwise>
				<input type="radio" name="archive" value="1" xsl:use-attribute-sets="iMULTI-STAGE_t_makearchive"/> Yes 
			<input type="radio" name="archive" value="0" xsl:use-attribute-sets="iMULTI-STAGE_t_makearchive" checked="checked"/> No		
	</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:attribute-set name="iMULTI-STAGE_t_makearchive"/>
	<!-- 
	______________  POLLING OBJECT _____________
	-->
	<!--
	<xsl:template match="MULTI-STAGE" mode="c_poll">
	Author:		Tom Whitehouse
	Context:      /H2G2
	Purpose:	If the user has permissions and its the article create page, create the polling object
	-->
	<xsl:template match="MULTI-STAGE" mode="c_poll">
		<xsl:if test="($test_IsEditor or ($superuser=1)) and /H2G2/MULTI-STAGE[@TYPE='TYPED-ARTICLE-CREATE' or @TYPE='TYPED-ARTICLE-PREVIEW']">
			<xsl:apply-templates select="." mode="r_poll"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="MULTI-STAGE" mode="c_poll">
	Author:		Tom Whitehouse
	Context:      /H2G2
	Purpose:	Creates the polling object
	-->
	<xsl:template match="MULTI-STAGE" mode="c_content_rating">
		<xsl:apply-templates select="." mode="r_content_rating"/>
	</xsl:template>
	<!--
	<xsl:template match="MULTI-STAGE" mode="c_poll">
	Author:		Tom Whitehouse
	Context:      /H2G2
	Purpose:	Checkbox to attach a polling object to an article
	-->
	<!-- ITS NOT POSSIBLE TO DO A GENERIC POLLING TEMPLATE BECAUSE THERE IS NO POLL 
	MULTI-ELEMENT WHEN YOU INITIALLY CREATE AN ARTICLE -->
	<xsl:template match="MULTI-STAGE" mode="t_content_rating_box">
		<input type="checkbox" name="polltype1" value="3" xsl:use-attribute-sets="iMULTI-STAGE_t_content_rating_box">
			<xsl:if test="MULTI-ELEMENT[@NAME='POLLTYPE1']/VALUE=3">
				<xsl:attribute name="checked">checked</xsl:attribute>
			</xsl:if>
		</input>
	</xsl:template>
	<!--
	<xsl:template match="MULTI-STAGE" mode="c_poll">
	Author:		Tom Whitehouse
	Context:      /H2G2
	Purpose:	Attribute set for the 'create a poll' checkbox
	-->
	<xsl:attribute-set name="iMULTI-STAGE_t_content_rating_box"/>
	
	<xsl:template match="MULTI-STAGE" mode="c_assetupload">
		<xsl:apply-templates select="." mode="r_assetupload"/>		
	</xsl:template>
	
	<xsl:template match="MULTI-STAGE" mode="t_imageuploadfield">
		<input name="file" type="file" size="60" maxlength="255" value="tttttttt"  xsl:use-attribute-sets="iMULTI-STAGE_t_imageuploadfield"/>
	</xsl:template>
	
	<xsl:template match="MULTI-REQUIRED" mode="c_assetmimetype">
			<xsl:apply-templates select="." mode="r_assetmimetype"/>
	</xsl:template>
	
	<xsl:attribute-set name="iMULTI-REQUIRED_r_assetmimetype"/>
	<xsl:template match="MULTI-REQUIRED" mode="r_assetmimetype">
	<xsl:choose>
	
		<xsl:when test="$contenttypepath=2">
		<select name="mimetype">
			<option value="mp2">MP2</option>			
			<option value="mp3">MP3</option>			
			<option value="wav">WAV</option>		
		</select>
		</xsl:when>
		
		<xsl:when test="$contenttypepath=3">
		<select name="mimetype">
			<option value="avi">AVI</option>			
			<option value="wmv">WMV (Windows Media Video)</option>			
			<option value="mov">MOV</option>
			<option value="mp1">MP1</option>			
		</select>
		</xsl:when>
	</xsl:choose>
	</xsl:template>

	<xsl:variable name="contenttypepath" select="/H2G2/PARAMS/PARAM[NAME='s_display']/VALUE"></xsl:variable>
			
	<xsl:attribute-set name="iMULTI-STAGE_t_imageuploadfield"></xsl:attribute-set>
		
	<xsl:template match="MULTI-STAGE" mode="c_assettags">
		<xsl:apply-templates select="." mode="r_assettags"/>
	</xsl:template>
			
	<xsl:template match="MULTI-STAGE" mode="r_assettags">
		<input type="hidden" name="HasKeyPhrases" value="1"/>
		<textarea name="mediaassetkeyphrases" cols="50" rows="1" xsl:use-attribute-sets="iMULTI-STAGE_r_assettags">			<xsl:value-of select="MULTI-REQUIRED[@NAME='MEDIAASSETKEYPHRASES']/VALUE-EDITABLE"/>
		</textarea>
	</xsl:template>			
	
	<xsl:attribute-set name="iMULTI-STAGE_r_assettags"></xsl:attribute-set>
	
	<xsl:template match="MULTI-STAGE" mode="c_copyright">
		<xsl:apply-templates select="." mode="r_copyright"/>
	</xsl:template>
	<xsl:attribute-set name="iMULTI-STAGE_r_copyright"/>
	<xsl:template match="MULTI-STAGE" mode="r_copyright">
		<input type="checkbox" name="termsandconditions" xsl:use-attribute-sets="iMULTI-STAGE_r_copyright">
			<xsl:if test="MULTI-REQUIRED[@NAME='TERMSANDCONDITIONS']/VALUE-EDITABLE = 'on'">
				<xsl:attribute name="checked">checked</xsl:attribute>
			</xsl:if>
		</input>
		
	</xsl:template>
	
	<xsl:template match="MULTI-REQUIRED" mode="c_taassetmimetype">
		<xsl:apply-templates select="." mode="r_taassetmimetype"/>
	</xsl:template>
	
	<xsl:template match="MULTI-REQUIRED" mode="c_tamimetypeselect">
		<xsl:apply-templates select="." mode="r_tamimetypeselect"/>
	</xsl:template>
	<xsl:template match="MULTI-REQUIRED" mode="r_tamimetypeselect">
		<xsl:choose>
			<xsl:when test="$contenttypepath=2">
				<select name="mimetype">
					<option value="mp2">MP2</option>			
					<option value="mp3">MP3</option>			
					<option value="wav">WAV</option>		
				</select>
			</xsl:when>
			<xsl:when test="$contenttypepath=3">
				<select name="mimetype">
					<option value="avi">AVI</option>			
					<option value="wmv">WMV (Windows Media Video)</option>			
					<option value="mov">MOV</option>
					<option value="mp1">MP1</option>			
				</select>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
			
</xsl:stylesheet>
