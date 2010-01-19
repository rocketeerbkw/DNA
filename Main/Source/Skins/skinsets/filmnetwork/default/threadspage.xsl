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
	<xsl:with-param name="message">THREADS_MAINBODY<xsl:value-of select="$current_article_type" /></xsl:with-param>
	<xsl:with-param name="pagename">threadspage.xsl</xsl:with-param>
	</xsl:call-template>
	<!-- DEBUG -->
	
	<xsl:choose>		
		<xsl:when test="/H2G2/PARAMS/PARAM[NAME='s_alertsRefresh']/VALUE">
			<table class="confirmBox confirmBoxMargin">
				<tr>
					<td>						
						<div class="biogname"><strong>processing</strong></div>
					</td>
				</tr>
				<tr>
					<td>
						<xsl:choose>
							<xsl:when test="/H2G2/EMAIL-SUBSCRIPTION/SUBSCRIPTION">
								<p>please wait while we take you to your email alerts management page</p>
								<p>if nothing happens after a few seconds, please click <a href="{$root}AlertGroups">here</a></p>
							</xsl:when>
							<xsl:otherwise>
								<p>please wait while we subscribe you to this forum</p>
								<p>if nothing happens after a few seconds, please click <a
									href="{$root}alertgroups?cmd=add&amp;itemid={/H2G2/SUBSCRIBE-STATE/@THREADID}&amp;itemtype=5&amp;s_view=confirm&amp;s_origin=message">here</a></p>
							</xsl:otherwise>
						</xsl:choose>
					</td>
				</tr>
			</table>
			<img src="http://www.bbc.co.uk/filmnetwork/images/furniture/writemessage/topboxangle.gif"
				width="635" height="27" />
		</xsl:when>
		<xsl:otherwise>
		
	<table border="0" cellspacing="0" cellpadding="0" width="635">
        <tr> 
          <td height="10">
		  <!-- crumb menu -->
		  <div class="crumbtop"><span class="textmedium">
<xsl:choose>

	<xsl:when test="/H2G2/VIEWING-USER/USER/USERID = /H2G2/FORUMSOURCE/ARTICLE/ARTICLEINFO/PAGEAUTHOR/EDITOR/USER/USERID">
		<a><xsl:attribute name="href"><xsl:value-of select="concat($root,'U',VIEWING-USER/USER/USERID)" /></xsl:attribute><strong>my profile</strong></a>
	</xsl:when>
	<xsl:otherwise>
		<a><xsl:attribute name="href"><xsl:value-of select="concat($root,'U',/H2G2/FORUMSOURCE/ARTICLE/ARTICLEINFO/PAGEAUTHOR/EDITOR/USER/USERID)" /></xsl:attribute>
		<strong>
		<xsl:choose>
			<xsl:when test="string-length(/H2G2/FORUMSOURCE/ARTICLE/ARTICLEINFO/PAGEAUTHOR/EDITOR/USER/FIRSTNAMES) &gt; 0">
				<xsl:value-of select="/H2G2/FORUMSOURCE/ARTICLE/ARTICLEINFO/PAGEAUTHOR/EDITOR/USER/FIRSTNAMES" />&nbsp;
				<xsl:value-of select="/H2G2/FORUMSOURCE/ARTICLE/ARTICLEINFO/PAGEAUTHOR/EDITOR/USER/LASTNAME" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="/H2G2/FORUMSOURCE/ARTICLE/ARTICLEINFO/PAGEAUTHOR/EDITOR/USER/USERNAME" />
			</xsl:otherwise>
		</xsl:choose>'s profile
		</strong>
		</a>
	</xsl:otherwise>
	</xsl:choose> |</span> <span class="textxlarge"><xsl:choose>
		<xsl:when test="/H2G2/VIEWING-USER/USER/USERID = /H2G2/FORUMSOURCE/ARTICLE/ARTICLEINFO/PAGEAUTHOR/EDITOR/USER/USERID">
	all my messages
	</xsl:when>
		<xsl:otherwise>
		all messages
		</xsl:otherwise>
	</xsl:choose></span></div>
		  <!-- END crumb menu --></td>
        </tr>
      </table>
<!-- 19px Spacer table -->
<table border="0" cellspacing="0" cellpadding="0" width="635">
	<tr>
		<td height="5"></td>
	</tr>
