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
    
    
    <xsl:template match="POST" mode="object_post_search">
        <xsl:param name="additional-classnames" />
        
        <li id="p{@POSTID}">
            <!-- Add the stripe class -->
            <xsl:call-template name="library_listitem_stripe">
                <xsl:with-param name="additional-classnames" select="$additional-classnames"/>
            </xsl:call-template>
          <div class="itemdetail">
            <p><xsl:text>Posted by </xsl:text>
            <xsl:apply-templates select="USER" mode="library_user_linked"/>
              <xsl:apply-templates select="DATEPOSTED | DATECREATED" mode="library_itemdetail"/>
            </p>
          </div>

          <p>
            <a href="{concat($root, '/NF', @FORUMID)}">
              <xsl:value-of select="/H2G2/TOPICLIST/TOPIC[FORUMID = @FORUMID]/TITLE" />Forum
            </a>
            /
            <a href="{concat($root, '/NF', @FORUMID, '?thread=', @THREAD)}">
              <xsl:apply-templates select="SUBJECT" mode="library_GuideML" />
            </a>
            <br/>
            (Relevance: <xsl:value-of select="@RANK"/>%)
          </p>
            
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
                <xsl:when test="@HIDDEN = 8">
                  <!-- Removed post for any user -->
                  <p class="dna-boards-failedpost">
                    Why have all of a users’ comments vanished? If the user is a spammer or a user who has been banned many times before all of their comments are removed when their account is closed.
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

          <xsl:variable name="skip">
            <xsl:value-of select="floor(@INDEX div 50) * 50" />
          </xsl:variable>
          <p class="dna-boards-thisreplyto">
            <a href="{concat($root, '/NF', @FORUMID, '?thread=', @THREAD, '&amp;skip=', $skip, '#p', @POSTID)}">Go to message</a>
          </p>
            
        </li>
        
    </xsl:template>
</xsl:stylesheet>
