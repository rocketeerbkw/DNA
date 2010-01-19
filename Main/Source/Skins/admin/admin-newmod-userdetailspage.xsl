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
	<xsl:template name="USER-DETAILS-PAGE_MAINBODY">
	Author:		Andy Harris
	Context:     /H2G2
	Purpose:	 Main body template
	-->
	<xsl:template name="USER-DETAILS-PAGE_MAINBODY">
		<ul id="classNavigation">
			<xsl:for-each select="/H2G2/MODERATION-CLASSES/MODERATION-CLASS">
				<li>
					<xsl:attribute name="class"><xsl:choose><xsl:when test="@CLASSID = /H2G2/PARAMS/PARAM[NAME = 's_classview']/VALUE">selected</xsl:when><xsl:otherwise>unselected</xsl:otherwise></xsl:choose></xsl:attribute>
					<xsl:attribute name="id">modClass<xsl:value-of select="@CLASSID"/></xsl:attribute>
					<a href="#">
						<xsl:attribute name="href">memberdetails?userid=<xsl:value-of select="/H2G2/USERS-DETAILS/@ID"/>&amp;siteid=<xsl:value-of select="/H2G2/USERS-DETAILS/@SITEID"/>&amp;s_classview=<xsl:value-of select="@CLASSID"/></xsl:attribute>
						<xsl:value-of select="NAME"/>
					</a>
				</li>
			</xsl:for-each>
		</ul>
		<div id="mainContent">
			<xsl:call-template name="users_search_bar"/>
			<xsl:apply-templates select="USERS-DETAILS" mode="crumbtrail"/>
			<xsl:apply-templates select="FEEDBACK" mode="userdetails_feedback_strip"/>
			<xsl:apply-templates select="USERS-DETAILS" mode="main_info"/>
			<xsl:apply-templates select="USERS-DETAILS" mode="update_form"/>
		</div>
	</xsl:template>
	<!-- 
	<xsl:template match="USERS-DETAILS" mode="crumbtrail">
	Author:		Andy Harris
	Context:     /H2G2/USERS-DETAILS
	Purpose:	 Template for displaying the user crumbtrail
	-->
	<xsl:template match="USERS-DETAILS" mode="crumbtrail">
		<p id="memberCrumbtrail">
			<a href="members?show=10&amp;skip=0&amp;direction=0&amp;sortedon=nickname&amp;siteid=1&amp;s_classview={/H2G2/PARAMS/PARAM[NAME = 's_classview']/VALUE}">
				<xsl:text>Members</xsl:text>
			</a>
			<xsl:text> &gt; </xsl:text>
			<xsl:value-of select="MAIN-IDENTITY/USERNAME"/>
			<xsl:text> details</xsl:text>
		</p>
	</xsl:template>
	<xsl:template match="FEEDBACK" mode="userdetails_feedback_strip">
		<p id="feedback-strip">
			<xsl:choose>
				<xsl:when test="@PROCESSED = 1">Your changes have been made</xsl:when>
				<xsl:when test="@PROCESSED = 0">There has been an error with your changes</xsl:when>
			</xsl:choose>
		</p>
	</xsl:template>
	<!-- 
	<xsl:template match="USERS-DETAILS" mode="main_info">
	Author:		Andy Harris
	Context:     /H2G2/USERS-DETAILS
	Purpose:	 Template which displays the main section of the user info page
	-->
	<xsl:template match="USERS-DETAILS" mode="main_info">
		<p id="memberInfoText">
			<xsl:text>Please note that only members with at least one edited or failed piece of content have their details stored here.</xsl:text>
		</p>
		<div id="memberDetails">
			<h2 class="noLine">name</h2>
			<p>
				<xsl:choose>
					<xsl:when test="not(string-length(MAIN-IDENTITY/USERNAME) = 0)">
						<xsl:value-of select="MAIN-IDENTITY/USERNAME"/>
					</xsl:when>
					<xsl:otherwise>No username</xsl:otherwise>
				</xsl:choose>
			</p>
			<h2 class="noLine">email address</h2>
			<p>
				<xsl:value-of select="MAIN-IDENTITY/EMAIL"/>
			</p>
			<h2 class="noLine">user ID</h2>
			<p>
				<xsl:value-of select="@ID"/>
			</p>
			<xsl:apply-templates select="ALT-IDENTITIES" mode="this_site"/>
			<xsl:apply-templates select="USER-POST-HISTORY-SUMMARY" mode="summary"/>
			<h2>member settings</h2>
		</div>
	</xsl:template>
	<!-- 
	<xsl:template match="ALT-IDENTITIES" mode="this_site">
	Author:		Andy Harris
	Context:     /H2G2/USERS-DETAILS/USER-POST-HISTORY-SUMMARY
	Purpose:	 Template which displays the alternative identities of the user on this site
	-->
	<xsl:template match="ALT-IDENTITIES" mode="this_site">
		<xsl:if test="IDENTITY[@SITEID = /H2G2/USERS-DETAILS/@SITEID]">
			<h2 class="altIdentities">alt. identities:</h2>
			<ul class="altIdentities">
				<xsl:for-each select="IDENTITY[@SITEID = /H2G2/USERS-DETAILS/@SITEID]">
					<li>
						<xsl:value-of select="@USERNAME"/>
						<xsl:text> </xsl:text>
						<a href="memberdetails?siteid={@SITEID}&amp;userid={@USERID}&amp;s_classview={/H2G2/PARAMS/PARAM[NAME = 's_classview']/VALUE}">[member profile]</a>
					</li>
				</xsl:for-each>
			</ul>
		</xsl:if>
	</xsl:template>
	<!-- 
	<xsl:template match="USER-POST-HISTORY-SUMMARY" mode="summary">
	Author:		Andy Harris
	Context:     /H2G2/USERS-DETAILS/USER-POST-HISTORY-SUMMARY
	Purpose:	 Template which displays the summary of the user activity
	-->
	<xsl:template match="USER-POST-HISTORY-SUMMARY" mode="summary">
		<h2>member summary</h2>
		<p>
			<xsl:value-of select="SUMMARY/@POSTCOUNT"/>
			<xsl:text> posts and </xsl:text>
			<xsl:value-of select="SUMMARY/@ENTRYCOUNT"/>
			<xsl:text> entries submitted since </xsl:text>
			<xsl:apply-templates select="SUMMARY/FIRSTACTIVITY/DATE" mode="mod-system-format"/>
			<xsl:text>.</xsl:text>
		</p>
		<p>
			<xsl:apply-templates select="REASONS-LIST/REASON" mode="summary"/>
		</p>
	</xsl:template>
	<!-- 
	<xsl:template match="REASON" mode="summary">
	Author:		Andy Harris
	Context:     /H2G2/USERS-DETAILS/USER-POST-HISTORY-SUMMARY/REASONS-LIST/REASON
	Purpose:	 Template which displays the reason for any moderation activities of the user
	-->
	<xsl:template match="REASON" mode="summary">
		<xsl:value-of select="@COUNT"/>
		<xsl:text> posts failed for </xsl:text>
		<xsl:value-of select="/H2G2/MOD-REASONS/MOD-REASON[@REASONID = current()/@REASONID]/@DISPLAYNAME"/>
		<xsl:choose>
			<xsl:when test="following-sibling::REASON">
				<xsl:text>, </xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>.</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- 
	<xsl:template match="USERS-DETAILS" mode="update_form">
	Author:		Andy Harris
	Context:     /H2G2/USERS-DETAILS
	Purpose:	 Template which creates the form for changing the users status
	-->
	<xsl:template match="USERS-DETAILS" mode="update_form">
		<form action="memberdetails" method="post">
			<div id="statusChange">
				<input type="hidden" name="update" value="update"/>
				<input type="hidden" name="userid" value="{@ID}"/>
				<input type="hidden" name="siteid" value="{@SITEID}"/>
				<input type="hidden" name="s_classview" value="{/H2G2/PARAMS/PARAM[NAME = 's_classview']/VALUE}"/>
				<xsl:apply-templates select="../USER-STATUSES" mode="settings_dropdown"/>
			</div>
			<xsl:apply-templates select="../USER-STATUSES" mode="applytoall_checkbox"/>
			<xsl:apply-templates select="../USER-TAGS" mode="usertags_checkboxes"/>
			<xsl:apply-templates select="." mode="alt_identities"/>
			<span class="clear"/>
			<input type="submit" value="Update" id="updateButton"/>
		</form>
	</xsl:template>
	<!-- 
	<xsl:template match="USER-STATUSES" mode="settings_dropdown">
	Author:		Andy Harris
	Context:     /H2G2/USER-STATUSES
	Purpose:	 Creates the dropdown for changing the user status
	-->
	<xsl:template match="USER-STATUSES" mode="settings_dropdown">
		<select name="status" id="statusSelect" onchange="durationChange()">
			<xsl:if test="/H2G2/USERS-DETAILS/MAIN-IDENTITY/STATUS/@STATUS = 4 and not($test_IsEditor)">
				<xsl:attribute name="disabled">disabled</xsl:attribute>
			</xsl:if>
			<xsl:for-each select="USER-STATUS[not(@USERSTATUSDESCRIPTION = 'Send for review') and not(@USERSTATUSDESCRIPTION = 'Postmoderate')]">
				<xsl:if test="not(not(/H2G2/USERS-DETAILS/MAIN-IDENTITY/STATUS/@STATUS = 4) and not($test_IsEditor) and (current()/@USERSTATUSID = 4))">
					<option value="{@USERSTATUSID}">
						<xsl:if test="/H2G2/USERS-DETAILS/MAIN-IDENTITY/STATUS/@STATUS = current()/@USERSTATUSID">
							<xsl:attribute name="selected">selected</xsl:attribute>
						</xsl:if>
						<xsl:value-of select="@USERSTATUSDESCRIPTION"/>
					</option>
				</xsl:if>
			</xsl:for-each>
		</select>
		<span id="statusText">
			<xsl:text> for </xsl:text>
		</span>
		<select name="duration" id="statusDuration">
			<xsl:if test="/H2G2/USERS-DETAILS/MAIN-IDENTITY/STATUS/@STATUS = 4 and not($test_IsEditor)">
				<xsl:attribute name="disabled">disabled</xsl:attribute>
			</xsl:if>
			<option>select duration</option>
			<option value="1440">
				<xsl:if test="/H2G2/USERS-DETAILS/MAIN-IDENTITY/STATUS/@DURATION = 1440">
					<xsl:attribute name="selected">selected</xsl:attribute>
				</xsl:if>
				<xsl:text>1 day</xsl:text>
			</option>
			<option value="10080">
				<xsl:if test="/H2G2/USERS-DETAILS/MAIN-IDENTITY/STATUS/@DURATION = 10080">
					<xsl:attribute name="selected">selected</xsl:attribute>
				</xsl:if>
				<xsl:text>1 week</xsl:text>
			</option>
			<option value="20160">
				<xsl:if test="/H2G2/USERS-DETAILS/MAIN-IDENTITY/STATUS/@DURATION = 20160">
					<xsl:attribute name="selected">selected</xsl:attribute>
				</xsl:if>
				<xsl:text>2 weeks</xsl:text>
			</option>
			<option value="40320">
				<xsl:if test="/H2G2/USERS-DETAILS/MAIN-IDENTITY/STATUS/@DURATION = 40320">
					<xsl:attribute name="selected">selected</xsl:attribute>
				</xsl:if>
				<xsl:text>1 month</xsl:text>
			</option>
			<option value="0">
				<xsl:if test="/H2G2/USERS-DETAILS/MAIN-IDENTITY/STATUS/@DURATION = 0">
					<xsl:attribute name="selected">selected</xsl:attribute>
				</xsl:if>
				<xsl:text>no limit</xsl:text>
			</option>
		</select>
		<p id="applyToAll">
			<xsl:text>apply status to alt. IDs?</xsl:text>
			<input type="radio" name="applytoaltids" value="0"/>
			<label>
				<xsl:text>No</xsl:text>
			</label>
			<input type="radio" name="applytoaltids" value="1" checked="checked"/>
			<label>
				<xsl:text>Yes</xsl:text>
			</label>
		</p>
	</xsl:template>
	<!-- 
	<xsl:template match="USER-STATUSES" mode="applytoall_checkbox">
	Author:		Andy Harris
	Context:     /H2G2/USER-STATUSES
	Purpose:	 Creates the checkbox for applying the change in status to all the users DNA profiles
	-->
	<xsl:template match="USER-STATUSES" mode="applytoall_checkbox">
		<xsl:if test="$superuser = 1">
			<p id="applyToOtherProfiles">
				<input type="checkbox" name="allprofiles"/>
				<label>
					<xsl:text>apply settings to all of this member's other DNA profiles?</xsl:text>
				</label>
			</p>
		</xsl:if>
	</xsl:template>
	<!-- 
	<xsl:template match="USER-TAGS" mode="usertags_checkboxes">
	Author:		Andy Harris
	Context:     /H2G2/USER-TAGS
	Purpose:	 Creates the checkboxs for attaching tags to the user
	-->
	<xsl:template match="USER-TAGS" mode="usertags_checkboxes">
		<h2 class="usertags">member tags</h2>
		<p class="usertags">
			<xsl:for-each select="USER-TAG">
				<input type="checkbox" name="usertag" value="{@ID}">
					<xsl:if test="/H2G2/USERS-DETAILS/MAIN-IDENTITY[USER-TAG = current()/@ID]">
						<xsl:attribute name="checked">checked</xsl:attribute>
					</xsl:if>
				</input>
				<label>
					<xsl:value-of select="DESCRIPTION"/>
				</label>
			</xsl:for-each>
		</p>
	</xsl:template>
	<!-- 
	<xsl:template match="USERS-DETAILS" mode="alt_identities">
	Author:		Andy Harris
	Context:     /H2G2/USER-DETAILS
	Purpose:	 Creates the list of alternative identities for this user on other DNA sites
	-->
	<xsl:template match="USERS-DETAILS" mode="alt_identities">
		<xsl:variable name="currentModClass">
			<xsl:value-of select="/H2G2/SITE-LIST/SITE[@ID =current()/@SITEID]/CLASSID"/>
		</xsl:variable>
		<xsl:variable name="currentSiteID">
			<xsl:value-of select="@SITEID"/>
		</xsl:variable>
		<xsl:if test="ALT-IDENTITIES/IDENTITY[not(@SITEID = current()/@SITEID)]">
			<h2 class="altIdentities">member profiles on other sites</h2>
			<p class="altIdenties">
				<xsl:text>This member profile is associated with </xsl:text>
				<xsl:value-of select="/H2G2/SITE-LIST/SITE[@ID = current()/@SITEID]/NAME"/>
				<xsl:text>. </xsl:text>
				<xsl:value-of select="MAIN-IDENTITY/USERNAME"/>
				<xsl:text> has profiles on other sites </xsl:text>
				<!--<xsl:text>in the </xsl:text>
				<xsl:choose>
					<xsl:when test="/H2G2/MODERATION-CLASSES/MODERATION-CLASS[@CLASSID = /H2G2/PARAMS/PARAM[NAME = 's_classview']/VALUE]/NAME = 'Standard Universal'">General</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="/H2G2/MODERATION-CLASSES/MODERATION-CLASS[@CLASSID = /H2G2/PARAMS/PARAM[NAME = 's_classview']/VALUE]/NAME"/>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:text> class, </xsl:text>-->
				<xsl:text>including: </xsl:text>
				<ul>
					<xsl:for-each select="ALT-IDENTITIES/IDENTITY[not(@SITEID = $currentSiteID)]">
						<li>
							<xsl:value-of select="/H2G2/SITE-LIST/SITE[@ID = current()/@SITEID]/NAME"/>
							<xsl:text> </xsl:text>
							<a href="memberdetails?siteid={@SITEID}&amp;userid={@USERID}&amp;s_classview={/H2G2/PARAMS/PARAM[NAME = 's_classview']/VALUE}">
								<xsl:text>[member profile]</xsl:text>
							</a>
						</li>
					</xsl:for-each>
				</ul>
			</p>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>
