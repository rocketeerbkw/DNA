<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
		<!-- HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH -->
	<!-- HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH -->
	<!-- HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH -->
	<!-- HHHHHHHHHHHHHH                                 HHHHHHHHHHHHHHHHHHHHH -->
	<!-- HHHHHHHHHHHHHH        IMAGE  MODERATION        HHHHHHHHHHHHHHHHHHHHH -->
	<!-- HHHHHHHHHHHHHH                                 HHHHHHHHHHHHHHHHHHHHH -->
	<!-- HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH -->
	<!-- HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH -->
	<!-- HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH -->
	<xsl:template match='H2G2[@TYPE="IMAGE-MODERATION"]'>
	<html>
		<head>
			<!-- prevent browsers caching the page -->
			<meta http-equiv="Cache-Control" content="no cache"/>
			<meta http-equiv="Pragma" content="no cache"/>
			<meta http-equiv="Expires" content="0"/>
			<META NAME="robots" CONTENT="{$robotsetting}"/>
			<title>h2g2 Moderation: Images</title>
			<style type="text/css">
				<xsl:comment>
					DIV.ModerationTools A { color: blue}
					DIV.ModerationTools A.active { color: red}
					DIV.ModerationTools A.visited { color: darkblue}
					DIV.ModerationTools A:hover   { text-decoration: underline ! important; color: red}
				</xsl:comment>
			</style>
			<script language="JavaScript">
				<![CDATA[
<!-- hide this script from non-javascript-enabled browsers
function IsEmpty(str)
{
	for (var i = 0; i < str.length; i++)
	{
		var ch = str.charCodeAt(i);
		if (ch > 32)
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
	if (value >= 0)
	{
		var i = 0;

		for (i = 0; i < document.ModerationForm.elements.length; i++)
		{
			if (document.ModerationForm.elements[i].name == 'Decision')
			{
				document.ModerationForm.elements[i].value = value;
			}
		}
	}
	return true;
}

function setAllReferTos(value,index)
{

	if (value >= 0)
	{
		var i =0;

		for (i=0; i < document.ModerationForm.elements.length; i++)
		{
			//finds the referto select node
			if (document.ModerationForm.elements[i].name == 'ReferTo')
			{	
				document.ModerationForm.elements[i].value = value;
				document.ModerationForm.elements[i].options[index].selected = true;
			}
		}
	}

	if (index > 0)
	{
		setAllDecisions(2);
		document.ModerationForm.DecideAll.value = 2;
	}
	return true;
}


function setAllFailedBecause(value,index)
{

	if (index >= 0)
	{
		var i = 0;

		for (i = 0; i < document.ModerationForm.elements.length; i++)
		{
			if (document.ModerationForm.elements[i].name == 'EmailType')
			{
				document.ModerationForm.elements[i].options[index].selected = true;
			}
		}
	}

	if (index > 0)
	{
		setAllDecisions(4);
		document.ModerationForm.DecideAll.value = 4;	 
	}

	return true;
}

function checkModerationForm()
{
	var totalPosts = 0;
	var i = 0;

	// first find the total number of posts being processed on this page
	for (i = 0; i < document.ModerationForm.elements.length; i++)
	{
		if (document.ModerationForm.elements[i].name == 'Decision')
		{
			totalPosts++;
		}
	}
	// then go through them all and check that all failed posts have 
	// been given a reason and all referred posts are given a note
	for (i = 1; i <= totalPosts; i++)
	{
		var emailElement = 'ModerationForm.EmailType' + i;
		var decisionElement = 'ModerationForm.Decision' + i;
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
				var customEmail = eval('ModerationForm.CustomEmailText' + i + '.value');
				if (IsEmpty(customEmail))
				{
					alert('Custom Email box should be filled if URL is selected as failure reason');
					eval('ModerationForm.CustomEmailText' + i + '.focus()')
					return false;
				}
			}
		}
		else
		if (decision == 2) //refer to
		{ 
			var notes = eval('ModerationForm.NotesArea' + i + '.value');
			if (IsEmpty(notes))
			{
				alert('Notes box should be filled if the post is referred');
				eval('ModerationForm.NotesArea' + i + '.focus()')
				return false;
			}
		}
	}
	return true;
}
// stop hiding -->
				]]>
			</script>
		</head>
		<body bgColor="lightblue">
			<div class="ModerationTools">
				<h2 align="center">
					Image Moderation :
					<xsl:if test="IMAGE-MODERATION-FORM/@REFERRALS = '1'">Referred </xsl:if>
					<xsl:choose>
						<xsl:when test="IMAGE-MODERATION-FORM/@TYPE='NEW'">New Images</xsl:when>
						<xsl:when test="IMAGE-MODERATION-FORM/@TYPE='COMPLAINTS'">Complaints</xsl:when>
						<xsl:otherwise>Unkown type</xsl:otherwise>
					</xsl:choose>
				</h2>
				<table width="100%">
					<tr>
						<td align = "left" valign="top">
								Logged in as <b><xsl:value-of select="/H2G2/VIEWING-USER/USER/USERNAME"/></b>
						</td>
						<td align = "right" valign="top">
							<a href="{$root}Moderate">Moderation Home Page</a>
						</td>
					</tr>
				</table>
				<br/>
				<!-- do an error messages -->
				<xsl:if test="IMAGE-MODERATION-FORM/ERROR">
					<span class="moderationformerror">
						<xsl:for-each select="IMAGE-MODERATION-FORM/ERROR">
							<b><xsl:value-of select="."/></b>
							<br/>
						</xsl:for-each>
					</span>
				</xsl:if>
				<!-- do any other messages -->
				<xsl:if test="IMAGE-MODERATION-FORM/MESSAGE">
						<xsl:choose>
							<xsl:when test="IMAGE-MODERATION-FORM/MESSAGE/@TYPE = 'NONE-LOCKED'">
								<b>You currently have no items of this type allocated to you for moderation. Select a type and click 'Process' to be 
								allocated the next batch of items of that type waiting to be moderated.</b>
								<br/>
							</xsl:when>
							<xsl:when test="IMAGE-MODERATION-FORM/MESSAGE/@TYPE = 'EMPTY-QUEUE'">
								<b>Currently there are no items of the specified type awaiting moderation.</b>
								<br/>
							</xsl:when>
							<xsl:otherwise>
								<b><xsl:value-of select="IMAGE-MODERATION-FORM/MESSAGE"/></b>
								<br/>
							</xsl:otherwise>
						</xsl:choose>
				</xsl:if>
				<form action="{$root}ModerateImages" method="post" name="ModerationForm" onSubmit="return checkModerationForm()">
					<xsl:if test="IMAGE-MODERATION-FORM/IMAGE">
						<table border="1" cellPadding="2" cellSpacing="0" width="100%">
							<!-- do the column headings -->
							<tbody>
								<!--tr align="left" vAlign="top">
									<td><b>Image</b></td>
									<td><b>Description</b></td>
									<td width="100%"><b>Preview</b></td>
									<td><b>Decision</b></td>
								</tr-->
							</tbody>
							<!-- and then fill the table -->
							<tbody align="left" vAlign="top">
								<xsl:for-each select="IMAGE-MODERATION-FORM/IMAGE">
									<tr>
										<td><b>ModId</b><br/><xsl:value-of select="MODERATION-ID"/>
										<br/><br/>
										<b>ImageId</b><br/><xsl:value-of select="IMAGE-ID"/></td>
										<!--td align="left" vAlign="top">
											<xsl:if test="/H2G2/SITE-LIST/SITE[NAME = 'ican']/@ID = SITEID">
												<xsl:attribute name="bgcolor">#ffff00</xsl:attribute>
											</xsl:if>
												<a target="ForumViewer">
													<xsl:attribute name="HREF"><xsl:value-of select="$root"/>F<xsl:value-of select="FORUM-ID"/>?thread=<xsl:value-of select="THREAD-ID"/>&amp;post=<xsl:value-of select="POST-ID"/>#p<xsl:value-of select="POST-ID"/></xsl:attribute>
													<xsl:value-of select="IMAGE-ID"/>
												</a>
												<br/>
												<br/>
												<xsl:apply-templates select="SITEID" mode="showfrom_mod_offsite"/-->
										<!--/td-->
										<!--td align="left" vAlign="top"><xsl:value-of select="IMAGE-DESCRIPTION"/></td-->
										<td align="left" vAlign="top" width="100%">
											<input type="hidden" name="ImageID">
												<xsl:attribute name="value"><xsl:value-of select="IMAGE-ID"/></xsl:attribute>
											</input>
											<input type="hidden" name="ModID">
												<xsl:attribute name="value"><xsl:value-of select="MODERATION-ID"/></xsl:attribute>
											</input>
											<input type="hidden" name="SiteID">
												<xsl:attribute name="value"><xsl:value-of select="SITEID"/></xsl:attribute>
											</input>
										<xsl:element name="img">
											<xsl:attribute name="src"><xsl:value-of select='/H2G2/IMAGE-MODERATION-FORM/IMAGE-RAW-URL-BASE'/><xsl:value-of select='IMAGE-FILE-NAME'/></xsl:attribute>
										</xsl:element>	
										<br/><br/>Live image:<br/><br/>
										<xsl:element name="img">
											<xsl:attribute name="src"><xsl:value-of select='/H2G2/IMAGE-MODERATION-FORM/IMAGE-PUBLIC-URL-BASE'/><xsl:value-of select='IMAGE-FILE-NAME'/></xsl:attribute>
										</xsl:element>	
										</td>
										<td rowspan="2" align="left" vAlign="top">
											<table width="100%" cellpadding="0" cellspacing="0">
												<tr>
													<td>
															<xsl:if test="/H2G2/IMAGE-MODERATION-FORM/@REFERRALS = 1">Referred by 
																<xsl:choose>
																	<xsl:when test="number(REFERRED-BY/USER/USERID) > 0"><xsl:apply-templates select="REFERRED-BY/USER"/></xsl:when>
																	<xsl:otherwise><span class="moderationformerror">Auto Referral</span></xsl:otherwise>
																</xsl:choose>
															</xsl:if>
													</td>
													<td align="right"><a target="_blank" href="{$root}ModerationHistory?ImageID={IMAGE-ID}">Show History</a></td>
												</tr>
												<tr>
													<td colspan="2">
															<xsl:if test="/H2G2/IMAGE-MODERATION-FORM/@TYPE='COMPLAINTS'">
																<input type="hidden" name="ComplainantID" value="{COMPLAINANT-ID}"/>
																<input type="hidden" name="CorrespondenceEmail" value="{CORRESPONDENCE-EMAIL}"/>
																Complaint from 
																<xsl:choose>
																	<xsl:when test="string-length(CORRESPONDENCE-EMAIL) > 0">
																		<a href="mailto:{CORRESPONDENCE-EMAIL}"><xsl:value-of select="CORRESPONDENCE-EMAIL"/></a>
																	</xsl:when>
																	<xsl:when test="number(COMPLAINANT-ID) > 0">Researcher <a href="{$root}U{COMPLAINANT-ID}">U<xsl:value-of select="COMPLAINANT-ID"/></a></xsl:when>
																	<xsl:otherwise>Anonymous Complainant</xsl:otherwise>
																</xsl:choose>
																<br/>
																<textarea cols="30" name="ComplaintText" rows="5" wrap="virtual"><xsl:value-of select="COMPLAINT-TEXT"/></textarea>
																<br/>
															</xsl:if>
													</td>
												</tr>
											</table>
												Notes<br/>
												<textarea ID="NotesArea{position()}" cols="30" name="Notes" rows="5" wrap="virtual"><xsl:value-of select="NOTES"/></textarea>
												<br/>
												<input type="button" name="EditPostButton" value="Edit Post" onClick="popupwindow('{$root}EditPost?PostID={POST-ID}', 'EditPostPopup', 'status=1,resizable=1,scrollbars=1,width=400,height=450')"/>
												&nbsp;
												<select name="Decision" id="Decision{position()}">
