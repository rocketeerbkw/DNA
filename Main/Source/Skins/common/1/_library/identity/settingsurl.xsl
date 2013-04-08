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
            
            Make a general site config library stream, make individaul templates for
            LOGGEDINWELCOME, NOTLOGGEDINWELCOME and so on.
            
        </doc:notes>
    </doc:documentation>
    
    <xsl:template match="VIEWING-USER[USER or SIGNINNAME]" mode="library_identity_settingsurl">
        <xsl:param name="ptrt" />
        
		<xsl:choose>
			<xsl:when test="/H2G2/SITE/SITEOPTIONS/SITEOPTION[NAME='UseIDV4']/VALUE = '1'">
				<xsl:value-of select="concat($configuration/identity/url, '/settings?target_resource=')" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="concat($configuration/identity/url, '/users/dash?target_resource=')" />
			</xsl:otherwise>
		</xsl:choose>
<!--         <xsl:value-of select="concat($configuration/identity/url, '/users/dash?target_resource=')"/> -->
        
        <xsl:call-template name="library_string_urlencode">
        	<xsl:with-param name="string">
        		<xsl:choose>
        			<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_contact']/VALUE = 1">
        				<xsl:value-of select="/H2G2/SITE/SITEOPTIONS/SITEOPTION[NAME = 'CollectExtraDetails']/VALUE" />
        			</xsl:when>
        			<xsl:otherwise>
        				<xsl:value-of select="/H2G2/SITE/IDENTITYPOLICY" />
        			</xsl:otherwise>
        		</xsl:choose>
        	</xsl:with-param>
        </xsl:call-template>

        <xsl:if test="$ptrt">
            <xsl:text>&amp;ptrt=</xsl:text>
            <xsl:apply-templates select="/H2G2" mode="library_identity_ptrt">
            	<xsl:with-param name="urlidentification">settingsurl</xsl:with-param>
            </xsl:apply-templates>
        </xsl:if>        
        
    </xsl:template>
    
    <xsl:template match="VIEWING-USER" mode="library_identity_settingsurl" /> 
    
    
</xsl:stylesheet>