<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">


<!-- article type chooser for non-javascript user -->
<xsl:template name="CHOOSE_ARTICLE_TYPE_SCREEN">
	<div class="mainbodysec">
		<div class="formsec">
			<div class="formbox">
			<h2 class="sportStep1">What are you going to write?</h2>
			<table cellpadding="0" cellspacing="0" border="0">
			<tr>
			<td width="47" valign="top" align="center">
				<img height="28" hspace="0" vspace="0" border="0" width="28" alt="1" src="{$imagesource}1.gif" />
			</td>
			<td width="381">
				<div class="noscript1">
					<ul>
						<xsl:choose>
							<xsl:when test="$test_IsEditor">
								<li><div class="noscriptbox"><a href="{$root}TypedArticle?acreate=new&amp;type=15">Article</a></div></li>
							</xsl:when>
							<xsl:otherwise>
								<li><div class="noscriptbox"><a href="{$root}TypedArticle?acreate=new&amp;type=10">Article</a></div></li>
							</xsl:otherwise>
						</xsl:choose>
						<li><div class="noscriptbox"><a href="{$root}TypedArticle?acreate=new&amp;type=11">Match article</a></div></li>
						<li><div class="noscriptbox"><a href="{$root}TypedArticle?acreate=new&amp;type=12">Event article</a></div></li>
						<li><div class="noscriptbox"><a href="{$root}TypedArticle?acreate=new&amp;type=13">Player profile</a></div></li>
						<li><div class="noscriptbox"><a href="{$root}TypedArticle?acreate=new&amp;type=14">Team profile</a></div></li>
					</ul>
				</div>
			</td>
			</tr>
			</table>
			</div>
			<br/>
		</div>
	</div>
</xsl:template>


<!-- form used for create/edit profile:  TYPE = 3001 -->
<xsl:template name="PROFILE_FORM">
	<!-- DEBUG -->
	<xsl:call-template name="TRACE">
	<xsl:with-param name="message">PROFILE_FORM</xsl:with-param>
	<xsl:with-param name="pagename">typedarticlepage_templates.xsl</xsl:with-param>
	</xsl:call-template>
	<!-- DEBUG -->
	<input type="hidden" name="_msxml" value="{$user_intro_fields}"/>
	<input type="hidden" name="type" value="3001"/>
	<input type="hidden" name="TITLE">
	<xsl:attribute name="value">
		<xsl:value-of select="/H2G2/ARTICLE/ARTICLEINFO/PAGEAUTHOR/EDITOR/USER/USERNAME" /> 
	</xsl:attribute>
	</input>
	<input type="hidden" name="TYPEOFARTICLE" value="member"/>
	<xsl:if test="/H2G2/PARAMS/PARAM[NAME = 's_display']/VALUE = 'register' or /H2G2/PARAMS/PARAM[NAME = 's_display']/VALUE = 'register2'">
	<input type="hidden" name="s_display" value="register2"/>
	</xsl:if>
	

<div class="mainbodysec">
		
	<!-- form -->
	<div class="bodysec">
	<div class="formbox">
        	<div class="requiredKeyBlock"><span class="required">*</span> compulsory fields</div>

		<table cellpadding="0" cellspacing="0" border="0" class="clear">
		<!-- step 1 -->
		<tr>
		<td width="35" valign="top">		
		<img height="28" hspace="0" vspace="0" border="0" width="28" alt="one" src="{$imagesource}1.gif" />
		</td>
		<td width="381">
		<div class="frow">
			<xsl:if test="MULTI-ELEMENT[@NAME='SPORTINGINTEREST1']/ERRORS/ERROR/@TYPE='VALIDATION-ERROR-EMPTY'">	
				<div class="errortext"><strong class="alert">Please enter a team sported or sporting intrerest</strong></div>
			</xsl:if>
			<div class="labelone">
			<xsl:if test="MULTI-ELEMENT[@NAME='SPORTINGINTEREST1']/ERRORS/ERROR/@TYPE='VALIDATION-ERROR-EMPTY'">
				<xsl:attribute name="class">labelone alert</xsl:attribute>
			</xsl:if>
			teams supported / sporting interests<span class="required">*</span><br /><span class="opt2">(max 3)</span></div>
			
			<div class="formstack">
				<div>
				<xsl:if test="MULTI-ELEMENT[@NAME='SPORTINGINTEREST1']/ERRORS/ERROR/@TYPE='VALIDATION-ERROR-EMPTY'">
					<xsl:attribute name="class">alert</xsl:attribute>
				</xsl:if>
				<input type="text" name="SPORTINGINTEREST1" class="inputone"  maxlength="{$maxcharacters_textinput_value}">
					<xsl:attribute name="value">
						<xsl:value-of select="MULTI-ELEMENT[@NAME='SPORTINGINTEREST1']/VALUE-EDITABLE"/>
					</xsl:attribute>
				</input>
				<xsl:if test="MULTI-ELEMENT[@NAME='SPORTINGINTEREST1']/ERRORS/ERROR/@TYPE='VALIDATION-ERROR-EMPTY'">
					<xsl:attribute name="class">labelone alert</xsl:attribute>
				</xsl:if>
				</div>						
				<xsl:call-template name="maxcharacters_textinput_text2" />	
			
				<input type="text" name="SPORTINGINTEREST2" class="inputone"  maxlength="{$maxcharacters_textinput_value}">
					<xsl:attribute name="value">
						<xsl:value-of select="MULTI-ELEMENT[@NAME='SPORTINGINTEREST2']/VALUE-EDITABLE"/>
					</xsl:attribute>
				</input>
				<xsl:call-template name="maxcharacters_textinput_text2" />
											
		
				<input type="text" name="SPORTINGINTEREST3" class="inputone"  maxlength="{$maxcharacters_textinput_value}">
					<xsl:attribute name="value">
						<xsl:value-of select="MULTI-ELEMENT[@NAME='SPORTINGINTEREST3']/VALUE-EDITABLE"/>
					</xsl:attribute>
				</input>
				<xsl:call-template name="maxcharacters_textinput_text2" />
			
			</div>	
		</div>				
		</td>
		</tr>
		<!-- step 2 -->
		<tr>
		<td valign="top">		
		<img height="28" hspace="0" vspace="0" border="0" width="28" alt="two" src="{$imagesource}2.gif" />
		</td>
		<td>
		<div class="frow">
			<xsl:if test="MULTI-ELEMENT[@NAME='FAVOURITEPLAYER']/ERRORS/ERROR/@TYPE='VALIDATION-ERROR-EMPTY'">
				<xsl:attribute name="class">frow alert</xsl:attribute>
				<div class="errortext"><strong>Please enter a favourite player</strong></div>
			</xsl:if>
			<div class="labelone"><label for="favourite">favourite player<span class="required">*</span></label></div>
			<input type="text" name="FAVOURITEPLAYER" id="favourite" class="inputone" maxlength="{$maxcharacters_textinput_value}">
				<xsl:attribute name="value">
					<xsl:value-of select="MULTI-ELEMENT[@NAME='FAVOURITEPLAYER']/VALUE-EDITABLE"/>
				</xsl:attribute>
			</input>
			<xsl:call-template name="maxcharacters_textinput_text" />
		</div>		
		</td>
		</tr>
		<!-- step 3-->
		<tr>
		<td valign="top">		
		<img height="28" hspace="0" vspace="0" border="0" width="28" alt="three" src="{$imagesource}3.gif" />
		</td>
		<td>
		<div class="frow">
			<div class="labelone"><label for="team">team you play in</label></div>
			<input type="text" name="TEAMPLAYEDIN" id="team" class="inputone"  maxlength="{$maxcharacters_textinput_value}">
				<xsl:attribute name="value">
					<xsl:value-of select="MULTI-ELEMENT[@NAME='TEAMPLAYEDIN']/VALUE-EDITABLE"/>
				</xsl:attribute>
			</input>
			<xsl:call-template name="maxcharacters_textinput_text" />
		</div>								
		
		<div class="frow">					
			<div class="labelone"><label for="teamlink">suggest a link for your team</label></div>
			<input type="text" name="TEAMPLAYEDINLINK" id="teamlink" class="inputone">
				<xsl:attribute name="value">
					<xsl:value-of select="MULTI-ELEMENT[@NAME='TEAMPLAYEDINLINK']/VALUE-EDITABLE"/>
				</xsl:attribute>
			</input>
			<div class="inputinfo">eg: http://www.nameofyourteam.com</div>
		</div>		
							
		</td>
		</tr>
		<!-- step 4 -->
		<tr>
		<td valign="top">		
		<img height="28" hspace="0" vspace="0" border="0" width="28" alt="four" src="{$imagesource}4.gif" />
		</td>
		<td>
		<div class="frow">
			<div>
			<xsl:if test="MULTI-ELEMENT[@NAME='FAVOURITEMATCH']/ERRORS/ERROR/@TYPE='VALIDATION-ERROR-EMPTY'">
				<xsl:attribute name="class">alert</xsl:attribute>
				<div class="errortext"><strong>Please enter a favourite match</strong></div>
			</xsl:if>
			<div class="labelone"><label for="favouritematch">favourite match<span class="required">*</span></label></div>
			<input type="text" name="FAVOURITEMATCH" id="favouritematch" class="inputone"  maxlength="{$maxcharacters_textinput_value}">
				<xsl:attribute name="value">
					<xsl:value-of select="MULTI-ELEMENT[@NAME='FAVOURITEMATCH']/VALUE-EDITABLE"/>
				</xsl:attribute>
			</input>
			<xsl:call-template name="maxcharacters_textinput_text" />
			</div>
					
			<div class="labelone"><label for="matchlink">suggest a link for this match</label></div>
			<input type="text" name="FAVOURITEMATCHLINK" id="matchlink"  class="inputone">
				<xsl:attribute name="value">
					<xsl:value-of select="MULTI-ELEMENT[@NAME='FAVOURITEMATCHLINK']/VALUE-EDITABLE"/>
				</xsl:attribute>
			</input>
			<div class="inputinfo">eg: http://news.bbc.co.uk/sport1/hi/football/ fa_cup/4907012.stm</div>
		</div>						
		</td>
		</tr>
		<!-- step 5 -->
		<tr>
		<td valign="top">		
		<img height="28" hspace="0" vspace="0" border="0" width="28" alt="five" src="{$imagesource}5.gif" />
		</td>
		<td>
		<div class="frow">					
			<div class="labelone"><label for="extlinkone">my link 1</label></div>
			<div class="formstack">
				<input type="text" name="EXTERNALLINK1" id="extlinkone" class="inputone">
				<xsl:attribute name="value">
					<xsl:value-of select="MULTI-ELEMENT[@NAME='EXTERNALLINK1']/VALUE-EDITABLE"/>
				</xsl:attribute>
			</input>
			</div>					
		</div>
		<div class="frow">	
			<div class="labelone"><label for="titleone">link title</label></div>
			<div class="formstack">
				<input type="text" name="EXTERNALLINK1TITLE" id="titleone" class="inputone">
				<xsl:attribute name="value">
					<xsl:value-of select="MULTI-ELEMENT[@NAME='EXTERNALLINK1TITLE']/VALUE-EDITABLE"/>
				</xsl:attribute>
			</input>
			</div>
		</div>
		<div class="clear"></div><hr class="formhr" />
		<div class="frow">	
			<div class="labelone"><label for="extlinktwo">my link 2</label></div>
			<div class="formstack">
				<input type="text" name="EXTERNALLINK2" id="extlinktwo" class="inputone">
				<xsl:attribute name="value">
					<xsl:value-of select="MULTI-ELEMENT[@NAME='EXTERNALLINK2']/VALUE-EDITABLE"/>
				</xsl:attribute>
			</input>
			</div>
		</div>
		<div class="frow">	
			<div class="labelone"><label for="titletwo">link title</label></div>					
			<div class="formstack">
				<input type="text" name="EXTERNALLINK2TITLE" id="titletwo" class="inputone">
				<xsl:attribute name="value">
					<xsl:value-of select="MULTI-ELEMENT[@NAME='EXTERNALLINK2TITLE']/VALUE-EDITABLE"/>
				</xsl:attribute>
			</input>
			</div>
		</div>
		<div class="clear"></div><hr class="formhr" />
		<div class="frow">	
			<div class="labelone"><label for="extlinkthree">my link 3</label></div>					
			<div class="formstack">
				<input type="text" name="EXTERNALLINK3" id="extlinkthree" class="inputone">
				<xsl:attribute name="value">
					<xsl:value-of select="MULTI-ELEMENT[@NAME='EXTERNALLINK3']/VALUE-EDITABLE"/>
				</xsl:attribute>
			</input>
			</div>
		</div>
		<div class="frow">	
			<div class="labelone"><label for="titlethree">link title</label></div>
			<div class="formstack">
				<input type="text" name="EXTERNALLINK3TITLE" id="titlethree" class="inputone">
				<xsl:attribute name="value">
					<xsl:value-of select="MULTI-ELEMENT[@NAME='EXTERNALLINK3TITLE']/VALUE-EDITABLE"/>
				</xsl:attribute>
			</input>
			</div>				
		</div>							
		</td>
		</tr>
		<!-- step 6 -->
		<tr>
		<td valign="top">		
		<img height="28" hspace="0" vspace="0" border="0" width="28" alt="six" src="{$imagesource}6.gif" />
		</td>
		<td>
		<div class="frow">
			<xsl:if test="MULTI-REQUIRED[@NAME='BODY']/ERRORS/ERROR/@TYPE='VALIDATION-ERROR-EMPTY'">
				<xsl:attribute name="class">frow alert</xsl:attribute>
				<div class="errortext"><strong>Please write something about yourself</strong></div>
			</xsl:if>
			<div class="labelone"><label for="maxchars450">tell us more<span class="required">*</span></label><br /><span class="opt2">(max 450 characters)</span></div>
			<textarea name="body" id="maxchars450" class="inputone" cols="15" rows="6">
				<xsl:value-of select="MULTI-REQUIRED[@NAME='BODY']/VALUE-EDITABLE"/>
			</textarea>			
		</div>		
							
		</td>
		</tr>
		</table>
		
		
		<!-- preview/submit buttons -->
		<xsl:choose>
			<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_display']/VALUE = 'register'">
				<div class="inputaction">					
					<xsl:apply-templates select="." mode="t_articlepreviewbutton"/>
				</div>
			</xsl:when>
			<xsl:when test="/H2G2/MULTI-STAGE/@TYPE='TYPED-ARTICLE-EDIT-PREVIEW'">
			<div class="frow">
				<div class="inputactionfl"><xsl:apply-templates select="." mode="t_articlepreviewbutton"/></div>
				<xsl:if test="not(*/ERRORS)">
					<div class="inputactionflr"><xsl:apply-templates select="." mode="c_articleeditbutton"/></div>
				</xsl:if>
				<div class="clear"></div>
			</div>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="SUBMIT_BUTTONS" />
			</xsl:otherwise>
		</xsl:choose>
		
	</div><!-- / formbox --> 
	</div><!-- / bodysec -->	
	<!-- hints and tips -->
	
	<!--[FIXME: remove]
	<div class="hintsec">				
			<div class="hintbox">	
		 	<h3>HINTS AND TIPS</h3>
			<p>Your profile is for people to learn more about you - include your sporting and non-sporting interests</p>
			
			<p>Your member page can find all the content you create and comments posted on your member page - use it to access all your latest contributions</p>
			
			<p>You must fill in this information to finish your registration and become a full member of 606</p>

		</div>   
	</div>
	-->
	
	 <div class="clear"></div>
