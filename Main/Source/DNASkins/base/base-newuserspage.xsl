<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<!--
	<xsl:template name="NEWUSERS_HEADER">
	Author:		Andy Harris
	Context:      H2G2
	Purpose:	 Creates the title for the page which sits in the html header
	-->
	<xsl:template name="NEWUSERS_HEADER">
		<xsl:apply-templates mode="header" select=".">
			<xsl:with-param name="title">
				<xsl:value-of select="$m_NewUsersPageTitle"/>
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>
	<!--
	<xsl:template match="NEWUSERS-LISTING" mode="c_inputform">
	Author:		Andy Harris
	Context:      /H2G2/NEWUSERS-LISTING
	Purpose:	 Creates the form element for the type selection form
	-->
	<xsl:template match="NEWUSERS-LISTING" mode="c_inputform">
		<form method="get" action="{$root}NewUsers" xsl:use-attribute-sets="fNEWUSERS-LISTING_c_inputform">
			<xsl:apply-templates select="." mode="r_inputform"/>
		</form>
	</xsl:template>
	<!--
	<xsl:template match="@TIMEUNITS" mode="t_timelist">
	Author:		Andy Harris
	Context:      /H2G2/NEWUSERS-LISTING/@TIMEUNITS
	Purpose:	 Creates the TIMEUNITS select element for the type selection form
	-->
	<xsl:template match="@TIMEUNITS" mode="t_timelist">
		<select name="TimeUnits" title="Number of Time Units" xsl:use-attribute-sets="sTIMEUNITS_t_timelist">
			<option value="1" xsl:use-attribute-sets="oTIMEUNITS_t_timelist">
				<xsl:if test=".='1'">
					<xsl:attribute name="selected">selected</xsl:attribute>
				</xsl:if>1</option>
			<option value="2" xsl:use-attribute-sets="oTIMEUNITS_t_timelist">
				<xsl:if test=".='2'">
					<xsl:attribute name="selected">selected</xsl:attribute>
				</xsl:if>2</option>
			<option value="3" xsl:use-attribute-sets="oTIMEUNITS_t_timelist">
				<xsl:if test=".='3'">
					<xsl:attribute name="selected">selected</xsl:attribute>
				</xsl:if>3</option>
			<option value="4" xsl:use-attribute-sets="oTIMEUNITS_t_timelist">
				<xsl:if test=".='4'">
					<xsl:attribute name="selected">selected</xsl:attribute>
				</xsl:if>4</option>
			<option value="5" xsl:use-attribute-sets="oTIMEUNITS_t_timelist">
				<xsl:if test=".='5'">
					<xsl:attribute name="selected">selected</xsl:attribute>
				</xsl:if>5</option>
			<option value="6" xsl:use-attribute-sets="oTIMEUNITS_t_timelist">
				<xsl:if test=".='6'">
					<xsl:attribute name="selected">selected</xsl:attribute>
				</xsl:if>6</option>
			<option value="7" xsl:use-attribute-sets="oTIMEUNITS_t_timelist">
				<xsl:if test=".='7'">
					<xsl:attribute name="selected">selected</xsl:attribute>
				</xsl:if>7</option>
			<option value="8" xsl:use-attribute-sets="oTIMEUNITS_t_timelist">
				<xsl:if test=".='8'">
					<xsl:attribute name="selected">selected</xsl:attribute>
				</xsl:if>8</option>
			<option value="9" xsl:use-attribute-sets="oTIMEUNITS_t_timelist">
				<xsl:if test=".='9'">
					<xsl:attribute name="selected">selected</xsl:attribute>
				</xsl:if>9</option>
			<option value="10" xsl:use-attribute-sets="oTIMEUNITS_t_timelist">
				<xsl:if test=".='10'">
					<xsl:attribute name="selected">selected</xsl:attribute>
				</xsl:if>10</option>
			<option value="11" xsl:use-attribute-sets="oTIMEUNITS_t_timelist">
				<xsl:if test=".='11'">
					<xsl:attribute name="selected">selected</xsl:attribute>
				</xsl:if>11</option>
			<option value="12" xsl:use-attribute-sets="oTIMEUNITS_t_timelist">
				<xsl:if test=".='12'">
					<xsl:attribute name="selected">selected</xsl:attribute>
				</xsl:if>12</option>
		</select>
	</xsl:template>
	<!--
	<xsl:template match="@UNITTYPE" mode="t_timelist">
	Author:		Andy Harris
	Context:      /H2G2/NEWUSERS-LISTING/@UNITTYPE
	Purpose:	 Creates the UNITTYPE select element for the type selection form
	-->
	<xsl:template match="@UNITTYPE" mode="t_timelist">
		<select name="UnitType" title="Type of Time Unit" xsl:use-attribute-sets="sUNITTYPE_t_timelist">
			<option value="month" xsl:use-attribute-sets="oUNITTYPE_t_timelist">
				<xsl:if test=".='month'">
					<xsl:attribute name="selected">selected</xsl:attribute>
				</xsl:if>Months</option>
			<option value="week" xsl:use-attribute-sets="oUNITTYPE_t_timelist">
				<xsl:if test=".='week'">
					<xsl:attribute name="selected">selected</xsl:attribute>
				</xsl:if>Weeks</option>
			<option value="day" xsl:use-attribute-sets="oUNITTYPE_t_timelist">
				<xsl:if test=".='day'">
					<xsl:attribute name="selected">selected</xsl:attribute>
				</xsl:if>Days</option>
			<option value="hour" xsl:use-attribute-sets="oUNITTYPE_t_timelist">
				<xsl:if test=".='hour'">
					<xsl:attribute name="selected">selected</xsl:attribute>
				</xsl:if>Hours</option>
		</select>
	</xsl:template>
	<!--
	<xsl:template match="NEWUSERS-LISTING" mode="t_submitbutton">
	Author:		Andy Harris
	Context:      /H2G2/NEWUSERS-LISTING
	Purpose:	 Creates the submit button for the type selection form
	-->
	<xsl:template match="NEWUSERS-LISTING" mode="t_submitbutton">
		<input xsl:use-attribute-sets="iNEWUSERS-LISTING_t_submitbutton"/>
	</xsl:template>
	<!--
	<xsl:template match="NEWUSERS-LISTING" mode="t_allradio">
	Author:		Andy Harris
	Context:      /H2G2/NEWUSERS-LISTING
	Purpose:	 Creates the FILTER-USERS radio button for the type selection form
	-->
	<xsl:template match="NEWUSERS-LISTING" mode="t_allradio">
		<input type="radio" name="Filter" value="off" xsl:use-attribute-sets="iNEWUSERS-LISTING_t_allradio">
			<xsl:if test="not(@FILTER-USERS=1)">
				<xsl:attribute name="checked">checked</xsl:attribute>
			</xsl:if>
		</input>
	</xsl:template>
	<!--
	<xsl:template match="NEWUSERS-LISTING" mode="t_haveintroradio">
	Author:		Andy Harris
	Context:      /H2G2/NEWUSERS-LISTING
	Purpose:	 Creates the FILTER-TYPE radio button for the type selection form
	-->
	<xsl:template match="NEWUSERS-LISTING" mode="t_haveintroradio">
		<input type="radio" name="Filter" value="haveintroduction" xsl:use-attribute-sets="iNEWUSERS-LISTING_t_haveintroradio">
			<xsl:if test="@FILTER-TYPE='haveintroduction'">
				<xsl:attribute name="checked">checked</xsl:attribute>
			</xsl:if>
		</input>
	</xsl:template>
	<!--
	<xsl:template match="NEWUSERS-LISTING" mode="t_nopostingradio">
	Author:		Andy Harris
	Context:      /H2G2/NEWUSERS-LISTING
	Purpose:	 Creates the FILTER-TYPE radio button for the type selection form
	-->
	<xsl:template match="NEWUSERS-LISTING" mode="t_nopostingradio">
		<input type="radio" name="Filter" value="noposting" xsl:use-attribute-sets="iNEWUSERS-LISTING_t_nopostingradio">
			<xsl:if test="@FILTER-TYPE='noposting'">
				<xsl:attribute name="checked">checked</xsl:attribute>
			</xsl:if>
		</input>
	</xsl:template>
	<!--
	<xsl:template match="NEWUSERS-LISTING" mode="t_thissitecheckbox">
	Author:		Andy Harris
	Context:      /H2G2/NEWUSERS-LISTING
	Purpose:	 Creates the SITEID radio button for the type selection form
	-->
	<xsl:template match="NEWUSERS-LISTING" mode="t_thissitecheckbox">
		<!--<input type="checkbox" name="thissite" value="1" xsl:use-attribute-sets="iNEWUSERS-LISTING_t_thissitecheckbox">
			<xsl:if test="@SITEID">
				<xsl:attribute name="checked">checked</xsl:attribute>
			</xsl:if>
		</input>-->
	</xsl:template>
	<!--
	<xsl:template select="." mode="t_updatedcheckbox"/>
	Author:		Andy Harris
	Context:      /H2G2/NEWUSERS-LISTING
	Purpose:	 Creates the SITEID radio button for the type selection form
	-->
	<xsl:template match="NEWUSERS-LISTING" mode="t_updatedcheckbox">
		<input type="checkbox" name="whoupdatedpersonalspace" value="1" xsl:use-attribute-sets="iNEWUSERS-LISTING_t_updatedcheckbox">
			<xsl:if test="@UPDATINGUSERS">
				<xsl:attribute name="checked">checked</xsl:attribute>
			</xsl:if>
		</input>
	</xsl:template>
	<!--
	<xsl:template match="NEWUSERS-LISTING" mode="c_newuserspage">
	Author:		Andy Harris
	Context:      /H2G2/NEWUSERS-LISTING
	Purpose:	 Calls the container for the NEWUSERS-LISTING object
	-->
	<xsl:template match="NEWUSERS-LISTING" mode="c_newuserspage">
		<xsl:apply-templates select="." mode="r_newuserspage"/>
	</xsl:template>
	<!--
	<xsl:template match="USER-LIST" mode="c_newuserspage">
	Author:		Andy Harris
	Context:      /H2G2/NEWUSERS-LISTING/USER-LIST
	Purpose:	 Calls the correct container for the USER-LIST object based on whether there is content
	-->
	<xsl:template match="USER-LIST" mode="c_newuserspage">
		<xsl:choose>
			<!-- if at least one new user returned then display the list -->
			<xsl:when test="USER">
				<xsl:apply-templates select="." mode="newusers_newuserspage"/>
			</xsl:when>
			<!-- otherwise display a message saying no users have registered in that time -->
			<xsl:otherwise>
				<xsl:apply-templates select="." mode="nonewusers_newuserspage"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="USER-LIST" mode="c_userlist">
	Author:		Andy Harris
	Context:      /H2G2/NEWUSERS-LISTING/USER-LIST
	Purpose:	 Calls the correct container for the USER object based on TYPE
	-->
	<xsl:template match="USER-LIST" mode="c_userlist">
		<xsl:choose>
			<xsl:when test="@TYPE='NEW-USERS'">
				<xsl:apply-templates select="." mode="newusers_userlist"/>
			</xsl:when>
			<xsl:when test="@TYPE='SUB-EDITORS'">
				<xsl:apply-templates select="." mode="subeditors_userlist"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="." mode="default_userlist"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="USER-LIST" mode="c_previous">
	Author:		Andy Harris
	Context:      /H2G2/NEWUSERS-LISTING/USER-LIST
	Purpose:	 Calls the correct container for the previous button based on whether there is a previous page
	-->
	<xsl:template match="USER-LIST" mode="c_previous">
		<xsl:choose>
			<xsl:when test="@SKIP &gt; 0 or @SKIPTO &gt; 0">
				<xsl:apply-templates select="." mode="link_previous"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="." mode="no_previous"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="USER-LIST" mode="link_previous">
	Author:		Andy Harris
	Context:      /H2G2/NEWUSERS-LISTING/USER-LIST
	Purpose:	 Creates the 'previous page' link
	-->
	<xsl:template match="USER-LIST" mode="link_previous">
		<!-- flag for if we are only showing researchers who have written their intros -->
		<xsl:variable name="thissiteflag">
  			 <xsl:if test="../@SITEID">&amp;thissite=1</xsl:if>
   		</xsl:variable>
		<xsl:variable name="filter">
			<xsl:choose>
				<xsl:when test="../@FILTER-USERS=1">
					<xsl:choose>
						<xsl:when test="../@FILTER-TYPE='haveintroduction'">Filter=haveintroduction</xsl:when>
						<xsl:otherwise>Filter=noposting</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise>Filter=off</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<a href="{$root}NewUsers?unittype={../@UNITTYPE}&amp;timeunits={../@TIMEUNITS}&amp;skip={number((@SKIP|@SKIPTO)[1]) - number(@SHOW)}&amp;{$filter}{$thissiteflag}">
			<xsl:value-of select="$m_OlderRegistrations"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="USER-LIST" mode="c_next">
	Author:		Andy Harris
	Context:      /H2G2/NEWUSERS-LISTING/USER-LIST
	Purpose:	 Calls the correct container for the next button based on whether there is a next page
	-->
	<xsl:template match="USER-LIST" mode="c_next">
		<xsl:choose>
			<xsl:when test="@MORE=1">
				<xsl:apply-templates select="." mode="link_next"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="." mode="no_next"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="USER-LIST" mode="link_next">
	Author:		Andy Harris
	Context:      /H2G2/NEWUSERS-LISTING/USER-LIST
	Purpose:	 Creates the 'next page' link
	-->
	<xsl:template match="USER-LIST" mode="link_next">
		<!-- flag for if we are only showing researchers who have written their intros -->
		<xsl:variable name="thissiteflag">
  			 <xsl:if test="../@SITEID">&amp;thissite=1</xsl:if>
   		</xsl:variable>
		<xsl:variable name="filter">
			<xsl:choose>
				<xsl:when test="../@FILTER-USERS=1">
					<xsl:choose>
						<xsl:when test="../@FILTER-TYPE='haveintroduction'">Filter=haveintroduction</xsl:when>
						<xsl:otherwise>Filter=noposting</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise>Filter=off</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<a href="{$root}NewUsers?unittype={../@UNITTYPE}&amp;timeunits={../@TIMEUNITS}&amp;skip={number((@SKIP|@SKIPTO)[1]) + number(@COUNT)}&amp;{$filter}{$thissiteflag}">
			<xsl:value-of select="$m_NewerRegistrations"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="USER" mode="c_newusers">
	Author:		Andy Harris
	Context:      /H2G2/NEWUSERS-LISTING/USER-LIST/USER
	Purpose:	 Calls the container for the USER object
	-->
	<xsl:template match="USER" mode="c_newusers">
		<xsl:apply-templates select="." mode="r_newusers"/>
	</xsl:template>
	<!--
	<xsl:template match="USER" mode="c_introflag">
	Author:		Andy Harris
	Context:      /H2G2/NEWUSERS-LISTING/USER-LIST/USER
	Purpose:	 Tests to see if the USER needs an intro flag
	-->
	<xsl:template match="USER" mode="c_introflag">
		<xsl:if test="number(MASTHEAD) != 0">
			<xsl:apply-templates select="." mode="r_introflag"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="USER" mode="c_postingflag">
	Author:		Andy Harris
	Context:      /H2G2/NEWUSERS-LISTING/USER-LIST/USER
	Purpose:	 Tests to see if the USER needs an posting flag
	-->
	<xsl:template match="USER" mode="c_postingflag">
		<xsl:if test="number(FORUM-POSTED-TO) != 0">
			<xsl:apply-templates select="." mode="r_postingflag"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="USER" mode="c_postingflag">
	Author:		Andy Harris
	Context:      /H2G2/NEWUSERS-LISTING/USER-LIST/USER/USERNAME
	Purpose:	 Creates the link to the USERNAME's userpage
	-->
	<xsl:template match="USERNAME" mode="t_newusers">
		<a xsl:use-attribute-sets="mUSERNAME_t_newusers">
			<xsl:attribute name="HREF"><xsl:value-of select="$root"/>U<xsl:value-of select="../USERID"/></xsl:attribute>
			<xsl:apply-templates select="."/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="USER" mode="c_subeditors">
	Author:		Andy Harris
	Context:      /H2G2/NEWUSERS-LISTING/USER-LIST/USER/USERNAME
	Purpose:	 Calls the USER object for the subeditors version of the list
	-->
	<xsl:template match="USER" mode="c_subeditors">
		<xsl:apply-templates select="." mode="r_subeditors"/>
	</xsl:template>
	<!--
	<xsl:template match="USER" mode="c_default">
	Author:		Andy Harris
	Context:      /H2G2/NEWUSERS-LISTING/USER-LIST/USER/USERNAME
	Purpose:	 Calls the USER object for the default version of the list
	-->
	<xsl:template match="USER" mode="c_default">
		<xsl:apply-templates select="." mode="r_default"/>
	</xsl:template>
	<xsl:attribute-set name="fNEWUSERS-LISTING_c_inputform"/>
	<xsl:attribute-set name="sTIMEUNITS_t_timelist"/>
	<xsl:attribute-set name="oTIMEUNITS_t_timelist"/>
	<xsl:attribute-set name="sUNITTYPE_t_timelist"/>
	<xsl:attribute-set name="oUNITTYPE_t_timelist"/>
	<xsl:attribute-set name="iNEWUSERS-LISTING_t_allradio"/>
	<xsl:attribute-set name="iNEWUSERS-LISTING_t_haveintroradio"/>
	<xsl:attribute-set name="iNEWUSERS-LISTING_t_nopostingradio"/>
	<xsl:attribute-set name="iNEWUSERS-LISTING_t_thissitecheckbox"/>
	<xsl:attribute-set name="iNEWUSERS-LISTING_t_updatedcheckbox"/>
	<xsl:attribute-set name="iNEWUSERS-LISTING_t_submitbutton"/>
</xsl:stylesheet>
