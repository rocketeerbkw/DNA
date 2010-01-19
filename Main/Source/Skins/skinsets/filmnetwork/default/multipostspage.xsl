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
	<xsl:with-param name="message">MULTIPOSTS_MAINBODY</xsl:with-param>
	<xsl:with-param name="pagename">multipostspage.xsl</xsl:with-param>
	</xsl:call-template>
	<!-- DEBUG -->

	<xsl:choose>
	<xsl:when test="/H2G2/FORUMSOURCE/@TYPE='reviewforum'">
	<!-- THIS IS THE LAYOUT FOR THE REVIEW INTRO -->
	<!-- start of table -->
	<!-- <xsl:element name="table" use-attribute-sets="html.table.container">
	<tr>
	<xsl:element name="td" use-attribute-sets="column.1">
	
	<div class="banner3">
	<table width="400" border="0" cellspacing="0" cellpadding="0">
	<tr>
	<td valign="top"><img src="{$imagesource}furniture/reviewcircle/pic_intro.gif" alt="Intro" width="205" height="153" border="0"/></td>
	<td valign="top">
	<div class="MainPromo2">
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	THIS IS AN INTRODUCTION FOR THE WORK
	</xsl:element>
	
	<div class="heading3">
		<xsl:element name="{$text.headinglarge}" use-attribute-sets="text.headinglarge">
	<a href="{FORUMTHREADPOSTS/POST/TEXT/LINK}"><xsl:value-of select="substring-after(FORUMTHREADPOSTS/POST/SUBJECT,'- ')" /></a>
	</xsl:element>
	</div>
	</div>
	</td>
	</tr>
	</table>
	</div>
	<img src="{$graphics}/backgrounds/back_papertop.gif" alt="" width="400" height="26" border="0" />
	<div class="PageContent">
	<div class="box">
	<table width="390" border="0" cellspacing="0" cellpadding="2">
	<tr>
	<td class="boxheading">
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	<span class="heading1">
	<xsl:value-of select="substring-after(FORUMTHREADPOSTS/POST/SUBJECT,'- ')" />
	</span>
	</xsl:element>
	</td>
	</tr>
	<tr>
	<td>
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	<span class="credit2">by</span>&nbsp; <a href="U{FORUMTHREADPOSTS/POST/USER/USERID}"><xsl:value-of select="FORUMTHREADPOSTS/POST/USER/USERNAME" /></a></xsl:element><br/>

	<xsl:variable name="userid" select="concat('- U', FORUMTHREADPOSTS/POST/USER/USERID)" />
	<br/>
	<xsl:element name="{$text.base}" use-attribute-sets="text.base">
	<xsl:value-of select="substring-after(FORUMTHREADPOSTS/POST/TEXT, $userid)"/>
	</xsl:element>	
	<br/><br/>
	</td>
	</tr>
	</table>
	
	<table width="390" border="0" cellspacing="0" cellpadding="0">
	<tr>
	<td align="right" class="boxactionback1">
	<a href="UserComplaint?PostID={FORUMTHREADPOSTS/POST/@POSTID}" target="ComplaintPopup" onClick="popupwindow('UserComplaint?PostID={FORUMTHREADPOSTS/POST/@POSTID}', 'ComplaintPopup', 'status=1,resizable=1,scrollbars=1,width=640,height=480')" xsl:use-attribute-sets="maHIDDEN_r_complainmp">
	<xsl:copy-of select="$alt_complain"/>
	</a>
	</td>
	</tr>
	</table>
	</div>
	
	</div>
	
	</xsl:element>
	<xsl:element name="td" use-attribute-sets="column.2">
	
	</xsl:element>
	</tr>
	</xsl:element> -->
	<!-- end of table -->	
	
	
	</xsl:when>
	<xsl:otherwise>
	    


<!-- ################## -->
	<!-- start of table -->
<!-- 	<xsl:element name="table" use-attribute-sets="html.table.container">
	<tr>
	<xsl:element name="td" use-attribute-sets="column.1">
	
	<xsl:element name="{$text.base}" use-attribute-sets="text.base">
	

	<div class="banner3">
	<table width="398" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td valign="top">
		<img src="{$imagesource}furniture/talk/pic_talk.gif" alt="Conversation" width="205" height="153" border="0"/>
		</td>
		<td valign="top">
		<div class="MainPromo2"> -->
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
							<xsl:when test="/H2G2/FORUMTHREADPOSTS/@GROUPALERTID">
								<p>please wait while we take you to your email alerts management page</p>
								<p>if nothing happens after a few seconds, please click <a href="{$root}AlertGroups">here</a></p>
							</xsl:when>
							<xsl:otherwise>
								<p>please wait while we subscribe you to this forum</p>
								<p>if nothing happens after a few seconds, please click <a href="{$root}alertgroups?cmd=add&amp;itemid={/H2G2/SUBSCRIBE-STATE/@THREADID}&amp;itemtype=5&amp;s_view=confirm&amp;s_origin=film">here</a></p>
							</xsl:otherwise>
						</xsl:choose>
					</td>
				</tr>
			</table>
			<img src="http://www.bbc.co.uk/filmnetwork/images/furniture/writemessage/topboxangle.gif"
				width="635" height="27" />
		</xsl:when>
	<xsl:when test="/H2G2/FORUMSOURCE/@TYPE='clubjournal'">
	
			<span class="heading2">
			<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
			THIS GROUP DISCUSSION IS RELATED TO
			</xsl:element></span>
			<div class="heading3">
			<xsl:element name="{$text.headinglarge}" use-attribute-sets="text.headinglarge">
			<a href="G{FORUMSOURCE/CLUB/@ID}"><xsl:value-of select="FORUMSOURCE/CLUB/NAME" /></a>
			</xsl:element>
			</div>
	
	</xsl:when>
	<xsl:when test="/H2G2/FORUMSOURCE/@TYPE='journal'">
	
			<span class="heading2">
			<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
			THIS IS THE WEBLOG OF
			</xsl:element></span>
			<div class="heading3">
			<xsl:element name="{$text.headinglarge}" use-attribute-sets="text.headinglarge">
			<a href="U{FORUMSOURCE/JOURNAL/USER/USERID}"><xsl:value-of select="FORUMSOURCE/JOURNAL/USER/USERNAME" /></a>
			</xsl:element>
			</div>
			
	</xsl:when>
	<xsl:when test="/H2G2/FORUMSOURCE/@TYPE='userpage'">
	      <table border="0" cellspacing="0" cellpadding="0" width="635">
        <tr> 
          <td height="10">
		  <!-- submission page textheader -->
		  <div class="pagehead">leave a message</div>
		  <!-- END submission page textheader --></td>
        </tr>
      </table>
		<!-- 2px Black rule -->
		<table border="0" cellspacing="0" cellpadding="0" width="635">
			<tr>
				<td height="2" class="darkestbg"></td>
			</tr>
			<tr><td height="10"></td></tr>
		</table>
		<!-- END 2px Black rule -->
