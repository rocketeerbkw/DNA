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

	<xsl:template match="H2G2[@TYPE = 'USERCONTRIBUTIONS']" mode="page">
		
		<xsl:call-template name="objects_links_breadcrumb">
			<xsl:with-param name="pagename" >user contributions for <xsl:value-of select="/H2G2/CONTRIBUTIONS/@USERID" /></xsl:with-param>
		</xsl:call-template>	
	
		<div class="dna-mb-intro blq-clearfix">
			<p>Below is a list of a users contributions across DNA services</p>
			<form method="get" action="usercontributions">
				<fieldset>
					<label for="s_userid">User Id:</label> <input type="text" name="s_userid" id="s_userid" value="{/H2G2/CONTRIBUTIONS/@USERID}"/> <a href="userlist">Find more users</a>
					<br /><br />
					<label for="s_startdate">Start Date:</label> <input type="text" name="s_startdate" id="s_startdate" value=""/> (Format: YYYY-MM-DD)
				</fieldset>
				<div class="dna-buttons dna-fr">
					<input type="submit" value ="Get Posts"/>
				</div>				
			</form>
		</div>
		<div class="dna-main dna-main-bg dna-main-pad blq-clearfix">
			<div class="dna-main dna-main-full">
				<div class="dna-box">
					<h3>User contributions for <xsl:value-of select="/H2G2/CONTRIBUTIONS/@USERID" /></h3>
					<xsl:apply-templates select="CONTRIBUTIONS" mode="library_pagination_forumthreadposts" />
					<div class="dna-fl dna-main-full">
						<table class="dna-dashboard-activity dna-dashboard-contributions">
							<thead>
								<tr>
									<th class="date">Date</th>
									<th>Post details</th>
									<th>Post</th>
									<th class="type">Reason</th>
								</tr>
							</thead>
							<tbody>
								<xsl:apply-templates select="/H2G2/CONTRIBUTIONS/CONTRIBUTIONITEMS/CONTRIBUTIONITEM" mode="objects_contributions_contribution" />
							</tbody>
						</table>
					</div>
					<xsl:apply-templates select="CONTRIBUTIONS" mode="library_pagination_forumthreadposts" />
				</div>
			</div>
		</div>
	</xsl:template>
	
</xsl:stylesheet>