</div><!-- / mainbodysec -->
</xsl:template>

<xsl:template name="PROFILE_FORM_ID">
	<!-- DEBUG -->
	<xsl:call-template name="TRACE">
	<xsl:with-param name="message">PROFILE_FORM</xsl:with-param>
	<xsl:with-param name="pagename">typedarticlepage_templates.xsl</xsl:with-param>
	</xsl:call-template>
	<!-- DEBUG -->
	<input type="hidden" name="_msxml" value="{$user_intro_fields}"/>
	<input type="hidden" name="type" value="3001"/>
	<input type="hidden" name="TITLE">
	<xsl:attribute name="value">
		<xsl:value-of select="/H2G2/ARTICLE/ARTICLEINFO/PAGEAUTHOR/EDITOR/USER/USERNAME" /> 
	</xsl:attribute>
	</input>
	<input type="hidden" name="TYPEOFARTICLE" value="member"/>
	<xsl:if test="/H2G2/PARAMS/PARAM[NAME = 's_display']/VALUE = 'register' or /H2G2/PARAMS/PARAM[NAME = 's_display']/VALUE = 'register2'">
	<input type="hidden" name="s_display" value="register2"/>
	</xsl:if>
	
	<!-- form -->
	<div class="formbox">
        <div class="requiredKeyBlock"><span class="required">*</span> compulsory fields</div>

		<table cellpadding="0" cellspacing="0" border="0" class="clear" width="100%">
		<!-- step 1 -->
		<tr>
			<td>
			<div class="frow">
				<xsl:if test="MULTI-ELEMENT[@NAME='SPORTINGINTEREST1']/ERRORS/ERROR/@TYPE='VALIDATION-ERROR-EMPTY'">	
					<div class="errortext"><strong class="alert">Please enter a team sported or sporting intrerest</strong></div>
				</xsl:if>
				<div class="labelone">
				<xsl:if test="MULTI-ELEMENT[@NAME='SPORTINGINTEREST1']/ERRORS/ERROR/@TYPE='VALIDATION-ERROR-EMPTY'">
					<xsl:attribute name="class">labelone alert</xsl:attribute>
				</xsl:if>
				Teams supported / sporting interests:<span class="required">*</span><br /><span class="opt2">(max 3)</span></div>
				
				<div class="formstack">
					<div>
						<xsl:if test="MULTI-ELEMENT[@NAME='SPORTINGINTEREST1']/ERRORS/ERROR/@TYPE='VALIDATION-ERROR-EMPTY'">
							<xsl:attribute name="class">alert</xsl:attribute>
						</xsl:if>
						<input type="text" name="SPORTINGINTEREST1" class="inputone"  maxlength="{$maxcharacters_textinput_value}">
							<xsl:attribute name="value">
								<xsl:value-of select="MULTI-ELEMENT[@NAME='SPORTINGINTEREST1']/VALUE-EDITABLE"/>
							</xsl:attribute>
						</input>
						<xsl:if test="MULTI-ELEMENT[@NAME='SPORTINGINTEREST1']/ERRORS/ERROR/@TYPE='VALIDATION-ERROR-EMPTY'">
							<xsl:attribute name="class">labelone alert</xsl:attribute>
						</xsl:if>
					</div>						
				
					<input type="text" name="SPORTINGINTEREST2" class="inputone"  maxlength="{$maxcharacters_textinput_value}">
						<xsl:attribute name="value">
							<xsl:value-of select="MULTI-ELEMENT[@NAME='SPORTINGINTEREST2']/VALUE-EDITABLE"/>
						</xsl:attribute>
					</input>
												
			
					<input type="text" name="SPORTINGINTEREST3" class="inputone"  maxlength="{$maxcharacters_textinput_value}">
						<xsl:attribute name="value">
							<xsl:value-of select="MULTI-ELEMENT[@NAME='SPORTINGINTEREST3']/VALUE-EDITABLE"/>
						</xsl:attribute>
					</input>
				
				</div>	
			</div>				
			</td>
			<td class="infocell">
				<xsl:call-template name="maxcharacters_textinput_text2" />
			</td>
		</tr>
		<!-- step 2 -->
		<tr>
			<td>
				<div class="frow">
					<xsl:if test="MULTI-ELEMENT[@NAME='FAVOURITEPLAYER']/ERRORS/ERROR/@TYPE='VALIDATION-ERROR-EMPTY'">
						<xsl:attribute name="class">frow alert</xsl:attribute>
						<div class="errortext"><strong>Please enter a favourite player</strong></div>
					</xsl:if>
					<div class="labelone"><label for="favourite">Favourite player:<span class="required">*</span></label></div>
					<div class="formstack">
						<input type="text" name="FAVOURITEPLAYER" id="favourite" class="inputone" maxlength="{$maxcharacters_textinput_value}">
							<xsl:attribute name="value">
								<xsl:value-of select="MULTI-ELEMENT[@NAME='FAVOURITEPLAYER']/VALUE-EDITABLE"/>
							</xsl:attribute>
						</input>
					</div>
				</div>		
			</td>
			<td class="infocell">
				<xsl:call-template name="maxcharacters_textinput_text2" />
			</td>
		</tr>
		<!-- step 3-->
		<tr>
		<td>
			<div class="frow">
				<div class="labelone"><label for="team">Team you play in:</label></div>
				<div class="formstack">
					<input type="text" name="TEAMPLAYEDIN" id="team" class="inputone"  maxlength="{$maxcharacters_textinput_value}">
						<xsl:attribute name="value">
							<xsl:value-of select="MULTI-ELEMENT[@NAME='TEAMPLAYEDIN']/VALUE-EDITABLE"/>
						</xsl:attribute>
					</input>
				</div>
			</div>								
			
			<div class="frow">					
				<div class="labelone"><label for="teamlink">Suggest a link for your team:</label></div>
				<div class="formstack">
					<input type="text" name="TEAMPLAYEDINLINK" id="teamlink" class="inputone">
						<xsl:attribute name="value">
							<xsl:value-of select="MULTI-ELEMENT[@NAME='TEAMPLAYEDINLINK']/VALUE-EDITABLE"/>
						</xsl:attribute>
					</input>
				</div>
			</div>		
			<td class="infocell">
				<xsl:call-template name="maxcharacters_textinput_text2" />
				<div class="inputinfo2">eg: http://www.nameofyourteam.com</div>
			</td>				
		</td>
		</tr>
		<!-- step 4 
		<tr>
		<td>
		<div class="frow">
			<div>
			<xsl:if test="MULTI-ELEMENT[@NAME='FAVOURITEMATCH']/ERRORS/ERROR/@TYPE='VALIDATION-ERROR-EMPTY'">
				<xsl:attribute name="class">alert</xsl:attribute>
				<div class="errortext"><strong>Please enter a favourite match</strong></div>
			</xsl:if>
			<div class="labelone"><label for="favouritematch">favourite match<span class="required">*</span></label></div>
			<input type="text" name="FAVOURITEMATCH" id="favouritematch" class="inputone"  maxlength="{$maxcharacters_textinput_value}">
				<xsl:attribute name="value">
					<xsl:value-of select="MULTI-ELEMENT[@NAME='FAVOURITEMATCH']/VALUE-EDITABLE"/>
				</xsl:attribute>
			</input>
			<xsl:call-template name="maxcharacters_textinput_text" />
			</div>
					
			<div class="labelone"><label for="matchlink">suggest a link for this match</label></div>
			<input type="text" name="FAVOURITEMATCHLINK" id="matchlink"  class="inputone">
				<xsl:attribute name="value">
					<xsl:value-of select="MULTI-ELEMENT[@NAME='FAVOURITEMATCHLINK']/VALUE-EDITABLE"/>
				</xsl:attribute>
			</input>
			<div class="inputinfo">eg: http://news.bbc.co.uk/sport1/hi/football/ fa_cup/4907012.stm</div>
		</div>						
		</td>
		</tr>-->
		<!-- step 5 -->
		<tr>
		<td>
		<div class="frow">					
			<div class="labelone"><label for="extlinkone">My link 1:</label></div>
			<div class="formstack">
				<input type="text" name="EXTERNALLINK1" id="extlinkone" class="inputone">
				<xsl:attribute name="value">
					<xsl:value-of select="MULTI-ELEMENT[@NAME='EXTERNALLINK1']/VALUE-EDITABLE"/>
				</xsl:attribute>
			</input>
			</div>					
		</div>
		<div class="frow">	
			<div class="labelone"><label for="titleone">Link title:</label></div>
			<div class="formstack">
				<input type="text" name="EXTERNALLINK1TITLE" id="titleone" class="inputone">
				<xsl:attribute name="value">
					<xsl:value-of select="MULTI-ELEMENT[@NAME='EXTERNALLINK1TITLE']/VALUE-EDITABLE"/>
				</xsl:attribute>
			</input>
			</div>
		</div>
		</td>
		<td>&#160;</td>
		</tr>
		<tr>
		<td>
		<div class="frow">	
			<div class="labelone"><label for="extlinktwo">My link 2:</label></div>
			<div class="formstack">
				<input type="text" name="EXTERNALLINK2" id="extlinktwo" class="inputone">
				<xsl:attribute name="value">
					<xsl:value-of select="MULTI-ELEMENT[@NAME='EXTERNALLINK2']/VALUE-EDITABLE"/>
				</xsl:attribute>
			</input>
			</div>
		</div>
		<div class="frow">	
			<div class="labelone"><label for="titletwo">Link title:</label></div>					
			<div class="formstack">
				<input type="text" name="EXTERNALLINK2TITLE" id="titletwo" class="inputone">
				<xsl:attribute name="value">
					<xsl:value-of select="MULTI-ELEMENT[@NAME='EXTERNALLINK2TITLE']/VALUE-EDITABLE"/>
				</xsl:attribute>
			</input>
			</div>
		</div>
		</td>
		<td>&#160;</td>
		</tr>
		<tr>
		<td>
		<div class="frow">	
			<div class="labelone"><label for="extlinkthree">My link 3:</label></div>					
			<div class="formstack">
				<input type="text" name="EXTERNALLINK3" id="extlinkthree" class="inputone">
				<xsl:attribute name="value">
					<xsl:value-of select="MULTI-ELEMENT[@NAME='EXTERNALLINK3']/VALUE-EDITABLE"/>
				</xsl:attribute>
			</input>
			</div>
		</div>
		<div class="frow">	
			<div class="labelone"><label for="titlethree">Link title:</label></div>
			<div class="formstack">
				<input type="text" name="EXTERNALLINK3TITLE" id="titlethree" class="inputone">
				<xsl:attribute name="value">
					<xsl:value-of select="MULTI-ELEMENT[@NAME='EXTERNALLINK3TITLE']/VALUE-EDITABLE"/>
				</xsl:attribute>
			</input>
			</div>				
		</div>							
		</td>
		<td>&#160;</td>
		</tr>
		<!-- step 6 -->
		<tr>
			<td>
				<div class="frow">
					<xsl:if test="MULTI-REQUIRED[@NAME='BODY']/ERRORS/ERROR/@TYPE='VALIDATION-ERROR-EMPTY'">
						<xsl:attribute name="class">frow alert</xsl:attribute>
						<div class="errortext"><strong>Please write something about yourself</strong></div>
					</xsl:if>
					<div class="labelone"><label for="maxchars450">Tell us more about yourself:<span class="required">*</span></label></div>
					<div class="formstack">
					<textarea name="body" id="maxchars450" class="inputone" cols="15" rows="6">
						<xsl:value-of select="MULTI-REQUIRED[@NAME='BODY']/VALUE-EDITABLE"/>
					</textarea>			
					</div>
				</div>		
			</td>
			<td class="infocell">
				<div class="inputinfo2">450 characters max</div>
			</td>			
		</tr>
		</table>
		
		
		<!-- preview/submit buttons -->
		<xsl:choose>
			<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_display']/VALUE = 'register'">
				<div>
					<xsl:attribute name="class">
						<xsl:text>inputaction </xsl:text>
						<xsl:if test="/H2G2/SITE/IDENTITYSIGNIN = 1">
							comm_inputaction
						</xsl:if>
					</xsl:attribute>
						
					<xsl:if test="/H2G2/SITE/IDENTITYSIGNIN = 1">
						<xsl:apply-templates select="." mode="c_articleeditbutton"/>
					</xsl:if>
					<xsl:apply-templates select="." mode="t_articlepreviewbutton"/>
					
				</div>
			</xsl:when>
			<xsl:when test="/H2G2/MULTI-STAGE/@TYPE='TYPED-ARTICLE-EDIT-PREVIEW'">
			<div class="frow">
				<div class="inputaction comm_inputaction">
					<xsl:apply-templates select="." mode="c_articleeditbutton"/>
					<xsl:apply-templates select="." mode="t_articlepreviewbutton"/>
					<div class="clear" />
				</div>
			</div>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="SUBMIT_BUTTONS" />
			</xsl:otherwise>
		</xsl:choose>
		
	</div><!-- / formbox --> 
	<!-- hints and tips -->
	
	<!--[FIXME: remove]
	<div class="hintsec">				
			<div class="hintbox">	
		 	<h3>HINTS AND TIPS</h3>
			<p>Your profile is for people to learn more about you - include your sporting and non-sporting interests</p>
			
			<p>Your member page can find all the content you create and comments posted on your member page - use it to access all your latest contributions</p>
			
			<p>You must fill in this information to finish your registration and become a full member of 606</p>

		</div>   
	</div>
	-->
	
	 <div class="clear"></div>
</xsl:template>

