<?xml version="1.0" encoding="iso-8859-1"?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0"
	xmlns:xhtml="http://www.w3.org/1999/xhtml"
	xmlns="http://www.w3.org/1999/xhtml"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:msxsl="urn:schemas-microsoft-com:xslt"
	xmlns:local="#local-functions"
	xmlns:s="urn:schemas-microsoft-com:xml-data"
	xmlns:dt="urn:schemas-microsoft-com:datatypes"
	exclude-result-prefixes="msxsl local s dt xhtml">



<!-- 
#############################################################
PROFILE FORM
#############################################################
-->
<!-- form used for create/edit profile:  TYPE = 3001 -->
<xsl:template name="PROFILE_FORM">
	<!-- DEBUG -->
	<xsl:call-template name="TRACE">
	<xsl:with-param name="message">PROFILE_FORM</xsl:with-param>
	<xsl:with-param name="pagename">typedarticlepage_templates.xsl</xsl:with-param>
	</xsl:call-template>
	<!-- DEBUG -->
	<input type="hidden" name="_msxml" value="{$user_intro_fields}"/>
	<input type="hidden" name="type" value="3001"/>
	<input type="hidden" name="TITLE">
	<xsl:attribute name="value">
		<xsl:value-of select="/H2G2/ARTICLE/ARTICLEINFO/PAGEAUTHOR/EDITOR/USER/USERNAME" /> 
	</xsl:attribute>
	</input>
	<input type="hidden" name="ARTICLECLASS" value="_profile"/>

	<div id="topPage">
		<div class="innerWide">
			<div id="shortDescForm">
				<h2>Your Memories</h2>									
				<p>
					<xsl:apply-templates select="/H2G2/MULTI-STAGE" mode="errors"/>
				</p>
				<!--[FIXME: redundant]
				<input type="hidden" name="TITLE" id="title" class="inputone" maxlength="{$maxcharacters_textinput_value}">
					<xsl:attribute name="value">
						<xsl:value-of select="MULTI-REQUIRED[@NAME='TITLE']/VALUE-EDITABLE"/>
					</xsl:attribute>
				</input>
				-->

				<label for="description">
					A short description about yourself					
					<xsl:if test="MULTI-REQUIRED[@NAME='BODY']/ERRORS/ERROR/@TYPE='VALIDATION-ERROR-EMPTY'">
						<em class="alert">Please write something about yourself</em>
					</xsl:if>
					</label><br/>
				<textarea name="body" id="description" cols="30" rows="6" maxlength="450" wrap="virtual">
					<xsl:value-of select="MULTI-REQUIRED[@NAME='BODY']/VALUE-EDITABLE"/>
				</textarea>			

				<div class="submitRow">
					<xsl:call-template name="SUBMIT_BUTTONS" />
				</div>
			</div>
		</div>
	</div>
    <xsl:call-template name="SEARCH_RSS_FEED"/>
</xsl:template>




