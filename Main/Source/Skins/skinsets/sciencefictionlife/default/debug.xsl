<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">

<!-- DEBUG toggles -->
<xsl:variable name="DEBUG">0</xsl:variable>
<xsl:variable name="VARIABLETEST">0</xsl:variable>
<xsl:variable name="TESTING">0</xsl:variable>
	

<!-- TRACE/DEBUG -->
	<xsl:template name="TRACE">
	<xsl:param name="message" />
	<xsl:param name="pagename" />
	<xsl:if test="$DEBUG = 1 or /H2G2/PARAMS/PARAM[NAME = 's_debug']/VALUE = '1'">
	<div class="debug">
	Template name: <b><xsl:value-of select="$message" /></b><br />
	Stylesheet name: <b><xsl:value-of select="$pagename" /></b><br />
	page type: <strong><xsl:value-of select="/H2G2/@TYPE" /></strong>
	</div>
	</xsl:if>
	</xsl:template>


<!-- for HTMLOutput.xsl -->
<xsl:template name="VARIABLEDUMP">
	<xsl:if test="$VARIABLETEST = 1 or /H2G2/PARAMS/PARAM[NAME = 's_debug']/VALUE = '1'">
	<div class="debug">
	
	<div><a href="?skin=purexml">?pure xml</a></div>
	<div><a href="&amp;skin=purexml">&amp;pure xml</a></div>
	<div><a href="?clear_templates=1">clear_templates</a></div>
	<br/>
	
	<xsl:if test="$test_IsEditor">
	<div class="variable">you are an editor</div>
	</xsl:if>
	
	<div class="variable">H2G2 page TYPE:<br/> 
	<b><xsl:value-of select="/H2G2/@TYPE" /></b></div>
	</div>
	
	<div id="TRACE">
		<div><b>DEBUG VARIABLE DUMP</b></div> 
		<div class="text">current_article_type is: 
		<b><xsl:value-of select="$current_article_type" /></b></div>
		<div class="text">PREPROCESSED NUMBER: <br/>
		<b><xsl:value-of select="/H2G2/ARTICLE/ARTICLEINFO/PREPROCESSED" /></b></div>
		<div class="text">article_type_name is: 
		<b><xsl:value-of select="$article_type_name" /></b></div> 
		<div class="text">article_type_group is: 
		<b><xsl:value-of select="$article_type_group" /></b></div>
		<div class="text">article_subtype is: 
		<b><xsl:value-of select="$article_subtype" /></b></div>
		<div class="text">layout_type is: 
		<b><xsl:value-of select="$layout_type" /></b></div>
		<div class="text">edit preview mode is: 
		<b><xsl:value-of select="/H2G2/MULTI-STAGE/@TYPE" /></b></div>
		<div class="text">page author ID: 
		<b><xsl:value-of select="/H2G2/ARTICLE/ARTICLEINFO/PAGEAUTHOR/EDITOR/USER/USERID" /></b></div>
		<div class="text">viewing user ID: 
		<b><xsl:value-of select="/H2G2/VIEWING-USER/USER/USERID" /></b></div>
		
	<div>article_subtype: <xsl:value-of select="$article_subtype" /></div>
	<div>article_type_group: <xsl:value-of select="$article_type_group" /></div>
	<div>article_type_user: <xsl:value-of select="$article_type_user" /></div>
	
	</div>
	</xsl:if>
</xsl:template>


<!-- display all objects on a page -->
<xsl:template match="/H2G2" mode="debug">
<div style="clear:both"><hr /></div>
<style type="text/css">
.debug {
	border:1px solid #D1C9BB;
	font-size:70%;
	background:#e2eeef;
	padding-top:5px;
	padding-bottom:5px;
	padding-left:5px;
	padding-right:5px;
	margin-left:5px;
	margin-bottom:10px;}
</style>


<div id="debuggingInfo">
	<h1>Debugging information </h1>
	
	<p><a href="#objects">skip to first object</a></p>
	
	<div class="debug">
		/H2G2<br />
		@type = <strong><xsl:value-of select="/H2G2/@TYPE" /></strong><br />	
		<table cellpadding="2" cellspacing="0" border="1" style="font-size:100%;">
		<xsl:for-each select="node()">
			<tr>
			<th valign="top" align="left"><xsl:value-of select="local-name(.)" /></th>
			<td>
			<xsl:choose>
				<xsl:when test="node() = text()">
				<span class="text"><xsl:value-of select="text()"/></span>
				</xsl:when>
				<xsl:otherwise>
					<!-- 2nd level -->
					<table cellpadding="2" cellspacing="0" border="1" style="font-size:100%;">
					<xsl:for-each select="node()">
						<tr>
						<th valign="top" align="left"><xsl:value-of select="local-name(.)" /></th>
						<td>
						<xsl:choose>
							<xsl:when test="node() = text()">
							<span class="text"><xsl:value-of select="text()"/></span>
							</xsl:when>
							<xsl:otherwise>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							<!-- 3rd level -->
							<!--
							<table cellpadding="2" cellspacing="0" border="1" style="font-size:100%;">
								<xsl:for-each select="node()">
									<tr>
									<th valign="top" align="left"><xsl:value-of select="local-name(.)" /></th>
									<td>
									<xsl:choose>
										<xsl:when test="node() = text()">
										<span class="text"><xsl:value-of select="text()"/></span>
										</xsl:when>
										<xsl:otherwise>
											&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
										</xsl:otherwise>
									</xsl:choose>
									</td>
									</tr>
								</xsl:for-each>
								</table>
							 -->							
							</xsl:otherwise>
						</xsl:choose>
						</td>
						</tr>
					</xsl:for-each>
					</table>
				</xsl:otherwise>
			</xsl:choose>
			</td>
			</tr>
		</xsl:for-each>
		</table>
	</div>
	
	<a name="objects"></a>
	<xsl:apply-templates select="/H2G2/ARTICLE" mode="debug"/>
	<xsl:apply-templates select="/H2G2/ARTICLEFORUM" mode="debug"/>
	<xsl:apply-templates select="/H2G2/ARTICLEHOT-PHRASES" mode="debug"/>
	<xsl:apply-templates select="/H2G2/ARTICLESEARCHPHRASE" mode="debug"/>
	<xsl:apply-templates select="/H2G2/DYNAMIC-LISTS" mode="debug"/>
	<xsl:apply-templates select="/H2G2/ERROR" mode="debug"/>
	<xsl:apply-templates select="/H2G2/HOT-PHRASES" mode="debug"/>
	<xsl:apply-templates select="/H2G2/MEDIAASSETBUILDER/ARTICLEMEDIAASSETINFO" mode="debug"/>
	<xsl:apply-templates select="/H2G2/MEDIAASSETINFO" mode="debug"/>
	<xsl:if test="/H2G2/MEDIAASSETBUILDER/MEDIAASSETINFO">
		<xsl:choose>
			<xsl:when test="/H2G2/MEDIAASSETBUILDER/MEDIAASSETINFO[ACTION='showusersassets']">
				<xsl:apply-templates select="/H2G2/MEDIAASSETBUILDER/MEDIAASSETINFO[ACTION='showusersassets']"  mode="debug"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="/H2G2/MEDIAASSETBUILDER/MEDIAASSETINFO" mode="debug"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:if>
	<xsl:apply-templates select="/H2G2/MEDIAASSETSEARCHPHRASE" mode="debug"/>
	<xsl:apply-templates select="/H2G2//MULTI-STAGE" mode="debug"/>
	<xsl:apply-templates select="/H2G2/PAGE-OWNER" mode="debug"/>
	<xsl:apply-templates select="/H2G2/PARAMS" mode="debug"/>
	<xsl:apply-templates select="/H2G2/POLL-LIST" mode="debug"/>
	<xsl:apply-templates select="/H2G2/RECENT-POSTS" mode="debug"/>
	<xsl:apply-templates select="/H2G2/RECENT-ENTRIES" mode="debug"/>
	<xsl:apply-templates select="/H2G2/RECENT-APPROVALS" mode="debug"/>
	<xsl:apply-templates select="/H2G2/SITECONFIG" mode="debug"/>
	<xsl:apply-templates select="/H2G2/TOP-FIVES" mode="debug"/>
	<xsl:apply-templates select="/H2G2/VIEWING-USER" mode="debug"/>
	
	<div class="debug">
	<h2>COLLECTIVE VARIABLES</h2>
	<strong>SITEVARS</strong><br />
	$sitedisplayname: <xsl:value-of select="$sitedisplayname" /><br />
	$sitename: <xsl:value-of select="$sitename" /><br />
	$root: <xsl:value-of select="$root" /><br />
	$sso_statbar_type: <xsl:value-of select="$sso_statbar_type" /><br />
	$sso_serviceid_path: <xsl:value-of select="$sso_serviceid_path" /><br />
	$sso_serviceid_link: <xsl:value-of select="$sso_serviceid_link" /><br />
	$sso_assets_path: <xsl:value-of select="$sso_assets_path" /><br />
	$imagesource: <xsl:value-of select="$imagesource" /><br />
	$smileysource: <xsl:value-of select="$smileysource" /><br />
	$graphics: <xsl:value-of select="$graphics" /><br />
	$fileextension: <xsl:value-of select="$fileextension" /><br />

	$site_server: <xsl:value-of select="$site_server" /><br />
	$dna_server: <xsl:value-of select="$dna_server" /><br />
	$site_number: <xsl:value-of select="$site_number" /><br />
	$contenttype: <xsl:value-of select="$contenttype" /><br />
	$downloadsurl: <xsl:value-of select="$downloadsurl" /><br />
	
	
	<br />
	<strong>ARTICLE</strong><br />
	$current_article_type = <xsl:value-of select="$current_article_type" /><br />
	$article_type_group = <strong><xsl:value-of select="$article_type_group" /></strong><br />
	$article_type_user = <strong><xsl:value-of select="$article_type_user" /></strong><br />
	$article_subtype = <strong><xsl:value-of select="$article_subtype" /></strong><br />
	$article_type_label = <strong><xsl:value-of select="$article_type_label" /></strong><br />
		
	<h2>DNA VARIABLES</h2>
	$contenttypepath: <xsl:value-of select="$contenttypepath" /><br />
	$test_IsEditor = <xsl:value-of select="$test_IsEditor" /><br />
	$ownerisviewer = <xsl:value-of select="$ownerisviewer" /><br />	
	$assetlibrary = <xsl:value-of select="$assetlibrary" /><br />
	
	$sso_signinlink = <xsl:value-of select="$sso_signinlink" /><br />
	$sso_registerlink = <xsl:value-of select="$sso_registerlink" /><br />
	$sso_redirectserver = <xsl:value-of select="$sso_redirectserver" /><br />
	$sso_serviceid_link = <xsl:value-of select="$sso_serviceid_link" /><br />
	$sso_ptrt = <xsl:value-of select="$sso_ptrt" /><br />
	$referrer = <xsl:value-of select="$referrer" /><br />
	$root = <xsl:value-of select="$root" /><br />
	$sso_rootlogin = <xsl:value-of select="$sso_rootlogin" /><br />
	$sso_rootregister = <xsl:value-of select="$sso_rootregister" /><br />
	</div>
	
