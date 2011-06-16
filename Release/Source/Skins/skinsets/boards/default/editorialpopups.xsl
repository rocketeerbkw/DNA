<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<!-- ============================= -->
	<!-- ======== Edit post popup ======== -->
	<!-- ============================= -->
	<xsl:template match='H2G2[@TYPE="EDIT-POST"]'>
		<html>
			<head>
				<!-- prevent browsers caching the page -->
				<meta http-equiv="Cache-Control" content="no cache"/>
				<meta http-equiv="Pragma" content="no cache"/>
				<meta http-equiv="Expires" content="0"/>
				<META NAME="robots" CONTENT="{$robotsetting}"/>
				<title>h2g2 Moderation: Edit Post</title>
				<style type="text/css">
					<xsl:comment>
					DIV.ModerationTools A { color: blue}
					DIV.ModerationTools A.active { color: red}
					DIV.ModerationTools A.visited { color: darkblue}
					DIV.ModerationTools A:hover   { text-decoration: underline ! important; color: red}
				</xsl:comment>
				</style>
				<script language="JavaScript">
					<xsl:comment>
						<!--
			this variable will receive the instance of TextObject describing
			current document selection
			-->
			var g_Range;

			<!--
			function EasyTextSelected()

			Author:		Igor Loboda
			Created:	1/3/2002
			Inputs:		-
			Outputs:	-
			Returns:	-
			Purpose:	This function is called when user selected a string
						from the EasyText select control and replaces the
						text from TextRange specified in g_Range with the text
						from the select control
			-->
			function EasyTextSelected()
			{
				var insertText = document.TextForm.EasyText.item(
					document.TextForm.EasyText.selectedIndex).text
				document.TextForm.EasyText.value = 0;
				if (g_Range == null) //PostText did not have focus yet
				{
					document.TextForm.PostText.value += insertText;
					return;
				}

				g_Range.text = insertText;
				document.selection.empty();
			}

			<!--
			function MonitorSelectionByMouse()

			Author:		Igor Loboda
			Created:	1/3/2002
			Inputs:		-
			Outputs:	-
			Returns:	-
			Purpose:	When mouse button is clicked the instance of TextRange 
						should be filled with correct selection information by
						means of moveToPoint function
			-->
			function MonitorSelectionByMouse()
			{
				g_Range = document.selection.createRange();
				g_Range.moveToPoint(window.event.x, window.event.y);
			}

			<!--
			function MonitorSelectionByKeybord()

			Author:		Igor Loboda
			Created:	1/3/2002
			Inputs:		-
			Outputs:	-
			Returns:	-
			Purpose:	Just get the TextRange for the current document selecion.
			-->
			function MonitorSelectionByKeybord()
			{
				g_Range = document.selection.createRange();
			}

			//</xsl:comment>
				</script>
				<script language="javascript">

          function validate()
          {
          if(byPassValidation)
          {
            return true;
          }
          if(document.getElementById("textNotes").value == "")
          {
          alert("Please enter some notes for auditing purposes.");
          document.getElementById("textNotes").style.border="1px solid red";
          return false;
          }
          return confirm("Are you sure?");

          }
          var byPassValidation = false;

        </script>
				<link type="text/css" rel="stylesheet" href="/dnaimages/boards/includes/admin.css"/>
			</head>
			<body bgColor="ffffff">
				<font size="2">
					<div class="ModerationTools">
            <xsl:for-each select="POST-EDIT-FORM/MESSAGE">
              <b><xsl:value-of select="."/></b><BR/><BR/>
            </xsl:for-each>
						<xsl:choose>
							<xsl:when test="POST-EDIT-FORM/MESSAGE/@TYPE='UPDATE-OK'">
								<b>
									<br/>
									<a href="#" onClick="javascript:if (window.name == 'EditPostPopup') window.close()">Close window</a>
								</b>
							</xsl:when>
              <xsl:otherwise>
                <b>
                  Edit Post '<xsl:value-of select="POST-EDIT-FORM/SUBJECT"/>' by <xsl:apply-templates select="POST-EDIT-FORM/AUTHOR"/>
                </b>
                <br/>
                <a href="moderationhistory?postid={POST-EDIT-FORM/POST-ID}">View Moderation History</a>
                <form name="TextForm" method="post" action="{$root}EditPost" onSubmit="return validate();">
                  <input type="hidden" name="PostID" value="{POST-EDIT-FORM/POST-ID}"/>
                  Subject:
                  <input type="text" name="Subject" size="30">
                    <xsl:attribute name="value">
                      <xsl:value-of select="POST-EDIT-FORM/SUBJECT"/>
                    </xsl:attribute>
                  </input>
                  <br/>
                  Text:
                  <br/>
                  <textarea onkeyup="MonitorSelectionByKeybord()" onmousedown="MonitorSelectionByMouse()" onselect="MonitorSelectionByKeybord()" id="PostText" name="Text" cols="40" rows="10" wrap="virtual">
                    <xsl:value-of select="POST-EDIT-FORM/TEXT"/>
                  </textarea>
                  <br/>
                  <br/>
                  Date Posted: <xsl:apply-templates select="POST-EDIT-FORM/DATE-POSTED/DATE" mode="library_date_longformat"/>
                  <br/>
                  IP Address: <xsl:value-of select="POST-EDIT-FORM/IPADDRESS"/>
                  <br/>
                  BBCUID: <xsl:value-of select="POST-EDIT-FORM/BBCUID"/>
                  <br/>
                  <xsl:text>Insert Text:</xsl:text>
                  <select id="EasyText" onchange="EasyTextSelected()">
                    <option value="0" selected="1">Select text to insert:</option>
                    <option value="1">[Unsuitable link removed by Moderator]</option>
                    <option value="2">[Broken link removed by Moderator]</option>
                    <option value="2">[Personal details removed by Moderator]</option>
                  </select>
                  <br/>
                  <br/>
                  <xsl:choose>
                    <xsl:when test="POST-EDIT-FORM/HIDDEN&gt; 0">
                      <xsl:text>Post is hidden</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:text>Take Action:</xsl:text>
                      <select id="hidePostReason" name="hidePostReason">
                        <option value="">Leave Post Visible</option>
                        <xsl:apply-templates select="MOD-REASONS/MOD-REASON[@REASONID &lt; 12]" mode="HIDEREASON"/>
                      </select>
                    </xsl:otherwise>
                  </xsl:choose>
                  <br/>
                  Notes:<br />
                  <textarea name="notes" cols="35" id="textNotes"></textarea>
                  <!-- xsl:choose>
										<xsl:when test="POST-EDIT-FORM/HIDDEN &gt; 0">
											<span class="posthidden">(Post is currently hidden)</span>
										</xsl:when>
										<xsl:otherwise>
											<span class="posthidden">(Post is currently visible)</span>
										</xsl:otherwise>
									</xsl:choose -->
                  <br/>

                  <input type="submit" name="Update" onClick="byPassValidation=false;">
                    <xsl:choose>
                      <xsl:when test="POST-EDIT-FORM/HIDDEN&gt; 0">
                        <xsl:attribute name="value">Unhide Post</xsl:attribute>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:attribute name="value">Edit message</xsl:attribute>
                      </xsl:otherwise>
                    </xsl:choose>
                  </input>


                  <xsl:if test="$superuser = 1">
                    <hr/>
                    List other users that have the same BBCUID cookie:<br/>
                    <input type="submit" name="ListBBCUIDUsers" value="List Other Users"  onClick="byPassValidation=true;"/>
                  </xsl:if>
                </form>
                <xsl:apply-templates select="POST-EDIT-FORM/POSTSWITHSAMEBBCUID"/>
              </xsl:otherwise>
						</xsl:choose>
					</div>
				</font>
			</body>
		</html>
	</xsl:template>
	<!-- ================================ -->
	<!-- ======== Move thread popup ======== -->
	<!-- ================================ -->
	<xsl:template match='H2G2[@TYPE="MOVE-THREAD"]'>
		<html>
			<head>
				<title>h2g2 : Move Thread</title>
				<!-- javascript for thread moving popup -->
				<script language="javascript">
					<xsl:comment>
					submit = 0;
					function checkSubmit()
					{
						submit += 1;
						if (submit > 1) { alert("Request is being processed, please be patient."); return (false); }
						return (true);
				
					}

					function fetchDetails(threadID)
					{
						// build a js string to popup a window to move the given thread to the currently selected destination
						var selectObject = eval('document.forms.MoveThreadForm' + threadID + '.Select' + threadID);
						var forumID = selectObject.options[selectObject.selectedIndex].value;
						
						//msgbox("hello");
						var fieldObject = eval('document.forms.MoveThreadForm' + threadID + '.DestinationID');
						fieldObject.value = 'F' + forumID;
						// show screen for 'busy processing'
						// only do a fetch within the popup - not an automatic move
						//return eval('window.location.href=\'<xsl:value-of select="$root"/>MoveThread?cmd=Fetch?ThreadID=' + threadID + '&amp;DestinationID=F' + forumID + '&amp;mode=POPUP\'');
					}
				// </xsl:comment>
				</script>
				<link type="text/css" rel="stylesheet" href="/dnaimages/boards/includes/admin.css"/>
			</head>
			<body xsl:use-attribute-sets="body" onLoad="initButtons();">
				<font size="2">
					<xsl:apply-templates select="MOVE-THREAD-FORM"/>
				</font>
			</body>
		</html>
	</xsl:template>
	<xsl:template match="MOVE-THREAD-FORM">
		<form method="get" action="{$root}MoveThread" onSubmit="checkSubmit()">
			<xsl:attribute name="name">MoveThreadForm<xsl:value-of select="THREAD-ID"/></xsl:attribute>
			<input type="hidden" name="mode">
				<xsl:attribute name="value"><xsl:value-of select="/H2G2/@MODE"/></xsl:attribute>
			</input>
			<input type="hidden" name="AutoPostID">
				<xsl:attribute name="value"><xsl:value-of select="AUTO-POST-ID"/></xsl:attribute>
			</input>
			<xsl:if test="/H2G2/PARAMS/PARAM[NAME = 's_frommod']/VALUE=1">	
				<input type="hidden" name="s_frommod" value="1"/>
			</xsl:if>
			<xsl:choose>
				<xsl:when test="SUCCESS='1'">
					<b>Thread moved successfully!</b>
					<br/>
					<br/>
					<xsl:if test="not(/H2G2/PARAMS/PARAM[NAME = 's_frommod']/VALUE=1)">
						<script language="javascript">
							<xsl:comment>
								// force a reload on the opening window, if any
								if (window.opener != null)
								{
									window.opener.location.reload();
								}
							// </xsl:comment>
						</script>
					</xsl:if>
				</xsl:when>
				<xsl:when test="SUCCESS='0'">
					<b>
						<span xsl:use-attribute-sets="WarningMessageFont">Move failed!</span>
					</b>
				</xsl:when>
			</xsl:choose>
			<br/>
			<!-- display any error messages -->
			<xsl:for-each select="ERROR">
				<xsl:choose>
					<xsl:when test="@TYPE='INVALID-DESTINATION'">
						Destination was not a valid Forum, Article or User ID.<br/>
						<br/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="."/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>
			<xsl:choose>
				<xsl:when test="SUCCESS='1'">
					<a href="#" onClick="window.close()">Close Window</a>
					<br/>
					<br/>
					<a>
						<xsl:attribute name="HREF">#</xsl:attribute>
						<xsl:attribute name="onClick">window.opener.location='/dna/boards/F<xsl:value-of select="NEW-FORUM-ID"/>';window.close();</xsl:attribute>
					Close window and go to the forum you have just moved the page to</a>
				</xsl:when>
				<xsl:otherwise>
					<!-- display the form -->
					<script language="javascript">
						
					function showButtons(divId) {
	if (document.getElementById) {
		document.getElementById(divId).style.visibility='visible'
	} else if (document.all){ 
		document.all[divId].style.visibility='visible'
	}
}