<!-- 
#############################################################
ARTICLE (MEMORY) FORM
#############################################################
-->
<!-- form used for creating an article (poll with comments) -->
<xsl:template name="ARTICLE_FORM">

	<!-- DEBUG -->
	<xsl:call-template name="TRACE">
	<xsl:with-param name="message">USER_ARTICLE_FORM</xsl:with-param>
	<xsl:with-param name="pagename">typedarticlepage_templates.xsl</xsl:with-param>
	</xsl:call-template>
	<!-- DEBUG -->
	
	<input type="hidden" name="_msxml" value="{$article_form}"/>
	<input type="hidden" name="ARTICLEFORUMSTYLE" value="1"/>
	<!--[FIXME: remove or change value?]
	<input type="hidden" name="polltype1" value="3"/>
	-->
	<input type="hidden" name="status" value="3"/>
	<input type="hidden" name="type">
		<xsl:attribute name="value"><xsl:value-of select="$current_article_type"/></xsl:attribute>
	</input>
	<!--
	
	-->
	<!--
	<input type="hidden" name="skin" value="purexml"/>
	-->
	<input type="hidden" name="haskeyphrases" value="1"/>

	<input type="hidden" name="ARTICLECLASS" value="_memory"/>
	<xsl:choose>
		<xsl:when test="$article_subtype = 'staff_memory' and $test_IsAdminUser">
			<input type="hidden" name="TYPEOFARTICLE" value="_staff_memory"/>
		</xsl:when>
		<xsl:otherwise>
			<input type="hidden" name="TYPEOFARTICLE" value="_user_memory"/>
		</xsl:otherwise>
	</xsl:choose>
	
	<!-- 
		============================================================
				AUTO TAGGING 
		============================================================ 
	-->
	
	<xsl:call-template name="AUTO_HIDDEN_FIELDS">
		<xsl:with-param name="keyword" select="$client_keyword"/>
		<xsl:with-param name="visibletag" select="$client_visibletag"/>
	</xsl:call-template>

	<!-- 
		============================================================
				END AUTO TAGGING 
		============================================================ 
	-->

	<div id="ms-std">
		<div id="ms-std-header"><xsl:comment> ms-std-header </xsl:comment></div>
		<div id="ms-std-content">
			<xsl:choose>
				<xsl:when test="/H2G2/MULTI-STAGE/@TYPE='TYPED-ARTICLE-EDIT' or /H2G2/MULTI-STAGE/@TYPE='TYPED-ARTICLE-EDIT-PREVIEW'">
					<h2>Edit memory</h2>
				</xsl:when>
				<xsl:otherwise>
					<h2>Add memory</h2>
				</xsl:otherwise>
			</xsl:choose>
			<p>
				Your Memory is something that happened to you at a certain time and in a certain place. The more information you can share, the more likely it is that others will be able to find your memory (remember, they may search by date, place or event).
			</p>
			<xsl:apply-templates select="/H2G2/MULTI-STAGE" mode="errors"/>

			<xsl:text disable-output-escaping="yes">
			&lt;script type="text/javascript" src="/memoryshare/assets/js/jquery.autocomplete.js"&gt;&lt;/script&gt;</xsl:text>

			<div id="addMemoryBox">
				<div id="addMemoryBoxHeader"><xsl:comment> add-memory-header </xsl:comment></div>
				<div id="layerScroll2">
					<div id="scrollContainer">
						<div id="memoryPanel">

							<!-- staff memories can have an alternative name (e.g. celebrity) -->
							<xsl:if test="$test_IsAdminUser">
								<p>
									<label for="altname">Added on behalf of</label>
								</p>
								<p>
									<input class="txt" type="text" name="altname" id="altname" maxlength="{$maxcharacters_textinput_value}">
										<xsl:attribute name="value">
											<xsl:value-of select="MULTI-ELEMENT[@NAME='ALTNAME']/VALUE-EDITABLE"/>
										</xsl:attribute>
									</input>
								</p>
							</xsl:if>

							<p>
								<label for="title">
									Title
									<em>
										<xsl:apply-templates select="MULTI-REQUIRED[@NAME='TITLE']" mode="validate">
											<xsl:with-param name="msg">Please enter a title.</xsl:with-param>
											<xsl:with-param name="cancel" select="@CANCEL"/>
										</xsl:apply-templates>
									</em>
								</label>
							</p>
							<p>
								<input class="txt" type="text" name="title" id="title" maxlength="{$maxcharacters_textinput_value}">
									<xsl:attribute name="value">
										<xsl:choose>
											<xsl:when test="MULTI-REQUIRED[@NAME='TITLE']/VALUE-EDITABLE and MULTI-REQUIRED[@NAME='TITLE']/VALUE-EDITABLE != ''">
												<xsl:value-of select="MULTI-REQUIRED[@NAME='TITLE']/VALUE-EDITABLE"/>
											</xsl:when>
											<xsl:when test="/H2G2/PARAMS/PARAM[NAME='s_memory_title']/VALUE">
												<xsl:value-of select="/H2G2/PARAMS/PARAM[NAME='s_memory_title']/VALUE"/>
											</xsl:when>
										</xsl:choose>
									</xsl:attribute>
								</input>
							</p>

						</div>

						<div id="memoryPanel2">
							<p>
								<label for="body">
									What happened?
									<em class="alert">
										<xsl:apply-templates select="MULTI-REQUIRED[@NAME='BODY']" mode="validate">
											<xsl:with-param name="msg">Please enter your memory text.</xsl:with-param>
											<xsl:with-param name="cancel" select="@CANCEL"/>
										</xsl:apply-templates>
									</em>
								</label>
							</p>
							<p>
								<textarea name="body" rows="8" cols="30" id="body" class="txtArea">
										<!-- 
										Need to make this box smaller if the embed media stuff is going to appear
										so it all first in the slider pane
										-->
										<xsl:if test="$typedarticle_embed ='yes' and ($typedarticle_embed_admin_only = 'no' or $test_IsAdminUser)">
											<xsl:attribute name="style">
												<xsl:text>height:120px;</xsl:text>
											</xsl:attribute>
										</xsl:if>
										<xsl:value-of select="MULTI-REQUIRED[@NAME='BODY']/VALUE-EDITABLE"/>
								</textarea>
							</p>

							<!--start embedded_mediasset_stuff -->
							<xsl:if test="$typedarticle_embed ='yes' and ($typedarticle_embed_admin_only = 'no' or $test_IsAdminUser)">
								<fieldset id="mediaassetFS">
									<input type="hidden" name="hasasset" id="hasasset" value="1"/>
									<input type="hidden" name="manualupload" id="manualupload" value="1"/>
									<input type="hidden" name="externallink" id="externallink" value="1"/>

									<xsl:choose>
										<!-- only let admin users edit media assets irrespective of settings -->
										<xsl:when test="/H2G2/MULTI-STAGE[@TYPE='TYPED-ARTICLE-EDIT' or @TYPE='TYPED-ARTICLE-EDIT-PREVIEW']">
											<xsl:variable name="s_ma_add" select="/H2G2/PARAMS/PARAM[NAME='s_ma_add']/VALUE"/>
											<xsl:choose>
												<xsl:when test="(MULTI-ELEMENT[@NAME='EXTERNALLINKURL']/VALUE-EDITABLE != '' and (not($s_ma_add) or $s_ma_add != 'yes')) or not($test_IsAdminUser)">
													<input type="hidden" name="externallinkurl" value="{MULTI-ELEMENT[@NAME='EXTERNALLINKURL']/VALUE-EDITABLE}"/>
													<input type="hidden" name="termsandconditions" value="1"/>

													<p>
														<label for="externallinkurl">Embed media</label>
														<xsl:value-of select="MULTI-ELEMENT[@NAME='EXTERNALLINKURL']/VALUE-EDITABLE"/>
													</p>
												</xsl:when>
												<xsl:otherwise>
													<xsl:if test="$typedarticle_embed_edit_add = 'yes'">
														<input type="hidden" name="s_ma_add" value="yes"/>
														<label for="externallinkurl">Embed media</label>
														<p>
															<input type="text" name="externallinkurl" id="externallinkurl" class="txtWide" maxlength="128">
																<xsl:attribute name="value">
																	<xsl:value-of select="MULTI-ELEMENT[@NAME='EXTERNALLINKURL']/VALUE-EDITABLE"/>
																</xsl:attribute>
															</input>
														</p>
														<xsl:if test="$typedarticle_embed_tc = 'yes'">
															<p>
																<input type="checkbox" name="termsandconditions" id="termsandconditions" value="1">
																	<xsl:if test="MULTI-ELEMENT[@NAME='TERMSANDCONDITIONS']/VALUE-EDITABLE = 1">
																		<xsl:attribute name="checked">checked</xsl:attribute>
																	</xsl:if>
																</input>
																<xsl:text> </xsl:text>
																<label for="termsandconditions">I have the rights etc</label>
															</p>
														</xsl:if>
													</xsl:if>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:when>
										<xsl:otherwise>
											<p>
												<label for="externallinkurl" class="bld">Embed media</label>
											</p>
											<p>
												<input type="text" name="externallinkurl" id="externallinkurl" maxlength="128" class="txt">
													<xsl:attribute name="value">
														<xsl:value-of select="MULTI-ELEMENT[@NAME='EXTERNALLINKURL']/VALUE-EDITABLE"/>
													</xsl:attribute>
												</input>
											</p>
											<xsl:if test="$typedarticle_embed_tc = 'yes'">
												<p>
													<input type="checkbox" name="termsandconditions" id="termsandconditions" value="1">
														<xsl:if test="MULTI-ELEMENT[@NAME='TERMSANDCONDITIONS']/VALUE-EDITABLE = 1">
															<xsl:attribute name="checked">checked</xsl:attribute>
														</xsl:if>
													</input>
													<xsl:text> </xsl:text>
													<label for="termsandconditions">I have the rights etc</label>
												</p>
											</xsl:if>
										</xsl:otherwise>
									</xsl:choose>
								</fieldset>
							</xsl:if>
							<!--end embedded_mediasset_stuff -->

						</div>

						<!-- Set up date variables start -->
						<xsl:variable name="dateValidationMessages">
							<xsl:apply-templates select="MULTI-REQUIRED[@NAME='STARTDATE']" mode="validate">
								<xsl:with-param name="msg">Please enter a valid start date.</xsl:with-param>
								<xsl:with-param name="cancel" select="@CANCEL"/>
							</xsl:apply-templates>
							<xsl:apply-templates select="MULTI-REQUIRED[@NAME='ENDDATE']" mode="validate">
								<xsl:with-param name="msg">Please enter a valid end date.</xsl:with-param>
								<xsl:with-param name="cancel" select="@CANCEL"/>
							</xsl:apply-templates>
							<xsl:apply-templates select="MULTI-REQUIRED[@NAME='STARTDAY']" mode="validate">
								<xsl:with-param name="msg">
									<xsl:value-of select="MULTI-REQUIRED[@NAME='STARTDAY']/ERRORS/ERROR[@TYPE='VALIDATION-ERROR-CUSTOM']/ERROR"/>.
								</xsl:with-param>
								<xsl:with-param name="cancel" select="@CANCEL"/>
							</xsl:apply-templates>
							<xsl:apply-templates select="MULTI-REQUIRED[@NAME='ENDDAY']" mode="validate">
								<xsl:with-param name="msg">
									<xsl:value-of select="MULTI-REQUIRED[@NAME='ENDDAY']/ERRORS/ERROR[@TYPE='VALIDATION-ERROR-CUSTOM']/ERROR"/>.
								</xsl:with-param>
								<xsl:with-param name="cancel" select="@CANCEL"/>
							</xsl:apply-templates>
						</xsl:variable>

						<xsl:variable name="datemode">
							<xsl:choose>
								<xsl:when test="/H2G2/PARAMS/PARAM[NAME='s_datemode']/VALUE">
									<xsl:value-of select="/H2G2/PARAMS/PARAM[NAME='s_datemode']/VALUE"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:variable name="date_range_type">
										<xsl:call-template name="GET_DATE_RANGE_TYPE">
											<xsl:with-param name="startdate" select="MULTI-REQUIRED[@NAME='STARTDATE']/VALUE-EDITABLE"/>
											<xsl:with-param name="startday" select="MULTI-REQUIRED[@NAME='STARTDAY']/VALUE-EDITABLE"/>
											<xsl:with-param name="startmonth" select="MULTI-REQUIRED[@NAME='STARTMONTH']/VALUE-EDITABLE"/>
											<xsl:with-param name="startyear" select="MULTI-REQUIRED[@NAME='STARTYEAR']/VALUE-EDITABLE"/>
											<xsl:with-param name="enddate" select="MULTI-REQUIRED[@NAME='ENDDATE']/VALUE-EDITABLE"/>
											<xsl:with-param name="endday" select="MULTI-REQUIRED[@NAME='ENDDAY']/VALUE-EDITABLE"/>
											<xsl:with-param name="endmonth" select="MULTI-REQUIRED[@NAME='ENDMONTH']/VALUE-EDITABLE"/>
											<xsl:with-param name="endyear" select="MULTI-REQUIRED[@NAME='ENDYEAR']/VALUE-EDITABLE"/>
											<xsl:with-param name="timeinterval" select="MULTI-REQUIRED[@NAME='TIMEINTERVAL']/VALUE-EDITABLE"/>
										</xsl:call-template>
									</xsl:variable>

									<xsl:choose>
										<xsl:when test="$date_range_type = 1">Specific</xsl:when>
										<xsl:when test="$date_range_type = 2">Daterange</xsl:when>
										<xsl:when test="$date_range_type = 3">Fuzzydate</xsl:when>
										<xsl:otherwise>
											<xsl:choose>
												<xsl:when test="/H2G2/MULTI-STAGE/@TYPE='TYPED-ARTICLE-EDIT' or /H2G2/MULTI-STAGE/@TYPE='TYPED-ARTICLE-EDIT-PREVIEW'">Nodate</xsl:when>
												<xsl:otherwise>Specific</xsl:otherwise>
												<!-- default to Specific -->
											</xsl:choose>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>

						<script type="text/javascript">
						<xsl:text disable-output-escaping="yes">
						// &lt;![CDATA[
						</xsl:text>

						<xsl:variable name="startDateString">
							<xsl:choose>
								<xsl:when test="MULTI-REQUIRED[@NAME='STARTDATE']/VALUE-EDITABLE != ''">
									<xsl:value-of select="MULTI-REQUIRED[@NAME='STARTDATE']/VALUE-EDITABLE"/>
								</xsl:when>
								<xsl:when test="MULTI-REQUIRED[@NAME='STARTDAY']/VALUE-EDITABLE and not(MULTI-REQUIRED[@NAME='STARTDAY']/VALUE-EDITABLE=0)">
									<xsl:value-of select="MULTI-REQUIRED[@NAME='STARTDAY']/VALUE-EDITABLE"/>
									<xsl:text>/</xsl:text>
									<xsl:value-of select="MULTI-REQUIRED[@NAME='STARTMONTH']/VALUE-EDITABLE"/>
									<xsl:text>/</xsl:text>
									<xsl:value-of select="MULTI-REQUIRED[@NAME='STARTYEAR']/VALUE-EDITABLE"/>
								</xsl:when>
								<xsl:when test="/H2G2/PARAMS/PARAM[NAME='s_memory_startdate']/VALUE">
									<xsl:value-of select="/H2G2/PARAMS/PARAM[NAME='s_memory_startdate']/VALUE"/>
								</xsl:when>
							</xsl:choose>
						</xsl:variable>

						<xsl:variable name="endDateString">
							<xsl:choose>
								<xsl:when test="MULTI-REQUIRED[@NAME='ENDDATE']/VALUE-EDITABLE != ''">
									<xsl:value-of select="MULTI-REQUIRED[@NAME='ENDDATE']/VALUE-EDITABLE"/>
								</xsl:when>
								<xsl:when test="MULTI-REQUIRED[@NAME='ENDDAY']/VALUE-EDITABLE and not(MULTI-REQUIRED[@NAME='ENDDAY']/VALUE-EDITABLE=0)">
									<xsl:value-of select="MULTI-REQUIRED[@NAME='ENDDAY']/VALUE-EDITABLE"/>
									<xsl:text>/</xsl:text>
									<xsl:value-of select="MULTI-REQUIRED[@NAME='ENDMONTH']/VALUE-EDITABLE"/>
									<xsl:text>/</xsl:text>
									<xsl:value-of select="MULTI-REQUIRED[@NAME='ENDYEAR']/VALUE-EDITABLE"/>
								</xsl:when>
								<xsl:when test="/H2G2/PARAMS/PARAM[NAME='s_memory_enddate']/VALUE">
									<xsl:value-of select="/H2G2/PARAMS/PARAM[NAME='s_memory_enddate']/VALUE"/>
								</xsl:when>
							</xsl:choose>
						</xsl:variable>

						<xsl:variable name="locationString">
							<xsl:if test="MULTI-ELEMENT[@NAME='LOCATION']/VALUE and MULTI-ELEMENT[@NAME='LOCATION']/VALUE != ''">
								<xsl:value-of select="MULTI-ELEMENT[@NAME='LOCATION']/VALUE"/>
							</xsl:if>
							<xsl:if test="MULTI-ELEMENT[@NAME='LOCATIONUSER']/VALUE-EDITABLE and MULTI-ELEMENT[@NAME='LOCATIONUSER']/VALUE-EDITABLE != ''">
								<xsl:text>,</xsl:text><xsl:value-of select="MULTI-ELEMENT[@NAME='LOCATIONUSER']/VALUE-EDITABLE"/>
							</xsl:if>
						</xsl:variable>							

						<xsl:text disable-output-escaping="yes">
						var jsDateMode = '</xsl:text><xsl:value-of select="$datemode" /><xsl:text disable-output-escaping="yes">';</xsl:text>
						<xsl:text disable-output-escaping="yes">
						var jsStartDate = '</xsl:text><xsl:value-of select="$startDateString" /><xsl:text disable-output-escaping="yes">';</xsl:text>
						<xsl:text disable-output-escaping="yes">
						var jsLocation = '</xsl:text><xsl:value-of select="$locationString" /><xsl:text disable-output-escaping="yes">';</xsl:text>
						<xsl:text disable-output-escaping="yes">
						var jsEndDate = '</xsl:text><xsl:value-of select="$endDateString" /><xsl:text disable-output-escaping="yes">';
						//]]&gt;
						</xsl:text>
						</script>
						<!-- Set up date variables end -->

						<div id="memoryPanel3">
							<noscript>
								<fieldset id="dateSelector">
									<p>
										<label>
										Date of memory
										<xsl:if test="$dateValidationMessages">
											<em class="alert">
												<xsl:value-of select="$dateValidationMessages"/>
											</em>
										</xsl:if>
										</label>
									</p>
									<p>
										<input type="radio" name="s_datemode" id="s_datemodeSpecific" class="radio" value="Specific" onclick="javascript:datefieldsWriteTypedArticle('Specific')">
											<xsl:if test="$datemode='Specific' or not(/H2G2/PARAMS/PARAM[NAME='s_datemode'])">
												<xsl:attribute name="checked">checked</xsl:attribute>
											</xsl:if>
										</input>
										<xsl:text> </xsl:text>
										<label for="s_datemodeSpecific" class="radioLabel">My memory is of a specific date (e.g. 14/10/1986)</label>
									</p>
									<p>
										<input type="radio" name="s_datemode" id="s_datemodeDaterange" class="radio" value="Daterange" onclick="javascript:datefieldsWriteTypedArticle('Daterange')">
											<xsl:if test="$datemode='Daterange'">
												<xsl:attribute name="checked">checked</xsl:attribute>
											</xsl:if>
										</input>
										<xsl:text> </xsl:text>
										<label for="s_datemodeDaterange" class="radioLabel">My memory is of a specific date range (e.g. 10/04/1972 to 16/04/1973)</label>
									</p>
									<p>
										<input type="radio" name="s_datemode" id="s_datemodeFuzzydate" class="radio" value="Fuzzydate" onclick="javascript:datefieldsWriteTypedArticle('Fuzzydate')">
											<xsl:if test="$datemode='Fuzzydate'">
												<xsl:attribute name="checked">checked</xsl:attribute>
											</xsl:if>
										</input>
										<xsl:text> </xsl:text>
										<label for="s_datemodeFuzzydate" class="radioLabel">My memory is of an approximate date range (e.g. 10/04/1972 to 16/04/1973 for a duration of 10 days)</label>
									</p>
									<p>
										<input type="radio" name="s_datemode" id="s_datemodeNodate" class="radio" value="Nodate" onclick="javascript:datefieldsWriteTypedArticle('Nodate')">
											<xsl:if test="$datemode='Nodate'">
												<xsl:attribute name="checked">checked</xsl:attribute>
											</xsl:if>
										</input>
										<xsl:text> </xsl:text>
										<label for="s_datemodeNodate" class="radioLabel">I don't know the date of my memory</label>
									</p>

									<p class="rAlign">
										<input type="submit" name="acreatecancelled" value="Enter dates &gt;" class="submit"/>
									</p>

									<xsl:choose>
										<xsl:when test="$datemode='Nodate'">
											<div id="datefieldsNodate" class="noscript">
												<xsl:call-template name="DATEFIELDS_NODATE"/>
											</div>
										</xsl:when>
										<xsl:when test="$datemode='Fuzzydate'">
											<div id="datefieldsDaterange" class="noscript">
												<xsl:call-template name="DATEFIELDS_FUZZYDATE">
													<xsl:with-param name="startdate" select="MULTI-REQUIRED[@NAME='STARTDATE']/VALUE-EDITABLE"/>
													<xsl:with-param name="startday" select="MULTI-REQUIRED[@NAME='STARTDAY']/VALUE-EDITABLE"/>
													<xsl:with-param name="startmonth" select="MULTI-REQUIRED[@NAME='STARTMONTH']/VALUE-EDITABLE"/>
													<xsl:with-param name="startyear" select="MULTI-REQUIRED[@NAME='STARTYEAR']/VALUE-EDITABLE"/>
													<xsl:with-param name="endate" select="MULTI-REQUIRED[@NAME='ENDDATE']/VALUE-EDITABLE"/>
													<xsl:with-param name="endday" select="MULTI-REQUIRED[@NAME='ENDDAY']/VALUE-EDITABLE"/>
													<xsl:with-param name="endmonth" select="MULTI-REQUIRED[@NAME='ENDMONTH']/VALUE-EDITABLE"/>
													<xsl:with-param name="endyear" select="MULTI-REQUIRED[@NAME='ENDYEAR']/VALUE-EDITABLE"/>
													<xsl:with-param name="timeinterval" select="MULTI-REQUIRED[@NAME='TIMEINTERVAL']/VALUE-EDITABLE"/>
													<xsl:with-param name="validationMsg" select="$dateValidationMessages"/>
												</xsl:call-template>
											</div>
										</xsl:when>
										<xsl:when test="$datemode='Daterange'">
											<div id="datefieldsDaterange" class="noscript">
												<xsl:call-template name="DATEFIELDS_DATERANGE">
													<xsl:with-param name="startdate" select="MULTI-REQUIRED[@NAME='STARTDATE']/VALUE-EDITABLE"/>
													<xsl:with-param name="startday" select="MULTI-REQUIRED[@NAME='STARTDAY']/VALUE-EDITABLE"/>
													<xsl:with-param name="startmonth" select="MULTI-REQUIRED[@NAME='STARTMONTH']/VALUE-EDITABLE"/>
													<xsl:with-param name="startyear" select="MULTI-REQUIRED[@NAME='STARTYEAR']/VALUE-EDITABLE"/>
													<xsl:with-param name="enddate" select="MULTI-REQUIRED[@NAME='ENDDATE']/VALUE-EDITABLE"/>
													<xsl:with-param name="endday" select="MULTI-REQUIRED[@NAME='ENDDAY']/VALUE-EDITABLE"/>
													<xsl:with-param name="endmonth" select="MULTI-REQUIRED[@NAME='ENDMONTH']/VALUE-EDITABLE"/>
													<xsl:with-param name="endyear" select="MULTI-REQUIRED[@NAME='ENDYEAR']/VALUE-EDITABLE"/>
													<xsl:with-param name="datesearchtype">no</xsl:with-param>
													<xsl:with-param name="validationMsg" select="$dateValidationMessages"/>
												</xsl:call-template>
											</div>
										</xsl:when>
										<xsl:otherwise>
											<div id="datefieldsSpecific" class="noscript">
												<xsl:call-template name="DATEFIELDS_SPECIFIC">
													<xsl:with-param name="startdate" select="MULTI-REQUIRED[@NAME='STARTDATE']/VALUE-EDITABLE"/>
													<xsl:with-param name="startday" select="MULTI-REQUIRED[@NAME='STARTDAY']/VALUE-EDITABLE"/>
													<xsl:with-param name="startmonth" select="MULTI-REQUIRED[@NAME='STARTMONTH']/VALUE-EDITABLE"/>
													<xsl:with-param name="startyear" select="MULTI-REQUIRED[@NAME='STARTYEAR']/VALUE-EDITABLE"/>
													<xsl:with-param name="validationMsg" select="$dateValidationMessages"/>
												</xsl:call-template>
											</div>
										</xsl:otherwise>
									</xsl:choose>

								</fieldset>
							</noscript>
						</div>

						<div id="memoryPanel4">
							<fieldset>
								<p>
									<label>Where did this happen?
									<em class="alert">
										<xsl:apply-templates select="MULTI-ELEMENT[@NAME='LOCATION']" mode="validate">
											<xsl:with-param name="msg">Please provide a location.</xsl:with-param>
											<xsl:with-param name="cancel" select="@CANCEL"/>
										</xsl:apply-templates>
									</em>
									</label>
								</p>

								<div id="locationNonJSPanel">
									<p>
										If you were in the UK, select the BBC site relevant to the location of your memory - see more in
										Memoryshare FAQs.
									</p>
									<xsl:variable name="locationSelectedValue">
										<xsl:choose>
											<xsl:when test="MULTI-ELEMENT[@NAME='LOCATION']/VALUE and MULTI-ELEMENT[@NAME='LOCATION']/VALUE != ''">
												<xsl:value-of select="MULTI-ELEMENT[@NAME='LOCATION']/VALUE" />
											</xsl:when>
											<xsl:when test="/H2G2/PARAMS/PARAM[NAME='s_memory_locationuk']/VALUE and /H2G2/PARAMS/PARAM[NAME='s_memory_locationuk']/VALUE != ''">
												<xsl:call-template name="translateQueryStringLocationToRadioButton">
													<xsl:with-param name="input" select="/H2G2/PARAMS/PARAM[NAME='s_memory_locationuk']/VALUE" />
												</xsl:call-template>
											</xsl:when>
											<xsl:when test="/H2G2/PARAMS/PARAM[NAME='s_memory_locationnonuk']/VALUE and /H2G2/PARAMS/PARAM[NAME='s_memory_locationnonuk']/VALUE != ''">
												<xsl:text>_location-Non-Uk</xsl:text>
											</xsl:when>
										</xsl:choose>
									</xsl:variable>
									<xsl:call-template name="GENERATE_COMBINED_LOCATION_RADIOS_NON_FLASH_CONTENT">
										<xsl:with-param name="selectedValue" select="$locationSelectedValue"/>
									</xsl:call-template>
									<p>
										<label for="locationuser">Tell us more (e.g France, Paris or England, Portsmouth)</label>
										<input type="text" name="locationuser" id="locationuser">
											<xsl:attribute name="value">
												<xsl:choose>
													<xsl:when test="MULTI-ELEMENT[@NAME='LOCATIONUSER']/VALUE-EDITABLE and MULTI-ELEMENT[@NAME='LOCATIONUSER']/VALUE-EDITABLE != ''">
														<xsl:value-of select="MULTI-ELEMENT[@NAME='LOCATIONUSER']/VALUE-EDITABLE"/>
													</xsl:when>
													<xsl:when test="/H2G2/PARAMS/PARAM[NAME='s_memory_locationnonuk']/VALUE and /H2G2/PARAMS/PARAM[NAME='s_memory_locationnonuk']/VALUE != ''">
														<xsl:value-of select="/H2G2/PARAMS/PARAM[NAME='s_memory_locationnonuk']/VALUE"/>
													</xsl:when>
												</xsl:choose>
											</xsl:attribute>
										</input>
									</p>
								</div>

							</fieldset>
						</div>

						<div id="memoryPanel5">
							<fieldset>
								<p>
									<label for="keywords">
										<strong>Keywords</strong>
										<em class="alert">
											<xsl:apply-templates select="MULTI-ELEMENT[@NAME='KEYWORDS']" mode="validate">
												<xsl:with-param name="msg">Please enter one or more keywords.</xsl:with-param>
												<xsl:with-param name="cancel" select="@CANCEL"/>
											</xsl:apply-templates>
										</em>
									</label>
								</p>
								<p>
									Keywords may relate to a place or event or activity. You can add one or more keywords, separating them with a <xsl:value-of select="$keyword_sep_name"/> e.g. Glastonbury<xsl:value-of select="$keyword_sep_char"/> festival<xsl:value-of select="$keyword_sep_char"/> rain.
								</p>
								<p>
									<input type="text" class="txt txtLong" name="keywords" id="keywords">
										<xsl:attribute name="value">
											<xsl:choose>
												<xsl:when test="MULTI-ELEMENT[@NAME='KEYWORDS']/VALUE-EDITABLE and MULTI-ELEMENT[@NAME='KEYWORDS']/VALUE-EDITABLE != ''">
													<xsl:value-of select="MULTI-ELEMENT[@NAME='KEYWORDS']/VALUE-EDITABLE"/>
													<xsl:text>, </xsl:text>
												</xsl:when>
												<xsl:when test="/H2G2/PARAMS/PARAM[NAME='s_memory_keywords']/VALUE and /H2G2/PARAMS/PARAM[NAME='s_memory_keywords']/VALUE != ''">
													<xsl:value-of select="/H2G2/PARAMS/PARAM[NAME='s_memory_keywords']/VALUE"/>
													<xsl:text>, </xsl:text>
												</xsl:when>
											</xsl:choose>
										</xsl:attribute>
									</input>
									<!--textarea name="keywords" id="keywords" rows="4" cols="30">
										<xsl:value-of select="MULTI-ELEMENT[@NAME='KEYWORDS']/VALUE-EDITABLE"/>
									</textarea-->
								</p>
							</fieldset>
						</div>

						<div id="memoryPanel6">
							<p>
								<label>
									You can now publish your memory, or you can preview it
									and go back to edit any mistakes you might have made.
								</label>
							</p>
							<p id="pg-publish">
								<span class="wrapper">
								<xsl:choose>
									<xsl:when test="/H2G2/MULTI-STAGE/@TYPE='TYPED-ARTICLE-EDIT' or /H2G2/MULTI-STAGE/@TYPE='TYPED-ARTICLE-EDIT-PREVIEW'">
										<input type="image" src="/memoryshare/assets/images/update-memory-button1.png" name="aupdate" class="update-memory-button" alt="Update"/>
									</xsl:when>
									<xsl:otherwise>
										<input type="image" src="/memoryshare/assets/images/publish-memory-button1.png" name="acreate" class="publish-memory-button" alt="Publish"/>
									</xsl:otherwise>
								</xsl:choose>
								</span>
							</p>
							<noscript>
								<p>
									<input type="image" name="apreview" src="/memoryshare/assets/images/preview-memory-button.png" alt="Preview" />
								</p>
								<p>
									<a id="cancel-memory" href="{$articlesearchroot}"><span><xsl:comment> </xsl:comment></span>Cancel Memory</a>
								</p>
							</noscript>							
						</div>
					</div>
				</div>
				<div id="addMemoryBoxFooter"><xsl:comment> add-memory-footer </xsl:comment></div>
			</div>

			<!--div>
				<div>
					<script type="text/javascript">
						<xsl:text disable-output-escaping="yes">
				// &lt;![CDATA[
				var articlesearchroot = '</xsl:text>
						<xsl:value-of select="$articlesearchroot"/>
						<xsl:text disable-output-escaping="yes">';
				document.write('&lt;input type="button" name="acancel" value="Cancel" class="submit" onclick="document.location=\'' + articlesearchroot + '\'"/&gt; ');
				//]]&gt;
				</xsl:text>
					</script>
					<noscript>
						<p>
							<a href="{$articlesearchroot}">Cancel</a>
						</p>
					</noscript>
					<input type="submit" name="apreview" value="Preview" />
					<xsl:text> </xsl:text>
					<xsl:choose>
						<xsl:when test="/H2G2/MULTI-STAGE/@TYPE='TYPED-ARTICLE-EDIT' or /H2G2/MULTI-STAGE/@TYPE='TYPED-ARTICLE-EDIT-PREVIEW'">
							<input type="submit" name="aupdate" value="Publish" />
						</xsl:when>
						<xsl:otherwise>
							<input type="submit" name="acreate" value="Publish" />
						</xsl:otherwise>
					</xsl:choose>
				</div>
			</div-->
		</div>
		<div id="ms-std-footer"><xsl:comment> ms-std-footer </xsl:comment></div>
	</div>

	<script type="text/javascript">
		<xsl:text disable-output-escaping="yes">
				// &lt;![CDATA[

				jQuery(document).ready(function () {					
					initAddMemory();
				});

				//]]&gt;
		</xsl:text>
	</script>	
	
