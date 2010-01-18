<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	
	<xsl:template name="SITEADMIN-EDITOR_SUBJECT">
		<xsl:call-template name="SUBJECTHEADER">
			<xsl:with-param name="text">DNA Site Admin for <xsl:value-of select="SITEADMIN/URLNAME"/>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template name="SITEADMIN-EDITOR_MAINBODY">
		<xsl:if test="$superuser = 1">
			<xsl:for-each select="SITE-LIST/SITE">
				<xsl:sort select="@ID" order="ascending" data-type="number"/>
 [ <a href="/dna/{NAME}/SiteAdmin">
					<xsl:value-of select="SHORTNAME"/>
				</a> ] 
</xsl:for-each>
			<br/>
		</xsl:if>
		<xsl:apply-templates select="SITEADMIN"/>
	</xsl:template>
  
<xsl:template match="SITEADMIN">
<b><xsl:value-of select="ERROR"/></b>
<xsl:apply-templates select="CREATERESULT"/>
<xsl:apply-templates select="UPLOADRESULT"/>
<form method="post" action="SiteAdmin">
	<table>
	<tr>
	<td align="right">URL: </td>
	<td><xsl:value-of select="URLNAME"/></td></tr>
	<tr><td align="right">Short name:</td>
	<td><input type="text" name="shortname" value="{SHORTNAME}"/></td>
	</tr>
	<tr><td align="right">Description:</td>
	<td><input type="text" name="description" value="{DESCRIPTION}"/></td></tr>
    <tr>
      <td align="right">SSO Service:</td>
      <td>
        <input type="text" name="ssoservice" value="{SSOSERVICE}"/>
      </td>
    </tr>
	<tr><td align="right">Default skin:</td>
	<td><input type="text" name="defaultskin" value="{DEFAULTSKIN}"/></td></tr>
    <tr>
      <td align="right">Skin Set:</td>
      <td>
        <input type="text" name="skinset" value="{SKINSET}"></input>
      </td>
    </tr>
	<tr><td align="right">Moderators email:</td>
	<td><input type="text" name="ModeratorsEmail" value="{MODERATORSEMAIL}"/></td></tr>
	<tr><td align="right">Editors email:</td>
	<td><input type="text" name="EditorsEmail" value="{EDITORSEMAIL}"/></td></tr>
	<tr><td align="right">Feedback email:</td>
	<td><input type="text" name="FeedbackEmail" value="{FEEDBACKEMAIL}"/></td></tr>
	<tr><td align="right">Auto Message User ID</td>
	<td><input type="text" name="AutoMessageUserID" value="{AUTOMESSAGEUSERID}"/></td></tr>
	<tr><td align="right">Event Alert Message User ID</td>
	<td><input type="text" name="eventalertmessageuserid" value="{EVENTALERTMESSAGEUSERID}" /></td></tr>
	<tr><td align="right">Alert Email Subject</td>
	<td><input type="text" name="EventEmailSubject" value="{EVENTEMAILSUBJECT}" /></td></tr>
	<tr><td align="right">Thread Edit Time Limit (minutes):</td>
	<td><input type="text" name="ThreadEditTimeLimit" value="{THREADEDITTIMELIMIT}"/></td></tr>

	<tr><td align="right">Premoderation:</td>
	<td><input type="radio" name="premoderation" value="1">
		<xsl:apply-templates select="PREMODERATION" mode="checkedattribute"/>
	</input> Yes 
	<input type="radio" name="premoderation" value="0">
		<xsl:apply-templates select="PREMODERATION" mode="notcheckedattribute"/>
	</input> No	</td></tr>
	<tr><td align="right">Prevent cross-linking:</td>
	<td><input type="radio" name="crosslink" value="1">
		<xsl:apply-templates select="NOCROSSLINKING" mode="checkedattribute"/>
	</input> Yes 
	<input type="radio" name="crosslink" value="0">
		<xsl:apply-templates select="NOCROSSLINKING" mode="notcheckedattribute"/>
	</input> No	</td></tr>
	<tr><td align="right">Custom terms:</td>
	<td><input type="radio" name="customterms" value="1">
		<xsl:apply-templates select="CUSTOMTERMS" mode="checkedattribute"/>
	</input> Yes 
	<input type="radio" name="customterms" value="0">
		<xsl:apply-templates select="CUSTOMTERMS" mode="notcheckedattribute"/>
	</input> No	</td></tr>
	<tr><td align="right">Require Password:</td>
	<td><input type="radio" name="passworded" value="1">
		<xsl:apply-templates select="PASSWORDED" mode="checkedattribute"/>
	</input> Yes 
	<input type="radio" name="passworded" value="0">
		<xsl:apply-templates select="PASSWORDED" mode="notcheckedattribute"/>
	</input> No	</td></tr>
	<tr><td align="right">Unmoderated:</td>
	<td><input type="radio" name="unmoderated" value="1">
		<xsl:apply-templates select="UNMODERATED" mode="checkedattribute"/>
	</input> Yes 
	<input type="radio" name="unmoderated" value="0">
		<xsl:apply-templates select="UNMODERATED" mode="notcheckedattribute"/>
	</input> No	</td></tr>
	
	<tr><td align="right">Article Guest Book Forums:</td>
	<td><input type="radio" name="articleguestbookforums" value="1">
		<xsl:apply-templates select="ARTICLEFORUMSTYLE" mode="checkedattribute"/>
	</input> Yes 
	<input type="radio" name="articleguestbookforums" value="0">
		<xsl:apply-templates select="ARTICLEFORUMSTYLE" mode="notcheckedattribute"/>
	</input> No	</td></tr>

	<tr><td align="right">Include crumbtrail:</td>
	<td><input type="radio" name="includecrumbtrail" value="1">
		<xsl:apply-templates select="INCLUDECRUMBTRAIL" mode="checkedattribute"/>
	</input> Yes 
	<input type="radio" name="includecrumbtrail" value="0">
		<xsl:apply-templates select="INCLUDECRUMBTRAIL" mode="notcheckedattribute"/>
	</input> No	</td></tr>
	
	
	
		
	<tr><td align="right">Allow vote removal:</td>
	<td><input type="radio" name="AllowRemoveVote" value="1">
		<xsl:if test="ALLOWREMOVEVOTE='1'"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if>
	</input> Yes 
	<input type="radio" name="AllowRemoveVote" value="0">
		<xsl:if test="ALLOWREMOVEVOTE!='1'"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if>
	</input> No	</td></tr>
	
	<tr><td align="right">Allow PostCodes in Search:</td>
	<td><input type="radio" name="AllowPostCodesInSearch" value="1">
		<xsl:if test="ALLOWPOSTCODESINSEARCH='1'"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if>
	</input> Yes 
	<input type="radio" name="AllowPostCodesInSearch" value="0">
		<xsl:if test="ALLOWPOSTCODESINSEARCH!='1'"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if>
	</input> No	</td></tr>
	
	<tr><td align="right">Queue Postings:</td>
	<td><input type="radio" name="QueuePostings" value="1">
		<xsl:if test="QUEUEPOSTINGS='1'"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if>
	</input> Yes 
	<input type="radio" name="QueuePostings" value="0">
		<xsl:if test="QUEUEPOSTINGS!='1'"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if>
	</input> No	</td></tr>
	
	

	
	
	

	<tr><td colspan="2"><xsl:apply-templates select="PERMISSIONS"/></td></tr>
	<tr><td colspan="2"><xsl:apply-templates select="THREADORDER"/></td></tr>
	<tr><td colspan="2"><input type="submit" name="update" value="Change settings"/></td></tr>
	</table>
