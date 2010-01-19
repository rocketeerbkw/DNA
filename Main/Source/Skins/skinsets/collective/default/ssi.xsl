<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
	<!ENTITY ldquo "<ENTITY type='ldquo'>&#8220;</ENTITY>">
	<!ENTITY rdquo "<ENTITY type='rdquo'>&#8221;</ENTITY>">	
	<!ENTITY deg "<ENTITY type='deg'>&#176;</ENTITY>">
	<!ENTITY copy "<ENTITY type='copy'>&#169;</ENTITY>">
	<!ENTITY pound "<ENTITY type='pound'>&#163;</ENTITY>">
	<!ENTITY quot "<ENTITY type='quot'>&#34;</ENTITY>">
	<!ENTITY apos "<ENTITY type='apos'>&#39;</ENTITY>">	
]>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:str="http://exslt.org/strings" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:ms="urn:schemas-microsoft-com:xslt">

<!-- 
NOTES - ABOUT THIS FILE:
This files was created for creating includes for bbc.co.uk/cultureshow
The file was a copy of actionnetwork/lib/ssi.xsl with cultureshow functionalitly added (i.e <xsl:when test="/H2G2/@TYPE='ARTICLE'">) and irrevlevent actionnetwork code removed (i.e anything related to campaigns, events and notices).
Existing actionnetwork code has been left in so we can test it against collective data and explore the possibilities of what the includes can be used for

