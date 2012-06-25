<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	version="1.0" 
	xmlns:doc="http://www.bbc.co.uk/dna/documentation" 
	xmlns="http://www.w3.org/1999/xhtml" 
	exclude-result-prefixes="doc">
	
	<xsl:template match="H2G2[@TYPE = 'SITEMANAGER']" mode="page">
    
		<xsl:call-template name="objects_links_breadcrumb">
			<xsl:with-param name="pagename" > Site Manager</xsl:with-param>
		</xsl:call-template>    

		<div class="dna-mb-intro blq-clearfix">
			<div class="dna-fl dna-main-full">
				<p>Create and edit site values and links to site options.</p>
        <form method="post" action="SiteManager" onsubmit="return sitemanager_validateForm(this);">
          <table cellspacing="5" class="dna-siteManager">
            <tr>
              <td class="title">Select Site:</td>
              <td>
                <xsl:apply-templates select="/H2G2/SITE-LIST" mode="select"/>
              </td>
              <td>
                <a href="/dna/moderation/SiteOptions?siteid={/H2G2/SITEMANAGER/@SITEID}"  target="_blank">Edit Site Options</a>
              </td>
            </tr>
            <tr>
              <td class="title" >URL Name: </td>
              <td class="value">
                <input type="text" name="urlname" value="{SITEMANAGER/URLNAME}"/>
              </td>
            </tr>
            <tr>
              <td class="title" >Sample URL: </td>
              <td class="value">
                <input type="text" name="sampleurl" value="{SITEMANAGER/SAMPLEURL}" style="width:400px"/>
              </td>
            </tr>
            <tr>
              <td class="title" >Short name:</td>
              <td class="value">
                <input type="text" name="shortname" value="{SITEMANAGER/SHORTNAME}"/>
              </td>
            </tr>
            <tr>
              <td class="title" >Description:</td>
              <td class="value">
                <input type="text" name="description" value="{SITEMANAGER/DESCRIPTION}"/>
              </td>
            </tr>
            <tr>
              <td class="title">Product:</td>
              <td class="value">
                <select name="division">
                  <xsl:apply-templates select="/H2G2/DIVISIONS/DIVISIONS/DIVISION" mode="sitemanager">
                    <xsl:with-param name="currentDivisionId" select="SITEMANAGER/BBCDIVISION"/>
                  </xsl:apply-templates>
                </select>
                <input type="hidden" name="ssoservice" value="{SITEMANAGER/SSOSERVICE}"/>
              </td>
            </tr>
            
            <tr>
              <td class="title" >Moderation:</td>
              <td class="value">
                <select name="modstatus">
                  <option value="1">
                    <xsl:if test="SITEMANAGER/UNMODERATED=1">
                      <xsl:attribute name="selected"/>
                    </xsl:if> UnModerated
                  </option>
                  <option value="2">
                    <xsl:if test="SITEMANAGER/UNMODERATED=0 and SITEMANAGER/PREMODERATED=0">
                      <xsl:attribute name="selected"/>
                    </xsl:if> PostModerated
                  </option>
                  <option value="3">
                    <xsl:if test="SITEMANAGER/PREMODERATED=1">
                      <xsl:attribute name="selected"/>
                    </xsl:if>
                    PreModerated
                  </option>
                </select>
              </td>
            </tr>
            <tr>
              <td class="title" >Moderation Class:</td>
              <td class="value">
                <select name="modclassid">
                  <xsl:apply-templates select="/H2G2/MODERATION-CLASSES/MODERATION-CLASS" mode="selectmodclass"/>
                </select>
              </td>
              <td>
                <a href="/dna/moderation/ModerationClassAdmin"  target="_blank">New Moderation Class</a>
              </td>
            </tr>
            <tr>
              <td class="title" >Moderators email:</td>
              <td class="value">
                <input type="text" name="ModeratorsEmail" value="{SITEMANAGER/MODERATORSEMAIL}"/>
              </td>
            </tr>
            <tr>
              <td class="title" >Editors email:</td>
              <td class="value">
                <input type="text" name="EditorsEmail" value="{SITEMANAGER/EDITORSEMAIL}"/>
              </td>
            </tr>
            <tr>
              <td class="title" >Feedback email:</td>
              <td class="value">
                <input type="text" name="feedbackemail" value="{SITEMANAGER/FEEDBACKEMAIL}"/>
              </td>
            </tr>
            <tr>
              <td class="title" >Auto Message User ID:</td>
              <td class="value">
                <input type="text" name="AutoMessageUserID" value="{SITEMANAGER/AUTOMESSAGEUSERID}"/>
              </td>
            </tr>
            <tr>
              <td class="title" >Risk Mod State:</td>
              <td class="value">
                <select name="riskmodonoff">
                  <option value="0">
                    <xsl:if test="SITEMANAGER/RISKMODONOFF=0">
                      <xsl:attribute name="selected"/>
                    </xsl:if>
                    Off
                  </option>
                  <option value="1">
                    <xsl:if test="SITEMANAGER/RISKMODONOFF=1">
                      <xsl:attribute name="selected"/>
                    </xsl:if>
                    On
                  </option>
                </select>

                <select name="riskModPublishMethod">
                  <option value="A">
                    <xsl:if test="SITEMANAGER/RISKMODPUBLISHMETHOD='A'">
                      <xsl:attribute name="selected"/>
                    </xsl:if>
                    Publish After Risk Assessment
                  </option>
                  <option value="B">
                    <xsl:if test="SITEMANAGER/RISKMODPUBLISHMETHOD='B'">
                      <xsl:attribute name="selected"/>
                    </xsl:if>
                    Publish Before Risk Assessment
                  </option>
                </select>
                value:<xsl:value-of select="RISKMODPUBLISHMETHOD"/>
                <xsl:if test="SITEMANAGER/RISKMODPUBLISHMETHOD='A'">
                  A
                </xsl:if>
                <xsl:if test="SITEMANAGER/RISKMODPUBLISHMETHOD='B'">
                  B
                </xsl:if>
                <xsl:if test="SITEMANAGER/RISKMODONOFF=0">
                  Off
                </xsl:if>
                <xsl:if test="SITEMANAGER/RISKMODONOFF=1">
                  On
                </xsl:if>
              </td>
            </tr>
            <tr>
              <td class="title" >Identity Policy:</td>
              <td class="value">
                <xsl:apply-templates select="/H2G2/SITEMANAGER/IDENTITYPOLICIES" mode="select"/>
              </td>
            </tr>


            <tr>
              <td class="title" >&#160;</td>
              <td class="value">
                <a href="javascript:sitemanager_showHideAdvanced('siteManagerAdvancedOptions', 'toggleOptions');" id="toggleOptions">Show Advanced Options</a>
              </td>
            </tr>
            
          </table>
          
          <div id="siteManagerAdvancedOptions" style="display:none;">
            <table cellspacing="5" class="dna-siteManager">
              <tr>
                <td class="title" >Default skin:</td>
                <td class="value">
                  <input type="text" name="defaultskin" value="{SITEMANAGER/DEFAULTSKIN}"/>
                </td>
              </tr>
              <tr>
                <td class="title" >Skinset:</td>
                <td class="value">
                  <input type="text" name="skinset" value="{SITEMANAGER/SKINSET}"/>
                </td>
              </tr>
            <tr>
              <td class="title" >Event Alert Message User ID:</td>
              <td class="value">
                <input type="text" name="eventalertmessageuserid" value="{SITEMANAGER/EVENTALERTMESSAGEUSERID}" />
              </td>
            </tr>
            <tr>
              <td class="title" >Alert Email Subject:</td>
              <td class="value">
                <input type="text" name="EventEmailSubject" value="{SITEMANAGER/EVENTEMAILSUBJECT}" />
              </td>
            </tr>
            <tr>
              <td class="title" >Thread Edit Time Limit (minutes):</td>
              <td class="value">
                <input type="text" name="ThreadEditTimeLimit" value="{SITEMANAGER/THREADEDITTIMELIMIT}"/>
              </td>
            </tr>
            <tr>
              <td class="title" >Thread Sort Order:</td>
              <td class="value">
                <select name="threadorder">
                  <option value="1">
                    <xsl:if test="SITEMANAGER/THREADSORTORDER!=2">
                      <xsl:attribute name="selected"/>
                    </xsl:if>
                    Last Posted
                  </option>
                  <option value="2">
                    <xsl:if test="SITEMANAGER/THREADSORTORDER=2">
                      <xsl:attribute name="selected"/>
                    </xsl:if>
                    Date Created
                  </option>
                </select>
              </td>
            </tr>
            <tr>
              <td class="title" >Require Password:</td>
              <td class="value">
                <input type="radio" name="passworded" value="1">
                  <xsl:if test="SITEMANAGER/PASSWORDED=1">
                    <xsl:attribute name="checked"></xsl:attribute>
                  </xsl:if>
                </input> Yes
                <input type="radio" name="passworded" value="0">
                  <xsl:if test="SITEMANAGER/PASSWORDED=0">
                    <xsl:attribute name="checked"></xsl:attribute>
                  </xsl:if>
                </input> No
              </td>
            </tr>
            <tr>
              <td class="title" >Article Guest Book Forums:</td>
              <td class="value">
                <input type="radio" name="articleforumstyle" value="1">
                  <xsl:if test="SITEMANAGER/ARTICLEFORUMSTYLE=1">
                    <xsl:attribute name="checked"/>
                  </xsl:if>
                </input> Yes
                <input type="radio" name="articleforumstyle" value="0">
                  <xsl:if test="SITEMANAGER/ARTICLEFORUMSTYLE=0">
                    <xsl:attribute name="checked"/>
                  </xsl:if>
                </input> No
              </td>
            </tr>
            <tr>
              <td class="title" >Include crumbtrail:</td>
              <td class="value">
                <input type="radio" name="includecrumbtrail" value="1">
                  <xsl:if test="SITEMANAGER/INCLUDECRUMBTRAIL=1">
                    <xsl:attribute name="checked"/>
                  </xsl:if>
                </input> Yes
                <input type="radio" name="includecrumbtrail" value="0">
                  <xsl:if test="SITEMANAGER/INCLUDECRUMBTRAIL=0">
                    <xsl:attribute name="checked"/>
                  </xsl:if>
                </input> No
              </td>
            </tr>
            <tr>
              <td class="title" >Allow vote removal:</td>
              <td class="value">
                <input type="radio" name="allowremovevote" value="1">
                  <xsl:if test="SITEMANAGER/ALLOWREMOVEVOTE=1">
                    <xsl:attribute name="checked"/>
                  </xsl:if>
                </input> Yes
                <input type="radio" name="allowremovevote" value="0">
                  <xsl:if test="SITEMANAGER/ALLOWREMOVEVOTE=0">
                    <xsl:attribute name="checked"/>
                  </xsl:if>
                </input> No
              </td>
            </tr>
            <tr>
              <td class="title" >Allow PostCodes in Search:</td>
              <td class="value">
                <input type="radio" name="allowpostcodesinsearch" value="1">
                  <xsl:if test="SITEMANAGER/ALLOWPOSTCODESINSEARCH=1">
                    <xsl:attribute name="checked"/>
                  </xsl:if>
                </input> Yes
                <input type="radio" name="allowpostcodesinsearch" value="0">
                  <xsl:if test="SITEMANAGER/ALLOWPOSTCODESINSEARCH=0">
                    <xsl:attribute name="checked"/>
                  </xsl:if>
                </input> No
              </td>
            </tr>
            <tr>
              <td class="title" >Queue Postings:</td>
              <td class="value">
                <!--
            Post queuing will not work at the , and if accidently turned on could cause
            problems.
            Disabling it here and in the database to avert catastophe!
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
            -->
                Not currently supported
              </td>
            </tr>
            <tr>
              <td class="title" >Custom Terms:</td>
              <td class="value">
                <input type="radio" name="customterms" value="1">
                  <xsl:if test="SITEMANAGER/CUSTOMTERMS=1">
                    <xsl:attribute name="checked"/>
                  </xsl:if>
                </input> Yes
                <input type="radio" name="customterms" value="0">
                  <xsl:if test="SITEMANAGER/CUSTOMTERMS=0">
                    <xsl:attribute name="checked"/>
                  </xsl:if>
                </input> No
              </td>
            </tr>
            <tr>
              <td  class="title">Prevent cross-linking:</td>
              <td class="value">
                <input type="radio" name="noautoswitch" value="1">
                  <xsl:if test="SITEMANAGER/NOAUTOSWITCH=1">
                    <xsl:attribute name="checked"/>
                  </xsl:if>
                </input> Yes
                <input type="radio" name="noautoswitch" value="0">
                  <xsl:if test="SITEMANAGER/NOAUTOSWITCH=0">
                    <xsl:attribute name="checked"/>
                  </xsl:if>
                </input> No
              </td>
            </tr>
           

            


            
            <!--<tr>
          <td >Select Site Type:</td>
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
          </div>
          <table cellspacing="5" class="dna-siteManager">
            <tr>
              <td class="title" valign="top">Update Notes</td>
              <td class="value">
                <textarea id="notes" name="notes" rows="5" cols="50"><xsl:text> </xsl:text></textarea>
                <div id="dnaErrorDiv" name="dnaErrorDiv" style="color:red;"></div>
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
                <a href="/dna/moderation/SiteConfig?siteid={/H2G2/SITEMANAGER/@SITEID}&amp;_msxml={$siteconfigfields}" target="_blank">Edit Site Config</a>
              </td>
            </tr>
          </table>
        </form>			
			</div>
		</div>
				
	</xsl:template>


  <xsl:template match="IDENTITYPOLICIES" mode="select">
    <xsl:variable name="currentidentitypolicy" select="/H2G2/SITEMANAGER/CURRENTIDENTITYPOLICY"/>
    <select name="identitypolicy">
      <option value="">
        Not using Identity
      </option>
      <option value="comment">
        <xsl:if test="$currentidentitypolicy = 'comment'">
          <xsl:attribute name="selected"></xsl:attribute>
        </xsl:if>
        IDv4 Comments
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
    <select name="siteid" onchange="this.form.submit();">
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
  

  <xsl:template match="DIVISION" mode="sitemanager">
    <xsl:param name="currentDivisionId"/>
    <option>
      <xsl:attribute name="value">
        <xsl:value-of select="@ID"/>
      </xsl:attribute>
      <xsl:if test="$currentDivisionId = @ID">
        <xsl:attribute name="selected">
          <xsl:text>selected</xsl:text>
        </xsl:attribute>
      </xsl:if>
      <xsl:value-of select="@NAME"/>
    </option>
  </xsl:template>
</xsl:stylesheet>
