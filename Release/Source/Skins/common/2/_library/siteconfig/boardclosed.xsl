<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">
    
  <doc:documentation>
      <doc:purpose>
        Is board open or closed?
      </doc:purpose>
      <doc:context>
        Called on request by skin
      </doc:context>
      <doc:notes>
      
      </doc:notes>
  </doc:documentation>
    
  <xsl:variable name="boardClosed">
    <xsl:choose>
      <xsl:when test="/H2G2/VIEWING-USER/USER/GROUPS/EDITOR or /H2G2/VIEWING-USER/USER/GROUPS/GROUP[NAME='EDITOR'] or /H2G2/VIEWING-USER/USER/STATUS = 2">
        <xsl:value-of select="false()"/>
      </xsl:when>
      <xsl:when test="/H2G2/SITE/SITECLOSED = 1">
        <xsl:value-of select="true()"/>
      </xsl:when>
      <xsl:when test="/H2G2/SITE/OPENCLOSETIMES/*">
        <xsl:variable name="dayOfWeek">
          <xsl:choose>
            <xsl:when test="/H2G2/DATE/@DAYNAME = 'Sunday'">1</xsl:when>
            <xsl:when test="/H2G2/DATE/@DAYNAME = 'Monday'">2</xsl:when>
            <xsl:when test="/H2G2/DATE/@DAYNAME = 'Tuesday'">3</xsl:when>
            <xsl:when test="/H2G2/DATE/@DAYNAME = 'Wednesday'">4</xsl:when>
            <xsl:when test="/H2G2/DATE/@DAYNAME = 'Thursday'">5</xsl:when>
            <xsl:when test="/H2G2/DATE/@DAYNAME = 'Friday'">6</xsl:when>
            <xsl:when test="/H2G2/DATE/@DAYNAME = 'Saturday'">7</xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="now" select="number(concat(format-number(/H2G2/DATE/@HOURS, '00'), format-number(/H2G2/DATE/@MINUTES, '00')))"/>
        <xsl:variable name="open" select="number(concat(format-number(/H2G2/SITE/OPENCLOSETIMES/EVENT[@ACTION = 0][TIME/@DAYTYPE = $dayOfWeek]/TIME/@HOURS, '00'), format-number(/H2G2/SITE/OPENCLOSETIMES/EVENT[@ACTION = 0][TIME/@DAYTYPE = $dayOfWeek]/TIME/@MINUTES, '00')))"/>
        <xsl:variable name="closed" select="number(concat(format-number(/H2G2/SITE/OPENCLOSETIMES/EVENT[@ACTION = 1][TIME/@DAYTYPE = $dayOfWeek]/TIME/@HOURS, '00'), format-number(/H2G2/SITE/OPENCLOSETIMES/EVENT[@ACTION = 1][TIME/@DAYTYPE = $dayOfWeek]/TIME/@MINUTES, '00')))"/>
        <xsl:choose>
          <!-- I don't know WHY I have to do this... will figure out later -->
          <xsl:when test="(string($open) = 'NaN') or (string($closed) = 'NaN')">
            <xsl:value-of select="false()"/>
          </xsl:when>
          <xsl:when test="$open = 0 and $closed = 0">
            <xsl:value-of select="true()"/>
          </xsl:when>
          <xsl:when test="$now &gt; $open and $now &lt; $closed">
            <xsl:value-of select="false()"/>
          </xsl:when>
          <xsl:when test="$open != 0 and $open &gt; $closed">
          	<xsl:value-of select="false()"/>
          </xsl:when>
          <xsl:otherwise>
           <xsl:value-of select="true()"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="false()"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  
</xsl:stylesheet>
