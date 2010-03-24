<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<xsl:import href="../../../base/base-threadspage.xsl"/>
	<!--
	THREADS_MAINBODY
				
	-->
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
							Page - Level  template
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<xsl:template name="THREADS_MAINBODY">
	
	<!-- DEBUG -->
	<xsl:call-template name="TRACE">
	<xsl:with-param name="message">THREADS_MAINBODY test variable = <xsl:value-of select="$current_article_type" /></xsl:with-param>
	<xsl:with-param name="pagename">threadspage.xsl</xsl:with-param>
	</xsl:call-template>
	<!-- DEBUG -->
	
		

		<xsl:apply-templates select="FORUMTHREADS" mode="c_threadspage"/>		
	
		<!-- MODERATION TOOLBAR -->
		<div>
			<xsl:apply-templates select="FORUMTHREADS/MODERATIONSTATUS" mode="c_threadspage"/>
		</div>
	</xsl:template>




<!-- headings -->
		<!--
	<xsl:template name="THREADS_SUBJECT">
	Author:		Tom Whitehouse
	Context:      H2G2
	Purpose:	 Creates the text for the subject
	-->
	<xsl:template name="THREADS_SUBJECT">

		<xsl:choose>
			
			<xsl:when test="FORUMSOURCE/@TYPE='reviewforum'">
	   			<div class="threads-a">
					<div class="threads-b">
						<xsl:element name="{$text.base}" use-attribute-sets="text.base"><strong><xsl:value-of select="$m_thisconvforentry_tp"/></strong></xsl:element><br />
						<xsl:element name="{$text.heading}" use-attribute-sets="text.heading"><strong><div class="brownlink"><xsl:apply-templates select="FORUMSOURCE" mode="reviewforum_forumsource"/></div></strong></xsl:element>
					</div>
				</div>
			</xsl:when>

			<xsl:when test="FORUMSOURCE/@TYPE='userpage'">
			<!-- ALL MY MESSAGES -->
	   			<div class="threads-a">
					<div class="threads-b">
						<xsl:element name="{$text.heading}" use-attribute-sets="text.heading"><strong><div class="brownlink"><xsl:apply-templates select="FORUMSOURCE" mode="userpage_forumsource"/></div></strong></xsl:element>
					</div>
				</div>
				<div class="threads-c"><img src="{$imagesource}icons/my_messages.gif" alt="" width="20" height="21" border="0" /><font size="4">&nbsp;<strong><xsl:value-of select="$m_thismessagecentre_tp"/></strong></font></div>
			</xsl:when>

			
			<xsl:otherwise>
	   			<div class="threads-a">
					<div class="threads-b">
						<xsl:element name="{$text.base}" use-attribute-sets="text.base"><xsl:value-of select="$m_thisconvforentry_tp"/></xsl:element><br />
						<xsl:element name="{$text.heading}" use-attribute-sets="text.heading"><strong><div class="brownlink"><xsl:apply-templates select="FORUMSOURCE" mode="article_forumsource"/></div></strong></xsl:element>
					</div>
				</div>
				<br />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	
	<!--
	<xsl:template match="MODERATIONSTATUS" mode="r_threadspage">
	Description: moderation status of the thread
	 -->
	<xsl:template match="MODERATIONSTATUS" mode="r_threadspage">
		<xsl:apply-imports/>
	</xsl:template>

	<!--
	<xsl:template match="FORUMSOURCE/ARTICLE/GUIDE/FORUMTHREADINTRO|FORUMSOURCE/ARTICLE/GUIDE/FORUMINTRO" mode="r_threadspage">
	Use: Presentation of FORUMINTRO if the ARTICLE has one
	 -->
	<xsl:template match="FORUMSOURCE/ARTICLE/GUIDE/FORUMTHREADINTRO|FORUMSOURCE/ARTICLE/GUIDE/FORUMINTRO" mode="r_threadspage">
		<xsl:value-of select="."/>
	</xsl:template>
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
					THREAD Logical Container Template
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<xsl:template match="FORUMTHREADS" mode="r_threadspage">
		<div class="middlewidth">
			<div class="allrecollections">

				<p><xsl:value-of select="/H2G2/FORUMSOURCE/ARTICLE/GUIDE/PRODUCTION_YEAR" /></p>
				<h1><xsl:if test="../FORUMSOURCE/ARTICLE/EXTRAINFO/TYPE/@ID = '30'">Book</xsl:if>
					<xsl:if test="../FORUMSOURCE/ARTICLE/EXTRAINFO/TYPE/@ID = '31'">Comic</xsl:if>
					<xsl:if test="../FORUMSOURCE/ARTICLE/EXTRAINFO/TYPE/@ID = '32'">Film</xsl:if>
					<xsl:if test="../FORUMSOURCE/ARTICLE/EXTRAINFO/TYPE/@ID = '33'">Radio</xsl:if>
					<xsl:if test="../FORUMSOURCE/ARTICLE/EXTRAINFO/TYPE/@ID = '34'">TV</xsl:if>
					<xsl:if test="../FORUMSOURCE/ARTICLE/EXTRAINFO/TYPE/@ID = '35'">Other</xsl:if>: 
					<a>
						<xsl:attribute name="href"><xsl:value-of select="concat($root, 'A', ../FORUMSOURCE/ARTICLE/ARTICLEINFO/H2G2ID)" /></xsl:attribute>
						<xsl:value-of select="../FORUMSOURCE/ARTICLE/SUBJECT" />
					</a>. Author: <xsl:value-of select="../FORUMSOURCE/ARTICLE/GUIDE/CREATOR" /></h1>
				<div class="allrecollections_toptext">
					<p><xsl:value-of select="../FORUMSOURCE/ARTICLE/GUIDE/SUM_UP" /></p>
				</div>
			</div>

			<div class="allrecollection_topbgtop"></div>
			<div class="allrecollection_topbgbottom"></div>
			<div class="allrecollection_title"><h2><img src="{$imageRoot}images/allrecollections/title_recollections.gif" border="0" width="136" height="23" alt="Recollections" /></h2></div>

			<!-- next previous buttons -->
			<div class="vspace10px"> </div>
			<div class="allmessages">
						<div class="allmessages_line"></div>
						<!-- <p class="pnormal">Page <strong>1</strong> of 5</p> -->
						<div class="clear"> </div>
						
						<table width="100%">
							<tr>

							   <td align="left" width="30%"><p class="pnormaltop"><!-- <a href="#"><img  src="{$imageRoot}images/first.gif" border="0" alt="first" width="8" height="7" /> first</a> <a href="#"><img  src="{$imageRoot}images/previous.gif" border="0" alt="previous" width="4" height="7" /> previous</a> -->
							   <xsl:apply-templates select="." mode="c_previouspage"/></p></td>
								<td align="center"><p class="pnormaltop"><!--  <strong>1</strong> | <a href="#">2</a> | <a href="#">3</a> | <a href="#">4</a> | <a href="#">5</a> --> </p></td>

								<td align="right" width="30%"><p class="pnormaltop"><!-- <a href="#">next <img  src="{$imageRoot}images/next.gif" border="0" alt="next" width="4" height="7" /></a> <a href="#">last <img  src="{$imageRoot}images/last.gif" border="0" alt="last" width="8" height="7" /></a> --><xsl:apply-templates select="." mode="c_nextpage"/></p></td>
							</tr>
						</table>
						<div class="allmessages_line"></div>
					</div>


			<div  class="allrecollection_list">
				<xsl:apply-templates select="THREAD" mode="c_threadspage"/>
			</div>
			
			<!-- next previous buttons -->
			<!-- <div class="nextprev"><strong>
			<xsl:apply-templates select="." mode="c_previouspage"/>
			&nbsp;&nbsp;&nbsp;&nbsp;
			<xsl:apply-templates select="." mode="c_nextpage"/>
			</strong></div> -->

				<div class="allmessages">
						<div class="allmessages_line"></div>
						<!-- <p class="pnormal">Page <strong>1</strong> of 5</p> -->
						<div class="clear"> </div>
						<table width="100%">
							<tr>

							   <td align="left" width="30%"><p class="pnormaltop"><!-- <a href="#"><img  src="{$imageRoot}images/first.gif" border="0" alt="first" width="8" height="7" /> first</a> <a href="#"><img  src="{$imageRoot}images/previous.gif" border="0" alt="previous" width="4" height="7" /> previous</a> -->
							   <xsl:apply-templates select="." mode="c_previouspage"/></p></td>
								<td align="center"><p class="pnormaltop"><!--  <strong>1</strong> | <a href="#">2</a> | <a href="#">3</a> | <a href="#">4</a> | <a href="#">5</a> --> </p></td>

								<td align="right" width="30%"><p class="pnormaltop"><!-- <a href="#">next <img  src="{$imageRoot}images/next.gif" border="0" alt="next" width="4" height="7" /></a> <a href="#">last <img  src="{$imageRoot}images/last.gif" border="0" alt="last" width="8" height="7" /></a> --><xsl:apply-templates select="." mode="c_nextpage"/></p></td>
							</tr>
						</table>
						<div class="allmessages_line"></div>
					</div>

			
		</div>
	</xsl:template>


	<!--
	<xsl:template match="THREAD" mode="r_threadspage">
	Use: Presentation of an individual thread in a THREADS page
	 -->
	<xsl:template match="THREAD" mode="r_threadspage">

		<xsl:if test="FIRSTPOST/@HIDDEN=0">

		<!-- <xsl:comment> ENTRY STARTS </xsl:comment> -->
		<h3>
			<xsl:apply-templates select="SUBJECT" mode="t_threadspage"/><img src="{$imageRoot}images/icon_rightarrow.gif" border="0" width="10" height="7" alt="" />
		</h3>
		<p><xsl:value-of select="FIRSTPOST/TEXT/RICHPOST/TIME" /></p>
		<div class="allrecollections_ablock">
			<p>
				<a>
					<xsl:attribute name="href"><xsl:value-of select="concat($root, 'U', FIRSTPOST/USER/USERID)" /></xsl:attribute><img src="{$imageRoot}images/allrecollections/linkimage.gif" border="0" width="45" height="31" alt="" />more from <xsl:value-of select="FIRSTPOST/USER/USERNAME" /> </a></p>

					
		</div>
		<!-- <xsl:comment> ENTRY ENDS </xsl:comment> -->

		</xsl:if>


	
	</xsl:template>
	<!--
	<xsl:template match="LASTPOST" mode="c_threadspage">
	Context:      /H2G2/FORUMTHREADS/THREAD/LASTPOST
	Purpose:	 Calls the container for the LASTPOST object
	-->
	<xsl:template match="LASTPOST" mode="r_threadspage">
		<a href="U{USER/USERID}"><xsl:choose>
								<xsl:when test="USER/EDITOR = 1"><span class="editorName"><em><strong><xsl:value-of select="USER/USERNAME" /></strong></em></span></xsl:when>
								<xsl:otherwise><xsl:value-of select="USER/USERNAME" /></xsl:otherwise>
								</xsl:choose></a>
	</xsl:template>
	
	<!--
	<xsl:template match="@THREADID" mode="r_movethreadgadget">
	Use: Presentation of the move thread editorial tool link
	 -->
	<xsl:template match="@THREADID" mode="r_movethreadgadget">
		<xsl:apply-imports/>
		<br/>
	</xsl:template>
	<!--
	<xsl:template match="FORUMTHREADS" mode="r_subscribe">
	Use: Presentation of the subscribe / unsubscribe button
	 -->
	<xsl:template match="FORUMTHREADS" mode="r_subscribe">
		<xsl:apply-imports/>
	</xsl:template>
	<!--
	<xsl:template match="@THREADID" mode="r_movethreadgadget">
	Use: Presentation of the move thread editorial tool link
	 -->
	<xsl:template match="@THREADID" mode="r_movethreadgadget">
		<xsl:apply-imports/>
	</xsl:template>
	<xsl:variable name="tpsplit" select="8"/>
	<!-- 
	<xsl:template match="FORUMTHREADPOSTS" mode="r_postblocks">
	Use: Container for the complete list of post blocks
	-->
	<xsl:template match="FORUMTHREADS" mode="r_threadblocks">
		<!-- <xsl:apply-templates select="." mode="c_threadblockdisplayprev"/> -->
		<xsl:apply-templates select="." mode="c_threadblockdisplay"/>
	<!-- 	<xsl:apply-templates select="." mode="c_threadblockdisplaynext"/> -->
	</xsl:template>
	<!-- 
	<xsl:template match="FORUMTHREADPOSTS" mode="r_blockdisplayprev">
	Use: Presentation of previous link
	-->
	<xsl:template match="FORUMTHREADS" mode="r_threadblockdisplayprev">
		<xsl:apply-imports/>
	</xsl:template>
	<!-- 
	<xsl:template match="FORUMTHREADPOSTS" mode="r_blockdisplaynext">
	Use: Presentation of next link
	-->
	<xsl:template match="FORUMTHREADS" mode="r_threadblockdisplaynext">
		<xsl:apply-imports/>
	</xsl:template>
	<!-- 
	<xsl:template match="FORUMTHREADS" mode="on_blockdisplay">
	Use: Controls the display of the block (outside the link) which is currently appearing on the page
	-->
	<xsl:template match="FORUMTHREADS" mode="on_threadblockdisplay">
		<xsl:param name="url"/>
		<xsl:copy-of select="$url"/>
	</xsl:template>
	<!-- 
	<xsl:template name="t_ontabcontent">
	Use: Controls the content of the link for the currently visible page
	-->
	<xsl:template name="t_threadontabcontent">
		<xsl:param name="range"/>
		<xsl:param name="pagenumber"/>
		<xsl:value-of select="$pagenumber"/>
	</xsl:template>
	<!-- 
	<xsl:template match="FORUMTHREADS" mode="off_blockdisplay">
	Use: Controls the display of the block (outside the link) which is not currently on the page
	-->
	<xsl:template match="FORUMTHREADS" mode="off_threadblockdisplay">
		<xsl:param name="url"/>
		<xsl:copy-of select="$url"/>
	</xsl:template>
	<!-- 
	<xsl:template name="t_offtabcontent">
	Use: Controls the content of the link for other pages in the currently visible range
	-->
	<xsl:template name="t_threadofftabcontent">
		<xsl:param name="range"/>
		<xsl:param name="pagenumber"/>
		<xsl:value-of select="$pagenumber"/>
	</xsl:template>
	<!-- 
	Use: Attribute sets for the links themselves
	-->
	<xsl:attribute-set name="mFORUMTHREADS_on_threadblockdisplay">
		<xsl:attribute name="class">active</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="mFORUMTHREADS_off_threadblockdisplay">
		<xsl:attribute name="class">inactive</xsl:attribute>
	</xsl:attribute-set>
	<!-- 
	<xsl:template match="FORUMTHREADS" mode="r_newconversation">
	Use: Presentation of the 'New Conversation' link
	-->
	<xsl:template match="FORUMTHREADS" mode="r_newconversation">
		<xsl:apply-imports/>
	</xsl:template>
	<!-- 
	<xsl:template match="FORUMTHREADS" mode="link_firstpage">
	Use: Presentation of the 'First Page' link
	-->
	<xsl:template match="FORUMTHREADS" mode="link_firstpage">
		<xsl:apply-imports/>
	</xsl:template>
	<!-- 
	<xsl:template match="FORUMTHREADS" mode="link_lastpage">
	Use: Presentation of the 'Last Page' link
	-->
	<xsl:template match="FORUMTHREADS" mode="link_lastpage">
		<xsl:apply-imports/>
	</xsl:template>
	<!-- 
	<xsl:template match="FORUMTHREADS" mode="link_previouspage">
	Use: Presentation of the 'Previous Page' link
	-->
	<xsl:template match="FORUMTHREADS" mode="link_previouspage">
		<!-- <span class="previous"> -->
			<xsl:apply-imports/>
		<!-- </span> -->
	</xsl:template>
	<!-- 
	<xsl:template match="FORUMTHREADS" mode="link_nextpage">
	Use: Presentation of the 'Next Page' link
	-->
	<xsl:template match="FORUMTHREADS" mode="link_nextpage">
		<!-- <span class="next"> -->
			<xsl:apply-imports/>
		<!-- </span> -->
	</xsl:template>
	<!-- 
	<xsl:template match="FORUMTHREADS" mode="text_firstpage">
	Use: Presentation of the 'On First Page' message
	-->
	<xsl:template match="FORUMTHREADS" mode="text_firstpage">
		<xsl:apply-imports/>
	</xsl:template>
	<!-- 
	<xsl:template match="FORUMTHREADS" mode="text_lastpage">
	Use: Presentation of the 'On Last Page' message
	-->
	<xsl:template match="FORUMTHREADS" mode="text_lastpage">
		<xsl:apply-imports/>
	</xsl:template>
	<!-- 
	<xsl:template match="FORUMTHREADS" mode="text_previouspage">
	Use: Presentation of the 'No Previous Page' message
	-->
	<xsl:template match="FORUMTHREADS" mode="text_previouspage">
		<xsl:apply-imports/>
	</xsl:template>
	<!-- 
	<xsl:template match="FORUMTHREADS" mode="text_nextpage">
	Use: Presentation of the 'No Next Page' message
	-->
	<xsl:template match="FORUMTHREADS" mode="text_nextpage">
		<xsl:apply-imports/>
	</xsl:template>
	<!-- 
	<xsl:template match="@SKIPTO" mode="r_gotobeginning">
	use: Skip to the beginning of the conversation embodiment
	-->
	<xsl:template match="@SKIPTO" mode="link_tpgotobeginning">
		<font size="2">
			<xsl:apply-imports/>
		</font>
	</xsl:template>
	<!-- 
	<xsl:template match="@SKIPTO" mode="r_gotoprevious">
	use: Skip to the previous page of the conversation embodiment
	-->
	<xsl:template match="@SKIPTO" mode="link_tpgotoprevious">
		<font size="2">
			<a href="{$root}F{../@FORUMID}?thread={../@THREADID}&amp;skip={(.) - (../@COUNT)}&amp;show={../@COUNT}" xsl:use-attribute-sets="maSKIPTO_link_tpgotoprevious">Previous</a>
		</font>
	</xsl:template>
	<!-- 
	<xsl:template match="@SKIPTO" mode="r_gotonext">
	use: Skip to the next page of the conversation embodiment
	-->
	<xsl:template match="@SKIPTO" mode="link_tpgotonext">
		<font size="2">
			<a href="{$root}F{../@FORUMID}?thread={../@THREADID}&amp;skip={(.) + (../@COUNT)}&amp;show={../@COUNT}" xsl:use-attribute-sets="maSKIPTO_link_tpgotonext">Next</a>
		</font>
	</xsl:template>
	<!-- 
	<xsl:template match="@SKIPTO" mode="r_gotolatest">
	use: Skip to the end of the conversation embodiment
	-->
	<xsl:template match="@SKIPTO" mode="link_tpgotolatest">
		<font size="2">
			<xsl:apply-imports/>
		</font>
	</xsl:template>
	<!-- 
	<xsl:template match="@SKIPTO" mode="r_gotobeginning">
	use: Skip to the beginning of the conversation embodiment
	-->
	<xsl:template match="@SKIPTO" mode="text_tpgotobeginning">
		<font size="2">
			<xsl:apply-imports/>
		</font>
	</xsl:template>
	<!-- 
	<xsl:template match="@SKIPTO" mode="r_gotoprevious">
	use: Skip to the previous page of the conversation embodiment
	-->
	<xsl:template match="@SKIPTO" mode="text_tpgotoprevious">
		<font size="2">
			<xsl:apply-imports/>
		</font>
	</xsl:template>
	<!-- 
	<xsl:template match="@SKIPTO" mode="r_gotonext">
	use: Skip to the next page of the conversation embodiment
	-->
	<xsl:template match="@SKIPTO" mode="text_tpgotonext">
		<font size="2">
			<xsl:apply-imports/>
		</font>
	</xsl:template>
	<!-- 
	<xsl:template match="@SKIPTO" mode="r_gotolatest">
	use: Skip to the end of the conversation embodiment
	-->
	<xsl:template match="@SKIPTO" mode="text_tpgotolatest">
		<font size="2">
			<xsl:apply-imports/>
		</font>
	</xsl:template>
	
</xsl:stylesheet>
