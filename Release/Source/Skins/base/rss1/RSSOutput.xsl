<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns="http://purl.org/rss/1.0/" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:dc="http://purl.org/dc/elements/1.1/" exclude-result-prefixes="msxsl local s dt rdf">
	<!--===============Output Setting=====================-->
	<xsl:import href="../base-extra.xsl"/>
	<xsl:output method="xml" version="1.0" standalone="yes" indent="yes" omit-xml-declaration="no" encoding="iso-8859-1"/>
	<xsl:include href="rss_articlepage.xsl"/>	
	<xsl:include href="rss_articlesearchphrase.xsl"/>
  <xsl:include href="rss_articlesearch.xsl"/>
	<xsl:include href="rss_categorypage.xsl"/>
	<xsl:include href="rss_clubpage.xsl"/>
	<xsl:include href="rss_frontpage.xsl"/>
	<xsl:include href="rss_indexpage.xsl"/>
	<xsl:include href="rss_infopage.xsl"/>
	<xsl:include href="rss_journalpage.xsl"/>
	<xsl:include href="rss_morepostspage.xsl"/>
	<xsl:include href="rss_multipostspage.xsl"/>
	<xsl:include href="rss_newuserspage.xsl"/>
	<xsl:include href="rss_threadspage.xsl"/>
	<xsl:include href="rss_userpage.xsl"/>
	<xsl:include href="rss_reviewforumpage.xsl"/>
	<!-- 
	<xsl:variable name="syn_article"/>
	Used: Used to hold a site-specific node-set for the article page and front page
	-->
	<xsl:variable name="syn_article"/>
	<xsl:variable name="thisnamespace">
		<xsl:choose>
			<xsl:when test="/H2G2/PARAMS/PARAM[NAME='s_xml']/VALUE='rss'">http://purl.org/rss/1.0/</xsl:when>
			<!--xsl:when test="/H2G2/PARAMS/PARAM[NAME='s_xml']/VALUE='atom'">http://purl.org/atom/ns#</xsl:when-->
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="rss_frontpage_description_default" select="$sitedisplayname"/>
	<xsl:variable name="rss_frontpage_title_default" select="$sitedisplayname"/>
	<xsl:variable name="rss_rdf_resource_image">
	
			
		<xsl:element name="image">
			<xsl:attribute name="rdf:resource">http://www.bbc.co.uk/images/logo042.gif</xsl:attribute>
		</xsl:element>
	</xsl:variable>
	
	<xsl:variable name="rss_image">
		<xsl:element name="image">
			<xsl:attribute name="rdf:about">http://www.bbc.co.uk/images/logo042.gif</xsl:attribute>
			<xsl:element name="title">BBC</xsl:element>
			<xsl:element name="url">http://www.bbc.co.uk/images/logo042.gif</xsl:element>
			<xsl:element name="link">http://www.bbc.co.uk</xsl:element>
			<!--xsl:element name="width">90</xsl:element>
			<xsl:element name="height">30</xsl:element-->
		</xsl:element>
	</xsl:variable>
	
	<xsl:variable name="rss_feedtype"><xsl:value-of select="/H2G2/PARAMS/PARAM[NAME='s_feed']/VALUE" /></xsl:variable>

	<!-- Specifies the maximum no of items that should be in a feed -->
	<xsl:variable name="rss_maxitems">
		<xsl:choose>
			<xsl:when test="/H2G2/PARAMS/PARAM[NAME='s_maxitems']"><xsl:value-of select="/H2G2/PARAMS/PARAM[NAME='s_maxitems']/VALUE" /></xsl:when>
			<xsl:when test="starts-with($rss_feedtype,'editorial-')">100</xsl:when>
			<xsl:otherwise>20</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<xsl:variable name="m_rsslinktracking"><xsl:value-of select="concat('/go/syn/rss/dna_', $sitename, '/-')"/></xsl:variable>
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
					RSS Logical Container Template
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<xsl:key name="feedtype" match="/H2G2/PARAMS/PARAM[NAME='s_feed']" use="VALUE"/>
	<!-- 
	
	-->
	<xsl:key name="xmltype" match="/H2G2/PARAMS/PARAM[NAME='s_xml']" use="VALUE"/>
	<!-- 
	
	-->
	<xsl:key name="pagetype" match="/H2G2" use="@TYPE"/>
	<!-- 
	
	-->
	<xsl:template match="H2G2[key('xmltype', 'rss1') or key('xmltype', 'rss')]">
		<rdf:RDF xmlns="http://purl.org/rss/1.0/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:dc="http://purl.org/dc/elements/1.1/"
