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
			            	<xsl:choose>
				            	<xsl:when test="string-length(SUBJECT) >= 72">
				            		<xsl:value-of select="concat(substring(SUBJECT, 1, 72), '...')" />
				            	</xsl:when>
				            	<xsl:otherwise>
				            		<xsl:value-of select="SUBJECT" />
				            	</xsl:otherwise>
			            	</xsl:choose>
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
            	<xsl:choose>
	            	<xsl:when test="string-length(FIRSTPOST/TEXT) >= 72">
	            		<xsl:value-of select="concat(substring(FIRSTPOST/TEXT, 1, 62), '...')" />
	            	</xsl:when>
	            	<xsl:otherwise>
	            		<xsl:value-of select="FIRSTPOST/TEXT" />
	            	</xsl:otherwise>
            	</xsl:choose>
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
	             	<!-- Split the string as it was destroying table layout -->
	             	<xsl:variable name="firstpostuser">
						<xsl:apply-templates select="FIRSTPOST/USER" mode="library_user_username" />
					</xsl:variable>	             	
	             	
	             	<xsl:variable name="stringlimit">15</xsl:variable>
	             	<xsl:choose>
	             		<xsl:when test="string-length($firstpostuser) >= $stringlimit">
	             			<xsl:variable name="stringlength">
	             				<xsl:value-of select="string-length($firstpostuser)" />
	             			</xsl:variable>	             			
	             			<xsl:variable name="tempstring1">
	             				<xsl:value-of select="substring($firstpostuser, 1, $stringlimit)" />
	             			</xsl:variable>
	             			<xsl:variable name="tempstring2">
	             				<xsl:value-of select="substring($firstpostuser, $stringlimit+1, $stringlength)" />
	             			</xsl:variable>	 
	             			            		
	             			<xsl:value-of select="$tempstring1" /><br /><xsl:value-of select="$tempstring2" />    
	             			
	             		</xsl:when>
	             		<xsl:otherwise>
	                 		<xsl:value-of select="$firstpostuser" />
	                 	</xsl:otherwise>
	                 </xsl:choose>
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
                </a>
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
                <p class="replydate">
                    <xsl:text>Last contribution: </xsl:text>
                    <xsl:apply-templates select="REPLYDATE/DATE" mode="library_date_shortformat"/>
                	<xsl:text> at </xsl:text>
                	<xsl:apply-templates select="REPLYDATE/DATE" mode="library_time_shortformat"/>
                	(<xsl:value-of select="REPLYDATE/DATE/@RELATIVE"/>)
                </p>
            	<p class="replies">
            		<xsl:if test="ancestor::POST-LIST/USER/USERID = /H2G2/VIEWING-USER/USER/USERID">
			            <xsl:text>New posts: </xsl:text><xsl:value-of select="number(parent::POST/@COUNTPOSTS) - number(parent::POST/@LASTPOSTCOUNTREAD)"/>
            			<br/>
            		</xsl:if>
            		<xsl:text>Latest post: </xsl:text>
            		<a href="{concat($host, '/dna/', /H2G2/SITE-LIST/SITE[@ID = $siteId]/NAME, '/NF', @FORUMID, '?thread=', @THREADID, '&amp;latest=1#p', LASTUSERPOST/@POSTID)}">
            			<xsl:apply-templates select="REPLYDATE/DATE" mode="library_date_shortformat"/>
            		</a>
            	</p>
            </div>                
        </li>
    </xsl:template>
</xsl:stylesheet>