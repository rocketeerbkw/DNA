<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<xsl:import href="../../../base/base-typedarticle.xsl"/>
	<xsl:variable name="articlefields"><![CDATA[<MULTI-INPUT>
						<REQUIRED NAME='TYPE'></REQUIRED>
						<REQUIRED NAME='BODY'></REQUIRED>
						<REQUIRED NAME='TITLE'></REQUIRED>
						<REQUIRED NAME='HIDEARTICLE'><VALIDATE TYPE='EMPTY'/></REQUIRED>
				</MULTI-INPUT>]]></xsl:variable>
	<xsl:variable name="createtype"><![CDATA[<MULTI-INPUT>
									<REQUIRED NAME='TYPE'></REQUIRED>
									<REQUIRED NAME='BODY'></REQUIRED>
								<REQUIRED NAME='TITLE'></REQUIRED>
								<REQUIRED NAME='HIDEARTICLE'><VALIDATE TYPE='EMPTY'/></REQUIRED>

								   </MULTI-INPUT>]]></xsl:variable>
	<!-- NOTES - CONTACT are editorial only -->
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
									Page - Level  template
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<xsl:template name="TYPED-ARTICLE_MAINBODY">
		<xsl:if test="$test_IsEditor">
			<a href="{$root}TypedArticle?acreate=new&amp;_msxml={$createtype}&amp;type=1">Create an article</a>
			<br/>
			<xsl:apply-templates select="PARSEERRORS" mode="c_typedarticle"/>
			<xsl:apply-templates select="ERROR" mode="c_typedarticle"/>
			<xsl:apply-templates select="DELETED" mode="c_article"/>
			<xsl:apply-templates select="MULTI-STAGE" mode="c_article"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="MULTI-STAGE" mode="create_article">
	Use: Presentation of the create / edit article functionality
	 -->
	<xsl:template match="MULTI-STAGE" mode="r_article">
		<input type="hidden" name="_msfinish" value="yes"/>
		<input type="hidden" name="_msxml" value="{$articlefields}"/>
		<xsl:apply-templates select="." mode="c_preview"/>
		Title:<br/>
		<xsl:apply-templates select="." mode="t_articletitle"/>
		<br/>
		<!--Role:
		<br/>
		<textarea name="ROLE" cols="40" rows="8">
			<xsl:choose>
				<xsl:when test="/H2G2/TYPED-ARTICLE-EDIT-FORM">
					<xsl:value-of select="/H2G2/TYPED-ARTICLE-EDIT-FORM/ARTICLE/GUIDE/ROLE"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="MULTI-ELEMENT[@NAME='ROLE']/VALUE"/>
				</xsl:otherwise>
			</xsl:choose>
			
		</textarea>
		<br/-->		
		Body:
		<br/>
		<xsl:apply-templates select="." mode="t_articlebody"/>
		<xsl:apply-templates select="." mode="c_permissionchange"/>
		<xsl:apply-templates select="." mode="c_articlestatus"/>
		<xsl:apply-templates select="." mode="c_articletype"/>
		<xsl:apply-templates select="." mode="c_makearchive"/>
		<xsl:apply-templates select="." mode="c_deletearticle"/>
		<xsl:apply-templates select="." mode="c_hidearticle"/>
		<xsl:apply-templates select="." mode="t_articlepreviewbutton"/>
		<xsl:apply-templates select="." mode="c_articleeditbutton"/>
		<xsl:apply-templates select="." mode="c_articlecreatebutton"/>
		<!--<xsl:apply-templates select="." mode="c_authorlist"/>-->
	</xsl:template>
	<!--
	<xsl:template match="MULTI-STAGE" mode="r_permissionchange">
	Use: Presentation of the article edit permissions functionality
	 -->
	<xsl:template match="MULTI-STAGE" mode="r_permissionchange">
		<p>
			Editable by:			
			<ul>
				<li>
					<xsl:apply-templates select="." mode="t_permissionowner"/> Owner only
				</li>
				<li>
					<xsl:apply-templates select="." mode="t_permissionall"/> Everybody
				</li>
			</ul>
		</p>
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
		<br/>
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
		<br/>
		<xsl:text>---------------------------------------------------</xsl:text>
		<br/>
		<xsl:value-of select="/H2G2/ARTICLE/SUBJECT"/>
		<br/>
		<xsl:apply-templates select="/H2G2/ARTICLE/GUIDE/BODY"/>
		<br/>
		<xsl:text>---------------------------------------------------</xsl:text>
		<br/>
	</xsl:template>
	<!--
	<xsl:template match="MULTI-STAGE" mode="r_deletearticle">
	Use: Presentation of the delete article functionality
	 -->
	<xsl:template match="MULTI-STAGE" mode="r_deletearticle">
		<xsl:apply-imports/>
		<br/>
	</xsl:template>
	<!--
	<xsl:template match="MULTI-STAGE" mode="r_hidearticle">
	Use: Presentation of the hide article functionality
	 -->
	<xsl:template match="MULTI-STAGE" mode="r_hidearticle">
		Hide this article: <xsl:apply-templates select="." mode="t_hidearticle"/>
		<br/>
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
		<xsl:apply-imports/>
	</xsl:template>
	<!--
	<xsl:template match="DELETED" mode="r_deleted">
	Use: Template invoked after deleting an article
	 -->
	<xsl:template match="DELETED" mode="r_article">
		This article has been deleted. If you want to restore any deleted articles you can view them <xsl:apply-imports/>
	</xsl:template>
	<xsl:attribute-set name="fMULTI-STAGE_c_article"/>
	<xsl:attribute-set name="iMULTI-STAGE_t_articletitle"/>
	<xsl:attribute-set name="mMULTI-STAGE_t_articlebody"/>
	<xsl:attribute-set name="mMULTI-STAGE_t_articlepreview"/>
	<xsl:attribute-set name="mMULTI-STAGE_t_articlecreate"/>
	<xsl:attribute-set name="iMULTI-STAGE_t_makearchive"/>
	<xsl:attribute-set name="mMULTI-STAGE_t_hidearticle"/>
	<xsl:attribute-set name="mMULTI-STAGE_t_permissionowner"/>
	<xsl:attribute-set name="mMULTI-STAGE_t_permissionall"/>
	<!--<xsl:attribute-set name="mMULTI-STAGE_t_authorlist"/>-->
</xsl:stylesheet>
