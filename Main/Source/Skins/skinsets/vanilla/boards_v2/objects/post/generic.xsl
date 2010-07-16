<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">
    
    <doc:documentation for="/sites/MySite/objects/post/generic.xsl">
        <doc:purpose>
            Holds the generic HTML construction of a post
        </doc:purpose>
        <doc:context>
            Called by object-post (_common/_logic/_objects/post.xsl)
        </doc:context>
        <doc:notes>
            GuideML is the xml format (similiar to HTML) that user entered content is
            stored in. 
        </doc:notes>
    </doc:documentation>
    
    
    <xsl:template match="POST" mode="object_post_generic">
        <xsl:param name="additional-classnames" />
        
        <li id="p{@POSTID}">
            <!-- Add the stripe class -->
            <xsl:call-template name="library_listitem_stripe">
                <xsl:with-param name="additional-classnames" select="$additional-classnames"/>
            </xsl:call-template>
            <xsl:apply-templates select="." mode="library_itemdetail"/> 
            
            <xsl:call-template name="library_userstate_editor">
              <xsl:with-param name="loggedin"> 
              	<div class="dna-moderation-wrapup"> 
                <p class="dna-boards-moderation">
                	<xsl:text>Moderation:</xsl:text>
					<xsl:apply-templates select="USER" mode="moderation_cta_moderateuser">
						<xsl:with-param name="label" select="'Moderate this user'" />
                    	<xsl:with-param name="user" select="USER/USERNAME" />
					</xsl:apply-templates>
					<xsl:apply-templates select="USER" mode="moderation_cta_viewalluserposts">
						<xsl:with-param name="label" select="'View all posts for this user'" />
                    	<xsl:with-param name="user" select="USER/USERNAME" />
					</xsl:apply-templates>
                </p>
                </div>
              </xsl:with-param>
            </xsl:call-template>
            
            <xsl:choose>
                <xsl:when test="@HIDDEN = 3 and USER/USERID = /H2G2/VIEWING-USER/USER/USERID">
                    <!-- Hidden post for the owner -->
                    <p class="dna-boards-failedpost">
                        <!-- <xsl:apply-templates select="/H2G2/SITECONFIG/DNACOMMENTTEXT/PREMODMESSAGE" mode="library_siteconfig_premodmessage" /> -->
                        <xsl:value-of select="TEXT" />
                    </p>
                </xsl:when>
                <xsl:when test="(@HIDDEN = 3 and USER/USERID != /H2G2/VIEWING-USER/USER/USERID) or @HIDDEN = 3">
                    <!-- Hidden post for any user -->
                    <p class="dna-boards-failedpost">
                        This comment is awaiting moderation. <a href="http://www.bbc.co.uk/messageboards/newguide/popup_checking_messages.html" class="popup">Explain</a>.
                    </p>
                	<xsl:call-template name="library_userstate_editor">
                		<xsl:with-param name="loggedin">
                			<p class="dna-boards-moderation">
                				<xsl:apply-templates select="@POSTID" mode="moderation_cta_boardsadmin_editpost" >
                					<xsl:with-param name="label" select="'Show this Post'"/>
                				</xsl:apply-templates>
                			</p>
                		</xsl:with-param>
                	</xsl:call-template>
                </xsl:when>
                <xsl:when test="@HIDDEN = 1 and USER/USERID = /H2G2/VIEWING-USER/USER/USERID">
                    <!-- Removed post for the owner -->
                    <p class="dna-boards-failedpost">
                        Your posting has been hidden during moderation because it broke the <a class="popup" href="http://www.bbc.co.uk/messageboards/newguide/popup_house_rules.html">House Rules</a> in some way. 
                    </p>
                </xsl:when>
                <xsl:when test="@HIDDEN = 1 and USER/USERID != /H2G2/VIEWING-USER/USER/USERID or @HIDDEN = 1">
                    <!-- Removed post for any user -->
                    <p class="dna-boards-failedpost">
                        This posting has been hidden during moderation because it broke the <a class="popup" href="http://www.bbc.co.uk/messageboards/newguide/popup_house_rules.html">House Rules</a> in some way.
                    </p>
                </xsl:when>
                <xsl:when test="@HIDDEN = 2 or @HIDDEN = 6">
                    <!-- Referred post for any user -->
                    <p class="dna-boards-failedpost">
                        This post has been temporarily hidden, because a moderator has referred it to a supervisor, BBC host or the Central Communities Team for a decision as to whether it contravenes the <a href="http://www.bbc.co.uk/messageboards/newguide/popup_house_rules.html" class="popup">House Rules</a> in some way. A decision will be made as quickly as possible..
                    </p>
                </xsl:when>
                <xsl:when test="@HIDDEN != 0 and @HIDDEN != 6 and @HIDDEN != 3 and @HIDDEN != 2 and @HIDDEN != 1"/>
                <xsl:when test="@HIDDEN = 0 or @HIDDEN = ''">
                    <p>
                        <xsl:apply-templates select="TEXT" mode="library_GuideML" />
                    </p>
                </xsl:when>
                <xsl:otherwise></xsl:otherwise>
            </xsl:choose>
                        
            <xsl:choose>
                <xsl:when test="$siteClosed = 'true'">
                    <!-- Nowt -->
                </xsl:when>
                <xsl:otherwise>
                    <p class="dna-boards-inreplyto">
                        <a href="{$root}/AddThread?inreplyto={@POSTID}" class="id-cta">
                            <xsl:call-template name="library_memberservice_require">
                                <xsl:with-param name="ptrt">
                                    <xsl:value-of select="$root"/>
                                    <xsl:text>/AddThread?inreplyto=</xsl:text>
                                    <xsl:value-of select="@POSTID"/>
                                </xsl:with-param>
                            </xsl:call-template>
                            Reply to this message
                            <span class="blq-hide"><xsl:value-of select="count(preceding-sibling::*)" /></span>
                        </a>
                    </p>
                </xsl:otherwise>
            </xsl:choose>
            
            <xsl:call-template name="library_userstate_editor">
                <xsl:with-param name="loggedin">
               	<div class="dna-moderation-wrapup">
                    <p class="dna-boards-moderation">
                    	<xsl:text>Moderation:</xsl:text>
			        	<xsl:call-template name="library_userstate_superuser">
			        		<xsl:with-param name="loggedin">
		        				<xsl:apply-templates select="@POSTID" mode="moderation_cta_boardsadmin_editpost" >
		        					<xsl:with-param name="label" select="'Edit Post'"/>
                      <xsl:with-param name="post" select="count(preceding-sibling::*)" />
		        				</xsl:apply-templates>
			        		</xsl:with-param>
			        	</xsl:call-template>                    
                        <span class="dna-invisible">View the </span>
                        <xsl:apply-templates select="@POSTID" mode="moderation_cta_boardsadmin_moderationhistory">
                          <xsl:with-param name="label" select="'Moderation History'"/>
                          <xsl:with-param name="post" select="count(preceding-sibling::*)" />
                      </xsl:apply-templates>
                    </p>
                </div>
                </xsl:with-param>
            </xsl:call-template>
            
            <xsl:apply-templates select="USER" mode="library_userstate_editor">
                <xsl:with-param name="false">
                    <p class="flag">
                        <a class="popup">
                            <xsl:attribute name="href">
                                <xsl:value-of select="concat($root, '/comments/UserComplaintPage?PostID=' , @POSTID, '&amp;s_start=1&amp;s_ptrt=')" />
                                <xsl:call-template name="library_serialise_ptrt_in">
                                    <xsl:with-param name="string">
                                        <xsl:apply-templates select="/H2G2" mode="library_memberservice_ptrt" />
                                    </xsl:with-param>
                                </xsl:call-template>
                            </xsl:attribute>
                            <xsl:text>Report message</xsl:text>
                            <span class="blq-hide"> <xsl:value-of select="count(preceding-sibling::*)" /></span>
                        </a>
                    </p>
                </xsl:with-param>
            </xsl:apply-templates>
            
            <xsl:if test="@INREPLYTO">
              <p class="dna-boards-thisreplyto">
              <xsl:choose>
              	<xsl:when test="@INREPLYTOINDEX">
                	This is a reply to <a href="{concat($root, '/NF', parent::FORUMTHREADPOSTS/@FORUMID, '?thread=', parent::FORUMTHREADPOSTS/@THREADID, '#p', @INREPLYTO)}"> message <xsl:value-of select="@INREPLYTOINDEX+1" /></a>.
                </xsl:when>
                <xsl:otherwise>
                	This is a reply to <a href="{concat($root, '/NF', parent::FORUMTHREADPOSTS/@FORUMID, '?thread=', parent::FORUMTHREADPOSTS/@THREADID, '#p', @INREPLYTO)}"> this message</a>.
                </xsl:otherwise>
               </xsl:choose>
              </p>
            </xsl:if>
            
        </li>
        
    </xsl:template>
</xsl:stylesheet>
