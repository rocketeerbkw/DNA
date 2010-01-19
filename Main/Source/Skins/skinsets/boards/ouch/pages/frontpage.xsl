<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">


    <doc:documentation>
        <doc:purpose>
            Page layout for a DNA front page
        </doc:purpose>
        <doc:context>
            Applied by the kick off file  (e.g. /html.xsl, /rss.xsl etc)
        </doc:context>
        <doc:notes>
            Used here to output the correct HTML for a BBC Homepage module
        </doc:notes>
    </doc:documentation>
    
    
    
    <xsl:template match="/H2G2[@TYPE = 'FRONTPAGE']" mode="page">
        <div id="tagline">
            <h2>About this Board</h2>
            <p>This messageboard is the beating heart of the Ouch community where you talk to us and each other.</p>
            <p>The Ouch Messageboard is <a href="http://www.bbc.co.uk/messageboards/newguide/popup_checking_messages.html#B" class="popup">reactively moderated</a></p>
            <h2>Opening hours</h2>
            <!-- <p>Open 24 hours a day, 365 days a year.</p> -->
            <p>Please note that the boards will be closed during the following periods:</p>
			<ul>
				<li>- 6pm on Thursday 24th December to 9am Sunday 27th December</li>
				<li>- 6pm on Thursday 31st December to 9am Saturday 2nd January</li>
			</ul>
          </div>
        <xsl:apply-templates select="TOPICLIST" mode="object_topiclist" />
        
    </xsl:template>
    
    <xsl:template match="/H2G2[@TYPE = 'FRONTPAGE']" mode="breadcrumbs">
        <li class="current">
            <a href="{$root}"><xsl:value-of select="concat(/H2G2/SITECONFIG/BOARDNAME, ' messageboards')"/></a>
        </li>
    </xsl:template>

</xsl:stylesheet>