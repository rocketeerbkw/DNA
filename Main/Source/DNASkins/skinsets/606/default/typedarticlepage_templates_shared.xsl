<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">

    <!--
        code which is shared between HTMLOutput and XMLOutput (or in this case XHTMLOutput)
    -->

	<xsl:template name="SPORT_VARIATIONS">
		<xsl:variable name="sport">
			<xsl:choose>
				<xsl:when test="/H2G2/MULTI-STAGE/MULTI-ELEMENT[@NAME='SPORT']/VALUE">
					<xsl:value-of select="/H2G2/MULTI-STAGE/MULTI-ELEMENT[@NAME='SPORT']/VALUE"/>
				</xsl:when>
				<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_sport']/VALUE">
					<xsl:value-of select="/H2G2/PARAMS/PARAM[NAME = 's_sport']/VALUE"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>null</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:choose>
			<xsl:when test="/H2G2/MULTI-STAGE/MULTI-ELEMENT[@NAME='SPORT']/VALUE='Football' or /H2G2/PARAMS/PARAM[NAME = 's_sport']/VALUE = 'football'">
				<input type="hidden" name="SPORT" value="Football"/>
				<xsl:call-template name="FOOTBALL_DROP_DOWNS" />
			</xsl:when>
			<xsl:when test="/H2G2/MULTI-STAGE/MULTI-ELEMENT[@NAME='SPORT']/VALUE='Cricket' or /H2G2/PARAMS/PARAM[NAME = 's_sport']/VALUE = 'cricket'">
				<input type="hidden" name="SPORT" value="Cricket"/>
				<xsl:call-template name="CRICKET_DROP_DOWNS" />
			</xsl:when>
			<xsl:when test="/H2G2/MULTI-STAGE/MULTI-ELEMENT[@NAME='SPORT']/VALUE='Rugby union' or /H2G2/PARAMS/PARAM[NAME = 's_sport']/VALUE = 'rugby_union'">
				<input type="hidden" name="SPORT" value="Rugby union"/>
				<xsl:call-template name="RUGBY_UNION_DROP_DOWNS" />
			</xsl:when>
			<xsl:when test="/H2G2/MULTI-STAGE/MULTI-ELEMENT[@NAME='SPORT']/VALUE='Rugby league' or /H2G2/PARAMS/PARAM[NAME = 's_sport']/VALUE = 'rugby_league'">
				<input type="hidden" name="SPORT" value="Rugby league"/>
				<xsl:call-template name="RUGBY_LEAGUE_DROP_DOWNS" />
			</xsl:when>
			<xsl:when test="/H2G2/MULTI-STAGE/MULTI-ELEMENT[@NAME='SPORT']/VALUE='Tennis' or /H2G2/PARAMS/PARAM[NAME = 's_sport']/VALUE = 'tennis'">
				<input type="hidden" name="SPORT" value="Tennis"/>
				<xsl:call-template name="TENNIS_DROP_DOWNS" />
			</xsl:when>
			<xsl:when test="/H2G2/MULTI-STAGE/MULTI-ELEMENT[@NAME='SPORT']/VALUE='Golf' or /H2G2/PARAMS/PARAM[NAME = 's_sport']/VALUE = 'golf'">
				<input type="hidden" name="SPORT" value="Golf"/>
				<xsl:call-template name="GOLF_DROP_DOWNS" />
			</xsl:when>
			<xsl:when test="/H2G2/MULTI-STAGE/MULTI-ELEMENT[@NAME='SPORT']/VALUE='Motorsport' or /H2G2/PARAMS/PARAM[NAME = 's_sport']/VALUE = 'motorsport'">
				<input type="hidden" name="SPORT" value="Motorsport"/>
				<xsl:call-template name="MOTORSPORT_DROP_DOWNS" />
				<!--
				<xsl:choose>
					<xsl:when test="$article_subtype='event_report'">
						<xsl:call-template name="MOTORSPORT_DROP_DOWNS" />
						<xsl:call-template name="EVENT_REPORT_OTHER_COMPETITION"/>
					</xsl:when>
					<xsl:when test="$article_subtype='player_profile'">
						<xsl:call-template name="MOTORSPORT_DROP_DOWNS" />
						<xsl:call-template name="PLAYER_PROFILE_TEAM_INPUTBOX" />
					</xsl:when>
					<xsl:when test="$article_subtype='team_profile'">
						<xsl:call-template name="MOTORSPORT_DROP_DOWNS" />
						<xsl:call-template name="TEAM_PROFILE_TEAM_INPUTBOX" />
						<xsl:call-template name="TEAM_PROFILE_OTHER_COMPETITION"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="MOTORSPORT_DROP_DOWNS" />
					</xsl:otherwise>
				</xsl:choose>
				-->
			</xsl:when>
			<xsl:when test="/H2G2/MULTI-STAGE/MULTI-ELEMENT[@NAME='SPORT']/VALUE='Boxing' or /H2G2/PARAMS/PARAM[NAME = 's_sport']/VALUE = 'boxing'">
				<input type="hidden" name="SPORT" value="Boxing"/>
				<xsl:call-template name="BOXING_DROP_DOWNS" />
			</xsl:when>
			<xsl:when test="/H2G2/MULTI-STAGE/MULTI-ELEMENT[@NAME='SPORT']/VALUE='Athletics' or /H2G2/PARAMS/PARAM[NAME = 's_sport']/VALUE = 'athletics'">
				<input type="hidden" name="SPORT" value="Athletics"/>
				<xsl:call-template name="ATHLETICS_DROP_DOWNS" />
			</xsl:when>
			<xsl:when test="/H2G2/MULTI-STAGE/MULTI-ELEMENT[@NAME='SPORT']/VALUE='Snooker' or /H2G2/PARAMS/PARAM[NAME = 's_sport']/VALUE = 'snooker'">
				<input type="hidden" name="SPORT" value="Snooker"/>
				<xsl:call-template name="SNOOKER_DROP_DOWNS" />
			</xsl:when>
			<xsl:when test="/H2G2/MULTI-STAGE/MULTI-ELEMENT[@NAME='SPORT']/VALUE='Horse racing' or /H2G2/PARAMS/PARAM[NAME = 's_sport']/VALUE = 'horse_racing'">
				<input type="hidden" name="SPORT" value="Horse racing"/>
				<xsl:call-template name="HORSE_RACING_DROP_DOWNS" />
			</xsl:when>
			<xsl:when test="/H2G2/MULTI-STAGE/MULTI-ELEMENT[@NAME='SPORT']/VALUE='Cycling' or /H2G2/PARAMS/PARAM[NAME = 's_sport']/VALUE = 'cycling'">
				<input type="hidden" name="SPORT" value="Cycling"/>
				<xsl:call-template name="CYCLING_DROP_DOWNS" />
			</xsl:when>
			<xsl:when test="/H2G2/MULTI-STAGE/MULTI-ELEMENT[@NAME='SPORT']/VALUE='Disability sport' or /H2G2/PARAMS/PARAM[NAME = 's_sport']/VALUE = 'disability_sport'">
				<input type="hidden" name="SPORT" value="Disability sport"/>
				<xsl:call-template name="DISABILITY_SPORT_DROP_DOWNS" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:if test="$sport != 'null'">
					<input type="hidden" name="SPORT" value="Othersport"/>
					<xsl:call-template name="OTHER_SPORT_DROP_DOWNS" />
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- max characters -->
	<xsl:variable name="maxcharacters_textinput_value">43</xsl:variable>
	<xsl:variable name="maxcharacters_textinput_value_limited">14</xsl:variable>
	<xsl:template name="maxcharacters_textinput_text">
		<div class="inputinfo">43 characters max</div>
	</xsl:template>
	<xsl:template name="maxcharacters_textinput_text_limited">
		<div class="inputinfo">14 characters max</div>
	</xsl:template>
	<xsl:template name="maxcharacters_textinput_text2">
		<div class="inputinfo2">43 characters max</div>
	</xsl:template>
	<xsl:template name="maxcharacters_textinput_text2_limited">
		<div class="inputinfo2">14 characters max</div>
	</xsl:template>


	<!--
		FIXED FIELDS
	-->
	<xsl:template name="ARTICLE_FORM_FIXED_FIELDS">
		<xsl:param name="start_step">2</xsl:param>

		<table cellpadding="0" cellspacing="0" border="0">
		<!-- 2 -->
		<tr>
		<td width="47" valign="top" align="center">
			<img height="28" hspace="0" vspace="0" border="0" width="28" alt="{$start_step}" src="{$imagesource}{$start_step}.gif" />
		</td>
		<td>

			<div class="frow">
				<xsl:if test="MULTI-REQUIRED[@NAME='TITLE']/ERRORS/ERROR/@TYPE='VALIDATION-ERROR-EMPTY'">
					<xsl:attribute name="class">frow alert</xsl:attribute>
					<div class="errortext"><strong>Please enter a title</strong></div>
				</xsl:if>
				<div class="labelone"><label for="title">What is the title of your article?<span class="required">*</span></label></div>
				<input type="text" name="TITLE" id="title" class="inputone" maxlength="{$maxcharacters_textinput_value}">
					<xsl:attribute name="value">
						<xsl:value-of select="MULTI-REQUIRED[@NAME='TITLE']/VALUE-EDITABLE"/>
					</xsl:attribute>
				</input>
				<xsl:call-template name="maxcharacters_textinput_text" />
			</div>	


			<!-- staff articles can have an image-->
			<xsl:if test="$article_subtype = 'staff_article' and $test_IsEditor">
				<div class="frow">
					<div class="labelone"><label for="image">Image</label></div>
					<textarea name="IMAGE" cols="40" rows="3" id="image" class="inputone">
					<xsl:choose>
						<!-- provide example IMAGE code when creating an article - but not on preview or edit -->
						<xsl:when test="/H2G2/MULTI-STAGE/@TYPE='TYPED-ARTICLE-CREATE'">&lt;img src="http://newsimg.bbc.co.uk/media/images/41979000/jpg/example.jpg" width="203" height="152" alt=""/&gt;</xsl:when>
						<!-- if an image has been entered display the code -->
						<xsl:when test="MULTI-ELEMENT[@NAME='IMAGE']/VALUE-EDITABLE/text()">
							<xsl:value-of select="MULTI-ELEMENT[@NAME='IMAGE']/VALUE-EDITABLE"/>
						</xsl:when>
					</xsl:choose>			
					</textarea>
				</div>

        <div class="frow">
          <div class="labelone">
            <label for="EMPURL">Emp URL e.g. http://news.bbc.co.uk/media/emp/8000000/8004500/8004530.xml</label>
          </div>
          <textarea class="inputone" name="EMPURL">
            <xsl:value-of select="MULTI-ELEMENT[@NAME='EMPURL']/VALUE-EDITABLE"/>
          </textarea>
        </div>
        <div class="frow">
          <div class="labelone">
            <label for="YOUTUBEURL">YouTube URL e.g. http://www.youtube.com/v/DNmAlv7pz7o</label>
          </div>
          <textarea class="inputone" name="YOUTUBEURL">
            <xsl:value-of select="MULTI-ELEMENT[@NAME='YOUTUBEURL']/VALUE-EDITABLE"/>
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
					<xsl:when test="($article_subtype = 'staff_article' or $article_subtype = 'info') and $test_IsEditor">
						<div class="labelone"><label for="body">Enter the text of your article here<span class="required">*</span></label></div>
						<textarea name="body" cols="15" rows="10" class="inputone" id="body">
							<xsl:value-of select="MULTI-REQUIRED[@NAME='BODY']/VALUE-EDITABLE"/>
						</textarea>
					</xsl:when>
					<xsl:otherwise>
						<div class="labelone"><label for="maxchars5000">Enter the text of your article here<span class="required">*</span></label>
							<!--[FIXME: remove] -->
						<br/><span class="opt2">(max 5000 characters)</span>
						
						</div>
						<textarea name="body" cols="15" rows="10" class="inputone" id="maxchars5000">
							<xsl:value-of select="MULTI-REQUIRED[@NAME='BODY']/VALUE-EDITABLE"/>
						</textarea>
					</xsl:otherwise>
				</xsl:choose>
			</div>

			<xsl:call-template name="ARTICLE_FORM_TIP"/>
		</td>
		</tr>
		</table>
	</xsl:template>

	<xsl:template name="ARTICLE_FORM_TIP">
		<!--[FIXME: temprorarily remove]
		<div class="articleFormTip">
			<p>
			Tip: If you want to link to a web page, paste in the url and it will appear as a link.
			</p>
			<p>
			More... <a href="{$root}hintsandtips">hints and tips</a>
			</p>
		</div>
		-->
	</xsl:template>
	

	<xsl:template name="MATCH_REPORT_FORM_FIXED_FIELDS">
		<xsl:param name="start_step">2</xsl:param>
		
		<table cellpadding="0" cellspacing="0" border="0">
		<!-- 2 -->
		<tr>
		<td valign="top" width="47" align="center">
			<img height="28" hspace="0" vspace="0" border="0" width="28" alt="{$start_step}" src="{$imagesource}{$start_step}.gif" />
		</td>
		<td>
			<div class="frow">
				<xsl:if test="MULTI-ELEMENT[@NAME='DATEDAY']/ERRORS/ERROR/@TYPE='VALIDATION-ERROR-EMPTY' or MULTI-ELEMENT[@NAME='DATEMONTH']/ERRORS/ERROR/@TYPE='VALIDATION-ERROR-EMPTY' or MULTI-ELEMENT[@NAME='DATEYEAR']/ERRORS/ERROR/@TYPE='VALIDATION-ERROR-EMPTY'">
					<xsl:attribute name="class">frow alert</xsl:attribute>
					<div class="errortext alert"><strong>Please select date</strong></div>
				</xsl:if>
				<div class="labelone"><label for="date">Date of match<span class="required">*</span></label></div>

				<span>
					<xsl:if test="MULTI-ELEMENT[@NAME='DATEDAY']/ERRORS/ERROR/@TYPE='VALIDATION-ERROR-EMPTY'">
						<xsl:attribute name="class">alert</xsl:attribute>
					</xsl:if>
					<select name="DATEDAY" id="dateday">
						<xsl:call-template name="DATEDAY_OPTIONS" />
					</select>
				</span>
				<xsl:text> / </xsl:text>
				<span>
					<xsl:if test="MULTI-ELEMENT[@NAME='DATEMONTH']/ERRORS/ERROR/@TYPE='VALIDATION-ERROR-EMPTY'">
						<xsl:attribute name="class">alert</xsl:attribute>
					</xsl:if>
					<select name="DATEMONTH" id="datemonth">
						<xsl:call-template name="DATEMONTH_OPTIONS" />
					</select>
				</span>
				<xsl:text> / </xsl:text>
				<span>
					<xsl:if test="MULTI-ELEMENT[@NAME='DATEYEAR']/ERRORS/ERROR/@TYPE='VALIDATION-ERROR-EMPTY'">
						<xsl:attribute name="class">alert</xsl:attribute>
					</xsl:if>
					<input type="text" name="DATEYEAR" id="dateyear" style="width:40px;">
						<xsl:attribute name="value">
							<xsl:choose>
								<xsl:when test="MULTI-ELEMENT[@NAME='DATEYEAR']/VALUE-EDITABLE/text()">
									<xsl:value-of select="MULTI-ELEMENT[@NAME='DATEYEAR']/VALUE-EDITABLE"/>
								</xsl:when>
								<xsl:otherwise>
								<xsl:value-of select="/H2G2/DATE/@YEAR"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:attribute>
					</input>
				</span>	
			</div>	
		</td>
		</tr>
		<!-- 3 -->
		<tr>
		<td width="47" valign="top" align="center">
			<img height="28" hspace="0" vspace="0" border="0" width="28" alt="{$start_step + 1}" src="{$imagesource}{$start_step + 1}.gif" />
		</td>
		<td>
			<div class="frow">
				<div class="labelone"><label for="venue">Venue</label></div>
				<input type="text" name="VENUE" id="venue" class="inputone" maxlength="{$maxcharacters_textinput_value}">
					<xsl:attribute name="value">
						<xsl:value-of select="MULTI-ELEMENT[@NAME='VENUE']/VALUE-EDITABLE"/>
					</xsl:attribute>
				</input>
				<xsl:call-template name="maxcharacters_textinput_text" />
			</div>
			
		</td>
		</tr>
		<!-- 4 -->
		<tr>
		<td width="47" valign="top" align="center">
			<img height="28" hspace="0" vspace="0" border="0" width="28" alt="{$start_step + 2}" src="{$imagesource}{$start_step + 2}.gif" />
		</td>
		<td>
		
			<div class="frow">
				<div class="labelone"><label for="player">Your player of the match</label></div>
				<input type="text" name="PLAYEROFTHEMATCH" id="player" class="inputone" maxlength="{$maxcharacters_textinput_value}">
					<xsl:attribute name="value">
						<xsl:value-of select="MULTI-ELEMENT[@NAME='PLAYEROFTHEMATCH']/VALUE-EDITABLE"/>
					</xsl:attribute>
				</input>
				<xsl:call-template name="maxcharacters_textinput_text" />
			</div>

		</td>
		</tr>
		<!-- 5 -->
		<tr>
		<td width="47" valign="top" align="center">
			<img height="28" hspace="0" vspace="0" border="0" width="28" alt="{$start_step + 3}" src="{$imagesource}{$start_step + 3}.gif" />
		</td>
		<td>
			
			<xsl:call-template name="ATTENDANCE" />
					
		</td>
		</tr>
		<!-- 6 -->
		<tr>
		<td width="47" valign="top" align="center">
			<img height="28" hspace="0" vspace="0" border="0" width="28" alt="{$start_step + 4}" src="{$imagesource}{$start_step + 4}.gif" />
		</td>
		<td>
			
			<div class="frow">
				<xsl:if test="MULTI-REQUIRED[@NAME='BODY']/ERRORS/ERROR/@TYPE='VALIDATION-ERROR-EMPTY'">
					<xsl:attribute name="class">frow alert</xsl:attribute>
					<div class="errortext alert"><strong>Please provide text for your match report</strong></div>
				</xsl:if>
				<div class="labelone"><label for="maxchars5000">Enter the text of your report here<span class="required">*</span></label>
				<!--[FIXME: remove]
				<br/><span class="opt2">(max 5000 characters)</span>
				-->
				</div>
				<textarea name="body" cols="15" rows="10" class="inputone" id="maxchars5000">
					<xsl:value-of select="MULTI-REQUIRED[@NAME='BODY']/VALUE-EDITABLE"/>
				</textarea>				
			</div>
			
			<xsl:call-template name="ARTICLE_FORM_TIP"/>
		</td>
		</tr>
		</table>
	</xsl:template>

	<xsl:template name="EVENT_REPORT_FORM_FIXED_FIELDS">
		<xsl:param name="start_step">2</xsl:param>
		
		<table cellpadding="0" cellspacing="0" border="0">
		<!-- 2 -->
		<tr>
		<td width="47" valign="top" align="center">
		<img height="28" hspace="0" vspace="0" border="0" width="28" alt="{$start_step + 4}" src="{$imagesource}{$start_step}.gif" />
		</td>
		<td width="581">
						
			<div class="frow">
					<xsl:if test="MULTI-REQUIRED[@NAME='TITLE']/ERRORS/ERROR/@TYPE='VALIDATION-ERROR-EMPTY'">
						<xsl:attribute name="class">frow alert</xsl:attribute>
						<div class="errortext"><strong>Please enter an event name</strong></div>
					</xsl:if>
					<div class="labelone"><label for="title">Event name<span class="required">*</span></label></div>
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
		<td width="47" valign="top" align="center">
			<img height="28" hspace="0" vspace="0" border="0" width="28" alt="{$start_step + 1}" src="{$imagesource}{$start_step + 1}.gif" />
		</td>
		<td>
		
			<div class="frow">
				<div class="labelone"><label for="venue">Competitors<span class="required">*</span></label></div>
			<table cellpadding="0" cellspacing="0" border="0">
			<tr>
			<td width="260" valign="top">
				<!-- home team -->
				<div id="hometeamwrapper">
					<input type="text" name="COMPETITOR1" id="hometeam" class="inputone" maxlength="{$maxcharacters_textinput_value}">
						<xsl:attribute name="value">
							<xsl:value-of select="MULTI-ELEMENT[@NAME='COMPETITOR1']/VALUE-EDITABLE"/>
						</xsl:attribute>
					</input>
					<xsl:call-template name="maxcharacters_textinput_text2" />
				</div>
			</td>
			<td width="30" valign="top" align="center">
				<div class="head" align="center">v</div>
			</td>
			<td width="260" valign="top" align="right">
			<!-- away team -->
				<div id="awayteamwrapper">
					<input type="text" name="COMPETITOR2" id="hometeam" class="inputone" maxlength="{$maxcharacters_textinput_value}">
						<xsl:attribute name="value">
							<xsl:value-of select="MULTI-ELEMENT[@NAME='COMPETITOR2']/VALUE-EDITABLE"/>
						</xsl:attribute>
					</input>
					<xsl:call-template name="maxcharacters_textinput_text2" />
				</div>	
			</td>				
			</tr>
			</table>
			</div>		
		</td>
		</tr>
		<!-- 4 -->
		<tr>
		<td width="47" valign="top" align="center">
			<img height="28" hspace="0" vspace="0" border="0" width="28" alt="{$start_step + 2}" src="{$imagesource}{$start_step + 2}.gif" />
		</td>
		<td>
			<xsl:call-template name="DATE_REPORT" />
			
		</td>
		</tr>
		<!-- 5 -->
		<tr>
		<td width="47" valign="top" align="center">
			<img height="28" hspace="0" vspace="0" border="0" width="28" alt="{$start_step + 3}" src="{$imagesource}{$start_step + 3}.gif" />
		</td>
		<td>
		
			<div class="frow">
				<div class="labelone"><label for="venue">Venue</label></div>
				<input type="text" name="VENUE" id="venue" class="inputone" maxlength="{$maxcharacters_textinput_value}">
					<xsl:attribute name="value">
						<xsl:value-of select="MULTI-ELEMENT[@NAME='VENUE']/VALUE-EDITABLE"/>
					</xsl:attribute>
				</input>
				<xsl:call-template name="maxcharacters_textinput_text" />
			</div>		
		
		</td>
		</tr>
		<!-- 6 -->
		<tr>
		<td width="47" valign="top" align="center">
			<img height="28" hspace="0" vspace="0" border="0" width="28" alt="{$start_step + 4}" src="{$imagesource}{$start_step + 4}.gif" />
		</td>
		<td>
			<xsl:call-template name="ATTENDANCE" />	
			
		</td>
		</tr>
		
		<!-- 7 -->
		<tr>
		<td width="47" valign="top" align="center">
			<img height="28" hspace="0" vspace="0" border="0" width="28" alt="{$start_step + 5}" src="{$imagesource}{$start_step + 5}.gif" />
		</td>
		<td>
			
			<div class="frow">
				<div class="labelone"><label for="star">Your star of the show</label></div>
				<input type="text" name="STAROFTHESHOW" id="star" class="inputone" maxlength="{$maxcharacters_textinput_value}">
					<xsl:attribute name="value">
						<xsl:value-of select="MULTI-ELEMENT[@NAME='STAROFTHESHOW']/VALUE-EDITABLE"/>
					</xsl:attribute>
				</input>
				<xsl:call-template name="maxcharacters_textinput_text" />
			</div>									
			
		</td>
		</tr>
		<!-- 8 -->
		<tr>
		<td width="47" valign="top" align="center">
			<img height="28" hspace="0" vspace="0" border="0" width="28" alt="{$start_step + 6}" src="{$imagesource}{$start_step + 6}.gif" />
		</td>
		<td>
			
			<div class="frow">
				<xsl:if test="MULTI-REQUIRED[@NAME='BODY']/ERRORS/ERROR/@TYPE='VALIDATION-ERROR-EMPTY'">
					<xsl:attribute name="class">frow alert</xsl:attribute>
					<div class="errortext"><strong>Please enter your report text</strong></div>
				</xsl:if>
				<div class="labelone"><label for="maxchars5000">Enter the text of your report here<span class="required">*</span></label>
				<!--[FIXME: remove]
				<br/><span class="opt2">(max 5000 characters)</span>
				-->
				</div>
				<textarea name="body" cols="15" rows="10" class="inputone" id="maxchars5000">
					<xsl:value-of select="MULTI-REQUIRED[@NAME='BODY']/VALUE-EDITABLE"/>
				</textarea>				
			</div>
			
			<xsl:call-template name="ARTICLE_FORM_TIP"/>
		</td>
		</tr>
		</table>
	</xsl:template>

	<xsl:template name="PLAYER_PROFILE_FORM_FIXED_FIELDS">
		<xsl:param name="start_step">2</xsl:param>
		
		<table cellpadding="0" cellspacing="0" border="0">
		<!-- 2 -->
		<tr>
		<td width="47" valign="top" align="center">
			<img height="28" hspace="0" vspace="0" border="0" width="28" alt="{$start_step}" src="{$imagesource}{$start_step}.gif" />
		</td>
		<td width="381">
						
			<div class="frow">
				<xsl:if test="MULTI-REQUIRED[@NAME='TITLE']/ERRORS/ERROR/@TYPE='VALIDATION-ERROR-EMPTY'">
					<xsl:attribute name="class">frow alert</xsl:attribute>
					<div class="errortext"><strong>Please enter a name</strong></div>
				</xsl:if>
				<div class="labelone"><label for="title">What's the player's name?<span class="required">*</span></label></div>
				<input type="text" name="TITLE" id="title"  class="inputone"  maxlength="{$maxcharacters_textinput_value}">
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
		<td width="47" valign="top" align="center">
			<img height="28" hspace="0" vspace="0" border="0" width="28" alt="{$start_step + 1}" src="{$imagesource}{$start_step + 1}.gif" />
		</td>
		<td>
		
			<div class="frow">
				<div class="labelone"><label for="playerdob">What's the player's date of birth?</label></div>
				<input type="text" name="PLAYERDOB" id="playerdob" class="inputone">
					<xsl:attribute name="value">
						<xsl:value-of select="MULTI-ELEMENT[@NAME='PLAYERDOB']/VALUE-EDITABLE"/>
					</xsl:attribute>
				</input>
				<span class="inputinfo3"> eg: 25/10/1976</span>	
			</div>
			
		</td>
		</tr>
		<!-- 4 -->
		<!--[FIXME: remove]
		<tr>
		<td width="47" valign="top" align="center">
			<img height="28" hspace="0" vspace="0" border="0" width="28" alt="{$start_step + 2}" src="{$imagesource}{$start_step + 2}.gif" />
		</td>
		<td>
		
		<xsl:choose>
			<xsl:when test="$sport = 'Football' or $sport = 'Cricket' or $sport = 'Rugby Union' or $sport = 'Rugby League'">
				
				<div class="frow" id="currentteamwrapper">
					<div class="labelone"><label for="currentteam">What's their current team and/or nationality</label></div>
					<select name="CURRENTTEAM" id="currentteam" class="inputselect">
							<xsl:choose>
								<xsl:when test="$sport='Football'">
									<xsl:call-template name="FOOTBALL_TEAMS_OPTIONS">
										<xsl:with-param name="node"><xsl:value-of select="MULTI-ELEMENT[@NAME='CURRENTTEAM']/VALUE-EDITABLE"/></xsl:with-param>
									</xsl:call-template>
								</xsl:when>
								<xsl:when test="$sport='Cricket'">
									<xsl:call-template name="CRICKET_TEAMS_OPTIONS">
										<xsl:with-param name="node"><xsl:value-of select="MULTI-ELEMENT[@NAME='CURRENTTEAM']/VALUE-EDITABLE"/></xsl:with-param>
									</xsl:call-template>
								</xsl:when>
								<xsl:when test="$sport='Rugby Union'">
									<xsl:call-template name="RUGBY_UNION_TEAMS_OPTIONS">
										<xsl:with-param name="node"><xsl:value-of select="MULTI-ELEMENT[@NAME='CURRENTTEAM']/VALUE-EDITABLE"/></xsl:with-param>
									</xsl:call-template>
								</xsl:when>
								<xsl:when test="$sport='Rugby League'">
									<xsl:call-template name="RUGBY_LEAGUE_TEAMS_OPTIONS">
										<xsl:with-param name="node"><xsl:value-of select="MULTI-ELEMENT[@NAME='CURRENTTEAM']/VALUE-EDITABLE"/></xsl:with-param>
									</xsl:call-template>
								</xsl:when>
							</xsl:choose>
					</select>					
					<div class="inputinfo" id="cantfindcurrentteam"></div>
				</div>
			
				<div class="frow" id="othercurrentteamwrapper">
					<div class="labelone"><label for="othercurrentteam">other<br /></label></div>
					<input type="text" name="OTHERCURRENTTEAM" id="othercurrentteam" class="inputone" maxlength="{$maxcharacters_textinput_value}">
						<xsl:attribute name="value">
							<xsl:value-of select="MULTI-ELEMENT[@NAME='OTHERCURRENTTEAM']/VALUE-EDITABLE"/>
						</xsl:attribute>
					</input>
					<xsl:call-template name="maxcharacters_textinput_text" />
				</div>
			</xsl:when>
			<xsl:otherwise>
				
				<div class="frow" id="currentteamwrapper">
					<div class="labelone"><label for="currentteam">current team and/or nationality</label></div>
					<input type="text" name="OTHERCURRENTTEAM" id="othercurrentteam" class="inputone" maxlength="{$maxcharacters_textinput_value}">
						<xsl:attribute name="value">
							<xsl:value-of select="MULTI-ELEMENT[@NAME='OTHERCURRENTTEAM']/VALUE-EDITABLE"/>
						</xsl:attribute>
					</input>
					<xsl:call-template name="maxcharacters_textinput_text" />
				</div>
			</xsl:otherwise>
		</xsl:choose>
		</td>
		</tr>
		-->
		<!-- 5 -->
		<tr>
		<td width="47" valign="top" align="center">
			<img height="28" hspace="0" vspace="0" border="0" width="28" alt="{$start_step + 2}" src="{$imagesource}{$start_step + 2}.gif" />
		</td>
		<td>
		
			<div class="frow">
				<xsl:if test="MULTI-REQUIRED[@NAME='BODY']/ERRORS/ERROR/@TYPE='VALIDATION-ERROR-EMPTY'">
					<xsl:attribute name="class">frow alert</xsl:attribute>
					<div class="errortext"><strong>Please enter your profile text</strong></div>
				</xsl:if>
				<div class="labelone"><label for="maxchars5000">Enter the text of your profile here<span class="required">*</span></label>
				<!--[FIXME: remove]
				<br/><span class="opt2">(max 5000 characters)</span>
				-->
				</div>
				<textarea name="body" cols="15" rows="10" class="inputone" id="maxchars5000">
					<xsl:value-of select="MULTI-REQUIRED[@NAME='BODY']/VALUE-EDITABLE"/>
				</textarea>				
			</div>
			
			<xsl:call-template name="ARTICLE_FORM_TIP"/>
		</td>
		</tr>
		</table>
	</xsl:template>

	<xsl:template name="TEAM_PROFILE_FORM_FIXED_FIELDS">
		<xsl:param name="start_step">2</xsl:param>
		
		<table cellpadding="0" cellspacing="0" border="0">
		<!-- 2 -->
		<tr>
		<td width="47" valign="top" align="center">
			<img height="28" hspace="0" vspace="0" border="0" width="28" alt="{$start_step + 3}" src="{$imagesource}{$start_step}.gif" />
		</td>
		<td width="381">
			<div class="frow">
				<div class="labelone"><label for="homevenue">What's the home venue?</label></div>
				<input type="text" name="HOMEVENUE" id="homevenue" class="inputone" maxlength="{$maxcharacters_textinput_value}">
					<xsl:attribute name="value">
						<xsl:value-of select="MULTI-ELEMENT[@NAME='HOMEVENUE']/VALUE-EDITABLE"/>
					</xsl:attribute>
				</input>
				<xsl:call-template name="maxcharacters_textinput_text" />
			</div>
			
		</td>
		</tr>
		<!-- 3 -->
		<tr>
		<td width="47" valign="top" align="center">
			<img height="28" hspace="0" vspace="0" border="0" width="28" alt="{$start_step + 1}" src="{$imagesource}{$start_step + 1}.gif" />
		</td>
		<td>
		
			<xsl:variable name="managerlabel">
				<xsl:choose>
					<xsl:when test="$sport='Boxing' or $sport='Horse Racing'">Who's the trainer?</xsl:when>
					<xsl:when test="$sport='Motorsport'">Who's the team boss?</xsl:when>
					<xsl:otherwise>Who's the manager / coach?</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<div class="frow">
				<div class="labelone"><label for="managercoach"><xsl:value-of select="$managerlabel"/></label></div>
				<input type="text" name="MANAGERCOACH" id="managercoach" class="inputone" maxlength="{$maxcharacters_textinput_value}">
					<xsl:attribute name="value">
						<xsl:value-of select="MULTI-ELEMENT[@NAME='MANAGERCOACH']/VALUE-EDITABLE"/>
					</xsl:attribute>
				</input>
				<xsl:call-template name="maxcharacters_textinput_text" />
			</div>
				
		</td>
		</tr>
		<!-- 4 -->
		<tr>
		<td width="47" valign="top" align="center">
			<img height="28" hspace="0" vspace="0" border="0" width="28" alt="{$start_step + 2}" src="{$imagesource}{$start_step + 2}.gif" />
		</td>
		<td>
			<div class="frow">
				<xsl:if test="MULTI-REQUIRED[@NAME='BODY']/ERRORS/ERROR/@TYPE='VALIDATION-ERROR-EMPTY'">
					<xsl:attribute name="class">frow alert</xsl:attribute>
					<div class="errortext"><strong>Please tell us more</strong></div>
				</xsl:if>
				<div class="labelone"><label for="anothermaxchars400">Enter the text of your profile here<span class="required">*</span></label><br /><span class="opt2">(max 400 characters)</span></div>
				<textarea name="BODY" cols="15" rows="10" class="inputone" id="anothermaxchars400">
					<xsl:value-of select="MULTI-REQUIRED[@NAME='BODY']/VALUE-EDITABLE"/>
				</textarea>				
			</div>
			
			<xsl:call-template name="ARTICLE_FORM_TIP"/>
		</td>
		</tr>
		</table>
	</xsl:template>


	<!-- 
	#############################################################
		DATE
	#############################################################
	-->

	<xsl:template name="DATE_REPORT">
		<div class="frow">
			<xsl:if test="MULTI-ELEMENT[@NAME='DATEDAY']/ERRORS/ERROR/@TYPE='VALIDATION-ERROR-EMPTY' or MULTI-ELEMENT[@NAME='DATEMONTH']/ERRORS/ERROR/@TYPE='VALIDATION-ERROR-EMPTY' or MULTI-ELEMENT[@NAME='DATEYEAR']/ERRORS/ERROR/@TYPE='VALIDATION-ERROR-EMPTY'">
				<xsl:attribute name="class">frow alert</xsl:attribute>
			</xsl:if>
			<div class="labelone"><label for="date">Date<span class="required">*</span></label></div>

			<span>
				<xsl:if test="MULTI-ELEMENT[@NAME='DATEDAY']/ERRORS/ERROR/@TYPE='VALIDATION-ERROR-EMPTY'">
					<xsl:attribute name="class">alert</xsl:attribute>
				</xsl:if>
				<select name="DATEDAY" id="dateday">
					<xsl:call-template name="DATEDAY_OPTIONS" />
				</select>
			</span>
			 /
			 <span>
				<xsl:if test="MULTI-ELEMENT[@NAME='DATEMONTH']/ERRORS/ERROR/@TYPE='VALIDATION-ERROR-EMPTY'">
					<xsl:attribute name="class">alert</xsl:attribute>
				</xsl:if>
				<select name="DATEMONTH" id="datemonth">
					<xsl:call-template name="DATEMONTH_OPTIONS" />
				</select>
			</span>
			 / 

			 <span>
				<xsl:if test="MULTI-ELEMENT[@NAME='DATEMONTH']/ERRORS/ERROR/@TYPE='VALIDATION-ERROR-EMPTY'">
					<xsl:attribute name="class">alert</xsl:attribute>
				</xsl:if>
				<input type="text" name="DATEYEAR" id="dateyear" style="width:40px;">
					<xsl:attribute name="value">
						<xsl:choose>
							<xsl:when test="MULTI-ELEMENT[@NAME='DATEYEAR']/VALUE-EDITABLE/text()">
								<xsl:value-of select="MULTI-ELEMENT[@NAME='DATEYEAR']/VALUE-EDITABLE"/>
							</xsl:when>
							<xsl:otherwise>
							<xsl:value-of select="/H2G2/DATE/@YEAR"/>
							</xsl:otherwise>
						</xsl:choose>

					</xsl:attribute>
				</input>
			</span>	
		</div>
	</xsl:template>

	<!-- 
	#############################################################
		ATTENDANCE
	#############################################################
	-->

	<xsl:template name="ATTENDANCE">
		<div class="frow">
			<div class="labelone"><label for="attendance">Attendance</label></div>
			<input type="text" name="ATTENDANCE" id="attendance" class="inputone" maxlength="10">
				<xsl:attribute name="value">
					<xsl:value-of select="MULTI-ELEMENT[@NAME='ATTENDANCE']/VALUE-EDITABLE"/>
				</xsl:attribute>
			</input>
			<div class="inputinfo">10 characters max</div>
		</div>
	</xsl:template>

	<!-- 
	#############################################################
		FOOTBALL
	#############################################################
	-->
	<xsl:template name="FOOTBALL_DROP_DOWNS">
		<xsl:choose>
			<xsl:when test="$article_type_group='article'">
				<div class="formSubRow">
					<xsl:call-template name="FOOTBALL_TEAMS" />
				</div>
				<div class="formSubRow">
					<xsl:call-template name="FOOTBALL_COMPETITIONS" />
				</div>
			</xsl:when>
			<xsl:when test="$article_subtype='player_profile'">
				<div class="formSubRow">
					<xsl:call-template name="FOOTBALL_TEAMS" />
				</div>
				<div class="formSubRow">
					<xsl:call-template name="FOOTBALL_COMPETITIONS" />
				</div>
			</xsl:when>
			<xsl:when test="$article_subtype='team_profile'">
				<div class="formSubRow">
					<xsl:call-template name="FOOTBALL_TEAMS" />
				</div>
				<div class="formSubRow">
					<xsl:call-template name="FOOTBALL_COMPETITIONS" />
				</div>
			</xsl:when>
			<xsl:when test="$article_subtype='match_report'">
				<div class="formSubRow">
					<xsl:call-template name="MATCH_REPORT_TEAMS"/>
				</div>
				<div class="formSubRow">
					<xsl:call-template name="FOOTBALL_COMPETITIONS" />	
				</div>
			</xsl:when>
			<xsl:when test="$article_subtype='event_report'">
				<div class="formSubRow">
					<xsl:call-template name="FOOTBALL_COMPETITIONS" />	
				</div>
			</xsl:when>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="FOOTBALL_TEAMS">
		<div class="frow" id="teamwrapper">
			<xsl:if test="$article_subtype='team_profile' and MULTI-ELEMENT[@NAME='TEAM']/ERRORS/ERROR/@TYPE='VALIDATION-ERROR-EMPTY'">
				<xsl:attribute name="class">frow alert</xsl:attribute>
				<div class="errortext"><strong>Please select a team</strong></div>
			</xsl:if>
			<div class="labelone"><label for="team">Choose a team<span class="required">*</span></label></div>
			<table border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td class="inputHolder">
					<select name="TEAM" id="team" class="inputselect">
						<xsl:call-template name="FOOTBALL_TEAMS_OPTIONS">
							<xsl:with-param name="node"><xsl:value-of select="MULTI-ELEMENT[@NAME='TEAM']/VALUE-EDITABLE"/></xsl:with-param>
						</xsl:call-template>
					</select>
				</td>
				<td class="otherlinkHolder">
					<div class="inputinfo" id="cantfindteam"></div>
				</td>
			</tr>
			</table>
		</div>
		<div class="frow" id="otherteamwrapper">
			<div class="labelone"><label for="otherteam">other</label></div>
			<input type="text" name="OTHERTEAM" id="otherteam" class="inputone">
				<xsl:attribute name="maxlength">
					<xsl:choose>
						<xsl:when test="$test_IsEditor">
							<xsl:value-of select="$maxcharacters_textinput_value"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$maxcharacters_textinput_value_limited"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
				<xsl:attribute name="value">
					<xsl:value-of select="MULTI-ELEMENT[@NAME='OTHERTEAM']/VALUE-EDITABLE"/>
				</xsl:attribute>
			</input>
			<xsl:choose>
				<xsl:when test="$test_IsEditor">
					<xsl:call-template name="maxcharacters_textinput_text" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="maxcharacters_textinput_text_limited" />
				</xsl:otherwise>
			</xsl:choose>
		</div>
		<div class="inputinfo2" id="addanotherteam2"></div>		
		
		<!-- 2 -->
		<!--[FIXME: take out for now]
		<div class="frow" id="team2wrapper">
			<xsl:if test="$article_subtype='team_profile' and MULTI-ELEMENT[@NAME='TEAM2']/ERRORS/ERROR/@TYPE='VALIDATION-ERROR-EMPTY'">
				<xsl:attribute name="class">frow alert</xsl:attribute>
				<div class="errortext"><strong>Please select another team</strong></div>
			</xsl:if>
			<div class="labelone"><label for="team">Choose another team<span class="required">*</span></label></div>
			<table border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td class="inputHolder">
					<select name="TEAM2" id="team2" class="inputselect">
						<xsl:call-template name="FOOTBALL_TEAMS_OPTIONS">
							<xsl:with-param name="node"><xsl:value-of select="MULTI-ELEMENT[@NAME='TEAM2']/VALUE-EDITABLE"/></xsl:with-param>
						</xsl:call-template>
					</select>
				</td>
				<td class="otherlinkHolder">
					<div class="inputinfo" id="cantfindteam2"></div>
				</td>
			</tr>
			</table>
		</div>
		<div class="frow" id="otherteam2wrapper">
			<div class="labelone"><label for="otherteam2">other</label></div>
			<input type="text" name="OTHERTEAM2" id="otherteam2" class="inputone" maxlength="{$maxcharacters_textinput_value}">
				<xsl:attribute name="value">
					<xsl:value-of select="MULTI-ELEMENT[@NAME='OTHERTEAM2']/VALUE-EDITABLE"/>
				</xsl:attribute>
			</input>
			<xsl:call-template name="maxcharacters_textinput_text" />
		</div>
		<div class="inputinfo" id="addanotherteam3"></div>
		-->
	</xsl:template>

	<xsl:template name="FOOTBALL_TEAMS_OPTIONS">
		<xsl:param name="node"/>
		<option value="">select a team</option>
		<xsl:for-each select="msxsl:node-set($competitions)/competition[@sport='Football'][not(@hidefromteam='yes')]//team">
			<xsl:sort select="@fullname"/>
			<option value="{@phrase}">
				<xsl:if test="$node = @phrase">
					<xsl:attribute name="selected">selected</xsl:attribute>
				</xsl:if>
				<xsl:value-of select="@fullname"/>
			</option>
		</xsl:for-each>
		<option value="Otherteam"><xsl:if test="$node = 'Otherteam' or MULTI-ELEMENT[@NAME='OTHERTEAM']/VALUE-EDITABLE/text()"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Other</option>
	</xsl:template>

	<xsl:template name="FOOTBALL_COMPETITIONS">
		<div class="frow" id="competitionwrapper">
			<xsl:if test="$article_type_group='report' and MULTI-ELEMENT[@NAME='COMPETITION']/ERRORS/ERROR/@TYPE='VALIDATION-ERROR-EMPTY'">
				<xsl:attribute name="class">frow alert</xsl:attribute>
				<div class="errortext"><strong>Please select a competition</strong></div>
			</xsl:if>
			<div class="labelone">
				<label for="competition">Choose a competition
					<xsl:if test="$article_type_group='report'">
						<span class="required">*</span>
					</xsl:if>
				</label>
			</div>
			<table border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td class="inputHolder">
					<select name="COMPETITION" id="competition" class="inputselect">
						<xsl:call-template name="FOOTBALL_COMPETITIONS_OPTIONS">
							<xsl:with-param name="node"><xsl:value-of select="MULTI-ELEMENT[@NAME='COMPETITION']/VALUE-EDITABLE"/></xsl:with-param>
						</xsl:call-template>
					</select>
				</td>
				<td class="otherlinkHolder">
					<div class="inputinfo" id="cantfindcompetition"></div>
				</td>
			</tr>
			</table>
		</div>
		<div class="frow" id="othercompetitionwrapper">
			<div class="labelone"><label for="othercompetition">other<br /></label></div>
			<input type="text" name="OTHERCOMPETITION" id="othercompetition" class="inputone">
				<xsl:attribute name="maxlength">
					<xsl:choose>
						<xsl:when test="$test_IsEditor">
							<xsl:value-of select="$maxcharacters_textinput_value"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$maxcharacters_textinput_value_limited"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
				<xsl:attribute name="value">
					<xsl:value-of select="MULTI-ELEMENT[@NAME='OTHERCOMPETITION']/VALUE-EDITABLE"/>
				</xsl:attribute>
			</input>
			<xsl:choose>
				<xsl:when test="$test_IsEditor">
					<xsl:call-template name="maxcharacters_textinput_text" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="maxcharacters_textinput_text_limited" />
				</xsl:otherwise>
			</xsl:choose>
		</div>
	</xsl:template>

	<xsl:template name="FOOTBALL_COMPETITIONS_OPTIONS">
		<xsl:param name="node"/>
		
		<option value="">select a competition</option>
		<xsl:for-each select="msxsl:node-set($competitions)/competition[@sport='Football'][not(@hide = 'yes')]">
			<option value="{@phrase}">
				<xsl:if test="$node = @phrase">
					<xsl:attribute name="selected">selected</xsl:attribute>
				</xsl:if>
				<xsl:value-of select="@name"/>
			</option>
		</xsl:for-each>
		<option value="Othercompetition"><xsl:if test="MULTI-ELEMENT[@NAME='COMPETITION']/VALUE-EDITABLE = 'Othercompetition' or MULTI-ELEMENT[@NAME='OTHERCOMPETITION']/VALUE-EDITABLE/text()"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Other</option>
	</xsl:template>



	<!-- 
	#############################################################
		CRICKET
	#############################################################
	-->

	<xsl:template name="CRICKET_DROP_DOWNS">
		<xsl:choose>
			<xsl:when test="$article_type_group='article'">
				<div class="formSubRow">
					<xsl:call-template name="CRICKET_TEAMS" />
				</div>
				<div class="formSubRow">
					<xsl:call-template name="CRICKET_COMPETITIONS" />
				</div>
			</xsl:when>
			<xsl:when test="$article_subtype='player_profile'">
				<div class="formSubRow">
					<xsl:call-template name="CRICKET_TEAMS" />
				</div>
				<div class="formSubRow">
					<xsl:call-template name="CRICKET_COMPETITIONS" />
				</div>
			</xsl:when>
			<xsl:when test="$article_subtype='team_profile'">
				<div class="formSubRow">
					<xsl:call-template name="CRICKET_TEAMS" />
				</div>
				<div class="formSubRow">
					<xsl:call-template name="CRICKET_COMPETITIONS" />
				</div>
			</xsl:when>
			<xsl:when test="$article_subtype='match_report'">
				<div class="formSubRow">
					<xsl:call-template name="MATCH_REPORT_TEAMS"/>
				</div>
				<div class="formSubRow">
					<xsl:call-template name="CRICKET_COMPETITIONS" />
				</div>
			</xsl:when>
			<xsl:when test="$article_subtype='event_report'">
				<div class="formSubRow">
					<xsl:call-template name="CRICKET_COMPETITIONS" />
				</div>
			</xsl:when>
		</xsl:choose>	
	</xsl:template>

	<xsl:template name="CRICKET_TEAMS">
		<div class="frow" id="teamwrapper">
			<xsl:if test="$article_subtype='team_profile' and MULTI-ELEMENT[@NAME='TEAM']/ERRORS/ERROR/@TYPE='VALIDATION-ERROR-EMPTY'">
				<xsl:attribute name="class">frow alert</xsl:attribute>
				<div class="errortext"><strong>Please select a team</strong></div>
			</xsl:if>
			<div class="labelone"><label for="team">Choose a team<span class="required">*</span></label></div>
			<table border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td class="inputHolder">
					<select name="TEAM" id="team" class="inputselect">
						<xsl:call-template name="CRICKET_TEAMS_OPTIONS">
							<xsl:with-param name="node"><xsl:value-of select="MULTI-ELEMENT[@NAME='TEAM']/VALUE-EDITABLE"/></xsl:with-param>
						</xsl:call-template>
					</select>
				</td>
				<td class="otherlinkHolder">
					<div class="inputinfo" id="cantfindteam"></div>
				</td>
			</tr>
			</table>
		</div>

		<div class="frow" id="otherteamwrapper">
			<div class="labelone"><label for="otherteam">other</label></div>
			<input type="text" name="OTHERTEAM" id="otherteam" class="inputone" maxlength="{$maxcharacters_textinput_value}">
				<xsl:attribute name="value">
					<xsl:value-of select="MULTI-ELEMENT[@NAME='OTHERTEAM']/VALUE-EDITABLE"/>
				</xsl:attribute>
			</input>
			<xsl:call-template name="maxcharacters_textinput_text" />
		</div>
	</xsl:template>

	<xsl:template name="CRICKET_TEAMS_OPTIONS">
		<xsl:param name="node"/>
		<option value="">select a team</option>
		<xsl:for-each select="msxsl:node-set($competitions)/competition[@sport='Cricket'][not(@hidefromteam='yes')]//team">
			<xsl:sort select="@fullname"/>
			<option value="{@phrase}">
				<xsl:if test="$node = @phrase">
					<xsl:attribute name="selected">selected</xsl:attribute>
				</xsl:if>
				<xsl:value-of select="@fullname"/>
			</option>
		</xsl:for-each>
		<option value="Otherteam"><xsl:if test="$node = 'Otherteam' or MULTI-ELEMENT[@NAME='OTHERTEAM']/VALUE-EDITABLE/text()"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Other</option>
	</xsl:template>

	<xsl:template name="CRICKET_COMPETITIONS">
		<div class="frow" id="competitionwrapper">
			<div class="labelone">
				<label for="competition">Choose a competition
					<xsl:if test="$article_type_group='report'">
						<span class="required">*</span>
					</xsl:if>
				</label>
			</div>
			<table border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td class="inputHolder">
					<select name="COMPETITION" id="competition" class="inputselect">
						<xsl:call-template name="CRICKET_COMPETITIONS_OPTIONS">
							<xsl:with-param name="node"><xsl:value-of select="MULTI-ELEMENT[@NAME='COMPETITION']/VALUE-EDITABLE"/></xsl:with-param>
						</xsl:call-template>
					</select>
				</td>
				<td class="otherlinkHolder">
					<div class="inputinfo" id="cantfindcompetition"></div>
				</td>
			</tr>
			</table>
		</div>

		<div class="frow" id="othercompetitionwrapper">
			<div class="labelone"><label for="othercompetition">other<br /></label></div>
			<input type="text" name="OTHERCOMPETITION" id="othercompetition" class="inputone" maxlength="{$maxcharacters_textinput_value}">
				<xsl:attribute name="value">
					<xsl:value-of select="MULTI-ELEMENT[@NAME='OTHERCOMPETITION']/VALUE-EDITABLE"/>
				</xsl:attribute>
			</input>
			<xsl:call-template name="maxcharacters_textinput_text" />
		</div>
	</xsl:template>

	<xsl:template name="CRICKET_COMPETITIONS_OPTIONS">
		<xsl:param name="node"/>
		
		<option value="">select a competition</option>
		<xsl:for-each select="msxsl:node-set($competitions)/competition[@sport='Cricket'][not(@hide = 'yes')]">
			<option value="{@phrase}">
				<xsl:if test="$node = @phrase">
					<xsl:attribute name="selected">selected</xsl:attribute>
				</xsl:if>
				<xsl:value-of select="@name"/>
			</option>
		</xsl:for-each>
		<option value="Othercompetition"><xsl:if test="MULTI-ELEMENT[@NAME='COMPETITION']/VALUE-EDITABLE = 'Othercompetition' or MULTI-ELEMENT[@NAME='OTHERCOMPETITION']/VALUE-EDITABLE/text()"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Other</option>
	</xsl:template>

	<!-- 
	#############################################################
		RUGBY UNION
	#############################################################
	-->
	<xsl:template name="RUGBY_UNION_DROP_DOWNS">
		<xsl:choose>
			<xsl:when test="$article_type_group='article'">
				<div class="formSubRow">
					<xsl:call-template name="RUGBY_UNION_TEAMS" />
				</div>
				<div class="formSubRow">
					<xsl:call-template name="RUGBY_UNION_COMPETITIONS" />
				</div>
			</xsl:when>
			<xsl:when test="$article_subtype='player_profile'">
				<div class="formSubRow">
					<xsl:call-template name="RUGBY_UNION_TEAMS" />
				</div>
				<div class="formSubRow">
					<xsl:call-template name="RUGBY_UNION_COMPETITIONS" />
				</div>
			</xsl:when>
			<xsl:when test="$article_subtype='team_profile'">
				<div class="formSubRow">
					<xsl:call-template name="RUGBY_UNION_TEAMS" />
				</div>
				<div class="formSubRow">
					<xsl:call-template name="RUGBY_UNION_COMPETITIONS" />
				</div>
			</xsl:when>
			<xsl:when test="$article_subtype='match_report'">
				<div class="formSubRow">
					<xsl:call-template name="MATCH_REPORT_TEAMS"/>
				</div>
				<div class="formSubRow">
					<xsl:call-template name="RUGBY_UNION_COMPETITIONS" />
				</div>
			</xsl:when>
			<xsl:when test="$article_subtype='event_report'">
				<div class="formSubRow">
					<xsl:call-template name="RUGBY_UNION_COMPETITIONS" />
				</div>
			</xsl:when>
		</xsl:choose>
	</xsl:template>


	<xsl:template name="RUGBY_UNION_TEAMS">
		<div class="frow" id="teamwrapper">
			<xsl:if test="$article_subtype='team_profile' and MULTI-ELEMENT[@NAME='TEAM']/ERRORS/ERROR/@TYPE='VALIDATION-ERROR-EMPTY'">
				<xsl:attribute name="class">frow alert</xsl:attribute>
				<div class="errortext"><strong>Please select a team</strong></div>
			</xsl:if>
			<div class="labelone"><label for="team">Choose a team<span class="required">*</span></label></div>
			<table border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td class="inputHolder">
					<select name="TEAM" id="team" class="inputselect">
						<xsl:call-template name="RUGBY_UNION_TEAMS_OPTIONS">
							<xsl:with-param name="node"><xsl:value-of select="MULTI-ELEMENT[@NAME='TEAM']/VALUE-EDITABLE"/></xsl:with-param>
						</xsl:call-template>
					</select>
				</td>
				<td class="otherlinkHolder">
					<div class="inputinfo" id="cantfindteam"></div>
				</td>
			</tr>
			</table>
		</div>

		<div class="frow" id="otherteamwrapper">
			<div class="labelone"><label for="otherteam">other</label></div>
			<input type="text" name="OTHERTEAM" id="otherteam" class="inputone" maxlength="{$maxcharacters_textinput_value}">
				<xsl:attribute name="value">
					<xsl:value-of select="MULTI-ELEMENT[@NAME='OTHERTEAM']/VALUE-EDITABLE"/>
				</xsl:attribute>
			</input>
			<xsl:call-template name="maxcharacters_textinput_text" />
		</div>
	</xsl:template>

	<xsl:template name="RUGBY_UNION_TEAMS_OPTIONS">
		<xsl:param name="node"/>
		
		<option value="">select a team</option>
		<xsl:for-each select="msxsl:node-set($competitions)/competition[@sport='Rugby union'][not(@hidefromteam='yes')]//team">
			<xsl:sort select="@fullname"/>
			<option value="{@phrase}">
				<xsl:if test="$node = @phrase">
					<xsl:attribute name="selected">selected</xsl:attribute>
				</xsl:if>
				<xsl:value-of select="@fullname"/>
			</option>
		</xsl:for-each>
		<option value="Otherteam"><xsl:if test="$node = 'Otherteam' or MULTI-ELEMENT[@NAME='OTHERTEAM']/VALUE-EDITABLE/text()"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Other</option>
	</xsl:template>

	<xsl:template name="RUGBY_UNION_COMPETITIONS">
		<div class="frow" id="competitionwrapper">
			<div class="labelone">
				<label for="competition">Choose a competition
					<xsl:if test="$article_type_group='report'">
						<span class="required">*</span>
					</xsl:if>
				</label>
			</div>
			<table border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td class="inputHolder">
					<select name="COMPETITION" id="competition" class="inputselect">
						<xsl:call-template name="RUGBY_UNION_COMPETITIONS_OPTIONS">
							<xsl:with-param name="node"><xsl:value-of select="MULTI-ELEMENT[@NAME='COMPETITION']/VALUE-EDITABLE"/></xsl:with-param>
						</xsl:call-template>
					</select>
				</td>
				<td class="otherlinkHolder">
					<div class="inputinfo" id="cantfindcompetition"></div>
				</td>
			</tr>
			</table>
		</div>

		<div class="frow" id="othercompetitionwrapper">
			<div class="labelone"><label for="othercompetition">other<br /></label></div>
			<input type="text" name="OTHERCOMPETITION" id="othercompetition" class="inputone" maxlength="{$maxcharacters_textinput_value}">
				<xsl:attribute name="value">
					<xsl:value-of select="MULTI-ELEMENT[@NAME='OTHERCOMPETITION']/VALUE-EDITABLE"/>
				</xsl:attribute>
			</input>
			<xsl:call-template name="maxcharacters_textinput_text" />
		</div>
	</xsl:template>

	<xsl:template name="RUGBY_UNION_COMPETITIONS_OPTIONS">
		<xsl:param name="node"/>
		
		<option value="">select a competition</option>
		<xsl:for-each select="msxsl:node-set($competitions)/competition[@sport='Rugby union'][not(@hide = 'yes')]">
			<option value="{@phrase}">
				<xsl:if test="$node = @phrase">
					<xsl:attribute name="selected">selected</xsl:attribute>
				</xsl:if>
				<xsl:value-of select="@name"/>
			</option>
		</xsl:for-each>
		<option value="Othercompetition"><xsl:if test="MULTI-ELEMENT[@NAME='COMPETITION']/VALUE-EDITABLE = 'Othercompetition' or MULTI-ELEMENT[@NAME='OTHERCOMPETITION']/VALUE-EDITABLE/text()"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Other</option>
	</xsl:template>


	<!-- 
	#############################################################
		RUGBY LEAGUE
	#############################################################
	-->
	<xsl:template name="RUGBY_LEAGUE_DROP_DOWNS">
		<xsl:choose>
			<xsl:when test="$article_type_group='article'">
				<div class="formSubRow">
					<xsl:call-template name="RUGBY_LEAGUE_TEAMS" />
				</div>
				<div class="formSubRow">
					<xsl:call-template name="RUGBY_LEAGUE_COMPETITIONS" />
				</div>
			</xsl:when>
			<xsl:when test="$article_subtype='player_profile'">
				<div class="formSubRow">
					<xsl:call-template name="RUGBY_LEAGUE_TEAMS" />
				</div>
				<div class="formSubRow">
					<xsl:call-template name="RUGBY_LEAGUE_COMPETITIONS" />
				</div>
			</xsl:when>
			<xsl:when test="$article_subtype='team_profile'">
				<div class="formSubRow">
					<xsl:call-template name="RUGBY_LEAGUE_TEAMS" />
				</div>
				<div class="formSubRow">
					<xsl:call-template name="RUGBY_LEAGUE_COMPETITIONS" />
				</div>
			</xsl:when>
			<xsl:when test="$article_subtype='match_report'">
				<div class="formSubRow">
					<xsl:call-template name="MATCH_REPORT_TEAMS"/>
				</div>
				<div class="formSubRow">
					<xsl:call-template name="RUGBY_LEAGUE_COMPETITIONS" />
				</div>
			</xsl:when>
			<xsl:when test="$article_subtype='event_report'">
				<div class="formSubRow">
					<xsl:call-template name="RUGBY_LEAGUE_COMPETITIONS" />
				</div>
			</xsl:when>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="RUGBY_LEAGUE_TEAMS">
		<div class="frow" id="teamwrapper">
			<xsl:if test="$article_subtype='team_profile' and MULTI-ELEMENT[@NAME='TEAM']/ERRORS/ERROR/@TYPE='VALIDATION-ERROR-EMPTY'">
				<xsl:attribute name="class">frow alert</xsl:attribute>
				<div class="errortext"><strong>Please select a team</strong></div>
			</xsl:if>
			<div class="labelone"><label for="team">Choose a team<span class="required">*</span></label></div>
			<table border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td class="inputHolder">
					<select name="TEAM" id="team" class="inputselect">
						<xsl:call-template name="RUGBY_LEAGUE_TEAMS_OPTIONS">
							<xsl:with-param name="node"><xsl:value-of select="MULTI-ELEMENT[@NAME='TEAM']/VALUE-EDITABLE"/></xsl:with-param>
						</xsl:call-template>
					</select>
				</td>
				<td class="otherlinkHolder">
					<div class="inputinfo" id="cantfindteam"></div>
				</td>
			</tr>
			</table>
		</div>

		<div class="frow" id="otherteamwrapper">
			<div class="labelone"><label for="otherteam">other</label></div>
			<input type="text" name="OTHERTEAM" id="otherteam" class="inputone" maxlength="{$maxcharacters_textinput_value}">
				<xsl:attribute name="value">
					<xsl:value-of select="MULTI-ELEMENT[@NAME='OTHERTEAM']/VALUE-EDITABLE"/>
				</xsl:attribute>
			</input>
			<xsl:call-template name="maxcharacters_textinput_text" />
		</div>
	</xsl:template>

	<xsl:template name="RUGBY_LEAGUE_TEAMS_OPTIONS">
		<xsl:param name="node"/>
		
		<option value="">select a team</option>
		<xsl:for-each select="msxsl:node-set($competitions)/competition[@sport='Rugby league'][not(@hidefromteam='yes')]//team">
			<xsl:sort select="@fullname"/>
			<option value="{@phrase}">
				<xsl:if test="$node = @phrase">
					<xsl:attribute name="selected">selected</xsl:attribute>
				</xsl:if>
				<xsl:value-of select="@fullname"/>
			</option>
		</xsl:for-each>
		<option value="Otherteam"><xsl:if test="$node = 'Otherteam' or MULTI-ELEMENT[@NAME='OTHERTEAM']/VALUE-EDITABLE/text()"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Other</option>
		<!--
		<option value="">select a team</option>
		<option value="Australia"><xsl:if test="$node = 'Australia'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Australia</option>
		<option value="Barrow  "><xsl:if test="$node = 'Barrow  '"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Barrow  </option>
		<option value="Batley  "><xsl:if test="$node = 'Batley  '"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Batley  </option>
		<option value="Blackpool "><xsl:if test="$node = 'Blackpool '"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Blackpool </option>
		<option value="Bradford"><xsl:if test="$node = 'Bradford'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Bradford</option>
		<option value="Bramley "><xsl:if test="$node = 'Bramley '"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Bramley </option>
		<option value="Brisbane  "><xsl:if test="$node = 'Brisbane  '"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Brisbane  </option>
		<option value="Canberra "><xsl:if test="$node = 'Canberra '"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Canberra </option>
		<option value="Canterbury "><xsl:if test="$node = 'Canterbury '"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Canterbury </option>
		<option value="Castleford "><xsl:if test="$node = 'Castleford '"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Castleford </option>
		<option value="Catalans"><xsl:if test="$node = 'Catalans'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Catalans</option>
		<option value="Celtic Crusaders "><xsl:if test="$node = 'Celtic Crusaders '"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Celtic Crusaders </option>
		<option value="Cook Islands"><xsl:if test="$node = 'Cook Islands'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Cook Islands</option>
		<option value="Cottingham Phoenix "><xsl:if test="$node = 'Cottingham Phoenix '"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Cottingham Phoenix </option>
		<option value="Cronulla "><xsl:if test="$node = 'Cronulla '"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Cronulla </option>
		<option value="Dewsbury "><xsl:if test="$node = 'Dewsbury '"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Dewsbury </option>
		<option value="Dewsbury Celtic "><xsl:if test="$node = 'Dewsbury Celtic '"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Dewsbury Celtic </option>
		<option value="Doncaster "><xsl:if test="$node = 'Doncaster '"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Doncaster </option>
		<option value="East Lancashire Lions "><xsl:if test="$node = 'East Lancashire Lions '"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>East Lancashire Lions </option>
		<option value="England"><xsl:if test="$node = 'England'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>England</option>
		<option value="Featherstone "><xsl:if test="$node = 'Featherstone '"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Featherstone </option>
		<option value="Featherstone Lions "><xsl:if test="$node = 'Featherstone Lions '"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Featherstone Lions </option>
		<option value="Fiji"><xsl:if test="$node = 'Fiji'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Fiji</option>
		<option value="France"><xsl:if test="$node = 'France'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>France</option>
		<option value="Gateshead "><xsl:if test="$node = 'Gateshead '"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Gateshead </option>
		<option value="Gateshead "><xsl:if test="$node = 'Gateshead '"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Gateshead </option>
		<option value="Georgia "><xsl:if test="$node = 'Georgia '"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Georgia </option>
		<option value="Gold Coast "><xsl:if test="$node = 'Gold Coast '"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Gold Coast </option>
		<option value="Great Britain"><xsl:if test="$node = 'Great Britain'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Great Britain</option>
		<option value="Halifax "><xsl:if test="$node = 'Halifax '"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Halifax </option>
		<option value="Harlequins"><xsl:if test="$node = 'Harlequins'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Harlequins</option>
		<option value="Hemel "><xsl:if test="$node = 'Hemel '"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Hemel </option>
		<option value="Huddersfield"><xsl:if test="$node = 'Huddersfield'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Huddersfield</option>
		<option value="Huddersfield Underbank "><xsl:if test="$node = 'Huddersfield Underbank '"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Huddersfield Underbank </option>
		<option value="Hull"><xsl:if test="$node = 'Hull'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Hull</option>
		<option value="Hull KR"><xsl:if test="$node = 'Hull KR'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Hull KR</option>
		<option value="Hunslet "><xsl:if test="$node = 'Hunslet '"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Hunslet </option>
		<option value="Ireland"><xsl:if test="$node = 'Ireland'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Ireland</option>
		<option value="Japan "><xsl:if test="$node = 'Japan '"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Japan </option>
		<option value="Keighley "><xsl:if test="$node = 'Keighley '"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Keighley </option>
		<option value="Lebanon "><xsl:if test="$node = 'Lebanon '"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Lebanon </option>
		<option value="Leeds"><xsl:if test="$node = 'Leeds'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Leeds</option>
		<option value="Leeds Akademiks "><xsl:if test="$node = 'Leeds Akademiks '"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Leeds Akademiks </option>
		<option value="Leigh "><xsl:if test="$node = 'Leigh '"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Leigh </option>
		<option value="London Skolars "><xsl:if test="$node = 'London Skolars '"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>London Skolars </option>
		<option value="Manly "><xsl:if test="$node = 'Manly '"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Manly </option>
		<option value="Melbourne "><xsl:if test="$node = 'Melbourne '"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Melbourne </option>
		<option value="New South Wales"><xsl:if test="$node = 'New South Wales'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>New South Wales</option>
		<option value="New Zealand"><xsl:if test="$node = 'New Zealand'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>New Zealand</option>
		<option value="New Zealand Warriors "><xsl:if test="$node = 'New Zealand Warriors '"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>New Zealand Warriors </option>
		<option value="Newcastle "><xsl:if test="$node = 'Newcastle '"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Newcastle </option>
		<option value="North Queensland "><xsl:if test="$node = 'North Queensland '"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>North Queensland </option>
		<option value="Oldham "><xsl:if test="$node = 'Oldham '"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Oldham </option>
		<option value="Parramatta "><xsl:if test="$node = 'Parramatta '"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Parramatta </option>
		<option value="Penrith "><xsl:if test="$node = 'Penrith '"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Penrith </option>
		<option value="Queensland"><xsl:if test="$node = 'Queensland'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Queensland</option>
		<option value="Rochdale "><xsl:if test="$node = 'Rochdale '"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Rochdale </option>
		<option value="Russia"><xsl:if test="$node = 'Russia'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Russia</option>
		<option value="Russia "><xsl:if test="$node = 'Russia '"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Russia </option>
		<option value="Salford"><xsl:if test="$node = 'Salford'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Salford</option>
		<option value="Samoa "><xsl:if test="$node = 'Samoa '"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Samoa </option>
		<option value="Scotland"><xsl:if test="$node = 'Scotland'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Scotland</option>
		<option value="Sheffield "><xsl:if test="$node = 'Sheffield '"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Sheffield </option>
		<option value="South Sydney "><xsl:if test="$node = 'South Sydney '"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>South Sydney </option>
		<option value="St George/Illawarra "><xsl:if test="$node = 'St George/Illawarra '"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>St George/Illawarra </option>
		<option value="St Helens"><xsl:if test="$node = 'St Helens'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>St Helens</option>
		<option value="Swinton "><xsl:if test="$node = 'Swinton '"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Swinton </option>
		<option value="Sydney "><xsl:if test="$node = 'Sydney '"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Sydney </option>
		<option value="Tonga "><xsl:if test="$node = 'Tonga '"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Tonga </option>
		<option value="United States "><xsl:if test="$node = 'United States '"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>United States </option>
		<option value="Wakefield"><xsl:if test="$node = 'Wakefield'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Wakefield</option>
		<option value="Wales"><xsl:if test="$node = 'Wales'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Wales</option>
		<option value="Warrington"><xsl:if test="$node = 'Warrington'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Warrington</option>
		<option value="Warrington Wizards "><xsl:if test="$node = 'Warrington Wizards '"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Warrington Wizards </option>
		<option value="Wests "><xsl:if test="$node = 'Wests '"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Wests </option>
		<option value="Whitehaven "><xsl:if test="$node = 'Whitehaven '"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Whitehaven </option>
		<option value="Widnes "><xsl:if test="$node = 'Widnes '"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Widnes </option>
		<option value="Wigan"><xsl:if test="$node = 'Wigan'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Wigan</option>
		<option value="Workington "><xsl:if test="$node = 'Workington '"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Workington </option>
		<option value="York "><xsl:if test="$node = 'York '"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>York </option>
		<option value="Otherteam"><xsl:if test="$node = 'Otherteam' or MULTI-ELEMENT[@NAME='OTHERTEAM']/VALUE-EDITABLE/text()"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Other</option>
		-->
	</xsl:template>

	<xsl:template name="RUGBY_LEAGUE_COMPETITIONS">
		<div class="frow" id="competitionwrapper">
			<div class="labelone">
				<label for="competition">Choose a competition
					<xsl:if test="$article_type_group='report'">
						<span class="required">*</span>
					</xsl:if>
				</label>
			</div>
			<table border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td class="inputHolder">
					<select name="COMPETITION" id="competition" class="inputselect">
						<xsl:call-template name="RUGBY_LEAGUE_COMPETITIONS_OPTIONS">
							<xsl:with-param name="node"><xsl:value-of select="MULTI-ELEMENT[@NAME='COMPETITION']/VALUE-EDITABLE"/></xsl:with-param>
						</xsl:call-template>
					</select>
				</td>
				<td class="otherlinkHolder">
					<div class="inputinfo" id="cantfindcompetition"></div>
				</td>
			</tr>
			</table>
		</div>

		<div class="frow" id="othercompetitionwrapper">
			<div class="labelone"><label for="othercompetition">other<br /></label></div>
			<input type="text" name="OTHERCOMPETITION" id="othercompetition" class="inputone" maxlength="{$maxcharacters_textinput_value}">
				<xsl:attribute name="value">
					<xsl:value-of select="MULTI-ELEMENT[@NAME='OTHERCOMPETITION']/VALUE-EDITABLE"/>
				</xsl:attribute>
			</input>
			<xsl:call-template name="maxcharacters_textinput_text" />
		</div>
	</xsl:template>

	<xsl:template name="RUGBY_LEAGUE_COMPETITIONS_OPTIONS">
		<xsl:param name="node"/>
		
		<option value="">select a competition</option>
		<xsl:for-each select="msxsl:node-set($competitions)/competition[@sport='Rugby league'][not(@hide = 'yes')]">
			<option value="{@phrase}">
				<xsl:if test="$node = @phrase">
					<xsl:attribute name="selected">selected</xsl:attribute>
				</xsl:if>
				<xsl:value-of select="@name"/>
			</option>
		</xsl:for-each>
		<option value="Othercompetition"><xsl:if test="MULTI-ELEMENT[@NAME='COMPETITION']/VALUE-EDITABLE = 'Othercompetition' or MULTI-ELEMENT[@NAME='OTHERCOMPETITION']/VALUE-EDITABLE/text()"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Other</option>
	</xsl:template>

	<!-- 
	#############################################################
		TENNIS
	#############################################################
	-->
	<xsl:template name="TENNIS_DROP_DOWNS">
		<xsl:choose>
			<xsl:when test="$article_type_group='article'">
				<div class="formSubRow">
					<xsl:call-template name="TENNIS_COMPETITIONS" />
				</div>
			</xsl:when>
			<xsl:when test="$article_subtype='player_profile'">
				<div class="formSubRow">
					<xsl:call-template name="PLAYER_PROFILE_TEAM_INPUTBOX" />
				</div>
				<div class="formSubRow">
					<xsl:call-template name="TENNIS_COMPETITIONS" />
				</div>
			</xsl:when>
			<xsl:when test="$article_subtype='team_profile'">
				<div class="formSubRow">
					<xsl:call-template name="TEAM_PROFILE_TEAM_INPUTBOX" />
				</div>
				<div class="formSubRow">
					<xsl:call-template name="TENNIS_COMPETITIONS" />
				</div>
			</xsl:when>
			<xsl:when test="$article_subtype='match_report'">
				<div class="formSubRow">
					<xsl:call-template name="MATCH_REPORT_TEAMS"/>
				</div>
				<div class="formSubRow">
					<xsl:call-template name="TENNIS_COMPETITIONS" />
				</div>
			</xsl:when>
			<xsl:when test="$article_subtype='event_report'">
				<div class="formSubRow">
					<xsl:call-template name="TENNIS_COMPETITIONS" />
				</div>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="TENNIS_COMPETITIONS">
		<div class="frow" id="competitionwrapper">
			<div class="labelone"><label for="competition">Choose a competition</label></div>
			<table border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td class="inputHolder">
					<select name="COMPETITION" id="competition" class="inputselect">
						<xsl:call-template name="TENNIS_COMPETITIONS_OPTIONS">
							<xsl:with-param name="node"><xsl:value-of select="MULTI-ELEMENT[@NAME='COMPETITION']/VALUE-EDITABLE"/></xsl:with-param>
						</xsl:call-template>
					</select>
				</td>
				<td class="otherlinkHolder">
					<div class="inputinfo" id="cantfindcompetition"></div>
				</td>
			</tr>
			</table>
		</div>
		<div class="frow" id="othercompetitionwrapper">
			<div class="labelone"><label for="othercompetition">other<br /></label></div>
			<input type="text" name="OTHERCOMPETITION" id="othercompetition" class="inputone" maxlength="{$maxcharacters_textinput_value}">
				<xsl:attribute name="value">
					<xsl:value-of select="MULTI-ELEMENT[@NAME='OTHERCOMPETITION']/VALUE-EDITABLE"/>
				</xsl:attribute>
			</input>
			<xsl:call-template name="maxcharacters_textinput_text" />
		</div>
	</xsl:template>

	<xsl:template name="TENNIS_COMPETITIONS_OPTIONS">
		<xsl:param name="node"/>
		
		<option value="">select a competition</option>
		<xsl:for-each select="msxsl:node-set($competitions)/competition[@sport='Tennis'][not(@hide = 'yes')]">
			<option value="{@phrase}">
				<xsl:if test="$node = @phrase">
					<xsl:attribute name="selected">selected</xsl:attribute>
				</xsl:if>
				<xsl:value-of select="@name"/>
			</option>
		</xsl:for-each>
		<option value="Othertype"><xsl:if test="MULTI-ELEMENT[@NAME='COMPETITION']/VALUE-EDITABLE = 'Othertype' or MULTI-ELEMENT[@NAME='OTHERCOMPETITION']/VALUE-EDITABLE/text()"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Other</option>
		<!--
		<option value="">select a competition</option>
		<option value="Wimbledon"><xsl:if test="MULTI-ELEMENT[@NAME='COMPETITION']/VALUE-EDITABLE = 'Wimbledon'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Wimbledon</option>
		<option value="Australian Open"><xsl:if test="MULTI-ELEMENT[@NAME='COMPETITION']/VALUE-EDITABLE = 'Australian Open'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Australian Open</option>
		<option value="US Open"><xsl:if test="MULTI-ELEMENT[@NAME='COMPETITION']/VALUE-EDITABLE = 'US Open'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>US Open</option>
		<option value="French Open"><xsl:if test="MULTI-ELEMENT[@NAME='COMPETITION']/VALUE-EDITABLE = 'French Open'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>French Open</option>
		<option value="Davis Cup"><xsl:if test="MULTI-ELEMENT[@NAME='COMPETITION']/VALUE-EDITABLE = 'Davis Cup'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Davis Cup</option>
		<option value="Masters Series"><xsl:if test="MULTI-ELEMENT[@NAME='COMPETITION']/VALUE-EDITABLE = 'Masters Series'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Masters Series</option>
		<option value="Fed Cup"><xsl:if test="MULTI-ELEMENT[@NAME='COMPETITION']/VALUE-EDITABLE = 'Fed Cup'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Fed Cup</option>
		<option value="British Tennis"><xsl:if test="MULTI-ELEMENT[@NAME='COMPETITION']/VALUE-EDITABLE = 'British Tennis'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>British Tennis</option>
		<option value="Othertype"><xsl:if test="MULTI-ELEMENT[@NAME='COMPETITION']/VALUE-EDITABLE = 'Othertype'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Other</option>	
		-->
	</xsl:template>
	

	<!-- 
	#############################################################
		GOLF
	#############################################################
	-->
	<xsl:template name="GOLF_DROP_DOWNS">
		<xsl:choose>
			<xsl:when test="$article_type_group='article'">
				<div class="formSubRow">
					<xsl:call-template name="GOLF_COMPETITIONS" />
				</div>
			</xsl:when>
			<xsl:when test="$article_subtype='player_profile'">
				<div class="formSubRow">
					<xsl:call-template name="PLAYER_PROFILE_TEAM_INPUTBOX" />
				</div>
				<div class="formSubRow">
					<xsl:call-template name="GOLF_COMPETITIONS" />
				</div>
			</xsl:when>
			<xsl:when test="$article_subtype='team_profile'">
				<div class="formSubRow">
					<xsl:call-template name="TEAM_PROFILE_TEAM_INPUTBOX" />
				</div>
				<div class="formSubRow">
					<xsl:call-template name="GOLF_COMPETITIONS" />
				</div>
			</xsl:when>
			<xsl:when test="$article_subtype='match_report'">
				<div class="formSubRow">
					<xsl:call-template name="MATCH_REPORT_TEAMS"/>
				</div>
				<div class="formSubRow">
					<xsl:call-template name="GOLF_COMPETITIONS" />
				</div>
			</xsl:when>
			<xsl:when test="$article_subtype='event_report'">
				<div class="formSubRow">
					<xsl:call-template name="GOLF_COMPETITIONS" />
				</div>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="GOLF_COMPETITIONS">
		<div class="frow" id="competitionwrapper">
			<div class="labelone"><label for="competition">Choose a competition</label></div>
			<table border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td class="inputHolder">
					<select name="COMPETITION" id="competition" class="inputselect">
						<xsl:call-template name="GOLF_COMPETITIONS_OPTIONS">
							<xsl:with-param name="node"><xsl:value-of select="MULTI-ELEMENT[@NAME='COMPETITION']/VALUE-EDITABLE"/></xsl:with-param>
						</xsl:call-template>
					</select>
				</td>
				<td class="otherlinkHolder">
					<div class="inputinfo" id="cantfindcompetition"></div>
				</td>
			</tr>
			</table>
		</div>
		<div class="frow" id="othercompetitionwrapper">
			<div class="labelone"><label for="othercompetition">other<br /></label></div>
			<input type="text" name="OTHERCOMPETITION" id="othercompetition" class="inputone" maxlength="{$maxcharacters_textinput_value}">
				<xsl:attribute name="value">
					<xsl:value-of select="MULTI-ELEMENT[@NAME='OTHERCOMPETITION']/VALUE-EDITABLE"/>
				</xsl:attribute>
			</input>
			<xsl:call-template name="maxcharacters_textinput_text" />
		</div>
	</xsl:template>
	
	<xsl:template name="GOLF_COMPETITIONS_OPTIONS">
		<xsl:param name="node"/>
		
		<option value="">select a competition</option>
		<xsl:for-each select="msxsl:node-set($competitions)/competition[@sport='Golf'][not(@hide = 'yes')]">
			<option value="{@phrase}">
				<xsl:if test="$node = @phrase">
					<xsl:attribute name="selected">selected</xsl:attribute>
				</xsl:if>
				<xsl:value-of select="@name"/>
			</option>
		</xsl:for-each>
		<option value="Othertype"><xsl:if test="MULTI-ELEMENT[@NAME='COMPETITION']/VALUE-EDITABLE = 'Othertype' or MULTI-ELEMENT[@NAME='OTHERCOMPETITION']/VALUE-EDITABLE/text()"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Other</option>
		
		<!--
		<option value="Masters"><xsl:if test="MULTI-ELEMENT[@NAME='COMPETITION']/VALUE-EDITABLE = 'Masters'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Masters</option>
		<option value="The Open"><xsl:if test="MULTI-ELEMENT[@NAME='COMPETITION']/VALUE-EDITABLE = 'The Open'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>The Open</option>
		<option value="US Open"><xsl:if test="MULTI-ELEMENT[@NAME='COMPETITION']/VALUE-EDITABLE = 'US Open'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>US Open</option>
		<option value="US PGA"><xsl:if test="MULTI-ELEMENT[@NAME='COMPETITION']/VALUE-EDITABLE = 'US PGA'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>US PGA</option>
		<option value="Ryder Cup"><xsl:if test="MULTI-ELEMENT[@NAME='COMPETITION']/VALUE-EDITABLE = 'Ryder Cup'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Ryder Cup</option>
		<option value="PGA Tour"><xsl:if test="MULTI-ELEMENT[@NAME='COMPETITION']/VALUE-EDITABLE = 'PGA Tour'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>PGA Tour</option>
		<option value="European Tour"><xsl:if test="MULTI-ELEMENT[@NAME='COMPETITION']/VALUE-EDITABLE = 'European Tour'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>European Tour</option>
		<option value="LPGA Tour"><xsl:if test="MULTI-ELEMENT[@NAME='COMPETITION']/VALUE-EDITABLE = 'LPGA Tour'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>LPGA Tour</option>
		<option value="Solheim Cup"><xsl:if test="MULTI-ELEMENT[@NAME='COMPETITION']/VALUE-EDITABLE = 'Solheim Cup'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Solheim Cup</option>
		-->
	</xsl:template>

	<!-- 
	#############################################################
		MOTORSPORT
	#############################################################
	-->
	<xsl:template name="MOTORSPORT_DROP_DOWNS">
		<xsl:choose>
			<xsl:when test="$article_type_group='article'">
				<div class="formSubRow">
					<xsl:call-template name="MOTORSPORT_COMPETITIONS" />
				</div>
			</xsl:when>
			<xsl:when test="$article_subtype='player_profile'">
				<div class="formSubRow">
					<xsl:call-template name="PLAYER_PROFILE_TEAM_INPUTBOX" />
				</div>
				<div class="formSubRow">
					<xsl:call-template name="MOTORSPORT_COMPETITIONS" />
				</div>
			</xsl:when>
			<xsl:when test="$article_subtype='team_profile'">
				<div class="formSubRow">
					<xsl:call-template name="TEAM_PROFILE_TEAM_INPUTBOX" />
				</div>
				<div class="formSubRow">
					<xsl:call-template name="MOTORSPORT_COMPETITIONS" />
				</div>
			</xsl:when>
			<xsl:when test="$article_subtype='match_report'">
				<div class="formSubRow">
					<xsl:call-template name="MATCH_REPORT_TEAMS"/>
				</div>
				<div class="formSubRow">
					<xsl:call-template name="MOTORSPORT_COMPETITIONS" />
				</div>
			</xsl:when>
			<xsl:when test="$article_subtype='event_report'">
				<div class="formSubRow">
					<xsl:call-template name="MOTORSPORT_COMPETITIONS" />
				</div>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="MOTORSPORT_COMPETITIONS">
		<div class="frow" id="typekwrapper">
			<div class="labelone"><label for="typek">Choose a type</label></div>
			<table border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td class="inputHolder">
					<select name="COMPETITION" id="typek" class="inputselect">
						<xsl:call-template name="MOTORSPORT_COMPETITIONS_OPTIONS">
							<xsl:with-param name="node"><xsl:value-of select="MULTI-ELEMENT[@NAME='COMPETITION']/VALUE-EDITABLE"/></xsl:with-param>
						</xsl:call-template>
					</select>
				</td>
				<td class="otherlinkHolder">
					<div class="inputinfo" id="cantfindtypek"></div>
				</td>
			</tr>
			</table>
		</div>

		<div class="frow" id="othertypekwrapper">
			<div class="labelone"><label for="othertypek">other<br /></label></div>
			<input type="text" name="OTHERCOMPETITION" id="othertypek" class="inputone" maxlength="{$maxcharacters_textinput_value}">
				<xsl:attribute name="value">
					<xsl:value-of select="MULTI-ELEMENT[@NAME='OTHERCOMPETITION']/VALUE-EDITABLE"/>
				</xsl:attribute>
			</input>
			<xsl:call-template name="maxcharacters_textinput_text" />
		</div>
	</xsl:template>
	
	<xsl:template name="MOTORSPORT_COMPETITIONS_OPTIONS">
		<xsl:param name="node"/>
		
		<option value="">select a competition</option>
		<xsl:for-each select="msxsl:node-set($competitions)/competition[@sport='Motorsport'][not(@hide = 'yes')]">
			<option value="{@phrase}">
				<xsl:if test="$node = @phrase">
					<xsl:attribute name="selected">selected</xsl:attribute>
				</xsl:if>
				<xsl:value-of select="@name"/>
			</option>
		</xsl:for-each>
		<option value="Othertype"><xsl:if test="MULTI-ELEMENT[@NAME='COMPETITION']/VALUE-EDITABLE = 'Othertype' or MULTI-ELEMENT[@NAME='OTHERCOMPETITION']/VALUE-EDITABLE/text()"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Other</option>
	
		<!--
		<option value="Formula One"><xsl:if test="MULTI-ELEMENT[@NAME='COMPETITION']/VALUE-EDITABLE = 'Formula One'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Formula One</option>
		<option value="Rallying"><xsl:if test="MULTI-ELEMENT[@NAME='COMPETITION']/VALUE-EDITABLE = 'Rallying'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Rallying</option>
		<option value="Motorbikes"><xsl:if test="MULTI-ELEMENT[@NAME='COMPETITION']/VALUE-EDITABLE = 'Motorbikes'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Motorbikes</option>
		<option value="Moto GP"><xsl:if test="MULTI-ELEMENT[@NAME='COMPETITION']/VALUE-EDITABLE = 'Moto GP'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Moto GP</option>
		<option value="Superbikes"><xsl:if test="MULTI-ELEMENT[@NAME='COMPETITION']/VALUE-EDITABLE = 'Superbikes'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Superbikes</option>
		<option value="World Rally Championship"><xsl:if test="MULTI-ELEMENT[@NAME='COMPETITION']/VALUE-EDITABLE = 'World Rally Championship'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>World Rally Championship</option>
		<option value="British Rally Championship"><xsl:if test="MULTI-ELEMENT[@NAME='COMPETITION']/VALUE-EDITABLE = 'British Rally Championship'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>British Rally Championship</option>
		<option value="A1GP"><xsl:if test="MULTI-ELEMENT[@NAME='COMPETITION']/VALUE-EDITABLE = 'A1GP'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>A1GP</option>
		<option value="Speedway"><xsl:if test="MULTI-ELEMENT[@NAME='COMPETITION']/VALUE-EDITABLE = 'Speedway'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Speedway</option>
		-->
	</xsl:template>


	<!-- 
	#############################################################
		BOXING
	#############################################################
	-->
	<xsl:template name="BOXING_DROP_DOWNS">
		<xsl:choose>
			<xsl:when test="$article_type_group='article'">
				<div class="formSubRow">
					<xsl:call-template name="BOXING_COMPETITIONS" />
				</div>
			</xsl:when>
			<xsl:when test="$article_subtype='player_profile'">
				<div class="formSubRow">
					<xsl:call-template name="PLAYER_PROFILE_TEAM_INPUTBOX" />
				</div>
				<div class="formSubRow">
					<xsl:call-template name="BOXING_COMPETITIONS" />
				</div>
			</xsl:when>
			<xsl:when test="$article_subtype='team_profile'">
				<div class="formSubRow">
					<xsl:call-template name="TEAM_PROFILE_TEAM_INPUTBOX" />
				</div>
				<div class="formSubRow">
					<xsl:call-template name="BOXING_COMPETITIONS" />
				</div>
			</xsl:when>
			<xsl:when test="$article_subtype='match_report'">
				<div class="formSubRow">
					<xsl:call-template name="MATCH_REPORT_TEAMS"/>
				</div>
				<div class="formSubRow">
					<xsl:call-template name="BOXING_COMPETITIONS" />
				</div>
			</xsl:when>
			<xsl:when test="$article_subtype='event_report'">
				<div class="formSubRow">
					<xsl:call-template name="BOXING_COMPETITIONS" />
				</div>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="BOXING_COMPETITIONS">
		<div class="frow" id="competitionwrapper">
			<div class="labelone"><label for="competition">Choose a competition</label></div>
			<table border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td class="inputHolder">
					<select name="COMPETITION" id="competition" class="inputselect">
						<xsl:call-template name="BOXING_COMPETITIONS_OPTIONS">
							<xsl:with-param name="node"><xsl:value-of select="MULTI-ELEMENT[@NAME='COMPETITION']/VALUE-EDITABLE"/></xsl:with-param>
						</xsl:call-template>
					</select>
				</td>
				<td class="otherlinkHolder">
					<div class="inputinfo" id="cantfindcompetition"></div>
				</td>
			</tr>
			</table>
		</div>
		<div class="frow" id="othercompetitionwrapper">
			<div class="labelone"><label for="othercompetition">other<br /></label></div>
			<input type="text" name="OTHERCOMPETITION" id="othercompetition" class="inputone" maxlength="{$maxcharacters_textinput_value}">
				<xsl:attribute name="value">
					<xsl:value-of select="MULTI-ELEMENT[@NAME='OTHERCOMPETITION']/VALUE-EDITABLE"/>
				</xsl:attribute>
			</input>
			<xsl:call-template name="maxcharacters_textinput_text" />
		</div>
	</xsl:template>
	
	<xsl:template name="BOXING_COMPETITIONS_OPTIONS">
		<xsl:param name="node"/>
		
		<option value="">select a competition</option>
		<xsl:for-each select="msxsl:node-set($competitions)/competition[@sport='Boxing'][not(@hide = 'yes')]">
			<option value="{@phrase}">
				<xsl:if test="$node = @phrase">
					<xsl:attribute name="selected">selected</xsl:attribute>
				</xsl:if>
				<xsl:value-of select="@name"/>
			</option>
		</xsl:for-each>
		<option value="Othertype"><xsl:if test="MULTI-ELEMENT[@NAME='COMPETITION']/VALUE-EDITABLE = 'Othertype' or MULTI-ELEMENT[@NAME='OTHERCOMPETITION']/VALUE-EDITABLE/text()"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Other</option>
	
		<!--
		<option value="Heavy"><xsl:if test="MULTI-ELEMENT[@NAME='COMPETITION']/VALUE-EDITABLE = 'Heavy'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Heavy</option>
		<option value="Cruiser"><xsl:if test="MULTI-ELEMENT[@NAME='COMPETITION']/VALUE-EDITABLE = 'Cruiser'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Cruiser</option>
		<option value="Light heavy"><xsl:if test="MULTI-ELEMENT[@NAME='COMPETITION']/VALUE-EDITABLE = 'Light heavy'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Light heavy</option>
		<option value="Super middle"><xsl:if test="MULTI-ELEMENT[@NAME='COMPETITION']/VALUE-EDITABLE = 'Super middle'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Super middle</option>
		<option value="Middle"><xsl:if test="MULTI-ELEMENT[@NAME='COMPETITION']/VALUE-EDITABLE = 'Middle'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Middle</option>
		<option value="Light middle"><xsl:if test="MULTI-ELEMENT[@NAME='COMPETITION']/VALUE-EDITABLE = 'Light middle'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Light middle</option>
		<option value="Welter"><xsl:if test="MULTI-ELEMENT[@NAME='COMPETITION']/VALUE-EDITABLE = 'Welter'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Welter</option>
		<option value="Light welter"><xsl:if test="MULTI-ELEMENT[@NAME='COMPETITION']/VALUE-EDITABLE = 'Light welter'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Light welter</option>
		<option value="Light"><xsl:if test="MULTI-ELEMENT[@NAME='COMPETITION']/VALUE-EDITABLE = 'Light'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Light</option>
		<option value="Super feather"><xsl:if test="MULTI-ELEMENT[@NAME='COMPETITION']/VALUE-EDITABLE = 'Super feather'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Super feather</option>
		<option value="Feather"><xsl:if test="MULTI-ELEMENT[@NAME='COMPETITION']/VALUE-EDITABLE = 'Feather'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Feather</option>
		<option value="Super bantam"><xsl:if test="MULTI-ELEMENT[@NAME='COMPETITION']/VALUE-EDITABLE = 'Super bantam'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Super bantam</option>
		<option value="Bantam"><xsl:if test="MULTI-ELEMENT[@NAME='COMPETITION']/VALUE-EDITABLE = 'Bantam'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Bantam</option>
		<option value="Super fly"><xsl:if test="MULTI-ELEMENT[@NAME='COMPETITION']/VALUE-EDITABLE = 'Super fly'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Super fly</option>
		<option value="Fly"><xsl:if test="MULTI-ELEMENT[@NAME='COMPETITION']/VALUE-EDITABLE = 'Fly'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Fly</option>
		<option value="Light fly"><xsl:if test="MULTI-ELEMENT[@NAME='COMPETITION']/VALUE-EDITABLE = 'Light fly'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Light fly</option>
		<option value="Straw"><xsl:if test="MULTI-ELEMENT[@NAME='COMPETITION']/VALUE-EDITABLE = 'Straw'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Straw</option>
		<option value="Amateur"><xsl:if test="MULTI-ELEMENT[@NAME='COMPETITION']/VALUE-EDITABLE = 'Amateur'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Amateur</option>
		<option value="Olympics"><xsl:if test="MULTI-ELEMENT[@NAME='COMPETITION']/VALUE-EDITABLE = 'Olympics'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Olympics</option>
		<option value="Legends"><xsl:if test="MULTI-ELEMENT[@NAME='COMPETITION']/VALUE-EDITABLE = 'Legends'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Legends</option>
		<option value="Pound for pound"><xsl:if test="MULTI-ELEMENT[@NAME='COMPETITION']/VALUE-EDITABLE = 'Pound for pound'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Pound for pound</option>
		-->
	</xsl:template>


	<!-- 
	#############################################################
		ATHLETICS
	#############################################################
	-->
	<xsl:template name="ATHLETICS_DROP_DOWNS">
		<xsl:choose>
			<xsl:when test="$article_type_group='article'">
				<div class="formSubRow">
					<xsl:call-template name="ATHLETICS_COMPETITIONS" />
				</div>
			</xsl:when>
			<xsl:when test="$article_subtype='player_profile'">
				<div class="formSubRow">
					<xsl:call-template name="PLAYER_PROFILE_TEAM_INPUTBOX" />
				</div>
				<div class="formSubRow">
					<xsl:call-template name="ATHLETICS_COMPETITIONS" />
				</div>
			</xsl:when>
			<xsl:when test="$article_subtype='team_profile'">
				<div class="formSubRow">
					<xsl:call-template name="TEAM_PROFILE_TEAM_INPUTBOX" />
				</div>
				<div class="formSubRow">
					<xsl:call-template name="ATHLETICS_COMPETITIONS" />
				</div>
			</xsl:when>
			<xsl:when test="$article_subtype='match_report'">
				<div class="formSubRow">
					<xsl:call-template name="MATCH_REPORT_TEAMS"/>
				</div>
				<div class="formSubRow">
					<xsl:call-template name="ATHLETICS_COMPETITIONS" />
				</div>
			</xsl:when>
			<xsl:when test="$article_subtype='event_report'">
				<div class="formSubRow">
					<xsl:call-template name="ATHLETICS_COMPETITIONS" />
				</div>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="ATHLETICS_COMPETITIONS">
		<div class="frow" id="competitionwrapper">
			<div class="labelone"><label for="competition">Choose a competition</label></div>
			<table border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td class="inputHolder">
					<select name="COMPETITION" id="competition" class="inputselect">
						<xsl:call-template name="ATHLETICS_COMPETITIONS_OPTIONS">
							<xsl:with-param name="node"><xsl:value-of select="MULTI-ELEMENT[@NAME='COMPETITION']/VALUE-EDITABLE"/></xsl:with-param>
						</xsl:call-template>
					</select>
				</td>
				<td class="otherlinkHolder">
					<div class="inputinfo" id="cantfindcompetition"></div>
				</td>
			</tr>
			</table>
		</div>
		<div class="frow" id="othercompetitionwrapper">
			<div class="labelone"><label for="othercompetition">other<br /></label></div>
			<input type="text" name="OTHERCOMPETITION" id="othercompetition" class="inputone" maxlength="{$maxcharacters_textinput_value}">
				<xsl:attribute name="value">
					<xsl:value-of select="MULTI-ELEMENT[@NAME='OTHERCOMPETITION']/VALUE-EDITABLE"/>
				</xsl:attribute>
			</input>
			<xsl:call-template name="maxcharacters_textinput_text" />
		</div>
	</xsl:template>
	
	<xsl:template name="ATHLETICS_COMPETITIONS_OPTIONS">
		<xsl:param name="node"/>
		
		<option value="">select a competition</option>
		<xsl:for-each select="msxsl:node-set($competitions)/competition[@sport='Athletics'][not(@hide = 'yes')]">
			<option value="{@phrase}">
				<xsl:if test="$node = @phrase">
					<xsl:attribute name="selected">selected</xsl:attribute>
				</xsl:if>
				<xsl:value-of select="@name"/>
			</option>
		</xsl:for-each>
		<option value="Othertype"><xsl:if test="MULTI-ELEMENT[@NAME='COMPETITION']/VALUE-EDITABLE = 'Othertype' or MULTI-ELEMENT[@NAME='OTHERCOMPETITION']/VALUE-EDITABLE/text()"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Other</option>

		<!--
		<option value="British athletics"><xsl:if test="MULTI-ELEMENT[@NAME='COMPETITION']/VALUE-EDITABLE = 'British athletics'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>British athletics</option>
		<option value="International athletics"><xsl:if test="MULTI-ELEMENT[@NAME='COMPETITION']/VALUE-EDITABLE = 'International athletics'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>International athletics</option>
		<option value="Olympics"><xsl:if test="MULTI-ELEMENT[@NAME='COMPETITION']/VALUE-EDITABLE = 'Olympics'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Olympics</option>
		<option value="London Marathon"><xsl:if test="MULTI-ELEMENT[@NAME='COMPETITION']/VALUE-EDITABLE = 'London Marathon'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>London Marathon</option>
		-->
	</xsl:template>


	<!-- 
	#############################################################
		SNOOKER
	#############################################################
	-->
	<xsl:template name="SNOOKER_DROP_DOWNS">
		<xsl:choose>
			<xsl:when test="$article_type_group='article'">
				<div class="formSubRow">
					<xsl:call-template name="SNOOKER_COMPETITIONS" />
				</div>
			</xsl:when>
			<xsl:when test="$article_subtype='player_profile'">
				<div class="formSubRow">
					<xsl:call-template name="PLAYER_PROFILE_TEAM_INPUTBOX" />
				</div>
				<div class="formSubRow">
					<xsl:call-template name="SNOOKER_COMPETITIONS" />
				</div>
			</xsl:when>
			<xsl:when test="$article_subtype='team_profile'">
				<div class="formSubRow">
					<xsl:call-template name="TEAM_PROFILE_TEAM_INPUTBOX" />
				</div>
				<div class="formSubRow">
					<xsl:call-template name="SNOOKER_COMPETITIONS" />
				</div>
			</xsl:when>
			<xsl:when test="$article_subtype='match_report'">
				<div class="formSubRow">
					<xsl:call-template name="MATCH_REPORT_TEAMS"/>
				</div>
				<div class="formSubRow">
					<xsl:call-template name="SNOOKER_COMPETITIONS" />
				</div>
			</xsl:when>
			<xsl:when test="$article_subtype='event_report'">
				<div class="formSubRow">
					<xsl:call-template name="SNOOKER_COMPETITIONS" />
				</div>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="SNOOKER_COMPETITIONS">
		<div class="frow" id="competitionwrapper">
			<div class="labelone"><label for="competition">Choose a competition</label></div>
			<table border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td class="inputHolder">
					<select name="COMPETITION" id="competition" class="inputselect">
						<xsl:call-template name="SNOOKER_COMPETITIONS_OPTIONS">
							<xsl:with-param name="node"><xsl:value-of select="MULTI-ELEMENT[@NAME='COMPETITION']/VALUE-EDITABLE"/></xsl:with-param>
						</xsl:call-template>
					</select>
				</td>
				<td class="otherlinkHolder">
					<div class="inputinfo" id="cantfindcompetition"></div>
				</td>
			</tr>
			</table>
		</div>
		<div class="frow" id="othercompetitionwrapper">
			<div class="labelone"><label for="othercompetition">other<br /></label></div>
			<input type="text" name="OTHERCOMPETITION" id="othercompetition" class="inputone" maxlength="{$maxcharacters_textinput_value}">
				<xsl:attribute name="value">
					<xsl:value-of select="MULTI-ELEMENT[@NAME='OTHERCOMPETITION']/VALUE-EDITABLE"/>
				</xsl:attribute>
			</input>
			<xsl:call-template name="maxcharacters_textinput_text" />
		</div>
	</xsl:template>
	
	<xsl:template name="SNOOKER_COMPETITIONS_OPTIONS">
		<xsl:param name="node"/>
		
		<option value="">select a competition</option>
		<xsl:for-each select="msxsl:node-set($competitions)/competition[@sport='Snooker'][not(@hide = 'yes')]">
			<option value="{@phrase}">
				<xsl:if test="$node = @phrase">
					<xsl:attribute name="selected">selected</xsl:attribute>
				</xsl:if>
				<xsl:value-of select="@name"/>
			</option>
		</xsl:for-each>
		<option value="Othertype"><xsl:if test="MULTI-ELEMENT[@NAME='COMPETITION']/VALUE-EDITABLE = 'Othertype' or MULTI-ELEMENT[@NAME='OTHERCOMPETITION']/VALUE-EDITABLE/text()"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Other</option>

		<!--
		<option value="Grand Prix"><xsl:if test="MULTI-ELEMENT[@NAME='COMPETITION']/VALUE-EDITABLE = 'Grand Prix'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Grand Prix</option>
		<option value="Masters"><xsl:if test="MULTI-ELEMENT[@NAME='COMPETITION']/VALUE-EDITABLE = 'Masters'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Masters</option>
		<option value="UK Championship"><xsl:if test="MULTI-ELEMENT[@NAME='COMPETITION']/VALUE-EDITABLE = 'UK Championship'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>UK Championship</option>
		<option value="World Championship"><xsl:if test="MULTI-ELEMENT[@NAME='COMPETITION']/VALUE-EDITABLE = 'World Championship'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>World Championship</option>
		-->
	</xsl:template>


	<!-- 
	#############################################################
		HORSE RACING
	#############################################################
	-->
	<xsl:template name="HORSE_RACING_DROP_DOWNS">
		<xsl:choose>
			<xsl:when test="$article_type_group='article'">
				<div class="formSubRow">
					<xsl:call-template name="HORSE_RACING_COMPETITIONS" />
				</div>
			</xsl:when>
			<xsl:when test="$article_subtype='player_profile'">
				<div class="formSubRow">
					<xsl:call-template name="PLAYER_PROFILE_TEAM_INPUTBOX" />
				</div>
				<div class="formSubRow">
					<xsl:call-template name="HORSE_RACING_COMPETITIONS" />
				</div>
			</xsl:when>
			<xsl:when test="$article_subtype='team_profile'">
				<div class="formSubRow">
					<xsl:call-template name="TEAM_PROFILE_TEAM_INPUTBOX" />
				</div>
				<div class="formSubRow">
					<xsl:call-template name="HORSE_RACING_COMPETITIONS" />
				</div>
			</xsl:when>
			<xsl:when test="$article_subtype='match_report'">
				<div class="formSubRow">
					<xsl:call-template name="MATCH_REPORT_TEAMS"/>
				</div>
				<div class="formSubRow">
					<xsl:call-template name="HORSE_RACING_COMPETITIONS" />
				</div>
			</xsl:when>
			<xsl:when test="$article_subtype='event_report'">
				<div class="formSubRow">
					<xsl:call-template name="HORSE_RACING_COMPETITIONS" />
				</div>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="HORSE_RACING_COMPETITIONS">
		<div class="frow" id="competitionwrapper">
			<div class="labelone"><label for="competition">Choose a competition</label></div>
			<table border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td class="inputHolder">
					<select name="COMPETITION" id="competition" class="inputselect">
						<xsl:call-template name="HORSE_RACING_COMPETITIONS_OPTIONS">
							<xsl:with-param name="node"><xsl:value-of select="MULTI-ELEMENT[@NAME='COMPETITION']/VALUE-EDITABLE"/></xsl:with-param>
						</xsl:call-template>
					</select>
				</td>
				<td class="otherlinkHolder">
					<div class="inputinfo" id="cantfindcompetition"></div>
				</td>
			</tr>
			</table>
		</div>
		<div class="frow" id="othercompetitionwrapper">
			<div class="labelone"><label for="othercompetition">other<br /></label></div>
			<input type="text" name="OTHERCOMPETITION" id="othercompetition" class="inputone" maxlength="{$maxcharacters_textinput_value}">
				<xsl:attribute name="value">
					<xsl:value-of select="MULTI-ELEMENT[@NAME='OTHERCOMPETITION']/VALUE-EDITABLE"/>
				</xsl:attribute>
			</input>
			<xsl:call-template name="maxcharacters_textinput_text" />
		</div>
	</xsl:template>
	
	<xsl:template name="HORSE_RACING_COMPETITIONS_OPTIONS">
		<xsl:param name="node"/>
		
		<option value="">select a competition</option>
		<xsl:for-each select="msxsl:node-set($competitions)/competition[@sport='Horse racing'][not(@hide = 'yes')]">
			<option value="{@phrase}">
				<xsl:if test="$node = @phrase">
					<xsl:attribute name="selected">selected</xsl:attribute>
				</xsl:if>
				<xsl:value-of select="@name"/>
			</option>
		</xsl:for-each>
		<option value="Othertype"><xsl:if test="MULTI-ELEMENT[@NAME='COMPETITION']/VALUE-EDITABLE = 'Othertype' or MULTI-ELEMENT[@NAME='OTHERCOMPETITION']/VALUE-EDITABLE/text()"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Other</option>
	
		<!--
		<option value="National Hunt"><xsl:if test="MULTI-ELEMENT[@NAME='COMPETITION']/VALUE-EDITABLE = 'National Hunt'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>National Hunt</option>
		<option value="Flat racing"><xsl:if test="MULTI-ELEMENT[@NAME='COMPETITION']/VALUE-EDITABLE = 'Flat racing'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Flat racing</option>
		<option value="Grand national"><xsl:if test="MULTI-ELEMENT[@NAME='COMPETITION']/VALUE-EDITABLE = 'Grand national'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Grand national</option>
		<option value="Derby"><xsl:if test="MULTI-ELEMENT[@NAME='COMPETITION']/VALUE-EDITABLE = 'Derby'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Derby</option>
		<option value="Royal Ascot"><xsl:if test="MULTI-ELEMENT[@NAME='COMPETITION']/VALUE-EDITABLE = 'Royal Ascot'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Royal Ascot</option>
		-->
	</xsl:template>


	<!-- 
	#############################################################
		CYCLING
	#############################################################
	-->
	<xsl:template name="CYCLING_DROP_DOWNS">
		<xsl:choose>
			<xsl:when test="$article_type_group='article'">
				<div class="formSubRow">
					<xsl:call-template name="CYCLING_COMPETITIONS" />
				</div>
			</xsl:when>
			<xsl:when test="$article_subtype='player_profile'">
				<div class="formSubRow">
					<xsl:call-template name="PLAYER_PROFILE_TEAM_INPUTBOX" />
				</div>
				<div class="formSubRow">
					<xsl:call-template name="CYCLING_COMPETITIONS" />
				</div>
			</xsl:when>
			<xsl:when test="$article_subtype='team_profile'">
				<div class="formSubRow">
					<xsl:call-template name="TEAM_PROFILE_TEAM_INPUTBOX" />
				</div>
				<div class="formSubRow">
					<xsl:call-template name="CYCLING_COMPETITIONS" />
				</div>
			</xsl:when>
			<xsl:when test="$article_subtype='match_report'">
				<div class="formSubRow">
					<xsl:call-template name="MATCH_REPORT_TEAMS"/>
				</div>
				<div class="formSubRow">
					<xsl:call-template name="CYCLING_COMPETITIONS" />
				</div>
			</xsl:when>
			<xsl:when test="$article_subtype='event_report'">
				<div class="formSubRow">
					<xsl:call-template name="CYCLING_COMPETITIONS" />
				</div>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="CYCLING_COMPETITIONS">
		<div class="frow" id="competitionwrapper">
			<div class="labelone"><label for="competition">Choose a competition</label></div>
			<table border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td class="inputHolder">
					<select name="COMPETITION" id="competition" class="inputselect">
						<xsl:call-template name="CYCLING_COMPETITIONS_OPTIONS">
							<xsl:with-param name="node"><xsl:value-of select="MULTI-ELEMENT[@NAME='COMPETITION']/VALUE-EDITABLE"/></xsl:with-param>
						</xsl:call-template>
					</select>
				</td>
				<td class="otherlinkHolder">
					<div class="inputinfo" id="cantfindcompetition"></div>
				</td>
			</tr>
			</table>
		</div>
		<div class="frow" id="othercompetitionwrapper">
			<div class="labelone"><label for="othercompetition">other<br /></label></div>
			<input type="text" name="OTHERCOMPETITION" id="othercompetition" class="inputone" maxlength="{$maxcharacters_textinput_value}">
				<xsl:attribute name="value">
					<xsl:value-of select="MULTI-ELEMENT[@NAME='OTHERCOMPETITION']/VALUE-EDITABLE"/>
				</xsl:attribute>
			</input>
			<xsl:call-template name="maxcharacters_textinput_text" />
		</div>
	</xsl:template>
	
	<xsl:template name="CYCLING_COMPETITIONS_OPTIONS">
		<xsl:param name="node"/>
		
		<option value="">select a competition</option>
		<xsl:for-each select="msxsl:node-set($competitions)/competition[@sport='Cycling'][not(@hide = 'yes')]">
			<option value="{@phrase}">
				<xsl:if test="$node = @phrase">
					<xsl:attribute name="selected">selected</xsl:attribute>
				</xsl:if>
				<xsl:value-of select="@name"/>
			</option>
		</xsl:for-each>
		<option value="Othertype"><xsl:if test="MULTI-ELEMENT[@NAME='COMPETITION']/VALUE-EDITABLE = 'Othertype' or MULTI-ELEMENT[@NAME='OTHERCOMPETITION']/VALUE-EDITABLE/text()"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Other</option>
	
		<!--
		<option value="Tour de France"><xsl:if test="MULTI-ELEMENT[@NAME='COMPETITION']/VALUE-EDITABLE = 'Tour de France'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Tour de France</option>
		<option value="Road cycling"><xsl:if test="MULTI-ELEMENT[@NAME='COMPETITION']/VALUE-EDITABLE = 'Road cycling'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Road cycling</option>
		<option value="Track cycling"><xsl:if test="MULTI-ELEMENT[@NAME='COMPETITION']/VALUE-EDITABLE = 'Track cycling'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Track cycling</option>
		<option value="Mountain biking"><xsl:if test="MULTI-ELEMENT[@NAME='COMPETITION']/VALUE-EDITABLE = 'Mountain biking'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Mountain biking</option>
		<option value="BMX"><xsl:if test="MULTI-ELEMENT[@NAME='COMPETITION']/VALUE-EDITABLE = 'BMX'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>BMX</option>
		<option value="Olympics"><xsl:if test="MULTI-ELEMENT[@NAME='COMPETITION']/VALUE-EDITABLE = 'Olympics'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Olympics</option>
		-->
	</xsl:template>


	<!-- 
	#############################################################
		DISABILITY SPORT
	#############################################################
	-->
	<xsl:template name="DISABILITY_SPORT_DROP_DOWNS">
		<xsl:choose>
			<xsl:when test="$article_type_group='article'">
				<div class="formSubRow">
					<xsl:call-template name="COMPETITION_INPUTBOX" />
				</div>
			</xsl:when>
			<xsl:when test="$article_subtype='player_profile'">
				<div class="formSubRow">
					<xsl:call-template name="COMPETITION_INPUTBOX" />
				</div>
				<div class="formSubRow">
					<xsl:call-template name="PLAYER_PROFILE_TEAM_INPUTBOX" />
				</div>
			</xsl:when>
			<xsl:when test="$article_subtype='team_profile'">
				<div class="formSubRow">
					<xsl:call-template name="COMPETITION_INPUTBOX" />
				</div>
				<div class="formSubRow">
					<xsl:call-template name="TEAM_PROFILE_TEAM_INPUTBOX" />
				</div>
			</xsl:when>
			<xsl:when test="$article_subtype='match_report'">
				<div class="formSubRow">
					<xsl:call-template name="COMPETITION_INPUTBOX" />
				</div>
				<div class="formSubRow">
					<xsl:call-template name="MATCH_REPORT_TEAMS"/>
				</div>
			</xsl:when>
			<xsl:when test="$article_subtype='event_report'">
				<div class="formSubRow">
					<xsl:call-template name="COMPETITION_INPUTBOX" />
				</div>
			</xsl:when>
		</xsl:choose>
	</xsl:template>


	<!-- 
	#############################################################
		OTHER SPORTS
	#############################################################
	-->

	<xsl:template name="OTHER_SPORT_DROP_DOWNS">
		<xsl:choose>
			<xsl:when test="$article_type_group='article'">
				<div class="formSubRow">
					<xsl:call-template name="OTHER_SPORT_SPORTS" />
				</div>
			</xsl:when>
			<xsl:when test="$article_subtype='player_profile'">
				<div class="formSubRow">
					<xsl:call-template name="OTHER_SPORT_SPORTS" />
				</div>
				<div class="formSubRow">
					<xsl:call-template name="PLAYER_PROFILE_TEAM_INPUTBOX" />
				</div>
			</xsl:when>
			<xsl:when test="$article_subtype='team_profile'">
				<div class="formSubRow">
					<xsl:call-template name="OTHER_SPORT_SPORTS" />
				</div>
				<div class="formSubRow">
					<xsl:call-template name="TEAM_PROFILE_TEAM_INPUTBOX" />
				</div>
			</xsl:when>
			<xsl:when test="$article_subtype='match_report'">
				<div class="formSubRow">
					<xsl:call-template name="OTHER_SPORT_SPORTS" />
				</div>
				<div class="formSubRow">
					<xsl:call-template name="MATCH_REPORT_TEAMS"/>
				</div>
			</xsl:when>
			<xsl:when test="$article_subtype='event_report'">
				<div class="formSubRow">
					<xsl:call-template name="OTHER_SPORT_SPORTS" />
				</div>
			</xsl:when>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="OTHER_SPORT_SPORTS">
		<div class="frow" id="othersportwrapper">
			<div class="labelone"><label for="othersport">Choose a sport</label></div>
			<table border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td class="inputHolder">
					<select name="OTHERSPORT" id="othersport" class="inputselect">
						<option value="">select a sport</option>
						<xsl:call-template name="OTHER_SPORT_OPTIONS"/>
					</select>
				</td>
				<td class="otherlinkHolder">
					<div class="inputinfo" id="cantfindothersport"></div>
				</td>
			</tr>
			</table>
		</div>

		<div class="frow" id="otherothersportwrapper">
			<div class="labelone"><label for="otherothersport">other</label></div>
			<input type="text" name="OTHERSPORTUSERS" id="otherothersport" class="inputone" maxlength="{$maxcharacters_textinput_value}">
				<xsl:attribute name="value">
					<xsl:value-of select="MULTI-ELEMENT[@NAME='OTHERSPORTUSERS']/VALUE-EDITABLE"/>
				</xsl:attribute>
			</input>
			<xsl:call-template name="maxcharacters_textinput_text" />
		</div>
	
		<!--
		<xsl:choose>
			<xsl:when test="$article_subtype='match_report'">
				<div class="formSubRow">
					<xsl:call-template name="MATCH_REPORT_TEAMS"/>
				</div>
			</xsl:when>
			<xsl:when test="$article_subtype='event_report'">
				<div class="formSubRow">
					<xsl:call-template name="EVENT_REPORT_OTHER_COMPETITION"/>
				</div>
			</xsl:when>
			<xsl:when test="$article_subtype='team_profile'">
				<div class="formSubRow">
					<xsl:call-template name="TEAM_PROFILE_TEAM_INPUTBOX" />
				</div>
				<div class="formSubRow">
					<xsl:call-template name="TEAM_PROFILE_OTHER_COMPETITION"/>
				</div>
			</xsl:when>
		</xsl:choose>
		-->
	</xsl:template>

	<xsl:template name="OTHER_SPORT_COMPETITIONS">
		<div class="frow" id="competitionwrapper">
			<div class="labelone"><label for="competition">Choose a competition</label></div>
			<table border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td class="inputHolder">
					<select name="COMPETITION" id="competition" class="inputselect">
						<xsl:call-template name="OTHER_SPORT_COMPETITIONS_OPTIONS"/>
					</select>
				</td>
				<td class="otherlinkHolder">
					<div class="inputinfo" id="cantfindcompetition"></div>
				</td>
			</tr>
			</table>
		</div>
		<div class="frow" id="othercompetitionwrapper">
			<div class="labelone"><label for="othercompetition">other<br /></label></div>
			<input type="text" name="OTHERCOMPETITION" id="othercompetition" class="inputone" maxlength="{$maxcharacters_textinput_value}">
				<xsl:attribute name="value">
					<xsl:value-of select="MULTI-ELEMENT[@NAME='OTHERCOMPETITION']/VALUE-EDITABLE"/>
				</xsl:attribute>
			</input>
			<xsl:call-template name="maxcharacters_textinput_text" />
		</div>
	</xsl:template>
	
	<xsl:template name="OTHER_SPORT_COMPETITIONS_OPTIONS">
		<option value="">select a competition</option>
		<option value="Olympics"><xsl:if test="MULTI-ELEMENT[@NAME='COMPETITION']/VALUE-EDITABLE = 'Olympics'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Olympics</option>
		<option value="Sports Personality of the Year"><xsl:if test="MULTI-ELEMENT[@NAME='COMPETITION']/VALUE-EDITABLE = 'Sports Personality of the Year'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Sports Personality of the Year</option>
		<option value="Othertype"><xsl:if test="MULTI-ELEMENT[@NAME='COMPETITION']/VALUE-EDITABLE = 'Othertype'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Other</option>	
	</xsl:template>


	<xsl:template name="ALL_SPORT_DROP_DOWNS">
		<div class="frow">
			<div class="labelone"><label for="sport">sport:</label></div>
			<select name="SPORT" id="sport" class="inputselect">
				<option value="">select a sport</option>			
				<xsl:call-template name="SPORT_OPTIONS" />
				<xsl:call-template name="OTHER_SPORT_OPTIONS" />
			</select>
		</div>

		<div class="frow">
			<div class="labelone"><label for="othersportusers">Other sport:</label></div>
			<input type="text" name="OTHERSPORTUSERS" id="othersportusers" class="inputone" maxlength="{$maxcharacters_textinput_value}">
				<xsl:attribute name="value">
					<xsl:value-of select="MULTI-ELEMENT[@NAME='OTHERSPORTUSERS']/VALUE-EDITABLE"/>
				</xsl:attribute>
			</input>
			<xsl:call-template name="maxcharacters_textinput_text" />
		</div>
	</xsl:template>


	<xsl:template name="SPORT_OPTIONS">
		<option value="Football"><xsl:if test="MULTI-ELEMENT[@NAME='OTHERSPORT']/VALUE-EDITABLE = 'Football'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Football</option>
		<option value="Cricket"><xsl:if test="MULTI-ELEMENT[@NAME='OTHERSPORT']/VALUE-EDITABLE = 'Cricket'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Cricket</option>
		<option value="Rugby union"><xsl:if test="MULTI-ELEMENT[@NAME='OTHERSPORT']/VALUE-EDITABLE = 'Rugby union'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Rugby union</option>
		<option value="Rugby league"><xsl:if test="MULTI-ELEMENT[@NAME='OTHERSPORT']/VALUE-EDITABLE = 'Rugby league'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Rugby league</option>
		<option value="Tennis"><xsl:if test="MULTI-ELEMENT[@NAME='OTHERSPORT']/VALUE-EDITABLE = 'Tennis'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Tennis</option>
		<option value="Golf"><xsl:if test="MULTI-ELEMENT[@NAME='OTHERSPORT']/VALUE-EDITABLE = 'Golf'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Golf</option>
		<option value="Motorsport"><xsl:if test="MULTI-ELEMENT[@NAME='OTHERSPORT']/VALUE-EDITABLE = 'Motorsport'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Motorsport</option>
		<option value="Boxing"><xsl:if test="MULTI-ELEMENT[@NAME='OTHERSPORT']/VALUE-EDITABLE = 'Boxing'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Boxing</option>
		<option value="Athletics"><xsl:if test="MULTI-ELEMENT[@NAME='OTHERSPORT']/VALUE-EDITABLE = 'Athletics'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Athletics</option>
		<option value="Snooker"><xsl:if test="MULTI-ELEMENT[@NAME='OTHERSPORT']/VALUE-EDITABLE = 'Snooker'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Snooker</option>
		<option value="Horse racing"><xsl:if test="MULTI-ELEMENT[@NAME='OTHERSPORT']/VALUE-EDITABLE = 'Horse racing'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Horse racing</option>
		<option value="Cycling"><xsl:if test="MULTI-ELEMENT[@NAME='OTHERSPORT']/VALUE-EDITABLE = 'Cycling'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Cycling</option>
	</xsl:template>

	<xsl:template name="OTHER_SPORT_OPTIONS">
		<xsl:variable name="incoming_othersport" select="MULTI-ELEMENT[@NAME='OTHERSPORT']/VALUE-EDITABLE"/>
		<xsl:for-each select="msxsl:node-set($MasterSports)/sports/sport[not(@main='yes')]">
			<option value="{@phrase} {@searchterms}">
				<xsl:if test="$incoming_othersport = concat(@phrase, ' ', @searchterms)">
					<xsl:attribute name="selected">selected</xsl:attribute>
				</xsl:if>
				<xsl:value-of select="name"/>
			</option>
		</xsl:for-each>
		<option value="Othersportusers"><xsl:if test="MULTI-ELEMENT[@NAME='OTHERSPORT']/VALUE-EDITABLE = 'Othersportusers'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Other</option>		
	</xsl:template>


	<xsl:template name="PLAYER_PROFILE_TEAM_INPUT">
			<xsl:choose>
				<xsl:when test="$sport='Football' or $sport='Cricket' or $sport='Rugby Union' or $sport='Rugby League'">
					<div id="hometeamwrapper">
						<xsl:if test="MULTI-ELEMENT[@NAME='TEAM']/ERRORS/ERROR/@TYPE='VALIDATION-ERROR-EMPTY'">
							<xsl:attribute name="class">alert</xsl:attribute>
						</xsl:if>
						<div class="inputinfo2" id="cantfindhometeam"></div>
						<select name="TEAM" id="hometeam" class="inputselect2">
							<xsl:choose>
								<xsl:when test="$sport='Football'">
									<xsl:call-template name="FOOTBALL_TEAMS_OPTIONS">
										<xsl:with-param name="node"><xsl:value-of select="MULTI-ELEMENT[@NAME='TEAM']/VALUE-EDITABLE"/></xsl:with-param>
									</xsl:call-template>
								</xsl:when>
								<xsl:when test="$sport='Cricket'">
									<xsl:call-template name="CRICKET_TEAMS_OPTIONS">
										<xsl:with-param name="node"><xsl:value-of select="MULTI-ELEMENT[@NAME='TEAM']/VALUE-EDITABLE"/></xsl:with-param>
									</xsl:call-template>
								</xsl:when>
								<xsl:when test="$sport='Rugby Union'">
									<xsl:call-template name="RUGBY_UNION_TEAMS_OPTIONS">
										<xsl:with-param name="node"><xsl:value-of select="MULTI-ELEMENT[@NAME='TEAM']/VALUE-EDITABLE"/></xsl:with-param>
									</xsl:call-template>
								</xsl:when>
								<xsl:when test="$sport='Rugby League'">
									<xsl:call-template name="RUGBY_LEAGUE_TEAMS_OPTIONS">
										<xsl:with-param name="node"><xsl:value-of select="MULTI-ELEMENT[@NAME='TEAM']/VALUE-EDITABLE"/></xsl:with-param>
									</xsl:call-template>
								</xsl:when>
							</xsl:choose>
						</select>

					</div>

					<div id="otherhometeamwrapper">
						<div class="head" align="left"><label for="otherhometeam">other</label></div>
						<input type="text" name="TEAMOTHER" id="otherhometeam" class="inputtwo" maxlength="{$maxcharacters_textinput_value}">
							<xsl:attribute name="value">
								<xsl:value-of select="MULTI-ELEMENT[@NAME='TEAMOTHER']/VALUE-EDITABLE"/>
							</xsl:attribute>
						</input>
						<xsl:call-template name="maxcharacters_textinput_text2" />
					</div>
				</xsl:when>
				<xsl:otherwise>
					<div id="hometeamwrapper">
						<xsl:if test="MULTI-ELEMENT[@NAME='TEAM']/ERRORS/ERROR/@TYPE='VALIDATION-ERROR-EMPTY'">
							<xsl:attribute name="class">alert</xsl:attribute>
						</xsl:if>
						<br/>
						<input type="text" name="TEAM" id="hometeam" class="inputtwo" maxlength="{$maxcharacters_textinput_value}">
							<xsl:attribute name="value">
								<xsl:value-of select="MULTI-ELEMENT[@NAME='TEAM']/VALUE-EDITABLE"/>
							</xsl:attribute>
						</input>
						<xsl:call-template name="maxcharacters_textinput_text2" />
					</div>

				</xsl:otherwise>
			</xsl:choose>
	</xsl:template>

	<!-- TEAM PROFILE - tema input for sports without predefinied list of teams (i.e no drop down) -->
	<xsl:template name="TEAM_PROFILE_TEAM_INPUTBOX">
		<xsl:if test="$article_subtype = 'team_profile' and ($sport != 'Football' and $sport != 'Cricket' and $sport != 'Rugby Union' and $sport != 'Rugby League')">
			 <div class="frow" id="teamwrapper">
				<xsl:if test="$article_subtype='team_profile' and MULTI-ELEMENT[@NAME='TEAM']/ERRORS/ERROR/@TYPE='VALIDATION-ERROR-EMPTY'">
					<xsl:attribute name="class">frow alert</xsl:attribute>
					<div class="errortext"><strong>Please select a team</strong></div>
				</xsl:if>
				<xsl:variable name="teamlabel">
					<xsl:choose>
						<xsl:when test="$sport='Horse Racing'">stable</xsl:when>
						<xsl:otherwise>team</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<div class="labelone"><label for="team"><xsl:value-of select="$teamlabel"/><span class="required">*</span></label></div>
				<input type="text" name="TEAM" id="otherteam" class="inputone" maxlength="{$maxcharacters_textinput_value}">
					<xsl:attribute name="value">
						<xsl:value-of select="MULTI-ELEMENT[@NAME='TEAM']/VALUE-EDITABLE"/>
					</xsl:attribute>
				</input>
				<xsl:call-template name="maxcharacters_textinput_text" />
			</div>
		</xsl:if>
	</xsl:template>

	<!-- PLAYER PROFILE - tema input for sports without predefinied list of teams (i.e no drop down) -->
	<xsl:template name="PLAYER_PROFILE_TEAM_INPUTBOX">
		<xsl:if test="$article_subtype = 'player_profile' and ($sport != 'Football' and $sport != 'Cricket' and $sport != 'Rugby Union' and $sport != 'Rugby League')">
			 <div class="frow" id="teamwrapper">
				<xsl:if test="$article_subtype='player_profile' and MULTI-ELEMENT[@NAME='TEAM']/ERRORS/ERROR/@TYPE='VALIDATION-ERROR-EMPTY'">
					<xsl:attribute name="class">frow alert</xsl:attribute>
					<div class="errortext"><strong>Please select a team</strong></div>
				</xsl:if>
				<!--[FIXME: remove]
				<xsl:variable name="teamlabel">
					<xsl:choose>
						<xsl:when test="$sport='Horse Racing'">stable</xsl:when>
						<xsl:otherwise>team</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				-->
				<div class="labelone"><label for="team">Current team and/or nationality<span class="required">*</span></label></div>
				<input type="text" name="TEAM" id="otherteam" class="inputone" maxlength="{$maxcharacters_textinput_value}">
					<xsl:attribute name="value">
						<xsl:value-of select="MULTI-ELEMENT[@NAME='TEAM']/VALUE-EDITABLE"/>
					</xsl:attribute>
				</input>
				<xsl:call-template name="maxcharacters_textinput_text" />
			</div>
		</xsl:if>
	</xsl:template>

	<xsl:template name="COMPETITION_INPUTBOX">
		 <div class="frow" id="competitionwrapper">
			<div class="labelone"><label for="competition">competition<span class="required">*</span></label></div>
			<input type="text" name="OTHERCOMPETITION" id="othercompetition" class="inputone" maxlength="{$maxcharacters_textinput_value}">
				<xsl:attribute name="value">
					<xsl:value-of select="MULTI-ELEMENT[@NAME='OTHERCOMPETITION']/VALUE-EDITABLE"/>
				</xsl:attribute>
			</input>
			<xsl:call-template name="maxcharacters_textinput_text" />
		</div>
	</xsl:template>
	
	<xsl:template name="MATCH_REPORT_TEAMS">
		<xsl:if test="MULTI-ELEMENT[@NAME='HOMETEAM']/ERRORS/ERROR/@TYPE='VALIDATION-ERROR-EMPTY' or MULTI-ELEMENT[@NAME='HOMETEAMSCORE']/ERRORS/ERROR/@TYPE='VALIDATION-ERROR-EMPTY' or MULTI-ELEMENT[@NAME='AWAYTEAMSCORE']/ERRORS/ERROR/@TYPE='VALIDATION-ERROR-EMPTY' or MULTI-ELEMENT[@NAME='AWAYTEAM']/ERRORS/ERROR/@TYPE='VALIDATION-ERROR-EMPTY'">
			<div class="errortext alert"><strong>Please select teams and provide scores</strong></div>
		</xsl:if>

		<xsl:choose>
			<xsl:when test="$sport='Football' or $sport='Cricket' or $sport='Rugby Union' or $sport='Rugby League'">
				<div class="head" align="left"><label for="hometeam">Choose your teams<span class="required">*</span></label></div>
			</xsl:when>
			<xsl:otherwise>
				<div class="head" align="left"><label for="hometeam">Choose your competitors<span class="required">*</span></label></div>
			</xsl:otherwise>
		</xsl:choose>
		<table cellpadding="0" cellspacing="0" border="0">
		<tr>
		<td width="195" valign="top">
			<!-- home team -->
			<xsl:choose>
				<xsl:when test="$sport='Football' or $sport='Cricket' or $sport='Rugby Union' or $sport='Rugby League'">
					<div id="hometeamwrapper">
						<xsl:if test="MULTI-ELEMENT[@NAME='HOMETEAM']/ERRORS/ERROR/@TYPE='VALIDATION-ERROR-EMPTY'">
							<xsl:attribute name="class">alert</xsl:attribute>
						</xsl:if>
						<div class="inputinfo2" id="cantfindhometeam"></div>
						<select name="HOMETEAM" id="hometeam" class="inputselect2">
							<xsl:choose>
								<xsl:when test="$sport='Football'">
									<xsl:call-template name="FOOTBALL_TEAMS_OPTIONS">
										<xsl:with-param name="node"><xsl:value-of select="MULTI-ELEMENT[@NAME='HOMETEAM']/VALUE-EDITABLE"/></xsl:with-param>
									</xsl:call-template>
								</xsl:when>
								<xsl:when test="$sport='Cricket'">
									<xsl:call-template name="CRICKET_TEAMS_OPTIONS">
										<xsl:with-param name="node"><xsl:value-of select="MULTI-ELEMENT[@NAME='HOMETEAM']/VALUE-EDITABLE"/></xsl:with-param>
									</xsl:call-template>
								</xsl:when>
								<xsl:when test="$sport='Rugby Union'">
									<xsl:call-template name="RUGBY_UNION_TEAMS_OPTIONS">
										<xsl:with-param name="node"><xsl:value-of select="MULTI-ELEMENT[@NAME='HOMETEAM']/VALUE-EDITABLE"/></xsl:with-param>
									</xsl:call-template>
								</xsl:when>
								<xsl:when test="$sport='Rugby League'">
									<xsl:call-template name="RUGBY_LEAGUE_TEAMS_OPTIONS">
										<xsl:with-param name="node"><xsl:value-of select="MULTI-ELEMENT[@NAME='HOMETEAM']/VALUE-EDITABLE"/></xsl:with-param>
									</xsl:call-template>
								</xsl:when>
							</xsl:choose>
						</select>
					</div>
					<div id="otherhometeamwrapper">
						<div class="head" align="left"><label for="otherhometeam">other</label></div>
						<input type="text" name="HOMETEAMOTHER" id="otherhometeam" class="inputtwo">
							<xsl:attribute name="maxlength">
								<xsl:choose>
									<xsl:when test="$test_IsEditor or not($sport = 'Football')">
										<xsl:value-of select="$maxcharacters_textinput_value"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="$maxcharacters_textinput_value_limited"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:attribute>
							<xsl:attribute name="value">
								<xsl:value-of select="MULTI-ELEMENT[@NAME='HOMETEAMOTHER']/VALUE-EDITABLE"/>
							</xsl:attribute>
						</input>
						<xsl:choose>
							<xsl:when test="$test_IsEditor or not($sport = 'Football')">
								<xsl:call-template name="maxcharacters_textinput_text2" />
							</xsl:when>
							<xsl:otherwise>
								<xsl:call-template name="maxcharacters_textinput_text2_limited" />
							</xsl:otherwise>
						</xsl:choose>						
					</div>
				</xsl:when>
				<xsl:otherwise>
					<div id="hometeamwrapper">
						<xsl:if test="MULTI-ELEMENT[@NAME='HOMETEAM']/ERRORS/ERROR/@TYPE='VALIDATION-ERROR-EMPTY'">
							<xsl:attribute name="class">alert</xsl:attribute>
						</xsl:if>
						<br/>
						<input type="text" name="HOMETEAM" id="hometeam" class="inputtwo" maxlength="{$maxcharacters_textinput_value}">
							<xsl:attribute name="value">
								<xsl:value-of select="MULTI-ELEMENT[@NAME='HOMETEAM']/VALUE-EDITABLE"/>
							</xsl:attribute>
						</input>
						<xsl:call-template name="maxcharacters_textinput_text2" />
					</div>
				</xsl:otherwise>
			</xsl:choose>
		</td>
		<td width="100" valign="top" align="center">
		<!-- score -->
		<xsl:if test="MULTI-ELEMENT[@NAME='HOMETEAMSCORE']/ERRORS/ERROR/@TYPE='VALIDATION-ERROR-EMPTY' or MULTI-ELEMENT[@NAME='AWAYTEAMSCORE']/ERRORS/ERROR/@TYPE='VALIDATION-ERROR-EMPTY'">
			<xsl:attribute name="class">alert</xsl:attribute>
		</xsl:if>

            <xsl:if test="$sport!='Cricket'">
                <xsl:choose>
                    <xsl:when test="$sport='Football' or $sport='Rugby Union' or $sport='Rugby League'">
                        <div class="head" align="center">score</div>
                    </xsl:when>
                    <xsl:otherwise>
                        <div class="headblank" align="center">score</div>
                    </xsl:otherwise>
                </xsl:choose>
                <span>
                    <input type="text" name="HOMETEAMSCORE" title="home team's score" class="inputthree" maxlength="2">
                        <xsl:attribute name="value">
                            <xsl:value-of select="MULTI-ELEMENT[@NAME='HOMETEAMSCORE']/VALUE-EDITABLE"/>
                        </xsl:attribute>
                    </input>
                </span>
                <xsl:text> </xsl:text>
                <span>
                    <input type="text" name="AWAYTEAMSCORE" title="away team's score" class="inputthree" maxlength="2">
                        <xsl:attribute name="value">
                            <xsl:value-of select="MULTI-ELEMENT[@NAME='AWAYTEAMSCORE']/VALUE-EDITABLE"/>
                        </xsl:attribute>
                    </input>
                </span>
            </xsl:if>
		</td>
		<td width="195" valign="top" align="right">
		<!-- away team -->
		<xsl:choose>
				<xsl:when test="$sport='Football' or $sport='Cricket' or $sport='Rugby Union' or $sport='Rugby League'">
					<div id="awayteamwrapper">
						<xsl:if test="MULTI-ELEMENT[@NAME='AWAYTEAM']/ERRORS/ERROR/@TYPE='VALIDATION-ERROR-EMPTY'">
							<xsl:attribute name="class">alert</xsl:attribute>
						</xsl:if>

						<div class="inputinfo2" id="cantfindawayteam"></div>
						<select name="AWAYTEAM" id="awayteam" class="inputselect2">
							<xsl:choose>
								<xsl:when test="$sport='Football'">
									<xsl:call-template name="FOOTBALL_TEAMS_OPTIONS">
										<xsl:with-param name="node"><xsl:value-of select="MULTI-ELEMENT[@NAME='AWAYTEAM']/VALUE-EDITABLE"/></xsl:with-param>
									</xsl:call-template>
								</xsl:when>
								<xsl:when test="$sport='Cricket'">
									<xsl:call-template name="CRICKET_TEAMS_OPTIONS">
										<xsl:with-param name="node"><xsl:value-of select="MULTI-ELEMENT[@NAME='AWAYTEAM']/VALUE-EDITABLE"/></xsl:with-param>
									</xsl:call-template>
								</xsl:when>
								<xsl:when test="$sport='Rugby Union'">
									<xsl:call-template name="RUGBY_UNION_TEAMS_OPTIONS">
										<xsl:with-param name="node"><xsl:value-of select="MULTI-ELEMENT[@NAME='AWAYTEAM']/VALUE-EDITABLE"/></xsl:with-param>
									</xsl:call-template>
								</xsl:when>
								<xsl:when test="$sport='Rugby League'">
									<xsl:call-template name="RUGBY_LEAGUE_TEAMS_OPTIONS">
										<xsl:with-param name="node"><xsl:value-of select="MULTI-ELEMENT[@NAME='AWAYTEAM']/VALUE-EDITABLE"/></xsl:with-param>
									</xsl:call-template>
								</xsl:when>
							</xsl:choose>
						</select>

					</div>

					<div id="otherawayteamwrapper">
						<div class="head" align="right"><label for="otherawayteam">other</label></div>
						<input type="text" name="AWAYTEAMOTHER" id="otherawayteam" class="inputtwo">
							<xsl:attribute name="maxlength">
								<xsl:choose>
									<xsl:when test="$test_IsEditor or not($sport = 'Football')">
										<xsl:value-of select="$maxcharacters_textinput_value"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="$maxcharacters_textinput_value_limited"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:attribute>
							<xsl:attribute name="value">
								<xsl:value-of select="MULTI-ELEMENT[@NAME='AWAYTEAMOTHER']/VALUE-EDITABLE"/>
							</xsl:attribute>
						</input>
						<xsl:choose>
							<xsl:when test="$test_IsEditor or not($sport = 'Football')">
								<xsl:call-template name="maxcharacters_textinput_text2" />
							</xsl:when>
							<xsl:otherwise>
								<xsl:call-template name="maxcharacters_textinput_text2_limited" />
							</xsl:otherwise>
						</xsl:choose>
					</div>
				</xsl:when>
				<xsl:otherwise>
					<div id="awayteamwrapper">
						<xsl:if test="MULTI-ELEMENT[@NAME='AWAYTEAM']/ERRORS/ERROR/@TYPE='VALIDATION-ERROR-EMPTY'">
							<xsl:attribute name="class">alert</xsl:attribute>
						</xsl:if>
						<br/>
						<input type="text" name="AWAYTEAM" id="hometeam" class="inputtwo" maxlength="{$maxcharacters_textinput_value}">
							<xsl:attribute name="value">
								<xsl:value-of select="MULTI-ELEMENT[@NAME='AWAYTEAM']/VALUE-EDITABLE"/>
							</xsl:attribute>
						</input>
						<xsl:call-template name="maxcharacters_textinput_text2" />
					</div>

				</xsl:otherwise>
			</xsl:choose>	
		</td>				
		</tr>
		</table>
	</xsl:template>

	<xsl:template name="TEAM_PROFILE_OTHER_COMPETITION">
		<div class="frow" id="competitionwrapper">
			<div class="labelone"><label for="competition">Choose a competition</label></div>
			<input type="text" name="OTHERCOMPETITION" id="othercompetition" class="inputone" maxlength="{$maxcharacters_textinput_value}">
				<xsl:attribute name="value">
					<xsl:value-of select="MULTI-ELEMENT[@NAME='OTHERCOMPETITION']/VALUE-EDITABLE"/>
				</xsl:attribute>
			</input>
			<xsl:call-template name="maxcharacters_textinput_text" />
		</div>
	</xsl:template>

	<xsl:template name="EVENT_REPORT_OTHER_COMPETITION">
		<div class="frow" id="competitionwrapper">
			<xsl:if test="MULTI-ELEMENT[@NAME='COMPETITION']/ERRORS/ERROR/@TYPE='VALIDATION-ERROR-EMPTY'">
				<xsl:attribute name="class">frow alert</xsl:attribute>
				<div class="errortext"><strong>Please select a competition</strong></div>
			</xsl:if>
			<div class="labelone"><label for="competition">competition<span class="required">*</span></label></div>
			<input type="text" name="COMPETITION" id="competition" class="inputone" maxlength="{$maxcharacters_textinput_value}">
				<xsl:attribute name="value">
					<xsl:value-of select="MULTI-ELEMENT[@NAME='COMPETITION']/VALUE-EDITABLE"/>
				</xsl:attribute>
			</input>
			<xsl:call-template name="maxcharacters_textinput_text" />
		</div>
	</xsl:template>


	<!-- 
	#############################################################
		DATES
	#############################################################
	-->

	<xsl:template name="DATEDAY_OPTIONS">
		<option value="">day</option>
		<option value="1"><xsl:if test="MULTI-ELEMENT[@NAME='DATEDAY']/VALUE-EDITABLE = '1'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>1</option>
		<option value="2"><xsl:if test="MULTI-ELEMENT[@NAME='DATEDAY']/VALUE-EDITABLE = '2'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>2</option>
		<option value="3"><xsl:if test="MULTI-ELEMENT[@NAME='DATEDAY']/VALUE-EDITABLE = '3'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>3</option>
		<option value="4"><xsl:if test="MULTI-ELEMENT[@NAME='DATEDAY']/VALUE-EDITABLE = '4'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>4</option>
		<option value="5"><xsl:if test="MULTI-ELEMENT[@NAME='DATEDAY']/VALUE-EDITABLE = '5'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>5</option>
		<option value="6"><xsl:if test="MULTI-ELEMENT[@NAME='DATEDAY']/VALUE-EDITABLE = '6'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>6</option>
		<option value="7"><xsl:if test="MULTI-ELEMENT[@NAME='DATEDAY']/VALUE-EDITABLE = '7'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>7</option>
		<option value="8"><xsl:if test="MULTI-ELEMENT[@NAME='DATEDAY']/VALUE-EDITABLE = '8'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>8</option>
		<option value="9"><xsl:if test="MULTI-ELEMENT[@NAME='DATEDAY']/VALUE-EDITABLE = '9'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>9</option>
		<option value="10"><xsl:if test="MULTI-ELEMENT[@NAME='DATEDAY']/VALUE-EDITABLE = '10'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>10</option>
		<option value="11"><xsl:if test="MULTI-ELEMENT[@NAME='DATEDAY']/VALUE-EDITABLE = '11'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>11</option>
		<option value="12"><xsl:if test="MULTI-ELEMENT[@NAME='DATEDAY']/VALUE-EDITABLE = '12'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>12</option>
		<option value="13"><xsl:if test="MULTI-ELEMENT[@NAME='DATEDAY']/VALUE-EDITABLE = '13'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>13</option>
		<option value="14"><xsl:if test="MULTI-ELEMENT[@NAME='DATEDAY']/VALUE-EDITABLE = '14'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>14</option>
		<option value="15"><xsl:if test="MULTI-ELEMENT[@NAME='DATEDAY']/VALUE-EDITABLE = '15'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>15</option>
		<option value="16"><xsl:if test="MULTI-ELEMENT[@NAME='DATEDAY']/VALUE-EDITABLE = '16'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>16</option>
		<option value="17"><xsl:if test="MULTI-ELEMENT[@NAME='DATEDAY']/VALUE-EDITABLE = '17'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>17</option>
		<option value="18"><xsl:if test="MULTI-ELEMENT[@NAME='DATEDAY']/VALUE-EDITABLE = '18'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>18</option>
		<option value="19"><xsl:if test="MULTI-ELEMENT[@NAME='DATEDAY']/VALUE-EDITABLE = '19'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>19</option>
		<option value="20"><xsl:if test="MULTI-ELEMENT[@NAME='DATEDAY']/VALUE-EDITABLE = '20'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>20</option>
		<option value="21"><xsl:if test="MULTI-ELEMENT[@NAME='DATEDAY']/VALUE-EDITABLE = '21'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>21</option>
		<option value="22"><xsl:if test="MULTI-ELEMENT[@NAME='DATEDAY']/VALUE-EDITABLE = '22'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>22</option>
		<option value="23"><xsl:if test="MULTI-ELEMENT[@NAME='DATEDAY']/VALUE-EDITABLE = '23'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>23</option>
		<option value="24"><xsl:if test="MULTI-ELEMENT[@NAME='DATEDAY']/VALUE-EDITABLE = '24'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>24</option>
		<option value="25"><xsl:if test="MULTI-ELEMENT[@NAME='DATEDAY']/VALUE-EDITABLE = '25'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>25</option>
		<option value="26"><xsl:if test="MULTI-ELEMENT[@NAME='DATEDAY']/VALUE-EDITABLE = '26'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>26</option>
		<option value="27"><xsl:if test="MULTI-ELEMENT[@NAME='DATEDAY']/VALUE-EDITABLE = '27'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>27</option>
		<option value="28"><xsl:if test="MULTI-ELEMENT[@NAME='DATEDAY']/VALUE-EDITABLE = '28'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>28</option>
		<option value="29"><xsl:if test="MULTI-ELEMENT[@NAME='DATEDAY']/VALUE-EDITABLE = '29'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>29</option>
		<option value="30"><xsl:if test="MULTI-ELEMENT[@NAME='DATEDAY']/VALUE-EDITABLE = '30'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>30</option>
		<option value="31"><xsl:if test="MULTI-ELEMENT[@NAME='DATEDAY']/VALUE-EDITABLE = '31'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>31</option>
	</xsl:template>

	<xsl:template name="DATEMONTH_OPTIONS">
		<option value="">month</option>
		<option value="January"><xsl:if test="MULTI-ELEMENT[@NAME='DATEMONTH']/VALUE-EDITABLE = 'January'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>January</option>
		<option value="February"><xsl:if test="MULTI-ELEMENT[@NAME='DATEMONTH']/VALUE-EDITABLE = 'February'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>February</option>
		<option value="March"><xsl:if test="MULTI-ELEMENT[@NAME='DATEMONTH']/VALUE-EDITABLE = 'March'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>March</option>
		<option value="April"><xsl:if test="MULTI-ELEMENT[@NAME='DATEMONTH']/VALUE-EDITABLE = 'April'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>April</option>
		<option value="May"><xsl:if test="MULTI-ELEMENT[@NAME='DATEMONTH']/VALUE-EDITABLE = 'May'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>May</option>
		<option value="June"><xsl:if test="MULTI-ELEMENT[@NAME='DATEMONTH']/VALUE-EDITABLE = 'June'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>June</option>
		<option value="July"><xsl:if test="MULTI-ELEMENT[@NAME='DATEMONTH']/VALUE-EDITABLE = 'July'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>July</option>
		<option value="August"><xsl:if test="MULTI-ELEMENT[@NAME='DATEMONTH']/VALUE-EDITABLE = 'August'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>August</option>
		<option value="September"><xsl:if test="MULTI-ELEMENT[@NAME='DATEMONTH']/VALUE-EDITABLE = 'September'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>September</option>
		<option value="October"><xsl:if test="MULTI-ELEMENT[@NAME='DATEMONTH']/VALUE-EDITABLE = 'October'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>October</option>
		<option value="November"><xsl:if test="MULTI-ELEMENT[@NAME='DATEMONTH']/VALUE-EDITABLE = 'November'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>November</option>
		<option value="December"><xsl:if test="MULTI-ELEMENT[@NAME='DATEMONTH']/VALUE-EDITABLE = 'December'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>December</option>
	</xsl:template>

	<!-- 
	Competitions:

	Premiership 
	Championship 
	League One 
	League Two 
	Non League 
	FA Cup 
	League Cup 
	Scottish Premier 
	Scottish League 
	Scottish Cups 
	Welsh 
	Irish 
	International football
	European Football
	African 
	Women

	Test cricket
	One-day internationals
	County cricket

	Six Nations
	International rugby
	European club rugby
	English club rugby
	Irish club rugby
	Scottish club rugby
	Welsh club rugby

	Super League
	Challenge Cup
	Australian
	International rugby league 

	-->
	
</xsl:stylesheet>
