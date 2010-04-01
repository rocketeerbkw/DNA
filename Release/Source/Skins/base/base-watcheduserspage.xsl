<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<!--
	<xsl:template name="WATCHED-USERS_HEADER">
	Author:		Andy Harris
	Context:      H2G2
	Purpose:	 Creates the title for the page which sits in the html header
	-->
	<xsl:template name="WATCHED-USERS_HEADER">
		<xsl:apply-templates mode="header" select=".">
			<xsl:with-param name="title">
				<xsl:value-of select="$m_pagetitlestart"/>
				<xsl:if test="$ownerisviewer=1">
					<xsl:copy-of select="$m_my"/>
				</xsl:if>
				<xsl:copy-of select="$m_friends"/>
				<xsl:if test="$ownerisviewer=0">
					<xsl:copy-of select="$m_of"/>
					<xsl:apply-templates select="/H2G2/PAGE-OWNER/USER" mode="username" />
				</xsl:if>
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>
	<!--
	<xsl:template name="WATCHED-USERS_SUBJECT">
	Author:		Andy Harris
	Context:      H2G2
	Purpose:	 Creates the text for the subject
	-->
	<xsl:template name="WATCHED-USERS_SUBJECT">
		<xsl:call-template name="SUBJECTHEADER">
			<xsl:with-param name="text">
				<xsl:if test="$ownerisviewer=1">
					<xsl:copy-of select="$m_my"/>
				</xsl:if>
				<xsl:copy-of select="$m_friends"/>
				<xsl:if test="$ownerisviewer=0">
					<xsl:copy-of select="$m_of"/>
					<xsl:apply-templates select="/H2G2/PAGE-OWNER/USER" mode="username" />
				</xsl:if>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<!--
	<xsl:template match="WATCH-USER-RESULT" mode="c_wupage">
	Author:		Andy Harris
	Context:      H2G2
	Purpose:	 Calls the container for the result message if there is one
	-->
	<xsl:template match="WATCH-USER-RESULT" mode="c_wupage">
		<xsl:apply-templates select="." mode="r_wupage"/>
	</xsl:template>
	<!--
	<xsl:template match="WATCH-USER-RESULT" mode="r_wupage">
	Author:		Andy Harris
	Context:      H2G2/WATCH-USER-RESULT
	Purpose:	 Creates the result message if there is one
	-->
	<xsl:template match="WATCH-USER-RESULT" mode="r_wupage">
		<xsl:choose>
			<xsl:when test="@TYPE='delete'">
				<xsl:copy-of select="$m_deletedfollowingfriends"/>
				<xsl:apply-templates select="USER" mode="deletewatched"/>
			</xsl:when>
			<xsl:when test="@TYPE='remove'">
				<xsl:copy-of select="$m_someusersdeleted"/>
			</xsl:when>
			<xsl:when test="@TYPE='add'">
				<xsl:copy-of select="$m_namesaddedtofriends"/>
				<xsl:choose>
					<xsl:when test="string-length(USER/USERNAME) = 0">
						<xsl:value-of select="concat($m_user,' ')"/>
						<xsl:value-of select="USER/USERID"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="USER" mode="username" />
					</xsl:otherwise>
				</xsl:choose>
				<br/>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="WATCHED-USER-LIST" mode="c_wupage">
	Author:		Andy Harris
	Context:      /H2G2/WATCHED-USER-LIST
	Purpose:	 Calls the WATCHED-USER-LIST container
	-->
	<xsl:template match="WATCHED-USER-LIST" mode="c_wupage">
		<form method="GET" action="{$root}Watch{@USERID}">
			<xsl:apply-templates select="." mode="r_wupage"/>
			<xsl:if test="/H2G2/PARAMS/PARAM[NAME='s_bd']">
				<input type="submit" name="delete" value="Delete Marked Names"/>
				<input type="hidden" name="s_bd" value="yes"/>
			</xsl:if>
		</form>
	</xsl:template>
	<!--
	<xsl:template match="WATCHED-USER-LIST" mode="t_wupwatchedintroduction">
	Author:		Andy Harris
	Context:      /H2G2/WATCHED-USER-LIST
	Purpose:	 Creates the correct WATCHED-USER-LIST introduction
	-->
	<xsl:template match="WATCHED-USER-LIST" mode="t_wupwatchedintroduction">
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
	<xsl:template match="WATCHED-USER-LIST" mode="c_wupdeletemany">
	Author:		Andy Harris
	Context:      /H2G2/WATCHED-USER-LIST
	Purpose:	 Calls the 'Delete many friends from list' link container
	-->
	<xsl:template match="WATCHED-USER-LIST" mode="c_wupdeletemany">
		<xsl:if test="not(/H2G2/PARAMS/PARAM[NAME='s_bd']) and (USER) and ($ownerisviewer=1)">
			<xsl:apply-templates select="." mode="r_wupdeletemany"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="WATCHED-USER-LIST" mode="r_wupdeletemany">
	Author:		Andy Harris
	Context:      /H2G2/WATCHED-USER-LIST
	Purpose:	 Creates the 'Delete many friends from list' link
	-->
	<xsl:template match="WATCHED-USER-LIST" mode="r_wupdeletemany">
		<a href="{$root}Watch{@USERID}?s_bd=yes" xsl:use-attribute-sets="mWATCHED-USER-LIST_r_wupdeletemany">
			<xsl:copy-of select="$m_deletemultiplefriends"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="WATCHED-USER-LIST" mode="c_wupfriendsjournals">
	Author:		Andy Harris
	Context:      /H2G2/WATCHED-USER-LIST
	Purpose:	 Calls the 'View friends journals' link container
	-->
	<xsl:template match="WATCHED-USER-LIST" mode="c_wupfriendsjournals">
		<xsl:if test="USER">
			<xsl:apply-templates select="." mode="r_wupfriendsjournals"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="WATCHED-USER-LIST" mode="r_wupfriendsjournals">
	Author:		Andy Harris
	Context:      /H2G2/WATCHED-USER-LIST
	Purpose:	 Creates the 'View friends journals' link
	-->
	<xsl:template match="WATCHED-USER-LIST" mode="r_wupfriendsjournals">
		<a href="{$root}Watch{/H2G2/PAGE-OWNER/USER/USERID}?full=1" xsl:use-attribute-sets="mWATCHED-USER-LIST_r_wupfriendsjournals">
			<xsl:copy-of select="$m_journalentriesbyfriends"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="USER" mode="c_wupwatcheduser">
	Author:		Andy Harris
	Context:      /H2G2/WATCHED-USER-LIST/USER
	Purpose:	 Calls the watched USER container
	-->
	<xsl:template match="USER" mode="c_wupwatcheduser">
		<xsl:apply-templates select="." mode="r_wupwatcheduser"/>
	</xsl:template>
	<!--
	<xsl:template match="USER" mode="t_wupwatchedusername">
	Author:		Andy Harris
	Context:      /H2G2/WATCHED-USER-LIST/USER
	Purpose:	 Creates the watched USER username
	-->
	<xsl:template match="USER" mode="t_wupwatchedusername">
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
	<xsl:template match="USER" mode="t_wupwatcheduserpage">
	Author:		Andy Harris
	Context:      /H2G2/WATCHED-USER-LIST/USER
	Purpose:	 Creates the watched USER personal space link
	-->
	<xsl:template match="USER" mode="t_wupwatcheduserpage">
		<a href="{$root}U{USERID}" xsl:use-attribute-sets="mUSER_t_wupwatcheduserpage">
			<xsl:copy-of select="$m_personalspace"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="USER" mode="t_wupwatcheduserjournal">
	Author:		Andy Harris
	Context:      /H2G2/WATCHED-USER-LIST/USER
	Purpose:	 Creates the watched USER journal link
	-->
	<xsl:template match="USER" mode="t_wupwatcheduserjournal">
		<a href="{$root}MJ{USERID}?Journal={JOURNAL}" xsl:use-attribute-sets="mUSER_t_wupwatcheduserjournal">
			<xsl:copy-of select="$m_journalpostings"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="USER" mode="c_wupwatcheduserdelete">
	Author:		Andy Harris
	Context:      /H2G2/WATCHED-USER-LIST/USER
	Purpose:	 Calls the 'Delete this user from list' link container
	-->
	<xsl:template match="USER" mode="c_wupwatcheduserdelete">
		<xsl:if test="$ownerisviewer=1">
			<xsl:apply-templates select="." mode="r_wupwatcheduserdelete"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="USER" mode="r_wupwatcheduserdelete">
	Author:		Andy Harris
	Context:      /H2G2/WATCHED-USER-LIST/USER
	Purpose:	 Creates the 'Delete this user from list' link
	-->
	<xsl:template match="USER" mode="r_wupwatcheduserdelete">
		<a href="{$root}Watch{../@USERID}?delete=yes&amp;duser={USERID}" xsl:use-attribute-sets="mUSER_r_wupwatcheduserdelete">
			<xsl:copy-of select="$m_delete"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="WATCHING-USER-LIST" mode="c_wupage">
	Author:		Andy Harris
	Context:      /H2G2/WATCHING-USER-LIST
	Purpose:	 Calls the WATCHING-USER-LIST container
	-->
	<xsl:template match="WATCHING-USER-LIST" mode="c_wupage">
		<xsl:if test="/H2G2/ARTICLE/GUIDE/OPTIONS[@WATCHING-USERS=1]">
			<xsl:apply-templates select="." mode="r_wupage"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="WATCHING-USER-LIST" mode="t_wupwatchingintroduction">
	Author:		Andy Harris
	Context:      /H2G2/WATCHING-USER-LIST
	Purpose:	 Creates the correct watching user introduction
	-->
	<xsl:template match="WATCHING-USER-LIST" mode="t_wupwatchingintroduction">
		<xsl:choose>
			<xsl:when test="$ownerisviewer=1">
				<xsl:choose>
					<xsl:when test="USER">
						<xsl:call-template name="m_peoplewatchingyou"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="m_youhavenousers"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:if test="USER">
					<xsl:call-template name="m_userswatchingusers"/>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="USER" mode="c_wupwatchinguser">
	Author:		Andy Harris
	Context:      /H2G2/WATCHING-USER-LIST/USER
	Purpose:	 Calls the watching USER container
	-->
	<xsl:template match="USER" mode="c_wupwatchinguser">
		<xsl:apply-templates select="." mode="r_wupwatchinguser"/>
	</xsl:template>
	<!--
	<xsl:template match="USER" mode="t_watchingusername">
	Author:		Andy Harris
	Context:      /H2G2/WATCHING-USER-LIST/USER
	Purpose:	 Creates the watching USER name
	-->
	<xsl:template match="USER" mode="t_watchingusername">
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
	<xsl:template match="USER" mode="t_watchinguserpage">
	Author:		Andy Harris
	Context:      /H2G2/WATCHING-USER-LIST/USER
	Purpose:	 Creates the watching USER personal page link
	-->
	<xsl:template match="USER" mode="t_watchinguserpage">
		<a href="{$root}U{USERID}" xsl:use-attribute-sets="mUSER_t_wupwatchinguserpage">
			<xsl:copy-of select="$m_personalspace"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="USER" mode="t_watchinguserjournal">
	Author:		Andy Harris
	Context:      /H2G2/WATCHING-USER-LIST/USER
	Purpose:	 Creates the watching USER journal page link
	-->
	<xsl:template match="USER" mode="t_watchinguserjournal">
		<a href="{$root}MJ{USERID}?Journal={JOURNAL}" xsl:use-attribute-sets="mUSER_t_wupwatchinguserjournal">
			<xsl:copy-of select="$m_journalpostings"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="WATCHED-USER-POSTS" mode="c_wupage">
	Author:		Andy Harris
	Context:      /H2G2/WATCHED-USER-POSTS
	Purpose:	 Calls the WATCHED-USER-POSTS container
	-->
	<xsl:template match="WATCHED-USER-POSTS" mode="c_wupage">
		<xsl:apply-templates select="." mode="r_wupage"/>
	</xsl:template>
	<!--
	<xsl:template match="WATCHED-USER-POST" mode="c_wupage">
	Author:		Andy Harris
	Context:      /H2G2/WATCHED-USER-POSTS/WATCHED-USER-POST
	Purpose:	 Calls the WATCHED-USER-POST container or displays a no post message
	-->
	<xsl:template match="WATCHED-USER-POST" mode="c_wupage">
		<xsl:choose>
			<xsl:when test="not(.)">
				<xsl:apply-templates select="." mode="nopost_wupage"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="." mode="post_wupage"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="WATCHED-USER-POSTS" mode="c_threadblocks">
	Author:		Andy Harris
	Context:      /H2G2/WATCHED-USER-POSTS
	Purpose:	 Calls the container for the thread blocks navigation
	-->
	<xsl:template match="WATCHED-USER-POSTS" mode="c_threadblocks">
		<xsl:apply-templates select="." mode="r_threadblocks"/>
	</xsl:template>
	<!--
	<xsl:template match="WATCHED-USER-POSTS" mode="c_postblock">
	Author:		Andy Harris
	Context:      /H2G2/WATCHED-USER-POSTS
	Purpose:	 Calls the container for the individual thread block in the navigation
	-->
	<xsl:template match="WATCHED-USER-POSTS" mode="c_postblock">
		<xsl:param name="skip" select="0"/>
		<xsl:apply-templates select="." mode="displayblock">
			<xsl:with-param name="skip" select="$skip"/>
		</xsl:apply-templates>
		<xsl:if test="($skip + @COUNT) &lt; @TOTAL">
			<xsl:apply-templates select="." mode="c_postblock">
				<xsl:with-param name="skip" select="$skip + @COUNT"/>
			</xsl:apply-templates>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="WATCHED-USER-POSTS" mode="displayblock">
	Author:		Andy Harris
	Context:      /H2G2/WATCHED-USER-POSTS
	Purpose:	 Creates the individual thread block in the navigation
	-->
	<xsl:template match="WATCHED-USER-POSTS" mode="displayblock">
		<xsl:param name="skip"/>
		<xsl:param name="PostRange" select="concat(($skip + 1), ' - ', ($skip + @COUNT))"/>
		<xsl:param name="threadblockon">
			<xsl:apply-templates select="." mode="on_postblock">
				<xsl:with-param name="range" select="$PostRange"/>
			</xsl:apply-templates>
		</xsl:param>
		<xsl:param name="threadblockoff">
			<xsl:apply-templates select="." mode="off_postblock">
				<xsl:with-param name="range" select="$PostRange"/>
			</xsl:apply-templates>
		</xsl:param>
		<a href="{$root}Watch{@USERID}?skip={$skip}&amp;show={@COUNT}" xsl:use-attribute-sets="mWATCHED-USER-POSTS_c_postblock">
			<xsl:choose>
				<xsl:when test="@SKIPTO = $skip">
					<xsl:copy-of select="$threadblockon"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:copy-of select="$threadblockoff"/>
				</xsl:otherwise>
			</xsl:choose>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="WATCHED-USER-POSTS" mode="t_backwatcheduserpage">
	Author:		Andy Harris
	Context:      /H2G2/WATCHED-USER-POSTS
	Purpose:	 Creates the 'Back to watched user page' link
	-->
	<xsl:template match="WATCHED-USER-POSTS" mode="t_backwatcheduserpage">
		<a href="{$root}Watch{@USERID}" xsl:use-attribute-sets="mWATCHED-USER-POSTS_t_backwatcheduserpage">
			<xsl:copy-of select="$m_friendslist"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="USERNAME" mode="t_wupost">
	Author:		Andy Harris
	Context:      /H2G2/WATCHED-USER-POSTS/WATCHED-USER-POST/USER/USERNAME
	Purpose:	 Creates the USERNAME text
	-->
	<xsl:template match="USERNAME" mode="t_wupost">
		<a xsl:use-attribute-sets="mUSER_WatchUserPosted" href="{$root}U{../USERID}">
			<xsl:value-of select="."/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="DATEPOSTED/DATE" mode="t_wupost">
	Author:		Andy Harris
	Context:      /H2G2/WATCHED-USER-POSTS/WATCHED-USER-POST/DATEPOSTED/DATE
	Purpose:	 Creates the DATE text
	-->
	<xsl:template match="DATEPOSTED/DATE" mode="t_wupost">
		<xsl:apply-templates select="." mode="absolute"/>
	</xsl:template>
	<!--
	<xsl:template match="SUBJECT" mode="t_wupost">
	Author:		Andy Harris
	Context:      /H2G2/WATCHED-USER-POSTS/WATCHED-USER-POST/SUBJECT
	Purpose:	 Creates the SUBJECT text
	-->
	<xsl:template match="SUBJECT" mode="t_wupost">
		<xsl:apply-templates/>
	</xsl:template>
	<!--
	<xsl:template match="BODY" mode="t_wupost">
	Author:		Andy Harris
	Context:      /H2G2/WATCHED-USER-POSTS/WATCHED-USER-POST/BODY
	Purpose:	 Creates the BODY text
	-->
	<xsl:template match="BODY" mode="t_wupost">
		<xsl:apply-templates/>
	</xsl:template>
	<!--
	<xsl:template match="WATCHED-USER-POST" mode="t_wupostreplies">
	Author:		Andy Harris
	Context:      /H2G2/WATCHED-USER-POSTS/WATCHED-USER-POST
	Purpose:	 Creates the 'number of replies' text
	-->
	<xsl:template match="WATCHED-USER-POST" mode="t_wupostreplies">
		<xsl:choose>
			<xsl:when test="number(POSTCOUNT) &gt; 2">
				<a xsl:use-attribute-sets="mWATCH-USER-POSTS_Replies" href="F{@FORUMID}?thread={@THREADID}">
					<xsl:value-of select="number(POSTCOUNT)-1"/>
					<xsl:copy-of select="$m_replies"/>
				</a>
				<xsl:text> </xsl:text>
				<xsl:copy-of select="$m_latestreply"/>
				<a xsl:use-attribute-sets="mWATCH-USER-POSTS_LastReply" href="F{@FORUMID}?thread={@THREADID}&amp;latest=1">
					<xsl:apply-templates select="LASTPOSTED/DATE"/>
				</a>
			</xsl:when>
			<xsl:when test="number(POSTCOUNT) = 2">
				<xsl:copy-of select="$m_onereplyposted"/>
				<a xsl:use-attribute-sets="mWATCH-USER-POSTS_LastReply" href="F{@FORUMID}?thread={@THREADID}">
					<xsl:apply-templates select="LASTPOSTED/DATE"/>
				</a>
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy-of select="$m_noreplies"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="@POSTID" mode="t_wupostreply">
	Author:		Andy Harris
	Context:      /H2G2/WATCHED-USER-POSTS/WATCHED-USER-POST/@POSTID
	Purpose:	 Creates the 'reply to this post' link
	-->
	<xsl:template match="@POSTID" mode="t_wupostreply">
		<a href="{$root}AddThread?inreplyto={.}" target="_top" xsl:use-attribute-sets="maPOSTID_ReplyToPost">
			<xsl:copy-of select="$m_replytothispost"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="WATCHED-USER-POSTS" mode="c_firstpage">
	Author:		Andy Harris
	Context:      /H2G2/WATCHED-USER-POSTS
	Purpose:	 Calls the correct container for the 'First page' link
	-->
	<xsl:template match="WATCHED-USER-POSTS" mode="c_firstpage">
		<xsl:choose>
			<xsl:when test="not(@SKIPTO = 0)">
				<xsl:apply-templates select="." mode="link_firstpage"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="." mode="text_firstpage"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="WATCHED-USER-POSTS" mode="c_lastpage">
	Author:		Andy Harris
	Context:      /H2G2/WATCHED-USER-POSTS
	Purpose:	 Calls the correct container for the 'Last page' link
	-->
	<xsl:template match="WATCHED-USER-POSTS" mode="c_lastpage">
		<xsl:choose>
			<xsl:when test="@MORE = 1">
				<xsl:apply-templates select="." mode="link_lastpage"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="." mode="text_lastpage"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="WATCHED-USER-POSTS" mode="c_previouspage">
	Author:		Andy Harris
	Context:      /H2G2/WATCHED-USER-POSTS
	Purpose:	 Calls the correct container for the 'Previous page' link
	-->
	<xsl:template match="WATCHED-USER-POSTS" mode="c_previouspage">
		<xsl:choose>
			<xsl:when test="not(@SKIPTO = 0)">
				<xsl:apply-templates select="." mode="link_previouspage"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="." mode="text_previouspage"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="WATCHED-USER-POSTS" mode="c_nextpage">
	Author:		Andy Harris
	Context:      /H2G2/WATCHED-USER-POSTS
	Purpose:	 Calls the correct container for the 'Next page' link
	-->
	<xsl:template match="WATCHED-USER-POSTS" mode="c_nextpage">
		<xsl:choose>
			<xsl:when test="@MORE = 1">
				<xsl:apply-templates select="." mode="link_nextpage"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="." mode="text_nextpage"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="WATCHED-USER-POSTS" mode="link_firstpage">
	Author:		Andy Harris
	Context:      /H2G2/WATCHED-USER-POSTS
	Purpose:	 Creates the 'First page' link
	-->
	<xsl:template match="WATCHED-USER-POSTS" mode="link_firstpage">
		<a href="{$root}Watch{@USERID}?show={@COUNT}&amp;skip=0" xsl:use-attribute-sets="mWATCHED-USER-POSTS_link_firstpage">
			<xsl:copy-of select="$m_firstpagethreads"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="WATCHED-USER-POSTS" mode="link_lastpage">
	Author:		Andy Harris
	Context:      /H2G2/WATCHED-USER-POSTS
	Purpose:	 Creates the 'Last page' link
	-->
	<xsl:template match="WATCHED-USER-POSTS" mode="link_lastpage">
		<a href="{$root}Watch{@USERID}?show={@COUNT}&amp;skip={number(@TOTALTHREADS) - number(@COUNT)}" xsl:use-attribute-sets="mWATCHED-USER-POSTS_link_lastpage">
			<xsl:copy-of select="$m_lastpagethreads"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="WATCHED-USER-POSTS" mode="link_previouspage">
	Author:		Andy Harris
	Context:      /H2G2/WATCHED-USER-POSTS
	Purpose:	 Creates the 'Previous page' link
	-->
	<xsl:template match="WATCHED-USER-POSTS" mode="link_previouspage">
		<a href="{$root}Watch{@USERID}?show={@COUNT}&amp;skip={number(@SKIPTO) - number(@COUNT)}" xsl:use-attribute-sets="mWATCHED-USER-POSTS_link_previouspage">
			<xsl:copy-of select="$m_previouspagethreads"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="WATCHED-USER-POSTS" mode="link_nextpage">
	Author:		Andy Harris
	Context:      /H2G2/WATCHED-USER-POSTS
	Purpose:	 Creates the 'Next page' link
	-->
	<xsl:template match="WATCHED-USER-POSTS" mode="link_nextpage">
		<a href="{$root}Watch{@Watch}?show={@COUNT}&amp;skip={number(@SKIPTO) + number(@COUNT)}" xsl:use-attribute-sets="mWATCHED-USER-POSTS_link_nextpage">
			<xsl:copy-of select="$m_nextpagethreads"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="WATCHED-USER-POSTS" mode="text_firstpage">
	Author:		Andy Harris
	Context:      /H2G2/WATCHED-USER-POSTS
	Purpose:	 Creates the 'On first page' text
	-->
	<xsl:template match="WATCHED-USER-POSTS" mode="text_firstpage">
		<xsl:copy-of select="$m_nofirstpagethreads"/>
	</xsl:template>
	<!--
	<xsl:template match="WATCHED-USER-POSTS" mode="text_lastpage">
	Author:		Andy Harris
	Context:      /H2G2/WATCHED-USER-POSTS
	Purpose:	 Creates the 'On last page' text
	-->
	<xsl:template match="WATCHED-USER-POSTS" mode="text_lastpage">
		<xsl:copy-of select="$m_nolastpagethreads"/>
	</xsl:template>
	<!--
	<xsl:template match="WATCHED-USER-POSTS" mode="text_previouspage">
	Author:		Andy Harris
	Context:      /H2G2/WATCHED-USER-POSTS
	Purpose:	 Creates the 'No previous page' text
	-->
	<xsl:template match="WATCHED-USER-POSTS" mode="text_previouspage">
		<xsl:copy-of select="$m_nopreviouspagethreads"/>
	</xsl:template>
	<!--
	<xsl:template match="WATCHED-USER-POSTS" mode="text_nextpage">
	Author:		Andy Harris
	Context:      /H2G2/WATCHED-USER-POSTS
	Purpose:	 Creates the 'No next page' text
	-->
	<xsl:template match="WATCHED-USER-POSTS" mode="text_nextpage">
		<xsl:copy-of select="$m_nonextpagethreads"/>
	</xsl:template>
</xsl:stylesheet>
