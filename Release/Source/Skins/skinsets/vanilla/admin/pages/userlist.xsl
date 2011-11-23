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
								<label for="searchType_0">DNA user number</label>
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
								<label for="searchType_2">Display name</label>
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
								<label for="searchType_5">Username</label>
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
						<form action="UserList?searchText={/H2G2/MEMBERLIST/@SEARCHTEXT}&amp;usersearchType={/H2G2/MEMBERLIST/@USERSEARCHTYPE}" method="post" id="modStatusForm" class="dna-fl dna-main-full">		
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
                    <!-- h3>Moderation Actions</h3>
										<xsl:call-template name="moderation_actions" /-->
                    <fieldset class="dna-fl dna-search-userlist">
                      <ul class="blq-clearfix">
                        <!-- li class="dna-fl">
                          <span class="dna-buttons">
                            <input type="submit" value="Apply action to marked accounts" id="ApplyAction" name="ApplyAction"></input>
                          </span>
                        </li -->

                        <li class="dna-fl reset-display-name">
                          <!--strong>Alternatively:</strong -->
                          <span class="dna-buttons">
                            <input type="submit" id="ApplyNickNameReset" value="Reset display name" name="ApplyNickNameReset" />
                          </span>
                        </li>

                      </ul>
                    </fieldset>
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
			<p><strong><xsl:value-of select="/H2G2/MEMBERLIST/@COUNT"/> instances found.</strong></p>
			<table class="dna-dashboard-activity dna-userlist">
				<thead>
					<tr>
						<th class="narrow"><label for="applyToAll">All</label><input type="checkbox" name="applyToAll" id="applyToAll" /></th>
						<th>User numbers</th>
						<th>Display name</th>
						<th>Username</th>
						<th>Site</th>
						<th>Email</th>
						<th class="mid">Moderation status</th>
						<th class="mid">Date joined</th>
					</tr>
				</thead>
				<tbody>	
					<xsl:apply-templates select="/H2G2/MEMBERLIST/USERACCOUNTS/USERACCOUNT" />
				</tbody>
			</table>
			<p><strong><xsl:value-of select="/H2G2/MEMBERLIST/@COUNT"/> instances found.</strong></p>
		</div>
	</xsl:template>
	
	<xsl:template match="USERACCOUNT">
		<tr>
			<xsl:call-template name="objects_stripe" />	
			<td>
				<h4 class="blq-hide">Instance number <xsl:value-of select="position()" /></h4>
				<input type="checkbox" name="applyTo|{@USERID}|{SITEID}" id="applyTo|{@USERID}|{SITEID}" class="applyToCheckBox"/>
			</td>
			<td>
				<p><strong>DNA user number:</strong><br />
				<xsl:value-of select="@USERID"/></p>
				<p><strong>Identity user ID:</strong><br />
				<xsl:value-of  select="IDENTITYUSERID"/></p>
			</td>
			<td>
				<a href="MemberDetails?userid={@USERID}" title="View users details"><xsl:value-of  select="USERNAME"/></a>
			</td>
			<td><xsl:value-of select="LOGINNAME"/></td>
			<td><xsl:value-of select="SHORTNAME" /></td>
			<td><xsl:value-of  select="EMAIL"/></td>
			<td class="mod">
				<xsl:choose>
					<xsl:when test="ACTIVE = '1'">
						<xsl:apply-templates select="USERSTATUSDESCRIPTION" mode="objects_user_typeicon" />
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
						<xsl:apply-templates select="USERSTATUSDESCRIPTION" mode="objects_user_typeicon" />
					</xsl:otherwise>
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
	
	

</xsl:stylesheet>
