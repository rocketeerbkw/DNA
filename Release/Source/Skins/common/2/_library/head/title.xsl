<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">
    
    <doc:documentation>
        <doc:purpose>
            Creates text for the title of the document, commonly used in the HTML title element.
        </doc:purpose>
        <doc:context>
            Often applied in a kick-off file (e.g. /html.xsl, /rss.xsl)
        </doc:context>
        <doc:notes>
            
        </doc:notes>
    </doc:documentation>
    
    
    <!-- 
        Creates the title, using the siteName value from the skin specific
        configuration and the title rules for each type of page, defined
        below.
    -->
    <xsl:template match="/H2G2" mode="head_title">
        <xsl:apply-templates select="." mode="head_title_page"/>
    </xsl:template>
    
    
    
    <!-- Title for Article page -->
    <xsl:template match="/H2G2[@TYPE = 'ARTICLE']" mode="head_title_page">
        <xsl:value-of select="ARTICLE/SUBJECT"/>
    </xsl:template>
    
    <xsl:template match="/H2G2[@TYPE = 'ARTICLESEARCH']" mode="head_title_page">
        <xsl:text>Article Search</xsl:text>
    </xsl:template>
    
    <xsl:template match="/H2G2[@TYPE = 'THREADS']" mode="head_title_page">
        <xsl:value-of select="FORUMSOURCE/ARTICLE/SUBJECT"/>
    </xsl:template>
    
    <xsl:template match="/H2G2[@TYPE = 'NOTFOUND']" mode="head_title_page">
        Not Found
    </xsl:template>
    
    <xsl:template match="/H2G2[@TYPE = 'COMMENTFORUMLIST']" mode="head_title_page">
        Dashboard
    </xsl:template>
    
    <xsl:template match="/H2G2[@TYPE = 'KEYARTICLE-EDITOR']" mode="head_title_page">
        Named Articles
    </xsl:template>
    
    <xsl:template match="/H2G2[@TYPE = 'FRONTPAGE']" mode="head_title_page" />
    
    <xsl:template match="/H2G2[@TYPE = 'FRONTPAGE'][TOPICLIST]" mode="head_title_page" >
        <xsl:text>Home</xsl:text>
    </xsl:template>
    
    
    <xsl:template match="/H2G2[@TYPE = 'FRONTPAGE-EDITOR']" mode="head_title_page">
        Edit The Frontpage
    </xsl:template>
    
    <xsl:template match="/H2G2[@TYPE = 'ERROR']" mode="head_title_page">
        Error
    </xsl:template>
    
    <xsl:template match="/H2G2[@TYPE = 'UITEMPLATEDEFINITION']" mode="head_title_page">
        UITemplate Definition Tool Page
    </xsl:template>
    
    <xsl:template match="/H2G2[@TYPE = 'USEREDIT']" mode="head_title_page">
        Editing
    </xsl:template>
    
    
    
    <!-- Title for Category page -->
    <xsl:template match="/H2G2[@TYPE = 'CATEGORY']" mode="head_title_page">
        <xsl:text>Viewing category '</xsl:text>
        <xsl:value-of select="HIERARCHYDETAILS/DISPLAYNAME"/>
        <xsl:text>'</xsl:text>
    </xsl:template>
    
    <xsl:template match="/H2G2[@TYPE = 'INSPECT-USER']" mode="head_title_page">
        <xsl:text>Inspect User</xsl:text>
    </xsl:template>
    
    <xsl:template match="/H2G2[@TYPE = 'THREADS']" mode="head_title_page">
        <xsl:value-of select="FORUMSOURCE/ARTICLE/SUBJECT"/>
    </xsl:template>
    
    <xsl:template match="/H2G2[@TYPE = 'ADDTHREAD'] | /H2G2[@TYPE = 'POSTTOFORUM']" mode="head_title_page">
        <xsl:value-of select="TOPICLIST/TOPIC[FORUMID = current()/POSTTHREADFORM/@FORUMID]/TITLE"/>
        <xsl:text> - </xsl:text>
        <xsl:value-of select="POSTTHREADFORM/SUBJECT"/>
        <xsl:text> - Reply to a message</xsl:text>
    </xsl:template>
    
    <xsl:template match="/H2G2[@TYPE = 'ADDTHREAD'][POSTTHREADFORM/@INREPLYTO = 0]" mode="head_title_page">
        <xsl:value-of select="TOPICLIST/TOPIC[FORUMID = current()/POSTTHREADFORM/@FORUMID]/TITLE"/>
        <xsl:text> - Start a new discussion</xsl:text>
    </xsl:template>
    
    <!-- Title for Multipost page, attached to an Article -->
    <xsl:template match="/H2G2[@TYPE = 'MULTIPOSTS'][/H2G2/FORUMSOURCE[@TYPE = 'article']]" mode="head_title_page">
        <xsl:value-of select="FORUMSOURCE/ARTICLE/SUBJECT"/>
        -
        <xsl:value-of select="FORUMTHREADPOSTS/FIRSTPOSTSUBJECT"/>
    </xsl:template>
    
    <!-- Title for Multipost page, attached to a User information page -->
    <xsl:template match="/H2G2[@TYPE = 'MULTIPOSTS'][/H2G2/FORUMSOURCE[@TYPE = 'userpage']]" mode="head_title_page">
        <xsl:value-of select="FORUMSOURCE/USERPAGE/USER/USERNAME"/>
        <xsl:value-of select="FORUMTHREADPOSTS/FIRSTPOSTSUBJECT"/>
    </xsl:template>
    
    <!-- Title for a User information page -->
    <xsl:template match="/H2G2[@TYPE = 'USERPAGE']" mode="head_title_page">
        <xsl:value-of select="ARTICLE/SUBJECT"/>
    </xsl:template>
    
    <!-- Title for a More posts (messageboard profile page) -->
    <xsl:template match="/H2G2[@TYPE = 'MOREPOSTS']" mode="head_title_page">
        Profile for <xsl:apply-templates select="POSTS/POST-LIST/USER" mode="library_user_username" />
    </xsl:template>
    
    <!-- Title for a More comments (messageboard profile page) -->
    <xsl:template match="/H2G2[@TYPE = 'MORECOMMENTS']" mode="head_title_page">
        Profile for <xsl:apply-templates select="MORECOMMENTS/COMMENTS-LIST/USER" mode="library_user_username" />
    </xsl:template>
    
    <!-- Title for a User information page -->
    <xsl:template match="/H2G2[@TYPE = 'USERDETAILS']" mode="head_title_page">
        <xsl:text>Change your nickname</xsl:text>
    </xsl:template>
    
    <!-- Title for a User information page -->
    <xsl:template match="/H2G2[@TYPE = 'USERPAGE']" mode="head_title_page">
        <xsl:value-of select="concat('U', VIEWING-USER/USER/USERID)"/>
    </xsl:template>
    
    <!-- Title for a move thread page -->
    <xsl:template match="/H2G2[@TYPE = 'MOVE-THREAD']" mode="head_title_page">
        <xsl:text>Move a discussion</xsl:text>
    </xsl:template>
    
    <!-- Title for a search posts page -->
    <xsl:template match="/H2G2[@TYPE = 'SEARCHTHREADPOSTS']" mode="head_title_page">
        <xsl:text>Search results</xsl:text>
    </xsl:template>    
    
    
</xsl:stylesheet>