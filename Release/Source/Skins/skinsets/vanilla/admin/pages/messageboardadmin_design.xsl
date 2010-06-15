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
          <h4>Banner</h4>
          <xsl:choose>
            <xsl:when test="/H2G2/SITECONFIGPREVIEW/SITECONFIG/V2_BOARDS/BANNER_SSI != ''">
              <p>
                <strong>Banner included: </strong>
                <xsl:value-of select="/H2G2/SITECONFIGPREVIEW/SITECONFIG/V2_BOARDS/BANNER_SSI"/>
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
          <h4>Horizontal navigation</h4>
          <xsl:choose>
            <xsl:when test="/H2G2/SITECONFIGPREVIEW/SITECONFIG/V2_BOARDS/HORIZONTAL_NAV_SSI != ''">
              <p>
                <strong>Navigation included: </strong>
                <xsl:value-of select="/H2G2/SITECONFIGPREVIEW/SITECONFIG/V2_BOARDS/HORIZONTAL_NAV_SSI"/>
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
              <h4>Left navigation</h4>
              <xsl:choose>
                <xsl:when test="/H2G2/SITECONFIGPREVIEW/SITECONFIG/V2_BOARDS/LEFT_NAV_SSI != ''">
                  <p>
                    <strong>Navigation included:</strong>
                  </p>

                  <ul class="dna-list-links">
                    <li>
                      <xsl:value-of select="/H2G2/SITECONFIGPREVIEW/SITECONFIG/V2_BOARDS/LEFT_NAV_SSI"/>
                    </li>
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
              <h4>Topics list</h4>
              <xsl:if test="/H2G2/TOPIC_PAGE">
                <ul class="dna-list-links">
                  <xsl:choose>
                    <xsl:when test="/H2G2/SITECONFIGPREVIEW/SITECONFIG/V2_BOARDS/TOPICLAYOUT = '2col'">
                        <xsl:apply-templates select="/H2G2/TOPIC_PAGE/TOPICLIST[@STATUS='Preview']/TOPIC[FRONTPAGEELEMENT/POSITION = starts-with(POSITION,'1') and position() mod 2 = 1]" mode="object_topiclist_design" />
                        <xsl:apply-templates select="/H2G2/TOPIC_PAGE/TOPICLIST[@STATUS='Preview']/TOPIC[FRONTPAGEELEMENT/POSITION = starts-with(POSITION,'2') and position() mod 2 = 1]" mode="object_topiclist_design" />
                        <xsl:apply-templates select="/H2G2/TOPIC_PAGE/TOPICLIST[@STATUS='Preview']/TOPIC[FRONTPAGEELEMENT/POSITION = starts-with(POSITION,'1') and position() mod 2 = 0]" mode="object_topiclist_design" />
                        <xsl:apply-templates select="/H2G2/TOPIC_PAGE/TOPICLIST[@STATUS='Preview']/TOPIC[FRONTPAGEELEMENT/POSITION = starts-with(POSITION,'2') and position() mod 2 = 0]" mode="object_topiclist_design" />
                        <xsl:apply-templates select="/H2G2/TOPIC_PAGE/TOPICLIST[@STATUS='Preview']/TOPIC[FRONTPAGEELEMENT/POSITION != starts-with(POSITION,'1') and POSITION != starts-with(POSITION,'2')]" mode="object_topiclist_design" />
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates select="/H2G2/TOPIC_PAGE/TOPICLIST[@STATUS='Preview']/TOPIC" mode="object_topiclist_design" />
                    </xsl:otherwise>
                  </xsl:choose>
                </ul>
              </xsl:if>

              <p class="dna-fnote">
                <strong>Note:</strong><br/>Topics will automatically appear when you add a new topic (right).
              </p>
            </div>

            <div class="dna-box">
              <h4 class="dna-off">Internal links</h4>
              <ul class="dna-list-links">
                <li>
                  <a href="#">My Discussions</a>
                </li>
                <li>
                  <a href="#">House Rules</a>
                </li>
                <li>
                  <a href="#">FAQs</a>
                </li>
              </ul>
            </div>
          </div>

          <div id="dna-preview-middle" class="dna-fl">
            <div class="dna-box-border">
              <h4>Welcome message</h4>
             
              <xsl:choose>
                <xsl:when test="/H2G2/SITECONFIGPREVIEW/SITECONFIG/V2_BOARDS/WELCOME_MESSAGE != ''">
                  <p>
                    <xsl:value-of select="/H2G2/SITECONFIGPREVIEW/SITECONFIG/V2_BOARDS/WELCOME_MESSAGE"/>
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

            <div id="dna-s-topics" class="dna-box">
              <h4>Topic layout</h4>
             
              
              <form action="messageboardadmin_design?s_mode=design&amp;cmd=updatetopicpositions&amp;s_success_topics=true" method="post">
                <p>To re-order the topics, drag and drop the topic modules and select <span class="dna-buttons"><input type="submit" value="Save"/></span></p>

                <p class="dna-topic-options"><span><a href="?s_mode=layout#dna-preview-edittopiclayout" class="dna-link-overlay">+ Choose topic layout</a></span><span><a href="?s_edittopic=0#dna-preview-topic-edit-0" class="dna-link-overlay">+ Add a new topic</a></span></p>
                
                <xsl:choose>
                  <xsl:when test="/H2G2/TOPIC_PAGE">

                      <xsl:choose>
                        <xsl:when test="/H2G2/SITECONFIGPREVIEW/SITECONFIG/V2_BOARDS/TOPICLAYOUT = '2col'">
                          <ul class="dna-list-topic-col1">
                            <xsl:apply-templates select="/H2G2/TOPIC_PAGE/TOPICLIST[@STATUS='Preview']/TOPIC[FRONTPAGEELEMENT/POSITION = starts-with(POSITION,'1')]" mode="object_topiclist_elements" />
                            <xsl:apply-templates select="/H2G2/TOPIC_PAGE/TOPICLIST[@STATUS='Preview']/TOPIC[FRONTPAGEELEMENT/POSITION != starts-with(POSITION,'1') and POSITION != starts-with(POSITION,'2') and position() mod 2 = 1]" mode="object_topiclist_elements" />
                          </ul>
                          <ul class="dna-list-topic-col2">
                            <xsl:apply-templates select="/H2G2/TOPIC_PAGE/TOPICLIST[@STATUS='Preview']/TOPIC[FRONTPAGEELEMENT/POSITION = starts-with(POSITION,'2')]" mode="object_topiclist_elements" />
                            <xsl:apply-templates select="/H2G2/TOPIC_PAGE/TOPICLIST[@STATUS='Preview']/TOPIC[FRONTPAGEELEMENT/POSITION != starts-with(POSITION,'1') and POSITION != starts-with(POSITION,'2') and position() mod 2 = 0]" mode="object_topiclist_elements" />
                          </ul>
                        </xsl:when>
                        <xsl:otherwise>
                          <ul class="dna-list-topic-col">
                            <xsl:apply-templates select="/H2G2/TOPIC_PAGE/TOPICLIST[@STATUS='Preview']/TOPIC" mode="object_topiclist_elements" />
                          </ul>
                        </xsl:otherwise>
                      </xsl:choose>

                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:apply-templates select="TOPICLIST" mode="object_topiclist_setup"/>
                  </xsl:otherwise>
                </xsl:choose>

              </form>
            </div>
          </div>


          <div id="dna-preview-right" class="dna-fl">
            <div class="dna-box-border">
              <h4>About this board</h4>
              
              <h5>About message:</h5>
              <p>
                <xsl:value-of select="/H2G2/SITECONFIGPREVIEW/SITECONFIG/V2_BOARDS/ABOUT_MESSAGE"/>
              </p>

              <h5>Opening hours:</h5>
               <p>
                 <xsl:value-of select="/H2G2/SITECONFIGPREVIEW/SITECONFIG/V2_BOARDS/OPENCLOSETIMES_TEXT"/>
              </p>

              <xsl:choose>
                <xsl:when test="/H2G2/SITECONFIGPREVIEW/SITECONFIG/V2_BOARDS/ABOUT_MESSAGE != '' or /H2G2/SITECONFIGPREVIEW/SITECONFIG/V2_BOARDS/OPENCLOSETIMES_TEXT != ''">
                  <p>
                    <a href="?s_mode=about#dna-preview-addtext" class="dna-link-overlay">+ Modify introduction/about message</a>
                  </p>
                </xsl:when>
                <xsl:otherwise>
                  <p>
                    <a href="?s_mode=about#dna-preview-addtext" class="dna-link-overlay">+ Add introduction/about message</a>
                  </p>
                </xsl:otherwise>
              </xsl:choose>
            </div>

            <div class="dna-box">
              <h4>Recent Discussions</h4>
              <p>For messageboards aimed at people under 16 years old, you may turn off the Recent Discussions module. This option is for <strong>under 16 messageboards only</strong> - the module is compulsory for all others.</p>

              <xsl:choose>
                <xsl:when test="/H2G2/SITECONFIGPREVIEW/SITECONFIG/V2_BOARDS/RECENTDISCUSSIONS = 'false'">
                  <p>
                    <a href="?s_mode=discussions#dna-preview-addrecentdiscussions" class="dna-link-overlay">+ Turn on recent discussions</a>
                  </p>
                </xsl:when>
                <xsl:otherwise>
                  <p>
                    <a href="?s_mode=discussions#dna-preview-addrecentdiscussions" class="dna-link-overlay">+ Turn off recent discussions</a>
                  </p>
                </xsl:otherwise>
              </xsl:choose>
            </div>


            <div class="dna-box-border">
              <h4>Extras modules</h4>
              <xsl:if test="/H2G2/SITECONFIGPREVIEW/SITECONFIG/V2_BOARDS/MODULES/LINKS != ''">
                <p>
                  <strong>Modules inserted:</strong>
                </p>
                <ul class="dna-list-links">
                  <xsl:for-each select="/H2G2/SITECONFIGPREVIEW/SITECONFIG/V2_BOARDS/MODULES/LINKS/LINK">
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
          <h4>Social media toolbar</h4>

          <xsl:choose>
            <xsl:when test="/H2G2/SITECONFIGPREVIEW/SITECONFIG/V2_BOARDS/SOCIALTOOLBAR != ''">
              <p>
                <strong>Toolbar added: </strong>
                <xsl:choose>
                  <xsl:when test="/H2G2/SITECONFIGPREVIEW/SITECONFIG/V2_BOARDS/SOCIALTOOLBAR = 'true'">yes</xsl:when>
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
          <h4>Footer colour</h4>

          <p>
            <xsl:choose>
              <xsl:when test="/H2G2/SITECONFIGPREVIEW/SITECONFIG/V2_BOARDS/FOOTER/COLOUR != ''">
                <strong>Footer colour chosen: </strong>
                <xsl:value-of select="/H2G2/SITECONFIGPREVIEW/SITECONFIG/V2_BOARDS/FOOTER/COLOUR"/>
              </xsl:when>
              <xsl:otherwise>Footer colour by default is dark grey.</xsl:otherwise>
            </xsl:choose>
          </p>

          <p>
            <a href="?s_mode=footer#dna-preview-editfooter" class="dna-link-overlay">+ Edit footer colour</a>
          </p>
        </div>

        <h3 class="dna-off">Edit your messageboard</h3>

        <xsl:for-each select="/H2G2/TOPIC_PAGE/TOPICLIST/TOPIC">
            <xsl:variable name="topicId" select="TOPICID" />
            <div id="dna-preview-topic-edit-{$topicId}">
              <xsl:attribute name="class">
                dna-preview-box  <xsl:if test="//PARAMS/PARAM[NAME = 's_edittopic']/VALUE != $topicId or not(//PARAMS/PARAM[NAME = 's_edittopic'])">dna-off</xsl:if>
              </xsl:attribute>


              <xsl:call-template name="object_topic_edit">
                <xsl:with-param name="topicid" select="TOPICID" />
              </xsl:call-template>
            </div>

            <xsl:apply-templates select="/H2G2/TOPIC_PAGE/TOPICLIST/TOPIC[TOPICSTATUS='0']" mode="object_topic_overlay"/>
            <xsl:apply-templates select="/H2G2/TOPIC_PAGE/TOPICLIST/TOPIC[TOPICSTATUS='1']" mode="object_topic_overlay"/>
            <xsl:apply-templates select="/H2G2/TOPIC_PAGE/TOPICLIST/TOPIC[TOPICSTATUS='3']" mode="object_topic_overlay"/>
            <xsl:apply-templates select="/H2G2/TOPIC_PAGE/TOPICLIST/TOPIC[TOPICSTATUS='4']" mode="object_topic_overlay"/>
          </xsl:for-each>
       
          <div id="dna-preview-topic-edit-0">
            <xsl:attribute name="class">
              dna-preview-box <xsl:if test="//PARAMS/PARAM[NAME = 's_edittopic']/VALUE != '0' or not(//PARAMS/PARAM[NAME = 's_edittopic'])">dna-off</xsl:if>
            </xsl:attribute>

            <xsl:call-template name="object_topic_edit">
              <xsl:with-param name="topicid" select="0" />
            </xsl:call-template>
          </div>
         

        <xsl:call-template name="lightboxes"/>
      </div>
    </div>

  </xsl:template>

</xsl:stylesheet>
