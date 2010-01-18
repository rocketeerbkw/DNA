<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	
	<!-- HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH -->
	<!-- HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH -->
	<!-- HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH -->
	<!-- HHHHHHHHHHHHHH                                     HHHHHHHHHHHHHHHHHHHHH -->
	<!-- HHHHHHHHHHHHHH        Moderation Status                      HHHHHHHHHHHHHHHHHHHHH -->
	<!-- HHHHHHHHHHHHHH                                            HHHHHHHHHHHHHHHHHHHHH -->
	<!-- HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH -->
	<!-- HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH -->
	<!-- HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH -->
	<xsl:template match="MODERATIONSTATUS" mode="c_threadspage">
		<xsl:if test="$test_IsEditor">
			<xsl:apply-templates select="." mode="r_threadspage"/>
		</xsl:if>
	</xsl:template>
	<xsl:template match="MODERATIONSTATUS" mode="r_threadspage">
		<form method="get" action="{$root}F{@ID}">
			<input type="hidden" name="cmd" value="UpdateForumModerationStatus"/>

			<xsl:apply-templates select="." mode="RADIOBUTTONS">
				<xsl:with-param name="title">Forum&nbsp;moderation&nbsp;status:</xsl:with-param>
			</xsl:apply-templates>

			<input TYPE="SUBMIT" NAME="UpdateForumModerationStatus" VALUE="Update"/>
		</form>
	</xsl:template>
	<!-- Not used anymore?? -->
	<xsl:template match="MODERATIONSTATUS" mode="USERARTICLEMOD">
		<form method="get" action="InspectUser">
			<input type="hidden" name="cmd" value="UpdateArticleModerationStatus"/>

			<xsl:apply-templates select="." mode="RADIOBUTTONS">
				<xsl:with-param name="title">Article&nbsp;moderation&nbsp;status:</xsl:with-param>
			</xsl:apply-templates>

			<input TYPE="SUBMIT" NAME="UpdateArticleModerationStatus" VALUE="Update"/>
		</form>
	</xsl:template>
	<xsl:template match="MODERATIONSTATUS" mode="c_articlepage">
		<xsl:if test="$test_IsEditor">
			<xsl:apply-templates select="." mode="r_articlepage"/>
		</xsl:if>
	</xsl:template>

	<xsl:template match="MODERATIONSTATUS" mode="r_articlepage">
		<form method="get" action="A{@ID}">
			<input type="hidden" name="cmd" value="UpdateArticleModerationStatus"/>

			<xsl:apply-templates select="." mode="RADIOBUTTONS">
				<xsl:with-param name="title">Article&nbsp;moderation&nbsp;status:</xsl:with-param>
			</xsl:apply-templates>

			<input TYPE="SUBMIT" NAME="UpdateArticleModerationStatus" VALUE="Update"/>
		</form>
	</xsl:template>
	<xsl:template match="MODERATIONSTATUS" mode="c_clubpage">
		<xsl:if test="$test_IsEditor">
			<xsl:apply-templates select="." mode="r_clubpage"/>
			 
		
		</xsl:if>
	</xsl:template>
	<xsl:template match="MODERATIONSTATUS" mode="r_clubpage">
	
		<form method="get" action="Club{/H2G2/CLUB/CLUBINFO/@ID}">
			<input type="hidden" name="action" value="UpdateClubModerationStatus"/>
			<xsl:apply-templates select="." mode="RADIOBUTTONS">
				<xsl:with-param name="title">Club&nbsp;moderation&nbsp;status:</xsl:with-param>
			</xsl:apply-templates>

			<input TYPE="SUBMIT" NAME="UpdateClubModerationStatus" VALUE="Update"/>
		</form>
	</xsl:template>

	<xsl:template match="MODERATIONSTATUS" mode="RADIOBUTTONS">
		<xsl:param name="title"/>
		<table>
			<tr>
				<xsl:value-of select="$title"/>
			</tr>
			<tr>
				<td class="modstatus">
					<input type="radio" name="status" value="0">
						<xsl:if test=". = 0">
							<xsl:attribute name="CHECKED">CHECKED</xsl:attribute>
						</xsl:if>
					</input>&nbsp;Undefined
				</td>
				<td class="modstatus">
					<input type="radio" name="status" value="1">
						<xsl:if test=". = 1">
							<xsl:attribute name="CHECKED">CHECKED</xsl:attribute>
						</xsl:if>
					</input>&nbsp;Unmoderated
				</td>
		
				<td class="modstatus">
					<input type="radio" name="status" value="2">
						<xsl:if test=". = 2">
							<xsl:attribute name="CHECKED">CHECKED</xsl:attribute>
						</xsl:if>
					</input>&nbsp;Post&nbsp;Moderated
				</td>
				<td class="modstatus">
					<input type="radio" name="status" value="3">
						<xsl:if test=". = 3">
							<xsl:attribute name="CHECKED">CHECKED</xsl:attribute>
						</xsl:if>
					</input>&nbsp;Pre&nbsp;Moderated
				</td>
			</tr>
		</table>
	</xsl:template>

</xsl:stylesheet>