<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">
    
  <xsl:template match="SELECTEDTYPES" mode="library_activitydata_typelist" >
    <ul class="dna-dashboard-links blq-clearfix">
      <li>
        <input type="checkbox" name="s_eventtype" id="all" value="0">
          <xsl:if test="TYPEID[text() = 0] or count(TYPEID) = 0">
            <xsl:attribute name="checked">
              <xsl:text>checked</xsl:text>
            </xsl:attribute>
          </xsl:if>
        </input>
       All
      </li>
      <li>
        <input type="checkbox" name="s_eventtype" value="1">
          <xsl:if test="TYPEID[text() = 1]">
            <xsl:attribute name="checked">
              <xsl:text>checked</xsl:text>
            </xsl:attribute>
          </xsl:if>
        </input>
        Failed Posts
      </li>
      <li>
        <input type="checkbox" name="s_eventtype" value="2">
          <xsl:if test="TYPEID[text() = 2]">
            <xsl:attribute name="checked">
              <xsl:text>checked</xsl:text>
            </xsl:attribute>
          </xsl:if>
        </input>
        Referred Posts
      </li>
      <li>
        <input type="checkbox" name="s_eventtype" value="3">
          <xsl:if test="TYPEID[text() = 3]">
            <xsl:attribute name="checked">
              <xsl:text>checked</xsl:text>
            </xsl:attribute>
          </xsl:if>
        </input>
        Failed Articles
      </li>
      <li>
        <input type="checkbox" name="s_eventtype" value="4">
          <xsl:if test="TYPEID[text() = 4]">
            <xsl:attribute name="checked">
              <xsl:text>checked</xsl:text>
            </xsl:attribute>
          </xsl:if>
        </input>
        Referred Articles
      </li>
      <li>
        <input type="checkbox" name="s_eventtype" value="7">
          <xsl:if test="TYPEID[text() = 7]">
            <xsl:attribute name="checked">
              <xsl:text>checked</xsl:text>
            </xsl:attribute>
          </xsl:if>
        </input>
        Alerts on posts
      </li>
      <li>
        <input type="checkbox" name="s_eventtype" value="8">
          <xsl:if test="TYPEID[text() = 8]">
            <xsl:attribute name="checked">
              <xsl:text>checked</xsl:text>
            </xsl:attribute>
          </xsl:if>
        </input>
        Alerts on articles
      </li>
      <li>
        <input type="checkbox" name="s_eventtype" value="10">
          <xsl:if test="TYPEID[text() = 10]">
            <xsl:attribute name="checked">
              <xsl:text>checked</xsl:text>
            </xsl:attribute>
          </xsl:if>
        </input>
        Pre-mod users
      </li>
      <li>
        <input type="checkbox" name="s_eventtype" value="11">
          <xsl:if test="TYPEID[text() = 11]">
            <xsl:attribute name="checked">
              <xsl:text>checked</xsl:text>
            </xsl:attribute>
          </xsl:if>
        </input>
        Post-mod users
      </li>
      <li>
        <input type="checkbox" name="s_eventtype" value="12">
          <xsl:if test="TYPEID[text() = 12]">
            <xsl:attribute name="checked">
              <xsl:text>checked</xsl:text>
            </xsl:attribute>
          </xsl:if>
        </input>
        Banned users
      </li>
      <li>
        <input type="checkbox" name="s_eventtype" value="13">
          <xsl:if test="TYPEID[text() = 13]">
            <xsl:attribute name="checked">
              <xsl:text>checked</xsl:text>
            </xsl:attribute>
          </xsl:if>
        </input>
        Deactivated users
      </li>
      <li>
        <input type="checkbox" name="s_eventtype" value="14">
          <xsl:if test="TYPEID[text() = 14]">
            <xsl:attribute name="checked">
              <xsl:text>checked</xsl:text>
            </xsl:attribute>
          </xsl:if>
        </input>
        New users
      </li>
    </ul>
      
    </xsl:template>
</xsl:stylesheet>