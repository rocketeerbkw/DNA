<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">


    <doc:documentation>
        <doc:purpose>
            Page layout for an article page
        </doc:purpose>
        <doc:context>
            Applied by the kick off file  (e.g. /html.xsl, /rss.xsl etc)
        </doc:context>
        <doc:notes>
            This defines the article page layout, not to be confused with the article object...
        </doc:notes>
    </doc:documentation>
    
    <xsl:template match="/H2G2[CURRENTSITE = 0]" mode="page" priority="1">        
        <style tyle="text/css">
          .servertoobusy p {
            margin: 10px 0 10px 0;
          }
          .servertoobusy ul {
            margin-top: 20px;
            margin-bottom: 20px;
          }
          .servertoobusy li.sitelink {
            float: left;
            margin-right: 10px;
            width: 15%;
          }
          #blq-content .servertoobusy li.sitelink a {
            border-bottom: 0;
          }
          .servertoobusy li.sitelink img {
            border: 0;
          }
        </style>
        <div class="servertoobusy blq-typ" style="margin-top: 20px; margin-bottom: 20px;">           
            <xsl:call-template name="library_header_h1">
                <xsl:with-param name="text">There has been a problem</xsl:with-param>
            </xsl:call-template>
            <p>We can't find the page you requested. Try checking the address for spelling mistakes or extra spaces.</p>
            <xsl:call-template name="library_header_h3">
                <xsl:with-param name="text">Were you looking for...?</xsl:with-param>
            </xsl:call-template>
            <ul>
              <li class="sitelink">
                <a href="/dna/h2g2">
                  <img src="/h2g2/skins/brunel/images/h2g2_logo.gif" alt="H2G2" title="H2G2" width="107" height="39"/>
                </a>
              </li>
              <li class="sitelink">
                <a href="/dna/memoryshare">
                  <img src="/memoryshare/images/logos/logo1_memoryshare.gif" title="BBC Memoryshare" alt="BBC Memoryshare" width="126" height="23"/>
                </a>
              </li>
              <li class="sitelink">
                <a href="/dna/filmnetwork">
                  <img src="/dnaimages/filmnetwork/bbcfilmnetwork_wht_medium.gif" alt="BBC Film Network" title="BBC Film Network" width="140" height="49"/>
                </a>
              </li>
              <li class="sitelink">
                <a href="/dna/606">
                  <img src="/dnaimages/606/606_logo_nborder.jpg" alt="BBC 606" title="BBC 606" height="40" width="140"/>
                </a>
              </li>
              <li class="sitelink">
                <a href="/messageboards/newguide/">
                  <img src="/dnaimages/messageboards_logo.gif" alt="BBC DNA Messageboards" title="BBC DNA Messageboards" width="291" height="40"/>
                </a>
              </li>
            </ul>
            <div style="clear: both;"><xsl:comment>clear</xsl:comment></div>
            <p>Alternatively, you can go to <a href="http://www.bbc.co.uk">the BBC Homepage</a> or view a <a href="/a-z">full list of BBC sites</a>.</p>
            
        </div>
        
    </xsl:template>
    
    

</xsl:stylesheet>