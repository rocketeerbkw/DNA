<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<xsl:import href="../../../base/base-tagitempage.xsl"/>
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
									Page - Level  template
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<xsl:template name="TAGITEM_MAINBODY">
	
	<!-- DEBUG -->
	<xsl:call-template name="TRACE">
	<xsl:with-param name="message">TAGITEM_MAINBODY test variable = <xsl:value-of select="$current_article_type" /></xsl:with-param>
	<xsl:with-param name="pagename">tagitempage.xsl</xsl:with-param>
	</xsl:call-template>
	<!-- DEBUG -->
	
	<div class="steps">
	<b>Step 4: success!</b>
	
	<!-- your review will be found in -->
	<div><xsl:apply-templates select="TAGITEM-PAGE/ACTION" mode="c_actionresult"/></div>
	
	<div class="backtolink">
	<a href="">&gt; </a> <xsl:apply-templates select="TAGITEM-PAGE/ITEM" mode="t_backtoobject"/>
	</div>
	
	<!-- error messages -->		
	<div><xsl:apply-templates select="TAGITEM-PAGE/ERROR" mode="c_tagitem"/></div>
	
	
</div>
	</xsl:template>
<!--
	<xsl:template match="TAGITEM-PAGE" mode="r_addtonode">
	Use: Presentation of the 'add to the taxonomy' link
	 -->
	<xsl:template name="ok_addtonode">
		<xsl:param name="addnodelink"/>
		<xsl:param name="nodetype"/>
		<xsl:copy-of select="$addnodelink"/>
		<br/>
	</xsl:template>
		<!--
	<xsl:template match="TAGITEM-PAGE" mode="signedout_addtonode">
	Use: Invoked instead of 'attach' if not signed in 
	 -->
	<xsl:template name="signedout_addtonode">
		<xsl:param name="nodetype"/>
	
		<br/>
	</xsl:template>
		<!--
	<xsl:template match="TAGITEM-PAGE" mode="full_addtonode">
	Use: Invoked if the article cannot be added to any more nodes
	 -->
	<xsl:template name="full_addtonode">
		<xsl:param name="nodetype"/>
		You cannot attach this article to any more nodes
		<br/>
	</xsl:template>
	<!--
	<xsl:template match="TAGGEDNODES" mode="full_tagitem">
	Use: Template invoked if there are one or more existing taggings
	 -->
	<xsl:template match="TAGGEDNODES" mode="full_tagitem">
		or <br/>
		
		<xsl:apply-templates select="NODE" mode="c_tagitem"/>
		
	</xsl:template>
	<!--
	<xsl:template match="TAGGEDNODES" mode="empty_tagitem">
	Use: Template invoked if there are no existing tagging
	 -->
	<xsl:template match="TAGGEDNODES" mode="empty_tagitem">
<!-- 		<xsl:apply-imports/>
		<br/>
		<br/> -->
	</xsl:template>
	<!--
	<xsl:template match="NODE" mode="r_tagitem">
	Use: Presentation of an individual node in the list of tags
	 -->
	<xsl:template match="NODE" mode="r_tagitem">
<!-- <xsl:apply-templates select="ANCESTRY" mode="c_tagitem"/>
		
	<xsl:apply-templates select="." mode="t_taggednodename"/> -->
		
	<xsl:apply-templates select="." mode="t_removetag"/>
			
	<!-- <xsl:apply-templates select="." mode="t_movetag"/> -->
	
	</xsl:template>
	<!--
	<xsl:template match="TAGITEM-PAGE" mode="r_addtonode">
	Use: Presentation of the 'add to the taxonomy' link
	 -->
	<xsl:template match="TAGITEM-PAGE" mode="r_addtonode">
		<xsl:apply-imports/>
		<br/>
	</xsl:template>
	<!--
	<xsl:template match="ANCESTRY" mode="r_tagitem">
	Use: Presentation of each NODE's crumbtrail
	 -->
	<xsl:template match="ANCESTRY" mode="r_tagitem">
		<xsl:apply-templates select="ANCESTOR" mode="c_tagitem"/>
	</xsl:template>
	<!--
	<xsl:template match="ANCESTOR" mode="r_tagitem">
	Use: Presentation of each crumbtrail's node in the taxonomy
	 -->
	<xsl:template match="ANCESTOR" mode="r_tagitem">
		<xsl:apply-imports/>
		<xsl:text> / </xsl:text>
	</xsl:template>
	<!--
	<xsl:template match="ERROR" mode="r_tagitem">
	Use: Presentation of the error message
	 -->
	<xsl:template match="ERROR" mode="r_tagitem">
		<xsl:apply-imports/>
	</xsl:template>
	
	
	<!--
	<xsl:template match="ACTION" mode="added_actionresult">
	Use: 
	 -->
	<xsl:template match="ACTION" mode="added_actionresult">
	 you review will be found in :<br />
	<div><xsl:apply-templates select="/H2G2/TAGITEM-PAGE/TAGGEDNODES/NODE/ANCESTRY/ANCESTOR" mode="r_tagitem"/><xsl:apply-templates select="." mode="t_activenode"/></div>
	
		<br/>
	</xsl:template>

	<xsl:template match="ACTION" mode="notadded_actionresult">
		<xsl:apply-templates select="." mode="t_activeobject"/>
		<xsl:text> could not be added to </xsl:text>
		<xsl:apply-templates select="." mode="t_activenode"/>
	</xsl:template>
	<xsl:template match="ACTION" mode="removed_actionresult">
		<xsl:text>your review has successfully been removed from: </xsl:text>
		<div><xsl:apply-templates select="/H2G2/TAGITEM-PAGE/TAGGEDNODES/NODE/ANCESTRY/ANCESTOR" mode="r_tagitem"/><xsl:apply-templates select="." mode="t_activenode"/></div>
	</xsl:template>
	<xsl:template match="ACTION" mode="notremoved_actionresult">
		<xsl:apply-templates select="." mode="t_activeobject"/>
		<xsl:text> could not be removed from </xsl:text>
		<xsl:apply-templates select="." mode="t_activenode"/>
	</xsl:template>
	<xsl:template match="ACTION" mode="moved_actionresult">
		<xsl:apply-templates select="." mode="t_activeobject"/>
		<xsl:text> has successfully been moved from </xsl:text>
		<xsl:apply-templates select="." mode="t_nodefrom"/>
		<xsl:text> to </xsl:text>
		<xsl:apply-templates select="." mode="t_nodeto"/>
	</xsl:template>
	
	<xsl:template match="ACTION" mode="notmoved_actionresult">
	
	</xsl:template>
</xsl:stylesheet>
