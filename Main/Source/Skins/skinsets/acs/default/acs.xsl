<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="html" omit-xml-declaration="yes" standalone="yes" indent="no" encoding="ISO-8859-1"/>

	<xsl:template match="H2G2[@TYPE='COMMENTBOX']">
			<xsl:if test="COMMENTBOX/FORUMTHREADPOSTS/@CANREAD=1">
			<xsl:apply-templates select="COMMENTBOX/FORUMTHREADPOSTS" />
		</xsl:if>		
	</xsl:template>
	
	<xsl:template match="DATE" mode="dc">
    <xsl:variable name="paddedminute">
      <!--<xsl:if test="@MINUTES&lt;10">0</xsl:if>-->
      <xsl:value-of select ="@MINUTES"/>
    </xsl:variable>

    <xsl:value-of select="concat(@DAYNAME, ' ', @DAY, ' ', @MONTHNAME, ' ', @YEAR,' ',@HOURS,':',$paddedminute)"/>
	</xsl:template>

	<xsl:template match="FORUMTHREADPOSTS">

	<xsl:choose>
		<xsl:when test="/H2G2/PARAMS/PARAM[NAME='s_dnaar']/VALUE=1">
		<xsl:call-template name="acs-response" />
		</xsl:when>
		<xsl:otherwise>

<div id="dnaacs">

	<script language="JavaScript" type="text/javascript">
	<xsl:comment>
	var dnaacs__r_element="dnaacs-r";
	var dnaacs__timer_element="dnaacs-countdown-display";
	var dnaacs__processing_element="dnaacs-processing";
	var dnaacs__c_name = "dnaacs_s_r";
	var dnaacs__user_id="<xsl:value-of select="/H2G2/VIEWING-USER/USER/USERID"/>";
	var dnaacs__uid="<xsl:value-of select="@UID"/>";
	var dnaacs__seconds_restr=<xsl:value-of select="/H2G2/SITE/SITEOPTIONS/SITEOPTION[NAME='PostFreq']/VALUE"/>;
		
	<![CDATA[
	
	function dnaacs__get_ms_xml_http() {
	    var dnaacs__xml_h = null;
	    
		/*
	    var dnaacs__clsids = ["Msxml2.XMLHTTP.6.0","Msxml2.XMLHTTP.5.0",
	                 "Msxml2.XMLHTTP.4.0","Msxml2.XMLHTTP.3.0", 
	                 "Msxml2.XMLHTTP.2.6","Microsoft.XMLHTTP.1.0", 
	                 "Microsoft.XMLHTTP.1","Microsoft.XMLHTTP"];
		*/

	    var dnaacs__clsids = ["Msxml2.XMLHTTP","Microsoft.XMLHTTP"];
					 
					 
	    for(var i=0; i<dnaacs__clsids.length && dnaacs__xml_h == null; i++) {
	        dnaacs__xml_h = dnaacs__c_xml_h(dnaacs__clsids[i]);
	    }
	    return dnaacs__xml_http;
	}
	
	function dnaacs__c_xml_h(dnaacs__clsid) {
	    var dnaacs__xml_h = null;
	    try {
	        dnaacs__xml_http = new ActiveXObject(dnaacs__clsid);
	        dnaacs__lastclsid = dnaacs__clsid;
	        return dnaacs__xml_h;
	    }
	    catch(e) {}
	}	
	
	function dnaacs__get_r(dnaacs__c_url,dnaacs__r_element) {
	    var dnaacs__http_request = null;
		var dnaacs_h = function() {dnaacs__do_h_r(dnaacs__http_request,dnaacs__r_element)};
		

//       if (window.XMLHttpRequest) { // Mozilla, Safari,...
//           http_request = new XMLHttpRequest();
//       } else if (window.ActiveXObject) { // IE
//           http_request = new ActiveXObject("Microsoft.XMLHTTP");
//       }
//       http_request.onreadystatechange = alertContents;
//       http_request.open('GET', url, true);
//       http_request.send(null);




//	    if (window.XMLHttpRequest) {
        // Mozilla | Netscape | Safari
//    	    dnaacs__http_request = new XMLHttpRequest();
//	        if (dnaacs__http_request != null) {
//    	        dnaacs__http_request.onload = dnaacs_h;
//        	    dnaacs__http_request.onerror = dnaacs_h;
//	        }
//			if (window.ActiveXObject) {
//		        dnaacs__http_request = dnaacs__get_ms_xml_http();
//	        	if (dnaacs__http_request != null) { dnaacs__http_request.onreadystatechange = dnaacs_h; }
//			}
//    	} 
//	    else {
    	    // Microsoft ie6 and below
//	        dnaacs__http_request = dnaacs__get_ms_xml_http;
//        	if (dnaacs__http_request != null) { dnaacs__http_request.onreadystatechange = dnaacs_h; }
//	    } 

       if (window.XMLHttpRequest) { // IE7, Mozilla, Safari,...
           dnaacs__http_request = new XMLHttpRequest();
       } else { // IE6 and below
	        dnaacs__http_request = dnaacs__get_ms_xml_http();
       }


		if (!dnaacs__http_request || dnaacs__http_request==null ) {return false;}

		// Send
		dnaacs__http_request.onreadystatechange = dnaacs_h;
	    dnaacs__http_request.open('GET', dnaacs__c_url, true);
	    dnaacs__http_request.send(null);
		return true;
	}


// BEGIN quick fix for comment posting issue
	
function dnaacs__post_r(url,params)
{
	if (window.XMLHttpRequest)
	{
		var httpRequest = new XMLHttpRequest();
	}
	else
	{
		var httpRequest = dnaacs__get_ms_xml_http();
	}
	var dnaacs_h = function() {dnaacs__do_h_r(httpRequest,dnaacs__r_element)};
	httpRequest.open("POST", url, true);
	httpRequest.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
	httpRequest.setRequestHeader("Content-length", params.length);
	httpRequest.setRequestHeader("Connection", "close");
	httpRequest.onreadystatechange = dnaacs_h;
	httpRequest.send(params);
	return true;
}


// END quick fix for comment posting issue

	function dnaacs__do_h_r(dnaacs__http_request,dnaacs__r_element) {
		var dnaacs__r_text="";
		if ((dnaacs__http_request.readyState==4 || dnaacs__http_request.readyState == 'complete') && dnaacs__http_request.status==200) {
			dnaacs__r_text=dnaacs__http_request.responseText;
			if(dnaacs__update_element(dnaacs__r_text,dnaacs__r_element)) {
				window.location="#dnaacs";		
				var dnaacs__processing_text="";
				dnaacs__update_element(dnaacs__processing_text,dnaacs__processing_element);
			}
		}
	}
	
	function dnaacs__update_element(dnaacs__r_text,dnaacs__r_element) {
		if(document.getElementById(dnaacs__r_element).innerHTML=dnaacs__r_text) {
			return true;
		}
	}

	function dnaacs__do_r(dnaacs__c_url,dnaacs__r_element) {
		var dnaacs__processing_text="loading...";
		dnaacs__update_element(dnaacs__processing_text,dnaacs__processing_element);
		if (dnaacs__get_r(dnaacs__c_url,dnaacs__r_element)) {return true;} 
		return false;
	}

	function dnaacs__c_r(dnaacs__c_url,dnaacs_e) {
	    //dnaacs_e = (dnaacs_e) ? dnaacs_e : ((event) ? event : null);
	    if (dnaacs_e) {
    	    dnaacs_key = dnaacs_e.keyCode;
	        if (dnaacs_e.charCode) {dnaacs_key = dnaacs_e.which;}
			if (dnaacs_key) {
				if(dnaacs_key == 13 || dnaacs_key == 32) {
					if (dnaacs__do_r(dnaacs__c_url,dnaacs__r_element)) {return false;} 
				}
			}
		}
		else {
			if (dnaacs__do_r(dnaacs__c_url,dnaacs__r_element)) {return false;} 
		} 
		return true;
	}
	
// BEGIN quick fix for comment posting issue

function dnaacs__do_r2(url,params) {
		var dnaacs__processing_text="loading...";
		dnaacs__update_element(dnaacs__processing_text,dnaacs__processing_element);
		if (dnaacs__post_r(url,params)) {return false;} 
		return false;
	}



function dnaacs__add_comment2() {
		var dnaacs__f=document.dnaacs_add_comment_f;
		if (dnaacs__f.dnacomment.value.length<1) {
			alert("please provide a comment.");
			dnaacs__f.dnacomment.focus();
			return false;
		}
		//need cookie regardless of javascript version
		var dnaacs__creation_date=new Date();
		dnaacs__creation_date.setTime(dnaacs__creation_date.getTime());
		var dnaacs__c_value=dnaacs__user_id+",";
		dnaacs__c_value+=dnaacs__uid+",";
		dnaacs__c_value+=dnaacs__seconds_restr+",";
		dnaacs__c_value+=dnaacs__creation_date;
		var dnaacs__c_expire=dnaacs__seconds_restr;
		
		//submit using ajax
		dnaacs__set_cookie(dnaacs__c_name,dnaacs__c_value,dnaacs__c_expire);
		
		var url = "]]><xsl:value-of select="$root"/><![CDATA[acs?";
		var params = "dnauid="+dnaacs__f.dnauid.value;
		params += "&dnaaction="+dnaacs__f.dnaaction.value;
		params += "&dnacomment="+encodeURIComponent(dnaacs__f.dnacomment.value);
		params += "&dnaur=0";
		params += "&s_dnaar=1";
		params += "&s_dnaheadinglevel="+dnaacs__f.s_dnaheadinglevel.value;

		
		if(dnaacs__do_r2(url, params)) {return false;}
		return false;
	}
	


// END quick fix for comment posting issue	

	function dnaacs__add_comment() {
		var dnaacs__f=document.dnaacs_add_comment_f;
		if (dnaacs__f.dnacomment.value.length<1) {
			alert("please provide a comment.");
			dnaacs__f.dnacomment.focus();
			return false;
		}
		//need cookie regardless of javascript version
		var dnaacs__creation_date=new Date();
		dnaacs__creation_date.setTime(dnaacs__creation_date.getTime());
		var dnaacs__c_value=dnaacs__user_id+",";
		dnaacs__c_value+=dnaacs__uid+",";
		dnaacs__c_value+=dnaacs__seconds_restr+",";
		dnaacs__c_value+=dnaacs__creation_date;
		var dnaacs__c_expire=dnaacs__seconds_restr;
		
		//submit using ajax
		dnaacs__set_cookie(dnaacs__c_name,dnaacs__c_value,dnaacs__c_expire);
		var dnaacs__r_url="]]><xsl:value-of select="$root"/><![CDATA[acs?";
		dnaacs__r_url+="dnauid="+dnaacs__f.dnauid.value;
		dnaacs__r_url+="&dnaaction="+dnaacs__f.dnaaction.value;
		dnaacs__r_url+="&dnacomment="+encodeURI(dnaacs__f.dnacomment.value);
		dnaacs__r_url+="&dnaur=0";
		dnaacs__r_url+="&s_dnaar=1";
		dnaacs__r_url+="&s_dnaheadinglevel="+dnaacs__f.s_dnaheadinglevel.value;
		if(dnaacs__c_r(dnaacs__r_url)) {return true;}
		return false;
	}

	function dnaacs__submit_restr_init() {
		var dnaacs__time_rem=dnaacs_check_cookie_remaiming(dnaacs__c_name,dnaacs__user_id,dnaacs__uid);
		dnaacs__submit_restr(dnaacs__timer_element,dnaacs__time_rem);
	}

	function dnaacs_check_cookie_remaiming(dnaacs__c_name,dnaacs__user_id,dnaacs__uid) {
		var dnaacs__time_rem=0;
		var dnaacs__c_content=dnaacs__get_cookie(dnaacs__c_name);
		if (dnaacs__c_content){
			var dnaacs__c_content_array=dnaacs__c_content.split(",");
			if (dnaacs__c_content_array[0]==dnaacs__user_id && dnaacs__c_content_array[1]==dnaacs__uid) {
				var dnaacs__seconds_restr=dnaacs__c_content_array[2];
				var dnaacs__c_content_creation_date=new Date(dnaacs__c_content_array[3]);
				var dnaacs__c_expiry_date=new Date(); 
				dnaacs__c_expiry_date.setTime(dnaacs__c_content_creation_date.getTime()+(dnaacs__seconds_restr*1000));
				var dnaacs__c_read_date=new Date();
				dnaacs__c_read_date.setTime(dnaacs__c_read_date.getTime());
				dnaacs__time_rem=dnaacs__c_expiry_date-dnaacs__c_read_date;
				dnaacs__time_rem=Math.ceil(dnaacs__time_rem/1000);
			}
		}
		return dnaacs__time_rem;
	}

	function dnaacs__submit_restr(dnaacs__timer_element,dnaacs__time_rem) {
		if (dnaacs__time_rem<0) {dnaacs__time_rem==0;}
		dnaacs__disable_submit(true);
		dnaacs__countdown(dnaacs__time_rem,dnaacs__timer_element);
	}

	function dnaacs__countdown(dnaacs__time_rem,dnaacs__timer_element) {
		if (dnaacs__time_rem > 0){
			dnaacs__time_rem=dnaacs__time_rem-1;
			var dnaacs__timer_text = "You must wait "+dnaacs__time_rem+" seconds until you can submit another comment.";
			dnaacs__update_element(dnaacs__timer_text,dnaacs__timer_element);
			setTimeout("dnaacs__countdown('"+dnaacs__time_rem+"','"+dnaacs__timer_element+"');",1000);
		}
		else {
			var dnaacs__timer_text = "]]><xsl:value-of select="/H2G2/SITECONFIG/DNACOMMENTTEXT/COUNTDOWNDISPLAY" /><![CDATA[";
			dnaacs__update_element(dnaacs__timer_text,dnaacs__timer_element);
			dnaacs__disable_submit(false);}
	}

	function dnaacs__disable_submit(dnaacs__submit_status) {
		var dnaacs__f=document.dnaacs_add_comment_f;
		dnaacs__f.dnasubmit.disabled=dnaacs__submit_status;
	}

	function dnaacs__set_cookie(dnaacs__c_name,dnaacs__c_value,dnaacs__c_expire) {
		var dnaacs__expire_date=new Date();
		dnaacs__expire_date.setTime(dnaacs__expire_date.getTime()+(dnaacs__c_expire*1000));
		document.cookie=dnaacs__c_name+"="+escape(dnaacs__c_value)+((dnaacs__c_expire==null) ? "" : ";expires="+dnaacs__expire_date);
	}	

	function dnaacs__get_cookie(dnaacs__c_name) {
		if (document.cookie.length>0) {
		  	dnaacs__c_start=document.cookie.indexOf(dnaacs__c_name + "=");
			if (dnaacs__c_start!=-1) {
	    		dnaacs__c_start=dnaacs__c_start + dnaacs__c_name.length+1;
	    		dnaacs__c_end=document.cookie.indexOf(";",dnaacs__c_start);
	    		if (dnaacs__c_end==-1) {
					dnaacs__c_end=document.cookie.length;
				}
	    		return unescape(document.cookie.substring(dnaacs__c_start,dnaacs__c_end));
	    	} 
	  	}
		return null;
	}
	
	function dnaacs__complain_popup(dnaacs__compl_url,dnaacs_e) {
	    if (dnaacs_e) {
    	    dnaacs_key = dnaacs_e.keyCode;
	        if (dnaacs_e.charCode) {dnaacs_key = dnaacs_e.which;}
			if (dnaacs_key) {
				if(dnaacs_key == 13 || dnaacs_key == 32) {
					window.open(dnaacs__compl_url, 'ComplaintPopup', 'status=1,resizable=1,scrollbars=1,width=640,height=440');
					return false;
				}
			}
		}
		else {
			window.open(dnaacs__compl_url, 'ComplaintPopup', 'status=1,resizable=1,scrollbars=1,width=640,height=440');
			return false;
		} 
	return true;
	}
  
  function popupwindow(url,target,style)
  {
    window.open(url,target,style);
    return false;
  }
  
	]]>	
