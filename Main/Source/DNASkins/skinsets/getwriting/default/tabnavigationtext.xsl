<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
	<!ENTITY space "<xsl:text xmlns:xsl='http://www.w3.org/1999/XSL/Transform'> </xsl:text>">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">

<!-- HOME -->
<xsl:variable name="tabs.front.home">
<div class="NoTabBack">
<img src="{$graphics}titles/t_gwhome.gif" alt="Home" width="116" height="39" border="0" />
</div>
</xsl:variable>

<!-- MY SPACE -->
<!-- add journal -->
<xsl:variable name="tabs.form.addjournal">
<xsl:call-template name="TABLAYOUT">
<xsl:with-param name="tabimagesource">titles/myspace/t_myjournal.gif</xsl:with-param>
<xsl:with-param name="tabimageheight">40</xsl:with-param>
<xsl:with-param name="tabimagewidth">150</xsl:with-param>
<xsl:with-param name="tabimagealt">My Journal</xsl:with-param>
<xsl:with-param name="tabbody">
<xsl:element name="{$text.heading}" use-attribute-sets="text.heading"><strong>: <xsl:value-of select="/H2G2/VIEWING-USER/USER/USERNAME" /></strong></xsl:element>&nbsp;
<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
<a id="tabbodyarrowon" href="{$root}U{/H2G2/VIEWING-USER/USER/USERID}">my space</a> | <span id="tabbodyarrowoff">my intro</span></xsl:element><br/><br/>
</xsl:with-param>
<xsl:with-param name="tabbodyextra">
	<div class="tabbodyextra">
	<xsl:if test="$test_IsEditor"><!-- removed for site pulldown -->
	<xsl:choose>
		<xsl:when test="/H2G2/POSTJOURNALFORM/PREVIEWBODY">
		<xsl:element name="{$text.medium}" use-attribute-sets="text.medium"><span class="steparrow2">Step 1: Write My Journal</span></xsl:element> <xsl:element name="{$text.base}" use-attribute-sets="text.base"><strong>Step 2 Preview</strong></xsl:element>
		</xsl:when>
		<xsl:otherwise>
		<xsl:element name="{$text.base}" use-attribute-sets="text.base"><strong>Step 1: Write My Journal</strong></xsl:element><xsl:element name="{$text.medium}" use-attribute-sets="text.medium"><span class="steparrow">Step 2 Preview</span></xsl:element>
		</xsl:otherwise>
	</xsl:choose>
	</xsl:if>
	</div>
</xsl:with-param>
</xsl:call-template>
</xsl:variable>




<!-- my space - my journal -->
<xsl:variable name="tabs.myjournal">
<xsl:call-template name="TABLAYOUT">
<xsl:with-param name="tabimagesource">http://www.bbc.co.uk/getwriting/furniture/titles/myspace/t_alljournalentries.gif</xsl:with-param>
<xsl:with-param name="tabimageheight">40</xsl:with-param>
<xsl:with-param name="tabimagewidth">200</xsl:with-param>
<xsl:with-param name="tabimagealt">All Journal Entries</xsl:with-param>
<xsl:with-param name="tabbody">
	<xsl:element name="{$text.heading}" use-attribute-sets="text.heading">
	<strong>: <xsl:value-of select="/H2G2/JOURNAL/JOURNALPOSTS/POST/USER/USERNAME"/></strong>&nbsp;
	</xsl:element>
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium"><a href="{$root}U{/H2G2/JOURNAL/JOURNALPOSTS/POST/USER/USERID}" id="tabbodyarrowon">my space</a> | <span id="tabbodyarrowoff">all <xsl:value-of select="$m_memberormy"/> weblog</span></xsl:element>
</xsl:with-param>
</xsl:call-template>
</xsl:variable>

<!-- my space page -->
<xsl:variable name="tabs.page.myspace">
<xsl:choose>
<xsl:when test="$ownerisviewer=1">
<div class="NoTabBack"><img src="{$graphics}/titles/myspace/t_myspace.gif" alt="My Space" width="135" height="47" border="0" align="middle"/>
:<xsl:apply-templates select="/H2G2/PAGE-OWNER" mode="c_usertitle"/>
</div>
</xsl:when>
<xsl:otherwise>
<div class="NoTabBack"><img src="{$graphics}/titles/myspace/t_memberspace.gif" alt="Member Space" width="177" height="40" border="0" align="middle"/>
:<xsl:apply-templates select="/H2G2/PAGE-OWNER" mode="c_usertitle"/>
</div>
</xsl:otherwise>
</xsl:choose>

</xsl:variable>

<!-- all my portfolio -->
<xsl:variable name="tabs.page.allmyportfolio">
<xsl:call-template name="TABLAYOUT">
<xsl:with-param name="tabimagesource">titles/myspace/t_allportfolios.gif</xsl:with-param>
<xsl:with-param name="tabimageheight">40</xsl:with-param>
<xsl:with-param name="tabimagewidth">148</xsl:with-param>
<xsl:with-param name="tabimagealt">All my portfolio</xsl:with-param>
<xsl:with-param name="tabbody">
	<xsl:element name="{$text.heading}" use-attribute-sets="text.heading">
	<xsl:apply-templates select="/H2G2/PAGE-OWNER" mode="c_usertitle"/>:
	</xsl:element>
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	 <a href="{$root}U{/H2G2/PAGE-OWNER/USER/USERID}" id="tabbodyarrowon">my space</a> | <span id="tabbodyarrowoff">all my portfolio</span>
	</xsl:element>
</xsl:with-param>
</xsl:call-template>
</xsl:variable>

<!-- all my conversations -->
<xsl:variable name="tabs.page.allconversations">
<xsl:call-template name="TABLAYOUT">
<xsl:with-param name="tabimagesource">titles/myspace/t_allconversations.gif</xsl:with-param>
<xsl:with-param name="tabimageheight">40</xsl:with-param>
<xsl:with-param name="tabimagewidth">193</xsl:with-param>
<xsl:with-param name="tabimagealt">All my conversations</xsl:with-param>
<xsl:with-param name="tabbody">
	<xsl:element name="{$text.heading}" use-attribute-sets="text.heading">
	<strong><xsl:apply-templates select="/H2G2/POSTS/POST-LIST/USER/USERNAME" />:</strong>&nbsp;
	</xsl:element>

	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	 <a href="{$root}U{/H2G2/POSTS/POST-LIST/USER/USERID}" id="tabbodyarrowon">my space</a> | <span id="tabbodyarrowoff">all my conversations</span>
	</xsl:element>
</xsl:with-param>
</xsl:call-template>
</xsl:variable>

<!-- all my messages -->
<xsl:variable name="tabs.page.allmymessages">
<xsl:call-template name="TABLAYOUT">
<xsl:with-param name="tabimagesource">titles/myspace/t_allmessages.gif</xsl:with-param>
<xsl:with-param name="tabimageheight">40</xsl:with-param>
<xsl:with-param name="tabimagewidth">148</xsl:with-param>
<xsl:with-param name="tabimagealt">All my messages</xsl:with-param>
<xsl:with-param name="tabbody">
	<xsl:element name="{$text.base}" use-attribute-sets="text.base">
	<strong><xsl:apply-templates select="/H2G2/FORUMSOURCE" mode="userpage_forumsource"/></strong> my space | all my messages
	</xsl:element>
</xsl:with-param>
</xsl:call-template>
</xsl:variable>

<!-- WRITE -->
<!-- front write -->
<xsl:variable name="tabs.front.write">
<xsl:call-template name="TABLAYOUT">
<xsl:with-param name="tabimagesource">titles/write/t_write.gif</xsl:with-param>
<xsl:with-param name="tabimageheight">41</xsl:with-param>
<xsl:with-param name="tabimagewidth">116</xsl:with-param>
<xsl:with-param name="tabimagealt">Write</xsl:with-param>
<xsl:with-param name="tabbody">
	<xsl:element name="{$text.base}" use-attribute-sets="text.base">
	Publish your story, poem or script on the site and submit it for review. Plus Competitions, Writing Challenges, House Rules and more...
	</xsl:element>
</xsl:with-param>
</xsl:call-template>
</xsl:variable>

<!-- write intro -->
<xsl:variable name="tabs.writeintro">
<xsl:call-template name="TABLAYOUT">
<xsl:with-param name="tabimagesource">titles/myspace/t_myintro.gif</xsl:with-param>
<xsl:with-param name="tabimageheight">40</xsl:with-param>
<xsl:with-param name="tabimagewidth">126</xsl:with-param>
<xsl:with-param name="tabimagealt">My Intro</xsl:with-param>
<xsl:with-param name="tabbody">
<strong>: <xsl:value-of select="/H2G2/VIEWING-USER/USER/USERNAME" /></strong>&nbsp;&nbsp;&nbsp;
<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
<a id="tabbodyarrowon" href="{$root}U{/H2G2/VIEWING-USER/USER/USERID}">my space</a>  | <span id="tabbodyarrowoff">remove my intro</span></xsl:element><br/><br/>
</xsl:with-param>
<xsl:with-param name="tabbodyextra">
<div class="tabbodyextra">
	<!-- Step 1 EDIT INTRO -->
	<!-- <xsl:choose>
	<xsl:when test="/H2G2/ARTICLE-EDIT-FORM/MASTHEAD=1 and not(/H2G2/ARTICLE-PREVIEW)">
	<xsl:element name="{$text.base}" use-attribute-sets="text.base"><strong>Step 1: Write an Introduction.</strong></xsl:element> <xsl:element name="{$text.medium}" use-attribute-sets="text.medium"><span class="steparrow">Step 2: Preview</span></xsl:element> 
	</xsl:when> -->
	<!-- Step 2 EDIT INTRO PREVIEW -->
	<!-- <xsl:when test="/H2G2/ARTICLE-PREVIEW and /H2G2/ARTICLE-EDIT-FORM/MASTHEAD=1">
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium"><span class="steparrow2">Step 1: Write an Introduction.</span></xsl:element> | <xsl:element name="{$text.base}" use-attribute-sets="text.base"><strong>Step 2: Preview</strong></xsl:element>
	</xsl:when>
	</xsl:choose> -->
	</div>
</xsl:with-param>
<xsl:with-param name="tabbodyfooter">
	<div class="tabbodyfooter">
	
<xsl:choose>
<xsl:when test="/H2G2/ARTICLE-EDIT-FORM/MASTHEAD=1 and not(/H2G2/ARTICLE-PREVIEW)">
	<!-- <xsl:element name="{$text.base}" use-attribute-sets="text.base">
	This is like the sleeve jacket of your Space, where you can put a little biography of yourself or explain what kind of work you're into.  This will help other writers know where you're coming from.  Use Edit to change your introduction.
	</xsl:element> -->
</xsl:when>
<xsl:when test="/H2G2/ARTICLE-PREVIEW and /H2G2/ARTICLE-EDIT-FORM/MASTHEAD=1">
	<!-- <xsl:element name="{$text.base}" use-attribute-sets="text.base">
	Check your work before you publish.
	</xsl:element> -->
</xsl:when>
</xsl:choose>
</div>
</xsl:with-param>
</xsl:call-template>
</xsl:variable>

