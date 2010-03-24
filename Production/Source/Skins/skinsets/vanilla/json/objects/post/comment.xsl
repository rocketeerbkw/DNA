<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">
    
    <doc:documentation for="/sites/MySite/objects/post/generic.xsl">
        <doc:purpose>
            Holds the generic HTML construction of a comment
        </doc:purpose>
        <doc:context>
            Called by object-post (_common/_logic/_objects/post.xsl)
        </doc:context>
        <doc:notes>
            GuideML is the xml format (similiar to HTML) that user entered content is
            stored in. 
        </doc:notes>
    </doc:documentation>
    
    
    <xsl:template match="POST[@HIDDEN = 3]" mode="object_post_comment">
        <xsl:if test="USER/USERID = /H2G2/VIEWING-USER/USER/USERID">
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
                            <xsl:apply-templates select="USER" mode="library_user_morecomments" />
                        </span>
                    </span>
                    <xsl:text> (awaiting moderation)</xsl:text>
                </cite>
                
                <p class="comment-text-moderation">
                    <xsl:call-template name="library_string_escapeapostrophe">
                        <xsl:with-param name="str">
                            <xsl:apply-templates select="/H2G2/SITECONFIG/DNACOMMENTTEXT/PREMODMESSAGE" mode="library_siteconfig_premodmessage" />
                        </xsl:with-param>
                    </xsl:call-template>
                </p>
            </li>
        </xsl:if>
    </xsl:template>
    
    
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
                <xsl:apply-templates select="TEXT" mode="library_Richtext">
                    <xsl:with-param name="escapeapostrophe" select="true()" />
                </xsl:apply-templates>
            </p>
        </li>
    </xsl:template>
</xsl:stylesheet>
