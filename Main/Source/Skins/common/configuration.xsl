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

	<!-- local --> 
	<xsl:variable name="serverenvironment">
		<xsl:text>local</xsl:text>
	</xsl:variable>
	
	
	<!-- live
	<xsl:variable name="serverenvironment">
		<xsl:text>live</xsl:text>
	</xsl:variable>
	 -->

	<!-- stage
	<xsl:variable name="serverenvironment">
		<xsl:text>stage</xsl:text>
	</xsl:variable>
	 -->

	<!-- test
	<xsl:variable name="serverenvironment">
		<xsl:text>test</xsl:text>
	</xsl:variable>
	 -->

	<!-- int
	<xsl:variable name="serverenvironment">
		<xsl:text>int</xsl:text>
	</xsl:variable>
	 -->

	<xsl:variable name="urlenv">
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

	<xsl:variable name="baseurl">
		<xsl:choose>
			<xsl:when test="$serverenvironment = 'int'">
				<xsl:text>http://www.int.bbc.co.uk</xsl:text>
			</xsl:when>
			<xsl:when test="$serverenvironment = 'test'">
				<xsl:text>http://www.test.bbc.co.uk</xsl:text>
			</xsl:when>
			<xsl:when test="$serverenvironment = 'stage'">
				<xsl:text>http://www.stage.bbc.co.uk</xsl:text>
			</xsl:when>
			<xsl:when test="$serverenvironment = 'local'">
				<xsl:text>http://local.bbc.co.uk</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>http://www.bbc.co.uk</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<xsl:variable name="securebaseurl">
		<xsl:choose>
			<xsl:when test="$serverenvironment = 'int'">
				<xsl:text>https://ssl.int.bbc.co.uk</xsl:text>
			</xsl:when>
			<xsl:when test="$serverenvironment = 'test'">
				<xsl:text>https://ssl.test.bbc.co.uk</xsl:text>
			</xsl:when>
			<xsl:when test="$serverenvironment = 'stage'">
				<xsl:text>https://ssl.stage.bbc.co.uk</xsl:text>
			</xsl:when>
			<xsl:when test="$serverenvironment = 'local'">
				<xsl:text>https://local.bbc.co.uk</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>https://ssl.bbc.co.uk</xsl:text>
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
				<xsl:text>https://ssl</xsl:text><xsl:value-of select="$urlenv"/><xsl:text>.bbc.co.uk/id</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>https://id</xsl:text><xsl:value-of select="$urlenv"/><xsl:text>.bbc.co.uk</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

  <xsl:variable name="globalconfiguration">
    <host>
		<!-- edit as appropriate -->
		<!-- live is blank <url></url> -->
		<!--<url>http://local.bbc.co.uk</url>
		<sslurl>https://local.bbc.co.uk</sslurl>-->
		<url>
			<xsl:value-of select="$baseurl"/>
		</url>
		<sslurl>
			<xsl:value-of select="$securebaseurl"/>
		</sslurl>
    </host>
    <sso>
      <url>http://ops-dev14.national.core.bbc.co.uk/cgi-perl/signon/mainscript.pl</url>
      <optional>vanilla</optional>
    </sso>
    <!-- 
            <sso>
                <url>http://www.bbc.co.uk/cgi-perl/signon/mainscript.pl</url>
                <optional>vanilla</optional>
            </sso>
        -->
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