</div>
</xsl:template>


<!-- 3 level table -->
<xsl:template name="tablex3">
<table cellpadding="2" cellspacing="0" border="1" style="font-size:100%;">
<xsl:for-each select="node()">
	<tr>
	<th valign="top" align="left"><xsl:value-of select="local-name(.)" /></th>
	<td>
	<xsl:choose>
		<xsl:when test="node() = text()">
		<span class="text"><xsl:value-of select="text()"/></span>
		</xsl:when>
		<xsl:otherwise>
			<!-- 2nd level -->
			<table cellpadding="2" cellspacing="0" border="1" style="font-size:100%;">
			<xsl:for-each select="node()">
				<tr>
				<th valign="top" align="left"><xsl:value-of select="local-name(.)" /></th>
				<td>
				<xsl:choose>
					<xsl:when test="node() = text()">
					<span class="text"><xsl:value-of select="text()"/></span>
					</xsl:when>
					<xsl:otherwise>
					<table cellpadding="2" cellspacing="0" border="1" style="font-size:100%;">
						<xsl:for-each select="node()">
							<tr>
							<th valign="top" align="left"><xsl:value-of select="local-name(.)" /></th>
							<td>
							<xsl:choose>
								<xsl:when test="node() = text()">
								<span class="text"><xsl:value-of select="text()"/></span>
								</xsl:when>
								<xsl:otherwise>
									&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
								</xsl:otherwise>
							</xsl:choose>
							</td>
							</tr>
						</xsl:for-each>
						</table>			
					</xsl:otherwise>
				</xsl:choose>
				</td>
				</tr>
			</xsl:for-each>
			</table>
		</xsl:otherwise>
	</xsl:choose>
	</td>
	</tr>
</xsl:for-each>
</table>
</xsl:template>

<!-- 
###############################################################
							Object A-Z
###############################################################
-->

<!-- ARTICLE
used on: articlepage.xsl -->
<xsl:template match="/H2G2/ARTICLE" mode="debug">
	<div class="debug">
		<h2>/H2G2/ARTICLE</h2>
		<br />
		TYPE = <strong><xsl:value-of select="EXTRAINFO/TYPE/@ID" /></strong><br />
		STATUS = <strong><xsl:value-of select="ARTICLEINFO/STATUS/@TYPE" /></strong> (<xsl:value-of select="/H2G2/ARTICLE/ARTICLEINFO/STATUS" />)<br />
		H2G2ID = <xsl:value-of select="ARTICLEINFO/H2G2ID" /><br />
		Page Author = <a href="{root}U{ARTICLEINFO/PAGEAUTHOR/EDITOR/USER/USERID}"><xsl:value-of select="ARTICLEINFO/PAGEAUTHOR/EDITOR/USER/USERNAME" /></a> (<xsl:value-of select="ARTICLEINFO/PAGEAUTHOR/EDITOR/USER/FIRSTNAMES" /><xsl:text> </xsl:text> <xsl:value-of select="ARTICLEINFO/PAGEAUTHOR/EDITOR/USER/LASTNAME" />)<br />
		Date created = <xsl:value-of select="ARTICLEINFO/DATECREATED/DATE/@SORT" /><br />
		Last updated = <xsl:value-of select="ARTICLEINFO/LASTUPDATED/DATE/@SORT" /><br />
		<br />
		$test_IsEditor = <xsl:value-of select="$test_IsEditor" /><br />
		$current_article_type = <xsl:value-of select="$current_article_type" /><br />
		$article_type_group = <strong><xsl:value-of select="$article_type_group" /></strong><br />
		$article_type_user = <strong><xsl:value-of select="$article_type_user" /></strong><br />
		$article_subtype = <strong><xsl:value-of select="$article_subtype" /></strong><br />
		$article_type_label = <strong><xsl:value-of select="$article_type_label" /></strong><br />
		<br />
		GUIDE<br />
		<table cellpadding="2" cellspacing="0" border="1" style="font-size:100%;">
		<xsl:for-each select="GUIDE/node()">
			<tr>
			<th valign="top" align="left"><xsl:value-of select="local-name(.)" /></th>
			<td><xsl:copy-of select="node()" /><br /></td>
			</tr>
		</xsl:for-each>
		</table>
		<br />
		EXTRAINFO<br />
		<table cellpadding="2" cellspacing="0" border="1" style="font-size:100%;">
		<xsl:for-each select="EXTRAINFO/node()">
			<tr>
					<xsl:choose>
						<xsl:when test="local-name(.)='TYPE'">
						<th valign="top" align="left">TYPE/@ID</th>
						<td><xsl:value-of select="./@ID"/></td>
						</xsl:when>
						<xsl:otherwise>
						<th valign="top" align="left"><xsl:value-of select="local-name(.)" /></th>
						<td><xsl:copy-of select="node()" /><br /></td>
						</xsl:otherwise>
					</xsl:choose>
				</tr>
		</xsl:for-each>
		</table>
	</div>
</xsl:template>


<!-- ARTICLEFORUM
used on: articlepage.xsl -->
<xsl:template match="/H2G2/ARTICLEFORUM" mode="debug">
	<div class="debug">
		<h2>/H2G2/ARTICLEFORUM</h2>
		@FORUMID:<xsl:value-of select="FORUMTHREADS/@FORUMID" /><br />
		@SKIPTO:<xsl:value-of select="FORUMTHREADS/@SKIPTO" /><br />
		@COUNT:<xsl:value-of select="FORUMTHREADS/@COUNT" /><br />
		@TOTALTHREADS:<xsl:value-of select="FORUMTHREADS/@TOTALTHREADS" /><br />
		@FORUMPOSTCOUNT:<xsl:value-of select="FORUMTHREADS/@FORUMPOSTCOUNT" /><br />
		
		<table cellpadding="2" cellspacing="0" border="1" style="font-size:100%;">
			<caption>FORUMTHREADS/THREAD</caption>
			<tr>
			<th>position()</th>
			<th>THREADID</th>
			<th>SUBJECT</th>
			<th>TOTALPOSTS</th>
			<th>DATEPOSTED/DATE</th>
			<th>FIRSTPOST</th>
			<th>LASTPOST</th>
			</tr>
			<xsl:for-each select="FORUMTHREADS/THREAD">
			<tr>
			<td><xsl:value-of select="position()"/></td>
			<td><xsl:value-of select="THREADID"/></td>
			<td><a href="{$root}F{@FORUMID}?thread={THREADID}"><xsl:value-of select="SUBJECT"/></a></td>
			<td><xsl:value-of select="TOTALPOSTS"/></td>
			<td><xsl:value-of select="DATEPOSTED/DATE/@DAY" />&nbsp;<xsl:value-of select="DATEPOSTED/DATE/@MONTHNAME" />&nbsp;<xsl:value-of select="DATEPOSTED/DATE/@YEAR" /><xsl:text> </xsl:text><xsl:value-of select="DATEPOSTED/DATE/@HOURS" />:<xsl:value-of select="DATEPOSTED/DATE/@MINUTES" />:<xsl:value-of select="DATEPOSTED/DATE/@SECONDS" /> - <xsl:value-of select="DATEPOSTED/DATE/@RELATIVE" /></td>
			<td><xsl:value-of select="FIRSTPOST/DATE/@RELATIVE" /></td>
			<td><xsl:value-of select="LASTPOST/DATE/@RELATIVE" /></td>
			</tr>
			</xsl:for-each>
		</table>
	</div>		
</xsl:template>

<!-- ARTICLEHOT-PHRASES
used on: articlesearchphrase.xsl -->
<!-- can't use this on the homepage as don't know what contenttype each term relates to -->
<xsl:template match="/H2G2/ARTICLEHOT-PHRASES" mode="debug">
	<xsl:if test="$DEBUG = 1 or /H2G2/PARAMS/PARAM[NAME = 's_debug']/VALUE = '1'">
		<div class="debug">
				/H2G2/ARTICLEHOT-PHRASES<br />
				@ASSETCONTENTTYPE: <xsl:value-of select="@ASSETCONTENTTYPE"/><br />
				@SKIP: <xsl:value-of select="@SKIP"/><br />
				@SHOW: <xsl:value-of select="@SHOW"/><br />
				@COUNT: <xsl:value-of select="@COUNT"/><br />
				@MORE: <xsl:value-of select="@MORE"/><br />
				<br />
				ARTICLEHOT-PHRASE
				<table cellpadding="0" cellspacing="0" border="1" style="font-size:100%;">
				<tr>
				<th>position</th>
				<th>name</th>
				<th>term</th>
				<th>rank</th>
				</tr>
				<xsl:for-each select="ARTICLEHOT-PHRASE">
				<tr>
				<td><xsl:value-of select="position()"/></td>
				<td><a href="/dna/comedysoup/ArticleSearchPhrase?contenttype={/H2G2/ARTICLEHOT-PHRASES/@ASSETCONTENTTYPE}&amp;phrase={NAME}"><xsl:value-of select="NAME"/></a></td>
				<td><xsl:value-of select="TERM"/></td>
				<td><xsl:value-of select="RANK"/></td>
				</tr>
				</xsl:for-each>
				</table>
			</div>
	</xsl:if>
</xsl:template>

