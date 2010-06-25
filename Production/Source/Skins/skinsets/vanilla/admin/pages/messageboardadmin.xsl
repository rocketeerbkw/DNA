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

  <xsl:template match="H2G2[@TYPE = 'FRONTPAGE']" mode="page">
    <div>
      <p class="dna-error"><a href="{$host}{$root}/mbadmin?s_mode=admin">Redirecting...</a></p>
    </div>
  </xsl:template>

    <xsl:template match="H2G2[@TYPE = 'MBADMIN']" mode="page">

    <div class="dna-mb-intro">
      <h2>Your messageboard controls</h2>
      
      <p>
       The controls below allow you to set the various admin-based options for your messageboard. Click the <em>Edit</em> button to change any of these details.
      </p>
      <p>
        <em>
          If you need additional help, please check our <a href="https://confluence.dev.bbc.co.uk/display/DNA/Messageboards+Admin+Tool+-+User+Guide">user guide</a>.
        </em>
      </p>
    </div>
    
    <div class="dna-main dna-main-bg dna-main-pad blq-clearfix">
      <div class="dna-fl dna-main-left">
        <div class="dna-fl dna-half">
          <div class="dna-box">
            <h3>Opening Times</h3>
            <p>
              <strong>Set the opening/closing times, controlling when someone can post a message.</strong>
            </p>
           
            <xsl:choose>
              <xsl:when test="not(//OPENCLOSETIMES/OPENCLOSETIME)">
                <p class="dna-fnote">Your messageboard is open 24/7. </p>
              </xsl:when>
              <xsl:otherwise>
                <div class="dna-open-time">
                  <table>
                    <tr>
                      <th><span>DAY</span></th>
                      <th><span>OPEN</span></th>
                      <th><span>CLOSE</span></th>
                    </tr>

                    <xsl:for-each select="//OPENCLOSETIME">
                      <xsl:sort select="@DAYOFWEEK"/>
                      <tr>
                        <xsl:attribute name="class">
                          <xsl:choose>
                            <xsl:when test="position() mod 2 = 1">odd</xsl:when>
                            <xsl:otherwise>even</xsl:otherwise>
                          </xsl:choose>
                        </xsl:attribute>

                        <td>
                          <xsl:choose>
                            <xsl:when test="@DAYOFWEEK = 1">Sunday</xsl:when>
                            <xsl:when test="@DAYOFWEEK = 2">Monday</xsl:when>
                            <xsl:when test="@DAYOFWEEK = 3">Tuesday</xsl:when>
                            <xsl:when test="@DAYOFWEEK = 4">Wednesday</xsl:when>
                            <xsl:when test="@DAYOFWEEK = 5">Thursday</xsl:when>
                            <xsl:when test="@DAYOFWEEK = 6">Friday</xsl:when>
                            <xsl:when test="@DAYOFWEEK = 7">Saturday</xsl:when>
                            
                          </xsl:choose>
                        </td>
                        <xsl:choose>
                          <xsl:when test="OPENTIME/HOUR != '0' or CLOSETIME/HOUR != '0'">
                            <td>
                              <xsl:value-of select="OPENTIME/HOUR"/>
                              <xsl:text>:</xsl:text>
                              <xsl:choose>
                                  <xsl:when test="OPENTIME/MINUTE = '0'">00</xsl:when>
                                  <xsl:otherwise>
                                    <xsl:value-of select="OPENTIME/MINUTE"/>
                                  </xsl:otherwise>
                              </xsl:choose>
                            </td>
                            <td>
                              <xsl:choose>
                                <xsl:when test="CLOSETIME/HOUR = '0'">24</xsl:when>
                                <xsl:otherwise>
                                  <xsl:value-of select="CLOSETIME/HOUR"/>
                                </xsl:otherwise>
                              </xsl:choose>
                              <xsl:text>:</xsl:text>
                              <xsl:choose>
                                <xsl:when test="CLOSETIME/MINUTE = '0'">00</xsl:when>
                                <xsl:otherwise>
                                  <xsl:value-of select="CLOSETIME/MINUTE"/>
                                </xsl:otherwise>
                                </xsl:choose>
                            </td>
                          </xsl:when>
                          <xsl:otherwise>
                            <td colspan="2">
                              <strong>Closed all day</strong>
                            </td>
                          </xsl:otherwise>
                        </xsl:choose>

                      </tr>
                    </xsl:for-each>
                  </table>
                </div>
              </xsl:otherwise>
            </xsl:choose>

            <p class="dna-link-edit"><a href="{$root}/MessageBoardSchedule">Edit<span class="dna-off"> opening times</span></a></p>
          </div>
        </div>

        <div class="dna-fr dna-half">
          <div class="dna-box">
            <h3>Assets</h3>
            <p>
              <strong>Below are the assets you have defined for your messageboard.</strong>
            </p>

   
            <h4>Stylesheet</h4>

            <xsl:choose>
              <xsl:when test="string(//SITECONFIG/V2_BOARDS/CSS_LOCATION)">
                <p>Stylesheet currently being used:</p>
                <p class="dna-fnote"><strong>File: </strong>
                  <xsl:value-of select="SITECONFIGPREVIEW/SITECONFIG/V2_BOARDS/CSS_LOCATION" />
                </p>
              </xsl:when>
              <xsl:otherwise>
                <p class="dna-fnote">You have not added a custom stylesheet - click the Edit button to add one.</p>
              </xsl:otherwise>
            </xsl:choose>
            
            <p class="dna-link-edit"><a href="{$root}/messageboardadmin_assets">Edit<span class="dna-off"> assets</span></a></p>
          </div>
        </div>
      </div>

      <div class="dna-fr dna-main-right">                                                                                                                                    
        <div class="dna-preview">
          <h3>Preview</h3>

          <p class="dna-center">
            <a href="/dna/{SITE/URLNAME}/boards_v2/?_previewmode=1" class="dna-openNewWindow">Preview this messageboard</a>
          </p>
          <p class="dna-fnote"><strong>View your messageboard exactly as the user will see it.</strong></p>
        </div>

        <div class="dna-publish">
          <h3>Publish</h3>

          <p class="dna-center">
            <a href="{$root}/mbadmin#dna-publish-mb"  class="dna-link-overlay">Publish this messageboard</a>
          </p>
          <p class="dna-fnote"><strong>Publish your messageboard live to the web.</strong></p>
        </div>
        
        <div class="dna-box">
          <h3>Topics</h3>
          <p>
            <strong>To archive a live topic - click the Edit button.</strong>
          </p>
          <p>
            <strong>
              If you would like to create a new topic, please use the <a href="{$root}/messageboardadmin_design?s_mode=design">Design</a> section.
            </strong>
          </p>
          
          <p class="dna-link-edit"><a href="{$root}/topicbuilder">Edit<span class="dna-off"> topics</span></a></p>
        </div>
      </div>

      <div id="dna-lightboxes" class="dna-clear">

        <div id="dna-publish-mb">
          <xsl:attribute name="class">
            dna-preview-box <xsl:if test="PARAMS/PARAM[NAME = 's_mode']/VALUE != 'publish' or not(PARAMS/PARAM[NAME = 's_mode'])">dna-off</xsl:if>
          </xsl:attribute>

          <h4>Publish this messageboard</h4>

          <form action="mbadmin?cmd=PUBLISHMESSAGEBOARD" method="post">
  
            <p>
              Are you sure you want to publish this messageboard?
            </p>

            <div class="dna-buttons">
              <ul>
                <li>
                  <input type="submit" name="submit" value="Yes" />
                </li>
                <li>
                  <a href="mbadmin?s_mode=admin" class="dna-btn-link dna-btn-cancel">No</a>
                </li>
              </ul>
            </div>

          </form>
         </div>
        
         <div id="dna-publish-mb-yes">
           <xsl:attribute name="class">
             dna-preview-box <xsl:if test="PARAMS/PARAM[NAME = 's_mode']/VALUE != 'publish' or not(PARAMS/PARAM[NAME = 's_mode'])">dna-off</xsl:if>
           </xsl:attribute>


           <xsl:choose>
            <xsl:when test="//MESSAGEBOARDPUBLISHERROR">
              <h4>Your board cannot be published yet...</h4>

              <p> In order to publish your messageboard, the following areas need to be completed:</p>

              <xsl:if test="MESSAGEBOARDPUBLISHERROR/DESIGN">
                <p>In the Design Section</p>

                <ul>
                  <xsl:for-each select="//MESSAGEBOARDPUBLISHERROR/DESIGN/ERROR">
                    <li>
                      <xsl:choose>
                        <xsl:when test=". = 'MissingWelcomeMessage'">Add a welcome message</xsl:when>
                        <xsl:when test=". = 'MissingAboutText'">Add your introduction/about text</xsl:when>
                        <xsl:when test=". = 'MissingOpenCloseMessage'">Add opening/closing times</xsl:when>
                        <xsl:when test=". = 'MissingTopicElementTitle'">Add a topic promo title</xsl:when>
                        <xsl:when test=". = 'MissingTopicElementText'">Add a topic description</xsl:when>
                        <xsl:when test=". = 'MissingTopicTitle'">Add the title of the topic page</xsl:when>
                        <xsl:when test=". = 'MissingTopicDescription'">Add the topic page description</xsl:when>
                        <xsl:when test=". = 'MissingImageName'">Add a topic promo image</xsl:when>
                        <xsl:when test=". = 'MissingAltText'">Provide an alt text</xsl:when>
                      </xsl:choose>
                    </li>
                  </xsl:for-each>
                </ul>
                <div class="dna-buttons">
                  <ul>
                    <li>
                      <a href="mbadmin?s_mode=admin" class="dna-btn-link dna-btn-cancel">Back</a>
                    </li>
                  </ul>
                </div>
              </xsl:if>
            </xsl:when>
            <xsl:otherwise>
              <h4>Your messageboard is live !</h4>
              
              <p>Your messageboard has been published.</p>

              <div class="dna-buttons">
                 
                <ul>
                  <li>
                    <a href="/dna/{SITE/URLNAME}" class="dna-btn-link dna-btn-cancel">View your messageboard</a>
                  </li>
                  <li>
                    <a href="mbadmin?s_mode=admin" class="dna-btn-link dna-btn-cancel">Close</a>
                  </li>
                </ul>
              </div>
            </xsl:otherwise>
          </xsl:choose>
        </div>

      </div>
    </div>
	</xsl:template>
  
	
</xsl:stylesheet>
