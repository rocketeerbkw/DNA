<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:msxsl="urn:schemas-microsoft-com:xslt" 
  xmlns:doc="http://www.bbc.co.uk/dna/documentation" 
  version="1.0" 
  exclude-result-prefixes="msxsl doc">
  
  <xsl:include href="includes.xsl"/>
  
  <xsl:output method="html" 
    version="4.0" 
    omit-xml-declaration="yes" 
    standalone="yes" 
    indent="yes" 
    encoding="ISO8859-1" 
    doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" 
    doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"/>
	
	<xsl:variable name="abc" select="'abcdefghijklmnopqrstuvwxyz'"/>
	<xsl:variable name="ABC" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>
	
	<xsl:variable name="smileys">
		<xsl:choose>
			<xsl:when test="/H2G2/EMOTICONLOCATION = 1">
				<xsl:value-of select="concat($serverPath, 'images/emoticons/f_')"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$configuration/assetPaths/smileys"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<xsl:variable name="serverPath">
		<xsl:choose>
			<xsl:when test="contains(/H2G2/SERVERNAME, 'OPS')">
				<xsl:value-of select="/H2G2/SITECONFIG/PATHDEV"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="/H2G2/SITECONFIG/PATHLIVE"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
    
  <xsl:template match="H2G2">
    <html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en-GB" lang="en-GB">
      <head profile="http://dublincore.org/documents/dcq-html/">
      	<title>
      		<xsl:text>BBC - </xsl:text>
      		<xsl:value-of select="SITE/NAME"/>
      		<xsl:text> </xsl:text>
        	<xsl:apply-templates select="." mode="head_title_page"/>
        </title>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="description" content=""/>
        <meta name="keywords" content=""/>
        <link rel="schema.dcterms" href="http://purl.org/dc/terms/"/>
        <meta name="DCTERMS.created" content="2006-09-15T12:00:00Z"/>
        <meta name="DCTERMS.modified" content="2006-09-15T12:35:00Z"/>
        <meta name="Author" content="{$configuration/general/skinAuthor}"/>
      	<xsl:choose>
      		<xsl:when test="SITE/IDENTITYSIGNIN = 1">
      			<xsl:comment>#set var="blq_identity" value="on"</xsl:comment>
      		</xsl:when>
      		<xsl:otherwise>
      			<xsl:comment>#set var="blq_identity" value="off"</xsl:comment>
      		</xsl:otherwise>
      	</xsl:choose>
      	
      	<xsl:choose>
      		<xsl:when test="SITECONFIG/BLQ-NAV-COLOR">
      			<xsl:comment>#set var="blq_nav_color" value="<xsl:value-of select="SITECONFIG/BLQ-NAV-COLOR"/>"</xsl:comment>
      		</xsl:when>
      		<xsl:otherwise>
      			<xsl:comment>#set var="blq_nav_color" value="blue"</xsl:comment>
      		</xsl:otherwise>
      	</xsl:choose>
      	
      	<xsl:if test="SITECONFIG/BLQ-FOOTER-COLOR">
      		<xsl:comment>#set var="blq_footer_color" value="<xsl:value-of select="SITECONFIG/BLQ-FOOTER-COLOR"/>"</xsl:comment>
      	</xsl:if>
      	
      	<xsl:if test="SITE/SITEOPTIONS/SITEOPTION[NAME = 'IsKidsSite']/VALUE = 1">
      		<xsl:comment>#set var="blq_variant" value="cbbc" </xsl:comment>
      		<xsl:comment>#set var="blq_search_scope" value="cbbc" </xsl:comment>
      	</xsl:if>
      	
      	<xsl:comment>#include virtual="/includes/blq/include/blq_head.sssi"</xsl:comment>
      	
        <script type="text/javascript" src="http://www.bbc.co.uk/glow/gloader.js"/>
      	<script type="text/javascript" src="/dnaimages/javascript/DNA.js"></script>
      </head>
      <body>
        <xsl:attribute name="id">
          <xsl:apply-templates select="/H2G2/@TYPE" mode="library_string_stringtolower"/>
        </xsl:attribute>
        <xsl:comment>#include virtual="/includes/blq/include/blq_body_first.sssi"</xsl:comment>
        <div id="blq-local-nav">
        
        </div>
        <div id="blq-content">
        	<p id="membership">
        		<xsl:if test="SITE/IDENTITYSIGNIN != 1">
        			<xsl:apply-templates select="VIEWING-USER" mode="library_memberservice_status" />
        		</xsl:if>
        	</p>
          <!-- Output the HTML layout for this page -->
          <xsl:apply-templates select="." mode="page"/>
        </div>
        <xsl:comment>#include virtual="/includes/blq/include/blq_body_last.sssi"</xsl:comment>
      </body>
    </html>
  </xsl:template>
</xsl:stylesheet>
