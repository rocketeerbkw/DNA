<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0" 
                xmlns:msxsl="urn:schemas-microsoft-com:xslt" 
                xmlns:local="#local-functions" 
                xmlns:s="urn:schemas-microsoft-com:xml-data" 
                xmlns:dt="urn:schemas-microsoft-com:datatypes">

<xsl:template name="SUBSCRIBE_SUBJECT">
<xsl:call-template name="SUBJECTHEADER">
	<xsl:with-param name="text">
		<xsl:choose>
			<xsl:when test="SUBSCRIBE-RESULT/@TOTHREAD or SUBSCRIBE-RESULT/@TOFORUM or UBSCRIBE-RESULT/@JOURNAL or SUBSCRIBE-RESULT/@FROMTHREAD or SUBSCRIBE-RESULT/@FROMFORUM">
				<xsl:value-of select="$m_subrequestcomplete"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$m_subrequestfailed"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:with-param>
</xsl:call-template>
</xsl:template>

<xsl:template name="SUBSCRIBE_BAR">
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
								<xsl:when test="SUBSCRIBE-RESULT/@TOTHREAD">
									<xsl:value-of select="$m_subthreadcomplete"/>
								</xsl:when>
								<xsl:when test="SUBSCRIBE-RESULT/@TOFORUM">
									<xsl:value-of select="$m_subforumcomplete"/>
								</xsl:when>
								<xsl:when test="SUBSCRIBE-RESULT/@JOURNAL">
									<xsl:value-of select="$m_journalremovecomplete"/>
								</xsl:when>
								<xsl:when test="SUBSCRIBE-RESULT/@FROMTHREAD">
									<xsl:value-of select="$m_unsubthreadcomplete"/>
								</xsl:when>
								<xsl:when test="SUBSCRIBE-RESULT/@FROMFORUM">
									<xsl:value-of select="$m_unsubforumcomplete"/>
								</xsl:when>
							</xsl:choose>						
						</b></font>
					</td>
				</tr>
				<tr><td><img src="{$imagesource}t.gif" width="1" height="5" alt="" /></td></tr>
				<tr><td><img src="{$imagesource}t.gif" width="1" height="8" alt="" /></td></tr>
			</table>
		</xsl:with-param>
	</xsl:call-template>
</xsl:template>

<xsl:template name="SUBSCRIBE_MAINBODY">
	<xsl:apply-templates select="SUBSCRIBE-RESULT"/>
	<xsl:apply-templates select="RETURN-TO"/>
</xsl:template>

<xsl:template match="RETURN-TO">
	<br/><a class="norm" href="{$root}{URL}"><xsl:value-of select="DESCRIPTION"/></a><br/>
</xsl:template>

</xsl:stylesheet>
