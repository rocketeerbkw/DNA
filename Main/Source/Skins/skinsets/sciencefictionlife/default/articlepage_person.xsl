<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<xsl:import href="../../../base/base-articlepage.xsl"/>

	
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
					ARTICLE Object
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	
	
	<!-- START OF ARTICLE ... STEP 4 -->
	<xsl:template name="PERSON_MAINBODY">

		<!-- PERSON HEADER INFO: IMAGE, TITLE, AUTHOR, SHORTDESC, CLIP @cv@05A-->		
		
		<h1 class="smallh1">
			<xsl:choose>
				<xsl:when test="$current_article_type = 36">People</xsl:when>
				<xsl:when test="$current_article_type = 4">Feature</xsl:when>
				<xsl:otherwise>Themes</xsl:otherwise>
			</xsl:choose>
		</h1>
		<h2 class="themepersonal"><xsl:value-of select="ARTICLE/SUBJECT"/></h2>
		<xsl:choose>
		<xsl:when test="GUIDE/IMAGE_LOC != ''">
			<xsl:attribute name="src"><xsl:value-of select="concat($root, GUIDE/IMAGE_LOC)" /></xsl:attribute>
			<xsl:attribute name="alt"><xsl:value-of select="concat($root, GUIDE/IMAGE_ALT)" /></xsl:attribute>
		</xsl:when>
		<xsl:otherwise>
			<img src="{$imageRoot}images/quatermassmainimage.jpg" width="416" height="113" alt="Description goes here" />
		</xsl:otherwise>
		</xsl:choose>
		<!-- <ul title="Catastrophe: related links" class="linklist">
			<li class="standardbold"><a href="#biog"><img src="{$imageRoot}images/icon_downdoublearrow.gif" border="0" width="14" height="10" alt="arrow icon" /> Read the biography</a></li>
			<li class="standardbold"><a href="#examples"><img src="{$imageRoot}images/icon_downdoublearrow.gif" border="0" width="14" height="10" alt="arrow icon" /> Find examples</a></li>
			<li class="standardbold"><a href="#discuss"><img src="{$imageRoot}images/icon_downdoublearrow.gif" border="0" width="14" height="10" alt="arrow icon" /> Watch further discussion by authors and commentators</a></li>
		</ul>	
 -->

		<xsl:copy-of select="ARTICLE/GUIDE/TOP_LINKS" />

				
		<div class="boxbot"></div>
		<div class="whitebg">
			<div class="vspace10px"></div>
			<div class="padding10px">

				<a name="biog"></a>
				<xsl:apply-templates select="/H2G2/ARTICLE/GUIDE/BODY"/>
			</div>
		</div>


		<div class="boxtop"></div>
		<div class="vspace10px"></div>
		<div class="boxbot"></div>
		
		<!-- <div class="whitebg">
			<div class="padding10px">
				<h3 class="blacklarge">
					<xsl:choose>
						<xsl:when test="$current_article_type = 36">Examples of <xsl:value-of select="ARTICLE/SUBJECT" />'s works</xsl:when>
						<xsl:otherwise>Related Works</xsl:otherwise>
					</xsl:choose>
				</h3>
				<p class="standard">[important note - this section is in the same field as the article, above, so can't be separated from it on the page layout]</p>
				<div class="vspace18px"></div>
				
				<table class="fourcol" summary="Table showing date of publication, title, media type and/or country of publication, entry link for examples of this theme">
					<tr class="hidden">
						<th>Date of publication</th>
						<th>Title</th>
						<th>Media type and/or country of publication</th>
						<th>Link to entry on this theme</th>
					</tr> -->


					<xsl:copy-of select="ARTICLE/GUIDE/RELATED_WORKS" />
					<!-- 	<tr>
							
							<xsl:if test="not(position() mod 2 = 0)"><xsl:attribute name="class">greyband</xsl:attribute></xsl:if>
							<td class="standard"><xsl:value-of select="@YEAR" /></td>
							<td class="standardbold">
								<xsl:value-of select="LINK" /> -->
								<!-- v3 cat IF CAT FRONT PAGE, ADD CREATOR TO ARTICLE LISTING 
								<xsl:if test="$article_type_group='category'">			
									<xsl:value-of select="concat(', ', @CREATOR)" />
								</xsl:if>
								-->
							<!-- </td>
							<td class="standard"><xsl:value-of select="@TYPE" />, <xsl:value-of select="@COUNTRY" /></td>
							<td class="standard"><a class="underline"><xsl:attribute name="href"><xsl:value-of select="concat($root, 'A', @AID)" /></xsl:attribute><xsl:value-of select="." /></a></td>
						</tr>
					</xsl:for-each>
				</table>
			</div>
		</div> 
 -->
		<div class="modulebottom"> </div>
		<div class="vspace10px"></div>
		<div class="boxtopyellowdotted"></div>
		
<!-- 		<div class="yellbg">
			<div class="padding10px cnsmagicbullet">
				
				<h3><xsl:value-of select="ARTICLE/SUBJECT" /> discussed</h3>
				<p class="standard">Writers and commentators explore and discuss</p>
				
				<div class="vspace20px"></div>
	 -->			
				<xsl:copy-of select="ARTICLE/GUIDE/DISCUSS" />
<!-- 					<div class="floatleft"><a href="{$root}{@LOC}"><img src="{$imageRoot}images/people/bullet.gif" border="0" height="60" width="60" alt="" /></a></div>
					<div class="floatleft rightdescription">
						<p class="macwidthstandard"><xsl:value-of select="." /></p>
						<div class="vspace2px"></div>
						<p class="macwidthstandard"><a href="{$root}{@LOC}" class="underline"><img src="{$imageRoot}images/medialinkarrow.gif" border="0" width="32" height="24" alt="Watch clip from the original" />Watch a clip</a> | <a href="#" class="underline">More about clip</a></p> 
					</div>
					<div class="vspace24px"></div>
				</xsl:for-each>
				

			</div>
		</div>
 -->
		<div class="yellowbaseleftup"></div>
		
		<!-- EDITOR BOX @cv@07 -->
		<xsl:if test="$test_IsEditor">
			<div><xsl:call-template name="editorbox" /></div>
		</xsl:if>

		
	
	</xsl:template>






















	<xsl:template name="THEMES_GENERIC">
		<!-- PERSON HEADER INFO: IMAGE, TITLE, AUTHOR, SHORTDESC, CLIP @cv@05A-->		
		
		<xsl:if test="/H2G2/ARTICLE/GUIDE/PAGE_TYPE_TITLE != ''">
		<h1 class="smallh1">
			<xsl:copy-of select="/H2G2/ARTICLE/GUIDE/PAGE_TYPE_TITLE" />
		</h1>
		</xsl:if>


		<h2 class="themepersonal"><xsl:value-of select="/H2G2/ARTICLE/SUBJECT"/></h2>
		<xsl:if test="/H2G2/ARTICLE/GUIDE/IMAGE_LOC != ''">
			<img><xsl:attribute name="src"><xsl:value-of select="concat($imageRoot, 'images/', /H2G2/ARTICLE/GUIDE/IMAGE_LOC)" /></xsl:attribute>
			<xsl:attribute name="alt"><xsl:value-of select="/H2G2/ARTICLE/GUIDE/IMAGE_ALT" /></xsl:attribute></img>
		</xsl:if>
		<!-- <xsl:otherwise>
			<img src="{$imageRoot}images/quatermassmainimage.jpg" width="416" height="113" alt="Description goes here" />
		</xsl:otherwise> -->
		<!-- </xsl:choose> -->
		<!-- <ul title="Catastrophe: related links" class="linklist">
			<li class="standardbold"><a href="#biog"><img src="{$imageRoot}images/icon_downdoublearrow.gif" border="0" width="14" height="10" alt="arrow icon" /> Read the biography</a></li>
			<li class="standardbold"><a href="#examples"><img src="{$imageRoot}images/icon_downdoublearrow.gif" border="0" width="14" height="10" alt="arrow icon" /> Find examples</a></li>
			<li class="standardbold"><a href="#discuss"><img src="{$imageRoot}images/icon_downdoublearrow.gif" border="0" width="14" height="10" alt="arrow icon" /> Watch further discussion by authors and commentators</a></li>
		</ul>	
 -->

		<xsl:copy-of select="/H2G2/ARTICLE/GUIDE/TOP_LINKS" />

				
		<!-- <div class="boxbot"></div>
		<div class="whitebg">
			<div class="vspace10px"></div>
			<div class="padding10px"> -->

				<a name="biog"></a>
				<xsl:copy-of select="/H2G2/ARTICLE/GUIDE/BODY"/>
			<!-- </div>
		</div> -->


		<!-- <div class="boxtop"></div>
		<div class="vspace10px"></div>
		<div class="boxbot"></div> -->
		
		<!-- <div class="whitebg">
			<div class="padding10px">
				<h3 class="blacklarge">
					<xsl:choose>
						<xsl:when test="$current_article_type = 36">Examples of <xsl:value-of select="ARTICLE/SUBJECT" />'s works</xsl:when>
						<xsl:otherwise>Related Works</xsl:otherwise>
					</xsl:choose>
				</h3>
				<p class="standard">[important note - this section is in the same field as the article, above, so can't be separated from it on the page layout]</p>
				<div class="vspace18px"></div>
				
				<table class="fourcol" summary="Table showing date of publication, title, media type and/or country of publication, entry link for examples of this theme">
					<tr class="hidden">
						<th>Date of publication</th>
						<th>Title</th>
						<th>Media type and/or country of publication</th>
						<th>Link to entry on this theme</th>
					</tr> -->

					<a name="relatedworks"></a>
					<xsl:copy-of select="ARTICLE/GUIDE/RELATED_WORKS" />
					<!-- 	<tr>
							
							<xsl:if test="not(position() mod 2 = 0)"><xsl:attribute name="class">greyband</xsl:attribute></xsl:if>
							<td class="standard"><xsl:value-of select="@YEAR" /></td>
							<td class="standardbold">
								<xsl:value-of select="LINK" /> -->
								<!-- v3 cat IF CAT FRONT PAGE, ADD CREATOR TO ARTICLE LISTING 
								<xsl:if test="$article_type_group='category'">			
									<xsl:value-of select="concat(', ', @CREATOR)" />
								</xsl:if>
								-->
							<!-- </td>
							<td class="standard"><xsl:value-of select="@TYPE" />, <xsl:value-of select="@COUNTRY" /></td>
							<td class="standard"><a class="underline"><xsl:attribute name="href"><xsl:value-of select="concat($root, 'A', @AID)" /></xsl:attribute><xsl:value-of select="." /></a></td>
						</tr>
					</xsl:for-each>
				</table>
			</div>
		</div> 
 -->
	<!-- 	<div class="modulebottom"> </div>
		<div class="vspace10px"></div>
		<div class="boxtopyellowdotted"></div> -->
		
<!-- 		<div class="yellbg">
			<div class="padding10px cnsmagicbullet">
				
				<h3><xsl:value-of select="ARTICLE/SUBJECT" /> discussed</h3>
				<p class="standard">Writers and commentators explore and discuss</p>
				
				<div class="vspace20px"></div>
	 -->			
				<a name="discuss"></a>
				<xsl:copy-of select="ARTICLE/GUIDE/DISCUSS" />
<!-- 					<div class="floatleft"><a href="{$root}{@LOC}"><img src="{$imageRoot}images/people/bullet.gif" border="0" height="60" width="60" alt="" /></a></div>
					<div class="floatleft rightdescription">
						<p class="macwidthstandard"><xsl:value-of select="." /></p>
						<div class="vspace2px"></div>
						<p class="macwidthstandard"><a href="{$root}{@LOC}" class="underline"><img src="{$imageRoot}images/medialinkarrow.gif" border="0" width="32" height="24" alt="Watch clip from the original" />Watch a clip</a> | <a href="#" class="underline">More about clip</a></p> 
					</div>
					<div class="vspace24px"></div>
				</xsl:for-each>
				

			</div>
		</div>
 -->
		<!-- <div class="yellowbaseleftup"></div> -->
		
		<!-- EDITOR BOX @cv@07 -->
		<xsl:if test="$test_IsEditor">
			<div><xsl:call-template name="editorbox" /></div>
		</xsl:if>

		
	
	</xsl:template>
</xsl:stylesheet>