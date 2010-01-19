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

		<xsl:call-template name="box.heading">
			<xsl:with-param name="box.heading.value" select="POSTS/POST-LIST/USER/USERNAME" />
		</xsl:call-template>

		<div class="myspace-b-b">
			<xsl:copy-of select="$myspace.conversations.white" />&nbsp;
			<xsl:element name="{$text.subheading}" use-attribute-sets="text.subheading"><strong>all my conversations</strong></xsl:element>
		</div>

		<table cellpadding="0" cellspacing="0" border="0">
		<tr>
<!-- column 1 -->
		<xsl:element name="td" use-attribute-sets="column.1">
		<div class="next-back">
			<table width="100%" border="0" cellspacing="0" cellpadding="4">
			<tr>
			<td><xsl:apply-templates select="POSTS" mode="r_prevmoreposts"/></td>
			<td align="right"><xsl:apply-templates select="POSTS" mode="r_nextmoreposts"/></td>
			</tr>
			</table>
		</div>
		<xsl:apply-templates select="POSTS" mode="c_morepostspage"/>
		
		<div class="next-back">
			<table width="100%" border="0" cellspacing="0" cellpadding="4">
			<tr>
			<td><xsl:apply-templates select="POSTS" mode="r_prevmoreposts"/></td>
			<td align="right"><xsl:apply-templates select="POSTS" mode="r_nextmoreposts"/></td>
			</tr>
			</table>
		</div>
		<br />
		<xsl:element name="{$text.base}" use-attribute-sets="text.base">
		<xsl:copy-of select="$arrow.left" /><xsl:text>  </xsl:text>
		<xsl:apply-templates select="POSTS" mode="t_morepostsPSlink"/>
		</xsl:element>
		<br />
		<xsl:element name="img" use-attribute-sets="column.spacer.1" />
		</xsl:element>
		<xsl:element name="td" use-attribute-sets="column.3"><xsl:element name="img" use-attribute-sets="column.spacer.3" /></xsl:element>

<!-- column 2 -->
		<xsl:element name="td" use-attribute-sets="column.2">
		
			
		
		
		<div class="morepost-h">
			<div class="myspace-r">
				<xsl:copy-of select="$myspace.tips" />&nbsp;
				<xsl:element name="{$text.subheading}" use-attribute-sets="text.subheading">
					<strong class="white">hints and tips</strong>
				</xsl:element>
			</div>
			<xsl:copy-of select="$tips_allconversations" />
				<div class="myspace-u">
				<div class="myspace-r">		
					<!-- my intro tools -->			
					<xsl:copy-of select="$myspace.popup" />&nbsp;
					<xsl:element name="{$text.subheading}" use-attribute-sets="text.subheading">
						<strong class="white">pop up my conversations</strong>
					</xsl:element>

					<xsl:element name="{$text.base}" use-attribute-sets="text.base">
					<div class="myspace-w">keep track of your collective conversations while you do something else</div>
					<!-- popup my conversations link -->
					<div class="myspace-v"><xsl:copy-of select="$arrow.right" /><xsl:call-template name="popupconversationslink"><xsl:with-param name="content" select="$alt_myconversations"/></xsl:call-template></div>
					</xsl:element>
				</div></div>
			<br />
			</div>
			<xsl:call-template name="RANDOMPROMO" />
		<xsl:element name="img" use-attribute-sets="column.spacer.2" />
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
			<xsl:when test="count(preceding-sibling::POST) mod 2 = 0">myspace-e-1</xsl:when><!-- alternate colours, MC -->
			<xsl:otherwise>myspace-e-2</xsl:otherwise>
			</xsl:choose>
			</xsl:attribute>
			<table cellspacing="0" cellpadding="0" border="0" width="395">
			<tr>
			<td rowspan="2" width="25" class="myspace-e-3">&nbsp;</td>
			<td class="brown">
			<xsl:element name="{$text.base}" use-attribute-sets="text.base">
				<strong><xsl:apply-templates select="THREAD/@THREADID" mode="t_morepostspagesubject"/></strong>
			</xsl:element>
			</td>
			<td align="right">
			<xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall">
				<xsl:apply-templates select="." mode="c_postunsubscribemorepostspage"/>
			</xsl:element>
			</td>
			</tr><tr>
			<td colspan="2" class="orange">
			<xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall">
				<xsl:apply-templates select="." mode="c_userpagepostdate"/> <xsl:if test="THREAD/LASTUSERPOST"> | </xsl:if> <xsl:apply-templates select="." mode="c_userpagepostlastreply"/> | <xsl:value-of select="@COUNTPOSTS"/> comments
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
			<xsl:apply-imports/> <xsl:copy-of select="$arrow.left" />
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
