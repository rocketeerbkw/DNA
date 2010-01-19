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
		<form>
			<input type="Button" onclick="checkName(this.value,'')" value="Press"/>
		</form>
		<xsl:text>=================================================================</xsl:text>
		<xsl:if test="$test_IsEditor or $test_IsModerator">
			<xsl:apply-templates select="/H2G2/CLIP" mode="c_articleclipped"/>
			<table width="100%" cellpadding="0" cellspacing="0" border="0">
				<tr>
					<td valign="top" class="postmain">
						<table width="100%" cellpadding="0" cellspacing="5" border="0">
							<tr>
								<td>
									<font xsl:use-attribute-sets="mainfont">
										<xsl:apply-templates select="/H2G2/ARTICLE/ARTICLEINFO/CRUMBTRAILS" mode="c_article"/>
										<!--xsl:apply-templates select="ARTICLE" mode="c_categorise"/-->
										<xsl:apply-templates select="ARTICLE" mode="c_articlepage"/>
										<br/>
										<br/>
										<xsl:apply-templates select="ARTICLE" mode="c_unregisteredmessage"/>
										<xsl:apply-templates select="ARTICLE-MODERATION-FORM" mode="c_skiptomod"/>
										<xsl:apply-templates select="ARTICLE-MODERATION-FORM" mode="c_modform"/>
										<xsl:apply-templates select="/H2G2/ARTICLE/ARTICLEINFO/MODERATIONSTATUS" mode="c_articlepage"/>
										<xsl:apply-templates select="EMAIL-SUBSCRIPTION" mode="c_articlepage"/>
									</font>
								</td>
							</tr>
						</table>
					</td>
					<td valign="top" class="postside" width="200">
						<font xsl:use-attribute-sets="mainfont">
							<xsl:apply-templates select="ARTICLE" mode="c_tag"/>
							<xsl:apply-templates select="ARTICLEFORUM" mode="c_article"/>
							<br/>
							<xsl:apply-templates select="ARTICLE/ARTICLEINFO" mode="c_articlepage"/>
						</font>
					</td>
				</tr>
			</table>
		</xsl:if>
	</xsl:template>
	<!--
	<xsl:template match="MODERATIONSTATUS" mode="r_articlepage">
	Description: moderation status of the article
	 -->
	<xsl:template match="MODERATIONSTATUS" mode="r_articlepage">
		<xsl:apply-imports/>
	</xsl:template>
	<!--
	<xsl:template match="CLIP" mode="r_articleclipped">
	Description: message to be displayed after clipping an article
	 -->
	<xsl:template match="CLIP" mode="r_articleclipped">
		<b>
			<xsl:apply-imports/>
		</b>
		<br/>
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
		<table bgColor="lightblue" cellspacing="2" cellpadding="2" border="0">
			<tr>
				<td>
					<font xsl:use-attribute-sets="mainfont">
						<xsl:apply-imports/>
					</font>
				</td>
			</tr>
		</table>
	</xsl:template>
	<!--
	<xsl:template match="ARTICLE" mode="add_tag">
	Use: Presentation for the link to add an article to the taxonomy
	 -->
	<xsl:template match="ARTICLE" mode="add_tag">
		<xsl:apply-imports/>
		<br/>
		<br/>
	</xsl:template>
	<!--
	<xsl:template match="ARTICLE" mode="edit_tag">
	Use: Presentation for the link to edit the taxonomy nodes
	 -->
	<xsl:template match="ARTICLE" mode="edit_tag">
		<xsl:apply-imports/>
		<br/>
		<br/>
	</xsl:template>
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
							ARTICLE Object
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<xsl:template match="ARTICLE" mode="r_articlepage">
		<xsl:apply-templates select="GUIDE/INTRO" mode="c_articlepage"/>
		<xsl:apply-templates select="GUIDE/BODY"/>
		<br/>
		<xsl:apply-templates select=".//FOOTNOTE" mode="c_articlefootnote"/>
		<xsl:apply-templates select="." mode="c_subscribearticleforum"/>
		<xsl:apply-templates select="." mode="c_unsubscribearticleforum"/>
		<xsl:apply-templates select="/H2G2/ARTICLEFORUM/FORUMTHREADS/@FORUMID" mode="t_addthread"/>
		<br/>
	</xsl:template>
	<!--
	<xsl:template match="ARTICLE" mode="r_subscribearticleforum">
	Description: Presentation of the 'subscribe to this article' link
	 -->
	<xsl:template match="ARTICLE" mode="r_subscribearticleforum">
		<xsl:apply-imports/>
		<br/>
	</xsl:template>
	<!--
	<xsl:template match="ARTICLE" mode="r_unsubscribearticleforum">
	Description: Presentation of the 'unsubscribe from this article' link
	 -->
	<xsl:template match="ARTICLE" mode="r_unsubscribearticleforum">
		<xsl:apply-imports/>
		<br/>
	</xsl:template>
	<!--
	<xsl:template match="INTRO" mode="r_articlepage">
	Description: Presentation of article INTRO (not sure where this exists)
	 -->
	<xsl:template match="INTRO" mode="r_articlepage">
		<font xsl:use-attribute-sets="mainfont">
			<b>
				<xsl:apply-templates/>
			</b>
		</font>
		<br/>
	</xsl:template>
	<!--
	<xsl:template match="FOOTNOTE" mode="object_articlefootnote">
	Description: Presentation of the footnote object 
	 -->
	<xsl:template match="FOOTNOTE" mode="object_articlefootnote">
		<xsl:apply-imports/>
		<br/>
		<br/>
	</xsl:template>
	<!--
	<xsl:template match="FOOTNOTE" mode="number_articlefootnote">
	Description: Presentation of the numeral within the footnote object
	 -->
	<xsl:template match="FOOTNOTE" mode="number_articlefootnote">
		<font size="1">
			<sup>
				<xsl:apply-imports/>
			</sup>
		</font>
	</xsl:template>
	<!--
	<xsl:template match="FOOTNOTE" mode="text_articlefootnote">
	Description: Presentation of the text within the footnote object
	 -->
	<xsl:template match="FOOTNOTE" mode="text_articlefootnote">
		<xsl:apply-imports/>
	</xsl:template>
	<xsl:template match="FOOTNOTE">
		<font size="1">
			<sup>
				<xsl:apply-imports/>
			</sup>
		</font>
	</xsl:template>
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
							ARTICLEFORUM Object
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<xsl:template match="ARTICLEFORUM" mode="r_article">
		<xsl:apply-templates select="FORUMTHREADS" mode="c_article"/>
		<xsl:apply-templates select="." mode="c_viewallthreads"/>
		<br/>
		<br/>
	</xsl:template>
	<!--
	<xsl:template match="ARTICLEFORUM" mode="r_viewallthreads">
	Description: Presentation of the 'view all threads related to this conversation' link
	 -->
	<xsl:template match="ARTICLEFORUM" mode="r_viewallthreads">
		<xsl:apply-imports/>
		<br/>
		<br/>
	</xsl:template>
	<!--
	<xsl:template match="FORUMTHREADS" mode="empty_article">
	Description: Presentation of the 'Be the first person to talk about this article' link 
	- ie if there are not threads
	 -->
	<xsl:template match="FORUMTHREADS" mode="empty_article">
		<b>
			<font size="3">
				Discussion
			</font>
		</b>
		<br/>
		<xsl:apply-imports/>
		<br/>
	</xsl:template>
	<!--
	<xsl:template match="FORUMTHREADS" mode="full_article">
	Description: Presentation of the forum threads if some do indeed exist
	 -->
	<xsl:template match="FORUMTHREADS" mode="full_article">
		<b>
			<font size="3">
				Discussion
			</font>
		</b>
		<br/>
		<xsl:value-of select="$m_peopletalking"/>
		<br/>
		<br/>
		<xsl:apply-templates select="THREAD" mode="c_article"/>
		<br/>
		<!-- How to create two columned threadlists: -->
		<!--table cellpadding="0" cellspacing="0" border="0">
			<xsl:for-each select="THREAD[position() mod 2 = 1]">
				<tr>
					<td>
						<font xsl:use-attribute-sets="mainfont" size="1">
							<xsl:apply-templates select="."/>
						</font>
					</td>
					<td>
						<font xsl:use-attribute-sets="mainfont" size="1">
							<xsl:apply-templates select="following-sibling::THREAD[1]"/>
						</font>
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
		<xsl:apply-templates select="@THREADID" mode="t_threadtitlelink"/>
		<br/>
		<font size="1">(<xsl:value-of select="$m_lastposting"/>
			<xsl:apply-templates select="@THREADID" mode="t_threaddatepostedlink"/>)</font>
		<br/>
		<br/>
	</xsl:template>
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
							ARTICLEINFO Object
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<xsl:template match="ARTICLEINFO" mode="r_articlepage">
		<font size="3">
			<b>
				<xsl:copy-of select="$m_entrydata"/>
			</b>
		</font>
		<br/>
		<xsl:copy-of select="$m_idcolon"/> A<xsl:value-of select="H2G2ID"/>
		<br/>
		<xsl:apply-templates select="STATUS/@TYPE" mode="c_articlestatus"/>
		<xsl:apply-templates select="PAGEAUTHOR" mode="c_article"/>
		<xsl:copy-of select="$m_datecolon"/>
		<xsl:apply-templates select="DATECREATED/DATE" mode="short1"/>
		<br/>
		<br/>
		<xsl:apply-templates select="." mode="c_editbutton"/>
		<xsl:apply-templates select="/H2G2/ARTICLE" mode="c_clip"/>
		<xsl:apply-templates select="RELATEDMEMBERS" mode="c_relatedmembersAP"/>
		<!--Editorial Tools-->
		<xsl:apply-templates select="/H2G2/PAGEUI/ENTRY-SUBBED/@VISIBLE" mode="c_returntoeditors"/>
		<xsl:apply-templates select="H2G2ID" mode="c_categoriselink"/>
		<xsl:apply-templates select="H2G2ID" mode="c_recommendentry"/>
		<!-- End of Editorial Tools-->
		<xsl:apply-templates select="SUBMITTABLE" mode="c_submit-to-peer-review"/>
		<xsl:apply-templates select="REFERENCES" mode="c_articlerefs"/>
		<xsl:apply-templates select="H2G2ID" mode="c_removeself"/>
		<br/>
		<br/>
		<font size="1">
			<xsl:copy-of select="$m_complainttext"/>
		</font>
	</xsl:template>
	<!-- 
	<xsl:template match="STATUS/@TYPE" mode="r_articlestatus">
	Use: presentation of an article's status
	-->
	<xsl:template match="STATUS/@TYPE" mode="r_articlestatus">
		<xsl:copy-of select="$m_status"/>
		<xsl:apply-imports/>
		<br/>
	</xsl:template>
	<!-- 
	<xsl:template match="ENTRY-SUBBED/@VISIBLE" mode="r_returntoeditors">
	Use: presentation of a Return to editors link
	-->
	<xsl:template match="ENTRY-SUBBED/@VISIBLE" mode="r_returntoeditors">
		<font size="3">
			<b>Return to editors</b>
		</font>
		<br/>
		<xsl:apply-imports/>
		<br/>
		<br/>
	</xsl:template>
	<!-- 
	<xsl:template match="H2G2ID" mode="r_categoriselink">
	Use: presentation of a 'categorise this article' link
	-->
	<xsl:template match="H2G2ID" mode="r_categoriselink">
		<font size="3">
			<b>Categorise</b>
		</font>
		<br/>
		<xsl:apply-imports/>
		<br/>
		<br/>
	</xsl:template>
	<!-- 
	<xsl:template match="H2G2ID" mode="r_removeself">
	Use: presentation of a 'remove my name from the authors' link
	-->
	<xsl:template match="H2G2ID" mode="r_removeself">
		<font size="3">
			<b>Remove self from list</b>
		</font>
		<br/>
		<xsl:apply-imports/>
		<br/>
		<br/>
	</xsl:template>
	<!-- 
	<xsl:template match="H2G2ID" mode="r_recommendentry">
	Use: presentation of the 'recommend article' link
	-->
	<xsl:template match="H2G2ID" mode="r_recommendentry">
		<font size="3">
			<b>Recommend</b>
		</font>
		<br/>
		<xsl:apply-imports/>
		<br/>
		<br/>
	</xsl:template>
	<!-- 
	<xsl:template match="SUBMITTABLE" mode="r_submit-to-peer-review">
	Use: presentation of position in the peer review process
	-->
	<xsl:template match="SUBMITTABLE" mode="r_submit-to-peer-review">
		<font size="3">
			<b>Review Status</b>
			<br/>
		</font>
		<xsl:apply-imports/>
		<br/>
		<br/>
	</xsl:template>
	<!-- 
	<xsl:template match="ARTICLEINFO" mode="r_editbutton">
	Use: presentation for the 'edit article' of edit link
	-->
	<xsl:template match="ARTICLEINFO" mode="r_editbutton">
		<font size="3">
			<b>Edit</b>
		</font>
		<br/>
		<xsl:apply-imports/>
		<br/>
		<br/>
	</xsl:template>
	<!-- 
	<xsl:template match="ARTICLE" mode="r_clip">
	Use: presentation for the 'add to clippings' link
	-->
	<xsl:template match="ARTICLE" mode="r_clip">
		<font size="3">
			<b>Clippings</b>
		</font>
		<br/>
		<xsl:apply-imports/>
		<br/>
		<br/>
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
		<font size="3">
			<b>Related Articles</b>
		</font>
		<br/>
		<xsl:apply-templates select="ARTICLEMEMBER" mode="c_relatedarticlesAP"/>
		<br/>
		<br/>
	</xsl:template>
	<!-- 
	<xsl:template match="ARTICLEMEMBER" mode="r_relatedarticlesAP">
	Use: presentation of a single related article
	-->
	<xsl:template match="ARTICLEMEMBER" mode="r_relatedarticlesAP">
		<xsl:apply-imports/>
		<br/>
	</xsl:template>
	<!-- 
	<xsl:template match="RELATEDCLUBS" mode="r_relatedclubsAP">
	Use: presentation of the list of related clubs container
	-->
	<xsl:template match="RELATEDCLUBS" mode="r_relatedclubsAP">
		<font size="3">
			<b>Related Clubs</b>
		</font>
		<br/>
		<xsl:apply-templates select="CLUBMEMBER" mode="c_relatedclubsAP"/>
		<br/>
		<br/>
	</xsl:template>
	<!-- 
	<xsl:template match="CLUBMEMBER" mode="r_relatedclubsAP">
	Use: presentation of a single related club
	-->
	<xsl:template match="CLUBMEMBER" mode="r_relatedclubsAP">
		<xsl:apply-imports/>
		<br/>
	</xsl:template>
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
							REFERENCES Object
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<xsl:template match="REFERENCES" mode="r_articlerefs">
		<font size="3">
			<b>References</b>
		</font>
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
		<xsl:value-of select="$m_researchers"/>
		<xsl:apply-templates select="USER" mode="c_researcherlist"/>
	</xsl:template>
	<!-- 
	<xsl:template match="USER" mode="r_researcherlist">
	Use: presentation of each individual user in the RESEARCHERS section
	-->
	<xsl:template match="USER" mode="r_researcherlist">
		<xsl:apply-imports/>
		<br/>
	</xsl:template>
	<!-- 
	<xsl:template match="EDITOR" mode="r_article">
	Use: presentation of the editor of an article
	-->
	<xsl:template match="EDITOR" mode="r_article">
		<xsl:value-of select="$m_editor"/>
		<xsl:apply-templates select="USER" mode="c_articleeditor"/>
	</xsl:template>
	<!-- 
	<xsl:template match="USER" mode="r_articleeditor">
	Use: presentation of each individual user in the EDITOR section
	-->
	<xsl:template match="USER" mode="r_articleeditor">
		<xsl:apply-imports/>
		<br/>
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
	<xsl:template match="EMAIL-SUBSCRIPTION" mode="r_articlepage">
		Subscription status :
		<br/>
		<xsl:apply-templates select="." mode="c_articlesub"/>
		<xsl:apply-templates select="." mode="c_forumsub"/>
	</xsl:template>
	<xsl:template match="EMAIL-SUBSCRIPTION" mode="r_articlesub">
		<xsl:apply-templates select="." mode="c_articlesubstatus"/>
		<xsl:text> :: </xsl:text>
		<xsl:apply-templates select="." mode="t_articlesublink"/>
		<br/>
	</xsl:template>
	<xsl:template match="EMAIL-SUBSCRIPTION" mode="r_forumsub">
		<xsl:apply-templates select="." mode="c_forumsubstatus"/>
		<xsl:text> :: </xsl:text>
		<xsl:apply-templates select="." mode="t_forumsublink"/>
	</xsl:template>
	<xsl:template match="EMAIL-SUBSCRIPTION" mode="on_articlesubstatus">
		Subscribed to Article via <xsl:apply-templates select="." mode="t_articlesubstatus"/>
	</xsl:template>
	<xsl:template match="EMAIL-SUBSCRIPTION" mode="off_articlesubstatus">
		Not Subscribed to Article
	</xsl:template>
	<xsl:template match="EMAIL-SUBSCRIPTION" mode="on_forumsubstatus">
		Subscribed to Forum via <xsl:apply-templates select="." mode="t_forumsubstatus"/>
	</xsl:template>
	<xsl:template match="EMAIL-SUBSCRIPTION" mode="off_forumsubstatus">
		Not Subscribed to Forum
	</xsl:template>
</xsl:stylesheet>
