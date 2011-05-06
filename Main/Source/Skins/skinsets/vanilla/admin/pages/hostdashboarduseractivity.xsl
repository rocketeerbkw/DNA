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

	<xsl:template match="H2G2[@TYPE = 'HOSTDASHBOARDUSERACTIVITYPAGE']" mode="page">
		
		<a href="#activity" class="blq-hide">Skip to activity</a>
		
		<xsl:call-template name="objects_links_breadcrumb">
			<xsl:with-param name="pagename" > activity page</xsl:with-param>
		</xsl:call-template>
		
		<div class="dna-mb-intro blq-clearfix">
			<div class="dna-fl dna-main-full">
				
				<form method="get" action="hostdashboarduseractivity">
          <input type="hidden" name="s_user" id="s_user">
            <xsl:attribute name="value">
              <xsl:value-of select="USEREVENTLIST/@USERID"/>
            </xsl:attribute>
          </input>
          <xsl:if test="/H2G2/PARAMS/PARAM[NAME = 's_siteid']/VALUE != '0'">
            <input type="hidden" name="s_siteid" id="s_siteid">
              <xsl:attribute name="value">
                <xsl:value-of select="/H2G2/PARAMS/PARAM[NAME = 's_siteid']/VALUE"/>
              </xsl:attribute>
            </input>
          </xsl:if>
          <xsl:if test="/H2G2/PARAMS/PARAM[NAME = 's_modclassid']/VALUE != '0'">
            <input type="hidden" name="s_modclassid" id="s_modclassid">
              <xsl:attribute name="value">
                <xsl:value-of select="/H2G2/PARAMS/PARAM[NAME = 's_modclassid']/VALUE"/>
              </xsl:attribute>
            </input>
          </xsl:if>
					<fieldset>
						<label for="s_startdate">Start date:</label> <small> (Format:YYYY-MM-DD)</small>
						<input type="text" name="s_startdate" id="s_startdate">
							<xsl:attribute name="value">
								<xsl:if test="USEREVENTLIST/STARTDATE">
									<xsl:value-of select="concat(USEREVENTLIST/STARTDATE/DATE/@YEAR,'-',USEREVENTLIST/STARTDATE/DATE/@MONTH,'-',USEREVENTLIST/STARTDATE/DATE/@DAY)"/>
								</xsl:if>
							</xsl:attribute>
						</input>
					</fieldset>
					<fieldset>
						<label for="s_enddate">End date:</label>
						<small> (Format:YYYY-MM-DD)</small>
						<input type="text" name="s_enddate" id="s_enddate">
							<xsl:attribute name="value">
								<xsl:if test="USEREVENTLIST/ENDDATE">
									<xsl:value-of select="concat(USEREVENTLIST/ENDDATE/DATE/@YEAR,'-',USEREVENTLIST/ENDDATE/DATE/@MONTH,'-',USEREVENTLIST/ENDDATE/DATE/@DAY)"/>
								</xsl:if>
							</xsl:attribute>
						</input>
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
          <div class="dna-box-title">
          Activity for user 
            
            <a href="memberdetails?userid={USEREVENTLIST/@USERID}">
            <xsl:value-of select="USEREVENTLIST/@USERID"/>
            </a> on moderation class
          "<xsl:value-of select="USEREVENTLIST/MODERATIONCLASS/NAME"/>"
  				</div>
					<xsl:choose>
						<xsl:when test="USEREVENTLIST/USEREVENTLIST/USEREVENT != ''">
							<xsl:apply-templates select="USEREVENTLIST" mode="library_pagination_forumthreadposts"/>
							
							<div class="dna-fl dna-main-full">
								<table class="dna-dashboard-activity">
									<thead>
										<tr>
											<th class="date">Date</th>
											<th class="activity">Activity</th>
											<th class="type">Type</th>
                      <th class="type">Score</th>
										</tr>
									</thead>
									<tbody>
										<xsl:apply-templates select="USEREVENTLIST/USEREVENTLIST/USEREVENT" mode="objects_moderator_userevent" />
									</tbody>
								</table>
							</div>
							<xsl:apply-templates select="USEREVENTLIST" mode="library_pagination_forumthreadposts"/>
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
