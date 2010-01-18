<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0" 
                xmlns:msxsl="urn:schemas-microsoft-com:xslt" 
                xmlns:local="#local-functions" 
                xmlns:s="urn:schemas-microsoft-com:xml-data" 
                xmlns:dt="urn:schemas-microsoft-com:datatypes">

<xsl:template name="FRONTPAGE_TITLEDATA">
	<font xsl:use-attribute-sets="smallfont" color="{$colournorm}"><b>.</b></font>
	<br clear="ALL" /><img src="{$imagesource}t.gif" width="1" height="8" alt="" /><br clear="ALL" />
</xsl:template>

<xsl:template name="FRONTPAGE_SUBJECT">
	<xsl:call-template name="SUBJECTHEADER">
		<xsl:with-param name="text"><xsl:value-of select="$m_home_head"/></xsl:with-param>
	</xsl:call-template>
</xsl:template>

<xsl:template name="FRONTPAGE_MAINBODY">
	<xsl:call-template name="FRONTPAGE_LEFTCOL"/>
	<td width="100%" bgcolor="#000000" class="postable">
		<xsl:apply-templates select="/H2G2/ARTICLE/FRONTPAGE/MAIN-SECTIONS/EDITORIAL/EDITORIAL-ITEM[@COLUMN!='2']">
			<xsl:sort select="PRIORITY" data-type="number" order="ascending"/>
		</xsl:apply-templates>
			<xsl:apply-templates select="/H2G2/ARTICLE/FRONTPAGE/MAIN-SECTIONS/EDITORIAL/EDITORIAL-ITEM[@COLUMN='2']">
				<xsl:sort select="PRIORITY" data-type="number" order="ascending"/>
			</xsl:apply-templates>
		<br clear="all" />
		<img src="{$imagesource}t.gif" width="1" height="15" alt="" /><br clear="all" />
	</td> 
</xsl:template>

<xsl:template name="FRONTPAGE_LEFTCOL">
	<!--td width="157" background="{$imagesource}homepage/bg_left.gif">
		<table width="157" cellspacing="0" cellpadding="0" border="0" bgcolor="#000000" class="postable">
			<tr>
				<td width="156">
					<img src="{$imagesource}homepage/rivets_top.gif" width="156" height="10" alt="" border="0" /><br clear="all" />
					<a href="DontPanic-Tour"><img src="{$imagesource}homepage/dont_panic.gif" width="156" height="90" alt="Don't Panic - What is h2g2" border="0" /></a><br clear="all" />
						<table width="156" cellspacing="0" cellpadding="15" border="0" bgcolor="#000000" class="postable">
						<tr>
							<td><font xsl:use-attribute-sets="xsmallfont" class="postxt"><xsl:call-template name="m_home_lue"/><br clear="all" /></font></td>
						</tr>
					</table>
					<a href="DontPanic-Tour"><img src="{$imagesource}homepage/how2_h2g2.gif" width="156" height="78" alt="How to use h2g2" border="0" /></a><br clear="all" />
					<img src="{$imagesource}homepage/rivets_bot.gif" width="156" height="9" alt="" border="0" /><br clear="all" /><img src="{$imagesource}t.gif" width="1" height="5" alt="" />
					<xsl:if test="$registered!=1">
						<table width="156" cellspacing="0" cellpadding="8" border="0" bgcolor="#000000" class="postable">
							<tr>
								<td><font xsl:use-attribute-sets="subheaderfont" class="postxt"><a href="Register" class="pos"><i><b><xsl:value-of select="$m_home_regnow"/></b></i></a></font><br /><font xsl:use-attribute-sets="smallfont" class="postxt"><i><b><xsl:value-of select="$m_home_helpbuildguide"/><br clear="all" /></b></i></font></td>
							</tr>
						</table>
						<img src="{$imagesource}homepage/dots_extra_news.gif" width="156" height="3" alt="" border="0" /><br clear="all" />
						<table width="156" cellspacing="0" cellpadding="15" border="0" bgcolor="#000000" class="postable">
							<tr>
								<td><font xsl:use-attribute-sets="mainfont" class="postxt"><xsl:call-template name="m_home_regdetails"/><br /><br />
									<img src="{$imagesource}homepage/fake_bullet.gif" width="10" height="8" alt="" border="0" /><xsl:value-of select="$m_home_regdetailsa"/><br /><br />
									<img src="{$imagesource}homepage/fake_bullet.gif" width="10" height="8" alt="" border="0" /><xsl:value-of select="$m_home_regdetailsb"/><br /><br />
									<img src="{$imagesource}homepage/fake_bullet.gif" width="10" height="8" alt="" border="0" /><xsl:value-of select="$m_home_regdetailsc"/><br /><br />
									<img src="{$imagesource}homepage/fake_bullet.gif" width="10" height="8" alt="" border="0" /><xsl:value-of select="$m_home_regdetailsd"/><br clear="all" /></font>
								</td>
							</tr>
						</table>
						<img src="{$imagesource}homepage/dots_extra_news.gif" width="156" height="3" alt="" border="0" /><br clear="all" />
					</xsl:if>
					<xsl:apply-templates select="/H2G2/ARTICLE/FRONTPAGE/MAIN-SECTIONS/EDITORIAL/EDITORIAL-ITEM[@COLUMN='2']">
						<xsl:sort select="PRIORITY" data-type="number" order="ascending"/>
					</xsl:apply-templates>
				</td>
				<td width="1" bgcolor="#333333" style="background:#000000"><img src="{$imagesource}t.gif" width="1" height="1" alt="" /></td>
			</tr>
		</table>
		<br clear="all" /><img src="{$imagesource}t.gif" width="1" height="15" alt="" /><br clear="all" />
	</td-->
