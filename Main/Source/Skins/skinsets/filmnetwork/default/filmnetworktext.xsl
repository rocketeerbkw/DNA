<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
	<!ENTITY space "<xsl:text xmlns:xsl='http://www.w3.org/1999/XSL/Transform'> </xsl:text>">
]>
<xsl:stylesheet exclude-result-prefixes="msxsl local s dt" version="1.0"
	xmlns:dt="urn:schemas-microsoft-com:datatypes" xmlns:local="#local-functions"
	xmlns:msxsl="urn:schemas-microsoft-com:xslt"
	xmlns:s="urn:schemas-microsoft-com:xml-data"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:variable name="m_complainttext"> Disclaimer<br /> Most of the content on
		BBC Film Network is created by BBC Network Members, who are members of the
		public. The views expressed are theirs and unless specifically stated are
		not those of the BBC. The BBC is not responsible for the content of any
		external sites referenced. If you consider anything on this page to be in
		breach of the site's <a href="{$root}houserules">House Rules</a>, please <a
			href="{$url_complain}">click here</a>. </xsl:variable>

	<xsl:variable name="test_UserHasEditorial"
		select="/H2G2/RECENT-APPROVALS/ARTICLE-LIST/ARTICLE[SITEID=15]" />
	<xsl:variable name="smileylist">smiley, biggrin, cool, sadface, winkeye, doh,
		ok, tongueout, yawn, zzz, wow, hangover, cross, hug, blush, headhurts, grr,
		drunk, erm, silly, disco,</xsl:variable>
	<xsl:variable name="sidenavbaritems">
		<category href="{$root}diary" name="2020 Diary" />
		<category href="{$root}arts" name="Arts" />
		<category href="{$root}body" name="Body &amp; mind" />
		<category href="{$root}environment" name="Environment" />
		<category href="{$root}leisure" name="Leisure &amp; sport" />
		<category href="{$root}love" name="Love" />
		<category href="{$root}politics" name="Politics &amp; society" />
		<category href="{$root}pop" name="Pop culture" />
		<category href="{$root}science" name="Science" />
		<category href="{$root}spirituality" name="Spirituality" />
		<category href="{$root}work" name="Work &amp; study" />
		<category href="{$root}odd" name="Odd" />
	</xsl:variable>

	<!-- generic terms -->
	<xsl:variable name="m_user">Member</xsl:variable>
	<xsl:variable name="m_users">Members</xsl:variable>
	<xsl:variable name="m_usera"> a </xsl:variable>
	<xsl:variable name="m_article">Film</xsl:variable>
	<xsl:variable name="m_articles">Films</xsl:variable>
	<xsl:variable name="m_articlea"> a </xsl:variable>
	<xsl:variable name="m_articleurl">Films</xsl:variable>
	<xsl:variable name="m_editedarticle">Edited Film</xsl:variable>
	<xsl:variable name="m_editedarticles">Edited Films</xsl:variable>
	<xsl:variable name="m_editedarticlea"> an </xsl:variable>
	<xsl:variable name="m_editedguide">Edited Site</xsl:variable>
	<xsl:variable name="m_nomembers">no films</xsl:variable>
	<xsl:variable name="m_member"> films</xsl:variable>
	<xsl:variable name="m_members"> films</xsl:variable>
	<xsl:variable name="m_posting">Comment</xsl:variable>
	<xsl:variable name="m_postings">Comments</xsl:variable>
	<xsl:variable name="m_postinga"> a </xsl:variable>
	<xsl:variable name="m_postingurl">Comment</xsl:variable>
	<xsl:variable name="m_thread">Comment</xsl:variable>
	<xsl:variable name="m_threads">Comments</xsl:variable>
	<xsl:variable name="m_threada"> a </xsl:variable>
	<xsl:variable name="m_threadurl">Comments</xsl:variable>
	<xsl:variable name="m_forum">Comment</xsl:variable>
	<xsl:variable name="m_forums">Comments</xsl:variable>
	<xsl:variable name="m_foruma"> a </xsl:variable>
	<xsl:variable name="m_nosuchguideentry">No Such <xsl:value-of
		select="$m_article" /></xsl:variable>

	<!-- my space conversations -->
	<xsl:variable name="m_noposting">no posting</xsl:variable>
	<xsl:variable name="m_postedcolon">my last post:</xsl:variable>
	<xsl:variable name="m_lastreply"> last comment</xsl:variable>
	<xsl:variable name="m_newestpost">latest comment</xsl:variable>
	<xsl:variable name="m_noreplies"><!-- latest comment no comment --></xsl:variable>

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
	<xsl:variable name="alt_viewallvisions">VIEW ALL ENTRIES</xsl:variable>
	<xsl:variable name="alt_tellusyourvision">WRITE AN ENTRY</xsl:variable>
	<xsl:variable name="alt_submittoreviewforumbutton">SUBMIT <xsl:value-of
			select="translate($m_article,$lowercase,$uppercase)" /></xsl:variable>
	<xsl:variable name="m_thefutureof">THE FUTURE OF</xsl:variable>
	<xsl:variable name="na_addentry">addentry</xsl:variable>
	<xsl:variable name="m_editor">By</xsl:variable>
	<xsl:variable name="m_datecolon">Created: </xsl:variable>
	<xsl:variable name="m_deleteFromList">Delete from list</xsl:variable>
	<xsl:variable name="m_cantfind">Can't find what you're looking for?</xsl:variable>
	<xsl:variable name="alt_searchoncategorypage">Search</xsl:variable>
	<xsl:variable name="m_visionsboxdummytext">Links to other entries and websites
		will appear here.</xsl:variable>
	<xsl:variable name="m_bbcboxdummytext">Links to bbc.co.uk websites will appear
		here.</xsl:variable>
	<xsl:variable name="m_othersitesboxdummytext">Links to external websites will
		appear here.</xsl:variable>
	<xsl:variable name="alt_clickherehelpentry"><img alt="Link to HOW TO CREATE AND EDIT YOUR ENTRY" border="0" height="17"
			src="{$imagesource}furniture/btn_createeditvision.gif" width="235" /></xsl:variable>
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
	<xsl:variable name="m_backtouserpage">go back to my profile without changing</xsl:variable>
	<xsl:variable name="m_prefintro">This is where you can make changes to your
		details.</xsl:variable>
	<xsl:variable name="m_changenickname">Change nickname</xsl:variable>
	<xsl:variable name="m_prefnickname">Your nickname appears next to all your
		posts</xsl:variable>
	<xsl:variable name="m_changeemail">Change email address</xsl:variable>
	<xsl:variable name="m_prefemail">Please check your email address is correct.
		This will be used ...</xsl:variable>
	<xsl:variable name="m_changepassword">Change password</xsl:variable>
	<xsl:variable name="m_preferencessubject">My details</xsl:variable>
	<xsl:variable name="m_submitreviewforumsubject">SUBMIT FOR REVIEW</xsl:variable>
	<xsl:variable name="m_rfintro">Listed here are the most recent Entries
		submitted for review:</xsl:variable>
	<xsl:variable name="m_editpost">Edit Posting</xsl:variable>
	<xsl:variable name="m_clicktowritearticle">go to the online submission form</xsl:variable>
	<xsl:variable name="m_ptclicktoleaveguestbookmessage">make your comment</xsl:variable>
	<xsl:variable name="m_ptclicktostartnewconv">leave your message</xsl:variable>
	<xsl:variable name="m_ptclicktoleaveprivatemessage">leave your message</xsl:variable>
	<!-- this might not be used -->
	<xsl:variable name="m_regwaittransfer">
		<!-- head section -->
		<table border="0" cellpadding="5" cellspacing="0" width="371">
			<tr>
				<td height="10" />
			</tr>
		</table>
		<table border="0" cellpadding="0" cellspacing="0" width="635">
			<!-- Spacer row -->
			<tr>
				<td>
					<img alt="" class="tiny" height="1" src="/f/t.gif" width="371" />
				</td>
				<td>
					<img alt="" class="tiny" height="1" src="/f/t.gif" width="20" />
				</td>
				<td>
					<img alt="" class="tiny" height="1" src="/f/t.gif" width="244" />
				</td>
			</tr>
			<tr>
				<td valign="top" width="371">

					<table border="0" cellpadding="0" cellspacing="0" width="371">

						<tr>
							<td class="topbg" height="69" valign="top">
								<img alt="" height="10" src="/f/t.gif" width="1" />
								<div class="whattodotitle">
									<strong>Please wait while you are transferred to your 'My
										Profile'.</strong>
								</div>
								<div class="topboxcopy"><strong>
										<a class="rightcol"
											href="{$root}U{/H2G2/NEWREGISTER/USERID}">Click here</a>
									</strong> if nothing happens after a few seconds.</div>
							</td>
						</tr>
					</table>
				</td>
				<td class="topbg" valign="top" width="20" />
				<td class="topbg" valign="top"> </td>
			</tr>
			<tr>
				<td colspan="3" valign="top" width="635">
					<img height="27"
						src="{$imagesource}furniture/writemessage/topboxangle.gif"
						width="635" />
				</td>
			</tr>
		</table>
		<!-- spacer -->
		<table border="0" cellpadding="0" cellspacing="0" width="635">
			<tr>
				<td height="10" />
			</tr>
		</table>
	</xsl:variable>

	<xsl:variable name="m_subscribedtoforum">You have now subscribed to this <xsl:choose>
			<xsl:when test="/H2G2/RETURN-TO[starts-with(URL, 'RF')]">review circle</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$m_forum" />
			</xsl:otherwise>
		</xsl:choose>. The 'Recent <xsl:value-of select="$m_threads" />' list in
		your 'My Portfolio' will show you when new <xsl:value-of select="$m_threads"
		 /> are started.</xsl:variable>

	<xsl:template name="m_unregistereduserediterror">
		<table border="0" cellpadding="5" cellspacing="0" width="371">
			<tr>
				<td>
					<br />
					<br />
					<div class="mediumtext">
						<P>We're sorry, but you can't create or edit <xsl:value-of
								select="$m_articles" /> until you've logged in.</P>
						<UL>
							<LI>
								<P>If you already have an account, please <b>
										<A href="{$sso_noarticlesigninlink}"
											xsl:use-attribute-sets="nm_unregistereduserediterror1"
											>click here to sign in</A>
									</b>.</P>
							</LI>
							<LI>
								<P>If you haven't already registered with us as a <xsl:value-of
										select="$m_user" />, please <b>
										<A HREF="{$sso_noarticleregisterlink}"
											xsl:use-attribute-sets="nm_unregistereduserediterror2"
											>click here to register</A>
									</b>. Registering is free and will enable you to share your
									wisdom with the rest of the Community. <b>
										<a href="{$root}help"
											xsl:use-attribute-sets="nm_unregistereduserediterror3"
											>Tell me more!</a>
									</b>.</P>
							</LI>
						</UL>
					</div>
				</td>
			</tr>
		</table>
		<br />
		<br />
		<br />
		<br />
	</xsl:template>

	<!-- friends -->
	<xsl:variable name="URL_dis">
		<xsl:choose>
			<xsl:when test="number(/H2G2/ARTICLE/ARTICLEINFO/H2G2ID) > 0"
					>'<xsl:value-of select="$root" />UserComplaint?h2g2ID=<xsl:value-of
					select="/H2G2/ARTICLE/ARTICLEINFO/H2G2ID" />'</xsl:when>
			<xsl:otherwise>'<xsl:value-of select="$root" />UserComplaint?URL=' +
				escape(window.location.href)</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="m_noconnectionerror" />

	<!-- this is the message that is displayed after a login/registration started from the UserEdit page. -->
	<xsl:template name="m_ptwriteguideentry">
		<b>
			<a href="{$root}UserEdit" xsl:use-attribute-sets="nm_ptwriteguideentry"
				>Click here to write your <xsl:value-of select="$m_article" /></a>
			<br />
			<br />
		</b>
	</xsl:template>

	<xsl:variable name="m_firsttotalk">Click below to be the first person to
		discuss this <xsl:value-of select="$m_article" /></xsl:variable>
	<!-- <xsl:variable name="m_addguideentry">Save to website</xsl:variable> -->
	<xsl:variable name="m_addguideentry">Update Entry</xsl:variable>
	<xsl:variable name="m_returntoconv">Return to the <xsl:value-of
			select="$m_thread" /> without posting</xsl:variable>
	<xsl:variable name="m_returntoentry">Return to the <xsl:value-of
			select="$m_article" /> without posting</xsl:variable>
	<xsl:variable name="m_returntoforum">Return to the <xsl:value-of
			select="$m_forum" /> without posting</xsl:variable>
	<xsl:variable name="m_userintro">Write your entry here</xsl:variable>

	<!-- login -->
	<xsl:variable name="m_oruserid">or <xsl:value-of select="$m_user" /> number </xsl:variable>
	<xsl:variable name="m_UserEditHouseRulesDiscl2">
		<table border="0" cellpadding="0" cellspacing="0" width="433">
			<tr>
				<td height="1" />
			</tr>
		</table>
		<table border="0" cellpadding="5" cellspacing="0" width="433">
			<tr>
				<td bgcolor="#E0DAC8">
					<font class="grey" size="1"><b class="white">TIPS</b><br /> &nbsp;<br />
						<img alt="" border="0" height="8"
							src="{$imagesource}furniture/bullet_black2.gif" width="9" />Keep
						it brief! If you want to make a point in depth, consider <a
							class="grey" href="{$root}useredit">Submit a Film</a>.<br /> &nbsp;<br />
						<img alt="" border="0" height="8"
							src="{$imagesource}furniture/bullet_black2.gif" width="9" />Please
						be very careful if you want to post an email address or instant
						messaging number, as you may receive lots of emails or messages. See
							<a class="grey" href="{$root}houserules">House Rules</a> for more
						information.<br /> &nbsp;<br />
						<img alt="" border="0" height="8"
							src="{$imagesource}furniture/bullet_black2.gif" width="9" />You
						must be over 16 to post to this site.<br /> &nbsp;<br />
						<img alt="" border="0" height="8"
							src="{$imagesource}furniture/bullet_black2.gif" width="9" />Refer
						to websites by typing the full address (e.g.
						http://www.bbc.co.uk)<br /> &nbsp;<br />
						<img alt="" border="0" height="8"
							src="{$imagesource}furniture/bullet_black2.gif" width="9" />Don't
						forget to follow the <a class="grey" href="{$root}houserules">House
							Rules</a>.<br /> &nbsp;<br />
						<img alt="" border="0" height="8"
							src="{$imagesource}furniture/bullet_black2.gif" width="9" />See <a
							class="grey" href="http://www.bbc.co.uk/copyright">Terms of
						Use</a> for details on how we may use your Conversation.<br /> &nbsp;<br />
						<img alt="" border="0" height="8"
							src="{$imagesource}furniture/bullet_black2.gif" width="9" />For
						more tips take a look at <a class="grey" href="{$root}help"
						>Help</a>.<br />
					</font>
					<table border="0" cellpadding="0" cellspacing="0" width="100%">
						<tr>
							<td height="7" />
						</tr>
					</table>
				</td>
			</tr>
		</table>
	</xsl:variable>

	<xsl:variable name="m_UserEditWarning">
		<table border="0" cellpadding="5" cellspacing="0" width="433">
			<tr>
				<td bgcolor="#E0DAC8">
					<font class="grey" size="1"><b class="white">TIPS</b><br /> &nbsp;<br />
						<img alt="" border="0" height="8"
							src="{$imagesource}furniture/bullet_black2.gif" width="9" />Your
						content will appear on the Website once you have selected
						'Save'.<br /> Once you've saved your entry you can still change it
						using the Edit option<br /> &nbsp;<br />
						<img alt="" border="0" height="8"
							src="{$imagesource}furniture/bullet_black2.gif" width="9" />Please
						be very careful if you want to post an email address or
						instantmessaging numbers, as you mayreceive lots of emails or
						messages.See House Rules for more information.<br /> &nbsp;<br />
						<img alt="" border="0" height="8"
							src="{$imagesource}furniture/bullet_black2.gif" width="9" />You
						must be be over 16 to post to this site<br /> &nbsp;<br />
						<img alt="" border="0" height="8"
							src="{$imagesource}furniture/bullet_black2.gif" width="9" />Refer
						to websites by typing the full address (e.g.
						http://www.bbc.co.uk)<br /> &nbsp;<br />
						<img alt="" border="0" height="8"
							src="{$imagesource}furniture/bullet_black2.gif" width="9" />Don't
						forget to follow the <a class="grey" href="{$root}houserules">House
							Rules</a><br /> &nbsp;<br />
						<img alt="" border="0" height="8"
							src="{$imagesource}furniture/bullet_black2.gif" width="9" />See <a
							class="grey" href="http://www.bbc.co.uk/copyright">Terms of
						Use</a> for details on how we may use your Films<br /> &nbsp;<br />
						<img alt="" border="0" height="8"
							src="{$imagesource}furniture/bullet_black2.gif" width="9" />For
						more tips take a look at <a class="grey" href="{$root}help"
						>Help</a><br />
					</font>
					<table border="0" cellpadding="0" cellspacing="0" width="100%">
						<tr>
							<td height="7" />
						</tr>
					</table>
				</td>
			</tr>
		</table>

	</xsl:variable>
	<xsl:variable name="m_cta">Think you know the future? Tell us and you could be
		published.</xsl:variable>
	<!--  Submit for review -->
	<xsl:variable name="m_entrysubmittoreviewforumsubject">
		<xsl:value-of select="$m_article" /> successfully submitted to the Editor's
		Desk</xsl:variable>
	<xsl:variable name="m_removefromreviewforumsubject">
		<xsl:value-of select="$m_article" /> Successfully Removed from the Editor's
		Desk</xsl:variable>
	<xsl:template name="m_submitforreviewbutton"> submit for review </xsl:template>
	<xsl:template name="m_currentlyinreviewforum"> Your work is in: </xsl:template>
	<xsl:template name="m_submittedtoreviewforumbutton">
		<xsl:value-of select="REVIEWFORUM/FORUMNAME" />
	</xsl:template>
	<xsl:variable name="m_srfinitialtext"> Use this form to submit <strong>
			<a href="A{/H2G2/SUBMIT-REVIEW-FORUM/ARTICLE/@H2G2ID}">
				<xsl:value-of select="/H2G2/SUBMIT-REVIEW-FORUM/ARTICLE" />
			</a>
		</strong> for review <br />
		<br /> please read the review circle introduction before using this form *
		short stories - ipsum lorem dorem <br /> * short stories - ipsum lorem dorem
		<br /> * short stories - ipsum lorem dorem <br /> * short stories - ipsum
		lorem dorem <br /> * short stories - ipsum lorem dorem <br /> * short
		stories - ipsum lorem dorem <br />
	</xsl:variable>

	<xsl:template name="bottom-disclaimer"> </xsl:template>

	<xsl:template name="m_bbcregblurb3">
		<font size="1">Your registration will allow us to:<br />
			<ul class="black">
				<li>Verify your access to bbc.co.uk services wich require registration</li>
				<li>Personalise your experience on bbc.co.uk</li>
			</ul>
		</font>
	</xsl:template>
	<xsl:template name="m_bbcloginblurb">
		<font class="grey" size="1"> This is where you can sign in to Network. You
			need to <a class="grey" xsl:use-attribute-sets="nm_bbcloginblurb">
				<xsl:call-template name="regpassthroughhref">
					<xsl:with-param name="url">register</xsl:with-param>
				</xsl:call-template> register </a> before you can sign in. </font>
	</xsl:template>
	<xsl:template name="m_bbcloginblurb2">
		<font class="grey" size="1"> Your member name and password are case
			sensitive. </font>
	</xsl:template>
	<xsl:template name="m_bbcloginblurb2a">
		<font class="grey" size="1"> If you have <a class="grey"
				href="{$root}UserDetails?unregcmd=yes"
				xsl:use-attribute-sets="nm_bbcloginblurb">forgotten your password</a>,
			then we can email you a new one. </font>
	</xsl:template>
	<xsl:template name="m_bbcloginblurb3">

		<font class="grey" size="1"> Having problems? See our <a class="grey"
				href="/help">Help page</a>. </font>
	</xsl:template>
	<xsl:template name="m_agreetoterms">I agree to the <a
			href="http://www.bbc.co.uk/copyright"> Terms of Use </a> and <a
			href="houserules">House Rules</a>
	</xsl:template>
	<xsl:template name="m_forgottenpassport">
		<b>
			<a href="{$root}UserDetails?unregcmd=yes"
				xsl:use-attribute-sets="nm_bbcloginblurb">Forgotten your password?</a>
		</b> We`ll email you one.</xsl:template>

	<xsl:template name="m_submitarticlefirst_text">A<xsl:value-of
			select="/H2G2/SUBMIT-REVIEW-FORUM/ARTICLE/@H2G2ID" /> - <b>
			<xsl:value-of select="/H2G2/SUBMIT-REVIEW-FORUM/ARTICLE" />
		</b>
	</xsl:template>
	<xsl:template name="m_submitarticlefirst_text2">To put this <xsl:value-of
			select="$m_article" /> into review, select the relevant Review Forum and
		enter your comments below. </xsl:template>
	<xsl:template name="m_guideentrydeleted"> Your <xsl:value-of
			select="$m_article" /> has been deleted. If you want to restore any
		deleted <xsl:value-of select="$m_articles" /> you can view them <a
			class="white" use-attribute-sets="nm_guideentrydeleted"><xsl:attribute
				name="href">MA<xsl:value-of select="USERID"
			 />&amp;type=3</xsl:attribute>on this page</a>. </xsl:template>

	<xsl:template name="m_logoutblurb">
		<!-- You have just logged out. The next time you visit on this computer we won't automatically recognise you.<br/>&nbsp; --><br />
		To sign in again, <b>
			<a href="{$sso_signinlink}">click here</a>
		</b>. </xsl:template>
	<xsl:variable name="m_notfoundbody">We're sorry, but the page you have
		requested does not exist. This could be because the URL<A HREF="#footnote1"
			NAME="back1"
			TITLE="That's the address of the web page that we can't find - it should begin with http://www.bbc.co.uk{$root}"
			xsl:use-attribute-sets="nm_notfoundbody1">
			<SUP>1</SUP>
		</A> is wrong, or because the page you are looking for has been removed from
		the Site.<br />&nbsp;<br /> We apologise for this interruption in your
		surfing, and hope the tide comes back in soon.<br />&nbsp;<br />
		<blockquote>
			<font size="-1">
				<hr />
				<A NAME="footnote1">
					<A HREF="#back1" xsl:use-attribute-sets="nm_notfoundbody2">
						<SUP>1</SUP>
					</A> That's the address of the web page that we can't find - it should
					begin with http://www.bbc.co.uk<xsl:value-of select="$root" />
				</A>
			</font>
		</blockquote>
	</xsl:variable>
	<xsl:template name="m_removefromreviewforum">X</xsl:template>

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
	<xsl:template name="m_entrysubmittedtoreviewforum" />

	<xsl:template name="m_cantpostnotregistered">
		<p>Hi, you need to become a member before you can post to <xsl:value-of
				select="$m_threada" />
			<xsl:value-of select="$m_thread" />.</p>
		<UL>
			<LI>
				<P>If you already have an account, please <b>
						<A href="{$sso_nopostsigninlink}"
							xsl:use-attribute-sets="nm_cantpostnotregistered1">click here to
							sign in</A>
					</b>.</P>
			</LI>
			<LI>
				<P>If you haven't already registered with us as <xsl:value-of
						select="$m_usera" />
					<xsl:value-of select="$m_user" />, please <b>
						<A href="{$sso_nopostregisterlink}"
							xsl:use-attribute-sets="nm_cantpostnotregistered2">click here to
							become a member</A>
					</b>. Registering is free and will enable you to share your wisdom
					with the rest of the Community. <b>
						<a href="A387317" xsl:use-attribute-sets="nm_cantpostnotregistered3"
							>Tell me more!</a>
					</b>.</P>
			</LI>
		</UL>
		<P>Alternatively, <b>
				<A xsl:use-attribute-sets="nm_cantpostnotregistered4">
					<xsl:attribute name="href"><xsl:value-of select="$root"
							 />F<xsl:value-of select="@FORUMID" />?thread=<xsl:value-of
							select="@THREADID" />&amp;post=<xsl:value-of select="@POSTID"
							 />#p<xsl:value-of select="@POSTID" /></xsl:attribute>click here
					to return to the <xsl:value-of select="$m_thread" /> without logging
					in</A>
			</b>.</P>
	</xsl:template>

	<xsl:variable name="m_alwaysremember">Always remember my password on this
		computer</xsl:variable>

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
		<xsl:attribute name="class">text.medium</xsl:attribute>
	</xsl:attribute-set>

	<xsl:variable name="text.base">div</xsl:variable>
	<xsl:attribute-set name="text.base">
		<xsl:attribute name="class">textmedium</xsl:attribute>
	</xsl:attribute-set>

	<xsl:variable name="text.medium">div</xsl:variable>
	<xsl:attribute-set name="text.medium">
		<xsl:attribute name="class">textmedium</xsl:attribute>
	</xsl:attribute-set>

	<xsl:variable name="text.small">div</xsl:variable>
	<xsl:attribute-set name="text.small">
		<xsl:attribute name="class">textxsmall</xsl:attribute>
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
				<xsl:when test="/H2G2/PARAMS/PARAM[NAME= 's_print']/VALUE = 1"
					>page-column-print</xsl:when>
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
		<xsl:attribute name="alt" />
	</xsl:attribute-set>

	<xsl:attribute-set name="column.spacer.2">
		<xsl:attribute name="width">195</xsl:attribute>
		<xsl:attribute name="height">1</xsl:attribute>
		<xsl:attribute name="border">0</xsl:attribute>
		<xsl:attribute name="src">/t/f.gif</xsl:attribute>
		<xsl:attribute name="alt" />
	</xsl:attribute-set>

	<xsl:attribute-set name="column.spacer.3">
		<xsl:attribute name="width">10</xsl:attribute>
		<xsl:attribute name="height">1</xsl:attribute>
		<xsl:attribute name="border">0</xsl:attribute>
		<xsl:attribute name="src">/t/f.gif</xsl:attribute>
		<xsl:attribute name="alt" />
	</xsl:attribute-set>

	<xsl:attribute-set name="column.spacer.4">
		<xsl:attribute name="width">615</xsl:attribute>
		<xsl:attribute name="height">1</xsl:attribute>
		<xsl:attribute name="border">0</xsl:attribute>
		<xsl:attribute name="src">/t/f.gif</xsl:attribute>
		<xsl:attribute name="alt" />
	</xsl:attribute-set>

	<!-- groups -->
	<xsl:variable name="m_editclub">edit group intro</xsl:variable>
	<xsl:variable name="m_joinclub">Apply for membership</xsl:variable>
	<xsl:variable name="m_clublastposting">Posted</xsl:variable>
	<xsl:variable name="m_clubjournaltitle">GROUP DISCUSSION</xsl:variable>
	<xsl:variable name="m_discussclubjournalentry">reply</xsl:variable>

	<xsl:variable name="m_complainclubjournal_type">
		<xsl:choose>
			<xsl:when test="/H2G2/@TYPE = 'ARTICLE'">Click this button if you think
				this comment breaks the house rules</xsl:when>
			<xsl:when test="/H2G2/FORUMSOURCE/@TYPE = 'article'">Click this button if
				you think this comment breaks the house rules</xsl:when>
			<xsl:otherwise>Click this button if you think this message breaks the
				house rules</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="m_complainclubjournal">
		<img alt="{$m_complainclubjournal_type}" border="0" height="22"
			src="{$graphics}icons/icon_complain.gif" width="24" />
	</xsl:variable>
	<xsl:variable name="m_clickaddclubjournal">start discussion</xsl:variable>
	<xsl:variable name="m_latestreply">read more</xsl:variable>
	<xsl:template name="noClubJournalReplies"> no replies </xsl:template>
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
	<xsl:variable name="m_editmembers_owner">owner <br />
		<img border="0" src="{$graphics}icons/icon_owner.gif" /></xsl:variable>
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
	<xsl:variable name="alt_nonewerpost">latest</xsl:variable>
	<!--  post -->
	<xsl:variable name="alt_showingoldest">first</xsl:variable>
	<!--  post -->
	<xsl:variable name="m_noolderconv">previous</xsl:variable>
	<xsl:variable name="alt_showoldestconv">first</xsl:variable>
	<!--  post -->
	<xsl:variable name="alt_shownewest">latest</xsl:variable>
	<!--  post -->
	<xsl:variable name="alt_shownext">next</xsl:variable>
	<xsl:variable name="alt_showprevious">previous</xsl:variable>
	<xsl:variable name="alt_nonewconvs">next</xsl:variable>
	<xsl:variable name="m_replytothispost">
		<img alt="add your comments" height="47"
			src="{$imagesource}furniture/addyourcomments1.gif" width="197" />
	</xsl:variable>
	<xsl:variable name="alt_complain">
		<img alt="{$m_complainclubjournal_type}" border="0" height="28"
			src="{$imagesource}furniture/drama/commentsexclam.gif" width="29" />
	</xsl:variable>
	<xsl:variable name="m_clickunsubscribe">remove from my <xsl:value-of
			select="$m_threads" /></xsl:variable>
	<xsl:variable name="m_returntothreadspage">related <xsl:value-of
			select="$m_threads" /></xsl:variable>
	<xsl:variable name="m_clicknotifynewconv">add to my conversations</xsl:variable>
	<xsl:variable name="m_clickstopnotifynewconv">remove me from conversation</xsl:variable>
	<xsl:variable name="m_peopletalking">Here are the most recent conversations
		about this entry:</xsl:variable>
	<xsl:variable name="m_advicetext">Read the lastest advice here. You can share
		your views about each advivce comment by clicking the post title or add your
		own comments below.</xsl:variable>
	<xsl:variable name="m_challenge">Read the lastest contributions to this
		challenge here. You can share your views about each advice comment by
		clicking the post title or add your own comments below.</xsl:variable>
	<xsl:variable name="alt_discussthis">
		<xsl:choose>
			<xsl:when
				test="$article_type_group='features' or $article_type_group='notes'">
				start a new discussion&nbsp;<img alt="" height="7"
					src="{$imagesource}furniture/arrowdark.gif" width="4" />
			</xsl:when>
			<xsl:otherwise>add your comment</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<!-- multiposts -->
	<xsl:variable name="alt_showpostings">previous</xsl:variable>

	<!-- threads -->
	<xsl:variable name="m_postsubjectremoved">comment removed: breaks the <A
			HREF="{$root}houserules" TARGET="_top"
			xsl:use-attribute-sets="nm_postremoved">house rules</A></xsl:variable>
	<xsl:template name="m_postremoved" />
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
	<xsl:variable name="m_clickmoreconv">more comments</xsl:variable>

	<!-- userpage -->
	<xsl:template name="m_journalownerfull" />
	<xsl:template name="m_journalviewerfull" />
	<xsl:variable name="m_clickmoreuserpageconv">more messages</xsl:variable>
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
	<xsl:variable name="m_deletedfollowingfriends">You have deleted the following
		name from your list contacts</xsl:variable>

	<!-- all my portfolio -->
	<xsl:variable name="m_olderentries">next</xsl:variable>
	<xsl:variable name="m_newerentries">previous</xsl:variable>

	<!-- all my conversations -->
	<xsl:variable name="m_unsubscribe">
		<xsl:copy-of select="$button.remove" />
	</xsl:variable>
	<xsl:variable name="m_newerpostings">previous</xsl:variable>
	<xsl:variable name="m_olderpostings">next</xsl:variable>
	<xsl:variable name="sendtoafriend">
		<div>
			<a href="/cgi-bin/navigation/mailto.pl?GO=1"
				onClick="popmailwin('/cgi-bin/navigation/mailto.pl?GO=1','Mailer')"
				target="Mailer">send to a friend</a>
		</div>
	</xsl:variable>
	<xsl:variable name="m_nomessagesowner">
		<!-- 	Want to get in touch with individuals on the site? You can leave a message on their personal space.  Add people to your contacts list to find them easily - simply visit their personal space and click 'Add to My Contacts' in the top right corner. -->
	</xsl:variable>

	<xsl:variable name="m_nomessages">
		<!-- Want to get in touch with individuals on the site? You can leave a message on their personal space.  Add people to your contacts list to find them easily - simply visit their personal space and click 'Add to My Contacts' in the top right corner. -->
	</xsl:variable>
	<xsl:variable name="m_artviewerfull">
		<xsl:element name="{$text.base}" use-attribute-sets="text.base"> Writing
			that you save to the site can be accessed here. You can publish four types
			of pages to GW:<br />
			<ul>
				<li>creative writing for constructive feedback from the community.</li>
				<li>writing advice from your own experience to contribute to our
					learning content.</li>
				<li>challenges: collaborations, writing games or mini-competitions for
					fun.</li>
				<li>exercises from our mini-courses to track your learning
				progress.</li>
			</ul>
		</xsl:element>
	</xsl:variable>

	<xsl:variable name="m_artviewerempty">
		<xsl:element name="{$text.base}" use-attribute-sets="text.base"> Writing
			that you save to the site can be accessed here. You can publish four types
			of pages to GW:<br />
			<ul>
				<li>creative writing for constructive feedback from the community.</li>
				<li>writing advice from your own experience to contribute to our
					learning content.</li>
				<li>challenges: collaborations, writing games or mini-competitions for
					fun.</li>
				<li>exercises from our mini-courses to track your learning
				progress.</li>
			</ul>
		</xsl:element>
	</xsl:variable>

	<xsl:variable name="m_clubempty">
		<xsl:element name="{$text.base}" use-attribute-sets="text.base"> You can
			join or start a writing group based on your interests and experience. Your
			list of groups and links to admin tools and group activity will be stored
			here. </xsl:element>
	</xsl:variable>
	
	<xsl:variable name="m_forumownerempty"> Your conversations from the Talk
		section and your Groups, plus reviews of your work, can be found here. You
		can also find updates from Community News if you have subscribed to
		it.<br /> If you don't want to be notified of new postings to a particular
		conversation, click the 'Remove?' button. </xsl:variable>
	<xsl:variable name="m_forumviewerempty"> Your conversations from the Talk
		section and your Groups, plus reviews of your work, can be found here. You
		can also find updates from Community News if you have subscribed to
		it.<br /> If you don't want to be notified of new postings to a particular
		conversation, click the 'Remove?' button. </xsl:variable>

	<xsl:template name="m_psintroowner">
		<xsl:element name="{$text.base}" use-attribute-sets="text.base"> You have't
			included any profile information. You can use this space to include a
			Biog, Organisation info, favourite films &amp; filmmakers, my
			links.<br /><br />
		</xsl:element>
	</xsl:template>

	<xsl:template name="m_psintrostandarduserowner">
		<xsl:element name="{$text.base}" use-attribute-sets="text.base">
			<strong>You can use this space to tell others users a bit about yourself.</strong>
			<br />
			<br />
		</xsl:element>
	</xsl:template>

	<xsl:template name="m_psintroviewer">
		<xsl:element name="{$text.base}" use-attribute-sets="text.base"> This member
			is yet to write their biog.<br /><br />
		</xsl:element>

		<xsl:element name="{$text.base}" use-attribute-sets="text.base"> If you have
			created a Film Network membership and haven't written a biog for yourself,
			this is what your profile page looks like. Boring, isn't it? If you want
			to write your biog, click <strong>My Profile</strong> on the left-hand
			menu and then the 'edit my biog' link at the top of your profile
			page<br /><br />
		</xsl:element>
	</xsl:template>

	<!-- weblogs -->
	<xsl:template name="m_journalownerempty"> This is where you can jot down your
		thoughts, formulate ideas, rave about a book you're reading... Generally
		write things that don't necessarily fit anywhere else.<br /> It can be
		whatver you want it to be, and you can add entries whenever you like. </xsl:template>

	<xsl:template name="m_journalviewerempty"> This is where you can jot down your
		thoughts, formulate ideas, rave about a book you're reading... Generally
		write things that don't necessarily fit anywhere else.<br /> It can be
		whatver you want it to be, and you can add entries whenever you like. </xsl:template>

	<xsl:variable name="m_weblog">
		<xsl:value-of select="$m_journal" />
	</xsl:variable>

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
	<xsl:variable name="alt_nowshowing" />
	<xsl:variable name="alt_show" />

	<!-- navigation -->
	<xsl:variable name="m_userpagenav">my profile</xsl:variable>

	<xsl:variable name="comment_hints">
		<div class="hintpara2">
			<ul class="rightcollistround3">
				<li class="rightcollistround3">keep your comment constructive - remember
					if you are commenting on somebody's work that they will probably read
					what you say</li>
				<li class="rightcollistround3">keep your comment short and to the point
					- people are more likely to read something succinct</li>
				<li class="rightcollistround3">make sure your post doesn't break the <b>
						<a class="rightcol" href="{$root}houserules">house rules</a>
					</b> e.g. it's not offensive, illegal or anti-social</li>
				<li class="rightcollistround3">if you want to include a link, begin it
					with 'http://' and it will automatically turn into a link</li>
				<li class="rightcollistround3">avoid using just capital letters - it
					looks as if you are shouting</li>
				<li class="rightcollistround3">remember you can't delete your comment so
					make sure you won't regret what you've written </li>
				<li class="rightcollistround3">leave text-speak for mobile phones</li>
				<li class="rightcollistround3">bear in mind tone is sometimes lost in
					the written word</li>
			</ul>
		</div>

	</xsl:variable>

	<xsl:variable name="message_hints">
		<div class="hintpara2">
			<ul class="rightcollistround3">
				<li class="rightcollistround3">make sure your post doesn't break the <b>
						<a class="rightcol" href="{$root}houserules">house rules</a>
					</b> e.g. it's not offensive, illegal or anti-social</li>
				<li class="rightcollistround3">if you want to include a link, begin it
					with 'http://' and it will automatically turn into a link</li>
				<li class="rightcollistround3">avoid using just capital letters - it
					looks as if you are shouting</li>
				<li class="rightcollistround3">remember you can't delete your mesage so
					make sure you really mean it</li>
				<li class="rightcollistround3">leave text-speak for mobile phones</li>
				<li class="rightcollistround3">bear in mind tone is sometimes lost in
					the written word</li>
			</ul>
		</div>

	</xsl:variable>

	<xsl:variable name="search_hints">
		<div class="hintpara2">
			<ul class="rightcollistround3">
				<li class="rightcollistround3">try putting quotes around the words to
					search for several words together e.g. "director of photography"</li>
				<li class="rightcollistround3">make sure you've spelt your search term
					correctly</li>
				<li class="rightcollistround3">don't include any accents or unusual
					characters</li>
			</ul>
		</div>
	</xsl:variable>

	<xsl:variable name="commentlist_hints">
		<div class="hintpara2">
			<ul class="rightcollistround2">
				<!-- <li>click "latest" to see the most recent comment</li> -->
				<li>new comments will appear at the top of the list</li>
				<li>if you think a comment breaks the <b>
						<a class="rightcol" href="{$root}houserules">house rules</a>
					</b> please alert the moderators by clicking on the '!' icon that
					appears next to the relevant post </li>
				<li>if you make a comment, a link back to it will appear on your profile
					page</li>
			</ul>
		</div>
	</xsl:variable>

	<xsl:variable name="userintroform_hints">
		<div class="hintpara2">
			<ul class="rightcollistround3">
				<!-- <li>click "latest" to see the most recent comment</li> -->
				<li class="rightcollistround3">remember that other members can read your
					biog so don't include anything you wouldn't want others to know</li>
				<li class="rightcollistround3">feel free to include links to other
					websites you think are interesting or relevant</li>
				<li class="rightcollistround3">if you want to include a link, begin it
					with 'http://' and it will automatically turn into a link</li>
				<li class="rightcollistround3">avoid using just capital letters - it
					looks as if you are shouting</li>
				<li class="rightcollistround3">you can edit your biog at anytime</li>
			</ul>
		</div>
	</xsl:variable>

	<xsl:variable name="m_unregisteredslug">
		<table border="0" cellpadding="0" cellspacing="0" width="371">
			<tr>
				<td valign="top" width="371">
					<div class="medium">If you want to be able to add your own opinions to
						the Site, simply <strong>
							<a href="{$sso_registerlink}">Register</a>
						</strong> or <strong>
							<a href="{$sso_signinlink}">Sign in</a>
						</strong> as a member.</div>
				</td>
			</tr>
		</table>
	</xsl:variable>

	<xsl:variable name="pleasenote_text">
		<div class="disclaimerrightbox2"><span class="darkertitle">Please
			Note</span><br /> Be very careful if you want to post an email address as
			you may receive lots of emails or messages. See <b>
				<a href="{$root}sitehelpcommenting">site help</a>
			</b> for more information.<p /> Remember, when you contribute to the site
			you are giving the BBC permission to use your contribution. See the <b>
				<a href="http://www.bbc.co.uk/copyright">Terms of Use</a>
			</b> for more information </div>
	</xsl:variable>

	<!-- user page not tagged yet  used in tag-item page -->
	<xsl:variable name="m_userpagenotyettagged"
		><!-- This userpage has not been tagged to the taxonomy yet --></xsl:variable>
	<xsl:variable name="alert_moderatortext">
		<xsl:choose>
			<xsl:when test="/H2G2/@TYPE = 'ARTICLE'">&nbsp;Click this button on a
				comment that you think breaks the house rules</xsl:when>
			<xsl:when test="/H2G2/FORUMSOURCE/@TYPE = 'article'">Click this button on
				a comment that you think breaks the house rules</xsl:when>
			<xsl:otherwise>Click this button on a message that you think breaks the
				house rules</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<!-- complaints pop up -->
	<xsl:template name="m_complaintpopupseriousnessproviso"> This form is only for
		serious complaints about specific content that breaks the site's <A
			HREF="{$root}HouseRules" target="_new"
			xsl:use-attribute-sets="nm_complaintpopupseriousnessproviso">House
		Rules</A>, such as unlawful, harassing, defamatory, abusive, threatening,
		harmful, obscene, profane, sexually oriented, racially offensive, or
		otherwise objectionable material. <br />
		<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
		<br /> If this comment doesn't break the house rules, please reply on site. <!-- For general comments please post to the relevant <xsl:value-of select="$m_thread"/> on the site. -->
		<br />
		<br />
	</xsl:template>

	<!-- register -->
	<xsl:template name="m_passthroughnewuser">
		<!-- head section -->
		<table border="0" cellpadding="0" cellspacing="0" width="635">
			<!-- Spacer row -->
			<tr>
				<td>
					<img alt="" class="tiny" height="1" src="/f/t.gif" width="371" />
				</td>
				<td>
					<img alt="" class="tiny" height="1" src="/f/t.gif" width="20" />
				</td>
				<td>
					<img alt="" class="tiny" height="1" src="/f/t.gif" width="244" />
				</td>
			</tr>
			<tr>
				<td colspan="3" valign="top" width="100%">
					<table border="0" cellpadding="0" cellspacing="0" width="100%">
						<tr>
							<td class="topbg" height="69" valign="top">
								<img alt="" height="10" src="/f/t.gif" width="1" />

								<div class="profilename">
									<strong>where do you want to go?<br /></strong>
								</div>

								<div class="topboxcopy">If you are a new member, you may want to
									create a profile page before you do anything else:<br />
									<strong>
										<a class="rightcol"
											href="{$root}U{/H2G2/VIEWING-USER/USER/USERID}">create
											your profile page&nbsp;<img alt="" height="7"
												src="{$imagesource}furniture/myprofile/arrow.gif"
												width="4" /></a>
									</strong></div>
								<div class="topboxcopy">If you already have a profile page and
									want to return to where you were:<br />
									<strong>
										<xsl:apply-templates mode="c_pagetype"
											select="REGISTER-PASSTHROUGH" />
									</strong>&nbsp;<img alt="" height="7"
										src="{$imagesource}furniture/myprofile/arrow.gif" width="4"
									 /></div>
							</td>
						</tr>
						<!-- <tr>
		          <td valign="top" height="20" class="topbg"></td>
				</tr> -->
					</table>
				</td>
				<!-- <td valign="top" width="20" class="topbg"></td>
            <td valign="top" class="topbg">
			</td> -->
			</tr>
			<tr>
				<td colspan="3" valign="top" width="635">
					<img height="27"
						src="{$imagesource}furniture/writemessage/topboxangle.gif"
						width="635" />
				</td>
			</tr>
		</table>
		<!-- spacer -->
		<table border="0" cellpadding="0" cellspacing="0" width="635">
			<tr>
				<td height="60" />
			</tr>
		</table>
		<!-- end spacer -->
		<!-- <meta http-equiv="REFRESH"><xsl:attribute name="content">0;url=<xsl:value-of select="$root"/>U<xsl:value-of select="/H2G2/VIEWING-USER/USER/USERID"/></xsl:attribute></meta> -->
	</xsl:template>
	<xsl:variable name="m_registertodiscuss" />
	<xsl:variable name="m_registertodiscussuserpage" />

	<xsl:template name="m_userpagehidden">
		<div class="mediumtext">
			<xsl:choose>
				<xsl:when test="$ownerisviewer = 1">
					<P>Your biog has been hidden, because it breaks our <A
							HREF="{$root}HouseRules"
							xsl:use-attribute-sets="nm_userpagehidden1">House Rules</A> - you
						have been sent an email explaining why.</P>
					<P>You can easily re-write your profile so that it doesn't break the
						rules, which will make it appear immediately. Simply click edit
						biog.</P>
				</xsl:when>
				<xsl:otherwise>
					<P>This biog has been hidden, because it contravenes our <A
							HREF="{$root}HouseRules"
							xsl:use-attribute-sets="nm_userpagehidden2">House Rules</A>.</P>
				</xsl:otherwise>
			</xsl:choose>
		</div>
	</xsl:template>

	<xsl:template name="m_articlehiddentext">
		<table border="0" cellpadding="0" cellspacing="0" width="635">
			<!-- Spacer row -->
			<tr>
				<td>
					<img alt="" class="tiny" height="1" src="/f/t.gif" width="371" />
				</td>
				<td>
					<img alt="" class="tiny" height="1" src="/f/t.gif" width="20" />
				</td>
				<td>
					<img alt="" class="tiny" height="1" src="/f/t.gif" width="244" />
				</td>
			</tr>
			<tr>
				<td valign="top" width="371">

					<table border="0" cellpadding="0" cellspacing="0" width="371">

						<tr>
							<td class="topbg" height="69" valign="top">
								<img alt="" height="10" src="/f/t.gif" width="1" />

								<div class="whattodotitle">
									<strong>
										<xsl:choose>
											<xsl:when test="$ownerisviewer = 1">
												<!-- <P xsl:use-attribute-sets="ArticleText">Your <xsl:value-of select="$m_article"/> has been hidden, because it contravenes our <A xsl:use-attribute-sets="nm_articlehiddentext1" HREF="{$root}HouseRules">House Rules</A> in some way.</P>
				<P xsl:use-attribute-sets="ArticleText">You can easily re-write your <xsl:value-of select="$m_article"/> so that it doesn't break the rules, which will make it appear immediately. Simply click on the 'Edit <xsl:value-of select="$m_article"/>' button, make any changes to ensure that your <xsl:value-of select="$m_article"/> doesn't break the rules, and click on 'Update <xsl:value-of select="$m_article"/>'.</P> -->
												This film isn't ready yet. Please come back later. </xsl:when>
											<xsl:otherwise>
												<!-- <P xsl:use-attribute-sets="ArticleText">This <xsl:value-of select="$m_article"/> has been hidden, because it contravenes our <A xsl:use-attribute-sets="nm_articlehiddentext2" HREF="{$root}HouseRules">House Rules</A> in some way. However, the author can easily re-write it so that it doesn't break the rules, so let's hope they do just that.</P> -->
												This film isn't ready yet. Please come back later.
											</xsl:otherwise>
										</xsl:choose>
										<br />
									</strong>
								</div>

							</td>
						</tr>
					</table>
				</td>
				<td class="topbg" valign="top" width="20" />
				<td class="topbg" valign="top"> </td>
			</tr>
			<tr>
				<td colspan="3" valign="top" width="635">
					<img height="27"
						src="{$imagesource}furniture/writemessage/topboxangle.gif"
						width="635" />
				</td>
			</tr>
		</table>
	</xsl:template>

	<xsl:template name="m_userpagereferred">
		<xsl:choose>
			<xsl:when test="$ownerisviewer = 1">
				<P>Your biog has been temporarily hidden, because a moderator has
					referred it to the Film Network editors as it may break the <A
						HREF="{$root}HouseRules"
						xsl:use-attribute-sets="nm_userpagereferred1">House Rules</A>. We
					will do everything we can to make a decision as quickly as possible.</P>
				<P>Please do not try to edit your biog in the meantime, as this will
					only mean it gets checked by a moderator Team twice.</P>
			</xsl:when>
			<xsl:otherwise>
				<P>This biog has been temporarily hidden, because a moderator has
					referred it to the Film Network editors as it may break the <A
						HREF="{$root}HouseRules"
						xsl:use-attribute-sets="nm_userpagereferred2">House Rules</A> in
					some way. We will do everything we can to make a decision as quickly
					as possible.</P>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="m_userpagependingpremoderation">
		<xsl:choose>
			<xsl:when test="$ownerisviewer = 1">
				<P>Your <xsl:value-of select="$m_articles" /> are being pre-moderated
					and will only appear after they have been approved by a Moderator.
					Your biog is now queued for moderation, and will be visible as soon as
					a member of our Moderation Team has approved it (assuming it doesn't
					contravene the <A HREF="{$root}HouseRules"
						xsl:use-attribute-sets="nm_userpagependingpremoderation1">House
						Rules</A>).</P>
			</xsl:when>
			<xsl:otherwise>
				<P>This biog is currently queued for moderation, and will be visible as
					soon as a member of our Moderation Team has approved it (assuming it
					doesn't contravene the <A HREF="{$root}HouseRules"
						xsl:use-attribute-sets="nm_userpagependingpremoderation2">House
						Rules</A>). The <xsl:value-of select="$m_user" /> who edited it is
					currently being pre-moderated, so all new <xsl:value-of
						select="$m_articles" /> they make must be checked before they become
					visible.</P>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="m_legacyuserpageawaitingmoderation">
		<xsl:choose>
			<xsl:when test="$ownerisviewer = 1">
				<P>Your biog is currently hidden, because it needs to be reactivated
					before it's visible, as part of the moderation system.</P>
				<P>To make it visible, simply click edit biog and then submit. Your biog
					should then appear.</P>
			</xsl:when>
			<xsl:otherwise>
				<P>This biog is currently hidden, because the owner has not yet returned
					to reactivate it. If they do not return, then in time our Moderation
					Team will reactivate it instead, as they work through all the content
					that was created before moderation was introduced.</P>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

                <xsl:variable name="m_BBCaddress"> Film Network Submissions,<br />Room 220,<br />Drama Building,<br />Television Centre,<br />London,<br />W12 7RJ</xsl:variable>

	<!-- contacts -->
	<xsl:variable name="m_youremptyfriendslist">This is where your list of
		contacts will appear. To add someone to your contacts list, go to their
		profile page and click 'add to my contacts list'.</xsl:variable>
	<xsl:variable name="m_namesonyourfriendslist">Below are the members you have
		added to your contact list.</xsl:variable>
	<xsl:variable name="m_friendslistofuser">Below are the members <xsl:value-of
			select="/H2G2/PAGE-OWNER/USER/FIRSTNAMES"
			 /><xsl:text> </xsl:text><xsl:value-of
			select="/H2G2/PAGE-OWNER/USER/LASTNAME" /> has added to his/her contact
		list.</xsl:variable>
	<xsl:variable name="m_hasntaddedfriends"> hasn't added any members to his/her
		contact list.</xsl:variable>

</xsl:stylesheet>