<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">

<xsl:template name="MEMBER_PAGE">

	<!-- DEBUG -->
	<xsl:call-template name="TRACE">
	<xsl:with-param name="message">MEMBER_PAGE</xsl:with-param>
	<xsl:with-param name="pagename">formmemberpage.xsl</xsl:with-param>
	</xsl:call-template>
	<!-- DEBUG -->

		<!-- <noscript><p class="info" style="color:red;">You cannot add a work because you do not have javascript enabled. <BR/>Please enable Javascript to add a work.</p>
		<p class="info" style="color:red;">You can find more information, including how to enable Javascript, on <a href="http://www.bbc.co.uk/webwise/askbruce/articles/browse/java_1.shtml">BBC Webwise</a></p>

		<p class="info" style="color:red;">If you are not able to enable Javascript for any reason, you can still add your recollection by giving your answers <a href="http://www.bbc.co.uk/mysciencefictionlife/contribute/addwork.shtml">here</a>.</p>

		<p class="info" style="color:red;">However, please be aware:<br />
		<ul>
			<li>New works are chosen to be added to the site daily, from the number which have been submitted</li>
			<li>Unfortunately, your new work will not appear on your user profile page, and it is not possible to ensure that your name appears on it</li>
		</ul>
		</p>

		<p class="info" style="color:red;">Your contribution is nonetheless valuable to us.</p>

		</noscript> -->

		<!-- FORM HEADER -->
		<xsl:if test="/H2G2/MULTI-STAGE[@TYPE='TYPED-ARTICLE-EDIT-PREVIEW' or @TYPE='TYPED-ARTICLE-PREVIEW']">
			<div class="useredit-u-a">
			<xsl:copy-of select="$myspace.tools.black" />&nbsp;
				<xsl:element name="{$text.subheading}" use-attribute-sets="text.subheading">
				<strong class="white">edit your <xsl:value-of select="$article_type_group" /></strong>
				</xsl:element>
			</div>
		</xsl:if>
		
		<!-- FORM BOX -->
		<div class="form-wrapper">
		<a name="edit" id="edit"></a>
	    <input type="hidden" name="_msfinish" value="yes"/>
		<input type="hidden" name="s_details" value="no" />
	
    <!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
				MEMBER PAGE FORM
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	
	
	<input type="hidden" name="_msxml" value="{$articlefields}"/>



	<!-- TITLE -->
			<div class="unsuccesful_listitems"> 
				
				<xsl:choose>
					<xsl:when test="not($article_subtype='person' or $article_subtype='theme' or $article_subtype='feature')">
					<h2 class="firstnoerror"><label for="title" title="Title"><img src="{$imageRoot}images/title_title.gif" border="0" width="35" height="16" alt="Title" /></label></h2>
					</xsl:when>
					<xsl:otherwise><h2>Title:</h2></xsl:otherwise>
				</xsl:choose>
			
				<div class="vspace2px"></div>

				<xsl:choose>
					<xsl:when test="not($article_subtype='person' or $article_subtype='theme' or $article_subtype='feature')">
						<p><textarea cols="45" rows="3" name="title" id="title"><xsl:value-of select="MULTI-REQUIRED[@NAME='TITLE']/VALUE-EDITABLE"/></textarea></p>
					</xsl:when>
					<xsl:otherwise>
						<p><xsl:apply-templates select="." mode="t_articletitle"/></p>
					</xsl:otherwise>
				</xsl:choose>

			</div>

	<xsl:if test="$article_subtype='person' or $article_subtype='theme' or $article_subtype='feature'">
		<div class="unsuccesful_listitems">
		<div class="vspace2px"></div>
		<input type="text" name="type" value="{$current_article_type}"/>
		</div>
	</xsl:if>


	<xsl:if test="not($article_subtype='person' or $article_subtype='theme' or $article_subtype='feature')">

		<!-- CREATOR -->
			<div class="unsuccesful_listitems"> 
				<h2><label for="writersorcreators" title="Writers or creator/s"><img src="{$imageRoot}images/title_writersandcreators.gif" border="0" width="138" height="18" alt="Writers or creator/s" /></label></h2>
				<div class="vspace2px"></div>
				<p><textarea cols="45" rows="3" name="creator" id="writersorcreators"><xsl:value-of select="MULTI-ELEMENT[@NAME='CREATOR']/VALUE-EDITABLE"/></textarea></p>
			</div>

			<!-- YEAR PUBLISHED -->
			<div class="unsuccesful_listitems"> 
				<h2><label for="firstpublished" title="Do you know when it was first published?"><img src="{$imageRoot}images/title_firstpublished.gif" border="0" width="315" height="22" alt="Do you know when it was first published?" /></label></h2>
                
				<p><input type="text" name="production_year" id="firstpublished" value="{MULTI-ELEMENT[@NAME='PRODUCTION_YEAR']/VALUE-EDITABLE}"/></p>
			</div>


			<div class="options2">
				<div class="floatleft">
					<h3><label for="option1">Choose from the drop down:</label></h3>
				</div>
				<div class="floatleft">
					<p class="paddingleft10px">
					<xsl:apply-templates select="." mode="r_articletype">
						<xsl:with-param name="group" select="$article_type_group" />
						<xsl:with-param name="user" select="$article_type_user" />
					</xsl:apply-templates>
					</p>
				</div>
				<div class="clear"></div>
			</div>
	
		
		
			<!-- WHY INCLUDE -->
			<div class="unsuccesful_listitems"> 
				<h2><label for="greatsciencefiction" title="Great Science Fiction"><img src="{$imageRoot}images/title_greatsciencefiction.gif" border="0"  alt="Great Science Fiction" /></label></h2>
                <p>Why do you think this should be in the Science Fiction in Britain timeline? What makes it worth including?</p>
                <p><textarea cols="45" rows="3" name="why_include" id="greatsciencefiction"><xsl:value-of select="MULTI-ELEMENT[@NAME='WHY_INCLUDE']/VALUE-EDITABLE"/></textarea></p>			
			</div>

			<!-- ENCAPSULATE
			<div class="unsuccesful_listitems"> 
				<h2><label for="encapsulated" title="Encapsulated"><img src="{$imageRoot}images/title_encapsulated.gif" border="0"  alt="Encapsulated" /></label></h2>
                <p>Would you recommend this? Why?</p>
                <p><textarea cols="45" rows="3" name="encap" id="encapsulated"><xsl:value-of select="MULTI-ELEMENT[@NAME='ENCAP']/VALUE-EDITABLE"/></textarea></p>
			</div>
		 -->

		<!-- TIME AND SPACE 
			<div class="unsuccesful_listitems"> 
				<h2><label for="timeandspace" title="Time and Space"><img src="{$imageRoot}images/title_timeandspace.gif" border="0"  alt="Time and Space" /></label></h2>
                <p>What year did you first come across this, and where were you at the time? How old were you? (40 - 50 words)</p>

                <p><textarea name="time_space" id="timeandspace" cols="45" rows="3"><xsl:value-of select="MULTI-ELEMENT[@NAME='TIME_SPACE']/VALUE-EDITABLE"/></textarea></p>
			</div>
		-->

		<!-- INSPIRATION 
			<div class="unsuccesful_listitems"> 
				<h2><label for="meandmysf" title="Me and my Science Fiction"><img src="{$imageRoot}images/title_recollections_reddot.gif" border="0"  alt="Me and my Science Fiction" /></label></h2>
                <p>How did you discover it? What memories does it conjure up? Did it influence, inspire or change you?</p>
                <p><textarea cols="45" rows="3" name="inspire_you" id="meandmysf"><xsl:value-of select="MULTI-ELEMENT[@NAME='INSPIRE_YOU']/VALUE-EDITABLE"/></textarea></p>
			</div>
		-->

		<!-- SUM UP -->
			<div class="unsuccesful_listitems"> 
				<h2><label for="sumupyourstory" title="Sum up your story"><img src="{$imageRoot}images/title_sumupyourstory.gif" border="0"  alt="Sum up your story" /></label></h2>
                <p>A short catchy headline (one word or a short phrase) which captures the essence of what you've written</p>
                <p><textarea cols="45" rows="3" name="sum_up" id="sumupyourstory"><xsl:value-of select="MULTI-ELEMENT[@NAME='SUM_UP']/VALUE-EDITABLE"/></textarea></p>
			</div>

			<div class="boxtop"></div>

		</xsl:if>


 		<xsl:if test="$test_IsEditor">

			<xsl:if test="not($article_subtype='person' or $article_subtype='theme' or $article_subtype='feature')">
				<div class="paddingbottom15px"></div>
				<div class="paddingbottom15px"></div>
				<div style="background:#CAE4ED; padding:5; font: bold">EDITOR'S SECTION</div>
			</xsl:if>

		
	
		
			<div class="unsuccesful_listitems">

				<!-- BODY OF ARTICLE -->
					<h2>Article Body</h2>
					<p>Contains the main content for the article. You may enter HTML tags.</p>
					<p><xsl:apply-templates select="." mode="t_articlebody"/></p>

			<xsl:if test="not($article_subtype='person' or $article_subtype='theme' or $article_subtype='feature')">

				<!-- Movie Clip -->
				<!-- <xsl:comment> LIST ITEM START </xsl:comment> -->
				<div class="unsuccesful_listitems"> 
					<h2>Movie Clip</h2>
					<p>Enter the full path and text for link</p>
					<p>&lt;CLIP LOC="http://full/path/to/file.mov"&gt;text for link&lt;/CLIP&gt;</p>
					<p><input type="text" name="movie_loc" id="firstpublished" value="{MULTI-ELEMENT[@NAME='MOVIE_LOC']/VALUE-EDITABLE}"/></p>
				</div>	
				
				
				<div class="unsuccesful_listitems"> 
					<h2>Country Abbreviation</h2>
					<p>Enter country abbreviation </p>
					<p><input type="text" name="country" id="firstpublished" value="{MULTI-ELEMENT[@NAME='COUNTRY']/VALUE-EDITABLE}"/></p>
				</div>

				<div class="unsuccesful_listitems"> 
					<h2>Override 'In Depth' title</h2>
					<p>Enter text for new title </p>
					<p><input type="text" name="indepth" id="firstpublished" value="{MULTI-ELEMENT[@NAME='INDEPTH']/VALUE-EDITABLE}"/></p>
				</div>

				<div class="unsuccesful_listitems"> 
					<h2>Add Theme link </h2>
					<p>Example: &lt;a href="/dna/mysciencefictionlife/evolution"&gt;Evolution&lt;/a&gt; </p>
					<p><input type="text" name="themelink" id="firstpublished" value="{MULTI-ELEMENT[@NAME='THEMELINK']/VALUE-EDITABLE}"/></p>
				</div>
			
			</xsl:if>

				<!-- Image Location -->
				<div class="unsuccesful_listitems"> 
					<h2>Image Location</h2>
					<p>Enter the filename only and upload the image to the 'images' folder </p>
					<p><input type="text" name="image_loc" id="firstpublished" value="{MULTI-ELEMENT[@NAME='IMAGE_LOC']/VALUE-EDITABLE}"/></p>
				</div>	


				<!-- @cv@! TAKE ARTICLE LIVE -->
				<div style="padding:5">
				<xsl:choose>
					<xsl:when test="$article_type_group='article'">
					<div class="textmedium">Article Status:
						<select name="status">
							<option value="3"><xsl:if test="@TYPE='TYPED-ARTICLE-CREATE'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>submission</option>		
							<option value="1"><xsl:if test="MULTI-REQUIRED[@NAME='STATUS']/VALUE-EDITABLE = 1"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>approved</option>
							<option value="5"><xsl:if test="MULTI-REQUIRED[@NAME='STATUS']/VALUE-EDITABLE = 5"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>declined</option>
							<option value="9"><xsl:if test="MULTI-REQUIRED[@NAME='STATUS']/VALUE-EDITABLE = 5"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>help</option>
						</select>
					</div>
					</xsl:when>
					<xsl:otherwise>
						<input type="hidden" name="STATUS" value="1" />
						<div class="textmedium">Article Status: 1 </div>
					</xsl:otherwise>
				</xsl:choose>
				</div>



				


				<!-- FEATURE 1 -->
				<div class="unsuccesful_listitems"> 
					<h2>Feature 1: to be displayed in right column</h2>
					<p>Enter the HTML as you would like it to be displayed</p>
					<textarea name="PROMO1" id="timeandspace" cols="50" rows="6">
						<xsl:choose>
							<!-- pre-populate the form GuideML -->
							<xsl:when test="@TYPE='TYPED-ARTICLE-CREATE'"></xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="MULTI-ELEMENT[@NAME='PROMO1']/VALUE-EDITABLE"/>
							</xsl:otherwise>
						</xsl:choose>
					</textarea>
				</div>

			<xsl:if test="not($article_subtype='person' or $article_subtype='theme' or $article_subtype='feature')">

				<!-- READ LINKS -->
				<div class="unsuccesful_listitems"> 
					<h2>Read Links (optional)</h2>
					<p>Enter the href and link text for each link</p>
					<p>&lt;li&gt;&lt;a href="http://full/path/"&gt;text for link&lt;/a&gt;&lt;/li&gt;</p>
					<textarea name="READ_LINKS" id="timeandspace" cols="50" rows="3">
						<xsl:choose>
						<!-- pre-populate the form GuideML -->
						<xsl:when test="@TYPE='TYPED-ARTICLE-CREATE'"></xsl:when>
						<xsl:otherwise>
						<xsl:value-of select="MULTI-ELEMENT[@NAME='READ_LINKS']/VALUE-EDITABLE"/>
						</xsl:otherwise>
						</xsl:choose>
					</textarea>
				</div>

	

				<!-- WATCH/LISTEN LINKS -->
				<div class="unsuccesful_listitems"> 
					<h2>Watch and Listen Links (optional)</h2>
					<p>Enter the HTML for the links enclosed by &lt;li&gt; </p>
					<p>&lt;li&gt;&lt;a href="http://full/path/file.mov"&gt;text for clip&lt;/a&gt;&lt;/li&gt;</p>
					<textarea name="WATCH_LISTEN" id="timeandspace" cols="50" rows="3">
						<xsl:choose>
							<!-- do not prepopulate because it is optional -->
							<xsl:when test="@TYPE='TYPED-ARTICLE-CREATE'"></xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="MULTI-ELEMENT[@NAME='WATCH_LISTEN']/VALUE-EDITABLE"/>
							</xsl:otherwise>
						</xsl:choose>
					</textarea>
				</div>

				<!-- ALSO ON BBC -->
				<div class="unsuccesful_listitems"> 
					<h2>Also on BBC (optional)</h2>
					<p>Enter the HTML for the links enclosed by &lt;li&gt; </p>
					<p>&lt;li&gt;&lt;a href="http://full/path/"&gt;text for link&lt;/a&gt;&lt;/li&gt;</p>
					<textarea name="ALSO_BBC" id="timeandspace" cols="50" rows="3">
						<xsl:choose>
							<!-- do not prepopulate because it is optional -->
							<xsl:when test="@TYPE='TYPED-ARTICLE-CREATE'"></xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="MULTI-ELEMENT[@NAME='ALSO_BBC']/VALUE-EDITABLE"/>
							</xsl:otherwise>
						</xsl:choose>
					</textarea>
				</div>

				<!-- ALSO ON WEB -->
				<div class="unsuccesful_listitems"> 
					<h2>Also on Web (optional)</h2>
					<p>Enter the HTML for the links enclosed by &lt;li&gt; </p>
					<p>&lt;li&gt;&lt;a href="http://full/path/"&gt;text for link&lt;/a&gt;&lt;/li&gt;</p>
					<textarea name="ALSO_WEB" id="timeandspace" cols="50" rows="3">
						<xsl:choose>
							<!-- do not prepopulate because it is optional -->
							<xsl:when test="@TYPE='TYPED-ARTICLE-CREATE'"></xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="MULTI-ELEMENT[@NAME='ALSO_WEB']/VALUE-EDITABLE"/>
							</xsl:otherwise>
						</xsl:choose>
					</textarea>
				</div>

			</xsl:if>



				<!-- RELATED WORKS -->
				<div class="unsuccesful_listitems"> 
					<h2>Related Works (optional)</h2>
					<xsl:choose>
						<xsl:when test="$article_subtype='person' or $article_subtype='theme' or $article_subtype='feature'">Enter HTML</xsl:when>
						<xsl:otherwise><p>Enter the media type (TV, Film, etc), year of publication, article ID, country abbreviation and article title</p>
						<p>&lt;LINK AID="A349388" TYPE="Comic" YEAR="1966" COUNTRY="UK"&gt;Godzilla&lt;/LINK&gt;</p>
						</xsl:otherwise>
					</xsl:choose>
					<textarea name="RELATED_WORKS" cols="50" rows="6">
						
						<xsl:value-of select="MULTI-ELEMENT[@NAME='RELATED_WORKS']/VALUE-EDITABLE"/>
						
					</textarea>
				</div>


			<xsl:if test="$article_subtype='person' or $article_subtype='theme' or $article_subtype='feature'">

				<!-- ARTICLE ASSOCIATIONS  v6 commented out because we should be able to use the existing RELATED_WORKS field
				<div class="unsuccesful_listitems"> 
					<h2>Article Associations</h2>
					<p>Enter the article name, year of publication, article ID, country abbreviation and category (TV, Film, Radio, etc)</p>
					<textarea name="ASSOCIATED_WORKS" cols="50" rows="3">
						<xsl:choose>
						<xsl:when test="@TYPE='TYPED-ARTICLE-CREATE'">&lt;LINK YEAR="" CATEGORY="" COUNTRY="" AID=""&gt;article title&lt;/LINK&gt;</xsl:when>
						<xsl:otherwise>
						<xsl:value-of select="MULTI-ELEMENT[@NAME='ASSOCIATED_WORKS']/VALUE-EDITABLE"/>
						</xsl:otherwise>
						</xsl:choose>
					</textarea>
				</div>
				-->

				<!-- DISCUSS -->
				<div class="unsuccesful_listitems"> 
					<h2>Discuss</h2>
					<p>Enter HTML</p>
					<textarea name="DISCUSS" cols="50" rows="9">
						
						<xsl:value-of select="MULTI-ELEMENT[@NAME='DISCUSS']/VALUE-EDITABLE"/>
					
					</textarea>
				</div>

				<!-- TOP LINKS -->
				<div class="unsuccesful_listitems"> 
					<h2>Links</h2>
					<p>Enter HTML</p>
					<textarea name="TOP_LINKS" cols="50" rows="3">
						
						<xsl:value-of select="MULTI-ELEMENT[@NAME='TOP_LINKS']/VALUE-EDITABLE"/>
					
					</textarea>
				</div>

				</xsl:if>





	


			
			</div>
			</xsl:if>


			<!-- <xsl:apply-templates select="/H2G2/MULTI-STAGE" mode="c_articlestatus"/> -->


	<!-- PREVIEW -->
	<xsl:if test="$test_IsEditor">
		<xsl:apply-templates select="." mode="t_articlepreviewbutton"/>
	</xsl:if>
	<!-- CREATE/PUBLISH/EDIT -->
		<a name="publish" id="publish"></a>
		<xsl:apply-templates select="." mode="c_articleeditbutton"/> 
	    <xsl:apply-templates select="." mode="c_articlecreatebutton"/>
		<!-- <xsl:apply-templates select="." mode="c_deletearticle"/> -->

	</div>

		
		 

	</xsl:template>
	
</xsl:stylesheet>