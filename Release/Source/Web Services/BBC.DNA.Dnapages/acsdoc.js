// JScript File
function xyzzy(thetext)
{
	document.getElementById('stylesheet').innerHTML = thetext;
	return true;
}

function gethttp()
{
	
}

function hide(elid)
{
	var el = document.getElementById(elid);
	el.style.display='none';
}

function unhide(elid)
{
	var el = document.getElementById(elid);
	el.style.display='block';
}

function hideallclass(classname)
{
	var els = getElementsByClass(classname);
	if (els != null)
	{
		var i=0;
		for (i=0; i < els.length;i++)
		{
			els[i].style.display='none';
		}
	}
}
function showallclass(classname)
{
	var els = getElementsByClass(classname);
	if (els != null)
	{
		var i=0;
		for (i=0; i < els.length;i++)
		{
			els[i].style.display='';
		}
	}
}

function getElementsByClass(searchClass,node,tag) {
	var classElements = new Array();
	if ( node == null )
		node = document;
	if ( tag == null )
		tag = '*';
	var els = node.getElementsByTagName(tag);
	var elsLen = els.length;
	var pattern = new RegExp('(^|\\s)'+searchClass+'(\\s|$)');
	for (i = 0, j = 0; i < elsLen; i++) {
		if ( pattern.test(els[i].className) ) {
			classElements[j] = els[i];
			j++;
		}
	}
	return classElements;
}


	function get_ms_xml_http() {
	    var xml_h = null;
	    
		/*
	    var dnaacs__clsids = ["Msxml2.XMLHTTP.6.0","Msxml2.XMLHTTP.5.0",
	                 "Msxml2.XMLHTTP.4.0","Msxml2.XMLHTTP.3.0", 
	                 "Msxml2.XMLHTTP.2.6","Microsoft.XMLHTTP.1.0", 
	                 "Microsoft.XMLHTTP.1","Microsoft.XMLHTTP"];
		*/

	    var clsids = ["Msxml2.XMLHTTP","Microsoft.XMLHTTP"];
					 
					 
	    for(var i=0; i<clsids.length && xml_h == null; i++) {
	        xml_h = getactivex(clsids[i]);
	    }
	    return xml_h;
	}
	
	function getactivex(clsid) {
	    try {
	        return new ActiveXObject(clsid);
	    }
	    catch(e) {}
	    return null;
	}	

	function updateelementwithresult(httpr, elementid)
	{
		var r_text="";
		if ((httpr.readyState==4 || httpr.readyState == 'complete') && httpr.status==200) 
		{
			var r_text=httpr.responseText;
			var el = document.getElementById(elementid);
			if (el != null)
			{
				el.innerHTML = r_text;
			}
		}
		else if ((httpr.readyState==4 || httpr.readyState == 'complete'))
		{
			var el = document.getElementById(elementid);
			if (el != null)
			{
				el.innerHTML = "<h1>Failed: Status " + httpr.status + "</h1>";			
			}
		}
//		else
//		{
//			document.getElementById(elementid).innerHTML = "<h1>Failed to fetch result</h1>";//<ul><li>Status text:" + "something" + httpr.statusText ;//+ "</li><li>Response text:" + httpr.responseText + "</li></ul>";
//		}
	}
	
	function dorequest(url,elementid)
	{
		var httpr = null;
		var f_sc = function() {updateelementwithresult(httpr, elementid)};
		if (window.XMLHttpRequest)
		{
			httpr = new XMLHttpRequest();
		}
		else
		{
			httpr = get_ms_xml_http();
		}
		
		if (!httpr || httpr == null)
		{
			return false;
		}
		
			var el = document.getElementById(elementid);
			if (el != null)
			{
			el.innerHTML = 'Loading comments...';
			}
		httpr.onreadystatechange = f_sc;
		httpr.open('GET',url,true);
		httpr.send(null);
		return false;
	}
	
	function doconfigrequest(url,params,elementid)
	{
		var httpr = null;
		var f_sc = function() {updateelementwithresult(httpr, elementid)};
		if (window.XMLHttpRequest)
		{
			httpr = new XMLHttpRequest();
		}
		else
		{
			httpr = get_ms_xml_http();
		}
		
		if (!httpr || httpr == null)
		{
			return false;
		}
		
			var el = document.getElementById(elementid);
			if (el != null)
			{
			el.innerHTML = 'Loading comments...';
			}
		var conf = document.getElementById('configtext');
		if (conf != null)
		{
			params += "&config=" + encodeURIComponent(conf.value);
		}
		httpr.open('POST',url,true);
		httpr.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
		httpr.setRequestHeader("Content-length", params.length);
		httpr.setRequestHeader("Connection", "close");
		httpr.onreadystatechange = f_sc;
		httpr.send(params);
		return false;
	}
	
	
	var dnaacs__r_element="dnaacs-r";
	var dnaacs__timer_element="dnaacs-countdown-display";
	var dnaacs__processing_element="dnaacs-proccessing";
	var dnaacs__c_name = "dnaacs_s_r";
	var dnaacs__user_id="6";
	var dnaacs__uid="6musictestrun9343534547545938459";
	var dnaacs__seconds_restr=0;
		
	
	
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
	
	function dnaacs__get_r(dnaacs__c_url,dnaacs__r_element) 
	{
	    var dnaacs__http_request = null;
		var dnaacs_h = function() {dnaacs__do_h_r(dnaacs__http_request,dnaacs__r_element)};
		
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
		
		var url = "/dna/mb6music/acs/acs?";
		var params = "dnauid="+dnaacs__f.dnauid.value;
		params += "&dnaaction="+dnaacs__f.dnaaction.value;
		params += "&dnacomment="+encodeURI(dnaacs__f.dnacomment.value);
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
		var dnaacs__r_url="/dna/mb6music/acs/acs?";
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
			var dnaacs__timer_text = "Please click the button below to submit your comment.";
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
 

