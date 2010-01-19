<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0" 
                xmlns:msxsl="urn:schemas-microsoft-com:xslt" 
                xmlns:local="#local-functions" 
                xmlns:s="urn:schemas-microsoft-com:xml-data" 
                xmlns:dt="urn:schemas-microsoft-com:datatypes">

<xsl:template name="MOREPAGES_TITLE">
	<title>
		<xsl:value-of select="$m_pagetitlestart"/>
		<xsl:choose>
			<xsl:when test="ARTICLES[@WHICHSET=1]"><xsl:value-of select="$m_editedentries"/></xsl:when>
			<xsl:when test="ARTICLES[@WHICHSET=2]"><xsl:value-of select="$m_guideentries"/></xsl:when>
			<xsl:when test="ARTICLES[@WHICHSET=3]"><xsl:value-of select="$m_cancelledentries"/></xsl:when>
		</xsl:choose>
		<xsl:value-of select="$m_by"/><xsl:value-of select="ARTICLES/USER/USERNAME"/>
	</title>
</xsl:template>

<xsl:template name="MOREPAGES_SUBJECT">
	<xsl:call-template name="SUBJECTHEADER">
		<xsl:with-param name="text">
			<xsl:choose>
				<xsl:when test="ARTICLES[@WHICHSET=1]"><xsl:value-of select="$m_editedentries"/></xsl:when>
				<xsl:when test="ARTICLES[@WHICHSET=2]"><xsl:value-of select="$m_guideentries"/></xsl:when>
				<xsl:when test="ARTICLES[@WHICHSET=3]"><xsl:value-of select="$m_cancelledentries"/></xsl:when>
			</xsl:choose>
		</xsl:with-param>
	</xsl:call-template>
</xsl:template>

<xsl:template name="MOREPAGES_BAR">
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
						<font xsl:use-attribute-sets="subheaderfont" class="postxt"><b>
							<xsl:choose>
								<xsl:when test="ARTICLES[@WHICHSET=1]"><xsl:value-of select="$m_editedentries"/></xsl:when>
								<xsl:when test="ARTICLES[@WHICHSET=2]"><xsl:value-of select="$m_guideentries"/></xsl:when>
								<xsl:when test="ARTICLES[@WHICHSET=3]"><xsl:value-of select="$m_cancelledentries"/></xsl:when>
							</xsl:choose>
							<xsl:value-of select="$m_by"/><xsl:value-of select="ARTICLES/USER/USERNAME"/>
						</b></font>
					</td>
				</tr>
				<tr><td><img src="{$imagesource}t.gif" width="1" height="5" alt="" /></td></tr>
				<tr><td><img src="{$imagesource}t.gif" width="1" height="8" alt="" /></td></tr>
			</table>
		</xsl:with-param>
	</xsl:call-template>
</xsl:template>

<xsl:template name="MOREPAGES_MAINBODY">
	<table width="100%" cellspacing="0" cellpadding="6" border="0">
		<tr>
			<td>
				<font xsl:use-attribute-sets="mainfont">
					<table width="100%" cellspacing="0" cellpadding="0" border="0">
						<tr>
							<td><font xsl:use-attribute-sets="smallfont"><b><xsl:value-of select="$m_morepages_id"/></b></font></td>
							<xsl:choose>
								<xsl:when test="$ownerisviewer = 1">
									<td><font xsl:use-attribute-sets="smallfont"><xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text></font></td>
									<td><font xsl:use-attribute-sets="smallfont"><b><xsl:value-of select="$m_morepages_title"/></b></font></td>
								</xsl:when>
								<xsl:otherwise>
									<td colspan="2"><font xsl:use-attribute-sets="smallfont"><b><xsl:value-of select="$m_morepages_title"/></b></font></td>
								</xsl:otherwise>
							</xsl:choose>
							<td></td>
							<td colspan="2"><font xsl:use-attribute-sets="smallfont"><b><xsl:value-of select="$m_morepages_site"/></b></font></td>
							<td><font xsl:use-attribute-sets="smallfont"><b><xsl:value-of select="$m_morepages_status"/></b></font></td>
							<td><font xsl:use-attribute-sets="smallfont"><b><xsl:value-of select="$m_morepages_created"/></b></font></td>
						</tr>
						<tr>
							<td width="70"><img src="{$imagesource}t.gif" width="70" height="10" alt="" /></td>
							<td width="35"><img src="{$imagesource}t.gif" width="35" height="10" alt="" /></td>
							<td width="100%"><img src="{$imagesource}t.gif" width="217" height="10" alt="" /></td>
							<td width="7"><img src="{$imagesource}t.gif" width="7" height="10" alt="" /></td>
							<td width="105"><img src="{$imagesource}t.gif" width="105" height="10" alt="" /></td>
							<td width="7"><img src="{$imagesource}t.gif" width="7" height="10" alt="" /></td>
							<td width="90"><img src="{$imagesource}t.gif" width="90" height="10" alt="" /></td>
							<td width="100"><img src="{$imagesource}t.gif" width="100" height="10" alt="" /></td>
						</tr>
						<xsl:apply-templates select="ARTICLES/ARTICLE-LIST"/>
						<tr>
							<td colspan="8" background="{$imagesource}dotted_line_inv.jpg">
								<img src="{$imagesource}t.gif" width="1" height="9" alt="" />
							</td>
						</tr>
						<tr>
							<td colspan="8">
								<img src="{$imagesource}t.gif" width="1" height="4" alt="" />
							</td>
						</tr>
						<xsl:if test="$ownerisviewer = 1">
							<tr>
								<td colspan="6">
