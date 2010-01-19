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
    
    
    <xsl:template match="MODSTATUS[ancestor::COMMENTFORUM]" mode="input_modstatus_commentforum">
        <xsl:variable name="commentforumlist" select="ancestor::COMMENTFORUMLIST" />
        <xsl:variable name="commentforum" select="ancestor::COMMENTFORUM" />
        
        <form action="{$root}/commentforumlist" method="post" class="form-modstatus">
            <p>
                <input type="hidden" name="dnauid" value="{$commentforum/@UID}"/>
                <input type="hidden" name="dnaaction" value="update" />
                
                <input type="hidden" name="dnasiteid" value="{$commentforum/SITEID}"/>
                <input type="hidden" name="dnahostpage" value="{$commentforum/HOSTPAGEURL}"/>
                <input type="hidden" name="dnaskip" value="{$commentforumlist/@SKIP}"/>
                <input type="hidden" name="dnashow" value="{$commentforumlist/@SHOW}"/>
                
                <input id="modstatus-reactive-{$commentforum/@UID}" type="radio" name="dnanewmodstatus" value="reactive" class="radio"/>
                <label for="modstatus-reactive-{$commentforum/@UID}">Reactive</label>
                
                <input id="modstatus-postmod-{$commentforum/@UID}" type="radio" name="dnanewmodstatus" value="postmod" class="radio"/>
                <label for="modstatus-postmod-{$commentforum/@UID}">Post Moderated</label>
                
                <input id="modstatus-premod-{$commentforum/@UID}" type="radio" name="dnanewmodstatus" value="premod" class="radio"/>
                <label for="modstatus-premod-{$commentforum/@UID}">Pre Moderated</label>
                
                <input type="submit" value="Update" />
            </p>
        </form>
    </xsl:template>
        
</xsl:stylesheet>