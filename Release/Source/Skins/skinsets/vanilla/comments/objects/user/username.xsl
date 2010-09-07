<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">
    
    <doc:documentation for="/sites/MySite/objects/post/generic.xsl">
        <doc:purpose>
            Transforms USERNAME to SITESUFFIX if site specific display name is selected in site options
        </doc:purpose>
        <doc:context>
            
        </doc:context>
        <doc:notes>
            
        </doc:notes>
    </doc:documentation>
    
    
    <xsl:template match="USER" mode="object_user_username">
        <xsl:param name="stringlimit" />

		<xsl:variable name="username">
			<xsl:choose>
				<xsl:when test="/H2G2/SITE/SITEOPTIONS/SITEOPTION[NAME = 'UseSiteSuffix']/VALUE = '1' and SITESUFFIX != ''">	
					<xsl:value-of select="SITESUFFIX" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="USERNAME" />
				</xsl:otherwise>	
			</xsl:choose>
		</xsl:variable>
		
		<xsl:choose>
			<xsl:when test="string-length($stringlimit) != 0">
				<xsl:choose>
					<xsl:when test="string-length(normalize-space($username)) &lt; $stringlimit"> 
						<xsl:value-of select="$username"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:variable name="truncatestring"><xsl:value-of select="substring($username, 1, $stringlimit)" /></xsl:variable>
						<xsl:value-of select="concat($truncatestring, '...')" />
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$username"/>
			</xsl:otherwise>
		</xsl:choose>
        
    </xsl:template>
</xsl:stylesheet>