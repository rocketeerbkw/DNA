<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	version="1.0" 
	xmlns:doc="http://www.bbc.co.uk/dna/documentation" 
	xmlns="http://www.w3.org/1999/xhtml" 
	exclude-result-prefixes="doc">
	
	<doc:documentation>
		<doc:purpose>
			
		</doc:purpose>
		<doc:context>
			
		</doc:context>
		<doc:notes>
			
		</doc:notes>
	</doc:documentation>
	
	<xsl:template match="H2G2[@TYPE = 'MEMBERDETAILS']" mode="page">
		<xsl:call-template name="objects_links_breadcrumb">
			<xsl:with-param name="pagename" >member details for user id <xsl:value-of select="/H2G2/MEMBERDETAILSLIST/MEMBERDETAILS/USER/USERID" /></xsl:with-param>
		</xsl:call-template>
		
		<div class="dna-mb-intro">
			<p>Below is the list of posts and details of user.</p>
		</div>
	
		<div class="dna-main dna-main-bg dna-main-pad blq-clearfix">
			<div class="dna-fl dna-main-full">
				<div class="dna-box">
					<xsl:apply-templates select="MEMBERDETAILSLIST" mode="main_info"/>
				</div>
			</div>
		</div>
		
		<div class="dna-main dna-main-bg dna-main-pad blq-clearfix">
			<div class="dna-fl dna-main-full">
				<div class="dna-box">
					<xsl:apply-templates select="MEMBERDETAILSLIST/SUMMARY" mode="main_info"/>
				</div>
			</div>
		</div>		
	</xsl:template>

	<xsl:template match="MEMBERDETAILSLIST" mode="main_info">
		<h3>Member details for user id <xsl:value-of select="/H2G2/MEMBERDETAILSLIST/MEMBERDETAILS/USER/USERID" /></h3>
		
		<xsl:variable name="userid">
			<xsl:value-of select="@USERID"/>
		</xsl:variable>
		
		<ul class="dna-list-links dna-fr">
			<li><a href="usercontributions?s_user={$userid}">View contributions</a></li>
			<li><a href="MemberDetails?userid={$userid}">Find Alternate Identities using Email</a></li>
			<li><a href="MemberDetails?userid={$userid}&amp;findbbcuidaltidentities=1">Find Alternate Identities using BBCUID</a></li>
		</ul>
		
		<p>
			<strong>Name: </strong>
			<xsl:choose>
				<xsl:when test="not(string-length(MEMBERDETAILS/USER[USERID=$userid]/USERNAME) = 0)">
					<xsl:value-of select="MEMBERDETAILS/USER[USERID=$userid]/USERNAME"/>
				</xsl:when>
				<xsl:otherwise>No username</xsl:otherwise>
			</xsl:choose>
		</p>
		
		<p><strong>User ID: </strong><xsl:value-of select="$userid"/></p>
		<p>
			<strong>Email: </strong>
			<xsl:choose>
				<xsl:when test="not(string-length(MEMBERDETAILS/USER[USERID=$userid]/EMAIL) = 0)">
					<xsl:value-of select="MEMBERDETAILS/USER[USERID=$userid]/EMAIL"/>
				</xsl:when>
				<xsl:otherwise>No email</xsl:otherwise>
			</xsl:choose>
		</p>
	
		<div class="dna-fl dna-main-full">
			<table class="dna-dashboard-activity">
				<thead>
					<tr>
						<th>User Id</th>
						<th>User Name</th>
						<th>Site</th>
						<th>Status</th>
						<th>Date Joined</th>
						<th>Posts Passed</th>
						<th>Posts Failed</th>
						<th>Total Posts</th>
						<th>Articles Passed</th>
						<th>Articles Failed</th>
						<th>Total Articles</th>
					</tr>
				</thead>
				<xsl:apply-templates select="MEMBERDETAILS"/>
			</table>
		</div>
	</xsl:template>

	<xsl:template match="SUMMARY" mode="main_info">
		<h3>User Summary</h3>
		<div class="dna-fl dna-main-full">
			<table class="dna-dashboard-activity">
				<tr class="odd">
					<th>Posts Passed</th>
					<td class="type">
						<xsl:value-of select="POSTPASSEDCOUNT"/>
					</td>
				</tr>
				<tr>
					<th>Posts Failed</th>
					<td>
						<xsl:value-of select="POSTFAILEDCOUNT"/>
					</td>
				</tr>
				<tr class="odd">
					<th>Total Posts</th>
					<td>
						<xsl:value-of select="POSTTOTALCOUNT"/>
					</td>
				</tr>
				<tr>
					<th>Articles Passed</th>
					<td>
						<xsl:value-of select="ARTICLEPASSEDCOUNT"/>
					</td>
				</tr>
				<tr class="odd">
					<th>Articles Failed</th>
					<td>
						<xsl:value-of select="ARTICLEFAILEDCOUNT"/>
					</td>
				</tr>
				<tr>
					<th>Total Articles</th>
					<td>
						<xsl:value-of select="ARTICLETOTALCOUNT"/>
					</td>
				</tr>
			</table>
		</div>
	</xsl:template>

	<xsl:template match="MEMBERDETAILS">
		<xsl:variable name="userid" select="USER/USERID"/>
		<xsl:variable name="sitename">
			<xsl:value-of select="SITE/NAME"/><xsl:text>/</xsl:text>
		</xsl:variable>
		<tr>
	    	<xsl:if test="position() mod 2 = 1">
		    	<xsl:attribute name="class">odd</xsl:attribute>
	    	</xsl:if>			
			<td>
				<a href="UserList?searchText={$userid}&amp;usersearchtype=0">
					<xsl:value-of select="USER/USERID"/>
				</a>
			</td>
			<td>
				<xsl:value-of select="USER/USERNAME"/>
			</td>
			<td>
				<xsl:value-of select="SITE/NAME"/>
			</td>
			<td>
				<xsl:apply-templates select="USER/STATUS" mode="user_status"/>
				<xsl:apply-templates select="USER/GROUPS" mode="user_groups"/>    
			</td>
			<td>
				<xsl:apply-templates select="DATEJOINED/DATE"/>
			</td>
			<td>
				<xsl:value-of select="POSTPASSEDCOUNT"/>
			</td>
			<td>
				<xsl:value-of select="POSTFAILEDCOUNT"/>
			</td>
			<td>
				<a href="usercontributions?s_user={$userid}&amp;s_siteid={SITE/@ID}">
					<xsl:value-of select="POSTTOTALCOUNT"/>
				</a>
			</td>
			<td>
				<xsl:value-of select="ARTICLEPASSEDCOUNT"/>
			</td>
			<td>
				<xsl:value-of select="ARTICLEFAILEDCOUNT"/>
			</td>
			<td>
				<a href="/dna/{SITE/URLNAME}/MA{$userid}?type=2" target="_blank">
					<xsl:value-of select="ARTICLETOTALCOUNT"/>
				</a>
			</td>
		</tr>
	</xsl:template>
</xsl:stylesheet>