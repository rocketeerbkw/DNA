<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">
    
  <xsl:template match="TYPE" mode="library_activitydata" >
      <xsl:choose>
        <xsl:when test="text() = 'NewUserToSite'">
          <img src="/dnaimages/dna_messageboard/img/icons/new_user.png" width="30" height="30" alt="new user" />
        </xsl:when>
        <xsl:when test="text() = 'ModeratePostFailed'">
          <img src="/dnaimages/dna_messageboard/img/icons/post_FAILED.png" width="30" height="33" alt="post failed" />
        </xsl:when>
        <xsl:when test="text() = 'ModerateArticleFailed'">
          <img src="/dnaimages/dna_messageboard/img/icons/article_FAILED.png" width="30" height="30" alt="article failed" />
        </xsl:when>
        <xsl:when test="text() = 'ComplaintPost'">
          <img src="/dnaimages/dna_messageboard/img/icons/post_ALERT.png" width="30" height="30" alt="post alert" />
        </xsl:when>
        <xsl:when test="text() = 'ComplaintArticle'">
          <img src="/dnaimages/dna_messageboard/img/icons/article_ALERT.png" width="30" height="30" alt="article alert"  />
        </xsl:when>
        <xsl:when test="text() = 'ModeratePostReferred'">
          <img src="/dnaimages/dna_messageboard/img/icons/post_REFERRED.png" width="30" height="30" alt="post referred" />
        </xsl:when>
        <xsl:when test="text() = 'ModerateArticleReferred'">
          <img src="/dnaimages/dna_messageboard/img/icons/article_REFERRED.png" width="30" height="30" alt="article referred"  />
        </xsl:when>
        <xsl:when test="text() = 'UserModeratedPremod'">
          <img src="/dnaimages/dna_messageboard/img/icons/pre-mod_user.png" width="30" height="30" alt="pre-moderated user"  />
        </xsl:when>
        <xsl:when test="text() = 'UserModeratedPostMod'">
          <img src="/dnaimages/dna_messageboard/img/icons/post-mod_user.png" width="30" height="30" alt="post-moderated user" />
        </xsl:when>
        <xsl:when test="text() = 'UserModeratedBanned'">
          <img src="/dnaimages/dna_messageboard/img/icons/banned_user.png" width="30" height="30" alt="banned user" />
        </xsl:when>
        <xsl:when test="text() = 'UserModeratedDeactivated'">
          <img src="/dnaimages/dna_messageboard/img/icons/deactivated_user.png" width="30" height="30" alt="deactivated user" />
        </xsl:when>        
        
        <xsl:otherwise>
          <xsl:value-of select="text()"/>
        </xsl:otherwise>
        
      </xsl:choose>
      
    </xsl:template>
</xsl:stylesheet>