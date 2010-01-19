<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<xsl:import href="../../../base/base-usereditpage.xsl"/>
	
	
	<xsl:template name="USEREDIT_MAINBODY">
	<!-- DEBUG -->
	<xsl:call-template name="TRACE">
	<xsl:with-param name="message">USEREDIT_MAINBODY<xsl:value-of select="$current_article_type" /></xsl:with-param>
	<xsl:with-param name="pagename">usereditpage.xsl</xsl:with-param>
	</xsl:call-template>
	<!-- DEBUG -->
	
	
		<xsl:apply-templates select="INREVEW" mode="c_inreview"/>
		<xsl:apply-templates select="ARTICLE-EDIT-FORM" mode="c_inputform"/>
			
	</xsl:template>

	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
							INREVIEW object
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<!--
	<xsl:template match="INREVIEW" mode="r_inreview">
	Description: Called when the article is currently in a review forum
	 -->
	<xsl:template match="INREVIEW" mode="r_inreview">
		<xsl:copy-of select="$m_inreviewtextandlink"/>
	</xsl:template>
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
						ARTICLE-EDIT-FORM object
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<!--
	<xsl:template match="ARTICLE-EDIT-FORM" mode="r_inputform">
	Description: Presentation of the object holding the Useredit entry form
	 -->
	<xsl:template match="ARTICLE-EDIT-FORM" mode="r_inputform">
	
	<!-- DONT SHOW THE FORM ID USER TYPES IN USEREDIT-->
	<xsl:choose>
	<xsl:when test="H2G2ID=0">
	Please use the new Typed article form to add reviews and pages	
	<a href="{$root}typedarticle">typed article</a>
	</xsl:when>
	<xsl:otherwise>
		
	<!-- STEP1 and 2-->
		<xsl:choose>
		<!-- TODO - what is this leave this alone its a different intro header for the editors! SZ-->	
		<!-- STEP1 EDIT OLD ARTICLE -->
		<xsl:when test="MASTHEAD=0 and not(../ARTICLE-PREVIEW)">
		<xsl:element name="{$text.base}" use-attribute-sets="text.base">
				<h2>step 1: edit a review.</h2><br/>
		</xsl:element>	
		</xsl:when>
		
		<!-- STEP2 EDIT OLD ARTICLE PREVIEW -->
		<xsl:when test="MASTHEAD=0">
			<xsl:element name="{$text.base}" use-attribute-sets="text.base">
				<h2>step 2: preview a review.</h2><br/>
			</xsl:element>	
		</xsl:when>
		</xsl:choose>
	  	  
		<!-- PREVIEW -->
		<xsl:apply-templates select="../ARTICLE-PREVIEW" mode="c_previewarticle"/>
		
		<table  border="0" cellspacing="0" cellpadding="0">
		<tr>
		<xsl:element name="td" use-attribute-sets="column.1">
			<xsl:apply-templates select="." mode="c_form"/>
		<xsl:element name="img" use-attribute-sets="column.spacer.1" />
		</xsl:element>
		
	<xsl:if test="MASTHEAD=1">		
		<xsl:element name="td" use-attribute-sets="column.3">
		<xsl:element name="img" use-attribute-sets="column.spacer.3" /></xsl:element>
		<xsl:element name="td" use-attribute-sets="column.2">
		
		<!-- removed for site pulldown -->
		
		<xsl:if test="$test_IsEditor">
			<xsl:element name="{$text.medium}" use-attribute-sets="text.medium"><div class="rightnavboxheaderhint">HINTS AND TIPS</div></xsl:element>
			<div class="rightnavbox">
			<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
			<xsl:copy-of select="$form.editintro.tips" />
			</xsl:element>
			</div>
			<br/>
		</xsl:if>
			
		<xsl:element name="img" use-attribute-sets="column.spacer.2" />
		</xsl:element>
	</xsl:if>
	
		</tr>
		</table>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!--
	<xsl:template match="ARTICLE-PREVIEW" mode="r_previewarticle">
	Use: Presentation of the preview section when a user is creating an article
	 -->
	<xsl:template match="ARTICLE-PREVIEW" mode="r_previewarticle">
		
		<table width="410" border="0" cellspacing="0" cellpadding="0">
		<tr>
		<td>
		<div class="PageContent">
		<strong><xsl:value-of select="ARTICLE/SUBJECT"/></strong><br />
		<xsl:apply-templates select="ARTICLE/GUIDE/BODY"/>
		<xsl:apply-templates select=".//FOOTNOTE" mode="c_articlefootnote"/>
		</div>
		</td>
		</tr></table>
		
	</xsl:template>

	<!--
	<xsl:template match="ARTICLE-EDIT-FORM" mode="r_form">
	Use: Presentation of the article generation form
	 -->
	<xsl:template match="ARTICLE-EDIT-FORM" mode="r_form">
	<div class="PageContent">
	
	<div class="titleBarNavBgSmall">
	<div class="titleBarNav">
	<xsl:choose>
		<xsl:when test="../ARTICLE-PREVIEW and MASTHEAD=1">
			<xsl:element name="{$text.subheading}" use-attribute-sets="text.subheading">
			<strong class="white">edit</strong>
			</xsl:element>
		</xsl:when>
		<xsl:when test="MASTHEAD=1"><xsl:element name="{$text.medium}" use-attribute-sets="text.medium">REMOVE YOUR INTRO</xsl:element></xsl:when>
	<xsl:otherwise>
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">USEREDIT</xsl:element>
	</xsl:otherwise>
	</xsl:choose>
	</div>
	</div>
	
