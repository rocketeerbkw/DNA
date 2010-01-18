<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">

<xsl:template name="FORM_EDITORARTICLE">
	<!-- DEBUG -->
	<xsl:call-template name="TRACE">
	<xsl:with-param name="message">FORM_EDITORARTICLE</xsl:with-param>
	<xsl:with-param name="pagename">formarticleeditor.xsl</xsl:with-param>
	</xsl:call-template>
	<!-- DEBUG -->
	

	
	<!-- PREVIEW -->
	<xsl:apply-templates select="." mode="c_preview"/>
	
	<!-- FORM -->
	<input type="hidden" name="_msfinish" value="yes"/>
	<input type="hidden" name="_msxml" value="{$articleeditorfields}"/>
	<!-- <input type="hidden" name="skin" value="purexml"/> -->
	
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
	
	
	<xsl:if test="MULTI-ELEMENT[@NAME='FLASH']/ERRORS/ERROR">
	<span class="errortext">*</span>
	</xsl:if>
	<strong>Flash:</strong><br/>
	<textarea name="FLASH" cols="55" rows="5">
	<xsl:value-of select="MULTI-ELEMENT[@NAME='FLASH']/VALUE-EDITABLE"/>
	</textarea>
	<br/>
	<br/>
	
	
	<xsl:if test="$article_type_group!='minicourse'">
	<xsl:if test="MULTI-ELEMENT[@NAME='BANNER']/ERRORS/ERROR">
	<span class="errortext">*</span>
	</xsl:if>
	<strong>Banner:</strong><br/>
	<textarea name="BANNER" cols="55" rows="10">
	<xsl:value-of select="MULTI-ELEMENT[@NAME='BANNER']/VALUE-EDITABLE"/>
	</textarea>
	<br/>
	<br/>
	</xsl:if>
	
	<xsl:if test="MULTI-REQUIRED[@NAME='BODY']/ERRORS/ERROR">
	<span class="errortext">*</span>
	</xsl:if>
	<strong>Main Promo:</strong><br/>
	<xsl:apply-templates select="." mode="t_articlebody"/>
	<br/>
	
	<xsl:if test="$article_type_group='minicourse'">
	<xsl:if test="MULTI-ELEMENT[@NAME='PART1']/ERRORS/ERROR">
	<span class="errortext">*</span>
	</xsl:if>
	<strong>Part 1:</strong><br/>
	<textarea name="PART1" cols="55" rows="15">
	<xsl:value-of select="MULTI-ELEMENT[@NAME='PART1']/VALUE-EDITABLE"/>
	</textarea><br/>
	<xsl:if test="MULTI-ELEMENT[@NAME='PART2']/ERRORS/ERROR">
	<span class="errortext">*</span>
	</xsl:if>
	<strong>Part 2:</strong><br/>
	<textarea name="PART2" cols="55" rows="15">
	<xsl:value-of select="MULTI-ELEMENT[@NAME='PART2']/VALUE-EDITABLE"/>
	</textarea><br/>
	<xsl:if test="MULTI-ELEMENT[@NAME='PART3']/ERRORS/ERROR">
	<span class="errortext">*</span>
	</xsl:if>
	<strong>Part 3:</strong><br/>
	<textarea name="PART3" cols="55" rows="15">
	<xsl:value-of select="MULTI-ELEMENT[@NAME='PART3']/VALUE-EDITABLE"/>
	</textarea><br/>
	<xsl:if test="MULTI-ELEMENT[@NAME='PART4']/ERRORS/ERROR">
	<span class="errortext">*</span>
	</xsl:if>
	<strong>Part 4:</strong><br/>
	<textarea name="PART4" cols="55" rows="15">
	<xsl:value-of select="MULTI-ELEMENT[@NAME='PART4']/VALUE-EDITABLE"/>
	</textarea>
	<br/>
	<br/>
	</xsl:if>
	
	<xsl:if test="MULTI-ELEMENT[@NAME='SUBPROMO1']/ERRORS/ERROR">
	<span class="errortext">*</span>
	</xsl:if>
	<strong>Footer/Tips/Images:</strong><br/>
	<textarea name="SUBPROMO1" cols="55" rows="10">
	<xsl:value-of select="MULTI-ELEMENT[@NAME='SUBPROMO1']/VALUE-EDITABLE"/>
	</textarea>
	<br/>
	<br/>
	

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
	<xsl:apply-templates select="MULTI-REQUIRED[@NAME='SUBPROMO2']" mode="c_error"/>
	<strong>Top nav/Tips/Images:</strong><br/>
	<textarea name="SUBPROMO2" cols="35" rows="10">
	<xsl:value-of select="MULTI-ELEMENT[@NAME='SUBPROMO2']/VALUE-EDITABLE"/>
	</textarea>
	<br/>
	<br/>
	
	<xsl:apply-templates select="MULTI-REQUIRED[@NAME='SUBPROMO3']" mode="c_error"/>
	<strong>Middle nav/Tips/Images:</strong><br/>
	<textarea name="SUBPROMO3" cols="35" rows="10">
	<xsl:value-of select="MULTI-ELEMENT[@NAME='SUBPROMO3']/VALUE-EDITABLE"/>
	</textarea>
	<br/>
	<br/>

	<xsl:apply-templates select="MULTI-REQUIRED[@NAME='SUBPROMO4']" mode="c_error"/>
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