</xsl:template>
	
<xsl:template name="FRONTPAGE_SIDEBAR">
	<td width="200" background="{$imagesource}perspace/entrydata_bg.gif">
      <div class="catblock-title">
        <xsl:value-of select="translate(string(/H2G2/ARTICLE/FRONTPAGE/MAIN-SECTIONS/CATEGORISATION/CATBLOCK/TITLE),'abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>
      </div>
    <div class="catblock-categorisation">
      <xsl:apply-templates select="/H2G2/ARTICLE/FRONTPAGE/MAIN-SECTIONS/CATEGORISATION" mode="simple"/>
    </div>
    <div class="catblock-topfives">
      <xsl:apply-templates select="/H2G2/TOP-FIVES" mode="simple"/>
    </div>
		<!--<table width="200" cellspacing="0" cellpadding="0" border="0" bgcolor="#000000">
			<tr valign="top">
				<td width="1" bgcolor="#000000"><img src="{$imagesource}t.gif" width="1" height="1" alt="" /></td>
				<td width="1" bgcolor="#333333" style="background:#CCCCCC"><img src="{$imagesource}t.gif" width="1" height="1" alt="" /></td>
				<td width="197">
					<table width="197" cellspacing="0" cellpadding="3" border="0" bgcolor="#000000">
						<tr>
							<td colspan="3"><img src="{$imagesource}t.gif" width="1" height="1" alt="" /></td>
						</tr>
						<xsl:apply-templates select="/H2G2/ARTICLE/FRONTPAGE/MAIN-SECTIONS/CATEGORISATION" />
						<xsl:apply-templates select="/H2G2/TOP-FIVES" />
					</table>
					<br clear="all" /><img src="{$imagesource}t.gif" width="1" height="15" alt="" /><br clear="all" />
				</td>
				<td width="1" bgcolor="#333333" style="background:#CCCCCC"><img src="{$imagesource}t.gif" width="1" height="1" alt="" /></td>
			</tr>
		</table>-->
	</td>
