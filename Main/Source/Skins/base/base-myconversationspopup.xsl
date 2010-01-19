<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<!--Variables used throughout the page-->
	<xsl:variable name="target" select="/H2G2/PARAMS/PARAM[NAME='s_target']/VALUE"/>
	<xsl:variable name="skipparams">skip=<xsl:value-of select="/H2G2/POSTS/POST-LIST/@SKIPTO"/>&amp;show=<xsl:value-of select="/H2G2/POSTS/POST-LIST/@COUNT"/>&amp;</xsl:variable>
	<xsl:variable name="userid">
		<xsl:value-of select="/H2G2/POSTS/@USERID"/>
	</xsl:variable>
	<!--End of Variables used throughout the page-->
	<!--
	<xsl:template name="MYCONVERSATIONS_HEADER">
	Author:		Andy Harris
	Context:      H2G2
	Purpose:	 Creates the title for the page which sits in the html header
	-->
	<xsl:template name="MYCONVERSATIONS_HEADER">
		<xsl:variable name="newpost">
			<xsl:apply-templates select="POSTS/POST-LIST/POST" mode="shownew"/>
		</xsl:variable>
		<xsl:apply-templates mode="header" select=".">
			<xsl:with-param name="title">
				<xsl:if test="string-length($newpost) &gt; 0">*</xsl:if>
				<xsl:value-of select="$m_myconversationstitle"/>
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>
	<!--
	<xsl:template match="POST" mode="shownew">
	Author:		Andy Harris
	Context:      POST
	Purpose:	 Used to check to see whether the * appears in the page title
	-->
	<xsl:template match="POST" mode="shownew">
		<xsl:variable name="thread">
			<xsl:value-of select="THREAD/@THREADID"/>
		</xsl:variable>
		<xsl:variable name="threadread">
			<xsl:value-of select="substring-after(/H2G2/PARAMS/PARAM[NAME='s_t' and substring-before(VALUE,'|') = string($thread)]/VALUE,'|')"/>
		</xsl:variable>
		<xsl:if test="($threadread = '' or number(concat(THREAD/REPLYDATE/DATE/@YEAR,THREAD/REPLYDATE/DATE/@MONTH,THREAD/REPLYDATE/DATE/@DAY,THREAD/REPLYDATE/DATE/@HOURS,THREAD/REPLYDATE/DATE/@MINUTES,THREAD/REPLYDATE/DATE/@SECONDS)) &gt; $threadread) and (HAS-REPLY = 1)">1</xsl:if>
	</xsl:template>
	<!--
	<xsl:template name="ApplyAttributes">
	Author:		Andy Harris
	Context:      
	Purpose:	 Used to add attributes to links throughout the page
	-->
	<xsl:template name="ApplyAttributes">
		<xsl:param name="attributes"/>
		<xsl:for-each select="msxsl:node-set($attributes)/attribute">
			<xsl:attribute name="{@name}"><xsl:value-of select="@value"/></xsl:attribute>
		</xsl:for-each>
	</xsl:template>
	<!--
	<xsl:template match="PARAM" mode="ThreadRead">
	Author:		Andy Harris
	Context:      /H2G2/PARAMS/PARAM
	Purpose:	 Used to add parameters to the queary string as part of the link generation templates
	-->
	<xsl:template match="PARAM" mode="ThreadRead">
		<xsl:param name="setdate"/>
		<xsl:param name="date"/>
		<xsl:text>&amp;s_t=</xsl:text>
		<xsl:choose>
			<xsl:when test="$setdate">
				<xsl:value-of select="$date"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="VALUE"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="PARAM" mode="ThreadRead">
	Author:		Andy Harris
	Context:      /H2G2/POSTS/POST-LIST/POST
	Purpose:	 Used to add parameters to the queary string as part of the link generation templates
	-->
	<xsl:template match="POST" mode="ThreadRead">
		<xsl:param name="date"/>
		<xsl:text>&amp;s_t=</xsl:text>
		<xsl:value-of select="THREAD/@THREADID"/>|<xsl:value-of select="$date"/>
	</xsl:template>
	<!--
	<xsl:template match="DATE" mode="t_myconversations">
	Author:		Andy Harris
	Context:      /H2G2/POSTS/POST-LIST/POST
	Purpose:	 Complex template that creates the links which allow the user to switch the state of posts in the list
	-->
	<xsl:template match="DATE" mode="t_myconversations">
		<xsl:param name="userid"/>
		<xsl:param name="skipparams"/>
		<xsl:param name="target"/>
		<xsl:param name="linkText"/>
		<xsl:param name="threadparams"/>
		<xsl:param name="thread"/>
		<xsl:param name="allsame"/>
		<xsl:param name="postlist"/>
		<xsl:param name="adjust"/>
		<xsl:variable name="datestring">
			<xsl:choose>
				<xsl:when test="string-length($adjust)=0">
					<xsl:value-of select="concat(@YEAR,@MONTH,@DAY,@HOURS,@MINUTES,@SECONDS)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="string(number(concat(@YEAR,@MONTH,@DAY,@HOURS,@MINUTES,@SECONDS)) + number($adjust))"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<a xsl:use-attribute-sets="mDATE_MorePosts">
			<xsl:attribute name="href"><xsl:value-of select="$root"/>MP
				<xsl:value-of select="$userid"/>?
				<xsl:value-of select="$skipparams"/>s_type=pop&amp;s_target=
				<xsl:value-of select="$target"/><xsl:if test="$threadparams"><xsl:apply-templates select="msxsl:node-set($threadparams)" mode="ThreadRead"><xsl:with-param name="setdate" select="$allsame"/><xsl:with-param name="date" select="$datestring"/></xsl:apply-templates></xsl:if><xsl:if test="$postlist"><xsl:apply-templates select="msxsl:node-set($postlist)" mode="ThreadRead"><xsl:with-param name="date" select="$datestring"/></xsl:apply-templates></xsl:if><xsl:choose><xsl:when test="$thread"><xsl:text>&amp;s_t=</xsl:text><xsl:value-of select="$thread"/>|
						<xsl:value-of select="$datestring"/></xsl:when><xsl:otherwise><xsl:text>&amp;s_upto=</xsl:text><xsl:value-of select="$datestring"/></xsl:otherwise></xsl:choose></xsl:attribute>
			<xsl:copy-of select="$linkText"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="POST-LIST" mode="t_myconversations">
	Author:		Andy Harris
	Context:      /H2G2/POSTS/POST-LIST
	Purpose:	 Complex template that creates the back and next links
	-->
	<xsl:template match="POST-LIST" mode="t_myconversations">
		<xsl:param name="userid"/>
		<xsl:param name="target"/>
		<xsl:param name="linkText"/>
		<xsl:param name="prev"/>
		<a xsl:use-attribute-sets="mPOST-LIST_MorePosts">
			<xsl:attribute name="HREF"><xsl:value-of select="$root"/>MP<xsl:value-of select="$userid"/>?show=<xsl:value-of select="@COUNT"/>&amp;skip=<xsl:choose><xsl:when test="$prev = 1"><xsl:value-of select="number(@SKIPTO) - number(@COUNT)"/></xsl:when><xsl:otherwise><xsl:value-of select="number(@SKIPTO) + number(@COUNT)"/></xsl:otherwise></xsl:choose>&amp;s_type=pop&amp;s_upto=<xsl:value-of select="/H2G2/PARAMS/PARAM[NAME='s_upto']/VALUE"/>&amp;s_target=<xsl:value-of select="$target"/></xsl:attribute>
			<xsl:copy-of select="$linkText"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="DATE" mode="t_markallread">
	Author:		Andy Harris
	Context:      /H2G2/POSTS/POST-LIST/POST/.../DATE
	Purpose:	 Creates the 'Mark all Read' link
	-->
	<xsl:template match="DATE" mode="t_markallread">
		<xsl:apply-templates select="." mode="t_myconversations">
			<xsl:with-param name="userid" select="$userid"/>
			<xsl:with-param name="skipparams" select="$skipparams"/>
			<xsl:with-param name="target" select="$target"/>
			<xsl:with-param name="linkText" select="$m_MarkAllRead"/>
			<xsl:with-param name="allsame" select="true()"/>
			<xsl:with-param name="postlist" select="../POSTS/POST-LIST/POST"/>
		</xsl:apply-templates>
	</xsl:template>
	<!--
	<xsl:template match="POSTS" mode="c_myconversations">
	Author:		Andy Harris
	Context:      /H2G2/POSTS
	Purpose:	 Calls the container for the POSTS object
	-->
	<xsl:template match="POSTS" mode="c_myconversations">
		<xsl:apply-templates select="." mode="r_myconversations"/>
	</xsl:template>
	<!--
	<xsl:template match="POST" mode="c_myconversations">
	Author:		Andy Harris
	Context:      /H2G2/POSTS/POST-LIST/POST
	Purpose:	 Calls the container for the POST object and selects whether it is in an unread or read state
	-->
	<xsl:template match="POST" mode="c_myconversations">
		<xsl:variable name="thread">
			<xsl:value-of select="THREAD/@THREADID"/>
		</xsl:variable>
		<xsl:variable name="threadread">
			<xsl:value-of select="substring-after(/H2G2/PARAMS/PARAM[NAME='s_t' and substring-before(VALUE,'|') = string($thread)]/VALUE,'|')"/>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="($threadread = '' or number(concat(THREAD/REPLYDATE/DATE/@YEAR,THREAD/REPLYDATE/DATE/@MONTH,THREAD/REPLYDATE/DATE/@DAY,THREAD/REPLYDATE/DATE/@HOURS,THREAD/REPLYDATE/DATE/@MINUTES,THREAD/REPLYDATE/DATE/@SECONDS)) &gt; $threadread) and (HAS-REPLY = 1)">
				<xsl:apply-templates select="." mode="unread_myconversations"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="." mode="read_myconversations"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="DATE" mode="t_unreadmarker">
	Author:		Andy Harris
	Context:      /H2G2/POSTS/POST-LIST/POST/THREAD/REPLYDATE/DATE
	Purpose:	 Creates the link that changes the state of a post from 'Unread' to Read'
	-->
	<xsl:template match="DATE" mode="t_unreadmarker">
		<xsl:variable name="thread">
			<xsl:value-of select="../../@THREADID"/>
		</xsl:variable>
		<xsl:apply-templates select="." mode="t_myconversations">
			<xsl:with-param name="userid" select="$userid"/>
			<xsl:with-param name="skipparams" select="$skipparams"/>
			<xsl:with-param name="target" select="$target"/>
			<xsl:with-param name="linkText" select="'&gt;&gt;'"/>
			<xsl:with-param name="thread" select="../../@THREADID"/>
			<xsl:with-param name="threadparams" select="/H2G2/PARAMS/PARAM[NAME='s_t' and substring-before(VALUE,'|') != string($thread)]"/>
		</xsl:apply-templates>
	</xsl:template>
	<!--
	<xsl:template match="DATE" mode="t_readmarker">
	Author:		Andy Harris
	Context:      /H2G2/POSTS/POST-LIST/POST/THREAD/REPLYDATE/DATE
	Purpose:	 Creates the link that changes the state of a post from 'Read' to Unread'
	-->
	<xsl:template match="DATE" mode="t_readmarker">
		<xsl:variable name="thread">
			<xsl:value-of select="../../@THREADID"/>
		</xsl:variable>
		<xsl:apply-templates select="." mode="t_myconversations">
			<xsl:with-param name="userid" select="$userid"/>
			<xsl:with-param name="skipparams" select="$skipparams"/>
			<xsl:with-param name="target" select="$target"/>
			<xsl:with-param name="linkText" select="'&lt;&lt;'"/>
			<xsl:with-param name="thread" select="../../@THREADID"/>
			<xsl:with-param name="adjust" select="-1"/>
			<xsl:with-param name="threadparams" select="/H2G2/PARAMS/PARAM[NAME='s_t' and substring-before(VALUE,'|') != string($thread)]"/>
		</xsl:apply-templates>
	</xsl:template>
	<!--
	<xsl:template match="POST" mode="t_markallabove">
	Author:		Andy Harris
	Context:      /H2G2/POSTS/POST-LIST/POST
	Purpose:	 Creates the link that changes the state of any post above the present one to 'Unread' and those below to 'Read'
	-->
	<xsl:template match="POST" mode="t_markallabove">
		<xsl:apply-templates select="THREAD/REPLYDATE/DATE" mode="t_myconversations">
			<xsl:with-param name="userid" select="$userid"/>
			<xsl:with-param name="skipparams" select="$skipparams"/>
			<xsl:with-param name="target" select="$target"/>
			<xsl:with-param name="linkText" select="'^^'"/>
			<xsl:with-param name="allsame" select="true()"/>
			<xsl:with-param name="postlist" select="../POST"/>
		</xsl:apply-templates>
	</xsl:template>
	<!--
	<xsl:template match="SITEID" mode="t_sitefrom">
	Author:		Andy Harris
	Context:      /H2G2/POSTS/POST-LIST/POST/SITID
	Purpose:	 Creates the 'From site' text
	-->
	<xsl:template match="SITEID" mode="t_sitefrom">
		<xsl:variable name="thissiteid">
			<xsl:value-of select="."/>
		</xsl:variable>
		<xsl:value-of select="$m_fromsite"/>
		<xsl:text> </xsl:text>
		<xsl:value-of select="/H2G2/SITE-LIST/SITE[@ID=number($thissiteid)]/SHORTNAME"/>
	</xsl:template>
	<!--
	<xsl:template match="@THREADID" mode="t_subject">
	Author:		Andy Harris
	Context:      /H2G2/POSTS/POST-LIST/POST/THREAD/@THREADID
	Purpose:	 Creates the subject link and text
	-->
	<xsl:template match="@THREADID" mode="t_subject">
		<xsl:param name="attributes">
			<attribute name="target" value="{$target}"/>
		</xsl:param>
		<a xsl:use-attribute-sets="maTHREADID_t_subject">
			<xsl:call-template name="ApplyAttributes">
				<xsl:with-param name="attributes" select="$attributes"/>
			</xsl:call-template>
			<xsl:attribute name="href"><xsl:value-of select="$root"/>F<xsl:value-of select="../@FORUMID"/>?thread=<xsl:value-of select="."/></xsl:attribute>
			<xsl:apply-templates select="../SUBJECT" mode="nosubject"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="POST" mode="t_lastuserpost">
	Author:		Andy Harris
	Context:      /H2G2/POSTS/POST-LIST/POST
	Purpose:	 Creates the last user post link and text
	-->
	<xsl:template match="POST" mode="t_lastuserpost">
		<xsl:param name="attributes">
			<attribute name="target" value="{$target}"/>
		</xsl:param>
		<xsl:choose>
			<xsl:when test="THREAD/LASTUSERPOST">
				<xsl:value-of select="$m_postedcolon"/>
				<a xsl:use-attribute-sets="mPOST_t_lastuserpost">
					<xsl:call-template name="ApplyAttributes">
						<xsl:with-param name="attributes" select="$attributes"/>
					</xsl:call-template>
					<xsl:attribute name="HREF"><xsl:value-of select="$root"/>F<xsl:value-of select="THREAD/@FORUMID"/>?thread=<xsl:value-of select="THREAD/@THREADID"/>&amp;post=<xsl:value-of select="THREAD/LASTUSERPOST/@POSTID"/>#p<xsl:value-of select="THREAD/LASTUSERPOST/@POSTID"/></xsl:attribute>
					<xsl:apply-templates select="THREAD/REPLYDATE/DATE"/>
				</a>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$m_noposting"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="POST" mode="t_lastreply">
	Author:		Andy Harris
	Context:      /H2G2/POSTS/POST-LIST/POST
	Purpose:	 Creates the last reply link and text
	-->
	<xsl:template match="POST" mode="t_lastreply">
		<xsl:param name="attributes">
			<attribute name="target" value="{$target}"/>
		</xsl:param>
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
				<a xsl:use-attribute-sets="mPOST_t_lastreply">
					<xsl:call-template name="ApplyAttributes">
						<xsl:with-param name="attributes" select="$attributes"/>
					</xsl:call-template>
					<xsl:attribute name="HREF"><xsl:value-of select="$root"/>F<xsl:value-of select="THREAD/@FORUMID"/>?thread=<xsl:value-of select="THREAD/@THREADID"/><xsl:variable name="thread" select="THREAD/@THREADID"/><xsl:choose><xsl:when test="/H2G2/PARAMS/PARAM[NAME='s_t' and (substring-before(VALUE, '|') = string($thread))]"><xsl:text>&amp;date=</xsl:text><xsl:value-of select="substring-after(/H2G2/PARAMS/PARAM[NAME='s_t' and substring-before(VALUE, '|') = string($thread)]/VALUE,'|')"/></xsl:when><xsl:otherwise><xsl:text>&amp;latest=1</xsl:text></xsl:otherwise></xsl:choose></xsl:attribute>
					<xsl:apply-templates select="THREAD/REPLYDATE/DATE"/>
				</a>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$m_noreplies"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="POST-LIST" mode="c_back">
	Author:		Andy Harris
	Context:      /H2G2/POSTS/POST-LIST
	Purpose:	 Calls the container for the back link
	-->
	<xsl:template match="POST-LIST" mode="c_back">
		<xsl:if test="@SKIPTO &gt; 0">
			<xsl:apply-templates select="." mode="r_back"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="POST-LIST" mode="r_back">
	Author:		Andy Harris
	Context:      /H2G2/POSTS/POST-LIST
	Purpose:	 Creates the back link
	-->
	<xsl:template match="POST-LIST" mode="r_back">
		<xsl:apply-templates select="." mode="t_myconversations">
			<xsl:with-param name="userid" select="$userid"/>
			<xsl:with-param name="target" select="$target"/>
			<xsl:with-param name="linkText">&lt;&lt;<xsl:value-of select="$m_newerpostings"/>
			</xsl:with-param>
			<xsl:with-param name="prev">1</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>
	<!--
	<xsl:template match="POST-LIST" mode="c_next">
	Author:		Andy Harris
	Context:      /H2G2/POSTS/POST-LIST
	Purpose:	 Calls the container for the next link
	-->
	<xsl:template match="POST-LIST" mode="c_next">
		<xsl:if test="@MORE=1">
			<xsl:apply-templates select="." mode="r_next"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="POST-LIST" mode="r_next">
	Author:		Andy Harris
	Context:      /H2G2/POSTS/POST-LIST
	Purpose:	 Creates the next link
	-->
	<xsl:template match="POST-LIST" mode="r_next">
		<xsl:apply-templates select="." mode="t_myconversations">
			<xsl:with-param name="userid" select="$userid"/>
			<xsl:with-param name="target" select="$target"/>
			<xsl:with-param name="linkText">
				<xsl:value-of select="$m_olderpostings"/> &gt;&gt;</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>
</xsl:stylesheet>
