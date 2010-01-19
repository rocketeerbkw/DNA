<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0" 
                xmlns:msxsl="urn:schemas-microsoft-com:xslt" 
                xmlns:local="#local-functions" 
                xmlns:s="urn:schemas-microsoft-com:xml-data" 
                xmlns:dt="urn:schemas-microsoft-com:datatypes">

<xsl:template name="INDEX_TITLE">
	<title><xsl:value-of select="$m_pagetitlestart"/><xsl:value-of select="$m_aplhaindex_title"/></title>
</xsl:template>

<xsl:template name="INDEX_BAR">
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
						<font xsl:use-attribute-sets="subheaderfont" class="postxt"><b><xsl:value-of select="$m_aplhaindex_for"/></b><xsl:value-of select="INDEX/@LETTER"/></font>
					</td>
				</tr>
				<tr><td><img src="{$imagesource}t.gif" width="1" height="5" alt="" /></td></tr>
				<tr><td><img src="{$imagesource}t.gif" width="1" height="8" alt="" /></td></tr>
			</table>
		</xsl:with-param>
	</xsl:call-template>
</xsl:template>

<xsl:template name="INDEX_MAINBODY">
	<br /><img src="{$imagesource}t.gif" width="10" height="1" alt="" />
	<font xsl:use-attribute-sets="subheaderfont"><b><xsl:value-of select="$m_aplhaindex_head"/></b></font><br />
	<img src="{$imagesource}t.gif" width="1" height="18" alt="" /><br clear="all" />
	<img src="{$imagesource}t.gif" width="5" height="1" alt="" />
	<xsl:call-template name="alphaindex">
		<xsl:with-param name="alphaimagesrc" select="concat($imagesource, 'search/')"/>
		<xsl:with-param name="imagedisplay">yes</xsl:with-param>
		<xsl:with-param name="firstimage">other</xsl:with-param>
	</xsl:call-template>
	<br clear="all" />
	<img src="{$imagesource}t.gif" width="1" height="4" alt="" /><br clear="all" />
	<img src="{$imagesource}t.gif" width="10" height="1" alt="" /><img src="{$imagesource}search/other.gif" width="12" height="17" alt="other" border="0" /><font xsl:use-attribute-sets="mainfont"><xsl:value-of select="$m_aplhaindex_notletter"/></font><br /><br />

	<table border="0" cellspacing="0" cellpadding="1">
		<form method="get" action="{$root}Index" name="">
		<input type="hidden" name="let"><xsl:attribute name="value"><xsl:value-of select="INDEX/@LETTER"/></xsl:attribute></input>
<!--
			<tr>
				<td rowspan="5"><img src="{$imagesource}t.gif" width="10" height="1" alt="" /></td>
				<td valign="top"><xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text></td>
				<td valign="top"><font xsl:use-attribute-sets="subheaderfont"><b><xsl:value-of select="$m_show"/>:</b></font></td>
			</tr>
			<tr>
				<td valign="top">	<input type="checkbox" name="official"><xsl:if test="INDEX/@APPROVED"><xsl:attribute name="checked">1</xsl:attribute></xsl:if></input></td>
				<td><b><font xsl:use-attribute-sets="mainfont"><xsl:value-of select="$m_editedentries"/></font></b></td>
			</tr>
			<tr>
				<td valign="top">	<input type="checkbox" name="submitted"><xsl:if test="INDEX/@SUBMITTED"><xsl:attribute name="checked">1</xsl:attribute></xsl:if></input></td>
				<td><font xsl:use-attribute-sets="mainfont"><xsl:value-of select="$m_awaitingappr"/></font></td>
			</tr>
			<tr>
				<td valign="top">	<input type="checkbox" name="user"><xsl:if test="INDEX/@UNAPPROVED"><xsl:attribute name="checked">1</xsl:attribute></xsl:if></input></td>
				<td><i><font xsl:use-attribute-sets="mainfont"><xsl:value-of select="$m_guideentries"/></font></i></td>
			</tr>
			<tr>
				<td valign="top"><xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text></td>
				<td><input type="submit" value="{$m_refresh}" name="submit" /></td>
			</tr>
-->
			<tr>
				<td valign="top">	<input type="checkbox" name="official"><xsl:if test="INDEX/@APPROVED"><xsl:attribute name="checked">1</xsl:attribute></xsl:if></input>
				<b><font xsl:use-attribute-sets="mainfont"><xsl:value-of select="$m_editedentries"/></font></b></td>
				<td valign="top">	<input type="checkbox" name="submitted"><xsl:if test="INDEX/@SUBMITTED"><xsl:attribute name="checked">1</xsl:attribute></xsl:if></input>
				<font xsl:use-attribute-sets="mainfont"><xsl:value-of select="$m_awaitingappr"/></font></td>
				<td valign="top">	<input type="checkbox" name="user"><xsl:if test="INDEX/@UNAPPROVED"><xsl:attribute name="checked">1</xsl:attribute></xsl:if></input>
				<i><font xsl:use-attribute-sets="mainfont"><xsl:value-of select="$m_guideentries"/></font></i></td>
				<td valign="top"><xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text><input type="submit" value="{$m_refresh}" name="submit" /></td>
			</tr>
		</form>
	</table>

	<xsl:apply-templates select="INDEX" />
	<br /><br />