<!-- changescreenname -->
<xsl:variable name="tabs.changescreename">
<xsl:call-template name="TABLAYOUT">
<xsl:with-param name="tabimagesource">titles/myspace/t_myscreenname.gif</xsl:with-param>
<xsl:with-param name="tabimageheight">40</xsl:with-param>
<xsl:with-param name="tabimagewidth">193</xsl:with-param>
<xsl:with-param name="tabimagealt">Change My Screenaname</xsl:with-param>
<xsl:with-param name="tabbody">
<xsl:element name="{$text.heading}" use-attribute-sets="text.heading"><strong>: <xsl:value-of select="/H2G2/VIEWING-USER/USER/USERNAME" /></strong></xsl:element>&nbsp;
<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
<a id="tabbodyarrowon" href="{$root}U{/H2G2/VIEWING-USER/USER/USERID}">my space</a> | <span id="tabbodyarrowoff">change my screen name</span></xsl:element><br/><br/>
</xsl:with-param>
<xsl:with-param name="tabbodyextra">
<div class="tabbodyextra">
	<!-- Step 2 -->
	<xsl:choose>
	<xsl:when test="/H2G2/USER-DETAILS-FORM/MESSAGE/@TYPE='detailsupdated'">
		<xsl:element name="{$text.medium}" use-attribute-sets="text.medium"><span class="steparrow2">Step 1: Change My Screen Name</span></xsl:element> | <xsl:element name="{$text.base}" use-attribute-sets="text.base"><strong>Step 2: Success</strong></xsl:element>
	</xsl:when>
	<!-- Step 1 -->
	<xsl:otherwise>
	<xsl:element name="{$text.base}" use-attribute-sets="text.base"><strong>Step 1: Change My Screen Name</strong></xsl:element> <xsl:element name="{$text.medium}" use-attribute-sets="text.medium"><span class="steparrow">step 2: Success</span></xsl:element> 
	</xsl:otherwise>
	</xsl:choose>
	</div>
</xsl:with-param>
<xsl:with-param name="tabbodyfooter">
<div class="tabbodyfooter">
<xsl:element name="{$text.base}" use-attribute-sets="text.base">Choose a name, or 'nom de plume', you are happy to use and publicise on the site, 
using the box below</xsl:element>
</div>
</xsl:with-param>
</xsl:call-template>
</xsl:variable>

<!-- write - challenge front -->
<xsl:variable name="tabs.front.challenge">
<xsl:call-template name="TABLAYOUT">
<xsl:with-param name="tabimagesource">titles/write/t_challenges.gif</xsl:with-param>
<xsl:with-param name="tabimageheight">39</xsl:with-param>
<xsl:with-param name="tabimagewidth">140</xsl:with-param>
<xsl:with-param name="tabimagealt">Challenge</xsl:with-param>
<xsl:with-param name="tabbody">
<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	<a id="tabbodyarrowon">
	<xsl:attribute name="href">
	<xsl:call-template name="sso_typedarticle_signin">
	<xsl:with-param name="type" select="42"/>
	</xsl:call-template>
	</xsl:attribute>
	start a new challenge
	</a>
	|
	<a name="tabbodyarrowon" id="tabbodyarrowon" href="{$root}Index?submit=new&amp;user=on&amp;type=42&amp;let=all">challenge index</a> |  <a name="tabbodyarrowon" id="tabbodyarrowon" href="{$root}challengebids">Challenge bids</a>
</xsl:element>
</xsl:with-param>
<xsl:with-param name="tabbodyfooter">
	<div class="tabbodyfooter">
	<xsl:element name="{$text.base}" use-attribute-sets="text.base">
	Feel like you need a task to excercise your writing muscles?  Play an existing writing game or start one of your own.
	</xsl:element>
	</div>
</xsl:with-param>
</xsl:call-template>
</xsl:variable>

<xsl:variable name="tabs.page.challengebids">
<xsl:call-template name="TABLAYOUT">
<xsl:with-param name="tabimagesource">titles/write/t_challenges.gif</xsl:with-param>
<xsl:with-param name="tabimageheight">39</xsl:with-param>
<xsl:with-param name="tabimagewidth">140</xsl:with-param>
<xsl:with-param name="tabimagealt">Challenge</xsl:with-param>
<xsl:with-param name="tabbody">
<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	<a id="tabbodyarrowon">
	<xsl:attribute name="href">
	<xsl:call-template name="sso_typedarticle_signin">
	<xsl:with-param name="type" select="42"/>
	</xsl:call-template>
	</xsl:attribute>
	start a new challenge
	</a>
	|
	<a name="tabbodyarrowon" id="tabbodyarrowon" href="{$root}Index?submit=new&amp;user=on&amp;type=42&amp;let=all">challenge index</a> |  <a id="tabbodyarrowoff">Challenge bids</a>
</xsl:element>
</xsl:with-param>
</xsl:call-template>
</xsl:variable>

<xsl:variable name="tabs.page.challenge">
<div class="NoTabBack"><img src="{$graphics}titles/write/t_challenge.gif" alt="Challenge" width="135" height="39" border="0" /></div>
</xsl:variable>

<xsl:variable name="tabs.front.competition">
<xsl:call-template name="TABLAYOUT">
<xsl:with-param name="tabimagesource">titles/write/t_competitions.gif</xsl:with-param>
<xsl:with-param name="tabimageheight">39</xsl:with-param>
<xsl:with-param name="tabimagewidth">174</xsl:with-param>
<xsl:with-param name="tabimagealt">Competitions</xsl:with-param>
<xsl:with-param name="tabbody">
	<xsl:element name="{$text.base}" use-attribute-sets="text.base">
	Top talent from our previous competitions
	</xsl:element>
</xsl:with-param>
</xsl:call-template>
</xsl:variable>

<xsl:variable name="tabs.page.competition">
<xsl:call-template name="TABLAYOUT">
<xsl:with-param name="tabimagesource">titles/write/t_competitions.gif</xsl:with-param>
<xsl:with-param name="tabimageheight">39</xsl:with-param>
<xsl:with-param name="tabimagewidth">174</xsl:with-param>
<xsl:with-param name="tabimagealt">Competitions</xsl:with-param>
<xsl:with-param name="tabbody">
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	<!-- <a href="{$root}competitions" id="tabbodyarrowon">gw competitions</a> |  --><a href="{$root}competitions" id="tabbodyarrowon">past competitions</a> | <span id="tabbodyarrowoff"><xsl:value-of select="/H2G2/ARTICLE/SUBJECT"/></span>
	</xsl:element>
</xsl:with-param>
</xsl:call-template>
</xsl:variable>

<xsl:variable name="tabs.page.competition2">
<xsl:call-template name="TABLAYOUT">
<xsl:with-param name="tabimagesource">titles/write/t_competitions.gif</xsl:with-param>
<xsl:with-param name="tabimageheight">39</xsl:with-param>
<xsl:with-param name="tabimagewidth">174</xsl:with-param>
<xsl:with-param name="tabimagealt">Competitions</xsl:with-param>
<xsl:with-param name="tabbody">
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	<!-- <a href="{$root}competitions" id="tabbodyarrowon">gw competitions</a> |  --><a href="{$root}competitions" id="tabbodyarrowon">past competitions</a> | <a href="{$root}A{/H2G2/PARAMS/PARAM[NAME='s_id']/VALUE}" id="tabbodyarrowon"><xsl:value-of select="/H2G2/PARAMS/PARAM[NAME='s_name']/VALUE"/></a> | <span id="tabbodyarrowoff">winner</span>
	</xsl:element>
</xsl:with-param>
</xsl:call-template>
</xsl:variable>

<xsl:variable name="tabs.page.thiscompetition">
<xsl:call-template name="TABLAYOUT">
<xsl:with-param name="tabimagesource">titles/write/t_competitions.gif</xsl:with-param>
<xsl:with-param name="tabimageheight">39</xsl:with-param>
<xsl:with-param name="tabimagewidth">174</xsl:with-param>
<xsl:with-param name="tabimagealt">Competitions</xsl:with-param>
<xsl:with-param name="tabbody">
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	<!-- <a href="{$root}competitions" id="tabbodyarrowon">gw competitions</a> |  --><a href="{$root}winners" id="tabbodyarrowon">past winners</a> | <span id="tabbodyarrowoff">this competition</span>
	</xsl:element>
</xsl:with-param>
</xsl:call-template>
</xsl:variable>

<xsl:variable name="tabs.front.winners">
<xsl:call-template name="TABLAYOUT">
<xsl:with-param name="tabimagesource">titles/write/t_competitions.gif</xsl:with-param>
<xsl:with-param name="tabimageheight">39</xsl:with-param>
<xsl:with-param name="tabimagewidth">174</xsl:with-param>
<xsl:with-param name="tabimagealt">Competitions</xsl:with-param>
<xsl:with-param name="tabbody">
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	<!-- <a href="{$root}competitions" id="tabbodyarrowon">gw competitions</a> |  --><span  id="tabbodyarrowoff">past competition winners</span>
	</xsl:element>
</xsl:with-param>
</xsl:call-template>
</xsl:variable>


<!-- special features -->
<xsl:variable name="tabs.page.specialfeatures">
<xsl:call-template name="TABLAYOUT">
<xsl:with-param name="tabimagesource">titles/reviewcircle/t_special.gif</xsl:with-param>
<xsl:with-param name="tabimageheight">38</xsl:with-param>
<xsl:with-param name="tabimagewidth">187</xsl:with-param>
<xsl:with-param name="tabimagealt">Special Features</xsl:with-param>
<xsl:with-param name="tabbody">
	<!-- <xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	<span  id="tabbodyarrowoff">past competition winners</span>
	</xsl:element> -->
</xsl:with-param>
</xsl:call-template>
</xsl:variable>


<!-- write creative -->
<xsl:variable name="tabs.form.creative">
<xsl:call-template name="TABLAYOUT">
<xsl:with-param name="tabimagesource">titles/write/t_publishwork.gif</xsl:with-param>
<xsl:with-param name="tabimageheight">39</xsl:with-param>
<xsl:with-param name="tabimagewidth">200</xsl:with-param>
<xsl:with-param name="tabimagealt">Publish Yor Work</xsl:with-param>
<xsl:with-param name="tabbody">
	
	<xsl:choose>
	<xsl:when test="/H2G2/MULTI-STAGE/@TYPE='TYPED-ARTICLE-CREATE'">
	<xsl:element name="{$text.base}" use-attribute-sets="text.base"><strong>Step 1: Publish Your Work</strong></xsl:element><xsl:element name="{$text.medium}" use-attribute-sets="text.medium"> <span class="steparrow">Step 2: Preview</span> <span class="steparrow">Success</span></xsl:element><br/>
	</xsl:when>
	<xsl:when test="/H2G2/MULTI-STAGE/@TYPE='TYPED-ARTICLE-EDIT' or /H2G2/MULTI-STAGE/@TYPE='TYPED-ARTICLE-EDIT-PREVIEW' or /H2G2/MULTI-STAGE/@TYPE='TYPED-ARTICLE-PREVIEW'">
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium"><span class="steparrow2">Step 1: Write Creative</span></xsl:element> <xsl:element name="{$text.base}" use-attribute-sets="text.base"><strong>Step 2: Preview</strong></xsl:element> <xsl:element name="{$text.medium}" use-attribute-sets="text.medium"><span class="steparrow"> Success</span></xsl:element><br/>
	</xsl:when>
	</xsl:choose>
	
