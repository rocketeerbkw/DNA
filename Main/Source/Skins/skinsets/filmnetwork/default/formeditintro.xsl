<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">

<xsl:template name="EDIT_INTRO">
	<!-- DEBUG -->
	<xsl:call-template name="TRACE">
		<xsl:with-param name="message">EDIT_INTRO</xsl:with-param>
		<xsl:with-param name="pagename">formeditintro.xsl</xsl:with-param>
	</xsl:call-template>
	<!-- DEBUG -->
	<input type="hidden" name="_msfinish" value="yes"/>
	<input type="hidden" name="_msxml" value="{$userintrofields}"/>
	<input type="hidden" name="type" value="3001"/>
	
	<!-- hidden fields to get number of films, location and specialism into the EXTRAINFO tags -->
	<input type="hidden" name="NUMBEROFAPPROVEDFILMS" value="{/H2G2/PARAMS/PARAM[NAME= 's_films']/VALUE}"/>
	<input type="hidden" name="LOCATION" value="{/H2G2/PARAMS/PARAM[NAME= 's_location']/VALUE}"/>
	<input type="hidden" name="LOCATION_ID" value="{/H2G2/PARAMS/PARAM[NAME= 's_location_id']/VALUE}"/>
	<input type="hidden" name="SPECIALISM1" value="{/H2G2/PARAMS/PARAM[NAME= 's_specialism1']/VALUE}"/>
	<input type="hidden" name="SPECIALISM1_ID" value="{/H2G2/PARAMS/PARAM[NAME= 's_specialism1_id']/VALUE}"/>
	<input type="hidden" name="SPECIALISM2" value="{/H2G2/PARAMS/PARAM[NAME= 's_specialism2']/VALUE}"/>
	<input type="hidden" name="SPECIALISM2_ID" value="{/H2G2/PARAMS/PARAM[NAME= 's_specialism2_id']/VALUE}"/>
	<input type="hidden" name="SPECIALISM3" value="{/H2G2/PARAMS/PARAM[NAME= 's_specialism3']/VALUE}"/>
	<input type="hidden" name="SPECIALISM3_ID" value="{/H2G2/PARAMS/PARAM[NAME= 's_specialism3_id']/VALUE}"/>
	
	
	<xsl:if test="MULTI-ELEMENT[@NAME='PUBLISH_INDUSTRY_IMG']/VALUE-EDITABLE='on'">
	<input type="hidden" name="PUBLISH_INDUSTRY_IMG" value="on"/>
	</xsl:if>
	
	

	<input type="hidden" name="TITLE">
		<xsl:attribute name="value">
		<xsl:choose>
			<xsl:when test="concat(/H2G2/ARTICLE/ARTICLEINFO/PAGEAUTHOR/EDITOR/USER/FIRSTNAMES, /H2G2/ARTICLE/ARTICLEINFO/PAGEAUTHOR/EDITOR/USER/LASTNAME) != ''">
				<xsl:value-of select="/H2G2/ARTICLE/ARTICLEINFO/PAGEAUTHOR/EDITOR/USER/FIRSTNAMES" />
				<xsl:text> </xsl:text>
				<xsl:value-of select="/H2G2/ARTICLE/ARTICLEINFO/PAGEAUTHOR/EDITOR/USER/LASTNAME" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="/H2G2/ARTICLE/ARTICLEINFO/PAGEAUTHOR/EDITOR/USER/USERNAME" /> 
			</xsl:otherwise>
		</xsl:choose>
		</xsl:attribute>
	</input>
	
	<table width="635" border="0" cellspacing="0" cellpadding="0" class="submistablebg topmargin editbiog">
        <tr> 
          <td colspan="3" width="635" valign="bottom"><img src="{$imagesource}furniture/submission/submissiontop.gif" width="635" height="57" alt="" class="tiny" /></td>
        </tr>
        <tr> 
          <td width="88" valign="top" class="subleftcolbg"><img src="{$imagesource}furniture/submission/submissiontopleftcorner.gif" width="88" height="29" alt="" /></td>
          <td width="459" valign="top"> 
            
			<!-- steps -->
            <xsl:choose>
				<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_view']/VALUE = 'step1'">
					<table border="0" cellspacing="0" cellpadding="0" class="steps4">
		              <tr> 
		                <td width="49" class="step1of4 currentStep">step 1</td>
		                <td width="67"><img src="{$imagesource}furniture/arrow_4steps.gif" alt="" width="67" height="11" /></td>
		                <td width="76" class="step2of4">step 2</td>
		                <td width="67"><img src="{$imagesource}furniture/arrow_4steps.gif" alt="" width="67" height="11" /></td>
		                <td width="72" class="step3of4">step 3</td>
						<td width="67"><img src="{$imagesource}furniture/arrow_4steps.gif" alt="" width="67" height="11" /></td>
		                <td width="61" class="step4of4">step 4</td>
		              </tr>
		            </table>
					<!-- submit s_view=step2 so that 'add place and specialism' can be displayed on userpage -->
					<input type="hidden" name="s_view" value="step2"/>	
				</xsl:when>
				<xsl:otherwise>
					<table border="0" cellspacing="0" cellpadding="0" class="steps4">
		              <tr> 
		                <td class="currentStep">&nbsp;</td>
		              </tr>
		            </table>
				</xsl:otherwise>
			</xsl:choose>
			
			<!-- heading -->
			<xsl:choose>
				<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_view']/VALUE = 'step1'">
					<h1 class="image"><img src="{$imagesource}furniture/title_my_profile_setup1.gif" width="459" height="29" alt="my profile setup 1: add biog" /></h1>
					<p class="textmedium">You can add the following information to your profile page. Complete or leave out whatever you like, it's all optional except for the biog. If you prefer, you can <strong><a href="{root}/dna/filmnetwork/U{/H2G2/VIEWING-USER/USER/USERID}?s_fromedit=1&amp;s_typedarticle=edit&amp;s_view=step2">leave this until later</a></strong></p>
				</xsl:when>
				<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_standard']/VALUE = '1'">
					<h1 class="image"><img src="{$imagesource}furniture/title_edit_introduction.gif" width="459" height="29" alt="Edit Introduction" /></h1>
					
				</xsl:when>
				<xsl:otherwise>
					<h1 class="image"><img src="{$imagesource}furniture/title_edit_biog.gif" width="459" height="29" alt="Edit Biog" /></h1>
					<xsl:choose>
						<xsl:when test="/H2G2/VIEWING-USER/USER/GROUPS/ADVISER">
							<p class="textmedium">You can use this page to tell Film Network users a bit about yourself and any organisation you represent. You can also add a link to your website. If you would like to include an image please email <a href="mailto:filmnetwork@bbc.co.uk">filmnetwork@bbc.co.uk</a></p>
						</xsl:when>	
						<xsl:otherwise>
							<p class="textmedium">You can add the following information to your profile page. Complete or leave out whatever you like, it's all optional except for the biog.</p>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
			
			<!-- main body - subheadings, text and form inputs-->
			<xsl:choose>
				<!-- if standard user, then only show introduction textbox -->
				<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_standard']/VALUE = '1'">
					
					<!-- ############## INTRODUCTION ############### -->
					<p class="textmedium">You can tell other users more about yourself by filling out the box below. You could try listing your favourite films. If you would like to add a filmmaking biography allowing you to list past projects then <a href="/dna/filmnetwork/UserDetails?s_upgradeuser=1" class="bold">add biog, credits and specialism</a>.</p>
			  		
					<xsl:apply-templates select="MULTI-REQUIRED[@NAME='BODY']" mode="c_errorbiog"/>
					<xsl:apply-templates select="." mode="t_articlebody1"/>
					
				</xsl:when>
				<!-- filmmakers and industry professionals-->
				<xsl:otherwise>
					
					<h2 class="image top bottom"><img src="{$imagesource}furniture/title_my_profile_page.gif" width="113" height="17" alt="my profile page" /></h2>
			
					<!-- ############## BIOG ############### -->
					<!-- title text area underline combo -->
					
					<div id="biogInputs">
					<div id="biog">
					<h3>biog</h3>
					<p class="textmedium">This is your chance to tell other users a bit about yourself  - who you are, what you do and your background in film.<br />
				  	<strong>(you need to fill this in)</strong></p></div>
					
					<xsl:apply-templates select="MULTI-REQUIRED[@NAME='BODY']" mode="c_errorbiog"/>
					<xsl:apply-templates select="." mode="t_articlebody1"/>
					  
					  
					<!-- ############## ORG INFO ############### -->
					<xsl:if test="/H2G2/VIEWING-USER/USER/GROUPS/ADVISER">
					
						<div class="hr"></div>
			   			<h3>organisation information</h3>
						<p class="textmedium">Please use this area to tell film Network users a bit about who you are, what you do and why you are a member of our industry panel.<br />
						<strong>(optional)</strong></p>
						<textarea name="ORGINFO" rows="5" cols="55" class="formTextarea">
							<xsl:value-of select="MULTI-ELEMENT[@NAME='ORGINFO']/VALUE-EDITABLE"/>
						</textarea>
					 </xsl:if>
			
					<!-- ############## AMBITIONS ############### -->
					<xsl:if test="not(/H2G2/VIEWING-USER/USER/GROUPS/ADVISER)">
					
						<div class="hr"></div>
						<h3>ambitions</h3>
						<p class="textmedium">Other members might like to know what you want to do.<br />
						For example, do you want to make shorts or do you have a feature up your sleave? <strong>(optional)</strong></p>
						<textarea name="TBC" rows="5"  class="formTextarea">
						<xsl:value-of select="MULTI-ELEMENT[@NAME='TBC']/VALUE-EDITABLE"/>
						</textarea>
					  
					</xsl:if>
			
					<!-- ############## PROJECT DEVELOPMENT ############### -->
					<xsl:if test="not(/H2G2/VIEWING-USER/USER/GROUPS/ADVISER)">
						
						<div class="hr"></div>
						<h3>project development</h3>
						<p class="textmedium">If you're currently working on something you might want to tell other members about it <strong>(optional)</strong></p>
						<textarea name="PROJECTINDEVELOPMENT" rows="5" class="formTextarea">
						<xsl:value-of select="MULTI-ELEMENT[@NAME='PROJECTINDEVELOPMENT']/VALUE-EDITABLE"/>
						</textarea>
					
					</xsl:if>
			
					<!-- ############## FAVOURITE FILMS ############### -->
					<div class="hr"></div>
					<h3>influences, inspirations and favourite films</h3>
					<p class="textmedium">Which films do you love? Who and what inspires you?<br />
					<strong>(optional)</strong></p>
					<textarea name="FAVFILMS" rows="5" class="formTextarea">
					<xsl:value-of select="MULTI-ELEMENT[@NAME='FAVFILMS']/VALUE-EDITABLE"/>
					</textarea>
					
					<!-- ############## LINKS ############### -->			    
					<div class="hr"></div>
		   			<h3>links</h3>
		   			<p class="textmedium">If you have your own website or a profile page on another website (Shooting People, Talent Circle, Trigger Street etc.) you can add a link to it here. <strong>(optional)</strong></p>
					
					<div id="biogLinks">
					<label for="MYLINKS1_TEXT" class="formLabel">page title:</label><br />
		   			<input type="text" name="MYLINKS1_TEXT" id="MYLINKS1_TEXT" class="formInput">
						<xsl:attribute name="value">
						<xsl:value-of select="MULTI-ELEMENT[@NAME='MYLINKS1_TEXT']/VALUE-EDITABLE"/>
						</xsl:attribute>
					</input><br />
					
					<label for="MYLINKS1" class="formLabel">address (url):</label><br />
		  			<input type="text" name="MYLINKS1" id="MYLINKS1" class="formInput">
						<xsl:attribute name="value">
						<xsl:value-of select="MULTI-ELEMENT[@NAME='MYLINKS1']/VALUE-EDITABLE"/>
						</xsl:attribute>
					</input><br />
					
					<label for="MYLINKS2_TEXT" class="formLabel">page title:</label><br />
		   			<input type="text" name="MYLINKS2_TEXT" id="MYLINKS2_TEXT" class="formInput">
						<xsl:attribute name="value">
						<xsl:value-of select="MULTI-ELEMENT[@NAME='MYLINKS2_TEXT']/VALUE-EDITABLE"/>
						</xsl:attribute>
					</input><br />
					
					<label for="MYLINKS2" class="formLabel">address (url):</label><br />
		  			<input type="text" name="MYLINKS2" id="MYLINKS2" class="formInput">
						<xsl:attribute name="value">
						<xsl:value-of select="MULTI-ELEMENT[@NAME='MYLINKS2']/VALUE-EDITABLE"/>
						</xsl:attribute>
					</input><br />
					
					<label for="MYLINKS3_TEXT" class="formLabel">page title:</label><br />
		   			<input type="text" name="MYLINKS3_TEXT" id="MYLINKS3_TEXT" class="formInput">
						<xsl:attribute name="value">
						<xsl:value-of select="MULTI-ELEMENT[@NAME='MYLINKS3_TEXT']/VALUE-EDITABLE"/>
						</xsl:attribute>
					</input><br />
					
					<label for="MYLINKS3" class="formLabel">address (url):</label><br />
		  			<input type="text" name="MYLINKS3" id="MYLINKS3" class="formInput">
						<xsl:attribute name="value">
						<xsl:value-of select="MULTI-ELEMENT[@NAME='MYLINKS3']/VALUE-EDITABLE"/>
						</xsl:attribute>
					</input><br />
					</div>
					
					</div>
			</xsl:otherwise>
			</xsl:choose>
			
      	<div class="pleaseNote">
			<p><span class="pleaseNoteTitle">Please Note</span><br />
			Be careful about posting your email address as you may receive unwanted messages.</p>
		</div>
		
		<div class="formBtnLink">			
<script language="JavaScript" type="text/javascript">
function validateForm()
{
	if(document.typedarticle.body.value=="")
	{
		alert('You need to put something in the biog box. It can be very short...');
		document.getElementById("biog").style.color='#FF0000';
		document.location="#";
		document.typedarticle.body.focus();
		return false;
	}
	else {
		return true;
	}
}
// end hiding -->
</script>
			<input type="image" src="{$imagesource}furniture/next1.gif" width="90" height="22" name="aupdate" alt="next" xsl:use-attribute-sets="mMULTI-STAGE_r_articleeditbutton" onclick="return validateForm()"/>
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
</xsl:template>


<xsl:template match="MULTI-STAGE" mode="t_articlebody1">
		<textarea class="formTextarea" name="body" rows="7">
			<xsl:value-of select="MULTI-REQUIRED[@NAME='BODY']/VALUE-EDITABLE"/>
		</textarea>
</xsl:template>
	
</xsl:stylesheet>
