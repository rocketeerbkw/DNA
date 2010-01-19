<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">

   <xsl:import href="../../../base/base-typedarticle.xsl"/>
   
   	<xsl:import href="formeditorpage.xsl"/>
	<xsl:import href="formeditorreview.xsl"/>
	<xsl:import href="formmemberpage.xsl"/>
	<xsl:import href="formfrontpage.xsl"/>
  	<xsl:import href="formeditcategory.xsl"/> 
	<xsl:import href="formarchive.xsl"/> 
		
  <xsl:variable name="frontpagearticlefields">
	<![CDATA[<MULTI-INPUT>
						<REQUIRED NAME='TYPE'></REQUIRED>
						<REQUIRED NAME='BODY'></REQUIRED>
						<REQUIRED NAME='TITLE'></REQUIRED>
						<REQUIRED NAME='STATUS'></REQUIRED>
						<REQUIRED NAME='HIDEARTICLE'></REQUIRED>
						<ELEMENT NAME='DESCRIPTION'></ELEMENT>
						<ELEMENT NAME='KEYWORDS'></ELEMENT>
					</MULTI-INPUT>]]>
	</xsl:variable>
	

	<!-- @CV@ -->
	<xsl:variable name="articlefields">
	<![CDATA[<MULTI-INPUT>
						<REQUIRED NAME='TYPE'></REQUIRED>
						<REQUIRED NAME='BODY'></REQUIRED>
						<REQUIRED NAME='TITLE' ESCAPED=1 EI='add'></REQUIRED>
						<REQUIRED NAME='STATUS'></REQUIRED>
						<REQUIRED NAME='HIDEARTICLE'></REQUIRED>
						<ELEMENT NAME='DESCRIPTION'></ELEMENT>
						<ELEMENT NAME='KEYWORDS'></ELEMENT>
						<ELEMENT NAME='PRODUCTION_YEAR' EI='add'></ELEMENT>
						<ELEMENT NAME='CREATOR' EI='add'></ELEMENT>
						<ELEMENT NAME='COUNTRY' EI='add'></ELEMENT>
						<ELEMENT NAME='WHY_INCLUDE'></ELEMENT>
						<ELEMENT NAME='MOVIE_LOC'></ELEMENT>
						<ELEMENT NAME='PAGE_TYPE_TITLE'></ELEMENT>
						<ELEMENT NAME='IMAGE_LOC'></ELEMENT>
						<ELEMENT NAME='IMAGE_ALT'></ELEMENT>
						<ELEMENT NAME='INDEPTH'></ELEMENT>
						<ELEMENT NAME='THEMELINK'></ELEMENT>
						<ELEMENT NAME='PROMO1'></ELEMENT>
						<ELEMENT NAME='ENCAP'></ELEMENT>
						<ELEMENT NAME='INSPIRE_YOU'></ELEMENT>
						<ELEMENT NAME='SUM_UP'></ELEMENT>
						<ELEMENT NAME='ALSO_BBC'></ELEMENT>
						<ELEMENT NAME='ALSO_WEB'></ELEMENT>
						<ELEMENT NAME='READ_LINKS'></ELEMENT>
						<ELEMENT NAME='WATCH_LISTEN'></ELEMENT>
						<ELEMENT NAME='TIME_SPACE'></ELEMENT>
						<ELEMENT NAME='RELATED_WORKS'></ELEMENT>
						<ELEMENT NAME='ASSOCIATED_WORKS'></ELEMENT>
						<ELEMENT NAME='SAYING_WHAT'></ELEMENT>
						<ELEMENT NAME='DISCUSS'></ELEMENT>
						<ELEMENT NAME='TOP_LINKS'></ELEMENT>
				</MULTI-INPUT>]]>
	</xsl:variable>
	

	
	

	<!-- @cv@ move necessary fields to the '$articlefields' and get rid of this variable all together -->
	<xsl:variable name="editorfields">
	<![CDATA[<MULTI-INPUT>
						<REQUIRED NAME='TYPE'></REQUIRED>
						<REQUIRED NAME='BODY'></REQUIRED>
						<REQUIRED NAME='TITLE' ESCAPED=1 ></REQUIRED>
						<REQUIRED NAME='STATUS'></REQUIRED>
						<ELEMENT NAME='MAINTITLE' ESCAPED=1 ></ELEMENT>
						<ELEMENT NAME='SUBTITLE' ESCAPED=1 ></ELEMENT>
						<ELEMENT NAME='USEFULLINKS'></ELEMENT>
						<ELEMENT NAME='USEFULLINK'></ELEMENT>
						<ELEMENT NAME='LINKTITLE'></ELEMENT>
						<ELEMENT NAME='AUTHOR'></ELEMENT>
						<ELEMENT NAME='EDITORNAME'></ELEMENT>
						<ELEMENT NAME='EDITORDNAID'></ELEMENT>
						<ELEMENT NAME='MOVIE_LOC'></ELEMENT>
						<ELEMENT NAME='PICTURENAME'></ELEMENT>
						<ELEMENT NAME='PICTUREWIDTH'></ELEMENT>
						<ELEMENT NAME='PICTUREHEIGHT'></ELEMENT>
						<ELEMENT NAME='PICTUREALT'></ELEMENT>
						<ELEMENT NAME='LABEL'></ELEMENT>
						<ELEMENT NAME='PICTUREALT'></ELEMENT>
						<ELEMENT NAME='PUBLISHDATE'></ELEMENT>
						<ELEMENT NAME='SNIPPETS'></ELEMENT>	
						<ELEMENT NAME='TAGLINE'></ELEMENT>	
						<ELEMENT NAME='RATING'></ELEMENT>
						<ELEMENT NAME='BOLDINFO'></ELEMENT>
						<ELEMENT NAME='RATING'></ELEMENT>
						<ELEMENT NAME='BOTTOMTEXT'></ELEMENT>
						<ELEMENT NAME='LIKETHIS'></ELEMENT>
						<ELEMENT NAME='TRYTHIS'></ELEMENT>
						<ELEMENT NAME='WHATDOYOUTHINK'></ELEMENT>
						<ELEMENT NAME='SEEALSO'></ELEMENT>
						<ELEMENT NAME='RELATEDREVIEWS'></ELEMENT>
						<ELEMENT NAME='RELATEDCONVERSATIONS'></ELEMENT>
						<ELEMENT NAME='ALSOONBBC'></ELEMENT>
						<REQUIRED NAME='HIDEARTICLE'></REQUIRED>
						<ELEMENT NAME='DESCRIPTION'></ELEMENT>		
						<ELEMENT NAME='KEYWORDS'></ELEMENT>			
						<ELEMENT NAME='ARTICLEFORUMSTYLE'></ELEMENT>
						<ELEMENT NAME='IMAGE_LOC'></ELEMENT>
						<ELEMENT NAME='INDEPTH'></ELEMENT>
						<ELEMENT NAME='THEMELINK'></ELEMENT>
						</MULTI-INPUT>]]>
	</xsl:variable>

	<!-- NOTES - CONTACT are editorial only -->
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
						Page - Level  template
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	
	
