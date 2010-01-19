<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<!--<xsl:template match='H2G2[@TYPE="MOVE-THREAD" and @MODE="POPUP"]'>-->
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
			</head>
			<body xsl:use-attribute-sets="body">
				<font xsl:use-attribute-sets="mainfont">
					<xsl:apply-templates select="MOVE-THREAD-FORM"/>
				</font>
			</body>
		</html>
	</xsl:template>
	<xsl:template match="MOVE-THREAD-FORM">
	<form method="get" action="{$root}MoveThread" onSubmit="checkSubmit()">
		<xsl:attribute name="name">MoveThreadForm<xsl:value-of select="THREAD-ID"/></xsl:attribute>
		<font xsl:use-attribute-sets="mainfont">
			<input type="hidden" name="mode"><xsl:attribute name="value"><xsl:value-of select="/H2G2/@MODE"/></xsl:attribute></input>
			<input type="hidden" name="AutoPostID"><xsl:attribute name="value"><xsl:value-of select="AUTO-POST-ID"/></xsl:attribute></input>
			<xsl:if test="/H2G2/PARAMS/PARAM[NAME = 's_frommod']/VALUE=1">	
				<input type="hidden" name="s_frommod" value="1"/>
			</xsl:if>
			<xsl:choose>
				<xsl:when test="SUCCESS='1'">
					<font xsl:use-attribute-sets="mainfont"><b>Thread moved successfully!</b></font><br/>
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
					<b><font xsl:use-attribute-sets="WarningMessageFont">Move failed!</font></b>
				</xsl:when>
			</xsl:choose>
			<br/>
			<!-- display any error messages -->
			<xsl:for-each select="ERROR">
				<xsl:choose>
					<xsl:when test="@TYPE='INVALID-DESTINATION'">
						Destination was not a valid Forum, Article or User ID.<br/><br/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="."/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>
			<!-- display the form -->
			<table width="100%" cellpadding="0" cellspacing="0" border="0">
				<tr valign="center">
					<td align="right"><font xsl:use-attribute-sets="mainfont">Move:</font></td>
					<td align="left"><input type="text" name="ThreadID" size="8"><xsl:attribute name="value"><xsl:value-of select="number(THREAD-ID)"/></xsl:attribute></input></td>
					<td>&nbsp;</td>
					<td width="100%">
						<xsl:if test="string-length(THREAD-SUBJECT) &gt; 0"><nobr><font xsl:use-attribute-sets="mainfont">'<xsl:value-of select="THREAD-SUBJECT"/>'</font></nobr></xsl:if>
					</td>
				</tr>
				<tr valign="center">
					<td align="right"><font xsl:use-attribute-sets="mainfont">To:</font></td>
					<td align="left"><input type="text" name="DestinationID" size="8"><xsl:attribute name="value">F<xsl:value-of select="number(NEW-FORUM-ID)"/></xsl:attribute></input></td>
					<td>&nbsp;</td>
					<td width="100%">
						<xsl:if test="string-length(NEW-FORUM-TITLE) &gt; 0"><font xsl:use-attribute-sets="mainfont">'<xsl:value-of select="NEW-FORUM-TITLE"/>'</font></xsl:if>
					</td>
				</tr>
				<!-- do the drop down menu -->
				<tr valign="center">
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
							<option value="2137311"><xsl:if test="number(NEW-FORUM-ID) = 2137311"><xsl:attribute name="SELECTED">SELECTED</xsl:attribute></xsl:if>Games Room</option>
							<option value="16034"><xsl:if test="number(NEW-FORUM-ID) = 16034"><xsl:attribute name="SELECTED">SELECTED</xsl:attribute></xsl:if>Miscellaneous Chat</option>
							<option value="0">Other</option>
						</select>
						<xsl:if test="FUNCTIONS/FETCH">
							<input type="submit" name="cmd" value="Fetch"/>
							<xsl:text> </xsl:text>
						</xsl:if>
						<br/>
					</td>
				</tr>
				<!-- do the textfield for custom message -->
				<tr valign="center">
					<td valign="top" align="right"><font xsl:use-attribute-sets="mainfont">Post:</font></td>
					<td align="left" colspan="3">
						<textarea name="PostContent" wrap="virtual" cols="25" rows="3"><xsl:value-of select="POST-CONTENT"/></textarea>
					</td>
				</tr>
				<!-- insert the buttons requested -->
				<tr valign="center">
					<td></td>
					<td align="left" colspan="3">
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
							<input type="submit" value="Close" onClick="window.close()"/>
						</xsl:if>
					</td>
				</tr>
			</table>
		</font>
	</form>
</xsl:template>
</xsl:stylesheet>