<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">
	
	<doc:documentation>
		<doc:purpose>
			Displays the SSO sign in / sign out typically found on user generated pages. 
		</doc:purpose>
		<doc:context>
			Called on request by skin
		</doc:context>
		<doc:notes>
			
		</doc:notes>
	</doc:documentation>
	
	<xsl:template match="LINKTOSIGNIN[/H2G2/SITE/IDENTITYSIGNIN = 1]" mode="library_siteconfig_inline">
		<xsl:param name="ptrt"/>
		<a class="id-cta">
			<xsl:call-template name="library_memberservice_require">
				<xsl:with-param name="ptrt" select="$ptrt"/>
			</xsl:call-template>
			<xsl:value-of select="."/>
		</a>
	</xsl:template>
	
	<xsl:template match="LINKTOSIGNIN" mode="library_siteconfig_inline">
		<a>
			<xsl:attribute name="href">
				<xsl:apply-templates select="/H2G2/SITE/SSOSERVICE" mode="library_sso_loginurl" />
			</xsl:attribute>
			<xsl:value-of select="."/>
		</a>
	</xsl:template>
	
	<xsl:template match="USERNAME" mode="library_siteconfig_inline">
		<xsl:apply-templates select="/H2G2/VIEWING-USER/USER" mode="library_user_morecomments" >
			<xsl:with-param name="url" select="/H2G2/PARAMS/PARAM[NAME = 's_commentprofileurl']/VALUE"/>
			<xsl:with-param name="additional-classnames">
				<xsl:apply-templates select="/H2G2/VIEWING-USER/USER" mode="library_user_notables"/>
			</xsl:with-param>
		</xsl:apply-templates>
		
	</xsl:template>
	
	<xsl:template match="LINKTOSIGNOUT[/H2G2/SITE/IDENTITYSIGNIN = 1]" mode="library_siteconfig_inline">
		<a>
			<xsl:attribute name="href">
				<xsl:apply-templates select="/H2G2/VIEWING-USER" mode="library_identity_logouturl" />
			</xsl:attribute>
			<xsl:value-of select="."/>
		</a>
	</xsl:template>
	
	<xsl:template match="LINKTOSIGNOUT" mode="library_siteconfig_inline">
		<a>
			<xsl:attribute name="href">
				<xsl:apply-templates select="/H2G2/SITE/SSOSERVICE" mode="library_sso_logouturl" />
			</xsl:attribute>
			<xsl:value-of select="."/>
		</a>
	</xsl:template>
	
	<xsl:template match="LINKTOREGISTER[/H2G2/SITE/IDENTITYSIGNIN = 1]" mode="library_siteconfig_inline">
		<xsl:param name="ptrt"/>
		<a>
			<!--<xsl:call-template name="library_memberservice_require">
				<xsl:with-param name="ptrt" select="$ptrt"/>
				</xsl:call-template>-->
			<xsl:attribute name="href">
				<xsl:apply-templates select="/H2G2/VIEWING-USER" mode="library_memberservice_registerurl">
					<xsl:with-param name="ptrt" select="$ptrt"/>
				</xsl:apply-templates>
			</xsl:attribute>
			<xsl:value-of select="."/>
		</a>
	</xsl:template>
	
	<xsl:template match="LINKTOREGISTER" mode="library_siteconfig_inline">
		<a>
			<xsl:attribute name="href">
				<xsl:apply-templates select="/H2G2/SITE/SSOSERVICE" mode="library_sso_registerurl" />
			</xsl:attribute>
			<xsl:value-of select="."/>
		</a>
	</xsl:template>
	
	<xsl:template match="LINKTOSIGNIN[/H2G2/SITE/IDENTITYSIGNIN = 1]" mode="library_siteconfig_inline_unauthorised">
		<xsl:param name="ptrt"/>
		<a class="id-cta">
			<xsl:call-template name="library_memberservice_require">
				<xsl:with-param name="ptrt" select="$ptrt"/>
			</xsl:call-template>
			Click here to complete your registration.
		</a>
	</xsl:template>
	
	<xsl:template match="LINKTOSIGNIN" mode="library_siteconfig_inline_unauthorised">
		<a>
			<xsl:attribute name="href">
				<xsl:apply-templates select="/H2G2/SITE/SSOSERVICE" mode="library_sso_loginurl" />
			</xsl:attribute>
			Click here to complete your registration.
		</a>
	</xsl:template>
	
	<xsl:template match="A | a" mode="library_siteconfig_inline">
		<xsl:choose>
			<!-- Why are people not setting up their sites correctly? Tsh. -->
			<xsl:when test="@HREF = '#' or @href = '#'">
				<a class="popup" href="http://www.bbc.co.uk/messageboards/newguide/popup_checking_messages.html">
					<xsl:value-of select="."/>
				</a>
			</xsl:when>
			<xsl:otherwise>
				<a>
					<xsl:if test="@HREF | @href">
						<xsl:attribute name="href">
							<xsl:value-of select="@HREF | @href"/>
						</xsl:attribute>
					</xsl:if>
					<xsl:if test="@CLASS | @class">
						<xsl:attribute name="class">
							<xsl:value-of select="@CLASS | @class"/>
						</xsl:attribute>
					</xsl:if>
					<xsl:value-of select="."/>
				</a>
			</xsl:otherwise>
		</xsl:choose>
		
	</xsl:template>
	
	<xsl:template match="SPAN | span" mode="library_siteconfig_inline">
		<span style="{@style}">
			<xsl:apply-templates select="." mode="library_siteconfig_inline" />
		</span>
	</xsl:template>
	
</xsl:stylesheet>