</xsl:with-param>
<xsl:with-param name="tabbodyfooter">
<!-- <div class="tabbodyfooter">
	<xsl:choose>
		<xsl:when test="/H2G2/MULTI-STAGE/@TYPE='TYPED-ARTICLE-CREATE'">
		<xsl:element name="{$text.base}" use-attribute-sets="text.base">
		Publish your work on the Get writing website!
		</xsl:element>
		</xsl:when>
		<xsl:when test="/H2G2/MULTI-STAGE/@TYPE='TYPED-ARTICLE-EDIT' or /H2G2/MULTI-STAGE/@TYPE='TYPED-ARTICLE-EDIT-PREVIEW' or /H2G2/MULTI-STAGE/@TYPE='TYPED-ARTICLE-PREVIEW'">
		<table width="560" border="0" cellspacing="0" cellpadding="0">
		<tr>
		<td><xsl:element name="{$text.base}" use-attribute-sets="text.base">
		Check your work before you publish.</xsl:element></td>
		<td align="right">
		<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
		<a href="#edit"><img src="{$graphics}buttons/button_editlarge.gif" alt="" border="0"/></a><xsl:text> </xsl:text><xsl:text> </xsl:text><a href="#publish"><img src="{$graphics}buttons/button_publish.gif" alt="" border="0"/></a>
		</xsl:element> 
		</td>
		</tr>
		</table>
		</xsl:when>
	</xsl:choose>
</div>-->
</xsl:with-param>
</xsl:call-template>
</xsl:variable>

<!-- from edit creative/publish work -->
<xsl:variable name="tabs.fromedit.creative">
<xsl:call-template name="TABLAYOUT">
<xsl:with-param name="tabimagesource">titles/write/t_publishwork.gif</xsl:with-param>
<xsl:with-param name="tabimageheight">39</xsl:with-param>
<xsl:with-param name="tabimagewidth">200</xsl:with-param>
<xsl:with-param name="tabimagealt">Publish Yor Work</xsl:with-param>
<xsl:with-param name="tabbody">
<xsl:element name="{$text.medium}" use-attribute-sets="text.medium"><span class="steparrow2">Step 1: Write Creative</span> <span class="steparrow2">Step 2: Preview</span></xsl:element> <xsl:element name="{$text.base}" use-attribute-sets="text.base"><strong>Success</strong></xsl:element>
</xsl:with-param>
<xsl:with-param name="tabbodyfooter">
	<div class="tabbodyfooter">
	<xsl:element name="{$text.base}" use-attribute-sets="text.base">You have published your work on Get Writing!</xsl:element><br/>
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	
	<br/>
	<strong>You now have three options:</strong>
	<br/><br/>
	
	<table width="500" border="0" cellspacing="2" cellpadding="2">
	<tr>
	<td valign="top">
	<img src="{$graphics}icons/icon_editgrey.gif" alt="" width="40" height="40" border="0"/>
	</td>
	<td valign="top">
	<!-- edit article -->
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	Spotted a typo? Make final tweaks, check your spelling or adjust the format. 
<br/>
	<div class="arrow2"><a href="{$root}TypedArticle?aedit=new&amp;type={$current_article_type}&amp;h2g2id={/H2G2/ARTICLE/ARTICLEINFO/H2G2ID}">edit</a></div>
	</xsl:element>
	</td>
	</tr>
	<tr>
	<td valign="top">
	<img src="{$graphics}icons/icon_myspace.gif" alt="" width="40" height="40" border="0"/>
	</td>
	<td valign="top">
	<!-- see article in my space -->
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	Go to your Portfolio on 'My Space' to see where to find and edit your work later. <br/>
	<div class="arrow2"><a href="U{/H2G2/VIEWING-USER/USER/USERID}#portfolio">my space</a></div>
	</xsl:element>
	</td>
	</tr>
	<tr>
	<td valign="top">
	<img src="{$graphics}icons/icon_submitreview.gif" alt="" width="40" height="40" border="0"/>
	</td>
	<td valign="top">
	<!-- submit to peer review -->
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	Introduce your work to the community and submit it for review. Be ready to offer reviews to others!<br/>
	<div class="arrow2"><a href="{$root}SubmitReviewForum?action=submitrequest&amp;h2g2id={/H2G2/ARTICLE/ARTICLEINFO/H2G2ID}&amp;s_type={/H2G2/ARTICLE/EXTRAINFO/TYPE/@ID}" xsl:use-attribute-sets="mSUBMITTABLE_r_submit-to-peer-review">submit for review now</a></div>
	</xsl:element>
	</td>
	</tr>
	<tr><td></td>
	<td>
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	Whatever you choose now, you can still edit or submit your work for review anytime in the future.
	</xsl:element>
	</td>
	</tr>
	</table>
	</xsl:element>
	
	</div>
</xsl:with-param>
</xsl:call-template>
</xsl:variable>

<xsl:variable name="tabs.page.creative">
<div class="NoTabBack"><img src="{$graphics}titles/write/t_creativework.gif" alt="Creative Work" width="177" height="39" border="0" /></div>
</xsl:variable>

<xsl:variable name="tabs.page.advice">
<div class="NoTabBack"><img src="{$graphics}titles/write/t_shareyouradvice.gif" alt="Advice" width="197" height="28" border="0" /></div>
</xsl:variable>



<!-- form edit advice -->
<xsl:variable name="tabs.fromedit.advice">
<xsl:call-template name="TABLAYOUT">
<xsl:with-param name="tabimagesource">titles/write/t_shareadvice.gif</xsl:with-param>
<xsl:with-param name="tabimageheight">39</xsl:with-param>
<xsl:with-param name="tabimagewidth">205</xsl:with-param>
<xsl:with-param name="tabimagealt">Share your advice</xsl:with-param>
<xsl:with-param name="tabbody">
<xsl:element name="{$text.medium}" use-attribute-sets="text.medium"><span class="steparrow2">Step 1: Write Creative</span> <span class="steparrow2">Step 2: Preview</span></xsl:element> <xsl:element name="{$text.base}" use-attribute-sets="text.base"><strong>Success</strong></xsl:element>
</xsl:with-param>
<xsl:with-param name="tabbodyfooter">
	<div class="tabbodyfooter">
	<xsl:element name="{$text.base}" use-attribute-sets="text.base">You have published your advice on Get Writing! </xsl:element><br/>
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	
	<br/>
	<strong>You now have two options:</strong>
	<br/><br/>
	
	<table width="500" border="0" cellspacing="2" cellpadding="2">
	<tr>
	<td valign="top">
	<img src="{$graphics}icons/icon_editgrey.gif" alt="" width="40" height="40" border="0"/>
	</td>
	<td valign="top">
	<!-- edit article -->
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	Spotted a typo? Make final tweaks, check your spelling or adjust the format. 
	<br/>
	<div class="arrow2"><a href="{$root}TypedArticle?aedit=new&amp;type={$current_article_type}&amp;h2g2id={/H2G2/ARTICLE/ARTICLEINFO/H2G2ID}">edit</a></div>
	</xsl:element>
	</td>
	</tr>
	<tr>
	<td valign="top">
	<img src="{$graphics}icons/icon_myspace.gif" alt="" width="40" height="40" border="0"/>
	</td>
	<td valign="top">
	<!-- see article in my space -->
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	Go to your Portfolio on 'My Space' to see where to find and edit your advice later. <br/>
	<div class="arrow2"><a href="U{/H2G2/VIEWING-USER/USER/USERID}#portfolio">my space</a></div>
	</xsl:element>
	</td>
	</tr>
	</table>
	</xsl:element>
	
	</div>
</xsl:with-param>
</xsl:call-template>
</xsl:variable>

<xsl:variable name="tabs.form.advice">
<xsl:call-template name="TABLAYOUT">
<xsl:with-param name="tabimagesource">titles/write/t_shareadvice.gif</xsl:with-param>
<xsl:with-param name="tabimageheight">39</xsl:with-param>
<xsl:with-param name="tabimagewidth">205</xsl:with-param>
<xsl:with-param name="tabimagealt">Share your advice</xsl:with-param>
<xsl:with-param name="tabbody">

	<xsl:choose>
	<xsl:when test="/H2G2/MULTI-STAGE/@TYPE='TYPED-ARTICLE-CREATE'">
	<xsl:element name="{$text.base}" use-attribute-sets="text.base"><strong>Step 1: Write Your Advice</strong></xsl:element> <xsl:element name="{$text.medium}" use-attribute-sets="text.medium"><span class="steparrow">Step 2: Preview</span> <span class="steparrow">Success</span></xsl:element><br/>
	</xsl:when>
	<xsl:when test="/H2G2/MULTI-STAGE/@TYPE='TYPED-ARTICLE-EDIT-PREVIEW' or /H2G2/MULTI-STAGE/@TYPE='TYPED-ARTICLE-PREVIEW'">
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium"><span class="steparrow2">Step 1: Write Advice</span></xsl:element> <xsl:element name="{$text.base}" use-attribute-sets="text.base"><strong>Step 2: Preview</strong></xsl:element> <xsl:element name="{$text.medium}" use-attribute-sets="text.medium"><span class="steparrow">Success</span></xsl:element><br/>
	</xsl:when>
	</xsl:choose>
	
</xsl:with-param>
<xsl:with-param name="tabbodyfooter">
<!--
	<div class="tabbodyfooter">
	<xsl:choose>
		<xsl:when test="/H2G2/MULTI-STAGE/@TYPE='TYPED-ARTICLE-CREATE'">
		<xsl:element name="{$text.base}" use-attribute-sets="text.base">
		Publish your advice on the Get Writing website!
		</xsl:element>
		</xsl:when>
		<xsl:when test="/H2G2/MULTI-STAGE/@TYPE='TYPED-ARTICLE-EDIT' or  /H2G2/MULTI-STAGE/@TYPE='TYPED-ARTICLE-EDIT-PREVIEW' or /H2G2/MULTI-STAGE/@TYPE='TYPED-ARTICLE-PREVIEW'">
		<table width="560" border="0" cellspacing="0" cellpadding="0">
		<tr>
		<td><xsl:element name="{$text.base}" use-attribute-sets="text.base">
		Check your work before you publish.</xsl:element></td>
		<td align="right">
 		<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
		<a href="#edit"><img src="{$graphics}buttons/button_editlarge.gif" alt="" border="0"/></a><xsl:text> </xsl:text><xsl:text> </xsl:text><a href="#publish"><img src="{$graphics}buttons/button_publish.gif" alt="" border="0"/></a>
		</xsl:element> 
		</td>
		</tr>
		</table>
		</xsl:when>
	</xsl:choose>
	</div>
	-->
</xsl:with-param>
</xsl:call-template>
</xsl:variable>