</xsl:template>

<xsl:template name="translateQueryStringLocationToRadioButton">
	<xsl:param name="input" />
	<xsl:choose>
		<xsl:when test="$input='Beds Herts and Bucks'">
			<xsl:text>_location-Beds Herts and Bucks,Beds Herts and Bucks,_location-Bedfordshire Hertfordshire and Buckinghamshire,Bedfordshire Hertfordshire and Buckinghamshire,_location-Bedfordshire,Bedfordshire,_location-Hertfordshire,Hertfordshire,_location-Buckinghamshire,Buckinghamshire,_location-Beds,Beds,_location-Herts,Herts,_location-Bucks,Bucks</xsl:text>
		</xsl:when>
		<xsl:when test="$input='Berkshire'">
			<xsl:text>_location-Berkshire,Berkshire,_location-Berks,Berks</xsl:text>
		</xsl:when>
		<xsl:when test="$input='Birmingham'">
			<xsl:text>_location-Birmingham,Birmingham</xsl:text>
		</xsl:when>
		<xsl:when test="$input='Black Country'">
			<xsl:text>_location-Black Country,Black Country</xsl:text>
		</xsl:when>
		<xsl:when test="$input='Bradford and W Yorks'">
			<xsl:text>_location-Bradford and W Yorks,Bradford and W Yorks,_location-Bradford and West Yorkshire,Bradford and West Yorkshire,_location-Bradford,Bradford,_location-Yorkshire,Yorkshire,_location-West Yorkshire,West Yorkshire,_location-Bradford and West Yorkshire,Bradford and West Yorkshire</xsl:text>
		</xsl:when>
		<xsl:when test="$input='Bristol'">
			<xsl:text>_location-Bristol,Bristol</xsl:text>
		</xsl:when>
		<xsl:when test="$input='Cambridgeshire'">
			<xsl:text>_location-Cambridgeshire,Cambridgeshire,_location-Cambs,Cambs,_location-Cambridge,Cambridge</xsl:text>
		</xsl:when>
		<xsl:when test="$input='Cornwall'">
			<xsl:text>_location-Cornwall,Cornwall</xsl:text>
		</xsl:when>
		<xsl:when test="$input='Coventry and Warks'">
			<xsl:text>_location-Coventry and Warks,Coventry and Warks,_location-Warwickshire,Warwickshire,_location-Coventry,Coventry,_location-Coventry and Warwickshire,Coventry and Warwickshire,_location-Coventry and Warks,Coventry and Warks</xsl:text>
		</xsl:when>
		<xsl:when test="$input='Cumbria'">
			<xsl:text>_location-Cumbria,Cumbria</xsl:text>
		</xsl:when>
		<xsl:when test="$input='Derby'">
			<xsl:text>_location-Derby,Derby,_location-Derbyshire,Derbyshire</xsl:text>
		</xsl:when>
		<xsl:when test="$input='Devon'">
			<xsl:text>_location-Devon,Devon</xsl:text>
		</xsl:when>
		<xsl:when test="$input='Dorset'">
			<xsl:text>_location-Dorset,Dorset</xsl:text>
		</xsl:when>
		<xsl:when test="$input='Essex'">
			<xsl:text>_location-Essex,Essex</xsl:text>
		</xsl:when>
		<xsl:when test="$input='Gloucestershire'">
			<xsl:text>_location-Gloucestershire,Gloucestershire,_location-Gloucester,Gloucester</xsl:text>
		</xsl:when>
		<xsl:when test="$input='Hampshire'">
			<xsl:text>_location-Hampshire,Hampshire,_location-Hants,Hants</xsl:text>
		</xsl:when>
		<xsl:when test="$input='Hereford and Worcs'">
			<xsl:text>_location-Hereford and Worcs,Hereford and Worcs,_location-Hereford,Hereford,_location-Hereford and Worcs,Hereford and Worcs,_location-Hereford and Worcestershire,Hereford and Worcestershire,_location-Worcestershire,Worcestershire,_location-Worcs,Worcs</xsl:text>
		</xsl:when>
		<xsl:when test="$input='Humber'">
			<xsl:text>_location-Humber,Humber</xsl:text>
		</xsl:when>
		<xsl:when test="$input='Kent'">
			<xsl:text>_location-Kent,Kent</xsl:text>
		</xsl:when>
		<xsl:when test="$input='Lancashire'">
			<xsl:text>_location-Lancashire,Lancashire,_location-Lancs,Lancs</xsl:text>
		</xsl:when>
		<xsl:when test="$input='Leeds'">
			<xsl:text>_location-Leeds,Leeds</xsl:text>
		</xsl:when>
		<xsl:when test="$input='Leicester'">
			<xsl:text>_location-Leicester,Leicester,_location-Leics,Leics</xsl:text>
		</xsl:when>
		<xsl:when test="$input='Lincolnshire'">
			<xsl:text>_location-Lincolnshire,Lincolnshire,_location-Lincs,Lincs,_location-Lincoln,Lincoln</xsl:text>
		</xsl:when>
		<xsl:when test="$input='Liverpool'">
			<xsl:text>_location-Liverpool,Liverpool,_location-Merseyside,Merseyside</xsl:text>
		</xsl:when>
		<xsl:when test="$input='London'">
			<xsl:text>_location-London,London</xsl:text>
		</xsl:when>
		<xsl:when test="$input='Manchester'">
			<xsl:text>_location-Manchester,Manchester,_location-Man,Man</xsl:text>
		</xsl:when>
		<xsl:when test="$input='Norfolk'">
			<xsl:text>_location-Norfolk,Norfolk</xsl:text>
		</xsl:when>
		<xsl:when test="$input='Northamptonshire'">
			<xsl:text>_location-Northamptonshire,Northamptonshire</xsl:text>
		</xsl:when>
		<xsl:when test="$input='North Yorkshire'">
			<xsl:text>_location-North Yorkshire,North Yorkshire,_location-North Yorks,North Yorks,_location-Yorks,Yorks,_location-Yorkshire,Yorkshire</xsl:text>
		</xsl:when>
		<xsl:when test="$input='Nottingham'">
			<xsl:text>_location-Nottingham,Nottingham,_location-Notts,Notts</xsl:text>
		</xsl:when>
		<xsl:when test="$input='Oxford'">
			<xsl:text>_location-Oxford,Oxford</xsl:text>
		</xsl:when>
		<xsl:when test="$input='Shropshire'">
			<xsl:text>_location-Shropshire,Shropshire,_location-Shrops,Shrops</xsl:text>
		</xsl:when>
		<xsl:when test="$input='Somerset'">
			<xsl:text>_location-Somerset,Somerset</xsl:text>
		</xsl:when>
		<xsl:when test="$input='South Yorkshire'">
			<xsl:text>_location-South Yorkshire,South Yorkshire,_location-Yorks,Yorks,_location-Yorkshire,Yorkshire</xsl:text>
		</xsl:when>
		<xsl:when test="$input='Southern Counties'">
			<xsl:text>_location-Southern Counties,Southern Counties</xsl:text>
		</xsl:when>
		<xsl:when test="$input='Stoke and Staffs'">
			<xsl:text>_location-Stoke and Staffs,Stoke and Staffs,_location-Stoke and Staffordshire,Stoke and Staffordshire,_location-Stoke,Stoke,_location-Staffordshire,Staffordshire</xsl:text>
		</xsl:when>
		<xsl:when test="$input='Suffolk'">
			<xsl:text>_location-Suffolk,Suffolk</xsl:text>
		</xsl:when>
		<xsl:when test="$input='Surrey and Sussex'">
			<xsl:text>_location-Surrey and Sussex,Surrey and Sussex,_location-Surrey,Surrey,_location-Sussex,Sussex,_location-Surrey and Sussex,Surrey and Sussex</xsl:text>
		</xsl:when>
		<xsl:when test="$input='Tees'">
			<xsl:text>_location-Tees,Tees</xsl:text>
		</xsl:when>
		<xsl:when test="$input='Tyne'">
			<xsl:text>_location-Tyne,Tyne</xsl:text>
		</xsl:when>
		<xsl:when test="$input='Wear'">
			<xsl:text>_location-Wear,Wear</xsl:text>
		</xsl:when>
		<xsl:when test="$input='Wiltshire'">
			<xsl:text>_location-Wiltshire,Wiltshire</xsl:text>
		</xsl:when>
		<xsl:when test="$input='Highlands and Islands'">
			<xsl:text>_location-Highlands and Islands,Highlands and Islands,_location-Highlands,Highlands,_location-Scotland,Scotland</xsl:text>
		</xsl:when>
		<xsl:when test="$input='North East Scotland'">
			<xsl:text>_location-North East Scotland,North East Scotland,_location-Scotland,Scotland</xsl:text>
		</xsl:when>
		<xsl:when test="$input='Tayside and Central Scotland'">
			<xsl:text>_location-Tayside and Central Scotland,Tayside and Central Scotland,_location-Tayside,Tayside,_location-Central Scotland,Central Scotland,_location-Scotland,Scotland</xsl:text>
		</xsl:when>
		<xsl:when test="$input='Glasgow and West of Scotland'">
			<xsl:text>_location-Glasgow and West of Scotland,Glasgow and West of Scotland,_location-Glasgow,Glasgow,_location-West of Scotland,West of Scotland,_location-Scotland,Scotland</xsl:text>
		</xsl:when>
		<xsl:when test="$input='Edinburgh and East of Scotland'">
			<xsl:text>_location-Edinburgh and East of Scotland,Edinburgh and East of Scotland,_location-Edinburgh,Edinburgh,_location-East of Scotland,East of Scotland,_location-Scotland,Scotland</xsl:text>
		</xsl:when>
		<xsl:when test="$input='South Scotland'">
			<xsl:text>_location-South Scotland,South Scotland,_location-Scotland,Scotland</xsl:text>
		</xsl:when>
		<xsl:when test="$input='North East Wales'">
			<xsl:text>_location-North East Wales,North East Wales,_location-Wales,Wales</xsl:text>
		</xsl:when>
		<xsl:when test="$input='North West Wales'">
			<xsl:text>_location-North West Wales,North West Wales,_location-Wales,Wales</xsl:text>
		</xsl:when>
		<xsl:when test="$input='Mid Wales'">
			<xsl:text>_location-Mid Wales,Mid Wales,_location-Wales,Wales</xsl:text>
		</xsl:when>
		<xsl:when test="$input='South East Wales'">
			<xsl:text>_location-South East Wales,South East Wales,_location-Wales,Wales</xsl:text>
		</xsl:when>
		<xsl:when test="$input='South West Wales'">
			<xsl:text>_location-South West Wales,South West Wales,_location-Wales,Wales</xsl:text>
		</xsl:when>
		<xsl:when test="$input='Gogledd Orllewin'">
			<xsl:text>_location-Gogledd Orllewin,Gogledd Orllewin,_location-Cymru,Cymru</xsl:text>
		</xsl:when>
		<xsl:when test="$input='Gogledd Ddwyrain'">
			<xsl:text>_location-Gogledd Ddwyrain,Gogledd Ddwyrain,_location-Cymru,Cymru</xsl:text>
		</xsl:when>
		<xsl:when test="$input='Canolbarth'">
			<xsl:text>_location-Canolbarth,Canolbarth,_location-Cymru,Cymru</xsl:text>
		</xsl:when>
		<xsl:when test="$input='De Orllewin'">
			<xsl:text>_location-De Orllewin,De Orllewin,_location-Cymru,Cymru</xsl:text>
		</xsl:when>
		<xsl:when test="$input='De Ddwyrain'">
			<xsl:text>_location-De Ddwyrain,De Ddwyrain,_location-Cymru,Cymru</xsl:text>
		</xsl:when>
		<xsl:when test="$input='Guernsey'">
			<xsl:text>_location-Guernsey,Guernsey,_location-Channel Islands,Channel Islands</xsl:text>
		</xsl:when>
		<xsl:when test="$input='Jersey'">
			<xsl:text>_location-Jersey,Jersey,_location-Channel Islands,Channel Islands</xsl:text>
		</xsl:when>
		<xsl:when test="$input='Isle of Man'">
			<xsl:text>_location-Isle of Man,Isle of Man</xsl:text>
		</xsl:when>
		<xsl:when test="$input='Northern Ireland'">
			<xsl:text>_location-Northern Ireland,Northern Ireland</xsl:text>
		</xsl:when>
	</xsl:choose>	
