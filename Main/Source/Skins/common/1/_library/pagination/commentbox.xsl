<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">
	
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
	
	<xsl:template match="FORUMTHREADPOSTS[@FROM and @TO and @SHOW and ((@TO - @FROM) > (@SHOW - 1) )]" mode="library_pagination_commentbox"/>
	
	<!-- s_sssicomponent is set in /dnaimages/components/commentbox/commentbox.sssi -->
	<xsl:template match="FORUMTHREADPOSTS[@FROM and @TO and @SHOW]" mode="library_pagination_commentbox" priority="0.5">
		<xsl:call-template name="paging_prevnext"/>
	</xsl:template>
	
	<xsl:template match="FORUMTHREADPOSTS[@FROM and @TO and @SHOW and ((@TO - @FROM) &lt; @SHOW )]" mode="library_pagination_commentbox" priority="0.75">
		<xsl:call-template name="paging_prevnext"/>
	</xsl:template>
	
	<!-- NB. this template moved from commentforumlist.xsl because it needs to be in no namepsace -->
	<xsl:template match="FORUMTHREADPOSTS[@FROM and @TO and @SHOW][/H2G2/PARAMS/PARAM[NAME = 's_sssicomponent']/VALUE = '1']" mode="library_pagination_commentbox" priority="1">
		<xsl:choose>
			<xsl:when test="contains(@HOSTPAGEURL, '/blogs/') or contains(@HOSTPAGEURL, '/dna')">
				<xsl:call-template name="paging_numbered"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="paging_prevnext"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="paging_prevnext">
		<ul class="pagination">
			<xsl:if test="@FROM &gt; 0">
				<li class="previous">
					<a href="?dnafrom={(@FROM - @SHOW)}&amp;dnato={(@FROM - 1)}#comments">
						<xsl:text>Previous</xsl:text>
					</a>
				</li>
			</xsl:if>
			
			<xsl:if test="@FORUMPOSTCOUNT &gt; @SHOW">
				<li class="next">
					<a>
						<xsl:attribute name="href">
							<xsl:value-of select="concat('?dnafrom=', (@TO + 1), '&amp;dnato=')"/>
							<xsl:choose>
								<xsl:when test="(@TO + @SHOW + 1) &lt; @FORUMPOSTCOUNT">
									<xsl:value-of select="((@TO + 1) + @SHOW)"/>            
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="@FORUMPOSTCOUNT"/>            
								</xsl:otherwise>
							</xsl:choose>
							<xsl:text>#comments</xsl:text>
						</xsl:attribute>
						<xsl:text>Next</xsl:text>
					</a>
				</li>
			</xsl:if>
		</ul>
	</xsl:template>
	
	<xsl:template name="paging_numbered">
		<ul class="pagination">
			<li class="previous">
				<xsl:choose>
					<xsl:when test="(@FROM > 0) and ((@TO div (@TO - @FROM)) - 1) > 0">
						<a href="?page={floor(@TO div (@TO - @FROM)) - 1}#comments">
							<xsl:text>Previous</xsl:text>
						</a>
					</xsl:when>
					<xsl:otherwise>
						<span>Previous</span>
					</xsl:otherwise>
				</xsl:choose>
			</li>
			
			<xsl:apply-templates select="self::node()[@TO > 0]" mode="library_pagination_pagelist" />
			<li class="next">
				<xsl:choose>
					<xsl:when test="(@TO > 0) and (((@TO - @FROM) + @FROM)+1) &lt; @FORUMPOSTCOUNT">
						
						<a href="?page={floor(@TO div (@TO - @FROM)) + 1}#comments">
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
	
	<xsl:template match="FORUMTHREADPOSTS[@TO > 0]" mode="library_pagination_pagelist">
		<xsl:param name="amount" select="(@TO - @FROM) + 1" />
		<xsl:param name="total" select="floor(@FORUMPOSTCOUNT div $amount)" />
		<xsl:param name="counter" select="1" />
		
		<xsl:param name="current" select="floor(@FROM div $total) + 1" />
		
		<xsl:if test="$total > 1">
			
			<li>
				<xsl:if test="$current = $counter">
					<xsl:attribute name="class">current</xsl:attribute>
				</xsl:if>
				<a href="?page={$counter}#comments">
					<xsl:value-of select="$counter"/>
				</a>
			</li>
			
			<xsl:if test="$counter &lt; $total">
				<xsl:apply-templates select="." mode="library_pagination_pagelist">
					<xsl:with-param name="counter" select="$counter + 1" />
					<xsl:with-param name="amount" select="$amount" />
					<xsl:with-param name="total" select="$total" />
				</xsl:apply-templates>
			</xsl:if>
			
		</xsl:if>
	</xsl:template>
	
</xsl:stylesheet>