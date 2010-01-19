<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0" 
                xmlns:msxsl="urn:schemas-microsoft-com:xslt" 
                xmlns:local="#local-functions" 
                xmlns:s="urn:schemas-microsoft-com:xml-data" 
                xmlns:dt="urn:schemas-microsoft-com:datatypes">

<!-- IL start -->
<xsl:attribute-set name="maFORUMID_THREADS_MAINBODY">
	<xsl:attribute name="class">norm</xsl:attribute>
</xsl:attribute-set>
<!-- IL end -->

<xsl:template name="THREADS_TITLE">
	<title>
		<xsl:value-of select="$m_pagetitlestart"/><xsl:apply-templates select="/H2G2/FORUMSOURCE/*" mode="titlebar"/>
	</title>
</xsl:template>

<xsl:template name="THREADS_SUBJECT">
	<xsl:call-template name="SUBJECTHEADER">
		<xsl:with-param name="text">
			<xsl:call-template name="FORUMSOURCETITLE" />
		</xsl:with-param>
	</xsl:call-template>
</xsl:template>

<xsl:template name="THREADS_BAR">
	<xsl:call-template name="nuskin-homelinkbar">
		<xsl:with-param name="bardata">
			<table width="100%" cellspacing="0" cellpadding="0" border="0" bgcolor="#000000" class="postable">
				<tr>
					<td width="14" rowspan="4"><img src="{$imagesource}t.gif" width="14" height="1" alt="" /></td>
					<td width="100%"><img src="{$imagesource}t.gif" width="611" height="30" alt="" /></td>
					<td width="14" rowspan="4"><img src="{$imagesource}t.gif" width="14" height="1" alt="" /></td>
				</tr>
				<tr>
					<td>
						<font xsl:use-attribute-sets="subheaderfont" class="postxt"><b><xsl:apply-templates select="FORUMSOURCE" /></b></font>
					</td>
				</tr>
				<tr><td><img src="{$imagesource}t.gif" width="1" height="5" alt="" /></td></tr>
				<tr><td><img src="{$imagesource}t.gif" width="1" height="8" alt="" /></td></tr>
			</table>
		</xsl:with-param>
	</xsl:call-template>
</xsl:template>

<!-- IL start -->
<xsl:template name="THREADS_MAINBODY">
	<xsl:call-template name="showforumintro"/>
	<xsl:choose>
		<xsl:when test="FORUMTHREADS/THREAD">
			<xsl:apply-templates select="FORUMTHREADS" />
		</xsl:when>
		<xsl:otherwise>
			<p><font xsl:use-attribute-sets="mainfont">There are no conversations on this subject yet. Click on 'New Conversation' to start one.</font></p>
		</xsl:otherwise>
	</xsl:choose>
	<xsl:if test="not(/H2G2/FORUMSOURCE/REVIEWFORUM)">
		<xsl:call-template name="newconversationbutton"/><br />
	</xsl:if>
	<xsl:call-template name="subscribeforumthreads"/>
	<br /><br />
</xsl:template>

<xsl:template name="newconversationbutton">
	<img src="{$imagesource}arrowh.gif" width="3" height="9" alt="" border="0" hspace="3" />
	<font xsl:use-attribute-sets="mainfont"><b>
	<xsl:if test="not(/H2G2/FORUMSOURCE/REVIEWFORUM)">
		<xsl:if test="$test_AllowNewConversationBtn">
			<xsl:apply-templates select="FORUMTHREADS/@FORUMID" mode="THREADS_MAINBODY"/>
		</xsl:if>
	</xsl:if>

	<!--xsl:choose>
		<xsl:when test="FORUMTHREADS/@JOURNALOWNER">
			<xsl:if test="number(FORUMTHREADS/@JOURNALOWNER) = number(/H2G2/VIEWING-USER/USER/USERID)">
			<a class="norm">
				<xsl:attribute name="HREF"><xsl:value-of select="$root"/>AddThread?forum=<xsl:value-of select="FORUMTHREADS/@FORUMID" /></xsl:attribute>
				<xsl:attribute name="TARGET">_top</xsl:attribute>
				<xsl:value-of select="$alt_newconversation" />
			</a>
			</xsl:if>
		</xsl:when>
		<xsl:otherwise>
			<a class="norm">
				<xsl:attribute name="HREF"><xsl:value-of select="$root"/>AddThread?forum=<xsl:value-of select="FORUMTHREADS/@FORUMID" /></xsl:attribute>
				<xsl:attribute name="TARGET">_top</xsl:attribute>
				<xsl:value-of select="$alt_newconversation" />
			</a>
		</xsl:otherwise>
	</xsl:choose-->
	</b></font>
