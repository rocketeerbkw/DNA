<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<xsl:import href="../../../base/base-articlepage.xsl"/>
	
	<!-- Frontpages -->
	<xsl:import href="front3column.xsl"/>
	<xsl:import href="front2column.xsl"/>
	<xsl:import href="articleeditor.xsl"/>

	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
									Page - Level  template
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	
	<xsl:template name="ARTICLE_MAINBODY">
	
	<!-- DEBUG -->
	<xsl:call-template name="TRACE">
	<xsl:with-param name="message"></xsl:with-param>
	<xsl:with-param name="pagename">articlepage.xsl</xsl:with-param>
	</xsl:call-template>
	<!-- DEBUG -->

	<!-- moderation tools -->
	<xsl:apply-templates select="ARTICLE-MODERATION-FORM" mode="c_skiptomod"/>
	<xsl:apply-templates select="ARTICLE-MODERATION-FORM" mode="c_modform"/>
	<!-- <xsl:apply-templates select="/H2G2/ARTICLE/ARTICLEINFO/MODERATIONSTATUS" mode="c_articlepage"/> -->
	<xsl:element name="{$text.base}" use-attribute-sets="text.base">
	<xsl:apply-templates select="ARTICLE" mode="c_unregisteredmessage"/>
	</xsl:element>
	
	<!-- CHOOSE FRONTPAGES -->
	<xsl:choose>
		<!-- review circle and talk page-->
 		<xsl:when test="$layout_type='front3column'">
			<xsl:call-template name="FRONT3COLUMN_MAINBODY" />
		</xsl:when> 
	<!-- write front page -->
		<xsl:when test="$layout_type='front2column'">
			<xsl:call-template name="FRONT2COLUMN_MAINBODY" />
		</xsl:when>
		<!-- write front page -->
		<xsl:when test="$layout_type='articleeditor' or /H2G2/ARTICLE/ARTICLEINFO/STATUS/@TYPE='9' or /H2G2/ARTICLE/ARTICLEINFO/PAGEAUTHOR/EDITOR/USER/GROUPS/GROUP[@NAME='Editor'] and $current_article_type=2">

	<xsl:choose>
	<xsl:when test="PAGEUI/MYHOME[@VISIBLE!=1] and /H2G2/ARTICLE/GUIDE/BODY/REGISTER">
	
	<div class="PageContent">
	<xsl:element name="{$text.base}" use-attribute-sets="text.base">
	You must be registered and signed-in to Get Writing to view this content.  Why not join the community and meet other writers like you? Registration is free and very quick to complete. 
	</xsl:element>
	<br/>
	
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	<div class="arrow2">
	<a href="{$sso_signinlink}">register now</a>
	</div>
	</xsl:element>
	
	</div>
	
	</xsl:when>
	<xsl:otherwise>
	<xsl:call-template name="ARTICLEEDITOR_MAINBODY" />
	</xsl:otherwise>
	</xsl:choose>
				
		</xsl:when>
		<!-- minicourses editor page -->
	<!-- 	<xsl:when test="$current_article_type=50">
			<xsl:call-template name="MINICOURSE_MAINBODY" />
		</xsl:when> -->
		<!-- craft flash pages -->
<!-- 		<xsl:when test="$current_article_type=53">
			<xsl:call-template name="CRAFT_MAINBODY" />
		</xsl:when> -->
		<xsl:otherwise>
		
		<!-- start of table -->
		<xsl:element name="table" use-attribute-sets="html.table.container">
			<tr>
			<xsl:element name="td" use-attribute-sets="column.1">
						
			<!-- this is the article -->
			<div class="PageContent">
			<xsl:apply-templates select="ARTICLE" mode="c_articlepage"/>
			
			
			<!-- 	to work on later SZ		
