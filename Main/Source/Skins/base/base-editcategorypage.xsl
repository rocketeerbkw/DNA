<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<xsl:variable name="userTagging" select="/H2G2/EDITCATEGORY/HIERARCHYDETAILS/TAGINFO"/>
		<xsl:variable name="m_returntotagarticlepage">Return to tagging page</xsl:variable>
	<xsl:variable name="m_returntotagclubpage">Return to tagging page</xsl:variable>
	<xsl:variable name="m_returntotaguserpage">Return to tagging page</xsl:variable>
	<xsl:attribute-set name="mTAGINFO_r_returntotagitem" use-attribute-sets="clubpagelinks"/>
	<!--
	* * * * * * * ATTRIBUTE SETS * * * * * * * 
	Author:		Tom Whitehouse
	Context:       -
	Purpose:	Attribute-sets for the form elements
	-->
	<xsl:attribute-set name="fEDITINPUT_c_editcat"/>
	<xsl:attribute-set name="iEDITINPUT_t_inputrename">
		<xsl:attribute name="value"><xsl:value-of select="/H2G2/EDITCATEGORY/HIERARCHYDETAILS/DISPLAYNAME"/></xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="iEDITINPUT_t_submitrename">
		<xsl:attribute name="value">Rename</xsl:attribute>
		<xsl:attribute name="type">submit</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="iEDITINPUT_t_inputaddsubject"/>
	<xsl:attribute-set name="iEDITINPUT_t_submitaddsubject">
		<xsl:attribute name="value">Add</xsl:attribute>
		<xsl:attribute name="type">submit</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="iEDITINPUT_t_inputchangedesc">
		<xsl:attribute name="cols">50</xsl:attribute>
		<xsl:attribute name="wrap">virtual</xsl:attribute>
		<xsl:attribute name="rows">3</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="iEDITINPUT_t_submitchangedesc">
		<xsl:attribute name="value">Update</xsl:attribute>
		<xsl:attribute name="type">submit</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="fHIERARCHYDETAILS_c_addarticle"/>
	<xsl:attribute-set name="iHIERARCHYDETAILS_t_addarticlednaid"/>
	<xsl:attribute-set name="iHIERARCHYDETAILS_t_addarticlesubmit">
		<xsl:attribute name="type">submit</xsl:attribute>
		<xsl:attribute name="value">Store Article</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="fSYNONYMS_c_editcat"/>
	<xsl:attribute-set name="iSYNONYMS_t_inputsynonyms">
		<xsl:attribute name="value"><xsl:value-of select="/H2G2/EDITCATEGORY/HIERARCHYDETAILS/SYNONYMS"/></xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="iSYNONYMS_t_submitsynonyms">
		<xsl:attribute name="type">submit</xsl:attribute>
		<xsl:attribute name="value">Update Synonyms</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="fHIERARCHYDETAILS_c_addarticle"/>
	<xsl:attribute-set name="iHIERARCHYDETAILS_t_allowusersubmit">
		<xsl:attribute name="value">Allow User</xsl:attribute>
		<xsl:attribute name="type">submit</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="iHIERARCHYDETAILS_t_disallowusersubmit">
		<xsl:attribute name="value">Disallow User</xsl:attribute>
		<xsl:attribute name="type">submit</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="fHIERARCHYDETAILS_c_addclub"/>
	<xsl:attribute-set name="iHIERARCHYDETAILS_t_inputclub"/>
	<xsl:attribute-set name="iHIERARCHYDETAILS_t_submitclub">
		<xsl:attribute name="type">submit</xsl:attribute>
		<xsl:attribute name="value">Store Club</xsl:attribute>
	</xsl:attribute-set>
	<!--
	<xsl:template name="EDITCATEGORY_HEADER">
	Author:		Tom Whitehouse
	Context:       /H2G2
	Purpose:      Creates the title for the page which sits in the html header
	-->
	<xsl:template name="EDITCATEGORY_HEADER">
		<xsl:apply-templates mode="header" select=".">
			<xsl:with-param name="title">
				<xsl:value-of select="$m_pagetitlestart"/>
				<xsl:value-of select="$m_editcategorisationheader"/>
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>
	<!--
	<xsl:template name="EDITCATEGORY_SUBJECT">
	Author:		Tom Whitehouse
	Context:       /H2G2
	Purpose:      Creates the text for the subject
	-->
	<xsl:template name="EDITCATEGORY_SUBJECT">
		<xsl:call-template name="SUBJECTHEADER">
			<xsl:with-param name="text">
				<xsl:value-of select="$m_editcategorisationsubject"/>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<!--
	<xsl:template match="EDITCATEGORY" mode="c_editcat">
	Author:		Tom Whitehouse
	Context:       /H2G2
	Purpose:      Creates the edit category container
	-->
	<xsl:template match="EDITCATEGORY" mode="c_editcat">
		<xsl:apply-templates select="." mode="r_editcat"/>
	</xsl:template>
	<!--
	<xsl:template match="EDITCATEGORY" mode="r_renamesubject">
	Author:		Tom Whitehouse
	Context:       /H2G2
	Purpose:      Creates the link to rename a category subject
	-->
	<xsl:template match="EDITCATEGORY" mode="r_renamesubject">
		<a href="{$root}editcategory?action=renamesubject&amp;nodeid={HIERARCHYDETAILS/@NODEID}" xsl:use-attribute-sets="mEDITCATEGORY_r_renamesubject">
			<xsl:copy-of select="$m_EditCatRenameSubjectButton"/>
		</a>
	</xsl:template>
	<xsl:template match="EDITCATEGORY" mode="c_renamesubject">
		<xsl:if test="not($userTagging)">
			<xsl:apply-templates select="." mode="r_renamesubject"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="DESCRIPTION" mode="c_editcat">
	Author:		Tom Whitehouse
	Context:       /H2G2
	Purpose:      Creates the container for the description
	-->
	<xsl:template match="DESCRIPTION" mode="c_editcat">
		<xsl:if test="not($userTagging)">
			<xsl:apply-templates select="." mode="r_editcat"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="DESCRIPTION" mode="t_editcat">
	Author:		Tom Whitehouse
	Context:       /H2G2
	Purpose:      Creates the link to rename a category description
	-->
	<xsl:template match="DESCRIPTION" mode="t_editcat">
		<a href="{$root}editcategory?action=renamedesc&amp;nodeid={../@NODEID}" xsl:use-attribute-sets="mDESCRIPTION_t_editcat">
			<xsl:copy-of select="$m_EditCatRenameDesc"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="HIERARCHYDETAILS" mode="c_editcat">
	Author:		Tom Whitehouse
	Context:       /H2G2/EDITCATEGORY
	Purpose:      Creates the container for the hierarchy details section (ancestry and display name)
	-->
	<xsl:template match="HIERARCHYDETAILS" mode="c_editcat">
		<xsl:apply-templates select="." mode="r_editcat"/>
	</xsl:template>
	<!--
	<xsl:template match="ANCESTOR" mode="c_editcat">
	Author:		Tom Whitehouse
	Context:       /H2G2/EDITCATEGORY/HIERARCHYDETAILS/ANCESTRY
	Purpose:      Creates the container for a single ancestor in the node's crumbtrail
	-->
	<xsl:template match="ANCESTOR" mode="c_editcat">
		<xsl:apply-templates select="." mode="r_editcat"/>
	</xsl:template>
	<!--
	<xsl:template match="ANCESTOR" mode="r_editcat">
	Author:		Tom Whitehouse
	Context:       /H2G2/EDITCATEGORY/HIERARCHYDETAILS/ANCESTRY
	Purpose:      Creates the link to a category node from a node in the crumbtrail
	-->
	<xsl:template match="ANCESTOR" mode="r_editcat">
		<xsl:variable name="activenode">
			<xsl:if test="/H2G2/EDITCATEGORY/ACTIVENODE/@ACTIVEID">&amp;activenode=<xsl:value-of select="/H2G2/EDITCATEGORY/ACTIVENODE/@ACTIVEID"/>
			</xsl:if>
			<xsl:if test="/H2G2/EDITCATEGORY/ACTIVENODE/@DELNODE">&amp;delnode=<xsl:value-of select="/H2G2/EDITCATEGORY/ACTIVENODE/@DELNODE"/>
			</xsl:if>
		</xsl:variable>
		<xsl:variable name="action">
			<xsl:choose>
				<xsl:when test="/H2G2/EDITCATEGORY/ACTIVENODE/@TYPE">&amp;action=navigate<xsl:value-of select="/H2G2/EDITCATEGORY/ACTIVENODE/@TYPE"/>
				</xsl:when>
				<xsl:otherwise>&amp;action=navigatesubject</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="tagmode">
			<xsl:if test="$userTagging">&amp;tagmode=<xsl:value-of select="/H2G2/EDITCATEGORY/HIERARCHYDETAILS/TAGINFO/@MODE"/>
			</xsl:if>
		</xsl:variable>
		<a href="{$root}editcategory?nodeid={NODEID}{$activenode}{$action}{$tagmode}" xsl:use-attribute-sets="mANCESTOR_r_editcat">
			<xsl:value-of select="NAME"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="EDITCATEGORY" mode="r_addsubject">
	Author:		Tom Whitehouse
	Context:       /H2G2
	Purpose:      Creates the link to add a new subject to a category page
	-->
	<xsl:template match="EDITCATEGORY" mode="r_addsubject">
		<a href="{$root}editcategory?action=addsubject&amp;nodeid={HIERARCHYDETAILS/@NODEID}" xsl:use-attribute-sets="mEDITCATEGORY_t_addsubject">
			<xsl:copy-of select="$m_EditCatAddSubjectButton"/>
		</a>
	</xsl:template>
	<xsl:template match="EDITCATEGORY" mode="c_addsubject">
		<xsl:if test="not($userTagging)">
			<xsl:apply-templates select="." mode="r_addsubject"/>
		</xsl:if>
	</xsl:template>
	<xsl:template match="EDITCATEGORY" mode="c_storenode">
		<xsl:if test="ACTIVENODE and not($userTagging)">
			<xsl:apply-templates select="." mode="r_storenode"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="EDITCATEGORY" mode="t_storenode">
	Author:		Tom Whitehouse
	Context:       /H2G2
	Purpose:      Creates the link to store the active node
	-->
	<xsl:template match="EDITCATEGORY" mode="r_storenode">
		<xsl:choose>
			<xsl:when test="ACTIVENODE/@TYPE='article'">
				<a href="{$root}editcategory?action=storearticle&amp;nodeid={HIERARCHYDETAILS/@NODEID}&amp;activenode={ACTIVENODE/@ACTIVEID}&amp;delnode={ACTIVENODE/@DELNODE}" onclick="return window.confirm('You are about to store the article here');" xsl:use-attribute-sets="mEDITCATEGORY_r_storenode">
					<xsl:copy-of select="$m_storearticlehere"/>
				</a>
			</xsl:when>
			<xsl:when test="ACTIVENODE/@TYPE='club'">
				<a href="{$root}editcategory?action=storeclub&amp;nodeid={HIERARCHYDETAILS/@NODEID}&amp;activenode={ACTIVENODE/@ACTIVEID}&amp;delnode={ACTIVENODE/@DELNODE}" onclick="return window.confirm('You are about to store the club here');" xsl:use-attribute-sets="mEDITCATEGORY_r_storenode">
					<xsl:copy-of select="$m_storeclubhere"/>
				</a>
			</xsl:when>
			<xsl:when test="ACTIVENODE/@TYPE='alias'">
				<a href="{$root}editcategory?action=storealias&amp;nodeid={HIERARCHYDETAILS/@NODEID}&amp;activenode={ACTIVENODE/@ACTIVEID}&amp;delnode={ACTIVENODE/@DELNODE}" onclick="return window.confirm('You are about to store the link here');" xsl:use-attribute-sets="mEDITCATEGORY_r_storenode">
					<xsl:copy-of select="$m_movelinkhere"/>
				</a>
			</xsl:when>
			<xsl:when test="ACTIVENODE/@TYPE='subject'">
				<a href="{$root}editcategory?action=storesubject&amp;nodeid={HIERARCHYDETAILS/@NODEID}&amp;activenode={ACTIVENODE/@ACTIVEID}" onclick="return window.confirm('You are about to store the subject here');" xsl:use-attribute-sets="mEDITCATEGORY_r_storenode">
					<xsl:copy-of select="$m_storesubjecthere"/>
				</a>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="EDITCATEGORY" mode="r_storelink">
	Author:		Tom Whitehouse
	Context:       /H2G2
	Purpose:      Creates the link to store the active link here 
	-->
	<xsl:template match="EDITCATEGORY" mode="r_storelink">
		<a href="{$root}editcategory?action=doaddalias&amp;nodeid={HIERARCHYDETAILS/@NODEID}&amp;activenode={ACTIVENODE/@ACTIVEID}" onclick="return window.confirm('You are about to store the link here');" xsl:use-attribute-sets="mEDITCATEGORY_r_storelink">
			<xsl:copy-of select="$m_storelinkhere"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="EDITCATEGORY" mode="c_storelink">
	Author:		Tom Whitehouse
	Context:       /H2G2
	Purpose:      Creates the container for storing the active link
	-->
	<xsl:template match="EDITCATEGORY" mode="c_storelink">
		<xsl:if test="ACTIVENODE/@TYPE='subject' and not($userTagging)">
			<xsl:apply-templates select="." mode="r_storelink"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="ERROR" mode="c_editcat">
	Author:		Tom Whitehouse
	Context:       /H2G2/EDITCATEGORY
	Purpose:      Displays an error message
	-->
	<xsl:template match="ERROR" mode="c_editcat">
		<xsl:apply-templates select="." mode="r_editcat"/>
	</xsl:template>
	<!--
	<xsl:template match="ERROR" mode="t_editcat">
	Author:		Tom Whitehouse
	Context:       /H2G2/EDITCATEGORY
	Purpose:      Displays an error message
	-->
	<xsl:template match="ERROR" mode="r_editcat">
		<xsl:choose>
			<xsl:when test="@TYPE='9'">
				<xsl:copy-of select="$m_catsubjectexists"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="ERROR"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="EDITINPUT" mode="c_editcat">
	Author:		Tom Whitehouse
	Context:       /H2G2/EDITCATEGORY
	Purpose:      Chooses container for the rename subject / add subject / change description functionality
	-->
	<xsl:template match="EDITINPUT" mode="c_editcat">
		<xsl:if test="not($userTagging)">
			<xsl:choose>
				<xsl:when test="@TYPE='renamesubject'">
					<form method="get" action="{$root}editcategory" xsl:use-attribute-sets="fEDITINPUT_c_editcat">
						<input name="action" type="hidden" value="dorenamesubject"/>
						<input name="nodeid" type="hidden" value="{../HIERARCHYDETAILS/@NODEID}"/>
						<xsl:apply-templates select="." mode="rename_editcat"/>
					</form>
				</xsl:when>
				<xsl:when test="@TYPE='addsubject'">
					<form method="get" action="{$root}editcategory" xsl:use-attribute-sets="fEDITINPUT_c_editcat">
						<input name="action" type="hidden" value="doaddsubject"/>
						<input name="nodeid" type="hidden" value="{../HIERARCHYDETAILS/@NODEID}"/>
						<xsl:apply-templates select="." mode="addsubject_editcat"/>
					</form>
				</xsl:when>
				<xsl:when test="@TYPE='changedescription'">
					<form method="post" action="{$root}editcategory" xsl:use-attribute-sets="fEDITINPUT_c_editcat">
						<input name="action" type="hidden" value="dochangedesc"/>
						<input name="nodeid" type="hidden" value="{../HIERARCHYDETAILS/@NODEID}"/>
						<xsl:apply-templates select="." mode="changedesc_editcat"/>
					</form>
				</xsl:when>
			</xsl:choose>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="EDITINPUT" mode="t_inputrename">
	Author:		Tom Whitehouse
	Context:       /H2G2/EDITCATEGORY
	Purpose:      Input text box for renaming a subject
	-->
	<xsl:template match="EDITINPUT" mode="t_inputrename">
		<input name="subject" type="text" xsl:use-attribute-sets="iEDITINPUT_t_inputrename"/>
	</xsl:template>
	<!--
	<xsl:template match="EDITINPUT" mode="t_submitrename">
	Author:		Tom Whitehouse
	Context:       /H2G2/EDITCATEGORY
	Purpose:      Submit button for renaming a subject
	-->
	<xsl:template match="EDITINPUT" mode="t_submitrename">
		<input xsl:use-attribute-sets="iEDITINPUT_t_submitrename"/>
	</xsl:template>
	<!--
	<xsl:template match="EDITINPUT" mode="t_inputaddsubject">
	Author:		Tom Whitehouse
	Context:       /H2G2/EDITCATEGORY
	Purpose:      Input text box for adding a new subject
	-->
	<xsl:template match="EDITINPUT" mode="t_inputaddsubject">
		<input name="subject" type="text" xsl:use-attribute-sets="iEDITINPUT_t_inputaddsubject"/>
	</xsl:template>
	<!--
	<xsl:template match="EDITINPUT" mode="t_submitaddsubject">
	Author:		Tom Whitehouse
	Context:       /H2G2/EDITCATEGORY
	Purpose:      Submit button for adding a new subject
	-->
	<xsl:template match="EDITINPUT" mode="t_submitaddsubject">
		<input xsl:use-attribute-sets="iEDITINPUT_t_submitaddsubject"/>
	</xsl:template>
	<!--
	<xsl:template match="EDITINPUT" mode="t_inputchangedesc">
	Author:		Tom Whitehouse
	Context:       /H2G2/EDITCATEGORY
	Purpose:      <textarea> box for inputting a change of description
	-->
	<xsl:template match="EDITINPUT" mode="t_inputchangedesc">
		<textarea name="description" xsl:use-attribute-sets="iEDITINPUT_t_inputchangedesc">
			<xsl:apply-templates/>
		</textarea>
	</xsl:template>
	<!--
	<xsl:template match="EDITINPUT" mode="t_submitchangedesc">
	Author:		Tom Whitehouse
	Context:       /H2G2/EDITCATEGORY
	Purpose:      Submit button for changing the description
	-->
	<xsl:template match="EDITINPUT" mode="t_submitchangedesc">
		<input xsl:use-attribute-sets="iEDITINPUT_t_submitchangedesc"/>
	</xsl:template>
	<!--
	<xsl:template match="HIERARCHYDETAILS" mode="c_addarticle">
	Author:		Tom Whitehouse
	Context:       /H2G2/EDITCATEGORY
	Purpose:      Container for adding a new article
	-->
	<!-- ************************************************************************ -->
	<!-- ************************************************************************ -->
	<!-- ************************************************************************ -->
	<!-- ********             DONT THINK THIS SHOULD BE HERE       ******** -->
	<!-- ************************************************************************ -->
	<!-- ************************************************************************ -->
	<xsl:template match="HIERARCHYDETAILS" mode="c_addarticle">
		<xsl:if test="@ISROOT=0 and not($userTagging)">
			<form method="get" action="EditCategory" xsl:use-attribute-sets="fHIERARCHYDETAILS_c_addarticle">
				<input type="hidden" name="nodeid" value="{@NODEID}"/>
				<input type="hidden" name="action" value="doaddarticle"/>
				<xsl:apply-templates select="." mode="r_addarticle"/>
			</form>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="HIERARCHYDETAILS" mode="t_addarticlednaid">
	Author:		Tom Whitehouse
	Context:       /H2G2/EDITCATEGORY
	Purpose:      Input text box for adding a new article
	-->
	<xsl:template match="HIERARCHYDETAILS" mode="t_addarticlednaid">
		<input type="text" name="h2g2id" xsl:use-attribute-sets="iHIERARCHYDETAILS_t_addarticlednaid"/>
	</xsl:template>
	<!--
	<xsl:template match="HIERARCHYDETAILS" mode="t_addarticlesubmit">
	Author:		Tom Whitehouse
	Context:       /H2G2/EDITCATEGORY
	Purpose:      Submit button for adding a new article
	-->
	<xsl:template match="HIERARCHYDETAILS" mode="t_addarticlesubmit">
		<input name="button" xsl:use-attribute-sets="iHIERARCHYDETAILS_t_addarticlesubmit"/>
	</xsl:template>
	<!--
	<xsl:template match="SYNONYMS" mode="c_editcat">
	Author:		Tom Whitehouse
	Context:       /H2G2/EDITCATEGORY/HIERARCHYDETAILS
	Purpose:      Container for inputting synonyms
	-->
	<xsl:template match="SYNONYMS" mode="c_editcat">
		<xsl:if test="not($userTagging)">
			<form method="get" action="EditCategory" xsl:use-attribute-sets="fSYNONYMS_c_editcat">
				<input type="hidden" name="nodeid" value="{../@NODEID}"/>
				<input type="hidden" name="action" value="doupdatesynonyms"/>
				<xsl:apply-templates select="." mode="r_editcat"/>
			</form>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="SYNONYMS" mode="t_inputsynonyms">
	Author:		Tom Whitehouse
	Context:       /H2G2/EDITCATEGORY/HIERARCHYDETAILS
	Purpose:      Text input box for entering synonyms
	-->
	<xsl:template match="SYNONYMS" mode="t_inputsynonyms">
		<input type="text" name="synonyms" xsl:use-attribute-sets="iSYNONYMS_t_inputsynonyms"/>
	</xsl:template>
	<!--
	<xsl:template match="SYNONYMS" mode="t_submitsynonyms">
	Author:		Tom Whitehouse
	Context:       /H2G2/EDITCATEGORY/HIERARCHYDETAILS
	Purpose:      Submit button for synonyms
	-->
	<xsl:template match="SYNONYMS" mode="t_submitsynonyms">
		<input xsl:use-attribute-sets="iSYNONYMS_t_submitsynonyms"/>
	</xsl:template>
	<!--
	<xsl:template match="HIERARCHYDETAILS" mode="c_addarticle">
	Author:		Tom Whitehouse
	Context:       /H2G2/EDITCATEGORY
	Purpose:      Container for allowing /disallowing users to add articles to this node
	-->
	<xsl:template match="HIERARCHYDETAILS" mode="c_addarticlepermission">
		<xsl:if test="not($userTagging)">
			<xsl:choose>
				<xsl:when test="@USERADD=0">
					<form method="get" action="EditCategory" xsl:use-attribute-sets="mHIERARCHYDETAILS_c_addarticlepermission">
						<input type="hidden" name="nodeid" value="{@NODEID}"/>
						<input type="hidden" name="action" value="doupdateuseradd"/>
						<input type="hidden" name="useradd" value="1"/>
						<xsl:apply-templates select="." mode="no_addarticlepermission"/>
					</form>
				</xsl:when>
				<xsl:when test="@USERADD=1">
					<form method="get" action="EditCategory" xsl:use-attribute-sets="mHIERARCHYDETAILS_c_addarticlepermission">
						<input type="hidden" name="nodeid" value="{@NODEID}"/>
						<input type="hidden" name="action" value="doupdateuseradd"/>
						<input type="hidden" name="useradd" value="0"/>
						<xsl:apply-templates select="." mode="yes_addarticlepermission"/>
					</form>
				</xsl:when>
			</xsl:choose>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="HIERARCHYDETAILS" mode="t_allowusersubmit">
	Author:		Tom Whitehouse
	Context:       /H2G2/EDITCATEGORY
	Purpose:      Submit button to allow users to add articles to this node
	-->
	<xsl:template match="HIERARCHYDETAILS" mode="t_allowusersubmit">
		<input xsl:use-attribute-sets="iHIERARCHYDETAILS_t_allowusersubmit"/>
	</xsl:template>
	<!--
	<xsl:template match="HIERARCHYDETAILS" mode="t_disallowusersubmit">
	Author:		Tom Whitehouse
	Context:       /H2G2/EDITCATEGORY
	Purpose:      Submit button to prevent users from adding articles to this node
	-->
	<xsl:template match="HIERARCHYDETAILS" mode="t_disallowusersubmit">
		<input xsl:use-attribute-sets="iHIERARCHYDETAILS_t_disallowusersubmit"/>
	</xsl:template>
	<!--
	<xsl:template match="HIERARCHYDETAILS" mode="c_addclub">
	Author:		Tom Whitehouse
	Context:       /H2G2/EDITCATEGORY
	Purpose:     Container for adding a club
	-->
	<xsl:template match="HIERARCHYDETAILS" mode="c_addclub">
		<xsl:if test="@ISROOT=0 and not($userTagging)">
			<form method="get" action="EditCategory" xsl:use-attribute-sets="fHIERARCHYDETAILS_c_addclub">
				<input type="hidden" name="nodeid" value="{@NODEID}"/>
				<input type="hidden" NAME="action" VALUE="doaddclub"/>
				<xsl:apply-templates select="." mode="r_addclub"/>
			</form>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="HIERARCHYDETAILS" mode="t_inputclub">
	Author:		Tom Whitehouse
	Context:       /H2G2/EDITCATEGORY
	Purpose:     Text input field for adding a club
	-->
	<xsl:template match="HIERARCHYDETAILS" mode="t_inputclub">
		<input type="text" name="clubid" xsl:use-attribute-sets="iHIERARCHYDETAILS_t_inputclub"/>
	</xsl:template>
	<!--
	<xsl:template match="HIERARCHYDETAILS" mode="t_submitclub">
	Author:		Tom Whitehouse
	Context:       /H2G2/EDITCATEGORY
	Purpose:     Submit button for adding a club
	-->
	<xsl:template match="HIERARCHYDETAILS" mode="t_submitclub">
		<input name="button" xsl:use-attribute-sets="iHIERARCHYDETAILS_t_submitclub"/>
	</xsl:template>
	<!--
	<xsl:template match="MEMBERS" mode="c_editcat">
	Author:		Tom Whitehouse
	Context:       /H2G2/EDITCATEGORY/HIERARCHYDETAILS
	Purpose:     Container for a list of all the members of the current node
	-->
	<xsl:template match="MEMBERS" mode="c_editcat">
		<xsl:apply-templates select="." mode="r_editcat"/>
	</xsl:template>
	<!--
	<xsl:template match="SUBJECTMEMBER" mode="c_editcat">
	Author:		Tom Whitehouse
	Context:       /H2G2/EDITCATEGORY/HIERARCHYDETAILS/MEMBERS
	Purpose:     Container for a Subject member contained within the current node
	-->
	<xsl:template match="SUBJECTMEMBER" mode="c_editcat">
		<xsl:apply-templates select="." mode="r_editcat"/>
	</xsl:template>
	<!--
	<xsl:template match="ARTICLEMEMBER" mode="c_editcat">
	Author:		Tom Whitehouse
	Context:       /H2G2/EDITCATEGORY/HIERARCHYDETAILS/MEMBERS
	Purpose:     Container for an article member contained within the current node
	-->
	<xsl:template match="ARTICLEMEMBER" mode="c_editcat">
		<xsl:apply-templates select="." mode="r_editcat"/>
	</xsl:template>
	<!--
	<xsl:template match="NODEALIASMEMBER" mode="c_editcat">
	Author:		Tom Whitehouse
	Context:       /H2G2/EDITCATEGORY/HIERARCHYDETAILS/MEMBERS
	Purpose:     Container for a nodealias member contained within the current node
	-->
	<xsl:template match="NODEALIASMEMBER" mode="c_editcat">
		<xsl:apply-templates select="." mode="r_editcat"/>
	</xsl:template>
	<!--
	<xsl:template match="CLUBMEMBER" mode="c_editcat">
	Author:		Tom Whitehouse
	Context:       /H2G2/EDITCATEGORY/HIERARCHYDETAILS/MEMBERS
	Purpose:     Container for a club member contained within the current node
	-->
	<xsl:template match="CLUBMEMBER" mode="c_editcat">
		<xsl:apply-templates select="." mode="r_editcat"/>
	</xsl:template>
	<!--
	<xsl:template match="NAME" mode="t_nodename_ec">
	Author:		Tom Whitehouse
	Context:       /H2G2/EDITCATEGORY/HIERARCHYDETAILS/MEMBERS/SUBJECTMEMBER
	Purpose:      Link to another node
	-->
	<xsl:template match="NAME" mode="t_nodename_ec">
		<xsl:variable name="activenode">
			<xsl:if test="/H2G2/EDITCATEGORY/ACTIVENODE/@ACTIVEID">&amp;activenode=<xsl:value-of select="/H2G2/EDITCATEGORY/ACTIVENODE/@ACTIVEID"/>
			</xsl:if>
			<xsl:if test="/H2G2/EDITCATEGORY/ACTIVENODE/@DELNODE">&amp;delnode=<xsl:value-of select="/H2G2/EDITCATEGORY/ACTIVENODE/@DELNODE"/>
			</xsl:if>
		</xsl:variable>
		<xsl:variable name="action">
			<xsl:choose>
				<xsl:when test="/H2G2/EDITCATEGORY/ACTIVENODE/@TYPE">
