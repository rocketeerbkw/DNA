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
	
	<xsl:template match="H2G2[@TYPE = 'TWITTERPROFILELIST']" mode="page">
		<xsl:call-template name="objects_links_breadcrumb">
			<xsl:with-param name="pagename">Twitter Profile List</xsl:with-param>
		</xsl:call-template> 
		 
	    <div class="twitter-admin">
	    	<div class="dna-mb-intro blq-clearfix">
	    		
	    		<xsl:choose>
		    		<xsl:when test="/H2G2/TWITTER-SITE-LIST/@COUNT != 0">
					    <form method="get" action="twitterprofilelist" class="blq-clearfix dna-fl"> 
					    	<fieldset>
						    	<label for="sites">Site:</label>
								  <select name="type" id="sites">
		                			<option value="">Select a site</option>
						    		<xsl:apply-templates select="/H2G2/TWITTER-SITE-LIST/SITE" mode="objects_sites_twittersites" />
						    	</select>
						    	<div class="dna-buttons sites">
						    		<input type="submit" value="Change site" />
						    	</div>
					    	</fieldset>
					    </form>
				    </xsl:when>
				    <xsl:otherwise>
				    	<p>There are no sites.</p>
				    </xsl:otherwise>
			    </xsl:choose>
			    
			    <form method="get" action="twitterprofilelist" class="blq-clearfix dna-fr">	
					  <fieldset>
			    		  <input type="hidden" name="s_activeonly">
			    			  <xsl:attribute name="value">
			    				  <xsl:choose>
			    					  <xsl:when test="/H2G2/PARAMS/PARAM[/H2G2/PARAMS/PARAM/NAME = 's_activeonly']/VALUE = 'on'">off</xsl:when>
			    					  <xsl:otherwise>on</xsl:otherwise>
			    				  </xsl:choose>
			    			  </xsl:attribute>
			    		  </input>					
						    <label for="activeonly">
							    <xsl:choose>
								    <xsl:when test="/H2G2/PARAMS/PARAM[/H2G2/PARAMS/PARAM/NAME = 's_activeonly']/VALUE = 'off'">
									    Show all profiles:
								    </xsl:when>
								    <xsl:otherwise>Show active profiles only:</xsl:otherwise>
							    </xsl:choose>
						    </label>
						  <!-- input type="checkbox" name="activeonly" id="activeonly">
							  <xsl:if test="ACTIVEONLY = TRUE">
								  <xsl:attribute name="checked">checked</xsl:attribute>
							  </xsl:if>
						  </input -->
						  <div class="dna-buttons">
							  <input type="submit">
								  <xsl:attribute name="value">
									  <xsl:choose>
										  <xsl:when test="/H2G2/PARAMS/PARAM[/H2G2/PARAMS/PARAM/NAME = 's_activeonly']/VALUE = 'off'">
											  <xsl:text>Show all</xsl:text>
										  </xsl:when>
										  <xsl:otherwise>Show active only</xsl:otherwise>
									  </xsl:choose>								
								  </xsl:attribute>
							  </input>
						  </div>					
					  </fieldset>
			    </form>    	
	    	
	    	</div>
	    	
		    <div class="dna-main dna-main-bg dna-main-pad blq-clearfix">
				<div class="dna-box">
					<h3>Number of profiles for <strong><xsl:value-of select="/H2G2/TWITTERPROFILELIST/TWITTERPROFILE/@SITETYPE" /></strong>: <xsl:value-of select="/H2G2/TWITTERPROFILELIST/@COUNT" /></h3>
					
		    		<xsl:call-template name="newprofilelink" />	 
		    		   	    	
					  <table>
						  <tr>
							  <th class="profileid">Profile Id</th>
							  <th>Active</th>
							  <th>Trusted Users</th>
							  <th>Counts Only</th>
							  <th>Keyword Counts</th>
							  <th>Moderated Tweets</th>
							  <th></th>
						  </tr>
						
						  <xsl:choose>
							<xsl:when test="/H2G2/TWITTERPROFILELIST/@COUNT = 0">
							  <tr>
								<td colspan="7">There are no Twitter profiles for this site</td>
							  </tr>
							</xsl:when>
							<xsl:otherwise>
							  <xsl:apply-templates select="/H2G2/TWITTERPROFILELIST/TWITTERPROFILE" />
							</xsl:otherwise>
						  </xsl:choose>
  						
					  </table>
		
			    	<xsl:call-template name="newprofilelink" />	
		    	
		    	</div>		
		    </div> 
		       
		</div>
	</xsl:template>
  
	<xsl:template name="newprofilelink">
		<div class="newprofilelink blq-clearfix">
			<ul class="dna-buttons">
				<li><a href="twitterprofile" target="_blank">New Profile</a></li>
			</ul>  
		</div>
	</xsl:template>
	  
	<xsl:template match="TWITTERPROFILE">
		<xsl:variable name="sitetype" select="@SITETYPE" />
		<xsl:variable name="profileid" select="PROFILEID" />
	  
		<tr>
			<td class="profileid"><xsl:value-of select="PROFILEID" /></td>
			<td><xsl:value-of select="ACTIVESTATUS" /></td>
			<td><xsl:value-of select="TRUSTEDUSERSTATUS" /></td>
			<td><xsl:value-of select="PROFILECOUNTSTATUS" /></td>
			<td><xsl:value-of select="PROFILEKEYWORDCOUNTSTATUS" /></td>
			<td><xsl:value-of select="MODERATIONSTATUS" /></td>
			<td><a href="twitterprofile?type={$sitetype}&amp;profileId={$profileid}&amp;action=getprofile" target="_blank">Edit</a></td>
		</tr>  
	</xsl:template>
	
</xsl:stylesheet>
