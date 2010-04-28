<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<xsl:variable name="m_clublinkclipped">This club has been added to your clippings</xsl:variable>
	<xsl:variable name="m_clubalreadyclipped">You have already added this club to your clippings</xsl:variable>
	<xsl:variable name="m_editclubmembership">Edit club: membership</xsl:variable>
	<xsl:variable name="m_editclubmember">Edit club: edit member</xsl:variable>
	<xsl:variable name="m_returntoeditmembers">Return to the edit members page</xsl:variable>
	<xsl:variable name="m_tagclub">Add this club to the taxonomy</xsl:variable>
	<xsl:variable name="m_editclubtags">Edit the taxonomy nodes for this club</xsl:variable>
	<xsl:variable name="m_clubsublink">Subscribe to Club</xsl:variable>
	<xsl:variable name="m_clubsubmanagelink">Manage Club Subscription</xsl:variable>
	<xsl:variable name="m_createclubloggedoutreg">
		<a href="{$sso_resources}{$sso_script}?c=register&amp;service={$sso_serviceid_link}&amp;ptrt={$sso_redirectserver}{$root}SSO%3Fpa=createclub">register</a>
	</xsl:variable>
	<xsl:variable name="m_createclubloggedoutlogin">
		<a href="{$sso_resources}{$sso_script}?c=login&amp;service={$sso_serviceid_link}&amp;ptrt={$sso_redirectserver}{$root}SSO%3Fpa=createclub">login</a>
	</xsl:variable>
	<xsl:attribute-set name="mCLUB_edit_tag" use-attribute-sets="clubpagelinks"/>
	<xsl:attribute-set name="mCLUB_add_tag" use-attribute-sets="clubpagelinks"/>
	<xsl:attribute-set name="mCLUBACTIONLIST_t_returntoeditmembers" use-attribute-sets="clubpagelinks"/>
	<xsl:attribute-set name="mACTIONUSER_t_invitinguser" use-attribute-sets="clubpagelinks"/>
	<xsl:attribute-set name="mNAME_t_subjectlink"/>
	<xsl:variable name="clubfields"><![CDATA[<MULTI-INPUT>
						<REQUIRED NAME='TYPE'></REQUIRED>
						<REQUIRED NAME='BODY'></REQUIRED>
						<REQUIRED NAME='TITLE' ESCAPED='1'><VALIDATE TYPE='EMPTY'/></REQUIRED>
				</MULTI-INPUT>]]></xsl:variable>
	<!--
	* * * * * * * * * * * ATTRIBUTE SETS * * * * * * * * * * * 
	Author:		Tom Whitehouse
	Context:       -
	Purpose:	Attribute-sets for the form elements
	-->
	<xsl:attribute-set name="mTEAM_r_more"/>
	<xsl:attribute-set name="iHIERARCHYRESULT_t_checkbox">
		<xsl:attribute name="type">checkbox</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="iSEARCHRESULTS_t_catagorisesubmit">
		<xsl:attribute name="value">Submit</xsl:attribute>
		<xsl:attribute name="type">submit</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="sMEMBER_t_selectactionform"/>
	<xsl:attribute-set name="oMEMBER_t_selectactionform"/>
	<xsl:attribute-set name="fMEMBER_c_changetypeform"/>
	<xsl:attribute-set name="iMEMBER_t_selectactionsubmit">
		<xsl:attribute name="type">submit</xsl:attribute>
		<xsl:attribute name="value"><xsl:copy-of select="$m_submitmemberedit"/></xsl:attribute>
	</xsl:attribute-set>
	<!--
	* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
	* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
	-->
	<!--
	<xsl:template name="CLUB_HEADER">
	Author:		Andy Harris
	Context:      /H2G2	
	Purpose:	 Creates the title for the page which sits in the html header
	-->
	<xsl:template name="CLUB_HEADER">
		<xsl:apply-templates mode="header" select=".">
			<xsl:with-param name="title">
				<xsl:value-of select="$m_pagetitlestart"/>
				<xsl:value-of select="/H2G2/CLUB/CLUBINFO/NAME"/>
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>
	<!--
	<xsl:template name="CLUB_SUBJECT">
	Author:		Tom Whitehouse
	Context:      /H2G2
	Purpose:	 Creates the text for the subject
	-->
	<xsl:template name="CLUB_SUBJECT">
		<xsl:choose>
			<xsl:when test="(/H2G2/MULTI-STAGE/@TYPE = 'CLUB') and not(/H2G2/MULTI-STAGE/@FINISH='YES')">
				<xsl:call-template name="SUBJECTHEADER">
					<xsl:with-param name="text">
						<xsl:copy-of select="$m_clubcreationtitle"/>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="/H2G2/PARAMS/PARAM[NAME='s_view']/VALUE='editmembers'">
				<xsl:call-template name="SUBJECTHEADER">
					<xsl:with-param name="text">
						<xsl:copy-of select="$m_editclubmembership"/>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="SUBJECTHEADER">
					<xsl:with-param name="text">
						<xsl:value-of select="/H2G2/CLUB/CLUBINFO/NAME"/>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="CLUB" mode="c_display">
	Author:		Tom Whitehouse
	Context:      /H2G2
	Purpose:	 Creates the container for the regular view club page
	-->
	<xsl:template match="CLUB" mode="c_display">
		<xsl:if test="not(/H2G2/PARAMS/PARAM[NAME='s_view']) and (not(/H2G2/MULTI-STAGE) or /H2G2/MULTI-STAGE/@FINISH='YES')">
			<xsl:apply-templates select="." mode="r_display"/>
		</xsl:if>
	</xsl:template>
	<xsl:template match="ERROR" mode="c_message">
		<xsl:choose>
			<xsl:when test="@TYPE='NoUser'">
				<xsl:apply-templates select="." mode="loggedout_message"/>
			</xsl:when>
			
		</xsl:choose>
	</xsl:template>
	<xsl:template match="CLIP" mode="c_clubclipped">
		<xsl:apply-templates select="." mode="r_clubclipped"/>
	</xsl:template>
	<xsl:template match="CLIP" mode="r_clubclipped">
		<xsl:choose>
			<xsl:when test="@RESULT='success'">
				<xsl:copy-of select="$m_clublinkclipped"/>
			</xsl:when>
			<xsl:when test="@RESULT='alreadylinked'">
				<xsl:copy-of select="$m_clubalreadyclipped"/>
			</xsl:when>
			<xsl:when test="@RESULT='alreadylinkedhidden'">
				<xsl:copy-of select="$m_clubalreadyclipped"/>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="CLUBACTIONLIST" mode="c_editmembership">
	Author:		Tom Whitehouse
	Context:      /H2G2
	Purpose:	Chooses which container to call, either a full list of members and recent actions or an inidividual user
	-->
	<xsl:template match="CLUBACTIONLIST" mode="c_editmembership">
		<xsl:if test="/H2G2/PARAMS/PARAM[NAME='s_view']/VALUE='editmembers'">
			<xsl:apply-templates select="." mode="list_editmembership"/>
		</xsl:if>
	</xsl:template>
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
							Display all users page
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<!--
	<xsl:template match="CLUBACTIONLIST" mode="c_pending">
	Author:		Tom Whitehouse
	Context:      /H2G2
	Purpose:	Creates the container for the 'pending requests' list
	-->
	<xsl:template match="CLUBACTIONLIST" mode="c_pending">
		<xsl:if test="CLUBACTION[@RESULT='stored' and (@ACTIONTYPE='joinmember' or @ACTIONTYPE='joinowner')]">
			<xsl:apply-templates select="." mode="r_pending"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="CLUBACTIONLIST" mode="c_completed">
	Author:		Tom Whitehouse
	Context:      /H2G2
	Purpose:	 Creates the container for the 'completed requests' list
	-->
	<xsl:template match="CLUBACTIONLIST" mode="c_completed">
		<xsl:if test="CLUBACTION[@RESULT='complete' and (@ACTIONTYPE='joinmember' or @ACTIONTYPE='joinowner')]">
			<xsl:apply-templates select="." mode="r_completed"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="CLUBACTION" mode="c_pending">
	Author:		Tom Whitehouse
	Context:      /H2G2/CLUBACTIONLIST
	Purpose:	 Chooses which 'pending' template to call, requests or invitations
	-->
	<xsl:template match="CLUBACTION" mode="c_pending">
		<xsl:choose>
			<xsl:when test="@RESULT='stored' and (@ACTIONTYPE='joinmember' or @ACTIONTYPE='joinowner')">
				<xsl:apply-templates select="." mode="join_pending"/>
			</xsl:when>
			<xsl:when test="@RESULT='stored' and (@ACTIONTYPE='invitemember' or @ACTIONTYPE='inviteowner')">
				<xsl:apply-templates select="." mode="invite_pending"/>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="CLUBACTION" mode="c_completed">
	Author:		Tom Whitehouse
	Context:      /H2G2/CLUBACTIONLIST
	Purpose:	 Creates a container for a single competed request
	-->
	<xsl:template match="CLUBACTION" mode="c_completed">
		<xsl:choose>
			<xsl:when test="@RESULT='complete' and (@ACTIONTYPE='joinmember' or @ACTIONTYPE='joinowner')">
				<xsl:apply-templates select="." mode="join_completed"/>
			</xsl:when>
			<xsl:when test="@RESULT='complete' and (@ACTIONTYPE='invitemember' or @ACTIONTYPE='inviteowner')">
				<xsl:apply-templates select="." mode="invite_completed"/>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="ACTIONUSER" mode="t_inviteduser">	
	Author:		Tom Whitehouse
	Context:      /H2G2/CLUBACTIONLIST/CLUBACTION
	Purpose:	 Creates a link to the user invited / requesting to join
	-->
	<xsl:template match="ACTIONUSER" mode="t_inviteduser">
		<a href="{$root}U{USER/USERID}" xsl:use-attribute-sets="mACTIONUSER_t_inviteduser">
			<xsl:apply-templates select="USER" mode="username"/>
		</a>
	</xsl:template>
	<xsl:template match="COMPLETEUSER" mode="t_invitinguser">
		<a href="{$root}U{USER/USERID}" xsl:use-attribute-sets="mACTIONUSER_t_invitinguser">
			<xsl:apply-templates select="USER" mode="username"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="@ACTIONTYPE" mode="t_invitetext">
	Author:		Tom Whitehouse
	Context:      /H2G2/CLUBACTIONLIST/CLUBACTION
	Purpose:	 Chooses the text for an invite action - eg 'member has been invited to  be a member' 
	-->
	<xsl:template match="@ACTIONTYPE" mode="t_invitetext">
		<xsl:choose>
			<xsl:when test=".='invitemember'">
				<xsl:copy-of select="$m_invitedmember"/>
			</xsl:when>
			<xsl:when test=".='inviteowner'">
				<xsl:copy-of select="$m_invitedowner"/>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="@ACTIONTYPE" mode="t_requesttypetext">
	Author:		Tom Whitehouse
	Context:      /H2G2/CLUBACTIONLIST/CLUBACTION
	Purpose:	Chooses the text for a join action - eg 'member has requested to be a member of..' 
	-->
	<xsl:template match="@ACTIONTYPE" mode="t_requesttypetext">
		<xsl:choose>
			<xsl:when test=".='joinmember'">
				<xsl:copy-of select="$m_joinmemberrequest"/>
			</xsl:when>
			<xsl:when test=".='joinowner'">
				<xsl:copy-of select="$m_joinownerrequest"/>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="ACTIONUSER" mode="t_nameofrequestor">
	Author:		Tom Whitehouse
	Context:      /H2G2/CLUBACTIONLIST/CLUBACTION
	Purpose:	 Displays the name of the person making a (pending) request as a link
	-->
	<xsl:template match="ACTIONUSER" mode="t_nameofrequestor">
		<a href="{$root}U{USER/USERID}" xsl:use-attribute-sets="mACTIONUSER_t_nameofrequestor">
			<xsl:apply-templates select="USER/USERNAME"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="CLUBNAME" mode="t_request">
	Author:		Tom Whitehouse
	Context:      /H2G2/CLUBACTIONLIST/CLUBACTION
	Purpose:	Displays the name of the club relating to the (pending) action as a link
	-->
	<xsl:template match="CLUBNAME" mode="t_request">
		<a href="{$root}G{../@CLUBID}" xsl:use-attribute-sets="mCLUBNAME_t_request">
			<xsl:value-of select="."/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="CLUBACTION" mode="t_accept">
	Author:		Tom Whitehouse
	Context:       /H2G2/CLUBACTIONLIST
	Purpose:	 Displays an 'accept' link to accept a pending request
	-->
	<xsl:template match="CLUBACTION" mode="t_accept">
		<a href="{$root}G{@CLUBID}?action=process&amp;actionid={@ACTIONID}&amp;result=1&amp;s_view=edit" xsl:use-attribute-sets="mCLUBACTION_t_accept">
			<xsl:copy-of select="$m_accept"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="CLUBACTION" mode="t_reject">
	Author:		Tom Whitehouse
	Context:      /H2G2/CLUBACTIONLIST
	Purpose:	Displays a 'reject' link to reject a pending request
	-->
	<xsl:template match="CLUBACTION" mode="t_reject">
		<a href="{$root}G{@CLUBID}?action=process&amp;actionid={@ACTIONID}&amp;result=2&amp;s_view=edit" xsl:use-attribute-sets="mCLUBACTION_t_reject">
			<xsl:copy-of select="$m_reject"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="DATEREQUESTED" mode="t_request">
	Author:		Tom Whitehouse
	Context:      /H2G2/CLUBACTIONLIST/CLUBACTION
	Purpose:     Displays the date a request was made	 
	-->
	<xsl:template match="DATEREQUESTED" mode="t_request">
		<xsl:apply-templates select="DATE"/>
	</xsl:template>
	<!--
	<xsl:template match="ACTIONUSER" mode="t_nameofrequested">
	Author:		Tom Whitehouse
	Context:      /H2G2/CLUBACTIONLIST/CLUBACTION
	Purpose:	 Displays the name of a completed requested action
	-->
	<xsl:template match="ACTIONUSER" mode="t_nameofrequested">
		<a href="{$root}U{USER/USERID}" xsl:use-attribute-sets="mACTIONUSER_t_nameofrequested">
			<xsl:apply-templates select="USER/USERNAME"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="@ACTIONTYPE" mode="t_requestmade">
	Author:		Tom Whitehouse
	Context:      /H2G2/CLUBACTIONLIST/CLUBACTION
	Purpose:	Chooses the type of request that was made
	-->
	<xsl:template match="@ACTIONTYPE" mode="t_requestmade">
		<xsl:choose>
			<xsl:when test=".='joinmember'">
				<xsl:copy-of select="$m_joinmember3rdperson"/>
			</xsl:when>
			<xsl:when test=".='joinowner'">
				<xsl:copy-of select="$m_joinownerviewer3rdperson"/>
			</xsl:when>
			<xsl:when test=".='invitemember'">
				<xsl:copy-of select="$m_invitemember3rdperson"/>
			</xsl:when>
			<xsl:when test=".='inviteowner'">
				<xsl:copy-of select="$m_inviteowner3rdperson"/>
			</xsl:when>
			<xsl:when test=".='ownerresignsmember'">
				<xsl:copy-of select="$m_ownerresignsmember3rdperson"/>
			</xsl:when>
			<xsl:when test=".='ownerresignscompletely'">
				<xsl:copy-of select="$m_ownerresignscompletely3rdperson"/>
			</xsl:when>
			<xsl:when test=".='memberresigns'">
				<xsl:copy-of select="$m_memberresigns3rdperson"/>
			</xsl:when>
			<xsl:when test=".='demoteownertomember'">
				<xsl:copy-of select="$m_demoteownertomember3rdperson"/>
			</xsl:when>
			<xsl:when test=".='removeowner'">
				<xsl:copy-of select="$m_removeowner3rdperson"/>
			</xsl:when>
			<xsl:when test=".='removemember'">
				<xsl:copy-of select="$m_removemember3rdperson"/>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="DATEREQUESTED" mode="t_clubaction">
	Author:		Tom Whitehouse
	Context:       /H2G2/CLUBACTIONLIST/CLUBACTION
	Purpose:	 Displays the date a completed request was made
	-->
	<xsl:template match="DATEREQUESTED" mode="t_clubaction">
		<xsl:apply-templates select="DATE"/>
	</xsl:template>
	<!--
	<xsl:template match="@RESULT" mode="t_requestresult">
	Author:		Tom Whitehouse
	Context:       /H2G2/CLUBACTIONLIST/CLUBACTION
	Purpose:	 Displays the result of a completed request
	-->
	<xsl:template match="@RESULT" mode="t_requestresult">
		<xsl:choose>
			<xsl:when test="../@ACTIONTYPE='invitemember' or ../@ACTIONTYPE='inviteowner'">
				<xsl:choose>
					<xsl:when test=".='complete'"> Accepted </xsl:when>
					<xsl:when test=".='declined'"> Declined </xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="."/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test=".='complete'"> Completed by </xsl:when>
					<xsl:when test=".='declined'"> Declined by </xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="."/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="COMPLETEUSER" mode="c_authoriser">
	Author:		Tom Whitehouse
	Context:      /H2G2/CLUBACTIONLIST/CLUBACTION
	Purpose:	 Creates a container for the person who authorised a completed request
	-->
	<xsl:template match="COMPLETEUSER" mode="c_authoriser">
		<xsl:apply-templates select="." mode="r_authoriser"/>
	</xsl:template>
	<!--
	<xsl:template match="COMPLETEUSER" mode="r_authoriser">
	Author:		Tom Whitehouse
	Context:      /H2G2/CLUBACTIONLIST/CLUBACTION
	Purpose:	Displays the name of the person who authorised a completed request, as a link.
	-->
	<xsl:template match="COMPLETEUSER" mode="r_authoriser">
		<a href="{$root}U{USER/USERID}" xsl:use-attribute-sets="mCOMPLETEUSER_r_authoriser">
			<xsl:apply-templates select="USER" mode="username"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="DATECOMPLETED" mode="t_clubaction">
	Author:		Tom Whitehouse
	Context:      /H2G2/CLUBACTIONLIST/CLUBACTION
	Purpose:	Displays the date a request was authorised / rejected 
	-->
	<xsl:template match="DATECOMPLETED" mode="t_clubaction">
		<xsl:apply-templates select="DATE"/>
	</xsl:template>
	<!--
	<xsl:template match="TEAM" mode="c_editmemberslist">
	Author:		Tom Whitehouse
	Context:      /H2G2/CLUB/POPULATION
	Purpose:	Creates the container listing all the members of a team
	-->
	<xsl:template match="TEAM" mode="c_editmemberslist">
		<xsl:if test="@TYPE='MEMBER'">
			<xsl:apply-templates select="." mode="r_editmemberslist"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="MEMBER" mode="c_memberdetails">
	Author:		Tom Whitehouse
	Context:       /H2G2/CLUB/POPULATION/TEAM
	Purpose:	 Creates the container for a single member within this list
	-->
	<xsl:template match="MEMBER" mode="c_memberdetails">
		<xsl:apply-templates select="." mode="r_memberdetails"/>
	</xsl:template>
	<!--
	<xsl:template match="USER" mode="t_membershipname">
	Author:		Tom Whitehouse
	Context:      /H2G2/CLUB/POPULATION/TEAM/MEMBER
	Purpose:	Displays the username of a single member within this list, as a link
	-->
	<xsl:template match="USER" mode="t_membershipname">
		<a href="{$root}U{USERID}" xsl:use-attribute-sets="mUSER_t_membershipname">
			<xsl:apply-templates select="." mode="username"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="USER" mode="c_editmember">
	Author:		Tom Whitehouse
	Context:      /H2G2/CLUB/POPULATION/TEAM/MEMBER
	Purpose:	Creates a container for the link to edit details for a single member within this list
	-->
	<xsl:template match="USER" mode="c_editmember">
		<xsl:if test="$viewerid = /H2G2/CLUB/POPULATION/TEAM[@TYPE='OWNER']/MEMBER/USER/USERID">
			<xsl:apply-templates select="." mode="r_editmember"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="USER" mode="r_editmember">
	Author:		Tom Whitehouse
	Context:      /H2G2/CLUB/POPULATION/TEAM/MEMBER
	Purpose:      Displays a link to edit details for a single member within this list
	-->
	<xsl:template match="USER" mode="r_editmember">
		<a href="{$root}G{/H2G2/CLUB/CLUBINFO/@ID}?s_view=U{USERID}" xsl:use-attribute-sets="mUSER_r_editmember">
			<xsl:copy-of select="$m_editmemberdetails"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="USER" mode="t_ownerormember">
	Author:		Tom Whitehouse
	Context:      /H2G2/CLUB/POPULATION/TEAM/MEMBER
	Purpose:	 Displays the type of a single member within this list (owner or member)
	-->
	<xsl:template match="USER" mode="t_ownerormember">
		<xsl:choose>
			<xsl:when test="USERID = ../../../TEAM[@TYPE='OWNER']/MEMBER/USER/USERID">
				<xsl:copy-of select="$m_editmembers_owner"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy-of select="$m_editmembers_member"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
							Edit single user page
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<!--
	<xsl:template match="MEMBER" mode="t_editmembername">
	Author:		Tom Whitehouse
	Context:      /H2G2/CLUB/POPULATION/TEAM
	Purpose:	Displays the name of the user being edited, as a link
	-->
	<xsl:template match="MEMBER" mode="t_editmembername">
		<xsl:if test="(../@TYPE='MEMBER') and (USER/@USERID=substring-after(/H2G2/PARAMS/PARAM[NAME='s_view']/VALUE, 'U'))">
			<!-- Selecting the member tag corresponding to the the member passed in in PARAMS -->
			<a href="{$root}U{USER/USERID}" xsl:use-attribute-sets="mMEMBER_t_editmembername">
				<xsl:apply-templates select="USER" mode="username"/>
			</a>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="MEMBER" mode="c_changetypeform">
	Author:		Tom Whitehouse
	Context:      /H2G2/CLUB/POPULATION/TEAM
	Purpose:	 Displays the form to change a user's type
	-->
	<xsl:template match="MEMBER" mode="c_changetypeform">
		<xsl:if test="(../@TYPE='MEMBER')">
			<form action="{$root}G{../../../CLUBINFO/@ID}" method="get" xsl:use-attribute-sets="fMEMBER_c_changetypeform">
				<xsl:apply-templates select="." mode="r_changetypeform"/>
			</form>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="MEMBER" mode="t_selectactionform">
	Author:		Tom Whitehouse
	Context:      /H2G2/CLUB/POPULATION/TEAM
	Purpose:	Chooses which form is appropriate for the member being acted upon 
	-->
	<xsl:template match="MEMBER" mode="t_selectactionform">
		<xsl:choose>
			<xsl:when test="USER/USERID = /H2G2/CLUB/POPULATION/TEAM[@TYPE='OWNER']/MEMBER/USER/USERID">
				<input type="hidden" name="userid" value="{USER/USERID}"/>
				<select name="action" xsl:use-attribute-sets="sMEMBER_t_selectactionform">
					<option xsl:use-attribute-sets="oMEMBER_t_selectactionform">
						Select an action
					</option>
					<option value="demoteownertomember" xsl:use-attribute-sets="oMEMBER_t_selectactionform">
						<xsl:copy-of select="$m_demoteownertomember"/>
					</option>
					<option value="removeowner" xsl:use-attribute-sets="oMEMBER_t_selectactionform">
						<xsl:copy-of select="$m_removeowner"/>
					</option>
				</select>
			</xsl:when>
			<xsl:when test="USER/USERID != /H2G2/CLUB/POPULATION/TEAM[@TYPE='OWNER']/MEMBER/USER/USERID">
				<input type="hidden" name="userid" value="{USER/USERID}"/>
				<select name="action" xsl:use-attribute-sets="sMEMBER_t_selectactionform">
					<option xsl:use-attribute-sets="oMEMBER_t_selectactionform">
						Select an action
					</option>
					<option value="removemember" xsl:use-attribute-sets="oMEMBER_t_selectactionform">
						<xsl:copy-of select="$m_removemember"/>
					</option>
				</select>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="MEMBER" mode="t_selectactionsubmit">
	Author:		Tom Whitehouse
	Context:      /H2G2/CLUB/POPULATION/TEAM
	Purpose:	Adds the submit button to change a user's type
	-->
	<xsl:template match="MEMBER" mode="t_selectactionsubmit">
		<input name="doit" xsl:use-attribute-sets="iMEMBER_t_selectactionsubmit"/>
	</xsl:template>
	<!--
	<xsl:template match="MEMBER" mode="c_currenttype">
	Author:		Tom Whitehouse
	Context:	/H2G2/CLUB/POPULATION/TEAM
	Purpose:	Creates the container for displaying a person's current type
	-->
	<xsl:template match="MEMBER" mode="c_currenttype">
		<xsl:if test="(../@TYPE='MEMBER') and (USER/USERID=substring-after(/H2G2/PARAMS/PARAM[NAME='s_view']/VALUE, 'U'))">
			<xsl:apply-templates select="." mode="r_currenttype"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="MEMBER" mode="c_currentrole">
	Author:		Tom Whitehouse
	Context:       /H2G2/CLUB/POPULATION/TEAM
	Purpose:	Creates the container for displaying a person's current role
	-->
	<xsl:template match="MEMBER" mode="c_currentrole">
		<xsl:if test="(../@TYPE='MEMBER') and (USER/USERID=substring-after(/H2G2/PARAMS/PARAM[NAME='s_view']/VALUE, 'U')) and ROLE">
			<xsl:apply-templates select="." mode="r_currentrole"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="MEMBER" mode="r_currenttype">
	Author:		Tom Whitehouse
	Context:       /H2G2/CLUB/POPULATION/TEAM
	Purpose:	Displays the current type of a user  
	-->
	<xsl:template match="MEMBER" mode="r_currenttype">
		<xsl:choose>
			<xsl:when test="USER/@USERID = /H2G2/CLUB/POPULATION/TEAM[@TYPE='OWNER']/MEMBER/USER/USERID">
				<xsl:copy-of select="$m_currenttype_owner"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy-of select="$m_currenttype_member"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="MEMBER" mode="r_currentrole">
	Author:		Tom Whitehouse
	Context:      /H2G2/CLUB/POPULATION/TEAM
	Purpose:	Displays the current role of a user 
	-->
	<xsl:template match="MEMBER" mode="r_currentrole">
		<xsl:value-of select="ROLE"/>
	</xsl:template>
	<!--
	<xsl:template match="CLUBACTIONLIST" mode="t_returntoeditmembers">
	Author:		Tom Whitehouse
	Context:      /H2G2
	Purpose:	 Displays a link to return back to the edit club page
	-->
	<xsl:template match="CLUBACTIONLIST" mode="t_returntoeditmembers">
		<a href="{$root}G{/H2G2/CLUB/CLUBINFO/@ID}?s_view=edit" xsl:use-attribute-sets="mCLUBACTIONLIST_t_returntoeditmembers">
			<xsl:copy-of select="$m_returntoeditmembers"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="CLUBACTIONLIST" mode="t_returntoclub">
	Author:		Tom Whitehouse
	Context:      /H2G2
	Purpose:	 Displays a link to return back to the club being edited
	-->
	<xsl:template match="CLUBACTIONLIST" mode="t_returntoclub">
		<a href="{$root}G{@CLUBID}" xsl:use-attribute-sets="mCLUBACTIONLIST_t_returntoclub">
			<xsl:copy-of select="$m_returntoclublink"/>
		</a>
	</xsl:template>
	<!--xsl:template match="CLUBACTIONLIST" mode="c_recentrequestslist">
		<xsl:if test="CLUBACTION[@RESULT='stored']">
			<xsl:apply-templates select="." mode="r_recentrequestslist"/>
		</xsl:if>
	</xsl:template>
	<xsl:template match="CLUBACTION" mode="c_recentrequest">
		<xsl:if test="@RESULT='stored'">
			<xsl:apply-templates select="." mode="r_recentrequest"/>
		</xsl:if>
	</xsl:template>
	<xsl:template match="CLUBACTION" mode="r_recentrequest">
		
	</xsl:template-->
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
							POPULATION Object
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<!--
	<xsl:template match="POPULATION" mode="c_club">
	Author:		Tom Whitehouse
	Context:      /H2G2/CLUB/POPULATION
	Purpose:	 Calls the container for the POPULATION object
	-->
	<xsl:template match="POPULATION" mode="c_club">
		<xsl:apply-templates select="." mode="r_club"/>
	</xsl:template>
	<!--
	<xsl:template match="POPULATION" mode="c_editmembershiplink">
	Author:		Tom Whitehouse
	Context:      /H2G2/CLUB
	Purpose:	 Creates the container for the 'edit membership details' link
	-->
	<xsl:template match="POPULATION" mode="c_editmembershiplink">
		<xsl:if test="$test_IsEditor or (/H2G2/CLUB/POPULATION/TEAM[@TYPE='OWNER']/MEMBER/USER/USERID = /H2G2/VIEWING-USER/USER/USERID)">
			<xsl:apply-templates select="." mode="r_editmembershiplink"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="POPULATION" mode="r_editmembershiplink">
	Author:		Tom Whitehouse
	Context:      /H2G2/CLUB
	Purpose:	 Creates the 'edit membership details' link
	-->
	<xsl:template match="POPULATION" mode="r_editmembershiplink">
		<a href="{$root}G{../CLUBINFO/@ID}?s_view=editmembers" xsl:use-attribute-sets="mPOPULATION_r_editmembership">
			<xsl:copy-of select="$m_editmembership"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="TEAM" mode="c_club">
	Author:		Tom Whitehouse
	Context:      /H2G2/CLUB/POPULATION/TEAM
	Purpose:	 Calls the container for each of the different types of TEAM objects
	-->
	<xsl:template match="TEAM" mode="c_club">
		<xsl:choose>
			<xsl:when test="@TYPE='OWNER'">
				<xsl:apply-templates select="." mode="owner_club"/>
			</xsl:when>
			<xsl:when test="@TYPE='MEMBER'">
				<xsl:apply-templates select="." mode="member_club"/>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="TEAM" mode="c_more">
	Author:		Tom Whitehouse
	Context:      /H2G2/CLUB/POPULATION/TEAM
	Purpose:	 Calls the container for the more team members link
	-->
	<xsl:template match="TEAM" mode="c_more">
		<xsl:if test="@TYPE='MEMBER'">
			<!-- Only need to apply to members as all members are owners -->
			<xsl:if test="count(/H2G2/CLUB/POPULATION/TEAM[@TYPE='OWNER']/MEMBER) + count(/H2G2/CLUB/POPULATION/TEAM[@TYPE='MEMBER']/MEMBER[not(USER/USERID = /H2G2/CLUB/POPULATION/TEAM[@TYPE='OWNER']/MEMBER/USER/USERID)]) &gt; $max_teammembers">
				<!-- if the number of owners + number of members who aren`t owners is greater than $max_teamnumbers -->
				<xsl:apply-templates select="." mode="r_more"/>
			</xsl:if>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="TEAM" mode="c_more">
	Author:		Tom Whitehouse
	Context:      /H2G2/CLUB/POPULATION/TEAM
	Purpose:	 Calls the container for the more team members link
	-->
	<xsl:template match="TEAM" mode="r_more">
		<a href="{$root}Teamlist?id={@ID}&amp;skip=0&amp;show=10" xsl:use-attribute-sets="mTEAM_r_more">
			<xsl:copy-of select="$m_moreteammembers"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="USER" mode="c_clubowners">
	Author:		Tom Whitehouse
	Context:      /H2G2/CLUB/POPULATION/TEAM/MEMBER/USER
	Purpose:	 Calls the container for the USER object in the owner list
	-->
	<xsl:template match="MEMBER" mode="c_clubowners">
		<xsl:apply-templates select="." mode="r_clubowners"/>
	</xsl:template>
	<!--
	<xsl:template match="USER" mode="c_clubmembers">
	Author:		Tom Whitehouse
	Context:      /H2G2/CLUB/POPULATION/TEAM/MEMBER/USER
	Purpose:	 Calls the container for the USER object in the member list
	-->
	<!--xsl:variable name="ownerids" select="/H2G2/CLUB/POPULATION/TEAM[@TYPE='OWNER']"/-->
	<!-- Use a variable if need  to return to XML page from node-set -->
	<xsl:variable name="max_teammembers">5</xsl:variable>
	<xsl:template match="MEMBER" mode="c_clubmembers">
		<xsl:apply-templates select="." mode="r_clubmembers"/>
	</xsl:template>
	<!--
	<xsl:template match="USER" mode="r_clubowners">
	Author:		Tom Whitehouse
	Context:      /H2G2/CLUB/POPULATION/TEAM/MEMBER/USER
	Purpose:	 Creates the USER link for the owner list
	-->
	<xsl:template match="MEMBER" mode="r_clubowners">
		<a xsl:use-attribute-sets="mUSER_r_clubowners" href="{$root}U{USER/USERID}">
			<xsl:apply-templates select="USER" mode="username"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="USER" mode="r_clubmembers">
	Author:		Tom Whitehouse
	Context:      /H2G2/CLUB/POPULATION/TEAM/MEMBER/USER
	Purpose:	 Creates the USER link for the member list
	-->
	<xsl:template match="MEMBER" mode="r_clubmembers">
		<a xsl:use-attribute-sets="mUSER_r_clubmembers" href="{$root}U{USER/USERID}">
			<xsl:apply-templates select="USER" mode="username"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="POPULATION" mode="t_privatemessagemembers">
	Author:		Tom Whitehouse
	Context:      /H2G2/CLUB/POPULATION
	Purpose:	 Creates themessage all members link
	-->
	<xsl:template match="POPULATION" mode="t_privatemessagemembers">
		<a href="{$root}This functionality isn`t there yet" xsl:use-attribute-sets="mPOPULATION_t_privatemessagemembers">
			<xsl:copy-of select="$m_messagemembers"/>
		</a>
	</xsl:template>
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
							ARTICLE Object
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<!--
	<xsl:template match="ARTICLE" mode="c_club">
	Author:		Tom Whitehouse
	Context:      /H2G2/CLUB/ARTICLE
	Purpose:	 Calls the container for the ARTCLE object
	-->
	<xsl:template match="ARTICLE" mode="c_club">
		<xsl:apply-templates select="." mode="r_club"/>
	</xsl:template>
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
							JOURNAL Object
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<!--
	<xsl:template match="JOURNAL" mode="c_club">
	Author:		Tom Whitehouse
	Context:      /H2G2/CLUB/JOURNAL
	Purpose:	 Calls the container for the JOURNAL object
	-->
	<xsl:template match="JOURNAL" mode="c_club">
		<xsl:apply-templates select="." mode="r_club"/>
	</xsl:template>
	<!--
	<xsl:template match="JOURN	ALPOSTS" mode="c_moreclubjournals">
	Author:		Tom Whitehouse
	Context:      /H2G2/CLUB/JOURNAL/JOURNALPOSTS
	Purpose:	 Calls the 'More journal posts' link object
	-->
	<xsl:variable name="maxclubjournals">5</xsl:variable>
	<xsl:template match="JOURNALPOSTS" mode="c_moreclubjournals">
		<xsl:if test="@MORE=1 or (@TOTALTHREADS > $maxclubjournals)">
			<xsl:apply-templates select="." mode="r_moreclubjournals"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="JOURNALPOSTS" mode="r_moreclubjournals">
	Author:		Tom Whitehouse
	Context:      /H2G2/CLUB/JOURNAL/JOURNALPOSTS
	Purpose:	 Creates the 'More journal posts' link
	-->
	<xsl:template match="JOURNALPOSTS" mode="r_moreclubjournals">
		<a xsl:use-attribute-sets="mJOURNALPOSTS_r_moreclubjournals" href="{$root}MJ{../../PAGE-OWNER/USER/USERID}?Journal={@FORUMID}&amp;show={@COUNT}">
			<xsl:copy-of select="$m_clickmoreclubjournal"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="JOURNALPOSTS" mode="c_addclubjournalentry">
	Author:		Tom Whitehouse
	Context:      /H2G2/CLUB/JOURNAL/JOURNALPOSTS
	Purpose:	 Calls the 'Add entry' link object container
	-->
	<xsl:template match="JOURNALPOSTS" mode="c_addclubjournalentry">
		<xsl:if test="@CANWRITE = 1">
			<xsl:apply-templates select="." mode="r_addclubjournalentry"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="JOURNALPOSTS" mode="r_addclubjournalentry">
	Author:		Tom Whitehouse
	Context:      /H2G2/CLUB/JOURNAL/JOURNALPOSTS
	Purpose:	 Creates the 'Add entry' link 
	-->
	<xsl:template match="JOURNALPOSTS" mode="r_addclubjournalentry">
		<a xsl:use-attribute-sets="mJOURNALPOSTS_r_addclubjournalentry" href="{$root}Addthread?forum={@FORUMID}&amp;action=Club{/H2G2/CLUB/CLUBINFO/@ID}">
			<xsl:copy-of select="$m_clickaddclubjournal"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="JOURNAL" mode="t_clubjournalmessage">
	Author:		Tom Whitehouse
	Context:      /H2G2/CLUB/JOURNAL
	Purpose:	 Creates the journal message text 
	-->
	<xsl:template match="JOURNAL" mode="t_clubjournalmessage">
		<xsl:choose>
			<xsl:when test="JOURNALPOSTS/POST">
				<xsl:choose>
					<xsl:when test="$ownerisviewer = 1">
						<xsl:copy-of select="$m_clubjournalownerfull"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:copy-of select="$m_clubjournalviewerfull"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="not(JOURNALPOSTS/POST) and (JOURNALPOSTS/@CANREAD=0)">
				<xsl:choose>
					<xsl:when test="$ownerisviewer = 1">
						<xsl:copy-of select="$m_clubjournalownercantread"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:copy-of select="$m_clubjournalviewercantread"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="$ownerisviewer = 1">
						<xsl:copy-of select="$m_clubjournalownerempty"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:copy-of select="$m_clubjournalviewerempty"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="POST" mode="c_clubjournalentries">
	Author:		Tom Whitehouse
	Context:      /H2G2/CLUB/JOURNAL/JOURNALPOSTS/POST
	Purpose:	 Calls the POST object container
	-->
	<xsl:template match="POST" mode="c_clubjournalentries">
		<xsl:if test="not(preceding-sibling::POST[number($maxclubjournals)])">
			<xsl:apply-templates select="." mode="r_clubjournalentries"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="LASTREPLY" mode="c_clubjournalreplies">
	Author:		Tom Whitehouse
	Context:      /H2G2/CLUB/JOURNAL/JOURNALPOSTS/POST/LASTREPLY
	Purpose:	 Calls the LASTREPLY object container or 'No replies' message
	-->
	<xsl:template match="LASTREPLY" mode="c_clubjournalreplies">
		<xsl:choose>
			<xsl:when test="@COUNT &gt; 1">
				<xsl:apply-templates select="." mode="r_clubjournalreplies"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="noClubJournalReplies"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="@THREADID" mode="t_clubjournallastreply">
	Author:		Tom Whitehouse
	Context:      /H2G2/CLUB/JOURNAL/JOURNALPOSTS/POST/@THREADID
	Purpose:	 Generates Date last replied to Journal entry as a link 
	-->
	<xsl:template match="@THREADID" mode="t_clubjournallastreply">
		<a xsl:use-attribute-sets="maTHREADID_t_clubjournallastreply" href="{$root}F{../../@FORUMID}?thread={.}&amp;latest=1">
			<xsl:apply-templates select="../LASTREPLY/DATE"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="DATE" mode="t_dateclubjournalposted">
	Author:		Tom Whitehouse
	Context:      /H2G2/CLUB/JOURNAL/JOURNALPOSTS/POST/DATEPOSTED/DATE
	Purpose:	 Creates the date posted date
	-->
	<xsl:template match="DATE" mode="t_dateclubjournalposted">
		<xsl:apply-templates select="."/>
	</xsl:template>
	<!--
	<xsl:template match="TEXT" mode="t_clubjournaltext">
	Author:		Tom Whitehouse
	Context:      /H2G2/CLUB/JOURNAL/JOURNALPOSTS/POST/TEXT
	Purpose:	 Creates the post text
	-->
	<xsl:template match="TEXT" mode="t_clubjournaltext">
		<xsl:apply-templates select="."/>
	</xsl:template>
	<!--
	<xsl:template match="@POSTID" mode="t_discussclubjournalentry">
	Author:		Tom Whitehouse
	Context:      /H2G2/CLUB/JOURNAL/JOURNALPOSTS/POST/@POSTID
	Purpose: Creates the 'discuss this journal entry' link
	-->
	<xsl:template match="@POSTID" mode="t_discussclubjournalentry">
		<a xsl:use-attribute-sets="maPOSTID_t_discussclubjournalentry" href="{$root}AddThread?InReplyTo={.}&amp;action=club{/H2G2/CLUB/CLUBINFO/@ID}">
			<xsl:copy-of select="$m_discussclubjournalentry"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="JOURNALPOSTS/POST">
	Author:		Tom Whitehouse
	Context:      /H2G2/CLUB/JOURNAL/JOURNALPOSTS/POST
	Purpose: Calls the POST object if its not hidden
	-->
	<xsl:template match="JOURNALPOSTS/POST">
		<xsl:if test="not(@HIDDEN &gt; 0)">
			<xsl:apply-templates select="." mode="journal"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="@THREADID" mode="t_clubjournalentriesreplies">
	Author:		Tom Whitehouse
	Context:      /H2G2/CLUB/JOURNAL/JOURNALPOSTS/POST/@THREADID
	Purpose:	Generates link like "2 replies" with HREF like this AddThread?InReplyTo=1899780
	-->
	<xsl:template match="@THREADID" mode="t_clubjournalentriesreplies">
		<a xsl:use-attribute-sets="maTHREADID_t_clubjournalentriesreplies" href="{$root}F{../../@FORUMID}?thread={.}">
			<xsl:choose>
				<xsl:when test="../LASTREPLY[@COUNT &gt; 2]">
					<xsl:value-of select="number(../LASTREPLY/@COUNT)-1"/>&nbsp;
					<xsl:value-of select="$m_clubreplies"/>
				</xsl:when>
				<xsl:otherwise>1&nbsp;<xsl:value-of select="$m_clubreply"/>
				</xsl:otherwise>
			</xsl:choose>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="@THREADID" mode="c_removeclubjournalpost">
	Author:		Tom Whitehouse
	Context:      /H2G2/CLUB/JOURNAL/JOURNALPOSTS/POST/@THREADID
	Purpose:	 Calls the remove post link container
	-->
	<xsl:template match="@THREADID" mode="c_removeclubjournalpost">
		<xsl:if test="$ownerisviewer = 1">
			<xsl:apply-templates select="." mode="r_removeclubjournalpost"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="@THREADID" mode="r_removeclubjournalpost">
	Author:		Tom Whitehouse
	Context:      /H2G2/CLUB/JOURNAL/JOURNALPOSTS/POST/@THREADID
	Purpose:	 Creates the remove post link
	-->
	<xsl:template match="@THREADID" mode="r_removeclubjournalpost">
		<a xsl:use-attribute-sets="maTHREADID_r_removeclubjournalpost" href="{$root}FSB{../../@FORUMID}?thread={.}&amp;cmd=unsubscribejournal&amp;page=normal&amp;desc={$alt_subreturntospace}&amp;return=U{$viewerid}">
			<xsl:copy-of select="$m_removeclubjournal"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="@POSTID" mode="r_editclubpost">
	Author:		Tom Whitehouse
	Context:      /H2G2/CLUB/JOURNAL/JOURNALPOSTS/POST/@POSTID
	Purpose:	 Creates the edit post link
	-->
	<xsl:template match="@POSTID" mode="r_editclubpost">
		<a href="{$root}EditPost?PostID={.}" target="_top" onClick="popupwindow('{$root}EditPost?PostID={.}', 'EditPostPopup', 'status=1,resizable=1,scrollbars=1,width=400,height=450');return false;" xsl:use-attribute-sets="maPOSTID_r_editpost">
			<xsl:copy-of select="$m_editpost"/>
		</a>
	</xsl:template>
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
							CLUBFORUM Object
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<!--
	<xsl:template match="CLUBFORUM" mode="c_club">
	Author:		Tom Whitehouse
	Context:      /H2G2/CLUB/CLUBFORUM
	Purpose:	 Calls the CLUBFORUM object container
	-->
	<xsl:template match="CLUBFORUM" mode="c_club">
		<xsl:apply-templates select="." mode="r_club"/>
	</xsl:template>
	<!--
	<xsl:template match="FORUMTHREADPOSTS" mode="c_club">
	Author:		Tom Whitehouse
	Context:      /H2G2/CLUB/CLUBFORUM/FORUMTHREADPOSTS
	Purpose:	 Calls the FORUMTHREADPOSTS object container
	-->
	<xsl:template match="FORUMTHREADPOSTS" mode="c_club">
		<xsl:apply-templates select="." mode="r_club"/>
	</xsl:template>
	<!--
	<xsl:template match="FORUMTHREADPOSTS" mode="t_clubcommentsintro">
	Author:		Tom Whitehouse
	Context:      /H2G2/CLUB/CLUBFORUM/FORUMTHREADPOSTS
	Purpose:	 Creates the club comments intro text
	-->
	<xsl:template match="FORUMTHREADPOSTS" mode="t_clubcommentsintro">
		<xsl:call-template name="scenarios">
			<xsl:with-param name="ownerfull" select="$m_clubcommentsintro_ownerfull"/>
			<xsl:with-param name="viewerfull" select="$m_clubcommentsintro_viewerfull"/>
			<xsl:with-param name="ownerempty" select="$m_clubcommentsintro_ownerempty"/>
			<xsl:with-param name="viewerempty" select="$m_clubcommentsintro_viewerempty"/>
			<xsl:with-param name="test" select="POST"/>
		</xsl:call-template>
	</xsl:template>
	<!--
	<xsl:template match="FORUMTHREADPOSTS" mode="t_addclubcomment">
	Author:		Tom Whitehouse
	Context:      /H2G2/CLUB/CLUBFORUM/FORUMTHREADPOSTS
	Purpose:	 Creates the correct version of the add a comment link
	-->
	<xsl:template match="FORUMTHREADPOSTS" mode="t_addclubcomment">
		<xsl:choose>
			<xsl:when test="POST">
				<a href="{$root}AddThread?subject=&amp;inreplyto={POST[1]/@POSTID}&amp;action=Club{/H2G2/CLUB/CLUBINFO/@ID}" xsl:use-attribute-sets="mFORUMTHREADPOSTS_t_addclubcomment">
					<xsl:copy-of select="$m_makeclubcommentfull"/>
				</a>
			</xsl:when>
			<xsl:otherwise>
				<a href="{$root}AddThread?forum={@FORUMID}&amp;action=Club{/H2G2/CLUB/CLUBINFO/@ID}" xsl:use-attribute-sets="mFORUMTHREADPOSTS_t_addclubcomment">
					<xsl:copy-of select="$m_makeclubcommentempty"/>
				</a>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="POST" mode="c_clubcomment">
	Author:		Tom Whitehouse
	Context:      /H2G2/CLUB/CLUBFORUM/FORUMTHREADPOSTS/POST
	Purpose:	 Calls the POST object container
	-->
	<xsl:template match="POST" mode="c_clubcomment">
		<xsl:apply-templates select="." mode="r_clubcomment"/>
	</xsl:template>
	<!--
	<xsl:template match="USER" mode="t_clubcommentauthor">
	Author:		Tom Whitehouse
	Context:      /H2G2/CLUB/CLUBFORUM/FORUMTHREADPOSTS/POST/USER
	Purpose:	 Creates the POST author USER link
	-->
	<xsl:template match="USER" mode="t_clubcommentauthor">
		<a href="{$root}U{USERID}" xsl:use-attribute-sets="mUSER_t_clubcommentauthor">
			<xsl:apply-templates select="." mode="username"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="FORUMTHREADS" mode="c_club">
	Author:		Tom Whitehouse
	Context:      /H2G2/CLUB/CLUBFORUM/FORUMTHREADS
	Purpose:	 Calls the correct container for the FORUMTHREADS object
	-->
	<xsl:template match="FORUMTHREADS" mode="c_club">
		<xsl:choose>
			<xsl:when test="THREAD">
				<xsl:apply-templates select="." mode="full_club"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="$registered=1">
						<xsl:apply-templates select="." mode="empty_club"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:copy-of select="$m_clubunregisteredmessage"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="FORUMTHREADS" mode="empty_club">
	Author:		Tom Whitehouse
	Context:      /H2G2/CLUB/CLUBFORUM/FORUMTHREADS
	Purpose:	 Creates the empty FORUMTHREADS message link
	-->
	<xsl:template match="FORUMTHREADS" mode="empty_club">
		<a href="{$root}Addthread?forum={@FORUMID}" xsl:use-attribute-sets="mFORUMTHREADS_empty_club">
			<xsl:copy-of select="$m_emptyclubforummessage"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="THREAD" mode="c_club">
	Author:		Tom Whitehouse
	Context:      /H2G2/CLUB/CLUBFORUM/FORUMTHREADS/THREAD
	Purpose:	 Calls the THREAD object container
	-->
	<xsl:template match="THREAD" mode="c_club">
		<xsl:apply-templates select="." mode="r_article"/>
	</xsl:template>
	<!--
	<xsl:template match="@THREADID" mode="t_clubthreadtitlelink">
	Author:		Tom Whitehouse
	Context:      /H2G2/CLUB/CLUBFORUM/FORUMTHREADS/THREAD/@THREADID
	Purpose:	 Creates the link to the thread using the thread title
	-->
	<xsl:template match="@THREADID" mode="t_clubthreadtitlelink">
		<a xsl:use-attribute-sets="maTHREADID_t_clubthreadtitlelink" href="{$root}F{../@FORUMID}?thread={.}">
			<xsl:apply-templates select="../SUBJECT" mode="nosubject"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="@THREADID" mode="t_clubthreaddatepostedlink">
	Author:		Tom Whitehouse
	Context:      /H2G2/CLUB/CLUBFORUM/FORUMTHREADS/THREAD/@THREADID
	Purpose:	 Creates the DATEPOSTED link
	-->
	<xsl:template match="@THREADID" mode="t_clubthreaddatepostedlink">
		<a xsl:use-attribute-sets="maTHREADID_t_clubthreaddatepostedlink" href="{$root}F{../../@FORUMID}?thread={.}&amp;latest=1">
			<xsl:apply-templates select="../DATEPOSTED"/>
		</a>
	</xsl:template>
	<!--xsl:variable name="m_editclubentrylink">edit article</xsl:variable>
	<xsl:attribute-set name="mARTICLEINFO_c_editclubarticlebutton" use-attribute-sets="clubpagelinks"/>
	<xsl:template match="ARTICLEINFO" mode="c_editclubarticlebutton">
		<xsl:if test="$ownerisviewer=1">
			<xsl:apply-templates select="." mode="r_editclubarticlebutton"/>
		</xsl:if>
	</xsl:template>
	<xsl:template match="ARTICLEINFO" mode="r_editclubarticlebutton">
		<a href="{$root}TypedArticle?submit=edit&amp;h2g2id={H2G2ID}" xsl:use-attribute-sets="mARTICLEINFO_c_editclubarticlebutton">
			<xsl:copy-of select="$m_editclubentrylink"/>
		</a>
	</xsl:template-->
	<!--xsl:template match="CLUB" mode="c_club">
		<xsl:if test="/H2G2/PARAMS/PARAM[NAME='s_show']/VALUE='article'">
			<xsl:apply-templates select="." mode="r_club"/>
		</xsl:if>
	</xsl:template-->
	<xsl:template match="H2G2ID" mode="c_linktoarticle">
		<xsl:apply-templates select="." mode="r_linktoarticle"/>
	</xsl:template>
	<xsl:template match="H2G2ID" mode="r_linktoarticle">
		<a href="{$root}G{/H2G2/CLUB/CLUBINFO/@ID}?s_view=description" xsl:use-attribute-sets="mH2G2ID_r_linktoarticle">
			<xsl:copy-of select="$m_linktoclubarticle"/>
		</a>
	</xsl:template>
	<xsl:template match="CLUB" mode="c_article">
		<xsl:if test="/H2G2/PARAMS/PARAM[NAME='s_view']/VALUE='article'">
			<xsl:apply-templates select="." mode="r_article"/>
		</xsl:if>
	</xsl:template>
	<xsl:template match="CLUBINFO" mode="c_joinclub">
		<xsl:if test="not(/H2G2/VIEWING-USER/USER/USERID = /H2G2/CLUB/POPULATION/TEAM[@TYPE='MEMBER']/MEMBER/USER/USERID) and $registered=1">
			<xsl:apply-templates select="." mode="r_joinclub"/>
		</xsl:if>
	</xsl:template>
	<xsl:template match="CLUBINFO" mode="r_joinclub">
		<a href="{$root}G{@ID}?action=joinmember" xsl:use-attribute-sets="mCLUBINFO_r_joinclub">
			<xsl:copy-of select="$m_joinclub"/>
		</a>
	</xsl:template>
	<xsl:template match="CLUBINFO" mode="c_becomeowner">
		<xsl:if test="/H2G2/VIEWING-USER/USER[(USERID = /H2G2/CLUB/POPULATION/TEAM[@TYPE='MEMBER']/MEMBER/USER/USERID) and not(USERID=/H2G2/CLUB/POPULATION/TEAM[@TYPE='OWNER']/MEMBER/USER/USERID)]">
			<form action="{$root}G{@ID}" method="get">
				<xsl:apply-templates select="." mode="r_becomeowner"/>
			</form>
		</xsl:if>
	</xsl:template>
	<xsl:template match="CLUBINFO" mode="r_becomeowner">
		<a href="{$root}G{@ID}?action=joinowner" xsl:use-attribute-sets="mCLUBINFO_r_becomeowner">
			<xsl:copy-of select="$m_requestownership"/>
		</a>
	</xsl:template>
	<xsl:template match="CLUB" mode="r_clip">
		<a href="{$root}G{CLUBINFO/@ID}?clip=1" xsl:use-attribute-sets="mCLUB_r_clip">
			<xsl:copy-of select="$m_clipissuepage"/>
		</a>
	</xsl:template>
	<xsl:template match="POST" mode="c_complainclubjournal">
		<xsl:if test="@HIDDEN=0">
			<xsl:apply-templates select="." mode="r_complainclubjournal"/>
		</xsl:if>
	</xsl:template>
	<xsl:template match="POST" mode="r_complainclubjournal">
		<a href="{$root}comments/UserComplaintPage?PostID={@POSTID}&amp;s_start=1" target="ComplaintPopup" onClick="popupwindow('comments/UserComplaintPage?PostID={@POSTID}&amp;s_start=1', 'ComplaintPopup', 'status=1,resizable=1,scrollbars=1,width=640,height=480')" xsl:use-attribute-sets="mPOST_r_complainclubjournal">
			<xsl:copy-of select="$m_complainclubjournal"/>
		</a>
	</xsl:template>
	<!--xsl:attribute-set name="iMULTI-REQUIRED_t_closedType">
		<xsl:attribute name="type">radio</xsl:attribute>
		<xsl:attribute name="size">30</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="fMULTI-STAGE_c_form">
		<xsl:attribute name="action"><xsl:value-of select="$root"/>club0</xsl:attribute>
		<xsl:attribute name="method">post</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="iMULTI-REQUIRED_t_clubBodyInput">
		<xsl:attribute name="cols">20</xsl:attribute>
		<xsl:attribute name="rows">5</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="iMULTI-REQUIRED_t_openType">
		<xsl:attribute name="type">radio</xsl:attribute>
		<xsl:attribute name="size">30</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="iMULTI-REQUIRED_t_clubTitleInput">
		<xsl:attribute name="type">text</xsl:attribute>
		<xsl:attribute name="size">30</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="iMULTI-STAGE_t_submit">
		<xsl:attribute name="value">Submit</xsl:attribute>
		<xsl:attribute name="type">submit</xsl:attribute>
	</xsl:attribute-set-->
	<xsl:attribute-set name="iMULTI-STAGE_t_inputtitle">
		<xsl:attribute name="size">60</xsl:attribute>
		<xsl:attribute name="maxlength">255</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="iMULTI-STAGE_t_inputimage">
		<xsl:attribute name="size">60</xsl:attribute>
		<!--xsl:attribute name="maxlength">255</xsl:attribute-->
	</xsl:attribute-set>
	<xsl:attribute-set name="iMULTI-STAGE_t_inputimagetag">
		<xsl:attribute name="size">60</xsl:attribute>
		<xsl:attribute name="maxlength">255</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="tMULTI-STAGE_t_inputbody">
		<xsl:attribute name="rows">20</xsl:attribute>
		<xsl:attribute name="cols">60</xsl:attribute>
	</xsl:attribute-set>
	<!--
	<xsl:template match="MULTI-STAGE" mode="c_club">
	Author:		Tom Whitehouse
	Context:      /H2G2	
	Purpose:	Creates the container for the club creation page
	-->
	<xsl:template match="MULTI-STAGE" mode="c_club">
		<xsl:if test="(/H2G2/MULTI-STAGE[@TYPE = 'CLUB' or @TYPE='CLUB-EDIT' or @TYPE='CLUB-PREVIEW' or @TYPE='CLUB-EDIT-PREVIEW']) and not(/H2G2/MULTI-STAGE/@FINISH='YES')">
			<xsl:apply-templates select="." mode="r_club"/>
		</xsl:if>
	</xsl:template>
	<xsl:template match="@FINISH" mode="c_message">
		<xsl:if test=".='YES'">
			<xsl:apply-templates select="." mode="r_message"/>
		</xsl:if>
	</xsl:template>
	<xsl:variable name="m_clubcreated">Your club has been successfully created</xsl:variable>
	<xsl:variable name="m_clubupdated">Your club has been successfully updated</xsl:variable>
	<xsl:template match="@FINISH" mode="r_message">
		<xsl:choose>
			<xsl:when test="../@TYPE='CLUB-EDIT'">
				<xsl:copy-of select="$m_clubcreated"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy-of select="$m_clubupdated"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="MULTI-STAGE" mode="c_form">
	Author:		Tom Whitehouse
	Context:      /H2G2	
	Purpose:	Creates the container for the club creation form
	-->
	<xsl:template match="MULTI-STAGE" mode="c_form">
		<xsl:choose>
			<xsl:when test="$registered=1">
				<form ENCTYPE="multipart/form-data" action="{$root}G{/H2G2/CLUB/CLUBINFO/@ID}" method="post">
					<!--input type="hidden" name="skin" value="purexml"/-->
					<input type="hidden" name="_msstage" value="{@STAGE}"/>
					<input type="hidden" name="action">
						<xsl:attribute name="value"><xsl:choose><xsl:when test="@TYPE='CLUB-EDIT' or @TYPE='CLUB-EDIT-PREVIEW'">edit</xsl:when><xsl:otherwise>new</xsl:otherwise></xsl:choose></xsl:attribute>
					</input>
					<xsl:if test="@TYPE = 'CLUB' or @TYPE='CLUB-PREVIEW'">
						<input type="hidden" name="s_fromedit" value="1"/>
					</xsl:if>
					<!--xsl:if test="@TYPE='CLUB-EDIT' or @TYPE='CLUB-EDIT-PREVIEW'">
						<input type="hidden" name="id" value="{/H2G2/CLUB/CLUBINFO/@ID}"/>
					</xsl:if-->
					<xsl:apply-templates select="." mode="loggedin_form"/>
				</form>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="." mode="loggedout_form"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="MULTI-STAGE" mode="c_submitclub">
		<xsl:choose>
			<xsl:when test="@TYPE='CLUB-EDIT' or @TYPE='CLUB-EDIT-PREVIEW'">
				<xsl:apply-templates select="." mode="edit_submitclub"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="." mode="create_submitclub"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="MULTI-STAGE" mode="c_previewclubbutton">
		<xsl:apply-templates select="." mode="r_previewclubbutton"/>
	</xsl:template>
	<xsl:attribute-set name="iMULTI-STAGE_r_previewclubbutton">
		<xsl:attribute name="type">submit</xsl:attribute>
		<xsl:attribute name="value">preview</xsl:attribute>
	</xsl:attribute-set>
	<xsl:template match="MULTI-STAGE" mode="r_previewclubbutton">
		<input xsl:use-attribute-sets="iMULTI-STAGE_r_previewclubbutton">
			<xsl:choose>
				<xsl:when test="@TYPE='CLUB-EDIT' or @TYPE='CLUB-EDIT-PREVIEW'">
					<xsl:attribute name="name">editpreview</xsl:attribute>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="name">preview</xsl:attribute>
				</xsl:otherwise>
			</xsl:choose>
		</input>
	</xsl:template>
	<xsl:template match="MULTI-STAGE" mode="c_previewclub">
		<xsl:if test="@TYPE='CLUB-PREVIEW' or @TYPE='CLUB-EDIT-PREVIEW' or /H2G2/ERROR[@CODE='PARSEERROR']">
			<xsl:apply-templates select="." mode="r_previewclub"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="MULTI-STAGE" mode="t_submitclubcreate">
	Author:		Tom Whitehouse
	Context:      /H2G2	
	Purpose:	Creates the submit button for the club creation
	-->
	<xsl:template match="MULTI-STAGE" mode="create_submitclub">
		<input xsl:use-attribute-sets="iMULTI-STAGE_create_submitclub"/>
	</xsl:template>
	<xsl:attribute-set name="iMULTI-STAGE_create_submitclub">
		<xsl:attribute name="value">Create campaign</xsl:attribute>
		<xsl:attribute name="type">submit</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="iMULTI-STAGE_edit_submitclub">
		<xsl:attribute name="value">Save your changes</xsl:attribute>
		<xsl:attribute name="type">submit</xsl:attribute>
	</xsl:attribute-set>
	<xsl:template match="MULTI-STAGE" mode="edit_submitclub">
		<input name="_mssave" xsl:use-attribute-sets="iMULTI-STAGE_edit_submitclub"/>
	</xsl:template>
	<!--
	<xsl:template match="MULTI-STAGE" mode="t_inputtitle">
	Author:		Tom Whitehouse
	Context:      /H2G2	
	Purpose:	 creates the title input field for club creation
	-->
	<xsl:template match="MULTI-STAGE" mode="t_inputtitle">
		<input type="text" name="title" xsl:use-attribute-sets="iMULTI-STAGE_t_inputtitle">
			<xsl:attribute name="value"><xsl:value-of select="MULTI-REQUIRED[@NAME='TITLE']/VALUE-EDITABLE"/></xsl:attribute>
		</input>
	</xsl:template>
	
	<xsl:template match="MULTI-STAGE" mode="t_inputimage">
		<input type="file" name="picture" xsl:use-attribute-sets="iMULTI-STAGE_t_inputimage">
		</input>
	</xsl:template>

	<xsl:template match="MULTI-STAGE" mode="t_inputimagename">
		<input type="hidden" name="picturename">
			<xsl:attribute name="value"><xsl:value-of select="MULTI-ELEMENT[@NAME='PICTURENAME']/VALUE-EDITABLE"/></xsl:attribute>
		</input>
	</xsl:template>
	
	<xsl:template match="MULTI-STAGE" mode="t_inputimagetag">
		<input type="text" name="picturetag" xsl:use-attribute-sets="iMULTI-STAGE_t_inputimagetag">
			<xsl:attribute name="value"><xsl:value-of select="MULTI-ELEMENT[@NAME='PICTURETAG']/VALUE-EDITABLE"/></xsl:attribute>
		</input>
	</xsl:template>
	
	<!--
	<xsl:template match="MULTI-STAGE" mode="t_inputbody">
	Author:		Tom Whitehouse
	Context:      /H2G2	
	Purpose:	 Creates the body textarea field for club creation
	-->
	<xsl:template match="MULTI-STAGE" mode="t_inputbody">
		<textarea name="body" xsl:use-attribute-sets="tMULTI-STAGE_t_inputbody">
			<xsl:value-of select="MULTI-REQUIRED[@NAME='BODY']/VALUE-EDITABLE"/>
		</textarea>
	</xsl:template>
	<!--xsl:template match="MULTI-STAGE" mode="c_club">
		<xsl:if test="(/H2G2/MULTI-STAGE/@TYPE = 'CLUB') and not(/H2G2/MULTI-STAGE/@FINISH='YES')">
			<xsl:apply-templates select="." mode="r_club"/>
		</xsl:if>
	</xsl:template>
	<xsl:template match="MULTI-STAGE" mode="c_form">
		<form xsl:use-attribute-sets="fMULTI-STAGE_c_form">
			<xsl:apply-templates select="." mode="r_form"/>
		</form>
	</xsl:template>
	<xsl:template match="MULTI-REQUIRED" mode="c_body">
		<xsl:if test="@NAME='BODY'">
			<xsl:apply-templates select="." mode="r_body"/>
		</xsl:if>
	</xsl:template>
	<xsl:template match="MULTI-REQUIRED" mode="c_type">
		<xsl:if test="@NAME='OPEN'">
			<xsl:apply-templates select="." mode="r_type"/>
		</xsl:if>
	</xsl:template>
	<xsl:template match="MULTI-REQUIRED" mode="c_title">
		<xsl:if test="@NAME='TITLE'">
			<xsl:apply-templates select="." mode="r_title"/>
		</xsl:if>
	</xsl:template>
	<xsl:template match="MULTI-REQUIRED" mode="t_clubBodyInput">
		<textarea name="body" xsl:use-attribute-sets="iMULTI-REQUIRED_t_clubBodyInput">
			<xsl:value-of select="."/>
		</textarea>
	</xsl:template>
	<xsl:template match="MULTI-REQUIRED" mode="c_clubBodyError">
		<xsl:if test="not(@ERROR='NONE')">
			<xsl:apply-templates select="." mode="r_clubBodyError"/>
		</xsl:if>
	</xsl:template>
	<xsl:template match="MULTI-REQUIRED" mode="t_closedType">
		<input name="open" value="0" xsl:use-attribute-sets="iMULTI-REQUIRED_t_closedType">
			<xsl:if test=".=0">
				<xsl:attribute name="checked">checked</xsl:attribute>
			</xsl:if>
		</input>
	</xsl:template>
	<xsl:template match="MULTI-REQUIRED" mode="t_openType">
		<input name="open" value="1" xsl:use-attribute-sets="iMULTI-REQUIRED_t_openType">
			<xsl:if test=".=1">
				<xsl:attribute name="checked">checked</xsl:attribute>
			</xsl:if>
		</input>
	</xsl:template>
	<xsl:template match="MULTI-REQUIRED" mode="t_clubTitleInput">
		<input name="title" xsl:use-attribute-sets="iMULTI-REQUIRED_t_clubTitleInput" value="{.}"/>
	</xsl:template>
	<xsl:template match="MULTI-REQUIRED" mode="c_clubTitleError">
		<xsl:if test="not(@ERROR='NONE')">
			<xsl:apply-templates select="." mode="r_clubTitleError"/>
		</xsl:if>
	</xsl:template>
	<xsl:template match="MULTI-STAGE" mode="t_submit">
		<input name="submit" xsl:use-attribute-sets="iMULTI-STAGE_t_submit"/>
	</xsl:template-->
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
								MULTI-STAGE Object
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<xsl:template match="SEARCHRESULTS" mode="c_club">
		<xsl:if test="@TYPE='HIERARCHY'">
			<xsl:choose>
				<xsl:when test="HIERARCHYRESULT">
					<xsl:apply-templates select="." mode="results_club"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="." mode="noresults_club"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:template>
	<xsl:template match="SEARCHRESULTS" mode="c_catagoriseform">
		<form method="post" action="{root}Club{//H2G2/CLUB/CLUBINFO/@ID}?action=classify">
			<xsl:apply-templates select="." mode="r_catagoriseform"/>
		</form>
	</xsl:template>
	<xsl:template match="HIERARCHYRESULT" mode="c_result">
		<xsl:if test="NODEID/@USERADD='1'">
			<xsl:apply-templates select="." mode="r_result"/>
		</xsl:if>
	</xsl:template>
	<xsl:template match="HIERARCHYRESULT" mode="t_checkbox">
		<input name="nodeid" value="{NODEID}" xsl:use-attribute-sets="iHIERARCHYRESULT_t_checkbox"/>
	</xsl:template>
	<xsl:template match="SEARCHRESULTS" mode="t_catagorisesubmit">
		<input name="submit" xsl:use-attribute-sets="iSEARCHRESULTS_t_catagorisesubmit"/>
	</xsl:template>
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
									VOTE Object
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<!--
	<xsl:template match="VOTE" mode="c_club">
	Author:		Tom Whitehouse
	Context:      /H2G2/CLUB
	Purpose:	Calls the container for voting section of a club page
	-->
	<xsl:template match="VOTE" mode="c_club">
		<xsl:choose>
			<xsl:when test="@TYPE='CLUB'">
				<xsl:choose>
					<xsl:when test="VOTEID = 0">
						<xsl:apply-templates select="." mode="novote_club"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="." mode="vote_club"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="VOTE" mode="novote_club">
	Author:		Tom Whitehouse
	Context:      /H2G2/CLUB
	Purpose:	Displayed if a club doesn`t have a vote set up
	-->
	<xsl:template match="VOTE" mode="novote_club">
		This club has no vote
	</xsl:template>
	<!--
	<xsl:template match="RESPONSE1" mode="c_club">
	Author:		Tom Whitehouse
	Context:      /H2G2/CLUB/VOTE
	Purpose:	Calls the container for a 'response 1' to a vote
	-->
	<xsl:template match="RESPONSE1" mode="c_club">
		<xsl:apply-templates select="." mode="r_club"/>
	</xsl:template>
	<!--
	<xsl:template match="RESPONSE2" mode="c_club">
	Author:		Tom Whitehouse
	Context:      /H2G2/CLUB/VOTE
	Purpose:	Calls the container for a 'response 2' to a vote
	-->
	<xsl:template match="RESPONSE2" mode="c_club">
		<xsl:apply-templates select="." mode="r_club"/>
	</xsl:template>
	<!--
	<xsl:template match="VOTE" mode="c_selectvote">
	Author:		Tom Whitehouse
	Context:      /H2G2/CLUB
	Purpose:	Calls the container for actually voting
	-->
	<xsl:template match="VOTE" mode="c_selectvote">
		<xsl:apply-templates select="." mode="r_selectvote"/>
	</xsl:template>
	<!--
	<xsl:template match="RESPONSE1" mode="t_radiobutton">
	Author:		Tom Whitehouse
	Context:      /H2G2/CLUB/VOTE
	Purpose:	Radio button for 'response 1'
	-->
	<xsl:template match="RESPONSE1" mode="t_select">
		<a href="{$root}vote?action=add&amp;voteid={../VOTEID}&amp;response=1&amp;type=1" xsl:use-attribute-sets="mRESPONSE1_t_select">
			<xsl:copy-of select="$m_support"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="RESPONSE2" mode="t_select">
	Author:		Tom Whitehouse
	Context:      /H2G2/CLUB/VOTE
	Purpose:	Link for 'response 2'
	-->
	<xsl:template match="RESPONSE2" mode="t_select">
		<a href="{$root}vote?action=add&amp;voteid={../VOTEID}&amp;response=0&amp;type=1" xsl:use-attribute-sets="mRESPONSE1_t_select">
			<xsl:copy-of select="$m_oppose"/>
		</a>
	</xsl:template>
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
									RELATEDMEMBERS Object
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<xsl:template match="CLUBINFO" mode="c_relatedmembers">
		<xsl:choose>
			<xsl:when test="RELATEDMEMBERS/RELATEDARTICLES">
				<xsl:apply-templates select="." mode="full_relatedmembers"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="." mode="empty_relatedmembers"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="RELATEDMEMBERS" mode="c_club">
		<xsl:apply-templates select="." mode="r_club"/>
	</xsl:template>
	<xsl:template match="RELATEDARTICLES" mode="c_club">
		<xsl:apply-templates select="." mode="r_club"/>
	</xsl:template>
	<xsl:template match="RELATEDCLUBS" mode="c_club">
		<xsl:apply-templates select="." mode="r_club"/>
	</xsl:template>
	<xsl:template match="CLUBMEMBER" mode="c_club">
		<xsl:apply-templates select="." mode="r_club"/>
	</xsl:template>
	<xsl:template match="ARTICLEMEMBER" mode="c_club">
		<xsl:if test="not(EXTRAINFO/TYPE/@ID = 3001)">
			<xsl:apply-templates select="." mode="r_club"/>
		</xsl:if>
	</xsl:template>
	<xsl:template match="CLUBMEMBER/NAME" mode="t_subjectlink">
		<a href="{$root}G{../CLUBID}" xsl:use-attribute-sets="mNAME_t_subjectlink">
			<xsl:value-of select="."/>
		</a>
	</xsl:template>
	<xsl:template match="ARTICLEMEMBER/NAME" mode="t_subjectlink">
		<a href="{$root}A{../H2G2ID}" xsl:use-attribute-sets="mNAME_t_subjectlink">
			<xsl:value-of select="."/>
		</a>
	</xsl:template>
	<xsl:template match="CLUB" mode="c_editclub">
		<xsl:if test="$ownerisviewer=1 or $test_IsEditor">
			<xsl:apply-templates select="." mode="r_editclub"/>
		</xsl:if>
	</xsl:template>
	<xsl:variable name="m_editclub">Edit club</xsl:variable>
	<xsl:attribute-set name="mCLUB_r_editclub" use-attribute-sets="clubpagelinks"/>
	<xsl:template match="CLUB" mode="r_editclub">
		<a href="{$root}G{CLUBINFO/@ID}?action=edit&amp;_msxml={$clubfields}" xsl:use-attribute-sets="mCLUB_r_editclub">
			<xsl:copy-of select="$m_editclub"/>
		</a>
	</xsl:template>
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
									CLUBINFO Object
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<xsl:template match="CLUBINFO" mode="c_info">
		<xsl:apply-templates select="." mode="r_info"/>
	</xsl:template>
	<xsl:template match="CLUB" mode="c_tag">
		<xsl:if test="$ownerisviewer=1 or $test_IsEditor">
			<xsl:choose>
				<xsl:when test="/H2G2/CLUB/CLUBINFO/CRUMBTRAILS">
					<xsl:apply-templates select="." mode="edit_tag"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="." mode="add_tag"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:template>
	<xsl:template match="CLUB" mode="edit_tag">
		<a href="{@root}TagItem?tagitemtype=1001&amp;tagitemid={CLUBINFO/@ID}" xsl:use-attribute-sets="mCLUB_edit_tag">
			<xsl:copy-of select="$m_editclubtags"/>
		</a>
	</xsl:template>
	<xsl:template match="CLUB" mode="add_tag">
		<a href="{@root}TagItem?tagitemtype=1001&amp;tagitemid={CLUBINFO/@ID}" xsl:use-attribute-sets="mCLUB_add_tag">
			<xsl:copy-of select="$m_tagclub"/>
		</a>
	</xsl:template>
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
									CRUMBTRAILS Object
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<xsl:template match="CRUMBTRAILS" mode="c_club">
		<xsl:apply-templates select="." mode="r_club"/>
	</xsl:template>
	<xsl:template match="CRUMBTRAIL" mode="c_club">
		<xsl:apply-templates select="." mode="r_club"/>
	</xsl:template>
	<xsl:template match="ANCESTOR" mode="c_club">
		<xsl:apply-templates select="." mode="r_club"/>
	</xsl:template>
	<xsl:template match="NAME" mode="t_club">
		<a href="{$root}C{../NODEID}">
			<xsl:value-of select="."/>
		</a>
	</xsl:template>
	
<xsl:template match="EMAIL-SUBSCRIPTION" mode="c_clubpage">
	<xsl:apply-templates select="." mode="r_clubpage"/>
	</xsl:template>

<xsl:template match="EMAIL-SUBSCRIPTION" mode="c_clubsub">
		<xsl:apply-templates select="." mode="r_clubsub"/>
	</xsl:template>
	
<xsl:template match="EMAIL-SUBSCRIPTION" mode="c_clubsubstatus">
		<xsl:choose>
			<xsl:when test="SUBSCRIPTION[@ITEMTYPE = 2]">
				<xsl:apply-templates select="." mode="on_clubsubstatus"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="." mode="off_clubsubstatus"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
<xsl:template match="EMAIL-SUBSCRIPTION" mode="t_clubsubstatus">
		<xsl:choose>
			<xsl:when test="SUBSCRIPTION/@LISTTYPE = 2">Normal </xsl:when>
			<xsl:otherwise> Instant </xsl:otherwise>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="SUBSCRIPTION/@NOTIFYTYPE = 1">Email</xsl:when>
			<xsl:otherwise>Private Message</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
<xsl:template match="EMAIL-SUBSCRIPTION" mode="t_clubsublink">
		<xsl:choose>
			<xsl:when test="SUBSCRIPTION[@ITEMTYPE = 2]">
				<a href="{$root}EMailAlert?s_manage=1&amp;s_itemtype=3&amp;s_itemid={/H2G2/CLUB/CLUBINFO/@ID}&amp;s_backto=G{/H2G2/CLUB/CLUBINFO/@ID}"><xsl:copy-of select="$m_clubsubmanagelink"/></a>
			</xsl:when>
			<xsl:otherwise>
				<a href="{$root}EMailAlert?s_manage=2&amp;s_itemtype=3&amp;s_itemid={/H2G2/CLUB/CLUBINFO/@ID}&amp;s_backto=G{/H2G2/CLUB/CLUBINFO/@ID}"><xsl:copy-of select="$m_clubsublink"/></a>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>


	
</xsl:stylesheet>
