<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	xmlns="http://www.w3.org/1999/xhtml"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	version="1.0" 
	xmlns:doc="http://www.bbc.co.uk/dna/documentation"  
	exclude-result-prefixes="doc">
    
    <doc:documentation for="/sites/MySite/objects/post/generic.xsl">
        <doc:purpose>
            Holds the generic HTML construction of a comment
        </doc:purpose>
        <doc:context>
            
        </doc:context>
        <doc:notes>
            This is quite a chunky file, basically a comment could have one of several different 
            states and renderings 
        </doc:notes>
    </doc:documentation>
    
    
    <xsl:template match="POST" mode="object_post_recentcomments">
        <li>
            <xsl:value-of select="USER/USERNAME"/>
            <xsl:text> on </xsl:text>
            <a href="{HOSTPAGEURL}#comment{(@INDEX + 1)}">
                <xsl:call-template name="library_string_searchandreplace">
                    <xsl:with-param name="str">
                        <xsl:value-of select="COMMENTFORUMTITLE"/>
                    </xsl:with-param>
                    <xsl:with-param name="search">
                        <xsl:text>'</xsl:text>
                    </xsl:with-param>
                    <xsl:with-param name="replace">
                        <xsl:text>\'</xsl:text>
                    </xsl:with-param>
                </xsl:call-template>
            </a>
        </li>
    </xsl:template>
     

    
    <xsl:template match="POST[@HIDDEN != 0 and @HIDDEN != 3]" mode="object_post_recentcomments" />       
    <xsl:template match="POST[@HIDDEN = 3 and ./USER/USERID = /H2G2/VIEWING-USER/USER/USERID]" mode="object_post_recentcomments"/>
    <xsl:template match="POST[@HIDDEN = 3 and USER/USERID != /H2G2/VIEWING-USER/USER/USERID or @HIDDEN = 3]" mode="object_post_recentcomments"/>
</xsl:stylesheet>