-->

	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
							VARIABLES
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	
	<xsl:variable name="var_global_urlroot">
		<xsl:choose>
			<xsl:when test="contains(/H2G2/SERVERNAME, 'OPS-DNA1')">http://dnadev.national.core.bbc.co.uk/dna/collective/</xsl:when>
			<xsl:when test="contains(/H2G2/SERVERNAME, 'NMSDNA0')">http://www0.bbc.co.uk/dna/collective/</xsl:when>
			<xsl:otherwise>http://www.bbc.co.uk/dna/collective/</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
    <xsl:variable name="maxItemCount">20</xsl:variable>
    <xsl:template name="newline"><xsl:text>&#13;&#10;</xsl:text></xsl:template>
    <xsl:variable name="s_feed"><xsl:value-of select="/H2G2/PARAMS/PARAM[NAME='s_feed']/VALUE"/></xsl:variable>
    
    <xsl:variable name="var_global_articles">
		<articles>
			<xsl:for-each select="/H2G2/HIERARCHYDETAILS/MEMBERS/ARTICLEMEMBER[EXTRAINFO/TYPE/@ID=1]">
				<xsl:sort select="LASTUPDATED/DATE/@SORT" order="descending" />
				<xsl:copy-of select="."/>
			</xsl:for-each>
		</articles>
	</xsl:variable>
	
	<xsl:variable name="var_global_events">
		<events>
			<xsl:for-each select="/H2G2/HIERARCHYDETAILS/MEMBERS/NOTICE[@TYPE='Event']">
				<xsl:sort order="descending" select="DATECLOSING/DATE/@SORT" data-type="number" />
				<xsl:copy-of select="."/>
			</xsl:for-each>
		</events>
	</xsl:variable>
	
	<xsl:variable name="var_global_notices">
		<notices>
			<xsl:for-each select="/H2G2/HIERARCHYDETAILS/MEMBERS/NOTICE[@TYPE='Notice']">
				<xsl:sort order="descending" select="DATEPOSTED/DATE/@SORT" data-type="number" />
				<xsl:copy-of select="."/>
			</xsl:for-each>
		</notices>
	</xsl:variable>
	
	<xsl:variable name="var_global_campaigns">
		<campaigns>
			<xsl:for-each select="/H2G2/HIERARCHYDETAILS/MEMBERS/CLUBMEMBER">
				<xsl:sort order="descending" select="LASTUPDATED/DATE/@SORT" data-type="number" />
				<xsl:copy-of select="."/>
			</xsl:for-each>
		</campaigns>
	</xsl:variable>
	
	<xsl:variable name="ssi_mixedcontent">
		<content>
			<xsl:for-each select="/H2G2/HIERARCHYDETAILS/MEMBERS/*[(name()='CLUBMEMBER') or (not($s_feed='campaigns') and name()='ARTICLEMEMBER' and EXTRAINFO/TYPE/@ID=1 and STATUS/@TYPE=3)]">
				<xsl:sort order="descending" select="LASTUPDATED/DATE/@SORT" data-type="number" />
				<xsl:copy-of select="."/>
			</xsl:for-each>
		</content>
	</xsl:variable>
		
	<xsl:variable name="ssi_gotracking">
		<xsl:text>http://www.bbc.co.uk/go/an/int/-/</xsl:text>
	</xsl:variable>
	
    
    <!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
							MAIN TEMPLATE
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	
    <!-- Matches any SSI feed -->
    <xsl:template match="/H2G2[PARAMS/PARAM[NAME='s_ssi']/VALUE='ssi']">

     	<!-- Required variables -->
		<xsl:comment>#set var="statement.start" value="&lt;!-"</xsl:comment>
		<xsl:comment>#set var="statement.end" value="-&gt;"</xsl:comment>
		<xsl:comment>#set var="statement.hyphen" value="-"</xsl:comment>
		
		
    	<xsl:choose>
    		<!-- Article page feeds -->
			<xsl:when test="/H2G2/@TYPE='ARTICLE'">
    			
    			<xsl:choose>
    				
    				<!-- features -->
		            <xsl:when test="/H2G2/ARTICLE/EXTRAINFO/TYPE/@ID=7 and $s_feed='features'">
		            	<xsl:apply-templates select="/H2G2" mode="ssi_features" />
		            </xsl:when>
					
					
					<!-- reviews -->
					<xsl:when test="/H2G2/ARTICLE/EXTRAINFO/TYPE/@ID=5 and $s_feed='reviews'">
		            	<xsl:apply-templates select="/H2G2" mode="ssi_reviews" />
		            </xsl:when>
    				
    			</xsl:choose>
    		
    		</xsl:when>
		
    		<!-- Category page feeds -->
    		<xsl:when test="/H2G2/@TYPE='CATEGORY'">
    		
    			<xsl:apply-templates select="/H2G2" mode="ssi_category" />
    		
   				<xsl:choose>

		            <!-- Articles -->
		            <xsl:when test="$s_feed='articles'">			
		            	<xsl:apply-templates select="/H2G2" mode="ssi_articles" />
		            </xsl:when>
		            
		            <!-- All -->
		            <xsl:when test="$s_feed='allcontent'">
			            <xsl:apply-templates select="/H2G2" mode="ssi_categorycontent" />
		            </xsl:when>
		
			   </xsl:choose>
    		
    		</xsl:when>
    		
    		<!-- Site wide / frontpage feeds -->
    		<xsl:when test="/H2G2/@TYPE='FRONTPAGE'">
    			
    			<xsl:choose>
    			            
		            <!-- Articles -->
		            <xsl:when test="$s_feed='articles'">
		            	<xsl:apply-templates select="/H2G2" mode="ssi_articles" />
		            </xsl:when>
		            
		            <!-- Comments -->
		            <xsl:when test="$s_feed='comments'">
		            	<xsl:apply-templates select="/H2G2" mode="ssi_comments" />
		            </xsl:when>
		            
		            <!-- All -->
		            <xsl:when test="$s_feed='allcontent'">
						<xsl:apply-templates select="/H2G2" mode="ssi_articles" />
		            	<xsl:apply-templates select="/H2G2" mode="ssi_comments" />
		            </xsl:when>
		            		
    			</xsl:choose>
    		
    		</xsl:when>
    		
    		<!-- Return blank if no such feed -->
    		<xsl:otherwise></xsl:otherwise>
    		
    	</xsl:choose>
    	
    	<xsl:if test="/H2G2/PARAMS/PARAM[NAME='s_printenv']">
			<xsl:call-template name="ssi_statement"><xsl:with-param name="statement">#printenv</xsl:with-param></xsl:call-template>
    	</xsl:if>
    	
    </xsl:template>
    
    <!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
							ARTICLE FEEDS
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	
	<xsl:template match="H2G2[@TYPE='ARTICLE']" mode="ssi_features">
		
		<xsl:call-template name="ssi_statement"><xsl:with-param name="statement">#set var="collective.feature.promo.title" value="<xsl:value-of select="/H2G2/ARTICLE/GUIDE/BODY/MAIN-SECTIONS/EDITORIAL/ROW/EDITORIAL-ITEM[1]/BANNER[1]/LINK/text()"/>"</xsl:with-param></xsl:call-template>
		<xsl:call-template name="ssi_statement"><xsl:with-param name="statement">#set var="collective.feature.promo.dnaid" value="<xsl:value-of select="/H2G2/ARTICLE/GUIDE/BODY/MAIN-SECTIONS/EDITORIAL/ROW/EDITORIAL-ITEM[1]/BANNER[1]/LINK/@DNAID"/>"</xsl:with-param></xsl:call-template>
		<xsl:call-template name="ssi_statement"><xsl:with-param name="statement">#set var="collective.feature.promo.type" value="<xsl:value-of select="/H2G2/ARTICLE/GUIDE/BODY/MAIN-SECTIONS/EDITORIAL/ROW/EDITORIAL-ITEM[1]/BANNER[1]/TEXT/text()"/>"</xsl:with-param></xsl:call-template>
		
		<xsl:for-each select="/H2G2/ARTICLE/GUIDE/BODY/MAIN-SECTIONS/EDITORIAL/ROW/EDITORIAL-ITEM[1]/LINK">
			<xsl:call-template name="ssi_statement"><xsl:with-param name="statement">#set var="collective.feature.<xsl:value-of select="position()"/>.title" value="<xsl:value-of select="text()"/>"</xsl:with-param></xsl:call-template>
			<xsl:call-template name="ssi_statement"><xsl:with-param name="statement">#set var="collective.feature.<xsl:value-of select="position()"/>.text" value="<xsl:value-of select="following::BODY/text()"/>"</xsl:with-param></xsl:call-template>
			<xsl:call-template name="ssi_statement"><xsl:with-param name="statement">#set var="collective.feature.<xsl:value-of select="position()"/>.dnaid" value="<xsl:value-of select="@DNAID"/>"</xsl:with-param></xsl:call-template>
			<xsl:call-template name="ssi_statement"><xsl:with-param name="statement">#set var="collective.feature.<xsl:value-of select="position()"/>.type" value="<xsl:value-of select="following::TYPE/text()"/>"</xsl:with-param></xsl:call-template>
			<xsl:call-template name="ssi_statement"><xsl:with-param name="statement">#set var="collective.feature.<xsl:value-of select="position()"/>.img" value="<xsl:value-of select="IMG/@NAME"/>"</xsl:with-param></xsl:call-template>
		</xsl:for-each>	
	
	</xsl:template>
	
	<xsl:template match="H2G2[@TYPE='ARTICLE']" mode="ssi_reviews">
		
		<xsl:call-template name="ssi_statement"><xsl:with-param name="statement">#set var="collective.review.music.promo.title" value="<xsl:value-of select="/H2G2/SITECONFIG/ALBUMWEEK/LINK/text()"/>"</xsl:with-param></xsl:call-template>
		<xsl:call-template name="ssi_statement"><xsl:with-param name="statement">#set var="collective.review.music.promo.text" value="<xsl:value-of select="//H2G2/SITECONFIG/ALBUMWEEK/BODY/text()"/>"</xsl:with-param></xsl:call-template>
		<xsl:call-template name="ssi_statement"><xsl:with-param name="statement">#set var="collective.review.music.promo.dnaid" value="<xsl:value-of select="/H2G2/SITECONFIG/ALBUMWEEK/LINK/@DNAID"/>"</xsl:with-param></xsl:call-template>
		<xsl:call-template name="ssi_statement"><xsl:with-param name="statement">#set var="collective.review.music.promo.type" value="<xsl:value-of select="/H2G2/SITECONFIG/ALBUMWEEK/HEADER/text()"/>"</xsl:with-param></xsl:call-template>
		<xsl:call-template name="ssi_statement"><xsl:with-param name="statement">#set var="collective.review.music.promo.img" value="<xsl:value-of select="/H2G2/SITECONFIG/ALBUMWEEK/IMG/@NAME"/>"</xsl:with-param></xsl:call-template>
		
		<xsl:call-template name="ssi_statement"><xsl:with-param name="statement">#set var="collective.review.film.promo.title" value="<xsl:value-of select="/H2G2/SITECONFIG/CINEMAWEEK/LINK/text()"/>"</xsl:with-param></xsl:call-template>
		<xsl:call-template name="ssi_statement"><xsl:with-param name="statement">#set var="collective.review.film.promo.text" value="<xsl:value-of select="//H2G2/SITECONFIG/CINEMAWEEK/BODY/text()"/>"</xsl:with-param></xsl:call-template>
		<xsl:call-template name="ssi_statement"><xsl:with-param name="statement">#set var="collective.review.film.promo.dnaid" value="<xsl:value-of select="/H2G2/SITECONFIG/CINEMAWEEK/LINK/@DNAID"/>"</xsl:with-param></xsl:call-template>
		<xsl:call-template name="ssi_statement"><xsl:with-param name="statement">#set var="collective.review.film.promo.type" value="<xsl:value-of select="/H2G2/SITECONFIG/CINEMAWEEK/HEADER/text()"/>"</xsl:with-param></xsl:call-template>
		<xsl:call-template name="ssi_statement"><xsl:with-param name="statement">#set var="collective.review.film.promo.img" value="<xsl:value-of select="/H2G2/SITECONFIG/CINEMAWEEK/IMG/@NAME"/>"</xsl:with-param></xsl:call-template>
		
		<xsl:call-template name="ssi_statement"><xsl:with-param name="statement">#set var="collective.review.moreculture.promo.title" value="<xsl:value-of select="/H2G2/SITECONFIG/MORECULTURE/LINK/text()"/>"</xsl:with-param></xsl:call-template>
		<xsl:call-template name="ssi_statement"><xsl:with-param name="statement">#set var="collective.review.moreculture.promo.text" value="<xsl:value-of select="//H2G2/SITECONFIG/MORECULTURE/BODY/text()"/>"</xsl:with-param></xsl:call-template>
		<xsl:call-template name="ssi_statement"><xsl:with-param name="statement">#set var="collective.review.moreculture.promo.dnaid" value="<xsl:value-of select="/H2G2/SITECONFIG/MORECULTURE/LINK/@DNAID"/>"</xsl:with-param></xsl:call-template>
		<xsl:call-template name="ssi_statement"><xsl:with-param name="statement">#set var="collective.review.moreculture.promo.type" value="<xsl:value-of select="/H2G2/SITECONFIG/MORECULTURE/HEADER/text()"/>"</xsl:with-param></xsl:call-template>
		<xsl:call-template name="ssi_statement"><xsl:with-param name="statement">#set var="collective.review.moreculture.promo.img" value="<xsl:value-of select="/H2G2/SITECONFIG/MORECULTURE/IMG/@NAME"/>"</xsl:with-param></xsl:call-template>
	
	</xsl:template>
	
    
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
							FRONT PAGE FEEDS
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	
	<!-- Outputs a count of and list of comments -->
	<xsl:template match="H2G2[@TYPE='FRONTPAGE']" mode="ssi_comments">
		<xsl:variable name="comments" select="TOP-FIVES/TOP-FIVE[@NAME='MostRecentComments']" />

		<!-- comments count -->
       	<xsl:call-template name="ssi_statement"><xsl:with-param name="statement">
       		#set var="collective.comment.count" value="<xsl:choose>
       			<xsl:when test="count(msxsl:node-set($comments)/TOP-FIVE-COMMENTS) &lt; $maxItemCount"><xsl:value-of select="count(msxsl:node-set($comments)/TOP-FIVE-COMMENTS)" /></xsl:when>
       			<xsl:otherwise><xsl:value-of select="$maxItemCount" /></xsl:otherwise>
       		</xsl:choose>
       		<xsl:text>"</xsl:text>
       	</xsl:with-param></xsl:call-template>
       	

       	<!-- comments list -->
        <xsl:apply-templates select="msxsl:node-set($comments)/TOP-FIVE-COMMENTS[position() &lt;= $maxItemCount]" mode="ssi_comment">
			<xsl:sort order="descending" select="DATEUPDATED/DATE/@SORT" data-type="number" />
        </xsl:apply-templates>

	</xsl:template>
	
	
	<!-- Outputs a count of and list of articles -->
	<xsl:template match="H2G2[@TYPE='FRONTPAGE']" mode="ssi_articles">
		<xsl:variable name="articles" select="TOP-FIVES/TOP-FIVE[@NAME='MostRecentIssues']" />

		<!-- Articles count -->
       	<xsl:call-template name="ssi_statement">
       		<xsl:with-param name="statement">#set var="collective.article.count" value="<xsl:choose>
       			<xsl:when test="count(msxsl:node-set($articles)/TOP-FIVE-ARTICLE[EXTRAINFO/TYPE/@ID=1]) &lt; $maxItemCount"><xsl:value-of select="count(msxsl:node-set($articles)/TOP-FIVE-ARTICLE[EXTRAINFO/TYPE/@ID=1])" /></xsl:when>
       			<xsl:otherwise><xsl:value-of select="$maxItemCount" /></xsl:otherwise>
       		</xsl:choose>
       		<xsl:text>"</xsl:text>
       	</xsl:with-param></xsl:call-template>
       	

       	<!-- Articles list -->
        <xsl:apply-templates select="msxsl:node-set($articles)/TOP-FIVE-ARTICLE[EXTRAINFO/TYPE/@ID=1][position() &lt;= $maxItemCount]" mode="ssi_article">
			<xsl:sort order="descending" select="DATEUPDATED/DATE/@SORT" data-type="number" />
        </xsl:apply-templates>

	</xsl:template>	
	
	
	
	
	
    <!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
							CATEGORY PAGE FEEDS
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
		
	<!-- Outputs category details for all category page feeds -->
	<xsl:template match="H2G2" mode="ssi_category">
		
		<xsl:call-template name="ssi_statement"><xsl:with-param name="statement">#set var="collective.category.title" value="<xsl:value-of select="HIERARCHYDETAILS/DISPLAYNAME" />"</xsl:with-param></xsl:call-template>
		
		<xsl:call-template name="ssi_statement"><xsl:with-param name="statement">#set var="collective.category.url" value="<xsl:call-template name="ssi_addtrackingtourl"><xsl:with-param name="url">C<xsl:value-of select="HIERARCHYDETAILS/@NODEID" /></xsl:with-param></xsl:call-template>"</xsl:with-param></xsl:call-template>
		
	</xsl:template>
	
	
	<!-- Outputs a mix of campaigns/user articles in last updated order -->
	<xsl:template match="H2G2[@TYPE='CATEGORY']" mode="ssi_categorycontent">

		<!-- Item count -->
       	<xsl:call-template name="ssi_statement">
       		<xsl:with-param name="statement">#set var="collective.item.count" value="<xsl:choose>
       			<xsl:when test="count(msxsl:node-set($ssi_mixedcontent)/content/*) &lt; $maxItemCount"><xsl:value-of select="count(msxsl:node-set($ssi_mixedcontent)/content/*)" /></xsl:when>
       			<xsl:otherwise><xsl:value-of select="$maxItemCount" /></xsl:otherwise>
       		</xsl:choose>
       		<xsl:text>"</xsl:text>
       	</xsl:with-param></xsl:call-template>
       	

       	<!-- Campaigns list -->
        <xsl:for-each select="msxsl:node-set($ssi_mixedcontent)/content/*">
			<xsl:call-template name="ssi_statement"><xsl:with-param name="statement">#set var="collective.item.<xsl:value-of select="position()" />.title" value="<xsl:apply-templates select="NAME" mode="ssi_minimalmarkup" />"</xsl:with-param></xsl:call-template>
			
			<xsl:call-template name="ssi_statement"><xsl:with-param name="statement">#set var="collective.item.<xsl:value-of select="position()" />.text" value="<xsl:apply-templates select="EXTRAINFO/AUTODESCRIPTION" mode="ssi_minimalmarkup" />"</xsl:with-param></xsl:call-template>
			
			<xsl:call-template name="ssi_statement"><xsl:with-param name="statement">#set var="collective.item.<xsl:value-of select="position()" />.updated" value="<xsl:apply-templates select="LASTUPDATED/DATE" mode="ssi_utcdate" />"</xsl:with-param></xsl:call-template>			
			
						
			<xsl:choose>
				<xsl:when test="name()='CLUBMEMBER'">
					<xsl:call-template name="ssi_statement"><xsl:with-param name="statement">#set var="collective.item.<xsl:value-of select="position()" />.url" value="<xsl:call-template name="ssi_addtrackingtourl"><xsl:with-param name="url">G<xsl:value-of select="CLUBID" /></xsl:with-param></xsl:call-template>"</xsl:with-param></xsl:call-template>
				</xsl:when>
				<xsl:when test="name()='ARTICLEMEMBER'">
					<xsl:call-template name="ssi_statement"><xsl:with-param name="statement">#set var="collective.item.<xsl:value-of select="position()" />.url" value="<xsl:call-template name="ssi_addtrackingtourl"><xsl:with-param name="url">A<xsl:value-of select="H2G2ID" /></xsl:with-param></xsl:call-template>"</xsl:with-param></xsl:call-template>
					<xsl:apply-templates select="EDITOR/USER" mode="ssi_user">
			       		<xsl:with-param name="varPrefix">collective.item.<xsl:value-of select="position()" /></xsl:with-param>
			       	</xsl:apply-templates>
				</xsl:when>
			</xsl:choose>
			
        </xsl:for-each>

	</xsl:template>
	
	
	<!-- Outputs a count of and list of articles -->
	<xsl:template match="H2G2[@TYPE='CATEGORY']" mode="ssi_articles">

		<!-- Count of articles -->
       	<xsl:call-template name="ssi_statement">
       		<xsl:with-param name="statement">#set var="collective.article.count" value="<xsl:choose>
       			<xsl:when test="count(msxsl:node-set($var_global_articles)/articles/ARTICLEMEMBER) &lt; $maxItemCount"><xsl:value-of select="count(msxsl:node-set($var_global_articles)/articles/ARTICLEMEMBER)" /></xsl:when>
       			<xsl:otherwise><xsl:value-of select="$maxItemCount" /></xsl:otherwise>
   			</xsl:choose>
   			<xsl:text>"</xsl:text>
		</xsl:with-param></xsl:call-template>
		

		<!-- Aritcles list -->
        <xsl:apply-templates select="msxsl:node-set($var_global_articles)/articles/ARTICLEMEMBER[position() &lt;= $maxItemCount]" mode="ssi_article" />

	</xsl:template>
	
	
	
	
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
							INDIVIDUAL ITEMS
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	
	
	<!-- Comment item -->
	<xsl:template match="TOP-FIVE-COMMENTS" mode="ssi_comment">

		<xsl:call-template name="ssi_statement"><xsl:with-param name="statement">#set var="collective.comment.<xsl:value-of select="position()"/>.title" value="<xsl:value-of select="TITLE" />"</xsl:with-param></xsl:call-template>
        <xsl:call-template name="ssi_statement"><xsl:with-param name="statement">#set var="collective.comment.<xsl:value-of select="position()"/>.url" value="<xsl:call-template name="ssi_addtrackingtourl"><xsl:with-param name="url">T<xsl:value-of select="THREADID" /></xsl:with-param></xsl:call-template>"</xsl:with-param></xsl:call-template>
        <xsl:call-template name="ssi_statement"><xsl:with-param name="statement">#set var="collective.comment.<xsl:value-of select="position()"/>.updated" value="<xsl:apply-templates select="DATEUPDATED/DATE" mode="ssi_utcdate" />"</xsl:with-param></xsl:call-template>

        <xsl:apply-templates select="USER" mode="ssi_user">
       		<xsl:with-param name="varPrefix">collective.comment.<xsl:value-of select="position()"/></xsl:with-param>
       	</xsl:apply-templates>

       	<xsl:call-template name="ssi_statement"><xsl:with-param name="statement">#set var="collective.comment.<xsl:value-of select="position()"/>.text" value="<xsl:apply-templates select="SUBJECT" mode="ssi_markup" />"</xsl:with-param></xsl:call-template>

	</xsl:template>
	
	
	<!-- Article items -->
    <xsl:template match="TOP-FIVE-ARTICLE|ARTICLEMEMBER" mode="ssi_article">

		<xsl:call-template name="ssi_statement"><xsl:with-param name="statement">#set var="collective.article.<xsl:value-of select="position()"/>.title" value="<xsl:value-of select="NAME|SUBJECT" />"</xsl:with-param></xsl:call-template>
        <xsl:call-template name="ssi_statement"><xsl:with-param name="statement">#set var="collective.article.<xsl:value-of select="position()"/>.url" value="<xsl:call-template name="ssi_addtrackingtourl"><xsl:with-param name="url">A<xsl:value-of select="H2G2ID" /></xsl:with-param></xsl:call-template>"</xsl:with-param></xsl:call-template>
        <xsl:call-template name="ssi_statement"><xsl:with-param name="statement">#set var="collective.article.<xsl:value-of select="position()"/>.updated" value="<xsl:apply-templates select="LASTUPDATED/DATE|DATEUPDATED/DATE" mode="ssi_utcdate" />"</xsl:with-param></xsl:call-template>
        <xsl:apply-templates select="EDITOR/USER|USER" mode="ssi_user">
       		<xsl:with-param name="varPrefix">collective.article.<xsl:value-of select="position()"/></xsl:with-param>
       	</xsl:apply-templates>
       	
       	<xsl:if test="name()='ARTICLEMEMBER'">
       		<xsl:call-template name="ssi_statement"><xsl:with-param name="statement">#set var="collective.article.<xsl:value-of select="position()"/>.isBBCAuthored" value="<xsl:choose><xsl:when test="STATUS/@TYPE=3">0</xsl:when><xsl:otherwise>1</xsl:otherwise></xsl:choose>"</xsl:with-param></xsl:call-template>	
       	</xsl:if>
       	
       	<xsl:call-template name="ssi_statement"><xsl:with-param name="statement">#set var="collective.article.<xsl:value-of select="position()"/>.text" value="<xsl:value-of select="EXTRAINFO/AUTODESCRIPTION" />"</xsl:with-param></xsl:call-template>
        
    </xsl:template>
    
    
    <!-- User details -->
    <xsl:template match="USER" mode="ssi_user">
		<xsl:param name="varPrefix" />
		
		<xsl:variable name="tempUsersName"><xsl:apply-templates select="." mode="l_fullname" /></xsl:variable>
		<xsl:call-template name="ssi_statement"><xsl:with-param name="statement">#set var="<xsl:value-of select="$varPrefix" />.username" value="<xsl:value-of select="translate($tempUsersName, '&nbsp;', ' ')" disable-output-escaping="yes" />"</xsl:with-param></xsl:call-template>
        <xsl:call-template name="ssi_statement"><xsl:with-param name="statement">#set var="<xsl:value-of select="$varPrefix" />.userurl" value="<xsl:call-template name="ssi_addtrackingtourl"><xsl:with-param name="url">U<xsl:value-of select="USERID" /></xsl:with-param></xsl:call-template>"</xsl:with-param></xsl:call-template>

	</xsl:template>
	
    
    <!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
							DATE FORMATTING
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	
	
    <xsl:template match="DATE" mode="ssi_utcdate">
    	<!--<xsl:variable name="dateTime"><xsl:value-of select="@DAYNAME" />, <xsl:value-of select="@DAY" />-<xsl:value-of select="@MONTHNAME" />-<xsl:value-of select="@YEAR" /><xsl:text> </xsl:text><xsl:value-of select="@HOURS" />:<xsl:value-of select="@MINUTES" />:<xsl:value-of select="@SECONDS" /> GMT</xsl:variable>
		<xsl:value-of select="$dateTime" />-->
		<xsl:apply-templates select="." mode="l_ddmmmyyyy"/>
    </xsl:template>
    

    
    
    <!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
						MINIMAL MARKUP TEMPLATES
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	
	
    <xsl:template match="NAME|TEXT|BODY|SUBJECT|AUTODESCRIPTION" mode="ssi_minimalmarkup">
		<xsl:apply-templates select="*|@*|text()" mode="ssi_minimalmarkup" />
	</xsl:template>
    
    <xsl:template match="*" mode="ssi_minimalmarkup"></xsl:template>
	<xsl:template match="@*" mode="ssi_minimalmarkup"></xsl:template>
	
	<xsl:template match="LINK" mode="ssi_minimalmarkup">
		<xsl:text>&lt;a</xsl:text>
		<xsl:apply-templates select="@*" mode="ssi_minimalmarkup" />
		<xsl:text>&gt;</xsl:text>
		<xsl:apply-templates select="*|text()" mode="ssi_minimalmarkup" />
		<xsl:text>&lt;/a&gt;</xsl:text>
	</xsl:template>

	<xsl:template match="@HREF|@TARGET" mode="ssi_minimalmarkup">
		<xsl:text> </xsl:text>
		<xsl:value-of select="translate(name(), $uppercase, $lowercase)" />
		<xsl:text>=\"</xsl:text>
		<xsl:value-of select="." />
		<xsl:text>\"</xsl:text>
	</xsl:template>
	
	<xsl:template match="text()" mode="ssi_minimalmarkup">

		<xsl:variable name="tempText">
			<xsl:call-template name="replacestring">
				<xsl:with-param name="string">
					<xsl:call-template name="replacestring">
						<xsl:with-param name="string" select="." />
						<xsl:with-param name="search">&quot;</xsl:with-param>
						<xsl:with-param name="replace">||-||</xsl:with-param>
					</xsl:call-template>
				</xsl:with-param>
				<xsl:with-param name="search">||-||</xsl:with-param>
				<xsl:with-param name="replace">\&quot;</xsl:with-param>
			</xsl:call-template>
		</xsl:variable>

		<xsl:value-of select="$tempText" disable-output-escaping="yes" />

	</xsl:template>
	
	
    
    <!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
							MARKUP TEMPLATES
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
    
    
    <xsl:template match="TEXT|BODY|SUBJECT" mode="ssi_markup">
		<xsl:apply-templates select="*|@*|text()" mode="ssi_markup" />
	</xsl:template>
	
	<xsl:template match="*" mode="ssi_markup"></xsl:template>
	<xsl:template match="@*" mode="ssi_markup"></xsl:template>
	
	<xsl:template match="BR" mode="ssi_markup">
		<xsl:text>&lt;</xsl:text>
		<xsl:value-of select="translate(name(), $uppercase, $lowercase)" />
		<xsl:text> /&gt;</xsl:text>
	</xsl:template>
	
	<xsl:template match="LINK|A" mode="ssi_markup">
		<xsl:text>&lt;a</xsl:text>
		<xsl:apply-templates select="@*" mode="ssi_markup" />
		<xsl:text>&gt;</xsl:text>
		<xsl:apply-templates select="*|text()" mode="ssi_markup" />
		<xsl:text>&lt;/a&gt;</xsl:text>
	</xsl:template>
	
	<xsl:template match="@HREF|@TARGET" mode="ssi_markup">
		<xsl:text> </xsl:text>
		<xsl:value-of select="translate(name(), $uppercase, $lowercase)" />
		<xsl:text>=\"</xsl:text>
		<xsl:value-of select="." />
		<xsl:text>\"</xsl:text>
	</xsl:template>
	
	<xsl:template match="B|I|U|STRONG|EM|P" mode="ssi_markup">
		<xsl:text>&lt;</xsl:text>
		<xsl:value-of select="translate(name(), $uppercase, $lowercase)" />
		<xsl:apply-templates select="@*" mode="ssi_markup" />
		<xsl:text>&gt;</xsl:text>
		<xsl:apply-templates select="*|text()" mode="ssi_markup" />
		<xsl:text>&lt;/</xsl:text>
		<xsl:value-of select="translate(name(), $uppercase, $lowercase)" />
		<xsl:text>&gt;</xsl:text>
	</xsl:template>
	
	<xsl:template match="text()" mode="ssi_markup">
	
		<xsl:variable name="tempText">
			<xsl:call-template name="replacestring">
				<xsl:with-param name="string">
					<xsl:call-template name="replacestring">
						<xsl:with-param name="string" select="." />
						<xsl:with-param name="search">&quot;</xsl:with-param>
						<xsl:with-param name="replace">||-||</xsl:with-param>
					</xsl:call-template>
				</xsl:with-param>
				<xsl:with-param name="search">||-||</xsl:with-param>
				<xsl:with-param name="replace">\&quot;</xsl:with-param>
			</xsl:call-template>
		</xsl:variable>
		
		<xsl:value-of select="$tempText" disable-output-escaping="yes" />

	</xsl:template>
	
	<xsl:template name="replacestring">
		<xsl:param name="string" />
		<xsl:param name="search" />
		<xsl:param name="replace" />
		
		<xsl:choose>
			<xsl:when test="contains($string, $search)">
				<xsl:call-template name="replacestring">
					<xsl:with-param name="string"><xsl:value-of select="substring-before($string, $search)" /><xsl:value-of select="$replace" /><xsl:value-of select="substring-after($string, $search)" /></xsl:with-param>
					<xsl:with-param name="search" select="$search" />
					<xsl:with-param name="replace" select="$replace" />
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise><xsl:value-of select="$string" /></xsl:otherwise>
		</xsl:choose>
		
	</xsl:template>
	
	
	<!-- Template to make add tracking to all URLs -->
	<xsl:template name="ssi_addtrackingtourl">
		<xsl:param name="url" />
		
		<xsl:choose>
			<xsl:when test="contains($var_global_urlroot, 'www.bbc.co.uk')">
				<xsl:value-of select="$ssi_gotracking" /><xsl:value-of select="$var_global_urlroot"/><xsl:value-of select="$url" />
			</xsl:when>
			<xsl:otherwise><xsl:value-of select="$var_global_urlroot"/><xsl:value-of select="$url" /></xsl:otherwise>
		</xsl:choose>
		
	</xsl:template>
		
	<!-- taken from	actionnetwork: -->
	<xsl:template name="ssi_statement">
    	<xsl:param name="statement" />
		<xsl:comment>#echo encoding="none" var="statement.start"</xsl:comment>
		<xsl:comment>#echo encoding="none" var="statement.hyphen"</xsl:comment>
		<xsl:value-of select="$statement" />
		<xsl:comment>#echo encoding="none" var="statement.hyphen"</xsl:comment>
		<xsl:comment>#echo encoding="none" var="statement.end"</xsl:comment>
		
		<xsl:call-template name="newline" />
		
    </xsl:template>
	
	<!-- used for testing 
	<xsl:template name="ssi_statement">
    	<xsl:param name="statement" />
		<xsl:comment><xsl:value-of select="$statement" /></xsl:comment>
		<xsl:call-template name="newline" />
    </xsl:template>
	-->

</xsl:stylesheet>