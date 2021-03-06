<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation" xmlns="http://www.w3.org/1999/xhtml"
	exclude-result-prefixes="doc">

	<xsl:template name="objects_links_tabs">
		<!-- put all these in apply templates sometime soon -->
		<ul>
			<!-- admin tool tabs -->
			<xsl:choose>
				<xsl:when
					test="@TYPE = 'MBADMIN' or @TYPE = 'MBADMINDESIGN'  or @TYPE = 'MESSAGEBOARDSCHEDULE' or @TYPE = 'TOPICBUILDER' or @TYPE = 'MBADMINASSETS' or @TYPE = 'FRONTPAGE'">
					<li>
						<xsl:if
							test="PARAMS/PARAM[NAME = 's_mode']/VALUE = 'admin' or not(PARAMS/PARAM[NAME = 's_mode'])">
							<xsl:attribute name="class">selected</xsl:attribute>
						</xsl:if>
						<a href="mbadmin?s_mode=admin">Admin</a>
					</li>
					<li>
						<xsl:if test="PARAMS/PARAM[NAME = 's_mode']/VALUE = 'design'">
							<xsl:attribute name="class">selected</xsl:attribute>
						</xsl:if>
						<a href="messageboardadmin_design?s_mode=design">Design</a>
					</li>
				</xsl:when>
				<xsl:when
					test="@TYPE = 'HOSTDASHBOARDACTIVITYPAGE' or @TYPE = 'HOSTDASHBOARDUSERACTIVITYPAGE' 
								or @TYPE = 'USERCONTRIBUTIONS' or @TYPE = 'MEMBERDETAILS' or @TYPE = 'COMMENTFORUMLIST'  
								or @TYPE = 'COMMENTSLIST' or @TYPE = 'USERLIST' or @TYPE = 'ERROR' or @TYPE = 'USERREPUTATIONREPORT' 
								or @TYPE = 'SITEMANAGER' or @TYPE = 'TERMSFILTERADMIN' or @TYPE = 'TERMSFILTERIMPORT' 
								or @TYPE = 'TWITTERPROFILELIST' or @TYPE = 'TWITTERPROFILE'">
					<!-- no tabs for the host dashboard activity page -->
					<li>&#160;</li>
				</xsl:when>
				<xsl:when test="@TYPE = 'MODERATOR-MANAGEMENT'">
					<li>
						<xsl:if test="/H2G2/MODERATOR-LIST/@GROUPNAME='moderator'">
							<xsl:attribute name="class">selected</xsl:attribute>
						</xsl:if>
						<a href="#top" onclick="modmanagement_submitGroup('moderator')"
							class="moderator">
							Moderator
						</a>
					</li>
					<li>
						<xsl:if test="/H2G2/MODERATOR-LIST/@GROUPNAME='editor'">
							<xsl:attribute name="class">selected</xsl:attribute>
						</xsl:if>
						<a href="#top" onclick="modmanagement_submitGroup('editor')"
							class="editor">
							Editor
						</a>
					</li>
					<li>
						<xsl:if test="/H2G2/MODERATOR-LIST/@GROUPNAME='notables'">
							<xsl:attribute name="class">selected</xsl:attribute>
						</xsl:if>
						<a href="#top" onclick="modmanagement_submitGroup('notables')"
							class="notables">
							Notables
						</a>
					</li>
					<li>
						<xsl:if test="/H2G2/MODERATOR-LIST/@GROUPNAME='referees'">
							<xsl:attribute name="class">selected</xsl:attribute>
						</xsl:if>
						<a href="#top" onclick="modmanagement_submitGroup('referees')"
							class="referees">
							Referees
						</a>
					</li>
				</xsl:when>
				<xsl:otherwise>
					<li>
						<xsl:if test="not(PARAMS/PARAM[NAME = 's_type']/VALUE )">
							<xsl:attribute name="class">selected</xsl:attribute>
						</xsl:if>
						<a href="hostdashboard?{$dashboardsiteuser}" class="all">
							All
							<xsl:apply-templates select="MODERATOR-HOME/MODERATOR/ACTIONITEMS"
								mode="objects_moderator_allactionitemtotal" />
						</a>
					</li>
					<li>
						<xsl:if test="PARAMS/PARAM[NAME = 's_type']/VALUE = '1'">
							<xsl:attribute name="class">selected</xsl:attribute>
						</xsl:if>
						<a href="hostdashboard?s_type=1{$dashboardsiteuser}" class="blogs">
							Blogs
							<xsl:apply-templates
								select="MODERATOR-HOME/MODERATOR/ACTIONITEMS/ACTIONITEM[TYPE = 'Blog']"
								mode="objects_moderator_actionitemtotal" />
						</a>
					</li>
					<li>
						<xsl:if test="PARAMS/PARAM[NAME = 's_type']/VALUE = '2'">
							<xsl:attribute name="class">selected</xsl:attribute>
						</xsl:if>
						<a href="hostdashboard?s_type=2{$dashboardsiteuser}" class="messageboards">
							Messageboards
							<xsl:apply-templates
								select="MODERATOR-HOME/MODERATOR/ACTIONITEMS/ACTIONITEM[TYPE = 'Messageboard']"
								mode="objects_moderator_actionitemtotal" />
						</a>
					</li>
					<li>
						<xsl:if test="PARAMS/PARAM[NAME = 's_type']/VALUE = '3'">
							<xsl:attribute name="class">selected</xsl:attribute>
						</xsl:if>
						<a href="hostdashboard?s_type=3{$dashboardsiteuser}" class="communities">
							Communities
							<xsl:apply-templates
								select="MODERATOR-HOME/MODERATOR/ACTIONITEMS/ACTIONITEM[TYPE = 'Community']"
								mode="objects_moderator_actionitemtotal" />
						</a>
					</li>
					<li>
						<xsl:if test="PARAMS/PARAM[NAME = 's_type']/VALUE = '4'">
							<xsl:attribute name="class">selected</xsl:attribute>
						</xsl:if>
						<a href="hostdashboard?s_type=4{$dashboardsiteuser}" class="stories">
							Comments
							<xsl:apply-templates
								select="MODERATOR-HOME/MODERATOR/ACTIONITEMS/ACTIONITEM[TYPE = 'EmbeddedComments']"
								mode="objects_moderator_actionitemtotal" />
						</a>
					</li>
					<li>
						<xsl:if test="PARAMS/PARAM[NAME = 's_type']/VALUE = '5'">
							<xsl:attribute name="class">selected</xsl:attribute>
						</xsl:if>
						<a href="hostdashboard?s_type=5{$dashboardsiteuser}" class="twitter">
							Twitter
							<xsl:apply-templates
								select="MODERATOR-HOME/MODERATOR/ACTIONITEMS/ACTIONITEM[TYPE = 'Twitter']"
								mode="objects_moderator_actionitemtotal" />
						</a>
					</li>

				</xsl:otherwise>
			</xsl:choose>
		</ul>
	</xsl:template>

</xsl:stylesheet>