<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
	xmlns="http://www.w3.org/1999/xhtml" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	version="1.0" 
	xmlns:doc="http://www.bbc.co.uk/dna/documentation"  
	exclude-result-prefixes="doc">

    <doc:documentation>
        <doc:purpose>
            Bridge to moderation skins
        </doc:purpose>
        <doc:context>
            Applied by the kick off file  (e.g. /html.xsl, /rss.xsl etc)
        </doc:context>
        <doc:notes>
            This is a hack, for now. Eeep!
        </doc:notes>
    </doc:documentation>
    
	<xsl:template match="/H2G2[@TYPE = 'MODERATE-HOME']" mode="page">
		<script type="text/javascript">
			window.location.replace("<xsl:value-of select="$root-base"/>/default/moderate");
		</script>
		<div>
			<p>If the page does not refresh, <a href="{$root-base}/default/moderate">click here</a> to go to the Moderation interface.</p>
		</div>
	</xsl:template>
	
	<xsl:template match="/H2G2[@TYPE = 'MODERATE-HOME']" mode="breadcrumbs"/>
		
	
	
</xsl:stylesheet>