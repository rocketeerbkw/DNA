<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<xsl:attribute-set name="mJOURNAL_r_firstjournalpage" use-attribute-sets="journallinks"/>
	<xsl:attribute-set name="mJOURNAL_r_lastjournalpage" use-attribute-sets="journallinks"/>
	<!--
	<xsl:template name="JOURNAL_HEADER">
	Author:		Andy Harris
	Context:      /H2G2
	Purpose:	 Creates the title for the page which sits in the html header
	-->
	<xsl:template name="JOURNAL_HEADER">
		<xsl:apply-templates mode="header" select=".">
			<xsl:with-param name="title">
				<xsl:value-of select="$m_pagetitlestart"/>
				<xsl:value-of select="$m_h2g2journaltitle"/>
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>
	<!--
	<xsl:template name="JOURNAL_SUBJECT">
	Author:		Tom Whitehouse
	Context:      /H2G2
	Purpose:	 Creates the text for the subject
	-->
	<xsl:template name="JOURNAL_SUBJECT">
		<xsl:call-template name="SUBJECTHEADER">
			<xsl:with-param name="text">
				<xsl:value-of select="$m_journalforresearcher"/>
				<xsl:value-of select="JOURNAL/@USERID"/>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<!--
	<xsl:template match="JOURNAL" mode="c_journalpage">
	Author:		Andy Harris
	Context:      /H2G2/JOURNAL
	Purpose:	 Calls the container for the JOURNAL object
	-->
	<xsl:template match="JOURNAL" mode="c_journalpage">
		<xsl:apply-templates select="." mode="r_journalpage"/>
	</xsl:template>
	<!--
	<xsl:template match="JOURNALPOSTS" mode="c_journalpage">
	Author:		Andy Harris
	Context:      /H2G2/JOURNAL/JOURNALPOSTS
	Purpose:	 Calls the container for the JOURNALPOSTS object
	-->
	<xsl:template match="JOURNALPOSTS" mode="c_journalpage">
		<xsl:apply-templates select="." mode="r_journalpage"/>
	</xsl:template>
	<!--
	<xsl:template match="POST" mode="c_journalpage">
	Author:		Andy Harris
	Context:      /H2G2/JOURNAL/JOURNALPOSTS/POST
	Purpose:	 Calls the container for the POST object
	-->
	<xsl:template match="POST" mode="c_journalpage">
		<xsl:apply-templates select="." mode="r_journalpage"/>
	</xsl:template>
	<!--
	<xsl:template match="DATEPOSTED/DATE" mode="t_journalpage">
	Author:		Andy Harris
	Context:      /H2G2/JOURNAL/JOURNALPOSTS/POST/DATEPOSTED
	Purpose:	 Creates the text for the DATEPOSTED
	-->
	<xsl:template match="DATEPOSTED/DATE" mode="t_journalpage">
		<xsl:apply-templates select="."/>
	</xsl:template>
	<!--
	<xsl:template match="TEXT" mode="t_journalpage">
	Author:		Andy Harris
	Context:      /H2G2/JOURNAL/JOURNALPOSTS/POST/TEXT
	Purpose:	 Creates the text for the post TEXT
	-->
	<xsl:template match="TEXT" mode="t_journalpage">
		<xsl:apply-templates/>
	</xsl:template>
	<!--
	<xsl:template match="LASTREPLY" mode="c_journalpage">
	Author:		Andy Harris
	Context:      /H2G2/JOURNAL/JOURNALPOSTS/POST/LASTREPLY
	Purpose:	 Calls the correct container for the LASTREPLY object
	-->
	<xsl:template match="LASTREPLY" mode="c_journalpage">
		<xsl:choose>
			<xsl:when test="@COUNT &gt; 1">
				<xsl:apply-templates select="." mode="replies_journalpage"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="." mode="noreplies_journalpage"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="LASTREPLY/DATE" mode="t_journalpage">
	Author:		Andy Harris
	Context:      /H2G2/JOURNAL/JOURNALPOSTS/POST/LASTREPLY/DATE
	Purpose:	 Creates the DATE link for the LASTREPLY
	-->
	<xsl:template match="LASTREPLY/DATE" mode="t_journalpage">
		<a href="{$root}F{../../../@FORUMID}?thread={../../@THREADID}&amp;latest=1" xsl:use-attribute-sets="mLASTREPLYDATE_t_journalpage">
			<xsl:apply-templates select="."/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="@COUNT" mode="t_journalpage">
	Author:		Andy Harris
	Context:      /H2G2/JOURNAL/JOURNALPOSTS/POST/LASTREPLY/@COUNT
	Purpose:	 Creates the COUNT link for the LASTREPLY
	-->
	<xsl:template match="@COUNT" mode="t_journalpage">
		<a href="{$root}F{../../../@FORUMID}?thread={../../@THREADID}" xsl:use-attribute-sets="mCOUNT_t_journalpage">
			<xsl:value-of select="."/>
			<xsl:text> </xsl:text>
			<xsl:copy-of select="$m_noofrepliesjournalpage"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="@POSTID" mode="t_discusslinkjournalpage">
	Author:		Andy Harris
	Context:      /H2G2/JOURNAL/JOURNALPOSTS/POST/@POSTID
	Purpose:	 Creates the 'Discuss this' link
	-->
	<xsl:template match="@POSTID" mode="t_discusslinkjournalpage">
		<a href="{$root}AddThread?InReplyTo={.}" xsl:use-attribute-sets="mPOSTID_t_discusslinkjournalpage">
			<xsl:copy-of select="$m_discusslinkjournalpage"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="@THREADID" mode="c_removelinkjournalpage">
	Author:		Andy Harris
	Context:      /H2G2/JOURNAL/JOURNALPOSTS/POST/@THREADID
	Purpose:	 Calls the container for the 'Remove this' link object if applicable
	-->
	<xsl:template match="@THREADID" mode="c_removelinkjournalpage">
		<xsl:if test="$ownerisviewer = 1">
			<xsl:apply-templates select="." mode="r_removelinkjournalpage"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="@THREADID" mode="r_removelinkjournalpage">
	Author:		Andy Harris
	Context:      /H2G2/JOURNAL/JOURNALPOSTS/POST/@THREADID
	Purpose:	 Creates the 'Remove this' link 
	-->
	<xsl:template match="@THREADID" mode="r_removelinkjournalpage">
		<a href="{$root}FSB{../../@FORUMID}?thread={.}&amp;cmd=unsubscribejournal&amp;page=normal&amp;desc={$alt_subreturntospace}&amp;return=U{$viewerid}" xsl:use-attribute-sets="mTHREADID_r_removelinkjournalpage">
			<xsl:copy-of select="$m_removelinkjournalpage"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="JOURNAL" mode="c_prevjournalpage">
	Author:		Andy Harris
	Context:      /H2G2/JOURNAL
	Purpose:	 Calls the container for the 'Previous' link if necessary 
	-->
	<xsl:template match="JOURNAL" mode="c_prevjournalpage">
		<xsl:if test="JOURNALPOSTS[@SKIPTO &gt; 0]">
			<xsl:apply-templates select="." mode="r_prevjournalpage"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="JOURNAL" mode="r_prevjournalpage">
	Author:		Andy Harris
	Context:      /H2G2/JOURNAL
	Purpose:	 Creates the 'Previous' link 
	-->
	<xsl:template match="JOURNAL" mode="r_prevjournalpage">
		<a href="{$root}MJ{@USERID}?journal={JOURNALPOSTS/@FORUMID}&amp;show={JOURNALPOSTS/@COUNT}&amp;skip={number(JOURNALPOSTS/@SKIPTO) - number(JOURNALPOSTS/@COUNT)}" xsl:use-attribute-sets="mJOURNAL_r_prevjournalpage">
			<xsl:copy-of select="$m_newerjournalentries"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="JOURNAL" mode="c_nextjournalpage">
	Author:		Andy Harris
	Context:      /H2G2/JOURNAL
	Purpose:	 Calls the container for the 'Next' link if necessary 
	-->
	<xsl:template match="JOURNAL" mode="c_nextjournalpage">
		<xsl:if test="JOURNALPOSTS[@MORE=1]">
			<xsl:apply-templates select="." mode="r_nextjournalpage"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="JOURNAL" mode="r_nextjournalpage">
	Author:		Andy Harris
	Context:      /H2G2/JOURNAL
	Purpose:	 Creates the 'Next' link 
	-->
	<xsl:template match="JOURNAL" mode="r_nextjournalpage">
		<a href="{$root}MJ{@USERID}?journal={JOURNALPOSTS/@FORUMID}&amp;show={JOURNALPOSTS/@COUNT}&amp;skip={number(JOURNALPOSTS/@SKIPTO) + number(JOURNALPOSTS/@COUNT)}" xsl:use-attribute-sets="mJOURNAL_r_nextjournalpage">
			<xsl:copy-of select="$m_olderjournalentries"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="JOURNAL" mode="t_userpagelinkjournalpage">
	Author:		Andy Harris
	Context:      /H2G2/JOURNAL
	Purpose:	 Creates the 'Back to userpage' link 
	-->
	<xsl:template match="JOURNAL" mode="t_userpagelinkjournalpage">
		<a href="{$root}U{@USERID}" xsl:use-attribute-sets="mJOURNAL_t_userpagelinkjournalpage">
			<xsl:value-of select="$m_backtoresearcher"/>
		</a>
	</xsl:template>
	<xsl:template match="JOURNAL" mode="c_firstjournalpage">
		<xsl:if test="JOURNALPOSTS[@SKIPTO &gt; 0]">
			<xsl:apply-templates select="." mode="r_firstjournalpage"/>
		</xsl:if>
	</xsl:template>
	<xsl:template match="JOURNAL" mode="c_lastjournalpage">
		
		<xsl:if test="JOURNALPOSTS[@MORE=1]">
			<xsl:apply-templates select="." mode="r_lastjournalpage"/>
		</xsl:if>
	</xsl:template>

	<xsl:template match="JOURNAL" mode="r_firstjournalpage">
		<a href="{$root}MJ{@USERID}?journal={JOURNALPOSTS/@FORUMID}&amp;show={JOURNALPOSTS/@COUNT}" xsl:use-attribute-sets="mJOURNAL_r_firstjournalpage">
			<xsl:copy-of select="$m_firstjournalpage"/>
				
		</a>
	</xsl:template>

	<xsl:template match="JOURNAL" mode="r_lastjournalpage">
		<xsl:variable name="lastpage" select="(ceiling(/H2G2/JOURNAL/JOURNALPOSTS/@TOTALTHREADS div /H2G2/JOURNAL/JOURNALPOSTS/@COUNT) - 1) * /H2G2/JOURNAL/JOURNALPOSTS/@COUNT"/>
		<a href="{$root}MJ{@USERID}?journal={JOURNALPOSTS/@FORUMID}&amp;show={JOURNALPOSTS/@COUNT}&amp;skip={$lastpage}" xsl:use-attribute-sets="mJOURNAL_r_lastjournalpage">
			<xsl:copy-of select="$m_lastjournalpage"/>
			
		</a>
	</xsl:template>
</xsl:stylesheet>
