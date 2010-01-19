<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
		<!--
	The locked status page for the moderation tools
-->

<xsl:template match='H2G2[@TYPE="MODERATE-STATS"]'>
	<html>
		<head>
			<!-- prevent browsers caching the page -->
			<meta http-equiv="Cache-Control" content="no cache"/>
			<meta http-equiv="Pragma" content="no cache"/>
			<meta http-equiv="Expires" content="0"/>
			<META NAME="robots" CONTENT="{$robotsetting}"/>
			<title>h2g2 : Moderation Stats</title>
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
			<font face="{$fontface}" size="2" color="black">
				<h2 align="center">Moderation Stats Page</h2>
				<form method="post" action="{$root}ModerateStats">
					<table border="0" cellPadding="0" cellSpacing="0" width="100%">
						<tr valign="top">
							<td align="left">
								<font face="Arial" size="2" color="black">
									Logged in as <b><xsl:value-of select="/H2G2/VIEWING-USER/USER/USERNAME"/></b>
								</font>
							</td>
							<td align="right">
								<font face="Arial" size="2" color="black">
									<a href="{$root}Moderate">Moderation Home Page</a>
								</font>
							</td>
						</tr>
					</table>
					<br/>
					<!-- give info if user is active and what they have locked to them -->
					<xsl:for-each select="MODERATION-STATS">
						<div align="center">
							<table border="1" cellPadding="4" cellSpacing="0">
								<tr align="center" vAlign="top">
									<td colspan="7"><b><font face="Arial" size="3" color="black">Total Locked/Referred Items per User</font></b></td>
								</tr>
								<tr align="center" vAlign="top">
									<td><b><font face="Arial" size="2" color="black">User</font></b></td>
									<td><b><font face="Arial" size="2" color="black">Status</font></b></td>
									<td><b><font face="Arial" size="2" color="black">Entries</font></b></td>
									<td><b><font face="Arial" size="2" color="black">Postings</font></b></td>
									<td><b><font face="Arial" size="2" color="black">Nicknames</font></b></td>
									<td><b><font face="Arial" size="2" color="black">General</font></b></td>
									<td><b><font face="Arial" size="2" color="black">Unlock</font></b></td>
								</tr>
								<xsl:for-each select="USER">
									<tr align="center" vAlign="top">
										<td align="left"><font face="Arial" size="2" color="black">
											<xsl:choose>
												<xsl:when test="/H2G2/VIEWING-USER/USER/GROUPS/EDITOR">
													<a href="{$root}Moderate?UserID={USERID}"><xsl:value-of select="USERNAME"/></a>
												</xsl:when>
												<xsl:otherwise><xsl:value-of select="USERNAME"/></xsl:otherwise>
											</xsl:choose>
										</font></td>
										<td><font face="Arial" size="2" color="black">
											<xsl:choose>
												<xsl:when test="SESSION/MINUTES-IDLE = 0">Active</xsl:when>
												<xsl:when test="SESSION/ONLINE = 1">Idle <xsl:value-of select="SESSION/MINUTES-IDLE"/> mins</xsl:when>
												<xsl:when test="SESSION/ONLINE = 0">Offline</xsl:when>
												<xsl:otherwise><font color="red">Unknown</font></xsl:otherwise>
											</xsl:choose>
										</font></td>
										<td><font face="Arial" size="2" color="black"><xsl:value-of select="TOTAL-ENTRIES"/></font></td>
										<td><font face="Arial" size="2" color="black"><xsl:value-of select="TOTAL-POSTS"/></font></td>
										<td><font face="Arial" size="2" color="black"><xsl:value-of select="TOTAL-NICKNAMES"/></font></td>
										<td><font face="Arial" size="2" color="black"><xsl:value-of select="TOTAL-GENERAL"/></font></td>
										<td><font face="Arial" size="2" color="black"><a href="{$root}ModerateStats?UserID={USERID}&amp;Unlock=1">Unlock All</a></font></td>
									</tr>
								</xsl:for-each>
							</table>
							<br/><br/>
						</div>
					</xsl:for-each>
				</form>
			</font>
			</div>
		</body>
	</html>
</xsl:template>
</xsl:stylesheet>