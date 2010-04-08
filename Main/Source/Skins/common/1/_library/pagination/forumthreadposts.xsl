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
             
        </doc:notes>
    </doc:documentation>
    
    <xsl:template match="FORUMTHREADPOSTS" mode="library_pagination_forumthreadposts">
        <ul class="pagination">
          <li class="first">
              <xsl:choose>
                    <xsl:when test="@SKIPTO > 0">
                        <a href="{$root}/NF{@FORUMID}?thread={@THREADID}&amp;skip=0">
                            <xsl:text>First </xsl:text>
                        </a>
                    </xsl:when>
                    <xsl:otherwise>
                        <span>
                            <xsl:text>First </xsl:text>
                        </span>
                    </xsl:otherwise>
                </xsl:choose>
            </li>
            <li class="previous">
                <xsl:choose>
                    <xsl:when test="@SKIPTO > 0">
                        <a href="{$root}/NF{@FORUMID}?thread={@THREADID}&amp;skip={@SKIPTO - @COUNT}">
                            <span class="arrow">
                                <xsl:text disable-output-escaping="yes"><![CDATA[&laquo;]]></xsl:text>
                            </span>
                            <xsl:text> Previous</xsl:text>
                        </a>
                    </xsl:when>
                    <xsl:otherwise>
                        <span>
                            <span class="arrow">
                                <xsl:text disable-output-escaping="yes"><![CDATA[&laquo;]]></xsl:text>
                            </span>
                            <xsl:text> Previous</xsl:text>
                        </span>
                    </xsl:otherwise>
                </xsl:choose>
            </li>
            <xsl:apply-templates select="." mode="library_pagination_pagelist" />
            <li class="next">
                <xsl:choose>
                    <xsl:when test="(@SKIPTO + @COUNT) &lt; @TOTALPOSTCOUNT">
                        <a href="{$root}/NF{@FORUMID}?thread={@THREADID}&amp;skip={(@SKIPTO + @COUNT)}">
                            <xsl:text>Next </xsl:text>
                            <span class="arrow">
                                <xsl:text disable-output-escaping="yes"><![CDATA[&raquo;]]></xsl:text>
                            </span>
                        </a>
                    </xsl:when>
                    <xsl:otherwise>
                        <span>
                            <xsl:text>Next </xsl:text>
                            <span class="arrow">
                                <xsl:text disable-output-escaping="yes"><![CDATA[&raquo;]]></xsl:text>
                            </span>
                        </span>
                    </xsl:otherwise>
                </xsl:choose>
            </li>
             <li class="last">
              <xsl:choose>
                    <xsl:when test="@MORE != 0">
                    	<a href="{$root}/NF{@FORUMID}?thread={@THREADID}&amp;skip={(floor(@TOTALPOSTCOUNT div @COUNT) * @COUNT)}">
                            <xsl:text> Last</xsl:text>
                        </a>
                    </xsl:when>
                    <xsl:otherwise>
                        <span>
                            <xsl:text> Last</xsl:text>
                        </span>
                    </xsl:otherwise>
                </xsl:choose>
            </li>
        </ul>
    </xsl:template>
    
    <xsl:template match="FORUMTHREADPOSTS" mode="library_pagination_pagelist">
        <!--ceil by floor() + 1-->
        <xsl:param name="totalPages" select="floor(@TOTALPOSTCOUNT div @COUNT) + 1"/>
        <xsl:param name="counter" select="1" />
        <xsl:param name="currentPage" select="floor(@SKIPTO div @COUNT) + 1" />
        
        
        <xsl:if test="($totalPages > 1) and ($counter > ($currentPage - 6) ) and ($counter &lt; ($currentPage + 6) )">
            <li>
                <xsl:if test="$currentPage = $counter">
                    <xsl:attribute name="class">current</xsl:attribute>
                </xsl:if>
                <a href="{$root}/NF{@FORUMID}?thread={@THREADID}&amp;skip={@COUNT * ($counter - 1)}">
                    <xsl:value-of select="$counter"/>
                </a>
            </li>
        </xsl:if>
        
        <xsl:if test="$counter &lt; $totalPages">
            <xsl:apply-templates select="." mode="library_pagination_pagelist">
                <xsl:with-param name="counter" select="$counter + 1" />
                <xsl:with-param name="totalPages" select="$totalPages" />
                <xsl:with-param name="currentPage" select="$currentPage" />
            </xsl:apply-templates>
        </xsl:if>
           
    </xsl:template>
    
</xsl:stylesheet>