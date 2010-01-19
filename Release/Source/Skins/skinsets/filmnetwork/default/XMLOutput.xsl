<?xml version="1.0" encoding="ISO-8859-1"?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet exclude-result-prefixes="msxsl local s dt media" version="1.0" xmlns:content="http://purl.org/rss/1.0/modules/content/" xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:dt="urn:schemas-microsoft-com:datatypes" xmlns:image="http://purl.org/rss/1.0/modules/image/" xmlns:local="#local-functions" xmlns:msxsl="urn:schemas-microsoft-com:xslt"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:media="http://search.yahoo.com/mrss" >

    <xsl:import href="../../../base/rss1/RSSOutput.xsl" />
    <xsl:include href="filmnetwork-sitevars.xsl" />
    
    
    <xsl:variable name="syn_article">
        <SYNDICATION>
            <xsl:choose>
                <xsl:when test="key('pagetype', 'FRONTPAGE') and key('feedtype', 'mwshorts')">
                    <xsl:for-each select="/H2G2/SITECONFIG/MOSTWATCHED/MWSHORT">
                        <ITEM>
                            <xsl:element name="title" namespace="{$thisnamespace}">
                                <xsl:value-of select="LINK" />
                            </xsl:element>
                            <xsl:element name="description" namespace="{$thisnamespace}">
                                <xsl:value-of select="CREDIT" />
                            </xsl:element>
                            <xsl:element name="link" namespace="{$thisnamespace}">
                                <xsl:value-of select="concat($thisserver, $root, LINK/@DNAID)" />
                            </xsl:element>
                            <image:item rdf:about="{$graphics}{IMG/@NAME}">
                                <dc:title>
                                    <xsl:value-of select="IMG/@ALT" />
                                </dc:title>
                                <image:width>
                                    <xsl:value-of select="IMG/@WIDTH" />
                                </image:width>
                                <image:height>
                                    <xsl:value-of select="IMG/@HEIGHT" />
                                </image:height>
                            </image:item>
                        </ITEM>
                    </xsl:for-each>
                </xsl:when>
            </xsl:choose>
        </SYNDICATION>
    </xsl:variable>
    <xsl:variable name="listname_temp" select="translate(/H2G2/PARAMS/PARAM[NAME='s_feed']/VALUE, '_', ' ')" />
    <xsl:variable name="listname" select="substring($listname_temp, 13)" />
    <xsl:variable name="rss_frontpage_description_default" select="$listname" />
    <xsl:variable name="rss_frontpage_title_default">
        <xsl:text>Film Network - </xsl:text>
        <xsl:value-of select="$listname" />
    </xsl:variable>
    <xsl:variable name="rss_rdf_resource_image">
        <xsl:element name="image" namespace="{$thisnamespace}">
            <xsl:attribute name="rdf:resource">http://www.bbc.co.uk/filmnetwork/images/externalpromotion/filmnetwork_blk_small.gif</xsl:attribute>
        </xsl:element>
    </xsl:variable>
    <xsl:variable name="rss_image">
        <xsl:element name="image" namespace="{$thisnamespace}">
            <xsl:attribute name="rdf:about">http://www.bbc.co.uk/filmnetwork/images/externalpromotion/filmnetwork_blk_small.gif</xsl:attribute>
            <xsl:element name="title" namespace="{$thisnamespace}">Film Network</xsl:element>
            <xsl:element name="url" namespace="{$thisnamespace}">http://www.bbc.co.uk/filmnetwork/images/externalpromotion/filmnetwork_blk_small.gif</xsl:element>
            <xsl:element name="link" namespace="{$thisnamespace}">http://www.bbc.co.uk/dna/filmnetwork/</xsl:element>
        </xsl:element>
    </xsl:variable>

    <xsl:template match="H2G2[key('xmltype', 'rss1') or key('xmltype', 'rss')]">
        <rss version="2.0" xmlns:media="http://search.yahoo.com/mrss/">
            <channel>
                <title><xsl:value-of select="$rss_title" /></title>
                <link><xsl:value-of select="$rss_link" /></link>
                <description><xsl:value-of select="$rss_description" /></description>
                <language>en-gb</language>
                <lastBuildDate><xsl:call-template name="shortDayName"><xsl:with-param name="dayName" select="DATE/@DAYNAME" /></xsl:call-template><xsl:value-of select="concat(', ', DATE/@DAY, ' ')" /><xsl:call-template name="shortMonthName"><xsl:with-param name="monthName" select="DATE/@MONTHNAME" /></xsl:call-template><xsl:value-of select="concat(' ', DATE/@YEAR, ' ', DATE/@HOURS, ':', DATE/@MINUTES, ':', DATE/@SECONDS, ' GMT')" /></lastBuildDate>
                <copyright>Copyright: (C) British Broadcasting Corporation, see http://news.bbc.co.uk/1/hi/help/rss/4498287.stm for terms and conditions of reuse</copyright>
                <docs>http://www.bbc.co.uk/syndication/</docs>
                <ttl>15</ttl>
                <image>
                    <title><xsl:value-of select="$sitedisplayname"/></title>
                    <url><xsl:value-of select="concat($imagesource, 'externalpromotion/filmnetwork_blk_small.gif')"/></url>
                    <link><xsl:value-of select="concat($thisserver, $root)" /></link>
                </image>
                <xsl:call-template name="type-check">
                    <xsl:with-param name="content">RSS1</xsl:with-param>
                </xsl:call-template>
            </channel>
        </rss>
    </xsl:template>

    <xsl:template match="ITEM" mode="rss1_frontpagedynamiclist">
        <item>
            <title>
                <xsl:call-template name="validChars">
                    <xsl:with-param name="string" select="ARTICLE-ITEM/SUBJECT" />
                </xsl:call-template>
            </title>
            <description><xsl:apply-templates mode="rss1_copycontent" select="ARTICLE-ITEM/EXTRAINFO/EXTRAINFO/AUTODESCRIPTION/text()" /></description>
            <link><xsl:value-of select="concat($thisserver, $root, 'A', ARTICLE-ITEM/@H2G2ID)" /></link>
            <guid isPermaLink="false"><xsl:value-of select="concat($thisserver, $root, 'A', ARTICLE-ITEM/@H2G2ID)" /></guid>
            <pubDate><xsl:call-template name="shortDayName"><xsl:with-param name="dayName" select="DATE-CREATED/DATE/@DAYNAME" /></xsl:call-template><xsl:value-of select="concat(', ', DATE-CREATED/DATE/@DAY, ' ')" /><xsl:call-template name="shortMonthName"><xsl:with-param name="monthName" select="DATE-CREATED/DATE/@MONTHNAME" /></xsl:call-template><xsl:value-of select="concat(' ', DATE-CREATED/DATE/@YEAR, ' ', DATE-CREATED/DATE/@HOURS, ':', DATE-CREATED/DATE/@MINUTES, ':', DATE-CREATED/DATE/@SECONDS, ' GMT')" /></pubDate>
            <media:thumbnail width="31" height="30">
            <xsl:attribute name="url">
                <xsl:choose>
                    <xsl:when test="/H2G2/PARAMS/PARAM[NAME= 's_feed']/VALUE = 'dynamiclist_magazine_features'">
                        <xsl:value-of select="concat($graphics,'magazine/A',ARTICLE-ITEM/@H2G2ID,'_small.jpg')" />
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="concat($graphics,'shorts/A',ARTICLE-ITEM/@H2G2ID,'_small.jpg')" />
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            </media:thumbnail>
        </item>
    </xsl:template>
    
    <xsl:template name="shortDayName">
        <xsl:param name="dayName" />
        <xsl:choose>
            <xsl:when test="$dayName = 'Monday'">
                <xsl:text>Mon</xsl:text>
            </xsl:when>
            <xsl:when test="$dayName = 'Tuesday'">
                <xsl:text>Tue</xsl:text>
            </xsl:when>
            <xsl:when test="$dayName = 'Wednesday'">
                <xsl:text>Wed</xsl:text>
            </xsl:when>
            <xsl:when test="$dayName = 'Thursday'">
                <xsl:text>Thu</xsl:text>
            </xsl:when>
            <xsl:when test="$dayName = 'Friday'">
                <xsl:text>Fri</xsl:text>
            </xsl:when>
            <xsl:when test="$dayName = 'Saturday'">
                <xsl:text>Sat</xsl:text>
            </xsl:when>
            <xsl:when test="$dayName = 'Sunday'">
                <xsl:text>Sun</xsl:text>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="shortMonthName">
        <xsl:param name="monthName" />
        <xsl:choose>
            <xsl:when test="$monthName = 'January'">
                <xsl:text>Jan</xsl:text>
            </xsl:when>
            <xsl:when test="$monthName = 'February'">
                <xsl:text>Feb</xsl:text>
            </xsl:when>
            <xsl:when test="$monthName = 'March'">
                <xsl:text>Mar</xsl:text>
            </xsl:when>
            <xsl:when test="$monthName = 'April'">
                <xsl:text>Apr</xsl:text>
            </xsl:when>
            <xsl:when test="$monthName = 'May'">
                <xsl:text>May</xsl:text>
            </xsl:when>
            <xsl:when test="$monthName = 'June'">
                <xsl:text>Jun</xsl:text>
            </xsl:when>
            <xsl:when test="$monthName = 'July'">
                <xsl:text>Jul</xsl:text>
            </xsl:when>
            <xsl:when test="$monthName = 'August'">
                <xsl:text>Aug</xsl:text>
            </xsl:when>
            <xsl:when test="$monthName = 'September'">
                <xsl:text>Sep</xsl:text>
            </xsl:when>
            <xsl:when test="$monthName = 'October'">
                <xsl:text>Oct</xsl:text>
            </xsl:when>
            <xsl:when test="$monthName = 'November'">
                <xsl:text>Nov</xsl:text>
            </xsl:when>
            <xsl:when test="$monthName = 'December'">
                <xsl:text>Dec</xsl:text>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>