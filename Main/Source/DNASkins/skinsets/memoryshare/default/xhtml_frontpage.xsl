<?xml version="1.0" encoding="iso-8859-1"?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<xsl:import href="../../../base/base-frontpage.xsl"/>

	<!-- 	template for producing XHTML snippets
		see: XMLOutput.xsl, XHTMLOutput.xsl, pagetype.xsl
	-->
	<xsl:template name="FRONTPAGE_XHTML">
		<!-- DEBUG -->
		<xsl:call-template name="TRACE">
			<xsl:with-param name="message">FRONTPAGE_XHTML</xsl:with-param>
			<xsl:with-param name="pagename">frontpage.xsl</xsl:with-param>
		</xsl:call-template>
		<!-- DEBUG -->
		
		<xsl:choose>
			<!-- Dynamic lists -->
			<xsl:when test="/H2G2/PARAMS/PARAM[NAME='s_xhtml']/VALUE = 'dynamiclist'">
				<xsl:choose>
					<xsl:when test="/H2G2/DYNAMIC-LISTS/LIST[@LISTNAME = /H2G2/PARAMS/PARAM[NAME='s_dlname']/VALUE]">
						<xsl:apply-templates select="/H2G2/DYNAMIC-LISTS/LIST[@LISTNAME = /H2G2/PARAMS/PARAM[NAME='s_dlname']/VALUE]" mode="xhtml">
							<xsl:with-param name="listlength">
								<xsl:choose>
									<xsl:when test="/H2G2/PARAMS/PARAM[NAME='s_len']">
										<xsl:value-of select="/H2G2/PARAMS/PARAM[NAME='s_len']/VALUE"/>
									</xsl:when>
									<xsl:otherwise>10</xsl:otherwise>
								</xsl:choose>
							</xsl:with-param>
						</xsl:apply-templates>
					</xsl:when>
					<xsl:otherwise>
						<p>
							There is no such list
						</p>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
