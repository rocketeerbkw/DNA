<%@ Page Language="C#" AutoEventWireup="true" Inherits="acsdemoindex" Codebehind="acsdemoindex.aspx.cs" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head id="Head1" runat="server">
    <title>Untitled Page</title>
    <script src="/dna/h2g2/acsdoc.js" type="text/javascript"></script>
</head>
<body>
<%--<%
	string[] stylesheets = System.IO.Directory.GetFiles(Server.MapPath(""), "*.css");
	foreach (string stylesheet in stylesheets)
	{
		Response.Write(String.Format("<a href='Default.aspx?stylesheet={0}'>{0}</a><br/>",System.IO.Path.GetFileName(stylesheet)));
	}
	
	 %>
--%>
<%--<form method="get" action="acsdemoindex">
<input type="text" name="stylesheet" value="defaultstyle.css" />
<input type="submit" name="submit" value="Change Stylesheet" />
</form>
--%>    <form id="form1" runat="server">
	<div class="helpsection" style="display:none">
	<h3>Comments 2.0 Sandbox</h3>
	<p>This include will help you design your stylesheet for including Comments 2.0 on your pages. With it you can:</p>
	<ul><li>See the different 'states' the comments can be in</li>
	<li>See the different messages that are displayed, and how to change them</li>
	<li>Use your own configuration file to change the messages</li>
	</ul>
	<p>To use this on your own page, just include the following line at the appropriate place in your template:</p>
	<p>&lt;!--#include virtual="/dna-ssi/staging/mb6music/acs/acsdemoindex?&$QUERY_STRING"--&gt;</p>
	<p>You'll also need to include the CSS files <code>/h2g2/test/comments.css</code> and <code>/h2g2/test/hack.css</code> or your replacements.</p>
	</div>
<!--    <div id="cleartemplates"><a href="#" onclick="return dorequest('/dna/h2g2/stylepage?clear_templates=1','xxx');">clear templates</a></div>
    <div class="helpsection" style="display:none"></div>-->
    <div id="openit" style="display:none"><a href="#" onclick="unhide('samples');unhide('closeit');hide('openit');return false;">show states</a>
    <div class="helpsection" style="display:none">Show the list of sample comment 'states'</div>
    </div>
    <div id="closeit"><a href="#" onclick="hide('samples');hide('closeit');unhide('openit');return false;">hide states</a>
    <div class="helpsection" style="display:none">Hide the list of sample comment 'states'</div>
    </div>
    <div id="hidemessagenames" style="display:none"><a href="#" onclick="unhide('showmessagenames');hide('hidemessagenames');hideallclass('dnaacs-message-name');return false;">hide message names</a>
    <div class="helpsection" style="display:none">Hide the labels showing the element names of each message as they appear in SiteConfig</div>
	</div>
    <div id="showmessagenames"><a href="#" onclick="hide('showmessagenames');unhide('hidemessagenames');showallclass('dnaacs-message-name');return false;">show message names</a>
    <div class="helpsection" style="display:none">Show  the labels showing the element names of each message as they appear in SiteConfig</div>
    </div>
    <div id="showconfig"><a href="#" onclick="unhide('configblock');unhide('hideconfig');hide('showconfig');return false;">show config</a>
    <div class="helpsection" style="display:none">Show the SiteConfig edit box</div>
    </div>
    <div id="hideconfig" style="display:none"><a href="#" onclick="hide('configblock');hide('hideconfig');unhide('showconfig');return false;">hide config</a>
    <div class="helpsection" style="display:none">Hide the SiteConfig edit box</div>
    </div>
		<div id="configblock" style="display:none">
		<textarea id="configtext" style="font-size:8pt;width:350px;height:400px;font-family:Arial"></textarea>
    <div class="helpsection" style="display:none">Type your SiteConfig XML into this box to see what the comments look like with your messages</div>
		<a href="#" onclick="return doconfigrequest('/dna/h2g2/stylepage','checkconfig=1','configerror');">Check config</a>
    <div class="helpsection" style="display:none">Click on Check Config to see if your SiteConfig XML works. If you have an error in your XML, 
    the system will ignore it all and use the default config.</div>
		<div id="configerror"></div>
		</div>
		<div id="showhelp"><a href="#" onclick="showallclass('helpsection');unhide('hidehelp');hide('showhelp');return false;">show help</a></div>
		<div id="hidehelp" style="display:none"><a href="#" onclick="hideallclass('helpsection');hide('hidehelp');unhide('showhelp');return false;">hide help</a></div>
		<div class="helpsection" style="display:none">The following links will pull in a comments section onto the page in the described state. 
		You should check that all of the states shown here display sensibly on your pages, and that all messages are displayed appropriately.</div>
    <div id="samples">
    <% ScanSamples(); %>
    </div>
    </form>
    <div id="uniqueid">include text will appear here</div>
</body>
</html>
