<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<xsl:import href="../../../base/base-usereditpage.xsl"/>
	<!--
	USEREDIT_MAINBODY
		insert-usereditpagesubject
		insert-usereditform
			ARTICLE-EDIT-FORM
	-->
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
									Page - Level  template
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<xsl:template name="USEREDIT_MAINBODY">
	
	<!-- DEBUG -->
	<xsl:call-template name="TRACE">
		<xsl:with-param name="message">USEREDIT_MAINBODY</xsl:with-param>
		<xsl:with-param name="pagename">usereditpage.xsl</xsl:with-param>
	</xsl:call-template>
	<!-- DEBUG -->
	
		<table width="100%" cellspacing="0" cellpadding="0" border="0">
			<tr>
				<td class="postmain">
					<xsl:apply-templates select="INREVEW" mode="c_inreview"/>
					<xsl:apply-templates select="ARTICLE-EDIT-FORM" mode="c_inputform"/>
				</td>
			</tr>
			<tr>
				<td colspan="2">
					<br/>
					<font xsl:use-attribute-sets="mainfont">
						<xsl:copy-of select="$m_UserEditHouseRulesDiscl"/>
					</font>
					<br/>
					<br/>
				</td>
			</tr>
		</table>
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
		<xsl:apply-templates select="../ARTICLE-PREVIEW" mode="c_previewarticle"/>
		<table cellpadding="5" cellspacing="0" border="0" width="100%">
			<xsl:apply-templates select="." mode="c_form"/>
			<xsl:apply-templates select="FUNCTIONS/DELETE" mode="c_deletearticle"/>
			<xsl:apply-templates select="SITEID" mode="c_move-to-site"/>
		</table>
	</xsl:template>
	<!--
	<xsl:template match="ARTICLE-PREVIEW" mode="r_previewarticle">
	Use: Presentation of the preview section when a user is creating an article
	 -->
	<xsl:template match="ARTICLE-PREVIEW" mode="r_previewarticle">
		<font size="3">
			<b>Article Preview:</b>
			<br/>
			----------------------------------------------------------------------<br/>
			<b>
				<xsl:value-of select="ARTICLE/SUBJECT"/>
			</b>
			<br/>
		</font>
		<font xsl:use-attribute-sets="mainfont">
			<xsl:apply-templates select="ARTICLE/GUIDE/BODY"/>
			<br/>
			<xsl:apply-templates select=".//FOOTNOTE" mode="c_articlefootnote"/>
			<!-- defined in article.xsl -->
			<br/>
			<br/>
			----------------------------------------------------------------------<br/>
		</font>
		<br/>
		<br/>
	</xsl:template>
	<!--
	<xsl:template match="ARTICLE-EDIT-FORM" mode="r_form">
	Use: Presentation of the article generation form
	 -->
	<xsl:template match="ARTICLE-EDIT-FORM" mode="r_form">
		<tr>
			<td colspan="2">
				<font size="1">
					<xsl:apply-templates select="." mode="c_premodmessage"/>
				</font>
			</td>
		</tr>
		<tr>
			<td width="40%" valign="top">
				<font xsl:use-attribute-sets="mainfont">
					<b>
						<xsl:copy-of select="$m_fsubject"/>
						<br/>
					</b>
					<xsl:apply-templates select="." mode="t_subjectbox"/>
				</font>
			</td>
			<td width="60%" valign="top" class="postside">
				<font xsl:use-attribute-sets="mainfont">
					<xsl:copy-of select="$m_UserEditWarning"/>
				</font>
			</td>
		</tr>
		<tr>
			<td valign="top">
				<font xsl:use-attribute-sets="mainfont">
					<b>
						<xsl:copy-of select="$m_content"/>
						<br/>
					</b>
					<xsl:apply-templates select="." mode="t_bodybox"/>
				</font>
			</td>
			<td valign="top" class="postside">
				<font xsl:use-attribute-sets="mainfont">&nbsp;</font>
			</td>
		</tr>
		<tr>
			<td valign="top">
				<font xsl:use-attribute-sets="mainfont">
					<b>
						<xsl:copy-of select="$m_previewinskin"/>
					</b>
					<br/>
					<xsl:apply-templates select="." mode="t_selectskin"/>&nbsp;	<xsl:apply-templates select="." mode="t_previewbutton"/>
				</font>
			</td>
			<td valign="top" class="postside">
				&nbsp;
			</td>
		</tr>
		<tr>
			<td valign="top">
				<font xsl:use-attribute-sets="mainfont">
					<xsl:apply-templates select="STATUS" mode="c_articlestatus"/>
					<xsl:apply-templates select="EDITORID" mode="c_articleeditor"/>
					<br/>
					<xsl:apply-templates select="FUNCTIONS/HIDE" mode="c_hidearticle"/>
				</font>
			</td>
			<td valign="top" class="postside">&nbsp;</td>
		</tr>
		<xsl:apply-templates select="SUBMITTABLE" mode="c_changesubmittable"/>
		<tr>
			<td valign="top">
				<font xsl:use-attribute-sets="mainfont">
					<xsl:apply-templates select="FORMAT" mode="c_guidemlorother"/>
					<xsl:apply-templates select="." mode="c_makearchive"/>
				</font>
			</td>
			<td valign="top" class="postside">
				<font xsl:use-attribute-sets="mainfont">
					<xsl:apply-templates select="../HELP" mode="c_helplink"/>
				</font>
			</td>
		</tr>
		<xsl:apply-templates select="RESEARCHERS/USER-LIST" mode="c_researchers"/>
		<xsl:apply-templates select="RESEARCHERS/USER-LIST" mode="c_editresearchers"/>
		<tr>
			<td valign="top">
				<font xsl:use-attribute-sets="mainfont">
					<xsl:apply-templates select="FUNCTIONS/ADDENTRY" mode="c_addarticle"/>
					<xsl:apply-templates select="FUNCTIONS/UPDATE" mode="c_updatearticle"/>
				</font>
			</td>
			<td valign="top" class="postside">
				<font xsl:use-attribute-sets="mainfont">
					<xsl:copy-of select="$m_mustsavefirstmessage"/>
				</font>
			</td>
		</tr>
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
		<xsl:value-of select="$m_HideEntry"/>
		<xsl:apply-imports/>
	</xsl:template>
	<!--
	<xsl:template match="FORMAT" mode="r_guidemlorother">
	Description: The GuideML / Text choice
	 -->
	<xsl:template match="FORMAT" mode="r_guidemlorother">
		<xsl:apply-templates select="." mode="c_formatbuttons"/>
		<xsl:apply-templates select="." mode="t_submitreformat"/>
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
		<tr>
			<td width="40%" valign="top">
				<font xsl:use-attribute-sets="mainfont">
					<xsl:apply-imports/>
					<xsl:copy-of select="$m_notforreviewtext"/>
				</font>
			</td>
			<td width="60%" valign="top" class="postside">
				<font xsl:use-attribute-sets="mainfont">
					<xsl:copy-of select="$m_notforreview_explanation"/>
				</font>
			</td>
		</tr>
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
		<xsl:attribute name="cols">50</xsl:attribute>
		<xsl:attribute name="rows">10</xsl:attribute>
		<xsl:attribute name="wrap">virtual</xsl:attribute>
	</xsl:attribute-set>
	<!--
	<xsl:attribute-set name="iARTICLE-EDIT-FORM_t_previewbutton">
	Use: Extra Presentation attributes for the preview article submit button
	 -->
	<xsl:attribute-set name="iARTICLE-EDIT-FORM_t_previewbutton">
		<xsl:attribute name="type">submit</xsl:attribute>
		<xsl:attribute name="value"><xsl:value-of select="$m_preview"/></xsl:attribute>
	</xsl:attribute-set>
	<!--
	<xsl:attribute-set name="iADDENTRY_r_addarticle">
	Use: Extra Presentation attributes for add entry submit button
	 -->
	<xsl:attribute-set name="iADDENTRY_r_addarticle">
		<xsl:attribute name="type">submit</xsl:attribute>
		<xsl:attribute name="title"><xsl:value-of select="$alt_storethis"/></xsl:attribute>
	</xsl:attribute-set>
	<!--
	<xsl:attribute-set name="iUPDATE_r_updatearticle">
	Use: Extra Presentation attributes for update entry submit button
	 -->
	<xsl:attribute-set name="iUPDATE_r_updatearticle">
		<xsl:attribute name="type">submit</xsl:attribute>
		<xsl:attribute name="title"><xsl:value-of select="$m_storechanges"/></xsl:attribute>
	</xsl:attribute-set>
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
	<xsl:attribute-set name="iARTICLE-EDIT-FORM_t_makearchive"/>
	Use: Presentation attributes for the archive radio buttons	 
	-->
	<xsl:attribute-set name="iARTICLE-EDIT-FORM_t_makearchive"/>
	<!--
	<xsl:template match="SITEID" mode="MoveToSite">
	Use: Presentation of the 'move to site' dropdown list
	 -->
	<xsl:template match="SITEID" mode="r_move-to-site">
		<tr>
			<td width="40%" valign="top" post="postmain">
				<font xsl:use-attribute-sets="mainfont">
					<b>
						<xsl:value-of select="$m_MoveToSite"/>
					</b>
					<br/>
					<xsl:value-of select="$m_BelongsToSite"/>
					<xsl:apply-templates select="." mode="t_movetositelist"/>
					<xsl:text> </xsl:text>
					<xsl:apply-templates select="." mode="t_movetositesubmit"/>
				</font>
				<br/>
				<br/>
			</td>
			<td width="60%" valign="top" class="postside">
				<font xsl:use-attribute-sets="mainfont">	&nbsp;</font>
			</td>
		</tr>
	</xsl:template>
	<!--
	<xsl:template match="FUNCTIONS/DELETE" mode="Form">
	Use: Presentation of the delete article button
	 -->
	<xsl:template match="FUNCTIONS/DELETE" mode="r_deletearticle">
		<tr>
			<td width="40%" valign="top">
				<font xsl:use-attribute-sets="mainfont">
					<b>
						<xsl:copy-of select="$m_deletethisentry"/>
					</b>
					<br/>
					<xsl:apply-imports/>
				</font>
			</td>
			<td width="60%" valign="top" class="postside">
				<font xsl:use-attribute-sets="mainfont">
					<xsl:copy-of select="$m_deletebypressing"/>
				</font>
			</td>
		</tr>
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
		<tr>
			<td width="40%" valign="top">
				<font xsl:use-attribute-sets="mainfont">
					<b>
						<xsl:copy-of select="$m_ResList"/>
					</b>
					<br/>
					<xsl:apply-templates select="USER" mode="c_showresearcher">
						<xsl:sort select="USERNAME" data-type="text" order="ascending"/>
					</xsl:apply-templates>
				</font>
			</td>
			<td width="60%" valign="top" class="postside">&nbsp;</td>
		</tr>
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
		<tr>
			<td width="40%" valign="top">
				<font xsl:use-attribute-sets="mainfont">
					<b>
						<xsl:copy-of select="$m_edittheresearcherlisttext"/>
					</b>
					<br/>
					<xsl:apply-templates select="." mode="t_setresearcherscontent"/>
					<br/>
					<xsl:apply-templates select="." mode="t_submitsetresearchers"/>
				</font>
			</td>
			<td width="60%" valign="top" class="postside">
				<font xsl:use-attribute-sets="mainfont">
					<xsl:value-of select="$m_ResListEdit"/>
				</font>
			</td>
		</tr>
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
	<!--
	<xsl:attribute-set name="iUSER-LIST_t_setresearcherscontent">
	Use: Presentation for the archive radio buttons
	 -->
	<xsl:template match="ARTICLE-EDIT-FORM" mode="r_makearchive">
		<br/>Archive? <xsl:apply-templates select="." mode="t_makearchive"/>
		<br/>
	</xsl:template>
</xsl:stylesheet>
