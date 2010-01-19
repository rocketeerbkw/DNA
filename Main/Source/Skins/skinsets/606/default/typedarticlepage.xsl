<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<xsl:import href="../../../base/base-typedarticle.xsl"/>
	<xsl:import href="typedarticlepage_multiinputs.xsl"/>

	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
									Page - Level  template
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<xsl:template name="TYPED-ARTICLE_MAINBODY">
	<xsl:if test="not(/H2G2/VIEWING-USER/USER)">
		You need to be signed in to view this page - <a href="{$cpshome}">return to the 606 homepage</a>.
	</xsl:if>
	<!-- DEBUG -->
	<xsl:call-template name="TRACE">
		<xsl:with-param name="message">TYPED-ARTICLE_MAINBODY</xsl:with-param>
		<xsl:with-param name="pagename">typedarticlepage.xsl</xsl:with-param>
	</xsl:call-template>
	<!-- DEBUG -->

		<xsl:apply-templates select="PARSEERRORS" mode="c_typedarticle"/>
		<xsl:apply-templates select="ERROR" mode="c_typedarticle"/>
		<xsl:apply-templates select="DELETED" mode="c_article"/>


		<xsl:apply-templates select="MULTI-STAGE" mode="heading_intro"/>
		<xsl:apply-templates select="MULTI-STAGE" mode="errors"/>
		<xsl:apply-templates select="MULTI-STAGE" mode="c_article"/>

	</xsl:template>


	<xsl:template match="MULTI-STAGE" mode="heading_intro">
		<xsl:choose>
			<!-- user page -->
			<xsl:when test="$current_article_type=3001">
				<xsl:choose>
					<!-- create intro - after sso registration - Step 1 -->
					<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_display']/VALUE = 'register'">
					    <xsl:choose>
					    	<xsl:when test="/H2G2/SITE/IDENTITYSIGNIN = 0">
							    <div id="mainbansec">
									<div class="stephead">
										<h2 class="steparr1">Step 1</h2><span class="hide">leading on to</span><span class="step2">Step 2</span>
									</div>
									<div class="clear"></div>
								</div>
								<div class="steps">
									<h3>Step 1: create your profile</h3>
									<p>You must complete this profile to become a full member and post without pre-moderation</p>
									<!-- <p>You must fill in this information to finish your registration and become a full member of 606</p> -->
								</div>
							</xsl:when>
							<xsl:otherwise>
								<!-- Is this being removed for identity?
								<div id="mainbansec">
									<div class="stephead">
										<h2 class="steparr1">Step 1</h2><span class="hide">leading on to</span><span class="step2">Step 2</span>
									</div>
									<div class="clear"></div>
								</div> -->
								<div class="steps">
									<h3>Create your profile</h3>
									<p>To start commenting on 606 topics, please complete your profile below. Other users will be able to see your profile by clicking on your username.</p>
									<!-- <p>You must fill in this information to finish your registration and become a full member of 606</p> -->
								</div>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<!-- create intro - after sso registration - Step 2 -->
					<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_display']/VALUE = 'register2' and /H2G2/SITE/IDENTITYSIGNIN = 0">
					    <div id="mainbansec">
							<div class="stephead">
								<h2 class="step1">Step 1</h2><span class="hide">leading on to</span><span class="steparr2">Step 2</span>
							</div>
							<div class="clear"></div>
						</div>
						<div class="steps">
							<h3>Step 2 my profile: preview</h3>
							<p>You can edit your content below - when you're happy with it, click publish</p>
						</div>
					</xsl:when>

					<!-- edit published profile -->
					<xsl:otherwise>
						<xsl:call-template name="USERPAGE_BANNER" />
						<xsl:choose>
							<xsl:when test="/H2G2/SITE/IDENTITYSIGNIN = 0">
								<xsl:choose>
									<xsl:when test="/H2G2/MULTI-STAGE[@TYPE='TYPED-ARTICLE-EDIT']">
										<div class="steps">
											<h3>Step 1:  create/edit your profile</h3>
											<p>Please fill in the fields below</p>
										</div>
									</xsl:when>
									<xsl:when test="/H2G2/MULTI-STAGE[@TYPE='TYPED-ARTICLE-EDIT-PREVIEW']">
										<div class="steps">
											<h3>Step 2:  preview your profile</h3>
											<p>You can edit your content below - when you're happy with it, click publish</p>
										</div>
									</xsl:when>
								</xsl:choose>
							</xsl:when>
							<xsl:otherwise>
								<xsl:choose>
									<xsl:when test="/H2G2/MULTI-STAGE[@TYPE='TYPED-ARTICLE-EDIT']">
										<div class="steps">
											<h3>Edit your <xsl:value-of select="/H2G2/SITE/NAME" /> profile</h3>
											<p>You can edit your content below - when you're happy with it, click publish</p>
										</div>
									</xsl:when>
									<xsl:when test="/H2G2/MULTI-STAGE[@TYPE='TYPED-ARTICLE-EDIT-PREVIEW']">
										<div class="steps">
											<xsl:choose>
												<xsl:when test="/H2G2/SITE/IDENTITYSIGNIN = 0">
													<h3>Preview your profile</h3>
												</xsl:when>
												<xsl:otherwise>
													<h3>My profile: Preview</h3>
												</xsl:otherwise>
											</xsl:choose>
											<p>You can edit your content below - when you're happy with it, click publish</p>
										</div>
									</xsl:when>
								</xsl:choose>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="$article_type_group = 'article'">
				<div id="mainbansec2">
					<h1>Create...</h1>
					<noscript>
						<p>
						An article can be used to write a few quick thoughts or anything up to 5000 characters
						</p>
					</noscript>
				</div>
			</xsl:when>
			<xsl:when test="$article_subtype = 'match_report'">
				<div id="mainbansec2">
					<h1>Create...</h1>
					<noscript>
						<p>
						This can be used to write a match article or just host a debate before, during or after a game
						</p>
					</noscript>
				</div>
			</xsl:when>
			<xsl:when test="$article_subtype = 'event_report'">
				<div id="mainbansec2">
					<h1>Create...</h1>
					<noscript>
						<p>
						This can be used to write a article or just host a debate before, during or after the event
						</p>
					</noscript>
				</div>
			</xsl:when>
			<xsl:when test="$article_subtype = 'player_profile'">
				<div id="mainbansec2">
					<h1>Create...</h1>
					<noscript>
						<p>
						A player profile is a place to celebrate or criticise any sportsperson
						</p>
					</noscript>
				</div>
			</xsl:when>
			<xsl:when test="$article_subtype = 'team_profile'">
				<div id="mainbansec2">
					<h1>Create...</h1>
					<noscript>
						<p>
						This is a chance to celebrate or criticise any team
						</p>
					</noscript>
				</div>
			</xsl:when>
			<!-- user and staff articles  -->
			<!--[FIXME: hide]
			<xsl:when test="$article_type_group='article'">
				<xsl:choose>
					<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_selectsport']">
						<div id="mainbansec">
							<div class="banartical"><h3>Article/ <strong>write an article</strong></h3></div>
							<xsl:call-template name="SEARCHBOX" />
							<div class="clear"></div>
						</div>
						<div class="steps">
							<h3>Step 1: select a sport</h3>
						</div>
					</xsl:when>
					<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_changedsport']">
						<div id="mainbansec">
							<div class="banartical"><h3>Article/ <strong>write an article</strong></h3></div>
							<xsl:call-template name="SEARCHBOX" />
							<div class="clear"></div>
						</div>
						<div class="steps">
							<h3>Step 2: write an article</h3>
							<p>Please fill in all the fields below</p>
						</div>
					</xsl:when>
					<xsl:when test="/H2G2/MULTI-STAGE/MULTI-ELEMENT[@NAME='SPORT']/VALUE/text() or /H2G2/PARAMS/PARAM[NAME = 's_sport']">
						<xsl:call-template name="REUSABLE_BANNER">
							<xsl:with-param name="title">Article</xsl:with-param>
							<xsl:with-param name="text">article</xsl:with-param>
						</xsl:call-template>
					</xsl:when>
					<xsl:otherwise>
						<div id="mainbansec">
							<div class="banartical"><h3>Article/ <strong>write an article</strong></h3></div>
							<xsl:call-template name="SEARCHBOX" />
							<div class="clear"></div>
						</div>
						<div class="steps">
							<h3>Step 1: select a sport</h3>
						</div>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			-->
			<!-- match report  -->
			<!--[FIXME: hide]
			<xsl:when test="$article_subtype = 'match_report'">
				<xsl:choose>
					<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_selectsport']">
						<div id="mainbansec">
							<div class="banartical"><h3>Match report/ <strong>write a match report</strong></h3></div>
							<xsl:call-template name="SEARCHBOX" />
							<div class="clear"></div>
						</div>
						<div class="steps">
							<h3>Step 1: select a sport</h3>
						</div>
					</xsl:when>
					<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_changedsport']">
						<div id="mainbansec">
							<div class="banartical"><h3>Match report/ <strong>write a match report</strong></h3></div>
							<xsl:call-template name="SEARCHBOX" />
							<div class="clear"></div>
						</div>
						<div class="steps">
							<h3>Step 2: write a match report</h3>
							<p>Please fill in all the fields below</p>
						</div>
					</xsl:when>
					<xsl:when test="/H2G2/MULTI-STAGE/MULTI-ELEMENT[@NAME='SPORT']/VALUE/text() or /H2G2/PARAMS/PARAM[NAME = 's_sport']">
						<xsl:call-template name="REUSABLE_BANNER">
							<xsl:with-param name="title">Match report</xsl:with-param>
							<xsl:with-param name="text">match report</xsl:with-param>
						</xsl:call-template>
					</xsl:when>
					<xsl:otherwise>
						<div id="mainbansec">
							<div class="banartical"><h3>Match report/ <strong>write a match report</strong></h3></div>
							<xsl:call-template name="SEARCHBOX" />
							<div class="clear"></div>
						</div>
						<div class="steps">
							<h3>Step 1: select a sport</h3>
						</div>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			-->
			<!-- EVENT REPORT -->
			<!--[FIXME: hide]
			<xsl:when test="$article_subtype = 'event_report'">
				<xsl:choose>
					<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_selectsport']">
						<div id="mainbansec">
							<div class="banartical"><h3>Event report/ <strong>write an event report</strong></h3></div>
							<xsl:call-template name="SEARCHBOX" />
							<div class="clear"></div>
						</div>
						<div class="steps">
							<h3>Step 1: select a sport</h3>
						</div>
					</xsl:when>
					<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_changedsport']">
						<div id="mainbansec">
							<div class="banartical"><h3>Event report/ <strong>write an event report</strong></h3></div>
							<xsl:call-template name="SEARCHBOX" />
							<div class="clear"></div>
						</div>
						<div class="steps">
							<h3>Step 2: write an event report</h3>
							<p>Please fill in all the fields below</p>
						</div>
					</xsl:when>
					<xsl:when test="/H2G2/MULTI-STAGE/MULTI-ELEMENT[@NAME='SPORT']/VALUE/text() or /H2G2/PARAMS/PARAM[NAME = 's_sport']">
						<xsl:call-template name="REUSABLE_BANNER">
							<xsl:with-param name="title">Event report</xsl:with-param>
							<xsl:with-param name="text">event report</xsl:with-param>
						</xsl:call-template>
					</xsl:when>
					<xsl:otherwise>
						<div id="mainbansec">
							<div class="banartical"><h3>Event report/ <strong>write an event report</strong></h3></div>
							<xsl:call-template name="SEARCHBOX" />
							<div class="clear"></div>
						</div>
						<div class="steps">
							<h3>Step 1: select a sport</h3>
						</div>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			-->
			<!-- PLAYER PROFILE -->
			<!--[FIXME: hide]
			<xsl:when test="$article_subtype = 'player_profile'">
				<xsl:choose>
					<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_selectsport']">
						<div id="mainbansec">
							<div class="banartical"><h3>Player profile/ <strong>write an player profile</strong></h3></div>
							<xsl:call-template name="SEARCHBOX" />
							<div class="clear"></div>
						</div>
						<div class="steps">
							<h3>Step 1: select a sport</h3>
						</div>
					</xsl:when>
					<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_changedsport']">
						<div id="mainbansec">
							<div class="banartical"><h3>Player profile/ <strong>write an player profile</strong></h3></div>
							<xsl:call-template name="SEARCHBOX" />
							<div class="clear"></div>
						</div>
						<div class="steps">
							<h3>Step 2: write a player profile</h3>
							<p>Please fill in all the fields below</p>
						</div>
					</xsl:when>
					<xsl:when test="/H2G2/MULTI-STAGE/MULTI-ELEMENT[@NAME='SPORT']/VALUE/text() or /H2G2/PARAMS/PARAM[NAME = 's_sport']">
						<xsl:call-template name="REUSABLE_BANNER">
							<xsl:with-param name="title">Player profile</xsl:with-param>
							<xsl:with-param name="text">player profile</xsl:with-param>
						</xsl:call-template>
					</xsl:when>
					<xsl:otherwise>
						<div id="mainbansec">
							<div class="banartical"><h3>Player profile/ <strong>write an player profile</strong></h3></div>
							<xsl:call-template name="SEARCHBOX" />
							<div class="clear"></div>
						</div>
						<div class="steps">
							<h3>Step 1: select a sport</h3>
						</div>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			-->
			<!-- TEAM PROFILE -->
			<!--[FIXME: hide]
			<xsl:when test="$article_subtype = 'team_profile'">
				<xsl:choose>
					<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_selectsport']">
						<div id="mainbansec">
							<div class="banartical"><h3>Team profile/ <strong>write an team profile</strong></h3></div>
							<xsl:call-template name="SEARCHBOX" />
							<div class="clear"></div>
						</div>
						<div class="steps">
							<h3>Step 1: select a sport</h3>
						</div>
					</xsl:when>
					<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_changedsport']">
						<div id="mainbansec">
							<div class="banartical"><h3>Team profile/ <strong>write an team profile</strong></h3></div>
							<xsl:call-template name="SEARCHBOX" />
							<div class="clear"></div>
						</div>
						<div class="steps">
							<h3>Step 2: write a team profile</h3>
							<p>Please fill in all the fields below</p>
						</div>
					</xsl:when>
					<xsl:when test="/H2G2/MULTI-STAGE/MULTI-ELEMENT[@NAME='SPORT']/VALUE/text() or /H2G2/PARAMS/PARAM[NAME = 's_sport']">
						<xsl:call-template name="REUSABLE_BANNER">
							<xsl:with-param name="title">Team profile</xsl:with-param>
							<xsl:with-param name="text">team profile</xsl:with-param>
						</xsl:call-template>
					</xsl:when>
					<xsl:otherwise>
						<div id="mainbansec">
							<div class="banartical"><h3>Team profile/ <strong>write an team profile</strong></h3></div>
							<xsl:call-template name="SEARCHBOX" />
							<div class="clear"></div>
						</div>
						<div class="steps">
							<h3>Step 1: select a sport</h3>
						</div>
					</xsl:otherwise>
				</xsl:choose>

			</xsl:when>
			-->
			<!-- DYNAMIC LISTS and HOUSE RULES-->
			<xsl:otherwise>
				<!--[FIXME: adapt]
				<xsl:if test="$test_IsEditor">
					<div id="mainbansec">
						<div class="banartical"><h3>Article/ <strong>create an article</strong></h3></div>
						<xsl:call-template name="SEARCHBOX" />
						<div class="clear"></div>
					</div>
				</xsl:if>
				-->
				<div id="mainbansec2">
					<h1>Create...</h1>
				</div>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>


	<xsl:template name="REUSABLE_BANNER">
		<xsl:param name="title"/>
		<xsl:param name="text"/>

		<!--
			create variables to store the step numbers (for create but not edit)
			as articles have an extra step when creating - as you have to first select a sport -->
		<xsl:variable name="createnumber">
			<xsl:choose>
				<xsl:when test="$article_type_group='article'">2</xsl:when>
				<xsl:otherwise>1</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="previewnumber">
			<xsl:choose>
				<xsl:when test="$article_type_group='article'">3</xsl:when>
				<xsl:otherwise>2</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:choose>
			<!-- create new -->
			<xsl:when test="/H2G2/MULTI-STAGE[@TYPE='TYPED-ARTICLE-CREATE']">
				<div id="mainbansec">
					<div class="banartical"><h3><xsl:value-of select="$title"/>/ <strong>write a <xsl:value-of select="$text"/></strong></h3></div>
					<xsl:call-template name="SEARCHBOX" />
					<div class="clear"></div>
				</div>
				<div class="steps">
					<h3>Step <xsl:value-of select="$createnumber"/>: write your <xsl:value-of select="$text"/></h3>
					<p>Please fill in all the fields below</p>
				</div>
			</xsl:when>
			<!-- preview new -->
			<xsl:when test="/H2G2/MULTI-STAGE/@TYPE='TYPED-ARTICLE-PREVIEW'">
				<div id="mainbansec">
					<div class="banartical"><h3><xsl:value-of select="$title"/>/ <strong><xsl:value-of select="$text"/></strong></h3></div>
					<xsl:call-template name="SEARCHBOX" />
					<div class="clear"></div>
				</div>
				<div class="steps">
					<h3>Step <xsl:value-of select="$previewnumber"/>: preview your <xsl:value-of select="$text"/></h3>
					<p>You can edit your content below - when you're happy with it, click publish</p>
				</div>
			</xsl:when>
			<!-- edit existing -->
			<xsl:when test="/H2G2/MULTI-STAGE[@TYPE='TYPED-ARTICLE-EDIT']">
				<div id="mainbansec">
					<div class="banartical"><h3><xsl:value-of select="$title"/>/ <strong>edit a <xsl:value-of select="$text"/></strong></h3></div>
					<xsl:call-template name="SEARCHBOX" />
					<div class="clear"></div>
				</div>
				<div class="steps">
					<h3>Step 1: edit your <xsl:value-of select="$text"/></h3>
					<p>You can edit your content below - when you're happy with it, click preview</p>
				</div>
			</xsl:when>
			<!-- preview existing -->
			<xsl:when test="/H2G2/MULTI-STAGE[@TYPE='TYPED-ARTICLE-EDIT-PREVIEW']">
				<div id="mainbansec">
					<div class="banartical"><h3><xsl:value-of select="$title"/>/ <strong>edit a <xsl:value-of select="$text"/></strong></h3></div>
					<xsl:call-template name="SEARCHBOX" />
					<div class="clear"></div>
				</div>
				<div class="steps">
					<h3>Step 2: preview your <xsl:value-of select="$text"/></h3>
					<p>You can edit your content below - when you're happy with it, click publish</p>
				</div>
			</xsl:when>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="MULTI-STAGE" mode="errors">
	<xsl:if test="*/ERRORS or /H2G2/PROFANITYERRORINFO">
		<div class="warningBox">
			<p class="warning">
				<strong>ERROR</strong><br />
				<xsl:if test="/H2G2/PROFANITYERRORINFO">
					Your information contains a blocked phrase. You must remove any profanities before your item can be submitted.<br />
				</xsl:if>
				<xsl:choose>
					<xsl:when test="$current_article_type=3001">
						<xsl:if test="MULTI-ELEMENT[@NAME='SPORTINGINTEREST1']/ERRORS/ERROR/@TYPE='VALIDATION-ERROR-EMPTY'">
							You must provide your team supported / sporting interests<br />
						</xsl:if>
						<xsl:if test="MULTI-ELEMENT[@NAME='FAVOURITEPLAYER']/ERRORS/ERROR/@TYPE='VALIDATION-ERROR-EMPTY'">
							You must provide your favourite player<br />
						</xsl:if>
						<xsl:if test="MULTI-ELEMENT[@NAME='FAVOURITEMATCH']/ERRORS/ERROR/@TYPE='VALIDATION-ERROR-EMPTY'">
							You must provide your favourite match<br />
						</xsl:if>
						<xsl:if test="MULTI-REQUIRED[@NAME='BODY']/ERRORS/ERROR/@TYPE='VALIDATION-ERROR-EMPTY'">
							You must provide information about yourself<br />
						</xsl:if>
					</xsl:when>
					<xsl:when test="$article_type_group='article'">
						<xsl:if test="MULTI-ELEMENT[@NAME='SPORT']/ERRORS/ERROR/@TYPE='VALIDATION-ERROR-EMPTY'">
							You must select a sport<br />
						</xsl:if>
						<xsl:if test="MULTI-REQUIRED[@NAME='TITLE']/ERRORS/ERROR/@TYPE='VALIDATION-ERROR-EMPTY'">
							You must provide a title for your article<br />
						</xsl:if>
						<xsl:if test="MULTI-REQUIRED[@NAME='BODY']/ERRORS/ERROR/@TYPE='VALIDATION-ERROR-EMPTY'">
							You must provide text for your article<br />
						</xsl:if>
					</xsl:when>
					<xsl:when test="$article_subtype = 'match_report'">
						<xsl:if test="MULTI-ELEMENT[@NAME='SPORT']/ERRORS/ERROR/@TYPE='VALIDATION-ERROR-EMPTY'">
							You must select a sport<br />
						</xsl:if>
						<xsl:if test="MULTI-ELEMENT[@NAME='COMPETITION']/ERRORS/ERROR/@TYPE='VALIDATION-ERROR-EMPTY'">
							You must select a competition<br />
						</xsl:if>
						<xsl:if test="MULTI-ELEMENT[@NAME='HOMETEAM']/ERRORS/ERROR/@TYPE='VALIDATION-ERROR-EMPTY'">
							You must select a home team<br />
						</xsl:if>
						<xsl:if test="MULTI-ELEMENT[@NAME='HOMETEAMSCORE']/ERRORS/ERROR/@TYPE='VALIDATION-ERROR-EMPTY'">
							You must select a home team score<br />
						</xsl:if>
						<xsl:if test="MULTI-ELEMENT[@NAME='AWAYTEAM']/ERRORS/ERROR/@TYPE='VALIDATION-ERROR-EMPTY'">
							You must select an away team<br />
						</xsl:if>
						<xsl:if test="MULTI-ELEMENT[@NAME='AWAYTEAMSCORE']/ERRORS/ERROR/@TYPE='VALIDATION-ERROR-EMPTY'">
							You must select an away team score<br />
						</xsl:if>
						<xsl:if test="MULTI-ELEMENT[@NAME='DATEDAY']/ERRORS/ERROR/@TYPE='VALIDATION-ERROR-EMPTY'">
							You must select a match day<br />
						</xsl:if>
						<xsl:if test="MULTI-ELEMENT[@NAME='DATEMONTH']/ERRORS/ERROR/@TYPE='VALIDATION-ERROR-EMPTY'">
							You must select a match month<br />
						</xsl:if>
						<xsl:if test="MULTI-ELEMENT[@NAME='DATEYEAR']/ERRORS/ERROR/@TYPE='VALIDATION-ERROR-EMPTY'">
							You must select a match year<br />
						</xsl:if>
						<xsl:if test="MULTI-REQUIRED[@NAME='TITLE']/ERRORS/ERROR/@TYPE='VALIDATION-ERROR-EMPTY'">
							You must provide a title for your match article<br />
						</xsl:if>
						<xsl:if test="MULTI-REQUIRED[@NAME='BODY']/ERRORS/ERROR/@TYPE='VALIDATION-ERROR-EMPTY'">
							You must provide text for your match article<br />
						</xsl:if>
					</xsl:when>
					<xsl:when test="$article_subtype = 'event_report'">
						<xsl:if test="MULTI-ELEMENT[@NAME='SPORT']/ERRORS/ERROR/@TYPE='VALIDATION-ERROR-EMPTY'">
							You must select a sport<br />
						</xsl:if>
						<xsl:if test="MULTI-ELEMENT[@NAME='COMPETITION']/ERRORS/ERROR/@TYPE='VALIDATION-ERROR-EMPTY'">
							You must select a competition<br />
						</xsl:if>
						<xsl:if test="MULTI-REQUIRED[@NAME='TITLE']/ERRORS/ERROR/@TYPE='VALIDATION-ERROR-EMPTY'">
							You must provide an event name<br />
						</xsl:if>
						<xsl:if test="MULTI-ELEMENT[@NAME='DATEDAY']/ERRORS/ERROR/@TYPE='VALIDATION-ERROR-EMPTY'">
							You must select an event day<br />
						</xsl:if>
						<xsl:if test="MULTI-ELEMENT[@NAME='DATEMONTH']/ERRORS/ERROR/@TYPE='VALIDATION-ERROR-EMPTY'">
							You must select an event month<br />
						</xsl:if>
						<xsl:if test="MULTI-ELEMENT[@NAME='DATEYEAR']/ERRORS/ERROR/@TYPE='VALIDATION-ERROR-EMPTY'">
							You must select an event year<br />
						</xsl:if>
						<xsl:if test="MULTI-REQUIRED[@NAME='BODY']/ERRORS/ERROR/@TYPE='VALIDATION-ERROR-EMPTY'">
							You must provide text for your event article<br />
						</xsl:if>
					</xsl:when>
					<xsl:when test="$article_subtype = 'player_profile'">
						<xsl:if test="MULTI-ELEMENT[@NAME='SPORT']/ERRORS/ERROR/@TYPE='VALIDATION-ERROR-EMPTY'">
							You must select a sport<br />
						</xsl:if>
						<xsl:if test="MULTI-REQUIRED[@NAME='TITLE']/ERRORS/ERROR/@TYPE='VALIDATION-ERROR-EMPTY'">
							You must provide a name<br />
						</xsl:if>
						<xsl:if test="MULTI-REQUIRED[@NAME='BODY']/ERRORS/ERROR/@TYPE='VALIDATION-ERROR-EMPTY'">
							You must provide text for your profile<br />
						</xsl:if>
					</xsl:when>
					<xsl:when test="$article_subtype = 'team_profile'">
					<xsl:if test="MULTI-ELEMENT[@NAME='SPORT']/ERRORS/ERROR/@TYPE='VALIDATION-ERROR-EMPTY'">
							You must select a sport<br />
						</xsl:if>
						<xsl:if test="MULTI-ELEMENT[@NAME='TEAM']/ERRORS/ERROR/@TYPE='VALIDATION-ERROR-EMPTY'">
							You must select a team<br />
						</xsl:if>
						<xsl:if test="MULTI-ELEMENT[@NAME='HONOURS']/ERRORS/ERROR/@TYPE='VALIDATION-ERROR-EMPTY'">
							You must provide info about team honours<br />
						</xsl:if>
						<xsl:if test="MULTI-REQUIRED[@NAME='BODY']/ERRORS/ERROR/@TYPE='VALIDATION-ERROR-EMPTY'">
							You must tell us more about your team<br />
						</xsl:if>
					</xsl:when>
					<xsl:otherwise>
						<!-- article for dynamic lists -->
						<xsl:if test="MULTI-REQUIRED[@NAME='TITLE']/ERRORS/ERROR/@TYPE='VALIDATION-ERROR-EMPTY'">
							You must provide a title for your article<br />
						</xsl:if>
						<xsl:if test="MULTI-REQUIRED[@NAME='BODY']/ERRORS/ERROR/@TYPE='VALIDATION-ERROR-EMPTY'">
							You must provide text for your article<br />
						</xsl:if>
					</xsl:otherwise>
				</xsl:choose>
			</p>

			<xsl:apply-templates select="MULTI-REQUIRED/ERRORS/ERROR[@TYPE='VALIDATION-ERROR-PARSE']" mode="validation_error_parse"/>

		</div>
	</xsl:if>
	</xsl:template>

	<!--
	<xsl:template match="MULTI-STAGE" mode="create_article">
	Use: Presentation of the create / edit article functionality
	 -->
	<xsl:template match="MULTI-STAGE" mode="r_article">
		<input type="hidden" name="_msfinish" value="yes"/>
		<!-- <input type="hidden" name="skin" value="purexml"/> -->

		<xsl:choose>
			<xsl:when test="/H2G2/MULTI-STAGE/@TYPE='TYPED-ARTICLE-EDIT' or /H2G2/MULTI-STAGE/@TYPE='TYPED-ARTICLE-EDIT-PREVIEW'">
			<!-- when editing - use page author -->
				<input type="hidden" name="AUTHORNAME" value="{/H2G2/ARTICLE/ARTICLEINFO/PAGEAUTHOR/EDITOR/USER/FIRSTNAMES} {/H2G2/ARTICLE/ARTICLEINFO/PAGEAUTHOR/EDITOR/USER/LASTNAME}"/>
				<input type="hidden" name="AUTHORUSERID" value="{/H2G2/ARTICLE/ARTICLEINFO/PAGEAUTHOR/EDITOR/USER/USERID}"/>
				<input type="hidden" name="AUTHORUSERNAME" value="{/H2G2/ARTICLE/ARTICLEINFO/PAGEAUTHOR/EDITOR/USER/USERNAME}"/>
				<xsl:choose>
					<xsl:when test="/H2G2/MULTI-STAGE/@TYPE='TYPED-ARTICLE-EDIT-PREVIEW'">
						<!-- during TYPED-ARTICLE-EDIT-PREVIEW the /H2G2/ARTICLE/ARTICLEINFO/DATECREATED/DATE/@SORT seems hold the value of the current date so need to reuse the created date -->
						<input type="hidden" name="DATECREATED" value="{/H2G2/ARTICLE/GUIDE/DATECREATED}"/>
					</xsl:when>
					<xsl:otherwise>
						<input type="hidden" name="DATECREATED" value="{/H2G2/ARTICLE/ARTICLEINFO/DATECREATED/DATE/@SORT}"/>
					</xsl:otherwise>
				</xsl:choose>


				<input type="hidden" name="LASTUPDATED" value="{/H2G2/DATE/@SORT}"/>
				<xsl:comment>editing</xsl:comment>
			</xsl:when>
			<xsl:when test="/H2G2/MULTI-STAGE/@TYPE='TYPED-ARTICLE-CREATE' or /H2G2/MULTI-STAGE/@TYPE='TYPED-ARTICLE-PREVIEW'">
			<!-- when creating - use viewer -->
				<input type="hidden" name="AUTHORNAME" value="{/H2G2/VIEWING-USER/USER/FIRSTNAMES} {/H2G2/VIEWING-USER/USER/LASTNAME}"/>
				<input type="hidden" name="AUTHORUSERID" value="{/H2G2/VIEWING-USER/USER/USERID}"/>
				<input type="hidden" name="AUTHORUSERNAME" value="{/H2G2/VIEWING-USER/USER/USERNAME}"/>
				<input type="hidden" name="DATECREATED" value="{/H2G2/DATE/@SORT}"/>
				<input type="hidden" name="LASTUPDATED" value="{/H2G2/DATE/@SORT}"/>
				<xsl:comment>creating</xsl:comment>
			</xsl:when>
		</xsl:choose>

		<!-- preview -->
		<xsl:apply-templates select="." mode="c_preview"/>


		<xsl:choose>
			<!-- create / edit biog  -->
			<xsl:when test="$current_article_type=3001">
				<xsl:choose>
					<xsl:when test="/H2G2/SITE/IDENTITYSIGNIN = 0">
						<xsl:call-template name="PROFILE_FORM" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="PROFILE_FORM_ID" />
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<!--
			<xsl:when test="$article_type_group='article'">
				<xsl:call-template name="ARTICLE_FORM_WRAPPER" />
			</xsl:when>
			<xsl:when test="$article_subtype = 'match_report'">
				<xsl:call-template name="MATCH_REPORT_FORM_WRAPPER" />
			</xsl:when>
			<xsl:when test="$article_subtype = 'event_report'">
				<xsl:call-template name="EVENT_REPORT_FORM_WRAPPER" />
			</xsl:when>
			<xsl:when test="$article_subtype = 'player_profile'">
				<xsl:call-template name="PLAYER_PROFILE_FORM_WRAPPER" />
			</xsl:when>
			<xsl:when test="$article_subtype = 'team_profile'">
				<xsl:call-template name="TEAM_PROFILE_FORM_WRAPPER" />
			</xsl:when>
			-->
			<xsl:when test="$current_article_type=1 and $test_IsEditor and /H2G2/PARAMS/PARAM[NAME='s_editorial']">
				<xsl:call-template name="EDITORIAL_ARTICLE_FORM" /><!-- e.g named article for dynamic lists -->
			</xsl:when>
			<xsl:when test="$current_article_type=2 and $test_IsEditor">
				<xsl:call-template name="EDITORIAL_ARTICLE_FORM" /><!-- e.g named article for house rules -->
			</xsl:when>
			<xsl:when test="$current_article_type=4 and $test_IsEditor">
				<xsl:call-template name="POPUP_ARTICLE_FORM" /><!-- e.g named article for house rules -->
			</xsl:when>
			<!--
			<xsl:otherwise>
				<noscript>
					<xsl:call-template name="CHOOSE_ARTICLE_TYPE_SCREEN"/>
				</noscript>
				<xsl:call-template name="COMBINED_FORM_MAIN"/>
			</xsl:otherwise>
			-->
			<xsl:otherwise>
				<xsl:call-template name="COMBINED_FORM_WRAPPER" />
			</xsl:otherwise>
		</xsl:choose>

		<xsl:if test="$test_IsEditor">
			<br clear="all"/>
			<div id="typedarticle_editorbox">
				<!-- Managers pick dropdown -->
				<label for="managerspick">Managers' pick</label>&nbsp;&nbsp;
				<select name="MANAGERSPICK" id="managerspick">
					<option value="">no</option>
					<option value="managerspick"><xsl:if test="MULTI-ELEMENT[@NAME='MANAGERSPICK']/VALUE-EDITABLE = 'managerspick'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>yes</option>
				</select><br />
				<br />
				<!-- Editors Tools -->
				<xsl:apply-templates select="." mode="c_permissionchange"/>
				<xsl:apply-templates select="." mode="c_articlestatus"/>
				<xsl:apply-templates select="." mode="c_articletype"/>
				<xsl:apply-templates select="." mode="c_makearchive"/>
				<xsl:apply-templates select="." mode="c_deletearticle"/>
				<xsl:apply-templates select="." mode="c_hidearticle"/>
				<xsl:apply-templates select="." mode="c_poll"/>
			</div>
		</xsl:if>
	</xsl:template>

	<!--
	<xsl:template match="MULTI-STAGE" mode="r_permissionchange">
	Use: Presentation of the article edit permissions functionality
	 -->
	<xsl:template match="MULTI-STAGE" mode="r_permissionchange">
		Editable by:
		<ul>
			<li>
				<xsl:apply-templates select="." mode="t_permissionowner"/> Owner only
			</li>
			<li>
				<xsl:apply-templates select="." mode="t_permissionall"/> Everybody
			</li>
		</ul>
	</xsl:template>


	<!--
	<xsl:template match="MULTI-STAGE" mode="r_articlestatus">
	Use: Presentation of the article status functionality
	 -->
	<xsl:template match="MULTI-STAGE" mode="r_articlestatus">
		<br/>
		Article status:
		<xsl:apply-imports/>
		<br/>
	</xsl:template>
	<!--
	<xsl:template match="MULTI-STAGE" mode="r_articletype">
	Use: Presentation of the article type functionality
	 -->
	<xsl:template match="MULTI-STAGE" mode="r_articletype">
		Article type: <xsl:apply-templates select="." mode="t_articletype"/>
	</xsl:template>
	<!--
	<xsl:template match="MULTI-STAGE" mode="r_makearchive">
	Use: Presentation of the archive article functionality
	 -->
	<xsl:template match="MULTI-STAGE" mode="r_makearchive">
		<br/>Archive this forum?: <xsl:apply-templates select="." mode="t_makearchive"/>
		<br/>
	</xsl:template>

	<!--
	<xsl:template match="MULTI-STAGE" mode="r_preview">
	Use: Presentation of the preview area
	 -->
	<xsl:template match="MULTI-STAGE" mode="r_preview">
	<div id="preview">
		<xsl:choose>
			<xsl:when test="$article_subtype = 'user_article'">
				<xsl:call-template name="ARTICLE" />
			</xsl:when>
			<xsl:when test="$article_subtype = 'match_report'">
				<xsl:call-template name="ARTICLE" />
			</xsl:when>
			<xsl:when test="$article_subtype = 'event_report'">
				<xsl:call-template name="ARTICLE" />
			</xsl:when>
			<xsl:when test="$article_subtype = 'player_profile'">
				<xsl:call-template name="ARTICLE" />
			</xsl:when>
			<xsl:when test="$article_subtype = 'team_profile'">
				<xsl:call-template name="ARTICLE" />
			</xsl:when>
			<xsl:when test="$article_subtype = 'staff_article'">
				<xsl:call-template name="ARTICLE" />
			</xsl:when>
			<xsl:when test="/H2G2/MULTI-STAGE/MULTI-REQUIRED[@NAME='TYPE']/VALUE=3001">
				<xsl:call-template name="USERPAGE_MAINBODY" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="EDITORIAL_ARTICLE" />
			</xsl:otherwise>
		</xsl:choose>
	</div>
	</xsl:template>
	<!--
	<xsl:template match="MULTI-STAGE" mode="r_deletearticle">
	Use: Presentation of the delete article functionality
	 -->
	<xsl:template match="MULTI-STAGE" mode="r_deletearticle">
		<xsl:apply-imports/><br />
	</xsl:template>
	<!--
	<xsl:template match="MULTI-STAGE" mode="r_hidearticle">
	Use: Presentation of the hide article functionality
	 -->
	<xsl:template match="MULTI-STAGE" mode="r_hidearticle">
		Hide this article: <xsl:apply-templates select="." mode="t_hidearticle"/>
	</xsl:template>
	<!--
	<xsl:template match="MULTI-STAGE" mode="r_authorlist">
	Use: Presentation of the authorlist functionality
	 -->
	<!--<xsl:template match="MULTI-STAGE" mode="r_authorlist">
		Authors: <xsl:apply-templates select="." mode="t_authorlist"/>
	</xsl:template>-->
	<!--
	<xsl:template match="ERROR" mode="r_typedarticle">
	Use: Presentation information for the error reports
	 -->
	<xsl:template match="ERROR" mode="r_typedarticle">
		<xsl:choose>
			<xsl:when test="/H2G2/ERROR/@TYPE='SITECLOSED'">
				<xsl:call-template name="siteclosed" />
			</xsl:when>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="ERROR" mode="r_typedarticle">
		<xsl:choose>
			<xsl:when test="/H2G2/ERROR/@TYPE='SITECLOSED'">
				<xsl:call-template name="siteclosed" />
			</xsl:when>
            <xsl:when test="/H2G2/ERROR/@OBJECT='TypedArticle::Create' and contains(/H2G2/ERROR/text(),'exceeded')">
            	<p>Sorry - you have exceeded the maximum number of articles allowed per day.</p> <p>Please refer to our <a href="http://www.bbc.co.uk/dna/606/houserules">house rules</a> for more details and feel free to keep commenting on existing articles.</p>
            </xsl:when>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="ERROR" mode="validation_error_parse">
		<div id="displayXMLerror">
				<xsl:apply-templates select="*|@*|text()"/>
			</div>
	</xsl:template>

	<!--
	<xsl:template match="DELETED" mode="r_deleted">
	Use: Template invoked after deleting an article
	 -->
	<xsl:template match="DELETED" mode="r_article">
		This article has been deleted. If you want to restore any deleted articles you can view them <xsl:apply-imports/>
	</xsl:template>


	<!--
	<xsl:template match="MULTI-ELEMENT" mode="r_poll">
	Use: Template invoked for the 'create a poll' functionality
	 -->
	<xsl:template match="MULTI-STAGE" mode="r_poll">
		<br /><xsl:apply-templates select="." mode="c_content_rating"/>
	</xsl:template>
	<!--
	<xsl:template match="MULTI-ELEMENT" mode="r_content_rating">
	Use: Create a poll box
	 -->
	<xsl:template match="MULTI-STAGE" mode="r_content_rating">
		<xsl:text>Create a poll for this article: </xsl:text>
		<xsl:apply-templates select="." mode="t_content_rating_box"/>
		<br/>
	</xsl:template>

	<!--
	<xsl:template match="MULTI-STAGE" mode="r_assettags">
	Use: presentation of the 'choose some tags' box
	-->
	<xsl:template match="MULTI-STAGE" mode="r_assettags">
		<div class="formRow">
			<label for="keyPhrases">Add some key phrases to this article</label><br />
			<input type="hidden" name="HasKeyPhrases" value="1"/>
			<textarea name="mediaassetkeyphrases" cols="50" rows="4" id="keyPhrases" xsl:use-attribute-sets="iMULTI-STAGE_r_assettags">
				<xsl:value-of select="MULTI-REQUIRED[@NAME='MEDIAASSETKEYPHRASES']/VALUE-EDITABLE"/>
			</textarea>
		</div>
	</xsl:template>


	<xsl:attribute-set name="fMULTI-STAGE_c_article">
		<xsl:attribute name="id">typedarticle</xsl:attribute>
	</xsl:attribute-set>


	<xsl:attribute-set name="iMULTI-STAGE_t_articletitle">
		<xsl:attribute name="size">30</xsl:attribute>
		<xsl:attribute name="class">inputone</xsl:attribute>
		<xsl:attribute name="id">title</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="mMULTI-STAGE_t_articlebody">
		<xsl:attribute name="cols">15</xsl:attribute>
		<xsl:attribute name="rows">10</xsl:attribute>
		<xsl:attribute name="class">inputone</xsl:attribute>
		<xsl:attribute name="id">body</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="mMULTI-STAGE_t_articlepreview"/>
	<xsl:attribute-set name="mMULTI-STAGE_t_articlecreate"/>
	<xsl:attribute-set name="iMULTI-STAGE_t_makearchive"/>
	<xsl:attribute-set name="mMULTI-STAGE_t_hidearticle"/>

</xsl:stylesheet>
