<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">


    <doc:documentation>
        <doc:purpose>
            Page layout for an article page
        </doc:purpose>
        <doc:context>
            Applied by the kick off file  (e.g. /html.xsl, /rss.xsl etc)
        </doc:context>
        <doc:notes>
            This defines the article page layout, not to be confused with the article object...
        </doc:notes>
    </doc:documentation>
    
    <xsl:template match="/H2G2[@TYPE = 'NOTFOUND']" mode="page">        
        
        <h2>There has been a problem...</h2>
        
        <p>We can't find the page you requested. Try checking the address for spelling mistakes or extra spaces.</p>
        
        <p>Alternatively, you can view the <a href="/dna/{/H2G2/SITECONFIG/BOARDROOT}"><xsl:value-of select="concat(/H2G2/SITECONFIG/BOARDNAME, ' messageboard topics')"/></a> or go to <a href="http://www.bbc.co.uk">the BBC Homepage</a>.</p>
        
    </xsl:template>
    
    <xsl:template match="/H2G2[@TYPE = 'NOTFOUND']" mode="breadcrumbs">
        <li class="current">
            <a href="{$root}"><xsl:value-of select="concat(/H2G2/SITECONFIG/BOARDNAME, ' message boards')"/></a>
        </li>
    </xsl:template>

</xsl:stylesheet>