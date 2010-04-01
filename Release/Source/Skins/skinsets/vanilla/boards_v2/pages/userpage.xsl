<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"  xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">
    
    <doc:documentation>
        <doc:purpose>
            HTML Layout for pages of type 'userpage'
        </doc:purpose>
        <doc:context>
            Applied by the kick off file  (e.g. /html.xsl, /rss.xsl etc)
        </doc:context>
        <doc:notes>
            
        </doc:notes>
    </doc:documentation>
    
    <xsl:template match="/H2G2[@TYPE = 'USERPAGE']" mode="page"> 
      <div>
        <xsl:call-template name="library_header_h3">
          <xsl:with-param name="text">
            <xsl:text>Personal Space</xsl:text>
          </xsl:with-param>
        </xsl:call-template>
      </div>
        <xsl:call-template name="library_userstate_editor">
            <xsl:with-param name="loggedin">
                <p>As an editor, you can <a href="{$root}/InspectUser?userid={PAGE-OWNER/USER/USERID}">inspect this user</a>.</p>
            </xsl:with-param>
            <xsl:with-param name="loggedout">
                <p>
                    The BBC message boards do not support the Personal Space feature.
                </p>
                <p>
                  You can instead <a href="{$root}/MP{PAGE-OWNER/USER/USERID}">view a list of this user's posts</a>.
                </p>
            </xsl:with-param>
        </xsl:call-template>
    
    </xsl:template>
    
    <xsl:template match="/H2G2[@TYPE = 'USERPAGE']" mode="breadcrumbs">

    </xsl:template>
    
</xsl:stylesheet>
