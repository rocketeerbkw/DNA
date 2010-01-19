<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
									Page - Level  template
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->


	<xsl:template name="FRONT3COLUMN_MAINBODY">
	<!-- DEBUG -->
	<xsl:call-template name="TRACE">
	<xsl:with-param name="message"></xsl:with-param>
	<xsl:with-param name="pagename">front3column.xsl</xsl:with-param>
	</xsl:call-template>
	<!-- DEBUG -->

		<!-- start of table -->
		<xsl:element name="table" use-attribute-sets="html.table.container">
		<tr>
		<xsl:element name="td" use-attribute-sets="column.1">
		
		<xsl:apply-templates select="/H2G2/ARTICLE/GUIDE[descendant::BANNER!='']/BANNER"/>
			
    	</xsl:element>
		<xsl:element name="td" use-attribute-sets="column.2">
		<div>
		<xsl:attribute name="class">
		<xsl:if test="descendant::NAVPROMO/@TYPE">NavPromoOuter</xsl:if>
		</xsl:attribute>
		<div>
		<xsl:attribute name="class">
		<xsl:value-of select="descendant::NAVPROMO/@TYPE" />
		</xsl:attribute>
		<xsl:apply-templates select="/H2G2/ARTICLE/GUIDE/SUBPROMO2"/>
		</div>
		</div>
		</xsl:element>
		</tr>
		</xsl:element>
		<!-- end of table -->	
		
		
		<!-- start of table -->
		<xsl:element name="table" use-attribute-sets="html.table.container">
		<tr>
		<xsl:element name="td" use-attribute-sets="column.1a">
		
		<xsl:choose>
		<xsl:when test="/H2G2/ARTICLE/ARTICLEINFO/PREPROCESSED=1">
		<xsl:apply-templates select="/H2G2/ARTICLE/GUIDE/BODY/*[not(self::BR)]"/>
		</xsl:when>
		<xsl:otherwise>
		<xsl:apply-templates select="/H2G2/ARTICLE/GUIDE/BODY"/>
		</xsl:otherwise>
		</xsl:choose>
	
		</xsl:element>
		</tr>
		</xsl:element>
		<!-- end of table -->	
			
		
		<!-- start of table -->
		<xsl:element name="table" use-attribute-sets="html.table.container">
		<tr>
		<xsl:element name="td" use-attribute-sets="column.1">
		
		<xsl:choose>
		<xsl:when test="/H2G2/ARTICLE/ARTICLEINFO/PREPROCESSED=1">
		<xsl:apply-templates select="/H2G2/ARTICLE/GUIDE/SUBPROMO1/*[not(self::BR)]"/>
		</xsl:when>
		<xsl:otherwise>
		<xsl:apply-templates select="/H2G2/ARTICLE/GUIDE/SUBPROMO1"/>
		</xsl:otherwise>
		</xsl:choose>
		
    	</xsl:element>
		<xsl:element name="td" use-attribute-sets="column.2">
	
		<xsl:choose>
		<xsl:when test="/H2G2/ARTICLE/ARTICLEINFO/PREPROCESSED=1">
		<xsl:apply-templates select="/H2G2/ARTICLE/GUIDE/SUBPROMO3/*[not(self::BR)]"/>
		</xsl:when>
		<xsl:otherwise>
		<xsl:apply-templates select="/H2G2/ARTICLE/GUIDE/SUBPROMO3"/>
		</xsl:otherwise>
		</xsl:choose>

		<xsl:choose>
		<xsl:when test="/H2G2/ARTICLE/ARTICLEINFO/PREPROCESSED=1">
		<xsl:apply-templates select="/H2G2/ARTICLE/GUIDE/SUBPROMO4/*[not(self::BR)]"/>
		</xsl:when>
		<xsl:otherwise>
		<xsl:apply-templates select="/H2G2/ARTICLE/GUIDE/SUBPROMO4"/>
		</xsl:otherwise>
		</xsl:choose>
		
		</xsl:element>
		</tr>
		</xsl:element>
		<!-- end of table -->	

	</xsl:template>
	
</xsl:stylesheet>
