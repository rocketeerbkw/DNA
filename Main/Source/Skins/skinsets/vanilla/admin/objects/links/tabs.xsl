<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	version="1.0"
	xmlns:doc="http://www.bbc.co.uk/dna/documentation"
	xmlns="http://www.w3.org/1999/xhtml"
	exclude-result-prefixes="doc">

	<xsl:template name="objects_links_tabs">
		<!-- must be a better way of doing the following -->
		<ul>
			<!-- admin tool tabs -->
			<xsl:choose>
				<xsl:when test="not(@TYPE = 'HOSTDASHBOARD' or @TYPE = 'HOSTDASHBOARDACTIVITYPAGE')">
					<li>
						<xsl:if test="PARAMS/PARAM[NAME = 's_mode']/VALUE = 'admin' or not(PARAMS/PARAM[NAME = 's_mode'])">
							<xsl:attribute name="class">selected</xsl:attribute>
						</xsl:if>
						<a href="{$root}/mbadmin?s_mode=admin">Admin</a>
					</li>
					<li>
						<xsl:if test="PARAMS/PARAM[NAME = 's_mode']/VALUE = 'design'">
							<xsl:attribute name="class">selected</xsl:attribute>
						</xsl:if>
						<a href="{$root}/messageboardadmin_design?s_mode=design">Design</a>
					</li>
				</xsl:when>
				<!-- 
					host dashboard tabs 
					do test around these if user can/cannot see the dashboard type for selected value or show/hide tabs?
				-->
				<xsl:otherwise>
					<li>
						<xsl:if test="not(PARAMS/PARAM[NAME = 's_type']/VALUE )">
							<xsl:attribute name="class">selected</xsl:attribute>
						</xsl:if>
						<a href="{$root}/hostdashboard?{$dashboardsiteuser}">
							All <xsl:apply-templates select="MODERATORHOME/MODERATOR/ACTIONITEMS" mode="objects_moderator_actionitemtotal"/>
						</a>
					</li>
					<li>
						<xsl:if test="PARAMS/PARAM[NAME = 's_type']/VALUE = '1'">
							<xsl:attribute name="class">selected</xsl:attribute>
						</xsl:if>
			            <a href="{$root}/hostdashboard?s_type=1{$dashboardsiteuser}">Blogs <xsl:apply-templates select="MODERATORHOME/MODERATOR/ACTIONITEMS/ACTIONITEM[TYPE = 'Blog']" mode="objects_moderator_actionitemtotal"/></a>
					</li>
					<li>
						<xsl:if test="PARAMS/PARAM[NAME = 's_type']/VALUE = '2'">
							<xsl:attribute name="class">selected</xsl:attribute>
						</xsl:if>
						<a href="{$root}/hostdashboard?s_type=2{$dashboardsiteuser}">Boards <xsl:apply-templates select="MODERATORHOME/MODERATOR/ACTIONITEMS/ACTIONITEM[TYPE = 'Messageboard']" /></a>
					</li>
					<li>
						<xsl:if test="PARAMS/PARAM[NAME = 's_type']/VALUE = '3'">
							<xsl:attribute name="class">selected</xsl:attribute>
						</xsl:if>
						<a href="{$root}/hostdashboard?s_type=3{$dashboardsiteuser}">Communities <xsl:apply-templates select="MODERATORHOME/MODERATOR/ACTIONITEMS/ACTIONITEM[TYPE = 'Community']" /></a>
					</li>
					<li>
						<xsl:if test="PARAMS/PARAM[NAME = 's_type']/VALUE = '4'">
							<xsl:attribute name="class">selected</xsl:attribute>
						</xsl:if>
						<a href="{$root}/hostdashboard?s_type=4{$dashboardsiteuser}">Stories <xsl:apply-templates select="MODERATORHOME/MODERATOR/ACTIONITEMS/ACTIONITEM[TYPE = 'EmbeddedComments']" /></a>
					</li>																
				</xsl:otherwise>
			</xsl:choose>
		</ul>
	</xsl:template>
	
</xsl:stylesheet>