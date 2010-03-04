<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<xsl:import href="../base-clubpage.xsl"/>
	<!-- 
	
	-->
	<xsl:template name="CLUB_RSS">
		<xsl:if test="key('feedtype', 'journal') or not(/H2G2/PARAMS/PARAM[NAME='s_feed'])">
			<!-- journal spcified or nothing specified - ie default -->
			<xsl:apply-templates select="CLUB/JOURNAL" mode="rss91"/>
		</xsl:if>
		<xsl:if test="key('feedtype', 'members')">
			<xsl:apply-templates select="CLUB/POPULATION" mode="rss91"/>
		</xsl:if>
	</xsl:template>
	<xsl:variable name="club_url" select="concat($thisserver, $root, 'G', /H2G2/CLUB/CLUBINFO/@ID)"/>
	<!-- 
	
	-->
	<xsl:template match="JOURNAL" mode="rss91">
		<xsl:apply-templates select="JOURNALPOSTS/POST" mode="rss91_club"/>
	</xsl:template>
	<!-- 
	
	-->
	<xsl:template match="POST" mode="rss91_club">
		<item>
			<title>
				<xsl:value-of select="SUBJECT"/>
			</title>
			<description>
				<xsl:value-of select="TEXT"/>
			</description>
			<link>
				<xsl:value-of select="$club_url"/>
			</link>
		</item>
	</xsl:template>
	<!-- 
	
	-->
	<xsl:template match="POPULATION" mode="rss91">
		<xsl:apply-templates select="TEAM/MEMBER" mode="rss91"/>
	</xsl:template>
	<!-- 
	
	-->
	<xsl:template match="MEMBER" mode="rss91">
		<item>
			<title>
				<xsl:apply-templates select="USER" mode="username"/>
				<xsl:text> </xsl:text>
			</title>
			<description>
				<xsl:choose>
					<xsl:when test="../@TYPE='OWNER'">Owner</xsl:when>
					<xsl:when test="../@TYPE='MEMBER'">Member</xsl:when>
				</xsl:choose>
				<xsl:choose>
					<xsl:when test="USER/AREA[string()]"> from <xsl:value-of select="USER/AREA"/>
					</xsl:when>
					<xsl:otherwise>, no location given</xsl:otherwise>
				</xsl:choose>
			</description>
			<link>
				<xsl:value-of select="concat($thisserver, $root, 'U', USER/USERID)"/> 
			</link>
		</item>
	</xsl:template>
</xsl:stylesheet>
