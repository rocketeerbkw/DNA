<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc" xmlns:dna="http://www.bbc.co.uk/dna">
    
    <doc:documentation>
        <doc:purpose>
            Transforms POSTLIST to list of threads a user has posted in.
        </doc:purpose>
        <doc:context>
            Applied on the user page to display conversations
        </doc:context>
        <doc:notes>
            Currently limits to 15 threads, should be paginated or something?
        </doc:notes>
    </doc:documentation>
    
    
    <xsl:template match="COMMENTFORUM-ITEM" mode="object_commentforum-item">
        <item>
            <title><xsl:value-of select="TITLE"/></title>
            <link>
                <xsl:value-of select="URL"/>
            </link>
            <description>
                <xsl:value-of select="COMMENTFORUMPOSTCOUNT"/>
                <xsl:text> comment</xsl:text>
                <xsl:if test="COMMENTFORUMPOSTCOUNT != 1">
                    <xsl:text>s</xsl:text>    
                </xsl:if>
            </description>
            <dna:postCount>
                <xsl:value-of select="COMMENTFORUMPOSTCOUNT"/>
            </dna:postCount>
        </item>
    </xsl:template>
    
</xsl:stylesheet>