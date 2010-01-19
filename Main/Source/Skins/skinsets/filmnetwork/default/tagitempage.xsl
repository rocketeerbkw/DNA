<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<xsl:import href="../../../base/base-tagitempage.xsl"/>
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
									Page - Level  template
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->

	<xsl:variable name="passedpagetitle">
		<xsl:choose>
			<xsl:when test="count(/H2G2/PARAMS/PARAM[NAME = 's_title']/VALUE) = 0">
					add / remove confirmation
			</xsl:when>
			<xsl:otherwise>
					<xsl:value-of select="/H2G2/PARAMS/PARAM[NAME = 's_title']/VALUE" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<xsl:variable name="m_tagitembacktouserpage">back to my profile&nbsp;<img src="{$imagesource}furniture/myprofile/arrowdark.gif" width="4" height="7" alt="" /></xsl:variable>
	

	
	<xsl:template name="TAGITEM_MAINBODY">
	<!-- DEBUG -->
		<xsl:call-template name="TRACE">
		<xsl:with-param name="message">TAGITEM_MAINBODY</xsl:with-param>
		<xsl:with-param name="pagename">tagitempage.xsl</xsl:with-param>
		</xsl:call-template>
		<!-- DEBUG -->
	
	
	<xsl:choose>
	<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_view']/VALUE = 'step3'">
	<!-- BAKC UP NEWSLETTER SUBSCRIPTION-->
	<script type="text/javascript">
	<xsl:comment>
	function validate(form)
	{
	var str = form.required_email.value;
	var re = /^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$/;
	
	if (str == ""){
		alert ("Please enter your email address.");
		return false;
		}
		
	if (!str.match(re)) {
		alert("Please check you have typed your email address correctly.");
		return false;
	} 
	
	return true;
	}
	</xsl:comment>
	</script>
		<form METHOD="post" ACTION="http://www.bbc.co.uk/cgi-bin/cgiemail/filmnetwork/newsletter/newsletter.txt" onsubmit="return validate(this)" name="emailform" class="topmargin">
		<INPUT TYPE="hidden" NAME="success" VALUE="{$dna_server}{$root}U{/H2G2/VIEWING-USER/USER/USERID}?s_view=step4"/>
		<INPUT TYPE="hidden" NAME="heading" VALUE="Newsletter"/>
		<INPUT TYPE="hidden" NAME="option" VALUE="subscribe"/>
			
		<!-- test:root -->
		<table width="635" border="0" cellspacing="0" cellpadding="0" class="submistablebg">
        <tr> 
          <td colspan="3" width="635" valign="bottom"><img src="{$imagesource}furniture/submission/submissiontop.gif" width="635" height="57" alt="" class="tiny" /></td>
        </tr>
        <tr> 
          <td width="88" valign="top" class="subleftcolbg"><img src="{$imagesource}furniture/submission/submissiontopleftcorner.gif" width="88" height="29" alt="" /></td>
          <td width="459" valign="top"> 
            <!-- steps -->
            <table border="0" cellspacing="0" cellpadding="0" class="steps4">
              <tr> 
                <td width="49" class="step1of4">step 1</td>
                <td width="67"><img src="{$imagesource}furniture/arrow_4steps.gif" alt="" width="67" height="11" /></td>
                <td width="76" class="step2of4">step 2</td>
                <td width="67"><img src="{$imagesource}furniture/arrow_4steps.gif" alt="" width="67" height="11" /></td>
                <td width="72" class="step3of4 currentStep">step 3</td>
				<td width="67"><img src="{$imagesource}furniture/arrow_4steps.gif" alt="" width="67" height="11" /></td>
                <td width="61" class="step4of4">step 4</td>
              </tr>
            </table>
            
				
		   <h1 class="image"><img src="{$imagesource}furniture/title_my_profile_setup_3.gif" width="459" height="29" alt="my profile setup 3: newsletter" /></h1>
		   <p class="textmedium">Would you like to subscribe to our regular update of new films, news and features? We won't use your address for any other reason or pass on your details. If you prefer, you can <strong><a href="{$root}U{/H2G2/VIEWING-USER/USER/USERID}?s_view=step4">leave this until later</a></strong>.</p>

			<p class="textmedium">To subscribe, enter your address in the box below.</p>
			<input type="text" size="60" name="required_email" value="" class="formInput" />
		   
      	<div class="formBtnLink" id="subscribeBtns">
      		
      		<xsl:variable name="location" select="/H2G2/TAGITEM-PAGE/TAGMULTIPLENODES/NODETAGCOUNTS/NODE[1]/@NAME"/>
      		<xsl:variable name="location_id" select="/H2G2/TAGITEM-PAGE/TAGMULTIPLENODES/NODETAGCOUNTS/NODE[1]/@NODEID"/>
      		<xsl:variable name="specialism1" select="/H2G2/TAGITEM-PAGE/TAGMULTIPLENODES/NODETAGCOUNTS/NODE[2]/@NAME"/>
      		<xsl:variable name="specialism1_id" select="/H2G2/TAGITEM-PAGE/TAGMULTIPLENODES/NODETAGCOUNTS/NODE[2]/@NODEID"/>
      		<xsl:variable name="specialism2" select="/H2G2/TAGITEM-PAGE/TAGMULTIPLENODES/NODETAGCOUNTS/NODE[3]/@NAME"/>
      		<xsl:variable name="specialism2_id" select="/H2G2/TAGITEM-PAGE/TAGMULTIPLENODES/NODETAGCOUNTS/NODE[3]/@NODEID"/>
      		<xsl:variable name="specialism3" select="/H2G2/TAGITEM-PAGE/TAGMULTIPLENODES/NODETAGCOUNTS/NODE[4]/@NAME"/>
      		<xsl:variable name="specialism3_id" select="/H2G2/TAGITEM-PAGE/TAGMULTIPLENODES/NODETAGCOUNTS/NODE[4]/@NODEID"/>
      		
      		<a href="{$root}U{/H2G2/VIEWING-USER/USER/USERID}?s_view=step4&amp;s_location={$location}&amp;s_location_id={$location_id}&amp;s_specialism1={$specialism1}&amp;s_specialism1_id={$specialism1_id}&amp;s_specialism2={$specialism2}&amp;s_specialism2_id={$specialism2_id}&amp;s_specialism3={$specialism3}&amp;s_specialism3_id={$specialism3_id}">
			<img src="{$imagesource}furniture/btnlink_dont_subscribe.gif" width="249" height="22" alt="don't subscribe" />
		</a> 
      		<input type="image" src="{$imagesource}furniture/btnlink_subscribe.gif" width="167" height="22" name="name" alt="subscribe" class="secondBtn" />
	</div>
		</td>
          <td width="88" valign="top"  class="subrightcolbg"><img src="/f/t.gif" class="tiny" width="88" height="30" alt="" /></td>
        </tr>
        <tr> 
          <td height="10" class="subrowbotbg"></td>
          <td class="subrowbotbg"></td>
          <td class="subrowbotbg"></td>
        </tr>
      </table>
	</form>

	</xsl:when>
	<xsl:otherwise>
			
