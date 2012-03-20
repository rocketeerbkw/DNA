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

  <xsl:template match="H2G2[@TYPE = 'TWITTERCREATEPROFILE']" mode="page">
  
	<xsl:call-template name="objects_links_breadcrumb">
		<xsl:with-param name="pagename">Create/Edit Twitter Profile</xsl:with-param>
	</xsl:call-template>
	<div class="twitter-admin">
		<div class="dna-mb-intro">
			<h2><xsl:value-of select="/H2G2/TWITTERCREATEPROFILE/@SITENAME" /></h2>
		</div>
		
		<div class="dna-main dna-main-bg dna-main-pad blq-clearfix">
			<div class="dna-box">
				<h3>Update/Create Twitter Profile</h3>
				<div class="dna-fr">
				  <span>* denotes required field</span>
				</div>
				<form method="get" action="twittercreateprofile" class="twitterprofile"> 
					<input type="hidden" name="type"><xsl:value-of select="/H2G2/TWITTERCREATEPROFILE/@SITENAME" /></input>
					<fieldset>
						<ul class="twitter-profile">
							<li>
								<label for="profileid">Profile Id <span>*</span>:</label>
								<input type="text" name="profileid" id="profileid" />
							</li>
							<li>
								<label for="title">Title <span>*</span>:</label>
								<input type="text" name="title" id="title" />
							</li>
							<li>
								<label for="users">Users: <br /><em>You must enter at least one user or search term</em></label>
								<textarea name="users" id="users"><xsl:text> </xsl:text></textarea>
							</li>
							<li>
								<label for="searchterms">Search Terms:<br /><em>You must enter at least one user or search term</em></label>
								<textarea name="searchterms" id="searchterms"><xsl:text> </xsl:text></textarea>
							</li>
							<li class="states blq-clearfix">
								<label for="active">Active:</label>
								<input type="checkbox" name="active" id="active" value="true">
									<xsl:if test="ACTIVEONLY = TRUE">
										<xsl:attribute name="checked">checked</xsl:attribute>
									</xsl:if>
								</input>
							
								<label for="trustedusers">Trusted Users:</label>
								<input type="checkbox" name="trustedusers" id="trustedusers" value="true">
									<xsl:if test="trustedusers = TRUE">
										<xsl:attribute name="checked">checked</xsl:attribute>
									</xsl:if>
								</input>
							
								<label for="countsonly">Counts Only:</label>
								<input type="checkbox" name="countsonly" id="countsonly" value="true">
									<xsl:if test="countsonly = TRUE">
										<xsl:attribute name="checked">checked</xsl:attribute>
									</xsl:if>
								</input>
							
								<label for="keywordcounts">Keyword Counts:</label>
								<input type="checkbox" name="keywordcounts" id="keywordcounts" value="true">
									<xsl:if test="ACTIVEONLY = TRUE">
										<xsl:attribute name="checked">checked</xsl:attribute>
									</xsl:if>
								</input>
    							
								<label for="moderated">Moderated:</label>
								<input type="checkbox" name="moderated" id="moderated" value="true">
									<xsl:if test="ACTIVEONLY = TRUE">
										<xsl:attribute name="checked">checked</xsl:attribute>
									</xsl:if>
								</input>				
							</li>
						</ul>
						<ul class="dna-buttons profile">
							<li><input type="submit" value="Create Profile" /></li>
							<li><a href="twitterprofilelist" class="button">Cancel</a></li>
						</ul>					
					</fieldset>
				</form>
			</div>	
		</div>    
	</div>
  </xsl:template>
	
</xsl:stylesheet>
