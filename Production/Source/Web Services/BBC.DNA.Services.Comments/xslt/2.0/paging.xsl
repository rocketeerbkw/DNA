<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:dna="BBC.Dna.Api"
	xmlns:doc="http://www.bbc.co.uk/dna/documentation"
	xmlns="http://www.w3.org/1999/xhtml"
	exclude-result-prefixes="xs dna doc"
	xpath-default-namespace="BBC.Dna.Api"
	version="2.0">
	
	<doc:documentation>
		<doc:purpose>
			Generic paging for commentlists, commentforumlists etc
		</doc:purpose>
		<doc:context>
			The node whose paging we're styling. This assumes the context has children named startIndex, totalCount and itemsPerPage.
		</doc:context>
		<doc:notes>
			param $context Pass in a node to style, otherwise this template uses the context it was called against.
			param $pagingOverspillThreshold The threashold at which paging won't show the total list of pages, but will instead show an ellpisis after half of the threshold, followed by the final half. If not required, pass in 0.
			returns A div containing pagecount, and - assuming there is more than one page - a list of other pages.
		</doc:notes>
		<doc:author>
			Laura Porter
		</doc:author>
	</doc:documentation>
	
	<xsl:output indent="yes" omit-xml-declaration="yes" method="xhtml" version="1.0" encoding="UTF-8"/>
	
	<xsl:template name="paging">
		<xsl:param name="context" select="."/>
		<xsl:param name="pagingOverspillThreshold" select="10" as="xs:integer"/>
		<xsl:variable name="totalPages" select="ceiling($context/totalCount div $context/itemsPerPage)" as="xs:double*"/>
		<div class="dna-paging">
			<p>Page <xsl:value-of select="if ($context/startIndex = 0) then '1' else ($context/startIndex div $context/itemsPerPage) + 1"/> of <xsl:value-of select="if ($totalPages = 0) then '1' else $totalPages"/></p>
			<xsl:if test="$totalPages gt 1">
				<ul>
					<li class="first">
						<xsl:choose>
							<xsl:when test="$context/startIndex = 0">
								<span class="disabled">First</span>
							</xsl:when>
							<xsl:otherwise>
								<a href="?startIndex=0&amp;itemsperpage={$context/itemsPerPage}&amp;format=html#dna-comments-top">First</a>
							</xsl:otherwise>
						</xsl:choose>
					</li>
					<li class="previous">
						<xsl:choose>
							<xsl:when test="$context/startIndex = 0">
								<span class="disabled">Previous</span>
							</xsl:when>
							<xsl:otherwise>
								<a href="{concat('?startIndex=', $context/startIndex - $context/itemsPerPage, '&amp;itemsperpage=', $context/itemsPerPage, '&amp;format=html#dna-comments-top')}">Previous</a>
							</xsl:otherwise>
						</xsl:choose>
					</li>
					<xsl:choose>
						<xsl:when test="$totalPages le 10 or $pagingOverspillThreshold = 0">
							<xsl:for-each select="for $i in 1 to xs:integer($totalPages) return $i">
								<li>
									<a href="?startIndex={(. - 1) * $context/itemsPerPage}&amp;itemsPerPage={$context/itemsPerPage}&amp;format=html#dna-comments-top">
										<xsl:value-of select="."/>
									</a>
								</li>
							</xsl:for-each>
						</xsl:when>
						<xsl:otherwise>
							<xsl:for-each select="for $i in 1 to ($pagingOverspillThreshold div 2) return $i">
								<li>
									<a href="?startIndex={(. - 1) * $context/itemsPerPage}&amp;itemsPerPage={$context/itemsPerPage}&amp;format=html#dna-comments-top">
										<xsl:value-of select="."/>
									</a>
								</li>
							</xsl:for-each>
							<li class="missingPages">...</li>
							<xsl:for-each select="for $i in xs:integer($totalPages - ($pagingOverspillThreshold div 2)) to xs:integer($totalPages) return $i">
								<li>
									<a href="?startIndex={(. - 1) * $context/itemsPerPage}&amp;itemsPerPage={$context/itemsPerPage}&amp;format=html#dna-comments-top">
										<xsl:value-of select="."/>
									</a>
								</li>
							</xsl:for-each>
						</xsl:otherwise>
					</xsl:choose>
					<li class="next">
						<xsl:choose>
							<xsl:when test="number($context/startIndex) ge ($context/totalCount - $context/itemsPerPage)">
								<span class="disabled">Next</span>
							</xsl:when>
							<xsl:otherwise>
								<a href="?startIndex={$context/startIndex + $context/itemsPerPage}&amp;itemsPerPage={$context/itemsPerPage}&amp;format=html#dna-comments-top">Next</a>
							</xsl:otherwise>
						</xsl:choose>
					</li>
					<li class="last">
						<xsl:choose>
							<xsl:when test="number($context/startIndex) ge ($context/totalCount - $context/itemsPerPage)">
								<span class="disabled">Last</span>
							</xsl:when>
							<xsl:otherwise>
								<a href="?startIndex={floor($context/totalCount div $context/itemsPerPage) * $context/itemsPerPage}&amp;itemsPerPage={$context/itemsPerPage}&amp;format=html#dna-comments-top">Last</a>
							</xsl:otherwise>
						</xsl:choose>
					</li>
				</ul>
			</xsl:if>
		</div>
	</xsl:template>

</xsl:stylesheet>
