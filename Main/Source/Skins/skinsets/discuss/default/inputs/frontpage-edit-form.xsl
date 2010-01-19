<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">
    
    <doc:documentation>
        <doc:purpose>
            Defines HTML for article link on the categories page
        </doc:purpose>
        <doc:context>
            Applied in objects/collections/members.xsl
        </doc:context>
        <doc:notes>
            
        </doc:notes>
    </doc:documentation>
    

    <xsl:template match="FRONTPAGE-EDIT-FORM[BODY = '']" mode="input_frontpage-edit-form">
        <form action="{$root}/EditFrontpage" method="post"> 
            <fieldset>
                <legend>Frontpage</legend>
                
                <textarea name="bodytext" cols="72" rows="25">
                    <GUIDE>
                        <BODY>
                        </BODY>
                    </GUIDE>
                </textarea>
                
                <input type="submit" name="storepage" value="Store page" />
            </fieldset>
        </form>
    </xsl:template>

    <xsl:template match="FRONTPAGE-EDIT-FORM" mode="input_frontpage-edit-form">
        <form action="{$root}/EditFrontpage" method="post"> 
            <fieldset>
                <legend>Frontpage</legend>
                
                <textarea name="bodytext" cols="72" rows="25">
                    <xsl:value-of select="BODY"/>
                </textarea>
                
                <input type="submit" name="storepage" value="Update page" />
            </fieldset>
        </form>
    </xsl:template>
    
</xsl:stylesheet>