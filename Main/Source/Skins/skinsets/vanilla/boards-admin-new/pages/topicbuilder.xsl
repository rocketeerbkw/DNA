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
	
	<xsl:template match="H2G2[@TYPE = 'TOPICBUILDER']" mode="page">
    <div class="dna-mb-intro">
      <h2>Topic Archive list</h2>
    </div>

    <div class="dna-main blq-clearfix">

      <div id="mbtopics-live">
        <h3>Live Topics</h3>
        <xsl:apply-templates select="/H2G2/TOPIC_PAGE/TOPICLIST/TOPIC[TOPICSTATUS='1']" mode="object_topiclist"/>
        <xsl:apply-templates select="/H2G2/TOPIC_PAGE/TOPICLIST/TOPIC[TOPICSTATUS='0']" mode="object_topiclist"/>
      </div>
      <div id="mbtopics-archived">
        <h3>Archived Topics</h3>
        <xsl:apply-templates select="/H2G2/TOPIC_PAGE/TOPICLIST/TOPIC[TOPICSTATUS='4']" mode="object_topiclist"/>
        <xsl:apply-templates select="/H2G2/TOPIC_PAGE/TOPICLIST/TOPIC[TOPICSTATUS='3']" mode="object_topiclist"/>
      </div>
    </div>
   
	</xsl:template>

</xsl:stylesheet>