<table border="0" cellspacing="0" cellpadding="0" width="635">
        <tr> 
          <td height="10">
		  <!-- crumb menu -->
		  <div class="crumbtop"><span class="textxlarge"><!-- <xsl:choose>
					<xsl:when test="string-length(/H2G2/SEARCH/SEARCHRESULTS/SAFESEARCHTERM) &gt; 0"> -->
						<xsl:value-of select="$passedpagetitle" />
					<!-- </xsl:when>
					<xsl:otherwise>
						search page
					</xsl:otherwise>
				</xsl:choose> --></span></div>
		  <!-- END crumb menu --></td>
        </tr>
      </table>
		
		<!-- head section -->
	<table width="635" border="0" cellspacing="0" cellpadding="0">
		  <!-- Spacer row -->
          <tr>
            <td><img src="/f/t.gif" width="371" height="1" class="tiny" alt="" /></td>
            <td><img src="/f/t.gif" width="20" height="1" class="tiny" alt="" /></td>
            <td><img src="/f/t.gif" width="244" height="1" class="tiny" alt="" /></td>
          </tr>
		  <tr>
            <td valign="top"  width="371">
			
			<table width="371" cellpadding="0" cellspacing="0" border="0">
			
				<tr>
					<td valign="top" class="topbg" height="69">
					<img src="/f/t.gif" width="1" height="10" alt="" />
					
						<div class="biogname"><strong><xsl:value-of select="$passedpagetitle" /><br /></strong></div>
						<img src="/f/t.gif" width="1" height="5" alt="" />
					 <div class="topboxcopy">You're currently included in these categories. <br />Click 'remove' to remove yourself from one.</div></td>
				</tr>
				<!-- <tr>
		          <td valign="top" height="20" class="topbg"></td>
				</tr> -->
			</table>
			</td>
          	<td valign="top" width="20" class="topbg"></td>
            <td valign="top" class="topbg">
			</td>
          </tr>
		  <tr>
          <td width="635" valign="top" colspan="3"><img src="{$imagesource}furniture/writemessage/topboxangle.gif" width="635" height="27" /></td>
		  </tr>
        </table>
	<!-- spacer -->
	<table width="635" border="0" cellspacing="0" cellpadding="0">
	  <tr>
		<td height="10"></td>
	  </tr>
	</table>
	<!-- end spacer -->

		<!-- END head section -->		
