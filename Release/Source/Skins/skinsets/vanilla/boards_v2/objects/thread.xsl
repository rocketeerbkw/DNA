<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">
    
    <doc:documentation>
        <doc:purpose>
            Defines HTML for the Thread object.
        </doc:purpose>
        <doc:context>
            Currently applied by objects/forumthreads.xsl
        </doc:context>
        <doc:notes>
            
        </doc:notes>
    </doc:documentation>
    
    
    <xsl:template match="THREAD" mode="object_thread">
      <xsl:variable name="threadId" select="@THREADID"/>
      <xsl:variable name="test_stickythreadson" select="/H2G2/SITE/SITEOPTIONS/SITEOPTION[NAME='EnableStickyThreads' and VALUE ='1']" />
      <tr>  
       	<xsl:call-template name="library_listitem_stripe">
	        <xsl:with-param name="threadId" select="$threadId" />
	        <xsl:with-param name="test_stickythreadson" select="$test_stickythreadson" />       	
       	</xsl:call-template>
        <td class="discussiondetail">
            <h3>
                <a href="{$root}/NF{@FORUMID}?thread={@THREADID}">
					<xsl:if test="$test_stickythreadson">
						<xsl:apply-templates select="/H2G2/FORUMTHREADS/THREAD[@THREADID = $threadId][@ISSTICKY='true']" mode="moderation_cta_addthreadstickytitle" />
					</xsl:if>
                    <xsl:choose>
                        <xsl:when test="SUBJECT/text()">
                          <xsl:call-template name="fixedLines">
                            <xsl:with-param name="originalString" select="SUBJECT/text()" />
                            <xsl:with-param name="charsPerLine" select="33" />
                            <xsl:with-param name="lines" select="1" />
                          </xsl:call-template>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:attribute name="class">
                                <xsl:text>nosubject</xsl:text>
                            </xsl:attribute>
                            <xsl:text>no subject</xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                </a>
            </h3>
            <p>
              <xsl:call-template name="fixedLines">
                <xsl:with-param name="originalString" select="FIRSTPOST/TEXT" />
                <xsl:with-param name="charsPerLine" select="36" />
                <xsl:with-param name="lines" select="2" />
              </xsl:call-template>
            </p>
         </td>
         <td class="replies">
            <p class="replies">
                 <xsl:value-of select="TOTALPOSTS - 1" />
            </p>         
         </td>
         <td class="startedby">
	         <span class="vcard">
	             <span class="fn">
	             	<xsl:attribute name="class">fn<xsl:text> </xsl:text><xsl:apply-templates select="FIRSTPOST/USER/GROUPS/GROUP" mode="library_user_group" /></xsl:attribute>
	             	<!-- Split the string as it was destroying table layout -->
	             	<xsl:variable name="firstpostuser">
						      <xsl:apply-templates select="FIRSTPOST/USER" mode="library_user_username" />
					      </xsl:variable>

                 <xsl:call-template name="fixedLines">
                   <xsl:with-param name="originalString" select="$firstpostuser" />
                   <xsl:with-param name="charsPerLine" select="12" />
                   <xsl:with-param name="lines" select="2" />
                 </xsl:call-template>
	             </span>
	         </span>         
         </td>
         <td class="latestreply">
       		<a href="{$root}/NF{@FORUMID}?thread={@THREADID}&amp;latest=1#p{LASTPOST/@POSTID}">
     	      <xsl:value-of select="DATEPOSTED/DATE/@RELATIVE"/>
     		</a>       
         </td>
      </tr>
		<tr class="moderation">
			<td colspan="4">
				<xsl:call-template name="library_userstate_editor">
					<xsl:with-param name="loggedin">
						<div>
							<div class="dna-moderation-wrapup">
								<p class="dna-boards-moderation">
									<xsl:text>Moderation:</xsl:text>
									<xsl:apply-templates select="/H2G2/FORUMTHREADS/THREAD[@THREADID = $threadId][@CANWRITE = 1]" mode="moderation_cta_closethread">
										<xsl:with-param name="label" select="'Close discussion'"/>
										<xsl:with-param name="subject" select="SUBJECT"/>
									</xsl:apply-templates>
									<xsl:apply-templates select="/H2G2/FORUMTHREADS/THREAD[@THREADID = $threadId][@CANWRITE = 0]" mode="moderation_cta_closethread">
										<xsl:with-param name="label" select="'Open discussion'" />
										<xsl:with-param name="subject" select="SUBJECT"/>
									</xsl:apply-templates>
									<xsl:apply-templates select="/H2G2/FORUMTHREADS/THREAD[@THREADID = $threadId]" mode="moderation_cta_movethread">
										<xsl:with-param name="label" select="'Move discussion'" />
										<xsl:with-param name="subject" select="SUBJECT"/>
									</xsl:apply-templates>
									
									<xsl:if test="$test_stickythreadson">
										<xsl:apply-templates select="/H2G2/FORUMTHREADS/THREAD[@THREADID = $threadId][@ISSTICKY='true']" mode="moderation_cta_removethreadsticky">
											<xsl:with-param name="subject" select="SUBJECT"/>
										</xsl:apply-templates>
										<xsl:apply-templates select="/H2G2/FORUMTHREADS/THREAD[@THREADID = $threadId][@ISSTICKY='false']" mode="moderation_cta_makethreadsticky">
											<xsl:with-param name="subject" select="SUBJECT"/>
										</xsl:apply-templates>
									</xsl:if>
								</p>
							</div>
						</div>
					</xsl:with-param>
				</xsl:call-template>  
			</td>            	
		</tr>      
    </xsl:template>
    
    <!-- For the MP page -->
    <xsl:template match="POST/THREAD" mode="object_thread">
    	<xsl:variable name="siteId" select="parent::POST/SITEID"/>
        <li>
            <xsl:call-template name="library_listitem_stripe"/>
            
            <p class="threadtitle">
            	<a href="{concat($host, '/dna/', /H2G2/SITE-LIST/SITE[@ID = $siteId]/NAME, '/NF', @FORUMID, '?thread=', @THREADID)}">
                    <xsl:choose>
                        <xsl:when test="SUBJECT/text()">
                            <xsl:value-of select="SUBJECT"/> 
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:attribute name="class">
                                <xsl:text>nosubject</xsl:text>
                            </xsl:attribute>
                            <xsl:text>no subject</xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                </a> - (<xsl:value-of select="parent::POST/@COUNTPOSTS" /> message<xsl:if test="parent::POST/@COUNTPOSTS &gt; 1">s</xsl:if>)
            </p>
        	<p class="thread-additionalinfo">
        		<xsl:text>from </xsl:text>
        		<a href="{concat($host, '/dna/', /H2G2/SITE-LIST/SITE[@ID = $siteId]/NAME, '/NF', @FORUMID)}">
        			<xsl:value-of select="FORUMTITLE"/>
        		</a>
        		<xsl:text> in </xsl:text>
        		<xsl:apply-templates select="parent::POST/SITEID" mode="library_site_link"/>
        	</p>
            
            <div class="itemdetail">
              <xsl:if test="LASTUSERPOST">
                <p class="replydate">
                    <xsl:text>Last contribution: </xsl:text>
                    <a href="{concat($host, '/dna/', /H2G2/SITE-LIST/SITE[@ID = $siteId]/NAME, '/NF', @FORUMID, '?thread=', @THREADID, '&amp;post=',LASTUSERPOST/@POSTID, '#p', LASTUSERPOST/@POSTID)}">
	                    <xsl:apply-templates select="LASTUSERPOST/DATEPOSTED/DATE" mode="library_date_shortformat"/>
	                	<xsl:text> at </xsl:text>
	                	<xsl:apply-templates select="LASTUSERPOST/DATEPOSTED/DATE" mode="library_time_shortformat"/>
                	</a>
                	(<xsl:value-of select="LASTUSERPOST/DATEPOSTED/DATE/@RELATIVE"/>)
                </p>
              </xsl:if>
            	<p class="replies">
            		<xsl:if test="ancestor::POST-LIST/USER/USERID = /H2G2/VIEWING-USER/USER/USERID">
			            <xsl:text>New posts: </xsl:text><xsl:value-of select="number(parent::POST/@COUNTPOSTS) - number(parent::POST/@LASTPOSTCOUNTREAD)"/>
            			<br/>
            		</xsl:if>
            		<xsl:text>Latest post: </xsl:text>
            		<a href="{concat($host, '/dna/', /H2G2/SITE-LIST/SITE[@ID = $siteId]/NAME, '/NF', @FORUMID, '?thread=', @THREADID, '&amp;latest=1')}">
            			<xsl:apply-templates select="REPLYDATE/DATE" mode="library_date_shortformat"/>
            		</a>
            	</p>
            </div>                
        </li>
    </xsl:template>
  
  <xsl:template name="fixedLines">
    <xsl:param name="originalString" />
    <xsl:param name="charsPerLine" />
    <xsl:param name="lines" select="1"/>
    <xsl:param name="newString" select="''" />



    <xsl:choose>
      <xsl:when test="string-length($originalString) > $charsPerLine">
        <xsl:choose>
          <xsl:when test="$lines > 1">
            <!-- get last space within char limit -->
            <xsl:variable name="currentLineIndex">
              <xsl:call-template name="lastIndexOf">
                <xsl:with-param name="string" select="substring($originalString, 1, $charsPerLine -1)" />
                <xsl:with-param name="char" select="' '" />
              </xsl:call-template>
            </xsl:variable>

            <!-- call text to keep -->
            <xsl:variable name="currentLineText">
              <xsl:choose>
                <xsl:when test="$currentLineIndex = 0">
                  <xsl:value-of select="substring($originalString, 1, $charsPerLine)"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="substring($originalString, 1, $currentLineIndex)"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:variable>

            <xsl:variable name="newline">
              <xsl:text> </xsl:text>
            </xsl:variable>


            <xsl:variable name="newCurrentLineText">
              <xsl:value-of disable-output-escaping="no" select="concat(concat($newString, $currentLineText), $newline)"/>
            </xsl:variable>

            <!-- call self to get next line -->
            <xsl:call-template name="fixedLines">
              <xsl:with-param name="originalString" select="substring-after($originalString, $currentLineText)" />
              <xsl:with-param name="charsPerLine" select="$charsPerLine" />
              <xsl:with-param name="lines" select="$lines -1" />
              <xsl:with-param name="newString" select="$newCurrentLineText"/>
            </xsl:call-template>
            
          </xsl:when>
          <xsl:otherwise>
            <!-- last line -->
            <!-- get last space within char limit -->
            <xsl:variable name="lastSpaceIndex">
              <xsl:call-template name="lastIndexOf">
                <xsl:with-param name="string" select="substring($originalString, 1, $charsPerLine -3)" />
                <xsl:with-param name="char" select="' '" />
              </xsl:call-template>
            </xsl:variable>
            
            <!-- check if there is a space within max size-->
            <xsl:variable name="lastLineIndex">
              <xsl:choose>
                <xsl:when test="$lastSpaceIndex = $charsPerLine">
                  <xsl:value-of select="$charsPerLine - 3"/>
                </xsl:when>
                <xsl:when test="$lastSpaceIndex = 0">
                  <xsl:value-of select="$charsPerLine - 3"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="$lastSpaceIndex" />
                </xsl:otherwise>
              </xsl:choose>
            </xsl:variable>
            <!-- output string -->
            <xsl:value-of disable-output-escaping="no" select="concat(concat($newString, substring($originalString, 1, $lastLineIndex)), '...')"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of disable-output-escaping="no" select="concat($newString, $originalString)"/>        
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
    
    <xsl:template name="lastIndexOf">
    <!-- declare that it takes two parameters 
	  - the string and the char -->
    <xsl:param name="string" />
    <xsl:param name="char" />
    <xsl:param name="length" select="0" />
    <xsl:choose>
      
      <!-- if the string contains the character... -->
      <xsl:when test="contains($string, $char)">
        <!-- call the template recursively... -->
        <xsl:call-template name="lastIndexOf">
          <!-- with the string being the string after the character-->
          <xsl:with-param name="string" select="substring-after($string, $char)" />
          <!-- and the character being the same as before -->
          <xsl:with-param name="char" select="$char" />
          <xsl:with-param name="length" select="$length + string-length(substring-before($string, $char)) + 1" />
        </xsl:call-template>
      </xsl:when>
      <!-- otherwise, return the value of the string -->
      <xsl:otherwise>
        <xsl:value-of select="$length" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>