<!-- 	cant do required files on useredit	<div class="box6">
	<xsl:element name="{$text.small}" use-attribute-sets="text.small">
	<span class="requiredtext">* =required field</span>
	</xsl:element>
	</div> -->
	
	<!-- FORM BOX -->
	<div class="box2">
	<a name="edit" id="edit"></a>
	<xsl:apply-templates select="." mode="c_premodmessage"/>

	<!-- useredit form -->
	<table border="0" cellspacing="0" cellpadding="0">
	<tr><td>
	
	<xsl:if test="$test_IsEditor">
	<xsl:element name="{$text.base}" use-attribute-sets="text.base">
	<label for="useredit-subject"><span class="headinggeneric">SUBJECT</span></label>
	</xsl:element><br/>
	</xsl:if>
	
	
	

	<xsl:element name="{$text.base}" use-attribute-sets="text.base">
	<xsl:choose>
	<xsl:when test="$test_IsEditor">
	<xsl:apply-templates select="." mode="t_subjectbox"/>
	</xsl:when>
	<xsl:otherwise>
	<input size="40" type="hidden" name="subject" value=""/>
	</xsl:otherwise>
	</xsl:choose>
	</xsl:element>
	
	<br/><br/>
	<xsl:if test="$test_IsEditor">
	<xsl:element name="{$text.base}" use-attribute-sets="text.base">
	<label for="useredit-content"><span class="headinggeneric">INTRODUCTION:</span></label>
	</xsl:element>
	
	<br/>
	</xsl:if>
	
	
	<xsl:element name="{$text.base}" use-attribute-sets="text.base">
	<xsl:choose>
	<xsl:when test="$test_IsEditor">
	<xsl:apply-templates select="." mode="t_bodybox"/>
	</xsl:when>
	<xsl:otherwise>
	<input size="40" type="hidden" name="body"  value=""/>
	Click remove to remove your intro.<br/><br/>
	</xsl:otherwise>
	</xsl:choose>
	
	</xsl:element>
	</td></tr>

	<xsl:if test="$test_IsEditor">
	<tr>
	<td colspan="2">
	<br/>
	<!-- CHOICE BETWEEN GUIDEML AND PLAINTEXT -->
	<xsl:apply-templates select="FORMAT" mode="c_guidemlorother"/>
	</td>
	</tr>	
	</xsl:if>
	
	
	<xsl:if test="$test_IsEditor and MASTHEAD=0">
	<tr><td>
	<!-- STATUS -->
	<div><xsl:apply-templates select="STATUS" mode="c_articlestatus"/></div>	
	<!-- EDITORID -->
	<div><xsl:apply-templates select="EDITORID" mode="c_articleeditor"/></div>
	</td></tr>
	
	<tr>
	<td colspan="2">
	<!-- CHOICE BETWEEN GUIDEML AND PLAINTEXT -->
	<xsl:apply-templates select="FORMAT" mode="c_guidemlorother"/>
	</td>
	</tr>
	<tr>
	<td colspan="2">
	<!-- HIDE ARTICLE -->
	<xsl:apply-templates select="FUNCTIONS/HIDE" mode="c_hidearticle"/><br/>
	<xsl:apply-templates select="SUBMITTABLE" mode="c_changesubmittable"/> 
	<br/>
	<br/>
	</td>
	</tr>
	<tr>
	<td colspan="2">
	<!-- RESEARCHER LIST -->
	<div>
	<xsl:apply-templates select="RESEARCHERS/USER-LIST" mode="c_researchers"/>
	</div>
	</td>
	</tr>
	<tr>
	<td colspan="2">
	<!-- EDIT RESEARCHERS -->
	<div>
	<xsl:apply-templates select="RESEARCHERS/USER-LIST" mode="c_editresearchers"/>
	</div>
	</td>
	</tr>
	</xsl:if>

    <tr>
	<td colspan="2" align="right">
		<!-- useredit buttons -->
		<a name="publish" id="publish"></a>
		<!-- removed for site pulldown -->
		<xsl:choose>
		<xsl:when test="$test_IsEditor">
			<xsl:apply-templates select="." mode="t_previewbutton"/>
			<xsl:apply-templates select="FUNCTIONS/ADDENTRY" mode="c_addarticle"/>
			<xsl:apply-templates select="FUNCTIONS/UPDATE" mode="c_updatearticle"/>
			<xsl:apply-templates select="FUNCTIONS/DELETE" mode="c_deletearticle"/>
			<xsl:element name="{$text.base}" use-attribute-sets="text.base">
			<br/><b>Note to editors: The remove button you see has the same function as the old 'PUBLISH' button. ie it will publish the intro if you have text or remove intro if no text in subject and body form.</b>
			</xsl:element>
		</xsl:when>
		<xsl:otherwise>
			<xsl:apply-templates select="FUNCTIONS/UPDATE" mode="c_updatearticle"/>
			<xsl:apply-templates select="FUNCTIONS/DELETE" mode="c_deletearticle"/>
		</xsl:otherwise>
		</xsl:choose>

		
	<br />
	
	<!-- <xsl:apply-templates select="SITEID" mode="c_move-to-site"/> -->
	<br />
	</td>
	</tr>
	</table>

