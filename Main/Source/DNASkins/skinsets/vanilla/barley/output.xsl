<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:doc="http://www.bbc.co.uk/dna/documentation" exclude-result-prefixes="msxsl doc">
  <xsl:include href="../html/includes.xsl"/>
  
  <xsl:output
    method="html"
    version="4.0"
    omit-xml-declaration="yes"
    standalone="yes"
    indent="yes"
    encoding="ISO8859-1"
    doctype-public="-//W3C//DTD HTML 4.0 Transitional//EN"
    doctype-system="http://www.w3.org/TR/REC-html40/loose.dtd"
  />
	
	<xsl:variable name="abc" select="'abcdefghijklmnopqrstuvwxyz'"/>
	<xsl:variable name="ABC" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>
	
  <xsl:template match="H2G2">
   
    <html>
      <head>
        <title>BBC - <xsl:apply-templates select="." mode="head_title"/></title>
        <meta name="description" content="[description]" />
        <meta name="keywords"    content="[keywords]" />
        <meta name="created"     content="[date]" />
        <meta name="updated"     content="[date]" />
        
        <meta http-equiv="Content-Type" content="text/html;charset=iso-8859-1" />
        
        
        <style type="text/css">
          <xsl:comment>
            body {margin:0;}
            form {margin:0;padding:0;}
            .bbcpageShadow {background-color:#828282;}
            .bbcpageShadowLeft {border-left:2px solid #828282;}
            .bbcpageBar {background:#999999 url(http://www.bbc.co.uk/images/v.gif) repeat-y;}
            .bbcpageSearchL {background:#666666 url(http://www.bbc.co.uk/images/sl.gif) no-repeat;}
            .bbcpageSearch {background:#666666 url(http://www.bbc.co.uk/images/st.gif) repeat-x;}
            .bbcpageSearch2 {background:#666666 url(http://www.bbc.co.uk/images/st.gif) repeat-x 0 0;}
            .bbcpageSearchRa {background:#999999 url(http://www.bbc.co.uk/images/sra.gif) no-repeat;}
            .bbcpageSearchRb {background:#999999 url(http://www.bbc.co.uk/images/srb.gif) no-repeat;}
            .bbcpageBlack {background-color:#000000;}
            .bbcpageGrey, .bbcpageShadowLeft {background-color:#999999;}
            .bbcpageWhite,font.bbcpageWhite,a.bbcpageWhite,a.bbcpageWhite:link,a.bbcpageWhite:hover,a.bbcpageWhite:visited {color:#ffffff;text-decoration:none;font-family:verdana,arial,helvetica,sans-serif;padding:1px 4px;}
            
            
          </xsl:comment>
          
        </style>
        <style type="text/css">
          @import 'http://www.bbc.co.uk/includes/tbenh.css';
        </style>
        
        
        <script language="JavaScript" type="text/javascript">
          <!--
            function popmailwin(x, y) {window.open(x,y,'status=no,scrollbars=yes,resizable=yes,width=350,height=400');}
            // -->
        </script>
        
        
        
        <style type="text/css"></style>
        
        <link type="text/css" rel="stylesheet" href="http://pc-s039222.national.core.bbc.co.uk/shared/assets/vanilla-one-barley.css" />
        <!--
        <link type="text/css" rel="stylesheet" href="/[sitepath]/includes/[stylesheet].css" />
        <script src="http://www.bbc.co.uk[/[sitepath]/includes/[script].js]"></script>
        -->
        
        
        
        <xsl:apply-templates select="." mode="head_additional"/>
        
      </head>
      
      <body bgcolor="#ffffff" text="#000000" link="#ff0000" vlink="#ff0000" alink="#ff0000" marginheight="0" marginwidth="0" topmargin="0" leftmargin="0">
        
        <!-- page layout templates v2.66 --><!-- GLOBAL NAVIGATION  --><!-- start dev -->
        
        <!-- variable settings
          bbcpage_charset - 	iso-8859-1
          bbcpage_bgcolor - 	ffffff
          bbcpage_navwidth - 	110
          bbcpage_navgraphic -	no
          bbcpage_navgutter - 	yes
          bbcpage_nav - 		yes
          bbcpage_contentwidth -	480
          bbcpage_contentalign -	left
          bbcpage_toolbarwidth - 	600
          bbcpage_searchcolour - 	666666
          bbcpage_banner - 	andy/template/includes/home
          bbcpage_crumb - 		andy/template/includes/home
          bbcpage_local - 		andy/template/includes/home
          bbcpage_graphic - 	(none)
          bbcpage_variant - 	english
          bbcpage_language - 	english
          bbcpage_lang -		(none)
          bbcpage_print - 		(none)
          bbcpage_topleft_textcolour - 	(none)
          bbcpage_topleft_linkcolour - 	(none)
          bbcpage_topleft_bgcolour - 	(none)
          bbcpage_survey - 	(none)
          bbcpage_surveypath - 	(none)
          bbcpage_surveyname - 	(none)
          bbcpage_surveysite - 	(none)
          bbcpage_surveycount_num - 	(none)
          bbcpage_surveycount_den - 	(none)
          bbcpage_survey_rnd - 	(none)
          bbcpage_survey_go - 	(none)
          bbcpage_surveywidth - 	(none)
        -->
        
        <!-- variable checks -->
        
        
        <!-- end variable checks -->
        <!-- end dev -->
        <a name="top" id="top"></a><!-- toolbar 1.44 header.page  666666 -->
        
        <table width="100%" cellpadding="0" cellspacing="0" border="0" lang="en">
          <tr>
            <td class="bbcpageShadow" colspan="2">
              <a href="#startcontent" accesskey="2">
                <img src="http://www.bbc.co.uk/f/t.gif" width="590" height="2" alt="Skip to main content" title="" border="0" />
              </a>
            </td>
            <td class="bbcpageShadow">
              <a href="/cgi-bin/education/betsie/parser.pl">
                <img src="http://www.bbc.co.uk/f/t.gif" width="1" height="1" alt="Text Only version of this page" title="" border="0" />
              </a>
              <br />
              <a href="/accessibility/accesskeys/keys.shtml" accesskey="0">
                <img src="http://www.bbc.co.uk/f/t.gif" width="1" height="1" alt="Access keys help" title="" border="0" />
              </a>
            </td>
          </tr>
          <form method="get" action="http://www.bbc.co.uk/cgi-bin/search/results.pl" accept-charset="utf-8">
            <tr><td class="bbcpageShadowLeft" width="94">
              <a href="http://www.bbc.co.uk/go/toolbar/-/home/d/" accesskey="1">
                <img src="http://www.bbc.co.uk/images/logo042.gif" width="90" height="30" alt="bbc.co.uk" border="0" hspace="2" vspace="0" />
              </a>
            </td>
              <td class="bbcpageGrey" align="right"><table cellpadding="0" cellspacing="0" border="0" style="float:right">
                <tr>
                  <td>
                    <font size="1">
                      <b>
                        <a href="http://www.bbc.co.uk/go/toolbar/text/-/home/d/" class="bbcpageWhite">Home</a>
                      </b>
                    </font>
                  </td>
                  <td class="bbcpageBar" width="6">
                    <br /></td><td><font size="1">
                      <b>
                        <a href="/go/toolbar/-/tv/d/" class="bbcpageWhite">TV</a>
                      </b>
                    </font>
                    </td>
                  <td class="bbcpageBar" width="6">
                    <br />
                  </td>
                  <td>
                    <font size="1">
                      <b>
                        <a href="/go/toolbar/-/radio/d/" class="bbcpageWhite">
                          Radio
                        </a>
                      </b>
                    </font>
                  </td>
                  <td class="bbcpageBar" width="6">
                    <br />
                  </td>
                  <td>
                    <font size="1">
                      <b>
                        <a href="/go/toolbar/-/talk/" class="bbcpageWhite">
                          Talk
                        </a>
                      </b>
                    </font>
                  </td>
                  <td class="bbcpageBar" width="6">
                    <br />
                  </td>
                  <td>
                    <font size="1">
                      <b>
                        <a href="/go/toolbar/-/whereilive/" class="bbcpageWhite">
                          Where I Live
                        </a>
                      </b>
                    </font>
                  </td>
                  <td class="bbcpageBar" width="6">
                    <br />
                  </td>
                  <td>
                    <nobr>
                      <font size="1">
                        <b>
                          <a href="/go/toolbar/-/a-z/" class="bbcpageWhite" accesskey="3">
                            A-Z Index
                          </a>
                        </b>
                      </font>
                    </nobr>
                  </td>
                  <td class="bbcpageSearchL" width="8">
                    <br />
                  </td>
                  <td class="bbcpageSearch2" width="100">
                    <input type="text" id="bbcpageSearchbox" name="q" size="6" style="margin:3px 0 0;font-family:arial,helvetica,sans-serif;width:100px;" title="BBC Search" accesskey="4" />
                  </td>
                  <td class="bbcpageSearch">
                    <input type="image" src="http://www.bbc.co.uk/images/srchb2.gif" name="go" value="go" alt="Search" width="64" height="25" border="0" />
                  </td>
                  <td class="bbcpageSearchRa" width="1">
                    <img src="http://www.bbc.co.uk/f/t.gif" width="1" height="30" alt="" />
                  </td>
                </tr>
              </table>
              </td>
              <td class="bbcpageSearchRb">
                <img src="http://www.bbc.co.uk/f/t.gif" width="1" height="1" alt="" />
                <input type="hidden" name="uri" value="/andy/template/" />
              </td>
            </tr>
          </form>
          <tr>
            <td class="bbcpageBlack" colspan="2">
              <table cellpadding="0" cellspacing="0" border="0">
                <tr>
                  <td width="110">
                    <img src="http://www.bbc.co.uk/f/t.gif" width="110" height="1" alt="" />
                  </td>
                  <td width="10">
                    <img src="http://www.bbc.co.uk/f/t.gif" width="10" height="1" alt="" />
                  </td><td id="bbcpageblackline" width="650">
                    <img src="http://www.bbc.co.uk/f/t.gif" width="650" height="1" alt="" />
                  </td>
                </tr>
              </table>
            </td>
            <td class="bbcpageBlack" width="100%">
              <img src="http://www.bbc.co.uk/f/t.gif" width="1" height="1" alt="" />
            </td>
          </tr>
        </table>
        <!-- end toolbar 1.42 -->
        <table cellspacing="0" cellpadding="0" border="0" width="100%">
          <tr>
            <td class="bbcpageToplefttd" width="110">
              <table cellspacing="0" cellpadding="0" border="0">
                <tr>
                  <td width="8">
                    <img src="http://www.bbc.co.uk/f/t.gif" width="8" height="1" alt="" />
                  </td>
                  <td width="102">
                    <img src="http://www.bbc.co.uk/f/t.gif" width="102" height="1" alt="" />
                    <br clear="all" />
                    <font face="arial, helvetica, sans-serif" size="1" class="bbcpageToplefttd" >
                      11 March 2004
                      <br />
                      <a class="bbcpageTopleftlink" style="text-decoration:underline;" href="/accessibility/">
                        Accessibility help
                      </a>
                      <br />
                      <a class="bbcpageTopleftlink" style="text-decoration:underline;" href="/cgi-bin/education/betsie/parser.pl">
                        Text only
                      </a>
                    </font>
                  </td>
                </tr>
              </table>
            </td>
            <td width="100%" valign="top">
              <!-- banner -start -->
              
              <h1>Vanilla</h1>
              
              <!-- banner -end -->
            </td>
          </tr>
        </table>
        <table style="margin:0px;" cellspacing="0" cellpadding="0" border="0" align="left" width="110">
          <tr>
            <td class="bbcpageCrumb" width="8">
              <img src="http://www.bbc.co.uk/f/t.gif" width="8" height="1" alt="" />
            </td>
            <td class="bbcpageCrumb" width="100">
              <img src="http://www.bbc.co.uk/f/t.gif" width="100" height="1" alt="" />
              <br clear="all" />
              <font face="arial, helvetica,sans-serif" size="2">
                <a class="bbcpageCrumb" href="/" lang="en">BBC Homepage</a>
                <br />
                <!-- crumb -start-->
                
                
                
                <!-- crumb -end-->
              </font>
            </td>
            <td width="2" class="bbcpageCrumb">
              <img src="http://www.bbc.co.uk/f/t.gif" width="2" height="1" alt="" />
            </td>
            <td class="bbcpageGutter" valign="top" width="10" rowspan="4">
              <img src="http://www.bbc.co.uk/f/t.gif" width="10" height="1" vspace="0" hspace="0" alt="" align="left" />
            </td>
          </tr>
          <tr>
            <td class="bbcpageLocal" colspan="3">
              <img src="http://www.bbc.co.uk/f/t.gif" width="1" height="7" alt="" />
            </td>
          </tr>
          <tr>
            <td class="bbcpageLocal" width="8" valign="top" align="right">
             <!-- <font size="1">&#187;</font> -->
            </td>
            <td class="bbcpageLocal" valign="top">
              <font face="arial, helvetica,sans-serif" size="2">
              <!-- local -start -->
                
                
                <ul id="vanilla-navigation">
                  <li><a href="Announcements">Article Page</a></li>
                  <li><a href="F44158?thread=63772">Thread</a></li>
                  <li><a href="U284">User page</a></li>
                  <li><a href="C834">Catergory</a></li>
                </ul>
                
                
                
              <!-- local -end -->
              </font>
            </td>
            <td class="bbcpageLocal" width="2"><img src="http://www.bbc.co.uk/f/t.gif" width="1" height="1" alt="" />
            </td>
          </tr>
          <tr>
            <td class="bbcpageServices">
              <img src="http://www.bbc.co.uk/f/t.gif" width="1" height="1" alt="" />
            </td>
            <td class="bbcpageServices">
              <hr width="50" align="left" />
              <font face="arial, helvetica, sans-serif" size="2">
                <a class="bbcpageServices" href="/feedback/">
                  Contact Us
                </a>
                <br />
                <br />
                <font size="1">
                  Like this page?
                  <br />
                  <a class="bbcpageServices" onclick="popmailwin('/cgi-bin/navigation/mailto.pl?GO=1&amp;REF=http://www.bbc.co.uk/andy/template/index.shtml','Mailer')" href="/cgi-bin/navigation/mailto.pl?GO=1&amp;REF=http://www.bbc.co.uk/andy/template/index.shtml" target="Mailer">
                    Send it to a friend!
                  </a>
                </font>
                <br />
              </font>
            </td>
            <td class="bbcpageServices">
              <img src="http://www.bbc.co.uk/f/t.gif" width="1" height="1" alt="" />
            </td>
          </tr>
        </table>
        <table width="650" cellspacing="0" cellpadding="0" border="0" style="margin:0px;float:left;">
          <tr>
            <td>
              <!-- End of GLOBAL NAVIGATION  -->
              <a name="startcontent" id="startcontent"></a>
              
              
              <!-- SSO -start-->
              
              
              
              <!-- SSO -end -->
              
              
              
              
              
            
            <!-- Content begins -->
            
              <div id="vanilla">
                
                <!-- Output the HTML layout for this page -->
                <xsl:apply-templates select="." mode="page"/>
                
              </div>
              
              <p id="disclaimer">
                Most of the content on h2g2 is created by h2g2's Researchers, who are members of the public. The views expressed are theirs and unless specifically stated are not those of the BBC. The BBC is not responsible for the content of any external sites referenced. In the event that you consider anything on this page to be in breach of the site's House Rules, please click here. For any other comments, please click on the Feedback button above.
              </p>
            
            <!-- Content end -->
            
            <!-- begin footer -->
            </td>
          </tr>
        </table>
        <!--if no nav or stretchy but not both -->
        <br clear="all" />
        <table  cellpadding="0" cellspacing="0" border="0" lang="en">
          <tr>
            <td class="bbcpageFooterMargin" width="110">
              <img src="http://www.bbc.co.uk/f/t.gif" width="110" height="1" alt="" />
            </td>
            <td class="bbcpageFooterGutter" width="10">
              <img src="http://www.bbc.co.uk/f/t.gif" width="10" height="1" alt="" />
            </td>
            <td class="bbcpageFooter" width="480" align="center">
              <img src="http://www.bbc.co.uk/f/t.gif" width="480" height="1" alt="" />
              <br />
              <font face="arial, helvetica, sans-serif" size="1">
                <a class="bbcpageFooter" href="/info/">About the BBC</a>
                 | 
                <a class="bbcpageFooter" href="/help/">Help</a>
                 | 
                <a class="bbcpageFooter" href="/terms/">Terms of Use</a>
                 | 
                <a class="bbcpageFooter" href="/privacy/">Privacy &amp; Cookies Policy</a>
                <br /> 
              </font>
            </td>
          </tr>
        </table>
        <br clear="all" />
        <!--<script src="http://www.bbc.co.uk/includes/linktrack.js?2" type="text/javascript"></script>-->
        <!-- end footer -->
        
      </body>
    </html>
    
    
  </xsl:template>
</xsl:stylesheet>
