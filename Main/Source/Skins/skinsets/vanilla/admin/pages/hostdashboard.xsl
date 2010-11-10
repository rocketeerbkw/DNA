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
    
	<div class="dna-main dna-main-bg dna-main-pad blq-clearfix">
  
	    <xsl:apply-templates select="VIEWING-USER/USER" mode="objects_user_welcome" />
	    
	    <div class="dna-fr dna-main-right">
		    <form method="get" action="hostdashboard" class="dna-fr"> 
		    	<fieldset>
		    		<input type="hidden" name="s_type" value="{/H2G2/PARAMS/PARAM[/H2G2/PARAMS/PARAM/NAME = 's_type']/VALUE}" />
		            
		            <xsl:if test="/H2G2/PARAMS/PARAM[/H2G2/PARAMS/PARAM/NAME = 's_userid']/VALUE != ''" >
				    	<input type="hidden" name="s_userid" value="{PARAMS/PARAM[NAME = 's_userid']/VALUE}" />
		            </xsl:if>
            		
            		<xsl:if test="/H2G2/PARAMS/PARAM[NAME = 's_type']/VALUE != 0 or /H2G2/PARAMS/PARAM[NAME = 's_type']/VALUE">
				    	<select name="s_siteid" id="s_siteid">
				    		<option selected="selected" value="all">All <xsl:value-of select="$dashboardtype" />s</option>
				    		<xsl:apply-templates select="MODERATORHOME/MODERATOR/SITES/SITE[@TYPE = /H2G2/PARAMS/PARAM[/H2G2/PARAMS/PARAM/NAME = 's_type']/VALUE]" mode="objects_moderator_sites" />
				    	</select>
				    	<input type="submit" value="go" />
			    	</xsl:if>
		    	</fieldset>
		    </form>	
	    </div>
	    
		<div class="dna-fl dna-main-full">
			<div class="dna-fl dna-main-threequarter">
				<div class="dna-box">
					<h3>Referrals <xsl:if test="/H2G2/PARAMS/PARAM[NAME = 's_siteid']">for <xsl:value-of select="/H2G2/SITE-LIST/SITE[@ID = /H2G2/PARAMS/PARAM[NAME = 's_siteid']/VALUE]/DESCRIPTION" /></xsl:if></h3>
					<xsl:apply-templates select="MODERATORHOME/MODERATIONQUEUES" mode="objects_moderator_queuedreffered" />
				</div>
			</div>
			
			<div class="dna-fr dna-main-right">
				<div class="dna-box">
					<h3>Activity</h3>
          			<xsl:apply-templates select="SITESUMMARYSTATS " mode="objects_moderator_queuesummary" />
				</div>
			</div>			
			
			<div class="dna-fl dna-main-threequarter">
				<div class="dna-box">
					<h3>Moderation statistics <xsl:if test="/H2G2/PARAMS/PARAM[NAME = 's_siteid']">on <xsl:value-of select="/H2G2/SITE-LIST/SITE[@ID = /H2G2/PARAMS/PARAM[NAME = 's_siteid']/VALUE]/DESCRIPTION" /></xsl:if></h3>
					<xsl:apply-templates select="MODERATORHOME/MODERATIONQUEUES" mode="objects_moderator_queued" />
				</div>
			</div>			
		</div>
		
		<div class="dna-fl dna-main-full">
			<div class="dna-fl dna-main-right dna-boxspace">
				<div class="dna-box">
					<h3><xsl:value-of select="$dashboardtype" /> admin links</h3>
					<xsl:choose>
						<!-- if an option is selected then show admin links -->
						<xsl:when test="SITESUMMARYSTATS/@SITEID = /H2G2/PARAMS/PARAM[NAME = 's_siteid']/VALUE"> 
							<xsl:call-template name="objects_links_admin" />
						</xsl:when>
						<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_type']/VALUE = 0 or not(/H2G2/PARAMS/PARAM[NAME = 's_type']/VALUE)">
							<p>Please select a site type.</p>
						</xsl:when>
						<xsl:otherwise><p>Please select a <xsl:value-of select="$dashboardtype" /> from the drop down menu above.</p></xsl:otherwise>
					</xsl:choose>
				</div>
			</div>
			
			<div class="dna-fl dna-main-right dna-boxspace">
				<div class="dna-box">
					<h3>User management</h3>
					<xsl:call-template name="objects_links_usermanagement" />
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
