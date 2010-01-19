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
  <!-- 
	<xsl:template name="POST-MODERATION_MAINBODY">
	Author:	Andy Harris
	Context:     	/H2G2
	Purpose:	Main body template
	-->
  <xsl:template name="SITESUMMARY_MAINBODY">
    <ul id="classNavigation">
      <xsl:for-each select="/H2G2/MODERATION-CLASSES/MODERATION-CLASS">
        <li>
          <xsl:attribute name="class">
            <xsl:choose>
              <xsl:when test="/H2G2/SITE-LIST/SITE[@ID = /H2G2/USERS-LIST/@SITEID]/CLASSID = current()/@CLASSID">selected</xsl:when>
              <xsl:otherwise>unselected</xsl:otherwise>
            </xsl:choose>
          </xsl:attribute>
          <xsl:attribute name="id">
            modClass<xsl:value-of select="@CLASSID"/>
          </xsl:attribute>
          <a href="#">
            <xsl:attribute name="href">
              members?show=10&amp;skip=0&amp;direction=0&amp;sortedon=nickname&amp;siteid=<xsl:value-of select="/H2G2/SITE-LIST/SITE[CLASSID = current()/@CLASSID]/@ID"/>&amp;s_classview=<xsl:value-of select="@CLASSID"/>
            </xsl:attribute>
            <xsl:value-of select="NAME"/>
          </a>
        </li>
      </xsl:for-each>
    </ul>

    <!-- Show Errors -->
    <xsl:if test="/H2G2/ERROR">
      <span class="moderationformerror">
        <xsl:for-each select="/H2G2/ERROR">
          <b>
            <xsl:value-of select="."/>
          </b>
          <br/>
        </xsl:for-each>
      </span>
    </xsl:if>
    
      <form action="sitesummary" id="moderationForm" method="get">
        <xsl:variable name="startdate">
          <xsl:apply-templates select="/H2G2/SITESUMMARY/STARTDATE/DATE" mode="dc"/></xsl:variable>
        <xsl:variable name="enddate">
          <xsl:apply-templates select="/H2G2/SITESUMMARY/ENDDATE/DATE" mode="dc"/>
        </xsl:variable>
        <table>
          <tr>
            <td>Start Date:</td>
            <td>
              <input type="text" name="startdate" value="{$startdate}"></input>
            </td>
          </tr>
          <tr>
            <td>
              End Date:
            </td>
            <td>
              <input type="text" name="enddate" value="{$enddate}"></input>
            </td>
          </tr>
          <tr>
            <td>
              Site:
            </td>
            <td>
              <xsl:call-template name="sites"/>
              <input type="submit" name="process"></input>
            </td>
          </tr>
          <tr>
            <td>Recalculate Report:</td>
            <td>
              <input type="checkbox" name="recalculate" value="1"/>
            </td>
          </tr>
        </table>
      </form>
  
     
      <xsl:for-each select="/H2G2/SITESUMMARY/POSTSUMMARYLIST/POSTSUMMARY">
        <div id="mainContent">
          <xsl:variable name="siteid">
            <xsl:value-of select="@SITEID"/>
          </xsl:variable>

          <table width ="100%" class="postItems">
            <tr class="infoBar">
              <td colspan="3">
                <xsl:value-of select="/H2G2/SITE-LIST/SITE[@ID=$siteid]/NAME"/>
              </td>
            </tr>
            <xsl:apply-templates select="/H2G2/SITESUMMARY/POSTSUMMARYLIST/POSTSUMMARY[@SITEID=$siteid]"></xsl:apply-templates>
            <xsl:apply-templates select="/H2G2/SITESUMMARY/ARTICLESUMMARYLIST/ARTICLESUMMARY[@SITEID=$siteid]"></xsl:apply-templates>
            <xsl:apply-templates select="/H2G2/SITESUMMARY/GENERALSUMMARYLIST/GENERALSUMMARY[@SITEID=$siteid]"></xsl:apply-templates>
          </table>
        </div>
      </xsl:for-each>
  </xsl:template>

  <xsl:template name="sites">
    <select name="siteid">
      <option value="0">
        <xsl:if test="not(/H2G2/SITESUMMARY/SITE)">
          <xsl:attribute name="selected">selected</xsl:attribute>
        </xsl:if>
          All Sites
      </option>
      <xsl:for-each select="/H2G2/SITE-LIST/SITE">
        <option value="{@ID}">
        <xsl:if test="@ID = /H2G2/SITESUMMARY/SITE/@ID">
          <xsl:attribute name="selected">selected</xsl:attribute>
        </xsl:if>
        <xsl:value-of select="SHORTNAME"/>
        </option>
      </xsl:for-each>
    </select>
  </xsl:template>
  
  <xsl:template match="POSTSUMMARY">
    <tr>
      <td colspan="3" class="firstPostTitle">
        POST SUMMARY </td>
    </tr>
    <tr>
      <td width="80%">Total Posts</td>
      <td>
        <xsl:value-of select="POSTTOTAL"/>
      </td>
      <td></td>
    </tr>
    <tr>
      <td>Total Posts Moderated</td>
      <td class="columnSummary">
        <xsl:value-of select="POSTMODERATEDTOTAL"/>
      </td>
      <td class="columnSummary">
      </td>
    </tr>
    <tr>
      <td>Total Posts Passed</td>
      <td class="columnSummary">
        <xsl:value-of select="POSTPASSED"/>
      </td>
      <td class="columnSummary">
        <xsl:if test ="POSTMODERATEDTOTAL &gt; 0">
          <xsl:value-of select="round(POSTPASSED div POSTMODERATEDTOTAL * 100)"/>%
        </xsl:if>
      </td>
    </tr>
    <tr>
      <td>Total Posts Failed</td>
      <td class="columnSummary">
        <xsl:value-of select="POSTFAILED"/>
      </td>
      <td class="columnSummary">
        <xsl:if test="POSTMODERATEDTOTAL &gt; 0">
          <xsl:value-of select="round(POSTFAILED div POSTMODERATEDTOTAL * 100)"/>%
        </xsl:if>
      </td>
    </tr>
    <tr>
      <td>Total Posts Referred</td>
      <td class="columnSummary">
        <xsl:value-of select="POSTREFERRED"></xsl:value-of>
      </td>
      <td class="columnSummary">
        <xsl:if test="POSTMODERATEDTOTAL &gt; 0">
          <xsl:value-of select="round(POSTREFERRED div POSTMODERATEDTOTAL * 100)"/>%
        </xsl:if>
      </td>
    </tr>
    <tr>
      <td>Total Complaints</td>
      <td class="columnSummary">
        <xsl:value-of select="POSTCOMPLAINT"/>
      </td>
      <td class="columnSummary">
        <xsl:if test="POSTMODERATEDTOTAL &gt; 0">
          <xsl:value-of select="round(POSTCOMPLAINT div POSTMODERATEDTOTAL * 100)"/>%
        </xsl:if>
      </td>
    </tr>

  </xsl:template>

  <xsl:template match="ARTICLESUMMARY">
    <tr>
      <td colspan="3" class="firstPostTitle">ARTICLE SUMMARY</td>
    </tr>
    <tr>
      <td>Total Articles Moderated</td>
      <td class="columnSummary">
        <xsl:value-of select="ARTICLEMODERATEDTOTAL"/>
      </td>
      <td class="columnSummary"></td>
    </tr>
    <tr>
      <td>Total Articles Passed</td>
      <td class="columnSummary">
        <xsl:value-of select="ARTICLEPASSED"/>
      </td>
      <td class="columnSummary">
        <xsl:if test="ARTICLEMODERATEDTOTAL &gt; 0 ">
          <xsl:value-of select="round(ARTICLEPASSED div ARTICLEMODERATEDTOTAL * 100)"/>%
        </xsl:if>
      </td>
    </tr>
    <tr>
      <td>Total Articles Failed</td>
      <td class="columnSummary">
        <xsl:value-of select="ARTICLEFAILED"/>
      </td>
      <td class="columnSummary">
        <xsl:if test="ARTICLEMODERATEDTOTAL &gt; 0 ">
          <xsl:value-of select="round(ARTICLEFAILED div ARTICLEMODERATEDTOTAL * 100)"/>%
        </xsl:if>
      </td>
    </tr>
    <tr>
      <td>Total Articles Referred</td>
      <td class="columnSummary">
        <xsl:value-of select="ARTICLEREFERRED"/>
      </td>
      <td class="columnSummary">
        <xsl:if test="ARTICLEMODERATEDTOTAL &gt; 0 ">
          <xsl:value-of select="round(ARTICLEREFERRED div ARTICLEMODERATEDTOTAL * 100)"/>%
        </xsl:if>
      </td>
    </tr>
    <tr>
      <td>Total Article Complaints</td>
      <td class="columnSummary">
        <xsl:value-of select="ARTICLECOMPLAINT"></xsl:value-of>
      </td>
      <td class="columnSummary">
        <xsl:if test="ARTICLEMODERATEDTOTAL &gt; 0 ">
          <xsl:value-of select="round(ARTICLECOMPLAINT div ARTICLEMODERATEDTOTAL * 100)"/>%
        </xsl:if>
      </td>
    </tr>
  </xsl:template>

  <xsl:template match="GENERALSUMMARY">
    <tr>
      <td colspan="3" class="firstPostTitle">GENERAL SUMMARY</td>
    </tr>
    <tr>
      <td>General Moderated Total</td>
      <td class="columnSummary">
        <xsl:value-of select="GENERALMODERATEDTOTAL"/>
      </td>
      <td class="columnSummary"></td>
    </tr>
    <tr>
      <td>General Passed Total</td>
      <td class="columnSummary">
        <xsl:value-of select="GENERALPASSED"/>
      </td>
      <td class="columnSummary">
        <xsl:if test="GENERALMODERATEDTOTAL &gt; 0">
          <xsl:value-of select="round(GENERALPASSED div GENERALMODERATEDTOTAL * 100)"/>%
        </xsl:if>
      </td>
    </tr>
    <tr>
      <td>General Failed Total</td>
      <td class="columnSummary">
        <xsl:value-of select="GENERALFAILED"/>
      </td>
      <td class="columnSummary">
        <xsl:if test="GENERALMODERATEDTOTAL &gt; 0">
          <xsl:value-of select="round(GENERALFAILED div GENERALMODERATEDTOTAL * 100)"/>%
        </xsl:if>
      </td>
    </tr>
    <tr>
      <td>General Referred Total</td>
      <td class="columnSummary">
        <xsl:value-of select="GENERALREFERRED"/>
      </td>
      <td class="columnSummary">
        <xsl:if test="GENERALMODERATEDTOTAL &gt; 0">
          <xsl:value-of select="round(GENERALREFERRED div GENERALMODERATEDTOTAL * 100)"/>%
        </xsl:if>
      </td>
    </tr>
  </xsl:template>
  
</xsl:stylesheet>
