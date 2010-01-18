<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
	<!ENTITY space "<xsl:text xmlns:xsl='http://www.w3.org/1999/XSL/Transform'> </xsl:text>">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<xsl:import href="../../../base/base-siteconfigpage.xsl"/>
	<xsl:variable name="configfields"><![CDATA[<MULTI-INPUT>
						<ELEMENT NAME='IMGPROMO1'></ELEMENT>
						<ELEMENT NAME='IMGPROMO2'></ELEMENT>
						<ELEMENT NAME='IMGPROMO3'></ELEMENT>
						<ELEMENT NAME='IMGPROMO4'></ELEMENT>
						<ELEMENT NAME='IMGPROMO5'></ELEMENT>
						<ELEMENT NAME='IMGPROMO6'></ELEMENT>
						<ELEMENT NAME='IMGPROMO7'></ELEMENT>
						<ELEMENT NAME='TEXTPROMO1'></ELEMENT>
						<ELEMENT NAME='TEXTPROMO2'></ELEMENT>
						<ELEMENT NAME='TEXTPROMO3'></ELEMENT>
						<ELEMENT NAME='TEXTPROMO4'></ELEMENT>
						<ELEMENT NAME='TIMETABLE'></ELEMENT>
						<ELEMENT NAME='CALENDAR'></ELEMENT>
				</MULTI-INPUT>]]></xsl:variable>
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
									Page - Level  template
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->

	<xsl:template name="SITECONFIG-EDITOR_MAINBODY">
	
	<xsl:if test="$test_IsEditor">

			<xsl:apply-templates select="ERROR" mode="c_siteconfig"/>
			
			
			<xsl:choose>
			<xsl:when test="not(SITECONFIG-EDIT/MULTI-STAGE[descendant::MULTI-ELEMENT!=''])">
			
	<!-- 		<form method="post" action="siteconfig" xsl:use-attribute-sets="fSITECONFIG-EDIT_c_siteconfig">
