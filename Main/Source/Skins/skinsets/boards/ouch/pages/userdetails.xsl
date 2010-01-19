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
    
    <xsl:template match="/H2G2[@TYPE = 'USERDETAILS']" mode="page">        
        
        <xsl:apply-templates select="USER-DETAILS-FORM" mode="input_user-details-form" />
        
    </xsl:template>
    
    <xsl:template match="/H2G2[@TYPE = 'USERDETAILS']" mode="breadcrumbs">
        <li>
            <a href="/"><xsl:value-of select="concat(/H2G2/SITECONFIG/BOARDNAME, ' message boards')"/></a>
        </li>
        <li class="current">
            <a href="userdetails">
                <xsl:text>Change your nickname</xsl:text>
            </a>
        </li>
    </xsl:template>
    

</xsl:stylesheet>