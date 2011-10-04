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
		
		<xsl:template match="USERREPUTATIONLIST" mode="library_pagination_userreputationlist">
			<xsl:variable name="querymodclass">
        <xsl:value-of select="concat('&amp;s_modclassid=', @MODCLASSID)"/>
			</xsl:variable>
      <xsl:variable name="querydays">
        <xsl:value-of select="concat('&amp;s_days=', @DAYS)"/>
      </xsl:variable>
      <xsl:variable name="querymodstatus">
        <xsl:value-of select="concat('&amp;s_modstatus=', @MODSTATUS)"/>
      </xsl:variable>
			
			<xsl:variable name="querystring">
				<xsl:value-of select="concat($querymodclass,$querydays, $querymodstatus)"/>
			</xsl:variable>
			
			<xsl:variable name="itemcount" select="count(USERS/USERREPUTATION)" />
			
			<div class="dna-fl">
				<xsl:text>Event </xsl:text>
				<xsl:choose>
					<xsl:when test="@STARTINDEX > 0">
						<xsl:value-of select="@STARTINDEX + 1" />
					</xsl:when>
					<xsl:otherwise>1</xsl:otherwise>
				</xsl:choose>
				<xsl:text> - </xsl:text>
				<xsl:value-of select="@STARTINDEX + $itemcount" />
				<xsl:text> of </xsl:text>
				<xsl:value-of select="@TOTALITEMS" />
			</div>
			
			<xsl:if test="@TOTALITEMS > $itemcount">
			<div class="dna-fr">
				<ul class="pagination">
					<li class="first dna-button">
						<xsl:choose>
							<xsl:when test="@STARTINDEX > 0">
								<a href="{$root}/userreputationreport?s_startindex=0{$querystring}">
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
								<a href="{$root}/userreputationreport?s_startindex={@STARTINDEX - $itemcount}{$querystring}">
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
								<a href="{$root}/userreputationreport?s_startindex={(@STARTINDEX + $itemcount)}{$querystring}">
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
									<a href="{$root}/userreputationreport?s_startindex={(floor(@TOTALITEMS div $itemcount)-1) * $itemcount}{$querystring}">
										<xsl:text> Last</xsl:text>
									</a>
								</xsl:when>
								<xsl:otherwise>
									<a href="{$root}/userreputationreport?s_startindex={(floor(@TOTALITEMS div $itemcount) * $itemcount)}{$querystring}">
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
			</div>
			</xsl:if>
		</xsl:template>
			
		<xsl:template match="USERREPUTATIONLIST" mode="library_pagination_pagelist">
			<xsl:param name="querystring" />
			<xsl:param name="itemcount" select="count(USERS/USERREPUTATION)" />
			<xsl:param name="totalPages">
				<!--ceil by floor() + 1-->
				<xsl:choose>
					<xsl:when test="@TOTALITEMS mod  @ITEMSPERPAGE =0">
						<xsl:value-of select="floor(@TOTALITEMS div @ITEMSPERPAGE)"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="floor(@TOTALITEMS div @ITEMSPERPAGE) + 1"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:param>
			<xsl:param name="counter" select="1" />
			<xsl:param name="currentPage" select="floor(@STARTINDEX div @ITEMSPERPAGE) +1" />
			
			<xsl:if test="($totalPages > 1) and ($counter > ($currentPage - 10) ) and ($counter &lt; ($currentPage + 10) )">
				<li>
					<xsl:if test="$currentPage = $counter">
						<xsl:attribute name="class">current</xsl:attribute>
					</xsl:if>
					<a href="{$root}/userreputationreport?s_startindex={$itemcount * ($counter - 1)}{$querystring}">
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

		
</xsl:stylesheet>