<xsl:template name="TYPED-ARTICLE_MAINBODY">

	<xsl:apply-templates select="/H2G2/DELETED" mode="c_article"/>

	<!-- DEBUG -->
	<xsl:call-template name="TRACE">
	<xsl:with-param name="message">TYPED-ARTICLE_MAINBODY test variable = <xsl:value-of select="$current_article_type" /></xsl:with-param>
	<xsl:with-param name="pagename">typedarticlepage.xsl</xsl:with-param>
	</xsl:call-template>
	<!-- DEBUG -->
	
	<!-- @CV@ add links to point to creating different types of articles -->
	<xsl:if test="$test_IsEditor">
		<div class="userprofile_listitems">
			<div><a href="{$root}{$create_person_article}">Create Person Entry</a></div>
			<div><a href="{$root}{$create_member_article}">Create Entry</a></div>
			<div><a href="{$root}{$create_frontpage_article}">Create FrontPage</a></div>
			<div><a href="{$root}{$create_theme_generic}">Create Theme Generic</a></div>
			<div class="vspace24px"></div>
			<form method="post" action="siteconfig" xsl:use-attribute-sets="fSITECONFIG-EDIT_c_siteconfig">
				<input type="hidden" name="_msxml" value="{$configfields}"/>
				<input  type="submit" value="edit siteconfig" />
			</form>
			<br />
		</div>
		
	
	<!-- SC --><!-- ADDED IF: only editors will see submission form -->
	<xsl:apply-templates select="MULTI-STAGE" mode="c_article"/>
	</xsl:if>

	<xsl:if test="not($test_IsEditor)">
		<h1 class="longtitle">My Science Fiction Life is now closed to new contributions.</h1>
		<div class="vspace14px"></div>
		<p>
		This site closed to new contributions in April 2007. You can still browse all of the content and recollections here on the site as an archive for the foreseeable future.</p>
	</xsl:if>

	