</form>
<hr/>
	Edit skin details:<br/>
  <table cellspacing="10">
    <xsl:for-each select="SKINS/SKIN">
      <tr>
        <form method="get" action="SiteAdmin">
          <td>
            <xsl:text>SkinName:</xsl:text>
          </td>
          <td>
            <input type="text" name="skindescription" value="{DESCRIPTION}"/><input type="hidden" name="skinname" value="{NAME}"/>
        </td><td>
		  Use frames: <input type="radio" name="useframes" value="1">
						<xsl:apply-templates select="USEFRAMES" mode="checkedattribute"/>
					</input> Yes 
					<input type="radio" name="useframes" value="0">
						<xsl:apply-templates select="USEFRAMES" mode="notcheckedattribute"/>
					</input> No
		  </td>
      <td>
        <input type="submit" name="renameskin" value="Change details"/>
      </td>
		</form>
		</tr>
	</xsl:for-each>
</table>

<!--<hr/><b>Upload skins</b>
<form enctype="multipart/form-data" action="SiteAdmin" method="post">
File to upload: <input align="center" type="file" name="file" size="60" maxlength="255"/><br/>
Skin Name: <input type="text" name="skinname"/>
<xsl:if test="$superuser = 1">
<input type="checkbox" name="create" value="1" selected="selected"/> Create New Skin<br/>
Description: <input type="text" name="description"/>
Use frames: <input type="radio" name="useframes" value="1" /> Yes <input type="radio" name="useframes" value="0" checked="checked"/> No<br/>
</xsl:if>
<br/>
Leafname: <input type="text" name="leafname" value="HTMLOutput.xsl"/><br/>
<INPUT type="submit" name="uploadskin" value="upload it"/>
</form>-->
			
