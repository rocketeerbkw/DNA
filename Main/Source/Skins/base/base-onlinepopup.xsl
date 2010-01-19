<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<!--
	<xsl:template name="ONLINE_HEADER">
	Author:		Andy Harris
	Context:      H2G2
	Purpose:	 Creates the title for the page which sits in the html header
	-->
	<xsl:template name="ONLINE_HEADER">
		<xsl:apply-templates mode="header" select=".">
			<xsl:with-param name="title">
				<xsl:value-of select="$m_onlinetitle"/>
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>
	<!--
	<xsl:template match="ONLINEUSERS" mode="c_orderform">
	Author:		Andy Harris
	Context:      H2G2/ONLINEUSERS
	Purpose:	 Creates the form element for the order selection
	-->
	<xsl:template match="ONLINEUSERS" mode="c_orderform">
		<form method="get" action="{$root}Online" name="WhosOnlineForm" title="{$alt_onlineform}" xsl:use-attribute-sets="fONLINEUSERS_c_orderform">
			<xsl:apply-templates select="." mode="r_orderform"/>
		</form>
	</xsl:template>
	<!--
	<xsl:template match="@ORDER-BY" mode="t_idbutton">
	Author:		Andy Harris
	Context:      H2G2/ONLINEUSERS/@ORDER-BY
	Purpose:	 Creates the 'order by id' radiobutton
	-->
	<xsl:template match="@ORDER-BY" mode="t_idbutton">
		<input type="radio" name="orderby" value="id" onclick="document.WhosOnlineForm.submit()" title="{$alt_onlineorderbyid}" xsl:use-attribute-sets="iORDERBY_t_idbutton">
			<xsl:if test=".='id'">
				<xsl:attribute name="checked">checked</xsl:attribute>
			</xsl:if>
		</input>
	</xsl:template>
	<!--
	<xsl:template match="@ORDER-BY" mode="t_namebutton">
	Author:		Andy Harris
	Context:      H2G2/ONLINEUSERS/@ORDER-BY
	Purpose:	 Creates the 'order by name' radiobutton
	-->
	<xsl:template match="@ORDER-BY" mode="t_namebutton">
		<input type="radio" name="orderby" value="name" onclick="document.WhosOnlineForm.submit()" title="{$alt_onlineorderbyname}" xsl:use-attribute-sets="iORDERBY_t_namebutton">
			<xsl:if test=".='name'">
				<xsl:attribute name="checked">checked</xsl:attribute>
			</xsl:if>
		</input>
	</xsl:template>
	<!--
	<xsl:template match="ONLINEUSERS" mode="t_number">
	Author:		Andy Harris
	Context:      H2G2/ONLINEUSERS
	Purpose:	 Creates the number of users online text
	-->
	<xsl:template match="ONLINEUSERS" mode="t_number">
		<xsl:choose>
			<xsl:when test="count(ONLINEUSER)=1">
				<xsl:value-of select="count(ONLINEUSER)"/>
				<xsl:value-of select="$m_useronline"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="count(ONLINEUSER)"/>
				<xsl:value-of select="$m_usersonline"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="ONLINEUSERS" mode="c_online">
	Author:		Andy Harris
	Context:      H2G2/ONLINEUSERS
	Purpose:	 Calls and orders the ONLINEUSER list
	-->
	<xsl:template match="ONLINEUSERS" mode="c_online">
		<xsl:choose>
			<xsl:when test="@ORDER-BY='id'">
				<xsl:apply-templates select="ONLINEUSER" mode="id_online">
					<xsl:sort select="USER/USERID" data-type="number" order="ascending"/>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:when test="@ORDER-BY='name'">
				<xsl:apply-templates select="ONLINEUSER" mode="name_online">
					<xsl:sort select="USER/USERNAME" data-type="text" order="ascending"/>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="." mode="default_online"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="ONLINEUSER" mode="c_online">
	Author:		Andy Harris
	Context:      H2G2/ONLINEUSERS/ONLINEUSER
	Purpose:	 Calls the container for each ONLINEUSER
	-->
	<xsl:template match="ONLINEUSER" mode="c_online">
		<xsl:apply-templates select="." mode="r_online"/>
	</xsl:template>
	<!--
	<xsl:template match="ONLINEUSER" mode="c_online">
	Author:		Andy Harris
	Context:      H2G2/ONLINEUSERS/ONLINEUSER
	Purpose:	 Creates the username link and the 'New this Week' text
	-->
	<xsl:template match="ONLINEUSER" mode="r_online">
		<a target="_blank" xsl:use-attribute-sets="mONLINEUSER_r_online">
			<xsl:attribute name="HREF"><xsl:value-of select="$root"/>U<xsl:value-of select="USER/USERID"/></xsl:attribute>
			<xsl:value-of select="USER/USERNAME"/>
		</a>
		<xsl:if test="number(DAYSSINCEJOINED) &lt; 7"> (<xsl:value-of select="$m_newthisweek"/>)</xsl:if>
	</xsl:template>
	<xsl:attribute-set name="fONLINEUSERS_c_orderform"/>
	<xsl:attribute-set name="iORDERBY_t_idbutton"/>
	<xsl:attribute-set name="iORDERBY_t_namebutton"/>
</xsl:stylesheet>