<!-- head section -->
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
			<tr><td height="10" class="topbg"></td></tr>
				<tr>
					<td valign="top" class="topbg" height="59">
					<div class="whattodotitle"><strong>this is a message for <a class="whattodotitlelink"  href="U{/H2G2/FORUMSOURCE/ARTICLE/ARTICLEINFO/PAGEAUTHOR/EDITOR/USER/USERID}"><xsl:choose>
						<xsl:when test="string-length(/H2G2/FORUMSOURCE/ARTICLE/ARTICLEINFO/PAGEAUTHOR/EDITOR/USER/FIRSTNAMES) &gt; 0">
							<xsl:value-of select="/H2G2/FORUMSOURCE/ARTICLE/ARTICLEINFO/PAGEAUTHOR/EDITOR/USER/FIRSTNAMES" />&nbsp;<xsl:value-of select="/H2G2/FORUMSOURCE/ARTICLE/ARTICLEINFO/PAGEAUTHOR/EDITOR/USER/LASTNAME" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="/H2G2/FORUMSOURCE/ARTICLE/ARTICLEINFO/PAGEAUTHOR/EDITOR/USER/USERNAME" />
						</xsl:otherwise>
					</xsl:choose></a></strong></div>
					<div class="biogname"><strong><xsl:value-of select="/H2G2/FORUMTHREADPOSTS/FIRSTPOSTSUBJECT" /></strong></div>
					<!-- <div class="topboxcopy">mi. Proin porta arcu sclerisque lectus</div> --></td>
				</tr>
				<tr>
		          <td valign="top" height="20" class="topbg"></td>
				</tr>
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

<!-- 	
			<span class="heading2">
			<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
			THIS IS A MESSAGE FOR
			</xsl:element></span>
			<div class="heading3">
			<xsl:element name="{$text.headinglarge}" use-attribute-sets="text.headinglarge">
			<a href="U{FORUMSOURCE/USERPAGE/USER/USERID}"><xsl:value-of select="FORUMSOURCE/USERPAGE/USER/USERNAME" /></a>
			</xsl:element>
			</div> -->

<!-- 				<xsl:apply-templates select="FORUMTHREADPOSTS/@SKIPTO" mode="c_navbuttons"/>
	
	<xsl:apply-templates select="FORUMTHREADPOSTS" mode="c_multiposts"/> -->
		
	</xsl:when>
	
	<!-- ALISTAIR: added test for privateuser -->
	<xsl:when test="/H2G2/FORUMSOURCE/@TYPE='privateuser'">
	      <table border="0" cellspacing="0" cellpadding="0" width="635">
        <tr> 
          <td height="10">
		  <!-- submission page textheader -->
		  <div class="pagehead">leave a message</div>
		  <!-- END submission page textheader --></td>
        </tr>
      </table>
		<!-- 2px Black rule -->
		<table border="0" cellspacing="0" cellpadding="0" width="635">
			<tr>
				<td height="2" class="darkestbg"></td>
			</tr>
			<tr><td height="10"></td></tr>
		</table>
		<!-- END 2px Black rule -->
<!-- head section -->
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
			<tr><td height="10" class="topbg"></td></tr>
				<tr>
					<td valign="top" class="topbg" height="59">
					<div class="whattodotitle"><strong>this is a message for <a class="whattodotitlelink"  href="U{/H2G2/FORUMSOURCE/USERPAGE/USER/USERID}"><xsl:choose>
						<xsl:when test="string-length(/H2G2/FORUMSOURCE/USERPAGE/USER/FIRSTNAMES) &gt; 0">
							<xsl:value-of select="/H2G2/FORUMSOURCE/USERPAGE/USER/FIRSTNAMES" />&nbsp;<xsl:value-of select="/H2G2/FORUMSOURCE/USERPAGE/USER/LASTNAME" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="/H2G2/FORUMSOURCE/ARTICLE/ARTICLEINFO/PAGEAUTHOR/EDITOR/USER/USERNAME" />
						</xsl:otherwise>
					</xsl:choose></a></strong></div>
					<div class="biogname"><strong><xsl:value-of select="/H2G2/FORUMTHREADPOSTS/FIRSTPOSTSUBJECT" /></strong></div></td>
				</tr>
				<tr>
		          <td valign="top" height="20" class="topbg"></td>
				</tr>
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
	</xsl:when>
	<xsl:when test="/H2G2/FORUMSOURCE/ARTICLE/EXTRAINFO/TYPE/@ID='60'">
	 <table border="0" cellspacing="0" cellpadding="0" width="635">
        <tr> 
          <td height="10">
		  <!-- crumb menu --> <div class="crumbtop"><span class="textmedium"><a href="{$root}discussion"><strong>discussion</strong></a> |</span> <span class="textxlarge"><xsl:value-of select="/H2G2/FORUMSOURCE/ARTICLE/SUBJECT" /></span></div>
		  <!-- END crumb menu --></td>
        </tr>
      </table>
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
					<img src="/f/t.gif" width="1" height="10" alt="" />
					
						<div class="whattodotitle"><strong>This discussion is about <br /></strong></div>
						 <div class="biogname"><strong><xsl:value-of select="/H2G2/FORUMSOURCE/ARTICLE/SUBJECT"/></strong></div>
					
			
					 <div class="topboxcopy"><xsl:value-of select="/H2G2/FORUMSOURCE/ARTICLE/GUIDE/BODY"/></div></td>
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

	
	<!-- spacer -->
	<table width="635" border="0" cellspacing="0" cellpadding="0">
	  <tr>
		<td height="10"></td>
	  </tr>
	</table>
	</xsl:when>
	<xsl:when test="/H2G2/FORUMSOURCE/ARTICLE/EXTRAINFO/TYPE/@ID='30' or
		/H2G2/FORUMSOURCE/ARTICLE/EXTRAINFO/TYPE/@ID='31' or
		/H2G2/FORUMSOURCE/ARTICLE/EXTRAINFO/TYPE/@ID='32' or
		/H2G2/FORUMSOURCE/ARTICLE/EXTRAINFO/TYPE/@ID='33' or
		/H2G2/FORUMSOURCE/ARTICLE/EXTRAINFO/TYPE/@ID='34' or
		/H2G2/FORUMSOURCE/ARTICLE/EXTRAINFO/TYPE/@ID='35'">
	<!-- article etc -->
	<!-- check if film page else show another type -->
	<!-- 10px Spacer table -->
		<table border="0" cellspacing="0" cellpadding="0" width="635">
			<tr>
				<td height="10"></td>
			</tr>
		</table>

		<!-- END 10px Spacer table -->
	<!-- Need to work out what category film is in and show that picture -->
	<xsl:variable name="article_header_gif"><xsl:choose>
			<xsl:when test="$showfakegifs = 'yes'">A1875585_large.jpg</xsl:when>
			<xsl:otherwise>A<xsl:value-of select="FORUMSOURCE/ARTICLE/ARTICLEINFO/H2G2ID" />_large.jpg</xsl:otherwise>
		</xsl:choose></xsl:variable>
	 <!--changeable bg image here -->
