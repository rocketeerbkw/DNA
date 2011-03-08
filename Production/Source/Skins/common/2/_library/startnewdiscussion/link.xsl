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
	    	<xsl:when test="/H2G2/FORUMSOURCE/ARTICLE/GUIDE/BODY/EDITORONLY and not(/H2G2/VIEWING-USER/USER/GROUPS/GROUP[NAME = 'EDITOR'])">
	    		<!-- if the editoronly tag is flagged and the user is not an editor then do not show start new discussion link -->
	    	</xsl:when>
	    	<xsl:when test="/H2G2/VIEWING-USER/USER/STATUS = 0">
	    		<!-- Don't show start new discussion link -->
	    	</xsl:when>
	    	<!--  this is a duplication - need to optimise this when have more time -->
   			<xsl:when test="$autogenname_required = 'true'">
            	<p class="article text">
            		<xsl:text>You need to  </xsl:text>
	            	<a>
	            		<xsl:attribute name="href">
				            <xsl:value-of select="/H2G2/SITE/SITEOPTIONS/SITEOPTION[@GLOBAL='0'][NAME = 'AutoGeneratedNames']/VALUE" />
			            </xsl:attribute>
			            <xsl:text>choose a Screen Name</xsl:text>	
		            </a>	
		            <xsl:text> before you can use the messageboards.</xsl:text>
	            </p>    				
   			</xsl:when>	    	
	    	<xsl:otherwise>
	    		<xsl:if test="@CANWRITE = '1'">
					<p class="dna-boards-startanewdiscussion">
						<a href="{$root}/posttoforum?forum={@FORUMID}" class="id-cta">
					        <xsl:text>Start a new discussion</xsl:text>
					    </a>          
					</p>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
		
    </xsl:template>
    
</xsl:stylesheet>