<xsl:variable name="tabs.fromedit.challenge">
<xsl:call-template name="TABLAYOUT">
<xsl:with-param name="tabimagesource">titles/write/t_startanewchallenge.gif</xsl:with-param>
<xsl:with-param name="tabimageheight">39</xsl:with-param>
<xsl:with-param name="tabimagewidth">240</xsl:with-param>
<xsl:with-param name="tabimagealt">Start a New Challenge</xsl:with-param>
<xsl:with-param name="tabbody">
<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	<a id="tabbodyarrowon" href="{$root}/challenge">challenges</a> | 
	<a id="tabbodyarrowoff">start a new challenge</a>
</xsl:element>
</xsl:with-param>
<xsl:with-param name="tabbodyextra">

<div class="tabbodyextra">
<xsl:element name="{$text.medium}" use-attribute-sets="text.medium"><span class="steparrow2">Step 1: Create a New challenge</span> <span class="steparrow2">Step 2: Preview</span></xsl:element> <xsl:element name="{$text.base}" use-attribute-sets="text.base"><strong>Success</strong></xsl:element>
</div>
	
</xsl:with-param>
<xsl:with-param name="tabbodyfooter">
	<div class="tabbodyfooter">
	<xsl:element name="{$text.base}" use-attribute-sets="text.base">You have set your challenge on Get Writing!</xsl:element><br/>
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	
	<br/>
	<strong>You now have two options:</strong>
	<br/><br/>
	
	<table width="500" border="0" cellspacing="2" cellpadding="2">
	<tr>
	<td valign="top">
	<img src="{$graphics}icons/icon_editgrey.gif" alt="" width="40" height="40" border="0"/>
	</td>
	<td valign="top">
	<!-- edit article -->
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	Spotted a typo? Make final tweaks, check your spelling or adjust the format. 
<br/>
	<div class="arrow2"><a href="{$root}TypedArticle?aedit=new&amp;type={$current_article_type}&amp;h2g2id={/H2G2/ARTICLE/ARTICLEINFO/H2G2ID}">edit</a></div>
	</xsl:element>
	</td>
	</tr>
	<tr>
	<td valign="top">
	<img src="{$graphics}icons/icon_myspace.gif" alt="" width="40" height="40" border="0"/>
	</td>
	<td valign="top">
	<!-- see article in my space -->
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	Go to your Portfolio on 'My Space' to see where to find and edit your challenge later. <br/>
	<div class="arrow2"><a href="U{/H2G2/VIEWING-USER/USER/USERID}#portfolio">my space</a></div>
	</xsl:element>
	</td>
	</tr>
	</table>
	</xsl:element>
	
	</div>
</xsl:with-param>
</xsl:call-template> 
</xsl:variable>

<!-- write challenge -->
<xsl:variable name="tabs.form.challenge">
<xsl:call-template name="TABLAYOUT">
<xsl:with-param name="tabimagesource">titles/write/t_startanewchallenge.gif</xsl:with-param>
<xsl:with-param name="tabimageheight">39</xsl:with-param>
<xsl:with-param name="tabimagewidth">240</xsl:with-param>
<xsl:with-param name="tabimagealt">Start a New Challenge</xsl:with-param>
<xsl:with-param name="tabbody">
<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	<a id="tabbodyarrowon" href="{$root}/challenge">challenges</a> | 
	<a id="tabbodyarrowoff">start a new challenge</a>
</xsl:element>
</xsl:with-param>
<xsl:with-param name="tabbodyextra">

	<div class="tabbodyextra">
		<xsl:choose>
		<xsl:when test="/H2G2/MULTI-STAGE/@TYPE='TYPED-ARTICLE-CREATE'">
		<xsl:element name="{$text.base}" use-attribute-sets="text.base"><strong>Step 1: Create a New Challenge</strong></xsl:element> <xsl:element name="{$text.medium}" use-attribute-sets="text.medium"><span class="steparrow">Step 2: Preview</span> <span class="steparrow">Success</span></xsl:element><br/>
		</xsl:when>
		<xsl:when test="/H2G2/MULTI-STAGE/@TYPE='TYPED-ARTICLE-EDIT-PREVIEW' or /H2G2/MULTI-STAGE/@TYPE='TYPED-ARTICLE-PREVIEW'">
		<xsl:element name="{$text.medium}" use-attribute-sets="text.medium"><span class="steparrow2">Step 1: Create a New Challenge</span></xsl:element> <xsl:element name="{$text.base}" use-attribute-sets="text.base"><strong>Step 2: Preview</strong></xsl:element> <xsl:element name="{$text.medium}" use-attribute-sets="text.medium"><span class="steparrow">Success</span></xsl:element><br/>
		</xsl:when>
		</xsl:choose>
	</div>
	
</xsl:with-param>
<xsl:with-param name="tabbodyfooter">

	<div class="tabbodyfooter">
	<xsl:choose>
		<xsl:when test="/H2G2/MULTI-STAGE/@TYPE='TYPED-ARTICLE-CREATE'">
		<xsl:element name="{$text.base}" use-attribute-sets="text.base">
		Fill in this simple form to tell everyone about your writing challenge.
		</xsl:element>
		</xsl:when>
		<xsl:when test="/H2G2/MULTI-STAGE/@TYPE='TYPED-ARTICLE-EDIT' or  /H2G2/MULTI-STAGE/@TYPE='TYPED-ARTICLE-EDIT-PREVIEW' or /H2G2/MULTI-STAGE/@TYPE='TYPED-ARTICLE-PREVIEW'">
		<table width="560" border="0" cellspacing="0" cellpadding="0">
		<tr>
		<td><xsl:element name="{$text.base}" use-attribute-sets="text.base">
		Check your challenge before you publish.</xsl:element></td>
		<td align="right">
		<!-- <xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
		<a href="#edit"><img src="{$graphics}buttons/button_editlarge.gif" alt="" border="0"/></a><xsl:text> </xsl:text><xsl:text> </xsl:text><a href="#publish"><img src="{$graphics}buttons/button_publish.gif" alt="" border="0"/></a>
		</xsl:element> -->
		</td>
		</tr>
		</table>
		</xsl:when>
	</xsl:choose>
	</div>
	
</xsl:with-param>
</xsl:call-template>
</xsl:variable>

<!-- READ AND REVIEW -->
<xsl:variable name="tabs.front.reviewcircle">
<xsl:call-template name="TABLAYOUT">
<xsl:with-param name="tabimagesource">titles/reviewcircle/t_read.gif</xsl:with-param>
<xsl:with-param name="tabimageheight">33</xsl:with-param>
<xsl:with-param name="tabimagewidth">80</xsl:with-param>
<xsl:with-param name="tabimagealt">Read</xsl:with-param>
<xsl:with-param name="tabbody">
	<xsl:element name="{$text.base}" use-attribute-sets="text.base">
	Read contributions to the site
	</xsl:element>
</xsl:with-param>
</xsl:call-template>
</xsl:variable>

<xsl:variable name="tabs.form.submitreviewforum">
<xsl:call-template name="TABLAYOUT">
<xsl:with-param name="tabimagesource">titles/reviewcircle/t_submitreview.gif</xsl:with-param>
<xsl:with-param name="tabimageheight">30</xsl:with-param>
<xsl:with-param name="tabimagewidth">219</xsl:with-param>
<xsl:with-param name="tabimagealt">Submit for Review</xsl:with-param>
<xsl:with-param name="tabbodyfooter">

<div class="tabbodyfooter">
<xsl:choose>
	<xsl:when test="/H2G2/SUBMIT-REVIEW-FORUM/NEW-THREAD">
	<p><xsl:element name="{$text.base}" use-attribute-sets="text.base">Success! Your work and introduction  have been submitted to the <a href="RF{NEW-THREAD/REVIEWFORUM/@ID}"><xsl:value-of select="NEW-THREAD/REVIEWFORUM/FORUMNAME" /></a> Review Circle</xsl:element></p>
	<p><xsl:element name="{$text.medium}" use-attribute-sets="text.medium"><strong>Next Steps:</strong></xsl:element></p>

<table width="500" border="0" cellspacing="2" cellpadding="2">
<tr>
	<td valign="top"><img src="{$graphics}icons/icon_submitreview.gif" alt="" width="40" height="40" border="0"/></td>
	<td valign="top">
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium"><br/>
	Start reviewing other people's stuff. This is the quickest way we know of getting
	feedback on your own work. Do at least five reviews!
	<div class="arrow2"><a href="{$root}readandreview">See Read &amp; Review</a></div></xsl:element>
	</td>
</tr>
<tr>
	<td valign="top"><img src="{$graphics}icons/icon_talk.gif" alt="" width="40" height="40" border="0"/></td>
	<td valign="top">
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	<div class="arrow2"><a href="{$root}talk">See Talk</a></div></xsl:element>
	</td>
</tr>
<tr>
	<td valign="top"><img src="{$graphics}icons/icon_minicourse.gif" alt="" width="40" height="40" border="0"/></td>
	<td valign="top">
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">Take a mini-course to improve your work in its next draft.<br/>
	<div class="arrow2"><a href="{$root}learn">See Learn.</a></div></xsl:element>
	</td>
</tr>
</table>
	
	</xsl:when>
	<xsl:otherwise>
	<xsl:element name="{$text.base}" use-attribute-sets="text.base">
	Leave a message in the box below to introduce your work to the Read &amp; Review
	</xsl:element>
	</xsl:otherwise>
</xsl:choose>
	
	
</div>

</xsl:with-param>
</xsl:call-template>
</xsl:variable>

<xsl:variable name="tabs.page.editorspicks">
<xsl:call-template name="TABLAYOUT">
<xsl:with-param name="tabimagesource">titles/reviewcircle/t_editorspicks.gif</xsl:with-param>
<xsl:with-param name="tabimageheight">40</xsl:with-param>
<xsl:with-param name="tabimagewidth">171</xsl:with-param>
<xsl:with-param name="tabimagealt">Editor's Pick's</xsl:with-param>
<xsl:with-param name="tabbody">
&nbsp;
</xsl:with-param>
</xsl:call-template>
</xsl:variable>

<xsl:variable name="tabs.page.anthology">
<xsl:call-template name="TABLAYOUT">
<xsl:with-param name="tabimagesource">titles/reviewcircle/t_anthology.gif</xsl:with-param>
<xsl:with-param name="tabimageheight">40</xsl:with-param>
<xsl:with-param name="tabimagewidth">171</xsl:with-param>
<xsl:with-param name="tabimagealt">Anthology</xsl:with-param>
<xsl:with-param name="tabbody">
<xsl:element name="{$text.base}" use-attribute-sets="text.base">Our own literary magazine</xsl:element>
</xsl:with-param>
</xsl:call-template>
</xsl:variable>



<xsl:variable name="tabs.page.reviewcircle">
<xsl:call-template name="TABLAYOUT">
<xsl:with-param name="tabimagesource">titles/reviewcircle/t_read.gif</xsl:with-param>
<xsl:with-param name="tabimageheight">33</xsl:with-param>
<xsl:with-param name="tabimagewidth">80</xsl:with-param>
<xsl:with-param name="tabimagealt">Read</xsl:with-param>
<xsl:with-param name="tabbody">
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	<a name="tabbodyarrowon" id="tabbodyarrowon" href="{$root}readandreview">read</a> | <a id="tabbodyarrowoff"><xsl:value-of select="$reviewcirclename" />: review circle</a>
	</xsl:element>
