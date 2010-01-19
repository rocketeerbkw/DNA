<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<!--
	<xsl:template name="MOREPOSTS_HEADER">
	Author:		Andy Harris
	Context:      H2G2
	Purpose:	 Creates the title for the page which sits in the html header
	-->
	<xsl:template name="MOREPOSTS_HEADER">
		<xsl:apply-templates mode="header" select=".">
			<xsl:with-param name="title">
				<xsl:value-of select="$m_pagetitlestart"/>
				<xsl:value-of select="$m_morepoststitle"/>
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>
	<!--
	<xsl:template name="MOREPOSTS_SUBJECT">
	Author:		Tom Whitehouse
	Context:      H2G2
	Purpose:	 Creates the text for the subject
	-->
	<xsl:template name="MOREPOSTS_SUBJECT">
		<xsl:call-template name="SUBJECTHEADER">
			<xsl:with-param name="text">
				<xsl:value-of select="$m_postingsby"/>
				<xsl:apply-templates select="POSTS" mode="ResearcherName"/>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<!--
	<xsl:template match="POSTS" mode="ResearcherName">
	Author:		Tom Whitehouse
	Context:      /H2G2/POSTS
	Purpose:	 Creates the name text for the subject area
	-->
	<xsl:template match="POSTS" mode="ResearcherName">
		<xsl:choose>
			<xsl:when test="POST-LIST">
				<xsl:value-of select="POST-LIST/USER/USERNAME"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$m_researcher"/>
				<xsl:value-of select="@USERID"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="POSTS" mode="c_morepostspage">
	Author:		Andy Harris
	Context:      /H2G2/POSTS
	Purpose:	 Calls the container for the POSTS object
	-->
	<xsl:template match="POSTS" mode="c_morepostspage">
		<xsl:apply-templates select="." mode="r_morepostspage"/>
	</xsl:template>
	<!--
	<xsl:template match="POSTS" mode="c_morepostlistempty">
	Author:		Andy Harris
	Context:      /H2G2/POSTS
	Purpose:	 Chooses the correct text for when the POSTS list is empty
	-->
	<xsl:template match="POSTS" mode="c_morepostlistempty">
		<xsl:if test="not(POST-LIST/POST)">
			<xsl:choose>
				<xsl:when test="$ownerisviewer = 1">
					<xsl:apply-templates select="." mode="owner_morepostlistempty"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="." mode="viewer_morepostlistempty"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="POST-LIST" mode="c_morepostspage">
	Author:		Andy Harris
	Context:      /H2G2/POSTS/POST-LIST
	Purpose:	 Chooses the correct container for the POST-LIST
	-->
	<xsl:template match="POST-LIST" mode="c_morepostspage">
		<xsl:choose>
			<xsl:when test="$ownerisviewer = 1">
				<xsl:apply-templates select="." mode="owner_morepostlist"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="." mode="viewer_morepostlist"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="POST" mode="c_morepostspage">
	Author:		Andy Harris
	Context:      /H2G2/POSTS/POST-LIST/POST
	Purpose:	 Calls the container for the POST object
	-->
	<xsl:template match="POST" mode="c_morepostspage">
		<xsl:apply-templates select="." mode="r_morepostspage"/>
	</xsl:template>
	<!--
	<xsl:template match="POSTS" mode="c_prevmoreposts">
	Author:		Andy Harris
	Context:      /H2G2/POSTS
	Purpose:	 Calls the container for the 'previous posts' link if there is one
	-->
	<xsl:template match="POSTS" mode="c_prevmoreposts">
		<xsl:if test="./POST-LIST[@SKIPTO &gt; 0]">
			<xsl:apply-templates select="." mode="r_prevmoreposts"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="POSTS" mode="r_prevmoreposts">
	Author:		Andy Harris
	Context:      /H2G2/POSTS
	Purpose:	 Creates the 'previous posts' link
	-->
	<xsl:template match="POSTS" mode="r_prevmoreposts">
		<a href="{$root}MP{./@USERID}?show={./POST-LIST/@COUNT}&amp;skip={number(./POST-LIST/@SKIPTO) - number(./POST-LIST/@COUNT)}">
			<xsl:value-of select="$m_newerpostings"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="POSTS" mode="c_nextmoreposts">
	Author:		Andy Harris
	Context:      /H2G2/POSTS
	Purpose:	 Calls the container for the 'more posts' link if there is one
	-->
	<xsl:template match="POSTS" mode="c_nextmoreposts">
		<xsl:if test="./POST-LIST[@MORE=1]">
			<xsl:apply-templates select="." mode="r_nextmoreposts"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="POSTS" mode="r_nextmoreposts">
	Author:		Andy Harris
	Context:      /H2G2/POSTS
	Purpose:	 Creates the 'more posts' link
	-->
	<xsl:template match="POSTS" mode="r_nextmoreposts">
		<a href="{$root}MP{./@USERID}?show={./POST-LIST/@COUNT}&amp;skip={number(./POST-LIST/@SKIPTO) + number(./POST-LIST/@COUNT)}">
			<xsl:value-of select="$m_olderpostings"/>
		</a>
	</xsl:template>
  <!--
	<xsl:template match="POSTS" mode="t_morepostsPSlink">
	Author:		Andy Harris
	Context:      /H2G2/POSTS
	Purpose:	 Creates the 'back to personal space' link
	-->
  <xsl:template match="POSTS" mode="t_morepostsPSlink">
    <a href="{$root}U{POST-LIST/USER/USERID}" xsl:use-attribute-sets="mPOSTS_morepostsPSlink">
      <xsl:copy-of select="$m_PostsBackTo"/>
      <xsl:value-of select="POST-LIST/USER/USERNAME"/>
      <xsl:copy-of select="$m_PostsPSpace"/>
    </a>
  </xsl:template>
  <!--
	<xsl:template match="POSTS" mode="t_moderateuserlink">
	Author:		Andy Harris
	Context:      /H2G2/POSTS
	Purpose:	 Creates the 'moderate user' link
	-->
  <xsl:template match="POSTS" mode="t_moderateuserlink">
    <xsl:if test="$test_IsModerator or $test_IsEditor">
        <a href="{$root}MemberList?UserID={POST-LIST/USER/USERID}" xsl:use-attribute-sets="mPOSTS_moderateuserlink">
        <xsl:copy-of select="$m_ModerateUser"/>
        <xsl:value-of select="POST-LIST/USER/USERNAME"/>
      </a>
      </xsl:if>
  </xsl:template>
  <!--
	<xsl:template match="POSTS" mode="t_morepostsPSlink">
	Author:		Andy Harris
	Context:      /H2G2/POSTS/POST-LIST/POST
	Purpose:	 Calls the container for the last user posting date or the no last posting text
	-->
	<xsl:template match="POST" mode="c_morepostspagepostdate">
		<xsl:choose>
			<xsl:when test="THREAD/LASTUSERPOST">
				<xsl:apply-templates select="." mode="r_morepostspagepostdate"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$m_noposting"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="SITEID" mode="t_morepostspage">
	Author:		Andy Harris
	Context:      /H2G2/POSTS/POST-LIST/POST/SITEID
	Purpose:	 Creates the text for the name of the originating site
	-->
	<xsl:template match="SITEID" mode="t_morepostspage">
		<xsl:value-of select="/H2G2/SITE-LIST/SITE[@ID=current()]/SHORTNAME"/>
	</xsl:template>
	<!--
	<xsl:template match="@THREADID" mode="t_morepostspagesubject">
	Author:		Andy Harris
	Context:      /H2G2/POSTS/POST-LIST/POST/THREAD/@THREADID
	Purpose:	 Creates the link to the thread using the SUBJECT
	-->
	<xsl:template match="@THREADID" mode="t_morepostspagesubject">
		<a href="{$root}F{../@FORUMID}?thread={.}" xsl:use-attribute-sets="mTHREADID_t_morepostssubject">
			<xsl:value-of select="../SUBJECT"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="POST" mode="r_morepostspagepostdate">
	Author:		Andy Harris
	Context:      /H2G2/POSTS/POST-LIST/POST
	Purpose:	 Calls the container for the DATE text
	-->
	<xsl:template match="POST" mode="r_morepostspagepostdate">
		<xsl:apply-templates select="THREAD/LASTUSERPOST/DATEPOSTED/DATE" mode="r_morepostspagepostdate"/>
	</xsl:template>
	<!--
	<xsl:template match="DATE" mode="r_morepostspagepostdate">
	Author:		Andy Harris
	Context:      /H2G2/POSTS/POST-LIST/POST/THREAD/LASTUSERPOST/DATEPOSTED/DATE
	Purpose:	 Creates the DATE text as a link to the posting in the thread
	-->
	<xsl:template match="DATE" mode="r_morepostspagepostdate">
		<a xsl:use-attribute-sets="mDATE_LastUserPost">
			<xsl:attribute name="HREF"><xsl:value-of select="$root"/>F<xsl:value-of select="../../../@FORUMID"/>?thread=<xsl:value-of select="../../../@THREADID"/>&amp;post=<xsl:value-of select="../../@POSTID"/>#p<xsl:value-of select="../../@POSTID"/></xsl:attribute>
			<xsl:apply-templates select="."/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="POST" mode="c_morepostspagepostlastreply">
	Author:		Andy Harris
	Context:      /H2G2/POSTS/POST-LIST/POST
	Purpose:	 Creates the DATE text as a link to the posting in the thread
	-->
	<xsl:template match="POST" mode="c_morepostspagepostlastreply">
		<xsl:apply-templates select="." mode="r_morepostspagepostlastreply"/>
	</xsl:template>
	<!--
	<xsl:template match="POST" mode="t_lastreplytext">
	Author:		Andy Harris
	Context:      /H2G2/POSTS/POST-LIST/POST
	Purpose:	 Chooses the correct form for the last reply text
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
	<xsl:template match="POST" mode="t_morepostspostlastreply">
	Author:		Andy Harris
	Context:      /H2G2/POSTS/POST-LIST/POST
	Purpose:	 Creates the date for the last reply text
	-->
	<xsl:template match="POST" mode="t_morepostspostlastreply">
		<xsl:if test="HAS-REPLY > 0">
			<xsl:apply-templates select="THREAD/REPLYDATE/DATE"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="POST" mode="c_postunsubscribemorepostspage">
	Author:		Andy Harris
	Context:      /H2G2/POSTS/POST-LIST/POST
	Purpose:	 Calls the unsubscribe link container if the viewer is the owner
	-->
	<xsl:template match="POST" mode="c_postunsubscribemorepostspage">
		<xsl:if test="$ownerisviewer = 1">
			<xsl:apply-templates select="." mode="r_postunsubscribemorepostspage"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="POST" mode="r_postunsubscribemorepostspage">
	Author:		Andy Harris
	Context:      /H2G2/POSTS/POST-LIST/POST
	Purpose:	 Creates the unsubscribe link
	-->
	<xsl:template match="POST" mode="r_postunsubscribemorepostspage">
		<xsl:param name="embodiment" select="$m_unsubscribe"/>
		<xsl:param name="attributes"/>
		<a target="_top" href="{$root}FSB{THREAD/@FORUMID}?thread={THREAD/@THREADID}&amp;cmd=unsubscribethread&amp;page=normal&amp;desc={$alt_subreturntopostlist}&amp;return=MP{$viewerid}%3Fskip={../@SKIPTO}%26amp;show={../@COUNT}" xsl:use-attribute-sets="npostunsubscribe2">
			<xsl:call-template name="ApplyAttributes">
				<xsl:with-param name="attributes" select="$attributes"/>
			</xsl:call-template>
			<xsl:copy-of select="$embodiment"/>
		</a>
	</xsl:template>
</xsl:stylesheet>
