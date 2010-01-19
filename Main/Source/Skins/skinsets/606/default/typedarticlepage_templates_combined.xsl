<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	
	<xsl:template name="COMBINED_FORM_WRAPPER"><noscript>
			<xsl:choose>
				<xsl:when test="$test_current_article_type = 'null'">
					<xsl:call-template name="CHOOSE_ARTICLE_TYPE_SCREEN"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:choose>
						<xsl:when test="$article_type_group = 'article'">
							<xsl:call-template name="ARTICLE_FORM"/>
						</xsl:when>
						<xsl:when test="$article_subtype = 'match_report'">
							<xsl:call-template name="MATCH_REPORT_FORM" />
						</xsl:when>
						<xsl:when test="$article_subtype = 'event_report'">
							<xsl:call-template name="EVENT_REPORT_FORM" />
						</xsl:when>
						<xsl:when test="$article_subtype = 'player_profile'">
							<xsl:call-template name="PLAYER_PROFILE_FORM" />
						</xsl:when>
						<xsl:when test="$article_subtype = 'team_profile'">
							<xsl:call-template name="TEAM_PROFILE_FORM" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:call-template name="CHOOSE_ARTICLE_TYPE_SCREEN"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
		</noscript>
		
		<div class="js">
			<xsl:call-template name="COMBINED_FORM_MAIN"/>
		</div>
	</xsl:template>


	<!-- combined form which can be switched by javascript -->
	<xsl:template name="COMBINED_FORM_MAIN">
		<!-- DEBUG -->
		<xsl:call-template name="TRACE">
			<xsl:with-param name="message">COMBINED_FORM_MAIN</xsl:with-param>
			<xsl:with-param name="pagename">typedarticlepage_templates_combined.xsl</xsl:with-param>
		</xsl:call-template>
		<!-- DEBUG -->

		<xsl:variable name="new_article_type">
			<xsl:choose>	
				<xsl:when test="$current_article_type != 1">
					<xsl:value-of select="$current_article_type"/>
				</xsl:when>
				<xsl:when test="/H2G2/PARAMS/PARAM[NAME='s_type']">
					<xsl:value-of select="/H2G2/PARAMS/PARAM[NAME='s_type']/VALUE"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$default_article_type"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:apply-templates select="/H2G2/MULTI-STAGE/MULTI-REQUIRED/ERRORS/ERROR | /H2G2/MULTI-STAGE/MULTI-ELEMENT/ERRORS/ERROR" mode="c_typedarticle"/>

		<input type="hidden" name="_msxml">
			<xsl:attribute name="value">
				<xsl:choose>
					<xsl:when test="$new_article_type = 15">
						<xsl:value-of select="$article_form"/>
					</xsl:when>
					<xsl:when test="$new_article_type = 14">
						<xsl:value-of select="$team_profile_form"/>
					</xsl:when>
					<xsl:when test="$new_article_type = 13">
						<xsl:value-of select="$player_profile_form"/>
					</xsl:when>
					<xsl:when test="$new_article_type = 12">
						<xsl:value-of select="$event_report_form"/>
					</xsl:when>
					<xsl:when test="$new_article_type = 11">
						<xsl:value-of select="$match_report_form"/>
					</xsl:when>
					<xsl:when test="$new_article_type = 10">
						<xsl:value-of select="$article_form"/>
					</xsl:when>
					<xsl:when test="$new_article_type = 4">
						<xsl:value-of select="$popup_article_fields"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$editorial_article_fields"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
		</input>
		
		<input type="hidden" name="ARTICLEFORUMSTYLE" value="1"/>
		<input type="hidden" name="polltype1" value="3"/>
		<input type="hidden" name="status" value="3"/>
		<input type="hidden" name="type">
			<xsl:attribute name="value"><xsl:value-of select="$new_article_type"/></xsl:attribute>
		</input>


		<!-- 
			============================================================
					AUTO TAGGING 
			============================================================ 
		-->
		<xsl:choose>
			<xsl:when test="$article_subtype = 'match_report'">
				<input type="hidden" name="TYPEOFARTICLE" value="match report sport"/>

				<xsl:variable name="hometeam">
					<xsl:choose>
						<xsl:when test="MULTI-ELEMENT[@NAME='HOMETEAMOTHER']/VALUE-EDITABLE/text()">
							<xsl:value-of select="MULTI-ELEMENT[@NAME='HOMETEAMOTHER']/VALUE-EDITABLE"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="MULTI-ELEMENT[@NAME='HOMETEAM']/VALUE-EDITABLE"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>

				<xsl:variable name="awayteam">
					<xsl:choose>
						<xsl:when test="MULTI-ELEMENT[@NAME='AWAYTEAMOTHER']/VALUE-EDITABLE/text()">
							<xsl:value-of select="MULTI-ELEMENT[@NAME='AWAYTEAMOTHER']/VALUE-EDITABLE"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="MULTI-ELEMENT[@NAME='AWAYTEAM']/VALUE-EDITABLE"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>

				<xsl:variable name="matcheventtitle">
					<xsl:value-of select="$hometeam"/><xsl:text> </xsl:text><xsl:value-of select="MULTI-ELEMENT[@NAME='HOMETEAMSCORE']/VALUE-EDITABLE"/><xsl:text> - </xsl:text><xsl:value-of select="MULTI-ELEMENT[@NAME='AWAYTEAMSCORE']/VALUE-EDITABLE"/><xsl:text> </xsl:text><xsl:value-of select="$awayteam"/>
				</xsl:variable>

				<xsl:comment>
					$hometeam: <xsl:value-of select="$hometeam"/><br />
					$awayteam: <xsl:value-of select="$awayteam"/><br />
					$matcheventtitle: <xsl:value-of select="$matcheventtitle"/> <br />
				</xsl:comment>

				<input type="hidden" name="title" value="{$matcheventtitle}"/>
				<xsl:call-template name="AUTO_HIDDEN_FIELDS_TWO_TEAMS">
					<xsl:with-param name="team1" select="$hometeam"/>
					<xsl:with-param name="team1_label">hometeam</xsl:with-param>
					<xsl:with-param name="team2" select="$awayteam"/>
					<xsl:with-param name="team2_label">awayteam</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$article_subtype = 'event_report'">
					<input type="hidden" name="TYPEOFARTICLE" value="event report sport"/>
			</xsl:when>
			<xsl:when test="$article_subtype = 'player_profile'">
				<input type="hidden" name="TYPEOFARTICLE" value="player profile sport"/>

				<xsl:variable name="team"><xsl:apply-templates select="/H2G2/ARTICLE/GUIDE/TEAM/text()" mode="variablevalue"/></xsl:variable>
				<xsl:variable name="currentteam"><xsl:apply-templates select="/H2G2/ARTICLE/GUIDE/CURRENTTEAM/text()" mode="variablevalue"/></xsl:variable>

				<xsl:call-template name="AUTO_HIDDEN_FIELDS_TWO_TEAMS">
					<xsl:with-param name="team1" select="$team"/>
					<xsl:with-param name="team1_label">team</xsl:with-param>
					<xsl:with-param name="team2" select="$currentteam"/>
					<xsl:with-param name="team2_label">current team</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$article_subtype = 'team_profile'">
				<input type="hidden" name="TYPEOFARTICLE" value="team profile sport"/>

				<!-- use team dropdown or otherteam input to create title for page-->
				<xsl:variable name="selectedteam" select="MULTI-ELEMENT[@NAME='TEAM']/VALUE-EDITABLE/text()"/>
				<xsl:variable name="selectedotherteam" select="MULTI-ELEMENT[@NAME='OTHERTEAM']/VALUE-EDITABLE/text()"/>
				<xsl:variable name="teamprofiletitle">
				<xsl:choose>
					<xsl:when test="$selectedotherteam"><xsl:value-of select="$selectedotherteam"/></xsl:when>
					<xsl:otherwise><xsl:value-of select="$selectedteam"/></xsl:otherwise>
				</xsl:choose>
				</xsl:variable>

				<xsl:comment>
					$selectedteam: <xsl:value-of select="$selectedteam"/><br />
					$selectedotherteam: <xsl:value-of select="$selectedotherteam"/><br />
					$teamprofiletitle: <xsl:value-of select="$teamprofiletitle"/> <br />
				</xsl:comment>
				<input type="hidden" name="title" value="{$teamprofiletitle}"/>

				<xsl:variable name="team"><xsl:value-of select="$teamprofiletitle"/></xsl:variable>

				<xsl:call-template name="AUTO_HIDDEN_FIELDS">
					<xsl:with-param name="team" select="$team"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="$article_subtype = 'staff_article' and $test_IsEditor">
						<input type="hidden" name="TYPEOFARTICLE" value="staff article sport"/>
					</xsl:when>
					<xsl:otherwise>
						<input type="hidden" name="TYPEOFARTICLE" value="user article sport"/>
					</xsl:otherwise>
				</xsl:choose>

				<xsl:variable name="team"><xsl:apply-templates select="/H2G2/ARTICLE/GUIDE/TEAM/text()" mode="variablevalue"/></xsl:variable>

				<xsl:call-template name="AUTO_HIDDEN_FIELDS">
					<xsl:with-param name="team" select="$team"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
		
		

		<!-- 
			============================================================
					END AUTO TAGGING 
			============================================================ 
		-->

		<div class="mainbodysec createarticle">
		
			<!-- form -->
			<div class="formsec">
			<div class="formbox">
				<xsl:call-template name="CHOOSE_ARTICLE_TYPE_DROP_DOWN">
					<xsl:with-param name="new_article_type" select="$new_article_type"/>
				</xsl:call-template>

				<xsl:call-template name="COMBINED_FORM_VARIED_FIELDS">
					<xsl:with-param name="new_article_type" select="$new_article_type"/>
				</xsl:call-template>

				<xsl:choose>
					<xsl:when test="$article_subtype = 'match_report'">
						<xsl:call-template name="MATCH_REPORT_FORM_FIXED_FIELDS">
							<xsl:with-param name="start_step">3</xsl:with-param>
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="$article_subtype = 'event_report'">
						<xsl:call-template name="EVENT_REPORT_FORM_FIXED_FIELDS">
							<xsl:with-param name="start_step">3</xsl:with-param>
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="$article_subtype = 'player_profile'">
						<xsl:call-template name="PLAYER_PROFILE_FORM_FIXED_FIELDS">
							<xsl:with-param name="start_step">3</xsl:with-param>
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="$article_subtype = 'team_profile'">
						<xsl:call-template name="TEAM_PROFILE_FORM_FIXED_FIELDS">
							<xsl:with-param name="start_step">3</xsl:with-param>
						</xsl:call-template>
					</xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="ARTICLE_FORM_FIXED_FIELDS">
							<xsl:with-param name="start_step">3</xsl:with-param>
						</xsl:call-template>
					</xsl:otherwise>
				</xsl:choose>

				<!-- submit buttons -->
				<xsl:call-template name="SUBMIT_BUTTONS" />
				
			</div><!-- / formbox -->
			</div><!-- / formsec -->	

			<!-- 
			<p class="top"><a href="#top">Back to top</a></p>
			-->

			<!-- hints and tips -->
			<!--[FIXME: remove]
			<div class="hintsec">				
				<div class="hintbox">	
					<h3>HINTS AND TIPS</h3>
					<p>Choose a subject you are knowledgeable about.</p>

					<p>Check your facts - getting the basics wrong devalues your article.</p>

					<p>Keep it lively.</p>

					<p>Don't be frightened of being opinionated.</p>

				</div>  
			</div>
			-->

			<div class="clear"></div>
		</div><!-- / mainbodysec -->
	</xsl:template>

	<xsl:template name="CHOOSE_ARTICLE_TYPE_DROP_DOWN">
		<xsl:param name="new_article_type" select="$default_article_type"/>
		
		<!-- DEBUG -->
		<xsl:call-template name="TRACE">
			<xsl:with-param name="message">CHOOSE_ARTICLE_TYPE_DROP_DOWN</xsl:with-param>
			<xsl:with-param name="pagename">typedarticlepage_templates_combined.xsl</xsl:with-param>
		</xsl:call-template>
		<!-- DEBUG -->
		
		<table cellpadding="0" cellspacing="0" border="0" width="100%">
		<!-- 2 -->
		<tr>
			<td width="47" valign="top" align="center">
				<img height="28" hspace="0" vspace="0" border="0" width="28" alt="one" src="{$imagesource}1.gif" />
			</td>
			<td valign="top">
				<div class="frow">
					<xsl:if test="MULTI-REQUIRED[@NAME='TYPE']/ERRORS/ERROR/@TYPE='VALIDATION-ERROR-EMPTY'">
						<xsl:attribute name="class">frow alert</xsl:attribute>
						<div class="errortext"><strong>Please enter a type</strong></div>
					</xsl:if>
					<div class="labeltwo"><label for="s_type">What are you going to write?</label></div>
					<select name="s_type" id="s_type" class="inputone" onchange="combined_type_onchange(this)">
						<xsl:choose>
							<xsl:when test="$test_IsEditor">
								<option value="15">
									<xsl:if test="$new_article_type = 15">
										<xsl:attribute name="selected">selected</xsl:attribute>
									</xsl:if>
									Article
								</option>
							</xsl:when>
							<xsl:otherwise>
								<option value="10">
									<xsl:if test="$new_article_type = 10">
										<xsl:attribute name="selected">selected</xsl:attribute>
									</xsl:if>
									Article
								</option>
							</xsl:otherwise>
						</xsl:choose>

						<option value="11">
							<xsl:if test="$new_article_type = 11">
								<xsl:attribute name="selected">selected</xsl:attribute>
							</xsl:if>
							Match article
						</option>
						<option value="12">
							<xsl:if test="$new_article_type = 12">
								<xsl:attribute name="selected">selected</xsl:attribute>
							</xsl:if>
							Event article
						</option>
						<option value="13">
							<xsl:if test="$new_article_type = 13">
								<xsl:attribute name="selected">selected</xsl:attribute>
							</xsl:if>
							Player profile
						</option>
						<option value="14">
							<xsl:if test="$new_article_type = 14">
								<xsl:attribute name="selected">selected</xsl:attribute>
							</xsl:if>
							Team profile
						</option>
					</select>
				</div>	
			</td>
			<td class="rowinfo">
				<xsl:choose>
					<xsl:when test="$new_article_type = 10">
						<div class="pad">
							<xsl:text>An article can be used to write a few quick thoughts or anything up to 5000 characters</xsl:text>
						</div>
					</xsl:when>
					<xsl:when test="$new_article_type = 11">
						<div class="pad">
							<xsl:text>This can be used to write a match report or just host a debate before, during or after the game.</xsl:text>
						</div>
					</xsl:when>
					<xsl:when test="$new_article_type = 12">
						<div class="pad">
							<xsl:text>This can be used to write a report or just host a debate before, during or after the event</xsl:text>
						</div>
					</xsl:when>
					<xsl:when test="$new_article_type = 13">
						<div class="pad">
							<xsl:text>A player profile is a place to celebrate or criticise any sportsperson</xsl:text>
						</div>
					</xsl:when>
					<xsl:when test="$new_article_type = 14">
						<div class="pad">
							<xsl:text>This is a chance to celebrate or criticise any team</xsl:text>
						</div>
					</xsl:when>
				</xsl:choose>
			</td>
		</tr>
		</table>
	</xsl:template>


	<xsl:template name="COMBINED_FORM_VARIED_FIELDS">
		<xsl:param name="new_article_type" select="$default_article_type"/>
		
		<!-- DEBUG -->
		<xsl:call-template name="TRACE">
			<xsl:with-param name="message">COMBINED_FORM_VARIED_FIELDS</xsl:with-param>
			<xsl:with-param name="pagename">typedarticlepage_templates_combined.xsl</xsl:with-param>
		</xsl:call-template>
		<!-- DEBUG -->
		
		<h2 class="formStep1">What you choose here will help other fans find what you've created</h2>
		<table cellpadding="0" cellspacing="0" border="0" width="100%">
		<!-- 2 -->
		<tr>
			<td width="47" valign="top" align="center">
				<img height="28" hspace="0" vspace="0" border="0" width="28" alt="two" src="{$imagesource}2.gif" />
			</td>
			<td valign="top">
				<div id="ajaxWrapper">
					<div class="frow">
						<xsl:if test="MULTI-REQUIRED[@NAME='SPORT']/ERRORS/ERROR/@TYPE='VALIDATION-ERROR-EMPTY'">
							<xsl:attribute name="class">frow alert</xsl:attribute>
							<div class="errortext"><strong>Please choose a sport</strong></div>
						</xsl:if>
						<div class="labeltwo"><label for="s_spotr">What sport or event are you writing about?</label></div>
						<select name="s_sport" id="s_sport" class="inputone" onchange="combined_sport_onchange(this)">
							<xsl:call-template name="SELECT_SPORT_COMBINED_OPTIONS">
								<xsl:with-param name="new_article_type" select="$new_article_type"/>
							</xsl:call-template>
						</select>
					</div>
					
					<div id="ajaxTarget">
						<xsl:call-template name="SPORT_VARIATIONS"/>
					</div>
					
					<div id="TA_S_Error">
						<div class="inner">
							<h3>There has been an error</h3>
							<p>
								There has been a technical difficulty updating the form.<br/>
							</p>
							<p>
								Please try again later 
								<!--[FIXME: implement]
								or switch to <a herf="javascript:_TA_S_switchToManual()">basic mode</a>
								-->
							</p>
							<div class="closeButton">
								<a href="javascript:_TA_S_closeError()">Close</a>
							</div>
						</div>
					</div>
					
					<div id="TA_S_Loading">
						<div class="animation">
							<img src="{$imagesource}refresh/loading_small.gif" alt="loading"/>

						</div>
						<div class="cancelButton">
							<a href="javascript:_TA_S_cancelRequest()">Cancel</a>
						</div>
					</div>
					
				</div>
			</td>
		</tr>
		</table>
	</xsl:template>

	<!--
	DEPRECATED
	
	-->
	<!-- form used for creating an article (poll with comments) -->
	<xsl:template name="ARTICLE_FORM_COMBINED">
		<!-- DEBUG -->
		<xsl:call-template name="TRACE">
		<xsl:with-param name="message">USER_ARTICLE_FORM_COMBINED</xsl:with-param>
		<xsl:with-param name="pagename">typedarticlepage_templates_combined.xsl</xsl:with-param>
		</xsl:call-template>
		<!-- DEBUG -->

			<!-- form -->
			<div class="formsec">
			<div class="formbox">
				<!--
				<xsl:call-template name="SELECT_SPORT_COMBINED" />
				-->

				<xsl:call-template name="SELECT_TEAM_COMBINED" />

				<table cellpadding="0" cellspacing="0" border="0">
				<!-- 2 -->
				<tr>
				<td width="47" valign="top" align="center">		
					<img height="28" hspace="0" vspace="0" border="0" width="28" alt="two" src="{$imagesource}3.gif" />
				</td>
				<td>

					<div class="frow">
						<xsl:if test="MULTI-REQUIRED[@NAME='TITLE']/ERRORS/ERROR/@TYPE='VALIDATION-ERROR-EMPTY'">
							<xsl:attribute name="class">frow alert</xsl:attribute>
							<div class="errortext"><strong>Please enter a title</strong></div>
						</xsl:if>
						<div class="labelone"><label for="title">title<span class="required">*</span></label></div>
						<input type="text" name="TITLE" id="title" class="inputone" maxlength="{$maxcharacters_textinput_value}">
							<xsl:attribute name="value">
								<xsl:value-of select="MULTI-REQUIRED[@NAME='TITLE']/VALUE-EDITABLE"/>
							</xsl:attribute>
						</input>
						<xsl:call-template name="maxcharacters_textinput_text" />
					</div>	

				</td>
				</tr>
				<!-- 3 -->
				<tr>
				<td valign="top">		
				<img height="28" hspace="0" vspace="0" border="0" width="28" alt="three" src="{$imagesource}3.gif" />
				</td>
				<td>

				<!-- staff articles can have an image-->
				<xsl:if test="$article_subtype = 'staff_article' and $test_IsEditor">
					<div class="frow">
						<div class="labelone"><label for="image">image</label></div>
						<textarea name="IMAGE" cols="40" rows="6" id="image" class="inputone">
						<xsl:choose>
							<!-- provide example IMAGE code when creating an article - but not on preview or edit -->
							<xsl:when test="/H2G2/MULTI-STAGE/@TYPE='TYPED-ARTICLE-CREATE'">&lt;img src="http://newsimg.bbc.co.uk/media/images/41979000/jpg/example.jpg" width="226" height="170" alt=""/&gt;</xsl:when>
							<!-- if an image has been entered display the code -->
							<xsl:when test="MULTI-ELEMENT[@NAME='IMAGE']/VALUE-EDITABLE/text()">
								<xsl:value-of select="MULTI-ELEMENT[@NAME='IMAGE']/VALUE-EDITABLE"/>
							</xsl:when>
						</xsl:choose>			
						</textarea>
					</div>
				</xsl:if>

				<div class="frow">
					<xsl:if test="MULTI-REQUIRED[@NAME='BODY']/ERRORS/ERROR/@TYPE='VALIDATION-ERROR-EMPTY'">
						<xsl:attribute name="class">frow alert</xsl:attribute>
						<div class="errortext"><strong>Please enter your article text</strong></div>
					</xsl:if>

					<!-- staff articles have no characters limit  -->
					<xsl:choose>
						<xsl:when test="$article_subtype = 'staff_article' and $test_IsEditor">
							<div class="labelone"><label for="body">text<span class="required">*</span></label></div>
							<textarea name="body" cols="15" rows="10" class="inputone" id="body">
								<xsl:value-of select="MULTI-REQUIRED[@NAME='BODY']/VALUE-EDITABLE"/>
							</textarea>
						</xsl:when>
						<xsl:otherwise>
							<div class="labelone"><label for="maxchars5000">text<span class="required">*</span></label>
								<!--[FIXME: remove] -->

							<br/><span class="opt2">(max 5000 characters)</span>
							</div>
							<textarea name="body" cols="15" rows="10" class="inputone" id="maxchars5000">
								<xsl:value-of select="MULTI-REQUIRED[@NAME='BODY']/VALUE-EDITABLE"/>
							</textarea>
						</xsl:otherwise>
					</xsl:choose>
				</div>		

				</td>
				</tr>
				<!-- 4 -->
				<!-- suggest a link -->
				<!--[FIXME: remove]
				<tr>
				<td valign="top">		
				<img height="28" hspace="0" vspace="0" border="0" width="28" alt="four" src="{$imagesource}4.gif" />
				</td>
				<td>

				<xsl:call-template name="SUGGEST_LINK">
					<xsl:with-param name="url">http://news.bbc.co.uk/sport1/</xsl:with-param>
					<xsl:with-param name="title">BBC Sport</xsl:with-param>
				</xsl:call-template>

				</td>
				</tr>
				-->
				</table>

				<!-- submit buttons -->
				<xsl:call-template name="SUBMIT_BUTTONS" />

			</div><!-- / formbox -->
			</div><!-- / formsec -->	

			<div class="clear"></div>
	</xsl:template>



	<!-- below is not used -->
	<xsl:template name="SELECT_TEAM_COMBINED">
		<div id="teams_football">
			<div id="teams_article_football">
				<div class="frow">
					<input type="hidden" name="SPORT" value="Football"/>
				</div>	
				<xsl:call-template name="FOOTBALL_DROP_DOWNS_COMBINED">
					<xsl:with-param name="type">article</xsl:with-param>
				</xsl:call-template>
			</div>
			<div id="teams_match_report_football">
				<div class="frow">
					<input type="hidden" name="SPORT" value="Football"/>
				</div>	
				<xsl:call-template name="FOOTBALL_DROP_DOWNS_COMBINED">
					<xsl:with-param name="type">match_report</xsl:with-param>
				</xsl:call-template>
			</div>
			<div id="teams_event_report_football">
				<div class="frow">
					<input type="hidden" name="SPORT" value="Football"/>
				</div>	
				<xsl:call-template name="FOOTBALL_DROP_DOWNS_COMBINED">
					<xsl:with-param name="type">event_report</xsl:with-param>
				</xsl:call-template>
			</div>
			<div id="teams_player_profile_football">
				<div class="frow">
					<input type="hidden" name="SPORT" value="Football"/>
				</div>	
				<xsl:call-template name="FOOTBALL_DROP_DOWNS_COMBINED">
					<xsl:with-param name="type">player_profile</xsl:with-param>
				</xsl:call-template>
			</div>
			<div id="teams_team_profile_football">
				<div class="frow">
					<input type="hidden" name="SPORT" value="Football"/>
				</div>	
				<xsl:call-template name="FOOTBALL_DROP_DOWNS_COMBINED">
					<xsl:with-param name="type">team_profile</xsl:with-param>
				</xsl:call-template>
			</div>
		</div>
		<!-- cricket -->
		<div id="teams_cricket">
			<div id="teams_article_cricket">
				<div class="frow">
					<input type="hidden" name="SPORT" value="Cricket"/>
				</div>
				<xsl:call-template name="CRICKET_DROP_DOWNS_COMBINED">
					<xsl:with-param name="type">article</xsl:with-param>
				</xsl:call-template>
			</div>
			<div id="teams_match_report_cricket">
				<div class="frow">
					<input type="hidden" name="SPORT" value="Cricket"/>
				</div>
				<xsl:call-template name="CRICKET_DROP_DOWNS_COMBINED">
					<xsl:with-param name="type">match_report</xsl:with-param>
				</xsl:call-template>
			</div>
			<div id="teams_event_report_cricket">
				<div class="frow">
					<input type="hidden" name="SPORT" value="Cricket"/>
				</div>
				<xsl:call-template name="CRICKET_DROP_DOWNS_COMBINED">
					<xsl:with-param name="type">event_report</xsl:with-param>
				</xsl:call-template>
			</div>
			<div id="teams_player_profile_cricket">
				<div class="frow">
					<input type="hidden" name="SPORT" value="Cricket"/>
				</div>
				<xsl:call-template name="CRICKET_DROP_DOWNS_COMBINED">
					<xsl:with-param name="type">player_profile</xsl:with-param>
				</xsl:call-template>
			</div>
			<div id="teams_team_profile_cricket">
				<div class="frow">
					<input type="hidden" name="SPORT" value="Cricket"/>
				</div>
				<xsl:call-template name="CRICKET_DROP_DOWNS_COMBINED">
					<xsl:with-param name="type">team_profile</xsl:with-param>
				</xsl:call-template>
			</div>
		</div>

		<!-- rugby union -->
		<div id="teams_rugby_union">
			<div id="teams_article_rugby_union">
				<div class="frow">
					<input type="hidden" name="SPORT" value="Rugby union"/>
				</div>
				<xsl:call-template name="RUGBY_UNION_DROP_DOWNS_COMBINED">
					<xsl:with-param name="type">article</xsl:with-param>
				</xsl:call-template>
			</div>
			<div id="teams_match_report_rugby_union">
				<div class="frow">
					<input type="hidden" name="SPORT" value="Rugby union"/>
				</div>
				<xsl:call-template name="RUGBY_UNION_DROP_DOWNS_COMBINED">
					<xsl:with-param name="type">match_report</xsl:with-param>
				</xsl:call-template>
			</div>
			<div id="teams_event_report_rugby_union">
				<div class="frow">
					<input type="hidden" name="SPORT" value="Rugby union"/>
				</div>
				<xsl:call-template name="RUGBY_UNION_DROP_DOWNS_COMBINED">
					<xsl:with-param name="type">event_report</xsl:with-param>
				</xsl:call-template>
			</div>
			<div id="teams_player_profile_rugby_union">
				<div class="frow">
					<input type="hidden" name="SPORT" value="Rugby union"/>
				</div>
				<xsl:call-template name="RUGBY_UNION_DROP_DOWNS_COMBINED">
					<xsl:with-param name="type">player_profile</xsl:with-param>
				</xsl:call-template>
			</div>
			<div id="teams_team_profile_rugby_union">
				<div class="frow">
					<input type="hidden" name="SPORT" value="Rugby union"/>
				</div>
				<xsl:call-template name="RUGBY_UNION_DROP_DOWNS_COMBINED">
					<xsl:with-param name="type">team_profile</xsl:with-param>
				</xsl:call-template>
			</div>
		</div>

		<!-- rugby league -->
		<div id="teams_rugby_league">
			<div id="teams_article_rugby_league">
				<div class="frow">
					<input type="hidden" name="SPORT" value="Rugby league"/>
				</div>
				<xsl:call-template name="RUGBY_LEAGUE_DROP_DOWNS_COMBINED">
					<xsl:with-param name="type">article</xsl:with-param>
				</xsl:call-template>
			</div>
			<div id="teams_match_report_rugby_league">
				<div class="frow">
					<input type="hidden" name="SPORT" value="Rugby league"/>
				</div>
				<xsl:call-template name="RUGBY_LEAGUE_DROP_DOWNS_COMBINED">
					<xsl:with-param name="type">match_report</xsl:with-param>
				</xsl:call-template>
			</div>
			<div id="teams_player_event_report_rugby_league">
				<div class="frow">
					<input type="hidden" name="SPORT" value="Rugby league"/>
				</div>
				<xsl:call-template name="RUGBY_LEAGUE_DROP_DOWNS_COMBINED">
					<xsl:with-param name="type">event_report</xsl:with-param>
				</xsl:call-template>
			</div>
			<div id="teams_player_profile_rugby_league">
				<div class="frow">
					<input type="hidden" name="SPORT" value="Rugby league"/>
				</div>
				<xsl:call-template name="RUGBY_LEAGUE_DROP_DOWNS_COMBINED">
					<xsl:with-param name="type">player_profile</xsl:with-param>
				</xsl:call-template>
			</div>
			<div id="teams_team_profile_rugby_league">
				<div class="frow">
					<input type="hidden" name="SPORT" value="Rugby league"/>
				</div>
				<xsl:call-template name="RUGBY_LEAGUE_DROP_DOWNS_COMBINED">
					<xsl:with-param name="type">team_profile</xsl:with-param>
				</xsl:call-template>
			</div>
		</div>

		<!-- motorsport -->
		<div id="teams_motorsport">
			<div class="frow">
				<input type="hidden" name="SPORT" value="Motorsport"/>
			</div>
			<xsl:call-template name="MOTORSPORT_DROP_DOWNS_COMBINED">
				<xsl:with-param name="type">article</xsl:with-param>
			</xsl:call-template>
		</div>

		<!-- disability sport -->	
		<div id="disability_sport">
			<div class="frow">
				<input type="hidden" name="SPORT" value="Disability sport"/>
			</div>
			<xsl:call-template name="COMPETITION_INPUTBOX" />
		</div>

		<!-- other sport -->
		<div id="teams_other">
			<div class="frow">
				<input type="hidden" name="SPORT" value="Othersport"/>
			</div>
			<xsl:call-template name="OTHER_SPORT_DROP_DOWNS" />
		</div>
	</xsl:template>


	<xsl:template name="SELECT_SPORT_COMBINED_OPTIONS">
		<option value="">Choose your sport</option>
		<xsl:choose>
			<xsl:when test="$article_subtype='match_report'">
				<!-- MATCH REPORT -->
				<option value="football">
					<xsl:if test="/H2G2/PARAMS/PARAM[NAME='s_sport']/VALUE = 'football' or $sport = 'Football'">
					<xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Football
				</option>
				<option value="cricket">
					<xsl:if test="/H2G2/PARAMS/PARAM[NAME='s_sport']/VALUE = 'cricket' or $sport = 'Cricket'">
					<xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Cricket
				</option>
				<option value="rugby_union">
					<xsl:if test="/H2G2/PARAMS/PARAM[NAME='s_sport']/VALUE = 'rugby_union' or $sport = 'Rugby Union'">
					<xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Rugby union
				</option>
				<option value="rugby_league">
					<xsl:if test="/H2G2/PARAMS/PARAM[NAME='s_sport']/VALUE = 'rugby_league' or $sport = 'Rugby League'">
					<xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Rugby league
				</option>
				<option value="tennis">
					<xsl:if test="/H2G2/PARAMS/PARAM[NAME='s_sport']/VALUE = 'tennis' or $sport = 'Tennis'">
					<xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Tennis
				</option>
				<option value="golf">
					<xsl:if test="/H2G2/PARAMS/PARAM[NAME='s_sport']/VALUE = 'golf' or $sport = 'Golf'">
					<xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Golf
				</option>
				<option value="motorsport">
					<xsl:if test="/H2G2/PARAMS/PARAM[NAME='s_sport']/VALUE = 'motorsport' or $sport = 'Motorsport'">
					<xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Motorsport
				</option>
				<option value="boxing">
					<xsl:if test="/H2G2/PARAMS/PARAM[NAME='s_sport']/VALUE = 'boxing' or $sport = 'Boxing'">
					<xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Boxing
				</option>
				<option value="athletics">
					<xsl:if test="/H2G2/PARAMS/PARAM[NAME='s_sport']/VALUE = 'athletics' or $sport = 'Athletics'">
					<xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Athletics
				</option>
				<option value="snooker">
					<xsl:if test="/H2G2/PARAMS/PARAM[NAME='s_sport']/VALUE = 'snooker' or $sport = 'Snooker'">
					<xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Snooker
				</option>
				<option value="horse_racing">
					<xsl:if test="/H2G2/PARAMS/PARAM[NAME='s_sport']/VALUE = 'horse_racing' or $sport = 'Horse Racing'">
					<xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Horse racing
				</option>
				<option value="cycling">
					<xsl:if test="/H2G2/PARAMS/PARAM[NAME='s_sport']/VALUE = 'cycling' or $sport = 'Cycling'">
					<xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Cycling
				</option>
				<!--[FIXME: taken out for now]
				<option value="disability_sport">
					<xsl:if test="/H2G2/PARAMS/PARAM[NAME='s_sport']/VALUE = 'disability_sport' or $sport = 'Disability Sport'">
					<xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Disability sport
				</option>
				-->
				<option value="other">
					<xsl:if test="/H2G2/PARAMS/PARAM[NAME='s_sport']/VALUE = 'other' or $sport = 'Other Sport'">
					<xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Other Sport
				</option>
			</xsl:when>
			<xsl:when test="$article_subtype='event_report'">
				<!-- EVENT REPORT -->
				<option value="football">
					<xsl:if test="/H2G2/PARAMS/PARAM[NAME='s_sport']/VALUE = 'football' or $sport = 'Football'">
					<xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Football
				</option>
				<option value="cricket">
					<xsl:if test="/H2G2/PARAMS/PARAM[NAME='s_sport']/VALUE = 'cricket' or $sport = 'Cricket'">
					<xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Cricket
				</option>
				<option value="rugby_union">
					<xsl:if test="/H2G2/PARAMS/PARAM[NAME='s_sport']/VALUE = 'rugby_union' or $sport = 'Rugby Union'">
					<xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Rugby union
				</option>
				<option value="rugby_league">
					<xsl:if test="/H2G2/PARAMS/PARAM[NAME='s_sport']/VALUE = 'rugby_league' or $sport = 'Rugby League'">
					<xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Rugby league
				</option>
				<option value="tennis">
					<xsl:if test="/H2G2/PARAMS/PARAM[NAME='s_sport']/VALUE = 'tennis' or $sport = 'Tennis'">
					<xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Tennis
				</option>
				<option value="golf">
					<xsl:if test="/H2G2/PARAMS/PARAM[NAME='s_sport']/VALUE = 'golf' or $sport = 'Golf'">
					<xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Golf
				</option>
				<option value="motorsport">
					<xsl:if test="/H2G2/PARAMS/PARAM[NAME='s_sport']/VALUE = 'motorsport' or $sport = 'Motorsport'">
					<xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Motorsport
				</option>
				<option value="boxing">
					<xsl:if test="/H2G2/PARAMS/PARAM[NAME='s_sport']/VALUE = 'boxing' or $sport = 'Boxing'">
					<xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Boxing
				</option>
				<option value="athletics">
					<xsl:if test="/H2G2/PARAMS/PARAM[NAME='s_sport']/VALUE = 'athletics' or $sport = 'Athletics'">
					<xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Athletics
				</option>
				<option value="snooker">
					<xsl:if test="/H2G2/PARAMS/PARAM[NAME='s_sport']/VALUE = 'snooker' or $sport = 'Snooker'">
					<xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Snooker
				</option>
				<option value="horse_racing">
					<xsl:if test="/H2G2/PARAMS/PARAM[NAME='s_sport']/VALUE = 'horse_racing' or $sport = 'Horse Racing'">
					<xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Horse racing
				</option>
				<option value="cycling">
					<xsl:if test="/H2G2/PARAMS/PARAM[NAME='s_sport']/VALUE = 'cycling' or $sport = 'Cycling'">
					<xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Cycling
				</option>
				<!--[FIXME: taken out for now]
				<option value="disability_sport">
					<xsl:if test="/H2G2/PARAMS/PARAM[NAME='s_sport']/VALUE = 'disability_sport' or $sport = 'Disability Sport'">
					<xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Disability sport
				</option>
				-->
				<option value="other">
					<xsl:if test="/H2G2/PARAMS/PARAM[NAME='s_sport']/VALUE = 'other' or $sport = 'Other Sport'">
					<xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Other Sport
				</option>
			</xsl:when>
			<xsl:otherwise>
				<!-- ALL OTHER ARTICLES -->
				<option value="football">
					<xsl:if test="/H2G2/PARAMS/PARAM[NAME='s_sport']/VALUE = 'football' or $sport = 'Football'">
					<xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Football
				</option>
				<option value="cricket">
					<xsl:if test="/H2G2/PARAMS/PARAM[NAME='s_sport']/VALUE = 'cricket' or $sport = 'Cricket'">
					<xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Cricket
				</option>
				<option value="rugby_union">
					<xsl:if test="/H2G2/PARAMS/PARAM[NAME='s_sport']/VALUE = 'rugby_union' or $sport = 'Rugby Union'">
					<xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Rugby union
				</option>
				<option value="rugby_league">
					<xsl:if test="/H2G2/PARAMS/PARAM[NAME='s_sport']/VALUE = 'rugby_league' or $sport = 'Rugby League'">
					<xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Rugby league
				</option>
				<option value="tennis">
					<xsl:if test="/H2G2/PARAMS/PARAM[NAME='s_sport']/VALUE = 'tennis' or $sport = 'Tennis'">
					<xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Tennis
				</option>
				<option value="golf">
					<xsl:if test="/H2G2/PARAMS/PARAM[NAME='s_sport']/VALUE = 'golf' or $sport = 'Golf'">
					<xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Golf
				</option>
				<option value="motorsport">
					<xsl:if test="/H2G2/PARAMS/PARAM[NAME='s_sport']/VALUE = 'motorsport' or $sport = 'Motorsport'">
					<xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Motorsport
				</option>
				<option value="boxing">
					<xsl:if test="/H2G2/PARAMS/PARAM[NAME='s_sport']/VALUE = 'boxing' or $sport = 'Boxing'">
					<xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Boxing
				</option>
				<option value="athletics">
					<xsl:if test="/H2G2/PARAMS/PARAM[NAME='s_sport']/VALUE = 'athletics' or $sport = 'Athletics'">
					<xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Athletics
				</option>
				<option value="snooker">
					<xsl:if test="/H2G2/PARAMS/PARAM[NAME='s_sport']/VALUE = 'snooker' or $sport = 'Snooker'">
					<xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Snooker
				</option>
				<option value="horse_racing">
					<xsl:if test="/H2G2/PARAMS/PARAM[NAME='s_sport']/VALUE = 'horse_racing' or $sport = 'Horse Racing'">
					<xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Horse racing
				</option>
				<option value="cycling">
					<xsl:if test="/H2G2/PARAMS/PARAM[NAME='s_sport']/VALUE = 'cycling' or $sport = 'Cycling'">
					<xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Cycling
				</option>
				<!--[FIXME: taken out for now]
				<option value="disability_sport">
					<xsl:if test="/H2G2/PARAMS/PARAM[NAME='s_sport']/VALUE = 'disability_sport' or $sport = 'Disability Sport'">
					<xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Disability sport
				</option>
				-->
				<option value="other">
					<xsl:if test="/H2G2/PARAMS/PARAM[NAME='s_sport']/VALUE = 'other' or $sport = 'Other Sport'">
					<xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Other Sport
				</option>
			</xsl:otherwise>
		</xsl:choose>	
	</xsl:template>


	<xsl:template name="FOOTBALL_DROP_DOWNS_COMBINED">
		<xsl:param name="type">article</xsl:param>
		<xsl:choose>
			<xsl:when test="$type='article' or $type='player_profile'">
				<xsl:call-template name="FOOTBALL_TEAMS" />
				<div class="extrabg">
					<strong>and/ or</strong>
					<xsl:call-template name="FOOTBALL_COMPETITIONS" />
				</div>
			</xsl:when>
			<xsl:when test="$type='team_profile'">
				<xsl:call-template name="FOOTBALL_TEAMS" />	
			</xsl:when>
			<xsl:when test="$type='match_report'">
				<xsl:call-template name="FOOTBALL_COMPETITIONS" />	
			</xsl:when>
			<xsl:when test="$type='event_report'">
				<!-- none -->	
			</xsl:when>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="CRICKET_DROP_DOWNS_COMBINED">
		<xsl:param name="type">article</xsl:param>
		<xsl:choose>
			<xsl:when test="$type='article' or $type='player_profile'">
				<xsl:call-template name="CRICKET_TEAMS" />
				<div class="extrabg">
					<strong>and/ or</strong>
					<xsl:call-template name="CRICKET_COMPETITIONS" />
				</div>
			</xsl:when>
			<xsl:when test="$type='team_profile'">
				<xsl:call-template name="CRICKET_TEAMS" />	
			</xsl:when>
			<xsl:when test="$type='match_report'">
				<xsl:call-template name="CRICKET_COMPETITIONS" />	
			</xsl:when>
			<xsl:when test="$type='event_report'">
				<!-- none -->	
			</xsl:when>
		</xsl:choose>	
	</xsl:template>

	<xsl:template name="RUGBY_UNION_DROP_DOWNS_COMBINED">
		<xsl:param name="type">article</xsl:param>

		<xsl:choose>
			<xsl:when test="$type='article' or $type='player_profile'">
				<xsl:call-template name="RUGBY_UNION_TEAMS" />
				<div class="extrabg">
					<strong>and/ or</strong>
					<xsl:call-template name="RUGBY_UNION_COMPETITIONS" />
				</div>
			</xsl:when>
			<xsl:when test="$type='team_profile'">
				<xsl:call-template name="RUGBY_UNION_TEAMS" />	
			</xsl:when>
			<xsl:when test="$type='match_report'">
				<xsl:call-template name="RUGBY_UNION_COMPETITIONS" />
			</xsl:when>
			<xsl:when test="$type='event_report'">
				<!-- none -->	
			</xsl:when>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="RUGBY_LEAGUE_DROP_DOWNS_COMBINED">
		<xsl:param name="type">article</xsl:param>

		<xsl:choose>
			<xsl:when test="$type='article' or $type='player_profile'">
				<xsl:call-template name="RUGBY_LEAGUE_TEAMS" />
				<div class="extrabg">
					<strong>and/ or</strong>
					<xsl:call-template name="RUGBY_LEAGUE_COMPETITIONS" />
				</div>
			</xsl:when>
			<xsl:when test="$type='team_profile'">
				<xsl:call-template name="RUGBY_LEAGUE_TEAMS" />	
			</xsl:when>
			<xsl:when test="$type='match_report'">
				<xsl:call-template name="RUGBY_LEAGUE_COMPETITIONS" />	
			</xsl:when>
			<xsl:when test="$type='event_report'">
				<!-- none -->	
			</xsl:when>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="MOTORSPORT_DROP_DOWNS_COMBINED">

		<div class="frow" id="typewrapper">
			<div class="labelone"><label for="type">Choose a type</label></div>
			<select name="COMPETITION" id="type" class="inputselect">
				<option value="">select a type</option>
				<option value="Formula One"><xsl:if test="MULTI-ELEMENT[@NAME='COMPETITION']/VALUE-EDITABLE = 'Formula One'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Formula One</option>
				<option value="Rallying"><xsl:if test="MULTI-ELEMENT[@NAME='COMPETITION']/VALUE-EDITABLE = 'Rallying'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Rallying</option>
				<option value="Motorbikes"><xsl:if test="MULTI-ELEMENT[@NAME='COMPETITION']/VALUE-EDITABLE = 'Motorbikes'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Motorbikes</option>
				<option value="Speedway"><xsl:if test="MULTI-ELEMENT[@NAME='COMPETITION']/VALUE-EDITABLE = 'Speedway'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Speedway</option>
				<option value="Othertype"><xsl:if test="MULTI-ELEMENT[@NAME='COMPETITION']/VALUE-EDITABLE = 'Othertype'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Other</option>	
			</select>
			<div class="inputinfo" id="cantfindtype"></div>
		</div>

		<div class="frow" id="othertypewrapper">
			<div class="labelone"><label for="othertype">other<br /></label></div>
			<input type="text" name="OTHERCOMPETITION" id="othertype" class="inputone" maxlength="{$maxcharacters_textinput_value}">
				<xsl:attribute name="value">
					<xsl:value-of select="MULTI-ELEMENT[@NAME='OTHERCOMPETITION']/VALUE-EDITABLE"/>
				</xsl:attribute>
			</input>
			<xsl:call-template name="maxcharacters_textinput_text" />
		</div>
	</xsl:template>
</xsl:stylesheet>
