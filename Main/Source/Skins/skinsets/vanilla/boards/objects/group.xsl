<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">
    
    <doc:documentation>
        <doc:purpose>
            Transforms a collection of posts to HTML 
        </doc:purpose>
        <doc:context>
            Used by a MULTIPOSTS page
        </doc:context>
        <doc:notes>
            
        </doc:notes>
    </doc:documentation>
    
    
    
    <xsl:template match="GROUP" mode="object_group">
        <li>
            <input type="checkbox" name="GroupsMenu" id="group-{@ID}" value="{@ID}">
                <xsl:if test="ancestor::INSPECT-USER-FORM/USER/GROUPS/GROUP/NAME[./text() = string(current()/@ID)]">
                    <xsl:attribute name="checked">
                        <xsl:text>checked</xsl:text>
                    </xsl:attribute>
                </xsl:if>
            </input>
            
            <label for="group-{@ID}">
                <xsl:value-of select="@NAME" />
            </label>
        </li>
    </xsl:template>
    
</xsl:stylesheet>