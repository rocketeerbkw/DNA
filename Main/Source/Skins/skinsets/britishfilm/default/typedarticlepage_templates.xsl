<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">


										
<xsl:template name="PROFILE_FORM"><!-- REMOVED: was used to create/edit profile:  TYPE = 3001 --></xsl:template>

<!-- form used for creating an film article (poll with comments) -->
<xsl:template name="ARTICLE_FORM">
	<!-- DEBUG -->
	<xsl:call-template name="TRACE">
	<xsl:with-param name="message">USER_ARTICLE_FORM</xsl:with-param>
	<xsl:with-param name="pagename">typedarticlepage_templates.xsl</xsl:with-param>
	</xsl:call-template>
	<!-- DEBUG -->
	
<!--	<xsl:apply-templates select="/H2G2/MULTI-STAGE/MULTI-REQUIRED/ERRORS/ERROR | /H2G2/MULTI-STAGE/MULTI-ELEMENT/ERRORS/ERROR" mode="c_typedarticle"/> -->
				
	<input type="hidden" name="_msxml" value="{$article_form}"/>
	<input type="hidden" name="ARTICLEFORUMSTYLE" value="1"/>
	<input type="hidden" name="polltype1" value="3"/>
	<input type="hidden" name="polltype1allowanonymousrating" value="true"/>
	<!-- <input type="hidden" name="status" value="3"/> -->
	<input type="hidden" name="TYPEOFARTICLE" value="film"/>
	<input type="hidden" name="type">
		<xsl:attribute name="value"><xsl:value-of select="$current_article_type"/></xsl:attribute>
	</input>

		<xsl:if test="/H2G2/MULTI-STAGE/@TYPE='TYPED-ARTICLE-PREVIEW' or /H2G2/MULTI-STAGE[@TYPE='TYPED-ARTICLE-EDIT-PREVIEW'] or /H2G2/MULTI-STAGE[@TYPE='TYPED-ARTICLE-EDIT']">
			<xsl:attribute name="class">mainbodysec createarticle</xsl:attribute>
		</xsl:if>
	

			<xsl:call-template name="FILM_EDITFORM" />
			<xsl:call-template name="SUBMIT_BUTTONS" />
	

	
</xsl:template>

		
<!-- form used for creating an editorial article -->
<xsl:template name="EDITORIAL_ARTICLE_FORM">

	<!-- DEBUG -->
	<xsl:call-template name="TRACE">
	<xsl:with-param name="message">EDITORIAL_ARTICLE_FORM</xsl:with-param>
	<xsl:with-param name="pagename">typedarticlepage_templates.xsl</xsl:with-param>
	</xsl:call-template>
	<!-- DEBUG -->
	
<!--	<xsl:apply-templates select="/H2G2/MULTI-STAGE/MULTI-REQUIRED/ERRORS/ERROR | /H2G2/MULTI-STAGE/MULTI-ELEMENT/ERRORS/ERROR" mode="c_typedarticle"/> -->
				
	<input type="hidden" name="_msxml" value="{$editorial_article_fields}"/>

	<input type="hidden" name="ARTICLEFORUMSTYLE" value="1"/>
	
	<!-- form -->
	
		<div class="requiredKey"><span class="required">*</span> compulsory fields</div>
		
		<br />

		
		<div class="frow">
			
			<div class="labelone"><label for="body">guideML</label></div>
			<textarea name="body" cols="80" rows="80" class="inputone" id="body">
				<xsl:value-of select="MULTI-REQUIRED[@NAME='BODY']/VALUE-EDITABLE"/>
			</textarea>
		</div>		

		
		<xsl:call-template name="SUBMIT_BUTTONS" />
						

</xsl:template>


<!-- 
#############################################################
	SUBMIT BUTTONS
#############################################################
-->

<!-- preview, create and edit buttons -->
<xsl:template name="SUBMIT_BUTTONS">
	<div class="inputaction">					
		<xsl:apply-templates select="." mode="t_articlepreviewbutton"/>&nbsp;&nbsp;
	
		
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
	<!-- <xsl:attribute name="src"><xsl:value-of select="$imagesource"/>submissionnext.gif</xsl:attribute> -->
	<xsl:attribute name="value">preview</xsl:attribute>
	<xsl:attribute name="class">mlimgnoborder</xsl:attribute>
</xsl:attribute-set>
	
<xsl:attribute-set name="mMULTI-STAGE_r_articleeditbutton">
	<xsl:attribute name="type">submit</xsl:attribute>
	<xsl:attribute name="value">publish</xsl:attribute>
	<xsl:attribute name="class">inputpre</xsl:attribute>
</xsl:attribute-set>

