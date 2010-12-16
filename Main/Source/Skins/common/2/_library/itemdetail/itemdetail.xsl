<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">
    
    <doc:documentation>
        <doc:properties common="true" />
        <doc:purpose>
            Library function for user and date information
        </doc:purpose>
        <doc:context>
            Called using:
            xsl:apply-templates select="POST" mode="library_itemdetail"
        </doc:context>
        <doc:notes>
            Currently matches POST, ARTICLEINFO
        </doc:notes>
    </doc:documentation>
    
    <xsl:template match="ARTICLEINFO" mode="library_itemdetail" >
        
        <div class="itemdetail">
            <xsl:apply-templates select="USER | PAGEAUTHOR/EDITOR/USER" mode="library_itemdetail"/>
            <xsl:apply-templates select="DATEPOSTED | LASTUPDATED | DATECREATED | LASTUPDATED" mode="library_itemdetail"/>
            <xsl:apply-templates select="@INDEX" mode="library_itemdetail"/>
        </div>
        
    </xsl:template>
	
	<xsl:template match="POST" mode="library_itemdetail" >
		<div class="itemdetail">
	    	<xsl:if test="not(parent::ARTICLEINFO)">
		    	<xsl:variable name="messagenumber" select="number(parent::FORUMTHREADPOSTS/@SKIPTO) + count(./preceding-sibling::POST)"></xsl:variable>
		    	<h4>
			    	<xsl:if test="$messagenumber + 1 = parent::FORUMTHREADPOSTS/@TOTALPOSTCOUNT">
			    		<xsl:attribute name="id">lastpost</xsl:attribute>
			    	</xsl:if>
		    		<xsl:value-of select="concat('Message ', $messagenumber + 1)"/><xsl:if test="@INDEX='0'">.&#160;</xsl:if>
		    	</h4>
		    	<p class="messagedetail">
			        <xsl:apply-templates select="@INREPLYTO" mode="library_itemdetail_replytomessage"/>
			    </p>
	    	</xsl:if>			
			
			<p class="postedby">	
				<xsl:apply-templates select="USER | PAGEAUTHOR/EDITOR/USER" mode="library_itemdetail"/>
				<xsl:apply-templates select="DATEPOSTED | DATECREATED" mode="library_itemdetail"/>
			</p>
		</div>
		
	</xsl:template>
    
</xsl:stylesheet>