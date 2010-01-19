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
	<xsl:with-param name="message">NEWREGISTER_MAINBODY</xsl:with-param>
	<xsl:with-param name="pagename">registerpage.xsl</xsl:with-param>
	</xsl:call-template>
	<!-- DEBUG -->
	
		<xsl:choose>
			<xsl:when test="/H2G2/@TYPE='NEWREGISTER' and not(/H2G2/NEWREGISTER) and /H2G2/VIEWING-USER/USER/USERID and (/H2G2/PARAMS/PARAM[NAME = 's_return']/VALUE = 'logout' or not(/H2G2/PARAMS/PARAM[NAME = 's_return']/VALUE/text()))">
			 <!-- redirect users that have just added this site as one of the services 
				(i.e have logged in to the site for the first time but are already have SS0 membership for another website 
				
				note: this is a bit of a hack as they isn't a flag for this type of user journey
				example url is:
				http://dnadev.national.core.bbc.co.uk/dna/606/SSO?s_return=logout&ssorl=1154534179&ssols=13&ssoc=addservice
				There is no NEWREGISTER present
			
			-->	
				<meta http-equiv="refresh" content="0;url={$root}U{/H2G2/VIEWING-USER/USER/USERID}?s_display=register"/>
				<xsl:call-template name="m_regwaitwelcomepage"/>
			</xsl:when>
			<xsl:when test="/H2G2/PARAMS/PARAM[NAME='s_return']/VALUE/text() and (not(/H2G2/PARAMS/PARAM[NAME='s_return']/VALUE/text()='logout') and not(/H2G2/PARAMS/PARAM[NAME='s_return']/VALUE/text()='register'))">
				<meta http-equiv="refresh" content="0;url={$root}{/H2G2/PARAMS/PARAM[NAME='s_return']/VALUE}"/>
				<p>Please wait while we <a href="{$root}{/H2G2/PARAMS/PARAM[NAME='s_return']/VALUE}">return you to the page you were on</a></p>
			</xsl:when>
			<xsl:otherwise>
				<font xsl:use-attribute-sets="mainfont">
					<xsl:apply-templates select="NEWREGISTER" mode="c_page"/>
				</font>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>


	<!--
		overide from base-registerpage.xsl
		this was put in as a fix for the base skins which are different
		on dnadev and staging/live.
		
		1. Don't login (or sign-out if you are logged in) 
		2. Click on Profiles (lhn) 
		3. View any Profile 
		4. Click on Create a Player Profile (rhn) 
		5. now taken to SSO login page  - click go back to 606
		6. you arrive at http://www.bbc.co.uk/dna/606/SSO?pa=editpage&amp;pt=category&amp;category=&amp;pt=type&amp;type=11&amp;ssorl=1173787628&amp;ssoc=login
	-->	
	<xsl:template match="NEWREGISTER" mode="c_page">
		<xsl:choose>
			<xsl:when test="POSTCODE">
				<form action="{$root}SSO" method="post">
					<input type="hidden" name="ssoc" value="postcode"/>
					<xsl:apply-templates select="." mode="postcode_page"/>
				</form>
			</xsl:when>
			<xsl:when test="@STATUS = 'NOTSIGNEDIN' or @STATUS = 'NOTLOGGEDIN'">
				<xsl:apply-templates select="." mode="notsignedin_page"/>
			</xsl:when>
			<xsl:when test="@STATUS='ASSOCIATED' or @STATUS='LOGGEDIN' or REGISTER-PASSTHROUGH">
				<xsl:choose>
					<xsl:when test="REGISTER-PASSTHROUGH">
						<xsl:apply-templates select="." mode="passthrough_page"/>
					</xsl:when>
					<xsl:when test="FIRSTTIME=0">
						<xsl:apply-templates select="." mode="welcomeback_page"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="." mode="welcome_page"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			
		</xsl:choose>
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
	
	
	
	<!-- over riding base files -->
	<xsl:template match="NEWREGISTER" mode="notsignedin_page">
		<p><xsl:choose>
			<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_return']/VALUE = 'register'">
		<!-- to do: insert meta refrech to the cps homepage -->
			You chose not to register
			<meta http-equiv="refresh" content="0;url={$cpshome}"/>
			</xsl:when>
			<xsl:when test="/H2G2/VIEWING-USER/SSO/SSOLOGINNAME">You are not currently signed in to this site. <a href="{$sso_signinlink}">Sign in</a>.</xsl:when>
			<xsl:otherwise>We were unable to sign you in at this time</xsl:otherwise>
		</xsl:choose></p>
		
		<!-- to do: insert the CPS homepage instead of /dna/606 -->
		
		<a href="{$cpshome}">
			<img src="{$sso_assets}/images/buttons/servicespecific/go_back_to_service.gif" alt="Go Back to homepage" border="0"/>
		</a>
	</xsl:template>
	
</xsl:stylesheet>