<!-- ARTICLESEARCHPHRASE
used on: articlesearchphrase.xsl -->
<xsl:template match="/H2G2/ARTICLESEARCHPHRASE" mode="debug">
	<xsl:if test="$DEBUG = 1 or /H2G2/PARAMS/PARAM[NAME = 's_debug']/VALUE = '1'">
		<div class="debug">
			/H2G2/ARTICLESEARCHPHRASE<br />
			PHRASES/@COUNT = <xsl:value-of select="PHRASES/@COUNT"/>
			<xsl:if test="PHRASES/@COUNT">
				<ul>
				<xsl:for-each select="PHRASES/PHRASE">
				<li><xsl:value-of select="TERM"/></li>
				</xsl:for-each>
				</ul>
			</xsl:if>
			
			<br />
			ARTICLESEARCH/ARTICLE
			<table cellpadding="1" cellspacing="0" border="1" style="font-size:100%;">
			<tr>
			<th>no.</th>
			<th>subject</th>
			<th>type</th>
			<th>description</th>
			<th>by</th>
			<th width="300">date&nbsp;created</th>
			<th>date&nbsp;modified</th>
			<th>ma.id</th>
			<th>ma.contenttype</th>
			<th>mimetype</th>
			<th>ma.hidden</th>
			<th>preview</th>
			<th>phrases</th>
			<th>poll.av</th>
			<th>poll.count</th>
			</tr>
			<xsl:for-each select="ARTICLESEARCH/ARTICLE">
			<tr>
			<td><xsl:value-of select="position()"/></td>
			<td><a href="A{@H2G2ID}"><xsl:value-of select="SUBJECT"/></a></td>
			<td><xsl:value-of select="EXTRAINFO/TYPE/@ID"/></td>
			<td><xsl:value-of select="EXTRAINFO/AUTODESCRIPTION"/></td>
			<td><a href="A{EDITOR/USER/USERID}"><xsl:value-of select="EDITOR/USER/USERNAME"/></a></td>
			<td><xsl:value-of select="DATECREATED/DATE/@SORT"/></td>
			<td><xsl:value-of select="LASTUPDATED/DATE/@SORT"/></td>
			<td><a href="MediaAsset?id={MEDIAASSET/@MEDIAASSETID}"><xsl:value-of select="MEDIAASSET/@MEDIAASSETID"/></a></td>
			<td><xsl:value-of select="MEDIAASSET/@CONTENTTYPE"/> (<xsl:choose>
					<xsl:when test="MEDIAASSET/@CONTENTTYPE=1">
					image
					</xsl:when>
					<xsl:when test="MEDIAASSET/@CONTENTTYPE=2">
					audio
					</xsl:when>
					<xsl:when test="MEDIAASSET/@CONTENTTYPE=3">
					video
					</xsl:when>
				</xsl:choose>)</td>
			<td><xsl:value-of select="MEDIAASSET/MIMETYPE"/></td>
			<td><xsl:value-of select="MEDIAASSET/HIDDEN"/><xsl:text></xsl:text>
				<xsl:choose>
					<xsl:when test="MEDIAASSET/HIDDEN=1">
					Failed
					</xsl:when>
					<xsl:when test="MEDIAASSET/HIDDEN=2">
					Refered
					</xsl:when>
					<xsl:when test="MEDIAASSET/HIDDEN=3">
					In moderation
					</xsl:when>
					<xsl:otherwise>
					Passed
					</xsl:otherwise>
				</xsl:choose></td>
			<td>
			<xsl:choose>
				<xsl:when test="MEDIAASSET/@CONTENTTYPE=1">
				<xsl:variable name="fileextension">
					<xsl:choose>
						<xsl:when test="MEDIAASSET/MIMETYPE='image/gif'">.gif</xsl:when>
						<xsl:otherwise>.jpg</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="moderated">
				<xsl:if test="MEDIAASSET/HIDDEN">.mod</xsl:if>
				</xsl:variable>
					<img src="{$downloadsurl}{MEDIAASSET/FTPPATH}{MEDIAASSET/@MEDIAASSETID}_thumb{$fileextension}{$moderated}"/>
				</xsl:when>
				<xsl:when test="MEDIAASSET/@CONTENTTYPE=2">
				AUDIO_PLACEHOLDER
				</xsl:when>
				<xsl:when test="MEDIAASSET/@CONTENTTYPE=3">
				VIDEO_PLACEHOLDER
				</xsl:when>
			</xsl:choose>
			</td>
			<td><xsl:value-of select="POLL/STATISTICS/@AVERAGERATING"/><br /></td>
			<td><xsl:value-of select="POLL/STATISTICS/@VOTECOUNT"/><br /></td>
			<td><xsl:value-of select="PHRASES/@COUNT"/>
				<xsl:for-each select="PHRASES/PHRASE"><xsl:text> </xsl:text><a href="ArticleSearchPhrase?contenttype={../../MEDIAASSET/@CONTENTTYPE}&amp;phrase={NAME}"><xsl:value-of select="NAME"/></a> <xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>
			</td>
			</tr>
			</xsl:for-each>
			</table>
		</div>		
	</xsl:if>
</xsl:template>

<!-- DYNAMIC LISTS
used on multiple pages:  
	articlepage.xsl -->
<xsl:template match="/H2G2/DYNAMIC-LISTS" mode="debug">
	<div class="debug">
		<h2>/H2G2/DYNAMIC-LISTS</h2>
		number of lists: <xsl:value-of select="count(LIST)"/><br />
		
		<xsl:for-each select="LIST">
			<div style="border:1px solid #999;padding:10px;margin:10px 0;"><strong>LIST  <xsl:value-of select="position()"/></strong><br />
				@LISTID: <xsl:value-of select="@LISTID"/><br />
				@LISTNAME: <xsl:value-of select="@LISTNAME"/><br />
				@LISTTYPE: <xsl:value-of select="@LISTTYPE"/><br />
				
				<xsl:choose>
					<xsl:when test="@LISTTYPE = 'ARTICLES'">
						<table cellpadding="1" cellspacing="0" border="1" style="font-size:100%;">
						<tr>
						<th>ITEM/@ITEMID</th>
						<th>article subject</th>
						<th>status</th>
						<th>author</th>
						<th>average rating</th>
						<th>vote count</th>
						</tr>
						<xsl:for-each select="ITEM-LIST/ITEM">
						<tr>
						<td><xsl:value-of select="@ITEMID"/></td>
						<td><a href="A{ARTICLE-ITEM/@H2G2ID}"><xsl:value-of select="ARTICLE-ITEM/SUBJECT"/></a></td>
						<td><xsl:value-of select="ARTICLE-ITEM/@ARTICLESTATUS"/></td>
						<td><a href="{ARTICLE-ITEM/AUTHOR/USER/USERID}"><xsl:value-of select="ARTICLE-ITEM/AUTHOR/USER/USERNAME"/></a></td>
						<td><xsl:value-of select="POLL-LIST/POLL/STATISTICS/@AVERAGERATING"/></td>
						<td><xsl:value-of select="POLL-LIST/POLL/STATISTICS/@VOTECOUNT"/></td>
						</tr>
						</xsl:for-each>		
						</table>
					</xsl:when>
					<xsl:when test="@LISTTYPE = 'TOPICFORUMS'">
						<table cellpadding="1" cellspacing="0" border="1" style="font-size:100%;">
						<tr>
						<th>ITEM/@ITEMID</th>
						<th>topic subject</th>
						<th>topicid</th>
						<th>forumpostcount</th>
						<th>forumid</th>
						</tr>
						<xsl:for-each select="ITEM-LIST/ITEM">
						<tr>
						<td><xsl:value-of select="@ITEMID"/></td>
						<td><xsl:value-of select="TOPIC-ITEM/SUBJECT"/></td>
						<td><xsl:value-of select="TOPIC-ITEM/@TOPICID"/></td>
						<td><xsl:value-of select="TOPIC-ITEM/@FORUMPOSTCOUNT"/></td>
						<td><xsl:value-of select="TOPIC-ITEM/@FORUMID"/></td>
						</tr>
						</xsl:for-each>		
						</table>
					</xsl:when>
					<xsl:otherwise>
						<table cellpadding="1" cellspacing="0" border="1" style="font-size:100%;">
						<tr>
						<th>ITEM/@ITEMID</th>
						<th>title</th>
						</tr>
						<xsl:for-each select="ITEM-LIST/ITEM">
						<tr>
						<td><xsl:value-of select="@ITEMID"/></td>
						<td><xsl:value-of select="TITLE"/></td>
						</tr>
						</xsl:for-each>		
						</table>
					</xsl:otherwise>
				</xsl:choose>
			</div>
		</xsl:for-each>
	</div>
</xsl:template>


<!-- ERROR -->
<xsl:template match="/H2G2/ERROR" mode="debug">
	<div class="debug">
		<h2 style="color:red;">/H2G2/ERROR</h2>
		<textarea style="width:400px" rows="6"><xsl:copy-of select="." /></textarea>
	</div>
</xsl:template>

<!-- HOT-PHRASES
for frontpage.xsl and maspage.xsl -->
<xsl:template match="/H2G2/HOT-PHRASES" mode="debug">
		<div class="debug">
				/H2G2/HOT-PHRASES<br />
				@ASSETCONTENTTYPE: <xsl:value-of select="@ASSETCONTENTTYPE"/><br />
				@SKIP: <xsl:value-of select="@SKIP"/><br />
				@SHOW: <xsl:value-of select="@SHOW"/><br />
				@COUNT: <xsl:value-of select="@COUNT"/><br />
				@MORE: <xsl:value-of select="@MORE"/><br />
				<br />
				HOT-PHRASE
				<table cellpadding="0" cellspacing="0" border="1" style="font-size:100%;">
				<tr>
				<th>position</th>
				<th>name</th>
				<th>term</th>
				<th>rank</th>
				</tr>
				<xsl:for-each select="HOT-PHRASE">
				<tr>
				<td><xsl:value-of select="position()"/></td>
				
				<td><a href="/dna/soup/MediaAssetSearchPhrase?contenttype={/H2G2/HOT-PHRASES/@ASSETCONTENTTYPE}&amp;phrase={NAME}"><xsl:value-of select="NAME"/></a></td>
				
				<td><xsl:value-of select="TERM"/></td>
				<td><xsl:value-of select="RANK"/></td>
				</tr>
				</xsl:for-each>
				</table>
		</div>
</xsl:template>

<!-- /H2G2/MEDIAASSETBUILDER/MEDIAASSETINFO[ACTION='showusersassets']
used on:  mediaassetpage.xsl -->
<xsl:template match="MEDIAASSETBUILDER/MEDIAASSETINFO[ACTION='showusersassets']" mode="debug">
	<xsl:variable name="assetroot">/dna/actionnetwork/icandev/</xsl:variable>
	<xsl:variable name="mediaassethome">MediaAsset</xsl:variable>
	<xsl:variable name="imagesourcepath">http://downloads.bbc.co.uk/dnauploads/</xsl:variable>
	<xsl:variable name="userid"><xsl:value-of select="USERSID"/></xsl:variable>
	