<!-- max characters -->
<xsl:variable name="maxcharacters_textinput_value">43</xsl:variable>
<xsl:template name="maxcharacters_textinput_text">
	<div class="inputinfo">43 characters max</div>
</xsl:template>
<xsl:template name="maxcharacters_textinput_text2">
	<div class="inputinfo2">43 characters max</div>
</xsl:template>

<!-- 
#############################################################
	DATE
#############################################################
-->

<xsl:template name="DATE_REPORT">
	<div class="frow">
		<xsl:if test="MULTI-ELEMENT[@NAME='DATEDAY']/ERRORS/ERROR/@TYPE='VALIDATION-ERROR-EMPTY' or MULTI-ELEMENT[@NAME='DATEMONTH']/ERRORS/ERROR/@TYPE='VALIDATION-ERROR-EMPTY' or MULTI-ELEMENT[@NAME='DATEYEAR']/ERRORS/ERROR/@TYPE='VALIDATION-ERROR-EMPTY'">
			<xsl:attribute name="class">frow alert</xsl:attribute>
		</xsl:if>
		<div class="labelone"><label for="date">date<span class="required">*</span></label></div>
				
		<span>
			<xsl:if test="MULTI-ELEMENT[@NAME='DATEDAY']/ERRORS/ERROR/@TYPE='VALIDATION-ERROR-EMPTY'">
				<xsl:attribute name="class">alert</xsl:attribute>
			</xsl:if>
			<select name="DATEDAY" id="dateday">
				<xsl:call-template name="DATEDAY_OPTIONS" />
			</select>
		</span>
		 /
		 <span>
			<xsl:if test="MULTI-ELEMENT[@NAME='DATEMONTH']/ERRORS/ERROR/@TYPE='VALIDATION-ERROR-EMPTY'">
				<xsl:attribute name="class">alert</xsl:attribute>
			</xsl:if>
			<select name="DATEMONTH" id="datemonth">
				<xsl:call-template name="DATEMONTH_OPTIONS" />
			</select>
		</span>
		 / 
		 
		 <span>
			<xsl:if test="MULTI-ELEMENT[@NAME='DATEMONTH']/ERRORS/ERROR/@TYPE='VALIDATION-ERROR-EMPTY'">
				<xsl:attribute name="class">alert</xsl:attribute>
			</xsl:if>
			<input type="text" name="DATEYEAR" id="dateyear" style="width:40px;">
				<xsl:attribute name="value">
					<xsl:choose>
						<xsl:when test="MULTI-ELEMENT[@NAME='DATEYEAR']/VALUE-EDITABLE/text()">
							<xsl:value-of select="MULTI-ELEMENT[@NAME='DATEYEAR']/VALUE-EDITABLE"/>
						</xsl:when>
						<xsl:otherwise>
						<xsl:value-of select="/H2G2/DATE/@YEAR"/>
						</xsl:otherwise>
					</xsl:choose>
					
				</xsl:attribute>
			</input>
		</span>	
	
			
	<!-- <div class="fl"><input type="text" name="" id="date" class="inputcal" /></div> <div class="calflr"><a href="#"><img height="18" hspace="5" vspace="0" border="0" width="18" alt="calender" src="{$imagesource}calendar.gif" align="left" /></a><a href="#" class="callink"> click the calender button</a></div> -->
	
	</div>
</xsl:template>



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
	CREATING A FILM: 3 step process
#############################################################
-->

