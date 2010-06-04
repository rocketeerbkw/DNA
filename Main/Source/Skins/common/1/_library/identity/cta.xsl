<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation" exclude-result-prefixes="doc">
    
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
    	<xsl:variable name="idptrt" select="concat($root,'/AddThread?forum=', @FORUMID, '%26article=', /H2G2/FORUMSOURCE/ARTICLE/ARTICLEINFO/H2G2ID)" />
     
      <p>Please 
    		<xsl:choose>
	    		<xsl:when test="not(IDENTITY)">
			    	<a class="id-signin">
						<xsl:attribute name="href">
				            <xsl:apply-templates select="." mode="library_identity_loginurl">
				                <xsl:with-param name="ptrt" select="$idptrt" />
				            </xsl:apply-templates>	
				    	</xsl:attribute>
			    	sign in</a> or <a>
				    	<xsl:attribute name="href">
							<xsl:apply-templates select="." mode="library_identity_registerurl">
							    <xsl:with-param name="ptrt" select="$idptrt" />
							</xsl:apply-templates>			    	
				    	</xsl:attribute> 
				    	<xsl:text>register</xsl:text>
			    	</a>  to BBC iD to use this service.
    			</xsl:when>
	            <xsl:otherwise>
	            	<xsl:choose>
		            	<xsl:when test="USER">
							<xsl:comment>do nothing</xsl:comment>
			            </xsl:when>
			            <xsl:otherwise>
				            	<a>
				            		<xsl:attribute name="href">
							            <xsl:apply-templates select="." mode="library_identity_policyurl">
							                <xsl:with-param name="ptrt" select="$idptrt" />
							            </xsl:apply-templates>
						            </xsl:attribute>
						            <xsl:text>Please complete your registration</xsl:text>	
					            </a>		            
			            </xsl:otherwise>
		            </xsl:choose>	            
	            </xsl:otherwise>
            </xsl:choose>
      </p>
    </xsl:template>
    
</xsl:stylesheet>