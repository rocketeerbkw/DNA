<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">


    <doc:documentation>
        <doc:purpose>
            Page layout for the users More Comments page
        </doc:purpose>
        <doc:context>
            Applied by the kick off file  (e.g. /html.xsl, /rss.xsl etc)
        </doc:context>
        <doc:notes>
            Provides the comment profile solution
        </doc:notes>
    </doc:documentation>
    
    <xsl:template match="/H2G2[@TYPE = 'MORECOMMENTS']" mode="page">   
        
        <div id="dna-commentprofile">
          
          <xsl:choose>
            <xsl:when test="MORECOMMENTS/COMMENTS-LIST/COMMENTS">
              <xsl:apply-templates select="MORECOMMENTS/COMMENTS-LIST/USER" mode="object_user_profile" />
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="library_header_h3">
                <xsl:with-param name="text">
                    <xsl:text>Comments</xsl:text>
                  </xsl:with-param>
                </xsl:call-template>
            </xsl:otherwise>
          </xsl:choose>
            
            <p>
              <xsl:if test="MORECOMMENTS/COMMENTS-LIST/COMMENTS">
                <xsl:text>Listed below are comments made by </xsl:text>
                <xsl:apply-templates select="MORECOMMENTS/COMMENTS-LIST/USER" mode="library_user_morecomments" >
                    <xsl:with-param name="url" select="'.'"></xsl:with-param>
                </xsl:apply-templates>
                <xsl:text> between </xsl:text>
                <xsl:apply-templates select="MORECOMMENTS/COMMENTS-LIST/COMMENTS/COMMENT[position() = last()]/DATEPOSTED/DATE" mode="library_date_longformat"/>
                <xsl:text> and </xsl:text>
                <xsl:apply-templates select="MORECOMMENTS/COMMENTS-LIST/COMMENTS/COMMENT[position() = 1]/DATEPOSTED/DATE" mode="library_date_longformat"/>
                
                <xsl:apply-templates select="/H2G2/SITECONFIG/DNACOMMENTTEXT/MORECOMMENTSLABEL" mode="library_siteconfig_morecommentslabel" />
              </xsl:if>
                
            </p>
            
            <p>
              <xsl:text>You can also view a </xsl:text>
              <a href="MP{(MORECOMMENTS/COMMENTS-LIST/USER | MORECOMMENTS/@USERID)[1]}">
              <xsl:text>list of </xsl:text>
              <xsl:choose>
                <xsl:when test="MORECOMMENTS/COMMENTS-LIST/USER">
                  <xsl:value-of select="MORECOMMENTS/COMMENTS-LIST/USER/USERNAME"/>
                </xsl:when>
                <xsl:otherwise>this user</xsl:otherwise>
              </xsl:choose>
              <xsl:text>'s posts</xsl:text>
              </a>
              <xsl:text>.</xsl:text>
            </p>
            
             <xsl:call-template name="library_userstate_editor">
              <xsl:with-param name="loggedin">
                <p class="dna-boards-moderation">
                  <xsl:apply-templates select="(MORECOMMENTS/COMMENTS-LIST/USER | MORECOMMENTS/@USERID)[1]" mode="moderation_cta_moderateuser">
                    <xsl:with-param name="label">Moderate this user</xsl:with-param>
                  </xsl:apply-templates>
                  <xsl:apply-templates select="(MORECOMMENTS/COMMENTS-LIST/USER | MORECOMMENTS/@USERID)[1]" mode="moderation_cta_inspectuser">
                    <xsl:with-param name="label">Inspect this user</xsl:with-param>
                  </xsl:apply-templates>
                  <xsl:apply-templates select="(MORECOMMENTS/COMMENTS-LIST/USER | MORECOMMENTS/@USERID)[1]" mode="moderation_cta_viewalluserposts">
                   <xsl:with-param name="label">View all comments for this user</xsl:with-param>
                  </xsl:apply-templates>
                </p>
              </xsl:with-param>
            </xsl:call-template>
            
            <xsl:apply-templates select="MORECOMMENTS/COMMENTS-LIST" mode="library_pagination_comments-list" />
            
            <xsl:apply-templates select="MORECOMMENTS/COMMENTS-LIST" mode="object_comments-list" />
            
            <xsl:apply-templates select="MORECOMMENTS/COMMENTS-LIST" mode="library_pagination_comments-list" />
        
        </div>
    </xsl:template>
    
    <xsl:template match="/H2G2[@TYPE = 'MORECOMMENTS']" mode="breadcrumbs">
      <li>
          <a href="/"><xsl:value-of select="concat(/H2G2/SITECONFIG/BOARDNAME, ' message boards')"/></a>
      </li>
      <li class="current">
          <a href="MP{MORECOMMENTS/@USERID}">
              <xsl:text>Profile for </xsl:text>
              <xsl:choose>
                <xsl:when test="MORECOMMENTS/COMMENTS-LIST/USER/USERNAME"><xsl:value-of select="MORECOMMENTS/COMMENTS-LIST/USER/USERNAME"/></xsl:when>
                <xsl:otherwise><xsl:value-of select="concat('U', MORECOMMENTS/@USERID)"/></xsl:otherwise>
              </xsl:choose>
          </a>
      </li>
    </xsl:template>
    

</xsl:stylesheet>