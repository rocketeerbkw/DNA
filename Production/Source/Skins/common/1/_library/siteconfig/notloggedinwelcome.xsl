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
    
	<xsl:template match="NOTLOGGEDINWELCOME" mode="library_siteconfig_notloggedinwelcome">
		<xsl:param name="ptrt" select="''"/>
		<xsl:apply-templates mode="library_siteconfig_inline">
			<xsl:with-param name="ptrt" select="$ptrt"/>			
		</xsl:apply-templates>
	</xsl:template>
	
	<xsl:template match="NOTLOGGEDINWELCOME" mode="library_siteconfig_notloggedinwelcome_comments">
		<xsl:param name="ptrt" select="''"/>
		<xsl:choose>
			<xsl:when test="/H2G2/SITE/IDENTITYSIGNIN = 1">
				<a class="identity-login">
					<xsl:call-template name="library_memberservice_require">
						<xsl:with-param name="ptrt" select="$ptrt"/>
					</xsl:call-template>
					<xsl:text>Sign in</xsl:text>
				</a>
				<xsl:text> or </xsl:text>
				<a>
					<xsl:attribute name="href">
						<xsl:apply-templates select="/H2G2/VIEWING-USER" mode="library_memberservice_registerurl">
							<xsl:with-param name="ptrt" select="$ptrt"/>
						</xsl:apply-templates>
					</xsl:attribute>
					<xsl:text>register</xsl:text>
				</a>
				<xsl:text> to comment.</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates mode="library_siteconfig_inline">
					<xsl:with-param name="ptrt" select="$ptrt"/>			
				</xsl:apply-templates>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
</xsl:stylesheet>