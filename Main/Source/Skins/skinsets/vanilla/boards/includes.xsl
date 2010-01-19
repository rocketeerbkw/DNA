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
    <xsl:include href="pages/multiposts-article.xsl" />
    <xsl:include href="pages/multiposts-userpage.xsl" />
    
    <xsl:include href="pages/addthread.xsl" />
    <xsl:include href="pages/blogsummary.xsl" />
    <xsl:include href="pages/category.xsl" />
    <xsl:include href="pages/commentbox.xsl" />
    <xsl:include href="pages/error.xsl" />
    <xsl:include href="pages/frontpage.xsl" />
    <xsl:include href="pages/inspect-user.xsl" />
    <xsl:include href="pages/logout.xsl" />
	<xsl:include href="pages/moderation.xsl" />
    <xsl:include href="pages/moreposts.xsl" />
    <xsl:include href="pages/morecomments.xsl" />
    <xsl:include href="pages/movethread.xsl" />
    <xsl:include href="pages/notfound.xsl" />
	<xsl:include href="pages/servertoobusy.xsl"/>
    <xsl:include href="pages/threads.xsl" />
    <xsl:include href="pages/userdetails.xsl" />
    <xsl:include href="pages/userpage.xsl" />
    
    <!--
    <xsl:include href="../../vanilla/comments/pages/user-complaint.xsl" />
    -->
    
    <xsl:include href="pages/uitemplatedefinition.xsl" />
    
    <!--   ====== ======================================================= Inputs  ===                      -->
    
    <xsl:include href="inputs/postthreadform.xsl" />
	<xsl:include href="inputs/moderated.xsl" />
    <xsl:include href="inputs/inspect-user-form.xsl" />
    <!--
    <xsl:include href="../../vanilla/comments/inputs/user-complaint-form.xsl" />
    -->
    <xsl:include href="inputs/move-thread-form.xsl"/>
    <xsl:include href="inputs/user-details-form.xsl" />
    <xsl:include href="inputs/commentbox.xsl" />
    
    <!--   ============================================================= Objects ===                      -->
    <xsl:include href="objects/post/first.xsl" />
    <xsl:include href="objects/post/generic.xsl" />
    <xsl:include href="objects/post/comment.xsl" />
    <xsl:include href="objects/post/recentcomments.xsl" />
    
    <xsl:include href="objects/article/generic.xsl" />
    <xsl:include href="objects/article/incomplete.xsl" />
    <xsl:include href="objects/article/title.xsl" />
    
	<xsl:include href="objects/about.xsl" />
    <xsl:include href="objects/ancestry.xsl" />
    <xsl:include href="objects/comments-list.xsl" />
    <xsl:include href="objects/commentforumlist.xsl" />
    <xsl:include href="objects/forumthreads.xsl" />
    <xsl:include href="objects/forumthreadposts.xsl" />
    <xsl:include href="objects/group.xsl" />
    <xsl:include href="objects/groups-list.xsl" />
    <xsl:include href="objects/members.xsl" />
    <xsl:include href="objects/post-list.xsl" />
    <xsl:include href="objects/promo.xsl" />
    <xsl:include href="objects/recentcomments.xsl" />
	<xsl:include href="objects/textbox.xsl" />
    <xsl:include href="objects/watchinguserlist.xsl" />
    
    
    <xsl:include href="objects/commentforum/commentforum.xsl" />
    <xsl:include href="objects/commentforum/blogsummary.xsl" />
    
    <xsl:include href="objects/error/error.xsl" />
    <xsl:include href="objects/error/errormessage.xsl" />
    <xsl:include href="objects/error/extrainfo.xsl" />
    
    
    <xsl:include href="objects/member/article.xsl" />
    <xsl:include href="objects/member/subject.xsl" />
    
    <xsl:include href="objects/top-fives/top-fives.xsl" />
    <xsl:include href="objects/top-fives/top-five.xsl" />
    <xsl:include href="objects/top-fives/top-five-article.xsl" />
    <xsl:include href="objects/top-fives/top-five-forum.xsl" />
    
    <xsl:include href="objects/ancestor.xsl" />
    <xsl:include href="objects/comment.xsl" />
    <xsl:include href="objects/thread.xsl" />
    
    <xsl:include href="objects/topic/topic.xsl" />
    <xsl:include href="objects/topic/title.xsl" />
    <xsl:include href="objects/topicelement.xsl" />
    <xsl:include href="objects/topiclist.xsl" />
    
    
    <xsl:include href="objects/user/detail.xsl" />
    <xsl:include href="objects/user/inline.xsl" />
    <xsl:include href="objects/user/linked.xsl" />
    <xsl:include href="objects/user/listitem.xsl" />
    <xsl:include href="objects/user/profile.xsl" />
    
</xsl:stylesheet>