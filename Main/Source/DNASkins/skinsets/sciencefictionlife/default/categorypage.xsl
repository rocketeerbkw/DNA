<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<xsl:import href="../../../base/base-categorypage.xsl"/>



	<xsl:template name="CATEGORY_HEADER">
		<xsl:apply-templates mode="header" select=".">
			<xsl:with-param name="title">
				<xsl:value-of select="$m_pagetitlestart"/>
				<!-- <xsl:value-of select="$m_browsetheguide"/> -->
				<xsl:value-of select="/H2G2/HIERARCHYDETAILS/DISPLAYNAME"/>
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>

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
		<xsl:with-param name="message">CATEGORY_MAINBODY</xsl:with-param>
		<xsl:with-param name="pagename">categorypage.xsl</xsl:with-param>
		</xsl:call-template>
		<!-- DEBUG -->
		
	
		<xsl:choose>
			<xsl:when test="not(/H2G2/HIERARCHYDETAILS/ANCESTRY/ANCESTOR[2])">
			<!-- top level index : list all sub categories for main category -->
				<xsl:apply-templates select="HIERARCHYDETAILS" mode="c_category"/>

			</xsl:when>
			<xsl:otherwise>
			<!-- 2nd level index : show all articles in certain category -->
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
		<h1 class="directory"><xsl:value-of select="DISPLAYNAME"/></h1>
		
		<xsl:apply-templates select="MEMBERS" mode="c_category"/>

		<!-- search panel 
		<h2 id="search">or search</h2>
		<form method="get" action="{$root}Search" xsl:use-attribute-sets="fc_search_dna" name="filmindexsearch" id="filmindexsearch" >
			<table width="635" border="0" cellspacing="0" cellpadding="0">
			  <tr> 
				<td width="98" height="96" align="right" valign="top" class="webboxbg">
				<img src="{$imagesource}furniture/directory/search.gif" width="75" height="75" alt="Search icon" id="searchIcon"/></td>
				<td width="465" valign="top" class="webboxbg">
				<div class="searchline">I am looking for</div>
				<div class="searchback"><xsl:call-template name="r_search_dna2" />&nbsp;&nbsp;<input type="image" name="dosearch" src="{$imagesource}furniture/directory/search1.gif" alt="search" /></div></td>
				<td width="72" valign="top" class="webboxbg"><img src="{$imagesource}furniture/filmindex/angle.gif" width="72" height="39" alt="" /></td>
			  </tr>
			</table>
		</form>	
		-->
	</xsl:template>


	<!--
	<xsl:template match="CLIP" mode="r_categoryclipped">
	Description: message to be displayed after clipping a category
	 -->
	<xsl:template match="CLIP" mode="r_categoryclipped">
		<b>
			<xsl:apply-imports/>
		</b>
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
		<xsl:apply-templates select="SUBJECTMEMBER[NODEID = $byMediaPage]" mode="c_category"/> 
		<xsl:apply-templates select="SUBJECTMEMBER[NODEID = $byThemePage]" mode="c_category"/>
		<xsl:apply-templates select="SUBJECTMEMBER[NODEID = $byDatePage]" mode="c_category"/>
		
		<!-- v3 COMMENTED OUT FOR NOW, NEED TO INVESTIGATE TEMPLATES
		<xsl:apply-templates select="ARTICLEMEMBER" mode="c_category"/>
		<xsl:apply-templates select="NODEALIASMEMBER" mode="c_category"/>
		<xsl:apply-templates select="CLUBMEMBER" mode="c_category"/>
		-->

	</xsl:template>
	<!--
	<xsl:template match="SUBJECTMEMBER" mode="r_category">
	Use: Presentation of a node if it is a subject (contains other nodes)
	 -->
	<xsl:template match="SUBJECTMEMBER" mode="r_category">

		<table width="635" border="0" cellspacing="0" cellpadding="0" class="directoryItem">
		  <tr> 
			<td valign="top">
			<!-- v3 cat SUB CATEGORY HEADERS -->
				<h2>
					<xsl:choose>
						<xsl:when test="$byMediaPage = NODEID">Format</xsl:when>
						<xsl:when test="$byThemePage = NODEID">Themes</xsl:when>
						<xsl:when test="$byDatePage = NODEID">Timeline</xsl:when>						
					</xsl:choose>
				</h2>
				
				<!-- v3 cat DISPLAY LISTING OF SUB CATEGORIES -->
				<xsl:apply-templates select="SUBNODES" mode="c_category"/>
					
			</td>
		  </tr>
		</table>
		
	</xsl:template>



	<!--
	<xsl:template match="NAME" mode="t_nodename">
	Author:		Trent
	Context:       /H2G2/HIERARCHYDETAILS/MEMBERS/SUBJECTMEMBER
	Purpose:      subject name no link, was using terminal template before
	-->
	<xsl:template match="NAME" mode="r_nodename">
		<!-- <a href="{$root}C{../NODEID}" xsl:use-attribute-sets="mNAME_t_nodename"> -->
			<h3><xsl:value-of select="."/></h3>
		<!-- </a> -->
	</xsl:template>

	
	<!--
	<xsl:template match="SUBNODES" mode="r_category">
	Use: Presentation of the subnodes logical container
	 -->
	<xsl:template match="SUBNODES" mode="r_category">
		<!-- Need to work out an elegant way of doing this -->

		<xsl:variable name="numberOfSubnodes" select="count(child::SUBNODE)"/>
		<xsl:value-of select="'&lt;table border=0 cellspacing=1 cellpadding=0&gt;'" disable-output-escaping="yes"/>
			<xsl:for-each select="SUBNODE">
			<xsl:sort/>
				<xsl:if test="position() mod 3 = 1">
					<xsl:choose>
						<xsl:when test="position() = $numberOfSubnodes">
						<xsl:value-of select="'&lt;tr&gt;'" disable-output-escaping="yes"/>
							<xsl:value-of select="'&lt;td width=187&gt;'" disable-output-escaping="yes"/><xsl:apply-templates select="." mode="r_category"/><xsl:value-of select="'&lt;/td&gt;'" disable-output-escaping="yes"/> 
							<xsl:value-of select="'&lt;td width=187&gt;'" disable-output-escaping="yes"/><xsl:value-of select="'&lt;/td&gt;'" disable-output-escaping="yes"/>
							<xsl:value-of select="'&lt;td width=187&gt;'" disable-output-escaping="yes"/><xsl:value-of select="'&lt;/td&gt;'" disable-output-escaping="yes"/>
						<xsl:value-of select="'&lt;/tr&gt;'" disable-output-escaping="yes"/>
						</xsl:when>
						<xsl:otherwise>
						<xsl:value-of select="'&lt;tr&gt;'" disable-output-escaping="yes"/>
							<xsl:value-of select="'&lt;td width=187&gt;'" disable-output-escaping="yes"/><xsl:apply-templates select="." mode="r_category"/><xsl:value-of select="'&lt;/td&gt;'" disable-output-escaping="yes"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
				<xsl:if test="position() mod 3 = 2">
					<xsl:choose>
						<xsl:when test="position() = $numberOfSubnodes">
							<xsl:value-of select="'&lt;td width=187&gt;'" disable-output-escaping="yes"/><xsl:apply-templates select="." mode="r_category"/><xsl:value-of select="'&lt;/td&gt;'" disable-output-escaping="yes"/>
							<xsl:value-of select="'&lt;td width=187&gt;'" disable-output-escaping="yes"/><xsl:value-of select="'&lt;/td&gt;'" disable-output-escaping="yes"/>
						<xsl:value-of select="'&lt;/tr&gt;'" disable-output-escaping="yes"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="'&lt;td width=187&gt;'" disable-output-escaping="yes"/><xsl:apply-templates select="." mode="r_category"/><xsl:value-of select="'&lt;/td&gt;'" disable-output-escaping="yes"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
				<xsl:if test="position() mod 3 = 0">
						<xsl:value-of select="'&lt;td width=187&gt;'" disable-output-escaping="yes"/><xsl:apply-templates select="." mode="r_category"/><xsl:value-of select="'&lt;/td&gt;'" disable-output-escaping="yes"/>
					<xsl:value-of select="'&lt;/tr&gt;'" disable-output-escaping="yes"/>
				</xsl:if>
			</xsl:for-each>
		<xsl:value-of select="'&lt;/table&gt;'" disable-output-escaping="yes"/>
		
	</xsl:template>
	

	<!--
	<xsl:template match="SUBNODE" mode="r_subnodename">
	Use: Presenttaion of a subnode, ie the contents of a SUBJECTMEMBER node
	 -->
	 <xsl:template match="SUBNODE" mode="r_category">
		<a href="{$root}C{@ID}">
			<xsl:value-of select="."/>
		</a>
	</xsl:template>
	 	 
	<xsl:template name="menu_items">
				
		<a href="{$root}C{@ID}" xsl:use-attribute-sets="mSUBNODE_r_subnodename">
			<xsl:value-of select="."/>
		</a>
		<xsl:if test="following-sibling::*[1][local-name()= 'SUBNODE'] ">  
			<xsl:text>&nbsp;&nbsp;|&nbsp;&nbsp;</xsl:text>
		</xsl:if>

	</xsl:template>


	<!--
	<xsl:template match="NODECOUNT" mode="zero_category">
	Use: Used if a SUBJECTMEMBER has 0 nodes contained in it
	 -->
	<xsl:template match="NODECOUNT" mode="zero_subject">
		[<xsl:value-of select="$m_nomembers"/>]
	</xsl:template>
	<!--
	<xsl:template match="NODECOUNT" mode="one_category">
	Use: Used if a SUBJECTMEMBER has 1 node contained in it
	 -->
	<xsl:template match="NODECOUNT" mode="one_subject">
		[1<xsl:value-of select="$m_member"/>]
	</xsl:template>
	<!--
	<xsl:template match="NODECOUNT" mode="many_category">
	Use: Used if a SUBJECTMEMBER has more than 1 nodes contained in it
	 -->
	<xsl:template match="NODECOUNT" mode="many_subject">
		[<xsl:apply-imports/>
		<xsl:value-of select="$m_members"/>]
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
		
		<div class="middletop">
			<h1>
				<xsl:choose>
					<xsl:when test="ANCESTRY/ANCESTOR[3]/NODEID = $byMediaPage">
						Search by Format
					</xsl:when>
					<xsl:when test="ANCESTRY/ANCESTOR[3]/NODEID = $byThemePage">
						Search by Theme
					</xsl:when>
					<xsl:when test="ANCESTRY/ANCESTOR[3]/NODEID = $byDatePage">
						Timeline
					</xsl:when>
				</xsl:choose>
			</h1>
			<div class="vspace10px"> </div>
			<!-- SC --><!-- REMOVED: Intro text -->
			<!-- <p><xsl:copy-of select="DESCRIPTION" /></p>   --> 

		</div>

		<!-- NAVIGATION -->
		<p class="middlenav">
		<xsl:choose>
				<xsl:when test="ANCESTRY/ANCESTOR[3]/NODEID = $byMediaPage">

					<xsl:choose>
						<xsl:when test="@NODEID = $mediaBook">
							Books
						</xsl:when>
						<xsl:otherwise>
							<a href="{$root}C{$mediaBook}">Books</a>
						</xsl:otherwise>
					</xsl:choose>

					|
					
					<xsl:choose>
						<xsl:when test="@NODEID = $mediaComic">
							Comics
						</xsl:when>
						<xsl:otherwise>
							<a href="{$root}C{$mediaComic}">Comics</a>
						</xsl:otherwise>
					</xsl:choose>

					|

					<xsl:choose>
						<xsl:when test="@NODEID = $mediaFilm">
							Film
						</xsl:when>
						<xsl:otherwise>
							<a href="{$root}C{$mediaFilm}">Film</a>
						</xsl:otherwise>
					</xsl:choose>

					|

					<xsl:choose>
						<xsl:when test="@NODEID = $mediaRadio">
							Radio
						</xsl:when>
						<xsl:otherwise>
							<a href="{$root}C{$mediaRadio}">Radio</a>
						</xsl:otherwise>
					</xsl:choose>

					|

					<xsl:choose>
						<xsl:when test="@NODEID = $mediaTV">
							TV
						</xsl:when>
						<xsl:otherwise>
							<a href="{$root}C{$mediaTV}">TV</a>
						</xsl:otherwise>
					</xsl:choose>

					|

					<xsl:choose>
						<xsl:when test="@NODEID = $mediaOther">
							Other
						</xsl:when>
						<xsl:otherwise>
							<a href="{$root}C{$mediaOther}">Other</a>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:when test="ANCESTRY/ANCESTOR[3]/NODEID = $byThemePage">

					<xsl:choose>
						<xsl:when test="@NODEID = $themeCatastrophe">
							Catastrophe
						</xsl:when>
						<xsl:otherwise>
							<a href="{$root}C{$themeCatastrophe}">Catastrophe</a>
						</xsl:otherwise>
					</xsl:choose>

					|

					<xsl:choose>
						<xsl:when test="@NODEID = $themeDystopia">
							Dystopia
						</xsl:when>
						<xsl:otherwise>
							<a href="{$root}C{$themeDystopia}">Dystopia</a>
						</xsl:otherwise>
					</xsl:choose>

					|

					<xsl:choose>
						<xsl:when test="@NODEID = $themeEvolution">
							Evolution
						</xsl:when>
						<xsl:otherwise>
							<a href="{$root}C{$themeEvolution}">Evolution</a>
						</xsl:otherwise>
					</xsl:choose>

					|

					<xsl:choose>
						<xsl:when test="@NODEID = $themeOrigins">
							Origins &amp; Development
						</xsl:when>
						<xsl:otherwise>
							<a href="{$root}C{$themeOrigins}">Origins &amp; Development</a>
						</xsl:otherwise>
					</xsl:choose>

					|

					<xsl:choose>
						<xsl:when test="@NODEID = $themeReligion">
							Religion
						</xsl:when>
						<xsl:otherwise>
							<a href="{$root}C{$themeReligion}">Religion</a>
						</xsl:otherwise>
					</xsl:choose>

					|

					<xsl:choose>
						<xsl:when test="@NODEID = $themeSex">
							Sex
						</xsl:when>
						<xsl:otherwise>
							<a href="{$root}C{$themeSex}">Sex</a>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:when test="ANCESTRY/ANCESTOR[3]/NODEID = $byDatePage">

					<xsl:choose>
						<xsl:when test="@NODEID = $dateTo1930">
							To 1930
						</xsl:when>
						<xsl:otherwise>
							<a href="{$root}C{$dateTo1930}">To 1930</a>
						</xsl:otherwise>
					</xsl:choose>

					|

					<xsl:choose>
						<xsl:when test="@NODEID = $date1930s">
							1930s
						</xsl:when>
						<xsl:otherwise>
							<a href="{$root}C{$date1930s}">1930s</a>
						</xsl:otherwise>
					</xsl:choose>

					|

					<xsl:choose>
						<xsl:when test="@NODEID = $date1940s">
							1940s
						</xsl:when>
						<xsl:otherwise>
							<a href="{$root}C{$date1940s}">1940s</a>
						</xsl:otherwise>
					</xsl:choose>

					|

					<xsl:choose>
						<xsl:when test="@NODEID = $date1950s">
							1950s
						</xsl:when>
						<xsl:otherwise>
							<a href="{$root}C{$date1950s}">1950s</a>
						</xsl:otherwise>
					</xsl:choose>

					|

					<xsl:choose>
						<xsl:when test="@NODEID = $date1960s">
							1960s
						</xsl:when>
						<xsl:otherwise>
							<a href="{$root}C{$date1960s}">1960s</a>
						</xsl:otherwise>
					</xsl:choose>

					|

					<xsl:choose>
						<xsl:when test="@NODEID = $date1970s">
							1970s
						</xsl:when>
						<xsl:otherwise>
							<a href="{$root}C{$date1970s}">1970s</a>
						</xsl:otherwise>
					</xsl:choose>

					|

					<xsl:choose>
						<xsl:when test="@NODEID = $date1980s">
							1980s
						</xsl:when>
						<xsl:otherwise>
							<a href="{$root}C{$date1980s}">1980s</a>
						</xsl:otherwise>
					</xsl:choose>

					|

					<xsl:choose>
						<xsl:when test="@NODEID = $date1990s">
							1990s
						</xsl:when>
						<xsl:otherwise>
							<a href="{$root}C{$date1990s}">1990s</a>
						</xsl:otherwise>
					</xsl:choose>

					|

					<xsl:choose>
						<xsl:when test="@NODEID = $date2000s">
							2000s
						</xsl:when>
						<xsl:otherwise>
							<a href="{$root}C{$date2000s}">2000s</a>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
			</xsl:choose>
		</p>
		
		<div id="books">
			<h2>
				<xsl:choose>
					<xsl:when test="/H2G2/HIERARCHYDETAILS/DISPLAYNAME = 'Book'">Books</xsl:when>
					<xsl:when test="/H2G2/HIERARCHYDETAILS/DISPLAYNAME = 'Comic'">Comics</xsl:when>
					<xsl:when test="/H2G2/HIERARCHYDETAILS/DISPLAYNAME = 'Film'">Films</xsl:when>
					<xsl:when test="/H2G2/HIERARCHYDETAILS/DISPLAYNAME = 'Radio'">Radio</xsl:when>
					<xsl:when test="/H2G2/HIERARCHYDETAILS/DISPLAYNAME = 'TV'">TV</xsl:when>
					<xsl:when test="/H2G2/HIERARCHYDETAILS/DISPLAYNAME = 'Other'">Other</xsl:when>
					<xsl:otherwise><xsl:value-of select="DISPLAYNAME"/></xsl:otherwise>
				</xsl:choose>
			</h2>
			
			<table>
			<xsl:choose>
				<xsl:when test="count(MEMBERS/ARTICLEMEMBER) &gt; 0">
					<xsl:apply-templates select="MEMBERS" mode="c_articlemembers"/>
				</xsl:when>
				<xsl:otherwise>
					<div>There are currently no entries under <strong><xsl:value-of select="DISPLAYNAME" /></strong><br /><br /></div>
				</xsl:otherwise>
			</xsl:choose>
			</table>
		</div>

		 <div id="booksbottom"></div>
		
		<xsl:if test="$DEBUG = 1 or /H2G2/PARAMS/PARAM[NAME = 's_debug']/VALUE = '1'">
			<div class="debug">
				<table cellpadding="0" cellspacing="0" border="1" style="font-size:100%;">
					<tr>
						<th>position()</th>
						<th>NAME</th>
						<th>type</th>
						<th>status</th>
						<th>date</th>
					</tr>
					<xsl:for-each select="MEMBERS/ARTICLEMEMBER">
					<tr>
						<td><xsl:value-of select="position()"/></td>
						<td><a href="{$root}A{H2G2ID}"><xsl:value-of select="NAME" /></a></td>
						<td><xsl:value-of select="EXTRAINFO/TYPE/@ID" /></td>
						<td><xsl:value-of select="STATUS/@TYPE" /></td>
						<td><xsl:value-of select="DATECREATED/DATE/@DAY" />&nbsp;<xsl:value-of select="DATECREATED/DATE/@MONTHNAME" />&nbsp;<xsl:value-of select="DATECREATED/DATE/@YEAR" /><xsl:text> </xsl:text><xsl:value-of select="DATECREATED/DATE/@HOURS" />:<xsl:value-of select="DATECREATED/DATE/@MINUTES" />:<xsl:value-of select="DATEPOSTED/DATE/@SECONDS" /></td>
					</tr>
					</xsl:for-each>
				</table>
			</div>
		</xsl:if>
					
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
		<!-- <a href="{$root}C{NODEID}" xsl:use-attribute-sets="mSUBJECTMEMBER_r_issue">
			<xsl:value-of select="NAME"/>
		</a> -->
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

	<!-- pagination length set below   set to 1000 as it was reauested to be removed, figure 1000 ahould do it -->
	<xsl:variable name="category_max_length">1000</xsl:variable>
	<xsl:variable name="cat_skipto">
	<xsl:choose>
		<xsl:when test="/H2G2/PARAMS/PARAM[NAME= 's_skipto']/VALUE &gt; 0">
			<xsl:value-of select="/H2G2/PARAMS/PARAM[NAME= 's_skipto']/VALUE" />
		</xsl:when>
		<xsl:otherwise>
			0
		</xsl:otherwise>
	</xsl:choose>
	</xsl:variable>

													<!-- v3 cat CONTAINS AND SORTS LIST OF ARTICLES -->
	<xsl:template match="MEMBERS" mode="short_articlemembers">
		
		<!-- v3 cat SORT BY ARTICLE TITLE -->
		<xsl:apply-templates select="ARTICLEMEMBER[STATUS/@TYPE = '1']" mode="r_issue">
			<xsl:sort select="NAME" data-type="text"/>				
		</xsl:apply-templates>	
		
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
		<xsl:apply-templates select="ARTICLEMEMBER" mode="r_issue"/>
	</xsl:template>
	
	
	<xsl:template name="newStatus">
		<xsl:param name="thisPosition" />
		<xsl:if test="$thisPosition &lt; 5">
			&nbsp;<span class="alert">NEW</span>
		</xsl:if>
	</xsl:template>

													<!-- v3 cat INDIVIDUAL ARTICLE ITEM -->
	<!--
	<xsl:template match="ARTICLEMEMBER" mode="r_issue">
	Use: Display of a single article container within the above logical container
	 -->
	<xsl:template match="ARTICLEMEMBER" mode="r_issue">

		<!-- v3 cat NEED TO ADD MOD 2 TO TURN CLASS ON AND OFF -->

		<tr>
		<xsl:if test="position() mod 2 = 0">
			<xsl:attribute name="class">greybg</xsl:attribute>
		</xsl:if>
			<td width="15%"><span class="year"><xsl:value-of select="EXTRAINFO/PRODUCTION_YEAR" /></span></td>
			<td width="84%"><a href="{$root}A{H2G2ID}" xsl:use-attribute-sets="mARTICLEMEMBER_r_issue"><xsl:apply-templates select="NAME" /> <img src="{$imageRoot}images/icon_rightarrow.gif" alt="" height="7" width="10" /></a>
			<br /><xsl:value-of select="EXTRAINFO/CREATOR" />
			<br />
			<xsl:choose>
				<xsl:when test="EXTRAINFO/TYPE/@ID = 30">
					<a href="{$root}C{$mediaBook}"><xsl:value-of select="msxsl:node-set($type)/type[@number=30 or @selectnumber=30]/@label" /></a>
				</xsl:when>
				<xsl:when test="EXTRAINFO/TYPE/@ID = 31">
					<a href="{$root}C{$mediaComic}"><xsl:value-of select="msxsl:node-set($type)/type[@number=31 or @selectnumber=31]/@label" /></a>
				</xsl:when>
				<xsl:when test="EXTRAINFO/TYPE/@ID = 32">
					<a href="{$root}C{$mediaFilm}"><xsl:value-of select="msxsl:node-set($type)/type[@number=32 or @selectnumber=32]/@label" /></a>
				</xsl:when>
				<xsl:when test="EXTRAINFO/TYPE/@ID = 33">
					<a href="{$root}C{$mediaRadio}"><xsl:value-of select="msxsl:node-set($type)/type[@number=33 or @selectnumber=33]/@label" /></a>
				</xsl:when>
				<xsl:when test="EXTRAINFO/TYPE/@ID = 34">
					<a href="{$root}C{$mediaTV}"><xsl:value-of select="msxsl:node-set($type)/type[@number=34 or @selectnumber=34]/@label" /></a>
				</xsl:when>
				<xsl:when test="EXTRAINFO/TYPE/@ID = 35">
					<a href="{$root}C{$mediaOther}"><xsl:value-of select="msxsl:node-set($type)/type[@number=35 or @selectnumber=35]/@label" /></a>
				</xsl:when>
			</xsl:choose><!-- v5 ; 
			<xsl:value-of select="EXTRAINFO/COUNTRY" /> --></td>
			<td><!-- <td class="media">v5 <a href="#">Watch a clip</a> --></td>
		</tr>

	</xsl:template>


	<!--
	<xsl:template match="MEMBERS" mode="c_articlemembers">
	Author:		Tom Whitehouse
	Context:    /H2G2/HIERARCHYDETAILS
	Purpose:    Creates the container for a list of all the articles within the current node
	Updateby:  Trent
	Purpose:   Change to look for status not type
	-->
												<!-- v3 cat ONLY DISPLAYS ARTICLES THAT ARE APPROVED -->
	<xsl:template match="MEMBERS" mode="c_articlemembers">
		<xsl:if test="ARTICLEMEMBER[STATUS/@TYPE = '1']">  
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
	Updateby:  Trent
	Purpose:   Change to look for status not type
	-->
	<xsl:template match="ARTICLEMEMBER" mode="c_issue">
		<xsl:choose>
			<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_type']/VALUE = '1'">
				<xsl:if test="EXTRAINFO/TYPE/@ID = '1' or not(EXTRAINFO)">
					<xsl:apply-templates select="." mode="r_issue"/>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<xsl:if test="(STATUS/@TYPE = '1' or not(EXTRAINFO)) and count(preceding-sibling::ARTICLEMEMBER[EXTRAINFO/TYPE/@ID = '1' or not(EXTRAINFO)]) &lt; $articlemaxlength"><!-- all layout should sit within here and below template so status 3 don't show anything etc -->
					<xsl:apply-templates select="." mode="r_issue"/>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>









</xsl:stylesheet>

