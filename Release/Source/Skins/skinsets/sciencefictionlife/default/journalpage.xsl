<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
	<!ENTITY space "<xsl:text xmlns:xsl='http://www.w3.org/1999/XSL/Transform'> </xsl:text>">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<xsl:import href="../../../base/base-journalpage.xsl"/>
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
									Page - Level  template
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<xsl:template name="JOURNAL_MAINBODY">
	
	<!-- DEBUG -->
	<xsl:call-template name="TRACE">
	<xsl:with-param name="message">JOURNAL_MAINBODY<xsl:value-of select="$current_article_type" /></xsl:with-param>
	<xsl:with-param name="pagename">journalpage.xsl</xsl:with-param>
	</xsl:call-template>
	<!-- DEBUG -->
	
		<xsl:call-template name="box.heading">
			<xsl:with-param name="box.heading.value"><xsl:value-of select="JOURNAL/JOURNALPOSTS/POST/USER/USERNAME"/></xsl:with-param>			
		</xsl:call-template>

		<div class="myspace-b-b">
			<xsl:copy-of select="$myspace.weblog.white" />&nbsp;
			<xsl:element name="{$text.subheading}" use-attribute-sets="text.subheading"><strong>all <xsl:value-of select="$m_memberormy"/> weblog</strong></xsl:element>
		</div>

		<table cellpadding="0" cellspacing="0" border="0">
		<tr>
<!-- column 1 -->
		<xsl:element name="td" use-attribute-sets="column.1">

		<div class="next-back" align="center">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
		<td><xsl:apply-templates select="JOURNAL" mode="c_prevjournalpage"/></td>
		<td align="right"><xsl:apply-templates select="JOURNAL" mode="c_nextjournalpage"/></td>
		</tr>
		</table>
		</div>
	
		<xsl:apply-templates select="JOURNAL" mode="c_journalpage"/>
	
		<div class="next-back" align="center">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
		<td><xsl:apply-templates select="JOURNAL" mode="c_prevjournalpage"/></td>
		<td align="right"><xsl:apply-templates select="JOURNAL" mode="c_nextjournalpage"/></td>
		</tr>
		</table>
		</div>

		<div class="myspace-b">
			<xsl:element name="{$text.base}" use-attribute-sets="text.base">
			<xsl:copy-of select="$arrow.right" />
			<xsl:apply-templates select="JOURNAL" mode="t_userpagelinkjournalpage"/>
			</xsl:element>
		</div>

		<br />
		<xsl:element name="img" use-attribute-sets="column.spacer.1" />
		</xsl:element>
		<xsl:element name="td" use-attribute-sets="column.3"><xsl:element name="img" use-attribute-sets="column.spacer.3" /></xsl:element>
		<xsl:element name="td" use-attribute-sets="column.2">
		
			
	<!-- rss feed link -->
	<div class="rssModule">
	<xsl:element name="A">
