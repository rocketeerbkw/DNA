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
	<!-- DEBUG -->
	<xsl:call-template name="TRACE">
	<xsl:with-param name="message">NEWREGISTER_MAINBODY test variable = <xsl:value-of select="$current_article_type" /></xsl:with-param>
	<xsl:with-param name="pagename">registerpage.xsl</xsl:with-param>
	</xsl:call-template>
	<!-- DEBUG -->
	
	<div class="errorpage">
	<b>
	<xsl:element name="{$text.base}" use-attribute-sets="text.base">
	<xsl:apply-templates select="NEWREGISTER" mode="c_page"/>
	</xsl:element>
	</b>
	</div>

		
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
	
		<div class="errorpage">
		<b>
		<xsl:element name="{$text.base}" use-attribute-sets="text.base">
		<xsl:apply-templates select="." mode="t_metaredirectuserpage"/>
		<xsl:copy-of select="$m_regwaittransfer"/>
		</xsl:element>
		</b>
		</div>
		
	</xsl:template>
	<!--
	<xsl:template match="NEWREGISTER" mode="welcome_page">
	Use: Page that redirects to the welcome named article page (or postcode page if appropriate)
	 -->
	<xsl:template match="NEWREGISTER" mode="welcome_page">
		<div class="errorpage">
		<b>
		<xsl:element name="{$text.base}" use-attribute-sets="text.base">
	<!-- 	<xsl:apply-templates select="." mode="t_metaredirectwelcomepage"/>
		<xsl:call-template name="m_regwaitwelcomepage"/> -->
		</xsl:element>
		</b>
		</div>
	
	<xsl:apply-templates select="." mode="t_metaredirectuserpage"/>

	</xsl:template>
	<!--
	<xsl:template match="NEWREGISTER" mode="passthrough_page">
	Use: Displayed as the interim page between Single Sign on and whatever it was the user 
	was doing before single sign on       
	 -->
	<xsl:template match="NEWREGISTER" mode="passthrough_page">
		<div class="errorpage">
		<b>
		<xsl:element name="{$text.base}" use-attribute-sets="text.base">
		 <xsl:apply-templates select="." mode="t_passthroughmessage"/><br/>
		 
		 <!-- see m_ptclicktostartnewconv, m_clicktowritearticle, $m_ptclicktoleaveprivatemessage, m_ptclicktowritereply -->
		<br/>Or else you can <xsl:apply-templates select="REGISTER-PASSTHROUGH" mode="c_pagetype"/>
		</xsl:element>
		</b>
		</div>
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