&amp;action=navigate<xsl:value-of select="/H2G2/EDITCATEGORY/ACTIVENODE/@TYPE"/>
				</xsl:when>
				<xsl:otherwise>
&amp;action=navigatesubject
</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="tagmode">
			<xsl:if test="/H2G2/EDITCATEGORY/HIERARCHYDETAILS/TAGINFO">
				<xsl:value-of select="concat('&amp;tagmode=', /H2G2/EDITCATEGORY/HIERARCHYDETAILS/TAGINFO/@MODE)"/>
			</xsl:if>
		</xsl:variable>
		<xsl:variable name="catlist">
		
			<xsl:if test="/H2G2/EDITCATEGORY/HIERARCHYDETAILS/CATEGORYLIST">
			&amp;catlistid=<xsl:value-of select="/H2G2/EDITCATEGORY/HIERARCHYDETAILS/CATEGORYLIST/@GUID"/>
			</xsl:if>
		</xsl:variable>
		<xsl:variable name="linkto">editcategory?nodeid=<xsl:value-of select="../NODEID"/>
			<xsl:value-of select="$activenode"/>
			<xsl:value-of select="$action"/>
			<xsl:value-of select="$tagmode"/>
			<xsl:value-of select="$catlist"/>
		</xsl:variable>
		<a href="{$root}{$linkto}" xsl:use-attribute-sets="mNAME_t_nodename_ec">
			<xsl:value-of select="."/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="NODECOUNT" mode="c_subject_ec">
	Author:		Tom Whitehouse
	Context:       /H2G2/EDITCATEGORY/HIERARCHYDETAILS/MEMBERS/SUBJECTMEMBER
	Purpose:      Container for displaying the number of child nodes a node contains
	-->
	<xsl:template match="NODECOUNT" mode="c_subject_ec">
		<xsl:choose>
			<xsl:when test=". + ../ARTICLECOUNT + ../ALIASCOUNT = 0">
				<xsl:apply-templates select="." mode="zero_subject_ec"/>
			</xsl:when>
			<xsl:when test=". + ../ARTICLECOUNT + ../ALIASCOUNT = 1">
				<xsl:apply-templates select="." mode="one_subject_ec"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="." mode="many_subject_ec"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="NODECOUNT" mode="many_subject_ec">
	Author:		Tom Whitehouse
	Context:       /H2G2/EDITCATEGORY/HIERARCHYDETAILS/MEMBERS/SUBJECTMEMBER
	Purpose:      Value of the number of child nodes a node contains (called if it is more than one)
	-->
	<xsl:template match="NODECOUNT" mode="many_subject_ec">
		<xsl:value-of select=".+../ARTICLECOUNT+../ALIASCOUNT"/>
	</xsl:template>
	<!--
	<xsl:template match="SUBNODE" mode="c_subnodename_ec">
	Author:		Tom Whitehouse
	Context:       /H2G2/EDITCATEGORY/HIERARCHYDETAILS/MEMBERS/SUBJECTMEMBER/SUBNODES
	Purpose:      Container for a subnode within a node
	-->
	<xsl:template match="SUBNODE" mode="c_subnodename_ec">
		<xsl:apply-templates select="." mode="r_subnodename_ec"/>
	</xsl:template>
	<!--
	<xsl:template match="SUBNODE" mode="r_subnodename_ec">
	Author:		Tom Whitehouse
	Context:       /H2G2/EDITCATEGORY/HIERARCHYDETAILS/MEMBERS/SUBJECTMEMBER/SUBNODES
	Purpose:      Link to a subnode
	-->
	<xsl:template match="SUBNODE" mode="r_subnodename_ec">
		<xsl:variable name="activenode">
			<xsl:if test="/H2G2/EDITCATEGORY/ACTIVENODE/@ACTIVEID">&amp;activenode=<xsl:value-of select="/H2G2/EDITCATEGORY/ACTIVENODE/@ACTIVEID"/>
			</xsl:if>
			<xsl:if test="/H2G2/EDITCATEGORY/ACTIVENODE/@DELNODE">&amp;delnode=<xsl:value-of select="/H2G2/EDITCATEGORY/ACTIVENODE/@DELNODE"/>
			</xsl:if>
		</xsl:variable>
		<xsl:variable name="action">
			<xsl:choose>
				<xsl:when test="/H2G2/EDITCATEGORY/ACTIVENODE/@TYPE">
