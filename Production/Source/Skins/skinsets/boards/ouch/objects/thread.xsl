<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">
    
    <doc:documentation>
        <doc:purpose>
            Defines HTML for the Thread object.
        </doc:purpose>
        <doc:context>
            Currently applied by objects/forumthreads.xsl
        </doc:context>
        <doc:notes>
            
        </doc:notes>
    </doc:documentation>
    
    
	<xsl:template match="THREAD" mode="object_thread">
		<xsl:variable name="threadId" select="@THREADID"/>
		<li>
			<xsl:call-template name="library_listitem_stripe"/>
			
			<p>
				<a href="F{@FORUMID}?thread={@THREADID}">
					<xsl:choose>
						<xsl:when test="SUBJECT/text()">
							<xsl:value-of select="SUBJECT"/> 
						</xsl:when>
						<xsl:otherwise>
							<xsl:attribute name="class">
								<xsl:text>nosubject</xsl:text>
							</xsl:attribute>
							<xsl:text>no subject</xsl:text>
						</xsl:otherwise>
					</xsl:choose>
				</a>
			</p>
			<div class="itemdetail">
			<p class="begun">
				<span class="dna-invisible">Discussion started by</span> 
				<span class="vcard">
					<span class="fn">
						<xsl:apply-templates select="FIRSTPOST/USER" mode="object_user_linked" />
					</span>
				</span>
				<span class="startedon">
					<span class="dna-invisible">on</span>
					<xsl:apply-templates select="FIRSTPOST/DATE | FIRSTUSERPOST/DATEPOSTED/DATE" mode="library_date_shortformat"/>
				</span>
				<span class="dna-invisible">. </span>
			</p>
			<p class="latest">
			
				<span class="replies">
					<xsl:choose>
						<xsl:when test="(TOTALPOSTS - 1) = 0">
							<span class="dna-invisible">There have been </span>
							<span class="noreplies">
								<xsl:text>no replies</xsl:text>
							</span>
						</xsl:when>
						<xsl:when test="(TOTALPOSTS - 1) = 1">
							<xsl:value-of select="TOTALPOSTS - 1" />
							<xsl:text> reply</xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="TOTALPOSTS - 1" />
							<xsl:text> replies</xsl:text>
						</xsl:otherwise>
					</xsl:choose>
					<span class="dna-invisible">.</span>
				</span>
				<span class="updatedon">
						<span class="dna-invisible">Updated </span>
						<a href="F{@FORUMID}?thread={@THREADID}&amp;latest=1#p{LASTPOST/@POSTID}">
							<xsl:value-of select="DATEPOSTED/DATE/@RELATIVE"/>
						</a>
						<span class="dna-invisible"> by </span>
						<span class="vcard">
							<span class="fn">
								<xsl:apply-templates select="LASTPOST/USER" mode="object_user_linked" />
							</span>
						</span>
						
				</span>
			</p>
				<xsl:call-template name="library_userstate_editor">
					<xsl:with-param name="loggedin">
						<div>
							<p class="dna-boards-moderation">
								<xsl:apply-templates select="/H2G2/FORUMTHREADS/THREAD[@THREADID = $threadId][@CANWRITE = 1]" mode="moderation_cta_closethread">
									<xsl:with-param name="label" select="'Close discussion'" />
								</xsl:apply-templates>
								<xsl:apply-templates select="/H2G2/FORUMTHREADS/THREAD[@THREADID = $threadId][@CANWRITE = 0]" mode="moderation_cta_closethread">
									<xsl:with-param name="label" select="'Open discussion'" />
								</xsl:apply-templates>
								<xsl:apply-templates select="/H2G2/FORUMTHREADS/THREAD[@THREADID = $threadId]" mode="moderation_cta_movethread">
									<xsl:with-param name="label" select="'Move discussion'" />
								</xsl:apply-templates>
							</p>
						</div>
					</xsl:with-param>
				</xsl:call-template>
			</div>
		</li>
	</xsl:template>
	
	<!-- For the MP page -->
	<xsl:template match="POST/THREAD" mode="object_thread">
		<xsl:variable name="siteId" select="parent::POST/SITEID"/>
		<li>
			<xsl:call-template name="library_listitem_stripe"/>
			
			<p class="threadtitle">
				<a href="{concat($host, '/dna/', /H2G2/SITE-LIST/SITE[@ID = $siteId]/NAME, '/F', @FORUMID, '?thread=', @THREADID)}">
					<xsl:choose>
						<xsl:when test="SUBJECT/text()">
							<xsl:value-of select="SUBJECT"/> 
						</xsl:when>
						<xsl:otherwise>
							<xsl:attribute name="class">
								<xsl:text>nosubject</xsl:text>
							</xsl:attribute>
							<xsl:text>no subject</xsl:text>
						</xsl:otherwise>
					</xsl:choose>
				</a>
			</p>
			<p class="thread-additionalinfo">
				<xsl:text>from </xsl:text>
				<a href="{concat($host, '/dna/', /H2G2/SITE-LIST/SITE[@ID = $siteId]/NAME, '/F', @FORUMID)}">
					<xsl:value-of select="FORUMTITLE"/>
				</a>
				<xsl:text> in </xsl:text>
				<xsl:apply-templates select="parent::POST/SITEID" mode="library_site_link"/>
			</p>
			
			<div class="itemdetail">
				<span class="replydate">
					<xsl:text>Last contribution: </xsl:text>
					<xsl:apply-templates select="REPLYDATE/DATE" mode="library_date_shortformat"/>
					<xsl:text> at </xsl:text>
					<xsl:apply-templates select="REPLYDATE/DATE" mode="library_time_shortformat"/>
					(<xsl:value-of select="REPLYDATE/DATE/@RELATIVE"/>)
				</span>
				
				<p class="postdetails">
					<xsl:if test="ancestor::POST-LIST/USER/USERID = /H2G2/VIEWING-USER/USER/USERID">
						<span class="newposts">
							<xsl:text>New posts: </xsl:text><xsl:value-of select="number(parent::POST/@COUNTPOSTS) - number(parent::POST/@LASTPOSTCOUNTREAD)"/>
						</span>
					</xsl:if>
					<span class="totalposts">
						<xsl:text>Total number of posts: </xsl:text><xsl:value-of select="parent::POST/@COUNTPOSTS"/>
					</span>
					<span class="latestpost">
						<xsl:text>Latest post: </xsl:text>
						<a href="{concat($host, '/dna/', /H2G2/SITE-LIST/SITE[@ID = $siteId]/NAME, '/F', @FORUMID, '?thread=', @THREADID, '&amp;latest=1#p', LASTUSERPOST/@POSTID)}">
							<xsl:apply-templates select="REPLYDATE/DATE" mode="library_date_shortformat"/>
						</a>
					</span>
				</p>
			</div>                
		</li>
	</xsl:template>
</xsl:stylesheet>