</xsl:template>
	
<!-- 
#############################################################
EDITORIAL ARTICLE FORM
#############################################################
-->
<!-- form used for creating an editorial article -->
<!--						
This page is for editors to set up article to pull in a dynamic list.
The article will not have any comments or ratings.
The article will be status 1 so will not appear on your members page
-->
<xsl:template name="EDITORIAL_ARTICLE_FORM">
	<!-- DEBUG -->
	<xsl:call-template name="TRACE">
	<xsl:with-param name="message">EDITORIAL_ARTICLE_FORM</xsl:with-param>
	<xsl:with-param name="pagename">typedarticlepage_templates.xsl</xsl:with-param>
	</xsl:call-template>
	<!-- DEBUG -->
	
	<xsl:apply-templates select="/H2G2/MULTI-STAGE/MULTI-REQUIRED/ERRORS/ERROR | /H2G2/MULTI-STAGE/MULTI-ELEMENT/ERRORS/ERROR" mode="c_typedarticle"/>
				
	<input type="hidden" name="_msxml" value="{$editorial_article_fields}"/>
	
	<!--[FIXME: do we need this?]
	<xsl:if test="/H2G2/MULTI-STAGE/@TYPE='TYPED-ARTICLE-PREVIEW' or /H2G2/MULTI-STAGE[@TYPE='TYPED-ARTICLE-EDIT-PREVIEW'] or /H2G2/MULTI-STAGE[@TYPE='TYPED-ARTICLE-EDIT']">
		<xsl:attribute name="class">mainbodysec createarticle</xsl:attribute>
	</xsl:if>
	-->
	
	<!-- form -->
	<div id="topPage">
		<div class="innerWide">
			<div id="shortDescForm">
				<h2>Editorial Article</h2>									
				<p>
					<xsl:apply-templates select="/H2G2/MULTI-STAGE" mode="errors"/>
				</p>

				<label for="title" class="bld">
					title
					<xsl:if test="MULTI-REQUIRED[@NAME='TITLE']/ERRORS/ERROR/@TYPE='VALIDATION-ERROR-EMPTY'">
						<em class="alert">Please enter a title</em>
					</xsl:if>
				</label><br/>
				<input type="text" name="TITLE" id="title" maxlength="{$maxcharacters_textinput_value}">
					<xsl:attribute name="value">
						<xsl:value-of select="MULTI-REQUIRED[@NAME='TITLE']/VALUE-EDITABLE"/>
					</xsl:attribute>
				</input><br/>

				<label for="introtext" class="bld">Intro Text</label><br/>
				<input type="text" name="INTROTEXT" id="introtext">
					<xsl:attribute name="value">
						<xsl:value-of select="MULTI-ELEMENT[@NAME='INTROTEXT']/VALUE-EDITABLE"/>
					</xsl:attribute>
				</input><br/>

				<label for="description" class="bld">
					Body
					<xsl:if test="MULTI-REQUIRED[@NAME='BODY']/ERRORS/ERROR/@TYPE='VALIDATION-ERROR-EMPTY'">
						<em class="alert">Please enter your article text</em>
					</xsl:if>
				</label><br/>
				<textarea name="body" rows="20" id="description">
					<xsl:value-of select="MULTI-REQUIRED[@NAME='BODY']/VALUE-EDITABLE"/>
				</textarea>

				<div class="submitRow">
					<xsl:call-template name="SUBMIT_BUTTONS" />
				</div>
			</div>
		</div>
	</div>