</xsl:template>

<xsl:template name="subscribeforumthreads">
	<xsl:if test="$registered=1">
		<img src="{$imagesource}arrowh.gif" width="3" height="9" alt="" border="0" hspace="3" />
		<font xsl:use-attribute-sets="mainfont"><b>
			<xsl:apply-templates select="FORUMTHREADS" mode="SubscribeUnsub"/>
		</b></font>
	</xsl:if>
</xsl:template>

<!-- IL end -->

<xsl:template name="threadnavbuttons">
	<xsl:param name="URL">FFO</xsl:param>
	<xsl:param name="ID"><xsl:value-of select="@FORUMID"/></xsl:param>
	<xsl:param name="ExtraParameters"/>
	<b>
		<xsl:choose>
			<xsl:when test="@SKIPTO != 0">
				<a class="norm" href="{$root}{$URL}{$ID}?skip={number(@SKIPTO) - number(@COUNT)}&amp;show={@COUNT}{$ExtraParameters}">
					<xsl:value-of select="$m_prevlist" />
				</a>
			</xsl:when>
			<xsl:otherwise><xsl:value-of select="$m_prevlist" /></xsl:otherwise>
		</xsl:choose>
		<font color="#ffffff"><xsl:value-of select="$skipdivider"/></font>
		<xsl:choose>
			<xsl:when test="@MORE">
				<a class="norm" href="{$root}{$URL}{$ID}?skip={number(@SKIPTO) + number(@COUNT)}&amp;show={@COUNT}{$ExtraParameters}">
					<xsl:value-of select="$m_nextlist" />
				</a>
			</xsl:when>
			<xsl:otherwise><xsl:value-of select="$m_nextlist" /></xsl:otherwise>
		</xsl:choose>
	</b>
</xsl:template>

<xsl:template name="zzzforumpostblocks">
	<xsl:param name="thread"></xsl:param>
	<xsl:param name="forum"></xsl:param>
	<xsl:param name="total"></xsl:param>
	<xsl:param name="show">20</xsl:param>
	<xsl:param name="skip">0</xsl:param>
	<xsl:param name="this">0</xsl:param>
	<xsl:param name="url">F</xsl:param>
	<xsl:param name="limit">250</xsl:param>
	<xsl:param name="splitevery">0</xsl:param>
	<xsl:param name="objectname"><xsl:value-of select="$m_postings"/></xsl:param>
	<xsl:param name="target">_top</xsl:param>
	<xsl:param name="image">none</xsl:param>
	<xsl:variable name="postblockon"><xsl:value-of select="$imagesource2"/>buttons/forumselected.gif</xsl:variable>
	<xsl:variable name="postblockoff"><xsl:value-of select="$imagesource2"/>buttons/forumunselected.gif</xsl:variable>
	<xsl:variable name="lower">
	<xsl:choose>
	<xsl:when test="$limit = 0">0</xsl:when>
	<xsl:otherwise><xsl:value-of select="(floor($this div $limit))*$limit"/></xsl:otherwise>
	</xsl:choose>
	</xsl:variable>
	<xsl:variable name="upper">
	<xsl:choose>
	<xsl:when test="$limit = 0"><xsl:value-of select="$total + $show"/></xsl:when>
	<xsl:otherwise><xsl:value-of select="$lower + $limit"/></xsl:otherwise>
	</xsl:choose>
	</xsl:variable>
