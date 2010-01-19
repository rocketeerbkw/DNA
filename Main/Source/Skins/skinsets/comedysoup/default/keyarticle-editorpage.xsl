<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
	<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
<xsl:import href="../../../base/base-articlepage.xsl"/>

<xsl:template name="KEYARTICLE-EDITOR_HEADER">
<xsl:apply-templates mode="header" select=".">
<xsl:with-param name="title"><xsl:value-of select="$m_pagetitlestart"/>Named Articles</xsl:with-param>
</xsl:apply-templates>
</xsl:template>

	<xsl:template name="KEYARTICLE-EDITOR_SUBJECT">
		<xsl:call-template name="SUBJECTHEADER">
			<xsl:with-param name="text">Named Articles</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template name="KEYARTICLE-EDITOR_MAINBODY">
	
		<xsl:apply-templates select="KEYARTICLEFORM"/>
		<br/>
		<xsl:apply-templates select="KEYARTICLELIST"/>
	</xsl:template>
	<xsl:template match="KEYARTICLEFORM">
		<xsl:apply-templates select="ERROR"/>
		<xsl:apply-templates select="SUCCESS"/>
Add a new named article
<form method="POST" action="{$root}NamedArticles">
Article Name <input type="text" name="name" value="{NAME}"/>
			<br/>
h2g2 ID <input type="text" name="h2g2id" value="{H2G2ID}"/> Allow articles from another site <input type="checkbox" name="allowothersites" value="1"/>
			<br/>
Date active <input type="text" name="date" value="{DATE}"/>
			<font size="1">(leave blank to start immediately)</font>
			<br/>
			<input type="submit" name="setarticle" value="Set Article"/>
		</form>
		<br/>
Note: Article names can only contain letters, numbers and the '-' sign.
</xsl:template>
	<xsl:template match="KEYARTICLEFORM/ERROR">
		<font color="red">
			<b>Error: <xsl:value-of select="."/>
			</b>
		</font>
		<br/>
	</xsl:template>
	<xsl:template match="KEYARTICLEFORM/SUCCESS">
The key article has been successfully created.<br/>
	</xsl:template>
	<xsl:template match="KEYARTICLELIST">
		<form method="post" action="{$root}NamedArticles">
These are the current named articles for your site:<br/>
			<xsl:apply-templates select="ARTICLE"/>
			<input type="submit" name="remove" value="Remove checked articles"/>
		</form>
	</xsl:template>
	<xsl:template match="KEYARTICLELIST/ARTICLE">
		<input type="checkbox" name="removename" value="{NAME}"/>
		<a href="{$root}{NAME}">
			<xsl:value-of select="NAME"/>
		</a> (<a href="{$root}TypedArticle?aedit=new&amp;type=1&amp;h2g2id={H2G2ID}">edit</a>)<br/>
	</xsl:template>

</xsl:stylesheet>