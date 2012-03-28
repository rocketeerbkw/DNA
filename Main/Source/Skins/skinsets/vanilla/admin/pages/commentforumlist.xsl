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
	
	<xsl:template match="H2G2[@TYPE = 'COMMENTFORUMLIST']" mode="page">
		<xsl:call-template name="objects_links_breadcrumb">
			<xsl:with-param name="pagename"> manage your entries/stories</xsl:with-param>
		</xsl:call-template>	
	
		<div class="dna-mb-intro">
			<form action="commentforumlist" method="get">
				<fieldset>
					<label for="dnahostpageurl">Enter BBC URL to filter including <strong>http:// </strong></label>
					<input type="text" name="dnahostpageurl" id="dnahostpageurl">
						<xsl:attribute name="value">
							<xsl:choose>
								<xsl:when test="/H2G2/COMMENTFORUMLIST/@REQUESTEDURL">
									<xsl:value-of select="/H2G2/COMMENTFORUMLIST/@REQUESTEDURL"/>
								</xsl:when>
								<xsl:otherwise>http://www.bbc.co.uk/</xsl:otherwise>
							</xsl:choose>
						</xsl:attribute>
					</input>
					
					<span class="dna-buttons">
						<input type="submit" value="Filter Site"/>
					</span>
				</fieldset>
			</form>
			
			<p>Forum list count: <strong><xsl:value-of select="/H2G2/COMMENTFORUMLIST/@COMMENTFORUMLISTCOUNT"/></strong></p>
		</div>
		
		<xsl:if test="/H2G2/COMMENTFORUMLIST/@COMMENTFORUMLISTCOUNT != 0">
			<div class="dna-main dna-main-bg dna-main-pad blq-clearfix">
				<div class="dna-fl dna-main-full">
					<div class="dna-box">
						<ul class="pagination cfl-pagination">
							<xsl:call-template name="cfl-skip-show"/>
						</ul>
						<div class="dna-fl dna-main-full">
							<table class="dna-dashboard-activity dna-dashboard-cfl">
								<xsl:apply-templates select="/H2G2/COMMENTFORUMLIST/COMMENTFORUM" />
							</table>
							<xsl:choose>
								<xsl:when test="/H2G2/SITE/SITEOPTIONS/SITEOPTION[NAME = 'MaxItemsInPriorityModeration']/VALUE = 0">
									<p id="prioritymod">* Please note forums will remain in priority moderation until forum has closed.</p>
								</xsl:when>
								<xsl:otherwise>
									<p id="prioritymod">* Please note forums will be removed from priority moderation after <xsl:value-of select="/H2G2/SITE/SITEOPTIONS/SITEOPTION[NAME = 'MaxItemsInPriorityModeration']/VALUE" /> posts.</p>
								</xsl:otherwise>
							</xsl:choose>
							
							
						</div>
						<ul class="pagination cfl-pagination">
							<xsl:call-template name="cfl-skip-show"/>
						</ul>
					</div>
				</div>
			</div>
		</xsl:if>
						
	</xsl:template>
	
	<xsl:template match="COMMENTFORUM">
		<tr>
			<xsl:call-template name="objects_stripe" />			
			<th>Host Page URL:</th>
			<td colspan="4">
				<a target="_blank">
					<xsl:attribute name="href">
						<xsl:value-of select="HOSTPAGEURL"/>
					</xsl:attribute>
					<xsl:value-of select="HOSTPAGEURL"/>
				</a>
				<xsl:choose>
					<xsl:when test="@CANWRITE=0">
						(<strong>currently closed</strong>)
					</xsl:when>	
					<xsl:when test="CLOSEDATE/DATE/@SORT &lt; /H2G2/DATE/@SORT and @CANWRITE = 1">
						(<strong>currently closed</strong>)
					</xsl:when>
				</xsl:choose>				
			</td>
		</tr>
		<tr>
			<xsl:call-template name="objects_stripe" />	
			<th>Details</th>
			<th>Mod Status</th>
			<th>Close Date</th>
			<th>Open/Close</th>
			<th>Priority Moderation <a href="#prioritymod">*</a></th>
		</tr>
		<tr>
			<xsl:call-template name="objects_stripe" />	   
			<td>
				<h4 class="blq-hide">Entry number <xsl:value-of select="position() + ancestor::COMMENTFORUMLIST/@SKIP " /> </h4>
				<xsl:variable name="siteId" select="SITEID"/>
				<xsl:variable name="forumId" select="@FORUMID"/>
				<xsl:variable name="title" select="TITLE"/>
				<ul>
					<li><strong>Title: </strong><xsl:value-of select="TITLE"/></li>
					<li><strong>Forum ID: </strong><xsl:value-of select="@FORUMID"/></li>
					<li><strong>UID: </strong><xsl:value-of select="@UID"/></li>
					<li><strong>Comment count: </strong><xsl:value-of select="@FORUMPOSTCOUNT"/></li>
					<li><strong>Comments: </strong><a href="{$root-secure-moderation}/admin/commentslist?s_siteid={$siteId}&amp;s_forumid={$forumId}&amp;s_title={$title}" target="_blank">Click here</a></li>
				</ul>
			</td>
			<td>
				<form action="commentforumlist" method="get">
					<fieldset>
						<input type="hidden" name="dnauid" value="{@UID}" />
						<input type="hidden" name="dnaaction" value="update" />
						
						<ul>
							<li>
								<label for="dnanewmodstatus1{@UID}">Reactive</label>
								<input type="radio" name="dnanewmodstatus" value="reactive" id="dnanewmodstatus1{@UID}">
									<xsl:if test="MODSTATUS=1">
										<xsl:attribute name="checked">checked</xsl:attribute>
									</xsl:if>
								</input>
							</li>
							<li>
								<label for="dnanewmodstatus2{@UID}">Post Moderated</label>
								<input type="radio" name="dnanewmodstatus" value="postmod" id="dnanewmodstatus2{@UID}">
									<xsl:if test="MODSTATUS=2">
										<xsl:attribute name="checked">checked</xsl:attribute>
									</xsl:if>
								</input> 
							</li>
							<li>
								<label for="dnanewmodstatus3{@UID}">Pre Moderated</label>
								<input type="radio" name="dnanewmodstatus" value="premod" id="dnanewmodstatus3{@UID}">
									<xsl:if test="MODSTATUS=3">
										<xsl:attribute name="checked">checked</xsl:attribute>
									</xsl:if>
								</input>
							</li>
						</ul> 
						
						<input type="hidden" name="dnasiteid" value="{/H2G2/COMMENTFORUMLIST/@REQUESTEDSITEID}" />
						<input type="hidden" name="dnahostpageurl" value="{/H2G2/COMMENTFORUMLIST/@REQUESTEDURL}" />
						<input type="hidden" name="dnaskip" value="{/H2G2/COMMENTFORUMLIST/@SKIP}" />
						<input type="hidden" name="dnashow" value="{/H2G2/COMMENTFORUMLIST/@SHOW}" />
							
						<p>
							<span class="dna-buttons">
								<input type="submit" value="update" />
							</span>
						</p>
					</fieldset>
				</form>
			</td>
			<td>
				<form action="commentforumlist" method="get">
					<fieldset>
						<input type="hidden" name="dnauid" value="{@UID}" />
						<input type="hidden" name="dnaaction" value="update" />
						
						<label for="dnanewforumclosedate{@UID}">Format: YYYYMMDD</label>
						<input type="text" name="dnanewforumclosedate" id="dnanewforumclosedate{@UID}" class="cfl-cell-input" value="{CLOSEDATE/DATE/@YEAR}{CLOSEDATE/DATE/@MONTH}{CLOSEDATE/DATE/@DAY}" />
						
						<input type="hidden" name="dnasiteid" value="{/H2G2/COMMENTFORUMLIST/@REQUESTEDSITEID}" />
						<input type="hidden" name="dnahostpageurl" value="{/H2G2/COMMENTFORUMLIST/@REQUESTEDURL}" />
						<input type="hidden" name="dnaskip" value="{/H2G2/COMMENTFORUMLIST/@SKIP}" />
						<input type="hidden" name="dnashow" value="{/H2G2/COMMENTFORUMLIST/@SHOW}" />
						
						<p>
							<span class="dna-buttons">
								<input type="submit" value="update" />
							</span>
						</p>
					</fieldset>
				</form>
			</td>
			<td>
				<form action="commentforumlist" method="get">
					<fieldset>
						<input type="hidden" name="dnauid" value="{@UID}" />
						<input type="hidden" name="dnaaction" value="update" />
						
						<ul>
							<li>
								<label for="dnanewcanwrite1{@UID}">Open</label>
								<input type="radio" name="dnanewcanwrite" value="1" id="dnanewcanwrite1{@UID}">
									<xsl:if test="@CANWRITE=1">
										<xsl:attribute name="checked">checked</xsl:attribute>
									</xsl:if>
								</input>
							</li>
							<li>
								<label for="dnanewcanwrite0{@UID}">Close</label>
								<input type="radio" name="dnanewcanwrite" value="0" id="dnanewcanwrite0{@UID}">
									<xsl:choose>
										<xsl:when test="@CANWRITE=0">
											<xsl:attribute name="checked">checked</xsl:attribute>
										</xsl:when>	
										<xsl:when test="CLOSEDATE/DATE/@SORT &lt; /H2G2/DATE/@SORT and @CANWRITE = 1">
											<xsl:attribute name="checked">checked</xsl:attribute>
										</xsl:when>
									</xsl:choose>									
								</input>
							</li>
						</ul>
						
						<input type="hidden" name="dnasiteid" value="{/H2G2/COMMENTFORUMLIST/@REQUESTEDSITEID}" />
						<input type="hidden" name="dnahostpageurl" value="{/H2G2/COMMENTFORUMLIST/@REQUESTEDURL}" />
						<input type="hidden" name="dnaskip" value="{/H2G2/COMMENTFORUMLIST/@SKIP}" />
						<input type="hidden" name="dnashow" value="{/H2G2/COMMENTFORUMLIST/@SHOW}" />
						
						<p>
							<span class="dna-buttons">
								<input type="submit" value="update" />
							</span>
						</p>
					</fieldset>
				</form>
			</td>
			<td>
				<form action="commentforumlist" method="get">
					<fieldset>
						<input type="hidden" name="dnauid" value="{@UID}" />
						<input type="hidden" name="dnaaction" value="update" />
						
						<label for="dnafastmod{@UID}" class="blq-hide">Fast Moderation</label>
						<select name="dnafastmod" id="dnafastmod{@UID}">
							<xsl:if test="FASTMOD='1'">
								<option value="enabled"><xsl:attribute name="selected">selected</xsl:attribute>Enabled</option>
								<option value="disabled">Disabled</option>
							</xsl:if>
							<xsl:if test="FASTMOD='0'">
								<option value="enabled">Enabled</option>
								<option value="disabled"><xsl:attribute name="selected">selected</xsl:attribute>Disabled</option>
							</xsl:if>
						</select>
						
						<input type="hidden" name="dnasiteid" value="{/H2G2/COMMENTFORUMLIST/@REQUESTEDSITEID}" />
						<input type="hidden" name="dnahostpageurl" value="{/H2G2/COMMENTFORUMLIST/@REQUESTEDURL}" />
						<input type="hidden" name="dnaskip" value="{/H2G2/COMMENTFORUMLIST/@SKIP}" />
						<input type="hidden" name="dnashow" value="{/H2G2/COMMENTFORUMLIST/@SHOW}" />
						<p>
							<span class="dna-buttons">
								<input type="submit" value="update" />
							</span>
						</p>
					</fieldset>
				</form>
			</td>
		</tr>
		
		<tr>
			<xsl:call-template name="objects_stripe" />
			<xsl:variable name="termId" select="/H2G2/PARAMS/PARAM[NAME='s_termid']/VALUE" />
			<xsl:variable name="divForumId" select="@FORUMID"/>			
			
			<th><a id="displayTermDetailsBlock" href="javascript:commentforumlist_divToggle('COMMENTFORUM-TERMDETAILS-{$divForumId}');">Terms Filter</a></th>
				
				<td colspan="4">
					<div id="COMMENTFORUM-TERMDETAILS-{$divForumId}" style="display:none">
						<table>
							<thead>
								<tr>
									<th>Term</th>
									<th>Action</th>
                  <th>Reason</th>
                  <th>User</th>
                  <th>Date</th>
									<th> </th>
								</tr>
							</thead>
							<tbody>
								  <xsl:apply-templates mode="COMMENTFORUMLIST_TERMSFILTER" select="TERMS/TERMSLIST/TERMDETAILS"/>
							</tbody>
						</table>
						 <p>					
							<a id="displayTermBlock" href="javascript:commentforumlist_divToggle('COMMENTFORUM-TERMDETAILS-{$divForumId}-FORM');">Import More Terms</a>
						</p>

            <div id="COMMENTFORUM-TERMDETAILS-{$divForumId}-FORM" style="display:none">
              <form action="commentforumlist?dnahostpageurl={HOSTPAGEURL}" method="post" id="COMMENTFORUM-{$divForumId}" onsubmit="return dnaterms_validateForm(this);" >
                <input type="hidden" value="UPDATETERMS" name="action" />
                <input type="hidden" value="s_termid" name="{$termId}" />
                <input type="hidden" value="{@FORUMID}" name="forumid" />
                <table cellpadding="2" cellspacing="0" width="100%">
                  <tr>
                    <th >Terms:</th>
                    <td colspan="3">
                      <xsl:choose>
                        <xsl:when test="/H2G2/ERROR/@TYPE = 'UPDATETERMMISSINGTERM'">
                          <textarea id="termtext" name="termtext" cols="50" rows="2" style="border: 2px solid red">
                            <xsl:value-of select="/H2G2/COMMENTFORUMLIST/COMMENTFORUM/TERMS/TERMSLIST[@FORUMID=$divForumId]/TERM[@ID=$termId]/@TERM"/>
                          </textarea>
                        </xsl:when>
                        <xsl:otherwise>
                          <textarea id="termtext" name="termtext" cols="50" rows="2">
                            <xsl:value-of select="/H2G2/COMMENTFORUMLIST/COMMENTFORUM/TERMS/TERMSLIST[@FORUMID=$divForumId]/TERM[@ID=$termId]/@TERM"/>
                          </textarea>
                        </xsl:otherwise>
                      </xsl:choose>
                    </td>
                  </tr>
                  <tr>
                    <th>Reason:</th>
                    <td colspan="3">
                      <xsl:choose>
                        <xsl:when test="/H2G2/ERROR/@TYPE = 'UPDATETERMMISSINGDESCRIPTION'">
                          <textarea id="reason" name="reason" cols="50" rows="2" style="border: 2px solid red"><xsl:value-of select="/H2G2/COMMENTFORUMLIST/COMMENTFORUM/TERMS/TERMSLIST[@FORUMID=$divForumId]/TERM[@ID=$termId]/@TERM"/></textarea>
                        </xsl:when>
                        <xsl:otherwise>
                          <textarea id="reason" name="reason" cols="50" rows="2"><xsl:value-of select="/H2G2/COMMENTFORUMLIST/COMMENTFORUM/TERMS/TERMSLIST[@FORUMID=$divForumId]/TERM[@ID=$termId]/@TERM"/></textarea>
                        </xsl:otherwise>
                      </xsl:choose>
                    </td>
                  </tr>
                  <tr>
                    <td>
                      <p>
                        <input type="radio" name="action_forumid_all" id="action_forumid_all_ReEdit_{$divForumId}" value="ReEdit" style="float:right" />
                        <label for="action_forumid_all_ReEdit_{$divForumId}">Ask user to re-edit</label>
                      </p>
                    </td>
                    <td>
                      <p>
                        <input type="radio" name="action_forumid_all" id='action_forumid_all_Refer_{$divForumId}' value="Refer" style="float:right" />
                        <label for="action_forumid_all_Refer_{$divForumId}">Send to moderator</label>
                      </p>

                    </td>
                    <td>
                      <p>
                        <input type="radio" name="action_forumid_all" id='action_forumid_all_NoAction_{$divForumId}' value="NoAction" style="float:right" />
                        <label for="action_forumid_all_NoAction_{$divForumId}">No Action</label>
                      </p>

                    </td>
                    <td>
                      <p>
                        <input type="submit" value="Apply" />
                      </p>
                    </td>
                  </tr>
                  <xsl:apply-templates select="FORUM-CLASS" mode="mainArea" />
                  <tr>
                    <div style="clear:both;margin:0px; padding:0px;">
                      <xsl:choose>
                        <xsl:when test="/H2G2/RESULT/MESSAGE != ''">
                          <div id="serverResponse" name="serverResponse" style="float:left; margin-top:10px; border: 1px solid green;">
                            <p>
                              <xsl:value-of select="/H2G2/RESULT/MESSAGE"/>
                            </p>
                          </div>
                        </xsl:when>
                        <xsl:when test="/H2G2/ERROR/ERRORMESSAGE != ''">
                          <div id="serverResponse" name="serverResponse" style="float:left; margin-top:10px; border: 1px solid red;">
                            <p>
                              <b>An error has occurred:</b>
                              <BR/>
                              <xsl:value-of select="/H2G2/ERROR/ERRORMESSAGE"/>
                            </p>
                          </div>
                        </xsl:when>
                        <xsl:otherwise>

                        </xsl:otherwise>
                      </xsl:choose>

                      <div id="dnaTermErrorDiv" name="dnaTermErrorDiv" style="float:left; margin-top:10px;border: 1px solid red;display: none;"></div>
                    </div>
                  </tr>
                </table>
              </form>
              </div>
            </div>
				</td>				
		</tr>
	 </xsl:template>	 
	 
	 <xsl:template mode="COMMENTFORUMLIST_TERMSFILTER" match="TERMDETAILS">
		<tr>
			<td>
				<xsl:value-of select="@TERM"/>
			</td>
			<td>
        <xsl:choose>
          <xsl:when test="@ACTION = 'Refer'">
            <img src="/dnaimages/dna_messageboard/img/icons/post_REFERRED.png" width="30" height="30" alt="Send message to moderation" title="Send message to moderation" />
          </xsl:when>
          <xsl:when test="@ACTION = 'ReEdit'">
            <img src="/dnaimages/dna_messageboard/img/icons/post_FAILED.png" width="30" height="30" alt="Ask user to re-edit word" title="Ask user to re-edit word" />
          </xsl:when>
          <xsl:otherwise>
            -
          </xsl:otherwise>
        </xsl:choose>
			</td>
      <td>
        <xsl:choose>
          <xsl:when test="REASON = 'Reason Unknown'">
            -
          </xsl:when>
          <xsl:otherwise>
            <span class="dna-termslist-reason" title="{REASON}">
              <xsl:call-template name="fixedLines">
                <xsl:with-param name="originalString" select="REASON" />
                <xsl:with-param name="charsPerLine" select="33" />
                <xsl:with-param name="lines" select="1" />
              </xsl:call-template>
            </span>
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="REASON = 'Reason Unknown'">
            -
          </xsl:when>
          <xsl:otherwise>
            <a href="/dna/moderation/admin/memberdetails?userid={@USERID}">
              <xsl:value-of select="USERNAME"/>
            </a>
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="REASON = 'Reason Unknown'">
            -
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="UPDATEDDATE/DATE/@RELATIVE"/>
          </xsl:otherwise>
        </xsl:choose>

      </td>
			<td>
				<xsl:variable name="forumid" select="../@FORUMID"/>
				<input type="hidden" value="{@TERM}" name="TERM-{$forumid}-{position()}" id="TERM-{$forumid}-{position()}"><xsl:value-of select="TERM" /></input>				
				<a id="displayTermBlock" href="javascript:commentforumlist_termToggle('COMMENTFORUM-TERMDETAILS-{$forumid}-FORM','{@TERM}',document.getElementById('COMMENTFORUM-{$forumid}'));">edit</a>
			</td>
		</tr>
	</xsl:template>
	
	<xsl:template match="FORUM-CLASS" mode="mainArea">
    <xsl:variable name="forumId" select="@FORUMID"/>
    <tr>
	
      <td>
        <a href="commentforumlist?forumid={$forumId}"><xsl:value-of select="NAME"/></a>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="/H2G2/COMMENTFORUMLIST/COMMENTFORUM/TERMS/TERMSLIST[@FORUMID=$forumId]/TERM/@ACTION='ReEdit'">
            <input type="radio" name="action_forumid_{@FORUMID}" value="ReEdit" checked="checked" />
          </xsl:when>
          <xsl:otherwise>
            <input type="radio" name="action_forumid_{@FORUMID}" value="ReEdit" onclick="unMarkAllRadioButtons();" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="/H2G2/COMMENTFORUMLIST/COMMENTFORUM/TERMS/TERMSLIST[@FORUMID=$forumId]/TERM/@ACTION='Refer'">
            <input type="radio" name="action_forumid_{@FORUMID}" value="Refer" checked="checked"  onclick="unMarkAllRadioButtons();"/>
          </xsl:when>
          <xsl:otherwise>
            <input type="radio" name="action_forumid_{@FORUMID}" value="Refer"  onclick="unMarkAllRadioButtons();"/>
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="/H2G2/COMMENTFORUMLIST/COMMENTFORUM/TERMS/TERMSLIST[@FORUMID=$forumId]">
            
            <input type="radio" name="action_forumid_{@FORUMID}" value="NoAction"  onclick="unMarkAllRadioButtons();"/>
          </xsl:when>
          <xsl:otherwise>
            <input type="radio" name="action_forumid_{@FORUMID}" value="NoAction" checked="checked"  onclick="unMarkAllRadioButtons();"/>
          </xsl:otherwise>
        </xsl:choose>
        
      </td>

    </tr>
    
	</xsl:template>
	
	
	<xsl:template name="cfl-skip-show">
		<xsl:param name="comments_per_page" select="/H2G2/COMMENTFORUMLIST/@SHOW"/>
		<xsl:param name="page_count" select="ceiling(/H2G2/COMMENTFORUMLIST/@COMMENTFORUMLISTCOUNT div /H2G2/COMMENTFORUMLIST/@SHOW)"/>
		<xsl:param name="page_label" select="1"/>
		
		<xsl:variable name="skip" select="/H2G2/COMMENTFORUMLIST/@SKIP" />
		<xsl:variable name="show" select="/H2G2/COMMENTFORUMLIST/@SHOW" />
		<xsl:variable name="total_list_count" select="/H2G2/COMMENTFORUMLIST/@COMMENTFORUMLISTCOUNT" />
		<xsl:variable name="page_count_total" select="ceiling(/H2G2/COMMENTFORUMLIST/@COMMENTFORUMLISTCOUNT div /H2G2/COMMENTFORUMLIST/@SHOW)"/>
		<xsl:variable name="current_page" select="($skip div $show) + 1"/>
		
		<!-- set for navigation range -->
		<xsl:variable name="nav_range" select="10" />
		<xsl:variable name="nav_start" select="floor(($current_page - 1) div $nav_range) * $nav_range"/>
		<xsl:variable name="nav_end" select="$nav_start + $nav_range"/>
		
		<xsl:if test="$page_label = 1">
			<li class="pagenum">Page <strong><xsl:value-of select="$current_page"/></strong> of <strong><xsl:value-of select="$page_count_total"/></strong></li>
		</xsl:if> 
		<xsl:if test="$page_label = 1">
			<li>
				<xsl:choose>
					<xsl:when test="$current_page > 1">
						<a href="commentforumlist?dnaskip=0&amp;dnashow={$show}&amp;dnasiteid={/H2G2/COMMENTFORUMLIST/@REQUESTEDSITEID}&amp;dnahostpageurl={/H2G2/COMMENTFORUMLIST/@REQUESTEDURL}">first page</a>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>first page</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</li>
			<li>
				<xsl:choose>
					<xsl:when test="$current_page > 1">
						<a href="commentforumlist?dnaskip={$skip - $show}&amp;dnashow={$show}&amp;dnasiteid={/H2G2/COMMENTFORUMLIST/@REQUESTEDSITEID}&amp;dnahostpageurl={/H2G2/COMMENTFORUMLIST/@REQUESTEDURL}">previous page</a>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>&lt; previous page</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</li>
			<li>
				<xsl:choose>
					<xsl:when test="$current_page > $nav_range">
						<a href="commentforumlist?dnaskip={($nav_start - 1) * $show}&amp;dnashow={$show}&amp;dnasiteid={/H2G2/COMMENTFORUMLIST/@REQUESTEDSITEID}&amp;dnahostpageurl={/H2G2/COMMENTFORUMLIST/@REQUESTEDURL}">
							&lt;&lt; <xsl:value-of select="concat('previous ',$nav_range)" />
						</a>
					</xsl:when>
					<xsl:otherwise>
						&lt;&lt; <xsl:value-of select="concat('previous ',$nav_range)" />
					</xsl:otherwise>
				</xsl:choose>
			</li>
		</xsl:if>
		
		<xsl:if test="($page_count > 0) and ($page_label &lt;= $nav_end)">
			<xsl:if test="($page_label > $nav_start) and ($page_label &lt;= $nav_end)">
				<li>
					<a href="commentforumlist?dnaskip={($page_label * $show) - $show}&amp;dnashow={$show}&amp;dnasiteid={/H2G2/COMMENTFORUMLIST/@REQUESTEDSITEID}&amp;dnahostpageurl={/H2G2/COMMENTFORUMLIST/@REQUESTEDURL}">
						<xsl:value-of select="$page_label" />
					</a>
				</li>
			</xsl:if>
			
			<xsl:choose>
				<xsl:when test="$page_label &lt;= $nav_start">
					<xsl:call-template name="cfl-skip-show">
						<xsl:with-param name="page_count" select="$page_count_total - $nav_start"/>
						<xsl:with-param name="page_label" select="$nav_start + 1"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="cfl-skip-show">
						<xsl:with-param name="page_count" select="$page_count - 1"/>
						<xsl:with-param name="page_label" select="$page_label + 1"/>
					</xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>
			
		</xsl:if>
		
		<xsl:if test="$page_label = ($nav_end + 1)">
			<li>
				<xsl:choose>
					<xsl:when test="$page_count_total > $current_page">
						<a href="commentforumlist?dnaskip={$current_page * $show}&amp;dnashow={$show}&amp;dnasiteid={/H2G2/COMMENTFORUMLIST/@REQUESTEDSITEID}&amp;dnahostpageurl={/H2G2/COMMENTFORUMLIST/@REQUESTEDURL}">next page</a>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>next page &gt;</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</li>
			<li>
				<xsl:choose>
					<xsl:when test="$page_count_total > $nav_end">
						<a href="commentforumlist?dnaskip={$nav_end * $show}&amp;dnashow={$show}&amp;dnasiteid={/H2G2/COMMENTFORUMLIST/@REQUESTEDSITEID}&amp;dnahostpageurl={/H2G2/COMMENTFORUMLIST/@REQUESTEDURL}">
							<xsl:value-of select="concat('next ',$nav_range)" /> &gt;&gt;
						</a>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="concat('next ',$nav_range)" /> &gt;&gt;
					</xsl:otherwise>
				</xsl:choose>
			</li>
			<li>
				<xsl:choose>
					<xsl:when test="$page_count_total > $current_page">
						<a href="commentforumlist?dnaskip={($page_count_total * $show) - $show}&amp;dnashow={$show}&amp;dnasiteid={/H2G2/COMMENTFORUMLIST/@REQUESTEDSITEID}&amp;dnahostpageurl={/H2G2/COMMENTFORUMLIST/@REQUESTEDURL}">last page</a>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>last page</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</li>
		</xsl:if>
		
		
	</xsl:template>

</xsl:stylesheet>
