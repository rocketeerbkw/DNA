<?xml version='1.0' encoding='ISO-8859-1' ?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0" 
                xmlns:msxsl="urn:schemas-microsoft-com:xslt" 
                xmlns:local="#local-functions" 
                xmlns:s="urn:schemas-microsoft-com:xml-data" 
                xmlns:dt="urn:schemas-microsoft-com:datatypes">

<xsl:template name="USERPAGE_TITLE">
	<title>
		<xsl:value-of select="$m_pagetitlestart"/>
		<xsl:choose>
			<xsl:when test="ARTICLE/SUBJECT">
				<xsl:value-of select="ARTICLE/SUBJECT"/> - U<xsl:value-of select="PAGE-OWNER/USER/USERID"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="$ownerisviewer = 1">
						<xsl:value-of select="$m_pstitleowner"/>
						<xsl:value-of select="PAGE-OWNER/USER/USERNAME"/>.
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$m_pstitleviewer"/>
						<xsl:value-of select="PAGE-OWNER/USER/USERID"/>.
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</title>
</xsl:template>

<xsl:template name="USERPAGE_TITLEDATA">
	<xsl:variable name="nu_inlinecheck"><xsl:value-of select="$m_userdataref"/><xsl:value-of select="/H2G2/PAGE-OWNER/USER/USERID"/></xsl:variable>
	<font xsl:use-attribute-sets="smallfont">
		<xsl:choose>
			<xsl:when test="/H2G2/PAGE-OWNER/USER/USERNAME = $nu_inlinecheck">
				<b><xsl:value-of select="$m_userdatano"/></b><xsl:value-of select="/H2G2/PAGE-OWNER/USER/USERID"/>
			</xsl:when>
			<xsl:otherwise>
				<b><xsl:value-of select="$m_userdata"/></b><xsl:value-of select="substring(/H2G2/PAGE-OWNER/USER/USERNAME,1,25)"/><xsl:if test="string-length(/H2G2/PAGE-OWNER/USER/USERNAME) &gt; 25">...</xsl:if><b> [<xsl:value-of select="$m_userdatano"/></b><xsl:value-of select="/H2G2/PAGE-OWNER/USER/USERID"/><b>]</b>
			</xsl:otherwise>
		</xsl:choose>
	</font>
	<br clear="ALL" /><img src="{$imagesource}t.gif" width="1" height="8" alt="" /><br clear="ALL" />
</xsl:template>

<xsl:template name="USERPAGE_SUBJECT">
<!-- Override SUBJECTHEADER font for this 'special' case -->
	<font xsl:use-attribute-sets="headerfont">
		<xsl:attribute name="size">6</xsl:attribute>
		<b>
			Personal Space
<!--
			<xsl:choose>
				<xsl:when test="ARTICLE/ARTICLEINFO[HIDDEN='1']">
					<xsl:value-of select="$m_userpagemoderatesubject"/>
				</xsl:when>
				<xsl:when test="ARTICLE/SUBJECT">
					<xsl:value-of select="substring(ARTICLE/SUBJECT,1,25)"/>
					<xsl:if test="string-length(ARTICLE/SUBJECT) &gt; 25">...</xsl:if>
				</xsl:when>
				<xsl:otherwise>
					<xsl:choose>
						<xsl:when test="$ownerisviewer = 1">
							<xsl:value-of select="substring(PAGE-OWNER/USER/USERNAME,1,25)"/>
							<xsl:if test="string-length(PAGE-OWNER/USER/USERNAME) &gt; 25">...</xsl:if>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$m_researchersub"/><xsl:value-of select="PAGE-OWNER/USER/USERID"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
-->
		</b>
	</font> 
</xsl:template>

<xsl:template name="USERPAGE_MAINBODY">
	<xsl:variable name="mymessage">
		<xsl:if test="$ownerisviewer=1">
			<xsl:value-of select="$m_mymessage"/>
			<xsl:text> </xsl:text>
		</xsl:if>
	</xsl:variable>
	<xsl:if test="/H2G2/ARTICLE/ERROR">
		<xsl:choose>
			<xsl:when test="$ownerisviewer = 1">
				<xsl:call-template name="m_pserrorowner"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="m_pserrorviewer"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:if>
	<xsl:if test="$ownerisviewer = 1">
	<xsl:if test="not($test_introarticle)">
		<table width="100%" cellspacing="0" cellpadding="6" border="0">
		<tr>
			<td>
		<font xsl:use-attribute-sets="mainfont">
		<xsl:call-template name="m_perspace_nointro"/>
		</font>
		</td>
		</tr>
		</table>
	</xsl:if>
		<xsl:call-template name="nuskin-jumpbar">
			<xsl:with-param name="jbarname">conv</xsl:with-param>
			<xsl:with-param name="jbartitle"><xsl:value-of select="$m_jbartitle_conv"/></xsl:with-param>
		</xsl:call-template>
		<xsl:apply-templates select="RECENT-POSTS" />
		<br />
		<xsl:call-template name="nuskin-jumpbar">
			<xsl:with-param name="jbarname">msgs</xsl:with-param>
			<xsl:with-param name="jbartitle"><xsl:value-of select="$m_jbartitle_msg"/></xsl:with-param>
		</xsl:call-template>
		<xsl:choose>
			<xsl:when test="/H2G2/ARTICLEFORUM/FORUMTHREADS"><xsl:apply-templates select="/H2G2/ARTICLEFORUM/FORUMTHREADS" /></xsl:when>
			<xsl:otherwise><font xsl:use-attribute-sets="mainfont">
				<xsl:call-template name="forum-empty">
					<xsl:with-param name="addlink"><xsl:value-of select="$m_leavemessage"/></xsl:with-param>
					<xsl:with-param name="addmessage"><xsl:value-of select="$m_firsttoleavemessage"/></xsl:with-param>
				</xsl:call-template>
			</font></xsl:otherwise>
		</xsl:choose>
		<br />
	</xsl:if>
	<xsl:if test="$ownerisviewer = 0">
		<xsl:call-template name="nuskin-jumpbar">
			<xsl:with-param name="jbarname">abme</xsl:with-param>
			<xsl:with-param name="jbartitle"><xsl:value-of select="$m_jbartitle_abme"/></xsl:with-param>
		</xsl:call-template>
		<table width="100%" cellspacing="0" cellpadding="0" border="0" bgcolor="#000000">
			<tr><td><img src="{$imagesource}t.gif" width="1" height="1" alt="" /></td></tr>
		</table>
		<xsl:call-template name="ABOUTME" />
		<table width="100%" cellspacing="0" cellpadding="0" border="0" bgcolor="#000000">
			<tr><td><img src="{$imagesource}t.gif" width="1" height="1" alt="" /></td></tr>
		</table>
	</xsl:if>
</xsl:template>

<xsl:template name="USERPAGE_SIDEBAR">
</xsl:template>

<xsl:template name="USERPAGE_MIDDLE">
	<xsl:if test="$ownerisviewer = 0">
		<table width="100%" cellspacing="0" cellpadding="0" border="0" style="margin:0px;">
			<tr valign="top">
				<xsl:call-template name="nuskin-dummynav"/>
				<td width="100%" bgcolor="#000000">
					<xsl:call-template name="nuskin-jumpbar">
						<xsl:with-param name="jbarname">conv</xsl:with-param>
						<xsl:with-param name="jbartitle"><xsl:value-of select="$m_jbartitle_conv"/></xsl:with-param>
					</xsl:call-template>
					<table width="100%" cellspacing="0" cellpadding="0" border="0" bgcolor="#000000">
						<tr><td><img src="{$imagesource}t.gif" width="1" height="1" alt="" /></td></tr>
					</table>
					<xsl:apply-templates select="RECENT-POSTS" />
				</td>
			</tr>
		</table>
		<table width="100%" cellspacing="0" cellpadding="0" border="0" style="margin:0px;">
			<tr valign="top">
				<xsl:call-template name="nuskin-dummynav"/>
				<td width="100%" bgcolor="#000000">
					<xsl:call-template name="nuskin-jumpbar">
						<xsl:with-param name="jbarname">msgs</xsl:with-param>
						<xsl:with-param name="jbartitle"><xsl:value-of select="$m_jbartitle_msg"/></xsl:with-param>
					</xsl:call-template>
					<table width="100%" cellspacing="0" cellpadding="0" border="0" bgcolor="#000000">
						<tr><td><img src="{$imagesource}t.gif" width="1" height="1" alt="" /></td></tr>
					</table>
					<xsl:choose>
						<xsl:when test="/H2G2/ARTICLEFORUM/FORUMTHREADS"><xsl:apply-templates select="/H2G2/ARTICLEFORUM/FORUMTHREADS" /></xsl:when>
						<xsl:otherwise><font xsl:use-attribute-sets="mainfont">
							<xsl:call-template name="forum-empty">
								<xsl:with-param name="addlink"><xsl:value-of select="$m_leavemessage"/></xsl:with-param>
								<xsl:with-param name="addmessage"><xsl:value-of select="$m_firsttoleavemessage"/></xsl:with-param>
							</xsl:call-template>
						</font></xsl:otherwise>
					</xsl:choose>
				</td>
			</tr>
		</table>
	</xsl:if>
	<table width="100%" cellspacing="0" cellpadding="0" border="0" style="margin:0px;">
		<tr valign="top">
			<xsl:call-template name="nuskin-dummynav"/>
			<td width="100%" bgcolor="#000000">
				<xsl:call-template name="nuskin-jumpbar">
					<xsl:with-param name="jbarname">jour</xsl:with-param>
					<xsl:with-param name="jbartitle"><xsl:value-of select="$m_jbartitle_jour"/></xsl:with-param>
				</xsl:call-template>
				<table width="100%" cellspacing="0" cellpadding="0" border="0" bgcolor="#000000">
					<tr><td><img src="{$imagesource}t.gif" width="1" height="1" alt="" /></td></tr>
				</table>
				<xsl:apply-templates select="JOURNAL" />
			</td>
		</tr>
	</table>
	<table width="100%" cellspacing="0" cellpadding="0" border="0" style="margin:0px;">
		<tr valign="top">
			<xsl:call-template name="nuskin-dummynav"/>
			<td width="100%" bgcolor="#000000">
				<xsl:call-template name="nuskin-jumpbar">
					<xsl:with-param name="jbarname">frie</xsl:with-param>
					<xsl:with-param name="jbartitle"><xsl:value-of select="$m_jbartitle_frie"/></xsl:with-param>
				</xsl:call-template>
				<table width="100%" cellspacing="0" cellpadding="0" border="0" bgcolor="#000000">
					<tr><td><img src="{$imagesource}t.gif" width="1" height="1" alt="" /></td></tr>
				</table>
				<table width="100%" cellspacing="0" cellpadding="8" border="0" bgcolor="#000000">
				<tr><td>
				<font xsl:use-attribute-sets="mainfont">
				<xsl:apply-templates select="WATCHED-USER-LIST" /><br/>
				<xsl:apply-templates select="WATCHING-USER-LIST" /><br/>
				</font>
				</td>
				</tr>
				</table>
			</td>
		</tr>
	</table>
  <xsl:apply-templates select="/H2G2/RECENT-SUBSCRIBEDARTICLES" mode="maindisplay"/>
	<table width="100%" cellspacing="0" cellpadding="0" border="0" style="margin:0px;">
		<tr valign="top">
			<xsl:call-template name="nuskin-dummynav"/>
			<td width="100%">
				<table width="100%" cellspacing="0" cellpadding="0" border="0" bgcolor="#000000">
					<tr>
						<td>
							<img src="{$imagesource}t.gif" width="1" height="1" alt="" />
						</td>
					</tr>
				</table>
				<xsl:call-template name="nuskin-jumpbar">
					<xsl:with-param name="jbarname">gent</xsl:with-param>
					<xsl:with-param name="jbartitle"><xsl:value-of select="$m_jbartitle_ents"/></xsl:with-param>
				</xsl:call-template>
				<xsl:apply-templates select="RECENT-ENTRIES" />
				<!--<xsl:apply-templates select="RECENT-APPROVALS" /> Edited out to combine tables-->
			</td>
		</tr>
	</table>
	<xsl:if test="$ownerisviewer = 1">
		<table width="100%" cellspacing="0" cellpadding="0" border="0" style="margin:0px;">
			<tr valign="top">
				<xsl:call-template name="nuskin-dummynav"/>
				<td width="100%" bgcolor="#000000">
					<xsl:call-template name="nuskin-jumpbar">
						<xsl:with-param name="jbarname">abme</xsl:with-param>
						<xsl:with-param name="jbartitle"><xsl:value-of select="$m_jbartitle_abme"/></xsl:with-param>
					</xsl:call-template>
					<table width="100%" cellspacing="0" cellpadding="0" border="0" bgcolor="#000000">
						<tr><td><img src="{$imagesource}t.gif" width="1" height="1" alt="" /></td></tr>
					</table>
					<xsl:call-template name="ABOUTME" />
				</td>
			</tr>
		</table>
	</xsl:if>
