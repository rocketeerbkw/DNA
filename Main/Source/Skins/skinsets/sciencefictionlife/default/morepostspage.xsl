<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-	microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
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
	<xsl:template name="MOREPOSTS_MAINBODY">
	
	<!-- DEBUG -->
	<xsl:call-template name="TRACE">
	<xsl:with-param name="message">MOREPOSTS_MAINBODY test variable = <xsl:value-of select="$current_article_type" /></xsl:with-param>
	<xsl:with-param name="pagename">morepostspage.xsl</xsl:with-param>
	</xsl:call-template>
	<!-- DEBUG -->


		<div class="userprofile_topsection"><h1>All recollections for <xsl:value-of select="POSTS/POST-LIST/USER/USERNAME" /></h1></div>

		

	<!-- next previous buttons -->
			<div class="vspace10px"> </div>
			<div class="allmessages">
						<div class="allmessages_line"></div>
						<div class="clear"> </div>
						
						<table width="100%">
							<tr>

							   <td align="left" width="30%"><p class="pnormaltop">

							   <xsl:apply-templates select="POSTS" mode="c_prevmoreposts"/>
							   
							   </p></td>
								<td align="center"><p class="pnormaltop"><!--  <strong>1</strong> | <a href="#">2</a> | <a href="#">3</a> | <a href="#">4</a> | <a href="#">5</a> --> </p></td>

								<td align="right" width="30%"><p class="pnormaltop"><!-- <a href="#">next <img  src="{$imageRoot}images/next.gif" border="0" alt="next" width="4" height="7" /></a> <a href="#">last <img  src="{$imageRoot}images/last.gif" border="0" alt="last" width="8" height="7" /></a> --><xsl:apply-templates select="POSTS" mode="c_nextmoreposts"/></p></td>
							</tr>
						</table>
						<div class="allmessages_line"></div>
					</div>


			<div  class="allrecollection_list">
		
		<xsl:apply-templates select="POSTS" mode="c_morepostspage"/>
		
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
							   <xsl:apply-templates select="POSTS" mode="c_prevmoreposts"/></p></td>
								<td align="center"><p class="pnormaltop"><!--  <strong>1</strong> | <a href="#">2</a> | <a href="#">3</a> | <a href="#">4</a> | <a href="#">5</a> --> </p></td>

								<td align="right" width="30%"><p class="pnormaltop"><!-- <a href="#">next <img  src="{$imageRoot}images/next.gif" border="0" alt="next" width="4" height="7" /></a> <a href="#">last <img  src="{$imageRoot}images/last.gif" border="0" alt="last" width="8" height="7" /></a> --><xsl:apply-templates select="POSTS" mode="c_nextmoreposts"/></p></td>
							</tr>
						</table>
						<div class="allmessages_line"></div>
					</div>
<div class="vspace10px"></div>
    <xsl:apply-templates select="POSTS" mode="t_morepostsPSlink"/>
    <xsl:apply-templates select="POSTS" mode="t_moderateuserlink"/>

  </xsl:template>



	<xsl:template match="POSTS" mode="t_morepostsPSlink">
		<div class="mostrecentview"><strong><a class="title" href="{$root}U{POST-LIST/USER/USERID}">
			Back to <xsl:value-of select="POST-LIST/USER/USERNAME"/>'s profile page
		</a></strong></div>
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
		<xsl:apply-templates select="POST" mode="c_morepostspage"/>
	</xsl:template>
	<!--
	<xsl:template match="POST-LIST" mode="viewer_morepostlist">
	Description: Presentation of a post list where the viewer is not the owner
	 -->
	<xsl:template match="POST-LIST" mode="viewer_morepostlist">
		<xsl:copy-of select="$m_forumviewerfull"/>
		<xsl:apply-templates select="POST" mode="c_morepostspage"/>
	</xsl:template>





	<!--
	<xsl:template match="POST-LIST/POST" mode="r_morepostspage">
	Description: Presentation of a single post in a list
	 -->
		<xsl:template match="POST" mode="r_morepostspage">
						
		<!-- <xsl:value-of select="$m_fromsite"/> 
		<xsl:apply-templates select="SITEID" mode="t_morepostspage"/>
		-->

