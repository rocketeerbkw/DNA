<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<xsl:import href="../../../base/base-mediaassetpage.xsl"/>
	
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
									Page - Level  template
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<xsl:template name="MEDIAASSET_MAINBODY">
		<!-- DEBUG -->
		<xsl:call-template name="TRACE">
			<xsl:with-param name="message">MEDIAASSET_MAINBODY</xsl:with-param>
			<xsl:with-param name="pagename">mediaassetpage.xsl</xsl:with-param>
		</xsl:call-template>
		<!-- DEBUG -->
	
		<xsl:apply-templates select="/H2G2/ERROR" mode="t_errorpage"/>
		<xsl:apply-templates select="MULTI-REQUIRED/ERRORS"/>
	
		<xsl:choose>
			<xsl:when test="MEDIAASSETBUILDER/MEDIAASSETINFO[ACTION='update']">
				<xsl:apply-templates select="MEDIAASSETBUILDER/MEDIAASSETINFO/MULTI-STAGE" mode="update"/>
			</xsl:when>
			<xsl:otherwise>
				<!-- View/Download an Asset -->
				<xsl:choose>
					<!-- licence agreement -->
					<xsl:when test="/H2G2/PARAMS/PARAM[NAME='s_display']/VALUE='licence'">
						<xsl:apply-templates select="/H2G2/MEDIAASSETBUILDER/MEDIAASSETINFO/MEDIAASSET" mode="licence"/>
					</xsl:when>
					<!-- user accepted agreement - it is downloading -->
					<xsl:when test="/H2G2/PARAMS/PARAM[NAME='s_select']/VALUE='yes'">
						<xsl:apply-templates select="/H2G2/MEDIAASSETBUILDER/MEDIAASSETINFO/MEDIAASSET" mode="licence_accepted"/>
					</xsl:when>
					<!-- user declined agreement  -->
					<xsl:when test="/H2G2/PARAMS/PARAM[NAME='s_select']/VALUE='no'">
						<xsl:apply-templates select="/H2G2/MEDIAASSETBUILDER/MEDIAASSETINFO/MEDIAASSET" mode="licence_declined"/>
					</xsl:when>
					<xsl:otherwise>
					<!-- View an Asset -->
						<xsl:apply-templates select="/H2G2/MEDIAASSETBUILDER/MEDIAASSETINFO/MEDIAASSET" mode="c_displayasset"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
		
		<!-- upload index page -->
		<xsl:if test="/H2G2/PARAMS/PARAM[NAME='s_display']/VALUE='index'">
			<xsl:apply-templates select="/H2G2/MEDIAASSETBUILDER" mode="c_mediaassetindex"/>
		</xsl:if>
		
		<!-- upload form -->
		<xsl:if test="not(MEDIAASSETBUILDER/MEDIAASSETINFO[ACTION='update'])">
			<xsl:apply-templates select="/H2G2/MEDIAASSETBUILDER/MEDIAASSETINFO/MULTI-STAGE" mode="c_mediaasset"/>
		</xsl:if>
		
		
		<!-- User articles with mediaassets -->
		<xsl:apply-templates select="MEDIAASSETBUILDER/ARTICLEMEDIAASSETINFO[ACTION='showusersarticleswithassets']"/> 
		
		<!-- 
			Uploaded Media Assets
				Page showing all assets a user has uploads
				e.g http://dnadev.bu.bbc.co.uk/dna/comedysoup/UMA1090497698
		
			<xsl:apply-templates select="/H2G2/MEDIAASSETBUILDER/MEDIAASSETINFO" mode="c_uma"/>
		-->
	</xsl:template>

	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
									Uploading an asset
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<!-- 
	<xsl:template match="MEDIAASSETBUILDER" mode="r_mediaassetindex">
	Use: Starting point for uploading an asset
	-->
	<xsl:template match="MEDIAASSETBUILDER" mode="r_mediaassetindex">
		<img src="{$imagesource}h1_uploadyourrawmaterialtotheassetlibrary.gif" alt="upload your raw material to the asset library" width="520" height="26" />
		
		<div id="uploadAssetLibraryIndex" class="assets">
		<div class="col1">
			<div class="margins">
				<div class="calHeader">
					<img src="{$imagesource}csal_logo_476x122.jpg" alt="" width="476" height="122" 
					/>
				</div>
				
				<p><b>Fancy sharing some of your raw material with the rest of Soup? Well you can do it here...</b></p>
				
				<p>Save yourself some trouble before you send it and make sure you've read the 
				comedy soup asset licence to see what will get on Soup and what won't</p>
				
				<div class="hozDots"></div>
				
				<p>If you're ready, get sending by clicking on one of the links below.</p>
				
				<xsl:apply-templates select="." mode="c_uploadimage"/>
				<xsl:apply-templates select="." mode="c_uploadaudio"/>
				<xsl:apply-templates select="." mode="c_uploadvideo"/>
				
			</div>
		</div><!--// col1 -->
	
		<div class="col2">
			<div class="margins">
				<xsl:apply-templates select="/H2G2/SITECONFIG/ASSETLIBRARYHELP" />
				
				<div class="contentBlock">
					<h2>What can I send</h2>
					<p>Help with file formats.tips and tricks for 
					compressing your work, it's <a href="insert_url">all here</a>.</p>
				</div>
				
				
				<div class="contentBlock">
					<h2>Help me!</h2>
					<p>Having trouble sumitting your content? <a href="insert_url">Read our guide</a> to getting your stuff on the site.</p>
				</div>
			</div>
		</div><!--// col2 -->
		<div class="clr"></div>
	</div>
	</xsl:template>
	<!-- 
	<xsl:template match="MEDIAASSETBUILDER" mode="r_uploadimage">
	Use: Submit button to upload an image
	-->
	<xsl:template match="MEDIAASSETBUILDER" mode="r_uploadimage">
		<xsl:apply-imports/>
		<br/>
		<br/>
		<p>Or,</p>
	</xsl:template>
	<!-- 
	<xsl:template match="MEDIAASSETBUILDER" mode="r_uploadaudio">
	Use: Submit button to upload an audio
	-->
	<xsl:template match="MEDIAASSETBUILDER" mode="r_uploadaudio">
		<xsl:apply-imports/>
		<br/>
		<br/>
		<p>Or,</p>
	</xsl:template>
	<!-- 
	<xsl:template match="MEDIAASSETBUILDER" mode="r_uploadimage">
	Use: Submit button to upload a video
	-->
	<xsl:template match="MEDIAASSETBUILDER" mode="r_uploadvideo">
		<xsl:apply-imports/>
	</xsl:template>
	<!-- 
	<xsl:template match="MULTI-STAGE" mode="create_mediaasset">
	Use: input fields for creating an asset
	-->
	<xsl:template match="MULTI-STAGE" mode="create_mediaasset">
		<!-- <input type="hidden" name="skin" value="purexml"/> -->
		<xsl:apply-templates select="." mode="asseterror"/>
		<xsl:apply-templates select="." mode="c_filetoupload"/>
		<xsl:apply-templates select="." mode="c_caption"/>
		<xsl:apply-templates select="MULTI-REQUIRED[@NAME='FILENAME']" mode="c_assetfilename"/>
		<xsl:apply-templates select="MULTI-REQUIRED[@NAME='MIMETYPE']" mode="c_mediaassetmimetype"/>
		<xsl:apply-templates select="." mode="c_assetdesc"/>
		<xsl:apply-templates select="." mode="c_assettags"/>
		<xsl:apply-templates select="." mode="c_assettandc"/>
		<xsl:apply-templates select="." mode="c_assetsubmit"/>
	</xsl:template>
	<!-- 
	<xsl:template match="MULTI-STAGE" mode="r_filetoupload">
	Use: input type="file" field
	-->
	<xsl:template match="MULTI-STAGE" mode="r_filetoupload">
		<p class="assetUpload">
			<xsl:text>File:</xsl:text>
			<br/>
			<xsl:apply-imports/>
		</p>
	</xsl:template>
	<!-- 
	<xsl:template match="MULTI-STAGE" mode="r_caption">
	Use: 'Adding a caption to the asset' field
	-->
	<xsl:template match="MULTI-STAGE" mode="r_caption">
		<p class="assetCaption">
		Caption:<br/>
			<xsl:apply-imports/>
		</p>
	</xsl:template>
	<!-- 
	<xsl:template match="MULTI-STAGE" mode="r_assetdesc">
	Use: 'Adding a description to the asset' field
	-->
	<xsl:template match="MULTI-STAGE" mode="r_assetdesc">
		<p class="assetDesc">
			Description Text:<br/>
			<xsl:apply-imports/>
		</p>
	</xsl:template>
	<!-- 
	<xsl:template match="MULTI-STAGE" mode="r_assettags">
	Use: 'Adding tags to the asset' field
	-->
	<xsl:template match="MULTI-STAGE" mode="r_assettags">
		<p class="assetTags">
