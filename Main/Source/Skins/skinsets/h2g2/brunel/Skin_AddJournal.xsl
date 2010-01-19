<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0" 
                xmlns:msxsl="urn:schemas-microsoft-com:xslt" 
                xmlns:local="#local-functions" 
                xmlns:s="urn:schemas-microsoft-com:xml-data" 
                xmlns:dt="urn:schemas-microsoft-com:datatypes">

<!-- IL start -->
<xsl:attribute-set name="asiPOSTJOURNALFORM_Subject">
	<xsl:attribute name="size">39</xsl:attribute>
	<xsl:attribute name="style">width:300px;</xsl:attribute>
</xsl:attribute-set>
<xsl:attribute-set name="astaPOSTJOURNALFORM_Body">
	<xsl:attribute name="cols">72</xsl:attribute>
	<xsl:attribute name="rows">25</xsl:attribute>
	<xsl:attribute name="wrap">soft</xsl:attribute>
	<xsl:attribute name="style">width:600;</xsl:attribute>
</xsl:attribute-set>
<xsl:attribute-set name="asiPOSTJOURNALFORM_PreviewBtn">
	<xsl:attribute name="type">submit</xsl:attribute>
	<xsl:attribute name="value">Preview</xsl:attribute>
	<!--<xsl:attribute name="src"><xsl:value-of select="$imagesource"/>preview_inv.gif</xsl:attribute>
	<xsl:attribute name="alt">Preview</xsl:attribute>
	<xsl:attribute name="border">0</xsl:attribute>-->
</xsl:attribute-set>
<xsl:attribute-set name="asiPOSTJOURNALFORM_StoreBtn">
	<xsl:attribute name="type">submit</xsl:attribute>
	<xsl:attribute name="name">post</xsl:attribute>
	<xsl:attribute name="value">Publish</xsl:attribute>
	<!--<xsl:attribute name="src"><xsl:value-of select="$imagesource"/>publish_inv.gif</xsl:attribute>
	<xsl:attribute name="alt">Publish</xsl:attribute>
	<xsl:attribute name="border">0</xsl:attribute>-->
</xsl:attribute-set>
<!-- IL end -->

<xsl:template name="ADDJOURNAL_TITLE">
	<title><xsl:value-of select="$m_pagetitlestart"/><xsl:value-of select="$m_addjournal"/></title>
	<xsl:call-template name="EnhEditorJS" />
</xsl:template>

<xsl:template name="ADDJOURNAL_SUBJECT">
	<xsl:call-template name="SUBJECTHEADER">
		<xsl:with-param name="text"><xsl:value-of select="$m_addjournal"/></xsl:with-param>
	</xsl:call-template>
</xsl:template>

<xsl:template name="ADDJOURNAL_MAINBODY">
	<td width="100%" bgcolor="#000000" class="postable">
		<table width="100%" cellspacing="0" cellpadding="8" border="0">
			<tr>
				<td>
					<font xsl:use-attribute-sets="textfont">
						<xsl:apply-templates select="POSTJOURNALUNREG"/>
						<xsl:apply-templates select="POSTJOURNALFORM" />
						<br /><br /><br /><br />
					</font>
				</td>
			</tr>
		</table>
		<xsl:if test="POSTJOURNALFORM">
			<script type="text/javascript" language="JavaScript">
				<xsl:comment>
					var domPath = document.theForm.body;
				//</xsl:comment>
			</script>
		</xsl:if>
	</td>
</xsl:template>

<xsl:template match="POSTJOURNALUNREG">
	<xsl:choose>
		<xsl:when test="@RESTRICTED = 1"><xsl:call-template name="m_cantpostrestricted"/></xsl:when>
		<xsl:when test="@REGISTERED = 1"><xsl:value-of select="$m_noagreetermsconds"/></xsl:when>
		<xsl:otherwise><xsl:value-of select="$m_nojournalunreg"/></xsl:otherwise>
	</xsl:choose>
	<br/><br/>
</xsl:template>