</xsl:template>

  <xsl:template match="RECENT-SUBSCRIBEDARTICLES" mode="maindisplay">
    <table width="100%" cellspacing="0" cellpadding="0" border="0" style="margin:0px;">
      <tr valign="top">
        <xsl:call-template name="nuskin-dummynav"/>
        <td width="100%">
          <table width="100%" cellspacing="0" cellpadding="0" border="0" bgcolor="#000000">
            <tr>
              <td>
                <img src="{$imagesource}t.gif" width="1" height="1" alt="" />
              </td>
            </tr>
          </table>
          <xsl:call-template name="nuskin-jumpbar">
            <xsl:with-param name="jbarname">subs</xsl:with-param>
            <xsl:with-param name="jbartitle">
              SUBSCRIBED ARTICLES
            </xsl:with-param>
          </xsl:call-template>
          <!--<xsl:apply-templates select="RECENT-APPROVALS" /> Edited out to combine tables-->
          <xsl:apply-templates select="ARTICLESUBSCRIPTIONLIST/ARTICLES" mode="subscription-table"/>
          <!--<div class="dottedline">
            &nbsp;
          </div>-->

			<xsl:if test="$ownerisviewer=1">
				<div class="morepages">
					<a href="{$root}MAS{/H2G2/PAGE-OWNER/USER/USERID}">More subscribed articles</a>
					<xsl:text> | </xsl:text>
					<a href="{$root}MUS{/H2G2/PAGE-OWNER/USER/USERID}">Your subscriptions</a>
					<xsl:text> | </xsl:text>
					<a href="{$root}MSU{/H2G2/PAGE-OWNER/USER/USERID}">Researchers who are subscribed to you</a>
				</div>
			</xsl:if>
			<xsl:if test="not($ownerisviewer=1)">
				<div class="morepages">
					<a href="{$root}MAS{/H2G2/PAGE-OWNER/USER/USERID}">
						<xsl:value-of select="/H2G2/PAGE-OWNER/USER/USERNAME"/>'s more subscribed articles</a>
					<xsl:text> | </xsl:text>
					<a href="{$root}MUS{/H2G2/PAGE-OWNER/USER/USERID}">
						<xsl:value-of select="/H2G2/PAGE-OWNER/USER/USERNAME"/>'s subscriptions</a>
					<xsl:text> | </xsl:text>
					<a href="{$root}MSU{/H2G2/PAGE-OWNER/USER/USERID}">Researchers who are subscribed to <xsl:value-of select="/H2G2/PAGE-OWNER/USER/USERNAME"/></a>
				</div>
			</xsl:if>
        </td>
      </tr>
    </table>

  </xsl:template>
  <xsl:template match="ARTICLES" mode="subscription-table">
    <div class="guideentries">
    <table>
      <col class="h2g2ID" />
      <col class="createdby" />
      <col class="title" />
      <col class="date" />
      <tr>
        <th>ID</th>
        <th>Created By</th>
        <th>Title</th>
        <th>Created</th>
      </tr>
      <xsl:apply-templates select="ARTICLE" mode="personalspace"/>
    </table>
</div>
  </xsl:template>
  <xsl:template match="ARTICLESUBSCRIPTIONLIST/ARTICLES/ARTICLE" mode="personalspace">
    <tr>
      <td>
        <a href="{$root}A{@H2G2ID}">A<xsl:value-of select="@H2G2ID"/></a>
      </td>
      <td>
        <a href="{$root}U{EDITOR/USER/USERID}">
          <xsl:value-of select="EDITOR/USER/USERNAME"/>
        </a>
      </td>
      <td>
        <a href="{$root}A{@H2G2ID}">
          <xsl:value-of select="SUBJECT"/>
        </a>
      </td>
      <td>
        <xsl:value-of select="DATECREATED/DATE/@RELATIVE"/>
      </td>
    </tr>
  </xsl:template>

<xsl:template name="nuskin-jumpbar">
	<xsl:param name="jbarname" />
	<xsl:param name="jbartitle" />
	<table width="100%" cellspacing="0" cellpadding="6" border="0" bgcolor="#333333" style="background:#CCCCCC">
		<tr>
			<td>
				<a name="{$jbarname}" /><font xsl:use-attribute-sets="smallfont" class="postxt"><b><xsl:copy-of select="$jbartitle" /></b></font><br clear="all" />
				<img src="{$imagesource}t.gif" width="125" height="1" alt="" />
			</td>
			<td align="right">
        <div class="psnav">
				
					<a href="#conv">
						<xsl:value-of select="$m_jumpbar_myconv"/>
						<!--<img src="{$imagesource}perspace/jump_conversations2.gif" width="88" height="6" alt="{$alt_jbartitle_conv}" border="0" />-->
					</a>
					<xsl:text> </xsl:text>
					<img src="{$imagesource}perspace/jump_divider.gif" width="7" height="5" alt="" border="0" />
					<a href="#msgs">
						<xsl:value-of select="$m_jumpbar_mymess"/>
						<!--<img src="{$imagesource}perspace/jump_messages.gif" width="61" height="5" alt="{$alt_jbartitle_msg}" border="0" />-->
					</a>
					<xsl:text> </xsl:text>
					<img src="{$imagesource}perspace/jump_divider.gif" width="7" height="5" alt="" border="0" />
					<a href="#jour">
						<xsl:value-of select="$m_jumpbar_myjournal"/>
						<!--<img src="{$imagesource}perspace/jump_journal.gif" width="56" height="5" alt="{$alt_jbartitle_jour}" border="0" />-->
					</a>
					<xsl:text> </xsl:text>
					<img src="{$imagesource}perspace/jump_divider.gif" width="7" height="5" alt="" border="0" />
					<a href="#frie">
						<xsl:value-of select="$m_jumpbar_myfriends"/>
						<!--<img src="{$imagesource}perspace/jump_guide_entries.gif" width="80" height="5" alt="{$alt_jbartitle_ents}" border="0" />-->
					</a>
					<xsl:text> </xsl:text>
					<img src="{$imagesource}perspace/jump_divider.gif" width="7" height="5" alt="" border="0" />
					<a href="{$root}ML{/H2G2/PAGE-OWNER/USER/USERID}">
						<xsl:value-of select="$m_jumpbar_mylinks"/>
					</a>
					<xsl:text> </xsl:text>
					<xsl:apply-templates select="/H2G2/RECENT-SUBSCRIBEDARTICLES" mode="navbarlink"/>
					<img src="{$imagesource}perspace/jump_divider.gif" width="7" height="5" alt="" border="0" />
					<a href="#gent">
						<xsl:value-of select="$m_jumpbar_myentries"/>
						<!--<img src="{$imagesource}perspace/jump_guide_entries.gif" width="80" height="5" alt="{$alt_jbartitle_ents}" border="0" />-->
					</a>
					<xsl:text> </xsl:text>
					<img src="{$imagesource}perspace/jump_divider.gif" width="7" height="5" alt="" border="0" />
					<a href="#abme">
						<xsl:value-of select="$m_jumpbar_aboutme"/>
						<!--<img src="{$imagesource}perspace/jump_about_me.gif" width="44" height="5" alt="{$alt_jbartitle_abme}" border="0" />-->
					</a>
				</div>
			</td>
		</tr>
	</table>
</xsl:template>

  <xsl:template match="RECENT-SUBSCRIBEDARTICLES" mode="navbarlink">
    <img src="{$imagesource}perspace/jump_divider.gif" width="7" height="5" alt="" border="0" />
    <a href="#subs">
      <xsl:text>SUBSCRIBED ARTICLES</xsl:text>
      <!--<img src="{$imagesource}perspace/jump_guide_entries.gif" width="80" height="5" alt="{$alt_jbartitle_ents}" border="0" />-->
    </a>
    <xsl:text> </xsl:text>

  </xsl:template>
  <xsl:template match="GROUPS">
	<xsl:apply-templates select="EDITOR"/>
	<xsl:apply-templates select="*[not(starts-with(name(), 'PROLIFICSCRIBE'))][not(name() = 'EDITOR')]"/>
	<xsl:apply-templates select="*[starts-with(name(), 'PROLIFICSCRIBE')][position() = last()]"/>
</xsl:template>

<xsl:template match="GROUPBADGE">
	<center><xsl:apply-templates/><br clear="all"/></center>
</xsl:template>

