<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<!--
	<xsl:template name="USERMYCLUBS_HEADER">
	Author:		Andy Harris
	Context:      H2G2
	Purpose:	 Creates the title for the page which sits in the html header
	-->
	<xsl:template name="USERMYCLUBS_HEADER">
		<xsl:apply-templates mode="header" select=".">
			<xsl:with-param name="title">
				<xsl:value-of select="$m_pagetitlestart"/>
				<xsl:value-of select="$m_usermyclubs"/>
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>
	<!--
	<xsl:template name="USERMYCLUBS_SUBJECT">
	Author:		Andy Harris
	Context:      H2G2
	Purpose:	 Creates the text for the subject
	-->
	<xsl:template name="USERMYCLUBS_SUBJECT">
		<xsl:call-template name="SUBJECTHEADER">
			<xsl:with-param name="text">
				<xsl:value-of select="$m_usermyclubs"/>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<!--
	<xsl:template match="CLUBSSUMMARY" mode="c_umcpage">
	Author:		Andy Harris
	Context:      H2G2/USERMYCLUBS/CLUBSSUMMARY
	Purpose:	 Calls the container for the CLUBSSUMMARY object
	-->
	<xsl:template match="CLUBSSUMMARY" mode="c_umcpage">
		<xsl:apply-templates select="." mode="r_umcpage"/>
	</xsl:template>
	<!--
	<xsl:template match="CLUB" mode="c_clubsummary">
	Author:		Andy Harris
	Context:      H2G2/USERMYCLUBS/CLUBSSUMMARY/CLUB
	Purpose:	 Calls the container for the CLUB object
	-->
	<xsl:template match="CLUB" mode="c_clubsummary">
		<xsl:apply-templates select="." mode="r_clubsummary"/>
	</xsl:template>
	<!--
	<xsl:template match="NAME" mode="t_clubsummary">
	Author:		Andy Harris
	Context:      H2G2/USERMYCLUBS/CLUBSSUMMARY/CLUB/NAME
	Purpose:	 Creates the NAME link for the club
	-->
	<xsl:template match="NAME" mode="t_clubsummary">
		<a href="{$root}G{../@ID}" xsl:use-attribute-sets="mNAME_t_clubsummary">
			<xsl:value-of select="."/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="ACTIVITY" mode="t_clubsummary">
	Author:		Andy Harris
	Context:      H2G2/USERMYCLUBS/CLUBSSUMMARY/CLUB/ACTIVITY
	Purpose:	 Creates the correct text for the state of activity for the club
	-->
	<xsl:template match="ACTIVITY" mode="t_clubsummary">
		<xsl:choose>
			<xsl:when test=". != 0">
				<a href="#{../NAME}">
					<xsl:value-of select="$m_newactivity"/>
				</a>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$m_nonewactivity"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="CLUBREVIEWS" mode="c_umcpage">
	Author:		Andy Harris
	Context:      H2G2/USERMYCLUBS/CLUBREVIEWS
	Purpose:	 Calls the container for the CLUBREVIEWS object
	-->
	<xsl:template match="CLUBREVIEWS" mode="c_umcpage">
		<xsl:apply-templates select="." mode="r_umcpage"/>
	</xsl:template>
	<!--
	<xsl:template match="CLUB" mode="c_clubreview">
	Author:		Andy Harris
	Context:      H2G2/USERMYCLUBS/CLUBREVIEWS/CLUB
	Purpose:	 Calls the container for the CLUB object
	-->
	<xsl:template match="CLUB" mode="c_clubreview">
		<xsl:apply-templates select="." mode="r_clubreview"/>
	</xsl:template>
	<!--
	<xsl:template match="NAME" mode="t_clubreview">
	Author:		Andy Harris
	Context:      H2G2/USERMYCLUBS/CLUBREVIEWS/CLUB/NAME
	Purpose:	 Creates the NAME link
	-->
	<xsl:template match="NAME" mode="t_clubreview">
		<a name="{.}"/>
		<xsl:value-of select="."/>
	</xsl:template>
	<!--
	<xsl:template match="MEMBERS" mode="c_clubreview">
	Author:		Andy Harris
	Context:      H2G2/USERMYCLUBS/CLUBREVIEWS/CLUB/MEMBERS
	Purpose:	 Calls the container for the MEMBERS object
	-->
	<xsl:template match="MEMBERS" mode="c_clubreview">
		<xsl:apply-templates select="." mode="r_clubreview"/>
	</xsl:template>
	<!--
	<xsl:template match="NEW" mode="c_members">
	Author:		Andy Harris
	Context:      H2G2/USERMYCLUBS/CLUBREVIEWS/CLUB/MEMBERS/NEW
	Purpose:	 Calls the container for the new members object if there are any
	-->
	<xsl:template match="NEW" mode="c_members">
		<xsl:if test=". != 0">
			<xsl:apply-templates select="." mode="r_members"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="ALL" mode="c_members">
	Author:		Andy Harris
	Context:      H2G2/USERMYCLUBS/CLUBREVIEWS/CLUB/MEMBERS/ALL
	Purpose:	 Calls the container for the all members object 
	-->
	<xsl:template match="ALL" mode="c_members">
		<xsl:apply-templates select="." mode="r_members"/>
	</xsl:template>
	<!--
	<xsl:template match="COMMENTS" mode="c_clubreview">
	Author:		Andy Harris
	Context:      H2G2/USERMYCLUBS/CLUBREVIEWS/CLUB/COMMENTS
	Purpose:	 Calls the container for the comments object 
	-->
	<xsl:template match="COMMENTS" mode="c_clubreview">
		<xsl:apply-templates select="." mode="r_clubreview"/>
	</xsl:template>
	<!--
	<xsl:template match="NEW" mode="c_comments">
	Author:		Andy Harris
	Context:      H2G2/USERMYCLUBS/CLUBREVIEWS/CLUB/COMMENTS/NEW
	Purpose:	 Calss the container for the new comments object  if there are any
	-->
	<xsl:template match="NEW" mode="c_comments">
		<xsl:if test=". != 0">
			<xsl:apply-templates select="." mode="r_comments"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="ALL" mode="c_comments">
	Author:		Andy Harris
	Context:      H2G2/USERMYCLUBS/CLUBREVIEWS/CLUB/COMMENTS/ALL
	Purpose:	 Calls the container for the all comments object
	-->
	<xsl:template match="ALL" mode="c_comments">
		<xsl:apply-templates select="." mode="r_comments"/>
	</xsl:template>
	<!--
	<xsl:template match="MEMBERSHIPSTATUS" mode="c_clubreview">
	Author:		Andy Harris
	Context:      H2G2/USERMYCLUBS/CLUBREVIEWS/CLUB/MEMBERSHIPSTATUS
	Purpose:	 Calls the container for the users membership status object
	-->
	<xsl:template match="MEMBERSHIPSTATUS" mode="c_clubreview">
		<xsl:apply-templates select="." mode="r_clubreview"/>
	</xsl:template>
	<!--
	<xsl:template match="MEMBERSHIPSTATUS" mode="c_changestatus">
	Author:		Andy Harris
	Context:      H2G2/USERMYCLUBS/CLUBREVIEWS/CLUB/MEMBERSHIPSTATUS
	Purpose:	 Calls the container for the change membership status object
	-->
	<xsl:template match="MEMBERSHIPSTATUS" mode="c_changestatus">
		<form action="{$root}G{../@ID}" xsl:use-attribute-set="fMEMBERSHIPSTATUS_c_changestatus">
			<input type="hidden" name="userid" value="{/H2G2/VIEWING-USER/USER/USERID}"/>
			<xsl:apply-templates select="." mode="r_changestatus"/>
		</form>
	</xsl:template>
	<!--
	<xsl:template match="MEMBERSHIPSTATUS" mode="r_changestatus">
	Author:		Andy Harris
	Context:      H2G2/USERMYCLUBS/CLUBREVIEWS/CLUB/MEMBERSHIPSTATUS
	Purpose:	 Creates the link to change the users status
	-->
	<xsl:template match="MEMBERSHIPSTATUS" mode="t_changestatuslist">
		<xsl:choose>
			<xsl:when test=". = 'Owner'">
				<select name="action" xsl:use-attribute-set="sMEMBERSHIPSTATUS_t_changestatuslist">
					<!--option value="joinmember" xsl:use-attribute-set="oMEMBERSHIPSTATUS_t_changestatuslist"></option-->
					<option value="ownerresignsmember" xsl:use-attribute-set="oMEMBERSHIPSTATUS_t_changestatuslist">Become a member</option>
					<option value="ownerresignscompletely" xsl:use-attribute-set="oMEMBERSHIPSTATUS_t_changestatuslist">Leave club</option>
				</select>
			</xsl:when>
			<xsl:otherwise>
				<select name="action">
					<option value="joinowner" xsl:use-attribute-set="oMEMBERSHIPSTATUS_t_changestatuslist">Request to become owner</option>
					<option value="memberresigns" xsl:use-attribute-set="oMEMBERSHIPSTATUS_t_changestatuslist">Leave club</option>
				</select>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="MEMBERSHIPSTATUS" mode="r_changestatus">
	Author:		Andy Harris
	Context:      H2G2/USERMYCLUBS/CLUBREVIEWS/CLUB/MEMBERSHIPSTATUS
	Purpose:	 Creates the link to change the users status
	-->
	<xsl:template match="MEMBERSHIPSTATUS" mode="t_changestatussubmit">
		<input type="submit" xsl:use-attribute-sets="iMEMBERSHIPSTATUS_t_changestatussubmit">
			<xsl:attribute name="value"><xsl:value-of select="$m_changestatus"/></xsl:attribute>
		</input>
	</xsl:template>
	<xsl:attribute-set name="fMEMBERSHIPSTATUS_c_changestatus"/>
	<xsl:attribute-set name="sMEMBERSHIPSTATUS_t_changestatuslist"/>
	<xsl:attribute-set name="oMEMBERSHIPSTATUS_t_changestatuslist"/>
	<xsl:attribute-set name="iMEMBERSHIPSTATUS_t_changestatussubmit"/>
	<!--
	<xsl:template match="CURRENTROLE" mode="c_clubreview">
	Author:		Andy Harris
	Context:      H2G2/USERMYCLUBS/CLUBREVIEWS/CLUB/CURRENTROLE
	Purpose:	 Calls the container for the user's current role object
	-->
	<xsl:template match="CURRENTROLE" mode="c_clubreview">
		<xsl:apply-templates select="." mode="r_clubreview"/>
	</xsl:template>
	<!--
	<xsl:template match="CURRENTROLE" mode="c_changerole">
	Author:		Andy Harris
	Context:      H2G2/USERMYCLUBS/CLUBREVIEWS/CLUB/CURRENTROLE
	Purpose:	 Creates the form for the user to change their current role
	-->
	<xsl:template match="CURRENTROLE" mode="c_changerole">
		<form name="change_role" method="post" action="{$root}umc" xsl:use-attribute-sets="fCURRENTROLE_c_changerole">
			<input type="hidden" name="clubid" value="{../@ID}"/>
			<xsl:apply-templates select="." mode="r_changerole"/>
		</form>
	</xsl:template>
	<!--
	<xsl:template match="CURRENTROLE" mode="t_inputrole">
	Author:		Andy Harris
	Context:      H2G2/USERMYCLUBS/CLUBREVIEWS/CLUB/CURRENTROLE
	Purpose:	 Creates the input element for the user to change their current role
	-->
	<xsl:template match="CURRENTROLE" mode="t_inputrole">
		<input name="rolechange" xsl:use-attribute-set="iCURRENTROLE_t_inputrole"/>
	</xsl:template>
	<!--
	<xsl:template match="CURRENTROLE" mode="t_submit">
	Author:		Andy Harris
	Context:      H2G2/USERMYCLUBS/CLUBREVIEWS/CLUB/CURRENTROLE
	Purpose:	 Creates the submit element for the user to change their current role
	-->
	<xsl:template match="CURRENTROLE" mode="t_submit">
		<input value="Submit" xsl:use-attribute-sets="iCURRENTROLE_t_submit"/>
	</xsl:template>
	<!--
	<xsl:template match="ACTIONS" mode="c_clubreview">
	Author:		Andy Harris
	Context:      H2G2/USERMYCLUBS/CLUBREVIEWS/CLUB/ACTIONS
	Purpose:	 Calls the container for the actions
	-->
	<xsl:template match="ACTIONS" mode="c_clubreview">
		<xsl:apply-templates select="." mode="r_clubreview"/>
	</xsl:template>
	<!--
	<xsl:template match="PENDING" mode="c_actions">
	Author:		Andy Harris
	Context:      H2G2/USERMYCLUBS/CLUBREVIEWS/CLUB/ACTIONS/PENDING
	Purpose:	 Calls the container for the pending actions if there are any
	-->
	<xsl:template match="PENDING" mode="c_actions">
		<xsl:if test="ACTION">
			<xsl:apply-templates select="." mode="r_actions"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="COMPLETED" mode="c_actions">
	Author:		Andy Harris
	Context:      H2G2/USERMYCLUBS/CLUBREVIEWS/CLUB/ACTIONS/COMPLETED
	Purpose:	 Calls the container for the completed actions if there are any
	-->
	<xsl:template match="COMPLETED" mode="c_actions">
		<xsl:if test="ACTION">
			<xsl:apply-templates select="." mode="r_actions"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="ACTION" mode="c_actions">
	Author:		Andy Harris
	Context:      H2G2/USERMYCLUBS/CLUBREVIEWS/CLUB/ACTIONS/COMPLETED/ACTION or H2G2/USERMYCLUBS/CLUBREVIEWS/CLUB/ACTIONS/PENDING/ACTION
	Purpose:	 Calls the container for the action object
	-->
	<xsl:template match="ACTION" mode="c_actions">
		<xsl:apply-templates select="." mode="r_actions"/>
	</xsl:template>
	<!--
	<xsl:template match="OWNER" mode="t_actions">
	Author:		Andy Harris
	Context:      ../ACTION/OWNER
	Purpose:	 Creates the link to the owner of the action
	-->
	<xsl:template match="OWNER" mode="t_actions">
		<a href="{$root}U{../OWNERID}" xsl:use-attribute-sets="mOWNER_t_actions">
			<xsl:value-of select="."/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="POSTDATE" mode="t_actions">
	Author:		Andy Harris
	Context:      ../ACTION/POSTDATE
	Purpose:	 Creates the date posted text
	-->
	<xsl:template match="POSTDATE" mode="t_actions">
		<xsl:value-of select="."/>
	</xsl:template>
	<!--
	<xsl:template match="CLUB" mode="t_editclub">
	Author:		Andy Harris
	Context:      H2G2/USERMYCLUBS/CLUBREVIEWS/CLUB
	Purpose:	 Creates the edit club link
	-->
	<xsl:template match="CLUB" mode="t_editclub">
		<a href="{$root}G{@ID}?s_view=edit" xsl:use-attribute-sets="mCLUB_t_editclub">
			<xsl:value-of select="$m_editclublink"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="CLUB" mode="t_viewclub">
	Author:		Andy Harris
	Context:      H2G2/USERMYCLUBS/CLUBREVIEWS/CLUB
	Purpose:	 Creates the view club link
	-->
	<xsl:template match="CLUB" mode="t_viewclub">
		<a href="{$root}G{@ID}" xsl:use-attribute-sets="mCLUB_t_viewclub">
			<xsl:value-of select="$m_viewclublink"/>
		</a>
	</xsl:template>
</xsl:stylesheet>
