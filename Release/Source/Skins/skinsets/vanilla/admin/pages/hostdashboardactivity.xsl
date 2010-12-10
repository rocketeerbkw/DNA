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
		
		<a href="#activity" class="blq-hide">Skip to activity</a>
		
		<xsl:call-template name="objects_links_breadcrumb">
			<xsl:with-param name="pagename" > activity page</xsl:with-param>
		</xsl:call-template>
		
		<div class="dna-mb-intro blq-clearfix">
			<div class="dna-fl dna-main-full">
				
				<form method="get" action="hostdashboardactivity"> 
					<fieldset>
						<label for="s_startdate">Start date:</label> <small> (Format:YYYY-MM-DD)</small>
						<input type="text" name="s_startdate" id="s_startdate">
							<xsl:attribute name="value">
								<xsl:if test="SITEEVENTLIST/STARTDATE">
									<xsl:value-of select="concat(SITEEVENTLIST/STARTDATE/DATE/@YEAR,'-',SITEEVENTLIST/STARTDATE/DATE/@MONTH,'-',SITEEVENTLIST/STARTDATE/DATE/@DAY)"/>
								</xsl:if>
							</xsl:attribute>
						</input>
					</fieldset>
					<fieldset>
						<label for="s_enddate">End date:</label>
						<small> (Format:YYYY-MM-DD)</small>
						<input type="text" name="s_enddate" id="s_enddate">
							<xsl:attribute name="value">
								<xsl:if test="SITEEVENTLIST/ENDDATE">
									<xsl:value-of select="concat(SITEEVENTLIST/ENDDATE/DATE/@YEAR,'-',SITEEVENTLIST/ENDDATE/DATE/@MONTH,'-',SITEEVENTLIST/ENDDATE/DATE/@DAY)"/>
								</xsl:if>
							</xsl:attribute>
						</input>
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
					<h3 id="activity">Activity for 
						<xsl:choose>
							<xsl:when test="$dashboardtypedescription != ''">
								<xsl:value-of select="$dashboardtypedescription" />
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$dashboardtypeplural" />
							</xsl:otherwise>
						</xsl:choose>
					</h3>
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
							<xsl:apply-templates select="SITEEVENTLIST" mode="library_pagination_forumthreadposts"/>
						</xsl:when>
						<xsl:otherwise>
							<div class="dna-fl dna-main-full">
								<p>There is no activity to display. Please choose or change your start date and activity.</p>
							</div>							
						</xsl:otherwise>
					</xsl:choose>
				</div>
			</div>
		</div>
				
	</xsl:template>
	
</xsl:stylesheet>
