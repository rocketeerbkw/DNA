<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
	xmlns="http://www.w3.org/1999/xhtml" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	version="1.0" 
	xmlns:doc="http://www.bbc.co.uk/dna/documentation"  
	exclude-result-prefixes="doc">
    
    <doc:documentation for="/sites/MySite/objects/post/generic.xsl">
        <doc:purpose>
            Transforms USER node into contact card HTML 
        </doc:purpose>
        <doc:context>
            
        </doc:context>
        <doc:notes>
            
        </doc:notes>
    </doc:documentation>
    
    
    <xsl:template match="USER" mode="object_user_detail">
        
        <div class="user detail">
            <p>
                <xsl:apply-templates select="." mode="object_user_linked"/>
            	<xsl:apply-templates select="../DATEPOSTED" mode="library_itemdetail" />
            </p>
            <p class="links">
                <!--<xsl:if test="FIRSTNAMES/text() and LASTNAME/text()">
                    <span class="username">
                    	<xsl:value-of select="FIRSTNAMES"/>
	                    <xsl:text> </xsl:text>
	                    <xsl:value-of select="LASTNAME"/>
                    </span>
                </xsl:if>-->
                <a href="U{USERID}">View Profile</a> | <a href="MJ{USERID}?Journal={JOURNAL}">Read Journal</a>
            </p>
        </div>
        
    </xsl:template>
</xsl:stylesheet>
