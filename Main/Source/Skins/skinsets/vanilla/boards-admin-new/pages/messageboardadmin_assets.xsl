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
		<div class="full">
			<h2>Assets</h2>
			<p>Below are the external assets you are currently using on your messageboard. From here you can control which assets are to be used, and add new assets.</p>
      <form action="messageboardadmin_assets?cmd=updatepreview" method="post">
        <input type="hidden" name="editkey" value="{SITECONFIGPREVIEW/EDITKEY}"></input>

        <div id="mbassets-emticons">
          <h3>EMOTICONS</h3>
          <p>
            Add custom emoticons to your messageboard.
          </p>
          <p>

            <label for="mbemoticon">URL:</label>
              <input type="text" name="EMOTICON_LOCATION" value="{SITECONFIGPREVIEW/SITECONFIG/V2_BOARDS/EMOTICON_LOCATION}" id="mbemoticon"/>
              <p class="info">
                <strong>Example:</strong> /emoticons/happy.gif
              </p>
      </p>
    </div>

    <div id="mbassets-css">
      <h3>STYLESHEET</h3>
      <p>
        Add a stylesheet to control the design of your messageboard.
      </p>
      <p>
          <label for="mbcss">URL:</label>
          <input type="text" name="CSS_LOCATION" value="{SITECONFIGPREVIEW/SITECONFIG/V2_BOARDS/CSS_LOCATION}" id="mbcss"/>
          <p class="info">
            <strong>Example:</strong> /files/styles.css
          </p>

        </p>
    </div>
    <xsl:call-template name="submitbuttons"/>
    </form>
    </div>
	</xsl:template>

</xsl:stylesheet>
