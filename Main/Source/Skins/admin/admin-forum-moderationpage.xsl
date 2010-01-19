<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<xsl:template match='H2G2[@TYPE="FORUM-MODERATION"]'>
		<html>
			<head>
				<!-- prevent browsers caching the page -->
				<meta http-equiv="Cache-Control" content="no cache"/>
				<meta http-equiv="Pragma" content="no cache"/>
				<meta http-equiv="Expires" content="0"/>
				<META NAME="robots" CONTENT="{$robotsetting}"/>
				<title>h2g2 Moderation: Forum Postings</title>
				<style type="text/css">
					<xsl:comment>
					DIV.ModerationTools A { color: blue}
					DIV.ModerationTools A.active { color: red}
					DIV.ModerationTools A.visited { color: darkblue}
					DIV.ModerationTools A:hover   { text-decoration: underline ! important; color: red}
				</xsl:comment>
				</style>
				<script language="JavaScript">
					<xsl:comment> hide this script from non-javascript-enabled browsers
function IsEmpty(str)
{
	for (var i = 0; i &lt; str.length; i++)
	{
		var ch = str.charCodeAt(i);
		if (ch &gt; 32)
		{
			return false;
		}
	}

	return true;
}

function popupwindow(link, target, parameters) 
{
	popupWin = window.open(link,target,parameters);
}

function setAllDecisions(value)
{
	if (value &gt;= 0)
	{
		var i = 0;

		for (i = 0; i &lt; document.ForumModerationForm.elements.length; i++)
		{
			if (document.ForumModerationForm.elements[i].name == 'Decision')
			{
				document.ForumModerationForm.elements[i].value = value;
			}
		}
	}
	return true;
}

function setAllReferTos(value,index)
{

	if (value &gt;= 0)
	{
		var i =0;

		for (i=0; i &lt; document.ForumModerationForm.elements.length; i++)
		{
			//finds the referto select node
			if (document.ForumModerationForm.elements[i].name == 'ReferTo')
			{	
				document.ForumModerationForm.elements[i].value = value;
				document.ForumModerationForm.elements[i].options[index].selected = true;
			}
		}
	}

	if (index &gt; 0)
	{
		setAllDecisions(2);
		document.ForumModerationForm.DecideAll.value = 2;
	}
	return true;
}


function setAllFailedBecause(value,index)
{

	if (index &gt;= 0)
	{
		var i = 0;

		for (i = 0; i &lt; document.ForumModerationForm.elements.length; i++)
		{
			if (document.ForumModerationForm.elements[i].name == 'EmailType')
			{
				document.ForumModerationForm.elements[i].options[index].selected = true;
			}
		}
	}

	if (index &gt; 0)
	{
		setAllDecisions(4);
		document.ForumModerationForm.DecideAll.value = 4;	 
	}

	return true;
}

