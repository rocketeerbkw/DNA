<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet exclude-result-prefixes="msxsl local s dt" version="1.0" xmlns:dt="urn:schemas-microsoft-com:datatypes" xmlns:local="#local-functions" xmlns:msxsl="urn:schemas-microsoft-com:xslt"
        xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
        <xsl:import href="../../../base/base-typedarticle.xsl"/>
        <xsl:import href="formeditorpage.xsl"/>
        <xsl:import href="formeditorreview.xsl"/>
        <xsl:import href="formmemberreview.xsl"/>
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
        <xsl:variable name="articlefields">
                <![CDATA[<MULTI-INPUT>
	<REQUIRED NAME='TYPE'></REQUIRED>
	<REQUIRED NAME='BODY'></REQUIRED>
	<REQUIRED NAME='TITLE' ESCAPED=1 ></REQUIRED>
	<ELEMENT NAME='HEADLINE' ESCAPED=1 ></ELEMENT>
	<REQUIRED NAME='STATUS'></REQUIRED>
	<ELEMENT NAME='USEFULLINKS'></ELEMENT>
	<ELEMENT NAME='LINKTITLE'></ELEMENT>
	<REQUIRED NAME='HIDEARTICLE'></REQUIRED>
                              <ELEMENT NAME='DESCRIPTION'></ELEMENT>
	<ELEMENT NAME='KEYWORDS'></ELEMENT>
	</MULTI-INPUT>]]>
        </xsl:variable>
        <xsl:variable name="memberreviewfields">
                <![CDATA[<MULTI-INPUT>
	<REQUIRED NAME='TYPE'></REQUIRED>
	<REQUIRED NAME='BODY'></REQUIRED>
	<REQUIRED NAME='TITLE' ESCAPED=1 ></REQUIRED>
	<ELEMENT NAME='HEADLINE' ESCAPED=1 ></ELEMENT>
	<REQUIRED NAME='STATUS'></REQUIRED>
	<ELEMENT NAME='RATING'></ELEMENT>
	<ELEMENT NAME='USEFULLINKS'></ELEMENT>
	<ELEMENT NAME='LINKTITLE'></ELEMENT>
	<REQUIRED NAME='HIDEARTICLE'></REQUIRED>
	<ELEMENT NAME='DESCRIPTION'></ELEMENT>
	<ELEMENT NAME='KEYWORDS'></ELEMENT>
	</MULTI-INPUT>]]>
        </xsl:variable>
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
	<ELEMENT NAME='TAGLINE'></ELEMENT>
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
                <xsl:apply-templates mode="c_article" select="/H2G2/DELETED"/>
                <!-- DEBUG -->
                <xsl:call-template name="TRACE">
                        <xsl:with-param name="message">TYPED-ARTICLE_MAINBODY test variable = <xsl:value-of select="$current_article_type"/></xsl:with-param>
                        <xsl:with-param name="pagename">typedarticlepage.xsl</xsl:with-param>
                </xsl:call-template>
                <!-- DEBUG -->
                <xsl:if test="$test_IsEditor">
                        <!-- ARTICLE TYPE DROPDOWN  -->
                        <table border="0" cellpadding="2" cellspacing="2" class="generic-n" width="100%">
                                <tr>
                                        <td class="generic-n-3" valign="top">
                                                <xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall">
                                                        <div class="guideml-c">
                                                                <img alt="" border="0" height="20" src="{$imagesource}icons/beige/icon_edit.gif" width="20"/>
                                                                <xsl:text>  </xsl:text>
                                                                <a href="{$root}{$create_old_article}">Create an old article</a>
                                                        </div>
                                                        <div class="guideml-c">
                                                                <img alt="" border="0" height="20" src="{$imagesource}icons/beige/icon_edit.gif" width="20"/>
                                                                <xsl:text>  </xsl:text>
                                                                <a href="{$root}{$create_member_article}">Create a member article</a>
                                                        </div>
                                                        <div class="guideml-c">
                                                                <img alt="" border="0" height="20" src="{$imagesource}icons/beige/icon_edit.gif" width="20"/>
                                                                <xsl:text>  </xsl:text>
                                                                <a href="{$root}{$create_member_review}">Create a member review</a>
                                                        </div>
                                                        <div class="guideml-c">
                                                                <img alt="" border="0" height="20" src="{$imagesource}icons/beige/icon_edit.gif" width="20"/>
                                                                <xsl:text>  </xsl:text>
                                                                <a href="{$root}{$create_member_feature}">Create a member feature</a>
                                                        </div>
                                                        <div class="guideml-c">
                                                                <img alt="" border="0" height="20" src="{$imagesource}icons/beige/icon_edit.gif" width="20"/>
                                                                <xsl:text>  </xsl:text>
                                                                <a href="{$root}TypedArticle?acreate=new&amp;type=101">Create all back issues</a>
                                                        </div>
                                                </xsl:element>
                                        </td>
                                        <td>&nbsp;</td>
                                        <td class="generic-n-3" valign="top">
                                                <xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall">
                                                        <div class="guideml-c">
                                                                <img alt="" border="0" height="20" src="{$imagesource}icons/beige/icon_edit.gif" width="20"/>
                                                                <xsl:text>  </xsl:text>
                                                                <a href="{$root}{$create_frontpage_article}">Create a front page article</a>
                                                        </div>
                                                        <div class="guideml-c">
                                                                <img alt="" border="0" height="20" src="{$imagesource}icons/beige/icon_edit.gif" width="20"/>
                                                                <xsl:text>  </xsl:text>
                                                                <a href="{$root}{$create_editor_article}">Create a editor article</a>
                                                        </div>
                                                        <div class="guideml-c">
                                                                <img alt="" border="0" height="20" src="{$imagesource}icons/beige/icon_edit.gif" width="20"/>
                                                                <xsl:text>  </xsl:text>
                                                                <a href="{$root}{$create_editor_review}">Create an editor review</a>
                                                        </div>
                                                        <div class="guideml-c">
                                                                <img alt="" border="0" height="20" src="{$imagesource}icons/beige/icon_edit.gif" width="20"/>
                                                                <xsl:text>  </xsl:text>
                                                                <a href="{$root}TypedArticle?acreate=new&amp;type=41">Create an editor album review</a>
                                                        </div>
                                                </xsl:element>
                                        </td>
                                        <td>&nbsp;</td>
                                        <td class="generic-n-3" valign="top">
                                                <xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall">
                                                        <div class="guideml-c">
                                                                <img alt="" border="0" height="20" src="{$imagesource}icons/beige/icon_edit.gif" width="20"/>
                                                                <xsl:text>  </xsl:text>
                                                                <a href="{$root}{$create_feature}">Create feature</a>
                                                        </div>
                                                        <div class="guideml-c">
                                                                <img alt="" border="0" height="20" src="{$imagesource}icons/beige/icon_edit.gif" width="20"/>
                                                                <xsl:text>  </xsl:text>
                                                                <a href="{$root}{$create_interview}">Create interview</a>
                                                        </div>
                                                        <div class="guideml-c">
                                                                <img alt="" border="0" height="20" src="{$imagesource}icons/beige/icon_edit.gif" width="20"/>
                                                                <xsl:text>  </xsl:text>
                                                                <a href="{$root}{$create_column}">Create column</a>
                                                        </div>
                                                </xsl:element>
                                                <form action="siteconfig" method="post" xsl:use-attribute-sets="fSITECONFIG-EDIT_c_siteconfig">
                                                        <input name="_msxml" type="hidden" value="{$configfields}"/>
                                                        <input type="submit" value="edit siteconfig"/>
                                                </form>
                                        </td>
                                </tr>
                        </table>
                        <br/>
                </xsl:if>
                <xsl:apply-templates mode="c_article" select="MULTI-STAGE"/>
        </xsl:template>
        <!--
