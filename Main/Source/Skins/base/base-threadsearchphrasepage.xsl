<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
	<!ENTITY quot "&#34;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" xmlns:str="http://exslt.org/strings" exclude-result-prefixes="msxsl local s dt str">
	<xsl:include href="str.replace.template.xsl"/>
	<xsl:attribute-set name="mTHREADID_r_movethreadsearchphrasegadget"/>
	<xsl:attribute-set name="mSUBJECT_t_threadsearchphrasepage"/>
	<xsl:attribute-set name="mTHREAD_r_hidethreadsearchphrase"/>
	<xsl:attribute-set name="mTHREADSEARCH_r_threadsearchphraseblockdisplayprev"/>
	<xsl:attribute-set name="mTHREADSEARCH_r_threadsearchphraseblockdisplaynext"/>
	<xsl:attribute-set name="mHOT-PHRASES_r_phraseblockdisplayprev"/>
	<xsl:attribute-set name="mHOT-PHRASES_r_phraseblockdisplaynext"/>
	<xsl:attribute-set name="mPHRASE_r_threadsearchphrasepage"/>
	<xsl:attribute-set name="mHOT-PHRASE_r_threadsearchphrasepage"/>
	<xsl:variable name="m_threadsearchphrasepostblocknext" select="$m_threadpostblocknext"/>
	<xsl:variable name="m_threadsearchphrasepostblockprev" select="$m_threadpostblockprev"/>
	<xsl:variable name="m_phrasepostblocknext">Next</xsl:variable>
	<xsl:variable name="m_phrasepostblockprev">Previous</xsl:variable>
	<xsl:variable name="m_Hidethreadsearchphrase" select="$m_HideThread"/>
	<xsl:variable name="m_Unhidethreadsearchphrase" select="$m_UnhideThread"/>
	<xsl:variable name="m_Movethreadsearchphrase" select="$m_MoveThread"/>
	<xsl:variable name="TSPforumid" select="/H2G2/THREADSEARCHPHRASE/THREADSEARCH/@FORUMID"/>
	
	<xsl:variable name="list_of_items">
		<xsl:for-each select="/H2G2/THREADSEARCHPHRASE/PHRASES/PHRASE/NAME[not(. = msxsl:node-set($list_of_regions)/region)]">
			<xsl:value-of select="."/>
			<xsl:if test="not(position() = last())">, </xsl:if>
		</xsl:for-each>
	</xsl:variable>
	<xsl:key name="regions" match="KEYPHRASE" use="NAME"/>
	<!--
	<xsl:template name="THREADSEARCHPHRASE_HEADER">
	Author:		Tom Whitehouse
	Context:      /H2G2
	Purpose:	 Creates the title for the page which sits in the html header
	-->
	<xsl:template name="THREADSEARCHPHRASE_HEADER">
		<xsl:apply-templates mode="header" select=".">
			<xsl:with-param name="title">Topic Tagging</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>
	<!--
	<xsl:template match="THREADSEARCHPHRASE" mode="c_searchthreadsearchphrasepage">
	Author:		Tom Whitehouse
	Context:      /H2G2
	Purpose:	 Creates the container for the thread search phrase input box
	-->
	<xsl:template match="THREADSEARCHPHRASE" mode="c_searchthreadsearchphrasepage">
		<form method="get" action="TSP">
			<!--input type="hidden" name="forum" value="{THREADSEARCH/@FORUMID}"/-->
			<!--input type="hidden" name="phrase" value="{key('regions', PHRASES/PHRASE/NAME)/TERM}"/-->
			<xsl:apply-templates select="." mode="r_searchthreadsearchphrasepage"/>
		</form>
	</xsl:template>
	<xsl:attribute-set name="iTHREADSEARCHPHRASE_t_searchinput">
		<xsl:attribute name="type">text</xsl:attribute>
		<xsl:attribute name="value">
			<xsl:for-each select="/H2G2/THREADSEARCHPHRASE/PHRASES/PHRASE/TERM">
				<!-- [not(contains($list_of_regions, .))] -->
				<xsl:call-template name="str:replace">
					<xsl:with-param name="string" select="."/>
					<xsl:with-param name="search" select="'%26'"/>
					<xsl:with-param name="replace" select="'&amp;'"/>
				</xsl:call-template>
				<!--xsl:value-of select="."/-->
				<xsl:if test="../following-sibling::PHRASE">
					<xsl:text> </xsl:text>
				</xsl:if>
			</xsl:for-each>
		</xsl:attribute>
		<xsl:attribute name="size">10</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="iTHREADSEARCHPHRASE_t_searchsubmit">
		<xsl:attribute name="type">submit</xsl:attribute>
		<xsl:attribute name="value">go</xsl:attribute>
	</xsl:attribute-set>
	<!--
	<xsl:template match="THREADSEARCHPHRASE" mode="t_searchinput">
	Author:		Tom Whitehouse
	Context:      /H2G2
	Purpose:	Text input box for the thread search phrase
	-->
	<xsl:template match="THREADSEARCHPHRASE" mode="t_searchinput">
		<input name="phrase" xsl:use-attribute-sets="iTHREADSEARCHPHRASE_t_searchinput"/>
	</xsl:template>
	<!--
	<xsl:template match="THREADSEARCHPHRASE" mode="t_searchsubmit">
	Author:		Tom Whitehouse
	Context:      /H2G2
	Purpose:	Submit button for the thread search phrase
	-->
	<xsl:template match="THREADSEARCHPHRASE" mode="t_searchsubmit">
		<input xsl:use-attribute-sets="iTHREADSEARCHPHRASE_t_searchsubmit"/>
	</xsl:template>
	<xsl:template match="PHRASE" mode="c_threadsearchphrasepage">
		
		<xsl:apply-templates select="." mode="r_threadsearchphrasepage"/>
	</xsl:template>
	<xsl:template match="PHRASE" mode="r_threadsearchphrasepage">
		<xsl:variable name="phrase_term">
			
			<xsl:if test="NAME">
				<xsl:text>?phrase=</xsl:text>
				<xsl:value-of select="TERM"/>
			</xsl:if>
		</xsl:variable>
		<a href="{$root}TSP{$phrase_term}" xsl:use-attribute-sets="mPHRASE_r_threadsearchphrasepage">
			<xsl:call-template name="truncateTagName"/>
			<!-- phrase={/H2G2/THREADSEARCHPHRASE/PHRASES/PHRASE/TERM[contains($list_of_regions, ../NAME)]} -->
		</a>
	</xsl:template>
	<!--
	<xsl:template match="THREADSEARCH" mode="c_threadsearchphrasepage">
	Author:		Tom Whitehouse
	Context:      
	Purpose:	 Calls the container for the THREADSEARCH object
	-->
	<xsl:template match="THREADSEARCH" mode="c_threadsearchphrasepage">
		<xsl:choose>
			<xsl:when test="THREAD">
				<xsl:apply-templates select="." mode="full_threadsearchphrasepage"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="." mode="empty_threadsearchphrasepage"/>
			</xsl:otherwise>
		</xsl:choose>
		
	</xsl:template>
	<!--
	<xsl:template match="THREAD" mode="c_threadsearchphrasepage">
	Author:		Tom Whitehouse
	Context:      
	Purpose:	 Calls the container for the THREAD object
	-->
	<xsl:template match="THREAD" mode="c_threadsearchphrasepage">
		<xsl:apply-templates select="." mode="r_threadsearchphrasepage"/>
	</xsl:template>
	<!--
	<xsl:template match="SUBJECT" mode="t_threadsearchphrasepage">
	Author:		Tom Whitehouse
	Context:      
	Purpose:	 Creates the SUBJECT link for the THREAD
	-->
	<xsl:template match="SUBJECT" mode="t_threadsearchphrasepage">
		<xsl:variable name="phrase">
			<xsl:if test="../PHRASES/PHRASE">
				<xsl:text>&amp;phrase=</xsl:text>
				<xsl:value-of select="../PHRASES/PHRASE/TERM"/>
			</xsl:if>
		</xsl:variable>
		<a href="{$root}F{../@FORUMID}?thread={../@THREADID}{$phrase}" xsl:use-attribute-sets="mSUBJECT_t_threadsearchphrasepage">
			<xsl:choose>
				<xsl:when test="text()">
					<xsl:value-of select="."/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>&lt;No Subject&gt;</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="TOTALPOSTS" mode="t_numberofrepliesthreadsearchphrasepage">
	Author:		Tom Whitehouse
	Context:      /H2G2/THREADSEARCH/THREAD/TOTALPOSTS
	Purpose:	 Calculates the number of replies
	-->
	<!--xsl:template match="TOTALPOSTS" mode="t_numberofrepliesthreadsearchphrasepage">
		<xsl:value-of select=". - 1"/>
	</xsl:template-->
	<!--
	<xsl:template match="FIRSTPOST" mode="c_threadspage">
	Author:		Tom Whitehouse
	Context:      /H2G2/THREADSEARCH/THREAD/FIRSTPOST
	Purpose:	 Calls the container for the FIRSTPOST object
	-->
	<!--xsl:template match="FIRSTPOST" mode="c_threadspage">
		<xsl:apply-templates select="." mode="r_threadspage"/>
	</xsl:template-->
	<!--xsl:template match="TEXT" mode="t_firstposttp">
		<xsl:value-of select="."/>
	</xsl:template>
	<xsl:template match="USER" mode="t_firstposttp">
		<a href="{$root}U{USERID}" xsl:use-attribute-sets="mUSER_t_firstposttp">
			<xsl:value-of select="USERNAME"/>
		</a>
	</xsl:template-->
	<!--
	<xsl:template match="LASTPOST" mode="c_threadspage">
	Author:		Tom Whitehouse
	Context:      
	Purpose:	 Calls the container for the LASTPOST object
	-->
	<!--xsl:template match="LASTPOST" mode="c_threadspage">
		<xsl:apply-templates select="." mode="r_threadspage"/>
	</xsl:template-->
	<!--xsl:template match="TEXT" mode="t_lastposttp">
		<xsl:value-of select="."/>
	</xsl:template>
	<xsl:template match="USER" mode="t_lastposttp">
		<a href="{$root}U{USERID}" xsl:use-attribute-sets="mUSER_t_lastposttp">
			<xsl:value-of select="USERNAME"/>
		</a>
	</xsl:template-->
	<!--
	<xsl:template match="@THREADID" mode="c_movethreadsearchphrasegadget">
	Author:		Tom Whitehouse
	Context:      
	Purpose:	 Calls the container for the 'move thread gadget' if the viewer is an editor
	-->
	<xsl:template match="@THREADID" mode="c_movethreadsearchphrasegadget">
		<xsl:if test="/H2G2/VIEWING-USER/USER/GROUPS/EDITOR or ($superuser = 1)">
			<xsl:apply-templates select="." mode="r_movethreadsearchphrasegadget"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="@THREADID" mode="r_movethreadgadget">
	Author:		Tom Whitehouse
	Context:      
	Purpose:	 Creates the 'move thread gadget' link
	-->
	<xsl:template match="@THREADID" mode="r_movethreadsearchphrasegadget">
		<a onClick="popupwindow('{$root}MoveThread?cmd=Fetch&amp;ThreadID={.}&amp;DestinationID=F0&amp;mode=POPUP','MoveThreadWindow','scrollbars=1,resizable=1,width=400,height=400');return false;" href="{$root}MoveThread?cmd=Fetch&amp;ThreadID={.}&amp;DestinationID=F0&amp;mode=POPUP" xsl:use-attribute-set="mTHREADID_r_movethreadsearchphrasegadget">
			<xsl:value-of select="$m_Movethreadsearchphrase"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="THREAD" mode="c_hidethreadsearchphrase">
	Author:		Tom Whitehouse
	Context:     
	Purpose:	 Calls the container for the 'hide thread' link if the viewer is an editor
	-->
	<xsl:template match="THREAD" mode="c_hidethreadsearchphrase">
		<xsl:if test="/H2G2/VIEWING-USER/USER/GROUPS/EDITOR or ($superuser = 1)">
			<xsl:apply-templates select="." mode="r_hidethread"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="THREAD" mode="r_hidethreadsearchphrase">
	Author:		Tom Whitehouse
	Context:     
	Purpose:	 Creates the 'hide thread' link
	-->
	<!--xsl:template match="THREAD" mode="r_hidethreadsearchphrase">
		<xsl:if test="@CANREAD=1">
			<a href="{$root}F{@FORUMID}?HideThread={@THREADID}" xsl:use-attribute-sets="mTHREAD_r_hidethreadsearchphrase">
				<xsl:value-of select="$m_Hidethreadsearchphrase"/>
			</a>
		</xsl:if>
		<xsl:if test="@CANREAD=0">
			<a href="{$root}F{@FORUMID}?UnHideThread={@THREADID}" xsl:use-attribute-sets="mTHREAD_r_hidethreadsearchphrase">
				<xsl:value-of select="$m_Unhidethreadsearchphrase"/>
			</a>
		</xsl:if>
	</xsl:template-->
	<!--
	<xsl:template match="THREADSEARCH" mode="c_subscribe">
	Author:		Tom Whitehouse
	Context:     
	Purpose:	 Calls the container for the 'Subscribe' or 'Unsubscribe' link if the viewer is registered
	-->
	<xsl:template match="THREADSEARCH" mode="c_subscribe">
		<xsl:if test="$registered=1">
			<xsl:apply-templates select="." mode="r_subscribe"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="DATE" mode="t_threadslastposteddate">
	Author:		Tom Whitehouse
	Context:      
	Purpose:	 
	-->
	<xsl:template match="DATE" mode="t_threadslastposteddate">
		<a href="{$root}F{../../@FORUMID}&amp;latest=1">
			<xsl:apply-templates select="."/>
		</a>
	</xsl:template>
	<!-- 
	#######################################################
					THREAD FILTER BLOCKS 
	#######################################################
	-->
	<!--
	<xsl:template match="THREADSEARCH" mode="c_threadsearchphraseblocks">
	Author:		Tom Whitehouse
	Context:      
	Purpose:	 Calls the container for the thread blocks navigation
	-->
	<xsl:template match="THREADSEARCH" mode="c_threadsearchphraseblocks">
		<xsl:apply-templates select="." mode="r_threadsearchphraseblocks"/>
	</xsl:template>
	<!--
	<xsl:template match="THREADSEARCH" mode="c_threadsearchphraseblockdisplayprev">
	Author:		Tom Whitehouse
	Context:      
	Purpose:	 Calls the container for the previous link in the thread blocks navigation
	-->
	<xsl:template match="THREADSEARCH" mode="c_threadsearchphraseblockdisplayprev">
		<xsl:if test="($tdp_lowerrange != 0)">
			<xsl:apply-templates select="." mode="r_threadsearchphraseblockdisplayprev"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="THREADSEARCH" mode="r_threadsearchphraseblockdisplayprev">
	Author:		Tom Whitehouse
	Context:      
	Purpose:	 Creates the previous link in the thread blocks navigation
	-->
	
	<xsl:template match="THREADSEARCH" mode="r_threadsearchphraseblockdisplayprev">
	
		<a href="{$root}TSP?skip={$tdp_lowerrange - @COUNT}&amp;show={@COUNT}" xsl:use-attribute-sets="mTHREADSEARCH_r_threadsearchphraseblockdisplayprev">
			<xsl:copy-of select="$m_threadsearchphrasepostblockprev"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="THREADSEARCH" mode="c_threadsearchphraseblockdisplaynext">
	Author:		Tom Whitehouse
	Context:     
	Purpose:	 Calls the container for the next link in the thread blocks navigation
	-->
	<xsl:template match="THREADSEARCH" mode="c_threadsearchphraseblockdisplaynext">
		<xsl:if test="(($tdp_upperrange + @COUNT) &lt; @TOTALTHREADS)">
			<xsl:apply-templates select="." mode="r_threadsearchphraseblockdisplaynext"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="THREADSEARCH" mode="r_threadsearchphraseblockdisplaynext">
	Author:		Tom Whitehouse
	Context:      
	Purpose:	 Creates the next link in the thread blocks navigation
	-->
	<xsl:template match="THREADSEARCH" mode="r_threadsearchphraseblockdisplaynext">
		<a href="{$root}TSP?skip={$tdp_upperrange + @COUNT}&amp;show={@COUNT}" xsl:use-attribute-sets="mTHREADSEARCH_r_threadsearchphraseblockdisplaynext">
			<xsl:copy-of select="$m_threadsearchphrasepostblocknext"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="THREADSEARCH" mode="c_threadsearchphraseblockdisplay">
	Author:		Tom Whitehouse
	Context:     
	Purpose:	 Calls the template to create the links in the thread blocks navigation
	-->
	<xsl:template match="THREADSEARCH" mode="c_threadsearchphraseblockdisplay">
		<xsl:param name="onlink"/>
		<xsl:param name="skip" select="$tdp_lowerrange"/>
		<xsl:apply-templates select="." mode="displayblocktdp">
			<xsl:with-param name="skip" select="$skip"/>
			<xsl:with-param name="onlink" select="$onlink"/>
		</xsl:apply-templates>
		<xsl:if test="(($skip + @COUNT) &lt; @TOTALTHREADS) and ($skip &lt; $tdp_upperrange)">
			<xsl:apply-templates select="." mode="c_threadsearchphraseblockdisplay">
				<xsl:with-param name="skip" select="$skip + @COUNT"/>
				<xsl:with-param name="onlink" select="$onlink"/>
			</xsl:apply-templates>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="THREADSEARCH" mode="displayblocktdp">
	Author:		Tom Whitehouse
	Context:    
	Purpose:	 Creates the individual links in the postblock area within the range set above
	-->
	<xsl:template match="THREADSEARCH" mode="displayblocktdp">
		<xsl:param name="skip"/>
		<xsl:param name="onlink"/>
		<xsl:param name="PostRange" select="concat(($skip + 1), ' - ', ($skip + @COUNT))"/>
		<xsl:choose>
			<xsl:when test="@SKIPTO = $skip">
				<xsl:apply-templates select="." mode="on_threadsearchphraseblockdisplay">
					<xsl:with-param name="url">
						<xsl:choose>
							<xsl:when test="$onlink = 'no'">
								<xsl:call-template name="t_threadsearchphraseontabcontent">
									<xsl:with-param name="range" select="$PostRange"/>
									<xsl:with-param name="pagenumber" select="substring-after($PostRange, ' - ') div @COUNT"/>
								</xsl:call-template>
							</xsl:when>
							<xsl:otherwise>
								<a href="{$root}TSP?skip={$skip}&amp;show={@COUNT}{$currentRegion}" xsl:use-attribute-sets="mTHREADSEARCH_on_threadsearchphraseblockdisplay">
									<xsl:call-template name="t_threadsearchphrasethreadontabcontent">
										<xsl:with-param name="range" select="$PostRange"/>
										<xsl:with-param name="pagenumber" select="substring-after($PostRange, ' - ') div @COUNT"/>
									</xsl:call-template>
								</a>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:with-param>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="." mode="off_threadsearchphraseblockdisplay">
					<xsl:with-param name="url">
						<a href="{$root}TSP?skip={$skip}&amp;show={@COUNT}{$currentRegion}" xsl:use-attribute-sets="mTHREADSEARCH_off_threadsearchphraseblockdisplay">
							<xsl:call-template name="t_threadsearchphraseofftabcontent">
								<xsl:with-param name="range" select="$PostRange"/>
								<xsl:with-param name="pagenumber" select="substring-after($PostRange, ' - ') div @COUNT"/>
							</xsl:call-template>
						</a>
					</xsl:with-param>
				</xsl:apply-templates>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- tdpsplit is the numbers of tabs that appear on one page-->
	<xsl:variable name="tdpsplit" select="10"/>
	<!--tdp_lowerrange is the skip value of the first post of the first page of the series of tabs on the page-->
	<xsl:param name="tdp_lowerrange">
		<xsl:choose>
			<xsl:when test="/H2G2/THREADSEARCHPHRASE/THREADSEARCH">
				<xsl:value-of select="floor(/H2G2/THREADSEARCHPHRASE/THREADSEARCH/@SKIPTO div ($tdpsplit * /H2G2/THREADSEARCHPHRASE/THREADSEARCH/@COUNT)) * ($tdpsplit * /H2G2/THREADSEARCHPHRASE/THREADSEARCH/@COUNT)"/>
			</xsl:when>
			<xsl:when test="/H2G2/THREADSEARCHPHRASE/FORUMTHREADPOSTS">
				<xsl:value-of select="floor(/H2G2/THREADSEARCHPHRASE/FORUMTHREADPOSTS/@SKIPTO div ($tdpsplit * /H2G2/THREADSEARCHPHRASE/FORUMTHREADPOSTS/@COUNT)) * ($tdpsplit * /H2G2/THREADSEARCHPHRASE/FORUMTHREADPOSTS/@COUNT)"/>
			</xsl:when>
		</xsl:choose>
	</xsl:param>
	<!--tdp_upperrange is the skip value of the first post of the last page of the series of tabs on the page-->
	<xsl:param name="tdp_upperrange">
		<xsl:choose>
			<xsl:when test="/H2G2/THREADSEARCHPHRASE/THREADSEARCH">
				<xsl:value-of select="$tdp_lowerrange + (($tdpsplit - 1) * /H2G2/THREADSEARCHPHRASE/THREADSEARCH/@COUNT)"/>
			</xsl:when>
			<xsl:when test="/H2G2/THREADSEARCHPHRASE/FORUMTHREADPOSTS">
				<xsl:value-of select="$tdp_lowerrange + (($tdpsplit - 1) * /H2G2/THREADSEARCHPHRASE/FORUMTHREADPOSTS/@COUNT)"/>
			</xsl:when>
		</xsl:choose>
	</xsl:param>
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
	<xsl:template name="t_threadsearchphraseontabcontent">
	Use: Controls the content of the link for the currently visible page
	-->
	<xsl:template name="t_threadsearchphrasethreadontabcontent">
		<xsl:param name="range"/>
		<xsl:param name="pagenumber"/>
		<xsl:value-of select="$pagenumber"/>
	</xsl:template>
	<!--xsl:attribute-set name="mTHREADSEARCH_on_threadblockdisplay"/>
	<xsl:attribute-set name="mTHREADSEARCH_off_threadblockdisplay"/>
	<xsl:attribute-set name="mTHREADSEARCH_r_threadblockdisplayprev"/>
	<xsl:attribute-set name="mTHREADSEARCH_r_threadblockdisplaynext"/>
	<xsl:attribute-set name="mFORUMTHREADPOSTS_on_threadblockdisplay"/>
	<xsl:attribute-set name="mFORUMTHREADPOSTS_off_threadblockdisplay"/>
	<xsl:attribute-set name="mFORUMTHREADPOSTS_r_threadblockdisplayprev"/>
	<xsl:attribute-set name="mFORUMTHREADPOSTS_r_threadblockdisplaynext"/-->
	<!--
	<xsl:template match="TOP-FIVES" mode="c_threadsearchphrasepage">
	Author:		Tom Whitehouse
	Context:     
	Purpose:	 Calls the template to create the container for the tag cloud
	-->
	<xsl:template match="HOT-PHRASES" mode="c_threadsearchphrasepage">
		<xsl:apply-templates select="." mode="r_threadsearchphrasepage"/>
	</xsl:template>
	<!--
	<xsl:template match="HOT-PHRASE" mode="c_threadsearchphrasepage">
	Author:		Tom Whitehouse
	Context:     
	Purpose:	 Calls the template to create the container for a single item in the tag cloud
	-->
	<xsl:template match="HOT-PHRASE" mode="c_threadsearchphrasepage">
		<xsl:apply-templates select="." mode="r_threadsearchphrasepage"/>
	</xsl:template>
	<!--
	<xsl:template match="THREADSEARCH" mode="c_threadsearchphraseblockdisplay">
	Author:		Tom Whitehouse
	Context:     
	Purpose:	 Single tag cloud item
	-->
	<xsl:template name="truncateTagName">
		<xsl:choose>
				<xsl:when test="string-length(NAME) &gt; 20">
					<xsl:value-of select="substring(NAME, 1, 20)"/>
					<xsl:text>...</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="NAME"/>
				</xsl:otherwise>
			</xsl:choose>
	</xsl:template>
	<xsl:template match="HOT-PHRASE" mode="r_threadsearchphrasepage">
		<xsl:variable name="region">
			<xsl:if test="key('regions', /H2G2/THREADSEARCHPHRASE/PHRASES/PHRASE/NAME)">
				<xsl:text>&amp;phrase=</xsl:text>
				<xsl:value-of select="key('regions', /H2G2/THREADSEARCHPHRASE/PHRASES/PHRASE/NAME)/TERM"/>
				<!--xsl:text>&quot;</xsl:text-->
			</xsl:if>
		</xsl:variable>
		<a href="{$root}TSP?phrase={TERM}{$region}" xsl:use-attribute-sets="mHOT-PHRASE_r_threadsearchphrasepage">
			<xsl:call-template name="truncateTagName"/>
			
		</a>
	</xsl:template>
	<xsl:template match="HOT-PHRASES" mode="c_more">
		<xsl:if test="@MORE=1 and not(/H2G2/PARAMS/PARAM[NAME='s_page']/VALUE='morephrases')">
			<xsl:apply-templates select="." mode="r_more"/>
		</xsl:if>
	</xsl:template>
	<xsl:template match="HOT-PHRASES" mode="r_more">
		<a href="{$root}TSP?skipphrases={@SKIP}&amp;showphrases=200&amp;s_page=morephrases&amp;sortby=Phrase">more ...</a>
	</xsl:template>
	<xsl:template match="THREADSEARCHPHRASE" mode="c_newthread">
		<xsl:apply-templates select="." mode="r_newthread"/>
	</xsl:template>
	<xsl:attribute-set name="mTHREADSEARCHPHRASE_r_newthread"/>
	<xsl:variable name="m_tspstartnewdiscussion">
		<img src="{$imagesource}startnewdiscussioneng.gif" alt="Start a new discussion" width="141" height="20" border="0"/>
	</xsl:variable>
	<xsl:template match="THREADSEARCHPHRASE" mode="r_newthread">
		<a xsl:use-attribute-sets="mTHREADSEARCHPHRASE_r_newthread">
			<xsl:attribute name="href">
				<xsl:call-template name="sso_addcommenttsp_signin"/>
				<xsl:value-of select="$currentRegion"/>
			</xsl:attribute>
			<xsl:copy-of select="$m_tspstartnewdiscussion"/>
			
			<!--xsl:text>Start a new discussion</xsl:text-->
		</a>
	</xsl:template>
	<xsl:template match="PHRASES" mode="c_region">
		<xsl:if test="not(/H2G2/PARAMS/PARAM[NAME='s_page']/VALUE='morephrases')">
			<xsl:apply-templates select="." mode="r_region"/>
		</xsl:if>
	</xsl:template>
	<xsl:template match="PHRASES" mode="t_region">
		<xsl:choose>
			<xsl:when test="key('regions', PHRASE/NAME)">
				<xsl:value-of select="key('regions', PHRASE/NAME)/NAME"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>England</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="PHRASES" mode="c_item">
		<xsl:apply-templates select="." mode="r_item"/>
		<!--xsl:if test="not(key('regions', PHRASE))">
			<xsl:apply-templates select="." mode="r_item"/>
		</xsl:if-->
	</xsl:template>
	<xsl:template match="PHRASE" mode="c_item">
		<xsl:apply-templates select="." mode="r_item"/>
	</xsl:template>
	<xsl:template match="ADDTHREADSEARCHPHRASE" mode="c_add">
		<form method="post" action="TSP">
			<input type="hidden" name="forum" value="{THREADPHRASELIST/@FORUMID}"/>
			<input type="hidden" name="thread" value="{THREADPHRASELIST/@THREADID}"/>
			<input type="hidden" name="s_returnto" value="F{THREADPHRASELIST/@FORUMID}?thread={THREADPHRASELIST/@THREADID}"/>
			<xsl:apply-templates select="." mode="r_add"/>
		</form>
	</xsl:template>
	<!-- 
	#######################################################
					HOT-PHRASES BLOCKS 
	#######################################################
	-->
	<!--
	<xsl:template match="THREADSEARCH" mode="c_threadsearchphraseblocks">
	Author:		Tom Whitehouse
	Context:      
	Purpose:	 Calls the container for the thread blocks navigation
	-->
	<xsl:template match="HOT-PHRASES" mode="c_phraseblocks">
		<!--xsl:copy-of select="$ranked-hot-phrases"/-->
		<xsl:if test="/H2G2/PARAMS/PARAM[NAME='s_page']/VALUE='morephrases'">
			<xsl:apply-templates select="." mode="r_phraseblocks"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="THREADSEARCH" mode="c_threadsearchphraseblockdisplayprev">
	Author:		Tom Whitehouse
	Context:      
	Purpose:	 Calls the container for the previous link in the thread blocks navigation
	-->
	<xsl:template match="HOT-PHRASES" mode="c_phraseblockdisplayprev">
		<xsl:if test="($hp_lowerrange != 0)">
			<xsl:apply-templates select="." mode="r_phraseblockdisplayprev"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="THREADSEARCH" mode="r_threadsearchphraseblockdisplayprev">
	Author:		Tom Whitehouse
	Context:      
	Purpose:	 Creates the previous link in the thread blocks navigation
	-->
	<xsl:template match="HOT-PHRASES" mode="r_phraseblockdisplayprev">
		<a href="{$root}TSP?skipphrases={$hp_lowerrange - @SHOW}&amp;show={@SHOW}&amp;sortby=Phrase&amp;s_page=morephrases" xsl:use-attribute-sets="mHOT-PHRASES_r_phraseblockdisplayprev">
			<xsl:copy-of select="$m_phrasepostblockprev"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="THREADSEARCH" mode="c_threadsearchphraseblockdisplaynext">
	Author:		Tom Whitehouse
	Context:     
	Purpose:	 Calls the container for the next link in the thread blocks navigation
	-->
	<xsl:template match="HOT-PHRASES" mode="c_phraseblockdisplaynext">
		<xsl:if test="(($hp_upperrange + @SHOW) &lt; @COUNT)">
			<xsl:apply-templates select="." mode="r_phraseblockdisplaynext"/>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="THREADSEARCH" mode="r_threadsearchphraseblockdisplaynext">
	Author:		Tom Whitehouse
	Context:      
	Purpose:	 Creates the next link in the thread blocks navigation
	-->
	<xsl:template match="HOT-PHRASES" mode="r_phraseblockdisplaynext">
		<a href="{$root}TSP?skipphrases={$hp_upperrange + @SHOW}&amp;showphrases={@SHOW}&amp;sortby=Phrase&amp;s_page=morephrases" xsl:use-attribute-sets="mHOT-PHRASES_r_phraseblockdisplaynext">
			<xsl:copy-of select="$m_phrasepostblocknext"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="THREADSEARCH" mode="c_threadsearchphraseblockdisplay">
	Author:		Tom Whitehouse
	Context:     
	Purpose:	 Calls the template to create the links in the thread blocks navigation
	-->
	<xsl:template match="HOT-PHRASES" mode="c_phraseblockdisplay">
		<xsl:param name="onlink"/>
		<xsl:param name="skip" select="$hp_lowerrange"/>
		<xsl:apply-templates select="." mode="displayblockhp">
			<xsl:with-param name="skip" select="$skip"/>
			<xsl:with-param name="onlink" select="$onlink"/>
		</xsl:apply-templates>
		<xsl:if test="(($skip + @SHOW) &lt; @COUNT) and ($skip &lt; $hp_upperrange)">
			<xsl:apply-templates select="." mode="c_phraseblockdisplay">
				<xsl:with-param name="skip" select="$skip + @SHOW"/>
				<xsl:with-param name="onlink" select="$onlink"/>
			</xsl:apply-templates>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="THREADSEARCH" mode="displayblocktdp">
	Author:		Tom Whitehouse
	Context:    
	Purpose:	 Creates the individual links in the postblock area within the range set above
	-->
	<xsl:template match="HOT-PHRASES" mode="displayblockhp">
		<xsl:param name="skip"/>
		<xsl:param name="onlink"/>
		<xsl:param name="PostRange" select="concat(($skip + 1), ' - ', ($skip + @SHOW))"/>
		<xsl:choose>
			<xsl:when test="@SKIP = $skip">
				<xsl:apply-templates select="." mode="on_phraseblockdisplay">
					<xsl:with-param name="url">
						<xsl:choose>
							<xsl:when test="$onlink = 'no'">
								<xsl:call-template name="t_phraseontabcontent">
									<xsl:with-param name="range" select="$PostRange"/>
									<xsl:with-param name="pagenumber" select="substring-after($PostRange, ' - ') div @SHOW"/>
								</xsl:call-template>
							</xsl:when>
							<xsl:otherwise>
								<a href="{$root}TSP?skipphrases={$skip}&amp;showphrases={@SHOW}&amp;sortby=Phrase&amp;s_page=morephrases" xsl:use-attribute-sets="mHOT-PHRASES_on_phraseblockdisplay">
									<xsl:call-template name="t_phraseontabcontent">
										<xsl:with-param name="range" select="$PostRange"/>
										<xsl:with-param name="pagenumber" select="substring-after($PostRange, ' - ') div @SHOW"/>
									</xsl:call-template>
								</a>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:with-param>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="." mode="off_phraseblockdisplay">
					<xsl:with-param name="url">
						<a href="{$root}TSP?skipphrases={$skip}&amp;showphrases={@SHOW}&amp;sortby=Phrase&amp;s_page=morephrases" xsl:use-attribute-sets="mHOT-PHRASES_off_phraseblockdisplay">
							<xsl:call-template name="t_phraseofftabcontent">
								<xsl:with-param name="range" select="$PostRange"/>
								<xsl:with-param name="pagenumber" select="substring-after($PostRange, ' - ') div @SHOW"/>
							</xsl:call-template>
						</a>
					</xsl:with-param>
				</xsl:apply-templates>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- tdpsplit is the numbers of tabs that appear on one page-->
	<xsl:variable name="hpsplit" select="10"/>
	<!--tdp_lowerrange is the skip value of the first post of the first page of the series of tabs on the page-->
	<xsl:param name="hp_lowerrange">
		<xsl:value-of select="floor(/H2G2/HOT-PHRASES/@SKIP div ($tdpsplit * /H2G2/HOT-PHRASES/@SHOW)) * ($tdpsplit * /H2G2/HOT-PHRASES/@SHOW)"/>
		<!--xsl:choose>
			<xsl:when test="/H2G2/THREADSEARCHPHRASE/THREADSEARCH">
				<xsl:value-of select="floor(/H2G2/THREADSEARCHPHRASE/THREADSEARCH/@SKIPTO div ($tdpsplit * /H2G2/THREADSEARCHPHRASE/THREADSEARCH/@COUNT)) * ($tdpsplit * /H2G2/THREADSEARCHPHRASE/THREADSEARCH/@COUNT)"/>
			</xsl:when>
			<xsl:when test="/H2G2/THREADSEARCHPHRASE/FORUMTHREADPOSTS">
				<xsl:value-of select="floor(/H2G2/THREADSEARCHPHRASE/FORUMTHREADPOSTS/@SKIPTO div ($tdpsplit * /H2G2/THREADSEARCHPHRASE/FORUMTHREADPOSTS/@COUNT)) * ($tdpsplit * /H2G2/THREADSEARCHPHRASE/FORUMTHREADPOSTS/@COUNT)"/>
			</xsl:when>
		</xsl:choose-->
	</xsl:param>
	<!--tdp_upperrange is the skip value of the first post of the last page of the series of tabs on the page-->
	<xsl:param name="hp_upperrange">
		<xsl:value-of select="$tdp_lowerrange + (($tdpsplit - 1) * /H2G2/HOT-PHRASES/@SHOW)"/>
		<!--xsl:choose>
			<xsl:when test="/H2G2/THREADSEARCHPHRASE/THREADSEARCH">
				<xsl:value-of select="$tdp_lowerrange + (($tdpsplit - 1) * /H2G2/THREADSEARCHPHRASE/THREADSEARCH/@COUNT)"/>
			</xsl:when>
			<xsl:when test="/H2G2/THREADSEARCHPHRASE/FORUMTHREADPOSTS">
				<xsl:value-of select="$tdp_lowerrange + (($tdpsplit - 1) * /H2G2/THREADSEARCHPHRASE/FORUMTHREADPOSTS/@COUNT)"/>
			</xsl:when>
		</xsl:choose-->
	</xsl:param>
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
	<xsl:template name="t_threadsearchphraseontabcontent">
	Use: Controls the content of the link for the currently visible page
	-->
	<xsl:template name="t_phrasethreadontabcontent">
		<xsl:param name="range"/>
		<xsl:param name="pagenumber"/>
		<xsl:value-of select="$pagenumber"/>
	</xsl:template>
	<!--xsl:template match="HOT-PHRASES" mode="c_phraseblocks">
		<xsl:apply-templates select="." mode="r_phraseblocks"/>
	</xsl:template-->
	<!--
	<xsl:template match="THREADSEARCH" mode="c_firstpage">
	Author:		Andy Harris
	Context:      /H2G2/THREADSEARCH
	Purpose:	 Calls the correct container for the 'First page' link
	-->
	<xsl:template match="THREADSEARCH" mode="c_firstpage">
		<xsl:choose>
			<xsl:when test="not(@SKIPTO = 0)">
				<xsl:apply-templates select="." mode="link_firstpage"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="." mode="text_firstpage"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="THREADSEARCH" mode="c_lastpage">
	Author:		Andy Harris
	Context:      /H2G2/THREADSEARCH
	Purpose:	 Calls the correct container for the 'Last page' link
	-->
	<xsl:template match="THREADSEARCH" mode="c_lastpage">
		<xsl:choose>
			<xsl:when test="@MORE = 1">
				<xsl:apply-templates select="." mode="link_lastpage"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="." mode="text_lastpage"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="THREADSEARCH" mode="c_previouspage">
	Author:		Andy Harris
	Context:      /H2G2/THREADSEARCH
	Purpose:	 Calls the correct container for the 'Previous page' link
	-->
	<xsl:template match="THREADSEARCH" mode="c_previouspage">
		<xsl:choose>
			<xsl:when test="not(@SKIPTO = 0)">
				<xsl:apply-templates select="." mode="link_previouspage"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="." mode="text_previouspage"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="THREADSEARCH" mode="c_nextpage">
	Author:		Andy Harris
	Context:      /H2G2/THREADSEARCH
	Purpose:	 Calls the correct container for the 'Next page' link
	-->
	<xsl:template match="THREADSEARCH" mode="c_nextpage">
		<xsl:choose>
			<xsl:when test="@MORE = 1">
				<xsl:apply-templates select="." mode="link_nextpage"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="." mode="text_nextpage"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!--
	<xsl:template match="THREADSEARCH" mode="link_firstpage">
	Author:		Andy Harris
	Context:      /H2G2/THREADSEARCH
	Purpose:	 Creates the 'First page' link
	-->
	<xsl:template match="THREADSEARCH" mode="link_firstpage">
		<a href="{$root}TSP?show={@COUNT}&amp;skip=0{$currentRegion}" xsl:use-attribute-sets="mTHREADSEARCH_link_firstpage">
			<xsl:copy-of select="$m_firstpagethreads"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="THREADSEARCH" mode="link_lastpage">
	Author:		Andy Harris
	Context:      /H2G2/THREADSEARCH
	Purpose:	 Creates the 'Last page' link
	-->
	<xsl:template match="THREADSEARCH" mode="link_lastpage">
		<a href="{$root}TSP?show={@COUNT}&amp;skip={number(@TOTALTHREADS) - number(@COUNT)}{$currentRegion}" xsl:use-attribute-sets="mTHREADSEARCH_link_lastpage">
			<xsl:copy-of select="$m_lastpagethreads"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="THREADSEARCH" mode="link_previouspage">
	Author:		Andy Harris
	Context:      /H2G2/THREADSEARCH
	Purpose:	 Creates the 'Previous page' link
	-->
	<xsl:template match="THREADSEARCH" mode="link_previouspage">
		<a href="{$root}TSP?show={@COUNT}&amp;skip={number(@SKIPTO) - number(@COUNT)}{$currentRegion}" xsl:use-attribute-sets="mTHREADSEARCH_link_previouspage">
			<xsl:copy-of select="$m_previouspagethreads"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="THREADSEARCH" mode="link_nextpage">
	Author:		Andy Harris
	Context:      /H2G2/THREADSEARCH
	Purpose:	 Creates the 'Next page' link
	-->
	<xsl:template match="THREADSEARCH" mode="link_nextpage">
		<a href="{$root}TSP?show={@COUNT}&amp;skip={number(@SKIPTO) + number(@COUNT)}{$currentRegion}" xsl:use-attribute-sets="mTHREADSEARCH_link_nextpage">
			<xsl:copy-of select="$m_nextpagethreads"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="THREADSEARCH" mode="text_firstpage">
	Author:		Andy Harris
	Context:      /H2G2/THREADSEARCH
	Purpose:	 Creates the 'On first page' text
	-->
	<xsl:template match="THREADSEARCH" mode="text_firstpage">
		<xsl:copy-of select="$m_nofirstpagethreads"/>
	</xsl:template>
	<!--
	<xsl:template match="THREADSEARCH" mode="text_lastpage">
	Author:		Andy Harris
	Context:      /H2G2/THREADSEARCH
	Purpose:	 Creates the 'On last page' text
	-->
	<xsl:template match="THREADSEARCH" mode="text_lastpage">
		<xsl:copy-of select="$m_nolastpagethreads"/>
	</xsl:template>
	<!--
	<xsl:template match="THREADSEARCH" mode="text_previouspage">
	Author:		Andy Harris
	Context:      /H2G2/THREADSEARCH
	Purpose:	 Creates the 'No previous page' text
	-->
	<xsl:template match="THREADSEARCH" mode="text_previouspage">
		<xsl:copy-of select="$m_nopreviouspagethreads"/>
	</xsl:template>
	<!--
	<xsl:template match="THREADSEARCH" mode="text_nextpage">
	Author:		Andy Harris
	Context:      /H2G2/THREADSEARCH
	Purpose:	 Creates the 'No next page' text
	-->
	<xsl:template match="THREADSEARCH" mode="text_nextpage">
		<xsl:copy-of select="$m_nonextpagethreads"/>
	</xsl:template>
	<xsl:attribute-set name="mTHREADSEARCH_link_firstpage"/>
	<xsl:attribute-set name="mTHREADSEARCH_link_lastpage"/>
	<xsl:attribute-set name="mTHREADSEARCH_link_previouspage"/>
	<xsl:attribute-set name="mTHREADSEARCH_link_nextpage"/>
	
	
	<!--
	<xsl:template match="THREADSEARCH" mode="c_firstpage">
	Author:		Andy Harris
	Context:      /H2G2/THREADSEARCH
	Purpose:	 Calls the correct container for the 'First page' link
	-->
	<xsl:template match="HOT-PHRASES" mode="c_firstphrasepage">
		<xsl:choose>
			<xsl:when test="not(@SKIP = 0)">
				<xsl:apply-templates select="." mode="link_firstphrasepage"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="." mode="text_firstphrasepage"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="THREADSEARCH" mode="c_lastpage">
	Author:		Andy Harris
	Context:      /H2G2/THREADSEARCH
	Purpose:	 Calls the correct container for the 'Last page' link
	-->
	<xsl:template match="HOT-PHRASES" mode="c_lastphrasepage">
		<xsl:choose>
			<xsl:when test="@MORE = 1">
				<xsl:apply-templates select="." mode="link_lastphrasepage"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="." mode="text_lastphrasepage"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="THREADSEARCH" mode="c_previouspage">
	Author:		Andy Harris
	Context:      /H2G2/THREADSEARCH
	Purpose:	 Calls the correct container for the 'Previous page' link
	-->
	<xsl:template match="HOT-PHRASES" mode="c_previousphrasepage">
		<xsl:choose>
			<xsl:when test="not(@SKIP = 0)">
				<xsl:apply-templates select="." mode="link_previousphrasepage"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="." mode="text_previousphrasepage"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="THREADSEARCH" mode="c_nextpage">
	Author:		Andy Harris
	Context:      /H2G2/THREADSEARCH
	Purpose:	 Calls the correct container for the 'Next page' link
	-->
	<xsl:template match="HOT-PHRASES" mode="c_nextphrasepage">
		<xsl:choose>
			<xsl:when test="@MORE = 1">
				<xsl:apply-templates select="." mode="link_nextphrasepage"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="." mode="text_nextphrasepage"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="THREADSEARCH" mode="link_firstpage">
	Author:		Andy Harris
	Context:      /H2G2/THREADSEARCH
	Purpose:	 Creates the 'First page' link
	-->
	<xsl:template match="HOT-PHRASES" mode="link_firstphrasepage">
		<a href="{$root}TSP?showphrases={@COUNT}&amp;skipphrases=0&amp;s_page=morephrases&amp;sortby=Phrase" xsl:use-attribute-sets="mTHREADSEARCH_link_firstpage">
			<xsl:copy-of select="$m_firstpagethreads"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="THREADSEARCH" mode="link_lastpage">
	Author:		Andy Harris
	Context:      /H2G2/THREADSEARCH
	Purpose:	 Creates the 'Last page' link
	-->
	<xsl:template match="HOT-PHRASES" mode="link_lastphrasepage">
		<a href="{$root}TSP?showphrases={@SHOW}&amp;skipphrases={number(@COUNT) - number(@SHOW)}&amp;sortby=Phrase&amp;s_page=morephrases" xsl:use-attribute-sets="mTHREADSEARCH_link_lastpage">
			<xsl:copy-of select="$m_lastpagethreads"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="THREADSEARCH" mode="link_previouspage">
	Author:		Andy Harris
	Context:      /H2G2/THREADSEARCH
	Purpose:	 Creates the 'Previous page' link
	-->
	<xsl:template match="HOT-PHRASES" mode="link_previousphrasepage">
		<a href="{$root}TSP?showphrases={@SHOW}&amp;skipphrases={number(@SKIP) - number(@SHOW)}&amp;sortby=Phrase&amp;s_page=morephrases" xsl:use-attribute-sets="mTHREADSEARCH_link_previouspage">
			<xsl:copy-of select="$m_previouspagethreads"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="THREADSEARCH" mode="link_nextpage">
	Author:		Andy Harris
	Context:      /H2G2/THREADSEARCH
	Purpose:	 Creates the 'Next page' link
	-->
	<xsl:template match="HOT-PHRASES" mode="link_nextphrasepage">
		<a href="{$root}TSP?showphrases={@SHOW}&amp;skipphrases={number(@SKIP) + number(@SHOW)}&amp;sortby=Phrase&amp;s_page=morephrases" xsl:use-attribute-sets="mTHREADSEARCH_link_nextpage">
			<xsl:copy-of select="$m_nextpagethreads"/>
		</a>
	</xsl:template>
	<!--
	<xsl:template match="THREADSEARCH" mode="text_firstpage">
	Author:		Andy Harris
	Context:      /H2G2/THREADSEARCH
	Purpose:	 Creates the 'On first page' text
	-->
	<xsl:template match="HOT-PHRASES" mode="text_firstphrasepage">
		<xsl:copy-of select="$m_nofirstpagethreads"/>
	</xsl:template>
	<!--
	<xsl:template match="THREADSEARCH" mode="text_lastpage">
	Author:		Andy Harris
	Context:      /H2G2/THREADSEARCH
	Purpose:	 Creates the 'On last page' text
	-->
	<xsl:template match="HOT-PHRASES" mode="text_lastphrasepage">
		<xsl:copy-of select="$m_nolastpagethreads"/>
	</xsl:template>
	<!--
	<xsl:template match="THREADSEARCH" mode="text_previouspage">
	Author:		Andy Harris
	Context:      /H2G2/THREADSEARCH
	Purpose:	 Creates the 'No previous page' text
	-->
	<xsl:template match="HOT-PHRASES" mode="text_previousphrasepage">
		<xsl:copy-of select="$m_nopreviouspagethreads"/>
	</xsl:template>
	<!--
	<xsl:template match="THREADSEARCH" mode="text_nextpage">
	Author:		Andy Harris
	Context:      /H2G2/THREADSEARCH
	Purpose:	 Creates the 'No next page' text
	-->
	<xsl:template match="HOT-PHRASES" mode="text_nextphrasepage">
		<xsl:copy-of select="$m_nonextpagethreads"/>
	</xsl:template>
	
	
	<xsl:template match="THREAD" mode="t_tsplastpost">
		<a href="{$root}F{@FORUMID}?thread={@THREADID}&amp;latest=1#p{LASTPOST/@POSTID}">
			<xsl:value-of select="LASTPOST/DATE/@RELATIVE"/>
		</a>
	</xsl:template>
	
	
</xsl:stylesheet>
