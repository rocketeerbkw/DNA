<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions"
	xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes"
	xmlns:dc="http://purl.org/dc/elements/1.1/"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	exclude-result-prefixes="msxsl local s dt">

	<xsl:variable name="club_url">
		<xsl:call-template name="rss_trackedlink">
			<xsl:with-param name="location">
				<xsl:value-of select="concat('G', /H2G2/CLUB/CLUBINFO/@ID)"/>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:variable>

	<!-- 
	
	-->
	<xsl:template name="CLUB_RSS1">
		<xsl:param name="mod"/>
		<xsl:choose>
			<xsl:when test="$mod='items'">
				<items xmlns="http://purl.org/rss/1.0/">
					<rdf:Seq>
						<xsl:if test="key('feedtype', 'members')">
							<xsl:apply-templates select="CLUB/POPULATION/TEAM/MEMBER"
								mode="rdf_resource_clubpage"/>
						</xsl:if>
						<xsl:if test="key('feedtype', 'journal')">
							<xsl:apply-templates select="CLUB/JOURNAL/JOURNALPOSTS/POST[not(@HIDDEN=1)]"
								mode="rdf_resource_clubpagejournal"/>
						</xsl:if>
					</rdf:Seq>
				</items>
			</xsl:when>
			<xsl:otherwise>
				<xsl:if test="key('feedtype', 'members')">
					<xsl:apply-templates select="CLUB/POPULATION/TEAM/MEMBER" mode="rss1_clubpage"/>
				</xsl:if>
				<xsl:if test="key('feedtype', 'journal')">
					<xsl:apply-templates select="CLUB/JOURNAL/JOURNALPOSTS/POST[not(@HIDDEN=1)]"
						mode="rss1_clubpagejournal"/>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- 
	
	-->
	<xsl:template match="MEMBER" mode="rdf_resource_clubpage">
		<rdf:li rdf:resource="{concat($thisserver, $root, 'U', USER/USERID)}"/>
	</xsl:template>
	<!-- 
	
	-->
	<xsl:template match="MEMBER" mode="rss1_clubpage">
		<item rdf:about="{concat($thisserver, $root, 'U', USER/USERID)}"
			xmlns="http://purl.org/rss/1.0/">
			<title>
				<xsl:value-of select="USER/USERNAME"/>
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

			<dc:date>
				<xsl:apply-templates select="DATEJOINED/DATE" mode="dc"/>
			</dc:date>
		</item>
	</xsl:template>
	<!-- 
	
	-->
	<xsl:template match="POST" mode="rdf_resource_clubpagejournal">
		<rdf:li rdf:resource="{$club_url}#p{@POSTID}"/>
	</xsl:template>
	<!--

	-->
	<xsl:template match="POST" mode="rss1_clubpagejournal">
		<item rdf:about="{$club_url}#p{@POSTID}" xmlns="http://purl.org/rss/1.0/">
			<xsl:element name="title" namespace="{$thisnamespace}">
				<xsl:call-template name="rss1_maketitle">
					<xsl:with-param name="title" select="SUBJECT" />
					<xsl:with-param name="content" select="TEXT" />				
				</xsl:call-template>
			</xsl:element>
			<xsl:element name="description" namespace="{$thisnamespace}">
				<xsl:call-template name="validChars">
					<xsl:with-param name="string"><xsl:value-of select="TEXT"/></xsl:with-param>			
				</xsl:call-template>
			</xsl:element>
			<xsl:element name="link" namespace="{$thisnamespace}">
				<xsl:value-of select="$club_url"/>
			</xsl:element>
			<dc:date>
				<xsl:apply-templates select="DATEPOSTED/DATE" mode="dc"/>
			</dc:date>
		</item>
	</xsl:template>

</xsl:stylesheet>
