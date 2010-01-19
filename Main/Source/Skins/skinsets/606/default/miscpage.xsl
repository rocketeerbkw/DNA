<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-	microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<xsl:import href="../../../base/base-miscpage.xsl"/>
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	LOGOUT_MAINBODY Page - Level  template
	Use: Page presented after you logout
	-->
	<xsl:template name="LOGOUT_MAINBODY">
		
	<!-- DEBUG -->
	<xsl:call-template name="TRACE">
		<xsl:with-param name="message">LOGOUT_MAINBODY</xsl:with-param>
		<xsl:with-param name="pagename">miscpage.xsl</xsl:with-param>
	</xsl:call-template>
	<!-- DEBUG -->
		<table width="100%" cellpadding="5" cellspacing="0" border="0" class="post">
			<tr>
				<td class="body">
					<font xsl:use-attribute-sets="mainfont">
						<xsl:copy-of select="$m_logoutblurb"/>
					</font>
				</td>
			</tr>
		</table>
	</xsl:template>
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	SIMPLEPAGE_MAINBODY Page - Level  template
	Use: Usually consists of a simple message / GuideML article
	-->
	<xsl:template name="SIMPLEPAGE_MAINBODY">
	
	<!-- DEBUG -->
	<xsl:call-template name="TRACE">
		<xsl:with-param name="message">SIMPLEPAGE_MAINBODY</xsl:with-param>
		<xsl:with-param name="pagename">miscpage.xsl</xsl:with-param>
	</xsl:call-template>
	<!-- DEBUG -->
	
		<table width="100%" cellpadding="5" cellspacing="0" border="0" class="post">
			<tr>
				<td class="body">
					<font xsl:use-attribute-sets="mainfont">
						<xsl:apply-templates select="ARTICLE/GUIDE"/>
						<xsl:apply-templates select="ARTICLE/USERACTION" mode="t_simplepage"/> 
					</font>
				</td>
			</tr>
		</table>
	</xsl:template>
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	NOTFOUND_MAINBODY Page - Level  template
	Use: Page presented when an incorrect URL is entered 
	-->
	<xsl:template name="NOTFOUND_MAINBODY">
	
	<!-- DEBUG -->
	<xsl:call-template name="TRACE">
		<xsl:with-param name="message">NOTFOUND_MAINBODY</xsl:with-param>
		<xsl:with-param name="pagename">miscpage.xsl</xsl:with-param>
	</xsl:call-template>
	<!-- DEBUG -->
	
	<table width="100%" cellpadding="5" cellspacing="0" border="0" class="post">
			<tr>
				<td class="body">
					<font xsl:use-attribute-sets="mainfont">
						<xsl:copy-of select="$m_notfoundbody"/>
					</font>
				</td>
			</tr>
		</table>
	</xsl:template>
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	ERROR_MAINBODY Page - Level  template
	Use: Page displayed when user makes certain errors
	-->
	<xsl:template name="ERROR_MAINBODY">
	<!-- DEBUG -->
	<xsl:call-template name="TRACE">
		<xsl:with-param name="message">ERROR_MAINBODY</xsl:with-param>
		<xsl:with-param name="pagename">miscpage.xsl</xsl:with-param>
	</xsl:call-template>
	<!-- DEBUG -->
	
	<table width="100%" cellpadding="5" cellspacing="0" border="0" class="post">
			<tr>
				<td class="body">
				<font xsl:use-attribute-sets="mainfont">
						<xsl:apply-templates select="ERROR" mode="t_errorpage"/>
					</font>
				</td>
			</tr>
		</table>
	</xsl:template>
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	SUBSCRIBE_MAINBODY Page - Level  template
	Use: Page displayed after user subscribes to a conversation / article
	-->
	<xsl:template name="SUBSCRIBE_MAINBODY">
	
	<!-- DEBUG -->
	<xsl:call-template name="TRACE">
		<xsl:with-param name="message">SUBSCRIBE_MAINBODY</xsl:with-param>
		<xsl:with-param name="pagename">miscpage.xsl</xsl:with-param>
	</xsl:call-template>
	<!-- DEBUG -->
	
		<h1><img src="{$imagesource}h1_error.gif" alt="sorry: there has been an error" width="353" height="26" /></h1>
		<xsl:apply-templates select="SUBSCRIBE-RESULT" mode="t_subscribepage"/>
			<br/><br/>
		<xsl:apply-templates select="RETURN-TO" mode="t_subscribepage"/>
	</xsl:template>
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	SITECHANGE_MAINBODY Page - Level  template
	Use: Page displayed when user tries to leave a 'walled garden' site 
	-->
	<xsl:template name="SITECHANGE_MAINBODY">
	
	<!-- DEBUG -->
	<xsl:call-template name="TRACE">
		<xsl:with-param name="message">SITECHANGE_MAINBODY</xsl:with-param>
		<xsl:with-param name="pagename">miscpage.xsl</xsl:with-param>
	</xsl:call-template>
	<!-- DEBUG -->
	
		<font xsl:use-attribute-sets="mainfont">
			<xsl:copy-of select="$m_sitechangemessage"/>
		</font>
	</xsl:template>
	
	<xsl:template match="SCHEDULE" mode="setactivelink" priority="2">
		<xsl:choose>
			<xsl:when test="EVENT[@ACTIVE=0]">
				<a href="{$root}MessageBoardSchedule?action=setactive">
					<!--
					<img src="http://sandbox0.bu.bbc.co.uk/new_messageboards/images/config_system/shared/emergency_reopen.gif" width="131" height="46" alt="Board re-opened" border="0"/>
					-->
					<xsl:text>[Board re-open]</xsl:text>
				</a>
				<hr/>
			</xsl:when>
			<xsl:otherwise>
				<a href="{$root}MessageBoardSchedule?action=setinactive">
					<!--
					<img src="http://sandbox0.bu.bbc.co.uk/new_messageboards/images/config_system/shared/emergency_stop.gif" width="131" height="46" alt="Stop the board - emergency closure" border="0"/>
					-->
					<xsl:text>[Stop the board - emergency closure]</xsl:text>
				</a>
				<hr/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="SITETOPICSEMERGENCYCLOSED" mode="setactivelink" priority="2">
		<xsl:choose>
			<xsl:when test=".=1">
				<a href="{$root}MessageBoardSchedule?action=setsitetopicsactive">
					<!--
					<img src="http://sandbox0.bu.bbc.co.uk/new_messageboards/images/config_system/shared/emergency_reopen.gif" width="131" height="46" alt="Board re-opened" border="0"/>
					-->
					<xsl:text>[Board re-open]</xsl:text>
				</a>
				<hr/>
			</xsl:when>
			<xsl:otherwise>
				<a href="{$root}MessageBoardSchedule?action=setsitetopicsinactive">
					<!--
					<img src="http://sandbox0.bu.bbc.co.uk/new_messageboards/images/config_system/shared/emergency_stop.gif" width="131" height="46" alt="Stop the board - emergency closure" border="0"/>
					-->
					<xsl:text>[Stop the board - emergency closure]</xsl:text>
				</a>
				<hr/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
</xsl:stylesheet>