<style>

.dramaintroimagebg {background:url(<xsl:value-of select="$imagesource" /><xsl:value-of select="$gif_assets" /><xsl:value-of select="$article_header_gif" />) top left no-repeat;}

</style>
		<!-- begin intro image table with background image -->
		<table width="635" border="0" cellspacing="0" cellpadding="0">
			<tr>
				  <td valign="top" width="635" height="195" class="dramaintroimagebg"><div class="dramareadcomments"><!-- <a href="A{FORUMSOURCE/ARTICLE/ARTICLEINFO/H2G2ID}">GO BACK TO<br />
					  FILM PAGE<img src="{$imagesource}furniture/drama/dramareadcommentsarrow.gif" width="28" height="23" alt="" /></a> --></div></td>
			</tr>
		</table>
		<!-- END intro image table with background image -->
		<!-- 19px Spacer table -->
		<table border="0" cellspacing="0" cellpadding="0" width="635">
			<tr>
				<td height="19"></td>
			</tr>
		</table>
		<!-- END 19px Spacer table -->	
			<!-- Intro -->
		<table width="635" border="0" cellspacing="0" cellpadding="0">
          <!-- Spacer row -->
          <tr>
            <td><img src="/f/t.gif" width="371" height="1" class="tiny" alt="" /></td>
            <td><img src="/f/t.gif" width="10" height="1" class="tiny" alt="" /></td>
            <td><img src="/f/t.gif" width="10" height="1" class="tiny" alt="" /></td>
            <td><img src="/f/t.gif" width="244" height="1" class="tiny" alt="" /></td>
          </tr>
          <tr>
		  <!-- mouseover -->
		   <!-- get corrent film title gif -->
		  <xsl:variable name="filmTitle"><xsl:choose>
			<xsl:when test="$showfakegifs = 'yes'">A1875585_title</xsl:when>
			<xsl:otherwise>A<xsl:value-of select="FORUMSOURCE/ARTICLE/ARTICLEINFO/H2G2ID" />_title</xsl:otherwise>
		</xsl:choose></xsl:variable>

            <td align="right" valign="top"><a href="{$root}A{FORUMSOURCE/ARTICLE/ARTICLEINFO/H2G2ID}"><img src="{$imagesource}{$gif_assets}{$filmTitle}.gif" width="371" name="newmovietitle" height="29" border="0" >
		  <xsl:attribute name="alt"><xsl:apply-templates select="FORUMSOURCE/ARTICLE/SUBJECT" /></xsl:attribute></img></a><br />
			  <span class="textxxlarge">
			  <strong><xsl:apply-templates select="FORUMSOURCE/ARTICLE/GUIDE/DIRECTORSNAME" /></strong></span>
			<!--  end mouseover ARTICLEINFO/PAGEAUTHOR/EDITOR/USER/USERNAME-->        
			<div class="intocredit"><div class="intodetails"><xsl:choose>
						<xsl:when test="FORUMSOURCE/ARTICLE/EXTRAINFO/TYPE/@ID = 30">
							<a href="{$root}C{$genreDrama}" class="textdark"><xsl:value-of select="msxsl:node-set($type)/type[@number=30 or @selectnumber=30]/@subtype" /></a>
						</xsl:when>
						<xsl:when test="FORUMSOURCE/ARTICLE/EXTRAINFO/TYPE/@ID = 31">
							<a href="{$root}C{$genreComedy}" class="textdark"><xsl:value-of select="msxsl:node-set($type)/type[@number=31 or @selectnumber=31]/@subtype" /></a>
						</xsl:when>
						<xsl:when test="FORUMSOURCE/ARTICLE/EXTRAINFO/TYPE/@ID = 32">
							<a href="{$root}C{$genreDocumentry}" class="textdark"><xsl:value-of select="msxsl:node-set($type)/type[@number=32 or @selectnumber=32]/@subtype" /></a>
						</xsl:when>
						<xsl:when test="FORUMSOURCE/ARTICLE/EXTRAINFO/TYPE/@ID = 33">
							<a href="{$root}C{$genreAnimation}" class="textdark"><xsl:value-of select="msxsl:node-set($type)/type[@number=33 or @selectnumber=33]/@subtype" /></a>
						</xsl:when>
						<xsl:when test="FORUMSOURCE/ARTICLE/EXTRAINFO/TYPE/@ID = 34">
							<a href="{$root}C{$genreExperimental}" class="textdark"><xsl:value-of select="msxsl:node-set($type)/type[@number=34 or @selectnumber=34]/@subtype" /></a>
						</xsl:when>
						<xsl:when test="FORUMSOURCE/ARTICLE/EXTRAINFO/TYPE/@ID = 35">
							<a href="{$root}C{$genreMusic}" class="textdark"><xsl:value-of select="msxsl:node-set($type)/type[@number=35 or @selectnumber=35]/@subtype" /></a>
						</xsl:when>
						<xsl:otherwise>No Genre</xsl:otherwise>
					</xsl:choose> | <xsl:value-of select="FORUMSOURCE/ARTICLE/ARTICLEINFO/DATECREATED/DATE/@DAY" />&nbsp;<xsl:value-of select="substring(FORUMSOURCE/ARTICLE/ARTICLEINFO/DATECREATED/DATE/@MONTHNAME, 1,3)" />&nbsp;<xsl:value-of select="substring(FORUMSOURCE/ARTICLE/ARTICLEINFO/DATECREATED/DATE/@YEAR, 3,4)" /></div></div>
            </td>
			<!-- END intro -->
            <td><!-- 10px spacer column --></td>
            <td class="introdivider"><!-- 10px spacer column -->&nbsp;</td>
            
          <td valign="top" class="darkestbg"> 
