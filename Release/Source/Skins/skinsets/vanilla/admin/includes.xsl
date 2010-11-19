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
    <xsl:variable name="configuration" select="msxsl:node-set($skin)/configuration" />
    
   	<!-- common and configuration -->
    <xsl:include href="../configuration.xsl"/>
    <xsl:include href="../../../common/configuration.xsl"/>
  	<xsl:include href="../../../common/2/includes.xsl" />

	<!-- objects -->
	<xsl:include href="objects/user/welcome.xsl"/>
	
	<xsl:include href="objects/activitydata/activitydata.xsl"/>
	<xsl:include href="objects/activitydata/notes.xsl"/>
	<xsl:include href="objects/activitydata/post.xsl"/>
	<xsl:include href="objects/activitydata/site.xsl"/>
	<xsl:include href="objects/activitydata/typeicon.xsl"/>
	<xsl:include href="objects/activitydata/typelist.xsl"/>	
	<xsl:include href="objects/activitydata/user.xsl"/>
		
	<xsl:include href="objects/links/admin.xsl"/>
	<xsl:include href="objects/links/breadcrumb.xsl"/>
	<xsl:include href="objects/links/tabs.xsl"/>
	<xsl:include href="objects/links/timeframe.xsl"/>
	<xsl:include href="objects/links/usermanagement.xsl"/>
	<xsl:include href="objects/links/useful.xsl"/>
	
	<xsl:include href="objects/moderator/actionitemtotal.xsl"/>
	<xsl:include href="objects/moderator/queued.xsl"/>
	<xsl:include href="objects/moderator/queuedreffered.xsl"/>
	<xsl:include href="objects/moderator/queuesummary.xsl"/>
	<xsl:include href="objects/moderator/siteevent.xsl"/>
	<xsl:include href="objects/moderator/sites.xsl"/>
	<xsl:include href="objects/moderator/sitesummarystats.xsl"/>
  
	<xsl:include href="objects/moderator/siteevent.xsl"/>
	<xsl:include href="objects/activitydata/activitydata.xsl"/>
	<xsl:include href="objects/activitydata/site.xsl"/>
	<xsl:include href="objects/activitydata/user.xsl"/>
	<xsl:include href="objects/activitydata/post.xsl"/>
	<xsl:include href="objects/activitydata/notes.xsl"/>
	<xsl:include href="objects/activitydata/typeicon.xsl"/>
	<xsl:include href="objects/activitydata/typelist.xsl"/>
	<xsl:include href="objects/contributions/contribution.xsl"/>

	<xsl:include href="objects/stripe.xsl"/>
	<xsl:include href="objects/title.xsl"/>
	<xsl:include href="objects/topiclist.xsl"/>	
	
	<!-- pages -->
	<xsl:include href="pages/commentforumlist.xsl"/>
	<xsl:include href="pages/error.xsl"/>
	<xsl:include href="pages/hostdashboard.xsl"/>
 	<xsl:include href="pages/usercontributions.xsl"/>
  	<xsl:include href="pages/hostdashboardactivity.xsl"/>
	<xsl:include href="pages/lightboxes.xsl"/>
	<xsl:include href="pages/memberdetails.xsl"/>
	<xsl:include href="pages/messageboardadmin.xsl"/>
	<xsl:include href="pages/messageboardadmin_assets.xsl"/>
	<xsl:include href="pages/messageboardadmin_design.xsl"/>
	<xsl:include href="pages/messageboardschedule.xsl"/>
	<xsl:include href="pages/mbbackuprestore.xsl"/>
	<xsl:include href="pages/topicbuilder.xsl"/>
	<xsl:include href="pages/userlist.xsl"/>
  
</xsl:stylesheet>