<!-- form used for creating an article (poll with comments) -->
<xsl:template name="ARTICLE_FORM">
	<!-- DEBUG -->
	<xsl:call-template name="TRACE">
		<xsl:with-param name="message">USER_ARTICLE_FORM</xsl:with-param>
		<xsl:with-param name="pagename">typedarticlepage_templates.xsl</xsl:with-param>
	</xsl:call-template>
	<!-- DEBUG -->
	
	<xsl:apply-templates select="/H2G2/MULTI-STAGE/MULTI-REQUIRED/ERRORS/ERROR | /H2G2/MULTI-STAGE/MULTI-ELEMENT/ERRORS/ERROR" mode="c_typedarticle"/>
				
	<input type="hidden" name="_msxml" value="{$article_form}"/>
	<input type="hidden" name="ARTICLEFORUMSTYLE" value="1"/>
	<input type="hidden" name="polltype1" value="3"/>
	<input type="hidden" name="status" value="3"/>
	<input type="hidden" name="type">
	<!-- <input type="hidden" name="skin" value="purexml"/> -->
		<xsl:attribute name="value"><xsl:value-of select="$current_article_type"/></xsl:attribute>
	</input>
	
	<xsl:choose>
		<xsl:when test="$article_subtype = 'staff_article' and $test_IsEditor">
			<input type="hidden" name="TYPEOFARTICLE" value="staff article sport"/>
		</xsl:when>
		<xsl:otherwise>
			<input type="hidden" name="TYPEOFARTICLE" value="user article sport"/>
		</xsl:otherwise>
	</xsl:choose>
	
	<!-- 
		============================================================
				AUTO TAGGING 
		============================================================ 
	-->
	<xsl:variable name="team"><xsl:apply-templates select="/H2G2/ARTICLE/GUIDE/TEAM/text()" mode="variablevalue"/></xsl:variable>
	
	<xsl:call-template name="AUTO_HIDDEN_FIELDS">
		<xsl:with-param name="team" select="$team"/>
	</xsl:call-template>
				
	<!-- 
		============================================================
				END AUTO TAGGING 
		============================================================ 
	-->
	
	<div class="mainbodysec">
		<xsl:if test="/H2G2/PARAMS/PARAM[NAME = 's_sport'] or /H2G2/MULTI-STAGE/@TYPE='TYPED-ARTICLE-PREVIEW' or /H2G2/MULTI-STAGE[@TYPE='TYPED-ARTICLE-EDIT-PREVIEW'] or /H2G2/MULTI-STAGE[@TYPE='TYPED-ARTICLE-EDIT']">
			<xsl:attribute name="class">mainbodysec createarticle</xsl:attribute>
		</xsl:if>
	
		<!-- form -->
		<div class="formsec">
		<div class="formbox">
			<xsl:call-template name="SELECT_SPORT" />
		
			<!-- only show input fields if not displaying list of sports page (step 2) -->
			<xsl:if test="(/H2G2/MULTI-STAGE/MULTI-ELEMENT[@NAME='SPORT']/VALUE/text() or /H2G2/PARAMS/PARAM[NAME = 's_sport']) and not(/H2G2/PARAMS/PARAM[NAME = 's_selectsport'])">
				<xsl:call-template name="ARTICLE_FORM_FIXED_FIELDS"/>			

				<!-- submit buttons -->
				<xsl:call-template name="SUBMIT_BUTTONS" />
			</xsl:if>		
										
		</div><!-- / formbox -->
		</div><!-- / formsec -->	
		
		<!-- 
		<p class="top"><a href="#top">Back to top</a></p>
		-->
		
		<!-- hints and tips -->
		<!--[FIXME: remove]
		<div class="hintsec">				
			<div class="hintbox">	
				<h3>HINTS AND TIPS</h3>
				<p>Choose a subject you are knowledgeable about.</p>

				<p>Check your facts - getting the basics wrong devalues your article.</p>
				
				<p>Keep it lively.</p>
				
				<p>Don't be frightened of being opinionated.</p>
				
			</div>  
		</div>
		-->
		
		<div class="clear"></div>
	</div><!-- / mainbodysec -->
</xsl:template>

<!-- form used for creating an match report article -->
<xsl:template name="MATCH_REPORT_FORM">
	<!-- DEBUG -->
	<xsl:call-template name="TRACE">
	<xsl:with-param name="message">MATCH_REPORT_FORM</xsl:with-param>
	<xsl:with-param name="pagename">typedarticlepage_templates.xsl</xsl:with-param>
	</xsl:call-template>
	<!-- DEBUG -->
	
	<xsl:apply-templates select="/H2G2/MULTI-STAGE/MULTI-REQUIRED/ERRORS/ERROR | /H2G2/MULTI-STAGE/MULTI-ELEMENT/ERRORS/ERROR" mode="c_typedarticle"/>
				
	<input type="hidden" name="_msxml" value="{$match_report_form}"/>
	<input type="hidden" name="ARTICLEFORUMSTYLE" value="1"/>
	<input type="hidden" name="polltype1" value="3"/>
	<input type="hidden" name="status" value="3"/>
	<input type="hidden" name="type">
		<xsl:attribute name="value"><xsl:value-of select="$current_article_type"/></xsl:attribute>
	</input>
	
	
	<input type="hidden" name="TYPEOFARTICLE" value="match report sport"/>
	
	<xsl:variable name="hometeam">
		<xsl:choose>
			<xsl:when test="MULTI-ELEMENT[@NAME='HOMETEAMOTHER']/VALUE-EDITABLE/text()">
				<xsl:value-of select="MULTI-ELEMENT[@NAME='HOMETEAMOTHER']/VALUE-EDITABLE"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="MULTI-ELEMENT[@NAME='HOMETEAM']/VALUE-EDITABLE"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<xsl:variable name="awayteam">
		<xsl:choose>
			<xsl:when test="MULTI-ELEMENT[@NAME='AWAYTEAMOTHER']/VALUE-EDITABLE/text()">
				<xsl:value-of select="MULTI-ELEMENT[@NAME='AWAYTEAMOTHER']/VALUE-EDITABLE"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="MULTI-ELEMENT[@NAME='AWAYTEAM']/VALUE-EDITABLE"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<xsl:variable name="matcheventtitle">
		<xsl:value-of select="$hometeam"/><xsl:text> </xsl:text><xsl:value-of select="MULTI-ELEMENT[@NAME='HOMETEAMSCORE']/VALUE-EDITABLE"/><xsl:text> - </xsl:text><xsl:value-of select="MULTI-ELEMENT[@NAME='AWAYTEAMSCORE']/VALUE-EDITABLE"/><xsl:text> </xsl:text><xsl:value-of select="$awayteam"/>
	</xsl:variable>
	
	<xsl:comment>
		$hometeam: <xsl:value-of select="$hometeam"/><br />
		$awayteam: <xsl:value-of select="$awayteam"/><br />
		$matcheventtitle: <xsl:value-of select="$matcheventtitle"/> <br />
	</xsl:comment>
	
	<input type="hidden" name="title" value="{$matcheventtitle}"/>
	
	
	<!-- 
		============================================================
				AUTO TAGGING 
		============================================================ 
	-->
	<xsl:call-template name="AUTO_HIDDEN_FIELDS_TWO_TEAMS">
		<xsl:with-param name="team1" select="$hometeam"/>
		<xsl:with-param name="team1_label">hometeam</xsl:with-param>
		<xsl:with-param name="team2" select="$awayteam"/>
		<xsl:with-param name="team2_label">awayteam</xsl:with-param>
	</xsl:call-template>

	
	
	<!-- 
		============================================================
				END AUTO TAGGING 
		============================================================ 
	-->
	
	
<div class="mainbodysec">
	<xsl:if test="/H2G2/PARAMS/PARAM[NAME = 's_sport'] or /H2G2/MULTI-STAGE/@TYPE='TYPED-ARTICLE-PREVIEW' or /H2G2/MULTI-STAGE[@TYPE='TYPED-ARTICLE-EDIT-PREVIEW'] or /H2G2/MULTI-STAGE[@TYPE='TYPED-ARTICLE-EDIT']">
		<xsl:attribute name="class">mainbodysec createarticle</xsl:attribute>
	</xsl:if>
	<!-- form -->
	<div class="formsec">	
	<div class="formbox">
		<xsl:call-template name="SELECT_SPORT" />
		
		<!-- only show input fields if not displaying list of sports page (step 1) -->
		<xsl:if test="(/H2G2/MULTI-STAGE/MULTI-ELEMENT[@NAME='SPORT']/VALUE/text() or /H2G2/PARAMS/PARAM[NAME = 's_sport']) and not(/H2G2/PARAMS/PARAM[NAME = 's_selectsport'])">
				
		<xsl:call-template name="MATCH_REPORT_FORM_FIXED_FIELDS"/>		
		
		<xsl:call-template name="SUBMIT_BUTTONS" />
				
	</xsl:if>
						
	</div><!-- / formbox -->
	</div><!-- / formsec -->	
	
	<!-- 
<p class="top"><a href="#top">Back to top</a></p>
-->
	
	<!-- hints and tips -->
	<!--[FIXME: remove]
	<div class="hintsec">				
		<div class="hintbox">	
			<h3>HINTS AND TIPS</h3>
			<p>Keep each paragraph short and concise. Try to get the main details - goals, sendings off etc - into the first 3-4 paragraphs.</p>

			<p>Don't be afraid to offer your own opinions.</p>

			<p>Mention things like the atmosphere, the mood among fans, your matchday experience etc.</p> 
		
			<p>Match reports are for team sports with straightforward scores involving goals or points such as 2-0 and 21-6 . If you can't find your sport here, try writing an <a href="{$root}TypedArticle?acreate=new&amp;type=12">event report</a></p>
		</div>  
	</div>
	-->

	<div class="clear"></div>
</div><!-- / mainbodysec -->
	
</xsl:template>

<!-- form used for creating an event report article -->
<xsl:template name="EVENT_REPORT_FORM">
	<!-- DEBUG -->
	<xsl:call-template name="TRACE">
	<xsl:with-param name="message">EVENT_REPORT_FORM</xsl:with-param>
	<xsl:with-param name="pagename">typedarticlepage_templates.xsl</xsl:with-param>
	</xsl:call-template>
	<!-- DEBUG -->
	
	<xsl:apply-templates select="/H2G2/MULTI-STAGE/MULTI-REQUIRED/ERRORS/ERROR | /H2G2/MULTI-STAGE/MULTI-ELEMENT/ERRORS/ERROR" mode="c_typedarticle"/>
				
	<input type="hidden" name="_msxml" value="{$event_report_form}"/>
	<input type="hidden" name="ARTICLEFORUMSTYLE" value="1"/>
	<input type="hidden" name="polltype1" value="3"/>
	<input type="hidden" name="status" value="3"/>
	<input type="hidden" name="type">
		<xsl:attribute name="value"><xsl:value-of select="$current_article_type"/></xsl:attribute>
	</input>
	
	<input type="hidden" name="TYPEOFARTICLE" value="event report sport"/>
	
	
<div class="mainbodysec">
	<xsl:if test="/H2G2/PARAMS/PARAM[NAME = 's_sport'] or /H2G2/MULTI-STAGE/@TYPE='TYPED-ARTICLE-PREVIEW' or /H2G2/MULTI-STAGE[@TYPE='TYPED-ARTICLE-EDIT-PREVIEW'] or /H2G2/MULTI-STAGE[@TYPE='TYPED-ARTICLE-EDIT']">
		<xsl:attribute name="class">mainbodysec createarticle</xsl:attribute>
	</xsl:if>
	<!-- form -->
	<div class="formsec">	
	<div class="formbox">
		<xsl:call-template name="SELECT_SPORT" />
		
		<!-- only show input fields if not displaying list of sports page (step 1) -->
		<xsl:if test="(/H2G2/MULTI-STAGE/MULTI-ELEMENT[@NAME='SPORT']/VALUE/text() or /H2G2/PARAMS/PARAM[NAME = 's_sport']) and not(/H2G2/PARAMS/PARAM[NAME = 's_selectsport'])">
				
		<xsl:call-template name="EVENT_REPORT_FORM_FIXED_FIELDS"/>
		
		<xsl:call-template name="SUBMIT_BUTTONS" />
		
	</xsl:if>
									
	</div><!-- / formbox -->
	</div><!-- / formsec -->	
	
	<!-- 
<p class="top"><a href="#top">Back to top</a></p>
-->
	
	<!-- hints and tips -->
	<!--[FIXME: remove]
	<div class="hintsec">				
		<div class="hintbox">	
			<h3>HINTS AND TIPS</h3>
			<p>Concentrate on getting the basics such as the teams/players names and the score correct.</p>
			
			<p>Put the most important thing that happened in the opening paragraph.</p>
			
			<p>Keep it lively.</p>
			
			<p>Mention things unique to your game - odd happenings in the crowd or from the players - it adds colour to your piece.</p>
			
			<p>If you want to write something on <strong>football</strong> or <strong>rugby</strong> then try writing a <a href="{$root}TypedArticle?acreate=new&amp;type=11">match report</a></p>
			
		</div>  
	</div>
	-->
	
	<div class="clear"></div>
</div><!-- / mainbodysec -->
	
</xsl:template>

<!-- form used for creating an player profile article -->
<xsl:template name="PLAYER_PROFILE_FORM">
	<!-- DEBUG -->
	<xsl:call-template name="TRACE">
	<xsl:with-param name="message">PLAYER_PROFILE_FORM</xsl:with-param>
	<xsl:with-param name="pagename">typedarticlepage_templates.xsl</xsl:with-param>
	</xsl:call-template>
	<!-- DEBUG -->
	
	<xsl:apply-templates select="/H2G2/MULTI-STAGE/MULTI-REQUIRED/ERRORS/ERROR | /H2G2/MULTI-STAGE/MULTI-ELEMENT/ERRORS/ERROR" mode="c_typedarticle"/>
				
	<input type="hidden" name="_msxml" value="{$player_profile_form}"/>
	<input type="hidden" name="ARTICLEFORUMSTYLE" value="1"/>
	<input type="hidden" name="polltype1" value="3"/>
	<input type="hidden" name="status" value="3"/>
	<input type="hidden" name="type">
		<xsl:attribute name="value"><xsl:value-of select="$current_article_type"/></xsl:attribute>
	</input>
	
	<input type="hidden" name="TYPEOFARTICLE" value="player profile sport"/>
	
	<!-- 
		============================================================
				AUTO TAGGING 
		============================================================ 
	-->
	<xsl:variable name="team"><xsl:apply-templates select="/H2G2/ARTICLE/GUIDE/TEAM/text()" mode="variablevalue"/></xsl:variable>
	<xsl:variable name="currentteam"><xsl:apply-templates select="/H2G2/ARTICLE/GUIDE/CURRENTTEAM/text()" mode="variablevalue"/></xsl:variable>
	
	<xsl:call-template name="AUTO_HIDDEN_FIELDS_TWO_TEAMS">
		<xsl:with-param name="team1" select="$team"/>
		<xsl:with-param name="team1_label">team</xsl:with-param>
		<xsl:with-param name="team2" select="$currentteam"/>
		<xsl:with-param name="team2_label">current team</xsl:with-param>
	</xsl:call-template>
	
	<!-- preview -->
	<!--
	<xsl:if test="$test_IsEditor"><span class="clearall"><br clear="all" /></span>
		<div class="editbox">
			<strong>Auto competition team tags:</strong><xsl:text> </xsl:text>
				<xsl:for-each select="msxsl:node-set($competitions)/competition[@sport=$sport]">
					<xsl:if test="$team = team/@fullname"><xsl:value-of select="@name"/><xsl:text> </xsl:text></xsl:if>
				</xsl:for-each>
			<br /><strong>Auto name team tags:</strong><xsl:text> </xsl:text>
			<xsl:for-each select="msxsl:node-set($competitions)/competition[@sport=$sport]/team">
				<xsl:if test="$team = @fullname"><xsl:value-of select="@searchterms"/><xsl:text> </xsl:text></xsl:if>
			</xsl:for-each>
			<br />
			<br /><strong>Auto competition current team tags:</strong><xsl:text> </xsl:text>
				<xsl:for-each select="msxsl:node-set($competitions)/competition[@sport=$sport]">
					<xsl:if test="$currentteam = team/@fullname"><xsl:value-of select="@name"/><xsl:text> </xsl:text></xsl:if>
				</xsl:for-each>
			<br /><strong>Auto name current team tags:</strong><xsl:text> </xsl:text>
			<xsl:for-each select="msxsl:node-set($competitions)/competition[@sport=$sport]/team">
				<xsl:if test="$currentteam = @fullname"><xsl:value-of select="@searchterms"/><xsl:text> </xsl:text></xsl:if>
			</xsl:for-each>
		</div>
	</xsl:if>
	-->
	
	<!-- populate -->
	<!--
	<input type="hidden" name="autocompetitions">
		<xsl:attribute name="value"><xsl:for-each select="msxsl:node-set($competitions)/competition[@sport=$sport]"><xsl:if test="$team = team/@fullname"><xsl:value-of select="@name"/><xsl:text> </xsl:text></xsl:if></xsl:for-each><xsl:for-each select="msxsl:node-set($competitions)/competition[@sport=$sport]"><xsl:if test="$currentteam = team/@fullname"><xsl:value-of select="@name"/><xsl:text> </xsl:text></xsl:if></xsl:for-each></xsl:attribute>
	</input>
	<input type="hidden" name="autonames">
		<xsl:attribute name="value"><xsl:for-each select="msxsl:node-set($competitions)/competition[@sport=$sport]/team"><xsl:if test="$team = @fullname"><xsl:value-of select="@searchterms"/><xsl:text> </xsl:text></xsl:if></xsl:for-each><xsl:for-each select="msxsl:node-set($competitions)/competition[@sport=$sport]/team"><xsl:if test="$currentteam = @fullname"><xsl:value-of select="@searchterms"/><xsl:text> </xsl:text></xsl:if></xsl:for-each></xsl:attribute>
	</input>
	-->
	
	
				
	<!-- 
		============================================================
				END AUTO TAGGING 
		============================================================ 
	-->
	