</table>
<!-- END 19px Spacer table -->	 





	<table width="635" border="0" cellspacing="0" cellpadding="0">
		  <!-- Spacer row -->
          <tr>
            <td><img src="/f/t.gif" width="371" height="1" class="tiny" alt="" /></td>
            <td><img src="/f/t.gif" width="20" height="1" class="tiny" alt="" /></td>
            <td><img src="/f/t.gif" width="244" height="1" class="tiny" alt="" /></td>
          </tr>
		  <tr>
            <td valign="top"  width="371">
			
			<table width="371" cellpadding="0" cellspacing="0" border="0">
			
				<tr>
					<td valign="top" class="topbg" height="69">
					<!-- <img src="/f/t.gif" width="1" height="10" alt="" /> -->
					
				<!-- <xsl:choose>
					<xsl:when test="string-length(/H2G2/SEARCH/SEARCHRESULTS/SAFESEARCHTERM) &gt; 0">
						<div class="whattodotitle"><strong>all my messages </strong></div>
						 <div class="biogname"><strong><xsl:value-of select="/H2G2/SEARCH/SEARCHRESULTS/SAFESEARCHTERM"/></strong></div>
					</xsl:when>
					<xsl:otherwise>
						<div class="whattodotitle"><strong>all my messages </strong></div>
					</xsl:otherwise>
				</xsl:choose> -->
			<div class="biogname"><strong><xsl:choose>
		<xsl:when test="/H2G2/VIEWING-USER/USER/USERID = /H2G2/FORUMSOURCE/ARTICLE/ARTICLEINFO/PAGEAUTHOR/EDITOR/USER/USERID">
	all my messages
	</xsl:when>
		<xsl:otherwise>
		all messages
		</xsl:otherwise>
	</xsl:choose></strong></div>
					<!-- <div class="topboxcopy">mi. Proin porta arcu sclerisque lectus</div> --></td>
				</tr>
				<!-- <tr>
		          <td valign="top" height="20" class="topbg"></td>
				</tr> -->
			</table>
			</td>
          	<td valign="top" width="20" class="topbg"></td>
            <td valign="top" class="topbg">
			</td>
          </tr>
		  <tr>
          <td width="635" valign="top" colspan="3"><img src="{$imagesource}furniture/writemessage/topboxangle.gif" width="635" height="27" /></td>
		  </tr>
        </table>
	<!-- spacer -->
	<table width="635" border="0" cellspacing="0" cellpadding="0">
	  <tr>
		<td height="10"></td>
	  </tr>
	</table>
	<!-- end spacer -->
	<!-- END head section -->













		<!-- Most Watched and Submit -->
	    <table width="635" border="0" cellspacing="0" cellpadding="0">
		  <!-- Spacer row -->
          <tr>
            <td><img src="/f/t.gif" width="371" height="1" class="tiny" alt="" /></td>
            <td><img src="/f/t.gif" width="20" height="1" class="tiny" alt="" /></td>
            <td><img src="/f/t.gif" width="244" height="1" class="tiny" alt="" /></td>
          </tr>
		  <tr>
            
          <td valign="top">

<xsl:call-template name="NEXT_BACK" />





<xsl:apply-templates select="FORUMTHREADS" mode="c_threadspage"/>
<!-- <xsl:apply-templates select="FORUMTHREADPOSTS" mode="c_threadblocks"/> -->

<table border="0" cellspacing="0" cellpadding="0" width="371">
	<tr>
		<td height="8"></td>
	</tr>
</table>
<xsl:call-template name="NEXT_BACK" />



<xsl:choose>
<xsl:when test="/H2G2/VIEWING-USER/USER/USERID = /H2G2/FORUMSOURCE/ARTICLE/ARTICLEINFO/PAGEAUTHOR/EDITOR/USER/USERID">
	<div class="finalsubmit"><a onmouseover="swapImage('backprofile', '{$imagesource}furniture/backprofile2.gif')" onmouseout="swapImage('backprofile', '{$imagesource}furniture/backprofile1.gif')"><xsl:attribute name="href">
	<xsl:choose>
	<xsl:when test="PAGEUI/MYHOME[@VISIBLE=1]">
	<xsl:value-of select="concat($root,'U',VIEWING-USER/USER/USERID)" />
	</xsl:when>
	<xsl:otherwise><xsl:value-of select="$sso_signinlink" /></xsl:otherwise>
	</xsl:choose>
	</xsl:attribute><img src="{$imagesource}furniture/backprofile1.gif" width="286" height="22" name="backprofile" alt="back to my profile" /></a></div>