</xsl:template>

<xsl:template name="INDEX_SIDEBAR">
</xsl:template>

<xsl:template match="INDEX">
	<table width="100%" cellspacing="0" cellpadding="3" border="0">
		<tr>
			<td>
				<table width="100%" cellspacing="1" cellpadding="0" border="0">
					<tr>
						<td width="8"><img src="{$imagesource}t.gif" width="8" height="1" alt="" /></td>
						<td width="88"><img src="{$imagesource}t.gif" width="88" height="1" alt="" /></td>
						<td width="100%"><img src="{$imagesource}t.gif" width="521" height="1" alt="" /></td>
					</tr>
					<tr>
						<td><xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text></td>
						<td colspan="2">
							<font xsl:use-attribute-sets="smallfont" color="#666666">
							<b>
								<xsl:apply-templates select="@SKIP" mode="index">
								<xsl:with-param name="bar"><font color="#ffffff"><xsl:value-of select="$skipdivider"/></font></xsl:with-param>
								<xsl:with-param name="lessthan"/>
								<xsl:with-param name="greaterthan"/>
								</xsl:apply-templates>
							</b>
							</font>
						</td>
					</tr>
					<tr>
						<td colspan="3" background="{$imagesource}dotted_line_inv.jpg"><img src="{$imagesource}pixel_black.gif" width="10" height="9" alt="" border="0" /></td>
					</tr>
					<xsl:apply-templates select="INDEXENTRY"/>
					<tr>
						<td colspan="3" background="{$imagesource}dotted_line_inv.jpg"><img src="{$imagesource}pixel_black.gif" width="10" height="9" alt="" border="0" /></td>
					</tr>
					<tr>
						<td><xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text></td>
						<td colspan="2">
							<font xsl:use-attribute-sets="smallfont" color="#666666">
							<b>
								<xsl:apply-templates select="@SKIP" mode="index">
								<xsl:with-param name="bar"><font color="#ffffff"><xsl:value-of select="$skipdivider"/></font></xsl:with-param>
								<xsl:with-param name="lessthan"/>
								<xsl:with-param name="greaterthan"/>
								</xsl:apply-templates>
							</b>
							</font>
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
</xsl:template>

<xsl:template match="INDEXENTRY">
	<tr>
		<td><xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text></td>
		<td>
			<font xsl:use-attribute-sets="mainfont">
				<xsl:apply-templates select="H2G2ID"/>
			</font>
		</td>
		<td>
			<font xsl:use-attribute-sets="mainfont">
				<a class="norm">
					<xsl:attribute name="HREF"><xsl:value-of select="$root"/>A<xsl:value-of select="H2G2ID"/></xsl:attribute><xsl:value-of select="SUBJECT"/>
				</a>
			</font>
		</td>
	</tr>
</xsl:template>

<xsl:template match="INDEXENTRY[STATUS='APPROVED']">
	<tr>
		<td><xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text></td>
		<td>
			<font xsl:use-attribute-sets="mainfont">
				<xsl:apply-templates select="H2G2ID"/>
			</font>
		</td>
		<td>
			<font xsl:use-attribute-sets="mainfont">
				<a class="norm">
					<xsl:attribute name="HREF"><xsl:value-of select="$root"/>A<xsl:value-of select="H2G2ID"/></xsl:attribute><b><xsl:value-of select="SUBJECT"/></b>
				</a>
			</font>	
		</td>
	</tr>
</xsl:template>

<xsl:template match="INDEXENTRY[STATUS='SUBMITTED']">
	<tr>
		<td><xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text></td>
		<td>
			<font xsl:use-attribute-sets="mainfont">
				<xsl:apply-templates select="H2G2ID"/>
			</font>
		</td>
		<td>
			<font xsl:use-attribute-sets="mainfont">
				<a class="norm">
					<xsl:attribute name="HREF"><xsl:value-of select="$root"/>A<xsl:value-of select="H2G2ID"/></xsl:attribute><xsl:value-of select="SUBJECT"/>
				</a>
			</font>
		</td>
	</tr>
</xsl:template>

<xsl:template match="INDEXENTRY[STATUS='UNAPPROVED']">
	<tr>
		<td><xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text></td>
		<td>
			<font xsl:use-attribute-sets="mainfont">
				<xsl:apply-templates select="H2G2ID"/>
			</font>
		</td>
		<td>
			<font xsl:use-attribute-sets="mainfont">
				<a class="norm">
					<xsl:attribute name="HREF"><xsl:value-of select="$root"/>A<xsl:value-of select="H2G2ID"/></xsl:attribute><i><xsl:value-of select="SUBJECT"/></i>
				</a>
			</font>	
		</td>
	</tr>
</xsl:template>

</xsl:stylesheet>