<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns="http://www.w3.org/1999/xhtml"
    version="1.0" 
    xmlns:doc="http://www.bbc.co.uk/dna/documentation"  
    exclude-result-prefixes="doc">


    <doc:documentation>
        <doc:purpose>
            Page layout for an article search page
        </doc:purpose>
        <doc:context>
            Applied by the kick off file  (e.g. /html.xsl, /rss.xsl etc)
        </doc:context>
        <doc:notes>
            
        </doc:notes>
    </doc:documentation>
    
    <xsl:template match="/H2G2[@TYPE='ARTICLESEARCH']" mode="page">        
      <xsl:variable name="s_mode" select="/H2G2/PARAMS/PARAM[NAME='s_mode']/VALUE"/>
      <xsl:variable name="s_view_mode" select="/H2G2/PARAMS/PARAM[NAME='s_view_mode']/VALUE"/>
        <div class="articlesearch">
          
          <xsl:choose>
            <xsl:when test="$s_mode = 'advanced'">
              <xsl:call-template name="library_header_h3">
                  <xsl:with-param name="text">Advanced search</xsl:with-param>
              </xsl:call-template>
              <xsl:apply-templates select="." mode="input_article_search_advanced"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:call-template name="library_header_h3">
                  <xsl:with-param name="text">Search</xsl:with-param>
              </xsl:call-template>
            </xsl:otherwise>
          </xsl:choose>
            <!--results -->
            <xsl:apply-templates select="ARTICLESEARCH" mode="object_articlesearch" />    
        </div>
        
    </xsl:template>

</xsl:stylesheet>