</xsl:when>
<xsl:otherwise>
	<div class="textmedium"><strong><a><xsl:attribute name="href"><xsl:value-of select="concat($root,'U',/H2G2/FORUMSOURCE/ARTICLE/ARTICLEINFO/PAGEAUTHOR/EDITOR/USER/USERID)" /></xsl:attribute>back to <xsl:choose>
		<xsl:when test="string-length(/H2G2/FORUMSOURCE/ARTICLE/ARTICLEINFO/PAGEAUTHOR/EDITOR/USER/FIRSTNAMES) &gt; 0">
			<xsl:value-of select="/H2G2/FORUMSOURCE/ARTICLE/ARTICLEINFO/PAGEAUTHOR/EDITOR/USER/FIRSTNAMES" />&nbsp;
			<xsl:value-of select="/H2G2/FORUMSOURCE/ARTICLE/ARTICLEINFO/PAGEAUTHOR/EDITOR/USER/LASTNAME" />		
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="/H2G2/FORUMSOURCE/ARTICLE/ARTICLEINFO/PAGEAUTHOR/EDITOR/USER/USERNAME" />
		</xsl:otherwise>
	</xsl:choose>'s profile</a></strong>&nbsp;<img src="{$imagesource}furniture/myprofile/arrowdark.gif" width="4" height="7" alt="" /><br /><br /></div>
</xsl:otherwise>
</xsl:choose>

 </td>
            <td><!-- 20px spacer column --></td>
            <td valign="top">			
			
			<!-- END other discussion topics content -->
			<!-- END other discussion topics all -->
			<!-- key with 1 elements -->
			<table width="244" border="0" cellspacing="0" cellpadding="0"  class="quotepanelbg">
			  <tr> 
				<td rowspan="2" width="22"></td>
				<td width="30" valign="top"><div class="textmedium" style="margin:0px 0px 0px 0px; padding:16px 0px 18px 0px; border:0px;"><strong>key</strong></div></td>
				<td width="192" valign="top"></td>
			  </tr>
			  <tr>
				<td width="30" valign="top"><img src="{$imagesource}furniture/keyalert.gif" width="17" height="16" alt="{$alert_moderatortext}" /></td>
				<td valign="top"><div class="textsmall" style="margin:0px 0px 0px 0px; padding:2px 0px 15px 0px; border:0px;"><xsl:value-of select="$alert_moderatortext" /></div></td>
			  </tr>
			</table>
			<!-- end key -->
			<!-- END RIGHT COL TOP SECTION-->
			  
			</td>
          </tr>
        </table>

		</xsl:otherwise>
	</xsl:choose>
	</xsl:template>

<!-- next back -->
	<xsl:template name="NEXT_BACK">
	<!-- previous / page x of x / next table -->
		<table width="371" border="0" cellspacing="0" cellpadding="0">
		  <tr>
			<td width="371" height="2"><img src="{$imagesource}furniture/blackrule.gif" width="371" height="2" alt="" class="tiny" /></td>
		  </tr>
		  <tr>
			<td height="8"></td>
		  </tr>
		  <tr>
			<td width="371" valign="top">
			  <table width="371" border="0" cellspacing="0" cellpadding="0">
				<tr>
				  <td width="145"><div class="textmedium"><strong><xsl:copy-of select="$arrow.first" />&nbsp;<xsl:apply-templates select="FORUMTHREADS" mode="c_firstpage"/>&nbsp;|&nbsp;<xsl:copy-of select="$arrow.previous" />&nbsp;<xsl:apply-templates select="FORUMTHREADS" mode="c_previouspage"/></strong></div></td>
				  <td align="center" width="96"><div class="textmedium"><strong>page <xsl:apply-templates select="FORUMTHREADS" mode="c_threadblocks"/></strong></div></td>
				  <td align="right" width="130"><div class="textmedium"><strong><xsl:apply-templates select="FORUMTHREADS" mode="c_nextpage"/>&nbsp;<xsl:copy-of select="$arrow.next" />&nbsp;|&nbsp;<xsl:apply-templates select="FORUMTHREADS" mode="c_lastpage"/>&nbsp;<xsl:copy-of select="$arrow.latest" /></strong></div></td>
				</tr>
			  </table></td>
		  </tr>
		  <tr>
			<td width="371" height="18"><img src="{$imagesource}furniture/blackrule.gif" width="371" height="2" alt="" class="tiny" /></td>
		  </tr>
		</table>
		<!-- END previous / page x of x / next table -->

	</xsl:template>