function hideButtons(divId) {
	if (document.getElementById) {
		document.getElementById(divId).style.visibility='hidden'
	} else if (document.all){ 
		document.all[divId].style.visibility='hidden'
	}
}
				
				
function initButtons () {
	hideButtons('buttons');
	hideButtons('archivewarning');
	hideButtons('archivebutton');
	}		

			
					</script>
					<table width="100%" cellpadding="5" cellspacing="5" border="0">
						<tr valign="center">
							<td align="right">Move:</td>
							<td align="left">
								<input type="hidden" name="ThreadID" size="8">
									<xsl:attribute name="value"><xsl:value-of select="number(THREAD-ID)"/></xsl:attribute>
								</input>
								<xsl:if test="string-length(THREAD-SUBJECT) &gt; 0">
									<nobr>'<xsl:value-of select="THREAD-SUBJECT"/>'</nobr>
								</xsl:if>
							</td>
							<td>&nbsp;</td>
							<td width="100%">&nbsp;</td>
						</tr>
						<tr valign="center">
							<td align="right">To:</td>
							<td align="left" colspan="3">
								<select name="DestinationID">
									<xsl:copy-of select="$movedropdown"/>
								</select>
							</td>
						</tr>
						<!-- do the drop down menu -->
						<!--<tr valign="center">
					<td></td>
					<td align="left" colspan="3">
						<select>
							<xsl:attribute name="name">Select<xsl:value-of select="THREAD-ID"/></xsl:attribute>
							<xsl:attribute name="onChange">fetchDetails(<xsl:value-of select="THREAD-ID"/>)</xsl:attribute>
							<option value="0" selected="selected">Choose destination:</option>
							<option value="1"><xsl:if test="number(NEW-FORUM-ID) = 1"><xsl:attribute name="SELECTED">SELECTED</xsl:attribute></xsl:if>Junk</option>
							<option value="48874"><xsl:if test="number(NEW-FORUM-ID) = 48874"><xsl:attribute name="SELECTED">SELECTED</xsl:attribute></xsl:if>Peer Review</option>
							<option value="59234"><xsl:if test="number(NEW-FORUM-ID) = 59234"><xsl:attribute name="SELECTED">SELECTED</xsl:attribute></xsl:if>Peer Review Sin Bin</option>
							<option value="57153"><xsl:if test="number(NEW-FORUM-ID) = 57153"><xsl:attribute name="SELECTED">SELECTED</xsl:attribute></xsl:if>Writing Workshop</option>
							<option value="615"><xsl:if test="number(NEW-FORUM-ID) = 615"><xsl:attribute name="SELECTED">SELECTED</xsl:attribute></xsl:if>Feedback Forum</option>
							<option value="47997"><xsl:if test="number(NEW-FORUM-ID) = 47997"><xsl:attribute name="SELECTED">SELECTED</xsl:attribute></xsl:if>Editorial Feedback</option>
							<option value="47996"><xsl:if test="number(NEW-FORUM-ID) = 47996"><xsl:attribute name="SELECTED">SELECTED</xsl:attribute></xsl:if>Technical Feedback</option>
							<option value="47998"><xsl:if test="number(NEW-FORUM-ID) = 47998"><xsl:attribute name="SELECTED">SELECTED</xsl:attribute></xsl:if>Design Feedback</option>
							<option value="56584"><xsl:if test="number(NEW-FORUM-ID) = 56584"><xsl:attribute name="SELECTED">SELECTED</xsl:attribute></xsl:if>Business Feedback</option>
							<option value="47999"><xsl:if test="number(NEW-FORUM-ID) = 47999"><xsl:attribute name="SELECTED">SELECTED</xsl:attribute></xsl:if>Feature Suggestions</option>
							<option value="48000"><xsl:if test="number(NEW-FORUM-ID) = 48000"><xsl:attribute name="SELECTED">SELECTED</xsl:attribute></xsl:if>Bug Reports</option>
							<option value="24276"><xsl:if test="number(NEW-FORUM-ID) = 24276"><xsl:attribute name="SELECTED">SELECTED</xsl:attribute></xsl:if>GuideML Clinic</option>
							<option value="55683"><xsl:if test="number(NEW-FORUM-ID) = 55683"><xsl:attribute name="SELECTED">SELECTED</xsl:attribute></xsl:if>Community Soapbox</option>
							<option value="19585"><xsl:if test="number(NEW-FORUM-ID) = 19585"><xsl:attribute name="SELECTED">SELECTED</xsl:attribute></xsl:if>Ask h2g2</option>
							<option value="30859"><xsl:if test="number(NEW-FORUM-ID) = 30859"><xsl:attribute name="SELECTED">SELECTED</xsl:attribute></xsl:if>How Do I...?</option>
							<option value="0">Other</option>
						</select>
						<xsl:if test="FUNCTIONS/FETCH">
							<input type="submit" name="cmd" value="Fetch"/>
							<xsl:text> </xsl:text>
						</xsl:if>
						<br/>
					</td>
				</tr>-->
						<!-- do the textfield for custom message -->
						<tr valign="center">
							<td valign="top" align="right">Post:</td>
							<td align="left" colspan="3">
								<textarea name="PostContent" wrap="virtual" cols="25" rows="3">
									<xsl:value-of select="POST-CONTENT"/>
								</textarea>
							</td>
						</tr>
						<!-- insert the buttons requested -->
						<tr valign="center">
							<td colspan="2">
								<div id="formstuff" onClick="showButtons('buttons');hideButtons('formstuff')" style="border:1px #ff0000 solid;width:100px;text-align:center;cursor: pointer;position:absolute;">
									Move thread
								</div>
								
								<div id="buttons">
								Are you sure?<br/>
									<xsl:if test="FUNCTIONS/MOVE">
										<input type="submit" name="cmd" value="Move"/>
										<xsl:text> </xsl:text>
									</xsl:if>
									<!--
						<xsl:if test="FUNCTIONS/UNDO">
							<input type="submit" name="cmd" value="Undo"/>
							<xsl:text> </xsl:text>
						</xsl:if>
						-->
									<xsl:if test="FUNCTIONS/CANCEL">
										<input type="submit" value="No" onClick="window.close()"/>
									</xsl:if>
								</div>
																
							</td>
						</tr>
					</table>
					
					<table width="100%" cellpadding="5" cellspacing="5" border="0">
					<tr>	<td>
					<br/><br/><br/>
					<font size="2">
					<xsl:choose>
						<xsl:when test="(/H2G2/CURRENTSITEURLNAME = 'mb606' or /H2G2/CURRENTSITEURLNAME = 'mbtms' or /H2G2/CURRENTSITEURLNAME = 'mbfansforum' or /H2G2/CURRENTSITEURLNAME = 'mbscrumv')">
						<div id="archive" onClick="showButtons('archivewarning');showButtons('archivebutton');hideButtons('archive')"  style="border:1px #000000 solid;width:150px;text-align:center;cursor: pointer;position:absolute;">
						or Archive the discussion to stop people posting and move discussion to the archive area<br/>
						</div>
						<div id="archivewarning">"Before Archiving please make sure you are archiving early in the morning or late in the evening as it is very slow and should not be done lightly"<br/></div>
						<div id="archivebutton"   style="border:1px #000000 solid;width:150px;text-align:center;cursor: pointer;">
						<a href="{$root}Movethread?cmd=Move&amp;ThreadID={/H2G2/MOVE-THREAD-FORM/THREAD-ID}&amp;destinationid=F2767130" onClick="hideButtons('archivewarning');hideButtons('archivebutton');" >Archive</a></div>						
						</xsl:when>
						<xsl:otherwise>
						</xsl:otherwise>
					</xsl:choose>
					</font>
					</td></tr>
					</table>
					
				</xsl:otherwise>
			</xsl:choose>
		</form>
	</xsl:template>

  <xsl:template match="MOD-REASON" mode="HIDEREASON">
    <option>
      <xsl:attribute name="value">
        <xsl:value-of select="@EMAILNAME"/>
      </xsl:attribute>
      Hide because "<xsl:value-of select="@DISPLAYNAME"/>"
    </option>
  </xsl:template>
</xsl:stylesheet>
