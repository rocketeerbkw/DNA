<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"  xmlns:doc="http://www.bbc.co.uk/dna/documentation" exclude-result-prefixes="doc">

  <doc:documentation>
    <doc:purpose>
      Provide site specific configuration details for xsl
    </doc:purpose>
    <doc:context>
      First included in required/required.xsl
    </doc:context>
    <doc:notes>
      Simply stored as xml. Did consider using a proper xml file and
      calling it via document() however memory overhead is unreliable
      / undocumented especially across large scale deployments.

      Access at runtime by using $configuration/
    </doc:notes>
  </doc:documentation>

	<xsl:variable name="serverenvironment">
		<xsl:text>live</xsl:text>
	</xsl:variable>
	

	<xsl:variable name="idurlenv">
		<xsl:choose>
			<xsl:when test="$serverenvironment = 'int'">
				<xsl:text>.int</xsl:text>
			</xsl:when>
			<xsl:when test="$serverenvironment = 'test' or $serverenvironment = 'local'">
				<xsl:text>.test</xsl:text>
			</xsl:when>
			<xsl:when test="$serverenvironment = 'stage'">
				<xsl:text>.stage</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text></xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<xsl:variable name="idURL">
		<xsl:choose>
			<xsl:when test="$serverenvironment = 'live'">
				<xsl:choose>
					<xsl:when test="/H2G2/SITE/SITEOPTIONS/SITEOPTION[NAME='UseIDV4']/VALUE = '1'">
						<xsl:text>https://ssl.bbc.co.uk/id</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>https://id.bbc.co.uk</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="/H2G2/SITE/SITEOPTIONS/SITEOPTION[NAME='UseIDV4']/VALUE = '1'">
				<xsl:text>https://ssl</xsl:text><xsl:value-of select="$idurlenv"/><xsl:text>.bbc.co.uk/id</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>https://id</xsl:text><xsl:value-of select="$idurlenv"/><xsl:text>.bbc.co.uk</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:if test="contains(/H2G2/SITE/IDENTITYPOLICY, 'u16comment')">/cbbc</xsl:if>
	</xsl:variable>

  <xsl:variable name="globalconfiguration">
    <host>
            <url>http://www.bbc.co.uk</url>
            <sslurl>https://ssl.bbc.co.uk</sslurl>
    </host>
            <sso>
                <url>http://www.bbc.co.uk/cgi-perl/signon/mainscript.pl</url>
                <optional>vanilla</optional>
            </sso>

    <identity>
      <xsl:choose>
        <xsl:when test="/H2G2/SITE/SITEOPTIONS/SITEOPTION[NAME='signinurl']">
          <url><xsl:value-of select="/H2G2/SITE/SITEOPTIONS/SITEOPTION[NAME='signinurl']/VALUE"/></url>
        </xsl:when>
        <xsl:otherwise>
          <url><xsl:value-of select="$idURL"></xsl:value-of></url>
        </xsl:otherwise>
      </xsl:choose>
    </identity>
  </xsl:variable>

  <xsl:variable name="houserulespopupurl">
    <xsl:choose>
      <xsl:when test="/H2G2/SITE/IDENTITYSIGNIN='1' and /H2G2/SITE/IDENTITYPOLICY='http://identity/policies/dna/over13'">
        <xsl:text>http://www.bbc.co.uk/messageboards/newguide/popup_house_rules_teens.html</xsl:text>
      </xsl:when>
      <xsl:when test="/H2G2/SITE/IDENTITYSIGNIN='1' and /H2G2/SITE/IDENTITYPOLICY='http://identity/policies/dna/schools'">
        <xsl:text>http://www.bbc.co.uk/messageboards/newguide/popup_house_rules_schools.html</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <!-- Default to adult -->
        <xsl:text>http://www.bbc.co.uk/messageboards/newguide/popup_house_rules.html</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="faqpopupurl">
    <xsl:text>http://www.bbc.co.uk/messageboards/newguide/popup_faq_index.html</xsl:text>
  </xsl:variable>

</xsl:stylesheet>