<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">


    <doc:documentation>
        <doc:purpose>
            Page layout for a commentbox page (as used in the acs feature)
        </doc:purpose>
        <doc:context>
            Applied by the kick off file  (e.g. /html.xsl, /rss.xsl etc)
        </doc:context>
        <doc:notes>
            This particluar page also packages various lists in ssi vars, for use
            during output.
        </doc:notes>
    </doc:documentation>
	
	<xsl:template match="/H2G2[@TYPE = 'COMMENTBOX'][/H2G2/PARAMS/PARAM[NAME = 's_mode']/VALUE = 'login']" mode="page" priority="1.0"> 
		<p>
			<a href="{COMMENTBOX/FORUMTHREADPOSTS/@HOSTPAGEURL}" class="id-cta">
				<xsl:call-template name="library_memberservice_require">
					<xsl:with-param name="ptrt">
						<xsl:value-of select="COMMENTBOX/FORUMTHREADPOSTS/@HOSTPAGEURL"/>
					</xsl:with-param>
				</xsl:call-template>
				<xsl:text>Click here to login, or complete the registration process.</xsl:text>
			</a>
		</p>
	</xsl:template>
    
    <xsl:template match="/H2G2[@TYPE = 'COMMENTBOX']" mode="page" priority="0.75">
        
       
            <xsl:variable name="recentComments">
                <xsl:apply-templates select="RECENTCOMMENTS" mode="object_recentcomments"/>  
            </xsl:variable>
        
            <xsl:variable name="beingDiscussedNow">
                <xsl:apply-templates select="COMMENTFORUMLIST" mode="object_commentforumlist" />
            </xsl:variable>
    	
    	<xsl:variable name="ptrt" select="COMMENTBOX/FORUMTHREADPOSTS/@HOSTPAGEURL"/>
    	     
        <div id="comments" class="comments">
            <h3>  
                <xsl:choose>
                    <xsl:when test="/H2G2/SITECONFIG/DNACOMMENTTEXT/COMMENTBOXTITLE">
                        <xsl:value-of select="/H2G2/SITECONFIG/DNACOMMENTTEXT/COMMENTBOXTITLE"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>Comments</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
                    
                  <xsl:if test="/H2G2/COMMENTBOX/FORUMTHREADPOSTS/@CANWRITE = 1 or /H2G2/SITE/SITECLOSED = 0">
                    <xsl:call-template name="library_userstate">
                          <xsl:with-param name="loggedin">
                              <a accesskey="8" title="Skip to post a comment form" href="#postcomment">Post your comment</a>
                          </xsl:with-param>
                          <xsl:with-param name="loggedout">
                          	<!-- removed as it doesn't fit wih Identity guidelines -->
                          	<!--<a href="{$ptrt}" class="id-cta">
                          		<xsl:call-template name="library_memberservice_require">
                          		<xsl:with-param name="ptrt" select="$ptrt"/>
                          		</xsl:call-template>
                          		<xsl:text>Sign in</xsl:text>
                          		</a>-->
                          </xsl:with-param>
                      </xsl:call-template>
                  </xsl:if>
            </h3>

            <xsl:call-template name="library_ssi_escaped">
                <xsl:with-param name="statement">
                    <xsl:text>#set var="dna.commentbox.recentComments" value='</xsl:text>
                    <xsl:copy-of select="$recentComments"/>
                    <xsl:text>'</xsl:text>
                </xsl:with-param>
            </xsl:call-template>
            
            <xsl:call-template name="library_ssi_escaped">
                <xsl:with-param name="statement">
                    <xsl:text>#set var="dna.commentbox.beingDiscussedNow" value='</xsl:text>
                    <xsl:copy-of select="$beingDiscussedNow"/>
                    <xsl:text>'</xsl:text>
                </xsl:with-param>
            </xsl:call-template>
            
            <xsl:call-template name="library_ssi_escaped">
                <xsl:with-param name="statement">
                    <xsl:text>#set var="dna.commentbox.commentCount" value='</xsl:text>
                    <xsl:value-of select="FORUMTHREADPOSTS/@FORUMPOSTCOUNT"/>
                    <xsl:text>'</xsl:text>
                </xsl:with-param>
            </xsl:call-template>
            
            <!-- Output the sign in or sign out text-->
            <xsl:if test="/H2G2/COMMENTBOX/FORUMTHREADPOSTS/@CANWRITE = 1 or /H2G2/SITE/SITECLOSED = 0">
              <p class="dna-commentbox-userstate">
                  <xsl:call-template name="library_userstate">
                      <xsl:with-param name="loggedin">
                          <xsl:apply-templates select="/H2G2/SITECONFIG/DNACOMMENTTEXT/LOGGEDINWELCOME" mode="library_siteconfig_loggedinwelcome" />
                      </xsl:with-param>
                      <xsl:with-param name="unauthorised">
                        <xsl:apply-templates select="/H2G2/SITECONFIG/DNACOMMENTTEXT/NOTLOGGEDINWELCOME" mode="library_siteconfig_unauthorisedwelcome" >
                        	<xsl:with-param name="ptrt" select="$ptrt"/>
                        </xsl:apply-templates>
                      </xsl:with-param>
                      <xsl:with-param name="loggedout">
                          <xsl:apply-templates select="/H2G2/SITECONFIG/DNACOMMENTTEXT/NOTLOGGEDINWELCOME" mode="library_siteconfig_notloggedinwelcome_comments" >
                          	<xsl:with-param name="ptrt" select="$ptrt"/>
                          </xsl:apply-templates>
                      </xsl:with-param>
                  </xsl:call-template>
              </p>
            </xsl:if>
            
                        
            <!-- Add the comments-->
            <xsl:apply-templates select="COMMENTBOX/FORUMTHREADPOSTS" mode="object_forumthreadposts" />
          
            <!-- If the user is logged in, show the Add Comment form -->
            <xsl:call-template name="library_userstate">
                <xsl:with-param name="loggedin">
                    <xsl:apply-templates select="COMMENTBOX/FORUMTHREADPOSTS" mode="input_commentbox"/>
                </xsl:with-param>
            </xsl:call-template>

        </div>
        
        <script type="text/javascript">
            <xsl:text>
            <![CDATA[if (window.dna) {
                if (window.glow) {
                    dna.comments.apply(]]></xsl:text>
            <xsl:call-template name="library_json">
                <xsl:with-param name="data">
                    <targetForm>div.comments form</targetForm>
                    <timeBetweenComments>
                        <xsl:apply-templates select="/H2G2/SITE" mode="library_siteoptions_get">
                            <xsl:with-param name="name" select="'PostFreq'"/>
                        </xsl:apply-templates>
                    </timeBetweenComments>
                    <viewingUser><xsl:value-of select="/H2G2/VIEWING-USER/USER/USERNAME"/></viewingUser>
                    <viewingUserGroup><xsl:apply-templates select="/H2G2/VIEWING-USER/USER" mode="library_user_notables" /></viewingUserGroup>
                </xsl:with-param>
            </xsl:call-template>
            <xsl:text><![CDATA[);
                } else {
                    dna.comments.queue(]]></xsl:text>
            <xsl:call-template name="library_json">
                <xsl:with-param name="data">
                    <targetForm>div.comments form</targetForm>
                    <timeBetweenComments>
                        <xsl:apply-templates select="/H2G2/SITE" mode="library_siteoptions_get">
                            <xsl:with-param name="name" select="'PostFreq'"/>
                        </xsl:apply-templates>
                    </timeBetweenComments>
                    <viewingUser><xsl:value-of select="/H2G2/VIEWING-USER/USER/USERNAME"/></viewingUser>
                    <viewingUserGroup><xsl:apply-templates select="/H2G2/VIEWING-USER/USER" mode="library_user_notables" /></viewingUserGroup>
                </xsl:with-param>
            </xsl:call-template>
            <xsl:text><![CDATA[);
                }
            }]]>
            </xsl:text>
        </script>
    </xsl:template>
    
</xsl:stylesheet>