</xsl:with-param>
</xsl:call-template>
</xsl:variable>

<xsl:variable name="tabs.intro.reviewcircle">
<div class="NoTabBack"><img src="{$graphics}titles/reviewcircle/t_readandreview.gif" alt="Read" width="173" height="37" border="0"/></div>
</xsl:variable>

<!-- LEARN -->
<xsl:variable name="tabs.front.learn">

<xsl:call-template name="TABLAYOUT">
<xsl:with-param name="tabimagesource">titles/learn/t_learn.gif</xsl:with-param>
<xsl:with-param name="tabimageheight">39</xsl:with-param>
<xsl:with-param name="tabimagewidth">128</xsl:with-param>
<xsl:with-param name="tabimagealt">Learn</xsl:with-param>
<xsl:with-param name="tabbody">
	<xsl:element name="{$text.base}" use-attribute-sets="text.base">
	Courses material and conversations to improve your writing skills
	</xsl:element>
</xsl:with-param>
</xsl:call-template>

</xsl:variable>

<xsl:variable name="tabs.front.minicourses">
<xsl:call-template name="TABLAYOUT">
<xsl:with-param name="tabimagesource">titles/learn/t_minicourses.gif</xsl:with-param>
<xsl:with-param name="tabimageheight">39</xsl:with-param>
<xsl:with-param name="tabimagewidth">158</xsl:with-param>
<xsl:with-param name="tabimagealt">Mini Courses</xsl:with-param>
<xsl:with-param name="tabbody">
	<!-- <xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	<span id="tabbodyarrowoff">mini courses</span> | Index: 
	<a href="Index?submit=new&amp;user=on&amp;type=50&amp;let=all" id="tabbodyarrowon">beginners</a> | 
	<a href="Index?submit=new&amp;user=on&amp;type=54&amp;let=all" id="tabbodyarrowon">intermediate</a> | 
	<a href="Index?submit=new&amp;user=on&amp;type=55&amp;let=all" id="tabbodyarrowon">advanced</a>
	</xsl:element> -->
	<xsl:element name="{$text.base}" use-attribute-sets="text.base">
	Improve your writing with professional advice and exercises
	</xsl:element>
</xsl:with-param>
</xsl:call-template>
</xsl:variable>

<!-- subbeginners -->
<xsl:variable name="tabs.page.subbeginners">
<xsl:call-template name="TABLAYOUT">
<xsl:with-param name="tabimagesource">titles/learn/t_minicourses.gif</xsl:with-param>
<xsl:with-param name="tabimageheight">39</xsl:with-param>
<xsl:with-param name="tabimagewidth">158</xsl:with-param>
<xsl:with-param name="tabimagealt">Mini Courses</xsl:with-param>
<xsl:with-param name="tabbody">
	<!-- <xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	<span id="tabbodyarrowoff">mini courses</span> | Index: 
	<a href="Index?submit=new&amp;user=on&amp;type=50&amp;let=all" id="tabbodyarrowon">beginners</a> | 
	<a href="Index?submit=new&amp;user=on&amp;type=54&amp;let=all" id="tabbodyarrowon">intermediate</a> | 
	<a href="Index?submit=new&amp;user=on&amp;type=55&amp;let=all" id="tabbodyarrowon">advanced</a>
	</xsl:element> -->
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	<a href="Index?submit=new&amp;user=on&amp;type=50&amp;let=all" id="tabbodyarrowon">beginners</a>
	</xsl:element>
</xsl:with-param>
</xsl:call-template>
</xsl:variable>

<!-- subinter -->
<xsl:variable name="tabs.page.subinter">
<xsl:call-template name="TABLAYOUT">
<xsl:with-param name="tabimagesource">http://www.bbc.co.uk/getwriting/furniture/titles/learn/t_minicourses.gif</xsl:with-param>
<xsl:with-param name="tabimageheight">39</xsl:with-param>
<xsl:with-param name="tabimagewidth">158</xsl:with-param>
<xsl:with-param name="tabimagealt">Mini Courses</xsl:with-param>
<xsl:with-param name="tabbody">
	<!-- <xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	<span id="tabbodyarrowoff">mini courses</span> | Index: 
	<a href="Index?submit=new&amp;user=on&amp;type=50&amp;let=all" id="tabbodyarrowon">beginners</a> | 
	<a href="Index?submit=new&amp;user=on&amp;type=54&amp;let=all" id="tabbodyarrowon">intermediate</a> | 
	<a href="Index?submit=new&amp;user=on&amp;type=55&amp;let=all" id="tabbodyarrowon">advanced</a>
	</xsl:element> -->
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	<a href="Index?submit=new&amp;user=on&amp;type=54&amp;let=all" id="tabbodyarrowon">intermediate</a>
	</xsl:element>
</xsl:with-param>
</xsl:call-template>
</xsl:variable>

<!-- subadv -->
<xsl:variable name="tabs.page.subadv">
<xsl:call-template name="TABLAYOUT">
<xsl:with-param name="tabimagesource">titles/learn/t_minicourses.gif</xsl:with-param>
<xsl:with-param name="tabimageheight">39</xsl:with-param>
<xsl:with-param name="tabimagewidth">158</xsl:with-param>
<xsl:with-param name="tabimagealt">Mini Courses</xsl:with-param>
<xsl:with-param name="tabbody">
	<!-- <xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	<span id="tabbodyarrowoff">mini courses</span> | Index: 
	<a href="Index?submit=new&amp;user=on&amp;type=50&amp;let=all" id="tabbodyarrowon">beginners</a> | 
	<a href="Index?submit=new&amp;user=on&amp;type=54&amp;let=all" id="tabbodyarrowon">intermediate</a> | 
	<a href="Index?submit=new&amp;user=on&amp;type=55&amp;let=all" id="tabbodyarrowon">advanced</a>
	</xsl:element> -->
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	<a href="Index?submit=new&amp;user=on&amp;type=55&amp;let=all" id="tabbodyarrowon">advanced</a>
	</xsl:element>
</xsl:with-param>
</xsl:call-template>
</xsl:variable>

<xsl:variable name="tabs.page.excercise">
<xsl:call-template name="TABLAYOUT">
<xsl:with-param name="tabimagesource">titles/learn/t_minicourses.gif</xsl:with-param>
<xsl:with-param name="tabimageheight">39</xsl:with-param>
<xsl:with-param name="tabimagewidth">158</xsl:with-param>
<xsl:with-param name="tabimagealt">Mini Courses</xsl:with-param>
<xsl:with-param name="tabbody">
	<!-- <xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	<span id="tabbodyarrowoff">mini courses</span> | Index: 
	<a href="Index?submit=new&amp;user=on&amp;type=50&amp;let=all" id="tabbodyarrowon">beginners</a> | 
	<a href="Index?submit=new&amp;user=on&amp;type=54&amp;let=all" id="tabbodyarrowon">intermediate</a> | 
	<a href="Index?submit=new&amp;user=on&amp;type=55&amp;let=all" id="tabbodyarrowon">advanced</a>
	</xsl:element> -->
</xsl:with-param>
</xsl:call-template>
</xsl:variable>

<xsl:variable name="tabs.form.writeexcercise">
<xsl:call-template name="TABLAYOUT">
<xsl:with-param name="tabimagesource">titles/learn/t_minicourses.gif</xsl:with-param>
<xsl:with-param name="tabimageheight">39</xsl:with-param>
<xsl:with-param name="tabimagewidth">158</xsl:with-param>
<xsl:with-param name="tabimagealt">Mini Courses</xsl:with-param>
<xsl:with-param name="tabbodyextra">
<div class="tabbodyextra">
<xsl:choose>
<xsl:when test="/H2G2/MULTI-STAGE/@TYPE='TYPED-ARTICLE-CREATE'">
<xsl:element name="{$text.base}" use-attribute-sets="text.base"><strong>Step 1: create a new excercise</strong></xsl:element>  <xsl:element name="{$text.medium}" use-attribute-sets="text.medium"><span class="steparrow">Step 2: Preview</span> <span class="steparrow">Success</span></xsl:element><br/>
</xsl:when>
<xsl:when test="/H2G2/MULTI-STAGE/@TYPE='TYPED-ARTICLE-EDIT' or /H2G2/MULTI-STAGE/@TYPE='TYPED-ARTICLE-EDIT-PREVIEW' or /H2G2/MULTI-STAGE/@TYPE='TYPED-ARTICLE-PREVIEW'">
<xsl:element name="{$text.medium}" use-attribute-sets="text.medium"><span class="steparrow2">Step 1: create a new excercise</span></xsl:element> <xsl:element name="{$text.base}" use-attribute-sets="text.base"> <strong>Step 2: Preview</strong></xsl:element> <xsl:element name="{$text.medium}" use-attribute-sets="text.medium"><span class="steparrow">Success</span></xsl:element><br/>
</xsl:when>
</xsl:choose>	
</div>
</xsl:with-param>
</xsl:call-template>
</xsl:variable>

<xsl:variable name="tabs.timetable.minicourses">
<xsl:call-template name="TABLAYOUT">
<xsl:with-param name="tabimagesource">titles/learn/t_timetable.gif</xsl:with-param>
<xsl:with-param name="tabimageheight">42</xsl:with-param>
<xsl:with-param name="tabimagewidth">129</xsl:with-param>
<xsl:with-param name="tabimagealt">Time Table</xsl:with-param>
<xsl:with-param name="tabbody">
	<!-- <xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	<span id="tabbodyarrowoff">mini courses</span> | Index: 
	<a href="Index?submit=new&amp;user=on&amp;type=50&amp;let=all" id="tabbodyarrowon">beginners</a> | 
	<a href="Index?submit=new&amp;user=on&amp;type=54&amp;let=all" id="tabbodyarrowon">intermediate</a> | 
	<a href="Index?submit=new&amp;user=on&amp;type=55&amp;let=all" id="tabbodyarrowon">advanced</a>
	</xsl:element> -->
</xsl:with-param>
</xsl:call-template>
</xsl:variable>

<xsl:variable name="tabs.front.thecraft">
<xsl:call-template name="TABLAYOUT">
<xsl:with-param name="tabimagesource">titles/learn/t_thecraft.gif</xsl:with-param>
<xsl:with-param name="tabimageheight">36</xsl:with-param>
<xsl:with-param name="tabimagewidth">146</xsl:with-param>
<xsl:with-param name="tabimagealt">The Craft</xsl:with-param>
<xsl:with-param name="tabbody">
	<!-- <xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	<a href="Index?submit=new&amp;user=on&amp;type=53&amp;let=all" id="tabbodyarrowon">craft index</a>
	</xsl:element> -->	
	<xsl:element name="{$text.base}" use-attribute-sets="text.base">
		We've commissioned articles from top writers on the basics of getting started
	</xsl:element>
