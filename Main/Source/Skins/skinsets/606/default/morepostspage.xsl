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
		<xsl:with-param name="message">MOREPOSTS_MAINBODY</xsl:with-param>
		<xsl:with-param name="pagename">morepostspage.xsl</xsl:with-param>
	</xsl:call-template>
	<!-- DEBUG -->
	
	<div id="mainbansec">
		<div class="banartical"><h3>Member page / <strong>all comments</strong></h3></div>		
		<xsl:call-template name="SEARCHBOX" />
		<div class="clear"></div>
		
		<h3 class="memberhead">
		<xsl:value-of select="/H2G2/ARTICLE/ARTICLEINFO/PAGEAUTHOR/EDITOR/USER/USERNAME" />
		</h3>
		<div class="memberdate">
			&nbsp;<!-- data not available in xml -->
		</div>
	</div>
		
	<div class="mainbodysec">	
		<h4 class="instructhead">Below is a list of comments
		
		<xsl:choose>
			<xsl:when test="$ownerisviewer=1">you have</xsl:when>
			<xsl:otherwise>
			<xsl:value-of select="/H2G2/POSTS/POST-LIST/USER/USERNAME"/> has
			</xsl:otherwise>
		</xsl:choose>
		
		made. <strong>Click the title to read the messages</strong></h4>	
			
		<div class="bodysec">			
		
			<div class="bodytext">	
			
				<!-- pagination nav -->
				<xsl:call-template name="MOREPOSTS_NAV"/>
				
				<!-- posts -->	
				<xsl:apply-templates select="POSTS" mode="c_morepostspage"/>
				
				<!-- pagination nav -->
				<xsl:call-template name="MOREPOSTS_NAV"/>

        <!-- link to personal space -->
        <div class="arrowb">
          <xsl:apply-templates select="POSTS" mode="t_morepostsPSlink"/>
        </div>
        <div class="arrowb">
          <xsl:apply-templates select="POSTS" mode="t_moderateuserlink"/>
        </div>
      </div>
		
		</div><!-- / bodysec -->	
		<div class="additionsec">	
		
			<div class="hintbox">	
				<h3>HINTS &amp; TIPS</h3>
				<p><xsl:copy-of select="$m_UserEditWarning"/></p>	
				
				<p><xsl:copy-of select="$m_UserEditHouseRulesDiscl"/></p>
			</div>  
				
			<xsl:call-template name="CREATE_ARTICLES_LISTALL" />	
			 
		</div><!-- /  additionsec -->	
				 
				 
		 <div class="clear"></div>
	</div><!-- / mainbodysec -->
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
		<font xsl:use-attribute-sets="mainfont">
					<xsl:copy-of select="$m_forumownerempty"/>
				</font>
	</xsl:template>
	<!--
	<xsl:template match="RECENT-POSTS" mode="viewer_morepostlistempty">
	Description: Presentation of an empty post list where the viewer is not the owner
	 -->
	<xsl:template match="POST-LIST" mode="viewer_morepostlistempty">
		<font xsl:use-attribute-sets="mainfont">
					<xsl:copy-of select="$m_forumviewerempty"/>
				</font>
	</xsl:template>
	<!--
	<xsl:template match="POST-LIST" mode="owner_morepostlist">
	Description: Presentation of a post list where the viewer is the owner
	 -->
	<xsl:template match="POST-LIST" mode="owner_morepostlist">
		<xsl:copy-of select="$m_forumownerfull"/>
		<ul class="striped bodylist">
			<xsl:apply-templates select="POST[SITEID=$site_number]" mode="c_morepostspage"/>
		</ul>
	</xsl:template>
	<!--
	<xsl:template match="POST-LIST" mode="viewer_morepostlist">
	Description: Presentation of a post list where the viewer is not the owner
	 -->
	<xsl:template match="POST-LIST" mode="viewer_morepostlist">
		<xsl:copy-of select="$m_forumviewerfull"/>
		<ul class="striped bodylist">
			<xsl:apply-templates select="POST[SITEID=$site_number]" mode="c_morepostspage"/>
		</ul>
	</xsl:template>
	<!--
	<xsl:template match="POST-LIST/POST" mode="r_morepostspage">
	Description: Presentation of a single post in a list
	 -->
	<xsl:template match="POST" mode="r_morepostspage">
		<li>
			<xsl:attribute name="class">
				<xsl:if test="count(preceding-sibling::POST[SITEID=$site_number]) mod 2 = 0">odd</xsl:if>
			</xsl:attribute>
			<strong><a href="{$root}F{THREAD/@FORUMID}?thread={THREAD/@THREADID}">RE: <xsl:value-of select="THREAD/FORUMTITLE"/></a></strong><br />
			<xsl:apply-templates select="." mode="c_userpagepostdate"/>  |  <xsl:apply-templates select="." mode="c_userpagepostlastreply"/> | <xsl:value-of select="@COUNTPOSTS"/> comments
		</li>
	</xsl:template>
	<!--
	<xsl:template match="DATE" mode="r_morepostspagepostdate">
	Description: Presentation of the 'last user post to conversation' date
	 -->
	<xsl:template match="DATE" mode="r_morepostspagepostdate">
		<xsl:apply-imports/>
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
		<br/>
	</xsl:template>

	
	<!--
	<xsl:template match="POSTS" mode="r_prevmoreposts">
	Description: Presentation of the previous link
	 -->
	<xsl:template match="POSTS" mode="r_prevmoreposts">
	<xsl:choose>
		<xsl:when test="./POST-LIST[@SKIPTO &gt; 0]">
			<xsl:apply-imports/>
		</xsl:when>
		<xsl:otherwise>
		<xsl:value-of select="$m_newerpostings"/>
		</xsl:otherwise>
	</xsl:choose>
	</xsl:template>
	
	<!--
	<xsl:template match="POSTS" mode="r_nextmoreposts">
	Description: Presentation of the more link
	 -->
	<xsl:template match="POSTS" mode="r_nextmoreposts">
	<xsl:choose>
		<xsl:when test="./POST-LIST[@MORE=1]">
			<xsl:apply-imports/>
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="$m_olderpostings"/>
		</xsl:otherwise>
	</xsl:choose>
	</xsl:template>
	
	
	<xsl:template name="MOREPOSTS_NAV">
		<div class="page">	
			<div class="links">
				<div class="pagecol1"><xsl:apply-templates select="POSTS" mode="r_prevmoreposts"/></div>
				<div class="pagecol2"></div>
				<div class="pagecol3"><xsl:apply-templates select="POSTS" mode="r_nextmoreposts"/></div>
			</div>
			<div class="clear"></div>
		</div>
	</xsl:template>
	
	
	
</xsl:stylesheet>
