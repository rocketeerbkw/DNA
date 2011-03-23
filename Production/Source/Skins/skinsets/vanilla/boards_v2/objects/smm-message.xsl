<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">
    
    <doc:documentation for="/sites/MySite/objects/post/generic.xsl">
        <doc:purpose>
            Holds the generic HTML construction of a comment
        </doc:purpose>
        <doc:context>
            Called by object-post (_common/_logic/_objects/post.xsl)
        </doc:context>
        <doc:notes>
            GuideML is the xml format (similiar to HTML) that user entered content is
            stored in. 
        </doc:notes>
    </doc:documentation>
    
    <xsl:template match="MESSAGE" mode="object_smm-message">
    	
    	<li id="message{@MSGID}">    	
    		<xsl:call-template name="library_listitem_stripe"/>
    		
    		<h5>Message received <xsl:apply-templates select="DATEPOSTED/DATE/@RELATIVE" mode="library_string_stringtolower"/></h5>
    		
    		<!-- change carriage returns in message to <br /> -->
	    	<xsl:call-template name="cr-to-br">
				<xsl:with-param name="text" select="BODY"/>
			</xsl:call-template>
			
			<br />
			<a href="smm?cmd=delete&#38;msgid={@MSGID}" class="delete">Delete message</a>
    	</li>
    	
    </xsl:template>

</xsl:stylesheet>
