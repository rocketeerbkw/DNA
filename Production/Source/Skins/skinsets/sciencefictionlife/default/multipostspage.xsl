<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<xsl:import href="../../../base/base-multipostspage.xsl"/>
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
				Page - Level  template
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<xsl:template name="MULTIPOSTS_MAINBODY">
	
	<!-- DEBUG -->
	<xsl:call-template name="TRACE">
	<xsl:with-param name="message">MULTIPOSTS_MAINBODY<xsl:value-of select="$current_article_type" /></xsl:with-param>
	<xsl:with-param name="pagename">multipostspage.xsl</xsl:with-param>
	</xsl:call-template>
	<!-- DEBUG -->






		<div class="middlewidth">
	
			<!-- <xsl:comment>TOP SECTION: LEFT IMAGE WITH YEAR AND BOOK TITLE STARTS</xsl:comment> -->
			<div id="textintro">
				<div class="paddingleft10px">
					<!-- RECOLLECTION TITLE @CV@01 -->
					<h1><xsl:value-of select="FORUMTHREADPOSTS/FIRSTPOSTSUBJECT" /></h1>
					<h2>
					<!-- USERNAME @CV@02 removed now only username TW -->
						<!-- <xsl:choose>
							<xsl:when test="FORUMTHREADPOSTS/POST[@INDEX='0']/USER/FIRSTNAMES and FORUMTHREADPOSTS/POST[@INDEX='0']/USER/LASTNAME">
								<xsl:value-of select="concat(FORUMTHREADPOSTS/POST[@INDEX='0']/USER/FIRSTNAMES, ' ', FORUMTHREADPOSTS/POST[@INDEX='0']/USER/LASTNAME)" /> 
							</xsl:when>
							<xsl:otherwise> -->
								<xsl:choose>
			<xsl:when test="FORUMTHREADPOSTS/POST[@INDEX='0']/USER/EDITOR = 1"><span class="editorName"><em><strong><xsl:value-of select="FORUMTHREADPOSTS/POST[@INDEX='0']/USER/USERNAME" /></strong></em></span></xsl:when>
			<xsl:otherwise><xsl:value-of select="FORUMTHREADPOSTS/POST[@INDEX='0']/USER/USERNAME" /></xsl:otherwise>
		</xsl:choose>
							<!-- </xsl:otherwise>
						</xsl:choose> -->
						writes about 
						<!--@cv@! link disabled for testing. remove comments around <a> when ready to go live -->
						<!-- <a href="A{FORUMSOURCE/ARTICLE/ARTICLEINFO/H2G2ID}"> -->
							<xsl:value-of select="FORUMSOURCE/ARTICLE/SUBJECT" />
						<!-- </a> -->
					</h2>
				</div>
				<div class="yelldiagbox"></div>
				
				<div class="piccontainer"> 
				<xsl:choose>
					<xsl:when test="FORUMSOURCE/ARTICLE/GUIDE/IMAGE_LOC != ''"><img src="{$imageRoot}{FORUMSOURCE/ARTICLE/GUIDE/IMAGE_LOC}" alt="{FORUMSOURCE/ARTICLE/GUIDE/CREATOR}" width="160" height="150" border="0" /></xsl:when>
					<xsl:otherwise><img src="{$imageRoot}images/genericentry_2.gif" border="0" alt="{FORUMSOURCE/ARTICLE/GUIDE/CREATOR}" /></xsl:otherwise>
				</xsl:choose>

				</div>
				
			


			
				<!-- BOOK INFORMATION @CV@03 -->
				<div class="scifibggrey">
					<p class="date">
						<!-- PUBLICATION YEAR -->
						<xsl:value-of select="FORUMSOURCE/ARTICLE/GUIDE/PRODUCTION_YEAR" />
					</p>
					<h3>

						 <!-- MEDIA TITLE  -->
						<xsl:if test="FORUMSOURCE/ARTICLE/EXTRAINFO/TYPE/@ID = '30'">Book</xsl:if>
						<xsl:if test="FORUMSOURCE/ARTICLE/EXTRAINFO/TYPE/@ID = '31'">Comic</xsl:if>
						<xsl:if test="FORUMSOURCE/ARTICLE/EXTRAINFO/TYPE/@ID = '32'">Film</xsl:if>
						<xsl:if test="FORUMSOURCE/ARTICLE/EXTRAINFO/TYPE/@ID = '33'">Radio</xsl:if>
						<xsl:if test="FORUMSOURCE/ARTICLE/EXTRAINFO/TYPE/@ID = '34'">TV</xsl:if>
						<xsl:if test="FORUMSOURCE/ARTICLE/EXTRAINFO/TYPE/@ID = '35'">Other</xsl:if>: 


						<a href="A{FORUMSOURCE/ARTICLE/ARTICLEINFO/H2G2ID}">

							<xsl:value-of select="FORUMSOURCE/ARTICLE/SUBJECT" />.

						</a>
							<br/><!-- <div class="vspace10px"></div> -->
						<xsl:if test="FORUMTHREADPOSTS/POST[@INDEX='0']/TEXT/RICHPOST/CREATOR != ''">
						<xsl:choose>
							<xsl:when test="FORUMSOURCE/ARTICLE/EXTRAINFO/TYPE/@ID = '30'">Author: </xsl:when>
							<xsl:otherwise>Creator: </xsl:otherwise>
						</xsl:choose>
						<xsl:value-of select="FORUMTHREADPOSTS/POST[@INDEX='0']/TEXT/RICHPOST/CREATOR" />
						</xsl:if>
				
					</h3>

					<div class="vspace10px"></div>

             		<p class="reccp"><xsl:value-of select="FORUMTHREADPOSTS/POST[@INDEX='0']/TEXT/RICHPOST/TAGLINE" /></p>

				</div>
			</div>
			<!-- <xsl:comment>TOP SECTION: LEFT IMAGE WITH YEAR AND BOOK TITLE ENDS</xsl:comment> -->

			<!-- v1 DELETE IF - only used for interim site 
			<xsl:if test="">
				<div class="unsuccesful_listitems"><p>Thank you for your submission <br /> To add another recollection return to the <a href="http://www.bbc.co.uk/mysciencefictionlife">homepage</a>.</p><br /><br /></div>
			</xsl:if> -->

			<!-- ENCAPSULATED -->
			<div class="unsuccesful_listitems"> 
				<h2 class="firstnoerror" title="Encapsulated. Would you recommend this? why?"><img src="{$imageRoot}images/title_encapsulated.gif" border="0" alt="Encapsulated. Would you recommend this? why?" /></h2>
				<p><xsl:apply-templates select="FORUMTHREADPOSTS/POST/TEXT/RICHPOST/ENCAP" /></p>
			</div>
			

			<!-- TIME AND SPACE -->
			<div class="unsuccesful_listitems"> 
				<h2 title="Time and Space: When and where I first encountered it"><img src="{$imageRoot}images/title_timespacewhenwhere.gif"  alt="Time and Space: When and where I first encountered it" /></h2>
				<p><xsl:apply-templates select="FORUMTHREADPOSTS/POST/TEXT/RICHPOST/TIME" /></p>
			</div>


			<!-- RECOLLECTIONS AND REVELATIONS -->
			<div class="unsuccesful_listitems"> 
				<h2 title="Recollection and revelations"><img src="{$imageRoot}images/title_recollections.gif"  alt="Recollection and revelations" /></h2>
				<p><xsl:apply-templates select="FORUMTHREADPOSTS/POST/TEXT/RICHPOST/REVELATIONS" /></p>
			</div>

			
			<xsl:if test="FORUMTHREADPOSTS/POST/TEXT/RICHPOST/BEFORETITLE != ''">
				<!-- BEFORE THIS -->
				<div class="unsuccesful_listitems"> 
					<h2 title="Before this..."><img src="{$imageRoot}images/title_beforethis2.gif" border="0"  alt="Before this..." /></h2>
					 <h3 class="strong"><xsl:value-of select="FORUMTHREADPOSTS/POST/TEXT/RICHPOST/BEFORETITLE" /></h3>
					 <p><xsl:apply-templates select="FORUMTHREADPOSTS/POST/TEXT/RICHPOST/BEFORETEXT" /></p>
				</div>
			</xsl:if>


			<!-- AFTER THIS -->
			<xsl:if test="/H2G2/FORUMTHREADPOSTS/POST/TEXT/RICHPOST/AFTERTITLE != ''">
				<div class="unsuccesful_listitems"> 
					<h2 title="After this..."><img src="{$imageRoot}images/title_afterthis2.gif" border="0"  alt="After This" /></h2>
					<h3 class="strong"><xsl:value-of select="FORUMTHREADPOSTS/POST/TEXT/RICHPOST/AFTERTITLE" /></h3>
					<p><xsl:apply-templates select="FORUMTHREADPOSTS/POST/TEXT/RICHPOST/AFTERTEXT" /></p>
				</div>
			</xsl:if>
			
			
			<div class="unsuccesful_listitems">

				<!-- FOR ME THIS IS CONNECTED v5

				<xsl:comment> CONNECTED WITH STARTS </xsl:comment>
				<xsl:variable name="optionText">Select a work</xsl:variable>
				<xsl:if test="FORUMTHREADPOSTS/POST/TEXT/RICHPOST/OPTION1 | FORUMTHREADPOSTS/POST/TEXT/RICHPOST/OPTION2 | FORUMTHREADPOSTS/POST/TEXT/RICHPOST/OPTION3 != $optionText">
					<h2 title="For me this is connected with..."><img src="{$imageRoot}images/title_forme.gif" border="0" width="228" height="17" alt="For me this is connected with..." /></h2>
					<ul title="For me this is connected with...">

						<xsl:for-each select="FORUMTHREADPOSTS/POST/TEXT/RICHPOST/OPTION1[. != $optionText] | FORUMTHREADPOSTS/POST/TEXT/RICHPOST/OPTION2[. != $optionText] | 	FORUMTHREADPOSTS/POST/TEXT/RICHPOST/OPTION3[. != $optionText]">

							<xsl:variable name="dnaid"><xsl:value-of select="." /></xsl:variable>
							<li class="strong"><a>
							<xsl:attribute name="href"><xsl:value-of select="$root" />A<xsl:value-of select="$dnaid" /></xsl:attribute><xsl:value-of select="/H2G2/SITECONFIG/ARTICLE_LIST/OPTION[@VALUE = $dnaid]" /></a></li>

						</xsl:for-each>

					</ul>
				</xsl:if>
				
				-->


				<div class="vspace10px"></div>

				<p class="strong">
					<img src="{$imageRoot}images/readeverything.gif" width="43" height="25" alt="" />
					<a>
						<xsl:attribute name="href"><xsl:value-of select="concat('U',FORUMTHREADPOSTS/POST[@INDEX='0']/USER/USERID)" /></xsl:attribute>Read everything by 
						<!-- USERNAME @CV@02 -->
						<!-- <xsl:choose> removeed first lant names TW
							<xsl:when test="FORUMTHREADPOSTS/POST[@INDEX='0']/USER/FIRSTNAMES and FORUMTHREADPOSTS/POST[@INDEX='0']/USER/LASTNAME">
								<xsl:value-of select="concat(FORUMTHREADPOSTS/POST[@INDEX='0']/USER/FIRSTNAMES, ' ', FORUMTHREADPOSTS/POST[@INDEX='0']/USER/LASTNAME)" /> 
							</xsl:when>
							<xsl:otherwise> -->
								<xsl:choose>
			<xsl:when test="FORUMTHREADPOSTS/POST[@INDEX='0']/USER/EDITOR = 1"><span class="editorName"><em><strong><xsl:value-of select="FORUMTHREADPOSTS/POST[@INDEX='0']/USER/USERNAME" /></strong></em></span></xsl:when>
			<xsl:otherwise><xsl:value-of select="FORUMTHREADPOSTS/POST[@INDEX='0']/USER/USERNAME" /></xsl:otherwise>
		</xsl:choose>
		 
							<!-- </xsl:otherwise>
						</xsl:choose> -->
					</a>
				</p>

				<div class="vspace10px"></div>


				<!-- SHOW ALL ENTRIES LINK -->



				<p class="strong">
					<a class="black">
						<xsl:attribute name="href"><xsl:value-of select="concat($root, 'F', FORUMTHREADPOSTS/@FORUMID)" /></xsl:attribute>
						Show all entries about <xsl:value-of select="FORUMSOURCE/ARTICLE/SUBJECT" /><img src="{$imageRoot}images/icon_rightarrow.gif" border="0" width="10" height="7" alt="" />
					</a>
				</p>

				<div class="vspace10px"></div>


			</div>
	


			<!-- SC --><!-- Changed: Only editors have access to link CV 28/02/07 -->
			<xsl:if test="$test_IsEditor">
				<div class="speechbox">
					<p>
						<a>
							<xsl:attribute name="href"><!-- <xsl:value-of select="concat($root, $create_member_article)" /> --><xsl:value-of select="concat($root, 'AddThread?forum=', FORUMTHREADPOSTS/@FORUMID, '&amp;article=', FORUMSOURCE/ARTICLE/ARTICLEINFO/H2G2ID)" /></xsl:attribute>Add an entry</a> of your own		
					</p>
				</div>

				<div class="vspace10px"></div>

			</xsl:if>

				<div class="unsuccesful_listitems"> 
					<div class="vspace10px"></div>
					<!-- <h2 class="firstnoerror">Problem with this entry?</h2> -->
					<xsl:variable name="post_id_complain" select="/H2G2/FORUMTHREADPOSTS/POST/@POSTID"/>
					<p class="alert">Click <a href="UserComplaint?PostID={$post_id_complain}" target="ComplaintPopup" onClick="popupwindow('UserComplaint?PostID={$post_id_complain}', 'ComplaintPopup', 'status=1,resizable=1,scrollbars=1,width=800,height=480')" title="Alert the moderator to this recollection"><img src="{$imageRoot}images/alert_white.gif" alt="Alert the moderator to this recollection" width="15" height="15" /></a> if you see something on this page that breaks the <a href="http://www.bbc.co.uk/mysciencefictionlife/pages/houserules.shtml">house rules</a>.</p>

					<div class="vspace18px"></div>
				</div>
			
			<!-- <xsl:if test="$test_IsEditor"> -->
			<div class="yellowdivider"></div>
			<!-- </xsl:if> -->

			<div class="unsuccesful_listitems"> 
				<div class="vspace14px"></div>
				<a name="allcomments"></a>
				<!-- SC --><!-- Changed image to 'Related Comments' and added conditional statement to only make visible if comments exist. CV 28/02/07 -->
				<xsl:if test="/H2G2/FORUMTHREADPOSTS/@TOTALPOSTCOUNT > 1 or $test_IsEditor">
				<h2 title="Related comments..." class="firstnoerror"><img src="{$imageRoot}images/title_relatedcomments.gif" border="0" alt="Related Comments..." /></h2>
				</xsl:if>

				<xsl:apply-templates select="FORUMTHREADPOSTS" mode="c_multiposts"/>

			</div>

			<!-- SC --><!-- Changed: Only editors have access to link CV 28/02/07 -->
			<xsl:if test="$test_IsEditor">
				<div class="speechbox">
					<p>
						<a><xsl:attribute name="href"><xsl:value-of select="concat($root, 'AddThread?inreplyto=', FORUMTHREADPOSTS/POST[@INDEX='0']/@POSTID)" /></xsl:attribute>Add a comment</a> of your own
					</p>
				</div>
			</xsl:if>
		
			<!-- SC --><!-- ADDED: conditional to test for comments. if comments exist, then show moderation alert. CV 28/02/07 -->
			<xsl:if test="/H2G2/FORUMTHREADPOSTS/@TOTALPOSTCOUNT > 1">
			  <div class="commentkey">Click <img src="{$imageRoot}images/alert_grey.gif" alt="" width="15" height="15" />on a comment that is inappropriate.</div>
			 </xsl:if>

			<xsl:if test="$test_IsEditor">
			  <div class="clear"></div>
				<table border="0" cellspacing="3" cellpadding="5" class="generic-n">
				<tr>
				<td class="generic-n-3">
				<font size="2">
				<h3>For editors only</h3>
						Contact me by email :
						<xsl:choose>
							<xsl:when test="FORUMTHREADPOSTS/POST/TEXT/RICHPOST/EMAILCHECKBOX = 'YES'">YES</xsl:when>
							<xsl:otherwise>NO</xsl:otherwise>
						</xsl:choose>
						<BR />
						<BR />
				</font></td>

				</tr>
				</table>
			</xsl:if>

		</div>

	</xsl:template>


	<xsl:variable name="mpsplit" select="5"/>
	<!-- 
	<xsl:template match="FORUMTHREADPOSTS" mode="r_postblocks">
	Use: Container for the complete list of post blocks
	-->
	
	<xsl:template match="FORUMTHREADPOSTS" mode="r_postblocks">
		<!-- <xsl:apply-templates select="." mode="c_blockdisplayprev"/> -->
		<xsl:apply-templates select="." mode="c_blockdisplay"/>
		<!-- <xsl:apply-templates select="." mode="c_blockdisplaynext"/> -->
	</xsl:template>
	<!-- 
	<xsl:template match="FORUMTHREADPOSTS" mode="r_blockdisplayprev">
	Use: Presentation of previous link
	-->
	<xsl:template match="FORUMTHREADPOSTS" mode="r_blockdisplayprev">
		<xsl:apply-imports/>
	</xsl:template>
	<!-- 
	<xsl:template match="FORUMTHREADPOSTS" mode="r_blockdisplaynext">
	Use: Presentation of next link
	-->
	<xsl:template match="FORUMTHREADPOSTS" mode="r_blockdisplaynext">
		<xsl:apply-imports/>
	</xsl:template>
	<!-- 
	<xsl:template match="FORUMTHREADS" mode="on_blockdisplay">
	Use: Controls the display of the block (outside the link) which is currently appearing on the page
	-->
	<xsl:template match="FORUMTHREADPOSTS" mode="on_blockdisplay">
		<xsl:param name="url"/>
		<xsl:copy-of select="$url"/>
	</xsl:template>
	
	<!-- 
	<xsl:template name="t_ontabcontent">
	Use: Controls the content of the link for the currently visible page
	-->
	<xsl:template name="t_ontabcontent">
		<xsl:param name="range"/>
		<xsl:param name="pagenumber"/>
		 <xsl:value-of select="$pagenumber"/>
	</xsl:template>
	<!-- 
	<xsl:template match="FORUMTHREADS" mode="off_blockdisplay">
	Use: Controls the display of the block (outside the link) which is not currently on the page
	-->
	<xsl:template match="FORUMTHREADPOSTS" mode="off_blockdisplay">
		<xsl:param name="url"/>
		<xsl:copy-of select="$url"/>
	</xsl:template>
	<!-- 
	<xsl:template name="t_offtabcontent">
	Use: Controls the content of the link for other pages in the currently visible range
	-->
	<xsl:template name="t_offtabcontent">
		<xsl:param name="range"/>
		<xsl:param name="pagenumber"/>
		<xsl:value-of select="$pagenumber"/>
	</xsl:template>

	<xsl:attribute-set name="mFORUMTHREADPOSTS_on_blockdisplay">
		<xsl:attribute name="class">next-back-on</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="mFORUMTHREADPOSTS_off_blockdisplay">
		<xsl:attribute name="class">next-back-off</xsl:attribute>
	</xsl:attribute-set>



	<!-- 
	<xsl:template match="FORUMTHREADPOSTS" mode="off_postblock">
	Use: Display of non-current post block  - eg 'show posts 21-40'
		  The range parameter must be present to show the numeric value of the posts
		  It is common to also include a test - for example add a br tag after every 5th post block - 
		  this test must be replicated in m_postblockoff
	-->
	<!--xsl:template match="FORUMTHREADPOSTS" mode="off_postblock">
		<xsl:param name="range"/>
		<xsl:param name="currentpost" select="substring-before($range, ' ')"/>
		<xsl:if test="$currentpost mod 100 = 1">
			
		</xsl:if>
		<xsl:value-of select="concat($alt_show, ' ', $range)"/>
		<br/>
	</xsl:template-->
	<!-- 
	<xsl:template match="FORUMTHREADPOSTS" mode="on_postblock">
	Use: Display of current post block  - eg 'now showing posts 21-40'
		  The range parameter must be present to show the numeric value of the post you are on
		  Use the same test as in m_postblockoff
	-->
	<!--xsl:template match="FORUMTHREADPOSTS" mode="on_postblock">
		<xsl:param name="range"/>
		<xsl:param name="currentpost" select="substring-before($range, ' ')"/>
		<xsl:if test="$currentpost mod 100 = 1">
			
		</xsl:if>
		<xsl:value-of select="concat($alt_nowshowing, ' ', $range)"/>
		<br/>
	</xsl:template-->
	<!--
	<xsl:template match="FORUMTHREADPOSTS" mode="r_subcribemultiposts">
	Use: Presentation of subscribe / unsubscribe button 
	 -->
	<xsl:template match="FORUMTHREADPOSTS" mode="r_subcribemultiposts">
	<xsl:if test="$registered=1">
		<xsl:copy-of select="$arrow.right" />
	</xsl:if>
	<xsl:apply-imports/>
	</xsl:template>
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
						FORUMTHREADPOSTS Object
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<!-- 
	<xsl:template match="FORUMTHREADPOSTS" mode="r_multiposts">
	Use: Logical container for the list of posts
	-->
	<xsl:template match="FORUMTHREADPOSTS" mode="r_multiposts">
		
		<xsl:variable name="commentCount"><xsl:value-of select="count(POST[@HIDDEN='0'])" /></xsl:variable>

		<xsl:for-each select="POST[@HIDDEN='0']">
			<xsl:sort order="descending" select="position()" />
			
			<xsl:choose>
					<xsl:when test="@INDEX='0'"></xsl:when>
					<!-- TW added s_view param to show all comments, ugly hach as i'm duplicating code in these next two WHEN conditions -->
					<xsl:when test="/H2G2/PARAMS/PARAM/NAME = 's_view'">
						<!--  COMMENT UNIT STARTS  -->
						<p class="paddingtop8px"><span class="paddingleft10px"><xsl:apply-templates select="." mode="t_postbodymp"/></span></p>
						<div class="commentgreybox">
							<div class="commentdate">
								Added
								<xsl:value-of select="concat(DATEPOSTED/DATE/@DAY, '/', DATEPOSTED/DATE/@MONTH, '/', DATEPOSTED/DATE/@YEAR)" />
							</div>
							<div class="commentauthor">Comment from <xsl:apply-templates select="USER/USERNAME" mode="c_multiposts"/></div>

							<!-- new - alert icon added 7 Nov 2006 TW -->
							<div class="commentalert"><a href="UserComplaint?PostID={@POSTID}" target="ComplaintPopup" onClick="popupwindow('UserComplaint?PostID={@POSTID}', 'ComplaintPopup', 'status=1,resizable=1,scrollbars=1,width=640,height=480')" title="Alert the moderator to this comment"><img src="{$imageRoot}images/alert_grey.gif" alt="Alert the moderator to this comment" width="15" height="15" /></a></div>
							<!-- end new alert icon TW -->

							<div class="clear"></div>

						</div>
						<!--  COMMENT UNIT ENDS  -->
						<div class="vspace14px"></div>
					</xsl:when>
					<xsl:when test="position() &lt; 4">
					
						<!--  COMMENT UNIT STARTS  -->
						<p class="paddingtop8px"><span class="paddingleft10px"><xsl:apply-templates select="." mode="t_postbodymp"/></span></p>
						<div class="commentgreybox">
							<div class="commentdate">
								Added
								<xsl:value-of select="concat(DATEPOSTED/DATE/@DAY, '/', DATEPOSTED/DATE/@MONTH, '/', DATEPOSTED/DATE/@YEAR)" />
							</div>
							<div class="commentauthor">Comment from <xsl:apply-templates select="USER/USERNAME" mode="c_multiposts"/></div>

							<!-- new - alert icon added 7 Nov 2006 TW -->
						<div class="commentalert"><a href="UserComplaint?PostID={@POSTID}" target="ComplaintPopup" onClick="popupwindow('UserComplaint?PostID={@POSTID}', 'ComplaintPopup', 'status=1,resizable=1,scrollbars=1,width=640,height=480')" title="Alert the moderator to this comment"><img src="{$imageRoot}images/alert_grey.gif" alt="Alert the moderator to this comment" width="15" height="15" /></a></div>
							<!-- end new alert icon TW -->


							<div class="clear"></div>

						</div>
						<!--  COMMENT UNIT ENDS  -->
						<div class="vspace14px"></div>
						
						</xsl:when>
					
					<xsl:otherwise></xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>

		<xsl:if test="$commentCount &gt; 3">
			<xsl:choose>
				<xsl:when test="/H2G2/PARAMS/PARAM/NAME = 's_view'">		
				</xsl:when>
				<xsl:otherwise>
				<div class="vspace14px"></div>
				<div class="paddingleft10px"><p class="strong"><a class="black"><xsl:attribute name="href"><xsl:value-of select="concat($root, 'F', /H2G2/FORUMTHREADPOSTS/@FORUMID)" /><xsl:value-of select="concat('?thread=', /H2G2/FORUMTHREADPOSTS/@THREADID)" />&amp;s_view=1#allcomments</xsl:attribute>View all comments<img  src="{$imageRoot}images/icon_rightarrow.gif" border="0" width="10" height="7" alt="" /></a></p></div>
				<div class="vspace10px"></div></xsl:otherwise>
			</xsl:choose>
		</xsl:if>

	</xsl:template>



	<!-- 
	<xsl:template match="POST" mode="r_multiposts">
	Use: Presentation of a single post
	-->
	<xsl:template match="POST" mode="r_multiposts">
	<xsl:apply-templates select="@POSTID" mode="t_createanchor"/>

		<!-- POST TITLE	 -->

		<!-- 		<div class="multi-title">
					<table cellpadding="0" cellspacing="0" border="0" width="390">
					<tr><td>
					<xsl:element name="{$text.base}" use-attribute-sets="text.base">
					<strong><xsl:apply-templates select="." mode="t_postsubjectmp"/></strong>
					</xsl:element>
					</td><td align="right">
					<xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall">
					<span class="orange"><span class="bold">post <xsl:apply-templates select="." mode="t_postnumber"/></span></span>
					</xsl:element>	
					</td></tr></table>
				</div>

				<div class="posted-by">
				<xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall">
				<xsl:if test="@HIDDEN='0'">
		 -->		<!-- POST INFO -->
		<!-- 		<xsl:copy-of select="$m_posted"/>
				<xsl:apply-templates select="USER/USERNAME" mode="c_multiposts"/>&nbsp; 
				<xsl:apply-templates select="USER" mode="c_onlineflagmp"/>&nbsp; 
				<xsl:apply-templates select="DATEPOSTED/DATE" mode="t_postdatemp"/>
				<xsl:apply-templates select="." mode="c_gadgetmp"/>
				</xsl:if>
				</xsl:element>
				</div>
		 -->		<!-- POST BODY -->
		<!-- 		<xsl:element name="{$text.base}" use-attribute-sets="text.base"><xsl:apply-templates select="." mode="t_postbodymp"/></xsl:element>
				
				<div class="add-comment">
				<table cellpadding="0" cellspacing="0" width="390" border="0"><tr>
				<td valign="top">
		 -->		<!-- REPLY OR ADD COMMENT -->
		<!-- 	 <xsl:copy-of select="$arrow.right" /><xsl:apply-templates select="@POSTID" mode="c_replytopost"/>  -->
				
				<!-- COMPLAIN ABOUT THIS POST -->
		<!-- 		<xsl:apply-templates select="@HIDDEN" mode="c_complainmp"/></td>
				</tr></table>
				</div>
		 -->				
				<!-- EDIT AND MODERATION HISTORY -->
				
		<!-- 		<xsl:if test="$test_IsEditor">
				<div align="right"><img src="{$imagesource}icons/white/icon_edit.gif" alt="" width="17" height="17" border="0"/>&nbsp;
				<xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall">
				<xsl:apply-templates select="@POSTID" mode="c_editmp"/>
				<xsl:text>  </xsl:text> | <xsl:text>  </xsl:text>
				<xsl:apply-templates select="@POSTID" mode="c_linktomoderate"/>
				</xsl:element>
				</div>
				</xsl:if>
		 -->			
				<!-- 
				or read first reply
				<xsl:if test="@FIRSTCHILD"> / </xsl:if>
				<xsl:apply-templates select="@FIRSTCHILD" mode="c_multiposts"/> -->
				
			
			
		<!-- 	in reply to	<xsl:if test="@INREPLYTO">
					(<xsl:apply-templates select="@INREPLYTO" mode="c_multiposts"/>)
				</xsl:if> -->
			
				
		<!-- 		<xsl:apply-templates select="@PREVINDEX" mode="c_multiposts"/>
				<xsl:if test="@PREVINDEX and @NEXTINDEX"> | </xsl:if>
				<xsl:apply-templates select="@NEXTINDEX" mode="c_multiposts"/> -->
			

	</xsl:template>
		<!--
	<xsl:template match="POST" mode="t_postsubjectmp">
	Author:		Tom Whitehouse
	Context:      /H2G2/FORUMTHREADPOSTS/POST
	Purpose:	 Creates the SUBJECT text 
	-->
	<xsl:template match="POST" mode="t_postsubjectmp">
		<xsl:choose>
			<xsl:when test="@HIDDEN = 1">
				<xsl:copy-of select="$m_postsubjectremoved"/>
			</xsl:when>
			<xsl:when test="@HIDDEN = 2">
				<xsl:copy-of select="$m_awaitingmoderationsubject"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="SUBJECT"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- 
	<xsl:template match="@NEXTINDEX" mode="r_multiposts">
	Use: Presentation of the 'next posting' link
	-->
	<xsl:template match="@NEXTINDEX" mode="r_multiposts">
		<xsl:apply-imports/>
	</xsl:template>
	<!-- 
	<xsl:template match="@PREVINDEX" mode="r_multiposts">
	Use: Presentation of the 'previous posting' link
	-->
	<xsl:template match="@PREVINDEX" mode="r_multiposts">
		<xsl:apply-imports/>
	</xsl:template>
	<!--
	<xsl:template match="USERNAME" mode="r_multiposts">
	Use: Presentation if the user name is to be displayed
	 -->
	<xsl:template match="USERNAME" mode="r_multiposts">
		<xsl:apply-imports/>
	</xsl:template>
	
	<!--
	<xsl:template match="USERNAME">
	Context:    checks for EDITOR
	Generic:	Yes
	Purpose:	Displays a username (in bold/italic if necessary)
	-->
	<xsl:template match="USERNAME">
	<xsl:choose>
	<xsl:when test="../EDITOR = 1">
		<span class="editorName"><em><strong><xsl:apply-templates/></strong></em></span>
	</xsl:when>
	<xsl:otherwise>
		<xsl:apply-templates/>
	</xsl:otherwise>
	</xsl:choose>
	</xsl:template>
	<!--
	<xsl:template match="USER" mode="r_onlineflagmp">
	Use: Presentation of the flag to display if a user is online or not
	 -->
	<xsl:template match="USER" mode="r_onlineflagmp">
		<xsl:copy-of select="$m_useronlineflagmp"/>
	</xsl:template>
	<!--
	<xsl:template match="@INREPLYTO" mode="r_multiposts">
	Use: Presentation of the 'this is a reply tothis post' link
	 -->
	<xsl:template match="@INREPLYTO" mode="r_multiposts">
		<xsl:value-of select="$m_inreplyto"/>
		<xsl:apply-imports/>
	</xsl:template>
	<!--
	<xsl:template match="POST" mode="r_gadgetmp">
	Use: Presentation of gadget container
	 -->
	<xsl:template match="POST" mode="r_gadgetmp">
		<xsl:apply-imports/>
	</xsl:template>
	<!--
	<xsl:template match="@FIRSTCHILD" mode="r_multiposts">
	Use: Presentation if the 'first reply to this'
	 -->
	<xsl:template match="@FIRSTCHILD" mode="r_multiposts">
		<xsl:value-of select="$m_readthe"/>
		<xsl:apply-imports/>
	</xsl:template>
	<!-- 
	<xsl:template match="@POSTID" mode="r_linktomoderate">
	use: Moderation link. Will appear only if editor or moderator.
	-->
	<xsl:template match="@POSTID" mode="r_linktomoderate">
		<xsl:apply-imports/>
	</xsl:template>
	<!-- 
	<xsl:template match="@HIDDEN" mode="r_complainmp">
	use: alert our moderation team link
	-->
	<xsl:template match="@HIDDEN" mode="r_complainmp">
		<xsl:apply-imports/>
	</xsl:template>
	<!-- 
	<xsl:template match="@POSTID" mode="r_editmp">
	use: editors or moderators can edit a post
	-->
	<xsl:template match="@POSTID" mode="r_editmp">
		<xsl:apply-imports/>
	</xsl:template>
	<!-- 
	<xsl:template match="@POSTID" mode="r_replytopost">
	use: 'reply to this post' link
	-->
	<xsl:template match="@POSTID" mode="r_replytopost">
		<xsl:apply-imports/>
	</xsl:template>
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
								Prev / Next threads
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<!-- 
	<xsl:template match="FORUMTHREADS" mode="r_otherthreads">
	use: inserts links to the previous and next threads
	-->
	<xsl:template match="FORUMTHREADS" mode="r_otherthreads">
		<xsl:apply-templates select="/H2G2/FORUMTHREADS/THREAD[@FORUMID=/H2G2/FORUMTHREADPOSTS/@FORUMID and @THREADID = /H2G2/FORUMTHREADPOSTS/@THREADID]/preceding-sibling::THREAD[1]" mode="c_previous"/>
		<xsl:apply-templates select="/H2G2/FORUMTHREADS/THREAD[@FORUMID=/H2G2/FORUMTHREADPOSTS/@FORUMID and @THREADID = /H2G2/FORUMTHREADPOSTS/@THREADID]/following-sibling::THREAD[1]" mode="c_next"/>
	</xsl:template>
	<!-- 
	<xsl:template match="THREAD" mode="r_previous">
	use: presentation of the previous link
	-->
	<xsl:template match="THREAD" mode="r_previous">
		Last Thread: <xsl:apply-imports/>
		<br/>
	</xsl:template>
	<!-- 
	<xsl:template match="THREAD" mode="r_next">
	use: presentation of the next link
	-->
	<xsl:template match="THREAD" mode="r_next">
		Next Thread: <xsl:apply-imports/>
		<br/>
	</xsl:template>
	<!-- 
	<xsl:template match="THREAD" mode="PreviousThread">
	use: inserts link to the previous thread
	-->
	<xsl:template match="THREAD" mode="PreviousThread">
		Last Thread: <xsl:apply-imports/>
		<br/>
	</xsl:template>
	<!-- 
	<xsl:template match="THREAD" mode="NextThread">
	use: inserts link to the next thread
	-->
	<xsl:template match="THREAD" mode="NextThread">
		Next Thread: <xsl:apply-imports/>
		<br/>
	</xsl:template>
	<!-- 
	<xsl:template match="@SKIPTO" mode="navbuttons">
	use: html containing the beginning / next / prev / latest buttons
	-->
	<xsl:template match="@SKIPTO" mode="r_navbuttons">
	
	<!-- DEFINE PAGE NUMBER -->
	<xsl:variable name="pagenumber">
		<xsl:choose>
		<xsl:when test=".='0'">
		 1
		</xsl:when>
		<xsl:when test=".='20'">
		 2
		</xsl:when>
		<xsl:otherwise>
		<xsl:value-of select="round(. div 20 + 1)" /><!-- TODO -->
		</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<!-- DEFINE NUMBER OF PAGES-->
	<xsl:variable name="pagetotal">
    <xsl:value-of select="ceiling(/H2G2/FORUMTHREADPOSTS/@TOTALPOSTCOUNT div 20)" />
	</xsl:variable>
	<!-- TODO not in design (<xsl:value-of select="/H2G2/FORUMTHREADPOSTS/@TOTALPOSTCOUNT" /> posts) -->
	
		<div class="next-back">
			<xsl:element name="{$text.base}" use-attribute-sets="text.base"><!-- totalposts -->
			page <xsl:value-of select="$pagenumber" /> of <xsl:value-of select="$pagetotal" />
			</xsl:element><br />
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
			<td><xsl:element name="{$text.base}" use-attribute-sets="text.base"><xsl:copy-of select="$arrow.first" />&nbsp;<xsl:apply-templates select="." mode="c_gotobeginning"/> | <xsl:copy-of select="$arrow.previous" />&nbsp;<xsl:apply-templates select="." mode="c_gotoprevious"/> </xsl:element></td>
			<td align="center" class="next-back"><xsl:element name="{$text.base}" use-attribute-sets="text.base"><xsl:apply-templates select="/H2G2/FORUMTHREADPOSTS" mode="c_postblocks"/></xsl:element></td>
			<td align="right"><xsl:element name="{$text.base}" use-attribute-sets="text.base"><xsl:apply-templates select="." mode="c_gotonext"/>&nbsp;<xsl:copy-of select="$arrow.next" /> | <xsl:apply-templates select="." mode="c_gotolatest"/>&nbsp;<xsl:copy-of select="$arrow.latest" /></xsl:element></td>
			</tr>
			</table>
		</div>
		
	</xsl:template>
	<!-- 
	<xsl:template match="@SKIPTO" mode="r_gotobeginning">
	use: Skip to the beginning of the conversation embodiment
	-->
	<xsl:template match="@SKIPTO" mode="link_gotobeginning">
		<xsl:apply-imports/>
	</xsl:template>
	<!--
	<xsl:template match="@SKIPTO" mode="link_gotoprevious">
	Author:		Tom Whitehouse
	Context:      /H2G2/FORUMTHREADPOSTS/@SKIPTO
	Purpose:	 Creates 'previous' link
	-->
	<xsl:template match="@SKIPTO" mode="link_gotoprevious">
		<a href="{$root}F{../@FORUMID}?thread={../@THREADID}&amp;skip={(.) - (../@COUNT)}&amp;show={../@COUNT}" xsl:use-attribute-sets="maSKIPTO_link_gotoprevious">
			<xsl:value-of select="$alt_showprevious"/>
		</a>
	</xsl:template>
	
	<!--
	<xsl:template match="@SKIPTO" mode="link_gotonext">
	Author:		Tom Whitehouse
	Context:      /H2G2/FORUMTHREADPOSTS/@SKIPTO
	Purpose:	 Creates the 'next' link
	-->
	<xsl:template match="@SKIPTO" mode="link_gotonext">
		<a href="{$root}F{../@FORUMID}?thread={../@THREADID}&amp;skip={(.) + (../@COUNT)}&amp;show={../@COUNT}" xsl:use-attribute-sets="maSKIPTO_link_gotonext">
			<xsl:value-of select="$alt_shownext"/>
		</a>
	</xsl:template>
	
	<!-- 
	<xsl:template match="@SKIPTO" mode="r_gotolatest">
	use: Skip to the end of the conversation embodiment
	-->
	<xsl:template match="@SKIPTO" mode="link_gotolatest">
		<xsl:apply-imports/>
	</xsl:template>
	<!-- 
	<xsl:template match="@SKIPTO" mode="r_gotobeginning">
	use: Skip to the beginning of the conversation embodiment
	-->
	<xsl:template match="@SKIPTO" mode="text_gotobeginning">
		<xsl:apply-imports/>
	</xsl:template>
	<!-- 
	<xsl:template match="@SKIPTO" mode="r_gotoprevious">
	use: Skip to the previous page of the conversation embodiment
	-->
	<xsl:template match="@SKIPTO" mode="text_gotoprevious">
		<xsl:apply-imports/>
	</xsl:template>
	<!-- 
	<xsl:template match="@SKIPTO" mode="r_gotonext">
	use: Skip to the next page of the conversation embodiment
	-->
	<xsl:template match="@SKIPTO" mode="text_gotonext">
		<xsl:apply-imports/>
	</xsl:template>
	<!-- 
	<xsl:template match="@SKIPTO" mode="r_gotolatest">
	use: Skip to the end of the conversation embodiment
	-->
	<xsl:template match="@SKIPTO" mode="text_gotolatest">
		<xsl:apply-imports/>
	</xsl:template>

</xsl:stylesheet>