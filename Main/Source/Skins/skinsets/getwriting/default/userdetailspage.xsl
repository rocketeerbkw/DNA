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
	<xsl:with-param name="message">USERDETAILS_MAINBODY test variable = <xsl:value-of select="$current_article_type" /></xsl:with-param>
	<xsl:with-param name="pagename">userdetailspage.xsl</xsl:with-param>
	</xsl:call-template>
	<!-- DEBUG -->
	
	
	<!-- start of table -->
	<xsl:element name="table" use-attribute-sets="html.table.container">
	<tr>
	<xsl:element name="td" use-attribute-sets="column.1">
	<div class="PageContent">
		<xsl:apply-templates select="USER-DETAILS-UNREG" mode="c_userdetails"/>
		<xsl:apply-templates select="USER-DETAILS-FORM" mode="c_registered"/>
	</div>
	</xsl:element>
	<xsl:element name="td" use-attribute-sets="column.2">
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
		<div class="rightnavboxheaderhint">HINTS AND TIPS</div>
		<div class="rightnavbox">
		<xsl:copy-of select="$user.changescreenname.tips" />
		</div>
	</xsl:element>
		<br/>	
	</xsl:element>
	</tr>
	</xsl:element>
<!-- end of table -->	
	
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
	<input type="hidden" name="s_nickname" value="{USERNAME}" />		
	<div class="titleBarNavBgSmall">
	<div class="titleBarNav">
		<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
		CHANGE MY SCREENNAME
		</xsl:element>
	</div>
	</div>
	
		<xsl:if test="MESSAGE/@TYPE='detailsupdated'">
			<div class="box2">
				<xsl:element name="{$text.subheading}" use-attribute-sets="text.subheading">
				your screen name has been changed to: <strong>
				<xsl:value-of select="USERNAME"/></strong>
				</xsl:element>
			</div>
		</xsl:if>
	
		<div class="boxsection">
		<table border="0" cellspacing="0" cellpadding="0">
		<tr><td>
		<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
		<label for="userdetails-screenname"><div class="headinggeneric"><xsl:value-of select="$m_nickname"/></div></label>
		</xsl:element><br/>
		<xsl:element name="{$text.base}" use-attribute-sets="text.base">
			<xsl:apply-templates select="." mode="t_inputusername"/>
		</xsl:element>
		</td></tr>
		</table>
		</div>
		<div class="boxsection">
		<table border="0" cellspacing="0" cellpadding="0">
		<tr><td align="center">
		<xsl:apply-templates select="." mode="t_submituserdetails"/>
		</td></tr>
		</table>
		</div>
		<div class="boxactionback">
		<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
			<div class="arrow1"><xsl:apply-templates select="." mode="c_returntouserpage"/></div>
		</xsl:element>
		</div>
		
		

	</xsl:template>
	<!-- 
	<xsl:template match="USER-DETAILS-FORM" mode="r_skins">
	Use: Presentation for choosing the skins
	-->

	<xsl:template match="USER-DETAILS-FORM" mode="r_skins">

		r_skins	
		<xsl:value-of select="$m_skin"/>
		<xsl:apply-templates select="." mode="t_skinlist"/>
		
		<br/>
	</xsl:template>
	<!-- 
	<xsl:template match="USER-DETAILS-FORM" mode="r_usermode">
	Use: Presentation of the user mode drop down
	-->
	<xsl:template match="USER-DETAILS-FORM" mode="r_usermode">
		r user
		<xsl:value-of select="$m_usermode"/>
		<xsl:apply-templates select="." mode="t_usermodelist"/>
		<br/>
	</xsl:template>
	<!-- 
	<xsl:template match="USER-DETAILS-FORM" mode="r_forumstyle">
	Use: Presentation of the forum style dropdown
	-->
	<xsl:template match="USER-DETAILS-FORM" mode="r_forumstyle">
		forum
		<xsl:value-of select="$m_forumstyle"/>
		<xsl:apply-templates select="." mode="t_forumstylelist"/>
		<br/>
	</xsl:template>
	<!-- 
	<xsl:template match="USER-DETAILS-FORM" mode="restricted_registered">
	Use: Presentation if the viewer is a restricted user
	-->
	<xsl:template match="USER-DETAILS-FORM" mode="restricted_registered">
		restrict <xsl:call-template name="m_restricteduserpreferencesmessage"/>
	</xsl:template>
	<!-- 
	<xsl:template match="USER-DETAILS-FORM" mode="r_returntouserpage">
	Use: Links back to the user page
	-->
	<xsl:template match="USER-DETAILS-FORM" mode="r_returntouserpage">
		<xsl:apply-imports />
	</xsl:template>
	<!-- 
	<xsl:attribute-set name="fUSER-DETAILS-FORM_c_registered"/>
	Use: Extra presentation attributes for the user details form <form> element
	-->
	<xsl:attribute-set name="fUSER-DETAILS-FORM_c_registered" />
	<!-- 
	<xsl:attribute-set name="iUSER-DETAILS-FORM_t_inputusername"/>
	Use: Extra presentation attributes for the input screen name input box
	-->
	<xsl:attribute-set name="iUSER-DETAILS-FORM_t_inputusername">
		<xsl:attribute name="value"><xsl:value-of select="USERNAME"/></xsl:attribute>
		<xsl:attribute name="size">30</xsl:attribute>
		<xsl:attribute name="id">userdetails-screenname</xsl:attribute>
		<xsl:attribute name="class">userdetails-g</xsl:attribute>
		<xsl:attribute name="maxlength">20</xsl:attribute>
	</xsl:attribute-set>
	
	<!-- 
	<xsl:attribute-set name="iUSER-DETAILS-FORM_t_submituserdetails"/>
	Use: Extra presentation attributes for the user details form submit button
	-->
	<xsl:attribute-set name="iUSER-DETAILS-FORM_t_submituserdetails" use-attribute-sets="form.change"/>
</xsl:stylesheet>