Add tags to this article:<br/>
			<xsl:apply-imports/>
		</p>
	</xsl:template>
	<!-- 
	<xsl:template match="MULTI-STAGE" mode="r_assettandc">
	Use: Terms and conditions tickbox
	-->
	<xsl:template match="MULTI-STAGE" mode="r_assettandc">
		<p class="assetCopyright">
			Agreement of Copyright:<br/>
			<xsl:apply-imports/>yes, I agree<br/>
		</p>
	</xsl:template>
	<!-- 
	<xsl:template match="MULTI-STAGE" mode="r_assetsubmit">
	Use: submit button for submitting a media asset
	-->
	<xsl:template match="MULTI-STAGE" mode="r_assetsubmit">
		<xsl:apply-imports/>
	</xsl:template>
	<!-- 
	<xsl:template match="MULTI-STAGE" mode="uploaded_mediaasset">
	Use: Interstitial page displayed after an asset has been submitted
	-->
	<xsl:template match="MULTI-STAGE" mode="uploaded_mediaasset">
		<xsl:text>Thankyou, your asset is now being uploaded for moderation</xsl:text>
		<br/>
		<br/>
		<a href="{$root}MediaAsset?id={../ID}">View your image</a>
	</xsl:template>
	<!-- 
	<xsl:template match="MULTI-STAGE" mode="uploadedmanual_mediaasset">
	Use: interstitial page displayed after a manual media asset's details has been posted 
	-->
	<xsl:template match="MULTI-STAGE" mode="uploadedmanual_mediaasset">
		<xsl:text>Thankyou, you can now post your media to use</xsl:text>
		<br/>
		<br/>
		<xsl:text>Your reference no is: </xsl:text>
		<xsl:value-of select="../ID"/>
	</xsl:template>
	<!-- 	
	<xsl:template match="MULTI-REQUIRED" mode="r_assetfilename">
	Use: Filename, needed when manually uploading an asset
	-->
	<xsl:template match="MULTI-REQUIRED" mode="r_assetfilename">
		Filename:<br/>
		<xsl:apply-imports/>
		<br/>
	</xsl:template>
	<!-- 
	<xsl:template match="MULTI-REQUIRED" mode="r_mediaassetmimetype">
	Use: mimetype: needed when manually uploading an asset
	-->
	<xsl:template match="MULTI-REQUIRED" mode="r_mediaassetmimetype">
		MimeType:<br/>
		<xsl:apply-imports/>
	</xsl:template>
	
	<xsl:template match="MULTI-STAGE" mode="asseterror">
		<xsl:if test="*/ERRORS">	
			<div style="color: red;">
				<xsl:text>Error:</xsl:text>
				<br/>
				<xsl:for-each select="MULTI-REQUIRED/ERRORS">
					<xsl:choose>
						<xsl:when test="ERROR/@TYPE='VALIDATION-ERROR-EMPTY'">
							<xsl:text></xsl:text>
							<xsl:choose>
								<xsl:when test="../@NAME='CAPTION'">You must provide a caption</xsl:when>
								<xsl:when test="../@NAME='FILE'">You must provide a file</xsl:when>
								<xsl:when test="../@NAME='MEDIAASSETDESCRIPTION'">You must provide a description</xsl:when>
								<xsl:when test="../@NAME='MEDIAASSETKEYPHRASES'">You must provide a key phrases</xsl:when>
								<xsl:when test="../@NAME='TERMSANDCONDITIONS'">You must agree to the copyright agreement</xsl:when>
							</xsl:choose>
						</xsl:when>
					</xsl:choose>
					<br/>
				
			</xsl:for-each>
			</div>
		</xsl:if>
	</xsl:template>
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
									Displaying an asset
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	
	<!-- 
	<xsl:template match="MEDIAASSET" mode="licence">
	Use: template for displaying the licence agreement
	-->
	<xsl:template match="MEDIAASSET" mode="licence">
	<xsl:variable name="videomimetype">
	<xsl:if test="/H2G2/PARAMS/PARAM/NAME/text()= 's_mimetype'">
	&amp;s_mimetype=<xsl:value-of select="/H2G2/PARAMS/PARAM[NAME='s_mimetype']/VALUE"/>
	</xsl:if>
	</xsl:variable>
	
	<h1><img src="{$imagesource}h1_assetinformationandlicence.gif" alt="asset information &amp; licence (use these to make your own comedy)" width="570" height="26" /></h1>

	<div id="assetLicence" class="assets">
		<div class="col1">
			<div class="margins">
				<!-- 3 column asset nav component -->
				<xsl:call-template name="ASSET_LIBRARY_TABS"/>
				<!--// 3 column asset nav component -->
				
				<div class="importantCAL">
					<!--
					<div class="imageHolder">
						<img src="{$imagesource}csal_logo_157x55.jpg" alt="Comedy Soup Asset Licence" />
					</div>
					-->
					<div class="content">					
						<p class="important">IMPORTANT: YOU MUST READ THIS LICENCE AND AGREE 
						TO ACCEPT ITS TERMS AND CONDITIONS BEFORE YOU CAN DOWNLOAD CONTENT.</p>					
					</div>
				</div>
				<div class="hozDots"></div>
				
				<xsl:comment>#include virtual="/comedysoup/includes/csa_licenceinbrief.ssi"</xsl:comment>
				
				<h2>The full Comedy Soup Asset Licence, please read carefully</h2>
				<p>This Comedy Soup Asset Licence enables You to use and distribute Works within the UK in the ways and on the terms set out in this Licence. Use of the Work by You will be treated as acceptance of this Licence.</p>
				
				<p>All capitalised terms are defined in Clause 1 below. The singular includes the plural and vice versa, unless the context otherwise requires.</p>
				
				<h3>This Licence is between:</h3>
				<p><strong>'the Licensor'</strong> the entity offering the Work under the terms and conditions of this Licence<br />
				<br />
				and<br />
				<br />
				<strong>'You'</strong> (a private individual or member of an educational establishment)<br />
				<br />
				agree as follows:</p> 
				
				<h3>1. Definitions</h3>
				<p><strong>"Credit/Crediting"</strong> (Attribution) means acknowledging the Original Authors and/or Licensors of any Works and/or Derivative Work that You Share; </p>
				
				<p><strong>"Derivative Work"</strong> means any work created by the editing, adaptation or translation of the Work in any media or any work made up of a number of separate works in which the Work is included in its entirety in unmodified form;</p>
				
				<p><strong>"Licence"</strong> means this Comedy Soup Asset licence for use within the UK;</p>
				
				<p><strong>"Logo"</strong> means the Comedy Soup Asset Licence logo attached to or incorporated in the Work;</p>
				
				<p><strong>"No-Endorsement"</strong> means that You must not use the Work and/or Derivative Work in any way that would suggest or imply the Licensor's support, association or approval;</p>
				
				<p><strong>"Non-Commercial"</strong> means personal use or use for educational purposes within any educational establishment listed in Annexe A, but excludes any commercial use (including professional, political or promotional uses);</p>
				
				<p><strong>"Original Author"</strong> means the individual (or entity) who created the Work and who should always be Credited.</p>
				
				<p><strong>"Share"</strong> means to communicate or make available to other members of the public by publishing, distributing, performing or other means of dissemination;</p>
				
				<p><strong>"Share-Alike"</strong> means Sharing the Work and/or Derivative Work under the same terms and conditions as granted to You under this Licence;</p>
				
				<p><strong>"Work"</strong> means the work protected by copyright which is offered under the terms of this Licence;</p>
				
				<h3>2. Grant of Licence</h3>
				<p><strong>2.1</strong>  The Licensor hereby grants to You a Non-Commercial, No-Endorsement, payment-free, non-exclusive licence within the United Kingdom for the duration of copyright in the Work to copy and/or Share the Work and/or create, copy and/or Share Derivative Works on any platform in any media.</p>
				
				<p><strong>2.2</strong> HOWEVER the licence granted in Clause 2.1 is provided to You only if You:</p>
				
				<p><strong>2.2.1.</strong> make reference to this Licence (by URL/URI, spoken word or as appropriate to the media used) on all copies of the Work and/or Derivative Works Shared by You and keep intact all notices that refer to this Licence;</p>
				
				<p><strong>2.2.2.</strong> share the Work and/or any Derivative Work only under the terms of this Licence (i.e.Share-Alike);</p>
				
				<p><strong>2.2.3 </strong> do not impose any terms and/or any digital rights management technology on the Work and/or Derivative Work that alter or restrict the terms of this Licence or any rights granted under it;</p>
				
				<p><strong>2.2.4.</strong> credit (attribute) the Original Author and/or Licensor(s) in a manner appropriate to the media used;</p>
				
				<p><strong>2.2.5.</strong> do not use the Work (which includes any underlying contributions to the work) and/or any Derivative Work for any illegal, derogatory or otherwise offensive purpose or through the use of the Work or any Derivative Work bring the Licensor's (or underlying rights owners') reputation into disrepute;</p>
				
				<p><strong>2.2.6</strong> keep this Licence intact and unaltered and including all notices, including FAQs that refer to this Licence.</p>
				
				<p><strong>2.2.7</strong> attach the Logo to any Work or Derivative Work you Share under the terms of this Licence to identify the source of the Work and/or Derivative Work and in order to demonstrate your agreement with the Licence terms. The Logo may not be altered or distorted in any way or used for any other purpose</p>
				
				<p><strong>2.3</strong> Each time You Share the Work and/or Derivative Work, the Licensor(s) offer to the recipient a Share-Alike licence to the Work provided the recipient complies with the terms of this Licence in respect of the Work and the Work as incorporated in the Derivative Work.</p>
				
				<p><strong>2.4</strong> This Licence does not affect any rights that You may have under any applicable law, including fair dealing or any other exception to copyright infringement.</p>
				
				<h3>3. Warranties and Disclaimer</h3>
				<p><strong>3.1</strong> The Licensor warrants that the Licensor is either the Original Author or has secured all rights in the Work necessary to grant this Licence in respect of the Work to you and that it has the right to grant permission to use the Logo as set out in this Licence</p>
				
				<p><strong>3.2</strong> Except as expressly stated in Clause 3.1 the Licensor provides no other warranty, express or implied, in respect of the Work.</p>
				
				<h3>4. Limit of Liability</h3>
				<p><strong>4.1</strong> Subject to any liability which may not be excluded or limited by law and/or any liability that You may incur to a third party resulting from a breach by the Licensor of its warranty in Clause 3.1 above, the Licensor shall not be liable and hereby expressly excludes any and all liability for loss or damage howsoever and whenever caused to You or by You.</p>
				
				<h3>5. Termination </h3>
				<p><strong>5.1</strong> The rights granted to You under this Licence shall terminate automatically upon any breach by You of the terms of this Licence. Individuals or entities who have received Derivative Works from You under this Licence, however, will not have their licences terminated provided such individuals or entities remain in full compliance with these Licence terms.</p>
				
				<h3>6. General</h3>
				<p><strong>6.1</strong> If any provision of this Licence is held to be invalid or unenforceable, it shall not affect the validity or enforceability of the remainder of the terms of this Licence</p> 
				
				<p><strong>6.2</strong> This Licence constitutes the entire agreement between the parties with respect to the Work licensed here. There are no understandings, agreements or representations with respect to the Work not specified here. The Licensor shall not be bound by any additional provisions that may appear in any communication from You.</p> 
				
				<p><strong>6.3</strong> A person who is not a party to this Licence will have no rights under the Contracts (Rights of Third Parties) Act 1999 to enforce any of its terms. </p>
				
				<p><strong>6.4</strong> (The BBC) reserves the right to change the terms of this Licence at any time. Any changes that (the BBC) considers at its discretion significantly alter the terms of the Licence, shall be notified to You.</p>
				
				<p><strong>6.5</strong> This Licence shall be governed by the laws of England and Wales and the parties irrevocably submit to the exclusive jurisdiction of the English Courts.</p>
				
				<h3>ANNEXE A</h3>
				<p>Educational Establishments<br />
				For the purposes of this Licence, an educational establishment shall mean:<br />
				- those bodies set out under S174 of the Copyright Designs and Patents Act 1988, which include schools, universities, higher education colleges and colleges of further education<br />
				- museums accredited by the MLA (Museums, Libraries and Archives Council) or funded/sponsored by the DCMS (Department for Culture, Media and Sport)</p>

				<div class="acceptance">
					<p>Do you accept the terms of this license?</p>
					
					<div>
						<a href="{$root}MediaAsset?id={@MEDIAASSETID}&amp;s_select=yes{$videomimetype}" class="button"><span><span><span>Accept</span></span></span></a>
						
						<a href="{$root}MediaAsset?id={@MEDIAASSETID}&amp;s_select=no" class="button"><span><span><span>Decline</span></span></span></a>
					</div>
				</div>
			</div>
		</div><!--// col1 -->
	
		<div class="col2">
			<div class="margins">
				
				<xsl:apply-templates select="/H2G2/SITECONFIG/ASSETLIBRARYHELP" />
			
			</div>
		</div><!--// col2 -->
		<div class="clear"></div>
	</div>
		
	
	</xsl:template>
	
	<!-- 
	<xsl:template match="MEDIAASSET" mode="licence_accepted">
	Use: template for displaying the it's downloading page (licence agreement accepted)
	-->
	<xsl:template match="MEDIAASSET" mode="licence_accepted"> 
	
	<xsl:variable name="downloadsuffix">
		<xsl:choose>
			<xsl:when test="/H2G2/PARAMS/PARAM/NAME/text()= 's_mimetype'">
				<xsl:value-of select="/H2G2/PARAMS/PARAM[NAME='s_mimetype']/VALUE"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$suffix"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<!-- automatic download -->
	<xsl:choose>
		<xsl:when test="CONTENTTYPE=1">
		<meta http-equiv="refresh" content="2;url={concat($libraryurl, FTPPATH, @MEDIAASSETID, '_raw.', $downloadsuffix)}"/>
		</xsl:when>
		<xsl:otherwise>
			<meta http-equiv="refresh" content="2;url={concat($libraryurl, FTPPATH, @MEDIAASSETID, '.', $downloadsuffix)}"/>
		</xsl:otherwise>
	</xsl:choose>
	<!-- // automatic doanload -->
		 
	<h1><img src="{$imagesource}h1_itsdownloading.gif" alt="it's downloading... (use these to make your own comedy!)" width="464" height="26" /></h1>

	<div id="automaticAssetDownload" class="assets">
		<div class="col1">
			<div class="margins">
				<!-- 3 column asset nav component -->
				<xsl:call-template name="ASSET_LIBRARY_TABS"/>
				<!--// 3 column asset nav component -->
				
				<div class="hozDotsWrapper">
					<h2>Your chosen asset is downloading</h2>
					<div class="hozDots"></div>
				</div>
				
				<p>Depending on the speed of your connection to the Internet, this download may take a while.</p> 

				<p>If your download doesn't start downloading automatically, 
					<xsl:choose>
						<xsl:when test="/H2G2/MEDIAASSETBUILDER/MEDIAASSETINFO/MEDIAASSET/CONTENTTYPE=1">
						<a href="{concat($libraryurl, FTPPATH, @MEDIAASSETID, '_raw.', $downloadsuffix)}" target="_blank">click here</a>
						</xsl:when>
						<xsl:otherwise>
							<a href="{concat($libraryurl, FTPPATH, @MEDIAASSETID, '.', $downloadsuffix)}" target="_blank">click here</a>
						</xsl:otherwise>
					</xsl:choose>
				</p>
				
				<p>You may navigate away from this page without affecting your download.</p> 
				
			</div>
		</div><!--// col1 -->
	
		<div class="col2">
			<div class="margins">
				<xsl:apply-templates select="/H2G2/SITECONFIG/ASSETLIBRARYHELP" />
				
				<div class="contentBlock">
					<h2>What are other people making?</h2>
					<p>Have a look at <a href="{$root}thelatest">the latest</a> stuff.</p>
				</div>
			</div>
		</div><!--// col2 -->
		<div class="clear"></div>
	</div>
	</xsl:template>
	
	<!-- 
	<xsl:template match="MEDIAASSET" mode="licence_declined">
	Use: template for displaying the 'sorry you declined the licence agreement)
	-->
	<xsl:template match="MEDIAASSET" mode="licence_declined">
	<h1><img src="{$imagesource}h1_licencedeclined.gif" alt="You declined" width="198" height="26" /></h1>

	<div id="automaticAssetDownload" class="assets">
		<div class="col1">
			<div class="margins">
				<!-- 3 column asset nav component -->
				<xsl:call-template name="ASSET_LIBRARY_TABS"/>
				<!--// 3 column asset nav component -->
				
				<br />
				<p>The Comedy Soup Asset Licence is vital protection for the rich and wide ranging content that it unlocks. We are sorry that you have chosen not to accept the terms and are unable to allow you to download your media.</p>
				  
				<div class="arrow"><a  HREF="insert_url">Back to the licence agreement page</a></div>
				<div class="backArrow"><a  HREF="{$root}">Home</a></div>

			</div>
		</div><!--// col1 -->
	
		<div class="col2">
			<div class="margins">
				<xsl:apply-templates select="/H2G2/SITECONFIG/ASSETLIBRARYHELP" />
			</div>
		</div><!--// col2 -->
		<div class="clear"></div>
	</div>
	</xsl:template>
	
	
	
	<xsl:variable name="m_download">
		<xsl:choose>
			<xsl:when test="/H2G2/MEDIAASSETBUILDER/MEDIAASSETINFO/MEDIAASSET/CONTENTTYPE=1">
				<xsl:text>Download image</xsl:text>
			</xsl:when>
			<xsl:when test="/H2G2/MEDIAASSETBUILDER/MEDIAASSETINFO/MEDIAASSET/CONTENTTYPE=2">
				<xsl:text>Download audio</xsl:text>
			</xsl:when>
			<xsl:when test="/H2G2/MEDIAASSETBUILDER/MEDIAASSETINFO/MEDIAASSET/CONTENTTYPE=3">
				<xsl:text>Download video</xsl:text>
			</xsl:when>
		</xsl:choose>
	</xsl:variable>
	<!-- 
	<xsl:template match="MEDIAASSET" mode="r_displayasset">
	Use: template for displaying an asset
	-->
	<xsl:template match="MEDIAASSET" mode="r_displayasset">
		<xsl:variable name="suffix">
			<xsl:call-template name="chooseassetsuffix">
				<xsl:with-param name="mimetype" select="MIMETYPE"/>
			</xsl:call-template>
		</xsl:variable>
		
		<xsl:variable name="contenttypetext">
		<xsl:choose>
			<xsl:when test="CONTENTTYPE=1">
				<xsl:text>image</xsl:text>
			</xsl:when>
			<xsl:when test="CONTENTTYPE=2">
				<xsl:text>audio</xsl:text>
			</xsl:when>
			<xsl:when test="CONTENTTYPE=3">
				<xsl:text>video</xsl:text>
			</xsl:when>
		</xsl:choose>
		</xsl:variable>
		
		<h1><xsl:choose>
			<xsl:when test="CONTENTTYPE=1">
				<img src="{$imagesource}h1_imageasset.gif" alt="image asset (use these to make your own comedy)" width="399" height="26" />
			</xsl:when>
			<xsl:when test="CONTENTTYPE=2">
				<img src="{$imagesource}h1_audioasset.gif" alt="audio asset (use these to make your own comedy)" width="385" height="26" />
			</xsl:when>
			<xsl:when test="CONTENTTYPE=3">
				<img src="{$imagesource}h1_videoasset.gif" alt="video asset (use these to make your own comedy)" width="390" height="26" />
			</xsl:when>
		</xsl:choose></h1>
		
		<div class="assets">
		<div class="col1">
			<div class="margins">
				<!-- MAIN CONTENT COLUMN -->
				
				<!-- 3 column asset nav component -->
				<xsl:call-template name="ASSET_LIBRARY_TABS"/>
				<!--// 3 column asset nav component -->
				
				<div class="backBlock">
					<a href="{$root}MediaAssetSearchPhrase?contenttype={CONTENTTYPE}&amp;phrase={/H2G2/PARAMS/PARAM[NAME = 's_tag']/VALUE}" class="backArrow">Back to <xsl:value-of select="$contenttypetext"/> search results</a>
					<div class="hozDots"></div>
				</div>
				
				<h2><xsl:value-of select="CAPTION"/></h2>	
				
		
				<div class="mediumFB">
					<div class="imageHolder">
						<xsl:apply-templates select="@MEDIAASSETID" mode="c_preview"/>
					</div>
					<div class="content">
						<div class="calBlock csalBlock">
							<img src="{$imagesource}csal_logo_264x106.jpg" width="264" height="106" alt="" />
							
 							<p>This content is provided under the<br /> 
							terms of the Comedy Soup Asset Licence.</p>
							
							<p><a href="{$root}csalfaq" class="arrow">More about the licence</a></p>
						</div>
					</div>
					<div class="clr"></div>
				</div>
				
				<div class="assetDetails">
					<div class="content">
						<xsl:apply-templates select="OWNER/USER" mode="c_previewauthor"/>
						<xsl:apply-templates select="//EXTRAELEMENTXML" mode="t_details"/>
						<!-- 
						<div class="info"><b>Published: </b><xsl:value-of select="DATECREATED/DATE/@DAY"/>/<xsl:value-of select="DATECREATED/DATE/@MONTH"/>/<xsl:value-of select="DATECREATED/DATE/@YEAR"/></div>
						-->
					</div>
					<div class="downloads">
						<xsl:apply-templates select="@MEDIAASSETID" mode="c_download"/>
						<xsl:apply-templates select="//EXTRAELEMENTXML/FILE_SIZE" mode="t_detail"/>
					</div>
					<div class="clr"></div>
				</div>
				
				<xsl:if test="($test_IsEditor)  and not(CONTENTTYPE=1)">
					<div class="editbox">
					<xsl:choose>
						<xsl:when test="HIDDEN=3">
							<p>This asset is awaiting moderation</p>
						</xsl:when>
						<xsl:when test="HIDDEN=2">
							<p>This asset has been refered</p>
						</xsl:when>
						<xsl:otherwise>
							<p>This asset has passed</p>
						</xsl:otherwise>
					</xsl:choose>
					<p><strong>Note for editors:</strong><br/>
					This is where you need to ftp the file to: <xsl:value-of select="concat($libraryurl, FTPPATH, @MEDIAASSETID, '.', $suffix)"/></p>
					</div>
				</xsl:if>
				
				<xsl:if test="CONTENTTYPE=3">
					<div class="hozDots"></div>
					<p><xsl:value-of select="MEDIAASSETDESCRIPTION"/></p>
				</xsl:if>
				
			</div>
		</div><!--// col1 -->
	
		<div class="col2">
			<div class="margins">
			<!-- PROMO COLUMN -->
				<xsl:apply-templates select="/H2G2/SITECONFIG/ASSETLIBRARYHELP" />
				
				<xsl:choose>
					<xsl:when test="/H2G2/MEDIAASSETSEARCHPHRASE/PHRASES/@COUNT=0">
					<!--
					<div class="contentBlock">
						<h2>Add to the asset library</h2>
						<p>You can add your own <xsl:value-of select="$contenttypetext"/> to the asset library for other people to use. <a href="insert_url">Find out</a> how to do it.</p>
					</div>
					-->
					</xsl:when>
					<xsl:otherwise>
						<div class="contentBlock">
							<h2> This asset has the following key phrases related with it:</h2>
							<p><xsl:apply-templates select="PHRASES" mode="c_displayasset"/></p>
							<!-- <div class="arrow"><a href="insert_url">See all key phrases</a></div> -->
						</div>
						
						<xsl:apply-templates select="/H2G2/SITECONFIG/POPULARRAWMATERIAL" />
					</xsl:otherwise>
				</xsl:choose>
			</div>
		</div><!--// col2 -->
		<div class="clear"></div>
	</div>
	
	</xsl:template>
	<!-- 
	<xsl:template match="@MEDIAASSETID" mode="r_preview">
	Use: Template invoked when displaying a media asset - 
	NOTE there is no preview function when uploading an asset
	-->
	<xsl:template match="@MEDIAASSETID" mode="r_preview">
		<xsl:choose>
			<xsl:when test="../CONTENTTYPE=1">
				<img src="{$libraryurl}{/H2G2/MEDIAASSETBUILDER/MEDIAASSETINFO/MEDIAASSET/FTPPATH}{.}_preview.{$suffix}" alt="{../MEDIAASSETDESCRIPTION}" />
			</xsl:when>
			<xsl:when test="../CONTENTTYPE=2">
				<img src="{$imagesource}audio_asset_187x187.gif" width="187" height="187" alt="" />
			</xsl:when>
			<xsl:when test="../CONTENTTYPE=3">
				<img src="{$imagesource}video/187/{.}.jpg" alt="{../SUBJECT/text()}" />
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<!-- 	
	<xsl:template match="@MEDIAASSETID" mode="r_download">
	Use: 'Download this asset' link
	-->
	<!-- 
		Alistair: need to add SSO check - user must be signed in
	-->
	<xsl:template match="@MEDIAASSETID" mode="r_download">
	<xsl:variable name="uma_download">
			<xsl:choose>
			<xsl:when test="../CONTENTTYPE=1">
				<xsl:text>download full sized image</xsl:text>
			</xsl:when>
			<xsl:when test="../CONTENTTYPE=2">
				<xsl:text>download audio (mp2)</xsl:text>
			</xsl:when>
		</xsl:choose>	
	</xsl:variable>
	<xsl:variable name="suffix">
		<xsl:call-template name="chooseassetsuffix">
			<xsl:with-param name="mimetype" select="../MIMETYPE"></xsl:with-param>
		</xsl:call-template>
	</xsl:variable>
	
	<xsl:choose>
		<xsl:when test="../CONTENTTYPE=3">
			<a href="{$root}MediaAsset?id={.}&amp;s_display=licence&amp;s_mimetype=wmv" class="button">
				<span><span><span>download video (windows media)</span></span></span>
			</a><div class="dlSize">&nbsp;</div>
			<a href="{$root}MediaAsset?id={.}&amp;s_display=licence&amp;s_mimetype=mov" class="button">
				<span><span><span>download video (quicktime)</span></span></span>
			</a><div class="dlSize">&nbsp;</div>
			<a href="{$root}MediaAsset?id={.}&amp;s_display=licence&amp;s_mimetype=mpg" class="button">
				<span><span><span>download video (mpeg)</span></span></span>
			</a>
		</xsl:when>
		<xsl:otherwise>
			<a class="button">
				<xsl:attribute name="href">
					<!-- check if a user is signed in before allowing them to download an asset -->
					<xsl:choose>
						<xsl:when test="/H2G2/VIEWING-USER/USER/USERID">
							<xsl:value-of select="concat($root,'MediaAsset?id=',.,'&amp;s_display=licence')"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="concat($sso_rootlogin,'SSO%3Fpa=downloadmediaasset%26pt=section%26section=rawmaterial%26pt=mediaassetid%26mediaassetid=',.)"/>
							<!-- 
							note by Alistair Duggin:
							We need to redirect user back to asset license page after logging in - there is no code for this in the base files so I 'hacked' it.
							
							pa=downloadmediaasset
							 	Adding pa= means a user is not redirected back to their personal space
								'downloadmediaasset' is an arbitary name (not used anywhere else but does what it says on the tin)
							
							pt=section%26section=rawmaterial
								This creates the following node /H2G2/NEWREGISTER/REGISTER-PASSTHROUGH/PARAM[@NAME='section']/text()='rawmaterial' which is tested for in registerpage.xsl
							
							pt=mediaassetid%26mediaassetid=
								This creates a node that we can use to store the id of the mediaasset
								/H2G2/NEWREGISTER/REGISTER-PASSTHROUGH/PARAM[@NAME='mediaassetid']/text()
								This is used to redirect the user back to the asset licence of the mediaasset they were trying to download
							-->
						</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
				<span><span><span><xsl:copy-of select="$uma_download"/></span></span></span>
			</a><br />
		</xsl:otherwise>
	</xsl:choose>
		
	</xsl:template>
	<!-- 	
	<xsl:template match="USER" mode="r_previewauthor">
	Use: The author of the asset
	-->
	<xsl:template match="USER" mode="r_previewauthor">
		<div class="author">Created by <xsl:apply-imports/></div>
	</xsl:template>
	<!--			
	<xsl:template match="PHRASES" mode="r_displayasset">
	Use: The list of tags associated with this asset
	-->
	<xsl:template match="PHRASES" mode="r_displayasset">
		<xsl:apply-templates select="PHRASE" mode="c_displayasset"/>
		<br/>
		<br/>
	</xsl:template>
	<!--			
	<xsl:template match="PHRASE" mode="r_displayasset">
	Use: Presentation of each individual tag associated with this asset
	-->
	<xsl:template match="PHRASE" mode="r_displayasset">
		<!-- 
			am overriding import because of suspected bug in base skin?
			display should use PHRASE/NAME rather than DISPLAY/TERM
		-->
		<!--
		<xsl:apply-imports/>
		-->
		<a href="{$root}MediaAssetSearchPhrase?contenttype={../../CONTENTTYPE}&amp;phrase={TERM}" xsl:use-attribute-sets="mPHRASE_r_displayasset">
			<xsl:value-of select="NAME"/>
		</a>
		
		<xsl:if test="following-sibling::PHRASE">
			<xsl:text>, </xsl:text>
		</xsl:if>
	</xsl:template>
	<!-- 	
	<xsl:template match="PARAMS" mode="r_backlink">
	Use: A link back to the mediaassetsearchphrase page
	The text is contained in the variable $m_mediaassetlinktomasp
	-->
	<xsl:template match="PARAMS" mode="r_backlink">
		<xsl:apply-imports/>
		<br/>
	</xsl:template>
	
	<!-- 
	<xsl:template match="" mode="">
	Use: 
	-->
	<xsl:template match="EXTRAELEMENTXML" mode="t_details">
		<xsl:call-template name="DURATION" />
		<xsl:apply-templates select="ASPECT_RATIO" mode="t_detail"/>
		<xsl:apply-templates select="CREDIT" mode="t_detail"/>
	</xsl:template>
	
	<!-- 
	<xsl:template match="" mode="">
	Use: 
	-->
	<xsl:template match="ASPECT_RATIO" mode="t_detail">
		<div class="info"><b>Aspect Ratio: </b><xsl:value-of select="." /></div>
	</xsl:template>
	
	<!-- 
	<xsl:template match="" mode="">
	Use: 
	-->
	<xsl:template match="CREDIT" mode="t_detail">
		<div class="info"><b>Credits: </b><xsl:value-of select="." /></div>
	</xsl:template>
	
	<!-- 
	<xsl:template match="" mode="">
	Use: 
	-->
	<xsl:template match="FILE_SIZE" mode="t_detail">
		<div class="dlSize"><xsl:value-of select="." /></div>
	</xsl:template>
	
	<!-- 
	<xsl:template match="" mode="">
	Use: 
	-->
	<xsl:template name="DURATION">
		<xsl:if test="DURATION_MINS or DURATION_SECS">
		<div class="info"><b>Duration: </b> 
		<xsl:choose>
			<xsl:when test="DURATION_MINS &gt; 1">
				<xsl:value-of select="DURATION_MINS"/>:<xsl:value-of select="DURATION_SECS"/>min
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="DURATION_SECS"/>sec
			</xsl:otherwise>
		</xsl:choose>
		</div>
		</xsl:if>
	</xsl:template>
	
	
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
								UMA Page
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	<!-- 
	<xsl:template match="MEDIAASSETINFO" mode="r_uma">
	Use: The list of media assets associated with a user
	-->
	<xsl:template match="MEDIAASSETINFO" mode="r_uma">
		<xsl:apply-templates select="MEDIAASSET" mode="c_uma"/>
	</xsl:template>
	<!-- 
	<xsl:template match="MEDIAASSET" mode="r_uma">
	Use: Display of a single media asset 
	This is taken from <xsl:template match="MEDIAASSET" mode="r_displayasset"> above
	-->
	<xsl:template match="MEDIAASSET" mode="r_uma">
		<xsl:apply-templates select="." mode="r_displayasset"/>
	</xsl:template>
	
	
	<!--
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
								ADDED BY AL
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	-->
	
	<!-- 
	<xsl:template match="MEDIAASSETBUILDER/ARTICLEMEDIAASSETINFO[ACTION='showusersarticleswithassets']">
	Use: The list of articles with media assets associated with a user
	-->
	<xsl:template match="MEDIAASSETBUILDER/ARTICLEMEDIAASSETINFO[ACTION='showusersarticleswithassets']">
	<xsl:variable name="userid">
		<xsl:choose>
			<!-- Al 2006-06-07: need to test for USER as currenlty only appears on dev server - will go live after next sprint -->
			<xsl:when test="/H2G2/MEDIAASSETBUILDER/ARTICLEMEDIAASSETINFO/USER">
				<xsl:value-of select="USER/USERID"/>
			</xsl:when>
			<!-- USERSID currenlty on live but not on dev - can remove after next code release after next sprint -->
			<xsl:otherwise>
				<xsl:value-of select="USERSID"/>
			</xsl:otherwise>
		</xsl:choose><!-- NOTE: test for /USER occurs 3 times on this page - remove them all when you can -->
	</xsl:variable>
	
	<h1>
	<xsl:choose>
		<xsl:when test="/H2G2/VIEWING-USER/USER/USERID = $userid">
			<!-- YOUR PERSONAL SPACE - PAGE TITLES -->
			<xsl:choose>
				<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_display']/VALUE = 'submissionlog'">
					<img src="{$imagesource}h1_yoursubmissionslog.gif" alt="your submissions log" width="254" height="26" />
				</xsl:when>
				<xsl:when test="@CONTENTTYPE=1">
					<img src="{$imagesource}h1_yourportfolioallimages.gif" alt="your portfolio: all images" width="294" height="26" />
				</xsl:when>
				<xsl:when test="@CONTENTTYPE=2">
					<img src="{$imagesource}h1_yourportfolioallaudio.gif" alt="your portfolio: all audio" width="275" height="26" />
				</xsl:when>
				<xsl:when test="@CONTENTTYPE=3">
					<img src="{$imagesource}h1_yourportfolioallvideo.gif" alt="your portfolio: all video" width="272" height="26" />
				</xsl:when>
				<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_display']/VALUE = 'programmechallenges'">
					<img src="{$imagesource}h1_yourportfolioallchallenges.gif" alt="your portfolio: all challenges" width="334" height="26" />
				</xsl:when>
				<xsl:otherwise>
				<!-- default -->
					<img src="/comedysoup/images/h1_yourportfolioallvideo.gif" alt="your portfolio: all video" width="272" height="26" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:when>
		<xsl:otherwise>
			<!-- THEIR PERSONAL SPACE - PAGE TITLES -->
			<xsl:choose>
				<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_display']/VALUE = 'submissionlog'">
					<!-- show nothing -->
				</xsl:when>
				<xsl:when test="@CONTENTTYPE=1">
					<img src="{$imagesource}h1_theirportfolioallimages.gif" alt="your portfolio: all images" width="294" height="26" />
				</xsl:when>
				<xsl:when test="@CONTENTTYPE=2">
					<img src="{$imagesource}h1_theirportfolioallaudio.gif" alt="your portfolio: all audio" width="275" height="26" />
				</xsl:when>
				<xsl:when test="@CONTENTTYPE=3">
					<img src="{$imagesource}h1_theirportfolioallvideo.gif" alt="your portfolio: all video" width="272" height="26" />
				</xsl:when>
				<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_display']/VALUE = 'programmechallenges'">
					<img src="{$imagesource}h1_theirportfolioallchallenges.gif" alt="your portfolio: all challenges" width="334" height="26" />
				</xsl:when>
				<xsl:otherwise>
				<!-- default -->
					<img src="/comedysoup/images/h1_theirportfolioallvideo.gif" alt="your portfolio: all video" width="272" height="26" />
				</xsl:otherwise>
			</xsl:choose>
			<xsl:if test="USER">
				<!--
				<span class="userName"><xsl:value-of select="USER/FIRSTNAMES"/><xsl:text> </xsl:text><xsl:value-of select="USER/LASTNAME"/></span><span class="clr"></span>
				-->
				<xsl:choose>
					<xsl:when test="@CONTENTTYPE=1">
						<xsl:call-template name="USERRSSICON">
							<xsl:with-param name="feedtype">image</xsl:with-param>
							<xsl:with-param name="userid" select="$userid"/>
							<xsl:with-param name="firstnames" select="USER/FIRSTNAMES"/>
							<xsl:with-param name="lastname" select="USER/LASTNAME"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="@CONTENTTYPE=2">
						<xsl:call-template name="USERRSSICON">
							<xsl:with-param name="feedtype">audio</xsl:with-param>
							<xsl:with-param name="userid" select="$userid"/>
							<xsl:with-param name="firstnames" select="USER/FIRSTNAMES"/>
							<xsl:with-param name="lastname" select="USER/LASTNAME"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="@CONTENTTYPE=3">
						<xsl:call-template name="USERRSSICON">
							<xsl:with-param name="feedtype">video</xsl:with-param>
							<xsl:with-param name="userid" select="$userid"/>
							<xsl:with-param name="firstnames" select="USER/FIRSTNAMES"/>
							<xsl:with-param name="lastname" select="USER/LASTNAME"/>
						</xsl:call-template>
					</xsl:when>
				</xsl:choose>
			</xsl:if>
		</xsl:otherwise>
	</xsl:choose>
	</h1>
	
	<div id="yourPortfolio" class="personalspace">
		<div class="inner">
			<div class="col1">
				<div class="margins">
				
				<xsl:choose>
					<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_display']/VALUE = 'submissionlog'">
					<!-- SUBMISSION LOG -->
						<xsl:choose>
							<xsl:when test="/H2G2/VIEWING-USER/USER/USERID = $userid">
							<!-- viewer is owner -->
								
								<!-- sort by -->
								<xsl:call-template name="SORT_BY" />
								
								<!-- pagination block -->
								<xsl:call-template name="PAGINATION_BLOCK" />
								
								<ul class="sublogList">
								<xsl:for-each select="ARTICLE">
									<li>
										<div class="date"><xsl:value-of select="DATECREATED/DATE/@DAY"/>/<xsl:value-of select="DATECREATED/DATE/@MONTH"/>/<xsl:value-of select="DATECREATED/DATE/@YEAR"/></div>   
										<div class="title"><xsl:value-of select="SUBJECT"/></div>
										<div class="format">
											<xsl:choose>
												<xsl:when test="MEDIAASSET/CONTENTTYPE=1">
												image
												</xsl:when>
												<xsl:when test="MEDIAASSET/CONTENTTYPE=2">
												audio
												</xsl:when>
												<xsl:when test="MEDIAASSET/CONTENTTYPE=3">
												video
												</xsl:when>
											</xsl:choose>
											<xsl:if test="EXTRAINFO/PCCAT &gt; 0">
												<span class="challenge">CHALLENGE</span>
											</xsl:if>
										</div>
										<div>
											<xsl:choose>
												<xsl:when test="MEDIAASSET/HIDDEN=2 or MEDIAASSET/HIDDEN=3">
													<xsl:attribute name="class">status pending</xsl:attribute>
												</xsl:when>
												<xsl:when test="MEDIAASSET/HIDDEN=1">
													<xsl:attribute name="class">status declined</xsl:attribute>
												</xsl:when>
												<xsl:otherwise>
													<xsl:attribute name="class">status accepted</xsl:attribute>
												</xsl:otherwise>
											</xsl:choose>
										
										<xsl:choose>
											<xsl:when test="MEDIAASSET/HIDDEN=1">
											Failed
											</xsl:when>
											<xsl:when test="MEDIAASSET/HIDDEN=2 or MEDIAASSET/HIDDEN=3">
											In moderation
											</xsl:when>
											<xsl:otherwise>
											<strong>Passed</strong>
											</xsl:otherwise>
										</xsl:choose>
										</div>
									</li>
								</xsl:for-each>
								</ul>
								
								<!-- pagination block -->
								<xsl:call-template name="PAGINATION_BLOCK" />
								
							</xsl:when>
							<xsl:otherwise>
							<p>Sorry, you are unable to view another person's submission log. </p>
							</xsl:otherwise>
						
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>
					<!-- PORTFOLIO -->
					
					<!-- sort by -->
					<xsl:call-template name="SORT_BY" />
					
					<!-- pagination block -->
					<xsl:call-template name="PAGINATION_BLOCK" />
					
					<!-- 4 column asset nav component -->
					<ul class="assetNav4Col">
						<li><a href="UAMA{$userid}?ContentType=3&amp;s_fid={/H2G2/PARAMS/PARAM[NAME='s_fid']/VALUE}">
						<xsl:if test="@CONTENTTYPE=3">
							<xsl:attribute name="class">selected</xsl:attribute>
						</xsl:if>
						Video</a></li>
						<li><a href="UAMA{$userid}?ContentType=1&amp;s_fid={/H2G2/PARAMS/PARAM[NAME='s_fid']/VALUE}">
						<xsl:if test="@CONTENTTYPE=1">
							<xsl:attribute name="class">selected</xsl:attribute>
						</xsl:if>
						Images</a></li>
						<li><a href="UAMA{$userid}?ContentType=2&amp;s_fid={/H2G2/PARAMS/PARAM[NAME='s_fid']/VALUE}">
						<xsl:if test="@CONTENTTYPE=2">
							<xsl:attribute name="class">selected</xsl:attribute>
						</xsl:if>Audio</a></li>
						<!--
						PROGRAMMES CHALLENGES - not ready yet
						
						<li class="last"><a href="UAMA{$userid}?s_display=programmechallenges">
						<xsl:if test="/H2G2/PARAMS/PARAM[NAME = 's_display']/VALUE = 'programmechallenges'">
							<xsl:attribute name="class">selected</xsl:attribute>
						</xsl:if>Challenges</a></li>
						-->
					</ul>
					<div class="clr"></div>
					<!--// 4 column asset nav component -->
					
					<!-- Results list component -->
					<ul class="resultsList">
							<xsl:for-each select="ARTICLE[MEDIAASSET/SITEID = /H2G2/CURRENTSITE]">
								<xsl:variable name="fileextension">
									<xsl:choose>
										<xsl:when test="MEDIAASSET/MIMETYPE='image/gif'">.gif</xsl:when>
										<xsl:otherwise>.jpg</xsl:otherwise>
									</xsl:choose>
								</xsl:variable>
								<xsl:variable name="moderated">
									<xsl:if test="MEDIAASSET/HIDDEN and $test_IsEditor='true'">.mod</xsl:if>
								</xsl:variable>
								<li class="smallFB">
								<xsl:choose>
									<xsl:when test="position()=last()">
										<xsl:attribute name="class">smallFB last</xsl:attribute>
									</xsl:when>
									<xsl:otherwise>
										<xsl:attribute name="class">smallFB</xsl:attribute>
									</xsl:otherwise>
								</xsl:choose>
								
									<div class="imageHolder">
										<xsl:choose>
											<xsl:when test="MEDIAASSET/CONTENTTYPE=1">
											<xsl:choose>
												<xsl:when test="MEDIAASSET/HIDDEN and not($test_IsEditor='true')"><p>Awaiting Moderation</p></xsl:when>
												<xsl:otherwise><a href="A{@H2G2ID}"><img src="{$assetlibrary}{MEDIAASSET/FTPPATH}{MEDIAASSET/@MEDIAASSETID}_thumb{$fileextension}{$moderated}" /></a></xsl:otherwise>
											</xsl:choose>
											</xsl:when>
											<xsl:when test="MEDIAASSET/CONTENTTYPE=2">
											<a href="A{@H2G2ID}"><img src="{$imagesource}audio_asset_134x134.gif" width="134" height="134" alt="" /></a>
											</xsl:when>
											<xsl:when test="MEDIAASSET/CONTENTTYPE=3">
											<a href="A{@H2G2ID}"><img src="{$imagesource}video/134/{MEDIAASSET/@MEDIAASSETID}.jpg" alt="{../SUBJECT/text()}" /></a>
											</xsl:when>
										</xsl:choose>
									</div>
									<div class="content">
										<h2 class="fbHeader"><a href="A{@H2G2ID}"><xsl:value-of select="SUBJECT"/></a></h2>
										<p><xsl:value-of select="EXTRAINFO/AUTODESCRIPTION"/></p>
										<div class="starRating">user rating:
											<xsl:choose>
												<xsl:when test="MEDIAASSET/POLL/STATISTICS/@AVERAGERATING > 0" >
													<img src="{$imagesource}stars_{floor(MEDIAASSET/POLL/STATISTICS/@AVERAGERATING)}.gif" alt="{floor(MEDIAASSET/POLL/STATISTICS/@AVERAGERATING)}" width="65" height="12" />
												</xsl:when>
												<xsl:otherwise>
													not yet rated
												</xsl:otherwise>
											</xsl:choose>
										</div>
										<div class="description">
										<!-- contenttype -->
										<xsl:choose>
											<xsl:when test="MEDIAASSET/CONTENTTYPE=1">
											image
											</xsl:when>
											<xsl:when test="MEDIAASSET/CONTENTTYPE=2">
											audio
											</xsl:when>
											<xsl:when test="MEDIAASSET/CONTENTTYPE=3">
											video
											</xsl:when>
										</xsl:choose> <span>
										<xsl:if test="EXTRAINFO/DURATION_MINS and EXTRAINFO/DURATION_SECS">
										<!-- duration -->
											| <xsl:value-of select="EXTRAINFO/DURATION_MINS"/>.<xsl:value-of select="EXTRAINFO/DURATION_SECS"/>min
										</xsl:if>
										<!-- mimetype -->
										| 
										<xsl:choose>
											<xsl:when test="MEDIAASSET/MIMETYPE='image/jpeg' or MEDIAASSET/MIMETYPE='image/pjpeg' or MEDIAASSET/MIMETYPE='image/jpg'">
											jpg
											</xsl:when>
											<xsl:when test="MEDIAASSET/MIMETYPE='image/gif'">
											gif
											</xsl:when>
											<xsl:when test="MEDIAASSET/MIMETYPE='audio/mp3'">
											mp3
											</xsl:when>
											<xsl:when test="MEDIAASSET/MIMETYPE='video/quicktime'">
											mov
											</xsl:when>
											<xsl:when test="MEDIAASSET/MIMETYPE='mov'">
											mov
											</xsl:when>
											<xsl:when test="MEDIAASSET/MIMETYPE='video/x-ms-wmv'">
											wmv
											</xsl:when>
											<xsl:when test="MEDIAASSET/MIMETYPE='avi'">
											avi
											</xsl:when>
										</xsl:choose></span>
										<xsl:if test="EXTRAINFO/PCCAT &gt; 0">
											<span class="challenge">CHALLENGE</span>
										</xsl:if>
										</div>
									</div>
									<div class="clr"></div>
								</li>
							</xsl:for-each>
							</ul>
					
					<!--// Results list component -->
					
					<!-- pagination block -->
					<xsl:call-template name="PAGINATION_BLOCK" />
					
					</xsl:otherwise>
				</xsl:choose>
				
				
				</div>
			</div><!--// col1 -->
		
			<div class="col2">
				<div class="margins">
					<!-- Arrow list component -->
					<ul class="arrowList">
						<xsl:variable name="forumid" select="/H2G2/PARAMS/PARAM[NAME='s_fid']/VALUE"/>
						<xsl:choose>
							<xsl:when test="/H2G2/VIEWING-USER/USER/USERID = $userid">
								<li class="backArrow"><a href="{$root}U{$userid}">Back to your personal space</a></li>
								<xsl:choose>
									<xsl:when test="not(/H2G2/PARAMS/PARAM[NAME = 's_display']/VALUE = 'submissionlog')">
										<li class="arrow"><a href="UAMA{$userid}?s_display=submissionlog&amp;s_fid={$forumid}">Submission Log</a></li>
									</xsl:when>
								</xsl:choose>
								
								<li class="arrow"><a href="UAMA{$userid}?ContentType=3&amp;s_fid={$forumid}">All your video</a></li>
								<li class="arrow"><a href="UAMA{$userid}?ContentType=1&amp;s_fid={$forumid}">All your images</a></li>
								<li class="arrow"><a href="UAMA{$userid}?ContentType=2&amp;s_fid={$forumid}">All your audio</a></li>
								<li class="arrow"><a href="Watch{$userid}">Contacts</a></li>
								<li class="arrow"><a href="F{$forumid}">Messages</a></li>
							</xsl:when>
							<xsl:otherwise>
								<li class="backArrow"><a href="{$root}U{$userid}">Back to their personal space</a></li>
								<li class="arrow"><a href="Watch{$userid}">Contacts</a></li>
								<li class="arrow"><a href="F{$forumid}">Messages</a></li>
							</xsl:otherwise>
						</xsl:choose>
						
						<!-- TODO: message link
						/H2G2/ARTICLE/ARTICLEINFO/FORUMID is not available on the mediaassetpage 
						- need to ask steve if it can be made available
						-->
					
						<li class="arrow"><a href="{$root}yourspace">Help</a></li>
						
					</ul>
					<!--// Arrow list component -->
					<a href="{$root}submityourstuff" class="button twoline"><span><span><span>Get your stuff on ComedySoup</span></span></span></a>
				</div>
			</div><!--// col2 -->
			<div class="clr"></div>
		</div>
	</div>
