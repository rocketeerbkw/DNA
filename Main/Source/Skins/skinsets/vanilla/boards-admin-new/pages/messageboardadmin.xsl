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
	
	<xsl:template match="H2G2[@TYPE = 'MBADMIN'] | H2G2[@TYPE = 'FRONTPAGE']" mode="page">

    <div class="dna-mb-intro">
      <p>
       The controls below, allow you to set the various admin-based options for your messageboard. Click the <em>Edit</em> button to change any of these details.
      </p>
      <p>
        <em>If you need additional help, please contact</em>
        <a href="mailto@help@help.com">help@help.com</a>
      </p>
    </div>
    
    <div class="dna-main blq-clearfix">
      <div class="dna-fl dna-main-left">
        <div class="dna-fl dna-half">
          <div class="dna-box">
            <h3>Opening Times</h3>
            <p>
              <strong>Set the opening/closing times, controlling when someone can post a message.</strong>
            </p>
            <p class="dna-fnote">You have yet to set any opening times  - click the Edit button to set them.</p>
          
            <p class="dna-link-edit"><a href="{$root}/MessageBoardSchedule">Edit<span class="off"> opening times</span></a></p>
          </div>
        </div>

        <div class="dna-fr dna-half">
          <div class="dna-box">
            <h3>Assets</h3>
            <p>
              <strong>Below are the assets you have defined for your messageboard.</strong>
            </p>

            <h4>Emoticons</h4>
            <p class="dna-fnote">You have not added any emoticons - click the Edit button to add some. </p>

            <h4>Stylesheet</h4>
            <p class="dna-fnote">You have not added a custom stylesheet - click the Edit button to add one.</p>

            <p class="dna-link-edit"><a href="{$root}/messageboardadmin_assets">Edit<span class="off"> assets</span></a></p>
          </div>
        </div>
      </div>

      <div class="dna-fr dna-main-right">                                                                                                                                    
        <div class="dna-preview">
          <h3>Preview</h3>

          <p class="dna-center">
            <a href="/dna/{SITE/URLNAME}/?_previewmode=1" class="button" target="_blank">Preview this messageboard</a>
          </p>
          <p class="dna-fnote">View your messageboard exactly as the user will view it.</p>
        </div>

        <div class="dna-publish">
          <h3>Publish</h3>

          <p class="dna-center">
            <a href="{$root}/messageboardadmin?cmd=UPDATEPREVIEWANDLIVE" class="button" onclick="return confirm('Are your sure you want to publish this site?');">Publish this messageboard</a>
          </p>
          <p class="dna-fnote">Publish your messageboard live to the web.</p>
        </div>
        
        <div class="dna-box">
          <h3>Archive</h3>
          <p>
            <strong>Below are the topics which you have archived. To archive a live topic - click the Edit button.</strong>
          </p>
          <p>
            <strong>
              If you would like to create a new topic, please use the <a href="{$root}/messageboardadmin_design?s_mode=design">Design</a> section.
            </strong>
          </p>
          <p class="dna-fnote">You do not have any archived topics - click the Edit button to archive a live topic.</p>

          <p class="dna-link-edit"><a href="{$root}/topicbuilder">Edit<span class="off"> archived topics</span></a></p>
        </div>
      </div>
    </div>  

	</xsl:template>
	
</xsl:stylesheet>
