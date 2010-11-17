<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">
    
    <doc:documentation>
        <doc:purpose>
            Coverts YOUTUBEURL nodes to Embedded YouTube videos
        </doc:purpose>
        <doc:context>
            Applied by _common/_library/GuideML.xsl
        </doc:context>
        <doc:notes>
            
        </doc:notes>
    </doc:documentation>
	
	<xsl:attribute-set name="picturetable">
		<xsl:attribute name="class">border0</xsl:attribute>
		<xsl:attribute name="border">0</xsl:attribute>
		<xsl:attribute name="cellspacing">0</xsl:attribute>
		<xsl:attribute name="cellpadding">0</xsl:attribute>
	</xsl:attribute-set>

	<xsl:template match="YOUTUBEURL | youtubeurl" mode="library_GuideML">
		<table xsl:use-attribute-sets="picturetable">
			<xsl:attribute name="align">
				<xsl:value-of select="@EMBED"/>
			</xsl:attribute>
			<tr>
				<td rowspan="4" width="5"/>
				<td height="5"/>
				<td rowspan="4" width="5"/>
			</tr>
			<tr>
				<td>
					<xsl:call-template name="renderyoutube"/>
				</td>
			</tr>
			<tr>
				<td height="5"/>
			</tr>
		</table>
    </xsl:template>
	
	<xsl:template name="renderyoutube">
		<!-- embed the player -->
		<xsl:if test=". and . != ''">
			<div id="ytapiplayer">
				<p>
					In order to see this content you need to have both <a href="http://www.bbc.co.uk/webwise/askbruce/articles/browse/java_1.shtml" title="BBC Webwise article about enabling javascript">Javascript</a> enabled and <a href="http://www.bbc.co.uk/webwise/askbruce/articles/download/howdoidownloadflashplayer_1.shtml" title="BBC Webwise article about downloading">Flash</a> installed. Visit <a href="http://www.bbc.co.uk/webwise/" >BBC Webwise</a> for full instructions. If you're reading via RSS, you'll need to visit the blog to access this content.
				</p>
			</div>
			<script src="http://swfobject.googlecode.com/svn/tags/rc3/swfobject/src/swfobject.js" type="text/javascript"></script>
			<script type="text/javascript">
				<![CDATA[
            // allowScriptAccess must be set to allow the Javascript from one
            // domain to access the swf on the youtube domain
            var params = { allowScriptAccess: "always", bgcolor: "#cccccc" };
            // this sets the id of the object or embed tag to 'myytplayer'.
            // You then use this id to access the swf and make calls to the player's API
            var atts = { id: "myytplayer" };
            swfobject.embedSWF("]]><xsl:value-of select="."/><![CDATA[&amp;border=0&amp;enablejsapi=1&amp;playerapiid=ytplayer","ytapiplayer", "400", "300", "8", null, null, params, atts);
            ]]>
			</script>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>