</xsl:template>


<xsl:template name="AUTO_HIDDEN_FIELDS">
	<xsl:param name="keyword"/>
	<xsl:param name="visibletag"/>
	
	<!--[FIXME: take out this guard?]
	<xsl:if test="$client_keyword != $vanilla_client_keyword">
	-->
		<xsl:choose>
			<!-- when in edit mode echo back the article's client keyword, if any.
				 otherwise use the viewing users client
			-->
			<xsl:when test="/H2G2/MULTI-STAGE/@TYPE='TYPED-ARTICLE-EDIT' or /H2G2/MULTI-STAGE/@TYPE='TYPED-ARTICLE-EDIT-PREVIEW'">
				<input type="hidden" name="client" value="{/H2G2/MULTI-STAGE/MULTI-ELEMENT[@NAME='CLIENT']/VALUE-EDITABLE}"/>
				<xsl:if test="$typedarticle_visibletag = 'yes'">
					<input type="hidden" name="visibleclient" value="{/H2G2/MULTI-STAGE/MULTI-ELEMENT[@NAME='VISIBLECLIENT']/VALUE-EDITABLE}"/>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<input type="hidden" name="client" value="{$keyword}"/>
				<xsl:if test="$typedarticle_visibletag = 'yes'">
					<input type="hidden" name="visibleclient" value="{$visibletag}"/>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	<!--[FIXME: take out this guard?]
	</xsl:if>
	-->
