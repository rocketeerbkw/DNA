<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<xsl:import href="../../../base/base-registerpage.xsl"/>
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
									Page - Level  template
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<xsl:template name="NEWREGISTER_MAINBODY">
	<!-- 	first time = <xsl:value-of select="/H2G2/NEWREGISTER/FIRSTTIME" /> -->
	<!-- DEBUG -->
	<xsl:call-template name="TRACE">
	<xsl:with-param name="message">NEWREGISTER_MAINBODY</xsl:with-param>
	<xsl:with-param name="pagename">registerpage.xsl</xsl:with-param>
	</xsl:call-template>
	<!-- DEBUG -->
	<br />
		<font xsl:use-attribute-sets="mainfont">
			<xsl:apply-templates select="NEWREGISTER" mode="c_page"/>
		</font>
	</xsl:template>

	<!--
	<xsl:template match="NEWREGISTER" mode="postcode_page">
	Use: Page for inserting a user's postcode
	 -->
	<xsl:template match="NEWREGISTER" mode="postcode_page">
		<xsl:apply-templates select="POSTCODE" mode="c_insertpostcode"/>
	</xsl:template>
	<!--
	<xsl:template match="POSTCODE" mode="r_insertpostcode">
	Use: Incorrect postcode message
	 -->
	<xsl:template match="POSTCODE" mode="r_insertpostcode">
		<b>Please enter your postcode:</b>
		<xsl:apply-templates select="BADPOSTCODE" mode="c_error"/>
		<br/>
		<xsl:apply-templates select="." mode="t_postcodeinput"/>
		<xsl:apply-templates select="." mode="t_postcodesubmit"/>
	</xsl:template>
	<!--
	<xsl:template match="BADPOSTCODE" mode="r_error">
	Use: Page that redirects the viewer's userpage
	 -->
	<xsl:template match="BADPOSTCODE" mode="r_error">
		You entered an incorrect postcode, please try again:
	</xsl:template>
	<!--
	<xsl:template match="NEWREGISTER" mode="welcomeback_page">
	Use: Page that redirects the viewer's userpage
	 -->
	<xsl:template match="NEWREGISTER" mode="welcomeback_page">
		<xsl:apply-templates select="." mode="t_metaredirectuserpage"/>
		<xsl:copy-of select="$m_regwaittransfer"/>
	</xsl:template>
	
	<!--
	<xsl:template match="NEWREGISTER" mode="welcome_page">
	Use: Page that redirects to the welcome named article page (or postcode page if appropriate)
	 -->
	<xsl:template match="NEWREGISTER" mode="welcome_page">
		<xsl:apply-templates select="." mode="t_metaredirectwelcomepage"/>
		<xsl:call-template name="m_regwaitwelcomepage"/>
	</xsl:template>
	
	<!-- override base file -->
	<xsl:template match="NEWREGISTER" mode="t_metaredirectwelcomepage">
		<meta http-equiv="refresh" content="0;url={$root}U{/H2G2/VIEWING-USER/USER/USERID}?s_display=register"/>
	</xsl:template>
	<!-- override base file -->
	<xsl:template name="m_regwaitwelcomepage">
		<p>Please wait while we transfer you to the next registration page
		or <a xsl:use-attribute-sets="nm_regwaitwelcomepage" href="{$root}U{/H2G2/VIEWING-USER/USER/USERID}?s_display=register">click here</a> if nothing happens after a few seconds.</p>
	</xsl:template>
	
	<!--
	<xsl:template match="NEWREGISTER" mode="passthrough_page">
	Use: Displayed as the interim page between Single Sign on and whatever it was the user 
	was doing before single sign on       
	 -->
	<xsl:template match="NEWREGISTER" mode="passthrough_page">
		<xsl:apply-templates select="." mode="t_passthroughmessage"/>
		<xsl:apply-templates select="REGISTER-PASSTHROUGH" mode="c_pagetype"/>
	</xsl:template>
	<!--
	<xsl:template match="REGISTER-PASSTHROUGH" mode="postforum_pagetype">
	Use: Provides link back to addthread page
	 -->
	<xsl:template match="REGISTER-PASSTHROUGH" mode="postforum_pagetype">
		<xsl:apply-imports/>
	</xsl:template>
	<!--
	<xsl:template match="REGISTER-PASSTHROUGH" mode="postforum_pagetype">
	Use: Provides link back to create a club page page
	 -->
	<xsl:template match="REGISTER-PASSTHROUGH" mode="createclub_pagetype">
		<xsl:apply-imports/>
	</xsl:template>
	<!--
	<xsl:template match="REGISTER-PASSTHROUGH" mode="postforum_pagetype">
	Use: Provides link back to create an article page
	 -->
	<xsl:template match="REGISTER-PASSTHROUGH" mode="createarticle_pagetype">
		<xsl:apply-imports/>
	</xsl:template>
	<!--
	<xsl:template match="REGISTER-PASSTHROUGH" mode="postforum_pagetype">
	Use: Provides link back to add vote page
	 -->
	<xsl:template match="REGISTER-PASSTHROUGH" mode="vote_pagetype">
		<xsl:apply-imports/>
	</xsl:template>
	<!--
	<xsl:template match="REGISTER-PASSTHROUGH" mode="addnotice_pagetype">
	Use: Provides link back to add notice page
	 -->
	<xsl:template match="REGISTER-PASSTHROUGH" mode="addnotice_pagetype">
		<xsl:apply-imports/>
	</xsl:template>
	
	
	

	
</xsl:stylesheet>