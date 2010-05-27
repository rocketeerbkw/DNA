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
	
  
	<xsl:template match="H2G2[@TYPE = 'ERROR']" mode="page">
    <div class="dna-error-box dna-main dna-main-bg dna-main-pad blq-clearfix">
      <h2>Welcome to the Messageboard Admin Tool</h2>

      <div class="dna-box">
        <p>
          Please <a href="" class="id-signin">sign-in</a> or <a href="#">register</a> to BBC iD to use this service
        </p>
        <p>
          You need to be granted the appropriate permissions to use this tool.<br />If you are having trouble logging in, please refer to our <a href="">user guide</a> or contact your <a href="">social media representative</a>.
        </p>
      </div>
    </div>
  </xsl:template>

  <xsl:template match="/H2G2[@TYPE != 'ERROR']/ERROR" mode="page">
    <p class="dna-error">An error has occurred - <xsl:value-of select="ERRORMESSAGE"/></p>
  </xsl:template>

  <xsl:template match="/H2G2/RESULT" mode="page">
    <p class="dna-no-error">
       <xsl:value-of select="MESSAGE"/>
    </p>
  </xsl:template>

</xsl:stylesheet>
