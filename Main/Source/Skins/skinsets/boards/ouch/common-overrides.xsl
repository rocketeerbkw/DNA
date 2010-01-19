<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">
    
    <doc:documentation>
        <doc:purpose>
          overrides for common functionality
        </doc:purpose>
        <doc:context>
          
        </doc:context>
        <doc:notes>
          Ouch! need all links in their messageboard to be relative, not absolute. This is due to the accessibility widget cookie only recognising sites that begin /ouch/
          
          Ouch are implementing a reweite rule to route all requests from /dna/ to /ouch/
          
          This include is to override all functionality in the common XSLT libraries which build absolute links ({$root}/...)
        </doc:notes>
    </doc:documentation>
    
    <xsl:template match="FORUMTHREADPOSTS" mode="library_pagination_forumthreadposts" priority="1">
        <ul class="pagination">
          <li class="first">
              <xsl:choose>
                    <xsl:when test="@SKIPTO > 0">
                        <a href="F{@FORUMID}?thread={@THREADID}&amp;skip=0">
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
                        <a href="F{@FORUMID}?thread={@THREADID}&amp;skip={@SKIPTO - @COUNT}">
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
                    <xsl:when test="@MORE != 0">
                        <a href="F{@FORUMID}?thread={@THREADID}&amp;skip={@SKIPTO + @COUNT}">
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
                    	<a href="F{@FORUMID}?thread={@THREADID}&amp;skip={(floor(@TOTALPOSTCOUNT div @COUNT) * @COUNT)}">
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
				<a href="F{@FORUMID}?thread={@THREADID}&amp;skip={@COUNT * ($counter - 1)}">
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
    
  
   <xsl:template match="FORUMTHREADS" mode="library_pagination_forumthreads" priority="1">
        <ul class="pagination">
            <li class="first">
              <xsl:choose>
                    <xsl:when test="@SKIPTO > 0">
                        <a href="F{@FORUMID}?skip=0">
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
                        <a href="F{@FORUMID}?skip={@SKIPTO - @COUNT}">
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
                    <xsl:when test="@MORE != 0">
                        <a href="F{@FORUMID}?skip={@SKIPTO + @COUNT}">
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
                    	<a href="F{@FORUMID}?skip={(floor(@TOTALTHREADS div @COUNT) * @COUNT)}">
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
    
    <xsl:template match="FORUMTHREADS" mode="library_pagination_pagelist" priority="1">
        <!--ceil by floor() + 1-->
        <xsl:param name="totalPages" select="floor(@TOTALTHREADS div @COUNT) + 1"/>
        <xsl:param name="counter" select="1" />
        <xsl:param name="currentPage" select="floor(@SKIPTO div @COUNT) + 1" />
        
        <xsl:if test="($totalPages > 1) and ($counter > ($currentPage - 6) ) and ($counter &lt; ($currentPage + 6) )">
            <li>
                <xsl:if test="$currentPage = $counter">
                    <xsl:attribute name="class">current</xsl:attribute>
                </xsl:if>
                <a href="F{@FORUMID}?skip={@COUNT * ($counter - 1)}">
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


  <xsl:template match="POST-LIST" mode="library_pagination_post-list" priority="1">
        <ul class="pagination">
            <li class="previous">
                <xsl:choose>
                    <xsl:when test="@SKIPTO > 0">
                        <a href="MP{USER/USERID}?skip={@SKIPTO - 25}">
                            <span class="arrow">
                                <xsl:text disable-output-escaping="yes"><![CDATA[&laquo;]]></xsl:text>
                            </span>
                            <xsl:text>Newer</xsl:text>
                        </a>
                    </xsl:when>
                    <xsl:otherwise>
                        <span>
                            <span class="arrow">
                                <xsl:text disable-output-escaping="yes"><![CDATA[&laquo;]]></xsl:text>
                            </span>
                            <xsl:text>Newer</xsl:text>
                        </span>
                    </xsl:otherwise>
                </xsl:choose>
            </li>
            <li class="next">
                <xsl:choose>
                    <xsl:when test="@MORE != 0">
                        <a href="MP{USER/USERID}?skip={@SKIPTO + 25}">
                            <xsl:text>Older</xsl:text>
                            <span class="arrow">
                                <xsl:text disable-output-escaping="yes"><![CDATA[&raquo;]]></xsl:text>
                            </span>
                        </a>
                    </xsl:when>
                    <xsl:otherwise>
                        <span>
                            <xsl:text>Older</xsl:text>
                            <span class="arrow">
                                <xsl:text disable-output-escaping="yes"><![CDATA[&raquo;]]></xsl:text>
                            </span>
                        </span>
                    </xsl:otherwise>
                </xsl:choose>
            </li>
        </ul>
    </xsl:template>
</xsl:stylesheet>