function checkForumModerationForm()
{
	var totalPosts = 0;
	var i = 0;

	// first find the total number of posts being processed on this page
	for (i = 0; i &lt; document.ForumModerationForm.elements.length; i++)
	{
		if (document.ForumModerationForm.elements[i].name == 'Decision')
		{
			totalPosts++;
		}
	}
	// then go through them all and check that all failed posts have 
	// been given a reason and all referred posts are given a note
	for (i = 1; i &lt;= totalPosts; i++)
	{
		var emailElement = 'ForumModerationForm.EmailType' + i;
		var decisionElement = 'ForumModerationForm.Decision' + i;
		var email = eval(emailElement + '.options[' + emailElement + '.selectedIndex].value');
		var decision = eval(decisionElement + '.options[' + decisionElement + '.selectedIndex].value');

		if (decision == 4 || decision == 6)
		{
			if (email == 'None')
			{
				alert('You must specify a failure reason for all failed postings!');
				return false;
			}
			else
			if (email == 'URLInsert') 
			{
				//if failed with the URL reason - custom email field should be filled
				var customEmail = eval('ForumModerationForm.CustomEmailText' + i + '.value');
				if (IsEmpty(customEmail))
				{
					alert('Custom Email box should be filled if URL is selected as failure reason');
					eval('ForumModerationForm.CustomEmailText' + i + '.focus()')
					return false;
				}
			}
		}
		else
		if (decision == 2) //refer to
		{ 
			var notes = eval('ForumModerationForm.NotesArea' + i + '.value');
			if (IsEmpty(notes))
			{
				alert('Notes box should be filled if the post is referred');
				eval('ForumModerationForm.NotesArea' + i + '.focus()')
				return false;
			}
		}
	}
	return true;
}
// stop hiding -->
	</xsl:comment>
				</script>
			</head>
			<body bgColor="lightblue">
				<div class="ModerationTools">
					<font face="Arial" size="2" color="black">
						<h2 align="center">
					Forum Moderation : 
					<xsl:if test="POST-MODERATION-FORM/@REFERRALS = '1'">Referred </xsl:if>
							<xsl:choose>
								<xsl:when test="POST-MODERATION-FORM/@TYPE='LEGACY'">Legacy Posts</xsl:when>
								<xsl:when test="POST-MODERATION-FORM/@TYPE='NEW'">New Posts</xsl:when>
								<xsl:when test="POST-MODERATION-FORM/@TYPE='COMPLAINTS'">Complaints Posts</xsl:when>
								<xsl:otherwise>Unkown type</xsl:otherwise>
							</xsl:choose>
						</h2>
						<table width="100%">
							<tr>
								<td align="left" valign="top">
									<font face="Arial" size="2" color="black">
								Logged in as <b>
											<xsl:value-of select="/H2G2/VIEWING-USER/USER/USERNAME"/>
										</b>
									</font>
								</td>
								<td align="right" valign="top">
									<font face="Arial" size="2" color="black">
										<xsl:choose>
											<xsl:when test="POST-MODERATION-FORM/@FASTMOD = 1">
												<a href="{$root}Moderate?fastmod=1">Fastmod Home Page</a>
											</xsl:when>
											<xsl:otherwise>
												<a href="{$root}Moderate">Moderation Home Page</a>
											</xsl:otherwise>
										</xsl:choose>
									</font>
								</td>
							</tr>
						</table>
						<br/>
						<!-- do an error messages -->
						<xsl:if test="POST-MODERATION-FORM/ERROR">
							<font face="Arial" size="2" color="red">
								<xsl:for-each select="POST-MODERATION-FORM/ERROR">
									<b>
										<xsl:value-of select="."/>
									</b>
									<br/>
								</xsl:for-each>
							</font>
						</xsl:if>
						<!-- do any other messages -->
						<xsl:if test="POST-MODERATION-FORM/MESSAGE">
							<font face="Arial" size="2" color="black">
								<xsl:choose>
									<xsl:when test="POST-MODERATION-FORM/MESSAGE/@TYPE = 'NONE-LOCKED'">
										<b>You currently have no forum postings of this type allocated to you for moderation. Select a type and click 'Process' to be 
								allocated the next batch of postings of that type waiting to be moderated.</b>
										<br/>
									</xsl:when>
									<xsl:when test="POST-MODERATION-FORM/MESSAGE/@TYPE = 'EMPTY-QUEUE'">
										<b>Currently there are no forum postings of the specified type awaiting moderation.</b>
										<br/>
									</xsl:when>
									<xsl:otherwise>
										<b>
											<xsl:value-of select="POST-MODERATION-FORM/MESSAGE"/>
										</b>
										<br/>
									</xsl:otherwise>
								</xsl:choose>
							</font>
						</xsl:if>
						<form action="{$root}ModerateForums" method="post" name="ForumModerationForm" onSubmit="return checkForumModerationForm()">
							<xsl:if test="POST-MODERATION-FORM/@FASTMOD = 1">
								<input type="hidden" name="fastmod" value="1"/>
								<input type="hidden" name="notfastmod" value="0"/>
							</xsl:if>
							<xsl:if test="POST-MODERATION-FORM/POST">
								<table border="1" cellPadding="2" cellSpacing="0" width="100%">
									<!-- do the column headings -->
									<tbody>
										<tr align="left" vAlign="top">
											<td>
												<b>
													<font face="Arial" size="2" color="black">Post</font>
												</b>
											</td>
											<td>
												<b>
													<font face="Arial" size="2" color="black">Subject</font>
												</b>
											</td>
											<td width="100%">
												<b>
													<font face="Arial" size="2" color="black">Text</font>
												</b>
											</td>
											<td>
												<b>
													<font face="Arial" size="2" color="black">Decision</font>
												</b>
											</td>
										</tr>
									</tbody>
									<!-- and then fill the table -->
									<tbody align="left" vAlign="top">
										<xsl:for-each select="POST-MODERATION-FORM/POST">
											<tr>
												<td align="left" vAlign="top">
													<font face="Arial" size="2" color="black">
														<a target="ForumViewer">
															<xsl:attribute name="HREF"><xsl:value-of select="$root"/>F<xsl:value-of select="FORUM-ID"/>?thread=<xsl:value-of select="THREAD-ID"/>&amp;post=<xsl:value-of select="POST-ID"/>#p<xsl:value-of select="POST-ID"/></xsl:attribute>
															<xsl:value-of select="POST-ID"/>
														</a>
														<br/>
														<br/>
														<xsl:apply-templates select="SITEID" mode="showfrom_mod_offsite"/>
													</font>
													<input type="hidden" name="PostID">
														<xsl:attribute name="value"><xsl:value-of select="POST-ID"/></xsl:attribute>
													</input>
													<input type="hidden" name="ThreadID">
														<xsl:attribute name="value"><xsl:value-of select="THREAD-ID"/></xsl:attribute>
													</input>
													<input type="hidden" name="ForumID">
														<xsl:attribute name="value"><xsl:value-of select="FORUM-ID"/></xsl:attribute>
													</input>
													<input type="hidden" name="ModID">
														<xsl:attribute name="value"><xsl:value-of select="MODERATION-ID"/></xsl:attribute>
													</input>
													<input type="hidden" name="SiteID">
														<xsl:attribute name="value"><xsl:value-of select="SITEID"/></xsl:attribute>
													</input>
												</td>
												<td align="left" vAlign="top">
													<font face="Arial" size="2" color="black">
														<xsl:value-of select="SUBJECT"/>
													</font>
												</td>
												<td align="left" vAlign="top" width="100%">
													<font face="Arial" size="2" color="black">
														<xsl:apply-templates select="TEXT"/>
													</font>
												</td>
												<td align="left" vAlign="top">
													<table width="100%" cellpadding="0" cellspacing="0">
														<tr>
															<td>
																<font face="Arial" size="2" color="black">
																	<xsl:if test="/H2G2/POST-MODERATION-FORM/@REFERRALS = 1">Referred by 
																<xsl:choose>
																			<xsl:when test="number(REFERRED-BY/USER/USERID) > 0">
																				<xsl:apply-templates select="REFERRED-BY/USER"/>
																			</xsl:when>
																			<xsl:otherwise>
																				<font color="red">Auto Referral</font>
																			</xsl:otherwise>
																		</xsl:choose>
																	</xsl:if>
																</font>
															</td>
															<td align="right">
																<font face="Arial" size="2" color="black">
																	<a target="_blank" href="{$root}ModerationHistory?PostID={POST-ID}">Show History</a>
																</font>
															</td>
														</tr>
														<tr>
															<td colspan="2">
																<font face="Arial" size="2" color="black">
																	<xsl:if test="/H2G2/POST-MODERATION-FORM/@TYPE='COMPLAINTS'">
																		<input type="hidden" name="ComplainantID" value="{COMPLAINANT-ID}"/>
																		<input type="hidden" name="CorrespondenceEmail" value="{CORRESPONDENCE-EMAIL}"/>
																Complaint from 
																<xsl:choose>
																			<xsl:when test="string-length(CORRESPONDENCE-EMAIL) > 0">
																				<a href="mailto:{CORRESPONDENCE-EMAIL}">
																					<xsl:value-of select="CORRESPONDENCE-EMAIL"/>
																				</a>
																			</xsl:when>
																			<xsl:when test="number(COMPLAINANT-ID) > 0">Researcher <a href="{$root}U{COMPLAINANT-ID}">U<xsl:value-of select="COMPLAINANT-ID"/>
																				</a>
																			</xsl:when>
																			<xsl:otherwise>Anonymous Complainant</xsl:otherwise>
																		</xsl:choose>
																		<xsl:if test="COMPLAINANT-ID/@EDITOR=1">
																	 (editor)
																</xsl:if>
																		<br/>
																		<textarea cols="30" name="ComplaintText" rows="5" wrap="virtual">
																			<xsl:value-of select="COMPLAINT-TEXT"/>
																			<xsl:text> </xsl:text>
																		</textarea>
																		<br/>
																	</xsl:if>
																</font>
															</td>
														</tr>
													</table>
													<font face="Arial" size="2" color="black">
												Notes<br/>
														<textarea ID="NotesArea{position()}" cols="30" name="Notes" rows="5" wrap="virtual">
															<xsl:value-of select="NOTES"/>
															<xsl:text> </xsl:text>
														</textarea>
														<br/>
														<input type="button" name="EditPostButton" value="Edit Post" onClick="popupwindow('{$root}EditPost?PostID={POST-ID}', 'EditPostPopup', 'status=1,resizable=1,scrollbars=1,width=400,height=450')"/>
												&nbsp;
												<select name="Decision" id="Decision{position()}">
															<!--													<option value="0">No Decision</option>-->
															<xsl:if test="/H2G2/POST-MODERATION-FORM/@TYPE='COMPLAINTS'">
																<option value="3" selected="selected">
																	<xsl:value-of select="$m_modrejectpostingcomplaint"/>
																</option>
																<option value="4">
																	<xsl:value-of select="$m_modacceptpostingcomplaint"/>
																</option>
																<option value="6">
																	<xsl:value-of select="$m_modacceptandeditposting"/>
																</option>
															</xsl:if>
															<xsl:if test="/H2G2/POST-MODERATION-FORM/@TYPE!='COMPLAINTS'">
																<option value="3" selected="selected">Pass</option>
																<option value="4">Fail</option>
															</xsl:if>
															<option value="2">Refer</option>
															<xsl:if test="/H2G2/POST-MODERATION-FORM/@REFERRALS = 1">
																<option value="5">Unrefer</option>
															</xsl:if>
														</select>
														<br/>
														<select name="ReferTo" id="ReferTo{position()}" onChange="javascript:if (selectedIndex != 0) ForumModerationForm.Decision{position()}.value = 2">
															<xsl:apply-templates select="/H2G2/REFEREE-LIST">
																<xsl:with-param name="SiteID" select="SITEID"/>
															</xsl:apply-templates>
														</select>
												&nbsp;
												<select name="EmailType" id="EmailType{position()}" onChange="javascript:if (ForumModerationForm.EmailType{position()}.selectedIndex != 0 &amp;&amp; ForumModerationForm.Decision{position()}.value != 4 &amp;&amp; ForumModerationForm.Decision{position()}.value !=6 ) ForumModerationForm.Decision{position()}.value = 4" title="Select a reason if you are failing this content">
															<!--
													<option value="None" selected="selected">Failed because:</option>
													<option value="OffensiveInsert">Offensive</option>
													<option value="LibelInsert">Libellous</option>
													<option value="URLInsert">URL</option>
													<option value="PersonalInsert">Personal</option>
													<option value="AdvertInsert">Advertising</option>
													<option value="CopyrightInsert">Copyright</option>
													<option value="PoliticalInsert">Party Political</option>
													<option value="IllegalInsert">Illegal</option>
													<xsl:if test="/H2G2/VIEWING-USER/USER/GROUPS/EDITOR">
														<option value="Custom">Custom (enter below)</option>
													</xsl:if>
