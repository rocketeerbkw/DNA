<?xml version="1.0" encoding="iso-8859-1"?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<xsl:import href="../../../base/base-newuserspage.xsl"/>
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
									Page - Level  template
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<xsl:template name="NEWUSERS_MAINBODY">
	
	<!-- DEBUG -->
	<xsl:call-template name="TRACE">
		<xsl:with-param name="message">NEWUSERS_MAINBODY</xsl:with-param>
		<xsl:with-param name="pagename">newuserpage.xsl</xsl:with-param>
	</xsl:call-template>
	<!-- DEBUG -->
	
		<table width="100%" cellspacing="0" cellpadding="5" border="0">
			<tr>
				<td>
					<font xsl:use-attribute-sets="mainfont">
						<xsl:copy-of select="$m_NewUsersPageExplanatory"/>
						<xsl:apply-templates select="NEWUSERS-LISTING" mode="c_inputform"/>
						<xsl:apply-templates select="NEWUSERS-LISTING" mode="c_newuserspage"/>
					</font>
				</td>
			</tr>
		</table>
	</xsl:template>
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
					NEWUSERS-LISTING Form Logical Container Template
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<!-- 
	<xsl:template match="NEWUSERS-LISTING" mode="r_inputform">
	Use: Container for the selection form to choose which newusers listing is viewed
	-->
	<xsl:template match="NEWUSERS-LISTING" mode="r_inputform">
		<br/><xsl:apply-templates select="@TIMEUNITS" mode="t_timelist"/>
		<xsl:apply-templates select="@UNITTYPE" mode="t_timelist"/>
		<br/><br/>
		<xsl:apply-templates select="." mode="t_allradio"/>
		<xsl:copy-of select="$m_UsersAll"/>
		<br/>
		<xsl:apply-templates select="." mode="t_haveintroradio"/>
		<xsl:copy-of select="$m_UsersWithIntroductions"/>
		<br/>
		<xsl:apply-templates select="." mode="t_nopostingradio"/>
		<xsl:copy-of select="$m_UsersWithIntroductionsNoPostings"/>
		<br/>
		<xsl:apply-templates select="." mode="t_thissitecheckbox"/>
		<xsl:copy-of select="$m_onlyshowusersfromthissite"/>
		<br/>
		<xsl:apply-templates select="." mode="t_updatedcheckbox"/>
		<xsl:copy-of select="$m_onlyshowuserswhoupdatedpersonalspace"/>
		<br/>
		<xsl:apply-templates select="." mode="t_submitbutton"/>
		<br/><br/>
	</xsl:template>
	<!-- 
	<xsl:attribute-set name="fNEWUSERS-LISTING_c_inputform"/>
	Use: Presentation of the form element
	-->
	<xsl:attribute-set name="fNEWUSERS-LISTING_c_inputform"/>
	<!-- 
	<xsl:attribute-set name="sTIMEUNITS_t_timelist"/>
	Use: Presentation of the time units select element
	-->
	<xsl:attribute-set name="sTIMEUNITS_t_timelist"/>
	<!-- 
	<xsl:attribute-set name="oTIMEUNITS_t_timelist"/>
	Use: Presentation of the time units option elements
	-->
	<xsl:attribute-set name="oTIMEUNITS_t_timelist"/>
	<!-- 
	<xsl:attribute-set name="sUNITTYPE_t_timelist"/>
	Use: Presentation of the unit type select element
	-->
	<xsl:attribute-set name="sUNITTYPE_t_timelist"/>
	<!-- 
	<xsl:attribute-set name="sUNITTYPE_t_timelist"/>
	Use: Presentation of the unit type option elements
	-->
	<xsl:attribute-set name="oUNITTYPE_t_timelist"/>
	<!-- 
	<xsl:attribute-set name="iNEWUSERS-LISTING_t_allradio"/>
	Use: Presentation of the all radio button
	-->
	<xsl:attribute-set name="iNEWUSERS-LISTING_t_allradio"/>
	<!-- 
	<xsl:attribute-set name="iNEWUSERS-LISTING_t_haveintroradio"/>
	Use: Presentation of the have introduction radio button
	-->
	<xsl:attribute-set name="iNEWUSERS-LISTING_t_haveintroradio"/>
	<!-- 
	<xsl:attribute-set name="iNEWUSERS-LISTING_t_nopostingradio"/>
	Use: Presentation of the no postings radio button
	-->
	<xsl:attribute-set name="iNEWUSERS-LISTING_t_nopostingradio"/>
	<!-- 
	<xsl:attribute-set name="iNEWUSERS-LISTING_t_thissitecheckbox"/>
	Use: Presentation of the this site checkbox
	-->
	<xsl:attribute-set name="iNEWUSERS-LISTING_t_thissitecheckbox"/>
	<!-- 
	<xsl:attribute-set name="iNEWUSERS-LISTING_t_updatedcheckbox"/>
	Use: Presentation of the show users who updated personal space checkbox
	-->
	<xsl:attribute-set name="iNEWUSERS-LISTING_t_updatedcheckbox"/>
	<!-- 
	<xsl:attribute-set name="iNEWUSERS-LISTING_t_submitbutton">
	Use: Presentation of the submit button
	-->
	<xsl:attribute-set name="iNEWUSERS-LISTING_t_submitbutton">
		<xsl:attribute name="type">submit</xsl:attribute>
		<xsl:attribute name="value"><xsl:copy-of select="$m_NewUsersPageSubmitButtonText"/></xsl:attribute>
	</xsl:attribute-set>
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
					NEWUSERS-LISTING Logical Container Template
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<!-- 
	<xsl:template match="NEWUSERS-LISTING" mode="r_newuserspage">
	Use: Container for the newusers list itself
	-->
	<xsl:template match="NEWUSERS-LISTING" mode="r_newuserspage">
		<xsl:call-template name="m_NewUsersListingHeading"/>
		<xsl:apply-templates select="USER-LIST" mode="c_newuserspage"/>
	</xsl:template>
	<!-- 
	<xsl:template match="USER-LIST" mode="newusers_newuserspage">
	Use: Container for the user list and the previous/next buttons
	-->
	<xsl:template match="USER-LIST" mode="newusers_newuserspage">
		<xsl:apply-templates select="." mode="c_userlist"/>
		<br/>
		<xsl:apply-templates select="." mode="c_previous"/>
		<xsl:apply-templates select="." mode="c_next"/>
	</xsl:template>
	<!-- 
	<xsl:template match="USER-LIST" mode="nonewusers_newuserspage">
	Use: Explanatory text for an empty list
	-->
	<xsl:template match="USER-LIST" mode="nonewusers_newuserspage">
		<xsl:call-template name="m_newuserslistempty"/>
	</xsl:template>
	<!-- 
	<xsl:template match="USER-LIST" mode="link_previous">
	Use: Previous page link
	-->
	<xsl:template match="USER-LIST" mode="link_previous">
		<xsl:apply-imports/>
		<br/>
	</xsl:template>
	<!-- 
	<xsl:template match="USER-LIST" mode="no_previous">
	Use: No previous page text
	-->
	<xsl:template match="USER-LIST" mode="no_previous">
		<xsl:value-of select="$m_NoOlderRegistrations"/>
		<br/>
	</xsl:template>
	<!-- 
	<xsl:template match="USER-LIST" mode="link_next">
	Use: Next page link
	-->
	<xsl:template match="USER-LIST" mode="link_next">
		<xsl:apply-imports/>
		<br/>
	</xsl:template>
	<!-- 
	<xsl:template match="USER-LIST" mode="no_next">
	Use: No next page text
	-->
	<xsl:template match="USER-LIST" mode="no_next">
		<xsl:value-of select="$m_NoNewerRegistrations"/>
		<br/>
	</xsl:template>
	<!-- 
	<xsl:template match="USER-LIST" mode="newusers_userlist">
	Use: Container for the user list with a NEWUSERS type
	-->
	<xsl:template match="USER-LIST" mode="newusers_userlist">
		<table width="100%" cellspacing="0" cellpadding="0" border="0"><xsl:apply-templates select="USER" mode="c_newusers"/></table>
		<br/>
		<xsl:copy-of select="$m_userhasmastheadflag"/>
		<xsl:copy-of select="$m_userhasmastheadfootnote"/>
		<br/>
		<xsl:copy-of select="$m_userhasmastheadflag"/>
		<xsl:value-of select="$m_usersintropostedtoflag"/>
		<xsl:value-of select="$m_usersintropostedtofootnote"/>
		<br/>
		</xsl:template>
	<!-- 
	<xsl:template match="USER" mode="r_newusers">
	Use: Presentation of each user in the list with a NEWUSERS type
	-->
	<xsl:template match="USER" mode="r_newusers">