<!-- Small badges 
<xsl:attribute-set name="groupbadges">
	<xsl:attribute name="width">37</xsl:attribute>
	<xsl:attribute name="height">39</xsl:attribute>
	<xsl:attribute name="border">0</xsl:attribute>
	<xsl:attribute name="vspace">0</xsl:attribute>
	<xsl:attribute name="hspace">3</xsl:attribute>
</xsl:attribute-set> -->

<xsl:attribute-set name="groupbadges">
	<xsl:attribute name="width">130</xsl:attribute>
	<xsl:attribute name="height">111</xsl:attribute>
	<xsl:attribute name="border">0</xsl:attribute>
	<xsl:attribute name="vspace">5</xsl:attribute>
	<xsl:attribute name="hspace">0</xsl:attribute>
</xsl:attribute-set>

<!-- Small badges 
<xsl:variable name="subbadges">
	<GROUPBADGE NAME="SUBS">
		<a href="{$root}SubEditors"><img xsl:use-attribute-sets="groupbadges" src="{$imagesource}badges/small/sub_editor.gif" alt="{$alt_badge_subed}" /></a>
	</GROUPBADGE>
	<GROUPBADGE NAME="ACES">
		<a href="{$root}Aces"><img xsl:use-attribute-sets="groupbadges" src="{$imagesource}badges/small/ace.gif" alt="{$alt_badge_ace}" /></a>
	</GROUPBADGE>
	<GROUPBADGE NAME="FIELDRESEARCHERS">
		<a href="{$root}University"><img xsl:use-attribute-sets="groupbadges" src="{$imagesource}badges/small/field_researcher.gif" alt="{$alt_badge_fres}" /></a>
	</GROUPBADGE>
	<GROUPBADGE NAME="GURUS">
		<a href="{$root}Gurus"><img xsl:use-attribute-sets="groupbadges" src="{$imagesource}badges/small/guru.gif" alt="{$alt_badge_guru}" /></a>
	</GROUPBADGE>
	<GROUPBADGE NAME="SCOUTS">
		<a href="{$root}Scouts"><img xsl:use-attribute-sets="groupbadges" src="{$imagesource}badges/small/scout.gif" alt="{$alt_badge_scout}" /></a>
	</GROUPBADGE>
	<GROUPBADGE NAME="EDITOR">
		<a href="{$root}Scouts"><img xsl:use-attribute-sets="groupbadges" src="{$imagesource}badges/small/editor.gif" alt="{$alt_badge_ed}" /></a>
	</GROUPBADGE>
	<GROUPBADGE NAME="ARTISTS">
		<a href="{$root}Scouts"><img xsl:use-attribute-sets="groupbadges" src="{$imagesource}badges/small/communityartist.gif" alt="{$alt_badge_comart}" /></a>
	</GROUPBADGE>
	<GROUPBADGE NAME="POSTREPORTERS">
		<a href="{$root}Scouts"><img xsl:use-attribute-sets="groupbadges" src="{$imagesource}badges/small/postreporter.gif" alt="{$alt_badge_postr}" /></a>
	</GROUPBADGE>
	<GROUPBADGE NAME="TRANSLATOR">
		<a href="{$root}Scouts"><img xsl:use-attribute-sets="groupbadges" src="{$imagesource}badges/small/translator.gif" alt="{$alt_badge_trans}" /></a>
	</GROUPBADGE>
</xsl:variable> -->

<xsl:variable name="subbadges">
	<GROUPBADGE NAME="SUBS">
		<a href="{$root}SubEditors">
			<img xsl:use-attribute-sets="groupbadges" src="{$imagesource}badges/big/n_subeditor.gif" alt="{$alt_badge_subed}" width="75" height="166" />
		</a>
	</GROUPBADGE>
	<GROUPBADGE NAME="ACES">
		<a href="{$root}Aces">
			<img xsl:use-attribute-sets="groupbadges" src="{$imagesource}badges/big/n_ace.gif" alt="{$alt_badge_ace}" width="75" height="166" />
		</a>
	</GROUPBADGE>
  <GROUPBADGE NAME="AVIATORS">
    <a href="{$root}Aviators">
      <img xsl:use-attribute-sets="groupbadges" src="{$imagesource}badges/big/aviator.jpg" alt="Aviators group" width="75" height="166" />
    </a>
  </GROUPBADGE>
  <GROUPBADGE NAME="FIELDRESEARCHERS">
		<a href="{$root}University">
			<img xsl:use-attribute-sets="groupbadges" src="{$imagesource}badges/big/n_fieldresearcher.gif" alt="{$alt_badge_fres}" width="75" height="166"/>
		</a>
	</GROUPBADGE>
	<GROUPBADGE NAME="GURUS">
		<a href="{$root}Gurus">
			<img xsl:use-attribute-sets="groupbadges" src="{$imagesource}badges/big/n_guru.gif" alt="{$alt_badge_guru}" width="75" height="166"/>
		</a>
	</GROUPBADGE>
	<GROUPBADGE NAME="SCOUTS">
		<a href="{$root}Scouts">
			<img xsl:use-attribute-sets="groupbadges" src="{$imagesource}badges/big/n_scout.gif" alt="{$alt_badge_scout}" width="75" height="166"/>
		</a>
	</GROUPBADGE>
	<GROUPBADGE NAME="EDITOR">
		<a href="{$root}Team">
			<img xsl:use-attribute-sets="groupbadges" src="{$imagesource}badges/big/n_staff.gif" alt="{$alt_badge_ed}" width="75" height="166"/>
		</a>
	</GROUPBADGE>
	<GROUPBADGE NAME="COMMUNITYARTISTS">
		<a href="{$root}CommunityArtists">
			<img xsl:use-attribute-sets="groupbadges" src="{$imagesource}badges/big/n_artist.gif" alt="{$alt_badge_comart}" width="75" height="166"/>
		</a>
	</GROUPBADGE>
	<GROUPBADGE NAME="POSTREPORTERS">
		<a href="{$root}ThePost">
			<img xsl:use-attribute-sets="groupbadges" src="{$imagesource}badges/big/n_postreporter.gif" alt="{$alt_badge_postr}" width="75" height="166"/>
		</a>
	</GROUPBADGE>
	<GROUPBADGE NAME="TRANSLATOR">
		<a href="{$root}Translators"><img xsl:use-attribute-sets="groupbadges" src="{$imagesource}badges/big/translator.gif" alt="{$alt_badge_trans}" /></a>
	</GROUPBADGE>
	
	<GROUPBADGE NAME="PHOTOGRAPHER">
	<a href="{$root}Photographers">
		<img border="0" src="{$imagesource}badges/big/n_photographer.gif" alt="photographer" width="75" height="166"/>
	</a>
	</GROUPBADGE>
	<GROUPBADGE NAME="UNDERGUIDE">
		<a href="{$root}Underguide">
			<img border="0" src="{$imagesource}badges/big/n_underguide.gif" alt="underguide" width="75" height="166"/>
		</a>
	</GROUPBADGE>
  <GROUPBADGE NAME="SCAVENGER">
    <a href="{$root}Scavengers">
      <img border="0" src="{$imagesource}badges/big/n_scavenger.gif" alt="scavenger" width="75" height="166" vspace="5"/>
    </a>
  </GROUPBADGE>
	<GROUPBADGE NAME="FORMERSTAFF">
			<img border="0" src="{$imagesource}badges/big/n_formerstaff.gif" width="75" height="166" vspace="5"/>
			<br/>
		</GROUPBADGE>
		<GROUPBADGE NAME="BBCTESTER">
			<img border="0" src="{$imagesource}badges/big/n_bbctester.gif" width="75" height="166" vspace="5"/>
			<br/>
		</GROUPBADGE>
	<GROUPBADGE NAME="PROLIFICSCRIBE0">
		<img src="{$imagesource}badges/big/01_Edited_Entries.jpg" alt="Edited Entry badge" width="75" height="76" vspace="5"/>
	</GROUPBADGE>
	<GROUPBADGE NAME="PROLIFICSCRIBE1">
			<img src="{$imagesource}badges/big/25_Edited_Entries.gif" alt="25 Edited Entries" width="75" height="76" vspace="5"/>
	</GROUPBADGE>
	<GROUPBADGE NAME="PROLIFICSCRIBE2">
			<img src="{$imagesource}badges/big/50_Edited_Entries.gif" alt="50 Edited Entries" width="75" height="76" vspace="5"/>
	</GROUPBADGE>
	<GROUPBADGE NAME="PROLIFICSCRIBE3">
			<img src="{$imagesource}badges/big/75_Edited_Entries.gif" alt="75 Edited Entries" width="75" height="76" vspace="5"/>
	</GROUPBADGE>
	<GROUPBADGE NAME="PROLIFICSCRIBE4">
			<img src="{$imagesource}badges/big/100_Edited_Entries.gif" alt="100 Edited Entries" width="75" height="76" vspace="5"/>
	</GROUPBADGE>
  <GROUPBADGE NAME="PROLIFICSCRIBE5">
    <img src="{$imagesource}badges/big/150_Edited_Entries.gif" alt="150 Edited Entries" width="75" height="76" vspace="5"/>
  </GROUPBADGE>
  <GROUPBADGE NAME="PROLIFICSCRIBE6">
    <img src="{$imagesource}badges/big/200_Edited_Entries.gif" alt="200 Edited Entries" width="75" height="76" vspace="5"/>
  </GROUPBADGE>
</xsl:variable>

<xsl:template name="RECENT-POSTS-CONTENT">
	<table width="100%" cellspacing="0" cellpadding="0" border="0">
		<tr>
			<td colspan="2"><font xsl:use-attribute-sets="smallfont"><b><xsl:value-of select="$m_psposts_topic"/></b></font></td>
			<td width="6"><img src="{$imagesource}t.gif" width="6" height="1" /></td>
			<td><font xsl:use-attribute-sets="smallfont"><b><xsl:value-of select="$m_psposts_site"/></b></font></td>
			<td><font xsl:use-attribute-sets="smallfont"><b><xsl:value-of select="$m_psposts_lpostd"/></b></font></td>
			<td><font xsl:use-attribute-sets="smallfont"><b><xsl:value-of select="$m_psposts_lreply"/></b></font></td>
		</tr>
		<tr>
			<td width="15"><img src="{$imagesource}t.gif" width="15" height="10" alt="" /></td>
			<td width="100%"><img src="{$imagesource}t.gif" width="288" height="10" alt="" /></td>
			<td/>
			<td width="105"><img src="{$imagesource}t.gif" width="105" height="10" alt="" /></td>
			<td width="100"><img src="{$imagesource}t.gif" width="100" height="10" alt="" /></td>
			<td width="100"><img src="{$imagesource}t.gif" width="100" height="10" alt="" /></td>
		</tr>
		<xsl:choose>
			<xsl:when test="/H2G2[@TYPE='MOREPOSTS']"><xsl:apply-templates select="POSTS/POST-LIST/POST[@PRIVATE=0]"/></xsl:when>
			<xsl:otherwise><xsl:apply-templates select="POST-LIST/POST[@PRIVATE=0][position() &lt;=$limitentries]"/></xsl:otherwise>
		</xsl:choose>
		<tr>
			<td colspan="6"><img src="{$imagesource}t.gif" width="1" height="7" alt="" /></td>
		</tr>
		<tr>
			<td colspan="6" background="{$imagesource}dotted_line_inv.jpg"><img src="{$imagesource}t.gif" width="1" height="9" alt="" /></td>
		</tr>
		<tr>
			<td colspan="6"><img src="{$imagesource}t.gif" width="1" height="4" alt="" /></td>
		</tr>
