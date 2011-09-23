<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">
    <xsl:template match="POST" mode="library_activitydata" >
      <xsl:variable name="modsiteid" select="../../SITEID" />
          <a href="/dna/moderation/boards-admin/moderationhistory?postid={/H2G2/SITE-LIST/SITE[@ID = $modsiteid]/NAME}/NF{@FORUMID}?thread={@THREADID}&amp;post={@POSTID}#p{@POSTID}" target="_blank">
            <xsl:value-of select="text()"/>
          </a>
    </xsl:template>
</xsl:stylesheet>