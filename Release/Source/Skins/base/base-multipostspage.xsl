<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	
	<!--xsl:variable name="num_currentpage" select="(/H2G2/FORUMTHREADPOSTS/@SKIPTO + /H2G2/FORUMTHREADPOSTS/@COUNT) div  /H2G2/FORUMTHREADPOSTS/@COUNT"/>
	<xsl:variable name="num_totalpages" select="ceiling(/H2G2/FORUMTHREADPOSTS/@TOTALPOSTCOUNT div /H2G2/FORUMTHREADPOSTS/@COUNT)"/-->
	<xsl:key name="onlineusers" match="ONLINEUSER" use="USER/USERID"/>
	<!--
	<xsl:template name="MULTIPOSTS_HEADER">
	Author:		Andy Harris
	Context:      /H2G2
	Purpose:	 Creates the title for the page which sits in the html header
	-->
	<xsl:template name="MULTIPOSTS_HEADER">
		<xsl:apply-templates mode="header" select=".">
			<xsl:with-param name="title">
				<xsl:value-of select="$m_pagetitlestart"/>A Forum Conversation</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>
	<!--
	<xsl:template name="MULTIPOSTS_SUBJECT">
	Author:		Tom Whitehouse
	Context:      /H2G2
	Purpose:	 Creates the text for the subject
	-->
	<xsl:template name="MULTIPOSTS_SUBJECT">
		<xsl:choose>
			<xsl:when test="FORUMSOURCE/@TYPE='journal'">
				<xsl:value-of select="$m_thisjournal"/>
				<xsl:apply-templates select="FORUMSOURCE" mode="journal_forumsource"/>
			</xsl:when>
			<xsl:when test="FORUMSOURCE/@TYPE='reviewforum'">
				<xsl:value-of select="$m_thisconvforentry"/>
				<xsl:apply-templates select="FORUMSOURCE" mode="reviewforum_forumsource"/>
			</xsl:when>
			<xsl:when test="FORUMSOURCE/@TYPE='userpage'">
				<xsl:value-of select="$m_thismessagecentre"/>
				<xsl:apply-templates select="FORUMSOURCE" mode="userpage_forumsource"/>
			</xsl:when>
			<xsl:when test="FORUMSOURCE/@TYPE='privateuser'">
				<xsl:copy-of select="$m_theseprivatemessages"/>
				<xsl:apply-templates select="FORUMSOURCE" mode="privateuser_forumsource"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$m_thisconvforentry"/>
				<xsl:apply-templates select="FORUMSOURCE" mode="article_forumsource"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="FORUMTHREADPOSTS" mode="c_multiposts">
	Author:		Tom Whitehouse
	Context:      /H2G2/FORUMTHREADPOSTS
	Purpose:	 Calls the container for the FORUMTHREADPOSTS 
	-->
	<xsl:template match="FORUMTHREADPOSTS" mode="c_multiposts">
		<xsl:if test="not(CANREAD=0)">
			<xsl:apply-templates select="." mode="r_multiposts"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="POST" mode="c_multiposts">
	Author:		Tom Whitehouse
	Context:      /H2G2/FORUMTHREADPOSTS/POST
	Purpose:	 Calls the container for the POST 
	-->
	<xsl:template match="POST" mode="c_multiposts">
		<xsl:apply-templates select="." mode="r_multiposts"/>
	</xsl:template>
	<!--
	<xsl:template match="FORUMTHREADPOSTS" mode="c_club">
	Author:		Tom Whitehouse
	Context:      /H2G2/FORUMTHREADPOSTS
	Purpose:	 Checks that the viewer is permitted to view the club thread and  calls the FORUMTHREADPOSTS container
	-->
	<xsl:template match="FORUMTHREADPOSTS" mode="c_club">
		<xsl:if test="@CANREAD=1">
			<xsl:apply-templates select="." mode="r_club"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="POST" mode="c_club">
	Author:		Tom Whitehouse
	Context:      /H2G2/FORUMTHREADPOSTS/POST
	Purpose:	 Calls the POST container
	-->
	<xsl:template match="POST" mode="c_club">
		<xsl:apply-templates select="." mode="r_club"/>
	</xsl:template>
	<!--
	<xsl:template match="@POSTID" mode="t_createanchor">
	Author:		Tom Whitehouse
	Context:      /H2G2/FORUMTHREADPOSTS/POST/@POSTID
	Purpose:	 Creates an archor to a particlular POST
	-->
	<xsl:template match="@POSTID" mode="t_createanchor">
		<a name="p{.}"/>
	</xsl:template>
	<!--
	<xsl:template match="@PREVINDEX" mode="c_multiposts">
	Author:		Tom Whitehouse
	Context:      /H2G2/FORUMTHREADPOSTS/POST/@PREVINDEX
	Purpose:	 Calls the container for the link to the previous POST
	-->
	<xsl:template match="@PREVINDEX" mode="c_multiposts">
		<xsl:apply-templates select="." mode="r_multiposts"/>
	</xsl:template>
	<!--
	<xsl:template match="@PREVINDEX" mode="c_clubpost">
	Author:		Tom Whitehouse
	Context:      /H2G2/FORUMTHREADPOSTS/POST/@PREVINDEX
	Purpose:	 Calls the container for the link to the previous POST
	-->
	<xsl:template match="@PREVINDEX" mode="c_clubpost">
		<xsl:apply-templates select="." mode="r_clubpost"/>
	</xsl:template>
	<!--
	<xsl:template match="@PREVINDEX" mode="r_clubpost">
	Author:		Tom Whitehouse
	Context:      /H2G2/FORUMTHREADPOSTS/POST/@PREVINDEX
	Purpose:	 Creates the right type of link to the previous POST 
	-->
	<xsl:template match="@PREVINDEX" mode="r_clubpost">
		<xsl:param name="ptype"/>
		<xsl:param name="embodiment" select="$m_prev"/>
		<xsl:choose>
			<xsl:when test="../../POST/@POSTID = .">
				<a href="#p{.}" xsl:use-attribute-sets="maPREVINDEX_r_clubpost">
					<xsl:copy-of select="$embodiment"/>
				</a>
			</xsl:when>
			<xsl:otherwise>
				<a xsl:use-attribute-sets="maPREVINDEX_r_clubpost">
					<xsl:if test="$ptype='frame'">
						<xsl:attribute name="target">_top</xsl:attribute>
					</xsl:if>
					<xsl:attribute name="href"><xsl:value-of select="$root"/><xsl:choose><xsl:when test="$ptype='frame'">F</xsl:when><xsl:otherwise>F</xsl:otherwise></xsl:choose><xsl:value-of select="../../@FORUMID"/>?thread=<xsl:value-of select="../../@THREADID"/>&amp;post=<xsl:value-of select="../@PREVINDEX"/>#p<xsl:value-of select="../@PREVINDEX"/></xsl:attribute>
					<xsl:copy-of select="$embodiment"/>
				</a>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="@PREVINDEX" mode="r_multiposts">
	Author:		Tom Whitehouse
	Context:      /H2G2/FORUMTHREADPOSTS/POST/@PREVINDEX
	Purpose:	 Creates the right type of link to the previous POST 
	-->
	<xsl:template match="@PREVINDEX" mode="r_multiposts">
		<xsl:param name="ptype"/>
		<xsl:param name="embodiment" select="$m_prev"/>
		<xsl:choose>
			<xsl:when test="../../POST/@POSTID = .">
				<a href="#p{.}" xsl:use-attribute-sets="maPREVINDEX_r_multiposts">
					<xsl:copy-of select="$embodiment"/>
				</a>
			</xsl:when>
			<xsl:otherwise>
				<a xsl:use-attribute-sets="maPREVINDEX_r_multiposts">
					<xsl:if test="$ptype='frame'">
						<xsl:attribute name="target">_top</xsl:attribute>
					</xsl:if>
					<xsl:attribute name="href"><xsl:value-of select="$root"/><xsl:choose><xsl:when test="$ptype='frame'">F</xsl:when><xsl:otherwise>F</xsl:otherwise></xsl:choose><xsl:value-of select="../../@FORUMID"/>?thread=<xsl:value-of select="../../@THREADID"/>&amp;post=<xsl:value-of select="../@PREVINDEX"/>#p<xsl:value-of select="../@PREVINDEX"/></xsl:attribute>
					<xsl:copy-of select="$embodiment"/>
				</a>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="@NEXTINDEX" mode="c_multiposts">
	Author:		Tom Whitehouse
	Context:      /H2G2/FORUMTHREADPOSTS/POST/@NEXTINDEX
	Purpose:	 Calls the container for the link to the next POST
	-->
	<xsl:template match="@NEXTINDEX" mode="c_multiposts">
		<xsl:apply-templates select="." mode="r_multiposts"/>
	</xsl:template>
	<!--
	<xsl:template match="@NEXTINDEX" mode="c_multiposts">
	Author:		Tom Whitehouse
	Context:      /H2G2/FORUMTHREADPOSTS/POST/@NEXTINDEX
	Purpose:	 Calls the container for the link to the next POST
	-->
	<xsl:template match="@NEXTINDEX" mode="c_clubpost">
		<xsl:apply-templates select="." mode="r_clubpost"/>
	</xsl:template>
	<!--
	<xsl:template match="@NEXTINDEX" mode="r_multiposts">
	Author:		Tom Whitehouse
	Context:      /H2G2/FORUMTHREADPOSTS/POST/@NEXTINDEX
	Purpose:	 Creates the right type of link to the next POST 
	-->
	<xsl:template match="@NEXTINDEX" mode="r_multiposts">
		<xsl:param name="ptype"/>
		<xsl:param name="embodiment" select="$m_next"/>
		<xsl:choose>
			<xsl:when test="../../POST/@POSTID = .">
				<a href="#p{.}" xsl:use-attribute-sets="maNEXTINDEX_r_multiposts">
					<xsl:copy-of select="$embodiment"/>
				</a>
			</xsl:when>
			<xsl:otherwise>
				<a xsl:use-attribute-sets="maNEXTINDEX_r_multiposts">
					<xsl:if test="$ptype='frame'">
						<xsl:attribute name="target">_top</xsl:attribute>
					</xsl:if>
					<xsl:attribute name="href"><xsl:value-of select="$root"/>F<xsl:value-of select="../../@FORUMID"/>?thread=<xsl:value-of select="../../@THREADID"/>&amp;post=<xsl:value-of select="../@NEXTINDEX"/>#p<xsl:value-of select="../@NEXTINDEX"/></xsl:attribute>
					<xsl:copy-of select="$embodiment"/>
				</a>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="DATE" mode="t_postdatemp">
	Author:		Tom Whitehouse
	Context:      /H2G2/FORUMTHREADPOSTS/POST/DATEPOSTED/DATE
	Purpose:	 Creates the DATEPOSTED text 
	-->
	<xsl:template match="DATE" mode="t_postdatemp">
		<xsl:apply-templates select="."/>
	</xsl:template>
	<!--
	<xsl:template match="POST" mode="t_postsubjectmp">
	Author:		Tom Whitehouse
	Context:      /H2G2/FORUMTHREADPOSTS/POST
	Purpose:	 Creates the SUBJECT text 
	-->
	<xsl:template match="POST" mode="t_postsubjectmp">
		<xsl:choose>
			<xsl:when test="@HIDDEN = 1">
				<xsl:value-of select="$m_postsubjectremoved"/>
			</xsl:when>
			<xsl:when test="@HIDDEN = 2">
				<xsl:value-of select="$m_awaitingmoderationsubject"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="SUBJECT"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="POST" mode="t_postbodymp">
	Author:		Tom Whitehouse
	Context:      /H2G2/FORUMTHREADPOSTS/POST
	Purpose:	 Creates the body of the POST text 
	-->
	<xsl:template match="POST" mode="t_postbodymp">
		<xsl:choose>
			<xsl:when test="@HIDDEN = 1">
				<xsl:call-template name="m_postremoved"/>
			</xsl:when>
			<xsl:when test="@HIDDEN = 2">
				<xsl:call-template name="m_postawaitingmoderation"/>
			</xsl:when>
			<xsl:when test="@HIDDEN = 3">
				<xsl:call-template name="m_postawaitingpremoderation"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="TEXT/node()"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="USERNAME" mode="c_clubpost">
	Author:		Tom Whitehouse
	Context:      /H2G2/FORUMTHREADPOSTS/POST/USER/USERNAME
	Purpose:	 Calls the container for the USERNAME if required 
	-->
	<xsl:template match="USERNAME" mode="c_clubpost">
		<xsl:if test="not(parent::USER/parent::POST/@HIDDEN)">
			<xsl:apply-templates select="." mode="r_clubpost"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="USERNAME" mode="c_multiposts">
	Author:		Tom Whitehouse
	Context:      /H2G2/FORUMTHREADPOSTS/POST/USER/USERNAME
	Purpose:	 Calls the container for the USERNAME if required 
	-->
	<xsl:template match="USERNAME" mode="c_multiposts">
		<xsl:if test="not(parent::USER/parent::POST/@HIDDEN &gt; 0)">
			<xsl:apply-templates select="." mode="r_multiposts"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="USERNAME" mode="r_multiposts">
	Author:		Tom Whitehouse
	Context:      /H2G2/FORUMTHREADPOSTS/POST/USER/USERNAME
	Purpose:	 Creates the USERNAME link 
	-->
	<xsl:template match="USERNAME" mode="r_multiposts">
		<a target="_top" href="{$root}U{../USERID}" xsl:use-attribute-sets="mUSERNAME_r_multiposts">
			<xsl:apply-templates select="."/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="@INREPLYTO" mode="c_clubpost">
	Author:		Tom Whitehouse
	Context:      /H2G2/FORUMTHREADPOSTS/POST/@INREPLYTO
	Purpose:	 Calls the container for the INREPLYTO link 
	-->
	<xsl:template match="@INREPLYTO" mode="c_clubpost">
		<xsl:apply-templates select="." mode="r_clubpost"/>
	</xsl:template>
	<!--
	<xsl:template match="POST" mode="t_postnumber">
	Author:		Tom Whitehouse
	Context:      /H2G2/FORUMTHREADPOSTS/POST
	Purpose:	 Creates the POST number text 
	-->
	<xsl:template match="POST" mode="t_postnumber">
		<xsl:value-of select="count(preceding-sibling::POST) + 1 + number(../@SKIPTO)"/>
	</xsl:template>
	<!--
	<xsl:template match="POST" mode="c_gadgetclubpost">
	Author:		Tom Whitehouse
	Context:      /H2G2/FORUMTHREADPOSTS/POST
	Purpose:	 Calls the container for the multiposts page gadget
	-->
	<xsl:template match="POST" mode="c_gadgetclubpost">
		<xsl:if test="$showtreegadget=1">
			<xsl:apply-templates select="." mode="r_gadgetclubpost"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="@POSTID" mode="c_replytopost">
	Author:		Tom Whitehouse
	Context:      /H2G2/FORUMTHREADPOSTS/POST/@POSTID
	Purpose:	 Calls the container for the 'reply to posts' link
	-->
	<xsl:template match="@POSTID" mode="c_replytopost">
		<xsl:if test="not(../../@CANWRITE = 0)">
			<xsl:apply-templates select="." mode="r_replytopost"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="@POSTID" mode="r_replytopost">
	Author:		Tom Whitehouse
	Context:      /H2G2/FORUMTHREADPOSTS/POST/@POSTID
	Purpose:	 Creates the 'reply to posts' link
	-->
	<xsl:template match="@POSTID" mode="r_replytopost">
		<xsl:param name="attributes"/>
		<xsl:param name="embodiment" select="$m_replytothispost"/>
		<a target="_top" xsl:use-attribute-sets="maPOSTID_r_replytopost">
			<xsl:attribute name="href"><xsl:apply-templates select=".." mode="sso_post_signin"/></xsl:attribute>
			<xsl:call-template name="ApplyAttributes">
				<xsl:with-param name="attributes" select="$attributes"/>
			</xsl:call-template>
			<xsl:copy-of select="$embodiment"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="USER" mode="c_onlineflag">
	Author:		Tom Whitehouse
	Context:      /H2G2/FORUMTHREADPOSTS/POST/USER
	Purpose:	 Calls the container for the 'user is online' flag
	-->
	<xsl:template match="USER" mode="c_onlineflag">
		<xsl:if test="key('onlineusers', USERID)">
			<xsl:apply-templates select="." mode="r_onlineflag"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="@POSTID" mode="c_linktomoderate">
	Author:		Tom Whitehouse
	Context:      /H2G2/FORUMTHREADPOSTS/POST/@POSTID
	Purpose:	 Calls the container for the 'moderate this post' link
	-->
	<xsl:template match="@POSTID" mode="c_linktomoderate">
		<xsl:if test="$test_EditorOrModerator">
			<xsl:apply-templates select="." mode="r_linktomoderate"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="@POSTID" mode="r_linktomoderate">
	Author:		Tom Whitehouse
	Context:      /H2G2/FORUMTHREADPOSTS/POST/@POSTID
	Purpose:	 Creates the 'moderate this post' link
	-->
	<xsl:template match="@POSTID" mode="r_linktomoderate">
		<a target="_top" href="{$root}ModerationHistory?PostID={.}" xsl:use-attribute-sets="maPOSTID_moderation">
			<xsl:value-of select="$m_moderationhistory"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="@POSTID" mode="c_failmessagelink">
	Author:		Andy Harris
	Context:      /H2G2/FORUMTHREADPOSTS/POST/@POSTID
	Purpose:	 Calls the container for the 'Fail this message' link
	-->
	<xsl:template match="@POSTID" mode="c_failmessagelink">
		<xsl:if test="$test_EditorOrModerator">
			<xsl:apply-templates select="." mode="r_failmessagelink"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="@POSTID" mode="r_failmessagelink">
	Author:		Andy Harris
	Context:      /H2G2/FORUMTHREADPOSTS/POST/@POSTID
	Purpose:	 Creates the 'Fail this message' link
	-->
	<xsl:template match="@POSTID" mode="r_failmessagelink">
		<a target="_top" href="{$root}FailMessage?forumid={../../@FORUMID}&amp;threadid={../../@THREADID}&amp;postid={.}&amp;_msxml={$failmessageparameters}" xsl:use-attribute-sets="maPOSTID_r_failmessagelink">
			<xsl:value-of select="$m_failmessage"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="@POSTID" mode="c_postmod">
	Author:		Tom Whitehouse
	Context:      /H2G2/FORUMTHREADPOSTS/POST/@POSTID
	Purpose:	 Calls the container for the moderation history link 
	-->
	<xsl:template match="@POSTID" mode="c_postmod">
		<xsl:if test="$test_EditorOrModerator">
			<xsl:apply-templates select="." mode="r_postmod"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="@POSTID" mode="r_postmod">
	Author:		Tom Whitehouse
	Context:      /H2G2/FORUMTHREADPOSTS/POST/@POSTID
	Purpose:	 Creates the moderation history link 
	-->
	<xsl:template match="@POSTID" mode="r_postmod">
		<a target="_top" href="{$root}ModerationHistory?PostID={.}" xsl:use-attribute-sets="maPOSTID_moderation">
			<xsl:value-of select="$m_moderationhistory"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="@HIDDEN" mode="c_clubpostcomplain">
	Author:		Tom Whitehouse
	Context:      /H2G2/FORUMTHREADPOSTS/POST/@HIDDEN
	Purpose:	 Calls the container for the post complaint 
	-->
	<xsl:template match="@HIDDEN" mode="c_clubpostcomplain">
		<xsl:if test=".=0">
			<xsl:apply-templates select="." mode="r_clubpostcomplain"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="POST" mode="r_gadgetclubpost">
	Author:		Tom Whitehouse
	Context:      /H2G2/FORUMTHREADPOSTS/POST
	Purpose:	 Calls the gadget template 
	-->
	<xsl:template match="POST" mode="r_gadgetclubpost">
		<xsl:call-template name="showtreegadget">
			<xsl:with-param name="ptype" select="$ptype"/>
		</xsl:call-template>
	</xsl:template>
	<!--
	<xsl:template match="@POSTID" mode="r_clubpostmod">
	Author:		Tom Whitehouse
	Context:      /H2G2/FORUMTHREADPOSTS/POST/@POSTID
	Purpose:	 Creates the moderation history link 
	-->
	<xsl:template match="@POSTID" mode="r_clubpostmod">
		<a target="_top" href="{$root}ModerationHistory?PostID={.}" xsl:use-attribute-sets="maPOSTID_moderation">
			<xsl:value-of select="$m_moderationhistory"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="FORUMTHREADPOSTS" mode="c_subcribemultiposts">
	Author:		Tom Whitehouse
	Context:      /H2G2/FORUMTHREADPOSTS
	Purpose:	 Calls the container for the subscribe to this conversation link 
	-->
	<xsl:template match="FORUMTHREADPOSTS" mode="c_subcribemultiposts">
		<xsl:if test="$registered=1">
			<xsl:apply-templates select="." mode="r_subcribemultiposts"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="FORUMTHREADPOSTS" mode="r_subcribemultiposts">
	Author:		Tom Whitehouse
	Context:      /H2G2/FORUMTHREADPOSTS
	Purpose:	 Creates the subscribe to this conversation link 
	-->
	<xsl:template match="FORUMTHREADPOSTS" mode="r_subcribemultiposts">
		<xsl:choose>
			<xsl:when test="../SUBSCRIBE-STATE[@THREAD='1']">
				<a target="_top" href="{$root}FSB{@FORUMID}?thread={@THREADID}&amp;skip={@SKIPTO}&amp;show={@COUNT}&amp;cmd=unsubscribethread&amp;page=normal&amp;desc={$alt_subreturntoconv}&amp;return=F{@FORUMID}%3Fthread={@THREADID}%26amp;skip={@SKIPTO}%26amp;show={@COUNT}" xsl:use-attribute-sets="mFORUMTHREADPOSTS_r_subcribemultiposts">
					<xsl:copy-of select="$m_clickunsubscribe"/>
				</a>
			</xsl:when>
			<xsl:otherwise>
				<a target="_top" href="{$root}FSB{@FORUMID}?thread={@THREADID}&amp;skip={@SKIPTO}&amp;show={@COUNT}&amp;cmd=subscribethread&amp;page=normal&amp;desc={$alt_subreturntoconv}&amp;return=F{@FORUMID}%3Fthread={@THREADID}%26amp;skip={@SKIPTO}%26amp;show={@COUNT}" xsl:use-attribute-sets="mFORUMTHREADPOSTS_r_subcribemultiposts">
					<xsl:copy-of select="$m_clicksubscribe"/>
				</a>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="FORUMTHREADPOSTS" mode="postblocks">
	Author:		Tom Whitehouse
	Context:      /H2G2/FORUMTHREADPOSTS
	Purpose:	 Creates the postblocks area 
	-->
	<xsl:template match="FORUMTHREADPOSTS" mode="postblocks">
		<xsl:param name="skip" select="0"/>
		<xsl:apply-templates select="." mode="displayblock">
			<xsl:with-param name="skip" select="$skip"/>
		</xsl:apply-templates>
		<xsl:if test="($skip + @COUNT) &lt; @TOTALPOSTCOUNT">
			<xsl:apply-templates select="." mode="postblocks">
				<xsl:with-param name="skip" select="$skip + @COUNT"/>
			</xsl:apply-templates>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="FORUMTHREADPOSTS" mode="displayblock">
	Author:		Tom Whitehouse
	Context:      /H2G2/FORUMTHREADPOSTS
	Purpose:	 Creates each of the links in the postblocks area 
	-->
	<xsl:template match="FORUMTHREADPOSTS" mode="displayblock">
		<xsl:param name="skip"/>
		<xsl:param name="PostRange" select="concat(($skip + 1), ' - ', ($skip + @COUNT))"/>
		<xsl:param name="postblockon">
			<xsl:apply-templates select="." mode="on_postblock">
				<!-- use apply-imports in XSLT 2.0 as it supports parameters -->
				<!--xsl:with-param name="range" select="concat($alt_nowshowing, ' ', $PostRange)"/-->
				<xsl:with-param name="range" select="$PostRange"/>
			</xsl:apply-templates>
		</xsl:param>
		<xsl:param name="postblockoff">
			<xsl:apply-templates select="." mode="off_postblock">
				<!--xsl:with-param name="range" select="concat($alt_show, ' ', $PostRange)"/-->
				<xsl:with-param name="range" select="$PostRange"/>
			</xsl:apply-templates>
		</xsl:param>
		<a href="{$root}F{@FORUMID}?thread={@THREADID}&amp;skip={$skip}&amp;show={@COUNT}">
			<xsl:choose>
				<xsl:when test="@SKIPTO = $skip">
					<xsl:copy-of select="$postblockon"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:copy-of select="$postblockoff"/>
				</xsl:otherwise>
			</xsl:choose>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="THREAD" mode="c_previous">
	Author:		Tom Whitehouse
	Context:      /H2G2/FORUMTHREADS/THREAD
	Purpose:	 Calls the container for the previous THREAD link 
	-->
	<xsl:template match="THREAD" mode="c_previous">
		<xsl:apply-templates select="." mode="r_previous"/>
	</xsl:template>
	<!--
	<xsl:template match="THREAD" mode="c_next">
	Author:		Tom Whitehouse
	Context:      /H2G2/FORUMTHREADS/THREAD
	Purpose:	 Calls the container for the next THREAD link 
	-->
	<xsl:template match="THREAD" mode="c_next">
		<xsl:apply-templates select="." mode="r_next"/>
	</xsl:template>
	<!--
	<xsl:template match="THREAD" mode="r_next">
	Author:		Tom Whitehouse
	Context:      /H2G2/FORUMTHREADS/THREAD
	Purpose:	 Creates the next THREAD link 
	-->
	<xsl:template match="THREAD" mode="r_next">
		<a href="{$root}F{@FORUMID}?thread={@THREADID}" xsl:use-attribute-sets="mTHREAD_NextThread">
			<xsl:value-of select="SUBJECT"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="THREAD" mode="r_previous">
	Author:		Tom Whitehouse
	Context:      /H2G2/FORUMTHREADS/THREAD
	Purpose:	 Creates the previous THREAD link 
	-->
	<xsl:template match="THREAD" mode="r_previous">
		<a href="{$root}F{@FORUMID}?thread={@THREADID}" xsl:use-attribute-sets="mTHREAD_PreviousThread">
			<xsl:value-of select="SUBJECT"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="FORUMTHREADPOSTS" mode="c_postblocks">
	Author:		Tom Whitehouse
	Context:      /H2G2/FORUMTHREADPOSTS
	Purpose:	 Calls the container for the postblocks area 
	-->
	<xsl:template match="FORUMTHREADPOSTS" mode="c_postblocks">
		<xsl:apply-templates select="." mode="r_postblocks"/>
	</xsl:template>
	<!--
	<xsl:template match="FORUMTHREADPOSTS" mode="c_postblock">
	Author:		Tom Whitehouse
	Context:      /H2G2/FORUMTHREADPOSTS
	Purpose:	 Creates the individual blocks in the postblock area 
	-->
	<xsl:template match="FORUMTHREADPOSTS" mode="c_postblock">
		<xsl:param name="skip" select="0"/>
		<xsl:apply-templates select="." mode="displayblockmp">
			<xsl:with-param name="skip" select="$skip"/>
		</xsl:apply-templates>
		<xsl:if test="($skip + @COUNT) &lt; @TOTALPOSTCOUNT">
			<xsl:apply-templates select="." mode="c_postblock">
				<xsl:with-param name="skip" select="$skip + @COUNT"/>
			</xsl:apply-templates>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="FORUMTHREADPOSTS" mode="displayblockmp">
	Author:		Tom Whitehouse
	Context:      /H2G2/FORUMTHREADPOSTS
	Purpose:	 Creates the individual links in the postblock area 
	-->
	<xsl:template match="FORUMTHREADPOSTS" mode="displayblockmp">
		<xsl:param name="skip"/>
		<xsl:param name="PostRange" select="concat(($skip + 1), ' - ', ($skip + @COUNT))"/>
		<xsl:param name="postblockon">
			<xsl:apply-templates select="." mode="on_postblock">
				<xsl:with-param name="range" select="$PostRange"/>
			</xsl:apply-templates>
		</xsl:param>
		<xsl:param name="postblockoff">
			<xsl:apply-templates select="." mode="off_postblock">
				<xsl:with-param name="range" select="$PostRange"/>
			</xsl:apply-templates>
		</xsl:param>
		<a href="{$root}F{@FORUMID}?thread={@THREADID}&amp;skip={$skip}&amp;show={@COUNT}" xsl:use-attribute-sets="mFORUMTHREADPOSTS_c_postblock">
			<xsl:choose>
				<xsl:when test="@SKIPTO = $skip">
					<xsl:copy-of select="$postblockon"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:copy-of select="$postblockoff"/>
				</xsl:otherwise>
			</xsl:choose>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="@SKIPTO" mode="c_navbuttons">
	Author:		Tom Whitehouse
	Context:      /H2G2/FORUMTHREADPOSTS/@SKIPTO
	Purpose:	 Calls the container for the navigation buttons 
	-->
	<xsl:template match="@SKIPTO" mode="c_navbuttons">
		<xsl:apply-templates select="." mode="r_navbuttons"/>
	</xsl:template>
	<!--
	<xsl:template match="@SKIPTO" mode="text_gotobeginning">
	Author:		Tom Whitehouse
	Context:      /H2G2/FORUMTHREADPOSTS/@SKIPTO
	Purpose:	 Creates the text for 'showing oldest conversation' 
	-->
	<xsl:template match="@SKIPTO" mode="text_gotobeginning">
		<xsl:copy-of select="$alt_showingoldest"/>
	</xsl:template>
	<!--
	<xsl:template match="@SKIPTO" mode="text_gotoprevious">
	Author:		Tom Whitehouse
	Context:      /H2G2/FORUMTHREADPOSTS/@SKIPTO
	Purpose:	 Creates the text for 'no older conversations' 
	-->
	<xsl:template match="@SKIPTO" mode="text_gotoprevious">
		<xsl:copy-of select="$m_noolderconv"/>
	</xsl:template>
	<!--
	<xsl:template match="@SKIPTO" mode="text_gotonext">
	Author:		Tom Whitehouse
	Context:      /H2G2/FORUMTHREADPOSTS/@SKIPTO
	Purpose:	 Creates the text for 'no newer conversations' 
	-->
	<xsl:template match="@SKIPTO" mode="text_gotonext">
		<xsl:copy-of select="$alt_nonewconvs"/>
	</xsl:template>
	<!--
	<xsl:template match="@SKIPTO" mode="text_gotolatest">
	Author:		Tom Whitehouse
	Context:      /H2G2/FORUMTHREADPOSTS/@SKIPTO
	Purpose:	 Creates the text for 'showing newest conversation' 
	-->
	<xsl:template match="@SKIPTO" mode="text_gotolatest">
		<xsl:copy-of select="$alt_nonewerpost"/>
	</xsl:template>
	<!--
	<xsl:template match="@SKIPTO" mode="c_gotobeginning">
	Author:		Tom Whitehouse
	Context:      /H2G2/FORUMTHREADPOSTS/@SKIPTO
	Purpose:	 Chooses correct link or text for 'go to beginning' button
	-->
	<xsl:template match="@SKIPTO" mode="c_gotobeginning">
		<xsl:choose>
			<xsl:when test=". != 0">
				<xsl:apply-templates select="." mode="link_gotobeginning"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="." mode="text_gotobeginning"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="@SKIPTO" mode="link_gotobeginning">
	Author:		Tom Whitehouse
	Context:      /H2G2/FORUMTHREADPOSTS/@SKIPTO
	Purpose:	 Creates 'go to beginning' link
	-->
	<xsl:template match="@SKIPTO" mode="link_gotobeginning">
		<a href="{$root}F{../@FORUMID}?thread={../@THREADID}&amp;skip=0&amp;show={../@COUNT}" xsl:use-attribute-sets="maSKIPTO_link_gotobeginning">
			<xsl:copy-of select="$alt_showoldestconv"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="@SKIPTO" mode="c_gotoprevious">
	Author:		Tom Whitehouse
	Context:      /H2G2/FORUMTHREADPOSTS/@SKIPTO
	Purpose:	 Chooses correct link or text for 'previous' button
	-->
	<xsl:template match="@SKIPTO" mode="c_gotoprevious">
		<xsl:choose>
			<xsl:when test=". != 0">
				<xsl:apply-templates select="." mode="link_gotoprevious"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="." mode="text_gotoprevious"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="@SKIPTO" mode="link_gotoprevious">
	Author:		Tom Whitehouse
	Context:      /H2G2/FORUMTHREADPOSTS/@SKIPTO
	Purpose:	 Creates 'previous' link
	-->
	<xsl:template match="@SKIPTO" mode="link_gotoprevious">
		<a href="{$root}F{../@FORUMID}?thread={../@THREADID}&amp;skip={(.) - (../@COUNT)}&amp;show={../@COUNT}" xsl:use-attribute-sets="maSKIPTO_link_gotoprevious">
			<xsl:value-of select="concat($alt_showpostings, (.) - (../@COUNT) + 1, $alt_to, .)"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="@SKIPTO" mode="c_gotonext">
	Author:		Tom Whitehouse
	Context:      /H2G2/FORUMTHREADPOSTS/@SKIPTO
	Purpose:	 Calls the correct 'next' link/text
	-->
	<xsl:template match="@SKIPTO" mode="c_gotonext">
		<xsl:choose>
			<xsl:when test="../@MORE = 1">
				<xsl:apply-templates select="." mode="link_gotonext"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="." mode="text_gotonext"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="@SKIPTO" mode="link_gotonext">
	Author:		Tom Whitehouse
	Context:      /H2G2/FORUMTHREADPOSTS/@SKIPTO
	Purpose:	 Creates the 'next' link
	-->
	<xsl:template match="@SKIPTO" mode="link_gotonext">
		<a href="{$root}F{../@FORUMID}?thread={../@THREADID}&amp;skip={(.) + (../@COUNT)}&amp;show={../@COUNT}" xsl:use-attribute-sets="maSKIPTO_link_gotonext">
			<xsl:value-of select="concat($alt_showpostings, ((.) + (../@COUNT) + 1), $alt_to, ((.) + (../@COUNT) + (../@COUNT)))"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="@SKIPTO" mode="c_gotolatest">
	Author:		Tom Whitehouse
	Context:      /H2G2/FORUMTHREADPOSTS/@SKIPTO
	Purpose:	 Calls the correct 'go to latest' link/text
	-->
	<xsl:template match="@SKIPTO" mode="c_gotolatest">
		<xsl:choose>
			<xsl:when test="../@MORE = 1">
				<xsl:apply-templates select="." mode="link_gotolatest"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="." mode="text_gotolatest"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="@SKIPTO" mode="link_gotolatest">
	Author:		Tom Whitehouse
	Context:      /H2G2/FORUMTHREADPOSTS/@SKIPTO
	Purpose:	 Creates the 'go to latest' link
	-->
	<xsl:template match="@SKIPTO" mode="link_gotolatest">
		<xsl:choose>
			<xsl:when test="(floor(../@TOTALPOSTCOUNT div ../@COUNT) * (../@COUNT)) = ../@TOTALPOSTCOUNT">
				<a href="{$root}F{../@FORUMID}?thread={../@THREADID}&amp;skip={(floor(../@TOTALPOSTCOUNT div ../@COUNT) * (../@COUNT)) - ../@COUNT}&amp;show={../@COUNT}" xsl:use-attribute-sets="maSKIPTO_link_gotolatest">
					<xsl:copy-of select="$alt_shownewest"/>
				</a>
			</xsl:when>
			<xsl:otherwise>
				<a href="{$root}F{../@FORUMID}?thread={../@THREADID}&amp;skip={floor(../@TOTALPOSTCOUNT div ../@COUNT) * (../@COUNT)}&amp;show={../@COUNT}" xsl:use-attribute-sets="maSKIPTO_link_gotolatest">
					<xsl:copy-of select="$alt_shownewest"/>
				</a>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="FORUMTHREADS" mode="c_otherthreads">
	Author:		Tom Whitehouse
	Context:      /H2G2/FORUMTHREADS
	Purpose:	 Calls the other threads container
	-->
	<xsl:template match="FORUMTHREADS" mode="c_otherthreads">
		<xsl:apply-templates select="." mode="r_otherthreads"/>
	</xsl:template>
	<!--
	<xsl:template match="THREAD" mode="c_otherthreadslist">
	Author:		Tom Whitehouse
	Context:      /H2G2/FORUMTHREADS/THREAD
	Purpose:	 Calls the containers for the previous/next thread links
	-->
	<xsl:template match="THREAD" mode="c_otherthreadslist">
		<xsl:param name="show"/>
		<xsl:param name="sibling"/>
		<xsl:choose>
			<xsl:when test="$sibling='previous'">
				<xsl:apply-templates select="../THREAD[@FORUMID=/H2G2/FORUMTHREADPOSTS/@FORUMID and @THREADID = /H2G2/FORUMTHREADPOSTS/@THREADID]/preceding-sibling::THREAD[position() &lt; $show]" mode="previous_otherthreadslist"/>
			</xsl:when>
			<xsl:when test="$sibling='next'">
				<xsl:apply-templates select="../THREAD[@FORUMID=/H2G2/FORUMTHREADPOSTS/@FORUMID and @THREADID = /H2G2/FORUMTHREADPOSTS/@THREADID]/following-sibling::THREAD[position() &lt; $show]" mode="next_otherthreadslist"/>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="FORUMTHREADPOSTS" mode="t_allthreads">
	Author:		Tom Whitehouse
	Context:      /H2G2/FORUMTHREADSPOSTS
	Purpose:	 Creates link to all the other threads in the forum
	-->
	<xsl:template match="FORUMTHREADPOSTS" mode="t_allthreads">
		<xsl:choose>
			<xsl:when test="../FORUMSOURCE[@TYPE='reviewforum']">
				<a href="{$root}RF{../FORUMSOURCE/REVIEWFORUM/@ID}?entry=0" xsl:use-attribute-sets="mFORUMTHREADPOSTS_t_allthreads">
					<xsl:value-of select="$m_articlelisttext"/>
				</a>
			</xsl:when>
			<xsl:otherwise>
				<a href="{$root}F{@FORUMID}?showthread={@THREADID}" xsl:use-attribute-sets="mFORUMTHREADPOSTS_t_allthreads">
					<xsl:value-of select="$m_returntothreadspage"/>
				</a>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="USER" mode="c_onlineflagmp">
	Author:		Tom Whitehouse
	Context:      /H2G2/FORUMTHREADSPOSTS/POST/USER/USERID
	Purpose:	 Calls the container for the user online flag
	-->
	<xsl:template match="USER" mode="c_onlineflagmp">
		<xsl:if test="key('onlineusers', USERID)">
			<xsl:apply-templates select="." mode="r_onlineflagmp"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="@INREPLYTO" mode="c_multiposts">
	Author:		Tom Whitehouse
	Context:      /H2G2/FORUMTHREADSPOSTS/POST/@INREPLYTO
	Purpose:	 Calls the container for the 'in reply to' link
	-->
	<xsl:template match="@INREPLYTO" mode="c_multiposts">
		<xsl:apply-templates select="." mode="r_multiposts"/>
	</xsl:template>
	<!--
	<xsl:template match="@INREPLYTO" mode="r_multiposts">
	Author:		Tom Whitehouse
	Context:      /H2G2/FORUMTHREADSPOSTS/POST/@INREPLYTO
	Purpose:	 Creates the 'in reply to' link
	-->
	<xsl:template match="@INREPLYTO" mode="r_multiposts">
		<xsl:param name="ptype"/>
		<xsl:choose>
			<xsl:when test="../../POST[@POSTID = .]">
				<a xsl:use-attribute-sets="maINREPLYTO_multiposts1">
					<xsl:attribute name="href"><xsl:value-of select="$root"/><xsl:choose><xsl:when test="$ptype='frame'">FFM</xsl:when><xsl:otherwise>F</xsl:otherwise></xsl:choose><xsl:value-of select="../../@FORUMID"/>?thread=<xsl:value-of select="../../@THREADID"/>&amp;skip=<xsl:value-of select="../../@SKIPTO"/>&amp;show=<xsl:value-of select="../../@COUNT"/>#p<xsl:value-of select="."/></xsl:attribute>
					<xsl:copy-of select="$m_thispost"/>
				</a>
			</xsl:when>
			<xsl:otherwise>
				<a xsl:use-attribute-sets="maINREPLYTO_multiposts2" href="{$root}F{../../@FORUMID}?thread={../../@THREADID}&amp;post={.}#p{.}">
					<xsl:if test="$ptype='frame'">
						<xsl:attribute name="target">_top</xsl:attribute>
					</xsl:if>
					<xsl:copy-of select="$m_thispost"/>
				</a>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="POST" mode="c_gadgetmp">
	Author:		Tom Whitehouse
	Context:      /H2G2/FORUMTHREADSPOSTS/POST
	Purpose:	 Calls the container for the multiposts gadget
	-->
	<xsl:template match="POST" mode="c_gadgetmp">
		<xsl:if test="$showtreegadget=1">
			<xsl:apply-templates select="." mode="r_gadgetmp"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="POST" mode="c_gadgetmp">
	Author:		Tom Whitehouse
	Context:      /H2G2/FORUMTHREADSPOSTS/POST
	Purpose:	 Calls the multiposts gadget
	-->
	<xsl:template match="POST" mode="r_gadgetmp">
		<xsl:apply-templates select="." mode="r_gadgetclubpost"/>
	</xsl:template>
	<!--
	<xsl:template match="@HIDDEN" mode="c_complainmp">
	Author:		Tom Whitehouse
	Context:      /H2G2/FORUMTHREADSPOSTS/POST/@HIDDEN
	Purpose:	 Calls the container for the 'complain about this post' link
	-->
	<xsl:template match="@HIDDEN" mode="c_complainmp">
		<xsl:if test=".=0">
      <xsl:apply-templates select="." mode="r_complainmp"/>
    </xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="@HIDDEN" mode="r_complainmp">
	Author:		Tom Whitehouse
	Context:      /H2G2/FORUMTHREADSPOSTS/POST/@HIDDEN
	Purpose:	 Creates the 'complain about this post' link
	-->
	<xsl:template match="@HIDDEN" mode="r_complainmp">
		<xsl:param name="attributes"/>
		<xsl:param name="embodiment" select="$alt_complain"/>
		<a href="{$root}comments/UserComplaintPage?PostID={../@POSTID}&amp;s_start=1" target="ComplaintPopup" onClick="popupwindow('{$root}comments/UserComplaintPage?PostID={../@POSTID}&amp;s_start=1', 'ComplaintPopup', 'status=1,resizable=1,scrollbars=1,width=640,height=480')" xsl:use-attribute-sets="maHIDDEN_r_complainmp">
			<xsl:copy-of select="$embodiment"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="@POSTID" mode="c_editmp">
	Author:		Tom Whitehouse
	Context:      /H2G2/FORUMTHREADSPOSTS/POST/@POSTID
	Purpose:	 Calls the container for the 'edit this post' link
	-->
	<xsl:template match="@POSTID" mode="c_editmp">
		<xsl:if test="$test_EditorOrModerator">
			<xsl:apply-templates select="." mode="r_editmp"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="@POSTID" mode="r_editmp">
	Author:		Tom Whitehouse
	Context:      /H2G2/FORUMTHREADSPOSTS/POST/@POSTID
	Purpose:	 Creates the 'edit this post' link
	-->
	<xsl:template match="@POSTID" mode="r_editmp">
		<a href="{$root}EditPost?PostID={.}" target="_top" onClick="popupwindow('{$root}EditPost?PostID={.}', 'EditPostPopup', 'status=1,resizable=1,scrollbars=1,width=400,height=450');return false;" xsl:use-attribute-sets="maPOSTID_r_editpost">
      <xsl:choose>
        <xsl:when test="$superuser = 1">
          <xsl:copy-of select="$m_editpost"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:copy-of select="$m_show"/>
        </xsl:otherwise>
      </xsl:choose>
    </a>
	</xsl:template>
	<!--
	<xsl:template match="@POSTID" mode="r_editmp">
	Author:		Tom Whitehouse
	Context:      /H2G2/FORUMTHREADSPOSTS/POST/@FIRSTCHILD
	Purpose:	 Calls the container for the 'first reply to this post' link
	-->
	<xsl:template match="@FIRSTCHILD" mode="c_multiposts">
		<xsl:apply-templates select="." mode="r_multiposts"/>
	</xsl:template>
	<!--
	<xsl:template match="@POSTID" mode="r_editmp">
	Author:		Tom Whitehouse
	Context:      /H2G2/FORUMTHREADSPOSTS/POST/@FIRSTCHILD
	Purpose:	 Creates the 'first reply to this post' link
	-->
	<xsl:template match="@FIRSTCHILD" mode="r_multiposts">
		<xsl:param name="embodiment" select="$m_firstreplytothis"/>
		<xsl:param name="ptype"/>
		<xsl:param name="attributes"/>
		<xsl:choose>
			<xsl:when test="../../POST[@POSTID = current()]">
				<a href="#p{.}" xsl:use-attribute-sets="maFIRSTCHILD_r_multiposts">
					<xsl:copy-of select="$embodiment"/>
				</a>
				<br/>
			</xsl:when>
			<xsl:otherwise>
				<a href="{$root}F{../../@FORUMID}?thread={../../@THREADID}&amp;post={../@FIRSTCHILD}#p{../@FIRSTCHILD}" xsl:use-attribute-sets="maFIRSTCHILD_r_multiposts">
					<xsl:if test="$ptype='frame'">
						<xsl:attribute name="target">_top</xsl:attribute>
					</xsl:if>
					<xsl:copy-of select="$embodiment"/>
				</a>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--================================================================-->
	<xsl:template name="insert-gadget">
		<xsl:if test="$showtreegadget=1">
			<xsl:apply-templates select="." mode="gadget"/>
		</xsl:if>
	</xsl:template>
	<xsl:variable name="showtreegadget">
		<xsl:choose>
			<xsl:when test="/H2G2/VIEWING-USER/USER/USER-MODE = 1">1</xsl:when>
			<xsl:otherwise>0</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:template name="showtreegadget">
		<xsl:param name="ptype" select="'frame'"/>
		<TABLE cellpadding="0" cellspacing="0" BORDER="0">
			<TR>
				<TD>
					<font>&nbsp;</font>
				</TD>
				<TD>
					<xsl:choose>
						<xsl:when test="@INREPLYTO">
							<xsl:attribute name="bgcolor">yellow</xsl:attribute>
							<xsl:choose>
								<xsl:when test="../POST[@POSTID = current()/@INREPLYTO]">
									<A>
										<xsl:attribute name="HREF">#p<xsl:value-of select="@INREPLYTO"/></xsl:attribute>
										<xsl:attribute name="title"><xsl:value-of select="$alt_replyingtothis"/></xsl:attribute>
										<font>^</font>
									</A>
								</xsl:when>
								<xsl:otherwise>
									<A>
										<xsl:if test="$ptype='frame'">
											<xsl:attribute name="target">twosides</xsl:attribute>
										</xsl:if>
										<xsl:attribute name="HREF"><xsl:value-of select="$root"/><xsl:choose><xsl:when test="$ptype='frame'">FLR</xsl:when><xsl:otherwise>F</xsl:otherwise></xsl:choose><xsl:value-of select="../@FORUMID"/>?thread=<xsl:value-of select="../@THREADID"/>&amp;post=<xsl:value-of select="@INREPLYTO"/>#p<xsl:value-of select="@INREPLYTO"/></xsl:attribute>
										<xsl:attribute name="title"><xsl:value-of select="$alt_replyingtothis"/></xsl:attribute>
										<font>^</font>
									</A>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:otherwise>
							<font>
								<xsl:text>^</xsl:text>
							</font>
						</xsl:otherwise>
					</xsl:choose>
				</TD>
				<TD>
					<font>&nbsp;</font>
				</TD>
			</TR>
			<TR>
				<TD>
					<xsl:choose>
						<xsl:when test="@PREVSIBLING">
							<xsl:attribute name="bgcolor">yellow</xsl:attribute>
							<xsl:choose>
								<xsl:when test="../POST[@POSTID = current()/@PREVSIBLING]">
									<A>
										<xsl:attribute name="HREF">#p<xsl:value-of select="@PREVSIBLING"/></xsl:attribute>
										<xsl:attribute name="title"><xsl:value-of select="$alt_prevreply"/></xsl:attribute>
										<font>&lt;</font>
									</A>
								</xsl:when>
								<xsl:otherwise>
									<A>
										<xsl:if test="$ptype='frame'">
											<xsl:attribute name="target">_top</xsl:attribute>
										</xsl:if>
										<xsl:attribute name="HREF"><xsl:value-of select="$root"/><xsl:choose><xsl:when test="$ptype='frame'">F</xsl:when><xsl:otherwise>F</xsl:otherwise></xsl:choose><xsl:value-of select="../@FORUMID"/>?thread=<xsl:value-of select="../@THREADID"/>&amp;post=<xsl:value-of select="@PREVSIBLING"/>#p<xsl:value-of select="@PREVSIBLING"/></xsl:attribute>
										<xsl:attribute name="title"><xsl:value-of select="$alt_prevreply"/></xsl:attribute>
										<font>&lt;</font>
									</A>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:otherwise>
							<font>
								<xsl:text>&lt;</xsl:text>
							</font>
						</xsl:otherwise>
					</xsl:choose>
				</TD>
				<TD>
					<font>o</font>
				</TD>
				<TD>
					<xsl:choose>
						<xsl:when test="@NEXTSIBLING">
							<xsl:attribute name="bgcolor">yellow</xsl:attribute>
							<xsl:choose>
								<xsl:when test="../POST[@POSTID = current()/@NEXTSIBLING]">
									<A>
										<xsl:attribute name="HREF">#p<xsl:value-of select="@NEXTSIBLING"/></xsl:attribute>
										<xsl:attribute name="title"><xsl:value-of select="$alt_nextreply"/></xsl:attribute>
										<font>&gt;</font>
									</A>
								</xsl:when>
								<xsl:otherwise>
									<A>
										<xsl:if test="$ptype='frame'">
											<xsl:attribute name="target">twosides</xsl:attribute>
										</xsl:if>
										<xsl:attribute name="HREF"><xsl:value-of select="$root"/><xsl:choose><xsl:when test="$ptype='frame'">FLR</xsl:when><xsl:otherwise>F</xsl:otherwise></xsl:choose><xsl:value-of select="../@FORUMID"/>?thread=<xsl:value-of select="../@THREADID"/>&amp;post=<xsl:value-of select="@NEXTSIBLING"/>#p<xsl:value-of select="@NEXTSIBLING"/></xsl:attribute>
										<xsl:attribute name="title"><xsl:value-of select="$alt_nextreply"/></xsl:attribute>
										<font>&gt;</font>
									</A>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:otherwise>
							<font>
								<xsl:text>&gt;</xsl:text>
							</font>
						</xsl:otherwise>
					</xsl:choose>
				</TD>
			</TR>
			<TR>
				<TD>
					<font>&nbsp;</font>
				</TD>
				<TD>
					<xsl:choose>
						<xsl:when test="@FIRSTCHILD">
							<xsl:attribute name="bgcolor">yellow</xsl:attribute>
							<xsl:choose>
								<xsl:when test="../POST[@POSTID = current()/@FIRSTCHILD]">
									<A>
										<xsl:attribute name="HREF">#p<xsl:value-of select="@FIRSTCHILD"/></xsl:attribute>
										<xsl:attribute name="title"><xsl:value-of select="$m_firstreplytothis"/></xsl:attribute>
										<font>V</font>
									</A>
								</xsl:when>
								<xsl:otherwise>
									<A>
										<xsl:if test="$ptype='frame'">
											<xsl:attribute name="target">twosides</xsl:attribute>
										</xsl:if>
										<xsl:attribute name="HREF"><xsl:value-of select="$root"/><xsl:choose><xsl:when test="$ptype='frame'">FLR</xsl:when><xsl:otherwise>F</xsl:otherwise></xsl:choose><xsl:value-of select="../@FORUMID"/>?thread=<xsl:value-of select="../@THREADID"/>&amp;post=<xsl:value-of select="@FIRSTCHILD"/>#p<xsl:value-of select="@FIRSTCHILD"/></xsl:attribute>
										<xsl:attribute name="title"><xsl:value-of select="$m_firstreplytothis"/></xsl:attribute>
										<font>V</font>
									</A>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:otherwise>
							<font>
								<xsl:text>V</xsl:text>
							</font>
						</xsl:otherwise>
					</xsl:choose>
				</TD>
				<TD>
					<font>&nbsp;</font>
				</TD>
			</TR>
		</TABLE>
	</xsl:template>
	<!--
	<xsl:template match="FORUMTHREADPOSTS" mode="c_blockdisplayprev">
	Author:		Andy Harris
	Context:      /H2G2/FORUMTHREADPOSTS
	Purpose:	 Calls the container for the previous link in the thread blocks navigation
	-->
	<xsl:template match="FORUMTHREADPOSTS" mode="c_blockdisplayprev">
		<xsl:if test="($mp_lowerrange != 0)">
			<xsl:apply-templates select="." mode="r_blockdisplayprev"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="FORUMTHREADPOSTS" mode="r_blockdisplayprev">
	Author:		Andy Harris
	Context:      /H2G2/FORUMTHREADPOSTS
	Purpose:	 Creates the previous link in the thread blocks navigation
	-->
	<xsl:template match="FORUMTHREADPOSTS" mode="r_blockdisplayprev">
		<a href="{$root}F{@FORUMID}?thread={@THREADID}&amp;skip={$mp_lowerrange - @COUNT}&amp;show={@COUNT}" xsl:use-attribute-sets="mFORUMTHREADPOSTS_r_blockdisplayprev">
			<xsl:copy-of select="$m_postblockprev"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="FORUMTHREADPOSTS" mode="c_blockdisplaynext">
	Author:		Andy Harris
	Context:      /H2G2/FORUMTHREADPOSTS
	Purpose:	 Calls the container for the next link in the thread blocks navigation
	-->
	<xsl:template match="FORUMTHREADPOSTS" mode="c_blockdisplaynext">
		<xsl:if test="(($mp_upperrange + @COUNT) &lt; @TOTALPOSTCOUNT)">
			<xsl:apply-templates select="." mode="r_blockdisplaynext"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="FORUMTHREADPOSTS" mode="r_blockdisplaynext">
	Author:		Andy Harris
	Context:      /H2G2/FORUMTHREADPOSTS
	Purpose:	 Creates the next link in the thread blocks navigation
	-->
	<xsl:template match="FORUMTHREADPOSTS" mode="r_blockdisplaynext">
		<a href="{$root}F{@FORUMID}?thread={@THREADID}&amp;skip={$mp_upperrange + @COUNT}&amp;show={@COUNT}" xsl:use-attribute-sets="mFORUMTHREADPOSTS_r_blockdisplaynext">
			<xsl:copy-of select="$m_postblocknext"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="FORUMTHREADPOSTS" mode="c_blockdisplay">
	Author:		Andy Harris
	Context:      /H2G2/FORUMTHREADPOSTS
	Purpose:	 Calls the template to create the links in the thread blocks navigation
	-->
	<xsl:template match="FORUMTHREADPOSTS" mode="c_blockdisplay">
		<xsl:param name="skip" select="$mp_lowerrange"/>
		<xsl:apply-templates select="." mode="displayblockmp">
			<xsl:with-param name="skip" select="$skip"/>
		</xsl:apply-templates>
		<xsl:if test="(($skip + @COUNT) &lt; @TOTALPOSTCOUNT) and ($skip &lt; $mp_upperrange)">
			<xsl:apply-templates select="." mode="c_blockdisplay">
				<xsl:with-param name="skip" select="$skip + @COUNT"/>
			</xsl:apply-templates>
		</xsl:if>
	</xsl:template>
	<!-- mpsplit is the numbers of tabs that appear on one page-->
	<xsl:variable name="mpsplit" select="10"/>
	<!--mp_lowerrange is the skip value of the first post of the first page of the series of tabs on the page-->
	<xsl:param name="mp_lowerrange" select="floor(/H2G2/FORUMTHREADPOSTS/@SKIPTO div ($mpsplit * /H2G2/FORUMTHREADPOSTS/@COUNT)) * ($mpsplit * /H2G2/FORUMTHREADPOSTS/@COUNT)"/>
	<!--mp_upperrange is the skip value of the first post of the last page of the series of tabs on the page-->
	<xsl:param name="mp_upperrange" select="$mp_lowerrange + (($mpsplit - 1) * /H2G2/FORUMTHREADPOSTS/@COUNT)"/>
	<!--
	<xsl:template match="FORUMTHREADPOSTS" mode="displayblockmp">
	Author:		Tom Whitehouse
	Context:      /H2G2/FORUMTHREADPOSTS
	Purpose:	 Creates the individual links in the postblock area within the range set above
	-->
	<xsl:template match="FORUMTHREADPOSTS" mode="displayblockmp">
		<xsl:param name="skip"/>
		<xsl:param name="PostRange" select="concat(($skip + 1), ' - ', ($skip + @COUNT))"/>
		<xsl:choose>
			<xsl:when test="@SKIPTO = $skip">
				<xsl:apply-templates select="." mode="on_blockdisplay">
					<xsl:with-param name="url">
						<a href="{$root}F{@FORUMID}?thread={@THREADID}&amp;skip={$skip}&amp;show={@COUNT}" xsl:use-attribute-sets="mFORUMTHREADPOSTS_on_blockdisplay">
							<xsl:call-template name="t_ontabcontent">
								<xsl:with-param name="range" select="$PostRange"/>
								<xsl:with-param name="pagenumber" select="substring-after($PostRange, ' - ') div @COUNT"/>
							</xsl:call-template>
						</a>
					</xsl:with-param>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="." mode="off_blockdisplay">
					<xsl:with-param name="url">
						<a href="{$root}F{@FORUMID}?thread={@THREADID}&amp;skip={$skip}&amp;show={@COUNT}" xsl:use-attribute-sets="mFORUMTHREADPOSTS_off_blockdisplay">
							<xsl:call-template name="t_offtabcontent">
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
	<xsl:template name="t_offtabcontent">
	Use: Controls the content of the link for other pages in the currently visible range
	-->
	<xsl:template name="t_offtabcontent">
		<xsl:param name="range"/>
		<xsl:param name="pagenumber"/>
		<xsl:value-of select="$pagenumber"/>
	</xsl:template>
	<!-- 
	<xsl:template name="t_ontabcontent">
	Use: Controls the content of the link for the currently visible page
	-->
	<xsl:template name="t_ontabcontent">
		<xsl:param name="range"/>
		<xsl:param name="pagenumber"/>
		<xsl:value-of select="$pagenumber"/>
	</xsl:template>
	
	<xsl:template match="THREADPHRASELIST" mode="c_multiposts">
		<form method="post" action="{$root}TSP"> 
			<input type="hidden" name="removephrases" value="1"/>
			<input type="hidden" name="thread" value="{@THREADID}"/>
			<input type="hidden" name="s_returnto" value="F{@FORUMID}?thread={@THREADID}"/>
			<xsl:apply-templates select="." mode="r_multiposts"/>
		</form>
	</xsl:template>
	
	<xsl:template match="THREADPHRASELIST" mode="c_addtag">
		<xsl:if test="$test_IsEditor">
			<xsl:apply-templates select="." mode="r_addtag"/>
		</xsl:if>
	</xsl:template>
	<xsl:template match="THREADPHRASELIST" mode="r_addtag">
		<a href="TSP?forum={@FORUMID}&amp;thread={@THREADID}&amp;addpage=1">Add another tag</a>
	</xsl:template>
	<xsl:variable name="m_postblockprev">prev</xsl:variable>
	<xsl:variable name="m_postblocknext">next</xsl:variable>
	<xsl:attribute-set name="mFORUMTHREADPOSTS_on_blockdisplay"/>
	<xsl:attribute-set name="mFORUMTHREADPOSTS_off_blockdisplay"/>
	<xsl:attribute-set name="mFORUMTHREADPOSTS_r_blockdisplayprev"/>
	<xsl:attribute-set name="mFORUMTHREADPOSTS_r_blockdisplaynext"/>
	<xsl:template match="PHRASE" mode="c_multiposts">
		<xsl:apply-templates select="." mode="r_multiposts"/>
	</xsl:template>
	<xsl:attribute-set name="mPHRASE_r_multiposts"/>
	<xsl:template match="PHRASE" mode="r_multiposts">
		<a href="{$root}TSP?phrase={TERM}" xsl:use-attribute-sets="mPHRASE_r_multiposts">
				<xsl:choose>
				<xsl:when test="string-length(NAME) &gt; 20">
					<xsl:value-of select="substring(NAME, 1, 20)"/>
					<xsl:text>...</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="NAME"/>
				</xsl:otherwise>
			</xsl:choose>
		</a>
	</xsl:template>
	<xsl:template match="PHRASE" mode="t_removetag">
		<xsl:if test="$test_IsEditor">
			<input type="checkbox" name="phrase" value="{TERM}"/>
			<xsl:text>remove</xsl:text>
			<br/>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="PHRASES" mode="t_submitremovetags">
		<xsl:if test="$test_IsEditor">
			<input type="submit" value="Remove tags"/>
			<br/>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>
