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

	<!-- <b>Title:</b> <xsl:apply-templates select="." mode="t_articletitle"/>
	<br /><br /> -->
	
	<xsl:if test="$article_subtype='dump'">
		<div class="options2">
				<div class="floatleft">
					<h3><label for="option1">Set Article Type:</label></h3>
				</div>
				<div class="floatleft">
					<p class="paddingleft10px">
					<xsl:apply-templates select="." mode="r_articletype">
						<xsl:with-param name="group" select="$article_type_group" />
						<xsl:with-param name="user" select="$article_type_user" />
					</xsl:apply-templates>
					</p>
				</div>
				<div class="clear"></div>
				
				<div class="unsuccesful_listitems">
				<div class="vspace2px"></div>
				<b>Title:</b> <xsl:apply-templates select="." mode="t_articletitle"/>
				</div>
			</div>
		</xsl:if>

		<xsl:if test="$article_subtype='person' or $article_subtype='theme' or $article_subtype='feature' or $article_subtype='interview'">
			<div class="unsuccesful_listitems">
			<div class="vspace2px"></div>
			<input type="text" name="type" value="{$current_article_type}"/>
			</div>
		</xsl:if>

	<b>Body</b><br />You may enter HTML here<br /> <xsl:apply-templates select="." mode="t_articlebody"/>

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




<xsl:template name="EDITOR_THEMES_GENERIC">
 <xsl:if test="$test_IsEditor">
	<!-- DEBUG -->
	<xsl:call-template name="TRACE">
	<xsl:with-param name="message">EDITOR_THEMES_GENERIC</xsl:with-param>
	<xsl:with-param name="pagename">formeditcategory.xsl</xsl:with-param>
	</xsl:call-template>
	<!-- DEBUG -->

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
		<input type="hidden" name="s_details" value="no" />
	
    <!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
				MEMBER PAGE FORM
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	
	
	<input type="hidden" name="_msxml" value="{$articlefields}"/>



			<div class="unsuccesful_listitems"> 
				<h2>Page Type Title:</h2>
				<p>EG: Themes or Peoples etc </p>
				<p><input type="text" name="PAGE_TYPE_TITLE" id="none" value="{MULTI-ELEMENT[@NAME='PAGE_TYPE_TITLE']/VALUE-EDITABLE}"/></p>
			</div>

	<!-- TITLE -->
			<div class="unsuccesful_listitems"> 
				
				<!-- <xsl:choose>
					<xsl:when test="not($article_subtype='person' or $article_subtype='theme' or $article_subtype='feature')">
					<h2 class="firstnoerror"><label for="title" title="Title"><img src="{$imageRoot}images/title_title.gif" border="0" width="35" height="16" alt="Title" /></label></h2>
					</xsl:when>
					<xsl:otherwise> --><h2>Title:</h2><!-- </xsl:otherwise> -->
				<!-- </xsl:choose> -->
			
				<div class="vspace2px"></div>

			<!-- 	<xsl:choose>
					<xsl:when test="not($article_subtype='person' or $article_subtype='theme' or $article_subtype='feature')">
						<p><textarea cols="45" rows="3" name="title" id="title"><xsl:value-of select="MULTI-REQUIRED[@NAME='TITLE']/VALUE-EDITABLE"/></textarea></p>
					</xsl:when>
					<xsl:otherwise> -->
					
						<p><xsl:apply-templates select="." mode="t_articletitle"/></p>
					<!-- </xsl:otherwise>
				</xsl:choose> -->

			</div>

<!-- 	<xsl:if test="$article_subtype='person' or $article_subtype='theme' or $article_subtype='feature'"> -->
		<div class="unsuccesful_listitems">
		<div class="vspace2px"></div>
		<p>Article type</p>
		<p><input type="text" name="type" value="{$current_article_type}"/></p>
		</div>