</xsl:with-param>	
<!--<xsl:with-param name="tabbodyfooter">
 <div class="tabbodyfooter">
	<xsl:element name="{$text.base}" use-attribute-sets="text.base">
	We've commissioned articles from top writers on the basics of getting started.
	</xsl:element>
	</div> 
</xsl:with-param>-->
</xsl:call-template>
</xsl:variable>

<xsl:variable name="tabs.page.thecraft">

<xsl:call-template name="TABLAYOUT">
<xsl:with-param name="tabimagesource">titles/learn/t_thecraft.gif</xsl:with-param>
<xsl:with-param name="tabimageheight">36</xsl:with-param>
<xsl:with-param name="tabimagewidth">146</xsl:with-param>
<xsl:with-param name="tabimagealt">The Craft</xsl:with-param>
<xsl:with-param name="tabbody">
	<!-- <xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	<a href="{$root}thecraft" id="tabbodyarrowon">The Craft</a> | <span id="tabbodyarrowoff">Craft Article</span> | <a href="Index?submit=new&amp;user=on&amp;type=53&amp;let=all" id="tabbodyarrowon">craft index</a>
	</xsl:element>

 -->
</xsl:with-param>
</xsl:call-template>

</xsl:variable>


<xsl:variable name="tabs.page.thecraft2">

<xsl:call-template name="TABLAYOUT">
<xsl:with-param name="tabimagesource">titles/learn/t_thecraft.gif</xsl:with-param>
<xsl:with-param name="tabimageheight">36</xsl:with-param>
<xsl:with-param name="tabimagewidth">146</xsl:with-param>
<xsl:with-param name="tabimagealt">The Craft</xsl:with-param>
<xsl:with-param name="tabbody">
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	<a href="Index?submit=new&amp;user=on&amp;type=53&amp;let=all" id="tabbodyarrowon">craft index</a>
	</xsl:element>


</xsl:with-param>
</xsl:call-template>

</xsl:variable>

<xsl:variable name="tabs.front.toolsandquizzes">
<xsl:call-template name="TABLAYOUT">
<xsl:with-param name="tabimagesource">http://www.bbc.co.uk/getwriting/furniture/titles/learn/t_toolsandquizzes.gif</xsl:with-param>
<xsl:with-param name="tabimageheight">39</xsl:with-param>
<xsl:with-param name="tabimagewidth">214</xsl:with-param>
<xsl:with-param name="tabimagealt">Tools &amp; Quizzes</xsl:with-param>
<xsl:with-param name="tabbody">
	<!-- <xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	<span id="tabbodyarrowoff">Tools &amp; quizzes</span> | <a href="Index?submit=new&amp;user=on&amp;type=57&amp;let=all" id="tabbodyarrowon">tool index</a> | <a href="{$root}quizindex" id="tabbodyarrowon">quiz index</a>
	</xsl:element> -->
	<xsl:element name="{$text.base}" use-attribute-sets="text.base">
	Get inspiration and test your knowledge with our interactive tools
	</xsl:element>
</xsl:with-param>
</xsl:call-template>
</xsl:variable>

<xsl:variable name="tabs.page.tools">
<xsl:call-template name="TABLAYOUT">
<xsl:with-param name="tabimagesource">titles/learn/t_tools.gif</xsl:with-param>
<xsl:with-param name="tabimageheight">35</xsl:with-param>
<xsl:with-param name="tabimagewidth">100</xsl:with-param>
<xsl:with-param name="tabimagealt">Tools</xsl:with-param>
<xsl:with-param name="tabbody">
	 <xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	<a href="{$root}toolsandquizzes" id="tabbodyarrowon">Tools &amp; quizzes</a> | <a href="Index?submit=new&amp;user=on&amp;type=57&amp;let=all" id="tabbodyarrowon">tool index</a> | <a href="{$root}quizindex" id="tabbodyarrowon">quiz index</a>
	</xsl:element> 
</xsl:with-param>
</xsl:call-template>
</xsl:variable>


<xsl:variable name="tabs.page.subtool">
<xsl:call-template name="TABLAYOUT">
<xsl:with-param name="tabimagesource">titles/learn/t_tools.gif</xsl:with-param>
<xsl:with-param name="tabimageheight">35</xsl:with-param>
<xsl:with-param name="tabimagewidth">100</xsl:with-param>
<xsl:with-param name="tabimagealt">Tools</xsl:with-param>
<xsl:with-param name="tabbody">
	 <xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	<a href="Index?submit=new&amp;user=on&amp;type=57&amp;let=all" id="tabbodyarrowon">tool index</a>
	</xsl:element> 
</xsl:with-param>
</xsl:call-template>
</xsl:variable>

<xsl:variable name="tabs.front.help">
<xsl:call-template name="TABLAYOUT">
<xsl:with-param name="tabimagesource">titles/t_sitehelp.gif</xsl:with-param>
<xsl:with-param name="tabimageheight">40</xsl:with-param>
<xsl:with-param name="tabimagewidth">154</xsl:with-param>
<xsl:with-param name="tabimagealt">Help</xsl:with-param>
<xsl:with-param name="tabbody"></xsl:with-param>
</xsl:call-template>

</xsl:variable>



<xsl:variable name="tabs.help.page">

<xsl:call-template name="TABLAYOUT">
<xsl:with-param name="tabimagesource">titles/t_helpsection.gif</xsl:with-param>
<xsl:with-param name="tabimageheight">40</xsl:with-param>
<xsl:with-param name="tabimagewidth">154</xsl:with-param>
<xsl:with-param name="tabimagealt">Help</xsl:with-param>
<xsl:with-param name="tabbody">
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	<a href="{$root}help" id="tabbodyarrowon">site help</a> | <a id="tabbodyarrowoff"><xsl:value-of select="/H2G2/ARTICLE/SUBJECT" /></a><br/>
	</xsl:element>
</xsl:with-param>
</xsl:call-template>

</xsl:variable>

<!-- TALK -->
<xsl:variable name="tabs.front.talk">
<div class="NoTabBack">
<img src="{$graphics}titles/talk/t_talk.gif" alt="Talk" width="205" height="39" border="0"/>
</div>
</xsl:variable>

<xsl:variable name="tabs.talk.page">

<xsl:call-template name="TABLAYOUT">
<xsl:with-param name="tabimagesource">titles/talk/t_talkspace.gif</xsl:with-param>
<xsl:with-param name="tabimageheight">40</xsl:with-param>
<xsl:with-param name="tabimagewidth">145</xsl:with-param>
<xsl:with-param name="tabimagealt">Talk Space</xsl:with-param>
<xsl:with-param name="tabbody">
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	<a href="{$root}talk" id="tabbodyarrowon">talk</a> | <span id="tabbodyarrowoff"><xsl:value-of select="/H2G2/ARTICLE/SUBJECT" /></span><br/>
	</xsl:element>
</xsl:with-param>
</xsl:call-template>

</xsl:variable>

<!-- GROUPS -->

<xsl:variable name="tabs.form.group.create">
<xsl:call-template name="TABLAYOUT">
<xsl:with-param name="tabimagesource">titles/groups/t_startnewgroup.gif</xsl:with-param>
<xsl:with-param name="tabimageheight">38</xsl:with-param>
<xsl:with-param name="tabimagewidth">192</xsl:with-param>
<xsl:with-param name="tabimagealt">Start a new Group</xsl:with-param>
<xsl:with-param name="tabbody">

	<xsl:if test="$test_IsEditor"><!-- removed for site pulldown -->
	<xsl:choose>
	<xsl:when test="/H2G2/MULTI-STAGE/@TYPE='CLUB'">
	<xsl:element name="{$text.base}" use-attribute-sets="text.base"><strong>Step 1: About this Group</strong></xsl:element>  <xsl:element name="{$text.medium}" use-attribute-sets="text.medium"><span class="steparrow">Step 2: Preview</span> <span class="steparrow">Success</span></xsl:element><br/>
 
	</xsl:when>
		<xsl:when test="/H2G2/MULTI-STAGE/@TYPE='CLUB-EDIT' or /H2G2/MULTI-STAGE/@TYPE='CLUB-EDIT-PREVIEW' or /H2G2/MULTI-STAGE/@TYPE='CLUB-PREVIEW'">
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium"><span class="steparrow2">Step 1: About this Group</span></xsl:element> <xsl:element name="{$text.base}" use-attribute-sets="text.base"><strong>Step 2: Preview</strong></xsl:element> <xsl:element name="{$text.medium}" use-attribute-sets="text.medium"><span class="steparrow">Success</span></xsl:element><br/>
	</xsl:when>
	</xsl:choose>
	<!--end removed for site pulldown --></xsl:if>


</xsl:with-param>
<xsl:with-param name="tabbodyfooter">
<div class="tabbodyfooter">
<xsl:if test="$test_IsEditor"><!-- removed for site pulldown -->
<xsl:choose>
	<xsl:when test="/H2G2/MULTI-STAGE/@TYPE='CLUB'">
	<xsl:element name="{$text.base}" use-attribute-sets="text.base">
	Fill in this simple form to tell everyone about how your group works.
	</xsl:element>
	</xsl:when>
	<xsl:when test="/H2G2/MULTI-STAGE/@TYPE='CLUB-EDIT' or /H2G2/MULTI-STAGE/@TYPE='CLUB-EDIT-PREVIEW' or /H2G2/MULTI-STAGE/@TYPE='CLUB-PREVIEW'">
	<table width="560" border="0" cellspacing="0" cellpadding="0">
	<tr>
	<td><xsl:element name="{$text.base}" use-attribute-sets="text.base">
	Before you save your group on the site, make sure it says what you want. Still, you can always come back and edit it later.</xsl:element></td>
	<td width="200" align="right">
<!-- 	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	<a href="#edit"><img src="{$graphics}buttons/button_editlarge.gif" alt="" border="0"/></a><xsl:text> </xsl:text><xsl:text> </xsl:text><a href="#save"><img src="{$graphics}buttons/button_save.gif" alt="" border="0"/></a>
	</xsl:element> -->
	</td>
	</tr>
	</table>
	</xsl:when>
</xsl:choose>

<!-- removed for site pulldown --></xsl:if>
</div>
</xsl:with-param>
</xsl:call-template>
</xsl:variable>

