<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns="http://www.w3.org/1999/xhtml" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    version="1.0" 
    xmlns:doc="http://www.bbc.co.uk/dna/documentation"  
    exclude-result-prefixes="doc">
    
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
    

    <xsl:template match="ARTICLE-EDIT-FORM[H2G2ID = 0]" mode="input_article-edit-form">
        <form action="{$root}/Edit" method="post"> 
            <fieldset>
                <legend>Article</legend>
                
                <input type="hidden" value="1" name="format"/>
                
                <div id="article-subject">
                    <label for="subject">Subject</label>
                    <input type="text" value="" name="subject" id="subject"/>
                </div>
               
                <div id="article-body">
                    <textarea name="body" cols="72" rows="25">
                        <GUIDE>
                            <BODY>Enter your article here...</BODY>
                        </GUIDE>
                    </textarea>
                </div>
                
                <div id="article-submit">
                    <input type="hidden" value="submit" name="cmd"/>
                    <input type="submit" border="0" value="Add Article" name="addentry"/>
                </div>
       
            </fieldset>
        </form>
    </xsl:template>

    <xsl:template match="ARTICLE-EDIT-FORM" mode="input_article-edit-form">
        <form action="{$root}/Edit" method="post"> 
            <fieldset>
                <legend>Article</legend>
                
                <input type="hidden" value="{H2G2ID}" name="id"/>
                <input type="hidden" value="1" name="format"/>
                
                <input type="text" value="{SUBJECT}" name="subject"/>
                
                <textarea name="body" cols="72" rows="25">
                    <xsl:value-of select="CONTENT"/>
                </textarea>
                
                <input type="hidden" value="submit" name="cmd"/>
                
                <input type="submit" border="0" value="Update Guide Entry" name="update"/>
            </fieldset>
        </form>
        
        <form method="post" action="/dna/discuss/NamedArticles">
            <fieldset>
                <legend>Create a new named link to this article</legend>
                
                <input type="text" name="name" value=""/>
                <input type="hidden" name="h2g2id" value="{H2G2ID}"/>
                
                <input type="submit" name="setarticle" value="Set Article"/>
            </fieldset>
        </form>
            
    </xsl:template>
    
</xsl:stylesheet>