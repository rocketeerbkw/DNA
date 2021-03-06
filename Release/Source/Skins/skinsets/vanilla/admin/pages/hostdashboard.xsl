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

  <xsl:template match="H2G2[@TYPE = 'HOSTDASHBOARD']" mode="page">
    
    <div class="dna-mb-intro blq-clearfix">
    	<xsl:apply-templates select="VIEWING-USER/USER" mode="objects_user_welcome" />
	    <div class="dna-fr">
			<form method="get" action="hostdashboard">
				<fieldset>
					<input type="hidden" name="s_type"
						value="{/H2G2/PARAMS/PARAM[/H2G2/PARAMS/PARAM/NAME = 's_type']/VALUE}" />
			
					<xsl:if test="/H2G2/PARAMS/PARAM[/H2G2/PARAMS/PARAM/NAME = 's_userid']/VALUE != ''">
						<input type="hidden" name="s_userid" value="{PARAMS/PARAM[NAME = 's_userid']/VALUE}" />
					</xsl:if>
		
					<xsl:if test="/H2G2/PARAMS/PARAM[NAME = 's_type']/VALUE != 0 or /H2G2/PARAMS/PARAM[NAME = 's_type']/VALUE">
						<select name="s_siteid" id="s_siteid">
				    		<option selected="selected" value="all">All <xsl:value-of select="$dashboardtypeplural" /></option>
				    		<xsl:for-each select="MODERATOR-HOME/MODERATOR/SITES/SITE[@TYPE = /H2G2/PARAMS/PARAM[NAME = 's_type']/VALUE and @CLASSID != 2]">
			    				<xsl:sort select="." />
			    				<xsl:variable name="modsiteid" select="@SITEID" />
								<option value="{$modsiteid}">
									<xsl:if test="/H2G2/PARAMS/PARAM[NAME = 's_siteid']/VALUE = $modsiteid"> 
										<xsl:attribute name="selected">selected</xsl:attribute>
									</xsl:if>
									<xsl:value-of select="/H2G2/SITE-LIST/SITE[@ID = $modsiteid]/DESCRIPTION" />
								</option> 
				    		</xsl:for-each>
