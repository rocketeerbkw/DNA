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
	<xsl:with-param name="message">JOURNAL_MAINBODY</xsl:with-param>
	<xsl:with-param name="pagename">journalpage.xsl</xsl:with-param>
	</xsl:call-template>
	<!-- DEBUG -->
	
	

		<table cellpadding="0" cellspacing="0" border="0">
		<tr>
<!-- column 1 -->
		<xsl:element name="td" use-attribute-sets="column.1">
		<div class="PageContent">
		
     	<div class="prevnextbox">
		<table width="390" border="0" cellspacing="0" cellpadding="0">
		<tr>
		<td><xsl:apply-templates select="JOURNAL" mode="c_prevjournalpage"/></td>
		<td align="right"><xsl:apply-templates select="JOURNAL" mode="c_nextjournalpage"/></td>
		</tr>
		</table>
		</div>
	
		<xsl:apply-templates select="JOURNAL" mode="c_journalpage"/>
	
		<div class="prevnextbox">
		<table width="390" border="0" cellspacing="0" cellpadding="0">
		<tr>
		<td><xsl:apply-templates select="JOURNAL" mode="c_prevjournalpage"/></td>
		<td align="right"><xsl:apply-templates select="JOURNAL" mode="c_nextjournalpage"/></td>
		</tr>
		</table>
		</div>

		<div class="boxactionback">
		<div class="arrow1">
			<xsl:element name="{$text.base}" use-attribute-sets="text.base">
			<xsl:choose>
			<xsl:when test="/H2G2/FORUMSOURCE/@TYPE='clubjournal'"><a href="G{/H2G2/FORUMSOURCE/CLUB/@ID}">back to this group's page</a></xsl:when>
<xsl:otherwise><!-- m_backtoresearcher -->
			<xsl:apply-templates select="JOURNAL" mode="t_userpagelinkjournalpage"/></xsl:otherwise>
			</xsl:choose>
			
			
			
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
	
		<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">	
		<div class="rightnavboxheaderhint">HINTS AND TIPS</div>
		<div class="rightnavbox">
		<xsl:copy-of select="$journal.tips" />
		</div>
		</xsl:element>
		
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
		<table width="390" border="0" cellspacing="0" cellpadding="0">
			<tr><td class="boxheading">
			<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
				<b><a xsl:use-attribute-sets="maTHREADID_JournalEntryReplies">
				<xsl:attribute name="HREF"><xsl:value-of select="$root"/>F<xsl:value-of select="../../@FORUMID"/>?thread=<xsl:value-of select="@THREADID"/></xsl:attribute>
				<xsl:value-of select="SUBJECT"/>
				</a></b>
				
			</xsl:element>
			</td><td align="right" class="boxheading">
			<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
				<xsl:choose>
				<xsl:when test="/H2G2/FORUMSOURCE/@TYPE='clubjournal'">&nbsp;discussion</xsl:when>
				<xsl:otherwise>&nbsp;weblog </xsl:otherwise>
				</xsl:choose>
			<xsl:value-of select="count(preceding-sibling::POST) + 1" />
			</xsl:element>
			</td></tr>
			<tr>
			<td colspan="2">
			<div class="boxback">
				<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
				published <xsl:apply-templates select="DATEPOSTED/DATE" mode="t_datejournalposted"/> | <xsl:apply-templates select="LASTREPLY" mode="c_lastjournalrepliesup"/>
				</xsl:element><br/>
				
				<xsl:element name="{$text.base}" use-attribute-sets="text.base">
				<xsl:apply-templates select="TEXT" mode="t_journalpage"/>
				</xsl:element>
			</div>
			</td>		
			</tr>
			<tr>
			<td class="boxactionback">
			<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
			<xsl:copy-of select="$arrow.right" />
			<!-- view comment --><a xsl:use-attribute-sets="maTHREADID_JournalEntryReplies"><xsl:attribute name="HREF"><xsl:value-of select="$root"/>F<xsl:value-of select="../../@FORUMID"/>?thread=<xsl:value-of select="@THREADID"/></xsl:attribute>view</a> and <xsl:apply-templates select="@POSTID" mode="t_discussjournalentry"/>
			</xsl:element>
			</td>
			<td align="right" class="boxactionback"><a href="UserComplaint?PostID={@POSTID}" target="ComplaintPopup" onClick="popupwindow('UserComplaint?PostID={@POSTID}', 'ComplaintPopup', 'status=1,resizable=1,scrollbars=1,width=640,height=480')" xsl:use-attribute-sets="maHIDDEN_r_complainmp"><xsl:copy-of select="$alt_complain"/></a></td>
			</tr>
		</table><br/>
		
		<!-- EDIT AND MODERATION HISTORY -->
		<xsl:if test="$test_IsEditor">
		<div class="moderationbox">
		<div align="right"><img src="{$graphics}icons/icon_editorsedit.gif" alt="" width="23" height="21" border="0" align="left"/>
		<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
		<xsl:apply-templates select="@POSTID" mode="c_editmp"/>
		<xsl:text>  </xsl:text> | <xsl:text>  </xsl:text>
		<xsl:apply-templates select="@POSTID" mode="c_linktomoderate"/>
		</xsl:element>
		</div>
		</div>
		</xsl:if>

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
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	
		<xsl:choose>
		<xsl:when test="JOURNALPOSTS[@SKIPTO &gt; 0]">
		
			<xsl:copy-of select="$arrow.right" />
			<div class="genericlink">
			<xsl:apply-templates select="." mode="r_prevjournalpage"/>
			</div>
			
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
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
		<xsl:choose>
		<xsl:when test="JOURNALPOSTS[@MORE=1]">
		
			<xsl:copy-of select="$arrow.right" />
			<div class="genericlink">
			<xsl:apply-templates select="." mode="r_nextjournalpage"/>
			</div>
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
