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

  <xsl:template name="MEMBERDETAILS_MAINBODY">
    <ul id="classNavigation">
      <xsl:for-each select="/H2G2/MODERATION-CLASSES/MODERATION-CLASS">
        <li>
          <xsl:attribute name="class">
            <xsl:choose>
              <xsl:when test="@CLASSID = /H2G2/PARAMS/PARAM[NAME = 's_classview']/VALUE">selected</xsl:when>
              <xsl:otherwise>unselected</xsl:otherwise>
            </xsl:choose>
          </xsl:attribute>
          <xsl:attribute name="id">
            modClass<xsl:value-of select="@CLASSID"/>
          </xsl:attribute>
          <a href="#">
            <xsl:attribute name="href">
              memberdetails?userid=<xsl:value-of select="/H2G2/USERS-DETAILS/@ID"/>&amp;siteid=<xsl:value-of select="/H2G2/USERS-DETAILS/@SITEID"/>&amp;s_classview=<xsl:value-of select="@CLASSID"/>
            </xsl:attribute>
            <xsl:value-of select="NAME"/>
          </a>
        </li>
      </xsl:for-each>
    </ul>
    <div id="mainContent">
      <xsl:apply-templates select="ERROR" mode="errormessage"/>
      <xsl:apply-templates select="MEMBERDETAILSLIST" mode="main_info"/>
      <xsl:apply-templates select="MEMBERDETAILSLIST/SUMMARY" mode="main_info"/>
    </div>
  </xsl:template>

  <xsl:template match="ERROR" mode="errormessage">
    <p>
      <xsl:value-of select="@TYPE"/> -
      <xsl:value-of select="ERRORMESSAGE"/>
    </p>
  </xsl:template>
  <!-- 
	<xsl:template match="USERS-DETAILS" mode="main_info">
	Author:		Andy Harris
	Context:     /H2G2/USERS-DETAILS
	Purpose:	 Template which displays the main section of the user info page
	-->
  <xsl:template match="MEMBERDETAILSLIST" mode="main_info">
    <xsl:variable name="userid">
      <xsl:value-of select="@USERID"/>
    </xsl:variable>
    <div id="memberDetails">
      <div align="right">
        <p>
          <a href="MemberDetailsAdmin?userid={$userid}">Find Alternate Identities using Email</a>
          <BR/>
          <a href="MemberDetailsAdmin?userid={$userid}&amp;findbbcuidaltidentities=1">Find Alternate Identities using BBCUID</a>
        </p>
      </div>
      <div align="left">
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
      <p>
        <h2>
          Identities for <xsl:value-of select="$userid"/>:
        </h2>
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
    <table class="postItems" cellspacing="6" width="100%">
      <tr class="infoBar">
        <th colspan="2">User Summary</th>
      </tr>
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
        <a href="{$root}MemberList?userid={$userid}">
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
        <a href="{$rootbase}{$sitename}MP{$userid}">
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
        <a href="{$rootbase}{$sitename}MA{$userid}?type=2">
          <xsl:value-of select="ARTICLETOTALCOUNT"/>
        </a>
      </td>
    </tr>
  </xsl:template>
</xsl:stylesheet>