<xsl:if test="(number($skip) > 0) or ((number($skip)) &lt; number($total))">
	<xsl:if test="(($skip div $show) mod $splitevery) = 0 and $splitevery &gt; 0 and $skip != 0">
		<br/>
	</xsl:if>
	<a>
		<xsl:if test="$target!=''">
			<xsl:attribute name="target"><xsl:value-of select="$target"/></xsl:attribute>
		</xsl:if>
		<xsl:attribute name="HREF">
			<xsl:value-of select="$root"/>
			<xsl:value-of select="$url"/>
			<xsl:value-of select="$forum"/>
			<xsl:choose>
				<xsl:when test="$thread!=''">?thread=<xsl:value-of select="$thread"/>&amp;</xsl:when>
				<xsl:otherwise>?</xsl:otherwise>
			</xsl:choose>
			skip=<xsl:value-of select="$skip"/>&amp;show=<xsl:value-of select="$show"/>
		</xsl:attribute>
		<xsl:variable name="PostRange">
			<xsl:value-of select="number($skip)+1"/>-<xsl:value-of select="number($skip) + number($show)"/>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="number($this) = number($skip)">
				<xsl:attribute name="TITLE">
					<xsl:value-of select="$alt_nowshowing"/>
					<xsl:value-of select="$objectname"/>
					<xsl:text> </xsl:text>
					<xsl:value-of select="$PostRange"/>
				</xsl:attribute>
				<img src="{$imagesource}pip_off.gif" width="7" height="7" hspace="2" vspace="3" border="0">
					<xsl:attribute name="alt">
						<xsl:value-of select="$objectname"/>
						<xsl:text> </xsl:text>
						<xsl:value-of select="$PostRange"/>
					</xsl:attribute>
				</img>
			</xsl:when>
			<xsl:otherwise>
				<xsl:attribute name="TITLE">
					<xsl:value-of select="$alt_show"/>
					<xsl:value-of select="$objectname"/>
					<xsl:text> </xsl:text>
					<xsl:value-of select="$PostRange"/>
				</xsl:attribute>
				<img src="{$imagesource}pip_on.gif" width="7" height="7" hspace="2" vspace="3" border="0">
					<xsl:attribute name="alt">
						<xsl:value-of select="$objectname"/>
						<xsl:text> </xsl:text>
						<xsl:value-of select="$PostRange"/>
					</xsl:attribute>
				</img>
			</xsl:otherwise>
		</xsl:choose>
	</a>
	<xsl:if test="(number($skip) + number($show)) &lt; number($total)">
		<xsl:call-template name="forumpostblocks">
			<xsl:with-param name="thread" select="$thread"/>
			<xsl:with-param name="forum" select="$forum"/>
			<xsl:with-param name="total" select="$total"/>
			<xsl:with-param name="show" select="$show"/>
			<xsl:with-param name="this" select="$this"/>
			<xsl:with-param name="skip" select="number($skip) + number($show)"/>
			<xsl:with-param name="url" select="$url"/>
			<xsl:with-param name="objectname" select="$objectname"/>
			<xsl:with-param name="target" select="$target"/>
			<xsl:with-param name="splitevery" select="$splitevery"/>
		</xsl:call-template>
	</xsl:if>
</xsl:if>
</xsl:template>

<xsl:template name="fpb_thisblock">
<xsl:param name="blocknumber"/>
<xsl:param name="objectname"/>
<xsl:param name="PostRange"/>
				<img src="{$imagesource}pip_on.gif" width="7" height="11" hspace="2" vspace="3" border="0">
					<xsl:attribute name="alt">
						<xsl:value-of select="$objectname"/>
						<xsl:text> </xsl:text>
						<xsl:value-of select="$PostRange"/>
					</xsl:attribute>
				</img>
</xsl:template>

<xsl:template name="fpb_otherblock">
<xsl:param name="blocknumber"/>
<xsl:param name="objectname"/>
<xsl:param name="PostRange"/>
				<img src="{$imagesource}pip_off.gif" width="7" height="11" hspace="2" vspace="3" border="0">
					<xsl:attribute name="alt">
						<xsl:value-of select="$objectname"/>
						<xsl:text> </xsl:text>
						<xsl:value-of select="$PostRange"/>
					</xsl:attribute>
				</img>
</xsl:template>

<xsl:template name="fpb_start">
				<img src="{$imagesource}startblock.gif" width="7" height="11" hspace="2" vspace="3" border="0">
				</img>
</xsl:template>

<xsl:template name="fpb_prevset">
				<img src="{$imagesource}prevblock.gif" width="7" height="11" hspace="2" vspace="3" border="0">
				</img>
</xsl:template>
<xsl:template name="fpb_nextset">
				<img src="{$imagesource}nextblock.gif" width="7" height="11" hspace="2" vspace="3" border="0">
				</img>
</xsl:template>
<xsl:template name="fpb_end">
				<img src="{$imagesource}endblock.gif" width="7" height="11" hspace="2" vspace="3" border="0">
				</img>
</xsl:template>

<xsl:template name="FORUMSOURCETITLE">
	<xsl:choose>
		<xsl:when test="/H2G2/FORUMSOURCE/ARTICLE"><xsl:value-of select="$m_threads_fstitle_art"/></xsl:when>
		<xsl:when test="/H2G2/FORUMSOURCE/JOURNAL"><xsl:value-of select="$m_threads_fstitle_jour"/></xsl:when>
		<xsl:when test="/H2G2/FORUMSOURCE/USERPAGE"><xsl:value-of select="$m_threads_fstitle_jour"/></xsl:when>
		<xsl:when test="/H2G2/FORUMSOURCE/REVIEWFORUM"><xsl:value-of select="$m_threads_fstitle_rev"/></xsl:when>
	</xsl:choose>
</xsl:template>

<xsl:template match="FORUMSOURCE" mode="titlebar">
	<xsl:apply-templates select="ARTICLE"/>
