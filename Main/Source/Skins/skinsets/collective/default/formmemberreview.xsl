<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">

<xsl:template name="MEMBER_REVIEW">

	<!-- DEBUG -->
	<xsl:call-template name="TRACE">
	<xsl:with-param name="message">MEMBER_REVIEW</xsl:with-param>
	<xsl:with-param name="pagename">formmemberreview.xsl</xsl:with-param>
	</xsl:call-template>
	<!-- DEBUG -->

		<table border="0" cellspacing="0" cellpadding="0">
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
		<input type="hidden" name="_msxml" value="{$memberreviewfields}" />
		<!-- ARTICLE TYPE - TODO:13 -->
		<table cellspacing="0" cellpadding="5" border="0" width="393">
		<tr><td valign="top" id="form-grey" class="form-label">
		<!-- form item 1 -->
			<xsl:copy-of select="$icon.step.one" />
				<xsl:element name="{$text.base}" use-attribute-sets="text.base">
				<label for="write-review-form-1">what are you reviewing?</label><br />
				</xsl:element>
				<xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall">
					<span class="black"><span class="normal">
					<br />select a category from the list below. If nothing suits, pick "general".<br /><br />
					</span></span>
				</xsl:element>
				<xsl:apply-templates select="." mode="r_articletype"><xsl:with-param name="group" select="$article_type_group" /><xsl:with-param name="user" select="$article_type_user" /></xsl:apply-templates>
		</td><td valign="top" class="form-label">
		<!-- form item 2 -->
			<xsl:copy-of select="$icon.step.two" />
				<xsl:element name="{$text.base}" use-attribute-sets="text.base">
				<label class="form-label" for="write-review-form-2">give your review a title</label><br />
				</xsl:element>
				<xsl:apply-templates select="." mode="t_articletitle"/><br />
				<xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall">
					<span class="black"><span class="normal">
					e.g. blur - think tank, lost in translation, dr mukti - will self
					</span></span>
				</xsl:element><br />
		<!-- form item 3 -->
			<xsl:copy-of select="$icon.step.three" />
				<xsl:element name="{$text.base}" use-attribute-sets="text.base">
				<label class="form-label" for="write-review-form-3">rate it out of 5</label><br />
				</xsl:element>
				<xsl:apply-templates select="." mode="r_ratingtype"/><br />
				
		</td></tr>
		<tr>
		<td colspan="2" class="form-label">
		<!-- form item 4 -->
			<xsl:copy-of select="$icon.step.four" />
				<xsl:element name="{$text.base}" use-attribute-sets="text.base">
				<label class="form-label" for="write-review-form-4">give your review a bold headline</label><br />
				</xsl:element>
				<input type="text" name="HEADLINE" id="write-review-form-4" class="wr-4" value="{MULTI-ELEMENT[@NAME='HEADLINE']/VALUE-EDITABLE}" />
				<br />
				<xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall">
					<span class="black"><span class="normal">
						dark and brooding hip-hop from Birmingham
					</span></span>
				</xsl:element><br />
		</td></tr>
		<tr>
		<td colspan="2" class="form-label">
		<!-- form item 5 -->
			<xsl:copy-of select="$icon.step.five" />
				<xsl:element name="{$text.base}" use-attribute-sets="text.base">
				<label class="form-label" for="write-review-form-5">write your review here</label><br />
				</xsl:element>
				<xsl:apply-templates select="." mode="t_articlebody"/>
		</td></tr>
		<tr>
		<td colspan="2" class="form-label">
		<!-- form item 6 -->
			<xsl:copy-of select="$icon.step.six" />
		<xsl:element name="{$text.base}" use-attribute-sets="text.base">
				<label class="form-label"><span class="black">suggest a useful link (this is optional)</span></label><br />
				</xsl:element>
		<table cellspacing="0" cellpadding="2" border="0">
		<tr><td>
		<xsl:element name="{$text.base}" use-attribute-sets="text.base">
		<label class="form-label" for="write-review-step-6-url">url:</label>
				</xsl:element>
		</td><td>
		<input type="text" name="USEFULLINKS" id="write-review-step-6-url" value="{MULTI-ELEMENT[@NAME='USEFULLINKS']/VALUE-EDITABLE}" />
		</td></tr><tr><td>&nbsp;</td><td>
				<xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall">
					<span class="black"><span class="normal">
						e.g. http://www.bbc.co.uk/collective/
					</span></span>
				</xsl:element>
		</td></tr><tr><td>
		<xsl:element name="{$text.base}" use-attribute-sets="text.base">
		<label class="form-label" for="write-review-step-6-title">link title:</label>
		</xsl:element>
			</td><td>
			<input type="text" name="LINKTITLE" id="write-review-step-6-title" value="{MULTI-ELEMENT[@NAME='LINKTITLE']/VALUE-EDITABLE}" />
			</td></tr><tr><td>&nbsp;</td><td>
				<xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall">
					<span class="black"><span class="normal">
						e.g. BBC Collective
					</span></span>
				</xsl:element>
		</td></tr>
		<tr>
		<td colspan="2">
			<xsl:apply-templates select="/H2G2/MULTI-STAGE" mode="c_articlestatus"/>
		</td>
		</tr>
		</table>
	

		</td></tr>
		</table>


	<!--EDIT BUTTONS --> 

	
	<!-- PREVIEW -->
	<xsl:apply-templates select="." mode="t_articlepreviewbutton"/>
		
	<!-- CREATE/PUBLISH/EDIT -->
		<a name="publish" id="publish"></a>
		<xsl:apply-templates select="." mode="c_articleeditbutton"/> 
	    <xsl:apply-templates select="." mode="c_articlecreatebutton"/>
		<xsl:apply-templates select="." mode="c_deletearticle"/>
	</div>

		<xsl:element name="img" use-attribute-sets="column.spacer.1" />
		</xsl:element>


		<xsl:element name="td" use-attribute-sets="column.3"><xsl:element name="img" use-attribute-sets="column.spacer.3" /></xsl:element>
<!-- column 2 -->
		<xsl:element name="td" use-attribute-sets="column.2">
			<xsl:attribute name="id">myspace-s-c</xsl:attribute>
			<!-- tips heading -->
			<div class="myspace-r-a">
				<xsl:copy-of select="$myspace.tips.black" />&nbsp;
				<xsl:element name="{$text.subheading}" use-attribute-sets="text.subheading">
					<strong class="white">hints &amp; tips</strong>
				</xsl:element>
			</div>
			<xsl:copy-of select="$tips_memberreview" />
		<xsl:element name="img" use-attribute-sets="column.spacer.2" />
		</xsl:element>
		</tr>
	</table>
	</xsl:template>
	
</xsl:stylesheet>
