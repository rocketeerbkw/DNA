<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
	<!ENTITY space "<xsl:text xmlns:xsl='http://www.w3.org/1999/XSL/Transform'> </xsl:text>">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<xsl:import href="../../../base/base-usermyclubspage.xsl"/>
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
									Page - Level  template
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	
	<xsl:template name="USERMYCLUBS_MAINBODY">
	<!-- DEBUG -->
	<xsl:call-template name="TRACE">
	<xsl:with-param name="message">USERMYCLUBS_MAINBODY<xsl:value-of select="$current_article_type" /></xsl:with-param>
	<xsl:with-param name="pagename">usermyclubspage.xsl</xsl:with-param>
	</xsl:call-template>
	<!-- DEBUG -->

	
	<!-- start of table -->
	<xsl:element name="table" use-attribute-sets="html.table.container">
	<tr>
	<xsl:element name="td" use-attribute-sets="column.1">
		
	<xsl:apply-templates select="USERMYCLUBS/CLUBREVIEWS" mode="c_umcpage"/>
			
	</xsl:element>
	<xsl:element name="td" use-attribute-sets="column.2">
		<div class="box">
		<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
		<strong>MEMBERSHIP BULLETIN</strong><br/>
		<a href="{$root}U{/H2G2/VIEWING-USER/USER/USERID}?s_view=myactivity">check on waiting lists</a><br/>
