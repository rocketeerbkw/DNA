<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	version="1.0" 
	xmlns:doc="http://www.bbc.co.uk/dna/documentation" 
	xmlns="http://www.w3.org/1999/xhtml" 
	exclude-result-prefixes="doc">
	
	<doc:documentation>
		<doc:purpose>
			
		</doc:purpose>
		<doc:context>
			
		</doc:context>
		<doc:notes>
			
		</doc:notes>
	</doc:documentation>
	
	<xsl:template match="H2G2[@TYPE = 'COMMENTFORUMLIST']" mode="page">
    <div class="dna-mb-intro">
      <h2>Comment Forum List</h2>
    </div>

    <div class="dna-main blq-clearfix">
      <div class="dna-fl dna-main-full">

          <xsl:apply-templates select="skip-show" />
        Enter BBC URL to Filter, including <b>http://</b>
        <form action="commentforumlist" method="get">
            <input type="text" name="dnahostpageurl" style="width:300px;">
              <xsl:attribute name="value">
                <xsl:choose>
                  <xsl:when test="/H2G2/COMMENTFORUMLIST/@REQUESTEDURL">
                    <xsl:value-of select="/H2G2/COMMENTFORUMLIST/@REQUESTEDURL"/>
                  </xsl:when>
                  <xsl:otherwise>http://www.bbc.co.uk/</xsl:otherwise>
                </xsl:choose>
              </xsl:attribute>
            </input>
            <input type="Submit" value="Filter Site"/>
          </form>

          <p>
            Forum list Count : <xsl:value-of select="/H2G2/COMMENTFORUMLIST/@COMMENTFORUMLISTCOUNT"/>
          </p>
          <style>
            .cfl-skip-show li {float:left; margin:2px; padding:2px; border:1px solid #000033; list-style:none; font-weight:normal; font-size:70%;}
            #commentforumlist {font-size:80%;}
          </style>
        <xsl:if test="/H2G2/COMMENTFORUMLIST/@COMMENTFORUMLISTCOUNT != 0">
          <ul class="cfl-skip-show">
            <xsl:call-template name="cfl-skip-show"/>
          </ul>
          <br clear="all" />
          <table border="1" cellpadding="2" id="commentforumlist">
            <thead>
              <th>Host Page URL</th>
              <th>Title</th>
              <th>Forum ID</th>
              <th>UID</th>
              <th>Comment Count</th>
              <th>Mod Status</th>
              <th>Open/Close</th>
              <th>Close Date</th>
              <th>Fast Moderation</th>
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
        </xsl:if>
        </div>
    </div>

  </xsl:template>

  <xsl:template match="COMMENTFORUM">
    <tr>
      <td style="text-align: center">
        <a target="_blank">
          <xsl:attribute name="href">
            <xsl:value-of select="HOSTPAGEURL"/>
          </xsl:attribute>
          <xsl:value-of select="HOSTPAGEURL"/>
        </a>
      </td>
      <td style="text-align: center">
        <xsl:value-of select="TITLE"/>
      </td>
      <td style="text-align: center">
        <xsl:value-of select="@FORUMID"/>
      </td>
      <td style="text-align: center;">
        <xsl:value-of select="@UID"/>
      </td>
      <td style="text-align: center">
        <xsl:value-of select="@FORUMPOSTCOUNT"/>
      </td>

      <td>
        <form action="commentforumlist" method="get">
          <input type="hidden" name="dnauid" value="{@UID}" />
          <input type="hidden" name="dnaaction" value="update" />
          <label for="dnanewmodstatus1{@UID}">
            <input type="radio" name="dnanewmodstatus" value="reactive" id="dnanewmodstatus1{@UID}">
              <xsl:if test="MODSTATUS=1">
                <xsl:attribute name="checked">checked</xsl:attribute>
              </xsl:if>
            </input> Reactive<br />
          </label>
          <label for="dnanewmodstatus2{@UID}">
            <input type="radio" name="dnanewmodstatus" value="postmod" id="dnanewmodstatus2{@UID}">
              <xsl:if test="MODSTATUS=2">
                <xsl:attribute name="checked">checked</xsl:attribute>
              </xsl:if>
            </input> Post Moderated<br />
          </label>
          <label for="dnanewmodstatus3{@UID}">
            <input type="radio" name="dnanewmodstatus" value="premod" id="dnanewmodstatus3{@UID}">
              <xsl:if test="MODSTATUS=3">
                <xsl:attribute name="checked">checked</xsl:attribute>
              </xsl:if>
            </input> Pre Moderated<br />
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
          <label for="dnanewforumclosedate{@UID}">
            <span style="font-size:6pt">Format: YYYYMMDD</span><br />
            <input type="text" name="dnanewforumclosedate" id="dnanewforumclosedate{@UID}" value="{CLOSEDATE/DATE/@YEAR}{CLOSEDATE/DATE/@MONTH}{CLOSEDATE/DATE/@DAY}" style="width:60px" />
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
            <input type="radio" name="dnanewcanwrite" value="1" id="dnanewcanwrite1{@UID}">
              <xsl:if test="@CANWRITE=1">
                <xsl:attribute name="checked">checked</xsl:attribute>
              </xsl:if>
            </input> Open<br />
          </label>
          <label for="dnanewcanwrite0{@UID}">
            <input type="radio" name="dnanewcanwrite" value="0" id="dnanewcanwrite0{@UID}">
              <xsl:if test="@CANWRITE=0">
                <xsl:attribute name="checked">checked</xsl:attribute>
              </xsl:if>
            </input> Close<br />
          </label>
          <input type="hidden" name="dnasiteid" value="{/H2G2/COMMENTFORUMLIST/@REQUESTEDSITEID}" />
          <input type="hidden" name="dnahostpageurl" value="{/H2G2/COMMENTFORUMLIST/@REQUESTEDURL}" />
          <input type="hidden" name="dnaskip" value="{/H2G2/COMMENTFORUMLIST/@SKIP}" />
          <input type="hidden" name="dnashow" value="{/H2G2/COMMENTFORUMLIST/@SHOW}" />
          <input type="submit" value="update" />
        </form>
      </td>
      <td style="text-align: center;">
        <form action="commentforumlist" method="get">
          <input type="hidden" name="dnauid" value="{@UID}" />
          <input type="hidden" name="dnaaction" value="update" />
          
          <label for="dnafastmod{@UID}">
            <select name="dnafastmod" id="dnafastmod{@UID}">
               <xsl:if test="FASTMOD='1'">
                <option value="enabled"><xsl:attribute name="selected">true</xsl:attribute>Enabled</option>
                <option value="disabled">Disabled</option>
              </xsl:if>
              <xsl:if test="FASTMOD='0'">
                <option value="enabled">Enabled</option>
                <option value="disabled"><xsl:attribute name="selected">true</xsl:attribute>Disabled</option>
              </xsl:if>
            </select>
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

    <xsl:variable name="nav_range" select="10" />
    <!-- set for navigation range -->

    <xsl:variable name="nav_start" select="floor(($current_page - 1) div $nav_range) * $nav_range"/>
    <xsl:variable name="nav_end" select="$nav_start + $nav_range"/>

    <!--<li>
      <xsl:value-of select="concat('pagecount:',$page_count,' pagelabel:',$page_label, ' navstart:',$nav_start,' navend:',$nav_end)"/>
    </li>-->
    <xsl:if test="$page_label = 1">
      <p>
        Page <xsl:value-of select="$current_page"/> of <xsl:value-of select="$page_count_total"/>
      </p>
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
            <a href="commentforumlist?dnaskip={($nav_start - 1) * $show}&amp;dnashow={$show}&amp;dnasiteid={/H2G2/COMMENTFORUMLIST/@REQUESTEDSITEID}&amp;dnahostpageurl={/H2G2/COMMENTFORUMLIST/@REQUESTEDURL}">
              <xsl:value-of select="concat('previous ',$nav_range)" />
            </a>
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
          <a href="commentforumlist?dnaskip={($page_label * $show) - $show}&amp;dnashow={$show}&amp;dnasiteid={/H2G2/COMMENTFORUMLIST/@REQUESTEDSITEID}&amp;dnahostpageurl={/H2G2/COMMENTFORUMLIST/@REQUESTEDURL}">
            <xsl:value-of select="$page_label" />
          </a>
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
            <a href="commentforumlist?dnaskip={$nav_end * $show}&amp;dnashow={$show}&amp;dnasiteid={/H2G2/COMMENTFORUMLIST/@REQUESTEDSITEID}&amp;dnahostpageurl={/H2G2/COMMENTFORUMLIST/@REQUESTEDURL}">
              <xsl:value-of select="concat('next ',$nav_range)" />
            </a>
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