<!--xsl:if test="string-length(/H2G2/VIEWING-USER/USER/USERID)>0"-->	
<![CDATA[
//if (window.onload) {
//var dnaacs_oldol = window.onload;
//window.onload = function() {
//dnaacs_oldol();
//dnaacs__submit_restr_init();
//}
//} 
//else {
//window.onload = function() {
//dnaacs__submit_restr_init();
//}
//}
 ]]>
<!--/xsl:if-->
	//</xsl:comment>
	</script>
	<div id="dnaacs-r">
		<xsl:call-template name="acs-response" />
	</div>
</div>
		</xsl:otherwise>
	</xsl:choose>
	</xsl:template>

  <xsl:variable name="acs_heading_level" select="/H2G2/PARAMS/PARAM[NAME='s_dnaheadinglevel']/VALUE" />

  <xsl:template name="acs-doheading">
    <xsl:param name="contents"></xsl:param>
    <xsl:param name="class"></xsl:param>
    <xsl:param name="offset">0</xsl:param>
    <xsl:variable name="elementname">
      <xsl:choose>
        <xsl:when test="(number($acs_heading_level)+number($offset)) &gt;0 and (number($acs_heading_level)+number($offset)) &lt; 7">
          <xsl:text>h</xsl:text><xsl:value-of select="number($acs_heading_level)+number($offset)"/>
        </xsl:when>
        <xsl:otherwise>strong</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:element name="{$elementname}">
      <xsl:attribute name="id">
        <xsl:value-of select="$class"/>
      </xsl:attribute>
      <xsl:copy-of select="$contents"/>
    </xsl:element>
  </xsl:template>

  <xsl:variable name="dayofweek">
    <xsl:choose>
      <xsl:when test="/H2G2/DATE/@DAYNAME = 'Monday'">2</xsl:when>
      <xsl:when test="/H2G2/DATE/@DAYNAME = 'Tuesday'">3</xsl:when>
      <xsl:when test="/H2G2/DATE/@DAYNAME = 'Wednesday'">4</xsl:when>
      <xsl:when test="/H2G2/DATE/@DAYNAME = 'Thursday'">5</xsl:when>
      <xsl:when test="/H2G2/DATE/@DAYNAME = 'Friday'">6</xsl:when>
      <xsl:when test="/H2G2/DATE/@DAYNAME = 'Saturday'">7</xsl:when>
      <xsl:when test="/H2G2/DATE/@DAYNAME = 'Sunday'">1</xsl:when>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="timeinminutes">
    <xsl:value-of select="/H2G2/DATE/@MINUTES + 60 * (/H2G2/DATE/@HOURS)"/>
  </xsl:variable>
  <xsl:variable name="closingtimeinminutes">
    <xsl:value-of select="/H2G2/SITE/OPENCLOSETIMES/OPENCLOSETIME[@DAYOFWEEK=$dayofweek]/CLOSETIME/MINUTE + 60 * (/H2G2/SITE/OPENCLOSETIMES/OPENCLOSETIME[@DAYOFWEEK=$dayofweek]/CLOSETIME/HOUR)"/>
  </xsl:variable>

  <xsl:variable name="forumcanwrite" select="/H2G2/COMMENTBOX/FORUMTHREADPOSTS/@CANWRITE = 1"/>
  <xsl:variable name="userisloggedin" select="string-length(/H2G2/VIEWING-USER/USER/USERID) &#62; 0"/>
  
  <xsl:template name="acs-response">
		<div id="dnaacs-action">
      <xsl:call-template name="acs-doheading">
        <xsl:with-param name="class">dnaacs-comment-heading</xsl:with-param>
        <xsl:with-param name="contents">
          <xsl:apply-templates select="/H2G2/SITECONFIG/DNACOMMENTTEXT/COMMENTBOXHEADING" />
        </xsl:with-param>
      </xsl:call-template>
      <!--<xsl:variable name="post-a-comment-h"><xsl:copy-of select="/H2G2/SITECONFIG/DNACOMMENTTEXT/COMMENTBOXHEADING" /></xsl:variable>
		<xsl:choose>
			<xsl:when test="$acs_heading_level = 1"><h1 id="dnaacs-comment-heading"><xsl:value-of select="$post-a-comment-h" /></h1></xsl:when>
			<xsl:when test="$acs_heading_level = 2"><h2 id="dnaacs-comment-heading"><xsl:value-of select="$post-a-comment-h" /></h2></xsl:when>
			<xsl:when test="$acs_heading_level = 3"><h3 id="dnaacs-comment-heading"><xsl:value-of select="$post-a-comment-h" /></h3></xsl:when>
			<xsl:when test="$acs_heading_level = 4"><h4 id="dnaacs-comment-heading"><xsl:value-of select="$post-a-comment-h" /></h4></xsl:when>
			<xsl:when test="$acs_heading_level = 5"><h5 id="dnaacs-comment-heading"><xsl:value-of select="$post-a-comment-h" /></h5></xsl:when>
			<xsl:when test="$acs_heading_level = 6"><h6 id="dnaacs-comment-heading"><xsl:value-of select="$post-a-comment-h" /></h6></xsl:when>
			<xsl:otherwise><strong id="dnaacs-comment-heading"><xsl:value-of select="$post-a-comment-h" /></strong></xsl:otherwise>
		</xsl:choose>-->
      <xsl:if test="$forumcanwrite">
        <!-- forum is open for posting-->
        <xsl:choose>
          <xsl:when test="string-length(/H2G2/VIEWING-USER/USER/USERID) &#62; 0">
            <!-- user is logged in-->
            <p id="dnaacs-logged-in-welcome">
              <xsl:apply-templates select="/H2G2/SITECONFIG/DNACOMMENTTEXT/LOGGEDINWELCOME" />
            </p>
            <p id="dnaacs-comment-link">
              <a href="#dnaacs-add-form">Post a comment</a>
            </p>
          </xsl:when>
          <xsl:otherwise>
            <p id="dnaacs-not-logged-in-welcome">
              <xsl:apply-templates select="/H2G2/SITECONFIG/DNACOMMENTTEXT/NOTLOGGEDINWELCOME" />
            </p>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:if>
		<p id="dnaacs-opening-times-message">
      <!--<xsl:apply-templates select="/H2G2/SITECONFIG/DNACOMMENTTEXT/OPENINGTIMESHEADING" />
      <br/>
      <xsl:apply-templates select="/H2G2/SITECONFIG/DNACOMMENTTEXT/OPENINGTIMESMESSAGE" />
      <br/>-->

      <xsl:choose>
        <xsl:when test="/H2G2/COMMENTBOX/FORUMTHREADPOSTS/@DEFAULTCANWRITE=0">
          <!-- forum is manually closed-->
          <p id="dnaacs-forum-closed-message">
            <xsl:apply-templates select="/H2G2/SITECONFIG/DNACOMMENTTEXT/FORUMCLOSEDMESSAGE" />
          </p>
        </xsl:when>
        <xsl:when test="/H2G2/SITE/SITECLOSED=1">
          <!-- site is closed-->
          <xsl:choose>
            <xsl:when test="/H2G2/SITE/SITECLOSED/@EMERGENCYCLOSED=1">
              <!-- site is emergency closed-->
              <p id="dnaacs-emergency-closed-message">
                <xsl:apply-templates select="/H2G2/SITECONFIG/DNACOMMENTTEXT/EMERGENCYCLOSEDMESSAGE" />
              </p>
              <xsl:call-template name="opening-times"/>
            </xsl:when>
            <xsl:when test="/H2G2/SITE/SITECLOSED/@SCHEDULEDCLOSED=1">
              <!-- site is closed for the night-->
              <xsl:call-template name="acs-doheading">
                <xsl:with-param name="class">dnaacs-scheduled-closed-message</xsl:with-param>
                <xsl:with-param name="offset">1</xsl:with-param>
                <xsl:with-param name="contents">
                  <xsl:apply-templates select="/H2G2/SITECONFIG/DNACOMMENTTEXT/SCHEDULEDCLOSEDMESSAGE" />
                </xsl:with-param>
              </xsl:call-template>
              <!--<xsl:variable name="opening-times-h"><xsl:apply-templates select="/H2G2/SITECONFIG/DNACOMMENTTEXT/OPENINGTIMESHEADING" /></xsl:variable>
					<xsl:choose>
						<xsl:when test="$acs_heading_level = 1"><h3 id="dnaacs-opening-times-heading"><xsl:value-of select="$opening-times-h" /></h3></xsl:when>
						<xsl:when test="$acs_heading_level = 2"><h4 id="dnaacs-opening-times-heading"><xsl:value-of select="$opening-times-h" /></h4></xsl:when>
						<xsl:when test="$acs_heading_level = 3"><h5 id="dnaacs-opening-times-heading"><xsl:value-of select="$opening-times-h" /></h5></xsl:when>
						<xsl:when test="$acs_heading_level = 4"><h6 id="dnaacs-opening-times-heading"><xsl:value-of select="$opening-times-h" /></h6></xsl:when>
						<xsl:otherwise><strong id="dnaacs-opening-times-heading"><xsl:value-of select="$opening-times-h" /></strong></xsl:otherwise>
					</xsl:choose>-->
              <xsl:call-template name="opening-times"/>
            </xsl:when>
            <xsl:otherwise>
              <p id="dnaacs-general-closed-message">
                <xsl:apply-templates select="/H2G2/SITECONFIG/DNACOMMENTTEXT/GENERALCLOSEDMESSAGE" />
              </p>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
      </xsl:choose>
      <xsl:if test="/H2G2/COMMENTBOX/ENDDATE/DATE/@YEAR &lt; 2100 and /H2G2/COMMENTBOX/FORUMTHREADPOSTS/@DEFAULTCANWRITE=1">
        <!-- forum isn't closed and it has an expiry date-->
        <xsl:choose>
        <xsl:when test="/H2G2/DATE/@SORT &lt; /H2G2/COMMENTBOX/ENDDATE/DATE/@SORT and /H2G2/SITECONFIG/DNACOMMENTTEXT/OPENUNTILMESSAGE">
          <!-- closing date hasn't passed and the site has supplied an OpenUntil message-->
          <div id="dnaacs-open-until">
          <xsl:apply-templates select="/H2G2/SITECONFIG/DNACOMMENTTEXT/OPENUNTILMESSAGE"/>
          </div>
          <!--<xsl:value-of select="concat(/H2G2/COMMENTBOX/ENDDATE/DATE/@DAYNAME,' ',/H2G2/COMMENTBOX/ENDDATE/DATE/@DAY,' ',/H2G2/COMMENTBOX/ENDDATE/DATE/@MONTHNAME,' ',/H2G2/COMMENTBOX/ENDDATE/DATE/@YEAR)"/>.-->
        </xsl:when>
          <xsl:when test="/H2G2/DATE/@SORT &gt;= /H2G2/COMMENTBOX/ENDDATE/DATE/@SORT and /H2G2/SITECONFIG/DNACOMMENTTEXT/FORUMEXPIREDMESSAGE">
            <!-- closing date has passed and the site has supplied a ForumExpiredMessage-->
            <div id="dnaacs-forum-expired">
              <xsl:apply-templates select="/H2G2/SITECONFIG/DNACOMMENTTEXT/FORUMEXPIREDMESSAGE"/>
            </div>
            <!--<xsl:value-of select="concat(/H2G2/COMMENTBOX/ENDDATE/DATE/@DAYNAME,' ',/H2G2/COMMENTBOX/ENDDATE/DATE/@DAY,' ',/H2G2/COMMENTBOX/ENDDATE/DATE/@MONTHNAME,' ',/H2G2/COMMENTBOX/ENDDATE/DATE/@YEAR)"/>-->

          </xsl:when>
        </xsl:choose>
      </xsl:if>

    </p>
		</div>
		
		<!--h3><xsl:value-of select="@FORUMPOSTCOUNT"/> Comment<xsl:if test="@FORUMPOSTCOUNT>1">s</xsl:if> Posted</h3-->
    <xsl:call-template name="acs-doheading">
      <xsl:with-param name="class">dnaacsstartcomments</xsl:with-param>
      <xsl:with-param name="contents">
        <xsl:apply-templates select="/H2G2/SITECONFIG/DNACOMMENTTEXT/TOTALPOSTSMESSAGE"/>
      </xsl:with-param>
    </xsl:call-template>
    <p id="dnaacs-summary">
      <!--<xsl:value-of select="count(POST)" /> comments posted so far, <xsl:value-of select="count(POST[@HIDDEN &#60; 1])" /> posts shown and <xsl:value-of select="count(POST[@HIDDEN &#62; 0])" /> hidden.-->
      <xsl:apply-templates select="/H2G2/SITECONFIG/DNACOMMENTTEXT/NUMBEROFPOSTSMESSAGE"/>
    </p>
    <!--<xsl:variable name="comments-posted-h"><xsl:value-of select="@FORUMPOSTCOUNT"/> Comment<xsl:if test="@FORUMPOSTCOUNT &#62; 1">s</xsl:if> posted so far</xsl:variable>
		<xsl:choose>
			<xsl:when test="$acs_heading_level = 1"><h1 id="dnaacsstartcomments"><xsl:value-of select="$comments-posted-h" /></h1></xsl:when>
			<xsl:when test="$acs_heading_level = 2"><h2 id="dnaacsstartcomments"><xsl:value-of select="$comments-posted-h" /></h2></xsl:when>
			<xsl:when test="$acs_heading_level = 3"><h3 id="dnaacsstartcomments"><xsl:value-of select="$comments-posted-h" /></h3></xsl:when>
			<xsl:when test="$acs_heading_level = 4"><h4 id="dnaacsstartcomments"><xsl:value-of select="$comments-posted-h" /></h4></xsl:when>
			<xsl:when test="$acs_heading_level = 5"><h5 id="dnaacsstartcomments"><xsl:value-of select="$comments-posted-h" /></h5></xsl:when>
			<xsl:when test="$acs_heading_level = 6"><h6 id="dnaacsstartcomments"><xsl:value-of select="$comments-posted-h" /></h6></xsl:when>
			<xsl:otherwise><strong><xsl:value-of select="$comments-posted-h" /></strong></xsl:otherwise>
		</xsl:choose>-->

    <xsl:if test="/H2G2/COMMENTBOX/POSTPREMODERATED/@UID">
      <!-- if the just-posted comment is premoderated-->
      <div id="dnaacs-premod-message">
        <xsl:apply-templates select="/H2G2/SITECONFIG/DNACOMMENTTEXT/PREMODMESSAGE" />
      </div>
    </xsl:if>
    <xsl:if test="/H2G2/ERROR[@TYPE='profanityblocked']">
      <!-- if the comment contained a blocked profanity -->
      <div id="dnaacs-profanity-message">
        <xsl:apply-templates select="/H2G2/SITECONFIG/DNACOMMENTTEXT/PROFANITYMESSAGE"/>
      </div>
    </xsl:if>
    <p id="dnaacs-processing"></p>
		
		<xsl:if test="@FORUMPOSTCOUNT &#62; ((@TO - @FROM)+1)">
      <!-- if there are more posts than on this page -->
		<!--<xsl:variable name="skipshow-h">Comment Posts Pagination Links</xsl:variable>
		<xsl:choose>
			<xsl:when test="$acs_heading_level = 1"><h2 class="dnaacs-skip-show-h"><xsl:value-of select="$skipshow-h" /></h2></xsl:when>
			<xsl:when test="$acs_heading_level = 2"><h3 class="dnaacs-skip-show-h"><xsl:value-of select="$skipshow-h" /></h3></xsl:when>
			<xsl:when test="$acs_heading_level = 3"><h4 class="dnaacs-skip-show-h"><xsl:value-of select="$skipshow-h" /></h4></xsl:when>
			<xsl:when test="$acs_heading_level = 4"><h5 class="dnaacs-skip-show-h"><xsl:value-of select="$skipshow-h" /></h5></xsl:when>
			<xsl:when test="$acs_heading_level = 5"><h6 class="dnaacs-skip-show-h"><xsl:value-of select="$skipshow-h" /></h6></xsl:when>
			<xsl:otherwise><strong class="dnaacs-skip-show-h"><xsl:value-of select="$skipshow-h" /></strong></xsl:otherwise>
		</xsl:choose>-->
		<ul class="dnaacs-skip-show">
		<xsl:call-template name="acs-skip-show" />
		</ul>
		
		</xsl:if>
		
		<div id="dnaacs-comments">
		
		<xsl:apply-templates select="POST"/>
		</div>

    <xsl:if test="@FORUMPOSTCOUNT &#62; ((@TO - @FROM)+1)">
      <!-- if there are more posts than on this page -->
      <!--<xsl:variable name="skipshow-h">Comment Posts Pagination Links</xsl:variable>
		<xsl:choose>
			<xsl:when test="$acs_heading_level = 1"><h2 class="dnaacs-skip-show-h"><xsl:value-of select="$skipshow-h" /></h2></xsl:when>
			<xsl:when test="$acs_heading_level = 2"><h3 class="dnaacs-skip-show-h"><xsl:value-of select="$skipshow-h" /></h3></xsl:when>
			<xsl:when test="$acs_heading_level = 3"><h4 class="dnaacs-skip-show-h"><xsl:value-of select="$skipshow-h" /></h4></xsl:when>
			<xsl:when test="$acs_heading_level = 4"><h5 class="dnaacs-skip-show-h"><xsl:value-of select="$skipshow-h" /></h5></xsl:when>
			<xsl:when test="$acs_heading_level = 5"><h6 class="dnaacs-skip-show-h"><xsl:value-of select="$skipshow-h" /></h6></xsl:when>
			<xsl:otherwise><strong class="dnaacs-skip-show-h"><xsl:value-of select="$skipshow-h" /></strong></xsl:otherwise>
		</xsl:choose>-->
		<ul class="dnaacs-skip-show">
		<xsl:call-template name="acs-skip-show" />
		</ul>
		
		</xsl:if>
		
		<div id="dnaacs-comment-box">

				<xsl:if test="string-length(/H2G2/VIEWING-USER/USER/USERID) &#62; 0 and /H2G2/COMMENTBOX/FORUMTHREADPOSTS/@CANWRITE=1">
          <!-- if the forum is open and user is logged in-->
          <xsl:call-template name="acs-doheading">
            <xsl:with-param name="class">dnaacs-leave-heading</xsl:with-param>
            <xsl:with-param name="contents">
              <xsl:apply-templates select="/H2G2/SITECONFIG/DNACOMMENTTEXT/LEAVECOMMENTHEADING" />
            </xsl:with-param>
          </xsl:call-template>
          <!--<xsl:variable name="leave-your-comment-h"><xsl:apply-templates select="/H2G2/SITECONFIG/DNACOMMENTTEXT/LEAVECOMMENTHEADING" /></xsl:variable>
				<xsl:choose>
					<xsl:when test="$acs_heading_level = 1"><h1 id="dnaacs-leave-heading"><xsl:value-of select="$leave-your-comment-h" /></h1></xsl:when>
					<xsl:when test="$acs_heading_level = 2"><h2 id="dnaacs-leave-heading"><xsl:value-of select="$leave-your-comment-h" /></h2></xsl:when>
					<xsl:when test="$acs_heading_level = 3"><h3 id="dnaacs-leave-heading"><xsl:value-of select="$leave-your-comment-h" /></h3></xsl:when>
					<xsl:when test="$acs_heading_level = 4"><h4 id="dnaacs-leave-heading"><xsl:value-of select="$leave-your-comment-h" /></h4></xsl:when>
					<xsl:when test="$acs_heading_level = 5"><h5 id="dnaacs-leave-heading"><xsl:value-of select="$leave-your-comment-h" /></h5></xsl:when>
					<xsl:when test="$acs_heading_level = 6"><h6 id="dnaacs-leave-heading"><xsl:value-of select="$leave-your-comment-h" /></h6></xsl:when>
					<xsl:otherwise><strong id="dnaacs-leave-heading"><xsl:value-of select="$leave-your-comment-h" /></strong></xsl:otherwise>
				</xsl:choose>-->
				<p>
				<xsl:choose>
					<xsl:when test="@MODERATIONSTATUS=0">
            <!-- moderation status is undefined by the forum-->
					<xsl:choose>
						<xsl:when test="/H2G2/SITE/MODERATIONSTATUS=1">
              <!-- site moderation status is reactive-->
              <span class="dnaacs-unmod-label"><xsl:apply-templates select="/H2G2/SITECONFIG/DNACOMMENTTEXT/UNMODLABEL" /></span></xsl:when>
						<xsl:when test="/H2G2/SITE/MODERATIONSTATUS=2">
              <!-- site moderation status is post-mod-->
              <span class="dnaacs-postmod-label"><xsl:apply-templates select="/H2G2/SITECONFIG/DNACOMMENTTEXT/POSTMODLABEL" /></span></xsl:when>
						<xsl:when test="/H2G2/SITE/MODERATIONSTATUS=3">
              <!-- site moderation status is pre-mod-->
              <span class="dnaacs-premod-label"><xsl:apply-templates select="/H2G2/SITECONFIG/DNACOMMENTTEXT/PREMODLABEL" /></span></xsl:when>
					</xsl:choose>
					</xsl:when>
					<xsl:when test="@MODERATIONSTATUS=1">
            <!-- forum moderation status is reactive-->
            <span class="dnaacs-unmod-label"><xsl:apply-templates select="/H2G2/SITECONFIG/DNACOMMENTTEXT/UNMODLABEL" /></span></xsl:when>
					<xsl:when test="@MODERATIONSTATUS=2">
            <!-- forum moderation status is post-mod-->
            <span class="dnaacs-postmod-label"><xsl:apply-templates select="/H2G2/SITECONFIG/DNACOMMENTTEXT/POSTMODLABEL" /></span></xsl:when>
					<xsl:when test="@MODERATIONSTATUS=3">
            <!-- forum moderation status is pre-mod-->
            <span class="dnaacs-premod-label"><xsl:apply-templates select="/H2G2/SITECONFIG/DNACOMMENTTEXT/PREMODLABEL" /></span></xsl:when>
				</xsl:choose></p>
          <!--<xsl:call-template name="acs-doheading">
            <xsl:with-param name="class">dnaacs-comment-enter-heading</xsl:with-param>
            <xsl:with-param name="offset">2</xsl:with-param>
            <xsl:with-param name="contents">
              <xsl:apply-templates select="/H2G2/SITECONFIG/DNACOMMENTTEXT/COMMENTENTERHEADING" />
            </xsl:with-param>
          </xsl:call-template>-->
				<!--<xsl:variable name="comment-h"><span class="dnaacs-premod-label"><xsl:apply-templates select="/H2G2/SITECONFIG/DNACOMMENTTEXT/COMMENTENTERHEADING" /></span></xsl:variable>
				<xsl:choose>
					<xsl:when test="$acs_heading_level = 1"><h2 id="dnaacs-comment-enter-heading"><xsl:value-of select="$comment-h" /></h2></xsl:when>
					<xsl:when test="$acs_heading_level = 2"><h3 id="dnaacs-comment-enter-heading"><xsl:value-of select="$comment-h" /></h3></xsl:when>
					<xsl:when test="$acs_heading_level = 3"><h4 id="dnaacs-comment-enter-heading"><xsl:value-of select="$comment-h" /></h4></xsl:when>
					<xsl:when test="$acs_heading_level = 4"><h5 id="dnaacs-comment-enter-heading"><xsl:value-of select="$comment-h" /></h5></xsl:when>
					<xsl:when test="$acs_heading_level = 5"><h6 id="dnaacs-comment-enter-heading"><xsl:value-of select="$comment-h" /></h6></xsl:when>
					<xsl:otherwise><strong id="dnaacs-comment-enter-heading"><xsl:value-of select="$comment-h" /></strong></xsl:otherwise>
				</xsl:choose>-->
            <xsl:if test="$closingtimeinminutes - $timeinminutes &lt; 15 and $closingtimeinminutes - $timeinminutes &gt;= 0">
              <!-- if the closing time is less than 15 minutes away-->
              <p id="dnaacs-closing-time-soon">
                <xsl:apply-templates select="/H2G2/SITECONFIG/DNACOMMENTTEXT/CLOSINGTIMESOON"/>
              </p>
            </xsl:if>
				<form action="{$root}acs" name="dnaacs_add_comment_f" onsubmit="return dnaacs__add_comment2();" id="dnaacs-add-form" method="post">
				<input type="hidden" name="dnauid" value="{@UID}" />
				<input type="hidden" name="dnaaction" value="add" />
				<input type="hidden" name="dnaur" value="1" />
				<input type="hidden" name="s_dnaheadinglevel" value="{$acs_heading_level}" />
				<label for="dnaacs-comment-text" id="dnaacs-comment-enter-label"><xsl:apply-templates select="/H2G2/SITECONFIG/DNACOMMENTTEXT/COMMENTENTERLABEL" /></label>
				<textarea name="dnacomment" onfocus="dnaacs__submit_restr_init();" id="dnaacs-comment-text"></textarea>
				<label for="dnaacs-submit" id="dnaacs-countdown-display"><xsl:apply-templates select="/H2G2/SITECONFIG/DNACOMMENTTEXT/COUNTDOWNDISPLAY" /></label>
				<input type="submit" value="Submit" name="dnasubmit" id="dnaacs-submit" />
				</form>
				</xsl:if>

		</div>
	</xsl:template>

  <xsl:template name="opening-times">
    <xsl:call-template name="acs-doheading">
      <xsl:with-param name="class">dnaacs-opening-times-heading</xsl:with-param>
      <xsl:with-param name="offset">2</xsl:with-param>
      <xsl:with-param name="contents">
        <xsl:apply-templates select="/H2G2/SITECONFIG/DNACOMMENTTEXT/OPENINGTIMESHEADING"/>
      </xsl:with-param>
    </xsl:call-template>
    <p id="dnaacs-opening-times">
      <xsl:choose>
        <xsl:when test="/H2G2/SITE/OPENCLOSETIMES/OPENCLOSETIME[@DAYOFWEEK=2]/OPENTIME/HOUR = /H2G2/SITE/OPENCLOSETIMES/OPENCLOSETIME[@DAYOFWEEK=3]/OPENTIME/HOUR 
                and /H2G2/SITE/OPENCLOSETIMES/OPENCLOSETIME[@DAYOFWEEK=3]/OPENTIME/HOUR = /H2G2/SITE/OPENCLOSETIMES/OPENCLOSETIME[@DAYOFWEEK=4]/OPENTIME/HOUR 
                and /H2G2/SITE/OPENCLOSETIMES/OPENCLOSETIME[@DAYOFWEEK=4]/OPENTIME/HOUR = /H2G2/SITE/OPENCLOSETIMES/OPENCLOSETIME[@DAYOFWEEK=5]/OPENTIME/HOUR 
                and /H2G2/SITE/OPENCLOSETIMES/OPENCLOSETIME[@DAYOFWEEK=5]/OPENTIME/HOUR = /H2G2/SITE/OPENCLOSETIMES/OPENCLOSETIME[@DAYOFWEEK=6]/OPENTIME/HOUR 
                and /H2G2/SITE/OPENCLOSETIMES/OPENCLOSETIME[@DAYOFWEEK=2]/OPENTIME/MINUTE = /H2G2/SITE/OPENCLOSETIMES/OPENCLOSETIME[@DAYOFWEEK=3]/OPENTIME/MINUTE 
                and /H2G2/SITE/OPENCLOSETIMES/OPENCLOSETIME[@DAYOFWEEK=3]/OPENTIME/MINUTE = /H2G2/SITE/OPENCLOSETIMES/OPENCLOSETIME[@DAYOFWEEK=4]/OPENTIME/MINUTE 
                and /H2G2/SITE/OPENCLOSETIMES/OPENCLOSETIME[@DAYOFWEEK=4]/OPENTIME/MINUTE = /H2G2/SITE/OPENCLOSETIMES/OPENCLOSETIME[@DAYOFWEEK=5]/OPENTIME/MINUTE 
                and /H2G2/SITE/OPENCLOSETIMES/OPENCLOSETIME[@DAYOFWEEK=5]/OPENTIME/MINUTE = /H2G2/SITE/OPENCLOSETIMES/OPENCLOSETIME[@DAYOFWEEK=6]/OPENTIME/MINUTE 
                ">
          <!-- weekday times are identical-->
          <li>
            <xsl:apply-templates select="/H2G2/SITECONFIG/DNACOMMENTTEXT/WEEKDAYSMESSAGE"/>
            <xsl:text> </xsl:text>
            <xsl:call-template name="acs-format-time">
              <xsl:with-param name="hour" select="/H2G2/SITE/OPENCLOSETIMES/OPENCLOSETIME[@DAYOFWEEK=2]/OPENTIME/HOUR" />
              <xsl:with-param name="minute" select="/H2G2/SITE/OPENCLOSETIMES/OPENCLOSETIME[@DAYOFWEEK=2]/OPENTIME/MINUTE" />
            </xsl:call-template>
            <xsl:text> to </xsl:text>
            <xsl:call-template name="acs-format-time">
              <xsl:with-param name="hour" select="/H2G2/SITE/OPENCLOSETIMES/OPENCLOSETIME[@DAYOFWEEK=2]/CLOSETIME/HOUR" />
              <xsl:with-param name="minute" select="/H2G2/SITE/OPENCLOSETIMES/OPENCLOSETIME[@DAYOFWEEK=2]/CLOSETIME/MINUTE" />
            </xsl:call-template>
          </li>
        </xsl:when>
        <xsl:otherwise>
          <li>
            <xsl:text>Monday </xsl:text>
            <xsl:call-template name="acs-format-time">
              <xsl:with-param name="hour" select="/H2G2/SITE/OPENCLOSETIMES/OPENCLOSETIME[@DAYOFWEEK=2]/OPENTIME/HOUR" />
              <xsl:with-param name="minute" select="/H2G2/SITE/OPENCLOSETIMES/OPENCLOSETIME[@DAYOFWEEK=2]/OPENTIME/MINUTE" />
            </xsl:call-template>
            <xsl:text> to </xsl:text>
            <xsl:call-template name="acs-format-time">
              <xsl:with-param name="hour" select="/H2G2/SITE/OPENCLOSETIMES/OPENCLOSETIME[@DAYOFWEEK=2]/CLOSETIME/HOUR" />
              <xsl:with-param name="minute" select="/H2G2/SITE/OPENCLOSETIMES/OPENCLOSETIME[@DAYOFWEEK=2]/CLOSETIME/MINUTE" />
            </xsl:call-template>
          </li>
          <li>
            <xsl:text>Tuesday </xsl:text>
            <xsl:call-template name="acs-format-time">
              <xsl:with-param name="hour" select="/H2G2/SITE/OPENCLOSETIMES/OPENCLOSETIME[@DAYOFWEEK=3]/OPENTIME/HOUR" />
              <xsl:with-param name="minute" select="/H2G2/SITE/OPENCLOSETIMES/OPENCLOSETIME[@DAYOFWEEK=3]/OPENTIME/MINUTE" />
            </xsl:call-template>
            <xsl:text> to </xsl:text>
            <xsl:call-template name="acs-format-time">
              <xsl:with-param name="hour" select="/H2G2/SITE/OPENCLOSETIMES/OPENCLOSETIME[@DAYOFWEEK=3]/CLOSETIME/HOUR" />
              <xsl:with-param name="minute" select="/H2G2/SITE/OPENCLOSETIMES/OPENCLOSETIME[@DAYOFWEEK=3]/CLOSETIME/MINUTE" />
            </xsl:call-template>
          </li>
          <li>
            <xsl:text>Wednesday </xsl:text>
            <xsl:call-template name="acs-format-time">
              <xsl:with-param name="hour" select="/H2G2/SITE/OPENCLOSETIMES/OPENCLOSETIME[@DAYOFWEEK=4]/OPENTIME/HOUR" />
              <xsl:with-param name="minute" select="/H2G2/SITE/OPENCLOSETIMES/OPENCLOSETIME[@DAYOFWEEK=4]/OPENTIME/MINUTE" />
            </xsl:call-template>
            <xsl:text> to </xsl:text>
            <xsl:call-template name="acs-format-time">
              <xsl:with-param name="hour" select="/H2G2/SITE/OPENCLOSETIMES/OPENCLOSETIME[@DAYOFWEEK=4]/CLOSETIME/HOUR" />
              <xsl:with-param name="minute" select="/H2G2/SITE/OPENCLOSETIMES/OPENCLOSETIME[@DAYOFWEEK=4]/CLOSETIME/MINUTE" />
            </xsl:call-template>
          </li>
          <li>
            <xsl:text>Thursday </xsl:text>
            <xsl:call-template name="acs-format-time">
              <xsl:with-param name="hour" select="/H2G2/SITE/OPENCLOSETIMES/OPENCLOSETIME[@DAYOFWEEK=5]/OPENTIME/HOUR" />
              <xsl:with-param name="minute" select="/H2G2/SITE/OPENCLOSETIMES/OPENCLOSETIME[@DAYOFWEEK=5]/OPENTIME/MINUTE" />
            </xsl:call-template>
            <xsl:text> to </xsl:text>
            <xsl:call-template name="acs-format-time">
              <xsl:with-param name="hour" select="/H2G2/SITE/OPENCLOSETIMES/OPENCLOSETIME[@DAYOFWEEK=5]/CLOSETIME/HOUR" />
              <xsl:with-param name="minute" select="/H2G2/SITE/OPENCLOSETIMES/OPENCLOSETIME[@DAYOFWEEK=5]/CLOSETIME/MINUTE" />
            </xsl:call-template>
          </li>
          <li>
            <xsl:text>Friday </xsl:text>
            <xsl:call-template name="acs-format-time">
              <xsl:with-param name="hour" select="/H2G2/SITE/OPENCLOSETIMES/OPENCLOSETIME[@DAYOFWEEK=6]/OPENTIME/HOUR" />
              <xsl:with-param name="minute" select="/H2G2/SITE/OPENCLOSETIMES/OPENCLOSETIME[@DAYOFWEEK=6]/OPENTIME/MINUTE" />
            </xsl:call-template>
            <xsl:text> to </xsl:text>
            <xsl:call-template name="acs-format-time">
              <xsl:with-param name="hour" select="/H2G2/SITE/OPENCLOSETIMES/OPENCLOSETIME[@DAYOFWEEK=6]/CLOSETIME/HOUR" />
              <xsl:with-param name="minute" select="/H2G2/SITE/OPENCLOSETIMES/OPENCLOSETIME[@DAYOFWEEK=6]/CLOSETIME/MINUTE" />
            </xsl:call-template>
          </li>

        </xsl:otherwise>
      </xsl:choose>
      <xsl:choose>
        <xsl:when test="/H2G2/SITE/OPENCLOSETIMES/OPENCLOSETIME[@DAYOFWEEK=1]/OPENTIME/HOUR = /H2G2/SITE/OPENCLOSETIMES/OPENCLOSETIME[@DAYOFWEEK=7]/OPENTIME/HOUR 
                and /H2G2/SITE/OPENCLOSETIMES/OPENCLOSETIME[@DAYOFWEEK=1]/OPENTIME/MINUTE = /H2G2/SITE/OPENCLOSETIMES/OPENCLOSETIME[@DAYOFWEEK=7]/OPENTIME/MINUTE ">
          <!-- weekend times are identical-->
          <li>
            <xsl:apply-templates select="/H2G2/SITECONFIG/DNACOMMENTTEXT/WEEKENDSMESSAGE"/>
            <xsl:text> </xsl:text>
            <xsl:call-template name="acs-format-time">
              <xsl:with-param name="hour" select="/H2G2/SITE/OPENCLOSETIMES/OPENCLOSETIME[@DAYOFWEEK=7]/OPENTIME/HOUR" />
              <xsl:with-param name="minute" select="/H2G2/SITE/OPENCLOSETIMES/OPENCLOSETIME[@DAYOFWEEK=7]/OPENTIME/MINUTE" />
            </xsl:call-template>
            <xsl:text> to </xsl:text>
            <xsl:call-template name="acs-format-time">
              <xsl:with-param name="hour" select="/H2G2/SITE/OPENCLOSETIMES/OPENCLOSETIME[@DAYOFWEEK=7]/CLOSETIME/HOUR" />
              <xsl:with-param name="minute" select="/H2G2/SITE/OPENCLOSETIMES/OPENCLOSETIME[@DAYOFWEEK=7]/CLOSETIME/MINUTE" />
            </xsl:call-template>

          </li>
        </xsl:when>
        <xsl:otherwise>
          <li>
            <xsl:text>Saturday </xsl:text>
            <xsl:call-template name="acs-format-time">
              <xsl:with-param name="hour" select="/H2G2/SITE/OPENCLOSETIMES/OPENCLOSETIME[@DAYOFWEEK=7]/OPENTIME/HOUR" />
              <xsl:with-param name="minute" select="/H2G2/SITE/OPENCLOSETIMES/OPENCLOSETIME[@DAYOFWEEK=7]/OPENTIME/MINUTE" />
            </xsl:call-template>
            <xsl:text> to </xsl:text>
            <xsl:call-template name="acs-format-time">
              <xsl:with-param name="hour" select="/H2G2/SITE/OPENCLOSETIMES/OPENCLOSETIME[@DAYOFWEEK=7]/CLOSETIME/HOUR" />
              <xsl:with-param name="minute" select="/H2G2/SITE/OPENCLOSETIMES/OPENCLOSETIME[@DAYOFWEEK=7]/CLOSETIME/MINUTE" />
            </xsl:call-template>
          </li>
          <li>
            <xsl:text>Sunday </xsl:text>
            <xsl:call-template name="acs-format-time">
              <xsl:with-param name="hour" select="/H2G2/SITE/OPENCLOSETIMES/OPENCLOSETIME[@DAYOFWEEK=1]/OPENTIME/HOUR" />
              <xsl:with-param name="minute" select="/H2G2/SITE/OPENCLOSETIMES/OPENCLOSETIME[@DAYOFWEEK=1]/OPENTIME/MINUTE" />
            </xsl:call-template>
            <xsl:text> to </xsl:text>
            <xsl:call-template name="acs-format-time">
              <xsl:with-param name="hour" select="/H2G2/SITE/OPENCLOSETIMES/OPENCLOSETIME[@DAYOFWEEK=1]/CLOSETIME/HOUR" />
              <xsl:with-param name="minute" select="/H2G2/SITE/OPENCLOSETIMES/OPENCLOSETIME[@DAYOFWEEK=1]/CLOSETIME/MINUTE" />
            </xsl:call-template>
          </li>

        </xsl:otherwise>
      </xsl:choose>
    </p>

  </xsl:template>
  
    <xsl:template match="POST">
	
		<xsl:if test="@HIDDEN &#60; 1 and @CANREAD=1">
      <!-- post is visible-->
		<div class="dnaacs-comment" id="DNA{@INDEX}">

		<p class="dnaacs-index-no"><span class="access-text">Post </span><xsl:value-of select="@INDEX+1" />.</p>
		
		<p class="dnaacs-date-posted"><xsl:apply-templates select="DATEPOSTED/DATE" mode="dc" /></p>
		
		<p class="dnaacs-sent-by"><xsl:apply-templates select="/H2G2/SITECONFIG/DNACOMMENTTEXT/SENTBYLABEL" />
		<strong>
      <xsl:choose>
        <xsl:when test="/H2G2/SITECONFIG/DNACOMMENTTEXT/COMMENTSITEONLY = 1">
          <xsl:value-of select="USER/USERNAME"/>
        </xsl:when>
        <xsl:otherwise>
          <a
              href="/dna/{/H2G2/SITE/NAME}/MC{USER/USERID}"
              title="View other comments from {USER/USERNAME}">
            <xsl:attribute name="class">
              <xsl:text>dnaacs-</xsl:text>
              <xsl:choose>
                <xsl:when test="USER/GROUPS/GROUP[NAME='EDITOR']">
                  <xsl:text>editor</xsl:text>
                </xsl:when>
                <xsl:when test="USER/GROUPS/GROUP[NAME='NOTABLES']">
                  <xsl:text>notables</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:text>other</xsl:text>
                </xsl:otherwise>
              </xsl:choose>
              <xsl:text>-member</xsl:text>
            </xsl:attribute>

            <xsl:value-of select="USER/USERNAME"/>
          </a>
        </xsl:otherwise>
      </xsl:choose>
    </strong>
		</p>

		<p class="dnaacs-post-text"><xsl:apply-templates select="TEXT"/></p>
		
		<xsl:variable name="host_page_url">
		<xsl:choose>
			<xsl:when test="contains(/H2G2/COMMENTBOX/FORUMTHREADPOSTS/@HOSTPAGEURL,'?')">
				<xsl:value-of select="concat(/H2G2/COMMENTBOX/FORUMTHREADPOSTS/@HOSTPAGEURL, '&amp;')" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="concat(/H2G2/COMMENTBOX/FORUMTHREADPOSTS/@HOSTPAGEURL, '?')" />
			</xsl:otherwise>
		</xsl:choose>
		</xsl:variable>
		<p><a href="comments/UserComplaintPage?s_start=1&amp;PostID={@POSTID}&amp;s_start=1" onclick="return dnaacs__complain_popup('{$root}UserComplaint?PostID={@POSTID}&amp;s_start=1');" onkeypress="return dnaacs__complain_popup('{$root}UserComplaint?PostID={@POSTID}&amp;s_start=1',event);" class="dnaacs-complain-link"><xsl:apply-templates select="/H2G2/SITECONFIG/DNACOMMENTTEXT/COMPLAINLINK" /></a></p>
		<p><a href="{$host_page_url}dnafrom={/H2G2/COMMENTBOX/FORUMTHREADPOSTS/@FROM}&amp;dnato={/H2G2/COMMENTBOX/FORUMTHREADPOSTS/@TO}#DNA{@INDEX}" class="dnaacs-perma-link" title="Post Permalink">permalink</a></p>
		</div>
		</xsl:if>
	
	</xsl:template>
	
	<xsl:template name="acs-skip-show">
		<xsl:param name="comments_per_page" select="@SHOW"/>
		<xsl:param name="page_count" select="floor(@FORUMPOSTCOUNT div $comments_per_page)"/>
		<xsl:param name="page_label" select="1"/>
		
		<xsl:variable name="total_post_count" select="@FORUMPOSTCOUNT" />
		<xsl:variable name="page_count_total" select="floor(@FORUMPOSTCOUNT div $comments_per_page)"/>
		<xsl:variable name="current_page" select="$page_count_total - floor(@FROM div $comments_per_page)"/>
		<xsl:variable name="current_page_pos" select="$page_count_total - $current_page"/>
		<xsl:variable name="acs_heading_level" select="/H2G2/PARAMS/PARAM[NAME='s_dnaheadinglevel']/VALUE" />
		
		<xsl:variable name="host_page_url">
		<xsl:choose>
			<xsl:when test="contains(@HOSTPAGEURL,'?')">
				<xsl:value-of select="concat(@HOSTPAGEURL, '&amp;')" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="concat(@HOSTPAGEURL, '?')" />
			</xsl:otherwise>
		</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="nav_range" select="10" /><!-- set for navigation range -->

		<xsl:variable name="nav_start" select="floor(($current_page - 1) div $nav_range) * $nav_range"/>
		<xsl:variable name="nav_end" select="$nav_start + $nav_range"/>
		
		<xsl:variable name="first_label"><![CDATA[NEWEST]]></xsl:variable>
		<xsl:variable name="prev_range_prepend"><![CDATA[<]]></xsl:variable>
		<xsl:variable name="prev_label"><![CDATA[<]]></xsl:variable>
		<xsl:variable name="next_label"><![CDATA[>]]></xsl:variable>
		<xsl:variable name="next_range_prepend"><![CDATA[>]]></xsl:variable>
		<xsl:variable name="last_label"><![CDATA[OLDEST]]></xsl:variable>
