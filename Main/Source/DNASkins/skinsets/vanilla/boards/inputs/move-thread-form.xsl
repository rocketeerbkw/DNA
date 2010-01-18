<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">
    
    <doc:documentation>
        <doc:purpose>
            Move a thread
        </doc:purpose>
        <doc:context>
            
        </doc:context>
        <doc:notes>
            
        </doc:notes>
    </doc:documentation>
    
    <xsl:template match="MOVE-THREAD-FORM" mode="input_move-thread-form">
        <xsl:variable name="thisForumId">
            <xsl:choose>
                <xsl:when test="NEW-FORUM-ID = 0"><xsl:value-of select="OLD-FORUM-ID"/></xsl:when>
                <xsl:otherwise><xsl:value-of select="NEW-FORUM-ID"/></xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
    	
    	
    	
        <form method="post" class="dna-boards" action="{$root}/MoveThread" name="MoveThreadForm{@THREAD-ID}">
            <div id="dnaacs">
                <xsl:call-template name="library_header_h3">
                    <xsl:with-param name="text">Move A Thread</xsl:with-param>
                </xsl:call-template>
                
                <xsl:if test="SUCCESS = 1">
                    <p class="dna-success">
                        The thread has successfully been moved.
                    	<a href="{$root}/F{NEW-FORUM-ID}">Go back to the <xsl:value-of select="$discussion"/>.</a>
                    </p>
                </xsl:if>
            	
            	<xsl:if test="ERROR">
            		<p class="dna-error"><xsl:value-of select="ERROR"/></p>
            	</xsl:if>
                
                <input type="hidden" name="mode" value="{/H2G2/@MODE}"/>
                <input type="hidden" name="AutoPostID" value="{AUTO-POST-ID}"/>
                <input type="hidden" name="cmd" value="move"/>
                
                <p>
                    Where would you like to move '<xsl:value-of select="THREAD-SUBJECT"/>' to?
                    <input type="hidden" name="ThreadID" value="{number(THREAD-ID)}" id="dna-movethread-subject"/>
                </p>
                <p>
                    <label for="dna-movethread-destination">To: </label>
                    <select name="DestinationID" id="dna-movethread-destination">
                        <option value="">Choose thread...</option>
                        <xsl:for-each select="/H2G2/TOPICLIST/TOPIC">
                            <option value="F{FORUMID}">
                                <xsl:if test="FORUMID = $thisForumId">
                                    <xsl:attribute name="selected">selected</xsl:attribute>
                                </xsl:if>
                                <xsl:value-of select="TITLE"/>
                            </option>
                        </xsl:for-each>
                     </select>
                </p>
                <p>
                    <label for="dna-movethread-post">Post: </label>
                    <textarea name="PostContent" id="dna-movethread-post" class="textarea">
                       <xsl:value-of select="POST-CONTENT"/>
                    </textarea>
                </p>
                <xsl:apply-templates select="." mode="input_move-thread-form_error" />
                <p>              	
                    <input type="submit" id="dna-movethread-submit" name="submit" value="Move Thread" class="submit" />
                </p>
                
            </div>
        </form>
    </xsl:template>
    
    <!-- error handling -->
    <xsl:template match="MOVE-THREAD-FORM" mode="input_move-thread-form_error" />
    
    <xsl:template match="MOVE-THREAD-FORM[ERROR]" mode="input_move-thread-form_error">
        <p class="dna-error">
            <xsl:value-of select="ERROR"/>
        </p>
    </xsl:template>
    
</xsl:stylesheet>