</xsl:template>

  <xsl:template match="TOP-FIVES" mode="simple">
    <xsl:apply-templates select="TOP-FIVE[not(@NAME='LeastViewed' or @NAME='MostRecent' or @NAME='MostRecentConversations' or @NAME='MostRecentUser') or (@NAME='LeastViewed' or @NAME='MostRecent' or @NAME='MostRecentConversations' or @NAME='MostRecentUser') and (@NAME = /H2G2/ARTICLE/FRONTPAGE/TOP-FIVES/AUTO-TOP-FIVE)] | /H2G2/ARTICLE/FRONTPAGE/TOP-FIVES/TOP-FIVE" mode="simple"/>
  </xsl:template>
  <xsl:template match="TOP-FIVE" mode="simple">
    <h3><xsl:value-of select="TITLE" /></h3>
    <div class="catblock-topfive">
      <ol>
        <xsl:apply-templates select="TOP-FIVE-ARTICLE | TOP-FIVE-FORUM | TOP-FIVE-ITEM" mode="simple"/>
      </ol>
    </div>
  </xsl:template>

  <xsl:template match="TOP-FIVE-ARTICLE" mode="simple">
    <li><a><xsl:attribute name="HREF">
		<xsl:value-of select="$root"/>A<xsl:value-of select="H2G2ID"/></xsl:attribute>
		<xsl:value-of select="SUBJECT"/>
	</a>
    </li> 
  </xsl:template>
  
  <xsl:template match="TOP-FIVE-FORUM" mode="simple">
    <li><a>
		<xsl:attribute name="HREF"><xsl:value-of select="$root"/>F<xsl:value-of select="FORUMID"/></xsl:attribute>
		<xsl:value-of select="SUBJECT"/>
	</a>
    </li>
  </xsl:template>
  
  <xsl:template match="TOP-FIVE-ITEM" mode="simple">
    <li>
    <a href="{ADDRESS}">
		<xsl:value-of select="SUBJECT"/>
	</a></li>
  </xsl:template>
  
  <xsl:template mode="frontpage" match="BODY">
	<font xsl:use-attribute-sets="textfont">
		<xsl:apply-templates />
	</font>
</xsl:template>

<!--<xsl:template match="TOP-FIVES">
	--><!--xsl:apply-templates select="TOP-FIVE[not(@NAME='LeastViewed' or @NAME='MostRecent' or @NAME='MostRecentConversations' or @NAME='MostRecentUser')]"/--><!--
	<xsl:apply-templates select="TOP-FIVE[not(@NAME='LeastViewed' or @NAME='MostRecent' or @NAME='MostRecentConversations' or @NAME='MostRecentUser') or (@NAME='LeastViewed' or @NAME='MostRecent' or @NAME='MostRecentConversations' or @NAME='MostRecentUser') and (@NAME = /H2G2/ARTICLE/FRONTPAGE/TOP-FIVES/AUTO-TOP-FIVE)] | /H2G2/ARTICLE/FRONTPAGE/TOP-FIVES/TOP-FIVE"/>

</xsl:template>

<xsl:template match="TOP-FIVE">
	<xsl:if test="position()>1">
		<tr>
			<td background="{$imagesource}dotted_line_inv.jpg" colspan="3"><img src="{$imagesource}t.gif" width="1" height="3" alt="" /></td>
		</tr>
	</xsl:if>
	<tr valign="top">
		<td rowspan="2"><img src="{$imagesource}bullet_fake_white.gif" width="14" height="14" alt="" border="0" /></td>
		<td>
			<font xsl:use-attribute-sets="smallfont">
				<b><xsl:value-of select="TITLE" /></b>
			</font>
		</td>
		<td rowspan="2"><img src="{$imagesource}t.gif" width="4" height="1" alt="" /></td>
	</tr>
	<tr>
		<td>
			<font xsl:use-attribute-sets="smallfont">
				<xsl:choose>
					<xsl:when test="/H2G2/ARTICLE/FRONTPAGE/TOP-FIVES/AUTO-TOP-FIVE[.=current()/@NAME]">
						<xsl:variable name="display" select="/H2G2/ARTICLE/FRONTPAGE/TOP-FIVES/AUTO-TOP-FIVE[.=current()/@NAME]/@SHOW + 1"/>
						--><!-- Set the number of TOP-FIVE's to display for the auto-generated top-fives --><!--
						<xsl:apply-templates select="TOP-FIVE-ARTICLE[position() &lt; $display] | TOP-FIVE-FORUM[position() &lt; $display] | TOP-FIVE-ITEM[position() &lt; $display]"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="TOP-FIVE-ARTICLE | TOP-FIVE-FORUM | TOP-FIVE-ITEM"/>
					</xsl:otherwise>
				</xsl:choose>
			</font>
		</td>
	</tr>
