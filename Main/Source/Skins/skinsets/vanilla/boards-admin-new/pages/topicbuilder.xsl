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
      <h2>Topics Archive List</h2>
    </div>

    <div class="dna-main blq-clearfix">
      <div class="dna-fl dna-main-full">
        <div class="dna-fl dna-half dna-main-bg">
          <p>The list below shows topics that are currently LIVE. You can drag and drop it into the archive list. This will remove it from the live site.</p>
          
          <div class="dna-box dna-mall">
            <h3>Live Topics</h3>
            
            <ul class="dna-list-topic-live">
              <xsl:apply-templates select="/H2G2/TOPIC_PAGE/TOPICLIST/TOPIC[TOPICSTATUS='1']" mode="object_topiclist"/>
              <xsl:apply-templates select="/H2G2/TOPIC_PAGE/TOPICLIST/TOPIC[TOPICSTATUS='0']" mode="object_topiclist"/>
            </ul>
           </div>
        </div>
        <div class="dna-fr dna-half dna-main-bg-g">
          <p>The list below shows topics that are currently ARCHIVED. You can drag and drop it into the live list. This will publish the topic to the live site.</p>

          <div class="dna-box dna-mall">
            <h3>Archived Topics</h3>

            <ul class="dna-list-topic-archive">
              <xsl:apply-templates select="/H2G2/TOPIC_PAGE/TOPICLIST/TOPIC[TOPICSTATUS='4']" mode="object_topiclist"/>
              <xsl:apply-templates select="/H2G2/TOPIC_PAGE/TOPICLIST/TOPIC[TOPICSTATUS='3']" mode="object_topiclist"/>
            </ul>
          </div>
        </div>
      </div>
    </div>
   
	</xsl:template>

</xsl:stylesheet>
