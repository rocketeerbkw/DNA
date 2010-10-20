<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">

    <doc:documentation>
        <doc:purpose>
            Master include file to pull in all the skin wide XSL
        </doc:purpose>
        <doc:context>
            Usually called by a skins own required/required.xsl
        </doc:context>
        <doc:notes>
            Will expand further as more pages and layouts are
            created.
            
            Comment line dividers are a bit garish, any other
            page seperation techniques that could be
            implemented?
        </doc:notes>
    </doc:documentation>
  
<!--
<doc:documentation>
<doc:purpose></doc:purpose>
<doc:context></doc:context>
<doc:notes></doc:notes>
</doc:documentation>
-->  
    
    
    <xsl:include href="_library/variables.xsl" />
<!-- ==================================================================================== Library === -->
    <xsl:include href="_library/exslt/stringToXml.xsl" />

    <xsl:include href="_library/GuideML/GuideML.xsl" />

    <xsl:include href="_library/GuideML/a.xsl" />
	<xsl:include href="_library/GuideML/blockquote.xsl" />
	<xsl:include href="_library/GuideML/br.xsl" />
	<xsl:include href="_library/GuideML/center.xsl" />
	<xsl:include href="_library/GuideML/code.xsl" />
	<xsl:include href="_library/GuideML/columns.xsl" />
	<xsl:include href="_library/GuideML/footnote.xsl"/>
	<xsl:include href="_library/GuideML/header.xsl" />
    <xsl:include href="_library/GuideML/h4.xsl" />
    <xsl:include href="_library/GuideML/h3.xsl" />
	<xsl:include href="_library/GuideML/hr.xsl" />
	<xsl:include href="_library/GuideML/i.xsl" />
	<xsl:include href="_library/GuideML/img.xsl" />
	<xsl:include href="_library/GuideML/li.xsl" />
	<xsl:include href="_library/GuideML/link.xsl" />
	<xsl:include href="_library/GuideML/ol.xsl" />
    <xsl:include href="_library/GuideML/p.xsl" />
	<xsl:include href="_library/GuideML/picture.xsl" />
	<xsl:include href="_library/GuideML/pre.xsl" />
	<xsl:include href="_library/GuideML/quote.xsl" />
	<xsl:include href="_library/GuideML/smiley.xsl" />
	<xsl:include href="_library/GuideML/small.xsl" />
	<xsl:include href="_library/GuideML/span.xsl" />
    <xsl:include href="_library/GuideML/strong.xsl" />
	<xsl:include href="_library/GuideML/subheader.xsl" />
	<xsl:include href="_library/GuideML/table.xsl" />
	<xsl:include href="_library/GuideML/td.xsl" />
	<xsl:include href="_library/GuideML/textelement.xsl" />
	<xsl:include href="_library/GuideML/tr.xsl" />
	<xsl:include href="_library/GuideML/ul.xsl" />

	<!-- 
    <xsl:include href="_library/Sumer/Sumer.xsl" />
    <xsl:include href="_library/Sumer/smiley.xsl" />
    <xsl:include href="_library/Sumer/p.xsl" />
    <xsl:include href="_library/Sumer/strong.xsl" />
     -->

    <xsl:include href="_library/Richtext/Richtext.xsl" />
    <xsl:include href="_library/Richtext/strong.xsl" />
    <xsl:include href="_library/Richtext/textelement.xsl" />
    <xsl:include href="_library/Richtext/a.xsl" />
    <xsl:include href="_library/Richtext/br.xsl" />
    <xsl:include href="_library/Richtext/blockquote.xsl" />
    <xsl:include href="_library/Richtext/em.xsl" />
    <xsl:include href="_library/Richtext/li.xsl" />
    <xsl:include href="_library/Richtext/link.xsl" />
    <xsl:include href="_library/Richtext/p.xsl" />
    <xsl:include href="_library/Richtext/pre.xsl" />
    <xsl:include href="_library/Richtext/q.xsl" />
    <xsl:include href="_library/Richtext/ul.xsl" />
    <!-- 
     -->
    

    <xsl:include href="_library/header/header.xsl" />

    <xsl:include href="_library/itemdetail/itemdetail.xsl" />
    <xsl:include href="_library/itemdetail/date.xsl" />
    <xsl:include href="_library/itemdetail/datecreated.xsl" />
    <xsl:include href="_library/itemdetail/dateposted.xsl" />
    <xsl:include href="_library/itemdetail/index.xsl" />
    <xsl:include href="_library/itemdetail/lastupdated.xsl" />
    <xsl:include href="_library/itemdetail/user.xsl" />


    <xsl:include href="_library/user/linked.xsl" />
    <xsl:include href="_library/user/morecomments.xsl" />
    <xsl:include href="_library/user/notables.xsl" />

    <xsl:include href="_library/date/longformat.xsl" />
    <xsl:include href="_library/date/shortformat.xsl" />
    <xsl:include href="_library/date/daysingle.xsl" />
    <xsl:include href="_library/date/daysuffix.xsl" />
    <xsl:include href="_library/date/converttobst.xsl" />
    <xsl:include href="_library/date/yyyymmdd.xsl" />

    <xsl:include href="_library/json/json.xsl" />
    <xsl:include href="_library/siteoptions/get.xsl" />


    <xsl:include href="_library/moderation/moderationstatus.xsl" />

    <xsl:include href="_library/time/shortformat.xsl" />
    <xsl:include href="_library/time/12hour.xsl" />
    <xsl:include href="_library/time/ampm.xsl" />

    <xsl:include href="_library/listitem/stripe.xsl" />

    <xsl:include href="_library/pagination/commentbox.xsl" />
    <xsl:include href="_library/pagination/comments-list.xsl" />
    <xsl:include href="_library/pagination/commentforumlist.xsl" />
    <xsl:include href="_library/pagination/forumthreads.xsl" />
    <xsl:include href="_library/pagination/forumthreadposts.xsl" />
    <xsl:include href="_library/pagination/post-list.xsl" />


    <xsl:include href="_library/sso/loginurl.xsl" />
    <xsl:include href="_library/sso/logouturl.xsl" />
    <xsl:include href="_library/sso/policyurl.xsl" />
    <xsl:include href="_library/sso/settingsurl.xsl" />
    <xsl:include href="_library/sso/registerurl.xsl" />

    <xsl:include href="_library/identity/loginurl.xsl" />
    <xsl:include href="_library/identity/logouturl.xsl" />
    <xsl:include href="_library/identity/policyurl.xsl" />
    <xsl:include href="_library/identity/ptrt.xsl" />
    <xsl:include href="_library/identity/settingsurl.xsl" />
    <xsl:include href="_library/identity/registerurl.xsl" />
    <xsl:include href="_library/identity/cta.xsl" />

    <xsl:include href="_library/memberservice/loginurl.xsl" />
    <xsl:include href="_library/memberservice/logouturl.xsl" />
    <xsl:include href="_library/memberservice/policyurl.xsl" />
    <xsl:include href="_library/memberservice/ptrt.xsl" />
    <xsl:include href="_library/memberservice/require.xsl" />
    <xsl:include href="_library/memberservice/registerurl.xsl" />
    <xsl:include href="_library/memberservice/settingsurl.xsl" />
    <xsl:include href="_library/memberservice/status.xsl" />

    <xsl:include href="_library/serialise/ptrt.xsl" />

    <xsl:include href="_library/ssi/escaped.xsl" />
    <xsl:include href="_library/ssi/ssi.xsl" />
    <xsl:include href="_library/ssi/var.xsl" />

    
    <xsl:include href="_library/siteconfig/forumclosedmessage.xsl" />
    <xsl:include href="_library/siteconfig/boardclosed.xsl" />
    <xsl:include href="_library/siteconfig/inline.xsl" />
    <xsl:include href="_library/siteconfig/loggedinwelcome.xsl" />
    <xsl:include href="_library/siteconfig/notloggedinwelcome.xsl" />
    <xsl:include href="_library/siteconfig/unauthorisedwelcome.xsl" />
    <xsl:include href="_library/siteconfig/postmodlabel.xsl" />
    <xsl:include href="_library/siteconfig/premodlabel.xsl" />
    <xsl:include href="_library/siteconfig/premodmessage.xsl" />
    <xsl:include href="_library/siteconfig/unmodlabel.xsl" />
    <xsl:include href="_library/siteconfig/morecommentslabel.xsl" />
    <xsl:include href="_library/siteconfig/morepostslabel.xsl" />

	      <xsl:include href="_library/site/link.xsl" />

	      <xsl:include href="_library/socialbookmarks/boards.xsl" />

    <xsl:include href="_library/string/escapeapostrophe.xsl" />
    <xsl:include href="_library/string/searchandreplace.xsl" />
	      <xsl:include href="_library/string/stringtolower.xsl" />
	      <xsl:include href="_library/string/urlencode.xsl" />

    <xsl:include href="_library/userstate/userstate.xsl" />
    <xsl:include href="_library/userstate/editor.xsl" />
    <xsl:include href="_library/userstate/superuser.xsl" />
    
