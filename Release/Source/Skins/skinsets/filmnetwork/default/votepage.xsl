<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
	<!ENTITY space "<xsl:text xmlns:xsl='http://www.w3.org/1999/XSL/Transform'> </xsl:text>">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<xsl:import href="../../../base/base-votepage.xsl"/>
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
									Page - Level  template
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<xsl:variable name="m_votename">Vote: </xsl:variable>
	<xsl:template name="VOTE_MAINBODY">
		<font xsl:use-attribute-sets="mainfont">
			<xsl:apply-templates select="VOTING-PAGE" mode="c_vote"/>
		</font>
	</xsl:template>
	<!--
	<xsl:template match="VOTING-PAGE" mode="add_vote">
	Use: Template invoked after vote has been initiated, the user is required to specify whether its a register
	         vote or not
	 -->
	<xsl:template match="VOTING-PAGE" mode="add_vote">
		<xsl:copy-of select="$m_votename"/>
		<xsl:value-of select="VOTENAME"/>
		<xsl:choose>
			<xsl:when test="RESPONSE=1">
				Support
			</xsl:when>
			<xsl:otherwise>
				Oppose
			</xsl:otherwise>
		</xsl:choose>
		<xsl:apply-templates select="." mode="c_votetype"/>
		<xsl:apply-templates select="OBJECT" mode="t_returntoobject"/>
		<xsl:apply-templates select="VOTINGUSERS" mode="c_vote"/>
	</xsl:template>
	<!--
	<xsl:template match="VOTING-PAGE" mode="voteclosed_votetype">
	Use: Message displayed after a vote has closed
	 -->
	<xsl:template match="VOTING-PAGE" mode="voteclosed_votetype">Vote is now closed</xsl:template>
	<!--
	<xsl:template match="VOTING-PAGE" mode="alreadyvoted_votetype">
	Use: Message displayed when the user has previously voted
	 -->
	<xsl:template match="VOTING-PAGE" mode="alreadyvoted_votetype">You have already voted</xsl:template>
	<!--
	<xsl:template match="VOTING-PAGE" mode="loggedin_votetype">
	Use: Template invoked if the user submitted a vote as a logged in user
	 -->
	<xsl:template match="VOTING-PAGE" mode="loggedin_votetype">
		Display: <xsl:value-of select="USER/USERNAME"/>
		<xsl:apply-templates select="." mode="t_displayradio"/>
		<br/>
		Do not display your name but register your vote <xsl:apply-templates select="." mode="t_hideradio"/>
		<br/>
		<xsl:apply-templates select="." mode="t_submitvoteloggedin"/>
	</xsl:template>
	<!--
	<xsl:template match="VOTING-PAGE" mode="loggedout_votetype">
	Use: Template invoked if the user submitted a vote as an unregistered user
	 -->
	<xsl:template match="VOTING-PAGE" mode="loggedout_votetype">
		<!--xsl:apply-templates select="." mode="t_signinradio"/-->
		<b>
			<a href="{$sso_novotesigninlink}">SIGN IN</a> or <a href="{$sso_novoteregisterlink}">REGISTER</a>
		</b> to display your name.<br/>
		<xsl:apply-templates select="." mode="t_anonymousradio"/>
		Do not display your name, but register your vote.<br/>
		<br/>
		<xsl:apply-templates select="." mode="t_submitvoteloggedout"/>
	</xsl:template>
	<!--
	<xsl:template match="VOTING-PAGE" mode="finish_vote">	
	Use: Template invoked after user has specified whether its a registered vote or not - 
	        contains a list of other voters
	 -->
	<xsl:template match="VOTING-PAGE" mode="finish_vote">
		 Vote:<xsl:value-of select="VOTING-PAGE/VOTENAME"/> (Page 2 of 2)
		<xsl:choose>
			<xsl:when test="RESPONSE = 1">
				Support
			</xsl:when>
			<xsl:otherwise>
				Against
			</xsl:otherwise>
		</xsl:choose>
		<br/>
		<xsl:apply-templates select="OBJECT" mode="t_returntoobject"/>
		<br/>
		<br/>
		<xsl:apply-templates select="VOTINGUSERS" mode="c_vote"/>
	</xsl:template>
	<!--
	<xsl:template match="VOTING-PAGE" mode="unknown_vote">
	Use: error message
	 -->
	<xsl:template match="VOTING-PAGE" mode="unknown_vote">
		Uknown vote action given
	</xsl:template>
	<!--
	<xsl:template match="VOTING-PAGE" mode="error_vote">
	Use: error message
	 -->
	<xsl:template match="VOTING-PAGE" mode="error_vote">
		<xsl:apply-imports/>

	</xsl:template>
	<!--
	<xsl:template match="VOTINGUSERS" mode="r_vote">
	Use: Template holding the list of registered voters and the number of hidden voters that had the same
	         vote as the viewer
	 -->
	<xsl:template match="VOTINGUSERS" mode="r_vote">
		<xsl:apply-templates select="VISIBLEUSERS" mode="c_list"/>
		<xsl:apply-templates select="HIDDENUSERS" mode="c_list"/>
	</xsl:template>
	<!--
	<xsl:template match="VISIBLEUSERS" mode="full_list">
	Use: Template invoked if there is at least one registered voter
	 -->
	<xsl:template match="VISIBLEUSERS" mode="full_list">
		Other voters:<br/>
		<xsl:apply-templates select="USER" mode="c_voted"/>
		<br/>
	</xsl:template>
	<!--
	<xsl:template match="USER" mode="r_voted">
	Use: Presentation of one single registered user
	 -->
	<xsl:template match="USER" mode="r_voted">
		<xsl:apply-imports/>
		<br/>
	</xsl:template>
	<!--
	<xsl:template match="VISIBLEUSERS" mode="empty_list">
	Use: Template invoked if there are no registered voters
	 -->
	<xsl:template match="VISIBLEUSERS" mode="empty_list">
		No other voters
		<br/>
	</xsl:template>
	<!--
	<xsl:template match="HIDDENUSERS" mode="full_list">
	Use: Template invoked when there is at least one unregistered voter
	 -->
	<xsl:template match="HIDDENUSERS" mode="full_list">
		Anonymous voters:
		<xsl:value-of select="@COUNT"/>
		<br/>
	</xsl:template>
	<!--
	<xsl:template match="HIDDENUSERS" mode="empty_list">
	Use: Template invoked if there are no unregistered voters
	 -->
	<xsl:template match="HIDDENUSERS" mode="empty_list">
		No anonymous voters<br/>
	</xsl:template>
	<!--
	<xsl:attribute-set name="fVOTING-PAGE_c_votetype"/>
	Use: Extra presentation attributes for the submit vote <form> html element
	 -->
	<xsl:attribute-set name="fVOTING-PAGE_c_votetype"/>
	<!--
	<xsl:attribute-set name="iVOTING-PAGE_t_displayradio"/>
	Use: Extra presentation attributes for the 'display your name' radio button
	 -->
	<xsl:attribute-set name="iVOTING-PAGE_t_displayradio"/>
	<!--
	<xsl:attribute-set name="iVOTING-PAGE_t_hideradio"/>
	Use: Extra presentation attributes for the 'anonymous vote' radio button
	 -->
	<xsl:attribute-set name="iVOTING-PAGE_t_hideradio"/>
	<!--
	<xsl:attribute-set name="iVOTING-PAGE_t_signinradio"/>
	Use: Extra presentation attributes for the 'sign in for a registered vote' radio button
	 -->
	<xsl:attribute-set name="iVOTING-PAGE_t_signinradio"/>
	<!--
	<xsl:attribute-set name="iVOTING-PAGE_t_anonymousradio"/>
	Use: Extra presentation attributes for 'anonymous vote' radio button when not logged in
	 -->
	<xsl:attribute-set name="iVOTING-PAGE_t_anonymousradio"/>
	<!--
	<xsl:attribute-set name="iVOTING-PAGE_t_submitvoteloggedin"/>
	Use: Extra presentation attributes for 'submit vote' button when logged in
	 -->
	<xsl:attribute-set name="iVOTING-PAGE_t_submitvoteloggedin"/>
	<!--
	<xsl:attribute-set name="iVOTING-PAGE_t_submitvoteloggedout"/>
	Use: Extra presentation attributes for 'submit vote' button when not logged in
	 -->
	<xsl:attribute-set name="iVOTING-PAGE_t_submitvoteloggedout"/>
</xsl:stylesheet>