<!-- 
#more accessible
		<xsl:variable name="first_label">first page</xsl:variable>
		<xsl:variable name="prev_range_prepend">prev </xsl:variable>
		<xsl:variable name="prev_label">prev page</xsl:variable>
		<xsl:variable name="next_label">next page </xsl:variable>
		<xsl:variable name="next_range_prepend">next </xsl:variable>
		<xsl:variable name="last_label">last page</xsl:variable>
		
 -->	 	    
 

 
 
 
 
 				<xsl:if test="$page_label = 1">
				<li>
				<xsl:choose>
			    <xsl:when test="$current_page &#62; 1">
            <xsl:attribute name="class">dnaacs-skip-show-nav-first</xsl:attribute>
            <a title="First page" href="{$host_page_url}dnafrom={$page_count * $comments_per_page - $comments_per_page}&amp;dnato={$total_post_count - 1}#dnaacs" onclick="return dnaacs__c_r('{$root}acs?dnauid={@UID}&amp;dnafrom={$page_count * $comments_per_page - $comments_per_page}&amp;dnato={$total_post_count - 1}&amp;s_dnaar=1&amp;s_dnaheadinglevel={$acs_heading_level}');" onkeypress="return dnaacs__c_r('{$root}acs?dnauid={@UID}&amp;dnafrom={$page_count * $comments_per_page - $comments_per_page}&amp;dnato={$total_post_count - 1}&amp;s_dnaar=1&amp;s_dnaheadinglevel={$acs_heading_level}',event);"><xsl:value-of select="$first_label"/></a>
				</xsl:when>
				<xsl:otherwise>
          <xsl:attribute name="class">dnaacs-skip-show-nav-first-nolink</xsl:attribute>
          <xsl:value-of select="$first_label"/>
				</xsl:otherwise>
				</xsl:choose>
				</li>
				
				<!--<li class="dnaacs-skip-show-nav-prev-range">
				<xsl:choose>
		 	    <xsl:when test="$current_page &#62; $nav_range">
				<a title="Previous {$nav_range} pages" href="{$host_page_url}dnafrom={($page_count_total - $nav_start) * $comments_per_page}&amp;dnato={(($page_count_total - $nav_start) * $comments_per_page) + ($comments_per_page -1)}#dnaacs" onclick="return dnaacs__c_r('{$root}acs?dnauid={@UID}&amp;dnafrom={($page_count_total - $nav_start) * $comments_per_page}&amp;dnato={(($page_count_total - $nav_start) * $comments_per_page) + ($comments_per_page -1)}&amp;s_dnaar=1&amp;s_dnaheadinglevel={$acs_heading_level}');" onkeypress="return dnaacs__c_r('{$root}acs?dnauid={@UID}&amp;dnafrom={($page_count_total - $nav_start) * $comments_per_page}&amp;dnato={(($page_count_total - $nav_start) * $comments_per_page) + ($comments_per_page -1)}&amp;s_dnaar=1&amp;s_dnaheadinglevel={$acs_heading_level}',event);"><xsl:value-of select="concat($prev_range_prepend,$nav_range)" /></a>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="concat($prev_range_prepend,$nav_range)" />
				</xsl:otherwise>
				</xsl:choose>
				</li>-->
				
				<li>
				<xsl:choose>
				<xsl:when test="$current_page &#62; 1">
          <xsl:attribute name="class">dnaacs-skip-show-nav-prev</xsl:attribute>
          <xsl:choose>
					<xsl:when test="$current_page &#62; 2">
						<a title="Previous page" href="{$host_page_url}dnafrom={($current_page_pos + 1) * $comments_per_page}&amp;dnato={(($current_page_pos + 2) * $comments_per_page) - 1}#dnaacs" onclick="return dnaacs__c_r('{$root}acs?dnauid={@UID}&amp;dnafrom={($current_page_pos + 1) * $comments_per_page}&amp;dnato={(($current_page_pos + 2) * $comments_per_page) - 1}&amp;s_dnaar=1&amp;s_dnaheadinglevel={$acs_heading_level}');" onkeypress="return dnaacs__c_r('{$root}acs?dnauid={@UID}&amp;dnafrom={($current_page_pos + 1) * $comments_per_page}&amp;dnato={(($current_page_pos + 2) * $comments_per_page) - 1}&amp;s_dnaar=1&amp;s_dnaheadinglevel={$acs_heading_level}',event);"><xsl:value-of select="$prev_label"/></a>
					</xsl:when>
					<xsl:otherwise>
						<a title="Previous page" href="{$host_page_url}dnauid={@UID}&amp;dnafrom={($current_page_pos + 1) * $comments_per_page}&amp;dnato={$total_post_count - 1}#dnaacs" onclick="return dnaacs__c_r('{$root}acs?dnauid={@UID}&amp;dnafrom={($current_page_pos + 1) * $comments_per_page}&amp;dnato={$total_post_count - 1}&amp;s_dnaar=1&amp;s_dnaheadinglevel={$acs_heading_level}');" onkeypress="return dnaacs__c_r('{$root}acs?dnauid={@UID}&amp;dnafrom={($current_page_pos + 1) * $comments_per_page}&amp;dnato={$total_post_count - 1}&amp;s_dnaar=1&amp;s_dnaheadinglevel={$acs_heading_level}',event);"><xsl:value-of select="$prev_label"/></a>
					</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise>
          <xsl:attribute name="class">dnaacs-skip-show-nav-prev-nolink</xsl:attribute>
          <xsl:value-of select="$prev_label"/>
				</xsl:otherwise>
				</xsl:choose>
				</li>
				
			</xsl:if>

	    <xsl:if test="$page_count &#62; 0">
		
		    <xsl:if test="(($page_label) &#62; $nav_start) and (($page_label) &#60;= $nav_end)">
				<li class="dnaacs-skip-show-nav-pages">
				<xsl:choose>
					<xsl:when test="$page_label &#62; 1">
					<a href="{$host_page_url}dnafrom={($page_count * $comments_per_page) - $comments_per_page}&amp;dnato={($page_count * $comments_per_page)-1}#dnaacs" onclick="return dnaacs__c_r('{$root}acs?dnauid={@UID}&amp;dnafrom={($page_count * $comments_per_page) - $comments_per_page}&amp;dnato={($page_count * $comments_per_page)-1}&amp;s_dnaar=1&amp;s_dnaheadinglevel={$acs_heading_level}');" onkeypress="return dnaacs__c_r('{$root}acs?dnauid={@UID}&amp;dnafrom={($page_count * $comments_per_page) - $comments_per_page}&amp;dnato={($page_count * $comments_per_page)-1}&amp;s_dnaar=1&amp;s_dnaheadinglevel={$acs_heading_level}',event);">
					<xsl:choose>
						<xsl:when test="$page_label = $current_page">
              <xsl:attribute name="class">dnaacs-skip-show-nav-on</xsl:attribute>
              <xsl:value-of select="$page_label"/>
						<!--<span class="dnaacs-skip-show-nav-on"><xsl:value-of select="$page_label"/></span>-->
						</xsl:when>
						<xsl:otherwise>
						<xsl:value-of select="$page_label"/>
						</xsl:otherwise>
					</xsl:choose>
					</a>
					</xsl:when>
					<xsl:otherwise>
					<a href="{$host_page_url}dnafrom={($page_count * $comments_per_page) - $comments_per_page}&amp;dnato={$total_post_count - 1}#dnaacs" onclick="return dnaacs__c_r('{$root}acs?dnauid={@UID}&amp;dnafrom={($page_count * $comments_per_page) - $comments_per_page}&amp;dnato={$total_post_count - 1}&amp;s_dnaar=1&amp;s_dnaheadinglevel={$acs_heading_level}');" onkeypress="return dnaacs__c_r('{$root}acs?dnauid={@UID}&amp;dnafrom={($page_count * $comments_per_page) - $comments_per_page}&amp;dnato={$total_post_count - 1}&amp;s_dnaar=1&amp;s_dnaheadinglevel={$acs_heading_level}',event);">
					<xsl:choose>
						<xsl:when test="$page_label = $current_page">
              <xsl:attribute name="class">dnaacs-skip-show-nav-on</xsl:attribute>
              <xsl:value-of select="$page_label"/>
              <!--<span class="dnaacs-skip-show-nav-on"><xsl:value-of select="$page_label"/></span>-->
            </xsl:when>
						<xsl:otherwise>
						<xsl:value-of select="$page_label"/>
						</xsl:otherwise>
					</xsl:choose>
					</a>
					</xsl:otherwise>
				</xsl:choose>
				</li>
			</xsl:if>
			
			<xsl:call-template name="acs-skip-show">
	       		<xsl:with-param name="comments_per_page" select="$comments_per_page"/>
	       		<xsl:with-param name="page_count" select="$page_count - 1"/>
	       		<xsl:with-param name="page_label" select="$page_label + 1"/>
			</xsl:call-template>
		</xsl:if>
		
	    <xsl:if test="$page_count_total = $page_label">
		
			<li>
			<xsl:choose>
			<xsl:when test="$page_count_total &#62; $current_page">
        <xsl:attribute name="class">dnaacs-skip-show-nav-next</xsl:attribute>
        <a title="Next page" href="{$host_page_url}dnafrom={($current_page_pos - 1) * $comments_per_page}&amp;dnato={($current_page_pos * $comments_per_page) - 1}#dnaacs" onclick="return dnaacs__c_r('{$root}acs?dnauid={@UID}&amp;dnafrom={($current_page_pos - 1) * $comments_per_page}&amp;dnato={($current_page_pos * $comments_per_page) - 1}&amp;s_dnaar=1&amp;s_dnaheadinglevel={$acs_heading_level}');" onkeypress="return dnaacs__c_r('{$root}acs?dnauid={@UID}&amp;dnafrom={($current_page_pos - 1) * $comments_per_page}&amp;dnato={($current_page_pos * $comments_per_page) - 1}&amp;s_dnaar=1&amp;s_dnaheadinglevel={$acs_heading_level}',event);"><xsl:value-of select="$next_label"/></a>
			</xsl:when>
			<xsl:otherwise>
        <xsl:attribute name="class">dnaacs-skip-show-nav-next-nolink</xsl:attribute>
        <xsl:value-of select="$next_label"/>
			</xsl:otherwise>
			</xsl:choose>
			</li>

			<!--  -->
			<!--<li class="dnaacs-skip-show-nav-next-range">
			<xsl:choose>
			<xsl:when test="$page_count_total &#62; $nav_end"> 
			<a title="Next {$nav_range} pages" href="{$host_page_url}dnafrom={((($page_count_total - $nav_end) - 1) * $comments_per_page)}&amp;dnato={((($page_count_total - $nav_end) - 1) * $comments_per_page) + ($comments_per_page -1)}#dnaacs" onclick="return dnaacs__c_r('{$root}acs?dnauid={@UID}&amp;dnafrom={((($page_count_total - $nav_end) - 1) * $comments_per_page)}&amp;dnato={((($page_count_total - $nav_end) - 1) * $comments_per_page) + ($comments_per_page -1)}&amp;s_dnaar=1&amp;s_dnaheadinglevel={$acs_heading_level}');" onkeypress="return dnaacs__c_r('{$root}acs?dnauid={@UID}&amp;dnafrom={((($page_count_total - $nav_end) - 1) * $comments_per_page)}&amp;dnato={((($page_count_total - $nav_end) - 1) * $comments_per_page) + ($comments_per_page -1)}&amp;s_dnaar=1&amp;s_dnaheadinglevel={$acs_heading_level}',event);"><xsl:value-of select="concat($next_range_prepend,$nav_range)" /></a>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="concat($nav_range,$next_range_prepend)" />
			</xsl:otherwise>
			</xsl:choose>
			</li>-->

			<li>
			<xsl:choose>
		    <xsl:when test="$page_count_total &#62; $current_page">
          <xsl:attribute name="class">dnaacs-skip-show-nav-last</xsl:attribute>
			<a title="Last page" href="{$host_page_url}dnafrom=0&amp;dnato={$comments_per_page - 1}#dnaacs" onclick="return dnaacs__c_r('{$root}acs?dnauid={@UID}&amp;dnafrom=0&amp;dnato={$comments_per_page - 1}&amp;s_dnaar=1&amp;s_dnaheadinglevel={$acs_heading_level}');" onkeypress="return dnaacs__c_r('{$root}acs?dnauid={@UID}&amp;dnafrom=0&amp;dnato={$comments_per_page - 1}&amp;s_dnaar=1&amp;s_dnaheadinglevel={$acs_heading_level}',event);"><xsl:value-of select="$last_label"/></a>
			</xsl:when>
			<xsl:otherwise>
        <xsl:attribute name="class">dnaacs-skip-show-nav-last-nolink</xsl:attribute>
        <xsl:value-of select="$last_label"/>
			</xsl:otherwise>
			</xsl:choose>
			</li>
		</xsl:if>
		
	</xsl:template>

  <!--
  WARNING - this template adjusts for BST
  -->
  
	<xsl:template name="acs-format-time">
		<xsl:param name="hour" select="0"/>
		<xsl:param name="minute" select="0"/>
		<xsl:variable name="delim">:</xsl:variable>
 		<xsl:choose>
			<xsl:when test="$minute &#60; 10">
			<xsl:value-of select="concat($hour,$delim,'0',$minute)"/>
			 </xsl:when>
			<xsl:otherwise>
 			<xsl:value-of select="concat($hour,$delim,$minute)"/>
	 		</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

  <xsl:variable name="sso_rootlogin" select="concat($sso_resources, $sso_script, '?c=login&amp;service=', /H2G2/SITE/SSOSERVICE, '&amp;ptrt=',/H2G2/COMMENTBOX/FORUMTHREADPOSTS/@HOSTPAGEURL)"/>
  <xsl:variable name="sso_rootregister" select="concat($sso_resources, $sso_script, '?c=register&amp;service=', /H2G2/SITE/SSOSERVICE, '&amp;ptrt=',/H2G2/COMMENTBOX/FORUMTHREADPOSTS/@HOSTPAGEURL)"/>
  <xsl:variable name="sso_rootsignout" select="concat($sso_resources, $sso_script, '?c=signout&amp;service=', /H2G2/SITE/SSOSERVICE, '&amp;ptrt=',/H2G2/COMMENTBOX/FORUMTHREADPOSTS/@HOSTPAGEURL)"/>

  <xsl:template match="DNACOMMENTTEXT//LINKTOREGISTER">
    <a href="{$sso_rootregister}">
      <xsl:apply-templates/>
    </a>
  </xsl:template>

  <xsl:template match="DNACOMMENTTEXT//LINKTOSIGNIN">
    <a href="{$sso_rootlogin}">
      <xsl:apply-templates/>
    </a>
  </xsl:template>

  <xsl:template match="DNACOMMENTTEXT//LINKTOSIGNOUT">
    <a href="{$sso_rootsignout}">
      <xsl:apply-templates/>
    </a>
  </xsl:template>

  <!--<xsl:template match="COMMENTBOXHEADING|LOGGEDINWELCOME|NOTLOGGEDINWELCOME|OPENINGTIMESMESSAGE|OPENUNTILMESSAGE|FORUMCLOSEDMESSAGE|EMERGENCYCLOSEDMESSAGE|PREMODMESSAGE|OPENINGTIMESHEADING|LEAVECOMMENTHEADING|UNMODLABEL|POSTMODLABEL|PREMODLABEL|COMMENTENTERHEADING|COMMENTENTERLABEL|COUNTDOWNDISPLAY|SENTBYLABEL|COMPLAINLINK|NUMBEROFPOSTSMESSAGE">
    <xsl:apply-templates/>
  </xsl:template>-->

  <xsl:template match="DNACOMMENTTEXT/*">
    <xsl:if test="/H2G2/debugmessages">
      <span class="dnaacs-message-name" style="display:none">[<xsl:value-of select="name()"/>]</span>
    </xsl:if>
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="DNACOMMENTTEXT//PAGEPOSTCOUNT">
    <xsl:value-of select="count(/H2G2/COMMENTBOX/FORUMTHREADPOSTS/POST)"/>
    <xsl:choose>
      <xsl:when test="count(/H2G2/COMMENTBOX/FORUMTHREADPOSTS/POST) = 1">
        <xsl:value-of select="@SINGULAR"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="@PLURAL"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="DNACOMMENTTEXT//TOTALPOSTCOUNT">
    <xsl:value-of select="/H2G2/COMMENTBOX/FORUMTHREADPOSTS/@FORUMPOSTCOUNT"/>
    <xsl:choose>
      <xsl:when test="/H2G2/COMMENTBOX/FORUMTHREADPOSTS/@FORUMPOSTCOUNT = 1">
        <xsl:value-of select="@SINGULAR"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="@PLURAL"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="DNACOMMENTTEXT//PAGEPOSTCOUNTHIDDEN">
    <xsl:value-of select="count(/H2G2/COMMENTBOX/FORUMTHREADPOSTS/POST[@HIDDEN > 0])"/>
    <xsl:choose>
      <xsl:when test="count(/H2G2/COMMENTBOX/FORUMTHREADPOSTS/POST[@HIDDEN > 0]) = 1">
        <xsl:value-of select="@SINGULAR"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="@PLURAL"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="DNACOMMENTTEXT//PAGEPOSTCOUNTSHOWN">
    <xsl:value-of select="count(/H2G2/COMMENTBOX/FORUMTHREADPOSTS/POST[@HIDDEN &lt; 1])"/>
    <xsl:choose>
      <xsl:when test="count(/H2G2/COMMENTBOX/FORUMTHREADPOSTS/POST[@HIDDEN &lt; 1]) = 1">
        <xsl:value-of select="@SINGULAR"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="@PLURAL"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="TEXT">
    <xsl:apply-templates />
  </xsl:template>

  <xsl:template match="DNACOMMENTTEXT//BLOCKEDPROFANITY">
    <xsl:apply-templates select="/H2G2/ERROR/ERRORMESSAGE"/>
  </xsl:template>

  <xsl:template match="DNACOMMENTTEXT//NEXTOPENTIME">
    <xsl:variable name="hoursmin">
      <xsl:value-of select="substring(/H2G2/DATE/@SORT,9,4)"/>
    </xsl:variable>
    <xsl:variable name="openingtime">
      <xsl:apply-templates select="/H2G2/SITE/OPENCLOSETIMES/OPENCLOSETIME[@DAYOFWEEK=$dayofweek]" mode="hourminute"/>
    </xsl:variable>
    <xsl:variable name="tomorrow">
      <xsl:value-of select="($dayofweek mod 7)+1"/>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$hoursmin &lt; $openingtime">
        <xsl:text>at </xsl:text>
        <xsl:apply-templates select="/H2G2/SITE/OPENCLOSETIMES/OPENCLOSETIME[@DAYOFWEEK=$dayofweek]" mode="hourcolonminute"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>at </xsl:text>
        <xsl:apply-templates select="/H2G2/SITE/OPENCLOSETIMES/OPENCLOSETIME[@DAYOFWEEK=$tomorrow]" mode="hourcolonminute"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="DNACOMMENTTEXT//MINUTESBEFORECLOSING">
    <xsl:value-of select="$closingtimeinminutes - $timeinminutes"/>
  </xsl:template>

  <xsl:template match="DNACOMMENTTEXT//FORUMEXPIRATIONDATE">
    <xsl:value-of select="concat(/H2G2/COMMENTBOX/ENDDATE/DATE/@DAYNAME,' ',/H2G2/COMMENTBOX/ENDDATE/DATE/@DAY,' ',/H2G2/COMMENTBOX/ENDDATE/DATE/@MONTHNAME,' ',/H2G2/COMMENTBOX/ENDDATE/DATE/@YEAR)"/>
  </xsl:template>

  <xsl:template match="OPENCLOSETIME" mode="hourminute">
    <xsl:number format="01" value="OPENTIME/HOUR"/>
    <xsl:choose>
      <xsl:when test="OPENTIME/MINUTE = 0">00</xsl:when>
      <xsl:otherwise>
        <xsl:number format="01" value="OPENTIME/MINUTE"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!--
  WARNING - this template adjusts for BST
  -->
  <xsl:template match="OPENCLOSETIME" mode="hourcolonminute">
    <xsl:number format="01" value="(OPENTIME/HOUR)"/>
    <xsl:text>:</xsl:text>
    <xsl:choose>
      <xsl:when test="OPENTIME/MINUTE = 0">00</xsl:when>
      <xsl:otherwise>
        <xsl:number format="01" value="OPENTIME/MINUTE"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  
</xsl:stylesheet>