</xsl:template>

<xsl:template match="FORUMSOURCE[@TYPE='userpage']" mode="titlebar">
	<xsl:apply-templates select="ARTICLE"/>
</xsl:template>

<xsl:template match="FORUMSOURCE[@TYPE='journal']" mode="titlebar">
	<xsl:apply-templates select="JOURNAL"/>
</xsl:template>

<xsl:template match="FORUMSOURCE[@TYPE='reviewforum']" mode="titlebar">
	<xsl:apply-templates select="REVIEWFORUM"/>
</xsl:template>

<xsl:template match="FORUMSOURCE/ARTICLE" mode="titlebar">
Conversation - <xsl:value-of select="SUBJECT"/>
</xsl:template>

<xsl:template match="FORUMSOURCE/JOURNAL" mode="titlebar">
Journal of <xsl:value-of select="USER/USERNAME"/>
</xsl:template>

<xsl:template match="FORUMSOURCE/USERPAGE" mode="titlebar">
<xsl:value-of select="$m_threads_msglistof"/><xsl:value-of select="USER/USERNAME"/>
</xsl:template>

<xsl:template match="FORUMSOURCE/REVIEWFORUM" mode="titlebar">
Review Forum - <xsl:value-of select="REVIEWFORUMNAME" />
</xsl:template>

<xsl:template match = "FORUMSOURCE/ARTICLE">
	<xsl:value-of select="$m_thisconvforentry"/>
	<A class="pos">
		<xsl:attribute name="HREF"><xsl:value-of select="$root"/>A<xsl:value-of select="H2G2ID" /></xsl:attribute>
		<xsl:attribute name="TARGET">_top</xsl:attribute>
		<xsl:apply-templates mode="nosubject" select="SUBJECT"/>
	</A>
</xsl:template>

<xsl:template match = "FORUMSOURCE/JOURNAL">
	<xsl:value-of select="$m_thisjournal"/> 
	<A class="pos">
		<xsl:attribute name="HREF"><xsl:value-of select="$root"/>U<xsl:value-of select="USER/USERID" /></xsl:attribute>
		<xsl:attribute name="TARGET">_top</xsl:attribute>
		<xsl:value-of select="USER/USERNAME" />
	</A>
</xsl:template>

<xsl:template match = "FORUMSOURCE/USERPAGE">
	<xsl:value-of select="$m_thismessagecentre"/>
	<A class="pos">
		<xsl:attribute name="HREF"><xsl:value-of select="$root"/>U<xsl:value-of select="USER/USERID" /></xsl:attribute>
<!--		<xsl:attribute name="CLASS">pos</xsl:attribute> -->
		<xsl:attribute name="TARGET">_top</xsl:attribute>
		<xsl:value-of select="USER/USERNAME" />
	</A>
</xsl:template>

<xsl:template match = "FORUMSOURCE/REVIEWFORUM">
	<xsl:value-of select="$m_thisconvforentry"/> 
	<A class="pos">
		<xsl:attribute name="HREF"><xsl:value-of select="$root"/>RF<xsl:value-of select="@ID" /></xsl:attribute>
		<xsl:attribute name="TARGET">_top</xsl:attribute>
		<xsl:value-of select="REVIEWFORUMNAME" />
	</A>
</xsl:template>

<xsl:template name="showforumintro">
<xsl:if test="FORUMSOURCE/ARTICLE/GUIDE/FORUMTHREADINTRO|FORUMSOURCE/ARTICLE/GUIDE/FORUMINTRO">
		<table width="100%" cellspacing="0" cellpadding="0" border="0" bgcolor="#000000" class="postable">
			<tr>
				<td width="14" rowspan="4"><img src="{$imagesource}t.gif" width="14" height="1" alt="" /></td>
				<td width="100%" background="{$imagesource}dotted_line_sml.jpg"><img src="{$imagesource}t.gif" width="611" height="5" alt="" /></td>
				<td width="14" rowspan="4"><img src="{$imagesource}t.gif" width="14" height="1" alt="" /></td>
			</tr>
			<tr>
				<td><img src="{$imagesource}t.gif" width="1" height="10" alt="" /></td>
			</tr>
			<tr>
				<td><font xsl:use-attribute-sets="mainfont" class="postxt"><xsl:apply-templates select="FORUMSOURCE/ARTICLE/GUIDE/FORUMTHREADINTRO|FORUMSOURCE/ARTICLE/GUIDE/FORUMINTRO"/></font></td>
			</tr>
			<tr>
				<td><img src="{$imagesource}t.gif" width="1" height="10" alt="" /></td>
			</tr>
		</table>
</xsl:if>
</xsl:template>

</xsl:stylesheet>