</xsl:template>

<!-- 
#############################################################
SUBMIT BUTTONS
#############################################################
-->
<!-- preview, create and edit buttons -->
<xsl:template name="SUBMIT_BUTTONS">
	<xsl:apply-templates select="." mode="t_articlepreviewbutton" />
	<xsl:apply-templates select="." mode="c_articleeditbutton"/>
	<xsl:apply-templates select="." mode="c_articlecreatebutton"/>

	<!-- force user to preview before submitting by only presenting submit button when previewing and when no errors -->
	<!--[FIXME: not needed?]
	<xsl:if test="/H2G2/MULTI-STAGE/@TYPE='TYPED-ARTICLE-PREVIEW' or /H2G2/MULTI-STAGE/@TYPE='TYPED-ARTICLE-EDIT-PREVIEW' and not(*/ERRORS)">
		<xsl:apply-templates select="." mode="c_articleeditbutton"/>
		<xsl:apply-templates select="." mode="c_articlecreatebutton"/>
	</xsl:if>
	-->
</xsl:template>

<!-- submit buttons attributes -->
<xsl:attribute-set name="mMULTI-STAGE_r_articlecreatebutton">
	<xsl:attribute name="type">submit</xsl:attribute>
	<xsl:attribute name="value">publish</xsl:attribute>
	<xsl:attribute name="class">inputpre</xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="mMULTI-STAGE_t_articlepreviewbutton">
	<xsl:attribute name="type">submit</xsl:attribute>
	<xsl:attribute name="value">preview</xsl:attribute>
	<xsl:attribute name="class">inputpre</xsl:attribute>