<div class="mainbodysec">
	<xsl:if test="/H2G2/PARAMS/PARAM[NAME = 's_sport'] or /H2G2/MULTI-STAGE/@TYPE='TYPED-ARTICLE-PREVIEW' or /H2G2/MULTI-STAGE[@TYPE='TYPED-ARTICLE-EDIT-PREVIEW'] or /H2G2/MULTI-STAGE[@TYPE='TYPED-ARTICLE-EDIT']">
		<xsl:attribute name="class">mainbodysec createarticle</xsl:attribute>
	</xsl:if>
	<!-- form -->
	<div class="formsec">	
	<div class="formbox">
		<xsl:call-template name="SELECT_SPORT" />
		
		<!-- only show input fields if not displaying list of sports page (step 1) -->
		<xsl:if test="(/H2G2/MULTI-STAGE/MULTI-ELEMENT[@NAME='SPORT']/VALUE/text() or /H2G2/PARAMS/PARAM[NAME = 's_sport']) and not(/H2G2/PARAMS/PARAM[NAME = 's_selectsport'])">
				
		<xsl:call-template name="PLAYER_PROFILE_FORM_FIXED_FIELDS"/>
		
		<xsl:call-template name="SUBMIT_BUTTONS" />
		
		</xsl:if>
		
		
									
	</div><!-- / formbox -->
	</div><!-- / formsec -->	
	
	<!-- 
<p class="top"><a href="#top">Back to top</a></p>
-->
	
	<!-- hints and tips -->
	<!--[FIXME: remove]
	<div class="hintsec">				
		<div class="hintbox">	
			<h3>HINTS AND TIPS</h3>
			<p>Think about what kind of information you've looked for when your club signs or is linked with a player.</p> 

			<p>Try to keep your player profiles as up-to-date as possible by updating them regularly.</p> 
			
			<p>Don't be afraid to offer your opinions. </p>
		</div>  
	</div>
	-->
	
	<div class="clear"></div>
</div><!-- / mainbodysec -->
			
		
</xsl:template>

<!-- form used for creating an team profile article -->
<xsl:template name="TEAM_PROFILE_FORM">
	<!-- DEBUG -->
	<xsl:call-template name="TRACE">
	<xsl:with-param name="message">TEAM_PROFILE_FORM</xsl:with-param>
	<xsl:with-param name="pagename">typedarticlepage_templates.xsl</xsl:with-param>
	</xsl:call-template>
	<!-- DEBUG -->
	
	<xsl:apply-templates select="/H2G2/MULTI-STAGE/MULTI-REQUIRED/ERRORS/ERROR | /H2G2/MULTI-STAGE/MULTI-ELEMENT/ERRORS/ERROR" mode="c_typedarticle"/>
				
	<input type="hidden" name="_msxml" value="{$team_profile_form}"/>
	<input type="hidden" name="ARTICLEFORUMSTYLE" value="1"/>
	<input type="hidden" name="polltype1" value="3"/>
	<input type="hidden" name="status" value="3"/>
	<input type="hidden" name="type">
		<xsl:attribute name="value"><xsl:value-of select="$current_article_type"/></xsl:attribute>
	</input>
	
	<input type="hidden" name="TYPEOFARTICLE" value="team profile sport"/>
	
	<!-- use team dropdown or otherteam input to create title for page-->
	<xsl:variable name="selectedteam" select="MULTI-ELEMENT[@NAME='TEAM']/VALUE-EDITABLE/text()"/>
	<xsl:variable name="selectedotherteam" select="MULTI-ELEMENT[@NAME='OTHERTEAM']/VALUE-EDITABLE/text()"/>
	<xsl:variable name="teamprofiletitle">
	<xsl:choose>
		<xsl:when test="$selectedotherteam"><xsl:value-of select="$selectedotherteam"/></xsl:when>
		<xsl:otherwise><xsl:value-of select="$selectedteam"/></xsl:otherwise>
	</xsl:choose>
	</xsl:variable>
	
	<xsl:comment>
		$selectedteam: <xsl:value-of select="$selectedteam"/><br />
		$selectedotherteam: <xsl:value-of select="$selectedotherteam"/><br />
		$teamprofiletitle: <xsl:value-of select="$teamprofiletitle"/> <br />
	</xsl:comment>
	<input type="hidden" name="title" value="{$teamprofiletitle}"/>
	
	
	
	<!-- 
		============================================================
				AUTO TAGGING 
		============================================================ 
	-->
	<xsl:variable name="team"><xsl:value-of select="$teamprofiletitle"/></xsl:variable>
	
	<xsl:call-template name="AUTO_HIDDEN_FIELDS">
		<xsl:with-param name="team" select="$team"/>
	</xsl:call-template>
				
	<!-- 
		============================================================
				END AUTO TAGGING 
		============================================================ 
	-->
	
	
	<div class="mainbodysec">
	<xsl:if test="/H2G2/PARAMS/PARAM[NAME = 's_sport'] or /H2G2/MULTI-STAGE/@TYPE='TYPED-ARTICLE-PREVIEW' or /H2G2/MULTI-STAGE[@TYPE='TYPED-ARTICLE-EDIT-PREVIEW'] or /H2G2/MULTI-STAGE[@TYPE='TYPED-ARTICLE-EDIT']">
		<xsl:attribute name="class">mainbodysec createarticle</xsl:attribute>
	</xsl:if>
		<!-- form -->
		<div class="formsec">	
		<div class="formbox">
			<xsl:call-template name="SELECT_SPORT" />

		
		<!-- only show input fields if not displaying list of sports page (step 1) -->
		<xsl:if test="(/H2G2/MULTI-STAGE/MULTI-ELEMENT[@NAME='SPORT']/VALUE/text() or /H2G2/PARAMS/PARAM[NAME = 's_sport']) and not(/H2G2/PARAMS/PARAM[NAME = 's_selectsport'])">
			
			<xsl:call-template name="TEAM_PROFILE_FORM_FIXED_FIELDS"/>
			
			<xsl:call-template name="SUBMIT_BUTTONS" />
				
		</xsl:if>
						
										
		</div><!-- / formbox -->
		</div><!-- / formsec -->	
		
		<!-- 
<p class="top"><a href="#top">Back to top</a></p>
-->
		
		<!-- hints and tips -->
		<!--[FIXME: remove]
		<div class="hintsec">				
			<div class="hintbox">	
				<h3>HINTS AND TIPS</h3>
				<p>Try to make your team profile informative, interesting and accurate.</p>

				<p>You can edit your profile to reflect the latest news and information - change in manager, for example.</p>
				
				<p>Don't be afraid to offer your opinions.</p>
				
			</div>  
		</div>
		-->
	
		<div class="clear"></div>
	</div><!-- / mainbodysec -->
		
		
	
</xsl:template>
		
<!-- form used for creating a popup article -->
<xsl:template name="POPUP_ARTICLE_FORM">
	<!-- DEBUG -->
	<xsl:call-template name="TRACE">
	<xsl:with-param name="message">POPUP_ARTICLE_FORM</xsl:with-param>
	<xsl:with-param name="pagename">typedarticlepage_templates.xsl</xsl:with-param>
	</xsl:call-template>
	<!-- DEBUG -->
	
	<xsl:apply-templates select="/H2G2/MULTI-STAGE/MULTI-REQUIRED/ERRORS/ERROR | /H2G2/MULTI-STAGE/MULTI-ELEMENT/ERRORS/ERROR" mode="c_typedarticle"/>
				
	<input type="hidden" name="_msxml" value="{$popup_article_fields}"/>
	<input type="hidden" name="s_editorial" value="1"/>
	
<div class="mainbodysec">
	<xsl:if test="/H2G2/PARAMS/PARAM[NAME = 's_sport'] or /H2G2/MULTI-STAGE/@TYPE='TYPED-ARTICLE-PREVIEW' or /H2G2/MULTI-STAGE[@TYPE='TYPED-ARTICLE-EDIT-PREVIEW'] or /H2G2/MULTI-STAGE[@TYPE='TYPED-ARTICLE-EDIT']">
		<xsl:attribute name="class">mainbodysec createarticle</xsl:attribute>
	</xsl:if>
	<!-- form -->
	<div class="formsec">	
	<div class="formbox">
		<div class="requiredKey"><span class="required">*</span> compulsory fields</div>
		
		<table cellpadding="0" cellspacing="0" border="0" class="clear">
		<!-- 1 -->
		<tr>
		<td width="35" valign="top">		
		<img height="28" hspace="0" vspace="0" border="0" width="28" alt="1" src="{$imagesource}1.gif" />
		</td>
		<td>
		<div class="frow">
			<xsl:if test="MULTI-REQUIRED[@NAME='TITLE']/ERRORS/ERROR/@TYPE='VALIDATION-ERROR-EMPTY'">
				<xsl:attribute name="class">frow alert</xsl:attribute>
				<div class="errortext"><strong>Please enter a title</strong></div>
			</xsl:if>
			<div class="labelone"><label for="title">title<span class="required">*</span></label></div>
			<input type="text" name="TITLE" id="title" class="inputone" maxlength="{$maxcharacters_textinput_value}">
				<xsl:attribute name="value">
					<xsl:value-of select="MULTI-REQUIRED[@NAME='TITLE']/VALUE-EDITABLE"/>
				</xsl:attribute>
			</input>
			<xsl:call-template name="maxcharacters_textinput_text" />
			</div>								
		</td>
		</tr>
		<!-- 3 -->
		<tr>
		<td valign="top">		
		<img height="28" hspace="0" vspace="0" border="0" width="28" alt="3" src="{$imagesource}2.gif" />
		</td>
		<td>
		<div class="frow">
			<xsl:if test="MULTI-REQUIRED[@NAME='BODY']/ERRORS/ERROR/@TYPE='VALIDATION-ERROR-EMPTY'">
				<xsl:attribute name="class">frow alert</xsl:attribute>
				<div class="errortext"><strong>Please enter your article text</strong></div>
			</xsl:if>
			
			<div class="labelone"><label for="body">Popup guideML<span class="required">*</span></label></div>
			<textarea name="body" cols="15" rows="10" class="inputone" id="body">
				<xsl:value-of select="MULTI-REQUIRED[@NAME='BODY']/VALUE-EDITABLE"/>
			</textarea>
		</div>		
					
		</td>
		</tr>
		</table>
		
		<xsl:call-template name="SUBMIT_BUTTONS" />
						
	</div><!-- / formbox -->
	</div><!-- / formsec -->	
	
	<!-- 
<p class="top"><a href="#top">Back to top</a></p>
-->
	
	<!-- hints and tips -->
	<!--[FIXME: remove]
	<div class="hintsec">				
		<div class="hintbox">	
			<h3>HINTS AND TIPS</h3>
			<p>This page is for editors to set up article to pull in a dynamic list.</p>

			<p>The article will not have any comments or ratings.</p>
			
			<p>The article will be status 1 so will not appear on your members page</p>
			
		</div>  
	</div>
	-->

	<div class="clear"></div>
</div><!-- / mainbodysec -->
</xsl:template>
		
<!-- form used for creating an editorial article -->
<xsl:template name="EDITORIAL_ARTICLE_FORM">
	<!-- DEBUG -->
	<xsl:call-template name="TRACE">
	<xsl:with-param name="message">EDITORIAL_ARTICLE_FORM</xsl:with-param>
	<xsl:with-param name="pagename">typedarticlepage_templates.xsl</xsl:with-param>
	</xsl:call-template>
	<!-- DEBUG -->
	
	<xsl:apply-templates select="/H2G2/MULTI-STAGE/MULTI-REQUIRED/ERRORS/ERROR | /H2G2/MULTI-STAGE/MULTI-ELEMENT/ERRORS/ERROR" mode="c_typedarticle"/>
				
	<input type="hidden" name="_msxml" value="{$editorial_article_fields}"/>
	<input type="hidden" name="s_editorial" value="1"/>
	
<div class="mainbodysec">
	<xsl:if test="/H2G2/PARAMS/PARAM[NAME = 's_sport'] or /H2G2/MULTI-STAGE/@TYPE='TYPED-ARTICLE-PREVIEW' or /H2G2/MULTI-STAGE[@TYPE='TYPED-ARTICLE-EDIT-PREVIEW'] or /H2G2/MULTI-STAGE[@TYPE='TYPED-ARTICLE-EDIT']">
		<xsl:attribute name="class">mainbodysec createarticle</xsl:attribute>
	</xsl:if>
	<!-- form -->
	<div class="formsec">	
	<div class="formbox">
		<div class="requiredKey"><span class="required">*</span> compulsory fields</div>
		
		<table cellpadding="0" cellspacing="0" border="0" class="clear">
		<!-- 1 -->
		<tr>
		<td width="35" valign="top">		
		<img height="28" hspace="0" vspace="0" border="0" width="28" alt="1" src="{$imagesource}1.gif" />
		</td>
		<td>
		<div class="frow">
			<xsl:if test="MULTI-REQUIRED[@NAME='TITLE']/ERRORS/ERROR/@TYPE='VALIDATION-ERROR-EMPTY'">
				<xsl:attribute name="class">frow alert</xsl:attribute>
				<div class="errortext"><strong>Please enter a title</strong></div>
			</xsl:if>
			<div class="labelone"><label for="title">title<span class="required">*</span></label></div>
			<input type="text" name="TITLE" id="title" class="inputone" maxlength="{$maxcharacters_textinput_value}">
				<xsl:attribute name="value">
					<xsl:value-of select="MULTI-REQUIRED[@NAME='TITLE']/VALUE-EDITABLE"/>
				</xsl:attribute>
			</input>
			<xsl:call-template name="maxcharacters_textinput_text" />
			</div>								
		</td>
		</tr>
		<!-- 2 -->
		<tr>
		<td valign="top">		
		<img height="28" hspace="0" vspace="0" border="0" width="28" alt="2" src="{$imagesource}2.gif" />
		</td>
		<td>
		
			<div class="frow">
				<div class="labelone"><label for="introtext">Intro Text</label></div>
				<input type="text" name="INTROTEXT" id="introtext" class="inputone">
					<xsl:attribute name="value">
						<xsl:value-of select="MULTI-ELEMENT[@NAME='INTROTEXT']/VALUE-EDITABLE"/>
					</xsl:attribute>
				</input>
			</div>
		</td>
		</tr>
		<!-- 3 -->
		<tr>
		<td valign="top">		
		<img height="28" hspace="0" vspace="0" border="0" width="28" alt="3" src="{$imagesource}3.gif" />
		</td>
		<td>
		<div class="frow">
			<xsl:if test="MULTI-REQUIRED[@NAME='BODY']/ERRORS/ERROR/@TYPE='VALIDATION-ERROR-EMPTY'">
				<xsl:attribute name="class">frow alert</xsl:attribute>
				<div class="errortext"><strong>Please enter your article text</strong></div>
			</xsl:if>
			
			<div class="labelone"><label for="body">guideML<span class="required">*</span></label></div>
			<textarea name="body" cols="15" rows="10" class="inputone" id="body">
				<xsl:value-of select="MULTI-REQUIRED[@NAME='BODY']/VALUE-EDITABLE"/>
			</textarea>
		</div>		
					
		</td>
		</tr>
		</table>
		
		<xsl:call-template name="SUBMIT_BUTTONS" />
						
	</div><!-- / formbox -->
	</div><!-- / formsec -->	
	
	<!-- 
