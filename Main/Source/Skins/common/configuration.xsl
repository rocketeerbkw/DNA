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
    
    
   
    <xsl:variable name="globalconfiguration">
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
            <url>https://id.stage.bbc.co.uk</url>
        </identity>
        <!-- live 
        	<identity>
        		<url>https://id.bbc.co.uk</url>
        	</identity>-->
        
        <host>
            <!-- edit as appropriate -->
            <!-- live is blank <url></url> -->
            <url>http://local.bbc.co.uk</url>
          <!--url>http://dnarelease.national.core.bbc.co.uk</url -->
            <sslurl>https://local.bbc.co.uk</sslurl>
            <!-- <url>http://ops-dev14.national.core.bbc.co.uk:6666</url> -->
        </host>
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