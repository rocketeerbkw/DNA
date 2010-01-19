<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
	<!ENTITY space "<xsl:text xmlns:xsl='http://www.w3.org/1999/XSL/Transform'> </xsl:text>">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">

<xsl:variable name="m_complainttext">
Disclaimer<br/>
Most of the content on BBC Get Writing is created by BBC Get Writing Members, who are members of the public. The views expressed are theirs and unless specifically stated are not those of the BBC. The BBC is not responsible for the content of any external sites referenced. If you consider anything on this page to be in breach of the site's <a href="{$root}HouseRules">House Rules</a>, please <a href="{$url_complain}">click here</a>.
</xsl:variable>

<xsl:variable name="test_UserHasEditorial" select="/H2G2/RECENT-APPROVALS/ARTICLE-LIST/ARTICLE[SITEID=15]"/>
	<xsl:variable name="smileylist">smiley, biggrin, cool, sadface, winkeye, doh, ok, tongueout, yawn, zzz, wow, hangover, cross, hug, blush, headhurts, grr, drunk, erm, silly, disco,</xsl:variable>
	<xsl:variable name="sidenavbaritems">
		<category name="2020 Diary" href="{$root}diary"/>
		<category name="Arts" href="{$root}arts"/>
		<category name="Body &amp; mind" href="{$root}body"/>
		<category name="Environment" href="{$root}environment"/>
		<category name="Leisure &amp; sport" href="{$root}leisure"/>
		<category name="Love" href="{$root}love"/>
		<category name="Politics &amp; society" href="{$root}politics"/>
		<category name="Pop culture" href="{$root}pop"/>
		<category name="Science" href="{$root}science"/>
		<category name="Spirituality" href="{$root}spirituality"/>
		<category name="Work &amp; study" href="{$root}work"/>
		<category name="Odd" href="{$root}odd"/>
	</xsl:variable>
	<!-- generic terms -->
	<xsl:variable name="m_user">Writer</xsl:variable>
	<xsl:variable name="m_users">Writers</xsl:variable>
	<xsl:variable name="m_usera"> a </xsl:variable>
	<xsl:variable name="m_article">Work</xsl:variable>
	<xsl:variable name="m_articles">Works</xsl:variable>
	<xsl:variable name="m_articlea"> a </xsl:variable>
	<xsl:variable name="m_articleurl">Works</xsl:variable>
	<xsl:variable name="m_editedarticle">Edited Article</xsl:variable>
	<xsl:variable name="m_editedarticles">Edited Articles</xsl:variable>
	<xsl:variable name="m_editedarticlea"> an </xsl:variable>
	<xsl:variable name="m_editedguide">Edited Site</xsl:variable>
	<xsl:variable name="m_nomembers">no articles</xsl:variable>
	<xsl:variable name="m_member"> works</xsl:variable>
	<xsl:variable name="m_members"> works</xsl:variable>
	<xsl:variable name="m_posting">Posting</xsl:variable>
	<xsl:variable name="m_postings">Postings</xsl:variable>
	<xsl:variable name="m_postinga"> a </xsl:variable>
	<xsl:variable name="m_postingurl">Posting</xsl:variable>
	<xsl:variable name="m_thread">conversation</xsl:variable>
	<xsl:variable name="m_threads">conversations</xsl:variable>
	<xsl:variable name="m_threada"> a </xsl:variable>
	<xsl:variable name="m_threadurl">Conversation</xsl:variable>
	<xsl:variable name="m_forum">Conversation Forum</xsl:variable>
	<xsl:variable name="m_forums">Conversation Forums</xsl:variable>
	<xsl:variable name="m_foruma"> a </xsl:variable>
	<xsl:variable name="m_nosuchguideentry">No Such <xsl:value-of select="$m_article"/>
	</xsl:variable>
	
	<!-- my space conversations -->
	<xsl:variable name="m_noposting">no posting</xsl:variable>
	<xsl:variable name="m_postedcolon">my last post:</xsl:variable>
	<xsl:variable name="m_lastreply">latest reply:</xsl:variable>
	<xsl:variable name="m_newestpost">latest reply:</xsl:variable>
	<xsl:variable name="m_noreplies">latest reply: no replies</xsl:variable>
	
	
	<!-- end of messages -->
	<xsl:variable name="alt_register">REGISTER</xsl:variable>
	<xsl:variable name="alt_login">SIGN IN</xsl:variable>
	<xsl:variable name="alt_logout">SIGN OUT</xsl:variable>
	<xsl:variable name="alt_myspace">PERSONAL SPACE</xsl:variable>
	<xsl:variable name="alt_addentry">WRITE AN ENTRY </xsl:variable>
	<xsl:variable name="alt_dontpanic">HELP</xsl:variable>
	<xsl:variable name="alt_feedback">FEEDBACK</xsl:variable>
	<xsl:variable name="alt_go">GO</xsl:variable>
	<xsl:variable name="alt_whatdoyouthink">WHAT DO YOU THINK?</xsl:variable>
	<!-- <xsl:variable name="m_searchlink">SEARCH Book of the Future</xsl:variable> -->
	<xsl:variable name="alt_viewallvisions">VIEW ALL ENTRIES</xsl:variable>
	<xsl:variable name="alt_tellusyourvision">WRITE AN ENTRY</xsl:variable>
	<xsl:variable name="alt_submittoreviewforumbutton">SUBMIT <xsl:value-of select="translate($m_article,$lowercase,$uppercase)"/></xsl:variable>
	 <xsl:variable name="m_thefutureof">THE FUTURE OF</xsl:variable> 
	<xsl:variable name="na_addentry">addentry</xsl:variable>
	<xsl:variable name="m_editor">By</xsl:variable>
	<xsl:variable name="m_datecolon">Created: </xsl:variable>
	<xsl:variable name="m_deleteFromList">Delete from list</xsl:variable>
	<xsl:variable name="m_cantfind">Can't find what you're looking for?</xsl:variable>
	<xsl:variable name="alt_searchoncategorypage">Search</xsl:variable>
	<xsl:variable name="m_visionsboxdummytext">Links to other entries and websites will appear here.</xsl:variable>
	<xsl:variable name="m_bbcboxdummytext">Links to bbc.co.uk websites will appear here.</xsl:variable>
	<xsl:variable name="m_othersitesboxdummytext">Links to external websites will appear here.</xsl:variable>
	<xsl:variable name="alt_clickherehelpentry">
		<img src="{$imagesource}btn_createeditvision.gif" width="235" height="17" border="0" alt="Link to HOW TO CREATE AND EDIT YOUR ENTRY"/>
	</xsl:variable>
	<xsl:variable name="m_greetingshiker">Posting to a conversation...</xsl:variable>
	<xsl:variable name="m_notforreviewtext">Not to be shown to editor</xsl:variable>

	<xsl:variable name="m_content">Your Entry</xsl:variable>
	<xsl:variable name="alt_storethis">Link to ADD YOUR ENTRY</xsl:variable>
	<xsl:variable name="alt_previewhowlook">Link to PREVIEW YOUR ENTRY</xsl:variable>
	<xsl:variable name="m_loginname">Member name </xsl:variable>
	<xsl:variable name="m_bbcpassword">Password </xsl:variable>
	<xsl:variable name="m_confirmbbcpassword">Confirm password </xsl:variable>
	<xsl:variable name="m_emailaddr">Email address </xsl:variable>
	<xsl:variable name="messagehighlight">*</xsl:variable>
	<xsl:variable name="m_newloginbutton">SIGN IN</xsl:variable>
	<xsl:variable name="m_newregisterbutton">REGISTRATION</xsl:variable>
	<xsl:variable name="m_whereinprocess">where you are in the publishing process</xsl:variable>
	<xsl:variable name="m_backtouserpage">go back to my space without changing</xsl:variable>
	<xsl:variable name="m_prefintro">This is where you can make changes to your details.</xsl:variable>
	<xsl:variable name="m_changenickname">Change nickname</xsl:variable>
	<xsl:variable name="m_prefnickname">Your nickname appears next to all your posts</xsl:variable>
	<xsl:variable name="m_changeemail">Change email address</xsl:variable>
	<xsl:variable name="m_prefemail">Please check your email address is correct. This will be used ...</xsl:variable>
	<xsl:variable name="m_changepassword">Change password</xsl:variable>
	<xsl:variable name="m_preferencessubject">My details</xsl:variable>
	<xsl:variable name="m_submitreviewforumsubject">SUBMIT FOR REVIEW</xsl:variable>
	<xsl:variable name="m_rfintro">Listed here are the most recent Entries submitted for review:</xsl:variable>
	<xsl:variable name="m_editpost">Edit Posting</xsl:variable>
	<xsl:variable name="submittoreviewforumurl" select="concat($root, 'SubmitReviewForum?action=submitarticle&amp;h2g2id=', $test_ArticleH2G2ID, '&amp;reviewforumid=', $reviewforum, '&amp;response=Thanks%20for%20submitting%20your%20article%20to%20the%20editor.%20The%20best%20articles%20and%20conversations%20will%20be%20published%20in%20a%20book%20in%20Spring%202003!')"/>
	
	<xsl:variable name="m_loginfailed">Your password and member name have not been recognised. Make sure you haven't got the Caps Lock key on, and try again.</xsl:variable>
	<xsl:template name="m_regwaittransfer">