<!-- IL start -->
		<xsl:if test="/H2G2[@TYPE='MOREPOSTS']">
			<tr>
				<td colspan="6">
					<font xsl:use-attribute-sets="smallfont">
						<b>
							<xsl:if test="POSTS/POST-LIST[@SKIPTO &gt; 0]">
								<xsl:apply-templates select="POSTS/@USERID" mode="NewerPostings"/><xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text></xsl:if>
							<xsl:if test="POSTS/POST-LIST[@MORE=1]">
								<xsl:apply-templates select="POSTS/@USERID" mode="OlderPostings"/>
							</xsl:if>
						</b>
					</font>
				</td>
			</tr>
		</xsl:if>
<!-- IL end -->
		<tr>
			<xsl:choose>
				<xsl:when test="/H2G2[@TYPE='MOREPOSTS']">
<!-- IL start -->
					<td colspan="3">
						<font xsl:use-attribute-sets="smallfont">
							<b>
								<xsl:apply-templates select="POSTS" mode="ToPSpaceFromMP"/>
							</b>
						</font>
					</td>
<!-- IL end -->
				</xsl:when>
				<xsl:otherwise><td colspan="3"><font xsl:use-attribute-sets="smallfont"><a class="norm" href="{$root}MP{POST-LIST/USER/USERID}"><b><xsl:value-of select="$m_psposts_prevconv"/></b></a></font></td></xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="$ownerisviewer = 1"><td colspan="2" align="right"><img src="{$imagesource}perspace/unsubscribe2.gif" width="6" height="6" alt="{$alt_psposts_unsub}" border="0" /><font xsl:use-attribute-sets="smallfont"><b><xsl:value-of select="$m_psposts_unsubkey"/></b></font></td></xsl:when>
				<xsl:otherwise><td colspan="2" align="right"><xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text></td></xsl:otherwise>
			</xsl:choose>
		</tr>
	</table>
</xsl:template>

<xsl:template match="RECENT-POSTS">
	<table width="100%" cellspacing="0" cellpadding="6" border="0">
		<tr>
			<td>
				<xsl:choose>
					<xsl:when test="$ownerisviewer = 1">
						<xsl:choose>
							<xsl:when test="POST-LIST">
								<xsl:call-template name="m_forumownerfull" />
								<xsl:call-template name="RECENT-POSTS-CONTENT" />
							</xsl:when>
							<xsl:otherwise>
								<font xsl:use-attribute-sets="mainfont"><xsl:call-template name="m_forumownerempty"/></font><br />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>
						<xsl:choose>
							<xsl:when test="POST-LIST">
								<xsl:call-template name="m_forumviewerfull"/>
								<xsl:call-template name="RECENT-POSTS-CONTENT" />
							</xsl:when>
							<xsl:otherwise>
								<font xsl:use-attribute-sets="mainfont"><xsl:call-template name="m_forumviewerempty"/></font><br/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:otherwise>
				</xsl:choose>
			</td>
		</tr>
	</table>
</xsl:template>

<xsl:template match="POST-LIST/POST">
	<tr valign="top">
		<xsl:choose>
			<xsl:when test="$ownerisviewer = 1">
				<td><xsl:call-template name="postunsubscribe"/>&nbsp;&nbsp;</td>
				<td><font xsl:use-attribute-sets="mainfont"><xsl:apply-templates select="THREAD/@THREADID" mode="LinkOnSubjectAB"/>
				<xsl:if test="@LASTPOSTCOUNTREAD">
				<xsl:choose>
				<xsl:when test="number(@LASTPOSTCOUNTREAD) = number(@COUNTPOSTS)">
				(<a href="{$root}F{THREAD/@FORUMID}?thread={THREAD/@THREADID}&amp;show=20&amp;skip={floor(((number(@LASTPOSTCOUNTREAD)) div 20))*20}#pi{number(@LASTPOSTCOUNTREAD)+1}">no new posts</a>)
				</xsl:when>
				<xsl:when test="(number(@COUNTPOSTS) - number(@LASTPOSTCOUNTREAD)) = 1">
				(<a href="{$root}F{THREAD/@FORUMID}?thread={THREAD/@THREADID}&amp;show=20&amp;skip={floor(((number(@LASTPOSTCOUNTREAD)) div 20))*20}#pi{number(@LASTPOSTCOUNTREAD)+1}">1 new post</a>)
				</xsl:when>
				<xsl:otherwise>
				(<a href="{$root}F{THREAD/@FORUMID}?thread={THREAD/@THREADID}&amp;show=20&amp;skip={floor(((number(@LASTPOSTCOUNTREAD)) div 20))*20}#pi{number(@LASTPOSTCOUNTREAD)+1}"><xsl:value-of select="(number(@COUNTPOSTS) - number(@LASTPOSTCOUNTREAD))"/> new posts</a>)
				</xsl:otherwise>
				</xsl:choose>
				</xsl:if>
				</font></td>
				<td/>
			</xsl:when>
			<xsl:otherwise>
				<td colspan="2"><font xsl:use-attribute-sets="mainfont"><xsl:apply-templates select="THREAD/@THREADID" mode="LinkOnSubjectAB"/></font></td>
				<td/>
			</xsl:otherwise>
		</xsl:choose>
		<td><font xsl:use-attribute-sets="mainfont"><xsl:apply-templates select="SITEID" mode="showfrom"/></font></td>
		<td>
			<font xsl:use-attribute-sets="mainfont">
				<xsl:choose>
					<xsl:when test="THREAD/LASTUSERPOST">	<xsl:apply-templates select="THREAD/LASTUSERPOST/DATEPOSTED/DATE" mode="LastUserPost"/></xsl:when>
					<xsl:otherwise><xsl:value-of select="$m_noposting"/></xsl:otherwise>
				</xsl:choose>
			</font>
		</td>
		<td>
			<font xsl:use-attribute-sets="mainfont">
				<xsl:choose>
					<xsl:when test="HAS-REPLY > 0"><xsl:apply-templates select="THREAD/REPLYDATE/DATE" mode="LatestPost"/></xsl:when>
					<xsl:otherwise><xsl:value-of select="$m_noreplies"/></xsl:otherwise>
				</xsl:choose>
			</font>
		</td>
	</tr>
</xsl:template>

<xsl:template name="postunsubscribe">
	<xsl:choose>
		<xsl:when test="/H2G2[@TYPE='USERPAGE']">
			<a href="{$root}FSB{THREAD/@FORUMID}?thread={THREAD/@THREADID}&amp;cmd=unsubscribethread&amp;page=normal&amp;desc={$alt_subreturntospace}&amp;return=U{$viewerid}"><img src="{$imagesource}perspace/unsubscribe.gif" width="10" height="10" alt="{$alt_psposts_unsub}" border="0" /></a>
		</xsl:when>
		<xsl:otherwise>
			<a target="_top" href="{$root}FSB{THREAD/@FORUMID}?thread={THREAD/@THREADID}&amp;cmd=unsubscribethread&amp;page=normal&amp;desc={$alt_subreturntopostlist}&amp;return=MP{$viewerid}%3Fskip={../@SKIPTO}%26amp;show={../@COUNT}"><img src="{$imagesource}perspace/unsubscribe.gif" width="10" height="10" alt="{$alt_psposts_unsub}" border="0" /></a>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template name="postsubject">
	<xsl:param name="linkstyle">norm</xsl:param>
	<font xsl:use-attribute-sets="mainfont">
		<a class="{$linkstyle}">
			<xsl:attribute name="HREF">
				<xsl:value-of select="$root"/>F<xsl:value-of select="FORUM-ID" />?thread=<xsl:value-of select="THREAD-ID" />
			</xsl:attribute>
			<xsl:choose>
				<xsl:when test="SUBJECT=''">&lt;<xsl:value-of select="$m_nosubject"/>&gt;</xsl:when>
				<xsl:otherwise><xsl:value-of select="SUBJECT" /></xsl:otherwise>
			</xsl:choose>
		</a>
	</font>
</xsl:template>

<xsl:template match="SITEID" mode="showfrom">
	<xsl:variable name="thissiteid"><xsl:value-of select="."/></xsl:variable>
	<xsl:value-of select="/H2G2/SITE-LIST/SITE[@ID=number($thissiteid)]/SHORTNAME"/>
</xsl:template>


<xsl:template match="JOURNAL">
	<table width="100%" cellspacing="0" cellpadding="10" border="0" class="postable">
		<tr>
			<td align="left">
				<font xsl:use-attribute-sets="textfont">
					<xsl:choose>
						<xsl:when test="JOURNALPOSTS/POST[@HIDDEN!='2']">
							<xsl:choose>
								<xsl:when test="$test_MayAddToJournal">
			<!--						<xsl:call-template name="m_journalownerfull"" /> -->
<!-- IL start -->
									<b>
										<xsl:call-template name="ClickAddJournal">
											<xsl:with-param name="img"><img src="{$imagesource}arrowh_pos.gif" width="3" height="9" alt="" border="0" hspace="3" /><xsl:value-of select="$m_psjour_addent"/></xsl:with-param>
										</xsl:call-template>
									</b>
<!-- IL end -->
									<br />
									<table width="100%" cellspacing="0" cellpadding="0" border="0">
										<tr>
											<td width="100%" background="{$imagesource}dotted_line.jpg">
												<img src="{$imagesource}t.gif" width="1" height="10" alt="" />
											</td>
										</tr>
									</table>
								</xsl:when>
								<xsl:otherwise>
			<!--						<xsl:call-template name="m_journalviewerfull"/> -->
								</xsl:otherwise>
							</xsl:choose>			
							<xsl:apply-templates select="JOURNALPOSTS" />
							<xsl:if test="JOURNALPOSTS[@MORE=1]">
								<font xsl:use-attribute-sets="smallfont" class="postxt">
