<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet exclude-result-prefixes="msxsl local s dt" version="1.0" xmlns:dt="urn:schemas-microsoft-com:datatypes" xmlns:local="#local-functions" xmlns:msxsl="urn:schemas-microsoft-com:xslt"
        xmlns:s="urn:schemas- microsoft-com:xml-data" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
        <xsl:import href="../../../base/base-addthreadpage.xsl"/>
        <!--
	ADDTHREAD_MAINBODY
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
									Page - Level  template
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
        <xsl:template name="ADDTHREAD_MAINBODY">
                <!-- DEBUG -->
                <xsl:call-template name="TRACE">
                        <xsl:with-param name="message">ADDTHREAD_MAINBODY<xsl:value-of select="$current_article_type"/></xsl:with-param>
                        <xsl:with-param name="pagename">addthreadpage.xsl</xsl:with-param>
                </xsl:call-template>
                <!-- DEBUG -->
                <!-- STEP1,2,3 -->
                <xsl:choose>
                        <xsl:when test="not(POSTTHREADFORM/PREVIEWBODY)">
                                <div class="generic-b">
                                        <table border="0" cellpadding="0" cellspacing="0">
                                                <tr>
                                                        <td>
                                                                <xsl:element name="{$text.subheading}" use-attribute-sets="text.subheading">
                                                                        <strong>step 1: post a new comment</strong>
                                                                </xsl:element>
                                                                <br/>
                                                                <xsl:element name="{$text.base}" use-attribute-sets="text.base">Type your comment in the box below and click "preview" to see what it
                                                                        will look like.</xsl:element>
                                                        </td>
                                                        <td align="right">
                                                                <br/>
                                                                <xsl:if test="POSTTHREADFORM/@INREPLYTO!=0">
                                                                        <a href="#lastread">
                                                                                <xsl:element name="img" use-attribute-sets="anchor.seelastcomments"/>
                                                                        </a>
                                                                </xsl:if>
                                                        </td>
                                                </tr>
                                        </table>
                                </div>
                        </xsl:when>
                        <xsl:otherwise>
                                <div class="generic-b">
                                        <table border="0" cellpadding="0" cellspacing="0">
                                                <tr>
                                                        <td>
                                                                <xsl:element name="{$text.subheading}" use-attribute-sets="text.subheading">
                                                                        <strong>step 2: preview your comment.</strong>
                                                                </xsl:element>
                                                                <br/>
                                                                <xsl:element name="{$text.base}" use-attribute-sets="text.base">Your comment will look like it does below. If you are happy click
                                                                        "publish" otherwise edit it using the boxes below.</xsl:element>
                                                        </td>
                                                        <td align="right">
                                                                <a href="#edit">
                                                                        <xsl:element name="img" use-attribute-sets="anchor.edit"/>
                                                                </a>
                                                                <br/>
                                                                <xsl:if test="POSTTHREADFORM/@INREPLYTO!=0">
                                                                        <a href="#lastread">
                                                                                <xsl:element name="img" use-attribute-sets="anchor.seelastcomments"/>
                                                                        </a>
                                                                </xsl:if>
                                                        </td>
                                                </tr>
                                        </table>
                                </div>
                        </xsl:otherwise>
                </xsl:choose>
                <table border="0" cellpadding="0" cellspacing="0" width="100%">
                        <tr>
                                <xsl:element name="td" use-attribute-sets="column.1">
                                        <xsl:apply-templates mode="c_addthread" select="FORUMSOURCE/ARTICLE/GUIDE/ADDTHREADINTRO"/>
                                        <xsl:apply-templates mode="c_addthread" select="POSTTHREADFORM"/>
                                        <xsl:apply-templates mode="c_addthread" select="POSTTHREADUNREG"/>
                                        <xsl:apply-templates mode="c_addthread" select="POSTPREMODERATED"/>
                                        <xsl:apply-templates mode="c_addthread" select="ERROR"/>
                                        <xsl:element name="img" use-attribute-sets="column.spacer.1"/>
                                </xsl:element>
                                <xsl:element name="td" use-attribute-sets="column.3">
                                        <xsl:element name="img" use-attribute-sets="column.spacer.3"/>
                                </xsl:element>
                                <xsl:element name="td" use-attribute-sets="column.2">
                                        <xsl:attribute name="id">myspace-s-c</xsl:attribute>
                                        <!-- my intro tips heading -->
                                        <div class="myspace-r-a">
                                                <xsl:copy-of select="$myspace.tips.black"/>&nbsp; <xsl:element name="{$text.subheading}" use-attribute-sets="text.subheading">
                                                        <strong class="white">hints &amp; tips</strong>
                                                </xsl:element>
                                        </div>
                                        <xsl:copy-of select="$tips_addcomment"/>
                                        <div class="useredit-u">
                                                <font size="1">
                                                        <xsl:copy-of select="$m_UserEditWarning"/>
                                                        <br/>
                                                        <br/>
                                                        <xsl:copy-of select="$m_UserEditHouseRulesDiscl"/>
                                                </font>
                                        </div>
                                        <xsl:element name="img" use-attribute-sets="column.spacer.2"/>
                                </xsl:element>
                        </tr>
                </table>
        </xsl:template>
        <!-- 
	<xsl:template match="ADDTHREADINTRO" mode="r_addthread">
	Use: Presentation of an introduction to a particular thread - defined in the article XML
	-->
        <xsl:template match="ADDTHREADINTRO" mode="r_addthread">
                <xsl:apply-templates/>
        </xsl:template>
        <!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
						POSTTHREADFORM Object
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
        <!-- 
	<xsl:template match="POSTTHREADFORM" mode="r_addthread">
	Use: The presentation of the form that generates a post. It has a preview area - ie what the post
	will look like when submitted, and a form area.
	-->
        <xsl:template match="POSTTHREADFORM" mode="r_addthread">
                <!-- PREVIEW -->
                <xsl:apply-templates mode="c_preview" select="."/>
                <!-- FORM -->
                <xsl:apply-templates mode="c_form" select="."/>
        </xsl:template>
        <!-- 
	<xsl:template match="POSTTHREADFORM" mode="r_preview">
	Use: The presentation of the preview - this can either be an error or a normal display
	-->
        <xsl:template match="POSTTHREADFORM" mode="r_preview">
                <xsl:apply-templates mode="c_addthread" select="PREVIEWERROR"/>
                <xsl:apply-templates mode="c_previewbody" select="."/>
        </xsl:template>
        <!-- 
	<xsl:template match="PREVIEWERROR" mode="r_addthread">
	Use: presentation of the preview if it is an error
	-->
        <xsl:template match="PREVIEWERROR" mode="r_addthread">
                <xsl:apply-imports/>
        </xsl:template>
        <!-- 
	<xsl:template match="POSTTHREADFORM" mode="r_previewbody">
	Use: presentation of the preview if it is not an error. 
	-->
        <xsl:template match="POSTTHREADFORM" mode="r_previewbody">
                <div class="myspace-b">
                        <xsl:element name="{$text.base}" use-attribute-sets="text.base">
                                <strong>
                                        <xsl:value-of select="SUBJECT"/>
                                </strong>
                                <br/>
                                <br/>
                                <xsl:apply-templates mode="t_addthread" select="PREVIEWBODY"/>
                        </xsl:element>
                </div>
        </xsl:template>
        
        <xsl:template match="POSTTHREADFORM" mode="c_form">
                <xsl:apply-templates mode="r_form" select="."/>
        </xsl:template>
        
        
        <!-- 
	<xsl:template match="POSTTHREADFORM" mode="r_form">
	Use: presentation of the post submission form and surrounding data
	-->
        <xsl:template match="POSTTHREADFORM" mode="r_form">
                <xsl:apply-templates mode="c_premoderationmessage" select="."/>
                <!-- FORM BOX -->
                <a name="edit"/>
                <div class="form-wrapper">
                        <form action="/dna/collective/AddThread" name="theForm" method="post">
                                <xsl:apply-templates mode="c_contententry" select="."/>
                        </form>
                </div>
                <div class="generic-r">
                        <xsl:element name="{$text.base}" use-attribute-sets="text.base">
                                <xsl:copy-of select="$arrow.right"/>
                                <xsl:choose>
                                        <xsl:when test="/H2G2/FORUMSOURCE/@TYPE='privateuser'">
                                                <a xsl:use-attribute-sets="maFORUMID_ReturnToConv">
                                                        <xsl:attribute name="HREF"><xsl:value-of select="$root"/>U<xsl:value-of select="/H2G2/FORUMSOURCE/USERPAGE/USER/USERID"/></xsl:attribute> go
                                                        back without posting </a>
                                        </xsl:when>
                                        <xsl:otherwise>
                                                <a xsl:use-attribute-sets="maFORUMID_ReturnToConv">
                                                        <xsl:attribute name="HREF"><xsl:value-of select="$root"/>F<xsl:value-of select="@FORUMID"/>?thread=<xsl:value-of select="@THREADID"
                                                                        />&amp;post=<xsl:value-of select="@INREPLYTO"/>#p<xsl:value-of select="@INREPLYTO"/></xsl:attribute> go back without posting
                                                </a>
                                        </xsl:otherwise>
                                </xsl:choose>
                        </xsl:element>
                </div>
                <a name="lastread"/>
                <xsl:if test="not(SUBJECT='')">
                        <div class="addthread-a">
                                <xsl:element name="{$text.subheading}" use-attribute-sets="text.subheading">
                                        <strong>the last comment you read was</strong>
                                </xsl:element>
                                <xsl:element name="{$text.base}" use-attribute-sets="text.base">
                                        <br/>
                                        <br/>
                                        <strong class="orange">
                                                <xsl:value-of select="SUBJECT"/>
                                        </strong>
                                        <br/>
                                        <br/>
                                        <xsl:apply-templates mode="c_addthread" select="INREPLYTO"/>
                                </xsl:element>
                        </div>
                </xsl:if>
        </xsl:template>
        <!-- 
	<xsl:template match="POSTTHREADFORM" mode="user_premoderationmessage">
	Use: Executed if the User is being premoderated
	-->
        <xsl:template match="POSTTHREADFORM" mode="user_premoderationmessage">
                <xsl:element name="{$text.base}" use-attribute-sets="text.base">
                        <xsl:copy-of select="$m_userpremodmessage"/>
                </xsl:element>
        </xsl:template>
        <!-- 
	<xsl:template match="POSTTHREADFORM" mode="site_premoderationmessage">
	Use: Executed if the site is under premoderation
	-->
        <xsl:template match="POSTTHREADFORM" mode="site_premoderationmessage">
                <xsl:copy-of select="$m_PostSitePremod"/>
        </xsl:template>
        <!-- 
	<xsl:template match="INREPLYTO" mode="r_addthread">
	Use: presentation of the 'This is a reply to' section, it contains the author and the body of that post
	-->
        <xsl:template match="INREPLYTO" mode="r_addthread">
                <b>
                        <xsl:value-of select="$m_messageisfrom"/>
                </b>
                <xsl:value-of select="USERNAME"/>
                <div>
                        <xsl:apply-templates select="BODY"/>
                </div>
        </xsl:template>
        <!-- 
	<xsl:template match="POSTTHREADFORM" mode="r_contententry">
	Use: presentation of the form input fields
	-->
        <xsl:template match="POSTTHREADFORM" mode="r_contententry">
                <table border="0" cellpadding="0" cellspacing="0" width="390">
                        <tr>
                                <td class="form-label">
                                        <xsl:copy-of select="$icon.step.one"/>
                                        <xsl:element name="{$text.base}" use-attribute-sets="text.base">
                                                <label for="addthread-subject">
                                                        <xsl:value-of select="$m_fsubject"/>
                                                </label>
                                        </xsl:element>
                                </td>
                                <td>
                                        <xsl:apply-templates mode="t_subjectfield" select="."/>
                                </td>
                        </tr>
                        <tr>
                                <td class="form-label" valign="top">
                                        <xsl:copy-of select="$icon.step.two"/>
                                        <xsl:element name="{$text.base}" use-attribute-sets="text.base">
                                                <label for="addthread-body">
                                                        <xsl:value-of select="$m_textcolon"/>
                                                </label>
                                        </xsl:element>
                                </td>
                                <td>
                                        <xsl:apply-templates mode="t_bodyfield" select="."/>
                                </td>
                        </tr>
                        <tr>
                                <td>&nbsp;</td>
                                <td>
                                        <xsl:apply-templates mode="t_previewpost" select="."/>
                                        <xsl:apply-templates mode="t_submitpost" select="."/>
                                </td>
                        </tr>
                </table>
        </xsl:template>
        <!--
	<xsl:attribute-set name="fPOSTTHREADFORM_c_contententry"/>
	Use: presentation attributes on the <form> element
	 -->
        <xsl:attribute-set name="fPOSTTHREADFORM_c_contententry"/>
        <!--
	<xsl:attribute-set name="iPOSTTHREADFORM_t_subjectfield"/>
	Use: Presentation attributes for the subject <input> box
	 -->
        <xsl:attribute-set name="iPOSTTHREADFORM_t_subjectfield">
                <xsl:attribute name="id">addthread-subject</xsl:attribute>
                <xsl:attribute name="size">46</xsl:attribute>
                <xsl:attribute name="maxlength">50</xsl:attribute>
        </xsl:attribute-set>
        <!--
	<xsl:attribute-set name="iPOSTTHREADFORM_Subject"/>
	Use: Presentation attributes for the body <textarea> box
	 -->
        <xsl:attribute-set name="iPOSTTHREADFORM_t_bodyfield">
                <xsl:attribute name="cols">45</xsl:attribute>
                <xsl:attribute name="rows">15</xsl:attribute>
                <xsl:attribute name="wrap">virtual</xsl:attribute>
                <xsl:attribute name="id">addthread-body</xsl:attribute>
        </xsl:attribute-set>
        <!--
	<xsl:attribute-set name="iPOSTTHREADFORM_t_previewpost">
	Use: Presentation attributes for the preview submit button
	 -->
        <xsl:attribute-set name="iPOSTTHREADFORM_t_previewpost" use-attribute-sets="form.preview"/>
        <!--
	<xsl:attribute-set name="iPOSTTHREADFORM_t_submitpost">
	Use: Presentation attributes for the submit button
	 -->
        <xsl:attribute-set name="iPOSTTHREADFORM_t_submitpost" use-attribute-sets="form.publish"/>
        <!--
	<xsl:template match="POSTTHREADUNREG" mode="r_addthread">
	Use: Message displayed if reply is attempted when unregistered
	 -->
        <xsl:template match="POSTTHREADUNREG" mode="r_addthread">
                <xsl:apply-imports/>
        </xsl:template>
        <!--
	<xsl:template match="POSTPREMODERATED" mode="r_addthread">
	Use: Presentation of the 'Post has been premoderated' text
	 -->
        <xsl:template match="POSTPREMODERATED" mode="r_addthread">
                <xsl:call-template name="m_posthasbeenpremoderated"/>
        </xsl:template>
        <!--
	<xsl:template match="ERROR" mode="r_addthread">
	Use: Presentation of error message
	 -->
        <xsl:template match="ERROR" mode="r_addthread">
                <xsl:apply-imports/>
        </xsl:template>
</xsl:stylesheet>
