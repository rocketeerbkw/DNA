<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
	<!ENTITY space "<xsl:text xmlns:xsl='http://www.w3.org/1999/XSL/Transform'> </xsl:text>">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">

		<xsl:variable name="button.submitreview"><img src="{$graphics}buttons/button_submitreview.gif" width="151" height="25" alt="submit for review" border="0" /></xsl:variable>
<xsl:variable name="button.editlarge"><img src="{$graphics}buttons/button_editlarge.gif" width="78" height="25" alt="read" border="0" /></xsl:variable>
	<xsl:variable name="button.read"><img src="{$graphics}buttons/button_read.gif" width="69" height="20" alt="read" border="0" /></xsl:variable>
	<xsl:variable name="button.remove"><img src="{$graphics}buttons/button_remove.gif" width="72" height="20" alt="remove" border="0" /></xsl:variable>
	<xsl:variable name="m_acceptlink"><img src="{$graphics}buttons/button_accept.gif" width="76" height="20" alt="remove" border="0" /></xsl:variable>
	<xsl:variable name="m_rejectlink"><img src="{$graphics}buttons/button_decline.gif" width="76" height="20" alt="remove" border="0" /></xsl:variable>
	<xsl:variable name="button.admin"><img src="{$graphics}buttons/button_admin.gif" width="66" height="20" alt="remove" border="0" /></xsl:variable>
	<xsl:variable name="m_delete">
	<xsl:choose>
	<xsl:when test="/H2G2/@TYPE='TYPED-ARTICLE'">Delete</xsl:when>
	<xsl:otherwise>Delete<!-- <xsl:copy-of select="$button.remove" /> --></xsl:otherwise>
</xsl:choose>
	
	
	</xsl:variable>
	 <xsl:variable name="m_removeme"><xsl:copy-of select="$button.remove" /></xsl:variable> 
	<xsl:variable name="m_editme"><img src="{$graphics}buttons/button_edit.gif" width="66" height="22" alt="edit" border="0" /></xsl:variable>
	<xsl:variable name="button.approve"><img src="{$graphics}buttons/button_approve.gif" width="76" height="20" alt="approve" border="0" /></xsl:variable>
	<xsl:variable name="button.decline"><img src="{$graphics}buttons/button_decline.gif" width="76" height="20" alt="decline" border="0" /></xsl:variable>
	<xsl:variable name="button.seeexample"><img src="{$graphics}buttons/button_seeanexample.gif" width="178" height="35" alt="see example" border="0" vspace="7"  /></xsl:variable>


	<xsl:attribute-set name="form.default.properties">
		<xsl:attribute name="type">image</xsl:attribute>
		<xsl:attribute name="border">0</xsl:attribute>
		<xsl:attribute name="vspace">5</xsl:attribute>
		<xsl:attribute name="hspace">2</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="form.preview" use-attribute-sets="form.default.properties">
		<xsl:attribute name="src"><xsl:value-of select="$graphics" />buttons/button_preview.gif</xsl:attribute>
		<xsl:attribute name="width">94</xsl:attribute>
		<xsl:attribute name="height">25</xsl:attribute>
		<xsl:attribute name="alt">preview</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="form.publish" use-attribute-sets="form.default.properties">
		<xsl:attribute name="src"><xsl:value-of select="$graphics" />buttons/button_publish.gif</xsl:attribute>
		<xsl:attribute name="width">94</xsl:attribute>
		<xsl:attribute name="height">25</xsl:attribute>
		<xsl:attribute name="alt">publish</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="form.change" use-attribute-sets="form.default.properties">
		<xsl:attribute name="src"><xsl:value-of select="$graphics" />buttons/button_change.gif</xsl:attribute>
		<xsl:attribute name="width">95</xsl:attribute>
		<xsl:attribute name="height">25</xsl:attribute>
		<xsl:attribute name="alt">change</xsl:attribute>
	</xsl:attribute-set>
	
		<xsl:attribute-set name="form.change.small" use-attribute-sets="form.default.properties">
		<xsl:attribute name="src"><xsl:value-of select="$graphics" />buttons/button_change_small.gif</xsl:attribute>
		<xsl:attribute name="width">70</xsl:attribute>
		<xsl:attribute name="height">20</xsl:attribute>
		<xsl:attribute name="alt">change</xsl:attribute>
	</xsl:attribute-set>
	
	
	
	<xsl:attribute-set name="form.submit" use-attribute-sets="form.default.properties">
		<xsl:attribute name="src"><xsl:value-of select="$graphics" />buttons/button_submit.gif</xsl:attribute>
		<xsl:attribute name="width">95</xsl:attribute>
		<xsl:attribute name="height">25</xsl:attribute>
		<xsl:attribute name="alt">submit</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="form.save" use-attribute-sets="form.default.properties">
		<xsl:attribute name="src"><xsl:value-of select="$graphics" />buttons/button_save.gif</xsl:attribute>
		<xsl:attribute name="width">95</xsl:attribute>
		<xsl:attribute name="height">25</xsl:attribute>
		<xsl:attribute name="alt">save</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="form.search" use-attribute-sets="form.default.properties">
		<xsl:attribute name="src"><xsl:value-of select="$graphics" />buttons/button_search.gif</xsl:attribute>
		<xsl:attribute name="width">85</xsl:attribute>
		<xsl:attribute name="height">25</xsl:attribute>
		<xsl:attribute name="alt">search</xsl:attribute>
	</xsl:attribute-set>


	<xsl:attribute-set name="form.update" /> 

</xsl:stylesheet>
