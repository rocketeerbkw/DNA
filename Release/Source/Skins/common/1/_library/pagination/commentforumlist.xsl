<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">
    
    <doc:documentation>
        <doc:purpose>
            pagination
        </doc:purpose>
        <doc:context>
            Applied by _common/_library/GuideML.xsl
        </doc:context>
        <doc:notes>
           working with the show, to and from, calculate the querystring
           
           this desperately needs to be split into its component parts correctly:
           
           logic layer 
            - work out the FORUMTHREAD type, its skip, step or from and to values and compute them into
              a collection of useful parameters for the skin.
              
           site layer
            - take params and work into relelvant links etc
            
            
            29/04/08 - Tweak page number list logic to avoid recursion when from and to = 0. 
        </doc:notes>
    </doc:documentation>
        
    <xsl:template match="COMMENTFORUMLIST" mode="library_pagination_commentforumlist">
        <!-- [(@SHOW + @SKIP) &lt; (@COMMENTFORUMLISTCOUNT + 1)] -->
        <ul class="pagination">
            <li class="previous">
                <xsl:choose>
                    <xsl:when test="@SKIP > 0">
                        <a href="?dnasiteid={@REQUESTEDSITEID}&amp;dnaskip={(@SKIP - @SHOW)}&amp;dnashow={@SHOW}">
                            <xsl:text>Previous</xsl:text>
                        </a>
                    </xsl:when>
                    <xsl:otherwise>
                        <span>Previous</span>
                    </xsl:otherwise>
                </xsl:choose>
            </li>
            <li class="next">
                
                <xsl:choose>
                    <xsl:when test="@COMMENTFORUMLISTCOUNT > (@SKIP + @SHOW)">
                        <a href="?dnasiteid={@REQUESTEDSITEID}&amp;dnaskip={(@SKIP + @SHOW)}&amp;dnashow={@SHOW}">
                            <xsl:text>Next</xsl:text>
                        </a>
                    </xsl:when>
                    <xsl:otherwise>
                        <span>Next</span>
                    </xsl:otherwise>
                </xsl:choose>
            </li>
        </ul>
    </xsl:template>
    
    
</xsl:stylesheet>