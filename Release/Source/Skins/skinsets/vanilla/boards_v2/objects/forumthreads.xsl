<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">
    
    <doc:documentation>
        <doc:purpose>
            Transforms THREAD elements belonging to a forum. 
        </doc:purpose>
        <doc:context>
            Can be used on ARTICLE AND USERPAGE
        </doc:context>
        <doc:notes>
            
        </doc:notes>
    </doc:documentation>
    
    
    <xsl:template match="FORUMTHREADS[THREAD]" mode="object_forumthreads">
        <xsl:if test="$siteClosed = 'false'">
			<xsl:apply-templates select="." mode="library_startnewdiscussion_link" />
        </xsl:if>
        
        <xsl:apply-templates select="." mode="library_pagination_forumthreads" />
        
        <h2 class="blq-hide">Threads for <xsl:value-of select="/H2G2/FORUMSOURCE/ARTICLE/SUBJECT" /></h2><br />
        <div class="numDiscussions"><strong>Discussions: </strong><xsl:value-of select="/H2G2/FORUMTHREADS/@SKIPTO + 1" /><xsl:text> - </xsl:text><xsl:value-of select="/H2G2/FORUMTHREADS/@SKIPTO + /H2G2/FORUMTHREADS/THREAD[last()]/@INDEX+1" /> of <xsl:value-of select="/H2G2/FORUMTHREADS/@TOTALTHREADS" /></div>
        <table class="forumthreads" id="topofthreads">
        	<thead>
	        	<tr>
	        		<th id="discussion">Discussion</th>
	        		<th id="replies">Replies</th>
	        		<th id="startedby">Started by</th>
	        		<th id="latestreply">Latest reply</th>
	        	</tr>
        	</thead>
          	<tbody>
          		<xsl:apply-templates select="THREAD" mode="object_thread" />
          	</tbody>
        </table>
        
        <p class="backtotop"><a href="#topofthreads">Back to top</a></p>
        
        <xsl:apply-templates select="." mode="library_pagination_forumthreads" />
        
        <xsl:call-template name="library_userstate_editor">
            <xsl:with-param name="loggedin">
              <xsl:apply-templates select="MODERATIONSTATUS" mode="moderation_cta_moderationstatus"/>
            </xsl:with-param>
          </xsl:call-template>
        
    </xsl:template>
    
    
    <xsl:template match="FORUMTHREADS" mode="object_forumthreads">
        <xsl:if test="$siteClosed = 'false'">
           	<xsl:apply-templates select="." mode="library_startnewdiscussion_link" />
        </xsl:if>
        
        <p class="forumthreads">
            There have been no discussions started here yet.
        </p>
        
        <xsl:call-template name="library_userstate_editor">
            <xsl:with-param name="loggedin">
              <xsl:apply-templates select="MODERATIONSTATUS" mode="moderation_cta_moderationstatus"/>
            </xsl:with-param>
        </xsl:call-template>
        
        
    </xsl:template>
    
</xsl:stylesheet>