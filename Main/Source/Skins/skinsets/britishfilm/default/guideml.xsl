<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
	<!ENTITY space "<xsl:text xmlns:xsl='http://www.w3.org/1999/XSL/Transform'> </xsl:text>">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">


	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
						GuideML Logical container template
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->


	<!--  ************** HTML AND DESIGN TEMPLATES ***************** -->

	<xsl:template match="BODY">
		<xsl:apply-templates/>
	</xsl:template>
	
	
	<xsl:template match="br | BR | P | p | B | b  | SUB | sub | SUP | sup | DIV | div | USEFULLINKS | lang | LANG | abbreviation | ABBREVIATION | acronym | ACRONYM | em | EM | strong | STRONG | cite | CITE | q | Q | I | i | SMALL | small | CODE | code">
		<xsl:copy>	
			<xsl:apply-templates select="*|@*|text()"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="HEADER | SUBHEADER | FORM | form | INPUT | input | SELECT | select | TABLE | table | TD | td | TH | th | TR | FONT| font | OL | ol | UL | ul | LI | li  | U | u | MARQUEE| marquee |CENTER | center | CAPTION | caption | PRE | pre | ITEM-LIST | item-list | INTRO | intro | GUESTBOOK | guestbook | BLOCKQUOTE | blockquote | ADDTHREADINTRO | addthreadintro | BRUNEL | brunel | FOOTNOTE | footnote | FORUMINTRO | forumintro | FORUMTHREADINTRO | forumthreadintro | REFERENCES | references | SECTION | section |  THREADINTRO | threadintro | VOLUNTEER-LIST | volunteer-list | WHO-IS-ONLINE | who-is-online"> 	<!-- TODO:8 -->	
		<xsl:apply-templates />
	</xsl:template>

	<xsl:template match="TEXTAREA">
		<!-- do nothing -->
	</xsl:template>
	
	<xsl:template match="INPUT[@SRC]">
		<xsl:comment>Sorry, the SRC attribute is not allowed on an INPUT tag in GuideML</xsl:comment>
	</xsl:template>
	
	<xsl:template match="IMG">
		<xsl:if test="not(starts-with(@SRC,'http://'))">
			<xsl:copy>
				<xsl:apply-templates select="*|@*|text()"/>
			</xsl:copy>
		</xsl:if>
	</xsl:template>

	<xsl:template match="A">
		<xsl:choose>
			<xsl:when test="/H2G2/ARTICLE/ARTICLEINFO/PAGEAUTHOR/EDITOR/USER/GROUPS/GROUP[@NAME='Editor']">
				<xsl:copy use-attribute-sets="mA">
					<xsl:apply-templates select="*|@HREF|@TARGET|@NAME|@CLASS|text()"/>
				</xsl:copy>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="OBJECT">
		<!-- do nothing -->
	</xsl:template>
	<xsl:template match="EMBED">
		<!-- do nothing -->
	</xsl:template>
	<xsl:template match="SCRIPT">
		<!-- do nothing -->
	</xsl:template>
	<xsl:template match="STYLE">
		<!-- do nothing -->
	</xsl:template>
	<xsl:template match="@STYLE">
		<!-- do nothing -->
	</xsl:template>
	<xsl:template match="@COLOR">
		<!-- do nothing -->
	</xsl:template>
	<xsl:template match="@WIDTH">
		<!-- do nothing -->
	</xsl:template>
	<xsl:template match="@HEIGHT">
		<!-- do nothing -->
	</xsl:template>
	<xsl:template match="@ALIGN">
		<!-- do nothing -->
	</xsl:template>
	<xsl:template match="PICTURE">
		<!-- do nothing -->
	</xsl:template>

	<xsl:template match="UL">
		<ul class="text"><xsl:apply-templates/></ul>
	</xsl:template>
	
	<xsl:template match="LI">
		<li><xsl:apply-templates/></li>
	</xsl:template>

	<xsl:template match="TABLE">
		<table border="0" class="userTable" cellspacing="0">
			<xsl:apply-templates select="*|@*|text()"/>
		</table>
	</xsl:template>
	
	<xsl:template match="TR | TH | TD">
		<xsl:copy>
			<xsl:apply-templates select="*|@*|text()"/>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="TR/TH[1]">
		<th class="first"><xsl:apply-templates/></th>
	</xsl:template>
	
	<xsl:template match="TR/TD[1]">
		<td class="first"><xsl:apply-templates select="*|@*|text()"/></td>
	</xsl:template>

		<xsl:template match="LINK">
		<xsl:apply-templates/>
	</xsl:template>
	
	
	<xsl:template match="LINK">
		<xsl:choose>
			<xsl:when test="/H2G2/ARTICLE/ARTICLEINFO/PAGEAUTHOR/EDITOR/USER/GROUPS/GROUP[@NAME='Editor']">
				<a>
				<xsl:apply-templates select="@DNAID | @HREF"/>
				<xsl:call-template name="dolinkattributes"/>
				<xsl:value-of select="./text()" />
				</a>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="SMILEY">
		<xsl:apply-imports/>
		<xsl:text> </xsl:text>
	</xsl:template>
	
	
	<xsl:template match="COL2">
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="TABLETITLE">
		<div class="tableTitle">
			<xsl:apply-templates select="*|@*|text()"/>
		</div>
	</xsl:template>
	
	<xsl:template match="TABLESUBTITLE">
		<div class="tableSubTitle">
			<xsl:apply-templates select="*|@*|text()"/>
		</div>
	</xsl:template>
	
	
	<xsl:template match="QUOTE">
		<xsl:variable name="raw_class">
			<xsl:choose>
				<xsl:when test="@align">
					quote<xsl:text> </xsl:text><xsl:value-of select="@align"/>quote
				</xsl:when>
				<xsl:when test="@ALIGN">
					quote<xsl:text> </xsl:text><xsl:value-of select="@ALIGN"/>quote
				</xsl:when>
				<xsl:otherwise>
					quote
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<div>
			<xsl:attribute name="class">
				<xsl:value-of select="translate($raw_class, '&#xA;&#9;&#10;', '')"/>
			</xsl:attribute>
			<xsl:apply-templates/>
		</div>
	</xsl:template>

	<xsl:template match="QUOTE/P">
		<span class="q1"></span><xsl:value-of select="."/><span class="q2"></span>
	</xsl:template>
	
	<xsl:template match="CITE">
		<cite><xsl:apply-templates/></cite>
	</xsl:template>

	<xsl:template match="VIDEO">
		<div class="avlink">
		<a onClick="javascript:launchAVConsoleStory('{@STORYID}'); return false;" href="http://news.bbc.co.uk/sport1/hi/video_and_audio/help_guide/4304501.stm">
			<img src="http://newsimg.bbc.co.uk/sol/shared/img/v3/videosport.gif" align="left" width="60" height="13" alt="" border="0" vspace="1"/><b><xsl:value-of select="CAPTION"/></b>
		</a>
		</div>
	</xsl:template>



	<!--  ************** ARTICLE PAGE TEMPLATES ***************** -->

	<!-- <xsl:template match="Banner">
		<xsl:apply-templates />
	</xsl:template> -->

	<xsl:template match="TEXT">
		<p><xsl:apply-templates /></p>
	</xsl:template>

	<xsl:template match="SCENE">
		<table>
			<tr>
				<td><img><xsl:attribute name="src"><xsl:value-of select="IMAGE" /></xsl:attribute></img></td>
				<td><a><xsl:attribute name="href"><xsl:value-of select="concat($root,ARTICLEID)"/></xsl:attribute><xsl:value-of select="TITLE" /></a></td>
			</tr>
		</table>
	</xsl:template>


	<!--  ************** RIGHT COLUMN TEMPLATES ***************** -->

	<xsl:template match="RIGHTCOL_BROWSE" mode="rightcol">
		<div class="relcontent">			   
			<h3>Browse</h3>Content for browse section goes here</div>
	</xsl:template>

	<xsl:template match="RIGHTCOL_TIPS" mode="rightcol">
		<div class="relcontent">			   
			<h3>Tips</h3>Content for tips section goes here</div>
	</xsl:template>

	<xsl:template match="RIGHTCOL_LINKS" mode="rightcol">
		<div class="relcontent">			   
			<h3>Links</h3>Content for list of links section goes here</div>
	</xsl:template>

	<xsl:template match="DYNAMIC-LISTS" mode="rightcol">
		<div class="relcontent">			   
			<h3>Top 5</h3>

			<ul>
				<xsl:for-each select="/H2G2/DYNAMIC-LISTS/LIST[@LISTNAME='film']/ITEM-LIST/ITEM">
					<li><a><xsl:attribute name="href"><xsl:value-of select="concat($root,'A',@ITEMID)" /></xsl:attribute><xsl:value-of select="ARTICLE-ITEM/SUBJECT" /></a></li>
				</xsl:for-each>
			</ul>
		</div>

			<!-- TAKEN FROM FILMNETWORK: need to modify CV : note that the code below breaks template up into two different templates

			<DYNAMIC-LISTS>
				<LIST LISTID="30" LISTNAME="sport_all" LISTTYPE="ARTICLES">
					<ITEM-LIST>
						<ITEM ITEMID="19628445">
							<ARTICLE-ITEM H2G2ID="19628445">
								<SUBJECT>SFA silence on Celtic's misdemeanours</SUBJECT>
								<EXTRAINFO><EXTRAINFO>
								<AUTHOR></AUTHOR>
							</ARTICLE-ITEM>
							<DATE-CREATED/>
							<DATE-UPDATED/>
							<TITLE>SFA silence on Celtic's misdemeanours</TITLE>
							<CREATOR></CREATOR>
							<POLL-LIST></POLL-LIST>
						</ITEM>

			<xsl:variable name="listname">
				<xsl:value-of select="@NAME" />
			</xsl:variable>
			<xsl:variable name="listlegnth">
				<xsl:choose>
					<xsl:when test="@LENGTH &gt; 0">
						<xsl:value-of select="@LENGTH" />
					</xsl:when>
					<xsl:otherwise>
					5
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
	
			<div>
				<xsl:apply-templates select="/H2G2/DYNAMIC-LISTS/LIST[@LISTNAME=$listname]/ITEM-LIST/ITEM[position() &lt;= $listlegnth]"/>
			</div>
	</xsl:template>

	<xsl:template match="ITEM-LIST/ITEM">
		<div class="itemTerm"><a href="{$root}A{@ITEMID}"><xsl:value-of select="TITLE" /></a></div>		
	-->
	</xsl:template>

	<xsl:template match="RIGHTCOL_SUBMIT" mode="rightcol">
		<div class="relcontent">			   
			<h3>Submit</h3>
			<a><xsl:attribute name="href">
				<xsl:call-template name="sso_typedarticle_signin">
						<xsl:with-param name="type" select="10"/>
				</xsl:call-template>
			</xsl:attribute><strong>Submit your film</strong></a>
		</div>
	</xsl:template>



	
	<!-- BODY : taken from filmnetwork can implement similar if we like
	<xsl:template match="BODY">
		<xsl:choose>
			<xsl:when test="parent::BLUE_HEADER_BOX">
				<div class="topboxcopy"><strong><xsl:apply-templates /></strong></div>
			</xsl:when>
			<xsl:when test="parent::FUNDINGDETAILS">
				<span class="textbrightsmall"><xsl:apply-templates /></span>
			</xsl:when>
			<xsl:otherwise>
					<xsl:apply-templates />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="RIGHTCOLBOX">
			<div class="rightcolbox"><xsl:apply-templates select="IMG" />
				<div class="textlightsmall"><xsl:apply-templates select="BODY" /></div>
				<div class="textbrightsmall">	
					<xsl:apply-templates select="UL" />
					<xsl:apply-templates select="SUBSCRIBEFIELD" />
				</div>
			</div>

			<table border="0" cellspacing="0" cellpadding="0" width="244">
			  <tr>
				<td height="10"></td>
			  </tr>
			</table>
	</xsl:template>
	
	<xsl:template match="COLUMN">
	<table width="635" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td><img src="/f/t.gif" width="371" height="1" class="tiny" alt="" /></td>
            <td><img src="/f/t.gif" width="10" height="1" class="tiny" alt="" /></td>
            <td><img src="/f/t.gif" width="10" height="1" class="tiny" alt="" /></td>
            <td><img src="/f/t.gif" width="244" height="1" class="tiny" alt="" /></td>
          </tr>
          <tr>
            <td align="right" valign="top">
		  
		  <xsl:apply-templates select="LEFTCOL"/></td>
            <td></td>
            <td class="introdivider">&nbsp;</td>
            <td valign="top"><xsl:apply-templates select="RIGHTCOL"/></td>
	</tr>
	</table>
	</xsl:template>

	<xsl:template match="LEFTCOL">
		<xsl:apply-templates select="*|@*|text()"/>
	</xsl:template>

	<xsl:template match="RIGHTCOL">
		<xsl:apply-templates select="*|@*|text()"/>
	</xsl:template>

	<xsl:template match="RIGHTCOLTOP">
		<div class="intorightcolumn">
			<xsl:apply-templates select="*|@*|text()"/>
		</div>
	</xsl:template>

	
	<xsl:template match="IMG | img">
	<xsl:choose>
		<xsl:when test="@DNAID | @HREF">
			<a>
				<xsl:apply-templates select="@DNAID | @HREF"/>
				<img src="{$imagesource}{@NAME}" border="0">
					<xsl:apply-templates select="*|@*|text()"/>
				</img>
			</a>
		</xsl:when>
		<xsl:when test="@CTA='submission'">
				<a>
				<xsl:attribute name="href">
				<xsl:call-template name="sso_typedarticle_signin">
				<xsl:with-param name="type" select="30"/>
				</xsl:call-template>
				</xsl:attribute>
					<img src="{$imagesource}{@NAME}" border="0">
						<xsl:apply-templates select="*|@*|text()"/>
					</img>
				</a>
		</xsl:when>
			<xsl:otherwise>
				<img src="{$imagesource}{@NAME}" border="0">
					<xsl:apply-templates select="*|@*|text()"/>
				</img>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>	

	-->
	
	

</xsl:stylesheet>