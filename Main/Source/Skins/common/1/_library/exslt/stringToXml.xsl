<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="1.0"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt"
    xmlns:dna="http://www.bbc.co.uk/dna"
    xmlns:doc="http://www.bbc.co.uk/dna/documentation"
    exclude-result-prefixes="doc dna"
    extension-element-prefixes="dna msxsl"
    >
    
    <doc:documentation>
        <doc:purpose>
            Exslt extension to convert a string into an XML fragment
        </doc:purpose>
        <doc:context>
            
        </doc:context>
        <doc:notes>
            Its a little evil writing a function in javascript...
            
            Also, xmlDocument requires the fragment to be valid xml, e.g.
            a root node with one or more child nodes. Therefore, 
            library_stringToXml will always return the nodes wrapped in
            a stringToXml node.
            
            Should this be changed to 'result' instead?
        </doc:notes>
    </doc:documentation>
    
    <msxsl:script language="JScript" implements-prefix="dna">
        <![CDATA[
		function stringToXml(xmlFragment)
		{
			var xmlDocument = new ActiveXObject("MSXML2.DOMDocument.4.0");

			xmlDocument.async = false;
			xmlDocument.loadXML(xmlFragment);

			return xmlDocument;
		}
	]]>
    </msxsl:script>
    
    <xsl:template name="library_stringToXml">
        <xsl:param name="text" />
        <xsl:copy-of select="dna:stringToXml(concat('&lt;stringToXml>', string($text), '&lt;/stringToXml>'))"/>
    </xsl:template>
    
</xsl:stylesheet>