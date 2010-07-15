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
	
	<xsl:template match="H2G2[@TYPE = 'MBBACKUPRESTORE']" mode="page">
    <div class="dna-mb-intro">
      <h2>Messageboard Backup/Restore</h2>
    </div>

    <div class="dna-main blq-clearfix">
      <div class="dna-fl dna-main-full">
        
        <h2>Backup</h2>

        <textarea cols="100" rows="10" id="mbBackupText">
          <xsl:copy-of select="/H2G2/MESSAGEBOARDBACKUP"/>
        </textarea>
        
      </div>
      <div class="dna-fl dna-main-full">
          <h2>Restore</h2>
          <form action="messageboardbackuprestore?cmd=RESTORE" method="post">
            <textarea cols="100" rows="10" name="RestoreBoardText" id="RestoreBoardText"><xsl:text>Enter xml and click restore</xsl:text></textarea>
            <br/>
            <input type="submit" value="Restore"></input>
          </form>
        
      </div>

    </div>
	</xsl:template>

</xsl:stylesheet>
