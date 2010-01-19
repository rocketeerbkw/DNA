<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:doc="http://www.bbc.co.uk/dna/documentation" exclude-result-prefixes="msxsl doc">
  <xsl:include href="includes.xsl"/>
  
  <xsl:output
    method="html"
    version="4.0"
    omit-xml-declaration="yes"
    standalone="yes"
    indent="yes"
    encoding="ISO8859-1"
    doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"
    doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"
  />
  <xsl:template match="H2G2">
      <xsl:comment>#set var="page.title" value="<xsl:apply-templates select="." mode="head_title"/>"</xsl:comment>
    
 
      <xsl:comment>#include virtual="/discuss/include/header.sssi"</xsl:comment>


<!-- 
        <ul>
          <li><a href="Announcements">Article Page</a></li>
          <li><a href="F44158?thread=63772">Thread</a></li>
          <li><a href="U284">User page</a></li>
          <li><a href="C834">Catergory</a></li>
        </ul>
   -->
        
        <!-- Output the HTML layout for this page -->
        <xsl:apply-templates select="." mode="page"/>


      <xsl:comment>#include virtual="/discuss/include/footer.sssi"</xsl:comment>




  </xsl:template>
</xsl:stylesheet>
