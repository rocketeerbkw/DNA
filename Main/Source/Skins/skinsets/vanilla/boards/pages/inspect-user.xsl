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
    
    <xsl:template match="/H2G2[@TYPE = 'INSPECT-USER']" mode="page">        
        
        <xsl:apply-templates select="INSPECT-USER-FORM" mode="input_inspect-user-form" />
        
    </xsl:template>
    
    <xsl:template match="/H2G2[@TYPE = 'INSPECT-USER']" mode="breadcrumbs">
        <li>
            <a href="{$root}"><xsl:value-of select="concat(/H2G2/SITECONFIG/BOARDNAME, ' message boards')"/></a>
        </li>
        <li class="current">
            <a href="{$root}/InspectUser">
                <xsl:value-of select="concat('Inspecting ', INSPECT-USER-FORM/USER/USERNAME)" />
            </a>
        </li>
    </xsl:template>
    

</xsl:stylesheet>