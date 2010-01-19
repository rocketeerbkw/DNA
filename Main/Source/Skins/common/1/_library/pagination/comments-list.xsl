<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">

  <doc:documentation>
    <doc:purpose>
      pagination
    </doc:purpose>
    <doc:context>
      Applied by _common/_library/GuideML.xsl
    </doc:context>
    <doc:notes>
      working with the show, to and from, calculate the querystring

      this desperately needs to be split into its component parts correctly:

      logic layer
      - work out the FORUMTHREAD type, its skip, step or from and to values and compute them into
      a collection of useful parameters for the skin.

      site layer
      - take params and work into relelvant links etc

    </doc:notes>
  </doc:documentation>

  <xsl:template match="COMMENTS-LIST" mode="library_pagination_comments-list">
    <ul class="pagination">
      <li class="previous">
        <xsl:choose>
          <xsl:when test="@SKIP > 0">
            <a href="?userid={USER/USERID}&amp;skip={@SKIP - /H2G2/SITE/SITEOPTIONS/SITEOPTION[SECTION='CommentForum' and NAME='DefaultShow']/VALUE}">
              <span class="arrow">
                <xsl:text disable-output-escaping="yes"><![CDATA[&laquo;]]></xsl:text>
              </span>
              <xsl:text>Newer</xsl:text>
            </a>
          </xsl:when>
          <xsl:otherwise>
            <span>
              <span class="arrow">
                <xsl:text disable-output-escaping="yes"><![CDATA[&laquo;]]></xsl:text>
              </span>
              <xsl:text>Newer</xsl:text>
            </span>
          </xsl:otherwise>
        </xsl:choose>
      </li>
      <li class="next">
        <xsl:choose>
          <xsl:when test="@MORE != 0">
            <a href="?userid={USER/USERID}&amp;skip={@SKIP + /H2G2/SITE/SITEOPTIONS/SITEOPTION[SECTION='CommentForum' and NAME='DefaultShow']/VALUE}">
              <xsl:text>Older</xsl:text>
              <span class="arrow">
                <xsl:text disable-output-escaping="yes"><![CDATA[&raquo;]]></xsl:text>
              </span>
            </a>
          </xsl:when>
          <xsl:otherwise>
            <span>
              <xsl:text>Older</xsl:text>
              <span class="arrow">
                <xsl:text disable-output-escaping="yes"><![CDATA[&raquo;]]></xsl:text>
              </span>
            </span>
          </xsl:otherwise>
        </xsl:choose>
      </li>
    </ul>
  </xsl:template>
</xsl:stylesheet>