</xsl:template>



<!-- pagination -->
<xsl:template name="PAGINATION_BLOCK">
	<xsl:variable name="contentfilter">
		<xsl:choose>
			<xsl:when test="@CONTENTTYPE=1">
				1
			</xsl:when>
			<xsl:when test="@CONTENTTYPE=2">
				2
			</xsl:when>
			<xsl:when test="@CONTENTTYPE=3">
				3
			</xsl:when>
			<xsl:otherwise>
			0
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<xsl:variable name="sparam_submissionlog">
		<xsl:if test="/H2G2/PARAMS/PARAM[NAME = 's_display']/VALUE = 'submissionlog'">
		&amp;s_display=submissionlog
		</xsl:if>
	</xsl:variable>

	<xsl:variable name="userid">
		<xsl:choose>
			<!-- Al 2006-06-07: need to test for USER as currenlty only appears on dev server - will go live after next sprint -->
			<xsl:when test="/H2G2/MEDIAASSETBUILDER/ARTICLEMEDIAASSETINFO/USER">
				<xsl:value-of select="USER/USERID"/>
			</xsl:when>
			<!-- USERSID currenlty on live but not on dev - can remove after next code release after next sprint -->
			<xsl:otherwise>
				<xsl:value-of select="USERSID"/>
			</xsl:otherwise>
		</xsl:choose><!-- NOTE: test for /USER occurs 3 times on this page - remove them all when you can -->
	</xsl:variable>

	<div class="paginationBlock">
	<!-- TODO: make this into a recursive templates that goes up to any number -->
		
		<!-- previous -->
		<xsl:choose>
			<xsl:when test="@SKIPTO != 0">
				<span class="prev_active">
				<a href="{$root}UAMA{$userid}?ContentType={$contentfilter}{$sparam_submissionlog}&amp;skip={@SKIPTO - 20}&amp;show=20&amp;sortby={@SORTBY}">
					<b>previous</b>
				</a>
				|</span>
			</xsl:when>
			<xsl:otherwise>
				<span class="prev_dormant">
					<b>previous</b>
				|</span>
			</xsl:otherwise>
		</xsl:choose>
		
		
		<xsl:choose>
			<xsl:when test="@SKIPTO != 0">
				<a href="{$root}UAMA{$userid}?ContentType={$contentfilter}{$sparam_submissionlog}&amp;skip=0&amp;show=20&amp;sortby={@SORTBY}">
					1
				</a>
			</xsl:when>
			<xsl:otherwise>
				1
			</xsl:otherwise>
		</xsl:choose>
		
		<xsl:choose>
			<xsl:when test="@SKIPTO != 20 and @TOTAL > 20">
				<xsl:text> </xsl:text><a href="{$root}UAMA{$userid}?ContentType={$contentfilter}{$sparam_submissionlog}&amp;skip=20&amp;show=20&amp;sortby={@SORTBY}">
				2
				</a>
			</xsl:when>
			<xsl:when test="@TOTAL > 20">
				 2
			</xsl:when>
		</xsl:choose>
		
		<xsl:choose>
			<xsl:when test="@SKIPTO != 40 and @TOTAL > 40">
				<xsl:text> </xsl:text><a href="{$root}UAMA{$userid}?ContentType={$contentfilter}{$sparam_submissionlog}&amp;skip=40&amp;show=20&amp;sortby={@SORTBY}">
				3
				</a>
			</xsl:when>
			<xsl:when test="@TOTAL > 40">
				 3
			</xsl:when>
		</xsl:choose>
		
		<xsl:choose>
			<xsl:when test="@SKIPTO != 60 and @TOTAL > 60">
				<xsl:text> </xsl:text><a href="{$root}UAMA{$userid}?ContentType={$contentfilter}{$sparam_submissionlog}&amp;skip=60&amp;show=20&amp;sortby={@SORTBY}">
				4
				</a>
			</xsl:when>
			<xsl:when test="@TOTAL > 60">
				 4
			</xsl:when>
		</xsl:choose>
		
		<xsl:choose>
			<xsl:when test="@SKIPTO != 80 and @TOTAL > 80">
				<xsl:text> </xsl:text><a href="{$root}UAMA{$userid}?ContentType={$contentfilter}{$sparam_submissionlog}&amp;skip=80&amp;show=20&amp;sortby={@SORTBY}">
				5
				</a>
			</xsl:when>
			<xsl:when test="@TOTAL > 80">
				 5
			</xsl:when>
		</xsl:choose>
		
		<xsl:choose>
			<xsl:when test="@SKIPTO != 100 and @TOTAL > 100">
				<xsl:text> </xsl:text><a href="{$root}UAMA{$userid}?ContentType={$contentfilter}{$sparam_submissionlog}&amp;skip=100&amp;show=20&amp;sortby={@SORTBY}">
				6
				</a>
			</xsl:when>
			<xsl:when test="@TOTAL > 100">
				 6
			</xsl:when>
		</xsl:choose>
		
		<xsl:choose>
			<xsl:when test="@SKIPTO != 120 and @TOTAL > 120">
				<xsl:text> </xsl:text><a href="{$root}UAMA{$userid}?ContentType={$contentfilter}{$sparam_submissionlog}&amp;skip=120&amp;show=20&amp;sortby={@SORTBY}">
				7
				</a>
			</xsl:when>
			<xsl:when test="@TOTAL > 120">
				 7
			</xsl:when>
		</xsl:choose>
		
		<xsl:choose>
			<xsl:when test="@SKIPTO != 140 and @TOTAL > 140">
				<xsl:text> </xsl:text><a href="{$root}UAMA{$userid}?ContentType={$contentfilter}{$sparam_submissionlog}&amp;skip=140&amp;show=20&amp;sortby={@SORTBY}">
				8
				</a>
			</xsl:when>
			<xsl:when test="@TOTAL > 140">
				 8
			</xsl:when>
		</xsl:choose>
		
		<xsl:choose>
			<xsl:when test="@SKIPTO != 160 and @TOTAL > 160">
				<xsl:text> </xsl:text><a href="{$root}UAMA{$userid}?ContentType={$contentfilter}{$sparam_submissionlog}&amp;skip=160&amp;show=20&amp;sortby={@SORTBY}">
				9
				</a>
			</xsl:when>
			<xsl:when test="@TOTAL > 160">
				 9
			</xsl:when>
		</xsl:choose>
		
		<xsl:choose>
			<xsl:when test="@SKIPTO != 180 and @TOTAL > 180">
				<xsl:text> </xsl:text><a href="{$root}UAMA{$userid}?ContentType={$contentfilter}{$sparam_submissionlog}&amp;skip=180&amp;show=20&amp;sortby={@SORTBY}">
				10
				</a>
			</xsl:when>
			<xsl:when test="@TOTAL > 180">
				 10
			</xsl:when>
		</xsl:choose>
		
		
		<!-- next -->
		<xsl:choose>
			<xsl:when test="@MORE = 1">
				<span class="next_active">|
				<a href="{$root}UAMA{$userid}?ContentType={$contentfilter}{$sparam_submissionlog}&amp;skip={@SKIPTO + 20}&amp;show=20&amp;sortby={@SORTBY}">
					<b>next</b>
				</a>
				</span>
			</xsl:when>
			<xsl:otherwise>
				<span class="next_dormant">|
					<b>next</b>
				</span>
			</xsl:otherwise>
		</xsl:choose>
		
	</div>