</xsl:template>
	




<!--============================ TYPED ARTICLES ======================= -->	 
<xsl:template match="MULTI-STAGE" mode="r_article">
<!--input type="hidden" name="skin" value="purexml"/--> 



	<!-- heading -->
	<div id="textintro">

		<div class="paddingleft10px">
			
				<xsl:choose>
					<xsl:when test="$current_article_type = 19">
						<h1 class="longtitle">Create the people index page</h1>
						<div class="vspace14px"></div>
					</xsl:when>
					<xsl:when test="$current_article_type = 26">
						<h1 class="longtitle">Create the theme index page</h1>
						<div class="vspace14px"></div>
					</xsl:when>
					<xsl:when test="$current_article_type = 36">
						<h1 class="longtitle">Create a person article page</h1>
						<div class="vspace14px"></div>
					</xsl:when>
					<xsl:when test="$current_article_type = 37">
						<h1 class="longtitle">Create a theme article page</h1>
						<div class="vspace14px"></div>
					</xsl:when>
					<xsl:when test="$current_article_type = 4">
						<h1 class="longtitle">Create a feature page</h1>
						<div class="vspace14px"></div>
					</xsl:when>
					<xsl:when test="$current_article_type = 5">
						<h1 class="longtitle">Create an interview page</h1>
						<div class="vspace14px"></div>
					</xsl:when>
					<xsl:otherwise>
						<xsl:if test="not($test_IsEditor)">
							<h1 class="longtitle">What do you think should be added to the Science Fiction timeline?</h1>
							<div class="vspace14px"></div>
							<p >First tell us about the work you'd like to nominate, then we'll also ask for your Recollections about it.</p>
							<p >Once you've done that, we'll check some of the details about the work before making it visible to everyone on the site.</p>
							<p >However, you will be able to see your Recollection immediately on your Profile page.</p>
						</xsl:if>
					</xsl:otherwise>
				</xsl:choose>
			

			<div class="vspace24px"></div>
		</div>
	</div>

	

	<xsl:if test="/H2G2/MULTI-STAGE[@TYPE='TYPED-ARTICLE-EDIT-PREVIEW' or @TYPE='TYPED-ARTICLE-PREVIEW']">
		<!-- removed preview publish TW -->
			<!-- <a href="#publish"><xsl:element name="img" use-attribute-sets="anchor.publish" /></a><br />
			<a href="#edit"><xsl:element name="img" use-attribute-sets="anchor.edit" /></a>		 -->
	
	</xsl:if>	


	<xsl:apply-templates select="/H2G2/MULTI-STAGE/MULTI-REQUIRED/ERRORS/ERROR | /H2G2/MULTI-STAGE/MULTI-ELEMENT/ERRORS/ERROR" mode="c_typedarticle"/>

		
	<!-- THIS CALLS THE PREVIEW -->
	<xsl:if test="$test_IsEditor">
		<xsl:apply-templates select="." mode="c_preview"/>
	</xsl:if>

	<xsl:choose>

		<!--
		<xsl:when test="$test_IsEditor">
			<xsl:call-template name="EDITOR_REVIEW" />
		</xsl:when>
		<xsl:when test="/H2G2/ARTICLE/ARTICLEINFO/STATUS/@TYPE=9 and $test_IsEditor or contains($article_type_name,'editor_article')">
			<xsl:call-template name="EDITOR_PAGE" />
		</xsl:when>
		-->
		<xsl:when test="$article_type_group='frontpage'">
			<xsl:call-template name="EDITOR_FRONTPAGE" />
		</xsl:when>	

		<xsl:when test="$article_type_group='category'">		
			<xsl:call-template name="EDITOR_CATEGORY" />
		</xsl:when>

		<xsl:when test="$article_subtype='dump'">		
			<xsl:call-template name="EDITOR_CATEGORY" />
		</xsl:when>

		<xsl:when test="$current_article_type = 19">		
			<xsl:call-template name="EDITOR_CATEGORY" />
		</xsl:when>

		<xsl:when test="$current_article_type = 4">		
			<xsl:call-template name="EDITOR_CATEGORY" />
		</xsl:when>

		<xsl:when test="$current_article_type = 5">		
			<xsl:call-template name="EDITOR_CATEGORY" />
		</xsl:when>

		<xsl:when test="$current_article_type = 26">		
			<xsl:call-template name="EDITOR_CATEGORY" />
		</xsl:when>

		<xsl:when test="$current_article_type = 38">		
			<xsl:call-template name="EDITOR_THEMES_GENERIC" />
		</xsl:when>

		<xsl:otherwise>	
			<xsl:call-template name="MEMBER_PAGE" />
		</xsl:otherwise>

	</xsl:choose>
