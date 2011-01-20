<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">
    
    <doc:documentation>
        <doc:purpose>
            Coverts EMP nodes to Embedded EMP videos
        </doc:purpose>
        <doc:context>
            Applied by _common/_library/GuideML.xsl
        </doc:context>
        <doc:notes>
            
        </doc:notes>
    </doc:documentation>
	
	<xsl:template match="EMP | emp" mode="library_GuideML">
		<div id="emp0">
			<xsl:comment>emp0</xsl:comment>
		</div>
		<div id="emp1">
			<xsl:comment>emp1</xsl:comment>
		</div>
		<script type="text/javascript">var emp = new embeddedMedia.Player();emp.setWidth("512");emp.setHeight("323");emp.setDomId("emp1");emp.setPlaylist("http://www.bbc.co.uk/emp/docs/demos/xml/video.xml");emp.write();</script>		
    </xsl:template>
</xsl:stylesheet>