</xsl:template>



<xsl:template name="SORT_BY">

<!-- sort by -->
<div class="assetNavFormBlock">
	<form name="sortByForm" id="sortByForm" method="GET">
		<xsl:choose>
			<!-- Al 2006-06-07: need to test for USER as currenlty only appears on dev server - will go live after next sprint -->
			<xsl:when test="/H2G2/MEDIAASSETBUILDER/ARTICLEMEDIAASSETINFO/USER">
				<xsl:attribute name="action"><xsl:value-of select="$root"/>UAMA<xsl:value-of select="/H2G2/MEDIAASSETBUILDER/ARTICLEMEDIAASSETINFO/USER/USERID"/>?</xsl:attribute>
			</xsl:when>
			<!-- USERSID currenlty on live but not on dev - can remove after next code release after next sprint -->
			<xsl:otherwise>
				<xsl:attribute name="action"><xsl:value-of select="$root"/>UAMA<xsl:value-of select="/H2G2/MEDIAASSETBUILDER/ARTICLEMEDIAASSETINFO/USERSID"/>?</xsl:attribute>
			</xsl:otherwise>
		</xsl:choose><!-- NOTE: test for /USER occurs 3 times on this page - remove them all when you can -->
		
		<xsl:choose>
			<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_display']/VALUE = 'submissionlog'">
				<input type="hidden" name="s_display" value="submissionlog" />
			</xsl:when>
			<xsl:when test="/H2G2/MEDIAASSETBUILDER/ARTICLEMEDIAASSETINFO/@CONTENTTYPE = 3">
				<input type="hidden" name="ContentType" value="3" />
			</xsl:when>
			<xsl:when test="/H2G2/MEDIAASSETBUILDER/ARTICLEMEDIAASSETINFO/@CONTENTTYPE = 2">
				<input type="hidden" name="ContentType" value="2" />
			</xsl:when>
			<xsl:when test="/H2G2/MEDIAASSETBUILDER/ARTICLEMEDIAASSETINFO/@CONTENTTYPE = 1">
				<input type="hidden" name="ContentType" value="1" />
			</xsl:when>
		</xsl:choose>
		
		<label for="sortBy">Sort by:</label>						
		<select name="sortby" id="sortBy">
			<option value="DateUploaded" selected="selected">Most recent</option>
			<option value="Caption">
				<xsl:if test="/H2G2/MEDIAASSETBUILDER/ARTICLEMEDIAASSETINFO/@SORTBY='Caption'">
					<xsl:attribute name="selected">selected</xsl:attribute>
				</xsl:if>A-Z by title</option>
			<option value="Rating">
				<xsl:if test="/H2G2/MEDIAASSETBUILDER/ARTICLEMEDIAASSETINFO/@SORTBY='Rating'">
					<xsl:attribute name="selected">selected</xsl:attribute>
				</xsl:if>Highest rated</option>
	    </select>
		
		<input type="submit" value="Go &gt;" style="width:40px;margin:0" />
		
	</form>