<xsl:if test="/H2G2/ARTICLE/GUIDE/CHALLENGEDAY = /H2G2/DATE/@DAY and /H2G2/ARTICLE/GUIDE/CHALLENGEMONTH = /H2G2/DATE/@MONTHNAME and /H2G2/ARTICLE/GUIDE/CHALLENGEYEAR = /H2G2/DATE/@YEAR">
			</xsl:if> -->
			
			
			<!-- dont show forum if we have just created article -->
			<xsl:if test="not(/H2G2/ARTICLE/ARTICLEINFO/HIDDEN or /H2G2/ARTICLE/GUIDE/BODY/MYPINBOARD or /H2G2/PARAMS/PARAM[NAME = 's_fromedit']/VALUE = 1 or /H2G2/PARAMS/PARAM[NAME= 's_print']/VALUE = 1)">

			
			<xsl:apply-templates select="ARTICLEFORUM" mode="c_article"/>
			
			
			
			</xsl:if>
			</div>
				
			</xsl:element>
			<xsl:if test="not(/H2G2/PARAMS/PARAM[NAME= 's_print']/VALUE = 1)">
			<xsl:element name="td" use-attribute-sets="column.2">
			<xsl:apply-templates select="ARTICLE/ARTICLEINFO" mode="c_articlepage"/>
			</xsl:element>
			</xsl:if>
			</tr>
		</xsl:element>
		<!-- end of table -->	
		
		</xsl:otherwise>
	</xsl:choose>
	
	<!-- edit box -->
	<xsl:if test="not(/H2G2/PARAMS/PARAM[NAME= 's_print']/VALUE = 1)">
	<xsl:call-template name="editorbox" />
	</xsl:if>
	
	<!-- NOT IN USE
	<xsl:apply-templates select="ARTICLE" mode="c_tag"/>
	<xsl:apply-templates select="/H2G2/CLIP" mode="c_articleclipped"/>
	<xsl:apply-templates select="ARTICLE" mode="c_categorise"/>
	 -->

	</xsl:template>
	<!--
	<xsl:template match="MODERATIONSTATUS" mode="r_articlepage">
	Description: moderation status of the article
	 -->
	<xsl:template match="MODERATIONSTATUS" mode="r_articlepage">
		<xsl:apply-imports/>
	</xsl:template>
	<!--
	<xsl:template match="CLIP" mode="r_articleclipped">
	Description: message to be displayed after clipping an article
	 -->
	<xsl:template match="CLIP" mode="r_articleclipped">
			<xsl:apply-imports/>
	</xsl:template>
	<!--
	<xsl:template match="ARTICLE" mode="r_unregisteredmessage">
	Description: message to be displayed if the viewer is not registered
	 -->
	<xsl:template match="ARTICLE" mode="r_unregisteredmessage">
		<!-- <xsl:copy-of select="$m_unregisteredslug"/> -->
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
		<table bgColor="lightblue" cellspacing="2" cellpadding="2" border="0">
			<tr>
				<td>
				<xsl:apply-imports/>
				</td>
			</tr>
		</table>
	</xsl:template>
	<!--
	<xsl:template match="ARTICLE" mode="add_tag">
	Use: Presentation for the link to add an article to the taxonomy
	 -->
	<xsl:template match="ARTICLE" mode="add_tag">
		<xsl:apply-imports/>
		<br/>
		<br/>
	</xsl:template>
	<!--
	<xsl:template match="ARTICLE" mode="edit_tag">
	Use: Presentation for the link to edit the taxonomy nodes
	 -->
	<xsl:template match="ARTICLE" mode="edit_tag">
		<xsl:apply-imports/>
		<br/>
		<br/>
	</xsl:template>
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
							ARTICLE Object
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<xsl:template match="ARTICLE" mode="c_articlepage">
	<xsl:element name="{$text.base}" use-attribute-sets="text.base">
	<xsl:apply-imports/>
	</xsl:element>
	</xsl:template>
	
	<xsl:template match="ARTICLE" mode="r_articlepage">
	
	<!-- heading -->
	    <div class="heading1">
		<xsl:element name="{$text.heading}" use-attribute-sets="text.heading">
		<xsl:apply-templates select="SUBJECT"/>
		</xsl:element>
		</div>
		
	<!-- printer friendly -->
		<xsl:if test="not(/H2G2/PARAMS/PARAM[NAME='s_type']/VALUE='pop')">
		<div>
		<a href="?s_print=1&amp;s_type=pop" target="printpopup" onClick="printwin(this.href, this.target, 575, 600, 'scroll', 'resize', 'yes'); return false;"><img src="{$graphics}icons/icon_printer.gif" alt="Printer Friendly Version" width="166" height="23" border="0"/></a>
		</div>
		</xsl:if>
		
		<hr class="line"/>
		
		<table width="380" border="0" cellspacing="2" cellpadding="2">
		<tr>
		<td width="50" valign="top">
		<xsl:choose>
			<xsl:when test="$article_type_group='creative'">
				<img src="{$graphics}icons/icon_{$article_subtype}.gif" alt="{$article_type_label}" width="38" height="38" border="0" class="imageborder"/><br/>
				<xsl:element name="{$text.small}" use-attribute-sets="text.small">
				<strong><xsl:value-of select="$article_type_label" /></strong>
			</xsl:element>
			</xsl:when>
			<xsl:otherwise>
				<img src="{$graphics}/icons/icon_{$article_type_group}.gif" alt="{$article_type_group}" width="38" height="38" border="0" class="imageborder"/>
			</xsl:otherwise>
		</xsl:choose>
		</td>
		<td valign="top">
		
		<xsl:element name="{$text.base}" use-attribute-sets="text.base">
		<xsl:if test="$article_type_group!='challenge'">
		<div class="heading4"><strong>Author:</strong>&nbsp;
		<xsl:apply-templates select="ARTICLEINFO/PAGEAUTHOR" mode="c_article"/>
		<xsl:if test="/H2G2/MULTI-STAGE/@TYPE='TYPED-ARTICLE-EDIT-PREVIEW' or /H2G2/MULTI-STAGE/@TYPE='TYPED-ARTICLE-PREVIEW'">
		<xsl:value-of select="/H2G2/VIEWING-USER/USER/USERNAME" />
		</xsl:if>
		</div>
		</xsl:if>
		
		<div class="heading4"><strong>Created:</strong>&nbsp;<xsl:apply-templates select="ARTICLEINFO/DATECREATED/DATE" mode="short2"/></div>
		
		<xsl:if test="$article_type_group='challenge'">
		
		<div class="heading4"><strong>Deadline:</strong>
		<xsl:choose>
		<xsl:when test="GUIDE/NODEADLINE='yes'">no deadline</xsl:when>
		<xsl:otherwise>
		&nbsp;<xsl:value-of select="GUIDE/CHALLENGEDAY"/><xsl:text>  </xsl:text><xsl:value-of select="GUIDE/CHALLENGEMONTH"/><xsl:text> </xsl:text><xsl:value-of select="GUIDE/CHALLENGEYEAR"/>
		</xsl:otherwise>
		</xsl:choose>
		</div>
		
		<div class="heading4"><strong>Word limit:</strong>&nbsp;
		<xsl:apply-templates select="GUIDE/WORDLIMIT"/>
		<xsl:if test="GUIDE/WORDLIMIT=''">none</xsl:if>
		</div>

		</xsl:if>
		</xsl:element>
		</td>
		<td valign="top">
		<xsl:if test="$selected_status='on'">
		<img src="{$graphics}icons/icon_selected.gif" alt="Preview" width="117" height="45" border="0"/>
		</xsl:if>
		
		
		<xsl:if test="/H2G2/MULTI-STAGE/@TYPE='TYPED-ARTICLE-EDIT-PREVIEW' or /H2G2/MULTI-STAGE/@TYPE='TYPED-ARTICLE-PREVIEW'">
		<img src="{$graphics}icons/icon_preview.gif" alt="Preview" width="116" height="40" border="0"/>
		</xsl:if>
		</td>
		</tr>
		</table>
		
		<xsl:if test="not(/H2G2/@TYPE='TYPED-ARTICLE')">
		<!-- submit to peer review -->
		
