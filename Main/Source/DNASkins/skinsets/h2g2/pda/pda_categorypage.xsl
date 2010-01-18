<?xml version="1.0" encoding="ISO-8859-1"?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
	<!ENTITY raquo "&#187;">
	<!ENTITY laquo "&#171;">
]>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<xsl:import href="../../../base/base-categorypage.xsl"/>
	<xsl:key name="cat" match="/H2G2/HIERARCHYDETAILS/@NODEID" use="."/>
	<xsl:template name="CATEGORY_CSS">
		<xsl:choose>
			<xsl:when test="key('cat', 72)">
				<LINK href="{$csssource}life.css" rel="stylesheet"/>
			</xsl:when>
			<xsl:when test="key('cat', 73)">
				<LINK href="{$csssource}uni.css" rel="stylesheet"/>
			</xsl:when>
			<xsl:when test="key('cat', 74)">
				<LINK href="{$csssource}evy.css" rel="stylesheet"/>
			</xsl:when>
			<xsl:when test="/H2G2/HIERARCHYDETAILS/ANCESTRY/ANCESTOR[2]/NODEID=72">
				<LINK href="{$csssource}life.css" rel="stylesheet"/>
			</xsl:when>
			<xsl:when test="/H2G2/HIERARCHYDETAILS/ANCESTRY/ANCESTOR[2]/NODEID=73">
				<LINK href="{$csssource}uni.css" rel="stylesheet"/>
			</xsl:when>
			<xsl:when test="/H2G2/HIERARCHYDETAILS/ANCESTRY/ANCESTOR[2]/NODEID=74">
				<LINK href="{$csssource}evy.css" rel="stylesheet"/>
			</xsl:when>
			<xsl:otherwise>
				<LINK href="{$csssource}evy.css" rel="stylesheet"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="cat_alphabet">
		<xsl:variable name="letters">
			<letter>A</letter>
			<letter>B</letter>
			<letter>C</letter>
			<letter>D</letter>
			<letter>E</letter>
			<letter>F</letter>
			<letter>G</letter>
			<letter>H</letter>
			<letter>I</letter>
			<letter>J</letter>
			<letter>K</letter>
			<letter>L</letter>
			<letter>M</letter>
			<letter>N</letter>
			<letter>O</letter>
			<letter>P</letter>
			<letter>Q</letter>
			<letter>R</letter>
			<letter>S</letter>
			<letter>T</letter>
			<letter>U</letter>
			<letter>V</letter>
			<letter>W</letter>
			<letter>X</letter>
			<letter>Y</letter>
			<letter>Z</letter>
		</xsl:variable>
		<xsl:variable name="nodeid" select="/H2G2/HIERARCHYDETAILS/@NODEID"/>
		<xsl:variable name="catpageletters">
			<xsl:for-each select="/H2G2/HIERARCHYDETAILS/MEMBERS/*[name()='ARTICLEMEMBER' or name()='SUBJECTMEMBER' or name()='NODEALIASMEMBER']">
				<xsl:value-of select="translate(substring(STRIPPEDNAME, 1,1), $lowercase, $uppercase)"/>
			</xsl:for-each>
		</xsl:variable>
		<xsl:for-each select="msxsl:node-set($letters)/letter">
			<xsl:choose>
				<xsl:when test="contains($catpageletters, .)">
					<a href="{$root}C{$nodeid}?s_letter={.}&amp;s_show=art" class="alpha">
						<xsl:value-of select="."/>
					</a>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="."/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:text> </xsl:text>
		</xsl:for-each>
	</xsl:template>
	<!--xsl:variable name="catpagemembers">
		<xsl:copy-of select="/H2G2/HIERARCHYDETAILS/MEMBERS"/>
	</xsl:variable>
	<xsl:template match="letter">
	<xsl:if test=". = starts-with(msxsl:node-set($catpagemembers)/MEMBERS/ARTICLEMEMBER/STRIPPEDNAME">
		
	</xsl:if>	
	</xsl:template-->
	<!--
	
	-->
	<xsl:template name="CATEGORY_MAINBODY">
		<table width="100%" cellpadding="0" cellspacing="0" border="0">
			<tr>
				<td width="50%" class="pageHead">
					<xsl:choose>
						<xsl:when test="/H2G2/HIERARCHYDETAILS/ANCESTRY/ANCESTOR[2]">
							<xsl:value-of select="/H2G2/HIERARCHYDETAILS/ANCESTRY/ANCESTOR[2]/NAME"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="/H2G2/HIERARCHYDETAILS/DISPLAYNAME"/>
						</xsl:otherwise>
					</xsl:choose>
				</td>
				<td width="50%" class="pageHead" align="right">
					<a href="{$root}" class="homeLnk">Home</a>&nbsp;</td>
			</tr>
		</table>
		<xsl:choose>
			<xsl:when test="/H2G2/PARAMS/PARAM[NAME='s_show']/VALUE='art' or not(/H2G2/HIERARCHYDETAILS/MEMBERS/SUBJECTMEMBER)">
				<!-- ' or /H2G2/HIERARCHYDETAILS/MEMBERS/SUBJECTMEMBER -->
				<div class="chapter">
					<xsl:value-of select="/H2G2/HIERARCHYDETAILS/DISPLAYNAME"/> (<xsl:value-of select="count(/H2G2/HIERARCHYDETAILS/MEMBERS/ARTICLEMEMBER) + count(/H2G2/HIERARCHYDETAILS/MEMBERS/SUBJECTMEMBER) + count(/H2G2/HIERARCHYDETAILS/MEMBERS/NODEALIASMEMBER)"/>)</div>
				<!--xsl:call-template name="paginate_cat"/-->
				<xsl:apply-templates select="/H2G2/HIERARCHYDETAILS/MEMBERS" mode="pda_lowerlevel"/>
				<div class="band2">
					<xsl:call-template name="cat_alphabet"/>
				</div>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<!--xsl:when test="/H2G2/PARAMS/PARAM[NAME='s_show']/VALUE='all'">
						<div class="chapter">Browse <xsl:value-of select="/H2G2/HIERARCHYDETAILS/DISPLAYNAME"/>:</div>
						<div class="catList">
							<xsl:apply-templates select="/H2G2/HIERARCHYDETAILS/MEMBERS/SUBJECTMEMBER" mode="r_issue"/>
						</div>
					</xsl:when>
					<xsl:otherwise>
						<div class="info">
							<b>Find</b> Entries or <b>
								<xsl:text>Browse </xsl:text>
								<xsl:value-of select="/H2G2/HIERARCHYDETAILS/DISPLAYNAME"/>
							</b>
							<br/>
						</div>
						<div class="srchBox">
							<form action="{$root}search">
								<xsl:text>Find in </xsl:text>
								<xsl:value-of select="/H2G2/HIERARCHYDETAILS/DISPLAYNAME"/>
								<br/>
								<input type="hidden" name="searchtype" value="article"/>
								<input type="hidden" name="category" value="{/H2G2/HIERARCHYDETAILS/@NODEID}"/>
								<input type="text" size="20" name="searchstring"/>
								<br/>
								<input type="submit" value="Find it"/>
							</form>
						</div>
				
						<xsl:apply-templates select="/H2G2/HIERARCHYDETAILS/MEMBERS" mode="pda_toplevel"/>
					</xsl:otherwise-->
					<xsl:when test="/H2G2/PARAMS/PARAM[NAME='s_show']/VALUE='search'">
						<div class="info">
							<xsl:choose>
								<xsl:when test="key('cat', 72)">
									<xsl:text>Life: Living things, their behaviour and biology.</xsl:text>
								</xsl:when>
								<xsl:when test="key('cat', 73)">
									<xsl:text>The Universe: The earth, galaxies and contents of intergalactic space - and travel.</xsl:text>
								</xsl:when>
								<xsl:when test="key('cat', 74)">
									<xsl:text>Everything: All the rest, entertainment, sport, history, leisure, language and lots, lots more.</xsl:text>
								</xsl:when>
							</xsl:choose>
							<!--b>Find</b> Entries or <b>
								<xsl:text>Browse </xsl:text>
								<xsl:value-of select="/H2G2/HIERARCHYDETAILS/DISPLAYNAME"/>
							</b-->
							<br/>
						</div>
						<div class="srchBox">
							<form action="{$root}search">
								<xsl:text>Find in </xsl:text>
								<xsl:value-of select="/H2G2/HIERARCHYDETAILS/DISPLAYNAME"/>
								<br/>
								<input type="hidden" name="searchtype" value="article"/>
								<input type="hidden" name="category" value="{/H2G2/HIERARCHYDETAILS/@NODEID}"/>
								<input type="hidden" name="show" value="7"/>
								<input type="text" size="20" name="searchstring"/>
								<br/>
								<input type="submit" value="Find it"/>
							</form>
						</div>
						<!--xsl:apply-templates select="/H2G2/HIERARCHYDETAILS/ANCESTRY" mode="me"/-->
						<xsl:apply-templates select="/H2G2/HIERARCHYDETAILS/MEMBERS" mode="pda_toplevel"/>
					</xsl:when>
					<xsl:otherwise>
						<div class="chapter">Browse <xsl:value-of select="/H2G2/HIERARCHYDETAILS/DISPLAYNAME"/>:</div>
						<div class="catList">
							<xsl:attribute name="class"><xsl:choose><xsl:when test="/H2G2/HIERARCHYDETAILS/ANCESTRY/ANCESTOR[2]">subCatList</xsl:when><xsl:otherwise>catList</xsl:otherwise></xsl:choose></xsl:attribute>
							<xsl:apply-templates select="/H2G2/HIERARCHYDETAILS/MEMBERS/SUBJECTMEMBER" mode="r_issue"/>
						</div>
						<xsl:if test="msxsl:node-set($sortedarticles)/ARTICLEMEMBER">
							<div class="listEntriesHead">Entries</div>
						</xsl:if>
						<xsl:apply-templates select="msxsl:node-set($sortedarticles)/ARTICLEMEMBER[position() &lt; 4]" mode="cats_and_arts"/>
						<xsl:if test="msxsl:node-set($sortedarticles)/ARTICLEMEMBER[4]">
							<span class="chevron">&raquo;</span>
							<a href="{$root}C{/H2G2/HIERARCHYDETAILS/@NODEID}?s_show=art">
								<xsl:text>More</xsl:text>
							</a>
						</xsl:if>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--xsl:variable name="arts_per_cat" select="7"/>
	<xsl:variable name="current_page_cat"
	<xsl:template name="paginate_cat">
		<xsl:if test=""
		<div class="topPaginate">
			<a href="#" class="pageLnk">&laquo;</a> 1 of <a href="entry_categ.shtml" class="pageLnk">80</a>
			<a href="entry_02.shtml" class="pageLnk">&raquo;</a>
		</div>
	</xsl:template-->
	<xsl:template match="ARTICLEMEMBER" mode="cats_and_arts">
		<xsl:variable name="current_letter" select="translate(substring(STRIPPEDNAME, 1, 1), $lowercase, $uppercase)"/>
		<div>
			<xsl:attribute name="class"><xsl:choose><xsl:when test="count(preceding-sibling::ARTICLEMEMBER) mod 2 = 0">band1</xsl:when><xsl:otherwise>band2</xsl:otherwise></xsl:choose></xsl:attribute>
			<span class="chevron">&raquo;</span>
			<a href="{$root}A{H2G2ID}" class="bulletLnk">
				<xsl:value-of select="NAME"/>
			</a>
		</div>
	</xsl:template>
	<xsl:variable name="sortedarticles">
		<xsl:for-each select="/H2G2/HIERARCHYDETAILS/MEMBERS/ARTICLEMEMBER">
			<xsl:sort select="STRIPPEDNAME" order="ascending"/>
			<xsl:copy-of select="."/>
		</xsl:for-each>
	</xsl:variable>
	<!--
	
	-->
	<xsl:template match="ANCESTRY" mode="me">
		<div class="category_ancestry_me">
			<xsl:apply-templates select="ANCESTOR" mode="r_category"/>
		</div>
	</xsl:template>
	<!--
	
	-->
	<xsl:template match="ANCESTOR" mode="r_category">
		<xsl:apply-imports/>
		<xsl:if test="not(position()=last())"> / </xsl:if>
	</xsl:template>
	<!--

	-->
	<xsl:template match="MEMBERS" mode="pda_toplevel">
		<div class="browseBar">Browse in <xsl:value-of select="/H2G2/HIERARCHYDETAILS/DISPLAYNAME"/>
		</div>
		<div class="browseList">
			<xsl:apply-templates select="SUBJECTMEMBER[position() &lt; 7]" mode="r_issue"/>
			<!--xsl:apply-templates select="ARTICLEMEMBER" mode="r_category"/-->
			<xsl:if test="count(SUBJECTMEMBER) &gt; 6">
				<span class="chevron">&raquo;</span>
				<a href="{$root}C{/H2G2/HIERARCHYDETAILS/@NODEID}?s_show=all">More</a>
				<br/>
			</xsl:if>
		</div>
	</xsl:template>
	<!--
	
	-->
	<xsl:attribute-set name="mSUBJECTMEMBER_r_issue">
		<xsl:attribute name="class">bulletLnk</xsl:attribute>
	</xsl:attribute-set>
	<xsl:template match="SUBJECTMEMBER" mode="r_issue">
		<span class="chevron">&raquo;</span>
		<a href="{$root}C{NODEID}" class="bulletLnk">
			<xsl:value-of select="NAME"/> [<xsl:value-of select="NODECOUNT+ARTICLECOUNT+ALIASCOUNT"/>]
		</a>
		<br/>
	</xsl:template>
	<!--

	-->
	<xsl:template match="ARTICLEMEMBER" mode="r_category">
		<span class="chevron">&raquo;</span>
		<xsl:apply-imports/>
		<br/>
	</xsl:template>
	<!--

	-->
	<xsl:template match="MEMBERS" mode="pda_lowerlevel">
		<!--xsl:variable name="letter">
			<xsl:for-each select="ARTICLEMEMBER/STRIPPEDNAME">
				<xsl:sort select="." order="ascending"/>
			</xsl:for-each>		
		
		<xsl:when test="starts-with(translate(ARTICLEMEMBER/STRIPPEDNAME, $lowercase, $uppercase), 'A')">A</xsl:when>
		</xsl:variable-->
		<xsl:variable name="show">
			<xsl:choose>
				<xsl:when test="/H2G2/PARAMS/PARAM[NAME='s_letter']/VALUE">
					<xsl:value-of select="/H2G2/PARAMS/PARAM[NAME='s_letter']/VALUE"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="substring(msxsl:node-set($sortedarticles)/ARTICLEMEMBER[1]/STRIPPEDNAME,1 ,1)"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<!--xsl:if test="SUBJECTMEMBER[starts-with(translate(STRIPPEDNAME, $lowercase, $uppercase), $show)]
