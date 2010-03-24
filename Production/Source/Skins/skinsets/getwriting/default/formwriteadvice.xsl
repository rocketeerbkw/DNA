<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">


<xsl:template name="WRITE_ADVICE">

    <!-- PREVIEW -->
	<xsl:apply-templates select="." mode="c_preview"/>		
	
	<!-- FORM -->
	<input type="hidden" name="_msfinish" value="yes"/>
	<input type="hidden" name="_msxml" value="{$articlefields}"/>
	<input type="hidden" name="type" value="{$current_article_type}"/>
	<!-- <input type="hidden" name="skin" value="purexml"/> -->
	<!-- start of table -->
	<xsl:element name="table" use-attribute-sets="html.table.container">
	<tr>
	<xsl:element name="td" use-attribute-sets="column.1">
    <div class="PageContent">
	
	<a name="edit" id="edit"></a>
	<div class="titleBars" id="titleAdvice">
	<xsl:element name="{$text.base}" use-attribute-sets="text.base">
		<xsl:choose>
		<xsl:when test="@TYPE='TYPED-ARTICLE-CREATE'">
		<!-- SHARE YOUR ADVICE --> 
		YOU CAN NO LONGER PUBLISH ADVICE
		</xsl:when>
		<xsl:when test="@TYPE='TYPED-ARTICLE-EDIT' or @TYPE='TYPED-ARTICLE-EDIT-PREVIEW' or @TYPE='TYPED-ARTICLE-PREVIEW'">
		<!-- EDIT YOUR ADVICE -->
		REMOVE YOUR ADVICE
		</xsl:when>
		</xsl:choose>
	<br/>
	</xsl:element>
	</div>	
	

	<!-- ################ removed for site pulldown ################ -->
	<xsl:choose>
	<xsl:when test="$test_IsEditor">
	<div class="box6">
	<xsl:element name="{$text.small}" use-attribute-sets="text.small">
	<span class="requiredtext">* = required field</span>
	</xsl:element>
	</div>
	
	<div class="box2">
	<div class="headinggeneric">
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	TITLE OF YOUR ADVICE <xsl:apply-templates select="MULTI-REQUIRED[@NAME='TITLE']" mode="c_error"/>
	</xsl:element>
	</div>
	
	<xsl:apply-templates select="." mode="t_articletitle"/>
	<br/><br/>
	
	<div class="headinggeneric">
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	ADVICE<xsl:text>  </xsl:text><xsl:apply-templates select="MULTI-REQUIRED[@NAME='BODY']" mode="c_error"/>
	</xsl:element>
	</div>
	
	<div>
	<table width="360" border="0" cellspacing="0" cellpadding="0">
	<tr>
	<td>
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	-Do keep it under 3,000 words. Link pages together
	 if it's longer.<br/> 
	-Do copy &amp; paste from offline.<br/> 
	-Don't visit another page before publishing - you
	 could lose your work. <br/>
	 </xsl:element>
	</td>
	<td>
	<a href="{$root}aboutwrite#write0"><img src="{$graphics}icons/icon_help.gif" alt="Preview" width="57" height="36" border="0"/></a>
	</td>
	</tr>
	</table>
	</div>
	<br/>
	
	<xsl:apply-templates select="." mode="t_articlebody"/>
	<br/>
	<br/>
	<a name="publish" id="publish"></a>
	<xsl:apply-templates select="." mode="t_articlepreviewbutton"/>
	<xsl:apply-templates select="." mode="c_articleeditbutton"/>
	<xsl:apply-templates select="." mode="c_articlecreatebutton"/>
	<xsl:apply-templates select="." mode="c_deletearticle"/>

	</div>
	<!-- ################ end removed for site pulldown ################ -->
	</xsl:when>
	<xsl:otherwise>
	<div class="headinggeneric">
	<xsl:if test="@TYPE='TYPED-ARTICLE-EDIT' or @TYPE='TYPED-ARTICLE-EDIT-PREVIEW' or @TYPE='TYPED-ARTICLE-PREVIEW'"><br/>
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	TITLE OF YOUR ADVICE 
	</xsl:element>
	</xsl:if>
	</div>
	<xsl:apply-templates select="/H2G2/MULTI-STAGE/MULTI-REQUIRED[@NAME='TITLE']/VALUE-EDITABLE"/>
	<br/>
	<br/>
	<a name="publish" id="publish"></a>
	<xsl:apply-templates select="." mode="c_deletearticle"/>
	
	</xsl:otherwise>
	</xsl:choose>
	</div>
	
	</xsl:element>
	<xsl:element name="td" use-attribute-sets="column.2">
		<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
		<div class="rightnavboxheaderhint">HINTS &amp; TIPS</div>
		<div class="rightnavbox">
		
		<a href="{$root}advicenames?s_print=1&amp;s_type=pop" target="printpopup" onClick="popwin(this.href, this.target, 575, 600, 'scroll', 'resize'); return false;"><xsl:copy-of select="$button.seeexample" /></a>
		
		<xsl:copy-of select="$form.advice.tips" />
		</div>
		</xsl:element>
		
		<br/>
	</xsl:element>	
	
	</tr>
	</xsl:element>
	<!-- end of table -->	

	
</xsl:template>
	
</xsl:stylesheet>
