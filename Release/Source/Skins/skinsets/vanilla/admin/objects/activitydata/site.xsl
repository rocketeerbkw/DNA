<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">
    <xsl:template match="SITE" mode="library_activitydata" >
      <xsl:variable name="modsiteid" select="@ID" />
      <a href="/dna/{/H2G2/SITE-LIST/SITE[@ID = $modsiteid]/NAME}/" target="_blank">
        <xsl:value-of select="/H2G2/SITE-LIST/SITE[@ID = $modsiteid]/DESCRIPTION"/>
      </a>
    </xsl:template>
</xsl:stylesheet>