| NODEALIASMEMBER[starts-with(translate(STRIPPEDNAME, $lowercase, $uppercase), $show)]">
			<div class="subCatList">
				<xsl:apply-templates select="SUBJECTMEMBER[starts-with(translate(STRIPPEDNAME, $lowercase, $uppercase), $show)] 
									| 
									NODEALIASMEMBER[starts-with(translate(STRIPPEDNAME, $lowercase, $uppercase), $show)]" mode="pda_lowerlevel"/>
			</div>
		</xsl:if-->
		<xsl:apply-templates select="ARTICLEMEMBER[starts-with(translate(STRIPPEDNAME, $lowercase, $uppercase), $show)]" mode="pda_lowerlevel"/>
	</xsl:template>
	<!--

	-->
	<xsl:template match="ARTICLEMEMBER" mode="pda_lowerlevel">
		<xsl:variable name="current_letter" select="translate(substring(STRIPPEDNAME, 1, 1), $lowercase, $uppercase)"/>
		<div>
			<xsl:attribute name="class"><xsl:choose><xsl:when test="count(preceding-sibling::ARTICLEMEMBER[starts-with(translate(STRIPPEDNAME, $lowercase, $uppercase), $current_letter)]) mod 2 = 0">band1</xsl:when><xsl:otherwise>band2</xsl:otherwise></xsl:choose></xsl:attribute>
			<span class="chevron">&raquo;</span>
			<a href="{$root}A{H2G2ID}" class="bulletLnk">
				<xsl:value-of select="NAME"/>
			</a>
		</div>
	</xsl:template>
	<xsl:template match="SUBJECTMEMBER | NODEALIASMEMBER" mode="pda_lowerlevel">
		<!--xsl:variable name="s_show">
			<xsl:if test="NODECOUNT=0">?s_show=art</xsl:if>
		</xsl:variable-->
		<span class="chevron">&raquo;</span>
		<a href="{$root}C{NODEID}" class="bulletLnk">
			<xsl:value-of select="NAME"/> [<xsl:value-of select="NODECOUNT+ARTICLECOUNT+ALIASCOUNT"/>]
		</a>
		<br/>
	</xsl:template>
</xsl:stylesheet>
