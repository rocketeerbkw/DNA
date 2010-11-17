<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">
    
    <doc:documentation>
        <doc:purpose>
			Converts PULLQUOTE nodes to HTML blockquotes
		</doc:purpose>
        <doc:context>
            Applied by _common/_library/GuideML.xsl
        </doc:context>
        <doc:notes>
            
        </doc:notes>
    </doc:documentation>
	

	<xsl:template match="PULLQUOTE | pullquote" mode="library_GuideML">
		<xsl:choose>
			<xsl:when test="@EMBED">
				<table cellpadding="6" cellspacing="6" width="200">
					<xsl:attribute name="align">
						<xsl:value-of select="@EMBED"/>
					</xsl:attribute>
					<tr valign="middle">
						<td ALIGN="left">
							<xsl:element name="P">
								<xsl:choose>
									<xsl:when test="@ALIGN">
										<xsl:attribute name="ALIGN">
											<xsl:value-of select="@ALIGN"/>
										</xsl:attribute>
									</xsl:when>
									<xsl:otherwise>
										<xsl:attribute name="ALIGN">CENTER</xsl:attribute>
									</xsl:otherwise>
								</xsl:choose>
								<font color="#BB4444" face="Verdana, Verdana, Arial, Helvetica, sans-serif" size="2" >
									<b>
										<xsl:apply-templates mode="library_GuideML"/>
									</b>
								</font>
							</xsl:element>
						</td>
					</tr>
				</table>
			</xsl:when>
			<xsl:otherwise>
				<xsl:element name="P">
					<xsl:choose>
						<xsl:when test="@ALIGN">
							<xsl:attribute name="ALIGN">
								<xsl:value-of select="@ALIGN"/>
							</xsl:attribute>
						</xsl:when>
						<xsl:otherwise>
							<xsl:attribute name="ALIGN">CENTER</xsl:attribute>
						</xsl:otherwise>
					</xsl:choose>
					<font color="#BB4444" face="Verdana, Verdana, Arial, Helvetica, sans-serif" size="2" >
						<b>
							<xsl:apply-templates mode="library_GuideML"/>
						</b>
					</font>
				</xsl:element>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>