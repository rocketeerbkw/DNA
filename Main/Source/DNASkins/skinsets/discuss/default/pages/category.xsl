<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">


    <doc:documentation>
        <doc:purpose>
            Page layout for a catergory page
        </doc:purpose>
        <doc:context>
            Applied by the kick off file  (e.g. /html.xsl, /rss.xsl etc)
        </doc:context>
        <doc:notes>
            
        </doc:notes>
    </doc:documentation>
    
    
    
    <xsl:template match="/H2G2[@TYPE = 'CATEGORY']" mode="page">
        
        <div class="column wide">
                
            <!-- Insert article object-->
            <xsl:apply-templates select="HIERARCHYDETAILS/ARTICLE" mode="object_article" />
           
            <!-- Add the forum-->
            <xsl:apply-templates select="HIERARCHYDETAILS/MEMBERS" mode="object_members" />
            
            <p class="quicklinks">
                <xsl:if test="count(HIERARCHYDETAILS/ANCESTRY/ANCESTOR) > 1">
                    <a href="C{HIERARCHYDETAILS/ANCESTRY/child::ANCESTOR[position() = last()]/NODEID}">
                        Return to '<xsl:value-of select="HIERARCHYDETAILS/ANCESTRY/child::ANCESTOR[position() = last()]/NAME"/>'
                    </a>
                </xsl:if>
            </p>
        
        </div>
    </xsl:template>

</xsl:stylesheet>