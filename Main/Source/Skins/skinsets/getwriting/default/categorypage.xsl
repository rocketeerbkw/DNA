<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<xsl:import href="../../../base/base-categorypage.xsl"/>
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
									Page - Level  template
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->

	
	<xsl:template name="CATEGORY_MAINBODY">
	<!-- DEBUG -->
	<xsl:call-template name="TRACE">
	<xsl:with-param name="message"></xsl:with-param>
	<xsl:with-param name="pagename">categorypage.xsl</xsl:with-param>
	</xsl:call-template>
	<!-- DEBUG -->
	
	<!-- SEARCHBOX -->
	<div class="searchback">
	<table cellspacing="0" cellpadding="0" border="0">
	<tr>
	<td rowspan="2" valign="top"><xsl:copy-of select="$icon.browse.brown" /></td>
	<td colspan="4">
	<div class="heading1">
	<xsl:element name="{$text.base}" use-attribute-sets="text.base">
	Advanced Search
	</xsl:element>
	</div>
	
	<div class="searchtext">
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	Search the writing categories by keyword, user name, title or genre (e.g. poetry, scripts, etc.)
	</xsl:element>
	</div>
	</td>
	</tr>
	<tr>
	<td>
	<div class="searchtext">
	<label for="category-search">
	<xsl:element name="{$text.base}" use-attribute-sets="text.base">i am searching for:&nbsp;
	</xsl:element>
	</label>
	</div>
	</td>
	<td>
	<xsl:element name="{$text.base}" use-attribute-sets="text.base">
	<xsl:call-template name="c_search_dna" />
	</xsl:element>
	</td>
	</tr>
	</table>
	</div>

	<xsl:choose>
	   <xsl:when test="not(/H2G2/HIERARCHYDETAILS/ANCESTRY/ANCESTOR[3])">
			<xsl:apply-templates select="HIERARCHYDETAILS" mode="c_category"/>
		</xsl:when>
		<xsl:otherwise>
			<xsl:apply-templates select="HIERARCHYDETAILS" mode="c_issue"/>
		</xsl:otherwise>
	</xsl:choose>
	
		
	</xsl:template>
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
					HIERARCHYDETAILS for taxonomy page
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<!--
	<xsl:template match="HIERARCHYDETAILS" mode="r_category">
	Use: HIERARCHYDETAILS contains ancestry, displayname and member information
	 -->
	<xsl:template match="HIERARCHYDETAILS" mode="r_category">
		<xsl:element name="table" use-attribute-sets="html.table.container">
		<tr>
		<xsl:element name="td" use-attribute-sets="column.1">
		
		<div class="PageContent">
		<!-- CATEGORY HEADING -->
		<div class="heading1" id="titleSearch">
		<xsl:element name="{$text.base}" use-attribute-sets="text.base">
		Browse index
		</xsl:element>
		</div>
		<!-- CATEGORY LIST -->
		<div class="box"><xsl:apply-templates select="MEMBERS" mode="c_category"/></div>
		</div>
		
	    <!-- to must show all -->
		<!-- AZ LIST -->
		<div class="PageContent">
		<xsl:element name="{$text.base}" use-attribute-sets="text.base">
		<div class="heading1" id="titleSearch">A-Z Index</div>
		</xsl:element>
		
		<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
		<strong>BROWSE ALPHABETICALLY</strong><br/>
		Click on a letter to see all items listed alphabetically.<br/>
		</xsl:element>
		
		<div class="alphabox">
		<xsl:call-template name="alphaindex">
		<xsl:with-param name="showtype">&amp;user=on&amp;</xsl:with-param>
		</xsl:call-template>
		</div>
		
		</div>
		
	</xsl:element>
		<xsl:element name="td" use-attribute-sets="column.2">
		
		<xsl:apply-templates select="/H2G2/SITECONFIG/IMGPROMO2" />
				
		<div class="rightnavboxheader">
		<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
		SEARCH TIPS
		</xsl:element>
		</div>
		<div class="rightnavbox">
		<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
		<xsl:copy-of select="$page.search.tips" />
		</xsl:element>
		</div>
		
		<!-- DESCRIPTION GUIDEML INSERT -->
		<!-- <xsl:apply-templates select="DESCRIPTION" /> -->

		<xsl:element name="img" use-attribute-sets="column.spacer.2" />
		</xsl:element>
		</tr>
		</xsl:element>
		
	</xsl:template>
	<!--
	<xsl:template match="CLIP" mode="r_categoryclipped">
	Description: message to be displayed after clipping a category
	 -->
	<xsl:template match="CLIP" mode="r_categoryclipped">
		<b><xsl:apply-imports/></b>
		<br/>
	</xsl:template>
	<!--
	<xsl:template match="ANCESTRY" mode="r_category">
	Use: Lists the crumbtrail for the current node
	 -->
	<xsl:template match="ANCESTRY" mode="r_category">
		<xsl:apply-templates select="ANCESTOR" mode="c_category"/>
		<br/>
		<br/>
	</xsl:template>
	<!--
	<xsl:template match="ANCESTOR" mode="r_category">
	Use: One item within the crumbtrail
	 -->
	<xsl:template match="ANCESTOR" mode="r_category">
		<xsl:apply-imports/>
		<xsl:if test="following-sibling::ANCESTOR">
			<xsl:text> /</xsl:text>
		</xsl:if>
	</xsl:template>
	<!-- 
	<xsl:template match="HIERARCHYDETAILS" mode="r_clip">
	Use: presentation for the 'add to clippings' link
	-->
	<xsl:template match="HIERARCHYDETAILS" mode="r_clip">
		<xsl:apply-imports/>
		<br/>
		<br/>
	</xsl:template>
	<!--
	<xsl:template match="MEMBERS" mode="r_category">
	Use: Holder for all the members of a node
	 -->
	<xsl:template match="MEMBERS" mode="r_category">
		<!-- <xsl:apply-templates select="SUBJECTMEMBER" mode="c_category"/> -->
		<!-- <xsl:apply-templates select="ARTICLEMEMBER" mode="c_category"/> -->
		
		<xsl:element name="{$text.base}" use-attribute-sets="text.base">
		<div class="colourbar2" id="iconright">
		<a href="Index?submit=new&amp;user=on&amp;type=31&amp;type=81&amp;let=a">
		<img src="{$graphics}/icons/icon_shortfiction.gif" alt="Short Fiction" width="38" height="38" border="0" class="imageborder"/> Short Fiction</a>
		</div>
		
		<div class="colourbar1" id="iconright">
		<a href="Index?submit=new&amp;user=on&amp;type=30&amp;type=80&amp;let=a">
		<img src="{$graphics}/icons/icon_poetry.gif" alt="Poetry" width="38" height="38" border="0" class="imageborder"/>
		Poetry</a>
		</div>
		
		<div class="colourbar2" id="iconright">
		<a href="Index?submit=new&amp;user=on&amp;type=35&amp;type=85&amp;let=a">
		<img src="{$graphics}/icons/icon_forchildren.gif" alt="For Children" width="38" height="38" border="0" class="imageborder"/>
		For Children</a>
		</div>
		
		<div class="colourbar1" id="iconright">
		<a href="Index?submit=new&amp;user=on&amp;type=33&amp;type=83&amp;let=a">
		<img src="{$graphics}/icons/icon_non-fiction.gif" alt="Non-Fiction" width="38" height="38" border="0" class="imageborder"/>
		Non-Fiction</a>
		</div>
		
		<div class="colourbar2" id="iconright">
		<a href="Index?submit=new&amp;user=on&amp;type=34&amp;type=84&amp;let=a">
		<img src="{$graphics}/icons/icon_dramascripts.gif" alt="Drama Scripts" width="38" height="38" border="0" class="imageborder"/>
		Drama Scripts</a>
		</div>
		
		<div class="colourbar1" id="iconright">
		<a href="Index?submit=new&amp;user=on&amp;type=32&amp;type=82&amp;let=a">
		<img src="{$graphics}/icons/icon_extendedwork.gif" alt="Extended Work" width="38" height="38" border="0" class="imageborder"/>
		Extended Work</a>
		</div>
		
		<div class="colourbar2" id="iconright">
		<a href="Index?submit=new&amp;user=on&amp;type=36&amp;type=86&amp;let=a">
		<img src="{$graphics}/icons/icon_scififantasy.gif" alt="Sci-Fi &amp; Fantasy" width="38" height="38" border="0" class="imageborder"/>
		Sci-Fi &amp; Fantasy</a>
		</div>
		
		<div class="colourbar1" id="iconright">
		<a href="Index?submit=new&amp;user=on&amp;type=37&amp;type=87&amp;let=a">
		<img src="{$graphics}/icons/icon_crimethriller.gif" alt="Crime &amp; Thriller" width="38" height="38" border="0" class="imageborder"/>
		Crime &amp; Thriller</a>
		</div>
		
		<div class="colourbar2" id="iconright">
		<a href="Index?submit=new&amp;user=on&amp;type=38&amp;type=88&amp;let=a">
		<img src="{$graphics}/icons/icon_comedyscripts.gif" alt="Comedy Scripts" width="38" height="38" border="0" class="imageborder"/>
		Comedy Scripts</a>
		</div>
		
		<div class="colourbar1" id="iconright">
		<a href="Index?submit=new&amp;user=on&amp;type=41&amp;let=all">
		<img src="{$graphics}/icons/icon_advice.gif" alt="Advice" width="38" height="38" border="0" class="imageborder"/>
		 Advice</a>
		</div>
		
		<div class="colourbar2" id="iconright">
		<a href="Index?submit=new&amp;user=on&amp;type=42&amp;let=all">
		<img src="{$graphics}/icons/icon_challenges.gif" alt="Challenges" width="38" height="38" border="0" class="imageborder"/> Challenges</a>
		</div>
		
		</xsl:element>
		<xsl:apply-templates select="NODEALIASMEMBER" mode="c_category"/>
		<xsl:apply-templates select="CLUBMEMBER" mode="c_category"/>
	</xsl:template>
	<!--
	<xsl:template match="SUBJECTMEMBER" mode="r_category">
	Use: Presentation of a node if it is a subject (contains other nodes)
	 -->
	<xsl:template match="SUBJECTMEMBER" mode="r_category">
		<div class="colourbar1">
		<xsl:element name="{$text.base}" use-attribute-sets="text.base">
		<strong><xsl:apply-templates select="NAME" mode="t_nodename"/></strong>
		</xsl:element>
		<!-- <xsl:apply-templates select="NODECOUNT" mode="c_subject"/> -->
		</div>
		<!-- <xsl:apply-templates select="SUBNODES" mode="c_category"/> -->
	</xsl:template>
	<!--
	<xsl:template match="SUBNODES" mode="r_category">
	Use: Presentation of the subnodes logical container
	 -->
	<xsl:template match="SUBNODES" mode="r_category">
		<xsl:apply-templates select="SUBNODE" mode="c_subnodename"/>
	</xsl:template>
	<!--
	<xsl:template match="SUBNODE" mode="r_subnodename">
	Use: Presenttaion of a subnode, ie the contents of a SUBJECTMEMBER node
	 -->
	<xsl:template match="SUBNODE" mode="r_subnodename">
			<xsl:apply-imports/>
			<xsl:text>, </xsl:text>
	</xsl:template>
	<!--
	<xsl:template match="NODECOUNT" mode="zero_category">
	Use: Used if a SUBJECTMEMBER has 0 nodes contained in it
	 -->
	<xsl:template match="NODECOUNT" mode="zero_subject">
		<xsl:value-of select="$m_nomembers"/>
	</xsl:template>
	<!--
	<xsl:template match="NODECOUNT" mode="one_category">
	Use: Used if a SUBJECTMEMBER has 1 node contained in it
	 -->
	<xsl:template match="NODECOUNT" mode="one_subject">
		1<xsl:value-of select="$m_member"/>
	</xsl:template>
	<!--
	<xsl:template match="NODECOUNT" mode="many_category">
	Use: Used if a SUBJECTMEMBER has more than 1 nodes contained in it
	 -->
	<xsl:template match="NODECOUNT" mode="many_subject">
		<xsl:apply-imports/>
		<xsl:value-of select="$m_members"/>
	</xsl:template>
	<!--
	<xsl:template match="ARTICLEMEMBER" mode="r_category">
	Use: Presentation of an node if it is an article
	 -->
	<xsl:template match="ARTICLEMEMBER" mode="r_category">
		<xsl:apply-imports/>
		<br/>
	</xsl:template>
	<!--
	<xsl:template match="NODEALIASMEMBER" mode="r_category">
	Use: Presentation of a node if it is a nodealias
	 -->
	<xsl:template match="NODEALIASMEMBER" mode="r_category">
		<xsl:apply-templates select="NAME" mode="t_nodealiasname"/>
		<xsl:apply-templates select="NODECOUNT" mode="c_nodealias"/>
		<xsl:if test="SUBNODES/SUBNODE">
			<br/>
		</xsl:if>
		<xsl:apply-templates select="SUBNODES" mode="c_category"/>
		<br/>
		<br/>
	</xsl:template>
	<!--
	<xsl:template match="NODEALIASMEMBER" mode="zero_category">
	Use: Used if a NODEALIASMEMBER has 0 nodes contained in it
	 -->
	<xsl:template match="NODEALIASMEMBER/NODECOUNT" mode="zero_nodealias">
		[<xsl:value-of select="$m_nomembers"/>]
	</xsl:template>
	<!--
	<xsl:template match="NODEALIASMEMBER" mode="one_category">
	Use: Used if a NODEALIASMEMBER has 1 node contained in it
	 -->
	<xsl:template match="NODEALIASMEMBER/NODECOUNT" mode="one_nodealias">
		[1<xsl:value-of select="$m_member"/>]
	</xsl:template>
	<!--
	<xsl:template match="NODEALIASMEMBER" mode="many_category">
	Use: Used if a NODEALIASMEMBER has more than 1 nodes contained in it
	 -->
	<xsl:template match="NODEALIASMEMBER/NODECOUNT" mode="many_nodealias">
		[<xsl:apply-imports/>
		<xsl:value-of select="$m_members"/>]
	</xsl:template>
	<!--
	<xsl:template match="CLUBMEMBER" mode="r_category">
	Use: Presentation of a node if it is a club
	 -->
	<xsl:template match="CLUBMEMBER" mode="r_category">
		<xsl:apply-templates select="NAME" mode="t_clubname"/>
		<xsl:apply-templates select="EXTRAINFO/DESCRIPTION" mode="c_clubdescription"/>
	</xsl:template>
	<!--
	<xsl:template match="DESCRIPTION" mode="r_clubdesription">
	Use: Presentation of the club's description
	 -->
	<xsl:template match="DESCRIPTION" mode="r_clubdesription">
		<xsl:apply-templates/>
	</xsl:template>
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
					HIERARCHYDETAILS for issue page
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<!--
	<xsl:template match="HIERARCHYDETAILS" mode="r_issue">
	Use: HIERARCHYDETAILS container used if the taxonomy is at a particular depth
	 -->
	<xsl:template match="HIERARCHYDETAILS" mode="r_issue">
		<xsl:apply-templates select="/H2G2/CLIP" mode="c_issueclipped"/>
		<xsl:apply-templates select="ANCESTRY" mode="c_issue"/>
		
			<b>
				<xsl:value-of select="DISPLAYNAME"/>
			</b>
		
		<br/>
		<xsl:apply-templates select="." mode="c_clipissue"/>
		<br/>
		<b>
			<xsl:copy-of select="$m_catpagememberstitle"/>
		</b>
		<br/>
		<xsl:apply-templates select="MEMBERS" mode="c_numberofclubs"/>
		<br/>
		<xsl:apply-templates select="MEMBERS" mode="c_numberofarticles"/>
		<br/>
		<xsl:apply-templates select="MEMBERS" mode="c_subjectmembers"/>
		<br/>
		<xsl:apply-templates select="MEMBERS" mode="c_nodealiasmembers"/>
		<br/>
		<xsl:apply-templates select="MEMBERS" mode="c_clubmembers"/>
		<br/>
		<xsl:apply-templates select="MEMBERS" mode="c_articlemembers"/>
	</xsl:template>
	<!--
	<xsl:template match="CLIP" mode="r_issueclipped">
	Description: message to be displayed after clipping an issue
	 -->
	<xsl:template match="CLIP" mode="r_issueclipped">
		<b>
			<xsl:apply-imports/>
		</b>
		<br/>
	</xsl:template>
	<!-- 
	<xsl:template match="HIERARCHYDETAILS" mode="r_clipissue">
	Use: presentation for the 'add to clippings' link
	-->
	<xsl:template match="HIERARCHYDETAILS" mode="r_clipissue">
		<xsl:apply-imports/>
		<br/>
		<br/>
	</xsl:template>
	<!--
	<xsl:template match="ANCESTRY" mode="r_issue">
	Use: Lists the crumbtrail for the current node
	 -->
	<xsl:template match="ANCESTRY" mode="r_issue">
		<xsl:apply-templates select="ANCESTOR" mode="c_issue"/>
		<br/>
		<br/>
	</xsl:template>
	<!--
	<xsl:template match="ANCESTOR" mode="r_issue">
	Use: One item within the crumbtrail
	 -->
	<xsl:template match="ANCESTOR" mode="r_issue">
		<xsl:apply-imports/>
		<xsl:if test="following-sibling::ANCESTOR">
			<xsl:text> /</xsl:text>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="MEMBERS" mode="r_numberofclubs">
	Use: container for displaying the number of clubs there are in a node
	 -->
	<xsl:template match="MEMBERS" mode="r_numberofclubs">
		<xsl:copy-of select="$m_numberofclubstext"/>
		 [<xsl:apply-imports/>]
	</xsl:template>
	<!--
	<xsl:template match="MEMBERS" mode="r_numberofarticles">
	Use: container for displaying the number of articles there are in a node
	 -->
	<xsl:template match="MEMBERS" mode="r_numberofarticles">
		<xsl:copy-of select="$m_numberofarticlestext"/>
		[<xsl:apply-imports/>]
	</xsl:template>
	<!--
	<xsl:template match="MEMBERS" mode="r_subjectmembers">
	Use: Logical container for all subject members
	 -->
	<xsl:template match="MEMBERS" mode="r_subjectmembers">
		<xsl:copy-of select="$m_subjectmemberstitle"/>
		<xsl:apply-templates select="SUBJECTMEMBER" mode="c_issue"/>
	</xsl:template>
	<!--
	<xsl:template match="SUBJECTMEMBER" mode="r_issue">
	Use: display of a single subject member within the above logical container
	 -->
	<xsl:template match="SUBJECTMEMBER" mode="r_issue">
		<xsl:apply-imports/>
		<xsl:if test="following-sibling::SUBJECTMEMBER">
			<xsl:text>, </xsl:text>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="MEMBERS" mode="r_nodealiasmembers">
	Use: Logical container for all subject members
	 -->
	<xsl:template match="MEMBERS" mode="r_nodealiasmembers">
		<xsl:apply-templates select="NODEALIASMEMBER" mode="c_issue"/>
	</xsl:template>
	<!--
	<xsl:template match="NODEALIASMEMBER" mode="r_issue">
	Use: display of a single subject member within the above logical container
	 -->
	<xsl:template match="NODEALIASMEMBER" mode="r_issue">
		<xsl:apply-imports/>
		<xsl:if test="following-sibling::NODEALIASMEMBER">
			<xsl:text>, </xsl:text>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="MEMBERS" mode="short_clubmembers">
	Use: Logical container for all club members
	 -->
	<xsl:variable name="clubmaxlength">1</xsl:variable>
	<xsl:template match="MEMBERS" mode="short_clubmembers">
		<b>
			<xsl:copy-of select="$m_clubmemberstitle"/>
		</b>
		<br/>
		<xsl:apply-templates select="CLUBMEMBER" mode="c_issue"/>
		<xsl:apply-templates select="." mode="c_moreclubs"/>
		<br/>
	</xsl:template>
	<!--
	<xsl:template match="MEMBERS" mode="full_clubmembers">
	Use: Logical container for all club members
	 -->
	<xsl:template match="MEMBERS" mode="full_clubmembers">
		<b>
			<xsl:copy-of select="$m_clubmemberstitle"/>
		</b>
		<br/>
		<xsl:apply-templates select="CLUBMEMBER" mode="c_issue"/>
		<br/>
	</xsl:template>
	<!--
	<xsl:template match="CLUBMEMBER" mode="r_issue">
	Use: Display of a single club member within the above logical container
	 -->
	<xsl:template match="CLUBMEMBER" mode="r_issue">
		<xsl:apply-templates select="." mode="t_clubname"/>
		<br/>
		<xsl:apply-templates select="." mode="t_clubdescription"/>
		<br/>
		<br/>
	</xsl:template>
	<!--
	<xsl:template match="MEMBERS" mode="short_articlemembers">
	Use: Logical container for shortened list of article members
	 -->
	<xsl:variable name="articlemaxlength">3</xsl:variable>
	<xsl:template match="MEMBERS" mode="short_articlemembers">
		<b>
			<xsl:copy-of select="$m_articlememberstitle"/>
		</b>
		<br/>
		<xsl:apply-templates select="ARTICLEMEMBER" mode="c_issue"/>
		<xsl:apply-templates select="." mode="c_morearticles"/>
	</xsl:template>
	<!--
	<xsl:template match="MEMBERS" mode="full_articlemembers">
	Use: Logical container for all article members
	 -->
	<xsl:template match="MEMBERS" mode="full_articlemembers">
		<b>
			<xsl:copy-of select="$m_articlememberstitle"/>
		</b>
		<br/>
		<xsl:apply-templates select="ARTICLEMEMBER" mode="c_issue"/>
	</xsl:template>
	<!--
	<xsl:template match="ARTICLEMEMBER" mode="r_issue">
	Use: Display of a single article container within the above logical container
	 -->
	<xsl:template match="ARTICLEMEMBER" mode="r_issue">
		<xsl:apply-imports/>
		<br/>
	</xsl:template>
</xsl:stylesheet>