<!-- IL start -->
									<!--xsl:call-template name="ENTRIES-MORE" /-->
<!-- IL end -->
									<img src="{$imagesource}t.gif" width="1" height="1" alt="" />
								</td>
								<td colspan="2" align="right">
									<font xsl:use-attribute-sets="smallfont">
										<nobr><img src="{$imagesource}perspace/edit2.gif" width="8" height="13" alt="{$alt_morepages_edit}" border="0" /><b><xsl:value-of select="$m_morepages_editkey"/></b></nobr>
										<xsl:value-of select="$skipdivider"/>
										<nobr><img src="{$imagesource}perspace/unsubscribe2.gif" width="6" height="6" alt="{$alt_morepages_uncancel}" border="0" /><b><xsl:value-of select="$m_morepages_uncancelkey"/></b></nobr>
									</font>
								</td>
							</tr>
						</xsl:if>
<!-- IL start -->
						<!--xsl:if test="$ownerisviewer != 1">
							<tr>
								<td colspan="7"><xsl:call-template name="ENTRIES-MORE" /></td>
							</tr>
						</xsl:if-->
<!-- IL end -->
						<tr>
							<td colspan="8">
								<img src="{$imagesource}t.gif" width="1" height="15" alt="" />
							</td>
						</tr>
<!-- IL start -->
						<tr>
							<td colspan="8">
								<font xsl:use-attribute-sets="smallfont">
									<b>
										<xsl:apply-templates select="ARTICLES/@USERID" mode="ShowEditedEntries"/> 			
										<xsl:text> | </xsl:text>
										<xsl:apply-templates select="ARTICLES/@USERID" mode="ShowGuideEntries"/>
										<xsl:if test="$test_MayShowCancelledEntries">
											<xsl:text> | </xsl:text>
											<xsl:apply-templates select="ARTICLES/@USERID" mode="ShowCancelledEntries"/>
										</xsl:if>
									</b>
								</font>
							</td>
						</tr>
						<tr>
							<td colspan="8">
								<font xsl:use-attribute-sets="smallfont">
									<b>
										<xsl:if test="$test_NewerArticlesExist">
											<xsl:apply-templates select="ARTICLES/@USERID" mode="NewerEntries"/>
											<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
										</xsl:if>
										<xsl:if test="$test_OlderArticlesExist">
											<xsl:apply-templates select="ARTICLES/@USERID" mode="OlderEntries"/>
										</xsl:if>
									</b>
								</font>
							</td>
						</tr>
						<tr>
							<td colspan="8">
								<font xsl:use-attribute-sets="smallfont">
									<b>
										<xsl:apply-templates select="ARTICLES/@USERID" mode="FromMAToPS"/>
									</b>
								</font>
							</td>
						</tr>
<!-- IL end -->
					</table>
				</font>
			</td>
		</tr>
	</table>
</xsl:template>

<!-- IL start -->
<!--xsl:template name="ENTRIES-MORE">
	<xsl:param name="secondtype">1</xsl:param>
	<xsl:param name="secondblurb"><xsl:value-of select="$m_showeditedentries"/></xsl:param>
	<font xsl:use-attribute-sets="smallfont">
		<xsl:if test="ARTICLES/ARTICLE-LIST[@MORE]">
			<a class="norm">
				<xsl:attribute name="HREF"><xsl:value-of select="$root"/>MA<xsl:value-of select="ARTICLES/@USERID"/>?type=1</xsl:attribute>
				<nobr><b><xsl:value-of select="$m_morepages_showmore"/></b></nobr>
			</a>
			<xsl:value-of select="$skipdivider"/>
		</xsl:if>
		<a class="norm">
			<xsl:attribute name="HREF"><xsl:value-of select="$root"/>MA<xsl:value-of select="ARTICLES/@USERID"/>?show=<xsl:value-of select="ARTICLES/ARTICLE-LIST/@COUNT"/>&amp;type=1</xsl:attribute>
			<nobr><b><xsl:value-of select="$m_showeditedentries"/></b></nobr>
		</a>
		<xsl:if test="$ownerisviewer = 1">
			<xsl:value-of select="$skipdivider"/>
			<a class="norm">
				<xsl:attribute name="HREF"><xsl:value-of select="$root"/>MA<xsl:value-of select="ARTICLES/@USERID"/>?show=<xsl:value-of select="ARTICLES/ARTICLE-LIST/@COUNT"/>&amp;type=3</xsl:attribute>
				<nobr><b><xsl:value-of select="$m_showcancelledentries"/></b></nobr>
			</a>
		</xsl:if>
	</font>
</xsl:template-->
<!-- IL end -->

</xsl:stylesheet>
