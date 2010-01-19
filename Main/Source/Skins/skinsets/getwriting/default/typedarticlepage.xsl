<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">

	<xsl:import href="../../../base/base-typedarticle.xsl"/>
	<xsl:import href="formwritecreative.xsl"/>
	<xsl:import href="formwriteadvice.xsl"/>
	<xsl:import href="formexcercise.xsl"/>
	<xsl:import href="formchallenge.xsl"/>
	<xsl:import href="formfrontpages.xsl"/>
<!-- <xsl:import href="formminicourse.xsl"/>
	<xsl:import href="formwriteexcercise.xsl"/>
	<xsl:import href="formcraft.xsl"/> -->
	<xsl:import href="formarticleeditor.xsl"/>

	
	<xsl:variable name="articlefields">
	<![CDATA[<MULTI-INPUT>
		<REQUIRED NAME='TYPE'><VALIDATE TYPE='EMPTY'/></REQUIRED>
		<REQUIRED NAME='BODY'><VALIDATE TYPE='EMPTY'/></REQUIRED>
		<REQUIRED NAME='TITLE'><VALIDATE TYPE='EMPTY'/></REQUIRED>
		<ELEMENT NAME='REVIEWPREFERENCE'><VALIDATE TYPE='EMPTY'/></ELEMENT>
		<ELEMENT NAME='DESCRIPTION'></ELEMENT>
	</MULTI-INPUT>]]>
	</xsl:variable>
				
	<xsl:variable name="createtype">
	<![CDATA[<MULTI-INPUT>
		<REQUIRED NAME='TYPE'></REQUIRED>
	</MULTI-INPUT>]]>
	</xsl:variable>
	
	<xsl:variable name="challengefields">
	<![CDATA[<MULTI-INPUT>
		<REQUIRED NAME='TYPE'><VALIDATE TYPE='EMPTY'/></REQUIRED>
		<REQUIRED NAME='BODY'><VALIDATE TYPE='EMPTY'/></REQUIRED>
		<REQUIRED NAME='TITLE'><VALIDATE TYPE='EMPTY'/></REQUIRED>
		<ELEMENT NAME='CHALLENGEDAY'><VALIDATE TYPE='EMPTY'/></ELEMENT>
		<ELEMENT NAME='CHALLENGEMONTH'><VALIDATE TYPE='EMPTY'/></ELEMENT>
		<ELEMENT NAME='CHALLENGEYEAR'><VALIDATE TYPE='EMPTY'/></ELEMENT>
		<ELEMENT NAME='WORDLIMIT'></ELEMENT>
		<ELEMENT NAME='NODEADLINE'></ELEMENT>
	</MULTI-INPUT>]]>
	</xsl:variable>
	
	<xsl:variable name="frontpagefields">
	<![CDATA[<MULTI-INPUT>
		<REQUIRED NAME='TYPE'></REQUIRED>
		<REQUIRED NAME='BODY'></REQUIRED>
		<REQUIRED NAME='TITLE'></REQUIRED>
		<ELEMENT NAME='BANNER'></ELEMENT>
		<ELEMENT NAME='TIPSHEADER'></ELEMENT>
		<ELEMENT NAME='TIPS'></ELEMENT>
		<ELEMENT NAME='IMAGEPROMOS'></ELEMENT>
		<ELEMENT NAME='SUBPROMO1'></ELEMENT>
		<ELEMENT NAME='SUBPROMO2'></ELEMENT>
		<ELEMENT NAME='SUBPROMO3'></ELEMENT>
		<ELEMENT NAME='SUBPROMO4'></ELEMENT>
		<ELEMENT NAME='DESCRIPTION'></ELEMENT>
	</MULTI-INPUT>]]>
	</xsl:variable>
	
	<xsl:variable name="articleeditorfields">
	<![CDATA[<MULTI-INPUT>
		<REQUIRED NAME='TYPE'></REQUIRED>
		<REQUIRED NAME='BODY'></REQUIRED>
		<REQUIRED NAME='TITLE'></REQUIRED>
		<ELEMENT NAME='PAGEHEADER'></ELEMENT>
		<ELEMENT NAME='BANNER'></ELEMENT>
		<ELEMENT NAME='FLASH'></ELEMENT>
		<ELEMENT NAME='TIPSHEADER'></ELEMENT>
		<ELEMENT NAME='TIPS'></ELEMENT>
		<ELEMENT NAME='IMAGEPROMOS'></ELEMENT>
		<ELEMENT NAME='SUBPROMO1'></ELEMENT>
		<ELEMENT NAME='SUBPROMO2'></ELEMENT>
		<ELEMENT NAME='SUBPROMO3'></ELEMENT>
		<ELEMENT NAME='SUBPROMO4'></ELEMENT>
		<ELEMENT NAME='DESCRIPTION'></ELEMENT>
		<ELEMENT NAME='PART1'></ELEMENT>
		<ELEMENT NAME='PART2'></ELEMENT>
		<ELEMENT NAME='PART3'></ELEMENT>
		<ELEMENT NAME='PART4'></ELEMENT>
	</MULTI-INPUT>]]>
	</xsl:variable>
	
	<xsl:variable name="excercisefields">
	<![CDATA[<MULTI-INPUT>
		<REQUIRED NAME='TYPE'></REQUIRED>
		<REQUIRED NAME='BODY'><VALIDATE TYPE='EMPTY'/></REQUIRED>
		<REQUIRED NAME='TITLE'><VALIDATE TYPE='EMPTY'/></REQUIRED>
		<ELEMENT NAME='DESCRIPTION'></ELEMENT>
		<ELEMENT NAME='PAGETITLE'></ELEMENT>
		<ELEMENT NAME='PART'></ELEMENT>
	</MULTI-INPUT>]]>
	</xsl:variable>
	
	
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
									Page - Level  template
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<xsl:template name="TYPED-ARTICLE_MAINBODY">
		<xsl:apply-templates select="PARSEERRORS" mode="c_typedarticle"/>
		
		<xsl:apply-templates select="DELETED" mode="c_article"/>
		<xsl:apply-templates select="MULTI-STAGE" mode="c_article"/>
	</xsl:template>
	<!--
	<xsl:template match="MULTI-STAGE" mode="create_article">
	Use: Presentation of the create / edit article functionality
	 -->
	<xsl:template match="MULTI-STAGE" mode="r_article">
