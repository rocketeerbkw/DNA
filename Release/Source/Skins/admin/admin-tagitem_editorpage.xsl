<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<xsl:template name="TAGITEM_EDITOR">
		<xsl:apply-templates select="TAGITEM-PAGE/SITE-TAGLIMITS"/>
	</xsl:template>
	<xsl:template match="TAGITEM-PAGE/SITE-TAGLIMITS">
	<h2>Site Tagging Limits</h2>
	<font xsl:use-attribute-sets="mainfont" size="2">
	<table width="100%" border="1" rules="rows" cellpadding="2">
		<xsl:for-each select="SITELIMIT">
			<tr>
				<td align="left">
					Node Type '<xsl:value-of select="@NODENAME"/>' (<xsl:value-of select="@NODETYPE"/>)
				</td>
				<td align="right">
					<xsl:choose>
						<xsl:when test="@ARTICLETYPE = 0 and @LIMIT = -1">
							No limits defined
						</xsl:when>
						<xsl:otherwise>
							Type '<xsl:value-of select="@ARTICLETYPE"/>'
							 Article limit = <xsl:value-of select="@LIMIT"/>
						</xsl:otherwise>
					</xsl:choose>
				</td>
				<td align="left">
					<a href="tagitem?sitelimits=show&amp;action=setlimit&amp;nodetype={@NODETYPE}&amp;itemtype={@ARTICLETYPE}&amp;limit=-1"><b>Delete</b></a>
				</td>
				<br/>
			</tr>
		</xsl:for-each>
	</table><br/>
	</font>
	<form name="setlimit" method="get" action="{$root}tagitem">
		<input type="hidden" name="sitelimits" value="show"/>
		<input type="hidden" name="action" value="setlimit"/>
		Node Type:<textarea name="nodetype" cols="4" rows="1"></textarea>
		ArticleType:<textarea name="itemtype" cols="4" rows="1"></textarea>
		Limit:<textarea name="limit" cols="4" rows="1"></textarea> - <input type="submit" value="Set Limit"/>
	</form>
		<br/>
		<form name="setlimit" method="get" action="{$root}tagitem">
		<input type="hidden" name="sitelimits" value="show"/>
		<input type="hidden" name="action" value="setlimit"/>
		<input type="hidden" name="thread" value="1"/>
		Node Type:<textarea name="nodetype" cols="4" rows="1"></textarea>
		Limit:<textarea name="limit" cols="4" rows="1"></textarea> - <input type="submit" value="Set Thread Limit"/>
	</form>
	<form name="setlimit" method="get" action="{$root}tagitem">
		<input type="hidden" name="sitelimits" value="show"/>
		<input type="hidden" name="action" value="setlimit"/>
		<input type="hidden" name="user" value="1"/>
		Node Type:<textarea name="nodetype" cols="4" rows="1"></textarea>
		Limit:<textarea name="limit" cols="4" rows="1"></textarea> - <input type="submit" value="Set User Limit"/>
	</form>
	<br/>
</xsl:template>

</xsl:stylesheet>