<?xml version="1.0" encoding="ISO-8859-1"?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<xsl:variable name="articlemaxlength"/>
	<xsl:variable name="clubmaxlength"/>
	
	<!--
	<xsl:template name="CATEGORY_HEADER">
	Author:		Tom Whitehouse
	Context:       /H2G2
	Purpose:      Creates the title for the page which sits in the html header
	-->
	<xsl:template name="CATEGORY_HEADER">
		<xsl:apply-templates mode="header" select=".">
			<xsl:with-param name="title">
				<xsl:value-of select="$m_pagetitlestart"/>
				<xsl:value-of select="$m_browsetheguide"/>
				<xsl:value-of select="concat(' - ', /H2G2/HIERARCHYDETAILS/DISPLAYNAME)"/>
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>
	<!--
	<xsl:template name="CATEGORY_SUBJECT">
	Author:		Tom Whitehouse
	Context:       /H2G2
	Purpose:     Creates the text for the subject
	-->
	<xsl:template name="CATEGORY_SUBJECT">
		<xsl:call-template name="SUBJECTHEADER">
			<xsl:with-param name="text">
				<xsl:value-of select="$m_browsetheguide"/>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
					HIERARCHYDETAILS for taxonomy page
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<!--
	<xsl:template match="HIERARCHYDETAILS" mode="c_category">
	Author:		Tom Whitehouse
	Context:       /H2G2
	Purpose:      Creates the container for the HIERARCHYDETAILS object
	-->
	<xsl:template match="HIERARCHYDETAILS" mode="c_category">
		<xsl:apply-templates select="." mode="r_category"/>
	</xsl:template>
	
	
	<xsl:variable name="m_categorylinkclipped">This category has been added to your clippings</xsl:variable>
	<xsl:variable name="m_categoryalreadyclipped">You have already added this category to your clippings</xsl:variable>
	
	
	
	<xsl:template match="CLIP" mode="c_categoryclipped">
		<xsl:apply-templates select="." mode="r_articleclipped"/>
	</xsl:template>
	<xsl:template match="CLIP" mode="r_categoryclipped">
		<xsl:choose>
			<xsl:when test="@RESULT='success'">
				<xsl:copy-of select="$m_categorylinkclipped"/>
			</xsl:when>
			<xsl:when test="@RESULT='alreadylinked'">
				<xsl:copy-of select="$m_categoryalreadyclipped"/>
			</xsl:when>
			<xsl:when test="@RESULT='alreadylinkedhidden'">
				<xsl:copy-of select="$m_categoryalreadyclipped"/>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="PAGE-OWNER" mode="r_clip">
	Author:		Tom Whitehouse
	Context:      /H2G2
	Purpose:	 Creates the 'save as clippings' link 
	-->


	<xsl:template match="HIERARCHYDETAILS" mode="r_clip">
		<a href="{$root}C{@NODEID}?clip=1" xsl:use-attribute-sets="mHIERARCHYDETAILS_r_clip">
			<xsl:copy-of select="$m_clipcategorypage"/>
		</a>
	</xsl:template>
	

	<xsl:template match="HIERARCHYDETAILS" mode="r_clipissue">
		<a href="{$root}C{@NODEID}?clip=1" xsl:use-attribute-sets="mHIERARCHYDETAILS_r_clipissue">
			<xsl:copy-of select="$m_clipissuepage"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="MEMBERS" mode="c_category">
	Author:		Tom Whitehouse
	Context:       /H2G2/HIERARCHYDETAILS
	Purpose:      Creates the MEMBERS object container - a list of all the node's members
	-->
	<xsl:template match="MEMBERS" mode="c_category">
		<xsl:apply-templates select="." mode="r_category"/>
	</xsl:template>
	<!--
	<xsl:template match="ANCESTRY" mode="c_category">
	Author:		Tom Whitehouse
	Context:       /H2G2/HIERARCHYDETAILS
	Purpose:      Creates the container holding the list of ancestors in the crumbtrail
	-->
	<xsl:template match="ANCESTRY" mode="c_category">
		<xsl:apply-templates select="." mode="r_category"/>
	</xsl:template>
	<!--
	<xsl:template match="ANCESTOR" mode="c_category">
	Author:		Tom Whitehouse
	Context:       /H2G2/HIERARCHYDETAILS
	Purpose:      Creates the container holding a single ancestor in a crumbtrail
	-->
	<xsl:template match="ANCESTOR" mode="c_category">
		<xsl:apply-templates select="." mode="r_category"/>
	</xsl:template>
	<!--
	<xsl:template match="ANCESTOR" mode="r_category">
	Author:		Tom Whitehouse
	Context:       /H2G2/HIERARCHYDETAILS/ANCESTRY
	Purpose:     Creates the link to a category node from a node in the crumbtrail 
	-->
	<xsl:template match="ANCESTOR" mode="r_category">
		<a href="{$root}C{NODEID}" xsl:use-attribute-sets="mANCESTOR_r_category">
			<xsl:value-of select="NAME"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="SUBJECTMEMBER" mode="c_category">
	Author:		Tom Whitehouse
	Context:       /H2G2/HIERARCHYDETAILS/MEMBERS
	Purpose:      Creates the container for a Subject member contained within the current node
	-->
	<xsl:template match="SUBJECTMEMBER" mode="c_category">
		<xsl:apply-templates select="." mode="r_category"/>
	</xsl:template>
	<!--
	<xsl:template match="NODEALIASMEMBER" mode="c_category">
	Author:		Tom Whitehouse
	Context:       /H2G2/HIERARCHYDETAILS/MEMBERS
	Purpose:      Creates the container for a Nodealias member contained within the current node
	-->
	<xsl:template match="NODEALIASMEMBER" mode="c_category">
		<xsl:apply-templates select="." mode="r_category"/>
	</xsl:template>
	<!--
	<xsl:template match="NAME" mode="t_nodename">
	Author:		Tom Whitehouse
	Context:       /H2G2/HIERARCHYDETAILS/MEMBERS/SUBJECTMEMBER
	Purpose:      Links to another subject member node
	-->
	<xsl:template match="NAME" mode="t_nodename">
		<a href="{$root}C{../NODEID}" xsl:use-attribute-sets="mNAME_t_nodename">
			<xsl:value-of select="."/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="SUBNODES" mode="c_category">
	Author:		Tom Whitehouse
	Context:       /H2G2/HIERARCHYDETAILS/MEMBERS/SUBJECTMEMBER
	Purpose:      Creates the container holding all the subnodes of the current node
	-->
	<xsl:template match="SUBNODES" mode="c_category">
		<xsl:apply-templates select="." mode="r_category"/>
	</xsl:template>
	<!--
	<xsl:template match="SUBNODE" mode="c_subnodename">
	Author:		Tom Whitehouse
	Context:       /H2G2/HIERARCHYDETAILS/MEMBERS/SUBJECTMEMBER/SUBNODES
	Purpose:      Creates the container holding a single subnode of the current node
	-->
	<xsl:template match="SUBNODE" mode="c_subnodename">
		<xsl:apply-templates select="." mode="r_subnodename"/>
	</xsl:template>
	<!--
	<xsl:template match="SUBNODE" mode="r_subnodename">
	Author:		Tom Whitehouse
	Context:       /H2G2/HIERARCHYDETAILS/MEMBERS/SUBJECTMEMBER/SUBNODES
	Purpose:      A subnode which links to another subject node in the taxonomy
	-->
	<xsl:template match="SUBNODE" mode="r_subnodename">
		<a href="{$root}C{@ID}" xsl:use-attribute-sets="mSUBNODE_r_subnodename">
			<xsl:value-of select="."/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="NODECOUNT" mode="c_subject">
	Author:		Tom Whitehouse
	Context:       /H2G2/HIERARCHYDETAILS/MEMBERS/SUBJECTMEMBER
	Purpose:      Calculates how many child nodes the current node has
	-->
	<xsl:template match="NODECOUNT" mode="c_subject">
		<xsl:choose>
			<xsl:when test=". + ../ARTICLECOUNT + ../ALIASCOUNT = 0">
				<xsl:apply-templates select="." mode="zero_subject"/>
			</xsl:when>
			<xsl:when test=". + ../ARTICLECOUNT + ../ALIASCOUNT = 1">
				<xsl:apply-templates select="." mode="one_subject"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="." mode="many_subject"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="NODECOUNT" mode="many_subject">
	Author:		Tom Whitehouse
	Context:       /H2G2/HIERARCHYDETAILS/MEMBERS/SUBJECTMEMBER
	Purpose:      Calculates the number of child nodes for the current subjectmember if more than one
	-->
	<xsl:template match="NODECOUNT" mode="many_subject">
		<xsl:value-of select=".+../ARTICLECOUNT+../ALIASCOUNT"/>
	</xsl:template>
	<!--
	<xsl:template match="NODECOUNT" mode="c_nodealias">
	Author:		Tom Whitehouse
	Context:       /H2G2/HIERARCHYDETAILS/MEMBERS/SUBJECTMEMBER
	Purpose:      Calculates how many child nodes the current nodealias has
	-->
	<xsl:template match="NODECOUNT" mode="c_nodealias">
		<xsl:choose>
			<xsl:when test=". + ../ARTICLECOUNT + ../ALIASCOUNT = 0">
				<xsl:apply-templates select="." mode="zero_nodealias"/>
			</xsl:when>
			<xsl:when test=". + ../ARTICLECOUNT + ../ALIASCOUNT = 1">
				<xsl:apply-templates select="." mode="one_nodealias"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="." mode="many_nodealias"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="NODECOUNT" mode="many_nodealias">
	Author:		Tom Whitehouse
	Context:       /H2G2/HIERARCHYDETAILS/MEMBERS/NODEALIASMEMBER
	Purpose:       Calculates the number of child nodes for the current nodealias if more than one
	-->
	<xsl:template match="NODECOUNT" mode="many_nodealias">
		<xsl:value-of select=".+../ARTICLECOUNT+../ALIASCOUNT"/>
	</xsl:template>
	<!--
	<xsl:template match="ARTICLEMEMBER" mode="c_category">
	Author:		Tom Whitehouse
	Context:       /H2G2/HIERARCHYDETAILS/MEMBERS
	Purpose:      Creates the container for an article member
	-->
	<xsl:template match="ARTICLEMEMBER" mode="c_category">
		<xsl:apply-templates select="." mode="r_category"/>
	</xsl:template>
	<!--
	<xsl:template match="ARTICLEMEMBER" mode="r_category">
	Author:		Tom Whitehouse
	Context:       /H2G2/HIERARCHYDETAILS/MEMBERS
	Purpose:      Creates a link to an article member 
	-->
	<xsl:template match="ARTICLEMEMBER" mode="r_category">
		<a href="{$root}A{H2G2ID}" xsl:use-attribute-sets="mNAME_t_articlename">
			<xsl:value-of select="NAME"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="NAME" mode="t_nodealiasname">
	Author:		Tom Whitehouse
	Context:       /H2G2/HIERARCHYDETAILS/MEMBERS/ARTICLEMEMBER
	Purpose:      Creates a link to a nodealias member
	-->
	<xsl:template match="NAME" mode="t_nodealiasname">
		<a href="{$root}C{../LINKNODEID}" xsl:use-attribute-sets="mNAME_t_nodealiasname">
			<xsl:value-of select="."/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="CLUBMEMBER" mode="c_category">
	Author:		Tom Whitehouse
	Context:       /H2G2/HIERARCHYDETAILS/MEMBERS
	Purpose:      Creates the container for a club member
	-->
	<xsl:template match="CLUBMEMBER" mode="c_category">
		<xsl:apply-templates select="." mode="r_category"/>
	</xsl:template>
	<!--
	<xsl:template match="NAME" mode="t_clubname">
	Author:		Tom Whitehouse
	Context:       /H2G2/HIERARCHYDETAILS/MEMBERS/CLUBMEMBER
	Purpose:      Creates a link to a club member
	-->
	<xsl:template match="NAME" mode="t_clubname">
		<a href="{$root}G{../CLUBID}" xsl:use-attribute-sets="mNAME_t_clubname">
			<xsl:value-of select="."/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="DESCRIPTION" mode="c_clubdescription">
	Author:		Tom Whitehouse
	Context:       /H2G2/HIERARCHYDETAILS/MEMBERS/CLUBMEMBER
	Purpose:      Creates a container for the description of the current node
	-->
	<xsl:template match="DESCRIPTION" mode="c_clubdescription">
		<xsl:apply-templates select="." mode="r_clubdescription"/>
	</xsl:template>
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
					HIERARCHYDETAILS for issue page
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<!--
	<xsl:template match="HIERARCHYDETAILS" mode="c_issue">
	Author:		Tom Whitehouse
	Context:       /H2G2
	Purpose:      Creates the container for the Herarchydetails object if the category page is 
	to be displayed as an issue
	-->
	<xsl:template match="HIERARCHYDETAILS" mode="c_issue">
		<xsl:apply-templates select="." mode="r_issue"/>
	</xsl:template>
	<xsl:variable name="m_issuelinkclipped">This issue has been added to your clippings</xsl:variable>
	<xsl:variable name="m_issuealreadyclipped">You have already added this issue to your clippings</xsl:variable>
	
	
	
	<xsl:template match="CLIP" mode="c_issueclipped">
		<xsl:apply-templates select="." mode="r_issueclipped"/>
	</xsl:template>
	<xsl:template match="CLIP" mode="r_issueclipped">
		<xsl:choose>
			<xsl:when test="@RESULT='success'">
				<xsl:copy-of select="$m_issuelinkclipped"/>
			</xsl:when>
			<xsl:when test="@RESULT='alreadylinked'">
				<xsl:copy-of select="$m_issuealreadyclipped"/>
			</xsl:when>
			<xsl:when test="@RESULT='alreadylinkedhidden'">
				<xsl:copy-of select="$m_categoryalreadyclipped"/>
			</xsl:when>
		</xsl:choose>
	</xsl:template>

	
	<!--
	<xsl:template match="MEMBERS" mode="c_subjectmembers">
	Author:		Tom Whitehouse
	Context:       /H2G2/HIERARCHYDETAILS
	Purpose:      Creates the container for the list of subject members
	-->
	<xsl:template match="MEMBERS" mode="c_subjectmembers">
		<xsl:if test="SUBJECTMEMBER">
			<xsl:apply-templates select="." mode="r_subjectmembers"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="SUBJECTMEMBER" mode="c_issue">
	Author:		Tom Whitehouse
	Context:       /H2G2/HIERARCHYDETAILS/MEMBERS
	Purpose:      Creates the container for a single subject member
	-->
	<xsl:template match="SUBJECTMEMBER" mode="c_issue">
		<xsl:apply-templates select="." mode="r_issue"/>
	</xsl:template>
	<!--
	<xsl:template match="SUBJECTMEMBER" mode="r_issue">
	Author:		Tom Whitehouse
	Context:       /H2G2/HIERARCHYDETAILS/MEMBERS
	Purpose:      Creates a link to another subject node in the taxonomy
	-->
	<xsl:template match="SUBJECTMEMBER" mode="r_issue">
		<a href="{$root}C{NODEID}" xsl:use-attribute-sets="mSUBJECTMEMBER_r_issue">
			<xsl:value-of select="NAME"/>
		</a>
	</xsl:template>
	
	<!--
	<xsl:template match="MEMBERS" mode="c_nodealiasmembers">
	Author:		Tom Whitehouse
	Context:       /H2G2/HIERARCHYDETAILS
	Purpose:      Creates the container for the list of subject members
	-->
	<xsl:template match="MEMBERS" mode="c_nodealiasmembers">
		<xsl:if test="NODEALIASMEMBER">
			<xsl:apply-templates select="." mode="r_nodealiasmembers"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="NODEALIASMEMBER" mode="c_issue">
	Author:		Tom Whitehouse
	Context:       /H2G2/HIERARCHYDETAILS/MEMBERS
	Purpose:      Creates the container for a single nodealias member
	-->
	<xsl:template match="NODEALIASMEMBER" mode="c_issue">
		<xsl:apply-templates select="." mode="r_issue"/>
	</xsl:template>
	<!--
	<xsl:template match="NODEALIASMEMBER" mode="r_issue">
	Author:		Tom Whitehouse
	Context:       /H2G2/HIERARCHYDETAILS/MEMBERS
	Purpose:      Creates a link to another subject node in the taxonomy
	-->
	<xsl:template match="NODEALIASMEMBER" mode="r_issue">
		<a href="{$root}C{LINKNODEID}" xsl:use-attribute-sets="mSUBJECTMEMBER_r_issue">
			<xsl:value-of select="NAME"/>
		</a>
	</xsl:template>
	
	
	
	<!--
	<xsl:template match="MEMBERS" mode="c_numberofclubs">
	Author:		Tom Whitehouse
	Context:       /H2G2/HIERARCHYDETAILS
	Purpose:      Creates the container for displaying how many clubs there are
	-->
	<xsl:template match="MEMBERS" mode="c_numberofclubs">
		<xsl:if test="CLUBMEMBER">
			<a href="#clubs">
				<xsl:apply-templates select="." mode="r_numberofclubs"/>
			</a>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="MEMBERS" mode="r_numberofclubs">
	Author:		Tom Whitehouse
	Context:        /H2G2/HIERARCHYDETAILS
	Purpose:      Counts the number of clubmembers in the current node
	-->
	<xsl:template match="MEMBERS" mode="r_numberofclubs">
		<xsl:value-of select="count(CLUBMEMBER)"/>
	</xsl:template>
	<!--
	<xsl:template match="MEMBERS" mode="c_numberofarticles">
	Author:		Tom Whitehouse
	Context:       /H2G2/HIERARCHYDETAILS
	Purpose:      Create the container displaying how many articles there are
	-->
	<xsl:template match="MEMBERS" mode="c_numberofarticles">
		<xsl:if test="ARTICLEMEMBER">
			<a href="#articles">
				<xsl:apply-templates select="." mode="r_numberofarticles"/>
			</a>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="MEMBERS" mode="r_numberofarticles">
	Author:		Tom Whitehouse
	Context:       /H2G2/HIERARCHYDETAILS
	Purpose:      Counts the number of articles in the current node
	-->
	<xsl:template match="MEMBERS" mode="r_numberofarticles">
		<xsl:value-of select="count(ARTICLEMEMBER[EXTRAINFO/TYPE/@ID = '1' or not(EXTRAINFO)])"/>
	</xsl:template>
	<!--
	<xsl:template match="MEMBERS" mode="c_clubmembers">
	Author:		Tom Whitehouse
	Context:       /H2G2/HIERARCHYDETAILS
	Purpose:      Creates the container containing the list of clubs
	-->
	<xsl:template match="MEMBERS" mode="c_clubmembers">
		<xsl:if test="CLUBMEMBER">
			<xsl:choose>
				<xsl:when test="H2G2/PARAMS/PARAM[NAME = 's_type']/VALUE = '1001'">
					<xsl:apply-templates select="." mode="full_clubmembers"/>
				</xsl:when>
				<xsl:otherwise>
					<a name="clubs"/>
					<xsl:apply-templates select="." mode="short_clubmembers"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="MEMBERS" mode="c_moreclubs">
	Author:		Andy Harris
	Context:       /H2G2/HIERARCHYDETAILS/MEMBERS
	Purpose:      Checks the length of the clubs list and presents the 'See more clubs' link if necessary
	-->
	<xsl:template match="MEMBERS" mode="c_moreclubs">
		<xsl:if test="(count(CLUBMEMBER[EXTRAINFO/TYPE/@ID = '1001' or not(EXTRAINFO/TYPE)]) &gt; $clubmaxlength) and not(/H2G2/PARAMS/PARAM[NAME = 's_type']/VALUE = '1001')">
			<xsl:apply-templates select="." mode="r_moreclubs"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="MEMBERS" mode="r_moreclubs">
	Author:		Andy Harris
	Context:       /H2G2/HIERARCHYDETAILS/MEMBERS
	Purpose:      Creates the 'See more clubs' link
	-->
	<xsl:template match="MEMBERS" mode="r_moreclubs">
		<a href="{$root}C{../@NODEID}?s_type=1001">
			<xsl:copy-of select="$m_moreclubs"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="CLUBMEMBER" mode="c_issue">
	Author:		Tom Whitehouse
	Context:       /H2G2/HIERARCHYDETAILS/MEMBERS
	Purpose:      Creates the container for a single club
	-->
	<xsl:template match="CLUBMEMBER" mode="c_issue">
		<xsl:choose>
			<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_type']/VALUE = '1001'">
				<xsl:if test="EXTRAINFO/TYPE/@ID = '1001' or not(EXTRAINFO/TYPE)">
					<xsl:apply-templates select="." mode="r_issue"/>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<xsl:if test="(EXTRAINFO/TYPE/@ID = '1001' or not(EXTRAINFO/TYPE)) and (count(preceding-sibling::CLUBMEMBER[EXTRAINFO/TYPE/@ID = '1001' or not(EXTRAINFO/TYPE)]) &lt; $clubmaxlength)">
					<xsl:apply-templates select="." mode="r_issue"/>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="CLUBMEMBER" mode="t_clubname">
	Author:		Tom Whitehouse
	Context:       /H2G2/HIERARCHYDETAILS/MEMBERS
	Purpose:      Creates the link to a club page
	-->
	<xsl:template match="CLUBMEMBER" mode="t_clubname">
		<a href="{$root}G{CLUBID}" xsl:use-attribute-sets="mNAME_t_clubname">
			<xsl:value-of select="NAME"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="CLUBMEMBER" mode="t_clubdescription">
	Author:		Tom Whitehouse
	Context:        /H2G2/HIERARCHYDETAILS/MEMBERS
	Purpose:      Displays the description attached to a club
	-->
	<xsl:template match="CLUBMEMBER" mode="t_clubdescription">
		<xsl:value-of select="EXTRAINFO/AUTODESCRIPTION"/>
	</xsl:template>
	<!--
	<xsl:template match="MEMBERS" mode="c_articlemembers">
	Author:		Tom Whitehouse
	Context:       /H2G2/HIERARCHYDETAILS
	Purpose:      Creates the container for a list of all the articles within the current node
	-->
	<xsl:template match="MEMBERS" mode="c_articlemembers">
		<xsl:if test="ARTICLEMEMBER[EXTRAINFO/TYPE/@ID = '1'] or ARTICLEMEMBER[not(EXTRAINFO)]">
			<xsl:choose>
				<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_type']/VALUE = '1'">
					<xsl:apply-templates select="." mode="full_articlemembers"/>
				</xsl:when>
				<xsl:otherwise>
					<a name="articles"/>
					<xsl:apply-templates select="." mode="short_articlemembers"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="ARTICLEMEMBER" mode="c_issue">
	Author:		Tom Whitehouse
	Context:        /H2G2/HIERARCHYDETAILS/MEMBERS
	Purpose:      Creates the container for a single article
	-->
	<xsl:template match="ARTICLEMEMBER" mode="c_issue">
		<xsl:choose>
			<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_type']/VALUE = '1'">
				<xsl:if test="EXTRAINFO/TYPE/@ID = '1' or not(EXTRAINFO)">
					<xsl:apply-templates select="." mode="r_issue"/>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<xsl:if test="(EXTRAINFO/TYPE/@ID = '1' or not(EXTRAINFO)) and count(preceding-sibling::ARTICLEMEMBER[EXTRAINFO/TYPE/@ID = '1' or not(EXTRAINFO)]) &lt; $articlemaxlength">
					<xsl:apply-templates select="." mode="r_issue"/>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="ARTICLEMEMBER" mode="r_issue">
	Author:		Tom Whitehouse
	Context:       /H2G2/HIERARCHYDETAILS/MEMBERS
	Purpose:      Creates a link to an article
	-->
	<xsl:template match="ARTICLEMEMBER" mode="r_issue">
		<a href="{$root}A{H2G2ID}" xsl:use-attribute-sets="mARTICLEMEMBER_r_issue">
			<xsl:value-of select="NAME"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="MEMBERS" mode="c_morearticles">
	Author:		Andy Harris
	Context:       /H2G2/HIERARCHYDETAILS/MEMBERS
	Purpose:      Checks the length of the articles list and presents the 'See more articles' link if necessary
	-->
	<xsl:template match="MEMBERS" mode="c_morearticles">
		<xsl:if test="(count(ARTICLEMEMBER[EXTRAINFO/TYPE/@ID = '1' or not(EXTRAINFO)]) &gt; $articlemaxlength) and not(/H2G2/PARAMS/PARAM[NAME = 's_type']/VALUE = '1')">
			<xsl:apply-templates select="." mode="r_morearticles"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="MEMBERS" mode="r_morearticles">
	Author:		Andy Harris
	Context:       /H2G2/HIERARCHYDETAILS/MEMBERS
	Purpose:      Creates the 'See more articles' link
	-->
	<xsl:template match="MEMBERS" mode="r_morearticles">
		<a href="{$root}C{../@NODEID}?s_type=1">
			<xsl:copy-of select="$m_morearticles"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="ANCESTRY" mode="c_issue">
	Author:		Tom Whitehouse
	Context:       /H2G2/HIERARCHYDETAILS
	Purpose:      Creates the container holding the crumbtrail
	-->
	<xsl:template match="ANCESTRY" mode="c_issue">
		<xsl:apply-templates select="." mode="r_issue"/>
	</xsl:template>
	<!--
	<xsl:template match="ANCESTOR" mode="c_issue">
	Author:		Tom Whitehouse
	Context:       /H2G2/HIERARCHYDETAILS/ANCESTRY
	Purpose:      Creates the container holding a single item within the crumbtrail
	-->
	<xsl:template match="ANCESTOR" mode="c_issue">
		<xsl:apply-templates select="." mode="r_issue"/>
	</xsl:template>
	<!--
	<xsl:template match="ANCESTOR" mode="r_issue">
	Author:		Tom Whitehouse
	Context:       /H2G2/HIERARCHYDETAILS/ANCESTRY
	Purpose:      Creates a link to another node in the taxonomy from the crumbtrail
	-->
	<xsl:template match="ANCESTOR" mode="r_issue">
		<a href="{$root}C{NODEID}" xsl:use-attribute-sets="mANCESTOR_r_issue">
			<xsl:value-of select="NAME"/>
		</a>
	</xsl:template>
	
	
	<xsl:template match="EMAIL-SUBSCRIPTION" mode="c_categorypage">
	<xsl:apply-templates select="." mode="r_categorypage"/>
	</xsl:template>
	
	<xsl:template match="EMAIL-SUBSCRIPTION" mode="c_categorysub">
		<xsl:apply-templates select="." mode="r_categorysub"/>
	</xsl:template>


