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
		Page - Level  template
	-->

	<xsl:template name="USEREDIT_MAINBODY">
		<!-- DEBUG -->
		<xsl:call-template name="TRACE">
		<xsl:with-param name="message">USEREDIT_MAINBODY test variable = <xsl:value-of select="$current_article_type" /></xsl:with-param>
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
	<xsl:element name="{$text.base}" use-attribute-sets="text.base">
	Please use the new Typed article form to add reviews and pages<br/><br/>
	
	If you've arrived at this page you will need to return to your "<a href="U{/H2G2/VIEWING-USER/USER/USERID}">personal space</a>" and follow the relevant link from there.  Sorry for this inconvenience.
		
	</xsl:element>
	<br/><br/>
	
	 <!-- CREATE A NEW REVIEW -->
			<div class="myspace-u">
			<div class="myspace-r">	
			<xsl:apply-templates select="/H2G2/SITECONFIG/WRITEREVIEW" />
			</div>
			</div>
			<br />
	<!-- CREATE A NEW PAGE -->
			<div class="myspace-u">
			<div class="myspace-r">	
			<xsl:apply-templates select="/H2G2/SITECONFIG/CREATEPAGE" />
			</div>
			</div>
			<br />
			
				<div class="myspace-u">
				<div class="myspace-r">		
					<!-- my intro tools -->			
					<xsl:copy-of select="$myspace.tools" />&nbsp;
					<xsl:element name="{$text.subheading}" use-attribute-sets="text.subheading">
						<strong class="white">my space tools</strong>
					</xsl:element>

					<xsl:element name="{$text.base}" use-attribute-sets="text.base">
					<!-- edit screen name -->
					<div class="myspace-v"><xsl:copy-of select="$arrow.right" /><a href="{$root}UserDetails">Edit my screenname</a></div>
					</xsl:element>
				</div></div>
			
	
	</xsl:when>
	<xsl:otherwise>
		
	<!-- STEP1 and 2-->
	
		<xsl:choose>


		<!-- STEP1 EDIT INTRO -->
		<xsl:when test="MASTHEAD=1 and not(../ARTICLE-PREVIEW)">

			<div class="generic-c">
				<xsl:call-template name="box.crumb">
					<xsl:with-param name="box.crumb.href" select="concat($root,'U',/H2G2/VIEWING-USER/USER/USERID)" />
					<xsl:with-param name="box.crumb.value">my space</xsl:with-param>
					<xsl:with-param name="box.crumb.title">edit introduction</xsl:with-param>
				</xsl:call-template>
			</div>

			<xsl:call-template name="box.heading">
				<xsl:with-param name="box.heading.value" select="/H2G2/VIEWING-USER/USER/USERNAME" />
			</xsl:call-template>

			<xsl:call-template name="box.step">
				<xsl:with-param name="box.step.title">step 1: write an introduction.</xsl:with-param>
				<xsl:with-param name="box.step.text">Use the boxes below to write an introduction about yourself. Don't include anything that you wouldn't want other members to see.</xsl:with-param>
			</xsl:call-template>

		</xsl:when>
		



		<!-- STEP2 EDIT INTRO PREVIEW -->
		<xsl:when test="MASTHEAD=1">

			<div class="generic-c">
				<xsl:call-template name="box.crumb">
					<xsl:with-param name="box.crumb.href" select="concat($root,'U',/H2G2/VIEWING-USER/USER/USERID)" />
					<xsl:with-param name="box.crumb.value">my space</xsl:with-param>
					<xsl:with-param name="box.crumb.title" select="0" />
				</xsl:call-template>
				<xsl:call-template name="box.crumb">
					<xsl:with-param name="box.crumb.href">#edit</xsl:with-param>
					<xsl:with-param name="box.crumb.value">edit introduction</xsl:with-param>
					<xsl:with-param name="box.crumb.title">preview</xsl:with-param>
				</xsl:call-template>
			</div>

			<xsl:call-template name="box.heading">
				<xsl:with-param name="box.heading.value" select="/H2G2/VIEWING-USER/USER/USERNAME" />
			</xsl:call-template>

			<div class="generic-b">
				<table cellpadding="0" cellspacing="0" border="0">
				<tr><td>
					<xsl:element name="{$text.subheading}" use-attribute-sets="text.subheading"><strong>step 2: preview introduction.</strong></xsl:element><br />
					<xsl:element name="{$text.base}" use-attribute-sets="text.base">you are happy click "publish" otherwise edit your introduction using the boxes below and click "preview" again.</xsl:element>
				</td><td>
					<a href="#edit"><xsl:element name="img" use-attribute-sets="anchor.edit" /></a><br /><a href="#publish"><xsl:element name="img" use-attribute-sets="anchor.publish" /></a>
				</td></tr></table>					
			</div>
		</xsl:when>
	

		<!-- TODO - what is this leave this alone its a different intro header for the editors! SZ-->	
		<!-- STEP1 EDIT OLD ARTICLE -->
		<xsl:when test="MASTHEAD=0 and not(../ARTICLE-PREVIEW)">
			<xsl:call-template name="box.step">
				<xsl:with-param name="box.step.title">step 1: edit a review.</xsl:with-param>
				<xsl:with-param name="box.step.text">this is an old style review.</xsl:with-param>
			</xsl:call-template>
		</xsl:when>
		
		<!-- STEP2 EDIT OLD ARTICLE PREVIEW -->
		<xsl:when test="MASTHEAD=0">

			<xsl:call-template name="box.step">
				<xsl:with-param name="box.step.title">step 2: preview a review.</xsl:with-param>
				<xsl:with-param name="box.step.text">this is an old style review.</xsl:with-param>
			</xsl:call-template>

		</xsl:when>

		</xsl:choose>
	  	  
		<!-- PREVIEW -->
		<xsl:apply-templates select="../ARTICLE-PREVIEW" mode="c_previewarticle"/>

		<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
		<xsl:element name="td" use-attribute-sets="column.1">
			<xsl:apply-templates select="." mode="c_form"/>
		<xsl:element name="img" use-attribute-sets="column.spacer.1" />
		</xsl:element>
		
	<xsl:if test="MASTHEAD=1">		
		<xsl:element name="td" use-attribute-sets="column.3"><xsl:element name="img" use-attribute-sets="column.spacer.3" /></xsl:element>
		<xsl:element name="td" use-attribute-sets="column.2">
			<xsl:attribute name="id">myspace-s-c</xsl:attribute>

			<!-- my intro tips heading -->
			<div class="myspace-r-a">
				<xsl:copy-of select="$myspace.tips.black" />&nbsp;
				<xsl:element name="{$text.subheading}" use-attribute-sets="text.subheading">
					<strong class="white">hints &amp; tips</strong>
				</xsl:element>
			</div>
			<xsl:copy-of select="$tips_editintro" />
			<div class="useredit-u">
				<font size="1">
					<xsl:copy-of select="$m_UserEditWarning"/><br /><br />
					<xsl:copy-of select="$m_UserEditHouseRulesDiscl"/>
				</font>
			</div><xsl:element name="img" use-attribute-sets="column.spacer.2" />
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
		<div class="myspace-b">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
		<xsl:element name="td" use-attribute-sets="column.1">
		<strong><xsl:value-of select="ARTICLE/SUBJECT"/></strong><br />
		<xsl:apply-templates select="ARTICLE/GUIDE/BODY"/>
		<xsl:apply-templates select=".//FOOTNOTE" mode="c_articlefootnote"/>
		</xsl:element>
		</tr></table>
		</div>
	</xsl:template>



	<!--
	<xsl:template match="ARTICLE-EDIT-FORM" mode="r_form">
	Use: Presentation of the article generation form
	 -->
	<xsl:template match="ARTICLE-EDIT-FORM" mode="r_form">
		
	<xsl:if test="../ARTICLE-PREVIEW">
			<!-- FORM HEADER -->
			<div class="useredit-u-a">
			<xsl:copy-of select="$myspace.tools.black" />&nbsp;
				<xsl:element name="{$text.subheading}" use-attribute-sets="text.subheading">
				<strong class="white">edit your
				<xsl:choose>
					<xsl:when test="MASTHEAD=1">introduction</xsl:when>
					<xsl:otherwise>review</xsl:otherwise>
				</xsl:choose>
				</strong>
				</xsl:element>
			</div>
	</xsl:if>
	
	<!-- FORM BOX -->
	<div class="form-wrapper">
	<a name="edit" id="edit"></a>
	<xsl:apply-templates select="." mode="c_premodmessage"/>
	









	<!-- useredit form -->
	<table border="0" cellspacing="0" cellpadding="0" width="390">
		<tr>
			<td class="form-label"><!-- useredit subject -->
				<xsl:copy-of select="$collective.icon.one" />
				<xsl:element name="{$text.base}" use-attribute-sets="text.base">
				<label for="useredit-subject" class="label-a"><xsl:copy-of select="$m_fsubject"/></label>
				</xsl:element>
			</td><td align="right">
				<xsl:element name="{$text.base}" use-attribute-sets="text.base">
				<xsl:apply-templates select="." mode="t_subjectbox"/>
				</xsl:element>
			</td></tr><tr><td class="form-label"><!-- useredit introduction -->
				<xsl:copy-of select="$collective.icon.two" />
				<xsl:element name="{$text.base}" use-attribute-sets="text.base">
				<label for="useredit-content" class="label-a">introduction:<!-- copy-of select="$m_content" --></label>
				</xsl:element>
			</td><td align="right">
				<xsl:element name="{$text.base}" use-attribute-sets="text.base">
				<xsl:apply-templates select="." mode="t_bodybox"/>
				</xsl:element>
			</td></tr>



			<tr><td>
			<!-- STATUS -->
			<div class="bodytext"><xsl:apply-templates select="STATUS" mode="c_articlestatus"/></div>	
			</td><td>
			<!-- EDITORID -->
			<div class="bodytext"><xsl:apply-templates select="EDITORID" mode="c_articleeditor"/></div>
			</td></tr>
			<xsl:if test="$test_IsEditor">
			<tr>
			<td colspan="2">
			<!-- CHOICE BETWEEN GUIDEML AND PLAINTEXT -->
			<xsl:apply-templates select="FORMAT" mode="c_guidemlorother"/>
			</td>
			</tr>
			</xsl:if>
	<tr>
	<td colspan="2">
	<!-- HIDE ARTICLE -->
	<div class="bodytext">
	<xsl:apply-templates select="FUNCTIONS/HIDE" mode="c_hidearticle"/>
	<!-- <xsl:apply-templates select="SUBMITTABLE" mode="c_changesubmittable"/> -->
	</div>
	</td>
	</tr>
	<xsl:if test="$test_IsEditor">
	<tr>
	<td colspan="2">
	<!-- RESEARCHER LIST -->
	<div class="bodytext">
	<xsl:apply-templates select="RESEARCHERS/USER-LIST" mode="c_researchers"/>
	</div>
	</td>
	</tr>
	<tr>
	<td colspan="2">
	<!-- EDIT RESEARCHERS -->
	<div class="bodytext">
	<xsl:apply-templates select="RESEARCHERS/USER-LIST" mode="c_editresearchers"/>
	</div>
	</td>
	</tr>
	</xsl:if>



    <tr>
	<td colspan="2" align="right">
		<!-- useredit buttons -->
		<a name="publish" id="publish"></a>
		<xsl:apply-templates select="." mode="t_previewbutton"/>
		<xsl:apply-templates select="FUNCTIONS/ADDENTRY" mode="c_addarticle"/>
		<xsl:apply-templates select="FUNCTIONS/UPDATE" mode="c_updatearticle"/>
		<xsl:apply-templates select="FUNCTIONS/DELETE" mode="c_deletearticle"/>
	<br />
	
	<!-- <xsl:apply-templates select="SITEID" mode="c_move-to-site"/> -->
	<br />
	</td>
	</tr>
	</table>
	</div>

	<div class="myspace-b">
		<xsl:element name="{$text.base}" use-attribute-sets="text.base">	
		<xsl:copy-of select="$arrow.right" /> <a href="{$root}U{/H2G2/VIEWING-USER/USER/USERID}">go back without editing</a>
		</xsl:element>
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
	
	<div>
	<xsl:apply-imports/>
	<xsl:copy-of select="$m_notforreviewtext"/>
	</div>
	
	<div><xsl:copy-of select="$m_notforreview_explanation"/></div>

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
		<xsl:attribute name="id">useredit-subject</xsl:attribute>
		<xsl:attribute name="class">useredit-h</xsl:attribute>
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


	<!-- buttons -->
	<xsl:attribute-set name="iARTICLE-EDIT-FORM_t_previewbutton" use-attribute-sets="form.preview" />
	<xsl:attribute-set name="iADDENTRY_r_addarticle"  use-attribute-sets="form.update" />
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
				
	<b><xsl:copy-of select="$m_ResList"/></b>
	<br/>
	<xsl:apply-templates select="USER" mode="c_showresearcher">
		<xsl:sort select="USERNAME" data-type="text" order="ascending"/>
	</xsl:apply-templates>

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
				
	<b><xsl:copy-of select="$m_edittheresearcherlisttext"/></b>
	<br/>
	<xsl:apply-templates select="." mode="t_setresearcherscontent"/>
	<br/>
	<xsl:apply-templates select="." mode="t_submitsetresearchers"/>

	<xsl:value-of select="$m_ResListEdit"/>

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
