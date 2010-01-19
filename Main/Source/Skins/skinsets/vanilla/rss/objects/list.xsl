<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">
    
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
    
    
    <xsl:template match="LIST" mode="object_list">
      <xsl:apply-templates select="ITEM-LIST/ITEM/COMMENTFORUM-ITEM" mode="object_commentforum-item" />
    </xsl:template>
    
</xsl:stylesheet>