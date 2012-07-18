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
	
  
	<xsl:template match="H2G2[@TYPE = 'ERROR']" mode="page">
    <div class="dna-error-box dna-main dna-main-bg dna-main-pad blq-clearfix">

      <xsl:choose>
        <xsl:when test="ERROR/@TYPE='NotSecure'">
          <h2>Secure Session Required</h2>
        </xsl:when>
        <xsl:when test="SITE/SITEOPTIONS/SITEOPTION[NAME='IsMessageboard']/VALUE='0'">
          <h2>Welcome to the Host Dashboard</h2>
        </xsl:when>
        <xsl:otherwise>
          <h2>Welcome to the Messageboard Admin Tool</h2>
        </xsl:otherwise>
      </xsl:choose>
      

      <div class="dna-box">

        <xsl:apply-templates select="/H2G2/VIEWING-USER" mode="library_identity_cta">
          <xsl:with-param name="signin-text">
            <xsl:value-of select="'to BBC iD to use this service.'" />
          </xsl:with-param>
        </xsl:apply-templates>

        <xsl:choose>
          <xsl:when test="ERROR/@TYPE='NotSecure'">
            <p>To access this page, you must use a secure request as it may include some private user information.</p>

            <p>To do this, in the address bar above, please change the beginning of the address from <b>"http://www.bbc.co.uk"</b> to <b>"https://ssl.bbc.co.uk"</b> and resubmit your request.</p>

            <p>If you have arrived to this page from a link, please submit a bug to the Social Publishing Team.</p>
          </xsl:when>
          <xsl:when test="SITE/SITEOPTIONS/SITEOPTION[NAME='IsMessageboard']/VALUE='0'">
            <p>
              You need to be granted the appropriate permissions to use this tool.<br />If you are having trouble logging in, please contact your <strong>social media representative</strong>.
            </p>
          </xsl:when>
          <xsl:otherwise>
            <p>
              You need to be granted the appropriate permissions to use this tool.<br />If you are having trouble logging in, please refer to our <a href="https://confluence.dev.bbc.co.uk/display/DNA/Messageboards+Admin+Tool+-+User+Guide" class="dna-openNewWindow">user guide</a> or contact your <strong>social media representative</strong>.
            </p>
          </xsl:otherwise>
        </xsl:choose>
      </div>
    </div>
  </xsl:template>

  <xsl:template match="/H2G2[@TYPE != 'ERROR']/ERROR" mode="page">
    <xsl:variable name="topicId" select="//PARAMS/PARAM[NAME = 's_edittopic']/VALUE" />
    
    <p class="dna-error">An error has occurred - 
      <xsl:choose>
        <xsl:when test="@TYPE = 'InvalidWelcomeMessage'"><a href="#dna-preview-addwelcome">Add a welcome message</a></xsl:when>
        <xsl:when test="@TYPE = 'InvalidAboutMessage'"><a href="#dna-preview-about">Add your introduction/about text</a></xsl:when>
        <xsl:when test="@TYPE = 'InvalidOpenCloseMessage'"><a href="#dna-preview-topic-edit-{$topicId}">Add opening/closing times</a></xsl:when>
        <xsl:when test="@TYPE = 'TopicElementTitleMissing'"><a href="#dna-preview-topic-edit-{$topicId}">Add a topic promo title</a></xsl:when>
        <xsl:when test="@TYPE = 'TopicElementTextMissing'"><a href="#dna-preview-topic-edit-{$topicId}">Add a topic description</a></xsl:when>
        <xsl:when test="@TYPE = 'TopicTitleMissing'"><a href="#dna-preview-topic-edit-{$topicId}">Add the title of the topic page</a></xsl:when>
        <xsl:when test="@TYPE = 'TopicDescriptionMissing'"><a href="#dna-preview-topic-edit-{$topicId}">Add the topic page description</a></xsl:when>
        <xsl:when test="@TYPE = 'ImageNameMissing'"><a href="#dna-preview-topic-edit-{$topicId}">Add a topic promo image</a></xsl:when>
        <xsl:when test="@TYPE = 'AltTextMissing'"><a href="#dna-preview-topic-edit-{$topicId}">Provide an alt text</a></xsl:when>
        <xsl:when test="@CODE = 'UserNotLoggedIn'">You are not logged in</xsl:when>
		<xsl:when test="@TYPE = 'TWITTERRETRIEVEUSERINVALIDACTION'">
			<xsl:variable name="tweetusername" select="ERRORLINKPARAMETER"/>
			<xsl:value-of select="ERRORMESSAGE"/><a href="UserList?searchText={$tweetusername}&amp;usersearchtype=6">User List</a>
		</xsl:when>
        <xsl:otherwise><xsl:value-of select="ERRORMESSAGE"/></xsl:otherwise>
      </xsl:choose>
    </p>
  </xsl:template>

  <xsl:template match="/H2G2/RESULT" mode="page">
  	<xsl:variable name="sitetype" select="/H2G2/TWITTERPROFILE/@SITENAME" />
    <xsl:choose>
    	<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_action']/VALUE = 'getprofile'">
			<xsl:choose>
				<xsl:when test="@TYPE = 'TwitterProfileRetrieved'">
					<p class="dna-no-error"><xsl:value-of select="/H2G2/RESULT/MESSAGE"/></p>
				</xsl:when>
			</xsl:choose>
    	</xsl:when>
		<xsl:otherwise>
		    <xsl:choose>
			    <xsl:when test="@TYPE = 'TwitterProfileCreated'">
			    
			    	<xsl:variable name="profiletype">
			    		<xsl:choose>
			    			<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_action']/VALUE = 'updateprofile'">
			    				<xsl:text>updated</xsl:text>
			    			</xsl:when>
			    			<xsl:otherwise>
			    				<xsl:text>created</xsl:text>
			    			</xsl:otherwise>
			    		</xsl:choose>
			    	</xsl:variable>
			    	<p class="dna-no-error">Your Twitter profile has been <xsl:value-of select="$profiletype" />. Return to the <a href="twitterprofilelist?type={$sitetype}">Twitter Profile List</a>.</p>
			    </xsl:when>
			    <xsl:otherwise>
					<p class="dna-no-error">Your Twitter profile has been updated. Return to the <a href="twitterprofilelist?type={$sitetype}">Twitter Profile List</a>.</p>
			    </xsl:otherwise>
		    </xsl:choose>		
		</xsl:otherwise>    
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
