<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">
    
    <doc:documentation>
        <doc:purpose>
            Transforms a collection of posts to HTML 
        </doc:purpose>
        <doc:context>
            Used by a MULTIPOSTS page
        </doc:context>
        <doc:notes>
            
        </doc:notes>
    </doc:documentation>
    
    
    <xsl:template match="FORUMTHREADPOSTS[preceding-sibling::ENDDATE/DATE/@SORT &lt; /H2G2/DATE/@SORT]" mode="input_commentbox">
        <p class="dna-commentbox-nocomments">
            <xsl:apply-templates select="/H2G2/SITECONFIG/DNACOMMENTTEXT/FORUMCLOSEDMESSAGE" mode="library_siteconfig_forumclosedmessage" />
        </p>
    </xsl:template>
    
    <xsl:template match="FORUMTHREADPOSTS[@CANWRITE = 0]" mode="input_commentbox">
        <p class="dna-commentbox-nocomments">
            <xsl:apply-templates select="/H2G2/SITECONFIG/DNACOMMENTTEXT/FORUMCLOSEDMESSAGE" mode="library_siteconfig_forumclosedmessage" />
        </p>
    </xsl:template>
    
    
    <xsl:template match="FORUMTHREADPOSTS" mode="input_commentbox">
        
        <form action="{$root}/acs" method="post" class="dna-commentbox" id="postcomment">
            <div id="dnaacs">
                <xsl:call-template name="library_header_h3">
                    <xsl:with-param name="text">Post a comment</xsl:with-param>
                </xsl:call-template>
                
                <p class="dna-moderation-message">
                    <!--<span class="dnaacs-unmod-label">All posts are reactively moderated. <a class="popup" href="http://www.bbc.co.uk/messageboards/newguide/popup_checking_messages.html">What does this mean?</a></span>-->
                    <xsl:apply-templates select="@MODERATIONSTATUS" mode="library_moderation_moderationstatus">
                        <xsl:with-param name="unmod">
                            <xsl:apply-templates select="/H2G2/SITECONFIG/DNACOMMENTTEXT/UNMODLABEL" mode="library_siteconfig_unmodlabel"/>
                        </xsl:with-param>
                        <xsl:with-param name="premod">
                            <xsl:apply-templates select="/H2G2/SITECONFIG/DNACOMMENTTEXT/PREMODLABEL" mode="library_siteconfig_premodlabel"/>
                        </xsl:with-param>
                        <xsl:with-param name="postmod">
                            <xsl:apply-templates select="/H2G2/SITECONFIG/DNACOMMENTTEXT/POSTMODLABEL" mode="library_siteconfig_postmodlabel"/>
                        </xsl:with-param>
                    </xsl:apply-templates>
                </p>
                
                
                <input type="hidden" name="dnauid" value="{@UID}"/>
                <input type="hidden" value="add" name="dnaaction"/>
                <input type="hidden" value="1" name="dnaur"/>
                <input type="hidden" value="1" name="dnapoststyle"/>
                
                <p>
                    <label for="dna-commentbox-text">Your Comment</label>
                    <textarea id="dna-commentbox-text" name="dnacomment"></textarea>
                </p>
                <p>
                    <label for="dna-commentbox-submit" class="dna-invisible">Send your comment</label>
                    <input type="submit" id="dna-commentbox-submit" name="dnasubmit" value="Post Comment"/>
                </p>
                
            </div>
        </form>
        
    </xsl:template>
    
</xsl:stylesheet>