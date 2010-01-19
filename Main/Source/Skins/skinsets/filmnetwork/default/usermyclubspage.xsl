<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
	<!ENTITY space "<xsl:text xmlns:xsl='http://www.w3.org/1999/XSL/Transform'> </xsl:text>">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<xsl:import href="../../../base/base-usermyclubspage.xsl"/>
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
									Page - Level  template
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<xsl:template name="USERMYCLUBS_MAINBODY">
		<xsl:apply-templates select="USERMYCLUBS/CLUBSSUMMARY" mode="c_umcpage"/>
		<xsl:apply-templates select="USERMYCLUBS/CLUBREVIEWS" mode="c_umcpage"/>
	</xsl:template>
	<!--
	<xsl:template match="CLUBSSUMMARY" mode="r_umcpage">
	Use: Display of the summary list of the user's clubs
	 -->
	<xsl:template match="CLUBSSUMMARY" mode="r_umcpage">
		<b>
			<xsl:value-of select="$m_clubsummarytitle"/>
		</b>
		<br/>
		<br/>
		<xsl:apply-templates select="CLUB" mode="c_clubsummary"/>
		----------------------------------------------------
		<br/>
		----------------------------------------------------
		<br/>
		<br/>
	</xsl:template>
	<!--
	<xsl:template match="CLUB" mode="r_clubsummary">
	Use: Display of the summary of the club in the list
	 -->
	<xsl:template match="CLUB" mode="r_clubsummary">
		<xsl:apply-templates select="NAME" mode="t_clubsummary"/>
		<br/>
		<xsl:apply-templates select="ACTIVITY" mode="t_clubsummary"/>
		<br/>
		<br/>
	</xsl:template>
	<!--
	<xsl:template match="CLUBREVIEWS" mode="c_umcpage">
	Use: Display of the club reviews section of the page
	 -->
	<xsl:template match="CLUBREVIEWS" mode="c_umcpage">
		<b>
			<xsl:value-of select="$m_clubreviewtitle"/>
		</b>
		<br/>
		<br/>
		<xsl:apply-templates select="CLUB" mode="c_clubreview"/>
	</xsl:template>
	<!--
	<xsl:template match="CLUB" mode="r_clubreview">
	Use: Display of the individual clubs within the review section of the page
	 -->
	<xsl:template match="CLUB" mode="r_clubreview">
		<b>
			<xsl:apply-templates select="NAME" mode="t_clubreview"/>
		</b>
		<br/>
		<xsl:apply-templates select="MEMBERS" mode="c_clubreview"/>
		<br/>
		<xsl:apply-templates select="COMMENTS" mode="c_clubreview"/>
		<br/>
		<xsl:apply-templates select="MEMBERSHIPSTATUS" mode="c_clubreview"/>
		<br/>
		<xsl:apply-templates select="CURRENTROLE" mode="c_clubreview"/>
		<br/>
		<xsl:apply-templates select="ACTIONS" mode="c_clubreview"/>
		<br/>
		<xsl:apply-templates select="." mode="t_editclub"/>
		<xsl:text> | </xsl:text>
		<xsl:apply-templates select="." mode="t_viewclub"/>
		<br/>
		<br/>
		---------------------------------------------------------------------------
		<br/>
		<br/>
	</xsl:template>
	<!--
	<xsl:template match="MEMBERS" mode="r_clubreview">
	Use: Display of the members totals within the club review
	 -->
	<xsl:template match="MEMBERS" mode="r_clubreview">
		<xsl:value-of select="$m_memberstitle"/>
		<br/>
		<xsl:apply-templates select="NEW" mode="c_members"/>
		<xsl:apply-templates select="ALL" mode="c_members"/>
		<br/>
	</xsl:template>
	<!--
	<xsl:template match="NEW" mode="r_members">
	Use: Display of the new members total within the club review
	 -->
	<xsl:template match="NEW" mode="r_members">
		<xsl:value-of select="$m_membersnewtitle"/>
		<xsl:value-of select="."/>
		<xsl:text> | </xsl:text>
	</xsl:template>
	<!--
	<xsl:template match="ALL" mode="r_members">
	Use: Display of the all members total within the club review
	 -->
	<xsl:template match="ALL" mode="r_members">
		<xsl:value-of select="$m_membersalltitle"/>
		<xsl:value-of select="."/>
	</xsl:template>
	<!--
	<xsl:template match="COMMENTS" mode="r_clubreview">
	Use: Display of the comments totals within the club review
	 -->
	<xsl:template match="COMMENTS" mode="r_clubreview">
		<xsl:value-of select="$m_commentstitle"/>
		<br/>
		<xsl:apply-templates select="NEW" mode="c_comments"/>
		<xsl:apply-templates select="ALL" mode="c_comments"/>
		<br/>
	</xsl:template>
	<!--
	<xsl:template match="NEW" mode="r_comments">
	Use: Display of the new comments total within the club review
	 -->
	<xsl:template match="NEW" mode="r_comments">
		<xsl:value-of select="$m_commentsnewtitle"/>
		<xsl:value-of select="."/>
		<xsl:text> | </xsl:text>
	</xsl:template>
	<!--
	<xsl:template match="ALL" mode="r_comments">
	Use: Display of the all comments total within the club review
	 -->
	<xsl:template match="ALL" mode="r_comments">
		<xsl:value-of select="$m_commentsalltitle"/>
		<xsl:value-of select="."/>
	</xsl:template>
	<!--
	<xsl:template match="MEMBERSHIPSTATUS" mode="r_clubreview">
	Use: Display of the users membership status within the club review
	 -->
	<xsl:template match="MEMBERSHIPSTATUS" mode="r_clubreview">
		<xsl:value-of select="$m_statustitle"/>
		<br/>
		<xsl:value-of select="."/>
		<br/>
		Change Status: <xsl:apply-templates select="." mode="c_changestatus"/>
		<br/>
	</xsl:template>
	<!--
	<xsl:template match="MEMBERSHIPSTATUS" mode="c_changestatus">
	Use: Display of the change users membership status within the club review
	 -->
	<xsl:template match="MEMBERSHIPSTATUS" mode="r_changestatus">
		<xsl:apply-templates select="." mode="t_changestatuslist"/>
		<xsl:text> | </xsl:text>
		<xsl:apply-templates select="." mode="t_changestatussubmit"/>
	</xsl:template>
	<xsl:attribute-set name="fMEMBERSHIPSTATUS_c_changestatus"/>
	<xsl:attribute-set name="sMEMBERSHIPSTATUS_t_changestatuslist"/>
	<xsl:attribute-set name="oMEMBERSHIPSTATUS_t_changestatuslist"/>
	<xsl:attribute-set name="iMEMBERSHIPSTATUS_t_changestatussubmit">
		<xsl:attribute name="type">submit</xsl:attribute>
	</xsl:attribute-set>
	<!--
	<xsl:template match="CURRENTROLE" mode="r_clubreview">
	Use: Display of the users current role within the club review
	 -->
	<xsl:template match="CURRENTROLE" mode="r_clubreview">
		<xsl:value-of select="$m_roletitle"/>
		<br/>
		<xsl:value-of select="."/>
		<xsl:apply-templates select="." mode="c_changerole"/>
	</xsl:template>
	<!--
	<xsl:template match="CURRENTROLE" mode="r_changerole">
	Use: Display of the change users current role within the club review
	 -->
	<xsl:template match="CURRENTROLE" mode="r_changerole">
		<xsl:value-of select="$m_changerole"/>
		<xsl:text>: </xsl:text>
		<xsl:apply-templates select="." mode="t_inputrole"/>
		<xsl:text> | </xsl:text>
		<xsl:apply-templates select="." mode="t_submit"/>
	</xsl:template>
	<!--
	<xsl:attribute-set name="fCURRENTROLE_c_changerole"/>
	Use: Attribute set for the change role form
	 -->
	<xsl:attribute-set name="fCURRENTROLE_c_changerole"/>
	<!--
	<xsl:attribute-set name="iCURRENTROLE_t_inputrole">
	Use: Attribute set for the change role input element
	 -->
	<xsl:attribute-set name="iCURRENTROLE_t_inputrole">
		<xsl:attribute name="type">text</xsl:attribute>
	</xsl:attribute-set>
	<!--
	<xsl:attribute-set name="iCURRENTROLE_t_submit">
	Use: Attribute set for the change role submit element
	 -->
	<xsl:attribute-set name="iCURRENTROLE_t_submit">
		<xsl:attribute name="type">submit</xsl:attribute>
	</xsl:attribute-set>
	<!--
	<xsl:template match="ACTIONS" mode="r_clubreview">
	Use: Display of the clubs actions within the club review
	 -->
	<xsl:template match="ACTIONS" mode="r_clubreview">
		<xsl:apply-templates select="PENDING" mode="c_actions"/>
		<xsl:apply-templates select="COMPLETED" mode="c_actions"/>
	</xsl:template>
	<!--
	<xsl:template match="PENDING" mode="r_actions">
	Use: Display of the clubs pending actions within the club review
	 -->
	<xsl:template match="PENDING" mode="r_actions">
		<xsl:value-of select="$m_pendingtitle"/>
		<br/>
		<xsl:apply-templates select="ACTION" mode="c_actions"/>
		<br/>
	</xsl:template>
	<!--
	<xsl:template match="COMPLETED" mode="r_actions">
	Use: Display of the clubs completed actions within the club review
	 -->
	<xsl:template match="COMPLETED" mode="r_actions">
		<xsl:value-of select="$m_completedtitle"/>
		<br/>
		<xsl:apply-templates select="ACTION" mode="c_actions"/>
		<br/>
	</xsl:template>
	<!--
	<xsl:template match="ACTION" mode="r_actions">
	Use: Display of the individual actions within the club review
	 -->
	<xsl:template match="ACTION" mode="r_actions">
		<xsl:value-of select="@NAME"/>
		<br/>
		Posted by:
		<xsl:apply-templates select="OWNER" mode="t_actions"/>
		<xsl:text> </xsl:text>
		<xsl:apply-templates select="POSTDATE" mode="t_actions"/>
		<br/>
	</xsl:template>
</xsl:stylesheet>