</div>

</xsl:template>

<xsl:template name="ASSET_LIBRARY_TABS">
<ul class="assetNav3Col">
	<li><a href="{$root}MediaAssetSearchPhrase?contenttype=3">Video assets</a></li>
	<li><a href="{$root}MediaAssetSearchPhrase?contenttype=1">Images assets</a></li>
	<li class="last"><a href="{$root}MediaAssetSearchPhrase?contenttype=2">Audio assets</a></li>
	<div class="clr"></div>
</ul>
</xsl:template>


<!-- override the base template to provide the correct page name for the title tag -->
<xsl:template name="MEDIAASSET_HEADER">
	<xsl:variable name="whos_portfolio">
		<xsl:choose>
			<xsl:when test="/H2G2/VIEWING-USER/USER/USERID = /H2G2/MEDIAASSETBUILDER/ARTICLEMEDIAASSETINFO/USERSID">your portfolio: </xsl:when>
			<xsl:otherwise>their portfolio: </xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<xsl:apply-templates mode="header" select=".">
		<xsl:with-param name="title">
			<xsl:value-of select="$m_pagetitlestart"/>
			<xsl:choose>
			<!-- User articles with mediaassets -->
				<xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_display']/VALUE = 'submissionlog'">
					your submissions log
				</xsl:when>
				<xsl:when test="/H2G2/MEDIAASSETBUILDER/ARTICLEMEDIAASSETINFO/@CONTENTTYPE = 3">
					<xsl:value-of select="$whos_portfolio"/>all video
				</xsl:when>
				<xsl:when test="/H2G2/MEDIAASSETBUILDER/ARTICLEMEDIAASSETINFO/@CONTENTTYPE = 2">
					<xsl:value-of select="$whos_portfolio"/>all audio
				</xsl:when>
				<xsl:when test="/H2G2/MEDIAASSETBUILDER/ARTICLEMEDIAASSETINFO/@CONTENTTYPE = 1">
					<xsl:value-of select="$whos_portfolio"/>all images
				</xsl:when>	
			<!-- View/Download an Asset -->
				<xsl:when test="/H2G2/PARAMS/PARAM[NAME='s_display']/VALUE='licence'">
					asset information &amp; licence
				</xsl:when>
				<xsl:when test="/H2G2/PARAMS/PARAM[NAME='s_select']/VALUE='yes'">
					it's downloading
				</xsl:when>
				<xsl:when test="/H2G2/PARAMS/PARAM[NAME='s_select']/VALUE='no'">
					license declined
				</xsl:when>
				<xsl:when test="/H2G2/MEDIAASSETBUILDER/MEDIAASSETINFO/ACTION='View' and /H2G2/MEDIAASSETBUILDER/MEDIAASSETINFO/MEDIAASSET/CONTENTTYPE=1">
					images asset
				</xsl:when>
				<xsl:when test="/H2G2/MEDIAASSETBUILDER/MEDIAASSETINFO/ACTION='View' and /H2G2/MEDIAASSETBUILDER/MEDIAASSETINFO/MEDIAASSET/CONTENTTYPE=2">
					audio asset
				</xsl:when>
				<xsl:when test="/H2G2/MEDIAASSETBUILDER/MEDIAASSETINFO/ACTION='View' and /H2G2/MEDIAASSETBUILDER/MEDIAASSETINFO/MEDIAASSET/CONTENTTYPE=3">
					video asset
				</xsl:when>
			</xsl:choose>
			</xsl:with-param>
	</xsl:apply-templates>
