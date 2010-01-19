<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<xsl:import href="../../../base/base-indexpage.xsl"/>
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
									Page - Level  template
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<xsl:template name="INDEX_MAINBODY">
	<!-- DEBUG -->
	<xsl:call-template name="TRACE">
	<xsl:with-param name="message">INDEX_MAINBODY</xsl:with-param>
	<xsl:with-param name="pagename">indexpage.xsl</xsl:with-param>
	</xsl:call-template>
	<!-- DEBUG -->
	
	<table border="0" cellspacing="0" cellpadding="0" width="635">
        <tr> 
          <td height="10">
		  <!-- crumb menu -->
		  <div class="crumbtop"><span class="textxlarge">index page</span></div>
		  <!-- END crumb menu --></td>
        </tr>
      </table>

		
		<table width="635" cellpadding="0" cellspacing="0" border="0">
				<tr>
					<td valign="top" class="topbg" height="59">
					<img src="/f/t.gif" width="1" height="10" alt="" />
					
						<div class="whattodotitle"><strong>your index results for '
						<xsl:choose>
							<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_display']/VALUE = 'submissions_awaiting'">
							Submissions - Awaiting
							</xsl:when>
							<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_display']/VALUE = 'submissions_declined'">
							Submissions - Declined
							</xsl:when>
							<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_display']/VALUE = 'films'">
							All Films 
							</xsl:when>
							<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_display']/VALUE = 'credits'">
							All Credits
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="/H2G2/INDEX/@LETTER" />
							</xsl:otherwise>
						</xsl:choose>
						'</strong></div>
					 </td>
				</tr>
			</table><img src="{$imagesource}furniture/writemessage/topboxangle.gif" width="635" height="27" /><br />
		
		<div class="mainpanelmenu" style="margin:10px 0;"><xsl:call-template name="ABCLINKS" /></div>

		<xsl:apply-templates select="INDEX" mode="c_index"/>



			<div class="searchhead" style="">search </div>
			<!-- search panel -->
			<form method="get" action="{$root}Search" xsl:use-attribute-sets="fc_search_dna" name="filmindexsearch" id="filmindexsearch" >
			<table width="635" border="0" cellspacing="0" cellpadding="0">
              <tr> 
			    <td width="98" height="96" align="right" valign="top" class="webboxbg">
				<div class="mainpanelicon"><img src="{$imagesource}furniture/directory/search.gif" width="75" height="75" alt="Search icon" /></div></td>
                <td width="465" valign="top" class="webboxbg">
				<div class="searchline">I am looking for</div>
				<div class="searchback"><xsl:call-template name="r_search_dna2" /><!-- <input name="textfield" type="text" size="10" class="searchinput"/> -->&nbsp;&nbsp;<input type="image" name="dosearch" src="{$imagesource}furniture/directory/search1.gif" alt="search" /></div></td>
                <td width="72" valign="top" class="webboxbg"><img src="{$imagesource}furniture/filmindex/angle.gif" width="72" height="39" alt="" /></td>
              </tr>
            </table>
			</form>
			<!-- END search panel -->

	<table width="635" border="0" cellspacing="0" cellpadding="0">
	  <tr>
		<td height="20"></td>
	  </tr>
	</table>

	</xsl:template>
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
							INDEX Object
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
<xsl:template match="INDEX" mode="r_index">
<table width="635" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td width="635" height="2"><img src="{$imagesource}furniture/blackrule.gif" width="635" height="2" alt="" class="tiny" /></td>
  </tr>
  <tr>
  	<td height="8"></td>
  </tr>
  <tr>
    <td  valign="top">
      <table width="635" border="0" cellspacing="0" cellpadding="0">
        <tr>
          <td><div class="textmedium"><strong><xsl:apply-templates select="@SKIP" mode="c_index"/></strong></div></td>
          <td align="right"><div class="textmedium"><strong><xsl:apply-templates select="@MORE" mode="c_index"/></strong></div></td>
        </tr>
      </table></td>
  </tr>
  <tr>
    <td width="635" height="18"><img src="{$imagesource}furniture/blackrule.gif" width="635" height="2" alt="" class="tiny" /></td>
  </tr>
</table>


<!-- hide a-z thumbnail view from editors - they want to see sortable table -->
<xsl:if test="$test_IsEditor=0">
<table width="100%" cellspacing="0" cellpadding="0" border="0">
	<xsl:apply-templates select="INDEXENTRY" mode="c_index"/>
</table>
</xsl:if>