</xsl:template>
	

	

<!-- ARTICLE TYPE DROPDOWN -->
<xsl:template match="MULTI-STAGE" mode="r_articletype">

	<xsl:param name="group" />
	<xsl:param name="user" />
	
	<select name="type">
		<xsl:choose>
			<xsl:when test="$current_article_type=1 and /H2G2/ARTICLE/ARTICLEINFO/STATUS/@TYPE=3">
					<xsl:apply-templates select="msxsl:node-set($type)/type[@group='article' and @user='member']" mode="t_articletype"/>
			</xsl:when>
				<xsl:when test="$current_article_type=1 and /H2G2/ARTICLE/ARTICLEINFO/STATUS/@TYPE=1">
					<xsl:apply-templates select="msxsl:node-set($type)/type[@group='article' and @user='member']" mode="t_articletype"/>
			</xsl:when>
			<xsl:when test="$current_article_type=3  or /H2G2/ARTICLE/ARTICLEINFO/STATUS/@TYPE=9">
				<xsl:apply-templates select="msxsl:node-set($type)/type[@group='article' and @user='editor']" mode="t_articletype"/>
			</xsl:when>
			
			<xsl:otherwise>
				<xsl:apply-templates select="msxsl:node-set($type)/type[@group='article' and @user='member']" mode="t_articletype"/>
			</xsl:otherwise>
		</xsl:choose>
		
		<!-- 	<xsl:if test="$test_IsEditor">		
				<option>change type</option>
				<option value="55">editor feature</option>
				<option value="70">editor interview</option>
				<option value="85">editor column</option>
				<option value="3">editor article</option>
				<option value="4">frontpage</option>
				</xsl:if> 
		-->
	</select>
</xsl:template>


<!-- When editing an article, it makes sure the current type will be 'selected' in the drop down -->
<xsl:template match="type" mode="t_articletype">

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




	<!--
	<xsl:template match="MULTI-STAGE" mode="t_articlebody">
	Author:		Tom Whitehouse
	Context:      /H2G2
	Purpose:	
	-->
	<xsl:template match="MULTI-STAGE" mode="t_articlebody">

		<textarea name="body" xsl:use-attribute-sets="mMULTI-STAGE_t_articlebody">
			<xsl:value-of select="MULTI-REQUIRED[@NAME='BODY']/VALUE-EDITABLE"/>
		</textarea>			  
			  
	</xsl:template>

<!-- PREVIEW AREA -->
<!--
	<xsl:template match="MULTI-STAGE" mode="r_preview">
	Use: Presentation of the preview area
	 -->