<table width="433" border="0" cellspacing="0" cellpadding="5">

<tr>
<td bgcolor="#C7C2B3"><font size="2" class="grey"><br/><b>Please wait while you are transferred to your 'My Portfolio'. 
<A xsl:use-attribute-sets="nm_regwaittransfer" href="{$root}U{NEWREGISTER/USERID}" class="white">Click here</A> if nothing happens after a few seconds.</b><br/>&nbsp;</font></td>
</tr>
</table>
		

	</xsl:template>
	<xsl:variable name="m_subscribedtoforum">You have now subscribed to this <xsl:choose>
			<xsl:when test="/H2G2/RETURN-TO[starts-with(URL, 'RF')]">review circle</xsl:when>
			<xsl:otherwise><xsl:value-of select="$m_forum"/></xsl:otherwise>
		</xsl:choose>. The 'Recent <xsl:value-of select="$m_threads"/>' list in your 'My Portfolio' will show you when new <xsl:value-of select="$m_threads"/> are started.</xsl:variable>
	
	
	<xsl:template name="m_unregistereduserediterror">
	<table cellpadding="10" cellspacing="0"  border="0"><tr><td><font size="2" class="grey">
	<P>"The Get Writing community has now closed.  This means you can no longer post or edit work online, or take part in the Talk area.  If you would like to access your personal space to remove work from the site or re-live those lively debates, you can <a xsl:use-attribute-sets="nm_unregistereduserediterror1" href="{$sso_noarticlesigninlink}">sign in here.</a></P>
	

<p>We don't recommend you create a new membership here. However, you can still hold onto and use your BBCi membership created for Get Writing in several other bbc.co.uk areas. Why not check out:</p></font></td></tr></table>
<UL>
<LI><a href="http://www.bbc.co.uk/dna/h2g2">H2g2</a> - The guide to Life, the Universe and Everything.</LI>
<LI><a href="http://www.bbc.co.uk/dna/collective">Collective</a> - exchanging views on new music, film and culture </LI>
<LI><a href="http://www.bbc.co.uk/dna/ww2">People's War</a>- share your wartime stories or family history</LI>

</UL>
		<!-- <P>We're sorry, but you can't create or edit <xsl:value-of select="$m_articles"/> until you've logged in.</P> -->
		<!-- <UL>
			<LI>
				<P>If you already have an account, please <b><A xsl:use-attribute-sets="nm_unregistereduserediterror1" href="{$sso_noarticlesigninlink}">click here to sign in</A></b>.</P>
			</LI> -->
			<!-- <LI>
				<P>If you haven't already registered with us as a 
