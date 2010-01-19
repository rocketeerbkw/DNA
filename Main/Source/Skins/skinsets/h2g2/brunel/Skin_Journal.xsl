<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0" 
                xmlns:msxsl="urn:schemas-microsoft-com:xslt" 
                xmlns:local="#local-functions" 
                xmlns:s="urn:schemas-microsoft-com:xml-data" 
                xmlns:dt="urn:schemas-microsoft-com:datatypes">

<xsl:template name="JOURNAL_TITLE">
	<title><xsl:value-of select="$m_pagetitlestart"/><xsl:value-of select="$m_h2g2journaltitle"/></title>
</xsl:template>

<xsl:template name="JOURNAL_SUBJECT">
	<xsl:call-template name="SUBJECTHEADER">
		<xsl:with-param name="text"><xsl:value-of select="$m_journal"/></xsl:with-param>
	</xsl:call-template>
</xsl:template>

<xsl:template name="JOURNAL_TITLEDATA">
	<font xsl:use-attribute-sets="smallfont"><b><xsl:value-of select="$m_userdata"/></b><xsl:value-of select="$m_userdatano"/><xsl:value-of select="/H2G2/JOURNAL/@USERID"/></font>
	<br clear="ALL" /><img src="{$imagesource}t.gif" width="1" height="8" alt="" /><br clear="ALL" />
</xsl:template>

<xsl:template name="JOURNAL_MAINBODY">
	<td width="100%" bgcolor="#FFFFFF">
		<table width="100%" cellspacing="0" cellpadding="10" border="0">
			<tr>
				<td>
					<font xsl:use-attribute-sets="textfont">
						<xsl:apply-templates select="JOURNAL/JOURNALPOSTS" />
						<br/>
						<xsl:if test="JOURNAL/JOURNALPOSTS[@SKIPTO &gt; 0]">
							<a class="pos">
								<xsl:attribute name="HREF"><xsl:value-of select="$root"/>MJ<xsl:value-of select="JOURNAL/@USERID"/>?journal=<xsl:value-of select="JOURNAL/JOURNALPOSTS/@FORUMID"/>&amp;show=<xsl:value-of select="JOURNAL/JOURNALPOSTS/@COUNT"/>&amp;skip=<xsl:value-of select="number(JOURNAL/JOURNALPOSTS/@SKIPTO) - number(JOURNAL/JOURNALPOSTS/@COUNT)"/></xsl:attribute>
								<img src="{$imagesource}arrowh_pos.gif" width="3" height="9" alt="" border="0" hspace="3" /><b><xsl:call-template name="m_newerentries"/></b>
							</a>
							<br />
						</xsl:if>
						<xsl:if test="JOURNAL/JOURNALPOSTS[@MORE=1]">
							<a class="pos">
								<xsl:attribute name="HREF"><xsl:value-of select="$root"/>MJ<xsl:value-of select="JOURNAL/@USERID"/>?journal=<xsl:value-of select="JOURNAL/JOURNALPOSTS/@FORUMID"/>&amp;show=<xsl:value-of select="JOURNAL/JOURNALPOSTS/@COUNT"/>&amp;skip=<xsl:value-of select="number(JOURNAL/JOURNALPOSTS/@SKIPTO) + number(JOURNAL/JOURNALPOSTS/@COUNT)"/></xsl:attribute>
								<img src="{$imagesource}arrowh_pos.gif" width="3" height="9" alt="" border="0" hspace="3" /><b><xsl:call-template name="m_olderentries"/></b>
							</a>
							<br/>
						</xsl:if>
						<a class="pos">
							<xsl:attribute name="HREF"><xsl:value-of select="$root"/>U<xsl:value-of select="JOURNAL/@USERID"/></xsl:attribute>
							<img src="{$imagesource}arrowh_pos.gif" width="3" height="9" alt="" border="0" hspace="3" /><b><xsl:value-of select="$m_backtoresearcher"/></b>
						</a>
					</font>
				</td>
			</tr>
		</table>
		<br /><br /><br />
	</td>
</xsl:template>

</xsl:stylesheet>