<!-- headings -->
		<!--
	<xsl:template name="THREADS_SUBJECT">
	Author:		Tom Whitehouse
	Context:      H2G2
	Purpose:	 Creates the text for the subject
	-->
	<xsl:template name="THREADS_SUBJECT">
	<xsl:if test="not(FORUMSOURCE/@TYPE='userpage')">
	<div class="banner3">
	<table width="398" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td valign="top">
		<img src="{$imagesource}furniture/talk/pic_talk.gif" alt="Conversation" width="205" height="153" border="0"/>
		</td>
		<td valign="top">
		<div class="MainPromo2">
		
			<xsl:choose>
			<xsl:when test="FORUMSOURCE/@TYPE='journal'">
			
			<xsl:element name="{$text.base}" use-attribute-sets="text.base">
			<span class="heading2">THIS CONVERSATION IS RELATED TO</span> <br/>
			</xsl:element>
			<div class="heading3">
			<xsl:element name="{$text.headinglarge}" use-attribute-sets="text.headinglarge">
			<xsl:apply-templates select="FORUMSOURCE" mode="journal_forumsource"/></xsl:element><br/>
			<xsl:element name="{$text.base}" use-attribute-sets="text.base">in <xsl:value-of select="$forumsubtype" /> section</xsl:element>
			</div>
			
			</xsl:when>
			<xsl:when test="FORUMSOURCE/@TYPE='reviewforum'">
			
			<xsl:element name="{$text.base}" use-attribute-sets="text.base">
			<span class="heading2">THIS CONVERSATION IS RELATED TO</span> <br/>
			</xsl:element>
			<div class="heading3">
			<xsl:element name="{$text.headinglarge}" use-attribute-sets="text.headinglarge">
			<xsl:apply-templates select="FORUMSOURCE" mode="reviewforum_forumsource"/></xsl:element><br/>
			<xsl:element name="{$text.base}" use-attribute-sets="text.base">in <xsl:value-of select="$forumsubtype" /> section</xsl:element>
			</div>
	   			
		
			</xsl:when>
			<xsl:when test="FORUMSOURCE/@TYPE='club'">
			
			<xsl:element name="{$text.base}" use-attribute-sets="text.base">
			<span class="heading2">THIS CONVERSATION IS RELATED TO</span> <br/>
			</xsl:element>
			<div class="heading3">
			<xsl:element name="{$text.headinglarge}" use-attribute-sets="text.headinglarge">
			<xsl:apply-templates select="FORUMSOURCE" mode="club_forumsource"/></xsl:element><br/>
			<xsl:element name="{$text.base}" use-attribute-sets="text.base">in <xsl:value-of select="$forumsubtype" /> section</xsl:element>
			</div>
	   	
	
			</xsl:when>
			<xsl:otherwise>
			
			<xsl:element name="{$text.base}" use-attribute-sets="text.base">
			<span class="heading2">THIS CONVERSATION IS RELATED TO</span> <br/>
			</xsl:element>
			<div class="heading3">
			<xsl:element name="{$text.headinglarge}" use-attribute-sets="text.headinglarge">
			<xsl:apply-templates select="FORUMSOURCE" mode="article_forumsource"/></xsl:element><br/>
			<xsl:element name="{$text.base}" use-attribute-sets="text.base">in <xsl:value-of select="$forumsubtype" /> section</xsl:element>
			</div>

			</xsl:otherwise>
		</xsl:choose>

		</div>
		</td>
	</tr>
	</table>
	</div>
</xsl:if>
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
		<table width="371" border="0" cellspacing="0" cellpadding="0">
			<xsl:apply-templates select="THREAD" mode="c_threadspage"/>
	  </table>
	</xsl:template>
	<!--
	<xsl:template match="THREAD" mode="r_threadspage">
	Use: Presentation of an individual thread in a THREADS page
	 -->
	<xsl:template match="THREAD" mode="r_threadspage">

	
  <tr> 
    <td width="371" valign="top" class="commentstoprow"><div class="commentstitle"><strong><xsl:apply-templates select="SUBJECT" mode="t_threadspage"/><xsl:if test="SUBJECT=''"><a href="{$root}F{@FORUMID}?thread={@THREADID}" xsl:use-attribute-sets="mSUBJECT_t_threadspage">No Subject</a></xsl:if></strong></div></td>
   
  </tr>
	<xsl:choose>
		<!-- for the all my messages layout -->
			<xsl:when test="/H2G2/FORUMSOURCE/@TYPE='userpage'">
				  <tr> 
					<td valign="top" class="commentssubrow" width="371">
					<div class="commentsposted">message from <xsl:apply-templates select="." mode="t_userposter"/> | left <xsl:apply-templates select="FIRSTPOST/DATE" mode="short1"/> | last reply <xsl:apply-templates select="@THREADID" mode="t_threaddatepostedlinkup"/></div>
				   <!--  <div class="commentuser">Man, what a wonderful thing to share with everybody</div> --></td>
				  </tr>
				  <xsl:if test="$test_IsEditor">
					<tr> 
					<td valign="top" class="commentssubrow" width="371">
					<div class="commentsposted"><xsl:apply-templates select="@THREADID" mode="c_movethreadgadget"/></div>
					</td>
					</tr>
				  </xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<tr> 
					<td valign="top" class="commentssubrow" width="371">
					testing
					</td>
				</tr>
			</xsl:otherwise>
	</xsl:choose>




