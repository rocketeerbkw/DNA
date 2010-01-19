<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
	<!ENTITY space "<xsl:text xmlns:xsl='http://www.w3.org/1999/XSL/Transform'> </xsl:text>">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">








<!-- Fonts -->
<xsl:variable name="text.base">font</xsl:variable> 
        <xsl:attribute-set name="text.base"> 
        <xsl:attribute name="size">2</xsl:attribute> 
        <xsl:attribute name="class">base</xsl:attribute> 
</xsl:attribute-set> 

<xsl:variable name="text.medium">font</xsl:variable> 
        <xsl:attribute-set name="text.medium"> 
        <xsl:attribute name="size">1</xsl:attribute> 
        <xsl:attribute name="class">medium</xsl:attribute> 
</xsl:attribute-set> 

 


</xsl:stylesheet>