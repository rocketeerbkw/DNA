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
	<xsl:template name="REVIEW_MAINBODY">
	
	<!-- DEBUG -->
	<xsl:call-template name="TRACE">
	<xsl:with-param name="message">REVIEW_MAINBODY test variable = <xsl:value-of select="$current_article_type" /></xsl:with-param>
	<xsl:with-param name="pagename">reviewfrontpage.xsl</xsl:with-param>
	</xsl:call-template>
	<!-- DEBUG -->
	
	<!-- EDIT -->
	<xsl:if test="$test_IsEditor">
	<p>
	<table width="100%" border="0" cellspacing="0" cellpadding="0" class="generic-n">
	<tr>
	<td class="generic-n-2">
	<img src="{$imagesource}icons/beige/icon_edit.gif" alt="" width="20" height="20" border="0" /><xsl:text>  </xsl:text><xsl:element name="{$text.base}" use-attribute-sets="text.base">
	<xsl:copy-of select="$arrow.right" /> <a href="{$root}TypedArticle?aedit=new&amp;h2g2id={ARTICLE/ARTICLEINFO/H2G2ID}" xsl:use-attribute-sets="mARTICLE_r_editbutton"><xsl:copy-of select="$m_editentrylinktext"/></a>
	</xsl:element>
	</td>
	</tr>
	</table>
	</p>
	</xsl:if>

	<!-- PAGE TITLE -->
	<div class="generic-u">
	
	<table width="590" border="0" cellspacing="0" cellpadding="0"><tr>
	<td><strong><xsl:element name="{$text.medheading}" use-attribute-sets="text.medheading"><xsl:value-of select="ARTICLE/SUBJECT" /><!-- &nbsp;<xsl:copy-of select="$collective.orange" /> --></xsl:element></strong></td>
	<td align="right">
	<div class="rssImage">
	<xsl:element name="A">
	<xsl:attribute name="HREF"><xsl:value-of select="$root" />xml/reviews?s_xml=rss</xsl:attribute>
	<img src="{$graphics}icons/logo_rss.gif" alt="RSS"  border="0"/>	
	</xsl:element>
	<xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall"><a href="http://www.bbc.co.uk/dna/collective/A5319380">What is RSS?</a></xsl:element>
</div>
</td></tr></table>
</div>

	<!-- CONTENT -->
	<div class="pageindent"><xsl:apply-templates select="ARTICLE/GUIDE/BODY/MAIN-SECTIONS/EDITORIAL/ROW"/></div>

	<!-- EDIT -->
	<xsl:if test="$test_IsEditor">
	<p>
	<table width="100%" border="0" cellspacing="0" cellpadding="0" class="generic-n">
	<tr>
	<td class="generic-n-2">
	<img src="{$imagesource}icons/beige/icon_edit.gif" alt="" width="20" height="20" border="0" /><xsl:text>  </xsl:text><xsl:element name="{$text.base}" use-attribute-sets="text.base">
	<xsl:copy-of select="$arrow.right" /> <a href="{$root}TypedArticle?aedit=new&amp;h2g2id={ARTICLE/ARTICLEINFO/H2G2ID}" xsl:use-attribute-sets="mARTICLE_r_editbutton"><xsl:copy-of select="$m_editentrylinktext"/></a>
	</xsl:element>
	</td>
	</tr>
	</table>
	</p>
	</xsl:if>

	</xsl:template>
	
</xsl:stylesheet>
