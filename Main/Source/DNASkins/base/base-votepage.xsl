<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<xsl:attribute-set name="fVOTING-PAGE_c_votetype"/>
	<xsl:attribute-set name="iVOTING-PAGE_t_displayradio"/>
	<xsl:attribute-set name="iVOTING-PAGE_t_hideradio"/>
	<xsl:attribute-set name="iVOTING-PAGE_t_signinradio"/>
	<xsl:attribute-set name="iVOTING-PAGE_t_anonymousradio"/>
	<xsl:attribute-set name="iVOTING-PAGE_t_submitvoteloggedin">
		<xsl:attribute name="type">submit</xsl:attribute>
		<xsl:attribute name="value">submit</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="iVOTING-PAGE_t_submitvoteloggedout">
		<xsl:attribute name="type">submit</xsl:attribute>
		<xsl:attribute name="value">submit</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="mOBJECT_t_returntoobject" use-attribute-sets="clubpagelinks"/>
	<xsl:attribute-set name="mUSER_r_voted" use-attribute-sets="clubpagelinks"/>
	<xsl:variable name="m_returntonoticepage">Return to your notice board page</xsl:variable>
	<xsl:variable name="m_noactiongiven">No vote was provided</xsl:variable>
	<xsl:variable name="sso_extravoteformfields"/>

	<!--
	<xsl:template name="ARTICLE_HEADER">
	Author:		Tom Whitehouse
	Context:      /H2G2
	Purpose:	 Creates the title for the page which sits in the html header
	-->
	<xsl:template name="VOTE_HEADER">
		<xsl:apply-templates mode="header" select=".">
			<xsl:with-param name="title">
				<xsl:choose>
					<xsl:when test="/H2G2/VOTING-PAGE/ACTION='finish'">
						<xsl:value-of select="$m_pagetitlestart"/>
						<xsl:copy-of select="$m_votecompletetitle"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$m_pagetitlestart"/>
						<xsl:copy-of select="$m_submitvotetitle"/>
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
	<xsl:template name="VOTE_SUBJECT">
		<xsl:choose>
			<xsl:when test="/H2G2/VOTING-PAGE/ACTION='add'">
				<xsl:copy-of select="$m_addvote"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy-of select="$m_votesubmitted"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="VOTING-PAGE" mode="error_vote">
		<xsl:choose>
			<xsl:when test="ERROR/INFO='NoAction'">
				<xsl:copy-of select="$m_noactiongiven"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="ERROR/INFO"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="VOTING-PAGE" mode="c_vote">
	Author:		Tom Whitehouse
	Context:      /H2G2
	Purpose:	Creates the container for the voting page
	-->
	<xsl:template match="VOTING-PAGE" mode="c_vote">
		<xsl:choose>
			<xsl:when test="ERROR/INFO">
				<xsl:apply-templates select="." mode="error_vote"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="ACTION='add'">
						<xsl:apply-templates select="." mode="add_vote"/>
					</xsl:when>
					<xsl:when test="ACTION='finish'">
						<xsl:apply-templates select="." mode="finish_vote"/>
					</xsl:when>
					<xsl:when test="CLIP[@ACTION='clippagetovote' and @RESULT='success']">
						<xsl:apply-templates select="." mode="clipped_vote"/>
					</xsl:when>
					<xsl:when test="CLIP[@ACTION='clippagetovote' and @RESULT='alreadylinkedhidden']">
						<xsl:apply-templates select="." mode="alreadyclipped_vote"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="." mode="unknown_vote"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="VOTING-PAGE" mode="c_votetype">
	Author:		Tom Whitehouse
	Context:      /H2G2
	Purpose:	Chooses the container for deciding whether register you vote or remain anonymous
	-->
	<xsl:template match="VOTING-PAGE" mode="c_votetype">
		<xsl:choose>
			<xsl:when test="VOTECLOSED=1">
				<xsl:apply-templates select="." mode="voteclosed_votetype"/>
			</xsl:when>
			<xsl:when test="ALREADYVOTED = 1">
				<xsl:apply-templates select="." mode="alreadyvoted_votetype"/>
			</xsl:when>
			<xsl:when test="USER/USERID = 0">
				<form name="signin" method="get" action="{$root}vote" xsl:use-attribute-sets="fVOTING-PAGE_c_votetype">
					<input type="hidden" name="response" value="{RESPONSE}"/>
					<input type="hidden" name="voteid" value="{VOTEID}"/>
					<xsl:copy-of select="$sso_extravoteformfields"/>
					<input type="hidden" name="type">
						<xsl:attribute name="value"><xsl:choose>
							<xsl:when test="/H2G2/VOTING-PAGE/VOTETYPE=2">2</xsl:when>
							<xsl:otherwise>1</xsl:otherwise>
						</xsl:choose></xsl:attribute>
					</input>
					
					<xsl:apply-templates select="." mode="loggedout_votetype"/>
				</form>
			</xsl:when>
			<xsl:otherwise>
				<form name="signin" method="get" action="{$root}vote" xsl:use-attribute-sets="fVOTING-PAGE_c_votetype">
					<input type="hidden" name="action" value="finish"/>
					<input type="hidden" name="response" value="{RESPONSE}"/>
					<input type="hidden" name="voteid" value="{VOTEID}"/>
					<xsl:copy-of select="$sso_extravoteformfields"/>
					<input type="hidden" name="type">
						<xsl:attribute name="value"><xsl:choose>
							<xsl:when test="/H2G2/VOTING-PAGE/VOTETYPE=2">2</xsl:when>
							<xsl:otherwise>1</xsl:otherwise>
						</xsl:choose></xsl:attribute>
					</input>
					<xsl:apply-templates select="." mode="loggedin_votetype"/>
				</form>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="VOTING-PAGE" mode="t_displayradio">
	Author:		Tom Whitehouse
	Context:      /H2G2
	Purpose:	Radio button for choosing to display your name
	-->
	<xsl:template match="VOTING-PAGE" mode="t_displayradio">
		<input type="radio" name="showuser" value="1" xsl:use-attribute-sets="iVOTING-PAGE_t_displayradio"/>
	</xsl:template>
	<!--
	<xsl:template match="VOTING-PAGE" mode="t_hideradio">
	Author:		Tom Whitehouse
	Context:      /H2G2
	Purpose:	Radio button for choosing to hide your name
	-->
	<xsl:template match="VOTING-PAGE" mode="t_hideradio">
		<input type="radio" name="showuser" value="0" xsl:use-attribute-sets="iVOTING-PAGE_t_hideradio"/>
	</xsl:template>
	<!--
	<xsl:template match="VOTING-PAGE" mode="t_signinradio">
	Author:		Tom Whitehouse
	Context:      /H2G2
	Purpose:	Radio button for choosing to sign in and display your name
	-->
	<xsl:template match="VOTING-PAGE" mode="t_signinradio">
		<input type="radio" name="action" value="signin" xsl:use-attribute-sets="iVOTING-PAGE_t_signinradio"/>
	</xsl:template>
	<!--
	<xsl:template match="VOTING-PAGE" mode="t_anonymousradio">
	Author:		Tom Whitehouse
	Context:      /H2G2
	Purpose:	Radio button for choosing to remain anonymous
	-->
	<xsl:template match="VOTING-PAGE" mode="t_anonymousradio">
		<input type="checkbox" name="action" value="finish" xsl:use-attribute-sets="iVOTING-PAGE_t_anonymousradio"/>
		<!--input type="radio" name="action" value="finish" xsl:use-attribute-sets="iVOTING-PAGE_t_anonymousradio"/-->
	</xsl:template>
	<!--
	<xsl:template match="VOTING-PAGE" mode="t_submitvoteloggedin">
	Author:		Tom Whitehouse
	Context:      /H2G2
	Purpose:	Submit button for registering your vote when logged in
	-->
	<xsl:template match="VOTING-PAGE" mode="t_submitvoteloggedin">
		<input xsl:use-attribute-sets="iVOTING-PAGE_t_submitvoteloggedin"/>
	</xsl:template>
	<!--
	<xsl:template match="VOTING-PAGE" mode="t_submitvoteloggedout">
	Author:		Tom Whitehouse
	Context:      /H2G2
	Purpose:	Submit button for registering your vote when not logged in
	-->
	<xsl:template match="VOTING-PAGE" mode="t_submitvoteloggedout">
		<input xsl:use-attribute-sets="iVOTING-PAGE_t_submitvoteloggedout"/>
	</xsl:template>
	<!--
	<xsl:template match="OBJECT" mode="t_returntoobject">
	Author:		Tom Whitehouse
	Context:      /H2G2/VOTING-PAGE
	Purpose:	Links back to the object (eg club) page
	-->
	<xsl:template match="OBJECT" mode="t_returntoobject">
		<xsl:variable name="url">
			<xsl:choose>
				<xsl:when test="@TYPE='CLUB'">G<xsl:value-of select="@ID"/></xsl:when>
				<xsl:when test="@TYPE='NOTICE'">NoticeBoard?postcode=<xsl:value-of select="/H2G2/VOTING-PAGE/OBJECT/@POSTCODE"/></xsl:when>
				<xsl:when test="@TYPE=2001">RF<xsl:value-of select="@ID"/></xsl:when>
				<xsl:when test="@TYPE=3001">U<xsl:value-of select="@ID"/></xsl:when>
				<xsl:when test="@TYPE=4001">C<xsl:value-of select="@ID"/></xsl:when>
				<xsl:otherwise>A</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<a href="{$root}{$url}" xsl:use-attribute-sets="mOBJECT_t_returntoobject">
			<xsl:choose>
				<xsl:when test="@TYPE='CLUB'">
					<xsl:copy-of select="$m_returntoclubpage"/>
				</xsl:when>
				<xsl:when test="@TYPE='NOTICE'">
					<xsl:copy-of select="$m_returntonoticepage"/>
				</xsl:when>
				<xsl:when test="@TYPE=2001">
					<xsl:copy-of select="$m_returntorfpage"/>
				</xsl:when>
				<xsl:when test="@TYPE=3001">
					<xsl:copy-of select="$m_returntouserpage"/>
				</xsl:when>
				<xsl:when test="@TYPE=4001">
					<xsl:copy-of select="$m_returntocategorypage"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:copy-of select="$m_returntoarticlepage"/>
				</xsl:otherwise>
			</xsl:choose>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="VOTINGUSERS" mode="c_vote">
	Author:		Tom Whitehouse
	Context:      /H2G2/VOTING-PAGE
	Purpose:	Creates container for displaying a list of users that have voted
	-->
	<xsl:template match="VOTINGUSERS" mode="c_vote">
		<xsl:apply-templates select="." mode="r_vote"/>
	</xsl:template>
	<!--
	<xsl:template match="VISIBLEUSERS" mode="c_list">
	Author:		Tom Whitehouse
	Context:      /H2G2/VOTING-PAGE/VOTINGUSERS
	Purpose:	Container for the visible (registered) users
	-->
	<xsl:template match="VISIBLEUSERS" mode="c_list">
		<xsl:choose>
			<xsl:when test="USER">
				<xsl:apply-templates select="." mode="full_list"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="." mode="empty_list"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="HIDDENUSERS" mode="c_list">
	Author:		Tom Whitehouse
	Context:       /H2G2/VOTING-PAGE/VOTINGUSERS
	Purpose:	Container for displaying the anonymous users
	-->
	<xsl:template match="HIDDENUSERS" mode="c_list">
		<xsl:choose>
			<xsl:when test="@COUNT &gt; 0">
				<xsl:apply-templates select="." mode="full_list"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="." mode="empty_list"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="USER" mode="c_voted">
	Author:		Tom Whitehouse
	Context:     /H2G2/VOTING-PAGE/VOTINGUSERS/VISIBLEUSERS
	Purpose:	Container for diaplying a single visible user
	-->
	<xsl:template match="USER" mode="c_voted">
		<xsl:apply-templates select="." mode="r_voted"/>
	</xsl:template>
	<!--
	<xsl:template match="USER" mode="r_voted">
	Author:		Tom Whitehouse
	Context:     /H2G2/VOTING-PAGE/VOTINGUSERS/VISIBLEUSERS
	Purpose:	Creates the link to a single visible user's personal space
	-->
	<xsl:template match="USER" mode="r_voted">
		<a href="{$root}U{USERID}" xsl:use-attribute-sets="mUSER_r_voted">
			<xsl:value-of select="USERNAME"/>
		</a>
	</xsl:template>
</xsl:stylesheet>
