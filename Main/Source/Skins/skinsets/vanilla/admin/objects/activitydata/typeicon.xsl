<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">
    
  <xsl:template match="TYPE" mode="library_activitydata" >
      <xsl:choose>
        <xsl:when test="text() = 'NewUserToSite'">
          <img src="/dnaimages/dna_messageboard/img/icons/smiley.png" width="30" height="32" alt="new user" />
        </xsl:when>
        <xsl:when test="text() = 'ModeratePostFailed'">
          <img src="/dnaimages/dna_messageboard/img/icons/failed.png" width="30" height="33" alt="post failed" />
        </xsl:when>
        <xsl:when test="text() = 'ModerateArticleFailed'">
          <img src="/dnaimages/dna_messageboard/img/icons/failed.png" width="30" height="33" alt="article failed" />
        </xsl:when>
        <xsl:when test="text() = 'ComplaintPost'">
          <img src="/dnaimages/dna_messageboard/img/icons/alert_triangle.png" width="30" height="33" alt="alert" />
        </xsl:when>
        <xsl:when test="text() = 'ComplaintArticle'">
          <img src="/dnaimages/dna_messageboard/img/icons/alert_triangle.png" width="30" height="33" alt="alert"  />
        </xsl:when>
        <xsl:when test="text() = 'ModeratePostReferred'">
          <img src="/dnaimages/dna_messageboard/img/icons/help.png" width="30" height="31" alt="referred" />
        </xsl:when>
        <xsl:when test="text() = 'ModerateArticleReferred'">
          <img src="/dnaimages/dna_messageboard/img/icons/help.png" width="30" height="31" alt="referred"  />
        </xsl:when>
        <xsl:when test="text() = 'UserModeratedPremod'">
          <img src="/dnaimages/dna_messageboard/img/icons/cheeky_monkey.png" width="30" height="27" alt="cheeky monkey"  />
        </xsl:when>
        <xsl:when test="text() = 'UserModeratedPostMod'">
          <img src="/dnaimages/dna_messageboard/img/icons/cheeky_monkey.png" width="30" height="27" alt="cheeky monkey" />
        </xsl:when>
        <xsl:when test="text() = 'UserModeratedBanned'">
          <img src="/dnaimages/dna_messageboard/img/icons/devil.png" width="30" height="27" alt="banned" />
        </xsl:when>
        
        <xsl:otherwise>
          <xsl:value-of select="text()"/>
        </xsl:otherwise>
        
      </xsl:choose>
      
    </xsl:template>
</xsl:stylesheet>