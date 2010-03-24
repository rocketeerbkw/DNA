<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">


    <doc:documentation>
        <doc:purpose>
            
        </doc:purpose>
        <doc:context>
            
        </doc:context>
        <doc:notes>
            
        </doc:notes>
    </doc:documentation>

    <xsl:template match="/H2G2[@TYPE = 'MOVE-THREAD']" mode="page">
        
        <xsl:apply-templates select="MOVE-THREAD-FORM" mode="input_move-thread-form" />
        
    </xsl:template>
    
    <xsl:template match="/H2G2[@TYPE = 'MOVE-THREAD']" mode="breadcrumbs">
        <li>
            <a href="{$root}"><xsl:value-of select="concat(/H2G2/SITECONFIG/BOARDNAME, ' message boards')"/></a>
        </li>
        <li>
            <a href="{$root}/NF{MOVE-THREAD-FORM/OLD-FORUM-ID}">
                <xsl:value-of select="MOVE-THREAD-FORM/OLD-FORUM-TITLE" />
            </a>
        </li>
        <li class="current">
            <a href="{$root}/MoveThread?cmd=Fetch&amp;ThreadID={MOVE-THREAD-FORM/THREAD-ID}&amp;DestinationID=F0&amp;mode=" class="startanewdiscussion">
                <xsl:value-of select="concat('Move discussion: ', MOVE-THREAD-FORM/THREAD-SUBJECT)"/>
            </a>
        </li>
    </xsl:template>

</xsl:stylesheet>