<div class="debug">
	<h2>/H2G2/MEDIAASSETBUILDER/ARTICLEMEDIAASSETINFO[ACTION='showusersassets']</h2>
	
	<a href="{$root}UMA{$userid}">
		All Media Assets
	</a>
	<br/>	
	<a href="{$root}UMA{$userid}?ContentType=1">
		All Image Assets
	</a>
	<br/>	
	<a href="{$root}UMA{$userid}?ContentType=2">
		All Audio Assets
	</a>
	<br/>	
	<a href="{$root}UMA{$userid}?ContentType=3">
		All Video Assets
	</a>
	<br/>	
	<br/>	
	<xsl:choose>
		<xsl:when test="@SKIPTO != 0">
			<a href="{$root}UMA{$userid}?skip=0&amp;show={@COUNT}">
				
					[ <xsl:value-of select="$m_newest"/> ]
			</a>
			<xsl:variable name="alt">[ <xsl:value-of select='number(@SKIPTO) - number(@COUNT) + 1'/>-<xsl:value-of select='number(@SKIPTO)'/> ]</xsl:variable>
			<a href="{$root}UMA{$userid}?skip={number(@SKIPTO) - number(@COUNT)}&amp;show={@COUNT}">
					<xsl:value-of select="$alt"/> 
			</a>
		</xsl:when>
		<xsl:otherwise>
			[ <xsl:value-of select="$m_newest"/> ]
			[ <xsl:value-of select="$m_newer"/> ]
		</xsl:otherwise>
	</xsl:choose>
	<xsl:choose>
		<xsl:when test="@MORE">
			<xsl:variable name="alt">[ <xsl:value-of select='number(@SKIPTO) + number(@COUNT) + 1'/>-<xsl:value-of select='number(@SKIPTO) + number(@COUNT) + number(@COUNT)'/> ]</xsl:variable>
			<a href="{$root}UMA{$userid}?skip={number(@SKIPTO) + number(@COUNT)}&amp;show={@COUNT}">
				<xsl:value-of select="$alt"/>
			</a>
			<a href="{$root}UMA{$userid}?skip={floor((number(@TOTAL)-1) div number(@COUNT)) * number(@COUNT)}&amp;show={@COUNT}">
					[ <xsl:value-of select="$m_oldest"/> ]
			</a>
		</xsl:when>
		<xsl:otherwise>
			[ <xsl:value-of select="$m_older"/> ]
			[ <xsl:value-of select="$m_oldest"/> ]
		</xsl:otherwise>
	</xsl:choose>
	<br/>	
	<br/>	
	<TABLE width="100%" cellpadding="2" cellspacing="0" border="1">
		<xsl:for-each select="MEDIAASSET">
			<xsl:variable name="mediaassetimagepath">
				<xsl:value-of select="@MEDIAASSETID"/>				
				<xsl:choose>
					<xsl:when test="MIMETYPE='image/jpeg' or MIMETYPE='image/pjpeg'">
						_thumb.jpg
					</xsl:when>
					<xsl:when test="MIMETYPE='image/gif'">
						_thumb.gif
					</xsl:when>
					<xsl:when test="MIMETYPE='video/movie'">
						.mov
					</xsl:when>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="ftppath">
				<xsl:value-of select="FTPPATH"/>
			</xsl:variable>
			<TR> 
				<TD colspan="2" align="center">
					
					<xsl:choose>
						<xsl:when test="HIDDEN">
							<strong>Image Awaiting Moderation</strong>						
						</xsl:when>
						<xsl:otherwise>
							<img src="{$assetlibrary}{$ftppath}{$mediaassetimagepath}"/>
						</xsl:otherwise>
					</xsl:choose>
				</TD>
				<TD colspan="2" align="center">
					<xsl:element name="A">
						<xsl:attribute name="HREF"><xsl:value-of select="$assetroot"/><xsl:value-of select="$mediaassethome" />?id=<xsl:value-of select="@MEDIAASSETID"/>&amp;action=view
						<xsl:if test="/H2G2/MEDIAASSETSEARCHPHRASE/PHRASES/@PARAM">&amp;phrase=<xsl:value-of select="/H2G2/MEDIAASSETSEARCHPHRASE/PHRASES/@PARAM"/></xsl:if>
						</xsl:attribute>
						<!-- Display link text -->
						<B><xsl:apply-templates mode="nosubject" select="CAPTION"/></B>
					</xsl:element>
				</TD>
				<TD colspan="2" align="left"><span class="lastposting">
					<xsl:choose>
						<xsl:when test="CONTENTTYPE='1'">
						Image
						</xsl:when>
						<xsl:when test="CONTENTTYPE='2'">
						Audio
						</xsl:when>
						<xsl:when test="CONTENTTYPE='3'">
						Video
						</xsl:when>
					</xsl:choose></span>
				</TD>
				<TD colspan="2" align="left"><span class="lastposting">
					<xsl:apply-templates select="PHRASES/PHRASE"/></span>
				</TD>
				<TD colspan="2" align="left"><span class="lastposting">
					by <xsl:value-of select="OWNER/USER/USERNAME"/></span>
				</TD>
				<TD colspan="2" align="left"><span class="lastposting">			
				<xsl:choose>
					<xsl:when test="HIDDEN=1">
					Failed
					</xsl:when>
					<xsl:when test="HIDDEN=2">
					Refered
					</xsl:when>
					<xsl:when test="HIDDEN=3">
					In moderation
					</xsl:when>
					<xsl:otherwise>
					Passed
					</xsl:otherwise>
				</xsl:choose></span>
				</TD>
			</TR>
		</xsl:for-each>
	</TABLE>
	</div>
</xsl:template>


<!-- /H2G2/MEDIAASSETBUILDER/ARTICLEMEDIAASSETINFO
used on:  mediaassetpage.xsl -->
<xsl:template match="/H2G2/MEDIAASSETBUILDER/ARTICLEMEDIAASSETINFO" mode="debug">
	<div class="debug">
		/H2G2/MEDIAASSETBUILDER/ARTICLEMEDIAASSETINFO<br />
		@CONTENTTYPE = <xsl:value-of select="/H2G2/MEDIAASSETBUILDER/ARTICLEMEDIAASSETINFO/@CONTENTTYPE" /><br />
		@SKIPTO = <xsl:value-of select="/H2G2/MEDIAASSETBUILDER/ARTICLEMEDIAASSETINFO/@SKIPTO" /><br />
		@SHOW = <xsl:value-of select="/H2G2/MEDIAASSETBUILDER/ARTICLEMEDIAASSETINFO/@SHOW" /><br />
		@COUNT = <xsl:value-of select="/H2G2/MEDIAASSETBUILDER/ARTICLEMEDIAASSETINFO/@COUNT" /><br />
		@TOTAL = <xsl:value-of select="/H2G2/MEDIAASSETBUILDER/ARTICLEMEDIAASSETINFO/@TOTAL" /><br />
		@MORE = <xsl:value-of select="/H2G2/MEDIAASSETBUILDER/ARTICLEMEDIAASSETINFO/@MORE" /><br />
		<br />
		ACTION = <xsl:value-of select="/H2G2/MEDIAASSETBUILDER/ARTICLEMEDIAASSETINFO/ACTION" /><br />
		USERSID = <xsl:value-of select="/H2G2/MEDIAASSETBUILDER/ARTICLEMEDIAASSETINFO/USERSID" /><br />
		<br />
		ARTICLE
		<table cellpadding="1" cellspacing="0" border="1" style="font-size:100%;">
		<tr>
		<th>no.</th>
		<th>subject</th>
		<th>type</th>
		<th>description</th>
		<th>duration</th>
		<th>by</th>
		<th width="300">date&nbsp;created</th>
		<th>date&nbsp;modified</th>
		<th>ma.id</th>
		<th>ma.contenttype</th>
		<th>mimetype</th>
		<th>ma.hidden</th>
		<th>ma.siteid</th>
		<th>preview</th>
		<th>phrases</th>
		<th>ma.siteid</th>
		<th>extrainfo</th>
		</tr>
		<xsl:for-each select="ARTICLE">
		<tr>
		<td><xsl:value-of select="position()"/></td>
		<td><a href="A{@H2G2ID}"><xsl:value-of select="SUBJECT"/></a><br /></td>
		<td><xsl:value-of select="EXTRAINFO/TYPE/@ID"/><br /></td>
		<td><xsl:value-of select="EXTRAINFO/AUTODESCRIPTION"/><br /></td>
		<td><xsl:value-of select="EXTRAINFO/DURATION_MINS"/>:<xsl:value-of select="EXTRAINFO/DURATION_SECS"/><br /></td>
		<td><a href="A{EDITOR/USER/USERID}"><xsl:value-of select="EDITOR/USER/USERNAME"/></a><br /></td>
		<td><xsl:value-of select="DATECREATED/DATE/@SORT"/><br /></td>
		<td><xsl:value-of select="LASTUPDATED/DATE/@SORT"/><br /></td>
		<td><a href="MediaAsset?id={MEDIAASSET/@MEDIAASSETID}"><xsl:value-of select="MEDIAASSET/@MEDIAASSETID"/></a><br /></td>
		<td><xsl:value-of select="MEDIAASSET/CONTENTTYPE"/> (<xsl:choose>
				<xsl:when test="MEDIAASSET/CONTENTTYPE=1">
				image
				</xsl:when>
				<xsl:when test="MEDIAASSET/CONTENTTYPE=2">
				audio
				</xsl:when>
				<xsl:when test="MEDIAASSET/CONTENTTYPE=3">
				video
				</xsl:when>
			</xsl:choose>)<br /></td>
		<td><xsl:value-of select="MEDIAASSET/MIMETYPE"/><br /></td>
		<td><xsl:value-of select="MEDIAASSET/HIDDEN"/><xsl:text> </xsl:text><xsl:choose>
				<xsl:when test="MEDIAASSET/HIDDEN=2">
				Refered
				</xsl:when>
				<xsl:when test="MEDIAASSET/HIDDEN=3">
				In moderation
				</xsl:when>
				<xsl:otherwise>
				Passed
				</xsl:otherwise>
			</xsl:choose><br /></td>
		<td><xsl:value-of select="MEDIAASSET/SITEID"/></td>
		<td>
		<xsl:choose>
			<xsl:when test="MEDIAASSET/CONTENTTYPE=1">
			<xsl:variable name="fileextension">
				<xsl:choose>
					<xsl:when test="MEDIAASSET/MIMETYPE='image/gif'">.gif</xsl:when>
					<xsl:otherwise>.jpg</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="moderated">
			<xsl:if test="MEDIAASSET/HIDDEN">.mod</xsl:if>
			</xsl:variable>
				<img src="{$downloadsurl}{MEDIAASSET/FTPPATH}{MEDIAASSET/@MEDIAASSETID}_thumb{$fileextension}{$moderated}"/>
			</xsl:when>
			<xsl:when test="MEDIAASSET/CONTENTTYPE=2">
			AUDIO_PLACEHOLDER
			</xsl:when>
			<xsl:when test="MEDIAASSET/CONTENTTYPE=3">
			VIDEO_PLACEHOLDER
			</xsl:when>
		</xsl:choose><br />
		</td>
		<td><xsl:value-of select="MEDIAASSET/PHRASES/@COUNT"/>
			<xsl:for-each select="MEDIAASSET/PHRASES/PHRASE"><xsl:text> </xsl:text><a href="ArticleSearchPhrase?&amp;phrase={NAME}"><xsl:value-of select="NAME"/></a> <xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>
			<br /></td>
		<td><xsl:value-of select="MEDIAASSET/SITEID"/><br /></td>
		<td>
			<table cellpadding="2" cellspacing="0" border="1" style="font-size:100%;">
			<xsl:for-each select="EXTRAINFO/node()">
			<tr>
				<xsl:choose>
					<xsl:when test="local-name(.)='TYPE'">
					<th valign="top" align="left">TYPE/@ID</th>
					<td><xsl:value-of select="./@ID"/></td>
					</xsl:when>
					<xsl:otherwise>
					<th valign="top" align="left"><xsl:value-of select="local-name(.)" /></th>
					<td><xsl:copy-of select="node()" /><br /></td>
					</xsl:otherwise>
				</xsl:choose>
			</tr>
			</xsl:for-each>
			</table>
		</td>
		</tr>
		</xsl:for-each>
		</table>
	</div>		
</xsl:template>

<!-- 
MEDIAASSETBUILDER/MEDIAASSETINFO
used on mediaassetpage.xsl