</xsl:attribute-set>
	
<xsl:attribute-set name="mMULTI-STAGE_r_articleeditbutton">
	<xsl:attribute name="type">submit</xsl:attribute>
	<xsl:attribute name="value">publish</xsl:attribute>
	<xsl:attribute name="class">inputpre</xsl:attribute>
</xsl:attribute-set>

<!-- max characters -->
<xsl:variable name="maxcharacters_textinput_value">56</xsl:variable>
<xsl:template name="maxcharacters_textinput_text">
	<div class="inputinfo">56 characters max</div>
</xsl:template>
<xsl:template name="maxcharacters_textinput_text2">
	<div class="inputinfo2">56 characters max</div>
</xsl:template>


<!-- VALIDATION -->
<xsl:template match="MULTI-REQUIRED | MULTI-ELEMENT" mode="validate">
	<xsl:param name="msg"/>
	<xsl:param name="cancel"/>

	<xsl:if test="not($cancel='YES')">
		<xsl:if test="ERRORS/ERROR/@TYPE">
			<xsl:value-of select="$msg"/>
			<xsl:text> </xsl:text>
		</xsl:if>
	</xsl:if>
</xsl:template>

	<xsl:template match="MULTI-STAGE" mode="c_article">		
		<form method="post" action="{$root}TypedArticle" xsl:use-attribute-sets="fMULTI-STAGE_c_article" id="typedArticleForm">
			<div>
			<!--input type="hidden" name="skin" value="purexml"/-->
			<xsl:if test="@TYPE='TYPED-ARTICLE-EDIT' or @TYPE='TYPED-ARTICLE-EDIT-PREVIEW'">
				<input type="hidden" name="s_typedarticle" value="edit"/>
			</xsl:if>
			<xsl:choose>
				<xsl:when test="@TYPE='TYPED-ARTICLE-CREATE' or @TYPE='TYPED-ARTICLE-PREVIEW'">
					<!--input type="hidden" name="type" value="{MULTI-REQUIRED[@NAME='TYPE']/VALUE}"/-->
					<input type="hidden" name="_msstage" value="{@STAGE}"/>
					<xsl:apply-templates select="." mode="r_article"/>
				</xsl:when>
				<xsl:when test="@TYPE='TYPED-ARTICLE-EDIT' or @TYPE='TYPED-ARTICLE-EDIT-PREVIEW'">
					<!--xsl:choose>
							<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_change']/VALUE=1">
								<input type="hidden" name="type" value="{MULTI-REQUIRED[@NAME='TYPE']/VALUE}"/>
							</xsl:when>
							<xsl:otherwise>
								<input type="hidden" name="type" value="{/H2G2/ARTICLE/EXTRAINFO/TYPE/@ID}"/>
							</xsl:otherwise>
						</xsl:choose-->
					<input type="hidden" name="_msstage" value="{@STAGE}"/>
					<input type="hidden" name="h2g2id" value="{/H2G2/ARTICLE/ARTICLEINFO/H2G2ID}"/>
					<xsl:apply-templates select="." mode="r_article"/>
				</xsl:when>
			</xsl:choose>
			</div>
		</form>
	</xsl:template>	
	

