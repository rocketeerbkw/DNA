<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0" 
                xmlns:msxsl="urn:schemas-microsoft-com:xslt" 
                xmlns:local="#local-functions" 
                xmlns:s="urn:schemas-microsoft-com:xml-data" 
                xmlns:dt="urn:schemas-microsoft-com:datatypes">

<xsl:template name="MOREPOSTS_TITLE">
	<title><xsl:value-of select="$m_pagetitlestart"/><xsl:value-of select="$m_postingsby"/><xsl:apply-templates select="POSTS" mode="ResearcherName"/></title>
</xsl:template>

<xsl:template name="MOREPOSTS_SUBJECT">
	<xsl:call-template name="SUBJECTHEADER">
		<xsl:with-param name="text"><xsl:value-of select="$m_moreposts_head"/></xsl:with-param>
	</xsl:call-template>
</xsl:template>

<xsl:template name="MOREPOSTS_BAR">
	<xsl:call-template name="nuskin-homelinkbar">
		<xsl:with-param name="bardata">
			<table width="100%" cellspacing="0" cellpadding="0" border="0">
				<tr>
					<td width="14" rowspan="4"><img src="{$imagesource}t.gif" width="14" height="1" alt="" /></td>
					<td width="100%"><img src="{$imagesource}t.gif" width="611" height="30" alt="" /></td>
					<td width="14" rowspan="4"><img src="{$imagesource}t.gif" width="14" height="1" alt="" /></td>
				</tr>
				<tr>
					<td>
						<font xsl:use-attribute-sets="subheaderfont" class="postxt"><b><xsl:value-of select="$m_postingsby"/><xsl:apply-templates select="POSTS" mode="ResearcherName"/></b></font>
					</td>
				</tr>
				<tr><td><img src="{$imagesource}t.gif" width="1" height="5" alt="" /></td></tr>
				<tr><td><img src="{$imagesource}t.gif" width="1" height="8" alt="" /></td></tr>
			</table>
		</xsl:with-param>
	</xsl:call-template>
</xsl:template>

<xsl:template name="MOREPOSTS_MAINBODY">
	<xsl:call-template name="RECENT-POSTS-CONTENT" />
</xsl:template>

</xsl:stylesheet>
