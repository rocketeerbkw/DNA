<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	version="1.0" 
	xmlns:doc="http://www.bbc.co.uk/dna/documentation" 
	xmlns="http://www.w3.org/1999/xhtml" 
	exclude-result-prefixes="doc">
	
	<doc:documentation>
		<doc:purpose>
			
		</doc:purpose>
		<doc:context>
			
		</doc:context>
		<doc:notes>
			
		</doc:notes>
	</doc:documentation>

  <xsl:template match="H2G2[@TYPE = 'USERCONTRIBUTIONS']" mode="page">

    <div class="dna-fl dna-main-left">
      <h3>User Contributions</h3>
      <p>Below is a list of a users contributions across DNA services</p>
      <form method="get" action="usercontributions" class="dna-fl">
        <fieldset>
          <p>
          User Id: <input type="text" name="s_userid" value="{/H2G2/CONTRIBUTIONS/@USERID}"/> <a href="userlist">Find more users</a>
          </p>
          <p>
            Start Date: <input type="text" name="s_startdate" value=""/> (Format: YYYY-MM-DD)
          </p>
          <p>
            <input type="submit" value ="Get Posts"/>
          </p>
        </fieldset>
      </form>
    </div>
    <div class="dna-fl dna-box">
      <div id="blq-local-nav" class="nav blq-clearfix">

        <ul>
          <li>
            <xsl:if test="not(PARAMS/PARAM[NAME = 's_type']/VALUE )">
              <xsl:attribute name="class">selected</xsl:attribute>
            </xsl:if>
            <a href="{$root}/usercontributions?{$dashboardsiteuser}">
              All <xsl:apply-templates select="MODERATORHOME/MODERATOR/ACTIONITEMS" mode="objects_moderator_actionitemtotal"/>
            </a>
          </li>
          <li>
            <xsl:if test="PARAMS/PARAM[NAME = 's_type']/VALUE = '1'">
              <xsl:attribute name="class">selected</xsl:attribute>
            </xsl:if>
            <a href="{$root}/usercontributions?s_type=1{$dashboardsiteuser}">
              Blogs <xsl:apply-templates select="MODERATORHOME/MODERATOR/ACTIONITEMS/ACTIONITEM[TYPE = 'Blog']" mode="objects_moderator_actionitemtotal"/>
            </a>
          </li>
          <li>
            <xsl:if test="PARAMS/PARAM[NAME = 's_type']/VALUE = '2'">
              <xsl:attribute name="class">selected</xsl:attribute>
            </xsl:if>
            <a href="{$root}/usercontributions?s_type=2{$dashboardsiteuser}">
              Boards <xsl:apply-templates select="MODERATORHOME/MODERATOR/ACTIONITEMS/ACTIONITEM[TYPE = 'Messageboard']" />
            </a>
          </li>
          <li>
            <xsl:if test="PARAMS/PARAM[NAME = 's_type']/VALUE = '3'">
              <xsl:attribute name="class">selected</xsl:attribute>
            </xsl:if>
            <a href="{$root}/usercontributions?s_type=3{$dashboardsiteuser}">
              Communities <xsl:apply-templates select="MODERATORHOME/MODERATOR/ACTIONITEMS/ACTIONITEM[TYPE = 'Community']" />
            </a>
          </li>
          <li>
            <xsl:if test="PARAMS/PARAM[NAME = 's_type']/VALUE = '4'">
              <xsl:attribute name="class">selected</xsl:attribute>
            </xsl:if>
            <a href="{$root}/usercontributions?s_type=4{$dashboardsiteuser}">
              Stories <xsl:apply-templates select="MODERATORHOME/MODERATOR/ACTIONITEMS/ACTIONITEM[TYPE = 'EmbeddedComments']" />
            </a>
          </li>
        </ul>

      </div>

    <div class="dna-main dna-main-full">
      
      <xsl:apply-templates select="CONTRIBUTIONS" mode="library_pagination_forumthreadposts" />
        
      <xsl:apply-templates mode="object_post_generic" select="/H2G2/CONTRIBUTIONS/CONTRIBUTIONITEMS/CONTRIBUTIONITEM"></xsl:apply-templates>
      
      <xsl:apply-templates select="CONTRIBUTIONS" mode="library_pagination_forumthreadposts" />
    </div>

    </div>
  </xsl:template>
	
</xsl:stylesheet>