<p class="top"><a href="#top">Back to top</a></p>
-->
	
	<!-- hints and tips -->
	<!--[FIXME: remove]
	<div class="hintsec">				
		<div class="hintbox">	
			<h3>HINTS AND TIPS</h3>
			<p>This page is for editors to set up article to pull in a dynamic list.</p>

			<p>The article will not have any comments or ratings.</p>
			
			<p>The article will be status 1 so will not appear on your members page</p>
			
		</div>  
	</div>
	-->

	<div class="clear"></div>
</div><!-- / mainbodysec -->
</xsl:template>



<!-- 
#############################################################
	HIDDEN FIELDS FOR AUTO TAGGING
#############################################################
-->
<xsl:template name="AUTO_HIDDEN_FIELDS">
	<xsl:param name="team"/>
	<xsl:param name="team_label"/>
	
	<!-- preview -->
	<xsl:if test="$test_IsEditor"><span class="clearall"><br clear="all" /></span>
		<div class="editbox">
			<strong>Auto competition <xsl:value-of select="$team_label"/> tags:</strong><xsl:text> </xsl:text>
				<xsl:for-each select="msxsl:node-set($competitions)/competition[@sport=$sport]">
					<xsl:if test="$team = team/@fullname">
						<xsl:value-of select="@name"/><xsl:text> </xsl:text>
						<xsl:value-of select="@searchterms"/><xsl:text> </xsl:text>
					</xsl:if>
				</xsl:for-each>
			<br /><strong>Auto name <xsl:value-of select="$team_label"/> tags:</strong><xsl:text> </xsl:text>
			<xsl:for-each select="msxsl:node-set($competitions)/competition[@sport=$sport]/team">
				<xsl:if test="$team = @fullname">
					<xsl:value-of select="@searchterms"/><xsl:text> </xsl:text>
				</xsl:if>
			</xsl:for-each>
		</div>
	</xsl:if>
	
	
	<input type="hidden" name="autocompetitions">
		<xsl:attribute name="value">
			<xsl:for-each select="msxsl:node-set($competitions)/competition[@sport=$sport]">
				<xsl:if test="$team = team/@fullname">
					<xsl:value-of select="@name"/><xsl:text> </xsl:text>
					<xsl:value-of select="@searchterms"/><xsl:text> </xsl:text>
				</xsl:if>
			</xsl:for-each>
		</xsl:attribute>
	</input>
	<input type="hidden" name="autonames">
		<xsl:attribute name="value">
			<xsl:for-each select="msxsl:node-set($competitions)/competition[@sport=$sport]/team">
				<xsl:if test="$team = @fullname">
					<xsl:value-of select="@searchterms"/><xsl:text> </xsl:text>
				</xsl:if>
			</xsl:for-each>
		</xsl:attribute>
	</input>
</xsl:template>


<!--
	HIDDEN FIELDS FOR AUTO TAGGING HOME AND AWAY
-->
<xsl:template name="AUTO_HIDDEN_FIELDS_TWO_TEAMS">
	<xsl:param name="team1"/>
	<xsl:param name="team1_label"/>
	<xsl:param name="team2"/>
	<xsl:param name="team2_label"/>
	
	<xsl:if test="$test_IsEditor"><span class="clearall"><br clear="all" /></span>
		<div class="editbox">
			<strong>Auto competition <xsl:value-of select="$team1_label"/> tags:</strong><xsl:text> </xsl:text>
				<xsl:for-each select="msxsl:node-set($competitions)/competition[@sport=$sport]">
					<xsl:if test="$team1 = team/@fullname">
						<xsl:value-of select="@name"/><xsl:text> </xsl:text>
						<xsl:value-of select="@searchterms"/><xsl:text> </xsl:text>
					</xsl:if>
				</xsl:for-each>
			<br /><strong>Auto name <xsl:value-of select="$team1_label"/> tags:</strong><xsl:text> </xsl:text>
			<xsl:for-each select="msxsl:node-set($competitions)/competition[@sport=$sport]/team">
				<xsl:if test="$team1 = @fullname">
					<xsl:value-of select="@searchterms"/><xsl:text> </xsl:text>
				</xsl:if>
			</xsl:for-each>
			<br />
			<br /><strong>Auto competition <xsl:value-of select="$team2_label"/> tags:</strong><xsl:text> </xsl:text>
				<xsl:for-each select="msxsl:node-set($competitions)/competition[@sport=$sport]">
					<xsl:if test="$team2 = team/@fullname">
						<xsl:value-of select="@name"/><xsl:text> </xsl:text>
						<xsl:value-of select="@searchterms"/><xsl:text> </xsl:text>
					</xsl:if>
				</xsl:for-each>
			<br /><strong>Auto name <xsl:value-of select="$team2_label"/> tags:</strong><xsl:text> </xsl:text>
			<xsl:for-each select="msxsl:node-set($competitions)/competition[@sport=$sport]/team">
				<xsl:if test="$team2 = @fullname">
					<xsl:value-of select="@searchterms"/><xsl:text> </xsl:text>
				</xsl:if>
			</xsl:for-each>
		</div>
	</xsl:if>
	
	<!-- populate -->
	<input type="hidden" name="autocompetitions">
		<xsl:attribute name="value">
			<xsl:for-each select="msxsl:node-set($competitions)/competition[@sport=$sport]">
				<xsl:if test="$team1 = team/@fullname">
					<xsl:value-of select="@name"/><xsl:text> </xsl:text>
					<xsl:value-of select="@searchterms"/><xsl:text> </xsl:text>
				</xsl:if>
			</xsl:for-each>
			<xsl:for-each select="msxsl:node-set($competitions)/competition[@sport=$sport]">
				<xsl:if test="$team2 = team/@fullname">
					<xsl:value-of select="@name"/><xsl:text> </xsl:text>
					<xsl:value-of select="@searchterms"/><xsl:text> </xsl:text>
				</xsl:if>
			</xsl:for-each>
		</xsl:attribute>
	</input>
	<input type="hidden" name="autonames">
		<xsl:attribute name="value">
			<xsl:for-each select="msxsl:node-set($competitions)/competition[@sport=$sport]/team">
				<xsl:if test="$team1 = @fullname">
					<xsl:value-of select="@searchterms"/><xsl:text> </xsl:text>
				</xsl:if>
			</xsl:for-each>
			<xsl:for-each select="msxsl:node-set($competitions)/competition[@sport=$sport]/team">
				<xsl:if test="$team2 = @fullname">
					<xsl:value-of select="@searchterms"/><xsl:text> </xsl:text>
				</xsl:if>
			</xsl:for-each>
		</xsl:attribute>
	</input>
</xsl:template>



<!-- 
#############################################################
	SUBMIT BUTTONS
#############################################################
-->

<!-- preview, create and edit buttons -->
<xsl:template name="SUBMIT_BUTTONS">

	<div>
		<xsl:attribute name="class">
			<xsl:text>inputaction </xsl:text>
			<xsl:if test="/H2G2/SITE/IDENTITYSIGNIN = 1">
				comm_inputaction
			</xsl:if>
		</xsl:attribute>
		
		<xsl:if test="/H2G2/MULTI-STAGE/@TYPE = 'TYPED-ARTICLE-EDIT'">
			<xsl:apply-templates select="." mode="c_articleeditbutton"/>
		</xsl:if>
		<xsl:apply-templates select="." mode="t_articlepreviewbutton"/>
		
		<!-- force user to preview before submitting by only presenting submit button when previewing and when no errors -->
		<xsl:if test="/H2G2/MULTI-STAGE/@TYPE='TYPED-ARTICLE-PREVIEW' or /H2G2/MULTI-STAGE/@TYPE='TYPED-ARTICLE-EDIT-PREVIEW' and not(*/ERRORS)">
			<xsl:apply-templates select="." mode="c_articleeditbutton"/>
			<xsl:apply-templates select="." mode="c_articlecreatebutton"/>
		</xsl:if>
	</div>	
	
</xsl:template>

<!-- submit buttons attributes -->
<xsl:attribute-set name="mMULTI-STAGE_r_articlecreatebutton">
	<xsl:attribute name="type">submit</xsl:attribute>
	<xsl:attribute name="value">publish</xsl:attribute>
	<xsl:attribute name="class">inputpre</xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="mMULTI-STAGE_t_articlepreviewbutton">
	<xsl:attribute name="type">submit</xsl:attribute>
	<xsl:attribute name="value">preview</xsl:attribute>
	<xsl:attribute name="class">inputpre</xsl:attribute>
</xsl:attribute-set>
	
<xsl:attribute-set name="mMULTI-STAGE_r_articleeditbutton">
	<xsl:attribute name="type">submit</xsl:attribute>
	<xsl:attribute name="value">publish</xsl:attribute>
	<xsl:attribute name="class">inputpre</xsl:attribute>
</xsl:attribute-set>


<!-- 
#############################################################
	SUGGEST A LINK
#############################################################
-->
<xsl:template name="SUGGEST_LINK">
	<xsl:param name="url"/>
	<xsl:param name="title"/>
	<div class="frow">
		<div class="labelone"><label for="articlelink">suggest a link</label></div>
		<input type="text" name="ARTICLELINK" id="articlelink" class="inputone">
			<xsl:attribute name="value">
				<xsl:value-of select="MULTI-ELEMENT[@NAME='ARTICLELINK']/VALUE-EDITABLE"/>
			</xsl:attribute>
		</input>
		<div class="inputinfo">eg: <xsl:value-of select="$url"/></div>
	</div>	
	<div class="frow">
		<div class="labelone"><label for="articlelinktitle">suggest a title for this link</label></div>
		<input type="text" name="ARTICLELINKTITLE" id="articlelinktitle" class="inputone">
		<xsl:attribute name="value">
				<xsl:value-of select="MULTI-ELEMENT[@NAME='ARTICLELINKTITLE']/VALUE-EDITABLE"/>
			</xsl:attribute>
		</input>
		<xsl:if test="not($article_subtype='team_profile')">
		<div class="inputinfo">eg: <xsl:value-of select="$title"/></div>
		</xsl:if>
		
	</div>	
</xsl:template>


<!-- 
#############################################################
	SELECTING A SPORT - links and dropdowns
#############################################################
-->

