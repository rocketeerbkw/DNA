<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation" exclude-result-prefixes="doc">
    
    <doc:documentation>
        <doc:purpose>
            Displays new discussion link depending on user login state
        </doc:purpose>
        <doc:context>
            Commonly applied on a skin specific page layout.
        </doc:context>
        <doc:notes>
           	checks user login state and displays relevant link for start new discussion
        </doc:notes>
    </doc:documentation>
    
    
    <xsl:template match="FORUMTHREADS" mode="library_startnewdiscussion_link">
    
    	<xsl:choose>
	    	<xsl:when test="not(/H2G2/VIEWING-USER/USER/USERNAME)">
	    		<xsl:apply-templates select="/H2G2/VIEWING-USER" mode="library_identity_cta">
	    			<xsl:with-param name="signin-text"><xsl:value-of select="$signin-discussion-text" /></xsl:with-param>
	    		</xsl:apply-templates>
	    	</xsl:when>
	    	
	    	<xsl:otherwise>
				<p class="dna-boards-startanewdiscussion">
					<a href="{$root}/AddThread?forum={@FORUMID}%26article={/H2G2/FORUMSOURCE/ARTICLE/ARTICLEINFO/H2G2ID}" class="id-cta">
				        <xsl:call-template name="library_memberservice_require">
				            <xsl:with-param name="ptrt">
				                <xsl:value-of select="$root"/>
				                <xsl:text>/AddThread?forum=</xsl:text>
				                <xsl:value-of select="@FORUMID"/>
				            	<xsl:text>%26article=</xsl:text>
				                <xsl:value-of select="/H2G2/FORUMSOURCE/ARTICLE/ARTICLEINFO/H2G2ID"/>
				            </xsl:with-param>
				        </xsl:call-template>
				        <xsl:text>Start a new discussion</xsl:text>
				    </a>          
				</p>
			</xsl:otherwise>
		</xsl:choose>
		
    </xsl:template>
    
</xsl:stylesheet>