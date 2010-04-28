<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<!--
	<xsl:variable name="var_orderby">
	Author:		Andy Harris
	Context:      H2G2
	Purpose:	 Creates the order by variable for use elsewhere
	-->
	<xsl:variable name="var_orderby">
		<xsl:choose>
			<xsl:when test="/H2G2/REVIEWFORUM/REVIEWFORUMTHREADS/@ORDERBY=1">dateentered</xsl:when>
			<xsl:when test="/H2G2/REVIEWFORUM/REVIEWFORUMTHREADS/@ORDERBY=2">lastposted</xsl:when>
			<xsl:when test="/H2G2/REVIEWFORUM/REVIEWFORUMTHREADS/@ORDERBY=3">authorid</xsl:when>
			<xsl:when test="/H2G2/REVIEWFORUM/REVIEWFORUMTHREADS/@ORDERBY=4">authorname</xsl:when>
			<xsl:when test="/H2G2/REVIEWFORUM/REVIEWFORUMTHREADS/@ORDERBY=5">entry</xsl:when>
			<xsl:when test="/H2G2/REVIEWFORUM/REVIEWFORUMTHREADS/@ORDERBY=6">subject</xsl:when>
			<xsl:otherwise>dateentered</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<!--
	<xsl:variable name="op_dir">
	Author:		Andy Harris
	Context:      H2G2
	Purpose:	 Creates the direction variable for use elsewhere
	-->
	<xsl:variable name="op_dir">
		<xsl:choose>
			<xsl:when test="/H2G2/REVIEWFORUM/REVIEWFORUMTHREADS/@DIR=1">0</xsl:when>
			<xsl:otherwise>1</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<!--
	<xsl:template name="REVIEWFORUM_HEADER">
	Author:		Andy Harris
	Context:      H2G2
	Purpose:	 Creates the title for the page which sits in the html header
	-->
	<xsl:template name="REVIEWFORUM_HEADER">
		<xsl:apply-templates mode="header" select=".">
			<xsl:with-param name="title">
				<xsl:value-of select="$m_pagetitlestart"/>
				<xsl:value-of select="REVIEWFORUM/FORUMNAME"/>
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>
	<!--
	<xsl:template name="REVIEWFORUM_SUBJECT">
	Author:		Andy Harris
	Context:      H2G2
	Purpose:	 Creates the text for the subject
	-->
	<xsl:template name="REVIEWFORUM_SUBJECT">
		<xsl:call-template name="SUBJECTHEADER">
			<xsl:with-param name="text">
				<xsl:value-of select="REVIEWFORUM/FORUMNAME"/>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<!--
	<xsl:template match="BODY" mode="c_reviewforum">
	Author:		Andy Harris
	Context:      H2G2/ARTICLE/GUIDE/BODY
	Purpose:	 Creates the container for the article BODY object
	-->
	<xsl:template match="BODY" mode="c_reviewforum">
		<xsl:apply-templates select="." mode="r_reviewforum"/>
	</xsl:template>
	<!--
	<xsl:template match="BODY" mode="r_reviewforum">
	Author:		Andy Harris
	Context:      H2G2/ARTICLE/GUIDE/BODY
	Purpose:	 Displays the article BODY object
	-->
	<xsl:template match="BODY" mode="r_reviewforum">
		<xsl:apply-templates select="."/>
	</xsl:template>
	<!--
	<xsl:template match="FOOTNOTE" mode="c_reviewforum">
	Author:		Andy Harris
	Context:      /H2G2/ARTICLE/GUIDE/GUIDE/BODY/FOOTNOTE
	Purpose:	 Calls the FOOTNOTE container for each FOOTNOTE
	-->
	<xsl:template match="FOOTNOTE" mode="c_reviewforum">
		<xsl:apply-templates select="." mode="object_reviewforum"/>
	</xsl:template>
	<!--
	<xsl:template match="FOOTNOTE" mode="object_reviewforum">
	Author:		Andy Harris
	Context:      /H2G2/ARTICLE/GUIDE/GUIDE/BODY/FOOTNOTE
	Purpose:	 Calls the FOOTNOTE text and link creation for each FOOTNOTE
	-->
	<xsl:template match="FOOTNOTE" mode="object_reviewforum">
		<a name="footnote{@INDEX}">
			<a href="#back{@INDEX}" xsl:use-attribute-sets="mFOOTNOTE_object_reviewforum">
				<xsl:apply-templates select="." mode="number_reviewforum"/>
			</a>
			<xsl:apply-templates select="." mode="text_reviewforum"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="FOOTNOTE" mode="number_reviewforum">
	Author:		Andy Harris
	Context:      /H2G2/ARTICLE/GUIDE/GUIDE/BODY/FOOTNOTE
	Purpose:	 Creates the FOOTNOTE number for each FOOTNOTE
	-->
	<xsl:template match="FOOTNOTE" mode="number_reviewforum">
		<xsl:value-of select="@INDEX"/>
	</xsl:template>
	<!--
	<xsl:template match="FOOTNOTE" mode="text_reviewforum">
	Author:		Andy Harris
	Context:      /H2G2/ARTICLE/GUIDE/GUIDE/BODY/FOOTNOTE
	Purpose:	 Creates the FOOTNOTE text for each FOOTNOTE
	-->
	<xsl:template match="FOOTNOTE" mode="text_reviewforum">
		<xsl:apply-templates/>
	</xsl:template>
	<!--
	<xsl:template match="REVIEWFORUMTHREADS" mode="c_reviewforum">
	Author:		Andy Harris
	Context:      /H2G2/REVIEWFORUM/REVIEWFORUMTHREADS
	Purpose:	 Calls the correct container for the REVIEWFORUMTHREADS
	-->
	<xsl:template match="REVIEWFORUMTHREADS" mode="c_reviewforum">
		<xsl:choose>
			<xsl:when test="THREAD">
				<xsl:apply-templates select="." mode="full_reviewforum"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="." mode="empty_reviewforum"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="REVIEWFORUMTHREADS" mode="c_threadnavigation">
	Author:		Andy Harris
	Context:      /H2G2/REVIEWFORUM/REVIEWFORUMTHREADS
	Purpose:	 Calls the container for the REVIEWFORUMTHREADS navigation if required
	-->
	<xsl:template match="REVIEWFORUMTHREADS" mode="c_threadnavigation">
		<xsl:if test="/H2G2/NOGUIDE">
			<xsl:apply-templates select="." mode="r_threadnavigation"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="REVIEWFORUMTHREADS" mode="c_rfthreadblocks">
	Author:		Andy Harris
	Context:      /H2G2/REVIEWFORUM/REVIEWFORUMTHREADS
	Purpose:	 Calls the container for the thread blocks navigation
	-->
	<xsl:template match="REVIEWFORUMTHREADS" mode="c_rfthreadblocks">
		<xsl:apply-templates select="." mode="r_rfthreadblocks"/>
	</xsl:template>
	<!--
	<xsl:template match="REVIEWFORUMTHREADS" mode="c_rfpostblock">
	Author:		Andy Harris
	Context:      /H2G2/REVIEWFORUM/REVIEWFORUMTHREADS
	Purpose:	 Calls the container for the individual thread block in the navigation
	-->
	<xsl:template match="REVIEWFORUMTHREADS" mode="c_rfpostblock">
		<xsl:param name="skip" select="0"/>
		<xsl:apply-templates select="." mode="rfdisplayblock">
			<xsl:with-param name="skip" select="$skip"/>
		</xsl:apply-templates>
		<xsl:if test="($skip + @COUNT) &lt; @TOTALTHREADS">
			<xsl:apply-templates select="." mode="c_rfpostblock">
				<xsl:with-param name="skip" select="$skip + @COUNT"/>
			</xsl:apply-templates>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="REVIEWFORUMTHREADS" mode="rfdisplayblock">
	Author:		Andy Harris
	Context:      /H2G2/REVIEWFORUM/REVIEWFORUMTHREADS
	Purpose:	 Creates the individual thread block in the navigation
	-->
	<xsl:template match="REVIEWFORUMTHREADS" mode="rfdisplayblock">
		<xsl:param name="skip"/>
		<xsl:param name="PostRange" select="concat(($skip + 1), ' - ', ($skip + @COUNT))"/>
		<xsl:param name="threadblockon">
			<xsl:apply-templates select="." mode="on_rfpostblock">
				<xsl:with-param name="range" select="$PostRange"/>
			</xsl:apply-templates>
		</xsl:param>
		<xsl:param name="threadblockoff">
			<xsl:apply-templates select="." mode="off_rfpostblock">
				<xsl:with-param name="range" select="$PostRange"/>
			</xsl:apply-templates>
		</xsl:param>
		<a href="{$root}RF{../@ID}?skip={$skip}&amp;show={@COUNT}&amp;order={$var_orderby}&amp;dir={@DIR}&amp;entry=0" xsl:use-attribute-sets="mREVIEWFORUMTHREADS_c_postblock">
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
	<xsl:template match="REVIEWFORUMTHREADS" mode="c_headers">
	Author:		Andy Harris
	Context:      /H2G2/REVIEWFORUM/REVIEWFORUMTHREADS
	Purpose:	 Calls the container for the REVIEWFORUMTHREADS headers
	-->
	<xsl:template match="REVIEWFORUMTHREADS" mode="c_headers">
		<xsl:apply-templates select="." mode="r_headers"/>
	</xsl:template>
	<!--
	<xsl:template match="REVIEWFORUMTHREADS" mode="t_h2g2idheader">
	Author:		Andy Harris
	Context:      /H2G2/REVIEWFORUM/REVIEWFORUMTHREADS
	Purpose:	 Creates the REVIEWFORUMTHREADS header for h2g2id
	-->
	<xsl:template match="REVIEWFORUMTHREADS" mode="t_h2g2idheader">
		<xsl:choose>
			<xsl:when test="@ORDERBY=5">
				<a>
					<xsl:attribute name="HREF"><xsl:value-of select="$root"/>RF<xsl:value-of select="../@ID"/>?skip=<xsl:value-of select="@SKIPTO"/>&amp;show=<xsl:value-of select="@COUNT"/>&amp;order=entry<xsl:if test="/H2G2/NOGUIDE">&amp;entry=0</xsl:if>&amp;dir=<xsl:value-of select="$op_dir"/>#<xsl:value-of select="$m_reviewforum_entrytarget"/></xsl:attribute>
					<xsl:call-template name="m_rft_selecth2g2id"/>
				</a>
			</xsl:when>
			<xsl:otherwise>
				<a>
					<xsl:attribute name="HREF"><xsl:value-of select="$root"/>RF<xsl:value-of select="../@ID"/>?skip=<xsl:value-of select="@SKIPTO"/>&amp;show=<xsl:value-of select="@COUNT"/>&amp;order=entry<xsl:if test="/H2G2/NOGUIDE">&amp;entry=0</xsl:if>&amp;dir=0#<xsl:value-of select="$m_reviewforum_entrytarget"/></xsl:attribute>
					<xsl:call-template name="m_rft_h2g2id"/>
				</a>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="REVIEWFORUMTHREADS" mode="t_subjectheader">
	Author:		Andy Harris
	Context:      /H2G2/REVIEWFORUM/REVIEWFORUMTHREADS
	Purpose:	 Creates the REVIEWFORUMTHREADS header for subject
	-->
	<xsl:template match="REVIEWFORUMTHREADS" mode="t_subjectheader">
		<xsl:choose>
			<xsl:when test="@ORDERBY=6">
				<a>
					<xsl:attribute name="HREF"><xsl:value-of select="$root"/>RF<xsl:value-of select="../@ID"/>?skip=<xsl:value-of select="@SKIPTO"/>&amp;show=<xsl:value-of select="@COUNT"/>&amp;order=subject<xsl:if test="/H2G2/NOGUIDE">&amp;entry=0</xsl:if>&amp;dir=<xsl:value-of select="$op_dir"/>#<xsl:value-of select="$m_reviewforum_entrytarget"/></xsl:attribute>
					<xsl:call-template name="m_rft_selectsubject"/>
				</a>
			</xsl:when>
			<xsl:otherwise>
				<a>
					<xsl:attribute name="HREF"><xsl:value-of select="$root"/>RF<xsl:value-of select="../@ID"/>?skip=<xsl:value-of select="@SKIPTO"/>&amp;show=<xsl:value-of select="@COUNT"/>&amp;order=subject<xsl:if test="/H2G2/NOGUIDE">&amp;entry=0</xsl:if>&amp;dir=0#<xsl:value-of select="$m_reviewforum_entrytarget"/></xsl:attribute>
					<xsl:call-template name="m_rft_subject"/>
				</a>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="REVIEWFORUMTHREADS" mode="t_dateenteredheader">
	Author:		Andy Harris
	Context:      /H2G2/REVIEWFORUM/REVIEWFORUMTHREADS
	Purpose:	 Creates the REVIEWFORUMTHREADS header for date entered
	-->
	<xsl:template match="REVIEWFORUMTHREADS" mode="t_dateenteredheader">
		<xsl:choose>
			<xsl:when test="@ORDERBY=1">
				<a>
					<xsl:attribute name="HREF"><xsl:value-of select="$root"/>RF<xsl:value-of select="../@ID"/>?skip=<xsl:value-of select="@SKIPTO"/>&amp;show=<xsl:value-of select="@COUNT"/>&amp;order=dateentered<xsl:if test="/H2G2/NOGUIDE">&amp;entry=0</xsl:if>&amp;dir=<xsl:value-of select="$op_dir"/>#<xsl:value-of select="$m_reviewforum_entrytarget"/></xsl:attribute>
					<xsl:call-template name="m_rft_selectdateentered"/>
				</a>
			</xsl:when>
			<xsl:otherwise>
				<a>
					<xsl:attribute name="HREF"><xsl:value-of select="$root"/>RF<xsl:value-of select="../@ID"/>?skip=<xsl:value-of select="@SKIPTO"/>&amp;show=<xsl:value-of select="@COUNT"/>&amp;order=dateentered<xsl:if test="/H2G2/NOGUIDE">&amp;entry=0</xsl:if>&amp;dir=0#<xsl:value-of select="$m_reviewforum_entrytarget"/></xsl:attribute>
					<xsl:call-template name="m_rft_dateentered"/>
				</a>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="REVIEWFORUMTHREADS" mode="t_lastpostedheader">
	Author:		Andy Harris
	Context:      /H2G2/REVIEWFORUM/REVIEWFORUMTHREADS
	Purpose:	 Creates the REVIEWFORUMTHREADS header for last post
	-->
	<xsl:template match="REVIEWFORUMTHREADS" mode="t_lastpostedheader">
		<xsl:choose>
			<xsl:when test="@ORDERBY=2">
				<a>
					<xsl:attribute name="href"><xsl:value-of select="$root"/>RF<xsl:value-of select="../@ID"/>?skip=<xsl:value-of select="@SKIPTO"/>&amp;show=<xsl:value-of select="@COUNT"/>&amp;order=lastposted<xsl:if test="/H2G2/NOGUIDE">&amp;entry=0</xsl:if>&amp;dir=<xsl:value-of select="$op_dir"/>#<xsl:value-of select="$m_reviewforum_entrytarget"/></xsl:attribute>
					<xsl:call-template name="m_rft_selectlastposted"/>
				</a>
			</xsl:when>
			<xsl:otherwise>
				<a>
					<xsl:attribute name="href"><xsl:value-of select="$root"/>RF<xsl:value-of select="../@ID"/>?skip=<xsl:value-of select="@SKIPTO"/>&amp;show=<xsl:value-of select="@COUNT"/>&amp;order=lastposted<xsl:if test="/H2G2/NOGUIDE">&amp;entry=0</xsl:if>&amp;dir=0#<xsl:value-of select="$m_reviewforum_entrytarget"/></xsl:attribute>
					<xsl:call-template name="m_rft_lastposted"/>
				</a>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="REVIEWFORUMTHREADS" mode="t_authorheader">
	Author:		Andy Harris
	Context:      /H2G2/REVIEWFORUM/REVIEWFORUMTHREADS
	Purpose:	 Creates the REVIEWFORUMTHREADS header for author
	-->
	<xsl:template match="REVIEWFORUMTHREADS" mode="t_authorheader">
		<xsl:choose>
			<xsl:when test="@ORDERBY=4">
				<a>
					<xsl:attribute name="href"><xsl:value-of select="$root"/>RF<xsl:value-of select="../@ID"/>?skip=<xsl:value-of select="@SKIPTO"/>&amp;show=<xsl:value-of select="@COUNT"/>&amp;order=authorname<xsl:if test="/H2G2/NOGUIDE">&amp;entry=0</xsl:if>&amp;dir=<xsl:value-of select="$op_dir"/>#<xsl:value-of select="$m_reviewforum_entrytarget"/></xsl:attribute>
					<xsl:call-template name="m_rft_selectauthor"/>
				</a>
			</xsl:when>
			<xsl:otherwise>
				<a>
					<xsl:attribute name="href"><xsl:value-of select="$root"/>RF<xsl:value-of select="../@ID"/>?skip=<xsl:value-of select="@SKIPTO"/>&amp;show=<xsl:value-of select="@COUNT"/>&amp;order=authorname<xsl:if test="/H2G2/NOGUIDE">&amp;entry=0</xsl:if>&amp;dir=0#<xsl:value-of select="$m_reviewforum_entrytarget"/></xsl:attribute>
					<xsl:call-template name="m_rft_author"/>
				</a>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="REVIEWFORUMTHREADS" mode="t_authoridheader">
	Author:		Andy Harris
	Context:      /H2G2/REVIEWFORUM/REVIEWFORUMTHREADS
	Purpose:	 Creates the REVIEWFORUMTHREADS header for author id
	-->
	<xsl:template match="REVIEWFORUMTHREADS" mode="t_authoridheader">
		<xsl:choose>
			<xsl:when test="@ORDERBY=3">
				<a>
					<xsl:attribute name="href"><xsl:value-of select="$root"/>RF<xsl:value-of select="../@ID"/>?skip=<xsl:value-of select="@SKIPTO"/>&amp;show=<xsl:value-of select="@COUNT"/>&amp;order=authorid<xsl:if test="/H2G2/NOGUIDE">&amp;entry=0</xsl:if>&amp;dir=<xsl:value-of select="$op_dir"/>#<xsl:value-of select="$m_reviewforum_entrytarget"/></xsl:attribute>
					<xsl:call-template name="m_rft_selectauthorid"/>
				</a>
			</xsl:when>
			<xsl:otherwise>
				<a>
					<xsl:attribute name="href"><xsl:value-of select="$root"/>RF<xsl:value-of select="../@ID"/>?skip=<xsl:value-of select="@SKIPTO"/>&amp;show=<xsl:value-of select="@COUNT"/>&amp;order=authorid<xsl:if test="/H2G2/NOGUIDE">&amp;entry=0</xsl:if>&amp;dir=0#<xsl:value-of select="$m_reviewforum_entrytarget"/></xsl:attribute>
					<xsl:call-template name="m_rft_authorid"/>
				</a>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="THREAD" mode="c_reviewforum">
	Author:		Andy Harris
	Context:      /H2G2/REVIEWFORUM/REVIEWFORUMTHREADS/THREAD
	Purpose:	 Calls the container for a review forum THREAD object
	-->
	<xsl:template match="THREAD" mode="c_reviewforum">
		<xsl:apply-templates select="." mode="r_reviewforum"/>
	</xsl:template>
	<!--
	<xsl:template match="THREAD" mode="t_h2g2id">
	Author:		Andy Harris
	Context:      /H2G2/REVIEWFORUM/REVIEWFORUMTHREADS/THREAD
	Purpose:	 Creates the h2g2 id link for a THREAD
	-->
	<xsl:template match="THREAD" mode="t_h2g2id">
		<a>
			<xsl:attribute name="href"><xsl:value-of select="$root"/>A<xsl:value-of select="H2G2ID"/></xsl:attribute>
			A<xsl:value-of select="H2G2ID"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="THREAD" mode="t_subject">
	Author:		Andy Harris
	Context:      /H2G2/REVIEWFORUM/REVIEWFORUMTHREADS/THREAD
	Purpose:	 Creates the subject link for a THREAD
	-->
	<xsl:template match="THREAD" mode="t_subject">
		<xsl:param name="longtext">
			<xsl:apply-templates mode="nosubject" select="SUBJECT"/>
		</xsl:param>
		<xsl:param name="maxlength">20</xsl:param>
		<xsl:variable name="shortlength" select="$maxlength - 3"/>
		<a>
			<xsl:attribute name="href"><xsl:value-of select="$root"/>A<xsl:value-of select="H2G2ID"/></xsl:attribute>
			<xsl:choose>
				<xsl:when test="string-length($longtext) &gt; $maxlength">
					<xsl:value-of select="substring($longtext, 1, $shortlength)"/>...</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$longtext"/>
				</xsl:otherwise>
			</xsl:choose>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="THREAD" mode="t_dateentered">
	Author:		Andy Harris
	Context:      /H2G2/REVIEWFORUM/REVIEWFORUMTHREADS/THREAD
	Purpose:	 Creates the date entered link for a THREAD
	-->
	<xsl:template match="THREAD" mode="t_dateentered">
		<a>
			<xsl:attribute name="href">F<xsl:value-of select="../@FORUMID"/>?thread=<xsl:value-of select="THREADID"/></xsl:attribute>
			<xsl:value-of select="DATEENTERED/DATE/@RELATIVE"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="THREAD" mode="t_lastposted">
	Author:		Andy Harris
	Context:      /H2G2/REVIEWFORUM/REVIEWFORUMTHREADS/THREAD
	Purpose:	 Creates the last posting link for a THREAD
	-->
	<xsl:template match="THREAD" mode="t_lastposted">
		<a>
			<xsl:attribute name="href"><xsl:value-of select="$root"/>F<xsl:value-of select="../@FORUMID"/>?thread=<xsl:value-of select="THREADID"/>&amp;latest=1</xsl:attribute>
			<xsl:apply-templates select="DATEPOSTED"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="THREAD" mode="t_author">
	Author:		Andy Harris
	Context:      /H2G2/REVIEWFORUM/REVIEWFORUMTHREADS/THREAD
	Purpose:	 Creates the author link for a THREAD
	-->
	<xsl:template match="THREAD" mode="t_author">
		<a>
			<xsl:attribute name="href"><xsl:value-of select="$root"/>U<xsl:value-of select="AUTHOR/USER/USERID"/></xsl:attribute>
			<xsl:apply-templates select="AUTHOR/USER" mode="username">
				<xsl:with-param name="stringlimit">17</xsl:with-param>			
			</xsl:apply-templates>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="THREAD" mode="t_authorid">
	Author:		Andy Harris
	Context:      /H2G2/REVIEWFORUM/REVIEWFORUMTHREADS/THREAD
	Purpose:	 Creates the author id link for a THREAD
	-->
	<xsl:template match="THREAD" mode="t_authorid">
		<a>
			<xsl:attribute name="href"><xsl:value-of select="$root"/>U<xsl:value-of select="AUTHOR/USER/USERID"/></xsl:attribute>
			U<xsl:value-of select="AUTHOR/USER/USERID"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="THREAD" mode="c_removefromforum">
	Author:		Andy Harris
	Context:      /H2G2/REVIEWFORUM/REVIEWFORUMTHREADS/THREAD
	Purpose:	 Calls the container for the remove from forum link for a THREAD
	-->
	<xsl:template match="THREAD" mode="c_removefromforum">
		<xsl:if test="/H2G2/VIEWING-USER/USER/GROUPS/EDITOR or /H2G2/VIEWING-USER/USER/USERID=./AUTHOR/USER/USERID or /H2G2/VIEWING-USER/USER/USERID=./SUBMITTER/USER/USERID">
			<xsl:apply-templates select="." mode="r_removefromforum"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="THREAD" mode="r_removefromforum">
	Author:		Andy Harris
	Context:      /H2G2/REVIEWFORUM/REVIEWFORUMTHREADS/THREAD
	Purpose:	 Creates the remove from forum link for a THREAD
	-->
	<xsl:template match="THREAD" mode="r_removefromforum">
		<a>
			<xsl:attribute name="href"><xsl:value-of select="$root"/>SubmitReviewForum?action=removethread&amp;rfid=<xsl:value-of select="../../@ID"/>&amp;h2g2id=<xsl:value-of select="H2G2ID"/></xsl:attribute>
			<xsl:attribute name="onclick">return window.confirm('Remove entry from Review Forum?');</xsl:attribute>
			<xsl:call-template name="m_removefromreviewforum"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="REVIEWFORUMTHREADS" mode="c_moreentries">
	Author:		Andy Harris
	Context:      /H2G2/REVIEWFORUM/REVIEWFORUMTHREADS
	Purpose:	 Calls the container for the more entries link
	-->
	<xsl:template match="REVIEWFORUMTHREADS" mode="c_moreentries">
		<xsl:if test="not(/H2G2/NOGUIDE) and @MORE=1">
			<xsl:apply-templates select="." mode="r_moreentries"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="REVIEWFORUMTHREADS" mode="r_moreentries">
	Author:		Andy Harris
	Context:      /H2G2/REVIEWFORUM/REVIEWFORUMTHREADS
	Purpose:	 Creates the more entries link
	-->
	<xsl:template match="REVIEWFORUMTHREADS" mode="r_moreentries">
		<a>
			<xsl:attribute name="href"><xsl:value-of select="$root"/>RF<xsl:value-of select="../@ID"/>?entry=0&amp;skip=0&amp;show=25&amp;order=<xsl:value-of select="$var_orderby"/>&amp;dir=<xsl:value-of select="@DIR"/></xsl:attribute>
			<xsl:value-of select="$m_clickmorereviewentries"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="REVIEWFORUMTHREADS" mode="c_subscribe">
	Author:		Andy Harris
	Context:      /H2G2/REVIEWFORUM/REVIEWFORUMTHREADS
	Purpose:	 Calls the container for the subscribe / unsubscribe links
	-->
	<xsl:template match="REVIEWFORUMTHREADS" mode="c_subscribe">
		<xsl:if test="$registered=1">
			<xsl:apply-templates select="." mode="r_subscribe"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="REVIEWFORUMTHREADS" mode="r_subscribe">
	Author:		Andy Harris
	Context:      /H2G2/REVIEWFORUM/REVIEWFORUMTHREADS
	Purpose:	 Creates the subscribe / unsubscribe links
	-->
	<xsl:template match="REVIEWFORUMTHREADS" mode="r_subscribe">
		<a target="_top">
			<xsl:attribute name="href"><xsl:value-of select="$root"/>FSB<xsl:value-of select="@FORUMID"/>?cmd=subscribeforum&amp;page=normal&amp;desc=<xsl:value-of select="$m_notifynewentriesinreviewforum"/>&amp;return=RF<xsl:value-of select="../@ID"/></xsl:attribute>
			<xsl:value-of select="$m_notifynewentriesinreviewforum"/>
		</a>
		<br/>
		<a target="_top">
			<xsl:attribute name="href"><xsl:value-of select="$root"/>FSB<xsl:value-of select="@FORUMID"/>?cmd=unsubscribeforum&amp;page=normal&amp;desc=<xsl:value-of select="$m_notifynewentriesinreviewforum"/>&amp;return=RF<xsl:value-of select="../@ID"/></xsl:attribute>
			<xsl:value-of select="$m_stopnotifynewentriesreviewforum"/>
		</a>
		<br/>
	</xsl:template>
	<!--
	<xsl:template match="REVIEWFORUM" mode="c_info">
	Author:		Andy Harris
	Context:      /H2G2/REVIEWFORUM
	Purpose:	 Calls the container for the forum info object
	-->
	<xsl:template match="REVIEWFORUM" mode="c_info">
		<xsl:apply-templates select="." mode="r_info"/>
	</xsl:template>
	<!--
	<xsl:template match="REVIEWFORUM" mode="t_name">
	Author:		Andy Harris
	Context:      /H2G2/REVIEWFORUM
	Purpose:	 Creates the forum name text
	-->
	<xsl:template match="REVIEWFORUM" mode="t_name">
		<xsl:value-of select="FORUMNAME"/>
	</xsl:template>
	<!--
	<xsl:template match="REVIEWFORUM" mode="t_url">
	Author:		Andy Harris
	Context:      /H2G2/REVIEWFORUM
	Purpose:	 Creates the friendly url text
	-->
	<xsl:template match="REVIEWFORUM" mode="t_url">
		<xsl:value-of select="URLFRIENDLYNAME"/>
	</xsl:template>
	<!--
	<xsl:template match="REVIEWFORUM" mode="c_recommendable">
	Author:		Andy Harris
	Context:      /H2G2/REVIEWFORUM
	Purpose:	 Calls the correct container for whether the forum is recommendable or not
	-->
	<xsl:template match="REVIEWFORUM" mode="c_recommendable">
		<xsl:choose>
			<xsl:when test="RECOMMENDABLE=1">
				<xsl:apply-templates select="." mode="true_recommendable"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="." mode="false_recommendable"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="REVIEWFORUM" mode="t_incubate">
	Author:		Andy Harris
	Context:      /H2G2/REVIEWFORUM
	Purpose:	 Creates the incubation time text
	-->
	<xsl:template match="REVIEWFORUM" mode="t_incubate">
		<xsl:value-of select="INCUBATETIME"/>
	</xsl:template>
	<!--
	<xsl:template match="REVIEWFORUM" mode="c_editorinfo">
	Author:		Andy Harris
	Context:      /H2G2/REVIEWFORUM
	Purpose:	 Calls the container for the editor info if required
	-->
	<xsl:template match="REVIEWFORUM" mode="c_editorinfo">
		<xsl:if test="/H2G2/VIEWING-USER/USER/GROUPS/EDITOR">
			<xsl:apply-templates select="." mode="r_editorinfo"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="REVIEWFORUM" mode="t_h2g2id">
	Author:		Andy Harris
	Context:      /H2G2/REVIEWFORUM
	Purpose:	 Creates the link to the h2g2 id of the article
	-->
	<xsl:template match="REVIEWFORUM" mode="t_h2g2id">
		<xsl:value-of select="$m_reviewforumdata_h2g2id"/>
		<a>
			<xsl:attribute name="href">A<xsl:value-of select="H2G2ID"/></xsl:attribute>A<xsl:value-of select="H2G2ID"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="REVIEWFORUM" mode="t_dataedit">
	Author:		Andy Harris
	Context:      /H2G2/REVIEWFORUM
	Purpose:	 Creates the link for editing the review forum
	-->
	<xsl:template match="REVIEWFORUM" mode="t_dataedit">
		<a>
			<xsl:attribute name="href"><xsl:value-of select="$root"/>EditReview?id=<xsl:value-of select="@ID"/></xsl:attribute>
			<xsl:value-of select="$m_reviewforumdata_edit"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="REVIEWFORUMTHREADS" mode="c_firstpage">
	Author:		Andy Harris
	Context:      /H2G2/REVIEWFORUM/REVIEWFORUMTHREADS
	Purpose:	 Calls the correct container for the 'First page' link
	-->
	<xsl:template match="REVIEWFORUMTHREADS" mode="c_firstpage">
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
	<xsl:template match="REVIEWFORUMTHREADS" mode="c_lastpage">
	Author:		Andy Harris
	Context:      /H2G2/REVIEWFORUM/REVIEWFORUMTHREADS
	Purpose:	 Calls the correct container for the 'Last page' link
	-->
	<xsl:template match="REVIEWFORUMTHREADS" mode="c_lastpage">
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
	<xsl:template match="REVIEWFORUMTHREADS" mode="c_previouspage">
	Author:		Andy Harris
	Context:      /H2G2/REVIEWFORUM/REVIEWFORUMTHREADS
	Purpose:	 Calls the correct container for the 'Previous page' link
	-->
	<xsl:template match="REVIEWFORUMTHREADS" mode="c_previouspage">
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
	<xsl:template match="REVIEWFORUMTHREADS" mode="c_nextpage">
	Author:		Andy Harris
	Context:      /H2G2/REVIEWFORUM/REVIEWFORUMTHREADS
	Purpose:	 Calls the correct container for the 'Next page' link
	-->
	<xsl:template match="REVIEWFORUMTHREADS" mode="c_nextpage">
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
	<xsl:template match="REVIEWFORUMTHREADS" mode="link_firstpage">
	Author:		Andy Harris
	Context:      /H2G2/REVIEWFORUM/REVIEWFORUMTHREADS
	Purpose:	 Creates the 'First page' link
	-->
	<xsl:template match="REVIEWFORUMTHREADS" mode="link_firstpage">
		<a href="{$root}RF{../ID}?show={@COUNT}&amp;skip=0&amp;order={$var_orderby}&amp;dir={@DIR}&amp;entry=0" xsl:use-attribute-sets="mREVIEWFORUMTHREADS_link_firstpage">
			<xsl:copy-of select="$m_firstpagethreads"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="REVIEWFORUMTHREADS" mode="link_lastpage">
	Author:		Andy Harris
	Context:      /H2G2/REVIEWFORUM/REVIEWFORUMTHREADS
	Purpose:	 Creates the 'Last page' link
	-->
	<xsl:template match="REVIEWFORUMTHREADS" mode="link_lastpage">
		<a href="{$root}RF{../@ID}?show={@COUNT}&amp;skip={number(@TOTALTHREADS) - number(@COUNT)}&amp;order={$var_orderby}&amp;dir={@DIR}&amp;entry=0" xsl:use-attribute-sets="mREVIEWFORUMTHREADS_link_lastpage">
			<xsl:copy-of select="$m_lastpagethreads"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="REVIEWFORUMTHREADS" mode="link_previouspage">
	Author:		Andy Harris
	Context:      /H2G2/REVIEWFORUM/REVIEWFORUMTHREADS
	Purpose:	 Creates the 'Previous page' link
	-->
	<xsl:template match="REVIEWFORUMTHREADS" mode="link_previouspage">
		<a href="{$root}RF{../@ID}?show={@COUNT}&amp;skip={number(@SKIPTO) - number(@COUNT)}&amp;order={$var_orderby}&amp;dir={@DIR}&amp;entry=0" xsl:use-attribute-sets="mREVIEWFORUMTHREADS_link_previouspage">
			<xsl:copy-of select="$m_previouspagethreads"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="REVIEWFORUMTHREADS" mode="link_nextpage">
	Author:		Andy Harris
	Context:      /H2G2/REVIEWFORUM/REVIEWFORUMTHREADS
	Purpose:	 Creates the 'Next page' link
	-->
	<xsl:template match="REVIEWFORUMTHREADS" mode="link_nextpage">
		<a href="{$root}RF{../@ID}?show={@COUNT}&amp;skip={number(@SKIPTO) + number(@COUNT)}&amp;order={$var_orderby}&amp;dir={@DIR}&amp;entry=0" xsl:use-attribute-sets="mREVIEWFORUMTHREADS_link_nextpage">
			<xsl:copy-of select="$m_nextpagethreads"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="REVIEWFORUMTHREADS" mode="text_firstpage">
	Author:		Andy Harris
	Context:      /H2G2/REVIEWFORUM/REVIEWFORUMTHREADS
	Purpose:	 Creates the 'On first page' text
	-->
	<xsl:template match="REVIEWFORUMTHREADS" mode="text_firstpage">
		<xsl:copy-of select="$m_nofirstpagethreads"/>
	</xsl:template>
	<!--
	<xsl:template match="REVIEWFORUMTHREADS" mode="text_lastpage">
	Author:		Andy Harris
	Context:      /H2G2/REVIEWFORUM/REVIEWFORUMTHREADS
	Purpose:	 Creates the 'On last page' text
	-->
	<xsl:template match="REVIEWFORUMTHREADS" mode="text_lastpage">
		<xsl:copy-of select="$m_nolastpagethreads"/>
	</xsl:template>
	<!--
	<xsl:template match="REVIEWFORUMTHREADS" mode="text_previouspage">
	Author:		Andy Harris
	Context:      /H2G2/REVIEWFORUM/REVIEWFORUMTHREADS
	Purpose:	 Creates the 'No previous page' text
	-->
	<xsl:template match="REVIEWFORUMTHREADS" mode="text_previouspage">
		<xsl:copy-of select="$m_nopreviouspagethreads"/>
	</xsl:template>
	<!--
	<xsl:template match="REVIEWFORUMTHREADS" mode="text_nextpage">
	Author:		Andy Harris
	Context:      /H2G2/REVIEWFORUM/REVIEWFORUMTHREADS
	Purpose:	 Creates the 'No next page' text
	-->
	<xsl:template match="REVIEWFORUMTHREADS" mode="text_nextpage">
		<xsl:copy-of select="$m_nonextpagethreads"/>
	</xsl:template>
</xsl:stylesheet>