<xsl:template name="SELECT_SPORT">
<xsl:choose>
	<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_selectsport']">
		<!-- non-js user is editing an article and wants to change the sport (so has just selected the 'change sport?' link)  -->
		
		<!-- todo: THINK THIS CAN BE REMOVED - as people can no longer change the sport of an article after is has been published -->
		
		<h2 class="sportStep1">What sport are you writing about?</h2>
		<table cellpadding="0" cellspacing="0" border="0">
		<tr>
		<td width="47" valign="top" align="center">
			<img height="28" hspace="0" vspace="0" border="0" width="28" alt="1" src="{$imagesource}2.gif" />
		</td>
		<td width="381">
		<xsl:choose>
			<xsl:when test="$article_subtype='match_report'">
			<!-- MATCH REPORT -->
				<div class="noscript1">
					<ul>
						<li><div class="noscriptbox"><a href="{$root}TypedArticle?aedit=new&amp;type={/H2G2/MULTI-STAGE/MULTI-REQUIRED[@NAME='TYPE']/VALUE-EDITABLE}&amp;h2g2id={/H2G2/ARTICLE/ARTICLEINFO/H2G2ID}&amp;s_sport=football&amp;s_changedsport=1">Football</a></div></li>
						<li><div class="noscriptbox"><a href="{$root}TypedArticle?aedit=new&amp;type={/H2G2/MULTI-STAGE/MULTI-REQUIRED[@NAME='TYPE']/VALUE-EDITABLE}&amp;h2g2id={/H2G2/ARTICLE/ARTICLEINFO/H2G2ID}&amp;s_sport=rugby_union&amp;s_changedsport=1">Rugby union</a></div></li>
						<li><div class="noscriptbox"><a href="{$root}TypedArticle?aedit=new&amp;type={/H2G2/MULTI-STAGE/MULTI-REQUIRED[@NAME='TYPE']/VALUE-EDITABLE}&amp;h2g2id={/H2G2/ARTICLE/ARTICLEINFO/H2G2ID}&amp;s_sport=other&amp;s_changedsport=1">Other Sport</a></div></li>
							
					</ul>
				</div>
				<div class="noscript2">
					<ul>
						<li><div class="noscriptbox"><a href="{$root}TypedArticle?aedit=new&amp;type={/H2G2/MULTI-STAGE/MULTI-REQUIRED[@NAME='TYPE']/VALUE-EDITABLE}&amp;h2g2id={/H2G2/ARTICLE/ARTICLEINFO/H2G2ID}&amp;s_sport=rugby_league&amp;s_changedsport=1">Rugby league</a></div></li>
						<li><div class="noscriptbox"><a href="{$root}TypedArticle?aedit=new&amp;type={/H2G2/MULTI-STAGE/MULTI-REQUIRED[@NAME='TYPE']/VALUE-EDITABLE}&amp;h2g2id={/H2G2/ARTICLE/ARTICLEINFO/H2G2ID}&amp;s_sport=disability_sport&amp;s_changedsport=1">Disability sport</a></div></li>
					</ul>
				</div>
			</xsl:when>
			<xsl:when test="$article_subtype='event_report'">
			<!-- EVENT REPORT -->
				<div class="noscript1">
					<ul>
						<li><div class="noscriptbox"><a href="{$root}TypedArticle?aedit=new&amp;type={/H2G2/MULTI-STAGE/MULTI-REQUIRED[@NAME='TYPE']/VALUE-EDITABLE}&amp;h2g2id={/H2G2/ARTICLE/ARTICLEINFO/H2G2ID}&amp;s_sport=tennis&amp;s_changedsport=1">Tennis</a></div></li>
						<li><div class="noscriptbox"><a href="{$root}TypedArticle?aedit=new&amp;type={/H2G2/MULTI-STAGE/MULTI-REQUIRED[@NAME='TYPE']/VALUE-EDITABLE}&amp;h2g2id={/H2G2/ARTICLE/ARTICLEINFO/H2G2ID}&amp;s_sport=motorsport&amp;s_changedsport=1">Motorsport</a></div></li>
						<li><div class="noscriptbox"><a href="{$root}TypedArticle?aedit=new&amp;type={/H2G2/MULTI-STAGE/MULTI-REQUIRED[@NAME='TYPE']/VALUE-EDITABLE}&amp;h2g2id={/H2G2/ARTICLE/ARTICLEINFO/H2G2ID}&amp;s_sport=athletics&amp;s_changedsport=1">Athletics</a></div></li>
						<li><div class="noscriptbox"><a href="{$root}TypedArticle?aedit=new&amp;type={/H2G2/MULTI-STAGE/MULTI-REQUIRED[@NAME='TYPE']/VALUE-EDITABLE}&amp;h2g2id={/H2G2/ARTICLE/ARTICLEINFO/H2G2ID}&amp;s_sport=horse_racing&amp;s_changedsport=1">Horse racing</a></div></li>		
						<li><div class="noscriptbox"><a href="{$root}TypedArticle?aedit=new&amp;type={/H2G2/MULTI-STAGE/MULTI-REQUIRED[@NAME='TYPE']/VALUE-EDITABLE}&amp;h2g2id={/H2G2/ARTICLE/ARTICLEINFO/H2G2ID}&amp;s_sport=disability_sport&amp;s_changedsport=1">Disability sport</a></div></li>
					</ul>
				</div>
				<div class="noscript2">
					<ul>
						<li><div class="noscriptbox"><a href="{$root}TypedArticle?aedit=new&amp;type={/H2G2/MULTI-STAGE/MULTI-REQUIRED[@NAME='TYPE']/VALUE-EDITABLE}&amp;h2g2id={/H2G2/ARTICLE/ARTICLEINFO/H2G2ID}&amp;s_sport=cricket&amp;s_changedsport=1">Cricket</a></div></li>
						<li><div class="noscriptbox"><a href="{$root}TypedArticle?aedit=new&amp;type={/H2G2/MULTI-STAGE/MULTI-REQUIRED[@NAME='TYPE']/VALUE-EDITABLE}&amp;h2g2id={/H2G2/ARTICLE/ARTICLEINFO/H2G2ID}&amp;s_sport=golf&amp;s_changedsport=1">Golf</a></div></li>
						<li><div class="noscriptbox"><a href="{$root}TypedArticle?aedit=new&amp;type={/H2G2/MULTI-STAGE/MULTI-REQUIRED[@NAME='TYPE']/VALUE-EDITABLE}&amp;h2g2id={/H2G2/ARTICLE/ARTICLEINFO/H2G2ID}&amp;s_sport=boxing&amp;s_changedsport=1">Boxing</a></div></li>
						<li><div class="noscriptbox"><a href="{$root}TypedArticle?aedit=new&amp;type={/H2G2/MULTI-STAGE/MULTI-REQUIRED[@NAME='TYPE']/VALUE-EDITABLE}&amp;h2g2id={/H2G2/ARTICLE/ARTICLEINFO/H2G2ID}&amp;s_sport=snooker&amp;s_changedsport=1">Snooker</a></div></li>
						<li><div class="noscriptbox"><a href="{$root}TypedArticle?aedit=new&amp;type={/H2G2/MULTI-STAGE/MULTI-REQUIRED[@NAME='TYPE']/VALUE-EDITABLE}&amp;h2g2id={/H2G2/ARTICLE/ARTICLEINFO/H2G2ID}&amp;s_sport=cycling&amp;s_changedsport=1">Cycling</a></div></li>
						<li><div class="noscriptbox"><a href="{$root}TypedArticle?aedit=new&amp;type={/H2G2/MULTI-STAGE/MULTI-REQUIRED[@NAME='TYPE']/VALUE-EDITABLE}&amp;h2g2id={/H2G2/ARTICLE/ARTICLEINFO/H2G2ID}&amp;s_sport=other&amp;s_changedsport=1">Other Sport</a></div></li>
					</ul>
				</div>
			</xsl:when>
			<xsl:otherwise>
			<!-- ALL OTHER ARTICLES -->
				<div class="noscript1">
					<ul>
						<li><div class="noscriptbox"><a href="{$root}TypedArticle?aedit=new&amp;type={/H2G2/MULTI-STAGE/MULTI-REQUIRED[@NAME='TYPE']/VALUE-EDITABLE}&amp;h2g2id={/H2G2/ARTICLE/ARTICLEINFO/H2G2ID}&amp;s_sport=football&amp;s_changedsport=1">Football</a></div></li>
						<li><div class="noscriptbox"><a href="{$root}TypedArticle?aedit=new&amp;type={/H2G2/MULTI-STAGE/MULTI-REQUIRED[@NAME='TYPE']/VALUE-EDITABLE}&amp;h2g2id={/H2G2/ARTICLE/ARTICLEINFO/H2G2ID}&amp;s_sport=rugby_union&amp;s_changedsport=1">Rugby union</a></div></li>
						<li><div class="noscriptbox"><a href="{$root}TypedArticle?aedit=new&amp;type={/H2G2/MULTI-STAGE/MULTI-REQUIRED[@NAME='TYPE']/VALUE-EDITABLE}&amp;h2g2id={/H2G2/ARTICLE/ARTICLEINFO/H2G2ID}&amp;s_sport=tennis&amp;s_changedsport=1">Tennis</a></div></li>
						<li><div class="noscriptbox"><a href="{$root}TypedArticle?aedit=new&amp;type={/H2G2/MULTI-STAGE/MULTI-REQUIRED[@NAME='TYPE']/VALUE-EDITABLE}&amp;h2g2id={/H2G2/ARTICLE/ARTICLEINFO/H2G2ID}&amp;s_sport=motorsport&amp;s_changedsport=1">Motorsport</a></div></li>
						<li><div class="noscriptbox"><a href="{$root}TypedArticle?aedit=new&amp;type={/H2G2/MULTI-STAGE/MULTI-REQUIRED[@NAME='TYPE']/VALUE-EDITABLE}&amp;h2g2id={/H2G2/ARTICLE/ARTICLEINFO/H2G2ID}&amp;s_sport=athletics&amp;s_changedsport=1">Athletics</a></div></li>
						<li><div class="noscriptbox"><a href="{$root}TypedArticle?aedit=new&amp;type={/H2G2/MULTI-STAGE/MULTI-REQUIRED[@NAME='TYPE']/VALUE-EDITABLE}&amp;h2g2id={/H2G2/ARTICLE/ARTICLEINFO/H2G2ID}&amp;s_sport=horse_racing&amp;s_changedsport=1">Horse racing</a></div></li>		
						<li><div class="noscriptbox"><a href="{$root}TypedArticle?aedit=new&amp;type={/H2G2/MULTI-STAGE/MULTI-REQUIRED[@NAME='TYPE']/VALUE-EDITABLE}&amp;h2g2id={/H2G2/ARTICLE/ARTICLEINFO/H2G2ID}&amp;s_sport=disability_sport&amp;s_changedsport=1">Disability sport</a></div></li>
					</ul>
				</div>
				<div class="noscript2">
					<ul>
						<li><div class="noscriptbox"><a href="{$root}TypedArticle?aedit=new&amp;type={/H2G2/MULTI-STAGE/MULTI-REQUIRED[@NAME='TYPE']/VALUE-EDITABLE}&amp;h2g2id={/H2G2/ARTICLE/ARTICLEINFO/H2G2ID}&amp;s_sport=cricket&amp;s_changedsport=1">Cricket</a></div></li>
						<li><div class="noscriptbox"><a href="{$root}TypedArticle?aedit=new&amp;type={/H2G2/MULTI-STAGE/MULTI-REQUIRED[@NAME='TYPE']/VALUE-EDITABLE}&amp;h2g2id={/H2G2/ARTICLE/ARTICLEINFO/H2G2ID}&amp;s_sport=rugby_league&amp;s_changedsport=1">Rugby league</a></div></li>
						<li><div class="noscriptbox"><a href="{$root}TypedArticle?aedit=new&amp;type={/H2G2/MULTI-STAGE/MULTI-REQUIRED[@NAME='TYPE']/VALUE-EDITABLE}&amp;h2g2id={/H2G2/ARTICLE/ARTICLEINFO/H2G2ID}&amp;s_sport=golf&amp;s_changedsport=1">Golf</a></div></li>
						<li><div class="noscriptbox"><a href="{$root}TypedArticle?aedit=new&amp;type={/H2G2/MULTI-STAGE/MULTI-REQUIRED[@NAME='TYPE']/VALUE-EDITABLE}&amp;h2g2id={/H2G2/ARTICLE/ARTICLEINFO/H2G2ID}&amp;s_sport=boxing&amp;s_changedsport=1">Boxing</a></div></li>
						<li><div class="noscriptbox"><a href="{$root}TypedArticle?aedit=new&amp;type={/H2G2/MULTI-STAGE/MULTI-REQUIRED[@NAME='TYPE']/VALUE-EDITABLE}&amp;h2g2id={/H2G2/ARTICLE/ARTICLEINFO/H2G2ID}&amp;s_sport=snooker&amp;s_changedsport=1">Snooker</a></div></li>
						<li><div class="noscriptbox"><a href="{$root}TypedArticle?aedit=new&amp;type={/H2G2/MULTI-STAGE/MULTI-REQUIRED[@NAME='TYPE']/VALUE-EDITABLE}&amp;h2g2id={/H2G2/ARTICLE/ARTICLEINFO/H2G2ID}&amp;s_sport=cycling&amp;s_changedsport=1">Cycling</a></div></li>
						<li><div class="noscriptbox"><a href="{$root}TypedArticle?aedit=new&amp;type={/H2G2/MULTI-STAGE/MULTI-REQUIRED[@NAME='TYPE']/VALUE-EDITABLE}&amp;h2g2id={/H2G2/ARTICLE/ARTICLEINFO/H2G2ID}&amp;s_sport=other&amp;s_changedsport=1">Other Sport</a></div></li>
					</ul>
				</div>
			</xsl:otherwise>
		</xsl:choose>
		
					
		</td>
		</tr>
		</table>
	</xsl:when>
	<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_changedsport']">
		<!-- non-js user is editing an article and has changed the sport (by clicking on a sport link above) 
			so need to use s_param to determine sport (rather than MULTI-ELEMENT VALUE) -->
		
		<!-- TO DO: THINK THIS CAN BE REMOVED as people can no longer change sport after an article has been submitted/created -->
		<div class="requiredKey"><span class="required">*</span> compulsory fields</div>
		
		<table cellpadding="0" cellspacing="0" border="2" class="clear">
		<!-- step 1 -->
		<tr>
		<td width="35" valign="top">		
		<img height="28" hspace="0" vspace="0" border="0" width="28" alt="1" src="{$imagesource}1.gif" />
		</td>
		<td width="581">
		
		<xsl:choose>
			<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_sport']/VALUE = 'football'">
				<div class="frow">
					<input type="hidden" name="SPORT" value="Football"/>
					<div class="labelone"><label for="selectsport">sport<span class="required">*</span></label></div>
					<span class="selectedsport">Football</span>
					<xsl:call-template name="CHANGE_SPORT" />
				</div>	
				<xsl:call-template name="FOOTBALL_DROP_DOWNS" />
			</xsl:when>
			<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_sport']/VALUE = 'cricket'">
				<div class="frow">
					<input type="hidden" name="SPORT" value="Cricket"/>
					<div class="labelone"><label for="selectsport">sport<span class="required">*</span></label></div>
					<span class="selectedsport">Cricket</span>
					<xsl:call-template name="CHANGE_SPORT" />
				</div>
				<xsl:call-template name="CRICKET_DROP_DOWNS" />
			</xsl:when>
			<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_sport']/VALUE = 'rugby_union'">
				<div class="frow">
					<input type="hidden" name="SPORT" value="Rugby union"/>
					<div class="labelone"><label for="selectsport">sport<span class="required">*</span></label></div>
					<span class="selectedsport">Rugby union</span>
					<xsl:call-template name="CHANGE_SPORT" />
				</div>
				<xsl:call-template name="RUGBY_UNION_DROP_DOWNS" />
			</xsl:when>
			<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_sport']/VALUE = 'rugby_league'">
				<div class="frow">
					<input type="hidden" name="SPORT" value="Rugby league"/>
					<div class="labelone"><label for="selectsport">sport<span class="required">*</span></label></div>
					<span class="selectedsport">Rugby league</span>
					<xsl:call-template name="CHANGE_SPORT" />
				</div>
				<xsl:call-template name="RUGBY_LEAGUE_DROP_DOWNS" />
			</xsl:when>
			<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_sport']/VALUE = 'tennis'">
				<div class="frow">
					<input type="hidden" name="SPORT" value="Tennis"/>
					<div class="labelone"><label for="selectsport">sport<span class="required">*</span></label></div>
					<span class="selectedsport">Tennis</span>
					<xsl:call-template name="CHANGE_SPORT" />
				</div>
				<xsl:call-template name="TENNIS_DROP_DOWNS" />
			</xsl:when>
			<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_sport']/VALUE = 'golf'">
				<div class="frow">
					<input type="hidden" name="SPORT" value="Golf"/>
					<div class="labelone"><label for="selectsport">sport<span class="required">*</span></label></div>
					<span class="selectedsport">Golf</span>
					<xsl:call-template name="CHANGE_SPORT" />
				</div>
				<xsl:call-template name="GOLF_DROP_DOWNS" />
			</xsl:when>
			<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_sport']/VALUE = 'motorsport'">
				<div class="frow">
					<input type="hidden" name="SPORT" value="Motorsport"/>
					<div class="labelone"><label for="selectsport">sport<span class="required">*</span></label></div>
					<span class="selectedsport">Motorsport</span>
					<xsl:call-template name="CHANGE_SPORT" />
				</div>
				<xsl:call-template name="MOTORSPORT_DROP_DOWNS" />
			</xsl:when>
			<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_sport']/VALUE = 'boxing'">
				<div class="frow">
					<input type="hidden" name="SPORT" value="Boxing"/>
					<div class="labelone"><label for="selectsport">sport<span class="required">*</span></label></div>
					<span class="selectedsport">Boxing</span>
					<xsl:call-template name="CHANGE_SPORT" />
				</div>
				<xsl:call-template name="BOXING_DROP_DOWNS" />
			</xsl:when>
			<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_sport']/VALUE = 'athletics'">
				<div class="frow">
					<input type="hidden" name="SPORT" value="Athletics"/>
					<div class="labelone"><label for="selectsport">sport<span class="required">*</span></label></div>
					<span class="selectedsport">Athletics</span>
					<xsl:call-template name="CHANGE_SPORT" />
				</div>
				<xsl:call-template name="ATHLETICS_DROP_DOWNS" />
			</xsl:when>
			<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_sport']/VALUE = 'snooker'">
				<div class="frow">
					<input type="hidden" name="SPORT" value="Snooker"/>
					<div class="labelone"><label for="selectsport">sport<span class="required">*</span></label></div>
					<span class="selectedsport">Snooker</span>
					<xsl:call-template name="CHANGE_SPORT" />
				</div>
				<xsl:call-template name="SNOOKER_DROP_DOWNS" />
			</xsl:when>
			<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_sport']/VALUE = 'horse_racing'">
				<div class="frow">
					<input type="hidden" name="SPORT" value="Horse racing"/>
					<div class="labelone"><label for="selectsport">sport<span class="required">*</span></label></div>
					<span class="selectedsport">Horse racing</span>
					<xsl:call-template name="CHANGE_SPORT" />
				</div>
				<xsl:call-template name="HORSE_RACING_DROP_DOWNS" />
			</xsl:when>
			<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_sport']/VALUE = 'cycling'">
				<div class="frow">
					<input type="hidden" name="SPORT" value="Cycling"/>
					<div class="labelone"><label for="selectsport">sport<span class="required">*</span></label></div>
					<span class="selectedsport">Cycling</span>
					<xsl:call-template name="CHANGE_SPORT" />
				</div>
				<xsl:call-template name="CYCLING_DROP_DOWNS" />
			</xsl:when>
			<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_sport']/VALUE = 'disability_sport'">
				<div class="frow">
					<input type="hidden" name="SPORT" value="Disability sport"/>
					<div class="labelone"><label for="selectsport">sport<span class="required">*</span></label></div>
					<span class="selectedsport">Disability sport</span>
					<xsl:call-template name="CHANGE_SPORT" />
				</div>
				<xsl:call-template name="DISABILITY_SPORT_DROP_DOWNS" />
			</xsl:when>
			<xsl:otherwise>
				<div class="frow">
					<input type="hidden" name="SPORT" value="Othersport"/>
					<div class="labelone"><label for="selectsport">sport<span class="required">*</span></label></div>
					<span class="selectedsport">Other Sport</span>
					<xsl:call-template name="CHANGE_SPORT" />
				</div>
				<xsl:call-template name="OTHER_SPORT_DROP_DOWNS" />
			</xsl:otherwise>
		</xsl:choose>
		
		<!-- TEAM PROFILE -->
		<xsl:call-template name="TEAM_PROFILE_TEAM_INPUTBOX" />
					
		</td>
		</tr>
		</table>
	</xsl:when>
	<xsl:when test="/H2G2/MULTI-STAGE/MULTI-ELEMENT[@NAME='SPORT']/VALUE/text() or /H2G2/PARAMS/PARAM[NAME = 's_sport']">
		<div class="requiredKey"><span class="required">*</span> compulsory fields</div>
		
		<!-- for non-js users - creating, editing and previewing -->
		<h2 class="formStep1">What you choose here will help other fans find what you've created</h2>
		<table cellpadding="0" cellspacing="0" border="0" class="clear">
		<!-- step 1 -->
		<tr>
		<td width="47" valign="top" align="center">
			<img height="28" hspace="0" vspace="0" border="0" width="28" alt="1" src="{$imagesource}1.gif" />
		</td>
		<td width="581">
		
		<xsl:choose>
			<xsl:when test="/H2G2/MULTI-STAGE/MULTI-ELEMENT[@NAME='SPORT']/VALUE='Football' or /H2G2/PARAMS/PARAM[NAME = 's_sport']/VALUE = 'football'">
				<div class="frow">
					<input type="hidden" name="SPORT" value="Football"/>
					<div class="labelone"><label for="selectsport">sport<span class="required">*</span></label></div>
					<span class="selectedsport">Football</span>
					<xsl:call-template name="CHANGE_SPORT" />
				</div>	
				<xsl:call-template name="FOOTBALL_DROP_DOWNS" />
			</xsl:when>
			<xsl:when test="/H2G2/MULTI-STAGE/MULTI-ELEMENT[@NAME='SPORT']/VALUE='Cricket' or /H2G2/PARAMS/PARAM[NAME = 's_sport']/VALUE = 'cricket'">
				<div class="frow">
					<input type="hidden" name="SPORT" value="Cricket"/>
					<div class="labelone"><label for="selectsport">sport<span class="required">*</span></label></div>
					<span class="selectedsport">Cricket</span>
					<xsl:call-template name="CHANGE_SPORT" />
				</div>
				<xsl:call-template name="CRICKET_DROP_DOWNS" />
			</xsl:when>
			<xsl:when test="/H2G2/MULTI-STAGE/MULTI-ELEMENT[@NAME='SPORT']/VALUE='Rugby union' or /H2G2/PARAMS/PARAM[NAME = 's_sport']/VALUE = 'rugby_union'">
				<div class="frow">
					<input type="hidden" name="SPORT" value="Rugby union"/>
					<div class="labelone"><label for="selectsport">sport<span class="required">*</span></label></div>
					<span class="selectedsport">Rugby union</span>
					<xsl:call-template name="CHANGE_SPORT" />
				</div>
				<xsl:call-template name="RUGBY_UNION_DROP_DOWNS" />
			</xsl:when>
			<xsl:when test="/H2G2/MULTI-STAGE/MULTI-ELEMENT[@NAME='SPORT']/VALUE='Rugby league' or /H2G2/PARAMS/PARAM[NAME = 's_sport']/VALUE = 'rugby_league'">
				<div class="frow">
					<input type="hidden" name="SPORT" value="Rugby league"/>
					<div class="labelone"><label for="selectsport">sport<span class="required">*</span></label></div>
					<span class="selectedsport">Rugby league</span>
					<xsl:call-template name="CHANGE_SPORT" />
				</div>
				<xsl:call-template name="RUGBY_LEAGUE_DROP_DOWNS" />
			</xsl:when>
			<xsl:when test="/H2G2/MULTI-STAGE/MULTI-ELEMENT[@NAME='SPORT']/VALUE='Tennis' or /H2G2/PARAMS/PARAM[NAME = 's_sport']/VALUE = 'tennis'">
				<div class="frow">
					<input type="hidden" name="SPORT" value="Tennis"/>
					<div class="labelone"><label for="selectsport">sport<span class="required">*</span></label></div>
					<span class="selectedsport">Tennis</span>
					<xsl:call-template name="CHANGE_SPORT" />
				</div>
				<xsl:call-template name="TENNIS_DROP_DOWNS" />
			</xsl:when>
			<xsl:when test="/H2G2/MULTI-STAGE/MULTI-ELEMENT[@NAME='SPORT']/VALUE='Golf' or /H2G2/PARAMS/PARAM[NAME = 's_sport']/VALUE = 'golf'">
				<div class="frow">
					<input type="hidden" name="SPORT" value="Golf"/>
					<div class="labelone"><label for="selectsport">sport<span class="required">*</span></label></div>
					<span class="selectedsport">Golf</span>
					<xsl:call-template name="CHANGE_SPORT" />
				</div>
				<xsl:call-template name="GOLF_DROP_DOWNS" />
			</xsl:when>
			<xsl:when test="/H2G2/MULTI-STAGE/MULTI-ELEMENT[@NAME='SPORT']/VALUE='Motorsport' or /H2G2/PARAMS/PARAM[NAME = 's_sport']/VALUE = 'motorsport'">
				<div class="frow">
					<input type="hidden" name="SPORT" value="Motorsport"/>
					<div class="labelone"><label for="selectsport">sport<span class="required">*</span></label></div>
					<span class="selectedsport">Motorsport</span>
					<xsl:call-template name="CHANGE_SPORT" />
				</div>
				<xsl:call-template name="MOTORSPORT_DROP_DOWNS" />
			</xsl:when>
			<!--[FIXME: duplicated??]
			<xsl:when test="/H2G2/MULTI-STAGE/MULTI-ELEMENT[@NAME='SPORT']/VALUE='Tennis' or /H2G2/PARAMS/PARAM[NAME = 's_sport']/VALUE = 'tennis'">
				<div class="frow">
					<input type="hidden" name="SPORT" value="Tennis"/>
					<div class="labelone"><label for="selectsport">sport<span class="required">*</span></label></div>
					<span class="selectedsport">Tennis</span>
					<xsl:call-template name="CHANGE_SPORT" />
				</div>

				<xsl:choose>
					<xsl:when test="$article_subtype='event_report'">
						<div class="formSubRow">
							<xsl:call-template name="EVENT_REPORT_OTHER_COMPETITION"/>
						</div>
					</xsl:when>
					<xsl:when test="$article_subtype='team_profile'">
						<div class="formSubRow">
							<xsl:call-template name="TEAM_PROFILE_TEAM_INPUTBOX" />
						</div>
						<div class="formSubRow">
							<xsl:call-template name="TEAM_PROFILE_OTHER_COMPETITION"/>
						</div>
					</xsl:when>
				</xsl:choose>
			</xsl:when>
			-->
			<xsl:when test="/H2G2/MULTI-STAGE/MULTI-ELEMENT[@NAME='SPORT']/VALUE='Boxing' or /H2G2/PARAMS/PARAM[NAME = 's_sport']/VALUE = 'boxing'">
				<div class="frow">
					<input type="hidden" name="SPORT" value="Boxing"/>
					<div class="labelone"><label for="selectsport">sport<span class="required">*</span></label></div>
					<span class="selectedsport">Boxing</span>
					<xsl:call-template name="CHANGE_SPORT" />
				</div>
				<xsl:call-template name="BOXING_DROP_DOWNS" />
			</xsl:when>
			<xsl:when test="/H2G2/MULTI-STAGE/MULTI-ELEMENT[@NAME='SPORT']/VALUE='Athletics' or /H2G2/PARAMS/PARAM[NAME = 's_sport']/VALUE = 'athletics'">
				<div class="frow">
					<input type="hidden" name="SPORT" value="Athletics"/>
					<div class="labelone"><label for="selectsport">sport<span class="required">*</span></label></div>
					<span class="selectedsport">Athletics</span>
					<xsl:call-template name="CHANGE_SPORT" />
				</div>
				<xsl:call-template name="ATHLETICS_DROP_DOWNS" />
			</xsl:when>
			<xsl:when test="/H2G2/MULTI-STAGE/MULTI-ELEMENT[@NAME='SPORT']/VALUE='Snooker' or /H2G2/PARAMS/PARAM[NAME = 's_sport']/VALUE = 'snooker'">
				<div class="frow">
					<input type="hidden" name="SPORT" value="Snooker"/>
					<div class="labelone"><label for="selectsport">sport<span class="required">*</span></label></div>
					<span class="selectedsport">Snooker</span>
					<xsl:call-template name="CHANGE_SPORT" />
				</div>
				<xsl:call-template name="SNOOKER_DROP_DOWNS" />
			</xsl:when>
			<xsl:when test="/H2G2/MULTI-STAGE/MULTI-ELEMENT[@NAME='SPORT']/VALUE='Horse racing' or /H2G2/PARAMS/PARAM[NAME = 's_sport']/VALUE = 'horse_racing'">
				<div class="frow">
					<input type="hidden" name="SPORT" value="Horse racing"/>
					<div class="labelone"><label for="selectsport">sport<span class="required">*</span></label></div>
					<span class="selectedsport">Horse racing</span>
					<xsl:call-template name="CHANGE_SPORT" />
				</div>
				<xsl:call-template name="HORSE_RACING_DROP_DOWNS" />
			</xsl:when>
			<xsl:when test="/H2G2/MULTI-STAGE/MULTI-ELEMENT[@NAME='SPORT']/VALUE='Cycling' or /H2G2/PARAMS/PARAM[NAME = 's_sport']/VALUE = 'cycling'">
				<div class="frow">
					<input type="hidden" name="SPORT" value="Cycling"/>
					<div class="labelone"><label for="selectsport">sport<span class="required">*</span></label></div>
					<span class="selectedsport">Cycling</span>
					<xsl:call-template name="CHANGE_SPORT" />
				</div>
				<xsl:call-template name="CYCLING_DROP_DOWNS" />
			</xsl:when>
			<!--[FIXME: take out for now]
			<xsl:when test="/H2G2/MULTI-STAGE/MULTI-ELEMENT[@NAME='SPORT']/VALUE='Disability sport' or /H2G2/PARAMS/PARAM[NAME = 's_sport']/VALUE = 'disability_sport'">
				<div class="frow">
					<input type="hidden" name="SPORT" value="Disability sport"/>
					<div class="labelone"><label for="selectsport">sport<span class="required">*</span></label></div>
					<span class="selectedsport">Disability sport</span>
					<xsl:call-template name="CHANGE_SPORT" />
				</div>
				<xsl:call-template name="DISABILITY_SPORT_DROP_DOWNS" />
			</xsl:when>
			-->
			<xsl:otherwise>
				<div class="frow">
					<input type="hidden" name="SPORT" value="Othersport"/>
					<div class="labelone"><label for="selectsport">sport<span class="required">*</span></label></div>
					<span class="selectedsport">Other Sport</span>
					<xsl:call-template name="CHANGE_SPORT" />
				</div>
				<xsl:call-template name="OTHER_SPORT_DROP_DOWNS" />
			</xsl:otherwise>
		</xsl:choose>
		
		</td>
		</tr>
		</table>
	
	</xsl:when>
	<xsl:otherwise>
		<h2 class="sportStep1">What sport are you writing about?</h2>
		<!-- non-js user is creating an article - this is step 2 - need to first select a sport so they can be presented with the relevent dropdowns for teams and competitions -->
		<table cellpadding="0" cellspacing="0" border="0">
		<tr>
		<td width="47" valign="top" align="center">
			<img height="28" hspace="0" vspace="0" border="0" width="28" alt="1" src="{$imagesource}2.gif" />
		</td>
		<td width="381">
		<xsl:choose>
			<xsl:when test="$article_subtype='match_report'">
				<!-- MATCH REPORT -->
				<div class="noscript1">
					<ul>
						<li><div class="noscriptbox"><a href="{$root}TypedArticle?acreate=new&amp;type={/H2G2/MULTI-STAGE/MULTI-REQUIRED[@NAME='TYPE']/VALUE-EDITABLE}&amp;s_sport=football">Football</a></div></li>
						<li><div class="noscriptbox"><a href="{$root}TypedArticle?acreate=new&amp;type={/H2G2/MULTI-STAGE/MULTI-REQUIRED[@NAME='TYPE']/VALUE-EDITABLE}&amp;s_sport=rugby_union">Rugby union</a></div></li>
						<li><div class="noscriptbox"><a href="{$root}TypedArticle?acreate=new&amp;type={/H2G2/MULTI-STAGE/MULTI-REQUIRED[@NAME='TYPE']/VALUE-EDITABLE}&amp;s_sport=tennis">Tennis</a></div></li>
						<li><div class="noscriptbox"><a href="{$root}TypedArticle?acreate=new&amp;type={/H2G2/MULTI-STAGE/MULTI-REQUIRED[@NAME='TYPE']/VALUE-EDITABLE}&amp;s_sport=motorsport">Motorsport</a></div></li>
						<li><div class="noscriptbox"><a href="{$root}TypedArticle?acreate=new&amp;type={/H2G2/MULTI-STAGE/MULTI-REQUIRED[@NAME='TYPE']/VALUE-EDITABLE}&amp;s_sport=athletics">Athletics</a></div></li>
						<li><div class="noscriptbox"><a href="{$root}TypedArticle?acreate=new&amp;type={/H2G2/MULTI-STAGE/MULTI-REQUIRED[@NAME='TYPE']/VALUE-EDITABLE}&amp;s_sport=horse_racing">Horse racing</a></div></li>		
						<!--[FIXME: take out for now]
						<li><div class="noscriptbox"><a href="{$root}TypedArticle?acreate=new&amp;type={/H2G2/MULTI-STAGE/MULTI-REQUIRED[@NAME='TYPE']/VALUE-EDITABLE}&amp;s_sport=disability_sport">Disability sport</a></div></li>
						-->
					</ul>
				</div>
				<div class="noscript2">
					<ul>
						<li><div class="noscriptbox"><a href="{$root}TypedArticle?acreate=new&amp;type={/H2G2/MULTI-STAGE/MULTI-REQUIRED[@NAME='TYPE']/VALUE-EDITABLE}&amp;s_sport=cricket">Cricket</a></div></li>
						<li><div class="noscriptbox"><a href="{$root}TypedArticle?acreate=new&amp;type={/H2G2/MULTI-STAGE/MULTI-REQUIRED[@NAME='TYPE']/VALUE-EDITABLE}&amp;s_sport=rugby_league">Rugby league</a></div></li>
						<li><div class="noscriptbox"><a href="{$root}TypedArticle?acreate=new&amp;type={/H2G2/MULTI-STAGE/MULTI-REQUIRED[@NAME='TYPE']/VALUE-EDITABLE}&amp;s_sport=golf">Golf</a></div></li>
						<li><div class="noscriptbox"><a href="{$root}TypedArticle?acreate=new&amp;type={/H2G2/MULTI-STAGE/MULTI-REQUIRED[@NAME='TYPE']/VALUE-EDITABLE}&amp;s_sport=boxing">Boxing</a></div></li>
						<li><div class="noscriptbox"><a href="{$root}TypedArticle?acreate=new&amp;type={/H2G2/MULTI-STAGE/MULTI-REQUIRED[@NAME='TYPE']/VALUE-EDITABLE}&amp;s_sport=snooker">Snooker</a></div></li>
						<li><div class="noscriptbox"><a href="{$root}TypedArticle?acreate=new&amp;type={/H2G2/MULTI-STAGE/MULTI-REQUIRED[@NAME='TYPE']/VALUE-EDITABLE}&amp;s_sport=cycling">Cycling</a></div></li>
						<li><div class="noscriptbox"><a href="{$root}TypedArticle?acreate=new&amp;type={/H2G2/MULTI-STAGE/MULTI-REQUIRED[@NAME='TYPE']/VALUE-EDITABLE}&amp;s_sport=other">Other Sport</a></div></li>
					</ul>
				</div>
				<!--
				<div class="noscript1">
					<ul>
						<li><div class="noscriptbox"><a href="{$root}TypedArticle?acreate=new&amp;type={/H2G2/MULTI-STAGE/MULTI-REQUIRED[@NAME='TYPE']/VALUE-EDITABLE}&amp;s_sport=football">Football</a></div></li>
						<li><div class="noscriptbox"><a href="{$root}TypedArticle?acreate=new&amp;type={/H2G2/MULTI-STAGE/MULTI-REQUIRED[@NAME='TYPE']/VALUE-EDITABLE}&amp;s_sport=rugby_union">Rugby union</a></div></li>
						<li><div class="noscriptbox"><a href="{$root}TypedArticle?acreate=new&amp;type={/H2G2/MULTI-STAGE/MULTI-REQUIRED[@NAME='TYPE']/VALUE-EDITABLE}&amp;s_sport=other">Other Sport</a></div></li>
							
					</ul>
				</div>
				<div class="noscript2">
					<ul>
						<li><div class="noscriptbox"><a href="{$root}TypedArticle?acreate=new&amp;type={/H2G2/MULTI-STAGE/MULTI-REQUIRED[@NAME='TYPE']/VALUE-EDITABLE}&amp;s_sport=rugby_league">Rugby league</a></div></li>
						<li><div class="noscriptbox"><a href="{$root}TypedArticle?acreate=new&amp;type={/H2G2/MULTI-STAGE/MULTI-REQUIRED[@NAME='TYPE']/VALUE-EDITABLE}&amp;s_sport=disability_sport">Disability sport</a></div></li>
					</ul>
				</div>
				-->
			</xsl:when>
			<xsl:when test="$article_subtype='event_report'">
				<!-- EVENT REPORT -->
				<div class="noscript1">
					<ul>
						<li><div class="noscriptbox"><a href="{$root}TypedArticle?acreate=new&amp;type={/H2G2/MULTI-STAGE/MULTI-REQUIRED[@NAME='TYPE']/VALUE-EDITABLE}&amp;s_sport=football">Football</a></div></li>
						<li><div class="noscriptbox"><a href="{$root}TypedArticle?acreate=new&amp;type={/H2G2/MULTI-STAGE/MULTI-REQUIRED[@NAME='TYPE']/VALUE-EDITABLE}&amp;s_sport=rugby_union">Rugby union</a></div></li>
						<li><div class="noscriptbox"><a href="{$root}TypedArticle?acreate=new&amp;type={/H2G2/MULTI-STAGE/MULTI-REQUIRED[@NAME='TYPE']/VALUE-EDITABLE}&amp;s_sport=tennis">Tennis</a></div></li>
						<li><div class="noscriptbox"><a href="{$root}TypedArticle?acreate=new&amp;type={/H2G2/MULTI-STAGE/MULTI-REQUIRED[@NAME='TYPE']/VALUE-EDITABLE}&amp;s_sport=motorsport">Motorsport</a></div></li>
						<li><div class="noscriptbox"><a href="{$root}TypedArticle?acreate=new&amp;type={/H2G2/MULTI-STAGE/MULTI-REQUIRED[@NAME='TYPE']/VALUE-EDITABLE}&amp;s_sport=athletics">Athletics</a></div></li>
						<li><div class="noscriptbox"><a href="{$root}TypedArticle?acreate=new&amp;type={/H2G2/MULTI-STAGE/MULTI-REQUIRED[@NAME='TYPE']/VALUE-EDITABLE}&amp;s_sport=horse_racing">Horse racing</a></div></li>		
						<!--[FIXME: take out for now]
						<li><div class="noscriptbox"><a href="{$root}TypedArticle?acreate=new&amp;type={/H2G2/MULTI-STAGE/MULTI-REQUIRED[@NAME='TYPE']/VALUE-EDITABLE}&amp;s_sport=disability_sport">Disability sport</a></div></li>
						-->
					</ul>
				</div>
				<div class="noscript2">
					<ul>
						<li><div class="noscriptbox"><a href="{$root}TypedArticle?acreate=new&amp;type={/H2G2/MULTI-STAGE/MULTI-REQUIRED[@NAME='TYPE']/VALUE-EDITABLE}&amp;s_sport=cricket">Cricket</a></div></li>
						<li><div class="noscriptbox"><a href="{$root}TypedArticle?acreate=new&amp;type={/H2G2/MULTI-STAGE/MULTI-REQUIRED[@NAME='TYPE']/VALUE-EDITABLE}&amp;s_sport=rugby_league">Rugby league</a></div></li>
						<li><div class="noscriptbox"><a href="{$root}TypedArticle?acreate=new&amp;type={/H2G2/MULTI-STAGE/MULTI-REQUIRED[@NAME='TYPE']/VALUE-EDITABLE}&amp;s_sport=golf">Golf</a></div></li>
						<li><div class="noscriptbox"><a href="{$root}TypedArticle?acreate=new&amp;type={/H2G2/MULTI-STAGE/MULTI-REQUIRED[@NAME='TYPE']/VALUE-EDITABLE}&amp;s_sport=boxing">Boxing</a></div></li>
						<li><div class="noscriptbox"><a href="{$root}TypedArticle?acreate=new&amp;type={/H2G2/MULTI-STAGE/MULTI-REQUIRED[@NAME='TYPE']/VALUE-EDITABLE}&amp;s_sport=snooker">Snooker</a></div></li>
						<li><div class="noscriptbox"><a href="{$root}TypedArticle?acreate=new&amp;type={/H2G2/MULTI-STAGE/MULTI-REQUIRED[@NAME='TYPE']/VALUE-EDITABLE}&amp;s_sport=cycling">Cycling</a></div></li>
						<li><div class="noscriptbox"><a href="{$root}TypedArticle?acreate=new&amp;type={/H2G2/MULTI-STAGE/MULTI-REQUIRED[@NAME='TYPE']/VALUE-EDITABLE}&amp;s_sport=other">Other Sport</a></div></li>
					</ul>
				</div>
				<!--
				<div class="noscript1">
					<ul>
						<li><div class="noscriptbox"><a href="{$root}TypedArticle?acreate=new&amp;type={/H2G2/MULTI-STAGE/MULTI-REQUIRED[@NAME='TYPE']/VALUE-EDITABLE}&amp;s_sport=tennis">Tennis</a></div></li>
						<li><div class="noscriptbox"><a href="{$root}TypedArticle?acreate=new&amp;type={/H2G2/MULTI-STAGE/MULTI-REQUIRED[@NAME='TYPE']/VALUE-EDITABLE}&amp;s_sport=motorsport">Motorsport</a></div></li>
						<li><div class="noscriptbox"><a href="{$root}TypedArticle?acreate=new&amp;type={/H2G2/MULTI-STAGE/MULTI-REQUIRED[@NAME='TYPE']/VALUE-EDITABLE}&amp;s_sport=athletics">Athletics</a></div></li>
						<li><div class="noscriptbox"><a href="{$root}TypedArticle?acreate=new&amp;type={/H2G2/MULTI-STAGE/MULTI-REQUIRED[@NAME='TYPE']/VALUE-EDITABLE}&amp;s_sport=horse_racing">Horse racing</a></div></li>	
						<li><div class="noscriptbox"><a href="{$root}TypedArticle?acreate=new&amp;type={/H2G2/MULTI-STAGE/MULTI-REQUIRED[@NAME='TYPE']/VALUE-EDITABLE}&amp;s_sport=disability_sport">Disability sport</a></div></li>
					</ul>
				</div>
				<div class="noscript2">
					<ul>
						<li><div class="noscriptbox"><a href="{$root}TypedArticle?acreate=new&amp;type={/H2G2/MULTI-STAGE/MULTI-REQUIRED[@NAME='TYPE']/VALUE-EDITABLE}&amp;s_sport=cricket">Cricket</a></div></li>
						<li><div class="noscriptbox"><a href="{$root}TypedArticle?acreate=new&amp;type={/H2G2/MULTI-STAGE/MULTI-REQUIRED[@NAME='TYPE']/VALUE-EDITABLE}&amp;s_sport=golf">Golf</a></div></li>
					<li><div class="noscriptbox"><a href="{$root}TypedArticle?acreate=new&amp;type={/H2G2/MULTI-STAGE/MULTI-REQUIRED[@NAME='TYPE']/VALUE-EDITABLE}&amp;s_sport=boxing">Boxing</a></div></li>
					<li><div class="noscriptbox"><a href="{$root}TypedArticle?acreate=new&amp;type={/H2G2/MULTI-STAGE/MULTI-REQUIRED[@NAME='TYPE']/VALUE-EDITABLE}&amp;s_sport=snooker">Snooker</a></div></li>
					<li><div class="noscriptbox"><a href="{$root}TypedArticle?acreate=new&amp;type={/H2G2/MULTI-STAGE/MULTI-REQUIRED[@NAME='TYPE']/VALUE-EDITABLE}&amp;s_sport=cycling">Cycling</a></div></li>
						<li><div class="noscriptbox"><a href="{$root}TypedArticle?acreate=new&amp;type={/H2G2/MULTI-STAGE/MULTI-REQUIRED[@NAME='TYPE']/VALUE-EDITABLE}&amp;s_sport=other">Other Sport</a></div></li>
					</ul>
				</div>
				-->
			</xsl:when>
			<xsl:otherwise>
			<!-- ALL OTHER ARTICLES -->
				<div class="noscript1">
					<ul>
						<li><div class="noscriptbox"><a href="{$root}TypedArticle?acreate=new&amp;type={/H2G2/MULTI-STAGE/MULTI-REQUIRED[@NAME='TYPE']/VALUE-EDITABLE}&amp;s_sport=football">Football</a></div></li>
						<li><div class="noscriptbox"><a href="{$root}TypedArticle?acreate=new&amp;type={/H2G2/MULTI-STAGE/MULTI-REQUIRED[@NAME='TYPE']/VALUE-EDITABLE}&amp;s_sport=rugby_union">Rugby union</a></div></li>
						<li><div class="noscriptbox"><a href="{$root}TypedArticle?acreate=new&amp;type={/H2G2/MULTI-STAGE/MULTI-REQUIRED[@NAME='TYPE']/VALUE-EDITABLE}&amp;s_sport=tennis">Tennis</a></div></li>
						<li><div class="noscriptbox"><a href="{$root}TypedArticle?acreate=new&amp;type={/H2G2/MULTI-STAGE/MULTI-REQUIRED[@NAME='TYPE']/VALUE-EDITABLE}&amp;s_sport=motorsport">Motorsport</a></div></li>
						<li><div class="noscriptbox"><a href="{$root}TypedArticle?acreate=new&amp;type={/H2G2/MULTI-STAGE/MULTI-REQUIRED[@NAME='TYPE']/VALUE-EDITABLE}&amp;s_sport=athletics">Athletics</a></div></li>
						<li><div class="noscriptbox"><a href="{$root}TypedArticle?acreate=new&amp;type={/H2G2/MULTI-STAGE/MULTI-REQUIRED[@NAME='TYPE']/VALUE-EDITABLE}&amp;s_sport=horse_racing">Horse racing</a></div></li>		
						<!--[FIXME: take out for now]
						<li><div class="noscriptbox"><a href="{$root}TypedArticle?acreate=new&amp;type={/H2G2/MULTI-STAGE/MULTI-REQUIRED[@NAME='TYPE']/VALUE-EDITABLE}&amp;s_sport=disability_sport">Disability sport</a></div></li>
						-->
					</ul>
				</div>
				<div class="noscript2">
					<ul>
						<li><div class="noscriptbox"><a href="{$root}TypedArticle?acreate=new&amp;type={/H2G2/MULTI-STAGE/MULTI-REQUIRED[@NAME='TYPE']/VALUE-EDITABLE}&amp;s_sport=cricket">Cricket</a></div></li>
						<li><div class="noscriptbox"><a href="{$root}TypedArticle?acreate=new&amp;type={/H2G2/MULTI-STAGE/MULTI-REQUIRED[@NAME='TYPE']/VALUE-EDITABLE}&amp;s_sport=rugby_league">Rugby league</a></div></li>
						<li><div class="noscriptbox"><a href="{$root}TypedArticle?acreate=new&amp;type={/H2G2/MULTI-STAGE/MULTI-REQUIRED[@NAME='TYPE']/VALUE-EDITABLE}&amp;s_sport=golf">Golf</a></div></li>
						<li><div class="noscriptbox"><a href="{$root}TypedArticle?acreate=new&amp;type={/H2G2/MULTI-STAGE/MULTI-REQUIRED[@NAME='TYPE']/VALUE-EDITABLE}&amp;s_sport=boxing">Boxing</a></div></li>
						<li><div class="noscriptbox"><a href="{$root}TypedArticle?acreate=new&amp;type={/H2G2/MULTI-STAGE/MULTI-REQUIRED[@NAME='TYPE']/VALUE-EDITABLE}&amp;s_sport=snooker">Snooker</a></div></li>
						<li><div class="noscriptbox"><a href="{$root}TypedArticle?acreate=new&amp;type={/H2G2/MULTI-STAGE/MULTI-REQUIRED[@NAME='TYPE']/VALUE-EDITABLE}&amp;s_sport=cycling">Cycling</a></div></li>
						<li><div class="noscriptbox"><a href="{$root}TypedArticle?acreate=new&amp;type={/H2G2/MULTI-STAGE/MULTI-REQUIRED[@NAME='TYPE']/VALUE-EDITABLE}&amp;s_sport=other">Other Sport</a></div></li>
					</ul>
				</div>
			</xsl:otherwise>
		</xsl:choose>	
		</td>
		</tr>
		</table>
	</xsl:otherwise>
</xsl:choose>
</xsl:template>



<xsl:template name="CHANGE_SPORT">
	<xsl:choose>
		<xsl:when test="/H2G2/MULTI-STAGE/@TYPE='TYPED-ARTICLE-EDIT'">
			<!-- 
				Allowing users to change the sport of a published article would screw up tags and dynamic lists
				<div class="inputinfo"><a href="{$root}TypedArticle?aedit=new&amp;type={$current_article_type}&amp;h2g2id={/H2G2/ARTICLE/ARTICLEINFO/H2G2ID}&amp;s_selectsport=1">change sport?</a></div>
			-->
		</xsl:when>
		<xsl:when test="/H2G2/MULTI-STAGE/@TYPE='TYPED-ARTICLE-CREATE'">
			<div class="inputinfo"><a href="{$root}TypedArticle?acreate=new&amp;type={$current_article_type}">change sport?</a></div>
		</xsl:when>
		<xsl:otherwise>
		<!-- 
		 do we need these?
			preview when creating
		 	preview when editing
			<font size="1">change link?</font>
		
		-->
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

	
</xsl:stylesheet>
