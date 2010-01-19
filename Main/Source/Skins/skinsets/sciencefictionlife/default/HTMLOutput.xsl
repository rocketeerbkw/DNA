<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
	<!ENTITY arrow "&#9658;">
]>



<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">


	<!--=============== Imported Files =====================-->
	<xsl:import href="../../../base/base-extra.xsl"/>
	
		
	<!--=============== Included Files =====================-->

	<xsl:include href="scifi-sitevars.xsl"/>
	<xsl:include href="scifitext.xsl"/>	
	<xsl:include href="scifiicons.xsl"/>
	<xsl:include href="scifitips.xsl"/>
	<xsl:include href="scifibuttons.xsl"/>
	<xsl:include href="debug.xsl"/>	
    <xsl:include href="promos.xsl"/>
	<xsl:include href="seealsopromos.xsl"/>
	<xsl:include href="siteconfigpromos.xsl"/>
	<xsl:include href="guideml.xsl"/>
	<xsl:include href="types.xsl"/>
	<xsl:include href="addjournalpage.xsl"/>
	<xsl:include href="addthreadpage.xsl"/>
	<xsl:include href="articlepage.xsl"/>
	<xsl:include href="categorypage.xsl"/>
	<xsl:include href="categories.xsl"/>
	<xsl:include href="keyarticle-editorpage.xsl"/>
	<xsl:include href="editcategorypage.xsl"/>
	<xsl:include href="frontpage.xsl"/>
	<xsl:include href="indexpage.xsl"/>
	<xsl:include href="infopage.xsl"/>
	<xsl:include href="journalpage.xsl"/>
	<xsl:include href="miscpage.xsl"/>
	<xsl:include href="monthpage.xsl"/>
	<xsl:include href="morearticlespage.xsl"/>
	<xsl:include href="morepostspage.xsl"/>
	<xsl:include href="multipostspage.xsl"/>
	<xsl:include href="myconversationspopup.xsl"/>
	<xsl:include href="newuserspage.xsl"/>
	<!--xsl:include href="noticeboardpage.xsl"/-->
	<!--xsl:include href="onlinepopup.xsl"/-->
	<xsl:include href="registerpage.xsl"/>	
	<!--xsl:include href="reviewforumpage.xsl"/-->
	<xsl:include href="searchpage.xsl"/>
	<xsl:include href="siteconfigpage.xsl"/>
	<!--xsl:include href="submitreviewforumpage.xsl"/-->
	
	<xsl:include href="tagitempage.xsl"/>
	<!--xsl:include href="teamlistpage.xsl"/-->
	<xsl:include href="threadspage.xsl"/>
	<xsl:include href="typedarticlepage.xsl"/>
	<xsl:include href="usercomplaintpopup.xsl"/>
	<xsl:include href="userdetailspage.xsl"/>
	<xsl:include href="usereditpage.xsl"/>
	<!--xsl:include href="usermyclubspage.xsl"/-->
	<xsl:include href="userpage.xsl"/>
	<!--xsl:include href="votepage.xsl"/-->
	<!--xsl:include href="watcheduserspage.xsl"/-->


	<!--=============== Global Variables =====================-->
	<xsl:variable name="skinname">sciencefictionlife</xsl:variable><!-- collective changed -->
	<xsl:variable name="scopename">mysciencefictionlife</xsl:variable><!-- collective changed -->
	<xsl:variable name="environment_colour">#ff00000</xsl:variable>
	<xsl:variable name="environment_text">Beta</xsl:variable>
	<xsl:variable name="imagesource" select="'http://www.bbc.co.uk/mysciencefictionlife/dnafurniture/'"/>  
	<xsl:variable name="promos" select="'http://www.bbc.co.uk/mysciencefictionlife/dnapromos/'"/> 
	<xsl:variable name="smileysource" select="'http://www.bbc.co.uk/mysciencefictionlife/dnasmileys/'"/> 
	<xsl:output method="html" version="4.0" omit-xml-declaration="yes" standalone="yes" indent="yes" encoding="iso-8859-1" doctype-public="-//W3C//DTD HTML 4.01 Transitional//EN" />

	<!-- CSS -->
	<xsl:variable name="csslink">
	
		<!-- link type="text/css" rel="stylesheet" title="default" href="http://www.bbc.co.uk/collective/includes/DEBUG_vanilla.css" -->
		<!--<link type="text/css" rel="alternate stylesheet" title="vanilla" href="http://www.bbc.co.uk/collective/includes/vanilla.css"/>-->
		<style type="text/css">
			<xsl:comment>
				<!-- Trent --><!-- Changed CSS, so be sure to have new version on live -->
				<!-- @import url(http://www.bbc.co.uk/mysciencefictionlife/includes/sciencefiction.css); -->
					@import url(http://www.bbc.co.uk/mysciencefictionlife/includes/sciencefiction_closed.css);
			</xsl:comment>
		</style>

		<xsl:comment><![CDATA[[if lte IE 6]>
			<style media="all" type="text/css">
				@import url(http://www.bbc.co.uk/mysciencefictionlife/includes/sciencefiction_ie6.css);
			</style>
		<![endif]]]></xsl:comment>

		<xsl:call-template name="insert-css"/>
	</xsl:variable>
	
	<!-- JAVASCRIPT -->
	<xsl:variable name="scriptlink">
		
	
		<script language="JavaScript" type="text/javascript">
		<xsl:comment><![CDATA[ 

		function popupwindow(link, target, parameters) 
		{
			popupWin = window.open(link,target,parameters);
		}

		function popmailwin(x, y){
			window.open(x,y,'status=no,scrollbars=yes,resizable=yes,width=350,height=400');
		}


				form_string_content = '';
				submitOK = true;
				function submitForm(){
					submitOK = true;
					form_string_content = '';//will hold xml version of content to submit to database


					for(i=0; i < document.theForm.length; i++){

						if (document.theForm[i].name == 'emailcheckbox'){
							if (document.theForm[i].checked == true){
									createXML_NONMandatory(document.theForm[i].name, 'YES');
							}

                        } else if (document.theForm[i].name == 'encap'){
							createXML_Mandatory(document.theForm[i].name, document.theForm[i].value);
						
						} else if (document.theForm[i].name == 'time'){
							createXML_Mandatory(document.theForm[i].name, document.theForm[i].value);
						
						} else if (document.theForm[i].name == 'revelations'){
							createXML_Mandatory(document.theForm[i].name, document.theForm[i].value);
						
						} else if (document.theForm[i].name == 'subject'){
							createXML_Mandatory(document.theForm[i].name, document.theForm[i].value);

						} else if (document.theForm[i].name == 'beforetitle'){
							createXML_NONMandatory(document.theForm[i].name, document.theForm[i].value);

						} else if (document.theForm[i].name == 'beforetext'){
							createXML_NONMandatory(document.theForm[i].name, document.theForm[i].value);

						} else if (document.theForm[i].name == 'aftertitle'){
							createXML_NONMandatory(document.theForm[i].name, document.theForm[i].value);

						} else if (document.theForm[i].name == 'aftertext'){
							createXML_NONMandatory(document.theForm[i].name, document.theForm[i].value);

						} else if (document.theForm[i].name == 'creator'){
							createXML_NONMandatory(document.theForm[i].name, document.theForm[i].value);

						} else if (document.theForm[i].name == 'tagline'){
							createXML_NONMandatory(document.theForm[i].name, document.theForm[i].value);

						} else if (document.theForm[i].name == 'option1'){
								createXML_NONMandatory(document.theForm[i].name, document.theForm[i].options[document.theForm[i].selectedIndex].value);

						} else if (document.theForm[i].name == 'option2'){
								createXML_NONMandatory(document.theForm[i].name, document.theForm[i].options[document.theForm[i].selectedIndex].value);	

						} else if (document.theForm[i].name == 'option3'){
								createXML_NONMandatory(document.theForm[i].name, document.theForm[i].options[document.theForm[i].selectedIndex].value);		
						} 
						
					}
					 
										
					value = form_string_content.toString();
					//alert(document.theForm.body.value);



					//now add break tags, allowing for diff browsers in order
					rExp1 = /\r\n/gi;
					rExp2 = /\r/gi;
					rExp3 = /\n/gi;

					value = value.replace(rExp1,"<br/>");
					value = value.replace(rExp2,"<br/>");
					value = value.replace(rExp3,"<br/>");
				

					document.theForm.body.value = value;
					if (submitOK){
						document.theForm.submit();
						return true;
					} else {
						return false;
					}
					
					//alert(form_string_content);
						
						
				}

				function createXML_Mandatory(name, value){
						if (stripSpaces(value) == ''){
							if (submitOK){//only show error once.
								alert('All mandatory text fields are not filled in. Please correct this.');
							}
							document.getElementById('mandatoryFields').style.display = 'inline';
							document.getElementById('mandatoryFields2').style.display = 'inline';
							document.getElementById('mandatoryFields3').style.display = 'inline';
							document.getElementById('mandatoryFields4').style.display = 'inline';
							document.getElementById('manmessage').style.display = 'block';
							submitOK = false;
						} else {
							form_string_content += '<' + name + '>' + xmlPrep(value) + '</' + name + '>';
						}
				}

				function createXML_NONMandatory(name, value){
						form_string_content += '<' + name + '>' + xmlPrep(value) + '</' + name + '>';
				}

				function stripSpaces(x) {
				    while (x.substring(0,1) == ' ') x = x.substring(1);
				    while (x.substring(x.length-1,x.length) == ' ') x = x.substring(0,x.length-1);
				    return x;
				}

				function xmlPrep(value){

					//PREPARE DATA FOR XML
					// replace xml characters
					rExp1 = /&gt;/gi;
					value = value.replace(rExp1,">");
					rExp2 = /&lt;/gi;
					value = value.replace(rExp2,"<");
					rExp3 = /&amp;/gi;
					value = value.replace(rExp3,"&");
					rExp4 = /&/gi;
					value = value.replace(rExp4,"&amp;");
					rExp5 = /</gi;
					value = value.replace(rExp5,"&lt;");
					rExp6 = />/gi;
					value = value.replace(rExp6,"&gt;");
					return value;

				}


		]]>	<xsl:text>//</xsl:text></xsl:comment>
		</script>

	</xsl:variable>
	
	<!-- METADATA -->
	<xsl:variable name="meta-tags">

		<!-- METADATA FOR SEARCH ENGINES -->
		<meta name="description">
			<xsl:attribute name="content">
				<xsl:choose>
					<xsl:when test="/H2G2/ARTICLE/EXTRAINFO/DESCRIPTION"><xsl:value-of select="/H2G2/ARTICLE/EXTRAINFO/DESCRIPTION" /></xsl:when>
					<xsl:when test="/H2G2/@TYPE='FRONTPAGE'"><xsl:value-of select="/H2G2/ARTICLE/FRONTPAGE/DESCRIPTION" /></xsl:when>
					<xsl:when test="$article_type_user='member'"><xsl:value-of select="/H2G2/ARTICLE/GUIDE/HEADLINE" /></xsl:when>
				</xsl:choose>
			</xsl:attribute>
		</meta>
	
		<meta name="keywords">
			<xsl:attribute name="content">
				<xsl:choose>
					<xsl:when test="/H2G2/ARTICLE/GUIDE/KEYWORDS"><xsl:value-of select="/H2G2/ARTICLE/GUIDE/KEYWORDS" /></xsl:when>
					<xsl:when test="/H2G2/@TYPE='FRONTPAGE'"><xsl:value-of select="/H2G2/ARTICLE/FRONTPAGE/KEYWORDS" /></xsl:when>
				</xsl:choose>
			</xsl:attribute>
		</meta>
	</xsl:variable> 

	<!-- SSO -->
	<xsl:variable name="sso_serviceid_path">mysciencefictionlife</xsl:variable>
	<xsl:variable name="create_person_article">TypedArticle?acreate=new&amp;type=36</xsl:variable>
	<xsl:variable name="create_frontpage_article">TypedArticle?acreate=new&amp;type=13</xsl:variable>
	<xsl:variable name="create_member_article">TypedArticle?acreate=new</xsl:variable>
	<xsl:variable name="create_theme_generic">TypedArticle?acreate=new&amp;type=38</xsl:variable>

	<!-- BARLEY : SITE -->

	<xsl:variable name="bbcpage_bgcolor">899DC2</xsl:variable>
	<xsl:variable name="bbcpage_nav">yes</xsl:variable>
	<xsl:variable name="bbcpage_navwidth">125</xsl:variable>
	<xsl:variable name="bbcpage_navgraphic">yes</xsl:variable>
	<xsl:variable name="bbcpage_navgutter">yes</xsl:variable>
	<xsl:variable name="bbcpage_contentwidth">635</xsl:variable>
	<xsl:variable name="bbcpage_contentalign">left</xsl:variable>
	<xsl:variable name="bbcpage_language">english</xsl:variable>
	<xsl:variable name="bbcpage_searchcolour">666666</xsl:variable>
	<xsl:variable name="bbcpage_topleft_bgcolour"/>
	<xsl:variable name="bbcpage_topleft_linkcolour"/>
	<xsl:variable name="bbcpage_topleft_textcolour"/>
	<xsl:variable name="bbcpage_lang"/>
	<xsl:variable name="bbcpage_variant"/>

	<!-- BARLEY : CRUMB : Do NOT remove else 'CRUMBTRAIL GOES HERE!!' will be displayed -->
	<xsl:variable name="crumb-content">
	<!-- 
		<div class="navWrapper">
			<div class="navLink"><xsl:if test="/H2G2[@TYPE='FRONTPAGE']"><xsl:attribute name="id">active</xsl:attribute></xsl:if><xsl:element name="{$text.base}" use-attribute-sets="text.base">
				<a target="_top" href="{$root}">
					<xsl:if test="/H2G2[@TYPE='FRONTPAGE']"><xsl:attribute name="id">active</xsl:attribute></xsl:if>
					<xsl:value-of select="$alt_frontpage"/><xsl:if test="/H2G2[@TYPE='FRONTPAGE']">&nbsp;&#8226;</xsl:if>
				</a></xsl:element>
			</div>
		</div> 
	-->
	</xsl:variable>


	<!-- SCIFI LOGO BANNER -->
	<xsl:variable name="banner-content">
		<table border="0" cellpadding="0" cellspacing="0" width="647">
			<tr>
				<td><a href="http://www.bbc.co.uk/mysciencefictionlife/"><img src="{$imageRoot}images/greyswirl_topbg_2.gif" width="645" height="67" alt="My Science Fiction Life" /></a></td>
			</tr>
		</table>
	</xsl:variable>


	<!--=============== Templates =====================-->

	<!-- LEFT NAVIGATION -->
	<xsl:template name="local-content">
		
		 <!-- LEFT NAVIGATION STARTS -->
		<div id="leftnav"> 

			<!-- HOME -->
			<xsl:choose>
				<xsl:when test="@TYPE='FRONTPAGE'">
					<div class="leftnavselected"><span>Home</span></div> 
				</xsl:when>
				<xsl:otherwise>
					<div class="leftnavitem">
						<a target="_top" href="http://www.bbc.co.uk/mysciencefictionlife/index.shtml">Home</a>
					</div>
				</xsl:otherwise>
			</xsl:choose>

			<div class="vspace20px"></div>

			<!-- TIMELINE -->
			<xsl:choose>
				<xsl:when test="/H2G2/HIERARCHYDETAILS/@NODEID = $dateTo1930">
					<div class="leftnavselected"><span>Timeline</span></div> 
				</xsl:when>
				<xsl:otherwise>
					<div class="leftnavitem"><a href="http://www.bbc.co.uk/mysciencefictionlife/timeline">Timeline</a></div>
				</xsl:otherwise>
			</xsl:choose>

			
			<!-- ADD NEW TITLE -->
			<!-- 
			<xsl:choose>
				<xsl:when test="$is_logged_in">
					<div class="leftnavitem">
						<a><xsl:attribute name="href"><xsl:value-of select="concat($root, $create_member_article)" /></xsl:attribute>Add new title</a>
					</div>
				</xsl:when>

				<xsl:otherwise>
					<div class="leftnavitem">
						<a>
							<xsl:attribute name="href"><xsl:value-of select="$sso_signinlink" /><xsl:value-of select="$referrer" /></xsl:attribute>
							Timeline
						</a>
					</div>
					
				</xsl:otherwise>
			<xsl:choose> -->

			<!-- MY PROFILE -->
			<xsl:choose>	
				<xsl:when test="$ownerisviewer=1 and /H2G2/@TYPE = 'USERPAGE'">
					<div class="leftnavselected">
						<span>My profile</span>
					</div>
				</xsl:when>
				<xsl:when test="$is_logged_in">
					<div class="leftnavitem">
						<a>
							<xsl:attribute name="href"><xsl:value-of select="concat($root, 'U', VIEWING-USER/USER/USERID)" /></xsl:attribute>
							My profile
						</a>
					</div>
				</xsl:when>

				<xsl:otherwise><!-- send to signin page -->
					<div class="leftnavitem">
						<a>
							<xsl:attribute name="href"><xsl:value-of select="$sso_signinlink" /><xsl:value-of select="$referrer" /></xsl:attribute>
							My profile
						</a>
					</div>
					
				</xsl:otherwise>
			</xsl:choose>

			<div class="vspace20px"></div>

			<!-- BOOKS -->
			<xsl:choose>
				<xsl:when test="/H2G2/HIERARCHYDETAILS/@NODEID = $mediaBook">
					<div class="leftnavselected"><span>Books</span></div> 
				</xsl:when>
				<xsl:otherwise>
					<div class="leftnavitem">
						<a href="{$root}C{$mediaBook}">Books</a>
					</div>
				</xsl:otherwise>
			</xsl:choose>

			<!-- COMICS -->
			<xsl:choose>
				<xsl:when test="/H2G2/HIERARCHYDETAILS/@NODEID = $mediaComic">
					<div class="leftnavselected"><span>Comics</span></div> 
				</xsl:when>
				<xsl:otherwise>
					<div class="leftnavitem">
						<a href="{$root}C{$mediaComic}">Comics</a>
					</div>
				</xsl:otherwise>
			</xsl:choose>


			<!-- FILMS -->
			<xsl:choose>
				<xsl:when test="/H2G2/HIERARCHYDETAILS/@NODEID = $mediaFilm">
					<div class="leftnavselected"><span>Films</span></div> 
				</xsl:when>
				<xsl:otherwise>
					<div class="leftnavitem">
						<a href="{$root}C{$mediaFilm}">Films</a>
					</div>
				</xsl:otherwise>
			</xsl:choose>

			<!-- RADIO -->
			<xsl:choose>
				<xsl:when test="/H2G2/HIERARCHYDETAILS/@NODEID = $mediaRadio">
					<div class="leftnavselected"><span>Radio</span></div> 
				</xsl:when>
				<xsl:otherwise>
					<div class="leftnavitem">
						<a href="{$root}C{$mediaRadio}">Radio</a>
					</div>
				</xsl:otherwise>
			</xsl:choose>

			<!-- TV -->
			<xsl:choose>
				<xsl:when test="/H2G2/HIERARCHYDETAILS/@NODEID = $mediaTV">
					<div class="leftnavselected"><span>TV</span></div> 
				</xsl:when>
				<xsl:otherwise>
					<div class="leftnavitem">
						<a href="{$root}C{$mediaTV}">TV</a>
					</div>
				</xsl:otherwise>
			</xsl:choose>

			<!-- OTHER -->
			<xsl:choose>
				<xsl:when test="/H2G2/HIERARCHYDETAILS/@NODEID = $mediaOther">
					<div class="leftnavselected"><span>Other</span></div> 
				</xsl:when>
				<xsl:otherwise>
					<div class="leftnavitem">
						<a href="{$root}C{$mediaOther}">Other</a>
					</div>
				</xsl:otherwise>
			</xsl:choose>


			<xsl:if test="$test_IsEditor">
				<div class="vspace20px"></div>
				<div class="leftnavitem">
					
					<!-- PERSON -->
					<xsl:choose>
						<xsl:when test="/H2G2/ARTICLE/EXTRAINFO/TYPE/@ID = 19">
							<div class="leftnavselected"><span>People</span></div> 
						</xsl:when>
						<xsl:otherwise>
							<div class="leftnavitem">
								<a href="{$root}people">People</a>
							</div>
						</xsl:otherwise>
					</xsl:choose>
				
				</div>
			</xsl:if>
				<div class="vspace20px"></div>
				<div class="leftnavitem">
				
					<!-- THEMES -->
					<!-- <xsl:choose>
						<xsl:when test="/H2G2/ARTICLE/EXTRAINFO/TYPE/@ID = 26">
							<div class="leftnavselected"><span>Themes</span></div> 
						</xsl:when>
						<xsl:otherwise> -->
							<div class="leftnavitem">
								<a href="{$root}A19388433">Themes</a>
							</div>
						<!-- </xsl:otherwise>
					</xsl:choose>
					 -->
				</div>
			

			<div class="vspace14px"></div>
			<div class="leftnavitem"><a href="http://www.bbc.co.uk/mysciencefictionlife/pages/about.shtml">About this site</a></div>

		</div>
		 <!-- LEFT NAVIGATION ENDS -->

	</xsl:template>

									
	<!-- 
	<xsl:template match="H2G2" mode="r_userpage">
	Use: Presentation of the User page link
	-->
	<xsl:template match="H2G2" mode="r_userpage">
		<xsl:apply-imports/>
	</xsl:template>
									


	<!-- PRIMARY TEMPLATE -->
	<xsl:template name="primary-template">
		<html>
			<!-- BBC NAVIGATION HEADER -->
			<xsl:call-template name="insert-header"/>
			<body bgcolor="#ffffff" text="#000000" link="#000099" vlink="#ff0000" alink="#ff0000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
				<xsl:apply-templates select="/H2G2" mode="c_bodycontent"/>
			</body>
		</html>
	</xsl:template>


	<!-- PAGE WRAPPER -->
	<xsl:template match="H2G2" mode="r_bodycontent">
	
		<!--  SSO STATUSBAR --> 
		<!-- SC --><!-- Removed sign in bar. Will only display sso bar if user is already signed in from other site. CV 28/02/07 -->
		<!--<xsl:choose>
			<xsl:when test="$registered=1"> -->
				<div class="page-sso"><xsl:call-template name="sso_statusbar"/></div>
		<!--</xsl:when>
			<xsl:otherwise>
			</xsl:otherwise>
		</xsl:choose> -->
						
		<table width="635" border="0" cellspacing="0" cellpadding="0" style="margin-top:9px">

			<tr>
				<td valign="top" width="426" class="maincolumn">
					<div class="middlewidth">
						<!-- MAIN BODY -->
						<xsl:call-template name="insert-mainbody"/>	<!-- is defined in base.xsl and goes on to pull in the corresponding _MAINBODY template -->
					</div>
				</td>

				<td width="209" valign="top">
					
					<!-- RIGHT COLUMN STARTS -->
				
					<xsl:choose>
						<!-- <xsl:when test="/H2G2/@TYPE ='CATEGORY'"></xsl:when> -->
						<xsl:when test="/H2G2/@TYPE ='TYPED-ARTICLE' and $article_type_group='category'"></xsl:when>
						<xsl:when test="/H2G2/@TYPE ='TYPED-ARTICLE' and ($current_article_type='37' or $current_article_type='36' or $current_article_type='12')"></xsl:when>
						<xsl:when test="/H2G2/@TYPE ='UNAUTHORISED'"></xsl:when>
						<xsl:when test="/H2G2/@TYPE ='INFO'"></xsl:when>
						<xsl:when test="/H2G2/@TYPE ='SITECONFIG-EDITOR'"></xsl:when>
						<!--<xsl:when test="/H2G2/@TYPE ='USERPAGE'"></xsl:when> -->
						<xsl:when test="/H2G2/@TYPE ='FRONTPAGE'"></xsl:when>
						<!--<xsl:when test="/H2G2/@TYPE ='ADDTHREAD'"></xsl:when> -->
						
						<xsl:otherwise>
							<!-- FEATURE 1 (defined in siteconfig) v4 make site config default if per page promo is not defined -->
							<xsl:choose>
								<xsl:when test="ARTICLE/GUIDE/PROMO1 != ''">
									<xsl:copy-of select="ARTICLE/GUIDE/PROMO1" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:copy-of select="SITECONFIG/PROMO1" />
								</xsl:otherwise>
							</xsl:choose>

							<!-- RELATED WORKS (defined in typed article form) -->
							<xsl:if test="((/H2G2/@TYPE ='ARTICLE' or /H2G2/@TYPE ='MULTIPOST') and ARTICLE/GUIDE/RELATED_WORKS and /H2G2/ARTICLE/ARTICLEINFO/STATUS/@TYPE = 1 and not(/H2G2/ARTICLE/ARTICLEINFO/STATUS/@TYPE = 37 or /H2G2/ARTICLE/ARTICLEINFO/STATUS/@TYPE = 36)) and ARTICLE/GUIDE/RELATED_WORKS/LINK">
								<div class="relatedworks">
									<div class="relatedworkstop"><h2>Related works</h2></div>

									<div class="relatedworksbottom"> 
										<ul>
											<xsl:for-each select="ARTICLE/GUIDE/RELATED_WORKS/LINK">
												<li>
													<xsl:value-of select="concat(@YEAR, ' ', @TYPE, ' ', @COUNTRY, ' ')" />&nbsp;
													<a>
														<xsl:attribute name="href"><xsl:value-of select="concat($root, 'A', @AID)" /></xsl:attribute>
														<xsl:value-of select="." />
													</a>
												</li>
											</xsl:for-each>
										</ul>
									</div> 
								</div>
							</xsl:if>

							<!-- SEARCH BOX AREA (defined in site config) -->				
							<xsl:if test="$test_IsEditor">
								<xsl:copy-of select="SITECONFIG/SEARCH_BOX" />
							</xsl:if>

							<!-- WHO'S SAYING WHAT (defined in typed article form) -->
							<xsl:if test="$test_IsEditor">
								<xsl:copy-of select="SITECONFIG/SAYING_WHAT" />
							</xsl:if>
						</xsl:otherwise>

					</xsl:choose>
					
					<!-- RIGHT COLUMN ENDS -->
				</td>	
			</tr>
		</table>
		
		<div class="footer-wrapper">
			<div class="footer">
				<div class="footer-inner">
					<div class="footer-content">&nbsp;</div>
					<div class="footer-disclaimer"><xsl:element name="{$text.base}" use-attribute-sets="text.base"><hr class="footer-disclaimer" /><xsl:copy-of select="$m_footerdisclaimer" /></xsl:element></div>
				</div>
			</div>
		</div>
		

		<xsl:if test="$VARIABLETEST=1"><xsl:call-template name="VARIABLEDUMP"/></xsl:if>		
		<xsl:if test="$TESTING=1"><xsl:call-template name="ERRORFORM" /></xsl:if>		
	</xsl:template>




	<!--===============Global Alpha Index=====================-->
	
	<xsl:template match="PARSEERRORS" mode="r_typedarticle">
		<b>Error in the XML</b>
		<br/>
		<xsl:apply-templates/>
	</xsl:template>


	<!-- XML ERROR -->
	<xsl:template match="XMLERROR">
			<b><xsl:value-of select="."/></b>	
	</xsl:template>


	<!-- DATE -->
	<xsl:template match="DATE" mode="collective_long">
	<xsl:value-of select="translate(@DAYNAME, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz')"/>
		<xsl:text> </xsl:text>
		<xsl:value-of select="translate(@DAY, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz')"/>
		<xsl:text> </xsl:text>
		<xsl:value-of select="translate(@MONTHNAME, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz')"/>
		<xsl:text> </xsl:text>
		<xsl:value-of select="substring(@YEAR, 3, 4)"/>
	</xsl:template>



	<xsl:template match="DATE" mode="collective_med">
		<xsl:value-of select="translate(@DAY, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz')"/>
		<xsl:text> </xsl:text>
		<xsl:value-of select="translate(@MONTHNAME, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz')"/>
		<xsl:text> </xsl:text>
		<xsl:value-of select="substring(@YEAR, 3, 4)"/>
	</xsl:template>
	
		
	<xsl:template match="DATE" mode="collective_short">
		<xsl:value-of select="translate(@DAY, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz')"/>
		<xsl:text> </xsl:text>
		<xsl:value-of select="translate(substring(@MONTHNAME, 1, 3), 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz')"/>
		<xsl:text> </xsl:text>
		<xsl:value-of select="substring(@YEAR, 3, 4)"/>
	</xsl:template>
	

	<xsl:template match="DATE" mode="short1">
		<xsl:value-of select="@DAYNAME"/>&nbsp;<xsl:value-of select="@DAY"/>&nbsp;<xsl:value-of select="@MONTHNAME"/>&nbsp;<xsl:value-of select="@YEAR"/>
	</xsl:template>

	<!--
	<xsl:template name="article_subtype">
	Description: Presentation of the subtypes in search, index, category and userpage lists
	 -->
	<xsl:template name="article_subtype">
		<xsl:param name="num" select="EXTRAINFO/TYPE/@ID"/>
		<xsl:param name="status"/>
		<xsl:param name="pagetype"/>
		<xsl:param name="searchtypenum" />
	
		<!-- match with lookup table type.xsl -->	
		<!-- subtype label -->
		<xsl:variable name="label">
			<xsl:value-of select="msxsl:node-set($type)/type[@number=$num or @selectnumber=$num]/@label" />
		</xsl:variable>
		
		<!-- user type - member or editor -->
		<xsl:variable name="usertype">
			<xsl:value-of select="msxsl:node-set($type)/type[@number=$num or @selectnumber=$num]/@user" />
		</xsl:variable>

		<xsl:choose>
		<!-- approved articles -->
		<xsl:when test="$num=1 and $status=1">
		editorial
		</xsl:when>
		
		<!-- old reviews by members -->
		<xsl:when test="$num=1 and $status=3">
		member review 
		</xsl:when>
		
		<xsl:when test="$num=$searchtypenum">
		<xsl:if test="msxsl:node-set($type)/type[@selectnumber=$num]">selected</xsl:if>
		<!-- dont show anything for member indexs by type e.g. member film reviews list -->
		</xsl:when>
		
		<!-- for index and userpage where no user prefix is required -->
		<xsl:when test="$pagetype='nouser'">
		<xsl:if test="msxsl:node-set($type)/type[@selectnumber=$num]">selected</xsl:if><xsl:text>  </xsl:text>
		<xsl:value-of select="$label" />
		</xsl:when>

		<xsl:when test="$num=3001">
		member's page
		</xsl:when>
		
		<!-- selected member's film review layout or member's portfoilio page-->
		<xsl:otherwise>
		<!-- if selected -->
		<xsl:if test="msxsl:node-set($type)/type[@selectnumber=$num]">selected</xsl:if>
		<!-- editor's or member's -->
		<xsl:if test="not(contains($label,'interview') or contains($label,'column') or contains($label,'feature'))">
		<xsl:value-of select="$usertype" />'s 
		</xsl:if>
		<!-- label name i.e. film review -->
		<xsl:value-of select="$label" />
		</xsl:otherwise> 
		</xsl:choose>

	</xsl:template>

<!-- ******************************************************************************************************* -->
<!-- TODO Temporary templates - added so skins can be uploaded to staging server 25/03/2004 -->
<!--                             Can be remove when these templates are on live - Thomas Whitehouse                          -->
<!-- ******************************************************************************************************* -->
       <xsl:attribute-set name="it_searchstring"/>
		<xsl:attribute-set name="it_submitsearch"/> 
       <xsl:attribute-set name="fc_search_dna"/>
       <xsl:template name="t_searchstring">
             <input type="text" name="searchstring" xsl:use-attribute-sets="it_searchstring"/>
       </xsl:template>
       <xsl:template name="t_submitsearch">
	       <!-- (type="image") disabled by mattc as it is overriding things we want to override elsewhere - see categorypage.xsl line #607-->
             <input name="dosearch" xsl:use-attribute-sets="it_submitsearch">
                    <xsl:attribute name="value"><xsl:value-of select="$m_searchtheguide"/></xsl:attribute>
             </input>
       </xsl:template>
       <xsl:template name="c_search_dna">
             <form method="get" action="{$root}Search" xsl:use-attribute-sets="fc_search_dna">
                    <xsl:call-template name="r_search_dna"/>      
             </form>
       </xsl:template>












	   	<xsl:template name="sso_statusbar">
		<xsl:if test="not(/H2G2/PARAMS/PARAM[NAME= 's_print']/VALUE = 1)">
			<link rel="StyleSheet" href="{$sso_assets}/includes/service_statbar.css" type="text/css"/>
			<xsl:choose>
				<xsl:when test="$sso_statbar_type='normal'">
					
					<table width="100%" cellpadding="0" cellspacing="0" border="0">
						<xsl:choose>
							<xsl:when test="$sso_username">
								<!-- One -->
								<tr class="ssoOne">
									<td width="220">
										<img src="/f/t.gif" width="220" height="1" alt=""/>
									</td>
									<td width="14">
										<img src="/f/t.gif" width="14" height="1" alt=""/>
									</td>
									<td>
										<img src="/f/t.gif" width="1" height="1" alt=""/>
									</td>
									<td width="23">
										<img src="/f/t.gif" width="23" height="1" alt=""/>
									</td>
									<td width="120">
										<img src="/f/t.gif" width="120" height="1" alt=""/>
									</td>
									<td width="23">
										<img src="/f/t.gif" width="23" height="1" alt=""/>
									</td>
									<td width="58">
										<img src="/f/t.gif" width="58" height="1" alt=""/>
									</td>
								</tr>
								<tr class="ssoOne">
									<td align="right" class="ssoStatusdark">
										<font size="-1">
								Hello <strong>
												<xsl:value-of select="$sso_username"/>
											</strong>
										</font>
									</td>
									<td>
										<img src="/f/t.gif" width="1" height="22" alt=""/>
									</td>
									<td>
										<font size="-2">
											<a href="{$sso_resources}{$sso_script}?c=notme&amp;service={$sso_serviceid_link}&amp;ptrt={$sso_redirectserver}{$root}SSO?s_return={$referrer}" class="ssoStatusdark">
									I'm not <xsl:value-of select="$sso_username"/>
											</a>
										</font>
									</td>
									<td class="ssoTwo" rowspan="2" valign="top">
										<img src="{$sso_assets}/images/other/statbar_diag_slim_l.gif" width="23" height="23" alt="" border="0"/>
									</td>
									<td align="center" class="ssoTwo" background="{$sso_assets}/images/other/statbar_bg.gif" style="background:top url({$sso_assets}/images/other/statbar_bg.gif) repeat-x;">
										<img src="/f/t.gif" width="1" height="4" alt=""/>
										<br/>
										<font size="-2">
											<strong>
												<a class="ssoStatuslight">
													<xsl:attribute name="href"><xsl:value-of select="$sso_managelink"/></xsl:attribute>Retrieve my details</a>
											</strong>
										</font>
									</td>
									<td class="ssoTwo" rowspan="2" valign="top">
										<img src="{$sso_assets}/images/other/statbar_diag_slim_r.gif" width="23" height="23" alt="" border="0"/>
									</td>
									<td align="center">
										<font size="-2">
											<strong>
												<a href="{$sso_signoutlink}" class="ssoStatusdark">Sign out</a>
											</strong>
										</font>
									</td>
								</tr>
								<!-- One shadow -->
								<tr>
									<td colspan="3" class="ssoStatusshadow">
										<img src="/f/t.gif" width="1" height="1" alt=""/>
									</td>
									<td class="ssoTwo">
										<img src="/f/t.gif" width="1" height="1" alt=""/>
									</td>
									<td class="ssoStatusshadow">
										<img src="/f/t.gif" width="1" height="1" alt=""/>
									</td>
								</tr>
								<!-- Two -->
								<tr>
									<td colspan="7" class="ssoTwo">
										<img src="/f/t.gif" width="1" height="2" alt=""/>
									</td>
								</tr>
								<!-- Two shadow -->
								<tr>
									<td colspan="7" class="ssoStatusshadow">
										<img src="/f/t.gif" width="1" height="1" alt=""/>
									</td>
								</tr>
								<!-- Three -->
								<tr>
									<td colspan="7" class="ssoThree">
										<img src="/f/t.gif" width="1" height="2" alt=""/>
									</td>
								</tr>
							</xsl:when>
							<xsl:otherwise>
								<!--slimline unrecognised status bar here-->
								<tr>
									<td class="ssoThree" width="10" valign="bottom" rowspan="2">
										<img src="{$sso_assets}/images/corners/statbar_light_bl.gif" width="10" height="10" alt="" border="0"/>
									</td>
									<td class="ssoThree">
										<img src="/f/t.gif" height="1" alt=""/>
									</td>
									<td class="ssoOne" width="1" valign="bottom" rowspan="2">
										<img src="{$sso_assets}/images/other/statbar_slim_middle.gif" height="30" width="21" alt="" border="0"/>
									</td>
									<td class="ssoOne">
										<img src="/f/t.gif" height="1" alt=""/>
									</td>
									<td align="right" class="ssoOne" valign="bottom" rowspan="2">
										<img src="{$sso_assets}/images/corners/statbar_dark_br.gif" width="10" height="10" alt="" border="0"/>
									</td>
								</tr>
								<tr>
									<td class="ssoThree">
										<table cellpadding="0" cellspacing="0" border="0">
											<tr>
												<td nowrap="nowrap" class="ssoStatuslight">
													<!-- SC -->
													<!-- <font size="-1">
														<strong>New visitors:&nbsp;</strong>
													</font> -->
												</td>
												<td>
													<!-- SC -->
													<!-- <a href="{$sso_registerlink}">
														<img src="{$sso_assets}/images/buttons/create_membership_slim.gif" alt="Create your membership" border="0"/>
													</a> -->
												</td>
											</tr>
										</table>
									</td>
									<td class="ssoOne">
										<table cellpadding="0" cellspacing="0" border="0">
											<tr>
												<td class="ssoStatusdark">
													<!-- SC -->
													<!-- <font size="-1">
														<strong>Returning members:&nbsp;</strong>
													</font> -->
												</td>
												<td>
													<!-- SC -->
													<!-- <a href="{$sso_signinlink}">
														<img src="{$sso_assets}/images/buttons/signin_slim.gif" alt="Sign in" border="0"/>
													</a> -->
												</td>
											</tr>
										</table>
									</td>
								</tr>
							</xsl:otherwise>
						</xsl:choose>
					</table>
				</xsl:when>
				<xsl:when test="$sso_statbar_type='kids'">
					<link rel="StyleSheet" href="{$sso_resources}/signon/sso_includes/singlesignon_kids_statbar.css" type="text/css"/>
					<xsl:choose>
						<xsl:when test="$sso_username">
							<table width="100%" cellspacing="0" cellpadding="0">
								<tr class="statbar">
									<td>
										<img src="{$sso_assets}/images/corners/stat_t_l.gif" width="10" height="10" alt="" />
									</td>
									<td align="right">
										<img src="{$sso_assets}/images/corners/stat_t_r.gif" width="10" height="10" alt="" />
									</td>
								</tr>
								<!--full rec statbar content-->
								<tr class="statbar">
									<td>
										<div class="contentFullLastRow">
											<font size="3" class="ssoNormal">
												<xsl:text>Hello </xsl:text>
												<strong>
													<xsl:value-of select="$sso_username"/>
												</strong>
											</font> 
											<font size="-2">
												<a href="{$sso_resources}{$sso_script}?c=notme&amp;service={$sso_serviceid_link}&amp;ptrt={$sso_redirectserver}{$root}SSO?s_return={$referrer}" class="ssoStatusdark">If you are not <xsl:value-of select="$sso_username"/> click here</a>
											</font>
										</div>
									</td>
									<td align="right">
										<div class="contentRightLastRow">
											<a href="{$sso_managelink}">
												<img src="{$sso_assets}/images/buttons/mydetails_cd.gif" width="82" height="22" alt="My details" />
											</a>
											<a href="{$sso_signoutlink}">
												<img src="{$sso_assets}/images/buttons/signout_bg.gif" width="70" height="22" alt="" class="adjacentButton" />
											</a>
										</div>
									</td>
								</tr>
								<!--full rec statbar bottom-->
								<tr class="statbar">
									<td>
										<img src="{$sso_assets}/images/corners/stat_b_l.gif" width="10" height="10" alt="" />
									</td>
									<td align="right">
										<img src="{$sso_assets}/images/corners/stat_b_r.gif" width="10" height="10" alt="" />
									</td>
								</tr>
							</table>
						</xsl:when>
						<xsl:otherwise>
							<table width="100%" cellspacing="0" cellpadding="0">
							<!--full rec statbar top-->
								<tr>
									<td class="reg" colspan="2">
										<img src="{$sso_assets}/images/corners/stat_t_l.gif" width="10" height="10" alt="" />
									</td>
									<td rowspan="3" width="1">
										<img src="/f/t.gif" width="1" height="1" alt="" />
									</td>
									<td align="right" class="rtn" colspan="2">
										<img src="{$sso_assets}/images/corners/stat_t_r.gif" width="10" height="10" alt="" />
									</td>
								</tr>

								<!--full rec statbar content-->
								<tr>
									<td class="reg" align="right">
										<div class="contentFullLastRow">
											<font size="2" class="ssoNormal">
												<strong>New?</strong>
											</font>
										</div>
									</td>
									<td class="reg">
										<div class="contentRightLastRow">
											<a href="{$sso_registerlink}">
												<img src="{$sso_assets}/images/buttons/becomeamember_slim_reg.gif" alt="Become a member" />
											</a>
										</div>
									</td>
									<td class="rtn" align="right">
										<div class="contentFullLastRow">
											<font size="2" class="ssoNormal">
												<strong>Returning members:</strong>
											</font>
										</div>
									</td>
										<td class="rtn">
											<div class="contentRightLastRow">
												<a href="{$sso_signinlink}">
													<img src="{$sso_assets}/images/buttons/signin_slim_rtn.gif" alt="Sign in" />
												</a>
											</div>
										</td>
									</tr>
									<!--full rec statbar bottom-->
									<tr>
										<td class="reg" colspan="2">
											<img src="{$sso_assets}/images/corners/stat_b_l.gif" width="10" height="10" alt="" />
										</td>
										<td align="right" class="rtn" colspan="2">
											<img src="{$sso_assets}/images/corners/stat_b_r.gif" width="10" height="10" alt="" />
										</td>
									</tr>
								</table>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
			</xsl:choose>
		</xsl:if>
	</xsl:template>

</xsl:stylesheet>