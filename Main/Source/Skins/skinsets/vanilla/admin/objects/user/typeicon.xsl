<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">
    
  <xsl:template match="TYPE | USERSTATUSDESCRIPTION | STATUS" mode="objects_user_typeicon" >
      <xsl:choose>
        <xsl:when test="text() = 'NewUserToSite'">
          <img src="/dnaimages/dna_messageboard/img/icons/new_user.png" width="30" height="30" alt="new user" title="new user" />
        </xsl:when>
        <xsl:when test="text() = 'ModeratePostFailed'">
          <img src="/dnaimages/dna_messageboard/img/icons/post_FAILED.png" width="30" height="30" alt="post failed" title="post failed" />
        </xsl:when>
        <xsl:when test="text() = 'ModerateArticleFailed'">
          <img src="/dnaimages/dna_messageboard/img/icons/article_FAILED.png" width="30" height="30" alt="article failed" title="article failed"/>
        </xsl:when>
        <xsl:when test="text() = 'ComplaintPost'">
          <img src="/dnaimages/dna_messageboard/img/icons/post_ALERT.png" width="30" height="30" alt="post alert" title="post alert" />
        </xsl:when>
        <xsl:when test="text() = 'ComplaintArticle'">
          <img src="/dnaimages/dna_messageboard/img/icons/article_ALERT.png" width="30" height="30" alt="article alert" title="article alert"  />
        </xsl:when>
        <xsl:when test="text() = 'ModeratePostReferred'">
          <img src="/dnaimages/dna_messageboard/img/icons/post_REFERRED.png" width="30" height="30" alt="post referred" title="post referred" />
        </xsl:when>
        <xsl:when test="text() = 'ModerateArticleReferred'">
          <img src="/dnaimages/dna_messageboard/img/icons/article_REFERRED.png" width="30" height="30" alt="article referred" title="article referred"  />
        </xsl:when>
        <xsl:when test="text() = 'UserModeratedPremod' or (text() = 'Premoderate' and parent::USERACCOUNT/ACTIVE = '1') or @STATUSID = '1'">
          <img src="/dnaimages/dna_messageboard/img/icons/pre-mod_user.png" width="30" height="30" alt="pre-moderated user" title="pre-moderated user"  />
        </xsl:when>
        <xsl:when test="text() = 'UserModeratedPostMod' or (text() = 'Postmoderate' and parent::USERACCOUNT/ACTIVE = '1') or @STATUSID = '2'">
          <img src="/dnaimages/dna_messageboard/img/icons/post-mod_user.png" width="30" height="30" alt="post-moderated user" title="post-moderated user" />
        </xsl:when>
        <xsl:when test="text() = 'UserModeratedBanned' or (text() = 'Banned' and parent::USERACCOUNT/ACTIVE = '1') or @STATUSID = '4'">
          <img src="/dnaimages/dna_messageboard/img/icons/banned_user.png" width="30" height="30" alt="banned user" title="banned user" />
        </xsl:when>
        <xsl:when test="text() = 'UserModeratedDeactivated'">
          <img src="/dnaimages/dna_messageboard/img/icons/deactivated_user.png" width="30" height="30" alt="deactivated user" title="deactivated user" />
        </xsl:when>       
        <xsl:when test="text() = 'Standard' and parent::USERACCOUNT/ACTIVE = '1'">
          <img src="/dnaimages/dna_messageboard/img/icons/standard_user.png" width="30" height="30" alt="standard user" title="standard user" />
        </xsl:when>  
        
        <xsl:otherwise>
          <xsl:if test="/H2G2/@TYPE != 'USERLIST'"><xsl:value-of select="text()"/></xsl:if>
          <xsl:if test="(/H2G2/@TYPE = 'USERLIST' and parent::USERACCOUNT/ACTIVE = '0') or parent::USER/ACTIVE = '1'"><img src="/dnaimages/dna_messageboard/img/icons/deactivated_user.png" width="30" height="30" alt="deactivated user" title="deactivated user" /></xsl:if>
        </xsl:otherwise>
        
      </xsl:choose>
      
    </xsl:template>
</xsl:stylesheet>