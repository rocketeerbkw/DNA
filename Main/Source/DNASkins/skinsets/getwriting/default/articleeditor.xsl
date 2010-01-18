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
		
	<xsl:template name="ARTICLEEDITOR_MAINBODY">
	<!-- DEBUG -->
	<xsl:call-template name="TRACE">
	<xsl:with-param name="message">ARTICLEEDITOR_MAINBODY</xsl:with-param>
	<xsl:with-param name="pagename">articleeditor.xsl</xsl:with-param>
	</xsl:call-template>
	
	
	<!-- DEBUG -->
		<xsl:apply-templates select="/H2G2/ARTICLE/GUIDE[descendant::FLASH!='']/FLASH"/>
		<xsl:if test="/H2G2/ARTICLE/EXTRAINFO/TYPE/@ID = '53'">
		<xsl:apply-templates select="/H2G2/ARTICLE/EXTRAINFO/DESCRIPTION[descendant::TEXTONLY!='']/TEXTONLY" mode="textonly_link"/>
		</xsl:if>
		
		<!-- start of table -->
		<xsl:element name="table" use-attribute-sets="html.table.container">
		<tr>
		<xsl:element name="td" use-attribute-sets="column.1">
		<!-- this is the article -->
		
		<xsl:apply-templates select="/H2G2/ARTICLE/GUIDE[child::BANNER!='']/BANNER"/>
		
		<div>
		<xsl:choose>
		<xsl:when test="$current_article_type=1 and /H2G2/ARTICLE/ARTICLEINFO/PAGEAUTHOR/EDITOR">
		<xsl:attribute name="class">PageContent</xsl:attribute>
		</xsl:when>
		<xsl:when test="$current_article_type=53">
		<xsl:attribute name="class">PageContent1</xsl:attribute>
		</xsl:when>
		<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
		
		<xsl:choose>
		<xsl:when test="/H2G2/ARTICLE/ARTICLEINFO/PREPROCESSED=1">
		<xsl:apply-templates select="/H2G2/ARTICLE/GUIDE/BODY/*[not(self::BR)]"/>
		</xsl:when>
		<xsl:otherwise>
		<xsl:apply-templates select="/H2G2/ARTICLE/GUIDE/BODY"/>
		</xsl:otherwise>
		</xsl:choose>
		
		</div>
			
		<!-- help navigation -->	
		<xsl:if test="/H2G2/ARTICLE/ARTICLEINFO/STATUS/@TYPE=9">

		<!-- <div class="helpbox">
		<div class="heading1">
		<xsl:element name="{$text.base}" use-attribute-sets="text.base">Other Help Topics:</xsl:element>
		</div>
		<table width="390" border="0" cellspacing="0" cellpadding="3">
			<tr>
			<td valign="top"><xsl:element name="{$text.medium}" use-attribute-sets="text.medium"><a href="{$root}aboutgetwriting" id="tabbodyarrowon">about GW</a></xsl:element></td>
			<td valign="top"><xsl:element name="{$text.medium}" use-attribute-sets="text.medium"><a href="{$root}aboutmyspace" id="tabbodyarrowon">about my space</a></xsl:element></td>
			<td valign="top"><xsl:element name="{$text.medium}" use-attribute-sets="text.medium"><a href="{$root}aboutreadandreview" id="tabbodyarrowon">about read &amp; review</a></xsl:element></td>
			</tr>
			<tr>
			<td valign="top"><xsl:element name="{$text.medium}" use-attribute-sets="text.medium"><a href="{$root}aboutwrite" id="tabbodyarrowon">about write</a></xsl:element></td>
			<td valign="top"><xsl:element name="{$text.medium}" use-attribute-sets="text.medium"><a href="{$root}aboutlearn" id="tabbodyarrowon">about learn</a></xsl:element></td>
			<td valign="top"><xsl:element name="{$text.medium}" use-attribute-sets="text.medium"><a href="{$root}abouttalk" id="tabbodyarrowon">about talk</a></xsl:element></td>
			</tr>
			<tr>
			<td valign="top"><xsl:element name="{$text.medium}" use-attribute-sets="text.medium"><a href="{$root}aboutgroups" id="tabbodyarrowon">about groups</a></xsl:element></td>
			<td valign="top"><xsl:element name="{$text.medium}" use-attribute-sets="text.medium"><a href="{$root}aboutsafety">about safety</a></xsl:element></td>
			<td valign="top"><xsl:element name="{$text.medium}" use-attribute-sets="text.medium"><a href="{$root}otherquestions" id="tabbodyarrowon">other questions</a></xsl:element></td>
			</tr>
		</table>
		</div>
		 -->
		</xsl:if>
		
		<xsl:if test="$article_type_group='minicourse'">
		<div class="PageContent">
		<a name="part1" id="part1"></a>
		<xsl:apply-templates select="/H2G2/ARTICLE/GUIDE[descendant::PART1!='']/PART1"/>
		
		<a name="part2" id="part2"></a>		
		<xsl:apply-templates select="/H2G2/ARTICLE/GUIDE[descendant::PART2!='']/PART2"/>
		
		<a name="part3" id="part3"></a>	
		<xsl:apply-templates select="/H2G2/ARTICLE/GUIDE[descendant::PART3!='']/PART3"/>
		
		<a name="part4" id="part4"></a>	
		<xsl:apply-templates select="/H2G2/ARTICLE/GUIDE[descendant::PART4!='']/PART4"/>
		</div>	
		</xsl:if>
		
		<!-- this is the article forum -->
		<xsl:if test="not(/H2G2/ARTICLE/GUIDE/BODY/MYPINBOARD or /H2G2/ARTICLE/GUIDE/BODY/NOFORUM)">
		<div class="PageContent"><xsl:apply-templates select="ARTICLEFORUM" mode="c_article"/></div>
		</xsl:if>
				
		<xsl:apply-templates select="/H2G2/ARTICLE/GUIDE/SUBPROMO1"/>
		
		</xsl:element>
		<xsl:if test="not(/H2G2/PARAMS/PARAM[NAME= 's_print']/VALUE = 1)">
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
		
		
		<xsl:if test="$current_article_type=53 or $current_article_type=56">
		<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
			<div class="rightnavboxheaderhint">HINTS AND TIPS</div>
			<div class="rightnavbox">
			<xsl:copy-of select="$page.thecraft.tips" />
			</div>
		</xsl:element>
		</xsl:if>
		
		<xsl:if test="$current_article_type=65">
		<div class="rightnavboxheaderhint">
		<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
		TOOLS &amp; QUIZZES TIPS</xsl:element></div>
		
		<div class="rightnavbox">
		<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
		<xsl:copy-of select="$index.toolsquizzes.tips" />
		</xsl:element>
		</div>		
		</xsl:if>
		
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
		</xsl:if>
		</tr>
		</xsl:element>
		<!-- end of table -->	
	
	</xsl:template>
	
	
</xsl:stylesheet>