<!-- sortable table for editorial team -->
<xsl:apply-templates select="." mode="submissions_table" />

<table width="635" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td width="635" height="2"><img src="{$imagesource}furniture/blackrule.gif" width="635" height="2" alt="" class="tiny" /></td>
  </tr>
  <tr>
  	<td height="8"></td>
  </tr>
  <tr>
    <td  valign="top">
      <table width="635" border="0" cellspacing="0" cellpadding="0">
        <tr>
          <td><div class="textmedium"><strong><xsl:apply-templates select="@SKIP" mode="c_index"/></strong></div></td>
          <td align="right"><div class="textmedium"><strong><xsl:apply-templates select="@MORE" mode="c_index"/></strong></div></td>
        </tr>
      </table></td>
  </tr>
  <tr>
    <td width="635" height="18"><img src="{$imagesource}furniture/blackrule.gif" width="635" height="2" alt="" class="tiny" /></td>
  </tr>
</table>
		
</xsl:template>
	
	<xsl:template match="INDEX" mode="submissions_table">
		<xsl:if test="$test_IsEditor">
		<xsl:variable name="skipto">
			<xsl:choose>
				<xsl:when test="(@TOTAL - 400) &lt; 0">
					0
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="@TOTAL - 400"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:choose>
			<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_display']/VALUE = 'submissions_awaiting'">
			<p><a href="{$root}Index?user=on&amp;type=30&amp;type=31&amp;type=32&amp;type=33&amp;type=34&amp;type=35&amp;let=all&amp;orderby=datecreated&amp;show=400&amp;skip={$skipto}&amp;s_display=submissions_awaiting">skip to 400 most recent Awaiting Submissions</a></p>
			</xsl:when>
			<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_display']/VALUE = 'submissions_declined'">
			<p><a href="{$root}Index?user=on&amp;type=50&amp;type=51&amp;type=52&amp;type=53&amp;type=54&amp;type=55&amp;let=all&amp;orderby=datecreated&amp;show=400&amp;skip={$skipto}&amp;s_display=submissions_declined">skip to 400 most recent Awaiting Declined</a></p>
			</xsl:when>
			<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_display']/VALUE = 'films'">
			<p><a href="{$root}Index?official=on&amp;type=30&amp;type=31&amp;type=32&amp;type=33&amp;type=34&amp;type=35&amp;let=all&amp;orderby=datecreated&amp;show=400&amp;skip={$skipto}&amp;s_display=films">skip to 400 most recent films</a></p>
			</xsl:when>
			<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_display']/VALUE = 'credits'">
			<p><a href="{$root}Index?user=on&amp;user=on&amp;submitted=on&amp;type=70&amp;type=71&amp;type=72&amp;type=73&amp;type=74&amp;type=75&amp;let=all&amp;orderby=datecreated&amp;show=400&amp;skip={$skipto}&amp;s_display=credits">skip to 400 most recent credits</a></p>
			</xsl:when>
			<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_display']/VALUE = 'notes'">
			<p><a href="{$root}Index?official=on&amp;user=on&amp;submitted=on&amp;type=90&amp;type=91&amp;type=92&amp;type=93&amp;type=94&amp;type=95&amp;let=all&amp;orderby=datecreated&amp;show=400&amp;skip={$skipto}&amp;s_display=notes">skip to 400 most recent Filmmakers note</a></p>
			</xsl:when>
		</xsl:choose>
			
		<p style="font-size:80%;">@LETTER: <xsl:value-of select="@LETTER" /><br />
			@APPROVED:<xsl:value-of select="@APPROVED" /><br />
			@UNAPPROVED:<xsl:value-of select="@UNAPPROVED" /><br />
			@SUBMITTED:<xsl:value-of select="@SUBMITTED" /><br />
			@COUNT:<xsl:value-of select="@COUNT" /><br />
			@SKIP:<xsl:value-of select="@SKIP" /><br />
			@TOTAL:<xsl:value-of select="@TOTAL" /><br />
			SEARCHTYPES: 
			<xsl:for-each select="SEARCHTYPES/TYPE">
				<xsl:value-of select="." /><xsl:if test="position() != last()">, </xsl:if>
			</xsl:for-each></p>
			<script src="{$site_server}/filmnetwork/includes/sorttable.js"></script>
			<xsl:choose>
				<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_display']/VALUE = 'films' or /H2G2/PARAMS/PARAM[NAME = 's_display']/VALUE = 'credits' or /H2G2/PARAMS/PARAM[NAME = 's_display']/VALUE = 'notes'">
					<table width="635" cellpadding="2" cellspacing="0" border="1" style="font-size:80%;background:#fff;margin-bottom:20px;" class="sortable" id="indextable">
					<tr style="background:#dddddd;">
						<th>Title</th>
						<th>director</th>
						<th>genre</th>
						<th>place</th>
						<th>duration</th>
						<th>date published</th>
						<th style="background:#efefef">status</th>
						<th style="background:#efefef">type</th>
					</tr>
					<xsl:for-each select="INDEXENTRY">
					<tr>
						<td><a href="A{H2G2ID}" title="{EXTRAINFO/DESCRIPTION}"><xsl:value-of select="SUBJECT" /></a><br /></td>
						<td><xsl:value-of select="EXTRAINFO/DIRECTORSNAME" /><br /></td>
						<td><xsl:choose>
								<xsl:when test="EXTRAINFO/TYPE/@ID=30 or EXTRAINFO/TYPE/@ID=50 or EXTRAINFO/TYPE/@ID=70 or EXTRAINFO/TYPE/@ID=90">
								drama
								</xsl:when>
								<xsl:when test="EXTRAINFO/TYPE/@ID=31 or EXTRAINFO/TYPE/@ID=51 or EXTRAINFO/TYPE/@ID=71or EXTRAINFO/TYPE/@ID=91">
								comedy
								</xsl:when>
								<xsl:when test="EXTRAINFO/TYPE/@ID=32 or EXTRAINFO/TYPE/@ID=52 or EXTRAINFO/TYPE/@ID=72 or EXTRAINFO/TYPE/@ID=92">
								documentary
								</xsl:when>
								<xsl:when test="EXTRAINFO/TYPE/@ID=33 or EXTRAINFO/TYPE/@ID=53 or EXTRAINFO/TYPE/@ID=73 or EXTRAINFO/TYPE/@ID=93">
								animation
								</xsl:when>
								<xsl:when test="EXTRAINFO/TYPE/@ID=34 or EXTRAINFO/TYPE/@ID=54 or EXTRAINFO/TYPE/@ID=74 or EXTRAINFO/TYPE/@ID=94">
								experimental
								</xsl:when>
								<xsl:when test="EXTRAINFO/TYPE/@ID=35 or EXTRAINFO/TYPE/@ID=55 or EXTRAINFO/TYPE/@ID=75 or EXTRAINFO/TYPE/@ID=95">
								music
								</xsl:when>
							</xsl:choose><br /></td>
						<td><xsl:value-of select="EXTRAINFO/REGION" /><br /></td>
						<td><xsl:variable name="mintues" select="EXTRAINFO/FILMLENGTH_MINS"/>
						<xsl:choose>
							<xsl:when test="string-length($mintues) = 1">
							0<xsl:value-of select="EXTRAINFO/FILMLENGTH_MINS" />
							</xsl:when>
							<xsl:otherwise>
							<xsl:value-of select="EXTRAINFO/FILMLENGTH_MINS" />
							</xsl:otherwise>
						</xsl:choose>
						<br /></td>
						<td><xsl:value-of select="substring(EXTRAINFO/DATECREATED, 1, 4)" />_<xsl:value-of select="substring(EXTRAINFO/DATECREATED, 5, 2)" />_<xsl:value-of select="substring(EXTRAINFO/DATECREATED, 7, 2)" /><br /></td>
						<td style="background:#efefef"><xsl:value-of select="STATUSNUMBER" /></td>
						<td style="background:#efefef"><xsl:value-of select="EXTRAINFO/TYPE/@ID" /></td>
					</tr>
					</xsl:for-each>
					</table>
				</xsl:when>
				<xsl:otherwise>
					<table width="635" cellpadding="2" cellspacing="0" border="1" style="font-size:80%;background:#fff;margin-bottom:20px;" class="sortable" id="indextable">
						<tr style="background:#dddddd;">
						<th>Title of submission</th>
						<th>Ref Number</th>
						<th>Submission Date</th>
						<th>Submission status</th>
						<th>Genre</th>
						<th>Submitted by</th>
						<th>email</th>
						<th>notes</th>
						<th style="background:#efefef">status</th>
						<th style="background:#efefef">type</th>
						</tr>
						<xsl:for-each select="INDEXENTRY">
						<tr>
						<td><a href="A{H2G2ID}" title="{EXTRAINFO/DESCRIPTION}"><xsl:value-of select="SUBJECT" /></a></td>
						<td><xsl:value-of select="H2G2ID" /></td>
						<td><xsl:value-of select="substring(EXTRAINFO/DATECREATED, 1, 4)" />_<xsl:value-of select="substring(EXTRAINFO/DATECREATED, 5, 2)" />_<xsl:value-of select="substring(EXTRAINFO/DATECREATED, 7, 2)" /><br /></td>
						<td><xsl:value-of select="EXTRAINFO/FILM_STATUS_MSG" /><br /></td>
						<td><xsl:choose>
								<xsl:when test="EXTRAINFO/TYPE/@ID=30 or EXTRAINFO/TYPE/@ID=50 or EXTRAINFO/TYPE/@ID=70">
								drama
								</xsl:when>
								<xsl:when test="EXTRAINFO/TYPE/@ID=31 or EXTRAINFO/TYPE/@ID=51 or EXTRAINFO/TYPE/@ID=71">
								comedy
								</xsl:when>
								<xsl:when test="EXTRAINFO/TYPE/@ID=32 or EXTRAINFO/TYPE/@ID=52 or EXTRAINFO/TYPE/@ID=72">
								documentary
								</xsl:when>
								<xsl:when test="EXTRAINFO/TYPE/@ID=33 or EXTRAINFO/TYPE/@ID=53 or EXTRAINFO/TYPE/@ID=73">
								animation
								</xsl:when>
								<xsl:when test="EXTRAINFO/TYPE/@ID=34 or EXTRAINFO/TYPE/@ID=54 or EXTRAINFO/TYPE/@ID=74">
								experimental
								</xsl:when>
								<xsl:when test="EXTRAINFO/TYPE/@ID=35 or EXTRAINFO/TYPE/@ID=55 or EXTRAINFO/TYPE/@ID=75">
								music
								</xsl:when>
							</xsl:choose><br /></td>
						<td><a href="U{EXTRAINFO/SUBMITTEDBYID}"><xsl:value-of select="EXTRAINFO/SUBMITTEDBYNAME" /></a><br /></td>
						<td><a href="InspectUser?userid={EXTRAINFO/SUBMITTEDBYID}">InspectUser</a></td>
						<td><xsl:value-of select="EXTRAINFO/WHYDECLINED" /><br /></td>
						<td style="background:#efefef"><xsl:value-of select="STATUSNUMBER" /></td>
						<td style="background:#efefef"><xsl:value-of select="EXTRAINFO/TYPE/@ID" /></td>
						</tr>
						</xsl:for-each>
					</table>
				</xsl:otherwise>
			</xsl:choose>
			</xsl:if>
	</xsl:template>
	
	



	<!--
		<xsl:template match="INDEXENTRY" mode="c_index">
	Author:		Andy Harris
	Context:      /H2G2/INDEX
	Purpose:	 Selects the correct type of INDEX to be dispalyed
	-->
	<xsl:template match="INDEXENTRY" mode="c_index">
		<xsl:choose>
			<xsl:when test="STATUS='APPROVED' and (EXTRAINFO/TYPE/@ID = 30 or EXTRAINFO/TYPE/@ID = 31 or EXTRAINFO/TYPE/@ID = 32 or EXTRAINFO/TYPE/@ID = 33 or EXTRAINFO/TYPE/@ID = 34)">
				<xsl:apply-templates select="." mode="approved_index"/>
			</xsl:when>
			 <xsl:when test="STATUS='UNAPPROVED'">
				<xsl:if test="$test_IsEditor">
				<xsl:apply-templates select="." mode="unapproved_index"/>
				</xsl:if>
			</xsl:when>
			<xsl:when test="STATUS='SUBMITTED'">
			<xsl:if test="$test_IsEditor">
				<xsl:apply-templates select="." mode="submitted_index"/>
			</xsl:if>
			</xsl:when>
		</xsl:choose>
	</xsl:template>



	<!--
	<xsl:template match="INDEXENTRY" mode="approved_index">
	Description: Presentation of the individual entries 	for the 
		approved articles index
	 -->
	<xsl:template match="INDEXENTRY" mode="approved_index">
		<tr>
				<td width="31" valign="top">
				<xsl:choose>
					<xsl:when test="EXTRAINFO/TYPE/@ID &gt; 29 and EXTRAINFO/TYPE/@ID &lt; 35">
						<!-- A{H2G2id} -->
						<img src="{$imagesource}shorts/A{H2G2ID}_small.jpg" width="31" height="30" alt="" />
					</xsl:when>
					<xsl:otherwise>
						<img src="{$imagesource}furniture/searchpage_icon.gif" width="31" height="30" alt="" />
					</xsl:otherwise>
				</xsl:choose>
				
				</td>
				<td width="340" valign="top">
				<div class="titlefilmography">
					<strong><xsl:apply-templates select="SUBJECT" mode="t_index"/></strong></div>
					<xsl:apply-templates select="POLL[STATISTICS/@VOTECOUNT &gt; 0][@HIDDEN = 0]" mode="show_dots"/>
					<div class="smallsubmenu"><xsl:choose>
						<xsl:when test="EXTRAINFO/TYPE/@ID = 30">
							<a href="{$root}C{$genreDrama}" class="textdark"><xsl:value-of select="msxsl:node-set($type)/type[@number=30 or @selectnumber=30]/@subtype" /></a>
						</xsl:when>
						<xsl:when test="EXTRAINFO/TYPE/@ID = 31">
							<a href="{$root}C{$genreComedy}" class="textdark"><xsl:value-of select="msxsl:node-set($type)/type[@number=31 or @selectnumber=31]/@subtype" /></a>
						</xsl:when>
						<xsl:when test="EXTRAINFO/TYPE/@ID = 32">
							<a href="{$root}C{$genreDocumentry}" class="textdark"><xsl:value-of select="msxsl:node-set($type)/type[@number=32 or @selectnumber=32]/@subtype" /></a>
						</xsl:when>
						<xsl:when test="EXTRAINFO/TYPE/@ID = 33">
							<a href="{$root}C{$genreAnimation}" class="textdark"><xsl:value-of select="msxsl:node-set($type)/type[@number=33 or @selectnumber=33]/@subtype" /></a>
						</xsl:when>
						<xsl:when test="EXTRAINFO/TYPE/@ID = 34">					
							<a href="{$root}C{$genreExperimental}" class="textdark"><xsl:value-of select="msxsl:node-set($type)/type[@number=34 or @selectnumber=34]/@subtype" /></a>
						</xsl:when>
						<xsl:when test="EXTRAINFO/TYPE/@ID = 35">					
							<a href="{$root}C{$genreMusic}" class="textdark"><xsl:value-of select="msxsl:node-set($type)/type[@number=35 or @selectnumber=35]/@subtype" /></a>
						</xsl:when>
						<xsl:otherwise>
						</xsl:otherwise>
					</xsl:choose>
				</div>

				<div class="padrightpara"><xsl:value-of select="EXTRAINFO/DESCRIPTION" /></div></td>
			  </tr>
			   <tr>
				<td width="371" height="10" colspan="2"></td>
			 </tr>
			  <tr> 
              <td height="1" colspan="2"><img src="{$imagesource}furniture/wherebeenbar.gif" width="371" height="1" class="tiny" alt="" /></td>
			</tr>
			  <tr>
				<td width="371" height="10" colspan="2"></td>
			 </tr>
	</xsl:template>
	<!--
	<xsl:template match="INDEXENTRY" mode="unapproved_index">
	Description: Presentation of the individual entries 	for the 
		unapproved articles index
	 -->
	<xsl:template match="INDEXENTRY" mode="unapproved_index">

	<tr>
	<td>
	<div class="smallsubmenu">
	<strong><a href="{$root}A{H2G2ID}"><xsl:value-of select="SUBJECT"/></a> | <a href="{$root}TypedArticle?aedit=new&amp;type={EXTRAINFO/TYPE/@ID}&amp;h2g2id=A{H2G2ID}">edit</a></strong><br />
	<xsl:value-of select="EXTRAINFO/DESCRIPTION"/><br /><br />
	<strong>Type: </strong>	<xsl:variable name="filmtype" select="EXTRAINFO/TYPE/@ID"/>
	<xsl:value-of select="msxsl:node-set($type)/type[@number=$filmtype]/@subtype" /><br />
	<strong>Directors name:</strong><xsl:text>   </xsl:text><xsl:value-of select="EXTRAINFO/DIRECTORSNAME"/><br />
	<strong>Status:</strong><xsl:text>   </xsl:text><xsl:value-of select="EXTRAINFO/FILM_STATUS_MSG"/><br />
	<strong>Film Length:</strong> <xsl:text>  </xsl:text><xsl:value-of select="EXTRAINFO/FILMLENGTH_MINS"/> mins <br />
	</div>
	<br />
	</td>
	</tr>
	

	</xsl:template>
	<!--
	<xsl:template match="INDEXENTRY" mode="submitted_index">
	Description: Presentation of the individual entries 	for the 
		submitted articles index
	 -->
	<xsl:template match="INDEXENTRY" mode="submitted_index">
	<tr>
	<td>
	<div class="smallsubmenu">
	<strong><a href="{$root}A{H2G2ID}"><xsl:value-of select="SUBJECT"/></a> | <a href="{$root}TypedArticle?aedit=new&amp;type={EXTRAINFO/TYPE/@ID}&amp;h2g2id=A{H2G2ID}">edit</a></strong><br />
	<xsl:value-of select="EXTRAINFO/DESCRIPTION"/><br /><br />
	<strong>Type: </strong>	<xsl:variable name="filmtype" select="EXTRAINFO/TYPE/@ID"/>
	<xsl:value-of select="msxsl:node-set($type)/type[@number=$filmtype]/@subtype" /><br />
	<strong>Directors name:</strong><xsl:text>   </xsl:text><xsl:value-of select="EXTRAINFO/DIRECTORSNAME"/><br />
	<strong>Status:</strong><xsl:text>   </xsl:text><xsl:value-of select="EXTRAINFO/FILM_STATUS_MSG"/><br />
	<strong>Film Length:</strong> <xsl:text>  </xsl:text><xsl:value-of select="EXTRAINFO/FILMLENGTH_MINS"/> mins <br />
	</div>
	<br />
	</td>
	</tr>
	</xsl:template>



	<!--
	<xsl:template match="@MORE" mode="more_index">
	Description: Presentation of the 'Next Page' link
	 -->
	<xsl:template match="@MORE" mode="more_index">
		<xsl:apply-imports/>&nbsp;<xsl:copy-of select="$next.arrow" />
	</xsl:template>
	<!--
	<xsl:template match="@MORE" mode="nomore_index">
	Description: Presentation of the 'No more pages' text
	 -->
	<xsl:template match="@MORE" mode="nomore_index">
		<xsl:apply-imports/>
	</xsl:template>
	<!--
	<xsl:template match="@SKIP" mode="previous_index">
	Description: Presentation of the 'Previous Page' link
	 -->
	<xsl:template match="@SKIP" mode="previous_index">
		<xsl:copy-of select="$previous.arrow" />&nbsp;<xsl:apply-imports/>
	</xsl:template>
	<!--
	<xsl:template match="@SKIP" mode="noprevious_index">
	Description: Presentation of the 'No previous pages' text
	 -->
	<xsl:template match="@SKIP" mode="noprevious_index">
		<xsl:apply-imports/>
	</xsl:template>
	<!--
	<xsl:template match="INDEX" mode="r_indexstatus">
	Description: Presentation of the index type selection area
	 -->
	<xsl:template match="INDEX" mode="r_indexstatus">
		<xsl:apply-templates select="." mode="t_approvedbox"/>
		<xsl:copy-of select="$m_editedentries"/>
		<xsl:text> </xsl:text>
		<xsl:apply-templates select="." mode="t_unapprovedbox"/>
		<xsl:value-of select="$m_guideentries"/>
		<xsl:text> </xsl:text>
		<xsl:apply-templates select="." mode="t_submittedbox"/>
		<xsl:value-of select="$m_awaitingappr"/>
		<xsl:text> </xsl:text>
		<xsl:apply-templates select="." mode="t_submit"/>
	</xsl:template>
	<!--
	<xsl:attribute-set name="iINDEX_t_approvedbox"/>
	Description: Attiribute set for the 'Approved' checkbox
	 -->
	<xsl:attribute-set name="iINDEX_t_approvedbox"/>
	<!--
	<xsl:attribute-set name="iINDEX_t_unapprovedbox"/>
	Description: Attiribute set for the 'Unapproved' checkbox
	 -->
	<xsl:attribute-set name="iINDEX_t_unapprovedbox"/>
	<!--
	<xsl:attribute-set name="iINDEX_t_submittedbox"/>
	Description: Attiribute set for the 'Submitted' checkbox
	 -->
	<xsl:attribute-set name="iINDEX_t_submittedbox"/>
	<!--
	<xsl:attribute-set name="iINDEX_t_submit"/>
	Description: Attiribute set for the submit button
	 -->
	<xsl:attribute-set name="iINDEX_t_submit">
		<xsl:attribute name="type">submit</xsl:attribute>
		<xsl:attribute name="value"><xsl:copy-of select="$m_refresh"/></xsl:attribute>
	</xsl:attribute-set>
</xsl:stylesheet>