</xsl:template>
	
<!--
EDITOR'S EDIT ASSET FUNCTIONS
-->
<xsl:variable name="updateassetfields"><![CDATA[<MULTI-INPUT>
									<REQUIRED NAME='MIMETYPE'><VALIDATE TYPE='EMPTY'/></REQUIRED>
									<ELEMENT NAME='ORIGINYEAR'><VALIDATE TYPE=''/></ELEMENT>
									<ELEMENT NAME='ORIGINMONTH'><VALIDATE TYPE=''/></ELEMENT>
									<ELEMENT NAME='ORIGINDAY'><VALIDATE TYPE=''/></ELEMENT>									
									<REQUIRED NAME='HIDDEN'><VALIDATE TYPE='EMPTY'/></REQUIRED>
								</MULTI-INPUT>]]>
</xsl:variable>


<!---
UPDATE ASSET FORM
-->
<xsl:template match="MEDIAASSETBUILDER/MEDIAASSETINFO/MULTI-STAGE" mode="update">
	<h1>Edit Media Asset Details</h1>
	<xsl:apply-templates select="/H2G2/ERROR" mode="t_errorpage"/>
	<xsl:apply-templates select="MULTI-REQUIRED/ERRORS"/>
	<form name="mediaassetdetails" method="post" action="{$root}MediaAsset">
		<input type="hidden" name="_msxml" value="{$updateassetfields}"/>
		<input type="hidden" name="addtolibrary" value="0"/>
		<input type="hidden" name="_msfinish" value="yes"/>
		<input type="hidden" name="manualupload" value="1"/>
		<xsl:if test="/H2G2/PARAMS/PARAM[NAME='s_articleid']">
			<input type="hidden" name="s_articleid" value="{/H2G2/PARAMS/PARAM[NAME='s_articleid']/VALUE}"/>
		</xsl:if>
	
		<xsl:if test="/H2G2/PARAMS/PARAM[NAME='s_mediaasset_updated']">			
			<p>
			<span class="challenge">MediaAsset <strong><xsl:value-of select="../ID"/></strong> updated.</span>
			<br/>
			<xsl:choose>
				<xsl:when test="MULTI-REQUIRED[@NAME='HIDDEN']/VALUE-EDITABLE = 0">
					Asset has been <strong>PASSED</strong>
				</xsl:when>
				<xsl:when test="MULTI-REQUIRED[@NAME='HIDDEN']/VALUE-EDITABLE = 1">
					Asset has been <strong>FAILED</strong>
				</xsl:when>
			</xsl:choose>
			<br/>
			Mime-type set to <strong><xsl:value-of select="MULTI-REQUIRED[@NAME='MIMETYPE']/VALUE-EDITABLE"/></strong>
			</p>
		</xsl:if>
		<p>
			MimeType:<br/>
			<xsl:call-template name="MimeTypeInput">
				<xsl:with-param name="setmimetype">
					<xsl:value-of select="MULTI-REQUIRED[@NAME='MIMETYPE']/VALUE-EDITABLE"/>
				</xsl:with-param>
			</xsl:call-template>
		</p>
		<p>
			Origin Date :
			<xsl:call-template name="OriginDateInput">
				<xsl:with-param name="setday"><xsl:value-of select="MULTI-ELEMENT[@NAME='ORIGINDAY']/VALUE"/></xsl:with-param>
				<xsl:with-param name="setmonth"><xsl:value-of select="MULTI-ELEMENT[@NAME='ORIGINMONTH']/VALUE"/></xsl:with-param>
				<xsl:with-param name="setyear"><xsl:value-of select="MULTI-ELEMENT[@NAME='ORIGINYEAR']/VALUE"/></xsl:with-param>
			</xsl:call-template>
		</p>
		<p>
			Hidden Status:<br/>
			<xsl:call-template name="HiddenStatusInput">
				<xsl:with-param name="setstatus">
					<xsl:value-of select="MULTI-REQUIRED[@NAME='HIDDEN']/VALUE-EDITABLE"/>
				</xsl:with-param>
			</xsl:call-template>
		</p>
		<input type="hidden" name="updatedatauploaded" value="{../UPDATEDATAUPLOADED}"/>
		<input type="hidden" name="action" value="{../ACTION}"/>
		<input type="hidden" name="h2g2id" value="{../UPDATEH2G2ID}"/>
		<input type="hidden" name="id" value="{../ID}"/>
		<input type="hidden" name="s_mediaasset_updated" value="1"/>
		<p>
			<input type="submit" value="Update"/>
		</p>
		<xsl:if test="/H2G2/PARAMS/PARAM[NAME='s_articleid']">
			<p>
				<a href="{$root}A{/H2G2/PARAMS/PARAM[NAME='s_articleid']/VALUE}">Back to Article</a>
			</p>
		</xsl:if>
	</form>
