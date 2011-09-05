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

    <div class="dna-main dna-main-bg dna-main-pad blq-clearfix">
      <div class="dna-fl dna-main-full">
        <div class="dna-box">

          <h3>User Reputation</h3>
          <div class="dna-fl dna-main-right">
            <p>
              User:<br/> <a href="memberdetails?userid={USEREVENTLIST/@USERID}">
                <xsl:value-of select="USERREPUTATION/USERNAME"/>
              </a>
            </p>
            <p>
              Current User Reputation Score:<br/> <xsl:value-of select="USERREPUTATION/REPUTATIONSCORE"/>
            </p>
            <p>
              Current Moderation Status:<br/>
              <xsl:apply-templates select="USERREPUTATION/CURRENTSTATUS" mode="objects_user_typeicon" />
            </p>
            <p>
              Reputation Determined Status:<br/>
              <xsl:apply-templates select="USERREPUTATION/REPUTATIONDETERMINEDSTATUS" mode="objects_user_typeicon" />
            </p>
            <p>
              Last Update:<br/>
              <xsl:apply-templates select="USERREPUTATION/LASTUPDATED/DATE" mode="library_time_shortformat" />
            <xsl:text> on </xsl:text>
            <span class="date">
              <xsl:apply-templates select="USERREPUTATION/LASTUPDATED/DATE" mode="library_date_shortformat" />
            </span>
            <br/>
            <xsl:text>(</xsl:text><xsl:value-of select="USERREPUTATION/LASTUPDATED/DATE/@RELATIVE"/><xsl:text>)</xsl:text>
            </p>
          </div>
          <xsl:if test="VIEWING-USER/USER/STATUS = 2">
            <div class="dna-fl dna-main-right">

              <form method="post" action="hostdashboarduseractivity?s_user={USEREVENTLIST/@USERID}&amp;s_siteid={/H2G2/PARAMS/PARAM[NAME = 's_siteid']/VALUE}&amp;s_modclassid={/H2G2/PARAMS/PARAM[NAME = 's_modclassid']/VALUE}" id="modStatusForm">
                <xsl:call-template name="moderation_actions" />
                <input type="submit" value="Update user status" id="ApplyAction" name="ApplyAction"></input>
              </form>


            </div>
          </xsl:if>
        </div>
      </div>
  </div>

  <div class="dna-main dna-main-bg dna-main-pad blq-clearfix">
    <div class="dna-fl dna-main-full">
      <div class="dna-box">
        <h3>
          Activity for user <xsl:value-of select="USEREVENTLIST/@USERID"/> on moderation class
          "<xsl:value-of select="USEREVENTLIST/MODERATIONCLASS/NAME"/>"
        </h3>
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
