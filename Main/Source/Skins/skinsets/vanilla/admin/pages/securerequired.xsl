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
	
	<xsl:template match="H2G2[@TYPE = 'SECUREREQUIRED']" mode="page">
		<div class="full">
      <div style="height: 300px;">
			<p>To access this page, you must use a secure request as it may include some private user information.</p>

      <p>To do this, in the address bar above, please change the beginning of the address from "http://www.bbc.co.uk" to "https://ssl.bbc.co.uk" and resubmit your request.</p>

      <p>If you have arrived to this page from a link, please submit a bug to the Social Publishing Team.</p>
      </div>
		</div>
	</xsl:template>

</xsl:stylesheet>
