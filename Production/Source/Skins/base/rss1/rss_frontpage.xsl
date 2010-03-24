<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:tom="http://purl.org/rss/1.0/" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" xmlns:dc="http://purl.org/dc/elements/1.1/"
xmlns:content="http://purl.org/rss/1.0/modules/content/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" exclude-result-prefixes="msxsl local s dt tom">
	
	
	<!--
		++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
					Variables for front page feeds
		++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	
	
	<!--
		<xsl:variable name="rss1_frontpageitems">
		Author:		Rich Caudle
		Puprose:	This variable will contain the list of items to be output in the 
					'latestcontent' feed, in the correct date order.
	-->
	<xsl:variable name="rss1_frontpageitems">
		
		<xsl:for-each select="/H2G2/TOP-FIVES/TOP-FIVE/*">
			<xsl:sort order="descending" select="DATEUPDATED/DATE/@SORT" />
			<xsl:copy-of select="."/>
		</xsl:for-each>	
		
	</xsl:variable>
	
	
	
	<!--
		++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
							Templates for front page feeds
		++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	
	<!-- 
	
	-->
	<xsl:template name="FRONTPAGE_RSS1">
		<xsl:param name="mod"/>
		
		<xsl:variable name="liststring">comedy</xsl:variable>
		<xsl:choose>
			<xsl:when test="$mod='items'">
				<items xmlns="http://purl.org/rss/1.0/">
					<rdf:Seq>
						<xsl:choose>
							<xsl:when test="key('feedtype', 'mostthreads')">
								<xsl:apply-templates select="/H2G2/TOP-FIVES/TOP-FIVE[@NAME='MostThreads']/TOP-FIVE-FORUM" mode="rdf_resource_frontpagemostthreads"/>
							</xsl:when>
							<xsl:when test="key('feedtype', 'threadupdates')">
								<xsl:apply-templates select="/H2G2/TOP-FIVES/TOP-FIVE[@NAME='MostRecentConversations']/TOP-FIVE-FORUM" mode="rdf_resource_frontpagethreadupdates"/>
							</xsl:when>
							<xsl:when test="key('feedtype', 'articleupdates')">
								<xsl:apply-templates select="/H2G2/TOP-FIVES/TOP-FIVE[@NAME='Updated']/TOP-FIVE-ARTICLE" mode="rdf_resource_frontpagearticleupdates"/>	
							</xsl:when>
							<xsl:when test="key('feedtype', 'recentedited')">
								<xsl:apply-templates select="/H2G2/TOP-FIVES/TOP-FIVE[@NAME='MostRecent']/TOP-FIVE-ARTICLE" mode="rdf_resource_frontpagerecentedited"/>	
							</xsl:when>
							<xsl:when test="key('feedtype', 'neglectedarticles')">
								<xsl:apply-templates select="/H2G2/TOP-FIVES/TOP-FIVE[@NAME='LeastViewed']/TOP-FIVE-ARTICLE" mode="rdf_resource_frontpageneglectedarticles"/>	
							</xsl:when>
							<xsl:when test="key('feedtype', 'clubupdates')">
								<xsl:apply-templates select="/H2G2/TOP-FIVES/TOP-FIVE[@NAME='MostRecentClubUpdates']/TOP-FIVE-CLUB" mode="rdf_resource_frontpageclubupdates"/>
							</xsl:when>
							<xsl:when test="key('feedtype', 'dynamiclist')">
								<xsl:apply-templates select="/H2G2/DYNAMIC-LISTS/LIST/ITEM-LIST/ITEM" mode="rdf_resource_frontpagedynamiclist"/>
							</xsl:when>
							<xsl:when test="key('feedtype', 'dynamiclist_comedy')">
								<xsl:apply-templates select="/H2G2/DYNAMIC-LISTS/LIST[@LISTNAME='comedy']/ITEM-LIST/ITEM" mode="rdf_resource_frontpagedynamiclist"/>
							</xsl:when>
							<!-- Latest content feed, as used by Action Network -->
							<xsl:when test="starts-with($rss_feedtype,'latestcontent-')">
								<xsl:apply-templates select="msxsl:node-set($rss1_frontpageitems)/*[position() &lt;= $rss_maxitems]" mode="rdf_resource_frontpageitem" />
							</xsl:when>
							<!-- Latest content feed, as used by Action Network -->
							<xsl:when test="starts-with($rss_feedtype,'editorial-')">
								<xsl:apply-templates select="msxsl:node-set($rss1_frontpageitems)/*[position() &lt;= $rss_maxitems]" mode="rdf_resource_frontpageitem" />
							</xsl:when>
							<xsl:otherwise>
								<xsl:apply-templates select="msxsl:node-set($syn_article)/SYNDICATION/ITEM" mode="rdf_resource_frontpage"/>
							</xsl:otherwise>
						</xsl:choose>
					</rdf:Seq>
				</items>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>					
					<xsl:when test="key('feedtype', 'mostthreads')">
						<xsl:apply-templates select="/H2G2/TOP-FIVES/TOP-FIVE[@NAME='MostThreads']/TOP-FIVE-FORUM" mode="rss1_frontpagemostthreads"/>
					</xsl:when>
					<xsl:when test="key('feedtype', 'threadupdates')">
								<xsl:apply-templates select="/H2G2/TOP-FIVES/TOP-FIVE[@NAME='MostRecentConversations']/TOP-FIVE-FORUM" mode="rss1_frontpagethreadupdates"/>
							</xsl:when>
					<xsl:when test="key('feedtype', 'articleupdates')">
						<xsl:apply-templates select="/H2G2/TOP-FIVES/TOP-FIVE[@NAME='Updated']/TOP-FIVE-ARTICLE" mode="rss1_frontpagearticleupdates"/>	
					</xsl:when>
					<xsl:when test="key('feedtype', 'recentedited')">
						<xsl:apply-templates select="/H2G2/TOP-FIVES/TOP-FIVE[@NAME='MostRecent']/TOP-FIVE-ARTICLE" mode="rss1_frontpagerecentedited"/>	
					</xsl:when>
					<xsl:when test="key('feedtype', 'neglectedarticles')">
						<xsl:apply-templates select="/H2G2/TOP-FIVES/TOP-FIVE[@NAME='LeastViewed']/TOP-FIVE-ARTICLE" mode="rss1_frontpageneglectedarticles"/>			
					</xsl:when>
					<xsl:when test="key('feedtype', 'clubupdates')">
						<xsl:apply-templates select="/H2G2/TOP-FIVES/TOP-FIVE[@NAME='MostRecentClubUpdates']/TOP-FIVE-CLUB" mode="rss1_frontpageclubupdates"/>
					</xsl:when>
					<xsl:when test="key('feedtype', 'dynamiclist')">
						<xsl:apply-templates select="/H2G2/DYNAMIC-LISTS/LIST/ITEM-LIST/ITEM" mode="rss1_frontpagedynamiclist"/>
					</xsl:when>
					<!-- Added an s_param value of 's_viewamount'.  If this is set to a number in the query string, the rss xml output will only show that amount of items -->
					<xsl:when test="key('feedtype', concat('dynamiclist_',$suffix))">
						<xsl:choose>
							<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_feedamount']/VALUE &gt; 0">
								<xsl:for-each select="/H2G2/DYNAMIC-LISTS/LIST[@LISTNAME=$suffix]/ITEM-LIST/ITEM[position() &lt;= /H2G2/PARAMS/PARAM[NAME = 's_feedamount']/VALUE ]">
									<xsl:apply-templates select="." mode="rss1_frontpagedynamiclist"/>
								</xsl:for-each>
							</xsl:when>
							<xsl:otherwise>
								<xsl:apply-templates select="/H2G2/DYNAMIC-LISTS/LIST[@LISTNAME=$suffix]/ITEM-LIST/ITEM" mode="rss1_frontpagedynamiclist"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<!-- Latest content feed, as used by Action Network -->
					<xsl:when test="starts-with($rss_feedtype,'editorial-')">
						<xsl:apply-templates select="msxsl:node-set($rss1_frontpageitems)/*[position() &lt;= $rss_maxitems]" mode="rdf_frontpageitem" />
					</xsl:when>	
					<!-- Latest content feed, as used by Action Network -->
					<xsl:when test="starts-with($rss_feedtype,'latestcontent-')">
						<xsl:apply-templates select="msxsl:node-set($rss1_frontpageitems)/*[position() &lt;= $rss_maxitems]" mode="rdf_frontpageitem" />
					</xsl:when>				
					<xsl:otherwise>
						<xsl:apply-templates select="msxsl:node-set($syn_article)/SYNDICATION/ITEM" mode="rss1_frontpage"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- 
	
	-->
	<xsl:template match="TOP-FIVE-FORUM" mode="rdf_resource_frontpagemostthreads">
		<rdf:li rdf:resource="{$thisserver}{$root}F{FORUMID}"/>
	</xsl:template>
	<!-- 
	
	-->
	<xsl:template match="TOP-FIVE-FORUM" mode="rss1_frontpagemostthreads">
		<item rdf:about="{$thisserver}{$root}F{FORUMID}" xmlns="http://purl.org/rss/1.0/">
			<title>
				<xsl:call-template name="validChars">
					<xsl:with-param name="string" select="SUBJECT"/>
				</xsl:call-template>
			</title>
			<link>
				<xsl:value-of select="concat($thisserver, $root, 'F', FORUMID)"/>
			</link>
		</item>
	</xsl:template>
	
	<!-- 
	
	-->
	<xsl:template match="TOP-FIVE-FORUM" mode="rdf_resource_frontpagethreadupdates">
		<rdf:li rdf:resource="{$thisserver}{$root}F{FORUMID}?thread={THREADID}"/>
	</xsl:template>
	<!-- 
	
	-->
	<xsl:template match="TOP-FIVE-FORUM" mode="rss1_frontpagethreadupdates">
		<item rdf:about="{$thisserver}{$root}F{FORUMID}?thread={THREADID}" xmlns="http://purl.org/rss/1.0/">
			<title>
				<xsl:call-template name="validChars">
					<xsl:with-param name="string" select="SUBJECT"/>
				</xsl:call-template>
			</title>
			<link>
				<xsl:value-of select="concat($thisserver, $root, 'F', FORUMID, '?thread=', THREADID)"/>
			</link>
		</item>
	</xsl:template>
	<!-- 
	
	-->
	<xsl:template match="TOP-FIVE-ARTICLE" mode="rdf_resource_frontpagearticleupdates">
		<rdf:li rdf:resource="{$thisserver}{$root}A{H2G2ID}"/>
	</xsl:template>
	<xsl:template match="TOP-FIVE-ARTICLE" mode="rdf_resource_frontpagerecentedited">
		<rdf:li rdf:resource="{$thisserver}{$root}A{H2G2ID}"/>
	</xsl:template>
	<!-- 
	
	-->
	<xsl:template match="TOP-FIVE-ARTICLE" mode="rss1_frontpagearticleupdates">
		<item rdf:about="{$thisserver}{$root}A{H2G2ID}" xmlns="http://purl.org/rss/1.0/">
			<title>
				<xsl:call-template name="validChars">
					<xsl:with-param name="string" select="SUBJECT"/>
				</xsl:call-template>
			</title>
			<link>
				<xsl:value-of select="concat($thisserver, $root, 'A', H2G2ID)"/>
			</link>
		</item>
	</xsl:template>
	<xsl:template match="TOP-FIVE-ARTICLE" mode="rss1_frontpagerecentedited">
		<item rdf:about="{$thisserver}{$root}A{H2G2ID}" xmlns="http://purl.org/rss/1.0/">
			<title>
				<xsl:call-template name="validChars">
					<xsl:with-param name="string" select="SUBJECT"/>
				</xsl:call-template>
			</title>
			<link>
				<xsl:value-of select="concat($thisserver, $root, 'A', H2G2ID)"/>
			</link>
		</item>
	</xsl:template>
	<!-- 
	
	-->
	<xsl:template match="TOP-FIVE-ARTICLE" mode="rdf_resource_frontpageneglectedarticles">
		<rdf:li rdf:resource="{$thisserver}{$root}A{H2G2ID}"/>
	</xsl:template>
	<!-- 
	
	-->
	<xsl:template match="TOP-FIVE-ARTICLE" mode="rss1_frontpageneglectedarticles">
		<item rdf:about="{$thisserver}{$root}A{H2G2ID}" xmlns="http://purl.org/rss/1.0/">
			<title>
				<xsl:value-of select="SUBJECT"/>
			</title>
			<link>
				<xsl:value-of select="concat($thisserver, $root, 'A', H2G2ID)"/>
			</link>
		</item>
	</xsl:template>
	<!-- 
	
	-->
	<xsl:template match="TOP-FIVE-CLUB" mode="rdf_resource_frontpageclubupdates">
		<rdf:li rdf:resource="{$thisserver}{$root}G{CLUBID}"/>
	</xsl:template>
	<!-- 
	
	-->
	<xsl:template match="TOP-FIVE-CLUB" mode="rss1_frontpageclubupdates">
		<item rdf:about="{$thisserver}{$root}G{CLUBID}" xmlns="http://purl.org/rss/1.0/">
			<title>
				<xsl:value-of select="SUBJECT"/>
			</title>
			<link>
				<xsl:value-of select="concat($thisserver, $root, 'G', CLUBID)"/>
			</link>
		</item>
	</xsl:template>
	<!-- 
	
	-->
	<xsl:template match="ITEM" mode="rdf_resource_frontpagedynamiclist">
		<rdf:li rdf:resource="{$thisserver}{$root}A{ARTICLE-ITEM/@H2G2ID}"/>
	</xsl:template>
	<!-- 
	
	-->
	<xsl:template match="ITEM" mode="rss1_frontpagedynamiclist">
		<item rdf:about="{$thisserver}{$root}A{ARTICLE-ITEM/@H2G2ID}" xmlns="http://purl.org/rss/1.0/">
			<title>
				<xsl:call-template name="validChars">
					<xsl:with-param name="string" select="ARTICLE-ITEM/SUBJECT"/>
				</xsl:call-template>
			</title>
			<description>
				<xsl:apply-templates select="ARTICLE-ITEM/EXTRAINFO/EXTRAINFO/AUTODESCRIPTION/text()" mode="rss1_copycontent" />
			</description>

			<link>
				<xsl:value-of select="concat($thisserver, $root, 'A', ARTICLE-ITEM/@H2G2ID)"/>
			</link>
			
			<content:encoded>
			<!--xsl:value-of select="'&lt;![CDATA['" disable-output-escaping="yes"/>
			<image:item src="{$graphics}shorts/A{ARTICLE-ITEM/@H2G2ID}_small.jpg">
				<dc:title>
					<xsl:call-template name="validChars">
						<xsl:with-param name="string" select="ARTICLE-ITEM/SUBJECT"/>
					</xsl:call-template>
				</dc:title>
				<image:width>31</image:width>
				<image:height>30</image:height>
       		</image:item>
				<xsl:value-of select="']]&gt;'" disable-output-escaping="yes"/-->
			<xsl:choose>
				<xsl:when test="/H2G2/PARAMS/PARAM[NAME= 's_feed']/VALUE = 'dynamiclist_magazine_features'">
					<xsl:value-of select="concat($graphics,'magazine/A',ARTICLE-ITEM/@H2G2ID,'_small.jpg')"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="concat($graphics,'shorts/A',ARTICLE-ITEM/@H2G2ID,'_small.jpg')"/>
				</xsl:otherwise>
			</xsl:choose>
			</content:encoded>
		</item>
	</xsl:template>
	<!-- 
	
	-->
	<xsl:template match="ITEM" mode="rdf_resource_frontpage">
		<rdf:li rdf:resource="{tom:link}"/>
	</xsl:template>
	<!-- 
	
	-->
	<xsl:template match="ITEM" mode="rss1_frontpage">
		<item rdf:about="{tom:link}" xmlns="http://purl.org/rss/1.0/">
			<xsl:for-each select="*">
				<xsl:copy-of select="."/>
			</xsl:for-each>
		</item>
	</xsl:template>
	

	<!--
		<xsl:template match="TOP-FIVE-ARTICLE" mode="rdf_resource_frontpageitem">
		Author:		Rich Caudle
		Purpose:	Creates a resource item for a top five article	
	-->
	<xsl:template match="TOP-FIVE-ARTICLE" mode="rdf_resource_frontpageitem">
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
		<xsl:template match="TOP-FIVE-CAMPAIGN-DIARY-ENTRY" mode="rdf_resource_frontpageitem">
		Author:		Rich Caudle
		Purpose:	Creates a resource item for a top five campaign update
	-->
	<xsl:template match="TOP-FIVE-CAMPAIGN-DIARY-ENTRY" mode="rdf_resource_frontpageitem">
		<rdf:li>
			<xsl:attribute name="rdf:resource">
				<xsl:call-template name="rss_trackedlink">
					<xsl:with-param name="location">
						<xsl:value-of select="concat('F', FORUMID, '?thread=', THREADID)"/>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:attribute>
		</rdf:li>
	</xsl:template>
	

	<!--
		<xsl:template match="TOP-FIVE-NOTICES" mode="rdf_resource_frontpageitem">
		Author:		Rich Caudle
		Purpose:	Creates a resource item for a top five notice
	-->
	<xsl:template match="TOP-FIVE-NOTICES" mode="rdf_resource_frontpageitem">
		<rdf:li>
			<xsl:attribute name="rdf:resource">
				<xsl:call-template name="rss_trackedlink">
					<xsl:with-param name="location">
						<xsl:value-of select="concat('F', FORUMID, '?thread=', THREADID)"/>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:attribute>
		</rdf:li>
	</xsl:template>
	
	
	<!--
		<xsl:template match="TOP-FIVE-ARTICLE" mode="rdf_frontpageitem">
		Author:		Rich Caudle
		Purpose:	Creates a feed item for a top five article
	-->
	<xsl:template match="TOP-FIVE-ARTICLE" mode="rdf_frontpageitem">
		
		<xsl:variable name="tempURL">
			<xsl:call-template name="rss_trackedlink">
				<xsl:with-param name="location">
					<xsl:value-of select="concat('A', H2G2ID)"/>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:variable>
		
		<item rdf:about="{$tempURL}" xmlns="http://purl.org/rss/1.0/">
			<title>
				<xsl:value-of select="SUBJECT"/>
			</title>
			<description>
				<xsl:apply-templates select="EXTRAINFO/AUTODESCRIPTION/text()" mode="rss1_copycontent" />
			</description>
			<link>
				<xsl:value-of select="$tempURL" />
			</link>
			<dc:date>
				<xsl:apply-templates select="DATEUPDATED/DATE" mode="dc"/>
			</dc:date>
			<xsl:apply-templates select="USER" mode="rss1_creator"/>
			<dc:format>text/plain</dc:format>
		</item>		
		
	</xsl:template>
	


	<!--
		<xsl:template match="TOP-FIVE-CAMPAIGN-DIARY-ENTRY" mode="rdf_frontpageitem">
		Author:		Rich Caudle
		Purpose:	Creates a feed item for a top five campaign update
	-->
	<xsl:template match="TOP-FIVE-CAMPAIGN-DIARY-ENTRY" mode="rdf_frontpageitem">
		
		<xsl:variable name="tempURL">
			<xsl:call-template name="rss_trackedlink">
				<xsl:with-param name="location">
					<xsl:value-of select="concat('F', FORUMID, '?thread=', THREADID)"/>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:variable>
		
		<item rdf:about="{$tempURL}" xmlns="http://purl.org/rss/1.0/">
			
			<title>
				<xsl:call-template name="rss1_maketitle">
					<xsl:with-param name="title" select="TITLE" />
					<xsl:with-param name="content" select="SUBJECT" />				
				</xsl:call-template>
			</title>
			<description>
				<xsl:apply-templates select="SUBJECT/node()" mode="rss1_copycontent" />
			</description>
			<link>
				<xsl:value-of select="$tempURL" />
			</link>
			<dc:date>
				<xsl:apply-templates select="DATEUPDATED/DATE" mode="dc"/>
			</dc:date>
			<xsl:apply-templates select="USER" mode="rss1_creator"/>
			<dc:format>text/plain</dc:format>
			
		</item>
		
	</xsl:template>
	
	
	<!--
		<xsl:template match="TOP-FIVE-NOTICES" mode="rdf_frontpageitem">
		Author:		Rich Caudle
		Purpose:	Creates a feed item for a top five notice
	-->
	<xsl:template match="TOP-FIVE-NOTICES" mode="rdf_frontpageitem">
		
		<xsl:variable name="tempURL">
			<xsl:call-template name="rss_trackedlink">
				<xsl:with-param name="location">
					<xsl:value-of select="concat('F', FORUMID, '?thread=', THREADID)"/>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:variable>
		
		<item rdf:about="{$tempURL}" xmlns="http://purl.org/rss/1.0/">
			
			<title>
				<xsl:call-template name="rss1_maketitle">
					<xsl:with-param name="title" select="TITLE" />
					<xsl:with-param name="content"><xsl:apply-templates select="SUBJECT/GUIDE/BODY/node()" mode="rss1_copycontent" /></xsl:with-param>				
				</xsl:call-template>
			</title>
			<description>
				<xsl:apply-templates select="SUBJECT/GUIDE/BODY/node()" mode="rss1_copycontent" />
			</description>
			<link>
				<xsl:value-of select="$tempURL" />
			</link>
			<dc:date>
				<xsl:apply-templates select="DATEUPDATED/DATE" mode="dc"/>
			</dc:date>
			<xsl:apply-templates select="USER" mode="rss1_creator"/>
			<dc:format>text/plain</dc:format>
			
		</item>
		
	</xsl:template>
	

</xsl:stylesheet>