<table width="635" border="0" cellspacing="0" cellpadding="0">
		  <!-- Spacer row -->
          <tr>
            <td><img src="/f/t.gif" width="371" height="1" class="tiny" alt="" /></td>
            <td><img src="/f/t.gif" width="20" height="1" class="tiny" alt="" /></td>
            <td><img src="/f/t.gif" width="244" height="1" class="tiny" alt="" /></td>
          </tr>
		  <tr>
            <td height="371" valign="top">
<!-- LEFT COL MAIN CONTENT -->
			<table width="371" border="0" cellspacing="0" cellpadding="0">
			<tr><td width="20"></td><td>
			<div class="textmedium">
			<b><xsl:apply-templates select="TAGITEM-PAGE/ACTION" mode="c_actionresult"/></b><br /><br />

			<xsl:apply-templates select="TAGITEM-PAGE/TAGGEDNODES" mode="c_tagitem"/>
			<xsl:call-template name="c_addtonode">
				<!-- Can spcify a startnode parameter if you don't want the tagging to start from C1  -->
			</xsl:call-template>
			<strong><xsl:apply-templates select="TAGITEM-PAGE/ITEM" mode="t_backtoobject"/></strong>
			<xsl:apply-templates select="TAGITEM-PAGE/ERROR" mode="c_tagitem"/>
			</div>
			</td></tr></table>


			</td>
            <td><!-- 20px spacer column --></td>
            
          <td valign="top"> 
			<!-- hints and tips -->
			<!-- top with angle -->

						<!-- END hint paragraphs -->
			

          </td>
          </tr>
        </table>
			
			
	</xsl:otherwise>