&amp;action=navigate<xsl:value-of select="/H2G2/EDITCATEGORY/ACTIVENODE/@TYPE"/>
				</xsl:when>
				<xsl:otherwise>
&amp;action=navigatesubject
</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="tagmode">
			<xsl:if test="/H2G2/EDITCATEGORY/HIERARCHYDETAILS/TAGINFO">
				<xsl:value-of select="concat('&amp;tagmode=', /H2G2/EDITCATEGORY/HIERARCHYDETAILS/TAGINFO/@MODE)"/>
			</xsl:if>
		</xsl:variable>
		<xsl:variable name="linkto">editcategory?nodeid=<xsl:value-of select="@ID"/>
			<xsl:value-of select="$activenode"/>
			<xsl:value-of select="$action"/>
			<xsl:value-of select="$tagmode"/>
		</xsl:variable>
		<a href="{$root}{$linkto}" xsl:use-attribute-sets="mSUBNODE_r_subnodename_ec">
			<xsl:value-of select="."/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="SUBJECTMEMBER" mode="t_movesubject">
	Author:		Tom Whitehouse
	Context:       /H2G2/EDITCATEGORY/HIERARCHYDETAILS/MEMBERS
	Purpose:      Link to move a subject member
	-->
	<xsl:template match="SUBJECTMEMBER" mode="r_movesubject">
		<a href="{$root}editcategory?nodeid=0&amp;action=navigatesubject&amp;activenode={NODEID}" xsl:use-attribute-sets="mSUBJECTMEMBER_r_movesubject">
			<xsl:copy-of select="$m_movesubject"/>
		</a>
	</xsl:template>
	<xsl:template match="SUBJECTMEMBER" mode="c_movesubject">
		<xsl:if test="not($userTagging)">
			<xsl:apply-templates select="." mode="r_movesubject"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="SUBJECTMEMBER" mode="t_deletesubject">
	Author:		Tom Whitehouse
	Context:       /H2G2/EDITCATEGORY/HIERARCHYDETAILS/MEMBERS
	Purpose:      Link to delete a subject member
	-->
	<xsl:template match="SUBJECTMEMBER" mode="r_deletesubject">
		<a href="{$root}editcategory?nodeid={../../@NODEID}&amp;action=delsubject&amp;activenode={NODEID}" onclick="return window.confirm('Are you sure you want to delete?');" xsl:use-attribute-sets="mSUBJECTMEMBER_r_deletesubject">
			<xsl:copy-of select="$m_deletesubject"/>
		</a>
	</xsl:template>
	<xsl:template match="SUBJECTMEMBER" mode="c_deletesubject">
		<xsl:if test="not($userTagging)">
			<xsl:apply-templates select="." mode="r_movesubject"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="ARTICLEMEMBER" mode="r_editcat">
	Author:		Tom Whitehouse
	Context:       /H2G2/EDITCATEGORY/HIERARCHYDETAILS/MEMBERS
	Purpose:      Displays a single article member as a link
	-->
	<xsl:template match="ARTICLEMEMBER" mode="r_editcat">
		<a href="{$root}A{H2G2ID}" xsl:use-attribute-sets="mARTICLEMEMBER_r_editcat">
			<xsl:value-of select="NAME"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="ARTICLEMEMBER" mode="t_movearticle">
	Author:		Tom Whitehouse
	Context:       /H2G2/EDITCATEGORY/HIERARCHYDETAILS/MEMBERS
	Purpose:      Displays a link to move an article member
	-->
	<xsl:template match="ARTICLEMEMBER" mode="r_movearticle">
		<a href="{$root}editcategory?nodeid=0&amp;action=navigatearticle&amp;activenode={H2G2ID}&amp;delnode={../../@NODEID}" xsl:use-attribute-sets="mARTICLEMEMBER_r_movearticle">
			<xsl:copy-of select="$m_movearticle"/>
		</a>
	</xsl:template>
	<xsl:template match="ARTICLEMEMBER" mode="c_movearticle">
		<xsl:if test="not($userTagging)">
			<xsl:apply-templates select="." mode="r_movearticle"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="ARTICLEMEMBER" mode="t_deletearticle">
	Author:		Tom Whitehouse
	Context:       /H2G2/EDITCATEGORY/HIERARCHYDETAILS/MEMBERS
	Purpose:      Displays a link to delete an article member
	-->
	<xsl:template match="ARTICLEMEMBER" mode="r_deletearticle">
		<a href="{$root}editcategory?nodeid={../../@NODEID}&amp;action=delarticle&amp;activenode={H2G2ID}" onclick="return window.confirm('Are you sure you want to delete?');" xsl:use-attribute-sets="mARTICLEMEMBER_r_deletearticle">
			<xsl:copy-of select="$m_deletearticle"/>
		</a>
	</xsl:template>
	<xsl:template match="ARTICLEMEMBER" mode="c_deletearticle">
		<xsl:if test="not($userTagging)">
			<xsl:apply-templates select="." mode="r_deletearticle"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="NAME" mode="t_clubname_ec">
	Author:		Tom Whitehouse
	Context:       /H2G2/EDITCATEGORY/HIERARCHYDETAILS/MEMBERS/CLUBMEMBER
	Purpose:     Displays a clubname as a link
	-->
	<xsl:template match="NAME" mode="t_clubname_ec">
		<a href="{$root}G{../CLUBID}" xsl:use-attribute-sets="mNAME_t_clubname_ec">
			<xsl:value-of select="."/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="DESCRIPTION" mode="c_clubdescription_ec">
	Author:		Tom Whitehouse
	Context:       /H2G2/EDITCATEGORY/HIERARCHYDETAILS/MEMBERS/CLUBMEMBER/EXTRAINFO
	Purpose:     Container for a club description
	-->
	<xsl:template match="DESCRIPTION" mode="c_clubdescription_ec">
		<xsl:apply-templates select="." mode="r_clubdescription_ec"/>
	</xsl:template>
	<!--
	<xsl:template match="CLUBMEMBER" mode="t_moveclub">
	Author:		Tom Whitehouse
	Context:       /H2G2/EDITCATEGORY/HIERARCHYDETAILS/MEMBERS
	Purpose:     Displays a link to move a club
	-->
	<xsl:template match="CLUBMEMBER" mode="r_moveclub">
		<a href="{$root}editcategory?nodeid=0&amp;action=navigateclub&amp;activenode={CLUBID}&amp;delnode={../../@NODEID}" xsl:use-attribute-sets="mCLUBMEMBER_r_moveclub">
			<xsl:copy-of select="$m_moveclub"/>
		</a>
	</xsl:template>
	<xsl:template match="CLUBMEMBER" mode="c_moveclub">
		<xsl:if test="not($userTagging)">
			<xsl:apply-templates select="." mode="r_moveclub"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="CLUBMEMBER" mode="t_deleteclub">
	Author:		Tom Whitehouse
	Context:       /H2G2/EDITCATEGORY/HIERARCHYDETAILS/MEMBERS
	Purpose:     Displays a link to delete a club
	-->
	<xsl:template match="CLUBMEMBER" mode="r_deleteclub">
		<a href="{$root}editcategory?nodeid={../../@NODEID}&amp;action=delclub&amp;activenode={CLUBID}" onclick="return window.confirm('Are you sure you want to delete this club?');" xsl:use-attribute-sets="mCLUBMEMBER_r_deleteclub">
			<xsl:copy-of select="$m_deleteclub"/>
		</a>
	</xsl:template>
	<xsl:template match="CLUBMEMBER" mode="c_deleteclub">
		<xsl:if test="not($userTagging)">
			<xsl:apply-templates select="." mode="r_deleteclub"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="NAME" mode="t_nodealiasname_ec">
	Author:		Tom Whitehouse
	Context:       /H2G2/EDITCATEGORY/HIERARCHYDETAILS/MEMBERS/NODEALIASMEMBER
	Purpose:     Displays a node alias name, as a link
	-->
	<xsl:template match="NAME" mode="t_nodealiasname_ec">
		<xsl:variable name="activenode">
			<xsl:if test="/H2G2/EDITCATEGORY/ACTIVENODE/@ACTIVEID">&amp;activenode=<xsl:value-of select="/H2G2/EDITCATEGORY/ACTIVENODE/@ACTIVEID"/>
			</xsl:if>
			<xsl:if test="/H2G2/EDITCATEGORY/ACTIVENODE/@DELNODE">&amp;delnode=<xsl:value-of select="/H2G2/EDITCATEGORY/ACTIVENODE/@DELNODE"/>
			</xsl:if>
		</xsl:variable>
		<xsl:variable name="action">
			<xsl:choose>
				<xsl:when test="/H2G2/EDITCATEGORY/ACTIVENODE/@TYPE">&amp;action=navigate<xsl:value-of select="/H2G2/EDITCATEGORY/ACTIVENODE/@TYPE"/>
				</xsl:when>
				<xsl:otherwise>&amp;action=navigatesubject</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="tagmode">
			<xsl:if test="/H2G2/EDITCATEGORY/HIERARCHYDETAILS/TAGINFO">
				<xsl:value-of select="concat('&amp;tagmode=', /H2G2/EDITCATEGORY/HIERARCHYDETAILS/TAGINFO/@MODE)"/>
			</xsl:if>
		</xsl:variable>
		<a href="{$root}editcategory?nodeid={../LINKNODEID}{$activenode}{$action}{$tagmode}" xsl:use-attribute-sets="mNAME_t_nodealiasname_ec">
			<xsl:value-of select="."/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="NODECOUNT" mode="c_nodealias_ec">
	Author:		Tom Whitehouse
	Context:       /H2G2/EDITCATEGORY/HIERARCHYDETAILS/MEMBERS/NODEALIASMEMBER
	Purpose:     Container for the number of children a node alias member has
	-->
	<xsl:template match="NODECOUNT" mode="c_nodealias_ec">
		<xsl:choose>
			<xsl:when test=". + ../ARTICLECOUNT + ../ALIASCOUNT = 0">
				<xsl:apply-templates select="." mode="zero_nodealias_ec"/>
			</xsl:when>
			<xsl:when test=". + ../ARTICLECOUNT + ../ALIASCOUNT = 1">
				<xsl:apply-templates select="." mode="one_nodealias_ec"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="." mode="many_nodealias_ec"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="NODECOUNT" mode="many_nodealias_ec">
	Author:		Tom Whitehouse
	Context:       /H2G2/EDITCATEGORY/HIERARCHYDETAILS/MEMBERS/NODEALIASMEMBER
	Purpose:     Displays the number of children a node alias member has
	-->
	<xsl:template match="NODECOUNT" mode="many_nodealias_ec">
		<xsl:value-of select=".+../ARTICLECOUNT+../ALIASCOUNT"/>
	</xsl:template>
	<!--
	<xsl:template match="NODEALIASMEMBER" mode="t_movesubjectlink">
	Author:		Tom Whitehouse
	Context:       /H2G2/EDITCATEGORY/HIERARCHYDETAILS/MEMBERS
	Purpose:     Displays a link to move the current subject node alias link
	-->
	<xsl:template match="NODEALIASMEMBER" mode="r_movesubjectlink">
		<a href="{$root}editcategory?nodeid=0&amp;action=navigatealias&amp;activenode={LINKNODEID}&amp;delnode={../../@NODEID}" xsl:use-attribute-sets="mNODEALIASMEMBER_r_movesubjectlink">
			<xsl:copy-of select="$m_movesubjectlink"/>
		</a>
	</xsl:template>
	<xsl:template match="NODEALIASMEMBER" mode="c_movesubjectlink">
		<xsl:if test="not($userTagging)">
			<xsl:apply-templates select="." mode="r_movesubjectlink"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="NODEALIASMEMBER" mode="t_deletesubjectlink">
	Author:		Tom Whitehouse
	Context:       /H2G2/EDITCATEGORY/HIERARCHYDETAILS/MEMBERS
	Purpose:     Displays a link to delete the current subject node alias link
	-->
	<xsl:template match="NODEALIASMEMBER" mode="r_deletesubjectlink">
		<a href="{$root}editcategory?nodeid={../../@NODEID}&amp;action=delalias&amp;activenode={LINKNODEID}" onclick="return window.confirm('Are you sure you want to delete');" xsl:use-attribute-sets="mNODEALIASMEMBER_r_deletesubjectlink">
			<xsl:copy-of select="$m_deletesubjectlink"/>
		</a>
	</xsl:template>
	<xsl:template match="NODEALIASMEMBER" mode="c_deletesubjectlink">
		<xsl:if test="not($userTagging)">
			<xsl:apply-templates select="." mode="r_deletesubjectlink"/>
		</xsl:if>
	</xsl:template>
	<xsl:template match="TAGINFO" mode="c_tagnode">
		<xsl:apply-templates select="." mode="r_tagnode"/>
	</xsl:template>
	<xsl:variable name="m_tagtothisnode">Tag to this node</xsl:variable>
	<xsl:variable name="m_movetothisnode">Move to this node</xsl:variable>
	<xsl:variable name="m_nopermissiontotag">You are not authorised to tag this node.</xsl:variable>
	<xsl:variable name="taginfo">
		<xsl:value-of select="concat('&amp;tagitemid=', /H2G2/EDITCATEGORY/ACTIVENODE/@ACTIVEID)"/>
		<xsl:choose>
			<xsl:when test="/H2G2/EDITCATEGORY/ACTIVENODE/@TYPEID &lt; 1000">&amp;tagitemtype=<xsl:value-of select="/H2G2/EDITCATEGORY/ACTIVENODE/@TYPEID"/></xsl:when>
			<xsl:when test="/H2G2/EDITCATEGORY/ACTIVENODE/@TYPEID = 1001">&amp;tagitemtype=1001</xsl:when>
			<xsl:when test="/H2G2/EDITCATEGORY/ACTIVENODE/@TYPEID = 3001">&amp;tagitemtype=3001</xsl:when>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="/H2G2/EDITCATEGORY/HIERARCHYDETAILS/TAGINFO/@MODE=1">
					&amp;tagorigin=<xsl:value-of select="/H2G2/EDITCATEGORY/HIERARCHYDETAILS/@NODEID"/>
			</xsl:when>
			<xsl:when test="/H2G2/EDITCATEGORY/HIERARCHYDETAILS/TAGINFO/@MODE=2">
					&amp;tagorigin=<xsl:value-of select="/H2G2/EDITCATEGORY/ACTIVENODE/@DELNODE"/>
					&amp;tagdestination=<xsl:value-of select="/H2G2/EDITCATEGORY/HIERARCHYDETAILS/@NODEID"/>
			</xsl:when>
		</xsl:choose>
	</xsl:variable>
	<xsl:attribute-set name="mTAGINFO_r_tagnode" use-attribute-sets="editcategorypagelinks"/>
	<xsl:template match="TAGINFO" mode="r_tagnode">
		<xsl:choose>
			<xsl:when test="/H2G2/EDITCATEGORY/HIERARCHYDETAILS/TAGINFO/@MODE=1">
				<xsl:choose>
					<xsl:when test="/H2G2/EDITCATEGORY/HIERARCHYDETAILS/@USERADD=1 and /H2G2/EDITCATEGORY/HIERARCHYDETAILS/@ISROOT!=1">
						<a href="{@root}TagItem?action=add{$taginfo}" xsl:use-attribute-sets="mTAGINFO_r_tagnode">
							<xsl:copy-of select="$m_tagtothisnode"/>
						</a>
					</xsl:when>
					<xsl:otherwise>
						<xsl:copy-of select="$m_nopermissiontotag"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="/H2G2/EDITCATEGORY/HIERARCHYDETAILS/TAGINFO/@MODE=2">
				<xsl:choose>
					<xsl:when test="/H2G2/EDITCATEGORY/HIERARCHYDETAILS/@USERADD=1 and /H2G2/EDITCATEGORY/HIERARCHYDETAILS/@ISROOT!=1">
						<a href="{@root}TagItem?action=move{$taginfo}" xsl:use-attribute-sets="mTAGINFO_r_tagnode">
							<xsl:copy-of select="$m_movetothisnode"/>
						</a>
					</xsl:when>
					<xsl:otherwise>
						<xsl:copy-of select="$m_nopermissiontotag"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="TAGINFO" mode="c_returntotagitem">
		<xsl:apply-templates select="." mode="r_returntotagitem"/>
	</xsl:template>

	<xsl:template match="TAGINFO" mode="r_returntotagitem">
		<xsl:choose>
			<xsl:when test="/H2G2/EDITCATEGORY/ACTIVENODE/@TYPEID &lt; 1000">
				<a href="{$root}TagItem?tagitemtype={/H2G2/EDITCATEGORY/ACTIVENODE/@TYPEID}&amp;tagitemid={/H2G2/EDITCATEGORY/ACTIVENODE/@ACTIVEID}" xsl:use-attribute-sets="mTAGINFO_r_returntotagitem">
					<xsl:copy-of select="$m_returntotagarticlepage"/>
				</a>
			</xsl:when>
			<xsl:when test="/H2G2/EDITCATEGORY/ACTIVENODE/@TYPEID = 1001">
				<a href="{$root}TagItem?tagitemtype=1001&amp;tagitemid={/H2G2/EDITCATEGORY/ACTIVENODE/@ACTIVEID}" xsl:use-attribute-sets="mTAGINFO_r_returntotagitem">
					<xsl:copy-of select="$m_returntotagclubpage"/>
				</a>
			</xsl:when>
			<xsl:when test="/H2G2/EDITCATEGORY/ACTIVENODE/@TYPEID = 3001">
				<a href="{$root}TagItem?tagitemtype=3001&amp;tagitemid={/H2G2/EDITCATEGORY/ACTIVENODE/@ACTIVEID}" xsl:use-attribute-sets="mTAGINFO_r_returntotagitem">
					<xsl:copy-of select="$m_returntotaguserpage"/>
				</a>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