<!-- add your comments -->
<table cellpadding="0" cellspacing="0" border="0" width="244">
<tr><td valign="top"><div class="rightcolsubmit"><xsl:apply-templates select="FORUMTHREADPOSTS/POST[1]/@POSTID" mode="c_replytopost"/></div></td></tr></table>
<!-- end add your comments --></td>
          </tr>
		  <tr>
		  <td></td>
		  </tr>
        </table>
		
		<!-- END Intro -->

		<!-- end film header -->


		<!-- start general page content  comments etc -->





		<!-- ############## -->
			<!-- <xsl:element name="{$text.base}" use-attribute-sets="text.base">
			<span class="heading2">THIS CONVERSATION IS RELATED TO</span> <br/>
			</xsl:element>
			
			<div class="heading3">
			<xsl:element name="{$text.headinglarge}" use-attribute-sets="text.headinglarge">
			<a href="A{FORUMSOURCE/ARTICLE/ARTICLEINFO/H2G2ID}"><xsl:value-of select="FORUMSOURCE/ARTICLE/SUBJECT" /></a></xsl:element><br/>
			<xsl:element name="{$text.base}" use-attribute-sets="text.base">
			
			in 
			<xsl:choose>
			<xsl:when test="/H2G2/FORUMSOURCE/ARTICLE/ARTICLEINFO/STATUS/@TYPE='9'">help</xsl:when>
			<xsl:otherwise><xsl:value-of select="$forumsubtype" /></xsl:otherwise>
			</xsl:choose>
			 section
			
			</xsl:element>
			</div>
		
			<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">	
			<div class="arrow3"><xsl:apply-templates select="FORUMTHREADPOSTS" mode="t_allthreads"/></div>
			
			</xsl:element>
			 -->
	</xsl:when>
	<xsl:otherwise>
	<table border="0" cellspacing="0" cellpadding="0" width="635">
        <tr> 
          <td height="10">
		  <!-- crumb menu --> <div class="crumbtop">
		  <xsl:if test="/H2G2/FORUMSOURCE/ARTICLE/EXTRAINFO/TYPE/@ID='63'">
		  <span class="textmedium"><a href="{$root}magazine"><strong>magazine</strong></a> | </span>
		  </xsl:if>
		  <span class="textxlarge"><xsl:value-of select="/H2G2/FORUMSOURCE/ARTICLE/SUBJECT" /></span></div>
		  <!-- END crumb menu --></td>
        </tr>
      </table>
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
					<img src="/f/t.gif" width="1" height="10" alt="" />
					
						<div class="whattodotitle"><strong>This discussion is about <br /></strong></div>
						 <div class="biogname"><strong><a class="rightcol"  href="{$root}A{FORUMSOURCE/ARTICLE/ARTICLEINFO/H2G2ID}"><xsl:value-of select="/H2G2/FORUMSOURCE/ARTICLE/SUBJECT"/></a></strong></div>
					
			
					<!--  <div class="topboxcopy"><xsl:value-of select="/H2G2/FORUMSOURCE/ARTICLE/GUIDE/BODY"/></div> --></td>
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

	
	<!-- spacer -->
	<table width="635" border="0" cellspacing="0" cellpadding="0">
	  <tr>
		<td height="10"></td>
	  </tr>
	</table>
	</xsl:otherwise>
	</xsl:choose>		
		
		<xsl:choose>
			<xsl:when test="/H2G2/PARAMS/PARAM/NAME='s_alertsRefresh'"></xsl:when>
			<xsl:otherwise>
		
		<!-- 	</div>
		</td>
	</tr>
	</table>
	</div> -->
		<!-- Grey line spacer -->
		<table width="635" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td height="14"></td>
          </tr>
        </table>
		<!-- END Grey line spacer -->
		
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

		  <!-- previous / page x of x / next table -->
	<!-- PREV AND NEXT -->
	<xsl:apply-templates select="FORUMTHREADPOSTS/@SKIPTO" mode="c_navbuttons"/>
	
	<!-- POSTS -->
	<xsl:apply-templates select="FORUMTHREADPOSTS" mode="c_multiposts"/>

	<xsl:if test="$DEBUG = 1 or /H2G2/PARAMS/PARAM[NAME = 's_debug']/VALUE = '1'">
	<div class="debug">
	<strong>FORUMTHREADPOSTS</strong><br />
	@COUNT:<xsl:value-of select="FORUMTHREADPOSTS/@COUNT" /><br />
	@FORUMPOSTCOUNT:<xsl:value-of select="FORUMTHREADPOSTS/@FORUMPOSTCOUNT" /><br />
	@TOTALPOSTCOUNT:<xsl:value-of select="FORUMTHREADPOSTS/@TOTALPOSTCOUNT" /><br />
	@MORE:<xsl:value-of select="FORUMTHREADPOSTS/@MORE" /><br />
	<table cellpadding="2" cellspacing="0" border="1" style="font-size:100%;">
		<caption>FORUMTHREADPOSTS/POST</caption>
		<tr>
		<th>position()</th>
		<th>SUBJECT</th>
		<th>USER/USERNAME</th>
		<th>TEXT</th>
		<th>DATEPOSTED/DATE</th>
		<th>@INDEX</th>
		</tr>
		<xsl:for-each select="FORUMTHREADPOSTS/POST">
		<tr>
		<td><xsl:value-of select="position()"/></td>
		<td><xsl:value-of select="SUBJECT"/></td>
		<td><a href="{$root}U{USER/USERID}"><xsl:value-of select="USER/USERNAME" /></a></td>
		<td><xsl:value-of select="TEXT"/></td>
		<td><xsl:value-of select="DATEPOSTED/DATE/@DAY" />&nbsp;<xsl:value-of select="DATEPOSTED/DATE/@MONTHNAME" />&nbsp;<xsl:value-of select="DATEPOSTED/DATE/@YEAR" /><xsl:text> </xsl:text><xsl:value-of select="DATEPOSTED/DATE/@HOURS" />:<xsl:value-of select="DATEPOSTED/DATE/@MINUTES" />:<xsl:value-of select="DATEPOSTED/DATE/@SECONDS" /></td>
		<td><xsl:value-of select="@INDEX" /></td>
		</tr>
		</xsl:for-each>
	</table>
	</div>		
