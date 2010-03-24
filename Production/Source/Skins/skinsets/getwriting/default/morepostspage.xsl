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

		<table cellpadding="0" cellspacing="0" border="0">
		<tr>
<!-- column 1 -->
		<xsl:element name="td" use-attribute-sets="column.1">
		<div class="PageContent">
		<div class="prevnextbox">
			<table width="390" border="0" cellspacing="0" cellpadding="4">
			<tr>
			<td><xsl:apply-templates select="POSTS" mode="r_prevmoreposts"/></td>
			<td align="right"><xsl:apply-templates select="POSTS" mode="r_nextmoreposts"/></td>
			</tr>
			</table>
		</div>
		<div class="box"><xsl:apply-templates select="POSTS" mode="c_morepostspage"/></div>
		
		<div class="prevnextbox">
			<table width="390" border="0" cellspacing="0" cellpadding="4">
			<tr>
			<td><xsl:apply-templates select="POSTS" mode="r_prevmoreposts"/></td>
			<td align="right"><xsl:apply-templates select="POSTS" mode="r_nextmoreposts"/></td>
			</tr>
			</table>
		</div>
		<br />
		
		<div class="boxactionback">
		<xsl:element name="{$text.base}" use-attribute-sets="text.base">
		<div class="arrow1">
      <xsl:apply-templates select="POSTS" mode="t_morepostsPSlink"/>
      <br/>
      <xsl:apply-templates select="POSTS" mode="t_moderateuserlink"/>
    </div>
		</xsl:element>
		</div>	
		
		</div>
		</xsl:element>
	<!-- column 2 -->
		<xsl:element name="td" use-attribute-sets="column.2">
		<div>
			<div class="rightnavboxheaderhint">
				<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
					HINTS AND TIPS
				</xsl:element>
			</div>
			<div class="rightnavbox">		
				<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
					<xsl:copy-of select="$all.conversation.tips" />
				</xsl:element>
			</div>
			<br />
			</div>
		</xsl:element>
		</tr>
		</table>
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
		<div>
			<xsl:attribute name="class">
			<xsl:choose>
			<xsl:when test="count(preceding-sibling::POST) mod 2 = 0">colourbar1</xsl:when>
			<xsl:otherwise>colourbar2</xsl:otherwise>
			</xsl:choose>
			</xsl:attribute>
			<table cellspacing="0" cellpadding="0" border="0" width="380">
			<tr>
			<td>
			<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
				<strong><xsl:apply-templates select="THREAD/@THREADID" mode="t_morepostspagesubject"/></strong>
				<xsl:if test="THREAD/SUBJECT=''"><a href="{$root}F{THREAD/@FORUMID}?thread={THREAD/@THREADID}" xsl:use-attribute-sets="mSUBJECT_t_threadspage">No Subject</a></xsl:if>
			</xsl:element>
			</td>
			<td align="right">
			<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
				<xsl:apply-templates select="." mode="c_postunsubscribemorepostspage"/>
			</xsl:element>
			</td>
			</tr><tr>
			<td colspan="2">
			<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
			<xsl:apply-templates select="." mode="c_userpagepostlastreply"/> | your last post:<xsl:text>  </xsl:text><xsl:apply-templates select="." mode="c_userpagepostdate"/>
			</xsl:element>
			</td>
			</tr>
			</table>
		</div>
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
		<xsl:apply-templates select="." mode="t_lastreplytext"/>&nbsp;
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
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	<xsl:choose>
		<xsl:when test="./POST-LIST[@SKIPTO &gt; 0]">
			<xsl:copy-of select="$previous.arrow" /> <xsl:apply-imports/>
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
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
		<xsl:choose>
			<xsl:when test="./POST-LIST[@MORE=1]">
				<xsl:apply-imports/><xsl:text>  </xsl:text><xsl:copy-of select="$next.arrow" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$m_olderpostings"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:element>

	</xsl:template>
</xsl:stylesheet>
