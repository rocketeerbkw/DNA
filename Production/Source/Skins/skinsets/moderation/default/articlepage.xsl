<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<xsl:import href="../../../base/base-articlepage.xsl"/>
	<xsl:template name="ARTICLE_JAVASCRIPT">
		<script language="JavaScript" type="text/javascript">
var req;

function loadXMLDoc(url) 
{
    // branch for native XMLHttpRequest object
    if (window.XMLHttpRequest) {		
        req = new XMLHttpRequest();
        req.onreadystatechange = processReqChange;
        req.open("GET", url, true);
        req.send(null);
    // branch for IE/Windows ActiveX version
    } else if (window.ActiveXObject) {
        req = new ActiveXObject("Microsoft.XMLHTTP");
        if (req) {
            req.onreadystatechange = processReqChange;
            req.open("GET", url, true);
            req.send();
        }
    }
}

function processReqChange() 
{
    // only if req shows "complete"
    if (req.readyState == 4) {
        // only if "OK"
        if (req.status == 200) {
            // ...processing statements go here...
			response  = req.responseXML.documentElement;
			//method = response.getElementsByTagName('method')[0].firstChild.data;
			method = checkName;
			result = response.getElementsByTagName('title')[0].firstChild.data;
		    //eval(method + '(\'\', result)');
			checkName('', result);
        } else {
            alert("There was a problem retrieving the XML data:\n" + req.statusText);
        }
    }
}

function checkName(input, response)
{
  if (response != ''){ 
    // Response mode
    /*message   = document.getElementById('nameCheckFailed');
    if (response == '1'){
      message.className = 'error';
    }else{
      message.className = 'hidden';
    } */	
	alert(response);
  }else{
    // Input mode
    url  = '/dna/collective/xml/reviews?s_xml=rss';
    loadXMLDoc(url);	
  }

}
	</script>
	</xsl:template>
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
									Page - Level  template
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<xsl:template name="ARTICLE_MAINBODY">
		<span class="clear"/>
		<div class="mainContent" id="articleModeration">
			<h2>Article subject:</h2>
			<p>
				<xsl:apply-templates select="/H2G2/ARTICLE/SUBJECT"/>
			</p>
			<h2>Article content:</h2>
			<p>
				<xsl:apply-templates select="/H2G2/ARTICLE/GUIDE/BODY"/>
			</p>
			<h2>Article moderation form:</h2>
			<p>
				<xsl:apply-templates select="ARTICLE-MODERATION-FORM" mode="c_modform"/>
			</p>
			<h2>Article in context:</h2>
			<p>
				<a target="_blank" href="/dna/{/H2G2/SITE-LIST/SITE[@ID = /H2G2/ARTICLE/ARTICLEINFO/SITE/ID]/NAME}/A{/H2G2/ARTICLE/ARTICLEINFO/H2G2ID}">
					<xsl:value-of select="/H2G2/ARTICLE/SUBJECT"/>
				</a>
				<!--<xsl:comment>
				<xsl:text>#include virtual="/dna/</xsl:text>
				<xsl:value-of select="/H2G2/SITE-LIST/SITE[@ID = /H2G2/ARTICLE/ARTICLEINFO/SITE/ID]/NAME"/>
				<xsl:text>/</xsl:text>
				<xsl:choose>
					<xsl:when test="/H2G2/ARTICLE/ARTICLEINFO/STATUS/@TYPE = 3">
						<xsl:text>U</xsl:text>
						<xsl:value-of select="/H2G2/ARTICLE/ARTICLEINFO/PAGEAUTHOR/EDITOR/USER/USERID"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>A</xsl:text>
						<xsl:value-of select="/H2G2/ARTICLE/ARTICLEINFO/H2G2ID"/>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:text>" </xsl:text>
			</xsl:comment>-->
			</p>
		</div>
	</xsl:template>
</xsl:stylesheet>
