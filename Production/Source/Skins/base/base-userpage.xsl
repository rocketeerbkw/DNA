<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<xsl:variable name="m_taguser">Add to the taxonomy</xsl:variable>
	<xsl:attribute-set name="mARTICLE_r_taguser" use-attribute-sets="userpagelinks"/>
	<xsl:attribute-set name="maFORUMID_r_leavemessage" use-attribute-sets="userpagelinks"/>
	<xsl:variable name="m_leaveusermessage">Leave a message</xsl:variable>
	<xsl:variable name="postlimitentries" select="10"/>
	<xsl:variable name="articlelimitentries" select="10"/>
	<xsl:variable name="clublimitentries" select="10"/>
	<xsl:template name="noJournalReplies">
		<xsl:value-of select="$m_noreplies"/>
	</xsl:template>
	<!--
	<xsl:template name="USERPAGE_HEADER">
	Author:		Andy Harris
	Context:      /H2G2
	Purpose:	 Creates the title for the page which sits in the html header
	-->
	<xsl:template name="USERPAGE_HEADER">
		<xsl:apply-templates mode="header" select=".">
			<xsl:with-param name="title">
				<xsl:choose>
					<xsl:when test="ARTICLE/SUBJECT">
						<xsl:value-of select="$m_pagetitlestart"/>
						<xsl:value-of select="ARTICLE/SUBJECT"/> - U<xsl:value-of select="PAGE-OWNER/USER/USERID"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:choose>
							<xsl:when test="$ownerisviewer = 1">
								<xsl:value-of select="$m_pagetitlestart"/>
								<xsl:value-of select="$m_pstitleowner"/>
								<xsl:apply-templates select="PAGE-OWNER/USER" mode="username" />.</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$m_pagetitlestart"/>
								<xsl:value-of select="$m_pstitleviewer"/>
								<xsl:value-of select="PAGE-OWNER/USER/USERID"/>.</xsl:otherwise>
						</xsl:choose>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>
	<!--
	<xsl:template name="USERPAGE_SUBJECT">
	Author:		Tom Whitehouse
	Context:      /H2G2
	Purpose:	 Creates the text for the subject
	-->
	<xsl:template name="USERPAGE_SUBJECT">
		<xsl:call-template name="SUBJECTHEADER">
			<xsl:with-param name="text">
				<xsl:choose>
					<xsl:when test="ARTICLE/ARTICLEINFO[HIDDEN='1']">
						<xsl:value-of select="$m_userpagemoderatesubject"/>
					</xsl:when>
					<xsl:when test="ARTICLE/SUBJECT">
						<xsl:value-of select="ARTICLE/SUBJECT"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:choose>
							<xsl:when test="$ownerisviewer = 1">
								<xsl:value-of select="$m_pstitleowner"/>
								<xsl:apply-templates select="PAGE-OWNER/USER" mode="username" />.</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$m_pstitleviewer"/>
								<xsl:value-of select="PAGE-OWNER/USER/USERID"/>.</xsl:otherwise>
						</xsl:choose>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="H2G2" mode="c_displayuserpage">
		<!--<xsl:if test="not(PARAMS/PARAM[NAME = 's_view'])">-->
		<xsl:apply-templates select="." mode="r_displayuserpage"/>
		<!--</xsl:if>-->
	</xsl:template>
	<!--======================================================
	====================JOURNAL OBJECT======================
	========================================================-->
	<!--
	<xsl:template match="JOURNAL" mode="c_userpage">
	Author:		Tom Whitehouse
	Context:      /H2G2/JOURNAL
	Purpose:	 Calls the container for the JOURNAL
	-->
	<xsl:template match="JOURNAL" mode="c_userpage">
		<xsl:apply-templates select="." mode="r_userpage"/>
	</xsl:template>
	<!--
	<xsl:template match="JOURNALPOSTS" mode="c_moreuserpagejournals">
	Author:		Tom Whitehouse
	Context:      /H2G2/JOURNAL/JOURNALPOSTS
	Purpose:	 Calls the container for the JOURNAL 'more entries' button 
	-->
	<xsl:template match="JOURNALPOSTS" mode="c_moreuserpagejournals">
		<xsl:if test="@MORE=1">
			<xsl:apply-templates select="." mode="r_moreuserpagejournals"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="JOURNALPOSTS" mode="r_moreuserpagejournals">
	Author:		Tom Whitehouse
	Context:      /H2G2/JOURNAL/JOURNALPOSTS
	Purpose:	 Creates the JOURNAL 'more entries' button 
	-->
	<xsl:template match="JOURNALPOSTS" mode="r_moreuserpagejournals">
		<xsl:param name="img" select="$m_clickmorejournal"/>
		<a xsl:use-attribute-sets="mJOURNALPOSTS_MoreJournal">
			<xsl:attribute name="HREF"><xsl:value-of select="$root"/>MJ<xsl:value-of select="../../PAGE-OWNER/USER/USERID"/>?Journal=<xsl:value-of select="@FORUMID"/>&amp;show=<xsl:value-of select="@COUNT"/>&amp;skip=<xsl:value-of select="number(@SKIPTO) + number(@COUNT)"/></xsl:attribute>
			<xsl:copy-of select="$img"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="JOURNALPOSTS" mode="c_adduserpagejournalentry">
	Author:		Tom Whitehouse
	Context:      /H2G2/JOURNAL/JOURNALPOSTS
	Purpose:	 Calls the container for the JOURNAL 'add entry' button 
	-->
	<xsl:template match="JOURNALPOSTS" mode="c_adduserpagejournalentry">
		<xsl:if test="@CANWRITE = 1 and $test_MayAddToJournal">
			<xsl:apply-templates select="." mode="r_adduserpagejournalentry"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="JOURNALPOSTS" mode="r_adduserpagejournalentry">
	Author:		Tom Whitehouse
	Context:      /H2G2/JOURNAL/JOURNALPOSTS
	Purpose:	 Creates the JOURNAL 'add entry' button 
	-->
	<xsl:template match="JOURNALPOSTS" mode="r_adduserpagejournalentry">
		<xsl:param name="img" select="$m_clickaddjournal"/>
		<a xsl:use-attribute-sets="nClickAddJournal">
			<xsl:attribute name="href"><xsl:value-of select="$root"/>PostJournal</xsl:attribute>
			<xsl:copy-of select="$img"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="JOURNAL" mode="t_journalmessage">
	Author:		Tom Whitehouse
	Context:      /H2G2/JOURNAL
	Purpose:	 Creates the JOURNAL introductory message 
	-->
	<xsl:template match="JOURNAL" mode="t_journalmessage">
		<xsl:choose>
			<xsl:when test="JOURNALPOSTS/POST">
				<xsl:choose>
					<xsl:when test="$ownerisviewer = 1">
						<xsl:call-template name="m_journalownerfull"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="m_journalviewerfull"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="not(JOURNALPOSTS/POST) and (JOURNALPOSTS/@CANREAD=0)">
				<xsl:choose>
					<xsl:when test="$ownerisviewer = 1">
						<xsl:copy-of select="$m_journalownercantread"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:copy-of select="$m_journalviewercantread"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="$ownerisviewer = 1">
						<xsl:call-template name="m_journalownerempty"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="m_journalviewerempty"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="POST" mode="c_userpagejournalentries">
	Author:		Tom Whitehouse
	Context:      /H2G2/JOURNAL/JOURNALPOSTS/POST
	Purpose:	 Calls the container for the each POST in the journal 
	-->
	<xsl:template match="POST" mode="c_userpagejournalentries">
		<xsl:apply-templates select="." mode="r_userpagejournalentries"/>
	</xsl:template>
	<!--
	<xsl:template match="DATE" mode="t_datejournalposted">
	Author:		Tom Whitehouse
	Context:      /H2G2/JOURNAL/JOURNALPOSTS/POST/DATEPOSTED/DATE
	Purpose:	 Creates the DATE text
	-->
	<xsl:template match="DATE" mode="t_datejournalposted">
		<xsl:apply-templates select="."/>
	</xsl:template>
	<!--
	<xsl:template match="TEXT" mode="t_journaltext">
	Author:		Tom Whitehouse
	Context:      /H2G2/JOURNAL/JOURNALPOSTS/POST/TEXT
	Purpose:	 Creates the journal body TEXT
	-->
	<xsl:template match="TEXT" mode="t_journaltext">
		<xsl:apply-templates select="."/>
	</xsl:template>
	<!--
	<xsl:template match="@THREADID" mode="t_journalentriesreplies">
	Author:		Tom Whitehouse
	Context:      /H2G2/JOURNAL/JOURNALPOSTS/POST/@THREADID
	Purpose:	 Creates the number of replies text
	-->
	<xsl:template match="@THREADID" mode="t_journalentriesreplies">
		<a xsl:use-attribute-sets="maTHREADID_JournalEntryReplies">
			<xsl:attribute name="HREF"><xsl:value-of select="$root"/>F<xsl:value-of select="../../@FORUMID"/>?thread=<xsl:value-of select="."/></xsl:attribute>
			<xsl:choose>
				<xsl:when test="../LASTREPLY[@COUNT &gt; 2]">
					<xsl:value-of select="number(../LASTREPLY/@COUNT)-1"/>
					<xsl:value-of select="$m_replies"/>
				</xsl:when>
				<xsl:otherwise>1<xsl:value-of select="$m_reply"/>
				</xsl:otherwise>
			</xsl:choose>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="@POSTID" mode="t_discussjournalentry">
	Author:		Tom Whitehouse
	Context:      /H2G2/JOURNAL/JOURNALPOSTS/POST/@POSTID
	Purpose:	 Creates the 'Dicuss this entry' link
	-->
	<xsl:template match="@POSTID" mode="t_discussjournalentry">
		<a xsl:use-attribute-sets="maPOSTID_DiscussJournalEntry">
			<xsl:attribute name="href"><xsl:value-of select="$root"/>AddThread?InReplyTo=<xsl:value-of select="."/></xsl:attribute>
			<xsl:copy-of select="$m_clickherediscuss"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="@THREADID" mode="t_journallastreply">
	Author:		Tom Whitehouse
	Context:      /H2G2/JOURNAL/JOURNALPOSTS/POST/@THREADID
	Purpose:	 Creates the 'Last reply' link
	-->
	<xsl:template match="@THREADID" mode="t_journallastreply">
		<a xsl:use-attribute-sets="maTHREADID_JournalLastReply">
			<xsl:attribute name="HREF"><xsl:value-of select="$root"/>F<xsl:value-of select="."/>?thread=<xsl:value-of select="../@THREADID"/>&amp;latest=1</xsl:attribute>
			<xsl:apply-templates select="../LASTREPLY/DATE"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="@THREADID" mode="c_removejournalpostup">
	Author:		Tom Whitehouse
	Context:      /H2G2/JOURNAL/JOURNALPOSTS/POST/@THREADID
	Purpose:	 Calls the 'Remove this post' link container
	-->
	<xsl:template match="@THREADID" mode="c_removejournalpostup">
		<xsl:if test="$test_MayRemoveJournalPost">
			<xsl:apply-templates select="." mode="r_removejournalpostup"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="@THREADID" mode="r_removejournalpostup">
	Author:		Tom Whitehouse
	Context:      /H2G2/JOURNAL/JOURNALPOSTS/POST/@THREADID
	Purpose:	 Creates the 'Remove this post' link
	-->
	<xsl:template match="@THREADID" mode="r_removejournalpostup">
		<a xsl:use-attribute-sets="maTHREADID_JournalRemovePost" href="{$root}FSB{../../@FORUMID}?thread={.}&amp;cmd=unsubscribejournal&amp;page=normal&amp;desc={$alt_subreturntospace}&amp;return=U{$viewerid}">
			<xsl:copy-of select="$m_removejournalup"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="LASTREPLY" mode="c_journalreplies">
	Author:		Tom Whitehouse
	Context:      /H2G2/JOURNAL/JOURNALPOSTS/POST/LASTREPLY
	Purpose:	 Calls the container for the journal replies or the no replies text
	-->
	<xsl:template match="LASTREPLY" mode="c_journalreplies">
		<xsl:choose>
			<xsl:when test="@COUNT &gt; 1">
				<xsl:apply-templates select="." mode="r_journalreplies"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="noJournalReplies"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="@THREADID" mode="r_removejournalpost">
	Author:		Tom Whitehouse
	Context:      /H2G2/JOURNAL/JOURNALPOSTS/POST/@THREADID
	Purpose:	 Creates the 'Remove journal' link
	-->
	<xsl:template match="@THREADID" mode="r_removejournalpost">
		<xsl:param name="img" select="$m_removejournal"/>
		<a xsl:use-attribute-sets="maTHREADID_JournalRemovePost" href="{$root}FSB{../../@FORUMID}?thread={.}&amp;cmd=unsubscribejournal&amp;page=normal&amp;desc={$alt_subreturntospace}&amp;return=U{$viewerid}">
			<xsl:copy-of select="$img"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="LASTREPLY" mode="c_lastjournalrepliesup">
	Author:		Tom Whitehouse
	Context:      /H2G2/JOURNAL/JOURNALPOSTS/POST/LASTREPLY
	Purpose:	 Calls the LASTREPLY container or 'No replies' text
	-->
	<xsl:template match="LASTREPLY" mode="c_lastjournalrepliesup">
		<xsl:choose>
			<xsl:when test="number(@COUNT) &gt; 1">
				<xsl:apply-templates select="." mode="r_lastjournalrepliesup"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="noJournalReplies"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--======================================================
	=================RECENT POSTS OBJECT====================
	========================================================-->
	<!--
	<xsl:template match="RECENT-POSTS" mode="c_userpage">
	Author:		Tom Whitehouse
	Context:      /H2G2/RECENT-POSTS
	Purpose:	 Calls the RECENT-POSTS container
	-->
	<xsl:template match="RECENT-POSTS" mode="c_userpage">
		<xsl:apply-templates select="." mode="r_userpage"/>
	</xsl:template>
	<!--
	<xsl:template match="RECENT-POSTS" mode="c_postlistempty">
	Author:		Tom Whitehouse
	Context:      /H2G2/RECENT-POSTS
	Purpose:	 Calls the RECENT-POSTS empty container
	-->
	<xsl:template match="RECENT-POSTS" mode="c_postlistempty">
		<xsl:if test="not(POST-LIST/POST)">
			<xsl:choose>
				<xsl:when test="$ownerisviewer = 1">
					<xsl:apply-templates select="." mode="owner_postlistempty"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="." mode="viewer_postlistempty"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="POST-LIST" mode="c_postlist">
	Author:		Tom Whitehouse
	Context:      /H2G2/RECENT-POSTS/POST-LIST
	Purpose:	 Calls the correct version of the POST-LIST container
	-->
	<xsl:template match="POST-LIST" mode="c_postlist">
		<xsl:choose>
			<xsl:when test="$ownerisviewer = 1">
				<xsl:apply-templates select="." mode="owner_postlist"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="." mode="viewer_postlist"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="POST" mode="c_userpage">
	Author:		Tom Whitehouse
	Context:      /H2G2/RECENT-POSTS/POST-LIST/POST
	Purpose:	 Calls the POST container
	-->
	<xsl:template match="POST" mode="c_userpage">
		<xsl:apply-templates select="." mode="r_userpage"/>
	</xsl:template>
	<!--
	<xsl:template match="USERID" mode="c_morepostslink">
	Author:		Tom Whitehouse
	Context:      /H2G2/RECENT-POSTS/POST-LIST/POST/USER/USERID
	Purpose:	 Calls the 'More posts' link container
	-->
	<xsl:template match="USERID" mode="c_morepostslink">
		<xsl:if test="position() &lt;= $postlimitentries">
			<xsl:apply-templates select="." mode="r_morepostslink"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="USERID" mode="c_morepostslink">
	Author:		Tom Whitehouse
	Context:      /H2G2/RECENT-POSTS/POST-LIST/POST/USER/USERID
	Purpose:	 Creates the 'More posts' link
	-->
	<xsl:template match="USERID" mode="r_morepostslink">
		<xsl:param name="img">
			<xsl:value-of select="$m_clickmoreconv"/>
		</xsl:param>
		<a xsl:use-attribute-sets="mUSERID_MorePosts">
			<xsl:attribute name="HREF"><xsl:value-of select="$root"/>MP<xsl:value-of select="."/></xsl:attribute>
			<xsl:copy-of select="$img"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="SITEID" mode="t_userpage">
	Author:		Tom Whitehouse
	Context:      /H2G2/RECENT-POSTS/POST-LIST/POST/SITEID
	Purpose:	 Creates the site origin text
	-->
	<xsl:template match="SITEID" mode="t_userpage">
		<xsl:value-of select="/H2G2/SITE-LIST/SITE[@ID=current()]/SHORTNAME"/>
	</xsl:template>
	<!--
	<xsl:template match="@THREADID" mode="t_userpagepostsubject">
	Author:		Tom Whitehouse
	Context:      /H2G2/RECENT-POSTS/POST-LIST/POST/THREAD/@THREADID
	Purpose:	 Calls the correct type of the SUBJECT link
	-->
	<xsl:template match="@THREADID" mode="t_userpagepostsubject">
		<a xsl:use-attribute-sets="maTHREADID_LinkOnSubjectAB">
			<xsl:attribute name="href"><xsl:value-of select="$root"/>F<xsl:value-of select="../@FORUMID"/>?thread=<xsl:value-of select="."/></xsl:attribute>
			<xsl:apply-templates select="../SUBJECT" mode="userpage"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="SUBJECT" mode="userpage">
	Author:		Tom Whitehouse
	Context:      /H2G2/RECENT-POSTS/POST-LIST/POST/THREAD/SUBJECT
	Purpose:	 Creates the SUBJECT link
	-->
	<xsl:template match="SUBJECT" mode="userpage">
		<xsl:choose>
			<xsl:when test=".=''">
				<xsl:value-of select="$m_nosubject"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="."/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="POST" mode="c_userpagepostdate">
	Author:		Tom Whitehouse
	Context:      /H2G2/RECENT-POSTS/POST-LIST/POST
	Purpose:	 Calls the container for post date link or the no posting text
	-->
	<xsl:template match="POST" mode="c_userpagepostdate">
		<xsl:choose>
			<xsl:when test="THREAD/LASTUSERPOST">
				<xsl:apply-templates select="." mode="r_userpagepostdate"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$m_noposting"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="POST" mode="r_userpagepostdate">
	Author:		Tom Whitehouse
	Context:      /H2G2/RECENT-POSTS/POST-LIST/POST
	Purpose:	 Calls the container for post date link
	-->
	<xsl:template match="POST" mode="r_userpagepostdate">
		<xsl:apply-templates select="THREAD/LASTUSERPOST/DATEPOSTED/DATE" mode="r_userpagepostdate"/>
	</xsl:template>
	<!--
	<xsl:template match="DATE" mode="r_userpagepostdate">
	Author:		Tom Whitehouse
	Context:      /H2G2/RECENT-POSTS/POST-LIST/POST
	Purpose:	 Creates the post date link
	-->
	<xsl:template match="DATE" mode="r_userpagepostdate">
		<a xsl:use-attribute-sets="mDATE_LastUserPost">
			<xsl:attribute name="HREF"><xsl:value-of select="$root"/>F<xsl:value-of select="../../../@FORUMID"/>?thread=<xsl:value-of select="../../../@THREADID"/>&amp;post=<xsl:value-of select="../../@POSTID"/>#p<xsl:value-of select="../../@POSTID"/></xsl:attribute>
			<xsl:apply-templates select="."/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="POST" mode="c_unsubscribe">
	Author:		Tom Whitehouse
	Context:      /H2G2/RECENT-POSTS/POST-LIST/POST
	Purpose:	 Calls the 'Unsubscribe to this thread' link container for the correct page type
	-->
	<xsl:template match="POST" mode="c_unsubscribe">
		<xsl:if test="$ownerisviewer = 1">
			<xsl:choose>
				<xsl:when test="/H2G2[@TYPE='USERPAGE']">
					<xsl:apply-templates select="." mode="c_postunsubscribeuserpage"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="." mode="postunsubotherpage"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="POST" mode="c_userpagepostlastreply">
	Author:		Tom Whitehouse
	Context:      /H2G2/RECENT-POSTS/POST-LIST/POST
	Purpose:	 Calls the 'Last reply' link container
	-->
	<xsl:template match="POST" mode="c_userpagepostlastreply">
		<xsl:apply-templates select="." mode="r_userpagepostlastreply"/>
	</xsl:template>
	<!--
	<xsl:template match="POST" mode="t_lastreplytext">
	Author:		Tom Whitehouse
	Context:      /H2G2/RECENT-POSTS/POST-LIST/POST
	Purpose:	 Creates the correct 'last reply' text
	-->
	<xsl:template match="POST" mode="t_lastreplytext">
		<xsl:choose>
			<xsl:when test="HAS-REPLY > 0">
				<xsl:choose>
					<xsl:when test="THREAD/LASTUSERPOST">
						<xsl:value-of select="$m_lastreply"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$m_newestpost"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$m_noreplies"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="POST" mode="t_userpagepostlastreply">
	Author:		Tom Whitehouse
	Context:      /H2G2/RECENT-POSTS/POST-LIST/POST
	Purpose:	 Calls the container for the 'last reply' date link
	-->
	<xsl:template match="POST" mode="t_userpagepostlastreply">
		<xsl:if test="HAS-REPLY > 0">
			<xsl:apply-templates select="THREAD/REPLYDATE/DATE" mode="LatestPost"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="POST" mode="t_userpagepostlastreply">
	Author:		Tom Whitehouse
	Context:      /H2G2/RECENT-POSTS/POST-LIST/POST
	Purpose:	 Creates the 'last reply' date link
	-->
	<xsl:template match="DATE" mode="LatestPost">
		<xsl:param name="attributes"/>
		<a xsl:use-attribute-sets="mDATE_LatestPost">
			<xsl:attribute name="HREF"><xsl:value-of select="$root"/>F<xsl:value-of select="../../@FORUMID"/>?thread=<xsl:value-of select="../../@THREADID"/><xsl:variable name="thread" select="../../@THREADID"/><xsl:choose><xsl:when test="/H2G2/PARAMS/PARAM[NAME='s_t' and (substring-before(VALUE, '|') = string($thread))]"><xsl:text>&amp;date=</xsl:text><xsl:value-of select="substring-after(/H2G2/PARAMS/PARAM[NAME='s_t' and substring-before(VALUE, '|') = string($thread)]/VALUE,'|')"/></xsl:when><xsl:otherwise><xsl:text>&amp;latest=1</xsl:text></xsl:otherwise></xsl:choose></xsl:attribute>
			<xsl:apply-templates select="."/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="POST" mode="c_postunsubscribeuserpage">
	Author:		Tom Whitehouse
	Context:      /H2G2/RECENT-POSTS/POST-LIST/POST
	Purpose:	 Calls the container for the 'unsubscribe' link container
	-->
	<xsl:template match="POST" mode="c_postunsubscribeuserpage">
		<xsl:if test="$ownerisviewer = 1">
			<xsl:apply-templates select="." mode="r_postunsubscribeuserpage"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="POST" mode="r_postunsubscribeuserpage">
	Author:		Tom Whitehouse
	Context:      /H2G2/RECENT-POSTS/POST-LIST/POST
	Purpose:	 Creates the 'unsubscribe' link for the userpage
	-->
	<xsl:template match="POST" mode="r_postunsubscribeuserpage">
		<xsl:param name="embodiment" select="$m_unsubscribe"/>
		<xsl:param name="attributes"/>
		<a href="{$root}FSB{THREAD/@FORUMID}?thread={THREAD/@THREADID}&amp;cmd=unsubscribethread&amp;page=normal&amp;desc={$alt_subreturntospace}&amp;return=U{$viewerid}" xsl:use-attribute-sets="npostunsubscribe1">
			<xsl:call-template name="ApplyAttributes">
				<xsl:with-param name="attributes" select="$attributes"/>
			</xsl:call-template>
			<xsl:copy-of select="$embodiment"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="POST" mode="postunsubotherpage">
	Author:		Tom Whitehouse
	Context:      /H2G2/RECENT-POSTS/POST-LIST/POST
	Purpose:	 Creates the 'unsubscribe' link for other pages
	-->
	<xsl:template match="POST" mode="postunsubotherpage">
		<xsl:param name="embodiment" select="$m_unsubscribe"/>
		<xsl:param name="attributes"/>
		<a target="_top" href="{$root}FSB{THREAD/@FORUMID}?thread={THREAD/@THREADID}&amp;cmd=unsubscribethread&amp;page=normal&amp;desc={$alt_subreturntopostlist}&amp;return=MP{$viewerid}%3Fskip={../@SKIPTO}%26amp;show={../@COUNT}" xsl:use-attribute-sets="npostunsubscribe2">
			<xsl:call-template name="ApplyAttributes">
				<xsl:with-param name="attributes" select="$attributes"/>
			</xsl:call-template>
			<xsl:copy-of select="$embodiment"/>
		</a>
	</xsl:template>
	<!--======================================================
	=================RECENT ENTRIES OBJECT====================
	========================================================-->
	<!--
	<xsl:template match="RECENT-ENTRIES" mode="c_userpage">
	Author:		Tom Whitehouse
	Context:      /H2G2/RECENT-ENTRIES
	Purpose:	 Calls the RECENT-ENTRIES container
	-->
	<xsl:template match="RECENT-ENTRIES" mode="c_userpage">
		<xsl:apply-templates select="." mode="r_userpage"/>
	</xsl:template>
	<!--
	<xsl:template match="RECENT-ENTRIES" mode="c_userpagelistempty">
	Author:		Tom Whitehouse
	Context:      /H2G2/RECENT-ENTRIES
	Purpose:	 Calls the correct RECENT-ENTRIES empty container
	-->
	<xsl:template match="RECENT-ENTRIES" mode="c_userpagelistempty">
		<xsl:if test="not(ARTICLE-LIST/ARTICLE[not(EXTRAINFO/TYPE/@ID=3001)][not(EXTRAINFO/TYPE/@ID=1001)])">
			<xsl:choose>
				<xsl:when test="$ownerisviewer = 1">
					<xsl:apply-templates select="." mode="owner_userpagelistempty"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="." mode="viewer_userpagelistempty"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="ARTICLE-LIST" mode="c_userpagelist">
	Author:		Tom Whitehouse
	Context:      /H2G2/RECENT-ENTRIES/ARTICLE-LIST
	Purpose:	 Calls the correct ARTICLE-LIST container
	-->
	<xsl:template match="ARTICLE-LIST" mode="c_userpagelist">
		<xsl:choose>
			<xsl:when test="$ownerisviewer = 1">
				<xsl:apply-templates select="." mode="ownerfull_userpagelist"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="." mode="viewerfull_userpagelist"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="ARTICLE" mode="c_userpagelist">
	Author:		Tom Whitehouse
	Context:      /H2G2/RECENT-ENTRIES/ARTICLE-LIST
	Purpose:	 Calls the ARTICLE container
	-->
	<xsl:template match="ARTICLE" mode="c_userpagelist">
		<xsl:if test="EXTRAINFO/TYPE/@ID &lt; 1001">
			<xsl:apply-templates select="." mode="r_userpagelist"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="ARTICLE-LIST" mode="c_morearticles">
	Author:		Tom Whitehouse
	Context:      /H2G2/RECENT-ENTRIES/ARTICLE-LIST
	Purpose:	 Calls the 'More articles' link container if needed
	-->
	<xsl:template match="ARTICLE-LIST" mode="c_morearticles">
		<xsl:if test="ARTICLE[position() &gt; $articlelimitentries]">
			<xsl:apply-templates select="." mode="r_morearticles"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="ARTICLE-LIST" mode="r_morearticles">
	Author:		Tom Whitehouse
	Context:      /H2G2/RECENT-ENTRIES/ARTICLE-LIST
	Purpose:	 Creates the 'More articles' link
	-->
	<xsl:template match="ARTICLE-LIST" mode="r_morearticles">
		<a href="{$root}MA{/H2G2/RECENT-ENTRIES/USER/USERID}?type=4" xsl:use-attribute-sets="mARTICLE-LIST_r_morearticles">
			<xsl:value-of select="$m_clickmoreentries"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="ARTICLE-LIST" mode="c_moreeditedarticles">
	Author:		Tom Whitehouse
	Context:      /H2G2/RECENT-ENTRIES/ARTICLE-LIST
	Purpose:	 Calls the 'More edited articles' link container if needed
	-->
	<xsl:template match="ARTICLE-LIST" mode="c_moreeditedarticles">
		<xsl:if test="ARTICLE[position() &gt; $articlelimitentries]">
			<xsl:apply-templates select="." mode="r_moreeditedarticles"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="ARTICLE-LIST" mode="r_moreeditedarticles">
	Author:		Tom Whitehouse
	Context:      /H2G2/RECENT-ENTRIES/ARTICLE-LIST
	Purpose:	 Creates the 'More edited articles' link
	-->
	<xsl:template match="ARTICLE-LIST" mode="r_moreeditedarticles">
		<a href="{$root}MA{/H2G2/RECENT-APPROVALS/USER/USERID}?type=1" xsl:use-attribute-sets="mARTICLE-LIST_r_moreeditedarticles">
			<xsl:value-of select="$m_clickmoreedited"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template name="c_createnewarticle">
	Author:		Tom Whitehouse
	Context:      
	Purpose:	 Creates the 'New article' link
	-->
	<xsl:template name="c_createnewarticle">
		<!-- there might be a test here! -->
		<xsl:call-template name="r_createnewarticle">
			<xsl:with-param name="content">
				<a href="{$root}useredit" xsl:use-attribute-sets="nc_createnewarticle">
					<xsl:value-of select="$m_clicknewentry"/>
				</a>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<!--
	<xsl:template match="H2G2-ID" mode="t_userpage">
	Author:		Tom Whitehouse
	Context:      /H2G2/RECENT-ENTRIES/ARTICLE-LIST/ARTICLE/H2G2-ID
	Purpose:	 Creates the H2G2-ID link to the article
	-->
	<xsl:template match="H2G2-ID" mode="t_userpage">
		<a href="{$root}A{.}" xsl:use-attribute-sets="mH2G2-ID_t_userpage">
			<xsl:value-of select="concat('A', .)"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="SUBJECT" mode="t_userpagearticle">
	Author:		Tom Whitehouse
	Context:      /H2G2/RECENT-ENTRIES/ARTICLE-LIST/ARTICLE/SUBJECT
	Purpose:	 Creates the SUBJECT link to the article
	-->
	<xsl:template match="SUBJECT" mode="t_userpagearticle">
		<a href="{$root}A{../H2G2-ID}" xsl:use-attribute-sets="mSUBJECT_t_userpagearticle">
			<xsl:value-of select="."/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="DATE" mode="t_userpagearticle">
	Author:		Tom Whitehouse
	Context:      /H2G2/RECENT-ENTRIES/ARTICLE-LIST/ARTICLE/DATECREATED/DATE
	Purpose:	 Creates the DATE text of the article
	-->
	<xsl:template match="DATE" mode="t_userpagearticle">
		<xsl:apply-templates select="."/>
	</xsl:template>
	<!--
	<xsl:template match="H2G2-ID" mode="c_uncancelarticle">
	Author:		Tom Whitehouse
	Context:      /H2G2/RECENT-ENTRIES/ARTICLE-LIST/ARTICLE/H2G2-ID
	Purpose:	 Calls the 'Uncancel this article' link container
	-->
	<xsl:template match="H2G2-ID" mode="c_uncancelarticle">
		<xsl:if test="($ownerisviewer = 1) and (../STATUS = 7)">
			<xsl:apply-templates select="." mode="r_uncancelarticle"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="H2G2-ID" mode="r_uncancelarticle">
	Author:		Tom Whitehouse
	Context:      /H2G2/RECENT-ENTRIES/ARTICLE-LIST/ARTICLE/H2G2-ID
	Purpose:	 Creates the 'Uncancel this article' link
	-->
	<xsl:template match="H2G2-ID" mode="r_uncancelarticle">
		<xsl:param name="embodiment" select="$m_uncancel"/>
		<a xsl:use-attribute-sets="mH2G2-ID_UserEditUndelete" href="{$root}UserEdit{.}?cmd=undelete">
			<xsl:copy-of select="$embodiment"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="STATUS" mode="t_userpagearticle">
	Author:		Tom Whitehouse
	Context:      /H2G2/RECENT-ENTRIES/ARTICLE-LIST/ARTICLE/STATUS
	Purpose:	 Creates the STATUS text
	-->
	<xsl:template match="STATUS" mode="t_userpagearticle">
		<xsl:choose>
			<xsl:when test=". = 7">
				<xsl:value-of select="$m_cancelled"/>
			</xsl:when>
			<xsl:when test=". > 3 and . != 7">
				<xsl:choose>
					<xsl:when test=". = 13 or . = 6">
						<xsl:value-of select="$m_pending"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$m_recommended"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="H2G2-ID" mode="c_editarticle">
	Author:		Tom Whitehouse
	Context:      /H2G2/RECENT-ENTRIES/ARTICLE-LIST/ARTICLE/H2G2-ID
	Purpose:	 Calls the 'Edit this article' link container
	-->
	<xsl:template match="H2G2-ID" mode="c_editarticle">
		<xsl:if test="($ownerisviewer = 1) and (../STATUS = 3 or ../STATUS = 4) and (../EDITOR/USER/USERID = $viewerid)">
			<xsl:apply-templates select="." mode="r_editarticle"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="H2G2-ID" mode="r_editarticle">
	Author:		Tom Whitehouse
	Context:      /H2G2/RECENT-ENTRIES/ARTICLE-LIST/ARTICLE/H2G2-ID
	Purpose:	 Creates the 'Edit this article' link
	-->
	<xsl:template match="H2G2-ID" mode="r_editarticle">
		<a href="{$root}UserEdit{.}" xsl:use-attribute-sets="mH2G2-ID_r_editarticle">
			<xsl:value-of select="$m_edit"/>
		</a>
	</xsl:template>
	<!--======================================================
	===============RECENT APPROVALS OBJECT==================
	========================================================-->
	<!--
	<xsl:template match="RECENT-APPROVALS" mode="c_userpage">
	Author:		Tom Whitehouse
	Context:      /H2G2/RECENT-APPROVALS
	Purpose:	 Calls the RECENT-APPROVALS container
	-->
	<xsl:template match="RECENT-APPROVALS" mode="c_userpage">
		<xsl:apply-templates select="." mode="r_userpage"/>
	</xsl:template>
	<!--
	<xsl:template match="RECENT-APPROVALS" mode="c_approvalslistempty">
	Author:		Tom Whitehouse
	Context:      /H2G2/RECENT-APPROVALS
	Purpose:	 Calls the correct RECENT-APPROVALS empty container
	-->
	<xsl:template match="RECENT-APPROVALS" mode="c_approvalslistempty">
		<xsl:if test="not(ARTICLE-LIST/ARTICLE)">
			<xsl:choose>
				<xsl:when test="$ownerisviewer = 1">
					<xsl:apply-templates select="." mode="owner_approvalslistempty"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="." mode="viewer_approvalslistempty"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="RECENT-APPROVALS" mode="c_approvalslistempty">
	Author:		Tom Whitehouse
	Context:      /H2G2/RECENT-APPROVALS/ARTICLE-LIST
	Purpose:	 Calls the correct ARTICLE-LIST container
	-->
	<xsl:template match="ARTICLE-LIST" mode="c_approvalslist">
		<xsl:choose>
			<xsl:when test="$ownerisviewer = 1">
				<xsl:apply-templates select="." mode="owner_approvalslist"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="." mode="viewer_approvalslist"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--======================================================
	=================PAGE OWNER OBJECT=====================
	========================================================-->
	<xsl:template match="USER/GROUPS/*">
		<xsl:variable name="groupname" select="name()"/>
		<xsl:apply-templates select="msxsl:node-set($subbadges)/GROUPBADGE[@NAME = $groupname]/*"/>
	</xsl:template>
	<!--
	<xsl:template match="PAGE-OWNER" mode="c_userpage">
	Author:		Tom Whitehouse
	Context:      /H2G2/PAGE-OWNER
	Purpose:	 Calls the container for the PAGE-OWNER
	-->
	<xsl:template match="PAGE-OWNER" mode="c_userpage">
		<xsl:apply-templates select="." mode="r_userpage"/>
	</xsl:template>
	<!--
	<xsl:template match="PAGE-OWNER" mode="t_userpageintro">
	Author:		Tom Whitehouse
	Context:      /H2G2/PAGE-OWNER
	Purpose:	 Creates the correct text for introductioon to the userpage
	-->
	<xsl:template match="PAGE-OWNER" mode="t_userpageintro">
		<xsl:choose>
			<xsl:when test="/H2G2/ARTICLE/ARTICLEINFO[HIDDEN='1']">
				<xsl:call-template name="m_userpagehidden"/>
			</xsl:when>
			<xsl:when test="/H2G2/ARTICLE/ARTICLEINFO[HIDDEN='2']">
				<xsl:call-template name="m_userpagereferred"/>
			</xsl:when>
			<xsl:when test="/H2G2/ARTICLE/ARTICLEINFO[HIDDEN='3']">
				<xsl:call-template name="m_userpagependingpremoderation"/>
			</xsl:when>
			<xsl:when test="/H2G2/ARTICLE/ARTICLEINFO[HIDDEN='4']">
				<xsl:call-template name="m_legacyuserpageawaitingmoderation"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="$test_introarticle">
						<xsl:apply-templates select="/H2G2/ARTICLE/GUIDE/BODY"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:choose>
							<xsl:when test="$ownerisviewer = 1">
								<xsl:call-template name="m_psintroowner"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:call-template name="m_psintroviewer"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="PAGE-OWNER" mode="c_userpageintro">
	Author:		Tom Whitehouse
	Context:      /H2G2/PAGE-OWNER
	Purpose:	 Added in case markup is required to enclose a userpage introduction 
	-->
	<xsl:template match="PAGE-OWNER" mode="c_userpageintro">
		<xsl:choose>
			<xsl:when test="/H2G2/ARTICLE/ARTICLEINFO[HIDDEN='1']">
				<xsl:call-template name="m_userpagehidden"/>
			</xsl:when>
			<xsl:when test="/H2G2/ARTICLE/ARTICLEINFO[HIDDEN='2']">
				<xsl:call-template name="m_userpagereferred"/>
			</xsl:when>
			<xsl:when test="/H2G2/ARTICLE/ARTICLEINFO[HIDDEN='3']">
				<xsl:call-template name="m_userpagependingpremoderation"/>
			</xsl:when>
			<xsl:when test="/H2G2/ARTICLE/ARTICLEINFO[HIDDEN='4']">
				<xsl:call-template name="m_legacyuserpageawaitingmoderation"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="$test_introarticle">
						<xsl:apply-templates select="/H2G2/ARTICLE/GUIDE/BODY" mode="r_userpageintro"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:choose>
							<xsl:when test="$ownerisviewer = 1">
								<xsl:call-template name="m_psintroowner"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:call-template name="m_psintroviewer"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="BODY" mode="r_userpageintro">
	Author:		Tom Whitehouse
	Context:      /H2G2/PAGE-OWNER
	Purpose:	 Default receiving template if none is provided in the skin
	-->
	<xsl:template match="BODY" mode="r_userpageintro">
		<p>
			<xsl:apply-templates/>
		</p>
	</xsl:template>
	<!--
	<xsl:template match="PAGE-OWNER" mode="r_clip">
	Author:		Tom Whitehouse
	Context:      /H2G2
	Purpose:	 Creates the 'save as clippings' link 
	-->
	<xsl:template match="PAGE-OWNER" mode="r_clip">
		<a href="{$root}U{USER/USERID}?clip=1" xsl:use-attribute-sets="mPAGE-OWNER_r_clip">
			<xsl:copy-of select="$m_clipuserpage"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="USERID" mode="c_inspectuser">
	Author:		Tom Whitehouse
	Context:      /H2G2/PAGE-OWNER/USER/USERID
	Purpose:	 Calls the inspect user link container if needed
	-->
	<xsl:template match="USERID" mode="c_inspectuser">
		<xsl:if test="$test_IsEditor">
			<xsl:apply-templates select="." mode="r_inspectuser"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="USERID" mode="r_inspectuser">
	Author:		Tom Whitehouse
	Context:      /H2G2/PAGE-OWNER/USER/USERID
	Purpose:	 Creates the inspect user link
	-->
	<xsl:template match="USERID" mode="r_inspectuser">
		<xsl:param name="img" select="$m_InspectUser"/>
		<a xsl:use-attribute-sets="mUSERID_Inspect" href="{$root}InspectUser?UserID={.}">
			<xsl:copy-of select="$img"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="PAGE-OWNER" mode="c_editmasthead">
	Author:		Tom Whitehouse
	Context:      /H2G2/PAGE-OWNER
	Purpose:	 Calls the 'Edit this page' link container if needed
	-->
	<xsl:template match="PAGE-OWNER" mode="c_editmasthead">
		<xsl:if test="$test_CanEditMasthead">
			<xsl:apply-templates select="." mode="r_editmasthead"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="PAGE-OWNER" mode="r_editmasthead">
	Author:		Tom Whitehouse
	Context:      /H2G2/PAGE-OWNER
	Purpose:	 Creates the 'Edit this page' link
	-->
	<xsl:template match="PAGE-OWNER" mode="r_editmasthead">
		<xsl:param name="img" select="$alt_editthispage"/>
		<a xsl:use-attribute-sets="nUserEditMasthead">
			<xsl:if test="/H2G2/ARTICLE/ARTICLEINFO/H2G2ID">
				<xsl:attribute name="href"><xsl:value-of select="$root"/>UserEdit<xsl:value-of select="/H2G2/ARTICLE/ARTICLEINFO/H2G2ID"/></xsl:attribute>
			</xsl:if>
			<xsl:if test="not(/H2G2/ARTICLE/ARTICLEINFO/H2G2ID)">
				<xsl:attribute name="href"><xsl:value-of select="$root"/>UserEdit?masthead=1</xsl:attribute>
			</xsl:if>
			<xsl:copy-of select="$img"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="USERID" mode="c_addtofriends">
	Author:		Tom Whitehouse
	Context:      /H2G2/PAGE-OWNER/USER/USERID
	Purpose:	 Calls the 'Add to friends' link container if needed
	-->
	<xsl:template match="USERID" mode="c_addtofriends">
		<xsl:if test="$ownerisviewer=0 and $registered=1">
			<xsl:apply-templates select="." mode="r_addtofriends"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="USERID" mode="r_addtofriends">
	Author:		Tom Whitehouse
	Context:      /H2G2/PAGE-OWNER/USER/USERID
	Purpose:	 Creates the 'Add to friends' link
	-->
	<xsl:template match="USERID" mode="r_addtofriends">
		<a href="Watch{$viewerid}?add=1&amp;adduser={.}">
			<xsl:copy-of select="$m_addtofriends"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="USERID" mode="r_addtofriends">
	Author:		Tom Whitehouse
	Context:      /H2G2/PAGE-OWNER/USER/USERID
	Purpose:	 Calls the GROUPS container
	-->
	<xsl:template match="GROUPS" mode="c_userpage">
		<xsl:apply-templates select="." mode="r_userpage"/>
	</xsl:template>
	<!--======================================================
	=================ARTICLEFOUM OBJECT=====================
	========================================================-->
	<!--
	<xsl:template match="ARTICLEFORUM" mode="c_userpage">
	Author:		Tom Whitehouse
	Context:      /H2G2/ARTICLEFORUM
	Purpose:	 Calls the ARTICLEFORUM container
	-->
	<xsl:template match="ARTICLEFORUM" mode="c_userpage">
		<xsl:apply-templates select="." mode="r_userpage"/>
	</xsl:template>
	<!--
	<xsl:template match="FORUMTHREADS" mode="c_userpage">
	Author:		Tom Whitehouse
	Context:      /H2G2/ARTICLEFORUM/FORUMTHREADS
	Purpose:	 Calls the correct FORUMTHREADS container or 'Register' text
	-->
	<xsl:template match="FORUMTHREADS" mode="c_userpage">
		<xsl:choose>
			<xsl:when test="THREAD">
				<xsl:apply-templates select="." mode="full_userpage"/>
				<br/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="$registered=1">
						<xsl:apply-templates select="." mode="empty_userpage"/>
						<br/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:copy-of select="$m_registertodiscussuserpage"/>
						<br/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="FORUMTHREADS" mode="empty_userpage">
	Author:		Tom Whitehouse
	Context:      /H2G2/ARTICLEFORUM/FORUMTHREADS
	Purpose:	 Calls the no threads FORUMTHREADS container
	-->
	<xsl:template match="FORUMTHREADS" mode="empty_userpage">
		<xsl:apply-templates select="." mode="empty_article"/>
	</xsl:template>
	<!--
	<xsl:template match="THREAD" mode="c_userpage">
	Author:		Tom Whitehouse
	Context:      /H2G2/ARTICLEFORUM/FORUMTHREADS/THREAD
	Purpose:	 Calls the THREAD container
	-->
	<xsl:template match="THREAD" mode="c_userpage">
		<xsl:apply-templates select="." mode="r_userpage"/>
	</xsl:template>
	<!--
	<xsl:template match="@THREADID" mode="t_threadtitlelinkup">
	Author:		Tom Whitehouse
	Context:      /H2G2/ARTICLEFORUM/FORUMTHREADS/THREAD/@THREADID
	Purpose:	 Creates the SUBJECT link for the THREAD
	-->
	<xsl:template match="@THREADID" mode="t_threadtitlelinkup">
		<a xsl:use-attribute-sets="maTHREADID_t_threadtitlelinkup">
			<xsl:attribute name="href"><xsl:value-of select="$root"/>F<xsl:value-of select="../@FORUMID"/>?thread=<xsl:value-of select="."/></xsl:attribute>
			<xsl:apply-templates select="../SUBJECT" mode="nosubject"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="ARTICLEFORUM" mode="c_viewallthreadsup">
	Author:		Tom Whitehouse
	Context:      /H2G2/ARTICLEFORUM
	Purpose:	 Calls the 'View all threads' link container
	-->
	<xsl:template match="ARTICLEFORUM" mode="c_viewallthreadsup">
		<xsl:if test="FORUMTHREADS/@MORE=1">
			<xsl:apply-templates select="." mode="r_viewallthreadsup"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="ARTICLEFORUM" mode="r_viewallthreadsup">
	Author:		Tom Whitehouse
	Context:      /H2G2/ARTICLEFORUM
	Purpose:	 Creates the 'View all threads' link
	-->
	<xsl:template match="ARTICLEFORUM" mode="r_viewallthreadsup">
		<a xsl:use-attribute-sets="maFORUMID_MoreConv" href="{$root}F{FORUMTHREADS/@FORUMID}">
			<xsl:copy-of select="$m_clickmoreuserpageconv"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="ARTICLEFORUM" mode="r_viewallthreadsup">
	Author:		Tom Whitehouse
	Context:      /H2G2/ARTICLEFORUM/FORUMTHREADS/THREAD/@THREADID
	Purpose:	 Creates 'Date posted' link
	-->
	<xsl:template match="@THREADID" mode="t_threaddatepostedlinkup">
		<a xsl:use-attribute-sets="maTHREADID_t_threaddatepostedlinkup">
			<xsl:attribute name="HREF"><xsl:value-of select="$root"/>F<xsl:value-of select="."/>?thread=<xsl:value-of select="../@THREADID"/>&amp;latest=1</xsl:attribute>
			<xsl:apply-templates select="../DATEPOSTED"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="@FORUMID" mode="c_leaveamessage">
	Author:		Tom Whitehouse
	Context:      /H2G2/ARTICLEFORUM/FORUMTHREADS/@FORUMID
	Purpose:	container for the 'leave this user a message link'
	-->
	<xsl:template match="@FORUMID" mode="c_leavemessage">
		<xsl:if test="not($ownerisviewer=1)">
			<xsl:apply-templates select="." mode="r_leavemessage"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="@FORUMID" mode="r_leaveamessage">
	Author:		Tom Whitehouse
	Context:      /H2G2/ARTICLEFORUM/FORUMTHREADS/@FORUMID
	Purpose:	the 'leave this user a message link'
	-->
	
	<xsl:template match="@FORUMID" mode="r_leavemessage">
		<a xsl:use-attribute-sets="maFORUMID_r_leavemessage">
			<xsl:attribute name="href"><xsl:call-template name="sso_message_signin"/></xsl:attribute>
			<xsl:copy-of select="$m_leaveusermessage"/>
		</a>
	</xsl:template>
	<!--======================================================
	=================REFERENCES OBJECT=====================
	========================================================-->
	<!--
	<xsl:template match="REFERENCES" mode="c_userpagerefs">
	Author:		Tom Whitehouse
	Context:      /H2G2/REFERENCES
	Purpose:	 Calls the REFERENCES container
	-->
	<xsl:template match="REFERENCES" mode="c_userpagerefs">
		<xsl:apply-templates select="." mode="r_userpagerefs"/>
	</xsl:template>
	<!--
	<xsl:template match="ENTRIES" mode="c_userpagerefs">
	Author:		Tom Whitehouse
	Context:      /H2G2/REFERENCES/ENTRIES
	Purpose:	 Calls the ENTRIES container
	-->
	<xsl:template match="ENTRIES" mode="c_userpagerefs">
		<xsl:if test="$test_RefHasEntries">
			<xsl:apply-templates select="." mode="r_userpagerefs"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="USERS" mode="c_userpagerefs">
	Author:		Tom Whitehouse
	Context:      /H2G2/REFERENCES/USERS
	Purpose:	 Calls the USERS container
	-->
	<xsl:template match="USERS" mode="c_userpagerefs">
		<xsl:if test="$test_RefHasEntries">
			<xsl:apply-templates select="." mode="r_userpagerefs"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="REFERENCES/ENTRIES/ENTRYLINK" mode="c_userpagerefs">
	Author:		Tom Whitehouse
	Context:      /H2G2/REFERENCES/ENTRIES/ENTRYLINK
	Purpose:	 Calls the ENTRYLINK container
	-->
	<xsl:template match="REFERENCES/ENTRIES/ENTRYLINK" mode="c_userpagerefs">
		<xsl:variable name="id" select="@H2G2"/>
		<xsl:if test="(/H2G2/ARTICLE/GUIDE//LINK[@H2G2=$id]) or (/H2G2/ARTICLE/GUIDE//LINK[@DNAID=$id])">
			<xsl:apply-templates select="." mode="r_userpagerefs"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="ENTRYLINK" mode="r_userpagerefs">
	Author:		Tom Whitehouse
	Context:      /H2G2/REFERENCES/ENTRIES/ENTRYLINK
	Purpose:	 Creates the ENTRYLINK link
	-->
	<xsl:template match="ENTRYLINK" mode="r_userpagerefs">
		<a href="{$root}A{H2G2ID}" use-attribute-sets="mENTRYLINK_r_userpagerefs">
			<xsl:value-of select="SUBJECT"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="REFERENCES/USERS/USERLINK" mode="c_userpagerefs">
	Author:		Tom Whitehouse
	Context:      /H2G2/REFERENCES/USERS/USERLINK
	Purpose:	 Calls the USERLINK container
	-->
	<xsl:template match="REFERENCES/USERS/USERLINK" mode="c_userpagerefs">
		<xsl:variable name="id" select="@H2G2"/>
		<xsl:if test="(/H2G2/ARTICLE/GUIDE//LINK[@H2G2=$id]) or (/H2G2/ARTICLE/GUIDE//LINK[@BIO=$id])">
			<xsl:apply-templates select="." mode="r_userpagerefs"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="USERLINK" mode="r_userpagerefs">
	Author:		Tom Whitehouse
	Context:      /H2G2/REFERENCES/USERS/USERLINK
	Purpose:	 Creates the USERLINK link
	-->
	<xsl:template match="USERLINK" mode="r_userpagerefs">
		<a href="{$root}U{USERID}" use-attribute-sets="mUSERLINK_r_userpagerefs">
			<xsl:value-of select="USERNAME"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="EXTERNAL" mode="c_userpagerefsbbc">
	Author:		Tom Whitehouse
	Context:      /H2G2/REFERENCES/EXTERNAL
	Purpose:	 Calls the EXTERNAL container for other bbc pages
	-->
	<xsl:template match="EXTERNAL" mode="c_userpagerefsbbc">
		<xsl:if test="EXTERNALLINK[starts-with(OFFSITE, 'http://www.bbc.co.uk') or starts-with(OFFSITE, 'http://news.bbc.co.uk')]">
			<xsl:apply-templates select="." mode="r_userpagerefsbbc"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="USERLINK" mode="r_userpagerefs">
	Author:		Tom Whitehouse
	Context:      /H2G2/REFERENCES/EXTERNAL/EXTERNALLINK
	Purpose:	 Calls the EXTERNALLINK container for other bbc pages
	-->
	<xsl:template match="EXTERNALLINK" mode="c_userpagerefsbbc">
		<xsl:variable name="id" select="@UINDEX"/>
		<xsl:if test="(/H2G2/ARTICLE/GUIDE//LINK[@UINDEX=$id])">
			<xsl:apply-templates select="." mode="r_userpagerefsbbc"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="EXTERNALLINK" mode="r_userpagerefsbbc">
	Author:		Tom Whitehouse
	Context:      /H2G2/REFERENCES/EXTERNAL/EXTERNALLINK
	Purpose:	 Creates the EXTERNALLINK links for other bbc pages
	-->
	<xsl:template match="EXTERNALLINK" mode="r_userpagerefsbbc">
		<a xsl:use-attribute-sets="mEXTERNALLINK_r_userpagerefsbbc">
			<xsl:apply-templates select="/H2G2/ARTICLE/GUIDE//LINK[@UINDEX=current()/@UINDEX]" mode="justattributes"/>
			<xsl:value-of select="TITLE"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="EXTERNAL" mode="c_userpagerefsnotbbc">
	Author:		Tom Whitehouse
	Context:      /H2G2/REFERENCES/EXTERNAL
	Purpose:	 Calls the EXTERNAL container for non bbc pages
	-->
	<xsl:template match="EXTERNAL" mode="c_userpagerefsnotbbc">
		<xsl:if test="EXTERNALLINK[not(starts-with(OFFSITE, 'http://www.bbc.co.uk') or starts-with(OFFSITE, 'http://news.bbc.co.uk'))]">
			<xsl:apply-templates select="." mode="r_userpagerefsnotbbc"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="EXTERNALLINK" mode="c_userpagerefsnotbbc">
	Author:		Tom Whitehouse
	Context:      /H2G2/REFERENCES/EXTERNAL/EXTERNALLINK
	Purpose:	 Calls the EXTERNALLINK container for non bbc pages
	-->
	<xsl:template match="EXTERNALLINK" mode="c_userpagerefsnotbbc">
		<xsl:variable name="id" select="@UINDEX"/>
		<xsl:if test="(/H2G2/ARTICLE/GUIDE//LINK[@UINDEX=$id])">
			<xsl:apply-templates select="." mode="r_userpagerefsnotbbc"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="EXTERNALLINK" mode="r_userpagerefsnotbbc">
	Author:		Tom Whitehouse
	Context:      /H2G2/REFERENCES/EXTERNAL/EXTERNALLINK
	Purpose:	 Creates the EXTERNALLINK links for non bbc pages
	-->
	<xsl:template match="EXTERNALLINK" mode="r_userpagerefsnotbbc">
		<a xsl:use-attribute-sets="mEXTERNALLINK_r_userpagerefsnotbbc">
			<xsl:apply-templates select="/H2G2/ARTICLE/GUIDE//LINK[@UINDEX=current()/@UINDEX]" mode="justattributes"/>
			<xsl:value-of select="TITLE"/>
		</a>
	</xsl:template>
	<xsl:template name="insert-articleerror">
		<xsl:if test="/H2G2/ARTICLE/ERROR">
			<xsl:choose>
				<xsl:when test="$ownerisviewer = 1">
					<xsl:call-template name="m_pserrorowner"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="m_pserrorviewer"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="WATCHED-USER-LIST" mode="c_userpage">
	Author:		Andy Harris
	Context:      /H2G2/WATCHED-USER-LIST
	Purpose:	 Calls the WATCHED-USER-LIST container
	-->
	<xsl:template match="WATCHED-USER-LIST" mode="c_userpage">
		<form method="GET" action="{$root}Watch{@USERID}">
			<xsl:apply-templates select="." mode="r_userpage"/>
			<xsl:if test="/H2G2/PARAMS/PARAM[NAME='s_bd']">
				<input type="submit" name="delete" value="Delete Marked Names"/>
				<input type="hidden" name="s_bd" value="yes"/>
			</xsl:if>
		</form>
	</xsl:template>
	<!--
	<xsl:template match="WATCHED-USER-LIST" mode="t_introduction">
	Author:		Andy Harris
	Context:      /H2G2/WATCHED-USER-LIST
	Purpose:	 Creates the correct WATCHED-USER-LIST introduction
	-->
	<xsl:template match="WATCHED-USER-LIST" mode="t_introduction">
		<xsl:choose>
			<xsl:when test="$ownerisviewer=1">
				<xsl:choose>
					<xsl:when test="USER">
						<xsl:copy-of select="$m_namesonyourfriendslist"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:copy-of select="$m_youremptyfriendslist"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="USER">
						<xsl:copy-of select="$m_friendslistofuser"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="/H2G2/PAGE-OWNER/USER" mode="username" />
						<xsl:copy-of select="$m_hasntaddedfriends"/>
						<br/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="WATCHED-USER-LIST" mode="c_deletemany">
	Author:		Andy Harris
	Context:      /H2G2/WATCHED-USER-LIST
	Purpose:	 Calls the 'Delete many friends from list' link container
	-->
	<xsl:template match="WATCHED-USER-LIST" mode="c_deletemany">
		<xsl:if test="not(/H2G2/PARAMS/PARAM[NAME='s_bd']) and (USER) and ($ownerisviewer=1)">
			<xsl:apply-templates select="." mode="r_deletemany"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="WATCHED-USER-LIST" mode="r_deletemany">
	Author:		Andy Harris
	Context:      /H2G2/WATCHED-USER-LIST
	Purpose:	 Creates the 'Delete many friends from list' link
	-->
	<xsl:template match="WATCHED-USER-LIST" mode="r_deletemany">
		<a href="{$root}Watch{@USERID}?s_bd=yes" xsl:use-attribute-sets="mWATCHED-USER-LIST_r_deletemany">
			<xsl:copy-of select="$m_deletemultiplefriends"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="WATCHED-USER-LIST" mode="c_friendsjournals">
	Author:		Andy Harris
	Context:      /H2G2/WATCHED-USER-LIST
	Purpose:	 Calls the 'View friends journals' link container
	-->
	<xsl:template match="WATCHED-USER-LIST" mode="c_friendsjournals">
		<xsl:if test="USER">
			<xsl:apply-templates select="." mode="r_friendsjournals"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="WATCHED-USER-LIST" mode="r_friendsjournals">
	Author:		Andy Harris
	Context:      /H2G2/WATCHED-USER-LIST
	Purpose:	 Creates the 'View friends journals' link
	-->
	<xsl:template match="WATCHED-USER-LIST" mode="r_friendsjournals">
		<a href="{$root}Watch{/H2G2/PAGE-OWNER/USER/USERID}?full=1" xsl:use-attribute-sets="mWATCHED-USER-LIST_r_friendsjournals">
			<xsl:copy-of select="$m_journalentriesbyfriends"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="USER" mode="c_watcheduser">
	Author:		Andy Harris
	Context:      /H2G2/WATCHED-USER-LIST/USER
	Purpose:	 Calls the watched USER container
	-->
	<xsl:template match="USER" mode="c_watcheduser">
		<xsl:apply-templates select="." mode="r_watcheduser"/>
	</xsl:template>
	<!--
	<xsl:template match="USER" mode="t_watchedusername">
	Author:		Andy Harris
	Context:      /H2G2/WATCHED-USER-LIST/USER
	Purpose:	 Creates the watched USER username
	-->
	<xsl:template match="USER" mode="t_watchedusername">
		<xsl:choose>
			<xsl:when test="string-length(USERNAME) = 0">
				<xsl:value-of select="concat($m_user,' ')"/>
				<xsl:value-of select="USERID"/>
			</xsl:when>
			<xsl:otherwise>
				<!-- <xsl:value-of select="USERNAME"/> -->
				<xsl:apply-templates select="." mode="username"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="USER" mode="t_watcheduserpage">
	Author:		Andy Harris
	Context:      /H2G2/WATCHED-USER-LIST/USER
	Purpose:	 Creates the watched USER personal space link
	-->
	<xsl:template match="USER" mode="t_watcheduserpage">
		<a href="{$root}U{USERID}" xsl:use-attribute-sets="mUSER_t_watcheduserpage">
			<xsl:copy-of select="$m_personalspace"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="USER" mode="t_watcheduserjournal">
	Author:		Andy Harris
	Context:      /H2G2/WATCHED-USER-LIST/USER
	Purpose:	 Creates the watched USER journal link
	-->
	<xsl:template match="USER" mode="t_watcheduserjournal">
		<a href="{$root}MJ{USERID}?Journal={JOURNAL}" xsl:use-attribute-sets="mUSER_t_watcheduserjournal">
			<xsl:copy-of select="$m_journalpostings"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="USER" mode="c_watcheduserdelete">
	Author:		Andy Harris
	Context:      /H2G2/WATCHED-USER-LIST/USER
	Purpose:	 Calls the 'Delete this user from list' link container
	-->
	<xsl:template match="USER" mode="c_watcheduserdelete">
		<xsl:if test="$ownerisviewer=1">
			<xsl:apply-templates select="." mode="r_watcheduserdelete"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="USER" mode="r_watcheduserdelete">
	Author:		Andy Harris
	Context:      /H2G2/WATCHED-USER-LIST/USER
	Purpose:	 Creates the 'Delete this user from list' link
	-->
	<xsl:template match="USER" mode="r_watcheduserdelete">
		<a href="{$root}Watch{../@USERID}?delete=yes&amp;duser={USERID}" xsl:use-attribute-sets="mUSER_r_watcheduserdelete">
			<xsl:copy-of select="$m_delete"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="PRIVATEFORUM" mode="c_userpage">
	Author:		Tom Whitehouse
	Context:      /H2G2/PRIVATEFORUM
	Purpose:	Test to see if the page should be displaying a PRIVATEFORUM object
	-->
	<xsl:template match="PRIVATEFORUM" mode="c_userpage">
		<xsl:if test="FORUMTHREADS/@CANREAD=1">
			<xsl:apply-templates select="." mode="r_userpage"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="PRIVATEFORUM" mode="t_intromessage">
	Author:		Tom Whitehouse
	Context:      /H2G2/PRIVATEFORUM
	Purpose:	Test to decide which introduction to add to the private forum section
	-->
	<xsl:template match="PRIVATEFORUM" mode="t_intromessage">
		<xsl:choose>
			<xsl:when test="not($ownerisviewer=1) and (/H2G2/VIEWING-USER/USER/GROUPS/EDITOR) and (FORUMTHREADS/THREAD)">
				<xsl:copy-of select="$m_privateforumviewer"/>
			</xsl:when>
			<xsl:when test="not($ownerisviewer=1) and (/H2G2/VIEWING-USER/USER/GROUPS/EDITOR) and not(FORUMTHREADS/THREAD)">
				<xsl:copy-of select="$m_privateforumviewerempty"/>
			</xsl:when>
			<xsl:when test="FORUMTHREADS/THREAD">
				<xsl:copy-of select="$m_privateforumfull"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy-of select="$m_privateforumempty"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="THREAD" mode="c_privateforum">
	Author:		Tom Whitehouse
	Context:      /H2G2/PRIVATEFORUM/FORUMTHREADS/THREAD
	Purpose:	calls the individual thread container for a private message forum
	-->
	<xsl:template match="THREAD" mode="c_privateforum">
		<xsl:apply-templates select="." mode="r_privateforum"/>
	</xsl:template>
	<!--
	<xsl:template match="SUBJECT" mode="t_privatemessage">
	Author:		Tom Whitehouse
	Context:      /H2G2/PRIVATEFORUM/FORUMTHREADS/THREAD/SUBJECT
	Purpose:	 Creates the subject link in the Private Messages Forum
	-->
	<xsl:template match="SUBJECT" mode="t_privatemessage">
		<a href="{$root}F{../@FORUMID}?thread={../@THREADID}" xsl:use-attribute-sets="mSUBJECT_t_privatemessage">
			<xsl:value-of select="."/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="DATEPOSTED" mode="t_privatemessage">
	Author:		Tom Whitehouse
	Context:      /H2G2/PRIVATEFORUM/FORUMTHREADS/THREAD/DATEPOSTED
	Purpose:	Creates the date posted link in the Private Messages Forum 
	-->
	<xsl:template match="DATEPOSTED" mode="t_privatemessage">
		<a href="{$root}F{../@FORUMID}?thread={../@THREADID}&amp;latest=1" xsl:use-attribute-sets="mDATEPOSTED_t_privatemessage">
			<xsl:apply-templates select="."/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="DATEPOSTED" mode="t_privatemessage">
	Author:		Tom Whitehouse
	Context:      /H2G2/PRIVATEFORUM
	Purpose:	Creates the leave private message link
	-->
	<xsl:template match="PRIVATEFORUM" mode="t_leavemessagelink">
		<xsl:if test="not($ownerisviewer = 1)">
			<a xsl:use-attribute-sets="mPRIVATEFORUM_t_leavemessagelink">
				<xsl:attribute name="href"><xsl:call-template name="sso_pf_signin"/></xsl:attribute>
				<xsl:copy-of select="$m_leaveprivatemessage"/>
			</a>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="USERCLUBACTIONLIST" mode="c_userpage">
	Author:		Andy Harris
	Context:      /H2G2/USERCLUBACTIONLIST
	Purpose:	 Calls the container for the USERCLUBACTIONLIST 
	-->
	<xsl:template match="USERCLUBACTIONLIST" mode="c_userpage">
		<xsl:apply-templates select="." mode="r_userpage"/>
	</xsl:template>
	<!--
	<xsl:template match="USERCLUBACTIONLIST" mode="c_yourrequests">
	Author:		Andy Harris
	Context:      /H2G2/USERCLUBACTIONLIST
	Purpose:	 Calls the container for the user's club requests 
	-->
	<xsl:template match="USERCLUBACTIONLIST" mode="c_yourrequests">
		<xsl:if test="CLUBACTION[@RESULT='stored' and (@ACTIONTYPE='joinmember' or @ACTIONTYPE='joinowner')]">
			<xsl:apply-templates select="." mode="r_yourrequests"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="USERCLUBACTIONLIST" mode="c_invitations">
	Author:		Andy Harris
	Context:      /H2G2/USERCLUBACTIONLIST
	Purpose:	 Calls the container for the user's club invitations 
	-->
	<xsl:template match="USERCLUBACTIONLIST" mode="c_invitations">
		<xsl:if test="CLUBACTION[@RESULT='stored' and (@ACTIONTYPE='invitemember' or @ACTIONTYPE='inviteowner')]">
			<xsl:apply-templates select="." mode="r_invitations"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="USERCLUBACTIONLIST" mode="c_previousactions">
	Author:		Andy Harris
	Context:      /H2G2/USERCLUBACTIONLIST
	Purpose:	 Calls the container for the user's previous actions 
	-->
	<xsl:template match="USERCLUBACTIONLIST" mode="c_previousactions">
		<xsl:if test="CLUBACTION[@RESULT!='stored']">
			<xsl:apply-templates select="." mode="r_previousactions"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="CLUBACTION" mode="c_yourrequests">
	Author:		Andy Harris
	Context:      /H2G2/USERCLUBACTIONLIST/CLUBACTION
	Purpose:	 Calls the container for the each individual user club request  
	-->
	<xsl:template match="CLUBACTION" mode="c_yourrequests">
		<xsl:if test="@RESULT='stored' and (@ACTIONTYPE='joinmember' or @ACTIONTYPE='joinowner')">
			<xsl:apply-templates select="." mode="r_yourrequests"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="CLUBACTION" mode="c_invitations">
	Author:		Andy Harris
	Context:      /H2G2/USERCLUBACTIONLIST/CLUBACTION
	Purpose:	 Calls the container for the each individual user club invitation  
	-->
	<xsl:template match="CLUBACTION" mode="c_invitations">
		<xsl:if test="@RESULT='stored' and (@ACTIONTYPE='invitemember' or @ACTIONTYPE='inviteowner')">
			<xsl:apply-templates select="." mode="r_invitations"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="CLUBACTION" mode="c_previousactions">
	Author:		Andy Harris
	Context:      /H2G2/USERCLUBACTIONLIST/CLUBACTION
	Purpose:	 Calls the container for the each individual previous user action
	-->
	<xsl:template match="CLUBACTION" mode="c_previousactions">
		<xsl:if test="@RESULT!='stored'">
			<xsl:apply-templates select="." mode="r_previousactions"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="@ACTIONTYPE" mode="t_actiondescription">
	Author:		Andy Harris
	Context:      /H2G2/USERCLUBACTIONLIST/CLUBACTION/@ACTIONTYPE
	Purpose:	 Creates the correct descriptive text to describe the action
	-->
	<xsl:template match="@ACTIONTYPE" mode="t_actiondescription">
		<xsl:choose>
			<xsl:when test=".='joinmember'">
				<xsl:copy-of select="$m_joinmember2ndperson"/>
			</xsl:when>
			<xsl:when test=".='joinowner'">
				<xsl:copy-of select="$m_joinowner2ndperson"/>
			</xsl:when>
			<xsl:when test=".='invitemember'">
				<xsl:copy-of select="$m_invitemember2ndperson"/>
			</xsl:when>
			<xsl:when test=".='inviteowner'">
				<xsl:copy-of select="$m_inviteowner2ndperson"/>
			</xsl:when>
			<xsl:when test=".='ownerresignsmember'">
				<xsl:copy-of select="$m_ownerresignsmember2ndperson"/>
			</xsl:when>
			<xsl:when test=".='ownerresignscompletely'">
				<xsl:copy-of select="$m_ownerresignscompletely2ndperson"/>
			</xsl:when>
			<xsl:when test=".='memberresigns'">
				<xsl:copy-of select="$m_memberresigns2ndperson"/>
			</xsl:when>
			<xsl:when test=".='demoteownertomember'">
				<xsl:copy-of select="$m_demoteownertomember2ndperson"/>
			</xsl:when>
			<xsl:when test=".='removeowner'">
				<xsl:copy-of select="$m_removeowner2ndperson"/>
			</xsl:when>
			<xsl:when test=".='removemember'">
				<xsl:copy-of select="$m_removemember2ndperson"/>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="CLUBNAME" mode="t_clublink">
	Author:		Andy Harris
	Context:      /H2G2/USERCLUBACTIONLIST/CLUBACTION/CLUBNAME
	Purpose:	 Creates the club name link
	-->
	<xsl:template match="CLUBNAME" mode="t_clublink">
		<a href="{$root}G{../@CLUBID}" xsl:use-attribute-sets="mCLUBNAME_t_clublink">
			<xsl:value-of select="."/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="USERNAME" mode="t_userlink">
	Author:		Andy Harris
	Context:      /H2G2/USERCLUBACTIONLIST/CLUBACTION/COMPLETEUSER/USER/USERNAME
	Purpose:	 Creates the user name link
	-->
	<xsl:template match="USERNAME" mode="t_userlink">
		<a href="{$root}U{../USERID}" xsl:use-attribute-sets="mUSERNAME_t_userlink">
			<xsl:value-of select="."/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="DATEREQUESTED" mode="t_date">
	Author:		Andy Harris
	Context:      /H2G2/USERCLUBACTIONLIST/CLUBACTION/DATEREQUESTED
	Purpose:	 Creates the date text
	-->
	<xsl:template match="DATEREQUESTED" mode="t_date">
		<xsl:apply-templates select="DATE"/>
	</xsl:template>
	<!--
	<xsl:template match="@ACTIONID" mode="t_acceptlink">
	Author:		Andy Harris
	Context:      /H2G2/USERCLUBACTIONLIST/CLUBACTION/@ACTIONID
	Purpose:	 Creates the 'Accept' link
	-->
	<xsl:template match="@ACTIONID" mode="t_acceptlink">
		<a href="Club{../@CLUBID}?action=process&amp;actionid={.}&amp;result=1" xsl:use-attribute-sets="maACTIONID_t_acceptlink">
			<xsl:copy-of select="$m_acceptlink"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="@ACTIONID" mode="t_rejectlink">
	Author:		Andy Harris
	Context:      /H2G2/USERCLUBACTIONLIST/CLUBACTION/@ACTIONID
	Purpose:	 Creates the 'Reject' link
	-->
	<xsl:template match="@ACTIONID" mode="t_rejectlink">
		<a href="Club{../@CLUBID}?action=process&amp;actionid={.}&amp;result=2" xsl:use-attribute-sets="maACTIONID_t_rejectlink">
			<xsl:copy-of select="$m_rejectlink"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="CLUBACTION" mode="c_resulttext">
	Author:		Andy Harris
	Context:      /H2G2/USERCLUBACTIONLIST/CLUBACTION
	Purpose:	 Calls the correct action result container
	-->
	<xsl:template match="CLUBACTION" mode="c_resulttext">
		<xsl:choose>
			<xsl:when test="@RESULT='complete' and (COMPLETEUSER/USER/USERID = ACTIONUSER/USER/USERID)">
				<xsl:apply-templates select="." mode="auto_resulttext"/>
			</xsl:when>
			<xsl:when test="@RESULT='complete' and (COMPLETEUSER/USER/USERID != ACTIONUSER/USER/USERID) and (@ACTIONTYPE='joinmember' or @ACTIONTYPE='joinowner')">
				<xsl:apply-templates select="." mode="accept_resulttext"/>
			</xsl:when>
			<xsl:when test="@RESULT='complete' and (COMPLETEUSER/USER/USERID != ACTIONUSER/USER/USERID) and not(@ACTIONTYPE='joinmember' or @ACTIONTYPE='joinowner')">
				<xsl:apply-templates select="." mode="by_resulttext"/>
			</xsl:when>
			<xsl:when test="@RESULT='declined' and (COMPLETEUSER/USER/USERID != ACTIONUSER/USER/USERID) and @ACTIONTYPE='invitemember'">
				<xsl:apply-templates select="." mode="selfdecline_resulttext"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="." mode="decline_resulttext"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- ************************************************ -->
	<xsl:template match="LINKS" mode="c_userpage">
		<xsl:apply-templates select="." mode="r_userpage"/>
	</xsl:template>
	<xsl:template match="LINKS" mode="t_folderslink">
		<a href="{$root}managelinks" xsl:use-attribute-sets="mLINKS_t_folderslink">
			<xsl:copy-of select="$m_viewfolders"/>
		</a>
	</xsl:template>
	<!-- *********************************** -->
	<xsl:variable name="m_userpagelinkclipped">This userpage has been added to your clippings</xsl:variable>
	<xsl:variable name="m_userpagealreadyclipped">You have already added this userpage to your clippings</xsl:variable>
	<xsl:template match="CLIP" mode="c_userpageclipped">
		<xsl:apply-templates select="." mode="r_userpageclipped"/>
	</xsl:template>
	<xsl:template match="CLIP" mode="r_userpageclipped">
		<xsl:choose>
			<xsl:when test="@RESULT='success'">
				<xsl:copy-of select="$m_userpagelinkclipped"/>
			</xsl:when>
			<xsl:when test="@RESULT='alreadylinked'">
				<xsl:copy-of select="$m_userpagealreadyclipped"/>
			</xsl:when>
			<xsl:when test="@RESULT='alreadylinkedhidden'">
				<xsl:copy-of select="$m_userpagealreadyclipped"/>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="ARTICLE" mode="c_taguser">
		<xsl:if test="$ownerisviewer or $test_IsEditor">
			<xsl:apply-templates select="." mode="r_taguser"/>
		</xsl:if>
	</xsl:template>
	<xsl:template match="ARTICLE" mode="r_taguser">
		<a href="{$root}TagItem?tagitemtype=3001&amp;tagitemid={/H2G2/ARTICLE/ARTICLEINFO/H2G2ID}" xsl:use-attribute-sets="mARTICLE_r_taguser">
			<xsl:copy-of select="$m_taguser"/>
		</a>
	</xsl:template>
	<!--======================================================
	=================USERMYCLUBS OBJECT=====================
	========================================================-->
	<xsl:template match="USERMYCLUBS" mode="c_userpage">
		<xsl:apply-templates select="." mode="r_userpage"/>
	</xsl:template>
	<xsl:template match="CLUBSSUMMARY" mode="c_userpage">
		<xsl:apply-templates select="." mode="r_userpage"/>
	</xsl:template>
	<xsl:template match="CLUBSSUMMARY" mode="t_more">
		<a href="{$root}umc" xsl:use-attribute-sets="mCLUBSSUMMARY_t_more">
			<xsl:copy-of select="$m_userpagemoreclubs"/>
		</a>
	</xsl:template>
	<xsl:template match="CLUB" mode="c_userpage">
		<xsl:if test="position() &lt; $clublimitentries">
			<xsl:apply-templates select="." mode="r_userpage"/>
		</xsl:if>
	</xsl:template>
	<xsl:template match="NAME" mode="t_clublink">
		<a href="{$root}G{../@ID}" xsl:use-attribute-sets="mNAME_t_clublink">
			<xsl:value-of select="."/>
		</a>
	</xsl:template>
	<xsl:attribute-set name="mCLUBSSUMMARY_t_more" use-attribute-sets="userpagelinks"/>
	<xsl:attribute-set name="mNAME_t_clublink" use-attribute-sets="userpagelinks"/>
	<xsl:attribute-set name="mGROUP_t_groupsubject" use-attribute-sets="userpagelinks"/>
	<xsl:attribute-set name="mLINKS_t_folderslink" use-attribute-sets="userpagelinks"/>
</xsl:stylesheet>
