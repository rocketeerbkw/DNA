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
        
        <div class="column">
            <!--
            -->
        
            <xsl:apply-templates select="COMMENTFORUMLIST" mode="object_commentforumlist"/>
        </div>
        
        
        <div class="column">
            
            <div id="detail" class="small-panel module">
                <xsl:call-template name="library_header_h2">
                    <xsl:with-param name="text" select="'Filter Pages'" />
                </xsl:call-template>
                
                <p>Filter the list of comments on the left by the DNA site name or by address of your website.</p>
                
                <form method="get" action="commentforumlist">
                    <fieldset>
                        <legend>DNA Site</legend>
                        <p>
                            <label for="dna-siteid">Select site</label>
                            <xsl:apply-templates select="/H2G2/EDITOR-SITE-LIST" mode="object_editor-site-list" />
                        </p>
                        <p>
                            <input type="submit" value="Filter" />
                        </p>
                    </fieldset>
                </form>
                
                <form method="get" action="commentforumlist" class="endcorners">
                    <fieldset>
                        <legend>Website address</legend>
                        <p>
                            <label for="dna-siteid">Select site</label>
                            <input type="text" value="http://www.bbc.co.uk/" name="dnahostpageurl" class="text"/>
                        </p>
                        <p>
                            <input type="submit" value="Filter" />
                        </p>
                    </fieldset>
                </form>
                
            </div>
            
            <!-- evil -->
            <xsl:if test="COMMENTFORUMLIST/COMMENTFORUM">
                <div class="small-panel module">
                    <h2>Jump To</h2>
                    <ul>
                        <xsl:variable name="skip" select="COMMENTFORUMLIST/@SKIP" />
                        <xsl:apply-templates select="COMMENTFORUMLIST/COMMENTFORUM[position() > $skip]" mode="object_commentforum_quicklist" >
                            <xsl:sort select="LASTUPDATED/DATE/@SORT" order="descending"/>
                        </xsl:apply-templates>
                    </ul>
                </div>
            </xsl:if>
            
        </div>
        
    </xsl:template>
    
    <xsl:template match="/H2G2[@TYPE = 'COMMENTFORUMLIST']" mode="head_additional">
        <script type="text/javascript" src="/hello.js"></script>
    </xsl:template>
    
</xsl:stylesheet>