<a href="{$root}U{/H2G2/VIEWING-USER/USER/USERID}?s_view=myactivity">check on membership decisions</a><br/>
		<a href="{$root}U{/H2G2/VIEWING-USER/USER/USERID}?s_view=myactivity">check for offers</a><br/>
		<a href="{$root}U{/H2G2/VIEWING-USER/USER/USERID}?s_view=myactivity">all my groups</a>
		</xsl:element>
		</div>
		
	<xsl:apply-templates select="USERMYCLUBS/CLUBSSUMMARY" mode="c_umcpage"/>
	
	</xsl:element>
	</tr>
	</xsl:element>
	<!-- end of table -->	
	
	</xsl:template>
	<!--
	<xsl:template match="CLUBSSUMMARY" mode="r_umcpage">
	Use: Display of the summary list of the user's clubs
	 -->
	<xsl:template match="CLUBSSUMMARY" mode="r_umcpage">
		<div class="box">
		<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
		<strong>ALL MY GROUP'S LIST</strong><br/>		
		<xsl:apply-templates select="CLUB" mode="c_clubsummary"/>
		</xsl:element>
		</div>
	</xsl:template>
	<!--
	<xsl:template match="CLUB" mode="r_clubsummary">
	Use: Display of the summary of the club in the list
	 -->
	<xsl:template match="CLUB" mode="r_clubsummary">
	<xsl:value-of select="NAME"/><br/>
	<a href="{$root}umc?s_view={@ID}"><xsl:copy-of select="$button.admin" /></a><br/>
	<!-- <xsl:apply-templates select="NAME" mode="t_clubsummary"/>
	<xsl:apply-templates select="ACTIVITY" mode="t_clubsummary"/> -->
	</xsl:template>
	<!--
	<xsl:template match="CLUBREVIEWS" mode="c_umcpage">
	Use: Display of the club reviews section of the page
	 -->
	<xsl:template match="CLUBREVIEWS" mode="c_umcpage">
	<!-- <xsl:value-of select="$m_clubreviewtitle"/> -->
	
		<xsl:choose>
		<xsl:when test="/H2G2/PARAMS/PARAM/NAME='s_view'">
		
		<xsl:apply-templates select="CLUB[/H2G2/PARAMS/PARAM/VALUE=@ID]" mode="c_clubreview"/>
	<!-- 	<xsl:apply-templates select="CLUB/PENDING" mode="r_myactions"/> -->
		</xsl:when>
		<xsl:otherwise>
		<xsl:apply-templates select="CLUB" mode="c_clubreview"/>
		</xsl:otherwise>
		</xsl:choose>

	</xsl:template>
	<!--
	<xsl:template match="CLUB" mode="r_clubreview">
	Use: Display of the individual clubs within the review section of the page
	 -->
	<xsl:template match="CLUB" mode="r_clubreview">
		<div class="box">
			<strong><xsl:apply-templates select="NAME" mode="t_clubreview"/></strong><br/>
			<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
			Admin page for Members<br/><br/>
			<xsl:apply-templates select="." mode="t_viewclub"/>
			</xsl:element>
		</div>
		<br/>
		<xsl:apply-templates select="MEMBERSHIPSTATUS" mode="c_clubreview"/>
		<br/>
		<xsl:apply-templates select="ACTIONS" mode="c_clubreview"/>
		
		<!-- 
		<xsl:apply-templates select="COMMENTS" mode="c_clubreview"/>
		<xsl:apply-templates select="MEMBERS" mode="c_clubreview"/>
		<xsl:apply-templates select="CURRENTROLE" mode="c_clubreview"/> 
		
		<xsl:apply-templates select="." mode="t_editclub"/>
		-->

	</xsl:template>
	<!--
	<xsl:template match="MEMBERS" mode="r_clubreview">
	Use: Display of the members totals within the club review
	 -->
	<xsl:template match="MEMBERS" mode="r_clubreview">
		<xsl:value-of select="$m_memberstitle"/>
		<br/>
		<xsl:apply-templates select="NEW" mode="c_members"/>
		<xsl:apply-templates select="ALL" mode="c_members"/>
		<br/>
	</xsl:template>
	<!--
	<xsl:template match="NEW" mode="r_members">
	Use: Display of the new members total within the club review
	 -->
	<xsl:template match="NEW" mode="r_members">
		<xsl:value-of select="$m_membersnewtitle"/>
		<xsl:value-of select="."/>
		<xsl:text> | </xsl:text>
	</xsl:template>
	<!--
	<xsl:template match="ALL" mode="r_members">
	Use: Display of the all members total within the club review
	 -->
	<xsl:template match="ALL" mode="r_members">
		<xsl:value-of select="$m_membersalltitle"/>
		<xsl:value-of select="."/>
	</xsl:template>
	<!--
	<xsl:template match="COMMENTS" mode="r_clubreview">
	Use: Display of the comments totals within the club review
	 -->
	<xsl:template match="COMMENTS" mode="r_clubreview">
		<xsl:value-of select="$m_commentstitle"/>
		<br/>
		<xsl:apply-templates select="NEW" mode="c_comments"/>
		<xsl:apply-templates select="ALL" mode="c_comments"/>
		<br/>
	</xsl:template>
	<!--
	<xsl:template match="NEW" mode="r_comments">
	Use: Display of the new comments total within the club review
	 -->
	<xsl:template match="NEW" mode="r_comments">
		<xsl:value-of select="$m_commentsnewtitle"/>
		<xsl:value-of select="."/>
		<xsl:text> | </xsl:text>
	</xsl:template>
	<!--
	<xsl:template match="ALL" mode="r_comments">
	Use: Display of the all comments total within the club review
	 -->
	<xsl:template match="ALL" mode="r_comments">
		<xsl:value-of select="$m_commentsalltitle"/>
		<xsl:value-of select="."/>
	</xsl:template>
	<!--
	<xsl:template match="MEMBERSHIPSTATUS" mode="r_clubreview">
	Use: Display of the users membership status within the club review
	 -->
	<xsl:template match="MEMBERSHIPSTATUS" mode="r_clubreview">
		<xsl:variable name="status">
		<xsl:choose>
		<xsl:when test=".='Supporter'">
		member
		</xsl:when>
		<xsl:otherwise>
		owner
		</xsl:otherwise>
		</xsl:choose>
		</xsl:variable>
	
	
		<strong>Edit Member Status</strong><br/>
		<div class="box">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
		<td>
		<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
		<strong><xsl:value-of select="$m_statustitle"/>:</strong> I am a <xsl:value-of select="$status" /> of this group.</xsl:element><br/><br/>
		</td>
		</tr>
		<tr>
		<td><xsl:apply-templates select="." mode="c_changestatus"/></td>
		</tr>
		</table>
		</div>
	</xsl:template>
	<!--
	<xsl:template match="MEMBERSHIPSTATUS" mode="c_changestatus">
	Author:		Andy Harris
	Context:      H2G2/USERMYCLUBS/CLUBREVIEWS/CLUB/MEMBERSHIPSTATUS
	Purpose:	 Calls the container for the change membership status object
	-->
	<xsl:template match="MEMBERSHIPSTATUS" mode="c_changestatus">
		<form action="{$root}G{../@ID}" xsl:use-attribute-set="fMEMBERSHIPSTATUS_c_changestatus">
			<input type="hidden" name="userid" value="{/H2G2/VIEWING-USER/USER/USERID}"/>
			<xsl:apply-templates select="." mode="r_changestatus"/>
		</form>
	</xsl:template>
	
		<!--
	<xsl:template match="MEMBERSHIPSTATUS" mode="c_changestatus">
	Use: Display of the change users membership status within the club review
	 -->
	<xsl:template match="MEMBERSHIPSTATUS" mode="r_changestatus">
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
		<td><xsl:apply-templates select="." mode="t_changestatuslist"/>	</td>
		<td><xsl:apply-templates select="." mode="t_changestatussubmit"/></td>
		</tr>
	</table>
	</xsl:template>
	
	<!--
	<xsl:template match="MEMBERSHIPSTATUS" mode="r_changestatus">
	Author:		Andy Harris
	Context:      H2G2/USERMYCLUBS/CLUBREVIEWS/CLUB/MEMBERSHIPSTATUS
	Purpose:	 Creates the link to change the users status
	-->
	<xsl:template match="MEMBERSHIPSTATUS" mode="t_changestatuslist">
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
		<xsl:choose>
			<xsl:when test=". = 'Owner'">
			<input type="radio" name="action" value="ownerresignsmember" /> become a member<br/>
			<input type="radio" name="action" value="ownerresignscompletely" />leave club<br/>
			</xsl:when>
			<xsl:otherwise>
			<input type="radio" name="action" value="joinowner" />request to become owner<br/>
			<input type="radio" name="action" value="memberresigns" />leave club<br/>
			</xsl:otherwise>
		</xsl:choose>
		</xsl:element>
	</xsl:template>
	
	<xsl:attribute-set name="fMEMBERSHIPSTATUS_c_changestatus"/>
	<xsl:attribute-set name="sMEMBERSHIPSTATUS_t_changestatuslist"/>
	<xsl:attribute-set name="oMEMBERSHIPSTATUS_t_changestatuslist"/>

	<!--
	<xsl:template match="CURRENTROLE" mode="r_clubreview">
	Use: Display of the users current role within the club review
	 -->
	<xsl:template match="CURRENTROLE" mode="r_clubreview">
		<xsl:value-of select="$m_roletitle"/>
		<br/>
		<xsl:value-of select="."/>
		<xsl:apply-templates select="." mode="c_changerole"/>
	</xsl:template>
	<!--
	<xsl:template match="CURRENTROLE" mode="r_changerole">
	Use: Display of the change users current role within the club review
	 -->
	<xsl:template match="CURRENTROLE" mode="r_changerole">
		<xsl:value-of select="$m_changerole"/>
		<xsl:text>: </xsl:text>
		<xsl:apply-templates select="." mode="t_inputrole"/>
		<xsl:text> | </xsl:text>
		<xsl:apply-templates select="." mode="t_submit"/>
	</xsl:template>
	<!--
	<xsl:attribute-set name="fCURRENTROLE_c_changerole"/>
	Use: Attribute set for the change role form
	 -->
	<xsl:attribute-set name="fCURRENTROLE_c_changerole"/>
	<!--
	<xsl:attribute-set name="iCURRENTROLE_t_inputrole">
	Use: Attribute set for the change role input element
	 -->
	<xsl:attribute-set name="iCURRENTROLE_t_inputrole">
		<xsl:attribute name="type">text</xsl:attribute>
	</xsl:attribute-set>
	<!--
	<xsl:attribute-set name="iCURRENTROLE_t_submit">
	Use: Attribute set for the change role submit element
	 -->
	<xsl:attribute-set name="iCURRENTROLE_t_submit">
		<xsl:attribute name="type">submit</xsl:attribute>
	</xsl:attribute-set>
	<!--
	<xsl:template match="ACTIONS" mode="r_clubreview">
	Use: Display of the clubs actions within the club review
	 -->
	<xsl:template match="ACTIONS" mode="r_clubreview">
	<!-- <xsl:apply-templates select="PENDING" mode="c_actions"/> -->
	<xsl:apply-templates select="COMPLETED" mode="c_actions"/>
	</xsl:template>
	<!--
	<xsl:template match="PENDING" mode="r_actions">
	Use: Display of the clubs pending actions within the club review
	 -->
	<xsl:template match="PENDING" mode="r_actions">
	<div class="boxheader"><strong><xsl:value-of select="$m_pendingtitle"/></strong></div>
	<table>
	<xsl:apply-templates select="ACTION" mode="c_actions"/>
	</table>
	</xsl:template>
	
	<!--
	<xsl:template match="PENDING" mode="r_actions">
	Use: Display of the clubs pending actions within the club review
	 -->
	<xsl:template match="PENDING" mode="r_myactions">
	<div class="boxheader"><strong>My pending approval</strong></div>
	<table>
	<xsl:apply-templates select="ACTION[OWNERID=/H2G2/VIEWING-USER/USER/USERID]" mode="c_actions"/>
	</table>
	</xsl:template>
	
	<!--
	<xsl:template match="COMPLETED" mode="r_actions">
	Use: Display of the clubs completed actions within the club review
	 -->
	<xsl:template match="COMPLETED" mode="r_actions">
	<strong><xsl:value-of select="$m_completedtitle"/></strong><br/>
	<div class="box">
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
	<td>
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	<strong>MEMBERS'S NAME</strong>
	</xsl:element>
	</td>
	<td>
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	<strong>ACTION</strong>
	</xsl:element>
	</td>
	<!-- <td>ACTION BY</td> -->
	<td>
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	<strong>DATE</strong>
	</xsl:element>
	</td>
	</tr>
	<xsl:apply-templates select="ACTION" mode="c_actions"/>
	</table>
	</div>
	</xsl:template>
	<!--
	<xsl:template match="ACTION" mode="r_actions">
	Use: Display of the individual actions within the club review
	 -->
	<xsl:template match="ACTION" mode="r_actions">
	<tr>
		<td>
		<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
		<xsl:apply-templates select="OWNER" mode="t_actions"/>
		</xsl:element>
		</td>
		<td>
		<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
			<xsl:choose>
			<xsl:when test="@NAME='joinmember'">
				<xsl:copy-of select="$m_joinmember3rdperson"/>
			</xsl:when>
			<xsl:when test="@NAME='joinowner'">
				<xsl:copy-of select="$m_joinownerviewer3rdperson"/>
			</xsl:when>
			<xsl:when test="@NAME='invitemember'">
				<xsl:copy-of select="$m_invitemember3rdperson"/>
			</xsl:when>
			<xsl:when test="@NAME='inviteowner'">
				<xsl:copy-of select="$m_inviteowner3rdperson"/>
			</xsl:when>
			<xsl:when test="@NAME='ownerresignsmember'">
				<xsl:copy-of select="$m_ownerresignsmember3rdperson"/>
			</xsl:when>
			<xsl:when test="@NAME='ownerresignscompletely'">
				<xsl:copy-of select="$m_ownerresignscompletely3rdperson"/>
			</xsl:when>
			<xsl:when test="@NAME='memberresigns'">
				<xsl:copy-of select="$m_memberresigns3rdperson"/>
			</xsl:when>
			<xsl:when test="@NAME='demoteownertomember'">
				<xsl:copy-of select="$m_demoteownertomember3rdperson"/>
			</xsl:when>
			<xsl:when test="@NAME='removeowner'">
				<xsl:copy-of select="$m_removeowner3rdperson"/>
			</xsl:when>
			<xsl:when test="@NAME='removemember'">
				<xsl:copy-of select="$m_removemember3rdperson"/>
			</xsl:when>
		</xsl:choose>
		</xsl:element>
		</td>
		<td>
		<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
		<xsl:apply-templates select="POSTDATE" mode="t_actions"/>
		</xsl:element>
		</td>
	</tr>
	</xsl:template>
</xsl:stylesheet>
