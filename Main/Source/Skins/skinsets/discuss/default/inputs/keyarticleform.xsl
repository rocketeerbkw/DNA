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
    

    <xsl:template match="KEYARTICLEFORM" mode="input_keyarticleform">
        <form action="{$root}/NamedArticles" method="post"> 
            <fieldset>
                <legend>Create a new named article link</legend>
                
                <p>
                    Article Name <input type="text" value="" name="name"/>
                </p>
                    Article Id<input type="text" value="" name="h2g2id"/>
                    Allow articles from another site <input type="checkbox" value="1" name="allowothersites"/>
                <p>
                    Date active <input type="text" value="" name="date"/><font size="1">(leave blank to start immediately)</font><br/>
                </p>
                <p>
                    <input type="submit" value="Set Article" name="setarticle"/>
                </p>
            </fieldset>
        </form>
        
    </xsl:template>
    
</xsl:stylesheet>