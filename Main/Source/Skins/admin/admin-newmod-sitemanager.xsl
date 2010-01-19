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

  <xsl:template name="SITEMANAGER_MAINBODY">
    <xsl:apply-templates select="ERROR" mode="errormessage"/>
    <div id="mainContent">
      <xsl:apply-templates select="SITEMANAGER" mode="main_info"/>
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
  <xsl:template match="SITEMANAGER" mode="main_info">
    <form method="post" action="SiteManager">
      <table cellspacing="5">
        <tr>
          <td align="right">Select Site:</td>
          <td>
            <xsl:apply-templates select="/H2G2/SITE-LIST" mode="select"/>
            <input type="submit" value="Select"/>
          </td>
          <td>
            <a href="SiteOptions?siteid={/H2G2/SITEMANAGER/@SITEID}">Edit Site Options</a>
          </td>
        </tr>
        <tr>
          <td align="right">URL Name: </td>
          <td>
            <input type="text" name="urlname" value="{URLNAME}"/>
          </td>
        </tr>
        <tr>
          <td align="right">Short name:</td>
          <td>
            <input type="text" name="shortname" value="{SHORTNAME}"/>
          </td>
        </tr>
        <tr>
          <td align="right">Description:</td>
          <td>
            <input type="text" name="description" value="{DESCRIPTION}"/>
          </td>
        </tr>
        <tr>
          <td align="right">SSO Service:</td>
          <td>
            <input type="text" name="ssoservice" value="{SSOSERVICE}"/>
          </td>
        </tr>
        <tr>
          <td align="right">Default skin:</td>
          <td>
            <input type="text" name="defaultskin" value="{DEFAULTSKIN}"/>
          </td>
        </tr>
        <tr>
          <td align="right">Skinset:</td>
          <td>
            <input type="text" name="skinset" value="{SKINSET}"/>
          </td>
        </tr>
        <tr>
          <td align="right">Moderation:</td>
          <td>
            <select name="modstatus">
              <option value="1">
                <xsl:if test="UNMODERATED=1">
                  <xsl:attribute name="selected"/>
                </xsl:if> UnModerated</option>
              <option value="2">
              <xsl:if test="UNMODERATED=0 and PREMODERATED=0">
                <xsl:attribute name="selected"/>
              </xsl:if> PostModerated
              </option>
              <option value="3">
                <xsl:if test="PREMODERATED=1">
                  <xsl:attribute name="selected"/>
                </xsl:if> 
                PreModerated
              </option>
            </select>
          </td>
        </tr>
        <tr>
          <td align="right">Moderation Class:</td>
          <td>
            <select name="modclassid">
              <xsl:apply-templates select="/H2G2/MODERATION-CLASSES/MODERATION-CLASS" mode="selectmodclass"/>
            </select>
          </td>
          <td>
            <a href="ModerationClassAdmin">New Moderation Class</a>
          </td>
        </tr>
        <tr>
          <td align="right">Moderators email:</td>
          <td>
            <input type="text" name="ModeratorsEmail" value="{MODERATORSEMAIL}"/>
          </td>
        </tr>
        <tr>
          <td align="right">Editors email:</td>
          <td>
            <input type="text" name="EditorsEmail" value="{EDITORSEMAIL}"/>
          </td>
        </tr>
        <tr>
          <td align="right">Feedback email:</td>
          <td>
            <input type="text" name="FeedbackEmail" value="{FEEDBACKEMAIL}"/>
          </td>
        </tr>
        <tr>
          <td align="right">Auto Message User ID</td>
          <td>
            <input type="text" name="AutoMessageUserID" value="{AUTOMESSAGEUSERID}"/>
          </td>
        </tr>
        <tr>
          <td align="right">Event Alert Message User ID</td>
          <td>
            <input type="text" name="eventalertmessageuserid" value="{EVENTALERTMESSAGEUSERID}" />
          </td>
        </tr>
        <tr>
          <td align="right">Alert Email Subject</td>
          <td>
            <input type="text" name="EventEmailSubject" value="{EVENTEMAILSUBJECT}" />
          </td>
        </tr>
        <tr>
          <td align="right">Thread Edit Time Limit (minutes):</td>
          <td>
            <input type="text" name="ThreadEditTimeLimit" value="{THREADEDITTIMELIMIT}"/>
          </td>
        </tr>
        <tr>
          <td align="right">Thread Sort Order:</td>
          <td>
            <select name="threadorder">
              <option value="1">
                <xsl:if test="THREADSORTORDER!=2">
                  <xsl:attribute name="selected"/>
                </xsl:if>
                Last Posted
              </option>
              <option value="2">
                <xsl:if test="THREADSORTORDER=2">
                  <xsl:attribute name="selected"/>
                </xsl:if> 
                Date Created
              </option>
            </select>
          </td>
        </tr>
        <tr>
          <td align="right">Require Password:</td>
          <td>
            <input type="radio" name="passworded" value="1">
              <xsl:if test="PASSWORDED=1">
                <xsl:attribute name="checked"></xsl:attribute>
              </xsl:if>
            </input> Yes
            <input type="radio" name="passworded" value="0">
              <xsl:if test="PASSWORDED=0">
                <xsl:attribute name="checked"></xsl:attribute>
              </xsl:if>
            </input> No
          </td>
        </tr>
        <tr>
          <td align="right">Article Guest Book Forums:</td>
          <td>
            <input type="radio" name="articleforumstyle" value="1">
              <xsl:if test="ARTICLEFORUMSTYLE=1">
              <xsl:attribute name="checked"/>
              </xsl:if>
            </input> Yes
            <input type="radio" name="articleforumstyle" value="0">
              <xsl:if test="ARTICLEFORUMSTYLE=0">
                <xsl:attribute name="checked"/>
              </xsl:if>
            </input> No
          </td>
        </tr>
        <tr>
          <td align="right">Include crumbtrail:</td>
          <td>
            <input type="radio" name="includecrumbtrail" value="1">
              <xsl:if test="INCLUDECRUMBTRAIL=1">
                <xsl:attribute name="checked"/>
              </xsl:if>
            </input> Yes
            <input type="radio" name="includecrumbtrail" value="0">
              <xsl:if test="INCLUDECRUMBTRAIL=0">
                <xsl:attribute name="checked"/>
              </xsl:if>
            </input> No
          </td>
        </tr>
        <tr>
          <td align="right">Allow vote removal:</td>
          <td>
            <input type="radio" name="allowremovevote" value="1">
              <xsl:if test="ALLOWREMOVEVOTE=1">
                <xsl:attribute name="checked"/>
              </xsl:if>
            </input> Yes
            <input type="radio" name="allowremovevote" value="0">
              <xsl:if test="ALLOWREMOVEVOTE=0">
                <xsl:attribute name="checked"/>
              </xsl:if>
            </input> No
          </td>
        </tr>
        <tr>
          <td align="right">Allow PostCodes in Search:</td>
          <td>
            <input type="radio" name="allowpostcodesinsearch" value="1">
              <xsl:if test="ALLOWPOSTCODESINSEARCH=1">
                <xsl:attribute name="checked"/>
              </xsl:if>
            </input> Yes
            <input type="radio" name="allowpostcodesinsearch" value="0">
              <xsl:if test="ALLOWPOSTCODESINSEARCH=0">
                <xsl:attribute name="checked"/>
              </xsl:if>
            </input> No
          </td>
        </tr>
        <tr>
          <td align="right">Queue Postings:</td>
          <td>
            <input type="radio" name="queuepostings" value="1">
              <xsl:if test="QUEUEPOSTINGS=1">
                <xsl:attribute name="checked"/>
              </xsl:if>
            </input> Yes
            <input type="radio" name="queuepostings" value="0">
              <xsl:if test="QUEUEPOSTINGS=0">
                <xsl:attribute name="checked"/>
              </xsl:if>
            </input> No
          </td>
        </tr>
        <tr>
          <td align="right">Custom Terms:</td>
          <td>
            <input type="radio" name="customterms" value="1">
              <xsl:if test="CUSTOMTERMS=1">
                <xsl:attribute name="checked"/>
              </xsl:if>
            </input> Yes
            <input type="radio" name="customterms" value="0">
              <xsl:if test="CUSTOMTERMS=0">
                <xsl:attribute name="checked"/>
              </xsl:if>
            </input> No
          </td>
        </tr>
        <tr>
          <td align="right">Prevent cross-linking</td>
          <td>
            <input type="radio" name="noautoswitch" value="1">
              <xsl:if test="NOAUTOSWITCH=1">
                <xsl:attribute name="checked"/>
              </xsl:if>
            </input> Yes
            <input type="radio" name="noautoswitch" value="0">
              <xsl:if test="NOAUTOSWITCH=0">
                <xsl:attribute name="checked"/>
              </xsl:if>
            </input> No
          </td>
        </tr>
        <tr>
          <td align="right">Identity Policy:</td>
          <td>
            <xsl:apply-templates select="/H2G2/SITEMANAGER/IDENTITYPOLICIES" mode="select"/>
          </td>
        </tr>
        <tr>
          <td>
          </td>
          <td>
            <input type="submit" name="update" value="Update Site"/>
            <input type="submit" name="create" value="Create Site"/>
          </td>
          <td>
            <xsl:variable name="siteconfigfields"><![CDATA[<MULTI-INPUT><ELEMENT NAME='SITECONFIG'></ELEMENT></MULTI-INPUT>]]></xsl:variable>
            <a href="SiteConfig?siteid={/H2G2/SITEMANAGER/@SITEID}&amp;_msxml={$siteconfigfields}">Edit Site Config</a>
          </td>
        </tr>
        <!--<tr>
          <td align="right">Select Site Type:</td>
          <td>
            <select name="sitetype">
              <option value="None">None</option>
              <option value="Messageboard">MessageBoard</option>
              <option value="Comments">Comments</option>
              <option value="Blog">Blog</option>
            </select>
          </td>
        </tr>-->
      </table>
    </form>
  </xsl:template>

  <xsl:template match="IDENTITYPOLICIES" mode="select">
    <xsl:variable name="currentidentitypolicy" select="/H2G2/SITEMANAGER/CURRENTIDENTITYPOLICY"/>
    <select name="identitypolicy">
      <option value="">
        Not using Identity
      </option>
      <xsl:for-each select="POLICY">
        <option value="{.}">
          <xsl:if test=". = $currentidentitypolicy">
            <xsl:attribute name="selected"></xsl:attribute>
          </xsl:if>
          <xsl:value-of select="."/>
        </option>
      </xsl:for-each>
    </select>
  </xsl:template>
  
  <xsl:template match="SITE-LIST" mode="select">
    <xsl:variable name="siteid" select="/H2G2/SITEMANAGER/@SITEID"/>
      <select name="siteid">
        <option value="-1">
          None - New Site 
        </option>
        <xsl:for-each select="SITE">
          <xsl:sort select="NAME"/>
          <option value="{@ID}">
            <xsl:if test="$siteid = @ID">
              <xsl:attribute name="selected"></xsl:attribute>
            </xsl:if>
            <xsl:value-of select="NAME"/> - <xsl:value-of select="DESCRIPTION"/>
          </option>
        </xsl:for-each>
      </select>
  </xsl:template>

  <xsl:template match="MODERATION-CLASS" mode="selectmodclass">
    <xsl:variable name="modclassid" select="/H2G2/SITEMANAGER/MODERATIONCLASSID"/>
    <option value="{@CLASSID}">
      <xsl:if test="$modclassid=@CLASSID">
        <xsl:attribute name="selected"/>
      </xsl:if>
      <xsl:value-of select="NAME"/>
    </option>
  </xsl:template>


</xsl:stylesheet>