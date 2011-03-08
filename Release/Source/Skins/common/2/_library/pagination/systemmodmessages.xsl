<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">
		
		<doc:documentation>
				<doc:purpose>
						pagination
				</doc:purpose>
				<doc:context>
						Applied by skinsets/vanilla/boards_v2/pages/smm.xsl
				</doc:context>
				<doc:notes>
					System moderation mailbox pagination						 
				</doc:notes>
		</doc:documentation>
		
		<xsl:template match="SYSTEMMESSAGEMAILBOX" mode="library_pagination_systemmessages">
			<xsl:if test="@TOTALCOUNT > @SHOW">
				<ul class="pagination">
					<li class="previous dna-button">
						<xsl:choose>
							<xsl:when test="@SKIPTO > 0">
								<a href="SMM?{/H2G2/VIEWING-USER/USER/USERID}&#38;skip={@SKIPTO - 25}">
									<span class="arrow">
										<xsl:text disable-output-escaping="yes"><![CDATA[&laquo;]]></xsl:text>
									</span>
									<xsl:text>Newer</xsl:text>
								</a>
							</xsl:when>
						</xsl:choose>
					</li>
					
					<xsl:variable name="total">
						<xsl:value-of select="@SKIPTO + @SHOW" />
					</xsl:variable>
					
					<xsl:choose>
						<xsl:when test="@TOTALCOUNT > $total">
							<li class="next dna-button">
								<a href="SMM?{/H2G2/VIEWING-USER/USER/USERID}&#38;skip={@SKIPTO + 25}">
									<xsl:text>Older</xsl:text>
									<span class="arrow">
										<xsl:text disable-output-escaping="yes"><![CDATA[&raquo;]]></xsl:text>
									</span>
								</a>
							</li>
						</xsl:when>
					</xsl:choose> 
				</ul>
			</xsl:if>
		</xsl:template>
		
</xsl:stylesheet>