</xsl:choose>


	
	

	</xsl:template>
	<!--
	<xsl:template name="r_addtonode">
	Use: Presentation of the 'add to the taxonomy' link
	 -->
	<xsl:template name="r_addtonode">
		<xsl:param name="addnodelink"/>
		<xsl:copy-of select="$addnodelink"/>
		<br/>
	</xsl:template>

	<!--
	<xsl:template match="TAGGEDNODES" mode="full_tagitem">
	Use: Template invoked if there are one or more existing taggings
	 -->
	<xsl:template match="TAGGEDNODES" mode="full_tagitem">
		<xsl:apply-templates select="NODE" mode="c_tagitem"/>
		<br/>
	</xsl:template>
	<!--
	<xsl:template match="TAGGEDNODES" mode="empty_tagitem">
	Use: Template invoked if there are no existing tagging
	 -->
	<xsl:template match="TAGGEDNODES" mode="empty_tagitem">
		<xsl:apply-imports/>
		<br/>
		<br/>
	</xsl:template>
	<!--
	<xsl:template match="NODE" mode="r_tagitem">
	Use: Presentation of an individual node in the list of tags
	 -->
	<xsl:template match="NODE" mode="r_tagitem">
	<xsl:if test="$test_IsEditor">
			<xsl:apply-templates select="ANCESTRY" mode="c_tagitem"/>
		</xsl:if>
		<b><xsl:apply-templates select="." mode="t_taggednodename"/></b>&nbsp;-&nbsp;
		<xsl:text> </xsl:text>
			<xsl:apply-templates select="." mode="t_removetag"/>
			<xsl:text> </xsl:text>
			<xsl:if test="$test_IsEditor"><xsl:apply-templates select="." mode="t_movetag"/></xsl:if>
		<br/>
	</xsl:template>
	<!--
	<xsl:template match="ANCESTRY" mode="r_tagitem">
	Use: Presentation of each NODE's crumbtrail
	 -->
	<xsl:template match="ANCESTRY" mode="r_tagitem">
		<xsl:apply-templates select="ANCESTOR" mode="c_tagitem"/>
	</xsl:template>
	<!--
	<xsl:template match="ANCESTOR" mode="r_tagitem">
	Use: Presentation of each crumbtrail's node in the taxonomy
	 -->
	<xsl:template match="ANCESTOR" mode="r_tagitem">
		<xsl:apply-imports/>
		<xsl:text> / </xsl:text>
	</xsl:template>
	<!--
	<xsl:template match="ERROR" mode="r_tagitem">
	Use: Presentation of the error message
	 -->
	<xsl:template match="ERROR" mode="r_tagitem">
		<xsl:apply-imports/>
	</xsl:template>
	<!--
	<xsl:template match="ACTION" mode="added_actionresult">
	Use: 
	 -->
	<xsl:template match="ACTION" mode="added_actionresult">
		<xsl:apply-templates select="." mode="t_activeobject"/>
		<xsl:text> has successfully been added to </xsl:text>
		<xsl:apply-templates select="." mode="t_activenode"/>
		<br/>
	</xsl:template>

	<xsl:template match="ACTION" mode="notadded_actionresult">
		<xsl:apply-templates select="." mode="t_activeobject"/>
		<xsl:text> could not be added to </xsl:text>
		<xsl:apply-templates select="." mode="t_activenode"/>
	</xsl:template>
	<xsl:template match="ACTION" mode="removed_actionresult">
		<xsl:apply-templates select="." mode="t_activeobject"/>
		<xsl:text> has successfully been removed from </xsl:text>
		<xsl:apply-templates select="." mode="t_activenode"/>
	</xsl:template>
	<xsl:template match="ACTION" mode="notremoved_actionresult">
		<xsl:apply-templates select="." mode="t_activeobject"/>
		<xsl:text> could not be removed from </xsl:text>
		<xsl:apply-templates select="." mode="t_activenode"/>
	</xsl:template>
	<xsl:template match="ACTION" mode="moved_actionresult">
		<xsl:apply-templates select="." mode="t_activeobject"/>
		<xsl:text> has successfully been moved from </xsl:text>
		<xsl:apply-templates select="." mode="t_nodefrom"/>
		<xsl:text> to </xsl:text>
		<xsl:apply-templates select="." mode="t_nodeto"/>
	</xsl:template>
	<xsl:template match="ACTION" mode="notmoved_actionresult">
	
	</xsl:template>
</xsl:stylesheet>