<xsl:template match="MULTI-STAGE" mode="create_article">
Use: Presentation of the create / edit article functionality
 -->
        <!--============================ TYPED ARTICLES ======================= -->
        <xsl:template match="MULTI-STAGE" mode="r_article">
                <!--input type="hidden" name="skin" value="purexml"/-->
                <!-- heading -->
                <div class="generic-u">
                        <xsl:choose>
                                <xsl:when test="/H2G2/MULTI-STAGE[@TYPE='TYPED-ARTICLE-EDIT-PREVIEW' or @TYPE='TYPED-ARTICLE-PREVIEW']">
                                        <xsl:call-template name="box.crumb">
                                                <xsl:with-param name="box.crumb.href">#edit</xsl:with-param>
                                                <xsl:with-param name="box.crumb.value">write a <xsl:value-of select="$article_type_group"/></xsl:with-param>
                                                <xsl:with-param name="box.crumb.title">preview</xsl:with-param>
                                        </xsl:call-template>
                                </xsl:when>
                                <xsl:otherwise>
                                        <xsl:element name="{$text.subheading}" use-attribute-sets="text.subheading">
                                                <strong>write a <xsl:value-of select="$article_type_group"/></strong>
                                        </xsl:element>
                                </xsl:otherwise>
                        </xsl:choose>
                </div>
                <!-- steps -->
                <div class="generic-u">
                        <table border="0" cellpadding="0" cellspacing="0">
                                <tr>
                                        <td>
                                                <xsl:choose>
                                                        <xsl:when test="/H2G2/MULTI-STAGE[@TYPE='TYPED-ARTICLE-CREATE']">
                                                                <xsl:element name="{$text.subheading}" use-attribute-sets="text.subheading">
                                                                        <strong>step 1: write your own <xsl:value-of select="$article_type_group"/></strong>
                                                                </xsl:element>
                                                                <br/>
                                                                <xsl:element name="{$text.base}" use-attribute-sets="text.base">
                                                                        <xsl:choose>
                                                                                <xsl:when test="contains($article_type_name,'member_article')">Create a page that falls outside the scope of a review using this form. See hints and tips for examples or write a review instead.</xsl:when>
                                                                                <xsl:when test="contains($article_type_name,'member_review')">Fill out the form below making sure you select a category and rating. Click preview to see what it will look like.</xsl:when>
                                                                                <xsl:otherwise/>
                                                                        </xsl:choose>
                                                                </xsl:element>
                                                        </xsl:when>
                                                        <xsl:when test="/H2G2/MULTI-STAGE[@TYPE='TYPED-ARTICLE-EDIT-PREVIEW' or @TYPE='TYPED-ARTICLE-PREVIEW']">
                                                                <xsl:element name="{$text.subheading}" use-attribute-sets="text.subheading">
                                                                        <strong>step 2: preview your page</strong>
                                                                </xsl:element>
                                                                <br/>
                                                                <xsl:element name="{$text.base}" use-attribute-sets="text.base">
                                                                        <xsl:choose>
                                                                                <xsl:when test="contains($article_type_name,'member_article')">our page will look as it does below. If you are happy click "publish". If not, you can edit your page and preview it again.</xsl:when>
                                                                                <xsl:when test="contains($article_type_name,'member_review')">Your review will look as it does below. If you are happy click "publish". If not, you can edit your review and preview it again.</xsl:when>
                                                                                <xsl:otherwise>You are previewing your <xsl:value-of select="$article_type_group"/></xsl:otherwise>
                                                                        </xsl:choose>
                                                                </xsl:element>
                                                        </xsl:when>
                                                        <xsl:otherwise>
                                                                <xsl:element name="{$text.base}" use-attribute-sets="text.base">
                                                                        <strong class="write-review-step">Step 1: edit your <xsl:value-of select="$article_type_group"/></strong>
                                                                </xsl:element>&nbsp;<xsl:element name="{$text.base}" use-attribute-sets="text.base">You are editing a <xsl:value-of
                                                                                select="$article_type_group"/>.</xsl:element>
                                                        </xsl:otherwise>
                                                </xsl:choose>
                                        </td>
                                        <xsl:if test="/H2G2/MULTI-STAGE[@TYPE='TYPED-ARTICLE-EDIT-PREVIEW' or @TYPE='TYPED-ARTICLE-PREVIEW']">
                                                <td align="right">
                                                        <a href="#publish">
                                                                <xsl:element name="img" use-attribute-sets="anchor.publish"/>
                                                        </a>
                                                        <br/>
                                                        <a href="#edit">
                                                                <xsl:element name="img" use-attribute-sets="anchor.edit"/>
                                                        </a>
                                                </td>
                                        </xsl:if>
                                </tr>
                        </table>
                </div>
                <xsl:apply-templates mode="c_typedarticle" select="/H2G2/MULTI-STAGE/MULTI-REQUIRED/ERRORS/ERROR | /H2G2/MULTI-STAGE/MULTI-ELEMENT/ERRORS/ERROR"/>
                <!-- THIS CALLS THE PREVIEW -->
                <xsl:apply-templates mode="c_preview" select="."/>
                <xsl:choose>
                        <xsl:when
                                test="$test_IsEditor and contains($article_type_name,'editor_review') or $article_type_group = 'interview' or $article_type_group = 'column' or $article_type_group = 'feature' or /H2G2/ARTICLE/ARTICLEINFO/STATUS/@TYPE=1 and $test_IsEditor and $current_article_type=1">
                                <xsl:call-template name="EDITOR_REVIEW"/>
                        </xsl:when>
                        <xsl:when test="/H2G2/ARTICLE/ARTICLEINFO/STATUS/@TYPE=9 and $test_IsEditor or contains($article_type_name,'editor_article')">
                                <xsl:call-template name="EDITOR_PAGE"/>
                        </xsl:when>
                        <xsl:when test="$article_type_user='member' and $article_type_group='review' or /H2G2/ARTICLE/ARTICLEINFO/STATUS/@TYPE=3 and $current_article_type=1">
                                <xsl:call-template name="MEMBER_REVIEW"/>
                        </xsl:when>
                        <xsl:when test="$article_type_group='frontpage'">
                                <xsl:call-template name="EDITOR_FRONTPAGE"/>
                        </xsl:when>
                        <xsl:when test="$current_article_type=4001">
                                <xsl:call-template name="EDITOR_CATEGORY"/>
                        </xsl:when>
                        <xsl:when test="$current_article_type=100 or $current_article_type=101">
                                <xsl:call-template name="EDITOR_ARCHIVE"/>
                        </xsl:when>
                        <xsl:otherwise>
                                <xsl:call-template name="MEMBER_PAGE"/>
                        </xsl:otherwise>
                </xsl:choose>
        </xsl:template>
        <!-- RATING DROPDOWN -->
        <xsl:template match="MULTI-STAGE" mode="r_ratingtype">
                <xsl:variable name="def_rating">
                        <xsl:value-of select="MULTI-ELEMENT[@NAME='RATING']/VALUE-EDITABLE"/>
                </xsl:variable>
                <select class="write-review-step-3" id="write-review-form-3" name="RATING">
                        <option value="3">rate</option>
                        <option>
                                <xsl:if test="$def_rating=1">
                                        <xsl:attribute name="selected">selected</xsl:attribute>
                                </xsl:if>1</option>
                        <option>
                                <xsl:if test="$def_rating='1 and 1/2'">
                                        <xsl:attribute name="selected">selected</xsl:attribute>
                                </xsl:if>1 and 1/2</option>
                        <option>
                                <xsl:if test="$def_rating=2">
                                        <xsl:attribute name="selected">selected</xsl:attribute>
                                </xsl:if>2</option>
                        <option>
                                <xsl:if test="$def_rating='2 and 1/2'">
                                        <xsl:attribute name="selected">selected</xsl:attribute>
                                </xsl:if>2 and 1/2</option>
                        <option>
                                <xsl:if test="$def_rating=3">
                                        <xsl:attribute name="selected">selected</xsl:attribute>
                                </xsl:if>3</option>
                        <option>
                                <xsl:if test="$def_rating='3 and 1/2'">
                                        <xsl:attribute name="selected">selected</xsl:attribute>
                                </xsl:if>3 and 1/2</option>
                        <option>
                                <xsl:if test="$def_rating=4">
                                        <xsl:attribute name="selected">selected</xsl:attribute>
                                </xsl:if>4</option>
                        <option>
                                <xsl:if test="$def_rating='4 and 1/2'">
                                        <xsl:attribute name="selected">selected</xsl:attribute>
                                </xsl:if>4 and 1/2</option>
                        <option>
                                <xsl:if test="$def_rating=5">
                                        <xsl:attribute name="selected">selected</xsl:attribute>
                                </xsl:if>5</option>
                        <option>
                                <xsl:if test="$def_rating='no rating'">
                                        <xsl:attribute name="selected">selected</xsl:attribute>
                                </xsl:if>no rating</option>
                </select>
        </xsl:template>
        <!--END RATING DROPDOWN -->
        <!-- ARTICLE TYPE DROPDOWN -->
        <xsl:template match="MULTI-STAGE" mode="r_articletype">
                <xsl:param name="group"/>
                <xsl:param name="user"/>
                <select id="write-review-step-1" name="type">
                        <xsl:choose>
                                <xsl:when test="$current_article_type=1 and /H2G2/ARTICLE/ARTICLEINFO/STATUS/@TYPE=3">
                                        <xsl:apply-templates mode="t_articletype" select="msxsl:node-set($type)/type[@group='review' and @user='member']"/>
                                </xsl:when>
                                <xsl:when test="$current_article_type=1 and /H2G2/ARTICLE/ARTICLEINFO/STATUS/@TYPE=1">
                                        <xsl:apply-templates mode="t_articletype" select="msxsl:node-set($type)/type[@group='review' and @user='editor']"/>
                                </xsl:when>
                                <xsl:when test="$current_article_type=3  or /H2G2/ARTICLE/ARTICLEINFO/STATUS/@TYPE=9">
                                        <xsl:apply-templates mode="t_articletype" select="msxsl:node-set($type)/type[@group='article' and @user='editor']"/>
                                </xsl:when>
                                <xsl:otherwise>
                                        <xsl:apply-templates mode="t_articletype" select="msxsl:node-set($type)/type[@group=$group and @user=$user]"/>
                                </xsl:otherwise>
                        </xsl:choose>
                        <xsl:if test="$test_IsEditor">
                                <option>--------change type-------</option>
                                <option value="55">editor feature</option>
                                <option value="70">editor interview</option>
                                <option value="85">editor column</option>
                                <option value="3">editor article</option>
                                <option value="4">frontpage</option>
                        </xsl:if>
                </select>
        </xsl:template>
        <xsl:template match="type" mode="t_articletype">
                <!-- use either selected number or normal number depending on status -->
                <xsl:variable name="articletype_number">
                        <xsl:choose>
                                <xsl:when test="$selected_status='on'">
                                        <xsl:value-of select="@selectnumber"/>
                                </xsl:when>
                                <xsl:otherwise>
                                        <xsl:value-of select="@number"/>
                                </xsl:otherwise>
                        </xsl:choose>
                </xsl:variable>
                <option value="{$articletype_number}">
                        <xsl:if test="$current_article_type=$articletype_number">
                                <xsl:attribute name="selected">selected</xsl:attribute>
                        </xsl:if>
                        <xsl:value-of select="@label"/>
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
                        <xsl:when test="$article_type_group='frontpage' or $current_article_type=100 or $current_article_type=101">
                                <xsl:apply-templates select="/H2G2/ARTICLE/GUIDE/BODY/MAIN-SECTIONS/EDITORIAL/ROW"/>
                        </xsl:when>
                        <!-- for category top pages -->
                        <xsl:when test="/H2G2/ARTICLE/EXTRAINFO/TYPE/@ID = '4001'">
                                <xsl:call-template name="category-content">
                                        <xsl:with-param name="articleNode" select="/H2G2/ARTICLE" />
                                </xsl:call-template>
                        </xsl:when>
                        <xsl:otherwise>
                                <table border="0" cellpadding="0" cellspacing="0">
                                        <tr>
                                                <xsl:element name="td" use-attribute-sets="column.1">
                                                        <!-- this takes you to the article template in article.xsl -->
                                                        <xsl:apply-templates mode="c_articlepage" select="/H2G2/ARTICLE"/>
                                                        <xsl:element name="img" use-attribute-sets="column.spacer.1"/>
                                                </xsl:element>
                                                <xsl:element name="td" use-attribute-sets="column.3">
                                                        <xsl:element name="img" use-attribute-sets="column.spacer.3"/>
                                                </xsl:element>
                                                <xsl:element name="td" use-attribute-sets="column.2">
                                                        <xsl:choose>
                                                                <!-- FOR ALL MEMBER ARTICLES -->
                                                                <xsl:when test="$article_type_user='member' and $article_type_group='review'">
                                                                        <xsl:if test="/H2G2/ARTICLE/GUIDE[descendant::USEFULLINKS!='']">
                                                                                <div class="generic-l">
                                                                                        <div class="generic-e-DA8A42">
                                                                                                <strong>
                                                                                                    <xsl:element name="{$text.subheading}" use-attribute-sets="text.subheading">related
                                                                                                    info</xsl:element>
                                                                                                </strong>
                                                                                        </div>
                                                                                        <div class="generic-v">
                                                                                                <div class="like-this"><img alt="" border="0" height="20" src="{$imagesource}icons/useful_links.gif"
                                                                                                    width="20"/>&nbsp;<xsl:element name="{$text.base}" use-attribute-sets="text.base">
                                                                                                    <strong>useful links</strong>
                                                                                                    </xsl:element></div>
                                                                                                <xsl:variable name="usefullink" select="/H2G2/ARTICLE/GUIDE/USEFULLINKS"/>
                                                                                                <xsl:variable name="usefullinkchecked">
                                                                                                    <xsl:choose>
                                                                                                    <xsl:when
                                                                                                    test="starts-with($usefullink,'http://') or starts-with($usefullink,'#') or starts-with($usefullink,'mailto:') or (starts-with($usefullink,'/') and contains(substring-after($usefullink,'/'),'/'))">
                                                                                                    <xsl:value-of select="$usefullink"/>
                                                                                                    </xsl:when>
                                                                                                    <xsl:when test="starts-with($usefullink,'/') and string-length($usefullink) &gt; 1">
                                                                                                    <xsl:value-of select="concat('http:/', $usefullink)"/>
                                                                                                    </xsl:when>
                                                                                                    <xsl:when
                                                                                                    test="starts-with($usefullink,'www') and string-length($usefullink) &gt; 1">
                                                                                                    <xsl:value-of select="concat('http://', $usefullink)"/>
                                                                                                    </xsl:when>
                                                                                                    </xsl:choose>
                                                                                                </xsl:variable>
                                                                                                <xsl:choose>
                                                                                                    <xsl:when test="$article_type_user='member'">
                                                                                                    <xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall">
                                                                                                    <a href="{$usefullinkchecked}" id="related" xsl:use-attribute-sets="mLINK">
                                                                                                    <xsl:apply-templates select="/H2G2/ARTICLE/GUIDE/LINKTITLE"/>
                                                                                                    </a>
                                                                                                    </xsl:element>
                                                                                                    </xsl:when>
                                                                                                    <xsl:otherwise>
                                                                                                    <xsl:apply-templates select="/H2G2/ARTICLE/GUIDE/USEFULLINKS"/>
                                                                                                    </xsl:otherwise>
                                                                                                </xsl:choose>
                                                                                        </div>
                                                                                        <div class="generic-k">
                                                                                                <xsl:element name="{$text.small}" use-attribute-sets="text.small">
                                                                                                    <xsl:value-of select="$coll_usefullinkdisclaimer"/>
                                                                                                </xsl:element>
                                                                                        </div>
                                                                                </div>
                                                                        </xsl:if>
                                                                </xsl:when>
                                                                <!-- FOR ALL EDITOR ARTICLES -->
                                                                <xsl:otherwise>
                                                                        <xsl:apply-templates mode="c_articlepage" select="/H2G2/ARTICLE/ARTICLEINFO"/>
                                                                </xsl:otherwise>
                                                        </xsl:choose>
                                                        <xsl:element name="img" use-attribute-sets="column.spacer.2"/>
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
                                        <xsl:element name="{$text.base}" use-attribute-sets="text.base">
                                                <strong> There is a problem with your page. You may have used an "&lt;" symbol which unfortunately doesn't work on Collective. Please remove it and
                                                        click preview again. </strong>
                                        </xsl:element>
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
                        <label class="form-label">hide <xsl:value-of select="$article_type_group"/>:</label>
                        <xsl:apply-templates mode="t_hidearticle" select="."/>
                </xsl:element>
        </xsl:template>
        <!--
	<xsl:template match="DELETED" mode="r_deleted">
	Use: Template invoked after deleting an article
	 -->
        <xsl:template match="DELETED" mode="r_article">
                <div class="errorpage">
                        <xsl:element name="{$text.base}" use-attribute-sets="text.base">
                                <strong>This article has been deleted.</strong>
                                <br/>
                                <br/>
                                <!--  If you want to restore any deleted articles you can view them <xsl:apply-imports/> -->
                        </xsl:element>
                </div>
        </xsl:template>
        <xsl:template match="MULTI-STAGE" mode="r_articlestatus">
                <xsl:element name="{$text.base}" use-attribute-sets="text.base">
                        <label class="form-label"><xsl:value-of select="$article_type_group"/> status:</label>
                        <xsl:text> </xsl:text>
                </xsl:element>
                <!-- template -->
                <!-- have to overwrite base template as collective editors want their forms to default to status =1 -->
                <xsl:choose>
                        <xsl:when test="@TYPE='TYPED-ARTICLE-EDIT' or @TYPE='TYPED-ARTICLE-EDIT-PREVIEW' or @TYPE='TYPED-ARTICLE-PREVIEW'">
                                <input name="status" type="text" value="{MULTI-REQUIRED[@NAME='STATUS']/VALUE-EDITABLE}" xsl:use-attribute-sets="iMULTI-STAGE_r_articlestatus"/>
                        </xsl:when>
                        <xsl:when test="$article_type_user='editor' and @TYPE='TYPED-ARTICLE-CREATE'">
                                <input name="status" type="text" value="1" xsl:use-attribute-sets="iMULTI-STAGE_r_articlestatus"/>
                        </xsl:when>
                        <xsl:otherwise>
                                <input name="status" type="text" value="{MULTI-REQUIRED[@NAME='STATUS']/VALUE-EDITABLE}" xsl:use-attribute-sets="iMULTI-STAGE_r_articlestatus"/>
                        </xsl:otherwise>
                </xsl:choose>
        </xsl:template>
        <xsl:attribute-set name="fMULTI-STAGE_c_article"/>
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
                                <xsl:when test="$article_type_group='frontpage' or $current_article_type=4001 or $article_type_group='archive'"/>
                                <xsl:otherwise>write-review-form-5</xsl:otherwise>
                        </xsl:choose>
                </xsl:attribute>
                <xsl:attribute name="class">
                        <xsl:choose>
                                <xsl:when test="$article_type_group='frontpage' or $current_article_type=4001 or $article_type_group='archive'"/>
                                <xsl:when test="$article_type_user='member' and $article_type_group='review' or /H2G2/ARTICLE/ARTICLEINFO/STATUS/@TYPE=3 and $current_article_type=1">members</xsl:when>
                                <xsl:otherwise> write-review-step-5</xsl:otherwise>
                        </xsl:choose>
                </xsl:attribute>
                <xsl:attribute name="cols">
                        <xsl:choose>
                                <xsl:when test="$article_type_group='frontpage' or $current_article_type=4001 or $article_type_group='archive'">95</xsl:when>
                                <xsl:otherwise>30</xsl:otherwise>
                        </xsl:choose>
                </xsl:attribute>
                <xsl:attribute name="rows">
                        <xsl:choose>
                                <xsl:when test="$article_type_group='frontpage' or $current_article_type=4001 or $article_type_group='archive'">30</xsl:when>
                                <xsl:otherwise>8</xsl:otherwise>
                        </xsl:choose>
                </xsl:attribute>
        </xsl:attribute-set>
        <!-- lots of duplication here ? a lot the var names seem redundant in the base xsl -->
        <xsl:attribute-set name="mMULTI-STAGE_t_articlepreviewbutton" use-attribute-sets="form.preview"/>
        <xsl:attribute-set name="mMULTI-STAGE_t_articlepreview" use-attribute-sets="form.preview"/>
        <xsl:attribute-set name="mMULTI-STAGE_t_articlecreate" use-attribute-sets="form.publish"/>
        <xsl:attribute-set name="mMULTI-STAGE_t_articlecreatebutton" use-attribute-sets="form.publish"/>
        <xsl:attribute-set name="mMULTI-STAGE_r_articlecreatebutton" use-attribute-sets="form.publish"/>
        <xsl:attribute-set name="mMULTI-STAGE_r_articleeditbutton" use-attribute-sets="form.publish"/>
        <xsl:attribute-set name="iMULTI-STAGE_r_articlestatus">
                <xsl:attribute name="size">5</xsl:attribute>
        </xsl:attribute-set>
        <!--
     <xsl:attribute-set name="mMULTI-STAGE_t_hidearticle"/>
     Use: Presentation attributes for the Hide article input box
      -->
        <xsl:attribute-set name="mMULTI-STAGE_t_hidearticle"/>
</xsl:stylesheet>