<!-- 		<xsl:if test="$article_type_group='creative'">
		<xsl:apply-templates select="ARTICLEINFO/SUBMITTABLE" mode="c_submit-to-peer-review"/>
		<xsl:text> </xsl:text>
		</xsl:if> -->
		
		
		<!-- edit button if owner is viewer -->
		<!-- <xsl:apply-templates select="ARTICLEINFO" mode="c_editbutton"/> -->
	
			
		</xsl:if>
		
		<hr class="line"/>
		
		<xsl:apply-templates select="GUIDE/BODY"/>
		<hr class="line"/>
	
	</xsl:template>
	<!--
	<xsl:template match="ARTICLE" mode="r_subscribearticleforum">
	Description: Presentation of the 'subscribe to this article' link
	 -->
	<xsl:template match="ARTICLE" mode="r_subscribearticleforum">
		<div class="arrow1"><xsl:apply-imports/></div>
	</xsl:template>
	<!--
	<xsl:template match="ARTICLE" mode="r_unsubscribearticleforum">
	Description: Presentation of the 'unsubscribe from this article' link
	 -->
	<xsl:template match="ARTICLE" mode="r_unsubscribearticleforum">
		<div class="arrow1"><xsl:apply-imports/></div>
	</xsl:template>
	<!--
	<xsl:template match="INTRO" mode="r_articlepage">
	Description: Presentation of article INTRO (not sure where this exists)
	 -->
	<xsl:template match="INTRO" mode="r_articlepage">
	<xsl:apply-templates/><br/>
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
			<sup>
				<xsl:apply-imports/>
			</sup>
	</xsl:template>
	<!--
	<xsl:template match="FOOTNOTE" mode="text_articlefootnote">
	Description: Presentation of the text within the footnote object
	 -->
	<xsl:template match="FOOTNOTE" mode="text_articlefootnote">
		<xsl:apply-imports/>
	</xsl:template>
	<xsl:template match="FOOTNOTE">
			<sup>
				<xsl:apply-imports/>
			</sup>
	</xsl:template>
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
							ARTICLEFORUM Object
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<xsl:template match="ARTICLEFORUM" mode="r_article">
	

	<xsl:if test="$test_IsEditor"><!-- removed for site pulldown -->
	<xsl:if test="$current_article_type!=44">
	<table width="392" border="0" cellspacing="0" cellpadding="0">
	<tr>
	<td height="25" class="boxactionbottom">
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	<div class="arrow1"><xsl:apply-templates select="/H2G2/ARTICLEFORUM/FORUMTHREADS/@FORUMID" mode="t_addthread"/></div> 
	</xsl:element>
	</td>
	<td class="boxactionbottom">
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	<xsl:choose>
		<xsl:when test="$article_type_group='creative'">
		<div class="arrow1"><a href="RF{$article_reviewforum}">read other <xsl:value-of select="$article_type_label" /></a></div>
		</xsl:when>
		<xsl:when test="$article_type_group='advice'">
		<div class="arrow1"><a href="Index?submit=new&amp;user=on&amp;type=41&amp;let=all">advice index</a></div>
		</xsl:when>
		<xsl:when test="$article_type_group='challenge'">
		<div class="arrow1"><a href="Index?submit=new&amp;user=on&amp;type=42&amp;let=all">challenge index</a></div>
		</xsl:when>
	</xsl:choose>
	</xsl:element>
	</td>
	</tr>
	</table>
	</xsl:if>
	
	<!-- removed for site pulldown --></xsl:if>
	
	<!-- <xsl:if test="THREAD"> --><!-- removed for site pulldown -->
	<xsl:choose>
	<xsl:when test="$article_type_group='creative'">
	<div class="titleBars" id="titleCreative"><xsl:element name="{$text.medium}" use-attribute-sets="text.medium">REVIEW</xsl:element></div>
	</xsl:when>
	<xsl:when test="$article_type_group='advice'">
	<div class="titleBars" id="titleAdvice"><xsl:element name="{$text.medium}" use-attribute-sets="text.medium">COMMENTS</xsl:element></div>
	</xsl:when>
	<xsl:when test="$article_type_group='challenge'">
	<div class="titleBars" id="titleChallenge"><xsl:element name="{$text.medium}" use-attribute-sets="text.medium">JOIN THIS CHALLENGE</xsl:element></div>
	</xsl:when>