<!--													<option value="0">No Decision</option>-->
													<xsl:if test="/H2G2/IMAGE-MODERATION-FORM/@TYPE='COMPLAINTS'">
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
													<xsl:if test="/H2G2/IMAGE-MODERATION-FORM/@TYPE!='COMPLAINTS'">
														<option value="3" selected="selected">Pass</option>
														<option value="4">Fail</option>
													</xsl:if>
													<option value="2">Refer</option>
													<xsl:if test="/H2G2/IMAGE-MODERATION-FORM/@REFERRALS = 1">
														<option value="5">Unrefer</option>
													</xsl:if>
												</select>
												<br/>
												<select name="ReferTo" id="ReferTo{position()}" onChange="javascript:if (selectedIndex != 0) ModerationForm.Decision{position()}.value = 2">
													<xsl:apply-templates select="/H2G2/REFEREE-LIST">
													<xsl:with-param name="SiteID" select="SITEID" />
													</xsl:apply-templates>
												</select>
												&nbsp;
												<select name="EmailType" id="EmailType{position()}" onChange="javascript:if (ModerationForm.EmailType{position()}.selectedIndex != 0 &amp;&amp; ModerationForm.Decision{position()}.value != 4 &amp;&amp; ModerationForm.Decision{position()}.value !=6 ) ModerationForm.Decision{position()}.value = 4" title="Select a reason if you are failing this content">
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
													<textarea cols="30" rows="5" name="CustomEmailText" id="CustomEmailText{position()}" wrap="virtual"></textarea>
										</td>
									</tr>
									<tr align="left" vAlign="top">
										<td><b>Tag</b></td>
										<td><xsl:value-of select="IMAGE-DESCRIPTION"/></td>
									</tr>
									<tr><td colspan="3">&nbsp;</td></tr>
								</xsl:for-each>
							</tbody>
						</table>
					</xsl:if>
					<br/>
					<input type="hidden" name="Referrals">
						<xsl:attribute name="value"><xsl:value-of select="IMAGE-MODERATION-FORM/@REFERRALS"/></xsl:attribute>
					</input>
					<input type="hidden" name="Show">
						<xsl:attribute name="value"><xsl:value-of select="IMAGE-MODERATION-FORM/@TYPE"/></xsl:attribute>
					</input>
					<!-- form buttons -->
					<table width="100%">
						<tr>
							<td valign="top" align="left">
									<input type="submit" name="Next" value="Process" title="Process these posts and then fetch the next batch" alt="Process these posts and then fetch the next batch"/>
									<xsl:text> </xsl:text>
									<input type="submit" name="Done" value="Process &amp; go to Moderation Home" title="Process these posts and go to Moderation Home" alt="Process these posts and then go to Moderation Home"/>
							</td>
							<td valign="top" align="left">
								<xsl:if test="POST-IMAGE-FORM/POST">
										Set all decisions to:
										<select name="DecideAll" onChange="setAllDecisions(this.options[this.selectedIndex].value)">
											<option value="-1" selected="selected">Choose one:</option>
											<xsl:if test="/H2G2/IMAGE-MODERATION-FORM/@TYPE='COMPLAINTS'">
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
											<xsl:if test="/H2G2/IMAGE-MODERATION-FORM/@TYPE!='COMPLAINTS'">
												<option value="3">Pass</option>
												<option value="4">Fail</option>
											</xsl:if>
											<option value="2">Refer</option>
										</select>
								</xsl:if>
							</td>

							<!-- Referto all -->
	
							<td valign="top" align="left">
								<xsl:if test="IMAGE-MODERATION-FORM/POST">
										Refer to:												
										<select name="DecideAllReferTo" onChange="setAllReferTos(this.options.value,this.selectedIndex);">
											<xsl:apply-templates select="/H2G2/REFEREE-LIST">
											<xsl:with-param name="SiteID" select="SITEID" />
											</xsl:apply-templates>
										</select>
								</xsl:if>
							</td>

							<td valign="top" align="left">
								<xsl:if test="IMAGE-MODERATION-FORM/POST">
										Failed Because:												
										<select name="DecideAllFailedBecause" onChange="setAllFailedBecause(this.options.value,this.selectedIndex);">
											<xsl:call-template name="m_ModerationFailureMenuItems"/>
										</select>
								</xsl:if>
							</td>


						</tr>
					</table>
					<br/>
				</form>
		</div>
		</body>
	</html>
</xsl:template>
</xsl:stylesheet>