<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet exclude-result-prefixes="msxsl local s dt" version="1.0" xmlns:dt="urn:schemas-microsoft-com:datatypes" xmlns:local="#local-functions" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:template name="MOD-EMAIL-MANAGEMENT_CSS">
		<style type="text/css"> 
			@import "http://www.bbc.co.uk/dnaimages/boards/includes/fonts.css" ;
		</style>
		<link href="http://www.bbc.co.uk/dnaimages/adminsystem/includes/dna_admin.css" rel="stylesheet" type="text/css"/>
		<script type="text/javascript"><![CDATA[
			var insertTarget; // variable flag used to set last focused form control
			function hilightStep(targetFormControl){
				targetStep = targetFormControl.parentNode;
				while (targetStep.tagName !=  'LI'){ 
					targetStep = targetStep.parentNode;
				}
				targetStep.className =	'selectedStep';
			}
			function lolightStep(targetFormControl){
				targetStep =  targetFormControl.parentNode;
				while (targetStep.tagName != 'LI'){
					targetStep = targetStep.parentNode;
				}
				targetStep.className = '';
			}
			function insertPhrase(targetTextarea){
			
				hide('phrasePick');	
			}
			function hide(ele){
				document.getElementById(ele).style.display='none';
			}
			function show(ele){
				document.getElementById(ele).style.display='block';
			}
			function insertAtCursor(myField, mySourceField){
				document.getElementById('doInsert').disabled='disabled';
				myValue='';
				for(i=0;i<mySourceField.length;i++){
					if(mySourceField[i].checked){
						myValue = '++**'+mySourceField[i].value+'**++';
						mySourceField[i].checked=false;
						break;
					}
				} 
				if (document.selection){//IE support
					myField.focus();
					sel = document.selection.createRange();
					sel.text = myValue;
				}else if(myField.selectionStart || myField.selectionStart == '0') {//MOZILLA/NETSCAPE support
					var startPos = myField.selectionStart;
					var endPos = myField.selectionEnd;
					myField.value = myField.value.substring(0, startPos)+myValue+ myField.value.substring(endPos, myField.value.length);
					myField.focus();
					myField.setSelectionRange(startPos+myValue.length,startPos+myValue.length);
				}else{
					myField.value += myValue;
				}
				mySourceField.selectedIndex=0;
				hide('phrasePicker');
			}
			function setTarget(ele){
				insertTarget = ele;
				document.getElementById('insertphrase').disabled=false;
			}
		]]></script>
	</xsl:template>
	<xsl:variable name="view" select="/H2G2/MODERATOR-VIEW/@VIEWTYPE"/>
	<xsl:variable name="viewid" select="/H2G2/MODERATOR-VIEW/@VIEWID"/>
	<xsl:variable name="phrasesort">
		<xsl:choose>
			<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_phrasesort']/VALUE = 'group'">INSERTGROUP</xsl:when>
			<xsl:otherwise>INSERTNAME</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<!--
	<xsl:variable name="sorted_templates"/>
	Author:		Darren Shukri
	Scope:		Global
	Purpose:	Template list sorted by name
	-->
	<xsl:variable name="sorted_templates">
		<view type="{/H2G2/MODERATOR-VIEW/@VIEWTYPE}"/>
		<templates>
			<xsl:for-each select="/H2G2/EMAIL-TEMPLATES/EMAIL-TEMPLATE">
				<xsl:sort select="NAME"/>
				<xsl:copy-of select="."/>
			</xsl:for-each>
		</templates>
	</xsl:variable>
	<!--
	<xsl:variable name="sorted_phrases"/>
	Author:		Darren Shukri
	Scope:		Global
	Purpose:	Phrase list sorted by name
	-->
	<xsl:variable name="sorted_phrases">
		<view type="{/H2G2/MODERATOR-VIEW/@VIEWTYPE}" id="{$viewid}"/>
		<phrases>
			<xsl:for-each select="/H2G2/EMAIL-INSERTS/EMAIL-INSERT">
				<xsl:sort select="*[name()=$phrasesort]"/>
				<xsl:copy-of select="."/>
			</xsl:for-each>
		</phrases>
	</xsl:variable>
  
	<!--
	<xsl:template name="MOD-EMAIL-MANAGEMENT_HEADER">
	Author:		Andy Harris
	Context:	H2G2
	Purpose:	Creates the title for the page which sits in the html header
	-->
	<xsl:template name="MOD-EMAIL-MANAGEMENT_HEADER">
		<xsl:apply-templates mode="header" select=".">
			<xsl:with-param name="title"> DNA - Email Management </xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>
	<!--
	<xsl:template name="MOD-EMAIL-MANAGEMENT_SUBJECT">
	Author:		Andy Harris
	Context:	H2G2
	Purpose:	Creates the text for the subject
	-->
	<xsl:template name="MOD-EMAIL-MANAGEMENT_SUBJECT">
		<xsl:call-template name="SUBJECTHEADER">
			<xsl:with-param name="text"> Email Management </xsl:with-param>
		</xsl:call-template>
	</xsl:template>
  
  <!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
									Page - Level  template
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<xsl:template name="MOD-EMAIL-MANAGEMENT_MAINBODY">
		<div id="topNav">
			<div id="bbcLogo">
				<img src="{$dnaAdminImgPrefix}/images/config_system/shared/bbc_logo.gif" alt="BBC"/>
			</div>
			<h1>DNA admin</h1>
		</div>
		<div style="width:996px;">
			<xsl:call-template name="sso_statusbar-admin"/>
			<div id="subNav" style="background:#f4ebe4 url({$dnaAdminImgPrefix}/images/config_system/shared/icon_email_man.gif) 0px 2px no-repeat;">
				<div id="subNavText">
					<h2>Email Management</h2>
				</div>
			</div>
			<form action="moderationemailmanagement" name="moderationemailmanagement" method="post">
				<xsl:call-template name="MODERATIONEMAILPAGEINTRO"/>
				<input type="hidden" name="view" value="{$view}"/>
				<input type="hidden" name="viewid" value="{$viewid}"/>
				<xsl:choose>
					<xsl:when test="$view = 'editinsert'">
						<xsl:variable name="siteid" select="/H2G2/MODERATOR-VIEW/@SITEID"/>
						<input type="hidden" name="siteid" value="{$siteid}"/>
						<xsl:variable name="modclassid" select="/H2G2/EMAIL-INSERTS/EMAIL-INSERT[@ID=$viewid]/CLASSID"/>
						<input type="hidden" name="modclassid" value="{/H2G2/SITE-LIST/SITE[@ID=$siteid]/CLASSID}"/>
					</xsl:when>
					<xsl:when test="$view = 'editemail'">
						<xsl:variable name="modclassid" select="/H2G2/EMAIL-TEMPLATES/EMAIL-TEMPLATE[@EMAILTEMPLATEID=$viewid]/@MODID"/>
						<input type="hidden" name="modclassid" value="{$modclassid}"/>
					</xsl:when>
					<xsl:when test="$view = 'createinsert'">
						<xsl:if test="/H2G2/MODERATOR-VIEW/@CLASSID = 0">
							<input type="hidden" name="siteid" value="{$viewid}"/>
							<xsl:variable name="modclassid" select="/H2G2/EMAIL-INSERTS/EMAIL-INSERT[@ID=$viewid]/CLASSID"/>
							<input type="hidden" name="modclassid" value="{/H2G2/SITE-LIST/SITE[@ID=$viewid]/CLASSID}"/>
						</xsl:if>
						<xsl:if test="/H2G2/MODERATOR-VIEW/@SITEID = 0">
							<input type="hidden" name="modclassid" value="{/H2G2/MODERATOR-VIEW/@CLASSID}"/>
						</xsl:if>
					</xsl:when>
					<xsl:when test="$view = 'createnewemail'">
						<input type="hidden" name="modclassid" value="{$viewid}"/>
					</xsl:when>
				</xsl:choose>
				<div id="mainBody" class="{$view}View">
					<xsl:call-template name="SELECTOR"/>
					<div id="mainContent" class="{$view}View">
						<xsl:call-template name="MOD-EMAIL-PAGE"/>
					</div>
				</div>
			</form>
		</div>
	</xsl:template>
	<!--
	<xsl:template name="MODERATIONEMAILPAGEINTRO">
	Author:		Darren Shukri
	Context:	H2G2
	Purpose:	Displays section header and instructional text
	-->
	<xsl:template name="MODERATIONEMAILPAGEINTRO">
		<xsl:choose>
			<xsl:when test="$view = 'class'">
				<h3>Email Templates for the <span class="classLabel">
						<xsl:value-of select="MODERATION-CLASSES/MODERATION-CLASS[@CLASSID = $viewid]/NAME"/> Class</span>
				</h3>
				<!--xsl:apply-templates select="LASTACTION" mode="CLASS"/-->
				<div id="instructional">
					<input name="createnewemail" type="submit" value="Create New" class="buttonThreeD"/>
					<p>To create a new email template, click the 'CREATE NEW EMAIL' button. Select 'edit' or 'remove' beside 
