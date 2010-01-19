<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
	<!ENTITY space "<xsl:text xmlns:xsl='http://www.w3.org/1999/XSL/Transform'> </xsl:text>">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<xsl:import href="../../../base/base-frontpage.xsl"/>
	<!--

	-->
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
									Page - Level  template
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->

	
	<xsl:template name="FRONTPAGE_MAINBODY">
	
    <xsl:apply-templates select="ARTICLE" mode="c_frontpage"/>
		
<!-- <xsl:apply-templates select="ARTICLE" mode="c_frontpage"/><img src="M:\Learning\Get Writing\Development\www\getwriting\furniture\titles\t_gwhome.gif" width="116" height="39" alt="" border="0">
	<xsl:apply-templates select="TOP-FIVES" mode="c_frontpage"/> -->
	
	</xsl:template>
	<!--
	<xsl:template match="ARTICLE" mode="r_frontpage">
	Use: Apply's templates to the root of the editorially-generated content area (GuideML)
	 -->
	<xsl:template match="ARTICLE" mode="r_frontpage">
		<xsl:apply-templates select="FRONTPAGE"/>
	</xsl:template>
	
	
	<xsl:template match="FRONTPAGE">
	
		<!-- start of table -->
		<xsl:element name="table" use-attribute-sets="html.table.container">
		<tr>
		<xsl:element name="td" use-attribute-sets="column.1">
		
		<xsl:apply-templates select="MAIN-SECTIONS/BANNER"/>
			
    	</xsl:element>
		<xsl:element name="td" use-attribute-sets="column.2">
		<div>
		<xsl:attribute name="class">MainPromo</xsl:attribute>
		<xsl:apply-templates select="MAIN-SECTIONS/SUBPROMO2"/>
		</div>
		</xsl:element>
		</tr>
		</xsl:element>
		<!-- end of table -->	
		
		
		<!-- start of table -->
		<xsl:element name="table" use-attribute-sets="html.table.container">
		<tr>
		<xsl:element name="td" use-attribute-sets="column.1a">
				
		<xsl:apply-templates select="MAIN-SECTIONS/BODY"/>
			
		</xsl:element>
		</tr>
		</xsl:element>
		<!-- end of table -->	
			
		
		<!-- start of table -->
		<xsl:element name="table" use-attribute-sets="html.table.container">
		<tr>
		<xsl:element name="td" use-attribute-sets="column.1">
				
		<xsl:apply-templates select="MAIN-SECTIONS/SUBPROMO1" />
				
    	</xsl:element>
		<xsl:element name="td" use-attribute-sets="column.2">
		
		<xsl:apply-templates select="MAIN-SECTIONS/TIPSHEADER"/>
		<xsl:apply-templates select="MAIN-SECTIONS/TIPS"/>
			
		<div class="promoQuote"><xsl:apply-templates select="MAIN-SECTIONS/SUBPROMO3"/></div>
				
		</xsl:element>
		</tr>
		</xsl:element>
		<!-- end of table -->	
	
	
	</xsl:template>
	
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
							TOP-FIVES Object
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<!--
	<xsl:template match="TOP-FIVES" mode="r_frontpage">
	Use: Logical container for area containing the top fives.
	 -->
	<xsl:template match="TOP-FIVES" mode="r_frontpage">
		<xsl:apply-templates select="TOP-FIVE" mode="c_frontpage"/>
	</xsl:template>
	<!--
	<xsl:template match="TOP-FIVE" mode="r_frontpage">
	Use: Presentation of one individual top five
	 -->
	<xsl:template match="TOP-FIVE" mode="r_frontpage">
		<b>
			<xsl:value-of select="TITLE"/>
		</b>
		<br/>
		<xsl:apply-templates select="TOP-FIVE-ARTICLE[position() &lt;=5]|TOP-FIVE-FORUM[position() &lt;=5]" mode="c_frontpage"/>
		<br/>
	</xsl:template>
	<!--
	<xsl:template match="TOP-FIVE-ARTICLE" mode="r_frontpage">
	Use: Presentation of one article link within a top five
	 -->
	<xsl:template match="TOP-FIVE-ARTICLE" mode="r_frontpage">
		<xsl:apply-imports/>
		<br/>
	</xsl:template>
	<!--
	<xsl:template match="TOP-FIVE-FORUM" mode="r_frontpage">
	Use: Presentation of one forum link within a top five
	 -->
	<xsl:template match="TOP-FIVE-FORUM" mode="r_frontpage">
		<xsl:apply-imports/>
		<br/>
	</xsl:template>
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
					Frontpage only GuideML tags
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->

</xsl:stylesheet>