<xsl:template name="FILM_EDITFORM">
		

		<h2 class="submissionh2">Personal details</h2>
		<table width="100%" border="0" cellspacing="0">
    	<tr>
      	<td width="20%">
					
					first name:<span>*</span>
				</td> 
				<td><input class="mlinput" type="text" name="FIRSTNAME">
						<xsl:attribute name="value">
							<xsl:value-of select="MULTI-ELEMENT[@NAME='FIRSTNAME']/VALUE-EDITABLE"/>
						</xsl:attribute>
					</input>
				</td>
			</tr>
			<tr>
				<td>
					
					surname:<span>*</span>
				</td> 
				<td><input class="mlinput" type="text" name="SURNAME">
						<xsl:attribute name="value">
							<xsl:value-of select="MULTI-ELEMENT[@NAME='SURNAME']/VALUE-EDITABLE"/>
						</xsl:attribute>
						</input>
				</td>
			</tr>
			<tr>
              <td height="10" colspan="2"><div class="divider3"></div></td>
            </tr>
		</table>

		<h2 class="submissionh2">Film details</h2>
		
		<table width="100%" border="0" cellspacing="0">
			<tr>
      	<td width="20%">
        	
					film title:<span>*</span>
				</td>
				<td> 
					<input class="mlinput" type="text" name="TITLE">
						<xsl:attribute name="value">
							<xsl:value-of select="MULTI-REQUIRED[@NAME='TITLE']/VALUE-EDITABLE"/>
						</xsl:attribute>
					</input>
				</td>
			</tr>

			<tr>
				<td>
					
				YouTube embed code:<span>*</span>
				</td>
				<td><input type="text" name="VIDEOLINK" class="mlinput">
						<xsl:attribute name="value">
							<xsl:value-of select="MULTI-ELEMENT[@NAME='VIDEOLINK']/VALUE-EDITABLE"/>
						</xsl:attribute>
					</input><br /><!-- WIDTH="411" HEIGHT="338" -->EG. http://www.youtube.com/v/qdImv2SdB6E
				</td>
			</tr>


			<tr>
				<td>
					
				BBC embed code:<span>*</span>
				</td>
				<td><input type="text" name="BBCVIDEOLINK" class="mlinput">
						<xsl:attribute name="value">
							<xsl:value-of select="MULTI-ELEMENT[@NAME='BBCVIDEOLINK']/VALUE-EDITABLE"/>
						</xsl:attribute>
					</input><br /><!-- WIDTH="411" HEIGHT="338" -->EG. http://www.bbc.co.uk/bbctwo/p/?x=avenueq_trainspotting_360
				</td>
			</tr>

			<tr>
				<td>
					
					director's name:<span>*</span>
				</td>
				<td><input type="text" name="DIRECTOR" class="mlinput">
						<xsl:attribute name="value">
							<xsl:value-of select="MULTI-ELEMENT[@NAME='DIRECTOR']/VALUE-EDITABLE"/>
						</xsl:attribute>
					</input>
				</td>
			</tr>

			<tr>
				<td>
					
					genre 1:<span>*</span>
				</td>
				<td>
					<select name="GENRE01" class="mlinput">
						<option value="">choose...</option>
						<option value="comedy"><xsl:if test="MULTI-ELEMENT[@NAME='GENRE01']/VALUE-EDITABLE = 'comedy'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Comedy</option>
						<option value="love"><xsl:if test="MULTI-ELEMENT[@NAME='GENRE01']/VALUE-EDITABLE = 'love'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Love</option>
						<option value="thriller"><xsl:if test="MULTI-ELEMENT[@NAME='GENRE01']/VALUE-EDITABLE = 'thriller'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Thriller</option>
						<option value="costumedrama"><xsl:if test="MULTI-ELEMENT[@NAME='GENRE01']/VALUE-EDITABLE = 'costumedrama'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Costume Drama</option>
						<option value="socialrealism"><xsl:if test="MULTI-ELEMENT[@NAME='GENRE01']/VALUE-EDITABLE = 'socialrealism'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Social Realism</option>
						<option value="horror"><xsl:if test="MULTI-ELEMENT[@NAME='GENRE01']/VALUE-EDITABLE = 'horror'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Horror</option>
						<option value="war"><xsl:if test="MULTI-ELEMENT[@NAME='GENRE01']/VALUE-EDITABLE = 'war'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>War</option>
					</select>
				</td>
			</tr>

			<tr>
				<td>genre 2:</td>
				<td><select name="GENRE02" class="mlinput">
						<option value="">choose...</option>
						<option value="comedy"><xsl:if test="MULTI-ELEMENT[@NAME='GENRE02']/VALUE-EDITABLE = 'comedy'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Comedy</option>
						<option value="love"><xsl:if test="MULTI-ELEMENT[@NAME='GENRE02']/VALUE-EDITABLE = 'love'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Love</option>
						<option value="thriller"><xsl:if test="MULTI-ELEMENT[@NAME='GENRE02']/VALUE-EDITABLE = 'thriller'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Thriller</option>
						<option value="costumedrama"><xsl:if test="MULTI-ELEMENT[@NAME='GENRE02']/VALUE-EDITABLE = 'costumedrama'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Costume Drama</option>
						<option value="socialrealism"><xsl:if test="MULTI-ELEMENT[@NAME='GENRE02']/VALUE-EDITABLE = 'socialrealism'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Social Realism</option>						
						<option value="horror"><xsl:if test="MULTI-ELEMENT[@NAME='GENRE02']/VALUE-EDITABLE = 'horror'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Horror</option>						
						<option value="war"><xsl:if test="MULTI-ELEMENT[@NAME='GENRE02']/VALUE-EDITABLE = 'war'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>War</option>
					</select>
				</td>
			</tr>

			<tr>
				<td>genre 3:</td>
				<td><select name="GENRE03" class="mlinput">
					<option value="">choose...</option>
						<option value="comedy"><xsl:if test="MULTI-ELEMENT[@NAME='GENRE03']/VALUE-EDITABLE = 'comedy'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Comedy</option>						
						<option value="love"><xsl:if test="MULTI-ELEMENT[@NAME='GENRE03']/VALUE-EDITABLE = 'love'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Love</option>
						<option value="scifi"><xsl:if test="MULTI-ELEMENT[@NAME='GENRE03']/VALUE-EDITABLE = 'scifi'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Sci-fi</option>
						<option value="thriller"><xsl:if test="MULTI-ELEMENT[@NAME='GENRE03']/VALUE-EDITABLE = 'thriller'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Thriller</option>					
						<option value="costumedrama"><xsl:if test="MULTI-ELEMENT[@NAME='GENRE03']/VALUE-EDITABLE = 'costumedrama'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Costume Drama</option>
						<option value="socialrealism"><xsl:if test="MULTI-ELEMENT[@NAME='GENRE03']/VALUE-EDITABLE = 'socialrealism'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Social Realism</option>	
						<option value="horror"><xsl:if test="MULTI-ELEMENT[@NAME='GENRE03']/VALUE-EDITABLE = 'horror'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Horror</option>
						<option value="war"><xsl:if test="MULTI-ELEMENT[@NAME='GENRE03']/VALUE-EDITABLE = 'war'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>War</option>
				</select>
				</td>
			</tr>
			
	

			<!-- <div>Other:&nbsp;
				<select name="PLATFORM">
					<option value="">choose...</option>
					<option value="video"><xsl:if test="MULTI-ELEMENT[@NAME='PLATFORM']/VALUE-EDITABLE = 'video'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Video</option>
					<option value="animation"><xsl:if test="MULTI-ELEMENT[@NAME='PLATFORM']/VALUE-EDITABLE = 'animation'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Animation</option>
					<option value="mobile"><xsl:if test="MULTI-ELEMENT[@NAME='PLATFORM']/VALUE-EDITABLE = 'mobile'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Mobile</option>
				</select>	
			</div> -->

			<tr>
      	<td>
        	
					other tag:<span>*</span>
				</td>
				<td>
					<select name="OTHER" class="mlinput">
						<option value="">choose...</option>
						<option value="video"><xsl:if test="MULTI-ELEMENT[@NAME='OTHER']/VALUE-EDITABLE = 'video'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Video</option>
						<option value="animation"><xsl:if test="MULTI-ELEMENT[@NAME='OTHER']/VALUE-EDITABLE = 'animation'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Animation</option>
						<option value="mobile"><xsl:if test="MULTI-ELEMENT[@NAME='OTHER']/VALUE-EDITABLE = 'mobile'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Mobile</option>
						<option value="puppets"><xsl:if test="MULTI-ELEMENT[@NAME='OTHER']/VALUE-EDITABLE = 'puppets'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Puppets</option>


						<!--
							<xsl:for-each select="/H2G2/SITECONFIG/MEDIUMS/MEDIUM">
								<option>
									<xsl:attribute name="value"><xsl:value-of select="./@VALUE"/></xsl:attribute>
									<xsl:if test="/H2G2/MULTI-STAGE/MULTI-ELEMENT[@NAME='MEDIUM']/VALUE = ./@VALUE">
										<xsl:attribute name="selected">selected</xsl:attribute>
									</xsl:if>
									<xsl:value-of select="./@LABEL" />
								</option>
							</xsl:for-each>
							-->
					</select>
				</td>
			</tr>
			

			<tr>
      	<td>
        	
					theme:<span>*</span>
				</td>
				<td>
					<select name="THEME">
						<option value="">choose...</option>
						<!-- <xsl:for-each select="/H2G2/SITECONFIG/THEMES/THEME"> -->
						<!-- <option value="tale"><xsl:if test="MULTI-ELEMENT[@NAME='THEME']/VALUE-EDITABLE = 'tale'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Tale</option> -->
						<!-- <option>
							<xsl:attribute name="value"><xsl:value-of select="./@VALUE"/></xsl:attribute>
							<xsl:if test="/H2G2/MULTI-STAGE/MULTI-ELEMENT[@NAME='THEME']/VALUE = ./@VALUE">
								<xsl:attribute name="selected">selected</xsl:attribute>
							</xsl:if>
							<xsl:value-of select="./@LABEL" />
						</option>
						</xsl:for-each> -->
						<option value="tale"><xsl:if test="MULTI-ELEMENT[@NAME='THEME']/VALUE-EDITABLE = 'tale'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Twist in the Tale</option>
						<option value="hotlead"><xsl:if test="MULTI-ELEMENT[@NAME='THEME']/VALUE-EDITABLE = 'hotlead'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Hot Lead</option>
						<option value="urbantale"><xsl:if test="MULTI-ELEMENT[@NAME='THEME']/VALUE-EDITABLE = 'urbantale'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Urban Tale</option>
						<option value="blackcomedy"><xsl:if test="MULTI-ELEMENT[@NAME='THEME']/VALUE-EDITABLE = 'blackcomedy'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Black Comedy</option>
						<option value="random"><xsl:if test="MULTI-ELEMENT[@NAME='THEME']/VALUE-EDITABLE = 'random'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Random</option>
						<option value="experimental"><xsl:if test="MULTI-ELEMENT[@NAME='THEME']/VALUE-EDITABLE = 'experimental'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Experimental</option>
						<option value="datingdisaster"><xsl:if test="MULTI-ELEMENT[@NAME='THEME']/VALUE-EDITABLE = 'datingdisaster'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Dating Disaster</option>
						<option value="hollywoodending"><xsl:if test="MULTI-ELEMENT[@NAME='THEME']/VALUE-EDITABLE = 'hollywoodending'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Hollywood Ending</option>
						<option value="sick"><xsl:if test="MULTI-ELEMENT[@NAME='THEME']/VALUE-EDITABLE = 'sick'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Sick</option>
						<option value="loverat"><xsl:if test="MULTI-ELEMENT[@NAME='THEME']/VALUE-EDITABLE = 'loverat'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Love Rat</option>
						<option value="peculiar"><xsl:if test="MULTI-ELEMENT[@NAME='THEME']/VALUE-EDITABLE = 'peculiar'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Funny Peculiar</option>
						<option value="gritty"><xsl:if test="MULTI-ELEMENT[@NAME='THEME']/VALUE-EDITABLE = 'gritty'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Gritty</option>
						<option value="soundtrack"><xsl:if test="MULTI-ELEMENT[@NAME='THEME']/VALUE-EDITABLE = 'soundtrack'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Great Soundtrack</option>
						<option value="chilling"><xsl:if test="MULTI-ELEMENT[@NAME='THEME']/VALUE-EDITABLE = 'chilling'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Chilling</option>
						<option value="scifi"><xsl:if test="MULTI-ELEMENT[@NAME='THEME']/VALUE-EDITABLE = 'scifi'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Sci-fi</option>
						<option value="technical"><xsl:if test="MULTI-ELEMENT[@NAME='THEME']/VALUE-EDITABLE = 'technical'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Technical Wizardry</option>
					</select>
				</td>
			</tr>
			<!-- CODE FOR PULLING IN THEMES FROM SITECONFIG. FOR NOW USE THE HARD CODED VERSION UNTIL TESTING AND CAN INITIALISE SITE CONFIG. CV 15/02/2007
				<xsl:for-each select="/H2G2/SITECONFIG/THEMES/THEME">
					<xsl:option>
						<xsl:attribute name="value"><xsl:value-of select="@value" /></xsl:attribute>
						<xsl:attribute name="value"><xsl:value-of select="@label" /></xsl:attribute>
					</xsl:option>
				</xsl:for-each>
			-->
			
			<!-- Using siteconfig to define themes, no longer hard coding CV 20/02/07
			<select name="THEME">
					<option value="">choose...</option>
					<option value="tale"><xsl:if test="MULTI-ELEMENT[@NAME='THEME']/VALUE-EDITABLE = 'tale'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Tale</option>
					<option value="hotlead"><xsl:if test="MULTI-ELEMENT[@NAME='THEME']/VALUE-EDITABLE = 'hotlead'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Hot Lead</option>
					<option value="urbantale"><xsl:if test="MULTI-ELEMENT[@NAME='THEME']/VALUE-EDITABLE = 'urbantale'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Urban Tale</option>
					<option value="blackcomedy"><xsl:if test="MULTI-ELEMENT[@NAME='THEME']/VALUE-EDITABLE = 'blackcomedy'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Black Comedy</option>
					<option value="random"><xsl:if test="MULTI-ELEMENT[@NAME='THEME']/VALUE-EDITABLE = 'random'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Random</option>
					<option value="experimental"><xsl:if test="MULTI-ELEMENT[@NAME='THEME']/VALUE-EDITABLE = 'experimental'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Experimental</option>
					<option value="datingdisaster"><xsl:if test="MULTI-ELEMENT[@NAME='THEME']/VALUE-EDITABLE = 'datingdisaster'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Dating Disaster</option>
					<option value="hollywoodending"><xsl:if test="MULTI-ELEMENT[@NAME='THEME']/VALUE-EDITABLE = 'hollywoodending'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Hollywood Ending</option>
					<option value="sick"><xsl:if test="MULTI-ELEMENT[@NAME='THEME']/VALUE-EDITABLE = 'sick'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Sick</option>
					<option value="loverat"><xsl:if test="MULTI-ELEMENT[@NAME='THEME']/VALUE-EDITABLE = 'loverat'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Love Rat</option>
				</select>	
				-->


			<tr>
				<td>
				
					film length:<span>*</span>
				</td>
				<td>
					<table width="250" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td style="padding:0; margin:0; ">
								<input type="text" name="LENGTH_MIN" size="4" maxlength="3">
									<xsl:attribute name="value">
										<xsl:value-of select="MULTI-ELEMENT[@NAME='LENGTH_MIN']/VALUE-EDITABLE"/>
									</xsl:attribute>
								</input>
							</td>
              <td style="padding:0; margin:0; ">minutes</td>
              <td style="padding:0; margin:0; ">
              	<input type="text" name="LENGTH_SEC" size="2" maxlength="2">
									<xsl:attribute name="value">
										<xsl:value-of select="MULTI-ELEMENT[@NAME='LENGTH_SEC']/VALUE-EDITABLE"/>
									</xsl:attribute>
								</input>
							</td>
            	<td style="padding:0; margin:0; ">seconds </td>
            </tr>
           </table>
          </td>
				</tr>

				<tr>
   				<td colspan="2">Both minutes and seconds boxes must be filled in, ie: 1 minutes 46 secsonds</td>
   			</tr>

			<tr>
			<!-- CV may call DATEMONTH_OPTIONS template to generate pull down options -->
				<td>
						
						date made:<span>*</span></td>
				<td>
					<input type="text" name="PUB_DAY" value="dd" size="2" maxlength="2" >
						<xsl:attribute name="value">
							<xsl:value-of select="MULTI-ELEMENT[@NAME='PUB_DAY']/VALUE-EDITABLE"/>
						</xsl:attribute>
					</input>
					<input type="text" name="PUB_MONTH" value="mm" size="2" maxlength="2">
						<xsl:attribute name="value">
							<xsl:value-of select="MULTI-ELEMENT[@NAME='PUB_MONTH']/VALUE-EDITABLE"/>
						</xsl:attribute>
					</input>
					<input type="text" name="PUB_YEAR" value="yyyy" size="4" maxlength="4">
						<xsl:attribute name="value">
							<xsl:value-of select="MULTI-ELEMENT[@NAME='PUB_YEAR']/VALUE-EDITABLE"/>
						</xsl:attribute>
					</input>
				</td>
			</tr>
			<tr>
				<!-- <td width="70%"></td>
				<td width="30%" style="text-align:right;"></td> -->
				<td colspan="2">
					
					<div class="logline">log line (short description):<span>*</span></div>
					<div class="approx">approx 20 words</div>
				</td>
			</tr>
			<tr>
      	<td colspan="2">
					<textarea name="TAGLINE" rows="3" class="mltextarea">
						
							<xsl:value-of select="MULTI-ELEMENT[@NAME='TAGLINE']/VALUE-EDITABLE"/>
						
					</textarea>
				</td>
			</tr>
		
			<tr>
         <td colspan="2">
         	
          <div class="logline">synopsis:<span>*</span></div>
      		<div class="approx">limited to 720 characters, roughly 100 words</div>
      	</td>
      </tr>
			<tr>
      	<td colspan="2">
      		<textarea type="text" name="body" rows="5" class="mltextarea">
						<xsl:value-of select="MULTI-REQUIRED[@NAME='BODY']/VALUE-EDITABLE"/>
					</textarea>
				</td>
			</tr>
			<tr>
         <td colspan="2">
         	
          <div class="logline">related links:</div>
      		<div class="approx"></div>
      	</td>
      </tr>
	  <tr>
      	<td colspan="2">
      		<textarea type="text" name="RELATEDLINKS" rows="5" class="mltextarea">
						<xsl:value-of select="MULTI-ELEMENT[@NAME='RELATEDLINKS']/VALUE-EDITABLE"/>
					</textarea>
				</td>
			</tr>
			<tr>
      	<td height="10" colspan="2"><div class="divider3"></div></td>
			</tr>
		</table>
		
		<h2 class="submissionh2">Rights</h2>

		<table width="100%" border="0" cellspacing="0">
			<tr>
       	<td>
       		<xsl:if test="//MULTI-ELEMENT[@NAME='DECLARATION_LEGAL']/VALUE-EDITABLE != 'on'">
							<span class="alert">*</span>
					</xsl:if>
					A legal summary of the rights they are giving to the BBC for the use of their film (repeated from the submit page).</td>
      </tr>
      <tr>
				<td>
					<input type="checkbox" name="DECLARATION_LEGAL" id="agreelegal">
						<xsl:if test="MULTI-ELEMENT[@NAME='DECLARATION_LEGAL']/VALUE-EDITABLE = 'on'">
							<xsl:attribute name="checked">checked</xsl:attribute>
						</xsl:if>	
					</input>
					<input type="hidden" name="DECLARATION_LEGAL"/>
					<label for="agreelegal">A check box agreeing to the summary.</label>
				</td>
      </tr>
			<tr>
      	<td height="10"></td>
    	</tr>
		</table>
          