<!-- ================================================================================= Moderation === -->

    <xsl:include href="_moderation/cta/closethread.xsl" />
    <xsl:include href="_moderation/cta/editpost.xsl" />
    <xsl:include href="_moderation/cta/moderationhistory.xsl" />
    <xsl:include href="_moderation/cta/moderationstatus.xsl" />
    <xsl:include href="_moderation/cta/movethread.xsl" />
    <xsl:include href="_moderation/cta/inspectuser.xsl" />
    <xsl:include href="_moderation/cta/moderateuser.xsl" />
    <xsl:include href="_moderation/cta/viewalluserposts.xsl" />
    <xsl:include href="_moderation/cta/makethreadsticky.xsl" />
    <xsl:include href="_moderation/cta/removethreadsticky.xsl" />

    <xsl:include href="_moderation/cta/boardsadmin/editpost.xsl" />
    <xsl:include href="_moderation/cta/boardsadmin/moderationhistory.xsl" />


<!-- ====================================================================================== Logic === -->
<!--   =============================================================== Pages ===                      -->
    <xsl:include href="_logic/_pages/multiposts.xsl" />

<!--   ============================================================= Objects ===                      -->
    <xsl:include href="_logic/_objects/post.xsl" />
    <xsl:include href="_logic/_objects/article.xsl" />
    <xsl:include href="_logic/_objects/articlesearch.xsl" />


<!-- ================================================================================== Structure === -->
    <xsl:include href="_library/head/css.xsl"/>
    <xsl:include href="_library/head/javascript.xsl"/>

    <xsl:include href="_library/head/title.xsl"/>
    <xsl:include href="_library/head/additional.xsl"/>

    <xsl:include href="_library/head/messageboardlayout.xsl"/>

<!-- =============================================================================== Intergration === -->


<!-- ====================================================================================== Pages === -->
    <xsl:include href="_pages/sitedoesnotexist.xsl"/>
	<!-- below has been moved to boards - new seperate servertoobusy.xsl is needed for comments -->
    <!--<xsl:include href="_pages/servertoobusy.xsl"/>-->
    
    
</xsl:stylesheet>