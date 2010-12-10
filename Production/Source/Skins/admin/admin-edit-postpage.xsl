<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
<!--
	Post Editing page
-->

<xsl:template match='H2G2[@TYPE="EDIT-POST"]'>
	<html>
		<head>
			<!-- prevent browsers caching the page -->
			<meta http-equiv="Cache-Control" content="no cache"/>
			<meta http-equiv="Pragma" content="no cache"/>
			<meta http-equiv="Expires" content="0"/>
      <meta content="text/html; charset=ISO-8859-1" http-equiv="Content-Type" />
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
		</head>
		<body bgColor="lightblue">
			<div class="ModerationTools">
			<font face="Arial" size="2" color="black">
				<xsl:for-each select="POST-EDIT-FORM/MESSAGE">
          <b><xsl:value-of select="."/></b><BR/><BR/>
				</xsl:for-each>
				<b>Edit Post '<xsl:value-of select="POST-EDIT-FORM/SUBJECT"/>' by <xsl:apply-templates select="POST-EDIT-FORM/AUTHOR"/></b>
				<form name="TextForm" method="post" action="{$root}EditPost">
					<input type="hidden" name="PostID" value="{POST-EDIT-FORM/POST-ID}"/>
					Subject:
					<input type="text" name="Subject" size="44">
						<xsl:attribute name="value"><xsl:value-of select="POST-EDIT-FORM/SUBJECT"/></xsl:attribute>
            
					</input>
					<br/>
					Text:<br/>
					<textarea onkeyup="MonitorSelectionByKeybord()" 
							onmousedown="MonitorSelectionByMouse()"
							onselect="MonitorSelectionByKeybord()" id="PostText" 
							name="Text" cols="40" rows="15" wrap="virtual">
            <xsl:if test="not($superuser = 1 or (VIEWING-USER/USER/GROUPS/EDITOR and POST-EDIT-FORM/AUTHOR/USER/USERID = VIEWING-USER/USER/USERID))">
              <xsl:attribute name="readonly">readonly</xsl:attribute>
            </xsl:if>
						<xsl:value-of select="POST-EDIT-FORM/TEXT"/>
          </textarea>
					<br/>
					Date Posted: <xsl:apply-templates select="POST-EDIT-FORM/DATE-POSTED/DATE" />
					<br/>
					<xsl:if test="$superuser = 1">
					IP Address: <xsl:value-of select="POST-EDIT-FORM/IPADDRESS"/>
					<br/>
					BBCUID: <xsl:value-of select="POST-EDIT-FORM/BBCUID"/>
					<br/>
					<xsl:text>Easy Text:</xsl:text>
					<select id="EasyText" onchange="EasyTextSelected()">
						<option value="0" selected="1">Select text to insert:</option>
						<option value="1">[Unsuitable link removed by Moderator]</option>
						<option value="2">[Broken link removed by Moderator]</option>
						<option value="2">[Personal details removed by Moderator]</option>
					</select>
					<br/>
					  <xsl:text> Hide Post:</xsl:text>
						<input type="checkbox" name="HidePost" value="1">
							<xsl:if test="POST-EDIT-FORM/HIDDEN &gt; 0">
								<xsl:attribute name="checked">checked</xsl:attribute>
							</xsl:if>
						</input>
					</xsl:if>
					<xsl:choose>
						<xsl:when test="POST-EDIT-FORM/HIDDEN &gt; 0"> <font size="1">(Post is currently hidden)</font></xsl:when>
						<xsl:otherwise> <font size="1">(Post is currently visible)</font></xsl:otherwise>
					</xsl:choose>
                  <br/><br/>
          <xsl:if test="$superuser = 1 or (VIEWING-USER/USER/GROUPS/EDITOR and POST-EDIT-FORM/AUTHOR/USER/USERID = VIEWING-USER/USER/USERID)">
            <input type="submit" name="Update" value="Update"/>
          </xsl:if>
					<input type="submit" name="Cancel" value="Close" onClick="javascript:if (window.name == 'EditPostPopup') window.close()"/>
					<xsl:if test="$superuser = 1">
						<hr/>
						List other users that have the same BBCUID cookie:<br/>
						<input type="submit" name="ListBBCUIDUsers" value="List Other Users"/>
					</xsl:if>
				</form>
				<xsl:apply-templates select="POST-EDIT-FORM/POSTSWITHSAMEBBCUID"/>
			</font>
			</div>
		</body>
	</html>
</xsl:template>


<!--<xsl:template match='H2G2[@TYPE="EDIT-POST" and /H2G2/VIEWING-USER/USER/STATUS != 2]'>
	<html>
		<head>
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
			
		</head>
		<body bgColor="lightblue">
			<div class="ModerationTools">
			<font face="Arial" size="2" color="black">
				<xsl:for-each select="POST-EDIT-FORM/MESSAGE">
					<xsl:choose>
						<xsl:when test="@TYPE='UPDATE-OK'"><b>Post was updated successfully.<br/><br/></b></xsl:when>
						<xsl:otherwise><xsl:value-of select="."/></xsl:otherwise>
					</xsl:choose>
				</xsl:for-each>
				<p>
					<b>Showing Post '<xsl:value-of select="POST-EDIT-FORM/SUBJECT"/>' by <xsl:apply-templates select="POST-EDIT-FORM/AUTHOR"/></b>
				</p>
				
				<p>
					Post:<br/>
					<textarea id="PostText" name="Text" cols="40" rows="15" wrap="virtual" readonly="readonly">
						<xsl:value-of select="POST-EDIT-FORM/TEXT"/>
					</textarea>
				</p>
				<p>
					
				</p>
				<p>
					Date Posted: <xsl:apply-templates select="POST-EDIT-FORM/DATE-POSTED/DATE" />
				</p>
								
					
				<xsl:if test="$superuser = 1">
					<p>
						IP Address: <xsl:value-of select="POST-EDIT-FORM/IPADDRESS"/>
						<br/>
						BBCUID: <xsl:value-of select="POST-EDIT-FORM/BBCUID"/>
					</p>
				</xsl:if>
				<p>
					<xsl:choose>
						<xsl:when test="POST-EDIT-FORM/HIDDEN &gt; 0"> <font size="1">(Post is currently hidden)</font></xsl:when>
						<xsl:otherwise> <font size="1">(Post is currently visible)</font></xsl:otherwise>
					</xsl:choose>
				</p>
				<p>
					<button onClick="javascript:if (window.name == 'EditPostPopup') window.close()">Close</button>
				</p>
					
				<xsl:apply-templates select="POST-EDIT-FORM/POSTSWITHSAMEBBCUID"/>
			</font>
			</div>
		</body>
	</html>
</xsl:template>-->

	<xsl:template match="POSTSWITHSAMEBBCUID">
		<h3>Other posts that have the same BBCUID</h3>
		<table>
			<tr>
				<td>User</td>
				<td>Post</td>
				<td>Date posted</td>
			</tr>
			<xsl:apply-templates select="POST"/>
		</table>
	</xsl:template>

	<xsl:template match="POSTSWITHSAMEBBCUID/POST">
		<tr>
			<td>
				<a href="U{USERID}"><xsl:value-of select="USERNAME"/></a>
			</td>
			<td>
				<a href="F{FORUMID}?thread={THREADID}&amp;skip=0&amp;show={POSTINDEX+1}#p{ENTRYID}"><xsl:value-of select="ENTRYID"/></a>
			</td>
			<td>
				<xsl:apply-templates select="DATEPOSTED/DATE" />
			</td>
		</tr>
	</xsl:template>
</xsl:stylesheet>