</xsl:if>
	
	
		<!-- Grey line spacer -->
		<table width="371" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td height="8"></td>
          </tr>
        </table>
		<!-- END Grey line spacer -->
	
	<!-- PREV AND NEXT -->
	<xsl:apply-templates select="FORUMTHREADPOSTS/@SKIPTO" mode="c_navbuttons"/>

<!-- back to my profile rollover -->
	<!-- <div class="finalsubmit"><a href="{$root}A{FORUMSOURCE/ARTICLE/ARTICLEINFO/H2G2ID}" onmouseover="swapImage('backfilmpage', '{$imagesource}furniture/backfilmpage2.gif')" onmouseout="swapImage('backfilmpage', '{$imagesource}furniture/backfilmpage1.gif')"><img src="{$imagesource}furniture/backfilmpage1.gif" width="312" height="22" name="backfilmpage" alt="go back to film page" /></a></div> -->
	
	
	
	<!-- have a 'add your comments' link for posts from articles
	BUT don't display the 'add your comments' link on posts about magazine features (type=63) -->
	<xsl:if test="/H2G2/FORUMSOURCE/@TYPE='article' and not(/H2G2/FORUMSOURCE/ARTICLE/EXTRAINFO/TYPE/@ID=63)"> 
		<div style="margin-top:6px;text-align:right;">
			<xsl:element name="{$text.base}" use-attribute-sets="text.base">
				<strong>
				<a>
				<xsl:attribute name="href">
					<xsl:choose>
						<xsl:when test="/H2G2/VIEWING-USER/USER">
							<xsl:value-of select="concat($root, 'AddThread?inreplyto=', /H2G2/FORUMTHREADPOSTS/POST[1]/@POSTID, '&amp;action=A', /H2G2/FORUMSOURCE/ARTICLE/ARTICLEINFO/H2G2ID)"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="concat($sso_rootlogin, 'AddThread?inreplyto=', /H2G2/FORUMTHREADPOSTS/POST[1]/@POSTID, '&amp;action=A', /H2G2/FORUMSOURCE/ARTICLE/ARTICLEINFO/H2G2ID)"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
				add your comments
				</a><xsl:copy-of select="$arrow.right" /></strong>
			</xsl:element>
		</div>
		
		
	</xsl:if>
	<div class="goback"><strong>
		<xsl:choose>
			<xsl:when test="/H2G2/FORUMSOURCE/@TYPE = 'userpage'">
		<a href="{$root}F{FORUMSOURCE/ARTICLE/ARTICLEINFO/FORUMID}">go back to message list&nbsp;<img src="{$imagesource}furniture/writemessage/arrowdark.gif" width="4" height="7" alt=""/></a>
		</xsl:when>
		<xsl:when test="/H2G2/FORUMSOURCE/ARTICLE/EXTRAINFO/TYPE/@ID='60'">
		<!-- <a href="{$root}discussion">go back to duscussion</a> -->
		<!-- <xsl:apply-templates select="FORUMTHREADPOSTS/POST[1]/@POSTID" mode="r_replytopostdiscussion"/> -->
		
		</xsl:when>
		<xsl:when test="/H2G2/FORUMSOURCE/ARTICLE/EXTRAINFO/TYPE/@ID='63'">
		<a href="{$root}A{FORUMSOURCE/ARTICLE/ARTICLEINFO/H2G2ID}">related feature</a>&nbsp;<img src="{$imagesource}furniture/writemessage/arrowdark.gif" width="4" height="7" alt=""/>
		</xsl:when>
		<xsl:otherwise>
			<a href="{$root}A{FORUMSOURCE/ARTICLE/ARTICLEINFO/H2G2ID}">go back to film page</a>&nbsp;<img src="{$imagesource}furniture/writemessage/arrowdark.gif" width="4" height="7" alt=""/>
		</xsl:otherwise>
	</xsl:choose></strong></div>
<!-- END back to my profile rollover -->

