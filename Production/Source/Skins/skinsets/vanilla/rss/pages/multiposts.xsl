<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"  xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">
    
    <doc:documentation>
        <doc:purpose>
            HTML Layout for pages of type 'multipost'
        </doc:purpose>
        <doc:context>
            Called by output.xsl
        </doc:context>
        <doc:notes>
            Output from here ends up between the document body tag 
        </doc:notes>
    </doc:documentation>
    
    
    <xsl:variable name="head" doc:description="If you wish to make additions to the &lt;head&gt; element of the output, add them here">
        <!--
            For example:
            
            <css>
                <file>myPageSpecificStyle.css</file>
            </css>
            <javascript>
                <file>pageSpecific.js</file>
                <file>anotherFile.js</file>
            </javascript>
        -->
    </xsl:variable>
    
    
    <xsl:template match="/H2G2[@TYPE = 'MULTIPOSTS']" mode="page">        
    	<title><xsl:value-of select="FORUMTHREADPOSTS/FIRSTPOSTSUBJECT"/></title>
    	<link><xsl:value-of select="concat($server, $root, '/F', FORUMTHREADPOSTS/@FORUMID, '?thread=', FORUMTHREADPOSTS/@THREADID)"/></link>
    	<description>
    		<xsl:variable name="postcount" select="count(FORUMTHREADPOSTS/POST)"/>
    		<xsl:value-of select="$postcount"/>
    		<xsl:text> post</xsl:text>
    		<xsl:if test="$postcount != 1">s</xsl:if>
    	</description>
        <docs>http://www.bbc.co.uk/dna/documentation/</docs>
        <ttl>60</ttl>
        <language>en-gb</language>
        <lastBuildDate>Wed, 4 Jul 2007 08:02:48 GMT</lastBuildDate>
        <!-- Insert posts-->
        <xsl:apply-templates select="FORUMTHREADPOSTS/POST" mode="object_post" />
    </xsl:template>
    
    
</xsl:stylesheet>
