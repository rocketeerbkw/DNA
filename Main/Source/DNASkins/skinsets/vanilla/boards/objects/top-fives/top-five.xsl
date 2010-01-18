<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">
    
    <doc:documentation for="/sites/MySite/objects/post/generic.xsl">
        <doc:purpose>
            Holds the generic HTML construction of a post
        </doc:purpose>
        <doc:context>
            Called by object-post (_common/_logic/_objects/post.xsl)
        </doc:context>
        <doc:notes>
            GuideML is the xml format (similiar to HTML) that user entered content is
            stored in. 
        </doc:notes>
    </doc:documentation>
    
    
    <xsl:template match="TOP-FIVE" mode="object_top-fives_top-five">
        
        
        <div class="hpData">
            <h3><xsl:value-of select="TITLE"/></h3>
            <p class="addremove"><a href="#" class="add"><span class="hide">Add a Story to this feed</span></a> <a class="remove" href="#"><span class="hide">Remove a story from this feed</span></a></p>
            <ul class="{translate( string(count(preceding-sibling::*) + 1), '1234', 'abcd')}">
                <xsl:apply-templates select="TOP-FIVE-ARTICLE" mode="object_top-fives_top-five-article"/>
                <xsl:apply-templates select="TOP-FIVE-FORUM" mode="object_top-fives_top-five-forum"/>
            </ul>
        </div>
        
    </xsl:template>
	
	<xsl:template match="TOP-FIVE" mode="object_top-five_rhn">
		<h3><xsl:value-of select="TITLE"/></h3>
		<ul class="dna-topfive {translate( string(count(preceding-sibling::*) + 1), '1234', 'abcd')}">
			<xsl:apply-templates select="TOP-FIVE-ARTICLE" mode="object_top-fives_top-five-article"/>
			<xsl:apply-templates select="TOP-FIVE-FORUM" mode="object_top-fives_top-five-forum"/>
		</ul>
	</xsl:template>
	
</xsl:stylesheet>
