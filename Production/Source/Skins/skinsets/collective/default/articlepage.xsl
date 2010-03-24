<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet exclude-result-prefixes="msxsl local s dt" version="1.0" xmlns:dt="urn:schemas-microsoft-com:datatypes" xmlns:local="#local-functions" xmlns:msxsl="urn:schemas-microsoft-com:xslt"
        xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
        <xsl:import href="../../../base/base-articlepage.xsl"/>
        <!-- Frontpages -->
        <xsl:import href="reviewfrontpage.xsl"/>
        <xsl:import href="communityfrontpage.xsl"/>
        <xsl:import href="featurefrontpage.xsl"/>
        <xsl:import href="recommendedfrontpage.xsl"/>
        <xsl:import href="watchandlistenfrontpage.xsl"/>
        <xsl:import href="archivepage.xsl"/>
        <!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
									Page - Level  template
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
        <xsl:template name="ARTICLE_MAINBODY">
                <!-- CHOOSE FRONT PAGE - accomodates different layouts in the future -->
                <xsl:choose>
                        <xsl:when test="$current_article_type=5">
                                <xsl:call-template name="REVIEW_MAINBODY"/>
                        </xsl:when>
                        <xsl:when test="$current_article_type=6">
                                <xsl:call-template name="RECOMMNDED_MAINBODY"/>
                        </xsl:when>
                        <xsl:when test="$current_article_type=7">
                                <xsl:call-template name="FEATURE_MAINBODY"/>
                        </xsl:when>
                        <xsl:when test="$current_article_type=8">
                                <xsl:call-template name="COMMUNITY_MAINBODY"/>
                        </xsl:when>
                        <xsl:when test="$current_article_type=4">
                                <xsl:call-template name="WATCHANDLISTEN_MAINBODY"/>
                        </xsl:when>
                        <xsl:when test="$article_type_group='archive'">
                                <xsl:call-template name="ARCHIVE_MAINBODY"/>
                        </xsl:when>
                        <xsl:otherwise>
                                <!-- REST OF ARTICLE PAGES -->
                                <!-- DEBUG -->
                                <xsl:call-template name="TRACE">
                                        <xsl:with-param name="message">ARTICLE_MAINBODY test variable = <xsl:value-of select="$current_article_type"/></xsl:with-param>
                                        <xsl:with-param name="pagename">articlepage.xsl</xsl:with-param>
                                </xsl:call-template>
                                <!-- DEBUG -->
                                <div class="generic-c">
                                        <table border="0" cellpadding="0" cellspacing="0" width="600">
                                                <tr>
                                                        <td>
                                                                <xsl:choose>
                                                                        <!-- old article -->
                                                                        <xsl:when test="$current_article_type=1">
                                                                                <xsl:call-template name="box.crumb">
                                                                                        <xsl:with-param name="box.crumb.href" select="0"/>
                                                                                        <xsl:with-param name="box.crumb.value"/>
                                                                                        <xsl:with-param name="box.crumb.title">
                                                                                                <xsl:choose>
                                                                                                    <xsl:when test="$article_authortype='editor'"> editors review </xsl:when>
                                                                                                    <xsl:when test="$article_authortype='member'"> member's portfolio page </xsl:when>
                                                                                                    <xsl:when test="$article_authortype='you' and /H2G2/ARTICLE/ARTICLEINFO/STATUS/@TYPE=3"> your
                                                                                                    portfolio page </xsl:when>
                                                                                                    <xsl:when test="$article_authortype='you' and /H2G2/ARTICLE/ARTICLEINFO/STATUS/@TYPE=1"> your
                                                                                                    review </xsl:when>
                                                                                                </xsl:choose>
                                                                                        </xsl:with-param>
                                                                                </xsl:call-template>
                                                                        </xsl:when>
                                                                        <!-- member article -->
                                                                        <xsl:when test="$current_article_type=2">
                                                                                <xsl:call-template name="box.crumb">
                                                                                        <xsl:with-param name="box.crumb.href" select="concat($root,'community')"/>
                                                                                        <xsl:with-param name="box.crumb.value">community</xsl:with-param>
                                                                                        <xsl:with-param name="box.crumb.title"><xsl:value-of select="$m_memberormy"/> portfolio page</xsl:with-param>
                                                                                </xsl:call-template>
                                                                        </xsl:when>
                                                                        <!-- editor artcile -->
                                                                        <xsl:when test="contains($article_type_name,'editor_article')">
                                                                                <xsl:call-template name="box.crumb">
                                                                                        <xsl:with-param name="box.crumb.href" select="$root"/>
                                                                                        <xsl:with-param name="box.crumb.value"/>
                                                                                        <xsl:with-param name="box.crumb.title">
                                                                                                <xsl:value-of select="ARTICLE/SUBJECT"/>
                                                                                        </xsl:with-param>
                                                                                </xsl:call-template>
                                                                        </xsl:when>
                                                                        <!-- reviews -->
                                                                        <xsl:when test="$article_type_group='review'">
                                                                                <xsl:call-template name="box.crumb">
                                                                                        <xsl:with-param name="box.crumb.href" select="concat($root,'reviews')"/>
                                                                                        <xsl:with-param name="box.crumb.value">reviews</xsl:with-param>
                                                                                        <xsl:with-param name="box.crumb.title" select="concat($article_type_user,' ',$article_type_label)"/>
                                                                                </xsl:call-template>
                                                                        </xsl:when>
                                                                        <xsl:otherwise>
                                                                                <!--  all the rest - features -->
                                                                                <xsl:call-template name="box.crumb">
                                                                                        <xsl:with-param name="box.crumb.href" select="concat($root,'features')"/>
                                                                                        <xsl:with-param name="box.crumb.value">features</xsl:with-param>
                                                                                        <xsl:with-param name="box.crumb.title" select="$article_type_label"/>
                                                                                </xsl:call-template>
                                                                        </xsl:otherwise>
                                                                </xsl:choose>
                                                        </td>
                                                        <td align="right">
                                                                <xsl:copy-of select="$content.by"/>
                                                        </td>
                                                </tr>
                                        </table>
                                </div>
                                <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                        <tr>
                                                <xsl:element name="td" use-attribute-sets="column.1">
                                                        <xsl:apply-templates mode="c_skiptomod" select="ARTICLE-MODERATION-FORM"/>
                                                        <xsl:apply-templates mode="c_modform" select="ARTICLE-MODERATION-FORM"/>
                                                        <!-- moderation tool bar -->
                                                        <div>
                                                                <xsl:apply-templates mode="c_articlepage" select="/H2G2/ARTICLE/ARTICLEINFO/MODERATIONSTATUS"/>
                                                        </div>
                                                        <!--  start of article main -->
                                                        <!-- article -->
                                                        <xsl:apply-templates mode="c_articlepage" select="ARTICLE"/>
                                                        <!-- other stuff.... -->
                                                        <!-- <xsl:apply-templates select="ARTICLE" mode="c_unregisteredmessage"/> -->
                                                </xsl:element>
                                                <xsl:element name="td" use-attribute-sets="column.3">
                                                        <xsl:element name="img" use-attribute-sets="column.spacer.3"/>
                                                </xsl:element>
                                                <xsl:element name="td" use-attribute-sets="column.2">
                                                        <!-- start of article nav -->
                                                        <xsl:apply-templates mode="c_articlepage" select="ARTICLE/ARTICLEINFO"/>
                                                </xsl:element>
                                        </tr>
                                </table>
                        </xsl:otherwise>
                </xsl:choose>
        </xsl:template>
        <!--
	<xsl:template match="MODERATIONSTATUS" mode="r_articlepage">
	Description: moderation status of the article
	 -->
        <xsl:template match="MODERATIONSTATUS" mode="r_articlepage">
                <!-- commented out temporarily SZ - until it can be built so that it doesn't break page -->
                <!-- <xsl:apply-imports/> -->
        </xsl:template>
        <!--
	<xsl:template match="ARTICLE" mode="noentryyet_articlepage">
	Author:        Tom Whitehouse
	Context:      /H2G2
	Purpose:      Template for when a valid H2G2ID hasn't been created yet
      -->
        <xsl:template match="ARTICLE" mode="noentryyet_articlepage">
                <div class="myspace-b">
                        <xsl:element name="{$text.base}" use-attribute-sets="text.base">
                                <xsl:copy-of select="$m_noentryyet"/>
                        </xsl:element>
                </div>
        </xsl:template>
        <!--
	<xsl:template match="ARTICLE" mode="r_unregisteredmessage">
	Description: message to be displayed if the viewer is not registered
	 -->
        <xsl:template match="ARTICLE" mode="r_unregisteredmessage">
                <xsl:copy-of select="$m_unregisteredslug"/>
        </xsl:template>
        <!--
	<xsl:template match="ARTICLE-MODERATION-FORM" mode="r_skiptomod">
	Description: Presentation of link that skips to the moderation section
	 -->
        <xsl:template match="ARTICLE-MODERATION-FORM" mode="r_skiptomod">
                <xsl:apply-imports/>
                <br/>
        </xsl:template>
        <!--
	<xsl:template match="ARTICLE-MODERATION-FORM" mode="r_modform">
	Description: Presentation of the article moderation form
	Visible to: Moderators
	 -->
        <xsl:template match="ARTICLE-MODERATION-FORM" mode="r_modform">
                <xsl:apply-imports/>
        </xsl:template>
        <!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
							ARTICLE Object
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
        <xsl:template match="ARTICLE" mode="r_articlepage">
                <!-- START OF ARTICLE -->
                <!-- different article head layouts depending on type -->
                <xsl:choose>
                        <!-- MEMBER REVIEW - SAME LAYOUT FOR EACH ARTICLE SUBTYPE FILM, BOOK, ART -->
                        <xsl:when test="$layout_type='layout_c'">
                                <xsl:apply-templates mode="c_articlelayoutc" select="."/>
                        </xsl:when>
                        <!-- IMAGE LAYOUT A FOR EDITORIAL CONTENT -->
                        <xsl:when test="$layout_type='layout_a'">
                                <xsl:apply-templates mode="c_articlelayouta" select="."/>
                        </xsl:when>
                        <!-- IMAGE LAYOUT B FOR EDITORIAL CONTENT-->
                        <xsl:otherwise>
                                <xsl:apply-templates mode="c_articlelayoutb" select="."/>
                        </xsl:otherwise>
                </xsl:choose>

                <!-- REST OF ARTICLE  -->
                <!-- REAL MEDIA PANEL - SNIPPET for all new content -->
                <xsl:choose>
                        <xsl:when test="/H2G2/ARTICLE/GUIDE/SNIPPETS/SNIPPET">
                                <div class="page-column-1">
                                        <div class="snippetbox">
                                                <table border="0" cellpadding="0" cellspacing="0">
                                                        <xsl:apply-templates mode="c_realmedia" select="/H2G2/ARTICLE/GUIDE/SNIPPETS"/>
                                                </table>
                                        </div>
                                        <xsl:copy-of select="$download.realplayer"/>
                                </div>
                        </xsl:when>
                        <xsl:when test="/H2G2/ARTICLE/GUIDE/SNIPPETS != ''">
                                <div class="page-column-1">
                                        <xsl:apply-templates select="/H2G2/ARTICLE/GUIDE/SNIPPETS"/>
                                        <xsl:copy-of select="$download.realplayer"/>
                                </div>
                        </xsl:when>
                </xsl:choose>
                <!-- HEADLINE -->
                <div class="generic-p">
                        <xsl:element name="{$text.base}" use-attribute-sets="text.base">
                                <xsl:if test="/H2G2/ARTICLE/GUIDE[descendant::HEADLINE!='']|/H2G2/ARTICLE/GUIDE[descendant::TAGLINE!='']">
                                        <div class="generic-q">
                                                <strong>
                                                        <xsl:apply-templates select="/H2G2/ARTICLE/GUIDE/HEADLINE"/>
                                                        <xsl:apply-templates select="/H2G2/ARTICLE/GUIDE/TAGLINE"/>
                                                </strong>
                                        </div>
                                </xsl:if>
                                <!-- BODY -->
                                <xsl:choose>
                                        <xsl:when test="$article_type_user='member' and $article_type_group='review'">
                                                <xsl:apply-templates select="/H2G2/ARTICLE/GUIDE/BODY"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                                <xsl:apply-templates select="/H2G2/ARTICLE/GUIDE/BODY/text() | /H2G2/ARTICLE/GUIDE/BODY/* "/>
                                        </xsl:otherwise>
                                </xsl:choose>
                        </xsl:element>
                        <!-- RATING PAGE AUTOUR AND DATE -->
                        <xsl:if test="not($layout_type='layout_c')">
                                <br/>
                                <br/>
                                <div class="userdate">
                                        <xsl:element name="{$text.base}" use-attribute-sets="text.base">
                                                <a href="{GUIDE/EDITORDNAID}">
                                                        <xsl:value-of select="GUIDE/EDITORNAME"/>
                                                </a>
                                                <xsl:text> </xsl:text>
                                                <xsl:apply-templates select="GUIDE/PUBLISHDATE"/>
                                                <xsl:text> </xsl:text>
                                                <xsl:apply-templates mode="c_rating" select="."/>
                                        </xsl:element>
                                </div>
                        </xsl:if>
                </div>
                <!--  BOLD INFO -->
                <xsl:if test="GUIDE[descendant::BOLDINFO!='']">
                        <div class="generic-p">
                                <xsl:element name="{$text.base}" use-attribute-sets="text.base">
                                        <div>
                                                <b>
                                                        <xsl:value-of select="GUIDE/BOLDINFO"/>
                                                </b>
                                        </div>
                                </xsl:element>
                        </div>
                </xsl:if>
                <!--  BOTTOMTEXT -->
                <xsl:if test="GUIDE[descendant::BOTTOMTEXT!='']">
                        <div class="generic-p">
                                <xsl:element name="{$text.base}" use-attribute-sets="text.base">
                                        <br/>
                                        <xsl:apply-templates select="GUIDE/BOTTOMTEXT"/>
                                </xsl:element>
                        </div>
                </xsl:if>
                <!-- ===== DONT SHOW IN PREVIEW MODE - start ===== -->
                <xsl:if test="not(/H2G2/ARTICLE/GUIDE/BODY/NOFORUM or /H2G2/MULTI-STAGE[@TYPE='TYPED-ARTICLE-EDIT-PREVIEW' or @TYPE='TYPED-ARTICLE-PREVIEW'])">
                        <!-- SEND TO A FRIEND -->
                        <table border="0" cellpadding="0" cellspacing="0" width="390">
                                <tr>
                                        <td>
                                                <xsl:element name="{$text.base}" use-attribute-sets="text.base">
                                                        <xsl:copy-of select="$coll_sendtoafriend"/>
                                                </xsl:element>
                                        </td>
                                        <td align="right">
                                                <!-- complain - dont show on editorial -->
                                                <xsl:if test="not($article_authortype='editor')">
                                                        <a
                                                                href="javascript:popupwindow('/dna/collective/UserComplaint?h2g2ID={/H2G2/ARTICLE/ARTICLEINFO/H2G2ID}', 'ComplaintPopup', 'status=1,resizable=1,scrollbars=1,width=640,height=480')"
                                                                xsl:use-attribute-sets="maHIDDEN_r_complainmp">
                                                                <xsl:copy-of select="$alt_complain"/>
                                                        </a>
                                                </xsl:if>
                                        </td>
                                </tr>
                        </table>
                        <!-- CONVERSATIONS -->
                        <a id="talkabouthis" name="talkabouthis"/>
                        <!-- TALK ABOUT BOX -->
                        <div class="generic-e-DA8A42">
                                <img alt="" border="0" height="21" src="{$imagesource}icons/talk_about_this_orange.gif" width="20"/>
                                <xsl:element name="{$text.subheading}" use-attribute-sets="text.subheading"> &nbsp;<strong>
                                                <xsl:choose>
                                                        <xsl:when test="/H2G2/ARTICLEFORUM/FORUMTHREADS">conversations</xsl:when>
                                                        <xsl:when test="/H2G2/ARTICLEFORUM/FORUMTHREADPOSTS">comments</xsl:when>
                                                </xsl:choose>
                                        </strong>
                                </xsl:element>
                        </div>
                        <!-- CONVERSATION LIST -->
                        <xsl:apply-templates mode="c_article" select="/H2G2/ARTICLEFORUM"/>
                        <!-- / END CONVERSATIONS -->
                </xsl:if>
                <xsl:if test="not(/H2G2/MULTI-STAGE[@TYPE='TYPED-ARTICLE-EDIT-PREVIEW' or @TYPE='TYPED-ARTICLE-PREVIEW'])">
                        <xsl:call-template name="editorbox"/>
                </xsl:if>
                <!--========= DONT SHOW IN PREVIEW MODE - end ======== -->
        </xsl:template>
        <!--
	<xsl:template match="ARTICLE" mode="r_rating">
	Description: Presentation of Member reviews - horrible botchy code so that they can rate by halves...
				 translate() is used  remove space - i.e change 'no rating' into 'norating'
	 -->
        <xsl:template match="ARTICLE" mode="c_rating">
                <xsl:variable name="ratingimg">
                        <xsl:choose>
                                <xsl:when test="contains(/H2G2/ARTICLE/GUIDE/RATING, '/')">
                                        <xsl:value-of select="substring-before(translate(/H2G2/ARTICLE/GUIDE/RATING, ' ', '_'), '/')"/>
                                </xsl:when>
                                <xsl:otherwise>
                                        <xsl:value-of select="translate(/H2G2/ARTICLE/GUIDE/RATING, ' ','')"/>
                                </xsl:otherwise>
                        </xsl:choose>
                </xsl:variable>
                <xsl:if test="not(/H2G2/ARTICLE/GUIDE/RATING='' or $current_article_type=1)">
                        <img alt="rating of {/H2G2/ARTICLE/GUIDE/RATING}" border="0" height="12" src="{$imagesource}icons/rating_{$ratingimg}.gif" width="64"/>
                        <!-- <xsl:value-of select="/H2G2/ARTICLE/GUIDE/RATING" /> out of 5 -->
                </xsl:if>
        </xsl:template>
        <!--
	<xsl:template match="ARTICLE" mode="r_articlelayouta">
	Description: Presentation of layout a Cinema, art/exhibitions/ comedy, TV, Theatre, gig/festivals, games, other
	 -->
        <!-- LAYOUT A -->
        <xsl:template match="ARTICLE" mode="c_articlelayouta">
                <xsl:choose>
                        <!-- OLD EDITOR PICTURE -->
                        <xsl:when test="/H2G2/ARTICLE/GUIDE/FURNITURE/PICTURE">
                                <div align="center" class="generic-m">
                                        <xsl:apply-templates select="/H2G2/ARTICLE/GUIDE/FURNITURE/PICTURE"/>
                                        <xsl:value-of select="GUIDE/MAINTITLE"/>
                                </div>
                        </xsl:when>
                        <!-- OLD Status = 9 HELP FAQ PICTURE -->
                        <xsl:when test="/H2G2/ARTICLE/ARTICLEINFO/STATUS/@TYPE=9 and $current_article_type=1">
                                <div align="center" class="generic-m">
                                        <xsl:apply-templates select="/H2G2/ARTICLE/GUIDE/FURNITURE/PICTURE"/>
                                        <img alt="{GUIDE/PICTUREALT}" border="0" height="{GUIDE/PICTUREHEIGHT}" src="{$graphics}{GUIDE/PICTURENAME}" width="{GUIDE/PICTUREWIDTH}"/>
                                        <xsl:value-of select="GUIDE/MAINTITLE"/>
                                </div>
                        </xsl:when>
                        <!-- OLD Status = 3 member review -->
                        <xsl:when test="/H2G2/ARTICLE/ARTICLEINFO/STATUS/@TYPE=3 and $current_article_type=1">
                                <div class="generic-m">
                                        <!-- SUBJECT -->
                                        <xsl:element name="{$text.heading}" use-attribute-sets="text.heading">
                                                <strong>
                                                        <xsl:value-of select="SUBJECT"/>
                                                </strong>
                                        </xsl:element>
                                        <br/>
                                        <!-- PAGE ATHOUR AND DATE -->
                                        <xsl:element name="{$text.base}" use-attribute-sets="text.base"> by: <xsl:apply-templates mode="c_article" select="ARTICLEINFO/PAGEAUTHOR"
                                                        />&nbsp;&nbsp;<xsl:apply-templates mode="short1" select="ARTICLEINFO/DATECREATED/DATE"/>
                                        </xsl:element>
                                </div>
                        </xsl:when>
                        <!-- EDITOR PAGE NO PICTURE -->
                        <xsl:when test="$current_article_type=3">
                                <div class="generic-m">
                                        <div>
                                                <xsl:element name="{$text.heading}" use-attribute-sets="text.heading">
                                                        <xsl:value-of select="GUIDE/MAINTITLE"/>
                                                </xsl:element>
                                        </div>
                                        <div>
                                                <xsl:element name="{$text.subheading}" use-attribute-sets="text.subheading">
                                                        <xsl:value-of select="GUIDE/SUBTITLE"/>
                                                </xsl:element>
                                        </div>
                                </div>
                        </xsl:when>
                        <xsl:otherwise>
                                <div class="reviewimage">
                                        <img alt="{GUIDE/PICTUREALT}" border="0" height="{GUIDE/PICTUREHEIGHT}" name="image-filter-613" src="{$graphics}{GUIDE/PICTURENAME}"
                                                width="{GUIDE/PICTUREWIDTH}"/>
                                </div>
                                <div class="frontimage">
                                        <xsl:element name="{$text.subheading}" use-attribute-sets="text.subheading">
                                                <xsl:value-of select="GUIDE/MAINTITLE"/>
                                        </xsl:element>
                                </div>
                        </xsl:otherwise>
                </xsl:choose>
        </xsl:template>
        <!--
	<xsl:template match="ARTICLE" mode="r_articlelayoutb">
	Description: Presentation of layout b
	 -->
        <xsl:template match="ARTICLE" mode="c_articlelayoutb">
                <!-- LAYOUT B -->
                <div class="generic-m-fixed">
                        <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                <tr>
                                        <td height="136" valign="middle" width="200">
                                                <img alt="{GUIDE/PICTUREALT}" border="0" height="{GUIDE/PICTUREHEIGHT}" src="{$graphics}{GUIDE/PICTURENAME}" width="{GUIDE/PICTUREWIDTH}"/>
                                        </td>
                                        <td valign="middle">
                                                <!-- REVIEW TYPE -->
                                                <!-- AUTHOR - please leave in this is in design! -->
                                                <xsl:element name="{$text.subheading}" use-attribute-sets="text.subheading">
                                                        <xsl:value-of select="GUIDE/AUTHOR"/>
                                                        <br/>
                                                </xsl:element>
                                                <!-- TITLE -->
                                                <xsl:element name="{$text.heading}" use-attribute-sets="text.heading">
                                                        <strong>
                                                                <xsl:value-of select="GUIDE/MAINTITLE"/>
                                                                <br/>
                                                        </strong>
                                                </xsl:element>
                                                <xsl:element name="{$text.base}" use-attribute-sets="text.base">
                                                        <xsl:value-of select="GUIDE/LABEL"/>
                                                </xsl:element>
                                        </td>
                                </tr>
                        </table>
                </div>
        </xsl:template>
        <!--
	<xsl:template match="ARTICLE" mode="c_articlelayoutc">
	Description: Presentation of Member reviews
	 -->
        <xsl:template match="ARTICLE" mode="c_articlelayoutc">
                <!-- IMAGE LEFT OF SUBJECT, AUTHOUR, DATE -->
                <div class="generic-m">
                        <xsl:if test="not($current_article_type=2 or $current_article_type=10 or $current_article_type=25)">
                                <!-- ensure box height is fixed when no image appears -->
                                <xsl:attribute name="id">articlepage-d</xsl:attribute>
                        </xsl:if>
                        <xsl:if test="not($current_article_type=2 or $current_article_type=10 or $current_article_type=25 or $current_article_type=16 or $current_article_type=31 )">
                                <div class="articlepage-c">
                                        <img alt="" border="0" height="120" hspace="0" src="{$graphics}reviews/{$article_subtype}{$selected_status}.gif" vspace="5" width="160"/>
                                </div>
                        </xsl:if>
                        <!-- SUBJECT -->
                        <xsl:element name="{$text.heading}" use-attribute-sets="text.heading">
                                <strong>
                                        <xsl:choose>
                                                <xsl:when test="not(SUBJECT='')">
                                                        <xsl:value-of select="SUBJECT"/>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                        <xsl:value-of select="$article_authortype"/>
                                                        <!-- if author type is 'you' we need to make it 'your' -->
                                                        <xsl:if test="$article_authortype='you'">r</xsl:if>
                                                        <xsl:text> </xsl:text>
                                                        <xsl:value-of select="$article_subtype"/>
                                                        <xsl:text> </xsl:text>
                                                        <xsl:value-of select="$article_type_group"/>
                                                </xsl:otherwise>
                                        </xsl:choose>
                                </strong>
                        </xsl:element>
                        <br/>
                        <!-- PAGE ATHOUR AND DATE -->
                        <xsl:element name="{$text.base}" use-attribute-sets="text.base"> by: <xsl:apply-templates mode="c_article" select="ARTICLEINFO/PAGEAUTHOR"
                                        />&nbsp;&nbsp;<xsl:apply-templates mode="collective_med" select="ARTICLEINFO/DATECREATED/DATE"/>
                        </xsl:element>
                        <!-- RATING -->
                        <xsl:if test="contains($article_type_name,'member_review') and /H2G2/ARTICLE/GUIDE/RATING!='no rating'">
                                <xsl:element name="{$text.base}" use-attribute-sets="text.base">
                                        <div class="generic-img">rating: <xsl:apply-templates mode="c_rating" select="."/></div>
                                </xsl:element>
                        </xsl:if>
                        <xsl:if test="not($current_article_type=2)">
                                <br clear="all"/>
                        </xsl:if>
                </div>
        </xsl:template>
        <!--
	<xsl:template match="ARTICLE" mode="r_subscribearticleforum">
	Description: Presentation of the 'subscribe to this article' link
	 -->
        <xsl:template match="ARTICLE" mode="r_subscribearticleforum">
                <xsl:apply-imports/>
                <br/>
        </xsl:template>
        <!--
	<xsl:template match="ARTICLE" mode="r_unsubscribearticleforum">
	Description: Presentation of the 'unsubscribe from this article' link
	 -->
        <xsl:template match="ARTICLE" mode="r_unsubscribearticleforum">
                <xsl:apply-imports/>
        </xsl:template>
        <!--
	<xsl:template match="INTRO" mode="r_articlepage">
	Description: Presentation of article INTRO (not sure where this exists)
	 -->
        <xsl:template match="INTRO" mode="r_articlepage">
                <xsl:apply-templates/>
        </xsl:template>
        <!--
	<xsl:template match="FOOTNOTE" mode="object_articlefootnote">
	Description: Presentation of the footnote object 
	 -->
        <xsl:template match="FOOTNOTE" mode="object_articlefootnote">
                <xsl:apply-imports/>
                <br/>
                <br/>
        </xsl:template>
        <!--
	<xsl:template match="FOOTNOTE" mode="number_articlefootnote">
	Description: Presentation of the numeral within the footnote object
	 -->
        <xsl:template match="FOOTNOTE" mode="number_articlefootnote">
                <xsl:apply-imports/>
        </xsl:template>
        <!--
	<xsl:template match="FOOTNOTE" mode="text_articlefootnote">
	Description: Presentation of the text within the footnote object
	 -->
        <xsl:template match="FOOTNOTE" mode="text_articlefootnote">
                <xsl:apply-imports/>
        </xsl:template>
        <xsl:template match="FOOTNOTE">
                <xsl:apply-imports/>
        </xsl:template>
        <!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
							ARTICLEFORUM Object
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
        <!-- ########### START NEW Alistair Duggin 2005 06 014 ############# -->
        <xsl:template match="ARTICLEFORUM" mode="c_article">
                <xsl:choose>
                        <xsl:when test="/H2G2/ARTICLEFORUM/FORUMTHREADS">
                                <div class="generic-m">
                                        <xsl:element name="{$text.base}" use-attribute-sets="text.base">Read members' comments.</xsl:element>
                                </div>
                                <div class="generic-o">
                                        <xsl:element name="{$text.base}" use-attribute-sets="text.base">
                                                <xsl:apply-templates mode="c_article" select="FORUMTHREADS"/>
                                        </xsl:element>
                                </div>
                                <!-- START A NEW CONVERSATION LINK -->
                                <table border="0" cellpadding="3" cellspacing="0" class="generic-n" width="410">
                                        <tr>
                                                <td class="generic-n-1"></td>
                                                <td align="right" class="generic-n-2" rowspan="2" valign="top"></td>
                                        </tr>
                                        <tr>
                                                <td class="generic-n-1">
                                                        <xsl:if test="/H2G2/ARTICLEFORUM/FORUMTHREADS/@TOTALTHREADS >= 1">
                                                                <xsl:element name="{$text.base}" use-attribute-sets="text.base">
                                                                        <xsl:apply-templates mode="c_viewallthreads" select="/H2G2/ARTICLEFORUM"/>
                                                                </xsl:element>
                                                        </xsl:if>
                                                </td>
                                        </tr>
                                </table>
                                <br/>
                        </xsl:when>
                        <xsl:when test="/H2G2/ARTICLEFORUM/FORUMTHREADPOSTS">
                                <div class="generic-m">
                                        <xsl:element name="{$text.base}" use-attribute-sets="text.base">Read members' comments related to this <xsl:value-of select="$article_subtype"/>.</xsl:element>
                                </div>
                                <xsl:apply-templates mode="r_viewconversation" select="FORUMTHREADPOSTS"/>
                                <xsl:if test="/H2G2/ARTICLEFORUM/FORUMTHREADPOSTS/@TOTALPOSTCOUNT &gt; 10 ">
                                        <div id="moreComentsInConveration">
                                                <xsl:element name="{$text.base}" use-attribute-sets="text.base">
                                                        <xsl:copy-of select="$arrow.right"/>
                                                        <a href="F{/H2G2/ARTICLEFORUM/FORUMTHREADPOSTS/@FORUMID}?thread={/H2G2/ARTICLEFORUM/FORUMTHREADPOSTS/POST/@THREAD}">more comments in this
                                                                conversation</a>
                                                </xsl:element>
                                        </div>
                                </xsl:if>
                                <br/>
                        </xsl:when>
                </xsl:choose>
        </xsl:template>
        <xsl:template match="FORUMTHREADPOSTS" mode="r_viewconversation">
                <xsl:apply-templates mode="r_viewconversation" select="POST"/>
        </xsl:template>
        <xsl:template match="POST" mode="r_viewconversation">
                <xsl:apply-templates mode="t_createanchor" select="@POSTID"/>
                <!-- POST TITLE	 -->
                <div class="multi-title">
                        <table border="0" cellpadding="0" cellspacing="0" width="390">
                                <tr>
                                        <td>
                                                <xsl:element name="{$text.base}" use-attribute-sets="text.base">
                                                        <strong>
                                                                <xsl:apply-templates mode="t_postsubjectmp" select="."/>
                                                        </strong>
                                                </xsl:element>
                                        </td>
                                        <td align="right">
                                                <xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall">
                                                        <span class="orange">
                                                                <span class="bold">post <xsl:value-of select="/H2G2/ARTICLEFORUM/FORUMTHREADPOSTS/@TOTALPOSTCOUNT - @INDEX"/></span>
                                                        </span>
                                                </xsl:element>
                                        </td>
                                </tr>
                        </table>
                </div>
                <div class="posted-by">
                        <xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall">
                                <xsl:if test="@HIDDEN='0'">
                                        <!-- POST INFO -->
                                        <xsl:copy-of select="$m_posted"/>
                                        <xsl:apply-templates mode="c_multiposts" select="USER/USERNAME"/>&nbsp; <xsl:apply-templates mode="c_onlineflagmp" select="USER"/>&nbsp;
                                                <xsl:apply-templates mode="t_postdatemp" select="DATEPOSTED/DATE"/>
                                        <xsl:apply-templates mode="c_gadgetmp" select="."/>
                                </xsl:if>
                        </xsl:element>
                </div>
                <!-- POST BODY -->
                <xsl:element name="{$text.base}" use-attribute-sets="text.base">
                        <xsl:apply-templates mode="t_postbodymp" select="."/>
                </xsl:element>
                <div class="add-comment">
                        <table border="0" cellpadding="0" cellspacing="0" width="390">
                                <tr>
                                        <td valign="top">
                                                <!-- REPLY OR ADD COMMENT -->
                                        </td>
                                        <td align="right">
                                                <!-- COMPLAIN ABOUT THIS POST -->
                                                <xsl:apply-templates mode="c_complainmp" select="@HIDDEN"/>
                                        </td>
                                </tr>
                        </table>
                </div>
                <!-- EDIT AND MODERATION HISTORY -->
                <xsl:if test="$test_IsEditor">
                        <div align="right"><img alt="" border="0" height="17" src="{$imagesource}icons/white/icon_edit.gif" width="17"/>&nbsp; <xsl:element name="{$text.medsmall}"
                                        use-attribute-sets="text.medsmall">
                                        <xsl:apply-templates mode="c_editmp" select="@POSTID"/>
                                        <xsl:text>  </xsl:text> | <xsl:text>  </xsl:text>
                                        <xsl:apply-templates mode="c_linktomoderate" select="@POSTID"/>
                                </xsl:element>
                        </div>
                </xsl:if>
        </xsl:template>
        <!-- ########### END NEW ############# -->
        <!--
	<xsl:template match="ARTICLEFORUM" mode="r_viewallthreads">
	Description: Presentation of the 'view all threads related to this conversation' link
	 -->
        <xsl:template match="ARTICLEFORUM" mode="r_viewallthreads">
                <xsl:copy-of select="$arrow.right"/>
                <xsl:apply-imports/>
        </xsl:template>
        <!--
	<xsl:template match="FORUMTHREADS" mode="empty_article">
	Description: Presentation of the 'Be the first person to talk about this article' link 
	- ie if there are not threads
	 -->
        <xsl:template match="FORUMTHREADS" mode="empty_article">
                <xsl:value-of select="$m_firsttotalk"/>
        </xsl:template>
        <!--
	<xsl:template match="FORUMTHREADS" mode="full_article">
	Description: Presentation of the forum threads if some do indeed exist
	 -->
        <xsl:template match="FORUMTHREADS" mode="full_article">
                <!-- <xsl:value-of select="$m_peopletalking"/> -->
                <xsl:apply-templates mode="c_article" select="THREAD"/>
                <!-- How to create two columned threadlists: -->
                <!--table cellpadding="0" cellspacing="0" border="0">
			<xsl:for-each select="THREAD[position() mod 2 = 1]">
				<tr>
					<td>
					<xsl:apply-templates select="."/>
					</td>
					<td>
					<xsl:apply-templates select="following-sibling::THREAD[1]"/>
					</td>
				</tr>
			</xsl:for-each>
		</table-->
        </xsl:template>
        <!--
 	<xsl:template match="THREAD" mode="r_article">
 	Presentation of each individual thread listed at the bottom of the article
 	-->
        <xsl:template match="THREAD" mode="r_article">
                <table border="0" cellpadding="0" cellspacing="0" width="395">
                        <tr>
                                <td class="myspace-e-3" rowspan="2" width="25">&nbsp;</td>
                                <td class="brown">
                                        <xsl:element name="{$text.base}" use-attribute-sets="text.base">
                                                <xsl:apply-templates mode="t_threadtitlelink" select="@THREADID"/>
                                        </xsl:element>
                                </td>
                        </tr>
                        <tr>
                                <td class="orange">
                                        <div class="posted-by">
                                                <xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall">
                                                        <xsl:value-of select="TOTALPOSTS"/> comments | last comment <xsl:apply-templates mode="t_threaddatepostedlink" select="@THREADID"/>
                                                </xsl:element>
                                        </div>
                                </td>
                        </tr>
                </table>
        </xsl:template>
        <xsl:attribute-set name="maTHREADID_t_threadtitlelink">
                <xsl:attribute name="class">article-title</xsl:attribute>
        </xsl:attribute-set>
        <!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
							ARTICLEINFO Object
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
        <xsl:template match="ARTICLEINFO" mode="r_articlepage">
                <!-- SNIPPETS - for old article type 1 only -->
                <xsl:if test="/H2G2/ARTICLE/GUIDE/FURNITURE[descendant::SNIPPET[not(@VALIGN) and $current_article_type=1]!='']">
                        <div class="generic-m">
                                <table border="0" cellpadding="0" cellspacing="0" width="150">
                                        <xsl:apply-templates mode="c_realmedia" select="/H2G2/ARTICLE/GUIDE/FURNITURE/SNIPPET[not(@VALIGN) and $current_article_type=1]"/>
                                </table>
                        </div>
                        <xsl:copy-of select="$download.realplayer"/>
                </xsl:if>
                <!-- REALTED INFO AND LIKE THIS TRY THIS -->
                <xsl:if test="/H2G2/ARTICLE/GUIDE[descendant::USEFULLINKS!=''] or /H2G2/ARTICLE/GUIDE[descendant::LIKETHIS!='']">
                        <div class="generic-l">
                                <div class="generic-e-DA8A42">
                                        <strong>
                                                <xsl:element name="{$text.subheading}" use-attribute-sets="text.subheading">related info</xsl:element>
                                        </strong>
                                </div>
                                <xsl:if test="/H2G2/ARTICLE/GUIDE/LIKETHIS and not(/H2G2/ARTICLE/GUIDE/LIKETHIS='')">
                                        <div class="generic-v">
                                                <div class="like-this"><img alt="" border="0" height="20" src="{$imagesource}icons/like_this.gif" width="20"/>&nbsp;<xsl:element name="{$text.base}"
                                                                use-attribute-sets="text.base">
                                                                <strong>like this? try this...</strong>
                                                        </xsl:element></div>
                                                <xsl:apply-templates select="/H2G2/ARTICLE/GUIDE/LIKETHIS"/>
                                        </div>
                                </xsl:if>
                                <xsl:if test="/H2G2/ARTICLE/GUIDE/USEFULLINKS and not(/H2G2/ARTICLE/GUIDE/USEFULLINKS='')">
                                        <div class="generic-v">
                                                <div class="like-this"><img alt="" border="0" height="20" src="{$imagesource}icons/useful_links.gif" width="20"/>&nbsp;<xsl:element
                                                                name="{$text.base}" use-attribute-sets="text.base">
                                                                <strong>useful links</strong>
                                                        </xsl:element></div>
                                                <!--  TODO - MUST ERROR CATCH IN FORM this will catch non existant links - hopefully -->
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
                                                                <xsl:when test="starts-with($usefullink,'www') and string-length($usefullink) &gt; 1">
                                                                        <xsl:value-of select="concat('http://', $usefullink)"/>
                                                                </xsl:when>
                                                        </xsl:choose>
                                                </xsl:variable>
                                                <xsl:choose>
                                                        <xsl:when test="$article_type_user='member' and not($article_type_group='feature')">
                                                                <xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall">
                                                                        <a href="{$usefullinkchecked}" id="related" xsl:use-attribute-sets="mLINK">
                                                                                <xsl:apply-templates select="/H2G2/ARTICLE/GUIDE/LINKTITLE"/>
                                                                        </a>
                                                                </xsl:element>
                                                        </xsl:when>
                                                        <xsl:otherwise>
                                                                <xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall">
                                                                        <xsl:apply-templates select="/H2G2/ARTICLE/GUIDE/USEFULLINKS"/>
                                                                </xsl:element>
                                                        </xsl:otherwise>
                                                </xsl:choose>
                                        </div>
                                        <!-- Useful link DICLAIMER -->
                                        <div class="generic-k">
                                                <xsl:element name="{$text.small}" use-attribute-sets="text.small">
                                                        <xsl:value-of select="$coll_usefullinkdisclaimer"/>
                                                </xsl:element>
                                        </div>
                                </xsl:if>
                        </div>
                </xsl:if>
                <xsl:if
                        test="/H2G2/ARTICLE/GUIDE[descendant::SEEALSO!=''] or /H2G2/ARTICLE/GUIDE[descendant::RELATEDREVIEWS!=''] | /H2G2/ARTICLE/GUIDE/FURNITURE[descendant::SNIPPET[@VALIGN='BOTTOM']!=''] or $m_seealso!='' or /H2G2/ARTICLE/GUIDE[descendant::ALSOONBBC!='']">
                        <!-- SEE ALSO BOX -->
                        <div class="generic-l">
                                <div class="generic-e-DA8A42">
                                        <strong>
                                                <xsl:element name="{$text.subheading}" use-attribute-sets="text.subheading">see also</xsl:element>
                                        </strong>
                                </div>
                                <!-- SEE ALSO  -->
                                <xsl:if test="/H2G2/ARTICLE/GUIDE[descendant::SEEALSO!='']">
                                        <!-- TODO move all generic-u to guide ML -->
                                        <div class="generic-v">
                                                <xsl:apply-templates select="/H2G2/ARTICLE/GUIDE/SEEALSO"/>
                                        </div>
                                </xsl:if>
                                <!-- RELATED CONVERSATIONS -->
                                <xsl:if test="/H2G2/ARTICLE/GUIDE[descendant::RELATEDCONVERSATIONS!='']">
                                        <div class="generic-v">
                                                <div class="like-this">
                                                        <xsl:element name="{$text.base}" use-attribute-sets="text.base">
                                                                <strong>related conversations</strong>
                                                        </xsl:element>
                                                </div>
                                                <xsl:apply-templates select="/H2G2/ARTICLE/GUIDE/RELATEDCONVERSATIONS"/>
                                        </div>
                                </xsl:if>
                                <!-- RELATED REVIEWS -->
                                <xsl:if test="/H2G2/ARTICLE/GUIDE[descendant::RELATEDREVIEWS!='']">
                                        <div class="generic-v">
                                                <div class="like-this">
                                                        <xsl:element name="{$text.base}" use-attribute-sets="text.base">
                                                                <strong>related member reviews</strong>
                                                        </xsl:element>
                                                </div>
                                                <xsl:apply-templates select="/H2G2/ARTICLE/GUIDE/RELATEDREVIEWS"/>
                                        </div>
                                </xsl:if>
                                <!-- SEE ALSO LINKS SPECIFIC TO EACH SECTION -->
                                <!-- Alistair removed 05/07/22
			<xsl:if test="not($m_seealso='')">
			<div class="generic-v">
			<xsl:copy-of select="$m_seealso" />
			</div>
			</xsl:if>
			-->
                                <!-- SNIPPETS VALIGN=BOTTOM OLD ARTICLE -->
                                <xsl:if test="/H2G2/ARTICLE/GUIDE/FURNITURE[descendant::SNIPPET[@VALIGN='BOTTOM']!='']">
                                        <div class="generic-v">
                                                <xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall">
                                                        <xsl:apply-templates mode="c_valignbottom" select="/H2G2/ARTICLE/GUIDE/FURNITURE/SNIPPET[@VALIGN='BOTTOM']"/>
                                                </xsl:element>
                                        </div>
                                </xsl:if>
                                <!-- SEE ALSO PROMO -->
                                <xsl:call-template name="SEEALSOPROMO"/>
                                <!-- ALSO ON bbc.co.uk -->
                                <xsl:if test="not(/H2G2/ARTICLE/GUIDE/ALSOONBBC='') and /H2G2/ARTICLE/GUIDE/ALSOONBBC">
                                        <div class="generic-v">
                                                <div class="like-this">
                                                        <xsl:element name="{$text.base}" use-attribute-sets="text.base">
                                                                <strong>also on bbc.co.uk</strong>
                                                        </xsl:element>
                                                </div>
                                                <xsl:apply-templates select="/H2G2/ARTICLE/GUIDE/ALSOONBBC"/>
                                        </div>
                                </xsl:if>
                        </div>
                </xsl:if>
                <!-- SITECONFIG PROMOS -->
                <xsl:call-template name="SITECONFIGPROMOS"/>
        </xsl:template>
        <!-- 
	<xsl:template match="LINKTITLE">
	Use: presentation of an articles's useful link
	-->
        <xsl:template match="LINKTITLE">
                <xsl:choose>
                        <xsl:when test="string-length() &gt; 30">
                                <xsl:value-of select="substring(./text(),1,26)"/>... </xsl:when>
                        <xsl:otherwise>
                                <xsl:value-of select="./text()"/>
                        </xsl:otherwise>
                </xsl:choose>
        </xsl:template>
        <!-- 
	<xsl:template match="STATUS/@TYPE" mode="r_articlestatus">
	Use: presentation of an article's status
	-->
        <xsl:template match="STATUS/@TYPE" mode="r_articlestatus">
                <xsl:copy-of select="$m_status"/>
                <xsl:apply-imports/>
        </xsl:template>
        <!-- 
	<xsl:template match="ENTRY-SUBBED/@VISIBLE" mode="r_returntoeditors">
	Use: presentation of a Return to editors link
	-->
        <xsl:template match="ENTRY-SUBBED/@VISIBLE" mode="r_returntoeditors">
                <b>Return to editors</b>
                <br/>
                <xsl:apply-imports/>
        </xsl:template>
        <!-- 
	<xsl:template match="H2G2ID" mode="r_categoriselink">
	Use: presentation of a 'categorise this article' link
	-->
        <xsl:template match="H2G2ID" mode="r_categoriselink">
                <b>Categorise</b>
                <br/>
                <xsl:apply-imports/>
        </xsl:template>
        <!-- c="H2G2ID" mode="r_removeself">
	Use: presentation of a 'remove my name fromt		
	he authors' link
	-->
        <xsl:template match="H2G2ID" mode="r_removeself">
                <b>Remove self from list</b>
                <br/>
                <xsl:apply-imports/>
        </xsl:template>
        <!--
	<xsl:template match="ARTICLEINFO" mode="r_editbutton">
	Author:		Tom Whitehouse
	Context:      /H2G2/ARTICLE or /H2G2/ARTCLE/ARTICLEINFO
	Purpose:	 Creates the 'Edit this' link
	-->
        <xsl:template match="ARTICLEINFO" mode="r_editbutton">
                <a href="{$root}TypedArticle?aedit=new&amp;h2g2id={H2G2ID}&amp;type={$current_article_type}" xsl:use-attribute-sets="mARTICLE_r_editbutton">
                        <xsl:copy-of select="$m_editentrylinktext"/>
                </a>
        </xsl:template>
        <!-- 
	<xsl:template match="ARTICLEINFO" mode="c_editbutton">
	Use: presentation for the 'create article/review' of edit link
	-->
        <xsl:template match="ARTICLEINFO" mode="c_createbutton">
                <a href="{$root}TypedArticle?acreate=new&amp;type={$current_article_type}" xsl:use-attribute-sets="nc_createnewarticle">
                        <xsl:value-of select="$m_clicknewreview"/>
                        <xsl:value-of select="$article_type_group"/>
                </a>
        </xsl:template>
        <!-- 
	<xsl:template match="ARTICLEINFO" mode="c_addindex">
	Use: add article to the index
	-->
        <xsl:template match="ARTICLEINFO" mode="c_addindex">
                <a href="{$root}TagItem?action=add&amp;tagitemid={/H2G2/ARTICLE/ARTICLEINFO/H2G2ID}&amp;tagitemtype=10&amp;">add to index</a>
        </xsl:template>
        <!-- 
	<xsl:template match="RELATEDMEMBERS" mode="c_relatedmembersAP">
	Use: presentation of all related articles container
	-->
        <xsl:template match="RELATEDMEMBERS" mode="c_relatedmembersAP">
                <xsl:apply-templates mode="c_relatedclubsAP" select="RELATEDCLUBS"/>
                <xsl:apply-templates mode="c_relatedarticlesAP" select="RELATEDARTICLES"/>
        </xsl:template>
        <!-- 
	<xsl:template match="RELATEDARTICLES" mode="r_relatedarticlesAP">
	Use: presentation of the list of related articles container
	-->
        <xsl:template match="RELATEDARTICLES" mode="r_relatedarticlesAP">
                <xsl:apply-templates mode="c_relatedarticlesAP" select="ARTICLEMEMBER"/>
        </xsl:template>
        <!-- 
	<xsl:template match="ARTICLEMEMBER" mode="r_relatedarticlesAP">
	Use: presentation of a single related article
	-->
        <xsl:template match="ARTICLEMEMBER" mode="r_relatedarticlesAP">
                <div>
                        <xsl:apply-imports/>
                </div>
        </xsl:template>
        <!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
							REFERENCES Object
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
        <xsl:template match="REFERENCES" mode="r_articlerefs">
                <b>References</b>
                <br/>
                <xsl:apply-templates mode="c_articlerefs" select="ENTRIES"/>
                <xsl:apply-templates mode="c_articlerefs" select="USERS"/>
                <xsl:apply-templates mode="c_bbcrefs" select="EXTERNAL"/>
                <xsl:apply-templates mode="c_nonbbcrefs" select="EXTERNAL"/>
        </xsl:template>
        <!-- 
	<xsl:template match="ENTRIES" mode="r_articlerefs">
	Use: presentation for the 'List of referenced entries' logical container
	-->
        <xsl:template match="ENTRIES" mode="r_articlerefs">
                <b>
                        <xsl:value-of select="$m_refentries"/>
                </b>
                <br/>
                <xsl:apply-templates mode="c_articlerefs" select="ENTRYLINK"/>
                <br/>
        </xsl:template>
        <!-- 
	<xsl:template match="ENTRYLINK" mode="r_articlerefs">
	Use: presentation of each individual entry link
	-->
        <xsl:template match="ENTRYLINK" mode="r_articlerefs">
                <xsl:apply-imports/>
                <br/>
        </xsl:template>
        <!-- 
	<xsl:template match="REFERENCES/USERS" mode="r_articlerefs">
	Use: presentation of of the 'List of referenced users' logical container
	-->
        <xsl:template match="REFERENCES/USERS" mode="r_articlerefs">
                <b>
                        <xsl:value-of select="$m_refresearchers"/>
                </b>
                <br/>
                <xsl:apply-templates mode="c_articlerefs" select="USERLINK"/>
                <br/>
        </xsl:template>
        <!-- 
	<xsl:template match="USERLINK" mode="r_articlerefs">
	Use: presentation of each individual link to a user in the references section
	-->
        <xsl:template match="USERLINK" mode="r_articlerefs">
                <xsl:apply-imports/>
                <br/>
        </xsl:template>
        <!-- 
	<xsl:template match="REFERENCES/EXTERNAL" mode="r_bbcrefs">
	Use: Presentation of the container listing all bbc references
	-->
        <xsl:template match="REFERENCES/EXTERNAL" mode="r_bbcrefs">
                <b>
                        <xsl:value-of select="$m_otherbbcsites"/>
                </b>
                <br/>
                <xsl:apply-templates mode="c_bbcrefs" select="EXTERNALLINK"/>
                <br/>
        </xsl:template>
        <!-- 
	<xsl:template match="REFERENCES/EXTERNAL" mode="r_nonbbcrefs">
	Use: Presentation of the container listing all external references
	-->
        <xsl:template match="REFERENCES/EXTERNAL" mode="r_nonbbcrefs">
                <b>
                        <xsl:value-of select="$m_refsites"/>
                </b>
                <br/>
                <xsl:apply-templates mode="c_nonbbcrefs" select="EXTERNALLINK"/>
                <br/>
        </xsl:template>
        <!-- 
	<xsl:template match="EXTERNALLINK" mode="r_articlerefsbbc">
	Use: presentation of each individual external link to a BBC page in the references section
	-->
        <xsl:template match="EXTERNALLINK" mode="r_bbcrefs">
                <xsl:apply-imports/>
                <br/>
        </xsl:template>
        <!-- 
	<xsl:template match="EXTERNALLINK" mode="r_articlerefsext">
	Use: presentation of each individual external link to a non-BBC page in the references section
	-->
        <xsl:template match="EXTERNALLINK" mode="r_nonbbcrefs">
                <xsl:apply-imports/>
                <br/>
        </xsl:template>
        <!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
							PAGEAUTHOR Object
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
        <xsl:template match="PAGEAUTHOR" mode="r_article">
                <xsl:apply-templates mode="c_article" select="RESEARCHERS"/>
                <xsl:apply-templates mode="c_article" select="EDITOR"/>
        </xsl:template>
        <!-- 
	<xsl:template match="RESEARCHERS" mode="r_article">
	Use: presentation of the researchers for an article, if they exist
	-->
        <xsl:template match="RESEARCHERS" mode="r_article">
                <xsl:apply-templates mode="c_researcherlist" select="USER"/>
        </xsl:template>
        <!-- 
	<xsl:template match="USER" mode="r_researcherlist">
	Use: presentation of each individual user in the RESEARCHERS section
	-->
        <xsl:template match="USER" mode="r_researcherlist">
                <xsl:apply-imports/>, </xsl:template>
        <!-- 
	<xsl:template match="EDITOR" mode="r_article">
	Use: presentation of the editor of an article
	-->
        <xsl:template match="EDITOR" mode="r_article">
                <xsl:apply-templates mode="c_articleeditor" select="USER"/>
        </xsl:template>
        <!-- 
	<xsl:template match="USER" mode="r_articleeditor">
	Use: presentation of each individual user in the EDITOR section
	-->
        <xsl:template match="USER" mode="r_articleeditor">
                <xsl:apply-imports/>
        </xsl:template>
        <!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
							CRUMBTRAILS Object
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
        <!-- 
	<xsl:template match="CRUMBTRAILS" mode="r_article">
	Use: Presentation of the crumbtrails section
	-->
        <xsl:template match="CRUMBTRAILS" mode="r_article">
                <xsl:apply-templates mode="c_article" select="CRUMBTRAIL"/>
        </xsl:template>
        <!-- 
	<xsl:template match="CRUMBTRAILS" mode="c_crumbremove">
	Use: remove from index
	-->
        <xsl:template match="CRUMBTRAILS" mode="c_crumbremove">
                <!-- REMOVE FROM INDEX -->
                <a href="{$root}tagitem?action=remove&amp;tagitemtype=1&amp;tagitemid={/H2G2/ARTICLE/ARTICLEINFO/H2G2ID}&amp;tagorigin={CRUMBTRAIL/ANCESTOR[position()=last()]/NODEID}"
                        >remove from the index</a>
        </xsl:template>
        <!-- 
	<xsl:template match="CRUMBTRAIL" mode="r_article">
	Use: Presentation of an individual crumbtrail
	-->
        <xsl:template match="CRUMBTRAIL" mode="r_article">
                <xsl:apply-templates mode="c_article" select="ANCESTOR"/>
                <br/>
        </xsl:template>
        <!-- 
	<xsl:template match="ANCESTOR" mode="r_article">
	Use: Presentation of an individual link in a crumbtrail
	-->
        <xsl:template match="ANCESTOR" mode="r_article">
                <xsl:apply-imports/>
                <xsl:if test="following-sibling::ANCESTOR">
                        <xsl:text> / </xsl:text>
                </xsl:if>
        </xsl:template>
        <xsl:template match="ARTICLE" mode="r_categorise"> </xsl:template>
        <xsl:template match="FURNITURE/PICTURE">
                <a>
                        <xsl:apply-templates select="@DNAID | @HREF"/>
                        <img alt="{@ALT}" border="0" height="{@HEIGHT}" src="{$graphics}{@NAME}" width="{@WIDTH}"/>
                </a>
        </xsl:template>
        <xsl:template match="SNIPPET" mode="c_valignbottom">
                <xsl:apply-templates select="BODY/*[not(self::FONT)]"/>
        </xsl:template>
        <xsl:template match="SNIPPET" mode="c_realmedia">
                <!-- realmedia box layout -->
                <tr>
                        <td valign="top">
                                <div class="guideml-c">
                                        <xsl:apply-templates select="ICON"/><xsl:apply-templates select="IMG"/>&nbsp; <font size="2">
                                                <b>
                                                        <xsl:apply-templates select="TEXT"/>
                                                </b>
                                        </font></div>
                        </td>
                        <td valign="top">
                                <div class="snippet">
                                        <xsl:apply-templates select="BODY"/>
                                </div>
                        </td>
                </tr>
        </xsl:template>
        <!--
	<xsl:template name="ARTICLE_HEADER">
	Author:		Andy Harris
	Context:      /H2G2
	Purpose:	 Creates the title for the page which sits in the html header
	-->
        <xsl:template name="ARTICLE_HEADER">
                <xsl:apply-templates mode="header" select=".">
                        <xsl:with-param name="title">
                                <xsl:value-of select="$m_pagetitlestart"/>
                                <xsl:choose>
                                        <xsl:when test="ARTICLE/ARTICLEINFO[HIDDEN='1']">article hidden</xsl:when>
                                        <xsl:when test="ARTICLE/ARTICLEINFO[HIDDEN='2']">
                                                <xsl:copy-of select="$m_articlereferredtitle"/>
                                        </xsl:when>
                                        <xsl:when test="ARTICLE/ARTICLEINFO[HIDDEN='3']">
                                                <xsl:copy-of select="$m_articleawaitingpremoderationtitle"/>
                                        </xsl:when>
                                        <xsl:when test="ARTICLE/ARTICLEINFO[HIDDEN='4']">
                                                <xsl:copy-of select="$m_legacyarticleawaitingmoderationtitle"/>
                                        </xsl:when>
                                        <xsl:when test="/H2G2/ARTICLE/ARTICLEINFO/STATUS[@TYPE='7']">content no longer avaliable</xsl:when>
                                        <xsl:when test="not(/H2G2/ARTICLE/SUBJECT)">
                                                <xsl:copy-of select="$m_nosuchguideentry"/>
                                        </xsl:when>
                                        <xsl:when test="$article_type_group = 'frontpage' and /H2G2[@TYPE='ARTICLE']/ARTICLE/GUIDE/BODY/PAGETITLE">
                                                <xsl:value-of select="/H2G2[@TYPE='ARTICLE']/ARTICLE/GUIDE/BODY/PAGETITLE"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                                <xsl:value-of select="ARTICLE/SUBJECT"/>
                                        </xsl:otherwise>
                                </xsl:choose>
                        </xsl:with-param>
                </xsl:apply-templates>
        </xsl:template>
        <xsl:template name="editorbox">
                <!-- EDITOR BOX - this is not in any of the designs but needs to be there for editord to perfom all the many work arounds....-->
                <xsl:if test="$test_IsEditor">
                        <br/>
                        <br/>
                        <table border="0" cellpadding="5" cellspacing="3" class="generic-n">
                                <tr>
                                        <td class="generic-n-3">
                                                <xsl:element name="{$text.base}" use-attribute-sets="text.base">
                                                        <!-- SELECTED ARTICLE -only see if editor -->
                                                        <h3>For editors only</h3>
                                                        <xsl:if test="not($current_article_type=1)and not($current_article_type=2) and $article_type_user='member'">
                                                                <form action="/dna/collective/TypedArticle" method="post">
                                                                        <input name="_msxml" type="hidden" value="{$memberreviewfields}"/>
                                                                        <input name="s_typedarticle" type="hidden" value="edit"/>
                                                                        <input name="_msstage" type="hidden" value="1"/>
                                                                        <input name="h2g2id" type="hidden" value="{/H2G2/ARTICLE/ARTICLEINFO/H2G2ID}"/>
                                                                        <input name="_msfinish" type="hidden" value="yes"/>
                                                                        <input name="type" type="hidden" value="{$selected_member_type}"/>
                                                                        <input name="title" type="hidden" value="{/H2G2/ARTICLE/SUBJECT}"/>
                                                                        <input name="RATING" type="hidden" value="{/H2G2/ARTICLE/GUIDE/RATING}"/>
                                                                        <input name="HEADLINE" type="hidden" value="{/H2G2/ARTICLE/GUIDE/HEADLINE}"/>
                                                                        <input name="body" type="hidden">
                                                                                <xsl:attribute name="value">
                                                                                        <xsl:apply-templates mode="XML_fragment" select="/H2G2/ARTICLE/GUIDE/BODY/* | /H2G2/ARTICLE/GUIDE/BODY/text()"/>
                                                                                </xsl:attribute>
                                                                        </input>
                                                                        <input name="LINKTITLE" type="hidden" value="{/H2G2/ARTICLE/GUIDE/LINKTITLE}"/>
                                                                        <input name="USEFULLINKS" type="hidden" value="{/H2G2/ARTICLE/GUIDE/USEFULLINKS}"/>
                                                                        <input name="STATUS" type="hidden" value="3"/>
                                                                        <input name="aupdate" type="submit" value="select/deselect this article"/>
                                                                </form>
                                                        </xsl:if>
                                                        <form action="siteconfig" method="post" xsl:use-attribute-sets="fSITECONFIG-EDIT_c_siteconfig">
                                                                <input name="_msxml" type="hidden" value="{$configfields}"/>
                                                                <input type="submit" value="edit siteconfig"/>
                                                        </form>
                                                        <br/>
                                                        <!-- TYPEDARTICLE -->
                                                        <div> Use to go to Typed article After you have set to GuideMl<br/> &nbsp;<img alt="" border="0" height="20"
                                                                        src="{$imagesource}icons/beige/icon_edit.gif" width="20"/><xsl:text>  </xsl:text><a
                                                                        href="{$root}TypedArticle?aedit=new&amp;h2g2id={ARTICLEINFO/H2G2ID}&amp;type={$current_article_type}"
                                                                        xsl:use-attribute-sets="mARTICLE_r_editbutton">
                                                                        <xsl:copy-of select="$m_editentrylinktext"/>
                                                                </a> (TypedArticle) </div>
                                                        <br/>
                                                        <!-- USEREDIT -->
                                                        <div> use to hide or to change to GuideML or to add Editors <br/> &nbsp;<img alt="" border="0" height="20"
                                                                        src="{$imagesource}icons/beige/icon_edit.gif" width="20"/><xsl:text>  </xsl:text><a href="{$root}UserEdit{ARTICLEINFO/H2G2ID}">
                                                                        <xsl:copy-of select="$m_editentrylinktext"/>
                                                                </a> (UserEdit)</div>
                                                </xsl:element>
                                        </td>
                                </tr>
                        </table>
                </xsl:if>
        </xsl:template>
        <xsl:template match="*" mode="XML_fragment">
                <xsl:choose>
                        <xsl:when test="* | text()">
                                <![CDATA[<]]><xsl:value-of select="name()"/><xsl:apply-templates mode="XML_fragment" select="@*"/><![CDATA[>]]>
                                <xsl:apply-templates mode="XML_fragment" select="* | text()"/>
                                <![CDATA[</]]><xsl:value-of select="name()"/><![CDATA[>]]>
                        </xsl:when>
                        <xsl:otherwise>
                                <![CDATA[<]]><xsl:value-of select="name()"/><xsl:apply-templates mode="XML_fragment" select="@*"/><![CDATA[/>]]>
                        </xsl:otherwise>
                </xsl:choose>
        </xsl:template>
        <xsl:template match="@*" mode="XML_fragment">
                <xsl:text> </xsl:text>
                <xsl:value-of select="name()"/><![CDATA[="]]><xsl:value-of select="."/><![CDATA["]]>
        </xsl:template>
</xsl:stylesheet>
