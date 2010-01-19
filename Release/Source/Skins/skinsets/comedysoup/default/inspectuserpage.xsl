<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">

<xsl:template name="INSPECT-USER_HEADER">
	<xsl:apply-templates mode="header" select=".">
		<xsl:with-param name="title"><xsl:value-of select="$m_pagetitlestart"/>Inspect User</xsl:with-param>
	</xsl:apply-templates>
</xsl:template>
	
	<xsl:template name="INSPECT-USER_MAINBODY">
	<!-- DEBUG -->
	<xsl:call-template name="TRACE">
		<xsl:with-param name="message">INSPECT-USER_MAINBODY</xsl:with-param>
		<xsl:with-param name="pagename">inspectuserpage.xsl</xsl:with-param>
	</xsl:call-template>
	<!-- DEBUG -->
		<table vspace="0" hspace="0" border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td align="left" valign="top" width="75%">
					<br/>
					<font face="{$fontface}" color="{$mainfontcolour}">
						<!-- put the rest inside a table to give it some space around the borders -->
						<table width="100%" cellpadding="2" cellspacing="2" border="0">
							<tr valign="top">
								<td>
									<!-- now for the main part of the page -->
									<!-- the whole thing is one big form -->
									<xsl:apply-templates select="INSPECT-USER-FORM"/>
								</td>
							</tr>
						</table>
						<br clear="all"/>
					</font>
				</td>
				<td width="25%" align="left" valign="top">
					<xsl:call-template name="INTERNAL-TOOLS-NAVIGATION"/>
				</td>
			</tr>
		</table>
	</xsl:template>

	<xsl:template match="INSPECT-USER-FORM">
		<!-- variable to make calculation of drop down menus easier -->
		<xsl:variable name="Integers">
			<VALUES>
				<I>0</I><I>1</I><I>2</I><I>3</I><I>4</I><I>5</I><I>6</I><I>7</I><I>8</I><I>9</I>
				<I>10</I><I>11</I><I>12</I><I>13</I><I>14</I><I>15</I><I>16</I><I>17</I><I>18</I><I>19</I>
				<I>20</I><I>21</I><I>22</I><I>23</I><I>24</I><I>25</I><I>26</I><I>27</I><I>28</I><I>29</I>
				<I>30</I>
			</VALUES>
		</xsl:variable>
		<!-- display any error message first -->
		<font xsl:use-attribute-sets="WarningMessageFont">
			<xsl:for-each select="ERROR">
				<xsl:value-of select="."/><br/>
			</xsl:for-each>
		</font>
		<!-- the actual inspect user form -->
		<form name="InspectUserForm" method="post" action="{$root}InspectUser">
			<input type="hidden" name="UserID" value="{USER/USERID}"/>
			<font xsl:use-attribute-sets="mainfont">
				<table width="100%" cellpadding="0" cellspacing="0" border="0">
					<tr valign="top" align="center">
						<td colspan="5">
							<font xsl:use-attribute-sets="mainfont">
								<b>User ID: </b>
								<input type="text" name="FetchUserID" value="{USER/USERID}" size="8"/>
								&nbsp;
								<input type="submit" name="FetchUser" value="Fetch User"/>
							</font>
						</td>
					</tr>
					<tr><td colspan="5">&nbsp;</td></tr>
					<tr align="center"><td colspan="5"><font xsl:use-attribute-sets="mainfont" size="5"><b>Inspecting U<xsl:value-of select="USER/USERID"/> : <xsl:apply-templates select="USER"/></b></font></td></tr>
					<tr><td colspan="5">&nbsp;</td></tr>
					<tr valign="top">
						<td colspan="2"><font xsl:use-attribute-sets="mainfont">
							<b>Active: </b><xsl:value-of select="USER/ACTIVE"/>
							<xsl:if test="USER/ACTIVE = 'No'">
								&nbsp;
								(since <xsl:apply-templates select="USER/DATE-RELEASED/DATE"/>)
							</xsl:if>
						</font></td>
						<td colspan="3"><font xsl:use-attribute-sets="mainfont"><b>Date Joined: </b><xsl:apply-templates select="USER/DATE-JOINED/DATE" mode="absolute"/></font></td>
					</tr>
					<tr valign="top">
						<td colspan="5">
							<!-- don't show deactivate button on users own account -->
							<xsl:choose>
								<xsl:when test="USER/ACTIVE = 'Yes' and /H2G2/VIEWING-USER/USER/USERID != USER/USERID">
									<input type="submit" name="DeactivateAccount" value="Deactivate">
										<xsl:if test="USER/GROUPS/EDITOR">
											<xsl:attribute name="onClick">return confirm('Are you sure you wish to deactivate this Editors account?')</xsl:attribute>
										</xsl:if>
									</input>
								</xsl:when>
								<xsl:when test="USER/ACTIVE = 'No'"><input type="submit" name="ReactivateAccount" value="Reactivate"/></xsl:when>
							</xsl:choose>
						</td>
					</tr>
					<tr><td colspan="5">&nbsp;</td></tr>
					<tr valign="top">
						<td><font xsl:use-attribute-sets="mainfont"><b>UserName:</b> <br/><input type="text" name="UserName" value="{USER/USERNAME}"/></font></td>
						<td>&nbsp;</td>
						<td><font xsl:use-attribute-sets="mainfont"><b>Email:</b> <br/><input type="text" name="EmailAddress" value="{USER/EMAIL-ADDRESS}"/></font></td>
						<td>&nbsp;</td>
						<td><font xsl:use-attribute-sets="mainfont"><b>LoginName:</b> <br/><input type="text" name="LoginName" value="{USER/LOGIN-NAME}" disabled="disabled"/></font></td>
						<td>&nbsp;</td>
						<td><font xsl:use-attribute-sets="mainfont"><b>Title:</b> <br/><input type="text" name="Title" value="{USER/TITLE}"/></font></td>
					
					</tr>
					<tr valign="top">
						<td><font xsl:use-attribute-sets="mainfont"><b>First Names:</b> <br/><input type="text" name="FirstNames" value="{USER/FIRST-NAMES}"/></font></td>
						<td>&nbsp;</td>
						<td><font xsl:use-attribute-sets="mainfont"><b>Last Name:</b> <br/><input type="text" name="LastName" value="{USER/LAST-NAME}"/></font></td>
						<td>&nbsp;</td>
						<td><font xsl:use-attribute-sets="mainfont"><b>BBC User ID:</b> <br/><input type="text" name="BBCUID" value="{USER/BBCUID}" disabled="disabled"/></font></td>
					</tr>
					<tr valign="top">
						<td>
							<font xsl:use-attribute-sets="mainfont"><b>Status:</b> <br/>
								<xsl:choose>
									<xsl:when test="$superuser = 1">
									<select name="Status">
										<option value="1"><xsl:if test="USER/STATUS=1"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>User</option>
										<option value="2"><xsl:if test="USER/STATUS=2"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Editor</option>
									</select>
									</xsl:when>
									<xsl:otherwise>
										<input type="HIDDEN" name="Status" value="{USER/STATUS}"/>
										<xsl:choose>
											<xsl:when test="USER/STATUS=1">User</xsl:when>
											<xsl:when test="USER/STATUS=2">Super-User</xsl:when>
										</xsl:choose>
									</xsl:otherwise>
								</xsl:choose>
							</font>
						</td>
						<td>&nbsp;</td>
						<td><font xsl:use-attribute-sets="mainfont"><b>Password:</b> <br/><input type="text" name="Password" value="{USER/PASSWORD}"/></font></td>
						<td>&nbsp;</td>
						<td>
							<xsl:if test="$superuser = 1">
								<input name="ClearBBCDetails" value="Clear BBC Details" type="submit" onClick="return confirm('This will clear the BBC details for this user, requiring them to reactivate their account. Are you sure you want to do this?')"/>
							</xsl:if>
							<br/>
							<xsl:choose>
								<xsl:when test="$superuser = 1">
									<font xsl:use-attribute-sets="mainfont" size="1">Clearing the BBC details allows them to be used with a different h2g2 account, but it also prevents the use of this account until it is reactivated with different BBC details.</font>
								</xsl:when>
							</xsl:choose>
						</td>
					</tr>
					<tr><td colspan="5">&nbsp;</td></tr>
					<tr>
						<td colspan="5"><input type="submit" name="UpdateDetails" value="Update Details"/></td>
					</tr>
					<tr><td colspan="5">&nbsp;</td></tr>
					<tr><td colspan="5">&nbsp;</td></tr>
				</table>
				<!-- bizarre work around to allow comparison of node name to a variable => is there a better way? -->
				<xsl:variable name="UsersGroups">
					<xsl:for-each select="/H2G2/INSPECT-USER-FORM/USER/GROUPS/*">
						<xsl:text> </xsl:text><xsl:value-of select="name()"/><xsl:text> </xsl:text>
					</xsl:for-each>
				</xsl:variable>
				<table cellpadding="0" cellspacing="0" border="0">
					<tr valign="top"><td colspan="5"><font xsl:use-attribute-sets="mainfont"><b>Group Membership:</b></font></td></tr>
					<tr valign="top" align="left">
						<td>
							<font xsl:use-attribute-sets="mainfont">
								<B>Current</B><br/>
								<!-- display current groups in a deactivated list for reference -->
								<!--
								<select name="GroupsDisplay" multiple="multiple" size="{count(GROUPS-LIST/GROUP)}" disabled="disabled">
									<xsl:for-each select="GROUPS-LIST/GROUP">
										<option value="{@ID}"><xsl:if test="contains($UsersGroups, concat(' ', @ID, ' '))"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if><xsl:value-of select="@NAME"/></option>
									</xsl:for-each>
								</select>
								-->
									<xsl:for-each select="GROUPS-LIST/GROUP">
										<xsl:if test="contains($UsersGroups, concat(' ', @ID, ' '))"><xsl:value-of select="@NAME"/><br/></xsl:if>
									</xsl:for-each>
							</font>
						</td>
						<td>&nbsp;</td>
						<td>
							<font xsl:use-attribute-sets="mainfont">
								<B>New</B><br/>
								<!-- then have a list the user can change -->
								<!--
								<select name="GroupsMenu" multiple="multiple" size="{count(GROUPS-LIST/GROUP)}">
									<xsl:for-each select="GROUPS-LIST/GROUP">
										<option value="{@ID}"><xsl:if test="contains($UsersGroups, concat(' ', @ID, ' '))"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if><xsl:value-of select="@NAME"/></option>
									</xsl:for-each>
								</select>
								-->
									<xsl:for-each select="GROUPS-LIST/GROUP">
										<INPUT id="Chk{@NAME}" name="GroupsMenu" value="{@ID}" TYPE="CHECKBOX"><xsl:if test="contains($UsersGroups, concat(' ', @ID, ' '))"><xsl:attribute name="CHECKED">CHECKED</xsl:attribute></xsl:if></INPUT><xsl:value-of select="@NAME"/><br/>
									</xsl:for-each>
							</font>
						</td>
						<td>&nbsp;</td>
						<td>
							<xsl:if test="$superuser=1">
							<font xsl:use-attribute-sets="mainfont">
								<b>Create new group:</b>
								<br/>
								<input type="text" name="NewGroupName" value=""/>
								<br/>
								<input type="submit" name="CreateUserGroup" value="Create Group"/>
							</font>
							</xsl:if>
						</td>
					</tr>
					<tr><td colspan="2">&nbsp;</td></tr>
						<script language="JavaScript">
						<xsl:comment>
							function CheckGroups()
							{
								if (document.InspectUserForm.ChkReferee == null ||
									document.InspectUserForm.ChkModerator == null)
								{
									return true;
								}
								
								if (document.InspectUserForm.ChkModerator.checked == false	
									&amp;&amp; document.InspectUserForm.ChkReferee.checked == true)
								{
									alert("<xsl:value-of select="$m_RefereeShouldBeModerator"/>");
									return false;
								}
								return true;
							}
						//</xsl:comment>
						</script>
				<tr><td colspan="2"><input type="submit" onclick="return CheckGroups();" name="UpdateGroups" value="Update Groups"/></td></tr>
				</table>
				<br/>
				<input type="reset" value="Reset Form"/>
				<!-- display group-related data as appropriate -->
				<xsl:if test="USER/GROUPS[SCOUTS or EDITOR]">
					<br/>
					<br/>
					<h3>Scout Info</h3>
					Quota: 
					<xsl:variable name="ScoutQuota" select="number(SCOUT-INFO/QUOTA)"/>
					<select name="ScoutQuota">
						<xsl:for-each select="msxsl:node-set($Integers)/VALUES/I">
							<option value="{number(.)}">
								<xsl:if test="number(.) = number($ScoutQuota)"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
								<xsl:value-of select="number(.)"/>
							</option>
						</xsl:for-each>
					</select>
					<xsl:text> </xsl:text>
					Interval: 
					<select name="ScoutInterval">
						<option value="day"><xsl:if test="SCOUT-INFO/INTERVAL = 'day'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Day</option>
						<option value="week"><xsl:if test="SCOUT-INFO/INTERVAL = 'week'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Week</option>
						<option value="month"><xsl:if test="SCOUT-INFO/INTERVAL = 'month'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Month</option>
					</select>
					<br/>
					Total Recommendations: <xsl:value-of select="SCOUT-INFO/TOTAL-RECOMMENDATIONS"/><br/>
					Recommendations Last Interval: <xsl:value-of select="SCOUT-INFO/RECOMMENDATIONS-LAST-INTERVAL"/><br/>
					<br/>
					<input type="submit" name="UpdateScoutInfo" value="Update Scout Info"/>
					<br/>
					<br/>
					<b>Recent Recommendations</b> in the last: 
					<select name="RecommendationsPeriod">
						<option value="hour"><xsl:if test="SCOUT-INFO/ARTICLE-LIST/@UNIT-TYPE = 'hour'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Hour</option>
						<option value="day"><xsl:if test="SCOUT-INFO/ARTICLE-LIST/@UNIT-TYPE = 'day'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Day</option>
						<option value="week"><xsl:if test="SCOUT-INFO/ARTICLE-LIST/@UNIT-TYPE = 'week'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Week</option>
						<option value="month"><xsl:if test="SCOUT-INFO/ARTICLE-LIST/@UNIT-TYPE = 'month'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Month</option>
						<option value="year"><xsl:if test="SCOUT-INFO/ARTICLE-LIST/@UNIT-TYPE = 'year'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Year</option>
					</select>
					&nbsp;
					<input type="submit" name="Refresh" value="Refresh"/>
					<br/>
					<br/>
					<table>
						<tr valign="top">
							<td><font xsl:use-attribute-sets="mainfont"><b>ID</b></font></td>
							<td><font xsl:use-attribute-sets="mainfont"><b>Subject</b></font></td>
							<td><font xsl:use-attribute-sets="mainfont"><b>Editor</b></font></td>
							<td><font xsl:use-attribute-sets="mainfont"><b>Recommended</b></font></td>
							<td><font xsl:use-attribute-sets="mainfont"><b>Accepted?</b></font></td>
							<td><font xsl:use-attribute-sets="mainfont"><b>Sub Editor</b></font></td>
							<td><font xsl:use-attribute-sets="mainfont"><b>Returned?</b></font></td>
						</tr>
						<xsl:for-each select="SCOUT-INFO/ARTICLE-LIST[@TYPE = 'SCOUT-RECOMMENDATIONS']/ARTICLE">
							<tr valign="top">
								<td><font xsl:use-attribute-sets="mainfont">A<xsl:value-of select="H2G2-ID"/></font></td>
								<td><font xsl:use-attribute-sets="mainfont"><a href="{$root}A{H2G2-ID}"><xsl:value-of select="SUBJECT"/></a></font></td>
								<td><font xsl:use-attribute-sets="mainfont"><a href="{$root}U{EDITOR/USER/USERID}"><xsl:apply-templates select="EDITOR/USER/USERNAME" mode="truncated"/></a></font></td>
								<td><font xsl:use-attribute-sets="mainfont"><xsl:apply-templates select="DATE-RECOMMENDED/DATE" mode="short"/></font></td>
								<td><font xsl:use-attribute-sets="mainfont">
									<xsl:choose>
										<xsl:when test="RECOMMENDATION-STATUS = 3"><xsl:apply-templates select="RECOMMENDATION-DECISION-DATE/DATE" mode="short"/></xsl:when>
										<xsl:when test="RECOMMENDATION-STATUS = 2">Rejected</xsl:when>
										<xsl:otherwise>Pending</xsl:otherwise>
									</xsl:choose>
								</font></td>
								<td><font xsl:use-attribute-sets="mainfont">
									<xsl:choose>
										<xsl:when test="SUBBING-STATUS = 1">Unallocated</xsl:when>
										<xsl:when test="SUBBING-STATUS = 2 or SUBBING-STATUS = 3"><a href="{$root}InspectUser?UserID={SUBEDITOR/USER/USERID}"><xsl:apply-templates select="SUBEDITOR/USER/USERNAME" mode="truncated"/></a></xsl:when>
										<xsl:when test="SUBBING-STATUS = 3"></xsl:when>
										<xsl:otherwise>-</xsl:otherwise>
									</xsl:choose>								
								</font></td>
								<td><font xsl:use-attribute-sets="mainfont">
									<xsl:choose>
										<xsl:when test="SUBBING-STATUS = 3"><xsl:apply-templates select="DATE-RETURNED/DATE" mode="short"/></xsl:when>
										<xsl:when test="SUBBING-STATUS = 2">Waiting</xsl:when>
										<xsl:otherwise>-</xsl:otherwise>
									</xsl:choose>
								</font></td>
							</tr>
						</xsl:for-each>
					</table>
				</xsl:if>
				<xsl:if test="USER/GROUPS[SUBS or EDITOR]">
					<br/>
					<br/>
					<h3>Sub Editor Info</h3>
					Quota: 
					<xsl:variable name="SubQuota" select="number(SUB-INFO/QUOTA)"/>
					<select name="SubQuota">
						<xsl:for-each select="msxsl:node-set($Integers)/VALUES/I">
							<option value="{number(.)}">
								<xsl:if test="number(.) = number($SubQuota)"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
								<xsl:value-of select="number(.)"/>
							</option>
						</xsl:for-each>
					</select>
					<br/>
					Current Allocations: <xsl:value-of select="SUB-INFO/CURRENT-ALLOCATIONS"/><br/>
					Total Subbed: <xsl:value-of select="SUB-INFO/TOTAL-SUBBED"/><br/>
					<br/>
					<input type="submit" name="UpdateSubInfo" value="Update Sub Info"/>
					<br/>
					<br/>
					<b>Recent Allocations</b> in the last: 
					<select name="SubAllocationsPeriod">
						<option value="hour"><xsl:if test="SUB-INFO/ARTICLE-LIST/@UNIT-TYPE = 'hour'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Hour</option>
						<option value="day"><xsl:if test="SUB-INFO/ARTICLE-LIST/@UNIT-TYPE = 'day'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Day</option>
						<option value="week"><xsl:if test="SUB-INFO/ARTICLE-LIST/@UNIT-TYPE = 'week'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Week</option>
						<option value="month"><xsl:if test="SUB-INFO/ARTICLE-LIST/@UNIT-TYPE = 'month'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Month</option>
						<option value="year"><xsl:if test="SUB-INFO/ARTICLE-LIST/@UNIT-TYPE = 'year'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Year</option>
					</select>
					&nbsp;
					<input type="submit" name="Refresh" value="Refresh"/>
					<br/>
					<br/>
					<table>
						<tr valign="top">
							<td><font xsl:use-attribute-sets="mainfont"><b>ID</b></font></td>
							<td><font xsl:use-attribute-sets="mainfont"><b>Subject</b></font></td>
							<td><font xsl:use-attribute-sets="mainfont"><b>Editor</b></font></td>
							<td><font xsl:use-attribute-sets="mainfont"><b>Recommended</b></font></td>
							<td><font xsl:use-attribute-sets="mainfont"><b>Scout</b></font></td>
							<td><font xsl:use-attribute-sets="mainfont"><b>Accepted</b></font></td>
							<td><font xsl:use-attribute-sets="mainfont"><b>Allocated</b></font></td>
							<td><font xsl:use-attribute-sets="mainfont"><b>Returned?</b></font></td>
						</tr>
						<xsl:for-each select="SUB-INFO/ARTICLE-LIST[@TYPE = 'SUB-ALLOCATIONS']/ARTICLE">
							<tr valign="top">
								<td><font xsl:use-attribute-sets="mainfont">A<xsl:value-of select="H2G2-ID"/></font></td>
								<td><font xsl:use-attribute-sets="mainfont"><a href="{$root}A{H2G2-ID}"><xsl:value-of select="SUBJECT"/></a></font></td>
								<td><font xsl:use-attribute-sets="mainfont"><a href="{$root}U{EDITOR/USER/USERID}"><xsl:apply-templates select="EDITOR/USER/USERNAME" mode="truncated"/></a></font></td>
								<td><font xsl:use-attribute-sets="mainfont"><xsl:apply-templates select="DATE-RECOMMENDED/DATE" mode="short"/></font></td>
								<td><font xsl:use-attribute-sets="mainfont"><a href="{$root}U{SCOUT/USER/USERID}"><xsl:apply-templates select="SCOUT/USER/USERNAME" mode="truncated"/></a></font></td>
								<td><font xsl:use-attribute-sets="mainfont">
									<xsl:choose>
										<xsl:when test="RECOMMENDATION-STATUS = 3"><xsl:apply-templates select="RECOMMENDATION-DECISION-DATE/DATE" mode="short"/></xsl:when>
										<xsl:when test="RECOMMENDATION-STATUS = 2">Rejected</xsl:when>
										<xsl:otherwise>Pending</xsl:otherwise>
									</xsl:choose>
								</font></td>
								<td><font xsl:use-attribute-sets="mainfont">
									<xsl:choose>
										<xsl:when test="SUBBING-STATUS = 3 or SUBBING-STATUS=2"><xsl:apply-templates select="DATE-ALLOCATED/DATE" mode="short"/></xsl:when>
										<xsl:when test="SUBBING-STATUS = 1">Unallocated</xsl:when>
										<xsl:otherwise>-</xsl:otherwise>
									</xsl:choose>
								</font></td>
								<td><font xsl:use-attribute-sets="mainfont">
									<xsl:choose>
										<xsl:when test="SUBBING-STATUS = 3"><xsl:apply-templates select="DATE-RETURNED/DATE" mode="short"/></xsl:when>
										<xsl:when test="SUBBING-STATUS = 2">Waiting</xsl:when>
										<xsl:otherwise>-</xsl:otherwise>
									</xsl:choose>
								</font></td>
							</tr>
						</xsl:for-each>
					</table>
				</xsl:if>


			</font>
			<br/>
		</form>
		<xsl:if test="JOURNAL-INFO">
			<font xsl:use-attribute-sets="mainfont">
			<br/>
			<h3>
				<xsl:value-of select="m_MoveJournalToSite"/>
			</h3>
			<xsl:apply-templates select="JOURNAL-INFO/SITEID" mode="MoveToSite">
				<xsl:with-param name="objectID" select="/H2G2/INSPECT-USER-FORM/USER/JOURNAL"/>
			</xsl:apply-templates>
			</font>
		</xsl:if>
		<br/>
		<br/>
		<br/>
	</xsl:template>
</xsl:stylesheet>