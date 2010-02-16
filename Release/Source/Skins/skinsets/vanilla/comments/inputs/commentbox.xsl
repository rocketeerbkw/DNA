<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">
    
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
    
    
    <xsl:template match="FORUMTHREADPOSTS[preceding-sibling::ENDDATE/DATE/@SORT &lt; /H2G2/DATE/@SORT]" mode="input_commentbox">
        <p class="dna-commentbox-nocomments">
            <xsl:apply-templates select="/H2G2/SITECONFIG/DNACOMMENTTEXT/FORUMCLOSEDMESSAGE" mode="library_siteconfig_forumclosedmessage" />
        </p>
    </xsl:template>
    
    <xsl:template match="FORUMTHREADPOSTS[@CANWRITE = 0]" mode="input_commentbox">
        <p class="dna-commentbox-nocomments">
            <xsl:apply-templates select="/H2G2/SITECONFIG/DNACOMMENTTEXT/FORUMCLOSEDMESSAGE" mode="library_siteconfig_forumclosedmessage" />
        </p>
    </xsl:template>
    
    
    <xsl:template match="FORUMTHREADPOSTS" mode="input_commentbox">
        
        <form action="{$root}/acs" method="post" class="dna-commentbox" id="postcomment">
            <div id="dnaacs">
                <h3>Post a comment</h3>
                
                <p class="dna-moderation-message">
                    <xsl:apply-templates select="@MODERATIONSTATUS" mode="library_moderation_moderationstatus">
                        <xsl:with-param name="unmod">
                            <xsl:apply-templates select="/H2G2/SITECONFIG/DNACOMMENTTEXT/UNMODLABEL" mode="library_siteconfig_unmodlabel"/>
                        </xsl:with-param>
                        <xsl:with-param name="premod">
                            <xsl:apply-templates select="/H2G2/SITECONFIG/DNACOMMENTTEXT/PREMODLABEL" mode="library_siteconfig_premodlabel"/>
                        </xsl:with-param>
                        <xsl:with-param name="postmod">
                            <xsl:apply-templates select="/H2G2/SITECONFIG/DNACOMMENTTEXT/POSTMODLABEL" mode="library_siteconfig_postmodlabel"/>
                        </xsl:with-param>
                    </xsl:apply-templates>
                </p>
                
                
                <input type="hidden" name="dnauid" value="{@UID}"/>
                <input type="hidden" value="add" name="dnaaction"/>
                <input type="hidden" value="1" name="dnaur"/>
                <input type="hidden" value="1" name="dnapoststyle"/>
                
                <p>
                    <label for="dna-commentbox-text">Your Comment</label>
                    <textarea id="dna-commentbox-text" name="dnacomment">
                        <xsl:text> </xsl:text>
                    	<xsl:value-of select="/H2G2/ERROR[@TYPE = 'XmlParseError']/EXTRAINFO" disable-output-escaping="yes"/>
                    </textarea>
                </p>
                <p>
                    <label for="dna-commentbox-submit" class="dna-invisible">Send your comment</label>
                    <input type="submit" id="dna-commentbox-submit" name="dnasubmit" value="Post Comment"/>
                </p>
                
                <xsl:apply-templates select="/H2G2/ERROR" mode="object_error" />
                
            </div>
        </form>
        
    </xsl:template>
    
	<xsl:template match="FORUMTHREADPOSTS" mode="input_contactbox">
	
		<div id="dnaacs">
			<!-- where should all this copy go? -->
       		<h3 id="postcomment">Post a comment</h3>
       		<p>Before you post a comment, we would like to ask you a question.<br />Occasionally the BBC might like to contact you to discuss your comments.</p>
       		<p>If you would like us to call you, you can supply your telephone number by clicking the 'contact me' button below, your details will be stored securely and will not be passed on to other websites or companies.</p>
       		<p>If you would rather we don't call you, continue on by clicking 'no thanks', to leave your comment on this blog.</p>
       	
       		<ul>
	       		<li>
		       		<a>
					<xsl:attribute name="href">
						<xsl:apply-templates select="/H2G2/VIEWING-USER" mode="library_identity_policyurl" >
							<xsl:with-param name="ptrt">
								<xsl:apply-templates select="/H2G2/VIEWING-USER" mode="library_identity_ptrt" />
							</xsl:with-param>
						</xsl:apply-templates>
					</xsl:attribute>
		       		Contact me</a>
	       		</li>
       			<li>&#160;<a href="?dnauid={/H2G2/COMMENTBOX/FORUMTHREADPOSTS/@UID}&amp;userid={/H2G2/VIEWING-USER/USER/USERID}&amp;s_contact=0#postcomment">No thanks</a></li>
       		</ul>
       	</div>	
	</xsl:template>    
    
</xsl:stylesheet>