<!-- 
	DATE FIELDS
	[FIXME: does this have to be duplicated in articlesearch?
	is there some way consolidate the two?]
-->
<!--
<xsl:template name="DATEFIELDS_SPECIFIC">
	<p>
		<input type="hidden" name="timeinterval" id="timeinterval" value="1"/>
		<label for="startday">Date</label>
		<select name="startday">
			<xsl:call-template name="GENERATE_DAY_OPTIONS">
				<xsl:with-param name="selectedValue" select="MULTI-REQUIRED[@NAME='STARTDAY']/VALUE-EDITABLE"/>
			</xsl:call-template>
		</select>
		/
		<select name="startmonth">
			<xsl:call-template name="GENERATE_MONTH_OPTIONS">
				<xsl:with-param name="selectedValue" select="MULTI-REQUIRED[@NAME='STARTMONTH']/VALUE-EDITABLE"/>
			</xsl:call-template>
		</select>
		/
		<input type="text" name="startyear" size="4" id="startyear">
			<xsl:attribute name="value">
				<xsl:if test="MULTI-REQUIRED[@NAME='STARTYEAR']/VALUE-EDITABLE != 0">
					<xsl:value-of select="MULTI-REQUIRED[@NAME='STARTYEAR']/VALUE-EDITABLE"/>
				</xsl:if>
			</xsl:attribute>
		</input>
	</p>
</xsl:template>

<xsl:template name="DATEFIELDS_DATERANGE">
	<p>
		<label for="startday">Between</label>
		<select name="startday">
			<xsl:call-template name="GENERATE_DAY_OPTIONS">
				<xsl:with-param name="selectedValue" select="MULTI-REQUIRED[@NAME='STARTDAY']/VALUE-EDITABLE"/>
			</xsl:call-template>
		</select>
		/
		<select name="startmonth">
			<xsl:call-template name="GENERATE_MONTH_OPTIONS">
				<xsl:with-param name="selectedValue" select="MULTI-REQUIRED[@NAME='STARTMONTH']/VALUE-EDITABLE"/>
			</xsl:call-template>
		</select>
		/
		<input type="text" name="startyear" size="4" id="startyear">
			<xsl:attribute name="value">
				<xsl:if test="MULTI-REQUIRED[@NAME='STARTYEAR']/VALUE-EDITABLE != 0">
					<xsl:value-of select="MULTI-REQUIRED[@NAME='STARTYEAR']/VALUE-EDITABLE"/>
				</xsl:if>
			</xsl:attribute>
		</input>
	</p>
	<p>
		<label for="endday">and</label>
		<select name="endday">
			<xsl:call-template name="GENERATE_DAY_OPTIONS">
				<xsl:with-param name="selectedValue" select="MULTI-REQUIRED[@NAME='ENDDAY']/VALUE-EDITABLE"/>
			</xsl:call-template>
		</select>
		/
		<select name="endmonth">
			<xsl:call-template name="GENERATE_MONTH_OPTIONS">
				<xsl:with-param name="selectedValue" select="MULTI-REQUIRED[@NAME='ENDMONTH']/VALUE-EDITABLE"/>
			</xsl:call-template>
		</select>
		/
		<input type="text" name="endyear" size="4" id="endyear">
			<xsl:attribute name="value">
				<xsl:if test="MULTI-REQUIRED[@NAME='ENDYEAR']/VALUE-EDITABLE != 0">
					<xsl:value-of select="MULTI-REQUIRED[@NAME='ENDYEAR']/VALUE-EDITABLE"/>
				</xsl:if>
			</xsl:attribute>
		</input>
	</p>
</xsl:template>

<xsl:template name="DATEFIELDS_FUZZYDATE">
	<p>
		<label for="startday">Somewhere between</label>
		<select name="startday">
			<xsl:call-template name="GENERATE_DAY_OPTIONS">
				<xsl:with-param name="selectedValue" select="MULTI-REQUIRED[@NAME='STARTDAY']/VALUE-EDITABLE"/>
			</xsl:call-template>
		</select>
		/
		<select name="startmonth">
			<xsl:call-template name="GENERATE_MONTH_OPTIONS">
				<xsl:with-param name="selectedValue" select="MULTI-REQUIRED[@NAME='STARTMONTH']/VALUE-EDITABLE"/>
			</xsl:call-template>
		</select>
		/
		<input type="text" name="startyear" size="4" id="startyear">
			<xsl:attribute name="value">
				<xsl:if test="MULTI-REQUIRED[@NAME='STARTYEAR']/VALUE-EDITABLE != 0">
					<xsl:value-of select="MULTI-REQUIRED[@NAME='STARTYEAR']/VALUE-EDITABLE"/>
				</xsl:if>
			</xsl:attribute>
		</input>
	</p>
	<p>
		<label for="endday">and</label>
		<select name="endday">
			<xsl:call-template name="GENERATE_DAY_OPTIONS">
				<xsl:with-param name="selectedValue" select="MULTI-REQUIRED[@NAME='ENDDAY']/VALUE-EDITABLE"/>
			</xsl:call-template>
		</select>
		/
		<select name="endmonth">
			<xsl:call-template name="GENERATE_MONTH_OPTIONS">
				<xsl:with-param name="selectedValue" select="MULTI-REQUIRED[@NAME='ENDMONTH']/VALUE-EDITABLE"/>
			</xsl:call-template>
		</select>
		/
		<input type="text" name="endyear" size="4" id="endyear">
			<xsl:attribute name="value">
				<xsl:if test="MULTI-REQUIRED[@NAME='ENDYEAR']/VALUE-EDITABLE != 0">
					<xsl:value-of select="MULTI-REQUIRED[@NAME='ENDYEAR']/VALUE-EDITABLE"/>
				</xsl:if>
			</xsl:attribute>
		</input>
	</p>
	<p>
		<label for="timeinterval" class="radioLabel">lasting</label>

		<input type="text" size="2" name="timeinterval" id="timeinterval">
			<xsl:attribute name="value">
				<xsl:if test="MULTI-REQUIRED[@NAME='TIMEINTERVAL']/VALUE-EDITABLE != 0">
					<xsl:value-of select="MULTI-REQUIRED[@NAME='TIMEINTERVAL']/VALUE-EDITABLE"/>
				</xsl:if>
			</xsl:attribute>
		</input>
		days
	</p>
</xsl:template>

<xsl:template name="DATEFIELDS_NODATE">
	<p>
		Please note that your memory will now not be available within the 
		timeline for people to view as you have not associated a date with it. 
	</p>
</xsl:template>
-->
</xsl:stylesheet>


