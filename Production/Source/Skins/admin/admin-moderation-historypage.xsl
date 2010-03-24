<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
  <xsl:template name="MODERATIONHISTORY_MAINBODY">
    <div id="mainContent">
        <h2>Moderation History</h2>
        <!-- show any error messages -->
        <xsl:for-each select="ERROR">
          <xsl:choose>
            <xsl:when test="@TYPE = 'INVALID-H2G2ID'">
              <b>
                <font color="red">The Entry ID supplied was not a valid one.</font>
              </b>
              <br/>
            </xsl:when>
            <xsl:otherwise>
              <b>
                <font color="red">
                  <xsl:value-of select="."/>
                </font>
              </b>
              <br/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:for-each>
        <br/>
        <a href="{$root}ModerateStats">Moderation Stats Page</a>
        <br/>
        <br/>
        <xsl:choose>
          <xsl:when test="not(MODERATION-HISTORY)">
            Enter an Entry ID or Post ID and click 'Fetch History'.<br/>
          </xsl:when>
          <xsl:when test="not(MODERATION-HISTORY/MODERATION)">
            <b>There is no moderation history for the item specified.</b>
            <br/>
          </xsl:when>
          <xsl:when test="not(number(MODERATION-HISTORY/@H2G2ID) &gt; 0 or number(MODERATION-HISTORY/@POSTID) &gt; 0 or MODERATION-HISTORY/@EXLINKURL)">
            No valid Entry ID or Post ID was provided.<br/>
          </xsl:when>
        </xsl:choose>
        <br/>
        <form method="post" action="{$root}ModerationHistory">
          <table>
            <tr align="left" valign="center">
              <td>
                <xsl:text>Entry Number:  </xsl:text>
              </td>
              <td>
                <input type="text" name="h2g2ID">
                  <xsl:if test="number(MODERATION-HISTORY/@H2G2ID) > 0">
                    <xsl:attribute name="value">
                      <xsl:value-of select="MODERATION-HISTORY/@H2G2ID"/>
                    </xsl:attribute>
                  </xsl:if>
                </input>
              </td>
            </tr>
            <tr align="left" valign="center">
              <td>
                <xsl:text>Post Number:  </xsl:text>
              </td>
              <td>
                <input type="text" name="PostID">
                  <xsl:if test="number(MODERATION-HISTORY/@POSTID) > 0">
                    <xsl:attribute name="value">
                      <xsl:value-of select="MODERATION-HISTORY/@POSTID"/>
                    </xsl:attribute>
                  </xsl:if>
                </input>
              </td>
            </tr>
            <tr align="left" valign="center">
              <td>
                <xsl:text>URL:  </xsl:text>
              </td>
              <td>
                <input type="text" name="ExLinkUrl">
                  <xsl:if test="MODERATION-HISTORY/@EXLINKURL">
                    <xsl:attribute name="value">
                      <xsl:value-of select="MODERATION-HISTORY/@EXLINKURL"/>
                    </xsl:attribute>
                  </xsl:if>
                </input>
              </td>
            </tr>
            <tr align="left" valign="center">
              <td>
                <xsl:text>Reference :</xsl:text>
              </td>
              <td>
                <input type="text" name="Reference"/>
              </td>
            </tr>
            <tr align="left" valign="center">
              <td>
                <xsl:text> </xsl:text>
              </td>
              <td>
                <input type="submit" name="Fetch" value="Fetch History"/>
              </td>
            </tr>
          </table>
        </form>
          
          <!-- process any article moderation history available -->
          <!-- show nothing if we don't even have data on the item -->
        <xsl:if test="MODERATION-HISTORY/MODERATION">
          <xsl:apply-templates select="MODERATION-HISTORY"/>
        </xsl:if>
    </div>
  </xsl:template>

  <xsl:template match="MODERATION-HISTORY">
    <div class="crumbtrail" >
      <table cellspacing="0">
        <tr align="center" vAlign="top">
          <td colspan="13">
            <b>
              <font face="Arial" size="3" color="black">
                <xsl:choose>
                  <xsl:when test="@H2G2ID">
                    Moderation History for Entry A<xsl:value-of select="@H2G2ID"/>
                  </xsl:when>
                  <xsl:when test="@POSTID">
                    Moderation History for Post P<xsl:value-of select="@POSTID"/>
                  </xsl:when>
                  <xsl:when test="@URL">
                    Moderation History for URL <xsl:value-of select="@URL"/>
                  </xsl:when>
                  <xsl:otherwise>Moderation History</xsl:otherwise>
                </xsl:choose>
              </font>
            </b>
          </td>
        </tr>
        <tr align="center" vAlign="top">
          <td colspan="13">
            <b>Subject</b>:
            <xsl:choose>
              <xsl:when test="@POSTID">
                <a href="{$root}F{@FORUMID}?thread={@THREADID}&amp;post={@POSTID}#p{@POSTID}">
                  <xsl:value-of select="SUBJECT"/>
                </a>
              </xsl:when>
              <xsl:when test="@H2G2ID">
                <a href="{$root}A{@H2G2ID}">
                  <xsl:value-of select="SUBJECT"/>
                </a>
              </xsl:when>
              <xsl:when test="@EXLINKURL">
                <a href="{SUBJECT}">
                  <xsl:value-of select="SUBJECT"/>
                </a>
              </xsl:when>
            </xsl:choose>
            <br/>
            <xsl:if test="EDITOR/USER">
              <b>
                Author
              </b>: <xsl:apply-templates select="EDITOR/USER"/>
              <xsl:apply-templates select="EDITOR/USER/STATUS" mode="user_status"/>
              <xsl:apply-templates select="EDITOR/USER/GROUPS" mode="user_groups"/>
            </xsl:if>
          </td>
        </tr>
      </table>
    </div>
    <xsl:apply-templates select="MODERATION"/>
  </xsl:template>

  <xsl:template  match="MODERATION">
    <div class="clear">
      <div class="infoBar">
        <b>
          <xsl:text>Moderation Reference ID: </xsl:text>
          <xsl:value-of select="@MODID"/>
        </b>
      </div>
      <div class="postInfo">
        <div class="postContent">
          <p>
            Status:
            <xsl:choose>
              <xsl:when test="STATUS = 0">In Queue</xsl:when>
              <xsl:when test="STATUS = 1">Locked</xsl:when>
              <xsl:when test="STATUS = 2">Referred</xsl:when>
              <xsl:when test="STATUS = 3">Passed</xsl:when>
              <xsl:when test="STATUS = 4">Failed</xsl:when>
              <xsl:otherwise>
                <xsl:text>Invalid Status:  </xsl:text>
                <xsl:value-of select="MODERATION-STATUS"/>
              </xsl:otherwise>
            </xsl:choose>
          </p>
          <p>
            Date Queued: <xsl:apply-templates select="DATE-QUEUED/DATE" mode="short"/>
          </p>
          <p>
            Date Completed: <xsl:apply-templates select="DATE-COMPLETED/DATE" mode="short"/>
          </p>
          <xsl:if test ="COMPLAINT">
            <p class="alertUserBar">
              <xsl:apply-templates select="COMPLAINT/USER/STATUS" mode="user_status"/>
              <xsl:apply-templates select="COMPLAINT/USER/GROUPS" mode="user_groups"/>
              <xsl:choose>
                <xsl:when test="COMPLAINT/USER/USERNAME">
                  <xsl:apply-templates select="COMPLAINT/USER"/>
                </xsl:when>
                <xsl:otherwise>
                  Anonymous
                </xsl:otherwise>
              </xsl:choose>
              <xsl:text> raised an alert ( submitted </xsl:text>
              <xsl:apply-templates select="DATE-QUEUED/DATE"/>
              <xsl:text> ) </xsl:text>
              <xsl:choose>
                <xsl:when test="COMPLAINANT/USER/CORRESPONDENCE-EMAIL">
                  [ <a href="mailto:{COMPLAINANT/USER/CORRESPONDENCE-EMAIL}">
                    <xsl:value-of select="COMPLAINANT/USER/CORRESPONDENCE-EMAIL"/>
                  </a> ]
                </xsl:when>
                <xsl:otherwise>[ No Email ]</xsl:otherwise>
              </xsl:choose>
            </p>
              <xsl:if test="/H2G2/VIEWING-USER/USER/STATUS='2'">
                <div class="postContent">
                  <p>
                    BBCUID: <xsl:value-of select="COMPLAINT/BBCUID"/>
                  </p>
                  <p>
                    IP Address: <xsl:value-of select="COMPLAINT/IPADDRESS"/>
                  </p>
                </div>
              </xsl:if>

            <div class="postContent">
              <p>
                <xsl:value-of select="COMPLAINT/COMPLAINT-TEXT"/>
              </p>
            </div>
          </xsl:if>
          <xsl:if test="string-length(NOTES) > 0">
            <p class="alertUserBar">
              Notes:<xsl:value-of select="NOTES"/>
            </p>
          </xsl:if>
        </div>
        </div>
        <div class="tools">
          <div class="toolBox">
            <p>
              LockedBy: <xsl:apply-templates select="LOCKED-BY/USER"/>
            </p>
            <p>
              Date Locked: <xsl:apply-templates select="DATE-LOCKED/DATE" mode="short"/>
            </p>
          </div>
          <div class="toolBox">
            <p>
              Referred By: <xsl:apply-templates select="REFERRED-BY/USER"/>
            </p>
            <p>
              Referred Date: <xsl:apply-templates select="DATE-REFERRED/DATE" mode="short"/>
            </p>
          </div>
          <xsl:apply-templates select="/H2G2/EXLINKMODEVENTHISTORY/EXLINKMODEVENT-LIST[@MODID=current()/@MODID]/EXLINKMODEVENT"/>
        </div>
    </div>
    <span class="clear"/>
  </xsl:template>

  <xsl:template match="EXLINKMODEVENT">
    <div class="toolBox">
      <p>
        Notification Event Notes: <xsl:value-of select="NOTES"/>
    </p>
      <p>
        Notification URL: <xsl:value-of select="../EXLINKCALLBACKURL"/>
      </p>
      <p>Notification Event Timestamp: <xsl:apply-templates select="TIMESTAMP/DATE" mode="absolute"/>
    </p>
    </div>
  </xsl:template>
</xsl:stylesheet>