</td>
            <td><!-- 20px spacer column --></td>
            <td valign="top">			




			<xsl:if test="(/H2G2/FORUMSOURCE/@TYPE = 'article') and (/H2G2/FORUMSOURCE/ARTICLE/EXTRAINFO/TYPE/@ID = 60)">

			<table cellpadding="0" cellspacing="0" border="0" width="244">
			<tr><td valign="top" class="darkestbg"><div class="rightcolsubmit"><xsl:apply-templates select="FORUMTHREADPOSTS/POST[1]/@POSTID" mode="c_replytopost"/></div></td></tr></table>
				<table width="24" border="0" cellspacing="0" cellpadding="0">
				  <tr>
					<td height="10"></td>
				  </tr>
				</table>
			</xsl:if>
			<!-- END other discussion topics all -->
			<!-- key with 1 elements -->
		<xsl:if test="/H2G2/FORUMSOURCE/ARTICLE/EXTRAINFO/TYPE/@ID='63'">
		<a href="{$root}A{FORUMSOURCE/ARTICLE/ARTICLEINFO/H2G2ID}"><img src="{$imagesource}furniture/boxlink_related_feature.gif" width="244" height="109" alt="related feature" style="margin-bottom:10px;" /></a>
		</xsl:if>
            	
           	 	<!-- emai alerts box -->
            		<table class="smallEmailBox" border="0" cellpadding="0" cellspacing="0">
            			<tr class="textMedium manageEmails">
            				<td class="emailImageCell">
            					<img id="manageIcon" src="http://www.bbc.co.uk/filmnetwork/images/furniture/manage_alerts.gif" width="25" height="20" alt="" />
            				</td>
            				<td>
            					<strong>
            						<xsl:choose>
            							<xsl:when test="/H2G2/FORUMTHREADPOSTS/@GROUPALERTID">
            								<a href="{$root}AlertGroups">
	            								<xsl:choose>
	            									<xsl:when test="/H2G2/FORUMSOURCE/@TYPE = 'userpage'">
	            										stop emailing me when this person replies
	            									</xsl:when>
	            									<xsl:otherwise>
	            										stop emailing me when someone leaves a comment
	            									</xsl:otherwise>
	            								</xsl:choose>
            									<img src="http://www.bbc.co.uk/filmnetwork/images/furniture/myprofile/arrowdark.gif" width="4" height="7" alt="" />
            								</a>
            							</xsl:when>
            							<xsl:otherwise>
            								<a>
	            								<xsl:choose>			
	            									<xsl:when test="/H2G2/FORUMSOURCE/@TYPE = 'userpage'">
												<xsl:call-template name="emailStart">
													<xsl:with-param name="origin">reply</xsl:with-param>
												</xsl:call-template>
	            										email me if this person<br />replies
	            									</xsl:when>
	            									<xsl:when test="/H2G2/FORUMSOURCE/ARTICLE/SUBJECT = 'Opinions'">
	            										<xsl:call-template name="emailStart">
	            											<xsl:with-param name="origin">discussion</xsl:with-param>
	            										</xsl:call-template>
	            										email me when new comments are made in this discussion 
	            									</xsl:when>
	            									<xsl:otherwise>
	            										<xsl:call-template name="emailStart">
	            											<xsl:with-param name="origin">film</xsl:with-param>
	            										</xsl:call-template>
	            										email me when new comments are made
	            									</xsl:otherwise>
	            								</xsl:choose>
            									<img src="http://www.bbc.co.uk/filmnetwork/images/furniture/myprofile/arrowdark.gif" width="4" height="7" alt="" />
            								</a>
            							</xsl:otherwise>
            						</xsl:choose>														
          					</strong>
              				</td>
            			</tr>
            			<tr class="profileMoreAbout moreEmails">
            				<td class="emailInfoImage">
            					<img src="http://www.bbc.co.uk/filmnetwork/images/furniture/more_alerts.gif" width="18"
            						height="18" alt="" />
            				</td>
            				<td>
            					<a href="sitehelpemailalerts">
            						more about email alerts&nbsp;
            						<img src="http://www.bbc.co.uk/filmnetwork/images/furniture/myprofile/arrowdark.gif" width="4" height="7" alt="" />
            					</a>
            				</td>
            			</tr>
            		</table>
            	
            	

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

		
	<!-- </xsl:element>
	<img src="{$graphics}/backgrounds/back_papertop.gif" alt="" width="400" height="26" border="0" />
	<div class="PageContent"> -->
	<!-- PREV AND NEXT -->
	<!-- <xsl:apply-templates select="FORUMTHREADPOSTS/@SKIPTO" mode="c_navbuttons"/> -->
	
	<!-- POSTS -->
	<!-- <xsl:apply-templates select="FORUMTHREADPOSTS" mode="c_multiposts"/> -->
	
	<!-- PREV AND NEXT -->
	<!-- <xsl:apply-templates select="FORUMTHREADPOSTS/@SKIPTO" mode="c_navbuttons"/>
	
	<div class="boxactionback">
	<div class="arrow1">
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	<xsl:apply-templates select="FORUMTHREADPOSTS" mode="c_subcribemultiposts"/>
	</xsl:element>
	</div>
	</div>
	</div>	
	</xsl:element>
	<xsl:element name="td" use-attribute-sets="column.2">
	
	<div class="NavPromoOuter">
	<div class="NavPromo">	
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	 <xsl:copy-of select="$key.tips" /> 
	</xsl:element>
	</div>
	</div>
	
	<div class="rightnavboxheaderhint">
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	HINTS AND TIPS
	</xsl:element>
	</div>
	<div class="rightnavbox">
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium"> -->
	<!-- <xsl:copy-of select="$conversation.tips" /> -->
<!-- 	</xsl:element>
	</div> -->

<!-- 	<xsl:call-template name="popupconversationslink">
		<xsl:with-param name="content">
			<xsl:copy-of select="$arrow.right" />
			<xsl:value-of select="$alt_myconversations" />
		</xsl:with-param>
	</xsl:call-template> -->

<!-- 	<xsl:apply-templates select="/H2G2/SITECONFIG/IMGPROMO1" />

	<xsl:apply-templates select="/H2G2/SITECONFIG/IMGPROMO2" />
	
	<xsl:apply-templates select="/H2G2/SITECONFIG/IMGPROMO3" /> -->
	
	
