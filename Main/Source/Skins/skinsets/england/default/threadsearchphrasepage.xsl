<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<xsl:import href="../../../base/base-threadsearchphrasepage.xsl"/>
		<xsl:template name="THREADSEARCHPHRASE_HEADER">
		<xsl:apply-templates mode="header" select=".">
			<xsl:with-param name="title">BBC Where I Live: The place for local discussion</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>
	<!-- 
	<xsl:template name="THREADSEARCHPHRASE_CSS">
	Use: CSS for this page
	-->
	<!--xsl:template name="THREADSEARCHPHRASE_CSS">
		<LINK TYPE="text/css" REL="stylesheet" HREF="http://sandbox0.bu.bbc.co.uk/tw/mb/messageboards.css"/>
	</xsl:template-->
	<!-- 
	<xsl:template name="THREADSEARCHPHRASE_MAINBODY">
	Use: Presentation of the Thread search phrase page - don't blame me i didn't name it.
	-->
	<xsl:variable name="this_region">
		<xsl:choose>
			<xsl:when test="/H2G2/THREADSEARCHPHRASE/PHRASES/PHRASE/NAME[. = msxsl:node-set($list_of_regions)/region]">
				<xsl:value-of select="/H2G2/THREADSEARCHPHRASE/PHRASES/PHRASE/NAME[. = msxsl:node-set($list_of_regions)/region]"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>England</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:template name="THREADSEARCHPHRASE_MAINBODY">
		<div id="lhcol">
			<xsl:if test="/H2G2/PARAMS/PARAM[NAME='s_page']/VALUE='morephrases'">
				<div style="float:left;">
					<h2>
						<xsl:text>More tags</xsl:text>
					</h2>
				</div>
				<div id="moreTagsToBoards">
					<a href="{$root}TSP">&lt;&lt; back to messageboard</a>
				</div>
			</xsl:if>
			<xsl:if test="/H2G2/ADDTHREADSEARCHPHRASE">
				<table cellpadding="0" cellspacing="0" border="0" width="100%">
					<tr>
						<td id="crumbtrail">
							<h5>
								<xsl:text>You are here &gt; </xsl:text>
								<a href="{$homepage}">BBC England Messageboard</a>
								<xsl:text> &gt; Add a tag</xsl:text>
							</h5>
						</td>
					</tr>
				</table>
			</xsl:if>
			<xsl:choose>
				<xsl:when test="THREADSEARCHPHRASE/PHRASES/PHRASE[not(NAME = msxsl:node-set($list_of_regions)/region)]">
					<xsl:apply-templates select="HOT-PHRASES" mode="c_threadsearchphrasepage"/>
					<xsl:apply-templates select="THREADSEARCHPHRASE" mode="c_searchthreadsearchphrasepage"/>
					<xsl:apply-templates select="THREADSEARCHPHRASE/BOARDPROMOLIST/BOARDPROMO" mode="choose_promotypetagging"/>
					<div class="TspThreadList">
						<!--h3>
							<xsl:text>All discussions in </xsl:text>
							<xsl:value-of select="$this_region"/>
						</h3-->
						<xsl:apply-templates select="THREADSEARCHPHRASE/PHRASES" mode="c_region"/>
						<xsl:apply-templates select="THREADSEARCHPHRASE" mode="c_newthread"/>
						<xsl:apply-templates select="THREADSEARCHPHRASE/THREADSEARCH" mode="c_threadsearchphrasepage"/>
					</div>
				</xsl:when>
				<xsl:when test="/H2G2/PARAMS/PARAM[NAME='s_page']/VALUE='morephrases'">
					<xsl:apply-templates select="THREADSEARCHPHRASE/PHRASES" mode="c_region"/>
					<xsl:apply-templates select="THREADSEARCHPHRASE" mode="c_searchthreadsearchphrasepage"/>
					<xsl:apply-templates select="THREADSEARCHPHRASE/BOARDPROMOLIST/BOARDPROMO" mode="choose_promotypetagging"/>
					<xsl:apply-templates select="HOT-PHRASES" mode="c_threadsearchphrasepage"/>
				</xsl:when>
				<xsl:when test="ADDTHREADSEARCHPHRASE">
					<xsl:apply-templates select="ADDTHREADSEARCHPHRASE" mode="c_add"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="THREADSEARCHPHRASE/PHRASES" mode="c_region"/>
					<xsl:apply-templates select="THREADSEARCHPHRASE" mode="c_searchthreadsearchphrasepage"/>
					<xsl:apply-templates select="THREADSEARCHPHRASE/BOARDPROMOLIST/BOARDPROMO" mode="choose_promotypetagging"/>
					<xsl:apply-templates select="HOT-PHRASES" mode="c_threadsearchphrasepage"/>
					<div class="TspThreadList">
						<h3>
							<xsl:text>All discussions in </xsl:text>
							<xsl:value-of select="$this_region"/>
						</h3>
						<xsl:apply-templates select="THREADSEARCHPHRASE" mode="c_newthread"/>
						<xsl:apply-templates select="THREADSEARCHPHRASE/THREADSEARCH" mode="c_threadsearchphrasepage"/>
					</div>
				</xsl:otherwise>
			</xsl:choose>
		</div>
		<xsl:if test="not(/H2G2/ADDTHREADSEARCHPHRASE)">
			<div id="rhcol">
				<!-- URL's used in the movie-->
				<!-- text used in the movie-->
				<div class="englandMap">
					<!--object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" codebase="http://fpdownload.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=7,0,0,0" width="190" height="235" id="welcome" align="middle">
						<param name="allowScriptAccess" value="sameDomain"/>
						<param name="movie" value="{$swfpath}englandmap.swf"/>
						<param name="quality" value="high"/>
						<param name="wmode" value="transparent"/>
						<embed src="{$swfpath}englandmap.swf" quality="high" wmode="transparent" bgcolor="#ffffff" width="190" height="235" name="welcome" align="middle" allowScriptAccess="sameDomain" type="application/x-shockwave-flash" pluginspage="http://www.macromedia.com/go/getflashplayer"/>
					</object-->
						<object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" codebase="http://fpdownload.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=7,0,0,0" width="190" height="235" id="welcome" align="middle">
						<param name="allowScriptAccess" value="sameDomain"/>
						<param name="movie" value="{$swfpath}map3.swf"/>
						<param name="FlashVars">
							<xsl:attribute name="value">
								<xsl:text>scores=</xsl:text>
								<xsl:for-each select="/H2G2/THREADSEARCHPHRASE/SITEKEYPHRASES/KEYPHRASE[not(NAME='Channel Islands' or NAME='England')]">
									<xsl:sort select="NAME" order="ascending" data-type="text"/>
									<!--xsl:value-of select="format-number(SCORE * 10, '0')"/-->
									<xsl:value-of select="SCORE"/>
									<xsl:if test="position() != last()">,</xsl:if>
								</xsl:for-each>
							</xsl:attribute>
						</param> 
						<param name="quality" value="high"/>
						<param name="wmode" value="transparent"/>
						<embed src="{$swfpath}map3.swf" quality="high" wmode="transparent" bgcolor="#ffffff" width="190" height="235" name="welcome" align="middle" allowScriptAccess="sameDomain" type="application/x-shockwave-flash" pluginspage="http://www.macromedia.com/go/getflashplayer">
							<xsl:attribute name="FlashVars">
								<xsl:text>scores=</xsl:text>
								<xsl:for-each select="/H2G2/THREADSEARCHPHRASE/SITEKEYPHRASES/KEYPHRASE[not(NAME='Channel Islands' or NAME='England')]">
									<xsl:sort select="NAME" order="ascending" data-type="text"/>
									<!--xsl:value-of select="format-number(SCORE * 10, '0')"/-->
									<xsl:value-of select="SCORE"/>
									<xsl:if test="position() != last()">,</xsl:if>
								</xsl:for-each>
							</xsl:attribute>

