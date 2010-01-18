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

			<div class="generic-c">
				<xsl:call-template name="box.crumb">
					<xsl:with-param name="box.crumb.href" select="concat($root,'U',/H2G2/VIEWING-USER/USER/USERID)" />
					<xsl:with-param name="box.crumb.value">my space</xsl:with-param>
					<xsl:with-param name="box.crumb.title">edit my screen name</xsl:with-param>
				</xsl:call-template>
			</div>
	
	<xsl:apply-templates select="USER-DETAILS-UNREG" mode="c_userdetails"/>
	<xsl:apply-templates select="USER-DETAILS-FORM" mode="c_registered"/>
			
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
		<input type="hidden" name="clear_templates" value="1"/>	

			<xsl:call-template name="box.heading">
				<xsl:with-param name="box.heading.value">
					<xsl:choose>
					<xsl:when test="MESSAGE/@TYPE='detailsupdated'"><xsl:value-of select="/H2G2/PARAMS/PARAM/VALUE"/></xsl:when>
					<xsl:otherwise><xsl:apply-templates select="USERNAME" /></xsl:otherwise>
					</xsl:choose>
				</xsl:with-param>
			</xsl:call-template>

			<xsl:call-template name="box.step">
				<xsl:with-param name="box.step.title">changing your screen name</xsl:with-param>
				<xsl:with-param name="box.step.text">We recommend that you keep your screen name the same as your member name (the one you signed in with). However, if you feel strongly about changing your name, use the box below.</xsl:with-param>
			</xsl:call-template>		

		<xsl:if test="MESSAGE/@TYPE='detailsupdated'">
			<div class="useredit-u-a">
				<xsl:element name="{$text.subheading}" use-attribute-sets="text.subheading">
				<strong class="white">your screen name has been changed to: <xsl:value-of select="USERNAME"/></strong>
				</xsl:element>
			</div>
		</xsl:if>

		<div class="form-wrapper">
		<table cellspacing="0" cellpadding="4" border="0">
		<tr><td class="form-label">
		<xsl:copy-of select="$icon.step.one" />&nbsp;
		<xsl:element name="{$text.base}" use-attribute-sets="text.base">
		<label for="userdetails-screenname" class="label-a"><xsl:value-of select="$m_nickname"/></label>
		</xsl:element>
		</td><td>
		<xsl:element name="{$text.base}" use-attribute-sets="text.base">
			<xsl:apply-templates select="." mode="t_inputusername"/>
		</xsl:element>
		</td></tr>
		<tr><td></td><td><xsl:apply-templates select="." mode="t_submituserdetails"/></td></tr>
		</table>
		</div>


		<xsl:if test="$test_IsEditor">		
<!--  TODO - required ?		<xsl:apply-templates select="." mode="c_skins"/>
		<xsl:apply-templates select="." mode="c_usermode"/>
		<xsl:apply-templates select="." mode="c_forumstyle"/> -->
		</xsl:if>
		
		<div class="myspace-b">
		<xsl:copy-of select="$arrow.right" />&nbsp;
		<xsl:element name="{$text.base}" use-attribute-sets="text.base">
			<xsl:apply-templates select="." mode="c_returntouserpage"/>
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
		<font size="2"><xsl:apply-imports /></font>
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
		<xsl:attribute name="size">10</xsl:attribute>
		<xsl:attribute name="id">userdetails-screenname</xsl:attribute>
		<xsl:attribute name="class">userdetails-g</xsl:attribute>
		<xsl:attribute name="maxlength">20</xsl:attribute>
	</xsl:attribute-set>
	
	<!-- 
	<xsl:attribute-set name="iUSER-DETAILS-FORM_t_submituserdetails"/>
	Use: Extra presentation attributes for the user details form submit button
	-->
	<xsl:attribute-set name="iUSER-DETAILS-FORM_t_submituserdetails">
		<xsl:attribute name="type">image</xsl:attribute><!-- TODO add widths etc.. -->
		<xsl:attribute name="src"><xsl:value-of select="$imagesource" />buttons/send.gif</xsl:attribute>
	</xsl:attribute-set>


</xsl:stylesheet>