<!-- 	<div>
		<xsl:attribute name="class">
		<xsl:choose>
		<xsl:when test="count(preceding-sibling::THREAD) mod 2 = 0">colourbar1</xsl:when>
		<xsl:otherwise>colourbar2</xsl:otherwise>
		</xsl:choose>
		</xsl:attribute>
		<table cellspacing="0" cellpadding="0" border="0" width="390">
		<tr>
		<td>
		<strong><xsl:apply-templates select="SUBJECT" mode="t_threadspage"/></strong>
		<xsl:if test="SUBJECT=''"><a href="{$root}F{@FORUMID}?thread={@THREADID}" xsl:use-attribute-sets="mSUBJECT_t_threadspage">No Subject</a></xsl:if>
		</td>
		</tr><tr>
		<td>
		
		<xsl:choose> -->
		<!-- for the all my messages layout -->
<!-- 			<xsl:when test="/H2G2/FORUMSOURCE/@TYPE='userpage'">
			<div class="smallsubmenu2">message from <xsl:apply-templates select="." mode="t_userposter"/> | left <xsl:apply-templates select="FIRSTPOST/DATE" mode="short"/> | last reply <xsl:apply-templates select="@THREADID" mode="t_threaddatepostedlinkup"/></div>
			
			</xsl:when>
			<xsl:otherwise> -->
			<!-- forum layout - not sure if we are using this in film network -->
<!-- 			<xsl:apply-templates select="TOTALPOSTS" mode="t_numberofreplies" /> comments | <a href="{$root}F{@FORUMID}?thread={@THREADID}&amp;post={LASTPOST/@POSTID}#p{LASTPOST/@POSTID}">last comment</a> | <xsl:apply-templates select="DATEPOSTED/DATE"/>
			
			</xsl:otherwise>
		</xsl:choose>
	
		</td>
		<td align="right"> -->
		<!-- MESSAGES MOVE THREAD -->
