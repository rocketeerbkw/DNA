<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0" 
                xmlns:msxsl="urn:schemas-microsoft-com:xslt" 
                xmlns:local="#local-functions" 
                xmlns:s="urn:schemas-microsoft-com:xml-data" 
                xmlns:dt="urn:schemas-microsoft-com:datatypes">

<!-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! -->
<!-- ADJUSTED THE IMAGE PATH IN JS BELOW FOR TESTING -->
<!-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! -->

<!-- In Global Variables 
	  var imgPath="";
	  LIVE PATH : /h2g2/skins/brunel/images/buttons/
	  LOCAL PATH : q:/h2g2/dna/brunel/images/buttons/
-->

<xsl:template name="EnhEditorJS">
	<script type="text/javascript" language="JavaScript">
	<![CDATA[
	<!--//
	// Script Coded by Fraser Pearce, Client Side Development Team, BBC New Media.
	// Version 1.3f [h2g2] 9/4/2002
	// Contact fraser.pearce@bbc.co.uk
	
	// Browser Check Script:
	// browserType 	0 = IE3 Mac, v2 browsers and anything too unknown.
	//				1 = All other v3 browsers and NS4
	//				2 = IE4 Win, IE4+ Mac, Opera 5+ and NS6+/Mozilla
	//				3 = IE5+ Win
	// Note: Could be done by checking property, although this method works fine too, albeit
	// a less future safe method as if a newer browser appears such that it can do what IE 5+
	// does with form select ranges, however this is unlikely for the foreseeable future.
	function checkType() {
		var browserType = 0;
		if (navigator.appName == "Microsoft Internet Explorer"){
			if (parseInt(navigator.appVersion) >= 4) {
				if (navigator.appVersion.charAt(navigator.appVersion.indexOf("MSIE") + 5) >= 5) {
					if (navigator.platform.indexOf("Win") != -1 && document.selection) {browserType = 3}
					else {browserType = 2} 
				}
				if (navigator.appVersion.charAt(navigator.appVersion.indexOf("MSIE") + 5) == 4) {browserType = 2} 
			}
			if (parseInt(navigator.appVersion) == 3) {browserType = 1}
		}
		else {
			if (parseInt(navigator.appVersion) >= 3) {
				if (parseInt(navigator.appVersion) >= 5) {browserType = 2}
				else {browserType = 1} 
			}
		}
		return browserType;
	}
	
	// Global Variables
	var imgPath="]]><xsl:value-of select="$imagesource"/><![CDATA[buttons/";
	var browserType = checkType();
	
	// Draw the Tool Buttons (Inside a table cell)
	function drawTools(browserType) {
		if (browserType == 0) {document.writeln('Sorry, the Enhanced Editor will not work on this particular browser.')}
		else {
			var funcArray = new Array(new Array("bold","Bold","i_bold",""),
									  new Array("italic","Italic","i_italic",""),
									  new Array("sup","Superscript","i_sup",""),
									  new Array("sub","Subscript","i_sub",""),
									  new Array("sp","","",""),
									  new Array("linebreak","Line Break","i_linebreak",""),
									  new Array("hrule","Horizontal Rule","i_hrule",""),
									  new Array("sp","","",""),
									  new Array("br","","",""),
									  new Array("header","Heading","i_header",""),
									  new Array("subhead","Subheader","i_subhead",""),
									  new Array("para","Paragraph","i_para",""),
									  new Array("blockquote","Blockquote","i_blockquote",""),
									  new Array("pre","Preformatted Text","i_pre",""),
									  new Array("br","","",""),
									  new Array("bullet","Bulleted List","e_list","b"),
									  new Array("numlist","Numbered List","e_list","n"),
									  new Array("table","Table","i_table",""),
									  new Array("sp","","",""),
									  new Array("foot","Foot Note","i_foot",""),
									  new Array("entity","Entity","i_entity",""),
									  new Array("link","Link","i_link",""),
									  new Array("pic","Picture","i_pic",""));
			if (browserType >= 2) {
				for (i=0;i<funcArray.length;i++) {
					if (funcArray[i][0] == 'br') {}
					else {
						if (funcArray[i][0] == 'sp') {document.write('<IMG SRC="/furniture/tiny.gif" WIDTH="8" HEIGHT="1" ALT="">')}
						else {document.write('<IMG SRC="' + imgPath + funcArray[i][0] + '.gif" ALT="' + funcArray[i][1] + '" NAME="' + funcArray[i][0] + '" ONCLICK="callClick(' + funcArray[i][2] + ',\'' + funcArray[i][3] + '\',\'' + funcArray[i][4] + '\')" WIDTH="26" HEIGHT="26" BORDER="0" HSPACE="3">')}
					}
				}
			}
			if (browserType == 1) {
				for (i=0;i<funcArray.length;i++) {
					if (funcArray[i][0] == 'br') {document.write('<BR>')}
					else {
						if (funcArray[i][0] == 'sp') {}
						else {document.write('<INPUT TYPE="Button" VALUE="' + funcArray[i][1] + '" ONCLICK="callClick(' + funcArray[i][2] + ',\'' + funcArray[i][3] + '\',\'' + funcArray[i][4] + '\')">')}
					}
				}
			}
		return true;
		}
	}
	
	// Draw the Emoticons (Inside a table cell)
	function drawEmoticons(browserType) {
		if (browserType == 0) {return false}
		else {	
			var funcArray = new Array(new Array("smiley","Smile"),
									  new Array("biggrin","Big Grin"),
									  new Array("laugh","Laugh"),
									  new Array("sadface","Sad"),
									  new Array("blush","Blush"),
									  new Array("kiss","Kiss"),
									  new Array("smooch","Smooch"),
									  new Array("loveblush","Love Blush"),
									  new Array("br",""),
									  new Array("winkeye","Winking"),
									  new Array("erm","Erm"),
									  new Array("cool","Cool"),
									  new Array("wah","Wah"),
									  new Array("cheerup","Cheer Up"),
									  new Array("hug","Hug"),
									  new Array("ok","OK"),
									  new Array("cheers","Cheers"),
									  new Array("br",""),
									  new Array("ale","Ale"),
									  new Array("bubbly","Bubbly"),
									  new Array("tea","Tea"),
									  new Array("cake","Cake"),
									  new Array("choc","Chocolate"),
									  new Array("tongueout","Tongue Out"),
									  new Array("run","Run"),
									  new Array("magic","Magic"));
			if (browserType >= 2) {
				for (i=0;i<funcArray.length;i++) {
					if (funcArray[i][0] == 'br') {document.write('<BR><IMG SRC="/furniture/tiny.gif" WIDTH="1" HEIGHT="4" ALT=""><BR>')}
					else {document.write('<IMG SRC="' + imgPath + funcArray[i][0] + '.gif" ALT="' + funcArray[i][1] + '" NAME="' + funcArray[i][0] + '" ONCLICK="e_emote(this.name)" WIDTH="51" HEIGHT="22" BORDER="0" HSPACE="2">')}
				}
			}
			if (browserType == 1) {
				for (i=0;i<funcArray.length;i++) {
					if (funcArray[i][0] == 'br') {document.write('<BR>')}
					else {document.write('<INPUT TYPE="Button" VALUE="' + funcArray[i][1] + '" ONCLICK="e_emote(\'' + funcArray[i][0] + '\')">')}
				}
			}
		return true;
		}
	}
	
	// Draw the hotkey list (including the table rows)
	function drawHotkeys(browserType) {
		if (browserType != 3) {return false}
		else {	
			var funcArray = new Array(new Array("CTRL + SHIFT + A","Link"),
									  new Array("CTRL + SHIFT + B","Bold"),
									  new Array("CTRL + SHIFT + C","Code"),
									  new Array("CTRL + SHIFT + D","Bulleted List"),
									  new Array("CTRL + SHIFT + E","Entity"),
									  new Array("CTRL + SHIFT + F","Footnote"),
									  new Array("CTRL + SHIFT + G","Picture"),
									  new Array("CTRL + SHIFT + H","Heading"),
									  new Array("CTRL + SHIFT + I","Italic"),
									  new Array("CTRL + SHIFT + J","Subscript"),
									  new Array("CTRL + SHIFT + K","Superscript"),
									  new Array("CTRL + SHIFT + L","Linebreak"),
									  new Array("CTRL + SHIFT + N","Numbered List"),
									  new Array("CTRL + SHIFT + P","Paragraph"),
									  new Array("CTRL + SHIFT + Q","Block Quote"),
									  new Array("CTRL + SHIFT + S","Subheader"),
									  new Array("CTRL + SHIFT + T","Table"),
									  new Array("CTRL + SHIFT + U","Preformatted Text"),
									  new Array("CTRL + SHIFT + W","Horizontal Rule"));
			document.write('<TR><TD><FONT FACE="arial, helvetica, sans-serif" SIZE="2" CLASS="postxt"><B>Keyboard Shortcuts:</B></FONT><BR><TABLE WIDTH="300" CELLPADDING=0 CELLSPACING=2 BORDER=0><TR><TD><FONT FACE="verdana, helvetica, sans-serif" SIZE="1" CLASS="postxt"><B>Hotkey</B></FONT></TD><TD><FONT FACE="verdana, helvetica, sans-serif" SIZE="1" CLASS="postxt"><B>Function</B></FONT></TD></TR>');
			for (i=0;i<funcArray.length;i++) {
				document.write('<TR><TD><FONT FACE="verdana, helvetica, sans-serif" SIZE="1" CLASS="postxt">' + funcArray[i][0] + '</FONT></TD><TD><FONT FACE="verdana, helvetica, sans-serif" SIZE="1" CLASS="postxt">' + funcArray[i][1] + '</FONT></TD></TR>');
			}
			document.write('</TABLE></TD></TR>');
		return true;
		}
	}
	
	// Call the Tag Function, and organise Parameters
	// e = extra parameter needed (execType) [i.e. list type]
	function callClick(callType,outType) {
		domPath.focus();
		if (browserType == 3) {highlighted = document.selection.createRange().text;}
		else {highlighted = ""}
		if (outType == 'b' || outType == 'n') {callType(highlighted,outType)}
		else {callType(highlighted)}
		return true;
	}
	
	// Monitor, check condtitions and execute functions for keyboard shortcuts
	function hotkeys() {
		if (browserType == 3) {
			if (event.ctrlKey != true) {return false}
			sRange = document.selection.createRange();
			qParent = sRange.parentElement();
			if (qParent.tagName != "TEXTAREA") {return false}
			highlighted = document.selection.createRange().text;
			if (window.event.keyCode == 1) {i_link(highlighted);}
			if (window.event.keyCode == 4) {e_list(highlighted,'b');}
			if (window.event.keyCode == 5) {i_entity(highlighted);}
			if (window.event.keyCode == 7) {i_pic(highlighted);}
			if (window.event.keyCode == 12) {i_linebreak(highlighted);}
			if (window.event.keyCode == 14) {e_list(highlighted,'n');}
			if (window.event.keyCode == 16) {i_para(highlighted);}
			if (window.event.keyCode == 20) {i_table(highlighted);}
			if (window.event.keyCode == 23) {i_hrule(highlighted);}
			if (window.event.keyCode == 2) {i_bold(highlighted);}
			if (window.event.keyCode == 3) {i_code(highlighted);}
			if (window.event.keyCode == 6) {i_foot(highlighted);}
			if (window.event.keyCode == 8) {i_header(highlighted);}
			if (window.event.keyCode == 9) {i_italic(highlighted);}
			if (window.event.keyCode == 10) {i_sub(highlighted);}
			if (window.event.keyCode == 11) {i_sup(highlighted);}
			if (window.event.keyCode == 17) {i_blockquote(highlighted);}
			if (window.event.keyCode == 19) {i_subhead(highlighted);}
			if (window.event.keyCode == 21) {i_pre(highlighted);}
		return true;
		}
	}
	
	// BOLD
	function i_bold(scriptTxt) { 
		if (browserType == 3) {document.selection.createRange().text = '<B>' + scriptTxt + '</B>'}
		if (browserType == 2 || browserType == 1) {domPath.value += '<B>' + scriptTxt + '</B>'}
		return true;
	}
	
	// ITALIC
	function i_italic(scriptTxt) { 
		if (browserType == 3) {document.selection.createRange().text = '<I>' + scriptTxt + '</I>'}
		if (browserType == 2 || browserType == 1) {domPath.value += '<I>' + scriptTxt + '</I>'}
		return true;
	}
	
	// HEADING
	function i_header(scriptTxt) { 
		if (browserType == 3) {document.selection.createRange().text = '<HEADER>' + scriptTxt + '</HEADER>'}
		if (browserType == 2 || browserType == 1) {domPath.value += '<HEADER>' + scriptTxt + '</HEADER>'}
		return true;
	}
	
	// SUBHEADING
	function i_subhead(scriptTxt) { 
		if (browserType == 3) {document.selection.createRange().text = '<SUBHEADER>' + scriptTxt + '</SUBHEADER>'}
		if (browserType == 2 || browserType == 1) {domPath.value += '<SUBHEADER>' + scriptTxt + '</SUBHEADER>'}
		return true;
	}
	
	// FOOTNOTE
	function i_foot(scriptTxt) { 
		if (browserType == 3) {document.selection.createRange().text = '<FOOTNOTE>' + scriptTxt + '</FOOTNOTE>'}
		if (browserType == 2 || browserType == 1) {domPath.value += '<FOOTNOTE>' + scriptTxt + '</FOOTNOTE>'}
		return true;
	}
	
	// SUBSCRIPT
	function i_sub(scriptTxt) { 
		if (browserType == 3) {document.selection.createRange().text = '<SUB>' + scriptTxt + '</SUB>'}
		if (browserType == 2 || browserType == 1) {domPath.value += '<SUB>' + scriptTxt + '</SUB>'}
		return true;
	}
	
	// SUPERSCRIPT
	function i_sup(scriptTxt) { 
		if (browserType == 3) {document.selection.createRange().text = '<SUP>' + scriptTxt + '</SUP>'}
		if (browserType == 2 || browserType == 1) {domPath.value += '<SUP>' + scriptTxt + '</SUP>'}
		return true;
	}
	
	// BLOCK QUOTE
	function i_blockquote(scriptTxt) { 
		if (browserType == 3) {document.selection.createRange().text = '<BLOCKQUOTE>' + scriptTxt + '</BLOCKQUOTE>'}
		if (browserType == 2 || browserType == 1) {domPath.value += '<BLOCKQUOTE>' + scriptTxt + '</BLOCKQUOTE>'}
		return true;
	}
	
	// CODE
	function i_code(scriptTxt) { 
		if (browserType == 3) {document.selection.createRange().text = '<CODE>' + scriptTxt + '</CODE>'}
		if (browserType == 2 || browserType == 1) {domPath.value += '<CODE>' + scriptTxt + '</CODE>'}
		return true;
	}
	
	// PREFORMATTED TEXT
	function i_pre(scriptTxt) { 
		if (browserType == 3) {document.selection.createRange().text = '<PRE>' + scriptTxt + '</PRE>'}
		if (browserType == 2 || browserType == 1) {domPath.value += '<PRE>' + scriptTxt + '</PRE>'}
		return true;
	}
	
	// LINEBREAK [BR]
	function i_linebreak(scriptTxt) {
		if (browserType == 3) {document.selection.createRange().text = scriptTxt + '<BR/>'}
		if (browserType == 2 || browserType == 1) {domPath.value += scriptTxt + '<BR/>'}
		return true;
	}
	
	// HORIZONTAL RULE
	function i_hrule(scriptTxt) {
		if (browserType == 3) {document.selection.createRange().text = scriptTxt + '<HR/>'}
		if (browserType == 2 || browserType == 1) {domPath.value += scriptTxt + '<HR/>'}
		return true;
	}
	
	// PARAGRAPH
	function i_para(scriptTxt) { 
		var i = 0;
		while (i == 0) {
			alignVar = prompt("LEFT, CENTER, RIGHT or FREE? (OK defaults to none)", "");
			if (alignVar == null) {return false;}
			if (alignVar == null || alignVar == "") {alignVar = "NONE"}
			alignVar = alignVar.toUpperCase();
			if (alignVar != 'NONE' && alignVar != 'LEFT' && alignVar != 'RIGHT' && alignVar != 'CENTER') {alert("Link Type Unknown! Please enter NONE, LEFT, CENTER or RIGHT.")}
			else {i = 1}
		}
		if (alignVar == 'NONE') {alignVar = ""}
		else {alignVar = ' ALIGN="' + alignVar + '"'}
		if (browserType == 3) {document.selection.createRange().text = '<P' + alignVar + '>' + scriptTxt + '</P>'}
		if (browserType == 2 || browserType == 1) {domPath.value += '<P' + alignVar + '></P>'}
		return true;
	}
	
	// LINK
	function i_link(scriptTxt) { 
		var i = 0;
		while (i == 0) {
			linkVar = prompt("Please type in the link", "");
			if (linkVar == null || linkVar == "") 
			{
				return false;
			}
			uclinkVar = linkVar;
			linkVar = linkVar.toLowerCase();
			if (((linkVar.charAt(0) == 'a' || linkVar.charAt(0) == 'f' || linkVar.charAt(0) == 'c') && linkVar.charAt(1) >= '0' && linkVar.charAt(1) <= '9') || ((linkVar.indexOf('rf') == 0 || linkVar.indexOf('mj') == 0 || linkVar.indexOf('ma') == 0 || linkVar.indexOf('mp') == 0) && linkVar.charAt(2) >= '0' && linkVar.charAt(2) <= '9')) 
			{
				linkVar = linkVar.toUpperCase(); typeVar = 'DNAID'; i = 1;
			}
			else 
			{
				if (linkVar.charAt(0) == 'u' && linkVar.charAt(1) >= '0' && linkVar.charAt(1) <= '9') 
				{
					linkVar = linkVar.toUpperCase(); typeVar = 'BIO'; i = 1;
				}
				else 
				{
					if (linkVar.indexOf('http://') == 0) 
					{
						typeVar = 'HREF';i = 1;
					}
					else 
					{
						if (linkVar.indexOf('www.') == 0) 
						{
							linkVar = 'http://' + linkVar; typeVar = 'HREF'; i = 1;
						}
						else 
						{
							//alert("That does not appear to be a valid, article, bio or web link.")
							typeVar = 'HREF';
							i = 1;
						}
					}
				}
			}
		}
		if (browserType == 3) {document.selection.createRange().text = '<LINK ' + typeVar + '="' + uclinkVar + '">' + scriptTxt + '</LINK>'}
		if (browserType == 2 || browserType == 1) {domPath.value += '<LINK ' + typeVar + '="' + uclinkVar + '">' + scriptTxt + '</LINK>'}
		return true;
	}
	
	// LISTS
	// B = Bulleted
	// N = Numbered
	function e_list(scriptTxt,listType) { 
		listItem = prompt("Please type in the first list point.", "");
		if (listItem == null || listItem == "") {return false}
		listTxt = '<LI>' + listItem + '</LI>\r\n';
		var i = 0;
		while (i == 0) {
			listItem = prompt("Please type in the next list point, or press cancel to close the list.", "");
		 	if (listItem == null || listItem == "") {i = 1}
			else {listTxt = listTxt + '<LI>' + listItem + '</LI>\r\n'}
		}
		if (listType == 'b') {
			if (browserType == 3) {document.selection.createRange().text = scriptTxt + '<UL>\r\n' + listTxt + '</UL>\r\n'}
			if (browserType == 2 || browserType == 1) {domPath.value += scriptTxt + '<UL>\r\n' + listTxt + '</UL>\r\n'}
		}
		if (listType == 'n') {
			if (browserType == 3) {document.selection.createRange().text = scriptTxt + '<OL>\r\n' + listTxt + '</OL>\r\n'}
			if (browserType == 2 || browserType == 1) {domPath.value += scriptTxt + '<OL>\r\n' + listTxt + '</OL>\r\n'}
		}
		return true;
	}
	
	// ENTITY
	function i_entity(scriptTxt) { 
		var i = 0;
		while (i == 0) {
			entityNum = prompt("Please type in the entity number.", "");
			if (entityNum == null || entityNum == "") {return}
			if (entityNum.charAt(0) == '#') {return}
			//if (entityNum !=  parseInt(entityNum)) {alert("Entity numbers should be NUMERICAL.")}
			//else {i = 1}
			i = 1;
		}
		var entname = entityNum;
		if (entityNum ==  parseInt(entityNum)) {entname = "#" + entityNum}
		if (browserType == 3) {document.selection.createRange().text = scriptTxt + '<ENTITY TYPE="' + entname + '"/>'}
		if (browserType == 2 || browserType == 1) {domPath.value += scriptTxt + '<ENTITY TYPE="' + entname + '"/>'}
	}
	
	// PICTURE
	function i_pic(scriptTxt) {
		var i = 0;
		while (i == 0) {
			blobName = prompt("Please type in the Blob Name.", "");
			if (blobName == null || blobName == "") {return}
			blobName = blobName.toUpperCase();
			if (blobName.charAt(0) != 'B') {alert("That does not appear to be a valid blob name as it does not start with a B.")}
			else {i = 1}
		}
		var i = 0;
		while (i == 0) {
			alignVar = prompt("Would you like the picture aligned to the LEFT, CENTER, RIGHT or FREE? (just pressing OK defaults to left)", "");
			if (alignVar == null || alignVar == "") {alignVar = "LEFT"}
			alignVar = alignVar.toUpperCase();
			if (alignVar != 'LEFT' && alignVar != 'RIGHT' && alignVar != 'CENTER' && alignVar != 'FREE') {alert("Link Type Unknown! Please enter LEFT, CENTER, RIGHT or FREE.")}
			else {i = 1}
		}
		altText = prompt("Please type in the ALT text. (Press OK to leave empty).", "");
		if (altText == null) {altText = ""}
		else {
			if (browserType == 3) {
				if (scriptTxt != null && scriptTxt != "") {document.selection.createRange().text = '<PICTURE BLOB="' + blobName + '" EMBED="' + alignVar + '" ALT="' + altText + '"/>' +  scriptTxt + '</PICTURE>'}
				else {document.selection.createRange().text = scriptTxt + '<PICTURE BLOB="' + blobName + '" EMBED="' + alignVar + '" ALT="' + altText + '"/>'}
			}
			if (browserType == 2 || browserType == 1) {domPath.value += scriptTxt + '<PICTURE BLOB="' + blobName + '" EMBED="' + alignVar + '" ALT="' + altText + '"/>'}
		}
	}
	
	// TABLE
	function i_table(scriptTxt) { 
		var makeTable = "";
		var k = 0;
		while (k == 0) {
			colsVar = prompt("Please type in the number of COLUMNS.", "");
			if (colsVar == null || colsVar == "") {return false}
			if (colsVar !=  parseInt(colsVar)) {alert("The value for the number of columns must be NUMERICAL.")}
			else {k = 1}
		}
		k = 0;
		while (k == 0) {
			rowsVar = prompt("Please type in the number of ROWS.", "");
			if (rowsVar == null || rowsVar == "") {return false}
			if (rowsVar !=  parseInt(rowsVar)) {alert("The value for the number of rows must be NUMERICAL.")}
			else {k = 1}
		}
		for (i=0;i<rowsVar;i++) {
			makeTable = makeTable + "<TR>\r\n";
			for (j=0;j<colsVar;j++) {
				makeTable = makeTable + "  <TD></TD>\r\n";
			}
			makeTable = makeTable + "</TR>\r\n";
		}
		if (browserType == 3) {document.selection.createRange().text = scriptTxt + '<TABLE>\r\n' + makeTable + '</TABLE>\r\n'}
		if (browserType == 2 || browserType == 1) {domPath.value += scriptTxt + '<TABLE>\r\n' + makeTable + '</TABLE>\r\n'}
		return true;
	}
	
	// EMOTICONS
	function e_emote(emoticon) {
		domPath.focus();
		if (browserType == 3) {scriptTxt = document.selection.createRange().text;}
		else {scriptTxt = ""}
		if (browserType == 3) {document.selection.createRange().text = scriptTxt + '<' + emoticon + '>'}
		if (browserType == 2 || browserType == 1) {domPath.value += scriptTxt + '<' + emoticon + '>'}
		return true;
	}
	
	// BUG FIX: NS4 FORM REFRESH BUG
	function forceFresh() {
		if (document.CAT.forceFresh.winW != window.innerWidth || document.CAT.forceFresh.winH != window.innerHeight) {
			document.location = document.location
		}
	}
	
	function setFreshVars() {
	var agent = navigator.userAgent.toLowerCase();
	if((parseInt(navigator.appVersion) == 4) && 
	   (agent.indexOf('mozilla')!=-1) &&
	   (agent.indexOf('spoofer')==-1) &&
	   (agent.indexOf('compatible') == -1) &&
	   (agent.indexOf('opera')==-1) &&
	   (agent.indexOf('webtv')==-1)) {
	    if (typeof document.CAT == 'undefined'){document.CAT = new Object}
	    if (typeof document.CAT.scaleFont == 'undefined') {
	      document.CAT.forceFresh = new Object;
	      document.CAT.forceFresh.winW = window.innerWidth;
	      document.CAT.forceFresh.winH = window.innerHeight;
	    }
	    window.onresize = forceFresh;
	  }
	}
	
	setFreshVars()
	
	//-->
	]]>
	</script>
</xsl:template>

</xsl:stylesheet>
