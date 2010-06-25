<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
	xmlns="http://www.w3.org/1999/xhtml" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	version="1.0" 
	xmlns:msxsl="urn:schemas-microsoft-com:xslt"
	xmlns:doc="http://www.bbc.co.uk/dna/documentation"
	xmlns:dt="urn:schemas-microsoft-com:datatypes" 
	exclude-result-prefixes="msxsl doc dt">
	

    
    <xsl:output
      method="html"
      version="4.0"
      omit-xml-declaration="yes"
      standalone="yes"
      indent="yes"
      encoding="UTF-8"
      doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"
      doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"
    />
    
 <xsl:include href="../../vanilla/boards_v2/output.xsl" />

	</xsl:stylesheet>
