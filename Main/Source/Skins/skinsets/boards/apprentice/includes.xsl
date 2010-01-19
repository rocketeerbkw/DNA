<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:msxsl="urn:schemas-microsoft-com:xslt"  xmlns:doc="http://www.bbc.co.uk/dna/documentation" exclude-result-prefixes="msxsl doc">
   
    <doc:documentation>
        <doc:purpose>
            Site specific master include file.
        </doc:purpose>
        <doc:context>
            Included at the top of the kick-off page (e.g. /html.xsl, /rss.xsl etc)
        </doc:context>
        <doc:notes>
            Pulls in site specific configuration, page and object
            markup files and all common skin-wide XSL logic.
        </doc:notes>
    </doc:documentation>
    
    
    <!-- =================================================================================== Required === --> 
    <xsl:include href="../../../common/configuration.xsl"/>
    <xsl:include href="../configuration.xsl"/>
    
    <xsl:variable name="configuration" select="msxsl:node-set($skin)/configuration" />
    
    <xsl:include href="../../../common/1/includes.xsl" />
    
    <!-- ==================================================================================== Library === -->
    
    
    
    
    <!-- ===================================================================================== Markup === -->
    <!--   =============================================================== Pages ===                      -->
    <xsl:include href="../../vanilla/boards/pages/multiposts-article.xsl" />
    <xsl:include href="../../vanilla/boards/pages/multiposts-userpage.xsl" />
    
    <xsl:include href="../../vanilla/boards/pages/addthread.xsl" />
    <xsl:include href="../../vanilla/boards/pages/blogsummary.xsl" />
    <xsl:include href="../../vanilla/boards/pages/category.xsl" />
    <xsl:include href="../../vanilla/boards/pages/commentbox.xsl" />
    <xsl:include href="../../vanilla/boards/pages/error.xsl" />
    <xsl:include href="../../vanilla/boards/pages/frontpage.xsl" />
    <xsl:include href="../../vanilla/boards/pages/inspect-user.xsl" />
    <xsl:include href="../../vanilla/boards/pages/moreposts.xsl" />
    <xsl:include href="../../vanilla/boards/pages/morecomments.xsl" />
    <xsl:include href="../../vanilla/boards/pages/movethread.xsl" />
    <xsl:include href="../../vanilla/boards/pages/notfound.xsl" />
	<xsl:include href="../../vanilla/boards/pages/servertoobusy.xsl" />
    <xsl:include href="../../vanilla/boards/pages/threads.xsl" />
    <xsl:include href="../../vanilla/boards/pages/userdetails.xsl" />
    <xsl:include href="../../vanilla/boards/pages/userpage.xsl" />
    
    <!--
    <xsl:include href="../../vanilla/comments/pages/user-complaint.xsl" />
    -->
    
    <xsl:include href="../../vanilla/boards/pages/uitemplatedefinition.xsl" />
    
    <!--   ============================================================= Inputs  ===                      -->
    
    <xsl:include href="../../vanilla/boards/inputs/postthreadform.xsl" />
	<xsl:include href="../../vanilla/boards/inputs/moderated.xsl" />
    <xsl:include href="../../vanilla/boards/inputs/inspect-user-form.xsl" />
    <!--
    <xsl:include href="../../vanilla/comments/inputs/user-complaint-form.xsl" />
    -->
    
    <xsl:include href="../../vanilla/boards/inputs/move-thread-form.xsl" />
    <xsl:include href="../../vanilla/boards/inputs/user-details-form.xsl" />
    <xsl:include href="../../vanilla/boards/inputs/commentbox.xsl" />
    
    <!--   ============================================================= Objects ===                      -->
    <xsl:include href="../../vanilla/boards/objects/post/first.xsl" />
    <xsl:include href="../../vanilla/boards/objects/post/generic.xsl" />
    <xsl:include href="../../vanilla/boards/objects/post/comment.xsl" />
    <xsl:include href="../../vanilla/boards/objects/post/recentcomments.xsl" />
    
    <xsl:include href="../../vanilla/boards/objects/article/generic.xsl" />
    <xsl:include href="../../vanilla/boards/objects/article/incomplete.xsl" />
    <xsl:include href="../../vanilla/boards/objects/article/title.xsl" />
    
    <xsl:include href="../../vanilla/boards/objects/ancestry.xsl" />
    <xsl:include href="../../vanilla/boards/objects/comments-list.xsl" />
    <xsl:include href="../../vanilla/boards/objects/commentforumlist.xsl" />
    <xsl:include href="../../vanilla/boards/objects/forumthreads.xsl" />
    <xsl:include href="../../vanilla/boards/objects/forumthreadposts.xsl" />
    <xsl:include href="../../vanilla/boards/objects/group.xsl" />
    <xsl:include href="../../vanilla/boards/objects/groups-list.xsl" />
    <xsl:include href="../../vanilla/boards/objects/members.xsl" />
    <xsl:include href="../../vanilla/boards/objects/post-list.xsl" />
    <xsl:include href="../../vanilla/boards/objects/recentcomments.xsl" />
    <xsl:include href="../../vanilla/boards/objects/watchinguserlist.xsl" />
    
    
    <xsl:include href="../../vanilla/boards/objects/commentforum/commentforum.xsl" />
    <xsl:include href="../../vanilla/boards/objects/commentforum/blogsummary.xsl" />
    
    <xsl:include href="../../vanilla/boards/objects/error/error.xsl" />
    <xsl:include href="../../vanilla/boards/objects/error/errormessage.xsl" />
    <xsl:include href="../../vanilla/boards/objects/error/extrainfo.xsl" />
    
    
    <xsl:include href="../../vanilla/boards/objects/member/article.xsl" />
    <xsl:include href="../../vanilla/boards/objects/member/subject.xsl" />
    
    <xsl:include href="../../vanilla/boards/objects/top-fives/top-fives.xsl" />
    <xsl:include href="../../vanilla/boards/objects/top-fives/top-five.xsl" />
    <xsl:include href="../../vanilla/boards/objects/top-fives/top-five-article.xsl" />
    <xsl:include href="../../vanilla/boards/objects/top-fives/top-five-forum.xsl" />
    
    <xsl:include href="../../vanilla/boards/objects/ancestor.xsl" />
    <xsl:include href="../../vanilla/boards/objects/comment.xsl" />
    <xsl:include href="../../vanilla/boards/objects/thread.xsl" />
    
    <xsl:include href="objects/topic/topic.xsl" />
    <xsl:include href="../../vanilla/boards/objects/topic/title.xsl" />
    <xsl:include href="objects/topicelement.xsl" />
    <xsl:include href="../../vanilla/boards/objects/topiclist.xsl" />
    
    
    <xsl:include href="../../vanilla/boards/objects/user/detail.xsl" />
    <xsl:include href="../../vanilla/boards/objects/user/inline.xsl" />
    <xsl:include href="../../vanilla/boards/objects/user/linked.xsl" />
    <xsl:include href="../../vanilla/boards/objects/user/listitem.xsl" />
    <xsl:include href="../../vanilla/boards/objects/user/profile.xsl" />
    
</xsl:stylesheet>