</xsl:template>

<xsl:template match="TOP-FIVE-ARTICLE">
	<xsl:value-of select="position()" />.<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
	<a class="norm"><xsl:attribute name="HREF">
		<xsl:value-of select="$root"/>A<xsl:value-of select="H2G2ID"/></xsl:attribute>
		<xsl:value-of select="SUBJECT"/>
	</a>
	<br />
</xsl:template>

<xsl:template match="TOP-FIVE-FORUM">
	<xsl:value-of select="position()" />.<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
	<a class="norm">
		<xsl:attribute name="HREF"><xsl:value-of select="$root"/>F<xsl:value-of select="FORUMID"/></xsl:attribute>
		<xsl:value-of select="SUBJECT"/>
	</a>
	<br />
</xsl:template>
<xsl:template match="TOP-FIVE-ITEM">
	<xsl:value-of select="position()" />.<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
	<a class="norm" href="{ADDRESS}">
		<xsl:value-of select="SUBJECT"/>
	</a>

	<br />
</xsl:template>


<xsl:template match="CATEGORISATION">
	<xsl:apply-templates select="CATBLOCK"/>
</xsl:template>-->
  
  <xsl:template match="CATEGORISATION" mode="simple">
    <xsl:apply-templates select="CATBLOCK" mode="simple"/>
  </xsl:template>

  <xsl:template match="CATBLOCK" mode="simple">
    <xsl:apply-templates select="CATEGORY" mode="simple" />
    <div class="catblock-links">
    <xsl:apply-templates select="P/LINK" mode="simple"/>
    </div>
  </xsl:template>

  <xsl:template match="CATEGORY" mode="simple">
    <h3><xsl:value-of select="NAME"/></h3>
    <p>
      <xsl:apply-templates select="SUBCATEGORY"/>
    </p>
  </xsl:template>
  
  <xsl:template match="LINK" mode="simple">
    <a href="{@HREF}">
        <xsl:value-of select="."/>
    </a>
  </xsl:template>

  <!--<xsl:template match="CATEGORISATION/CATBLOCK">
	<xsl:apply-templates select="CATEGORY" />
	<xsl:if test="P/LINK">
	<xsl:for-each select="P/LINK">
	<tr valign="top">
		<td width="14"><img src="{$imagesource}bullet_fake_white.gif" width="14" height="14" alt="" border="0" /></td>
		<td width="161">
			<font xsl:use-attribute-sets="smallfont">
				<a class="norm" href="{@HREF}"><b><xsl:value-of select="."/></b></a>
			</font>
		</td>
		<td width="4"><img src="{$imagesource}t.gif" width="4" height="1" alt="" /></td>
	</tr>
	</xsl:for-each>
	<tr>
		<td background="{$imagesource}dotted_line_inv.jpg" colspan="3"><img src="{$imagesource}t.gif" width="1" height="3" alt="" /></td>
	</tr>
	</xsl:if>

</xsl:template>-->

