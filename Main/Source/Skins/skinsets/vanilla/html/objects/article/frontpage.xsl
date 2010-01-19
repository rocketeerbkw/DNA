<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns="http://www.w3.org/1999/xhtml" 
	version="1.0" 
	xmlns:doc="http://www.bbc.co.uk/dna/documentation"  
	exclude-result-prefixes="doc">
    
    <doc:documentation>
        <doc:purpose>
            HTML for a DNA frontpage article
        </doc:purpose>
        <doc:context>
            Applied by logic layer (common/logic/objects/article.xsl)
        </doc:context>
        <doc:notes>
            
        </doc:notes>
    </doc:documentation>
    
    
	<xsl:template match="ARTICLE" mode="object_article_frontpage">
		<xsl:apply-templates select="FRONTPAGE" mode="object_article_frontpage"/>
	</xsl:template>
	
	<xsl:template match="FRONTPAGE" mode="object_article_frontpage">
		<xsl:apply-templates select="MAIN-SECTIONS" mode="object_article_frontpage"/>
		<xsl:apply-templates select="CATEGORISATION" mode="object_article_frontpage"/>
	</xsl:template>
	
	<xsl:template match="MAIN-SECTIONS" mode="object_article_frontpage">
		<xsl:apply-templates mode="object_article_frontpage"/>
	</xsl:template>
	
	<xsl:template match="EDITORIAL" mode="object_article_frontpage">
		<div class="editorial">
			<xsl:apply-templates mode="object_article_frontpage"/>
		</div>
	</xsl:template>
	
	<xsl:template match="BANNER" mode="object_article_frontpage">
		<div class="banner">
			<xsl:apply-templates mode="object_article_frontpage"/>
		</div>
	</xsl:template>
	
	<xsl:template match="ROW" mode="object_article_frontpage">
		<div class="row">
			<xsl:apply-templates mode="object_article_frontpage"/>
		</div>
	</xsl:template>
	
	<xsl:template match="LEFTCOL" mode="object_article_frontpage">
		<div class="column left">
			<xsl:apply-templates mode="object_article_frontpage"/>
		</div>
	</xsl:template>
	
	<xsl:template match="RIGHTCOL" mode="object_article_frontpage">
		<div class="column right">
			<xsl:apply-templates mode="object_article_frontpage"/>
		</div>
	</xsl:template>
	
	<xsl:template match="EDITORIAL-ITEM" mode="object_article_frontpage">
		<div class="editorial-item">
			<xsl:call-template name="library_header_h2">
				<xsl:with-param name="text">
					<xsl:value-of select="SUBJECT" />
				</xsl:with-param>
			</xsl:call-template>
			<div class="article text">
				<xsl:apply-templates select="BODY" mode="library_GuideML" />
			</div>
		</div>
	</xsl:template>
	
	<xsl:template match="node()" mode="object_article_frontpage">
		<xsl:apply-templates mode="library_GuideML"/>
	</xsl:template>
	
	<xsl:template match="CATEGORISATION" mode="object_article_frontpage">
		<div id="categories" class="frontpage">
			<xsl:apply-templates mode="object_article_frontpage"/>
		</div>
	</xsl:template>
	
	<xsl:template match="CATBLOCK" mode="object_article_frontpage">
		<ul class="categories">
			<xsl:apply-templates mode="object_article_frontpage"/>
		</ul>
	</xsl:template>
	
	<xsl:template match="CATEGORY" mode="object_article_frontpage">
		<li>
			<a href="{$root}/C{CATID}"><xsl:value-of select="NAME"/></a>
			<xsl:if test="SUBCATEGORY">
				<ul class="subcategory">
					<xsl:apply-templates select="SUBCATEGORY" mode="object_article_frontpage"/>
				</ul>
			</xsl:if>
		</li>
	</xsl:template>
	
	<xsl:template match="SUBCATEGORY" mode="object_article_frontpage">
		<li>
			<a href="{$root}/C{CATID}"><xsl:value-of select="NAME"/></a>
		</li>
	</xsl:template>
    
</xsl:stylesheet>