<!-- <input type="hidden" name="skin" value="purexml"/>  -->

   <input type="hidden" name="SUBMITTABLE" value="1"/>
     	<!-- ERROR -->
		<xsl:apply-templates select="/H2G2/MULTI-STAGE/MULTI-REQUIRED/ERRORS/ERROR | /H2G2/MULTI-STAGE/MULTI-ELEMENT/ERRORS/ERROR" mode="c_typedarticle"/>

   <!-- WRITE CREATIVE-->
	<xsl:choose>
	<xsl:when test="$layout_type='articleeditor' or $current_article_type=2001 or /H2G2/ARTICLE/ARTICLEINFO/STATUS/@TYPE='9' or $current_article_type=2 or /H2G2/ARTICLE/ARTICLEINFO/PAGEAUTHOR/EDITOR/USER/GROUPS/GROUP[@NAME='Editor'] and $current_article_type=1">
	<xsl:call-template name="FORM_EDITORARTICLE" />
	</xsl:when>
	<xsl:when test="$article_type_group='creative'">
	<xsl:call-template name="WRITE_CREATIVE" />
	</xsl:when>
	<xsl:when test="$article_type_group='advice'">
	<xsl:call-template name="WRITE_ADVICE" />
	</xsl:when>
	<xsl:when test="$article_type_group='challenge'">
	<xsl:call-template name="CHALLENGE" />
	</xsl:when>
	<xsl:when test="$article_type_group='excercise'">
	<xsl:call-template name="EXCERCISE" />
	</xsl:when>
	<xsl:when test="$article_type_group='frontpage'">
	<xsl:call-template name="FORM_FRONTPAGES" />
	</xsl:when>
	<xsl:otherwise>
	
	<!-- PREVIEW -->
	<xsl:apply-templates select="." mode="c_preview"/>
	
	<!-- GENERIC -->
		<input type="hidden" name="_msfinish" value="yes"/>
		<input type="hidden" name="_msxml" value="{$articlefields}">
	
		</input>
	
		Title:<br/>
		<xsl:apply-templates select="." mode="t_articletitle"/>
		<br/>
	
		Body:
		<br/>
		<xsl:apply-templates select="." mode="t_articlebody"/>
		
		article type:<xsl:apply-templates select="." mode="t_articletype"/>
		<xsl:apply-templates select="." mode="t_articlepreviewbutton"/>
		<xsl:apply-templates select="." mode="c_articleeditbutton"/>
		<xsl:apply-templates select="." mode="c_articlecreatebutton"/>
		<xsl:apply-templates select="." mode="c_deletearticle"/>
	
	</xsl:otherwise>
	</xsl:choose>
	

	
    <xsl:if test="$test_IsEditor">
	<!-- HIDE ARTICLE -->
	<div class="editboxheader2">For editors only</div>
	<div class="editbox2">
	<xsl:apply-templates select="/H2G2/MULTI-STAGE" mode="c_hidearticle"/><br/>
	article type:&nbsp;<xsl:apply-templates select="." mode="t_articletype"/>
	<xsl:apply-templates select="." mode="c_articlestatus"/>
	</div>
	</xsl:if>
		
	</xsl:template>
		
	<!-- ARTICLE TYPE DROPDOWN -->
	<xsl:template match="MULTI-STAGE" mode="r_articletype">
	<xsl:param name="group" />
	<xsl:param name="user" />

	<select name="type">
	<xsl:apply-templates select="msxsl:node-set($type)/type[@group=$group and @user=$user]" mode="c_articletype"/>

	<xsl:if test="$test_IsEditor">		
		<option>--------change type-------</option>
	    <option value="41">advice</option>
		<option value="42">challenge</option>
		<option value="2">editor article</option>
		<option value="2001">review circle</option>
		<!-- <option value="2001">review circle</option> -->
	</xsl:if>
	</select>
	</xsl:template>

	<xsl:template match="type" mode="c_articletype">
	
	<!-- use either selected number or normal number depending on status -->
		<xsl:variable name="articletype_number">
		<xsl:choose>
		<xsl:when test="$selected_status='on'">
			<xsl:value-of select="@selectnumber" />
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="@number" />
		</xsl:otherwise>
		</xsl:choose>
		</xsl:variable>
	
		<option value="{$articletype_number}">
		<xsl:if test="$current_article_type=$articletype_number">
		<xsl:attribute name="selected">selected</xsl:attribute>
		</xsl:if>
		<xsl:value-of select="@label" />
		</option>
	
	
	</xsl:template>
	<!-- END ARTICLE TYPE DROPDOWN -->
	
	<xsl:template match="MULTI-STAGE" mode="r_articlestatus">
		<br/>
		article status:
		<xsl:choose>
		<xsl:when test="@TYPE='TYPED-ARTICLE-CREATE'">
		<input type="text" name="status" value="3" xsl:use-attribute-sets="iMULTI-STAGE_r_articlestatus"/></xsl:when>
		<xsl:otherwise>
		<input type="text" name="STATUS" value="{MULTI-REQUIRED[@NAME='STATUS']/VALUE-EDITABLE}" />
		</xsl:otherwise>
		</xsl:choose>
			
		<!-- <xsl:apply-imports/> -->
		<br/>
	</xsl:template>

	<!--
	<xsl:template match="MULTI-STAGE" mode="r_preview">
	Use: Presentation of the preview area
	 -->
	<xsl:template match="MULTI-STAGE" mode="r_preview">
	
	<xsl:choose>
	<!-- FOR ALL FRONTPAGES -->
	<xsl:when test="$layout_type='front3column'">
	<xsl:call-template name="FRONT3COLUMN_MAINBODY"/>
	</xsl:when>
	<xsl:when test="$layout_type='front2column'">
	<xsl:call-template name="FRONT2COLUMN_MAINBODY"/>
	</xsl:when>
	<xsl:when test="$layout_type='articleeditor'">
	<xsl:call-template name="ARTICLEEDITOR_MAINBODY"/>
	</xsl:when>
	<xsl:otherwise>
	<table width="410" border="0" cellspacing="0" cellpadding="0">
	<tr>
	<td>
	<div class="PageContent">
	<xsl:apply-templates select="/H2G2/ARTICLE" mode="c_articlepage"/>
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
	<xsl:when test="$test_IsEditor and $layout_type='articleeditor'">
		<div class="error">
		<div class="errortext"><xsl:element name="{$text.heading}" use-attribute-sets="text.heading">error</xsl:element></div>
		<xsl:element name="{$text.base}" use-attribute-sets="text.base">
		<xsl:apply-templates select="*|@*|text()"/>
		</xsl:element>
		</div>
	</xsl:when>
	<xsl:otherwise>


	<xsl:choose>
	<xsl:when test="@TYPE='VALIDATION-ERROR-PARSE'">
		<div class="error">
		<div class="errortext"><xsl:element name="{$text.heading}" use-attribute-sets="text.heading">error</xsl:element></div>
		<xsl:element name="{$text.base}" use-attribute-sets="text.base">
		There is a problem with your page. You may have used an "&lt;" symbol which unfortunately doesn't work on Get Writing.  Please remove it and click preview again.
		</xsl:element>
		</div>
	</xsl:when>
	<xsl:otherwise></xsl:otherwise>
	</xsl:choose>