<xsl:variable name="tabs.fromedit.groups">
<xsl:call-template name="TABLAYOUT">
<xsl:with-param name="tabimagesource">titles/groups/t_startnewgroup.gif</xsl:with-param>
<xsl:with-param name="tabimageheight">38</xsl:with-param>
<xsl:with-param name="tabimagewidth">192</xsl:with-param>
<xsl:with-param name="tabimagealt">Start a new Group</xsl:with-param>
<xsl:with-param name="tabbody">
<xsl:element name="{$text.medium}" use-attribute-sets="text.medium"><span class="steparrow2">Step 1: About This Group</span> <span class="steparrow2">Step 2: Preview</span></xsl:element> <xsl:element name="{$text.base}" use-attribute-sets="text.base"><strong>Success</strong></xsl:element>
</xsl:with-param>
<xsl:with-param name="tabbodyfooter">
<div class="tabbodyfooter">
<xsl:element name="{$text.base}" use-attribute-sets="text.base">You have saved your group to the site!  If you want to make any changes or manage membership, use the Group Admin button.</xsl:element><br/>
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	<br/>
	<strong>You now have two options:</strong>
	<br/><br/>
	</xsl:element>
	<table width="500" border="0" cellspacing="2" cellpadding="2">
	<tr>
	<td valign="top">
	<img src="{$graphics}icons/icon_editgrey.gif" alt="" width="40" height="40" border="0"/>
	</td>
	<td valign="top">
	<!-- edit article -->
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	Spotted a typo? Make final tweaks, check your spelling or adjust the format.<br/>
	<div class="arrow2"><a href="{$root}G{/H2G2/CLUB/CLUBINFO/@ID}?action=edit&amp;_msxml={$clubfields}">edit</a></div>
	</xsl:element>
	</td>
	</tr>
	<tr>
	<td valign="top">
	<img src="{$graphics}icons/icon_myspace.gif" alt="" width="40" height="40" border="0"/>
	</td>
	<td valign="top">
	<!-- see article in my space -->
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	Go to your Portfolio on 'My Space' to see where to find and edit your group later.<br/>
	<div class="arrow2"><a href="U{/H2G2/VIEWING-USER/USER/USERID}#group">my space</a></div>
	</xsl:element>
	</td>
	</tr>
	</table>
	

</div>
</xsl:with-param>
</xsl:call-template>
</xsl:variable>


<xsl:variable name="tabs.front.groups">
<xsl:call-template name="TABLAYOUT">
<xsl:with-param name="tabimagesource">titles/groups/t_groups.gif</xsl:with-param>
<xsl:with-param name="tabimageheight">39</xsl:with-param>
<xsl:with-param name="tabimagewidth">119</xsl:with-param>
<xsl:with-param name="tabimagealt">Groups</xsl:with-param>
<xsl:with-param name="tabbody">
	<xsl:element name="{$text.base}" use-attribute-sets="text.base">
	Work in a small writing group to set your own tasks, challenges and discussion topics.  Join an existing group or start your own.
	</xsl:element>
</xsl:with-param>
</xsl:call-template>
</xsl:variable>


<xsl:variable name="tabs.group.admin">
<xsl:call-template name="TABLAYOUT">
<xsl:with-param name="tabimagesource">http://www.bbc.co.uk/getwriting/furniture/titles/groups/t_groupadmin.gif</xsl:with-param>
<xsl:with-param name="tabimageheight">39</xsl:with-param>
<xsl:with-param name="tabimagewidth">205</xsl:with-param>
<xsl:with-param name="tabimagealt">Group Admin</xsl:with-param>
<xsl:with-param name="tabbody">
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	<span id="tabbodyarrowoff">group admin</span> | 
	<xsl:if test="$ownerisviewer=1 or $test_IsEditor">
		<a href="{$root}G{/H2G2/CLUB/CLUBINFO/@ID}?action=edit&amp;_msxml={$clubfields}" id="tabbodyarrowon">
		edit group intro
		</a>
	</xsl:if> | <a href="{$root}G{/H2G2/CLUB/CLUBINFO/@ID}#discussion" id="tabbodyarrowon">read latest discussion</a><br/>
	</xsl:element>
</xsl:with-param>
</xsl:call-template>
</xsl:variable>

<xsl:variable name="tabs.member.group.admin">
<xsl:call-template name="TABLAYOUT">
<xsl:with-param name="tabimagesource">titles/groups/t_groupadmin.gif</xsl:with-param>
<xsl:with-param name="tabimageheight">30</xsl:with-param>
<xsl:with-param name="tabimagewidth">150</xsl:with-param>
<xsl:with-param name="tabimagealt">Group Admin</xsl:with-param>
<xsl:with-param name="tabbody">
	<xsl:element name="{$text.base}" use-attribute-sets="text.base">
	group admin | read latest discussion<br/>
	</xsl:element>
	<xsl:element name="{$text.base}" use-attribute-sets="text.base">
	hello <a href="U{/H2G2/VIEWING-USER/USER/USERID}">'<xsl:value-of select="/H2G2/VIEWING-USER/USER/USERNAME" />'</a> you can manage your group membership here<br/>
	</xsl:element>
</xsl:with-param>
</xsl:call-template>
</xsl:variable>

<xsl:variable name="tabs.member.bulletin">
<xsl:call-template name="TABLAYOUT">
<xsl:with-param name="tabimagesource">titles/groups/t_membershipbulletin.gif</xsl:with-param>
<xsl:with-param name="tabimageheight">39</xsl:with-param>
<xsl:with-param name="tabimagewidth">220</xsl:with-param>
<xsl:with-param name="tabimagealt">Membership Bulletin</xsl:with-param>
<xsl:with-param name="tabbody">
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	<a href="U{/H2G2/VIEWING-USER/USER/USERID}" id="tabbodyarrowon">my space</a><br/>
	</xsl:element>
</xsl:with-param>
<xsl:with-param name="tabbodyfooter">
<div class="tabbodyfooter">
	<xsl:element name="{$text.base}" use-attribute-sets="text.base">
		hello <a href="U{/H2G2/VIEWING-USER/USER/USERID}">'<xsl:value-of select="/H2G2/VIEWING-USER/USER/USERNAME" />'</a> you can check on applications and offers for promotion<br/>
	</xsl:element>
</div>
</xsl:with-param>
</xsl:call-template>
</xsl:variable>

<xsl:variable name="tabs.group.page">
<xsl:call-template name="TABLAYOUT">
<xsl:with-param name="tabimagesource">titles/groups/t_groupsspace.gif</xsl:with-param>
<xsl:with-param name="tabimageheight">39</xsl:with-param>
<xsl:with-param name="tabimagewidth">163</xsl:with-param>
<xsl:with-param name="tabimagealt">Group Space</xsl:with-param>
<xsl:with-param name="tabbody">
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	<span id="tabbodyarrowoff">this Group's Space</span> <xsl:if test="/H2G2/CLUB/JOURNAL/JOURNALPOSTS/@CANWRITE = 1">| <span id="tabbodyarrowon"><a href="#discussion">start Group Discussion</a></span></xsl:if>
	</xsl:element>
</xsl:with-param>
<xsl:with-param name="tabbodyfooter">
	<div class="tabbodyfooter">
	<xsl:element name="{$text.base}" use-attribute-sets="text.base">
	Find out who is in this group and what they do.  Read the latest discussion to check what's happening now.<br/>
	<xsl:apply-templates select="/H2G2/CLUBACTIONRESULT"/>
	</xsl:element>
	</div>
</xsl:with-param>
</xsl:call-template>
</xsl:variable>

<xsl:variable name="tabs.index.group">
<xsl:call-template name="TABLAYOUT">
<xsl:with-param name="tabimagesource">titles/groups/t_groupindex.gif</xsl:with-param>
<xsl:with-param name="tabimageheight">39</xsl:with-param>
<xsl:with-param name="tabimagewidth">205</xsl:with-param>
<xsl:with-param name="tabimagealt">Group Index</xsl:with-param>
<xsl:with-param name="tabbodyfooter">
<div class="tabbodyfooter">	
<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	<div class="heading1" id="titleSearchGrey">BROWSE GROUPS</div>
	Click on a letter to see all groups listed alphabetically
	</xsl:element>
		<div class="alphabox">
		<xsl:call-template name="alphaindex">
		<xsl:with-param name="showtype">&amp;user=on</xsl:with-param>
		<xsl:with-param name="type">&amp;type=1001</xsl:with-param>
		<xsl:with-param name="imgtype">small</xsl:with-param>
		</xsl:call-template>
		</div>
	</div>
</xsl:with-param>
</xsl:call-template>

</xsl:variable>

<xsl:variable name="tabs.front.eventsvideo">
<!-- <div class="NoTabBack"><img src="{$graphics}titles/eventsvideo/t_eventsvideo.gif" alt="Events &amp; Video" width="182" height="41" border="0"/></div> -->
<div class="NoTabBack"><img src="{$graphics}titles/eventsvideo/t_watch_listen.gif" alt="Watch and Listen" width="219" height="33" border="0"/></div>
</xsl:variable>

<xsl:variable name="tabs.calendar.eventsvideo">
<xsl:call-template name="TABLAYOUT">
<xsl:with-param name="tabimagesource">titles/eventsvideo/t_eventscalendar.gif</xsl:with-param>
<xsl:with-param name="tabimageheight">40</xsl:with-param>
<xsl:with-param name="tabimagewidth">194</xsl:with-param>
<xsl:with-param name="tabimagealt">Watch &amp; Listen</xsl:with-param>
<xsl:with-param name="tabbody">
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	<span id="tabbodyarrowon"><a href="{$root}eventsvideo">watch &amp; listen</a></span> | <span id="tabbodyarrowoff">events calendar</span><br/>
	</xsl:element>
</xsl:with-param>
</xsl:call-template>
</xsl:variable>

<!-- SEARCH AND BROWSE -->
<xsl:variable name="tabs.front.search">
<div class="NoTabBack"><img src="{$graphics}titles/search/t_searchbrowse.gif" alt="Search and Browse" width="190" height="40" border="0"/></div>
</xsl:variable>

<xsl:variable name="tabs.index.thecraft">
<xsl:call-template name="TABLAYOUT">
<xsl:with-param name="tabimagesource">titles/search/t_allcraftarticles.gif</xsl:with-param>
<xsl:with-param name="tabimageheight">39</xsl:with-param>
<xsl:with-param name="tabimagewidth">205</xsl:with-param>
<xsl:with-param name="tabimagealt">All Craft Articles</xsl:with-param>
<xsl:with-param name="tabbody">
	<!-- <xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	<span id="tabbodyarrowon"><a href="{$root}thecraft">the craft</a></span> | <span id="tabbodyarrowoff">craft index</span><br/>
	</xsl:element> -->
</xsl:with-param>
</xsl:call-template>
</xsl:variable>

<xsl:variable name="tabs.index.minicourse">
<xsl:call-template name="TABLAYOUT">
<xsl:with-param name="tabimagesource">titles/learn/t_minicourseindex.gif</xsl:with-param>
<xsl:with-param name="tabimageheight">39</xsl:with-param>
<xsl:with-param name="tabimagewidth">171</xsl:with-param>
<xsl:with-param name="tabimagealt">All Mini Courses</xsl:with-param>
<xsl:with-param name="tabbody">
	<!-- <xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	<span id="tabbodyarrowon"><a href="{$root}minicourse">mini-courses</a></span> | Index: 
	<a href="Index?submit=new&amp;user=on&amp;type=50&amp;let=all" id="tabbodyarrowon"><xsl:if test="$searchtype=50"><xsl:attribute name="id">tabbodyarrowoff</xsl:attribute></xsl:if>beginners</a> | 
	<a href="Index?submit=new&amp;user=on&amp;type=54&amp;let=all" id="tabbodyarrowon"><xsl:if test="$searchtype=54"><xsl:attribute name="id">tabbodyarrowoff</xsl:attribute></xsl:if>intermediate</a> | 
	<a href="Index?submit=new&amp;user=on&amp;type=55&amp;let=all" id="tabbodyarrowon"><xsl:if test="$searchtype=55"><xsl:attribute name="id">tabbodyarrowoff</xsl:attribute></xsl:if>advanced</a>
	</xsl:element> -->
