<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<xsl:import href="../../../base/base-onlinepopup.xsl"/>
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
									Page - Level  template
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<xsl:template name="ONLINE_MAINBODY">
		<table width="100%" cellpadding="5" cellspacing="5" border="0">
			<tr>
				<td class="postmain"><font xsl:use-attribute-sets="mainfont">
					<a name="top"/>
					<xsl:apply-templates select="ONLINEUSERS" mode="c_orderform"/>
					<xsl:apply-templates select="ONLINEUSERS" mode="t_number"/>
					<br/>
					<xsl:apply-templates select="ONLINEUSERS" mode="c_online"/></font>
					<br/><font size="1"><a href="#top">^back to top</a></font>
				</td>
			</tr>
		</table>
	</xsl:template>
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
					ORDERFORM Logical Container Template
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<!-- 
	<xsl:template match="ONLINEUSERS" mode="r_orderform">
	Use: Container for the 'Order by' form
	-->
	<xsl:template match="ONLINEUSERS" mode="r_orderform">
		<xsl:copy-of select="$m_onlineorderby"/>
		<xsl:apply-templates select="@ORDER-BY" mode="t_idbutton"/>
		<xsl:copy-of select="$m_onlineidradiolabel"/>
		<xsl:apply-templates select="@ORDER-BY" mode="t_namebutton"/>
		<xsl:value-of select="$m_onlinenameradiolabel"/>
	</xsl:template>
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
					ONLINEUSERS Logical Container Template
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<!-- 
	<xsl:template match="ONLINEUSERS" mode="id_online">
	Use: Container for online list ordered by id
	-->
	<xsl:template match="ONLINEUSER" mode="id_online">
		<xsl:apply-templates select="." mode="c_online"/>
	</xsl:template>
	<!-- 
	<xsl:template match="ONLINEUSERS" mode="name_online">
	Use: Container for online list ordered by name
	-->
	<xsl:template match="ONLINEUSER" mode="name_online">
		<xsl:apply-templates select="." mode="c_online"/>
	</xsl:template>
	<!-- 
	<xsl:template match="ONLINEUSERS" mode="default_online">
	Use: Container for default online list
	-->
	<xsl:template match="ONLINEUSER" mode="default_online">
		<xsl:apply-templates select="." mode="c_online"/>
	</xsl:template>
	<!-- 
	<xsl:template match="ONLINEUSER" mode="r_online">
	Use: Display information for each username link in the list
	-->
	<xsl:template match="ONLINEUSER" mode="r_online">
		<xsl:apply-imports/>
		<br/>
	</xsl:template>
	<!-- 
	<xsl:attribute-set name="fONLINEUSERS_c_orderform"/>
	Use: Attribute set for the form element
	-->
	<xsl:attribute-set name="fONLINEUSERS_c_orderform"/>
	<!-- 
	<xsl:attribute-set name="iORDERBY_t_idbutton"/>
	Use: Attribute set for the id radio button element
	-->
	<xsl:attribute-set name="iORDERBY_t_idbutton"/>
	<!-- 
	<xsl:attribute-set name="iORDERBY_t_namebutton"/>
	Use: Attribute set for the name radio button element
	-->
	<xsl:attribute-set name="iORDERBY_t_namebutton"/>
</xsl:stylesheet>
