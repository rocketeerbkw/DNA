<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	version="1.0" 
	xmlns:doc="http://www.bbc.co.uk/dna/documentation" 
	xmlns="http://www.w3.org/1999/xhtml" 
	exclude-result-prefixes="doc">
	
	<xsl:template match="H2G2[@TYPE = 'USERLIST']" mode="page">
    
		<xsl:call-template name="objects_links_breadcrumb">
			<xsl:with-param name="pagename" > user list</xsl:with-param>
		</xsl:call-template>    

		<div class="dna-mb-intro blq-clearfix">
			<div class="dna-userlist dna-fl dna-main-full">
				<p>Search for users of your sites. View their details, modify their moderation status, reset their display names.</p>
				<form action="UserList" method="get">
					<fieldset class="dna-fl dna-search-userlist">
						<label>Search for user:</label>
						<input type="text" id="searchText" name="searchText">
							<xsl:attribute name="value">
								<xsl:value-of select="/H2G2/MEMBERLIST/@SEARCHTEXT"/>
							</xsl:attribute>
						</input>
					</fieldset>
					<h5 class="dna-fl">Search by:</h5>
					<fieldset class="dna-typelist">
						<ul class="dna-fl">
							<li>
								<label for="searchType_0">User ID</label>
								<input id="searchType_0" type="radio" name="usersearchtype" value="0">
									<xsl:attribute name="checked">checked</xsl:attribute>
								</input>
							</li>
							<li>
								<label for="searchType_1">Email</label>
								<input id="searchType_1" type="radio" name="usersearchtype" value="1">
									<xsl:if test="/H2G2/MEMBERLIST/@USERSEARCHTYPE = '1'">
										<xsl:attribute name="checked">checked</xsl:attribute>
									</xsl:if>
								</input>
							</li>
							<li>
								<label for="searchType_2">User Name</label>
								<input id="searchType_2" type="radio" name="usersearchtype" value="2">
									<xsl:if test="/H2G2/MEMBERLIST/@USERSEARCHTYPE = '2'">
										<xsl:attribute name="checked">checked</xsl:attribute>
									</xsl:if>
								</input>
							</li>
						</ul>
						<ul class="dna-fl">
							<li>
								<label for="searchType_3">IP Address</label>
								<input id="searchType_3" type="radio" name="usersearchtype" value="3">
									<xsl:if test="/H2G2/MEMBERLIST/@USERSEARCHTYPE = '3'">
										<xsl:attribute name="checked">checked</xsl:attribute>
									</xsl:if>
								</input>
							</li>
							<li>
								<label for="searchType_4">BBCUID</label>
								<input id="searchType_4" type="radio" name="usersearchtype" value="4">
									<xsl:if test="/H2G2/MEMBERLIST/@USERSEARCHTYPE = '4'">
										<xsl:attribute name="checked">checked</xsl:attribute>
									</xsl:if>
								</input>
							</li>
							<li>
								<label for="searchType_5">Login Name</label>
								<input id="searchType_5" type="radio" name="usersearchtype" value="5">
									<xsl:if test="/H2G2/MEMBERLIST/@USERSEARCHTYPE = '5'">
										<xsl:attribute name="checked">checked</xsl:attribute>
									</xsl:if>
								</input>
							</li>
						</ul>
					</fieldset>
					<div class="dna-fr dna-buttons">
						<span class="dna-buttons"><input type="submit" value="Search" /></span>
					</div>
				</form>	
				<xsl:if test="/H2G2/MEMBERLIST/@SEARCHTEXT != ''">
					<xsl:choose>
						<xsl:when test="/H2G2/MEMBERLIST/@COUNT = '0'">
							<p>No users found matching these details.</p>
						</xsl:when>
					</xsl:choose>
				</xsl:if>			
			</div>
		</div>

		<xsl:choose>
			<xsl:when test="/H2G2/MEMBERLIST/@SEARCHTEXT != ''">
				<xsl:choose>
					<xsl:when test="/H2G2/MEMBERLIST/@COUNT != '0'">
						<form action="UserList?searchText={@SEARCHTEXT}&amp;usersearchType={@USERSEARCHTYPE}" method="post" id="modStatusForm" class="dna-fl dna-main-full">		
							<div class="dna-main dna-main-bg dna-main-pad blq-clearfix">
								<div class="dna-fl dna-main-full">
									<div class="dna-box">
										<h3>Users Found</h3>
										<xsl:apply-templates select="/H2G2/MEMBERLIST" />
									</div>
								</div>
							</div>
							<div class="dna-main dna-main-bg dna-main-pad blq-clearfix">
								<div class="dna-fl dna-main-full">
									<div class="dna-box">
										<xsl:call-template name="moderation_actions" />
									</div>
								</div>
							</div>							
						</form>
					</xsl:when>
				</xsl:choose>
			</xsl:when>
		</xsl:choose>						
	</xsl:template>

	<xsl:template match="MEMBERLIST">
		<div class="dna-fl dna-main-full">
			<p><strong><xsl:value-of select="/H2G2/MEMBERLIST/@COUNT"/> users found.</strong></p>
			<table class="dna-dashboard-activity dna-userlist">
				<thead>
					<tr>
						<th><label for="applyToAll">All</label><input type="checkbox" name="applyToAll" id="applyToAll" /></th>
						<th>DNA user number</th>
						<th>Display name</th>
						<th>Username</th>
						<th>Email</th>
						<th>Moderation status</th>
						<th>Identity user ID</th>
						<th>Active</th>
						<th>Date Joined</th>
					</tr>
				</thead>
				<tbody>	
					<xsl:apply-templates select="/H2G2/MEMBERLIST/USERACCOUNTS/USERACCOUNT" />
				</tbody>
			</table>
			<p><strong><xsl:value-of select="/H2G2/MEMBERLIST/@COUNT"/> users found.</strong></p>
		</div>
	</xsl:template>
	
	<xsl:template match="USERACCOUNT">
		<tr>
			<xsl:call-template name="objects_stripe" />	
			<td>
				<input type="checkbox" name="applyTo|{@USERID}|{SITEID}" id="applyTo|{@USERID}|{SITEID}" class="applyToCheckBox"/>
			</td>
			<td><xsl:value-of select="@USERID"/></td>
			<td>
				<a href="MemberDetails?userid={@USERID}" title="View users details"><xsl:value-of  select="USERNAME"/></a>
			</td>
			<td><xsl:value-of select="LOGINNAME"/></td>
			<td><xsl:value-of  select="EMAIL"/></td>
			<td>
				<xsl:choose>
					<xsl:when test="ACTIVE = '1'">
						<img alt="{USERSTATUSDESCRIPTION}" src="/dnaimages/moderation/images/icons/status{PREFSTATUS}.gif" />
						<xsl:choose>
							<xsl:when test="PREFSTATUSDURATION != '0'">
								<br />
								<xsl:choose>
									<xsl:when test="PREFSTATUSDURATION = '1440'">(1 Day)</xsl:when>
									<xsl:when test="PREFSTATUSDURATION = '10080'">(1 Week)</xsl:when>
									<xsl:when test="PREFSTATUSDURATION = '20160'">(2 Weeks)</xsl:when>
									<xsl:when test="PREFSTATUSDURATION = '40320'">(1 Month)</xsl:when>
								</xsl:choose>
							</xsl:when>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>
						<img alt="Inactive" src="/dnaimages/moderation/images/icons/status4.gif" />
					</xsl:otherwise>
				</xsl:choose>
			</td>
			<td><xsl:value-of  select="IDENTITYUSERID"/></td>
			<td>
				<xsl:choose>
					<xsl:when test="ACTIVE = '1'"><xsl:text>yes</xsl:text></xsl:when>
					<xsl:when test="ACTIVE = '0'"><xsl:text>no</xsl:text></xsl:when>
				</xsl:choose>
			</td>
			<td>
				<xsl:choose>
					<xsl:when test="DATEJOINED">
						<xsl:value-of select="concat(DATEJOINED/DATE/@DAY, '/',DATEJOINED/DATE/@MONTH,'/',DATEJOINED/DATE/@YEAR)"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>-</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</td>			
		</tr>
	</xsl:template>
	
	<xsl:template name="moderation_actions">
		<h3>Moderation Actions</h3>
		<fieldset class="dna-fl dna-search-userlist">
			<div>
				<label for="userStatusDescription">Moderation Status</label>
				<select id="userStatusDescription" name="userStatusDescription">
					<option value="Standard" selected="selected">Standard</option>
					<option value="Premoderate">Premoderate</option>
					<option value="Postmoderate">Postmoderate</option>
					<option value="Restricted">Banned</option>
					<xsl:if test="/H2G2/VIEWING-USER/USER/STATUS = '2'">
						<option value="Deactivate">Deactivate</option>
					</xsl:if>
				</select>
			</div>
			<div id="durationContainer">
				<label for="duration">Duration:</label>
				<select id="duration" name="duration">
					<option value="0" selected="selected">no limit</option>
					<option value="1440">1 day</option>
					<option value="10080">1 week</option>
					<option value="20160">2 weeks</option>
					<option value="40320">1 month</option>
				</select>
			</div>
			<div id="hideAllPostsContainer">
				<label for="hideAllPosts">Hide all content</label>
				<input type="checkbox" name="hideAllPosts" id="hideAllPosts" /> 
			</div>
			<div>
				<label for="reasonChange">Reason for change:</label>
				<textarea id="reasonChange" name="reasonChange" cols="50" rows="5">
					<xsl:text>&#x0A;</xsl:text>
				</textarea>
			</div>
		</fieldset>
		<fieldset class="dna-fl dna-search-userlist">
			<ul>
				<li class="dna-fl">
					<span class="dna-buttons">
						<input type="submit" value="Apply action to marked accounts" id="ApplyAction" name="ApplyAction"></input>
					</span>
				</li>
				<li class="dna-fl">
					Alternatively:
					<span class="dna-buttons">
						<input type="submit" id="ApplyNickNameReset" value="Reset display name" name="ApplyNickNameReset" />
					</span>
				</li>	
			</ul>
		</fieldset>
	</xsl:template>

</xsl:stylesheet>