<!-- 		<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
		<xsl:apply-templates select="@THREADID" mode="c_movethreadgadget"/><xsl:text>  </xsl:text>
		</xsl:element>
		</td>
		</tr>
		</table>
	</div> -->


	</xsl:template>
	<!--
	<xsl:template match="LASTPOST" mode="c_threadspage">
	Context:      /H2G2/FORUMTHREADS/THREAD/LASTPOST
	Purpose:	 Calls the container for the LASTPOST object
	-->
	<xsl:template match="LASTPOST" mode="r_threadspage">
		<a href="U{USER/USERID}"><xsl:value-of select="USER/USERNAME" /></a>
	</xsl:template>
	
	<!--
	<xsl:template match="@THREADID" mode="r_movethreadgadget">
	Use: Presentation of the move thread editorial tool link
	 -->
	<xsl:template match="@THREADID" mode="r_movethreadgadget">
		<xsl:apply-imports/>
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
		<span class="urlon"><xsl:copy-of select="$url"/></span>
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
		<span class="urloff"><xsl:copy-of select="$url"/></span>
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
		<span class="previous">
			<xsl:apply-imports/>
		</span>
	</xsl:template>
	<!-- 
	<xsl:template match="FORUMTHREADS" mode="link_nextpage">
	Use: Presentation of the 'Next Page' link
	-->
	<xsl:template match="FORUMTHREADS" mode="link_nextpage">
		<span class="next">
			<xsl:apply-imports/>
		</span>
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
	
	<!--
	<xsl:template name="DATE" mode="short2">
	Inputs:		-
	Purpose:	Displays date in the following format:28 Mar 2002
	Update: Trent Williams - all date in film network month is shortened
	-->
	<xsl:template match="DATE" mode="short1">
		<xsl:value-of select="@DAY"/>
		&nbsp;
		<xsl:value-of select="substring(@MONTHNAME, 1,3)"/>
		&nbsp;
		<xsl:value-of select="@YEAR"/>
	</xsl:template>


	<!--
	<xsl:template match="FORUMTHREADPOSTS" mode="r_postblocks">
	Use: Container for the complete list of post blocks
	-->
	<xsl:template match="FORUMTHREADPOSTS" mode="r_threadblocks">
		<!-- <xsl:apply-templates select="." mode="c_threadblockdisplayprev"/> -->
		<xsl:apply-templates select="." mode="r_threadspage2"/>
	<!-- 	<xsl:apply-templates select="." mode="c_threadblockdisplaynext"/> -->
	</xsl:template>

	<xsl:template match="FORUMTHREADPOSTS" mode="r_threadspage2">
		<table width="371" border="0" cellspacing="0" cellpadding="0">
			<xsl:apply-templates select="POST" mode="r_threadspage2"/>
	  </table>
	</xsl:template>


	<xsl:template match="SUBJECT" mode="t_threadspage2">
		<a href="{$root}F{../../@FORUMID}?thread={../@THREAD}" xsl:use-attribute-sets="mSUBJECT_t_threadspage">
			<xsl:value-of select="."/>
		</a>
	</xsl:template>


		<!--
	Author:	Trent Williams
	Context: Get username of message poster
 	<xsl:template match="THREAD" mode="t_userposter">
 	-->
	<xsl:template match="POST" mode="t_userposter2">
		<a  class="textdark"><xsl:attribute name="href"><xsl:value-of select="$root" />U<xsl:value-of select="USER/USERID" /></xsl:attribute><xsl:value-of select="USER/FIRSTNAMES" />&nbsp;<xsl:value-of select="USER/LASTNAME" /><!-- <xsl:value-of select="FIRSTPOST/USER/FIRSTNAMES" />&nbsp;<xsl:value-of select="FIRSTPOST/USER/LASTNAME" /> --></a>
	</xsl:template>

	<xsl:template match="@THREADID" mode="t_threaddatepostedlinkup">
		<!-- <a xsl:use-attribute-sets="maTHREADID_t_threaddatepostedlinkup"> -->
		<a class="textdark">
			<xsl:attribute name="HREF"><xsl:value-of select="$root"/>F<xsl:value-of select="."/>?thread=<xsl:value-of select="../@THREADID"/>&amp;post=<xsl:value-of select="../LASTPOST/@POSTID"/>#p<xsl:value-of select="../LASTPOST/@POSTID"/></xsl:attribute>
			<xsl:apply-templates select="../DATEPOSTED" mode="short1"/>
		</a>
	</xsl:template>

	<!--
	<xsl:template match="POST" mode="r_threadspage2">
	Use: Presentation of an individual thread in a THREADS page
	 -->
	<xsl:template match="POST" mode="r_threadspage2">

	
  <tr> 
    <td width="371" valign="top" class="commentstoprow"><div class="commentstitle"><strong><xsl:apply-templates select="SUBJECT" mode="t_threadspage2"/><xsl:if test="SUBJECT=''"><a href="{$root}F{../@FORUMID}?thread={@THREAD}" xsl:use-attribute-sets="mSUBJECT_t_threadspage">No Subject</a></xsl:if></strong></div></td>
   
  </tr>
	<xsl:choose>
		<!-- for the all my messages layout -->
			<xsl:when test="/H2G2/FORUMSOURCE/@TYPE='userpage'">
				  <tr> 
					<td valign="top" class="commentssubrow" width="371">
					<div class="commentsposted">message from <xsl:apply-templates select="." mode="t_userposter2"/> | left <xsl:apply-templates select="DATEPOSTED/DATE" mode="short1"/> | last reply <xsl:apply-templates select="@THREADID" mode="t_threaddatepostedlinkup"/></div>
				   <!--  <div class="commentuser">comment here</div> --></td>
				  </tr>
				  <xsl:if test="$test_IsEditor">
					<tr> 
					<td valign="top" class="commentssubrow" width="371">
					<div class="commentsposted"><xsl:apply-templates select="@THREADID" mode="c_movethreadgadget"/></div>
					</td>
					</tr>
				  </xsl:if>
			</xsl:when>
			
	</xsl:choose>


	</xsl:template>


</xsl:stylesheet>