<!-- IL start -->
									<b>
										<xsl:apply-templates select="JOURNALPOSTS" mode="MoreJournal">
											<xsl:with-param name="img" select="$m_psjour_showmore"/>
										</xsl:apply-templates>
									</b>
<!-- IL end -->
									<br />
								</font>
							</xsl:if>
							<br />
						</xsl:when>
						<xsl:otherwise>
<!-- IL start -->
							<xsl:call-template name="JournalEmptyMsg"/>
<!-- IL end -->
						</xsl:otherwise>
					</xsl:choose>
				</font><br clear="all" />
			</td>
		</tr>
	</table>
</xsl:template>

<xsl:attribute-set name="mJOURNALPOSTS_MoreJournal">
	<xsl:attribute name="class">pos</xsl:attribute>
</xsl:attribute-set>

<xsl:template match="JOURNALPOSTS/POST">
	<xsl:if test="not(@HIDDEN &gt; 0)">
	<b><xsl:value-of select="SUBJECT" /></b><br />
	<font xsl:use-attribute-sets="smallfont" class="postxt"><xsl:apply-templates select="DATEPOSTED/DATE" /><br /><br /></font>
	<xsl:apply-templates select="TEXT" /><br /><br />
	<!--<font xsl:use-attribute-sets="mainfont">-->
<!-- IL start -->
		<b>
			<xsl:apply-templates select="@POSTID" mode="DiscussJournalEntry">
				<xsl:with-param name="img">
					<img src="{$imagesource}arrowh_pos.gif" width="3" height="9" alt="" border="0" hspace="3" />Discuss this entry
				</xsl:with-param>
			</xsl:apply-templates>
		</b>
<!-- IL end -->
	<xsl:choose>
		<xsl:when test="number(LASTREPLY/@COUNT) &gt; 1">
			- <a class="pos">
				<xsl:attribute name="HREF">
					<xsl:value-of select="$root"/>F<xsl:value-of select="../@FORUMID"/>?thread=<xsl:value-of select="@THREADID" />
				</xsl:attribute>
				<xsl:choose>
					<xsl:when test="LASTREPLY[@COUNT &gt; 2]"><xsl:value-of select="number(LASTREPLY/@COUNT)-1" /><xsl:value-of select="$m_replies"/></xsl:when>
					<xsl:otherwise>1<xsl:value-of select="$m_reply"/></xsl:otherwise>
				</xsl:choose>
			</a>
			 - <xsl:value-of select="$m_latestreply"/>
			<a class="pos">
				<xsl:attribute name="HREF">
					<xsl:value-of select="$root"/>F<xsl:value-of select="../@FORUMID"/>?thread=<xsl:value-of select="@THREADID" />&amp;latest=1
				</xsl:attribute>
				<xsl:apply-templates select="LASTREPLY/DATE" />
			</a>
		</xsl:when>
		<xsl:otherwise>
			(<xsl:value-of select="$m_noreplies"/>)
		</xsl:otherwise>
	</xsl:choose>
	<br />
<!-- IL start -->
	<xsl:if test="$test_MayRemoveJournalPost">
		<b>
			<xsl:apply-templates select="@THREADID" mode="JournalRemovePost">
				<xsl:with-param name="img"><img src="{$imagesource}arrowh_pos.gif" width="3" height="9" alt="" border="0" hspace="3" /><xsl:value-of select="$m_psjour_delent"/></xsl:with-param>
			</xsl:apply-templates>
		</b>
		<br/>
	</xsl:if>
<!-- IL end -->
	<br />
	<!--</font>-->
	<table width="100%" cellspacing="0" cellpadding="0" border="0">
		<tr>
			<td width="100%" background="{$imagesource}dotted_line.jpg">
				<img src="{$imagesource}t.gif" width="1" height="10" alt="" />
			</td>
		</tr>
	</table>
	</xsl:if>
</xsl:template>

<!-- IL start -->
<!--xsl:template name="removejournalpost">
	<xsl:if test="$ownerisviewer = 1">
		<a class="pos" target="_top" href="{$root}FSB{../@FORUMID}?thread={@THREADID}&amp;cmd=unsubscribejournal&amp;page=normal&amp;desc={$alt_subreturntospace}&amp;return=U{$viewerid}"><img src="{$imagesource}arrowh_pos.gif" width="3" height="9" alt="" border="0" hspace="3" /><b><xsl:value-of select="$m_psjour_delent"/></b></a><br/>
	</xsl:if>
</xsl:template-->
<!-- IL end -->

<xsl:template match="RECENT-ENTRIES">
	<table width="100%" cellspacing="0" cellpadding="6" border="0">
		<tr>
			<td>
				<font xsl:use-attribute-sets="mainfont">
					<xsl:choose>
						<xsl:when test="ARTICLE-LIST/ARTICLE[not(EXTRAINFO/TYPE/@ID=3001)][not(EXTRAINFO/TYPE/@ID=1001)]">
<!--						<xsl:choose>
								<xsl:when test="$ownerisviewer = 1">
									<xsl:call-template name="m_artownerfull"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:call-template name="m_artviewerfull"/>
								</xsl:otherwise>
							</xsl:choose> -->
							<table width="100%" cellspacing="0" cellpadding="0" border="0">
								<!-- <tr>
									<td colspan="7"><font xsl:use-attribute-sets="mainfont"><xsl:value-of select="$m_psent_recent"/></font></td>
								</tr>
								<tr>
									<td colspan="7" background="{$imagesource}dotted_line_inv.jpg">
										<img src="{$imagesource}t.gif" width="1" height="9" alt="" />
									</td>
								</tr>-->
								<tr>
									<td><font xsl:use-attribute-sets="smallfont"><b><xsl:value-of select="$m_psent_id"/></b></font></td>
									<xsl:choose>
										<xsl:when test="$ownerisviewer = 1">
											<td><font xsl:use-attribute-sets="smallfont"><xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text></font></td>
											<td><font xsl:use-attribute-sets="smallfont"><b><xsl:value-of select="$m_psent_titile"/></b></font></td>
										</xsl:when>
										<xsl:otherwise>
											<td colspan="2"><font xsl:use-attribute-sets="smallfont"><b><xsl:value-of select="$m_psent_titile"/></b></font></td>
										</xsl:otherwise>
									</xsl:choose>
									<td></td>
									<td><font xsl:use-attribute-sets="smallfont"><b><xsl:value-of select="$m_psent_site"/></b></font></td>
									<td><font xsl:use-attribute-sets="smallfont"><xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text></font></td>
									<td><font xsl:use-attribute-sets="smallfont"><b><xsl:value-of select="$m_psent_status"/></b></font></td>
									<td><font xsl:use-attribute-sets="smallfont"><b><xsl:value-of select="$m_psent_created"/></b></font></td>
								</tr>
								<tr>
									<td width="70"><img src="{$imagesource}t.gif" width="70" height="10" alt="" /></td>
									<td width="35"><img src="{$imagesource}t.gif" width="35" height="10" alt="" /></td>
									<td width="100%"><img src="{$imagesource}t.gif" width="210" height="10" alt="" /></td>
									<td width="7"><img src="{$imagesource}t.gif" width="7" height="1" alt="" /></td>
									<td width="105"><img src="{$imagesource}t.gif" width="105" height="10" alt="" /></td>
									<td width="7"><img src="{$imagesource}t.gif" width="7" height="10" alt="" /></td>
									<td width="100"><img src="{$imagesource}t.gif" width="100" height="10" alt="" /></td>
									<td width="100"><img src="{$imagesource}t.gif" width="100" height="10" alt="" /></td>
								</tr>
								<xsl:apply-templates select="ARTICLE-LIST">
									
								</xsl:apply-templates>
								<!--xsl:apply-templates select="../RECENT-APPROVALS"/-->
								<!--xsl:apply-templates select="ARTICLE-LIST" mode="edited" /-->
								<tr>
									<td colspan="8">
										<img src="{$imagesource}t.gif" width="1" height="7" alt="" />
									</td>
								</tr>
								<tr>
									<td colspan="8" background="{$imagesource}dotted_line_inv.jpg">
										<img src="{$imagesource}t.gif" width="1" height="9" alt="" />
									</td>
								</tr>
								<tr>
									<td colspan="8">
										<img src="{$imagesource}t.gif" width="1" height="4" alt="" />
									</td>
								</tr>
								<xsl:choose>
									<xsl:when test="$ownerisviewer = 1">
										<tr>
											<td colspan="6">
												<font xsl:use-attribute-sets="smallfont">
													<xsl:if test="count(/H2G2/RECENT-APPROVALS/ARTICLE-LIST/ARTICLE) &gt; $limitentries">
														<xsl:call-template name="RECENT-APPROVALS-MORE"/>
													</xsl:if>
													<xsl:if test="count(/H2G2/RECENT-APPROVALS/ARTICLE-LIST/ARTICLE) &gt; $limitentries and count(/H2G2/RECENT-ENTRIES/ARTICLE-LIST/ARTICLE) &gt; $limitentries">
														<xsl:value-of select="$skipdivider"/>
													</xsl:if>
													<xsl:if test="count(/H2G2/RECENT-ENTRIES/ARTICLE-LIST/ARTICLE) &gt; $limitentries">
														<xsl:call-template name="RECENT-ENTRIES-MORE"/>
													</xsl:if>
												</font>
											</td>
											<td colspan="2" align="right">
												<font xsl:use-attribute-sets="smallfont">
													<nobr><img src="{$imagesource}perspace/edit2.gif" width="8" height="13" alt="{$alt_morepages_edit}" border="0" /><b><xsl:value-of select="$m_morepages_editkey"/></b></nobr>
													<xsl:if test='not(/H2G2[@TYPE="USERPAGE"])'>
														<xsl:value-of select="$skipdivider"/>
														<nobr><img src="{$imagesource}perspace/unsubscribe2.gif" width="6" height="6" alt="{$alt_morepages_uncancel}" border="0" /><b><xsl:value-of select="$m_morepages_uncancelkey"/></b></nobr>
													</xsl:if>
												</font>
											</td>
										</tr>
										<tr>
											<td colspan="8">
												<font xsl:use-attribute-sets="mainfont"><br />
													<a class="norm" href="{$root}useredit">
														<b><img src="{$imagesource}arrowh.gif" width="3" height="9" alt="" border="0" hspace="3" /><xsl:value-of select="$m_psent_createnew"/></b>
													</a>
												</font>
											</td>
										</tr>
									</xsl:when>
									<xsl:otherwise>
										<xsl:if test="count(ARTICLE-LIST/ARTICLE) &gt; $limitentries or count(../RECENT-APPROVALS/ARTICLE-LIST/ARTICLE) &gt; $limitentries">
											<tr>
												<td colspan="8">
													<font xsl:use-attribute-sets="smallfont">
														<xsl:if test="count(/H2G2/RECENT-ENTRIES/ARTICLE-LIST/ARTICLE) &gt; $limitentries">
															<xsl:call-template name="RECENT-ENTRIES-MORE"/>
														</xsl:if>
														<xsl:if test="count(/H2G2/RECENT-APPROVALS/ARTICLE-LIST/ARTICLE) &gt; $limitentries and count(/H2G2/RECENT-ENTRIES/ARTICLE-LIST/ARTICLE) &gt; $limitentries">
															<xsl:value-of select="$skipdivider"/>
														</xsl:if>
														<xsl:if test="count(/H2G2/RECENT-APPROVALS/ARTICLE-LIST/ARTICLE) &gt; $limitentries">
															<xsl:call-template name="RECENT-APPROVALS-MORE"/>
														</xsl:if>
													</font>
												</td>
											</tr>
										</xsl:if>
									</xsl:otherwise>
								</xsl:choose>
								<tr>
									<td colspan="8">
										<img src="{$imagesource}t.gif" width="1" height="15" alt="" />
									</td>
								</tr>
							</table>
						</xsl:when>
						<xsl:otherwise>
							<xsl:choose>
								<xsl:when test="$ownerisviewer = 1">
									<xsl:call-template name="m_artownerempty"/><br/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:call-template name="m_artviewerempty"/><br/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:otherwise>
					</xsl:choose>
				</font>
			</td>
		</tr>
	</table>