<input type="hidden" name="_msxml" value="{$configfields}"/>
<input type="submit" value="initialise siteconfig" />
			</form> -->
			<xsl:apply-templates select="SITECONFIG-EDIT" mode="c_siteconfig"/>
			
			</xsl:when>
			<xsl:otherwise>
			<xsl:apply-templates select="SITECONFIG-EDIT" mode="c_siteconfig"/>
			</xsl:otherwise>
			</xsl:choose>

	</xsl:if>
	
	
	</xsl:template>
	<xsl:template match="SITECONFIG-EDIT" mode="r_siteconfig">

		<!--<input type="hidden" name="skin" value="purexml"/>-->
		
		
		<input type="hidden" name="_msfinish" value="yes"/>
		<input type="hidden" name="_msxml" value="{$configfields}"/>
	
		<table border="0" cellspacing="2" cellpadding="2">
		<tr>
		<td>
		<xsl:element name="{$text.base}" use-attribute-sets="text.base">
		<strong>Promo 1:</strong>
		<br/>
		<textarea type="text" name="IMGPROMO1" rows="5" cols="50">
		<xsl:choose>
		<xsl:when test="MULTI-STAGE/MULTI-ELEMENT/@NAME = 'IMGPROMO1'">
		<xsl:value-of select="MULTI-STAGE/MULTI-ELEMENT[@NAME='IMGPROMO1']/VALUE-EDITABLE"/>
		</xsl:when>
		<xsl:otherwise>Please initialise the site config information</xsl:otherwise>
		</xsl:choose>
		</textarea>		
		</xsl:element>
		</td>
		<td width="195">
		<xsl:apply-templates select="MULTI-STAGE/MULTI-ELEMENT[@NAME='IMGPROMO1']/VALUE" />
		</td>
		</tr>
		</table>
		<br/>
		
		<table border="0" cellspacing="2" cellpadding="2">
		<tr>
		<td>
		<xsl:element name="{$text.base}" use-attribute-sets="text.base">
		<strong>Promo 2:</strong>
		<br/>
		<textarea type="text" name="IMGPROMO2" rows="5" cols="50">
		<xsl:choose>
		<xsl:when test="MULTI-STAGE/MULTI-ELEMENT/@NAME = 'IMGPROMO2'">
		<xsl:value-of select="MULTI-STAGE/MULTI-ELEMENT[@NAME='IMGPROMO2']/VALUE-EDITABLE"/>
		</xsl:when>
		<xsl:otherwise>Please initialise the site config information</xsl:otherwise>
		</xsl:choose>
		</textarea>
		</xsl:element>
		</td>
		<td width="195">
		<xsl:apply-templates select="MULTI-STAGE/MULTI-ELEMENT[@NAME='IMGPROMO2']/VALUE" />
		</td>
		</tr>
		</table>
		
		<table border="0" cellspacing="2" cellpadding="2">
		<tr>
		<td>
		<xsl:element name="{$text.base}" use-attribute-sets="text.base">
		<strong>Promo 3:</strong>
		<br/>
		<textarea type="text" name="IMGPROMO3" rows="5" cols="50">
		<xsl:choose>
		<xsl:when test="MULTI-STAGE/MULTI-ELEMENT/@NAME = 'IMGPROMO3'">
		<xsl:value-of select="MULTI-STAGE/MULTI-ELEMENT[@NAME='IMGPROMO3']/VALUE-EDITABLE"/>
		</xsl:when>
		<xsl:otherwise>Please initialise the site config information</xsl:otherwise>
		</xsl:choose>
		</textarea>
		<br/>
		</xsl:element>
		</td>
		<td width="195">
		<xsl:apply-templates select="MULTI-STAGE/MULTI-ELEMENT[@NAME='IMGPROMO3']/VALUE" />
		</td>
		</tr>
		</table>
		<br/>
		
		<table border="0" cellspacing="2" cellpadding="2">
		<tr>
		<td>
		<xsl:element name="{$text.base}" use-attribute-sets="text.base">
		<strong>Promo 4:</strong>
		<br/>
		<textarea type="text" name="IMGPROMO4" rows="5" cols="50">
		<xsl:choose>
		<xsl:when test="MULTI-STAGE/MULTI-ELEMENT/@NAME = 'IMGPROMO4'">
		<xsl:value-of select="MULTI-STAGE/MULTI-ELEMENT[@NAME='IMGPROMO4']/VALUE-EDITABLE"/>
		</xsl:when>
		<xsl:otherwise>Please initialise the site config information</xsl:otherwise>
		</xsl:choose>
		</textarea>
		<br/>
		</xsl:element>
		</td>
		<td width="195">
		<xsl:apply-templates select="MULTI-STAGE/MULTI-ELEMENT[@NAME='IMGPROMO4']/VALUE" />
		</td>
		</tr>
		</table>
		<br/>
		
		<table border="0" cellspacing="2" cellpadding="2">
		<tr>
		<td>
		<xsl:element name="{$text.base}" use-attribute-sets="text.base">
		<strong>Promo 5:</strong>
		<br/>
		<textarea type="text" name="IMGPROMO5" rows="5" cols="50">
		<xsl:choose>
		<xsl:when test="MULTI-STAGE/MULTI-ELEMENT/@NAME = 'IMGPROMO5'">
		<xsl:value-of select="MULTI-STAGE/MULTI-ELEMENT[@NAME='IMGPROMO5']/VALUE-EDITABLE"/>
		</xsl:when>
		<xsl:otherwise>Please initialise the site config information</xsl:otherwise>
		</xsl:choose>
		</textarea>
		<br/>
		</xsl:element>
		</td>
		<td width="195">
		<xsl:apply-templates select="MULTI-STAGE/MULTI-ELEMENT[@NAME='IMGPROMO5']/VALUE" />
		</td>
		</tr>
		</table>
		<br/>
		
		<table border="0" cellspacing="2" cellpadding="2">
		<tr>
		<td>
		<xsl:element name="{$text.base}" use-attribute-sets="text.base">
		<strong>Promo 6:</strong>
		<br/>
		<textarea type="text" name="IMGPROMO6" rows="5" cols="50">
		<xsl:choose>
		<xsl:when test="MULTI-STAGE/MULTI-ELEMENT/@NAME = 'IMGPROMO6'">
		<xsl:value-of select="MULTI-STAGE/MULTI-ELEMENT[@NAME='IMGPROMO6']/VALUE-EDITABLE"/>
		</xsl:when>
		<xsl:otherwise>Please initialise the site config information</xsl:otherwise>
		</xsl:choose>
		</textarea>
		<br/>
		</xsl:element>
		</td>
		<td width="195">
		<xsl:apply-templates select="MULTI-STAGE/MULTI-ELEMENT[@NAME='IMGPROMO6']/VALUE" />
		</td>
		</tr>
		</table>
		<br/>
		
		<table border="0" cellspacing="2" cellpadding="2">
		<tr>
		<td>
		<xsl:element name="{$text.base}" use-attribute-sets="text.base">
		<strong>Promo 7:</strong>
		<br/>
		<textarea type="text" name="IMGPROMO7" rows="5" cols="50">
		<xsl:choose>
		<xsl:when test="MULTI-STAGE/MULTI-ELEMENT/@NAME = 'IMGPROMO7'">
		<xsl:value-of select="MULTI-STAGE/MULTI-ELEMENT[@NAME='IMGPROMO7']/VALUE-EDITABLE"/>
		</xsl:when>
		<xsl:otherwise>Please initialise the site config information</xsl:otherwise>
		</xsl:choose>
		</textarea>
		<br/>
		</xsl:element>
		</td>
		<td width="195">
		<xsl:apply-templates select="MULTI-STAGE/MULTI-ELEMENT[@NAME='IMGPROMO7']/VALUE" />
		</td>
		</tr>
		</table>
		<br/>
		
		<table border="0" cellspacing="2" cellpadding="2">
		<tr>
		<td>
		<xsl:element name="{$text.base}" use-attribute-sets="text.base">
	 	<strong> TEXT Promo 1:</strong>
		<br/>
		<textarea type="text" name="TEXTPROMO1" rows="5" cols="50">
		<xsl:choose>
		<xsl:when test="MULTI-STAGE/MULTI-ELEMENT/@NAME = 'TEXTPROMO1'">
		<xsl:value-of select="MULTI-STAGE/MULTI-ELEMENT[@NAME='TEXTPROMO1']/VALUE-EDITABLE"/>
		</xsl:when>
		<xsl:otherwise>Please initialise the site config information</xsl:otherwise>
		</xsl:choose>
		</textarea>
		</xsl:element>
		</td>
		<td>
		<xsl:apply-templates select="MULTI-STAGE/MULTI-ELEMENT[@NAME='TEXTPROMO1']/VALUE" />
		</td>
		</tr>
		</table>
     	<br/>
		
		<table border="0" cellspacing="2" cellpadding="2">
		<tr>
		<td>
		<xsl:element name="{$text.base}" use-attribute-sets="text.base">
		<strong>TEXT Promo 2:</strong>
		<br/>
		<textarea type="text" name="TEXTPROMO2" rows="5" cols="50">
		<xsl:choose>
		<xsl:when test="MULTI-STAGE/MULTI-ELEMENT/@NAME = 'TEXTPROMO2'">
		<xsl:value-of select="MULTI-STAGE/MULTI-ELEMENT[@NAME='TEXTPROMO2']/VALUE-EDITABLE"/>
		</xsl:when>
		<xsl:otherwise>Please initialise the site config information</xsl:otherwise>
		</xsl:choose>
		</textarea>
		</xsl:element>
		</td>
		<td>
		<xsl:apply-templates select="MULTI-STAGE/MULTI-ELEMENT[@NAME='TEXTPROMO2']/VALUE" />
		</td>
		</tr>
		</table>
		<br/>
		
		
		<table border="0" cellspacing="2" cellpadding="2">
		<tr>
		<td>
		<xsl:element name="{$text.base}" use-attribute-sets="text.base">
	    <strong>TEXT Promo 3:</strong>
		<br/>
		<textarea type="text" name="TEXTPROMO3" rows="5" cols="50">
		<xsl:choose>
		<xsl:when test="MULTI-STAGE/MULTI-ELEMENT/@NAME = 'TEXTPROMO3'">
		<xsl:value-of select="MULTI-STAGE/MULTI-ELEMENT[@NAME='TEXTPROMO3']/VALUE-EDITABLE"/>
		</xsl:when>
		<xsl:otherwise>Please initialise the site config information</xsl:otherwise>
		</xsl:choose>
		</textarea>
		</xsl:element>
		</td>
		<td>
		<xsl:apply-templates select="MULTI-STAGE/MULTI-ELEMENT[@NAME='TEXTPROMO3']/VALUE" />
		</td>
		</tr>
		</table>
		<br/>
		
		<table border="0" cellspacing="2" cellpadding="2">
		<tr>
		<td>
		<xsl:element name="{$text.base}" use-attribute-sets="text.base">
	    <strong>TEXT Promo 4:</strong>
		<br/>
		<textarea type="text" name="TEXTPROMO4" rows="5" cols="50">
		<xsl:choose>
		<xsl:when test="MULTI-STAGE/MULTI-ELEMENT/@NAME = 'TEXTPROMO4'">
		<xsl:value-of select="MULTI-STAGE/MULTI-ELEMENT[@NAME='TEXTPROMO4']/VALUE-EDITABLE"/>
		</xsl:when>
		<xsl:otherwise>Please initialise the site config information</xsl:otherwise>
		</xsl:choose>
		</textarea>
		</xsl:element>
		</td>
		<td>
		<xsl:apply-templates select="MULTI-STAGE/MULTI-ELEMENT[@NAME='TEXTPROMO4']/VALUE" />
		</td>
		</tr>
		</table>
		<br/>
		
		<table border="0" cellspacing="2" cellpadding="2">
		<tr>
		<td>
		<xsl:element name="{$text.base}" use-attribute-sets="text.base">
	    <strong>TIME TABLE:</strong>
		<br/>
		<textarea type="text" name="TIMETABLE" rows="25" cols="50">
		<xsl:choose>
		<xsl:when test="MULTI-STAGE/MULTI-ELEMENT/@NAME = 'TIMETABLE'">
		<xsl:value-of select="MULTI-STAGE/MULTI-ELEMENT[@NAME='TIMETABLE']/VALUE-EDITABLE"/>
		</xsl:when>
		<xsl:otherwise>Please initialise the site config information</xsl:otherwise>
		</xsl:choose>
		</textarea>
		</xsl:element>
		</td>
		<td>
		<xsl:apply-templates select="MULTI-STAGE/MULTI-ELEMENT[@NAME='TIMETABLE']/VALUE" />
		</td>
		</tr>
		</table>
		<br/>
		
		<table border="0" cellspacing="2" cellpadding="2">
		<tr>
		<td>
		<xsl:element name="{$text.base}" use-attribute-sets="text.base">
	    <strong>CALENDAR:</strong>
		<br/>
		<textarea type="text" name="CALENDAR" rows="25" cols="50">
		<xsl:choose>
		<xsl:when test="MULTI-STAGE/MULTI-ELEMENT/@NAME = 'CALENDAR'">
		<xsl:value-of select="MULTI-STAGE/MULTI-ELEMENT[@NAME='CALENDAR']/VALUE-EDITABLE"/>
		</xsl:when>
		<xsl:otherwise>Please initialise the site config information</xsl:otherwise>
		</xsl:choose>
		</textarea>
		</xsl:element>
		</td>
		<td>
		<xsl:apply-templates select="MULTI-STAGE/MULTI-ELEMENT[@NAME='CALENDAR']/VALUE" />
		</td>
		</tr>
		</table>
		<br/>
	
		
		<input type="submit" name="_mscancel" value="preview"/>
		<input type="submit" name="bob" value="submit"/>
		
	</xsl:template>
	<xsl:attribute-set name="fSITECONFIG-EDIT_c_siteconfig"/>
	<xsl:attribute-set name="iSITECONFIG-EDIT_t_configeditbutton"/>
	<xsl:attribute-set name="iSITECONFIG-EDIT_t_configpreviewbutton"/>
	
	<xsl:template match="ERROR" mode="r_siteconfig">
		<xsl:apply-imports/>
	</xsl:template>
</xsl:stylesheet>
