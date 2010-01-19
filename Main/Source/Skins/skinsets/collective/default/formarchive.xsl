<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">

<xsl:template name="EDITOR_ARCHIVE">

	<!-- DEBUG -->
	<xsl:call-template name="TRACE">
	<xsl:with-param name="message">EDITOR_archive</xsl:with-param>
	<xsl:with-param name="pagename">formarchive.xsl</xsl:with-param>
	</xsl:call-template>
	<!-- DEBUG -->

		<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
		<xsl:element name="td" use-attribute-sets="column.1">
		<!-- FORM HEADER -->
		<xsl:if test="/H2G2/MULTI-STAGE[@TYPE='TYPED-ARTICLE-EDIT-PREVIEW' or @TYPE='TYPED-ARTICLE-PREVIEW']">
			<div class="useredit-u-a">
			<xsl:copy-of select="$myspace.tools.black" />&nbsp;
				<xsl:element name="{$text.subheading}" use-attribute-sets="text.subheading">
				<strong class="white">edit your <xsl:value-of select="$article_type_group" /></strong>
				</xsl:element>
			</div>
		</xsl:if>
		
		<!-- FORM BOX -->
		<div class="form-wrapper">
		<a name="edit" id="edit"></a>
	    <input type="hidden" name="_msfinish" value="yes"/>
    <!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
									FRONT PAGE FORM
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<input type="hidden" name="_msxml" value="{$frontpagearticlefields}"/>

	<table>
	<tr>
	<td>
	<xsl:element name="{$text.base}" use-attribute-sets="text.base"><b>Title:</b></xsl:element><br />
	<xsl:apply-templates select="." mode="t_articletitle"/>
	</td>
	<td>	
	<xsl:element name="{$text.base}" use-attribute-sets="text.base"><b>Archive</b></xsl:element><br />
	<xsl:apply-templates select="." mode="r_articletype"> 
	<xsl:with-param name="group" select="$article_type_group" />
	<xsl:with-param name="user" select="$article_type_user" />
	</xsl:apply-templates> 
	</td>
	</tr>
	<tr>
	<td colspan="2">
	<xsl:element name="{$text.base}" use-attribute-sets="text.base"><b>Body:</b></xsl:element><br />
	<xsl:apply-templates select="." mode="t_articlebody"/>
	</td>
	</tr>
	<tr>
	<td colspan="2">
	<xsl:element name="{$text.base}" use-attribute-sets="text.base"><b>Description:</b></xsl:element><br />
	<textarea name="DESCRIPTION" ID="DESCRIPTION" cols="65" rows="5">
	<xsl:value-of select="MULTI-ELEMENT[@NAME='DESCRIPTION']/VALUE-EDITABLE"/>
</textarea><br /><br />
	<xsl:element name="{$text.base}" use-attribute-sets="text.base"><b>Keywords:</b></xsl:element><br />
	<textarea name="KEYWORDS" ID="KEYWORDS" cols="65" rows="5">
	<xsl:value-of select="MULTI-ELEMENT[@NAME='KEYWORDS']/VALUE-EDITABLE"/>
</textarea>
	</td>
	</tr>
	</table>

	<!--EDIT BUTTONS --> 
	
	<!-- STATUS -->
	<div>
	<xsl:apply-templates select="/H2G2/MULTI-STAGE" mode="c_articlestatus"/>
	</div>
	
	<!-- HIDE ARTICLE -->
	<div><xsl:apply-templates select="/H2G2/MULTI-STAGE" mode="c_hidearticle"/></div>
	
	<!-- PREVIEW -->
	<xsl:apply-templates select="." mode="t_articlepreviewbutton"/>
		
	<!-- CREATE/PUBLISH/EDIT -->
		<a name="publish" id="publish"></a>
		<xsl:apply-templates select="." mode="c_articleeditbutton"/> 
	    <xsl:apply-templates select="." mode="c_articlecreatebutton"/>
		<xsl:apply-templates select="." mode="c_deletearticle"/>
		
	<!-- DELETE ARTICLE commented out as per request Matt W 13/04/2004 -->
	   <!-- <xsl:apply-templates select="." mode="c_deletearticle"/> -->
	</div>

		<xsl:element name="img" use-attribute-sets="column.spacer.1" />
		</xsl:element>


		<xsl:element name="td" use-attribute-sets="column.3"><xsl:element name="img" use-attribute-sets="column.spacer.3" /></xsl:element>

		</tr>
	</table>
	</xsl:template>
	
</xsl:stylesheet>