<xsl:attribute name="HREF"><xsl:value-of select="$root" />xml/MJ<xsl:value-of select="/H2G2/JOURNAL/@USERID"/>?Journal=<xsl:value-of select="/H2G2/JOURNAL/JOURNALPOSTS/@FORUMID"/>&amp;s_xml=rss</xsl:attribute>
<img src="{$graphics}icons/logo_rss.gif" alt="RSS" class="mr10" border="0"/>	
</xsl:element><xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall"><a  href="http://www.bbc.co.uk/dna/collective/A5319380">What is RSS?</a></xsl:element>
	</div>
	<!-- end rss feed link -->
		
		<div class="morepost-h">
			<div class="myspace-r">
				<xsl:element name="{$text.subheading}" use-attribute-sets="text.subheading">
					<strong class="white">key</strong>
				</xsl:element>
				<br />
				<xsl:element name="{$text.base}" use-attribute-sets="text.base">
					<xsl:copy-of select="$complain.orange" /> : <strong class="white">alert the moderators</strong>
				</xsl:element>
			</div>
		</div>
		<br />
		<div class="morepost-h">
			<div class="myspace-r">
				<xsl:copy-of select="$myspace.tips" />&nbsp;
				<xsl:element name="{$text.subheading}" use-attribute-sets="text.subheading">
					<strong class="white">hints and tips</strong>
				</xsl:element>
			</div>
			<xsl:copy-of select="$tips_myweblog" />
		</div><br />
		<xsl:element name="img" use-attribute-sets="column.spacer.2" />
		</xsl:element>
		</tr>
		</table>		
	</xsl:template>














	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
					JOURNAL Logical Container Template
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<!-- 
	<xsl:template match="JOURNAL" mode="r_journalpage">
	Use: Container for the JOURNAL object
	-->
	<xsl:template match="JOURNAL" mode="r_journalpage">
		<xsl:apply-templates select="JOURNALPOSTS" mode="c_journalpage"/>
	</xsl:template>
	<!-- 
	<xsl:template match="JOURNALPOSTS" mode="r_journalpage">
	Use: Container for the JOURNALPOSTS object
	-->
	<xsl:template match="JOURNALPOSTS" mode="r_journalpage">
		<xsl:apply-templates select="POST" mode="c_journalpage"/>
	</xsl:template>
	<!-- 
	<xsl:template match="POST" mode="r_journalpage">
	Use: Template for the POST object
	-->
	<xsl:template match="POST" mode="r_journalpage">
	<!-- TITLE -->


	<div class="myspace-e-4">
		<table cellspacing="0" cellpadding="0" border="0" width="395">
			<tr><td>
			<xsl:element name="{$text.base}" use-attribute-sets="text.base">
				&nbsp;<strong>weblog <xsl:value-of select="count(preceding-sibling::POST) + 1" /></strong>
			</xsl:element>
			</td><td class="orange" align="right">
			<xsl:element name="{$text.base}" use-attribute-sets="text.base">
				published <xsl:apply-templates select="DATEPOSTED/DATE" mode="t_datejournalposted"/> | <xsl:apply-templates select="LASTREPLY" mode="c_lastjournalrepliesup"/>
			</xsl:element>
			</td></tr></table>
			</div>
	<!-- blog title -->					
		<div class="myspace-j">
			<xsl:element name="{$text.base}" use-attribute-sets="text.base">
				<a xsl:use-attribute-sets="maTHREADID_JournalEntryReplies">
				<xsl:attribute name="HREF"><xsl:value-of select="$root"/>F<xsl:value-of select="../../@FORUMID"/>?thread=<xsl:value-of select="@THREADID"/></xsl:attribute>
				<xsl:value-of select="SUBJECT"/>
				</a>
			</xsl:element>
		</div>	
	<div class="myspace-b">
		<xsl:element name="{$text.base}" use-attribute-sets="text.base">
		<xsl:apply-templates select="TEXT" mode="t_journalpage"/>
			</xsl:element>
	</div>
	<!-- blog buttons -->
	<div class="myspace-h">
		<table cellspacing="0" cellpadding="0" border="0" width="395"><tr><td>
		<xsl:element name="{$text.base}" use-attribute-sets="text.base">
		<xsl:copy-of select="$arrow.right" />
		<!-- view comment --><a xsl:use-attribute-sets="maTHREADID_JournalEntryReplies"><xsl:attribute name="HREF"><xsl:value-of select="$root"/>F<xsl:value-of select="../../@FORUMID"/>?thread=<xsl:value-of select="@THREADID"/></xsl:attribute>view</a> and <xsl:apply-templates select="@POSTID" mode="t_discussjournalentry"/>
		</xsl:element>
			</td>
		<td align="right"><a href="UserComplaint?PostID={@POSTID}" target="ComplaintPopup" onClick="popupwindow('UserComplaint?PostID={@POSTID}', 'ComplaintPopup', 'status=1,resizable=1,scrollbars=1,width=640,height=480')" xsl:use-attribute-sets="maHIDDEN_r_complainmp"><xsl:copy-of select="$complain.brown"/></a></td></tr></table>
	</div>	
	<!--
	<div class="bodytext"><xsl:apply-templates select="@THREADID" mode="c_removelinkjournalpage"/></div>
	-->
	</xsl:template>








	<!-- 
	<xsl:template match="LASTREPLY" mode="replies_journalpage">
	Use: Template for the LASTREPLY object if there are replies
	-->
	<xsl:template match="LASTREPLY" mode="replies_journalpage">
		<xsl:apply-templates select="@COUNT" mode="t_journalpage"/>
		
		<!-- <xsl:copy-of select="$m_lastreplyjournalpage"/>
		<xsl:apply-templates select="DATE" mode="t_journalpage"/> -->
	</xsl:template>
	<!-- 
	<xsl:template match="LASTREPLY" mode="noreplies_journalpage">
	Use: Template for the LASTREPLY object if theere are no replies
	-->
	<xsl:template match="LASTREPLY" mode="noreplies_journalpage">
		<xsl:copy-of select="$m_norepliesjournalpage"/>
	</xsl:template>
	<!-- 
	<xsl:template match="@THREADID" mode="r_removelinkjournalpage">
	Use: Template for the 'Remove the posts' link
	-->
	<xsl:template match="@THREADID" mode="r_removelinkjournalpage">
		<xsl:apply-imports/>
		<br/>
	</xsl:template>
	<!-- 
	<xsl:template match="JOURNAL" mode="r_prevjournalpage">
	Use: Template for the 'Previous posts' link
	-->
	<xsl:template match="JOURNAL" mode="r_prevjournalpage">
		<xsl:apply-imports/>
	</xsl:template>
	<!--
	<xsl:template match="JOURNAL" mode="c_prevjournalpage">
	Author:		Andy Harris
	Context:      /H2G2/JOURNAL
	Purpose:	 Calls the container for the 'Previous' link if necessary 
	-->
	<xsl:template match="JOURNAL" mode="c_prevjournalpage">
	<xsl:element name="{$text.base}" use-attribute-sets="text.base">
		<xsl:choose>
		<xsl:when test="JOURNALPOSTS[@SKIPTO &gt; 0]">
			<xsl:copy-of select="$arrow.right" /><xsl:apply-templates select="." mode="r_prevjournalpage"/>
		</xsl:when>
		<xsl:otherwise>
			<xsl:copy-of select="$m_newerjournalentries"/>
		</xsl:otherwise>
		</xsl:choose>
	</xsl:element>
	</xsl:template>
	<!--
	<xsl:template match="JOURNAL" mode="c_nextjournalpage">
	Author:		Andy Harris
	Context:      /H2G2/JOURNAL
	Purpose:	 Calls the container for the 'Next' link if necessary 
	-->
	<xsl:template match="JOURNAL" mode="c_nextjournalpage">
	<xsl:element name="{$text.base}" use-attribute-sets="text.base">
		<xsl:choose>
		<xsl:when test="JOURNALPOSTS[@MORE=1]">
			<xsl:copy-of select="$arrow.right" /><xsl:apply-templates select="." mode="r_nextjournalpage"/>
		</xsl:when>
		<xsl:otherwise>
			<xsl:copy-of select="$m_olderjournalentries"/>
		</xsl:otherwise>
		</xsl:choose>
	</xsl:element>
	</xsl:template>
	<!-- 
	<xsl:template match="JOURNAL" mode="r_nextjournalpage">
	Use: Template for the 'Next posts' link
	-->
	<xsl:template match="JOURNAL" mode="r_nextjournalpage">
		<xsl:apply-imports/>
		<br/>
	</xsl:template>
</xsl:stylesheet>
