<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	version="1.0" 
	xmlns:doc="http://www.bbc.co.uk/dna/documentation" 
	xmlns="http://www.w3.org/1999/xhtml" 
	exclude-result-prefixes="doc">
	
	<xsl:template match="H2G2[@TYPE = 'USERREPUTATIONREPORT']" mode="page">
    
		<xsl:call-template name="objects_links_breadcrumb">
			<xsl:with-param name="pagename" >User Reputation Report</xsl:with-param>
		</xsl:call-template>    

		<div class="dna-mb-intro blq-clearfix">
			<div class="dna-userlist dna-fl dna-main-full">
				<p>This report displays the users whose moderation status should be changed based on their reputation.</p>
				<form action="userreputationreport" method="get">
					<fieldset class="dna-fl dna-search-userlist">
						<label>Days:</label>
            <select id="s_days" name="s_days">
              <option value="1">
                <xsl:if test="USERREPUTATIONLIST/@DAYS='1'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
                1</option>
              <option value="3">
                <xsl:if test="USERREPUTATIONLIST/@DAYS='3'">
                  <xsl:attribute name="selected">selected</xsl:attribute>
                </xsl:if>
                3</option>
              <option value="7">
                <xsl:if test="USERREPUTATIONLIST/@DAYS='7'">
                  <xsl:attribute name="selected">selected</xsl:attribute>
                </xsl:if>
                7</option>
            </select>
					</fieldset>
          <fieldset class="dna-fl dna-search-userlist">
            <label>Moderation Class:</label>
            <select id="s_modclassid" name="s_modclassid">
              <option value="0">All</option>
              <xsl:apply-templates select="MODERATION-CLASSES/MODERATION-CLASS" mode="moderation_class_select"/>
            </select>
          </fieldset>
          <fieldset class="dna-fl dna-search-userlist">
            <label>Recommended Status:</label>
            <select id="s_modstatus" name="s_modstatus">
              
              <xsl:apply-templates select="USERREPUTATIONLIST" mode="search_modstatus"/>
            </select>
          </fieldset>
					<div class="dna-fr dna-buttons">
						<span class="dna-buttons"><input type="submit" value="Go" /></span>
					</div>
				</form>	
					<xsl:choose>
						<xsl:when test="count(/H2G2/USERREPUTATIONLIST/USERS/USERREPUTATION) = 0">
							<p>No users requiring adjustment.</p>
						</xsl:when>
					</xsl:choose>
			</div>
		</div>

    <xsl:choose>
					<xsl:when test="count(/H2G2/USERREPUTATIONLIST/USERS/USERREPUTATION) != 0">
						<form action="userreputationreport?s_modclassid={USERREPUTATIONLIST/@MODCLASSID}&amp;s_modstatus={USERREPUTATIONLIST/@MODSTATUS}&amp;s_days={USERREPUTATIONLIST/@DAYS}" method="post" id="reputationForm" class="dna-fl dna-main-full">		
							<div class="dna-main dna-main-bg dna-main-pad blq-clearfix">
								<div class="dna-fl dna-main-full">
									<div class="dna-box">
										<h3>Users Found</h3>
										<xsl:apply-templates select="USERREPUTATIONLIST" />
									</div>
								</div>
							</div>
						</form>
					</xsl:when>
				</xsl:choose>
	</xsl:template>

	<xsl:template match="USERREPUTATIONLIST">
		<div class="dna-fl dna-main-full">
			<p><strong><xsl:value-of select="@TOTALITEMS"/> instances found.</strong></p>
      <xsl:apply-templates select="." mode="library_pagination_userreputationlist"/>
			<table class="dna-dashboard-activity dna-userlist">
				<thead>
					<tr>
						<th class="narrow"><label for="applyToAll">All</label><input type="checkbox" name="applyToAll" id="applyToAll" /></th>
						<th>User</th>
						<th>
              <xsl:call-template name="sortTermsReputation">
                <xsl:with-param name="sortBy">Score</xsl:with-param>
              </xsl:call-template>
            </th>
						<th>Current Status</th>
						<th>Reputation Status</th>
						<th>
              <xsl:call-template name="sortTermsReputation">
                <xsl:with-param name="sortBy">Last Updated</xsl:with-param>
              </xsl:call-template></th>
						<th class="mid"></th>
					</tr>
				</thead>
				<tbody>	
					<xsl:apply-templates select="USERS/USERREPUTATION" />
				</tbody>
			</table>
      <xsl:apply-templates select="." mode="library_pagination_userreputationlist"/>
			<p><strong><xsl:value-of select="@TOTALITEMS"/> instances found.</strong></p>
      <input type="submit" value="Apply action to all select users" id="ApplyAction" name="ApplyAction"/>
		</div>
	</xsl:template>
	
	<xsl:template match="USERREPUTATION">
		<tr>
			<xsl:call-template name="objects_stripe" />	
			<td>
				<h4 class="blq-hide">Instance number <xsl:value-of select="position()" /></h4>
				<input type="checkbox" name="applyTo|{position()}" id="applyTo|{position()}" class="applyToCheckBox"/>
			</td>
			<td>
        <input type="hidden" id="{position()}|userid" name="{position()}|userid" value="{USERID}"/>
        <input type="hidden" id="{position()}|modclassid" name="{position()}|modclassid" value="{MODERATIONCLASS/@CLASSID}"/>
        <a href="memberdetails?userid={USERID}">
          <xsl:value-of select="USERNAME"/>
        </a>
			</td>
			<td>
        <xsl:value-of select="REPUTATIONSCORE"/>
			</td>
			<td>
        <xsl:apply-templates select="CURRENTSTATUS" mode="objects_user_typeicon" />
      </td>
			<td>
        <input type="hidden" id="{position()}|reputationdeterminedstatus" name="{position()}|reputationdeterminedstatus" value="{REPUTATIONDETERMINEDSTATUS}"/>
        <xsl:apply-templates select="REPUTATIONDETERMINEDSTATUS" mode="objects_user_typeicon" />
      </td>
			<td>
        <xsl:choose>
          <xsl:when test="LASTUPDATED">
            <xsl:value-of select="concat(LASTUPDATED/DATE/@DAY, '/',LASTUPDATED/DATE/@MONTH,'/',LASTUPDATED/DATE/@YEAR)"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>-</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </td>
			<td>
        <a href="HostDashboardUserActivity?s_user={USERID}&amp;s_modclassid={MODERATIONCLASS/@CLASSID}">
          View Reputation Details
        </a>
			</td>			
		</tr>
	</xsl:template>

  <xsl:template match="MODERATION-CLASS" mode="moderation_class_select">
    <option>
      <xsl:attribute name="value">
        <xsl:value-of select="@CLASSID"/>
      </xsl:attribute>
      <xsl:if test="/H2G2/USERREPUTATIONLIST/@MODCLASSID = @CLASSID">
        <xsl:attribute name="selected">selected</xsl:attribute>
      </xsl:if>
      <xsl:value-of select="NAME"/>
    </option>
  </xsl:template>

  <xsl:template match="USERREPUTATIONLIST" mode="search_modstatus">
    <option value="-10">
      <xsl:if test="@MODSTATUS = '-10'">
        <xsl:attribute name="selected">selected</xsl:attribute>
      </xsl:if>
      All
    </option>
    <option value="Standard">
      <xsl:if test="@MODSTATUS = '0'">
        <xsl:attribute name="selected">selected</xsl:attribute>
      </xsl:if>
      Standard
    </option>
    <option value="Premoderated">
      <xsl:if test="@MODSTATUS = '1'">
        <xsl:attribute name="selected">selected</xsl:attribute>
      </xsl:if>
      Premoderate
    </option>
    <option value="Postmoderated">
      <xsl:if test="@MODSTATUS = '2'">
        <xsl:attribute name="selected">selected</xsl:attribute>
      </xsl:if>
      Postmoderate
    </option>
    <option value="Restricted">
      <xsl:if test="@MODSTATUS = '4'">
        <xsl:attribute name="selected">selected</xsl:attribute>
      </xsl:if>
      Banned
    </option>
    <option value="Trusted">
      <xsl:if test="@MODSTATUS = '6'">
        <xsl:attribute name="selected">selected</xsl:attribute>
      </xsl:if>
      Trusted
    </option>
  </xsl:template>

  <xsl:template name="sortTermsReputation">
    <!-- declare that it takes two parameters 
	  - the string and the char -->
    <xsl:param name="sortBy" />
    <xsl:param name="sortByEnum">
      <xsl:choose>
        <!-- if the string contains the character... -->
        <xsl:when test="$sortBy ='Score'">ReputationScore</xsl:when>
        <!-- otherwise, return the value of the string -->
        <xsl:otherwise>Created</xsl:otherwise>
      </xsl:choose>
    </xsl:param>
    <xsl:param name="sortDirection">
      <xsl:choose>
        <xsl:when test="/H2G2/PARAMS/PARAM[NAME='s_sortDirection']/VALUE = 'Descending'">Ascending</xsl:when>
        <xsl:otherwise>Descending</xsl:otherwise>
      </xsl:choose>
    </xsl:param>

    <xsl:variable name="querystring">
      <xsl:value-of select="concat(concat('&amp;s_modclassid=', @MODCLASSID),concat('&amp;s_days=', @DAYS), concat('&amp;s_modstatus=', @MODSTATUS))"/>
    </xsl:variable>

    <a>
      <xsl:attribute name="href">
        <xsl:value-of select="concat('userreputationreport?', $querystring, '&amp;s_sortDirection=',$sortDirection, '&amp;s_sortBy=', $sortByEnum)"/>
      </xsl:attribute>
      <xsl:value-of select="$sortBy"/>
    </a>
  </xsl:template>

</xsl:stylesheet>
