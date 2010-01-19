<?xml version="1.0" encoding="ISO-8859-1"?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" xmlns:image="http://purl.org/rss/1.0/modules/image/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:dc="http://purl.org/dc/elements/1.1/" exclude-result-prefixes="msxsl local s dt">
	<xsl:import href="../../../base/rss1/RSSOutput.xsl"/>
	<!--xsl:import href="../atom/AtomOutput.xsl"/-->
	<xsl:include href="scifi-sitevars.xsl"/>
	<!-- 
	
	-->
	<xsl:variable name="syn_article">
		<SYNDICATION>
			<xsl:choose>
				<xsl:when test="/H2G2/ARTICLE/EXTRAINFO/TYPE/@ID=5 and key('feedtype', 'lastwinners')">
					<xsl:for-each select="/H2G2/SITECONFIG/LASTWEEKWIN/SMALL/LINK">
						<ITEM>
							<xsl:element name="title" namespace="{$thisnamespace}">
								<xsl:call-template name="validChars">
									<xsl:with-param name="string" select="text()"/>
								</xsl:call-template>
							</xsl:element>
							<xsl:element name="link" namespace="{$thisnamespace}">
								<xsl:value-of select="concat($thisserver, $root, @DNAID)"/>
							</xsl:element>
						</ITEM>
					</xsl:for-each>
				</xsl:when>
				<!--xsl:when test="/H2G2/ARTICLE/EXTRAINFO/TYPE/@ID=5 and key('feedtype', '2')">
					<ITEM>
						<xsl:for-each select="/H2G2/ARTICLE/GUIDE/BODY/MAIN-SECTIONS/EDITORIAL/ROW[position() &lt; 3]/EDITORIAL-ITEM/LINK">
							
						</xsl:for-each>
					</ITEM>
				</xsl:when-->
				<xsl:when test="/H2G2/ARTICLE/EXTRAINFO/TYPE/@ID=5">
					<!-- reviews page -->
					<xsl:if test="/H2G2/SITECONFIG/ALBUMWEEK">
						<ITEM>
							<xsl:element name="title" namespace="{$thisnamespace}">
								<xsl:call-template name="validChars">
									<xsl:with-param name="string" select="concat(/H2G2/SITECONFIG/ALBUMWEEK/HEADER, ' - ', /H2G2/SITECONFIG/ALBUMWEEK/LINK)"/>
								</xsl:call-template>
							</xsl:element>
							<xsl:element name="description" namespace="{$thisnamespace}">
								<xsl:call-template name="validChars">
									<xsl:with-param name="string" select="/H2G2/SITECONFIG/ALBUMWEEK/BODY"/>
								</xsl:call-template>
						
							</xsl:element>
							<xsl:element name="link" namespace="{$thisnamespace}">
								<xsl:value-of select="concat($thisserver, $root, /H2G2/SITECONFIG/ALBUMWEEK/LINK/@DNAID)"/>
							</xsl:element>
							<image:item rdf:about="{$graphics}{/H2G2/SITECONFIG/ALBUMWEEK/IMG/@NAME}">
								<dc:title>
									<xsl:value-of select="/H2G2/SITECONFIG/ALBUMWEEK/IMG/@ALT"/>
								</dc:title>
								<image:width>
									<xsl:value-of select="/H2G2/SITECONFIG/ALBUMWEEK/IMG/@WIDTH"/>
								</image:width>
								<image:height>
									<xsl:value-of select="/H2G2/SITECONFIG/ALBUMWEEK/IMG/@HEIGHT"/>
								</image:height>
       						 </image:item>
						</ITEM>
					</xsl:if>
					<xsl:if test="/H2G2/SITECONFIG/CINEMAWEEK">
						<ITEM>
							<xsl:element name="title" namespace="{$thisnamespace}">
								<xsl:call-template name="validChars">
									<xsl:with-param name="string" select="concat(/H2G2/SITECONFIG/CINEMAWEEK/HEADER, ' - ', /H2G2/SITECONFIG/CINEMAWEEK/LINK)"/>
								</xsl:call-template>
							</xsl:element>
							<xsl:element name="description" namespace="{$thisnamespace}">
								<xsl:call-template name="validChars">
									<xsl:with-param name="string" select="/H2G2/SITECONFIG/CINEMAWEEK/BODY"/>
								</xsl:call-template>
								
							</xsl:element>
							<xsl:element name="link" namespace="{$thisnamespace}">
								<xsl:value-of select="concat($thisserver, $root, /H2G2/SITECONFIG/CINEMAWEEK/LINK/@DNAID)"/>
							</xsl:element>
							<image:item rdf:about="{$graphics}{/H2G2/SITECONFIG/CINEMAWEEK/IMG/@NAME}">
								<dc:title>
									<xsl:value-of select="/H2G2/SITECONFIG/CINEMAWEEK/IMG/@ALT"/>
								</dc:title>
								<image:width>
									<xsl:value-of select="/H2G2/SITECONFIG/CINEMAWEEK/IMG/@WIDTH"/>
								</image:width>
								<image:height>
									<xsl:value-of select="/H2G2/SITECONFIG/CINEMAWEEK/IMG/@HEIGHT"/>
								</image:height>
       						 </image:item>

						</ITEM>
					</xsl:if>
					<xsl:if test="/H2G2/SITECONFIG/MORECULTURE">
						<ITEM>
							<xsl:element name="title" namespace="{$thisnamespace}">
								<xsl:call-template name="validChars">
									<xsl:with-param name="string" select="concat(/H2G2/SITECONFIG/MORECULTURE/HEADER, ' - ',/H2G2/SITECONFIG/MORECULTURE/LINK)"/>
								</xsl:call-template>
							</xsl:element>
							<xsl:element name="description" namespace="{$thisnamespace}">
								<xsl:call-template name="validChars">
									<xsl:with-param name="string" select="/H2G2/SITECONFIG/MORECULTURE/BODY"/>
								</xsl:call-template>
								
							</xsl:element>
							<xsl:element name="link" namespace="{$thisnamespace}">
								<xsl:value-of select="concat($thisserver, $root, /H2G2/SITECONFIG/MORECULTURE/LINK/@DNAID)"/>
							</xsl:element>
							<image:item rdf:about="{$graphics}{/H2G2/SITECONFIG/MORECULTURE/IMG/@NAME}">
								<dc:title>
									<xsl:value-of select="/H2G2/SITECONFIG/MORECULTURE/IMG/@ALT"/>
								</dc:title>
								<image:width>
									<xsl:value-of select="/H2G2/SITECONFIG/MORECULTURE/IMG/@WIDTH"/>
								</image:width>
								<image:height>
									<xsl:value-of select="/H2G2/SITECONFIG/MORECULTURE/IMG/@HEIGHT"/>
								</image:height>
       						 </image:item>
						</ITEM>
					</xsl:if>
				</xsl:when>
				<xsl:when test="/H2G2/ARTICLE/EXTRAINFO/TYPE/@ID=6">
					<xsl:for-each select="/H2G2/ARTICLE/GUIDE/BODY/MAIN-SECTIONS/EDITORIAL/ROW[position() &lt; 3]/EDITORIAL-ITEM/LINK">
						<ITEM>
							<xsl:element name="title" namespace="{$thisnamespace}">
								<xsl:choose>
									<xsl:when test="IMG/text()">
										<xsl:call-template name="validChars">
											<xsl:with-param name="string" select="IMG/text()"/>
										</xsl:call-template>
									</xsl:when>
									<xsl:otherwise>
										<xsl:call-template name="validChars">
											<xsl:with-param name="string" select="text()"/>
										</xsl:call-template>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:element>
							<xsl:choose>
								<xsl:when test="following-sibling::BODY">
									<xsl:element name="description" namespace="{$thisnamespace}">
										<xsl:call-template name="validChars">
											<xsl:with-param name="string" select="following-sibling::BODY"/>
										</xsl:call-template>
									</xsl:element>
								</xsl:when>
							</xsl:choose>
							<xsl:element name="link" namespace="{$thisnamespace}">
								<xsl:choose>
									<xsl:when test="@DNAID">
										<xsl:value-of select="concat($thisserver, $root, @DNAID)"/>
									</xsl:when>
								</xsl:choose>
							</xsl:element>
						</ITEM>
					</xsl:for-each>
						
				</xsl:when>
				<xsl:when test="/H2G2/ARTICLE/EXTRAINFO/TYPE/@ID=4">
					
					<xsl:for-each select="/H2G2/ARTICLE/GUIDE/BODY/MAIN-SECTIONS/EDITORIAL/ROW/EDITORIAL-ITEM[@TYPE='greenorangebox']/SMALL/LINK[contains(@HREF, '.ram')]">
					
						<ITEM>
							<xsl:element name="title" namespace="{$thisnamespace}">
								<xsl:call-template name="validChars">
									<xsl:with-param name="string" select="."/>
								</xsl:call-template>
							</xsl:element>
							<xsl:element name="link" namespace="{$thisnamespace}">
								<xsl:value-of select="@HREF"/>
							
							</xsl:element>
						</ITEM>
					</xsl:for-each>	
				</xsl:when>
				<xsl:when test="/H2G2/ARTICLE/EXTRAINFO/TYPE/@ID=7">
					<xsl:for-each select="/H2G2/ARTICLE/GUIDE/BODY/MAIN-SECTIONS/EDITORIAL/ROW/EDITORIAL-ITEM[not(@TYPE='GREEN')]/LINK[@DNAID]
								|
								/H2G2/ARTICLE/GUIDE/BODY/MAIN-SECTIONS/EDITORIAL/ROW/EDITORIAL-ITEM[not(@TYPE='GREEN')]/BANNER/LINK[@DNAID]">
						<ITEM>
							<xsl:element name="title" namespace="{$thisnamespace}">
								<xsl:choose>
									<xsl:when test="IMG/text()">
										<xsl:call-template name="validChars">
											<xsl:with-param name="string" select="IMG/text()"/>
										</xsl:call-template>
										
									</xsl:when>
									<xsl:otherwise>
										<xsl:call-template name="validChars">
											<xsl:with-param name="string" select="text()"/>
										</xsl:call-template>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:element>
							<xsl:element name="description" namespace="{$thisnamespace}">
								<xsl:call-template name="validChars">
									<xsl:with-param name="string" select="following-sibling::BODY"/>
								</xsl:call-template>
							</xsl:element>
							<xsl:element name="link" namespace="{$thisnamespace}">
								<xsl:choose>
									<xsl:when test="@DNAID">
										<xsl:value-of select="concat($thisserver, $root, @DNAID)"/>
									</xsl:when>
								</xsl:choose>
							</xsl:element>
							<xsl:if test="IMG">
								<image:item rdf:about="{$graphics}{IMG/@NAME}">
									<dc:title>
										<xsl:choose>
											<xsl:when test="IMG/text()">
												<xsl:call-template name="validChars">
													<xsl:with-param name="string" select="IMG/text()"/>
												</xsl:call-template>
												
											</xsl:when>
											<xsl:otherwise>
												<xsl:call-template name="validChars">
													<xsl:with-param name="string" select="text()"/>
												</xsl:call-template>
											</xsl:otherwise>
										</xsl:choose>
									</dc:title>
									<image:width>
										<xsl:value-of select="IMG/@WIDTH"/>
									</image:width>
									<image:height>
										<xsl:value-of select="IMG/@HEIGHT"/>
									</image:height>
	       						 </image:item>
							</xsl:if>
						</ITEM>
					</xsl:for-each>
				</xsl:when>
			</xsl:choose>
		</SYNDICATION>
	</xsl:variable>
	<!-- 
	
	-->

</xsl:stylesheet>
