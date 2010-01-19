<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<xsl:attribute-set name="maHIDDEN_r_complainap"/>
	<xsl:variable name="num_articleposts" select="/H2G2/ARTICLEFORUM/FORUMTHREADPOSTS/@SKIPTO + count(/H2G2/ARTICLEFORUM/FORUMTHREADPOSTS/POST)"/>
	<xsl:variable name="change_poll">change your rating</xsl:variable>
	<xsl:attribute-set name="mUSER-VOTE_r_changevote"/>
	<!--
	<xsl:template name="ARTICLE_HEADER">
	Author:		Andy Harris
	Context:      /H2G2
	Purpose:	 Creates the title for the page which sits in the html header
	-->
	<xsl:template name="ARTICLE_HEADER">
		<xsl:apply-templates mode="header" select=".">
			<xsl:with-param name="title">
				<xsl:value-of select="$m_pagetitlestart"/>
				<xsl:if test="ARTICLE/ARTICLEINFO/H2G2ID">
					<xsl:text> - A</xsl:text>
					<xsl:value-of select="ARTICLE/ARTICLEINFO/H2G2ID"/>
				</xsl:if>
				<xsl:text> - </xsl:text>
				<xsl:choose>
					<xsl:when test="ARTICLE/ARTICLEINFO[HIDDEN='1']">
						<xsl:copy-of select="$m_articlehiddentitle"/>
					</xsl:when>
					<xsl:when test="ARTICLE/ARTICLEINFO[HIDDEN='2']">
						<xsl:copy-of select="$m_articlereferredtitle"/>
					</xsl:when>
					<xsl:when test="ARTICLE/ARTICLEINFO[HIDDEN='3']">
						<xsl:copy-of select="$m_articleawaitingpremoderationtitle"/>
					</xsl:when>
					<xsl:when test="ARTICLE/ARTICLEINFO[HIDDEN='4']">
						<xsl:copy-of select="$m_legacyarticleawaitingmoderationtitle"/>
					</xsl:when>
					<xsl:when test="/H2G2/ARTICLE/ARTICLEINFO/STATUS[@TYPE='7']">
						<xsl:copy-of select="$m_articledeletedtitle"/>
					</xsl:when>
					<xsl:when test="not(/H2G2/ARTICLE/SUBJECT)">
						<xsl:copy-of select="$m_nosuchguideentry"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="ARTICLE/SUBJECT"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>
	<!--
	<xsl:template name="ARTICLE_SUBJECT">
	Author:		Tom Whitehouse
	Context:      /H2G2
	Purpose:	 Creates the text for the subject
	-->
	<xsl:template name="ARTICLE_SUBJECT">
		<xsl:choose>
			<xsl:when test="ARTICLE/ARTICLEINFO[HIDDEN='1']">
				<xsl:value-of select="$m_articlehiddentitle"/>
			</xsl:when>
			<xsl:when test="ARTICLE/ARTICLEINFO[HIDDEN='2']">
				<xsl:value-of select="$m_articlereferredtitle"/>
			</xsl:when>
			<xsl:when test="ARTICLE/ARTICLEINFO[HIDDEN='3']">
				<xsl:value-of select="$m_articleawaitingpremoderationtitle"/>
			</xsl:when>
			<xsl:when test="ARTICLE/ARTICLEINFO[HIDDEN='4']">
				<xsl:value-of select="$m_legacyarticleawaitingmoderationtitle"/>
			</xsl:when>
			<xsl:when test="/H2G2/ARTICLE/ARTICLEINFO/STATUS[@TYPE='7']">
				<xsl:value-of select="$m_articledeletedsubject"/>
			</xsl:when>
			<xsl:when test="not(/H2G2/ARTICLE/SUBJECT)">
				<xsl:copy-of select="$m_nosuchguideentry"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="ARTICLE/SUBJECT"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:variable name="m_articlelinkclipped">This article has been added to your clippings</xsl:variable>
	<xsl:variable name="m_articlealreadyclipped">You have already added this article to your clippings</xsl:variable>
	<xsl:template match="CLIP" mode="c_articleclipped">
		<xsl:apply-templates select="." mode="r_articleclipped"/>
	</xsl:template>
	<xsl:template match="CLIP" mode="r_articleclipped">
		<xsl:choose>
			<xsl:when test="@RESULT='success'">
				<xsl:copy-of select="$m_articlelinkclipped"/>
			</xsl:when>
			<xsl:when test="@RESULT='alreadylinked'">
				<xsl:copy-of select="$m_articlealreadyclipped"/>
			</xsl:when>
			<xsl:when test="@RESULT='alreadylinkedhidden'">
				<xsl:copy-of select="$m_articlealreadyclipped"/>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="ARTICLE-MODERATION-FORM" mode="c_skiptomod">
	Author:		Tom Whitehouse
	Context:      /H2G2/ARTICLE-MODERATION-FORM
	Purpose:	 Checks the state of @REFERRALS and calls the skip to moderation link container
	-->
	<xsl:template match="ARTICLE-MODERATION-FORM" mode="c_skiptomod">
		<xsl:if test="@REFERRALS=1">
			<xsl:apply-templates select="." mode="r_skiptomod"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="ARTICLE-MODERATION-FORM" mode="r_skiptomod">
	Author:		Tom Whitehouse
	Context:      /H2G2/ARTICLE-MODERATION-FORM
	Purpose:	 Creates the skip to moderation link container
	-->
	<xsl:template match="ARTICLE-MODERATION-FORM" mode="r_skiptomod">
		<a href="#moderatesection">
			<xsl:value-of select="$m_jumptomoderate"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="ARTICLE" mode="c_articlepage">
	Author:		Tom Whitehouse
	Context:      /H2G2/ARTICLE
	Purpose:	 Chooses the correct HIDDEN text if the article is hidden or calls the ARTICLE container
	-->
	<xsl:template match="ARTICLE" mode="c_articlepage">
		<xsl:choose>
			<xsl:when test="ARTICLEINFO[HIDDEN='1']">
				<xsl:call-template name="m_articlehiddentext"/>
			</xsl:when>
			<xsl:when test="ARTICLEINFO[HIDDEN='2']">
				<xsl:call-template name="m_articlereferredtext"/>
			</xsl:when>
			<xsl:when test="ARTICLEINFO[HIDDEN='3']">
				<xsl:call-template name="m_articleawaitingpremoderationtext"/>
			</xsl:when>
			<xsl:when test="ARTICLEINFO[HIDDEN='4']">
				<xsl:call-template name="m_legacyarticleawaitingmoderationtext"/>
			</xsl:when>
			<xsl:when test="ARTICLEINFO/STATUS[@TYPE='7']">
				<xsl:call-template name="m_articledeletedbody"/>
			</xsl:when>
			<xsl:when test="GUIDE/BODY/NOENTRYYET">
				<xsl:apply-templates select="." mode="noentryyet_articlepage"/>
			</xsl:when>
			<xsl:otherwise>
				<!--
				<xsl:for-each select=".//SECTION">
					<a href="#section{position()}"><xsl:value-of select="position()"/>: <xsl:apply-templates/></a><br/>
				</xsl:for-each>
			-->
				<xsl:apply-templates select="." mode="r_articlepage"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	
	<!--
	<xsl:template match="ARTICLE" mode="c_displaymediaasset">
	Author:		Tom Whitehouse
	Context:      /H2G2/MEDIAASSETINFO
	Purpose:	 Displays media asset in article
	-->
	<xsl:template match="MEDIAASSET" mode="c_displaymediaasset">
	<xsl:choose>
		<xsl:when test="/H2G2/MEDIAASSETINFO/MEDIAASSET/CONTENTTYPE=1">
			<xsl:apply-templates select="." mode="image_displaymediaasset"/>
		</xsl:when>
		<xsl:when test="/H2G2/MEDIAASSETINFO/MEDIAASSET/CONTENTTYPE=2">
			<xsl:apply-templates select="." mode="audio_displaymediaasset"/>
		</xsl:when>
		<xsl:when test="/H2G2/MEDIAASSETINFO/MEDIAASSET/CONTENTTYPE=3">
			<xsl:apply-templates select="." mode="video_displaymediaasset"/>
		</xsl:when>				
	</xsl:choose>
	</xsl:template>
	
	<xsl:variable name="articlemediasuffix">
		<xsl:call-template name="chooseassetsuffix">
			<xsl:with-param name="mimetype" select="/H2G2/MEDIAASSETINFO/MEDIAASSET/MIMETYPE"></xsl:with-param>
		</xsl:call-template>
	</xsl:variable>
		
	<xsl:template match="MEDIAASSET" mode="image_displaymediaasset">
		<img src="{$articlemediapath}{@MEDIAASSETID}_preview.{$articlemediasuffix}" alt="{/H2G2/ARTICLE/SUBJECT}" xsl:use-attribute-sets="imgMEDIAASSET_image_displaymediaasset" border="0" />	
	</xsl:template>	
	
	<xsl:template match="MEDIAASSET" mode="audio_displaymediaasset">
		<xsl:choose>
			<xsl:when test="$assetuploaded=1">
			<xsl:value-of select="concat($articlemediapath, @MEDIAASSETID, '_preview.', $articlemediasuffix)"/>
			</xsl:when>
			<xsl:otherwise>AUDIO PLACEHOLDER</xsl:otherwise>
		</xsl:choose>
	</xsl:template>		
	
	<xsl:template match="MEDIAASSET" mode="video_displaymediaasset">
		<xsl:choose>
			<xsl:when test="$assetuploaded=1">
			<xsl:value-of select="concat($articlemediapath, @MEDIAASSETID, '_preview.', $articlemediasuffix)"/>
			</xsl:when>
			<xsl:otherwise>VIDEO PLACEHOLDER</xsl:otherwise>
		</xsl:choose>
	</xsl:template>	
	
	<xsl:variable name="assetuploaded" select="WENEEDTHETEST"></xsl:variable>
	
	<xsl:attribute-set name="imgMEDIAASSET_image_displaymediaasset"></xsl:attribute-set>
	<xsl:variable name="articlemediapath" select="concat($assetlibrary, /H2G2/MEDIAASSETINFO/MEDIAASSET/FTPPATH)"/>
		
	<!--
	<xsl:template match="ARTICLE" mode="noentryyet_articlepage">
	Author:		Tom Whitehouse
	Context:      /H2G2
	Purpose:	Template for when a valid H2G2ID hasn't been created yet
	-->
	<xsl:template match="ARTICLE" mode="noentryyet_articlepage">
		<xsl:copy-of select="$m_noentryyet"/>
	</xsl:template>
	<!--
	<xsl:template match="INTRO" mode="c_articlepage">
	Author:		Tom Whitehouse
	Context:      /H2G2/ARTICLE/GUIDE/INTRO
	Purpose:	 Calls the INTRO container if there is one
	-->
	<xsl:template match="INTRO" mode="c_articlepage">
		<xsl:if test="string-length(.) &gt; 0">
			<xsl:apply-templates select="." mode="r_articlepage"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="FOOTNOTE" mode="c_articlefootnote">
	Author:		Tom Whitehouse
	Context:      /H2G2/ARTICLE/GUIDE/GUIDE/BODY/FOOTNOTE
	Purpose:	 Calls the FOOTNOTE container for each FOOTNOTE
	-->
	<xsl:template match="FOOTNOTE" mode="c_articlefootnote">
		<xsl:apply-templates select="." mode="object_articlefootnote"/>
	</xsl:template>
	<!--
	<xsl:template match="FOOTNOTE" mode="object_articlefootnote">
	Author:		Tom Whitehouse
	Context:      /H2G2/ARTICLE/GUIDE/GUIDE/BODY/FOOTNOTE
	Purpose:	 Calls the FOOTNOTE text and link creation for each FOOTNOTE
	-->
	<xsl:template match="FOOTNOTE" mode="object_articlefootnote">
		<a name="footnote{@INDEX}">
			<a href="#back{@INDEX}" xsl:use-attribute-sets="mFOOTNOTE_object_articlefootnote">
				<xsl:apply-templates select="." mode="number_articlefootnote"/>
			</a>
			<xsl:apply-templates select="." mode="text_articlefootnote"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="FOOTNOTE" mode="number_articlefootnote">
	Author:		Tom Whitehouse
	Context:      /H2G2/ARTICLE/GUIDE/GUIDE/BODY/FOOTNOTE
	Purpose:	 Creates the FOOTNOTE number for each FOOTNOTE
	-->
	<xsl:template match="FOOTNOTE" mode="number_articlefootnote">
		<xsl:value-of select="@INDEX"/>
	</xsl:template>
	<!--
	<xsl:template match="FOOTNOTE" mode="text_articlefootnote">
	Author:		Tom Whitehouse
	Context:      /H2G2/ARTICLE/GUIDE/GUIDE/BODY/FOOTNOTE
	Purpose:	 Creates the FOOTNOTE text for each FOOTNOTE
	-->
	<xsl:template match="FOOTNOTE" mode="text_articlefootnote">
		<xsl:apply-templates/>
	</xsl:template>
	<!--
	<xsl:template match="ARTICLE-MODERATION-FORM" mode="c_modform">
	Author:		Tom Whitehouse
	Context:      /H2G2/ARTICLE-MODERATION-FORM
	Purpose:	 Calls the ARTICLE-MODERATION-FORM container
	-->
	<xsl:template match="ARTICLE-MODERATION-FORM" mode="c_modform">
		<xsl:apply-templates select="." mode="r_modform"/>
	</xsl:template>
	<!--
	<xsl:template match="@FORUMID" mode="t_addthread">
	Author:		Tom Whitehouse
	Context:      /H2G2/ARTICLEFORUM/FORUMTHREADS/@FORUMID
	Purpose:	 Creates the 'Discuss this' link
	-->
	<xsl:template match="@FORUMID" mode="t_addthread">
		<xsl:if test="../@CANWRITE = 1">
			<a xsl:use-attribute-sets="maFORUMID_t_addthread">
				<xsl:attribute name="href"><xsl:call-template name="sso_addcomment_signin"/></xsl:attribute>
				<xsl:copy-of select="$alt_discussthis"/>
			</a>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="ARTICLEFORUM" mode="c_article">
	Author:		Tom Whitehouse
	Context:      /H2G2/ARTICLEFORUM
	Purpose:	 Calls the ARTICLEFORUM container
	-->
	<xsl:template match="ARTICLEFORUM" mode="c_article">
		<xsl:apply-templates select="." mode="r_article"/>
	</xsl:template>
	<!--
	<xsl:template match="ARTICLEFORUM" mode="c_article">
	Author:		Tom Whitehouse
	Context:      /H2G2/ARTICLEFORUM/FORUMTHREADS
	Purpose:	 Calls the THREAD container if there is one otherwise chooses the correct empty text/link
	-->
	<xsl:template match="FORUMTHREADS" mode="c_article">
		<xsl:choose>
			<xsl:when test="THREAD">
				<xsl:apply-templates select="." mode="full_article"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:if test="@CANWRITE = 1">
					<xsl:choose>
						<xsl:when test="$registered=1">
							<xsl:apply-templates select="." mode="empty_article"/>
							<!--xsl:apply-templates select="@FORUMID" mode="FirstToTalk"/-->
						</xsl:when>
						<xsl:otherwise>
							<xsl:copy-of select="$m_registertodiscuss"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="FORUMTHREADS" mode="empty_article">
	Author:		Tom Whitehouse
	Context:      /H2G2/ARTICLEFORUM/FORUMTHREADS
	Purpose:	 Creates the 'Be the first to discuss this' link
	-->
	<xsl:template match="FORUMTHREADS" mode="empty_article">
		<a href="{$root}Addthread?forum={@FORUMID}" xsl:use-attribute-sets="maFORUMID_empty_article">
			<xsl:value-of select="$m_firsttotalk"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="THREAD" mode="c_article">
	Author:		Tom Whitehouse
	Context:      /H2G2/ARTICLEFORUM/FORUMTHREADS/THREAD
	Purpose:	 Calls the THREAD container
	-->
	<xsl:template match="THREAD" mode="c_article">
		<xsl:apply-templates select="." mode="r_article"/>
	</xsl:template>
	<!--
	<xsl:template match="ARTICLEFORUM" mode="c_viewallthreads">
	Author:		Tom Whitehouse
	Context:      /H2G2/ARTICLEFORUM
	Purpose:	 Calls the 'View all threads' container if it is necessary
	-->
	<xsl:template match="ARTICLEFORUM" mode="c_viewallthreads">
		<xsl:if test="FORUMTHREADS/@MORE=1">
			<xsl:apply-templates select="." mode="r_viewallthreads"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="ARTICLEFORUM" mode="r_viewallthreads">
	Author:		Tom Whitehouse
	Context:      /H2G2/ARTICLEFORUM
	Purpose:	 Creates the 'View all threads' link
	-->
	<xsl:template match="ARTICLEFORUM" mode="r_viewallthreads">
		<a xsl:use-attribute-sets="mARTICLEFORUM_r_viewallthreads" href="{$root}F{FORUMTHREADS/@FORUMID}">
			<xsl:copy-of select="$m_clickmoreconv"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="@THREADID" mode="t_threadtitlelink">
	Author:		Tom Whitehouse
	Context:      /H2G2/ARTICLEFORUM/FORUMTHREADS/THREAD/@THREADID
	Purpose:	 Creates the thread link
	-->
	<xsl:template match="@THREADID" mode="t_threadtitlelink">
		<a xsl:use-attribute-sets="maTHREADID_t_threadtitlelink" href="{$root}F{../@FORUMID}?thread={.}">
			<xsl:apply-templates select="../SUBJECT" mode="nosubject"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="@THREADID" mode="t_threaddatepostedlink">
	Author:		Tom Whitehouse
	Context:      /H2G2/ARTICLEFORUM/FORUMTHREADS/THREAD/@THREADID
	Purpose:	 Creates the date posted link
	-->
	<xsl:template match="@THREADID" mode="t_threaddatepostedlink">
		<a xsl:use-attribute-sets="maTHREADID_t_threaddatepostedlink" href="{$root}F{../../@FORUMID}?thread={.}&amp;latest=1">
			<xsl:apply-templates select="../DATEPOSTED"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template name="c_unregisteredmessage">
	Author:		Tom Whitehouse
	Context:      /H2G2
	Purpose:	 Calls the unregistered message container
	-->
	<xsl:template match="ARTICLE" mode="c_unregisteredmessage">
		<xsl:if test="$registered=0">
			<xsl:apply-templates select="." mode="r_unregisteredmessage"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="ARTICLEINFO" mode="c_editbutton">
	Author:		Tom Whitehouse
	Context:      /H2G2
	Purpose:	 Calls the 'Edit this' link container
	-->
	<xsl:template match="ARTICLEINFO" mode="c_editbutton">
		<xsl:if test="$test_ShowEditLink">
			<xsl:apply-templates select="." mode="r_editbutton"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="ARTICLE" mode="r_clip">
	Author:		Tom Whitehouse
	Context:      /H2G2
	Purpose:	 Creates the 'save as clippings' link 
	-->
	<xsl:template match="ARTICLE" mode="r_clip">
		<a href="{$root}A{ARTICLEINFO/H2G2ID}?clip=1" xsl:use-attribute-sets="mARTICLE_r_clip">
			<xsl:copy-of select="$m_cliparticle"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="RELATEDMEMBERS" mode="c_relatedmembersAP">
	Author:		Tom Whitehouse
	Context:      /H2G2/ARTICLE/ARTICLEINFO
	Purpose:	 Creates the container for all related members
	-->
	<xsl:template match="RELATEDMEMBERS" mode="c_relatedmembersAP">
		<xsl:if test="RELATEDCLUBS/* or RELATEDARTICLES/ARTICLEMEMBER[H2G2ID != /H2G2/ARTICLE/ARTICLEINFO/H2G2ID]">
			<xsl:apply-templates select="." mode="r_relatedmembersAP"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="RELATEDARTICLES" mode="c_relatedarticlesAP">
	Author:		Tom Whitehouse
	Context:      /H2G2/ARTICLE/ARTICLEINFO/RELATEDMEMBERS
	Purpose:	 Calls the list of related article members logical container
	-->
	<xsl:template match="RELATEDARTICLES" mode="c_relatedarticlesAP">
		<xsl:if test="ARTICLEMEMBER/EXTRAINFO/TYPE/@ID &lt; 1000 and ARTICLEMEMBER[H2G2ID != /H2G2/ARTICLE/ARTICLEINFO/H2G2ID]">
			<xsl:apply-templates select="." mode="r_relatedarticlesAP"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="ARTICLEMEMBER" mode="c_relatedarticlesAP">
	Author:		Tom Whitehouse
	Context:      /H2G2/ARTICLE/ARTICLEINFO/RELATEDMEMBERS/RELATEDARTICLES
	Purpose:	 Calls the container for a single related article member
	-->
	<xsl:template match="ARTICLEMEMBER" mode="c_relatedarticlesAP">
		<xsl:if test="EXTRAINFO/TYPE/@ID &lt; 1000 and H2G2ID != /H2G2/ARTICLE/ARTICLEINFO/H2G2ID">
			<xsl:apply-templates select="." mode="r_relatedarticlesAP"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="ARTICLEMEMBER" mode="r_relatedarticlesAP">
	Author:		Tom Whitehouse
	Context:      /H2G2/ARTICLE/ARTICLEINFO/RELATEDMEMBERS/RELATEDARTICLES
	Purpose:	Creates a single related article as a link
	-->
	<xsl:template match="ARTICLEMEMBER" mode="r_relatedarticlesAP">
		<a href="{$root}A{H2G2ID}" xsl:use-attribute-sets="mARTICLEMEMBER_r_relatedarticlesAP">
			<xsl:value-of select="NAME"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="RELATEDCLUBS" mode="c_relatedclubsAP">
	Author:		Tom Whitehouse
	Context:      /H2G2/ARTICLE/ARTICLEINFO/RELATEDMEMBERS
	Purpose:	Calls the container for the list of related clubs
	-->
	<xsl:template match="RELATEDCLUBS" mode="c_relatedclubsAP">
		<xsl:if test="CLUBMEMBER/EXTRAINFO/TYPE/@ID='1001'">
			<xsl:apply-templates select="." mode="r_relatedclubsAP"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="CLUBMEMBER" mode="c_relatedclubsAP">
	Author:		Tom Whitehouse
	Context:     /H2G2/ARTICLE/ARTICLEINFO/RELATEDMEMBERS/RELATEDCLUBS
	Purpose:	Calls the container for a single related club
	-->
	<xsl:template match="CLUBMEMBER" mode="c_relatedclubsAP">
		<xsl:if test="EXTRAINFO/TYPE/@ID='1001'">
			<xsl:apply-templates select="." mode="r_relatedclubsAP"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="CLUBMEMBER" mode="r_relatedclubsAP">
	Author:		Tom Whitehouse
	Context:     /H2G2/ARTICLE/ARTICLEINFO/RELATEDMEMBERS/RELATEDCLUBS
	Purpose:	 Creates a single related club as a link
	-->
	<xsl:template match="CLUBMEMBER" mode="r_relatedclubsAP">
		<a href="{$root}G{CLUBID}" xsl:use-attribute-sets="mCLUBMEMBER_r_relatedclubsAP">
			<xsl:value-of select="NAME"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="ARTICLEINFO" mode="r_editbutton">
	Author:		Tom Whitehouse
	Context:      /H2G2/ARTICLE or /H2G2/ARTCLE/ARTICLEINFO
	Purpose:	 Creates the 'Edit this' link
	-->
	<xsl:template match="ARTICLEINFO" mode="r_editbutton">
		<a href="{$root}TypedArticle?aedit=new&amp;type=1&amp;h2g2id={H2G2ID}" xsl:use-attribute-sets="mARTICLE_r_editbutton">
			<!--xsl:attribute name="href"><xsl:value-of select="$root"/><xsl:choose><xsl:when test="substring(/H2G2/PAGEUI/EDITPAGE/@LINKHINT,1,1) = '/'"><xsl:value-of select="substring(/H2G2/PAGEUI/EDITPAGE/@LINKHINT,2)"/></xsl:when><xsl:otherwise><xsl:value-of select="/H2G2/PAGEUI/EDITPAGE/@LINKHINT"/></xsl:otherwise></xsl:choose></xsl:attribute-->
			<xsl:copy-of select="$m_editentrylinktext"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="@VISIBLE" mode="c_returntoeditors">
	Author:		Tom Whitehouse
	Context:      /H2G2/PAGEUI/ENTRY-SUBBED/@VISIBLE
	Purpose:	 Calls the 'Entry Subbed' link container
	-->
	<xsl:template match="@VISIBLE" mode="c_returntoeditors">
		<xsl:if test="$test_ShowEntrySubbedLink">
			<xsl:apply-templates select="." mode="r_returntoeditors"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="ENTRY-SUBBED/@VISIBLE" mode="r_returntoeditors">
	Author:		Tom Whitehouse
	Context:      /H2G2/PAGEUI/ENTRY-SUBBED/@VISIBLE
	Purpose:	 Creates the 'Entry Subbed' link
	-->
	<xsl:template match="ENTRY-SUBBED/@VISIBLE" mode="r_returntoeditors">
		<xsl:param name="img" select="$m_ReturnToEditorsLinkText"/>
		<a xsl:use-attribute-sets="maVISIBLE_r_returntoeditors" href="{$root}{../@LINKHINT}">
			<xsl:copy-of select="$img"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="H2G2ID" mode="c_categoriselink">
	Author:		Tom Whitehouse
	Context:      /H2G2/ARTICLE/ARTICLEINFO/H2G2ID
	Purpose:	 Calls the 'Catagorise' link container
	-->
	<xsl:template match="H2G2ID" mode="c_categoriselink">
		<xsl:if test="$test_IsEditor">
			<xsl:apply-templates select="." mode="r_categoriselink"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="H2G2ID" mode="r_categoriselink">
	Author:		Tom Whitehouse
	Context:      /H2G2/ARTICLE/ARTICLEINFO/H2G2ID
	Purpose:	 Creates the 'Catagorise' link
	-->
	<xsl:template match="H2G2ID" mode="r_categoriselink">
		<xsl:param name="img" select="$m_Categorise"/>
		<a xsl:use-attribute-sets="mH2G2ID_r_categoriselink">
			<xsl:attribute name="href"><xsl:value-of select="$root"/>EditCategory?activenode=<xsl:value-of select="."/>&amp;nodeid=0&amp;action=navigatearticle</xsl:attribute>
			<xsl:copy-of select="$img"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="H2G2ID" mode="c_removeself">
	Author:		Tom Whitehouse
	Context:      /H2G2/ARTICLE/ARTICLEINFO/H2G2ID
	Purpose:	 Calls the 'Remove from Researchers' link container
	-->
	<xsl:template match="H2G2ID" mode="c_removeself">
		<xsl:if test="$test_MayRemoveFromResearchers">
			<xsl:apply-templates select="." mode="r_removeself"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="H2G2ID" mode="r_removeself">
	Author:		Tom Whitehouse
	Context:      /H2G2/ARTICLE/ARTICLEINFO/H2G2ID
	Purpose:	 Creates the 'Remove from Researchers' link
	-->
	<xsl:template match="H2G2ID" mode="r_removeself">
		<xsl:param name="img" select="$m_RemoveMeFromResearchersList"/>
		<a xsl:use-attribute-sets="mH2G2ID_r_removeself" onclick="return confirm('{$m_ConfirmRemoveSelf}')" href="{$root}UserEdit{.}?cmd=RemoveSelf">
			<xsl:copy-of select="$img"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="H2G2ID" mode="c_recommendentry">
	Author:		Tom Whitehouse
	Context:      /H2G2/ARTICLE/ARTICLEINFO/H2G2ID
	Purpose:	 Calls the 'Recommend Entry' link container
	-->
	<xsl:template match="H2G2ID" mode="c_recommendentry">
		<xsl:choose>
			<xsl:when test="RECOMMENDENTRY">
				<xsl:if test="not(../HIDDEN) and (/H2G2/VIEWING-USER/USER/GROUPS/SCOUTS or /H2G2/VIEWING-USER/USER/GROUPS/EDITOR)">
					<xsl:apply-templates select="." mode="r_recommendentry"/>
				</xsl:if>
			</xsl:when>
			<xsl:when test="/H2G2/VIEWING-USER/USER/GROUPS/EDITOR and ../STATUS/@TYPE=3">
				<xsl:apply-templates select="." mode="r_recommendentry"/>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="H2G2ID" mode="r_recommendentry">
	Author:		Tom Whitehouse
	Context:      /H2G2/ARTICLE/ARTICLEINFO/H2G2ID
	Purpose:	 Creates the 'Recommend Entry' link
	-->
	<xsl:template match="H2G2ID" mode="r_recommendentry">
		<a xsl:use-attribute-sets="mH2G2ID_r_recommendentry">
			<xsl:attribute name="href">javascript:popupwindow('<xsl:value-of select="$root"/>RecommendEntry?h2g2ID=<xsl:value-of select="."/>&amp;mode=POPUP','RecommendEntry','resizable=1,scrollbars=1,width=375,height=300');</xsl:attribute>
			<xsl:call-template name="m_recommendentrybutton"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="STATUS/@TYPE" mode="c_articlestatus">
	Author:		Tom Whitehouse
	Context:      /H2G2/ARTICLE/ARTICLEINFO/STATUS/@TYPE
	Purpose:	 Calls the status text container if needed
	-->
	<xsl:template match="STATUS/@TYPE" mode="c_articlestatus">
		<xsl:if test=".=1 or .=9 or .=4 or .3">
			<xsl:apply-templates select="." mode="r_articlestatus"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="STATUS/@TYPE" mode="r_articlestatus">
	Author:		Tom Whitehouse
	Context:      /H2G2/ARTICLE/ARTICLEINFO/STATUS/@TYPE
	Purpose:	 Creates the correct status text
	-->
	<xsl:template match="STATUS/@TYPE" mode="r_articlestatus">
		<xsl:choose>
			<xsl:when test=".=1">
				<xsl:copy-of select="$m_edited"/>
			</xsl:when>
			<xsl:when test=".=3">
				<xsl:copy-of select="$m_unedited"/>
			</xsl:when>
			<xsl:when test=".=9">
				<xsl:copy-of select="$m_helppage"/>
			</xsl:when>
			<xsl:when test=".=4">
				<xsl:copy-of select="$m_entrydatarecommendedstatus"/>
			</xsl:when>
			<xsl:otherwise/>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="ARTICLEINFO" mode="c_articlepage">
	Author:		Tom Whitehouse
	Context:      /H2G2/ARTICLE/ARTICLEINFO
	Purpose:	 Calls the ARTICLEINFO container
	-->
	<xsl:template match="ARTICLEINFO" mode="c_articlepage">
		<xsl:apply-templates select="." mode="r_articlepage"/>
	</xsl:template>
	<!--
	<xsl:template match="ARTICLEINFO/SUBMITTABLE" mode="c_submit-to-peer-review">
	Author:		Tom Whitehouse
	Context:      /H2G2/ARTICLE/ARTICLEINFO/SUBMITTABLE
	Purpose:	 Calls the submit for review button container
	-->
	<xsl:template match="ARTICLEINFO/SUBMITTABLE" mode="c_submit-to-peer-review">
		<xsl:if test="not(../HIDDEN) and /H2G2/VIEWING-USER/USER">
			<xsl:apply-templates select="." mode="r_submit-to-peer-review"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="ARTICLEINFO/SUBMITTABLE" mode="r_submit-to-peer-review">
	Author:		Tom Whitehouse
	Context:      /H2G2/ARTICLE/ARTICLEINFO/SUBMITTABLE
	Purpose:	 Creates the correct submit for review button 
	-->
	<xsl:template match="ARTICLEINFO/SUBMITTABLE" mode="r_submit-to-peer-review">
		<xsl:param name="submitbutton">
			<xsl:call-template name="m_submitforreviewbutton"/>
		</xsl:param>
		<xsl:param name="notforreviewbutton">
			<xsl:call-template name="m_notforreviewbutton"/>
		</xsl:param>
		<xsl:param name="currentlyinreviewforum">
			<xsl:call-template name="m_currentlyinreviewforum"/>
		</xsl:param>
		<xsl:param name="reviewforum">
			<xsl:call-template name="m_submittedtoreviewforumbutton"/>
		</xsl:param>
		<!-- If the article is hidden then don't display any of this -->
		<xsl:choose>
			<xsl:when test="@TYPE='YES'">
				<a href="{$root}SubmitReviewForum?action=submitrequest&amp;h2g2id={/H2G2/ARTICLE/ARTICLEINFO/H2G2ID}" xsl:use-attribute-sets="mSUBMITTABLE_r_submit-to-peer-review">
					<xsl:copy-of select="$submitbutton"/>
				</a>
			</xsl:when>
			<xsl:when test="@TYPE='NO'">
				<xsl:choose>
					<!-- Only show the button for editors-->
					<xsl:when test="/H2G2/VIEWING-USER/USER/GROUPS/EDITOR">
						<a href="{$root}SubmitReviewForum?action=submitrequest&amp;h2g2id={/H2G2/ARTICLE/ARTICLEINFO/H2G2ID}" xsl:use-attribute-sets="mSUBMITTABLE_r_submit-to-peer-review">
							<xsl:copy-of select="$submitbutton"/>
						</a>
					</xsl:when>
					<xsl:otherwise>
						<xsl:copy-of select="$notforreviewbutton"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="@TYPE='IN'">
				<xsl:copy-of select="$currentlyinreviewforum"/>
				<a href="{$root}F{FORUM/@ID}?thread={THREAD/@ID}" xsl:use-attribute-sets="mSUBMITTABLE_r_submit-to-peer-review">
					<xsl:copy-of select="$reviewforum"/>
				</a>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="REFERENCES" mode="c_articlerefs">
	Author:		Tom Whitehouse
	Context:      /H2G2/ARTICLE/ARTICLEINFO/REFERENCES
	Purpose:	 Calls the REFERENCES object container
	-->
	<xsl:template match="REFERENCES" mode="c_articlerefs">
		<xsl:if test="./*">
			<xsl:apply-templates select="." mode="r_articlerefs"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="ENTRIES" mode="c_articlerefs">
	Author:		Tom Whitehouse
	Context:      /H2G2/ARTICLE/ARTICLEINFO/REFERENCES/ENTRIES
	Purpose:	 Calls the ENTRIES object container
	-->
	<xsl:template match="ENTRIES" mode="c_articlerefs">
		<xsl:if test="$test_RefHasEntries">
			<xsl:apply-templates select="." mode="r_articlerefs"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="USERS" mode="c_articlerefs">
	Author:		Tom Whitehouse
	Context:      /H2G2/ARTICLE/ARTICLEINFO/REFERENCES/USERS
	Purpose:	 Calls the USERS object container
	-->
	<xsl:template match="USERS" mode="c_articlerefs">
		<xsl:if test="$test_RefHasEntries">
			<xsl:apply-templates select="." mode="r_articlerefs"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="REFERENCES/ENTRIES/ENTRYLINK" mode="c_articlerefs">
	Author:		Tom Whitehouse
	Context:      /H2G2/ARTICLE/ARTICLEINFO/REFERENCES/ENTRIES/ENTRYLINK
	Purpose:	 Calls the ENTRYLINK container
	-->
	<xsl:template match="REFERENCES/ENTRIES/ENTRYLINK" mode="c_articlerefs">
		<xsl:variable name="id" select="@H2G2"/>
		<xsl:if test="(/H2G2/ARTICLE/GUIDE//LINK[@H2G2=$id]) or (/H2G2/ARTICLE/GUIDE//LINK[@DNAID=$id])">
			<xsl:apply-templates select="." mode="r_articlerefs"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="ENTRYLINK" mode="r_articlerefs">
	Author:		Tom Whitehouse
	Context:      /H2G2/ARTICLE/ARTICLEINFO/REFERENCES/ENTRIES/ENTRYLINK
	Purpose:	 Creates the ENTRYLINK link
	-->
	<xsl:template match="ENTRYLINK" mode="r_articlerefs">
		<a href="{$root}A{H2G2ID}" use-attribute-sets="mENTRYLINK_r_articlerefs">
			<xsl:value-of select="SUBJECT"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="REFERENCES/USERS" mode="c_articlerefs">
	Author:		Tom Whitehouse
	Context:      /H2G2/ARTICLE/ARTICLEINFO/REFERENCES/USERS
	Purpose:	 Calls the USERS object container
	-->
	<xsl:template match="REFERENCES/USERS" mode="c_articlerefs">
		<xsl:apply-templates select="." mode="r_articlerefs"/>
	</xsl:template>
	<!--
	<xsl:template match="REFERENCES/USERS/USERLINK" mode="c_articlerefs">
	Author:		Tom Whitehouse
	Context:      /H2G2/ARTICLE/ARTICLEINFO/REFERENCES/USERS/USERLINK
	Purpose:	 Calls the USERLINK object container
	-->
	<xsl:template match="REFERENCES/USERS/USERLINK" mode="c_articlerefs">
		<xsl:variable name="id" select="@H2G2"/>
		<xsl:if test="(/H2G2/ARTICLE/GUIDE//LINK[@H2G2=$id]) or (/H2G2/ARTICLE/GUIDE//LINK[@BIO=$id])">
			<xsl:apply-templates select="." mode="r_articlerefs"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="USERLINK" mode="r_articlerefs">
	Author:		Tom Whitehouse
	Context:      /H2G2/ARTICLE/ARTICLEINFO/REFERENCES/USERS/USERLINK
	Purpose:	 Creates the USERLINK link
	-->
	<xsl:template match="USERLINK" mode="r_articlerefs">
		<a href="{$root}U{USERID}" use-attribute-sets="mUSERLINK_r_articlerefs">
			<xsl:value-of select="USERNAME"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="EXTERNAL" mode="c_articlerefs">
	Author:		Tom Whitehouse
	Context:      /H2G2/ARTICLE/ARTICLEINFO/REFERENCES
	Purpose:	 Calls the EXTERNAL object container for bbc sites
	-->
	<xsl:template match="EXTERNAL" mode="c_bbcrefs">
		<xsl:if test="EXTERNALLINK[starts-with(OFFSITE, 'http://www.bbc.co.uk') or starts-with(OFFSITE, 'http://news.bbc.co.uk')]">
			<xsl:apply-templates select="." mode="r_bbcrefs"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="EXTERNAL" mode="c_articlerefs">
	Author:		Tom Whitehouse
	Context:      /H2G2/ARTICLE/ARTICLEINFO/REFERENCES
	Purpose:	 Calls the EXTERNAL object container for non-bbc sites
	-->
	<xsl:template match="EXTERNAL" mode="c_nonbbcrefs">
		<xsl:if test="EXTERNALLINK[not(starts-with(OFFSITE, 'http://www.bbc.co.uk') or starts-with(OFFSITE, 'http://news.bbc.co.uk'))]">
			<xsl:apply-templates select="." mode="r_nonbbcrefs"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="EXTERNALLINK" mode="c_bbcrefs">
	Author:		Tom Whitehouse
	Context:      /H2G2/ARTICLE/ARTICLEINFO/REFERENCES/EXTERNAL/EXTERNALLINK
	Purpose:	 Calls the EXTERNALLINK (on the bbc website) object container
	-->
	<xsl:template match="EXTERNALLINK" mode="c_bbcrefs">
		<xsl:if test="(/H2G2/ARTICLE/GUIDE//LINK[@UINDEX=current()/@UINDEX]) and starts-with(OFFSITE, 'http://www.bbc.co.uk') or starts-with(OFFSITE, 'http://news.bbc.co.uk')">
			<xsl:apply-templates select="." mode="r_bbcrefs"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="EXTERNALLINK" mode="r_bbcrefs">
	Author:		Tom Whitehouse
	Context:      /H2G2/ARTICLE/ARTICLEINFO/REFERENCES/EXTERNAL/EXTERNALLINK
	Purpose:	 Creates the EXTERNALLINK (on the bbc website) link
	-->
	<xsl:template match="EXTERNALLINK" mode="r_bbcrefs">
		<a xsl:use-attribute-sets="mEXTERNALLINK_r_bbcrefs">
			<xsl:apply-templates select="/H2G2/ARTICLE/GUIDE//LINK[@UINDEX=current()/@UINDEX]" mode="justattributes"/>
			<xsl:value-of select="TITLE"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="EXTERNALLINK" mode="c_nonbbcrefs">
	Author:		Tom Whitehouse
	Context:      /H2G2/ARTICLE/ARTICLEINFO/REFERENCES/EXTERNAL/EXTERNALLINK
	Purpose:	 Calls the EXTERNALLINK object container
	-->
	<xsl:template match="EXTERNALLINK" mode="c_nonbbcrefs">
		<xsl:if test="(/H2G2/ARTICLE/GUIDE//LINK[@UINDEX=current()/@UINDEX]) and not(starts-with(OFFSITE, 'http://www.bbc.co.uk') or starts-with(OFFSITE, 'http://news.bbc.co.uk'))">
			<xsl:apply-templates select="." mode="r_nonbbcrefs"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="EXTERNALLINK" mode="r_articlerefsext">
	Author:		Tom Whitehouse
	Context:      /H2G2/ARTICLE/ARTICLEINFO/REFERENCES/EXTERNAL
	Purpose:	 Creates the EXTERNALLINK link
	-->
	<xsl:template match="EXTERNALLINK" mode="r_nonbbcrefs">
		<a xsl:use-attribute-sets="mEXTERNALLINK_r_nonbbcrefs">
			<xsl:apply-templates select="/H2G2/ARTICLE/GUIDE//LINK[@UINDEX=current()/@UINDEX]" mode="justattributes"/>
			<xsl:value-of select="TITLE"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="ARTICLE" mode="c_subscribearticleforum">
	Author:		Tom Whitehouse
	Context:      /H2G2/ARTICLE
	Purpose:	 Calls the 'Subscribe to the article forum' container
	-->
	<xsl:template match="ARTICLE" mode="c_subscribearticleforum">
		<xsl:if test="$registered=1">
			<xsl:apply-templates select="." mode="r_subscribearticleforum"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="ARTICLE" mode="c_unsubscribearticleforum">
	Author:		Tom Whitehouse
	Context:      /H2G2/ARTICLE
	Purpose:	 Calls the 'Unsubscribe to the article forum' container
	-->
	<xsl:template match="ARTICLE" mode="c_unsubscribearticleforum">
		<xsl:if test="$registered=1">
			<xsl:apply-templates select="." mode="r_unsubscribearticleforum"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="ARTICLE" mode="r_subscribearticleforum">
	Author:		Tom Whitehouse
	Context:      /H2G2/ARTICLE
	Purpose:	 Creates the 'Subscribe to the article forum' link
	-->
	<xsl:template match="ARTICLE" mode="r_subscribearticleforum">
		<xsl:if test="$registered=1">
			<a target="_top" href="{$root}FSB{ARTICLEINFO/FORUMID}?cmd=subscribeforum&amp;page=normal&amp;desc={$alt_subreturntoarticle}&amp;return=A{ARTICLEINFO/H2G2ID}" xsl:use-attribute-sets="mARTICLE_r_subscribearticleforum">
				<xsl:copy-of select="$m_clicknotifynewconv"/>
			</a>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="ARTICLE" mode="r_unsubscribearticleforum">
	Author:		Tom Whitehouse
	Context:      /H2G2/ARTICLE
	Purpose:	 Creates the 'Unsubscribe to the article forum' link
	-->
	<xsl:template match="ARTICLE" mode="r_unsubscribearticleforum">
		<xsl:if test="$registered=1">
			<a target="_top" href="{$root}FSB{ARTICLEINFO/FORUMID}?cmd=unsubscribeforum&amp;page=normal&amp;desc={$alt_subreturntoarticle}&amp;return=A{ARTICLEINFO/H2G2ID}" xsl:use-attribute-sets="mARTICLE_r_unsubscribearticleforum">
				<xsl:copy-of select="$m_clickstopnotifynewconv"/>
			</a>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="PAGEAUTHOR" mode="c_article">
	Author:		Tom Whitehouse
	Context:      /H2G2/ARTICLE/ARTICLEINFO/PAGEAUTHOR
	Purpose:	 Calls the PAGEAUTHOR object container
	-->
	<xsl:template match="PAGEAUTHOR" mode="c_article">
		<xsl:apply-templates select="." mode="r_article"/>
	</xsl:template>
	<!--
	<xsl:template match="RESEARCHERS" mode="c_article">
	Author:		Tom Whitehouse
	Context:      /H2G2/ARTICLE/ARTICLEINFO/PAGEAUTHOR/RESEARCHERS
	Purpose:	 Calls the RESEARCHES object container
	-->
	<xsl:template match="RESEARCHERS" mode="c_article">
		<xsl:if test="$test_HasResearchers">
			<xsl:apply-templates select="." mode="r_article"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="USER" mode="c_researcherlist">
	Author:		Tom Whitehouse
	Context:      /H2G2/ARTICLE/ARTICLEINFO/PAGEAUTHOR/RESEARCHERS/USER
	Purpose:	 Calls the USER object container
	-->
	<xsl:template match="USER" mode="c_researcherlist">
		<xsl:if test="USERID!=../../EDITOR/USER/USERID">
			<xsl:apply-templates select="." mode="r_researcherlist"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="USER" mode="r_researcherlist">
	Author:		Tom Whitehouse
	Context:      /H2G2/ARTICLE/ARTICLEINFO/PAGEAUTHOR/RESEARCHERS/USER
	Purpose:	 Creates the USER link
	-->
	<xsl:template match="USER" mode="r_researcherlist">
		<a xsl:use-attribute-sets="mUSER_r_researcherlist" href="{$root}U{USERID}">
			<xsl:value-of select="USERNAME"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="EDITOR" mode="c_article">
	Author:		Tom Whitehouse
	Context:      /H2G2/ARTICLE/ARTICLEINFO/PAGEAUTHOR/EDITOR
	Purpose:	 Calls the EDITOR object container
	-->
	<xsl:template match="EDITOR" mode="c_article">
		<xsl:apply-templates select="." mode="r_article"/>
	</xsl:template>
	<!--
	<xsl:template match="USER" mode="c_articleeditor">
	Author:		Tom Whitehouse
	Context:      /H2G2/ARTICLE/ARTICLEINFO/PAGEAUTHOR/EDITOR/USER
	Purpose:	 Calls the USER object container
	-->
	<xsl:template match="USER" mode="c_articleeditor">
		<xsl:apply-templates select="." mode="r_articleeditor"/>
	</xsl:template>
	<!--
	<xsl:template match="USER" mode="r_articleeditor">
	Author:		Tom Whitehouse
	Context:      /H2G2/ARTICLE/ARTICLEINFO/PAGEAUTHOR/EDITOR/USER
	Purpose:	 Creates the USER link
	-->
	<xsl:template match="USER" mode="r_articleeditor">
		<a xsl:use-attribute-sets="mUSER_r_articleeditor" href="{$root}U{USERID}">
			<xsl:value-of select="USERNAME"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="INVALIDARTICLE">
	Author:		Tom Whitehouse
	Context:      /H2G2/INVALIDARTICLE
	Purpose:	 Creates the INVALIDARTICLE text
	-->
	<xsl:template match="INVALIDARTICLE">
		<xsl:call-template name="m_entryexists"/>
		<xsl:apply-templates select="SUGGESTEDALTERNATIVES[LINK]"/>
	</xsl:template>
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
							CRUMBTRAILS Object
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<!--
	<xsl:template match="CRUMBTRAILS" mode="c_article">
	Author:		Tom Whitehouse
	Context:      /H2G2/ARTICLE/ARTICLEINFO
	Purpose:	Creates the crumbtrails container
	-->
	<xsl:template match="CRUMBTRAILS" mode="c_article">
		<xsl:apply-templates select="." mode="r_article"/>
	</xsl:template>
	<!--
	<xsl:template match="CRUMBTRAIL" mode="c_article">
	Author:		Tom Whitehouse
	Context:      /H2G2/ARTICLE/ARTICLEINFO/CRUMBTRAILS
	Purpose:	 Creates a single crumbtrail container
	-->
	<xsl:template match="CRUMBTRAIL" mode="c_article">
		<xsl:apply-templates select="." mode="r_article"/>
	</xsl:template>
	<!--
	<xsl:template match="ANCESTOR" mode="c_article">
	Author:		Tom Whitehouse
	Context:     /H2G2/ARTICLE/ARTICLEINFO/CRUMBTRAILS/CRUMBTRAIL
	Purpose:     Creates the container for a single ancestor node
	-->
	<xsl:template match="ANCESTOR" mode="c_article">
		<xsl:apply-templates select="." mode="r_article"/>
	</xsl:template>
	<!--
	<xsl:template match="ANCESTOR" mode="r_article">
	Author:		Tom Whitehouse
	Context:      /H2G2/ARTICLE/ARTICLEINFO/CRUMBTRAILS/CRUMBTRAIL
	Purpose:	Creates the link to a single ancestor node
	-->
	<xsl:template match="ANCESTOR" mode="r_article">
		<a href="{$root}C{NODEID}" xsl:use-attribute-sets="mANCESTOR_r_article">
			<xsl:value-of select="NAME"/>
		</a>
	</xsl:template>
	<!--xsl:template match="ARTICLE" mode="c_categorise">
		<xsl:if test="$ownerisviewer=1 or $test_IsEditor">
			<xsl:apply-templates select="." mode="r_categorise"/>
		</xsl:if>
	</xsl:template-->
	<!--xsl:template match="ARTICLE" mode="r_categorise">
		
			<xsl:choose>
				<xsl:when test="TAGITEM-PAGE/ITEM/@TYPE=1">
					<a href="editcategory?action=navigatearticle&amp;{$commontaginfo}">Add article to athother node</a>
				</xsl:when>
				<xsl:when test="TAGITEM-PAGE/ITEM/@TYPE=1001">
					<a href="editcategory?action=navigateclub&amp;{$commontaginfo}">Add club to athother node</a>
				</xsl:when>
			</xsl:choose>
		
	</xsl:template-->
	<xsl:template match="ARTICLE" mode="c_tag">
		<xsl:if test="$ownerisviewer=1 or $test_IsEditor">
			<xsl:choose>
				<xsl:when test="ARTICLEINFO/CRUMBTRAILS">
					<xsl:apply-templates select="." mode="edit_tag"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="." mode="add_tag"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:template>
	<xsl:template match="ARTICLE" mode="add_tag">
		<a href="{$root}TagItem?tagitemtype=1&amp;tagitemid={ARTICLEINFO/H2G2ID}" xsl:use-attribute-sets="mARTICLE_add_tag">
			<xsl:copy-of select="$m_tagarticle"/>
		</a>
	</xsl:template>
	<xsl:template match="ARTICLE" mode="edit_tag">
		<a href="{$root}TagItem?tagitemtype=1&amp;tagitemid={ARTICLEINFO/H2G2ID}" xsl:use-attribute-sets="mARTICLE_edit_tag">
			<xsl:copy-of select="$m_editarticletags"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="@HIDDEN" mode="c_complainap">
	Author:		Tom Whitehouse
	Context:      
	Purpose:	 Calls the container for the 'complain about this post' link
	-->
	<xsl:template match="@HIDDEN" mode="c_complainap">
		<xsl:if test=".=0">
			<xsl:apply-templates select="." mode="r_complainap"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="@HIDDEN" mode="r_complainmp">
	Author:		Tom Whitehouse
	Context:      
	Purpose:	 Creates the 'complain about this post' link
	-->
	<xsl:template match="@HIDDEN" mode="r_complainap">
		<xsl:param name="attributes"/>
		<xsl:param name="embodiment" select="$alt_complain"/>
		<a href="{$root}comments/UserComplaintPage?PostID={../@POSTID}&amp;s_start=1" target="ComplaintPopup" onClick="popupwindow('comments/UserComplaintPage?PostID={../@POSTID}&amp;s_start=1', 'ComplaintPopup', 'status=1,resizable=1,scrollbars=1,width=640,height=480')" xsl:use-attribute-sets="maHIDDEN_r_complainap">
			<xsl:copy-of select="$embodiment"/>
		</a>
	</xsl:template>
	<xsl:template match="EMAIL-SUBSCRIPTION" mode="c_articlepage">
		<xsl:apply-templates select="." mode="r_articlepage"/>
	</xsl:template>
	<xsl:template match="EMAIL-SUBSCRIPTION" mode="c_articlesub">
		<xsl:apply-templates select="." mode="r_articlesub"/>
	</xsl:template>
	<xsl:template match="EMAIL-SUBSCRIPTION" mode="c_forumsub">
		<xsl:apply-templates select="." mode="r_forumsub"/>
	</xsl:template>
	<xsl:template match="EMAIL-SUBSCRIPTION" mode="c_articlesubstatus">
		<xsl:choose>
			<xsl:when test="SUBSCRIPTION[@ITEMTYPE = 2]">
				<xsl:apply-templates select="." mode="on_articlesubstatus"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="." mode="off_articlesubstatus"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="EMAIL-SUBSCRIPTION" mode="t_articlesubstatus">
		<xsl:choose>
			<xsl:when test="SUBSCRIPTION/@LISTTYPE = 2">Normal </xsl:when>
			<xsl:otherwise> Instant </xsl:otherwise>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="SUBSCRIPTION/@NOTIFYTYPE = 1">Email</xsl:when>
			<xsl:otherwise>Private Message</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="EMAIL-SUBSCRIPTION" mode="t_articlesublink">
		<xsl:choose>
			<xsl:when test="SUBSCRIPTION[@ITEMTYPE = 2]">
				<a href="{$root}EMailAlert?s_manage=1&amp;s_itemtype=2&amp;s_itemid={/H2G2/ARTICLE/ARTICLEINFO/H2G2ID}&amp;s_backto=A{/H2G2/ARTICLE/ARTICLEINFO/H2G2ID}">
					<xsl:copy-of select="$m_articlesubmanagelink"/>
				</a>
			</xsl:when>
			<xsl:otherwise>
				<a href="{$root}EMailAlert?s_manage=2&amp;s_itemtype=2&amp;s_itemid={/H2G2/ARTICLE/ARTICLEINFO/H2G2ID}&amp;s_backto=A{/H2G2/ARTICLE/ARTICLEINFO/H2G2ID}">
					<xsl:copy-of select="$m_articlesublink"/>
				</a>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="EMAIL-SUBSCRIPTION" mode="c_forumsubstatus">
		<xsl:choose>
			<xsl:when test="SUBSCRIPTION[@ITEMTYPE = 4]">
				<xsl:apply-templates select="." mode="on_forumsubstatus"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="." mode="off_forumsubstatus"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="EMAIL-SUBSCRIPTION" mode="t_forumsubstatus">
		<xsl:choose>
			<xsl:when test="SUBSCRIPTION/@LISTTYPE = 2">Normal </xsl:when>
			<xsl:otherwise> Instant </xsl:otherwise>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="SUBSCRIPTION/@NOTIFYTYPE = 1">Email</xsl:when>
			<xsl:otherwise>Private Message</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="EMAIL-SUBSCRIPTION" mode="t_forumsublink">
		<xsl:choose>
			<xsl:when test="SUBSCRIPTION[@ITEMTYPE = 4]">
				<a href="{$root}EMailAlert?s_manage=1&amp;s_itemtype=4&amp;s_itemid={/H2G2/ARTICLE/ARTICLEINFO/FORUMID}&amp;s_backto=A{/H2G2/ARTICLE/ARTICLEINFO/H2G2ID}">
					<xsl:copy-of select="$m_forumsubmanagelink"/>
				</a>
			</xsl:when>
			<xsl:otherwise>
				<a href="{$root}EMailAlert?s_manage=2&amp;s_itemtype=4&amp;s_itemid={/H2G2/ARTICLE/ARTICLEINFO/FORUMID}&amp;s_backto=A{/H2G2/ARTICLE/ARTICLEINFO/H2G2ID}">
					<xsl:copy-of select="$m_forumsublink"/>
				</a>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="POLL-LIST" mode="c_articlepage">
	Author:		Tom Whitehouse
	Context:      /H2G2
	Purpose:	Container for the list of polls object
	-->
	<xsl:template match="POLL-LIST" mode="c_articlepage">
		<xsl:apply-templates select="." mode="r_articlepage"/>
	</xsl:template>
	<!--
	<xsl:template match="POLL-LIST" mode="c_articlepage">
	Author:		Tom Whitehouse
	Context:      /H2G2/POLL-LIST
	Purpose:	Decides whether a poll is hidden, should be displayed as a form or should display its results
	-->
	<xsl:attribute-set name="mPOLL_c_articlepage"/>
	<xsl:template match="POLL" mode="c_articlepage">
		<xsl:choose>
			<xsl:when test="@HIDDEN=1">
				<xsl:apply-templates select="." mode="hidden_articlepage"/>
			</xsl:when>
			<xsl:when test="not(/H2G2/PARAMS/PARAM[NAME='s_show']/VALUE='vote') and (USER-VOTE or /H2G2/VIEWING-USER/USER/USERID =  /H2G2/ARTICLE/ARTICLEINFO/PAGEAUTHOR/EDITOR/USER/USERID)">
				<xsl:apply-templates select="." mode="results_articlepage"/>
			</xsl:when>
			<xsl:when test="not(/H2G2/VIEWING-USER/USER)">
				<form action="{$root}poll" method="post" xsl:use-attribute-sets="mPOLL_c_articlepage">
					<input type="hidden" name="pollid" value="{@POLLID}"/>
					<input type="hidden" name="s_redirectto" value="A{/H2G2/ARTICLE/ARTICLEINFO/H2G2ID}"/>
					<input type="hidden" name="cmd" value="vote"/>
					<xsl:apply-templates select="." mode="signedout_articlepage"/>
				</form>
			</xsl:when>
			<xsl:otherwise>
				<form action="{$root}poll" method="post" xsl:use-attribute-sets="mPOLL_c_articlepage">
					<input type="hidden" name="pollid" value="{@POLLID}"/>
					<input type="hidden" name="s_redirectto" value="A{/H2G2/ARTICLE/ARTICLEINFO/H2G2ID}"/>
					<input type="hidden" name="cmd" value="vote"/>
					<xsl:apply-templates select="." mode="form_articlepage"/>
				</form>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="POLL" mode="t_submitcontentrating">
	Author:		Tom Whitehouse
	Context:      /H2G2/POLL-LIST
	Purpose:	Submit button for content rating
	-->
	
	<xsl:template match="POLL" mode="t_submitcontentrating">
		<input xsl:use-attribute-sets="iPOLL_t_submitcontentrating"/>
	</xsl:template>
	<!--
	<xsl:attribute-set name="iPOLL_t_submitcontentrating">
	Author:		Tom Whitehouse
	Purpose:	Att set for content rating submit button
	-->
	<xsl:attribute-set name="iPOLL_t_submitcontentrating">
		<xsl:attribute name="type">submit</xsl:attribute>
		<xsl:attribute name="value">Vote</xsl:attribute>
	</xsl:attribute-set>
	
	<!--
	<xsl:template match="POLL" mode="c_hide">
	Author:		Tom Whitehouse
	Context:      /H2G2/POLL-LIST
	Purpose:	Only editors are allowed to hide polls
	-->
	<xsl:template match="POLL" mode="c_hide">
		<xsl:if test="$test_IsEditor">
			<form action="{$root}poll" method="post">
				<input type="hidden" name="pollid" value="{@POLLID}"/>
				<input type="hidden" name="s_redirectto" value="A{/H2G2/ARTICLE/ARTICLEINFO/H2G2ID}"/>
				

				<xsl:apply-templates select="." mode="r_hide"/>
			</form>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="POLL" mode="t_hidepollradio">
	Author:		Tom Whitehouse
	Context:      /H2G2/POLL-LIST
	Purpose:	Hiding a poll radio button
	-->
	
	<xsl:template match="POLL" mode="t_hidepollradio">
		<input type="radio" name="cmd" value="hidepoll" xsl:use-attribute-sets="iPOLL_t_hidepollradio">
			<xsl:if test="@HIDDEN=1">
				<xsl:attribute name="checked">checked</xsl:attribute>
			</xsl:if>
		</input>
	</xsl:template>
	<xsl:attribute-set name="iPOLL_t_hidepollradio">
		<xsl:attribute name="type">radio</xsl:attribute>
	</xsl:attribute-set>
	<!--
	<xsl:template match="POLL" mode="t_hidepollradio">
	Author:		Tom Whitehouse
	Context:      /H2G2/POLL-LIST
	Purpose:	Unhide a poll radio button
	-->
	<xsl:template match="POLL" mode="t_unhidepollradio">
		<input type="radio" name="cmd" value="unhidepoll" xsl:use-attribute-sets="iPOLL_t_unhidepollradio">
			<xsl:if test="@HIDDEN=0">
				<xsl:attribute name="checked">checked</xsl:attribute>
			</xsl:if>
		</input>
	</xsl:template>
	<xsl:attribute-set name="iPOLL_t_unhidepollradio">
		<xsl:attribute name="type">radio</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="iPOLL_t_submithidepoll">
		<xsl:attribute name="type">submit</xsl:attribute>
		<xsl:attribute name="value">submit</xsl:attribute>
	</xsl:attribute-set>
	<xsl:template match="POLL" mode="t_submithidepoll">
		<input xsl:use-attribute-sets="iPOLL_t_submithidepoll"/>
	</xsl:template>
	<!--
	<xsl:template match="USER-VOTE" mode="c_display">
	Author:		Tom Whitehouse
	Context:      /H2G2/POLL-LIST/POLL
	Purpose:	Creates the 'You voted for ....' object
	-->
	<xsl:template match="USER-VOTE" mode="c_display">
		<xsl:apply-templates select="." mode="r_display"/>
	</xsl:template>
	<!--
	<xsl:template match="ERROR" mode="c_articlepoll">
	Author:		Tom Whitehouse
	Context:      /H2G2/POLL-LIST/POLL
	Purpose:	Creates the Error object for content rating
	-->
	<xsl:template match="ERROR" mode="c_articlepoll">
		<xsl:apply-templates select="." mode="r_articlepoll"/>
	</xsl:template>
		<!--
	<xsl:template match="ERROR" mode="r_articlepoll">
	Author:		Tom Whitehouse
	Context:      /H2G2/POLL-LIST/POLL
	Purpose:	Error object for content rating
	-->
	<xsl:template match="ERROR" mode="r_articlepoll">
		<xsl:choose>
			<xsl:when test="@CODE=0">Unspecified error</xsl:when>
			<xsl:when test="@CODE=1">Invalid value in the cmd parameter</xsl:when>
			<xsl:when test="@CODE=2">One or more invalid parameters found </xsl:when>
			<xsl:when test="@CODE=3">Invalid poll id</xsl:when>
			<xsl:when test="@CODE=4">User needs to be logged in before operation can be performed</xsl:when>
			<xsl:when test="@CODE=5">Access denied</xsl:when>
			<xsl:when test="@CODE=6">Page Author is not allowed to vote</xsl:when>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="USER-VOTE" mode="c_changevote">
	Author:		Tom Whitehouse
	Context:      /H2G2/POLL-LIST/POLL
	Purpose:	Container for changing your vote
	-->
	<xsl:template match="USER-VOTE" mode="c_changevote">
		<xsl:apply-templates select="." mode="r_changevote"/>
	</xsl:template>

	<!--
	<xsl:template match="USER-VOTE" mode="r_changevote">
	Author:		Tom Whitehouse
	Context:      /H2G2/POLL-LIST/POLL
	Purpose:	Link to change your vote
	-->
	<xsl:template match="USER-VOTE" mode="r_changevote">
		<a href="{$root}A{/H2G2/ARTICLE/ARTICLEINFO/H2G2ID}?s_show=vote" xsl:use-attribute-sets="mUSER-VOTE_r_changevote">
			<xsl:copy-of select="$change_poll"/>
		</a>
	</xsl:template>
</xsl:stylesheet>