the relevant email template to perform these actions. Email templates are class-specific.</p>
				</div>
			</xsl:when>
			<xsl:when test="$view = 'site'">
				<h3>Inserted Phrases for the <span class="siteLabel">
						<xsl:value-of select="SITE-LIST/SITE[@ID = $viewid]/NAME"/> Site</span>
				</h3>
				<!--xsl:apply-templates select="LASTACTION" mode="SITE"/-->
				<div id="instructional">
					<input name="insertcreate" type="submit" value="Create New Phrase" class="buttonThreeD"/>
					<p>To create a new inserted phrase, click the ‘CREATE NEW PHRASE’ button. Select ‘edit’ or ‘remove’
beside a pre-existing phrase to perform these actions.</p>
				</div>
			</xsl:when>
			<xsl:when test="$view = 'editinsert'">
				<h3>Edit Inserted Phrase: <xsl:value-of select="/H2G2/EMAIL-INSERTS/EMAIL-INSERT[@ID = $viewid]/NAME"/>
				</h3>
				<!--xsl:apply-templates select="LASTACTION" mode="SITE"/-->
				<div id="instructional">
					<p>
						<b>Step 1:</b> Name the phrase.  <b>Step 2:</b> If the phrase belongs to a group of phrases, select the group’s name from the drop-down menu. If the group doesn’t exist, create it by entering a name into the ‘Create group’ field.  <b>Step 3:</b> Add default text associated with this phrase. <b>Step 4:</b> To add customised text for this site, enter it in the ‘Site-specific text’ field. This text will override the default text.</p>
				</div>
			</xsl:when>
			<xsl:when test="$view = 'editemail'">
				<h3>Edit Email Template: <xsl:value-of select="/H2G2/EMAIL-TEMPLATES/EMAIL-TEMPLATE[@EMAILTEMPLATEID = $viewid]/NAME"/>
				</h3>
				<!--xsl:apply-templates select="LASTACTION" mode="SITE"/-->
				<div id="instructional">
					<input class="buttonThreeD" type="submit" id="finduser" name="finduser" value="Create New Moderator"/>
					<p>Name the email template and add the text that will appear in the email. To add a phrase to the template, place your cursor in the correct location and click the ‘INSERT PHRASE’ button. Select the appropriate phrase from the popup window. To delete a phrase, either remove it by pressing the backspace key or select it and then click the ‘REMOVE PHRASE’ button. Email templates are class-specific.</p>
				</div>
			</xsl:when>
			<xsl:when test="$view = 'createinsert'">
				<h3>Create an Inserted Phrase for the <span class="siteLabel">
						<xsl:value-of select="SITE-LIST/SITE[@ID = $viewid]/NAME"/> Site</span>
				</h3>
				<!--xsl:apply-templates select="LASTACTION" mode="SITE"/-->
				<div id="instructional">
					<p>
						<b>Step 1:</b> Name the phrase.  <b>Step 2:</b> If the phrase belongs to a group of phrases, select the group’s name from the drop-down menu. If the group doesn’t exist, create it by entering a name into the ‘Create group’ field.  <b>Step 3:</b> Add default text associated with this phrase. <b>Step 4:</b> To add customised text for this site, enter it in the ‘Site-specific text’ field. This text will override the default text.</p>
				</div>
			</xsl:when>
			<xsl:when test="$view = 'createnewemail'">
				<h3>Create an Email Template for the <span class="classLabel">
						<xsl:value-of select="MODERATION-CLASSES/MODERATION-CLASS[@CLASSID = $viewid]/NAME"/> Class</span>
				</h3>
				<!--xsl:apply-templates select="LASTACTION" mode="SITE"/-->
				<div id="instructional">
					<input class="buttonThreeD" type="submit" id="finduser" name="finduser" value="Create New Moderator"/>
					<p>Click the 'CREATE MODERATOR' button to add a moderator. To remove moderators' direct access to the site or to remove moderators from the system, check the relevant checkbox(es) and then click either'REMOVE DIRECT ACCESS TO SITE' or 'REMOVE MODERATOR'.</p>
				</div>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template name="templates">
	Author:		Darren Shukri
	Context:	H2G2
	Purpose:	Creates the table of email templates for current class
	-->
	<xsl:template match="templates">
		<xsl:param name="classname"/>
		<table cellspacing="0" class="modTable {$view}View emailTable">
			<thead>
				<tr>
					<th>Subject</th>
					<th class="actions">Actions</th>
				</tr>
			</thead>
			<tbody>
				<xsl:apply-templates select="EMAIL-TEMPLATE">
					<xsl:with-param name="classname">
						<xsl:value-of select="$classname"/>
					</xsl:with-param>
				</xsl:apply-templates>
				<xsl:if test="count(EMAIL-TEMPLATE) = 0">
					<tr>
						<td class="noData" colspan="5">No templates found for this class.</td>
					</tr>
				</xsl:if>
			</tbody>
		</table>
	</xsl:template>
	<!--
	<xsl:template name="EMAIL-TEMPLATE">
	Author:		Darren Shukri
	Context:	H2G2
	Purpose:	Populates the table of email templates for current class
	-->
	<xsl:template match="EMAIL-TEMPLATE">
		<xsl:param name="classname"/>
		<tr>
			<xsl:choose>
				<xsl:when test="count(preceding-sibling::EMAIL-TEMPLATE) mod 2 = 0">
					<xsl:attribute name="class">stripeOne</xsl:attribute>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="class">stripeTwo</xsl:attribute>
				</xsl:otherwise>
			</xsl:choose>
			<td>
				<xsl:value-of select="NAME"/>
			</td>
			<td>
				<a href="{$query}&amp;action=editemail&amp;view={$modview}&amp;viewid={$modviewid}&amp;emailtemplatename={NAME}&amp;emailtemplateid={@EMAILTEMPLATEID}">edit</a>&nbsp;<a class="removeLink" href="{$query}&amp;view={$modview}&amp;viewid={$modviewid}&amp;action=removeemail&amp;emailtemplatename={NAME}&amp;emailtemplateid={@EMAILTEMPLATEID}&amp;modclassid={@MODID}" onclick="javascript:return(confirm('Remove the {NAME} Email template from the {$classname} class?'));">remove</a>
			</td>
		</tr>
	</xsl:template>
	<!--
	<xsl:template name="phrases">
	Author:		Darren Shukri
	Context:	H2G2
	Purpose:	Creates the table of email phrases for current site
	-->
	<xsl:template match="phrases">
		<xsl:param name="sitename"/>
		<table cellspacing="0" class="modTable {$view}View emailTable">
			<thead>
				<tr>
					<th>
						<a href="{$root}{$query}&amp;s_phrasesort=name">Phrase Name</a>
					</th>
					<th>
						<a href="{$root}{$query}&amp;s_phrasesort=group">Phrase Group</a>
					</th>
					<th>Default Text</th>
					<th>Site-specific Text</th>
					<th class="actions">Actions</th>
				</tr>
			</thead>
			<tbody>
				<xsl:apply-templates select="EMAIL-INSERT">
					<xsl:with-param name="sitename">
						<xsl:value-of select="$sitename"/>
					</xsl:with-param>
				</xsl:apply-templates>
				<xsl:if test="count(EMAIL-INSERT) = 0">
					<tr>
						<td class="noData" colspan="5">No inserts found for this site.</td>
					</tr>
				</xsl:if>
			</tbody>
		</table>
	</xsl:template>
	<!--
	<xsl:template name="EMAIL-INSERT">
	Author:		Darren Shukri
	Context:	H2G2
	Purpose:	Populates the table of email phrases for current site
	-->
	<xsl:template match="EMAIL-INSERT">
		<xsl:param name="sitename"/>
		<tr>
			<xsl:choose>
				<xsl:when test="count(preceding-sibling::EMAIL-INSERT) mod 2 = 0">
					<xsl:attribute name="class">stripeOne</xsl:attribute>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="class">stripeTwo</xsl:attribute>
				</xsl:otherwise>
			</xsl:choose>
			<td>
				<xsl:value-of select="NAME"/>
			</td>
			<td>
				<xsl:choose>
					<xsl:when test="GROUP != ''">
						<xsl:value-of select="GROUP"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:attribute name="class">inactive</xsl:attribute>none</xsl:otherwise>
				</xsl:choose>
			</td>
			<td>
				<xsl:value-of select="DEFAULTTEXT"/>
			</td>
			<td>
				<xsl:value-of select="TEXT"/>
			</td>
			<td>
        <a href="ModerationEmailManagement?s_view={$view}&amp;view={$view}&amp;viewid={$viewid}&amp;s_viewid={$viewid}&amp;action=editinsert&amp;insertname={NAME}&amp;insertid={@ID}">edit</a>
        <xsl:choose>
          <xsl:when test="@SITEID != 0">
            &nbsp;<a class="removeLink" href="ModerationEmailManagement?s_view={$view}&amp;s_viewid={$viewid}&amp;view={$view}&amp;viewid={$viewid}&amp;action=removeinsert&amp;insertname={NAME}&amp;insertid={@ID}&amp;siteid={@SITEID}" onclick="javascript:return(confirm('Remove the inserted phrase {NAME} from the {$sitename} site?'));">remove from site</a>
          </xsl:when>
          <xsl:otherwise>
            &nbsp;<a class="removeLink" href="ModerationEmailManagement?s_view=class&amp;s_viewid={CLASSID}&amp;view=class&amp;viewid={CLASSID}&amp;action=removeinsert&amp;insertname={NAME}&amp;insertid={@ID}&amp;modclassid={CLASSID}" onclick="javascript:return(confirm('Remove the inserted phrase {NAME} from the moderation class?'));">remove from class</a>
          </xsl:otherwise>
        </xsl:choose>
			</td>
		</tr>
	</xsl:template>
	<!--
	<xsl:template name="MOD-EMAIL-PAGE[@PAGE = 'createnewemail']">
	Author:		Darren Shukri
	Context:	H2G2
	Purpose:	Displays Email Template creation form
	-->
	<xsl:template name="MOD-EMAIL-PAGE">
		<xsl:choose>
			<xsl:when test="$view = 'createnewemail'">
				<xsl:call-template name="CREATE-EMAIL-TEMPLATE"/>
			</xsl:when>
			<xsl:when test="$view = 'editemail'">
				<xsl:call-template name="CREATE-EMAIL-TEMPLATE">
					<xsl:with-param name="editemail">
						<xsl:value-of select="$viewid"/>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$view = 'class'">
				<xsl:apply-templates select="msxsl:node-set($sorted_templates)/templates">
					<xsl:with-param name="classname">
						<xsl:value-of select="/H2G2/MODERATION-CLASSES/MODERATION-CLASS[@CLASSID = $viewid]/NAME"/>
					</xsl:with-param>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:when test="$view = 'site'">
				<xsl:apply-templates select="msxsl:node-set($sorted_phrases)/phrases">
					<xsl:with-param name="site">
						<xsl:value-of select="/H2G2/SITE-LIST/SITE[@ID = $viewid]"/>
					</xsl:with-param>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:when test="$view = 'createinsert'">
				<xsl:call-template name="CREATE-EMAIL-INSERT"/>
			</xsl:when>
			<xsl:when test="$view = 'editinsert'">
				<xsl:call-template name="CREATE-EMAIL-INSERT">
					<xsl:with-param name="editinsert">
						<xsl:value-of select="$viewid"/>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template name="CREATE-EMAIL-TEMPLATE">
	Author:		Darren Shukri
	Context:	H2G2
	Purpose:	Displays create email template form. If action=save then new email created otherwise edit of existing.
	-->
	<xsl:template name="CREATE-EMAIL-TEMPLATE">
		<xsl:param name="editemail" select="'null'"/>
		<input class="buttonThreeD" disabled="disabled" type="button" id="insertphrase" name="insertphrase" value="Insert Phrase" onclick="show('phrasePicker');this.disabled='disabled';" onkeypress="show('phrasePicker');this.disabled='disabled';"/>
		<div id="emailControls">
		Name: <input maxlength="80" name="name" type="text" value="{/H2G2/EMAIL-TEMPLATES/EMAIL-TEMPLATE[@EMAILTEMPLATEID = $editemail]/NAME}">
        <xsl:if test="$editemail != 'null'">
          <xsl:attribute name="readonly">readonly</xsl:attribute>
        </xsl:if>
			</input>
			<br/> Subject: <input maxlength="80" name="subject" onfocus="setTarget(this)" type="text" value="{/H2G2/EMAIL-TEMPLATES/EMAIL-TEMPLATE[@EMAILTEMPLATEID = $editemail]/SUBJECT}"/>
			<br/>
			<textarea id="emailTemplateBody" name="body" onfocus="setTarget(this)" rows="15" cols="63">
				<xsl:value-of select="/H2G2/EMAIL-TEMPLATES/EMAIL-TEMPLATE[@EMAILTEMPLATEID = $editemail]/BODY"/>
			</textarea>
			<br/>
			<label for="{generate-id()}">
				<input id="{generate-id()}" name="autoformat" type="checkbox"/>
			auto-format text </label>
		</div>
    <xsl:if test="$editemail = 'null'">
      <input type="hidden" name="action" value="save"/>
    </xsl:if>
    <input type="hidden" name="s_view" value="class" />
    <input type="hidden" name="s_viewid" value="{/H2G2/MODERATOR-VIEW/@CLASSID}" />
    <input type="reset" value="Clear Changes" class="buttonThreeD"/>
		<input type="submit" name="saveandreturnhome" value="Save and Return Home" class="buttonThreeD"/>
		<input type="submit" name="saveandcreatenew" value="Save and Create Another" class="buttonThreeD"/>
		<div id="phrasePicker">
			<h1>Phrase Picker</h1>
			<p>Select the phrase or phrase group:</p>
			<ul>
				<xsl:apply-templates select="/H2G2/EMAIL-INSERT-GROUPS/GROUP" mode="PHRASEPICK"/>
				<xsl:apply-templates select="/H2G2/INSERT-TYPES/TYPE" mode="PHRASEPICK"/>
			</ul>
			<button disabled="disabled" id="doInsert" name="doInsert" type="button" onclick="insertAtCursor(insertTarget,document.forms['moderationemailmanagement'].elements['selInsert'])" onkeypress="insertAtCursor(insertTarget,document.forms['moderationemailmanagement'].elements['selInsert'])">insert</button>
		</div>
	</xsl:template>
	<!--
	<xsl:template match="EMAIL-INSERT-GROUPS/GROUP">
	Author:		Darren Shukri
	Context:	H2G2
	Purpose:	Adds phrase groups to phrase selection dialogue
	-->
	<xsl:template match="EMAIL-INSERT-GROUPS/GROUP" mode="PHRASEPICK">
		<li>
			<label for="{generate-id()}">
				<input id="{generate-id()}" name="selInsert" onchange="document.getElementById('doInsert').disabled=false" onclick="this.blur();this.focus()/*required for IE*/" onkeyup="this.blur();this.focus()/*required for IE*/" type="radio" value="{.}"/>group:<xsl:value-of select="."/>
			</label>
		</li>
	</xsl:template>
	<!--
	<xsl:template match="INSERT-TYPES/TYPE">
	Author:		Darren Shukri
	Context:	H2G2
	Purpose:	Adds phrase types to phrase selection dialogue
	-->
	<xsl:template match="INSERT-TYPES/TYPE" mode="PHRASEPICK">
		<li>
			<label for="{generate-id()}">
				<input id="{generate-id()}" name="selInsert" onchange="document.getElementById('doInsert').disabled=false" onclick="this.blur();this.focus()/*required for IE*/" onkeyup="this.blur();this.focus()/*required for IE*/" type="radio" value="{.}"/>
				<xsl:value-of select="."/>
			</label>
		</li>
	</xsl:template>
	<!--
	<xsl:template name="CREATE-EMAIL-INSERT">
	Author:		Darren Shukri
	Context:	H2G2
	Purpose:	Displays create email insert form
	-->
	<xsl:template name="CREATE-EMAIL-INSERT">
		<xsl:param name="editinsert" select="'null'"/>
		<span id="indicates">* indicates a required field</span>
		<div id="emailControls">
			<ol id="insertSteps">
				<li>Phrase Name*: <input name="InsertName" onblur="lolightStep(this)" onfocus="hilightStep(this)" type="text" value="{/H2G2/EMAIL-INSERTS/EMAIL-INSERT[@ID = $editinsert]/NAME}">
						<xsl:if test="$editinsert != 'null'">
							<xsl:attribute name="readonly">readonly</xsl:attribute>
						</xsl:if>
					</input>
          Display Name*: <input name="ReasonDescription" type="text" onfocus="hilightStep(this)" onblur="lolightStep(this)" value="{/H2G2/EMAIL-INSERTS/EMAIL-INSERT[@ID = $editinsert]/DISPLAYNAME}"/>
        </li>
				<li>Does this phrase belong to a group (e.g. House Rules)? If not, skip to
				Step 3.<br/> Select group <xsl:apply-templates select="/H2G2/EMAIL-INSERT-GROUPS">
						<xsl:with-param name="editinsert">
							<xsl:value-of select="$editinsert"/>
						</xsl:with-param>
					</xsl:apply-templates>
				 - or - Add new group <input name="NewInsertGroup" onblur="lolightStep(this)" onfocus="hilightStep(this)" type="text"/>
				</li>
				<li>Default Text*<br/>
					<textarea rows="3" cols="58" name="ClassInsertText" onblur="lolightStep(this)" onfocus="hilightStep(this)">
						<xsl:value-of select="/H2G2/EMAIL-INSERTS/EMAIL-INSERT[@ID = $editinsert]/DEFAULTTEXT"/>
					</textarea>
					<br/>
					<label for="{generate-id()}">
						<input id="{generate-id()}" name="DuplicateToClass" onblur="lolightStep(this)" onfocus="hilightStep(this)" type="checkbox"/> Duplicate this Inserted Phrase across all other
					sites in the <xsl:value-of select="/H2G2/MODERATION-CLASSES/MODERATION-CLASS[@CLASSID = /H2G2/SITE-LIST/SITE[@ID = $viewid]/CLASSID]/NAME"/> class.</label>
					<br/> (Site-specific text will not be duplicated.)</li>
				<li>Site-specific Text<br/>
					<textarea rows="3" cols="58" name="SiteInsertText" onblur="lolightStep(this)" onfocus="hilightStep(this)">
						<xsl:value-of select="/H2G2/EMAIL-INSERTS/EMAIL-INSERT[@ID = $editinsert]/TEXT"/>
					</textarea>
				</li>
			</ol>
		</div>
    <input type="hidden" name="s_view" value="site" />
    <input type="hidden" name="s_viewid" value="{/H2G2/MODERATOR-VIEW/@SITEID}" />
    <input type="reset" value="Clear Changes" class="buttonThreeD clearButton"/>
    <input type="submit" name="insertsaveandreturnhome" value="Save &amp; Return Home" class="buttonThreeD"/>
		<input type="submit" name="insertsaveandcreatenew" value="Save &amp; Create Another" class="buttonThreeD"/>
	</xsl:template>
	<!--
	<xsl:template name="EMAIL-INSERT-GROUPS">
	Author:		Darren Shukri
	Context:	H2G2
	Purpose:	Creates insert groups select
	-->
	<xsl:template match="EMAIL-INSERT-GROUPS">
		<xsl:param name="editinsert" select="'null'"/>
		<select name="InsertGroup" onblur="lolightStep(this)" onfocus="hilightStep(this)">
			<option value="">select group</option>
			<xsl:apply-templates select="GROUP">
				<xsl:with-param name="editinsert">
					<xsl:value-of select="$editinsert"/>
				</xsl:with-param>
			</xsl:apply-templates>
		</select>
	</xsl:template>
	<!--
	<xsl:template name="GROUP">
	Author:		Darren Shukri
	Context:	H2G2
	Purpose:	Populates insert groups select
	-->
	<xsl:template match="GROUP">
		<xsl:param name="editinsert" select="'null'"/>
		<option value="{.}">
			<xsl:if test=". = /H2G2/EMAIL-INSERTS/EMAIL-INSERT[@ID = $editinsert]/GROUP">
				<xsl:attribute name="selected">selected</xsl:attribute>
			</xsl:if>
			<xsl:value-of select="."/>
		</option>
	</xsl:template>

</xsl:stylesheet>
