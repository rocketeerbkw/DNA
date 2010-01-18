<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:variable name="rootbase">/dna/</xsl:variable>
	<xsl:variable name="assetroot">/dna/actionnetwork/icandev/</xsl:variable>
	<xsl:variable name="mediaassethome">MediaAsset</xsl:variable>
	<xsl:variable name="localimagesourcepath">c:/mediaassetuploadqueue</xsl:variable>
	<xsl:variable name="libraryext">library/</xsl:variable>
	<xsl:variable name="imagesourcepath">http://downloads.bbc.co.uk/dnauploads/test/</xsl:variable>

	<xsl:template match="H2G2[@TYPE='ARTICLESEARCH']">
		<xsl:apply-templates select="ARTICLESEARCH" />
	</xsl:template>

	<xsl:template match="ARTICLES">
		<xsl:param name="url" select="'A'" />
		<xsl:param name="target">_top</xsl:param>
		<!-- javascript for thread moving popup -->
		<script language="javascript">
			<xsl:comment>
				function moveThreadPopup(threadID)
				{
				// build a js string to popup a window to move the given thread to the currently selected destination
				var selectObject = 'document.forms.MoveThreadForm' + threadID + '.Select' + threadID;
				var forumID = eval(selectObject + '.options[' + selectObject + '.selectedIndex].value');
				var command = 'Move';

				// don't try to perform the move if we have no sensible destination
				if (forumID == 0)
				{
				command = 'Fetch';
				}
				return eval('window.open(\'<xsl:value-of select="$root"/>MoveThread?cmd=' + command + '?ThreadID=' + threadID + '&amp;DestinationID=F' + forumID + '&amp;mode=POPUP\', \'MoveThread\', \'scrollbars=1,resizable=1,width=300,height=230\')');
				}
				//
			</xsl:comment>
		</script>
		<div align="CENTER">
			<xsl:choose>
				<xsl:when test="@SKIPTO != 0">
					<a href="{$root}ArticleSearch?skip=0&amp;show={@COUNT}">

						[ Newest ]
					</a>
					<xsl:variable name="alt">
						[ <xsl:value-of select='number(@SKIPTO) - number(@COUNT) + 1'/>-<xsl:value-of select='number(@SKIPTO)'/> ]
					</xsl:variable>
					<a href="{$root}ArticleSearch?skip={number(@SKIPTO) - number(@COUNT)}&amp;show={@COUNT}">
						<xsl:value-of select="$alt"/>
					</a>
				</xsl:when>
				<xsl:otherwise>
					[ Newest ]
					[ Newer ]
				</xsl:otherwise>
			</xsl:choose>

			<xsl:choose>
				<xsl:when test="@MORE">
					<xsl:variable name="alt">
						[ <xsl:value-of select='number(@SKIPTO) + number(@COUNT) + 1'/>-<xsl:value-of select='number(@SKIPTO) + number(@COUNT) + number(@COUNT)'/> ]
					</xsl:variable>
					<a href="{$root}ArticleSearch?skip={number(@SKIPTO) + number(@COUNT)}&amp;show={@COUNT}">
						<xsl:value-of select="$alt"/>
					</a>
					<a href="{$root}ArticleSearch?skip={floor((number(@TOTAL)-1) div number(@COUNT)) * number(@COUNT)}&amp;show={@COUNT}">
						[ Oldest ]
					</a>
				</xsl:when>
				<xsl:otherwise>
					[ Older ]
					[ Oldest ]
				</xsl:otherwise>
			</xsl:choose>
			<br/>
		</div>
		<br/>
		<br/>
		<TABLE width="100%" cellpadding="2" cellspacing="0" border="1">
			<TR>
				<TD colspan="2" align="center">Article</TD>
				<TD colspan="2" align="center">Caption</TD>
				<TD colspan="2" align="center">Description</TD>
				<TD colspan="2" align="center">Editor</TD>
				<TD colspan="2" align="center">Start Date Range</TD>
				<TD colspan="2" align="center">End Date Range</TD>
				<TD colspan="2" align="center">Duration</TD>
			</TR>
				<xsl:for-each select="ARTICLE">
				<TR>
					<TD colspan="2" align="center">
						<xsl:element name="A">
							<xsl:attribute name="HREF">
								<xsl:value-of select="$root"/>
								<xsl:value-of select="$url"/>
								<xsl:value-of select="@H2G2ID"/>
								<xsl:if test="/H2G2/ARTICLESEARCH/PHRASES/@PARAM">
									&amp;phrase=<xsl:value-of select="/H2G2/ARTICLESEARCH/PHRASES/@PARAM"/>
								</xsl:if>
							</xsl:attribute>
							<xsl:attribute name="TARGET">
								<xsl:value-of select="$target"/>
							</xsl:attribute>

							<!-- Display link text -->
							<B>
								<xsl:apply-templates mode="nosubject" select="SUBJECT"/>
							</B>
						</xsl:element>
					</TD>
					<TD colspan="2" align="left">
						<span class="lastposting">
							<xsl:apply-templates select="EXTRAINFO/AUTODESCRIPTION"/>
						</span>
					</TD>
					<TD colspan="2" align="left">
						<span class="lastposting">
							<xsl:apply-templates select="PHRASES/PHRASE"/>
						</span>
					</TD>
					<TD colspan="2" align="left">
						<span class="lastposting">
							by <xsl:value-of select="EDITOR/USER/USERNAME"/>
						</span>
					</TD>
					<TD colspan="2" align="left">
						<span class="lastposting">
							<xsl:value-of select="DATERANGESTART/DATE/@RELATIVE"/>
						</span>
					</TD>
					<TD colspan="2" align="left">
						<span class="lastposting">
							<xsl:value-of select="DATERANGEEND/DATE/@RELATIVE"/>
						</span>
					</TD>
					<TD colspan="2" align="left">
						<span class="lastposting">
							<xsl:value-of select="TIMEINTERVAL"/>
						</span>
					</TD>
					<xsl:choose>
						<xsl:when test="MEDIAASSET">
							<xsl:variable name="mediaassetpath">
								<xsl:value-of select="MEDIAASSET/@MEDIAASSETID"/>
								<xsl:choose>
									<xsl:when test="MEDIAASSET/MIMETYPE='image/jpeg' or MEDIAASSET/MIMETYPE='image/pjpeg'">
										_thumb.jpg
									</xsl:when>
									<xsl:when test="MEDIAASSET/MIMETYPE='image/gif'">
										_thumb.gif
									</xsl:when>
									<xsl:when test="MEDIAASSET/MIMETYPE='video/movie'">
										.mov
									</xsl:when>
									<xsl:when test="MEDIAASSET/MIMETYPE='audio/mpeg'">
										.mp3
									</xsl:when>
								</xsl:choose>
							</xsl:variable>
							<xsl:variable name="ftppath">
								<xsl:value-of select="MEDIAASSET/FTPPATH"/>
							</xsl:variable>
							<TD colspan="2" align="left">
								<span class="lastposting">
									<xsl:choose>
										<xsl:when test="MEDIAASSET/@CONTENTTYPE='1'">
											Image
										</xsl:when>
										<xsl:when test="MEDIAASSET/@CONTENTTYPE='2'">
											Audio
										</xsl:when>
										<xsl:when test="MEDIAASSET/@CONTENTTYPE='3'">
											Video
										</xsl:when>
									</xsl:choose>
								</span>
							</TD>
							<TD colspan="2" align="left">
								<span class="lastposting">
									<xsl:choose>
										<xsl:when test="not(MEDIAASSET/HIDDEN)">
											<xsl:choose>
												<xsl:when test="MEDIAASSET/@CONTENTTYPE='1'">
													<img src="{$imagesourcepath}{$ftppath}{$mediaassetpath}"/>
												</xsl:when>
												<xsl:when test="MEDIAASSET/@CONTENTTYPE='2'">
													<a href="{$imagesourcepath}{$ftppath}{$mediaassetpath}">Click here to play Audio Asset </a>
												</xsl:when>
												<xsl:when test="MEDIAASSET/@CONTENTTYPE='3'">
													<xsl:choose>
														<xsl:when test="not(MEDIAASSET/EXTERNALLINKURL)">
															<a href="{$imagesourcepath}{$ftppath}{$mediaassetpath}">Click here to play Video Asset</a>
														</xsl:when>
														<xsl:otherwise>
															<xsl:if test="MEDIAASSET/EXTERNALLINKID">
																<xsl:choose>
																	<xsl:when test="MEDIAASSET/EXTERNALLINKTYPE='Google'">
																		<embed style="width:400px; height:326px;" id="VideoPlayback" align="middle" type="application/x-shockwave-flash" src="http://video.google.com/googleplayer.swf?docId={MEDIAASSET/EXTERNALLINKID}" allowScriptAccess="sameDomain" quality="best" bgcolor="#ffffff" scale="noScale" salign="TL"  FlashVars="playerMode=embedded"> </embed>
																	</xsl:when>
																	<xsl:when test="MEDIAASSET/EXTERNALLINKTYPE='MySpace'">
																		<embed style="width:400px; height:326px;" id="VideoPlayback" align="middle" type="application/x-shockwave-flash" src="http://lads.myspace.com/videos/vplayer.swf" flashvars="m={MEDIAASSET/EXTERNALLINKID}&amp;type=video"> </embed>
																	</xsl:when>
																	<xsl:otherwise>
																		<object width="213" height="175">
																			<param name="movie" value="http://www.youtube.com/v/{MEDIAASSET/EXTERNALLINKID}"></param>
																			<embed src="http://www.youtube.com/v/{MEDIAASSET/EXTERNALLINKID}" type="application/x-shockwave-flash" width="425" height="350"></embed>
																		</object>
																	</xsl:otherwise>
																</xsl:choose>

																<br/>
																<br/>
															</xsl:if>
															<a href="{MEDIAASSET/EXTERNALLINKURL}">Goto external site to show video</a>
														</xsl:otherwise>
													</xsl:choose>
												</xsl:when>
											</xsl:choose>
										</xsl:when>
										<xsl:otherwise>
											<xsl:choose>
												<xsl:when test="MEDIAASSET/@CONTENTTYPE='1'">
													<B>Image</B>
												</xsl:when>
												<xsl:when test="MEDIAASSET/@CONTENTTYPE='2'">
													<B>Audio</B>
												</xsl:when>
												<xsl:when test="MEDIAASSET/@CONTENTTYPE='3'">
													<B>Video</B>
												</xsl:when>
											</xsl:choose>
											<B> Awaiting Moderation</B>
										</xsl:otherwise>
									</xsl:choose>
								</span>
							</TD>
							<TD colspan="2" align="left">
								<span class="lastposting">
									<xsl:choose>
										<xsl:when test="MEDIAASSET/HIDDEN=2">
											Refered
										</xsl:when>
										<xsl:when test="MEDIAASSET/HIDDEN=4">
											Failed
										</xsl:when>
										<xsl:when test="MEDIAASSET/HIDDEN=3">
											In Moderation
										</xsl:when>
										<xsl:otherwise>
											Passed
										</xsl:otherwise>
									</xsl:choose>
								</span>
							</TD>
							<TD colspan="2" align="left">
								<span class="lastposting">
									<xsl:apply-templates select="POLL/STATISTICS"/>
								</span>
							</TD>
						</xsl:when>
					</xsl:choose>
				</TR>
			</xsl:for-each>
		</TABLE>
	</xsl:template>

	<xsl:template match="ARTICLESEARCH">
		<h1>Article Search Page</h1>
		<!-- Show current search phrases -->
		<xsl:apply-templates select="PHRASES"/>

		<!-- Show hot phrases-->
		<xsl:apply-templates select="ARTICLEHOT-PHRASES" mode="r_threadsearchphrasepage"/>

		<form method="GET" action="ArticleSearch">
			<h3>Find Articles tagged with these words: </h3>
			<input type="text" name="phrase" value="" size="10" />
			<xsl:if test="/H2G2/PREVIEWMODE &gt; 0">
				<input type="hidden" name="_previewmode" value="1"/>
			</xsl:if>
			<input type="submit" value="Go"/>
			<BR/>
			<input type = "radio" value="-1" name="contenttype">
				<xsl:if test="@CONTENTTYPE=-1">
					<xsl:attribute name="checked">checked</xsl:attribute>
				</xsl:if>
				All Articles
			</input>
			<BR/>
			<input type = "radio" value="0" name="contenttype">
				<xsl:if test="not(@CONTENTTYPE)">
					<xsl:attribute name="checked">checked</xsl:attribute>
				</xsl:if>
				All Articles with Media Assets
			</input>
			<BR/>
			<input type="radio" value="1" name="contenttype">
				<xsl:if test="@CONTENTTYPE=1">
					<xsl:attribute name="checked">checked</xsl:attribute>
				</xsl:if>
				Articles with Image Assets
			</input>
			<BR/>
			<input type="radio" value="2" name="contenttype">
				<xsl:if test="@CONTENTTYPE=2">
					<xsl:attribute name="checked">checked</xsl:attribute>
				</xsl:if>
				Articles with Audio Assets
			</input>
			<BR/>
			<input type="radio" value="3" name="contenttype">
				<xsl:if test="@CONTENTTYPE=3">
					<xsl:attribute name="checked">checked</xsl:attribute>
				</xsl:if>
				Articles with Video Assets
			</input>
			<BR/>
			<BR/>
			Sort Articles with Media Assets by
			<BR/>
			<select name="articlesortby">
				<option value="DateUploaded" selected="selected">Date Uploaded (most recent first)</option>
				<option value="Caption">Caption A-Z</option>
				<option value="Rating">Rating</option>
			</select>
			<BR/>
			<BR/>
			Include Date Range Search
			<BR/>
			<input type = "radio" value="0" name="datesearchtype">
				<xsl:if test="@DATESEARCHTYPE=0">
					<xsl:attribute name="checked">checked</xsl:attribute>
				</xsl:if>
				No Date Search
			</input>
			<BR/>
			<input type="radio" value="1" name="datesearchtype">
				<xsl:if test="@DATESEARCHTYPE=1">
					<xsl:attribute name="checked">checked</xsl:attribute>
				</xsl:if>
				Articles about Dates within the Date Range
			</input>
			<BR/>
			<input type="radio" value="2" name="datesearchtype">
				<xsl:if test="@DATESEARCHTYPE=2">
					<xsl:attribute name="checked">checked</xsl:attribute>
				</xsl:if>
				Articles about Dates covering the Date Range
			</input>
			<p>
				<xsl:call-template name="DateRange">
					<xsl:with-param name="sday">
						<xsl:value-of select="DATERANGESTART/DATE/@DAY"/>
					</xsl:with-param>
					<xsl:with-param name="smonth">
						<xsl:value-of select="DATERANGESTART/DATE/@MONTH"/>
					</xsl:with-param>
					<xsl:with-param name="syear">
						<xsl:value-of select="DATERANGESTART/DATE/@YEAR"/>
					</xsl:with-param>
					<xsl:with-param name="eday">
						<xsl:value-of select="DATERANGEEND/DATE/@DAY"/>
					</xsl:with-param>
					<xsl:with-param name="emonth">
						<xsl:value-of select="DATERANGEEND/DATE/@MONTH"/>
					</xsl:with-param>
					<xsl:with-param name="eyear">
						<xsl:value-of select="DATERANGEEND/DATE/@YEAR"/>
					</xsl:with-param>
					<xsl:with-param name="tinterval">
						<xsl:value-of select="@TIMEINTERVAL"/>
					</xsl:with-param>
				</xsl:call-template>

			</p>
		</form>

		<xsl:apply-templates select="ARTICLES" />
	</xsl:template>

	<xsl:template name="DaysOfMonthOptions">
		<option value="01">01</option>
		<option value="02">02</option>
		<option value="03">03</option>
		<option value="04">04</option>
		<option value="05">05</option>
		<option value="06">06</option>
		<option value="07">07</option>
		<option value="08">08</option>
		<option value="09">09</option>
		<option value="10">10</option>
		<option value="11">11</option>
		<option value="12">12</option>
		<option value="10">10</option>
		<option value="11">11</option>
		<option value="12">12</option>
		<option value="13">13</option>
		<option value="14">14</option>
		<option value="15">15</option>
		<option value="16">16</option>
		<option value="17">17</option>
		<option value="18">18</option>
		<option value="19">19</option>
		<option value="20">20</option>
		<option value="21">21</option>
		<option value="22">22</option>
		<option value="23">23</option>
		<option value="24">24</option>
		<option value="25">25</option>
		<option value="26">26</option>
		<option value="27">27</option>
		<option value="28">28</option>
		<option value="29">29</option>
		<option value="30">30</option>
		<option value="31">31</option>
	</xsl:template>

	<xsl:template name="MonthsOptions">
		<option value="01">01</option>
		<option value="02">02</option>
		<option value="03">03</option>
		<option value="04">04</option>
		<option value="05">05</option>
		<option value="06">06</option>
		<option value="07">07</option>
		<option value="08">08</option>
		<option value="09">09</option>
		<option value="10">10</option>
		<option value="11">11</option>
		<option value="12">12</option>
	</xsl:template>

	<xsl:template name="YearsOptions">
		<option value="2007">2007</option>
		<option value="2006">2006</option>
		<option value="2005">2005</option>
		<option value="2004">2004</option>
		<option value="2003">2003</option>
		<option value="2002">2002</option>
		<option value="2001">2001</option>
		<option value="2000">2000</option>
		<option value="1999">1999</option>
		<option value="1998">1998</option>
		<option value="1997">1997</option>
		<option value="1996">1996</option>
		<option value="1995">1995</option>
	</xsl:template>

	<xsl:template name="DateRange">
		<xsl:param name="sday">1</xsl:param>
		<xsl:param name="smonth">03</xsl:param>
		<xsl:param name="syear">2005</xsl:param>
		<xsl:param name="eday">31</xsl:param>
		<xsl:param name="emonth">04</xsl:param>
		<xsl:param name="eyear">2006</xsl:param>
		<xsl:param name="tinterval">1</xsl:param>
		Start Day
		<select name="startday">
			<option value="{$sday}">
				<xsl:value-of select="$sday"/>
			</option>
			<xsl:call-template name="DaysOfMonthOptions"/>
		</select>
		Start Month
		<select name="startmonth">
			<option value="{$smonth}">
				<xsl:value-of select="$smonth"/>
			</option>
			<xsl:call-template name="MonthsOptions"/>
		</select>
		Start Year
		<select name="startyear">
			<option value="{$syear}">
				<xsl:value-of select="$syear"/>
			</option>
			<xsl:call-template name="YearsOptions"/>
		</select>
		<br/>
		End Day
		<select name="endday">
			<option value="{$eday}">
				<xsl:value-of select="$eday"/>
			</option>
			<xsl:call-template name="DaysOfMonthOptions"/>
		</select>
		End Month
		<select name="endmonth">
			<option value="{$emonth}">
				<xsl:value-of select="$emonth"/>
			</option>
			<xsl:call-template name="MonthsOptions"/>
		</select>
		End Year
		<select name="endyear">
			<option value="{$eyear}">
				<xsl:value-of select="$eyear"/>
			</option>
			<xsl:call-template name="YearsOptions"/>
		</select>
		<br/>
		Time interval <input type="text" name="timeinterval" value="{$tinterval}"/>
	</xsl:template>

	<xsl:template match="ARTICLEHOT-PHRASES" mode="r_threadsearchphrasepage">
		<xsl:if test=".!=''">
			<h2>Article tag cloud</h2>

			<xsl:apply-templates select="ARTICLEHOT-PHRASE" mode="r_threadsearchphrasepage"/>
		</xsl:if>
	</xsl:template>

	<xsl:template match="ARTICLEHOT-PHRASE" mode="r_threadsearchphrasepage">
		<li>
			<xsl:value-of select="NAME"/> (<xsl:value-of select="RANK"/>)
		</li>
	</xsl:template>

	<xsl:template match="PHRASES">
		The Phrases you chose are:
		<xsl:apply-templates select="PHRASE"/>
	</xsl:template>

	<xsl:template match="PHRASE">
		<li>
			<xsl:value-of select="NAME"/>
		</li>
	</xsl:template>


</xsl:stylesheet>