<xsl:if test="$superuser = 1">
<hr/>
<B>Create new site</B>
<form enctype="multipart/form-data" method="post" action="SiteAdmin">
<table>
<tr><td>URL Name: </td><td><input type="text" name="urlname"/></td></tr>
<tr><td>Short Name: </td><td><input type="text" name="shortname"/></td></tr>
<tr><td>Description: </td><td><input type="text" name="description"/></td></tr>
  <tr>
    <td>SSO Service: </td>
    <td>
      <input type="text" name="ssoservice"/>
    </td>
  </tr>
<tr><td>Default Skin: </td><td><input type="text" name="defaultskin" value="default"/></td></tr>
<tr><td>Skin description: </td><td><input type="text" name="skindescription" value="default"/></td></tr>
  <tr>
    <td>Skin Set:</td>
    <td>
      <input type="text" name="skinset"></input>
    </td>
  </tr>
<!--<tr><td>File to upload: </td><td><input align="center" type="file" name="file" size="60" maxlength="255"/></td></tr>-->
<tr><td>Use frames: </td><td><input type="radio" name="useframes" value="1" /> Yes <input type="radio" name="useframes" value="0" checked="checked"/> No</td></tr>
<tr><td>Moderators email:</td><td><input type="text" name="ModeratorsEmail"/></td></tr>
<tr><td>Editors email:</td><td><input type="text" name="EditorsEmail"/></td></tr>
<tr><td>Feedback email:</td><td><input type="text" name="FeedbackEmail"/></td></tr>
<tr><td>Auto Message User ID</td><td><input type="text" name="AutoMessageUserID" value="294"/></td></tr>
<tr><td>Premoderation: </td><td><input type="radio" name="premoderation" value="1" /> Yes 
<input type="radio" name="premoderation" value="0" checked="checked" /> No	</td></tr>
<tr><td>Prevent cross-linking: </td><td><input type="radio" name="crosslink" value="1" /> Yes 
<input type="radio" name="crosslink" value="0" checked="checked" /> No	</td></tr>
<tr><td>Custom terms: </td><td><input type="radio" name="customterms" value="1" /> Yes 
<input type="radio" name="customterms" value="0" checked="checked" /> No	</td></tr>
<tr><td>Require Password: </td><td><input type="radio" name="passworded" value="1" checked="checked" /> Yes 
<input type="radio" name="passworded" value="0" /> No	</td></tr>
<tr><td>Unmoderated: </td><td><input type="radio" name="unmoderated" value="1" /> Yes 
<input type="radio" name="unmoderated" value="0" checked="checked" /> No	</td></tr>
<tr><td>Include crumbtrail: </td><td><input type="radio" name="includecrumbtrail" value="1" /> Yes 
<input type="radio" name="includecrumbtrail" value="0" checked="checked" /> No	</td></tr>
<table>
<tr>Thread Sort Order:<br />

<td></td></tr>
<tr><td>Creation Date</td>
<td><input type="radio" name="threadorder" value="createdate"/></td>
</tr>
<tr><td>Lastest Post (default)</td>
<td><input type="radio" name="threadorder" value="latestpost" checked="checked"/></td>
</tr>
<!--
<tr><td>Number of Messages</td>
<td><input type="radio" name="threadorder" value="nummessages"/>
</td>
</tr>
-->
</table>
<tr><td><input type="submit" name="newsite" value="Create Site"/></td><td/></tr>
</table>
</form>
</xsl:if>

