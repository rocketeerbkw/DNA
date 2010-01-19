<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">

<xsl:template name="EDITOR_CATEGORY">

	<!-- DEBUG -->
	<xsl:call-template name="TRACE">
	<xsl:with-param name="message">EDITOR_CATEGORY</xsl:with-param>
	<xsl:with-param name="pagename">formfrontpage.xsl</xsl:with-param>
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
	       <xsl:value-of select="name()"/>
	<xsl:apply-templates select="." mode="t_articletitle"/>
	</td>
	<td>	
	<xsl:element name="{$text.base}" use-attribute-sets="text.base"><b>Front page type</b></xsl:element><br />
	<input type="text" name="type" value="4001"/>
	</td>
	</tr>
	<tr>
	<td colspan="2">
	<xsl:element name="{$text.base}" use-attribute-sets="text.base"><b>Body:</b></xsl:element><br />
	<xsl:apply-templates select="." mode="t_articlebody"/>
	</td>
	</tr>
	</table>

	<!--EDIT BUTTONS --> 
	
	<!-- STATUS -->
	<div>
	status: <input type="text" name="status" value="1" xsl:use-attribute-sets="iMULTI-STAGE_r_articlestatus"/>
	</div>
	
	
	<!-- PREVIEW -->
	<xsl:apply-templates select="." mode="t_articlepreviewbutton"/>
		
	<!-- CREATE/PUBLISH/EDIT -->
		<a name="publish" id="publish"></a>
		<xsl:apply-templates select="." mode="c_articleeditbutton"/> 
	    <xsl:apply-templates select="." mode="c_articlecreatebutton"/>
		
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
