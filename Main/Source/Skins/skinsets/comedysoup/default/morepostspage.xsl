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
	
		<table width="100%" cellpadding="0" cellspacing="0" border="0">
			<tr>
				<td valign="top" class="postmain" width="60%">
					<xsl:apply-templates select="POSTS" mode="c_morepostspage"/>
				</td>
				<td valign="top" class="postside" width="40%">
					<font xsl:use-attribute-sets="mainfont">
						<xsl:apply-templates select="POSTS" mode="c_prevmoreposts"/>
						<xsl:apply-templates select="POSTS" mode="c_nextmoreposts"/>
						<xsl:apply-templates select="POSTS" mode="t_morepostsPSlink"/>
					</font>
				</td>
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
		<table width="100%" cellpadding="0" cellspacing="5" border="0">
			<xsl:apply-templates select="." mode="c_morepostlistempty"/>
			<xsl:apply-templates select="POST-LIST" mode="c_morepostspage"/>
		</table>
	</xsl:template>
	<!--
	<xsl:template match="RECENT-POSTS" mode="owner_morepostlistempty">
	Description: Presentation of an empty post list where the viewer is the owner
	 -->
	<xsl:template match="POST-LIST" mode="owner_morepostlistempty">
		<tr>
			<td class="body">
				<font xsl:use-attribute-sets="mainfont">
					<xsl:copy-of select="$m_forumownerempty"/>
				</font>
			</td>
		</tr>
	</xsl:template>
	<!--
	<xsl:template match="RECENT-POSTS" mode="viewer_morepostlistempty">
	Description: Presentation of an empty post list where the viewer is not the owner
	 -->
	<xsl:template match="POST-LIST" mode="viewer_morepostlistempty">
		<tr>
			<td class="body">
				<font xsl:use-attribute-sets="mainfont">
					<xsl:copy-of select="$m_forumviewerempty"/>
				</font>
			</td>
		</tr>
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
		<tr>
			<td>
				<table width="100%" cellpadding="5" cellspacing="0" border="0" class="post">
					<tr>
						<td class="head">
							<font xsl:use-attribute-sets="mainfont">
								<xsl:value-of select="$m_fromsite"/>
								<xsl:text> </xsl:text>
								<xsl:apply-templates select="SITEID" mode="t_morepostspage"/>
							</font>
						</td>
					</tr>
					<tr>
						<td class="body">
							<font xsl:use-attribute-sets="mainfont">
								<xsl:apply-templates select="THREAD/@THREADID" mode="t_morepostspagesubject"/>
								<br/>
								<xsl:apply-templates select="." mode="c_morepostspagepostdate"/>
								<br/>
						(<xsl:apply-templates select="." mode="c_morepostspagepostlastreply"/>)
						<br/>
								<xsl:apply-templates select="." mode="c_postunsubscribemorepostspage"/>
							</font>
						</td>
					</tr>
				</table>
			</td>
		</tr>
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
		<xsl:apply-imports/>
		<br/>
	</xsl:template>
	<!--
	<xsl:template match="POSTS" mode="r_nextmoreposts">
	Description: Presentation of the more link
	 -->
	<xsl:template match="POSTS" mode="r_nextmoreposts">
		<xsl:apply-imports/>
		<br/>
	</xsl:template>
</xsl:stylesheet>
