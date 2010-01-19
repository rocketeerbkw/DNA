<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	
	<xsl:import href="../../../base/base-articlepage.xsl"/>

	<!-- Frontpages -->
	<xsl:import href="articlepage_person.xsl"/>
	<xsl:import href="communityfrontpage.xsl"/>
	<xsl:import href="featurefrontpage.xsl"/>
	<xsl:import href="recommendedfrontpage.xsl"/>
	<xsl:import href="watchandlistenfrontpage.xsl"/>
	<xsl:import href="archivepage.xsl"/>
	
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
				Page - Level  template
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	
	<xsl:template name="ARTICLE_MAINBODY">
	
		<!-- PRIMARY ARTICLE CONTENT: choose between different article scenarios -->
		<xsl:choose>

			<!-- PERSON ARTICLE PAGE -->
			<xsl:when test="$current_article_type=36">
				<xsl:call-template name="PERSON_MAINBODY" />
			</xsl:when>

			<!-- THEME ARTICLE PAGE -->
			<xsl:when test="$current_article_type=37">
				<xsl:call-template name="PERSON_MAINBODY" />
			</xsl:when>

			<!-- THEME ARTICLE PAGE -->
			<xsl:when test="$current_article_type=38">
				<xsl:call-template name="THEMES_GENERIC" />
			</xsl:when>

			<!-- FEATURE ARTICLE PAGE -->
			<xsl:when test="$current_article_type=4">
				<xsl:call-template name="PERSON_MAINBODY" />
			</xsl:when>

			<!-- PERSON INDEX PAGE -->
			<xsl:when test="$current_article_type=19">
				<xsl:copy-of select="/H2G2/ARTICLE/GUIDE/BODY" />
			</xsl:when>

			<!-- THEME INDEX PAGE -->
			<xsl:when test="$current_article_type=26">
				<xsl:copy-of select="/H2G2/ARTICLE/GUIDE/BODY" />
			</xsl:when>


			<!-- ARTICLE ENTRY -->
			<xsl:otherwise>
			
				<!-- DEBUG -->
				<xsl:call-template name="TRACE">
				<xsl:with-param name="message">ARTICLE_MAINBODY test variable = <xsl:value-of select="$current_article_type" /></xsl:with-param>
				<xsl:with-param name="pagename">articlepage.xsl</xsl:with-param>
				</xsl:call-template>
				<!-- DEBUG -->
		
			
				<xsl:apply-templates select="ARTICLE-MODERATION-FORM" mode="c_skiptomod"/>
				<xsl:apply-templates select="ARTICLE-MODERATION-FORM" mode="c_modform"/>
				
				<!-- moderation tool bar -->
				<div><xsl:apply-templates select="/H2G2/ARTICLE/ARTICLEINFO/MODERATIONSTATUS" mode="c_articlepage"/></div>		
				
				<!-- contains main article content -->
				<xsl:choose>

					<!-- content for non-editors that are viewing an article page that is not yet approved -->
					<xsl:when test="/H2G2/ARTICLE/ARTICLEINFO/STATUS/@TYPE = 3 and $ownerisviewer = 1 and not($test_IsEditor)">
						
						<div class="success_topsection">
						<!-- <h1>Thanks very much. Go to <a><xsl:attribute name="href"><xsl:value-of select="concat($root, 'U', /H2G2/VIEWING-USER/USER/USERID)" /></xsl:attribute>your profile</a> page to see it live on the site.</h1> -->



						<!-- redirect non-editors strailat to recollection page so they can add a recollection to the title they just submitted TW -->
						<script type="text/javascript">

							<xsl:comment><![CDATA[

							  window.location  =']]><xsl:value-of select="concat($root, 'AddThread?forum=',/H2G2/ARTICLEFORUM/FORUMTHREADS/@FORUMID,'&amp;article=',/H2G2/ARTICLE/ARTICLEINFO/H2G2ID)" /><![CDATA[';

							]]> <xsl:text>//</xsl:text></xsl:comment>

							</script>

							<h1>Thanks very much. To be the first person to add a recollection,
							go to the <a><xsl:attribute name="href"><xsl:value-of
							select="concat($root, 'AddThread?forum=',
							/H2G2/ARTICLEFORUM/FORUMTHREADS/@FORUMID, '&amp;article=',
							/H2G2/ARTICLE/ARTICLEINFO/H2G2ID)" /></xsl:attribute>Add Recollection</a>
							page.</h1>

						</div>

						<div class="vspace24px"></div>
						
						<p class="simple1">If you've suggested a new work for the site, we'll check a few of the details before linking it in to the rest of the site.</p>
						<p class="simple1">Our interactive timeline will be regularly updated with a selection of new works -- keep checking back to see if your nomination
						has been added.</p>
						
						<div class="vspace80px"></div>
						
						<p class="simple2">The BBC is making a programme all about people's Science Fiction lives, and the works that are important to them. Your contribution may be of interest to the team.</p>
						
						<div class="vspace10px"></div>
						
						<!--
						<form action="" class="scifiform">
							<div class="success_floatleft">
							
								<input type="checkbox" name="emailcheckbox" id="emailcheckbox"/>
								<div class="success_floatrightp">
									<p><label for="emailcheckbox" title="email check box">Please tick this box if you're happy for the BBC to contact you by email should we wish to follow this up futher.</label></p>
								</div>
							</div>
							<div class="success_floatright">
								<img  src="{$imageRoot}images/submit.gif" border="0" width="72" height="24" alt="Submit" />
							</div>
						</form>
						-->

					</xsl:when>

					<!-- content for non-editors that are viewing an article that was declined for inclusion in site -->
					<xsl:when test="/H2G2/ARTICLE/ARTICLEINFO/STATUS/@TYPE = 5 and $ownerisviewer = 1 and not($test_IsEditor)">
						<div class="success_topsection"></div>
						<div class="vspace24px"></div>
						<p class="simple1">Your article has been declined for publication, either because of technical problems or because it broke the House Rules in some way. You can contact the site editors by emailing: sciencefictionlife@bbc.co.uk.</p>
					</xsl:when>
					
					<!-- primary content for all approved articles -->
					<xsl:when test="/H2G2/ARTICLE/ARTICLEINFO/STATUS/@TYPE = 1 or $test_IsEditor">		
						<xsl:apply-templates select="ARTICLE" mode="c_articlepage"/>
					</xsl:when>

					<!-- catch all for any article page that is not caught by above test statements AND is not approved -->
					<xsl:otherwise></xsl:otherwise>
				</xsl:choose>
			
			</xsl:otherwise>
		</xsl:choose>

	</xsl:template>


	
	<!--
	<xsl:template match="MODERATIONSTATUS" mode="r_articlepage">
	Description: moderation status of the article
	 -->
	<xsl:template match="MODERATIONSTATUS" mode="r_articlepage">
	<!-- commented out temporarily SZ - until it can be built so that it doesn't break page -->
		<!-- <xsl:apply-imports/> -->
	</xsl:template>

	<!--
	<xsl:template match="ARTICLE" mode="noentryyet_articlepage">
	Author:        Tom Whitehouse
	Context:      /H2G2
	Purpose:      Template for when a valid H2G2ID hasn't been created yet
	 -->
	<xsl:template match="ARTICLE" mode="noentryyet_articlepage">
		<div class="myspace-b">
		<xsl:element name="{$text.base}" use-attribute-sets="text.base"><xsl:copy-of select="$m_noentryyet"/></xsl:element>
		</div>
	</xsl:template>
	<!--
	<xsl:template match="ARTICLE" mode="r_unregisteredmessage">
	Description: message to be displayed if the viewer is not registered
	 -->
	<xsl:template match="ARTICLE" mode="r_unregisteredmessage">
		<xsl:copy-of select="$m_unregisteredslug"/>
	</xsl:template>
	<!--
	<xsl:template match="ARTICLE-MODERATION-FORM" mode="r_skiptomod">
	Description: Presentation of link that skips to the moderation section
	 -->
	<xsl:template match="ARTICLE-MODERATION-FORM" mode="r_skiptomod">
		<xsl:apply-imports/>
		<br/>
	</xsl:template>
	<!--
	<xsl:template match="ARTICLE-MODERATION-FORM" mode="r_modform">
	Description: Presentation of the article moderation form
	Visible to: Moderators
	 -->
	<xsl:template match="ARTICLE-MODERATION-FORM" mode="r_modform">
			<xsl:apply-imports/>
	</xsl:template>
	
	






	
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
				ARTICLE Object
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	
	
	<xsl:template match="ARTICLE" mode="r_articlepage">

		<!-- BOOK HEADER INFO: IMAGE, TITLE, 
		, SHORTDESC, CLIP -->		
		<div class="topmiddle_booktitle">
			<div class="piccontainer"> 

				<!-- IMAGE -->
				<xsl:choose>
					<xsl:when test="GUIDE/IMAGE_LOC != ''"><img src="{$imageRoot}{GUIDE/IMAGE_LOC}" alt="{SUBJECT}" width="160" height="150" border="0" /></xsl:when>
					<xsl:otherwise><img src="{$imageRoot}images/genericentry_2.jpg" border="0" alt="{SUBJECT}" /></xsl:otherwise>
				</xsl:choose>

			</div>

			<div class="textcontainer">
				<p class="date"><xsl:value-of select="GUIDE/PRODUCTION_YEAR"/></p>
				<h1><xsl:value-of select="$article_type_label" />: <xsl:value-of select="SUBJECT"/></h1>
				<xsl:if test="GUIDE/CREATOR != ''">
					<h2>
						<xsl:choose>
							<xsl:when test="EXTRAINFO/TYPE/@ID = 30">Author: </xsl:when>
							<xsl:otherwise>Creator: </xsl:otherwise>
						</xsl:choose>
						<xsl:value-of select="GUIDE/CREATOR" />
					</h2>
				</xsl:if>
				<p class="titletext"><xsl:value-of select="GUIDE/SUM_UP" /></p>

				<!-- WATCH CLIP -->
				<xsl:if test="GUIDE/MOVIE_LOC != ''">




					<!-- new html - 03 Nov 2006 -->
					<table class="medialink">
						<tr><th></th><th></th></tr>
						<tr>
							<td>
								<a title="Watch clip from the original">
									<xsl:attribute name="href"><xsl:value-of select="GUIDE/MOVIE_LOC/CLIP/@LOC" /><!-- ?size=4x3&amp;bgc=C0C0C0&amp;nbram=1 --></xsl:attribute> 
									<xsl:attribute name="onclick">window.open(this.href,this.target,'status=no,scrollbars=yes,resizable=yes,width=409,height=269')</xsl:attribute>
									<xsl:attribute name="target">avaccess</xsl:attribute>
									<img src="{$imageRoot}images/medialinkarrow.gif" border="0" width="32" height="24" alt="Watch clip from the original" />
								</a>
							</td>
							<td>
								<a title="Watch clip from the original">
									<xsl:attribute name="href"><xsl:value-of select="GUIDE/MOVIE_LOC/CLIP/@LOC" /><!-- ?size=4x3&amp;bgc=C0C0C0&amp;nbram=1 --></xsl:attribute> 
									<xsl:attribute name="onclick">window.open(this.href,this.target,'status=no,scrollbars=yes,resizable=yes,width=409,height=269')</xsl:attribute>
									<xsl:attribute name="target">avaccess</xsl:attribute>
									<xsl:value-of select="GUIDE/MOVIE_LOC/CLIP" />
								</a>
							</td>
						</tr>
					</table>
					<!-- end new html -->
				</xsl:if>
			</div>

			<div class="clear"></div>

			<div class="topsectionbottom">
				<p align="right"><strong><a href="#inDepth"><img src="{$imageRoot}images/icon_downdoublearrow.gif" border="0" width="14" height="10" alt="arrow icon" />More details</a></strong></p>
			</div>
		</div>

		<!-- LIST RECOLLECTIONS -->
		<xsl:if test="../ARTICLEFORUM/FORUMTHREADS/@TOTALTHREADS != 0">
			<div>
				<h2>
					<!-- SC --><!-- Changed the image to 'Recollections'. CV 28/02/07 -->
					<img src="{$imageRoot}images/recollectionsgrey.gif" border="0"  width="416" height="43" alt="Recollections..." />
				</h2>
			</div>
			<xsl:apply-templates select="/H2G2/ARTICLEFORUM" mode="c_article"/>
		</xsl:if>
		
		<!-- SC --><!-- Changed: Only editors will see speech bubble with link to add entry -->
		<xsl:if test="$test_IsEditor">
		<div class="speechbox2">
			<p><xsl:apply-templates select="/H2G2/ARTICLEFORUM/FORUMTHREADS/@FORUMID" mode="t_addthread"/> of your own</p>		<!-- text of link defined in scifitext.xsl with the variable $alt_discussthis -->
		</div>

		<div class="vspace10px"></div>
		</xsl:if>

		<!-- SC --><!-- ADDED: blurb for non editors -->
		<!-- BLURB ABOUT ADDING RECOLLECTION -->
		<xsl:if test="../ARTICLEFORUM/FORUMTHREADS/@TOTALTHREADS = 0 and $test_IsEditor">
			<p class="greybgstrongp">This site is all about your science fiction life. By adding an entry, you can talk about the stories and works that are important to you, and why. For more information, visit our <a href="http://www.bbc.co.uk/mysciencefictionlife/pages/about.shtml" class="black underline"><acronym title="Frequently Asked Questions">FAQ</acronym>s section</a></p>
		</xsl:if>
		<!-- <xsl:if test="not($test_IsEditor)"> -->
		<xsl:if test="../ARTICLEFORUM/FORUMTHREADS/@TOTALTHREADS = 0">
		<div class="vspace10px"></div>
			 
		</xsl:if>

		<div class="vspace10px"></div>
		<div class="boxtopyellowdotted"> </div>
		<div class="indepth_top">
			<a name="inDepth"></a>

			<div class="leftpadding">
				<table width="370" border="0" cellspacing="0" cellpadding="0">
				  <tr>
					<td width="150">
						<h2>
							<xsl:choose>
								<xsl:when test="GUIDE/INDEPTH != ''"><xsl:value-of select="GUIDE/INDEPTH" /></xsl:when>
								<xsl:otherwise>In Depth</xsl:otherwise>
							</xsl:choose>
						</h2>
					</td>
					<td width="220">
					
					<xsl:if test="GUIDE/THEMELINK != ''">
						<table width="220" border="0" cellspacing="0" cellpadding="0">
						  <tr>
							<td width="35" valign="top" class="arrow"><img  src="{$imageRoot}images/icon_leftbigarrow.gif" border="0" width="35" height="11" alt="arrow icon" /></td>
							<td width="185" class="themelink">Theme: <xsl:copy-of select="GUIDE/THEMELINK" /></td>
						  </tr>
						</table>
					</xsl:if>

					  </td>
				  </tr>

				</table>
			</div>

			<div class="floatright"></div>

			<div class="clear"></div>
		</div> 
	
   		<!-- IN DEPTH -->
		<div class="indepth_top_topics">
			<h3><xsl:apply-templates select="/H2G2/ARTICLE/SUBJECT"/></h3>
			<p><xsl:apply-templates select="/H2G2/ARTICLE/GUIDE/BODY"/></p>
		</div>

		<div class="clear"></div>	

		<div>
		<xsl:if test="GUIDE/WATCH_LISTEN != '' or GUIDE/READ_LINKS != ''">
			<xsl:attribute name="class">seperatorverthorztopnogap</xsl:attribute>
		</xsl:if>
		<!-- <xsl:choose>
				<xsl:when test="GUIDE/READ_LINKS != ''"><xsl:attribute name="class">.seperatorverthorztopnogap</xsl:attribute></xsl:when>
 				<xsl:otherwise><xsl:attribute name="class">seperatorverthorztop_noread</xsl:attribute></xsl:otherwise>		
		</xsl:choose> -->

		</div>	
			
		<!-- SC --><!-- Waiting on HTML to replace ADD Links below CV 28/02/07 -->
		<xsl:if test="GUIDE/READ_LINKS != ''">
			<div class="read">
				<div class="readtop"><h3>Read</h3></div>
				<div class="readbottom">
					<ul><xsl:copy-of select="GUIDE/READ_LINKS" /></ul>
				</div>
				<div class="clear"></div>  
			</div>

			 <div class="greyseperator"></div>
		</xsl:if>


		<!-- <div>
			<xsl:choose>
				<xsl:when test="GUIDE/READ_LINKS != ''"><xsl:attribute name="class">doublebox</xsl:attribute></xsl:when>
				<xsl:otherwise><xsl:attribute name="class">doublebox_noread</xsl:attribute></xsl:otherwise>
			</xsl:choose>
			<div class="leftbox">
				<div class="leftboxtop"><h3>Add</h3></div>
				<div class="leftboxbottom">

					<ul>
						<li><a><xsl:attribute name="href"><xsl:value-of select="concat($root, 'AddThread?forum=', /H2G2/ARTICLEFORUM/FORUMTHREADS/@FORUMID, '&amp;article=', /H2G2/ARTICLE/ARTICLEINFO/H2G2ID)" /></xsl:attribute>Add your own recollection</a></li>
						<li><xsl:choose>	
								<xsl:when test="$is_logged_in">
										<a><xsl:attribute name="href"><xsl:value-of select="concat($root, $create_member_article)" /></xsl:attribute>Add a new work</a>
								</xsl:when>
								<xsl:otherwise>
										<a><xsl:attribute name="href"><xsl:value-of select="$sso_signinlink" /></xsl:attribute>Add a new work</a>
								</xsl:otherwise>
							</xsl:choose>
						</li>
					</ul>
				</div> 
			</div>

			<xsl:if test="GUIDE/READ_LINKS != ''">
				<div class="rightbox">
					<div class="rightboxtop"><h3>Read</h3></div>
					<div class="rightboxbottom">
						<ul>
							<xsl:copy-of select="GUIDE/READ_LINKS" />						
						</ul>
					</div> 
				</div>
			</xsl:if>

			<div class="clear"></div>

		</div> -->

       
		
		<!-- WATCH / LISTEN -->
		<xsl:if test="GUIDE/WATCH_LISTEN != ''">
			<div class="watch">
				<div class="watchtop"><h3>Watch / listen to interview</h3></div>
				<div class="watchbottom">
					<ul>
						<xsl:copy-of select="GUIDE/WATCH_LISTEN" />
					</ul>
				</div> 
				<div class="clear"></div> 
			</div>

			<div class="clear"></div>
			<div class="greyseperator"></div>
		</xsl:if>

			
		
		<xsl:if test="GUIDE/ALSO_BBC != '' and GUIDE/ALSO_WEB != ''">
		
		<div class="doublebox">

			<!-- ALSO ON BBC -->
			<xsl:if test="GUIDE/ALSO_BBC != ''">
				<div class="leftbox">
					<div class="leftboxtop"><h3>Also on bbc.co.uk</h3></div>
					<div class="leftboxbottom">
						<ul>
							<xsl:copy-of select="GUIDE/ALSO_BBC" />
						</ul>
					</div> 
				</div>
			</xsl:if>

			<!-- ALSO ON WEB -->
			<xsl:if test="GUIDE/ALSO_WEB != ''">
				<div class="rightbox">
					<div class="rightboxtop"><h3>Also on the web</h3></div>
					<div class="rightboxbottom">
						<ul>
							<xsl:copy-of select="GUIDE/ALSO_WEB" />
						</ul>
					</div> 
				</div>
			</xsl:if>

			<div class="clear"></div>

		</div>

		<div class="seperatorverthorzbot"></div>
		
		</xsl:if>
		
		<div class="clear"></div>		  
		
		<!-- EDITOR BOX @cv@07 -->
		<xsl:if test="$test_IsEditor">
			<div><xsl:call-template name="editorbox" /></div>
		</xsl:if>

	
	</xsl:template>







	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
				ARTICLEFORUM Object
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->

	<!-- @cv@ stripped a bunch of code from the collective template. revisit the articleforum object from the collective skins if you need to add in more -->
	
	<xsl:template match="ARTICLEFORUM" mode="c_article">
	
		<!-- LIST 3 RECOLLECTIONS @cv@10 -->
		<xsl:apply-templates select="FORUMTHREADS" mode="c_article"/>	

				 
		<div class="modulebottom"> </div>


		<!-- <xsl:if test="FORUMTHREADS/@TOTALTHREADS > 3"> -->
		<!-- changed if statement to count non hided thread only -->
		<xsl:if test="count(FORUMTHREADS/THREAD/FIRSTPOST[@HIDDEN=0]) > 3">

			<div class="boxbot"></div>

			<div>
				<h2 class="homepage" style="background:#fff;padding-left:10px;"><img src="{$imageRoot}images/morerecollections.gif" border="0"  width="181" height="20" alt="More recollections..." /></h2>
			</div>


			<div class="otherentries">
				<div class="padding10px">
					<div class="vspace10px"></div>
			  
			  
					<xsl:for-each select="FORUMTHREADS/THREAD[FIRSTPOST/@HIDDEN=0][position() &gt;= 4 and position() &lt;= 8]">
					  		
						<xsl:choose>
							<xsl:when test="position() mod 2">
								
								<div class="nongreystrip2">
									<div class="morerecollectionleft">
										<a>
											<xsl:attribute name="href"><xsl:value-of select="concat($root, 'F', /H2G2/ARTICLEFORUM/FORUMTHREADS/@FORUMID, '?thread=', @THREADID)" /></xsl:attribute>
											<xsl:value-of select="SUBJECT" /> <img src="{$imageRoot}images/icon_rightarrow.gif" border="0"  width="10" height="7" alt="arrow icon" />
										</a>
									</div>
									<div class="morerecollectionright">
										<a>
											<xsl:attribute name="href"><xsl:value-of select="concat($root, 'U', FIRSTPOST/USER/USERID)" /></xsl:attribute>
											<xsl:value-of select="FIRSTPOST/USER/USERNAME" /><xsl:choose>
			<xsl:when test="FIRSTPOST/USER/EDITOR = 1"><span class="editorName"><em><strong><xsl:value-of select="FIRSTPOST/USER/USERNAME" /></strong></em></span></xsl:when>
			<xsl:otherwise><xsl:value-of select="FIRSTPOST/USER/USERNAME" /></xsl:otherwise>
		</xsl:choose>
										</a>
									</div>
								</div>
							</xsl:when>
							<xsl:otherwise>
								<div class="greystrip2">
									<div class="morerecollectionleft">
										<a>
											<xsl:attribute name="href"><xsl:value-of select="concat($root, 'F', /H2G2/ARTICLEFORUM/FORUMTHREADS/@FORUMID, '?thread=', @THREADID)" /></xsl:attribute>
											<xsl:value-of select="SUBJECT" /> <img src="{$imageRoot}images/icon_rightarrow.gif" border="0"  width="10" height="7" alt="arrow icon" />
										</a>
									</div>
									<div class="morerecollectionright">
										<a>
											<xsl:attribute name="href"><xsl:value-of select="concat($root, 'U', FIRSTPOST/USER/USERID)" /></xsl:attribute>
											<xsl:choose>
			<xsl:when test="FIRSTPOST/USER/EDITOR = 1"><span class="editorName"><em><strong><xsl:value-of select="FIRSTPOST/USER/USERNAME" /></strong></em></span></xsl:when>
			<xsl:otherwise><xsl:value-of select="FIRSTPOST/USER/USERNAME" /></xsl:otherwise>
		</xsl:choose>
										</a>
									</div>
								</div>
							</xsl:otherwise>
						</xsl:choose>
				
					</xsl:for-each>

					<div class="vspace10px"></div>
				</div>
			</div>
			

			<!-- VIEW ALL RECOLLECTIONS LINK -->
			<xsl:if test="/H2G2/ARTICLEFORUM/FORUMTHREADS/@TOTALTHREADS > 8">
				<div class="mostrecentview">
					<strong>
						<a xsl:use-attribute-sets="mARTICLEFORUM_r_viewallthreads" href="{$root}F{FORUMTHREADS/@FORUMID}">View all entries<img src="{$imageRoot}images/icon_rightarrow.gif" border="0"  width="10" height="7" alt="arrow icon" /></a>
					</strong>
				</div>
			</xsl:if>
			

		</xsl:if>

	
	</xsl:template>

	
	<!-- LIST 3 RECOLLECTIONS CON'T @CV@10 -->
	<xsl:template match="FORUMTHREADS" mode="c_article">
		<xsl:choose>
			<xsl:when test="THREAD/FIRSTPOST/@HIDDEN=0">
				<xsl:for-each select="THREAD[FIRSTPOST/@HIDDEN=0][position() &lt;= 3]">
					<div class="mostrecent"> 
						<h3>
							<a>
								<xsl:attribute name="href"><xsl:value-of select="concat($root, 'F', /H2G2/ARTICLEFORUM/FORUMTHREADS/@FORUMID, '?thread=', @THREADID)" /></xsl:attribute>
								<xsl:attribute name="title"><xsl:value-of select="SUBJECT" /></xsl:attribute>
								<xsl:value-of select="SUBJECT" />
								<img src="{$imageRoot}images/icon_rightarrow.gif" border="0" width="10" height="7" alt="arrow icon" />
							</a>
						</h3>
						<p><xsl:value-of select="substring(FIRSTPOST/TEXT/RICHPOST/TIME,1,150)" /><xsl:if test="string-length(FIRSTPOST/TEXT/RICHPOST/TIME) &gt; 150"> ...</xsl:if><br />
							<a>
								<xsl:attribute name="href"><xsl:value-of select="concat($root, 'U', FIRSTPOST/USER/USERID)" /></xsl:attribute>
								<xsl:attribute name="class">decoration</xsl:attribute>
								more from <xsl:choose>
			<xsl:when test="FIRSTPOST/USER/EDITOR = 1"><span class="editorName"><em><strong><xsl:value-of select="FIRSTPOST/USER/USERNAME" /></strong></em></span></xsl:when>
			<xsl:otherwise><xsl:value-of select="FIRSTPOST/USER/USERNAME" /></xsl:otherwise>
		</xsl:choose>
	
							</a>
						</p>
					</div>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<xsl:if test="@CANWRITE = 1">
					<xsl:choose>
						<xsl:when test="$registered=1">
							<div class="mostrecent"><p><xsl:apply-templates select="." mode="empty_article"/></p></div>
							<!--xsl:apply-templates select="@FORUMID" mode="FirstToTalk"/-->
						</xsl:when>
						<xsl:otherwise>
							<xsl:copy-of select="$m_registertodiscuss"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	
	<!-- @cv@? might be able to delete the following templates...should test all of these with different user scenarios -->
	<!--
	<xsl:template match="ARTICLEFORUM" mode="r_viewallthreads">
	Description: Presentation of the 'view all threads related to this conversation' link
	 -->
	<xsl:template match="ARTICLEFORUM" mode="r_viewallthreads">
		<xsl:copy-of select="$arrow.right" /><xsl:apply-imports/>
	</xsl:template>

	<!--
	<xsl:template match="FORUMTHREADS" mode="empty_article">
	Description: Presentation of the 'Be the first person to talk about this article' link 
	- ie if there are not threads
	 -->
	<xsl:template match="FORUMTHREADS" mode="empty_article">
	<xsl:value-of select="$m_firsttotalk"/>
	</xsl:template>

	<!--
	<xsl:template match="FORUMTHREADS" mode="full_article">
	Description: Presentation of the forum threads if some do indeed exist
	 -->
	<xsl:template match="FORUMTHREADS" mode="full_article">
		<!-- <xsl:value-of select="$m_peopletalking"/> -->
	
		<xsl:apply-templates select="THREAD" mode="c_article"/>
		
		<!-- How to create two columned threadlists: -->
		<!--table cellpadding="0" cellspacing="0" border="0">
			<xsl:for-each select="THREAD[position() mod 2 = 1]">
				<tr>
					<td>
					<xsl:apply-templates select="."/>
					</td>
					<td>
					<xsl:apply-templates select="following-sibling::THREAD[1]"/>
					</td>
				</tr>
			</xsl:for-each>
		</table-->
	</xsl:template>


	<!--
 	<xsl:template match="THREAD" mode="r_article">
 	Presentation of each individual thread listed at the bottom of the article
 	-->
	<xsl:template match="THREAD" mode="r_article">
		<table cellspacing="0" cellpadding="0" border="0" width="395">
		<tr>
		<td rowspan="2" width="25" class="myspace-e-3">&nbsp;</td>
		<td class="brown">
		<xsl:element name="{$text.base}" use-attribute-sets="text.base"><xsl:apply-templates select="@THREADID" mode="t_threadtitlelink"/></xsl:element>
		</td>
		</tr><tr>
		<td class="orange">
			<div class="posted-by"><xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall">
			<xsl:value-of select="TOTALPOSTS" /> comments | last comment <xsl:apply-templates select="@THREADID" mode="t_threaddatepostedlink"/> </xsl:element></div>
		</td>
		</tr>
		</table>

	</xsl:template>

	
	<xsl:attribute-set name="maTHREADID_t_threadtitlelink">
			<xsl:attribute name="class">article-title</xsl:attribute>
	</xsl:attribute-set>










	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
				ARTICLEINFO Object
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<xsl:template match="ARTICLEINFO" mode="r_articlepage">
		
		<!--  @cv@? what should go here? used to be the RIGHT COLUMN
					  moved the siteconfig reference up to the main template. don't really belong in the ARTICLEINFO object 
					  ? but we are not using any of the ARTICLEINFO, are we? -->
			
		
		
	</xsl:template>
	<!-- 
	<xsl:template match="LINKTITLE">
	Use: presentation of an articles's useful link
	-->
	<xsl:template match="LINKTITLE">
	
		<xsl:choose>
		<xsl:when test="string-length() &gt; 30">
		<xsl:value-of select="substring(./text(),1,26)" />...
		</xsl:when>
		<xsl:otherwise>
		<xsl:value-of select="./text()" />
		</xsl:otherwise>
		</xsl:choose>
		
	</xsl:template>
	

	<!-- 
	<xsl:template match="STATUS/@TYPE" mode="r_articlestatus">
	Use: presentation of an article's status
	-->
	<xsl:template match="STATUS/@TYPE" mode="r_articlestatus">
		<xsl:copy-of select="$m_status"/>
		<xsl:apply-imports/>
	</xsl:template>
	<!-- 
	<xsl:template match="ENTRY-SUBBED/@VISIBLE" mode="r_returntoeditors">
	Use: presentation of a Return to editors link
	-->
	<xsl:template match="ENTRY-SUBBED/@VISIBLE" mode="r_returntoeditors">
	<b>Return to editors</b><br/>
		<xsl:apply-imports/>
	</xsl:template>
	<!-- 
	<xsl:template match="H2G2ID" mode="r_categoriselink">
	Use: presentation of a 'categorise this article' link
	-->
	<xsl:template match="H2G2ID" mode="r_categoriselink">
		<b>Categorise</b><br />
		<xsl:apply-imports/>
	</xsl:template>
		<!-- c="H2G2ID" mode="r_removeself">
	Use: presentation of a 'remove my name fromt		
	he authors' link
	-->
	<xsl:template match="H2G2ID" mode="r_removeself">
	<b>Remove self from list</b><br/>
	<xsl:apply-imports/>
	</xsl:template>
	<!--
	<xsl:template match="ARTICLEINFO" mode="r_editbutton">
	Author:		Tom Whitehouse
	Context:      /H2G2/ARTICLE or /H2G2/ARTCLE/ARTICLEINFO
	Purpose:	 Creates the 'Edit this' link
	-->
	<xsl:template match="ARTICLEINFO" mode="r_editbutton">
		<a href="{$root}TypedArticle?aedit=new&amp;h2g2id={H2G2ID}&amp;type={$current_article_type}" xsl:use-attribute-sets="mARTICLE_r_editbutton"><xsl:copy-of select="$m_editentrylinktext"/></a>	
	</xsl:template>
	<!-- 
	<xsl:template match="ARTICLEINFO" mode="c_editbutton">
	Use: presentation for the 'create article/review' of edit link
	-->
	<xsl:template match="ARTICLEINFO" mode="c_createbutton">
	<a href="{$root}TypedArticle?acreate=new&amp;type={$current_article_type}" xsl:use-attribute-sets="nc_createnewarticle">
	<xsl:value-of select="$m_clicknewreview"/><xsl:value-of select="$article_type_group"/> 
	</a>
	</xsl:template>

	<!-- 
	<xsl:template match="ARTICLEINFO" mode="c_addindex">
	Use: add article to the index
	-->
		
	<xsl:template match="ARTICLEINFO" mode="c_addindex">
	<a href="{$root}TagItem?action=add&amp;tagitemid={/H2G2/ARTICLE/ARTICLEINFO/H2G2ID}&amp;tagitemtype=10&amp;">add to index</a>
	</xsl:template>
	
	
	<!-- 
	<xsl:template match="RELATEDMEMBERS" mode="c_relatedmembersAP">
	Use: presentation of all related articles container
	-->
	<xsl:template match="RELATEDMEMBERS" mode="c_relatedmembersAP">
		<xsl:apply-templates select="RELATEDCLUBS" mode="c_relatedclubsAP"/>
		<xsl:apply-templates select="RELATEDARTICLES" mode="c_relatedarticlesAP"/>
	</xsl:template>
	<!-- 
	<xsl:template match="RELATEDARTICLES" mode="r_relatedarticlesAP">
	Use: presentation of the list of related articles container
	-->
	
	<xsl:template match="RELATEDARTICLES" mode="r_relatedarticlesAP">
		<xsl:apply-templates select="ARTICLEMEMBER" mode="c_relatedarticlesAP"/>
	</xsl:template>
	<!-- 
	<xsl:template match="ARTICLEMEMBER" mode="r_relatedarticlesAP">
	Use: presentation of a single related article
	-->
	<xsl:template match="ARTICLEMEMBER" mode="r_relatedarticlesAP">
		<div><xsl:apply-imports/></div>
	</xsl:template>








	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
				REFERENCES Object
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<xsl:template match="REFERENCES" mode="r_articlerefs">
		<b>References</b>
		
		<br/>
		<xsl:apply-templates select="ENTRIES" mode="c_articlerefs"/>
		<xsl:apply-templates select="USERS" mode="c_articlerefs"/>
		<xsl:apply-templates select="EXTERNAL" mode="c_bbcrefs"/>
		<xsl:apply-templates select="EXTERNAL" mode="c_nonbbcrefs"/>
	</xsl:template>
	<!-- 
	<xsl:template match="ENTRIES" mode="r_articlerefs">
	Use: presentation for the 'List of referenced entries' logical container
	-->
	<xsl:template match="ENTRIES" mode="r_articlerefs">
		<b>
			<xsl:value-of select="$m_refentries"/>
		</b>
		<br/>
		<xsl:apply-templates select="ENTRYLINK" mode="c_articlerefs"/>
		<br/>
	</xsl:template>
	<!-- 
	<xsl:template match="ENTRYLINK" mode="r_articlerefs">
	Use: presentation of each individual entry link
	-->
	<xsl:template match="ENTRYLINK" mode="r_articlerefs">
		<xsl:apply-imports/>
		<br/>
	</xsl:template>
	<!-- 
	<xsl:template match="REFERENCES/USERS" mode="r_articlerefs">
	Use: presentation of of the 'List of referenced users' logical container
	-->
	<xsl:template match="REFERENCES/USERS" mode="r_articlerefs">
		<b>
			<xsl:value-of select="$m_refresearchers"/>
		</b>
		<br/>
		<xsl:apply-templates select="USERLINK" mode="c_articlerefs"/>
		<br/>
	</xsl:template>
	<!-- 
	<xsl:template match="USERLINK" mode="r_articlerefs">
	Use: presentation of each individual link to a user in the references section
	-->
	<xsl:template match="USERLINK" mode="r_articlerefs">
		<xsl:apply-imports/>
		<br/>
	</xsl:template>
	<!-- 
	<xsl:template match="REFERENCES/EXTERNAL" mode="r_bbcrefs">
	Use: Presentation of the container listing all bbc references
	-->
	<xsl:template match="REFERENCES/EXTERNAL" mode="r_bbcrefs">
		<b>
			<xsl:value-of select="$m_otherbbcsites"/>
		</b>
		<br/>
		<xsl:apply-templates select="EXTERNALLINK" mode="c_bbcrefs"/>
		<br/>
	</xsl:template>
	<!-- 
	<xsl:template match="REFERENCES/EXTERNAL" mode="r_nonbbcrefs">
	Use: Presentation of the container listing all external references
	-->
	<xsl:template match="REFERENCES/EXTERNAL" mode="r_nonbbcrefs">
		<b>
			<xsl:value-of select="$m_refsites"/>
		</b>
		<br/>
		<xsl:apply-templates select="EXTERNALLINK" mode="c_nonbbcrefs"/>
		<br/>
	</xsl:template>
	<!-- 
	<xsl:template match="EXTERNALLINK" mode="r_articlerefsbbc">
	Use: presentation of each individual external link to a BBC page in the references section
	-->
	<xsl:template match="EXTERNALLINK" mode="r_bbcrefs">
		<xsl:apply-imports/>
		<br/>
	</xsl:template>
	<!-- 
	<xsl:template match="EXTERNALLINK" mode="r_articlerefsext">
	Use: presentation of each individual external link to a non-BBC page in the references section
	-->
	<xsl:template match="EXTERNALLINK" mode="r_nonbbcrefs">
		<xsl:apply-imports/>
		<br/>
	</xsl:template>









	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
				PAGEAUTHOR Object
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<xsl:template match="PAGEAUTHOR" mode="r_article">
		<xsl:apply-templates select="RESEARCHERS" mode="c_article"/>
		<xsl:apply-templates select="EDITOR" mode="c_article"/>
	</xsl:template>
	<!-- 
	<xsl:template match="RESEARCHERS" mode="r_article">
	Use: presentation of the researchers for an article, if they exist
	-->
	<xsl:template match="RESEARCHERS" mode="r_article">
		<xsl:apply-templates select="USER" mode="c_researcherlist"/>
	</xsl:template>
	<!-- 
	<xsl:template match="USER" mode="r_researcherlist">
	Use: presentation of each individual user in the RESEARCHERS section
	-->
	<xsl:template match="USER" mode="r_researcherlist">
		<xsl:apply-imports/>,
	</xsl:template>
	<!-- 
	<xsl:template match="EDITOR" mode="r_article">
	Use: presentation of the editor of an article
	-->
	<xsl:template match="EDITOR" mode="r_article">
		<xsl:apply-templates select="USER" mode="c_articleeditor"/>
	</xsl:template>
	<!-- 
	<xsl:template match="USER" mode="r_articleeditor">
	Use: presentation of each individual user in the EDITOR section
	-->
	<xsl:template match="USER" mode="r_articleeditor">
		<xsl:apply-imports/>
	</xsl:template>











	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
				CRUMBTRAILS Object
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<!-- 
	<xsl:template match="CRUMBTRAILS" mode="r_article">
	Use: Presentation of the crumbtrails section
	-->
	<xsl:template match="CRUMBTRAILS" mode="r_article">
		<xsl:apply-templates select="CRUMBTRAIL" mode="c_article"/>
	</xsl:template>
	
	<!-- 
	<xsl:template match="CRUMBTRAILS" mode="c_crumbremove">
	Use: remove from index
	-->
	<xsl:template match="CRUMBTRAILS" mode="c_crumbremove">
	<!-- REMOVE FROM INDEX -->
	<a href="{$root}tagitem?action=remove&amp;tagitemtype=1&amp;tagitemid={/H2G2/ARTICLE/ARTICLEINFO/H2G2ID}&amp;tagorigin={CRUMBTRAIL/ANCESTOR[position()=last()]/NODEID}">remove from the index</a>
	</xsl:template>
	
	<!-- 
	<xsl:template match="CRUMBTRAIL" mode="r_article">
	Use: Presentation of an individual crumbtrail
	-->
	<xsl:template match="CRUMBTRAIL" mode="r_article">
		<xsl:apply-templates select="ANCESTOR" mode="c_article"/>
		<br/>
	</xsl:template>
	<!-- 
	<xsl:template match="ANCESTOR" mode="r_article">
	Use: Presentation of an individual link in a crumbtrail
	-->
	<xsl:template match="ANCESTOR" mode="r_article">
		<xsl:apply-imports/>
		<xsl:if test="following-sibling::ANCESTOR">
			<xsl:text> / </xsl:text>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="ARTICLE" mode="r_categorise">
	</xsl:template>
	
	<xsl:template match="FURNITURE/PICTURE">
	<a><xsl:apply-templates select="@DNAID | @HREF"/>
			<img src="{$graphics}{@NAME}" alt="{@ALT}" width="{@WIDTH}" height="{@HEIGHT}" border="0"/></a>
	</xsl:template>
	
	
	<xsl:template match="SNIPPET" mode="c_valignbottom">
		<xsl:apply-templates select="BODY/*[not(self::FONT)]"/>
	</xsl:template>
	
	
	<xsl:template match="SNIPPET" mode="c_realmedia">
	<!-- realmedia box layout -->
	
		<tr>
			<td valign="top">
				<div class="guideml-c">
					<xsl:apply-templates select="ICON"/><xsl:apply-templates select="IMG"/>&nbsp;
					<font size="2"><b><xsl:apply-templates select="TEXT"/></b></font>
				</div>
			</td>
			<td valign="top">
				<div class="snippet">
					<xsl:apply-templates select="BODY"/>
				</div>
			</td>
		</tr>
	</xsl:template>
	<!--
	<xsl:template name="ARTICLE_HEADER">
	Author:		Andy Harris
	Context:	/H2G2
	Purpose:	Creates the title for the page which sits in the html header
	-->
	<xsl:template name="ARTICLE_HEADER">
		<xsl:apply-templates mode="header" select=".">
			<xsl:with-param name="title">
				<xsl:value-of select="$m_pagetitlestart"/>
				<xsl:choose>
					<xsl:when test="ARTICLE/ARTICLEINFO[HIDDEN='1']">
						<xsl:copy-of select="$m_articlehiddentitle"/>
					</xsl:when>
					<xsl:when test="ARTICLE/ARTICLEINFO[HIDDEN='2']">
						<xsl:copy-of select="$m_articlereferredtitle"/>
					</xsl:when>
					<xsl:when test="ARTICLE/ARTICLEINFO[HIDDEN='3']">
						<xsl:copy-of select="$m_articleawaitingpremoderationtitle"/>
					</xsl:when>
					<xsl:when test="ARTICLE/ARTICLEINFO[HIDDEN='4']">
						<xsl:copy-of select="$m_legacyarticleawaitingmoderationtitle"/>
					</xsl:when>
					<xsl:when test="/H2G2/ARTICLE/ARTICLEINFO/STATUS[@TYPE='7']">
						<xsl:copy-of select="$m_articledeletedtitle"/>
					</xsl:when>
					<xsl:when test="not(/H2G2/ARTICLE/SUBJECT)">
						<xsl:copy-of select="$m_nosuchguideentry"/>
					</xsl:when>
					<xsl:when test="$article_type_group = 'frontpage' and /H2G2[@TYPE='ARTICLE']/ARTICLE/GUIDE/BODY/PAGETITLE">
						<xsl:value-of select="/H2G2[@TYPE='ARTICLE']/ARTICLE/GUIDE/BODY/PAGETITLE" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="ARTICLE/SUBJECT"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>

	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
							EDITOR BOX Object
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	
	<xsl:template name="editorbox">

		<!-- EDITOR BOX @07-->
		<xsl:if test="$test_IsEditor">
			<br /><br />
			<table border="0" cellspacing="3" cellpadding="5" class="generic-n">
				<tr>
					<td class="generic-n-3">
						<xsl:element name="{$text.base}" use-attribute-sets="text.base">
						<h3>For editors only</h3>
						Status: <xsl:value-of select="/H2G2/ARTICLE/ARTICLEINFO/STATUS/@TYPE" /><br /><br />
						<xsl:if test="not($current_article_type=1)and not($current_article_type=2)">
							<form method="post" action="/dna/collective/TypedArticle">
							<input type="hidden" name="_msxml" value="{$articlefields}"/>
							<input type="hidden" name="s_typedarticle" value="edit" />
							<input type="hidden" name="_msstage" value="1" />
							<input type="hidden" name="h2g2id" value="{/H2G2/ARTICLE/ARTICLEINFO/H2G2ID}" />
							<input type="hidden" name="_msfinish" value="yes" />
							<input type="hidden" name="type" value="{$selected_member_type}" />
							<input type="hidden" name="title" value="{/H2G2/ARTICLE/SUBJECT}" />
							<input type="hidden" name="ADD_LINKS" value="{/H2G2/ARTICLE/GUIDE/ADD_LINKS}" />
							
							<!-- @101 i added this and don't know if it helps. don't think it is necessary -->
							<input type="hidden" name="TYPE" value="{/H2G2/ARTICLE/EXTRAINFO/TYPE}" />
							
							<input type="hidden" name="READ_LINKS" value="{/H2G2/ARTICLE/GUIDE/READ_LINKS}" />
							<input type="hidden" name="WATCH_LISTEN" value="{/H2G2/ARTICLE/GUIDE/WATCH_LISTEN}" />
							<input type="hidden" name="RELATED_WORKS" value="{/H2G2/ARTICLE/GUIDE/RELATED_WORKS}" />
							<input type="hidden" name="body">
							<xsl:attribute name="value">
							<xsl:apply-templates select="/H2G2/ARTICLE/GUIDE/BODY/* | /H2G2/ARTICLE/GUIDE/BODY/text()" mode="XML_fragment" />
							</xsl:attribute>
							</input>
							<input type="hidden" name="LINKTITLE" value="{/H2G2/ARTICLE/GUIDE/LINKTITLE}" />
							<input type="hidden" name="USEFULLINKS" value="{/H2G2/ARTICLE/GUIDE/USEFULLINKS}" />
							<input type="hidden" name="STATUS" value="3" />
							<input type="submit" value="select/deselect this article" name="aupdate" />
							</form>
						</xsl:if>
			
						<form method="post" action="siteconfig" xsl:use-attribute-sets="fSITECONFIG-EDIT_c_siteconfig">
							<input type="hidden" name="_msxml" value="{$configfields}"/>
							<input  type="submit" value="edit siteconfig" />
						</form>
			
						<br />
						<!-- @cv@ I had deleted some 'only show in preview' code from the collective templates. i may need to reinstate that code -->
						<!-- TYPEDARTICLE -->
						<div>
						Use to go to Typed article After you have set to GuideMl<br />
						&nbsp;<img src="{$imagesource}icons/beige/icon_edit.gif" alt="" width="20" height="20" border="0"/><xsl:text>  </xsl:text><a href="{$root}TypedArticle?aedit=new&amp;h2g2id={/H2G2/ARTICLE/ARTICLEINFO/H2G2ID}&amp;type={$current_article_type}" xsl:use-attribute-sets="mARTICLE_r_editbutton"><xsl:copy-of select="$m_editentrylinktext"/></a> (TypedArticle)
						</div>
						<br />
						<!-- USEREDIT -->
						<div>
						use to hide or to change to GuideML or to add Editors <br />
						&nbsp;<img src="{$imagesource}icons/beige/icon_edit.gif" alt="" width="20" height="20" border="0"/><xsl:text>  </xsl:text><a href="{$root}UserEdit{/H2G2/ARTICLE/ARTICLEINFO/H2G2ID}"><xsl:copy-of select="$m_editentrylinktext"/></a> (UserEdit)</div>		
						</xsl:element>
					</td>
				</tr>
			</table>
		</xsl:if>

	</xsl:template>

	<xsl:template match="*" mode="XML_fragment">
		<xsl:choose>
			<xsl:when test="* | text()">
				<![CDATA[<]]><xsl:value-of select="name()"/><xsl:apply-templates select="@*" mode="XML_fragment"/><![CDATA[>]]>
				<xsl:apply-templates select="* | text()" mode="XML_fragment"/>
				<![CDATA[</]]><xsl:value-of select="name()"/><![CDATA[>]]>
			</xsl:when>
			<xsl:otherwise>
				<![CDATA[<]]><xsl:value-of select="name()"/><xsl:apply-templates select="@*" mode="XML_fragment"/><![CDATA[/>]]>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="@*" mode="XML_fragment">
		<xsl:text> </xsl:text>
		<xsl:value-of select="name()"/><![CDATA[="]]><xsl:value-of select="."/><![CDATA["]]>
	</xsl:template>


		
</xsl:stylesheet>