<xsl:value-of select="$m_user"/>, please <b><A xsl:use-attribute-sets="nm_unregistereduserediterror2" HREF="{$sso_noarticleregisterlink}">click here to register</A></b>. Registering is free and will enable you to share your wisdom with the rest of the Community. <b><a xsl:use-attribute-sets="nm_unregistereduserediterror3" href="{$root}help">Tell me more!</a></b>.</P>
			</LI> -->
		<!-- </UL> -->
	</xsl:template>
	
	<!-- friends -->
	<xsl:variable name="m_namesonyourfriendslist"></xsl:variable>
	<xsl:variable name="URL_dis">
			<xsl:choose>
				<xsl:when test="number(/H2G2/ARTICLE/ARTICLEINFO/H2G2ID) > 0">'<xsl:value-of select="$root"/>UserComplaint?h2g2ID=<xsl:value-of select="/H2G2/ARTICLE/ARTICLEINFO/H2G2ID"/>'</xsl:when>
				<xsl:otherwise>'<xsl:value-of select="$root"/>UserComplaint?URL=' + escape(window.location.href)</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
	<xsl:variable name="m_noconnectionerror"></xsl:variable>
	<!-- this is the message that is displayed after a login/registration started from the UserEdit page. -->
	<xsl:template name="m_ptwriteguideentry">
		<b><a xsl:use-attribute-sets="nm_ptwriteguideentry" href="{$root}UserEdit">Click here to write your <xsl:value-of select="$m_article"/></a><br/><br/></b>
	</xsl:template>
	<xsl:variable name="m_ArticleCopyText">
		<table cellpadding="5" cellspacing="0" border="0" width="100%">
			
			<tr>
				<td colspan="2">
					<font size="2" class="grey">
						<b>Your <xsl:value-of select="$m_article"/> is now on the site</b>
					</font>
				</td>
			</tr>
			<tr>
				
				<td >
					<font size="2" class="grey">You can edit your <xsl:value-of select="$m_articles"/> at any time via your <br/><b><a href="{$root}U{$test_ViewingUserNumber}" class="grey">My Portfolio</a></b>
					</font>
				</td>
			</tr>
		</table>
	</xsl:variable>
	<xsl:variable name="m_firsttotalk">Click below to be the first person to discuss this <xsl:value-of select="$m_article"/>
	</xsl:variable>
	<!-- <xsl:variable name="m_addguideentry">Save to website</xsl:variable> -->
	<xsl:variable name="m_addguideentry">Update Entry</xsl:variable>
	<xsl:variable name="m_returntoconv">Return to the <xsl:value-of select="$m_thread"/> without posting</xsl:variable>
	<xsl:variable name="m_returntoentry">Return to the <xsl:value-of select="$m_article"/> without posting</xsl:variable>
	<xsl:variable name="m_returntoforum">Return to the <xsl:value-of select="$m_forum"/> without posting</xsl:variable>
	<xsl:variable name="m_userintro">Write your entry here</xsl:variable>

	<!-- login -->
	 <xsl:variable name="m_oruserid">or <xsl:value-of select="$m_user"/> number </xsl:variable>
	<xsl:variable name="m_UserEditHouseRulesDiscl2">
		<table width="433" border="0" cellspacing="0" cellpadding="0">
			<tr>
			<td height="1"></td>
			</tr>
			</table>
			<table width="433" border="0" cellspacing="0" cellpadding="5">
			<tr>
			<td bgcolor="#E0DAC8"><font size="1" class="grey"><b class="white">TIPS</b><br/>
			&nbsp;<br />
			<img src="{$imagesource}bullet_black2.gif" width="9" height="8" border="0" alt="" />Keep it brief! If you want to make a point in depth, consider
			<a href="{$root}useredit" class="grey">Write a Works</a>.<br />
			&nbsp;<br />
			<img src="{$imagesource}bullet_black2.gif" width="9" height="8" border="0" alt="" />Please be very careful if you want to post an email address or instant
			messaging number, as you may receive lots of emails or messages.
			See <a href="{$root}houserules" class="grey">House Rules</a> for more information.<br />
			&nbsp;<br />
			<img src="{$imagesource}bullet_black2.gif" width="9" height="8" border="0" alt="" />You must be over 16 to post to this site.<br />
			 &nbsp;<br />
			<img src="{$imagesource}bullet_black2.gif" width="9" height="8" border="0" alt="" />Refer to websites by typing the full address (e.g. http://www.bbc.co.uk)<br />
			&nbsp;<br />
			<img src="{$imagesource}bullet_black2.gif" width="9" height="8" border="0" alt="" />Don't forget to follow the <a href="{$root}houserules" class="grey">House Rules</a>.<br />
			&nbsp;<br />
			<img src="{$imagesource}bullet_black2.gif" width="9" height="8" border="0" alt="" />See <a href="http://www.bbc.co.uk/copyright" class="grey">Terms of Use</a> for details on how we may use your Conversation.<br />
			&nbsp;<br />
			<img src="{$imagesource}bullet_black2.gif" width="9" height="8" border="0" alt="" />For more tips take a look at <a href="{$root}help" class="grey">Help</a>.<br />
			</font>
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
			<td height="7"></td>
			</tr>
			</table>
			</td>
			</tr>
			</table>
	</xsl:variable>
	
	<xsl:variable name="m_UserEditWarning">
		<table width="433" border="0" cellspacing="0" cellpadding="5">
		<tr>
		<td bgcolor="#E0DAC8"><font size="1" class="grey"><b class="white">TIPS</b><br />
		&nbsp;<br />
		<img src="{$imagesource}bullet_black2.gif" width="9" height="8" border="0" alt="" />Your content will appear on the Website once you have selected 'Save'.<br />
		Once you've saved your entry you can still change it using the Edit option<br />
		&nbsp;<br />
		<img src="{$imagesource}bullet_black2.gif" width="9" height="8" border="0" alt="" />Please be very careful if you want to post an email address or instantmessaging numbers, as you mayreceive lots of emails or messages.See House Rules for more information.<br />
		&nbsp;<br />
		<img src="{$imagesource}bullet_black2.gif" width="9" height="8" border="0" alt="" />You must be be over 16 to post to this site<br />
		&nbsp;<br />
		<img src="{$imagesource}bullet_black2.gif" width="9" height="8" border="0" alt="" />Refer to websites by typing the full address (e.g. http://www.bbc.co.uk)<br />
		&nbsp;<br />
		<img src="{$imagesource}bullet_black2.gif" width="9" height="8" border="0" alt="" />Don't forget to follow the <a href="{$root}houserules" class="grey">House Rules</a><br />
		&nbsp;<br />
		<img src="{$imagesource}bullet_black2.gif" width="9" height="8" border="0" alt="" />See <a href="http://www.bbc.co.uk/copyright" class="grey">Terms of Use</a> for details on how we may use your Works<br />
		&nbsp;<br />
		<img src="{$imagesource}bullet_black2.gif" width="9" height="8" border="0" alt="" />For more tips take a look at <a href="{$root}help" class="grey">Help</a><br />
		</font>
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
		<td height="7"></td>
		</tr>
		</table>
		</td>
		</tr>
		</table>
		
	</xsl:variable>  
	<xsl:variable name="m_cta">Think you know the future? Tell us and you could be published.</xsl:variable> 
	<!-- <xsl:variable name="m_allconvs">View more conversations (total [<xsl:value-of select="$test_ArticleTotalThreads"/>])</xsl:variable> -->
	<xsl:variable name="m_allconvs">More Conversations - total [<xsl:value-of select="$test_ArticleTotalThreads"/>]</xsl:variable>

<!--  Submit for review -->
	<xsl:variable name="m_entrysubmittoreviewforumsubject">
		<xsl:value-of select="$m_article"/> successfully submitted to the Editor's Desk</xsl:variable>
	<xsl:variable name="m_removefromreviewforumsubject">
		<xsl:value-of select="$m_article"/> Successfully Removed from the Editor's Desk</xsl:variable>
	<xsl:template name="m_submitforreviewbutton">
		submit for review
	</xsl:template>
	<xsl:template name="m_currentlyinreviewforum">
		Your work is in: 
	</xsl:template>
	<xsl:template name="m_submittedtoreviewforumbutton">
		<xsl:value-of select="REVIEWFORUM/FORUMNAME"/>
	</xsl:template>
	<xsl:variable name="m_srfinitialtext">
		Use this form to submit 
		<strong>
		<a href="A{/H2G2/SUBMIT-REVIEW-FORUM/ARTICLE/@H2G2ID}">
		<xsl:value-of select="/H2G2/SUBMIT-REVIEW-FORUM/ARTICLE"/>
		</a>
		</strong> 
		for review
		<br/>
		<br/>
		please read the review circle introduction before using this form
		* short stories - ipsum lorem dorem <br/>
		* short stories - ipsum lorem dorem <br/>
		* short stories - ipsum lorem dorem <br/>
		* short stories - ipsum lorem dorem <br/>
		* short stories - ipsum lorem dorem <br/>
		* short stories - ipsum lorem dorem <br/>
	</xsl:variable>
	
	
	<xsl:template name="m_welcomebackuser">
		<b>Username:</b>
		&space;<a href="{$root}U{$test_ViewingUserNumber}">
			<xsl:value-of select="$test_ViewingUsername"/>
		</a>
		<!--xsl:if test="string-length($test_ViewingUsername) &gt; 20">..</xsl:if-->
	</xsl:template>
	<xsl:template name="bottom-disclaimer">
		
		
	</xsl:template>
	 <xsl:variable name="m_registertodiscuss"></xsl:variable>
	<!--<xsl:template name="m_bbcregblurb">
		<font size="1">This is where you register with [i] on  the Future. If you are already registered please use the <a href="{$root}login" class="vlink">
				<b>LOGIN</b>
			</a> page.<br/>
			<br/>
			You need to register to be able to post your comments to a conversation or submit an entry to the site. You can also be updated on new additions to the site.  It won't take long and once you've registered you only have to login when you come to the site. 
</font>
	</xsl:template> -->
	<!-- <xsl:template name="m_bbcregblurb2">
		<font size="1">
			When inputting a username please choose something that is unusual or add some numbers to a word that may be in common use.  As all the usernames are unique the most obvious one's, like "jimbob" are already being used.  If you wanted to use "jimbob" you'd have to add some numbers, for example "jimbob909". 

If you have any problems contact us at <b>
				<a href="mailto:onthefuture.feedback@bbc.co.uk">onthefuture.feedback@bbc.co.uk</a>
			</b>.

Enjoy looking into the future!" 
<br/>
			<br/>
		Your login name and password must both have at least 6 characters and no spaces.<br/>
Please read and agree to the <b>
				<a xsl:use-attribute-sets="nm_bbcregblurb3" href="http://www.bbc.co.uk/copyright">Terms of Use</a>
			</b> [you need to agree to the terms of use to register].</font>
		<br/>
	</xsl:template> -->
	<xsl:template name="m_bbcregblurb3">
		<font size="1">Your registration will allow us to:<br/>
			<ul class="black">
				<li>Verify your access to bbc.co.uk services wich require registration</li>
				<li>Personalise your experience on bbc.co.uk</li>
			</ul>
		</font>
	</xsl:template>
	<xsl:template name="m_bbcloginblurb">
		<font size="1" class="grey">
			This is where you can sign in to Get Writing. You need to 
			<a class="grey" xsl:use-attribute-sets="nm_bbcloginblurb">
				<xsl:call-template name="regpassthroughhref">
					<xsl:with-param name="url">register</xsl:with-param>
				</xsl:call-template>
				register
			</a>
			 before you can sign in. 
		 </font>
<!--
		<font size="2">This is where you can log in to Talk London. You need to <b>
				<a xsl:use-attribute-sets="nm_bbcloginblurb">
					<xsl:call-template name="regpassthroughhref">
						<xsl:with-param name="url">register</xsl:with-param>
					</xsl:call-template>register</a>
			</b> before you can login.</font>
-->
		<!--P>This is where you can log in to <xsl:value-of select="$sitedisplayname"/> (if you want to create a new account, first you need to <a xsl:use-attribute-sets="nm_bbcloginblurb">
				<xsl:call-template name="regpassthroughhref">
					<xsl:with-param name="url">Register</xsl:with-param>
				</xsl:call-template>register</a>). Please note you need to have cookies enabled in your browser for this to work.</P>
		<P>To log in, simply enter your BBC login name (<I>not</I> your Nickname) and your BBC password. <B>Your BBC login name and password are case sensitive.</B> If you have a BBC account but you haven't logged in to <xsl:value-of select="$sitedisplayname"/> before, you may be asked to retype your password and accept our Terms and Conditions.</P-->
	</xsl:template>
	<xsl:template name="m_bbcloginblurb2">
		<font size="1" class="grey">
			Your member name and password are case sensitive.
		</font>
	</xsl:template>
	<xsl:template name="m_bbcloginblurb2a">
		<font size="1" class="grey">
			If you have 
<!--				<a xsl:use-attribute-sets="nm_bbcloginblurb" href="{$root}UserDetails?unregcmd=yes">forgotten your password</a> -->
			<a class="grey" xsl:use-attribute-sets="nm_bbcloginblurb" href="{$root}UserDetails?unregcmd=yes">forgotten your password</a>,
			then we can email you a new one.
		</font>
	</xsl:template>
	<xsl:template name="m_bbcloginblurb3">
<!--
		<font size="1">Having problems? See our <B><a href="faq">Frequently Asked Questions</a></B> or <B><a href="mailto:yourlondon@bbc.co.uk">email us</a></B>. We'll contact you as soon as we can. </font>
-->
		<font size="1" class="grey">
			Having problems? See our <a href="/help" class="grey">Help page</a>.
		</font>	
	</xsl:template>
	<xsl:template name="m_agreetoterms">I agree to the <!--A xsl:use-attribute-sets="nm_agreetoterms1" HREF="{$root}HouseRules">House Rules</A> and the -->
<!--		<a xsl:use-attribute-sets="nm_agreetoterms2" href="http://www.bbc.co.uk/copyright">-->
		<a href="http://www.bbc.co.uk/copyright">
			Terms of Use
		</a> and <a href="houserules">House Rules</a>
	</xsl:template>
	<xsl:template name="m_forgottenpassport">
		<b>
			<a xsl:use-attribute-sets="nm_bbcloginblurb" href="{$root}UserDetails?unregcmd=yes">Forgotten your password?</a>
		</b> We`ll email you one.</xsl:template>
	<xsl:template name="m_uddetailsupdated">
		<xsl:choose>
			<xsl:when test="$test_ChangeNickname">your nickname has been changed to <xsl:value-of select="/H2G2/USER-DETAILS-FORM/USERNAME"/>.</xsl:when>
			<xsl:when test="$test_ChangeEmail">your email address has been changed to <xsl:value-of select="/H2G2/USER-DETAILS-FORM/EMAIL-ADDRESS"/>.</xsl:when>
			<xsl:when test="$test_ChangePassword">your password has been changed successfully.</xsl:when>
		</xsl:choose>
		<!-- Your details have been updated -->
	</xsl:template>
	<xsl:template name="m_submitarticlefirst_text">A<xsl:value-of select="/H2G2/SUBMIT-REVIEW-FORUM/ARTICLE/@H2G2ID"/> - <b>
			<xsl:value-of select="/H2G2/SUBMIT-REVIEW-FORUM/ARTICLE"/>
		</b>
	</xsl:template>
	<xsl:template name="m_submitarticlefirst_text2">To put this <xsl:value-of select="$m_article"/> into review, select the relevant Review Forum and enter your comments below.
</xsl:template>
<xsl:template name="m_guideentrydeleted">
Your <xsl:value-of select="$m_article"/> has been deleted. If you want to restore any deleted <xsl:value-of select="$m_articles"/> you can view them 
<a use-attribute-sets="nm_guideentrydeleted"><xsl:attribute name="href">MA<xsl:value-of select="USERID"/>&amp;type=3</xsl:attribute>on this page</a>.
</xsl:template>

	<xsl:template name="m_guideentryrestored">
		Your <xsl:value-of select="$m_article"/>
		<xsl:text> </xsl:text>
		<a xsl:use-attribute-sets="nm_guideentryrestored1" href="{$root}A{H2G2ID}">
			<xsl:apply-templates select="SUBJECT" mode="nosubject"/>
		</a> has been restored. 
		If you wish to edit this <xsl:value-of select="$m_article"/><xsl:text>  </xsl:text> 
		<a href="{$root}TypedArticle?aedit=new&amp;type={$current_article_type}&amp;h2g2id={H2G2ID}">click here
		</a>
	</xsl:template>

	<xsl:template name="m_logoutblurb">
		<font class="grey" size="1">You have just logged out. The next time you visit on this computer we won't automatically recognise you.<br/>&nbsp;<br/>
	To sign in again, <b><a href="{$sso_signinlink}" class="white">click here</a></b>.</font>
	</xsl:template>
	<xsl:template name="m_notfoundbody">We're sorry, but the page you have requested does not exist. 
This could be because the URL<A xsl:use-attribute-sets="nm_notfoundbody1" TITLE="That's the address of the web page that we can't find - it should begin with http://www.bbc.co.uk{$root}" NAME="back1" HREF="#footnote1">
			<SUP>1</SUP>
		</A> is wrong, 
or because the page you are looking for has been removed from the Site.<br/>&nbsp;<br/>
		We apologise for this interruption in your surfing, and hope the tide comes back in soon.<br/>&nbsp;<br/>
		<blockquote>
			<font size="-1">
				<hr/>
				<A NAME="footnote1">
					<A xsl:use-attribute-sets="nm_notfoundbody2" HREF="#back1">
						<SUP>1</SUP>
					</A> 
That's the address of the web page that we can't find - it should begin with 
http://www.bbc.co.uk<xsl:value-of select="$root"/>
				</A>
			</font>
		</blockquote>
	</xsl:template>
	<xsl:template name="m_removefromreviewforum">X</xsl:template>	
	<xsl:variable name="m_clickmorereviewentries">More <xsl:value-of select="$reviewcirclename" /> work in review</xsl:variable>
	<xsl:template name="m_rft_selectlastposted">
		<b>
			<i>LATEST POST</i>
		</b>
	</xsl:template>
	<xsl:template name="m_rft_lastposted">
		<b>LATEST POST</b>
	</xsl:template>
	<xsl:template name="m_rft_selectdateentered">
		<b>
			<i>DATE ENTERED</i>
		</b>
	</xsl:template>
	<xsl:template name="m_rft_dateentered">
		<b>DATE ENTERED</b>
	</xsl:template>
	<xsl:template name="m_rft_selectauthor">
		<b>
			<i>AUTHOR</i>
		</b>
	</xsl:template>
	<xsl:template name="m_rft_author">
		<b>AUTHOR</b>
	</xsl:template>
	<xsl:template name="m_rft_selecth2g2id">
		<b>
			<i>ID</i>
		</b>
	</xsl:template>
	<xsl:template name="m_rft_h2g2id">
		<b>ID</b>
	</xsl:template>
	<xsl:template name="m_rft_subject">
		<b>TITLE</b>
	</xsl:template>
	<xsl:template name="m_rft_selectsubject">
		<b>
		<i>TITLE</i>
		</b>
	</xsl:template>
	<xsl:template name="m_rft_selectauthorid">
		<b>
			<i>AUTHOR ID</i>
		</b>
	</xsl:template>
	<xsl:template name="m_rft_authorid">
		<b>AUTHOR ID</b>
	</xsl:template>
	<xsl:template name="m_entrysubmittedtoreviewforum"></xsl:template>

	<xsl:template name="m_cantpostnotregistered">
		<p>Hi, you need to become a member before you can post to <xsl:value-of select="$m_threada"/>
			<xsl:value-of select="$m_thread"/>.</p>
		<UL>
			<LI>
				<P>If you already have an account, please <b><A xsl:use-attribute-sets="nm_cantpostnotregistered1" href="{$sso_nopostsigninlink}">click here to sign in</A></b>.</P>
			</LI>
			<LI>
				<P>If you haven't already registered with us as <xsl:value-of select="$m_usera"/>
					<xsl:value-of select="$m_user"/>, please <b><A xsl:use-attribute-sets="nm_cantpostnotregistered2" href="{$sso_nopostregisterlink}">click here to become a member</A></b>. Registering is free and will enable you to share your wisdom with the rest of the Community. <b><a xsl:use-attribute-sets="nm_cantpostnotregistered3" href="A387317">Tell me more!</a></b>.</P>
			</LI>
		</UL>
		<P>Alternatively, <b><A xsl:use-attribute-sets="nm_cantpostnotregistered4">
				<xsl:attribute name="href"><xsl:value-of select="$root"/>F<xsl:value-of select="@FORUMID"/>?thread=<xsl:value-of select="@THREADID"/>&amp;post=<xsl:value-of select="@POSTID"/>#p<xsl:value-of select="@POSTID"/></xsl:attribute>click here to return to the <xsl:value-of select="$m_thread"/> without logging in</A></b>.</P>
	</xsl:template>
		
	<xsl:variable name="m_alwaysremember">Always remember my password on this computer</xsl:variable>
	
<!-- Fonts -->

	<xsl:variable name="text.headinglarge">font</xsl:variable>
		<xsl:attribute-set name="text.headinglarge">
		<xsl:attribute name="size">6</xsl:attribute>
		<xsl:attribute name="class">headinglarge</xsl:attribute>
	</xsl:attribute-set>

	<xsl:variable name="text.heading">font</xsl:variable>
		<xsl:attribute-set name="text.heading">
		<xsl:attribute name="size">4</xsl:attribute>
		<xsl:attribute name="class">heading</xsl:attribute>
	</xsl:attribute-set>

	<xsl:variable name="text.subheading">font</xsl:variable>
		<xsl:attribute-set name="text.subheading">
		<xsl:attribute name="size">3</xsl:attribute>
		<xsl:attribute name="class">subheading</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:variable name="text.base">font</xsl:variable>
		<xsl:attribute-set name="text.base">
		<xsl:attribute name="size">2</xsl:attribute>
		<xsl:attribute name="class">base</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:variable name="text.medium">font</xsl:variable>
		<xsl:attribute-set name="text.medium">
		<xsl:attribute name="size">1</xsl:attribute>
		<xsl:attribute name="class">medium</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:variable name="text.small">font</xsl:variable>
		<xsl:attribute-set name="text.small">
		<xsl:attribute name="size">1</xsl:attribute>
		<xsl:attribute name="class">small</xsl:attribute>
	</xsl:attribute-set>
	
<!-- Tables -->

<xsl:attribute-set name="html.table.container">
	<xsl:attribute name="width">
	<xsl:choose>
		<xsl:when test="/H2G2/PARAMS/PARAM[NAME= 's_print']/VALUE = 1">550</xsl:when>
		<xsl:otherwise>625</xsl:otherwise>
	</xsl:choose>
	</xsl:attribute>
	<xsl:attribute name="border">0</xsl:attribute>
	<xsl:attribute name="cellpadding">0</xsl:attribute>
	<xsl:attribute name="cellspacing">0</xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="html.table.user.container">
	<xsl:attribute name="width">605</xsl:attribute>
	<xsl:attribute name="border">0</xsl:attribute>
	<xsl:attribute name="cellpadding">0</xsl:attribute>
	<xsl:attribute name="cellspacing">0</xsl:attribute>
</xsl:attribute-set>

<!-- columns -->
<xsl:attribute-set name="column.1">
		<xsl:attribute name="valign">top</xsl:attribute>
		<xsl:attribute name="width">
		<xsl:choose>
		<xsl:when test="/H2G2/PARAMS/PARAM[NAME= 's_print']/VALUE = 1">550</xsl:when>
		<xsl:otherwise>410</xsl:otherwise>
		</xsl:choose>
		</xsl:attribute>
		<xsl:attribute name="class">
		<xsl:choose>
		<xsl:when test="/H2G2/PARAMS/PARAM[NAME= 's_print']/VALUE = 1">page-column-print</xsl:when>
		<xsl:otherwise>page-column-1</xsl:otherwise>
		</xsl:choose>
		</xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="column.1.user">
		<xsl:attribute name="valign">top</xsl:attribute>
		<xsl:attribute name="width">390</xsl:attribute>
		<xsl:attribute name="class">page-column-1-user</xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="column.1a">
		<xsl:attribute name="valign">top</xsl:attribute>
		<xsl:attribute name="width">625</xsl:attribute>
		<xsl:attribute name="class">page-column-1a</xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="column.2">
		<xsl:attribute name="valign">top</xsl:attribute>
		<xsl:attribute name="width">215</xsl:attribute>
		<xsl:attribute name="class">page-column-2</xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="column.3">
		<xsl:attribute name="width">10</xsl:attribute>
		<xsl:attribute name="class">page-column-3</xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="column.4">
		<xsl:attribute name="valign">top</xsl:attribute>
		<xsl:attribute name="width">615</xsl:attribute>
		<xsl:attribute name="class">page-column-4</xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="column.spacer.1">
		<xsl:attribute name="width">300</xsl:attribute>
		<xsl:attribute name="height">1</xsl:attribute>
		<xsl:attribute name="border">0</xsl:attribute>
		<xsl:attribute name="src">/t/f.gif</xsl:attribute>
		<xsl:attribute name="alt"></xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="column.spacer.2">
		<xsl:attribute name="width">195</xsl:attribute>
		<xsl:attribute name="height">1</xsl:attribute>
		<xsl:attribute name="border">0</xsl:attribute>
		<xsl:attribute name="src">/t/f.gif</xsl:attribute>
		<xsl:attribute name="alt"></xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="column.spacer.3">
		<xsl:attribute name="width">10</xsl:attribute>
		<xsl:attribute name="height">1</xsl:attribute>
		<xsl:attribute name="border">0</xsl:attribute>
		<xsl:attribute name="src">/t/f.gif</xsl:attribute>
		<xsl:attribute name="alt"></xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="column.spacer.4">
		<xsl:attribute name="width">615</xsl:attribute>
		<xsl:attribute name="height">1</xsl:attribute>
		<xsl:attribute name="border">0</xsl:attribute>
		<xsl:attribute name="src">/t/f.gif</xsl:attribute>
		<xsl:attribute name="alt"></xsl:attribute>
</xsl:attribute-set>

<!-- groups -->
<xsl:variable name="m_editclub">edit group intro</xsl:variable>
<xsl:variable name="m_joinclub">Apply for membership</xsl:variable>
<xsl:variable name="m_clublastposting">Posted</xsl:variable>
<xsl:variable name="m_clubjournaltitle">GROUP DISCUSSION</xsl:variable>
<xsl:variable name="m_discussclubjournalentry">reply</xsl:variable>
<xsl:variable name="m_complainclubjournal"><img src="{$graphics}icons/icon_complain.gif" alt="complain about this page" width="24" height="22" border="0" /></xsl:variable>
<xsl:variable name="m_clickaddclubjournal">start discussion</xsl:variable>
<xsl:variable name="m_latestreply">read more</xsl:variable>
	<xsl:template name="noClubJournalReplies">
		no replies
	</xsl:template>
<xsl:variable name="m_clickmoreclubjournal">previous discussion</xsl:variable>
<xsl:variable name="m_editmembership">group admin</xsl:variable>
<xsl:variable name="m_teamlisttitle">edit member status</xsl:variable>
<xsl:variable name="m_pendingrequests">member pending approval</xsl:variable>
<xsl:variable name="m_completedrequests">recent membership action</xsl:variable>
<!-- <xsl:variable name="m_clubsummarytitle">ALL</xsl:variable> -->
<xsl:variable name="m_statustitle">my status</xsl:variable>
<xsl:variable name="m_viewclublink">go to this group's space</xsl:variable>
<xsl:variable name="m_pendingtitle">members pending</xsl:variable>
<xsl:variable name="m_completedtitle">Recent Activity</xsl:variable>
<xsl:variable name="m_changestatus">change</xsl:variable>
<xsl:variable name="m_editmembers_owner">owner <br/> <img src="{$graphics}icons/icon_owner.gif"  border="0" /></xsl:variable>
<xsl:variable name="m_editmembers_member">member</xsl:variable>


<xsl:variable name="m_removeowner">remove from group</xsl:variable>
<xsl:variable name="m_demoteownertomember">step down as owner</xsl:variable>
<xsl:variable name="m_promoteowner">promote to owner</xsl:variable>
<xsl:variable name="m_removemember">remove from group</xsl:variable>

<xsl:variable name="m_joinmemberrequest">Request to be member </xsl:variable>
<xsl:variable name="m_joinownerrequest">Request to be owner </xsl:variable>
<xsl:variable name="m_invitedowner">Invited to be owner</xsl:variable>
<xsl:variable name="m_invitedmember">Invited to be member</xsl:variable>
<xsl:variable name="m_joinmember3rdperson">Request to be member</xsl:variable>
<xsl:variable name="m_joinownerviewer3rdperson">Request to be owner</xsl:variable>
<xsl:variable name="m_invitemember3rdperson">Invited to be member</xsl:variable>
<xsl:variable name="m_inviteowner3rdperson">Invited to be owner</xsl:variable>
<xsl:variable name="m_ownerresignsmember3rdperson">Stepped down as owner</xsl:variable>
<xsl:variable name="m_ownerresignscompletely3rdperson">Stepped down as owner</xsl:variable>
<xsl:variable name="m_memberresigns3rdperson">Left the group</xsl:variable>
<xsl:variable name="m_demoteownertomember3rdperson">Demoted to member</xsl:variable>
<xsl:variable name="m_removeowner3rdperson">Removed from group</xsl:variable>
<xsl:variable name="m_removemember3rdperson">Removed from group</xsl:variable>

<xsl:variable name="m_joinmember2ndperson">join </xsl:variable>
<xsl:variable name="m_joinowner2ndperson">join </xsl:variable>
<xsl:variable name="m_invitemember2ndperson">invited to join </xsl:variable>
<xsl:variable name="m_inviteowner2ndperson">invited to own </xsl:variable>
<xsl:variable name="m_ownerresignsmember2ndperson">left </xsl:variable>
<xsl:variable name="m_ownerresignscompletely2ndperson">left </xsl:variable>
<xsl:variable name="m_memberresigns2ndperson">left </xsl:variable>
<xsl:variable name="m_demoteownertomember2ndperson">demoted </xsl:variable>
<xsl:variable name="m_removeowner2ndperson">removed from </xsl:variable>
<xsl:variable name="m_removemember2ndperson">removed from </xsl:variable>


<!-- conversations -->

<xsl:variable name="m_posted">posted by</xsl:variable>
<xsl:variable name="m_postedsoon">Posted: soon</xsl:variable>
<xsl:variable name="m_fsubject">SUBJECT</xsl:variable>
<xsl:variable name="m_textcolon">MESSAGE</xsl:variable>
<xsl:variable name="alt_myconversations">launch pop up</xsl:variable>
<xsl:variable name="alt_nonewerpost">latest post</xsl:variable>
<xsl:variable name="alt_showingoldest">first post</xsl:variable>
<xsl:variable name="m_noolderconv">previous</xsl:variable>
<xsl:variable name="alt_showoldestconv">first post</xsl:variable>
<xsl:variable name="alt_shownewest">latest post</xsl:variable>
<xsl:variable name="alt_shownext">next</xsl:variable>
<xsl:variable name="alt_showprevious">previous</xsl:variable>
<xsl:variable name="alt_nonewconvs">next</xsl:variable>
<xsl:variable name="m_replytothispost">add comment</xsl:variable>
<xsl:variable name="alt_complain"><img src="{$graphics}icons/icon_complain.gif" alt="complain about this page" width="24" height="22" border="0" /></xsl:variable>
<xsl:variable name="m_clickunsubscribe">remove from my <xsl:value-of select="$m_threads"/></xsl:variable>
<xsl:variable name="m_returntothreadspage">related <xsl:value-of select="$m_threads"/></xsl:variable>
<xsl:variable name="m_clicknotifynewconv">add to my conversations</xsl:variable>
<xsl:variable name="m_clickstopnotifynewconv">remove me from conversation</xsl:variable>
<xsl:variable name="m_peopletalking">Here are the most recent conversations about this entry:</xsl:variable>
<xsl:variable name="m_advicetext">Read the lastest advice here. You can share your views about each advivce comment by clicking the post title or add your own comments below.</xsl:variable>
<xsl:variable name="m_challenge">Read the lastest contributions to this challenge here. You can share your views about each advice comment by clicking the post title or add your own comments below.</xsl:variable>
<xsl:variable name="alt_discussthis">
<xsl:choose>
<xsl:when test="$article_type_group='creative'">
add your review
</xsl:when>
<xsl:when test="$article_type_group='advice'">
add your comments
</xsl:when>
<xsl:when test="$article_type_group='challenge'">
join the challenge
</xsl:when>
<xsl:when test="$article_subtype='talkpage'">
start '<xsl:value-of select="/H2G2/ARTICLE/SUBJECT" />' talk
</xsl:when>
<xsl:otherwise>add your comment</xsl:otherwise>
</xsl:choose>
</xsl:variable>

<!-- multiposts -->
<xsl:variable name="alt_showpostings">previous</xsl:variable>

<!-- threads -->
<xsl:variable name="m_postsubjectremoved">comment removed: breaks the <A xsl:use-attribute-sets="nm_postremoved" TARGET="_top" HREF="{$root}HouseRules">house rules</A></xsl:variable>
<xsl:template name="m_postremoved"></xsl:template>	
<xsl:variable name="m_messageisfrom">IN REPLY TO:</xsl:variable>

<!-- journal -->
<xsl:variable name="m_newerjournalentries">previous</xsl:variable>
<xsl:variable name="m_olderjournalentries">next</xsl:variable>
	<xsl:variable name="m_memberormy">
		<xsl:choose>
			<xsl:when test="$ownerisviewer=1">my</xsl:when>
			<xsl:otherwise>member's</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
<xsl:variable name="m_clickaddjournal">write new entry</xsl:variable>
<xsl:variable name="m_journalintroUI">this is the intro for the journal page</xsl:variable>
<xsl:variable name="m_clickmorejournal">view all my entries</xsl:variable>
<xsl:variable name="m_clickmoreconv">more conversations</xsl:variable>
<xsl:variable name="m_backtoresearcher">back to <xsl:value-of select="$m_user"/>'s personal space</xsl:variable>

<!-- userpage -->
<xsl:template name="m_journalownerfull"></xsl:template>
<xsl:template name="m_journalviewerfull"></xsl:template>
<xsl:variable name="m_clickmoreuserpageconv">see all my messages</xsl:variable>
<xsl:variable name="m_recentapprovals">editorial</xsl:variable>
<xsl:variable name="m_intro">intro</xsl:variable>
<xsl:variable name="m_recententries">my portfolio</xsl:variable>
<xsl:variable name="m_clickmoreentries">see all work in my portfolio</xsl:variable>
<xsl:variable name="m_mostrecentconv">my conversation</xsl:variable>
<xsl:variable name="m_usermyclubs">my groups</xsl:variable>
<xsl:variable name="m_recentarticlethreads">my messages and contacts</xsl:variable>
<xsl:variable name="m_friends">my contacts</xsl:variable>
<xsl:variable name="m_journal">my journal</xsl:variable>
<xsl:variable name="m_clickherediscuss">add comments</xsl:variable>
<xsl:variable name="m_nickname">ENTER MY NEW SCREEN NAME</xsl:variable>


<!-- userpage groups -->
<xsl:variable name="m_yourrequests">WAITING LISTS</xsl:variable>
<xsl:variable name="m_invitations">MEMBERSHIP OFFERS</xsl:variable>
<xsl:variable name="m_previousactions">MEMBERSHIP DECISIONS:</xsl:variable>

<!-- watched user -->
<xsl:variable name="m_deletedfollowingfriends">You have deleted the following name from your list contacts</xsl:variable>

<!-- all my portfolio -->
<xsl:variable name="m_olderentries">next</xsl:variable>
<xsl:variable name="m_newerentries">previous</xsl:variable>

<!-- all my conversations -->
<xsl:variable name="m_unsubscribe"><xsl:copy-of select="$button.remove" /></xsl:variable>
<xsl:variable name="m_newerpostings">previous</xsl:variable>
<xsl:variable name="m_olderpostings">next</xsl:variable>

	<xsl:variable name="sendtoafriend">
		<div><a onClick="popmailwin('/cgi-bin/navigation/mailto.pl?GO=1','Mailer')" href="/cgi-bin/navigation/mailto.pl?GO=1" target="Mailer">send to a friend</a></div>
	</xsl:variable>

	<xsl:variable name="m_nomessagesowner">
	<xsl:element name="{$text.base}" use-attribute-sets="text.base">
	<!-- Want to get in touch with individuals on the site? You can leave a message on their personal space.  Add people to your contacts list to find them easily - simply visit their personal space and click 'Add to My Contacts' in the top right corner. -->
	</xsl:element>
	</xsl:variable>
	
	<xsl:variable name="m_nomessages">	
	<xsl:element name="{$text.base}" use-attribute-sets="text.base">
	<!-- Want to get in touch with individuals on the site? You can leave a message on their personal space.  Add people to your contacts list to find them easily - simply visit their personal space and click 'Add to My Contacts' in the top right corner. -->
	</xsl:element>
	</xsl:variable>
	
<xsl:variable name="m_artviewerfull">
<xsl:element name="{$text.base}" use-attribute-sets="text.base">
<!-- Writing that you save to the site can be accessed here. You can publish four types of pages to GW:<br/>
<ul>
<li>creative writing for constructive feedback from the community.</li>
<li>writing advice from your own experience to contribute to our learning content.</li>
<li>challenges: collaborations, writing games or mini-competitions for fun.</li>
<li>exercises from our mini-courses to track your learning progress.</li>
</ul> -->
You have no work published on Get Writing.
</xsl:element>
</xsl:variable>

<xsl:variable name="m_artviewerempty">
<xsl:element name="{$text.base}" use-attribute-sets="text.base">
<!-- Writing that you save to the site can be accessed here. You can publish four types of pages to GW:<br/>
<ul>
<li>creative writing for constructive feedback from the community.</li>
<li>writing advice from your own experience to contribute to our learning content.</li>
<li>challenges: collaborations, writing games or mini-competitions for fun.</li>
<li>exercises from our mini-courses to track your learning progress.</li>
</ul> -->
This person has no work published on Get Writing.
</xsl:element>
</xsl:variable>


<xsl:variable name="m_artownerempty">
	<xsl:element name="{$text.base}" use-attribute-sets="text.base">
	You have no work published on Get Writing.</xsl:element>
</xsl:variable>




<xsl:variable name="m_clubempty">
<xsl:element name="{$text.base}" use-attribute-sets="text.base">
<!-- You can join or start a writing group based on your interests and experience.  Your list of groups and links to admin tools and group activity will be stored here.  -->
</xsl:element>
</xsl:variable>

	
<xsl:variable name="m_forumownerempty">
<!-- Your conversations from the Talk section and your Groups, plus reviews of your work, can be found here. You can also find updates from Community News if you have subscribed to it.<br/>
If you don't want to be notified of new postings to a particular conversation, click the 'Remove?' button. -->
</xsl:variable>
<xsl:variable name="m_forumviewerempty">
<!-- Your conversations from the Talk section and your Groups, plus reviews of your work, can be found here. You can also find updates from Community News if you have subscribed to it.<br/>
If you don't want to be notified of new postings to a particular conversation, click the 'Remove?' button. -->
</xsl:variable>

<xsl:template name="m_psintroowner">
<xsl:element name="{$text.base}" use-attribute-sets="text.base">
Welcome back.  Unfortunately, the community is now closed, and most people have moved house.  Find out more from <a href="{$root}aboutgw">About Get Writing</a>. 

		<xsl:if test="$ownerisviewer = 1 and /H2G2/ARTICLE/ARTICLEINFO/SITEID='15'">
		If you would like to join another DNA community, you can move your personal space to one of the sites below.
		<br/><br/>
				<a href="/dna/h2g2">h2g2</a> - The guide to Life, the Universe and Everything. <br/>
<a href="{$sso_resources}/cgi-perl/signon/mainscript.pl?c=login&amp;service=h2g2&amp;ptrt={$sso_redirectserver}/dna/h2g2/U{/H2G2/VIEWING-USER/USER/USERID}?homesite=1"><img src="{$graphics}buttons/button_movespace.gif" alt="" width="120" vspace="4" height="25" border="0"/></a>
<br/><br/>
		<a href="/dna/collective">collective</a> - exchanging views on new music, film and culture.<br/>
<a href="{$sso_resources}/cgi-perl/signon/mainscript.pl?c=login&amp;service=collective&amp;ptrt={$sso_redirectserver}/dna/collective/U{/H2G2/VIEWING-USER/USER/USERID}?homesite=1"><img src="{$graphics}buttons/button_movespace.gif" alt="" width="120" height="25" border="0"/></a>
<br/><br/>
		<a href="/dna/ww2">People's War</a> - share your wartime stories or family history <br/>
<a href="{$sso_resources}/cgi-perl/signon/mainscript.pl?c=login&amp;service=ww2&amp;ptrt={$sso_redirectserver}/dna/ww2/U{/H2G2/VIEWING-USER/USER/USERID}?homesite=1"><img src="{$graphics}buttons/button_movespace.gif" alt="" width="120" height="25" border="0"/></a>
<br/><br/></xsl:if>

<br/><br/>There are still useful articles, tools and listings on the site.  We hope you'll continue to use this resource for your writing.

<!-- Welcome to your Get Writing.  This is your personal space - your own HQ to control and manage your activity on this site. Now that you're with us, we recommend you do these three things first:

<p>1. Visit <a href="{$root}communitynews">Community News</a> and sign up for updates. This will let you know whenever we've got new stuff or when technical upgrades mean the site will be offline for a bit.  You'll also get advance notice of competitions coming up.</p>

<p>2. Introduce yourself. The GW community would really like to know a bit more about you.  Click 'edit intro' to write a paragraph or two about your interests and experience. Then visit the <a href="{$root}newbies">Newbie's Intro</a> and say hello.</p>

<p>3. Take the Guided Tour - our handy overview of how to use the site.  <a href="{$root}aboutmyspace">Here's a taster</a>.</p> -->

</xsl:element>
</xsl:template>

<xsl:template name="m_psintroviewer">
<xsl:element name="{$text.base}" use-attribute-sets="text.base">
Thanks for dropping by to visit this person.  Unfortunately, the community is now closed, and most people have moved house.  Find out more from <a href="{$root}aboutgw">http://www.bbc.co.uk/dna/getwriting/aboutgw</a>.<br/><br/>
This person has now removed their introduction from  Get Writing. ?	
</xsl:element>
</xsl:template>
	
<!-- weblogs -->
<xsl:template name="m_journalownerempty">
<!-- This is where you can jot down your thoughts, formulate ideas, rave about a book you're reading... Generally write things that don't necessarily fit anywhere else.<br/>
It can be whatver you want it to be, and you can add entries whenever you like. -->
</xsl:template>

<xsl:template name="m_journalviewerempty">
<!-- This is where you can jot down your thoughts, formulate ideas, rave about a book you're reading... Generally write things that don't necessarily fit anywhere else.<br/>
It can be whatver you want it to be, and you can add entries whenever you like.  -->
</xsl:template>

<xsl:variable name="m_weblog"><xsl:value-of select="$m_journal"/></xsl:variable>
	
	
<!-- index page -->
<xsl:variable name="m_moreindexentries">next</xsl:variable>	
<xsl:variable name="m_nomoreentries">next</xsl:variable>
<xsl:variable name="m_previousindexentries">previous</xsl:variable>
<xsl:variable name="m_nopreventries">previous</xsl:variable>

<!-- search and browse -->
<xsl:variable name="m_searchresultstitle">Search Results</xsl:variable>
<xsl:variable name="m_searchresultsfor">you have searched for</xsl:variable>
<xsl:variable name="m_noprevresults">previous</xsl:variable>
<xsl:variable name="m_m_nomoreresults">next</xsl:variable>
<xsl:variable name="m_prevresults">previous</xsl:variable>
<xsl:variable name="m_nextresults">next</xsl:variable>

<!-- review forum -->
 <xsl:variable name="m_firstpagethreads">first post</xsl:variable>
<xsl:variable name="m_lastpagethreads">last post</xsl:variable>
<xsl:variable name="m_previouspagethreads">previous</xsl:variable>
<xsl:variable name="m_nextpagethreads">next</xsl:variable>
<xsl:variable name="m_nofirstpagethreads">first post</xsl:variable>
<xsl:variable name="m_nolastpagethreads">last post</xsl:variable>
<xsl:variable name="m_nopreviouspagethreads">previous</xsl:variable>
<xsl:variable name="m_nonextpagethreads">next</xsl:variable>
<xsl:variable name="alt_nowshowing"></xsl:variable>
<xsl:variable name="alt_show"></xsl:variable>













</xsl:stylesheet>