</xsl:template>

<xsl:template match="ARTICLE-LIST">
	<xsl:apply-templates select="ARTICLE[position() &lt;=$limitentries][not(EXTRAINFO/TYPE/@ID=3001)][not(EXTRAINFO/TYPE/@ID=1001)] | ../../RECENT-APPROVALS/ARTICLE-LIST/ARTICLE[position() &lt;=$limitentries][not(EXTRAINFO/TYPE/@ID=3001)][not(EXTRAINFO/TYPE/@ID=1001)]">
		<xsl:sort select="concat(DATE-CREATED/DATE/@YEAR, DATE-CREATED/DATE/@MONTH, DATE-CREATED/DATE/@DAY, DATE-CREATED/DATE/@HOURS, DATE-CREATED/DATE/@MINUTES, DATE-CREATED/DATE/@SECONDS)" data-type="number" order="descending"/>
	</xsl:apply-templates>
</xsl:template>

<xsl:template name="RECENT-APPROVALS-MORE">
	<a class="norm">
		<xsl:attribute name="HREF"><xsl:value-of select="$root"/>MA<xsl:value-of select="USER/USERID"/>?type=1</xsl:attribute>
		<nobr><b><xsl:value-of select="$m_morepages_showmore"/></b></nobr>
	</a>
</xsl:template>

<xsl:template name="RECENT-ENTRIES-MORE">
	<a class="norm">
		<xsl:attribute name="HREF"><xsl:value-of select="$root"/>MA<xsl:value-of select="USER/USERID"/>?type=2</xsl:attribute>
		<nobr><b><xsl:value-of select="$m_psent_showmore"/></b></nobr>
	</a>
</xsl:template>

<!-- Edited out for combine tables
<xsl:template match="RECENT-APPROVALS">
	<table width="100%" cellspacing="0" cellpadding="6" border="0">
		<tr>
			<td>
				<font xsl:use-attribute-sets="mainfont">
					<xsl:choose>
						<xsl:when test="ARTICLE-LIST/ARTICLE">
							<table width="100%" cellspacing="0" cellpadding="0" border="0">
								<tr>
									<td colspan="6"><font xsl:use-attribute-sets="mainfont"><xsl:value-of select="$m_psaprv_recented"/></font></td>
								</tr>
								<tr>
									<td colspan="6" background="{$imagesource}dotted_line_inv.jpg">
										<img src="{$imagesource}t.gif" width="1" height="9" alt="" />
									</td>
								</tr>
								<tr>
									<td><font xsl:use-attribute-sets="smallfont"><b><xsl:value-of select="$m_psaprv_id"/></b></font></td>
									<td><font xsl:use-attribute-sets="smallfont"><b><xsl:value-of select="$m_psaprv_title"/></b></font></td>
									<td><font xsl:use-attribute-sets="smallfont"><b><xsl:value-of select="$m_psaprv_site"/></b></font></td>
									<td><font xsl:use-attribute-sets="smallfont"><xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text></font></td>
									<td><font xsl:use-attribute-sets="smallfont"><b><xsl:value-of select="$m_psent_status"/></b></font></td>
									<td><font xsl:use-attribute-sets="smallfont"><b><xsl:value-of select="$m_psaprv_created"/></b></font></td>
								</tr>
								<tr>
									<td width="70"><img src="{$imagesource}t.gif" width="70" height="10" alt="" /></td>
									<td width="100%"><img src="{$imagesource}t.gif" width="345" height="10" alt="" /></td>
									<td width="105"><img src="{$imagesource}t.gif" width="105" height="10" alt="" /></td>
									<td width="7"><img src="{$imagesource}t.gif" width="7" height="10" alt="" /></td>
									<td width="100"><img src="{$imagesource}t.gif" width="100" height="10" alt="" /></td>
									<td width="100"><img src="{$imagesource}t.gif" width="100" height="10" alt="" /></td>
								</tr>
								<xsl:apply-templates select="ARTICLE-LIST" mode="edited" />
								<tr>
									<td colspan="6" background="{$imagesource}dotted_line_inv.jpg">
										<img src="{$imagesource}t.gif" width="1" height="9" alt="" />
									</td>
								</tr>
								<tr>
									<td colspan="6">
										<img src="{$imagesource}t.gif" width="1" height="4" alt="" />
									</td>
								</tr>
								<xsl:if test="/H2G2/RECENT-APPROVALS/ARTICLE-LIST[@MORE]">
									<tr>
										<td colspan="6">
											<font xsl:use-attribute-sets="smallfont">
												<a class="norm">
													<xsl:attribute name="HREF"><xsl:value-of select="$root"/>MA<xsl:value-of select="USER/USERID"/>?type=1</xsl:attribute>
													<nobr><b><xsl:value-of select="$m_morepages_showmore"/></b></nobr>
												</a>
											</font>
										</td>
									</tr>
								</xsl:if>
								<tr>
									<td colspan="6">
										<img src="{$imagesource}t.gif" width="1" height="15" alt="" />
									</td>
								</tr>
							</table>
						</xsl:when>
						<xsl:otherwise>
							<xsl:choose>
								<xsl:when test="$ownerisviewer = 1">
									<xsl:call-template name="m_editownerempty"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:call-template name="m_editviewerempty"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:otherwise>
					</xsl:choose>
				</font><br clear="all" />
			</td>
		</tr>
	</table>
</xsl:template> -->

<xsl:template match="ARTICLE-LIST/ARTICLE">
	<tr valign="top">
		<td>
			<font xsl:use-attribute-sets="mainfont">
				<a class="norm">
					<xsl:attribute name="HREF"><xsl:value-of select="$root"/>A<xsl:value-of select="H2G2-ID"/></xsl:attribute>
					A<xsl:value-of select="H2G2-ID"/>
				</a>
			</font>
		</td>
		<xsl:choose>
			<xsl:when test="$ownerisviewer = 1">
				<td align="center">
					<xsl:choose>
						<xsl:when test="(STATUS = 3 or STATUS = 4) and (EDITOR/USER/USERID = $viewerid)">
							<a class="norm">
								<xsl:attribute name="HREF"><xsl:value-of select="$root"/>UserEdit<xsl:value-of select="H2G2-ID"/></xsl:attribute>
								<img src="{$imagesource}perspace/edit.gif" width="15" height="15" alt="{$alt_morepages_edit}" border="0" />
							</a>
						</xsl:when>
						<xsl:when test="STATUS = 7">
							<a class="norm">
								<xsl:attribute name="HREF"><xsl:value-of select="$root"/>UserEdit<xsl:value-of select="H2G2-ID"/>?cmd=undelete</xsl:attribute>
								<img src="{$imagesource}perspace/unsubscribe.gif" width="10" height="10" alt="{$alt_morepages_uncancel}" border="0" />
							</a>
						</xsl:when>
						<xsl:otherwise><xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text></xsl:otherwise>
					</xsl:choose>
				</td>
				<td>
					<font xsl:use-attribute-sets="mainfont">
						<a class="norm">
							<xsl:attribute name="HREF"><xsl:value-of select="$root"/>A<xsl:value-of select="H2G2-ID"/></xsl:attribute>
							<xsl:value-of select="SUBJECT"/>
						</a>
					</font>
				</td>
			</xsl:when>
			<xsl:otherwise>
				<td colspan="2">
					<font xsl:use-attribute-sets="mainfont">
						<a class="norm">
							<xsl:attribute name="HREF"><xsl:value-of select="$root"/>A<xsl:value-of select="H2G2-ID"/></xsl:attribute>
							<xsl:value-of select="SUBJECT"/>
						</a>
					</font>
				</td>
			</xsl:otherwise>
		</xsl:choose>
		<td></td>
		<td>
			<font xsl:use-attribute-sets="mainfont"><xsl:apply-templates select="SITEID" mode="showfrom"/></font>
		</td>
		<td><font xsl:use-attribute-sets="smallfont"><xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text></font></td>
		<td>
			<font xsl:use-attribute-sets="mainfont">
				<xsl:choose>
					<xsl:when test="STATUS = 7">
						<xsl:value-of select="$m_cancelled"/>
					</xsl:when>
					<xsl:when test="STATUS = 1">
						<xsl:value-of select="$m_psent_edited"/>
					</xsl:when>
					<xsl:when test="STATUS > 3 and STATUS != 7">
						<xsl:choose>
							<xsl:when test="STATUS = 13 or STATUS = 6"><xsl:value-of select="$m_pending"/></xsl:when>
							<xsl:otherwise><xsl:value-of select="$m_recommended"/></xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>-</xsl:otherwise>
				</xsl:choose>
			</font>
		</td>
		<td>
			<font xsl:use-attribute-sets="mainfont"><xsl:apply-templates select="DATE-CREATED/DATE"/></font>
		</td>
	</tr>
</xsl:template>

