<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<xsl:import href="../../../base/base-editcategorypage.xsl"/>
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
				Page - Level  template
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<xsl:template name="EDITCATEGORY_MAINBODY">
		<xsl:apply-templates select="EDITCATEGORY" mode="c_editcat"/>
	</xsl:template>
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
				EDITCATEGORY Object
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<!--
	<xsl:template match="EDITCATEGORY" mode="r_editcat">
	Use:Presenttaion of the object editcategory object 
	 -->
	<xsl:template match="EDITCATEGORY" mode="r_editcat">
	
	<!-- DEBUG -->
	<xsl:call-template name="TRACE">
	<xsl:with-param name="message">EDITCATEGORY<xsl:value-of select="$current_article_type" /></xsl:with-param>
	<xsl:with-param name="pagename">editcategory.xsl</xsl:with-param>
	</xsl:call-template>
	<!-- DEBUG -->


	<!-- <div class="generic-c"><xsl:value-of select="HIERARCHYDETAILS/DISPLAYNAME"/></div> -->
	<div class="generic-c"><xsl:apply-templates select="HIERARCHYDETAILS" mode="c_editcat"/></div>

	<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
	<td valign="top">
		<xsl:element name="{$text.base}" use-attribute-sets="text.base">
		<xsl:apply-templates select="HIERARCHYDETAILS/DESCRIPTION" mode="c_editcat"/>
		</xsl:element>
		<br />
	</td>
	</tr>
	<tr>
	<td valign="top">

		<xsl:apply-templates select="." mode="c_renamesubject"/>
			<xsl:apply-templates select="." mode="c_addsubject"/>
			<xsl:apply-templates select="." mode="c_storenode"/>
			<xsl:apply-templates select="." mode="c_storelink"/>
			<xsl:apply-templates select="ERROR" mode="c_editcat"/>
			
			<xsl:apply-templates select="EDITINPUT" mode="c_editcat"/>
			<xsl:apply-templates select="HIERARCHYDETAILS/SYNONYMS" mode="c_editcat"/>
			<xsl:apply-templates select="HIERARCHYDETAILS" mode="c_addarticlepermission"/>
			<xsl:apply-templates select="HIERARCHYDETAILS" mode="c_addarticle"/>
			<!-- <xsl:apply-templates select="HIERARCHYDETAILS" mode="c_addclub"/> -->
		
			
			<xsl:apply-templates select="HIERARCHYDETAILS/MEMBERS" mode="c_editcat"/>
			<xsl:apply-templates select="HIERARCHYDETAILS/TAGINFO" mode="c_tagnode"/>
			<xsl:apply-templates select="HIERARCHYDETAILS/TAGINFO" mode="c_returntotagitem"/>
	</td>
	</tr>
	</table>

	</xsl:template>
	<!--
	<xsl:template match="HIERARCHYDETAILS" mode="r_editcat">
	Use: Hierarchy details contains the crumbtrail as well as the display name of the node
	 -->
	<xsl:template match="HIERARCHYDETAILS" mode="r_editcat">
		<xsl:apply-templates select="ANCESTRY/ANCESTOR" mode="c_editcat"/>
		<xsl:value-of select="DISPLAYNAME"/>
	</xsl:template>
	<!--
	<xsl:template match="ANCESTOR" mode="r_editcat">
	Use: Presentation of a single node in a crumbtrail
	 -->
	<xsl:template match="ANCESTOR" mode="r_editcat">
		<xsl:apply-imports/> /
	</xsl:template>
	<!--
	<xsl:template match="DESCRIPTION" mode="r_editcat">
	Use: Presentation of a node's description
	 -->
	<xsl:template match="DESCRIPTION" mode="r_editcat">
	
	<div style="clear:both;"><xsl:apply-templates select="." mode="t_editcat"/></div>
		<xsl:apply-templates/>
		
	</xsl:template>
	<!--
	<xsl:template match="MEMBERS" mode="r_editcat">
	Use: Object holding all nodes within the current node
	 -->
	<xsl:template match="MEMBERS" mode="r_editcat">
	
		<xsl:apply-templates select="SUBJECTMEMBER" mode="c_editcat"/>
		<xsl:apply-templates select="ARTICLEMEMBER" mode="c_editcat"/>
		<xsl:apply-templates select="NODEALIASMEMBER" mode="c_editcat"/>
		<xsl:apply-templates select="CLUBMEMBER" mode="c_editcat"/>
	</xsl:template>
	<!--
	<xsl:template match="SUBJECTMEMBER" mode="r_editcat">
	Use: Presentation of an individual subject member node
	 -->
	<xsl:template match="SUBJECTMEMBER" mode="r_editcat">
	
	<div class="categorytitle"><xsl:apply-templates select="NAME" mode="t_nodename_ec"/></div>
	<!--  category box -->
	<div class="myspace-h">
	<xsl:element name="{$text.base}" use-attribute-sets="text.base">
		<xsl:apply-templates select="NODECOUNT" mode="c_subject_ec"/>
		<xsl:if test="SUBNODES"><br /></xsl:if>
		<xsl:apply-templates select="SUBNODES/SUBNODE" mode="c_subnodename_ec"/>
		<br/>
		<xsl:apply-templates select="." mode="c_movesubject"/>
		<xsl:apply-templates select="." mode="r_deletesubject"/>
		</xsl:element>
		</div>
	</xsl:template>
	
	<!--
	<xsl:template match="SUBNODE" mode="r_subnodename_ec">
	Use: Presenttaion of an individual Subject Member subnode
	 -->
	<xsl:template match="SUBNODE" mode="r_subnodename_ec">
		
			<xsl:apply-imports/>
			<xsl:text>, </xsl:text>
		
	</xsl:template>
	<!--
	<xsl:template match="NODECOUNT" mode="zero_subject_ec">
	Use: Used if a SUBJECTMEMBER has 0 nodes contained in it
	 -->
	<xsl:template match="NODECOUNT" mode="zero_subject_ec">
		[<xsl:value-of select="$m_nomembers"/>]
	</xsl:template>
	<!--
	<xsl:template match="NODECOUNT" mode="one_subject_ec">
	Use: Used if a SUBJECTMEMBER has 1 node contained in it
	 -->
	<xsl:template match="NODECOUNT" mode="one_subject_ec">
		[1<xsl:value-of select="$m_member"/>]
	</xsl:template>
	<!--
	<xsl:template match="NODECOUNT" mode="many_subject_ec">
	Use: Used if a SUBJECTMEMBER has more than 1 nodes contained in it
	 -->
	<xsl:template match="NODECOUNT" mode="many_subject_ec">
		[<xsl:apply-imports/>
		<xsl:value-of select="$m_members"/>]
	</xsl:template>
	
	<!--
	<xsl:template match="ARTICLEMEMBER" mode="r_editcat">
	Use: Presentation of a single article member node
	 -->
	<xsl:template match="ARTICLEMEMBER" mode="r_editcat">
		<xsl:apply-imports/>
		<br/>
		<xsl:apply-templates select="." mode="c_movearticle"/>
		<xsl:apply-templates select="." mode="c_deletearticle"/>
		<br/>
	</xsl:template>

	<!--
	<xsl:template match="CLUBMEMBER" mode="r_editcat">
	Use: Presentation of a single club member node
	 -->
	<xsl:template match="CLUBMEMBER" mode="r_editcat">
		<xsl:apply-templates select="NAME" mode="t_clubname_ec"/>
		<xsl:apply-templates select="EXTRAINFO/DESCRIPTION" mode="c_clubdescription_ec"/>
		<xsl:apply-templates select="." mode="c_moveclub"/>
		<xsl:apply-templates select="." mode="c_deleteclub"/>
		<br/>
		<br/>
	</xsl:template>

	<!--
	<xsl:template match="DESCRIPTION" mode="r_clubdesription_ec">
	Use: Presentation of the the description attached to a club
	 -->
	<xsl:template match="DESCRIPTION" mode="r_clubdesription_ec">
		<xsl:apply-templates/>
	</xsl:template>
	<!--
	<xsl:template match="NODEALIASMEMBER" mode="r_editcat">
	Use: Presentation of a single node alias node
	 -->
	<xsl:template match="NODEALIASMEMBER" mode="r_editcat">
		<xsl:apply-templates select="NAME" mode="t_nodealiasname_ec"/>
		<xsl:apply-templates select="NODECOUNT" mode="c_nodealias_ec"/>
		<br/>
		<xsl:apply-templates select="." mode="c_movesubjectlink"/>
		
		<xsl:apply-templates select="." mode="c_deletesubjectlink"/>
		<br/>
		<br/>
	</xsl:template>

	<!--
	<xsl:template match="NODEALIASMEMBER/NODECOUNT" mode="zero_nodealias_ec">
	Use: Used if a NODEALIASMEMBER has 0 nodes contained in it
	 -->
	<xsl:template match="NODEALIASMEMBER/NODECOUNT" mode="zero_nodealias_ec">
		[<xsl:value-of select="$m_nomembers"/>]
	</xsl:template>
	<!--
	<xsl:template match="NODEALIASMEMBER/NODECOUNT" mode="one_nodealias_ec">
	Use: Used if a NODEALIASMEMBER has 1 node contained in it
	 -->
	<xsl:template match="NODEALIASMEMBER/NODECOUNT" mode="one_nodealias_ec">
		[1<xsl:value-of select="$m_member"/>]
	</xsl:template>
	<!--
	<xsl:template match="NODEALIASMEMBER/NODECOUNT" mode="many_nodealias_ec">
	Use: Used if a NODEALIASMEMBER has more than 1 nodes contained in it
	 -->
	<xsl:template match="NODEALIASMEMBER/NODECOUNT" mode="many_nodealias_ec">
		[<xsl:apply-imports/>
		<xsl:value-of select="$m_members"/>]
	</xsl:template>
	<!--
	<xsl:template match="TAGINFO" mode="r_tagnode">
	Use: Presentation of the 'store this article / club / userpage here' link
	 -->
	<xsl:template match="TAGINFO" mode="r_tagnode">
		<xsl:apply-imports/>
		<br/>
	</xsl:template>
	<!--
	<xsl:template match="TAGINFO" mode="r_returntotagitem">
	Use: Presentation of the return to article / club / userpage link
	 -->
	<xsl:template match="TAGINFO" mode="r_returntotagitem">
		<xsl:apply-imports/>
		<br/>
	</xsl:template>
	<!-- *************************************************************************************************************** -->
	<!-- *********************************      EDITORIAL-TOOLS                *************************************** -->
	<!-- *************************************************************************************************************** -->
	
	<!--
	<xsl:template match="EDITCATEGORY" mode="r_renamesubject">
	Use: Presentation of the 'rename subject' link
	 -->
	<xsl:template match="EDITCATEGORY" mode="r_renamesubject">
		<xsl:apply-imports/>
		<xsl:text> - </xsl:text>
	</xsl:template>
	<!--
	<xsl:template match="EDITCATEGORY" mode="r_addsubject">
	Use: Presentation of the 'add subject' link
	 -->
	<xsl:template match="EDITCATEGORY" mode="r_addsubject">
		<xsl:apply-imports/>
		<br/>
		<hr/>
	</xsl:template>
	
	<!--
	<xsl:template match="EDITCATEGORY" mode="r_storelink">
	Use: Presentation of the 'store this link here' link
	 -->
	<xsl:template match="EDITCATEGORY" mode="r_storelink">
		<xsl:apply-imports/>
		<br/>
		<hr/>
	</xsl:template>
	<!--
	<xsl:template match="EDITINPUT" mode="rename_editcat">
	Use: Presentation of the 'Rename this subject' functionality
	 -->
	<xsl:template match="EDITINPUT" mode="rename_editcat">
		
			<b>Rename this subject</b>
		
		<br/>
		<xsl:copy-of select="$m_renamesubject"/>
		<xsl:apply-templates select="." mode="t_inputrename"/>
		<xsl:apply-templates select="." mode="t_submitrename"/>
		<hr/>
	</xsl:template>
	<!--
	<xsl:template match="EDITINPUT" mode="addsubject_editcat">
	Use: Presentation of the 'Enter the new subject name' functionality
	 -->
	<xsl:template match="EDITINPUT" mode="addsubject_editcat">
		
			<b>Enter the new subject name</b>
		
		<br/>
		<xsl:copy-of select="$m_enternewname"/>
		<xsl:apply-templates select="." mode="t_inputaddsubject"/>
		<br/>
		<xsl:apply-templates select="." mode="t_submitaddsubject"/>
		<hr/>
	</xsl:template>
	<!--
	<xsl:template match="EDITINPUT" mode="changedesc_editcat">
	Use: Presentation of the 'change description' functionality
	 -->
	<xsl:template match="EDITINPUT" mode="changedesc_editcat">
		
			<b>Change the subject's description</b>
		
		<br/>
		<xsl:copy-of select="$m_changedescription"/>
		<xsl:apply-templates select="." mode="t_inputchangedesc"/>
		<br/>
		<xsl:apply-templates select="." mode="t_submitchangedesc"/>
		<hr/>
	</xsl:template>
	
	<!--
	<xsl:template match="HIERARCHYDETAILS" mode="r_addclub">
	Use: Presentation of the 'Add a club to this subject' link
	 -->
	<xsl:template match="HIERARCHYDETAILS" mode="r_addclub">
		<xsl:copy-of select="$m_addclubtosubject"/>
		<xsl:apply-templates select="." mode="t_inputclub"/>
		<xsl:apply-templates select="." mode="t_submitclub"/>
		<br/>
		<hr/>
	</xsl:template>
	<!--
	<xsl:template match="HIERARCHYDETAILS" mode="r_addclub">
	Use: Presentation of the 'Store article here' link
	 -->
	<xsl:template match="EDITCATEGORY" mode="r_storenode">
		<xsl:apply-imports/>
		<br/>
		<hr/>
	</xsl:template>
	<!--
	<xsl:template match="ERROR" mode="r_editcat">
	Use: Presentation of an error message
	 -->
	<xsl:template match="ERROR" mode="r_editcat">
		<xsl:apply-imports/>
	</xsl:template>
	<!--
	<xsl:template match="HIERARCHYDETAILS" mode="no_addarticle">
	Use: Presentation of the 'allow user to submit content' submit button
	 -->
	<xsl:template match="HIERARCHYDETAILS" mode="no_addarticlepermission">
		<xsl:copy-of select="$m_userdenied"/>
		<xsl:apply-templates select="." mode="t_allowusersubmit"/>
		<br/>
		<hr/>
	</xsl:template>
	<!--
	<xsl:template match="HIERARCHYDETAILS" mode="yes_addarticle">
	Use: Presentation of the 'stop allowing user to submit content' submit button
	 -->
	<xsl:template match="HIERARCHYDETAILS" mode="yes_addarticlepermission">
		<xsl:copy-of select="$m_userenabled"/>
		<xsl:apply-templates select="." mode="t_disallowusersubmit"/>
		<br/>
		<hr/>
	</xsl:template>
	<!--
	<xsl:template match="SYNONYMS" mode="r_editcat">
	Use: Presentation of the 'input synonyms' functionality 
	 -->
	<xsl:template match="SYNONYMS" mode="r_editcat">
		
			<b>Synonyms</b>
		
		<br/>
		<xsl:copy-of select="$m_synonymstitle"/>
		<xsl:apply-templates select="." mode="t_inputsynonyms"/>
		<xsl:apply-templates select="." mode="t_submitsynonyms"/>
		<br/>
		<hr/>
	</xsl:template>
	<!--
	<xsl:template match="HIERARCHYDETAILS" mode="r_addarticle">
	Use: 'Add an article to this subject' functionality
	 -->
	<xsl:template match="HIERARCHYDETAILS" mode="r_addarticle">
		<b><xsl:copy-of select="$m_addarticletosubject"/></b>
		<xsl:apply-templates select="." mode="t_addarticlednaid"/>
		<xsl:apply-templates select="." mode="t_addarticlesubmit"/><br /><br />
	</xsl:template>
		<!--
	<xsl:template match="ARTICLEMEMBER" mode="r_movearticle">
	Use: Presentation of the 'move article' link
	 -->
	<xsl:template match="ARTICLEMEMBER" mode="r_movearticle">
		<xsl:apply-imports/>
	</xsl:template>
	<!--
	<xsl:template match="ARTICLEMEMBER" mode="r_deletearticle">
	Use: Presentation of the 'delete article' link
	 -->
	<xsl:template match="ARTICLEMEMBER" mode="r_deletearticle">
		<xsl:apply-imports/>
		<br/>
	</xsl:template>
	<!--
	<xsl:template match="SUBJECTMEMBER" mode="r_movesubject">
	Use: Presentation of the 'move subject' link
	 -->
	<xsl:template match="SUBJECTMEMBER" mode="r_movesubject">
		<xsl:apply-imports/>
		<xsl:copy-of select="$m_editcatdots"/>
	</xsl:template>
	<!--
	<xsl:template match="SUBJECTMEMBER" mode="r_deletesubject">
	Use: Presentation of the 'delete subject' link
	 -->
	<xsl:template match="SUBJECTMEMBER" mode="r_deletesubject">
		<xsl:apply-imports/>
	</xsl:template>
	<!--
	<xsl:template match="SUBJECTMEMBER" mode="r_deletesubject">
	Use: Presentation of the 'move club' link
	 -->
	<xsl:template match="CLUBMEMBER" mode="r_moveclub">
		<xsl:apply-imports/>
		<xsl:text>........</xsl:text>
	</xsl:template>
	<!--
	<xsl:template match="SUBJECTMEMBER" mode="r_deletesubject">
	Use: Presentation of the 'delete club' link
	 -->
	<xsl:template match="CLUBMEMBER" mode="r_deleteclub">
		<xsl:apply-imports/>
	</xsl:template>
	<!--
	<xsl:template match="NODEALIASMEMBER" mode="r_movesubjectlink">
	Use: Presentation of the 'delete nodealias' link
	 -->
	<xsl:template match="NODEALIASMEMBER" mode="r_movesubjectlink">
		<xsl:apply-imports/>
		<xsl:text>........</xsl:text>
	</xsl:template>
	<!--
	<xsl:template match="NODEALIASMEMBER" mode="r_deletesubjectlink">
	Use: Presentation of the 'delete nodealias' link
	 -->
	<xsl:template match="NODEALIASMEMBER" mode="r_deletesubjectlink">
		<xsl:apply-imports/>
	</xsl:template>
	
	<!--
	<xsl:attribute-set name="fEDITINPUT_c_editcat"/>
	Use: Extra Presentation attributes for rename subject / add subject / change description 
	form element
	 -->
	<xsl:attribute-set name="fEDITINPUT_c_editcat"/>
	<!--
	<xsl:attribute-set name="iEDITINPUT_t_inputrename"/>
	Use: Extra Presentation attributes for rename subject input field
	 -->
	<xsl:attribute-set name="iEDITINPUT_t_inputrename"/>
	<!--
	<xsl:attribute-set name="iEDITINPUT_t_submitrename"/>
	Use: Extra Presentation attributes for rename subject submit button
	 -->
	<xsl:attribute-set name="iEDITINPUT_t_submitrename"/>
	<!--
	<xsl:attribute-set name="iEDITINPUT_t_inputaddsubject"/>
	Use: Use: Extra Presentation attributes for add subject input field
	 -->
	<xsl:attribute-set name="iEDITINPUT_t_inputaddsubject"/>
	<!--
	<xsl:attribute-set name="iEDITINPUT_t_submitaddsubject"/>
	Use: Extra Presentation attributes for add subject submit button
	 -->
	<xsl:attribute-set name="iEDITINPUT_t_submitaddsubject"/>
	<!--
	<xsl:attribute-set name="iEDITINPUT_t_inputchangedesc"/>
	Use: Use: Extra Presentation attributes for change description input field
	 -->
	
		<xsl:attribute-set name="iEDITINPUT_t_inputchangedesc">
		<xsl:attribute name="cols">50</xsl:attribute>
		<xsl:attribute name="wrap">virtual</xsl:attribute>
		<xsl:attribute name="rows">8</xsl:attribute>
	</xsl:attribute-set>
	<!--
	<xsl:attribute-set name="iEDITINPUT_t_submitchangedesc"/>
	Use: Extra Presentation attributes for change description submit button
	 -->
	<xsl:attribute-set name="iEDITINPUT_t_submitchangedesc"/>
	<!--
	<xsl:attribute-set name="fHIERARCHYDETAILS_c_addarticle"/>
	Use: Extra Presentation attributes for add article form element
	 -->
	<xsl:attribute-set name="fHIERARCHYDETAILS_c_addarticle"/>
	<!--
	<xsl:attribute-set name="iHIERARCHYDETAILS_t_addarticlednaid"/>
	Use: Extra Presentation attributes for add article input box
	 -->
	<xsl:attribute-set name="iHIERARCHYDETAILS_t_addarticlednaid"/>
	<!--
	<xsl:attribute-set name="iHIERARCHYDETAILS_t_addarticlesubmit"/>
	Use: Extra Presentation attributes for add article submit button
	 -->
	<xsl:attribute-set name="iHIERARCHYDETAILS_t_addarticlesubmit"/>
	<!--
	<xsl:attribute-set name="fSYNONYMS_c_editcat"/>
	Use: Extra Presentation attributes for synonyms form element
	 -->
	<xsl:attribute-set name="fSYNONYMS_c_editcat"/>
	<!--
	<xsl:attribute-set name="iSYNONYMS_t_inputsynonyms"/>
	Use: Extra Presentation attributes for synonyms input box
	 -->
	<xsl:attribute-set name="iSYNONYMS_t_inputsynonyms"/>
	<!--
	<xsl:attribute-set name="iSYNONYMS_t_submitsynonyms"/>
	Use: Extra Presentation attributes for synonyms submit button
	 -->
	<xsl:attribute-set name="iSYNONYMS_t_submitsynonyms"/>
	<!--
	<xsl:attribute-set name="iHIERARCHYDETAILS_t_allowusersubmit"/>
	Use: Extra Presentation attributes for the 'allow user to submit content' submit button
	 -->
	<xsl:attribute-set name="iHIERARCHYDETAILS_t_allowusersubmit"/>
	<!--
	<xsl:attribute-set name="iHIERARCHYDETAILS_t_disallowusersubmit"/>
	Use: Extra Presentation attributes for the 'stop allowing user to submit content' submit button
	 -->
	<xsl:attribute-set name="iHIERARCHYDETAILS_t_disallowusersubmit"/>
	<!--
	<xsl:attribute-set name="fHIERARCHYDETAILS_c_addclub"/>
	Use: Extra Presentation attributes for add club form element
	 -->
	<xsl:attribute-set name="fHIERARCHYDETAILS_c_addclub"/>
	<!--
	<xsl:attribute-set name="iHIERARCHYDETAILS_t_inputclub"/>
	Use: Use: Extra Presentation attributes for add club input box
	 -->
	<xsl:attribute-set name="iHIERARCHYDETAILS_t_inputclub"/>
	<!--
	<xsl:attribute-set name="iHIERARCHYDETAILS_t_submitclub"/>
	Use: Use: Extra Presentation attributes for add club submit button
	 -->
	<xsl:attribute-set name="iHIERARCHYDETAILS_t_submitclub"/>
</xsl:stylesheet>
