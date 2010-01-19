<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
						rss_categorypage.xsl
						
	Author: Rich Caudle
	Comments: The feeds for the category page have initially been
		written for use by Action Network. However, it should be 
		straight forward to extend the feeds for use on other sites.
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-->
<xsl:stylesheet version="1.0" xmlns="http://purl.org/rss/1.0/" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" exclude-result-prefixes="msxsl local s dt">
	
	
	<!--
		++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
						Variables for Category page feeds
		++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	
	<!--
		<xsl:variable name="rss1_categoryitems">
		Author:		Rich Caudle
		Purpose:	Depending on the value of the s_feed parameter, this variable will contain
		the list of items to be output in the feed, in the correct date order.
	-->
	<xsl:variable name="rss1_categoryitems">
		<xsl:for-each select="/H2G2/HIERARCHYDETAILS/MEMBERS/*">
			<xsl:sort order="descending" select="*[name()='LASTUPDATED' or name()='DATEPOSTED']/DATE/@SORT" />
			<xsl:choose>
				
				<!-- Campaigns -->
				<xsl:when test="name()='CLUBMEMBER' and (contains($rss_feedtype,'campaigns') or contains($rss_feedtype,'all'))">
					<xsl:copy-of select="."/>	
				</xsl:when>
				
				<!-- BBC articles -->
				<xsl:when test="name()='ARTICLEMEMBER' and EXTRAINFO/TYPE/@ID=1 and STATUS/@TYPE=1 and (contains($rss_feedtype,'bbcarticles') or contains($rss_feedtype,'all'))">
					<xsl:copy-of select="."/>	
				</xsl:when>
				
				<!-- User articles -->
				<xsl:when test="name()='ARTICLEMEMBER' and EXTRAINFO/TYPE/@ID=1 and STATUS/@TYPE=3 and (contains($rss_feedtype,'articles') or contains($rss_feedtype,'all'))">
					<xsl:copy-of select="."/>	
				</xsl:when>
				
				<!-- Notices -->
				<xsl:when test="name()='NOTICE' and @TYPE='Notice' and (contains($rss_feedtype,'notices') or contains($rss_feedtype,'all'))">
					<xsl:copy-of select="."/>	
				</xsl:when>
				
			</xsl:choose>
									
		</xsl:for-each>	
		
	</xsl:variable>
	
	
	<!--
		++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
						Templates for Category page feeds
		++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	
	<!--
		<xsl:template name="CATEGORY_RSS1">
		Author:		Rich Caudle
		Purpose:	Main template for all feeds on the page, called from base-pagetype.xsl
	-->
	<xsl:template name="CATEGORY_RSS1">
		<xsl:param name="mod"/>

		<xsl:choose>
			<xsl:when test="$mod='items'">
				<items xmlns="http://purl.org/rss/1.0/">
					<rdf:Seq>
						<xsl:choose>
							<xsl:when test="starts-with($rss_feedtype,'latestcontent-')">
								<xsl:apply-templates select="msxsl:node-set($rss1_categoryitems)/*[position() &lt;= $rss_maxitems]" mode="rdf_resource_categoryitem" />
							</xsl:when>
						</xsl:choose>
					</rdf:Seq>
				</items>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="starts-with($rss_feedtype,'latestcontent-')">
						<xsl:apply-templates select="msxsl:node-set($rss1_categoryitems)/*[position() &lt;= $rss_maxitems]" mode="rdf_categoryitem" />
					</xsl:when>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	


	<!--
		<xsl:template match="NOTICE" mode="rdf_resource_categoryitem">
		Author:		Rich Caudle
		Purpose:	Creates a resource item for a notice
	-->
	<xsl:template match="NOTICE" mode="rdf_resource_categoryitem">
		<rdf:li>
			<xsl:attribute name="rdf:resource">
				<xsl:call-template name="rss_trackedlink">
					<xsl:with-param name="location">
						<xsl:value-of select="concat('F', FORUMID, '?thread=', THREADID, '#', POSTID)"/>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:attribute>
		</rdf:li>
	</xsl:template>
	

	<!--
		<xsl:template match="ARTICLEMEMBER" mode="rdf_resource_categoryitem">
		Author:		Rich Caudle
		Purpose:	Creates a resource item for an article
	-->
	<xsl:template match="ARTICLEMEMBER" mode="rdf_resource_categoryitem">
		<rdf:li>
			<xsl:attribute name="rdf:resource">
				<xsl:call-template name="rss_trackedlink">
					<xsl:with-param name="location">
						<xsl:value-of select="concat('A', H2G2ID)"/>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:attribute>
		</rdf:li>
	</xsl:template>
	

	<!--
		<xsl:template match="CLUBMEMBER" mode="rdf_resource_categoryitem">
		Author:		Rich Caudle
		Purpose:	Creates a resource item for a campaign
	-->
	<xsl:template match="CLUBMEMBER" mode="rdf_resource_categoryitem">
		<rdf:li>
			<xsl:attribute name="rdf:resource">
				<xsl:call-template name="rss_trackedlink">
					<xsl:with-param name="location">
						<xsl:value-of select="concat('G', CLUBID)"/>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:attribute>
		</rdf:li>
	</xsl:template>
	


	<!--
		<xsl:template match="NOTICE" mode="rdf_categoryitem">
		Author:		Rich Caudle
		Purpose:	Creates an item with details for a notice
	-->
	<xsl:template match="NOTICE" mode="rdf_categoryitem">
		
		<xsl:variable name="tempURL">
			<xsl:call-template name="rss_trackedlink">
				<xsl:with-param name="location">
					<xsl:value-of select="concat('F', FORUMID, '?thread=', THREADID, '#', POSTID)"/>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:variable>
		
		<item rdf:about="{$tempURL}" xmlns="http://purl.org/rss/1.0/">
						
			<title>
				<xsl:call-template name="rss1_maketitle">
					<xsl:with-param name="title" select="TITLE" />
					<xsl:with-param name="content"><xsl:apply-templates select="GUIDE/BODY/node()" mode="rss1_copycontent" /></xsl:with-param>				
				</xsl:call-template>
			</title>
			<description>
				<xsl:apply-templates select="GUIDE/BODY/node()" mode="rss1_copycontent" />
			</description>
			<link>
				<xsl:value-of select="$tempURL" />
			</link>
			<dc:date>
				<xsl:apply-templates select="DATEPOSTED/DATE" mode="dc"/>
			</dc:date>
			<xsl:apply-templates select="USER" mode="rss1_creator"/>
			<dc:format>text/plain</dc:format>
		</item>
		
	</xsl:template>
	


	<!--
		<xsl:template match="ARTICLEMEMBER" mode="rdf_categoryitem">
		Author:		Rich Caudle
		Purpose:	Creates an item with details for an article
	-->
	<xsl:template match="ARTICLEMEMBER" mode="rdf_categoryitem">
		
		<xsl:variable name="tempURL">
			<xsl:call-template name="rss_trackedlink">
				<xsl:with-param name="location">
					<xsl:value-of select="concat('A', H2G2ID)"/>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:variable>
		
		<item rdf:about="{$tempURL}" xmlns="http://purl.org/rss/1.0/">
			<title>
				<xsl:value-of select="NAME"/>
			</title>
			<description>
				<xsl:apply-templates select="EXTRAINFO/AUTODESCRIPTION/text()" mode="rss1_copycontent" />
			</description>
			<link>
				<xsl:value-of select="$tempURL" />
			</link>
			<dc:date>
				<xsl:apply-templates select="LASTUPDATED/DATE" mode="dc"/>
			</dc:date>
			<xsl:apply-templates select="EDITOR/USER" mode="rss1_creator"/>
			<dc:format>text/plain</dc:format>
		</item>
		
	</xsl:template>
	

	<!--
		<xsl:template match="CLUBMEMBER" mode="rdf_categoryitem">
		Author:		Rich Caudle
		Purpose:	Creates an item with details for a campaign
	-->
	<xsl:template match="CLUBMEMBER" mode="rdf_categoryitem">
		
		<xsl:variable name="tempURL">
			<xsl:call-template name="rss_trackedlink">
				<xsl:with-param name="location">
					<xsl:value-of select="concat('G', CLUBID)"/>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:variable>
		
		<item rdf:about="{$tempURL}" xmlns="http://purl.org/rss/1.0/">
			<title>
				<xsl:value-of select="NAME"/>
			</title>
			<description>
				<xsl:apply-templates select="EXTRAINFO/AUTODESCRIPTION/text()" mode="rss1_copycontent" />
			</description>
			<link>
				<xsl:value-of select="$tempURL" />
			</link>
			<dc:date>
				<xsl:apply-templates select="LASTUPDATED/DATE" mode="dc"/>
			</dc:date>
			<dc:format>text/plain</dc:format>
		</item>
		
	</xsl:template>
	
	

</xsl:stylesheet>