<!--
<xsl:template match="ARTICLE-LIST/ARTICLE" mode="edited">
	<tr valign="top">
		<td>
			<font xsl:use-attribute-sets="mainfont">
				<a class="norm">
					<xsl:attribute name="HREF"><xsl:value-of select="$root"/>A<xsl:value-of select="H2G2-ID"/></xsl:attribute>
					A<xsl:value-of select="H2G2-ID"/>
				</a>
			</font>
		</td>
		<td colspan="2">-->
		<!-- <td> Changed for table comine-->
		<!--	<font xsl:use-attribute-sets="mainfont">
				<a class="norm">
					<xsl:attribute name="HREF"><xsl:value-of select="$root"/>A<xsl:value-of select="H2G2-ID"/></xsl:attribute>
					<xsl:value-of select="SUBJECT"/>
				</a>
			</font>
		</td>
		<td>
			<font xsl:use-attribute-sets="mainfont"><xsl:apply-templates select="SITEID" mode="showfrom"/></font>
		</td>
		<td><font xsl:use-attribute-sets="smallfont"><xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text></font></td>
		<td>
			<font xsl:use-attribute-sets="mainfont"><xsl:value-of select="$m_psent_edited"/></font>
		</td>
		<td>
			<font xsl:use-attribute-sets="mainfont"><xsl:apply-templates select="DATE-CREATED/DATE"/></font>
		</td>
	</tr>
</xsl:template> -->

<xsl:template name="ABOUTME">
	<xsl:variable name="lastpostbyusersort">
		<xsl:for-each select="/H2G2/RECENT-POSTS/POST-LIST/POST/THREAD/LASTUSERPOST/DATEPOSTED/DATE">
			<xsl:sort select="concat(@YEAR, @MONTH, @DAY, @HOURS, @MINUTES, @SECONDS)" order="descending"/>
			<xsl:copy-of select="."/>
		</xsl:for-each>
	</xsl:variable>
	<xsl:variable name="lastpostbyuser">
		<xsl:apply-templates select="msxsl:node-set($lastpostbyusersort)/DATE[1]"/>
	</xsl:variable>

	<table width="100%" cellspacing="0" cellpadding="0" border="0" bgcolor="#000000" class="postable">
		<tr>
			<td width="1" rowspan="6"><img src="{$imagesource}t.gif" width="1" height="387" alt="" /></td>
			<td width="100%">	<img src="{$imagesource}t.gif" width="10" height="5" alt="" /></td>
			<td width="200"><img src="{$imagesource}t.gif" width="200" height="5" alt="" /></td>
		</tr>
		<tr valign="top">
			<td align="left">
				<img src="{$imagesource}t.gif" width="1" height="5" alt="" /><br clear="all"/><img src="{$imagesource}t.gif" width="10" height="1" alt="" />
				<font xsl:use-attribute-sets="textsmallfont">
					<xsl:if test="/H2G2/ARTICLE/ARTICLEINFO/DATECREATED/DATE"><xsl:value-of select="$m_created"/><xsl:apply-templates mode="CREATEDATE" select="/H2G2/ARTICLE/ARTICLEINFO/DATECREATED/DATE"/></xsl:if>
					<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
				</font>
			</td>
			<td><img src="{$imagesource}t.gif" height="35" alt="" /></td>
		</tr>
		<tr>
			<td align="left" valign="bottom" colspan="2">
				<img src="{$imagesource}t.gif" width="10" height="1" alt="" />
				<font xsl:use-attribute-sets="textheaderfont">
					<b>
						<xsl:choose>
							<xsl:when test="$test_introarticle"><xsl:value-of select="/H2G2/ARTICLE/SUBJECT"/></xsl:when>
							<xsl:when test="/H2G2/PAGE-OWNER/USER/USERNAME">
								<xsl:choose>
									<xsl:when test="$ownerisviewer = 1"><xsl:value-of select="$m_psabme_uwelcome"/><xsl:value-of select="/H2G2/PAGE-OWNER/USER/USERNAME"/>.</xsl:when>
									<xsl:otherwise><xsl:value-of select="$m_psabme_welcome"/><xsl:value-of select="/H2G2/PAGE-OWNER/USER/USERNAME"/>.</xsl:otherwise>
								</xsl:choose>
							</xsl:when>
							<xsl:otherwise>
								<xsl:choose>
									<xsl:when test="$ownerisviewer = 1"><xsl:value-of select="$m_psabme_uwelcomer"/><xsl:value-of select="/H2G2/PAGE-OWNER/USER/USERID"/>.</xsl:when>
									<xsl:otherwise><xsl:value-of select="$m_psabme_welcomer"/><xsl:value-of select="/H2G2/PAGE-OWNER/USER/USERID"/>.</xsl:otherwise>
								</xsl:choose>
							</xsl:otherwise>
						</xsl:choose>
					</b>
				</font>
			</td>
		</tr>
		<tr>
			<td colspan="2"><img src="{$imagesource}t.gif" width="1" height="5" alt="" /></td>
		</tr>
		<tr>
			<td colspan="2" style="background:#000000"><img src="{$imagesource}t.gif" width="1" height="1" alt="" /></td>
		</tr>
		<tr valign="top">
			<td>
				<table width="100%" cellspacing="0" cellpadding="10" border="0">
					<tr>
						<td>
							<font xsl:use-attribute-sets="textfont">
							
									<xsl:apply-templates select="/H2G2/ARTICLE/GUIDE/INTRO" />
							
								<xsl:choose>
									<xsl:when test="/H2G2/ARTICLE/ARTICLEINFO[HIDDEN='1']">
										<xsl:call-template name="m_userpagehidden" />
									</xsl:when>
									<xsl:when test="/H2G2/ARTICLE/ARTICLEINFO[HIDDEN='2']">
										<xsl:call-template name="m_userpagereferred" />
									</xsl:when>
									<xsl:when test="/H2G2/ARTICLE/ARTICLEINFO[HIDDEN='3']">
										<xsl:call-template name="m_userpagependingpremoderation" />
									</xsl:when>
									<xsl:when test="/H2G2/ARTICLE/ARTICLEINFO[HIDDEN='4']">
										<xsl:call-template name="m_legacyuserpageawaitingmoderation" />
									</xsl:when>
									<xsl:otherwise>
										<xsl:choose>
											<xsl:when test="$test_introarticle">
												<xsl:apply-templates select="/H2G2/ARTICLE/GUIDE/BODY" />
											</xsl:when>
											<xsl:otherwise>
												<xsl:choose>
													<xsl:when test="$ownerisviewer = 1">
														<xsl:call-template name="m_psintroowner" />
													</xsl:when>
													<xsl:otherwise>
														<xsl:call-template name="m_psintroviewer"/>
													</xsl:otherwise>
												</xsl:choose>
											</xsl:otherwise>
										</xsl:choose>
										<xsl:if test=".//FOOTNOTE">
											<blockquote>
												<font xsl:use-attribute-sets="textsmallfont">
													<hr xsl:use-attribute-sets="nu_hr" />
													<xsl:apply-templates mode="display" select=".//FOOTNOTE"/>
												</font>
											</blockquote>
										</xsl:if>
									</xsl:otherwise>
								</xsl:choose>
							</font>
						</td>
					</tr>
				</table>
				<br /><br />
			</td>
			<td background="{$imagesource}perspace/entrydata_bg.gif">
				<table width="200" cellspacing="0" cellpadding="0" border="0" style="background:#000000" background="">
					<xsl:choose>
						<xsl:when test="($ownerisviewer=0 and $registered=1) or ($ownerisviewer = 1 and /H2G2/PAGEUI/EDITPAGE/@VISIBLE = 1) or $test_IsEditor or /H2G2/ARTICLE/ARTICLEINFO/FORUMID">
							<tr valign="top">
								<xsl:choose>
									<xsl:when test="name(/H2G2/PAGE-OWNER/USER/GROUPS/*) = msxsl:node-set($subbadges)/GROUPBADGE/@NAME"><td width="1" rowspan="7" style="background:#000000"><img src="{$imagesource}t.gif" width="1" height="1" alt="" /></td></xsl:when>
									<xsl:otherwise><td width="1" rowspan="3" style="background:#000000"><img src="{$imagesource}t.gif" width="1" height="1" alt="" /></td></xsl:otherwise>
								</xsl:choose>
								<td width="1" bgcolor="#000000" class="postable"><img src="{$imagesource}t.gif" width="1" height="1" alt="" /></td>
								<td width="197">
                  <!--<xsl:if test="($ownerisviewer = 1 and /H2G2/PAGEUI/EDITPAGE/@VISIBLE = 1) or $test_IsEditor">
                    <table width="197" cellspacing="5" cellpadding="0" border="0" bgcolor="#000000" class="postable">
                      <tr>
                        <td>
                          <font xsl:use-attribute-sets="mainfont">
                            <img src="{$imagesource}arrowh_pos.gif" width="3" height="9" alt="" border="0" hspace="3" />
                            <b>
                              <a class="pos">
                                <xsl:attribute name="href">
                                  <xsl:choose>
                                    <xsl:when test="$test_IsEditor">
                                      <xsl:value-of select="$root"/>UserEdit<xsl:value-of select="/H2G2/ARTICLE/ARTICLEINFO/H2G2ID"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                      <xsl:value-of select="$root"/>
                                      <xsl:value-of select="$pageui_editpage"/>
                                    </xsl:otherwise>
                                  </xsl:choose>
                                </xsl:attribute>
                                <xsl:value-of select="$m_editpagetbut"/>
                              </a>
                            </b>
                          </font>
                        </td>
                      </tr>
                    </table>
                  </xsl:if>
									<xsl:if test="/H2G2/ARTICLE/ARTICLEINFO/FORUMID">
									<table width="197" cellspacing="5" cellpadding="0" border="0" bgcolor="#000000" class="postable">
										<tr>
											<td><font xsl:use-attribute-sets="mainfont"><img src="{$imagesource}arrowh_pos.gif" width="3" height="9" alt="" border="0" hspace="3" /><b>
												<a class="pos">
													<xsl:attribute name="href">AddThread?forum=<xsl:value-of select="/H2G2/ARTICLE/ARTICLEINFO/FORUMID"/>&amp;article=<xsl:value-of select="/H2G2/ARTICLE/ARTICLEINFO/H2G2ID"/></xsl:attribute>
													<xsl:value-of select="$m_leavemessage"/>
												</a>
											</b></font></td>
										</tr>
									</table>
									</xsl:if>
									<xsl:if test="$ownerisviewer=0 and $registered=1">
									<table width="197" cellspacing="5" cellpadding="0" border="0" bgcolor="#000000" class="postable">
										<tr>
											<td><font xsl:use-attribute-sets="mainfont"><img src="{$imagesource}arrowh_pos.gif" width="3" height="9" alt="" border="0" hspace="3" /><b>
												<a class="pos" href="Watch{$viewerid}?add=1&amp;adduser={/H2G2/PAGE-OWNER/USER/USERID}">
													Add to Friends
												</a>
											</b></font></td>
										</tr>
									</table>
									</xsl:if>
                  <xsl:if test="$ownerisviewer=0 and $registered=1">
                    <table width="197" cellspacing="5" cellpadding="0" border="0" bgcolor="#000000" class="postable">
                      <tr>
                        <td>
                          <font xsl:use-attribute-sets="mainfont">
                            <img src="{$imagesource}arrowh_pos.gif" width="3" height="9" alt="" border="0" hspace="3" />
                            <b>
                              <a class="pos" href="Watch{$viewerid}?add=1&amp;adduser={/H2G2/PAGE-OWNER/USER/USERID}">
                                Subscribe to User
                              </a>
                            </b>
                          </font>
                        </td>
                      </tr>
                    </table>
                  </xsl:if>-->
                  <ul class="ps-functions">
                    <xsl:if test="($ownerisviewer = 1 and /H2G2/PAGEUI/EDITPAGE/@VISIBLE = 1) or $test_IsEditor">
                      <li>
                        <a>
                          <xsl:attribute name="href">
                            <xsl:choose>
                              <xsl:when test="$test_IsEditor">
                                <xsl:value-of select="$root"/>UserEdit<xsl:value-of select="/H2G2/ARTICLE/ARTICLEINFO/H2G2ID"/>
                              </xsl:when>
                              <xsl:otherwise>
                                <xsl:value-of select="$root"/>
                                <xsl:value-of select="$pageui_editpage"/>
                              </xsl:otherwise>
                            </xsl:choose>
                          </xsl:attribute>
                          <xsl:value-of select="$m_editpagetbut"/>
                        </a>
                      </li>
                    </xsl:if>
                    <xsl:if test="/H2G2/ARTICLE/ARTICLEINFO/FORUMID">
                      <li>
                        <a>
                          <xsl:attribute name="href">
                            AddThread?forum=<xsl:value-of select="/H2G2/ARTICLE/ARTICLEINFO/FORUMID"/>&amp;article=<xsl:value-of select="/H2G2/ARTICLE/ARTICLEINFO/H2G2ID"/>
                          </xsl:attribute>
                          <xsl:value-of select="$m_leavemessage"/>
                        </a>
                      </li>                      
                    </xsl:if>
                    <xsl:if test="$ownerisviewer=0 and $registered=1">
                      <li>
                        <a href="Watch{$viewerid}?add=1&amp;adduser={/H2G2/PAGE-OWNER/USER/USERID}">
                          Add to Friends
                        </a>
                      </li>
                    </xsl:if>
                    <xsl:if test="$ownerisviewer=0 and $registered=1">
                      <li>
                        <a href="{$root}MUS{/H2G2/VIEWING-USER/USER/USERID}?dnaaction=subscribe&amp;subscribedtoid={/H2G2/PAGE-OWNER/USER/USERID}">Subscribe to User</a>
                      </li>
                    </xsl:if>
                    </ul>
                </td>
								<xsl:choose>
									<xsl:when test="name(/H2G2/PAGE-OWNER/USER/GROUPS/*) = msxsl:node-set($subbadges)/GROUPBADGE/@NAME"><td width="1" rowspan="7" bgcolor="#333333" style="background:#CCCCCC"><img src="{$imagesource}t.gif" width="1" height="1" alt="" /></td></xsl:when>
									<xsl:otherwise><td width="1" rowspan="3" bgcolor="#333333" style="background:#CCCCCC"><img src="{$imagesource}t.gif" width="1" height="1" alt="" /></td></xsl:otherwise>
								</xsl:choose>
							</tr>
							<tr>
								<td colspan="2"><img src="{$imagesource}t.gif" width="1" height="1" alt="" /></td>
							</tr>
						</xsl:when>
						<xsl:otherwise> 
							<tr valign="top">
								<xsl:choose>
									<xsl:when test="name(/H2G2/PAGE-OWNER/USER/GROUPS/*) = msxsl:node-set($subbadges)/GROUPBADGE/@NAME"><td width="1" rowspan="6"><img src="{$imagesource}t.gif" width="1" height="1" alt="" /></td></xsl:when>
									<xsl:otherwise><td width="1" rowspan="2"><img src="{$imagesource}t.gif" width="1" height="1" alt="" /></td></xsl:otherwise>
								</xsl:choose>
								<td width="1" style="background:#CCCCCC"><img src="{$imagesource}t.gif" width="1" height="1" alt="" /></td>
								<td width="197" style="background:#CCCCCC"><img src="{$imagesource}t.gif" width="197" height="1" alt="" /></td>
								<td width="1" rowspan="2" style="background:#CCCCCC"><img src="{$imagesource}t.gif" width="1" height="1" alt="" /></td>
								<xsl:choose>
									<xsl:when test="name(/H2G2/PAGE-OWNER/USER/GROUPS/*) = msxsl:node-set($subbadges)/GROUPBADGE/@NAME"><td width="1" rowspan="6" style="background:#CCCCCC"><img src="{$imagesource}t.gif" width="1" height="1" alt="" /></td></xsl:when>
									<xsl:otherwise><td width="1" rowspan="2" style="background:#CCCCCC"><img src="{$imagesource}t.gif" width="1" height="1" alt="" /></td></xsl:otherwise>
								</xsl:choose>
							</tr>
						</xsl:otherwise>
					</xsl:choose>
					
					<xsl:if test="name(/H2G2/PAGE-OWNER/USER/GROUPS/*) = msxsl:node-set($subbadges)/GROUPBADGE/@NAME">
						<tr valign="top">
							<td bgcolor="#333333" style="background:#CCCCCC"><img src="{$imagesource}t.gif" width="1" height="1" alt="" /></td>
							<td>
								<table width="197" cellspacing="0" cellpadding="3" border="0" background="">
									<tr>
										<td bgcolor="#333333" style="background:#CCCCCC"><font xsl:use-attribute-sets="smallfont" class="postxt"><b><xsl:value-of select="$m_researcher_badges"/></b></font><br clear="all" /><img src="{$imagesource}t.gif" width="191" height="1" alt="" /></td>
									</tr>
								</table>
							</td>
						</tr>
						<tr>
							<td colspan="2"><img src="{$imagesource}t.gif" width="1" height="1" alt="" /></td>
						</tr>
						<tr>
							<td colspan="2" bgcolor="#FFFFFF"><br /><xsl:apply-templates select="/H2G2/PAGE-OWNER/USER/GROUPS"/><br /></td>
						</tr>
						<tr>
							<td colspan="2"><img src="{$imagesource}t.gif" width="1" height="1" alt="" /></td>
						</tr>
					</xsl:if>
					<tr valign="top">
						<td bgcolor="#333333" style="background:#CCCCCC"><img src="{$imagesource}t.gif" width="1" height="1" alt="" /></td>
						<td>
							<table width="197" cellspacing="0" cellpadding="3" border="0" background="">
								<tr>
									<td colspan="3" bgcolor="#333333" style="background:#CCCCCC"><font xsl:use-attribute-sets="smallfont" class="postxt"><b><xsl:value-of select="$m_researcher_data"/></b></font><br clear="all" /><img src="{$imagesource}t.gif" width="191" height="1" alt="" /></td>
								</tr>
								<tr>
									<td colspan="3"><img src="{$imagesource}t.gif" width="1" height="1" alt="" /></td>
								</tr>
								<tr valign="top">
									<td><img src="{$imagesource}bullet_fake_white.gif" width="14" height="14" alt="" border="0" /></td>
									<td>
										<font xsl:use-attribute-sets="smallfont">
											<b><xsl:value-of select="$m_psabme_name"/></b><br /><br />
											<xsl:apply-templates select="/H2G2/PAGE-OWNER/USER" mode="showonline">
												<xsl:with-param name="symbol"><img src="{$imagesource}online_brunel.jpg" alt="Online Now" width="21" height="11"/></xsl:with-param>
											</xsl:apply-templates>