<!-- 	<xsl:when test="$article_subtype='talkpage'">
	<div class="talktitlebar">
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium"><xsl:apply-templates select="/H2G2/ARTICLE/SUBJECT"/></xsl:element>
	</div>
	</xsl:when> -->
	<xsl:otherwise>
	<div class="titleBars" id="titleCreative"><xsl:element name="{$text.medium}" use-attribute-sets="text.medium">CONVERSATION</xsl:element></div>
	</xsl:otherwise>
	</xsl:choose>
	

	
	<xsl:apply-templates select="FORUMTHREADS" mode="c_article"/>
	<!-- </xsl:if> --><!-- removed for site pulldown -->


	<xsl:if test="$test_IsEditor"><!-- removed for site pulldown -->
	<table width="392" border="0" cellspacing="0" cellpadding="0">
	<tr>
	<td class="boxactionback">
	<!-- alt_discussthis  -->
	<div class="arrow1">
	
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	<xsl:apply-templates select="/H2G2/ARTICLEFORUM/FORUMTHREADS/@FORUMID" mode="t_addthread"/> 
	</xsl:element>
	
	</div>
	</td>
	<td class="boxactionback">
	<xsl:if test="$article_type_group='creative'">
	<div class="arrow1">
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	<a href="RandomEntry">Find me other work to read</a>
	</xsl:element>
	</div>
	</xsl:if>
	</td>
	</tr>
	</table>
	</xsl:if>


	<xsl:apply-templates select="/H2G2/ARTICLEFORUM" mode="c_viewallthreads"/>
	<br/>
	


	<xsl:if test="$test_IsEditor"><!-- removed for site pulldown -->
	<div class="box">
	<div class="boxback2">
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	Want to know what people  are saying about this work? Be notified of new reviews on your personal space in 'My Conversations'.<br/>
	</xsl:element>
	</div>
	
	<table width="390" border="0" cellspacing="0" cellpadding="0">
	<tr>
	<td class="boxactionback1">
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	<xsl:apply-templates select="/H2G2/ARTICLE" mode="c_subscribearticleforum"/>	
	</xsl:element>
	</td>
	<td class="boxactionback1">
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	<xsl:apply-templates select="/H2G2/ARTICLE" mode="c_unsubscribearticleforum"/>
	</xsl:element>
	</td>
	</tr>
	</table>
	</div>
	<!-- removed for site pulldown --></xsl:if>
		
	</xsl:template>
	<!--
	<xsl:template match="ARTICLEFORUM" mode="r_viewallthreads">
	Description: Presentation of the 'view all threads related to this conversation' link
	 -->
	<xsl:template match="ARTICLEFORUM" mode="r_viewallthreads">
	<div class="boxactionback1">
	<div class="arrow1">
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	<xsl:apply-imports/>
	</xsl:element>
	</div>
	</div>
	</xsl:template>
	<!--
	<xsl:template match="FORUMTHREADS" mode="empty_article">
	Description: Presentation of the 'Be the first person to talk about this article' link 
	- ie if there are not threads
	 -->
	<xsl:template match="FORUMTHREADS" mode="empty_article">
	<div class="boxback">
		<xsl:element name="{$text.base}" use-attribute-sets="text.base">
		<xsl:if test="$test_IsEditor"><!-- removed for site pulldown -->
		<xsl:apply-imports/>
		</xsl:if>
		</xsl:element>
	</div>
	</xsl:template>
	<!--
	<xsl:template match="FORUMTHREADS" mode="full_article">
	Description: Presentation of the forum threads if some do indeed exist
	 -->
	<xsl:template match="FORUMTHREADS" mode="full_article">
	
	<xsl:choose>
	<xsl:when test="$article_type_group='creative'">
	
		<div class="boxback">
		<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
		<xsl:value-of select="$m_peopletalking"/>
		</xsl:element>
		</div>
		<div class="box">
		<table width="390" border="0" cellspacing="0" cellpadding="2">
		<tr>
		<td class="boxheading">
		<xsl:element name="{$text.small}" use-attribute-sets="text.small">
		TITLE
		</xsl:element>
		</td>
		<td class="boxheading">
		<xsl:element name="{$text.small}" use-attribute-sets="text.small">
		LAST REPLY
		</xsl:element>
		</td>
		</tr>
		<xsl:apply-templates select="THREAD" mode="c_article"/>
		</table>
		</div>
		
	</xsl:when>
	<xsl:when test="$article_type_group='advice'">
		<div class="boxback">
		<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
		<xsl:value-of select="$m_advicetext"/>
		</xsl:element>
		</div>
		<div class="box">
		<table width="390" border="0" cellspacing="0" cellpadding="0">
		<tr>
		<td class="boxheading">
		<xsl:element name="{$text.small}" use-attribute-sets="text.small">
		COMMENTS
		</xsl:element>
		</td>
		<td class="boxheading">
		<xsl:element name="{$text.small}" use-attribute-sets="text.small">
		LATEST REPLY
		</xsl:element>
		</td>
		</tr>
		<xsl:apply-templates select="THREAD" mode="c_article"/>
		</table>
		</div>
	</xsl:when>
	<xsl:when test="$article_type_group='challenge'">
		<div class="boxback">
		<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
		<xsl:value-of select="$m_challenge"/>
		</xsl:element>
		</div>
		<div class="box">
		<table width="390" border="0" cellspacing="0" cellpadding="0">
		<tr>
		<td class="boxheading">
		<xsl:element name="{$text.small}" use-attribute-sets="text.small">
		CONVERSATION
		</xsl:element>
		</td>
		<td width="100" class="boxheading">
		<xsl:element name="{$text.small}" use-attribute-sets="text.small">
		LATEST REPLY
		</xsl:element>
		</td>
		</tr>
		<xsl:apply-templates select="THREAD" mode="c_article"/>
		</table>
		</div>
	</xsl:when>
	<xsl:when test="$article_subtype='talkpage'">
		<table width="390" border="0" cellspacing="0" cellpadding="0">
		<tr>
		<td class="boxheading">
		<xsl:element name="{$text.small}" use-attribute-sets="text.small">
		TITLE
		</xsl:element>
		</td>
		<td class="boxheading">
		<xsl:element name="{$text.small}" use-attribute-sets="text.small">
		<xsl:value-of select="$m_lastposting"/>
		</xsl:element>
		</td>
		</tr>
		<xsl:apply-templates select="THREAD" mode="c_article"/>
		</table>
	</xsl:when>
	<xsl:otherwise>
	<div class="box">
		<table width="390" border="0" cellspacing="0" cellpadding="0">
		<tr>
		<td class="boxheading">
		<xsl:element name="{$text.small}" use-attribute-sets="text.small">
		TITLE
		</xsl:element>
		</td>
		<td class="boxheading">
		<xsl:element name="{$text.small}" use-attribute-sets="text.small">
		<xsl:value-of select="$m_lastposting"/>
		</xsl:element>
		</td>
		</tr>
		<xsl:apply-templates select="THREAD" mode="c_article"/>
		</table>
		</div>
	</xsl:otherwise>
	</xsl:choose>
	
	</xsl:template>
	<!--
 	<xsl:template match="THREAD" mode="r_article">
 	Presentation of each individual thread listed at the bottom of the article
 	-->
	<xsl:template match="THREAD" mode="r_article">
	<xsl:choose>
	<xsl:when test="$article_type_group='creative'">
		<tr>
		<xsl:attribute name="class">
		<xsl:choose>
		<xsl:when test="count(preceding-sibling::THREAD) mod 2 = 0">colourbar2</xsl:when>
		<xsl:otherwise>colourbar1</xsl:otherwise>
		</xsl:choose>
		</xsl:attribute>
		<td>
		<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
		REVIEW:<xsl:apply-templates select="@THREADID" mode="t_threadtitlelink"/>
		</xsl:element>
		</td>
		<td>
		<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
		<xsl:apply-templates select="@THREADID" mode="t_threaddatepostedlink"/>
		</xsl:element>
		</td>
		</tr>
	</xsl:when>
	<xsl:when test="$article_type_group='advice' or $article_type_group='challenge'">
		<tr>
		<xsl:attribute name="class">
		<xsl:choose>
		<xsl:when test="count(preceding-sibling::THREAD) mod 2 = 0">colourbar2</xsl:when>
		<xsl:otherwise>colourbar1</xsl:otherwise>
		</xsl:choose>
		</xsl:attribute>
		<td>
		<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
		<xsl:apply-templates select="@THREADID" mode="t_threadtitlelink"/>
		</xsl:element>
		</td>
		<td>
		<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
		<xsl:apply-templates select="@THREADID" mode="t_threaddatepostedlink"/>
		</xsl:element>
		</td>
		</tr>
	</xsl:when>
	<xsl:when test="$article_subtype='talkpage'">
		<tr>
		<xsl:attribute name="class">
		<xsl:choose>
		<xsl:when test="count(preceding-sibling::THREAD) mod 2 = 0">colourbar2</xsl:when>
		<xsl:otherwise>colourbar1</xsl:otherwise>
		</xsl:choose>
		</xsl:attribute>
		<td>
		<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
		<xsl:apply-templates select="@THREADID" mode="t_threadtitlelink"/>
		</xsl:element>
		</td>
		<td>
		<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
		<xsl:apply-templates select="@THREADID" mode="t_threaddatepostedlink"/>
		</xsl:element>
		</td>
		</tr>
	</xsl:when>
	<xsl:otherwise>
			<tr>
		<xsl:attribute name="class">
		<xsl:choose>
		<xsl:when test="count(preceding-sibling::THREAD) mod 2 = 0">colourbar2</xsl:when>
		<xsl:otherwise>colourbar1</xsl:otherwise>
		</xsl:choose>
		</xsl:attribute>
		<td>
		<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
		<xsl:apply-templates select="@THREADID" mode="t_threadtitlelink"/>
		</xsl:element>
		</td>
		<td>
		<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
		<xsl:apply-templates select="@THREADID" mode="t_threaddatepostedlink"/>
		</xsl:element>
		</td>
		</tr>
	</xsl:otherwise>
	</xsl:choose>
	</xsl:template>
	
	<!--
	<xsl:template match="@THREADID" mode="t_threaddatepostedlink">
	Author:		Tom Whitehouse
	Context:      /H2G2/ARTICLEFORUM/FORUMTHREADS/THREAD/@THREADID
	Purpose:	 Creates the date posted link
	-->
	<xsl:template match="@THREADID" mode="t_threaddatepostedlink">
		<a xsl:use-attribute-sets="maTHREADID_t_threaddatepostedlink" href="{$root}F{../../@FORUMID}?thread={.}&amp;latest=1#last">
			<xsl:apply-templates select="../DATEPOSTED"/>
		</a>
	</xsl:template>
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
							ARTICLEINFO Object
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<xsl:template match="ARTICLEINFO" mode="r_articlepage">
	
	<xsl:choose>
	<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_fromedit']/VALUE = 1 and $article_type_group='creative'">
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	<!-- 	<div class="rightnavboxheaderhint">HINTS AND TIPS</div>
		<div class="rightnavbox">
		<xsl:copy-of select="$page.submitreview.tips" />
		</div>-->
		</xsl:element> 
	</xsl:when>
	<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_fromedit']/VALUE = 1 and $article_type_group='advice'">
		<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
		<!-- <div class="rightnavboxheaderhint">HINTS AND TIPS</div>
		<div class="rightnavbox">
		<xsl:copy-of select="$page.submitadvice.tips" />
		</div> -->
		</xsl:element>
	</xsl:when>
	<xsl:when test="$article_type_group='creative'">
		<div class="NavPromoOuter">
	    <div class="NavPromo">
	
		<xsl:element name="{$text.base}" use-attribute-sets="text.base">
		<div class="NavPromoSubHeader">BE A BETTER READER</div>
		Want to learn more about giving feedback to writers
		</xsl:element>
		<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
		<div class="arrow2"><a href="reviewing101">get tips on reviewing</a></div>
		<div class="arrow2"><a href="http://www.bbc.co.uk/learning/coursesearch/get_writing">find a writing course</a></div>
		</xsl:element>
		
		</div>
		</div>


		<xsl:if test="$test_IsEditor"><!-- removed for site pulldown -->
		<div class="rightnavboxheadermore">
		<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
		WANT TO READ MORE
		</xsl:element>
		</div>
		<div class="rightnavbox">
		<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
		<li><a href="{root}shortfiction">Short Fiction</a></li>
		<li><a href="{root}poetry">Poetry</a></li>
		<li><a href="{root}forchildren">For Children</a></li>
		<li><a href="{root}nonfiction">Non-Fiction</a></li>
		<li><a href="{root}dramascripts">Drama Scripts</a></li>
		<li><a href="{root}extendedwork">Extended Work</a></li>
		<li><a href="{root}scifi">Sci-Fi &amp; Fantasy</a></li>
		<li><a href="{root}crimethriller">Crime &amp; Thriller</a></li>
		<li><a href="{root}comedyscripts">Comedy Scripts</a></li>
		</xsl:element>
		</div>
		</xsl:if>
	
		<!-- <xsl:apply-templates select="/H2G2/SITECONFIG/IMGPROMO1" /> -->
		<xsl:apply-templates select="/H2G2/SITECONFIG/IMGPROMO2" />
		<!-- <xsl:apply-templates select="/H2G2/SITECONFIG/IMGPROMO3" /> -->
	
	</xsl:when>
	<xsl:when test="$article_type_group='advice'">	

	<xsl:if test="$test_IsEditor"><!-- removed for site pulldown -->
		<div class="rightnavboxheadermore">
		<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
		WANT TO READ MORE
		</xsl:element>
		</div>
		<div class="rightnavbox">
		<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
		<li><a href="{root}shortfiction">Short Fiction</a></li>
		<li><a href="{root}poetry">Poetry</a></li>
		<li><a href="{root}forchildren">For Children</a></li>
		<li><a href="{root}nonfiction">Non-Fiction</a></li>
		<li><a href="{root}dramascripts">Drama Scripts</a></li>
		<li><a href="{root}extendedwork">Extended Work</a></li>
		<li><a href="{root}scifi">Sci-Fi &amp; Fantasy</a></li>
		<li><a href="{root}crimethriller">Crime &amp; Thriller</a></li>
		<li><a href="{root}comedyscripts">Comedy Scripts</a></li>
		</xsl:element>
		</div>

		</xsl:if>
		<!-- <xsl:apply-templates select="/H2G2/SITECONFIG/IMGPROMO1" /> -->
		<xsl:apply-templates select="/H2G2/SITECONFIG/IMGPROMO2" />
		<!-- <xsl:apply-templates select="/H2G2/SITECONFIG/IMGPROMO3" /> -->
	</xsl:when>
	
	<xsl:when test="$article_type_group='challenge'">	
		<xsl:if test="$test_IsEditor"><!-- removed for site pulldown -->
	
		<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
		<div class="rightnavboxheaderhint">HINTS AND TIPS</div>
		<div class="rightnavbox">
		<xsl:copy-of select="$page.challenge.tips" />
		</div>
		</xsl:element>
		



		
		<xsl:apply-templates select="/H2G2/SITECONFIG/PROMO1" />
    	<xsl:apply-templates select="/H2G2/SITECONFIG/IMGPROMO2" />
		<xsl:apply-templates select="/H2G2/SITECONFIG/IMGPROMO3" />
		</xsl:if>
	</xsl:when>
	
	</xsl:choose>

	

