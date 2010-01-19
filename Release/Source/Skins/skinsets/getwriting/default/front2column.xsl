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
	

	
	<xsl:template name="FRONT2COLUMN_MAINBODY">
	<!-- DEBUG -->
	<xsl:call-template name="TRACE">
	<xsl:with-param name="message"></xsl:with-param>
	<xsl:with-param name="pagename">front2column.xsl</xsl:with-param>
	</xsl:call-template>
	<!-- DEBUG -->
		
		<!-- start of table -->
		<xsl:element name="table" use-attribute-sets="html.table.container">
		<tr>
		<xsl:element name="td" use-attribute-sets="column.1">

		<xsl:apply-templates select="/H2G2/ARTICLE/GUIDE[descendant::BANNER!='']/BANNER"/>
	
		<xsl:choose>
		<xsl:when test="/H2G2/ARTICLE/ARTICLEINFO/PREPROCESSED=1">
		<xsl:apply-templates select="/H2G2/ARTICLE/GUIDE/BODY/*[not(self::BR)]"/>
		</xsl:when>
		<xsl:otherwise>
		<xsl:apply-templates select="/H2G2/ARTICLE/GUIDE/BODY"/>
		</xsl:otherwise>
		</xsl:choose>
		
		<xsl:if test="$current_article_type=14">
		<div class="PageContent">
		<!-- groups search -->
		<img src="{$graphics}/titles/groups/t_findagroup.gif" alt="Find a group" width="392" height="30" border="0"/>
			
		<!-- 	
		<div>
		<xsl:call-template name="c_search_dna">
		<xsl:with-param name="searchfor" select="forum" />
		<xsl:with-param name="type" select="1001" />
		</xsl:call-template>
		</div> -->
		
		<div class="ActionBox">
		
		<table>
		<tr>
		<td>
		<xsl:copy-of select="$icon.browse" />
		</td>
		<td>
		<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
		<strong>BROWSE GROUPS</strong><br/>
		click on a letter to see all groups listed alphabetically.
		</xsl:element>
		</td>
		</tr>
		</table>

		


		<div>
		<xsl:call-template name="alphaindex">
		 <xsl:with-param name="showtype">&amp;user=on</xsl:with-param>
		  <xsl:with-param name="type">&amp;type=1001</xsl:with-param>
		</xsl:call-template>
		</div>
		
		</div>
		</div>
		</xsl:if>
	
		<xsl:apply-templates select="/H2G2/ARTICLE/GUIDE/SUBPROMO1"/>
	
		
		</xsl:element>
		<xsl:element name="td" use-attribute-sets="column.2">
		
		<div>
		<xsl:attribute name="class">
		<xsl:if test="descendant::NAVPROMO/@TYPE='NavPromo'">NavPromoOuter</xsl:if>
		</xsl:attribute>
		<div>
		<xsl:attribute name="class">
		<xsl:value-of select="descendant::NAVPROMO/@TYPE" />
		</xsl:attribute>
		<xsl:choose>
		<xsl:when test="/H2G2/ARTICLE/ARTICLEINFO/PREPROCESSED=1">
		<xsl:apply-templates select="/H2G2/ARTICLE/GUIDE/SUBPROMO2/*[not(self::BR)]"/> 
		</xsl:when>
		<xsl:otherwise>
		<xsl:apply-templates select="/H2G2/ARTICLE/GUIDE/SUBPROMO2"/>
		</xsl:otherwise>
		</xsl:choose>
		</div>
		</div>
				
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
