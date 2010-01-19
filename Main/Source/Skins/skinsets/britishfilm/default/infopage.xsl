<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-	microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<xsl:import href="../../../base/base-infopage.xsl"/>
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
									Page - Level  template
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<xsl:template name="INFO_MAINBODY">
		
	<!-- DEBUG -->
	<xsl:call-template name="TRACE">
		<xsl:with-param name="message">INFO_MAINBODY</xsl:with-param>
		<xsl:with-param name="pagename">infopage.xsl</xsl:with-param>
	</xsl:call-template>
	<!-- DEBUG -->
	
	
	
		<!-- title and search -->
		<div id="mainbansec">	
			<div class="banartical"><h3>
				<xsl:choose>
					<xsl:when test="INFO/@MODE='articles'">Most recently created articles</xsl:when>
					<xsl:when test="INFO/@MODE='conversations'">Most recently comments</xsl:when>
				</xsl:choose>
			</h3></div>				
			<div class="clear"></div>
			<div class="searchline"><div></div></div>
		</div>
	
		<div class="mainbodysec">
		<div class="bodysec">
			<xsl:call-template name="MOREARTICLES_NAV"/>
			<xsl:apply-templates select="INFO" mode="c_info"/>
			<xsl:call-template name="MOREARTICLES_NAV"/>
		</div><!-- / bodysec -->	
		<div class="additionsec">
			<div class="getinvolved"><h3>WANT TO GET INVOLVED?</h3></div>
			<hr/>
		</div><!-- /  additionsec -->
		</div>
		
	</xsl:template>
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
							INFO Object
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<!--
	<xsl:template match="INFO" mode="r_info">
	Description: Presentation of the object holding the four different INFO blocks, the 
		TOTALREGUSERS and the APPROVEDENTRIES info with their respective text
	 -->
	<xsl:template match="INFO" mode="r_info">
	
		<p><xsl:choose>
			<xsl:when test="TOTALREGUSERS"><!-- info?cmd=tru -->
				<strong>
					<xsl:value-of select="$m_totalregusers"/>
				</strong>
				<br/>
				<strong><xsl:value-of select="TOTALREGUSERS"/></strong>
				<xsl:text> </xsl:text>
				<xsl:value-of select="$m_usershaveregistered"/>
				</xsl:when>
			<xsl:when test="APPROVEDENTRIES"> <!-- info?cmd=tae -->
			<strong>
				<xsl:value-of select="$m_editedentries"/>
			</strong>
				<br/>
				<xsl:value-of select="$m_therearecurrently"/>
				<xsl:text> </xsl:text>
				<strong><xsl:value-of select="APPROVEDENTRIES"/></strong>
				<xsl:text> </xsl:text>
				<xsl:value-of select="$m_editedinguide"/>
			</xsl:when>
		</xsl:choose></p>
	
		
		<!-- turned off
		
		<xsl:apply-templates select="PROLIFICPOSTERS" mode="c_info"/> 
		<xsl:apply-templates select="ERUDITEPOSTERS" mode="c_info"/> 
		-->
		<xsl:apply-templates select="RECENTCONVERSATIONS" mode="c_info"/>
		<xsl:apply-templates select="FRESHESTARTICLES" mode="c_info"/>
		
	</xsl:template>
	<!--
	<xsl:template match="PROLIFICPOSTERS" mode="r_info">
	Description: Presentation of the object holding the PROLIFICPOSTERS
		and its title text
	 -->
	<xsl:template match="PROLIFICPOSTERS" mode="r_info">
		
			<strong>
				<xsl:value-of select="$m_toptenprolific"/>
			</strong>
			<br/>
			<xsl:apply-templates select="PROLIFICPOSTER" mode="c_info"/>
		
	</xsl:template>
	<!--
	<xsl:template match="PROLIFICPOSTER" mode="r_info">
	Description: Presentation of the PROLIFICPOSTER object
	 -->
	<xsl:template match="PROLIFICPOSTER" mode="r_info">
	<xsl:apply-templates select="USER" mode="t_info"/>
		<xsl:text> </xsl:text>
		<xsl:value-of select="COUNT"/>
		<xsl:apply-templates select="COUNT" mode="t_average"/>
		<xsl:value-of select="AVERAGESIZE"/>
		<br/>
	</xsl:template>
	<!--
	<xsl:template match="ERUDITEPOSTERS" mode="r_info">
	Description: Presentation of the object holding the ERUDITEPOSTERS
		and its title text
	 -->
	<xsl:template match="ERUDITEPOSTERS" mode="r_info">
		<font xsl:use-attribute-sets="mainfont">
			<strong>
				<xsl:value-of select="$m_toptenerudite"/>
			</strong>
			<br/>
			<xsl:apply-templates select="ERUDITEPOSTER" mode="c_info"/>
		</font>
	</xsl:template>
	<!--
	<xsl:template match="ERUDITEPOSTER" mode="r_info">
	Description: Presentation of the ERUDITEPOSTER object
	 -->
	<xsl:template match="ERUDITEPOSTER" mode="r_info">
		<xsl:apply-templates select="USER" mode="t_info"/>
		<xsl:text> </xsl:text>
		<xsl:value-of select="COUNT"/>
		<xsl:apply-templates select="COUNT" mode="t_average"/>
		<xsl:value-of select="AVERAGESIZE"/>
		<br/>
	</xsl:template>
	<!--
	<xsl:template match="RECENTCONVERSATIONS" mode="r_info">
	Description: Presentation of the object holding the RECENTCONVERSATIONS
		and its title text
	 -->
	<xsl:template match="RECENTCONVERSATIONS" mode="r_info">
		<font xsl:use-attribute-sets="mainfont">
			<strong>
				<xsl:value-of select="$m_toptwentyupdated"/>
			</strong>
			<br/>
			<xsl:apply-templates select="RECENTCONVERSATION" mode="c_info"/>
		</font>
	</xsl:template>
	<!--
	<xsl:template match="RECENTCONVERSATION" mode="r_info">
	Description: Presentation of the RECENTCONVERSATION object
	 -->
	<xsl:template match="RECENTCONVERSATION" mode="r_info">
		<xsl:apply-templates select="." mode="t_info"/>
		<font size="1">
			(<xsl:apply-templates select="DATEPOSTED/DATE" mode="t_info"/>)
		</font>
		<br/>
	</xsl:template>
	<!--
	<xsl:template match="FRESHESTARTICLES" mode="r_info">
	Description: Presentation of the object holding the FRESHESTARTICLES
		and its title text
	 -->
	<xsl:template match="FRESHESTARTICLES" mode="r_info">
		<ul class="bodylist">
		<xsl:apply-templates select="RECENTARTICLE" mode="t_info"/>
		</ul>
	</xsl:template>
	
	
	<!--
	Purpose:	 Creates the link to the RECENTARTICLE using the SUBJECT
	-->
	<xsl:template match="RECENTARTICLE" mode="t_info">
		<xsl:variable name="oddoreven">
			<xsl:choose>
				<xsl:when test="position() mod 2 != 0">odd</xsl:when>
				<xsl:otherwise>even</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<li>
			<xsl:attribute name="class">
				<xsl:value-of select="$oddoreven"/>
			</xsl:attribute>
			<a href="{$root}A{H2G2ID}" xsl:use-attribute-sets="mRECENTARTICLE_t_info">
				<xsl:value-of select="SUBJECT"/>
			</a>
			<xsl:text> | </xsl:text><xsl:apply-templates select="DATEUPDATED/DATE" mode="t_info"/>
		</li>
	</xsl:template>
	
	<xsl:template name="MOREARTICLES_NAV">
		<xsl:if test="INFO/@MODE='articles'">
			<div class="page">	
				<div class="links">
					<div class="pagecol1">
						<xsl:choose>
							<xsl:when test="INFO/@SKIPTO=0">previous</xsl:when>
							<xsl:when test="INFO/@SKIPTO=50"><a href="{root}info?cmd=art&amp;show=50&amp;skip=0">previous</a></xsl:when>
							<xsl:when test="INFO/@SKIPTO=100"><a href="{root}info?cmd=art&amp;show=50&amp;skip=50">previous</a></xsl:when>
							<xsl:when test="INFO/@SKIPTO=150"><a href="{root}info?cmd=art&amp;show=50&amp;skip=100">previous</a></xsl:when>
							<xsl:otherwise>previous</xsl:otherwise>
						</xsl:choose>
					</div>
					<div class="pagecol2"></div>
					<div class="pagecol3">
						<xsl:choose>
							<xsl:when test="INFO/@SKIPTO=0"><a href="{root}info?cmd=art&amp;show=50&amp;skip=50">next</a></xsl:when>
							<xsl:when test="INFO/@SKIPTO=50"><a href="{root}info?cmd=art&amp;show=50&amp;skip=100">next</a></xsl:when>
							<xsl:when test="INFO/@SKIPTO=100"><a href="{root}info?cmd=art&amp;show=50&amp;skip=150">next</a></xsl:when>
							<xsl:otherwise>next</xsl:otherwise>
						</xsl:choose>
					</div>
				</div>
				<div class="clear"></div>
			</div>
		</xsl:if>
	</xsl:template>
	
</xsl:stylesheet>