MEDIAASSETINFO
used on articlepage.xsl
-->
<xsl:template match="MEDIAASSETINFO" mode="debug">
	<div class="debug">
		<xsl:choose>
			<xsl:when test="parent::MEDIAASSETBUILDER">
			<h2>/H2G2/MEDIAASSETBUILDER/MEDIAASSETINFO</h2>
			</xsl:when>
			<xsl:when test="parent::H2G2">
			<h2>/H2G2/MEDIAASSETINFO</h2>
			</xsl:when>
		</xsl:choose>
		ACTION: <xsl:value-of select="ACTION"/><br />
		ID: <xsl:value-of select="ID"/><br />
		
		
		<xsl:for-each select="MEDIAASSET">
		<br />
		MEDIAASSET<br />
			<table style="font-size:100%;" border="1" cellspacing="0">
			<tr>
			<td><b>Asset ID:</b></td><td><xsl:value-of select="@MEDIAASSETID"/></td>
			</tr>
			<tr>
			<td><b>Site ID:</b></td><td><xsl:value-of select="SITEID"/></td>
			</tr>
			<tr>
			<td><b>Caption:</b></td><td><xsl:value-of select="CAPTION"/></td>
			</tr>
			<tr>
			<td><b>Filename:</b></td><td><xsl:value-of select="FILENAME"/></td>
			</tr>
			<tr>
			<td><b>MimeType:</b></td><td><xsl:value-of select="MIMETYPE"/></td>
			</tr>
			<tr>
			<td><b>Content Type:</b></td><td><xsl:value-of select="CONTENTTYPE"/></td>
			</tr>				
			<tr>
			<td><b>Description:</b></td><td><xsl:value-of select="MEDIAASSETDESCRIPTION"/></td>
			</tr>
			<tr>
			<td valign="top"><b>Key phrases:</b></td><td><xsl:value-of select="PHRASES/@COUNT"/>
				<ul>
					<xsl:for-each select="PHRASES/PHRASE">
					<li><a href="ArticleSearchPhrase?contenttype={../../CONTENTTYPE}&amp;phrase={NAME}"><xsl:value-of select="NAME"/></a></li>
					</xsl:for-each>
				</ul></td>
			</tr>				
			<tr>
			<td><b>Owner:</b></td><td><a href="{OWNER/USER/USERID}"><xsl:value-of select="OWNER/USER/USERNAME"/></a></td>
			</tr>
			<tr>
			<td><b>Date Created:</b></td><td><xsl:value-of select="DATECREATED/DATE/@DAY"/> <xsl:value-of select="DATECREATED/DATE/@MONTHNAME"/> <xsl:value-of select="DATECREATED/DATE/@YEAR"/> <xsl:value-of select="DATECREATED/DATE/@HOURS"/>:<xsl:value-of select="DATECREATED/DATE/@MINUTES"/>:<xsl:value-of select="DATECREATED/DATE/@SECONDS"/></td>
			</tr>
			<tr>
			<td><b>Last Updated:</b></td><td><xsl:value-of select="LASTUPDATED/DATE/@DAY"/> <xsl:value-of select="LASTUPDATED/DATE/@MONTHNAME"/> <xsl:value-of select="LASTUPDATED/DATE/@YEAR"/> <xsl:value-of select="LASTUPDATED/DATE/@HOURS"/>:<xsl:value-of select="LASTUPDATED/DATE/@MINUTES"/>:<xsl:value-of select="LASTUPDATED/DATE/@SECONDS"/></td>
			</tr>
			<tr>
				<td><b>Moderation Status:</b></td>
				<td>
					<xsl:value-of select="HIDDEN"/> (
					<xsl:choose>
				<xsl:when test="HIDDEN=1">
				Failed
				</xsl:when>
				<xsl:when test="HIDDEN=2">
				Refered
				</xsl:when>
				<xsl:when test="HIDDEN=3">
				In moderation
				</xsl:when>
				<xsl:otherwise>
				Passed
				</xsl:otherwise>
			</xsl:choose>)
				</td>
			</tr>
			<tr>
			<td valign="top"><b>EXTRAELEMENTXML<xsl:if test="EXTRAELEMENTXML/EXTRAELEMENTXML">/EXTRAELEMENTXML</xsl:if></b>&nbsp;</td>
			<td>
				<table cellpadding="2" cellspacing="0" border="1" style="font-size:100%;">
					<xsl:for-each select="EXTRAELEMENTXML/EXTRAELEMENTXML/node()">
						<tr>
						<th valign="top" align="left"><xsl:value-of select="local-name(.)" /></th>
						<td>
						<span class="text"><xsl:value-of select="text()"/></span>
						</td>
						</tr>
					</xsl:for-each>
					</table>
			</td>
			</tr>
			</table>
		
			<xsl:choose>
				<xsl:when test="CONTENTTYPE=1">
					<xsl:variable name="fileextension">
						<xsl:choose>
							<xsl:when test="MIMETYPE='image/gif'">.gif</xsl:when>
							<xsl:otherwise>.jpg</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<xsl:if test="HIDDEN">
					<strong>image has not passed moderation</strong><br />
					<xsl:value-of select="$downloadsurl"/><xsl:value-of select="FTPPATH"/><xsl:value-of select="@MEDIAASSETID"/>_thumb<xsl:value-of select="$fileextension"/><strong>.mod</strong><br />
					<img src="{$downloadsurl}{FTPPATH}{@MEDIAASSETID}_thumb{$fileextension}.mod"/>
					</xsl:if>
					<dl>
					<dt><xsl:value-of select="$downloadsurl"/><xsl:value-of select="FTPPATH"/><xsl:value-of select="@MEDIAASSETID"/>_thumb<xsl:value-of select="$fileextension"/></dt>
					<dd><img src="{$downloadsurl}{FTPPATH}{@MEDIAASSETID}_thumb{$fileextension}"/></dd>
					
					<dt><xsl:value-of select="$downloadsurl"/><xsl:value-of select="FTPPATH"/><xsl:value-of select="@MEDIAASSETID"/>_preview<xsl:value-of select="$fileextension"/></dt>
					<dd><img src="{$downloadsurl}{FTPPATH}{@MEDIAASSETID}_preview{$fileextension}"/></dd>
	
					<dt><xsl:value-of select="$downloadsurl"/><xsl:value-of select="FTPPATH"/><xsl:value-of select="@MEDIAASSETID"/>_article<xsl:value-of select="$fileextension"/></dt>
					<dd><img src="{$downloadsurl}{FTPPATH}{@MEDIAASSETID}_article{$fileextension}"/></dd>
					
					<dt><xsl:value-of select="$downloadsurl"/><xsl:value-of select="FTPPATH"/><xsl:value-of select="@MEDIAASSETID"/>_raw<xsl:value-of select="$fileextension"/></dt>
					<dd><img src="{$downloadsurl}{FTPPATH}{@MEDIAASSETID}_raw{$fileextension}"/></dd>
					</dl>
				</xsl:when>
				<xsl:when test="CONTENTTYPE=2">
				AUDIO_PLACEHOLDER
				</xsl:when>
				<xsl:when test="CONTENTTYPE=3">
				VIDEO_PLACEHOLDER
				</xsl:when>
			</xsl:choose>
			
		</xsl:for-each>
		</div>	
</xsl:template>

<!-- MEDIAASSETSEARCHPHRASE
used on:	maspage.xsl	-->
<xsl:template match="/H2G2/MEDIAASSETSEARCHPHRASE" mode="debug">
	<div class="debug">
		/H2G2/MEDIAASSETSEARCHPHRASE<br />
		
		ASSETSEARCH/@CONTENTTYPE = <xsl:value-of select="ASSETSEARCH/@CONTENTTYPE"/><br />
		ASSETSEARCH/@SKIPTO = <xsl:value-of select="ASSETSEARCH/@SKIPTO"/><br />
		ASSETSEARCH/@COUNT = <xsl:value-of select="ASSETSEARCH/@COUNT"/><br />
		ASSETSEARCH/@TOTAL = <xsl:value-of select="ASSETSEARCH/@TOTAL"/><br />
		PHRASES/@COUNT = <xsl:value-of select="PHRASES/@COUNT"/>
		<xsl:if test="PHRASES/@COUNT">
			<ul>
			<xsl:for-each select="PHRASES/PHRASE">
			<li><xsl:value-of select="TERM"/></li>
			</xsl:for-each>
			</ul>
		</xsl:if>
		
		<table cellpadding="1" cellspacing="0" border="1" style="font-size:100%;">
		<tr>
		<th>no.</th>
		<th>subject</th>
		<th>owner</th>
		<th>id</th>
		<th>contenttype</th>
		<th>mimetype</th>
		<th>hidden</th>
		<th>preview</th>
		<th>phrases</th>
		</tr>
		<xsl:for-each select="ASSETSEARCH/ASSET">
		<tr>
		<td><xsl:value-of select="position()"/></td>
		<td><a href="MediaAsset?id={@ASSETID}"><xsl:value-of select="SUBJECT"/></a></td>
		<td><a href="A{OWNER/USER/USERID}"><xsl:value-of select="OWNER/USER/USERNAME"/></a></td>
		<td><xsl:value-of select="@ASSETID"/></td>
		<td><xsl:value-of select="@CONTENTTYPE"/> (<xsl:choose>
				<xsl:when test="@CONTENTTYPE=1">
				image
				</xsl:when>
				<xsl:when test="@CONTENTTYPE=2">
				audio
				</xsl:when>
				<xsl:when test="@CONTENTTYPE=3">
				video
				</xsl:when>
			</xsl:choose>)</td>
		<td><xsl:value-of select="MIMETYPE"/></td>
		<td><xsl:value-of select="HIDDEN"/><xsl:text> </xsl:text>
			<xsl:choose>
					<xsl:when test="HIDDEN=1">
					Failed
					</xsl:when>
					<xsl:when test="HIDDEN=2">
					Refered
					</xsl:when>
					<xsl:when test="HIDDEN=3">
					In moderation
					</xsl:when>
					<xsl:otherwise>
					Passed
					</xsl:otherwise>
				</xsl:choose>
			</td>
		<td>
		<xsl:choose>
			<xsl:when test="@CONTENTTYPE=1">
			<xsl:variable name="fileextension">
				<xsl:choose>
					<xsl:when test="MIMETYPE='image/gif'">.gif</xsl:when>
					<xsl:otherwise>.jpg</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="moderated">
			<xsl:if test="HIDDEN">.mod</xsl:if>
			</xsl:variable>
				<img src="{$downloadsurl}{FTPPATH}{@ASSETID}_thumb{$fileextension}{$moderated}"/>
			</xsl:when>
			<xsl:when test="@CONTENTTYPE=2">
			AUDIO_PLACEHOLDER
			</xsl:when>
			<xsl:when test="@CONTENTTYPE=3">
			VIDEO_PLACEHOLDER
			</xsl:when>
		</xsl:choose>
		</td>
		<td><xsl:value-of select="PHRASES/@COUNT"/>
			<xsl:for-each select="PHRASES/PHRASE"><xsl:text> </xsl:text><a href="MediaAssetSearchPhrase?phrase={NAME}"><xsl:value-of select="NAME"/></a> <xsl:if test="position()!=last()">,</xsl:if></xsl:for-each>
			</td>
		</tr>
		</xsl:for-each>
		</table>
	</div>
</xsl:template>

<!-- MULTI-STAGE
used on:
	typedarticlepage.xsl
	siteconfigpage.xsl 
	mediaassetpage.xsl -->
