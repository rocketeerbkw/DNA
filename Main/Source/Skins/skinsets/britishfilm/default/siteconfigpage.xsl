<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
	<!ENTITY space "<xsl:text xmlns:xsl='http://www.w3.org/1999/XSL/Transform'> </xsl:text>">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<xsl:import href="../../../base/base-siteconfigpage.xsl"/>
	<xsl:variable name="configfields"><![CDATA[<MULTI-INPUT>
						<ELEMENT NAME='LISTOFLINKS'></ELEMENT>
						<ELEMENT NAME='THEMES'></ELEMENT>
						<ELEMENT NAME='MEDIUMS'></ELEMENT>
				</MULTI-INPUT>]]></xsl:variable>
				
				
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
								Page - Level  template
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	
	<xsl:template name="SITECONFIG-EDITOR_MAINBODY">
		<font size="2">
			<a href="{$root}Siteconfig?_msxml={$configfields}">
				Initialise fields
			</a>
			<br/>
			Site - <xsl:value-of select="SITECONFIG-EDIT/URLNAME"/>
			<xsl:apply-templates select="ERROR" mode="c_siteconfig"/>
			<xsl:apply-templates select="SITECONFIG-EDIT" mode="c_siteconfig"/>
		</font>
	</xsl:template>
	
	
	<xsl:template match="SITECONFIG-EDIT" mode="r_siteconfig">

		<table>
		<tr>
		<td>
		List of Links:
		<br/>
		<textarea name="listoflinks" rows="8" cols="40">
		<xsl:choose><xsl:when test="MULTI-STAGE/MULTI-ELEMENT/@NAME = 'LISTOFLINKS'"><xsl:value-of select="MULTI-STAGE/MULTI-ELEMENT[@NAME = 'LISTOFLINKS']/VALUE-EDITABLE"/></xsl:when><xsl:otherwise>Please initialise the site config information</xsl:otherwise></xsl:choose>
		</textarea>
		<br/></td>
		<td>&nbsp;&nbsp;</td>
			<td><xsl:apply-templates select="MULTI-STAGE/MULTI-ELEMENT[@NAME='LISTOFLINKS']/VALUE" /></td>
		</tr>
		</table>

		<br/><br/>
		<table>
		<tr>
		<td>
		Theme drop down:
		<br/>
		<textarea name="themes" rows="8" cols="40">
		<xsl:choose><xsl:when test="MULTI-STAGE/MULTI-ELEMENT/@NAME = 'THEMES'"><xsl:value-of select="MULTI-STAGE/MULTI-ELEMENT[@NAME = 'THEMES']/VALUE-EDITABLE"/></xsl:when><xsl:otherwise>Please initialise the site config information</xsl:otherwise></xsl:choose>
		</textarea>
		<br/></td>
		<td>&nbsp;&nbsp;</td>
			<td><xsl:apply-templates select="MULTI-STAGE/MULTI-ELEMENT[@NAME='THEMES']/VALUE" /></td>
		</tr>
		</table>

		<br/><br/>
		<table>
		<tr>
		<td>
		Medium/Other drop down:
		<br/>
		<textarea name="mediums" rows="8" cols="40">
		<xsl:choose><xsl:when test="MULTI-STAGE/MULTI-ELEMENT/@NAME = 'MEDIUMS'"><xsl:value-of select="MULTI-STAGE/MULTI-ELEMENT[@NAME = 'MEDIUMS']/VALUE-EDITABLE"/></xsl:when><xsl:otherwise>Please initialise the site config information</xsl:otherwise></xsl:choose>
		</textarea>
		<br/></td>
		<td>&nbsp;&nbsp;</td>
			<td><xsl:apply-templates select="MULTI-STAGE/MULTI-ELEMENT[@NAME='MEDIUMS']/VALUE" /></td>
		</tr>
		</table>

		
		
		<input type="submit" name="_mscancel" value="preview"/>
		<xsl:apply-templates select="." mode="t_configeditbutton"/>
	</xsl:template>

	<xsl:attribute-set name="fSITECONFIG-EDIT_c_siteconfig"/>
	<xsl:attribute-set name="iSITECONFIG-EDIT_t_configeditbutton"/>
	<xsl:attribute-set name="iSITECONFIG-EDIT_t_configpreviewbutton"/>
	
	<xsl:template match="ERROR" mode="r_siteconfig">
		<xsl:apply-imports/>
	</xsl:template>

</xsl:stylesheet>