<!-- 	</xsl:element>
	</tr>
	</xsl:element>
	 -->
	</xsl:otherwise>
		</xsl:choose>
	</xsl:otherwise>
	</xsl:choose>
	
	</xsl:template>
	
	<xsl:variable name="mpsplit" select="8"/> 
	
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
		<span class="urlon"><xsl:copy-of select="$url"/></span>
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
		<span class="urloff"><xsl:copy-of select="$url"/></span>
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
		
		<xsl:apply-templates select="POST[@HIDDEN != 1]" mode="c_multiposts"/>
		
	</xsl:template>
	<!-- 
	<xsl:template match="POST" mode="r_multiposts">
	Use: Presentation of a single post
	-->
	<xsl:template match="POST" mode="r_multiposts">
	
	<xsl:if test="count(/H2G2/FORUMTHREADPOSTS/POST) = @INDEX + 1"><a name="last" id="last"></a></xsl:if>
	<xsl:apply-templates select="@POSTID" mode="t_createanchor"/>
	
	<div class="post">
	<table width="371" border="0" cellspacing="0" cellpadding="0">
	<xsl:if test="USER/GROUPS/ADVISOR or USER/GROUPS/EDITOR">
			<xsl:attribute name="class">industryPanelReply</xsl:attribute>
		</xsl:if>
	  <tr> 
		<td width="342" valign="top" class="commentstoprow"><div class="commentstitle"><span class="textsmall"><xsl:choose>
			<xsl:when test="/H2G2/FORUMSOURCE/@TYPE = 'userpage'">message</xsl:when><xsl:otherwise>comment</xsl:otherwise></xsl:choose> by</span>&nbsp;<span class="textmedium"><strong><xsl:apply-templates select="USER/USERNAME" mode="c_multiposts"/></strong></span></div></td>
		<td width="29" valign="top" class="commentstoprow"><xsl:apply-templates select="@HIDDEN" mode="c_complainmp"/></td>
	  </tr>
	  <tr> 
		<td colspan="2" valign="top" class="commentssubrow" width="371">
		<div class="commentsposted">posted <xsl:apply-templates select="DATEPOSTED/DATE" mode="t_postdatemp"/></div>
		<div class="commentuser"><xsl:apply-templates select="." mode="t_postbodymp"/></div>
			<xsl:if test="/H2G2/FORUMSOURCE/@TYPE = 'userpage' or /H2G2/FORUMSOURCE/ARTICLE/EXTRAINFO/TYPE/@ID = 60 or /H2G2/FORUMSOURCE/ARTICLE/EXTRAINFO/TYPE/@ID = 63 or /H2G2/FORUMSOURCE/@TYPE = 'privateuser'"><!--  -->
				<div class="commentreply">
				<!-- 
				<strong>
					<a><xsl:attribute name="href"><xsl:value-of select="$root" />AddThread?inreplyto=<xsl:value-of select="@POSTID" /></xsl:attribute>reply</a>
					&nbsp;<img src="{$imagesource}furniture/myprofile/arrowdark.gif" width="4" height="7" alt="" />
				</strong>
				
				-->
				
				<strong>
				<a>
				<xsl:attribute name="href">
					<xsl:choose>
						<xsl:when test="/H2G2/VIEWING-USER/USER">
							<xsl:value-of select="concat($root, 'AddThread?inreplyto=', /H2G2/FORUMTHREADPOSTS/POST[1]/@POSTID)"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="concat($sso_rootlogin, 'AddThread?inreplyto=', /H2G2/FORUMTHREADPOSTS/POST[1]/@POSTID)"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
				reply
				</a><xsl:copy-of select="$arrow.right" />
		</strong>
				</div>
				</xsl:if>
			</td>
			  
	  
	  
	  </tr>
	<xsl:if test="$test_IsEditor">
	  <tr> 
		<td colspan="2" valign="top" class="commentssubrow" width="371">
		<xsl:apply-templates select="@POSTID" mode="c_editmp"/>
		<xsl:text>&nbsp;</xsl:text>&nbsp;<!-- | <xsl:text>  </xsl:text>
		<xsl:apply-templates select="@POSTID" mode="c_linktomoderate"/> --></td>
	  </tr>
	</xsl:if>
	</table>
		<xsl:if test="USER/GROUPS/ADVISER or USER/GROUPS/EDITOR">
			<table width="371" border="0" cellspacing="0" cellpadding="0" class="industryPanelDetails">
			<tr>
				<td class="industryPanelIcon" valign="top"><img src="{$imagesource}furniture/icon_indust_prof.gif" width="31" height="30" alt=""/></td>
				<td class="industryPanelMember">
				<xsl:apply-templates select="USER" mode="articlecomment"/>
				is
				<xsl:choose>
					<xsl:when test="USER/GROUPS/ADVISER">
						<xsl:value-of select="USER/TITLE"/> and a member of Film Network's <a href="{$root}industrypanel">Industry Panel</a>.
					</xsl:when>
					<xsl:otherwise>
						a member of the Film Network editorial team.
					</xsl:otherwise>
				</xsl:choose>
				
				</td>
			</tr>
			</table>
		</xsl:if>
	</div>

<!-- 	<div class="box">
		<table width="390" border="0" cellspacing="0" cellpadding="0">
		<tr><td class="boxheading">
		<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
		<strong><xsl:apply-templates select="." mode="t_postsubjectmp"/></strong>
		</xsl:element>
		</td><td align="right" class="boxheading">
		<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
		post <xsl:apply-templates select="." mode="t_postnumber"/>
		</xsl:element>	
		</td></tr></table>
		
		<div class="boxback2">
		<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
		<xsl:if test="@HIDDEN='0'"> -->
		<!-- POST INFO -->
<!-- 		<span class="credit2"><xsl:copy-of select="$m_posted"/></span>&nbsp;
		<xsl:apply-templates select="USER/USERNAME" mode="c_multiposts"/>&nbsp; 
		<xsl:apply-templates select="USER" mode="c_onlineflagmp"/>|  
		<span class="credit2">posted
		<xsl:apply-templates select="DATEPOSTED/DATE" mode="t_postdatemp"/>
		<xsl:apply-templates select="." mode="c_gadgetmp"/></span>
		</xsl:if>
		</xsl:element>
		<div class="postbody">
		<xsl:element name="{$text.base}" use-attribute-sets="text.base">
		<xsl:apply-templates select="." mode="t_postbodymp"/>
		</xsl:element>
		</div>
		</div>
		</div>	
		<table width="392" border="0" cellspacing="0" cellpadding="0">
		<tr>
		<td valign="top" class="boxactionbottom"> -->
		<!-- REPLY OR ADD COMMENT -->
<!-- 		<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
		<xsl:apply-templates select="@POSTID" mode="c_replytopost"/>
		</xsl:element>
		</td>
		<td align="right" class="boxactionbottom"> -->
		<!-- COMPLAIN ABOUT THIS POST -->