<xsl:template match="MULTI-STAGE" mode="debug">
	<div class="debug">
	
	<xsl:choose>
		<xsl:when test="parent::SITECONFIG-EDIT">
			<h2>/H2G2/SITECONFIG-EDIT/MULTI-STAGE</h2>
		</xsl:when>
		<xsl:when test="parent::MEDIAASSETINFO">
			<h2>/H2G2/MEDIAASSETBUILDER/MEDIAASSETINFO/MULTI-STAGE</h2>
		</xsl:when>
		<xsl:when test="parent::H2G2">
			<h2>/H2G2/MULTI-STAGE</h2>
		</xsl:when>
		<xsl:otherwise>
			<h2>/H2G2/??????/MULTI-STAGE</h2>
		</xsl:otherwise>
	</xsl:choose>
			
	@TYPE: <xsl:value-of select="@TYPE"/><br />
	@STAGE: <xsl:value-of select="@STAGE"/><br />
	@FINISH: <xsl:value-of select="@FINISH"/><br />
	<br />
	URLNAME: <xsl:value-of select="URLNAME"/><br />
	<br />
	MULTI-REQUIRED<br />
	<table cellpadding="1" cellspacing="0" border="1" style="font-size:100%;">
		<tr>
			<th>@NAME</th>
			<th>VALUE</th>
			<th>VALUE-EDITABLE</th>
			<th>error</th>
		</tr>
		<xsl:for-each select="MULTI-REQUIRED">
		<tr>
			<td><xsl:value-of select="@NAME"/></td>
			<td><xsl:value-of select="VALUE"/><br /></td>
			<td><xsl:value-of select="VALUE-EDITABLE"/><br /></td>
			<td><xsl:value-of select="ERRORS/ERROR/@TYPE"/><br /></td>
			</tr>
		</xsl:for-each>		
		</table>
		
		<br />
	MULTI-ELEMENT<br />
	<table cellpadding="1" cellspacing="0" border="1" style="font-size:100%;">
		<tr>
			<th valign="top">NAME</th>
			<th valign="top">VALUE</th>
			<th valign="top">VALUE-EDITABLE</th>
			<th valign="top">error</th>
		</tr>
		<xsl:for-each select="MULTI-ELEMENT">
		<tr>
			<td valign="top"><xsl:value-of select="@NAME"/></td>
			<td valign="top"><xsl:value-of select="VALUE"/><br /></td>
			<td valign="top"><xsl:value-of select="VALUE-EDITABLE"/><br /></td>
			<td valign="top"><xsl:value-of select="ERRORS/ERROR/@TYPE"/><br /></td>
			</tr>
		</xsl:for-each>		
		</table>
	</div>
</xsl:template>




<!-- PAGE-OWNER
used on all -->
<xsl:template match="/H2G2/PAGE-OWNER" mode="debug">
	<div class="debug">
		/H2G2/PAGE-OWNER<br />
		<xsl:call-template name="tablex3"/>
	</div>
</xsl:template>

<!-- PARAMS
used on all -->
<xsl:template match="/H2G2/PARAMS" mode="debug">
	<div class="debug">
		/H2G2/PARAMS<br />
		<xsl:call-template name="tablex3"/>
	</div>
</xsl:template>

<!-- POLL-LIST
used on: articlepage.xsl -->
<xsl:template match="/H2G2/POLL-LIST" mode="debug">
	<div class="debug">
		<h2>/H2G2/POLL-LIST</h2>
		number of polls: <xsl:value-of select="count(POLL)"/><br />
		
		
		<xsl:if test="count(POLL) > 0">
		<xsl:choose>
			<xsl:when test="/H2G2/VIEWING-USER/USER/USERID = /H2G2/ARTICLE/ARTICLEINFO/PAGEAUTHOR/EDITOR/USER/USERID">
				You cannot vote - this page is yours
			</xsl:when>
			<xsl:otherwise>
				You can vote - the page owner is <a href="U{/H2G2/ARTICLE/ARTICLEINFO/PAGEAUTHOR/EDITOR/USER/USERID}"><xsl:value-of select="/H2G2/ARTICLE/ARTICLEINFO/PAGEAUTHOR/EDITOR/USER/USERNAME"/></a>
			</xsl:otherwise>
		</xsl:choose>
		</xsl:if>
		
		<xsl:for-each select="POLL">
			<div style="border:1px solid #999;padding:10px;margin:10px 0;"><strong>POLL  <xsl:value-of select="position()"/></strong><br />
				@POLLID: <xsl:value-of select="@POLLID"/><br />
				@POLLTYPE: <xsl:value-of select="@POLLTYPE"/><br />
				@HIDDEN: <xsl:value-of select="@HIDDEN"/><br />
				OPTION-LIST/USERSTATUS/TYPE: <xsl:value-of select="OPTION-LIST/USERSTATUS/TYPE"/>
				
				<table cellpadding="1" cellspacing="0" border="1" style="font-size:100%;">
				<tr>
				<th>result</th>
				<th>count</th>
				<th>percent</th>
				</tr>
				<xsl:for-each select="OPTION-LIST/USERSTATUS/OPTION">
				<tr>
				<td><xsl:value-of select="@INDEX"/></td>
				<td><xsl:value-of select="@COUNT"/></td>
				<td>
				<xsl:choose>
					<xsl:when test="position()=1">
						<xsl:value-of select="$option1percent"/>	
					</xsl:when>
					<xsl:when test="position()=2">
						<xsl:value-of select="$option1percent"/>	
					</xsl:when>
					<xsl:when test="position()=3">
						<xsl:value-of select="$option1percent"/>	
					</xsl:when>
					<xsl:when test="position()=4">
						<xsl:value-of select="$option1percent"/>	
					</xsl:when>
					<xsl:when test="position()=5">
						<xsl:value-of select="$option1percent"/>	
					</xsl:when>
				</xsl:choose>
				%</td>
				</tr>
				</xsl:for-each>		
				</table>
				number of votes: <xsl:value-of select="$votes_cast"/><br />
				average vote: <xsl:value-of select="$poll_average_score"/> / 5<br />
				your vote: <xsl:value-of select="USER-VOTE/@CHOICE"/>
			</div>
		</xsl:for-each>
	</div>		
</xsl:template>

<!-- RECENT-APPROVALS
used on: userpage.xsl -->
<xsl:template match="/H2G2/RECENT-APPROVALS" mode="debug">	
	<div class="debug">
		<h2>/H2G2/RECENT-APPROVALS</h2>
		number of articles: <xsl:value-of select="count(/H2G2/RECENT-APPROVALS/ARTICLE-LIST/ARTICLE)" /><br />
		count:<xsl:value-of select="/H2G2/RECENT-APPROVALS/ARTICLE-LIST/@COUNT" /><br />
		skipto:<xsl:value-of select="/H2G2/RECENT-APPROVALS/ARTICLE-LIST/@SKIPTO" /><br />
		<br />
		ARTICLE-LIST/ARTICLE
		<table cellpadding="0" cellspacing="0" border="1" style="font-size:100%;">
			<tr>
			<th>no.</th>
			<th>article title</th>
			<th>type</th>
			<th>status</th>
			<th>site</th>
			</tr>
			<xsl:for-each select="/H2G2/RECENT-APPROVALS/ARTICLE-LIST/ARTICLE">
			<tr>
			<td><xsl:value-of select="../@SKIPTO + position()"/></td>
			<td><xsl:apply-templates select="SUBJECT" mode="t_userpagearticle"/></td>
			<td><xsl:value-of select="EXTRAINFO/TYPE/@ID" /></td>
			<td><xsl:value-of select="STATUS" /></td>
			<td><xsl:value-of select="SITEID" /></td>
			</tr>
			</xsl:for-each>
		</table>
	</div>
</xsl:template>

<!-- RECENT-ENTRIES 
used on: userpage.xsl -->
<xsl:template match="/H2G2/RECENT-ENTRIES" mode="debug">		
	<div class="debug">
		<h2>/H2G2/RECENT-ENTRIES</h2>
		number of articles: <xsl:value-of select="count(/H2G2/RECENT-ENTRIES/ARTICLE-LIST/ARTICLE)" /><br />
		count:<xsl:value-of select="/H2G2/RECENT-ENTRIES/ARTICLE-LIST/@COUNT" /><br />
		skipto:<xsl:value-of select="/H2G2/RECENT-ENTRIES/ARTICLE-LIST/@SKIPTO" /><br />
		<br />
		ARTICLE-LIST/ARTICLE
		<table cellpadding="0" cellspacing="0" border="1" style="font-size:100%;">
			<tr>
			<th>no.</th>
			<th>article title</th>
			<th>type</th>
			<th>status</th>
			<th>site</th>
			</tr>
			<xsl:for-each select="/H2G2/RECENT-ENTRIES/ARTICLE-LIST/ARTICLE">
			<tr>
			<td><xsl:value-of select="../@SKIPTO + position()"/></td>
			<td><xsl:apply-templates select="SUBJECT" mode="t_userpagearticle"/></td>
			<td><xsl:value-of select="EXTRAINFO/TYPE/@ID" /></td>
			<td><xsl:value-of select="STATUS" /></td>
			<td><xsl:value-of select="SITEID" /></td>
			</tr>
			</xsl:for-each>
		</table>
	</div>
</xsl:template>

<!-- RECENT-POSTS 
used on: userpage.xsl -->
<xsl:template match="/H2G2/RECENT-POSTS" mode="debug">		
	<div class="debug">
		<h2>/H2G2/RECENT-POSTS</h2>
		number of articles: <xsl:value-of select="count(/H2G2/RECENT-POSTS/POST-LIST/POST)" /><br />
		count:<xsl:value-of select="/H2G2/RECENT-POSTS/POST-LIST/@COUNT" /><br />
		skipto:<xsl:value-of select="/H2G2/RECENT-POSTS/POST-LIST/@SKIPTO" /><br />
		<br />
		POST-LIST/POST
		<table cellpadding="0" cellspacing="0" border="1" style="font-size:100%;">
			<tr>
			<th>no.</th>
			<th>forum id</th>
			<th>thread id</th>
			<th>subject</th>
			<th>forum title</th>
			<th>site</th>
			</tr>
			<xsl:for-each select="/H2G2/RECENT-POSTS/POST-LIST/POST">
			<tr>
			<td><xsl:value-of select="../@SKIPTO + position()"/></td>
			<td><xsl:value-of select="THREAD/@THREADID" /></td>
			<td><xsl:value-of select="THREAD/@FORUMID" /></td>
			<td><a href="{$root}F{THREAD/@FORUMID}?thread={THREAD/@THREADID}"><xsl:value-of select="THREAD/SUBJECT" /></a></td>
			<td><a href="{$root}F{THREAD/@FORUMID}"><xsl:value-of select="THREAD/FORUMTITLE" /></a></td>
			<td><xsl:value-of select="SITEID" /></td>
			</tr>
			</xsl:for-each>
		</table>
	</div>
</xsl:template>

<!-- SITECONFIG
used on all pages -->
<xsl:template match="/H2G2/SITECONFIG" mode="debug">
	<div class="debug">
		<h2>/H2G2/SITECONFIG</h2>
		number of items: <xsl:value-of select="count(node())" />
		<ol>
		<xsl:for-each select="node()">
			<li><xsl:value-of select="local-name(.)" /><br />
			<textarea style="width:400px" rows="6"><xsl:copy-of select="node()" /></textarea><br /><br />
			</li>
		</xsl:for-each>
		</ol>
	</div>
</xsl:template>

