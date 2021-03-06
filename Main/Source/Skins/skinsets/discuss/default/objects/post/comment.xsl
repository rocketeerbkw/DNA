<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">
    
    <doc:documentation for="/sites/MySite/objects/post/generic.xsl">
        <doc:purpose>
            Holds the generic HTML construction of a comment
        </doc:purpose>
        <doc:context>
            
        </doc:context>
        <doc:notes>
            This is quite a chunky file, basically a comment could have one of several different 
            states and renderings 
        </doc:notes>
    </doc:documentation>
    
    
    <!-- Hidden post for the owner -->
    <xsl:template match="POST[@HIDDEN = 3 and ./USER/USERID = /H2G2/VIEWING-USER/USER/USERID]" mode="object_post_comment">
        <li id="comment{(@INDEX + 1)}">
            <!-- Add the stripe class -->
            <xsl:call-template name="library_listitem_stripe">
                <xsl:with-param name="additional-classnames">
                    <xsl:apply-templates select="USER" mode="library_user_notables"/>
                </xsl:with-param>
            </xsl:call-template>
            
            <span class="comment-number">
                <xsl:value-of select="@INDEX + 1"/>
                <xsl:text>. </xsl:text>
            </span>
            <cite>
                <xsl:text>At </xsl:text>
                <a class="time" href="{parent::FORUMTHREADPOSTS/@HOSTPAGEURL}#comment{@INDEX + 1}">
                    <xsl:apply-templates select="DATEPOSTED" mode="library_time_shortformat" />
                </a>
                <xsl:text> on </xsl:text>
                <span class="date">
                    <xsl:apply-templates select="DATEPOSTED" mode="library_date_shortformat" />
                </span>
                <xsl:text>, </xsl:text>
                <span class="vcard">
                    <span class="fn">
                        <xsl:apply-templates select="USER" mode="library_user_morecomments" >
                            <xsl:with-param name="url" select="/H2G2/PARAMS/PARAM[NAME = 's_commentprofileurl']/VALUE"/>
                        </xsl:apply-templates>
                    </span>
                </span>
                <xsl:text> (awaiting moderation)</xsl:text>
            </cite>
            
            <p class="comment-text-moderation">
                <xsl:apply-templates select="/H2G2/SITECONFIG/DNACOMMENTTEXT/PREMODMESSAGE" mode="library_siteconfig_premodmessage" />
            </p>
        </li>
    </xsl:template>
    
    <!-- Hidden post for any user -->
    <xsl:template match="POST[@HIDDEN = 3 and USER/USERID != /H2G2/VIEWING-USER/USER/USERID or @HIDDEN = 3]" mode="object_post_comment">
        <li id="comment{(@INDEX + 1)}">
            <!-- Add the stripe class -->
            <xsl:call-template name="library_listitem_stripe">
                <xsl:with-param name="additional-classnames">
                    <xsl:apply-templates select="USER" mode="library_user_notables"/>
                </xsl:with-param>
            </xsl:call-template>
            
            <span class="comment-number">
                <xsl:value-of select="@INDEX + 1"/>
                <xsl:text>. </xsl:text>
            </span>
            <cite>
                <xsl:text>At </xsl:text>
                <a class="time" href="{parent::FORUMTHREADPOSTS/@HOSTPAGEURL}#comment{@INDEX + 1}">
                    <xsl:apply-templates select="DATEPOSTED" mode="library_time_shortformat" />
                </a>
                <xsl:text> on </xsl:text>
                <span class="date">
                    <xsl:apply-templates select="DATEPOSTED" mode="library_date_shortformat" />
                </span>
                <xsl:text>, </xsl:text>
                <span class="vcard">
                    <span class="fn">
                        <xsl:apply-templates select="USER" mode="library_user_morecomments" >
                            <xsl:with-param name="url" select="/H2G2/PARAMS/PARAM[NAME = 's_commentprofileurl']/VALUE"/>
                        </xsl:apply-templates>
                    </span>
                </span>
            </cite>
            <p class="comment-text-moderation">
                This comment is awaiting moderation. <a href="http://www.bbc.co.uk/messageboards/newguide/popup_checking_messages.html" class="popup">Explain</a>.
            </p>
        </li>
    </xsl:template>
    
    
     
    <!-- Removed post for the owner -->
    <xsl:template match="POST[@HIDDEN = 1 and ./USER/USERID = /H2G2/VIEWING-USER/USER/USERID]" mode="object_post_comment">
        <li id="comment{(@INDEX + 1)}">
            <!-- Add the stripe class -->
            <xsl:call-template name="library_listitem_stripe">
                <xsl:with-param name="additional-classnames">
                    <xsl:apply-templates select="USER" mode="library_user_notables"/>
                </xsl:with-param>
            </xsl:call-template>
            
            <span class="comment-number">
                <xsl:value-of select="@INDEX + 1"/>
                <xsl:text>. </xsl:text>
            </span>
            <cite>
                <xsl:text>At </xsl:text>
                <a class="time" href="{parent::FORUMTHREADPOSTS/@HOSTPAGEURL}#comment{@INDEX + 1}">
                    <xsl:apply-templates select="DATEPOSTED" mode="library_time_shortformat" />
                </a>
                <xsl:text> on </xsl:text>
                <span class="date">
                    <xsl:apply-templates select="DATEPOSTED" mode="library_date_shortformat" />
                </span>
                <xsl:text>, </xsl:text>
                <span class="vcard">
                    <span class="fn">
                        <xsl:apply-templates select="USER" mode="library_user_morecomments" >
                            <xsl:with-param name="url" select="/H2G2/PARAMS/PARAM[NAME = 's_commentprofileurl']/VALUE"/>
                        </xsl:apply-templates>
                    </span>
                </span>
                <xsl:text></xsl:text>
            </cite>
            
            <p class="comment-text-moderation">
                Your comment has been removed and has been deemed to break the <a class="popup" href="{$houserulespopupurl}">House Rules</a>. 
            </p>
        </li>
    </xsl:template>
    
    <!-- Removed post for any user -->
    <xsl:template match="POST[@HIDDEN = 1 and USER/USERID != /H2G2/VIEWING-USER/USER/USERID or @HIDDEN = 1]" mode="object_post_comment">
        <li id="comment{(@INDEX + 1)}">
            <!-- Add the stripe class -->
            <xsl:call-template name="library_listitem_stripe">
                <xsl:with-param name="additional-classnames">
                    <xsl:apply-templates select="USER" mode="library_user_notables"/>
                </xsl:with-param>
            </xsl:call-template>
            
            <span class="comment-number">
                <xsl:value-of select="@INDEX + 1"/>
                <xsl:text>. </xsl:text>
            </span>
            <cite>
                <xsl:text>At </xsl:text>
                <a class="time" href="{parent::FORUMTHREADPOSTS/@HOSTPAGEURL}#comment{@INDEX + 1}">
                    <xsl:apply-templates select="DATEPOSTED" mode="library_time_shortformat" />
                </a>
                <xsl:text> on </xsl:text>
                <span class="date">
                    <xsl:apply-templates select="DATEPOSTED" mode="library_date_shortformat" />
                </span>
                <xsl:text>, </xsl:text>
                <span class="vcard">
                    <span class="fn">
                        <xsl:apply-templates select="USER" mode="library_user_morecomments" >
                            <xsl:with-param name="url" select="/H2G2/PARAMS/PARAM[NAME = 's_commentprofileurl']/VALUE"/>
                        </xsl:apply-templates>
                    </span>
                </span>
            </cite>
            <p class="comment-text-moderation">
                This comment was removed because the moderators found it broke the <a class="popup" href="{$houserulespopupurl}">House Rules</a>.
            </p>
        </li>
    </xsl:template>
    
    <!-- Referred comment for any user -->
    <xsl:template match="POST[@HIDDEN = 2]" mode="object_post_comment">
        <li id="comment{(@INDEX + 1)}">
            <!-- Add the stripe class -->
            <xsl:call-template name="library_listitem_stripe">
                <xsl:with-param name="additional-classnames">
                    <xsl:apply-templates select="USER" mode="library_user_notables"/>
                </xsl:with-param>
            </xsl:call-template>
            
            <span class="comment-number">
                <xsl:value-of select="@INDEX + 1"/>
                <xsl:text>. </xsl:text>
            </span>
            <cite>
                <xsl:text>At </xsl:text>
                <a class="time" href="{parent::FORUMTHREADPOSTS/@HOSTPAGEURL}#comment{@INDEX + 1}">
                    <xsl:apply-templates select="DATEPOSTED" mode="library_time_shortformat" />
                </a>
                <xsl:text> on </xsl:text>
                <span class="date">
                    <xsl:apply-templates select="DATEPOSTED" mode="library_date_shortformat" />
                </span>
                <xsl:text>, </xsl:text>
                <span class="vcard">
                    <span class="fn">
                        <xsl:apply-templates select="USER" mode="library_user_morecomments" >
                            <xsl:with-param name="url" select="/H2G2/PARAMS/PARAM[NAME = 's_commentprofileurl']/VALUE"/>
                        </xsl:apply-templates>
                    </span>
                </span>
            </cite>
            <p class="comment-text-moderation">
                This comment has been referred to the moderators. <a href="http://www.bbc.co.uk/messageboards/newguide/popup_checking_messages.html" class="popup">Explain</a>.
            </p>
        </li>
    </xsl:template>
    
    
    
    <xsl:template match="POST[@HIDDEN != 0 and @HIDDEN != 3 and @HIDDEN != 2 and @HIDDEN != 1]" mode="object_post_comment" />
    
    <xsl:template match="POST" mode="object_post_comment">
        
        <li id="comment{(@INDEX + 1)}">
            <!-- Add the stripe class -->
            <xsl:call-template name="library_listitem_stripe">
                <xsl:with-param name="additional-classnames">
                    <xsl:apply-templates select="USER" mode="library_user_notables"/>
                </xsl:with-param>
            </xsl:call-template>
            
            <span class="comment-number">
                <xsl:value-of select="@INDEX + 1"/>
                <xsl:text>. </xsl:text>
            </span>
            <cite>
                <xsl:text>At </xsl:text>
                <a class="time" href="{parent::FORUMTHREADPOSTS/@HOSTPAGEURL}#comment{@INDEX + 1}">
                    <xsl:apply-templates select="DATEPOSTED" mode="library_time_shortformat" />
                </a>
                <xsl:text> on </xsl:text>
                <span class="date">
                    <xsl:apply-templates select="DATEPOSTED" mode="library_date_shortformat" />
                </span>
                <xsl:text>, </xsl:text>
                <span class="vcard">
                    <span class="fn">
                        <xsl:apply-templates select="USER" mode="library_user_morecomments" >
                            <xsl:with-param name="url" select="/H2G2/PARAMS/PARAM[NAME = 's_commentprofileurl']/VALUE"/>
                        </xsl:apply-templates>
                    </span>
                </span>
                <xsl:text> wrote:</xsl:text>
            </cite>
            
            <p class="comment-text">
                <xsl:apply-templates select="TEXT" mode="library_Richtext" >
                    <xsl:with-param name="escapeapostrophe" select="false()"/>
                </xsl:apply-templates>
            </p>
            
            <p class="flag">
              <a class="popup" href="{$root}/comments/UserComplaintPage?PostID={@POSTID}&amp;s_start=1">Complain about this comment</a>
            </p>
        </li>
    </xsl:template>
</xsl:stylesheet>
