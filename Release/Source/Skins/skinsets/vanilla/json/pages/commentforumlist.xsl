<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">


    <doc:documentation>
        <doc:purpose>
            Page layout for a commentbox page (as used in the acs feature)
        </doc:purpose>
        <doc:context>
            Applied by the kick off file  (e.g. /html.xsl, /rss.xsl etc)
        </doc:context>
        <doc:notes>
            This particluar page also packages various lists in ssi vars, for use
            during output.
        </doc:notes>
    </doc:documentation>
    
    <xsl:template match="/H2G2[@TYPE = 'COMMENTFORUMLIST']" mode="page">
        <xsl:apply-templates select="." mode="object_error"/>        
    </xsl:template>
</xsl:stylesheet>