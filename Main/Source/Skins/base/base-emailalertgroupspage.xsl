<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<!--
	<xsl:template name="EMAILALERTGROUPS_HEADER">
	Author:		Andy Harris
	Context:      H2G2
	Purpose:	 Creates the title for the page which sits in the html header
	-->
	<xsl:template name="EMAILALERTGROUPS_HEADER">
		<xsl:apply-templates mode="header" select=".">
			<xsl:with-param name="title">
				<xsl:value-of select="$m_pagetitlestart"/>
				<xsl:value-of select="$m_emailalertgroups"/>
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>
	<!--
	<xsl:template name="EMAILALERTGROUPS_SUBJECT">
	Author:		Andy Harris
	Context:      H2G2
	Purpose:	 Creates the text for the subject
	-->
	<xsl:template name="EMAILALERTGROUPS_SUBJECT">
		<xsl:call-template name="SUBJECTHEADER">
			<xsl:with-param name="text">
				<xsl:value-of select="$m_emailalert"/>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="ALERTGROUPS" mode="c_emailalertgroups">
		<!-- Page layouts -->
		<xsl:choose>
			<!-- Error page -->
			<xsl:when test="/H2G2/ERROR/@CODE='UserNotLoggedIn' or /H2G2/ERROR/@CODE='UserNotAuthorised'">
				<xsl:apply-templates select="/H2G2/ERROR" mode="error_emailalertgroups"/>
			</xsl:when>
			<!-- Editing alerts -->
			<xsl:when test="/H2G2/PARAMS/PARAM[NAME='s_mode']/VALUE='edit'">
				<xsl:apply-templates select="." mode="edit_emailalertgroups"/>
			</xsl:when>
			<!-- Confirmation that an alert has been set -->
			<xsl:when test="/H2G2/PARAMS/PARAM[NAME='s_mode']/VALUE='confirm'">
				<xsl:apply-templates select="." mode="confirmation_emailalertgroups"/>
			</xsl:when>
			<!-- Standard alerts page -->
			<xsl:otherwise>
				<xsl:apply-templates select="." mode="summary_emailalertgroups"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="ALERTGROUPS" mode="c_alertsummary">
		<xsl:choose>
			<xsl:when test="GROUPALERT">
				<xsl:apply-templates select="." mode="full_alertsummary"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="." mode="empty_alertsummary"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="ALERTGROUPS" mode="c_owneralertsummary">
		<xsl:apply-templates select="." mode="r_owneralertsummary"/>
	</xsl:template>
	<xsl:template match="ALERTGROUPS" mode="t_owneralertmethod">
		<xsl:choose>
			<xsl:when test="GROUPALERT[ISOWNER = 1]/NOTIFYTYPE = 1">Email</xsl:when>
			<xsl:when test="GROUPALERT[ISOWNER = 1]/NOTIFYTYPE = 2">My Messages</xsl:when>
			<xsl:when test="GROUPALERT[ISOWNER = 1]/NOTIFYTYPE = 3">No Alerts</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="ALERTGROUPS" mode="t_otheralertmethod">
		<xsl:choose>
			<xsl:when test="GROUPALERT[ISOWNER = 0]/NOTIFYTYPE = 1">Email</xsl:when>
			<xsl:when test="GROUPALERT[ISOWNER = 0]/NOTIFYTYPE = 2">My Messages</xsl:when>
			<xsl:when test="GROUPALERT[ISOWNER = 0]/NOTIFYTYPE = 3">No Alerts</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="ALERTGROUPS" mode="t_owneralertchangelink">
		<a href="alertgroups?s_mode=edit&amp;s_type=owner" xsl:use-attribute-sets="mALERTGROUPS_t_owneralertchangelink">
			Change this
		</a>
	</xsl:template>
	<xsl:template match="ALERTGROUPS" mode="t_otheralertchangelink">
		<a href="alertgroups?s_mode=edit&amp;s_type=other" xsl:use-attribute-sets="mALERTGROUPS_t_otheralertchangelink">
			Change this
		</a>
	</xsl:template>
	<xsl:template match="ALERTGROUPS" mode="c_otheralertsummary">
		<xsl:apply-templates select="." mode="r_otheralertsummary"/>
	</xsl:template>
	<xsl:template match="GROUPALERT" mode="c_owneralertsummary">
		<xsl:if test="ISOWNER=1">
			<xsl:apply-templates select="." mode="r_owneralertsummary"/>
		</xsl:if>
	</xsl:template>
	<xsl:template match="GROUPALERT" mode="c_otheralertsummary">
		<xsl:if test="ISOWNER=0">
			<xsl:apply-templates select="." mode="r_otheralertsummary"/>
		</xsl:if>
	</xsl:template>
	<xsl:template match="GROUPALERT" mode="t_viewlink">
		<a xsl:use-attribute-sets="mGROUPALERT_t_viewlink">
			<xsl:attribute name="href"><xsl:choose><!-- Issue / Location --><xsl:when test="ITEMTYPE=1">C<xsl:value-of select="ITEMID"/></xsl:when><!-- Article --><xsl:when test="ITEMTYPE=2">A<xsl:value-of select="ITEMID"/></xsl:when><!-- Campaign --><xsl:when test="ITEMTYPE=3">G<xsl:value-of select="ITEMID"/></xsl:when><!-- Forum --><xsl:when test="ITEMTYPE=4">F<xsl:value-of select="ITEMID"/>?thread=<xsl:value-of select="ITEMID2"/></xsl:when><!-- Thread --><xsl:when test="ITEMTYPE=5">T<xsl:value-of select="ITEMID"/></xsl:when><!-- User --><xsl:when test="ITEMTYPE=7">U<xsl:value-of select="ITEMID"/></xsl:when><!-- Link --><xsl:when test="ITEMTYPE=9">A<xsl:value-of select="ITEMID"/></xsl:when></xsl:choose></xsl:attribute>
			<xsl:text>View Item</xsl:text>
		</a>
	</xsl:template>
	<xsl:template match="GROUPALERT" mode="t_deletelink">
		<a href="alertgroups?cmd=remove&amp;groupid={GROUPID}" xsl:use-attribute-sets="mGROUPALERT_t_deletelink">
			<xsl:text>Delete Alert</xsl:text>
		</a>
	</xsl:template>
	<xsl:template match="ALERTGROUPS" mode="c_editpage">
		<xsl:choose>
			<xsl:when test="/H2G2/PARAMS/PARAM[NAME='s_type']/VALUE='owner'">
				<xsl:apply-templates select="." mode="owner_editpage"/>
			</xsl:when>
			<xsl:when test="/H2G2/PARAMS/PARAM[NAME='s_type']/VALUE='other'">
				<xsl:apply-templates select="." mode="other_editpage"/>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="ALERTGROUPS" mode="c_editform">
		<form action="alertgroups" method="post" xsl:use-attribute-sets="fALERTGROUPS_c_editform">
			<input type="hidden" name="cmd" value="editgroup"/>
			<input type="hidden" name="owneditems">
				<xsl:attribute name="value"><xsl:choose><xsl:when test="/H2G2/PARAMS/PARAM[NAME='s_type']/VALUE='owner'">1</xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></xsl:attribute>
			</input>
			<input type="hidden" name="alerttype" value="normal"/>
			<xsl:apply-templates select="." mode="r_editform"/>
		</form>
	</xsl:template>
	<xsl:template match="ALERTGROUPS" mode="t_emailoption">
		<xsl:variable name="typevalue">
			<xsl:choose>
				<xsl:when test="/H2G2/PARAMS/PARAM[NAME='s_type']/VALUE='owner'">1</xsl:when>
				<xsl:when test="/H2G2/PARAMS/PARAM[NAME='s_type']/VALUE='other'">0</xsl:when>
			</xsl:choose>
		</xsl:variable>
		<input type="radio" name="notifytype" value="email" xsl:use-attribute-sets="iALERTGROUPS_t_emailoption">
			<xsl:if test="GROUPALERT[ISOWNER = $typevalue]/NOTIFYTYPE = 1">
				<xsl:attribute name="checked">true</xsl:attribute>
			</xsl:if>
		</input>
	</xsl:template>
	<xsl:template match="ALERTGROUPS" mode="t_messageoption">
		<xsl:variable name="typevalue">
			<xsl:choose>
				<xsl:when test="/H2G2/PARAMS/PARAM[NAME='s_type']/VALUE='owner'">1</xsl:when>
				<xsl:when test="/H2G2/PARAMS/PARAM[NAME='s_type']/VALUE='other'">0</xsl:when>
			</xsl:choose>
		</xsl:variable>
		<input type="radio" name="notifytype" value="private" xsl:use-attribute-sets="iALERTGROUPS_t_messageoption">
			<xsl:if test="GROUPALERT[ISOWNER = $typevalue]/NOTIFYTYPE = 2">
				<xsl:attribute name="checked">true</xsl:attribute>
			</xsl:if>
		</input>
	</xsl:template>
	<xsl:template match="ALERTGROUPS" mode="t_disabledoption">
		<xsl:variable name="typevalue">
			<xsl:choose>
				<xsl:when test="/H2G2/PARAMS/PARAM[NAME='s_type']/VALUE='owner'">1</xsl:when>
				<xsl:when test="/H2G2/PARAMS/PARAM[NAME='s_type']/VALUE='other'">0</xsl:when>
			</xsl:choose>
		</xsl:variable>
		<input type="radio" name="notifytype" value="disabled" xsl:use-attribute-sets="iALERTGROUPS_t_disableoption">
			<xsl:if test="GROUPALERT[ISOWNER = $typevalue]/NOTIFYTYPE = 3">
				<xsl:attribute name="checked">true</xsl:attribute>
			</xsl:if>
		</input>
	</xsl:template>
	<xsl:template match="ALERTGROUPS" mode="t_submit">
		<input type="submit" value="Change" xsl:use-attribute-sets="iALERTGROUPS_t_submit"/>
	</xsl:template>
	<xsl:template match="ALERTGROUPS" mode="t_pagename">
		<xsl:value-of select="GROUPALERT[GROUPID = /H2G2/ALERTACTION/NEWGROUPID]/NAME"/>
	</xsl:template>
	<xsl:template match="ALERTGROUPS" mode="t_alerttype">
		<xsl:choose>
			<xsl:when test="GROUPALERT[GROUPID = /H2G2/ALERTACTION/NEWGROUPID]/NOTIFYTYPE = 1">Email</xsl:when>
			<xsl:when test="GROUPALERT[GROUPID = /H2G2/ALERTACTION/NEWGROUPID]/NOTIFYTYPE = 2">My Messages</xsl:when>
			<xsl:when test="GROUPALERT[GROUPID = /H2G2/ALERTACTION/NEWGROUPID]/NOTIFYTYPE = 3">No Alerts</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="ALERTACTION" mode="t_pagelink">
		<a xsl:use-attribute-sets="mALERTACTION_t_pagelink">
			<xsl:attribute name="href"><xsl:choose><!-- Issue / Location --><xsl:when test="ITEMTYPE=1">C<xsl:value-of select="ITEMID"/></xsl:when><!-- Article --><xsl:when test="ITEMTYPE=2">A<xsl:value-of select="ITEMID"/></xsl:when><!-- Campaign --><xsl:when test="ITEMTYPE=3">G<xsl:value-of select="ITEMID"/></xsl:when><!-- Forum --><xsl:when test="ITEMTYPE=4">F<xsl:value-of select="ITEMID"/>?thread=<xsl:value-of select="ITEMID2"/></xsl:when><!-- Thread --><xsl:when test="ITEMTYPE=5">T<xsl:value-of select="ITEMID"/></xsl:when><!-- User --><xsl:when test="ITEMTYPE=7">U<xsl:value-of select="ITEMID"/></xsl:when><!-- Link --><xsl:when test="ITEMTYPE=9">A<xsl:value-of select="ITEMID"/></xsl:when></xsl:choose></xsl:attribute>
			<xsl:value-of select="/H2G2/ALERTGROUPS/GROUPALERT[GROUPID = current()/NEWGROUPID]/NAME"/>
		</a>
	</xsl:template>
	<xsl:attribute-set name="mALERTGROUPS_t_owneralertchangelink"/>
	<xsl:attribute-set name="mALERTGROUPS_t_otheralertchangelink"/>
	<xsl:attribute-set name="mGROUPALERT_t_viewlink"/>
	<xsl:attribute-set name="mGROUPALERT_t_deletelink"/>
	<xsl:attribute-set name="fALERTGROUPS_c_editform"/>
	<xsl:attribute-set name="iALERTGROUPS_t_emailoption"/>
	<xsl:attribute-set name="iALERTGROUPS_t_messageoption"/>
	<xsl:attribute-set name="iALERTGROUPS_t_disableoption"/>
	<xsl:attribute-set name="iALERTGROUPS_t_submit"/>
	<xsl:attribute-set name="mALERTACTION_t_pagelink"/>
</xsl:stylesheet>
