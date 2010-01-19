<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">

<xsl:template name="EXCERCISE">

	<!-- PREVIEW -->
	<xsl:apply-templates select="." mode="c_preview"/>
	
	<!-- FORM -->
	<input type="hidden" name="_msfinish" value="yes"/>
	<input type="hidden" name="_msxml" value="{$excercisefields}"/>
	<input type="hidden" name="type" value="{$current_article_type}"/>
	
	<xsl:variable name="minicourseinfo">&lt;ARTICLEID&gt;<xsl:value-of select="/H2G2/PARAMS/PARAM[NAME = 's_dnaid']/VALUE" />&lt;/ARTICLEID&gt;&lt;COURSENAME&gt;<xsl:value-of select="/H2G2/PARAMS/PARAM[NAME = 's_pagetitle']/VALUE" />&lt;/COURSENAME&gt;&lt;PART&gt;<xsl:value-of select="/H2G2/PARAMS/PARAM[NAME = 's_part']/VALUE" />&lt;/PART&gt;</xsl:variable>
	
	<input type="hidden" name="DESCRIPTION" value="{$minicourseinfo}"/>

	<!-- <input type="hidden" name="skin" value="purexml"/> -->
	<!-- start of table -->
	<xsl:element name="table" use-attribute-sets="html.table.container">
	<tr>
	<xsl:element name="td" use-attribute-sets="column.1">
<!-- 	<xsl:element name="{$text.base}" use-attribute-sets="text.base">
	This is for<br/>
	<strong><xsl:value-of select="/H2G2/PARAMS/PARAM[NAME = 's_pagetitle']/VALUE" /></strong></xsl:element> -->
	
	<div class="PageContent">
	<div class="titleBars" id="titleCreative">
	<xsl:element name="{$text.base}" use-attribute-sets="text.base">
		<xsl:choose>
		<xsl:when test="@TYPE='TYPED-ARTICLE-CREATE'">
		<!-- CREATE A NEW EXERCISE -->
		NO MORE EXERCISES
		</xsl:when>
		<xsl:when test="@TYPE='TYPED-ARTICLE-EDIT' or @TYPE='TYPED-ARTICLE-EDIT-PREVIEW' or @TYPE='TYPED-ARTICLE-PREVIEW'">
		<!-- EDIT YOUR EXCERCISE -->
		REMOVE YOUR EXERCISE
		</xsl:when>
		</xsl:choose>
	</xsl:element>
	</div>



	<!-- ################ removed for site pulldown ################ -->
	<xsl:choose>
	<xsl:when test="$test_IsEditor"><!-- $test_IsEditor -->


	<div class="box6">
	<xsl:element name="{$text.small}" use-attribute-sets="text.small">
	<span class="requiredtext">* = required field</span>
	</xsl:element>
	</div>

	<div class="box2">
	<div class="headinggeneric">
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	TITLE OF YOUR EXERCISE HERE: <xsl:apply-templates select="MULTI-REQUIRED[@NAME='TITLE']" mode="c_error"/>
	</xsl:element>
	</div>
	<xsl:apply-templates select="." mode="t_articletitle"/>
	<br/>
	<br/>
	<div class="headinggeneric">
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	EXERCISE: <xsl:apply-templates select="MULTI-REQUIRED[@NAME='BODY']" mode="c_error"/>
	</xsl:element>
	</div>
	<xsl:apply-templates select="." mode="t_articlebody"/>
	<br/>
	<br/>
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
	TITLE OF YOUR EXERCISE 
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
		<div class="rightnavboxheaderhint">HINTS AND TIPS</div>
		<div class="rightnavbox">
		
		<a href="{$root}exampleexercise?s_print=1&amp;s_type=pop" target="printpopup" onClick="popwin(this.href, this.target, 575, 600, 'scroll', 'resize'); return false;"><xsl:copy-of select="$button.seeexample" /></a>
		
		<xsl:copy-of select="$form.excercise.tips" />
		</div>
		</xsl:element>
		<br/>
		
	</xsl:element>
	</tr>
	</xsl:element>
	<!-- end of table -->	

	
</xsl:template>
	
</xsl:stylesheet>
