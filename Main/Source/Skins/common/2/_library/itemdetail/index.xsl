<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">
    
    <doc:documentation>
        <doc:purpose>
            Passes DATEPOSTED nodes to library_date_longformat
        </doc:purpose>
        <doc:context>
            Applied by _common/_library/itemdetail.xsl
        </doc:context>
        <doc:notes>
            
        </doc:notes>
    </doc:documentation>
    
    <xsl:template match="COMMENTBOX/FORUMTHREADPOSTS/POST/@INDEX" mode="library_itemdetail">
        <span class="permalink">
            <a href="#comment{(. + 1)}">permalink<span class="blq-hide"> comment: <xsl:value-of select="../SUBJECT"/></span></a>
        </span>
    </xsl:template>
    
    <xsl:template match="FORUMTHREADPOSTS/POST/@INDEX" mode="library_itemdetail">
        <p class="permalink">
            <a href="#p{(../@POSTID)}">Link to this<span class="blq-hide"> forum: <xsl:value-of select="../SUBJECT"/></span></a>
        </p>
    </xsl:template>
</xsl:stylesheet>