<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
	<!ENTITY space "<xsl:text xmlns:xsl='http://www.w3.org/1999/XSL/Transform'> </xsl:text>">
]>
<xsl:stylesheet exclude-result-prefixes="msxsl local s dt" version="1.0"
	xmlns:dt="urn:schemas-microsoft-com:datatypes" xmlns:local="#local-functions"
	xmlns:msxsl="urn:schemas-microsoft-com:xslt"
	xmlns:s="urn:schemas-microsoft-com:xml-data"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
						Watched User Object
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<!--
	<xsl:template match="WATCHED-USER-LIST" mode="r_userpage">
	Description: Presentation of the WATCHED-USER-LIST object
 	-->
	<xsl:template match="WATCHED-USER-LIST" mode="r_userpage">
		<a name="contacts" />
		<div class="box default" id="contacts">
			<div class="boxTitleTop">
				<strong>contacts</strong>
			</div>
			<p>
				<xsl:apply-templates mode="r_introduction" select="." />
			</p>
			<xsl:apply-templates mode="c_watcheduser" select="USER" />
			<div class="hr" />
			<div class="infoLink">
				<a href="{$root}sitehelpprofile#contacts">what is a contacts list?</a>
			</div>
		</div>
	</xsl:template>

	<!--
	<xsl:template match="USER" mode="r_watcheduser">
	Description: Presentation of the WATCHED-USER-LIST/USER object
 	-->
	<xsl:template match="USER" mode="r_watcheduser">
		<div class="contactName">
			<a href="{$root}U{USERID}">
				<xsl:choose>
					<xsl:when test="string-length(FIRSTNAMES) &gt; 0">
						<xsl:value-of select="FIRSTNAMES" />&nbsp; <xsl:value-of
							select="LASTNAME" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="USERNAME" />
					</xsl:otherwise>
				</xsl:choose>
			</a>
		</div>
		<xsl:if test="$ownerisviewer=1">
			<div class="removeContact">
				<a href="{$root}Watch{../@USERID}?delete=yes&amp;duser={USERID}"
					>remove</a>
				<img alt="" height="7" src="{$imagesource}furniture/rightarrow.gif"
					width="9" />
			</div>
		</xsl:if>
	</xsl:template>

	<xsl:template match="WATCHED-USER-LIST" mode="r_introduction">
		<xsl:choose>
			<xsl:when test="$ownerisviewer=1">
				<xsl:choose>
					<xsl:when test="USER">
						<xsl:copy-of select="$m_namesonyourfriendslist" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:copy-of select="$m_youremptyfriendslist" />
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="USER">
						<xsl:copy-of select="$m_friendslistofuser" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:choose>
							<xsl:when test="string-length(/H2G2/PAGE-OWNER/USER/FIRSTNAMES) &gt; 0">
								<xsl:value-of select="/H2G2/PAGE-OWNER/USER/FIRSTNAMES" />&nbsp;<xsl:value-of
									select="/H2G2/PAGE-OWNER/USER/LASTNAME" />
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="/H2G2/PAGE-OWNER/USER/USERNAME" />
							</xsl:otherwise>
						</xsl:choose>
						<xsl:copy-of select="$m_hasntaddedfriends" />
						<br />
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!--
	<xsl:template match="USER" mode="r_watcheduserdelete">
	Description: Presentation of the 'Delete' link
 	-->
	<xsl:template match="USER" mode="r_watcheduserdelete">
		<xsl:apply-imports />
	</xsl:template>
	
	<!--
	<xsl:template match="WATCHED-USER-LIST" mode="r_friendsjournals">
	Description: Presentation of the 'Views friends journals' link
 	-->
	<xsl:template match="WATCHED-USER-LIST" mode="r_friendsjournals">
		<xsl:apply-imports />
		<br />
	</xsl:template>
	
	<!--
	<xsl:template match="WATCHED-USER-LIST" mode="r_deletemany">
	Description: Presentation of the 'Delete many friends' link
 	-->
	<xsl:template match="WATCHED-USER-LIST" mode="r_deletemany">
		<xsl:apply-imports />
		<br />
	</xsl:template>

</xsl:stylesheet>