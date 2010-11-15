<!DOCTYPE xsl:stylesheet [
  <!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
  <!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
									Page - Level  template
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->

  <xsl:template match="H2G2[@TYPE = 'MEMBERDETAILS']" mode="page">
    <div class="dna-mb-intro">
      <h2>DNA Member Details</h2>
      Below is the list of posts and details of user.
    </div>

    <div class="dna-main blq-clearfix">
      <div class="dna-memberdetails dna-main-full">
        
        <div id="mainContent">
          <xsl:apply-templates select="MEMBERDETAILSLIST" mode="main_info"/>
          <xsl:apply-templates select="MEMBERDETAILSLIST/SUMMARY" mode="main_info"/>
        </div>
      </div>
    </div>
  </xsl:template>

  <!-- 
	<xsl:template match="USERS-DETAILS" mode="main_info">
	Author:		Andy Harris
	Context:     /H2G2/USERS-DETAILS
	Purpose:	 Template which displays the main section of the user info page
	-->
  <xsl:template match="MEMBERDETAILSLIST" mode="main_info">
    <h3>Member Details</h3>
    <xsl:variable name="userid">
      <xsl:value-of select="@USERID"/>
    </xsl:variable>
    <div id="memberDetails">
      <div style="float:right" align="right">
        <p>
          <a href="usercontributions?s_userid={$userid}">View contributions</a>
          <br/>
          <a href="MemberDetails?userid={$userid}">Find Alternate Identities using Email</a>
          <BR/>
          <a href="MemberDetails?userid={$userid}&amp;findbbcuidaltidentities=1">Find Alternate Identities using BBCUID</a>
        </p>
      </div>
      <div style="float:left" align="left">
        <h2 class="noLine">name</h2>
        <p>
          <xsl:choose>
            <xsl:when test="not(string-length(MEMBERDETAILS/USER[USERID=$userid]/USERNAME) = 0)">
              <xsl:value-of select="MEMBERDETAILS/USER[USERID=$userid]/USERNAME"/>
            </xsl:when>
            <xsl:otherwise>No username</xsl:otherwise>
          </xsl:choose>
        </p>
        <h2 class="noLine">user ID</h2>
        <p>
          <xsl:value-of select="$userid"/>
        </p>
        <h2 class="noLine">Email</h2>
        <p>
          <xsl:choose>
            <xsl:when test="not(string-length(MEMBERDETAILS/USER[USERID=$userid]/EMAIL) = 0)">
              <xsl:value-of select="MEMBERDETAILS/USER[USERID=$userid]/EMAIL"/>
            </xsl:when>
            <xsl:otherwise>No Email</xsl:otherwise>
          </xsl:choose>
        </p>
      </div>
    </div>
    <div style="clear:both;">
      <p>
        <h4>
          Identities for <xsl:value-of select="$userid"/>:
        </h4>
      </p>
      
      <table class="postItems" cellspacing="6" width="100%">
          <tr class="infoBar">
          <th>UserId</th>
          <th>UserName</th>
          <th>Site</th>
          <th>Status</th>
          <th>DateJoined</th>
          <th>Posts Passed</th>
          <th>Posts Failed</th>
          <th>Total Posts</th>
          <th>Articles Passed</th>
          <th>Articles Failed</th>
          <th>Total Articles</th>
        </tr>
        <xsl:apply-templates select="MEMBERDETAILS"/>
      </table>
    </div>
  </xsl:template>

  <xsl:template match="SUMMARY" mode="main_info">
    <h4>User Summary</h4>

    <table class="postItems" cellspacing="6" width="100%">
     
      <tr>
        <td>Posts Passed</td>
        <td>
          <xsl:value-of select="POSTPASSEDCOUNT"/>
        </td>
      </tr>
      <tr>
        <td>Posts Failed</td>
        <td>
          <xsl:value-of select="POSTFAILEDCOUNT"/>
        </td>
      </tr>
      <tr>
        <td>Total Posts</td>
        <td>
          <xsl:value-of select="POSTTOTALCOUNT"/>
        </td>
      </tr>
      <tr>
        <td>Articles Passed</td>
        <td>
          <xsl:value-of select="ARTICLEPASSEDCOUNT"/>
        </td>
      </tr>
      <tr>
        <td>Articles Failed</td>
        <td>
          <xsl:value-of select="ARTICLEFAILEDCOUNT"/>
        </td>
      </tr>
      <tr>
        <td>Total Articles</td>
        <td>
          <xsl:value-of select="ARTICLETOTALCOUNT"/>
        </td>
      </tr>
    </table>
  </xsl:template>
  
  <!-- 
	<xsl:template match="ALT-IDENTITIES" mode="this_site">
	Author:		Andy Harris
	Context:     /H2G2/USERS-DETAILS/USER-POST-HISTORY-SUMMARY
	Purpose:	 Template which displays the alternative identities of the user on this site
	-->
  <xsl:template match="MEMBERDETAILS">
    <xsl:variable name="userid" select="USER/USERID"/>
    <xsl:variable name="sitename">
      <xsl:value-of select="SITE/NAME"/><xsl:text>/</xsl:text>
    </xsl:variable>
    <tr>
      <td>
        <a href="UserList?searchText={$userid}&amp;usersearchtype=0">
          <xsl:value-of select="USER/USERID"/>
        </a>
      </td>
      <td>
        <xsl:value-of select="USER/USERNAME"/>
      </td>
      <td>
        <xsl:value-of select="SITE/NAME"/>
      </td>
      <td align="center">
          <xsl:apply-templates select="USER/STATUS" mode="user_status"/>
          <xsl:apply-templates select="USER/GROUPS" mode="user_groups"/>    
      </td>
      <td>
        <xsl:apply-templates select="DATEJOINED/DATE"/>
      </td>
      <td align="center">
        <xsl:value-of select="POSTPASSEDCOUNT"/>
      </td>
      <td align="center">
        <xsl:value-of select="POSTFAILEDCOUNT"/>
      </td>
      <td align="center">
        <a href="usercontributions?s_userid={$userid}&amp;s_siteid={SITE/@ID}">
          <xsl:value-of select="POSTTOTALCOUNT"/>
        </a>
      </td>
      <td align="center">
        <xsl:value-of select="ARTICLEPASSEDCOUNT"/>
      </td>
      <td align="center">
        <xsl:value-of select="ARTICLEFAILEDCOUNT"/>
      </td>
      <td align="center">
        <a href="/dna/{SITE/URLNAME}/MA{$userid}?type=2" target="_blank">
          <xsl:value-of select="ARTICLETOTALCOUNT"/>
        </a>
      </td>
    </tr>
  </xsl:template>
</xsl:stylesheet>