<!--<xsl:template match="CATEGORY">
	<tr valign="top">
		<td width="14"><img src="{$imagesource}bullet_fake_white.gif" width="14" height="14" alt="" border="0" /></td>
		<td width="161">
			<font xsl:use-attribute-sets="smallfont">
				<b><xsl:value-of select="NAME"/></b>
				<br /><br />
				<xsl:apply-templates select="SUBCATEGORY"/>
				<br /><br />
			</font>
		</td>
		<td width="4"><img src="{$imagesource}t.gif" width="4" height="1" alt="" /></td>
	</tr>
	<tr>
		<td background="{$imagesource}dotted_line_inv.jpg" colspan="3"><img src="{$imagesource}t.gif" width="1" height="3" alt="" /></td>
	</tr>
</xsl:template>-->

<xsl:template match="SUBCATEGORY">
	<xsl:if test="position()>1">, </xsl:if>
	<a><xsl:attribute name="HREF">
		<xsl:value-of select="$root"/>C<xsl:value-of select="CATID"/></xsl:attribute>
		<xsl:value-of select="NAME"/>
	</a>
</xsl:template>

<xsl:template match="EDITORIAL-ITEM"><!--xsl:template match="EDITORIAL-ITEM[@COLUMN='1']"-->
	<xsl:if test="(not(@TYPE)) or (@TYPE='REGISTERED' and $registered=1) or (@TYPE='UNREGISTERED' and $registered=0)">
	<table width="100%" cellspacing="0" cellpadding="3" border="0" bgcolor="#000000" class="postable">
		<tr>
			<td bgcolor="#333333" style="background:#666666">
			<xsl:if test="SUBJECT/@ALIGN">
				<xsl:attribute name="align"><xsl:value-of select="SUBJECT/@ALIGN"/></xsl:attribute>
				
			</xsl:if>
			<font xsl:use-attribute-sets="smallfont"><b><xsl:value-of select="translate(SUBJECT, 'abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/></b></font><br clear="all" /><img src="{$imagesource}t.gif" width="276" height="1" alt="" /></td>
		</tr>
	</table>
	<table width="100%" cellspacing="0" cellpadding="0" border="0">
		<tr>
			<td bgcolor="#000000"><img src="{$imagesource}t.gif" width="1" height="1" alt="" /></td>
		</tr>
	</table>
	<table width="100%" cellspacing="0" cellpadding="5" border="0">
		<tr>
			<td><br /><xsl:apply-templates mode="frontpage" select="BODY"/></td>
		</tr>	
		<xsl:if test="MORE">
		<tr>
			<td align="right"><font xsl:use-attribute-sets="textfont"><a href="{MORE/@DNAID|MORE/@H2G2|MORE/@BIO|MORE/@HREF}" class="pos"><b><xsl:value-of select="MORE"/></b></a></font></td>
		</tr>
		</xsl:if>
	</table>
	<xsl:if test="position()!=REGISTERED[last()] or position()!=UNREGISTERED[last()]">
		<table width="100%" cellspacing="0" cellpadding="0" border="0">
			<tr>
				<td bgcolor="#000000"><img src="{$imagesource}t.gif" width="1" height="1" alt="" /></td>
			</tr>
		</table>
	</xsl:if>
	</xsl:if>
</xsl:template>

<!--xsl:template match="EDITORIAL-ITEM[@COLUMN='2']">
	<xsl:if test="(not(@TYPE)) or (@TYPE='REGISTERED' and $registered=1) or (@TYPE='UNREGISTERED' and $registered=0)">
		<table width="100%" cellspacing="0" cellpadding="15" border="0" bgcolor="#000000" class="postable">
			<tr>
				<td>
					<font xsl:use-attribute-sets="xsubheaderfont">
						<b>
							<i>
								<xsl:value-of select="translate(SUBJECT, 'abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>
							</i>
						</b>
					</font><br/><br/>
					<xsl:apply-templates mode="frontpage" select="BODY" />
				</td>
			</tr>
		</table>
		<xsl:if test="position()!=REGISTERED[last()] or position()!=UNREGISTERED[last()]">
		<img src="{$imagesource}homepage/dots_extra_news.gif" width="156" height="3" alt="" border="0" /><br clear="all" />
		</xsl:if>
	</xsl:if>
</xsl:template-->

</xsl:stylesheet>