<!-- 	<xsl:copy-of select="$m_idcolon"/> A<xsl:value-of select="H2G2ID"/>
		<xsl:apply-templates select="STATUS/@TYPE" mode="c_articlestatus"/>
 -->
	
<!-- 	<xsl:apply-templates select="." mode="c_editbutton"/>
		<xsl:apply-templates select="/H2G2/ARTICLE" mode="c_clip"/>
		<xsl:apply-templates select="RELATEDMEMBERS" mode="c_relatedmembersAP"/> -->
		
		<!--Editorial Tools-->
<!-- 	<xsl:apply-templates select="/H2G2/PAGEUI/ENTRY-SUBBED/@VISIBLE" mode="c_returntoeditors"/>
		<xsl:apply-templates select="H2G2ID" mode="c_categoriselink"/>
		<xsl:apply-templates select="H2G2ID" mode="c_recommendentry"/> -->
		
		<!-- End of Editorial Tools-->
		
<!-- 		
		<xsl:apply-templates select="REFERENCES" mode="c_articlerefs"/>
		<xsl:apply-templates select="H2G2ID" mode="c_removeself"/> -->
	
		
	</xsl:template>
	<!-- 
	<xsl:template match="STATUS/@TYPE" mode="r_articlestatus">
	Use: presentation of an article's status
	-->
	<xsl:template match="STATUS/@TYPE" mode="r_articlestatus">
		<xsl:copy-of select="$m_status"/>
		<xsl:apply-imports/>
		<br/>
	</xsl:template>
	<!-- 
	<xsl:template match="ENTRY-SUBBED/@VISIBLE" mode="r_returntoeditors">
	Use: presentation of a Return to editors link
	-->
	<xsl:template match="ENTRY-SUBBED/@VISIBLE" mode="r_returntoeditors">
		<b>Return to editors</b>
		<br/>
		<xsl:apply-imports/>
		<br/>
		<br/>
	</xsl:template>
	<!-- 
	<xsl:template match="H2G2ID" mode="r_categoriselink">
	Use: presentation of a 'categorise this article' link
	-->
	<xsl:template match="H2G2ID" mode="r_categoriselink">
		<b>Categorise</b>
		<br/>
		<xsl:apply-imports/>
		<br/>
		<br/>
	</xsl:template>
	<!-- 
	<xsl:template match="H2G2ID" mode="r_removeself">
	Use: presentation of a 'remove my name from the authors' link
	-->
	<xsl:template match="H2G2ID" mode="r_removeself">
		<b>Remove self from list</b>
		<br/>
		<xsl:apply-imports/>
		<br/>
		<br/>
	</xsl:template>
	<!-- 
	<xsl:template match="H2G2ID" mode="r_recommendentry">
	Use: presentation of the 'recommend article' link
	-->
	<xsl:template match="H2G2ID" mode="r_recommendentry">
		<b>Recommend</b>
		<br/>
		<xsl:apply-imports/>
		<br/>
		<br/>
	</xsl:template>
	
		<!--
	<xsl:template match="ARTICLEINFO/SUBMITTABLE" mode="c_submit-to-peer-review">
	Author:		Tom Whitehouse
	Context:      /H2G2/ARTICLE/ARTICLEINFO/SUBMITTABLE
	Purpose:	 Calls the submit for review button container
	-->
	<xsl:template match="ARTICLEINFO/SUBMITTABLE" mode="c_submit-to-peer-review">
		<xsl:if test="not(../HIDDEN) and $ownerisviewer = 1">
			<xsl:apply-templates select="." mode="r_submit-to-peer-review"/>
		</xsl:if>
	</xsl:template>
	
	<!--
	<xsl:template match="ARTICLEINFO/SUBMITTABLE" mode="r_submit-to-peer-review">
	Author:		Tom Whitehouse
	Context:      /H2G2/ARTICLE/ARTICLEINFO/SUBMITTABLE
	Purpose:	 Creates the correct submit for review button 
	-->
	<xsl:template match="ARTICLEINFO/SUBMITTABLE" mode="r_submit-to-peer-review">
		<xsl:param name="submitbutton">
			<xsl:call-template name="m_submitforreviewbutton"/>
		</xsl:param>
		<xsl:param name="notforreviewbutton">
			<xsl:call-template name="m_notforreviewbutton"/>
		</xsl:param>
		<xsl:param name="currentlyinreviewforum">
			<xsl:call-template name="m_currentlyinreviewforum"/>
		</xsl:param>
		<xsl:param name="reviewforum">
			<xsl:call-template name="m_submittedtoreviewforumbutton"/>
		</xsl:param>

	<xsl:variable name="pagetype" select="/H2G2/ARTICLE/EXTRAINFO/TYPE/@ID"/>
	<xsl:variable name="reviewforumid" select="msxsl:node-set($type)/type[@number=$pagetype or @selectnumber=$pagetype]/@reviewforumid"/>

	<!-- If the article is hidden then don't display any of this -->
		<xsl:choose>
			<xsl:when test="@TYPE='YES'">
			<a href="{$root}SubmitReviewForum?action=submitrequest&amp;h2g2id={/H2G2/ARTICLE/ARTICLEINFO/H2G2ID}&amp;s_type={/H2G2/ARTICLE/EXTRAINFO/TYPE/@ID}" xsl:use-attribute-sets="mSUBMITTABLE_r_submit-to-peer-review">
					<xsl:copy-of select="$button.submitreview"/>
				</a>
			</xsl:when>
			<xsl:when test="@TYPE='YES' and /H2G2/PARAMS/PARAM[NAME='s_fromedit']/VALUE=1">
			<p>
			<form method="POST" action="/dna/getwriting/SubmitReviewForum">
			<input type="HIDDEN" name="action" value="submitarticle" />
			<input type="HIDDEN" name="h2g2id" value="{ARTICLE/ARTICLEINFO/H2G2ID}" />
			<input type="hidden" name="reviewforumid" value="$reviewforumid"/>
          
			<strong>Message</strong> leave a intro in the box below
			<br/>
			<textarea cols="45" rows="5" name="response">
			</textarea><br/>
			<input value="Submit Work" type="submit" title="SUBMIT WORK" name="submit"/>
			</form>
			</p>
			</xsl:when>
			<xsl:when test="@TYPE='NO'">
				<xsl:choose>
					<!-- Only show the button for editors-->
					<xsl:when test="/H2G2/VIEWING-USER/USER/GROUPS/EDITOR">
						<a href="{$root}SubmitReviewForum?action=submitrequest&amp;h2g2id={/H2G2/ARTICLE/ARTICLEINFO/H2G2ID}" xsl:use-attribute-sets="mSUBMITTABLE_r_submit-to-peer-review">
							<xsl:copy-of select="$button.submitreview"/>
						</a>
					</xsl:when>
					<xsl:otherwise>
						<xsl:copy-of select="$notforreviewbutton"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="@TYPE='IN' and REVIEWFORUM/@ID != $reviewforumid">
			You have changed the type of this article to <strong><xsl:value-of select="$article_type_label" /></strong> do you want to submit it to the <strong><xsl:value-of select="$article_type_label" /></strong> review or leave it in the <a href="RF{REVIEWFORUM/@ID}" xsl:use-attribute-sets="mSUBMITTABLE_r_submit-to-peer-review">
					<xsl:copy-of select="$reviewforum"/>
				</a> review?<br/><br/>
			</xsl:when>
			<xsl:when test="@TYPE='IN'">
				<xsl:copy-of select="$currentlyinreviewforum"/>
				<a href="RF{REVIEWFORUM/@ID}" >
					<xsl:copy-of select="$reviewforum"/>
				</a>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	
	<!-- 
	<xsl:template match="ARTICLEINFO" mode="r_editbutton">
	Use: presentation for the 'edit article' of edit link
	-->
	<xsl:template match="ARTICLEINFO" mode="r_editbutton">