<xsl:template match="POSTJOURNALFORM">
	<table width="100%" cellpadding="0" cellspacing="6" border="0">
		<xsl:choose>
			<xsl:when test="WARNING">
				<tr>
					<td colspan="2">
						<font xsl:use-attribute-sets="mainfont" class="postxt">
							<b><xsl:value-of select="$m_warningcolon"/></b>
							<xsl:value-of select="WARNING"/><br />
						</font>
					</td>
				</tr>
				<tr>
					<td colspan="2" background="{$imagesource}dotted_line_ssml_grey.jpg" style="background-repeat:repeat-x"><img src="{$imagesource}t.gif" width="599" height="1" alt="" /></td>
				</tr>
			</xsl:when>
      <xsl:when test="@PROFANITYTRIGGERED=1">
          <p style="color:#ffffff; font-weight:bold; padding-left:20px; background-image: url(http://www.bbc.co.uk/dnaimages/boards/images/warning.gif); background-repeat: no-repeat; background-position-y: 3px;">This message has been blocked as it contains a word which other users may find offensive. Please edit your message and post it again.</p>
      </xsl:when>
			<xsl:when test="PREVIEWBODY">
				<tr>
					<td colspan="2"><font xsl:use-attribute-sets="mainfont" class="postxt"><b><xsl:value-of select="$m_previewurjournal"/></b></font></td>
				</tr>
				<tr>
					<td><font xsl:use-attribute-sets="smallfont" class="postxt"><xsl:value-of select="$m_journallooklike"/></font></td>
					<td align="right"><font xsl:use-attribute-sets="smallfont" class="postxt"><nobr><a href="#reply" class="pos"><b><xsl:value-of select="$m_jumptoreply"/></b></a></nobr></font></td>
				</tr>
				<tr>
					<td colspan="2" background="{$imagesource}dotted_line_ssml_grey.jpg" style="background-repeat:repeat-x"><img src="{$imagesource}t.gif" width="599" height="1" alt="" /></td>
				</tr>				
				<tr>
					<td colspan="2">
						<font xsl:use-attribute-sets="mainfont" class="postxt">
							<b><xsl:value-of select="SUBJECT"/></b> (<xsl:value-of select="$m_soon"/>)<br />
						</font>
						<font xsl:use-attribute-sets="textfont">
							<xsl:apply-templates select="PREVIEWBODY" /><br />
						</font>
					</td>
				</tr>
				<tr>
					<td colspan="2" background="{$imagesource}dotted_line_ssml_grey.jpg" style="background-repeat:repeat-x"><img src="{$imagesource}t.gif" width="599" height="1" alt="" /></td>
				</tr>
			</xsl:when>
			<xsl:otherwise>
				<tr>
					<td colspan="2">
						<font xsl:use-attribute-sets="mainfont" class="postxt">
<!-- IL start -->
							<xsl:copy-of select="$m_journalintroUI"/><br />
<!-- IL end -->
						</font>
					</td>
				</tr>
				<tr>
					<td colspan="2" background="{$imagesource}dotted_line_ssml_grey.jpg" style="background-repeat:repeat-x"><img src="{$imagesource}t.gif" width="599" height="1" alt="" /></td>
				</tr>
			</xsl:otherwise>
		</xsl:choose>
	</table>
	<table width="611" cellpadding="5" cellspacing="1" border="0">
<!-- IL start -->
		<form xsl:use-attribute-sets="asfPOSTJOURNALFORM">
<!-- IL end -->
			<tr>
				<td>
					<font xsl:use-attribute-sets="mainfont" class="postxt">
						<xsl:call-template name="postpremoderationmessage"/>
						<table width="580" cellpadding="0" cellspacing="0" border="0">
							<tr>
								<td width="320"><img src="{$imagesource}t.gif" width="320" height="1" alt="" /></td>
								<td width="10" rowspan="2"><img src="{$imagesource}t.gif" width="10" height="1" alt="" /></td>
								<td width="250"><img src="{$imagesource}t.gif" width="250" height="1" alt="" /></td>
							</tr>
							<tr>
								<td colspan="3"><font xsl:use-attribute-sets="mainfont" class="postxt"><b><a name="reply" /><xsl:value-of select="$m_fsubject"/></b></font><br clear="all" /><img src="{$imagesource}t.gif" width="612" height="4" alt="" /></td>
							</tr>
							<tr>
								<td colspan="2">
<!-- IL start -->
									<xsl:apply-templates select="." mode="Subject"/>
<!-- IL end -->
								</td>
								<td><font xsl:use-attribute-sets="smallfont" class="postxt"><b><xsl:call-template name="m_enheditorhelp" /></b></font></td>
							</tr>
						</table>
					</font>
				</td>
			</tr>
			<tr>
				<td><font xsl:use-attribute-sets="mainfont" class="postxt"><b><xsl:value-of select="$m_fjournalentry"/></b></font><br clear="all" /><img src="{$imagesource}t.gif" width="1" height="4" alt="" /><br clear="all" />
<!-- IL start -->
					<xsl:apply-templates select="." mode="Body"/>
<!-- IL end -->
					<img src="{$imagesource}t.gif" width="1" height="2" alt="" /><br />
					<font xsl:use-attribute-sets="smallfont" class="postxt"><xsl:call-template name="m_enhemoticonhelp" /></font>
				</td>
			</tr>
			<tr>
				<td>
					<table width="599" cellpadding="0" cellspacing="0" border="0">
						<tr valign="top">
							<td width="99"><!-- IL start --><input xsl:use-attribute-sets="asiPOSTJOURNALFORM_PreviewBtn"/><!-- IL end --><br clear="all" />
								<img src="{$imagesource}t.gif" width="1" height="5" alt="" /><br clear="all" />
								<!-- IL start --><input xsl:use-attribute-sets="asiPOSTJOURNALFORM_StoreBtn"/><!-- IL end --><br clear="all" />
								<img src="{$imagesource}t.gif" width="1" height="5" alt="" />
							</td>
							<td width="500" align="right">
								<script type="text/javascript" language="JavaScript">
									<xsl:comment>
										drawEmoticons(checkType());
									//</xsl:comment>
								</script>
								<noscript>
									<font xsl:use-attribute-sets="mainfont" class="postxt"><xsl:value-of select="$m_enherrornojs"/></font>
								</noscript>
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</form>
	</table>
</xsl:template>

</xsl:stylesheet>
