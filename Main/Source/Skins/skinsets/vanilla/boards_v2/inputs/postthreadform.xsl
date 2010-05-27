<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">
    
    <doc:documentation>
        <doc:purpose>
            Transforms a collection of posts to HTML 
        </doc:purpose>
        <doc:context>
            Used by a MULTIPOSTS page
        </doc:context>
        <doc:notes>
            
        </doc:notes>
    </doc:documentation>
    
    
    <xsl:template match="POSTTHREADFORM" mode="input_postthreadform_error" />
    
    <xsl:template match="POSTTHREADFORM[@PROFANITYTRIGGERED = 1]" mode="input_postthreadform_error">
        <p class="dna-error">
            Your message contains a word, phrase or website address which is blocked from being posted on this website. Please edit your message before trying to post again.
        </p>
    </xsl:template>
    
    <xsl:template match="POSTTHREADFORM[@CANWRITE = 0]" mode="input_postthreadform">
      <div>
          <xsl:call-template name="library_header_h2">
            <xsl:with-param name="text">
                <xsl:text>Sorry...</xsl:text>
            </xsl:with-param>
        </xsl:call-template>
        <p class="closed">
            This discussion has been closed and is not now accepting any contributions.
        </p>
	</div>      
     
    </xsl:template>
    
    <xsl:template match="POSTTHREADFORM[@CANWRITE = 1]" mode="input_postthreadform">
      
    	<form action="{$root}/AddThread" method="post" class="dna-boards">
            <div>
                <xsl:call-template name="library_header_h2">
                    <xsl:with-param name="text"><xsl:value-of select="/H2G2/FORUMSOURCE/ARTICLE/SUBJECT" /></xsl:with-param>
                </xsl:call-template>
               
               <h4><xsl:value-of select="SUBJECT" /></h4>
               
            	<xsl:apply-templates select="SECONDSBEFOREREPOST"/>
              
              <xsl:choose>
                <xsl:when test="PREVIEWBODY">
                  <xsl:apply-templates select="." mode="preview"/>
                </xsl:when>
                <xsl:otherwise>
                  <p class="article">To reply to this message, type your message in the box below.</p>
                </xsl:otherwise>
              </xsl:choose>
              
              <input type="hidden" name="threadid" value="{@THREADID}"/>
              <input type="hidden" name="forum" value="{@FORUMID}"/>
              <input type="hidden" name="inreplyto" value="{@INREPLYTO}"/>
              <input type="hidden" name="dnapoststyle" value="1"/>
                
                <p>
                    <label for="dna-boards-body">Your reply</label>
                    <textarea id="dna-boards-body" name="body" class="textarea" rows="10" cols="10">
                       <xsl:value-of select="BODY" />     
                    </textarea>
                </p>
                <xsl:apply-templates select="." mode="input_postthreadform_error" />
                <ul>
                    <li><input type="submit" id="dna-boards-preview" name="preview" value="Preview" class="preview dna-button"/></li>
                    <li><input type="button" id="dna-boards-cancel" name="cancel" value="Cancel" class="cancel dna-button"/></li>
                    <li><input type="submit" id="dna-boards-submit" name="post" value="Post message" class="submit dna-button"/></li>
                </ul>
                
                <xsl:apply-templates select="/H2G2/ERROR" mode="object_error" />
            	
            </div>
        </form>
    	<xsl:apply-templates select="INREPLYTO" mode="input_postthreadform"/>
    </xsl:template>
	
	<xsl:template match="INREPLYTO" mode="input_postthreadform">
		<ul class="collections forumthreadposts">
			<li class="firstpost">
				<xsl:choose>
					<xsl:when test="USERID != '0'">
						<div class="itemdetail">
							<span class="createdby">
									In reply to
								<a href="MP{USERID}" class="user linked">
									<xsl:value-of select="USERNAME"/>
								</a>
								<xsl:text>:</xsl:text>
							</span>
						</div>
						<p>
							<xsl:apply-templates select="BODY" mode="library_GuideML" />
						</p>
					</xsl:when>
					<xsl:otherwise>
						<div class="itemdetail">
							<em>This post is hidden.</em>
						</div>
					</xsl:otherwise>
				</xsl:choose>	
			</li>
		</ul>
		
	</xsl:template>
 
    <xsl:template match="POSTTHREADFORM[@CANWRITE = 1 and @INREPLYTO = 0]" mode="input_postthreadform">
        <xsl:choose>
            <xsl:when test="$siteClosed = 'true'">
                <p class="dna-error">
                    Sorry, but <xsl:value-of select="/H2G2/SITECONFIG/BOARDNAME"/> message boards are currently closed.
                </p>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="library_userstate">
                    <xsl:with-param name="loggedin">
                    	
                        <form action="{$root}/AddThread" method="post" class="dna-boards">
                            <div>
                                <xsl:call-template name="library_header_h2">
                                    <xsl:with-param name="text">Start a new discussion</xsl:with-param>
                                    <xsl:with-param name="class">new-discussion</xsl:with-param>
                                </xsl:call-template>
                            	
                            	<xsl:apply-templates select="SECONDSBEFOREREPOST"/>
                                
                              <xsl:choose>
                                <xsl:when test="PREVIEWBODY">
                                  <xsl:apply-templates select="." mode="preview"/>
                                </xsl:when>
                                <xsl:otherwise>
                                  <p class="article">To create a new discussion in the , fill out the form below.</p>
                                </xsl:otherwise>
                              </xsl:choose>
                                
                                <input type="hidden" name="threadid" value="{@THREADID}"/>
                                <input type="hidden" name="forum" value="{@FORUMID}"/>
                                <input type="hidden" name="inreplyto" value="{@INREPLYTO}"/>
                                <input type="hidden" name="dnapoststyle" value="1"/>
                                
                                <p>
                                    <label for="dna-boards-subject">Title of your discussion</label>
                                    <input type="text" name="subject" id="dna-boards-subject" value="{SUBJECT}" class="text"/>
                                </p>
                                
                                <p>
                                    <label for="dna-boards-body">Your thoughts on the topic</label>
                                    <textarea id="dna-boards-body" name="body" class="textarea" rows="10" cols="10">
                                        <xsl:value-of select="BODY" />     
                                    </textarea>
                                </p>
                                <xsl:apply-templates select="." mode="input_postthreadform_error" />
                                <ul>
                                    <li><input type="submit" id="dna-boards-preview" name="preview" value="Preview" class="preview dna-button"/></li>
                                    <li><input type="button" id="dna-boards-cancel" name="cancel" value="Cancel" class="cancel dna-button"/></li>
                                    <li><input type="submit" id="dna-boards-submit" name="post" value="Post message" class="submit dna-button"/></li>
                                </ul>
                                
                                <xsl:apply-templates select="/H2G2/ERROR" mode="object_error" />
                            </div>
                        </form>
                    </xsl:with-param>
                    <xsl:with-param name="unauthorised">
                        <h3>Almost there...</h3>
                        <p>
                            <xsl:text>You are nearly ready to contribute, however we need you to </xsl:text>
                            <a href="{$root}/AddThread?inreplyto={@POSTID}" class="id-cta">
                                <xsl:call-template name="library_memberservice_require">
                                    <xsl:with-param name="ptrt">
                                        <xsl:value-of select="$root"/>
                                        <xsl:text>/AddThread?inreplyto=</xsl:text>
                                        <xsl:value-of select="@POSTID"/>
                                    </xsl:with-param>
                                </xsl:call-template>
                                accept the House Rules and verify your email address
                            </a>
                            <xsl:text> first.</xsl:text>
                        </p>
                    </xsl:with-param>
                    <xsl:with-param name="loggedout">
                        <h3>Please log in</h3>
                        <p>
                            <xsl:text>You must be logged in to contribute. Please log in </xsl:text>
                            <a href="{$root}/AddThread?inreplyto={@POSTID}" class="id-cta">
                                <xsl:call-template name="library_memberservice_require">
                                    <xsl:with-param name="ptrt">
                                        <xsl:value-of select="$root"/>
                                        <xsl:text>/AddThread?inreplyto=</xsl:text>
                                        <xsl:value-of select="@POSTID"/>
                                    </xsl:with-param>
                                </xsl:call-template>
                                <xsl:text>here</xsl:text>
                            </a>
                            <xsl:text>.</xsl:text>
                        </p>
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

	<xsl:template match="SECONDSBEFOREREPOST">

		<xsl:variable name="minutestowait">
			<xsl:value-of select="floor(/H2G2/POSTTHREADFORM/SECONDSBEFOREREPOST div 60)" />
		</xsl:variable>
		
		<xsl:variable name="secondsstowait">
			<xsl:value-of select="/H2G2/POSTTHREADFORM/SECONDSBEFOREREPOST mod 60" />
		</xsl:variable>
		
		<p id="countdown"><strong>You must wait  <span id="minuteValue"><xsl:value-of select="$minutestowait"/></span> minutes  <span id="secondValue"><xsl:value-of select="$secondsstowait"/></span> secs before you can post again</strong></p>
	</xsl:template>
	
  <xsl:template match="POSTTHREADFORM[PREVIEWBODY]" mode="preview">
  	<p class="preview">Previewing your post:</p>
      <div>
      <ul>
        <li>
          <xsl:if test="@INREPLYTO = 0">
            <h4><xsl:value-of select="SUBJECT"/></h4>
          </xsl:if>
          <div class="itemdetail">
            <span class="createdby">
              <span>Message posted by </span>
              <a href="MP{/H2G2/VIEWING-USER/USER/USERID}" class="user linked">
                <xsl:value-of select="/H2G2/VIEWING-USER/USER/USERNAME"/>
              </a>
              <xsl:text>:</xsl:text>
            </span>
          </div>
          <p>
            <xsl:apply-templates select="PREVIEWBODY" mode="library_GuideML" />
          </p>
        </li>
      </ul>
    </div>
	</xsl:template>

	
</xsl:stylesheet>