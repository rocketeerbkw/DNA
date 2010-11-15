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
    
    
    <xsl:template match="CONTRIBUTIONITEM" mode="object_post_generic">
        <xsl:param name="additional-classnames" />
        
        <li>
          <div>
            <xsl:apply-templates select="DATEPOST" mode="library_time_shortformat" />
            <xsl:text> on </xsl:text>
            <span class="date">
              <xsl:apply-templates select="DATEPOST" mode="library_date_shortformat" />
            </span>
            <br/>
            <xsl:text>(</xsl:text>
            <xsl:value-of select="DATEPOST/@RELATIVE"/>
            <xsl:text>)</xsl:text>
          </div>
          <div>
            <a>
              <xsl:attribute name="href">
                <xsl:choose>
                  <xsl:when test="COMMENTFORUMURL = ''">
                    <xsl:value-of select="concat('/dna/', SITEURL, '/F', FORUMID)"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="COMMENTFORUMURL"/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:attribute>
              <xsl:choose>
                <xsl:when test="SOURCETITLE = ''">
                  <xsl:value-of select="TITLE"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="SOURCETITLE"/>
                </xsl:otherwise>
              </xsl:choose>
            </a>
          </div>
          <div>
            from
            <a>
              <xsl:attribute name="href">
                <xsl:choose>
                  <xsl:when test="SITETYPE = 'Blog'">
                    <xsl:value-of select="concat(COMMENTFORUMURL, '?postid=', THREADENTRYID)"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="concat('/dna/', SITEURL, '/F', FORUMID, '?thread=', THREADID, '&amp;post=', THREADENTRYID, '#p', THREADENTRYID)"/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:attribute>
              <xsl:value-of select="TITLE"/>
            </a>
            in
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
          </div>

          <div>
            <xsl:apply-templates select="TEXT" mode="library_GuideML"/>
          </div>
          <div  class="dna-fr">
            <xsl:choose>
              <xsl:when test="/H2G2/CONTRIBUTIONS/@USERID != /H2G2/VIEWING-USER/USER/USERID">
                <xsl:choose>
                  <xsl:when test="MODERATIONSTATUS=3">
                    <p class="dna-boards-failedpost">Awaiting Moderation.</p>
                  </xsl:when>
                  <xsl:when test="MODERATIONSTATUS=8">
                    <p class="dna-boards-failedpost">User Removed</p>
                  </xsl:when>
                  <xsl:when test="MODERATIONSTATUS = 2 or MODERATIONSTATUS = 6 or MODERATIONSTATUS=1">
                    <!-- Referred post for any user -->
                    <p class="dna-boards-failedpost">
                      <a href="/dna/{SITEURL}/ModerationHistory?PostID={THREADENTRYID}" target="_blank">Post Failed</a>
                    </p>
                  </xsl:when>
                  <xsl:otherwise>
                    <a class="popup">
                      <xsl:attribute name="href">
                        <xsl:value-of select="concat('/dna/', SITEURL,'/comments/UserComplaintPage?PostID=' , @THREADENTRYID, '&amp;s_start=1&amp;s_ptrt=')" />
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
              </xsl:when>
            </xsl:choose>
          </div>
        </li>
        
    </xsl:template>
</xsl:stylesheet>