</xsl:otherwise>
</xsl:choose>

</xsl:template>
	<!--
	<xsl:template match="DELETED" mode="r_deleted">
	Use: Template invoked after deleting an article
	 -->
	<xsl:template match="DELETED" mode="r_article">
	<div class="PageContent">
	<br/>
	<div class="box2">
	<xsl:element name="{$text.base}" use-attribute-sets="text.base">
This article has been deleted. 
<!-- ################ removed for site pulldown ################ -->
	<xsl:if test="$test_IsEditor">If you want to restore any deleted articles you can view them
 <xsl:apply-imports/>
	</xsl:if>
	</xsl:element>
	</div>
	
	</div>
	
	

	</xsl:template>
	
	    <!--
      <xsl:template match="MULTI-STAGE" mode="r_hidearticle">
      Use: Presentation of the hide article functionality
       -->

      <xsl:template match="MULTI-STAGE" mode="r_hidearticle">
            Hide this article: <xsl:apply-templates select="." mode="t_hidearticle"/>
      </xsl:template>

	
	<xsl:template match="MULTI-REQUIRED|MULTI-ELEMENT" mode="c_error">

		<xsl:choose>
		<xsl:when test="ERRORS/ERROR/@TYPE='VALIDATION-ERROR-EMPTY'">
		<font color="#FF0000">*</font>
		</xsl:when>
		<xsl:otherwise>*</xsl:otherwise>
		</xsl:choose>
	
	</xsl:template>

	<!--
	<xsl:attribute-set name="fMULTI-STAGE_c_article"/>
	Use: 
	 -->
	<xsl:attribute-set name="fMULTI-STAGE_c_article"/>
	<!--
	<xsl:attribute-set name="iMULTI-STAGE_t_articletitle"/>
	Use: 
	 -->
	<xsl:attribute-set name="iMULTI-STAGE_t_articletitle"/>
		<xsl:attribute-set name="mMULTI-STAGE_t_articlebody">
		<xsl:attribute name="maxlength">
			<xsl:choose>
			<xsl:when test="$article_type_group='creative'">3000</xsl:when>
			<xsl:otherwise></xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>
		<xsl:attribute name="cols">
			<xsl:choose>
			<xsl:when test="$article_type_group='frontpage'">55</xsl:when>
			<xsl:when test="$layout_type='articleeditor'">55</xsl:when>
			<xsl:otherwise>45</xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>
		<xsl:attribute name="rows">
			<xsl:choose>
			<xsl:when test="$article_type_group='minicourse'">20</xsl:when>
			<xsl:otherwise>20</xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>
	</xsl:attribute-set>

	<!-- Buttons -->
	<!-- lots of duplication here ? a lot the var names seem redundant in the base xsl -->
	<xsl:attribute-set name="mMULTI-STAGE_t_articlepreviewbutton" use-attribute-sets="form.preview" />
	<xsl:attribute-set name="mMULTI-STAGE_t_articlepreview" use-attribute-sets="form.preview" />
	<xsl:attribute-set name="mMULTI-STAGE_t_articlecreate" use-attribute-sets="form.publish" />
	<xsl:attribute-set name="mMULTI-STAGE_t_articlecreatebutton" use-attribute-sets="form.publish" />
	<xsl:attribute-set name="mMULTI-STAGE_r_articlecreatebutton" use-attribute-sets="form.publish" />
	<xsl:attribute-set name="mMULTI-STAGE_r_articleeditbutton" use-attribute-sets="form.publish" />

	
</xsl:stylesheet>
