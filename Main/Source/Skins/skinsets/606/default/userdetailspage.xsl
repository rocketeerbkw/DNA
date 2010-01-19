<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<xsl:import href="../../../base/base-userdetailspage.xsl"/>
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
									Page - Level  template
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<xsl:template name="USERDETAILS_MAINBODY">
	
	<!-- DEBUG -->
	<xsl:call-template name="TRACE">
		<xsl:with-param name="message">USERDETAILS_MAINBODY</xsl:with-param>
		<xsl:with-param name="pagename">userdetailspage.xsl</xsl:with-param>
	</xsl:call-template>
	<!-- DEBUG -->
		<div id="mainbansec">
			<div class="banartical"><h3>Change your nickname</h3></div>
			<xsl:call-template name="SEARCHBOX" />
			
			<div class="clear"></div>
			<div class="searchline"><div></div></div>
		</div>
		
	
		<div class="mainbodysec">
		<div class="bodysec">	
		
			<div class="bodytext">
				<p><xsl:apply-templates select="USER-DETAILS-UNREG" mode="c_userdetails"/>
				<xsl:apply-templates select="USER-DETAILS-FORM" mode="c_registered"/></p>			
			</div>
			
		</div><!-- / bodysec -->	
		<div class="additionsec">	
			
		</div><!-- /  additionsec -->	
		 
		 
	<div class="clear"></div>
	</div><!-- / mainbodysec -->

	<!--[FIXME: remove]	
	<xsl:if test="/H2G2/@TYPE='ARTICLE'">
		<xsl:call-template name="ADVANCED_SEARCH" />
	</xsl:if>
	-->
	
	
	
	
			
		
	</xsl:template>
	<!-- 
	<xsl:template match="USER-DETAILS-UNREG" mode="r_userdetails">
	Use: Presentation of the user details form if the viewer is unregistered
	-->
	<xsl:template match="USER-DETAILS-UNREG" mode="r_userdetails">
		<xsl:apply-templates select="MESSAGE"/>
		<xsl:call-template name="m_unregprefsmessage"/>
	</xsl:template>
	
	<!-- 
	<xsl:template match="USER-DETAILS-FORM" mode="normal_registered">
	Use: Presentation of the user details form
	-->
	<xsl:template match="USER-DETAILS-FORM" mode="normal_registered">
		
		<p><strong>Member name</strong> -  
		<xsl:choose>
			<xsl:when test="/H2G2/SITE/IDENTITYSIGNIN = 0">
				<xsl:value-of select="/H2G2/VIEWING-USER/SSO/SSOLOGINNAME"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="/H2G2/VIEWING-USER/SIGNINNAME" />
			</xsl:otherwise>
		</xsl:choose><br />
		<strong><xsl:value-of select="$m_nickname"/></strong> - <xsl:apply-templates select="." mode="t_inputusername"/></p>
		
		
		<xsl:if test="$test_IsEditor">
		<div class="editbox" style="margin-top:10px;">
			<xsl:apply-templates select="." mode="c_usermode"/>
		</div>
		</xsl:if>
		
		
		<p><xsl:apply-templates select="." mode="t_submituserdetails"/></p>
		
		<p><xsl:apply-templates select="." mode="c_returntouserpage"/></p>
	</xsl:template>
	<!-- 
	<xsl:template match="USER-DETAILS-FORM" mode="r_skins">
	Use: Presentation for choosing the skins
	-->
	<xsl:template match="USER-DETAILS-FORM" mode="r_skins">
		<xsl:value-of select="$m_skin"/>
		<xsl:apply-templates select="." mode="t_skinlist"/>
		<br/>
	</xsl:template>
	<!-- 
	<xsl:template match="USER-DETAILS-FORM" mode="r_usermode">
	Use: Presentation of the user mode drop down
	-->
	<xsl:template match="USER-DETAILS-FORM" mode="r_usermode">
		<xsl:value-of select="$m_usermode"/>
		<xsl:apply-templates select="." mode="t_usermodelist"/>
		<br/>
	</xsl:template>
	<!-- 
	<xsl:template match="USER-DETAILS-FORM" mode="r_forumstyle">
	Use: Presentation of the forum style dropdown
	-->
	<xsl:template match="USER-DETAILS-FORM" mode="r_forumstyle">
		<xsl:value-of select="$m_forumstyle"/>
		<xsl:apply-templates select="." mode="t_forumstylelist"/>
		<br/>
	</xsl:template>
	<!-- 
	<xsl:template match="USER-DETAILS-FORM" mode="restricted_registered">
	Use: Presentation if the viewer is a restricted user
	-->
	<xsl:template match="USER-DETAILS-FORM" mode="restricted_registered">
		<xsl:call-template name="m_restricteduserpreferencesmessage"/>
	</xsl:template>
	<!-- 
	<xsl:template match="USER-DETAILS-FORM" mode="r_returntouserpage">
	Use: Links back to the user page
	-->
	<xsl:template match="USER-DETAILS-FORM" mode="r_returntouserpage">
		<xsl:apply-imports/>
	</xsl:template>
	<!-- 
	<xsl:attribute-set name="fUSER-DETAILS-FORM_c_registered"/>
	Use: Extra presentation attributes for the user details form <form> element
	-->
	<xsl:attribute-set name="fUSER-DETAILS-FORM_c_registered"/>
	<!-- 
	<xsl:attribute-set name="iUSER-DETAILS-FORM_t_inputusername"/>
	Use: Extra presentation attributes for the input screen name input box
	-->
	<xsl:attribute-set name="iUSER-DETAILS-FORM_t_inputusername"/>
	<!-- 
	<xsl:attribute-set name="iUSER-DETAILS-FORM_t_submituserdetails"/>
	Use: Extra presentation attributes for the user details form submit button
	-->
	<xsl:attribute-set name="iUSER-DETAILS-FORM_t_submituserdetails"/>
</xsl:stylesheet>
