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

  <xsl:template match="H2G2[@TYPE = 'TWITTERPROFILE']" mode="page">
  
  	<xsl:variable name="profiletype">
		<xsl:choose>
			<xsl:when test="/H2G2/PROFILE">Update</xsl:when>
			<xsl:otherwise>Create</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
  
	<xsl:call-template name="objects_links_breadcrumb">
		<xsl:with-param name="pagename"> <xsl:value-of select="$profiletype" /> Twitter Profile</xsl:with-param>
	</xsl:call-template>
	
	<div class="twitter-admin">
		<div class="dna-mb-intro">
			<h2><xsl:value-of select="/H2G2/TWITTERPROFILE/@SITENAME" /></h2>
		</div>
		
		<div class="dna-main dna-main-bg dna-main-pad blq-clearfix">
			<div class="dna-box">
				<h3><xsl:value-of select="$profiletype" /> Twitter Profile</h3>
				<div class="dna-fr">
				  <span>* denotes required field</span>
				</div>
				<form method="get" action="twitterprofile" class="twitterprofile"> 
					<input type="hidden" name="type">
						<xsl:attribute name="value">
							<xsl:value-of select="/H2G2/TWITTERPROFILE/@SITENAME" />
						</xsl:attribute>
					</input>
					<fieldset>
						<ul class="twitter-profile">
							<li>
								<label for="profileid">Profile Id <span>*</span>:</label>
								<input type="text" name="profileid" id="profileid">
									<xsl:attribute name="value"><xsl:value-of select="/H2G2/PROFILE/PROFILEID" /></xsl:attribute> 
								</input>
							</li>
							<li>
								<label for="title">Title <span>*</span>:</label>
								<input type="text" name="title" id="title">
									<xsl:attribute name="value"><xsl:value-of select="/H2G2/PROFILE/PROFILEID" /></xsl:attribute> 
								</input>
							</li>
							<li>
								<label for="users">Users: <br /><em>You must enter at least one user or search term</em></label>
								<textarea name="users" id="users">
									<xsl:text> </xsl:text>
									<xsl:apply-templates select="/H2G2/PROFILE/USERS/ITEM" mode="items" />
								</textarea>
							</li>
							<li>
								<label for="searchterms">Search Terms:<br /><em>You must enter at least one user or search term</em></label>
								<textarea name="searchterms" id="searchterms">
									<xsl:text> </xsl:text>
									<xsl:apply-templates select="/H2G2/PROFILE/KEYWORDS/ITEM" mode="items" />
								</textarea>
							</li>
							<li class="states blq-clearfix">
								<label for="active">Active:</label>
								<input type="checkbox" name="active" id="active" value="true">
									<xsl:if test="/H2G2/PROFILE/ACTIVEONLY = 'true'">
										<xsl:attribute name="checked">checked</xsl:attribute>
									</xsl:if>
								</input>
							
								<label for="trustedusers">Trusted Users:</label>
								<input type="checkbox" name="trustedusers" id="trustedusers" value="true">
									<xsl:if test="/H2G2/PROFILE/TRUSTEDUSERSENABLED = 'true'">
										<xsl:attribute name="checked">checked</xsl:attribute>
									</xsl:if>
								</input>
							
								<label for="countsonly">Counts Only:</label>
								<input type="checkbox" name="countsonly" id="countsonly" value="true">
									<xsl:if test="/H2G2/PROFILE/PROFILECOUNTENABLED = 'true'">
										<xsl:attribute name="checked">checked</xsl:attribute>
									</xsl:if>
								</input>
							
								<label for="keywordcounts">Keyword Counts:</label>
								<input type="checkbox" name="keywordcounts" id="keywordcounts" value="true">
									<xsl:if test="/H2G2/PROFILE/PROFILEKEYWORDCOUNTENABLED = 'true'">
										<xsl:attribute name="checked">checked</xsl:attribute>
									</xsl:if>
								</input>
    							
								<label for="moderated">Moderated:</label>
								<input type="checkbox" name="moderated" id="moderated" value="true">
									<xsl:if test="/H2G2/PROFILE/MODERATIONENABLED = 'true'">
										<xsl:attribute name="checked">checked</xsl:attribute>
									</xsl:if>
								</input>				
							</li>
						</ul>
						<ul class="dna-buttons profile">
							<xsl:variable name="sitetype" select="/H2G2/TWITTERPROFILE/@SITENAME" />
							<xsl:if test="/H2G2/PROFILE">
								<input type="hidden" name="s_action" value="updateprofile" />
							</xsl:if>
							<input type="hidden" name="action" value="createupdateprofile" />
							<li><input type="submit" value="{$profiletype} Profile" /></li>
							<li><a href="twitterprofilelist?type={$sitetype}" class="button">Cancel</a></li>
						</ul>					
					</fieldset>
				</form>
			</div>	
		</div>    
	</div>
  </xsl:template>
  
  <xsl:template match="ITEM" mode="items">
	<xsl:value-of select="." />
	<xsl:if test="position() != last()"> 
		<xsl:text>, </xsl:text>
	</xsl:if> 
  </xsl:template>
	
</xsl:stylesheet>
