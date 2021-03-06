<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">
    
    <doc:documentation for="/sites/MySite/objects/post/generic.xsl">
        <doc:purpose>
            Holds the generic HTML construction of a comment
        </doc:purpose>
        <doc:context>
            Called by object-post (_common/_logic/_objects/post.xsl)
        </doc:context>
        <doc:notes>
            GuideML is the xml format (similiar to HTML) that user entered content is
            stored in. 
        </doc:notes>
    </doc:documentation>
    
    <xsl:template match="COMMENT" mode="object_comment">
    	<li id="comment{(POSTINDEX + 1)}">
    		<xsl:call-template name="library_listitem_stripe">
                <xsl:with-param name="additional-classnames">
                    <xsl:apply-templates select="USER" mode="library_user_notables"/>
                </xsl:with-param>
            </xsl:call-template>
    		<p>
    			<a href="{URL}#comment{POSTINDEX + 1}">
	                <span class="title">
	                    <xsl:value-of select="FORUMTITLE"/>
	                </span>
    			</a>
    		</p>
    		<div class="itemdetail">
    			<cite>
                    <span class="time">
                        <xsl:apply-templates select="DATEPOSTED" mode="library_time_shortformat" />
                    </span>
                    <xsl:text> on </xsl:text>
                    <span class="date">
                        <xsl:apply-templates select="DATEPOSTED" mode="library_date_shortformat" />
                    </span>
                </cite>
    		</div>
    		<p class="comment-text">
    			<xsl:apply-templates select="TEXT" mode="library_Richtext" >
                    <xsl:with-param name="escapeapostrophe" select="false()"/>
                </xsl:apply-templates>
    		</p>
    	</li>
    </xsl:template>

</xsl:stylesheet>
