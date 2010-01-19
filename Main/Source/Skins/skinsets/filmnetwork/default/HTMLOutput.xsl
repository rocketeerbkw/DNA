<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet exclude-result-prefixes="msxsl local s dt" version="1.0" xmlns:dt="urn:schemas-microsoft-com:datatypes" xmlns:local="#local-functions" xmlns:msxsl="urn:schemas-microsoft-com:xslt"
        xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
        <!--===============Imported Files=====================-->
        <xsl:import href="../../../base/base-extra.xsl"/>
        <!--===============Included Files=====================-->
        <xsl:include href="addjournalpage.xsl"/>
        <xsl:include href="addthreadpage.xsl"/>
        <xsl:include href="articlepage.xsl"/>
        <xsl:include href="articlepage_templates.xsl"/>
        <xsl:include href="categories.xsl"/>
        <xsl:include href="categorypage.xsl"/>
        <xsl:include href="cominguppage.xsl"/>
        <xsl:include href="debug.xsl"/>
        <xsl:include href="editcategorypage.xsl"/>
        <xsl:include href="emailalertgroupspage.xsl"/>
        <xsl:include href="filmmakersnotes.xsl"/>
        <xsl:include href="filmnetworktext.xsl"/>
        <xsl:include href="filmnetworkbuttons.xsl"/>
        <xsl:include href="filmnetworkicons.xsl"/>
        <xsl:include href="filmnetwork-sitevars.xsl"/>
        <xsl:include href="frontpage.xsl"/>
        <xsl:include href="guideml.xsl"/>
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
        <xsl:include href="noticeboardpage.xsl"/>
        <xsl:include href="onlinepopup.xsl"/>
        <xsl:include href="promos.xsl"/>
        <xsl:include href="registerpage.xsl"/>
        <xsl:include href="reviewforumpage.xsl"/>
        <xsl:include href="siteconfigpage.xsl"/>
        <xsl:include href="searchpage.xsl"/>
        <xsl:include href="submitreviewforumpage.xsl"/>
        <xsl:include href="tagitempage.xsl"/>
        <xsl:include href="teamlistpage.xsl"/>
        <xsl:include href="threadspage.xsl"/>
        <xsl:include href="typedarticlepage.xsl"/>
        <xsl:include href="types.xsl"/>
        <xsl:include href="usercomplaintpopup.xsl"/>
        <xsl:include href="userdetailspage.xsl"/>
        <xsl:include href="usereditpage.xsl"/>
        <xsl:include href="usermyclubspage.xsl"/>
        <xsl:include href="userpage.xsl"/>
        <xsl:include href="votepage.xsl"/>
        <xsl:include href="watcheduserspage.xsl"/>
        <!--===============Included Files=====================-->
        <!--===============Output Setting=====================-->
        <xsl:output encoding="ISO8859-1" indent="yes" method="html" omit-xml-declaration="yes" standalone="yes" version="4.0"/>
        <!--===============CSS=====================-->
        <xsl:variable name="csslink">
                <xsl:if test="/H2G2/@TYPE = 'FRONTPAGE'"> </xsl:if>
                <style type="text/css">                  
			body {margin:0;}
			form {margin:0;padding:0;}
			a.bbcpageFooter, a.bbcpageFooter:link, a.bbcpageFooter:visited {color:#5E5D5D;}
			.bbcpageCrumb {font-weight:bold; text-align:right;}
			a.bbcpageCrumb, a.bbcpageCrumb:link,a.bbcpageCrumb:visited  {padding-right:5px; color:#575656;}
			a.bbcpageTopleftlink {color:#575656;}
			a.bbcpageTopleftlink:link {color:#575656;}
			.bbcpageServices {background:#a3a3a3;font-family:'Trebuchet MS', Verdana, Arial, sans-serif; color:#575656;}
			.bbcpageServices hr {display:none;}
			a.bbcpageServices {color:#575656; padding-right:10px;}
			a.bbcpageServices:link {color:#575656;}
			.bbcpageToplefttd {background:#a3a3a3; font-family:'Trebuchet MS', Verdana, Arial, sans-serif;}
			.bbcpageFooterMargin {background:#a3a3a3;}
			.bbcpageLocal {background:#a3a3a3;}
			.bbcpageShadow {background-color:#828282;}
			.bbcpageShadowLeft {border-left:2px solid #828282;}
			.bbcpageBar {background:#999999 url(/images/v.gif) repeat-y;}
			.bbcpageSearchL {background:#747474 url(/images/sl.gif) no-repeat;}
			.bbcpageSearch {background:#747474 url(/images/st.gif) repeat-x;}
			.bbcpageSearch2 {background:#747474 url(/images/st.gif) repeat-x 0 0;}
			.bbcpageSearchRa {background:#999999 url(/images/sra.gif) no-repeat;}
			.bbcpageSearchRb {background:#999999 url(/images/srb.gif) no-repeat;}
			.bbcpageBlack {background-color:#000000} 
			.bbcpageGrey, .bbcpageShadowLeft {background-color:#999999}
			.bbcpageWhite, font.bbcpageWhite, a.bbcpageWhite, a.bbcpageWhite:link, a.bbcpageWhite:hover, a.bbcpageWhite:visited {color:#ffffff;text-decoration:none;font-family:verdana,arial,helvetica,sans-serif;padding:1px 4px;}
		</style>
		<xsl:if test="/H2G2/@TYPE = 'FRONTPAGE'">
				<xsl:comment>#if expr='${bbcpage_survey_go} = 1' </xsl:comment>
				<xsl:comment>#include virtual="/includes/survey_css.sssi" </xsl:comment>
				<xsl:comment>#endif </xsl:comment>
			</xsl:if>
                <xsl:choose>
                        <xsl:when test="/H2G2/SERVERNAME = 'OPS-DNA1'">
                                <link href="http://ideweb-dev.national.core.bbc.co.uk/filmnetwork/includes/filmnetwork_phase2.css" rel="stylesheet" title="default" type="text/css"/>
                        </xsl:when>
                        <xsl:otherwise>
                                <link href="http://www.bbc.co.uk/filmnetwork/includes/filmnetwork_phase2.css" rel="stylesheet" title="default" type="text/css"/>
                        </xsl:otherwise>
                </xsl:choose>
                <xsl:call-template name="insert-css"/>
        </xsl:variable>
        <!--===============CSS=====================-->
        <!--===============Attribute-sets Settings=====================-->
        <xsl:attribute-set name="mainfont">
                <xsl:attribute name="size">2</xsl:attribute>
        </xsl:attribute-set>
        <!--===============Attribute-sets Settings=====================-->
        <!--===============Javascript=====================-->
        <xsl:variable name="scriptlink">
                <!-- meta refresh for the email alerts -->
                <xsl:if test="/H2G2/PARAMS/PARAM/NAME='s_alertsRefresh'">
                        <meta http-equiv="refresh">
                                <xsl:attribute name="content">
                                        <xsl:choose>
                                                <xsl:when test="/H2G2/FORUMTHREADPOSTS/@GROUPALERTID or        /H2G2/EMAIL-SUBSCRIPTION/SUBSCRIPTION">0;url=<xsl:value-of select="$root"/>AlertGroups</xsl:when>
                                                <xsl:when test="/H2G2/PARAMS/PARAM[NAME='s_alertsRefresh']/VALUE = '4'">0;url=<xsl:value-of select="$root"
                                                                />alertgroups?cmd=add&amp;itemid=<xsl:value-of select="/H2G2/SUBSCRIBE-STATE/@FORUMID"
                                                        />&amp;itemtype=4&amp;s_view=confirm&amp;s_origin=message</xsl:when>
                                                <xsl:when test="/H2G2/PARAMS/PARAM[NAME='s_alertsRefresh']/VALUE = '5'">0;url=<xsl:value-of select="$root"
                                                                />alertgroups?cmd=add&amp;itemid=<xsl:value-of select="/H2G2/SUBSCRIBE-STATE/@THREADID"
                                                        />&amp;itemtype=5&amp;s_view=confirm&amp;s_origin=film</xsl:when>
                                        </xsl:choose>
                                </xsl:attribute>
                        </meta>
                </xsl:if>
                <script language="JavaScript1.1" src="{$site_server}/filmnetwork/includes/dynamichtml.js" type="text/javascript"/>
                <script type="text/javascript">
<![CDATA[<!--
				function popmailwin(x, y) {window.open(x,y,'status=no,scrollbars=yes,resizable=yes,width=350,height=400');} 
//-->]]>
			//<![CDATA[
				<!--Site wide Javascript goes here-->
				function popupwindow(link, target, parameters) {
					popupWin = window.open(link,target,parameters);
					if (window.focus) {popupWin.focus();}
				}
				function popusers(link) {
					popupWin = window.open(link,'popusers','status=1,resizable=1,scrollbars=1,width=165,height=340');
				}
				function submitForm(){
				document.setDetails.submit();
				}
				function popmailwin(x, y){
					window.open(x,y,'status=no,scrollbars=yes,resizable=yes,width=350,height=400');
				}
			//	function rsubmitFormNow(){
			//		Id = window.setTimeout("submitFormNow();",1000);
			//	} 
			function validate(form){	
				flag = true;
				var reqfields;
				reqfields=document.getElementById('required').value.split(',');
				for(i=0;i < reqfields.length;i++){
					if(form.elements(reqfields[i]).value == ""){
						flag = false;
						document.getElementById(reqfields[i]).style.color='#FF0000';
						document.getElementById('validatemsg').style.visibility='visible';
						//return false;
					}else{
						document.getElementById(reqfields[i]).style.color='#5E5D5D';
					}
				}
				//if any fields are empty don't submit
				if(flag == false){
					return false;
				}
				//if email address is invalid alert he user
				if(form.email){
					var str = form.email.value;
					var re = /^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$/;	
					if(!str.match(re)){
						alert("Please check you have typed your email address correctly.");
						return false; 
					}
				}
			return true;
			}
			//]]>
		</script>
                <xsl:if test="/H2G2/@TYPE='TYPED-ARTICLE'">
                        <script type="text/javascript">
				//<![CDATA[
					/* onload function to hide other region and languages text boxes on the form submission page */
					function formInit(){
						if(document.getElementsByTagName){
							var rowElements = document.getElementsByTagName('tr');
							for(var i = 0; i < rowElements.length; i++){
								if(rowElements[i].className == 'jsHidden'){
									var selectElement = rowElements[i-1].getElementsByTagName('select')[0];
									if(selectElement.selectedIndex != (selectElement.length - 1)){
										rowElements[i].style.display = 'none';
									}
								}
							}
						}
					}
					/* function to dynamically display/hide text boxes on the film submission page */
					function dropDown(selectElement, id){
						if(document.getElementById){
							var textBox = document.getElementById(id);
							if(selectElement.selectedIndex == (selectElement.length - 1)){
								textBox.style.display = "";
							}else{
								textBox.style.display = "none";
							}
						}
					}						
				//]]>
			</script>
                </xsl:if>
                <xsl:if test="/H2G2/@TYPE='ARTICLE'">
                        <script type="text/javascript">
				//<![CDATA[
				window.onload = function(){
					    var list = document.getElementById('filmmaking_index');
					    if(!list){
						    return;
					    };
                                         var reUrl = /\/(\w*)$/;
                        		    var articleNo = reUrl.exec(location.pathname);
					    var indexItems = list.getElementsByTagName('li');
					    for(var i = 0; i < indexItems.length; i++){
					        if((indexItems[i].getAttribute('class') == 'index_items') || (indexItems[i].getAttribute('className') == 'index_items')){
                                		 	var expand = false;
                                			var siblings = indexItems[i].parentNode.childNodes
                                			for(var j = 0; j < siblings.length; j++){
                                    				if(siblings[j].nodeType == 1){
                                        				var href = siblings[j].getElementsByTagName('a')[0].getAttribute('href');
                                        				var thisArticle = reUrl.exec(href);
                                        				if(thisArticle && articleNo && (thisArticle[1] == articleNo[1])){
                                            				expand = true;
                                            				break;
                                        				}
                                    				}
                                			}
                                			if(!expand){
					               	indexItems[i].style.display = 'none';
                                			}
                                else{
                                        indexItems[i].parentNode.parentNode.style.backgroundImage = "url('http://www.bbc.co.uk/filmnetwork/images/furniture/crosshair_open.gif')";
                                }
					        }
					        if((indexItems[i].getAttribute('class') == 'index_categories') || (indexItems[i].getAttribute('className') == 'index_categories')){
					            var spanObj = indexItems[i].getElementsByTagName('span')[0];
					            spanObj.onclick = expandIndex;
					            spanObj.style.cursor = 'pointer';
					        }
					    }
					}
					function expandIndex(){
					    var subIndexItems = this.parentNode.getElementsByTagName('li'); 
                                if(subIndexItems.length && subIndexItems[0].style.display === ''){
                                        this.parentNode.style.backgroundImage = "url('http://www.bbc.co.uk/filmnetwork/images/furniture/crosshair_closed.gif')";
                                }else if(subIndexItems.length){
                                        this.parentNode.style.backgroundImage = "url('http://www.bbc.co.uk/filmnetwork/images/furniture/crosshair_open.gif')";
                                }else{
                                        this.parentNode.style.backgroundImage = 'none';
                                }
                                
					    for(var i = 0; i < subIndexItems.length; i++){
					        if(subIndexItems[i].style.display == 'none'){
					            subIndexItems[i].style.display = '';
					        }
					        else{
					            subIndexItems[i].style.display = 'none';
					        }
					    }
				}
				//]]>
			</script>
                </xsl:if>
        </xsl:variable>
        <!--===============Javascript=====================-->
        <!--===============Variable Settings=====================-->
        <xsl:variable name="skinname">filmnetwork</xsl:variable>
        <xsl:variable name="bbcpage_bgcolor">ffffff</xsl:variable>
        <xsl:variable name="bbcpage_nav">yes</xsl:variable>
        <xsl:variable name="bbcpage_navwidth">125</xsl:variable>
        <xsl:variable name="bbcpage_navgraphic">yes</xsl:variable>
        <xsl:variable name="bbcpage_navgutter">yes</xsl:variable>
        <xsl:variable name="bbcpage_contentwidth">635</xsl:variable>
        <xsl:variable name="bbcpage_contentalign">left</xsl:variable>
        <xsl:variable name="bbcpage_language">english</xsl:variable>
        <xsl:variable name="bbcpage_searchcolour">747474</xsl:variable>
        <xsl:variable name="bbcpage_topleft_bgcolour"/>
        <xsl:variable name="bbcpage_topleft_linkcolour"/>
        <xsl:variable name="bbcpage_topleft_textcolour"/>
        <xsl:variable name="bbcpage_lang"/>
        <xsl:variable name="bbcpage_variant"/>
        <xsl:variable name="site_number">
                <xsl:value-of select="/H2G2/SITE-LIST/SITE[NAME='filmnetwork']/@ID"/>
        </xsl:variable>
        <!-- show fake gifs or no change bottom otherwise statement to turn on or off yes or no -->
        <xsl:variable name="showfakegifs">
                <xsl:choose>
                        <xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_fake']/VALUE = 'yes'">yes</xsl:when>
                        <xsl:otherwise>no</xsl:otherwise>
                        <!-- change to yes to display for testing -->
                </xsl:choose>
        </xsl:variable>
        <!-- where all these images are held straight after $imagsource-->
        <xsl:variable name="gif_assets">shorts/</xsl:variable>
        <!--===============Variable Settings=====================-->
        <!--===============Category numbers=====================-->
        <!--===============Banner Template (Banner Area Stuff)=====================-->
        <xsl:variable name="banner-content">
                <!-- Banner -->
                <xsl:choose>
                        <xsl:when test="/H2G2/@TYPE='UNAUTHORISED'">
                                <table border="0" cellpadding="0" cellspacing="0" class="banner" width="635">
                                        <tr>
                                                <td width="1%">
                                                        <img alt="film network - short films from new British filmmakers" height="80" src="{$imagesource}furniture/banner_filmnetwork.gif" width="382"/>
                                                </td>
                                        </tr>
                                </table>
                        </xsl:when>
                        <xsl:otherwise>
                                <table border="0" cellpadding="0" cellspacing="0" class="banner" width="635">
                                        <tr>
                                                <td width="1%">
                                                        <img alt="film network - short films from new British filmmakers" height="80" src="{$imagesource}furniture/banner_filmnetwork.gif" width="382"/>
                                                </td>
                                                <td class="bannersearch">search film network<br/>
                                                        <form action="{$root}Search" method="get" xsl:use-attribute-sets="fc_search_dna">
                                                                <input name="ShowContentRatingData" type="hidden" value="1"/>
                                                                <input class="bannerinput" name="searchstring" size="20" type="text"/>
                                                                <input alt="search film network" border="0" height="18" id="bannerBtnGo" name="dosearch" src="{$imagesource}furniture/banner_go.gif"
                                                                        type="image" width="26"/>
                                                        </form>
                                                </td>
                                        </tr>
                                </table>
                        </xsl:otherwise>
                </xsl:choose>
        </xsl:variable>
        <!--===============Banner Template (Banner Area Stuff)=====================-->
        <!--===============Crumb Template (Crumb Navigation Stuff)=====================-->
        <xsl:variable name="crumb-content">
                <font face="arial, helvetica,sans-serif" size="2">
                        <a class="bbcpageCrumb" href="/film/">Film</a>
                        <br/>
                </font>
        </xsl:variable>
        <!--===============Crumb Template (Crumb Navigation Stuff)=====================-->
        <!--===============Local Template (Local Navigation Stuff)=====================-->
        <xsl:template name="local-content">
                <xsl:choose>
                        <xsl:when test="/H2G2/@TYPE='UNAUTHORISED'">
                                <img alt="" height="300" src="/f/t.gif" width="1"/>
                        </xsl:when>
                        <xsl:otherwise>
                                <xsl:apply-templates select="/H2G2/SITECONFIG/LEFTHANDNAV" />
                                <xsl:if test="$VARIABLETEST = 1 or /H2G2/PARAMS/PARAM[NAME = 's_debug']/VALUE = '1'">
                                        <xsl:call-template name="VARIABLEDUMP"/>
                                </xsl:if>
                        </xsl:otherwise>
                </xsl:choose>
        </xsl:template>
        <!--===============LOCATION MAPPING=====================-->
        <!--  mapping string value (region name) to appropriate cat number -->
        <xsl:variable name="mapToRegion">
                <xsl:if test="/H2G2/ARTICLE/GUIDE[REGION='North East']">
                        <xsl:value-of select="$northeast"/>
                </xsl:if>
                <xsl:if test="/H2G2/ARTICLE/GUIDE[REGION='North West']">
                        <xsl:value-of select="$northwest"/>
                </xsl:if>
                <xsl:if test="/H2G2/ARTICLE/GUIDE[REGION='Wales']">
                        <xsl:value-of select="$wales"/>
                </xsl:if>
                <xsl:if test="/H2G2/ARTICLE/GUIDE[REGION='Northern Ireland']">
                        <xsl:value-of select="$nthireland"/>
                </xsl:if>
                <xsl:if test="/H2G2/ARTICLE/GUIDE[REGION='Scotland']">
                        <xsl:value-of select="$scotland"/>
                </xsl:if>
                <xsl:if test="/H2G2/ARTICLE/GUIDE[REGION='East Midlands']">
                        <xsl:value-of select="$eastmidlands"/>
                </xsl:if>
                <xsl:if test="/H2G2/ARTICLE/GUIDE[REGION='East Of England']">
                        <xsl:value-of select="$eastofengland"/>
                </xsl:if>
                <xsl:if test="/H2G2/ARTICLE/GUIDE[REGION='London']">
                        <xsl:value-of select="$london"/>
                </xsl:if>
                <xsl:if test="/H2G2/ARTICLE/GUIDE[REGION='South East']">
                        <xsl:value-of select="$southeast"/>
                </xsl:if>
                <xsl:if test="/H2G2/ARTICLE/GUIDE[REGION='South West']">
                        <xsl:value-of select="$southwest"/>
                </xsl:if>
                <xsl:if test="/H2G2/ARTICLE/GUIDE[REGION='West Midlands']">
                        <xsl:value-of select="$westmidlands"/>
                </xsl:if>
                <xsl:if test="/H2G2/ARTICLE/GUIDE[REGION='Yorkshire &amp; Humber']">
                        <xsl:value-of select="$yorkshirehumber"/>
                </xsl:if>
        </xsl:variable>
        <!--===============TESTING FOR USER AND PAGE TYPES=====================-->
        <!--  other user type testing is done in base.xsl -->
        <xsl:variable name="isIndustryProf">
                <xsl:choose>
                        <xsl:when test="/H2G2/PAGE-OWNER/USER/GROUPS/ADVISER">1</xsl:when>
                        <xsl:otherwise>0</xsl:otherwise>
                </xsl:choose>
        </xsl:variable>
        <xsl:variable name="isFilmmaker">
                <xsl:choose>
                        <xsl:when test="/H2G2/PAGE-OWNER/USER/USER-MODE = 0 and not(/H2G2/PAGE-OWNER/USER/GROUPS/ADVISER)">1</xsl:when>
                        <xsl:otherwise>0</xsl:otherwise>
                </xsl:choose>
        </xsl:variable>
        <xsl:variable name="isStandardUser">
                <xsl:choose>
                        <xsl:when test="/H2G2/PAGE-OWNER/USER/USER-MODE = 1 and not(/H2G2/PAGE-OWNER/USER/GROUPS/ADVISER)">1</xsl:when>
                        <xsl:otherwise>0</xsl:otherwise>
                </xsl:choose>
        </xsl:variable>
        <!-- ================ PAGE COUNT BY TYPE ==============-->
        <!-- Defines keys to group the article id's so can perform
     count. XSLT doesn't allow using count() with attribute
	 values, so must use keys to group -->
        <xsl:key match="/H2G2/RECENT-ENTRIES/ARTICLE-LIST/ARTICLE/EXTRAINFO/TYPE" name="pageType" use="@ID"/>
        <xsl:variable name="featuresPageCount" select="count(/H2G2/RECENT-APPROVALS/ARTICLE-LIST/ARTICLE[SITEID = $site_number]/EXTRAINFO/TYPE[@ID=63][../../SITEID=$site_number])"/>
        <xsl:variable name="filmPageCountSet1" select="count(/H2G2/RECENT-APPROVALS/ARTICLE-LIST/ARTICLE[SITEID = $site_number][STATUS=1])"/>
        <xsl:variable name="filmPageCount" select="$filmPageCountSet1 - $featuresPageCount"/>
        <xsl:variable name="submissionPageSet1" select="key('pageType', '30')"/>
        <xsl:variable name="submissionPageSet2" select="key('pageType', '31')"/>
        <xsl:variable name="submissionPageSet3" select="key('pageType', '32')"/>
        <xsl:variable name="submissionPageSet4" select="key('pageType', '33')"/>
        <xsl:variable name="submissionPageSet5" select="key('pageType', '34')"/>
        <xsl:variable name="submissionPageSet6" select="key('pageType', '35')"/>
        <xsl:variable name="submissionPageCount"
                select="count($submissionPageSet1) + count($submissionPageSet2) + count($submissionPageSet3) + count($submissionPageSet4) + count($submissionPageSet5) + count($submissionPageSet6)"/>
        <xsl:variable name="declinedPageSet1" select="key('pageType', '50')"/>
        <xsl:variable name="declinedPageSet2" select="key('pageType', '51')"/>
        <xsl:variable name="declinedPageSet3" select="key('pageType', '52')"/>
        <xsl:variable name="declinedPageSet4" select="key('pageType', '53')"/>
        <xsl:variable name="declinedPageSet5" select="key('pageType', '54')"/>
        <xsl:variable name="declinedPageSet6" select="key('pageType', '55')"/>
        <xsl:variable name="declinedPageCount"
                select="count($declinedPageSet1) + count($declinedPageSet2) + count($declinedPageSet3) + count($declinedPageSet4) + count($declinedPageSet5) + count($declinedPageSet6)"/>
        <xsl:variable name="creditPageSet1" select="key('pageType', '70')"/>
        <xsl:variable name="creditPageSet2" select="key('pageType', '71')"/>
        <xsl:variable name="creditPageSet3" select="key('pageType', '72')"/>
        <xsl:variable name="creditPageSet4" select="key('pageType', '73')"/>
        <xsl:variable name="creditPageSet5" select="key('pageType', '74')"/>
        <xsl:variable name="creditPageSet6" select="key('pageType', '75')"/>
        <xsl:variable name="creditPageCount"
                select="count($creditPageSet1) + count($creditPageSet2) + count($creditPageSet3) + count($creditPageSet4) + count($creditPageSet5) + count($creditPageSet6)"/>
        <!--===============ARTICLE PAGE TYPE=====================-->
        <!--  test to see what type of article we are dealing with -->
        <!-- when using these in a for-each loop, becareful to pay 
     attention to the context node. as defined below, the 
	 context node will be set at ARTICLE
	 these variables will not work when testing category
	 pages.
-->
        <xsl:variable name="isCreditPage" select="/H2G2/RECENT-ENTRIES/ARTICLE-LIST/ARTICLE[SITEID = $site_number][EXTRAINFO/TYPE/@ID[substring(.,1,1)=7]]"/>
        <xsl:variable name="isNotePage" select="/H2G2/RECENT-ENTRIES/ARTICLE-LIST/ARTICLE[SITEID = $site_number][EXTRAINFO/TYPE/@ID=90]"/>
        <xsl:variable name="isSubmissionPage" select="/H2G2/RECENT-ENTRIES/ARTICLE-LIST/ARTICLE[SITEID = $site_number][EXTRAINFO/TYPE/@ID[substring(.,1,1)=3] and EXTRAINFO/TYPE/@ID!=3001]"/>
        <xsl:variable name="isFeaturesPage" select="/H2G2/RECENT-APPROVALS/ARTICLE-LIST/ARTICLE[SITEID = $site_number][EXTRAINFO/TYPE/@ID=63]"/>
        <xsl:variable name="isDeclinedPage" select="/H2G2/RECENT-ENTRIES/ARTICLE-LIST/ARTICLE[SITEID = $site_number][EXTRAINFO/TYPE/@ID[substring(.,1,1)=5]]"/>
        <xsl:variable name="isApprovedFilmPage" select="/H2G2/RECENT-APPROVALS/ARTICLE-LIST/ARTICLE[SITEID = $site_number][EXTRAINFO/TYPE/@ID[substring(.,1,1)=3]]"/>
        <!-- meta tags -->
        <xsl:variable name="meta-tags">
                <meta name="description">
                        <xsl:attribute name="content">
                                <xsl:choose>
                                        <!-- film submission -->
                                        <xsl:when test="/H2G2/ARTICLE/EXTRAINFO/TYPE/@ID =  12">How to submit your short to BBC Film Network.</xsl:when>
                                        <!-- filmakers guide -->
                                        <xsl:when test="/H2G2/ARTICLE/EXTRAINFO/TYPE/@ID =  11">A basic guide to filmmaking from formatting a script to organising a screening, with links to loads of
                                                useful online filmmaking resources.</xsl:when>
                                        <!-- magazine frontpage -->
                                        <xsl:when test="/H2G2/ARTICLE/EXTRAINFO/TYPE/@ID =  62">Interviews, profiles, masterclasses, short selections, 'how to' guide and more.</xsl:when>
                                        <!-- magazine article -->
                                        <xsl:when test="/H2G2/ARTICLE/EXTRAINFO/TYPE/@ID =  63">
                                                <xsl:value-of select="/H2G2/ARTICLE/EXTRAINFO/DESCRIPTION"/>
                                        </xsl:when>
                                        <!-- discussion -->
                                        <xsl:when test="/H2G2/ARTICLE/EXTRAINFO/TYPE/@ID =  10">Exchange advice, tips and comments with other BBC Film Network members.</xsl:when>
                                        <!-- film index -->
                                        <xsl:when test="$thisCatPage = $filmIndexPage">A directory of short films on BBC Film Network.</xsl:when>
                                        <xsl:when test="$thisCatPage = $directoryPage">A directory of BBC Film Networks members.</xsl:when>
                                        <!-- all other frontpage etc -->
                                        <xsl:when test="/H2G2/ARTICLE/EXTRAINFO/TYPE/@ID &gt; 29 and /H2G2/ARTICLE/EXTRAINFO/TYPE/@ID &lt; 35">Short film by <xsl:value-of
                                                        select="/H2G2/ARTICLE/GUIDE/DIRECTORSNAME"/>: <xsl:value-of select="/H2G2/ARTICLE/GUIDE/DESCRIPTION"/></xsl:when>
                                        <xsl:otherwise>Showcasing new UK film talent by screening short films, profiling the people who made them and providing filmmakers with the tools to exchange
                                                advice, tips and comment on each other's work.</xsl:otherwise>
                                </xsl:choose>
                        </xsl:attribute>
                </meta>
                <meta name="keywords">
                        <xsl:attribute name="content">
                                <xsl:choose>
                                        <!-- film submission -->
                                        <xsl:when test="/H2G2/ARTICLE/EXTRAINFO/TYPE/@ID =  12">submit, enter, send, work</xsl:when>
                                        <!-- filmakers guide -->
                                        <xsl:when test="/H2G2/ARTICLE/EXTRAINFO/TYPE/@ID =  11">writing, script, funding, screenings, equipment, editing, post production, watching shorts, training,
                                                rights, clearances, budget, schedule, insurance, cast, crew, glossary, pre-production, production, webguide, shoot, links, set, microphone, camera,
                                                distributor, agent, directing, hints, tips, advice, guide, how to, DV, 35mm, 16mm, Hi-Def, High Definition, character, television, TV, web guide</xsl:when>
                                        <!-- news -->
                                        <xsl:when test="/H2G2/ARTICLE/EXTRAINFO/TYPE/@ID =  62">News, film festivals, applications, events, screenings, festival, entry, entries, festivals,
                                                competition, competitions, submission, submissions, fest, funding, talks, lectures, master classes, nominations, awards, ceremonies</xsl:when>
                                        <!-- discussion -->
                                        <xsl:when test="/H2G2/ARTICLE/EXTRAINFO/TYPE/@ID =  10">Talk, comment, discussion, review, debate, chat, remarks, conversation, post, community, communicate,
                                                discuss, share, express, tips, advice, hints, message board, users, opinions, views, join in, boards, community, topics</xsl:when>
                                        <!-- film index -->
                                        <xsl:when test="$thisCatPage = $filmIndexPage">shorts, film, short films, comedy, drama, animation, experimental, documentary, music, horror, thriller, sci-fi,
                                                indie, indy, romantic, romance, action, adventure, factual, non-fiction, crime, fantasy, musical, historical, war, family, western, film noir, promos,
                                                Scotland, North East, North West, Northern Ireland, Yorkshire &amp; Humber, Wales, West Midlands, East Midlands, East Of England, South West, South
                                                East, London</xsl:when>
                                        <xsl:when test="$thisCatPage = $directoryPage">members, users, director, director of photography, camera, sound designer, sound recordist, producer, writer,
                                                cast, crew, actor, editor, production manager, costume, art director, art department, actress, animator, assistant, cameraman, cinematographer, DOP, DP,
                                                makeup, enthusiast, organisation, gaffer, grip, location manager, music, composer, production assistant, designer, runner, script editor, post
                                                production, stills, photographer, script writer, film buff</xsl:when>
                                        <!-- all other frontpage etc -->
                                        <xsl:otherwise>Short film, film, filmmaker, shorts, British, UK, talent, community, network, BBC Film Network, BBC Filmnetwork, video, profiles, film maker,
                                                film-maker, streaming, download, downloading, filming, UK Film Council, UKFC, new cinema fund, movie, independent, comedy, drama, animation,
                                                experimental, documentary, music, horror, thriller, sci-fi, indie, indy, romantic, romance, action, adventure, factual, non-fiction, crime, fantasy,
                                                musical, historical, war, family, western, film noir, promos, watching, viewing, screening, cinema, digital</xsl:otherwise>
                                </xsl:choose>
                        </xsl:attribute>
                </meta>
        </xsl:variable>
        <!-- 
	<xsl:template name="r_search_dna">
	Use: Presentation of the global search box
	-->
        <xsl:template name="r_search_dna">
                <!-- film -->
                <input name="type" type="hidden" value="1"/>
                <!-- or forum or user -->
                <input name="showapproved" type="hidden" value="1"/>
                <!-- status 1 articles -->
                <input name="showsubmitted" type="hidden" value="0"/>
                <!-- articles in a review forum -->
                <input name="shownormal" type="hidden" value="1"/>
                <!-- user articles -->
                <input name="searchstring" type="text" xsl:use-attribute-sets="it_searchstring">
                        <xsl:attribute name="class">bannerinput</xsl:attribute>
                        <xsl:attribute name="size">10</xsl:attribute>
                </input>
                <!-- or other types -->
                <!-- trent: which do we search article mem or forum-->
                <input name="searchtype" type="hidden" value="article"/>
        </xsl:template>
        <xsl:template name="r_search_dna2">
                <!-- film -->
                <input name="type" type="hidden" value="1"/>
                <!-- or forum or user -->
                <input name="showapproved" type="hidden" value="1"/>
                <!-- status 1 articles -->
                <input name="showsubmitted" type="hidden" value="1"/>
                <!-- articles in a review forum -->
                <input name="shownormal" type="hidden" value="1"/>
                <!-- user articles -->
                <input name="searchstring" type="text" xsl:use-attribute-sets="it_searchstring">
                        <xsl:attribute name="class">searchinput</xsl:attribute>
                        <xsl:attribute name="size">10</xsl:attribute>
                </input>
                <!-- or other types -->
                <!-- trent: which do we search article mem or forum-->
                <input name="searchtype" type="hidden" value="article"/>
        </xsl:template>
        <!--
	<xsl:attribute-set name="it_searchstring"/>
	Use: Presentation attributes for the search input field
	 -->
        <xsl:attribute-set name="it_searchstring"/>
        <!--
	<xsl:attribute-set name="it_submitsearch"/>
	Use: Presentation attributes for the search submit button
	 -->
        <xsl:attribute-set name="it_submitsearch"/>
        <!--
	<xsl:attribute-set name="fc_search_dna"/>
	Use: Presentation attributes for the search form element
	 -->
        <xsl:attribute-set name="fc_search_dna"/>
        <!-- 
	<xsl:template match="H2G2" mode="r_register">
	Use: Presentation of the Register link
	-->
        <xsl:template match="H2G2" mode="r_register">
                <xsl:apply-imports/>
                <br/>
        </xsl:template>
        <!-- 
	<xsl:template match="H2G2" mode="r_login">
	Use: Presentation of the Login link
	-->
        <xsl:template match="H2G2" mode="r_login">
                <xsl:apply-imports/>
                <br/>
        </xsl:template>
        <!-- 
	<xsl:template match="H2G2" mode="r_userpage">
	Use: Presentation of the User page link
	-->
        <xsl:template match="H2G2" mode="r_userpage">
                <xsl:apply-imports/>
        </xsl:template>
        <!-- 
	<xsl:template match="H2G2" mode="r_contribute">
	Use: Presentation of the Contribute link
	-->
        <xsl:template match="H2G2" mode="r_contribute">
                <xsl:apply-imports/>
                <br/>
        </xsl:template>
        <!-- 
	<xsl:template match="H2G2" mode="r_preferences">
	Use: Presentation of the Preferences link
	-->
        <xsl:template match="H2G2" mode="r_preferences">
                <xsl:apply-imports/>
                <br/>
        </xsl:template>
        <!-- 
	<xsl:template match="H2G2" mode="r_logout">
	Use: Presentation of the Logout link
	-->
        <xsl:template match="H2G2" mode="r_logout">
                <xsl:apply-imports/>
                <br/>
        </xsl:template>
        <!--===============Local Template (Local Navigation Stuff)=====================-->
        <!--===============Primary Template (Page Stuff)=====================-->
        <xsl:template name="primary-template">
                <html>
                        <xsl:call-template name="insert-header"/>
                        <body alink="#ff0000" bgcolor="#ffffff" leftmargin="0" link="#000099" marginheight="0" marginwidth="0" text="#000000" topmargin="0" vlink="#ff0000">
                                <xsl:if test="/H2G2/@TYPE='TYPED-ARTICLE'">
                                        <xsl:attribute name="onload">formInit()</xsl:attribute>
                                </xsl:if>
                                <xsl:if test="/H2G2/PARAMS/PARAM[NAME = 's_details']/VALUE = 'yes' and /H2G2/PARAMS/PARAM[NAME = 's_print']/VALUE = 1">
                                        <xsl:attribute name="onload">submitForm();</xsl:attribute>
                                </xsl:if>
                                <xsl:if test="@TYPE = 'MESSAGEBOARDSCHEDULE'">
                                        <xsl:attribute name="onload">intialise();</xsl:attribute>
                                </xsl:if>
                                <div class="navBg">
                                        <xsl:apply-templates mode="c_bodycontent" select="/H2G2"/>
                                </div>
                                <!-- DEBUG -->
                                <xsl:if test="$DEBUG = 1 or (/H2G2/PARAMS/PARAM[NAME = 's_debug']/VALUE = '1' and $test_IsEditor=1)">
                                        <xsl:apply-templates mode="debug" select="/H2G2"/>
                                </xsl:if>
                                <!-- /DEBUG -->
                        </body>
                </html>
        </xsl:template>
        <!--===============Primary Template (Page Stuff)=====================-->
        <!--===============Body Content Template (Global Content Stuff)=====================-->
        <xsl:template match="H2G2" mode="r_bodycontent">
                <xsl:call-template name="sso_statusbar"/>
                <xsl:call-template name="categories_navigation"/>
                <!-- drama comedy etc -->
                <div id="maincontent">
                        <xsl:call-template name="insert-mainbody"/>
                </div>
                <xsl:call-template name="editorbox"/>
                <xsl:choose>
                        <xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_details']/VALUE = 'yes'"/>
                        <xsl:otherwise>
                                <xsl:call-template name="FILM_DISCLAIMER"/>
                        </xsl:otherwise>
                </xsl:choose>
                <xsl:if test="$TESTING=1">
                        <xsl:call-template name="ERRORFORM"/>
                </xsl:if>
        </xsl:template>
        <xsl:template name="FILM_DISCLAIMER">
                <!-- Disclaimer -->
                <table border="0" cellpadding="0" cellspacing="0" id="footer" width="635">
                        <tr>
                                <td valign="top">
                                        <p class="disclaimertext">Some of the content on Film Network is generated by members of the public. The views expressed are theirs and unless specifically
                                                stated are not those of the BBC. The BBC is not responsible for the content of any external sites referenced. If you consider this content to be in
                                                breach of the <a href="/dna/filmnetwork/houserules">house rules</a> please alert our moderators. </p>
                                </td>
                                <td valign="top">
                                        <table border="0" cellpadding="0" cellspacing="0" id="AboutFilmNetwork" width="246">
                                                <tr>
                                                        <td width="160">
                                                                <p><strong>About Film Network</strong><br/> Film Network is a showcase and community for up-and-coming UK filmmakers<br/>
                                                                        <a class="genericlink" href="/dna/filmnetwork/about">Find out more</a> &nbsp; <img alt="" height="7"
                                                                                src="{$imagesource}furniture/arrowdark.gif" width="4"/></p>
                                                        </td>
                                                        <td>
                                                                <img alt="" height="90" src="{$imagesource}furniture/footer_info.gif" width="83"/>
                                                        </td>
                                                </tr>
                                        </table>
                                </td>
                        </tr>
                </table>
        </xsl:template>
        <xsl:template name="categories_navigation">
                <xsl:choose>
                        <xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_details']/VALUE = 'yes' and /H2G2/PARAMS/PARAM[NAME = 's_print']/VALUE = 1"/>
                        <xsl:otherwise>
                                <div class="topnav">
                                        <xsl:choose>
                                                <xsl:when test="/H2G2/ARTICLE/EXTRAINFO/TYPE/@ID = '13'">
                                                        <img alt="Drama" border="0" height="30" id="topnavMusic" name="drama" src="{$imagesource}furniture/topnav_drama_on.gif" width="106"/>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                        <a href="/dna/filmnetwork/drama" onmouseout="swapImage('drama', '{$imagesource}furniture/topnav_drama_off.gif')"
                                                                onmouseover="swapImage('drama', '{$imagesource}furniture/topnav_drama_on.gif')">
                                                                <img alt="Drama" border="0" height="30" id="topnavMusic" name="drama" src="{$imagesource}furniture/topnav_drama_off.gif" width="106"/>
                                                        </a>
                                                </xsl:otherwise>
                                        </xsl:choose>
                                        <xsl:choose>
                                                <xsl:when test="/H2G2/ARTICLE/EXTRAINFO/TYPE/@ID = '14'">
                                                        <img alt="Comedy" border="0" height="30" name="comedy" src="{$imagesource}furniture/topnav_comedy_on.gif" width="106"/>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                        <a href="/dna/filmnetwork/comedy" onmouseout="swapImage('comedy', '{$imagesource}furniture/topnav_comedy_off.gif')"
                                                                onmouseover="swapImage('comedy', '{$imagesource}furniture/topnav_comedy_on.gif')">
                                                                <img alt="Comedy" border="0" height="30" name="comedy" src="{$imagesource}furniture/topnav_comedy_off.gif" width="106"/>
                                                        </a>
                                                </xsl:otherwise>
                                        </xsl:choose>
                                        <xsl:choose>
                                                <xsl:when test="/H2G2/ARTICLE/EXTRAINFO/TYPE/@ID = '15'">
                                                        <img alt="Documentary" border="0" height="30" name="documentary" src="{$imagesource}furniture/topnav_documentary_on.gif" width="106"/>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                        <a href="/dna/filmnetwork/documentary" onmouseout="swapImage('documentary', '{$imagesource}furniture/topnav_documentary_off.gif')"
                                                                onmouseover="swapImage('documentary', '{$imagesource}furniture/topnav_documentary_on.gif')">
                                                                <img alt="Documentary" border="0" height="30" name="documentary" src="{$imagesource}furniture/topnav_documentary_off.gif" width="106"/>
                                                        </a>
                                                </xsl:otherwise>
                                        </xsl:choose>
                                        <xsl:choose>
                                                <xsl:when test="/H2G2/ARTICLE/EXTRAINFO/TYPE/@ID = '16'">
                                                        <img alt="Animation" border="0" height="30" name="animation" src="{$imagesource}furniture/topnav_animation_on.gif" width="106"/>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                        <a href="/dna/filmnetwork/animation" onmouseout="swapImage('animation', '{$imagesource}furniture/topnav_animation_off.gif')"
                                                                onmouseover="swapImage('animation', '{$imagesource}furniture/topnav_animation_on.gif')">
                                                                <img alt="Animation" border="0" height="30" name="animation" src="{$imagesource}furniture/topnav_animation_off.gif" width="106"/>
                                                        </a>
                                                </xsl:otherwise>
                                        </xsl:choose>
                                        <xsl:choose>
                                                <xsl:when test="/H2G2/ARTICLE/EXTRAINFO/TYPE/@ID = '17'">
                                                        <img alt="Experimental" border="0" height="30" name="experimental" src="{$imagesource}furniture/topnav_experimental_on.gif" width="106"/>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                        <a href="/dna/filmnetwork/experimental" onmouseout="swapImage('experimental', '{$imagesource}furniture/topnav_experimental_off.gif')"
                                                                onmouseover="swapImage('experimental', '{$imagesource}furniture/topnav_experimental_on.gif')">
                                                                <img alt="Experimental" border="0" height="30" name="experimental" src="{$imagesource}furniture/topnav_experimental_off.gif" width="106"
                                                                />
                                                        </a>
                                                </xsl:otherwise>
                                        </xsl:choose>
                                        <xsl:choose>
                                                <xsl:when test="/H2G2/ARTICLE/EXTRAINFO/TYPE/@ID = '18'">
                                                        <img alt="Music" border="0" height="30" name="music" src="{$imagesource}furniture/topnav_music_on.gif" width="105"/>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                        <a href="/dna/filmnetwork/music" onmouseout="swapImage('music', '{$imagesource}furniture/topnav_music_off.gif')"
                                                                onmouseover="swapImage('music', '{$imagesource}furniture/topnav_music_on.gif')">
                                                                <img alt="Music" border="0" height="30" name="music" src="{$imagesource}furniture/topnav_music_off.gif" width="105"/>
                                                        </a>
                                                </xsl:otherwise>
                                        </xsl:choose>
                                </div>
                        </xsl:otherwise>
                </xsl:choose>
        </xsl:template>
        <!--===============Body Content Template (Global Content Stuff)=====================-->
        <!--===============Popup Template (Popup page Stuff)=====================-->
        <xsl:template name="popup-template">
                <html>
                        <xsl:call-template name="insert-header"/>
                        <body alink="#ff0000" bgcolor="#ffffff" leftmargin="0" link="#000099" marginheight="0" marginwidth="0" text="#000000" topmargin="0" vlink="#ff0000">
                                <xsl:call-template name="insert-mainbody"/>
                        </body>
                </html>
        </xsl:template>
        <!--===============Popup Template (Popup page Stuff)=====================-->
        <!--===============Global Alpha Index=====================-->
        <xsl:template name="alphaindex">
                <xsl:param name="type"/>
                <xsl:param name="showtype"/>
                <xsl:param name="imgtype"/>
                <!-- switch this to the above methodology for XSLT 2.0 where its possible to use with-param with apply-imports -->
                <xsl:variable name="alphabet">
                        <!-- <letter>*</letter> -->
                        <letter>a</letter>
                        <letter>b</letter>
                        <letter>c</letter>
                        <letter>d</letter>
                        <letter>e</letter>
                        <letter>f</letter>
                        <letter>g</letter>
                        <letter>h</letter>
                        <letter>i</letter>
                        <letter>j</letter>
                        <letter>k</letter>
                        <letter>l</letter>
                        <letter>m</letter>
                        <letter>n</letter>
                        <letter>o</letter>
                        <letter>p</letter>
                        <letter>q</letter>
                        <letter>r</letter>
                        <letter>s</letter>
                        <letter>t</letter>
                        <letter>u</letter>
                        <letter>v</letter>
                        <letter>w</letter>
                        <letter>x</letter>
                        <letter>y</letter>
                        <letter>z</letter>
                </xsl:variable>
                <xsl:for-each select="msxsl:node-set($alphabet)/letter">
                        <xsl:apply-templates mode="alpha" select=".">
                                <xsl:with-param name="type" select="$type"/>
                                <xsl:with-param name="showtype" select="$showtype"/>
                                <xsl:with-param name="imgtype" select="$imgtype"/>
                        </xsl:apply-templates>
                </xsl:for-each>
        </xsl:template>
        <!--
	<xsl:template match="letter" mode="alpha">
	Author:		Thomas Whitehouse
	Purpose:	Creates each of the letter links
	-->
        <xsl:template match="letter" mode="alpha">
                <xsl:param name="imgtype"/>
                <xsl:param name="type"/>
                <xsl:param name="showtype"/>
                <a href="{$root}Index?submit=new{$showtype}&amp;let={.}{$type}" xsl:use-attribute-sets="nalphaindex">
                        <xsl:choose>
                                <xsl:when test="$imgtype='small'">
                                        <img alt="" border="0" height="20" src="{$graphics}icons/az/small/small_{.}.gif"/>
                                </xsl:when>
                                <xsl:otherwise>
                                        <img alt="" border="0" height="26" src="{$graphics}icons/az/{.}.gif"/>
                                        <xsl:if test=".= 'm'">
                                                <BR/>
                                        </xsl:if>
                                </xsl:otherwise>
                        </xsl:choose>
                </a>
        </xsl:template>
        <xsl:template match="PARSEERRORS" mode="r_typedarticle">
                <font size="2">
                        <b>Error in the XML</b>
                        <br/>
                        <xsl:apply-templates/>
                </font>
        </xsl:template>
        <xsl:template match="XMLERROR">
                <font color="red">
                        <b>
                                <xsl:value-of select="."/>
                        </b>
                </font>
        </xsl:template>
        <!--
	<xsl:template name="article_subtype">
	Description: Presentation of the subtypes in search, index, category and userpage lists
	 -->
        <xsl:template name="article_subtype">
                <xsl:param name="num" select="EXTRAINFO/TYPE/@ID"/>
                <xsl:param name="status"/>
                <xsl:param name="pagetype"/>
                <xsl:param name="searchtypenum"/>
                <!-- match with lookup table type.xsl -->
                <!-- subtype label -->
                <xsl:variable name="label">
                        <xsl:value-of select="msxsl:node-set($type)/type[@number=$num or @selectnumber=$num]/@label"/>
                </xsl:variable>
                <!-- displays -->
                <xsl:value-of select="$label"/>
        </xsl:template>
        <xsl:template name="article_selected">
                <xsl:param name="num" select="EXTRAINFO/TYPE/@ID"/>
                <xsl:param name="status"/>
                <xsl:param name="pagetype"/>
                <xsl:param name="searchtypenum"/>
                <xsl:param name="img"/>
                <xsl:choose>
                        <xsl:when test="msxsl:node-set($type)/type[@selectnumber=$num]">
                                <img alt="Editor's Pick" border="0" height="30" src="{$graphics}icons/icon_{$img}.gif" width="100"/>
                        </xsl:when>
                        <xsl:otherwise>
                                <xsl:choose>
                                        <xsl:when test="/H2G2/@TYPE='USERPAGE'"/>
                                        <xsl:otherwise>
                                                <img border="0" height="30" src="/f/t.gif" width="1"/>
                                        </xsl:otherwise>
                                </xsl:choose>
                        </xsl:otherwise>
                </xsl:choose>
        </xsl:template>
</xsl:stylesheet>
