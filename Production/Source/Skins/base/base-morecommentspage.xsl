<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	
	<xsl:variable name="mcUserNode" select="/H2G2/MORECOMMENTS/COMMENTS-LIST/USER"/>
	
	<xsl:variable name="UserIsOwner">
		<xsl:choose>
			<xsl:when test="number(/H2G2/VIEWING-USER/USER/USERID) = number($mcUserNode/@USERID)">
				1
			</xsl:when>
			<xsl:when test="number(/H2G2/VIEWING-USER/USER/USERID) = number(/H2G2/PAGE-OWNER/USER/USERID)">
				1
			</xsl:when>
			<xsl:otherwise>
				0
			</xsl:otherwise>
		</xsl:choose>	
	</xsl:variable>
	
	<!--
	<xsl:template name="MORECOMMENTS_HEADER">
	Author:		Andy Harris
	Context:      H2G2
	Purpose:	 Creates the title for the page which sits in the html header
	-->
	<xsl:template name="MORECOMMENTS_HEADER">
		<xsl:apply-templates mode="header" select=".">
			<xsl:with-param name="title">
				<xsl:value-of select="$m_pagetitlestart"/>
				<xsl:text>Comments</xsl:text>
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>
	<!--
	<xsl:template name="MORECOMMENTS_SUBJECT">
	Author:		Tom Whitehouse
	Context:      H2G2
	Purpose:	 Creates the text for the subject
	-->
	<xsl:template name="MORECOMMENTS_SUBJECT">
		<xsl:call-template name="SUBJECTHEADER">
			<xsl:with-param name="text">
				<xsl:text>Comments by </xsl:text> 
				<xsl:apply-templates select="MORECOMMENTS" mode="ResearcherName"/>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<!--
	<xsl:template match="MORECOMMENTS" mode="ResearcherName">
	Author:		Tom Whitehouse
	Context:      /H2G2/MORECOMMENTS
	Purpose:	 Creates the name text for the subject area
	-->
	<xsl:template match="MORECOMMENTS" mode="ResearcherName">
		<xsl:choose>
			<xsl:when test="COMMENTS-LIST">
				<xsl:apply-templates select="COMMENTS-LIST/USER" mode="username" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$m_researcher"/>
				<xsl:value-of select="@USERID"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="MORECOMMENTS" mode="c_morepostspage">
	Author:		Andy Harris
	Context:      /H2G2/MORECOMMENTS
	Purpose:	 Calls the container for the MORECOMMENTS object
	-->
	<xsl:template match="COMMENTS-LIST" mode="c_morecommentspage">
		<xsl:apply-templates select="." mode="r_morecommentspage"/>
	</xsl:template>
	<!--
	<xsl:template match="MORECOMMENTS" mode="c_morepostlistempty">
	Author:		Andy Harris
	Context:      /H2G2/MORECOMMENTS
	Purpose:	 Chooses the correct text for when the MORECOMMENTS list is empty
	-->
	<xsl:template match="COMMENTS-LIST" mode="c_morecommentslistempty">
		<xsl:if test="not(COMMENTS/COMMENT)">
			<xsl:choose>
				<xsl:when test="$ownerisviewer = 1">
					<xsl:apply-templates select="COMMENTS-LIST" mode="owner_morecommentslistempty"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="COMMENTS-LIST" mode="viewer_morecommentslistempty"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="COMMENTS-LIST" mode="c_morepostspage">
	Author:		Andy Harris
	Context:      /H2G2/MORECOMMENTS/COMMENTS-LIST
	Purpose:	 Chooses the correct container for the COMMENTS-LIST
	-->
	<xsl:template match="COMMENTS-LIST" mode="c_morecommentspage">
		<xsl:choose>
			<xsl:when test="$ownerisviewer = 1">
				<xsl:apply-templates select="COMMENTS" mode="owner_morecommentslist"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="COMMENTS" mode="viewer_morecommentslist"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="COMMENT" mode="c_morepostspage">
	Author:		Andy Harris
	Context:      /H2G2/MORECOMMENTS/COMMENTS-LIST/COMMENT
	Purpose:	 Calls the container for the COMMENT object
	-->
	<xsl:template match="COMMENT" mode="c_morecommentspage">
		<xsl:apply-templates select="." mode="r_morecommentspage"/>
	</xsl:template>
	<!--
	<xsl:template match="MORECOMMENTS" mode="c_prevmoreposts">
	Author:		Andy Harris
	Context:      /H2G2/MORECOMMENTS
	Purpose:	 Calls the container for the 'previous posts' link if there is one
	-->
	<xsl:template match="MORECOMMENTS" mode="c_prevmoreposts">
		<xsl:if test="./COMMENTS-LIST[@SKIPTO &gt; 0]">
			<xsl:apply-templates select="." mode="r_prevmoreposts"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="MORECOMMENTS" mode="r_prevmoreposts">
	Author:		Andy Harris
	Context:      /H2G2/MORECOMMENTS
	Purpose:	 Creates the 'previous posts' link
	-->
	<xsl:template match="MORECOMMENTS" mode="r_prevmoreposts">
		<a href="{$root}MP{./@USERID}?show={./COMMENTS-LIST/@COUNT}&amp;skip={number(./COMMENTS-LIST/@SKIPTO) - number(./COMMENTS-LIST/@COUNT)}">
			<xsl:value-of select="$m_newerpostings"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="MORECOMMENTS" mode="c_nextmoreposts">
	Author:		Andy Harris
	Context:      /H2G2/MORECOMMENTS
	Purpose:	 Calls the container for the 'more posts' link if there is one
	-->
	<xsl:template match="MORECOMMENTS" mode="c_nextmoreposts">
		<xsl:if test="./COMMENTS-LIST[@MORE=1]">
			<xsl:apply-templates select="." mode="r_nextmoreposts"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="MORECOMMENTS" mode="r_nextmoreposts">
	Author:		Andy Harris
	Context:      /H2G2/MORECOMMENTS
	Purpose:	 Creates the 'more posts' link
	-->
	<xsl:template match="MORECOMMENTS" mode="r_nextmoreposts">
		<a href="{$root}MP{./@USERID}?show={./COMMENTS-LIST/@COUNT}&amp;skip={number(./COMMENTS-LIST/@SKIPTO) + number(./COMMENTS-LIST/@COUNT)}">
			<xsl:value-of select="$m_olderpostings"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="MORECOMMENTS" mode="t_morepostsPSlink">
	Author:		Andy Harris
	Context:      /H2G2/MORECOMMENTS
	Purpose:	 Creates the 'back to personal space' link
	-->
	<xsl:template match="MORECOMMENTS" mode="t_morecommentsPSlink">
		<a href="{$root}U{COMMENTS-LIST/USER/USERID}">
			<xsl:copy-of select="$m_PostsBackTo"/>
			<xsl:apply-templates select="COMMENTS-LIST/USER" mode="username" />
			<xsl:copy-of select="$m_PostsPSpace"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="MORECOMMENTS" mode="t_morepostsPSlink">
	Author:		Andy Harris
	Context:      /H2G2/MORECOMMENTS
	Purpose:	 Creates the 'back to personal space' link
	-->
	<xsl:template match="MORECOMMENTS" mode="t_morecommentsPSlink">
		<a href="{$root}MP{COMMENTS-LIST/USER/USERID}">
			<xsl:text>View </xsl:text>
			<xsl:apply-templates select="COMMENTS-LIST/USER" mode="username" />
			<xsl:text> Forum Postings</xsl:text>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="MORECOMMENTS" mode="t_morepostsPSlink">
	Author:		Andy Harris
	Context:      /H2G2/MORECOMMENTS/COMMENTS-LIST/COMMENT
	Purpose:	 Calls the container for the last user posting date or the no last posting text
	-->
	<xsl:template match="COMMENT" mode="c_morecommentspagepostdate">
		<xsl:choose>
			<xsl:when test="THREAD/LASTUSERPOST">
				<xsl:apply-templates select="." mode="r_morecommentspagepostdate"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$m_noposting"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="SITEID" mode="t_morepostspage">
	Author:		Andy Harris
	Context:      /H2G2/MORECOMMENTS/COMMENTS-LIST/COMMENT/SITEID
	Purpose:	 Creates the text for the name of the originating site
	-->
	<xsl:template match="SITEID" mode="t_morecommentspage">
		<xsl:value-of select="/H2G2/SITE-LIST/SITE[@ID=current()]/SHORTNAME"/>
	</xsl:template>
	<!--
	<xsl:template match="@THREADID" mode="t_morepostspagesubject">
	Author:		Andy Harris
	Context:      /H2G2/MORECOMMENTS/COMMENTS-LIST/COMMENT/THREAD/@THREADID
	Purpose:	 Creates the link to the thread using the SUBJECT
	-->
	<xsl:template match="@THREADID" mode="t_morepostspagesubject">
		<a href="{$root}F{../@FORUMID}?thread={.}">
			<xsl:value-of select="../SUBJECT"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="COMMENT" mode="r_morepostspagepostdate">
	Author:		Andy Harris
	Context:      /H2G2/MORECOMMENTS/COMMENTS-LIST/COMMENT
	Purpose:	 Calls the container for the DATE text
	-->
	<xsl:template match="COMMENT" mode="r_morepostspagepostdate">
		<xsl:apply-templates select="THREAD/LASTUSERPOST/DATEPOSTED/DATE" mode="r_morepostspagepostdate"/>
	</xsl:template>
	<!--
	<xsl:template match="DATE" mode="r_morepostspagepostdate">
	Author:		Andy Harris
	Context:      /H2G2/MORECOMMENTS/COMMENTS-LIST/COMMENT/THREAD/LASTUSERPOST/DATEPOSTED/DATE
	Purpose:	 Creates the DATE text as a link to the posting in the thread
	-->
	<xsl:template match="DATE" mode="r_morecommentspagepostdate">
			<xsl:apply-templates select="."/>
	</xsl:template>
	<!--
	<xsl:template match="COMMENT" mode="c_morepostspagepostlastreply">
	Author:		Andy Harris
	Context:      /H2G2/MORECOMMENTS/COMMENTS-LIST/COMMENT
	Purpose:	 Creates the DATE text as a link to the posting in the thread
	-->
	<xsl:template match="COMMENT" mode="c_morecommentspagepostlastreply">
		<xsl:apply-templates select="." mode="r_morepostspagepostlastreply"/>
	</xsl:template>
	<!--
	<xsl:template match="COMMENT" mode="t_lastreplytext">
	Author:		Andy Harris
	Context:      /H2G2/MORECOMMENTS/COMMENTS-LIST/COMMENT
	Purpose:	 Chooses the correct form for the last reply text
	-->
	<xsl:template match="COMMENT" mode="t_lastreplytext">
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
	<xsl:template match="COMMENT" mode="t_morecommentspostlastreply">
	Author:		Andy Harris
	Context:      /H2G2/MORECOMMENTS/COMMENTS-LIST/COMMENT
	Purpose:	 Creates the date for the last reply text
	-->
	<xsl:template match="COMMENT" mode="t_morepostspostlastreply">
		<xsl:if test="HAS-REPLY > 0">
			<xsl:apply-templates select="THREAD/REPLYDATE/DATE"/>
		</xsl:if>
	</xsl:template>
	<!--
		<xsl:template match="COMMENT" mode="c_postunsubscribemorecommentspage">
	Author:		Andy Harris
	Context:      /H2G2/MORECOMMENTS/COMMENTS-LIST/COMMENT
	Purpose:	 Calls the unsubscribe link container if the viewer is the owner
	-->
	<xsl:template match="COMMENT" mode="c_postunsubscribemorecommentspage">
		<xsl:if test="$ownerisviewer = 1">
			<xsl:apply-templates select="." mode="r_postunsubscribemorecommentspage"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="COMMENT" mode="r_postunsubscribemorepostspage">
	Author:		Andy Harris
	Context:      /H2G2/MORECOMMENTS/COMMENTS-LIST/COMMENT
	Purpose:	 Creates the unsubscribe link
	-->
	<xsl:template match="COMMENT" mode="r_postunsubscribemorecommentspage">
		<xsl:param name="embodiment" select="$m_unsubscribe"/>
		<xsl:param name="attributes"/>
		<a target="_top" href="{$root}FSB{THREAD/@FORUMID}?thread={THREAD/@THREADID}&amp;cmd=unsubscribethread&amp;page=normal&amp;desc={$alt_subreturntopostlist}&amp;return=MP{$viewerid}%3Fskip={../@SKIPTO}%26amp;show={../@COUNT}" xsl:use-attribute-sets="npostunsubscribe2">
			<xsl:call-template name="ApplyAttributes">
				<xsl:with-param name="attributes" select="$attributes"/>
			</xsl:call-template>
			<xsl:copy-of select="$embodiment"/>
		</a>
	</xsl:template>
	<!--
		<xsl:template match="POST" mode="c_userpagepostdate">
		Author:		Tom Whitehouse
		Context:      /H2G2/RECENT-POSTS/POST-LIST/POST
		Purpose:	 Calls the container for post date link or the no posting text
	-->
	<xsl:template match="COMMENT" mode="c_userpagepostdate">
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
		<xsl:template match="text()" mode="text_crop">
		Description: Crops a body of text for small descriptions and alike.
		Author:		 Richard Hodgson
		Parameters:  @suffix - Character to add to the end of the crop
		e.g. "...", " >>>"
		@amount - Amount of characters to crop to.						   
	-->
	<xsl:template match="text()" mode="text_crop">
		<xsl:param name="suffix"/>
		<xsl:param name="amount" select="200"/>
		
		<xsl:choose>
			<xsl:when test="string-length(.) > $amount">
				<xsl:value-of select="substring(., 0, $amount)"/>
				<xsl:copy-of select="$suffix"/>
				
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="."/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
</xsl:stylesheet>
