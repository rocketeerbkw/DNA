<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation" exclude-result-prefixes="doc">
    
    <doc:documentation>
        <doc:purpose>
            Displays identity links depending on user login state
        </doc:purpose>
        <doc:context>
           
        </doc:context>
        <doc:notes>
           
        </doc:notes>
    </doc:documentation>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
    
    
    <xsl:template match="VIEWING-USER"  mode="library_identity_cta">
    	<xsl:param name="signin-text" />
    	
    	<xsl:variable name="idptrt" select="concat($root,'/AddThread?forum=', @FORUMID, '%26article=', /H2G2/FORUMSOURCE/ARTICLE/ARTICLEINFO/H2G2ID)" />
    	
    	<div class="id-wrap blq-clearfix">
    		<xsl:choose>
	    		<xsl:when test="not(IDENTITY)">
			    	<a class="id-signin">
						<xsl:attribute name="href">
				            <xsl:apply-templates select="." mode="library_identity_loginurl">
				                <xsl:with-param name="ptrt" select="$idptrt" />
				            </xsl:apply-templates>	
				    	</xsl:attribute>
			    	Sign in</a>
			    	<p> or 
			    	<a>
				    	<xsl:attribute name="href">
							<xsl:value-of select="/H2G2/SITE/SITEOPTIONS/SITEOPTION[@GLOBAL='0'][NAME = 'AutoGeneratedNames']/VALUE" />			    	
				    	</xsl:attribute>
				    	<xsl:text>register</xsl:text>
			    	</a>&#160;<xsl:value-of select="$signin-text" /></p>
    			</xsl:when>
    			<xsl:when test="$autogenname_required = 'true'">
	            	<p class="completereg">
	            		<xsl:text>You need to  </xsl:text>
		            	<a>
		            		<xsl:attribute name="href">
					            <xsl:apply-templates select="." mode="library_identity_udngurl">
					                <xsl:with-param name="ptrt" select="$idptrt" />
					            </xsl:apply-templates>
				            </xsl:attribute>
				            <xsl:text>choose a Screen Name</xsl:text>	
			            </a>	
			            <xsl:text> before you can use the messageboards.</xsl:text>
		            </p>    				
    			</xsl:when>
	            <xsl:otherwise>
	            	<xsl:choose>
		            	<xsl:when test="USER">
							<xsl:comment>do nothing</xsl:comment>
			            </xsl:when>
			            <xsl:otherwise>
			            	<p class="completereg">
				            	<a>
				            		<xsl:attribute name="href">
							            <xsl:apply-templates select="." mode="library_identity_policyurl">
							                <xsl:with-param name="ptrt" select="$idptrt" />
							            </xsl:apply-templates>
						            </xsl:attribute>
						            <xsl:text>Please complete your registration</xsl:text>	
					            </a>	
				            </p>			            
			            </xsl:otherwise>
		            </xsl:choose>	            
	            </xsl:otherwise>
            </xsl:choose>		    	
    	</div>
    </xsl:template>
    
</xsl:stylesheet>