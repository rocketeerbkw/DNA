<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">
	
	<doc:documentation>
		<doc:purpose>
			Displays the link to the Identity Dash pages where users can complete other attributes required by DNA. 
		</doc:purpose>
		<doc:context>
			Called by library_memberservice_policyurl
		</doc:context>
		<doc:notes>
			
			
			
		</doc:notes>
	</doc:documentation>
	
	<xsl:template match="VIEWING-USER" mode="library_identity_policyurl">
		<xsl:param name="ptrt" />
		
		<xsl:value-of select="concat($configuration/identity/url, '/users/dash/more?target_resource=')" />
		
        <xsl:call-template name="library_string_urlencode">
        	<xsl:with-param name="string">
        		<xsl:choose>
        			<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_contact']/VALUE = 1 and /H2G2/VIEWING-USER/USER/USERNAME">
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
			<!-- <xsl:value-of select="$host" /> -->
			<xsl:apply-templates select="/H2G2" mode="library_identity_ptrt">
         		<xsl:with-param name="urlidentification">registerurl</xsl:with-param>
         	</xsl:apply-templates>
			</xsl:if>
	</xsl:template>
	
</xsl:stylesheet>