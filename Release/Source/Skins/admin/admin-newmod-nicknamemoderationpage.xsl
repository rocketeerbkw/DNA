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
	<xsl:template name="NICKNAME-MODERATION_MAINBODY">
	Author:	Andy Harris
	Context:     	/H2G2
	Purpose:	Main body template
	-->
	<xsl:template name="NICKNAME-MODERATION_MAINBODY">
		<ul id="classNavigation">
			<xsl:for-each select="/H2G2/MODERATION-CLASSES/MODERATION-CLASS">
				<li>
					<xsl:attribute name="class"><xsl:choose><xsl:when test="@CLASSID = /H2G2/PARAMS/PARAM[NAME = 's_classview']/VALUE">selected</xsl:when><xsl:otherwise>unselected</xsl:otherwise></xsl:choose></xsl:attribute>
					<xsl:attribute name="id">modClass<xsl:value-of select="@CLASSID"/></xsl:attribute>
					<a href="#">
						<xsl:attribute name="href">moderatenicknames?newstyle=1&amp;modclassid=<xsl:value-of select="@CLASSID"/>&amp;s_classview=<xsl:value-of select="@CLASSID"/></xsl:attribute>
						<xsl:value-of select="NAME"/>
					</a>
				</li>
			</xsl:for-each>
		</ul>
		<form action="moderatenicknames" method="post">
			<input type="hidden" name="newstyle" value="1"/>
			<input type="hidden" name="modclassid" value="{/H2G2/MODERATENICKNAMES/@MODID}"/>
			<input type="hidden" name="fastmod" value="{/H2G2/MODERATENICKNAMES/@FASTMOD}"/>
			<div id="mainContent">
				<xsl:apply-templates select="MODERATENICKNAMES" mode="crumbtrail"/>
				<!--<xsl:apply-templates select="FEEDBACK" mode="feedback_strip"/>-->
				<!--<xsl:call-template name="checkalerts_strip"/>-->
				<table id="moderate-nickname-table" cellspacing="0">
					<thead>
						<tr>
							<td>
								<xsl:text>Site</xsl:text>
							</td>
							<td>
								<xsl:text>Nickname</xsl:text>
							</td>
							<td>
								<xsl:text>History</xsl:text>
							</td>
							<td>
								<xsl:text>Alt. IDs</xsl:text>
							</td>
							<td>
								<xsl:text>Status</xsl:text>
							</td>
							<td>
								<xsl:text>Date &amp; Time</xsl:text>
							</td>
							<td>
								<xsl:text>ACTIONS</xsl:text>
							</td>
						</tr>
					</thead>
					<tbody>
						<xsl:apply-templates select="MODERATENICKNAMES/NICKNAME" mode="nicknamemod"/>
					</tbody>
				</table>
			</div>
			<div id="processButtons">
				<input type="submit" value="Process &amp; Continue" name="next" title="Process these posts and then fetch the next batch" alt="Process these posts and then fetch the next batch" id="continueButton"/>
				<input type="submit" value="Process &amp; Return to Main" name="done" title="Process these posts and go to Moderation Home" alt="Process these posts and then go to Moderation Home" id="returnButton"/>
			</div>
		</form>
	</xsl:template>
	<!-- 
		<xsl:template match="MODERATENICKNAMES" mode="crumbtrail">
		Author:	Andy Harris
		Context:     	/H2G2/MODERATENICKNAMES
		Purpose:	Displays the crumbtrail at the top of the page
	-->
	<xsl:template match="MODERATENICKNAMES" mode="crumbtrail">
		<p class="crumbtrail">
			<a href="moderate?newstyle=1">
				<xsl:text>Main</xsl:text>
			</a>
			<xsl:text> &gt; Nicknames</xsl:text>
		</p>
	</xsl:template>
	<!-- 
		<xsl:template match="NICKNAME" mode="nicknamemod">
		Author:	Andy Harris
		Context:     	/H2G2/MODERATENICKNAMES/NICKNAME
		Purpose:	Displays the information about the user with the NICKNAME
	-->
	<xsl:template match="NICKNAME" mode="nicknamemod">
		<tr>
			<xsl:if test="position() mod 2 = 0">
				<xsl:attribute name="class">evenRow</xsl:attribute>
			</xsl:if>
			<td>
				<xsl:apply-templates select="SITEID" mode="sitename"/>
			</td>
			<td>
				<xsl:apply-templates select="USER" mode="nickname"/>
			</td>
			<td>
				<xsl:apply-templates select="USER" mode="profile"/>
			</td>
			<td>
				<xsl:apply-templates select="." mode="alt_ids"/>
			</td>
			<td>
				<xsl:apply-templates select="USER/STATUS" mode="user_status"/>
			</td>
			<td>
				<xsl:apply-templates select="DATEQUEUED/DATE" mode="mod-system-format"/>
			</td>
			<td>
				<xsl:apply-templates select="." mode="actions"/>
			</td>
		</tr>
	</xsl:template>
	<!-- 
		<xsl:template match="SITEID" mode="sitename">
		Author:	Andy Harris
		Context:     	/H2G2/MODERATENICKNAMES/NICKNAME/SITEID
		Purpose:	Displays the information about the site that the NICKNAME belongs to
	-->
	<xsl:template match="SITEID" mode="sitename">
		<xsl:value-of select="/H2G2/SITE-LIST/SITE[@ID = current()]/NAME"/>
	</xsl:template>
	<!-- 
		<xsl:template match="USER" mode="nickname">
		Author:	Andy Harris
		Context:     	/H2G2/MODERATENICKNAMES/NICKNAME/USER
		Purpose:	Displays the nickname and creates a link to the USERs userpage
	-->
	<xsl:template match="USER" mode="nickname">
		<a class="userpage" target="_blank">
			<xsl:attribute name="href"><xsl:text>/dna/</xsl:text><xsl:value-of select="/H2G2/SITE-LIST/SITE[@ID = current()/../SITEID]/NAME"/><xsl:text>/U</xsl:text><xsl:value-of select="USERID"/></xsl:attribute>
			<xsl:value-of select="USERNAME"/>
		</a>
	</xsl:template>
	<!-- 
		<xsl:template match="USER" mode="profile">
		Author:	Andy Harris
		Context:     	/H2G2/MODERATENICKNAMES/NICKNAME/USER
		Purpose:	Creates a link to the USERs profile page
	-->
	<xsl:template match="USER" mode="profile">
		<a href="memberdetails?userid={USERID}" class="profile" target="_blank">
			<xsl:text>member profile</xsl:text>
		</a>
	</xsl:template>

  <xsl:template match="USER" mode="profile_withusername">
    <a href="/dna/moderation/admin/memberdetails?userid={USERID}" class="profile" target="_blank">
      <xsl:apply-templates select="USERNAME"/>
    </a>
  </xsl:template>
	<!-- 
		<xsl:template match="NICKNAME" mode="alt_ids">
		Author:	Andy Harris
		Context:     	/H2G2/MODERATENICKNAMES/NICKNAME
		Purpose:	Displays whether or not the user has alternative identities
	-->
	<xsl:template match="NICKNAME" mode="alt_ids">
		<xsl:choose>
			<xsl:when test="ALTERNATEUSERS">
				<xsl:text>yes</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>no</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- 
		<xsl:template match="NICKNAME" mode="actions">
		Author:	Andy Harris
		Context:     	/H2G2/MODERATENICKNAMES/NICKNAME
		Purpose:	Creates the dropdown for the action being done to the NICKNAME
	-->
	<xsl:template match="NICKNAME" mode="actions">
		<select name="status">
			<option value="3">Pass</option>
			<option value="4">Fail</option>
			<!--<option value="7">Hold</option>-->
		</select>
		<input type="hidden" name="SiteID" value="{SITEID}"/> 
		<input type="hidden" name="userid" value="{USER/USERID}"/>
		<input type="hidden" name="modid" value="{MODERATION-ID}"/>
		<input type="hidden" name="username" value="{USER/USERNAME}"/>
		<input type="hidden" name="s_returnto" value="moderate?newstyle=1"/>
	</xsl:template>
</xsl:stylesheet>