<!-- 		<xsl:apply-templates select="@HIDDEN" mode="c_complainmp"/>
		</td>
		</tr>
		</table> -->
			
		<!-- EDIT AND MODERATION HISTORY -->
<!-- 		<xsl:if test="$test_IsEditor">
		<div class="moderationbox">
		<div align="right"><img src="{$graphics}icons/icon_editorsedit.gif" alt="" width="23" height="21" border="0" align="left"/>
		<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
		<xsl:apply-templates select="@POSTID" mode="c_editmp"/>
		<xsl:text>  </xsl:text> | <xsl:text>  </xsl:text>
		<xsl:apply-templates select="@POSTID" mode="c_linktomoderate"/>
		</xsl:element>
		</div>
		</div>
		</xsl:if> -->
		
	
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
	but now displying first and last
	 -->
	<xsl:template match="USERNAME" mode="r_multiposts">
		<!-- <xsl:apply-imports/> -->
		<a target="_top" href="{$root}U{../USERID}" xsl:use-attribute-sets="mUSERNAME_r_multiposts">
			<!-- <xsl:apply-templates select="."/> -->
			<xsl:choose>
				<xsl:when test="string-length(../FIRSTNAMES) &gt; 0">
					<xsl:value-of select="../FIRSTNAMES" />&nbsp;
					<xsl:value-of select="../LASTNAME" /><xsl:if test="../EDITOR = 1">&nbsp;(editor)</xsl:if>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="."/><xsl:if test="../EDITOR = 1">&nbsp;(editor)</xsl:if>
				</xsl:otherwise>
			</xsl:choose>
		</a>
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
	<!-- <xsl:template match="@POSTID" mode="r_editmp">
		<xsl:apply-imports/>
	</xsl:template> -->
	<xsl:template match="@POSTID" mode="r_editmp">
		<div class="commentuser"><a href="{$root}EditPost?PostID={.}" target="_top" onClick="popupwindow('{$root}EditPost?PostID={.}', 'EditPostPopup', 'status=1,resizable=1,scrollbars=1,width=400,height=450');return false;" xsl:use-attribute-sets="maPOSTID_r_editpost">
			<xsl:copy-of select="$m_editpost"/>
		</a></div>
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
          <td width="140"><div class="textsmall"><strong><xsl:copy-of select="$arrow.first" />&nbsp;<xsl:apply-templates select="." mode="c_gotobeginning"/>&nbsp;|&nbsp;<xsl:copy-of select="$arrow.previous" />&nbsp;<xsl:apply-templates select="." mode="c_gotoprevious"/></strong></div></td>
          <td align="center" width="101"><div class="textsmall"><strong>page <xsl:value-of select="$pagenumber" /> of <xsl:value-of select="$pagetotal" /></strong></div></td>
          <td align="right" width="130"><div class="textsmall"><strong><xsl:apply-templates select="." mode="c_gotonext"/>&nbsp;<xsl:copy-of select="$arrow.next" />&nbsp;|&nbsp;<xsl:apply-templates select="." mode="c_gotolatest"/>&nbsp;<xsl:copy-of select="$arrow.latest" /></strong></div></td>
        </tr>
      </table></td>
  </tr>
  <tr>
    <td width="371" height="18"><img src="{$imagesource}furniture/blackrule.gif" width="371" height="2" alt="" class="tiny" /></td>
  </tr>
</table>
<!-- END previous / page x of x / next table -->
	<!-- 	<div class="prevnextbox">
			
			<table width="390" border="0" cellspacing="0" cellpadding="0">
			<tr>			
			<td colspan="3">
			<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
			<strong>You are looking at page <xsl:value-of select="$pagenumber" /> of <xsl:value-of select="$pagetotal" /></strong>
			</xsl:element>
			</td></tr>
			<tr>
			<td align="left">
			<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
			<xsl:copy-of select="$arrow.first" />
			&nbsp;<xsl:apply-templates select="." mode="c_gotobeginning"/> | 
			<xsl:copy-of select="$arrow.previous" />
			&nbsp;<xsl:apply-templates select="." mode="c_gotoprevious"/> 
			</xsl:element>
			</td>
			<td align="center" class="next-back">
			<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
			<xsl:apply-templates select="/H2G2/FORUMTHREADPOSTS" mode="c_postblocks"/>
			</xsl:element>
			</td>
			<td align="right">
			<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
			<xsl:apply-templates select="." mode="c_gotonext"/>
			&nbsp;<xsl:copy-of select="$arrow.next" /> | 
			<xsl:apply-templates select="." mode="c_gotolatest"/>
			&nbsp;<xsl:copy-of select="$arrow.latest" /></xsl:element>
			</td>
			</tr>
			</table>
		</div>
		<br/> -->
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


	<xsl:template match="@POSTID" mode="r_replytopostdiscussion">
		<xsl:param name="attributes"/>
		<a target="_top" xsl:use-attribute-sets="maPOSTID_r_replytopost">
			<xsl:attribute name="href"><xsl:apply-templates select=".." mode="sso_post_signin"/></xsl:attribute>
			<xsl:call-template name="ApplyAttributes">
				<xsl:with-param name="attributes" select="$attributes"/>
			</xsl:call-template>
			<img src="{$imagesource}furniture/drama/addyourcomments1.gif" name="addyourcomments" width="301" height="30" alt="add your comments" />
		</a>
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
		<B><I><xsl:apply-templates/></I></B>
	</xsl:when>
	<xsl:otherwise>
		<xsl:apply-templates/>
	</xsl:otherwise>
	</xsl:choose>
	</xsl:template>
	
	<!-- for email alerts -->
	<xsl:template name="emailStart">
		<xsl:param name="origin" />
		<xsl:attribute name="href">
			<xsl:value-of select="$root" />alertgroups?cmd=add&amp;itemid=<xsl:value-of
				select="/H2G2/SUBSCRIBE-STATE/@THREADID"
			/>&amp;itemtype=5&amp;s_view=confirm&amp;s_origin=<xsl:value-of select="$origin"/>
		</xsl:attribute>
	</xsl:template>
	
	
</xsl:stylesheet>


