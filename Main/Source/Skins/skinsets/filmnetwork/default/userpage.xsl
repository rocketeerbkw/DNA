<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
	<!ENTITY space "<xsl:text xmlns:xsl='http://www.w3.org/1999/XSL/Transform'> </xsl:text>">
]>
<xsl:stylesheet exclude-result-prefixes="msxsl local s dt" version="1.0"
	xmlns:dt="urn:schemas-microsoft-com:datatypes" xmlns:local="#local-functions"
	xmlns:msxsl="urn:schemas-microsoft-com:xslt"
	xmlns:s="urn:schemas-microsoft-com:xml-data"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:import href="../../../base/base-userpage.xsl" />
	<xsl:import href="userpage_templates.xsl" />

	<!--
	<xsl:variable name="limiteentries" select="10"/>
	Use: sets the number of recent conversations and articles to display
	 -->
	<xsl:variable name="postlimitentries" select="5" />
	<xsl:variable name="articlelimitentries" select="5" />
	<xsl:variable name="clublimitentries" select="8" />

	<xsl:template name="USERPAGE_MAINBODY">
		<!-- DEBUG -->
		<xsl:call-template name="TRACE">
			<xsl:with-param name="message">USERPAGE_MAINBODY<xsl:value-of
					select="$current_article_type" /></xsl:with-param>
			<xsl:with-param name="pagename">userpage.xsl</xsl:with-param>
		</xsl:call-template>
		<!-- DEBUG -->
		<xsl:apply-templates mode="c_displayuserpage" select="/H2G2" />
	</xsl:template>

	<xsl:template match="H2G2" mode="r_displayuserpage">
		<xsl:choose>

			<!-- BEGIN redirect to 'add biog' -->
			<xsl:when
				test="/H2G2/PARAMS/PARAM[NAME = 's_next_page']/VALUE = 'add_biog'">
				<meta http-equiv="REFRESH">
					<xsl:attribute name="content">0;url=<xsl:value-of select="$root"
							 />TypedArticle?aedit=new&amp;type=3001&amp;h2g2id=<xsl:value-of
							select="/H2G2/ARTICLE/ARTICLEINFO/H2G2ID"
					 />&amp;s_view=step1</xsl:attribute>
				</meta>
				<!-- incase meta refresh does not work -->
				<table border="0" cellpadding="5" cellspacing="0" width="371">
					<tr>
						<td height="10" />
					</tr>
				</table>
				<table border="0" cellpadding="0" cellspacing="0" width="635">
					<tr>
						<td>
							<img alt="" class="tiny" height="1" src="/f/t.gif" width="371" />
						</td>
						<td>
							<img alt="" class="tiny" height="1" src="/f/t.gif" width="20" />
						</td>
						<td>
							<img alt="" class="tiny" height="1" src="/f/t.gif" width="244" />
						</td>
					</tr>
					<tr>
						<td valign="top" width="371">
							<table border="0" cellpadding="0" cellspacing="0" width="371">
								<tr>
									<td class="topbg" height="69" valign="top">
										<img alt="" height="10" src="/f/t.gif" width="1" />
										<div class="whattodotitle">
											<strong>Adding biog, credits, specialisms.</strong>
										</div>
										<div class="topboxcopy"><strong>
												<a class="rightcol"
													href="url={$root}TypedArticle?aedit=new&amp;type=3001&amp;h2g2id={/H2G2/ARTICLE/ARTICLEINFO/H2G2ID}&amp;s_view=step1"
													>Click here</a>
											</strong> if nothing happens after a few seconds.</div>
									</td>
								</tr>
							</table>
						</td>
						<td class="topbg" valign="top" width="20" />
						<td class="topbg" valign="top"> </td>
					</tr>
					<tr>
						<td colspan="3" valign="top" width="635">
							<img height="27"
								src="{$imagesource}furniture/writemessage/topboxangle.gif"
								width="635" />
						</td>
					</tr>
				</table>
			</xsl:when>
			<!-- END redirected to 'add biog' -->

			<!-- BEGIN step 2 setup: place and specialism -->
			<xsl:when
				test="/H2G2/PARAMS/PARAM[NAME = 's_view']/VALUE = 'step2' or /H2G2/PARAMS/PARAM[NAME = 's_view']/VALUE = 'placeandspecialisms'">
				<table border="0" cellpadding="0" cellspacing="0"
					class="submistablebg topmargin" width="635">
					<tr>
						<td colspan="3" valign="bottom" width="635">
							<img alt="" class="tiny" height="57"
								src="{$imagesource}furniture/submission/submissiontop.gif"
								width="635" />
						</td>
					</tr>
					<tr>
						<td class="subleftcolbg" valign="top" width="88">
							<img alt="" height="29"
								src="{$imagesource}furniture/submission/submissiontopleftcorner.gif"
								width="88" />
						</td>
						<td valign="top" width="459">
							<!-- steps -->
							<xsl:choose>
								<xsl:when
									test="/H2G2/PARAMS/PARAM[NAME = 's_view']/VALUE = 'step2'">
									<table border="0" cellpadding="0" cellspacing="0"
										class="steps4">
										<tr>
											<td class="step1of4" width="49">step 1</td>
											<td width="67">
												<img alt="" height="11"
													src="{$imagesource}furniture/arrow_4steps.gif"
													width="67" />
											</td>
											<td class="step2of4 currentStep" width="76">step 2</td>
											<td width="67">
												<img alt="" height="11"
													src="{$imagesource}furniture/arrow_4steps.gif"
													width="67" />
											</td>
											<td class="step3of4" width="72">step 3</td>
											<td width="67">
												<img alt="" height="11"
													src="{$imagesource}furniture/arrow_4steps.gif"
													width="67" />
											</td>
											<td class="step4of4" width="61">step 4</td>
										</tr>
									</table>
									<h1 class="image">
										<img alt="my profile setup 2: place and specialism"
											height="65"
											src="{$imagesource}furniture/title_my_profile_setup_2.gif"
											width="459" />
									</h1>
								</xsl:when>
								<xsl:otherwise>
									<table border="0" cellpadding="0" cellspacing="0"
										class="steps4">
										<tr>
											<td class="currentStep">&nbsp;</td>
										</tr>
									</table>
									<h1 class="image">
										<img alt="place and specialism" height="29"
											src="{$imagesource}furniture/title_place_and_specialisms.gif"
											width="459" />
									</h1>
								</xsl:otherwise>
							</xsl:choose>
							<p class="textmedium"> You can add yourself to our people
								directory by tagging yourself to a place and up to
								<strong>three</strong> specialisms. <xsl:if
									test="/H2G2/PARAMS/PARAM[NAME = 's_view']/VALUE = 'step2'"> If
									you prefer, you can <a class="em"
										href="{root}tagitem?s_view=step3">leave this until later</a>
								</xsl:if>
							</p>
							<div class="infoLink">
								<a href="{root}sitehelpfindingthings#peopledirectory"
									target="_blank">what is the people directory?</a>
							</div>
							<script type="text/javascript">
