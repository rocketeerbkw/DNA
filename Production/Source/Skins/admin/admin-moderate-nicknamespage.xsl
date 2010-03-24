<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
<!--
	Nickname moderation page
-->

<xsl:template match='H2G2[@TYPE="MODERATE-NICKNAMES"]'>
	<html>
		<head>
			<!-- prevent browsers caching the page -->
			<meta http-equiv="Cache-Control" content="no cache"/>
			<meta http-equiv="Pragma" content="no cache"/>
			<meta http-equiv="Expires" content="0"/>
			<META NAME="robots" CONTENT="{$robotsetting}"/>
			<title>h2g2 Moderation: Nicknames</title>
			<style type="text/css">
				<xsl:comment>
					DIV.ModerationTools A { color: blue}
					DIV.ModerationTools A.active { color: red}
					DIV.ModerationTools A.visited { color: darkblue}
					DIV.ModerationTools A:hover   { text-decoration: underline ! important; color: red}
				</xsl:comment>
			</style>
		</head>
		<body bgColor="lightblue">
			<div class="ModerationTools">
			<font face="Arial" size="2" color="black">
				<h2 align="center">Nickname Moderation</h2>
				<table width="100%">
					<tr>
						<td align = "left" valign="top">
							<font face="Arial" size="2" color="black">
								Logged in as <b><xsl:value-of select="/H2G2/VIEWING-USER/USER/USERNAME"/></b>
							</font>
						</td>
						<td align = "right" valign="top">
							<font face="Arial" size="2" color="black">
								<a href="{$root}Moderate">Moderation Home Page</a>
							</font>
						</td>
					</tr>
				</table>
				<br/>
				<xsl:if test="NICKNAME-MODERATION-FORM/MESSAGE">
					<font face="Arial" size="2" color="black">
						<xsl:choose>
							<xsl:when test="NICKNAME-MODERATION-FORM/MESSAGE/@TYPE = 'NONE-LOCKED'">
								<b>You currently have no nicknames allocated to you for moderation. Click 'Process' to be 
								allocated the next batch of postings waiting to be moderated.</b>
								<br/>
							</xsl:when>
							<xsl:when test="NICKNAME-MODERATION-FORM/MESSAGE/@TYPE = 'EMPTY-QUEUE'">
								<b>Currently there are no nicknames awaiting moderation.</b>
								<br/>
							</xsl:when>
							<xsl:otherwise>
								<b><xsl:value-of select="NICKNAME-MODERATION-FORM/MESSAGE"/></b>
								<br/>
							</xsl:otherwise>
						</xsl:choose>
					</font>
				</xsl:if>
				<form action="{$root}ModerateNicknames" method="post" name="NicknameModerationForm">
					<xsl:if test="NICKNAME-MODERATION-FORM/NICKNAME">
						<table border="1" cellPadding="2" cellSpacing="0">
							<!-- do the column headings -->
							<tbody>
								<tr align="left" vAlign="top">
									<td><b><font face="Arial" size="2" color="black">User ID</font></b></td>
									<td><b><font face="Arial" size="2" color="black">Nickname</font></b></td>
									<td><b><font face="Arial" size="2" color="black">First name</font></b></td>
									<td><b><font face="Arial" size="2" color="black">Last name</font></b></td>
									<td><b><font face="Arial" size="2" color="black">Site</font></b></td>
									<td><b><font face="Arial" size="2" color="black">Pass?</font></b></td>
								</tr>
							</tbody>
							<!-- and then fill the table -->
							<tbody align="left" vAlign="top">
								<xsl:for-each select="NICKNAME-MODERATION-FORM/NICKNAME">
									<tr>
										<td align="left" vAlign="top">
											<font face="Arial" size="2" color="black">
												<xsl:apply-templates select="USER/USERID"/>
											</font>
											<input type="hidden" name="UserID">
												<xsl:attribute name="value"><xsl:value-of select="USER/USERID"/></xsl:attribute>
											</input>
											<input type="hidden" name="ModID">
												<xsl:attribute name="value"><xsl:value-of select="MODERATION-ID"/></xsl:attribute>
											</input>
											<input type="hidden" name="UserName">
												<xsl:attribute name="value"><xsl:value-of select="USER/USERNAME"/></xsl:attribute>
											</input>
											<input type="hidden" name="SiteID">
												<xsl:attribute name="value"><xsl:value-of select="SITEID"/></xsl:attribute>
											</input>
										</td>
										<td align="left" vAlign="top">
											<font face="Arial" size="2" color="black">
												<xsl:choose>
													<xsl:when test="string-length(USER/USERNAME) &gt; 0">
														<xsl:apply-templates select="USER"/>
													</xsl:when>
													<xsl:otherwise>None set</xsl:otherwise>
												</xsl:choose>
											</font>
										</td>
										<td>
											<font face="Arial" size="2" color="black">
												<xsl:value-of select="USER/FIRSTNAMES"/><xsl:text>&nbsp;</xsl:text>
											</font>
										</td>
										<td>
											<font face="Arial" size="2" color="black">
												<xsl:value-of select="USER/LASTNAME"/><xsl:text>&nbsp;</xsl:text>
											</font>
										</td>
										<td>
											<font face="Arial" size="2" color="black">
												<xsl:value-of select="SITENAME"/>
											</font>
										</td>
										<td align="left" vAlign="top">
											<font face="Arial" size="2" color="black">
												<select name="Pass">
												<OPTION value="1" selected="selected">Pass</OPTION>
												<OPTION value="0">Fail</OPTION>
												</select>
											</font>
										</td>
									</tr>
								</xsl:for-each>
							</tbody>
						</table>
					</xsl:if>
					<!-- form buttons -->
					<table width="100%">
						<tr>
							<td valign="top" align="left">
								<font face="Arial" size="2" color="black">
									<input type="submit" name="Next" value="Process" title="Process these nicknames and then fetch the next batch" alt="Process these nicknames and then fetch the next batch"/>
									<xsl:text> </xsl:text>
									<input type="submit" name="Done" value="Process &amp; go to Moderation Home" title="Process these nicknames and then go to Moderation Home" alt="Process these nicknames and then go to Moderation Home"/>
								</font>
							</td>
						</tr>
					</table>
					<br/>
				</form>
			</font>
		</div>
		</body>
	</html>
</xsl:template>
</xsl:stylesheet>