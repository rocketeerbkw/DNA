<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">

    <doc:documentation>
        <doc:purpose>
            Page layout for Messageboard Admin page
        </doc:purpose>
        <doc:context>
            Applied by the kick off file  (e.g. /html.xsl, /rss.xsl etc)
        </doc:context>
        <doc:notes>
            
        </doc:notes>
    </doc:documentation>
    
    <xsl:template match="/H2G2[@TYPE = 'FRONTPAGE-LAYOUT']" mode="page">        
      <div class="vanilla-admin">
        <h2>Vanilla messageboard skins</h2>
        <xsl:apply-templates select="SITECONFIG" mode="vanilla"/>
      	<div class="right">
      		<div class="buttonThreeD" >
	      		<a href="{$root}messageboardadmin">Back to Message Board Admin</a>
	      	</div>
      	</div>
      </div>
    </xsl:template>
    
    <xsl:template match="SITECONFIG" mode="vanilla">
      <p>The following are new settings for Vanilla messageboards. These values should be supplied to the DNA production team. 
      	If you wish to amend any of these values, please email <a href="mailto:bbccommunities@bbc.co.uk?Subject=Vanilla%20Skins:%20{BOARDNAME}%20({BOARDSSOLINK})">DNA-Host Support</a> with your requirements.</p>
      <table border="0" summary="Assets required by the Vanilla messageboard skins" class="vanilla-assets">
          <tr>
            <th>
              Barlesque header colour
              <p class="info">Sets the colour of the navigation buttons in the Barlesque header - will be default blue if not set. </p>
              <p class="info">Choose your colour from the Barlesque <a href="http://www.bbc.co.uk/includes/blq/include/help/display_customisation/test_explore_colour.shtml" target="_blank">guidelines</a>.</p>
            </th>
            <td>
              <xsl:choose>
                <xsl:when test="BLQ-NAV-COLOR and BLQ-NAV-COLOR != ''"><xsl:value-of select="BLQ-NAV-COLOR"/></xsl:when>
                <xsl:otherwise><em>Not yet set</em></xsl:otherwise>
              </xsl:choose>
            </td>
            <!--<td>
              <a href="{$root}siteconfigEditor">Edit / Set</a>
            </td>-->
          </tr>
          <tr>
            <th>
              Barlesque footer colour
              <p class="info">Sets the colour of the Barlesque footer - will be default grey if not set.</p>
              <p class="info">Choose your colour from the Barlesque <a href="http://www.bbc.co.uk/includes/blq/include/help/display_customisation/test_footer_colour.shtml" target="_blank">guidelines</a>.</p>
            </th>
            <td>
              <xsl:choose>
                <xsl:when test="BLQ-FOOTER-COLOR and BLQ-FOOTER-COLOR != ''"><xsl:value-of select="BLQ-FOOTER-COLOR"/></xsl:when>
                <xsl:otherwise><em>Default</em></xsl:otherwise>
              </xsl:choose>
            </td>
            <!--<td>
              <a href="{$root}siteconfigEditor">Edit / Set</a>
            </td>-->
          </tr>
          <tr>
            <th>
              Messageboard parent site
              <p class="info">URL to the parent site this messageboard belongs to, if any. This is not mandatory.</p>
            </th>
            <td>
              <xsl:choose>
                <xsl:when test="SITEHOME and SITEHOME != ''">
                  <a href="{SITEHOME}" target="_blank">
                    <xsl:value-of select="SITEHOME"/>
                  </a>
                </xsl:when>
                <xsl:otherwise><em>Not yet set</em></xsl:otherwise>
              </xsl:choose>
            </td>
            <!--<td>
               <a href="{$root}siteconfigEditor">Edit / Set</a>
            </td>-->
          </tr>
        </table>
    </xsl:template>
    
    <xsl:template match="/H2G2[@TYPE = 'FRONTPAGE-LAYOUT']" mode="breadcrumbs">
      
    </xsl:template>

</xsl:stylesheet>