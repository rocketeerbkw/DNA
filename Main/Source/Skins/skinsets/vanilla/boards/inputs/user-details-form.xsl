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
         
    <xsl:template match="USER-DETAILS-FORM" mode="input_user-details-form">
        <form action="{$root}/UserDetails" method="post" class="dna-boards">
            <div>
                <xsl:call-template name="library_header_h3">
                    <xsl:with-param name="text">Change your nickname</xsl:with-param>
                </xsl:call-template>
                
                <p>
                    You can change how your name appears on the messageboard. 
                </p>
                <p>
                    <label for="dna-boards-nickname">Your nickname</label>
                    <input type="text" name="username" id="dna-boards-nickname" value="{/H2G2/VIEWING-USER/USER/USERNAME}" class="text"/>
                </p>
                
                <p>
                    <input type="hidden" value="submit" name="cmd"/>
                    <input type="hidden" value="0" name="PrefUserMode"/>
                    <input type="hidden" value="0" name="PrefSkin"/>
                    <input type="hidden" value="0" name="SiteSuffix"/>
                    <input type="hidden" value="0" name="PrefForumStyle"/>
                    <input type="hidden" value="{/H2G2/USER-DETAILS-FORM/EMAIL-ADDRESS}" name="OldEmail"/>
                    <input type="hidden" value="{/H2G2/USER-DETAILS-FORM/EMAIL-ADDRESS}" name="NewEmail"/>
                    <input type="hidden" value="" name="Password"/>
                    <input type="hidden" value="" name="NewPassword"/>
                    <input type="hidden" value="" name="PasswordConfirm"/>
                    <input type="submit" id="dna-boards-submit" value="Save changes" class="submit"/>
                </p>
                
                <xsl:apply-templates select="/H2G2/ERROR" mode="object_error" />
            </div>
        </form>
    </xsl:template>
 
    
</xsl:stylesheet>