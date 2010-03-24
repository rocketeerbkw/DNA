<?xml version="1.0" encoding="iso-8859-1"?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<!-- dynamic lists -->
	<xsl:template match="DYNAMIC-LISTS/LIST" mode="xhtml">
		<xsl:param name="listlength"/>
		
		<!--[FIXME: what is this for?]
		<xsl:variable name="listname">
			<xsl:value-of select="@NAME" />
		</xsl:variable>
		
		<xsl:variable name="listlength">
			<xsl:choose>
				<xsl:when test="@LENGTH &gt; 0">
					<xsl:value-of select="@LENGTH" />
				</xsl:when>
				<xsl:otherwise>
				100
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		-->

		<xsl:choose>
			<xsl:when test="not(ITEM-LIST/ITEM)">
				<p>
					There are no entries at present.
				</p>
			</xsl:when>
			<xsl:otherwise>
				<ul>
					<xsl:apply-templates select="ITEM-LIST/ITEM[position() &lt;= $listlength]" mode="xhtml"/>
				</ul>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="ITEM-LIST/ITEM" mode="xhtml">
		<li>
			<a href="{$root}A{@ITEMID}"><xsl:value-of select="TITLE" /></a>

			<!--[FIXME: is this needed?]
			<xsl:apply-templates select="ARTICLE-ITEM/EXTRAINFO/EXTRAINFO/AUTHORUSERID"/>
			<xsl:apply-templates select="ARTICLE-ITEM/EXTRAINFO/EXTRAINFO/DATECREATED"/>
			<xsl:apply-templates select="ARTICLE-ITEM/EXTRAINFO/EXTRAINFO/AUTODESCRIPTION/text()" />
			-->
		</li>
	</xsl:template>
</xsl:stylesheet>
