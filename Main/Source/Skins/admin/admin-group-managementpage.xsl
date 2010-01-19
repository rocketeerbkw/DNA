<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<xsl:template name="GROUP-MANAGEMENT_SUBJECT">
		<div align="center">
			<xsl:call-template name="SUBJECTHEADER">
				<xsl:with-param name="text">Users Group Management</xsl:with-param>
			</xsl:call-template>
		</div>
	</xsl:template>
	<xsl:template name="GROUP-MANAGEMENT_MAINBODY">
		<table vspace="0" hspace="0" border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td align="left" valign="top" width="75%">
					<br/>
					<font face="{$fontface}" color="{$mainfontcolour}">
						<!-- put the rest inside a table to give it some space around the borders -->
						<table width="100%" cellpadding="2" cellspacing="2" border="0">
							<tr valign="top">
								<td>
									<!-- now for the main part of the page -->
									<!-- the whole thing is one big form -->
									<xsl:apply-templates select="GROUP-MANAGEMENT-FORM"/>
								</td>
							</tr>
						</table>
						<br clear="all"/>
					</font>
				</td>
				<td width="25%" align="left" valign="top">
					<xsl:call-template name="INTERNAL-TOOLS-NAVIGATION"/>
				</td>
			</tr>
		</table>
	
	</xsl:template>
<xsl:template match="GROUP-MANAGEMENT-FORM">
	<!-- display any error message first -->
	<span xsl:use-attribute-sets="WarningMessageFont">
		<xsl:for-each select="ERROR">
			<xsl:value-of select="."/><br/>
		</xsl:for-each>
	</span>
	<!-- the actual group management form -->
	<form name="ManageGroupsForm" method="post" action="{$root}ManageGroups">
			<!-- bizarre work around to allow comparison of node name to a variable => is there a better way? -->
			<table cellpadding="0" cellspacing="0" border="0" width="100%">
				<tr valign="top" align="center"><td><b>Show Membership of:</b></td></tr>
				<tr valign="top" align="center">
					<td>
							<select name="GroupName" multiple="multiple" size="{count(GROUPS-LIST/GROUP)}">
								<xsl:for-each select="GROUPS-LIST/GROUP">
									<option value="{@ID}">
										<xsl:if test="@ID = /H2G2/GROUP-MANAGEMENT-FORM/GROUP/@NAME">
											<xsl:attribute name="selected">selected</xsl:attribute>
										</xsl:if>
										<xsl:value-of select="@NAME"/>
									</option>
								</xsl:for-each>
							</select>
							<br/>
							<input type="submit" name="Refresh" value="Refresh"/>
					</td>
				</tr>
				<tr><td>&nbsp;</td></tr>
				<tr><td>&nbsp;</td></tr>
			</table>
			<table cellpadding="0" cellspacing="4" border="0" width="100%">
				<xsl:for-each select="GROUP">
					<tr valign="top" align="center">
						<td colspan="4"><b><xsl:value-of select="@NAME"/></b></td>
					</tr>
					<tr valign="top">
						<td><b>ID</b></td>
						<td><b>UserName</b></td>
						<td><b>Email</b></td>
						<td><b><nobr>Date Joined</nobr></b></td>
					</tr>
					<xsl:for-each select="USER-LIST/USER">
						<tr valign="top">
							<td>
									<a href="{$root}U{USERID}">U<xsl:value-of select="USERID"/></a>
							</td>
							<td>
									<a href="{$root}InspectUser?UserID={USERID}"><xsl:apply-templates select="USERNAME" mode="truncated"/></a>
							</td>
							<td>
									<a href="mailto:{EMAIL}"><xsl:value-of select="EMAIL"/></a>
							</td>
							<td>
									<xsl:apply-templates select="DATE-JOINED" mode="short"/>
							</td>
						</tr>
					</xsl:for-each>
					<tr><td colspan="4">&nbsp;</td></tr>
					<tr><td colspan="4">&nbsp;</td></tr>
				</xsl:for-each>
			</table>
			<br/>
			<br/>
			<br/>
			<br/>
	</form>
</xsl:template>
</xsl:stylesheet>