</xsl:template>






<!-- 
#############################################################
	DATES
#############################################################
-->

<xsl:template name="DATEDAY_OPTIONS">
	<option value="">day</option>
	<option value="1"><xsl:if test="MULTI-ELEMENT[@NAME='DATEDAY']/VALUE-EDITABLE = '1'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>1</option>
	<option value="2"><xsl:if test="MULTI-ELEMENT[@NAME='DATEDAY']/VALUE-EDITABLE = '2'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>2</option>
	<option value="3"><xsl:if test="MULTI-ELEMENT[@NAME='DATEDAY']/VALUE-EDITABLE = '3'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>3</option>
	<option value="4"><xsl:if test="MULTI-ELEMENT[@NAME='DATEDAY']/VALUE-EDITABLE = '4'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>4</option>
	<option value="5"><xsl:if test="MULTI-ELEMENT[@NAME='DATEDAY']/VALUE-EDITABLE = '5'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>5</option>
	<option value="6"><xsl:if test="MULTI-ELEMENT[@NAME='DATEDAY']/VALUE-EDITABLE = '6'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>6</option>
	<option value="7"><xsl:if test="MULTI-ELEMENT[@NAME='DATEDAY']/VALUE-EDITABLE = '7'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>7</option>
	<option value="8"><xsl:if test="MULTI-ELEMENT[@NAME='DATEDAY']/VALUE-EDITABLE = '8'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>8</option>
	<option value="9"><xsl:if test="MULTI-ELEMENT[@NAME='DATEDAY']/VALUE-EDITABLE = '9'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>9</option>
	<option value="10"><xsl:if test="MULTI-ELEMENT[@NAME='DATEDAY']/VALUE-EDITABLE = '10'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>10</option>
	<option value="11"><xsl:if test="MULTI-ELEMENT[@NAME='DATEDAY']/VALUE-EDITABLE = '11'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>11</option>
	<option value="12"><xsl:if test="MULTI-ELEMENT[@NAME='DATEDAY']/VALUE-EDITABLE = '12'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>12</option>
	<option value="13"><xsl:if test="MULTI-ELEMENT[@NAME='DATEDAY']/VALUE-EDITABLE = '13'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>13</option>
	<option value="14"><xsl:if test="MULTI-ELEMENT[@NAME='DATEDAY']/VALUE-EDITABLE = '14'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>14</option>
	<option value="15"><xsl:if test="MULTI-ELEMENT[@NAME='DATEDAY']/VALUE-EDITABLE = '15'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>15</option>
	<option value="16"><xsl:if test="MULTI-ELEMENT[@NAME='DATEDAY']/VALUE-EDITABLE = '16'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>16</option>
	<option value="17"><xsl:if test="MULTI-ELEMENT[@NAME='DATEDAY']/VALUE-EDITABLE = '17'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>17</option>
	<option value="18"><xsl:if test="MULTI-ELEMENT[@NAME='DATEDAY']/VALUE-EDITABLE = '18'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>18</option>
	<option value="19"><xsl:if test="MULTI-ELEMENT[@NAME='DATEDAY']/VALUE-EDITABLE = '19'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>19</option>
	<option value="20"><xsl:if test="MULTI-ELEMENT[@NAME='DATEDAY']/VALUE-EDITABLE = '20'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>20</option>
	<option value="21"><xsl:if test="MULTI-ELEMENT[@NAME='DATEDAY']/VALUE-EDITABLE = '21'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>21</option>
	<option value="22"><xsl:if test="MULTI-ELEMENT[@NAME='DATEDAY']/VALUE-EDITABLE = '22'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>22</option>
	<option value="23"><xsl:if test="MULTI-ELEMENT[@NAME='DATEDAY']/VALUE-EDITABLE = '23'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>23</option>
	<option value="24"><xsl:if test="MULTI-ELEMENT[@NAME='DATEDAY']/VALUE-EDITABLE = '24'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>24</option>
	<option value="25"><xsl:if test="MULTI-ELEMENT[@NAME='DATEDAY']/VALUE-EDITABLE = '25'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>25</option>
	<option value="26"><xsl:if test="MULTI-ELEMENT[@NAME='DATEDAY']/VALUE-EDITABLE = '26'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>26</option>
	<option value="27"><xsl:if test="MULTI-ELEMENT[@NAME='DATEDAY']/VALUE-EDITABLE = '27'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>27</option>
	<option value="28"><xsl:if test="MULTI-ELEMENT[@NAME='DATEDAY']/VALUE-EDITABLE = '28'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>28</option>
	<option value="29"><xsl:if test="MULTI-ELEMENT[@NAME='DATEDAY']/VALUE-EDITABLE = '29'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>29</option>
	<option value="30"><xsl:if test="MULTI-ELEMENT[@NAME='DATEDAY']/VALUE-EDITABLE = '30'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>30</option>
	<option value="31"><xsl:if test="MULTI-ELEMENT[@NAME='DATEDAY']/VALUE-EDITABLE = '31'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>31</option>
