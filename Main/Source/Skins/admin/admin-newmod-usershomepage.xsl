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
	<xsl:template name="USERS-HOMEPAGE_MAINBODY">
	Author:		Andy Harris
	Context:     /H2G2
	Purpose:	 Main body template
	-->
	<xsl:template name="USERS-HOMEPAGE_MAINBODY">
		<ul id="classNavigation">
			<xsl:for-each select="/H2G2/MODERATION-CLASSES/MODERATION-CLASS">
				<li>
					<xsl:attribute name="class"><xsl:choose><xsl:when test="/H2G2/SITE-LIST/SITE[@ID = /H2G2/USERS-LIST/@SITEID]/CLASSID = current()/@CLASSID">selected</xsl:when><xsl:otherwise>unselected</xsl:otherwise></xsl:choose></xsl:attribute>
					<xsl:attribute name="id">modClass<xsl:value-of select="@CLASSID"/></xsl:attribute>
					<a href="#">
						<xsl:attribute name="href">members?show=10&amp;skip=0&amp;direction=0&amp;sortedon=nickname&amp;siteid=<xsl:value-of select="/H2G2/SITE-LIST/SITE[CLASSID = current()/@CLASSID]/@ID"/>&amp;s_classview=<xsl:value-of select="@CLASSID"/></xsl:attribute>
						<xsl:value-of select="NAME"/>
					</a>
				</li>
			</xsl:for-each>
		</ul>
		<div id="mainContent">
			<xsl:call-template name="users_search_bar"/>
			<xsl:apply-templates select="USERS-LIST" mode="nav_bar">
				<xsl:with-param name="position">Top</xsl:with-param>
			</xsl:apply-templates>
			<xsl:apply-templates select="USERS-LIST" mode="userlist"/>
			<xsl:apply-templates select="USERS-LIST" mode="nav_bar">
				<xsl:with-param name="position">Bottom</xsl:with-param>
			</xsl:apply-templates>
		</div>
	</xsl:template>
	<!-- 
	<xsl:template name="users_search_bar">
	Author:		Andy Harris
	Context:    None
	Purpose: Template called to make the search bar on the member pages
	-->
	<xsl:template name="users_search_bar">
		<form action="members" id="siteSelect">
			<input type="hidden" name="show" value="10"/>
			<input type="hidden" name="skip" value="0"/>
			<input type="hidden" name="direction" value="0"/>
			<input type="hidden" name="sortedon" value="nickname"/>
			<input type="hidden" name="s_classview" value="{/H2G2/PARAMS/PARAM[NAME = 's_classview']/VALUE}"/>
			<p>
				<xsl:text>Select site:</xsl:text>
			</p>
			<select name="siteid">
				<xsl:for-each select="/H2G2/SITE-LIST/SITE">
					<xsl:choose>
						<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_classview']">
							<xsl:if test="CLASSID = /H2G2/PARAMS/PARAM[NAME = 's_classview']/VALUE">
								<option value="{@ID}">
									<xsl:choose>
										<xsl:when test="/H2G2/@TYPE = 'USER-DETAILS-PAGE'">
											<xsl:if test="@ID = /H2G2/USERS-DETAILS/@SITEID">
												<xsl:attribute name="selected">selected</xsl:attribute>
											</xsl:if>
										</xsl:when>
										<xsl:otherwise>
											<xsl:if test="@ID = /H2G2/USERS-LIST/@SITEID">
												<xsl:attribute name="selected">selected</xsl:attribute>
											</xsl:if>
										</xsl:otherwise>
									</xsl:choose>
									<xsl:value-of select="SHORTNAME"/>
								</option>
							</xsl:if>
						</xsl:when>
						<xsl:otherwise>
							<xsl:if test="CLASSID = 1">
								<option value="{@ID}">
									<xsl:if test="@ID = /H2G2/USERS-LIST/@SITEID">
										<xsl:attribute name="selected">selected</xsl:attribute>
									</xsl:if>
									<xsl:value-of select="SHORTNAME"/>
								</option>
							</xsl:if>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:for-each>
			</select>
			<input type="submit" value="Go"/>
		</form>
		<form action="members" id="memberSearch">
			<input type="hidden" name="show" value="10"/>
			<input type="hidden" name="search" value="search"/>
			<xsl:choose>
				<xsl:when test="/H2G2/@TYPE = 'USERS-HOMEPAGE' and not(/H2G2/USERS-LIST/@SITEID = 0)">
					<input type="hidden" name="siteid" value="{/H2G2/USERS-LIST/@SITEID}"/>
				</xsl:when>
				<xsl:when test="/H2G2/@TYPE = 'USER-DETAILS-PAGE' and not(/H2G2/USERS-DETAILS/@SITEID = 0)">
					<input type="hidden" name="siteid" value="{/H2G2/USERS-DETAILS/@SITEID}"/>
				</xsl:when>
				<xsl:otherwise>
					<input type="hidden" name="siteid" value="1"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_classview']/VALUE">
					<input type="hidden" name="s_classview" value="{/H2G2/PARAMS/PARAM[NAME = 's_classview']/VALUE}"/>
				</xsl:when>
				<xsl:otherwise>
					<input type="hidden" name="s_classview" value="1"/>
				</xsl:otherwise>
			</xsl:choose>
			<select name="searchoption">
				<option>-- search by --</option>
				<option value="uid">UI no.</option>
				<option value="email">email address</option>
				<option value="nickname">nickname</option>
			</select>
			<input type="text" name="searchterm"/>
			<input type="submit" name="Search" value="Search"/>
		</form>
	</xsl:template>
	<!-- 
	<xsl:template match="USERS-LIST" mode="userlist">
	Author:		Andy Harris
	Context:     /H2G2/USERS-LIST
	Purpose:	 Template for displaying the user list
	-->
	<xsl:template match="USERS-LIST" mode="userlist">
		<table cellspacing="0" id="memberList">
			<thead>
				<xsl:choose>
					<xsl:when test="@SEARCHTERM">
						<tr>
							<td width="50%">
								<xsl:text>Nicknames</xsl:text>
							</td>
							<td width="10%">
								<xsl:text>Status</xsl:text>
							</td>
							<td width="10%">
								<xsl:text>Duration</xsl:text>
							</td>
							<td width="10%">
								<xsl:text>Ending in</xsl:text>
							</td>
							<td width="10%">
								<xsl:text>Tags</xsl:text>
							</td>
							<td width="10%">
								<xsl:text>Links</xsl:text>
							</td>
						</tr>
					</xsl:when>
					<xsl:otherwise>
						<tr>
							<td width="50%">
								<a>
									<xsl:attribute name="href">members?show=<xsl:value-of select="@SHOW"/>&amp;skip=<xsl:value-of select="@SKIP"/>&amp;direction=<xsl:choose><xsl:when test="(@SORTEDON = 'nickname' and @DIRECTION = 0)">1</xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose>&amp;sortedon=nickname&amp;siteid=<xsl:value-of select="@SITEID"/>&amp;s_classview=<xsl:value-of select="/H2G2/PARAMS/PARAM[NAME = 's_classview']/VALUE"/></xsl:attribute>
									<xsl:attribute name="class"><xsl:choose><xsl:when test="(@SORTEDON = 'nickname' and @DIRECTION = 0)">directionDown</xsl:when><xsl:when test="(@SORTEDON = 'nickname' and @DIRECTION = 1)">directionUp</xsl:when></xsl:choose></xsl:attribute>
									<xsl:text>Nicknames</xsl:text>
								</a>
							</td>
							<td width="10%">
								<a>
									<xsl:attribute name="href">members?show=<xsl:value-of select="@SHOW"/>&amp;skip=<xsl:value-of select="@SKIP"/>&amp;direction=<xsl:choose><xsl:when test="(@SORTEDON = 'status' and @DIRECTION = 0)">1</xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose>&amp;sortedon=status&amp;siteid=<xsl:value-of select="@SITEID"/>&amp;s_classview=<xsl:value-of select="/H2G2/PARAMS/PARAM[NAME = 's_classview']/VALUE"/></xsl:attribute>
									<xsl:attribute name="class"><xsl:choose><xsl:when test="(@SORTEDON = 'status' and @DIRECTION = 0)">directionDown</xsl:when><xsl:when test="(@SORTEDON = 'status' and @DIRECTION = 1)">directionUp</xsl:when></xsl:choose></xsl:attribute>
									<xsl:text>Status</xsl:text>
								</a>
							</td>
							<td width="10%">
								<a>
									<xsl:attribute name="href">members?show=<xsl:value-of select="@SHOW"/>&amp;skip=<xsl:value-of select="@SKIP"/>&amp;direction=<xsl:choose><xsl:when test="(@SORTEDON = 'duration' and @DIRECTION = 0)">1</xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose>&amp;sortedon=duration&amp;siteid=<xsl:value-of select="@SITEID"/>&amp;s_classview=<xsl:value-of select="/H2G2/PARAMS/PARAM[NAME = 's_classview']/VALUE"/></xsl:attribute>
									<xsl:attribute name="class"><xsl:choose><xsl:when test="(@SORTEDON = 'duration' and @DIRECTION = 0)">directionDown</xsl:when><xsl:when test="(@SORTEDON = 'duration' and @DIRECTION = 1)">directionUp</xsl:when></xsl:choose></xsl:attribute>
									<xsl:text>Duration</xsl:text>
								</a>
							</td>
							<td width="10%">
								<a>
									<xsl:attribute name="href">members?show=<xsl:value-of select="@SHOW"/>&amp;skip=<xsl:value-of select="@SKIP"/>&amp;direction=<xsl:choose><xsl:when test="(@SORTEDON = 'endingin' and @DIRECTION = 0)">1</xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose>&amp;sortedon=endingin&amp;siteid=<xsl:value-of select="@SITEID"/>&amp;s_classview=<xsl:value-of select="/H2G2/PARAMS/PARAM[NAME = 's_classview']/VALUE"/></xsl:attribute>
									<xsl:attribute name="class"><xsl:choose><xsl:when test="(@SORTEDON = 'endingin' and @DIRECTION = 0)">directionDown</xsl:when><xsl:when test="(@SORTEDON = 'endingin' and @DIRECTION = 1)">directionUp</xsl:when></xsl:choose></xsl:attribute>
									<xsl:text>Ending in</xsl:text>
								</a>
							</td>
							<td width="10%">
								<a>
									<xsl:attribute name="href">members?show=<xsl:value-of select="@SHOW"/>&amp;skip=<xsl:value-of select="@SKIP"/>&amp;direction=<xsl:choose><xsl:when test="(@SORTEDON = 'usertags' and @DIRECTION = 0)">1</xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose>&amp;sortedon=usertags&amp;siteid=<xsl:value-of select="@SITEID"/>&amp;s_classview=<xsl:value-of select="/H2G2/PARAMS/PARAM[NAME = 's_classview']/VALUE"/></xsl:attribute>
									<xsl:attribute name="class"><xsl:choose><xsl:when test="(@SORTEDON = 'usertags' and @DIRECTION = 0)">directionDown</xsl:when><xsl:when test="(@SORTEDON = 'usertags' and @DIRECTION = 1)">directionUp</xsl:when></xsl:choose></xsl:attribute>
									<xsl:text>Tags</xsl:text>
								</a>
							</td>
							<td width="10%">
								<xsl:text>Links</xsl:text>
							</td>
						</tr>
					</xsl:otherwise>
				</xsl:choose>
			</thead>
			<tbody>
				<xsl:apply-templates select="USER" mode="userlist"/>
			</tbody>
		</table>
	</xsl:template>
	<!-- 
	<xsl:template match="USER" mode="userlist">
	Author:		Andy Harris
	Context:     /H2G2/USERS-LIST/USER
	Purpose:	 Template for an individual user in the user list
	-->
	<xsl:template match="USER" mode="userlist">
		<tr>
			<xsl:if test="position() mod 2 = 0">
				<xsl:attribute name="class">evenRow</xsl:attribute>
			</xsl:if>
			<td>
				<xsl:choose>
					<xsl:when test="string-length(USERNAME) > 25">
						<xsl:value-of select="substring(USERNAME, 0, 25)"/>
						<xsl:text>...</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="USERNAME"/>
					</xsl:otherwise>
				</xsl:choose>
			</td>
			<td>
				<xsl:apply-templates select="STATUS" mode="user_status"/>
			</td>
			<td>
				<xsl:apply-templates select="STATUS" mode="status_duration"/>
			</td>
			<td>
				<xsl:apply-templates select="STATUS" mode="status_ending"/>
			</td>
			<td>
				<xsl:apply-templates select="USERTAG" mode="userlist"/>
			</td>
			<td>
				<!--<a href="inspectuser?FetchUserID={@USERID}&amp;FetchUser=Fetch+User">inspect user</a>-->
				<a href="memberdetails?siteid={/H2G2/USERS-LIST/@SITEID}&amp;userid={@USERID}&amp;s_classview={/H2G2/PARAMS/PARAM[NAME = 's_classview']/VALUE}">member profile</a>
				<!--<xsl:text> | </xsl:text>
				<a href="#">member archive</a>-->
			</td>
		</tr>
	</xsl:template>
  
	<!-- 
	<xsl:template match="STATUS" mode="user_status">
	Author:		Andy Harris
	Context:     /H2G2/USERS-LIST/USER/STATUS
	Purpose:	 Template for an individual users status image 
	-->
	<xsl:template match="STATUS" mode="user_status">
		<xsl:choose>
			<xsl:when test="@STATUSID">
				<img width="22" height="23">
					<xsl:attribute name="src"><xsl:value-of select="$asset-root"/>moderation/images/icons/status<xsl:value-of select="/H2G2/USER-STATUSES/USER-STATUS[@USERSTATUSID = current()/@STATUSID]/@USERSTATUSID"/>.gif</xsl:attribute>
					<xsl:attribute name="alt"><xsl:value-of select="/H2G2/USER-STATUSES/USER-STATUS[@USERSTATUSID = current()/@STATUSID]/@USERSTATUSDESCRIPTION"/></xsl:attribute>
				</img>
			</xsl:when>
			<xsl:otherwise>
				<img src="{$asset-root}moderation/images/icons/status0.gif" width="22" height="23" alt="Standard"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

  <!-- 
	<xsl:template match="GROUPS" mode="user_groups">
	Author:		Martin Robb
	Context:     USER/GROUPS
	Purpose:	 Template for an individual users groups images 
	-->
  <xsl:template match="GROUPS" mode="user_groups">
      <xsl:if test="EDITOR or GROUP/@NAME='Editor' or GROUP/NAME='EDITOR'">
        <img width="22" height="23">
          <xsl:attribute name="src">
            <xsl:value-of select="$asset-root"/>moderation/images/icons/editor.gif
          </xsl:attribute>
          <xsl:attribute name="alt">Editor</xsl:attribute>
        </img>
      </xsl:if>
    <xsl:if test="NOTABLES or GROUP/@NAME='Notables' or GROUP/NAME='NOTABLES'">
      <img width="22" height="23">
        <xsl:attribute name="src">
          <xsl:value-of select="$asset-root"/>moderation/images/icons/notables.gif
        </xsl:attribute>
        <xsl:attribute name="alt">Notable</xsl:attribute>
      </img>
    </xsl:if>
    <xsl:if test="TRUSTED or GROUP/@NAME='Trusted' or GROUP/NAME='TRUSTED'">
      <img width="22" height="23">
        <xsl:attribute name="src">
          <xsl:value-of select="$asset-root"/>moderation/images/icons/trusted.gif
        </xsl:attribute>
        <xsl:attribute name="alt">Trusted User</xsl:attribute>
      </img>
    </xsl:if>
  </xsl:template>
  
	<!-- 
	<xsl:template match="STATUS" mode="status_duration">
	Author:		Andy Harris
	Context:     /H2G2/USERS-LIST/USER/STATUS
	Purpose:	 Template for displaying the duration of a status 
	-->
	<xsl:template match="STATUS" mode="status_duration">
		<xsl:choose>
			<xsl:when test="@DURATION = 1440">1 day</xsl:when>
			<xsl:when test="@DURATION = 10080">1 week</xsl:when>
			<xsl:when test="@DURATION = 20160">2 weeks</xsl:when>
			<xsl:when test="@DURATION = 40320">1 month</xsl:when>
			<xsl:when test="@DURATION = 0">no limit</xsl:when>
			<xsl:otherwise>
				<xsl:text>n/a</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- 
	<xsl:template match="STATUS" mode="status_ending">
	Author:		Andy Harris
	Context:     /H2G2/USERS-LIST/USER/STATUS
	Purpose:	 Template for working out the length of time left for a particular user status 
	-->
	<xsl:template match="STATUS" mode="status_ending">
		<xsl:choose>
			<xsl:when test="@DURATION = 0">
				<xsl:text>n/a</xsl:text>
			</xsl:when>
			<xsl:when test="@DURATION">
				<xsl:variable name="todays-date">
					<xsl:call-template name="calculate-julian-day">
						<xsl:with-param name="year" select="/H2G2/DATE/@YEAR"/>
						<xsl:with-param name="month" select="/H2G2/DATE/@MONTH"/>
						<xsl:with-param name="day" select="/H2G2/DATE/@DAY"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:variable name="status-start-date">
					<xsl:call-template name="calculate-julian-day">
						<xsl:with-param name="year" select="STATUSCHANGEDDATE/DATE/@YEAR"/>
						<xsl:with-param name="month" select="STATUSCHANGEDDATE/DATE/@MONTH"/>
						<xsl:with-param name="day" select="STATUSCHANGEDDATE/DATE/@DAY"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:variable name="duration-days">
					<xsl:call-template name="calculate-duration-in-days">
						<xsl:with-param name="duration" select="@DURATION"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:variable name="end-date">
					<xsl:value-of select="$status-start-date + $duration-days"/>
				</xsl:variable>
				<xsl:choose>
					<xsl:when test="$end-date = $todays-date">
						<!--<xsl:choose>
							<xsl:when test="STATUSCHANGEDDATE/DATE/@HOURS = /H2G2/DATE/@HOURS">
								<xsl:choose>
									<xsl:when test="STATUSCHANGEDDATE/DATE/@MINUTES = /H2G2/DATE/@MINUTES">
										<xsl:text>Now</xsl:text>
									</xsl:when>
									<xsl:when test="STATUSCHANGEDDATE/DATE/@MINUTES - /H2G2/DATE/@MINUTES = 1">
										<xsl:text>1 minute</xsl:text>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="STATUSCHANGEDDATE/DATE/@MINUTES - /H2G2/DATE/@MINUTES"/>
										<xsl:text> minutes</xsl:text>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:when>
							<xsl:when test="STATUSCHANGEDDATE/DATE/@HOURS - /H2G2/DATE/@HOURS = 1">
								<xsl:text>1 hour</xsl:text>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="STATUSCHANGEDDATE/DATE/@HOURS - /H2G2/DATE/@HOURS"/>
								<xsl:text> hours</xsl:text>
							</xsl:otherwise>
						</xsl:choose>-->
						<xsl:text>Today</xsl:text>
					</xsl:when>
					<xsl:when test="$end-date - $todays-date = 1">
						<xsl:text>1 day</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$end-date - $todays-date"/>
						<xsl:text> days</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>n/a</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
  
	<!-- 
	<xsl:template name="calculate-julian-day">
	Author:		Andy Harris
	Context:     None
	Purpose:	 Generic template for working out the julian day of a particular date 
	-->
	<xsl:template name="calculate-julian-day">
		<xsl:param name="year"/>
		<xsl:param name="month"/>
		<xsl:param name="day"/>
		<xsl:variable name="a" select="floor((14 - $month) div 12)"/>
		<xsl:variable name="y" select="$year + 4800 - $a"/>
		<xsl:variable name="m" select="$month + 12 * $a - 3"/>
		<xsl:value-of select="$day + floor((153 * $m + 2) div 5) + $y * 365 + floor($y div 4) - floor ($y div 100) + floor($y div 400) - 32045"/>
	</xsl:template>
	<!-- 
	<xsl:template name="calculate-duration-in-days">
	Author:		Andy Harris
	Context:     None
	Purpose:	 Generic template for working out the duration of a status in days 
	-->
	<xsl:template name="calculate-duration-in-days">
		<xsl:param name="duration"/>
		<xsl:choose>
			<xsl:when test="$duration = 1440">1</xsl:when>
			<xsl:when test="$duration = 10080">7</xsl:when>
			<xsl:when test="$duration = 20160">14</xsl:when>
			<xsl:when test="$duration = 40320">28</xsl:when>
			<xsl:otherwise>no limit</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- 
	<xsl:template match="USERTAG" mode="userlist">
	Author:		Andy Harris
	Context:     /H2G2/USERS-LIST/USER/USERTAG
	Purpose:	 Template for displaying any user tags that a user may have
	-->
	<xsl:template match="USERTAG" mode="userlist">
		<xsl:value-of select="."/>
		<xsl:text>, </xsl:text>
	</xsl:template>
	<!-- 
	<xsl:template match="USERS-LIST" mode="nav_bar">
	Author:		Andy Harris
	Context:     /H2G2/USERS-LIST
	Purpose:	 Container for the elements of the nav bar
	-->
	<xsl:template match="USERS-LIST" mode="nav_bar">
		<xsl:param name="position">Top</xsl:param>
		<p id="navigationBar">
			<xsl:text>Page </xsl:text>
			<xsl:value-of select="(@SKIP div @SHOW) + 1"/>
			<xsl:text> of </xsl:text>
			<xsl:value-of select="floor(@TOTALUSERS div @SHOW) + 1"/>
			<xsl:text>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</xsl:text>
			<xsl:apply-templates select="." mode="navbar_firstpage"/>
			<xsl:apply-templates select="." mode="navbar_prevpage"/>
			<!--<xsl:apply-templates select="." mode="navbar_prevblock"/>-->
			<xsl:apply-templates select="." mode="navbar_blockdisplay"/>
			<!--<xsl:apply-templates select="." mode="navbar_nextblock"/>-->
			<xsl:apply-templates select="." mode="navbar_nextpage"/>
			<xsl:apply-templates select="." mode="navbar_lastpage"/>
		</p>
		<xsl:apply-templates select="." mode="navbar_goto">
			<xsl:with-param name="position" select="$position"/>
		</xsl:apply-templates>
	</xsl:template>
	<!-- 
	<xsl:template match="USERS-LIST" mode="navbar_firstpage">
	Author:		Andy Harris
	Context:     /H2G2/USERS-LIST
	Purpose:	 Presentation of first page link
	-->
	<xsl:template match="USERS-LIST" mode="navbar_firstpage">
		<xsl:if test="(@TOTALUSERS &gt; @SHOW) and not(@SKIP = 0)">
			<a>
				<xsl:attribute name="href">members?show=<xsl:value-of select="@SHOW"/>&amp;skip=0&amp;direction=<xsl:value-of select="@DIRECTION"/>&amp;sortedon=<xsl:value-of select="@SORTEDON"/>&amp;siteid=<xsl:value-of select="@SITEID"/>&amp;s_classview=<xsl:value-of select="/H2G2/PARAMS/PARAM[NAME = 's_classview']/VALUE"/><xsl:choose><xsl:when test="@SEARCHTERM">&amp;search=search&amp;searchoption=<xsl:value-of select="@SEARCHOPTION"/>&amp;searchterm=<xsl:value-of select="@SEARCHTERM"/></xsl:when></xsl:choose></xsl:attribute>
				<xsl:text>&lt; &lt;</xsl:text>
			</a>
			<xsl:text> | </xsl:text>
		</xsl:if>
	</xsl:template>
	<!-- 
	<xsl:template match="USERS-LIST" mode="navbar_lastpage">
	Author:		Andy Harris
	Context:     /H2G2/USERS-LIST
	Purpose:	 Presentation of last page link
	-->
	<xsl:template match="USERS-LIST" mode="navbar_lastpage">
		<xsl:if test="(@TOTALUSERS &gt; @SHOW) and not(@SKIP + @SHOW &gt; @TOTALUSERS)">
			<xsl:text> | </xsl:text>
			<a>
				<xsl:attribute name="href">members?show=<xsl:value-of select="@SHOW"/>&amp;skip=<xsl:value-of select="(floor(@TOTALUSERS div @SHOW)) * @SHOW"/>&amp;direction=<xsl:value-of select="@DIRECTION"/>&amp;sortedon=<xsl:value-of select="@SORTEDON"/>&amp;siteid=<xsl:value-of select="@SITEID"/>&amp;s_classview=<xsl:value-of select="/H2G2/PARAMS/PARAM[NAME = 's_classview']/VALUE"/><xsl:choose><xsl:when test="@SEARCHTERM">&amp;search=search&amp;searchoption=<xsl:value-of select="@SEARCHOPTION"/>&amp;searchterm=<xsl:value-of select="@SEARCHTERM"/></xsl:when></xsl:choose></xsl:attribute>
				<xsl:text>&gt; &gt;</xsl:text>
			</a>
		</xsl:if>
	</xsl:template>
	<!-- 
	<xsl:template match="USERS-LIST" mode="navbar_prevpage">
	Author:		Andy Harris
	Context:     /H2G2/USERS-LIST
	Purpose:	 Presentation of previous page link
	-->
	<xsl:template match="USERS-LIST" mode="navbar_prevpage">
		<xsl:if test="@SKIP &gt; 0">
			<a>
				<xsl:attribute name="href">members?show=<xsl:value-of select="@SHOW"/>&amp;skip=<xsl:value-of select="@SKIP - @SHOW"/>&amp;direction=<xsl:value-of select="@DIRECTION"/>&amp;sortedon=<xsl:value-of select="@SORTEDON"/>&amp;siteid=<xsl:value-of select="@SITEID"/>&amp;s_classview=<xsl:value-of select="/H2G2/PARAMS/PARAM[NAME = 's_classview']/VALUE"/><xsl:choose><xsl:when test="@SEARCHTERM">&amp;search=search&amp;searchoption=<xsl:value-of select="@SEARCHOPTION"/>&amp;searchterm=<xsl:value-of select="@SEARCHTERM"/></xsl:when></xsl:choose></xsl:attribute>
				<xsl:text>&lt;</xsl:text>
			</a>
			<xsl:text> | </xsl:text>
		</xsl:if>
	</xsl:template>
	<!-- 
	<xsl:template match="USERS-LIST" mode="navbar_nextpage">
	Author:		Andy Harris
	Context:     /H2G2/USERS-LIST
	Purpose:	 Presentation of next page link
	-->
	<xsl:template match="USERS-LIST" mode="navbar_nextpage">
		<xsl:if test="(($navbar_upperrange + @SHOW) &lt; @TOTALUSERS)">
			<xsl:text> | </xsl:text>
			<a>
				<xsl:attribute name="href">members?show=<xsl:value-of select="@SHOW"/>&amp;skip=<xsl:value-of select="@SKIP + @SHOW"/>&amp;direction=<xsl:value-of select="@DIRECTION"/>&amp;sortedon=<xsl:value-of select="@SORTEDON"/>&amp;siteid=<xsl:value-of select="@SITEID"/>&amp;s_classview=<xsl:value-of select="/H2G2/PARAMS/PARAM[NAME = 's_classview']/VALUE"/><xsl:choose><xsl:when test="@SEARCHTERM">&amp;search=search&amp;searchoption=<xsl:value-of select="@SEARCHOPTION"/>&amp;searchterm=<xsl:value-of select="@SEARCHTERM"/></xsl:when></xsl:choose></xsl:attribute>
				<xsl:text>&gt;</xsl:text>
			</a>
		</xsl:if>
	</xsl:template>
	<!-- 
	<xsl:template match="USERS-LIST" mode="navbar_prevblock">
	Author:		Andy Harris
	Context:     /H2G2/USERS-LIST
	Purpose:	 Presentation of previous block link
	-->
	<xsl:template match="USERS-LIST" mode="navbar_prevblock">
		<xsl:if test="($navbar_lowerrange != 0)">
			<a>
				<xsl:attribute name="href">members?show=<xsl:value-of select="@SHOW"/>&amp;skip=<xsl:value-of select="$navbar_lowerrange - @SHOW"/>&amp;direction=<xsl:value-of select="@DIRECTION"/>&amp;sortedon=<xsl:value-of select="@SORTEDON"/>&amp;siteid=<xsl:value-of select="@SITEID"/>&amp;s_classview=<xsl:value-of select="/H2G2/PARAMS/PARAM[NAME = 's_classview']/VALUE"/><xsl:choose><xsl:when test="@SEARCHTERM">&amp;search=search&amp;searchoption=<xsl:value-of select="@SEARCHOPTION"/>&amp;searchterm=<xsl:value-of select="@SEARCHTERM"/></xsl:when></xsl:choose></xsl:attribute>
				<xsl:text>Previous Block </xsl:text>
			</a>
		</xsl:if>
	</xsl:template>
	<!-- 
	<xsl:template match="USERS-LIST" mode="navbar_nextblock">
	Author:		Andy Harris
	Context:     /H2G2/USERS-LIST
	Purpose:	 Presentation of next block link
	-->
	<xsl:template match="USERS-LIST" mode="navbar_nextblock">
		<xsl:if test="(($navbar_upperrange + @SHOW) &lt; @TOTALUSERS)">
			<a>
				<xsl:attribute name="href">members?show=<xsl:value-of select="@SHOW"/>&amp;skip=<xsl:value-of select="$navbar_upperrange + @SHOW"/>&amp;direction=<xsl:value-of select="@DIRECTION"/>&amp;sortedon=<xsl:value-of select="@SORTEDON"/>&amp;siteid=<xsl:value-of select="@SITEID"/>&amp;s_classview=<xsl:value-of select="/H2G2/PARAMS/PARAM[NAME = 's_classview']/VALUE"/><xsl:choose><xsl:when test="@SEARCHTERM">&amp;search=search&amp;searchoption=<xsl:value-of select="@SEARCHOPTION"/>&amp;searchterm=<xsl:value-of select="@SEARCHTERM"/></xsl:when></xsl:choose></xsl:attribute>
				<xsl:text> Next Block</xsl:text>
			</a>
		</xsl:if>
	</xsl:template>
	<!-- 
	<xsl:template match="USERS-LIST" mode="on_blockdisplay">
	Author:		Andy Harris
	Context:     /H2G2/USERS-LIST
	Purpose:	 Controls the display of the block (outside the link) which is currently appearing on the page
	-->
	<xsl:template match="USERS-LIST" mode="on_blockdisplay">
		<xsl:param name="url"/>
		<xsl:copy-of select="$url"/>&nbsp; </xsl:template>
	<!-- 
	<xsl:template name="ontabcontent">
	Author:		Andy Harris
	Context:      none
	Purpose:	  Controls the content of the link for the currently visible page
	-->
	<xsl:template name="ontabcontent">
		<xsl:param name="range"/>
		<xsl:param name="pagenumber"/>
		<xsl:value-of select="$pagenumber"/>
	</xsl:template>
	<!-- 
	<xsl:template match="USERS-LIST" mode="off_blockdisplay">
	Author:		Andy Harris
	Context:     /H2G2/USERS-LIST
	Purpose:	 Controls the display of the block (outside the link) which is not currently on the page
	-->
	<xsl:template match="USERS-LIST" mode="off_blockdisplay">
		<xsl:param name="url"/>
		<xsl:copy-of select="$url"/>&nbsp; </xsl:template>
	<!--
	<xsl:template name="offtabcontent">
	Author:		Andy Harris
	Context:      none
	Purpose:	 Controls the content of the link for other pages in the currently visible range
	-->
	<xsl:template name="offtabcontent">
		<xsl:param name="range"/>
		<xsl:param name="pagenumber"/>
		<xsl:value-of select="$pagenumber"/>
	</xsl:template>
	<!-- navbar_split is the numbers of tabs that appear on one page-->
	<xsl:variable name="navbar_split" select="10"/>
	<!--navbar_lowerrange is the skip value of the first post of the first page of the series of tabs on the page-->
	<xsl:param name="navbar_lowerrange" select="floor(/H2G2/USERS-LIST/@SKIP div ($navbar_split * /H2G2/USERS-LIST/@SHOW)) * ($navbar_split * /H2G2/USERS-LIST/@SHOW)"/>
	<!--navbar_upperrange is the skip value of the first post of the last page of the series of tabs on the page-->
	<xsl:param name="navbar_upperrange" select="$navbar_lowerrange + (($navbar_split - 1) * /H2G2/USERS-LIST/@SHOW)"/>
	<!--
	<xsl:template match="USERS-LIST" mode="navbar_blockdisplay">
	Author:		Andy Harris
	Context:      /H2G2/USERS-LIST
	Purpose:	 One of the two templates which create the links in the block navigation
	-->
	<xsl:template match="USERS-LIST" mode="navbar_blockdisplay">
		<xsl:param name="skip" select="$navbar_lowerrange"/>
		<xsl:if test="not(@TOTALUSERS &lt; @SHOW)">
			<xsl:apply-templates select="." mode="displayblockmh">
				<xsl:with-param name="skip" select="$skip"/>
			</xsl:apply-templates>
			<xsl:if test="(($skip + @SHOW) &lt; @TOTALUSERS) and ($skip &lt; $navbar_upperrange)">
				<xsl:apply-templates select="." mode="navbar_blockdisplay">
					<xsl:with-param name="skip" select="$skip + @SHOW"/>
				</xsl:apply-templates>
			</xsl:if>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="USERS-LIST" mode="displayblockmh">
	Author:		Andy Harris
	Context:      /H2G2/USERS-LIST
	Purpose:	 The second of the two templates which create the links in the block navigation
	-->
	<xsl:template match="USERS-LIST" mode="displayblockmh">
		<xsl:param name="skip"/>
		<xsl:param name="PostRange" select="concat(($skip + 1), ' - ', ($skip + @SHOW))"/>
		<xsl:choose>
			<xsl:when test="@SKIP = $skip">
				<xsl:apply-templates select="." mode="on_blockdisplay">
					<xsl:with-param name="url">
						<a class="pageSelected">
							<xsl:attribute name="href">members?show=<xsl:value-of select="@SHOW"/>&amp;skip=<xsl:value-of select="$skip"/>&amp;direction=<xsl:value-of select="@DIRECTION"/>&amp;sortedon=<xsl:value-of select="@SORTEDON"/>&amp;siteid=<xsl:value-of select="@SITEID"/>&amp;s_classview=<xsl:value-of select="/H2G2/PARAMS/PARAM[NAME = 's_classview']/VALUE"/><xsl:choose><xsl:when test="@SEARCHTERM">&amp;search=search&amp;searchoption=<xsl:value-of select="@SEARCHOPTION"/>&amp;searchterm=<xsl:value-of select="@SEARCHTERM"/></xsl:when></xsl:choose></xsl:attribute>
							<xsl:call-template name="ontabcontent">
								<xsl:with-param name="range" select="$PostRange"/>
								<xsl:with-param name="pagenumber" select="substring-after($PostRange, ' - ') div @SHOW"/>
							</xsl:call-template>
						</a>
					</xsl:with-param>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="." mode="off_blockdisplay">
					<xsl:with-param name="url">
						<a>
							<xsl:attribute name="href">members?show=<xsl:value-of select="@SHOW"/>&amp;skip=<xsl:value-of select="$skip"/>&amp;direction=<xsl:value-of select="@DIRECTION"/>&amp;sortedon=<xsl:value-of select="@SORTEDON"/>&amp;siteid=<xsl:value-of select="@SITEID"/>&amp;s_classview=<xsl:value-of select="/H2G2/PARAMS/PARAM[NAME = 's_classview']/VALUE"/><xsl:choose><xsl:when test="@SEARCHTERM">&amp;search=search&amp;searchoption=<xsl:value-of select="@SEARCHOPTION"/>&amp;searchterm=<xsl:value-of select="@SEARCHTERM"/></xsl:when></xsl:choose></xsl:attribute>
							<xsl:call-template name="offtabcontent">
								<xsl:with-param name="range" select="$PostRange"/>
								<xsl:with-param name="pagenumber" select="substring-after($PostRange, ' - ') div @SHOW"/>
							</xsl:call-template>
						</a>
					</xsl:with-param>
				</xsl:apply-templates>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="USERS-LIST" mode="navabr_goto">
	Author:		Andy Harris
	Context:      /H2G2/USERS-LIST
	Purpose:	 The template which creates the goto area in the navbar
	-->
	<xsl:template match="USERS-LIST" mode="navbar_goto">
		<xsl:param name="position">Top</xsl:param>
		<xsl:if test="@TOTALUSERS &gt; @SHOW">
			<form action="members" id="gotoSelect{$position}">
				<input type="hidden" name="show" value="{@SHOW}"/>
				<input type="hidden" name="direction" value="{@DIRECTION}"/>
				<input type="hidden" name="sortedon" value="{@SORTEDON}"/>
				<input type="hidden" name="siteid" value="{@SITEID}"/>
				<input type="hidden" name="s_classview" value="{/H2G2/PARAMS/PARAM[NAME = 's_classview']/VALUE}"/>
				<xsl:choose>
					<xsl:when test="@SEARCHTERM">
						<input type="hidden" name="search" value="search"/>
						<input type="hidden" name="searchoption" value=""/>
						<input type="hidden" name="searchterm" value="{@SEARCHTERM}"/>
					</xsl:when>
				</xsl:choose>
				<p>
					<xsl:text>Jump To:</xsl:text>
				</p>
				<select name="skip">
					<xsl:apply-templates select="." mode="navbar_gotodropdown">
						<xsl:with-param name="page">0</xsl:with-param>
					</xsl:apply-templates>
				</select>
				<input type="submit" value="Go"/>
			</form>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="USERS-LIST" mode="navabr_gotodropdown">
	Author:		Andy Harris
	Context:      /H2G2/USERS-LIST
	Purpose:	 The template which creates the goto dropdown in the navbar
	-->
	<xsl:template match="USERS-LIST" mode="navbar_gotodropdown">
		<xsl:param name="page"/>
		<xsl:choose>
			<xsl:when test="($page * @SHOW) &lt; (@TOTALUSERS - @SHOW)">
				<option value="{$page * @SHOW}">
					<xsl:value-of select="$page + 1"/>
				</option>
				<xsl:apply-templates select="." mode="navbar_gotodropdown">
					<xsl:with-param name="page">
						<xsl:value-of select="$page + 1"/>
					</xsl:with-param>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:otherwise>
				<option value="{$page * @SHOW}">
					<xsl:value-of select="$page + 1"/>
				</option>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
