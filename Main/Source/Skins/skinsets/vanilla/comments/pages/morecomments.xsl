<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">


    <doc:documentation>
        <doc:purpose>
            Page layout for the users More Comments page
        </doc:purpose>
        <doc:context>
            Applied by the kick off file  (e.g. /html.xsl, /rss.xsl etc)
        </doc:context>
        <doc:notes>
            Provides the comment profile solution
        </doc:notes>
    </doc:documentation>
    
    <xsl:template match="/H2G2[@TYPE = 'MORECOMMENTS']" mode="page">        
        
        <div id="dna-commentprofile">
                
            <xsl:apply-templates select="MORECOMMENTS/COMMENTS-LIST/USER" mode="object_user_profile" />
            
            <p>
                <xsl:text>Listed below are comments made by </xsl:text>
                <xsl:apply-templates select="MORECOMMENTS/COMMENTS-LIST/USER" mode="library_user_morecomments" >
                    <xsl:with-param name="url" select="'.'"></xsl:with-param>
                </xsl:apply-templates>
                <xsl:text> between </xsl:text>
                <xsl:apply-templates select="MORECOMMENTS/COMMENTS-LIST/COMMENTS/COMMENT[position() = last()]/DATEPOSTED/DATE" mode="library_date_longformat"/>
                <xsl:text> and </xsl:text>
                <xsl:apply-templates select="MORECOMMENTS/COMMENTS-LIST/COMMENTS/COMMENT[position() = 1]/DATEPOSTED/DATE" mode="library_date_longformat"/>
                <!--
                <xsl:text> across all </xsl:text>
                <a href="/blogs/">BBC Blogs</a>
                -->
                <xsl:apply-templates select="/H2G2/SITECONFIG/DNACOMMENTTEXT/MORECOMMENTSLABEL" mode="library_siteconfig_morecommentslabel" />
                
                <xsl:text>.</xsl:text>
            </p>
            
            <xsl:apply-templates select="MORECOMMENTS/COMMENTS-LIST" mode="library_pagination_comments-list" />
            
            <xsl:apply-templates select="MORECOMMENTS/COMMENTS-LIST" mode="object_comments-list" />
            
            <xsl:apply-templates select="MORECOMMENTS/COMMENTS-LIST" mode="library_pagination_comments-list" />
        
        </div>
    </xsl:template>
    

</xsl:stylesheet>