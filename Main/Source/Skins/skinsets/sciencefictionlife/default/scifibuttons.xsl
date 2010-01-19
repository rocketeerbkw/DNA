<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
	<!ENTITY space "<xsl:text xmlns:xsl='http://www.w3.org/1999/XSL/Transform'> </xsl:text>">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">

	<xsl:attribute-set name="form.default.properties">
		<xsl:attribute name="type">image</xsl:attribute>
		<xsl:attribute name="border">0</xsl:attribute>
		<xsl:attribute name="vspace">5</xsl:attribute>
		<xsl:attribute name="hspace">2</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="form.preview" use-attribute-sets="form.default.properties">
		<xsl:attribute name="src"><xsl:value-of select="$imagesource" />buttons/preview.gif</xsl:attribute>
		<xsl:attribute name="width">121</xsl:attribute>
		<xsl:attribute name="height">23</xsl:attribute>
		<xsl:attribute name="alt">preview</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="form.publish" use-attribute-sets="form.default.properties">
		<xsl:attribute name="src"><xsl:value-of select="$imagesource" />buttons/publish.gif</xsl:attribute>
		<!-- <xsl:attribute name="width">121</xsl:attribute>
		<xsl:attribute name="height">23</xsl:attribute> -->
		<xsl:attribute name="alt">publish</xsl:attribute>                                                          
	</xsl:attribute-set>


	<xsl:attribute-set name="form.update" /> 


	<xsl:attribute-set name="anchor.edit">
		<xsl:attribute name="src"><xsl:value-of select="$imageRoot" />images/edit.gif</xsl:attribute>
		<xsl:attribute name="width">94</xsl:attribute>
		<xsl:attribute name="height">23</xsl:attribute>
		<xsl:attribute name="alt">edit</xsl:attribute>
		<xsl:attribute name="border">0</xsl:attribute>
		<xsl:attribute name="vspace">1</xsl:attribute>
		<xsl:attribute name="hspace">2</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="anchor.publish">
		<xsl:attribute name="src"><xsl:value-of select="$imageRoot" />images/publish.gif</xsl:attribute>
		<xsl:attribute name="width">94</xsl:attribute>
		<xsl:attribute name="height">23</xsl:attribute>
		<xsl:attribute name="alt">publish</xsl:attribute>
		<xsl:attribute name="border">0</xsl:attribute>
		<xsl:attribute name="vspace">1</xsl:attribute>
		<xsl:attribute name="hspace">2</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="anchor.seelastcomments"> 
		<xsl:attribute name="src"><xsl:value-of select="$imagesource" />buttons/see_last_comment.gif</xsl:attribute>
		<xsl:attribute name="width">143</xsl:attribute>
		<xsl:attribute name="height">23</xsl:attribute>
		<xsl:attribute name="alt">see last comment</xsl:attribute>
		<xsl:attribute name="border">0</xsl:attribute>
		<xsl:attribute name="vspace">1</xsl:attribute>
		<xsl:attribute name="hspace">2</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:variable name="m_delete"><img src="{$imagesource}buttons/delete.gif" alt="delete articles" width="120" height="23" vspace="5" hspace="2" border="0"/></xsl:variable>
	
    <xsl:variable name="graphicrss"><img src="{$imagesource}buttons/rss.gif" alt="rss" width="120" height="23" vspace="0" hspace="0" border="0"/></xsl:variable>

</xsl:stylesheet>