<xsl:comment>
//<![CDATA[
function validate(form)
{
nodes = form.node.length;
selected = 0;

for (i = 11; i < nodes; i++) /* ignore first 11 nodes (places) */
{
	if (form.node[i].checked) 
	{
		selected = selected + 1;
	}
}
if (selected > 3) 
	{
		alert("You can select up to three specialisms and one place.");
		return false;
	}
	else {return true;}
}
//]]>
</xsl:comment>
							</script>
							<form action="{$root}tagitem" id="setup2" method="get"
								name="multitag" onsubmit="return validate(this)">
								<xsl:variable name="doc_node" select="/" />
								<input name="tagitemtype" type="hidden"
									value="{$current_article_type}" />
								<input name="tagitemid" type="hidden"
									value="{/H2G2/ARTICLE/ARTICLEINFO/H2G2ID}" />
								<input name="action" type="hidden" value="addmulti" />
								<div id="addPlace">
									<h2 class="image top">
										<img alt="add place" height="17"
											src="{$imagesource}furniture/title_add_place.gif"
											width="70" />
									</h2>
									<p class="textmedium">Choose your place from the list below.</p>
									<table border="0" cellpadding="0" cellspacing="0">
										<tr>
											<td valign="top" width="180">
												<xsl:for-each
													select="msxsl:node-set($categories)/category[substring(@name, 1, 6)
													= 'member' and not(@name = 'membersPlacePage') and not(@name = 'membersSpecialismPage')]">
													<xsl:sort select="@name" />
													<xsl:if
														test="position() &lt;= ((last() + 1) div 2)">
														<xsl:call-template
															name="add_place_specialism_inputs">
															<xsl:with-param name="doc_node" select="$doc_node" />
															<xsl:with-param name="type" select="'radio'" />
														</xsl:call-template>
													</xsl:if>
												</xsl:for-each>
											</td>
											<td valign="top">
												<xsl:for-each
													select="msxsl:node-set($categories)/category[substring(@name, 1, 6)
													= 'member' and not(@name = 'membersPlacePage') and not(@name = 'membersSpecialismPage')]">
													<xsl:sort select="@name" />
													<xsl:if
														test="position() &gt; ((last() + 1) div 2)">
														<xsl:call-template
															name="add_place_specialism_inputs">
															<xsl:with-param name="doc_node" select="$doc_node" />
															<xsl:with-param name="type" select="'radio'" />
														</xsl:call-template>
													</xsl:if>
												</xsl:for-each>
											</td>
										</tr>
									</table>
								</div>
								<div class="hr" />
								<div id="addSpecialism">
									<h2 class="image">
										<img alt="add specialism" height="17"
											src="{$imagesource}furniture/title_add_specialism.gif"
											width="108" />
									</h2>
									<p class="textmedium">You can add up to three specialisms.
										These can be updated or removed at a later date.</p>
									<table border="0" cellpadding="0" cellspacing="0">
										<tr>
											<td valign="top" width="180">
												<xsl:for-each
													select="msxsl:node-set($categories)/category[substring(@name, 1, 10)
													= 'specialism']">
													<xsl:sort select="@name" />
													<xsl:if
														test="position() &lt;= ((last() + 1) div 2)">
														<xsl:call-template
															name="add_place_specialism_inputs">
															<xsl:with-param name="doc_node" select="$doc_node" />
															<xsl:with-param name="type" select="'checkbox'" />
														</xsl:call-template>
													</xsl:if>
												</xsl:for-each>
											</td>
											<td valign="top">
												<xsl:for-each
													select="msxsl:node-set($categories)/category[substring(@name, 1, 10)
													= 'specialism']">
													<xsl:sort select="@name" />
													<xsl:if
														test="position() &gt; ((last() + 1) div 2)">
														<xsl:call-template
															name="add_place_specialism_inputs">
															<xsl:with-param name="doc_node" select="$doc_node" />
															<xsl:with-param name="type" select="'checkbox'" />
														</xsl:call-template>
													</xsl:if>
												</xsl:for-each>
											</td>
										</tr>
									</table>
								</div>
								<div class="formBtnLink">
									<xsl:if
										test="/H2G2/PARAMS/PARAM[NAME = 's_view']/VALUE = 'step2'">
										<input name="s_view" type="hidden" value="step3" />
										<input alt="next" height="22"
											src="{$imagesource}furniture/next1.gif" type="image"
											width="90" />
									</xsl:if>
									<xsl:if
										test="/H2G2/PARAMS/PARAM[NAME = 's_view']/VALUE = 'placeandspecialisms'">
										<input name="s_next_page" type="hidden" value="my_profile" />
										<input alt="next" height="22"
											src="{$imagesource}furniture/next1.gif" type="image"
											width="90" />
									</xsl:if>
								</div>
							</form>
						</td>
						<td class="subrightcolbg" valign="top" width="88">
							<img alt="" class="tiny" height="30" src="/f/t.gif" width="88" />
						</td>
					</tr>
					<tr>
						<td class="subrowbotbg" height="10" />
						<td class="subrowbotbg" />
						<td class="subrowbotbg" />
					</tr>
				</table>
			</xsl:when>
			<!-- END step 2 setup: place and specialism -->

			<!-- BEGIN step 4 setup: add credit pages -->
			<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_view']/VALUE = 'step4'">
				<table border="0" cellpadding="0" cellspacing="0"
					class="submistablebg topmargin" width="635">
					<tr>
						<td colspan="3" valign="bottom" width="635">
							<img alt="" class="tiny" height="57"
								src="{$imagesource}furniture/submission/submissiontop.gif"
								width="635" />
						</td>
					</tr>
					<tr>
						<td class="subleftcolbg" valign="top" width="88">
							<img alt="" height="29"
								src="{$imagesource}furniture/submission/submissiontopleftcorner.gif"
								width="88" />
						</td>
						<td valign="top" width="459">
							<!-- steps -->
							<table border="0" cellpadding="0" cellspacing="0" class="steps4">
								<tr>
									<td class="step1of4" width="49">step 1</td>
									<td width="67">
										<img alt="" height="11"
											src="{$imagesource}furniture/arrow_4steps.gif" width="67"
										 />
									</td>
									<td class="step2of4" width="76">step 2</td>
									<td width="67">
										<img alt="" height="11"
											src="{$imagesource}furniture/arrow_4steps.gif" width="67"
										 />
									</td>
									<td class="step3of4" width="72">step 3</td>
									<td width="67">
										<img alt="" height="11"
											src="{$imagesource}furniture/arrow_4steps.gif" width="67"
										 />
									</td>
									<td class="step4of4 currentStep" width="61">step 4</td>
								</tr>
							</table>
							<h1 class="image">
								<img alt="my profile setup 4: credits page" height="29"
									src="{$imagesource}furniture/title_my_profile_setup_4.gif"
									width="459" />
							</h1>
							<p class="textmedium">You can add a credit page for any films that
								you've made or worked on. On the credit page you can include
								information about your film including: your role, a logline,
								cast and crew etc. To add a credit click "add credit" in the
								credits section of your profile page. Any credits you add will
								appear here. If you would like the chance to showcase your film
								on Film Network, you need to fill in our online submission form.</p>
							<div class="formBtnLink">
								<xsl:variable name="h2g2id"
									select="/H2G2/RECENT-ENTRIES/ARTICLE-LIST/ARTICLE/H2G2-ID" />
								<xsl:variable name="title"
									select="/H2G2/VIEWING-USER/USER/USERNAME" />
								<a href="U{/H2G2/VIEWING-USER/USER/USERID}">
									<img alt="Go to my profile" height="22"
										src="{$imagesource}furniture/btnlink_go_to_my_profile.gif"
										width="258" />
								</a>
							</div>
						</td>
						<td class="subrightcolbg" valign="top" width="88">
							<img alt="" class="tiny" height="30" src="/f/t.gif" width="88" />
						</td>
					</tr>
					<tr>
						<td class="subrowbotbg" height="10" />
						<td class="subrowbotbg" />
						<td class="subrowbotbg" />
					</tr>
				</table>
			</xsl:when>
			<!-- END step 4 setup: add credit pages -->

			<!-- BEGIN profile display -->
			<xsl:otherwise>
				<!-- debugger -->
				<xsl:if
					test="$DEBUG = 1 or /H2G2/PARAMS/PARAM[NAME = 's_debug']/VALUE = '1'">
					<div class="debug">
						<p>page owner: <xsl:if
								test="/H2G2/PAGE-OWNER/USER/USER-MODE = 0 and /H2G2/PAGE-OWNER/USER/GROUPS/ADVISER"
								>industry professional</xsl:if>
							<xsl:if
								test="/H2G2/PAGE-OWNER/USER/USER-MODE = 0 and not(/H2G2/PAGE-OWNER/USER/GROUPS/ADVISER)"
								>filmmaker</xsl:if>
							<xsl:if test="/H2G2/PAGE-OWNER/USER/USER-MODE = 1">standard
							user</xsl:if><br /> status: you are <xsl:if
								test="$ownerisviewer=0">
								<strong>NOT</strong>
							</xsl:if> viewing your own page.</p>
						<p>is: <xsl:if test="$isIndustryProf=1"> isIndustryProf </xsl:if>
							<xsl:if test="$isFilmmaker=1"> isFilmmaker </xsl:if>
							<xsl:if test="$isStandardUser=1"> isStandardUser </xsl:if>
							<xsl:if test="$test_IsEditor"> and <b>test_IsEditor</b>
							</xsl:if><br /> USER-MODE: <xsl:value-of
								select="/H2G2/PAGE-OWNER/USER/USER-MODE" /></p> you have
							<xsl:value-of select="$filmPageCount" /> approved films<br /> you
						have <xsl:value-of select="$creditPageCount" /> credits<br /> you
						have <xsl:value-of select="$submissionPageCount" />
						submissions<br /> you have <xsl:value-of select="$declinedPageCount"
						 /> declined<br /> you have <xsl:value-of
							select="$featuresPageCount" /> features<br />
					</div>
				</xsl:if>
				<!-- Page Title-->
				<xsl:choose>
					<xsl:when test="$ownerisviewer=1">
						<h1>my profile</h1>
					</xsl:when>
					<xsl:when test="$isIndustryProf=1">
						<h1>industry panel member profile</h1>
					</xsl:when>
					<xsl:otherwise>
						<h1>member profile</h1>
					</xsl:otherwise>
				</xsl:choose>
				<!-- ################################ PROFILE TOP BOX ############################ -->
				<div id="myProfileTopBox">
					<div id="myProfileTopBoxInner">
						<table border="0" cellpadding="0" cellspacing="0" height="165"
							width="635">
							<tr>
								<td class="boxleft" valign="top" width="381">
									<div class="profileWrapper">
										<!-- profile name -->
										<div class="profilename">
											<xsl:value-of select="$name" />
										</div>
										<!-- if an idustry professional's title -->
										<xsl:if test="$isIndustryProf=1">
											<div class="industprofTitle">
												<xsl:value-of select="/H2G2/PAGE-OWNER/USER/TITLE" />
											</div>
										</xsl:if>
										<div class="profiledescription">

											<!-- BEGIN display specialism -->
											<xsl:for-each
												select="/H2G2/ARTICLE/ARTICLEINFO/CRUMBTRAILS/CRUMBTRAIL[ANCESTOR/NODEID =
					$membersSpecialismPage]">
												<a>
													<xsl:attribute name="href"><xsl:value-of
															select="$root" />C<xsl:value-of
															select="ANCESTOR[position()=last()]/NODEID" /></xsl:attribute>
													<xsl:value-of
														select="ANCESTOR[position()=last()]/NAME" />
												</a>
												<xsl:if test="position() != last()">,
												</xsl:if>&nbsp; </xsl:for-each>
											<!-- END display specialism -->

											<!-- BEGIN display location -->
											<xsl:if
												test="/H2G2/ARTICLE/ARTICLEINFO/CRUMBTRAILS/CRUMBTRAIL[ANCESTOR/NODEID =
					$membersSpecialismPage] and /H2G2/ARTICLE/ARTICLEINFO/CRUMBTRAILS/CRUMBTRAIL[ANCESTOR/NODEID =
					$membersPlacePage]"
												>|&nbsp;</xsl:if>
											<a>
												<xsl:attribute name="href"><xsl:value-of select="$root"
														 />C<xsl:value-of
														select="/H2G2/ARTICLE/ARTICLEINFO/CRUMBTRAILS/CRUMBTRAIL[ANCESTOR/NODEID =
						$membersPlacePage]/ANCESTOR[position()=last()]/NODEID"
													 /></xsl:attribute>
												<xsl:value-of
													select="/H2G2/ARTICLE/ARTICLEINFO/CRUMBTRAILS/CRUMBTRAIL[ANCESTOR/NODEID = $membersPlacePage]/ANCESTOR[position()=last()]/NAME"
												 />
											</a>
											<!-- END display location -->

										</div>

										<!-- BEGIN add/remove specialisms and place -->
										<xsl:if
											test="($test_IsEditor or $ownerisviewer = 1) and ($isIndustryProf=1 or $isFilmmaker=1) ">
											<div class="profiledescriptionedit">
												<!-- if there is a place or specialism we need to change the class of the div (different top margin) -->
												<xsl:if
													test="/H2G2/ARTICLE/ARTICLEINFO/CRUMBTRAILS/CRUMBTRAIL[ANCESTOR/NODEID = $membersSpecialismPage] and /H2G2/ARTICLE/ARTICLEINFO/CRUMBTRAILS/CRUMBTRAIL[ANCESTOR/NODEID = $membersPlacePage]">
													<xsl:attribute name="class"
													>profiledescriptionedit2</xsl:attribute>
												</xsl:if>
												<!-- Add Place -->
												<xsl:if
													test="count(/H2G2/ARTICLE/ARTICLEINFO/CRUMBTRAILS/CRUMBTRAIL[ANCESTOR/NODEID = $membersPlacePage]) = 0">
													<a
														href="{$root}U{/H2G2/VIEWING-USER/USER/USERID}?s_fromedit=1&amp;s_typedarticle=edit&amp;s_view=placeandspecialisms"
														>add place</a>
												</xsl:if>
												<!-- Remove Place -->
												<xsl:if
													test="count(/H2G2/ARTICLE/ARTICLEINFO/CRUMBTRAILS/CRUMBTRAIL[ANCESTOR/NODEID = $membersPlacePage]) &gt; 0">
													<a
														href="{$root}TagItem?tagitemid={$userpage_article_number}&amp;tagitemtype=3001&amp;s_title=remove place"
														>remove place</a>
												</xsl:if> &nbsp;<img alt="" height="7"
													src="{$imagesource}furniture/myprofile/arrow.gif"
													width="4" />
												<span class="seperatePlaceandSpecialism">&nbsp;</span>
												<!-- Add specialism -->
												<xsl:if
													test="count(/H2G2/ARTICLE/ARTICLEINFO/CRUMBTRAILS/CRUMBTRAIL[ANCESTOR/NODEID = $membersSpecialismPage]) &lt; 3">
													<a
														href="{$root}U{/H2G2/VIEWING-USER/USER/USERID}?s_fromedit=1&amp;s_typedarticle=edit&amp;s_view=placeandspecialisms"
														>add <xsl:if
															test="count(/H2G2/ARTICLE/ARTICLEINFO/CRUMBTRAILS/CRUMBTRAIL[ANCESTOR/NODEID = $membersSpecialismPage]) = 0"
															> specialism</xsl:if></a>
												</xsl:if>
												<!-- if both add and remove then need a seperator - i.e / -->
												<xsl:if
													test="count(/H2G2/ARTICLE/ARTICLEINFO/CRUMBTRAILS/CRUMBTRAIL[ANCESTOR/NODEID = $membersSpecialismPage]) &lt; 3 and count(/H2G2/ARTICLE/ARTICLEINFO/CRUMBTRAILS/CRUMBTRAIL[ANCESTOR/NODEID = $membersSpecialismPage]) &gt; 0"
													> / </xsl:if>
												<!-- Remove specialism -->
												<xsl:if
													test="count(/H2G2/ARTICLE/ARTICLEINFO/CRUMBTRAILS/CRUMBTRAIL[ANCESTOR/NODEID = $membersSpecialismPage]) &gt; 0">
													<a
														href="{$root}TagItem?tagitemid={$userpage_article_number}&amp;tagitemtype=3001&amp;s_title=remove specialism"
														>remove specialism</a>
												</xsl:if>&nbsp;<img alt="" height="7"
													src="{$imagesource}furniture/myprofile/arrow.gif"
													width="4" />
											</div>
											<!-- What is a specialism - only display if they haven't got one-->
											<xsl:if
												test="count(/H2G2/ARTICLE/ARTICLEINFO/CRUMBTRAILS/CRUMBTRAIL[ANCESTOR/NODEID = $membersSpecialismPage]) = 0">
												<div class="whatisaspecialism">
													<a href="{$root}sitehelpprofile#specialisms">what is a
														specialism?</a>
												</div>
											</xsl:if>
										</xsl:if>
										<!-- END add/remove specialisms and place -->

									</div>
								</td>
								<td class="boxright" valign="top" width="254">
									<xsl:choose>
										<!-- industry professional - optional img of user -->
										<xsl:when test="$isIndustryProf=1">
											<xsl:if
												test="/H2G2/ARTICLE/GUIDE/PUBLISH_INDUSTRY_IMG = 'on'">
												<xsl:variable name="pageownerID">
													<xsl:choose>
														<xsl:when test="$showfakegifs = 'yes'"
															>industryprofessional</xsl:when>
														<xsl:otherwise>
															<xsl:value-of
																select="/H2G2/PAGE-OWNER/USER/USERID" />
														</xsl:otherwise>
													</xsl:choose>
												</xsl:variable>
												<img alt="" height="191"
													src="{$imagesource}industryprof/{$pageownerID}.jpg"
													width="254" />
											</xsl:if>
										</xsl:when>
										<xsl:when test="$isFilmmaker=1">
											<div class="profileWrapper">
												<xsl:choose>
													<xsl:when
														test="$ownerisviewer=1 and count(/H2G2/ARTICLE/ARTICLEINFO/CRUMBTRAILS/CRUMBTRAIL[ANCESTOR/NODEID = $members_place]) != 0">
														<div class="seeothermebers">
															<a href=""><xsl:attribute name="href"
																		><xsl:value-of select="$root"
																		 />C<xsl:value-of
																		select="/H2G2/ARTICLE/ARTICLEINFO/CRUMBTRAILS/CRUMBTRAIL[ANCESTOR/NODEID = $members_place]/ANCESTOR[position()=last()]/NODEID"
																	 /></xsl:attribute> see other members in my
																area </a>
														</div>
													</xsl:when>
													<xsl:when test="$ownerisviewer=0 and $registered=1">
														<div class="addcontact">
															<a
																href="Watch{$viewerid}?add=1&amp;adduser={PAGE-OWNER/USER/USERID}"
																>add <xsl:value-of select="$name" /> to my
																contact list</a>
														</div>
														<div class="moreinfo">
															<a href="{root}sitehelpprofile#contacts">what is
																my contact list?</a>
														</div>
													</xsl:when>
													<xsl:otherwise> &nbsp; </xsl:otherwise>
												</xsl:choose>
											</div>
										</xsl:when>
										<!-- if standard user -->
										<xsl:otherwise>
											<div class="profileWrapper">
												<!-- upgrade user mode by adding full biog details -->
												<xsl:if test="$ownerisviewer=1">
													<div class="addfullbiog">
														<a href="{root}UserDetails?s_upgradeuser=1">add full
															biog, credits and specialism</a>
													</div>
													<div class="moreinfo">
														<a href="{root}sitehelpprofile#filmmakerprofile"
															>what does this do?</a>
													</div>
												</xsl:if>
												<xsl:if test="$ownerisviewer=0">
													<div class="addcontact">
														<a
															href="Watch{$viewerid}?add=1&amp;adduser={PAGE-OWNER/USER/USERID}"
															>add <xsl:value-of select="$name" /> to my contact
															list</a>
													</div>
													<div class="moreinfo">
														<a href="{root}sitehelpprofile#contacts">what is my
															contact list?</a>
													</div>
												</xsl:if>
											</div>
										</xsl:otherwise>
									</xsl:choose>
								</td>
							</tr>
						</table>
					</div>
				</div>
				<!-- column layout -->
				<table border="0" cellpadding="0" cellspacing="0" width="635">
					<tr>
						<td>
							<img alt="" class="tiny" height="1" src="f/t.gif" width="371" />
						</td>
						<td>
							<img alt="" class="tiny" height="1" src="f/t.gif" width="20" />
						</td>
						<td>
							<img alt="" class="tiny" height="1" src="f/t.gif" width="244" />
						</td>
					</tr>
					<tr>
						<td valign="top">
							<!-- main colun-->
							<!-- ################################ INTRO / BIOGRAPHY ############################ -->
							<!-- see userpage_templates.xsl -->
							<xsl:call-template name="USER_BIOGRAPHY" />
							<!-- ###################### MESSAGES for owners ###################### -->
							<!-- see userpage_message_templates.xsl -->
							<xsl:if test="$ownerisviewer = 1">
								<xsl:call-template name="USER_MESSAGES" />
							</xsl:if>
							<!-- ################################ FILMOGRAPHY ############################ -->
							<xsl:if test="$filmPageCount > 0">
								<xsl:call-template name="USER_FILMOGRAPHY" />
							</xsl:if>
							<!-- ################################ CREDITS ############################ -->
							<xsl:if
								test="$creditPageCount > 0 or ($isFilmmaker=1 and $ownerisviewer = 1)">
								<xsl:call-template name="USER_CREDITS" />
							</xsl:if>
							<!-- ################################ SUBMISSIONS ############################ -->
							<xsl:if
								test="($submissionPageCount > 0 or $declinedPageCount > 0) and ($ownerisviewer = 1 or $test_IsEditor)">
								<xsl:call-template name="USER_SUBMISSIONS" />
							</xsl:if>
							<!-- ################################ MAGAZINE FEATURES ############################ -->
							<xsl:if test="$featuresPageCount > 0">
								<xsl:call-template name="USER_FEATURES" />
							</xsl:if>
							<!-- ################################ COMMENTS ############################ -->
							<!-- see userpage_comments_templates.xsl -->
							<xsl:if
								test="$isStandardUser=0 and count(/H2G2/RECENT-POSTS/POST-LIST/POST[SITEID=$site_number]) > 0 ">
								<xsl:call-template name="USER_COMMENTS" />
							</xsl:if>
							<!-- ###################### MESSAGES for other user view ###################### -->
							<xsl:if test="$ownerisviewer != 1 and $isIndustryProf !=1">
								<xsl:call-template name="USER_MESSAGES" />
							</xsl:if>
							<!-- /end main colun-->
						</td>
						<td />
						<td valign="top">
							<!-- right colun-->
							<!-- ###################### CONTACTS ###################### -->
							<xsl:apply-templates mode="c_userpage" select="WATCHED-USER-LIST" />
							<!-- email alerts box -->
							<xsl:if test="$ownerisviewer=1">
								<table border="0" cellpadding="0" cellspacing="0"
									class="smallEmailBox ">
									<tr class="textMedium manageEmails">
										<td class="emailImageCell">
											<img alt="" height="20" id="manageIcon"
												src="http://www.bbc.co.uk/filmnetwork/images/furniture/manage_alerts.gif"
												width="25" />
										</td>
										<td>
											<strong>
												<a href="{$root}alertgroups">manage my email alerts <img
														alt="" height="7"
														src="http://www.bbc.co.uk/filmnetwork/images/furniture/myprofile/arrowdark.gif"
														width="4" />
												</a>
											</strong>
										</td>
									</tr>
									<tr class="profileMoreAbout moreEmails">
										<td class="emailInfoImage">
											<img alt="" height="18"
												src="http://www.bbc.co.uk/filmnetwork/images/furniture/more_alerts.gif"
												width="18" />
										</td>
										<td>
											<a href="sitehelpemailalerts"> more about email
												alerts&nbsp; <img alt="" height="7"
													src="http://www.bbc.co.uk/filmnetwork/images/furniture/myprofile/arrowdark.gif"
													width="4" />
											</a>
										</td>
									</tr>
								</table>
							</xsl:if>
							<!-- ###################### NEWSLETTER ###################### -->
							<!-- newsletter -->
							<xsl:if test="$ownerisviewer = 1 and $isIndustryProf != 1 ">
								<div id="newsletterTitle">
									<strong>newsletter</strong>
								</div>
								<!-- Alistair: change this into a siteconfig -->
								<div class="box default" id="newsletter">
									<script type="text/javascript">
	<xsl:comment>
	//<![CDATA[
	function validate(form){
		var str = form.required_email.value;
		var re = /^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$/;
		if (str == ""){
			alert("Please enter your email address.");
			return false;
		}
		if(!str.match(re)){
			alert("Please check you have typed your email address correctly.");
			return false;
		} 
		return true;
	}
	//]]>
	</xsl:comment>
	</script>
									<form
										action="http://www.bbc.co.uk/cgi-bin/cgiemail/filmnetwork/newsletter/newsletter.txt"
										method="post" name="emailform"
										onsubmit="return validate(this)">
										<input name="success" type="hidden"
											value="http://www.bbc.co.uk/dna/filmnetwork/newsletterthanks" />
										<input name="heading" type="hidden" value="Newsletter" />
										<input name="option" type="hidden" value="subscribe" />
										<p>Regular updates of new films, news and features. We won't
											use your address for anything else.</p>
										<p id="enterEmail">Enter your email below:<br />
											<input name="required_email" size="28" type="text"
												value="your email" /></p>
										<input height="16" id="subscribeBtn" name="subscribe"
											src="{$imagesource}furniture/newsletter_subscribe.gif"
											type="image" value="subscribe" width="77" />
										<div id="exampleNewsletter">
											<div class="arrowlink">
												<a
													href="http://www.bbc.co.uk/filmnetwork/newsletter/examplenewsletter.html"
													target="_new">see example newsletter</a>
												<img alt="" height="7"
													src="{$imagesource}furniture/rightarrow.gif" width="9"
												 />
											</div>
											<p>Newsletter is separate from membership.</p>
										</div>
									</form>
								</div>
							</xsl:if>
							<!-- submit your short -->
							<xsl:if test="$ownerisviewer = 1 and $isFilmmaker = 1 ">
								<a href="{root}Filmsubmit">
									<img alt="submit your short - send us your film" height="108"
										src="{$imagesource}furniture/myprofile/boxlink_submitshort.gif"
										width="244" />
								</a>
							</xsl:if>
							<!-- /end right colun-->
						</td>
					</tr>
				</table>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!--======================================================
	=================RECENT ENTRIES OBJECT====================
	========================================================-->
	<!--
	<xsl:template match="RECENT-ENTRIES" mode="c_userpage">
	Author:		Tom Whitehouse
	Context:      /H2G2/RECENT-ENTRIES
	Purpose:	 Calls the RECENT-ENTRIES container
	-->
	<xsl:template match="RECENT-ENTRIES" mode="c_userpage">
		<xsl:param name="recententriestype" />
		<xsl:apply-templates mode="r_userpage" select=".">
			<xsl:with-param name="recententriestype">
				<xsl:value-of select="$recententriestype" />
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>

	<!--
	<xsl:template match="ARTICLE" mode="r_taguser">
	Use: Presentation of the link to tag a user to the taxonomy
	 -->
	<xsl:template match="ARTICLE" mode="r_taguser">
		<xsl:apply-imports />
		<br />
		<br />
	</xsl:template>

	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
						ARTICLEFORUM Object for the userpage 
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<!-- moved to userpage_message_template.xsl -->
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
							REFERENCES Object for the userpage
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<xsl:template match="REFERENCES" mode="r_userpagerefs">
		<b>References</b>
		<br />
		<xsl:apply-templates mode="c_userpagerefs" select="ENTRIES" />
		<xsl:apply-templates mode="c_userpagerefs" select="USERS" />
		<xsl:apply-templates mode="c_userpagerefsbbc" select="EXTERNAL" />
		<xsl:apply-templates mode="c_userpagerefsnotbbc" select="EXTERNAL" />
	</xsl:template>

	<!-- 
	<xsl:template match="ENTRIES" mode="r_userpagerefs">
	Use: presentation for the 'List of referenced entries' logical container
	-->
	<xsl:template match="ENTRIES" mode="r_userpagerefs">
		<xsl:value-of select="$m_refentries" />
		<br />
		<xsl:apply-templates mode="c_userpagerefs" select="ENTRYLINK" />
		<br />
	</xsl:template>

	<!-- 
	<xsl:template match="ENTRYLINK" mode="r_userpagerefs">
	Use: presentation of each individual entry link
	-->
	<xsl:template match="ENTRYLINK" mode="r_userpagerefs">
		<xsl:apply-imports />
		<br />
	</xsl:template>

	<!-- 
	<xsl:template match="REFERENCES/USERS" mode="r_userpagerefs">
	Use: presentation of of the 'List of referenced users' logical container
	-->
	<xsl:template match="REFERENCES/USERS" mode="r_userpagerefs">
		<xsl:value-of select="$m_refresearchers" />
		<br />
		<xsl:apply-templates mode="c_userpagerefs" select="USERLINK" />
		<br />
		<br />
	</xsl:template>

	<!-- 
	<xsl:template match="USERLINK" mode="r_userpagerefs">
	Use: presentation of each individual link to a user in the references section
	-->
	<xsl:template match="USERLINK" mode="r_userpagerefs">
		<xsl:apply-imports />
		<br />
	</xsl:template>

	<!-- 
	<xsl:template match="EXTERNAL" mode="r_userpagerefsbbc">
	Use: presentation of of the 'List of external BBC sites' logical container
	-->
	<xsl:template match="EXTERNAL" mode="r_userpagerefsbbc">
		<xsl:value-of select="$m_otherbbcsites" />
		<br />
		<xsl:apply-templates mode="c_userpagerefsbbc" select="EXTERNALLINK" />
		<br />
	</xsl:template>

	<!-- 
	<xsl:template match="EXTERNAL" mode="r_userpagerefsnotbbc">
	Use: presentation of of the 'List of external non-BBC sites' logical container
	-->
	<xsl:template match="EXTERNAL" mode="r_userpagerefsnotbbc">
		<xsl:value-of select="$m_refsites" />
		<br />
		<xsl:apply-templates mode="c_userpagerefsnotbbc" select="EXTERNALLINK" />
		<br />
	</xsl:template>

	<!-- 
	<xsl:template match="EXTERNALLINK" mode="r_userpagerefsbbc">
	Use: presentation of each individual external link to a BBC page in the references section
	-->
	<xsl:template match="EXTERNALLINK" mode="r_userpagerefsbbc">
		<xsl:apply-imports />
		<br />
	</xsl:template>

	<!-- 
	<xsl:template match="EXTERNALLINK" mode="r_userpagerefsnotbbc">
	Use: presentation of each individual external link to a non-BBC page in the references section
	-->
	<xsl:template match="EXTERNALLINK" mode="r_userpagerefsnotbbc">
		<xsl:apply-imports />
		<br />
	</xsl:template>

	<!-- my journal -->
	<!--
	<xsl:template match="JOURNAL" mode="r_userpage">
	Description: Presentation of the object holding the userpage journal
	 -->
	<xsl:template match="JOURNAL" mode="r_userpage">
		<xsl:if test="not(JOURNALPOSTS/POST)">
			<div class="box2">
				<xsl:element name="{$text.base}" use-attribute-sets="text.base">
					<xsl:apply-templates mode="t_journalmessage" select="." />
				</xsl:element>
			</div>
		</xsl:if>
		<!-- only show first post -->
		<xsl:apply-templates mode="c_userpagejournalentries"
			select="JOURNALPOSTS/POST[1]" />
		<xsl:apply-templates mode="c_moreuserpagejournals" select="JOURNALPOSTS" />
		<xsl:apply-templates mode="c_adduserpagejournalentry"
			select="/H2G2/JOURNAL/JOURNALPOSTS" />
	</xsl:template>

	<!--
	<xsl:template match="JOURNALPOSTS" mode="r_moreuserpagejournals">
	Description: Presentation of the 'click here to see more entries' link if appropriate
	 -->
	<xsl:template match="JOURNALPOSTS" mode="c_moreuserpagejournals">
		<xsl:apply-templates mode="r_moreuserpagejournals" select="." />
	</xsl:template>

	<!--
	<xsl:template match="JOURNALPOSTS" mode="r_moreuserpagejournals">
	Author:		Tom Whitehouse
	Context:      /H2G2/JOURNAL/JOURNALPOSTS
	Purpose:	 Creates the JOURNAL 'more entries' button 
	-->
	<xsl:template match="JOURNALPOSTS" mode="r_moreuserpagejournals">
		<xsl:param name="img" select="$m_clickmorejournal" />
		<xsl:if test="count(POST)&gt;1">
			<div class="boxactionback">
				<div class="arrow1">
					<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
						<a xsl:use-attribute-sets="mJOURNALPOSTS_MoreJournal">
							<xsl:attribute name="HREF"><xsl:value-of select="$root"
									 />MJ<xsl:value-of select="../../PAGE-OWNER/USER/USERID"
									 />?Journal=<xsl:value-of select="@FORUMID" /></xsl:attribute>
							<xsl:copy-of select="$img" />
						</a>
					</xsl:element>
				</div>
			</div>
		</xsl:if>
	</xsl:template>

	<!--
	<xsl:template match="JOURNALPOSTS" mode="r_adduserpagejournalentry">
	Description: Presentation of the 'add a journal entry' link if appropriate
	 -->
	<xsl:template match="JOURNALPOSTS" mode="r_adduserpagejournalentry">
		<!-- m_clickaddjournal -->
		<div class="boxactionback">
			<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
				<div class="arrow1">
					<xsl:apply-imports />
				</div>
			</xsl:element>
		</div>
	</xsl:template>

	<!--
	<xsl:template match="POST" mode="r_userpagejournalentries">
	Description: Presentation of a single Journal post
	 -->
	<xsl:template match="POST" mode="r_userpagejournalentries">
		<div class="boxheading">
			<xsl:element name="{$text.base}" use-attribute-sets="text.base">
				<xsl:value-of select="SUBJECT" />
			</xsl:element>
		</div>
		<div class="box2">
			<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
				published <xsl:apply-templates mode="t_datejournalposted"
					select="DATEPOSTED/DATE" /> | <xsl:apply-templates
					mode="c_lastjournalrepliesup" select="LASTREPLY" /><br />
			</xsl:element>
			<xsl:element name="{$text.base}" use-attribute-sets="text.base">
				<xsl:apply-templates mode="t_journaltext" select="TEXT" />
			</xsl:element>
		</div>
		<table border="0" cellpadding="0" cellspacing="0" width="400">
			<tr>
				<td class="boxactionback">
					<div class="arrow1">
						<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
							<xsl:apply-templates mode="t_discussjournalentry" select="@POSTID"
							 />
						</xsl:element>
					</div>
				</td>
				<td align="right" class="boxactionback">
					<a href="comments/UserComplaintPage?PostID={@POSTID}&amp;s_start=1"
						onClick="popupwindow('comments/UserComplaintPage?PostID={@POSTID}&amp;s_start=1', 'ComplaintPopup', 'status=1,resizable=1,scrollbars=1,width=640,height=480')"
						target="ComplaintPopup"
						xsl:use-attribute-sets="maHIDDEN_r_complainmp">
						<xsl:copy-of select="$alt_complain" />
					</a>
				</td>
			</tr>
		</table>
		<!-- EDIT AND MODERATION HISTORY -->
		<xsl:if test="$test_IsEditor">
			<div class="moderationbox">
				<div align="right">
					<img align="left" alt="" border="0" height="21"
						src="{$graphics}icons/icon_editorsedit.gif" width="23" />
					<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
						<xsl:apply-templates mode="c_editmp" select="@POSTID" />
						<xsl:text>  </xsl:text> | <xsl:text>  </xsl:text>
						<xsl:apply-templates mode="c_linktomoderate" select="@POSTID" />
					</xsl:element>
				</div>
			</div>
		</xsl:if>
	</xsl:template>

	<!--
	<xsl:template match="LASTREPLY" mode="r_lastjournalrepliesup">
	Description: Object is used if there are replies to a journal entry
	 -->
	<xsl:template match="LASTREPLY" mode="r_lastjournalrepliesup">
		<xsl:apply-templates mode="t_journalentriesreplies" select="../@THREADID" />
	</xsl:template>
	<xsl:template name="noJournalReplies">
		<xsl:value-of select="$m_noreplies" />
	</xsl:template>

	<!--
	<xsl:template match="@THREADID" mode="r_removejournalpost">
	Description: Display of the 'remove journal entry' link if appropriate
	 -->
	<xsl:template match="@THREADID" mode="r_removejournalpost">
		<xsl:apply-imports />
	</xsl:template>

	<!--
	<xsl:template match="ARTICLE-LIST" mode="c_userpagelist">
	Author:		Tom Whitehouse
	Context:      /H2G2/RECENT-ENTRIES/ARTICLE-LIST
	Purpose:	 Calls the correct ARTICLE-LIST container
	-->
	<xsl:template match="ARTICLE-LIST" mode="c_userpagelist">
		<xsl:param name="recententriestype" />
		<xsl:choose>
			<xsl:when test="$ownerisviewer = 1">
				<xsl:apply-templates mode="ownerfull_userpagelist" select=".">
					<xsl:with-param name="recententriestype">
						<xsl:value-of select="$recententriestype" />
					</xsl:with-param>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates mode="viewerfull_userpagelist" select=".">
					<xsl:with-param name="recententriestype">
						<xsl:value-of select="$recententriestype" />
					</xsl:with-param>
				</xsl:apply-templates>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="ARTICLE-LIST" mode="ownerfull_userpagelist">
		<xsl:param name="recententriestype" />
		<xsl:apply-templates mode="c_userpagelist"
			select="ARTICLE[position() &lt;=$articlelimitentries]">
			<xsl:with-param name="recententriestype">
				<xsl:value-of select="$recententriestype" />
			</xsl:with-param>
		</xsl:apply-templates>
		<xsl:apply-templates mode="c_morearticles" select="." />
	</xsl:template>

	<!--
	<xsl:template match="ARTICLE" mode="c_userpagelist">
	Author:		Tom Whitehouse
	Context:      /H2G2/RECENT-ENTRIES/ARTICLE-LIST
	Purpose:	 Calls the ARTICLE container
	-->
	<xsl:template match="ARTICLE" mode="c_userpagelist">
		<xsl:param name="recententriestype" />
		<xsl:if test="EXTRAINFO/TYPE/@ID &lt; 1001">
			<xsl:apply-templates mode="r_userpagelist" select=".">
				<xsl:with-param name="recententriestype">
					<xsl:value-of select="$recententriestype" />
				</xsl:with-param>
			</xsl:apply-templates>
		</xsl:if>
	</xsl:template>

	<xsl:template match="ARTICLE-LIST" mode="viewerfull_userpagelist">
		<xsl:apply-templates mode="c_userpagelist"
			select="ARTICLE[position() &lt;=$articlelimitentries]" />
	</xsl:template>

	<xsl:template name="r_createnewarticle">
		<xsl:param name="content" select="$m_clicknewentry" />
		<xsl:copy-of select="$content" />
	</xsl:template>

	<xsl:template match="ARTICLE-LIST" mode="r_morearticles">
		<!-- more submissions table -->
		<table border="0" cellpadding="0" cellspacing="0" width="371">
			<tr>
				<td valign="top" width="371">
					<div class="morecommments">
						<strong>
							<a href="{$root}MA{/H2G2/RECENT-ENTRIES/USER/USERID}?type=2"
								xsl:use-attribute-sets="mARTICLE-LIST_r_morearticles"> more
								submissions</a>
						</strong>&nbsp;<img alt="" height="7"
							src="{$imagesource}furniture/myprofile/arrowdark.gif" width="4" />
					</div>
				</td>
			</tr>
		</table>
	</xsl:template>

	<xsl:template match="RECENT-ENTRIES" mode="owner_userpagelistempty">
		<div class="box2">
			<xsl:element name="{$text.base}" use-attribute-sets="text.base"
			> </xsl:element>
		</div>
	</xsl:template>

	<xsl:template match="RECENT-ENTRIES" mode="viewer_userpagelistempty">
		<div class="box2">
			<xsl:element name="{$text.base}" use-attribute-sets="text.base"
			> </xsl:element>
		</div>
	</xsl:template>

	<!--
	<xsl:template match="ARTICLE" mode="r_userpagelist">
	Description: Presentation of a single article item within a list
	 -->
	<xsl:template match="ARTICLE" mode="r_userpagelist">
		<xsl:param name="recententriestype" />
		<xsl:value-of select="$recententriestype" />dd <xsl:choose>
			<xsl:when test="STATUS=1">
				<table border="0" cellpadding="0" cellspacing="0" width="371">
					<tr>
						<td valign="top" width="31">
							<xsl:variable name="article_small_gif">
								<xsl:choose>
									<xsl:when test="$showfakegifs = 'yes'">A3923219_small.jpg</xsl:when>
									<xsl:otherwise>A<xsl:value-of select="H2G2-ID"
									 />_small.jpg</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
							<img alt="" height="30"
								src="{$imagesource}{$gif_assets}{$article_small_gif}" width="31"
							 />
						</td>
						<td valign="top" width="340">
							<div class="titlefilmography">
								<strong>
									<xsl:apply-templates mode="t_userpagearticle" select="SUBJECT"
									 />
								</strong>
							</div>
							<div class="smallsubmenu"><xsl:choose>
									<xsl:when test="EXTRAINFO/TYPE/@ID = 30">
										<a class="textdark" href="{$root}C{$genreDrama}">
											<xsl:value-of
												select="msxsl:node-set($type)/type[@number=30 or @selectnumber=30]/@subtype"
											 />
										</a>
									</xsl:when>
									<xsl:when test="EXTRAINFO/TYPE/@ID = 31">
										<a class="textdark" href="{$root}C{$genreComedy}">
											<xsl:value-of
												select="msxsl:node-set($type)/type[@number=31 or @selectnumber=31]/@subtype"
											 />
										</a>
									</xsl:when>
									<xsl:when test="EXTRAINFO/TYPE/@ID = 32">
										<a class="textdark" href="{$root}C{$genreDocumentry}">
											<xsl:value-of
												select="msxsl:node-set($type)/type[@number=32 or @selectnumber=32]/@subtype"
											 />
										</a>
									</xsl:when>
									<xsl:when test="EXTRAINFO/TYPE/@ID = 33">
										<a class="textdark" href="{$root}C{$genreAnimation}">
											<xsl:value-of
												select="msxsl:node-set($type)/type[@number=33 or @selectnumber=33]/@subtype"
											 />
										</a>
									</xsl:when>
									<xsl:when test="EXTRAINFO/TYPE/@ID = 34">
										<a class="textdark" href="{$root}C{$genreExperimental}">
											<xsl:value-of
												select="msxsl:node-set($type)/type[@number=34 or @selectnumber=34]/@subtype"
											 />
										</a>
									</xsl:when>
									<xsl:when test="EXTRAINFO/TYPE/@ID = 35">
										<a class="textdark" href="{$root}C{$genreMusic}">
											<xsl:value-of
												select="msxsl:node-set($type)/type[@number=35 or @selectnumber=35]/@subtype"
											 />
										</a>
									</xsl:when>
								</xsl:choose> | <xsl:value-of select="DATE-CREATED/DATE/@DAY"
									 />&nbsp;<xsl:value-of
									select="substring(DATE-CREATED/DATE/@MONTHNAME, 1, 3)"
									 />&nbsp;<xsl:value-of
									select="substring(DATE-CREATED/DATE/@YEAR, 3, 4)"
								 /><!-- </a> --></div>
						</td>
					</tr>
					<tr>
						<td colspan="2" height="10" width="371" />
					</tr>
				</table>
			</xsl:when>
			<xsl:when test="STATUS = 3">
				<!-- DISPLAY CREDIT  --><!-- added trent film 2 --> CREDIT <table
					border="0" cellpadding="0" cellspacing="0" width="371">
					<tr>
						<td valign="top" width="31">
							<xsl:variable name="article_small_gif">
								<xsl:choose>
									<xsl:when test="$showfakegifs = 'yes'">A3923219_small.jpg</xsl:when>
									<xsl:otherwise>A<xsl:value-of select="H2G2-ID"
									 />_small.jpg</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
							<img alt="" height="30"
								src="{$imagesource}{$gif_assets}{$article_small_gif}" width="31"
							 />
						</td>
						<td valign="top" width="340">
							<div class="titlefilmography">
								<strong>
									<xsl:apply-templates mode="t_userpagearticle" select="SUBJECT"
									 />
								</strong>
							</div>
							<div class="smallsubmenu"><xsl:choose>
									<xsl:when test="EXTRAINFO/TYPE/@ID = 70">
										<a class="textdark" href="{$root}C{$genreDrama}">
											<xsl:value-of
												select="msxsl:node-set($type)/type[@number=70 or @selectnumber=70]/@subtype"
											 />
										</a>
									</xsl:when>
									<xsl:when test="EXTRAINFO/TYPE/@ID = 71">
										<a class="textdark" href="{$root}C{$genreComedy}">
											<xsl:value-of
												select="msxsl:node-set($type)/type[@number=71 or @selectnumber=71]/@subtype"
											 />
										</a>
									</xsl:when>
									<xsl:when test="EXTRAINFO/TYPE/@ID = 72">
										<a class="textdark" href="{$root}C{$genreDocumentry}">
											<xsl:value-of
												select="msxsl:node-set($type)/type[@number=72 or @selectnumber=72]/@subtype"
											 />
										</a>
									</xsl:when>
									<xsl:when test="EXTRAINFO/TYPE/@ID = 73">
										<a class="textdark" href="{$root}C{$genreAnimation}">
											<xsl:value-of
												select="msxsl:node-set($type)/type[@number=73 or @selectnumber=73]/@subtype"
											 />
										</a>
									</xsl:when>
									<xsl:when test="EXTRAINFO/TYPE/@ID = 74">
										<a class="textdark" href="{$root}C{$genreExperimental}">
											<xsl:value-of
												select="msxsl:node-set($type)/type[@number=74 or @selectnumber=74]/@subtype"
											 />
										</a>
									</xsl:when>
									<xsl:otherwise>
										<a class="textdark" href="{$root}C{$genreMusic}">
											<xsl:value-of
												select="msxsl:node-set($type)/type[@number=75 or @selectnumber=75]/@subtype"
											 />
										</a>
									</xsl:otherwise>
								</xsl:choose> | <xsl:value-of select="DATE-CREATED/DATE/@DAY"
									 />&nbsp;<xsl:value-of
									select="substring(DATE-CREATED/DATE/@MONTHNAME, 1, 3)"
									 />&nbsp;<xsl:value-of
									select="substring(DATE-CREATED/DATE/@YEAR, 3, 4)"
								 /><!-- </a> --></div>
						</td>
					</tr>
					<tr>
						<td colspan="2" height="10" width="371" />
					</tr>
				</table>
				<!-- 		</xsl:if>
 -->
			</xsl:when>
			<xsl:when test="STATUS=3 and EXTRAINFO/TYPE/@ID[substring(.,1,1) = '3']">
				<!-- DISPLAY SUBMISSION  --><!-- added trent film 2 -->
			</xsl:when>
			<xsl:otherwise> submission <!-- only shows films to normal users -->
				<xsl:if
					test="($test_IsEditor or (EXTRAINFO/TYPE/@ID[substring(.,1,1) = '3'] or EXTRAINFO/TYPE/@ID[substring(.,1,1) = '5'])) and SITEID = $site_number">
					<table border="0" cellpadding="0" cellspacing="0" width="371">
						<tr>
							<td valign="top" width="276">
								<xsl:attribute name="class">
									<xsl:choose>
										<xsl:when test="count(preceding-sibling::ARTICLE) mod 2 = 0"
											>lightband</xsl:when>
										<xsl:otherwise>darkband</xsl:otherwise>
									</xsl:choose>
								</xsl:attribute>
								<div class="titlecentcol">
									<img align="absmiddle" alt="" height="5"
										src="{$imagesource}furniture/myprofile/bullett.gif"
										width="5" />
									<strong>&nbsp;<xsl:apply-templates
											mode="t_userpagearticle" select="SUBJECT" /></strong>
								</div>
								<div class="smallsubmenu2">
									<xsl:choose>
										<xsl:when test="EXTRAINFO/TYPE/@ID = 30">
											<a class="textdark" href="{$root}C{$genreDrama}">
												<xsl:value-of
													select="msxsl:node-set($type)/type[@number=30 or @selectnumber=30]/@subtype"
												 />
											</a>
										</xsl:when>
										<xsl:when test="EXTRAINFO/TYPE/@ID = 31">
											<a class="textdark" href="{$root}C{$genreComedy}">
												<xsl:value-of
													select="msxsl:node-set($type)/type[@number=31 or @selectnumber=31]/@subtype"
												 />
											</a>
										</xsl:when>
										<xsl:when test="EXTRAINFO/TYPE/@ID = 32">
											<a class="textdark" href="{$root}C{$genreDocumentry}">
												<xsl:value-of
													select="msxsl:node-set($type)/type[@number=32 or @selectnumber=32]/@subtype"
												 />
											</a>
										</xsl:when>
										<xsl:when test="EXTRAINFO/TYPE/@ID = 33">
											<a class="textdark" href="{$root}C{$genreAnimation}">
												<xsl:value-of
													select="msxsl:node-set($type)/type[@number=33 or @selectnumber=33]/@subtype"
												 />
											</a>
										</xsl:when>
										<xsl:when test="EXTRAINFO/TYPE/@ID = 34">
											<a class="textdark" href="{$root}C{$genreExperimental}">
												<xsl:value-of
													select="msxsl:node-set($type)/type[@number=34 or @selectnumber=34]/@subtype"
												 />
											</a>
										</xsl:when>
										<xsl:when test="EXTRAINFO/TYPE/@ID = 35">
											<a class="textdark" href="{$root}C{$genreMusic}">
												<xsl:value-of
													select="msxsl:node-set($type)/type[@number=35 or @selectnumber=35]/@subtype"
												 />
											</a>
										</xsl:when>
									</xsl:choose> | <xsl:value-of select="DATE-CREATED/DATE/@DAY"
									 />&nbsp; <xsl:value-of
										select="substring(DATE-CREATED/DATE/@MONTHNAME, 1, 3)"
									 />&nbsp; <xsl:value-of
										select="substring(DATE-CREATED/DATE/@YEAR, 3, 4)" />
								</div>
							</td>
							<td width="24">
								<xsl:attribute name="class">
									<xsl:choose>
										<xsl:when test="count(preceding-sibling::ARTICLE) mod 2 = 0"
											>lightband</xsl:when>
										<xsl:otherwise>darkband</xsl:otherwise>
									</xsl:choose>
								</xsl:attribute>
								<img alt="" height="24"
									src="{$imagesource}furniture/myprofile/newsubmiticon.gif"
									width="24" />
							</td>
							<td width="71">
								<xsl:attribute name="class">
									<xsl:choose>
										<xsl:when test="count(preceding-sibling::ARTICLE) mod 2 = 0"
											>lightband</xsl:when>
										<xsl:otherwise>darkband</xsl:otherwise>
									</xsl:choose>
								</xsl:attribute>
								<div class="endbox">
									<xsl:choose>
										<xsl:when test="STATUS=3">new</xsl:when>
										<xsl:otherwise>declined</xsl:otherwise>
									</xsl:choose>
									<br />submission </div>
							</td>
						</tr>
					</table>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!--
	<xsl:template match="H2G2-ID" mode="r_uncancelarticle">
	Description: Presentation of the 'uncancel this article' link
	 -->
	<xsl:template match="H2G2-ID" mode="r_uncancelarticle">
		(<xsl:apply-imports />) </xsl:template>

	<!--
	<xsl:template match="H2G2-ID" mode="c_editarticle">
	Author:		Tom Whitehouse
	Context:      /H2G2/RECENT-ENTRIES/ARTICLE-LIST/ARTICLE/H2G2-ID
	Purpose:	 Calls the 'Edit this article' link container
	-->
	<xsl:template match="H2G2-ID" mode="c_editarticle">
		<xsl:if
			test="($ownerisviewer = 1) and (../STATUS = 1 or ../STATUS = 3 or ../STATUS = 4) and (../EDITOR/USER/USERID = $viewerid)">
			<xsl:apply-templates mode="r_editarticle" select="." />
		</xsl:if>
	</xsl:template>

	<!--
	<xsl:template match="H2G2-ID" mode="r_editarticle">
	Description: Presentation of the 'edit this article' link
	 -->
	<xsl:template match="H2G2-ID" mode="r_editarticle">
		<!-- edit article -->
		<!-- uses m_edit for image -->
		<a href="{$root}TypedArticle?aedit=new&amp;h2g2id={.}"
			xsl:use-attribute-sets="mH2G2-ID_r_editarticle">
			<xsl:copy-of select="$m_editme" />
		</a>
	</xsl:template>

	<!--
	<xsl:template match="RECENT-APPROVALS" mode="r_userpage">
	Description: Presentation of the Edited Articles Object
	 -->
	<xsl:template match="RECENT-APPROVALS" mode="r_userpage">
		<xsl:apply-templates mode="c_approvalslistempty" select="." />
		<xsl:apply-templates mode="c_approvalslist" select="ARTICLE-LIST" />
	</xsl:template>

	<!--
	<xsl:template match="ARTICLE-LIST" mode="owner_approvalslist">
	Description: Presentation of the list of edited articles when the viewer is the owner
	 -->
	<xsl:template match="ARTICLE-LIST" mode="owner_approvalslist">
		<xsl:apply-templates mode="c_userpagelist"
			select="ARTICLE[position() &lt;=$articlelimitentries]" />
		<xsl:apply-templates mode="c_moreeditedarticles" select="." />
	</xsl:template>

	<!--
	<xsl:template match="ARTICLE-LIST" mode="viewer_approvalslist">
	Description: Presentation of the list of edited articles when the viewer is not the owner
	 -->
	<xsl:template match="ARTICLE-LIST" mode="viewer_approvalslist">
		<!--<xsl:copy-of select="$m_editviewerfull"/>-->
		<xsl:apply-templates mode="c_userpagelist"
			select="ARTICLE[position() &lt;=$articlelimitentries]" />
		<xsl:apply-templates mode="c_moreeditedarticles" select="." />
	</xsl:template>

	<!--
	<xsl:template match="ARTICLE-LIST" mode="r_moreeditedarticles">
	Description: Presentation of the 'See more edited articles' link
	 -->
	<xsl:template match="ARTICLE-LIST" mode="r_moreeditedarticles">
		<!-- more films table -->
		<table border="0" cellpadding="0" cellspacing="0" width="371">
			<tr>
				<td valign="top" width="371">
					<div class="morecommments"><strong>
							<a href="{$root}MA{/H2G2/RECENT-APPROVALS/USER/USERID}?type=1"
								xsl:use-attribute-sets="mARTICLE-LIST_r_moreeditedarticles">
								more films </a>
						</strong>&nbsp;<img alt="" height="7"
							src="{$imagesource}furniture/myprofile/arrowdark.gif" width="4"
					 /></div>
				</td>
			</tr>
		</table>
	</xsl:template>

	<!--
	<xsl:template match="ARTICLE-LIST" mode="r_moresubmissions">
	Description: Presentation of the 'See more submissions' link
	 -->
	<xsl:template match="ARTICLE-LIST" mode="r_moresubmissions">
		<!-- more films table -->
		<table border="0" cellpadding="0" cellspacing="0" width="371">
			<tr>
				<td valign="top" width="371">
					<div class="morecommments"><strong>
							<a href="{$root}MA{/H2G2/RECENT-ENTRIES/USER/USERID}?type=1"
								xsl:use-attribute-sets="mARTICLE-LIST_r_moreeditedarticles">
								more films </a>
						</strong>&nbsp;<img alt="" height="7"
							src="{$imagesource}furniture/myprofile/arrowdark.gif" width="4"
					 /></div>
				</td>
			</tr>
		</table>
		<!-- END more films table -->
	</xsl:template>

	<!--
	<xsl:template match="RECENT-APPROVALS" mode="owner_approvalslistempty">
	Description: Presentation of an empty list of edited articles when the viewer is the owner
	 -->
	<xsl:template match="RECENT-APPROVALS" mode="owner_approvalslistempty"> </xsl:template>

	<!--
	<xsl:template match="RECENT-APPROVALS" mode="viewer_approvalslistempty">
	Description: Presentation of an empty list of edited articles when the viewer is not the owner
	 -->
	<xsl:template match="RECENT-APPROVALS" mode="viewer_approvalslistempty"> </xsl:template>

	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

							PAGE-OWNER Object
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<!--
	<xsl:template match="PAGE-OWNER" mode="r_userpage">
	Description: Presentation of the Page Owner object
	 -->
	<xsl:template match="PAGE-OWNER" mode="r_userpage">
		<b>
			<xsl:value-of select="$m_userdata" />
		</b>
		<br />
		<xsl:value-of select="$m_researcher" />
		<xsl:value-of select="USER/USERID" />
		<br />
		<xsl:value-of select="$m_namecolon" />
		<xsl:value-of select="$name" />
		<br />
		<xsl:apply-templates mode="c_inspectuser" select="USER/USERID" />
		<xsl:apply-templates mode="c_editmasthead" select="." />
		<xsl:apply-templates mode="c_addtofriends" select="USER/USERID" />
		<xsl:apply-templates mode="c_userpage" select="USER/GROUPS" />
	</xsl:template>

	<xsl:template match="PAGE-OWNER" mode="c_usertitle">

		<xsl:element name="{$text.heading}" use-attribute-sets="text.heading">
			<span class="headinguser">
				<a href="{$root}U{USER/USERID}">
					<xsl:value-of select="$name" />
				</a>
			</span>
		</xsl:element>

	</xsl:template>

	<!--
	<xsl:template match="USERID" mode="r_inspectuser">
	Description: Presentation of the 'Inspect this user' link
	 -->
	<xsl:template match="USERID" mode="r_inspectuser">
		<xsl:apply-imports />
		<br />
	</xsl:template>

	<!--
	<xsl:template match="PAGE-OWNER" mode="r_editmasthead">
	Description: Presentation of the 'Edit my Introduction' link
	 -->
	<xsl:template match="PAGE-OWNER" mode="r_editmasthead">
		<xsl:apply-imports />
		<br />
	</xsl:template>

	<!--
	<xsl:template match="USERID" mode="r_addtofriends">
	Description: Presentation of the 'Add to my friends' link
	 -->
	<xsl:template match="USERID" mode="r_addtofriends">
		<xsl:apply-imports />
		<br />
		<br />
	</xsl:template>

	<!--
	<xsl:template match="GROUPS" mode="r_userpage">
	Description: Presentation of the GROUPS object
	 -->
	<xsl:template match="GROUPS" mode="r_userpage">
		<xsl:value-of select="$m_memberof" />
		<br />
		<xsl:apply-templates />
		<br />
	</xsl:template>

	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
								LINKS Object
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<xsl:template match="LINKS" mode="r_userpage">
		<xsl:apply-templates mode="t_folderslink" select="." />
		<br />
		<hr />
	</xsl:template>

	<!--
	<xsl:template name="USERPAGE_HEADER">
	Author:		Andy Harris
	Context:      /H2G2
	Purpose:	 Creates the title for the page which sits in the html header
	-->
	<xsl:template name="USERPAGE_HEADER">
		<xsl:apply-templates mode="header" select=".">
			<xsl:with-param name="title">
				<xsl:choose>
					<xsl:when test="ARTICLE/SUBJECT">
						<xsl:value-of select="$m_pagetitlestart" />
						<xsl:value-of select="$name" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:choose>
							<xsl:when test="$ownerisviewer = 1">
								<xsl:value-of select="$m_pagetitlestart" />
								<xsl:value-of select="$m_pstitleowner" />
								<xsl:value-of select="PAGE-OWNER/USER/USERNAME" />.</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$m_pagetitlestart" />
								<xsl:value-of select="$m_pstitleviewer" /> .</xsl:otherwise>
						</xsl:choose>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>

	<!-- two templates to add the add place/specialism input boxes -->
	<xsl:template name="add_place_specialism_inputs">
		<xsl:param name="doc_node" />
		<xsl:param name="type" />
		<input name="node" type="{$type}" value="{server[@name = $server]/@cnum}">
			<xsl:if
				test="server[@name = $server]/@cnum = $doc_node/H2G2/ARTICLE/ARTICLEINFO/CRUMBTRAILS/CRUMBTRAIL/ANCESTOR[4]/NODEID">
				<xsl:attribute name="checked">checked</xsl:attribute>
			</xsl:if>
		</input>
		<label class="formLabel" for="name">
			<xsl:value-of select="@label" />
		</label>
		<br />
	</xsl:template>

	<xsl:variable name="test_introarticle_ifilm"
		select="/H2G2/ARTICLE/GUIDE[string-length(BODY) &gt; 0] or /H2G2/ARTICLE/GUIDE[string-length(PROJECTINDEVELOPMENT) &gt; 0] or /H2G2/ARTICLE/GUIDE[string-length(FAVFILMS) &gt; 0] or /H2G2/ARTICLE/GUIDE[string-length(TBC) &gt; 0] or /H2G2/ARTICLE/GUIDE[string-length(MYLINKS1) &gt; 0] or /H2G2/ARTICLE/GUIDE[string-length(MYLINKS2) &gt; 0] or /H2G2/ARTICLE/GUIDE[string-length(MYLINKS3) &gt; 0]" />

</xsl:stylesheet>
