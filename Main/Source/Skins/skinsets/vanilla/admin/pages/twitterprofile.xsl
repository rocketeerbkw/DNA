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
				<form method="get" action="twittercreateprofile"> 
					<fieldset>
						<ul class="twitter-profile">
							<li>
							<label for="profileid">Profile Id</label>
							<input type="text" name="profileid" id="profileid" />
							</li>
							<li>
							<label for="title">Title</label>
							<input type="text" name="title" id="title" />
							</li>
							<li>
							<label for="users">Users</label>
							<textarea name="users" id="users"><xsl:text> </xsl:text></textarea>
							</li>
							<li>
							<label for="searchterms">Search Terms</label>
							<textarea name="searchterms" id="searchterms"><xsl:text> </xsl:text></textarea>
							</li>
							<li>
							<label for="active">Active:</label>
							<input type="checkbox" name="active" id="active">
								<xsl:if test="ACTIVEONLY = TRUE">
									<xsl:attribute name="checked">checked</xsl:attribute>
								</xsl:if>
							</input>
							
							<label for="trustedusers">Truster Users:</label>
							<input type="checkbox" name="trustedusers" id="trustedusers">
								<xsl:if test="trustedusers = TRUE">
									<xsl:attribute name="checked">checked</xsl:attribute>
								</xsl:if>
							</input>
							
							<label for="countsonly">Counts Only:</label>
							<input type="checkbox" name="countsonly" id="countsonly">
								<xsl:if test="countsonly = TRUE">
									<xsl:attribute name="checked">checked</xsl:attribute>
								</xsl:if>
							</input>
							
							<label for="keywordcounts">Keyword Counts:</label>
							<input type="checkbox" name="keywordcounts" id="keywordcounts">
								<xsl:if test="ACTIVEONLY = TRUE">
									<xsl:attribute name="checked">checked</xsl:attribute>
								</xsl:if>
							</input>
							
							<label for="moderated">Moderated:</label>
							<input type="checkbox" name="moderated" id="moderated">
								<xsl:if test="ACTIVEONLY = TRUE">
									<xsl:attribute name="checked">checked</xsl:attribute>
								</xsl:if>
							</input>				
							</li>
						</ul>
						<ul class="dna-buttons">
							<li><a href="twitterprofilelist" class="button">Cancel</a></li>
							<li><input type="submit" value="Create Profile" /></li>
						</ul>					
					</fieldset>
				</form>
			</div>	
		</div>    
	</div>
  </xsl:template>
	
</xsl:stylesheet>
