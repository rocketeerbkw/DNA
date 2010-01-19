<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" exclude-result-prefixes="msxsl local s dt">
	<!-- 
	
	-->	
	
	<!-- 
	
	-->
	<xsl:template name="INDEX_RSS1">
		<xsl:param name="mod"/>
		<xsl:choose>
			<xsl:when test="$mod='items'">
				<items xmlns="http://purl.org/rss/1.0/">
					<rdf:Seq>
						<xsl:apply-templates select="INDEX/INDEXENTRY" mode="rdf_resource_indexpage"/>
					</rdf:Seq>
				</items>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="INDEX/INDEXENTRY" mode="rss1_indexpage"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- 
	
	-->
	<xsl:template match="INDEXENTRY" mode="rdf_resource_indexpage">
		<rdf:li rdf:resource="{$thisserver}{$root}A{H2G2ID}"/>
	</xsl:template>
	<!-- 
	
	-->
	<xsl:template match="INDEXENTRY" mode="rss1_indexpage">
		<item rdf:about="{$thisserver}{$root}A{H2G2ID}" xmlns="http://purl.org/rss/1.0/">
		<xsl:if test="/H2G2/CURRENTSITEURLNAME='filmnetwork'">
		<xsl:element name="url" namespace="{$thisnamespace}">
			<xsl:value-of select="concat($thisserver, $root, 'A', H2G2ID)"/>
		</xsl:element>		
		<xsl:element name="image_small" namespace="{$thisnamespace}">
			<xsl:value-of select="concat('http://www.bbc.co.uk/filmnetwork/images/shorts/A', H2G2ID, '_small.jpg')"/>
		</xsl:element>		
		<xsl:element name="image_medium" namespace="{$thisnamespace}">
			<xsl:value-of select="concat('http://www.bbc.co.uk/filmnetwork/images/shorts/A', H2G2ID, '_medium.jpg')"/>
		</xsl:element>				
		</xsl:if>
		<xsl:element name="title" namespace="{$thisnamespace}">
			<xsl:call-template name="validChars">
				<xsl:with-param name="string" select="SUBJECT"/>
			</xsl:call-template>		
		</xsl:element>
		<xsl:element name="director" namespace="{$thisnamespace}">
			<xsl:call-template name="validChars">
				<xsl:with-param name="string" select="EXTRAINFO/DIRECTORSNAME"/>
			</xsl:call-template>
		</xsl:element>		
		<xsl:element name="genre" namespace="{$thisnamespace}">
			<xsl:choose>
				<xsl:when test="EXTRAINFO/TYPE/@ID='35'">music</xsl:when>
				<xsl:when test="EXTRAINFO/TYPE/@ID='34'">experimental</xsl:when>
				<xsl:when test="EXTRAINFO/TYPE/@ID='33'">animation</xsl:when>
				<xsl:when test="EXTRAINFO/TYPE/@ID='32'">documentary</xsl:when>
				<xsl:when test="EXTRAINFO/TYPE/@ID='31'">comedy</xsl:when>
				<xsl:when test="EXTRAINFO/TYPE/@ID='30'">drama</xsl:when>
			</xsl:choose>
		</xsl:element>		
		<xsl:element name="region" namespace="{$thisnamespace}">
			<xsl:value-of select="EXTRAINFO/REGION"/>
		</xsl:element>
		<xsl:element name="description" namespace="{$thisnamespace}">
			<xsl:call-template name="validChars">
					<xsl:with-param name="string" select="EXTRAINFO/DESCRIPTION"/>
			</xsl:call-template>
		</xsl:element>		
		<xsl:element name="duration" namespace="{$thisnamespace}">
			<xsl:variable name="minutes">
				<xsl:value-of select="EXTRAINFO/FILMLENGTH_MINS"/>
			</xsl:variable>
			<xsl:if test="(EXTRAINFO/FILMLENGTH_SECS) &lt; 30">
				<xsl:value-of select="EXTRAINFO/FILMLENGTH_MINS"/><xsl:text> min</xsl:text>
					<xsl:choose>
						<xsl:when test="EXTRAINFO/FILMLENGTH_MINS!=1">s</xsl:when>
					</xsl:choose>
			</xsl:if>		
			<xsl:if test="(EXTRAINFO/FILMLENGTH_SECS) &gt; 29">
				<xsl:value-of select="$minutes + 1"/><xsl:text> min</xsl:text>
					<xsl:choose>
						<xsl:when test="EXTRAINFO/FILMLENGTH_MINS!=1">s</xsl:when>
					</xsl:choose>
			</xsl:if>					
		</xsl:element>	
		<dc:date>
			<xsl:apply-templates select="DATECREATED/DATE" mode="dc"/>
		</dc:date>	
		
		<xsl:if test="/H2G2/CURRENTSITEURLNAME='filmnetwork'">		
		<xsl:element name="content_warning" namespace="{$thisnamespace}">
			<xsl:value-of select="EXTRAINFO/STANDARD_WARNING"/>
		</xsl:element>	
		<xsl:element name="aspect_ratio" namespace="{$thisnamespace}">
			<xsl:value-of select="EXTRAINFO/PLAYER_SIZE"/>
		</xsl:element>		
		<xsl:element name="video" namespace="{$thisnamespace}">
			<xsl:value-of select="concat('http://www.bbc.co.uk/mediaselector/check/filmnetwork/media/shorts/A', H2G2ID, '?size=', EXTRAINFO/PLAYER_SIZE, '&amp;bgc=c0c0c0&amp;nbwm=1&amp;bbwm=1&amp;nbram=1&amp;bbram=1')"/>
		</xsl:element>							
		</xsl:if>
		</item>

	</xsl:template>
</xsl:stylesheet>