<xsl:value-of select="/H2G2/PAGE-OWNER/USER/USERNAME"/>
											<br />
											<xsl:if test="$test_IsEditor">
											<a href="{$root}InspectUser?userid={/H2G2/PAGE-OWNER/USER/USERID}">Inspect This User</a><br/>
											<a href="{$root}ModerationHistory?h2g2id={/H2G2/ARTICLE/ARTICLEINFO/H2G2ID}">Moderation History</a><br/>
											</xsl:if>
											<xsl:choose>
												<xsl:when test="msxsl:node-set($lastpostbyusersort)/DATE">
													<xsl:value-of select="$m_myconvslastposted"/>
													<xsl:value-of select="$lastpostbyuser"/>
												</xsl:when>
												<xsl:otherwise>
													<xsl:copy-of select="$m_norecentpostings"/>
												</xsl:otherwise>
											</xsl:choose>	
											<br />
										</font>
									</td>
									<td><img src="{$imagesource}t.gif" width="4" height="1" alt="" /></td>
								</tr>
								<tr>
									<td><img src="{$imagesource}t.gif" width="14" height="1" alt="" border="0" /></td>
									<td background="{$imagesource}dotted_line_inv.jpg"><img src="{$imagesource}t.gif" width="1" height="3" alt="" /></td>
									<td><img src="{$imagesource}t.gif" width="4" height="1" alt="" /></td>
								</tr>
								<tr valign="top">
									<td><img src="{$imagesource}bullet_fake_white.gif" width="14" height="14" alt="" border="0" /></td>
									<td>
										<font xsl:use-attribute-sets="smallfont">
											<b><xsl:value-of select="$m_psabme_resno"/></b><br /><br />
											<xsl:value-of select="/H2G2/PAGE-OWNER/USER/USERID"/>
											<br /><br />
										</font>
									</td>
									<td><img src="{$imagesource}t.gif" width="4" height="1" alt="" /></td>
								</tr>
								<tr>
									<td><img src="{$imagesource}t.gif" width="14" height="1" alt="" border="0" /></td>
									<td background="{$imagesource}dotted_line_inv.jpg"><img src="{$imagesource}t.gif" width="1" height="3" alt="" /></td>
									<td><img src="{$imagesource}t.gif" width="4" height="1" alt="" /></td>
								</tr>
								<xsl:apply-templates select="/H2G2/ARTICLE/ARTICLEINFO/REFERENCES" />
								<tr>
									<td width="14"><img src="{$imagesource}t.gif" width="14" height="1" alt="" border="0" /></td>
									<td width="161"><img src="{$imagesource}t.gif" width="161" height="3" alt="" /></td>
									<td width="4"><img src="{$imagesource}t.gif" width="4" height="1" alt="" /></td>
								</tr>
								<tr>
									<td colspan="3"><img src="{$imagesource}t.gif" width="1" height="20" alt="" /></td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
</xsl:template>

</xsl:stylesheet>