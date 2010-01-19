<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet exclude-result-prefixes="msxsl local s dt" version="1.0" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:dt="urn:schemas-microsoft-com:datatypes"
        xmlns:image="http://purl.org/rss/1.0/modules/image/" xmlns:local="#local-functions" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
        xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
        <xsl:import href="../../../base/rss1/RSSOutput.xsl"/>
        <xsl:variable name="feed-name">
                <xsl:value-of select="substring-after(/H2G2/PARAMS/PARAM[NAME = 's_feed']/VALUE, '_')"/>
        </xsl:variable>
        <xsl:variable name="feed-amount">
                <xsl:value-of select="/H2G2/PARAMS/PARAM[NAME = 's_feedamount']/VALUE"/>
        </xsl:variable>
        <xsl:variable name="root">http://www.bbc.co.uk/dna/collective/</xsl:variable>
        <xsl:variable name="editorial-email">rowan.kerek@bbc.co.uk</xsl:variable>
        <xsl:variable name="technical-email">darren.hurley@bbc.co.uk</xsl:variable>
        <xsl:template match="H2G2[PARAMS/PARAM/NAME = 's_feed']">
                <rss version="2.0">
                        <channel>
                                <title>collective</title>
                                <link>
                                        <xsl:value-of select="concat($root, 'C', HIERARCHYDETAILS/@NODEID)"/>
                                </link>
                                <description>the latest <xsl:value-of select="HIERARCHYDETAILS/DISPLAYNAME"/> articles</description>
                                <language>en-gb</language>
                                <lastBuildDate>
                                        <xsl:apply-templates select="HIERARCHYDETAILS/ARTICLE/ARTICLEINFO/LASTUPDATED/DATE"></xsl:apply-templates>
                                </lastBuildDate>
                                <docs>http://blogs.law.harvard.edu/tech/rss</docs>
                                <managingEditor>
                                        <xsl:value-of select="$editorial-email"/>
                                </managingEditor>
                                <webMaster>
                                        <xsl:value-of select="$technical-email"/>
                                </webMaster>
                                <generator>DNA</generator>
                                <category>
                                        <xsl:value-of select="HIERARCHYDETAILS/DISPLAYNAME"/>
                                </category>
                                <xsl:choose>
                                        <xsl:when test="$feed-amount &gt; 0">
                                                <xsl:apply-templates select="DYNAMIC-LISTS/LIST[@LISTNAME = $feed-name]/ITEM-LIST/ITEM[position() &lt;= $feed-amount]" />                                             
                                        </xsl:when>
                                        <xsl:otherwise>
                                                <xsl:apply-templates select="DYNAMIC-LISTS/LIST[@LISTNAME = $feed-name]/ITEM-LIST/ITEM" />                                             
                                        </xsl:otherwise>
                                </xsl:choose>
                        </channel>
                </rss>
        </xsl:template>
        <xsl:template match="ITEM">
                <item>
                        <title><xsl:value-of select="TITLE"/></title>
                        <link><xsl:value-of select="concat($root, 'A', ARTICLE-ITEM/@H2G2ID)"/></link>
                        <description><xsl:value-of select="AUTODESCRIPTION" /></description>
                        <pubDate><xsl:apply-templates select="DATE-CREATED/DATE"></xsl:apply-templates></pubDate>
                        <guid isPermaLink="true"><xsl:value-of select="concat($root, 'A', ARTICLE-ITEM/@H2G2ID)"/></guid>
                </item>
        </xsl:template>
        <xsl:template match="DATE">
                <xsl:value-of select="substring(@DAYNAME, 1, 3)"/>
                <xsl:text>, </xsl:text>
                <xsl:value-of select="@DAY"/>
                <xsl:text> </xsl:text>
                <xsl:value-of select="substring(@MONTHNAME, 1, 3)"/>
                <xsl:text> </xsl:text>
                <xsl:value-of select="@YEAR"/>
                <xsl:text> </xsl:text>
                <xsl:value-of select="@HOURS"/>
                <xsl:text>:</xsl:text>
                <xsl:value-of select="@MINUTES"/>
                <xsl:text>:</xsl:text>
                <xsl:value-of select="@SECONDS"/>
                <xsl:text> GMT</xsl:text>
        </xsl:template>
</xsl:stylesheet>
