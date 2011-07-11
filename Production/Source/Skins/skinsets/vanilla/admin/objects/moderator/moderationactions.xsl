<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	version="1.0"
	xmlns:doc="http://www.bbc.co.uk/dna/documentation"
	xmlns="http://www.w3.org/1999/xhtml"
	exclude-result-prefixes="doc">

  <xsl:template name="moderation_actions">
   
    <fieldset class="dna-fl dna-search-userlist">
      <div>
        <label for="userStatusDescription">Moderation status:  </label>
        <select id="userStatusDescription" name="userStatusDescription">
          <option value="Standard">
            <xsl:if test="USERREPUTATION/REPUTATIONDETERMINEDSTATUS = 'Standard'">
              <xsl:attribute name="selected">selected</xsl:attribute>
            </xsl:if>
            Standard
          </option>
          <option value="Premoderated">
            <xsl:if test="USERREPUTATION/REPUTATIONDETERMINEDSTATUS = 'Premoderate'">
              <xsl:attribute name="selected">selected</xsl:attribute>
            </xsl:if>
            Premoderate
          </option>
          <option value="Postmoderated">
            <xsl:if test="USERREPUTATION/REPUTATIONDETERMINEDSTATUS = 'Postmoderated'">
              <xsl:attribute name="selected">selected</xsl:attribute>
            </xsl:if>
            Postmoderate
          </option>
          <option value="Restricted">
            <xsl:if test="USERREPUTATION/REPUTATIONDETERMINEDSTATUS = 'Restricted'">
              <xsl:attribute name="selected">selected</xsl:attribute>
            </xsl:if>
            Banned
          </option>
          <xsl:if test="/H2G2/VIEWING-USER/USER/STATUS = '2'">
            <option value="Deactivated">Deactivate</option>
          </xsl:if>
        </select>
      </div>
      <div id="durationContainer">
        <label for="duration">Duration:</label>
        <select id="duration" name="duration">
          <option value="0" selected="selected">no limit</option>
          <option value="1440">1 day</option>
          <option value="10080">1 week</option>
          <option value="20160">2 weeks</option>
          <option value="40320">1 month</option>
        </select>
      </div>
      <div id="hideAllPostsContainer">
        <label for="hideAllPosts">Hide all content: </label>
        <input type="checkbox" name="hideAllPosts" id="hideAllPosts" />
      </div>
      <div>
        <label for="reasonChange">Reason for change:</label>
        <select id="reasonChange" name="reasonChange">
          <option value=""></option>
          <option value="Spam">Spam</option>
          <option value="Advertising">Advertising</option>
          <option value="Off topic">Off topic</option>
          <option value="Offensive">Offensive</option>
          <option value="Illegal activity">Illegal activity</option>
          <option value="Impersonation">Impersonation</option>
          <option value="Harassment">Harassment</option>
          <option value="Multiple accounts">Multiple accounts</option>
          <option value="Re-registered user">Re-registered user</option>
          <option value="Under or over age">Under or over age</option>
          <option value="Complaints abuse">Complaints abuse</option>
          <option value="Custom (otherwise disruptive)">Custom (otherwise disruptive)</option>

          <xsl:if test="/H2G2/USERREPUTATION">
            <option value="User Reputation Determined" selected="selected">
              <xsl:attribute name="selected">selected</xsl:attribute>
              User Reputation Determined
            </option>
          </xsl:if>
        </select>
      </div>
      <div>
        <label for="additionalNotes">Additional Notes:</label>
        <textarea id="additionalNotes" name="additionalNotes" cols="50" rows="3">
          <xsl:text>&#x0A;</xsl:text>
        </textarea>
      </div>
      <xsl:if test="/H2G2/USERREPUTATION">
      <div id="hideAllSitesContainer">
        <label for="hideAllSites">Hide on all sites: </label>
        <input type="checkbox" name="hideAllSites" id="hideAllSites" />
      </div>
      </xsl:if>
    </fieldset>
    
  </xsl:template>	
</xsl:stylesheet>
