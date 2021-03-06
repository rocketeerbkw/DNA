<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">
    
    <doc:documentation>
        <doc:purpose>
            Displays the SSO sign in / sign out typically found on user generated pages. 
        </doc:purpose>
        <doc:context>
            Called on request by skin
        </doc:context>
        <doc:notes>
            
            NOTE: If the site is Barlesque-ed, then the Barlesque header will handle all this 
            
        </doc:notes>
    </doc:documentation>
    
    <xsl:template match="VIEWING-USER" mode="library_identity_loginurl">
        <xsl:param name="ptrt" />
        
    	<xsl:value-of select="concat($configuration/identity/url, '/users/login?target_resource=')"/>
    	
    	<!-- hard coded hack to allow the sign in link to show the 'contact me' details in have your say -->
	    <xsl:variable name="policy">	
	    	<xsl:choose>
	    		<xsl:when test="/H2G2/SITE/NAME = 'blog477'">
	    			<xsl:text>http://identity/policies/dna/adult</xsl:text>
	    		</xsl:when>
	    		<xsl:otherwise>
	    			<xsl:value-of select="/H2G2/SITE/IDENTITYPOLICY" />
	    		</xsl:otherwise>
    		</xsl:choose>
    	</xsl:variable>
    		    	
    	<xsl:call-template name="library_string_urlencode">
			<xsl:with-param name="string" select="$policy" />
    	</xsl:call-template>
    	
         <xsl:if test="$ptrt">
         	<xsl:text>&#38;ptrt=</xsl:text>
         	<xsl:apply-templates select="/H2G2" mode="library_identity_ptrt" />
        </xsl:if>   
    </xsl:template>
    
</xsl:stylesheet>