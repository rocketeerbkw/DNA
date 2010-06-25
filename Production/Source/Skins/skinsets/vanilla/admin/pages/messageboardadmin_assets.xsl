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
	
	<xsl:template match="H2G2[@TYPE = 'MBADMINASSETS']" mode="page">

    <div class="dna-mb-intro">
      <h2>Assets</h2>
      
      <p>
        Below are the external assets you are currently using on your messageboard. From here you can control which assets are to be used, and add new assets.
      </p>
    </div>
    
    
    <div class="dna-main dna-main-bg dna-main-pad blq-clearfix">
      <form action="messageboardadmin_assets?cmd=updatepreview" method="post">
        <input type="hidden" name="editkey" value="{SITECONFIGPREVIEW/EDITKEY}"></input>

        <div class="dna-fl dna-main-full">
          <div class="dna-box">
            <h3>Stylesheet</h3>
            <p>
              Add a stylesheet to control the design of your messageboard.
            </p>

            <p>
              <label for="mbcss">URL:</label>
              <input type="text" name="CSS_LOCATION" value="{SITECONFIGPREVIEW/SITECONFIG/V2_BOARDS/CSS_LOCATION}" id="mbcss"/>
              <span class="dna-fnote">
                <strong>Example:</strong> http://www.bbc.co.uk/files/styles.css
               </span>
            </p>
          </div>
        </div>
        
        <xsl:call-template name="submitbuttons">
          <xsl:with-param name="cancelUrl" select="'mbadmin?s_mode=admin'" />
        </xsl:call-template>

      </form>
     
     </div>
	
	</xsl:template>

</xsl:stylesheet>