<!-- INDIVIDUAL ENTRIES -->


		<xsl:if test="../USER/USERID = FIRSTPOSTER/USER/USERID">
		
<div class="goback">
<p><xsl:apply-templates select="THREAD/@THREADID" mode="t_morepostspagesubject"/><xsl:copy-of select="$arrow.right" /></p>
</div>
<div class="paddingbottom8px"></div>
<div class="commentgreybox">
<div class="commentmedia">
<div class="commentdate">Added: <xsl:value-of select="THREAD/DATEFIRSTPOSTED/DATE/@DAY"/>/<xsl:value-of select="THREAD/DATEFIRSTPOSTED/DATE/@MONTH"/>/<xsl:value-of select="THREAD/DATEFIRSTPOSTED/DATE/@YEAR"/>&nbsp;|&nbsp;<xsl:apply-templates select="." mode="c_postunsubscribemorepostspage"/></div>
</div>
</div>
<div class="vspace10px"></div>

			
			<!-- <table cellspacing="0" cellpadding="0" border="0" width="395">
			<tr>
			<td rowspan="2" width="25" class="myspace-e-3">&nbsp;</td>
			<td class="brown">1
			<xsl:element name="{$text.base}" use-attribute-sets="text.base">
				<strong><xsl:apply-templates select="THREAD/@THREADID" mode="t_morepostspagesubject"/></strong>
			</xsl:element>
			</td>
			<td align="right">2
			<xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall">
				<xsl:apply-templates select="." mode="c_postunsubscribemorepostspage"/>
			</xsl:element>
			</td>
			</tr><tr>
			<td colspan="2" class="orange">3
			<xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall">
				<xsl:apply-templates select="." mode="c_userpagepostdate"/> <xsl:if test="THREAD/LASTUSERPOST"> | </xsl:if> <xsl:apply-templates select="." mode="c_userpagepostlastreply"/> | <xsl:value-of select="@COUNTPOSTS"/> comments
			</xsl:element>
			</td>
			</tr>
			</table> -->
		
		</xsl:if>
	</xsl:template>




	<!--
	<xsl:template match="DATE" mode="r_morepostspagepostdate">
	Description: Presentation of the 'last user post to conversation' date
	 -->
	<xsl:template match="DATE" mode="r_morepostspagepostdate">
		<xsl:apply-imports/>
	</xsl:template>
	
	<!--
	<xsl:template match="DATE" mode="r_morepostspagepostdate">
	Author:		Andy Harris
	Context:      /H2G2/POSTS/POST-LIST/POST/THREAD/LASTUSERPOST/DATEPOSTED/DATE
	Purpose:	 Creates the DATE text as a link to the posting in the thread
	-->
	<xsl:template match="DATE" mode="r_morepostspagepostdate">
			<xsl:apply-templates select="."/>
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
	</xsl:template>
	<!--
	<xsl:template match="POSTS" mode="r_prevmoreposts">
	Description: Presentation of the previous link
	 -->
	<xsl:template match="POSTS" mode="r_prevmoreposts">
	<xsl:element name="{$text.base}" use-attribute-sets="text.base">
	<xsl:choose>
		<xsl:when test="./POST-LIST[@SKIPTO &gt; 0]">
			<xsl:copy-of select="$arrow.left" /> <xsl:apply-imports/>
		</xsl:when>
		<xsl:otherwise>
		<xsl:value-of select="$m_newerpostings"/>
		</xsl:otherwise>
	</xsl:choose>
	</xsl:element>
	</xsl:template>
	
	<!--
	<xsl:template match="POSTS" mode="r_nextmoreposts">
	Description: Presentation of the more link
	 -->
	<xsl:template match="POSTS" mode="r_nextmoreposts">
	<xsl:element name="{$text.base}" use-attribute-sets="text.base">
		<xsl:choose>
			<xsl:when test="./POST-LIST[@MORE=1]">
				<xsl:apply-imports/> <xsl:copy-of select="$arrow.right" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$m_olderpostings"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:element>

	</xsl:template>
</xsl:stylesheet>