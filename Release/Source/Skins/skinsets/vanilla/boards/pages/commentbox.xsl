<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">


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
    
    <xsl:template match="/H2G2[@TYPE = 'COMMENTBOX']" mode="page">
        
       
            <xsl:variable name="recentComments">
                <xsl:apply-templates select="RECENTCOMMENTS" mode="object_recentcomments"/>  
            </xsl:variable>
        
            <xsl:variable name="beingDiscussedNow">
                <xsl:apply-templates select="COMMENTFORUMLIST" mode="object_commentforumlist" />
            </xsl:variable>
        
                
        <div id="comments" class="comments">
            <xsl:call-template name="library_header_h3">
                <xsl:with-param name="text">
                    <xsl:text>Comments</xsl:text>
                    <xsl:call-template name="library_userstate">
                        <xsl:with-param name="loggedin">
                            <a accesskey="8" title="Skip to post a comment form" href="#postcomment">Post your comment</a>
                        </xsl:with-param>
                        <xsl:with-param name="loggedout">
                            <a>
                                <xsl:attribute name="href">
                                    <xsl:apply-templates select="/H2G2/SITE/SSOSERVICE" mode="library_sso_loginurl" />
                                </xsl:attribute>
                                <xsl:text>Sign in</xsl:text>
                            </a>
                        </xsl:with-param>
                    </xsl:call-template>
                </xsl:with-param>
            </xsl:call-template>
            
          <!--
            <xsl:comment>#set var="statement.start" value="&lt;!-"</xsl:comment>
            <xsl:comment>#set var="statement.end" value="-&gt;"</xsl:comment>
            <xsl:comment>#set var="statement.hyphen" value="-"</xsl:comment>
            
            <xsl:call-template name="ssi_statement">
                <xsl:with-param name="statement">
                    <xsl:text>#set var="dna.commentbox.recentComments" value='</xsl:text>
            <xsl:copy-of select="$recentComments"/>
                    <xsl:text>'</xsl:text>
                </xsl:with-param>
            </xsl:call-template>
            -->
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
            <p class="dna-commentbox-userstate">
                <xsl:call-template name="library_userstate">
                    <xsl:with-param name="loggedin">
                        <xsl:apply-templates select="/H2G2/SITECONFIG/DNACOMMENTTEXT/LOGGEDINWELCOME" mode="library_siteconfig_loggedinwelcome" />
                    </xsl:with-param>
                    <xsl:with-param name="loggedout">
                        <xsl:apply-templates select="/H2G2/SITECONFIG/DNACOMMENTTEXT/NOTLOGGEDINWELCOME" mode="library_siteconfig_notloggedinwelcome" />
                    </xsl:with-param>
                </xsl:call-template>
            </p>
            
                        
            <!-- Add the comments-->
            <xsl:apply-templates select="COMMENTBOX/FORUMTHREADPOSTS" mode="object_forumthreadposts" />
            
            <!-- ssi var of the rss link -->
            <!-- 
            <xsl:call-template name="library_ssi_var">
                <xsl:with-param name="name" select="'dna.commentbox.feed'" />
                <xsl:with-param name="value">
                    <xsl:text>/dnassi/pmblog/vanilla-xml/acs/?dnahostpageurl=</xsl:text>
                    <xsl:value-of select="COMMENTBOX/FORUMTHREADPOSTS/@HOSTPAGEURL"/>
                    <xsl:text>&amp;dnauid=</xsl:text>
                    <xsl:value-of select="COMMENTBOX/FORUMTHREADPOSTS/@UID"/>
                </xsl:with-param>
            </xsl:call-template>
            -->
          
            
            <!-- If the user is logged in, show the Add Comment form -->
            <xsl:call-template name="library_userstate">
                <xsl:with-param name="loggedin">
                    <xsl:apply-templates select="COMMENTBOX/FORUMTHREADPOSTS" mode="input_commentbox"/>
                </xsl:with-param>
            </xsl:call-template>
            
            <!-- 
            <xsl:call-template name="library_ssi">
                <xsl:with-param name="statement">
                    <xsl:text>echo encoding="none" var="dna.commentbox.recentComments"</xsl:text>
                </xsl:with-param>
            </xsl:call-template>
             -->
        </div>
        
        <script type="text/javascript">
            <![CDATA[
                var dna = dna || false;
                
                if (dna) {
                    dna.comments.apply(
            ]]>
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
            <![CDATA[
                );}
            ]]>
        </script>
    </xsl:template>
    
</xsl:stylesheet>