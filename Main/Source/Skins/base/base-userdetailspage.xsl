<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<xsl:attribute-set name="mUSER-DETAILS-FORM_r_returntouserpage" use-attribute-sets="userdetailspagelinks"/>
	<xsl:attribute-set name="userdetailspagelinks" use-attribute-sets="linkatt"/>
	<xsl:attribute-set name="fUSER-DETAILS-FORM_c_registered"/>
	<xsl:attribute-set name="iUSER-DETAILS-FORM_t_inputusername">
		<xsl:attribute name="value"><xsl:value-of select="/H2G2/USER-DETAILS-FORM/USERNAME"/></xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="iUSER-DETAILS-FORM_t_submituserdetails">
		<xsl:attribute name="type">submit</xsl:attribute>
		<xsl:attribute name="value"><xsl:value-of select="$m_updatedetails"/></xsl:attribute>

	</xsl:attribute-set>
	<!--
	<xsl:template name="USERDETAILS_HEADER">
	Author:		Tom Whitehouse
	Context:      /H2G2
	Purpose:	 Creates the title for the page which sits in the html header
	-->
	<xsl:template name="USERDETAILS_HEADER">
		<xsl:apply-templates mode="header" select=".">
			<xsl:with-param name="title">
				<xsl:value-of select="$m_preferencestitle"/>
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>
	<!--
	<xsl:template name="USERDETAILS_SUBJECT">
	Author:		Tom Whitehouse
	Context:      /H2G2
	Purpose:	 Creates the text for the subject
	-->
	<xsl:template name="USERDETAILS_SUBJECT">
		<xsl:call-template name="SUBJECTHEADER">
			<xsl:with-param name="text">
				<xsl:value-of select="$m_preferencessubject"/>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
  
	<xsl:template match="USER-DETAILS-UNREG" mode="c_userdetails">
		<xsl:apply-templates select="." mode="r_userdetails"/>
	</xsl:template>

  <!-- Template for adding status message -->
	<xsl:template match="MESSAGE">
		<xsl:choose>
			<xsl:when test="@TYPE='badpassword'">
				<xsl:call-template name="m_udbaddpassword"/>
			</xsl:when>
			<xsl:when test="@TYPE='invalidpassword'">
				<xsl:call-template name="m_udinvalidpassword"/>
			</xsl:when>
			<xsl:when test="@TYPE='unmatchedpasswords'">
				<xsl:call-template name="m_udunmatchedpasswords"/>
			</xsl:when>
			<xsl:when test="@TYPE='badpasswordforemail'">
				<xsl:call-template name="m_udbaddpasswordforemail"/>
			</xsl:when>
			<xsl:when test="@TYPE='newpasswordsent'">
				<xsl:call-template name="m_udnewpasswordsent"/>
			</xsl:when>
			<xsl:when test="@TYPE='newpasswordfailed'">
				<xsl:call-template name="m_udnewpasswordfailed"/>
			</xsl:when>
			<xsl:when test="@TYPE='detailsupdated'">
				<xsl:call-template name="m_uddetailsupdated"/>
			</xsl:when>
			<xsl:when test="@TYPE='skinset'">
				<xsl:call-template name="m_udskinset"/>
			</xsl:when>
			<xsl:when test="@TYPE='restricteduser'">
				<xsl:call-template name="m_udrestricteduser"/>
			</xsl:when>
			<xsl:when test="@TYPE='invalidemail'">
				<xsl:call-template name="m_udinvalidemail"/>
			</xsl:when>
      <xsl:when test="@TYPE='usernamepremoderated'">
        <xsl:call-template name="m_udusernamepremoderated"/>
      </xsl:when>
		</xsl:choose>
	</xsl:template>
  
	<xsl:template match="USER-DETAILS-FORM" mode="c_registered">
    <xsl:apply-templates select="MESSAGE"/>
		<xsl:choose>
			<xsl:when test="$restricted = 0">
				<form method="post" action="{$root}UserDetails" xsl:use-attribute-sets="fUSER-DETAILS-FORM_c_registered">
					<input name="cmd" type="hidden" value="submit"/>
					<input type="hidden" name="PrefSkin" xsl:use-attribute-sets="mUSER-DETAILS-FORM_c_registered_prefskin"/>
					<input type="hidden" name="PrefUserMode" value="{PREFERENCES/USER-MODE}"/>
					<input type="hidden" name="PrefForumStyle" value="{PREFERENCES/FORUM-STYLE}"/>
					<input name="OldEmail" type="hidden" value="{EMAIL-ADDRESS}"/>
					<input name="NewEmail" type="hidden" value="{EMAIL-ADDRESS}"/>
					<input type="hidden" name="Password"/>
					<input type="hidden" name="NewPassword"/>
					<input type="hidden" name="PasswordConfirm"/>
					<xsl:apply-templates select="." mode="normal_registered"/>
				</form>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="." mode="restricted_registered"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="USER-DETAILS-FORM" mode="t_inputusername">
		<xsl:choose>
			<xsl:when test="$premoderated = 1">
				<xsl:value-of select="USERNAME"/>
			</xsl:when>
			<xsl:otherwise>
				<input type="text" name="Username" xsl:use-attribute-sets="iUSER-DETAILS-FORM_t_inputusername"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="USER-DETAILS-FORM" mode="c_skins">
		<xsl:apply-templates select="." mode="r_skins"/>
	</xsl:template>
	<xsl:template match="USER-DETAILS-FORM" mode="t_skinlist">
		<select name="PrefSkin">
			<xsl:call-template name="skindropdown">
				<xsl:with-param name="localskinname">
					<xsl:value-of select="PREFERENCES/SKIN"/>
				</xsl:with-param>
			</xsl:call-template>
		</select>
	</xsl:template>
	<xsl:template name="skindropdown">
		<xsl:param name="localskinname">
			<xsl:value-of select="$skinname"/>
		</xsl:param>
		<xsl:apply-templates select="msxsl:node-set($skinlist)/*">
			<xsl:with-param name="localskinname">
				<xsl:value-of select="$localskinname"/>
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>
	<xsl:template match="SKINDEFINITION">
		<xsl:param name="localskinname">
			<xsl:value-of select="$skinname"/>
		</xsl:param>
		<OPTION VALUE="{NAME}">
			<xsl:if test="$localskinname = string(NAME)">
				<xsl:attribute name="SELECTED">1</xsl:attribute>
			</xsl:if>
			<xsl:value-of select="DESCRIPTION"/>
		</OPTION>
	</xsl:template>
	<xsl:template match="USER-DETAILS-FORM" mode="c_usermode">
		<xsl:apply-templates select="." mode="r_usermode"/>
	</xsl:template>
	<xsl:template match="USER-DETAILS-FORM" mode="t_usermodelist">
		<select name="PrefUserMode">
			<xsl:choose>
				<xsl:when test="number(PREFERENCES/USER-MODE)=1">
					<option value="0">
						<xsl:value-of select="$m_normal"/>
					</option>
					<option value="1" selected="1">
						<xsl:value-of select="$m_expert"/>
					</option>
				</xsl:when>
				<xsl:otherwise>
					<option value="0" selected="1">
						<xsl:value-of select="$m_normal"/>
					</option>
					<option value="1">
						<xsl:value-of select="$m_expert"/>
					</option>
				</xsl:otherwise>
			</xsl:choose>
		</select>
	</xsl:template>
	<xsl:template match="USER-DETAILS-FORM" mode="t_forumstylelist">
		<select name="PrefForumStyle">
			<xsl:choose>
				<xsl:when test="number(PREFERENCES/FORUM-STYLE)=0">
					<option value="0" selected="selected">
						<xsl:value-of select="$m_forumstylesingle"/>
					</option>
					<option value="1">
						<xsl:value-of select="$m_forumstyleframes"/>
					</option>
				</xsl:when>
				<xsl:otherwise>
					<option value="0">
						<xsl:value-of select="$m_forumstylesingle"/>
					</option>
					<option value="1" selected="selected">
						<xsl:value-of select="$m_forumstyleframes"/>
					</option>
				</xsl:otherwise>
			</xsl:choose>
		</select>
	</xsl:template>
	
	<xsl:template match="USER-DETAILS-FORM" mode="t_submituserdetails">
		<input xsl:use-attribute-sets="iUSER-DETAILS-FORM_t_submituserdetails"/>
	</xsl:template>
	<xsl:template match="USER-DETAILS-FORM" mode="c_forumstyle">
		<xsl:apply-templates select="." mode="r_forumstyle"/>
	</xsl:template>
	<xsl:template match="USER-DETAILS-FORM" mode="c_returntouserpage">
		<xsl:apply-templates select="." mode="r_returntouserpage"/>
	</xsl:template>
	<xsl:template match="USER-DETAILS-FORM" mode="r_returntouserpage">
		<a href="{$root}U{USERID}" xsl:use-attribute-sets="mUSER-DETAILS-FORM_r_returntouserpage">
			<xsl:copy-of select="$m_backtouserpage"/>
		</a>
	</xsl:template>
	<xsl:attribute-set name="mUSER-DETAILS-FORM_c_registered_prefskin">
		<xsl:attribute name="value"><xsl:value-of select="$skinname"/></xsl:attribute>
	</xsl:attribute-set>
</xsl:stylesheet>