xmlns:content="http://purl.org/rss/1.0/modules/content/">
			<channel rdf:about="{$thisserver}{$root}{$referrer}">
				<title>
					<xsl:value-of select="$rss_title"/>
				</title>
				<!--xsl:element name="link" namespace="{$thisnamespace}">
					<xsl:value-of select="$rss_link"/>
				</xsl:element-->
				<link>
					<xsl:value-of select="$rss_link"/>
				</link>
				<description>
					<xsl:value-of select="$rss_description"/>
				</description>
				<dc:date>
					<xsl:apply-templates select="DATE" mode="dc"/>
				</dc:date>
				<xsl:copy-of select="$rss_rdf_resource_image"/>
	
				<xsl:call-template name="type-check">
					<xsl:with-param name="content">RSS1</xsl:with-param>
					<xsl:with-param name="mod">items</xsl:with-param>
				</xsl:call-template>
			</channel>
			<xsl:copy-of select="$rss_image"/>
			<xsl:call-template name="type-check">
				<xsl:with-param name="content">RSS1</xsl:with-param>
			</xsl:call-template>
		</rdf:RDF>
	</xsl:template>
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
						Temporary RSS templates
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<xsl:variable name="rss_subject">
		<xsl:choose>
			<xsl:when test="/H2G2[@TYPE='THREADS'] or /H2G2[@TYPE='MULTIPOSTS']">
				<xsl:choose>
					<xsl:when test="/H2G2/FORUMSOURCE/@TYPE='userpage'">
						<xsl:value-of select="/H2G2/FORUMSOURCE/USERPAGE/USER/USERNAME"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="/H2G2/FORUMSOURCE/ARTICLE/SUBJECT"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="rss_title">
		<xsl:choose>
			<xsl:when test="/H2G2[@TYPE='ARTICLE']">
				<xsl:choose>
					<xsl:when test="key('feedtype', 'lastwinners')">
						<xsl:value-of select="concat($sitedisplayname, ' - Last weeks winning reviews')"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="concat($sitedisplayname, ' - ', /H2G2/ARTICLE/SUBJECT)"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<!-- <xsl:when test="/H2G2[@TYPE='CATEGORY']">
				<xsl:choose>
					<xsl:when test="key('feedtype', 'events')">
						<xsl:value-of select="concat($sitedisplayname, ' - ', 'Recent events from ', /H2G2/HIERARCHYDETAILS/DISPLAYNAME)"/>
					</xsl:when>
					<xsl:when test="key('feedtype', 'notices')">
						<xsl:value-of select="concat($sitedisplayname, ' - ', 'Recent notices from ', /H2G2/HIERARCHYDETAILS/DISPLAYNAME)"/>
					</xsl:when>
				</xsl:choose>
			</xsl:when> -->
			<xsl:when test="/H2G2[@TYPE='CLUB']">
				<xsl:choose>
					<xsl:when test="key('feedtype', 'members')">
						<xsl:value-of select="concat($sitedisplayname, ' - ', 'members of ', /H2G2/CLUB/CLUBINFO/NAME)"/>
					</xsl:when>
					<xsl:when test="key('feedtype', 'journal')">
						<xsl:value-of select="concat($sitedisplayname, ' - ', 'journal entries for ', /H2G2/CLUB/CLUBINFO/NAME)"/>
					</xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="key('pagetype', 'FRONTPAGE')">
				<xsl:choose>
					<xsl:when test="key('feedtype', 'mostthreads')">
						<xsl:value-of select="concat($sitedisplayname, ' - ', 'Busiest Conversations')"/>
					</xsl:when>
					<xsl:when test="key('feedtype', 'articleupdates')">
						<xsl:value-of select="concat($sitedisplayname, ' - ', 'Recently Updated Articles')"/>
					</xsl:when>
					<xsl:when test="key('feedtype', 'recentedited')">
						<xsl:value-of select="concat($sitedisplayname, ' - ', 'Recently Edited Articles')"/>
					</xsl:when>
					<xsl:when test="key('feedtype', 'clubupdates')">
						<xsl:value-of select="concat($sitedisplayname, ' - ', 'Recently Updated Campaigns')"/>
					</xsl:when>
					<xsl:when test="key('feedtype', 'threadupdates')">
						<xsl:value-of select="concat($sitedisplayname, ' - ', 'Recently Updated Conversations')"/>
					</xsl:when>
					<xsl:when test="key('feedtype', 'neglectedarticles')">
						<xsl:value-of select="concat($sitedisplayname, ' - ', 'Neglected Articles')"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$rss_frontpage_title_default"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="key('pagetype', 'INFO')">
				<xsl:choose>
					<xsl:when test="/H2G2/INFO/RECENTCONVERSATIONS/RECENTCONVERSATION">
						<xsl:value-of select="concat($sitedisplayname, ' - ', 'Recently Updated Conversations')"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="concat($sitedisplayname, ' - ', 'Recently Created Articles')"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="key('pagetype', 'JOURNAL')">
				<xsl:value-of select="concat($sitedisplayname, ' - ', 'Journal - ', /H2G2/FORUMSOURCE/JOURNAL/USER/USERNAME)"/>
			</xsl:when>
			<xsl:when test="key('pagetype', 'MOREPOSTS')">
				<xsl:value-of select="concat($sitedisplayname, ' - Conversations - ', /H2G2/POSTS/POST-LIST/USER/USERNAME)"/>
			</xsl:when>
			<xsl:when test="key('pagetype', 'INDEX')">
				<xsl:value-of select="$sitedisplayname"/>
			</xsl:when>
			<xsl:when test="/H2G2[@TYPE='MULTIPOSTS']">
				<xsl:value-of select="concat($sitedisplayname, ' - Conversation - ', $rss_subject)"/>
			</xsl:when>
			<xsl:when test="/H2G2[@TYPE='NEWUSERS']">
				<xsl:value-of select="concat($sitedisplayname, ' - New Users')"/>
			</xsl:when>
			<xsl:when test="/H2G2[@TYPE='REVIEWFORUM']">
				<xsl:value-of select="concat($sitedisplayname, ' - Review Forum - ', /H2G2/REVIEWFORUM/FORUMNAME)"/>
			</xsl:when>
			<xsl:when test="/H2G2[@TYPE='THREADS']">
				<xsl:value-of select="concat($sitedisplayname, ' - Forum - ', $rss_subject)"/>
			</xsl:when>
			<xsl:when test="/H2G2[@TYPE='USERPAGE']">
				<xsl:value-of select="concat($sitedisplayname, ' - ', /H2G2/PAGE-OWNER/USER/USERNAME, ' - Messages')"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="msxsl:node-set($html_header)/head/title"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="rss_link">
		<xsl:value-of select="concat($thisserver, '/go/syn/rss/dna_', $sitename, '/-', $root, $referrer)"/>
		<xsl:if test="/H2G2[@TYPE='MULTIPOSTS']">
			<xsl:value-of select="concat('#p', /H2G2/FORUMTHREADPOSTS/POST[position()=last()]/@POSTID)"/>
		</xsl:if>
	</xsl:variable>
	<xsl:template name="rss_trackedlink">
		<xsl:param name="location" />

		<xsl:choose>
			<xsl:when test="contains($thisserver, 'www.bbc.co.uk')"><xsl:value-of select="concat($thisserver, $m_rsslinktracking, $root, $location)"/></xsl:when>
			<xsl:otherwise><xsl:value-of select="concat($thisserver, $root, $location)"/></xsl:otherwise>
		</xsl:choose>

	</xsl:template>
	<xsl:variable name="rss_description">
		<xsl:choose>
			<xsl:when test="key('pagetype', 'ARTICLE')">
				<xsl:choose>
					<xsl:when test="key('feedtype', 'lastwinners')">
						<xsl:value-of select="concat($sitedisplayname, ' - Last weeks winning reviews')"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="concat($sitedisplayname, ' - ', /H2G2/ARTICLE/SUBJECT)"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<!-- <xsl:when test="/H2G2[@TYPE='CATEGORY']">
				<xsl:choose>
					<xsl:when test="key('feedtype', 'events')">
						<xsl:value-of select="concat($sitedisplayname,  ' - Recent events from ', /H2G2/HIERARCHYDETAILS/DISPLAYNAME)"/>
					</xsl:when>
					<xsl:when test="key('feedtype', 'notices')">
						<xsl:value-of select="concat($sitedisplayname,  ' - Recent notices from ', /H2G2/HIERARCHYDETAILS/DISPLAYNAME)"/>
					</xsl:when>
				</xsl:choose>
			</xsl:when> -->
			<xsl:when test="/H2G2[@TYPE='CLUB']">
				<xsl:choose>
					<xsl:when test="key('feedtype', 'members')">
						<xsl:value-of select="concat($sitedisplayname, ' - ', 'members of ', /H2G2/CLUB/CLUBINFO/NAME)"/>
					</xsl:when>
					<xsl:when test="key('feedtype', 'journal')">
						<xsl:value-of select="concat($sitedisplayname, ' - ', 'journal entries for ', /H2G2/CLUB/CLUBINFO/NAME)"/>
					</xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="key('pagetype', 'FRONTPAGE')">
				<xsl:choose>
					<xsl:when test="key('feedtype', 'mostthreads')">
						<xsl:value-of select="concat($sitedisplayname, ' - ', 'Busiest Conversations')"/>
					</xsl:when>
					<xsl:when test="key('feedtype', 'articleupdates')">
						<xsl:value-of select="concat($sitedisplayname, ' - ', 'Recently Updated Articles')"/>
					</xsl:when>
					<xsl:when test="key('feedtype', 'recentedited')">
						<xsl:value-of select="concat($sitedisplayname, ' - ', 'Recently Edited Articles')"/>
					</xsl:when>
					<xsl:when test="key('feedtype', 'clubupdates')">
						<xsl:value-of select="concat($sitedisplayname, ' - ', 'Recently Updated Campaigns')"/>
					</xsl:when>
					<xsl:when test="key('feedtype', 'threadupdates')">
						<xsl:value-of select="concat($sitedisplayname, ' - ', 'Recently Updated Conversations')"/>
					</xsl:when>
					<xsl:when test="key('feedtype', 'neglectedarticles')">
						<xsl:value-of select="concat($sitedisplayname, ' - ', 'Neglected Articles')"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$rss_frontpage_description_default"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="key('pagetype', 'INFO')">
				<xsl:choose>
					<xsl:when test="/H2G2/INFO/RECENTCONVERSATIONS/RECENTCONVERSATION">
						<xsl:value-of select="concat($sitedisplayname, ' - ', 'Recently Updated Conversations')"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="concat($sitedisplayname, ' - ', 'Recently Created Articles')"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="key('pagetype', 'JOURNAL')">
				<xsl:value-of select="concat($sitedisplayname, ' - ', 'Journal - ', /H2G2/FORUMSOURCE/JOURNAL/USER/USERNAME)"/>
			</xsl:when>
			<xsl:when test="key('pagetype', 'MOREPOSTS')">
				<xsl:value-of select="concat($sitedisplayname, ' - Conversations - ', /H2G2/POSTS/POST-LIST/USER/USERNAME)"/>
			</xsl:when>
			<xsl:when test="/H2G2[@TYPE='MULTIPOSTS']">
				<xsl:value-of select="concat($sitedisplayname, ' - Conversation - ', $rss_subject)"/>
			</xsl:when>
			<xsl:when test="key('pagetype', 'INDEX')">
				<xsl:choose>
					<xsl:when test="/H2G2/CURRENTSITEURLNAME='filmnetwork'">
						<xsl:text>Short films selected by  Film Network, the BBC's interactive showcase for new British filmmakers.</xsl:text>			
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="concat($sitedisplayname, ' - Index')"/>
					</xsl:otherwise>					
				</xsl:choose>
			</xsl:when>			
			<xsl:when test="/H2G2[@TYPE='NEWUSERS']">
				<xsl:value-of select="concat($sitedisplayname, ' - New Users')"/>
			</xsl:when>
			<xsl:when test="/H2G2[@TYPE='THREADS']">
				<xsl:value-of select="concat($sitedisplayname, ' - Forum - ', $rss_subject)"/>
			</xsl:when>
			<xsl:when test="/H2G2[@TYPE='USERPAGE']">
				<xsl:value-of select="concat($sitedisplayname, ' - ', /H2G2/PAGE-OWNER/USER/USERNAME, ' - Messages')"/>
			</xsl:when>
			<xsl:when test="/H2G2[@TYPE='REVIEWFORUM']">
				<xsl:value-of select="concat($sitedisplayname, ' - Review Forum - ', /H2G2/REVIEWFORUM/FORUMNAME)"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="msxsl:node-set($html_header)/head/title"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<!-- sets the suffix variable used in dynamic lists -->	
	<xsl:variable name="suffix">
		<xsl:if test="starts-with($rss_feedtype,'dynamiclist_')">
			<xsl:value-of select="substring-after($rss_feedtype,'dynamiclist_')" />
		</xsl:if>		
	</xsl:variable>
	
	<xsl:variable name="html_header">
		<xsl:call-template name="insert-header"/>
	</xsl:variable>
	<xsl:template name="validChars">
		<xsl:param name="string"/>
    <!--<xsl:value-of select="translate($string, translate($string, 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890+/= &amp;-?.,', ''), '')"/>-->
    <xsl:value-of select="$string"/>
  </xsl:template>
	<!--
	
	-->
	<xsl:template match="*" mode="rss1_copycontent">
		<xsl:element name="{translate(name(),$uppercase,$lowercase)}" namespace="{$thisnamespace}">
			<xsl:apply-templates select="*|@*|text() " mode="rss1_copycontent" />
		</xsl:element>
	</xsl:template>
	<!--
	
	-->
	<xsl:template match="BR" mode="rss1_copycontent">
		<br/>
	</xsl:template>
	<!--
		
	-->
	<xsl:template match="LINK" mode="rss1_copycontent">
		<xsl:if test="@HREF">
			<a href="{@HREF}"><xsl:apply-templates select="*|@*|text() " mode="rss1_copycontent" /></a>
		</xsl:if>
	</xsl:template>
	<!--
	
	-->
	<xsl:template match="@*" mode="rss1_copycontent">
		<xsl:attribute name="{translate(name(),$uppercase,$lowercase)}"><xsl:value-of select="." /></xsl:attribute>
	</xsl:template>
	<!--
	
	-->
	<xsl:template match="text()" mode="rss1_copycontent">
		<xsl:call-template name="validChars">
			<xsl:with-param name="string" select="." />
		</xsl:call-template>
	</xsl:template>
	
	
	
	<!--
		<xsl:template name="rss1_maketitle">
		Author:		Rich Caudle
		Purpose:	Creates a title for an item. Use for items that may not have a title.
	-->
	<xsl:template name="rss1_maketitle">
		<xsl:param name="title" />
		<xsl:param name="content" />
		
		<xsl:variable name="validTitle"><xsl:value-of select="$title" /></xsl:variable>		
		<xsl:variable name="validContent"><xsl:value-of select="$content" /></xsl:variable>
		
		<xsl:choose>
			
			<!-- If title is not blank -->
			<xsl:when test="string-length($title) &gt; 0">
				<xsl:value-of select="$validTitle" />
			</xsl:when>
			
			<!-- If blank title -->
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="string-length($validContent) &lt; 26"><xsl:value-of select="$validContent" /></xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="rss1_trimtolastspace"><xsl:with-param name="value"><xsl:value-of select="$validContent" /></xsl:with-param></xsl:call-template><xsl:text>...</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
			
		</xsl:choose>
		
	</xsl:template>
	
	
	<!--
		<xsl:template name="rss1_trimtolastspace">
		Author:		Rich Caudle
		Purpose:	Trims a string to the end of a word within the maximum length
	-->
	<xsl:template name="rss1_trimtolastspace">
		<xsl:param name="targetLength">30</xsl:param>
		<xsl:param name="value"></xsl:param>
		
		<xsl:variable name="temp">
			<xsl:choose>
				<xsl:when test="string-length($value) &gt; $targetLength"><xsl:value-of select="substring($value,1, $targetLength + 1)" /></xsl:when>
				<xsl:otherwise><xsl:value-of select="$value" /></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:choose>
			
			<!-- if last character is space -->
			<xsl:when test="substring($temp,string-length($temp),1) = ' '">
				<xsl:value-of select="substring($temp,1,string-length($value)-1)" />
			</xsl:when>
			
			<!-- Otherwise trim last character -->
			<xsl:otherwise>
				<xsl:call-template name="rss1_trimtolastspace">
					<xsl:with-param name="targetLength"><xsl:value-of select="$targetLength" /></xsl:with-param>
					<xsl:with-param name="value"><xsl:value-of select="substring($temp,1,string-length($value)-1)" /></xsl:with-param>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>		
		
	</xsl:template>

	
</xsl:stylesheet>