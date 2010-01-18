<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">


    <doc:documentation>
        <doc:purpose>
          
        </doc:purpose>
        <doc:context>
            Applied by the kick off file  (e.g. /html.xsl, /rss.xsl etc)
        </doc:context>
        <doc:notes>
          
        </doc:notes>
    </doc:documentation>
	
	<xsl:variable name="thisUser" select="/H2G2/VIEWING-USER/USER/USERID"/>
    
    <xsl:template match="/H2G2[@TYPE = 'MOREPOSTS']" mode="page">
        <xsl:apply-templates select="/H2G2/POSTS/POST-LIST" />
    </xsl:template>
    
    <xsl:template match="POST-LIST">
        <title>
            <xsl:text>Posts made by </xsl:text>
            <xsl:value-of select="USER/USERNAME"/>
        	<xsl:text> (U</xsl:text><xsl:value-of select="USER/USERID"/><xsl:text>)</xsl:text>
        </title>
        <link>
            <xsl:text>http://www.bbc.co.uk/blogs/service/user/</xsl:text>
            <xsl:value-of select="@USERID"/>
        </link>
        <language>en-gb</language>
        <ttl>30</ttl>
        <pubDate><xsl:apply-templates select="/H2G2/DATE" mode="utils" /></pubDate>
        <description><xsl:value-of select="count(POST)"/> post<xsl:if test="count(POST) != 1">s</xsl:if></description>
        
        <xsl:apply-templates select="POST" mode="moreposts" />
    </xsl:template>
    
    <xsl:template match="POST" mode="moreposts">
        <item>
            <title>
            	<xsl:text>Forum: </xsl:text><xsl:value-of select="THREAD/FORUMTITLE"/>
            </title>
            <link>
            	<xsl:value-of select="concat($server, $root, '/F', THREAD/@FORUMID, '?thread=', THREAD/@THREADID, '#p', @POSTID)"/>
            </link>
            <description>
            		<xsl:if test="not(FIRSTPOSTER/USER/USERID = $thisUser)">
            			<xsl:text>In reply to: </xsl:text>
            		</xsl:if>
            		<xsl:value-of select="THREAD/SUBJECT"/>
            </description>
            <pubDate>
            		<xsl:apply-templates select="THREAD/REPLYDATE/DATE" mode="utils" />
           	</pubDate>
        </item>
    </xsl:template>
    

</xsl:stylesheet>