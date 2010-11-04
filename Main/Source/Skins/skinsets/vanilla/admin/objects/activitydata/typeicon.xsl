<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">
    
  <xsl:template match="TYPE" mode="library_activitydata" >
      <xsl:choose>
        <xsl:when test="text() = 'NewUserToSite'">
          <img src="/dnaimages/boards/images/emoticons/f_cracker.gif" />
        </xsl:when>
        <xsl:when test="text() = 'ModeratePostFailed'">
          <img src="/dnaimages/boards/images/emoticons/f_sadface.gif" />
        </xsl:when>
        <xsl:when test="text() = 'ModerateArticleFailed'">
          <img src="/dnaimages/boards/images/emoticons/f_sadface.gif" />
        </xsl:when>
        <xsl:when test="text() = 'ComplaintPost'">
          <img src="/dnaimages/boards/images/emoticons/f_yikes.gif" width="42" height="24" />
        </xsl:when>
        <xsl:when test="text() = 'ComplaintArticle'">
          <img src="/dnaimages/boards/images/emoticons/f_yikes.gif" width="42" height="24" />
        </xsl:when>
        <xsl:when test="text() = 'ModeratePostReferred'">
          <img src="/dnaimages/boards/images/emoticons/f_doh.gif" width="42" height="24" />
        </xsl:when>
        <xsl:when test="text() = 'ModerateArticleReferred'">
          <img src="/dnaimages/boards/images/emoticons/f_doh.gif" width="42" height="24" />
        </xsl:when>
        <xsl:when test="text() = 'UserModeratedPremod'">
          <img src="/dnaimages/boards/images/emoticons/f_grr.gif" />
        </xsl:when>
        <xsl:when test="text() = 'UserModeratedPostMod'">
          <img src="/dnaimages/boards/images/emoticons/f_steam.gif" />
        </xsl:when>
        <xsl:when test="text() = 'UserModeratedBanned'">
          <img src="/dnaimages/boards/images/emoticons/f_devil.gif" />
        </xsl:when>
        
        <xsl:otherwise>
          <xsl:value-of select="text()"/>
        </xsl:otherwise>
        
      </xsl:choose>
      
    </xsl:template>
</xsl:stylesheet>