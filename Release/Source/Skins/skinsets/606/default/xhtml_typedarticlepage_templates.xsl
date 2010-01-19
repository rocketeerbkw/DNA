
<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
	<!ENTITY space "<xsl:text xmlns:xsl='http://www.w3.org/1999/XSL/Transform'> </xsl:text>">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<xsl:import href="../../../base/base-frontpage.xsl"/>

	<!--
	<xsl:include href="typedarticlepage_templates_shared.xsl"/>
	-->
	
	<!-- 	template for producing XHTML snippets
		see: XMLOutput.xsl, XHTMLOutput.xsl, pagetype.xsl
	-->
	<xsl:template name="TYPED-ARTICLE_XHTML">
		<!-- DEBUG -->
		<xsl:call-template name="TRACE">
			<xsl:with-param name="message">TYPED-ARTICLE_XHTML</xsl:with-param>
			<xsl:with-param name="pagename">xhtml_typedarticlepage_templates.xsl</xsl:with-param>
		</xsl:call-template>
		<!-- DEBUG -->
		
		<xsl:variable name="new_article_type">
			<xsl:choose>	
				<xsl:when test="$current_article_type != 1">
					<xsl:value-of select="$current_article_type"/>
				</xsl:when>
				<xsl:when test="/H2G2/PARAMS/PARAM[NAME='s_type']/VALUE">
					<xsl:value-of select="/H2G2/PARAMS/PARAM[NAME='s_type']/VALUE"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$default_article_type"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<div id="ajaxContent">
			<xsl:call-template name="SPORT_VARIATIONS"/>
		</div>
	</xsl:template>
	
</xsl:stylesheet>