<!-- 				    		<xsl:apply-templates select="MODERATOR-HOME/MODERATOR/SITES/SITE[@TYPE = /H2G2/PARAMS/PARAM[NAME = 's_type']/VALUE and @CLASSID != 2]" mode="objects_moderator_sites"> -->
<!-- 				    			<xsl:sort select="/H2G2/SITE-LIST/SITE/DESCRIPTION" /> -->
<!-- 				    		</xsl:apply-templates> -->
				    		<option value="all">--++== All Sites Below Are Closed! ==++--</option>
				    		<xsl:apply-templates select="MODERATOR-HOME/MODERATOR/SITES/SITE[@TYPE = /H2G2/PARAMS/PARAM[NAME = 's_type']/VALUE and @CLASSID = 2]" mode="objects_moderator_sites">
				    			<xsl:sort select="DESCRIPTION" />
				    		</xsl:apply-templates>
				    	</select>
						<div class="dna-buttons">
							<input type="submit" value="go" />
						</div>
					</xsl:if>
				</fieldset>
		    </form>
	    </div>	
    </div>    
	
	<div class="dna-main dna-main-bg dna-main-pad blq-clearfix">
		<div class="dna-fl dna-main-full">
			<div class="dna-fl dna-main-threequarter">
				<div class="dna-box">
					<h3>Referrals <xsl:call-template name="objects_subheading" /></h3>
					<xsl:apply-templates select="MODERATOR-HOME/MODERATION-QUEUES" mode="objects_moderator_queuedreffered" />
				</div>
			</div>
			
			<div class="dna-fr dna-main-threequarter">
				<div class="dna-box dna-mod-stats">
					<h3>Moderation statistics  <xsl:call-template name="objects_subheading" /></h3>
					<xsl:apply-templates select="MODERATOR-HOME/MODERATION-QUEUES" mode="objects_moderator_queued" />
				</div>
			</div>			
		</div>
		
		<div class="dna-fl dna-main-full dna-dashboard-box">
			<div class="dna-fl dna-main-right dna-boxspace">
				<div class="dna-box">
					<h3>Activity  <xsl:call-template name="objects_subheading" /></h3>
          			<xsl:apply-templates select="SITESUMMARYSTATS" mode="objects_moderator_sitesummarystats" />
				</div>
			</div>				
			
			<div class="dna-fl dna-main-right dna-boxspace">
				<div class="dna-box">
					<h3>site admin &amp; user management</h3>
					<xsl:choose>
						<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_type']/VALUE = 0 or not(/H2G2/PARAMS/PARAM[NAME = 's_type']/VALUE)">
							<p>To perform site admin please choose a site type from the tabs above</p>
						</xsl:when>
						<xsl:otherwise><p>To perform site admin please choose a <xsl:value-of select="$dashboardtype" /> from the drop down above.</p></xsl:otherwise>
					</xsl:choose>						
					<ul class="dna-list-links">
						<!-- if an option is selected then show admin links -->
						<xsl:if test="SITESUMMARYSTATS/@SITEID = /H2G2/PARAMS/PARAM[NAME = 's_siteid']/VALUE"> 
							<xsl:call-template name="objects_links_admin" />
						</xsl:if>
						<li><a href="userlist?{$dashboardsiteuser}">Look up user</a></li>
            <xsl:choose>
              <xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_type']/VALUE = 5">
                <xsl:variable name="siteId" select="/H2G2/PARAMS/PARAM[NAME = 's_siteid']/VALUE"/>
                <xsl:if test="/H2G2/VIEWING-USER/USER/STATUS = 1">
                  <xsl:if test="/H2G2/PARAMS/PARAM[NAME = 's_siteid']/VALUE != 0">
                    <li><a href="/dna/moderation/admin/commentforumlist?dnasiteid={$siteId}">Comment Forum List</a></li>
                  </xsl:if>
                  <li><a href="twitterprofilelist" target="_blank">Tweet Module Admin Console</a></li>
                  <li><a href="/dna/moderation/moderationhome" target="_blank">Moderation Homepage</a></li>
                </xsl:if>
                <xsl:if test="/H2G2/VIEWING-USER/USER/STATUS = 2">
                  <xsl:if test="/H2G2/PARAMS/PARAM[NAME = 's_siteid']/VALUE != 0">
                    <li><a href="/dna/moderation/admin/commentforumlist?dnasiteid={$siteId}">Comment Forum List</a></li>
                  </xsl:if>
                  <li><a href="twitterprofilelist" target="_blank">Tweet Module Admin Console</a></li>
                  <li><a href="sitemanager">Site Manager</a></li>
                  <li><a href="userreputationreport">User Reputation Report</a></li>
                  <li><a href="termsfilteradmin">Terms Filter Admin</a></li>
                  <li><a href="/dna/moderation/moderationhome" target="_blank">Moderation Homepage</a></li>
                  <li><a href="/dna/moderation/moderatormanagement" target="_blank">Moderator Management</a></li>
		              <li><a href="/dna/moderation/moderatestats" target="_blank">Moderation Stats</a></li>
                </xsl:if>
              </xsl:when>
              <xsl:otherwise>
                <xsl:if test="/H2G2/VIEWING-USER/USER/STATUS = 1">

                </xsl:if>
                <xsl:if test="/H2G2/VIEWING-USER/USER/STATUS = 2">
                  <li><a href="sitemanager">Site Manager</a></li>
                  <li><a href="userreputationreport">User Reputation Report</a></li>
                  <li><a href="termsfilteradmin">Terms Filter Admin</a></li>
                  <li><a href="/dna/moderation/moderationhome" target="_blank">Moderation Homepage</a></li>
                  <li><a href="/dna/moderation/moderatormanagement" target="_blank">Moderator Management</a></li>
		              <li><a href="/dna/moderation/moderatestats" target="_blank">Moderation Stats</a></li>
                </xsl:if>
              </xsl:otherwise>
            </xsl:choose>				
					</ul>
				</div>
			</div>
				
			<div class="dna-fl dna-main-right">
				<div class="dna-box">
					<h3>Useful links</h3>
					<xsl:call-template name="objects_links_useful" />
				</div>
			</div>
		</div>		
	</div>
	
  </xsl:template>
	
</xsl:stylesheet>
