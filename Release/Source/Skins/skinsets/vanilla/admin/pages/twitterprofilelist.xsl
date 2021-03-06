<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation" xmlns="http://www.w3.org/1999/xhtml"
	exclude-result-prefixes="doc">

	<doc:documentation>
		<doc:purpose>

		</doc:purpose>
		<doc:context>

		</doc:context>
		<doc:notes>

		</doc:notes>
	</doc:documentation>

	<xsl:template match="H2G2[@TYPE = 'TWITTERPROFILELIST']"
		mode="page">
		<xsl:call-template name="objects_links_breadcrumb">
			<xsl:with-param name="pagename">
				Twitter Profile List
			</xsl:with-param>
		</xsl:call-template>

		<div class="twitter-admin">
			<div class="dna-mb-intro blq-clearfix">

				<xsl:choose>
					<xsl:when test="/H2G2/TWITTER-SITE-LIST/@COUNT != 0">
						<form method="get" action="twitterprofilelist" class="blq-clearfix dna-fl"
							style="width:45%">
							<fieldset>
								<label for="sites">Site:</label>
								<select name="sitename" id="sites">
									<xsl:for-each select="/H2G2/TWITTER-SITE-LIST/SITE">
										<xsl:sort select="NAME" />
										<option value="{NAME}">
											<xsl:if test="NAME=/H2G2/PROCESSINGSITE/SITE/NAME">
												<xsl:attribute name="selected">selected</xsl:attribute>
											</xsl:if>
											<xsl:value-of select="NAME" />
										</option>
									</xsl:for-each>
									<!-- <xsl:apply-templates select="/H2G2/TWITTER-SITE-LIST" -->
									<!-- mode="objects_sites_twittersites" /> -->
								</select>
								<div class="dna-buttons">
									<input type="submit" value="Change site" class="change-site" />
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
						<input type="hidden" name="s_activeonly" class="activeonly">
							<xsl:attribute name="value">
			    				  <xsl:choose>
			    					  <xsl:when
								test="/H2G2/PARAMS/PARAM[/H2G2/PARAMS/PARAM/NAME = 's_activeonly']/VALUE = 'on'">off</xsl:when>
			    					  <xsl:otherwise>on</xsl:otherwise>
			    				  </xsl:choose>
			    			  </xsl:attribute>
						</input>

						<label for="activeonly">
							<xsl:choose>
								<xsl:when
									test="/H2G2/PARAMS/PARAM[/H2G2/PARAMS/PARAM/NAME = 's_activeonly']/VALUE = 'on' or /H2G2/PARAMS/PARAM[/H2G2/PARAMS/PARAM/NAME = 's_activeonly']/VALUE = ''">
									Show all profiles:
								</xsl:when>
								<xsl:otherwise>
									Show active profiles only:
								</xsl:otherwise>
							</xsl:choose>
						</label>

						<input type="hidden" name="sitename" class="sitename">
							<xsl:attribute name="value">
                    <xsl:value-of select="/H2G2/PROCESSINGSITE/SITE/NAME" />
                  </xsl:attribute>
						</input>

						<div class="dna-buttons">
							<input type="submit">
								<xsl:attribute name="value">
									  <xsl:choose>
										  <xsl:when
									test="/H2G2/PARAMS/PARAM[/H2G2/PARAMS/PARAM/NAME = 's_activeonly']/VALUE = 'on' or /H2G2/PARAMS/PARAM[/H2G2/PARAMS/PARAM/NAME = 's_activeonly']/VALUE = ''">
											  <xsl:text>Show all</xsl:text>
										  </xsl:when>
										  <xsl:otherwise><xsl:text>Show active only</xsl:text></xsl:otherwise>
									  </xsl:choose>								
								  </xsl:attribute>
								<xsl:attribute name="class">
									  <xsl:choose>
										  <xsl:when
									test="/H2G2/PARAMS/PARAM[/H2G2/PARAMS/PARAM/NAME = 's_activeonly']/VALUE = 'on' or /H2G2/PARAMS/PARAM[/H2G2/PARAMS/PARAM/NAME = 's_activeonly']/VALUE = ''">
											  <xsl:text>show-all-profiles</xsl:text>
										  </xsl:when>
										  <xsl:otherwise><xsl:text>show-active-only-profiles</xsl:text></xsl:otherwise>
									  </xsl:choose>								
								  </xsl:attribute>
							</input>
						</div>
					</fieldset>
				</form>

			</div>

			<div class="dna-main dna-main-bg dna-main-pad blq-clearfix">
				<div class="dna-box">
					<h3 class="profile-count">
						Number of profiles: <!--for <strong><xsl:value-of select="/H2G2/TWITTERPROFILELIST/TWITTERPROFILE/@SITETYPE" 
							/></strong>: -->
						<xsl:value-of select="/H2G2/TWITTERPROFILELIST/@COUNT" />
					</h3>

					<xsl:call-template name="newprofilelink" />

					<table class="twitter-profile-list">
						<thead>
							<tr>
								<th class="profileid">Profile Id</th>
								<th>Active</th>
								<!--<th>Trusted Users</th> -->
								<th>Counts Only</th>
								<th>Keyword Counts</th>
								<!--<th>Moderated Tweets</th> -->
								<th></th>
							</tr>
						</thead>
						<tbody>
							<xsl:choose>
								<xsl:when test="/H2G2/TWITTERPROFILELIST/@COUNT = 0">
									<tr>
										<td colspan="5" class="no-twitter-profiles">There are no Twitter profiles for
											this site
										</td>
									</tr>
								</xsl:when>
								<xsl:otherwise>
									<xsl:apply-templates select="/H2G2/TWITTERPROFILELIST/TWITTERPROFILE" />
								</xsl:otherwise>
							</xsl:choose>
						</tbody>
					</table>

					<xsl:call-template name="newprofilelink" />

				</div>
			</div>

		</div>
	</xsl:template>

	<xsl:template name="newprofilelink">
		<xsl:variable name="sitetype">
			<xsl:choose>
				<xsl:when test="/H2G2/PROCESSINGSITE/SITE/NAME = 'All'">
					All
				</xsl:when>
				<xsl:when test="/H2G2/PROCESSINGSITE/SITE/NAME != ''">
					<xsl:value-of select="/H2G2/PROCESSINGSITE/SITE/NAME" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="/H2G2/TWITTER-SITE-LIST/SITE/NAME" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<div class="blq-clearfix dna-fr">
			<ul class="dna-buttons">
				<li>
					<xsl:choose>
						<xsl:when test="$sitetype = 'All'">
							Please select a specific site to create a new profile
						</xsl:when>
						<xsl:otherwise>
							<a
								href="twitterprofile?s_sitename={$sitetype}&amp;sitename={$sitetype}"
								class="create-new-profile">New Profile</a>
						</xsl:otherwise>
					</xsl:choose>
				</li>
			</ul>
		</div>
	</xsl:template>

	<xsl:template match="TWITTERPROFILE">
		<xsl:variable name="sitetype" select="@SITETYPE" />
		<xsl:variable name="profileid" select="PROFILEID" />

		<tr>
			<td class="profileid">
				<xsl:value-of select="PROFILEID" />
			</td>
			<td>
				<xsl:value-of select="ACTIVESTATUS" />
			</td>
			<!--<td><xsl:value-of select="TRUSTEDUSERSTATUS" /></td> -->
			<td>
				<xsl:value-of select="PROFILECOUNTSTATUS" />
			</td>
			<td>
				<xsl:value-of select="PROFILEKEYWORDCOUNTSTATUS" />
			</td>
			<!--<td><xsl:value-of select="MODERATIONSTATUS" /></td> -->
			<td>
				<a
					href="twitterprofile?s_sitename={$sitetype}&amp;sitename={$sitetype}&amp;profileId={$profileid}&amp;action=getprofile&amp;s_action=getprofile"
					class="edit-profile">Edit</a>
			</td>
		</tr>
	</xsl:template>

</xsl:stylesheet>