</xsl:template>
<xsl:template match="*|@*" mode="checkedattribute">
		<xsl:if test=".=1">
			<xsl:attribute name="checked">checked</xsl:attribute>
		</xsl:if>
	</xsl:template>
	<xsl:template match="*|@*" mode="notcheckedattribute">
		<xsl:if test=".=0">
			<xsl:attribute name="checked">checked</xsl:attribute>
		</xsl:if>
	</xsl:template>



	<xsl:template match="CREATERESULT">
    <hr/>
		<xsl:choose>
			<xsl:when test="@RESULT='SUCCESS'">
Site created. <a href="/dna/{@URLNAME}/SiteAdmin">Click here to administer.</a>
				<br/>
			</xsl:when>
			<xsl:otherwise>
Failed to create new site - URL already exists<br/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="UPLOADRESULT">
    <hr/>
		<xsl:choose>
			<xsl:when test="SAVED">
Your stylesheet change has been uploaded successfully<br/>
			</xsl:when>
			<xsl:when test="UPLOADERROR">
There was a problem uploading your stylesheet<br/>
			</xsl:when>
			<xsl:when test="NOSUCHSKIN">
The skin name you chose does not exist in this site.<br/>
			</xsl:when>
			<xsl:when test="NOTALLOWED">
You are not allowed to upload core elements<br/>
			</xsl:when>
			<xsl:when test="COPYERROR">
Unable to copy the stylesheet. Try again or clear the templates.<br/>
			</xsl:when>
			<xsl:when test="PARSE-ERROR[@TYPE='runtime']">
Your stylesheet contains runtime errors. Make sure you haven't mistyped a variable name or template name.<br/>
			</xsl:when>
			<xsl:when test="PARSE-ERROR[@TYPE='parse']">
Your stylesheet is badly formed. An error was found on line <xsl:value-of select="PARSE-ERROR/LINE"/> at character <xsl:value-of select="PARSE-ERROR/CHARACTER"/>
				<br/>
Error: <xsl:value-of select="PARSE-ERROR/REASON"/>
				<PRE>
					<xsl:value-of select="PARSE-ERROR/SRCTEXT"/>
				</PRE>
				<br/>
			</xsl:when>
			<xsl:otherwise>
An unknown error occurred while uploading your stylesheet.<br/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>


<xsl:template match="PERMISSIONS">
<input type="hidden" name="setdefaults" value="1"/>
<table>
<tr>
<td class="permissionlabel">Club type</td><td class="permissionlabel">User type</td>
<td class="permissionlabel">AutoJoinMember</td>
<td class="permissionlabel">AutoJoinOwner</td>
<td class="permissionlabel">JoinMember</td>
<td class="permissionlabel">JoinOwner</td>
<td class="permissionlabel">ApproveMember</td>
<td class="permissionlabel">ApproveOwner</td>
<td class="permissionlabel">DemoteOwner</td>
<td class="permissionlabel">DemoteMember</td>
<td class="permissionlabel">ViewActions</td>
<td class="permissionlabel">ViewClub</td>
<td class="permissionlabel">PostJournal</td>
<td class="permissionlabel">PostCalendar</td>
<td class="permissionlabel">CanEdit</td>
</tr>
<tr><td>Open</td><td>Owner</td>
<xsl:apply-templates select="OPENCLUB/OWNER"/>
</tr>
<tr><td>Open</td><td>Member</td>
<xsl:apply-templates select="OPENCLUB/MEMBER"/>
</tr>
<tr><td>Open</td><td>User</td>
<xsl:apply-templates select="OPENCLUB/USER"/>
</tr>
<tr><td>Closed</td><td>Owner</td>
<xsl:apply-templates select="CLOSEDCLUB/OWNER"/>
</tr>
<tr><td>Closed</td><td>Member</td>
<xsl:apply-templates select="CLOSEDCLUB/MEMBER"/>
</tr>
<tr><td>Closed</td><td>User</td>
<xsl:apply-templates select="CLOSEDCLUB/USER"/>
</tr>
</table>