</xsl:template>

<xsl:template name="MimeTypeInput">
	<xsl:param name="setmimetype"/>
	
	<select name="mimetype">
		<option value="">----</option>
		<option value="bmp">
			<xsl:if test="$setmimetype = 'image/bmp' or $setmimetype = 'bmp'">
				<xsl:attribute name="selected">selected</xsl:attribute>
			</xsl:if>
			image/bmp (bmp)
		</option>
		<option value="gif">
			<xsl:if test="$setmimetype = 'image/gif' or $setmimetype = 'gif'">
				<xsl:attribute name="selected">selected</xsl:attribute>
			</xsl:if>
			image/gif (gif)
		</option>
		<option value="jpg">
			<xsl:if test="$setmimetype = 'image/jpeg' or $setmimetype = 'jpg'">
				<xsl:attribute name="selected">selected</xsl:attribute>
			</xsl:if>
			image/jpeg (jpg)
		</option>
		<option value="png">
			<xsl:if test="$setmimetype = 'image/png' or $setmimetype = 'png'">
				<xsl:attribute name="selected">selected</xsl:attribute>
			</xsl:if>
			image/png (png)
		</option>
		<option value="aud">
			<xsl:if test="$setmimetype = 'audio/aud' or $setmimetype = 'aud'">
				<xsl:attribute name="selected">selected</xsl:attribute>
			</xsl:if>
			audio/aud (aud)
		</option>
		<option value="mp1">
			<xsl:if test="$setmimetype = 'audio/mp1' or $setmimetype = 'mp1'">
				<xsl:attribute name="selected">selected</xsl:attribute>
			</xsl:if>
			audio/mp1 (mp1)
		</option>
		<option value="mp2">
			<xsl:if test="$setmimetype = 'audio/mp2' or $setmimetype = 'mp2'">
				<xsl:attribute name="selected">selected</xsl:attribute>
			</xsl:if>
			audio/mp2 (mp2)
		</option>
		<option value="mp3">
			<xsl:if test="$setmimetype = 'audio/mp3' or $setmimetype = 'mp3'">
				<xsl:attribute name="selected">selected</xsl:attribute>
			</xsl:if>
			audio/mp3 (mp3)
		</option>
		<option value="ra">
			<xsl:if test="$setmimetype = 'audio/x-pn-realaudio' or $setmimetype = 'ra'">
				<xsl:attribute name="selected">selected</xsl:attribute>
			</xsl:if>
			audio/x-pn-realaudio (ra)
		</option>
		<option value="wav">
			<xsl:if test="$setmimetype = 'audio/x-wav' or $setmimetype = 'wav'">
				<xsl:attribute name="selected">selected</xsl:attribute>
			</xsl:if>
			audio/x-wav (wav)
		</option>
		<option value="wma">
			<xsl:if test="$setmimetype = 'audio/x-ms-wma' or $setmimetype = 'wma'">
				<xsl:attribute name="selected">selected</xsl:attribute>
			</xsl:if>
			audio/x-ms-wma (wma)
		</option>
		<option value="avi">
			<xsl:if test="$setmimetype = 'video/avi' or $setmimetype = 'avi'">
				<xsl:attribute name="selected">selected</xsl:attribute>
			</xsl:if>
			video/avi (avi)
		</option>
		<option value="mov">
			<xsl:if test="$setmimetype = 'video/quicktime' or $setmimetype = 'mov'">
				<xsl:attribute name="selected">selected</xsl:attribute>
			</xsl:if>
			video/quicktime (mov)
		</option>
		<option value="mpg">
			<xsl:if test="$setmimetype = 'video/mpeg' or $setmimetype = 'mpg'">
				<xsl:attribute name="selected">selected</xsl:attribute>
			</xsl:if>
			video/mpeg (mpg)
		</option>
		<option value="rm">
			<xsl:if test="$setmimetype = 'application/vnd.rn-realmedia' or $setmimetype = 'rm'">
				<xsl:attribute name="selected">selected</xsl:attribute>
			</xsl:if>
			application/vnd.rn-realmedia (rm)
		</option>
		<option value="wmv">
			<xsl:if test="$setmimetype = 'video/x-ms-wmv' or $setmimetype = 'wmv'">
				<xsl:attribute name="selected">selected</xsl:attribute>
			</xsl:if>
			video/x-ms-wmv (wmv)
		</option>
		<option value="swf">
			<xsl:if test="$setmimetype = 'application/x-shockwave-flash' or $setmimetype = 'swf'">
				<xsl:attribute name="selected">selected</xsl:attribute>
			</xsl:if>
			application/x-shockwave-flash (swf)
		</option>
		<option value="flv">
			<xsl:if test="$setmimetype = 'video/x-flv' or $setmimetype = 'flv'">
				<xsl:attribute name="selected">selected</xsl:attribute>
			</xsl:if>
			video/x-flv (flv)
		</option>		
	</select>