<!-- 		<a href="{$root}TypedArticle?aedit=new&amp;type={$current_article_type}&amp;h2g2id={H2G2ID}"><xsl:copy-of select="$button.editlarge" />
		</a> -->
	</xsl:template>
	<!-- 
	<xsl:template match="ARTICLE" mode="r_clip">
	Use: presentation for the 'add to clippings' link
	-->
	<xsl:template match="ARTICLE" mode="r_clip">
		<b>Clippings</b>
		<br/>
		<xsl:apply-imports/>
		<br/>
		<br/>
	</xsl:template>
	<!-- 
	<xsl:template match="RELATEDMEMBERS" mode="c_relatedmembersAP">
	Use: presentation of all related articles container
	-->
	<xsl:template match="RELATEDMEMBERS" mode="c_relatedmembersAP">
		<xsl:apply-templates select="RELATEDCLUBS" mode="c_relatedclubsAP"/>
		<xsl:apply-templates select="RELATEDARTICLES" mode="c_relatedarticlesAP"/>
	</xsl:template>
	<!-- 
	<xsl:template match="RELATEDARTICLES" mode="r_relatedarticlesAP">
	Use: presentation of the list of related articles container
	-->
	<xsl:template match="RELATEDARTICLES" mode="r_relatedarticlesAP">
			<b>Related Articles</b>
		<br/>
		<xsl:apply-templates select="ARTICLEMEMBER" mode="c_relatedarticlesAP"/>
		<br/>
		<br/>
	</xsl:template>
	<!-- 
	<xsl:template match="ARTICLEMEMBER" mode="r_relatedarticlesAP">
	Use: presentation of a single related article
	-->
	<xsl:template match="ARTICLEMEMBER" mode="r_relatedarticlesAP">
		<xsl:apply-imports/>
		<br/>
	</xsl:template>
	<!-- 
	<xsl:template match="RELATEDCLUBS" mode="r_relatedclubsAP">
	Use: presentation of the list of related clubs container
	-->
	<xsl:template match="RELATEDCLUBS" mode="r_relatedclubsAP">
			<b>Related Clubs</b>
		<br/>
		<xsl:apply-templates select="CLUBMEMBER" mode="c_relatedclubsAP"/>
		<br/>
		<br/>
	</xsl:template>
	<!-- 
	<xsl:template match="CLUBMEMBER" mode="r_relatedclubsAP">
	Use: presentation of a single related club
	-->
	<xsl:template match="CLUBMEMBER" mode="r_relatedclubsAP">
		<xsl:apply-imports/>
		<br/>
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
		<xsl:apply-templates select="ENTRIES" mode="c_articlerefs"/>
		<xsl:apply-templates select="USERS" mode="c_articlerefs"/>
		<xsl:apply-templates select="EXTERNAL" mode="c_bbcrefs"/>
		<xsl:apply-templates select="EXTERNAL" mode="c_nonbbcrefs"/>
	</xsl:template>
	<!-- 
	<xsl:template match="ENTRIES" mode="r_articlerefs">
	Use: presentation for the 'List of referenced entries' logical container
	-->
	<xsl:template match="ENTRIES" mode="r_articlerefs">
		<xsl:value-of select="$m_refentries"/>
		<br/>
		<xsl:apply-templates select="ENTRYLINK" mode="c_articlerefs"/>
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
			<xsl:value-of select="$m_refresearchers"/>
		<br/>
		<xsl:apply-templates select="USERLINK" mode="c_articlerefs"/>
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
			<xsl:value-of select="$m_otherbbcsites"/>
		<br/>
		<xsl:apply-templates select="EXTERNALLINK" mode="c_bbcrefs"/>
		<br/>
	</xsl:template>
	<!-- 
	<xsl:template match="REFERENCES/EXTERNAL" mode="r_nonbbcrefs">
	Use: Presentation of the container listing all external references
	-->
	<xsl:template match="REFERENCES/EXTERNAL" mode="r_nonbbcrefs">
			<xsl:value-of select="$m_refsites"/>
		<br/>
		<xsl:apply-templates select="EXTERNALLINK" mode="c_nonbbcrefs"/>
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
		<xsl:apply-templates select="RESEARCHERS" mode="c_article"/>
		<xsl:apply-templates select="EDITOR" mode="c_article"/>
		</xsl:template>
	<!-- 
	<xsl:template match="RESEARCHERS" mode="r_article">
	Use: presentation of the researchers for an article, if they exist
	-->
	<xsl:template match="RESEARCHERS" mode="r_article">
			<xsl:apply-templates select="USER" mode="c_researcherlist"/>
	</xsl:template>
	<!-- 
	<xsl:template match="USER" mode="r_researcherlist">
	Use: presentation of each individual user in the RESEARCHERS section
	-->
	<xsl:template match="USER" mode="r_researcherlist">
		<xsl:apply-imports/>
		<br/>
	</xsl:template>
	<!-- 
	<xsl:template match="EDITOR" mode="r_article">
	Use: presentation of the editor of an article
	-->
	<xsl:template match="EDITOR" mode="r_article">
	
		<xsl:apply-templates select="USER" mode="c_articleeditor"/>
	</xsl:template>
	<!-- 
	<xsl:template match="USER" mode="r_articleeditor">
	Use: presentation of each individual user in the EDITOR section
	-->
	<xsl:template match="USER" mode="r_articleeditor">
		<xsl:apply-imports/>
		<br/>
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
		<xsl:apply-templates select="CRUMBTRAIL" mode="c_article"/>
	</xsl:template>
	<!-- 
	<xsl:template match="CRUMBTRAIL" mode="r_article">
	Use: Presentation of an individual crumbtrail
	-->
	<xsl:template match="CRUMBTRAIL" mode="r_article">
		<xsl:apply-templates select="ANCESTOR" mode="c_article"/>
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
	
	<xsl:template match="ARTICLE" mode="r_categorise">
		
	</xsl:template>
	
	<xsl:template name="editorbox">

	<!-- EDITOR BOX - this is not in any of the designs but needs to be there for editord to perfom all the many work arounds....-->
	<xsl:if test="$test_IsEditor">
	<br /><br />
	<div class="editboxheader">For editors only</div>
	<div class="editbox">
	
	<table border="0" cellspacing="2" cellpadding="2">
	<tr>
	<td width="200">
	<a href="{$root}TypedArticle?aedit=new&amp;type={$current_article_type}&amp;h2g2id={/H2G2/ARTICLE/ARTICLEINFO/H2G2ID}"><img src="{$graphics}buttons/button_edittypedarticle.gif" alt="" width="150" height="25" border="0" /></a>
	</td>
	<td><a href="{$root}UserEdit{/H2G2/ARTICLE/ARTICLEINFO/H2G2ID}"><img src="{$graphics}buttons/button_useredit.gif" alt="" width="150" height="25" border="0" /></a>
	</td>
	</tr>
	</table>
	
	<table border="0" cellspacing="2" cellpadding="2">
	<tr>
	<td valign="top">
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	<!-- USEREDIT -->
	<div class="arrow2"><a href="{$root}TypedArticle?acreate=new&amp;type=10">Create a Front Page</a></div>
	<div class="arrow2"><a href="{$root}TypedArticle?acreate=new&amp;type=2">Create a General Article</a></div>
	<div class="arrow2"><a href="{$root}TypedArticle?acreate=new&amp;type=44">Create a Talk Page</a></div>
	<div class="arrow2"><a href="{$root}TypedArticle?acreate=new&amp;type=50">Create a Beginners Minicourses</a></div>
	<div class="arrow2"><a href="{$root}TypedArticle?acreate=new&amp;type=54">Create a Intermediate Mini Course</a></div>
	<div class="arrow2"><a href="{$root}TypedArticle?acreate=new&amp;type=55">Advanced Mini Course</a></div>
	<div class="arrow2"><a href="{$root}TypedArticle?acreate=new&amp;type=60">Create a Minicourse Time table</a></div>
	<div class="arrow2"><a href="{$root}TypedArticle?acreate=new&amp;type=61">Create and Events Calendar</a></div>
	</xsl:element>
	</td>
	<td valign="top">
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	<div class="arrow2"><a href="{$root}TypedArticle?acreate=new&amp;type=53">Create a Flash Craft article</a></div>
	<div class="arrow2"><a href="{$root}TypedArticle?acreate=new&amp;type=56">Create a Text Craft article</a></div>
	<div class="arrow2"><a href="{$root}TypedArticle?acreate=new&amp;type=57">Create a Tools page</a></div>
	<div class="arrow2"><a href="{$root}TypedArticle?acreate=new&amp;type=58">Create a Quiz page</a></div>
	<div class="arrow2"><a href="{$root}TypedArticle?acreate=new&amp;type=43">Create a Competition</a></div>
