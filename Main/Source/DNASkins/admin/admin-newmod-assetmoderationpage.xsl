<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
									Page - Level  template
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<!-- 
	<xsl:template name="MEDIAASSET-MODERATION_MAINBODY">
	Author:		Andy Harris
	Context:     /H2G2
	Purpose:	 Main body template
	-->
	<xsl:template name="MEDIAASSET-MODERATION_MAINBODY">
		<script language="JavaScript"><![CDATA[
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

		for (i = 0; i < document.ModerateMediaAssetsForm.elements.length; i++)
		{
			if (document.ModerateMediaAssetsForm.elements[i].name == 'Decision')
			{
				document.ModerateMediaAssetsForm.elements[i].value = value;
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

		for (i=0; i < document.ModerateMediaAssetsForm.elements.length; i++)
		{
			//finds the referto select node
			if (document.ModerateMediaAssetsForm.elements[i].name == 'ReferTo')
			{	
				document.ModerateMediaAssetsForm.elements[i].value = value;
				document.ModerateMediaAssetsForm.elements[i].options[index].selected = true;
			}
		}
	}

	if (index > 0)
	{
		setAllDecisions(2);
		document.ModerateMediaAssetsForm.DecideAll.value = 2;
	}
	return true;
}


function setAllFailedBecause(value,index)
{

	if (index >= 0)
	{
		var i = 0;

		for (i = 0; i < document.ModerateMediaAssetsForm.elements.length; i++)
		{
			if (document.ModerateMediaAssetsForm.elements[i].name == 'EmailType')
			{
				document.ModerateMediaAssetsForm.elements[i].options[index].selected = true;
			}
		}
	}

	if (index > 0)
	{
		setAllDecisions(4);
		document.ModerateMediaAssetsForm.DecideAll.value = 4;	 
	}

	return true;
}

function checkMediaAssetsForm()
{
	var totalPosts = 0;
	var i = 0;

	// first find the total number of posts being processed on this page
	for (i = 0; i < document.ModerateMediaAssetsForm.elements.length; i++)
	{
		if (document.ModerateMediaAssetsForm.elements[i].name == 'Decision')
		{
			totalPosts++;
		}
	}
	// then go through them all and check that all failed posts have 
	// been given a reason and all referred posts are given a note
	for (i = 1; i <= totalPosts; i++)
	{
		var emailElement = 'ModerateMediaAssetsForm.EmailType' + i;
		var decisionElement = 'ModerateMediaAssetsForm.Decision' + i;
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
				var customEmail = eval('ModerateMediaAssetsForm.CustomEmailText' + i + '.value');
				if (IsEmpty(customEmail))
				{
					alert('Custom Email box should be filled if URL is selected as failure reason');
					eval('ModerateMediaAssetsForm.CustomEmailText' + i + '.focus()')
					return false;
				}
			}
		}
		else
		if (decision == 2) //refer to
		{ 
			var notes = eval('ModerateMediaAssetsForm.NotesArea' + i + '.value');
			if (IsEmpty(notes))
			{
				alert('Notes box should be filled if the post is referred');
				eval('ModerateMediaAssetsForm.NotesArea' + i + '.focus()')
				return false;
			}
		}
	}
	return true;
}
// stop hiding -->
				]]></script>
		<ul id="classNavigation">
			<xsl:for-each select="/H2G2/MODERATION-CLASSES/MODERATION-CLASS">
				<li>
					<xsl:attribute name="class"><xsl:choose><xsl:when test="@CLASSID = /H2G2/PARAMS/PARAM[NAME = 's_classview']/VALUE">selected</xsl:when><xsl:otherwise>unselected</xsl:otherwise></xsl:choose></xsl:attribute>
					<xsl:attribute name="id">modClass<xsl:value-of select="@CLASSID"/></xsl:attribute>
					<a href="#">
						<xsl:attribute name="href">moderateposts?modclassid=<xsl:value-of select="@CLASSID"/>&amp;s_classview=<xsl:value-of select="@CLASSID"/></xsl:attribute>
						<xsl:value-of select="NAME"/>
					</a>
				</li>
			</xsl:for-each>
		</ul>
		<!-- do an error messages -->
		<xsl:if test="/H2G2/ERROR">
			<span class="moderationformerror">
				<xsl:for-each select="/H2G2/ERROR">
					<b>
						<xsl:value-of select="."/>
					</b>
					<br/>
				</xsl:for-each>
			</span>
		</xsl:if>
		<form action="{$root}ModerateMediaAssets" method="post" name="ModerateMediaAssetsForm" onSubmit="return checkMediaAssetsForm()">
			<!--<form action="moderateposts" method="post">-->
			<div id="mainContent">
				<xsl:apply-templates select="MEDIAASSETMODERATION" mode="crumbtrail"/>
				<xsl:call-template name="checkmediaalerts_strip"/>
				<xsl:apply-templates select="MEDIAASSETMODERATION" mode="lockedby_strip"/>
				<xsl:apply-templates select="MEDIAASSETMODERATION" mode="post_list"/>
			</div>
			<div id="processButtons">
				<input type="submit" value="Process &amp; Continue" name="next" title="Process these posts and then fetch the next batch" alt="Process these posts and then fetch the next batch" id="continueButton"/>
				<input type="submit" value="Process &amp; Return to Main" name="done" title="Process these posts and go to Moderation Home" alt="Process these posts and then go to Moderation Home" id="returnButton"/>
			</div>
		</form>
	</xsl:template>
	<xsl:template match="MEDIAASSETMODERATION" mode="crumbtrail">
		<p class="crumbtrail">
			<a href="moderate">
				<xsl:text>Main</xsl:text>
			</a>
			<xsl:choose>
				<xsl:when test="@ALERTS = 1">
					<xsl:text> &gt; Alerts re: Media Assets</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text> &gt; Media Assets</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:apply-templates select="/H2G2/FEEDBACK" mode="mediaasset_feedback_strip"/>
		</p>
	</xsl:template>
	<xsl:template match="FEEDBACK" mode="mediaasset_feedback_strip">
		<xsl:choose>
			<xsl:when test="not(@PROCESSED = 0)">
				<span id="feedback-info">
					<xsl:value-of select="@PROCESSED"/>
					<xsl:text> media assets have been processed</xsl:text>
				</span>
			</xsl:when>
			<xsl:otherwise/>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="checkmediaalerts_strip">
		<xsl:if test="not(@ALERTS = 1)">
			<a href="#" onclick="getAlerts('FORUMS', 'FORUMS-FASTMOD')" id="checkAlerts">
				<xsl:text>Check for alerts &gt; &gt;</xsl:text>
			</a>
			<div id="alertResponse"/>
		</xsl:if>
	</xsl:template>
	<xsl:template match="MEDIAASSETMODERATION" mode="lockedby_strip">
		<xsl:choose>
			<xsl:when test="$superuser = 1"/>
			<xsl:otherwise>
				<p id="lockedby">
					<xsl:text>Locked by </xsl:text>
					<xsl:value-of select="POST[1]/LOCKED/USER/USERNAME"/>
					<xsl:text> at </xsl:text>
					<xsl:apply-templates select="POST[1]/LOCKED/DATELOCKED/DATE" mode="mod-system-format"/>
					<xsl:text>.</xsl:text>
				</p>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="MEDIAASSETMODERATION" mode="post_list">
		<xsl:apply-templates select="MEDIAASSET" mode="post_list"/>
	</xsl:template>
	<xsl:template match="MEDIAASSET" mode="post_list">
		<xsl:apply-templates select="." mode="location_bar"/>
		<xsl:apply-templates select="." mode="discussion_status"/>
		<xsl:apply-templates select="USER" mode="mediauser_info"/>
		<xsl:apply-templates select="." mode="media_info"/>
		<xsl:apply-templates select="ALERT/USER" mode="complaintuser_info"/>
		<xsl:apply-templates select="ALERT" mode="complaint_info"/>
		<xsl:apply-templates select="REFERRED/USER" mode="referringuser_info"/>
		<xsl:apply-templates select="REFERRED" mode="referred_info"/>
		<xsl:apply-templates select="." mode="mod_form"/>
	</xsl:template>
	<xsl:template match="MEDIAASSETMODERATION/MEDIAASSET" mode="location_bar">
		<input type="hidden" name="MEDIAASSETID" value="{@ID}"/>
		<input type="hidden" name="ModID" value="{@MODERATION-ID}"/>
		<input type="hidden" name="SiteID" value="{SITEID}"/>
		<p>
			<xsl:attribute name="class"><xsl:choose><xsl:when test="$test_IsEditor">postInfoBar</xsl:when><xsl:otherwise>postInfoBar withOut</xsl:otherwise></xsl:choose></xsl:attribute>
			<xsl:number/>
			<xsl:text>/</xsl:text>
			<xsl:value-of select="../@COUNT"/>
			<xsl:text> </xsl:text>
			<xsl:value-of select="/H2G2/SITE-LIST/SITE[@ID = current()/SITEID]/SHORTNAME"/>
		</p>
	</xsl:template>
	<xsl:template match="MEDIAASSETMODERATION/MEDIAASSET" mode="discussion_status">
		<xsl:if test="$test_IsEditor">
			<div class="threadStatus">
				<xsl:text>&nbsp;</xsl:text>
				<br/>
				<!--<select name="threadmoderationstatus">
					<option value="1">no moderation</option>
					<option value="2">post moderation</option>
					<option value="3">pre moderation</option>
				</select>-->
			</div>
		</xsl:if>
	</xsl:template>
	<xsl:template match="USER" mode="mediauser_info">
		<p class="postUserBar">
			<xsl:choose>
				<xsl:when test="$test_IsEditor">
					<xsl:apply-templates select="STATUS" mode="user_status"/>
					<xsl:value-of select="USERNAME"/>
					<xsl:text> </xsl:text>
					<a href="memberdetails?siteid={../SITEID}&amp;userid={USERID}&amp;s_classview={/H2G2/PARAMS/PARAM[NAME = 's_classview']/VALUE}">[member profile]</a>
				</xsl:when>
				<xsl:otherwise>member</xsl:otherwise>
			</xsl:choose>
		</p>
	</xsl:template>
	<xsl:template match="MEDIAASSETMODERATION/MEDIAASSET" mode="media_info">
		<div class="mediaasset">
			<xsl:variable name="mediaassetpath">
				<xsl:value-of select="@ID"/>
			</xsl:variable>
			<xsl:variable name="mediaassetsuffix">
				<xsl:choose>
					<xsl:when test="MIMETYPE='image/jpeg' or MIMETYPE='image/pjpeg'">
					_article.jpg
				</xsl:when>
					<xsl:when test="MIMETYPE='image/gif'">
					_article.gif
				</xsl:when>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="ftppath">
				<xsl:value-of select="FTPPATH"/>
			</xsl:variable>
			<xsl:choose>
				<xsl:when test="@CONTENTTYPE='1'">
					<img src="{$assetlibrary}{$ftppath}{$mediaassetpath}{$mediaassetsuffix}.mod"/>
				</xsl:when>
				<xsl:when test="@CONTENTTYPE='2'">
					<a href="{$assetlibrary}{$ftppath}{$mediaassetpath}.mod">Click here to play Audio Asset </a>
				</xsl:when>
				<xsl:when test="@CONTENTTYPE='3'">
					<a href="{$assetlibrary}{$ftppath}{$mediaassetpath}.mod">Click here to play Video Asset</a>
				</xsl:when>
			</xsl:choose>
		</div>
		<xsl:if test="LOCKED">
			<div class="mediaassetinfo">
				<strong>Locked By:</strong>
				<xsl:apply-templates select="LOCKED/USER"/>
				<br/>
				<strong>Locked Date:</strong>
				<xsl:apply-templates select="LOCKED/DATELOCKED"/>
			</div>
		</xsl:if>
		<xsl:if test="ALERT">
			<input type="hidden" name="alerts" value="1"/>
		</xsl:if>
		<xsl:if test="REFERRED">
			<input type="hidden" name="referrals" value="1"/>
		</xsl:if>
		<xsl:if test="LOCKED">
			<input type="hidden" name="locked" value="1"/>
		</xsl:if>
		<div class="mediaassetinfo">
			<strong>Media Asset ID: </strong>
			<xsl:value-of select="@ID"/>
		</div>
		<div class="mediaassetinfo">
			<strong>Caption: </strong>
			<xsl:value-of select="CAPTION"/>
		</div>
		<div class="mediaassetinfo">
			<strong>Description: </strong>
			<xsl:value-of select="DESCRIPTION"/>
		</div>
		<div class="mediaassetinfo">
			<strong>Filename: </strong>
			<xsl:value-of select="FILENAME"/>
		</div>
		<div class="mediaassetinfo">
			<input type="hidden" name="MimeType">
				<xsl:attribute name="value"><xsl:value-of select="MIMETYPE"/></xsl:attribute>
			</input>
			<strong>Mime type: </strong>
			<xsl:value-of select="MIMETYPE"/>
		</div>
		<xsl:if test="PHRASES">
			<div class="mediaassetinfo">
				<strong>Key phrases:</strong>
				<br/>
				<xsl:apply-templates select="PHRASES" mode="DiassociateAssetPhrases">
					<xsl:with-param name="moditempos" select="position()"/>
				</xsl:apply-templates>
			</div>
		</xsl:if>
	</xsl:template>
	<xsl:template match="PHRASES" mode="DiassociateAssetPhrases">
		<xsl:param name="moditempos"/>
		<xsl:for-each select="PHRASE">
			<xsl:value-of select="NAME"/>
			<input id="Chk{NAME}" name="DiassociateAssetPhrases{$moditempos}" value="{NAME}" type="checkbox"/> diassociate<br/>
		</xsl:for-each>
	</xsl:template>
	<xsl:template match="USER" mode="complaintuser_info">
		<p class="alertUserBar">
			<xsl:choose>
				<xsl:when test="$test_IsEditor">
					<xsl:apply-templates select="STATUS" mode="user_status"/>
					<xsl:value-of select="USERNAME"/>
					<xsl:text> </xsl:text>
					<a href="memberdetails?siteid={../SITEID}&amp;userid={USERID}&amp;s_classview={/H2G2/PARAMS/PARAM[NAME = 's_classview']/VALUE}">[member profile]</a>
				</xsl:when>
				<xsl:otherwise>member</xsl:otherwise>
			</xsl:choose>
			<xsl:text> raised an alert (submitted at </xsl:text>
			<xsl:apply-templates select="../DATEQUEUED/DATE"/>
			<xsl:text>)</xsl:text>
		</p>
	</xsl:template>
	<xsl:template match="ALERT" mode="complaint_info">
		<p class="alertContent">
			<xsl:value-of select="TEXT"/>
		</p>
	</xsl:template>
	<xsl:template match="USER" mode="referringuser_info">
		<p class="referredUserBar">
			<xsl:apply-templates select="../DATEREFERRED/DATE"/>
			<xsl:text> referred by </xsl:text>
			<xsl:value-of select="USERNAME"/>
			<xsl:text> to </xsl:text>
			<xsl:value-of select="../../LOCKED/USER/USERNAME"/>
			<xsl:text> because:</xsl:text>
		</p>
	</xsl:template>
	<xsl:template match="REFERRED" mode="referred_info">
		<p class="referredContent">
			<xsl:value-of select="TEXT"/>
		</p>
	</xsl:template>
	<xsl:template match="MEDIAASSETMODERATION/MEDIAASSET" mode="mod_form">
		<br clear="all"/>
		<div class="postForm" id="form{@ID}">
			<table width="100%" cellpadding="0" cellspacing="0">
				<tr>
					<td>
						<xsl:if test="REFERRED">Referred by:
														<xsl:choose>
								<xsl:when test="number(REFERRED/USER/USERID) > 0">
									<xsl:apply-templates select="REFERRED/USER"/>
								</xsl:when>
								<xsl:otherwise>
									<span class="moderationformerror">Auto Referral</span>
								</xsl:otherwise>
							</xsl:choose>
							<BR/>Date Referred: <xsl:apply-templates select="REFERRED/DATEREFERRED"/>
						</xsl:if>
					</td>
					<td align="right">
						<a target="_blank" href="{$root}ModerationHistory?PostID={@POSTID}">Show History</a>
					</td>
				</tr>
				<tr>
					<td colspan="2">
						<xsl:if test="ALERT">
							<input type="hidden" name="ComplainantID" value="{ALERT/COMPLAINANT-ID}"/>
							<input type="hidden" name="CorrespondenceEmail" value="{ALERT/CORRESPONDENCE-EMAIL}"/>
							<BR/>Date Submitted: <xsl:apply-templates select="ALERT/DATESUBMITTED"/>
																Complaint from Researcher <xsl:apply-templates select="ALERT/USER"/>
							<xsl:apply-templates select="ALERT/USER/USERMEMBERTAGS"/>
							<br/>
							<textarea cols="30" name="ComplaintText" rows="5" wrap="virtual">
								<xsl:value-of select="ALERT/TEXT"/>
							</textarea>
							<br/>
						</xsl:if>
					</td>
				</tr>
			</table>
											Notes<br/>
			<textarea ID="NotesArea{position()}" cols="30" name="Notes" rows="5" wrap="virtual">
				<xsl:value-of select="REFERRED/TEXT"/>
			</textarea>
			<br/>
			<input type="button" name="EditPostButton" value="Edit Post" onClick="popupwindow('{$root}EditPost?PostID={@POSTID}', 'EditPostPopup', 'status=1,resizable=1,scrollbars=1,width=400,height=450')"/>
											&nbsp;
											<select name="Decision" id="Decision{position()}">
				<xsl:choose>
					<xsl:when test="/H2G2/MEDIAASSET-MODERATION/MEDIAASSETMODERATION/@ALERTS=1">
						<option value="3" selected="selected">
							<xsl:value-of select="$m_modrejectpostingcomplaint"/>
						</option>
						<option value="4">
							<xsl:value-of select="$m_modacceptpostingcomplaint"/>
						</option>
						<option value="6">
							<xsl:value-of select="$m_modacceptandeditposting"/>
						</option>
					</xsl:when>
					<xsl:otherwise>
						<option value="3" selected="selected">Pass</option>
						<option value="4">Fail</option>
					</xsl:otherwise>
				</xsl:choose>
				<option value="2">Refer</option>
				<xsl:if test="REFERRED">
					<option value="5">Unrefer</option>
				</xsl:if>
				<option value="7">Hold</option>
			</select>
			<br/>
			<select name="ReferTo" id="ReferTo{position()}" onChange="javascript:if (selectedIndex != 0) ModeratePostsForm.Decision{position()}.value = 2">
				<xsl:apply-templates select="/H2G2/REFEREE-LIST">
					<xsl:with-param name="SiteID" select="SITEID"/>
				</xsl:apply-templates>
			</select>
											&nbsp;
											<select name="EmailType" id="EmailType{position()}" onChange="javascript:if (ModeratePostsForm.EmailType{position()}.selectedIndex != 0 &amp;&amp; ModeratePostsForm.Decision{position()}.value != 4 &amp;&amp; ModeratePostsForm.Decision{position()}.value !=6 ) ModerateMediaAssetsForm.Decision{position()}.value = 4" title="Select a reason if you are failing this content">
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
			<textarea cols="30" rows="5" name="CustomEmailText" id="CustomEmailText{position()}" wrap="virtual"/>
		</div>
	</xsl:template>
</xsl:stylesheet>