</xsl:template>

<xsl:template name="HiddenStatusInput">
	<xsl:param name="setstatus" />
	<select name="hidden">
		<option value="">----</option>
		<option value="0">
			<xsl:if test="$setstatus = 0">
				<xsl:attribute name="selected">selected</xsl:attribute>
			</xsl:if>
			0 - Passed / Visible
		</option>
		<option value="1">
			<xsl:if test="$setstatus = 1">
				<xsl:attribute name="selected">selected</xsl:attribute>
			</xsl:if>
			1 - Failed
		</option>
		<!--
		<option value="2">
			<xsl:if test="$setstatus = 2">
				<xsl:attribute name="selected">selected</xsl:attribute>
			</xsl:if>
			2 - Refered / Hidden
		</option>
		-->
		<!--
		<option value="3">
			<xsl:if test="$setstatus = 3">
				<xsl:attribute name="selected">selected</xsl:attribute>
			</xsl:if>
			3 - In Moderation
		</option>
		-->
	</select>
</xsl:template>

<xsl:template name="OriginDateInput">
	<xsl:param name="setday">31</xsl:param>
	<xsl:param name="setmonth">12</xsl:param>
	<xsl:param name="setyear">2005</xsl:param>
	Day 
	<select name="originday">
		<option value="{$setday}"><xsl:value-of select="$setday"/></option>
		<option value="01">01</option>
		<option value="02">02</option>
		<option value="03">03</option>
		<option value="04">04</option>
		<option value="05">05</option>
		<option value="06">06</option>
		<option value="07">07</option>
		<option value="08">08</option>
		<option value="09">09</option>
		<option value="10">10</option>
		<option value="11">11</option>
		<option value="12">12</option>
		<option value="10">10</option>
		<option value="11">11</option>
		<option value="12">12</option>
		<option value="13">13</option>
		<option value="14">14</option>
		<option value="15">15</option>
		<option value="16">16</option>
		<option value="17">17</option>
		<option value="18">18</option>
		<option value="19">19</option>
		<option value="20">20</option>
		<option value="21">21</option>
		<option value="22">22</option>
		<option value="23">23</option>
		<option value="24">24</option>
		<option value="25">25</option>
		<option value="26">26</option>
		<option value="27">27</option>
		<option value="28">28</option>
		<option value="29">29</option>
		<option value="30">30</option>
		<option value="31">31</option>
	</select>
	 Month 
	<select name="originmonth">
		<option value="{$setmonth}"><xsl:value-of select="$setmonth"/></option>
		<option value="01">01</option>
		<option value="02">02</option>
		<option value="03">03</option>
		<option value="04">04</option>
		<option value="05">05</option>
		<option value="06">06</option>
		<option value="07">07</option>
		<option value="08">08</option>
		<option value="09">09</option>
		<option value="10">10</option>
		<option value="11">11</option>
		<option value="12">12</option>
	</select>
	 Year 
	<select name="originyear" value="{$setyear}">
		<option value="{$setyear}"><xsl:value-of select="$setyear"/></option>
		<option value="2006">2007</option>
		<option value="2006">2006</option>
		<option value="2005">2005</option>
		<option value="2004">2004</option>
		<option value="2003">2003</option>
		<option value="2002">2002</option>
		<option value="2001">2001</option>
		<option value="2000">2000</option>
		<option value="1999">1999</option>
		<option value="1998">1998</option>
		<option value="1997">1997</option>
		<option value="1996">1996</option>
		<option value="1995">1995</option>
	</select>
</xsl:template>	
	
</xsl:stylesheet>
