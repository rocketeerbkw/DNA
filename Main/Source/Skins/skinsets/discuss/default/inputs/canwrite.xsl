<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">
    
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
    
    
    <xsl:template match="COMMENTFORUM/@CANWRITE[. = 1]" mode="input_canwrite_commentforum">
        <xsl:variable name="commentforumlist" select="ancestor::COMMENTFORUMLIST" />
        <xsl:variable name="commentforum" select="ancestor::COMMENTFORUM" />
        
        <form action="{$root}/commentforumlist" method="post" class="form-openclose">
            <p>
                <input type="hidden" name="dnauid" value="{$commentforum/@UID}"/>
                <input type="hidden" name="dnaaction" value="update" />
                
                <input type="hidden" name="dnasiteid" value="{$commentforum/SITEID}"/>
                <input type="hidden" name="dnahostpage" value="{$commentforum/HOSTPAGEURL}"/>
                <input type="hidden" name="dnaskip" value="{$commentforumlist/@SKIP}"/>
                <input type="hidden" name="dnashow" value="{$commentforumlist/@SHOW}"/>
                
                <input type="hidden" name="dnanewcanwrite" value="0" />
                
                <label for="canwrite-{$commentforum/@UID}">These comments are <strong>open</strong> for contribution</label>
                <input type="submit" id="canwrite-{$commentforum/@UID}" value="Close" />
            </p>
        </form>
    </xsl:template>
    
    
    <xsl:template match="COMMENTFORUM/@CANWRITE[. = 0]" mode="input_canwrite_commentforum">
        <xsl:variable name="commentforumlist" select="ancestor::COMMENTFORUMLIST" />
        <xsl:variable name="commentforum" select="ancestor::COMMENTFORUM" />
        
        <form action="{$root}/commentforumlist" method="post">
            <p>
                <input type="hidden" name="dnauid" value="{$commentforum/@UID}"/>
                <input type="hidden" name="dnaaction" value="update" />
                
                <input type="hidden" name="dnasiteid" value="{$commentforum/SITEID}"/>
                <input type="hidden" name="dnahostpage" value="{$commentforum/HOSTPAGEURL}"/>
                <input type="hidden" name="dnaskip" value="{$commentforumlist/@SKIP}"/>
                <input type="hidden" name="dnashow" value="{$commentforumlist/@SHOW}"/>
                
                <input type="hidden" name="dnanewcanwrite" value="1" />
                
                <label for="canwrite-{$commentforum/@UID}">These comments are <strong>closed</strong> for contribution</label>
                <input type="submit" id="canwrite-{$commentforum/@UID}" value="Open" />
            </p>
        </form>
    </xsl:template>
    
</xsl:stylesheet>