</xsl:with-param>
</xsl:call-template>
</xsl:variable>

<xsl:variable name="tabs.index.alltools">
<xsl:call-template name="TABLAYOUT">
<xsl:with-param name="tabimagesource">titles/learn/t_alltools.gif</xsl:with-param>
<xsl:with-param name="tabimageheight">39</xsl:with-param>
<xsl:with-param name="tabimagewidth">132</xsl:with-param>
<xsl:with-param name="tabimagealt">All Tools</xsl:with-param>
<xsl:with-param name="tabbody">
	<!-- <xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	<span id="tabbodyarrowon">
	<a href="{$root}toolsandquizzes">tools &amp; quizzes</a></span> | <span id="tabbodyarrowoff">tool index</span> | 
	<a href="{$root}quizindex" id="tabbodyarrowon">quiz index</a>

	</xsl:element> -->
	<xsl:element name="{$text.base}" use-attribute-sets="text.base">
	Use our fabulous tools
	</xsl:element>
</xsl:with-param>
</xsl:call-template>
</xsl:variable>

<xsl:variable name="tabs.index.allquizzes">
<xsl:call-template name="TABLAYOUT">
<xsl:with-param name="tabimagesource">titles/learn/t_allquizzes.gif</xsl:with-param>
<xsl:with-param name="tabimageheight">39</xsl:with-param>
<xsl:with-param name="tabimagewidth">174</xsl:with-param>
<xsl:with-param name="tabimagealt">All Quizzes</xsl:with-param>
<xsl:with-param name="tabbody">
	<!-- <xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	<span id="tabbodyarrowon">
	<a href="{$root}toolsandquizzes">tools &amp; quizzes</a></span> | <a href="Index?submit=new&amp;user=on&amp;type=57&amp;let=all" id="tabbodyarrowon">tool index</a> | 
 <span id="tabbodyarrowoff">quiz index</span>

	</xsl:element> -->
	<xsl:element name="{$text.base}" use-attribute-sets="text.base">
	Take a fabulous quiz
	</xsl:element>
</xsl:with-param>
</xsl:call-template>
</xsl:variable>

<xsl:variable name="tabs.index.generic">
<xsl:call-template name="TABLAYOUT">
<xsl:with-param name="tabimagesource">http://www.bbc.co.uk/getwriting/furniture/titles/search/t_browseindex.gif</xsl:with-param>
<xsl:with-param name="tabimageheight">40</xsl:with-param>
<xsl:with-param name="tabimagewidth">205</xsl:with-param>
<xsl:with-param name="tabimagealt">Browse Index</xsl:with-param>
<xsl:with-param name="tabbody">
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	<!-- <span id="tabbodyarrowon"><a href="{$root}browse">search and browse</a></span> | <span id="tabbodyarrowoff"><xsl:value-of select="$searchtypename" /> index</span><br/> -->
	</xsl:element>
</xsl:with-param>
</xsl:call-template>
</xsl:variable>

<xsl:variable name="tabs.general">
<xsl:call-template name="TABLAYOUT">
<xsl:with-param name="tabimagesource">titles/t_general.gif</xsl:with-param>
<xsl:with-param name="tabimageheight">35</xsl:with-param>
<xsl:with-param name="tabimagewidth">48</xsl:with-param>
<xsl:with-param name="tabimagealt">GW</xsl:with-param>
<xsl:with-param name="tabbody">
</xsl:with-param>
</xsl:call-template>
</xsl:variable>


<xsl:variable name="tabs.page.conversation">
<div class="NoTabBack"><img src="{$graphics}titles/talk/t_conversations.gif" alt="Conversations" width="205" height="39" border="0"/></div>
</xsl:variable>


<xsl:variable name="tabs.page.usefullinks">
<div class="NoTabBack"><img src="{$graphics}titles/t_usefullinks.gif" alt="Useful Links" width="170" height="36" border="0"/></div>
</xsl:variable>

<xsl:variable name="tabs.page.newsletter">
<div class="NoTabBack"><img src="{$graphics}titles/t_newsletter.gif" alt="Newsletter" width="131" height="34" border="0"/></div>
</xsl:variable>



<xsl:variable name="tabs.page.addcomment">
	<xsl:call-template name="TABLAYOUT">
	<xsl:with-param name="tabimagesource">titles/talk/t_addcomment.gif</xsl:with-param>
	<xsl:with-param name="tabimageheight">40</xsl:with-param>
	<xsl:with-param name="tabimagewidth">205</xsl:with-param>
	<xsl:with-param name="tabimagealt">Add Comment</xsl:with-param>
	<xsl:with-param name="tabbody">
&nbsp;
	</xsl:with-param>
	</xsl:call-template>
</xsl:variable>

<xsl:variable name="tabs.groups.discussion">
	<xsl:call-template name="TABLAYOUT">
	<xsl:with-param name="tabimagesource">titles/groups/t_strgroupdiscussion.gif</xsl:with-param>
	<xsl:with-param name="tabimageheight">39</xsl:with-param>
	<xsl:with-param name="tabimagewidth">212</xsl:with-param>
	<xsl:with-param name="tabimagealt">Start a Group Discussion</xsl:with-param>
	<xsl:with-param name="tabbody">
	<div class="tabbody">
	<xsl:choose>
	<xsl:when test="/H2G2/FORUMSOURCE/@TYPE='clubjournal' and not(/H2G2/POSTTHREADFORM/PREVIEWBODY)">
	<xsl:element name="{$text.base}" use-attribute-sets="text.base"><strong>Step 1: start a discussion</strong></xsl:element><xsl:element name="{$text.medium}" use-attribute-sets="text.medium"><span class="steparrow">Step 2: Preview</span> <span class="steparrow">Success</span></xsl:element><br/>
	</xsl:when>
	<xsl:when test="/H2G2/FORUMSOURCE/@TYPE='clubjournal' and /H2G2/POSTTHREADFORM/PREVIEWBODY">
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium"><span class="steparrow2">Step 1: start a discussion</span></xsl:element> <xsl:element name="{$text.base}" use-attribute-sets="text.base"> <strong>Step 2: Preview</strong></xsl:element> <xsl:element name="{$text.medium}" use-attribute-sets="text.medium"><span class="steparrow">Success</span></xsl:element><br/>
	</xsl:when>
	<xsl:when test="/H2G2/PARAMS/PARAM[NAME='s_view']/VALUE='discussioncreated'">
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium"><span class="steparrow2">Step 1: start a discussion</span> <span class="steparrow2">Step 2: Preview</span></xsl:element> <xsl:element name="{$text.base}" use-attribute-sets="text.base"><strong>Success</strong></xsl:element>
	</xsl:when>	
	</xsl:choose>	
	</div>
	</xsl:with-param>
	<xsl:with-param name="tabbodyfooter">
	<div class="tabbodyfooter">
	<xsl:choose>
	<xsl:when test="/H2G2/FORUMSOURCE/@TYPE='clubjournal' and not(/H2G2/POSTTHREADFORM/PREVIEWBODY)">
	<xsl:element name="{$text.base}" use-attribute-sets="text.base">You are starting a group discussion for the  <strong>'<xsl:value-of select="/H2G2/FORUMSOURCE/CLUB/NAME" />'</strong> group. Let your members know whose work you're reviewing this week, what is the latest news, or just have a chat.</xsl:element>
	</xsl:when>
	<xsl:when test="/H2G2/FORUMSOURCE/@TYPE='clubjournal' and /H2G2/POSTTHREADFORM/PREVIEWBODY">
		<table width="560" border="0" cellspacing="0" cellpadding="0">
		<tr>
		<td>
		<xsl:element name="{$text.base}" use-attribute-sets="text.base">
		You are starting a group discussion for the  <strong>'<xsl:value-of select="/H2G2/FORUMSOURCE/CLUB/NAME" />'</strong> group. Check what you're about to post carefully before publishing it to Get Writing.  Group discussions can not be deleted.
		</xsl:element>
		</td>
		<td width="200" align="right">
<!-- 		<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
		<a href="#edit"><img src="{$graphics}buttons/button_editlarge.gif" alt="" border="0"/></a><xsl:text> </xsl:text><xsl:text> </xsl:text><a href="#save"><img src="{$graphics}buttons/button_save.gif" alt="" border="0"/></a>
		</xsl:element> -->
		</td>
		</tr>
		</table>
	</xsl:when>
	<xsl:when test="/H2G2/PARAMS/PARAM[NAME='s_view']/VALUE='discussioncreated'">
	<xsl:element name="{$text.base}" use-attribute-sets="text.base">Your group space has been updated and is now open for  'group discussion'. </xsl:element><br/>
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	
	<br/>
	<strong>You now have two options:</strong>
	<br/><br/>
	
	<table width="500" border="0" cellspacing="2" cellpadding="2">
	<tr>
	<td valign="top">
	<img src="{$graphics}icons/icon_editgrey.gif" alt="" width="40" height="40" border="0"/>
	</td>
	<td valign="top">
	<!-- edit article -->
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	Spotted a typo? Make final tweaks, check your spelling or adjust the format. <br/>
	<div class="arrow2"><a href="{$root}G{/H2G2/CLUB/CLUBINFO/@ID}#discussion">edit my group discussion</a></div>
	</xsl:element>
	</td>
	</tr>
	<tr>
	<td valign="top">
	<img src="{$graphics}icons/icon_group.gif" alt="" width="36" height="31" border="0"/>
	</td>
	<td valign="top">
	<!-- see article in my space -->
	<xsl:element name="{$text.medium}" use-attribute-sets="text.medium">
	You can view your published group discussion in the 'Group's space'.<br/>
	<div class="arrow2"><a href="{$root}G{/H2G2/CLUB/CLUBINFO/@ID}">go to this group's space</a></div>
	</xsl:element>
	</td>
	</tr>
	</table>
	</xsl:element>
	</xsl:when>
	</xsl:choose>	
	</div>
	</xsl:with-param>
	</xsl:call-template>
</xsl:variable>


<!-- /////////////////////////////// -->
<!-- TAB LAYOUT TEMPLATE -->
<xsl:template name="TABLAYOUT">
<xsl:param name="tabimagesource" />
<xsl:param name="tabimageheight" />
<xsl:param name="tabimagewidth" />
<xsl:param name="tabimagealt" />
<xsl:param name="tabbody" />
<xsl:param name="tabbodyextra" />
<xsl:param name="tabbodyfooter" />

<div class="markerInnerBox">
<table width="595" border="0" cellspacing="0" cellpadding="0">
<tr>
	<td valign="top"><img src="{$graphics}{$tabimagesource}" alt="{$tabimagealt}" width="{$tabimagewidth}" height="{$tabimageheight}" border="0"/></td>
	<td width="80%" valign="top"><div class="markerInnerText"><xsl:copy-of select="$tabbody" /></div></td>
</tr>
<tr>
<td colspan="2">
<xsl:copy-of select="$tabbodyextra" />
</td>
</tr>
</table>
</div>
<xsl:copy-of select="$tabbodyfooter" />

</xsl:template>

</xsl:stylesheet>
