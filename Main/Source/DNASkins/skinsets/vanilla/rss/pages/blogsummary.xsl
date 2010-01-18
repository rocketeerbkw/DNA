<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation" xmlns:comment-feeds="http://www.bbc.co.uk/blogs/comment-feeds"  exclude-result-prefixes="doc comment-feeds" xmlns:dna="http://www.bbc.co.uk/dna">

    <doc:documentation>
        <doc:purpose>
          
        </doc:purpose>
        <doc:context>
            Applied by the kick off file  (e.g. /html.xsl, /rss.xsl etc)
        </doc:context>
        <doc:notes>
          
        </doc:notes>
    </doc:documentation>
    
    <xsl:template match="/H2G2[@TYPE = 'BLOGSUMMARY']" mode="page">
        <xsl:apply-templates select="RECENTCOMMENTS" />
    </xsl:template>
    
    <xsl:template match="/H2G2[@TYPE = 'BLOGSUMMARY'][/H2G2/PARAMS/PARAM[NAME = 's_flavour']/VALUE = 'beingdiscussednow']" mode="page">
        <xsl:apply-templates select="COMMENTFORUMLIST" />
    </xsl:template>

    <xsl:template match="COMMENTFORUMLIST">
        <title>BBC Blogs - Being Discussed Now</title>
        <link>http://www.bbc.co.uk/blogs/service/beingdiscussednow</link>
        <language>en-gb</language>
        <ttl>30</ttl>
        <pubDate><xsl:apply-templates select="/H2G2/DATE" mode="utils" /></pubDate>
        <description>Blog entries being discussed now on BBC Blogs</description>
        
        <xsl:apply-templates select="COMMENTFORUM" mode="commentforum" >
            <xsl:sort select="@FORUMPOSTCOUNT" data-type="number" order="descending"/>
        </xsl:apply-templates>
    </xsl:template>
    
    <xsl:template match="RECENTCOMMENTS">
        <title>BBC Blogs - Recent Comments</title>
        <link>http://www.bbc.co.uk/blogs/service/recentcomments</link>
        <language>en-gb</language>
        <ttl>30</ttl>
        <pubDate><xsl:apply-templates select="/H2G2/DATE" mode="utils" /></pubDate>
        <description>Recent comments made on BBC Blogs</description>
        
        <xsl:apply-templates select="POST" mode="recentcomments" />
    </xsl:template>
    
    <xsl:template match="POST" mode="recentcomments">
        <item>
            <title><xsl:value-of select="COMMENTFORUMTITLE"/></title>
            <link>
                <xsl:value-of select="HOSTPAGEURL"/>
            </link>
            <description><xsl:value-of select="TEXT"/></description>
            <pubDate><xsl:apply-templates select="DATEPOSTED/DATE" mode="utils" /></pubDate>
            <author><xsl:value-of select="USER/USERID"/></author>
            <comment-feeds:username>
                <xsl:value-of select="USER/USERNAME"/>   
            </comment-feeds:username>
        </item>
    </xsl:template>
    
    <xsl:template match="COMMENTFORUM" mode="commentforum">
        <item>
            <title><xsl:value-of select="TITLE"/></title>
            <link>
                <xsl:value-of select="HOSTPAGEURL"/>
            </link>
            <description>
                <xsl:value-of select="@FORUMPOSTCOUNT"/>
                <xsl:text> comment</xsl:text>
                <xsl:if test="@FORUMPOSTCOUNT != 1">
                    <xsl:text>s</xsl:text>
                </xsl:if>
            </description>
            <pubDate><xsl:apply-templates select="DATECREATED/DATE" mode="utils" /></pubDate>
            <dna:postCount>
                <xsl:value-of select="@FORUMPOSTCOUNT"/>
            </dna:postCount>
        </item>
    </xsl:template>
    
</xsl:stylesheet>