</embed>
					</object>

				</div>
			
				<div class="openingHours">
					<p>This messageboard is now closed.
					</p>
				</div>
			</div>
		</xsl:if>
	</xsl:template>
	<!-- 
	<xsl:template match="THREADSEARCHPHRASE" mode="r_searchthreadsearchphrasepage">
	Use: Presentation of the search box
	-->
	<xsl:template match="THREADSEARCHPHRASE" mode="r_searchthreadsearchphrasepage">
		<div class="TspSearchObject">
			<div class="TspSearch">
				<p>
					<xsl:text>Find conversations tagged with these words:</xsl:text>&nbsp;
					<xsl:apply-templates select="." mode="t_searchinput"/>&nbsp;
					<xsl:apply-templates select="." mode="t_searchsubmit"/>
				</p>
			</div>
		</div>
	</xsl:template>
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
					THREAD Logical Container Template
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<xsl:template match="THREADSEARCH" mode="empty_threadsearchphrasepage">
		<!--div class="TspDiscussions">
			<h4>There are currently no discussions</h4>
		</div-->
	</xsl:template>
	<!--
	<xsl:template match="THREAD" mode="r_threadspage">
	Use: Presentation of a collection of threads in a THREADSEARCHPHRASE page
	 -->
	<xsl:template match="THREADSEARCH" mode="full_threadsearchphrasepage">
		<div class="TspDiscussions">
			<h4>
				<span class="strong">Discussions</span>  &nbsp;<xsl:value-of select="@SKIPTO + THREAD[1]/@INDEX + 1"/> - <xsl:value-of select="@SKIPTO + THREAD[position()=last()]/@INDEX + 1"/> of <xsl:value-of select="@TOTALTHREADS"/>
			</h4>
		</div>
		<table cellspacing="0" cellpadding="0" border="0" width="420" id="content">
			<tr>
				<td class="tablenavbarTop" width="420" colspan="4">
					<div class="tablenavtext">
						<xsl:apply-templates select="." mode="c_firstpage"/>
						<xsl:text> | </xsl:text>
						<xsl:apply-templates select="." mode="c_previouspage"/>
						<xsl:apply-templates select="." mode="c_threadsearchphraseblocks"/>
						<xsl:apply-templates select="." mode="c_nextpage"/>
						<xsl:text> | </xsl:text>
						<xsl:apply-templates select="." mode="c_lastpage"/>
					</div>
				</td>
			</tr>
			<tr>
				<th id="thDiscussion">
					<p class="thText">Discussion</p>
				</th>
				<th id="thReplies">
					<p class="thText">Replies</p>
				</th>
				<th id="thLatestReply">
					<p class="thText">Latest Reply</p>
				</th>
				<th id="thTags">
					<p class="thText">Tags</p>
				</th>
			</tr>
			<xsl:apply-templates select="THREAD" mode="c_threadsearchphrasepage"/>
		</table>
	</xsl:template>
	<!--
	<xsl:template match="THREAD" mode="r_threadspage">
	Use: Presentation of an individual thread in a THREADSEARCHPHRASE page
	 -->
	<xsl:template match="THREAD" mode="r_threadsearchphrasepage">
		<tr>
			<xsl:attribute name="class"><xsl:choose><xsl:when test="count(preceding-sibling::THREAD) mod 2 = 0">rowOne</xsl:when><xsl:otherwise>rowTwo</xsl:otherwise></xsl:choose></xsl:attribute>
			<td class="discussion">
				<p>
					<xsl:apply-templates select="SUBJECT" mode="t_threadsearchphrasepage"/>
					<br/>
					<xsl:value-of select="concat(substring(FIRSTPOST/TEXT, 1, 40), '...')"/>
				</p>
			</td>
			<td class="replies" width="50">
				<p>
					<xsl:value-of select="TOTALPOSTS - 1"/>
				</p>
			</td>
			<td class="latestreply" width="50">
				<p>
					<!--xsl:value-of select="concat('(', $m_LastPost, ' ')"/-->
					<xsl:apply-templates select="." mode="t_tsplastpost"/>
					<!--xsl:text>)</xsl:text-->
				</p>
			</td>
			<td class="tags" width="105">
				<p>
					<xsl:apply-templates select="PHRASES" mode="r_threadsearchphrasepage"/>
				</p>
			</td>
			<!--xsl:apply-templates select="@THREADID" mode="c_movethreadsearchphrasegadget"/-->
			<!--xsl:apply-templates select="." mode="c_hidethreadsearchphrase"/-->
		</tr>
	</xsl:template>
	<!--
	<xsl:template match="PHRASES" mode="r_threadsearchphrasepage">
	Use: Presentation of a collection of phrases attributed to an individual thread
	 -->
	<xsl:template match="PHRASES" mode="r_threadsearchphrasepage">
		<xsl:choose>
			<xsl:when test="PHRASE">
				<xsl:apply-templates select="PHRASE[position() &lt; 11]" mode="c_threadsearchphrasepage"/>
				<xsl:if test="PHRASE[position() = 11]">...</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text> &nbsp;</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="PHRASES" mode="r_threadsearchphrasepage">
	Use: Presentation of an individual phrase attributed to an individual thread
	 -->
	<xsl:template match="PHRASE" mode="r_threadsearchphrasepage">
		<xsl:apply-imports/>
		<xsl:if test="following-sibling::PHRASE and not(count(preceding-sibling::PHRASE) = 9)">, </xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="FIRSTPOST" mode="r_threadspage">
	Use: Presentation of the FIRSTPOST object
	 -->
	<!--xsl:template match="FIRSTPOST" mode="r_threadspage">
		First Post:
		<br/>
		Content: <xsl:apply-templates select="TEXT" mode="t_firstposttp"/>
		<br/>
		User: <xsl:apply-templates select="USER" mode="t_firstposttp"/>
		<br/>
		Posted: <xsl:apply-templates select="DATE"/>
	</xsl:template-->
	<!--
	<xsl:template match="LASTPOST" mode="r_threadspage">
	Use: Presentation of the LASTPOST object
	 -->
	<!--xsl:template match="LASTPOST" mode="r_threadspage">
		Last Post:
		<br/>
		Content: <xsl:apply-templates select="TEXT" mode="t_lastposttp"/>
		<br/>
		User: <xsl:apply-templates select="USER" mode="t_lastposttp"/>
		<br/>>
		Posted: <xsl:apply-templates select="DATE" mode="t_threadslastposteddate"/>
	</xsl:template-->
	<!--
	<xsl:template match="@THREADID" mode="r_movethreadsearchphrasegadget">
	Use: Presentation of the move thread editorial tool link
	 -->
	<!--xsl:template match="@THREADID" mode="r_movethreadsearchphrasegadget">
		<xsl:apply-imports/>
		<br/>
	</xsl:template-->
	<!--
	<xsl:template match="@THREADID" mode="r_hidethreadsearchphrase">
	Use: Presentation of the hide thread editorial tool link
	 -->
	<!--xsl:template match="THREAD" mode="r_hidethreadsearchphrase">
		<xsl:apply-imports/>
		<br/>
	</xsl:template-->
	<!--
	<xsl:template match="THREADSEARCH" mode="r_subscribe">
	Use: Presentation of the subscribe / unsubscribe button
	 -->
	<!--xsl:template match="THREADSEARCH" mode="r_subscribe">
		<font xsl:use-attribute-sets="mainfont">
			<xsl:apply-imports/>
		</font>
	</xsl:template-->
	<!--
	<xsl:template match="THREADSEARCH" mode="r_emailalerts">
	Use: Presentation of the email alerts form
	 -->
	<!--xsl:template match="THREADSEARCH" mode="r_emailalerts">
		Set Instant Alerts:
		On <xsl:apply-templates select="." mode="t_emailalertson"/>
		<br/>
		Off <xsl:apply-templates select="." mode="t_emailalertsoff"/>
		<br/>
		<xsl:apply-templates select="." mode="t_emailalertssubmit"/>
	</xsl:template-->
	<!-- 
	#######################################################
					THREAD FILTER BLOCKS 
	#######################################################
	-->
	<!--
	<xsl:template match="THREADSEARCH" mode="r_threadsearchphraseblocks">
	Use: Presentation of the thread block container
	 -->
	<xsl:template match="THREADSEARCH" mode="r_threadsearchphraseblocks">
		<xsl:apply-templates select="." mode="c_threadsearchphraseblockdisplayprev"/>
		<xsl:apply-templates select="." mode="c_threadsearchphraseblockdisplay"/>
		<xsl:apply-templates select="." mode="c_threadsearchphraseblockdisplaynext"/>
	</xsl:template>
	<!-- 
	<xsl:template match="FORUMTHREADPOSTS" mode="r_threadsearchphraseblockdisplayprev">
	Use: Presentation of previous link
	-->
	<xsl:template match="THREADSEARCH" mode="r_threadsearchphraseblockdisplayprev">
		<xsl:apply-imports/>
	</xsl:template>
	<!-- 
	<xsl:template match="FORUMTHREADPOSTS" mode="r_threadsearchphraseblockdisplaynext">
	Use: Presentation of next link
	-->
	<xsl:template match="THREADSEARCH" mode="r_threadsearchphraseblockdisplaynext">
		<xsl:apply-imports/>
	</xsl:template>
	<!-- 
	<xsl:template match="THREADSEARCH" mode="on_threadsearchphraseblockdisplay">
	Use: Controls the display of the block (outside the link) which is currently appearing on the page
	-->
	<xsl:template match="THREADSEARCH" mode="on_threadsearchphraseblockdisplay">
		<xsl:param name="url"/>
		<span class="onTspTabBlock">
			<xsl:copy-of select="$url"/>
		</span>
		<xsl:text> </xsl:text>
	</xsl:template>
	<!-- 
	<xsl:template name="t_threadsearchphraseontabcontent">
	Use: Controls the content of the link for the currently visible page
	-->
	<xsl:template name="t_threadsearchphraseontabcontent">
		<xsl:param name="range"/>
		<xsl:param name="pagenumber"/>
		Page <xsl:value-of select="$pagenumber"/> of Titles
	</xsl:template>
	<!-- 
	<xsl:template match="THREADSEARCH" mode="off_threadsearchphraseblockdisplay">
	Use: Controls the display of the block (outside the link) which is not currently on the page
	-->
	<xsl:template match="THREADSEARCH" mode="off_threadsearchphraseblockdisplay">
		<xsl:param name="url"/>
		<xsl:copy-of select="$url"/>
		<xsl:text> </xsl:text>
	</xsl:template>
	<!-- 
	<xsl:template name="t_threadsearchphraseofftabcontent">
	Use: Controls the content of the link for other pages in the currently visible range
	-->
	<xsl:template name="t_threadsearchphraseofftabcontent">
		<xsl:param name="range"/>
		<xsl:param name="pagenumber"/>
		<xsl:value-of select="$pagenumber"/>
	</xsl:template>
	<!-- 
	Use: Attribute sets for the links themselves
	-->
	<xsl:attribute-set name="mTHREADSEARCH_on_threadsearchphraseblockdisplay"/>
	<xsl:attribute-set name="mTHREADSEARCH_off_threadsearchphraseblockdisplay"/>
	<!-- 
	<xsl:template match="THREADSEARCH" mode="r_newconversation">
	Use: Presentation of the 'New Conversation' link
	-->
	<!--xsl:template match="THREADSEARCH" mode="r_newconversation">
		<xsl:apply-imports/>
	</xsl:template-->
	<!-- 
	<xsl:template match="THREADSEARCH" mode="link_firstthreadsearchphrasepage">
	Use: Presentation of the 'First Page' link
	-->
	<xsl:template match="THREADSEARCH" mode="link_firstthreadsearchphrasepage">
		<xsl:apply-imports/>
		<br/>
	</xsl:template>
	<!-- 
	<xsl:template match="THREADSEARCH" mode="link_lastthreadsearchphrasepage">
	Use: Presentation of the 'Last Page' link
	-->
	<xsl:template match="THREADSEARCH" mode="link_lastthreadsearchphrasepage">
		<xsl:apply-imports/>
		<br/>
	</xsl:template>
	<!-- 
	<xsl:template match="THREADSEARCH" mode="link_previousthreadsearchphrasepage">
	Use: Presentation of the 'Previous Page' link
	-->
	<xsl:template match="THREADSEARCH" mode="link_previousthreadsearchphrasepage">
		<xsl:apply-imports/>
		<br/>
	</xsl:template>
	<!-- 
	<xsl:template match="THREADSEARCH" mode="link_nextthreadsearchphrasepage">
	Use: Presentation of the 'Next Page' link
	-->
	<xsl:template match="THREADSEARCH" mode="link_nextthreadsearchphrasepage">
		<xsl:apply-imports/>
		<br/>
	</xsl:template>
	<!-- 
	<xsl:template match="THREADSEARCH" mode="text_firstthreadsearchphrasepage">
	Use: Presentation of the 'On First Page' message
	-->
	<xsl:template match="THREADSEARCH" mode="text_firstthreadsearchphrasepage">
		<xsl:apply-imports/>
		<br/>
	</xsl:template>
	<!-- 
	<xsl:template match="THREADSEARCH" mode="text_lastthreadsearchphrasepage">
	Use: Presentation of the 'On Last Page' message
	-->
	<xsl:template match="THREADSEARCH" mode="text_lastthreadsearchphrasepage">
		<xsl:apply-imports/>
		<br/>
	</xsl:template>
	<!-- 
	<xsl:template match="THREADSEARCH" mode="text_previousthreadsearchphrasepage">
	Use: Presentation of the 'No Previous Page' message
	-->
	<xsl:template match="THREADSEARCH" mode="text_previousthreadsearchphrasepage">
		<xsl:apply-imports/>
		<br/>
	</xsl:template>
	<!-- 
	<xsl:template match="THREADSEARCH" mode="text_nextthreadsearchphrasepage">
	Use: Presentation of the 'No Next Page' message
	-->
	<xsl:template match="THREADSEARCH" mode="text_nextthreadsearchphrasepage">
		<xsl:apply-imports/>
		<br/>
	</xsl:template>
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
					HOT-PHRASES Logical Container Template
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<!-- 
	<xsl:template match="HOT-PHRASES" mode="r_threadsearchphrasepage">
	Use: Presentation of the tag cloud
	-->
	<xsl:template match="HOT-PHRASES" mode="r_threadsearchphrasepage">
		<div class="hotPhrases">
			<xsl:apply-templates select="." mode="c_phraseblocks"/>
			<xsl:if test="not(/H2G2/PARAMS/PARAM[NAME='s_page'])">
				<h3>
					<xsl:choose>
						<xsl:when test="not(/H2G2/THREADSEARCHPHRASE/PHRASES/PHRASE)">
							<xsl:text>What people are talking about... </xsl:text>
						</xsl:when>
						<xsl:when test="/H2G2/THREADSEARCHPHRASE/PHRASES/PHRASE/NAME[. = msxsl:node-set($list_of_regions)/region] and /H2G2/THREADSEARCHPHRASE/PHRASES/PHRASE/NAME[not(. = msxsl:node-set($list_of_regions)/region)]">
							<xsl:text>What people are talking about </xsl:text>
							<!--xsl:for-each select="/H2G2/THREADSEARCHPHRASE/PHRASES/PHRASE/NAME[not(contains($list_of_regions, .))]">
								<xsl:value-of select="self::NAME[not(contains($list_of_regions, .))]"/>
								<xsl:if test="../following-sibling::PHRASE/NAME[not(contains($list_of_regions, .))]"> and </xsl:if>
							</xsl:for-each-->
							<xsl:text> in </xsl:text>
							<xsl:value-of select="/H2G2/THREADSEARCHPHRASE/PHRASES/PHRASE/NAME[. = msxsl:node-set($list_of_regions)/region]"/>
						</xsl:when>
						<xsl:when test="/H2G2/THREADSEARCHPHRASE/PHRASES/PHRASE/NAME[. = msxsl:node-set($list_of_regions)/region]">
							<xsl:text>What people are talking about in </xsl:text>
							<xsl:value-of select="/H2G2/THREADSEARCHPHRASE/PHRASES/PHRASE/NAME[. = msxsl:node-set($list_of_regions)/region]"/>
						</xsl:when>
						<xsl:when test="/H2G2/THREADSEARCHPHRASE/PHRASES/PHRASE/NAME[not(. = msxsl:node-set($list_of_regions)/region)]">
							<xsl:text>What people are talking about in England</xsl:text>
						</xsl:when>
					</xsl:choose>
				</h3>
			</xsl:if>
			<!--xsl:if test="/H2G2/THREADSEARCHPHRASE/PHRASES/PHRASE and contains($list_of_regions, /H2G2/THREADSEARCHPHRASE/PHRASES/PHRASE/NAME)"-->
			<xsl:if test="/H2G2/THREADSEARCHPHRASE/PHRASES/PHRASE and (/H2G2/THREADSEARCHPHRASE/PHRASES/PHRASE/NAME = msxsl:node-set($list_of_regions)/region)">
				<div style="font-size:10px; float:right;">
					<a href="{$root}TSP">See everything in England</a>
				</div>
				<br/>
			</xsl:if>
			<!--xsl:apply-templates select="HOT-PHRASE[not(contains($list_of_regions, NAME))]" mode="c_threadsearchphrasepage"-->
			<xsl:apply-templates select="HOT-PHRASE" mode="c_threadsearchphrasepage">
				<xsl:sort select="NAME" data-type="text" order="ascending"/>
			</xsl:apply-templates>
			<xsl:apply-templates select="." mode="c_more"/>
			<br/>
			<!--xsl:copy-of select="$ranked-hot-phrases"/-->
		</div>
	</xsl:template>
	<!--xsl:key name="hot-phrases" match="HOT-PHRASE" use="TERM"/-->
	<!-- 
	<xsl:template match="HOT-PHRASE" mode="r_threadsearchphrasepage">
	Use: Presentation of an individual item within a tag cloud
	-->
	<xsl:variable name="avg_phrases_score" select="sum(/H2G2/HOT-PHRASES/HOT-PHRASE/RANK) div count(/H2G2/HOT-PHRASES/HOT-PHRASE)"/>
	<xsl:variable name="total-phrases">30</xsl:variable>
	<xsl:variable name="no-of-ranges" select="5"/>
	<xsl:variable name="phrases-in-range" select="$total-phrases div $no-of-ranges"/>
	<xsl:variable name="hot-phrases">
		<!--xsl:for-each select="/H2G2/HOT-PHRASES/HOT-PHRASE[not(contains($list_of_regions, NAME))]"-->
		<xsl:for-each select="/H2G2/HOT-PHRASES/HOT-PHRASE">
			<xsl:sort select="RANK" data-type="number" order="descending"/>
			<xsl:copy>
				<xsl:attribute name="position"><xsl:value-of select="position() mod $hot-phrases-in-block"/></xsl:attribute>
				<xsl:attribute name="generate-id"><xsl:value-of select="generate-id()"/></xsl:attribute>
				<xsl:copy-of select="node()"/>
			</xsl:copy>
		</xsl:for-each>
	</xsl:variable>
	<!--xsl:variable name="hot-phrases-in-block" select="ceiling(count(/H2G2/HOT-PHRASES/HOT-PHRASE[not(contains($list_of_regions, NAME))]) div $no-of-ranges)"/-->
	<xsl:variable name="hot-phrases-in-block" select="ceiling(count(/H2G2/HOT-PHRASES/HOT-PHRASE) div $no-of-ranges)"/>
	<xsl:variable name="ranked-hot-phrases">
		<xsl:for-each select="msxsl:node-set($hot-phrases)/HOT-PHRASE[@position=1]">
			<RANGE ID="{position()}">
				<xsl:copy-of select="."/>
				<xsl:for-each select="following-sibling::HOT-PHRASE[position() &lt; $hot-phrases-in-block]">
					<xsl:copy-of select="."/>
				</xsl:for-each>
			</RANGE>
		</xsl:for-each>
	</xsl:variable>
	<xsl:key name="ranked-hot-phrases" match="HOT-PHRASE" use="RANK"/>
	<!--xsl:variable name="ranked-hot-phrases2">
		<xsl:for-each select="key()"
	</xsl:variable-->
	<!--xsl:key name="ranked-hot-phrases" match="msxsl:node-set($hot-phrases)/HOT-PHRASE" use="@position"/-->
	<!--xsl:template match="HOT-PHRASE" mode="ranking">
		<xsl:param name="phrases-in-range"/>
		<xsl:copy>
			<xsl:attribute name="position">
				
				<xsl:value-of select="@position mod $phrases-in-range"/>
			</xsl:attribute>
			<xsl:copy-of select="node()"/>
		</xsl:copy>
	</xsl:template-->
	<xsl:template match="HOT-PHRASE" mode="r_threadsearchphrasepage">
		<xsl:variable name="popularity" select="$no-of-ranges + 1 - msxsl:node-set($ranked-hot-phrases)/RANGE[HOT-PHRASE[generate-id(current()) = @generate-id]]/@ID"/>
		<!-- 5 ranges + 1 + -->
		<span class="rank{$popularity}">
			<xsl:apply-imports/>
		</span>
		<xsl:text> </xsl:text>
	</xsl:template>
	<xsl:template match="THREADSEARCHPHRASE" mode="r_newthread">
		<xsl:if test="PHRASES/PHRASE/NAME[. = msxsl:node-set($list_of_regions)/region]">
			<div class="newDiscussion">
				<xsl:apply-imports/>
			</div>
		</xsl:if>
	</xsl:template>
	<xsl:template match="PHRASES" mode="r_region">
		<div class="TspIntro">
			<p>
				<xsl:choose>
					<xsl:when test="/H2G2/THREADSEARCHPHRASE/THREADSEARCH/THREAD">
						<xsl:text>What People are saying </xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>There are currently no discussions </xsl:text>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:apply-templates select="." mode="c_item"/>
				<xsl:text> in </xsl:text>
				<span class="introRegion">
					<xsl:apply-templates select="." mode="t_region"/>
				</span>
			</p>
		</div>
	</xsl:template>
	<xsl:template match="PHRASES" mode="r_item">
		<xsl:if test="string-length($list_of_items) &gt; 0">
			<xsl:text> about </xsl:text>
			<xsl:apply-templates select="PHRASE[not(NAME = msxsl:node-set($list_of_regions)/region)]" mode="c_item"/>
		</xsl:if>
	</xsl:template>
	<xsl:template match="PHRASE" mode="r_item">
		<span class="introPhrase">
			<xsl:call-template name="truncateTagName"/>
		</span>
		<xsl:choose>
			<xsl:when test="not(following-sibling::PHRASE[not(NAME = msxsl:node-set($list_of_regions)/region)][1])"/>
			<xsl:when test="not(following-sibling::PHRASE[not(NAME = msxsl:node-set($list_of_regions)/region)][2])"> and </xsl:when>
			<xsl:otherwise>, </xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="ADDTHREADSEARCHPHRASE" mode="r_add">
		<h1>Add a tag</h1>
		<div style="background-color:#E3E8E9; padding:5px;">
			<h6>
				<xsl:text>Current discussion tags: </xsl:text>
				<xsl:for-each select="THREADPHRASELIST/PHRASES/PHRASE">
					<xsl:value-of select="NAME"/>
					<xsl:if test="not(position()=last())">, </xsl:if>
				</xsl:for-each>
			</h6>
			<br/>
			<h4>Your tag(s): </h4>
			<p>
				<xsl:text>Help other users find the discussion with descriptive words separated with a space</xsl:text>
				<br/>
				<br/>
				<input type="text" name="addphrase" value="" size="50"/>
				<br/>
				<xsl:text>Once you have added a tag you won't be able to delete it!</xsl:text>
				<br/>
				<div class="cancelTagLink">
					<a href="{$root}F{THREADPHRASELIST/@FORUMID}?thread={THREADPHRASELIST/@THREADID}">
						<img src="{$imagesource}cancel_button.gif" alt="Cancel" border="0"/>
					</a>
				</div>
				<div class="addTagLink">
					<input type="image" src="{$imagesource}add_tag.gif" value="Add Tag(s)" width="104" height="23"/>
				</div>
			</p>
		</div>
	</xsl:template>
	<xsl:template match="HOT-PHRASES" mode="r_more">
		<span class="more-phrases">
			<xsl:apply-imports/>
		</span>
	</xsl:template>
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
					HOT-PHRASES BLOCKS
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<!--
	<xsl:template match="THREADSEARCH" mode="r_threadsearchphraseblocks">
	Use: Presentation of the thread block container
	 -->
	<xsl:template match="HOT-PHRASES" mode="r_phraseblocks">
		<div class="hotPhrasesNav">
			<!--xsl:apply-templates select="." mode="c_phraseblockdisplayprev"/-->
			<!--xsl:apply-templates select="." mode="c_phraseblockdisplaynext"/-->
			<xsl:apply-templates select="." mode="c_firstphrasepage"/>
			<xsl:text> | </xsl:text>
			<xsl:apply-templates select="." mode="c_previousphrasepage"/>
			<xsl:apply-templates select="." mode="c_phraseblockdisplay"/>
			<xsl:apply-templates select="." mode="c_nextphrasepage"/>
			<xsl:text> | </xsl:text>
			<xsl:apply-templates select="." mode="c_lastphrasepage"/>
		</div>
	</xsl:template>
	<!-- 
	<xsl:template match="FORUMTHREADPOSTS" mode="r_threadsearchphraseblockdisplayprev">
	Use: Presentation of previous link
	-->
	<xsl:template match="HOT-PHRASES" mode="r_phraseblockdisplayprev">
		<xsl:apply-imports/>
	</xsl:template>
	<!-- 
	<xsl:template match="FORUMTHREADPOSTS" mode="r_threadsearchphraseblockdisplaynext">
	Use: Presentation of next link
	-->
	<xsl:template match="HOT-PHRASES" mode="r_phraseblockdisplaynext">
		<xsl:apply-imports/>
	</xsl:template>
	<!-- 
	<xsl:template match="THREADSEARCH" mode="on_threadsearchphraseblockdisplay">
	Use: Controls the display of the block (outside the link) which is currently appearing on the page
	-->
	<xsl:template match="HOT-PHRASES" mode="on_phraseblockdisplay">
		<xsl:param name="url"/>
		<xsl:copy-of select="$url"/>
		<xsl:text> </xsl:text>
	</xsl:template>
	<!-- 
	<xsl:template name="t_threadsearchphraseontabcontent">
	Use: Controls the content of the link for the currently visible page
	-->
	<xsl:template name="t_phraseontabcontent">
		<xsl:param name="range"/>
		<xsl:param name="pagenumber"/>
		<xsl:value-of select="$pagenumber"/>
	</xsl:template>
	<!-- 
	<xsl:template match="THREADSEARCH" mode="off_threadsearchphraseblockdisplay">
	Use: Controls the display of the block (outside the link) which is not currently on the page
	-->
	<xsl:template match="HOT-PHRASES" mode="off_phraseblockdisplay">
		<xsl:param name="url"/>
		<xsl:copy-of select="$url"/>
		<xsl:text> </xsl:text>
	</xsl:template>
	<!-- 
	<xsl:template name="t_threadsearchphraseofftabcontent">
	Use: Controls the content of the link for other pages in the currently visible range
	-->
	<xsl:template name="t_phraseofftabcontent">
		<xsl:param name="range"/>
		<xsl:param name="pagenumber"/>
		<xsl:value-of select="$pagenumber"/>
	</xsl:template>
	<!-- 
	Use: Attribute sets for the links themselves
	-->
	<xsl:attribute-set name="mHOT-PHRASES_on_phraseblockdisplay"/>
	<xsl:attribute-set name="mHOT-PHRASES_off_phraseblockdisplay"/>
	<!-- 
	<xsl:template match="THREADSEARCH" mode="r_newconversation">
	Use: Presentation of the 'New Conversation' link
	-->
	<!--xsl:template match="THREADSEARCH" mode="r_newconversation">
		<xsl:apply-imports/>
	</xsl:template-->
	<!-- 
	<xsl:template match="THREADSEARCH" mode="link_firstthreadsearchphrasepage">
	Use: Presentation of the 'First Page' link
	-->
	<xsl:template match="HOT-PHRASES" mode="link_firstphrasepage">
		<xsl:apply-imports/>
	</xsl:template>
	<!-- 
	<xsl:template match="THREADSEARCH" mode="link_lastthreadsearchphrasepage">
	Use: Presentation of the 'Last Page' link
	-->
	<xsl:template match="HOT-PHRASES" mode="link_lastphrasepage">
		<xsl:apply-imports/>
	</xsl:template>
	<!-- 
	<xsl:template match="THREADSEARCH" mode="link_previousthreadsearchphrasepage">
	Use: Presentation of the 'Previous Page' link
	-->
	<xsl:template match="HOT-PHRASES" mode="link_previousphrasepage">
		<xsl:apply-imports/>
	</xsl:template>
	<!-- 
	<xsl:template match="THREADSEARCH" mode="link_nextthreadsearchphrasepage">
	Use: Presentation of the 'Next Page' link
	-->
	<xsl:template match="HOT-PHRASES" mode="link_nextphrasepage">
		<xsl:apply-imports/>
	</xsl:template>
	<!-- 
	<xsl:template match="THREADSEARCH" mode="text_firstthreadsearchphrasepage">
	Use: Presentation of the 'On First Page' message
	-->
	<xsl:template match="HOT-PHRASES" mode="text_firstphrasepage">
		<span class="off">
			<xsl:apply-imports/>
		</span>
	</xsl:template>
	<!-- 
	<xsl:template match="THREADSEARCH" mode="text_lastthreadsearchphrasepage">
	Use: Presentation of the 'On Last Page' message
	-->
	<xsl:template match="HOT-PHRASES" mode="text_lastphrasepage">
		<span class="off">
			<xsl:apply-imports/>
		</span>
	</xsl:template>
	<!-- 
	<xsl:template match="THREADSEARCH" mode="text_previousthreadsearchphrasepage">
	Use: Presentation of the 'No Previous Page' message
	-->
	<xsl:template match="HOT-PHRASES" mode="text_previousphrasepage">
		<span class="off">
			<xsl:apply-imports/>
		</span>
	</xsl:template>
	<!-- 
	<xsl:template match="THREADSEARCH" mode="text_nextthreadsearchphrasepage">
	Use: Presentation of the 'No Next Page' message
	-->
	<xsl:template match="HOT-PHRASES" mode="text_nextphrasepage">
		<span class="off">
			<xsl:apply-imports/>
		</span>
	</xsl:template>
	<!-- 
	<xsl:template match="FORUMTHREADS" mode="link_firstpage">
	Use: Presentation of the 'First Page' link
	-->
	<xsl:template match="THREADSEARCH" mode="link_firstpage">
		<xsl:apply-imports/>
	</xsl:template>
	<!-- 
	<xsl:template match="FORUMTHREADS" mode="link_lastpage">
	Use: Presentation of the 'Last Page' link
	-->
	<xsl:template match="THREADSEARCH" mode="link_lastpage">
		<xsl:apply-imports/>
	</xsl:template>
	<!-- 
	<xsl:template match="FORUMTHREADS" mode="link_previouspage">
	Use: Presentation of the 'Previous Page' link
	-->
	<xsl:template match="THREADSEARCH" mode="link_previouspage">
		<xsl:apply-imports/>
	</xsl:template>
	<!-- 
	<xsl:template match="FORUMTHREADS" mode="link_nextpage">
	Use: Presentation of the 'Next Page' link
	-->
	<xsl:template match="THREADSEARCH" mode="link_nextpage">
		<xsl:apply-imports/>
	</xsl:template>
	<!-- 
	<xsl:template match="FORUMTHREADS" mode="text_firstpage">
	Use: Presentation of the 'On First Page' message
	-->
	<xsl:template match="THREADSEARCH" mode="text_firstpage">
		<span class="off">
			<xsl:apply-imports/>
		</span>
	</xsl:template>
	<!-- 
	<xsl:template match="FORUMTHREADS" mode="text_lastpage">
	Use: Presentation of the 'On Last Page' message
	-->
	<xsl:template match="THREADSEARCH" mode="text_lastpage">
		<span class="off">
			<xsl:apply-imports/>
		</span>
	</xsl:template>
	<!-- 
	<xsl:template match="FORUMTHREADS" mode="text_previouspage">
	Use: Presentation of the 'No Previous Page' message
	-->
	<xsl:template match="THREADSEARCH" mode="text_previouspage">
		<span class="off">
			<xsl:apply-imports/>
		</span>
	</xsl:template>
	<!-- 
	<xsl:template match="FORUMTHREADS" mode="text_nextpage">
	Use: Presentation of the 'No Next Page' message
	-->
	<xsl:template match="THREADSEARCH" mode="text_nextpage">
		<span class="off">
			<xsl:apply-imports/>
		</span>
	</xsl:template>
	<!--
	<xsl:template match="BOARDPROMO" mode="choose_promotype">
	Author:		Andy Harris
	Context:    H2G2/BOARDPROMOPAGE/BOARDPROMOLIST/BOARDPROMO
	Purpose:	 Selects the correct board promo type for displaying the promos on the user facing pages themselves
	-->
	<xsl:template match="BOARDPROMO" mode="choose_promotypetagging">
		<div id="promoContentTag">
			<xsl:choose>
				<xsl:when test="TEXTBOXTYPE = 3">
					<xsl:apply-templates select="TEXT"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:choose>
						<xsl:when test="TEMPLATETYPE = 1">
							<p>
								<xsl:apply-templates select="TEXT"/>
							</p>
						</xsl:when>
						<xsl:when test="TEMPLATETYPE = 2">
							<img src="{$imagesource}{IMAGENAME}" width="{IMAGEWIDTH}" height="{IMAGEHEIGHT}" alt="{IMAGEALTTEXT}"/>
						</xsl:when>
						<xsl:when test="TEMPLATETYPE = 3">
							<img src="{$imagesource}{IMAGENAME}" width="{IMAGEWIDTH}" height="{IMAGEHEIGHT}" alt="{IMAGEALTTEXT}" class="imgPromoLeft"/>
							<p>
								<xsl:apply-templates select="TEXT"/>
							</p>
						</xsl:when>
						<xsl:when test="TEMPLATETYPE = 4">
							<p>
								<xsl:apply-templates select="TEXT"/>
							</p>
							<img src="{$imagesource}{IMAGENAME}" width="{IMAGEWIDTH}" height="{IMAGEHEIGHT}" alt="{IMAGEALTTEXT}" class="imgPromoRight"/>
						</xsl:when>
						<xsl:when test="TEMPLATETYPE = 5">
							<img src="{$imagesource}{IMAGENAME}" width="{IMAGEWIDTH}" height="{IMAGEHEIGHT}" alt="{IMAGEALTTEXT}" class="imgPromoLeft"/>
							<p>
								<xsl:apply-templates select="TEXT"/>
							</p>
						</xsl:when>
						<xsl:when test="TEMPLATETYPE = 6">
							<img src="{$imagesource}{IMAGENAME}" width="{IMAGEWIDTH}" height="{IMAGEHEIGHT}" alt="{IMAGEALTTEXT}" class="imgPromoLeft"/>
							<p>
								<xsl:apply-templates select="TEXT"/>
							</p>
						</xsl:when>
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
		</div>
	</xsl:template>
</xsl:stylesheet>
