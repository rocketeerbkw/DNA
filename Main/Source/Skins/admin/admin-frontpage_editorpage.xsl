<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<xsl:template name="FRONTPAGE_EDITOR">
		<xsl:apply-templates select="FRONTPAGE-PREVIEW-PARSEERROR"/>
		<xsl:apply-templates select="FRONTPAGE-EDIT-FORM"/>
	</xsl:template>
	<xsl:template match="FRONTPAGE-PREVIEW-PARSEERROR">
		<xsl:apply-templates/>
	</xsl:template>
	<xsl:template match="FRONTPAGE-EDIT-FORM">
		<form method="post" action="EditFrontpage">
			<textarea cols="70" rows="20" wrap="virtual" name="bodytext">
				<xsl:value-of select="BODY"/>
			</textarea>
			<br/>
Skin: <input type="text" name="skin" value="{SKIN}"/>
Date Active: <input type="text" name="date" value="{DATE}"/>
			<input type="checkbox" name="registered" value="1">
				<xsl:if test="REGISTERED=1">
					<xsl:attribute name="checked">checked</xsl:attribute>
				</xsl:if>
			</input> Registered
<input type="submit" name="preview" value="Preview"/>
			<input type="submit" name="storepage" value="Store page"/>
		</form>
	</xsl:template>
	<xsl:template match="XMLPARSEERROR">
An XML Parsing error occurred.<br/>
		<xsl:value-of select="REASON"/>
		<br/>
at line <xsl:value-of select="LINENUMBER"/>, character <xsl:value-of select="CHARACTER"/>
		<br/>
		<br/>
		<xsl:choose>
			<xsl:when test="SOURCE">
				<font size="3">
					<SAMP>
						<xsl:value-of select="substring(SOURCE,1,number(CHARACTER)-1)"/>
						<b>
							<font color="red">[here]</font>
						</b>
						<xsl:value-of select="substring(SOURCE,number(CHARACTER))"/>
					</SAMP>
				</font>
			</xsl:when>
			<xsl:otherwise>
We are unable to display the line containing the error.
</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>