<xsl:template match="EMAIL-SUBSCRIPTION" mode="c_categorysubstatus">
		<xsl:choose>
			<xsl:when test="SUBSCRIPTION[@ITEMTYPE = 1]">
				<xsl:apply-templates select="." mode="on_categorysubstatus"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="." mode="off_categorysubstatus"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="EMAIL-SUBSCRIPTION" mode="t_categorysubstatus">
		<xsl:choose>
			<xsl:when test="SUBSCRIPTION/@LISTTYPE = 2">Normal </xsl:when>
			<xsl:otherwise> Instant </xsl:otherwise>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="SUBSCRIPTION/@NOTIFYTYPE = 1">Email</xsl:when>
			<xsl:otherwise>Private Message</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="EMAIL-SUBSCRIPTION" mode="t_categorysublink">
		<xsl:choose>
			<xsl:when test="SUBSCRIPTION[@ITEMTYPE = 1]">
				<a href="{$root}EMailAlert?s_manage=1&amp;s_itemtype=1&amp;s_itemid={/H2G2/HIERARCHYDETAILS/@NODEID}&amp;s_backto=C{/H2G2/HIERARCHYDETAILS/@NODEID}"><xsl:copy-of select="$m_categorysubmanagelink"/></a>
			</xsl:when>
			<xsl:otherwise>
				<a href="{$root}EMailAlert?s_manage=2&amp;s_itemtype=1&amp;s_itemid={/H2G2/HIERARCHYDETAILS/@NODEID}&amp;s_backto=C{/H2G2/HIERARCHYDETAILS/@NODEID}"><xsl:copy-of select="$m_categorysublink"/></a>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:variable name="m_categorysublink">
	Subscribe to Category
	</xsl:variable>
	<xsl:variable name="m_categorysubmanagelink">
	Manage Category subscription
	</xsl:variable>
	<!-- 
	************************************************************************************************************************
										POLL
	************************************************************************************************************************
	-->
	<xsl:template match="POLL" mode="c_category">
		<xsl:apply-templates select="." mode="r_category"/>
	</xsl:template>
</xsl:stylesheet>