-->
															<xsl:call-template name="m_ModerationFailureMenuItems"/>
														</select>
														<br/>
														<xsl:choose>
															<xsl:when test="/H2G2/VIEWING-USER/USER/GROUPS/EDITOR">
													Text for Custom Email
												</xsl:when>
															<xsl:when test="/H2G2/VIEWING-USER/USER/GROUPS/MODERATOR and not(/H2G2/VIEWING-USER/USER/GROUPS/EDITOR)">
																<xsl:value-of select="$m_ModEnterURLandReason"/>
																<br/>
															</xsl:when>
															<xsl:otherwise>
													If this posting failed due to URLs, please list them here.
													Please note that this information will be sent to the researcher
													who wrote the posting, so please only type the URLs. 
													<br/>
															</xsl:otherwise>
														</xsl:choose>
														<textarea cols="30" rows="5" name="CustomEmailText" id="CustomEmailText{position()}" wrap="virtual"><xsl:text> </xsl:text></textarea>
													</font>
												</td>
											</tr>
										</xsl:for-each>
									</tbody>
								</table>
							</xsl:if>
							<br/>
							<input type="hidden" name="Referrals">
								<xsl:attribute name="value"><xsl:value-of select="POST-MODERATION-FORM/@REFERRALS"/></xsl:attribute>
							</input>
							<input type="hidden" name="Show">
								<xsl:attribute name="value"><xsl:value-of select="POST-MODERATION-FORM/@TYPE"/></xsl:attribute>
							</input>
							<!-- form buttons -->
							<table width="100%">
								<tr>
									<td valign="top" align="left">
										<font face="Arial" size="2" color="black">
											<input type="submit" name="Next" value="Process" title="Process these posts and then fetch the next batch" alt="Process these posts and then fetch the next batch"/>
											<xsl:text> </xsl:text>
											<input type="submit" name="Done" value="Process &amp; go to Moderation Home" title="Process these posts and go to Moderation Home" alt="Process these posts and then go to Moderation Home"/>
										</font>
									</td>
									<td valign="top" align="left">
										<xsl:if test="POST-MODERATION-FORM/POST">
											<font face="Arial" size="2" color="black">
										Set all decisions to:
										<select name="DecideAll" onChange="setAllDecisions(this.options[this.selectedIndex].value)">
													<!--											<option value="0">No Decision</option>-->
													<option value="-1" selected="selected">Choose one:</option>
													<xsl:if test="/H2G2/POST-MODERATION-FORM/@TYPE='COMPLAINTS'">
														<option value="3" selected="selected">
															<xsl:value-of select="$m_modrejectpostingcomplaint"/>
														</option>
														<option value="4">
															<xsl:value-of select="$m_modacceptpostingcomplaint"/>
														</option>
														<option value="6">
															<xsl:value-of select="$m_modacceptandeditposting"/>
														</option>
													</xsl:if>
													<xsl:if test="/H2G2/POST-MODERATION-FORM/@TYPE!='COMPLAINTS'">
														<option value="3">Pass</option>
														<option value="4">Fail</option>
													</xsl:if>
													<option value="2">Refer</option>
												</select>
											</font>
										</xsl:if>
									</td>
									<!-- Referto all -->
									<td valign="top" align="left">
										<xsl:if test="POST-MODERATION-FORM/POST">
											<font face="Arial" size="2" color="black">
										Refer to:												
										<select name="DecideAllReferTo" onChange="setAllReferTos(this.options.value,this.selectedIndex);">
													<xsl:apply-templates select="/H2G2/REFEREE-LIST">
														<xsl:with-param name="SiteID" select="/H2G2/CURRENTSITE"/>
													</xsl:apply-templates>
												</select>
											</font>
										</xsl:if>
									</td>
									<td valign="top" align="left">
										<xsl:if test="POST-MODERATION-FORM/POST">
											<font face="Arial" size="2" color="black">
										Failed Because:												
										<select name="DecideAllFailedBecause" onChange="setAllFailedBecause(this.options.value,this.selectedIndex);">
													<xsl:call-template name="m_ModerationFailureMenuItems"/>
												</select>
											</font>
										</xsl:if>
									</td>
								</tr>
							</table>
							<br/>
						</form>
					</font>
				</div>
			</body>
		</html>
	</xsl:template>
</xsl:stylesheet>