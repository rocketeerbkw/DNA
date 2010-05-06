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
    	<xsl:variable name="thisUserId" select="USER/USERID"/>
        <li id="P{@POSTID}">
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
                <a class="time" href="{parent::FORUMTHREADPOSTS/@HOSTPAGEURL}#P{POSTID}" name="comment{(@INDEX + 1)}">
                    <xsl:apply-templates select="DATEPOSTED" mode="library_time_shortformat" />
                </a>
                <xsl:text> on </xsl:text>
                <span class="date">
                    <xsl:apply-templates select="DATEPOSTED" mode="library_date_shortformat" />
                </span>
                <xsl:text>, </xsl:text>
                <span class="vcard">
                    <span class="fn">
                    	<a href="{/H2G2/PARAMS/PARAM[NAME = 's_commentprofileurl']/VALUE}?userid={USER/USERID}">
                    		<xsl:choose>
                    			<xsl:when test="/H2G2/VIEWING-USER/USER/USERID = $thisUserId">you</xsl:when>
                    			<xsl:otherwise><xsl:value-of select="USER/USERNAME"/></xsl:otherwise>
                    		</xsl:choose>
                    	</a>
                    </span>
                </span>
                <xsl:text>wrote (awaiting moderation)</xsl:text>
            </cite>
            
            <p class="comment-text-moderation">
            	<xsl:choose>
            		<xsl:when test="/H2G2/SITE/MODERATIONSTATUS = 2">
            			<xsl:apply-templates select="/H2G2/SITECONFIG/DNACOMMENTTEXT/PREMODLABEL" mode="library_siteconfig_premodlabel"/>
            		</xsl:when>
            		<xsl:otherwise>
            			<xsl:apply-templates select="/H2G2/SITECONFIG/DNACOMMENTTEXT/PREMODMESSAGE" mode="library_siteconfig_premodmessage" />
            		</xsl:otherwise>
            	</xsl:choose>
            </p>
            <xsl:apply-templates select="." mode="object_post_comment_moderation" />
        </li>
    </xsl:template>
    
    <!-- Hidden post for any user -->
    <xsl:template match="POST[@HIDDEN = 3 and USER/USERID != /H2G2/VIEWING-USER/USER/USERID or @HIDDEN = 3]" mode="object_post_comment">
    	<xsl:variable name="thisUserId" select="USER/USERID"/>
    	<li id="P{@POSTID}">
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
                <a class="time" href="{parent::FORUMTHREADPOSTS/@HOSTPAGEURL}#P{@POSTID}" name="comment{(@INDEX + 1)}">
                    <xsl:apply-templates select="DATEPOSTED" mode="library_time_shortformat" />
                </a>
                <xsl:text> on </xsl:text>
                <span class="date">
                    <xsl:apply-templates select="DATEPOSTED" mode="library_date_shortformat" />
                </span>
                <xsl:text>, </xsl:text>
                <span class="vcard">
                    <span class="fn">
                    	<a href="{/H2G2/PARAMS/PARAM[NAME = 's_commentprofileurl']/VALUE}?userid={USER/USERID}">
                    		<xsl:choose>
                    			<xsl:when test="/H2G2/VIEWING-USER/USER/USERID = $thisUserId">you</xsl:when>
                    			<xsl:otherwise><xsl:value-of select="USER/USERNAME"/></xsl:otherwise>
                    		</xsl:choose>
                    	</a>
                    </span>
                </span>
            	<xsl:text> wrote:</xsl:text>
            </cite>
            <p class="comment-text-moderation">
                This comment is awaiting moderation. <a href="http://www.bbc.co.uk/messageboards/newguide/popup_checking_messages.html" class="popup">Explain</a>.
            </p>
            <xsl:apply-templates select="." mode="object_post_comment_moderation" />
        </li>
    </xsl:template>
    
    
     
    <!-- Removed post for the owner -->
    <xsl:template match="POST[@HIDDEN = 1 and ./USER/USERID = /H2G2/VIEWING-USER/USER/USERID]" mode="object_post_comment">
    	<xsl:variable name="thisUserId" select="USER/USERID"/>
    	<li id="P{@POSTID}">
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
                <a class="time" href="{parent::FORUMTHREADPOSTS/@HOSTPAGEURL}#P{@POSTID}" name="comment{(@INDEX + 1)}">
                    <xsl:apply-templates select="DATEPOSTED" mode="library_time_shortformat" />
                </a>
                <xsl:text> on </xsl:text>
                <span class="date">
                    <xsl:apply-templates select="DATEPOSTED" mode="library_date_shortformat" />
                </span>
                <xsl:text>, </xsl:text>
                <span class="vcard">
                    <span class="fn">
                    	<a href="{/H2G2/PARAMS/PARAM[NAME = 's_commentprofileurl']/VALUE}?userid={USER/USERID}">
                    		<xsl:choose>
                    			<xsl:when test="/H2G2/VIEWING-USER/USER/USERID = $thisUserId">you</xsl:when>
                    			<xsl:otherwise><xsl:value-of select="USER/USERNAME"/></xsl:otherwise>
                    		</xsl:choose>
                    	</a>
                    </span>
                </span>
            	<xsl:text> wrote:</xsl:text>
            </cite>
            
            <p class="comment-text-moderation">
                Your comment has been removed and has been deemed to break the <a class="popup" href="{$houserulespopupurl}">House Rules</a>. 
            </p>
            <xsl:apply-templates select="." mode="object_post_comment_moderation" />
        </li>
    </xsl:template>
    
    <!-- Removed post for any user -->
    <xsl:template match="POST[@HIDDEN = 1 and USER/USERID != /H2G2/VIEWING-USER/USER/USERID or @HIDDEN = 1]" mode="object_post_comment">
    	<xsl:variable name="thisUserId" select="USER/USERID"/>
    	<li id="P{@POSTID}">
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
                <a class="time" href="{parent::FORUMTHREADPOSTS/@HOSTPAGEURL}#P{@POSTID}" name="comment{(@INDEX + 1)}">
                    <xsl:apply-templates select="DATEPOSTED" mode="library_time_shortformat" />
                </a>
                <xsl:text> on </xsl:text>
                <span class="date">
                    <xsl:apply-templates select="DATEPOSTED" mode="library_date_shortformat" />
                </span>
                <xsl:text>, </xsl:text>
                <span class="vcard">
                    <span class="fn">
                    	<a href="{/H2G2/PARAMS/PARAM[NAME = 's_commentprofileurl']/VALUE}?userid={USER/USERID}">
                    		<xsl:choose>
                    			<xsl:when test="/H2G2/VIEWING-USER/USER/USERID = $thisUserId">you</xsl:when>
                    			<xsl:otherwise><xsl:value-of select="USER/USERNAME"/></xsl:otherwise>
                    		</xsl:choose>
                    	</a>
                    </span>
                </span>
            	<xsl:text> wrote:</xsl:text>
            </cite>
            <p class="comment-text-moderation">
                This comment was removed because the moderators found it broke the <a class="popup" href="{$houserulespopupurl}">House Rules</a>.
            </p>
            <xsl:apply-templates select="." mode="object_post_comment_moderation" />
        </li>
    </xsl:template>
    
    <!-- Referred comment for any user -->
    <xsl:template match="POST[@HIDDEN = 2 or @HIDDEN = 6]" mode="object_post_comment">
    	<xsl:variable name="thisUserId" select="USER/USERID"/>
    	<li id="P{@POSTID}">
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
                <a class="time" href="{parent::FORUMTHREADPOSTS/@HOSTPAGEURL}#P{@POSTID}" name="comment{(@INDEX + 1)}">
                    <xsl:apply-templates select="DATEPOSTED" mode="library_time_shortformat" />
                </a>
                <xsl:text> on </xsl:text>
                <span class="date">
                    <xsl:apply-templates select="DATEPOSTED" mode="library_date_shortformat" />
                </span>
                <xsl:text>, </xsl:text>
                <span class="vcard">
                    <span class="fn">
                    	<a href="{/H2G2/PARAMS/PARAM[NAME = 's_commentprofileurl']/VALUE}?userid={USER/USERID}">
                    		<xsl:choose>
                    			<xsl:when test="/H2G2/VIEWING-USER/USER/USERID = $thisUserId">you</xsl:when>
                    			<xsl:otherwise><xsl:value-of select="USER/USERNAME"/></xsl:otherwise>
                    		</xsl:choose>
                    	</a>
                    </span>
                </span>
            	<xsl:text> wrote:</xsl:text>
            </cite>
            <p class="comment-text-moderation">
              This comment has been referred for further consideration. <a href="http://www.bbc.co.uk/blogs/moderation.shtml#queue" target="_blank">Explain</a>
            </p>
            <xsl:apply-templates select="." mode="object_post_comment_moderation" />
        </li>
    </xsl:template>
    
    
    
    <xsl:template match="POST[@HIDDEN != 0 and @HIDDEN != 6 and @HIDDEN != 3 and @HIDDEN != 2 and @HIDDEN != 1]" mode="object_post_comment" />
    
    <xsl:template match="POST[@HIDDEN = 0 or @HIDDEN = '']" mode="object_post_comment">
    	<xsl:variable name="thisUserId" select="USER/USERID"/>
        <li id="P{@POSTID}">
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
                <a class="time" href="{parent::FORUMTHREADPOSTS/@HOSTPAGEURL}#P{@POSTID}" name="comment{(@INDEX + 1)}">
                    <xsl:apply-templates select="DATEPOSTED" mode="library_time_shortformat" />
                </a>
                <xsl:text> on </xsl:text>
                <span class="date">
                    <xsl:apply-templates select="DATEPOSTED" mode="library_date_shortformat" />
                </span>
                <xsl:text>, </xsl:text>
                <span class="vcard">
                    <span class="fn">
                    	<a href="{/H2G2/PARAMS/PARAM[NAME = 's_commentprofileurl']/VALUE}?userid={USER/USERID}">
                    		<xsl:choose>
                    			<xsl:when test="/H2G2/VIEWING-USER/USER/USERID = $thisUserId">you</xsl:when>
                    			<xsl:otherwise><xsl:value-of select="USER/USERNAME"/></xsl:otherwise>
                    		</xsl:choose>
                    	</a>
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
              <a class="popup" href="{$root}/UserComplaintPage?PostID={@POSTID}&amp;s_start=1">Complain about this comment</a>
            </p>
            <xsl:apply-templates select="." mode="object_post_comment_moderation" /> 
        </li>
    </xsl:template>

    
        
                
    <xsl:template match="POST[@HIDDEN = 1 or @HIDDEN = 2 or @HIDDEN = 3 or @HIDDEN = 6]" mode="object_post_comment_moderation">
    	<xsl:variable name="thisUserId" select="USER/USERID"/>
    	<xsl:call-template name="library_userstate_editor">
            <xsl:with-param name="loggedin">
                <p class="moderation">
                    <xsl:apply-templates select="@POSTID" mode="moderation_cta_editpost" />
                    
                    <xsl:apply-templates select="@POSTID" mode="moderation_cta_moderationhistory" />
                </p>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template match="POST[@HIDDEN = 0 or @HIDDEN =  '']" mode="object_post_comment_moderation">
        <xsl:call-template name="library_userstate_editor">
            <xsl:with-param name="loggedin">
                <p class="moderation">
                    <xsl:apply-templates select="@POSTID" mode="moderation_cta_moderationhistory" />
                </p>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>
</xsl:stylesheet>
