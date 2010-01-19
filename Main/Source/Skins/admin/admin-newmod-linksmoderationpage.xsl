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

  <xsl:template name="LINKS-MODERATION_MAINBODY">
    <div id="mainContent">
      <xsl:apply-templates select="LINKMODERATION-LIST"/>
    </div>
	</xsl:template>
	
	<xsl:template match="LINKMODERATION-LIST">
		<div class="linksmoderation">
			<xsl:apply-templates select="LINKMODERATION"/>
		</div>
	</xsl:template>
	
	<xsl:template match="LINKMODERATION">
		<div class="link">
			<form action="{$root}moderateexlinks" method="post" name="LinksModerationForm">
				<input type="hidden" name="URI" value="{URI}"/>
				<input type="hidden" name="ModID" value="{@MODID}"/>
        <input type="hidden" name="ModClassId" value="{/H2G2/LINKMODERATION-LIST/@MODCLASSID}"/>
        <input type="hidden" name="alerts" value="{/H2G2/LINKMODERATION-LIST/@ALERTS}"/>
        <input type="hidden" name="referrals" value="{/H2G2/LINKMODERATION-LIST/@REFERRALS}"/>
			 <iframe src="{URI}" width="100%" height="300">
			  <p>If you cannot see the content, please <a href="{URI}" target="_blank">click here</a>.</p>
				</iframe>
        <div class="postInfo">
          <p>
            URI: <a href="{URI}" target="_blank">
              <xsl:value-of select="URI"/>
            </a>
          </p>
          <xsl:apply-templates select="ALERTS" mode="complaint_info"/>
        </div>
        <div class="tools">
          <xsl:apply-templates select="." mode="mod_form"/>
        </div>

        <div id="processButtons">
          <input type="submit" value="Process &amp; Continue" name="next" title="Process these posts and then fetch the next batch" alt="Process these posts and then fetch the next batch" id="continueButton"/>
          <input type="submit" value="Process &amp; Return to Main" name="done" title="Process these posts and go to Moderation Home" alt="Process these posts and then go to Moderation Home" id="returnButton"/>
        </div>
        <input type="hidden" name="redirect" value="{$root}Moderate?newstyle=1"/>
              
			</form>
		</div>
	</xsl:template>
	
	<xsl:template match="MOD-REASON">
		<option value="{@EMAILNAME}"><xsl:value-of select="@DISPLAYNAME"/></option>
	</xsl:template>
	
	<xsl:template match="REFEREE-LIST">
		<option value="0" >Anyone</option>
		<xsl:for-each select="REFEREE/USER">
			<option value="{USERID}"><xsl:value-of select="USERNAME"/></option>
		</xsl:for-each>
	</xsl:template>

  <xsl:template match="ALERTS" mode="complaint_info">
    <p class="alertUserBar">
      <xsl:text> ( Alert raised </xsl:text>
      <xsl:apply-templates select="DATEQUEUED/DATE"/>
      <xsl:text>)</xsl:text>
    </p>
    <p class="alertContent">
      <xsl:apply-templates select="TEXT"/>
    </p>
  </xsl:template>

  <xsl:template match="LINKMODERATION" mode="mod_form">
    <xsl:variable name="currentSite">
      <xsl:value-of select="SITEID"/>
    </xsl:variable>
    <xsl:variable name="modid">
      <xsl:value-of select="@MODERATIONID"/>
    </xsl:variable>
    <div class="toolBox">
      <h2>Moderation Action</h2>
      <div class="postForm" id="form{@MODERATIONID}">
        <label class="hiddenLabel" for="Decision">Moderation decision for the link</label>
        <select class="type" name="Decision">
          <xsl:choose>
            <xsl:when test="../@ALERTS = 1">
              <option value="3" class="{@MODERATIONID}">Reject Alert &amp; Pass </option>
              <option value="4" class="{@MODERATIONID}">Uphold Alert &amp; Fail </option>
              <option value="2" class="{@MODERATIONID}">Refer</option>
            </xsl:when>
            <xsl:otherwise>
              <option value="3" class="{@MODERATIONID}">Pass</option>
              <option value="4" class="{@MODERATIONID}">Fail</option>
              <option value="2" class="{@MODERATIONID}">Refer</option>
            </xsl:otherwise>
          </xsl:choose>
        </select>
        <div class="refer">
          <label class="hiddenLabel" for="ReferTo">This link is being referred to </label>
          <select name="ReferTo" class="referName">
            <xsl:attribute name="id">
              ReferTo<xsl:number/>
            </xsl:attribute>
            <option class="{$modid}">or Refer to</option>
            <xsl:for-each select="/H2G2/REFEREE-LIST/REFEREE">
              <xsl:if test="SITEID = $currentSite">
                <option class="{$modid}" value="{USER/USERID}">
                  <xsl:value-of select="USER/USERNAME"/>
                </option>
              </xsl:if>
            </xsl:for-each>
          </select>
        </div>
        <div class="fail">
          <label class="hiddenLabel">
            <xsl:attribute name="for">
              EmailType<xsl:number/>
            </xsl:attribute>
            This link has been failed for
          </label>
          <select class="failReason" name="EmailType">
            <xsl:attribute name="id">
              EmailType<xsl:number/>
            </xsl:attribute>
            <option class="{$modid}">or Select failure reason</option>
                <xsl:for-each select="/H2G2/MOD-REASONS/MOD-REASON">
                  <option class="{$modid}" value="{@EMAILNAME}">
                    <xsl:value-of select="@DISPLAYNAME"/>
                  </option>
                </xsl:for-each>
          </select>
        </div>
        
        <div class="reasonText">
          <div class="textLabel">
            <xsl:text>Reason</xsl:text>
          </div>
          <label class="hiddenLabel" for="Notes"> why the link has been referred</label>
          <textarea rows="5" cols="40" name="Notes" class="reasonArea">
            <xsl:attribute name="id">
              NotesArea<xsl:number/>
            </xsl:attribute>
            <xsl:value-of select="NOTES"/>
          </textarea>
        </div>
      </div>
    </div>
  </xsl:template>
 
</xsl:stylesheet>
