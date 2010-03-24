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
			Style a comment OR rating
		</doc:purpose>
		<doc:context>
			The comment/rating we're styling.
		</doc:context>
		<doc:notes>
			param $element The element type the comment/rating details should be wrapped in (default is div or li)
			returns An li or div (or other element type - can be passed in as a param) containing all information about this comment/rating.
		</doc:notes>
		<doc:author>
			Laura Porter
		</doc:author>
	</doc:documentation>
	
	<xsl:output indent="yes" omit-xml-declaration="yes" method="xhtml" version="1.0" encoding="UTF-8"/>
	
	<xsl:include href="createdUpdated.xsl"/>
	<xsl:include href="user.xsl"/>
	
	<xsl:variable name="forumUri" select="(/commentForum/parentUri | /ratingForum/parentUri)[1]"/>
	
	<xsl:template match="comment | rating">
		<xsl:param name="element" select="if (ancestor::commentsList) then 'li' else 
											if (ancestor::ratingsList) then 'li' else 'div'"/>
		<xsl:variable name="number" as="xs:double">
			<xsl:number/>
		</xsl:variable>
		<xsl:variable name="startIndex" select="if (ancestor::commentsList) then ancestor::commentsList/startIndex else ancestor::ratingsList/startIndex"/>
		<xsl:element name="{$element}">
			<xsl:attribute name="class" select="concat('dna-', lower-case(local-name()), 
													if (count(preceding-sibling::comment|preceding-sibling::rating) = 0) then ' first' else '',
													if (count(preceding-sibling::comment|preceding-sibling::rating) mod 2 = 1) then ' stripe' else '',
													if (user/editor = 'true') then ' editor' else '')"/>
			<xsl:attribute name="id" select="id"/>
			<div class="dna-{local-name()}Detail">
				<p class="dna-{local-name()}Number">
					<xsl:value-of select="if (local-name() = 'comment') then 'Comment #' else 'Review #'"/>
					<xsl:value-of select="$number + $startIndex"/>
					<span class="permalink">
						<a href="{$forumUri}#{id}">permalink</a>
					</span>
				</p>
				<xsl:apply-templates select="user"/>
				<xsl:apply-templates select="created"/>
			</div>
			<xsl:if test="rating">
				<div class="dna-ratingValue">
					<span><xsl:value-of select="rating"/></span>
				</div>
			</xsl:if>
			<div class="dna-{local-name()} text">
				<xsl:choose>
					<xsl:when test="poststyle = 'plaintext'">
						<p>
							<xsl:analyze-string select="text" regex="&#xA;">
								<xsl:matching-substring>
									<br/>
								</xsl:matching-substring>
								<xsl:non-matching-substring>
									<xsl:value-of select="."/>
								</xsl:non-matching-substring>
							</xsl:analyze-string>
						</p>
					</xsl:when>
					<xsl:otherwise>
						<xsl:copy-of select="text/node()"/>
					</xsl:otherwise>
				</xsl:choose>
			</div>
			<a class="dna-complaintLink" href="{complaintUri}" target="_blank">Complain about this comment</a>
		</xsl:element>
	</xsl:template>

</xsl:stylesheet>
