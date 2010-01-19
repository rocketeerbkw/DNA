<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<xsl:variable name="num_currentpage" select="(/H2G2/FORUMTHREADPOSTS/@SKIPTO + /H2G2/FORUMTHREADPOSTS/@COUNT) div  /H2G2/FORUMTHREADPOSTS/@COUNT"/>
	<xsl:variable name="num_totalpages" select="ceiling(/H2G2/FORUMTHREADPOSTS/@TOTALPOSTCOUNT div /H2G2/FORUMTHREADPOSTS/@COUNT)"/>
	<!--
	<xsl:template name="THREADS_HEADER">
	Author:		Andy Harris
	Context:      H2G2
	Purpose:	 Creates the title for the page which sits in the html header
	-->
	<xsl:template name="THREADS_HEADER">
		<xsl:apply-templates mode="header" select=".">
			<xsl:with-param name="title">
				<xsl:value-of select="$m_pagetitlestart"/>Conversations</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>
	<!--
	<xsl:template name="THREADS_SUBJECT">
	Author:		Tom Whitehouse
	Context:      H2G2
	Purpose:	 Creates the text for the subject
	-->
	<xsl:template name="THREADS_SUBJECT">
		<xsl:choose>
			<xsl:when test="FORUMSOURCE/@TYPE='journal'">
				<xsl:value-of select="$m_thisjournal_tp"/>
				<xsl:apply-templates select="FORUMSOURCE" mode="journal_forumsource"/>
			</xsl:when>
			<xsl:when test="FORUMSOURCE/@TYPE='reviewforum'">
				<xsl:value-of select="$m_thisconvforentry_tp"/>
				<xsl:apply-templates select="FORUMSOURCE" mode="reviewforum_forumsource"/>
			</xsl:when>
			<xsl:when test="FORUMSOURCE/@TYPE='userpage'">
				<xsl:value-of select="$m_thismessagecentre_tp"/>
				<xsl:apply-templates select="FORUMSOURCE" mode="userpage_forumsource"/>
			</xsl:when>
			<xsl:when test="FORUMSOURCE/@TYPE='club'">
				<xsl:copy-of select="$m_thisconvforclub_tp"/>
				<xsl:apply-templates select="FORUMSOURCE" mode="club_forumsource"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$m_thisconvforentry_tp"/>
				<xsl:apply-templates select="FORUMSOURCE" mode="article_forumsource"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="FORUMSOURCE/ARTICLE/GUIDE/FORUMTHREADINTRO|FORUMSOURCE/ARTICLE/GUIDE/FORUMINTRO" mode="c_threadspage">
	Author:		Andy Harris
	Context:      /H2G2/FORUMSOURCE/ARTICLE/GUIDE/FORUMTHREADINTRO or
				    /H2G2/FORUMSOURCE/ARTICLE/GUIDE/FORUMINTRO
	Purpose:	 Calls the container for the FORUMINTRO or FORUMTHREADINTRO object
	-->
	<xsl:template match="FORUMSOURCE/ARTICLE/GUIDE/FORUMTHREADINTRO|FORUMSOURCE/ARTICLE/GUIDE/FORUMINTRO" mode="c_threadspage">
		<xsl:apply-templates select="." mode="r_threadspage"/>
	</xsl:template>
	<!--
	<xsl:template match="FORUMTHREADS" mode="c_threadspage">
	Author:		Andy Harris
	Context:      /H2G2/FORUMTHREADS
	Purpose:	 Calls the container for the FORUMTHREADS object
	-->
	<xsl:template match="FORUMTHREADS" mode="c_threadspage">
		<xsl:apply-templates select="." mode="r_threadspage"/>
	</xsl:template>
	<!--
	<xsl:template match="THREAD" mode="c_threadspage">
	Author:		Andy Harris
	Context:      /H2G2/FORUMTHREADS/THREAD
	Purpose:	 Calls the container for the THREAD object
	-->
	<xsl:template match="THREAD" mode="c_threadspage">
		<xsl:apply-templates select="." mode="r_threadspage"/>
	</xsl:template>
	<!--
	<xsl:template match="SUBJECT" mode="t_threadspage">
	Author:		Andy Harris
	Context:      /H2G2/FORUMTHREADS/THREAD/SUBJECT
	Purpose:	 Creates the SUBJECT link for the THREAD
	-->
	<xsl:template match="SUBJECT" mode="t_threadspage">
		<a href="{$root}F{../@FORUMID}?thread={../@THREADID}" xsl:use-attribute-sets="mSUBJECT_t_threadspage">
			<xsl:value-of select="."/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="TOTALPOSTS" mode="t_numberofreplies">
	Author:		Andy Harris
	Context:      /H2G2/FORUMTHREADS/THREAD/TOTALPOSTS
	Purpose:	 Calculates the number of replies
	-->
	<xsl:template match="TOTALPOSTS" mode="t_numberofreplies">
		<xsl:value-of select=". - 1"/>
	</xsl:template>
	<!--
	<xsl:template match="FIRSTPOST" mode="c_threadspage">
	Author:		Andy Harris
	Context:      /H2G2/FORUMTHREADS/THREAD/FIRSTPOST
	Purpose:	 Calls the container for the FIRSTPOST object
	-->
	<xsl:template match="FIRSTPOST" mode="c_threadspage">
		<xsl:apply-templates select="." mode="r_threadspage"/>
	</xsl:template>
	<xsl:template match="TEXT" mode="t_firstposttp">
		<xsl:value-of select="."/>
	</xsl:template>
	<xsl:template match="USER" mode="t_firstposttp">
		<a href="{$root}U{USERID}" xsl:use-attribute-sets="mUSER_t_firstposttp">
			<xsl:value-of select="USERNAME"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="LASTPOST" mode="c_threadspage">
	Author:		Andy Harris
	Context:      /H2G2/FORUMTHREADS/THREAD/LASTPOST
	Purpose:	 Calls the container for the LASTPOST object
	-->
	<xsl:template match="LASTPOST" mode="c_threadspage">
		<xsl:apply-templates select="." mode="r_threadspage"/>
	</xsl:template>
	<xsl:template match="TEXT" mode="t_lastposttp">
		<xsl:value-of select="."/>
	</xsl:template>
	<xsl:template match="USER" mode="t_lastposttp">
		<a href="{$root}U{USERID}" xsl:use-attribute-sets="mUSER_t_lastposttp">
			<xsl:value-of select="USERNAME"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="@THREADID" mode="c_movethreadgadget">
	Author:		Andy Harris
	Context:      /H2G2/FORUMTHREADS/THREAD/@THREADID
	Purpose:	 Calls the container for the 'move thread gadget' if the viewer is an editor
	-->
	<xsl:template match="@THREADID" mode="c_movethreadgadget">
		<xsl:if test="/H2G2/VIEWING-USER/USER/GROUPS/EDITOR or ($superuser = 1)">
			<xsl:apply-templates select="." mode="r_movethreadgadget"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="@THREADID" mode="r_movethreadgadget">
	Author:		Andy Harris
	Context:      /H2G2/FORUMTHREADS/THREAD/@THREADID
	Purpose:	 Creates the 'move thread gadget' link
	-->
	<xsl:template match="@THREADID" mode="r_movethreadgadget">
		<a onClick="popupwindow('{$root}MoveThread?cmd=Fetch&amp;ThreadID={.}&amp;DestinationID=F0&amp;mode=POPUP','MoveThreadWindow','scrollbars=1,resizable=1,width=400,height=400');return false;" href="{$root}MoveThread?cmd=Fetch&amp;ThreadID={.}&amp;DestinationID=F0&amp;mode=POPUP" xsl:use-attribute-set="mTHREADID_r_movethreadgadget">
			<xsl:value-of select="$m_MoveThread"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="THREAD" mode="c_hidethread">
	Author:		Andy Harris
	Context:      /H2G2/FORUMTHREADS/THREAD/@THREADID
	Purpose:	 Calls the container for the 'hide thread' link if the viewer is an editor
	-->
	<xsl:template match="THREAD" mode="c_hidethread">
		<xsl:if test="/H2G2/VIEWING-USER/USER/GROUPS/EDITOR or ($superuser = 1)">
			<xsl:apply-templates select="." mode="r_hidethread"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="THREAD" mode="r_hidethread">
	Author:		Andy Harris
	Context:      /H2G2/FORUMTHREADS/THREAD/@THREADID
	Purpose:	 Creates the 'hide thread' link
	-->
	<xsl:template match="THREAD" mode="r_hidethread">
		<xsl:if test="@CANREAD=1">
			<a href="{$root}F{@FORUMID}?HideThread={@THREADID}" xsl:use-attribute-sets="mTHREAD_r_hidethread">
				<xsl:value-of select="$m_HideThread"/>
			</a>
		</xsl:if>
		<xsl:if test="@CANREAD=0">
			<a href="{$root}F{@FORUMID}?UnHideThread={@THREADID}" xsl:use-attribute-sets="mTHREAD_r_hidethread">
				<xsl:value-of select="$m_UnhideThread"/>
			</a>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="FORUMTHREADS" mode="c_subscribe">
	Author:		Andy Harris
	Context:      /H2G2/FORUMTHREADS
	Purpose:	 Calls the container for the 'Subscribe' or 'Unsubscribe' link if the viewer is registered
	-->
	<xsl:template match="FORUMTHREADS" mode="c_subscribe">
		<xsl:if test="$registered=1">
			<xsl:apply-templates select="." mode="r_subscribe"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="FORUMTHREADS" mode="r_subscribe">
	Author:		Andy Harris
	Context:      /H2G2/FORUMTHREADS
	Purpose:	 Creates the 'Subscribe' or 'Unsubscribe link
	-->
	<xsl:template match="FORUMTHREADS" mode="r_subscribe">
		<xsl:choose>
			<xsl:when test="SUBSCRIBE-STATE[@FORUM='1']">
				<a xsl:use-attribute-sets="mFORUMTHREADS_r_subscribe_unsub">
					<xsl:attribute name="href"><xsl:value-of select="$root"/>FSB<xsl:value-of select="@FORUMID"/>?thread=<xsl:value-of select="@THREADID"/>&amp;skip=<xsl:value-of select="@SKIPTO"/>&amp;show=<xsl:value-of select="@COUNT"/>&amp;cmd=unsubscribeforum&amp;page=normal&amp;desc=<xsl:value-of select="$alt_subreturntoconv"/>&amp;return=F<xsl:value-of select="@FORUMID"/>%3Fthread=<xsl:value-of select="@THREADID"/>%26amp;skip=<xsl:value-of select="@SKIPTO"/>%26amp;show=<xsl:value-of select="@COUNT"/></xsl:attribute>
					<xsl:copy-of select="$m_clickunsubforum"/>
				</a>
			</xsl:when>
			<xsl:otherwise>
				<a xsl:use-attribute-sets="mFORUMTHREADS_r_subscribe">
					<xsl:attribute name="href"><xsl:value-of select="$root"/>FSB<xsl:value-of select="@FORUMID"/>?thread=<xsl:value-of select="@THREADID"/>&amp;skip=<xsl:value-of select="@SKIPTO"/>&amp;show=<xsl:value-of select="@COUNT"/>&amp;cmd=subscribeforum&amp;page=normal&amp;desc=<xsl:value-of select="$alt_subreturntoconv"/>&amp;return=F<xsl:value-of select="@FORUMID"/>%3Fthread=<xsl:value-of select="@THREADID"/>%26amp;skip=<xsl:value-of select="@SKIPTO"/>%26amp;show=<xsl:value-of select="@COUNT"/></xsl:attribute>
					<xsl:copy-of select="$m_clicksubforum"/>
				</a>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="FORUMTHREADS" mode="c_emailalerts">
	Author:		Andy Harris
	Context:      /H2G2/FORUMTHREADS
	Purpose:	 Calls the container for the email alerts if the viewer is registered
	-->
	<xsl:template match="FORUMTHREADS" mode="c_emailalerts">
		<xsl:if test="$registered=1">
			<form method="post" action="{$root}F{@FORUMID}">
				<input type="hidden" name="cmd" value="alertinstantly"/>
				<xsl:apply-templates select="." mode="r_emailalerts"/>
			</form>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="FORUMTHREADS" mode="t_emailalertson">
	Author:		Andy Harris
	Context:      /H2G2/FORUMTHREADS
	Purpose:	 Creates the email alerts on radio button
	-->
	<xsl:template match="FORUMTHREADS" mode="t_emailalertson">
		<input type="radio" name="alertinstantly" value="1">
			<xsl:if test="/H2G2/FORUMSOURCE/ALERTINSTANTLY='1'">
				<xsl:attribute name="checked">checked</xsl:attribute>
			</xsl:if>
		</input>
	</xsl:template>
	<!--
	<xsl:template match="FORUMTHREADS" mode="t_emailalertsoff">
	Author:		Andy Harris
	Context:      /H2G2/FORUMTHREADS
	Purpose:	 Creates the email alerts off radio button
	-->
	<xsl:template match="FORUMTHREADS" mode="t_emailalertsoff">
		<input type="radio" name="alertinstantly" value="0">
			<xsl:if test="/H2G2/FORUMSOURCE/ALERTINSTANTLY='0'">
				<xsl:attribute name="checked">checked</xsl:attribute>
			</xsl:if>
		</input>
	</xsl:template>
	<!--
	<xsl:template match="FORUMTHREADS" mode="t_emailalertssubmit">
	Author:		Andy Harris
	Context:      /H2G2/FORUMTHREADS
	Purpose:	 Creates the email alerts submit button
	-->
	<xsl:template match="FORUMTHREADS" mode="t_emailalertssubmit">
		<input value="go" xsl:use-attribute-sets="mFORUMTHREADS_t_emailalertssubmit"/>
	</xsl:template>
	<xsl:attribute-set name="mFORUMTHREADS_t_emailalertssubmit">
		<xsl:attribute name="type">submit</xsl:attribute>
		<xsl:attribute name="name">submit</xsl:attribute>
	</xsl:attribute-set>
	<!--
	<xsl:template match="FORUMTHREADS" mode="c_newconversation">
	Author:		Andy Harris
	Context:      /H2G2/FORUMTHREADS
	Purpose:	 Calls the container for the 'New Conversation' link
	-->
	<xsl:template match="FORUMTHREADS" mode="c_newconversation">
		<xsl:if test="not(/H2G2/FORUMSOURCE[@TYPE='reviewforum'])">
			<xsl:if test="not(/H2G2/FORUMTHREADS/@JOURNALOWNER) or (number(/H2G2/FORUMTHREADS/@JOURNALOWNER) = number(/H2G2/VIEWING-USER/USER/USERID))">
				<xsl:apply-templates select="." mode="r_newconversation"/>
			</xsl:if>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="FORUMTHREADS" mode="r_newconversation">
	Author:		Andy Harris
	Context:      /H2G2/FORUMTHREADS
	Purpose:	 Creates the 'New Conversation' link
	-->
	<xsl:template match="FORUMTHREADS" mode="r_newconversation">
		<a xsl:use-attribute-sets="mFORUMTHREADS_r_newconversation">
			<xsl:attribute name="href"><xsl:call-template name="sso_addcomment_signin"/></xsl:attribute>
			<xsl:copy-of select="$alt_newconversation"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="FORUMTHREADS" mode="c_firstpage">
	Author:		Andy Harris
	Context:      /H2G2/FORUMTHREADS
	Purpose:	 Calls the correct container for the 'First page' link
	-->
	<xsl:template match="FORUMTHREADS" mode="c_firstpage">
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
	<xsl:template match="FORUMTHREADS" mode="c_lastpage">
	Author:		Andy Harris
	Context:      /H2G2/FORUMTHREADS
	Purpose:	 Calls the correct container for the 'Last page' link
	-->
	<xsl:template match="FORUMTHREADS" mode="c_lastpage">
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
	<xsl:template match="FORUMTHREADS" mode="c_previouspage">
	Author:		Andy Harris
	Context:      /H2G2/FORUMTHREADS
	Purpose:	 Calls the correct container for the 'Previous page' link
	-->
	<xsl:template match="FORUMTHREADS" mode="c_previouspage">
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
	<xsl:template match="FORUMTHREADS" mode="c_nextpage">
	Author:		Andy Harris
	Context:      /H2G2/FORUMTHREADS
	Purpose:	 Calls the correct container for the 'Next page' link
	-->
	<xsl:template match="FORUMTHREADS" mode="c_nextpage">
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
	<xsl:template match="FORUMTHREADS" mode="link_firstpage">
	Author:		Andy Harris
	Context:      /H2G2/FORUMTHREADS
	Purpose:	 Creates the 'First page' link
	-->
	<xsl:template match="FORUMTHREADS" mode="link_firstpage">
		<a href="{$root}F{@FORUMID}?show={@COUNT}&amp;skip=0" xsl:use-attribute-sets="mFORUMTHREADS_link_firstpage">
			<xsl:copy-of select="$m_firstpagethreads"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="FORUMTHREADS" mode="link_lastpage">
	Author:		Andy Harris
	Context:      /H2G2/FORUMTHREADS
	Purpose:	 Creates the 'Last page' link
	-->
	<xsl:template match="FORUMTHREADS" mode="link_lastpage">
		<a href="{$root}F{@FORUMID}?show={@COUNT}&amp;skip={number(@TOTALTHREADS) - number(@COUNT)}" xsl:use-attribute-sets="mFORUMTHREADS_link_lastpage">
			<xsl:copy-of select="$m_lastpagethreads"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="FORUMTHREADS" mode="link_previouspage">
	Author:		Andy Harris
	Context:      /H2G2/FORUMTHREADS
	Purpose:	 Creates the 'Previous page' link
	-->
	<xsl:template match="FORUMTHREADS" mode="link_previouspage">
		<a href="{$root}F{@FORUMID}?show={@COUNT}&amp;skip={number(@SKIPTO) - number(@COUNT)}" xsl:use-attribute-sets="mFORUMTHREADS_link_previouspage">
			<xsl:copy-of select="$m_previouspagethreads"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="FORUMTHREADS" mode="link_nextpage">
	Author:		Andy Harris
	Context:      /H2G2/FORUMTHREADS
	Purpose:	 Creates the 'Next page' link
	-->
	<xsl:template match="FORUMTHREADS" mode="link_nextpage">
		<a href="{$root}F{@FORUMID}?show={@COUNT}&amp;skip={number(@SKIPTO) + number(@COUNT)}" xsl:use-attribute-sets="mFORUMTHREADS_link_nextpage">
			<xsl:copy-of select="$m_nextpagethreads"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="FORUMTHREADS" mode="text_firstpage">
	Author:		Andy Harris
	Context:      /H2G2/FORUMTHREADS
	Purpose:	 Creates the 'On first page' text
	-->
	<xsl:template match="FORUMTHREADS" mode="text_firstpage">
		<xsl:copy-of select="$m_nofirstpagethreads"/>
	</xsl:template>
	<!--
	<xsl:template match="FORUMTHREADS" mode="text_lastpage">
	Author:		Andy Harris
	Context:      /H2G2/FORUMTHREADS
	Purpose:	 Creates the 'On last page' text
	-->
	<xsl:template match="FORUMTHREADS" mode="text_lastpage">
		<xsl:copy-of select="$m_nolastpagethreads"/>
	</xsl:template>
	<!--
	<xsl:template match="FORUMTHREADS" mode="text_previouspage">
	Author:		Andy Harris
	Context:      /H2G2/FORUMTHREADS
	Purpose:	 Creates the 'No previous page' text
	-->
	<xsl:template match="FORUMTHREADS" mode="text_previouspage">
		<xsl:copy-of select="$m_nopreviouspagethreads"/>
	</xsl:template>
	<!--
	<xsl:template match="FORUMTHREADS" mode="text_nextpage">
	Author:		Andy Harris
	Context:      /H2G2/FORUMTHREADS
	Purpose:	 Creates the 'No next page' text
	-->
	<xsl:template match="FORUMTHREADS" mode="text_nextpage">
		<xsl:copy-of select="$m_nonextpagethreads"/>
	</xsl:template>
	<!--
	<xsl:template match="@SKIPTO" mode="text_gotobeginning">
	Author:		Tom Whitehouse
	Context:      /H2G2/FORUMTHREADPOSTS/@SKIPTO
	Purpose:	 Creates the text for 'showing oldest conversation' 
	-->
	<xsl:template match="@SKIPTO" mode="text_tpgotobeginning">
		<xsl:copy-of select="$alt_showingoldest"/>
	</xsl:template>
	<!--
	<xsl:template match="@SKIPTO" mode="text_gotoprevious">
	Author:		Tom Whitehouse
	Context:      /H2G2/FORUMTHREADPOSTS/@SKIPTO
	Purpose:	 Creates the text for 'no older conversations' 
	-->
	<xsl:template match="@SKIPTO" mode="text_tpgotoprevious">
		<xsl:copy-of select="$m_noolderconv"/>
	</xsl:template>
	<!--
	<xsl:template match="@SKIPTO" mode="text_gotonext">
	Author:		Tom Whitehouse
	Context:      /H2G2/FORUMTHREADPOSTS/@SKIPTO
	Purpose:	 Creates the text for 'no newer conversations' 
	-->
	<xsl:template match="@SKIPTO" mode="text_tpgotonext">
		<xsl:copy-of select="$alt_nonewconvs"/>
	</xsl:template>
	<!--
	<xsl:template match="@SKIPTO" mode="text_gotolatest">
	Author:		Tom Whitehouse
	Context:      /H2G2/FORUMTHREADPOSTS/@SKIPTO
	Purpose:	 Creates the text for 'showing newest conversation' 
	-->
	<xsl:template match="@SKIPTO" mode="text_tpgotolatest">
		<xsl:copy-of select="$alt_nonewerpost"/>
	</xsl:template>
	<!--
	<xsl:template match="@SKIPTO" mode="c_gotobeginning">
	Author:		Tom Whitehouse
	Context:      /H2G2/FORUMTHREADPOSTS/@SKIPTO
	Purpose:	 Chooses correct link or text for 'go to beginning' button
	-->
	<xsl:template match="@SKIPTO" mode="c_tpgotobeginning">
		<xsl:choose>
			<xsl:when test=". != 0">
				<xsl:apply-templates select="." mode="link_tpgotobeginning"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="." mode="text_tpgotobeginning"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="@SKIPTO" mode="link_gotobeginning">
	Author:		Tom Whitehouse
	Context:      /H2G2/FORUMTHREADPOSTS/@SKIPTO
	Purpose:	 Creates 'go to beginning' link
	-->
	<xsl:template match="@SKIPTO" mode="link_tpgotobeginning">
		<a href="{$root}F{../@FORUMID}?skip={(.) - (../@COUNT)}&amp;show={../@COUNT}" xsl:use-attribute-sets="maSKIPTO_link_tpgotobeginning">
			<xsl:copy-of select="$alt_showoldestconv"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="@SKIPTO" mode="c_gotoprevious">
	Author:		Tom Whitehouse
	Context:      /H2G2/FORUMTHREADPOSTS/@SKIPTO
	Purpose:	 Chooses correct link or text for 'previous' button
	-->
	<xsl:template match="@SKIPTO" mode="c_tpgotoprevious">
		<xsl:choose>
			<xsl:when test=". != 0">
				<xsl:apply-templates select="." mode="link_tpgotoprevious"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="." mode="text_tpgotoprevious"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="@SKIPTO" mode="link_gotoprevious">
	Author:		Tom Whitehouse
	Context:      /H2G2/FORUMTHREADPOSTS/@SKIPTO
	Purpose:	 Creates 'previous' link
	-->
	<xsl:template match="@SKIPTO" mode="link_tpgotoprevious">
		<a href="{$root}F{../@FORUMID}?skip={(.) - (../@COUNT)}&amp;show={../@COUNT}" xsl:use-attribute-sets="maSKIPTO_link_tpgotoprevious">
			<xsl:value-of select="concat($alt_showpostings, (.) - (../@COUNT) + 1, $alt_to, .)"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="@SKIPTO" mode="c_gotonext">
	Author:		Tom Whitehouse
	Context:      /H2G2/FORUMTHREADPOSTS/@SKIPTO
	Purpose:	 Calls the correct 'next' link/text
	-->
	<xsl:template match="@SKIPTO" mode="c_tpgotonext">
		<xsl:choose>
			<xsl:when test="../@MORE = 1">
				<xsl:apply-templates select="." mode="link_tpgotonext"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="." mode="text_tpgotonext"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="@SKIPTO" mode="link_gotonext">
	Author:		Tom Whitehouse
	Context:      /H2G2/FORUMTHREADPOSTS/@SKIPTO
	Purpose:	 Creates the 'next' link
	-->
	<xsl:template match="@SKIPTO" mode="link_tpgotonext">
		<a href="{$root}F{../@FORUMID}?skip={(.) + (../@COUNT)}&amp;show={../@COUNT}" xsl:use-attribute-sets="maSKIPTO_link_tpgotonext">
			<xsl:value-of select="concat($alt_showpostings, ((.) + (../@COUNT) + 1), $alt_to, ((.) + (../@COUNT) + (../@COUNT)))"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="@SKIPTO" mode="c_gotolatest">
	Author:		Tom Whitehouse
	Context:      /H2G2/FORUMTHREADPOSTS/@SKIPTO
	Purpose:	 Calls the correct 'go to latest' link/text
	-->
	<xsl:template match="@SKIPTO" mode="c_tpgotolatest">
		<xsl:choose>
			<xsl:when test="../@MORE = 1">
				<xsl:apply-templates select="." mode="link_tpgotolatest"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="." mode="text_tpgotolatest"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="@SKIPTO" mode="link_gotolatest">
	Author:		Tom Whitehouse
	Context:      /H2G2/FORUMTHREADPOSTS/@SKIPTO
	Purpose:	 Creates the 'go to latest' link
	-->
	<xsl:template match="@SKIPTO" mode="link_tpgotolatest">
		<a href="{$root}F{../@FORUMID}?skip={floor(../@TOTALPOSTCOUNT div ../@COUNT) * 20}&amp;show={../@COUNT}" xsl:use-attribute-sets="maSKIPTO_link_tpgotolatest">
			<xsl:copy-of select="$alt_shownewest"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="FORUMTHREADPOSTS" mode="c_threadblocks">
	Author:		Andy Harris
	Context:      /H2G2/FORUMTHREADPOSTS
	Purpose:	 Calls the container for the thread blocks navigation
	-->
	<xsl:template match="FORUMTHREADPOSTS" mode="c_threadblocks">
		<xsl:apply-templates select="." mode="r_threadblocks"/>
	</xsl:template>
	<!--
	<xsl:template match="FORUMTHREADPOSTS" mode="c_threadblockdisplayprev">
	Author:		Andy Harris
	Context:      /H2G2/FORUMTHREADPOSTS
	Purpose:	 Calls the container for the previous link in the thread blocks navigation
	-->
	<xsl:template match="FORUMTHREADPOSTS" mode="c_threadblockdisplayprev">
		<xsl:if test="($tp_lowerrange != 0)">
			<xsl:apply-templates select="." mode="r_threadblockdisplayprev"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="FORUMTHREADPOSTS" mode="r_threadblockdisplayprev">
	Author:		Andy Harris
	Context:      /H2G2/FORUMTHREADPOSTS
	Purpose:	 Creates the previous link in the thread blocks navigation
	-->
	<xsl:template match="FORUMTHREADPOSTS" mode="r_threadblockdisplayprev">
		<a href="{$root}F{@FORUMID}?thread={@THREADID}&amp;skip={$tp_lowerrange - @COUNT}&amp;show={@COUNT}" xsl:use-attribute-sets="mFORUMTHREADPOSTS_r_threadblockdisplayprev">
			<xsl:copy-of select="$m_threadpostblockprev"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="FORUMTHREADPOSTS" mode="c_threadblockdisplaynext">
	Author:		Andy Harris
	Context:      /H2G2/FORUMTHREADPOSTS
	Purpose:	 Calls the container for the next link in the thread blocks navigation
	-->
	<xsl:template match="FORUMTHREADPOSTS" mode="c_threadblockdisplaynext">
		<xsl:if test="(($tp_upperrange + @COUNT) &lt; @TOTALPOSTCOUNT)">
			<xsl:apply-templates select="." mode="r_blockdisplaynext"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="FORUMTHREADPOSTS" mode="r_threadblockdisplaynext">
	Author:		Andy Harris
	Context:      /H2G2/FORUMTHREADPOSTS
	Purpose:	 Creates the next link in the thread blocks navigation
	-->
	<xsl:template match="FORUMTHREADPOSTS" mode="r_threadblockdisplaynext">
		<a href="{$root}F{@FORUMID}?thread={@THREADID}&amp;skip={$tp_upperrange + @COUNT}&amp;show={@COUNT}" xsl:use-attribute-sets="mFORUMTHREADPOSTS_r_threadblockdisplaynext">
			<xsl:copy-of select="$m_threadpostblocknext"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="FORUMTHREADPOSTS" mode="c_threadblockdisplay">
	Author:		Andy Harris
	Context:      /H2G2/FORUMTHREADPOSTS
	Purpose:	 Calls the template to create the links in the thread blocks navigation
	-->
	<xsl:template match="FORUMTHREADPOSTS" mode="c_threadblockdisplay">
		<xsl:param name="onlink"/>
		<xsl:param name="skip" select="$tp_lowerrange"/>
		<xsl:apply-templates select="." mode="displayblocktp">
			<xsl:with-param name="skip" select="$skip"/>
			<xsl:with-param name="onlink" select="$onlink"/>
		</xsl:apply-templates>
		<xsl:if test="(($skip + @COUNT) &lt; @TOTALPOSTCOUNT) and ($skip &lt; $tp_upperrange)">
			<xsl:apply-templates select="." mode="c_threadblockdisplay">
				<xsl:with-param name="skip" select="$skip + @COUNT"/>
				<xsl:with-param name="onlink" select="$onlink"/>
			</xsl:apply-templates>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="FORUMTHREADPOSTS" mode="displayblocktp">
	Author:		Tom Whitehouse
	Context:      /H2G2/FORUMTHREADPOSTS
	Purpose:	 Creates the individual links in the postblock area within the range set above
	-->
	<xsl:template match="FORUMTHREADPOSTS" mode="displayblocktp">
		<xsl:param name="skip"/>
		<xsl:param name="onlink"/>
		<xsl:param name="PostRange" select="concat(($skip + 1), ' - ', ($skip + @COUNT))"/>
		<xsl:choose>
			<xsl:when test="@SKIPTO = $skip">
				<xsl:apply-templates select="." mode="on_threadblockdisplay">
					<xsl:with-param name="url">
						<xsl:choose>
							<xsl:when test="$onlink = 'no'">
								<xsl:call-template name="t_threadontabcontent">
									<xsl:with-param name="range" select="$PostRange"/>
									<xsl:with-param name="pagenumber" select="substring-after($PostRange, ' - ') div @COUNT"/>
								</xsl:call-template>
							</xsl:when>
							<xsl:otherwise>
								<a href="{$root}F{@FORUMID}?thread={@THREADID}&amp;skip={$skip}&amp;show={@COUNT}" xsl:use-attribute-sets="mFORUMTHREADPOSTS_on_threadblockdisplay">
									<xsl:call-template name="t_threadontabcontent">
										<xsl:with-param name="range" select="$PostRange"/>
										<xsl:with-param name="pagenumber" select="substring-after($PostRange, ' - ') div @COUNT"/>
									</xsl:call-template>
								</a>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:with-param>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="." mode="off_threadblockdisplay">
					<xsl:with-param name="url">
						<a href="{$root}F{@FORUMID}?thread={@THREADID}&amp;skip={$skip}&amp;show={@COUNT}" xsl:use-attribute-sets="mFORUMTHREADPOSTS_off_threadblockdisplay">
							<xsl:call-template name="t_threadofftabcontent">
								<xsl:with-param name="range" select="$PostRange"/>
								<xsl:with-param name="pagenumber" select="substring-after($PostRange, ' - ') div @COUNT"/>
							</xsl:call-template>
						</a>
					</xsl:with-param>
				</xsl:apply-templates>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="FORUMTHREADS" mode="c_threadblocks">
	Author:		Andy Harris
	Context:      /H2G2/FORUMTHREADS
	Purpose:	 Calls the container for the thread blocks navigation
	-->
	<xsl:template match="FORUMTHREADS" mode="c_threadblocks">
		<xsl:apply-templates select="." mode="r_threadblocks"/>
	</xsl:template>
	<!--
	<xsl:template match="FORUMTHREADS" mode="c_threadblockdisplayprev">
	Author:		Andy Harris
	Context:      /H2G2/FORUMTHREADS
	Purpose:	 Calls the container for the previous link in the thread blocks navigation
	-->
	<xsl:template match="FORUMTHREADS" mode="c_threadblockdisplayprev">
		<xsl:if test="($tp_lowerrange != 0)">
			<xsl:apply-templates select="." mode="r_threadblockdisplayprev"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="FORUMTHREADS" mode="r_threadblockdisplayprev">
	Author:		Andy Harris
	Context:      /H2G2/FORUMTHREADS
	Purpose:	 Creates the previous link in the thread blocks navigation
	-->
	<xsl:template match="FORUMTHREADS" mode="r_threadblockdisplayprev">
		<a href="{$root}F{@FORUMID}?skip={$tp_lowerrange - @COUNT}&amp;show={@COUNT}" xsl:use-attribute-sets="mFORUMTHREADS_r_threadblockdisplayprev">
			<xsl:copy-of select="$m_threadpostblockprev"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="FORUMTHREADS" mode="c_threadblockdisplayprev">
	Author:		Andy Harris
	Context:      /H2G2/FORUMTHREADS
	Purpose:	 Calls the container for the next link in the thread blocks navigation
	-->
	<xsl:template match="FORUMTHREADS" mode="c_threadblockdisplaynext">
		<xsl:if test="(($tp_upperrange + @COUNT) &lt; @TOTALTHREADS)">
			<xsl:apply-templates select="." mode="r_threadblockdisplaynext"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="FORUMTHREADS" mode="r_threadblockdisplayprev">
	Author:		Andy Harris
	Context:      /H2G2/FORUMTHREADS
	Purpose:	 Creates the next link in the thread blocks navigation
	-->
	<xsl:template match="FORUMTHREADS" mode="r_threadblockdisplaynext">
		<a href="{$root}F{@FORUMID}?skip={$tp_upperrange + @COUNT}&amp;show={@COUNT}" xsl:use-attribute-sets="mFORUMTHREADS_r_threadblockdisplaynext">
			<xsl:copy-of select="$m_threadpostblocknext"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="FORUMTHREADS" mode="c_threadblockdisplay">
	Author:		Andy Harris
	Context:      /H2G2/FORUMTHREADS
	Purpose:	 Calls the template to create the links in the thread blocks navigation
	-->
	<xsl:template match="FORUMTHREADS" mode="c_threadblockdisplay">
		<xsl:param name="onlink"/>
		<xsl:param name="skip" select="$tp_lowerrange"/>
		<xsl:apply-templates select="." mode="displayblocktp">
			<xsl:with-param name="skip" select="$skip"/>
			<xsl:with-param name="onlink" select="$onlink"/>
		</xsl:apply-templates>
		<xsl:if test="(($skip + @COUNT) &lt; @TOTALTHREADS) and ($skip &lt; $tp_upperrange)">
			<xsl:apply-templates select="." mode="c_threadblockdisplay">
				<xsl:with-param name="skip" select="$skip + @COUNT"/>
				<xsl:with-param name="onlink" select="$onlink"/>
			</xsl:apply-templates>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="FORUMTHREADS" mode="displayblocktp">
	Author:		Tom Whitehouse
	Context:      /H2G2/FORUMTHREADS
	Purpose:	 Creates the individual links in the postblock area within the range set above
	-->
	<xsl:template match="FORUMTHREADS" mode="displayblocktp">
		<xsl:param name="skip"/>
		<xsl:param name="onlink"/>
		<xsl:param name="PostRange" select="concat(($skip + 1), ' - ', ($skip + @COUNT))"/>
		<xsl:choose>
			<xsl:when test="@SKIPTO = $skip">
				<xsl:apply-templates select="." mode="on_threadblockdisplay">
					<xsl:with-param name="url">
						<xsl:choose>
							<xsl:when test="$onlink = 'no'">
								<xsl:call-template name="t_threadontabcontent">
									<xsl:with-param name="range" select="$PostRange"/>
									<xsl:with-param name="pagenumber" select="substring-after($PostRange, ' - ') div @COUNT"/>
								</xsl:call-template>
							</xsl:when>
							<xsl:otherwise>
								<a href="{$root}F{@FORUMID}?skip={$skip}&amp;show={@COUNT}" xsl:use-attribute-sets="mFORUMTHREADS_on_threadblockdisplay">
									<xsl:call-template name="t_threadontabcontent">
										<xsl:with-param name="range" select="$PostRange"/>
										<xsl:with-param name="pagenumber" select="substring-after($PostRange, ' - ') div @COUNT"/>
									</xsl:call-template>
								</a>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:with-param>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="." mode="off_threadblockdisplay">
					<xsl:with-param name="url">
						<a href="{$root}F{@FORUMID}?skip={$skip}&amp;show={@COUNT}" xsl:use-attribute-sets="mFORUMTHREADS_off_threadblockdisplay">
							<xsl:call-template name="t_threadofftabcontent">
								<xsl:with-param name="range" select="$PostRange"/>
								<xsl:with-param name="pagenumber" select="substring-after($PostRange, ' - ') div @COUNT"/>
							</xsl:call-template>
						</a>
					</xsl:with-param>
				</xsl:apply-templates>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- tpsplit is the numbers of tabs that appear on one page-->
	<xsl:variable name="tpsplit" select="10"/>
	<!--tp_lowerrange is the skip value of the first post of the first page of the series of tabs on the page-->
	<xsl:param name="tp_lowerrange">
		<xsl:choose>
			<xsl:when test="/H2G2/FORUMTHREADS">
				<xsl:value-of select="floor(/H2G2/FORUMTHREADS/@SKIPTO div ($tpsplit * /H2G2/FORUMTHREADS/@COUNT)) * ($tpsplit * /H2G2/FORUMTHREADS/@COUNT)"/>
			</xsl:when>
			<xsl:when test="/H2G2/FORUMTHREADPOSTS">
				<xsl:value-of select="floor(/H2G2/FORUMTHREADPOSTS/@SKIPTO div ($tpsplit * /H2G2/FORUMTHREADPOSTS/@COUNT)) * ($tpsplit * /H2G2/FORUMTHREADPOSTS/@COUNT)"/>
			</xsl:when>
		</xsl:choose>
	</xsl:param>
	<!--tp_upperrange is the skip value of the first post of the last page of the series of tabs on the page-->
	<xsl:param name="tp_upperrange">
		<xsl:choose>
			<xsl:when test="/H2G2/FORUMTHREADS">
				<xsl:value-of select="$tp_lowerrange + (($tpsplit - 1) * /H2G2/FORUMTHREADS/@COUNT)"/>
			</xsl:when>
			<xsl:when test="/H2G2/FORUMTHREADPOSTS">
				<xsl:value-of select="$tp_lowerrange + (($tpsplit - 1) * /H2G2/FORUMTHREADPOSTS/@COUNT)"/>
			</xsl:when>
		</xsl:choose>
	</xsl:param>
	<!-- 
	<xsl:template name="t_offtabcontent">
	Use: Controls the content of the link for other pages in the currently visible range
	-->
	<xsl:template name="t_threadofftabcontent">
		<xsl:param name="range"/>
		<xsl:param name="pagenumber"/>
		<xsl:value-of select="$pagenumber"/>
	</xsl:template>
	<!-- 
	<xsl:template name="t_ontabcontent">
	Use: Controls the content of the link for the currently visible page
	-->
	<xsl:template name="t_threadontabcontent">
		<xsl:param name="range"/>
		<xsl:param name="pagenumber"/>
		<xsl:value-of select="$pagenumber"/>
	</xsl:template>
	<xsl:variable name="m_threadpostblockprev">prev</xsl:variable>
	<xsl:variable name="m_threadpostblocknext">next</xsl:variable>
	<xsl:attribute-set name="mFORUMTHREADS_on_threadblockdisplay"/>
	<xsl:attribute-set name="mFORUMTHREADS_off_threadblockdisplay"/>
	<xsl:attribute-set name="mFORUMTHREADS_r_threadblockdisplayprev"/>
	<xsl:attribute-set name="mFORUMTHREADS_r_threadblockdisplaynext"/>
	<xsl:attribute-set name="mFORUMTHREADPOSTS_on_threadblockdisplay"/>
	<xsl:attribute-set name="mFORUMTHREADPOSTS_off_threadblockdisplay"/>
	<xsl:attribute-set name="mFORUMTHREADPOSTS_r_threadblockdisplayprev"/>
	<xsl:attribute-set name="mFORUMTHREADPOSTS_r_threadblockdisplaynext"/>
</xsl:stylesheet>