<div class="arrow2"><a href="{$root}TypedArticle?acreate=new&amp;type=46">Create Competition Rules</a></div>
<div class="arrow2"><a href="{$root}TypedArticle?acreate=new&amp;type=45">Create Competition Winners</a></div>
<div class="arrow2"><a href="{$root}TypedArticle?acreate=new&amp;type=47">Create Competition Winning Entry</a></div>
	</xsl:element>
	</td>
	</tr>
	</table>

	<table border="0" cellspacing="2" cellpadding="2">
	<tr>
	<td width="200" valign="top">
	
	<form method="post" action="siteconfig" xsl:use-attribute-sets="fSITECONFIG-EDIT_c_siteconfig">
<input type="hidden" name="_msxml" value="{$configfields}"/>
<input  type="image" src="{$graphics}buttons/button_editsiteconfig.gif" width="122" height="25" />
	</form>
	</td>
	<td valign="top">
	<xsl:choose>
	<xsl:when test="$article_type_group='creative'and  $current_article_type=1">
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	you need to open this article in typed article to make it and editors pick
	</xsl:element>
	</xsl:when>
	<xsl:when test="$article_type_group='creative'">
	<form method="post" action="/dna/getwriting/TypedArticle">
	<input type="hidden" name="s_typedarticle" value="edit" />
	<input type="hidden" name="_msstage" value="1" />
	<input type="hidden" name="h2g2id" value="{/H2G2/ARTICLE/ARTICLEINFO/H2G2ID}" />
	<input type="hidden" name="_msfinish" value="yes" />
	<input type="hidden" name="s_selected" value="yes" />
	<input type="hidden" name="type" value="{$selected_member_type}" />
	<input type="hidden" name="title" value="{/H2G2/ARTICLE/SUBJECT}" />
	<input type="hidden" name="body">
	<xsl:attribute name="value">
	<xsl:apply-templates select="/H2G2/ARTICLE/GUIDE/BODY/* | /H2G2/ARTICLE/GUIDE/BODY/text()" mode="XML_fragment" />
	</xsl:attribute>
	</input>
	<input type="hidden" name="STATUS" value="3" />
	<input type="image" name="aupdate" src="{$graphics}buttons/button_select.gif" width="150" height="25"/>
	</form>
	

	</xsl:when>
	<xsl:otherwise></xsl:otherwise>
	</xsl:choose>

	</td>
	</tr>
	</table>
	
	<table>
	<tr>
	<td>

	<div class="arrow2">
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	<a href="{$root}NamedArticles">Named Articles</a>
	</xsl:element>
	</div>
	
	<div class="arrow2">
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	<a href="{$root}editreview?action=addnew">Create a review Circle</a>
	</xsl:element>
	</div>
	
	<div class="arrow2">
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	<a href="{$root}inspectuser">Edit user (inspectuser)</a>
	</xsl:element>
	</div>
	
	<div class="arrow2">
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	<a href="{$root}siteadmin">Site Admin</a>
	</xsl:element>
	</div>
	
		<div class="arrow2">
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	<a href="{$root}clublist">all clubs on Getwriting</a>
	</xsl:element>
	</div>
	
	</td></tr>
	</table>
	</div>
	
	
	
	<!-- 
	other useful commands
	
	editreview?action=addnew
	EditReview?id=18
	inspectuser
	namedarticles
	siteadmin
	
	
	 -->
	</xsl:if>

</xsl:template>
	<xsl:template match="*" mode="XML_fragment">
		<xsl:choose>
			<xsl:when test="* | text()">
				<![CDATA[<]]><xsl:value-of select="name()"/><xsl:apply-templates select="@*" mode="XML_fragment"/><![CDATA[>]]>
				<xsl:apply-templates select="* | text()" mode="XML_fragment"/>
				<![CDATA[</]]><xsl:value-of select="name()"/><![CDATA[>]]>
			</xsl:when>
			<xsl:otherwise>
				<![CDATA[<]]><xsl:value-of select="name()"/><xsl:apply-templates select="@*" mode="XML_fragment"/><![CDATA[/>]]>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
		<xsl:template match="@*" mode="XML_fragment">
		<xsl:text> </xsl:text>
		<xsl:value-of select="name()"/><![CDATA[="]]><xsl:value-of select="."/><![CDATA["]]>
	</xsl:template>

</xsl:stylesheet>