</xsl:template>

<xsl:template name="DATEMONTH_OPTIONS">
	<option value="">month</option>
	<option value="January"><xsl:if test="MULTI-ELEMENT[@NAME='DATEMONTH']/VALUE-EDITABLE = 'January'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>January</option>
	<option value="February"><xsl:if test="MULTI-ELEMENT[@NAME='DATEMONTH']/VALUE-EDITABLE = 'February'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>February</option>
	<option value="March"><xsl:if test="MULTI-ELEMENT[@NAME='DATEMONTH']/VALUE-EDITABLE = 'March'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>March</option>
	<option value="April"><xsl:if test="MULTI-ELEMENT[@NAME='DATEMONTH']/VALUE-EDITABLE = 'April'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>April</option>
	<option value="May"><xsl:if test="MULTI-ELEMENT[@NAME='DATEMONTH']/VALUE-EDITABLE = 'May'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>May</option>
	<option value="June"><xsl:if test="MULTI-ELEMENT[@NAME='DATEMONTH']/VALUE-EDITABLE = 'June'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>June</option>
	<option value="July"><xsl:if test="MULTI-ELEMENT[@NAME='DATEMONTH']/VALUE-EDITABLE = 'July'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>July</option>
	<option value="August"><xsl:if test="MULTI-ELEMENT[@NAME='DATEMONTH']/VALUE-EDITABLE = 'August'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>August</option>
	<option value="September"><xsl:if test="MULTI-ELEMENT[@NAME='DATEMONTH']/VALUE-EDITABLE = 'September'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>September</option>
	<option value="October"><xsl:if test="MULTI-ELEMENT[@NAME='DATEMONTH']/VALUE-EDITABLE = 'October'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>October</option>
	<option value="November"><xsl:if test="MULTI-ELEMENT[@NAME='DATEMONTH']/VALUE-EDITABLE = 'November'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>November</option>
	<option value="December"><xsl:if test="MULTI-ELEMENT[@NAME='DATEMONTH']/VALUE-EDITABLE = 'December'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>December</option>