<!-- 	<div>
		<xsl:element name="{$text.base}" use-attribute-sets="text.base">	
		<xsl:copy-of select="$arrow.right" /> <a href="{$root}U{/H2G2/VIEWING-USER/USER/USERID}">go back without editing</a>
		</xsl:element>
	</div> -->
	
	</div>
	
	</div>
	</xsl:template>
	<!--
	<xsl:template match="ARTICLE-EDIT-FORM" mode="user_premodmessage">
	Description: Displayed if the user is pre-moderated
	 -->
	<xsl:template match="ARTICLE-EDIT-FORM" mode="user_premodmessage">
		<xsl:copy-of select="$m_articleuserpremodblurb"/>
	</xsl:template>
	<!--
	<xsl:template match="ARTICLE-EDIT-FORM" mode="article_premodmessage">
	Description: Displayed if the article is premoderated
	 -->
	<xsl:template match="ARTICLE-EDIT-FORM" mode="article_premodmessage">
		<xsl:copy-of select="$m_articlepremodblurb"/>
	</xsl:template>
	<!--
	<xsl:template match="ADDENTRY" mode="r_addarticle">
	Description: Presentation of the 'add article' button
	 -->
	<xsl:template match="ADDENTRY" mode="r_addarticle">
		<xsl:apply-imports/>
	</xsl:template>
	<!--
	<xsl:template match="UPDATE" mode="r_updatearticle">
	Description: Presentation of the 'update article' button
	 -->
	<xsl:template match="UPDATE" mode="r_updatearticle">
		<xsl:apply-imports/>
	</xsl:template>
	<!--
	<xsl:template match="STATUS" mode="r_articlestatus">
	Description: Article status text input box
	 -->
	<xsl:template match="STATUS" mode="r_articlestatus">
		<br/>Status: <xsl:apply-imports/>
	</xsl:template>
	<!--
	<xsl:template match="EDITORID" mode="r_articleeditor">
	Description: Editor of the article's U number text input box
	 -->
	<xsl:template match="EDITORID" mode="r_articleeditor">
		<br/>Editor: <xsl:apply-imports/>
	</xsl:template>
	<!--
	<xsl:template match="FUNCTIONS/HIDE" mode="r_hidearticle">
	Description: Presentation of the 'hide this article' functionality
	 -->
	<xsl:template match="FUNCTIONS/HIDE" mode="r_hidearticle">
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
		<xsl:value-of select="$m_HideEntry"/>
		<xsl:apply-imports/>
	</xsl:element>
	</xsl:template>
	<!--
	<xsl:template match="FORMAT" mode="r_guidemlorother">
	Description: The GuideML / Text choice
	 -->
	<xsl:template match="FORMAT" mode="r_guidemlorother">
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
		<xsl:apply-templates select="." mode="c_formatbuttons"/>
		<xsl:apply-templates select="." mode="t_submitreformat"/>
	</xsl:element>	
	</xsl:template>
	<!--
	<xsl:template match="FORMAT" mode="guideml_formatbuttons">
	Description: Presentation of the GuideML / Text boxes if GuideML is set
	 -->
	<xsl:template match="FORMAT" mode="guideml_formatbuttons">
		<xsl:apply-imports/>
	</xsl:template>
	<!--
	<xsl:template match="FORMAT" mode="text_formatbuttons">
	Description: Presentation of the GuideML / Text boxes if Plain text is set
	 -->
	<xsl:template match="FORMAT" mode="text_formatbuttons">
		<xsl:apply-imports/>
	</xsl:template>
	<!--
	<xsl:template match="SUBMITTABLE" mode="r_changesubmittable">
	Description: Presentation of the 'this article is not for review' checkbox
	 -->
	<xsl:template match="SUBMITTABLE" mode="r_changesubmittable">
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	<div>
	<xsl:apply-imports/>
	<xsl:copy-of select="$m_notforreviewtext"/>
	</div>
	<br/>
	<div><xsl:copy-of select="$m_notforreview_explanation"/></div>
	</xsl:element>
	</xsl:template>
	<!--
	<xsl:template match="HELP" mode="r_helplink">
	Description: Links to 'help with writing this article' with a dynamic href value depending
	on whether GuideML or Plain Text is selected
	 -->
	<xsl:template match="HELP" mode="r_helplink">
		<xsl:apply-imports/>
	</xsl:template>
	<!--
	<xsl:attribute-set name="iSTATUS_r_articlestatus"/>
	Use: Extra Presentation attributes for the article status input box
	 -->
	<xsl:attribute-set name="iSTATUS_r_articlestatus"/>
	<!--
	<xsl:attribute-set name="iEDITORID_r_articleeditor"/>
	Use: Extra Presentation attributes for the Editor's ID input box
	 -->
	<xsl:attribute-set name="iEDITORID_r_articleeditor"/>
	<!--
	<xsl:attribute-set name="sARTICLE-EDIT-FORM_t_selectskin"/>
	Use: Extra Presentation attributes for 'selecting the skin to preview in' submit button
	 -->
	<xsl:attribute-set name="sARTICLE-EDIT-FORM_t_selectskin"/>
	<!--
	<xsl:attribute-set name="oARTICLE-EDIT-FORM_t_selectskin"/>
	Use: Extra Presentation attributes for the drop down options when choosing the skin
	 -->
	<xsl:attribute-set name="oARTICLE-EDIT-FORM_t_selectskin"/>
	<!--
	<xsl:attribute-set name="iSUBMITTABLE_r_changesubmittable"/>
	Use: Extra Presentation attributes for the 'article is not for review' checkbox
	 -->
	<xsl:attribute-set name="iSUBMITTABLE_r_changesubmittable"/>
	<!--
	<xsl:attribute-set name="iFORMAT_t_submitreformat"/>
	Use: Extra Presentation attributes for the GuideML / Plain text submit button
	 -->
	<xsl:attribute-set name="iFORMAT_t_submitreformat"/>
	<!--
	<xsl:attribute-set name="iFORMAT_r_formatbuttons"/>
	Use: Extra Presentation attributes for the GuideML / Plain Text radio boxes
	 -->
	<xsl:attribute-set name="iFORMAT_r_formatbuttons"/>
	<!--
	<xsl:attribute-set name="fARTICLE-EDIT-FORM_c_form"/>
	Use: Extra Presentation attributes for content generation form element
	 -->
	<xsl:attribute-set name="fARTICLE-EDIT-FORM_c_form"/>
	<!--
	<xsl:attribute-set name="iARTICLE-EDIT-FORM_t_subjectbox">
	Use: Extra Presentation attributes for article subject input element
	 -->
	<xsl:attribute-set name="iARTICLE-EDIT-FORM_t_subjectbox">
		<xsl:attribute name="size">40</xsl:attribute>
	</xsl:attribute-set>
	<!--
	<xsl:attribute-set name="iARTICLE-EDIT-FORM_t_bodybox">
	Use: Extra Presentation attributes for article body textarea element
	 -->
	<xsl:attribute-set name="iARTICLE-EDIT-FORM_t_bodybox">
		<xsl:attribute name="cols">
			<xsl:choose>
			<xsl:when test="MASTHEAD=0">95</xsl:when>
			<xsl:otherwise>45</xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>
		<xsl:attribute name="rows">
			<xsl:choose>
			<xsl:when test="MASTHEAD=0">30</xsl:when>
			<xsl:otherwise>20</xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>
		<xsl:attribute name="wrap">virtual</xsl:attribute>
		<xsl:attribute name="id">useredit-content</xsl:attribute>
		<xsl:attribute name="class">
			<xsl:choose>
			<xsl:when test="MASTHEAD=0"></xsl:when>
			<xsl:otherwise>useredit-i</xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>
	
	</xsl:attribute-set>

	<!--
	<xsl:attribute-set name="iARTICLE-EDIT-FORM_t_previewbutton">
	Use: Extra Presentation attributes for the preview article submit button see getwritingbuttons.xsl
	 -->
	<xsl:attribute-set name="iARTICLE-EDIT-FORM_t_previewbutton" use-attribute-sets="form.preview" />
	<!--
	<xsl:attribute-set name="iADDENTRY_r_addarticle">
	Use: Extra Presentation attributes for add entry submit button see getwritingbuttons.xsl
	 -->
	<xsl:attribute-set name="iADDENTRY_r_addarticle"  use-attribute-sets="form.update" />
	<!--
	<xsl:attribute-set name="iUPDATE_r_updatearticle">
	Use: Extra Presentation attributes for update entry submit button see getwritingbuttons.xsl
	 -->
	<xsl:attribute-set name="iUPDATE_r_updatearticle" use-attribute-sets="form.publish" />
	<!--
	<xsl:attribute-set name="iSITEID_t_movetositesubmit"/>
	Use: Extra Presentation attributes for 'move to site' submit button
	 -->
	<xsl:attribute-set name="iSITEID_t_movetositesubmit">
		<xsl:attribute name="type">submit</xsl:attribute>
		<xsl:attribute name="value"><xsl:value-of select="$m_Move"/></xsl:attribute>
	</xsl:attribute-set>
	<!--
	<xsl:attribute-set name="sSITEID_t_movetositelist"/>
	Use: Extra Presentation attributes for 'move to site' select element
	 -->
	<xsl:attribute-set name="sSITEID_t_movetositelist"/>
	<!--
	<xsl:attribute-set name="oSITEID_t_movetositelist"/>
	Use: Extra Presentation attributes for 'move to site' option elements
	 -->
	<xsl:attribute-set name="oSITEID_t_movetositelist"/>
	<!--
	<xsl:attribute-set name="iHIDE_r_hidearticle"/>
	Use: Presentation attributes for the 'hide this entry' tickbox
	 -->
	<xsl:attribute-set name="iHIDE_r_hidearticle"/>
	<!--
	<xsl:template match="SITEID" mode="MoveToSite">
	Use: Presentation of the 'move to site' dropdown list
	 -->
	<xsl:template match="SITEID" mode="r_move-to-site">
				
					<b>
						<xsl:value-of select="$m_MoveToSite"/>
					</b>
					<br/>
					<xsl:value-of select="$m_BelongsToSite"/>
					<xsl:apply-templates select="." mode="t_movetositelist"/>
					<xsl:text> </xsl:text>
					<xsl:apply-templates select="." mode="t_movetositesubmit"/>
				
				<br/>
				<br/>
	</xsl:template>
	<!--
	<xsl:template match="FUNCTIONS/DELETE" mode="Form">
	Use: Presentation of the delete article button
	 -->
	<xsl:template match="FUNCTIONS/DELETE" mode="r_deletearticle">
		<xsl:apply-imports/>
	</xsl:template>
	<!--
	<xsl:attribute-set name="fDELETE_c_deletearticle"/>
	Use: Presentation attributes for the delete article <form> element
	 -->
	<xsl:attribute-set name="fDELETE_c_deletearticle"/>
	<!--
	<xsl:attribute-set name="iDELETE_r_deletearticle"/>
	Use: Extra Presentation attributes for the delete article button
	 -->
	<xsl:attribute-set name="iDELETE_r_deletearticle">
		<xsl:attribute name="type">submit</xsl:attribute>
		<xsl:attribute name="value"><xsl:value-of select="$m_delete"/></xsl:attribute>
		<xsl:attribute name="alt"><xsl:value-of select="$alt_DeleteGE"/></xsl:attribute>
	</xsl:attribute-set>
	<!--
	<xsl:template match="USER-LIST" mode="r_researchers">
	Use: Presentation of the 'List of researchers (authors)'
	 -->
	<xsl:template match="USER-LIST" mode="r_researchers">
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">			
	<b><xsl:copy-of select="$m_ResList"/></b>
	<br/>
	<xsl:apply-templates select="USER" mode="c_showresearcher">
		<xsl:sort select="USERNAME" data-type="text" order="ascending"/>
	</xsl:apply-templates>
	</xsl:element>
	</xsl:template>
	<!--
	<xsl:template match="USER" mode="r_showresearcher">
	Use: Presentation of a single user within the list of researchers
	 -->
	<xsl:template match="USER" mode="r_showresearcher">
		<xsl:apply-imports/>
		<xsl:text> </xsl:text>(U<xsl:value-of select="USERID"/>)<br/>
	</xsl:template>
	<!--
	<xsl:template match="USER-LIST" mode="r_editresearchers">
	Use: Presentation of the editable researchers list
	 -->
	<xsl:template match="USER-LIST" mode="r_editresearchers">
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">			
	<b><xsl:copy-of select="$m_edittheresearcherlisttext"/></b>
	<br/>
	<xsl:apply-templates select="." mode="t_setresearcherscontent"/>
	<br/>
	<xsl:apply-templates select="." mode="t_submitsetresearchers"/>
	<xsl:value-of select="$m_ResListEdit"/>
	
	</xsl:element>
	</xsl:template>
	<!--
	<xsl:template match="USER" mode="r_editresearcher">
	Use: Presentation of individual reserachers within the editable user list
	 -->
	<xsl:template match="USER" mode="r_editresearcher">
		<xsl:apply-imports/>,</xsl:template>
	<!--
	<xsl:attribute-set name="iUSER-LIST_t_submitsetresearchers"/>
	Use: Presentation of the 'set researcher' submit button
	 -->
	<xsl:attribute-set name="iUSER-LIST_t_submitsetresearchers">
		<xsl:attribute name="type">submit</xsl:attribute>
		<xsl:attribute name="value"><xsl:value-of select="$m_SetResearchers"/></xsl:attribute>
	</xsl:attribute-set>
	<!--
	<xsl:attribute-set name="iUSER-LIST_t_setresearcherscontent">
	Use: Presentation for the 'set researcher' <textarea> element 
	 -->
	<xsl:attribute-set name="iUSER-LIST_t_setresearcherscontent">
		<xsl:attribute name="cols">50</xsl:attribute>
		<xsl:attribute name="rows">3</xsl:attribute>
	</xsl:attribute-set>
</xsl:stylesheet>
