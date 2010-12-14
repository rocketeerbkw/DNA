<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">
    
	<xsl:template match="CONTRIBUTIONITEM" mode="objects_contributions_contribution">
		<tr>
	    	<xsl:if test="position() mod 2 = 1">
		    	<xsl:attribute name="class">odd</xsl:attribute>
	    	</xsl:if>		
			<td>
				<h4 class="blq-hide">Contribution number <xsl:value-of select="position() + ancestor::CONTRIBUTIONS/@STARTINDEX" /></h4>
				<xsl:apply-templates select="DATEPOST" mode="library_time_shortformat" />
				<span class="date">
					<xsl:apply-templates select="DATEPOST" mode="library_date_shortformat" />
				</span>
				<xsl:value-of select="DATEPOST/@RELATIVE"/>
			</td>
			<td>
				<a>
					<xsl:attribute name="href">
						<xsl:choose>
							<xsl:when test="SITETYPE = 'Blog'">
								<xsl:value-of select="concat(COMMENTFORUMURL, '?postid=', THREADENTRYID)"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="concat('/dna/', SITEURL, '/NF', FORUMID, '?thread=', THREADID, '&amp;post=', THREADENTRYID, '#p', THREADENTRYID)"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
					<xsl:value-of select="TITLE" disable-output-escaping="yes"/>
				</a><br/>			
				<a>
					<xsl:attribute name="href">
						<xsl:choose>
							<xsl:when test="COMMENTFORUMURL = ''">
								<xsl:value-of select="concat('/dna/', SITEURL, '/NF', FORUMID)"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="COMMENTFORUMURL" disable-output-escaping="yes"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
					<xsl:choose>
						<xsl:when test="SOURCETITLE = ''">
							<xsl:value-of select="TITLE"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="SOURCETITLE" disable-output-escaping="yes"/>
						</xsl:otherwise>
					</xsl:choose>
				</a><br/>
				in
				<!-- site -->
				<a>
					<xsl:attribute name="href">
						<xsl:choose>
							<xsl:when test="SITETYPE = 'Blog'">
								<xsl:value-of select="COMMENTFORUMURL"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="concat('/dna/', SITEURL)"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
					<xsl:value-of select="SITEDESCRIPTION" />
				</a>
			</td>
			<td>
				<xsl:apply-templates select="TEXT" mode="library_GuideML"/>
			</td>
			<td>
				<xsl:if test="/H2G2/CONTRIBUTIONS/@USERID != /H2G2/VIEWING-USER/USER/USERID">
					<xsl:choose>
						<xsl:when test="MODERATIONSTATUS=3">
							<p class="dna-boards-failedpost">Awaiting Moderation.</p>
						</xsl:when>
						<xsl:when test="MODERATIONSTATUS=8">
							<p class="dna-boards-failedpost">User Removed</p>
						</xsl:when>
						<xsl:when test="MODERATIONSTATUS = 2 or MODERATIONSTATUS = 6 or MODERATIONSTATUS=1">
							<!-- Referred post for any user -->
							<xsl:if test="MODERATIONSTATUS = 1">
								<p class="dna-boards-failedpost">Failed</p>
							</xsl:if>
							<p class="dna-boards-failedpost">
								<a href="/dna/moderation/ModerationHistory?PostID={THREADENTRYID}" target="_blank">Post Failed</a>
							</p>
						</xsl:when>
						<xsl:otherwise>
							<xsl:if test="MODERATIONSTATUS = 0">
								<p class="dna-boards-failedpost">Live</p>
							</xsl:if>						
							<a class="popup">
								<xsl:attribute name="href">
									<xsl:value-of select="concat('/dna/', SITEURL,'/comments/UserComplaintPage?PostID=' , THREADENTRYID, '&amp;s_start=1&amp;s_ptrt=')" />
									<xsl:call-template name="library_serialise_ptrt_in">
										<xsl:with-param name="string">
											<xsl:apply-templates select="/H2G2" mode="library_memberservice_ptrt" />
										</xsl:with-param>
									</xsl:call-template>
								</xsl:attribute>
								<xsl:text>Report message</xsl:text>
								<span class="blq-hide">
									<xsl:value-of select="count(preceding-sibling::*)" />
								</span>
							</a>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:if test="/H2G2/VIEWING-USER/USER/STATUS = 2">
						<p>
							<a class="popup" href="/dna/moderation/EditPost?PostId={THREADENTRYID}">Edit Post</a>
						</p>
					</xsl:if>
				</xsl:if>
			</td>
		</tr>
	</xsl:template>
</xsl:stylesheet>