<!-- TOP FIVES
used on multiple pages -->
<xsl:template match="/H2G2/TOP-FIVES" mode="debug">
	<div class="debug">
		/H2G2/TOP-FIVES<br />
		number of top fives: <xsl:value-of select="count(TOP-FIVE)"/><br />
		
	
		<xsl:for-each select="TOP-FIVE">
			<div style="border:1px solid #999;padding:10px;margin:10px 0;"><strong>LIST  <xsl:value-of select="position()"/></strong><br />
				@NAME: <xsl:value-of select="@NAME"/><br />
				TITLE: <xsl:value-of select="TITLE"/><br />
				
						<table cellpadding="1" cellspacing="0" border="1" style="font-size:100%;">
						<tr>
						<th>position</th>
						<th>SUBJECT</th>
						<th>H2G2ID</th>
						<th>type</th>
						<th>description</th>
						<th>date update</th>
						<th>event datet</th>
						</tr>
						<xsl:for-each select="TOP-FIVE-ARTICLE">
						<tr>
						<td><xsl:value-of select="position()"/></td>
						<td><a href="A{H2G2ID}"><xsl:value-of select="SUBJECT"/></a></td>
						<td><xsl:value-of select="H2G2ID"/></td>
						<td><xsl:value-of select="EXTRAINFO/TYPE/@ID"/></td>
						<td><xsl:value-of select="EXTRAINFO/AUTODESCRIPTION"/></td>
						<td><xsl:value-of select="DATEUPDATED/DATE/@SORT"/></td>
						<td><xsl:value-of select="EVENTDATE/DATE/@SORT"/></td>
						</tr>
						</xsl:for-each>		
						</table>
				</div>
		</xsl:for-each>		
	</div>
</xsl:template>

<!-- VIEWING-USER
used on all -->
<xsl:template match="/H2G2/VIEWING-USER" mode="debug">
	<div class="debug">
		/H2G2/VIEWING-USER<br />
		<xsl:call-template name="tablex3"/>
	</div>
</xsl:template>


<!--
###############################################################
move to <xsl:template match="/H2G2" mode="debug">
and remove <xsl:if test="$DEBUG = 1 or /H2G2/PARAMS/PARAM[NAME = 's_debug']/VALUE = '1'">
###############################################################
-->

<!-- for categorypage.xsl -->
<xsl:template name="categorypage_debug">
	<xsl:if test="$DEBUG = 1 or /H2G2/PARAMS/PARAM[NAME = 's_debug']/VALUE = '1'">
		<div class="debug">
		<strong>HIERARCHYDETAILS</strong><br />
		DISPLAYNAME = <xsl:value-of select="/H2G2/HIERARCHYDETAILS/DISPLAYNAME" /><br />
		@NODEID = <xsl:value-of select="/H2G2/HIERARCHYDETAILS/@NODEID" /><br />
		ANCESTOR[2] = <xsl:value-of select="/H2G2/HIERARCHYDETAILS/ANCESTRY/ANCESTOR[2]/NAME"/><br />
		ANCESTOR[3] = <xsl:value-of select="/H2G2/HIERARCHYDETAILS/ANCESTRY/ANCESTOR[3]/NAME"/><br />
		<br />
		<br />
		/H2G2/HIERARCHYDETAILS/MEMBERS/SUBJECTMEMBER
		<table cellpadding="0" cellspacing="0" border="1" style="font-size:100%;">
			<tr>
			<th>no.</th>
			<th>name</th>
			<th>nodeid</th>
			</tr>
			<xsl:for-each select="/H2G2/HIERARCHYDETAILS/MEMBERS/SUBJECTMEMBER">
			<tr>
			<td valign="top"><xsl:value-of select="position()"/></td>
			<td><a href="{$root}C{NODEID}"><xsl:value-of select="NAME" /></a>
			<ol>
			<xsl:for-each select="SUBNODES/SUBNODE">
			<li><a href="{$root}C{@ID}"><xsl:value-of select="." /></a> - <xsl:value-of select="@ID" /></li>
			</xsl:for-each>
			</ol></td>
			<td valign="top"><xsl:value-of select="NODEID" /></td>

			</tr>
			</xsl:for-each>
		</table>
		
		<br />
		/H2G2/HIERARCHYDETAILS/CLOSEMEMBERS/ARTICLEMEMBER
		<table cellpadding="0" cellspacing="0" border="1" style="font-size:100%;">
			<tr>
			<th>no.</th>
			<th>NAME</th>
			<th>H2G2ID</th>
			</tr>
			<xsl:for-each select="/H2G2/HIERARCHYDETAILS/CLOSEMEMBERS/ARTICLEMEMBER">
			<tr>
			<td><xsl:value-of select="position()"/></td>
			<td><a href="{$root}A{H2G2ID}"><xsl:value-of select="NAME" /></a></td>
			<td><xsl:value-of select="H2G2ID" /></td>

			</tr>
			</xsl:for-each>
		</table>
		
		</div>
	</xsl:if>
</xsl:template>

<!-- for categorypage.xsl -->
<xsl:template match="HIERARCHYDETAILS" mode="debug">
	<xsl:if test="$DEBUG = 1 or /H2G2/PARAMS/PARAM[NAME = 's_debug']/VALUE = '1'">
		<div class="debug">
		<table cellpadding="0" cellspacing="0" border="1" style="font-size:100%;">
			<tr>
			<th>position()</th>
			<th>NAME</th>
			<th>type</th>
			<th>stauts</th>
			<th>date</th>
			</tr>
			<xsl:for-each select="MEMBERS/ARTICLEMEMBER">
			<tr>
			<td><xsl:value-of select="position()"/></td>
			<td><a href="{$root}A{H2G2ID}"><xsl:value-of select="NAME" /></a></td>
			<td><xsl:value-of select="EXTRAINFO/TYPE/@ID" /></td>
			<td><xsl:value-of select="STATUS/@TYPE" /></td>
			<td><xsl:value-of select="DATECREATED/DATE/@DAY" />&nbsp;<xsl:value-of select="DATECREATED/DATE/@MONTHNAME" />&nbsp;<xsl:value-of select="DATECREATED/DATE/@YEAR" /><xsl:text> </xsl:text><xsl:value-of select="DATECREATED/DATE/@HOURS" />:<xsl:value-of select="DATECREATED/DATE/@MINUTES" />:<xsl:value-of select="DATEPOSTED/DATE/@SECONDS" /></td>
			</tr>
			</xsl:for-each>
		</table>
		</div>
	</xsl:if>
</xsl:template>

<!-- for morearticlepage.xsl -->
<xsl:template match="ARTICLES/ARTICLE-LIST" mode="debug">
<xsl:if test="$DEBUG = 1 or /H2G2/PARAMS/PARAM[NAME = 's_debug']/VALUE = '1'">
		<div class="debug">
		type:<xsl:value-of select="@TYPE" /><br />
		more:<xsl:value-of select="@MORE" /><br />
		skipto:<xsl:value-of select="@SKIPTO" /><br />
		<table cellpadding="0" cellspacing="0" border="1" style="font-size:100%;">
			<tr>
			<th>no.</th>
			<th>article title</th>
			<th>type</th>
			<th>status</th>
			<th>site</th>
			</tr>
			<xsl:for-each select="ARTICLE">
			<tr>
			<td><xsl:value-of select="../@SKIPTO + position()"/></td>
			<td><xsl:apply-templates select="SUBJECT" mode="t_userpagearticle"/></td>
			<td><xsl:value-of select="EXTRAINFO/TYPE/@ID" /></td>
			<td><xsl:value-of select="STATUS" /></td>
			<td><xsl:value-of select="SITEID" /></td>
			</tr>
			</xsl:for-each>
		</table>
		</div>
		
		</xsl:if>
</xsl:template>


<!-- for multipostspage.xsl -->
<xsl:template match="FORUMTHREADPOSTS" mode="debug">
<xsl:if test="$DEBUG = 1 or /H2G2/PARAMS/PARAM[NAME = 's_debug']/VALUE = '1'">
	<div class="debug">
	<strong>FORUMTHREADPOSTS</strong><br />
	@COUNT:<xsl:value-of select="FORUMTHREADPOSTS/@COUNT" /><br />
	@FORUMPOSTCOUNT:<xsl:value-of select="FORUMTHREADPOSTS/@FORUMPOSTCOUNT" /><br />
	@TOTALPOSTCOUNT:<xsl:value-of select="FORUMTHREADPOSTS/@TOTALPOSTCOUNT" /><br />
	@MORE:<xsl:value-of select="FORUMTHREADPOSTS/@MORE" /><br />
	<table cellpadding="2" cellspacing="0" border="1" style="font-size:100%;">
		<caption>FORUMTHREADPOSTS/POST</caption>
		<tr>
		<th>position()</th>
		<th>SUBJECT</th>
		<th>USER/USERNAME</th>
		<th>TEXT</th>
		<th>DATEPOSTED/DATE</th>
		<th>@INDEX</th>
		</tr>
		<xsl:for-each select="FORUMTHREADPOSTS/POST">
		<tr>
		<td><xsl:value-of select="position()"/></td>
		<td><xsl:value-of select="SUBJECT"/></td>
		<td><a href="{$root}U{USER/USERID}"><xsl:value-of select="USER/USERNAME" /></a></td>
		<td><xsl:value-of select="TEXT"/></td>
		<td><xsl:value-of select="DATEPOSTED/DATE/@DAY" />&nbsp;<xsl:value-of select="DATEPOSTED/DATE/@MONTHNAME" />&nbsp;<xsl:value-of select="DATEPOSTED/DATE/@YEAR" /><xsl:text> </xsl:text><xsl:value-of select="DATEPOSTED/DATE/@HOURS" />:<xsl:value-of select="DATEPOSTED/DATE/@MINUTES" />:<xsl:value-of select="DATEPOSTED/DATE/@SECONDS" /></td>
		<td><xsl:value-of select="@INDEX" /></td>
		</tr>
		</xsl:for-each>
	</table>
	</div>		
</xsl:if>
</xsl:template>

<!-- for searchpage.xsl -->
<xsl:template match="SEARCHRESULTS" mode="debug">
	<xsl:if test="$DEBUG = 1 or /H2G2/PARAMS/PARAM[NAME = 's_debug']/VALUE = '1'">
		<div class="debug">
		count:<xsl:value-of select="COUNT" /><br />
		more:<xsl:value-of select="MORE" /><br />
		skip:<xsl:value-of select="SKIP" /><br />
		<table cellpadding="0" cellspacing="0" border="1" style="font-size:100%;">
			<tr>
			<th>no.</th>
			<th>article title</th>
			<th>type</th>
			<th>status</th>
			<th>site</th>
			</tr>
			<xsl:for-each select="ARTICLERESULT">
			<tr>
			<td><xsl:value-of select="position()"/></td>
			<td><xsl:apply-templates select="SUBJECT" mode="t_subjectlink"/></td>
			<td><xsl:value-of select="EXTRAINFO/TYPE/@ID" /></td>
			<td><xsl:value-of select="STATUS" /></td>
			<td><xsl:value-of select="SITEID" /></td>
			</tr>
			</xsl:for-each>
		</table>
		</div>		
	</xsl:if>
