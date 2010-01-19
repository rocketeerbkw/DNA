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
	<xsl:with-param name="message">NEWUSERS_MAINBODY test variable = <xsl:value-of select="$current_article_type" /></xsl:with-param>
	<xsl:with-param name="pagename">newuserspage.xsl</xsl:with-param>
	</xsl:call-template>
	<!-- DEBUG -->


		<div class="generic-c">
			<xsl:element name="{$text.subheading}" use-attribute-sets="text.subheading">
				<strong>new members</strong>
			</xsl:element>
		</div>
		<br />
		<table cellpadding="0" cellspacing="0" border="0">
		<tr>
	<!-- * column 1 -->
		<xsl:element name="td" use-attribute-sets="column.1">
			<div class="myspace-b">
			<!-- only see if editor -->
			  <xsl:if test="$test_IsEditor">
			  	<xsl:element name="{$text.base}" use-attribute-sets="text.base">	
				<xsl:copy-of select="$m_NewUsersPageExplanatory"/>
				</xsl:element>
				<xsl:apply-templates select="NEWUSERS-LISTING" mode="c_inputform"/>
			  </xsl:if>
				<!-- for members and editors -->
				<xsl:apply-templates select="NEWUSERS-LISTING" mode="c_newuserspage"/>
			</div>

		</xsl:element>
		<xsl:element name="td" use-attribute-sets="column.3"><xsl:element name="img" use-attribute-sets="column.spacer.3" /></xsl:element>
	<!-- * column 2 -->
		<xsl:element name="td" use-attribute-sets="column.2">
		<div class="morepost-h">
			<div class="myspace-r">
				<xsl:element name="{$text.subheading}" use-attribute-sets="text.subheading">
					<strong class="white">key</strong>
				</xsl:element>
				<br />
				<xsl:element name="{$text.base}" use-attribute-sets="text.base">
					<xsl:copy-of select="$m_userhasmastheadflag"/>	
					<xsl:copy-of select="$m_userhasmastheadfootnote"/>
					<br/>
					<xsl:copy-of select="$m_userhasmastheadflag"/>
					<xsl:copy-of select="$m_usersintropostedtoflag"/>
					<xsl:value-of select="$m_usersintropostedtofootnote"/>
				</xsl:element>
			</div>
		</div>
		<br />
		<div class="morepost-h">
			<div class="myspace-r">
				<xsl:copy-of select="$myspace.tips" />&nbsp;
				<xsl:element name="{$text.subheading}" use-attribute-sets="text.subheading">
					<strong class="white">hints and tips</strong>
				</xsl:element>
			</div>
			<xsl:copy-of select="$tips_newusers" />
		</div><br />

		</xsl:element>
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
	<xsl:element name="{$text.base}" use-attribute-sets="text.base">
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
		
		<br/><xsl:apply-templates select="." mode="t_submitbutton"/>
		<br/><br/>
		</xsl:element>
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
	
		<xsl:element name="{$text.heading}" use-attribute-sets="text.heading">
			<strong>our new my science fiction life members</strong>
		</xsl:element><br />
		<xsl:element name="{$text.base}" use-attribute-sets="text.base">
		<xsl:call-template name="m_NewUsersListingHeading"/>
		</xsl:element>
		<xsl:apply-templates select="USER-LIST" mode="c_newuserspage"/>
	</xsl:template>


	<!-- 
	<xsl:template match="USER-LIST" mode="newusers_newuserspage">
	Use: Container for the user list and the previous/next buttons
	-->
	<xsl:template match="USER-LIST" mode="newusers_newuserspage">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
		<td><xsl:apply-templates select="." mode="c_previous"/></td>		
		<td align="right"><xsl:apply-templates select="." mode="c_next"/></td>
		</tr>
		</table>
		<br/>
		<xsl:apply-templates select="." mode="c_userlist"/>
		<br/>
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
		<td><xsl:apply-templates select="." mode="c_previous"/></td>		
		<td align="right"><xsl:apply-templates select="." mode="c_next"/></td>
		</tr>
		</table>
	</xsl:template>
	<!-- 
	<xsl:template match="USER-LIST" mode="nonewusers_newuserspage">
	Use: Explanatory text for an empty list
	-->
	<xsl:template match="USER-LIST" mode="nonewusers_newuserspage">
		<xsl:element name="{$text.base}" use-attribute-sets="text.base">
		<xsl:call-template name="m_newuserslistempty"/>
		</xsl:element>
	</xsl:template>
	<!-- 
	<xsl:template match="USER-LIST" mode="link_previous">
	Use: Previous page link
	-->
	<xsl:template match="USER-LIST" mode="link_previous">
	<xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall">
		<xsl:copy-of select="$arrow.left" /><xsl:text>  </xsl:text><xsl:apply-imports/>
	</xsl:element>
	</xsl:template>
	<!-- 
	<xsl:template match="USER-LIST" mode="no_previous">
	Use: No previous page text
	-->
	<xsl:template match="USER-LIST" mode="no_previous">
	<xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall">
	<xsl:value-of select="$m_NoOlderRegistrations"/> 
	</xsl:element>	
	</xsl:template>
	<!-- 
	<xsl:template match="USER-LIST" mode="link_next">
	Use: Next page link
	-->
	<xsl:template match="USER-LIST" mode="link_next">
	<xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall">
		<xsl:copy-of select="$arrow.right" /> <xsl:apply-imports/>
	</xsl:element>
	</xsl:template>
	<!-- 
	<xsl:template match="USER-LIST" mode="no_next">
	Use: No next page text
	-->
	<xsl:template match="USER-LIST" mode="no_next">
	<xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall">
		<xsl:value-of select="$m_NoNewerRegistrations"/>
	</xsl:element>
	</xsl:template>
	<!-- 
	<xsl:template match="USER-LIST" mode="newusers_userlist">
	Use: Container for the user list with a NEWUSERS type
	-->
	<xsl:template match="USER-LIST" mode="newusers_userlist">
		<xsl:apply-templates select="USER" mode="c_newusers"/>
	</xsl:template>
	<!-- 
	<xsl:template match="USER" mode="r_newusers">
	Use: Presentation of each user in the list with a NEWUSERS type
	-->
	<xsl:template match="USER" mode="r_newusers">
		<div>
			<xsl:attribute name="class">
			<xsl:choose>
			<xsl:when test="count(preceding-sibling::USER) mod 2 = 0">myspace-e-1</xsl:when><!-- alternate colours, MC -->
			<xsl:otherwise>myspace-e-2</xsl:otherwise>
			</xsl:choose>
			</xsl:attribute>
			<table cellspacing="0" cellpadding="0" border="0" width="395">
			<tr>
			<td rowspan="2" width="25" class="myspace-e-3">&nbsp;</td>
			<td class="brown">
			<xsl:element name="{$text.base}" use-attribute-sets="text.base">
				<strong><xsl:apply-templates select="USERNAME" mode="t_newusers"/></strong>
			</xsl:element>
			</td>
			<td align="right">
				<xsl:apply-templates select="." mode="c_introflag"/>
				<xsl:apply-templates select="." mode="c_postingflag"/>
			</td>
			</tr><tr>
			<td colspan="2" class="orange">
			<xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall">
				member since: <xsl:apply-templates select="DATE-JOINED/DATE"/>
			</xsl:element>
			</td>
			</tr>
			</table>
		</div>

	
	</xsl:template>
	<!-- 
	<xsl:template match="USER" mode="r_introflag">
	Use: Presentation of the 'Member has written an Introduction' flag
	-->
	<xsl:template match="USER" mode="r_introflag">
		<xsl:copy-of select="$member.has_intro.white"/>
	</xsl:template>
	<!-- 
	<xsl:template match="USER" mode="r_postingflag">
	Use: Presentation of the 'Member's Introduction has had at least one Posting' flag
	-->
	<xsl:template match="USER" mode="r_postingflag">
		<xsl:copy-of select="$member.left_message.white"/>
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
