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

	<xsl:template match="H2G2[@TYPE = 'HOSTDASHBOARDACTIVITYPAGE']" mode="page">
		
		<xsl:call-template name="objects_links_breadcrumb">
			<xsl:with-param name="pagename" >activity</xsl:with-param>
		</xsl:call-template>
		
		<div class="dna-mb-intro blq-clearfix">
			<div class="dna-fl dna-main-full">
				<form method="get" action="hostdashboardactivity"> 
					<fieldset>
						<label for="s_startdate">Start Date:</label>
						<input type="text" name="s_startdate" id="s_startdate" /> (Format:YYYY-MM-DD)<br/>
					</fieldset>
					<fieldset class="dna-typelist">
						<xsl:apply-templates select="SITEEVENTLIST/SELECTEDTYPES" mode="objects_activitydata_typelist" />
						
						<xsl:if test="/H2G2/PARAMS/PARAM[/H2G2/PARAMS/PARAM/NAME = 's_userid']/VALUE != ''" >
							<input type="hidden" name="s_userid" value="{PARAMS/PARAM[NAME = 's_userid']/VALUE}" />
						</xsl:if>
					</fieldset>
					<div class="dna-fr dna-buttons">
						<input type="submit" value="go" />
					</div>
				</form>	
			</div>
		</div>
		
		<div class="dna-main dna-main-bg dna-main-pad blq-clearfix">
			<div class="dna-fl dna-main-full">
				<div class="dna-box">
					<h3>Activity for <xsl:value-of select="$dashboardtype" /><xsl:if test="not($dashboardtype = 'all')">s</xsl:if></h3>
					
					<xsl:choose>
						<xsl:when test="SITEEVENTLIST/SITEEVENTS/SITEEVENT != ''">
							<xsl:apply-templates select="SITEEVENTLIST" mode="library_pagination_forumthreadposts"/>
							
							<div class="dna-fl dna-main-full">
								<table class="dna-dashboard-activity">
									<thead>
										<tr>
											<th class="date">Date</th>
											<th class="activity">Activity</th>
											<th class="type">Type</th>
										</tr>
									</thead>
									<tbody>
										<xsl:apply-templates select="SITEEVENTLIST/SITEEVENTS/SITEEVENT" mode="objects_moderator_siteevent" />
									</tbody>
								</table>
							</div>
							<div class="dna-fr">
								<xsl:apply-templates select="SITEEVENTLIST" mode="library_pagination_forumthreadposts"/>
							</div>
						</xsl:when>
						<xsl:otherwise>
							<div class="dna-fl dna-main-full">
								<p>There is no activity.</p>
							</div>							
						</xsl:otherwise>
					</xsl:choose>
				</div>
			</div>
		</div>
				
	</xsl:template>
	
</xsl:stylesheet>
