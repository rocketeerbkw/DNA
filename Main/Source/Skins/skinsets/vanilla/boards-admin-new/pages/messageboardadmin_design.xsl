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
	
	<xsl:template match="H2G2[@TYPE = 'MBADMINDESIGN']" mode="page">

    <div class="dna-mb-intro">
      <h2>Messageboard Design</h2>
      <p>
        Below is a preview of your messageboard, indicating which areas you can edit. Once you are finished click the <strong>Save</strong> button. To cancel any changes you have made, click the <strong>Cancel</strong> button.
      </p>
    </div>

    <div class="dna-main dna-main-bg dna-main-pad blq-clearfix">

      <div class="dna-fl dna-main-full">
        
         <h3>Your messageboard</h3>

          <div class="dna-box-border">
            <h4 class="dna-off">Header</h4>
            <p>
              <xsl:choose>
                <xsl:when test="SITECONFIGPREVIEW/SITECONFIG/V2_BOARDS/HEADER_COLOUR">
                  <strong>Header colour chosen: </strong>
                  <xsl:value-of select="SITECONFIGPREVIEW/SITECONFIG/V2_BOARDS/HEADER_COLOUR"/>
                </xsl:when>
                <xsl:otherwise>
                  <strong>Header colour by default </strong> blue.</xsl:otherwise>
              </xsl:choose>
            </p>
            
            <p><a href="?s_mode=header#dna-preview-editheader" class="dna-link-overlay">+ Edit header colour</a></p>
          </div>

          <div class="dna-box-border">
            <h4 class="dna-off">Banner</h4>
            <xsl:choose>
              <xsl:when test="SITECONFIGPREVIEW/SITECONFIG/V2_BOARDS/BANNER_SSI">
                <p>
                  <strong>Banner included: </strong>
                  <xsl:value-of select="SITECONFIGPREVIEW/SITECONFIG/V2_BOARDS/BANNER_SSI"/>
                </p>
                <p>
                  <a href="?s_mode=banner#dna-preview-insertbanner" class="dna-link-overlay">+ Update banner</a>
                </p>
              </xsl:when>
              <xsl:otherwise>
                <p>
                  <a href="?s_mode=banner#dna-preview-insertbanner" class="dna-link-overlay">+ Insert your own banner (SSI)</a>
                </p>
              </xsl:otherwise>
            </xsl:choose>
          </div>

          <div class="dna-box-border">
            <h4 class="dna-off">Horizontal navigation</h4>
            <xsl:choose>
              <xsl:when test="SITECONFIGPREVIEW/SITECONFIG/V2_BOARDS/HORIZONTAL_NAV_SSI">
                <p>
                  <strong>Horizontal navigation included: </strong>
                  <xsl:value-of select="SITECONFIGPREVIEW/SITECONFIG/V2_BOARDS/HORIZONTAL_NAV_SSI"/>
                </p>
                <p>
                  <a href="?s_mode=topnav#dna-preview-addtopnav" class="dna-link-overlay">+ Update horizontal navigation</a>
                </p>
              </xsl:when>
              <xsl:otherwise>
                <p>
                  <a href="?s_mode=topnav#dna-preview-addtopnav" class="dna-link-overlay">+ Add top navigation (SSI)</a>
                </p>
              </xsl:otherwise>
            </xsl:choose>
          </div>


          <div id="dna-preview-content">
            <div id="dna-preview-left" class="dna-fl">
              
              <div class="dna-box-border">
                <h4 class="dna-off">Left navigation</h4>
                <xsl:choose>
                  <xsl:when test="SITECONFIGPREVIEW/SITECONFIG/V2_BOARDS/LEFT_NAV_SSI">
                    <p><strong>Left navigation included: </strong></p>
                    <ul class="dna-list-links"> 
                      <li><xsl:value-of select="SITECONFIGPREVIEW/SITECONFIG/V2_BOARDS/LEFT_NAV_SSI"/></li>
                    </ul>
                    
                    <p>
                      <a href="?s_mode=lnav#dna-preview-addnav" class="dna-link-overlay">+ Update navigation</a>
                    </p>
                  </xsl:when>
                  <xsl:otherwise>
                    <p>
                      <a href="?s_mode=lnav#dna-preview-addnav" class="dna-link-overlay">+ Add navigation (SSI)</a>
                    </p>
                  </xsl:otherwise>
                </xsl:choose>
              </div>
              
              <div class="dna-box">
                <h4 class="dna-off">Topic's list</h4>
                <xsl:if test="/H2G2/TOPIC_PAGE">
                  <ul class="dna-list-links">
                    <xsl:apply-templates select="/H2G2/TOPIC_PAGE/TOPICLIST[@STATUS='Preview']" mode="object_topiclist"/>
                  </ul>
                </xsl:if>
                
                <p class="dna-fnote">
                  <strong>Note:</strong><br/>Topics will automatically appear when you add a new topic (right).
                </p>
              </div>
              
              <div class="dna-box">
                <h4 class="dna-off">Internal links</h4>
                <ul class="dna-list-links">
                  <li><a href="#">My Discussions</a></li>
                  <li><a href="#">House Rules</a></li>
                  <li><a href="#">FAQs</a></li>
                </ul>
              </div>
            </div>

            <div id="dna-preview-middle" class="dna-fl">
              <div class="dna-box-border">
                <h4 class="dna-off">Welcome message</h4>
                <xsl:choose>
                   <xsl:when test="SITECONFIGPREVIEW/SITECONFIG/V2_BOARDS/WELCOME_MESSAGE">
                     <p>
                       <strong>Welcome message: </strong>
                       <br/>
                       <xsl:value-of select="SITECONFIGPREVIEW/SITECONFIG/V2_BOARDS/WELCOME_MESSAGE"/>
                     </p>
                     <p>
                       <a href="?s_mode=welcome#dna-preview-addwelcome" class="dna-link-overlay">+ Modify your welcome message</a>
                     </p>
                   </xsl:when>
                   <xsl:otherwise>
                     <p>
                       <a href="?s_mode=welcome#dna-preview-addwelcome" class="dna-link-overlay">+ Add welcome message</a>
                     </p>
                   </xsl:otherwise>
                 </xsl:choose>
               </div>

              <div>
                <h4 class="dna-off">Topics</h4>
                
                <form action="messageboardadmin_design?cmd=updatetopicpositions" method="post">
                  <xsl:choose>
                    <xsl:when test="/H2G2/TOPIC_PAGE">
                      <ul>
                        <xsl:attribute name="class">
                          <xsl:choose>
                            <xsl:when test="/H2G2/SITECONFIGPREVIEW/SITECONFIG/V2_BOARDS/TOPICLAYOUT = '1col'">dna-edit-topic-1</xsl:when>
                            <xsl:otherwise>dna-edit-topic-2</xsl:otherwise>
                          </xsl:choose>
                        </xsl:attribute>
                        
                        <xsl:apply-templates select="/H2G2/TOPIC_PAGE/TOPICLIST[@STATUS='Preview']" mode="object_topiclist_elements" />
                      </ul>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:apply-templates select="TOPICLIST" mode="object_topiclist_setup"/>
                    </xsl:otherwise>
                  </xsl:choose>


                  <p class="dna-off">
                    <input type="submit" value="Update Topic Layout"/>
                  </p>
                </form>

                <div class="dna-box-border dna-clear">
                  <p >
                    <a href="?s_mode=topic#dna-preview-edittopic" class="dna-link-overlay">+ Add a new topic</a>
                  </p>
                </div>

                <div class="dna-box-border">
                  <p>
                    <a href="?s_mode=layout#dna-preview-edittopiclayout" class="dna-link-overlay">+ Choose topic layout</a>
                  </p>
                  <p class="dna-fnote">Choose between a 1 and 2 column layout tp display the topics.</p>
                </div>
              </div>
            </div>
            

            <div id="dna-preview-right" class="dna-fl">
              <div class="dna-box-border">
                <h4 class="dna-off">About message</h4>
                <xsl:choose>
                  <xsl:when test="SITECONFIGPREVIEW/SITECONFIG/V2_BOARDS/ABOUT_MESSAGE">
                    <p>
                      <strong>About message: </strong>
                      <br/>
                      <xsl:value-of select="SITECONFIGPREVIEW/SITECONFIG/V2_BOARDS/ABOUT_MESSAGE"/>
                    </p>
                    <p>
                      <a href="?s_mode=about#dna-preview-addtext" class="dna-link-overlay">+ Modify about message</a>
                    </p>
                  </xsl:when>
                  <xsl:otherwise>
                    <p>
                      <a href="?s_mode=about#dna-preview-addtext" class="dna-link-overlay">+ Add about message</a>
                    </p>
                  </xsl:otherwise>
                </xsl:choose>
               
                <h4 class="dna-off">Opening hours</h4>
                <xsl:choose>
                  <xsl:when test="SITECONFIGPREVIEW/SITECONFIG/V2_BOARDS/OPENCLOSETIMES_TEXT">
                    <p>
                      <strong>Opening hours: </strong>
                      <br/>
                      <xsl:value-of select="SITECONFIGPREVIEW/SITECONFIG/V2_BOARDS/OPENCLOSETIMES_TEXT"/>
                    </p>
                    <p>
                      <a href="?s_mode=about#dna-preview-addtext" class="dna-link-overlay">+ Modify opening hours text</a>
                    </p>
                  </xsl:when>
                  <xsl:otherwise>
                    <p>
                      <a href="?s_mode=about#dna-preview-addtext" class="dna-link-overlay">+ Add opening hours text</a>
                    </p>
                  </xsl:otherwise>
                </xsl:choose>
              </div>

              <div id="dna-preview-recent" class="dna-box">
                <h4 class="dna-off">Recent Discussions</h4>
                <p class="dna-fnote">
                  <strong>Note (to do):</strong><br/>
                  Recent discussions will be automatically generated when your messageboard is live.
                </p>
              </div>


              <div class="dna-box-border">
                <h4 class="dna-off">Extras modules</h4>
                <xsl:if test="SITECONFIGPREVIEW/SITECONFIG/V2_BOARDS/MODULES/LINKS">
                  <p><strong>Modules inserted:</strong></p>
                  <ul class="dna-list-links">
                    <xsl:for-each select="SITECONFIGPREVIEW/SITECONFIG/V2_BOARDS/MODULES/LINKS/LINK">
                      <li>
                        <xsl:value-of select="."/>
                      </li>
                      </xsl:for-each>
                  </ul>
                </xsl:if>

                <p>
                  <a href="?s_mode=modules#dna-preview-addmodules" class="dna-link-overlay">+ Add more modules</a>
                </p>
              </div>
            </div>
          </div>



         <div class="dna-box-border dna-clear">
          <xsl:choose>
            <xsl:when test="SITECONFIGPREVIEW/SITECONFIG/V2_BOARDS/SOCIALTOOLBAR">
              <p>
                <strong>Social media added: </strong>
                <xsl:choose>
                  <xsl:when test="SITECONFIGPREVIEW/SITECONFIG/V2_BOARDS/SOCIALTOOLBAR = 'true'">yes</xsl:when>
                  <xsl:otherwise>no</xsl:otherwise>
                </xsl:choose>
              </p>
              <p>
                <a href="?s_mode=toolbar#dna-preview-addtoolbar" class="dna-link-overlay">+ Remove Social Media toolbar</a>
              </p>
            </xsl:when>
            <xsl:otherwise>
              <p>
                <a href="?s_mode=toolbar#dna-preview-addtoolbar" class="dna-link-overlay">+ Add Social Media toolbar (e.g. Facebook, Digg, Delicious etc.)</a>
              </p>
            </xsl:otherwise>
          </xsl:choose>
          </div>


          <div class="dna-box-border">
            <p>
              <xsl:choose>
                <xsl:when test="SITECONFIGPREVIEW/SITECONFIG/V2_BOARDS/FOOTER/COLOUR">
                  <strong>Footer colour chosen: </strong>
                  <xsl:value-of select="SITECONFIGPREVIEW/SITECONFIG/V2_BOARDS/FOOTER/COLOUR"/>
                </xsl:when>
                <xsl:otherwise>Footer colour by default is dark grey.</xsl:otherwise>
              </xsl:choose>
            </p>

            <p>
              <a href="?s_mode=footer#dna-preview-editfooter" class="dna-link-overlay">+ Edit footer colour</a>
            </p>
          </div>
 
          <xsl:choose>
            <xsl:when test="PARAMS/PARAM[NAME='s_edittopic'] and (TOPIC_PAGE/TOPICLIST/TOPIC/TOPICID = PARAMS/PARAM[NAME='s_edittopic']/VALUE)">
              <xsl:call-template name="object_topic_edit">
                <xsl:with-param name="topicid" select="PARAMS/PARAM[NAME='s_edittopic']/VALUE" />
              </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
              <xsl:call-template name="object_topic_edit">
                <xsl:with-param name="topicid" select="0" />
              </xsl:call-template>
            </xsl:otherwise>
          </xsl:choose>

          <xsl:call-template name="lightboxes"/>
       </div>
    </div>
   
	</xsl:template>

</xsl:stylesheet>
