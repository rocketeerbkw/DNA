<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">


	<xsl:template name="COMMENTFORUMLIST_JAVASCRIPT">
	</xsl:template>

	<xsl:template name="COMMENTFORUMLIST_SUBJECT">
		<xsl:call-template name="SUBJECTHEADER">
			<xsl:with-param name="text">
				Comment Forums List
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsl:template name="COMMENTFORUMLIST_HEADER">
		<xsl:apply-templates mode="header" select=".">
			<xsl:with-param name="title">
				DNA Administration - Comment Forums List
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template name="COMMENTFORUMLIST_CSS">
		<link type="text/css" rel="stylesheet" href="http://www.bbc.co.uk/dnaimages/boards/includes/admin.css"/>
	</xsl:template>


<xsl:template name="COMMENTFORUMLIST_MAINBODY">
	<xsl:call-template name="sso_statusbar-admin"/>

	<div id="subNav" style="background:#f4ebe4 url({$adminimagesource}icon_assets.gif) 0px 2px no-repeat;">
		<div id="subNavText">
			<h4> DNA Administration - Comment Forums List</h4>
		</div>
	</div>
	<br/>

	<div id="contentArea">
		<div class="centralAreaRight">
			<div class="header">
				<img src="{$adminimagesource}t_l.gif" alt=""/>
			</div>
			<div class="centralArea">

	
		<!--h1>Comment Forums List</h1-->
		<h2>for: 
		<xsl:choose>
			<xsl:when test="/H2G2/COMMENTFORUMLIST/@REQUESTEDURL">
				<xsl:value-of select="/H2G2/COMMENTFORUMLIST/@REQUESTEDURL"/>
			</xsl:when>
			<xsl:when test="/H2G2/COMMENTFORUMLIST/@REQUESTEDSITEID">
				<xsl:value-of select="/H2G2/EDITOR-SITE-LIST/SITE-LIST/SITE[@ID=/H2G2/COMMENTFORUMLIST/@REQUESTEDSITEID]/NAME"/>
			</xsl:when>
		</xsl:choose>
		</h2>
		
		<xsl:apply-templates select="skip-show" />
		
		<h3>Select Site to Filter</h3>		
		<form action="commentforumlist" method="get">
		<select name="dnasiteid">
		<option>Select DNA Site</option>
		<xsl:for-each select="/H2G2/EDITOR-SITE-LIST/SITE-LIST/SITE">
		<xsl:sort select="NAME"/>
		<option value="{@ID}">
		<xsl:if test="@ID=/H2G2/COMMENTFORUMLIST/@REQUESTEDSITEID">
			<xsl:attribute name="selected">selected</xsl:attribute>
		</xsl:if>
		<xsl:value-of select="NAME"/>
		</option>
		</xsl:for-each>
		</select>
		<br />
		<input type="Submit" value="Select Site"/>
		</form>
		<h3>OR... Enter BBC URL to Filter</h3>		
		<form action="commentforumlist" method="get">
		<p>enter full url, including <b>http://</b></p>
		<input type="text" name="dnahostpageurl" style="width:300px;">
		<xsl:attribute name="value">
			<xsl:choose>
				<xsl:when test="/H2G2/COMMENTFORUMLIST/@REQUESTEDURL"><xsl:value-of select="/H2G2/COMMENTFORUMLIST/@REQUESTEDURL"/></xsl:when>
			<xsl:otherwise>http://www.bbc.co.uk/</xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>
		</input>
		<input type="Submit" value="Filter Site"/>
		</form>

		<p>Forum list Count : <xsl:value-of select="/H2G2/COMMENTFORUMLIST/@COMMENTFORUMLISTCOUNT"/></p>
		<style>
		.cfl-skip-show li {float:left; margin:2px; padding:2px; border:1px solid #000033; list-style:none; font-weight:normal; font-size:70%;}
		#commentforumlist {font-size:80%;}
		</style>
		<ul class="cfl-skip-show">
		<xsl:call-template name="cfl-skip-show"/>
		</ul>
		<br clear="all" />
		<table border="1" cellpadding="2" id="commentforumlist">
		<thead>
			<th>Host Page URL</th>
			<th>Title</th>
			<th>Forum ID</th>
			<th>Site ID</th>
			<th>UID</th>
			<th>Comment Count</th>
			<th>Mod Status</th>
			<th>Open/Close</th>
			<th>Close Date</th>
			<th>Change Mod Status</th>
			<th>Change Close Date</th>
			<th>Open or Close Forum</th>
		</thead>
		<tbody>
			<xsl:apply-templates select="/H2G2/COMMENTFORUMLIST/COMMENTFORUM" />
		</tbody>
		<tfoot>
		</tfoot>
		</table>
		<br clear="all" />
		<ul class="cfl-skip-show">
		<xsl:call-template name="cfl-skip-show"/>
		</ul>
		<br clear="all" />
			</div>
		</div>	
		<div class="footer">
		</div>	
	</div>							
		
</xsl:template>

	<xsl:template match="COMMENTFORUM">
		<tr>
		<td><xsl:value-of select="HOSTPAGEURL"/></td>
		<td><xsl:value-of select="TITLE"/></td>
		<td><xsl:value-of select="@FORUMID"/></td>
		<td><xsl:value-of select="SITEID"/></td>
		<td><xsl:value-of select="@UID"/></td>
		<td><xsl:value-of select="@FORUMPOSTCOUNT"/></td>
		<td>
		<xsl:choose>
			<xsl:when test="MODSTATUS='0'">Undefined</xsl:when>
			<xsl:when test="MODSTATUS='1'">Reactive</xsl:when>
			<xsl:when test="MODSTATUS='2'">Post Moderated</xsl:when>
			<xsl:when test="MODSTATUS='3'">Pre Moderated</xsl:when>
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
		</td>
		<td><xsl:choose>
			<xsl:when test="@CANWRITE=1">Open</xsl:when>
			<xsl:when test="@CANWRITE=0">Closed</xsl:when>
		</xsl:choose></td>
		<td>
		<xsl:apply-templates select="CLOSEDATE/DATE" mode="dc" />
		</td>
		<td>
		<form action="commentforumlist" method="get">
		<input type="hidden" name="dnauid" value="{@UID}" />
		<input type="hidden" name="dnaaction" value="update" />
		<label for="dnanewmodstatus1{@UID}">
		<input type="radio" name="dnanewmodstatus" value="reactive" id="dnanewmodstatus1{@UID}"><xsl:if test="MODSTATUS=1"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if></input> Reactive<br /></label>
		<label for="dnanewmodstatus2{@UID}">
		<input type="radio" name="dnanewmodstatus" value="postmod" id="dnanewmodstatus2{@UID}"><xsl:if test="MODSTATUS=2"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if></input> Post Moderated<br /></label>
		<label for="dnanewmodstatus3{@UID}">
		<input type="radio" name="dnanewmodstatus" value="premod" id="dnanewmodstatus3{@UID}"><xsl:if test="MODSTATUS=3"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if></input> Pre Moderated<br /></label>
		<input type="hidden" name="dnasiteid" value="{/H2G2/COMMENTFORUMLIST/@REQUESTEDSITEID}" />
		<input type="hidden" name="dnahostpageurl" value="{/H2G2/COMMENTFORUMLIST/@REQUESTEDURL}" />
		<input type="hidden" name="dnaskip" value="{/H2G2/COMMENTFORUMLIST/@SKIP}" />
		<input type="hidden" name="dnashow" value="{/H2G2/COMMENTFORUMLIST/@SHOW}" />
		<input type="submit" value="update" />
		</form>
		</td>
		<td>
		<form action="commentforumlist" method="get">
		<input type="hidden" name="dnauid" value="{@UID}" />
		<input type="hidden" name="dnaaction" value="update" />
		<label for="dnanewforumclosedate{@UID}">
		YYYYMMDD<br />
		<input type="text" name="dnanewforumclosedate" id="dnanewforumclosedate{@UID}" />
		</label>
		<input type="hidden" name="dnasiteid" value="{/H2G2/COMMENTFORUMLIST/@REQUESTEDSITEID}" />
		<input type="hidden" name="dnahostpageurl" value="{/H2G2/COMMENTFORUMLIST/@REQUESTEDURL}" />
		<input type="hidden" name="dnaskip" value="{/H2G2/COMMENTFORUMLIST/@SKIP}" />
		<input type="hidden" name="dnashow" value="{/H2G2/COMMENTFORUMLIST/@SHOW}" />
		<input type="submit" value="update" />
		</form>
		</td>
		<td>
		<form action="commentforumlist" method="get">
		<input type="hidden" name="dnauid" value="{@UID}" />
		<input type="hidden" name="dnaaction" value="update" />
		<label for="dnanewcanwrite1{@UID}">
		<input type="radio" name="dnanewcanwrite" value="1" id="dnanewcanwrite1{@UID}"><xsl:if test="@CANWRITE=1"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if></input> Open<br />
		</label>
		<label for="dnanewcanwrite0{@UID}">
		<input type="radio" name="dnanewcanwrite" value="0" id="dnanewcanwrite0{@UID}"><xsl:if test="@CANWRITE=0"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if></input> Close<br />
		</label>
		<input type="hidden" name="dnasiteid" value="{/H2G2/COMMENTFORUMLIST/@REQUESTEDSITEID}" />
		<input type="hidden" name="dnahostpageurl" value="{/H2G2/COMMENTFORUMLIST/@REQUESTEDURL}" />
		<input type="hidden" name="dnaskip" value="{/H2G2/COMMENTFORUMLIST/@SKIP}" />
		<input type="hidden" name="dnashow" value="{/H2G2/COMMENTFORUMLIST/@SHOW}" />
		<input type="submit" value="update" />
		</form>
		</td>
		</tr>
</xsl:template>

	
	<xsl:template name="cfl-skip-show">

	<xsl:param name="comments_per_page" select="/H2G2/COMMENTFORUMLIST/@SHOW"/>
	<xsl:param name="page_count" select="ceiling(/H2G2/COMMENTFORUMLIST/@COMMENTFORUMLISTCOUNT div /H2G2/COMMENTFORUMLIST/@SHOW)"/>
	<xsl:param name="page_label" select="1"/>
	
	<xsl:variable name="skip" select="/H2G2/COMMENTFORUMLIST/@SKIP" />
	<xsl:variable name="show" select="/H2G2/COMMENTFORUMLIST/@SHOW" />


		<xsl:variable name="total_list_count" select="/H2G2/COMMENTFORUMLIST/@COMMENTFORUMLISTCOUNT" />
		<xsl:variable name="page_count_total" select="ceiling(/H2G2/COMMENTFORUMLIST/@COMMENTFORUMLISTCOUNT div /H2G2/COMMENTFORUMLIST/@SHOW)"/>

		<xsl:variable name="current_page" select="($skip div $show) + 1"/>

		<xsl:variable name="nav_range" select="10" /><!-- set for navigation range -->

		<xsl:variable name="nav_start" select="floor(($current_page - 1) div $nav_range) * $nav_range"/>
		<xsl:variable name="nav_end" select="$nav_start + $nav_range"/>

    <!--<li>
      <xsl:value-of select="concat('pagecount:',$page_count,' pagelabel:',$page_label, ' navstart:',$nav_start,' navend:',$nav_end)"/>
    </li>-->
    <xsl:if test="$page_label = 1">
		<p>page <xsl:value-of select="$current_page"/> of <xsl:value-of select="$page_count_total"/></p>
			<li>
			<xsl:choose>
		    <xsl:when test="$current_page > 1">
			<a href="commentforumlist?dnaskip=0&amp;dnashow={$show}&amp;dnasiteid={/H2G2/COMMENTFORUMLIST/@REQUESTEDSITEID}&amp;dnahostpageurl={/H2G2/COMMENTFORUMLIST/@REQUESTEDURL}">first page</a>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>first page</xsl:text>
			</xsl:otherwise>
			</xsl:choose>
			</li>	

			<li>
			<xsl:choose>
			<xsl:when test="$current_page > 1">
			<a href="commentforumlist?dnaskip={$skip - $show}&amp;dnashow={$show}&amp;dnasiteid={/H2G2/COMMENTFORUMLIST/@REQUESTEDSITEID}&amp;dnahostpageurl={/H2G2/COMMENTFORUMLIST/@REQUESTEDURL}">previous page</a>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>previous page</xsl:text>
			</xsl:otherwise>
			</xsl:choose>
			</li>

			<li>
			<xsl:choose>
	 	    <xsl:when test="$current_page > $nav_range">
			<a href="commentforumlist?dnaskip={($nav_start - 1) * $show}&amp;dnashow={$show}&amp;dnasiteid={/H2G2/COMMENTFORUMLIST/@REQUESTEDSITEID}&amp;dnahostpageurl={/H2G2/COMMENTFORUMLIST/@REQUESTEDURL}"><xsl:value-of select="concat('previous ',$nav_range)" /></a>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="concat('previous ',$nav_range)" />
			</xsl:otherwise>
			</xsl:choose>
			</li>
			
		</xsl:if>

	    <xsl:if test="($page_count > 0) and ($page_label &lt;= $nav_end)">
		    <xsl:if test="($page_label > $nav_start) and ($page_label &lt;= $nav_end)">
		
			<li>
			<a href="commentforumlist?dnaskip={($page_label * $show) - $show}&amp;dnashow={$show}&amp;dnasiteid={/H2G2/COMMENTFORUMLIST/@REQUESTEDSITEID}&amp;dnahostpageurl={/H2G2/COMMENTFORUMLIST/@REQUESTEDURL}"><xsl:value-of select="$page_label" /></a>
			</li>
			</xsl:if>
        <xsl:choose>
          <xsl:when test="$page_label &lt;= $nav_start">
            <xsl:call-template name="cfl-skip-show">
              <xsl:with-param name="page_count" select="$page_count_total - $nav_start"/>
              <xsl:with-param name="page_label" select="$nav_start + 1"/>
            </xsl:call-template>

          </xsl:when>
          <xsl:otherwise>
          <xsl:call-template name="cfl-skip-show">
            <xsl:with-param name="page_count" select="$page_count - 1"/>
            <xsl:with-param name="page_label" select="$page_label + 1"/>
          </xsl:call-template>
          </xsl:otherwise>
        </xsl:choose>
		</xsl:if>

	    <xsl:if test="$page_label = ($nav_end + 1)">
			<li>
			<xsl:choose>
			<xsl:when test="$page_count_total > $current_page">
				<a href="commentforumlist?dnaskip={$current_page * $show}&amp;dnashow={$show}&amp;dnasiteid={/H2G2/COMMENTFORUMLIST/@REQUESTEDSITEID}&amp;dnahostpageurl={/H2G2/COMMENTFORUMLIST/@REQUESTEDURL}">next page</a>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>next page</xsl:text>
			</xsl:otherwise>
			</xsl:choose>
			</li>

			<li>
			<xsl:choose>
	 	    <xsl:when test="$page_count_total > $nav_end"> 
			<a href="commentforumlist?dnaskip={$nav_end * $show}&amp;dnashow={$show}&amp;dnasiteid={/H2G2/COMMENTFORUMLIST/@REQUESTEDSITEID}&amp;dnahostpageurl={/H2G2/COMMENTFORUMLIST/@REQUESTEDURL}"><xsl:value-of select="concat('next ',$nav_range)" /></a>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="concat('next ',$nav_range)" />
			</xsl:otherwise>
			</xsl:choose>
			</li>
			
			<li>
			<xsl:choose>
		    <xsl:when test="$page_count_total > $current_page">
				<a href="commentforumlist?dnaskip={($page_count_total * $show) - $show}&amp;dnashow={$show}&amp;dnasiteid={/H2G2/COMMENTFORUMLIST/@REQUESTEDSITEID}&amp;dnahostpageurl={/H2G2/COMMENTFORUMLIST/@REQUESTEDURL}">last page</a>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>last page</xsl:text>
			</xsl:otherwise>
			</xsl:choose>
			</li>
		</xsl:if>

	</xsl:template>

</xsl:stylesheet>