</xsl:template>


	<xsl:template match="MULTI-STAGE" mode="c_article">
		<form method="post" class="formtext" action="{$root}TypedArticle" xsl:use-attribute-sets="fMULTI-STAGE_c_article">



			<!--input type="hidden" name="skin" value="purexml"/-->
			<xsl:if test="@TYPE='TYPED-ARTICLE-EDIT' or @TYPE='TYPED-ARTICLE-EDIT-PREVIEW'">
				<input type="hidden" name="s_typedarticle" value="edit"/>
			</xsl:if>
			<xsl:choose>
				<xsl:when test="@TYPE='TYPED-ARTICLE-CREATE' or @TYPE='TYPED-ARTICLE-PREVIEW'">
					<!--input type="hidden" name="type" value="{MULTI-REQUIRED[@NAME='TYPE']/VALUE}"/-->
					<input type="hidden" name="_msstage" value="{@STAGE}"/>
					<xsl:apply-templates select="." mode="r_article"/>					
				</xsl:when>
				<xsl:when test="@TYPE='TYPED-ARTICLE-EDIT' or @TYPE='TYPED-ARTICLE-EDIT-PREVIEW'">
					<!--xsl:choose>
							<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_change']/VALUE=1">
								<input type="hidden" name="type" value="{MULTI-REQUIRED[@NAME='TYPE']/VALUE}"/>
							</xsl:when>
							<xsl:otherwise>
								<input type="hidden" name="type" value="{/H2G2/ARTICLE/EXTRAINFO/TYPE/@ID}"/>
							</xsl:otherwise>
						</xsl:choose-->
					<input type="hidden" name="_msstage" value="{@STAGE}"/>
					<input type="hidden" name="h2g2id" value="{/H2G2/ARTICLE/ARTICLEINFO/H2G2ID}"/>
					<xsl:apply-templates select="." mode="r_article"/>
				</xsl:when>
			</xsl:choose>
		</form>
	</xsl:template>
</xsl:stylesheet>
