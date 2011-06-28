<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<xsl:template name="SCOUT-RECOMMENDATIONS_SUBJECT">
		<xsl:call-template name="SUBJECTHEADER">
			<xsl:with-param name="text">Scout Recommendations</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template name="SCOUT-RECOMMENDATIONS_MAINBODY">
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
									<xsl:apply-templates select="UNDECIDED-RECOMMENDATIONS"/>
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
	<!--
	Template to match the undecied recommendations list in e.g. the scout recommendations
	page, and turn it into a suitable form
-->
	<xsl:template match="UNDECIDED-RECOMMENDATIONS">
		<!-- create the form HTML -->
		<form name="ScoutRecommendationsForm" method="get" action="{$root}ScoutRecommendations">
			<table width="100%" border="0" cellspacing="0" cellpadding="2">
				<tr valign="top">
					<td>
						<font xsl:use-attribute-sets="mainfont">
							<b>ID</b>
						</font>
					</td>
					<td>&nbsp;</td>
					<td>
						<font xsl:use-attribute-sets="mainfont">
							<b>Subject</b>
						</font>
					</td>
					<td>&nbsp;</td>
					<td>
						<font xsl:use-attribute-sets="mainfont">
							<b>Author</b>
						</font>
					</td>
					<td>&nbsp;</td>
					<td>
						<font xsl:use-attribute-sets="mainfont">
							<b>Recommended</b>
						</font>
					</td>
					<td>&nbsp;</td>
					<td>
						<font xsl:use-attribute-sets="mainfont">
							<b>Scout</b>
						</font>
					</td>
					<xsl:if test="/H2G2/VIEWING-USER/USER/GROUPS/GROUP/NAME='EDITOR'">
						<td>&nbsp;</td>
						<td>
							<font xsl:use-attribute-sets="mainfont">
								<b>Decision</b>
							</font>
						</td>
					</xsl:if>
				</tr>
				<xsl:for-each select="ARTICLE-LIST/ARTICLE">
					<tr valign="top">
						<td>
							<font xsl:use-attribute-sets="mainfont">A<xsl:value-of select="H2G2-ID"/>
							</font>
						</td>
						<td>&nbsp;</td>
						<td>
							<font xsl:use-attribute-sets="mainfont">
								<a target="_blank" href="{$root}A{H2G2-ID}">
									<xsl:value-of select="SUBJECT"/>
								</a>
							</font>
						</td>
						<td>&nbsp;</td>
						<td>
							<font xsl:use-attribute-sets="mainfont">
								<a target="_blank" href="{$root}U{EDITOR/USER/USERID}">
									<xsl:apply-templates select="EDITOR/USER/USERNAME" mode="truncated"/>
								</a>
							</font>
						</td>
						<td>&nbsp;</td>
						<td>
							<font xsl:use-attribute-sets="mainfont">
								<xsl:apply-templates select="DATE-RECOMMENDED/DATE" mode="short"/>
							</font>
						</td>
						<td>&nbsp;</td>
						<td>
							<font xsl:use-attribute-sets="mainfont">
								<a target="_blank" href="{$root}U{SCOUT/USER/USERID}">
									<xsl:apply-templates select="SCOUT/USER/USERNAME" mode="truncated"/>
								</a>
							</font>
						</td>
						<xsl:if test="/H2G2/VIEWING-USER/USER/GROUPS/GROUP/NAME='EDITOR'">
							<td>&nbsp;</td>
							<td>
								<font xsl:use-attribute-sets="mainfont">
									<input type="button" value="Accept">
										<xsl:attribute name="onClick">
                      javascript:window.open('https://ssl.bbc.co.uk/dna/moderation/ProcessRecommendation?RecommendationID=' + <xsl:value-of select="RECOMMENDATION-ID"/> + '&amp;Reject=0' + '&amp;mode=POPUP', 'ProcessRecommendation', 'resizable=1,scrollbars=1,width=750,height=550')</xsl:attribute>
									</input>
								&nbsp;
								<input type="button" value="Reject">
										<xsl:attribute name="onClick">
                      javascript:window.open('https://ssl.bbc.co.uk/dna/moderation/ProcessRecommendation?RecommendationID=' + <xsl:value-of select="RECOMMENDATION-ID"/> + '&amp;Accept=0' + '&amp;mode=POPUP', 'ProcessRecommendation', 'resizable=1,scrollbars=1,width=375,height=550')</xsl:attribute>
									</input>
								</font>
							</td>
						</xsl:if>
					</tr>
				</xsl:for-each>
			</table>
		</form>
	</xsl:template>

</xsl:stylesheet>