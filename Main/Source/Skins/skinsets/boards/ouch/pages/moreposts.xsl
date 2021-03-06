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
    
    <xsl:template match="/H2G2[@TYPE = 'MOREPOSTS']" mode="page">        
        
        <xsl:call-template name="library_header_h3">
            <xsl:with-param name="text">
                <span class="dna-invisible">
                    <xsl:text>Profile for </xsl:text>
                </span>
                <xsl:value-of select="POSTS/POST-LIST/USER/USERNAME"/>
                <xsl:text> (U</xsl:text><xsl:value-of select="POSTS/POST-LIST/USER/USERID"/><xsl:text>) </xsl:text>
                <span>
                    <a href="MP{POSTS/POST-LIST/USER/USERID}">permalink</a>
                </span>
            </xsl:with-param>
        </xsl:call-template>    
        
        <p>
          <xsl:choose>
            <xsl:when test="POSTS/POST-LIST/POST">
               <xsl:text>Listed below are posts made by </xsl:text>
               <xsl:value-of select="POSTS/POST-LIST/USER/USERNAME"/>
              <xsl:text> (U</xsl:text><xsl:value-of select="POSTS/POST-LIST/USER/USERID"/><xsl:text>)</xsl:text>
              <xsl:text> between </xsl:text>
              <xsl:apply-templates select="POSTS/POST-LIST/POST[position() = last()]/THREAD/REPLYDATE/DATE" mode="library_date_longformat"/>
              <xsl:text> and </xsl:text>
              <xsl:apply-templates select="POSTS/POST-LIST/POST[position() = 1]/THREAD/REPLYDATE/DATE" mode="library_date_longformat"/>

              <xsl:apply-templates select="/H2G2/SITECONFIG/DNACOMMENTTEXT/MOREPOSTSLABEL" mode="library_siteconfig_morepostslabel" />
            </xsl:when>
            <xsl:otherwise>
              <xsl:text>This user hasn't made any posts yet.</xsl:text>
            </xsl:otherwise>
          </xsl:choose>
          
        </p>
        
        <p>
          <xsl:text>You can also view a </xsl:text>
          <a href="MC{POSTS/POST-LIST/USER/USERID}">list of <xsl:value-of select="POSTS/POST-LIST/USER/USERNAME"/>'s comments</a>
          <xsl:text>.</xsl:text>
        </p>
        
        <xsl:call-template name="library_userstate_editor">
          <xsl:with-param name="loggedin">
            <p class="dna-boards-moderation">
              <xsl:apply-templates select="POSTS/POST-LIST/USER" mode="moderation_cta_moderateuser">
                <xsl:with-param name="label">Moderate this user</xsl:with-param>
              </xsl:apply-templates>
              <xsl:apply-templates select="POSTS/POST-LIST/USER" mode="moderation_cta_inspectuser">
                <xsl:with-param name="label">Inspect this user</xsl:with-param>
              </xsl:apply-templates>
              <xsl:apply-templates select="POSTS/POST-LIST/USER" mode="moderation_cta_viewalluserposts">
               <xsl:with-param name="label">View all posts for this user</xsl:with-param>
              </xsl:apply-templates>
            </p>
          </xsl:with-param>
        </xsl:call-template>
        
        <xsl:apply-templates select="POSTS/POST-LIST" mode="library_pagination_post-list" />
        
        <xsl:apply-templates select="POSTS/POST-LIST" mode="object_post-list" />
        
        <xsl:apply-templates select="POSTS/POST-LIST" mode="library_pagination_post-list" />
        
    </xsl:template>
    
    <xsl:template match="/H2G2[@TYPE = 'MOREPOSTS']" mode="breadcrumbs">
        <li>
            <a href="/"><xsl:value-of select="concat(/H2G2/SITECONFIG/BOARDNAME, ' message boards')"/></a>
        </li>
        <li class="current">
            <a href="MP{POSTS/POST-LIST/USER/USERID}">
                <xsl:text>Profile for </xsl:text>
                <xsl:value-of select="POSTS/POST-LIST/USER/USERNAME"/>
            </a>
        </li>
    </xsl:template>
    

</xsl:stylesheet>