<tr valign="top">		<td><font xsl:use-attribute-sets="mainfont"><xsl:apply-templates select="." mode="c_introflag"/>
		<xsl:apply-templates select="." mode="c_postingflag"/>
		<xsl:apply-templates select="USERNAME" mode="t_newusers"/></font></td>
		<td width="100"><font xsl:use-attribute-sets="mainfont"><xsl:apply-templates select="DATE-JOINED/DATE"/></font>
		</td></tr>
	</xsl:template>
	<!-- 
	<xsl:template match="USER" mode="r_introflag">
	Use: Presentation of the 'Member has written an Introduction' flag
	-->
	<xsl:template match="USER" mode="r_introflag">
		<xsl:value-of select="$m_userhasmastheadflag"/>
	</xsl:template>
	<!-- 
	<xsl:template match="USER" mode="r_postingflag">
	Use: Presentation of the 'Member's Introduction has had at least one Posting' flag
	-->
	<xsl:template match="USER" mode="r_postingflag">
		<xsl:value-of select="$m_usersintropostedtoflag"/>
	</xsl:template>
	<!-- 
	<xsl:template match="USER-LIST" mode="subeditors_userlist">
	Use: Container for the user list with a SUBEDITORS type
	-->
	<xsl:template match="USER-LIST" mode="subeditors_userlist">
		<xsl:apply-templates select="USER" mode="c_subeditors"/>
	</xsl:template>
	<!-- 
	<xsl:template match="USER" mode="r_subeditors">
	Use: Presentation of each user in the list with a SUBEDITORS type
	-->
	<xsl:template match="USER" mode="r_subeditors">
		<xsl:apply-templates select="USERNAME" mode="t_newusers"/>
		<xsl:value-of select="ALLOCATIONS"/>
		<br/>
	</xsl:template>
	<!-- 
	<xsl:template match="USER-LIST" mode="default_userlist">
	Use: Container for the default user list
	-->
	<xsl:template match="USER-LIST" mode="default_userlist">
		<xsl:apply-templates select="USER" mode="c_default"/>
	</xsl:template>
	<!-- 
	<xsl:template match="USER" mode="r_default">
	Use: Presentation of each user in the default list
	-->
	<xsl:template match="USER" mode="r_default">
		<xsl:apply-templates select="USERNAME" mode="t_newusers"/>
		<br/>
	</xsl:template>
</xsl:stylesheet>
