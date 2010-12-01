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
		
		<xsl:template match="SITEEVENTLIST" mode="library_pagination_forumthreadposts">
      <xsl:variable name="queryeventtype">
        <xsl:if test="SELECTEDTYPES/TYPEID">
          <xsl:apply-templates select="SELECTEDTYPES/TYPEID" mode="library_pagination_querystring"/>
        </xsl:if>
      </xsl:variable>
      <xsl:variable name="querystart">
        <xsl:if test="STARTDATE">
          <xsl:value-of select="concat('&amp;s_startdate=', STARTDATE/DATE/@YEAR,'-',STARTDATE/DATE/@MONTH,'-',STARTDATE/DATE/@DAY)"/>
        </xsl:if>
      </xsl:variable>
      <xsl:variable name="queryend">
        <xsl:if test="ENDDATE">
          <xsl:value-of select="concat('&amp;s_enddate=', ENDDATE/DATE/@YEAR,'-',ENDDATE/DATE/@MONTH,'-',ENDDATE/DATE/@DAY)"/>
        </xsl:if>
      </xsl:variable>
      <xsl:variable name="querysite">
        <xsl:if test="/H2G2/PARAMS/PARAM[NAME = 's_type']/VALUE != ''">
          <xsl:value-of select="concat('&amp;s_type=', /H2G2/PARAMS/PARAM[NAME = 's_type']/VALUE)"/>
        </xsl:if>
      </xsl:variable>

      <xsl:variable name="querystring">
          <xsl:value-of select="concat($queryeventtype,$querystart, $queryend, $querysite)"/>
      </xsl:variable>

      <xsl:variable name="itemcount" select="count(SITEEVENTS/SITEEVENT)" />

      <div>
      <xsl:text>Event </xsl:text>
      <xsl:choose>
        <xsl:when test="@STARTINDEX > 0">
          <xsl:value-of select="@STARTINDEX" />
        </xsl:when>
        <xsl:otherwise>
          1
        </xsl:otherwise>
      </xsl:choose>
      <xsl:text> - </xsl:text>
      <xsl:value-of select="@STARTINDEX + $itemcount" />
      <xsl:text> of </xsl:text>
      <xsl:value-of select="@TOTALITEMS" />
      </div>
			<xsl:if test="@TOTALITEMS > $itemcount">
					<ul class="pagination">
						<li class="first dna-button">
								<xsl:choose>
											<xsl:when test="@STARTINDEX > 0">
													<a href="{$root}/hostdashboardactivity?s_startindex=0{$querystring}">
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
							<li class="previous dna-button">
									<xsl:choose>
											<xsl:when test="@STARTINDEX > 0">
													<a href="{$root}/hostdashboardactivity?s_startindex={@STARTINDEX - $itemcount}{$querystring}">
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
            <xsl:apply-templates select="." mode="library_pagination_pagelist">
              <xsl:with-param name="querystring" select="$querystring"/>
            </xsl:apply-templates>
                                   >
							<li class="next dna-button">
									<xsl:choose>
											<xsl:when test="@TOTALITEMS > @STARTINDEX + $itemcount">
													<a href="{$root}/hostdashboardactivity?s_startindex={(@STARTINDEX + $itemcount)}{$querystring}">
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
							 <li class="last dna-button">
								<xsl:choose>
											<xsl:when test="@TOTALITEMS > @STARTINDEX + $itemcount">
												<xsl:choose>
													<xsl:when test="@TOTALITEMS mod $itemcount =0">
														<a href="{$root}/hostdashboardactivity?s_startindex={(floor(@TOTALITEMS div $itemcount)-1) * $itemcount}{$querystring}">
															<xsl:text> Last</xsl:text>
														</a>
													</xsl:when>
													<xsl:otherwise>
														<a href="{$root}/hostdashboardactivity?s_startindex={(floor(@TOTALITEMS div $itemcount) * $itemcount)}{$querystring}">
															<xsl:text> Last</xsl:text>
														</a>
													</xsl:otherwise>
												</xsl:choose>
											</xsl:when>
											<xsl:otherwise>
													<span>
															<xsl:text> Last</xsl:text>
													</span>
											</xsl:otherwise>
									</xsl:choose>
							</li>
					</ul>
			</xsl:if>
		</xsl:template>
		
		<xsl:template match="SITEEVENTLIST" mode="library_pagination_pagelist">
      <xsl:param name="querystring" />
      <xsl:param name="itemcount" select="count(SITEEVENTS/SITEEVENT)" />
      <xsl:param name="totalPages">
        <!--ceil by floor() + 1-->
        <xsl:choose>
          <xsl:when test="@TOTALITEMS mod $itemcount =0">
            <xsl:value-of select="floor(@TOTALITEMS div $itemcount)"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="floor(@TOTALITEMS div $itemcount) + 1"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:param>

      <xsl:param name="counter" select="1" />
      <xsl:param name="currentPage" select="floor(@STARTINDEX div $itemcount) + 1" />

      

      <xsl:if test="($totalPages > 1) and ($counter > ($currentPage - 5) ) and ($counter &lt; ($currentPage + 5) )">
						<li>
								<xsl:if test="$currentPage = $counter">
										<xsl:attribute name="class">current</xsl:attribute>
								</xsl:if>
								<a href="{$root}/hostdashboardactivity?s_startindex={$itemcount * ($counter - 1)}{$querystring}">
										<xsl:value-of select="$counter"/>
								</a>
						</li>
				</xsl:if>
				
				<xsl:if test="$counter &lt; $totalPages">
						<xsl:apply-templates select="." mode="library_pagination_pagelist">
              <xsl:with-param name="querystring" select="$querystring" />
								<xsl:with-param name="counter" select="$counter + 1" />
								<xsl:with-param name="totalPages" select="$totalPages" />
								<xsl:with-param name="currentPage" select="$currentPage" />
						</xsl:apply-templates>
				</xsl:if>
					 
		</xsl:template>

  <xsl:template match="TYPEID" mode="library_pagination_querystring">
    
    <xsl:value-of select="concat('&amp;s_eventtype=', .)"/>
  </xsl:template>
		
</xsl:stylesheet>