</xsl:template>

<!-- for userpage.xsl -->
<xsl:template name="userpage_debug">
	<xsl:if test="$DEBUG = 1 or /H2G2/PARAMS/PARAM[NAME = 's_debug']/VALUE = '1'">
		<div class="debug">
		Article ID: A<xsl:value-of select="H2G2-ID" /> <BR />
		Article type: <xsl:value-of select="EXTRAINFO/TYPE/@ID" /> <BR />
		Site ID: <xsl:value-of select="SITEID" /> <BR />
		Status: <xsl:value-of select="STATUS" /> <BR />
		</div>
	</xsl:if>
</xsl:template>









<!-- userdetailspage.xsl -->
<xsl:template match="/H2G2/USER-DETAILS-FORM" mode="debug">
	<xsl:if test="$DEBUG = 1 or /H2G2/PARAMS/PARAM[NAME = 's_debug']/VALUE = '1'">
		<div class="debug">
		/H2G2/USER-DETAILS-FORM<br />
		<br />
		MESSAGE/@TYPE: <xsl:value-of select="MESSAGE/@TYPE"/><br />
		USERID: <xsl:value-of select="USERID"/><br />
		USERNAME: <xsl:value-of select="USERNAME"/><br />
		EMAIL-ADDRESS: <xsl:value-of select="EMAIL-ADDRESS"/><br />
		REGION: <xsl:value-of select="REGION"/><br />
		PREFERENCES/SKIN: <xsl:value-of select="PREFERENCES/SKIN"/><br />
		PREFERENCES/USER-MODE: <xsl:value-of select="PREFERENCES/USER-MODE"/><br />
		PREFERENCES/FORUM-STYLE: <xsl:value-of select="PREFERENCES/FORUM-STYLE"/><br />
		PREFERENCES/SITESUFFIX: <xsl:value-of select="PREFERENCES/SITESUFFIX"/><br />
		SITEPREFERENCES: <xsl:value-of select="SITEPREFERENCES"/><br />
		</div>
	</xsl:if>
</xsl:template>


<!-- indexpage.xsl -->
<xsl:template match="INDEX" mode="debug">
	<xsl:if test="$DEBUG = 1 or /H2G2/PARAMS/PARAM[NAME = 's_debug']/VALUE = '1'">
		<div class="debug">
		<script src="{$site_server}/filmnetwork/includes/sorttable.js"></script>
			<p style="font-size:80%;">@LETTER: <xsl:value-of select="@LETTER" /><br />
			@APPROVED:<xsl:value-of select="@APPROVED" /><br />
			@COUNT:<xsl:value-of select="@COUNT" /><br />
			@SKIP:<xsl:value-of select="@SKIP" /><br />
			<br />
			@TOTAL:<xsl:value-of select="@TOTAL" /><br />
			SEARCHTYPES: 
			<xsl:for-each select="SEARCHTYPES/TYPE">
				<xsl:value-of select="." /><xsl:if test="position() != last()">, </xsl:if>
			</xsl:for-each></p>
			
			<table width="635" cellpadding="2" cellspacing="0" border="1" style="font-size:80%;background:#fff;margin-bottom:20px;" class="sortable" id="indextable">
				<tr>
				<th>Title of submission</th>
				<th>Ref Number</th>
				<th>Submission Date</th>
				<th>Submitted by</th>
				<th>email</th>
				<th style="background:#efefef">status</th>
				<th style="background:#efefef">type</th>
				</tr>
				<xsl:for-each select="INDEXENTRY">
				<tr>
				<td><a href="A{H2G2ID}" title="{EXTRAINFO/DESCRIPTION}"><xsl:value-of select="SUBJECT" /></a></td>
				<td><xsl:value-of select="H2G2ID" /></td>
				<td><xsl:value-of select="EXTRAINFO/DATECREATED" /><br /></td>
				<td><a href="U{EXTRAINFO/SUBMITTEDBYID}"><xsl:value-of select="EXTRAINFO/SUBMITTEDBYNAME" /></a><br /></td>
				<td><a href="InspectUser?userid={EXTRAINFO/SUBMITTEDBYID}">InspectUser</a></td>
				<td style="background:#efefef"><xsl:value-of select="STATUSNUMBER" /></td>
				<td style="background:#efefef"><xsl:value-of select="EXTRAINFO/TYPE/@ID" /></td>
				</tr>
				</xsl:for-each>
			</table>
		</div>
	</xsl:if>
</xsl:template>



<!-- 
##########################################
 ERROR FORM
###########################################
-->

	
	<!-- TRACE/DEBUG : ERROR INPUT FORM -->
	<!-- TRACE/DEBUG : ERROR INPUT FORM -->
	<xsl:template name="ERRORFORM">
	<div id="DEBUG">
	<h3>REPORT A BUG</h3>
		<form method="post" action="http://www.bbc.co.uk/cgi-bin/cgiemail/collective/includes/error_form.txt" name="debugform">
		<table cellpadding="10">
		<tr><td>From:</td><td><input type="text" name="from" /></td></tr>
		<tr><td>Subject:</td><td><input type="text" name="subject" /></td></tr>
		<tr><td>Error Class:</td><td><select name="class" size="4" multiple="multiple">
				<option></option>
				<option value="design">Design</option>
				<option value="functionality">Functionality</option>
				<option value="content">Content</option>
				</select></td></tr>
		<tr><td>Error description:</td><td><textarea cols="25" rows="8" name="description"></textarea></td></tr>
		<tr><td>URL</td><td><input type="text" name="url" value="" /></td></tr>
		<tr><td>DNA UID</td><td><input type="text" name="dnaid" value="{/H2G2/VIEWING-USER/USER/USERID}" /></td></tr>
		<tr><td>Browser O/S</td><td><input type="text" name="browseros" value="" /></td></tr>
		<tr><td>Date</td><td><input type="text" name="date" value="{/H2G2/DATE/@DAY} {/H2G2/DATE/@MONTHNAME} {/H2G2/DATE/@YEAR}" /></td></tr>
		<tr><td></td><td><input type="submit" name="submit" /></td></tr>
		</table>		
		<script type="text/javascript">
		document.debugform.browseros.value = navigator.appName + ', ' + navigator.appVersion + ', ' + navigator.platform;
		document.debugform.url.value = location.href;
		</script>
	</form>
	</div>

	</xsl:template>
	
	
<!-- 
##########################################
	VARIABLES NEEDED
###########################################
-->

	<xsl:variable name="site_number">
		<xsl:value-of select="/H2G2/SITE-LIST/SITE[NAME='comedysoup']/@ID" />
	</xsl:variable>

	<!-- 
	Calculating totals for each option...
	-->
	<xsl:variable name="poll_count1">
		<xsl:apply-templates select="/H2G2/POLL-LIST/POLL" mode="poll_count">
			<xsl:with-param name="index">1</xsl:with-param>
		</xsl:apply-templates>
	</xsl:variable>
	<xsl:variable name="poll_count2">
		<xsl:apply-templates select="/H2G2/POLL-LIST/POLL" mode="poll_count">
			<xsl:with-param name="index">2</xsl:with-param>
		</xsl:apply-templates>
	</xsl:variable>
	<xsl:variable name="poll_count3">
		<xsl:apply-templates select="/H2G2/POLL-LIST/POLL" mode="poll_count">
			<xsl:with-param name="index">3</xsl:with-param>
		</xsl:apply-templates>
	</xsl:variable>
	<xsl:variable name="poll_count4">
		<xsl:apply-templates select="/H2G2/POLL-LIST/POLL" mode="poll_count">
			<xsl:with-param name="index">4</xsl:with-param>
		</xsl:apply-templates>
	</xsl:variable>
	<xsl:variable name="poll_count5">
		<xsl:apply-templates select="/H2G2/POLL-LIST/POLL" mode="poll_count">
			<xsl:with-param name="index">5</xsl:with-param>
		</xsl:apply-templates>
	</xsl:variable>
	<!-- 
	Calculating the total number of votes cast 
	-->
	<xsl:variable name="votes_cast" select="$poll_count1 + $poll_count2 + $poll_count3 + $poll_count4 + $poll_count5"/>
	<!-- 
	Calculating the average of all votes cast
	-->
	<xsl:variable name="poll_average_score">
		<xsl:choose>
			<xsl:when test="$votes_cast = 0">0</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="format-number((($poll_count1*1) + ($poll_count2*2) + ($poll_count3*3) + ($poll_count4*4) + ($poll_count5*5)) div $votes_cast, '#.00')"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<!-- 
	Calculating the percentages of all votes
	-->
	<xsl:variable name="option1percent">
		<xsl:choose>
			<xsl:when test="$poll_count1 = 0">0</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="format-number(($poll_count1 div $votes_cast) * 100, '#.00')"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="option2percent">
		<xsl:choose>
			<xsl:when test="$poll_count2 = 0">0</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="format-number(($poll_count2 div $votes_cast) * 100, '#.00')"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="option3percent">
		<xsl:choose>
			<xsl:when test="$poll_count3 = 0">0</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="format-number(($poll_count3 div $votes_cast) * 100, '#.00')"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="option4percent">
		<xsl:choose>
			<xsl:when test="$poll_count4 = 0">0</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="format-number(($poll_count4 div $votes_cast) * 100, '#.00')"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="option5percent">
		<xsl:choose>
			<xsl:when test="$poll_count5 = 0">0</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="format-number(($poll_count5 div $votes_cast) * 100, '#.00')"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<xsl:variable name="downloadsurl">
		<xsl:choose>
			<xsl:when test="/H2G2/SERVERNAME='BBCDEV1105'"><!-- dnadev -->
			http://downloads.bbc.co.uk/dnauploads/test/
			</xsl:when>
			<xsl:when test="/H2G2/SERVERNAME='NMSDNA0'"><!-- www0/stage -->
			http://downloads.bbc.co.uk/dnauploads/staging/
			</xsl:when>
			<xsl:otherwise><!-- www/live -->
			http://downloads.bbc.co.uk/dnauploads/library/
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<xsl:variable name="contenttype">
		<xsl:choose>
				<xsl:when test="/H2G2/MULTI-STAGE/MULTI-REQUIRED[@NAME='TYPE']/VALUE-EDITABLE=10">1</xsl:when>
				<xsl:when test="/H2G2/MULTI-STAGE/MULTI-REQUIRED[@NAME='TYPE']/VALUE-EDITABLE=11">2</xsl:when>
				<xsl:when test="/H2G2/MULTI-STAGE/MULTI-REQUIRED[@NAME='TYPE']/VALUE-EDITABLE=12">3</xsl:when>
			</xsl:choose>
	</xsl:variable>
	
	<xsl:variable name="fileextension">
		<xsl:choose>
			<xsl:when test="/H2G2/MEDIAASSETBUILDER/MEDIAASSETINFO/MEDIAASSET/MIMETYPE='image/gif'">.gif</xsl:when>
			<xsl:when test="/H2G2/MEDIAASSETBUILDER/MEDIAASSETINFO/MEDIAASSET/MIMETYPE='image/pjpeg'">.jpg</xsl:when>
		</xsl:choose>
	</xsl:variable>

</xsl:stylesheet>