<!-- 	</xsl:if> -->



				<!-- Image Location -->
				<div class="unsuccesful_listitems"> 
					<h2>Image Location</h2>
					<p>Enter the filename only and upload the image to the 'images' folder </p>
					<p><input type="text" name="image_loc" id="firstpublished" value="{MULTI-ELEMENT[@NAME='IMAGE_LOC']/VALUE-EDITABLE}"/></p>
				</div>	


				<div class="unsuccesful_listitems"> 
					<h2>Image Alt Tag</h2>
					<p>Enter the Alt tag </p>
					<p><input type="text" name="image_alt" id="firstpublished" value="{MULTI-ELEMENT[@NAME='IMAGE_ALT']/VALUE-EDITABLE}"/></p>
				</div>	



				<div class="unsuccesful_listitems"> 
					<h2>Top Links</h2>
					<p>Enter HTML</p>
					<p><textarea name="TOP_LINKS" cols="50" rows="20">
						
						<xsl:value-of select="MULTI-ELEMENT[@NAME='TOP_LINKS']/VALUE-EDITABLE"/>
					
					</textarea></p>
				</div>	
		
	
		
			<div class="unsuccesful_listitems">

				<!-- BODY OF ARTICLE -->
					<h2>Article Body</h2>
					<p>Enter HTML</p>
					<p><xsl:apply-templates select="." mode="t_articlebody"/></p>

			

				


				<!-- @cv@! TAKE ARTICLE LIVE -->
				<div style="padding:5">
				<xsl:choose>
					<xsl:when test="$article_type_group='article'">
					<div class="textmedium">Article Status:
						<select name="status">
							<option value="3"><xsl:if test="@TYPE='TYPED-ARTICLE-CREATE'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>submission</option>		
							<option value="1"><xsl:if test="MULTI-REQUIRED[@NAME='STATUS']/VALUE-EDITABLE = 1"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>approved</option>
							<option value="5"><xsl:if test="MULTI-REQUIRED[@NAME='STATUS']/VALUE-EDITABLE = 5"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>declined</option>
							<option value="9"><xsl:if test="MULTI-REQUIRED[@NAME='STATUS']/VALUE-EDITABLE = 5"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>help</option>
						</select>
					</div>
					</xsl:when>
					<xsl:otherwise>
						<input type="hidden" name="STATUS" value="1" />
						<div class="textmedium">Article Status: 1 </div>
					</xsl:otherwise>
				</xsl:choose>
				</div>



				


				

		



				<!-- RELATED WORKS -->
				<div class="unsuccesful_listitems"> 
					<h2>Related Works</h2>
			
						<p>Enter HTML</p>
					
					<textarea name="RELATED_WORKS" cols="50" rows="20">
						
						<xsl:value-of select="MULTI-ELEMENT[@NAME='RELATED_WORKS']/VALUE-EDITABLE"/>
						
					</textarea>
				</div>


				<!-- DISCUSS -->
				<div class="unsuccesful_listitems"> 
					<h2>Discuss</h2>
					<p>Enter HTML</p>
					<textarea name="DISCUSS" cols="50" rows="20">
						
						<xsl:value-of select="MULTI-ELEMENT[@NAME='DISCUSS']/VALUE-EDITABLE"/>
					
					</textarea>
				</div>






				
				<!-- FEATURE 1 -->
				<div class="unsuccesful_listitems"> 
					<h2>Feature 1: to be displayed in right column</h2>
					<p>Enter HTML</p>
					<textarea name="PROMO1" id="timeandspace" cols="50" rows="20">
						<xsl:choose>
							<!-- pre-populate the form GuideML -->
							<xsl:when test="@TYPE='TYPED-ARTICLE-CREATE'"></xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="MULTI-ELEMENT[@NAME='PROMO1']/VALUE-EDITABLE"/>
							</xsl:otherwise>
						</xsl:choose>
					</textarea>
				</div>


			<!-- <xsl:if test="$article_subtype='person' or $article_subtype='theme' or $article_subtype='feature'"> -->

				<!-- ARTICLE ASSOCIATIONS  v6 commented out because we should be able to use the existing RELATED_WORKS field
				<div class="unsuccesful_listitems"> 
					<h2>Article Associations</h2>
					<p>Enter the article name, year of publication, article ID, country abbreviation and category (TV, Film, Radio, etc)</p>
					<textarea name="ASSOCIATED_WORKS" cols="50" rows="3">
						<xsl:choose>
						<xsl:when test="@TYPE='TYPED-ARTICLE-CREATE'">&lt;LINK YEAR="" CATEGORY="" COUNTRY="" AID=""&gt;article title&lt;/LINK&gt;</xsl:when>
						<xsl:otherwise>
						<xsl:value-of select="MULTI-ELEMENT[@NAME='ASSOCIATED_WORKS']/VALUE-EDITABLE"/>
						</xsl:otherwise>
						</xsl:choose>
					</textarea>
				</div>
				-->

				

				<!-- TOP LINKS -->
				<!-- <div class="unsuccesful_listitems"> 
					<h2>Links</h2>
					<p>Enter HTML</p>
					<textarea name="TOP_LINKS" cols="50" rows="3">
						
						<xsl:value-of select="MULTI-ELEMENT[@NAME='TOP_LINKS']/VALUE-EDITABLE"/>
					
					</textarea>
				</div> -->

				<!-- </xsl:if> -->





	


			
			</div>
			


			<!-- <xsl:apply-templates select="/H2G2/MULTI-STAGE" mode="c_articlestatus"/> -->


	<!-- PREVIEW -->
	<xsl:if test="$test_IsEditor">
		<xsl:apply-templates select="." mode="t_articlepreviewbutton"/>
	</xsl:if>
	<!-- CREATE/PUBLISH/EDIT -->
		<a name="publish" id="publish"></a>
		<xsl:apply-templates select="." mode="c_articleeditbutton"/> 
	    <xsl:apply-templates select="." mode="c_articlecreatebutton"/>
		<!-- <xsl:apply-templates select="." mode="c_deletearticle"/> -->

	</div>
</xsl:if>
		
	</xsl:template>
</xsl:stylesheet>