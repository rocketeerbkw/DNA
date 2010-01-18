<?xml version="1.0" encoding="iso-8859-1"?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<xsl:import href="../../../base/base-morepostspage.xsl"/>
	<!--
	MOREPOSTS_MAINBODY"
		POSTS
		POST-LIST
			owner_morepostlistempty
			viewer_morepostlistempty
			owner_morepostlist
			viewer_morepostlist
		POST		
	-->
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
									Page - Level  template
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<xsl:template name="MOREPOSTS_HEADER">
		<xsl:apply-templates mode="header" select=".">
			<xsl:with-param name="title">
				<xsl:value-of select="$m_pagetitlestart"/>
				<xsl:text>Comments</xsl:text>
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>
	
	<xsl:template name="MOREPOSTS_MAINBODY">
	
	<!-- DEBUG -->
	<xsl:call-template name="TRACE">
		<xsl:with-param name="message">MOREPOSTS_MAINBODY</xsl:with-param>
		<xsl:with-param name="pagename">morepostspage.xsl</xsl:with-param>
	</xsl:call-template>
	<!-- DEBUG -->
    <div id="topPage">
      <h2>All comments</h2>

      <!--<h3>
			<xsl:value-of select="/H2G2/ARTICLE/ARTICLEINFO/PAGEAUTHOR/EDITOR/USER/USERNAME" />
		</h3>-->
      <!--<div class="memberdate">
			&nbsp;-->
      <!-- data not available in xml -->
      <!--
		</div>-->

      <p>
        Below is a list of comments

        <xsl:choose>
          <xsl:when test="$test_OwnerIsViewer=1">you have</xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="/H2G2/POSTS/POST-LIST/USER/USERNAME"/> has
          </xsl:otherwise>
        </xsl:choose>

        made.  Click the title to read the messages
      </p>

      <!-- link to personal space -->
      <xsl:apply-templates select="POSTS" mode="t_morepostsPSlink"/>
      <br/>
      <xsl:apply-templates select="POSTS" mode="t_moderateuserlink"/>
    </div>

    <div class="tear">
      <hr/>
    </div>

    <div class="padWrapper">
      <div class="barStrong">
        <h2 class="left">Comments</h2>
        <p class="right">
          <!-- pagination nav -->
          <xsl:call-template name="MOREPOSTS_NAV"/>
        </p>
      </div>
      <div class="resultsList">

        <!-- posts -->
        <xsl:apply-templates select="POSTS" mode="c_morepostspage"/>

      </div>
      <div class="barStrong">
        <p class="left">
          <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
        </p>
        <p class="right">
          <!-- pagination nav -->
          <xsl:call-template name="MOREPOSTS_NAV"/>
        </p>
        <div class="clr">
          <hr/>
        </div>
      </div>
    </div>
    <p id="rssBlock">
      <a class="rssLink" href="{$feedroot}xml/MP{/H2G2/PAGE-OWNER/USER/USERID}?s_xml={$rss_param}&amp;s_client={$client}&amp;show={$rss_show}" id="rssLink">
        <xsl:text>Latest comments </xsl:text>
      </a>
      <xsl:text> | </xsl:text>
      <a>
        <xsl:attribute name="href">
          <xsl:value-of select="msxsl:node-set($clients)/list/item[client=$client]/rsshelp"/>
        </xsl:attribute>
        What is RSS?
      </a>
	<xsl:text> | </xsl:text>
	<a href="{$root}help#feeds">
		<xsl:text>Memoryshare RSS feeds</xsl:text>
	</a>
    </p>
	</xsl:template>
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
							POSTS Object
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<!--
	<xsl:template match="POSTS" mode="r_morepostspage">
	Description: Presentation of the object holding the latest conversations the user
	has contributed to
	 -->
	<xsl:template match="POSTS" mode="r_morepostspage">
		<xsl:apply-templates select="." mode="c_morepostlistempty"/>
		<xsl:apply-templates select="POST-LIST" mode="c_morepostspage"/>
	</xsl:template>
	<!--
	<xsl:template match="RECENT-POSTS" mode="owner_morepostlistempty">
	Description: Presentation of an empty post list where the viewer is the owner
	 -->
	<xsl:template match="POST-LIST" mode="owner_morepostlistempty">
		<xsl:copy-of select="$m_forumownerempty"/>
	</xsl:template>
	<!--
	<xsl:template match="RECENT-POSTS" mode="viewer_morepostlistempty">
	Description: Presentation of an empty post list where the viewer is not the owner
	 -->
	<xsl:template match="POST-LIST" mode="viewer_morepostlistempty">
		<xsl:copy-of select="$m_forumviewerempty"/>
	</xsl:template>
	<!--
	<xsl:template match="POST-LIST" mode="owner_morepostlist">
	Description: Presentation of a post list where the viewer is the owner
	 -->
	<xsl:template match="POST-LIST" mode="owner_morepostlist">
		<xsl:copy-of select="$m_forumownerfull"/>
		<ul class="resultList">
			<!-- was mode="c_morepostspage" -->
			<xsl:apply-templates select="POST[SITEID=$site_number]" mode="post_list_item"/>
		</ul>
	</xsl:template>
	<!--
	<xsl:template match="POST-LIST" mode="viewer_morepostlist">
	Description: Presentation of a post list where the viewer is not the owner
	 -->
	<xsl:template match="POST-LIST" mode="viewer_morepostlist">
		<xsl:copy-of select="$m_forumviewerfull"/>
		<ul class="resultList">
			<xsl:apply-templates select="POST[SITEID=$site_number]" mode="c_morepostspage"/>
		</ul>
	</xsl:template>
	<!--
	<xsl:template match="POST-LIST/POST" mode="r_morepostspage">
	Description: Presentation of a single post in a list
	 -->
	 <!--[FIXME: redundant?] -->
	<xsl:template match="POST" mode="r_morepostspage">
		<li>
			<xsl:attribute name="class">
				<xsl:if test="count(preceding-sibling::POST[SITEID=$site_number]) mod 2 = 0">odd</xsl:if>
			</xsl:attribute>
			<p>
        <xsl:text>Re: </xsl:text><a href="{$root}F{THREAD/@FORUMID}?thread={THREAD/@THREADID}"><xsl:value-of select="THREAD/FORUMTITLE"/></a>
			</p>
			<p>
				<xsl:apply-templates select="." mode="c_userpagepostdate"/>  |  <xsl:apply-templates select="." mode="c_userpagepostlastreply"/> | <xsl:value-of select="@COUNTPOSTS"/> comments
			</p>
		</li>
	</xsl:template>
	<!--
	<xsl:template match="DATE" mode="r_morepostspagepostdate">
	Description: Presentation of the 'last user post to conversation' date
	 -->
	<xsl:template match="DATE" mode="r_morepostspagepostdate">
		<xsl:apply-imports/>
	</xsl:template>
	<!--
	<xsl:template match="POST" mode="r_morepostspagepostlastreply">
	Description: Presentation of the 'last reply to post' date
	 -->
	<xsl:template match="POST" mode="r_morepostspagepostlastreply">
		<xsl:apply-templates select="." mode="t_lastreplytext"/>
		<xsl:apply-templates select="." mode="t_morepostspostlastreply"/>
	</xsl:template>
	<!--
	<xsl:template match="POST" mode="r_postunsubscribemorepostspage">
	Description: Presentation of the 'unsubscribe' from this conversation link
	 -->
	<xsl:template match="POST" mode="r_postunsubscribemorepostspage">
		<xsl:apply-imports/>
		<br/>
	</xsl:template>

	
	<!--
	<xsl:template match="POSTS" mode="r_prevmoreposts">
	Description: Presentation of the previous link
	 -->
	<xsl:template match="POSTS" mode="r_prevmoreposts">
	<xsl:choose>
		<xsl:when test="./POST-LIST[@SKIPTO &gt; 0]">
			<xsl:apply-imports/>
		</xsl:when>
		<xsl:otherwise>
		<xsl:value-of select="$m_newerpostings"/>
		</xsl:otherwise>
	</xsl:choose>
	</xsl:template>
	
	<!--
	<xsl:template match="POSTS" mode="r_nextmoreposts">
	Description: Presentation of the more link
	 -->
	<xsl:template match="POSTS" mode="r_nextmoreposts">
	<xsl:choose>
		<xsl:when test="./POST-LIST[@MORE=1]">
			<xsl:apply-imports/>
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="$m_olderpostings"/>
		</xsl:otherwise>
	</xsl:choose>
	</xsl:template>
	
	
	<xsl:template name="MOREPOSTS_NAV">
    <xsl:apply-templates select="POSTS" mode="r_prevmoreposts"/>
    <xsl:text> | </xsl:text>
    <xsl:apply-templates select="POSTS" mode="r_nextmoreposts"/>
	</xsl:template>
	
	
	
</xsl:stylesheet>
