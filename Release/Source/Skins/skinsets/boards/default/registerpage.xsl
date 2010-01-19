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
		<font xsl:use-attribute-sets="mainfont">
			<xsl:apply-templates select="NEWREGISTER" mode="c_page"/>
			<xsl:apply-templates select="ERROR" mode="c_error"/>
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
		<!--<xsl:apply-templates select="." mode="t_metaredirectuserpage"/>
		<xsl:copy-of select="$m_regwaittransfer"/>-->
		<xsl:variable name="returnto">
			<xsl:choose>
				<xsl:when test="/H2G2/PARAMS/PARAM[NAME='s_return']/VALUE = 'logout'">
					<xsl:value-of select="$homepage"/>
				</xsl:when>
				<xsl:when test="/H2G2/PARAMS/PARAM[NAME='s_return']/VALUE = ''">
					<xsl:value-of select="$homepage"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="/H2G2/PARAMS/PARAM[NAME='s_return']/VALUE"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<meta http-equiv="refresh" content="0;url={$returnto}"/>
		<p>You are now signed into BBCi</p>
		<p>The page will automatically take you back to the message boards, or you can use the following link</p>
		<p>
			<a href="{$returnto}">Return to the message boards</a>
		</p>
	</xsl:template>
	<!--
	<xsl:template match="NEWREGISTER" mode="welcome_page">
	Use: Page that redirects to the welcome named article page (or postcode page if appropriate)
	 -->
	<xsl:template match="NEWREGISTER" mode="welcome_page">
		<!--<xsl:apply-templates select="." mode="t_metaredirectwelcomepage"/>
		<xsl:call-template name="m_regwaitwelcomepage"/>-->
		<p>You have successfully created your BBCi Membership.</p>
		<p>
			<a href="{$root}{/H2G2/PARAMS/PARAM[NAME='s_return']/VALUE}">Return to the message boards</a>
		</p>
		<p>Or, if you are new to message boards, you may want to read our <a href="http://www.bbc.co.uk/messageboards/newguide/popup_faq_index.html" onclick="popupwindow('http://www.bbc.co.uk/messageboards/newguide/popup_faq_index.html', 'popwin', 'status=1,resizable=1,scrollbars=1,width=440,height=380');return false;" target="popwin" title="This link opens in a new popup window">help page</a>
		</p>
	</xsl:template>
	<!--
	<xsl:template match="NEWREGISTER" mode="passthrough_page">
	Use: Displayed as the interim page between Single Sign on and whatever it was the user 
	was doing before single sign on       
	 -->
	<xsl:template match="NEWREGISTER" mode="passthrough_page">
		<!--<xsl:apply-templates select="." mode="t_passthroughmessage"/>-->
		<xsl:choose>
			<xsl:when test="not(/H2G2/VIEWING-USER/USER)">
				<p>You are not signed into bbc.co.uk</p>
			</xsl:when>
			<xsl:otherwise>
				<p>You are now signed into bbc.co.uk</p>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:apply-templates select="REGISTER-PASSTHROUGH" mode="c_pagetype"/>
		<p>Or, if you are new to message boards, you may want to read our <a href="http://www.bbc.co.uk/messageboards/newguide/popup_faq_index.html" onclick="popupwindow('http://www.bbc.co.uk/messageboards/newguide/popup_faq_index.html', 'popwin', 'status=1,resizable=1,scrollbars=1,width=440,height=380');return false;" target="popwin" title="This link opens in a new popup window">help page</a>
		</p>
	</xsl:template>
	<!--
	<xsl:template match="REGISTER-PASSTHROUGH" mode="editdetails_pagetype">
	Use: Page displayed when user is returning from editing SSO details
	 -->
	<xsl:template match="REGISTER-PASSTHROUGH" mode="editdetails_pagetype">
		<xsl:variable name="returnto">
			<xsl:choose>
				<xsl:when test="/H2G2/PARAMS/PARAM[NAME='s_return']/VALUE = 'logout'">
					<xsl:value-of select="$homepage"/>
				</xsl:when>
				<xsl:when test="/H2G2/PARAMS/PARAM[NAME='s_return']/VALUE = ''">
					<xsl:value-of select="$homepage"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="/H2G2/PARAMS/PARAM[NAME='s_return']/VALUE"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<meta http-equiv="refresh" content="0;url={$returnto}"/>
		<p>
			<xsl:apply-imports/>
		</p>
		<p>The page will automatically take you back to the message boards, or you can use the following link</p>
		<p>
			<a href="{$returnto}">Return to the message boards</a>
		</p>
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
	<xsl:template match="ERROR" mode="r_error">
		<xsl:apply-imports/>
	</xsl:template>
</xsl:stylesheet>
