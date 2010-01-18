<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">


<xsl:template name="FORM_FRONTPAGES">
	<!-- DEBUG -->
	<xsl:call-template name="TRACE">
	<xsl:with-param name="message">FORM_FRONTPAGES</xsl:with-param>
	<xsl:with-param name="pagename">formfrontpages.xsl</xsl:with-param>
	</xsl:call-template>
	<!-- DEBUG -->
	

	
	<!-- PREVIEW -->
	<xsl:apply-templates select="." mode="c_preview"/>
	
	<!-- FORM -->
	<input type="hidden" name="_msfinish" value="yes"/>
	<input type="hidden" name="_msxml" value="{$frontpagefields}"/>

	<!-- <input type="hidden" name="skin" value="purexml"/> -->
	
	<xsl:if test="@TYPE='TYPED-ARTICLE-CREATE'">
	
	<xsl:apply-templates select="." mode="r_articletype"> 
	<xsl:with-param name="group" select="$article_type_group" />
	<xsl:with-param name="user" select="$article_type_user" />
	</xsl:apply-templates> 
	
	</xsl:if>
	
	<h2><xsl:value-of select="$article_type_label" /> editor form</h2>
	<!-- start of table -->
	<xsl:element name="table" use-attribute-sets="html.table.container">
	<tr>
	<xsl:element name="td" use-attribute-sets="column.1">
	<xsl:element name="{$text.base}" use-attribute-sets="text.base">
	<xsl:if test="MULTI-REQUIRED[@NAME='TITLE']/ERRORS/ERROR">
	<span class="errortext">*</span>
	</xsl:if>
	<strong>Title:</strong><br/>
	<xsl:apply-templates select="." mode="t_articletitle"/>
	<br/>
	<br/>
	<xsl:if test="MULTI-ELEMENT[@NAME='DESCRIPTION']/ERRORS/ERROR">
	<span class="errortext">*</span>
	</xsl:if>
	<strong>Description:</strong><br/>
	<textarea name="DESCRIPTION" cols="55" rows="5">
	<xsl:value-of select="MULTI-ELEMENT[@NAME='DESCRIPTION']/VALUE-EDITABLE"/>
	</textarea>
	<br/>
	<br/>
	
	<xsl:if test="MULTI-ELEMENT[@NAME='BANNER']/ERRORS/ERROR">
	<span class="errortext">*</span>
	</xsl:if>
	<strong>Banner:</strong><br/>
	<textarea name="BANNER" cols="55" rows="10">
	<xsl:value-of select="MULTI-ELEMENT[@NAME='BANNER']/VALUE-EDITABLE"/>
	</textarea>
	<br/>
	<br/>
	<xsl:if test="MULTI-REQUIRED[@NAME='BODY']/ERRORS/ERROR">
	<span class="errortext">*</span>
	</xsl:if>
	<strong>Main Promo:</strong><br/>
	<br/>
	<br/>
	<xsl:apply-templates select="." mode="t_articlebody"/>

	<br/>
	<xsl:if test="MULTI-ELEMENT[@NAME='SUBPROMO1']/ERRORS/ERROR">
	<span class="errortext">*</span>
	</xsl:if>
	<strong>Footer/Tips/Images:</strong><br/>
	<textarea name="SUBPROMO1" cols="55" rows="10">
	<xsl:value-of select="MULTI-ELEMENT[@NAME='SUBPROMO1']/VALUE-EDITABLE"/>
	</textarea>
	<br/>
	<br/>

	<xsl:apply-templates select="." mode="t_articlepreviewbutton"/>
	<xsl:apply-templates select="." mode="c_articleeditbutton"/>
	<xsl:apply-templates select="." mode="c_articlecreatebutton"/>
	<xsl:apply-templates select="." mode="c_deletearticle"/>
	</xsl:element>
	</xsl:element>
	<xsl:element name="td" use-attribute-sets="column.2">
	<xsl:element name="{$text.base}" use-attribute-sets="text.base">
	<xsl:if test="MULTI-ELEMENT[@NAME='SUBPROMO2']/ERRORS/ERROR">
	<span class="errortext">*</span>
	</xsl:if>
	<strong>Top nav/Tips/Images:</strong><br/>
	<textarea name="SUBPROMO2" cols="35" rows="10">
	<xsl:value-of select="MULTI-ELEMENT[@NAME='SUBPROMO2']/VALUE-EDITABLE"/>
	</textarea>
	<br/>
	<br/>
	
	<xsl:if test="MULTI-ELEMENT[@NAME='SUBPROMO3']/ERRORS/ERROR">
	<span class="errortext">*</span>
	</xsl:if>
	<strong>Middle nav/Tips/Images:</strong><br/>
	<textarea name="SUBPROMO3" cols="35" rows="10">
	<xsl:value-of select="MULTI-ELEMENT[@NAME='SUBPROMO3']/VALUE-EDITABLE"/>
	</textarea>
	<br/>
	<br/>

	<xsl:if test="MULTI-ELEMENT[@NAME='SUBPROMO4']/ERRORS/ERROR">
	<span class="errortext">*</span>
	</xsl:if>
	<strong>Bottom nav/Tips/Images:</strong><br/>
	<textarea name="SUBPROMO4" cols="35" rows="10">
	<xsl:value-of select="MULTI-ELEMENT[@NAME='SUBPROMO4']/VALUE-EDITABLE"/>
	</textarea>
	</xsl:element>
		
	</xsl:element>
	</tr>
	</xsl:element>
	<!-- end of table -->	

	
</xsl:template>
	
</xsl:stylesheet>