</xsl:template>

<xsl:template match="THREADORDER">

Thread Sort Order:

<table>
<tr><td>Creation Date</td>
<td><input type="radio" name="threadorder" value="createdate">
		<xsl:if test=".='createdate'"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if>
	</input>

</td>
</tr>
<tr><td>Lastest Post (default)</td>
<td><input type="radio" name="threadorder" value="latestpost">
		<xsl:if test=".='latestpost'"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if>
	</input>
</td>
</tr>
<!--
<tr><td>Number of Messages</td>
<td><input type="radio" name="threadorder" value="nummessages">
		<xsl:if test=".='nummessages'"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if>
	</input>
</td>
</tr>
-->
</table>

</xsl:template>

<xsl:template match="OPENCLUB/OWNER|OPENCLUB/MEMBER|OPENCLUB/USER|CLOSEDCLUB/OWNER|CLOSEDCLUB/MEMBER|CLOSEDCLUB/USER">
<xsl:apply-templates select="@CANAUTOJOINMEMBER"/>
<xsl:apply-templates select="@CANAUTOJOINOWNER"/>
<xsl:apply-templates select="@CANBECOMEMEMBER"/>
<xsl:apply-templates select="@CANBECOMEOWNER"/>
<xsl:apply-templates select="@CANAPPROVEMEMBERS"/>
<xsl:apply-templates select="@CANAPPROVEOWNERS"/>
<xsl:apply-templates select="@CANDEMOTEOWNERS"/>
<xsl:apply-templates select="@CANDEMOTEMEMBERS"/>
<xsl:apply-templates select="@CANVIEWACTIONS"/>
<xsl:apply-templates select="@CANVIEW"/>
<xsl:apply-templates select="@CANPOSTJOURNAL"/>
<xsl:apply-templates select="@CANPOSTCALENDAR"/>
<xsl:apply-templates select="@CANEDIT"/>
</xsl:template>

<xsl:template match="OPENCLUB/*/@*|CLOSEDCLUB/*/@*">
<xsl:variable name="prefix">
<xsl:if test="name(../..)='CLOSEDCLUB'">CLOSED</xsl:if>
<xsl:choose>
<xsl:when test="name(..)='OWNER'">CLUBOWNER</xsl:when>
<xsl:when test="name(..)='MEMBER'">CLUBMEMBER</xsl:when>
<xsl:when test="name(..)='USER'">CLUB</xsl:when>
</xsl:choose>
</xsl:variable>
<td align="center"><input type="checkbox" value="1">
<xsl:attribute name="name"><xsl:value-of select="concat($prefix,name(.))"/></xsl:attribute>
<xsl:if test=".=1"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if>
</input></td>
</xsl:template>


<xsl:template match="OPENCLUB/OWNER" mode="buttons">
<td>,,,</td>
<td>[</td>
<td>]<input type="checkbox"><xsl:if test="@CANAUTOJOINOWNER=1"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if></input></td>
<td>]<input type="checkbox"><xsl:if test="@CANBECOMEMEMBER=1"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if></input></td>
<td>[<input type="checkbox"><xsl:if test="@CANBECOMEOWNER=1"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if></input></td>
<td>]<input type="checkbox"><xsl:if test="@CANAPPROVEMEMBERS=1"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if></input></td>
<td>'<input type="checkbox"><xsl:if test="@CANAPPROVEOWNERS=1"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if></input></td>
<td>;<input type="checkbox"><xsl:if test="@CANDEMOTEOWNERS=1"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if></input></td>
<td>#<input type="checkbox"><xsl:if test="@CANDEMOTEMEMBERS=1"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if></input></td>
<td>;<input type="checkbox"><xsl:if test="@CANVIEWACTIONS=1"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if></input></td>
<td>.<input type="checkbox"><xsl:if test="@CANVIEW=1"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if></input></td>
<td>,<input type="checkbox"><xsl:if test="@CANPOSTJOURNAL=1"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if></input></td>
<td>/<input type="checkbox"><xsl:if test="@CANPOSTCALENDAR=1"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if></input></td>
</xsl:template>
</xsl:stylesheet>