<xsl:template match="MULTI-STAGE" mode="r_preview">
	<xsl:choose>
	<!-- FOR ALL FRONTPAGES -->
	<xsl:when test="$article_type_group='frontpage' or $current_article_type=100 or $current_article_type=101"><xsl:apply-templates select="/H2G2/ARTICLE/GUIDE/BODY/MAIN-SECTIONS/EDITORIAL/ROW"/></xsl:when>
	<xsl:when test="$current_article_type=38">
				<xsl:call-template name="THEMES_GENERIC" />
			</xsl:when>
	<xsl:otherwise>
	

	<table border="0" cellspacing="0" cellpadding="0">
	<tr>
	<xsl:element name="td" use-attribute-sets="column.1">
	<!-- this takes you to the article template in article.xsl -->
	<xsl:apply-templates select="/H2G2/ARTICLE" mode="c_articlepage"/>
	<xsl:element name="img" use-attribute-sets="column.spacer.1" />
	</xsl:element>
	<xsl:element name="td" use-attribute-sets="column.3"><xsl:element name="img" use-attribute-sets="column.spacer.3" /></xsl:element>
	<xsl:element name="td" use-attribute-sets="column.2">
	
	<xsl:choose>
	<!-- FOR ALL MEMBER ARTICLES -->
	<xsl:when test="$article_type_user='member' and $article_type_group='review'">
	<xsl:if test="/H2G2/ARTICLE/GUIDE[descendant::USEFULLINKS!='']">
	<div class="generic-l">
	<div class="generic-e-DA8A42"><strong><xsl:element name="{$text.subheading}" use-attribute-sets="text.subheading">related info</xsl:element></strong>
	</div>
	

		<div class="generic-v">
		<div class="like-this"><img src="{$imagesource}icons/useful_links.gif" height="20" width="20" border="0" alt="" />&nbsp;<xsl:element name="{$text.base}" use-attribute-sets="text.base"><strong>useful links</strong></xsl:element></div>
	
			<xsl:variable name="usefullink" select="/H2G2/ARTICLE/GUIDE/USEFULLINKS" />
				<xsl:variable name="usefullinkchecked">
					<xsl:choose>
					<xsl:when test="starts-with($usefullink,'http://') or starts-with($usefullink,'#') or starts-with($usefullink,'mailto:') or (starts-with($usefullink,'/') and contains(substring-after($usefullink,'/'),'/'))">
					<xsl:value-of select="$usefullink"/>
					</xsl:when>
					<xsl:when test="starts-with($usefullink,'/') and string-length($usefullink) &gt; 1"><xsl:value-of select="concat('http:/', $usefullink)"/></xsl:when>
					<xsl:when test="starts-with($usefullink,'www') and string-length($usefullink) &gt; 1"><xsl:value-of select="concat('http://', $usefullink)"/></xsl:when>
					</xsl:choose>
				</xsl:variable>
				
				<xsl:choose>
					<xsl:when test="$article_type_user='member'">
					<xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall">
					<a href="{$usefullinkchecked}" id="related" xsl:use-attribute-sets="mLINK">
					<xsl:apply-templates select="/H2G2/ARTICLE/GUIDE/LINKTITLE"/></a>
					</xsl:element>
					</xsl:when>
					<xsl:otherwise><xsl:apply-templates select="/H2G2/ARTICLE/GUIDE/USEFULLINKS"/></xsl:otherwise>
				</xsl:choose>
			</div>
				
			<div class="generic-k">
			<xsl:element name="{$text.small}" use-attribute-sets="text.small">
			<xsl:value-of select="$coll_usefullinkdisclaimer" />
			</xsl:element>
			</div>
		
		</div>
		
	</xsl:if>	
	</xsl:when>
	<!-- FOR ALL EDITOR ARTICLES -->
	<xsl:otherwise>
	<xsl:apply-templates select="/H2G2/ARTICLE/ARTICLEINFO" mode="c_articlepage"/>	
	</xsl:otherwise>
	</xsl:choose>

	<xsl:element name="img" use-attribute-sets="column.spacer.2" />
	</xsl:element>
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
	<xsl:when test="$test_IsEditor">
	
	<div class="generic-error">
	<div class="generic-errortext">error</div>
	<xsl:element name="{$text.base}" use-attribute-sets="text.base">
	<xsl:apply-templates select="*|@*|text()"/>
	</xsl:element>
	</div>
	
	</xsl:when>
	<xsl:otherwise>
	<div class="generic-error">
	<div class="generic-errortext">error</div>
	<xsl:element name="{$text.base}" use-attribute-sets="text.base"><strong>
		There is a problem with your page. You may have used an "&lt;" symbol which unfortunately doesn't work on My Science Fiction Life.  Please remove it and click preview again.
	</strong></xsl:element>
	</div>
	</xsl:otherwise>
	</xsl:choose>
	</xsl:template>

     <!--
      <xsl:template match="MULTI-STAGE" mode="r_hidearticle">
      Use: Presentation of the hide article functionality
       -->

      <xsl:template match="MULTI-STAGE" mode="r_hidearticle">
		<xsl:element name="{$text.base}" use-attribute-sets="text.base">
		<label class="form-label">hide <xsl:value-of select="$article_type_group" />:</label>
		<xsl:apply-templates select="." mode="t_hidearticle"/>
		</xsl:element>
	 </xsl:template>


	<!--
	<xsl:template match="DELETED" mode="r_deleted">
	Use: Template invoked after deleting an article
	 -->
	<xsl:template match="DELETED" mode="r_article">
		<div class="errorpage">
			<xsl:element name="{$text.base}" use-attribute-sets="text.base"><strong>This article has been deleted.</strong><br/><br/>
			<!--  If you want to restore any deleted articles you can view them <xsl:apply-imports/> --></xsl:element>
		</div>
	</xsl:template>

	<xsl:template match="MULTI-STAGE" mode="r_articlestatus">
	<xsl:element name="{$text.base}" use-attribute-sets="text.base">
	<label class="form-label"><xsl:value-of select="$article_type_group" /> status:</label><xsl:text> </xsl:text>
	</xsl:element>
			<!-- template -->
			<!-- have to overwrite base template as sci fi editors want their forms to default to status =1 -->
			<xsl:choose>
			<xsl:when test="@TYPE='TYPED-ARTICLE-EDIT' or @TYPE='TYPED-ARTICLE-EDIT-PREVIEW' or @TYPE='TYPED-ARTICLE-PREVIEW'">
				<input type="text" name="status" value="{MULTI-REQUIRED[@NAME='STATUS']/VALUE-EDITABLE}" xsl:use-attribute-sets="iMULTI-STAGE_r_articlestatus"/>
			</xsl:when>
			<xsl:when test="$article_type_user='editor' and @TYPE='TYPED-ARTICLE-CREATE'">
				<input type="text" name="status" value="1" xsl:use-attribute-sets="iMULTI-STAGE_r_articlestatus"/>
			</xsl:when>
			<xsl:otherwise>
			<input type="text" name="status" value="{MULTI-REQUIRED[@NAME='STATUS']/VALUE-EDITABLE}" xsl:use-attribute-sets="iMULTI-STAGE_r_articlestatus"/>
			</xsl:otherwise>
		</xsl:choose>

	</xsl:template>

	<xsl:attribute-set name="fMULTI-STAGE_c_article">
		<xsl:attribute name="name">typedarticle</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="iMULTI-STAGE_t_articletitle">
		<xsl:attribute name="maxlength">
			<xsl:choose>
			<xsl:when test="$test_IsEditor">200</xsl:when>
			<xsl:otherwise>36</xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>
		<xsl:attribute name="size">10</xsl:attribute>
		<xsl:attribute name="id">write-review-form-2</xsl:attribute>
		<xsl:attribute name="class">write-review-step-2</xsl:attribute>
		
   </xsl:attribute-set>
	
	<xsl:attribute-set name="mMULTI-STAGE_t_articlebody">
		<xsl:attribute name="id">
			<xsl:choose>
			<xsl:when test="$article_type_group='frontpage' or $current_article_type=4001 or $article_type_group='archive'"></xsl:when>
			<xsl:otherwise>write-review-form-5</xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>
		<xsl:attribute name="class">
			<xsl:choose>
			<xsl:when test="$article_type_group='frontpage' or $current_article_type=4001 or $article_type_group='archive'"></xsl:when>
			<xsl:when test="$article_type_user='member' and $article_type_group='review' or /H2G2/ARTICLE/ARTICLEINFO/STATUS/@TYPE=3 and $current_article_type=1">members</xsl:when>
			<xsl:otherwise>write-review-step-5</xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>
		<xsl:attribute name="cols">
			<xsl:choose>
			<xsl:when test="$article_type_group='category'">95</xsl:when>
			<xsl:otherwise>30</xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>
		<xsl:attribute name="rows">
			<xsl:choose>
			<xsl:when test="$article_type_group='category'">30</xsl:when>
			<xsl:when test="$current_article_type=38">20</xsl:when>
			<xsl:otherwise>12</xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>
	</xsl:attribute-set>

	<!-- lots of duplication here ? a lot the var names seem redundant in the base xsl -->
	<xsl:attribute-set name="mMULTI-STAGE_t_articlepreviewbutton" use-attribute-sets="form.preview" />
	<xsl:attribute-set name="mMULTI-STAGE_t_articlepreview" use-attribute-sets="form.preview" />
	<xsl:attribute-set name="mMULTI-STAGE_t_articlecreate" use-attribute-sets="form.publish" />
	<xsl:attribute-set name="mMULTI-STAGE_t_articlecreatebutton" use-attribute-sets="form.publish" />
	<xsl:attribute-set name="mMULTI-STAGE_r_articlecreatebutton" use-attribute-sets="form.publish" />
	<xsl:attribute-set name="mMULTI-STAGE_r_articleeditbutton" use-attribute-sets="form.publish" />


	<xsl:attribute-set name="iMULTI-STAGE_r_articlestatus">
			<xsl:attribute name="size">5</xsl:attribute>
	</xsl:attribute-set>
	
	  <!--
     <xsl:attribute-set name="mMULTI-STAGE_t_hidearticle"/>
     Use: Presentation attributes for the Hide article input box
      -->
     <xsl:attribute-set name="mMULTI-STAGE_t_hidearticle"/>

		
</xsl:stylesheet>

