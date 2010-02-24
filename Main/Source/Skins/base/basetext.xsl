<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
	<xsl:template name="showcategory">
		<xsl:apply-templates select="msxsl:node-set($categorydata)/CATEGORISATION"/>
		<!--<xsl:apply-templates select="$categorydata"/>-->
	</xsl:template>
	
	<!-- Site specific nickname text -->
	<xsl:template name="ssnickname_introtext">
		<p>You can change your h2g2 display name by entering it in the below field (255 character limit):</p>
	</xsl:template>
	
	<xsl:template name="ssnickname_nb">
		<p><strong>Please note:</strong> This is the name by which you are identified on  h2g2 only, not other BBC sites which use the iD sign-in system. <br />
		To change your  general BBC iD display name, click the <a href="$id_settings">Settings</a> link above and enter it in the name field.<br />
		Click <a href="http://www.bbc.co.uk/dna/h2g2/brunel/DontPanic-Prefs#2">here</a> for more information about display names on h2g2 and BBC iD.
		</p>
	</xsl:template>	
	
	<xsl:variable name="categorydata">
		<!--		<CATEGORISATION>
		</CATEGORISATION>
-->
	</xsl:variable>
	<xsl:variable name="sitedisplayname">This Site</xsl:variable>
	<xsl:variable name="categoryroot"/>
	<xsl:template name="m_welcomebackuser">
Welcome back, <xsl:value-of select="substring(VIEWING-USER/USER/USERNAME,1,20)"/>
		<xsl:if test="string-length(VIEWING-USER/USER/USERNAME) &gt; 20">..</xsl:if>. <a xsl:use-attribute-sets="nm_welcomebackuser" HREF="{$root}Register">(Click here if this isn't you)</a>
	</xsl:template>
	<xsl:template name="m_welcomebackuser2line">
Welcome back, <xsl:value-of select="substring(VIEWING-USER/USER/USERNAME,1,20)"/>
		<xsl:if test="string-length(VIEWING-USER/USER/USERNAME) &gt; 20">...</xsl:if>
		<BR/>
		<a xsl:use-attribute-sets="nm_welcomebackuser2line" HREF="{$root}Register">(Click here if this isn't you)</a>
	</xsl:template>
	<xsl:template name="m_registertodiscuss">
		<P>If you <A xsl:use-attribute-sets="nm_registertodiscuss" HREF="{$root}register">register</A> you can discuss this <xsl:value-of select="$m_article"/> with other <xsl:value-of select="$m_users"/>.</P>
	</xsl:template>
	<xsl:template name="m_journalownerfull">
		<P>Welcome to your <xsl:value-of select="$m_journal"/>.</P>
	</xsl:template>
	<xsl:template name="m_journalownerempty">
		<P>This is where any <xsl:value-of select="$m_journalpostings"/> you make will appear. <xsl:value-of select="$m_journalpostings"/> are like a diary: each <xsl:value-of select="$m_journalposting"/> is associated with a specific time, and you can use your <xsl:value-of select="$m_journal"/> to jot down thoughts and opinions as they occur to you. Other <xsl:value-of select="$m_users"/> can discuss your <xsl:value-of select="$m_journalpostings"/> and it's a great way to talk about things that aren't necessarily suited to <xsl:value-of select="$m_articlea"/>
			<xsl:value-of select="$m_article"/>.</P>
	</xsl:template>
	<xsl:template name="m_journalviewerempty">
		<p>This is where any <xsl:value-of select="$m_journalpostings"/> would appear, if this <xsl:value-of select="$m_user"/> had made any. Unfortunately they haven't managed to write anything, which is a shame because their <xsl:value-of select="$m_journal"/> is where they could tell everyone what they've been up to. Is your <xsl:value-of select="$m_journal"/> empty too? If so, this is how it'll appear to other <xsl:value-of select="$m_users"/> who visit your Personal Space.</p>
	</xsl:template>
	<xsl:template name="m_journalviewerfull">
		<p>Welcome to this <xsl:value-of select="$m_user"/>'s <xsl:value-of select="$m_journal"/>. If you'd like to comment on anything they have written here, just click the relevant 'Discuss this <xsl:value-of select="$m_article"/>' button.</p>
	</xsl:template>
	<xsl:template name="m_artownerfull">
		<p>This is a list of the most recent <xsl:value-of select="$m_articles"/> you have created.</p>
	</xsl:template>
	<xsl:template name="m_artownerempty">
		<p>Whenever you write <xsl:value-of select="$m_articlea"/>
			<xsl:value-of select="$m_article"/> it will appear here, and if you ever want to edit one of your <xsl:value-of select="$m_articles"/> you can do so simply by clicking on the 'Edit' link. Any <xsl:value-of select="$m_articles"/> you create are automatically added to the Site and will appear in search results. <A xsl:use-attribute-sets="nm_artownerempty" href="{$root}useredit">Click here if you want to get writing straight away.</A>
		</p>
	</xsl:template>
	<xsl:template name="m_artviewerfull">
		<p>These are all the <xsl:value-of select="$m_articles"/> this <xsl:value-of select="$m_user"/> has created. If you'd like to read them, click on the link, and if you want to talk about them, use the 'Discuss this <xsl:value-of select="$m_article"/>' button when you get there.</p>
	</xsl:template>
	<xsl:template name="m_artviewerempty">
		<p>When this <xsl:value-of select="$m_user"/> writes some <xsl:value-of select="$m_articles"/> they will appear here, but they haven't got round to it yet. We're sure they will soon...</p>
	</xsl:template>
	<xsl:template name="m_editownerfull">
		<p>This is a list of <xsl:value-of select="$m_editedarticles"/> to which you have contributed.</p>
	</xsl:template>
	<xsl:template name="m_editownerempty">
		<p>If one of your <xsl:value-of select="$m_articles"/> has been recommended for the <xsl:value-of select="$m_editedguide"/> and the Editors have given it their stamp of approval or have used a part of it in <xsl:value-of select="$m_editedarticlea"/>
			<xsl:value-of select="$m_editedarticle"/>, then the details will appear here.</p>
	</xsl:template>
	<xsl:template name="m_editviewerfull">
		<p>These are all the <xsl:value-of select="$m_editedarticles"/> to which this <xsl:value-of select="$m_user"/> has contributed.</p>
	</xsl:template>
	<xsl:template name="m_editviewerempty">
		<p>This <xsl:value-of select="$m_user"/> hasn't had any <xsl:value-of select="$m_articles"/> picked for editing, yet... but we're sure they soon will.</p>
	</xsl:template>
	<xsl:variable name="m_journalintroUI">
		<p>
			<xsl:copy-of select="$m_journalintro"/>
		</p>
	</xsl:variable>
	<xsl:variable name="m_journalintro">
		We all lead interesting lives, and your <xsl:value-of select="$m_journal"/> is the place to tell everyone exactly what makes your days buzz by. Here you can talk about what you're thinking of doing, what you think about what you're thinking of doing, and when you're thinking of doing it, because, unlike <xsl:value-of select="$m_articles"/>, <xsl:value-of select="$m_journalpostings"/> are associated with specific points in time.
		Think of your <xsl:value-of select="$m_journal"/> as your personal diary. If you want to preserve your writing in a more permanent format you might like to create <xsl:value-of select="$m_articlea"/>
		<xsl:value-of select="$m_article"/>, but remember that everything you write is always part of the Site, and other visitors to your page can still read what you've said, and discuss it.
	</xsl:variable>
	<xsl:template name="m_pserrorowner">
		<p>Unfortunately the Introduction to your Personal Space cannot be displayed fully due to errors in the GuideML. Click <a xsl:use-attribute-sets="nm_pserrorowner" href="{$root}UserEdit?masthead=1">here</a> to edit this page, and then select 'Preview'; the errors will then be highlighted for you.</p>
	</xsl:template>
	<xsl:template name="m_pserrorviewer">
		<P>Unfortunately this <xsl:value-of select="$m_user"/>'s Introduction cannot be displayed fully due to errors in the GuideML they've used.</P>
	</xsl:template>
	<xsl:template name="m_psintroowner">
		<P>This is your Personal Space, the most useful page you could ever hope for. It's where people can come along and find out all about you, and it's also where you can write <xsl:value-of select="$m_articles"/>, keep track of your <xsl:value-of select="$m_threads"/>, update your <xsl:value-of select="$m_journal"/> and change your preferences. It is basically your personal nerve centre.</P>
		<P>You can get to this page at any time by clicking on the 'My Space' button.</P>
		<P>One of the first things you'll want to do is set up your preferences, which you can do by clicking on the 'Preferences' button. That's where you can change your Nickname so you're no longer known as just another number.</P>
		<P>You should also replace this text with something a bit more individual and entertaining to visitors, by clicking on the 'Edit Page' button and typing in your own Introduction. If you don't do this then visitors to your Personal Space will not be able to leave messages, so it's a good thing to do straight away.</P>
		<P>Remember, you can get here at any time by clicking on the 'My Space' button.</P>
	</xsl:template>
	<xsl:template name="m_psintroviewer">
		<P>This is the Personal Space of <xsl:value-of select="/H2G2/PAGE-OWNER/USER/USERNAME"/>. Unfortunately <xsl:value-of select="/H2G2/PAGE-OWNER/USER/USERNAME"/> doesn't seem to have found the time to write anything by way of an introduction yet, but hopefully that will soon change.</P>
		<P>By the way, if you've registered but haven't yet written an Introduction to <I>your</I> Personal Space, then this is what your Space looks like to visitors (and, in the same way that you can't leave a message here for this <xsl:value-of select="$m_user"/>, others won't be able to leave messages for you on your Space). You can change this by clicking on the 'My Space' button, going to your Space, clicking on the 'Edit Page' button, and entering your own Introduction - it's highly recommended!</P>
	</xsl:template>
	<xsl:template name="m_forumownerempty">
		This section will display details of any <xsl:value-of select="$m_postings"/> you make to <xsl:value-of select="$m_threads"/>. This is really useful: by checking out this section you can keep track of <xsl:value-of select="$m_threads"/> you are involved in and can see if anyone has replied to your <xsl:value-of select="$m_postings"/>, and when.		
	</xsl:template>
	<xsl:template name="m_forumviewerfull">
		<!--
<P>Here are the details of the latest <xsl:value-of select="$m_postings"/> this <xsl:value-of select="$m_user"/> has made. Feel free to check out what they've posted and join in yourself.</P>
-->
	</xsl:template>
	<xsl:template name="m_forumownerfull">
	</xsl:template>
	<xsl:template name="m_forumviewerempty">
		This section will display details of any <xsl:value-of select="$m_postings"/> this <xsl:value-of select="$m_user"/> makes, when they get around to talking to the rest of the Community. <xsl:value-of select="$m_threads"/> are really fun and are the best way to meet people, as well as the best way to get people to visit your own Personal Space, so let's hope they join in soon.
	</xsl:template>
	<xsl:template name="m_lifelink">
		<a xsl:use-attribute-sets="nm_lifelink" target="_top" href="{$root}C72">Life</a>
	</xsl:template>
	<xsl:template name="m_universelink">
		<a xsl:use-attribute-sets="nm_universelink" target="_top" href="{$root}C73">The Universe</a>
	</xsl:template>
	<xsl:template name="m_everythinglink">
		<a xsl:use-attribute-sets="nm_everythinglink" target="_top" href="{$root}C74">Everything</a>
	</xsl:template>
	<xsl:template name="m_searchlink">
		<a xsl:use-attribute-sets="nm_searchlink" target="_top" href="{$root}Search">Advanced Search</a>
	</xsl:template>
	<xsl:template name="m_copyright2">
		<a xsl:use-attribute-sets="nm_copyright2" href="/copyright">
			<xsl:text disable-output-escaping="yes">&amp;copy; </xsl:text>BBC MMI</a>
	</xsl:template>
	<xsl:template name="m_registerslug">
		<B>
			<FONT SIZE="3">Add <I>your</I> Opinion!</FONT>
		</B>
		<P>
			<B>There are many <xsl:value-of select="$m_articles"/>, written by our <xsl:value-of select="$m_users"/>. If you want to be able to add your own opinions to the Site, simply <a xsl:use-attribute-sets="nm_registerslug" href="{$registerlink}">create your bbc.co.uk membership</a>.
			</B>
		</P>
	</xsl:template>
	<xsl:template name="m_recommendtext">
		<P>If you're not content to have created <xsl:value-of select="$m_articlea"/>
			<xsl:value-of select="$m_article"/> that's accessible to anyone using the search engine, why not take that extra step and put it up for Peer Review, for possible inclusion in the <xsl:value-of select="$m_editedguide"/>? You can find out how to do this at the <a xsl:use-attribute-sets="nm_recommendtext" href="{$root}PeerReview">Peer Review Page</a>.</P>
	</xsl:template>
	<xsl:template name="m_searchfailed">
		<P>We're sorry, but your search for '<xsl:value-of select="SEARCHTERM"/>' didn't find any results in any DNA sites. You might like to check the spelling of your search term, or you could try searching the whole of bbc.co.uk using the search box in the tool bar above.</P>
	</xsl:template>
	<xsl:template name="m_entryexists">
		<P xsl:use-attribute-sets="ArticleText">The <xsl:value-of select="$m_article"/> number you asked for doesn't exist.<br/>
Perhaps you mistyped it?</P>
	</xsl:template>
	<xsl:template name="m_possiblealternatives">
		<P xsl:use-attribute-sets="ArticleText">Here are some possible <xsl:value-of select="$m_articles"/> it could be:</P>
	</xsl:template>
	<xsl:template name="m_cantpostnotregistered">
		<P>We're sorry, but you can't post to <xsl:value-of select="$m_threada"/>
			<xsl:value-of select="$m_thread"/> until you've registered with us as <xsl:value-of select="$m_usera"/>
			<xsl:value-of select="$m_user"/>.</P>
		<UL>
			<LI>
				<P>If you already have an account, please <A xsl:use-attribute-sets="nm_cantpostnotregistered1" href="{$sso_nopostsigninlink}">click here to sign in</A>.</P>
			</LI>
			<LI>
				<P>If you haven't already registered with us as <xsl:value-of select="$m_usera"/>
					<xsl:value-of select="$m_user"/>, please <A xsl:use-attribute-sets="nm_cantpostnotregistered2" href="{$sso_nopostregisterlink}">click here to register</A>. Registering is free and will enable you to share your wisdom with the rest of the Community. <a xsl:use-attribute-sets="nm_cantpostnotregistered3" href="A387317">Tell me more!</a>.</P>
			</LI>
		</UL>
		<P>Alternatively, <A xsl:use-attribute-sets="nm_cantpostnotregistered4">
				<xsl:attribute name="href"><xsl:value-of select="$root"/>F<xsl:value-of select="@FORUMID"/>?thread=<xsl:value-of select="@THREADID"/>&amp;post=<xsl:value-of select="@POSTID"/>#p<xsl:value-of select="@POSTID"/></xsl:attribute>click here to return to the <xsl:value-of select="$m_thread"/> without logging in</A>.</P>
	</xsl:template>
	<xsl:template name="m_cantpostnoterms">
		<P>We're sorry, but you can't post to <xsl:value-of select="$m_threada"/>
			<xsl:value-of select="$m_thread"/> until you've agreed with our specific 
terms of use. <A xsl:use-attribute-sets="nm_cantpostnoterms1" href="{$root}LoginTerms?pa=postforum&amp;pt=forum&amp;forum={@FORUMID}&amp;pt=thread&amp;thread={@THREADID}&amp;pt=post&amp;post={@POSTID}">Click here to complete your login</A> - then you'll be able to 
share your wisdom with the rest of the Community. <a xsl:use-attribute-sets="nm_cantpostnoterms2" href="A387317">Tell me More!</a>
		</P>
		<P>Alternatively, <A xsl:use-attribute-sets="nm_cantpostnoterms3">
				<xsl:attribute name="href"><xsl:value-of select="$root"/>F<xsl:value-of select="@FORUMID"/>?thread=<xsl:value-of select="@THREADID"/>&amp;post=<xsl:value-of select="@POSTID"/></xsl:attribute>click here to return to the <xsl:value-of select="$m_thread"/>
			</A>.</P>
	</xsl:template>
	<xsl:template name="m_clickhelpbrowse">
	</xsl:template>
	<xsl:template name="m_regnewemail">
		<P>We've just sent you an email that you'll need to read before your registration is complete... go and check your mail!</P>
		<P>In the meantime, please feel free to continue exploring the Site.</P>
		<P>To return to the front page at any time, simply click on the logo at the top left of the page, or the 'Front Page' button above.</P>
	</xsl:template>
	<xsl:template name="m_regwaittransfer">
		<P>Please wait while you are transferred to your Personal Space. 
<A xsl:use-attribute-sets="nm_regwaittransfer" href="{$root}U{NEWREGISTER/USERID}">Click here</A> if nothing happens after a few seconds.</P>
	</xsl:template>
	<xsl:template name="m_regoldemail">
		<P>You've already registered with us, but it looks like you've logged out, or you're using a different browser or computer.</P>
		<P>We've sent you an email, which will allow you to reset your password to something
you can remember.</P>
	</xsl:template>
	<xsl:template name="m_regalready">
		<P>You're already registered with us as <xsl:value-of select="REGISTER/EMAILADDRESS"/>, so you probably want to go to your <a xsl:use-attribute-sets="nm_regalready1" href="{$root}U{VIEWING-USER/USER/USERID}">Personal Space</a>.</P>
		<P>However, if you are trying to set a password for this account so that you can log in from any computer, then you can do so by changing your <a xsl:use-attribute-sets="nm_regalready2" href="{$root}UserDetails">Preferences</a>.</P>
	</xsl:template>
	<xsl:template name="m_regbadpassword">
		<P>The password you typed is incorrect. Remember that upper and lower case letters are treated as different, so make sure you haven't pressed your Caps Lock key.</P>
	</xsl:template>
	<xsl:template name="m_dodgyemail">
		<P>'<xsl:value-of select="REGISTER/EMAILADDRESS"/>' doesn't really look like an email address.</P>
		<P>You probably meant to type something like someone@somewhere.com</P>
		<P>Why not try again?</P>
	</xsl:template>
	<xsl:template name="m_registrationblurb">
		<P>To register as <xsl:value-of select="$m_usera"/>
			<xsl:value-of select="$m_user"/> all you need to do is to enter your email address in the field below and press the 'Register' button. It's free, there's no obligation, and we promise not to give away your email address to anyone else. <a xsl:use-attribute-sets="nm_registrationblurb" href="A387317">Tell me More!</a>
		</P>
	</xsl:template>
	<xsl:template name="m_loginblurb">
		<P>If your email address is already registered, and you have set up a password, enter them both below to log in instantly wherever you are. If you can't remember what your password is, 
<xsl:choose>
				<xsl:when test="REGISTER/EMAILADDRESS">
					<a xsl:use-attribute-sets="nm_loginblurb" href="{$root}Register?email={REGISTER/EMAILADDRESS}&amp;cmd=withpassword">click here</a> and we'll email you instructions on how to change your password.
</xsl:when>
				<xsl:otherwise>
just leave the password blank and we'll email you instructions on how to change your password.
</xsl:otherwise>
			</xsl:choose>
		</P>
	</xsl:template>
	<xsl:template name="m_passwordintro">
Please enter your password to log in. If you can't remember your password,
<xsl:choose>
			<xsl:when test="REGISTER/EMAILADDRESS">
				<a xsl:use-attribute-sets="nm_passwordintro" href="{$root}Register?email={REGISTER/EMAILADDRESS}&amp;cmd=withpassword">click here</a> and we'll email you instructions on how to change your password.
</xsl:when>
			<xsl:otherwise>
just leave the password blank and we'll email you instructions on how to change your password.
</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="m_logoutblurb">
		<P>You have just logged out. The next time you visit on this computer we won't automatically recognise you.</P>
		<P>To log in again, go to the front page and follow the link.</P>
	</xsl:template>
	<xsl:variable name="m_MABackTo">Back to </xsl:variable>
	<xsl:variable name="m_MAPSpace">'s Personal Space</xsl:variable>
  <xsl:variable name="m_ModerateUser">Moderate </xsl:variable>
	<xsl:variable name="m_PostsBackTo">Back to </xsl:variable>
	<xsl:variable name="m_PostsPSpace">'s Personal Space</xsl:variable>
	<xsl:template name="m_regconfirmation">
		<P>Thank you for registering as an official <xsl:value-of select="$m_user"/>: we do hope you enjoy contributing to the Site.</P>
		<P>Please wait while you are transferred to <A xsl:use-attribute-sets="nm_regconfirmation" HREF="{$root}U{REGISTERING-USER/USER/USERID}"> your Personal Space </A>... or click the link if nothing happens.</P>
	</xsl:template>
	<xsl:template name="m_NewUsersListingHeading">
		<xsl:value-of select="$m_users"/> who have joined us in the last
<xsl:if test="number(@TIMEUNITS) &gt; 1">
			<xsl:text/>
			<xsl:value-of select="@TIMEUNITS"/>
		</xsl:if>
		<xsl:text/>
		<xsl:value-of select="@UNITTYPE"/>
		<xsl:if test="number(@TIMEUNITS) &gt; 1">s</xsl:if>:<br/>
		<br/>
	</xsl:template>
	<xsl:template name="m_NewUsersListingEmpty">
No new <xsl:value-of select="$m_users"/> have joined us in the last
<xsl:if test="number(@TIMEUNITS) &gt; 1">
			<xsl:text/>
			<xsl:value-of select="@TIMEUNITS"/>
		</xsl:if>
		<xsl:text/>
		<xsl:value-of select="@UNITTYPE"/>
		<xsl:if test="number(@TIMEUNITS) &gt; 1">s</xsl:if>.<br/>
		<br/>
	</xsl:template>
	<xsl:template name="m_notcancelled">
		<P>You have chosen <I>not</I> to cancel the account. <a xsl:use-attribute-sets="nm_notcancelled" href="{$root}U{REGISTER/USERID}">Click here to go to the Personal Space for this account.</a>
		</P>
	</xsl:template>
	<xsl:template name="m_accountcancelled">
		<P>The account has now been cancelled.</P>
	</xsl:template>
	<xsl:template name="m_abouttocancelaccount">
		<P>You are about to cancel the account for <xsl:value-of select="$m_user"/> number <xsl:value-of select="REGISTER/USERID"/>. This will remove any personal details from this account (including the email address) and de-activate it, meaning it can no longer be used. Any <xsl:value-of select="$m_postings"/> and <xsl:value-of select="$m_articles"/> created by this account will remain in the Guide, but if you cancel this account they will no longer be editable.</P>
		<P>If you want to see what this <xsl:value-of select="$m_user"/> has said on the Site, <A xsl:use-attribute-sets="nm_abouttocancelaccount" HREF="{$root}U{REGISTER/USERID}" TARGET="_blank">click here</A> to view their Personal Space in a new window.</P>
		<P>If you're sure you wish to cancel this account, and remove the email address from the site, click the button marked 'YES'. If you wish to leave it alone, click on the button marked 'NO'.</P>
	</xsl:template>
	<xsl:template name="m_sorryrejectedterms">
		<P>We're sorry you chose not to join us, but thanks for your time.</P>
		<P>
			<a xsl:use-attribute-sets="nm_sorryrejectedterms" href="{$root}Register?email={REGISTER/EMAILADDRESS}">Click here if you've changed your mind and want to accept the terms</a>.</P>
	</xsl:template>
	<xsl:template name="m_terms">
		<!-- Old Terms and Conditions went here -->
	</xsl:template>
	<xsl:template name="m_acceptblurb">
		<P>Please read the following terms and conditions. Ticking the 'I agree to these terms' check box indicates your acceptance of these terms.</P>
	</xsl:template>
	<xsl:template name="m_termsforregistered">
		<P>You have already registered with us, but perhaps you have forgotten your password. Simply type in a new password (twice to prevent mistyping) and press the 'Change password and Log In' button to change your password and log in.</P>
	</xsl:template>
	<xsl:template name="m_termserror">
		<P>You cannot activate this account because the key is wrong. Please check the link in the email and try again.</P>
	</xsl:template>
	<xsl:template name="m_accountsuspendedsince">
		<P>This account has been suspended until <xsl:apply-templates select="REGISTER/DATERELEASED/DATE"/>.</P>
	</xsl:template>
	<xsl:template name="m_accountsuspended">
		<P>This account has been suspended indefinitely.</P>
	</xsl:template>
	<xsl:template name="m_sharebademail">
		<P>The email address you entered is not valid.</P>
	</xsl:template>
	<xsl:template name="m_sharenomessage">
		<P>You must type in a message to welcome the person you're inviting.</P>
	</xsl:template>
	<xsl:template name="m_sharealreadyjoined">
		<P>The person you have nominated is already <xsl:value-of select="$m_usera"/>
			<xsl:value-of select="$m_user"/>. <a xsl:use-attribute-sets="nm_sharealreadyjoined" href="{$root}U{SHAREANDENJOY/USERID}">Click here to visit their Personal Space.</a>
		</P>
	</xsl:template>
	<xsl:template name="m_sharealreadyasked">
		<P>The person you have nominated has already been asked to join but hasn't completed their registration. Hopefully they soon will!</P>
	</xsl:template>
	<xsl:template name="m_shareunregistered">
		<P>Only registered <xsl:value-of select="$m_users"/> can invite other people to join. <a xsl:use-attribute-sets="nm_shareunregistered" href="{$sso_registerlink}">Click here to register.</a>
		</P>
	</xsl:template>
	<xsl:template name="m_sharesuccess">
		<P>We've just sent an email to your friend inviting them to join us. <a xsl:use-attribute-sets="nm_sharesuccess" href="{$root}U{SHAREANDENJOY/USERID}">Click here to go to their Personal Space.</a> Why not check up on them in a day or so to see if they have completed their registration?</P>
	</xsl:template>
	<xsl:template name="m_regwaitwelcomepage">
		<P>Your registration has been completed. Please wait while we transfer you to the Welcome Page
or <a xsl:use-attribute-sets="nm_regwaitwelcomepage" href="{$root}Welcome">click here</a> if nothing happens after a few seconds.</P>
	</xsl:template>
	<xsl:template name="m_shareandenjoyintro">
		<P>If you've got friends who you think would enjoy becoming <xsl:value-of select="$m_users"/>, then you can save them the effort of registering by sending them a special 'Share and Enjoy' invitation!</P>
		<P>Simply enter their email address below and a welcome message, and we'll take care of the rest. They'll get a personalised email containing a special fast-track registration link, and a link to your Personal Space so they can let you know when they've joined.</P>
		<P>Don't be a party-pooper - bring a friend!</P>
	</xsl:template>
	<xsl:template name="m_illegaltext">
This text cannot be displayed because it contains illegal scripting.

</xsl:template>
	<xsl:template name="m_scriptremoved">
This script section has been removed for security reasons.
</xsl:template>
	<xsl:template name="m_entrysidebarcomplaint">
		<xsl:variable name="URL">
			<xsl:choose>
				<xsl:when test="number(/H2G2/ARTICLE/ARTICLEINFO/H2G2ID) > 0">'/dna/<xsl:value-of select="/H2G2/CURRENTSITEURLNAME"/>/comments/UserComplaintPage?s_start=1&amp;h2g2id=<xsl:value-of select="/H2G2/ARTICLE/ARTICLEINFO/H2G2ID"/>'</xsl:when>
				<xsl:otherwise>'/dna/<xsl:value-of select="/H2G2/CURRENTSITEURLNAME"/>/comments/UserComplaintPage?s_start=1&amp;URL=' + escape(window.location.href)</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<font xsl:use-attribute-sets="mainfont" size="1">
Most of the content on this site is created by our <xsl:value-of select="$m_users"/>, who are members of the public. The views expressed are theirs and unless specifically stated are not those of the BBC. The BBC is not responsible for the content of any external sites referenced. In the event that you consider anything on this page to be in breach of the site's <A xsl:use-attribute-sets="nm_entrysidebarcomplaint1" HREF="{$root}HouseRules">House Rules</A>, please <a xsl:use-attribute-sets="nm_entrysidebarcomplaint2">
				<xsl:attribute name="href">javascript:popupwindow(<xsl:value-of select="$URL"/>, 'ComplaintPopup', 'status=1,resizable=1,scrollbars=1,width=640,height=480')</xsl:attribute>click here</a> to alert our Moderation Team. For any other comments, please start <xsl:value-of select="$m_threada"/>
			<xsl:value-of select="$m_thread"/> below.
</font>
	</xsl:template>
	<xsl:template name="m_pagebottomcomplaint">
		<font xsl:use-attribute-sets="mainfont" size="1">
Most of the content on this site is created by our <xsl:value-of select="$m_users"/>, who are members of the public. The views expressed are theirs and unless specifically stated are not those of the BBC. The BBC is not responsible for the content of any external sites referenced. In the event that you consider anything on this page to be in breach of the site's <A xsl:use-attribute-sets="nm_pagebottomcomplaint1" HREF="{$root}HouseRules">House Rules</A>, please
<a xsl:use-attribute-sets="nm_pagebottomcomplaint2">
				<xsl:attribute name="href"><xsl:text>javascript:popupwindow(</xsl:text><xsl:choose><xsl:when test="/H2G2/@TYPE='ARTICLE' or /H2G2/@TYPE='USERPAGE'">'/dna/<xsl:value-of select="/H2G2/CURRENTSITEURLNAME"/>/comments/UserComplaintPage?s_start=1&amp;h2g2ID=<xsl:value-of select="/H2G2/ARTICLE/ARTICLEINFO/H2G2ID"/>'</xsl:when><xsl:otherwise>'/dna/<xsl:value-of select="/H2G2/CURRENTSITEURLNAME"/>/comments/UserComplaintPage?s_start=1&amp;URL=' + escape(window.location.href)</xsl:otherwise></xsl:choose><xsl:text>, 'ComplaintPopup', 'status=1,resizable=1,scrollbars=1,width=640,height=480')</xsl:text></xsl:attribute>click here</a>. 
For any other comments, please 
<xsl:choose>
				<xsl:when test="/H2G2/@TYPE='ARTICLE' or /H2G2/@TYPE='USERPAGE'">start <xsl:value-of select="$m_threada"/>
					<xsl:value-of select="$m_thread"/> above</xsl:when>
				<xsl:otherwise>click on the Feedback button above</xsl:otherwise>
			</xsl:choose>.
</font>
	</xsl:template>
	<xsl:template name="m_forumpostingsdisclaimer">
		<font xsl:use-attribute-sets="mainfont" size="1">
Most of the content on this site is created by our <xsl:value-of select="$m_users"/>, who are members of the public. The views expressed are theirs and unless specifically stated are not those of the BBC. The BBC is not responsible for the content of any external sites referenced. In the event that you consider anything on this page to be in breach of the site's <A xsl:use-attribute-sets="nm_forumpostingsdisclaimer" TARGET="_top" HREF="{$root}HouseRules">House Rules</A>, please click on the relevant <img src="{$imagesource}buttons/complain.gif" border="0"/> button to alert our Moderation Team.
</font>
	</xsl:template>
	<xsl:template name="m_articlecomplaintdescription">
Fill in this form to register a complaint about the <xsl:value-of select="$m_article"/> '<xsl:value-of select="USER-COMPLAINT-FORM/SUBJECT"/>', edited by <xsl:apply-templates select="USER-COMPLAINT-FORM/AUTHOR/USER"/>.
</xsl:template>
	<xsl:template name="m_postingcomplaintdescription">
Fill in this form to register a complaint about the <xsl:value-of select="$m_posting"/> '<xsl:value-of select="USER-COMPLAINT-FORM/SUBJECT"/>', written by <xsl:apply-templates select="USER-COMPLAINT-FORM/AUTHOR/USER"/>.
</xsl:template>
	<xsl:template name="m_generalcomplaintdescription">
Register a complaint about the content of this page.
</xsl:template>
	<xsl:template name="m_complaintpopupseriousnessproviso">
This form is only for serious complaints about specific content that breaks the site's <A xsl:use-attribute-sets="nm_complaintpopupseriousnessproviso" HREF="{$root}HouseRules">House Rules</A>, such as unlawful, harassing, defamatory, abusive, threatening, harmful, obscene, profane, sexually oriented, racially offensive, or otherwise objectionable material.
<br/>
		<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
		<br/>
For general comments please post to the relevant <xsl:value-of select="$m_thread"/> on the site.
<hr/>
		<br/>
	</xsl:template>
	<xsl:template name="m_complaintpopupemailaddresslabel">
Please enter your email address here, so we can contact you with details of the action taken:<br/>
	</xsl:template>
	<xsl:template name="m_returninguserblurb">
		<P>This form is for reactivating a pre-BBC account only; if you already have a BBC account, then please <A xsl:use-attribute-sets="nm_returninguserblurb1" HREF="{$sso_signinlink}">sign in here</A>. Please note: to reactivate an account successfully you need to have cookies and JavaScript enabled in your browser.</P>
		<P>If you have problems converting your account, then please email <A xsl:use-attribute-sets="nm_returninguserblurb2" HREF="mailto:h2g2.support@bbc.co.uk">h2g2.support@bbc.co.uk</A> with as many details as you can give us. We'll get back to you as soon as we can.</P>
		<P>To reactivate your h2g2 account you'll have to create a BBC login name and password which you can then use to log in to your existing h2g2 account. <B>Both the BBC login name and password must be at least six characters long, can only contain letters and numbers, and are case sensitive.</B> In other words:</P>
		<UL>
			<LI>Enter a BBC login name and password for your new BBC account. If you already have a BBC account (with myBBC, for example) then enter these details.</LI>
			<LI>Enter the email address and h2g2 password from your h2g2 account.</LI>
			<LI>Finally you must agree to the site's <A xsl:use-attribute-sets="nm_returninguserblurb3" HREF="{$root}HouseRules">House Rules</A> and <A xsl:use-attribute-sets="nm_returninguserblurb4" HREF="http://www.bbc.co.uk/copyright">Terms of use</A> by ticking the box.</LI>
		</UL>
		<P>Don't worry if your preferred BBC login name is already taken - you'll only use it to log in, and it won't be shown on site.</P>
	</xsl:template>
	<xsl:template name="m_bbcregblurb">
		<P>Here's where you can register for <xsl:value-of select="$sitedisplayname"/>. If you have already registered then please log in at the <A xsl:use-attribute-sets="nm_bbcregblurb1">
				<xsl:call-template name="regpassthroughhref">
					<xsl:with-param name="url">Login</xsl:with-param>
				</xsl:call-template>login page</A>, not here.</P>
		<P>Please note that to register successfully you need to have cookies and JavaScript enabled in your browser. Also, if you already have a BBC account, then you should enter the details for that account below to avoid creating a new BBC account.</P>
		<P>To register, all you need to do is:</P>
		<UL>
			<LI>
				<P>Choose a BBC login name, which must be at least six characters long and can only contain letters and numbers.</P>
			</LI>
			<LI>
				<P>Choose a BBC password, which must also be at least six characters long, and must start with a letter or number.</P>
			</LI>
			<LI>
				<P>Then give us your email address, so we can contact you if necessary.</P>
			</LI>
			<LI>
				<P>And finally, you must agree to the site's <A xsl:use-attribute-sets="nm_bbcregblurb2" HREF="{$root}HouseRules">House Rules</A> and <A xsl:use-attribute-sets="nm_bbcregblurb3" HREF="http://www.bbc.co.uk/copyright">Terms of use</A> by ticking the box below.</P>
			</LI>
		</UL>
	</xsl:template>
	<xsl:template name="m_bbcloginblurb">
		<P>This is where you can log in to <xsl:value-of select="$sitedisplayname"/> (if you want to create a new account, first you need to <a xsl:use-attribute-sets="nm_bbcloginblurb">
				<xsl:call-template name="regpassthroughhref">
					<xsl:with-param name="url">Register</xsl:with-param>
				</xsl:call-template>register</a>). Please note you need to have cookies enabled in your browser for this to work.</P>
		<P>To log in, simply enter your BBC login name (<I>not</I> your Nickname) and your BBC password. <B>Your BBC login name and password are case sensitive.</B> If you have a BBC account but you haven't logged in to <xsl:value-of select="$sitedisplayname"/> before, you may be asked to retype your password and accept our Terms of use.</P>
	</xsl:template>
	<!-- ********************************************** -->
	<xsl:template name="m_monthsummaryblurb">
		<P>Missed any of the new <xsl:value-of select="$m_articles"/> over the last month? With our guarantee to bring you at least five <xsl:value-of select="$m_articles"/> per working day there's plenty of them coming at you thick and fast, but don't worry, you can always pop along to this page to see a summary of the last month's worth of newbies.</P>
	</xsl:template>
	<xsl:template name="m_userpagehidden">
		<xsl:choose>
			<xsl:when test="$ownerisviewer = 1">
				<P>Your Personal Space Introduction has been hidden, because it contravenes our <A xsl:use-attribute-sets="nm_userpagehidden1" HREF="{$root}HouseRules">House Rules</A> in some way - you have been sent an email explaining why.</P>
				<P>You can easily re-write your Introduction so that it doesn't break the rules, which will make it appear immediately. Simply click on the 'Edit Page' button, make any changes to ensure that your Introduction doesn't break the rules, and click on 'Update Introduction'.</P>
			</xsl:when>
			<xsl:otherwise>
				<P>This Personal Space Introduction has been hidden, because it contravenes our <A xsl:use-attribute-sets="nm_userpagehidden2" HREF="{$root}HouseRules">House Rules</A> in some way. However, the author can easily re-write their Introduction so that it doesn't break the rules, so let's hope they do just that.</P>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="m_articlehiddentext">
		<xsl:choose>
			<xsl:when test="$ownerisviewer = 1">
				<P xsl:use-attribute-sets="ArticleText">Your <xsl:value-of select="$m_article"/> has been hidden, because it contravenes our <A xsl:use-attribute-sets="nm_articlehiddentext1" HREF="{$root}HouseRules">House Rules</A> in some way.</P>
				<P xsl:use-attribute-sets="ArticleText">You can easily re-write your <xsl:value-of select="$m_article"/> so that it doesn't break the rules, which will make it appear immediately. Simply click on the 'Edit <xsl:value-of select="$m_article"/>' button, make any changes to ensure that your <xsl:value-of select="$m_article"/> doesn't break the rules, and click on 'Update <xsl:value-of select="$m_article"/>'.</P>
			</xsl:when>
			<xsl:otherwise>
				<P xsl:use-attribute-sets="ArticleText">This <xsl:value-of select="$m_article"/> has been hidden, because it contravenes our <A xsl:use-attribute-sets="nm_articlehiddentext2" HREF="{$root}HouseRules">House Rules</A> in some way. However, the author can easily re-write it so that it doesn't break the rules, so let's hope they do just that.</P>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="m_articledeletedbody">
		<!-- attribute-set has been added as the p tag sets the font colour to be the default, and this may not be required: -->
		<P xsl:use-attribute-sets="ArticleText">This <xsl:value-of select="$m_article"/> has been deleted from the Site by the author.</P>
		<P xsl:use-attribute-sets="ArticleText">We apologise for this interruption to your surfing.</P>
	</xsl:template>
	
<xsl:template name="m_postawaitingmoderation">
This <xsl:value-of select="$m_posting"/> has been temporarily hidden, because a member of our Moderation Team has referred it to the Community Team for a decision as to whether it contravenes the <A xsl:use-attribute-sets="nm_postawaitingmoderation" TARGET="_top" HREF="{$root}HouseRules">House Rules</A> in some way. We will do everything we can to ensure that a decision is made as quickly as possible.
</xsl:template>
	
<xsl:template name="m_postawaitingpremoderation">
This <xsl:value-of select="$m_posting"/> is currently queued for moderation, and will be visible as soon as a member of our Moderation Team has approved it (assuming it doesn't contravene the <A xsl:use-attribute-sets="nm_postawaitingpremoderation" TARGET="_top" HREF="{$root}HouseRules">House Rules</A>). The <xsl:value-of select="$m_user"/> who posted it is currently being pre-moderated, so all new <xsl:value-of select="$m_postings"/> they make must be checked before they become visible.
</xsl:template>

<xsl:template name="m_postremoved">
This <xsl:value-of select="$m_posting"/> has been hidden during moderation because it broke the <A xsl:use-attribute-sets="nm_postremoved" TARGET="_top" HREF="{$root}HouseRules">House Rules</A> in some way.
</xsl:template>

<xsl:template name="m_postcomplaint">
This <xsl:value-of select="$m_posting"/> has been temporarily hidden by a member of the Community Team and referred to the Moderation Team for a decision as to whether it contravenes the <A xsl:use-attribute-sets="nm_postawaitingmoderation" TARGET="_top" HREF="{$root}HouseRules">House Rules</A> in some way. We will do everything we can to ensure that a decision is made as quickly as possible.
</xsl:template>

	<xsl:variable name="m_changepasswordexternal">
		<!--
If you want to change your password, you can do so by 
	<A xsl:use-attribute-sets="nm_changepasswordexternal" 
	HREF="http://www.bbc.co.uk/cgi-perl/mybbc/mybbc?profileEditor=1" TARGET="profilewin" 
	onclick="popupwindow('http://www.bbc.co.uk/cgi-perl/mybbc/mybbc?profileEditor=1','profilewin','width=272,height=450,scrollbars=yes,resizable=yes,status=yes')">editing 
	your global BBC user identity</A>.
-->
	</xsl:variable>
	<xsl:variable name="m_newerentries">&lt;&lt; Newer Entries</xsl:variable>
	<xsl:variable name="m_olderentries">Older Entries &gt;&gt;</xsl:variable>
	<xsl:template name="m_unregistereduserediterror">
		<P>We're sorry, but you can't create or edit <xsl:value-of select="$m_articles"/> until you've signed in.</P>
		<UL>
			<LI>
				<P>If you already have an account, please <A xsl:use-attribute-sets="nm_unregistereduserediterror1" href="{$sso_noarticlesigninlink}">click here to sign in</A>.</P>
			</LI>
			<LI>
				<P>If you haven't already registered with us as a 
member, please <a xsl:use-attribute-sets="nm_unregistereduserediterror2" href="{$sso_noarticleregisterlink}">click here to become a member</a>. Creating your membership is free and will enable you to share your wisdom with the rest of the Community. <a xsl:use-attribute-sets="nm_unregistereduserediterror3" href="A387317">Tell me more!</a>.</P>
			</LI>
		</UL>
	</xsl:template>
	<xsl:template name="m_RecommendEntrySubmitSuccessMessage">
		<p>
			<xsl:value-of select="$m_article"/> was submitted for recommendation successfully.</p>
	</xsl:template>
	<xsl:template name="m_ModerationFailureMenuItems">
		<!--
		<option value="None" selected="selected">Failure reason:</option>
		<option value="OffensiveInsert">Offensive</option>
		<option value="LibelInsert">Libellous</option>
		<option value="URLInsert">Unsuitable/Broken URL</option>
		<option value="PersonalInsert">Personal Details</option>
		<option value="AdvertInsert">Advertising</option>
		<option value="CopyrightInsert">Copyright Material</option>
		<option value="PoliticalInsert">Contempt Of Court</option>
		<option value="IllegalInsert">Illegal Activity</option>
		<option value="SpamInsert">Spam</option>
		<option value="ForeignLanguage">Foreign Language</option>
		<xsl:if test="/H2G2/VIEWING-USER/USER/GROUPS/EDITOR">
			<option value="CustomInsert">Custom (enter below)</option>
		</xsl:if>
		-->
		<!-- Generate Moderation Failure Menu Items from XML - extendable-->
		<option value="None" selected="selected">Failure reason:</option>
		<xsl:for-each select="/H2G2/MOD-REASONS/MOD-REASON">
			<xsl:if test="(@EDITORSONLY = 0) or ($test_IsEditor)">
				<option value="{@EMAILNAME}"><xsl:value-of select="@DISPLAYNAME"/></option>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="m_agreetoterms">
I agree to the <A xsl:use-attribute-sets="nm_agreetoterms1" HREF="{$root}HouseRules">House Rules</A> and the <A xsl:use-attribute-sets="nm_agreetoterms2" HREF="http://www.bbc.co.uk/copyright">Terms of use</A>
	</xsl:template>
	<xsl:template name="m_articlereferredtext">
		<xsl:choose>
			<xsl:when test="$ownerisviewer = 1">
				<P xsl:use-attribute-sets="ArticleText">Your <xsl:value-of select="$m_article"/> has been temporarily hidden, because a member of our Moderation Team has referred it to the Community Team for a decision as to whether it contravenes the <A xsl:use-attribute-sets="nm_articlereferredtext1" HREF="{$root}HouseRules">House Rules</A> in some way. We will do everything we can to ensure that a decision is made as quickly as possible.</P>
				<P xsl:use-attribute-sets="ArticleText">Please do not try to edit your <xsl:value-of select="$m_article"/> in the meantime, as this will only mean it gets checked by the Moderation Team twice.</P>
			</xsl:when>
			<xsl:otherwise>
				<P xsl:use-attribute-sets="ArticleText">This <xsl:value-of select="$m_article"/> has been temporarily hidden, because a member of our Moderation Team has referred it to the Community Team for a decision as to whether it contravenes the <A xsl:use-attribute-sets="nm_articlereferredtext2" HREF="{$root}HouseRules">House Rules</A> in some way. We will do everything we can to ensure that a decision is made as quickly as possible.</P>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="m_articleawaitingpremoderationtext">
		<xsl:choose>
			<xsl:when test="$ownerisviewer = 1">
				<P xsl:use-attribute-sets="ArticleText">Your <xsl:value-of select="$m_articles"/> are being pre-moderated and will only appear after they have been approved by a Moderator. Your <xsl:value-of select="$m_article"/> is now queued for moderation, and will be visible as soon as a member of our Moderation Team has approved it (assuming it doesn't contravene the <A xsl:use-attribute-sets="nm_articleawaitingpremoderationtext1" HREF="{$root}HouseRules">House Rules</A>).</P>
			</xsl:when>
			<xsl:otherwise>
				<P xsl:use-attribute-sets="ArticleText">This <xsl:value-of select="$m_article"/> is currently queued for moderation, and will be visible as soon as a member of our Moderation Team has approved it (assuming it doesn't contravene the <A xsl:use-attribute-sets="nm_articleawaitingpremoderationtext2" HREF="{$root}HouseRules">House Rules</A>). The <xsl:value-of select="$m_user"/> who posted it is currently being pre-moderated, so all new <xsl:value-of select="$m_articles"/> they make must be checked before they become visible.</P>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="m_legacyarticleawaitingmoderationtext">
		<xsl:choose>
			<xsl:when test="$ownerisviewer = 1">
				<P xsl:use-attribute-sets="ArticleText">Your <xsl:value-of select="$m_article"/> is currently hidden, because it needs to be reactivated before it's visible, as part of our moderation system.</P>
				<P xsl:use-attribute-sets="ArticleText">To make it visible, simply click on the 'Edit Page' button, check that your <xsl:value-of select="$m_article"/> doesn't break the <A xsl:use-attribute-sets="nm_legacyarticleawaitingmoderationtext" HREF="{$root}HouseRules">House Rules</A>, and click on 'Update <xsl:value-of select="$m_article"/>'. It will appear instantly.</P>
			</xsl:when>
			<xsl:otherwise>
				<P xsl:use-attribute-sets="ArticleText">This <xsl:value-of select="$m_article"/> is currently hidden, because the author has not yet returned to reactivate it. If they do not return, then in time our Moderation Team will reactivate it instead, as they work through all the content that was created before moderation was introduced.</P>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="m_userpagereferred">
		<xsl:choose>
			<xsl:when test="$ownerisviewer = 1">
				<P>Your Personal Space Introduction has been temporarily hidden, because a member of our Moderation Team has referred it to the Community Team for a decision as to whether it contravenes the <A xsl:use-attribute-sets="nm_userpagereferred1" HREF="{$root}HouseRules">House Rules</A> in some way. We will do everything we can to ensure that a decision is made as quickly as possible.</P>
				<P>Please do not try to edit your Introduction in the meantime, as this will only mean it gets checked by the Moderation Team twice.</P>
			</xsl:when>
			<xsl:otherwise>
				<P>This Personal Space Introduction has been temporarily hidden, because a member of our Moderation Team has referred it to the Community Team for a decision as to whether it contravenes the <A xsl:use-attribute-sets="nm_userpagereferred2" HREF="{$root}HouseRules">House Rules</A> in some way. We will do everything we can to ensure that a decision is made as quickly as possible.</P>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="m_userpagependingpremoderation">
		<xsl:choose>
			<xsl:when test="$ownerisviewer = 1">
				<P>Your <xsl:value-of select="$m_articles"/> are being pre-moderated and will only appear after they have been approved by a Moderator. Your Personal Space Introduction is now queued for moderation, and will be visible as soon as a member of our Moderation Team has approved it (assuming it doesn't contravene the <A xsl:use-attribute-sets="nm_userpagependingpremoderation1" HREF="{$root}HouseRules">House Rules</A>).</P>
			</xsl:when>
			<xsl:otherwise>
				<P>This Personal Space Introduction is currently queued for moderation, and will be visible as soon as a member of our Moderation Team has approved it (assuming it doesn't contravene the <A xsl:use-attribute-sets="nm_userpagependingpremoderation2" HREF="{$root}HouseRules">House Rules</A>). The <xsl:value-of select="$m_user"/> who edited it is currently being pre-moderated, so all new <xsl:value-of select="$m_articles"/> they make must be checked before they become visible.</P>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="m_legacyuserpageawaitingmoderation">
		<xsl:choose>
			<xsl:when test="$ownerisviewer = 1">
				<P>Your Personal Space Introduction is currently hidden, because it needs to be reactivated before it's visible, as part of the moderation system.</P>
				<P>To make it visible, simply click on the 'Edit Page' button, check that your Introduction doesn't break the <A xsl:use-attribute-sets="nm_legacyuserpageawaitingmoderation" HREF="{$root}HouseRules">House Rules</A>, and click on 'Update Introduction'. It will appear instantly.</P>
			</xsl:when>
			<xsl:otherwise>
				<P>This Personal Space Introduction is currently hidden, because the author has not yet returned to reactivate it. If they do not return, then in time our Moderation Team will reactivate it instead, as they work through all the content that was created before moderation was introduced.</P>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="m_articlepremodblurb">
		<p>The site is currently being pre-moderated. This means that you can create and edit <xsl:value-of select="$m_articles"/> normally, but they will not be visible until they have been approved by a Moderator.</p>
	</xsl:template>
	<xsl:template name="m_submitentryblurb"/>
	<!--	<xsl:template name="m_submitentryblurb">
		<P>
			<FONT SIZE="+1">
				<STRONG>Submitting your <xsl:value-of select="$m_article"/> for official approval</STRONG>
			</FONT>
		</P>
		<P>	This <xsl:value-of select="$m_article"/> has already been submitted to the Editors for approval. If
			you want to make any changes to it though, go right ahead, because they
			will always look at the most recent version of any <xsl:value-of select="$m_article"/> before approving
			it.
		</P>
		<P>	However if you've changed your mind and don't want the Editors to consider
			your <xsl:value-of select="$m_article"/> and would rather muck around with it until you're happier,
			then just press the button below and it will be taken off the list of
			submitted <xsl:value-of select="$m_articles"/>.
		</P>
	</xsl:template>
-->
	<xsl:template name="m_movesubject">
Move Subject
</xsl:template>
	<xsl:template name="m_comingupintro">
		<BR/>
		<P>
This page shows what's coming up, and currently going through our editorial process.
</P>
	</xsl:template>
	<xsl:template name="m_cominguprecintro">
		<P>
These <xsl:value-of select="$m_articles"/> have been accepted from the scouts, but haven't been sent to a subeditor yet.
</P>
	</xsl:template>
	<xsl:template name="m_comingupwitheditorintro">
		<P>
Copies of these <xsl:value-of select="$m_articles"/> have been sent to a subeditor and are being edited.
</P>
	</xsl:template>
	<xsl:template name="m_comingupreturnintro">
		<P>
These <xsl:value-of select="$m_articles"/> have been returned from the subeditor and are awaiting final polishing.
</P>
	</xsl:template>
	<xsl:template name="m_editcatRenameSubject">
Rename Subject
</xsl:template>
	<xsl:template name="m_editcatRenameDescription">
Rename Description
</xsl:template>
	<xsl:template name="m_editcatMoveSubject">
Move Subject
</xsl:template>
	<xsl:template name="m_editcatDeleteSubject">
Delete Subject
</xsl:template>
	<xsl:template name="m_editcatAddSubject">
Add a subject
</xsl:template>
	<xsl:template name="m_editcatDeleteSubjectLink">
Delete Subject Link
</xsl:template>
	<xsl:template name="m_editcatMoveSubjectLink">
Move Subject Link
</xsl:template>
	<xsl:template name="m_editcatMoveArticle">
Move <xsl:value-of select="$m_article"/>
	</xsl:template>
	<xsl:template name="m_editcatDeleteArticle">
Delete <xsl:value-of select="$m_article"/>
	</xsl:template>
	<xsl:template name="m_EditCatDots">
........
</xsl:template>
	<xsl:template name="m_EditCatRenameDesc">
Add/Change Description
</xsl:template>
	<xsl:template name="m_EditCatRenameSubjectButton">
Change Subject
</xsl:template>
	<xsl:template name="m_EditCatAddSubjectButton">
Add a new subject
</xsl:template>
	<xsl:template name="m_submitforreviewbutton">
		<FONT size="2">
Submit For Review
</FONT>
	</xsl:template>
	<xsl:template name="m_notforreviewbutton">
		<FONT xsl:use-attribute-sets="mainfont" size="1">
			<b>
				<xsl:value-of select="$alt_notforreview"/>
			</b>
		</FONT>
	</xsl:template>
	<xsl:template name="m_submittedtoreviewforumbutton">
		<FONT size="1">
			<xsl:value-of select="REVIEWFORUM/FORUMNAME"/>
		</FONT>
	</xsl:template>
	<xsl:template name="m_currentlyinreviewforum">
		<FONT xsl:use-attribute-sets="mainfont" size="1">
			<b>
Currently in: </b>
		</FONT>
	</xsl:template>
	<xsl:template name="m_rft_articleheader">
		<b>
			<xsl:value-of select="$m_article"/>
		</b>
	</xsl:template>
	<xsl:template name="m_rft_selectlastposted">
		<b>
			<i>Last Posted</i>
		</b>
	</xsl:template>
	<xsl:template name="m_rft_lastposted">
		<b>Last Posted</b>
	</xsl:template>
	<xsl:template name="m_rft_selectdateentered">
		<b>
			<i>Date Entered</i>
		</b>
	</xsl:template>
	<xsl:template name="m_rft_dateentered">
		<b>Date Entered</b>
	</xsl:template>
	<xsl:template name="m_rft_selectauthor">
		<b>
			<i>Author</i>
		</b>
	</xsl:template>
	<xsl:template name="m_rft_author">
		<b>Author</b>
	</xsl:template>
	<xsl:template name="m_rft_selecth2g2id">
		<b>
			<i>
				<xsl:value-of select="$m_article"/>
			</i>
		</b>
	</xsl:template>
	<xsl:template name="m_rft_h2g2id">
		<b>
			<xsl:value-of select="$m_article"/>
		</b>
	</xsl:template>
	<xsl:template name="m_rft_subject">
		<b>Subject</b>
	</xsl:template>
	<xsl:template name="m_rft_selectsubject">
		<b>
			<i>Subject</i>
		</b>
	</xsl:template>
	<xsl:template name="m_removefromreviewforum">
Remove
</xsl:template>
	<xsl:template name="m_searchresultsthissite">
The following results were found in <xsl:value-of select="$m_sitetitle"/>
	</xsl:template>
	<xsl:template name="m_searchresultsothersites">
These results were found in other sites
</xsl:template>
	<xsl:template name="m_recommendentrybutton">
Recommend <xsl:value-of select="$m_article"/>
	</xsl:template>
	<xsl:template name="m_sitechangemessage">
		<P>
The link you clicked on will take you out of this site. Think very carefully about this. 
Are you sure you want to leave our fluffy environs? It's a big bad world out there in the
rest of DNA, and it might not be safe for everybody. Your choice.
</P>
		<P>
			<A xsl:use-attribute-sets="nm_sitechangemessage" href="/dna/{SITECHANGE/SITENAME}/{SITECHANGE/URL}">Click here to continue on...</A>
		</P>
	</xsl:template>
	<xsl:template name="m_rft_selectauthorid">
		<b>
			<i>Author ID</i>
		</b>
	</xsl:template>
	<xsl:template name="m_rft_authorid">
		<b>Author ID</b>
	</xsl:template>
	<xsl:template name="m_submitarticlefirst_text">
		<br/>A<xsl:value-of select="../ARTICLE/@H2G2ID"/> - <xsl:value-of select="../ARTICLE"/>
		<br/>
		<br/>
To put this <xsl:value-of select="$m_article"/> into review, select the relevant Review Forum and enter your comments below.
</xsl:template>
	<xsl:template name="m_submitarticlelast_text">
For more information about Review Forums, please read the Review Forum FAQ.
<br/>
		<br/>
		<A xsl:use-attribute-sets="nm_submitarticlelast_text">
			<xsl:attribute name="HREF">A<xsl:value-of select="../ARTICLE/@H2G2ID"/></xsl:attribute>
Click here to return to the <xsl:value-of select="$m_article"/> without putting it into a Review Forum</A>
	</xsl:template>
	<xsl:template name="m_inreviewtextandlink">
The <xsl:value-of select="$m_article"/> you are trying to delete is currently in the Review Forum '<xsl:value-of select="INREVIEW/REVIEWFORUM/FORUMNAME"/>'. <br/>
		<br/>
If you would like to remove the <xsl:value-of select="$m_article"/> from '<xsl:value-of select="INREVIEW/REVIEWFORUM/FORUMNAME"/>' and delete it then click <A xsl:use-attribute-sets="nm_inreviewtextandlink1">
			<xsl:attribute name="HREF"><xsl:value-of select="$root"/>UserEdit<xsl:value-of select="INREVIEW/ARTICLE/@H2G2ID"/>?cmd=deletereview</xsl:attribute>here</A>.<br/>
		<br/>
Alternatively you can go back to <A xsl:use-attribute-sets="nm_inreviewtextandlink2">
			<xsl:attribute name="HREF"><xsl:value-of select="$root"/>UserEdit<xsl:value-of select="INREVIEW/ARTICLE/@H2G2ID"/></xsl:attribute>editing the <xsl:value-of select="$m_article"/> without deleting it</A>.<br/>
	</xsl:template>
	<xsl:template name="m_removefromreviewsuccesslink">
The <xsl:value-of select="$m_article"/>
		<xsl:text> </xsl:text>
		<A xsl:use-attribute-sets="nm_removefromreviewsuccesslink1">
			<xsl:attribute name="HREF"><xsl:value-of select="$root"/>A<xsl:value-of select="H2G2ID"/></xsl:attribute>
			<xsl:value-of select="SUBJECT"/>
		</A> has been successfully removed from the Review Forum '<A xsl:use-attribute-sets="nm_removefromreviewsuccesslink2">
			<xsl:attribute name="HREF"><xsl:value-of select="$root"/>RF<xsl:value-of select="REVIEWFORUM/@ID"/></xsl:attribute>
			<xsl:value-of select="REVIEWFORUM/REVIEWFORUMNAME"/>
		</A>'.<br/>
		<br/>
The relevant Review <xsl:value-of select="$m_thread"/> has been moved to the <xsl:value-of select="$m_forum"/> for the <xsl:value-of select="$m_article"/> itself, and the <xsl:value-of select="$m_article"/> will no longer appear in any Review Forums.
</xsl:template>
	<xsl:template name="m_crumbtrail_divider">
|
</xsl:template>
	<xsl:template name="m_cantpostrestricted">
		<p>
We're sorry, but you are restricted from posting to this site.
</p>
	</xsl:template>
	<xsl:template name="m_articleuserpremodblurb">
		<p>
			<b>Please note:</b> Your <xsl:value-of select="$m_articles"/> are being pre-moderated and will only appear after they have been approved by a Moderator.
</p>
	</xsl:template>
	<xsl:template name="m_posthasbeenpremoderated">
Thank you for posting. Your <xsl:value-of select="$m_posting"/> will be checked by our Moderation Team and will appear on the site once it has been approved. If you just started a new <xsl:value-of select="$m_thread"/>, it will only appear on your Personal Space after it has been approved.<br/>
		<xsl:choose>
			<xsl:when test="number(@NEWCONVERSATION)=1">
				<a xsl:use-attribute-sets="nm_posthasbeenpremoderated1" href="{$root}F{@FORUM}">Click here to return to the <xsl:value-of select="$m_forum"/>
				</a>
				<br/>
			</xsl:when>
			<xsl:otherwise>
				<a xsl:use-attribute-sets="nm_posthasbeenpremoderated2" href="{$root}F{@FORUM}?thread={@THREAD}&amp;post={@POST}">Click here to return to the <xsl:value-of select="$m_thread"/>
				</a>
				<br/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="m_posthasbeenqueued">
Thank you for posting. Your <xsl:value-of select="$m_posting"/> has been placed in a queue and will appear on the site shortly. If you just started a new <xsl:value-of select="$m_thread"/>, 
it will only appear on your Personal Space after it has been posted.<br/>
		<xsl:choose>
			<xsl:when test="@THREAD">
				<a xsl:use-attribute-sets="nm_posthasbeenpremoderated2" href="{$root}F{@FORUM}?thread={@THREAD}&amp;post={@POST}">Click here to return to the <xsl:value-of select="$m_thread"/>
				</a>
				<br/>
			</xsl:when>
			<xsl:otherwise>
				<a xsl:use-attribute-sets="nm_posthasbeenpremoderated1" href="{$root}F{@FORUM}">Click here to return to the <xsl:value-of select="$m_forum"/>
				</a>
				<br/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="m_posthasbeenautopremoderated">
<font size="2">
Thank you for posting to the <xsl:value-of select="/H2G2/SITECONFIG/BOARDNAME"/> message boards.<br/>
All posts by new message board members are pre-moderated.  This means that your first few postings will not appear on the message board immediately, as they need to be checked by a moderator first.   After you have used the BBC message boards for a while, you will become a trusted user and your posts will appear on the board as soon as you post them.<br/>
The BBC receives thousands of messages every day so please be patient.<br/><br/>	
		<xsl:choose>
			<xsl:when test="number(@NEWCONVERSATION)=1">
				<a xsl:use-attribute-sets="nm_posthasbeenpremoderated1" href="{$root}F{@FORUM}">Click here to return to the <xsl:value-of select="/H2G2/SITECONFIG/BOARDNAME"/> message boards
				</a>
				<br/>
			</xsl:when>
			<xsl:otherwise>
				<a xsl:use-attribute-sets="nm_posthasbeenpremoderated2" href="{$root}F{@FORUM}?thread={@THREAD}&amp;post={@POST}">Click here to return to the <xsl:value-of select="/H2G2/SITECONFIG/BOARDNAME"/> message boards
				</a>
				<br/>
			</xsl:otherwise>
		</xsl:choose>
</font>		
	</xsl:template>
	<xsl:template name="m_entrysubmittedtoreviewforum">
		<p>
			<br/>The <xsl:value-of select="$m_article"/>
			<xsl:text> </xsl:text>
			<A xsl:use-attribute-sets="nm_entrysubmittedtoreviewforum1">
				<xsl:attribute name="href">A<xsl:value-of select="../ARTICLE/@H2G2ID"/></xsl:attribute>
				<xsl:value-of select="../ARTICLE"/>
			</A> has been successfully submitted to the Review Forum
'<A xsl:use-attribute-sets="nm_entrysubmittedtoreviewforum2">
				<xsl:attribute name="href">RF<xsl:value-of select="REVIEWFORUM/@ID"/></xsl:attribute>
				<xsl:value-of select="REVIEWFORUM/FORUMNAME"/>
			</A>'. <br/>
			<br/>
You can find the Review <xsl:value-of select="$m_thread"/> at 
<A xsl:use-attribute-sets="nm_entrysubmittedtoreviewforum3">
				<xsl:attribute name="href">F<xsl:value-of select="@FORUMID"/>?thread=<xsl:value-of select="@THREADID"/></xsl:attribute>F<xsl:value-of select="@FORUMID"/>?thread=<xsl:value-of select="@THREADID"/>
			</A>
		</p>
	</xsl:template>
	<xsl:template name="m_notforreview_explanation">
		<font use-attribute-sets="mainfont" size="1">
				Tick the 'Not for Review' box if you <I>don't</I> want your <xsl:value-of select="$m_article"/> to be available for review (see the <A xsl:use-attribute-sets="nm_notforreview_explanation" HREF="DontPanic-ReviewForums">Review Forums FAQ</A> for more information)
</font>
	</xsl:template>
	<xsl:template name="m_passthroughwelcomeback">
		<!-- This is a generic message when someone has just logged in while doing a passthrough -->
You are now signed in - welcome back!<br/>
		<br/>
	</xsl:template>
	<xsl:template name="m_passthroughnewuser">
		<!-- This is a generic message when someone has just registered while doing a passthrough -->
Welcome. You're registered now, so the 'My Space' button will take you
to your Personal Space, where you can write something about yourself.<br/>
	</xsl:template>
	<xsl:template name="m_ptwriteguideentry">
		<!-- this is the message that is displayed after a login/registration started from the UserEdit page. -->
		<a xsl:use-attribute-sets="nm_ptwriteguideentry" href="{$root}UserEdit">Click here to write your <xsl:value-of select="$m_article"/>
		</a>
	</xsl:template>
	<xsl:template name="m_restricteduserpreferencesmessage">
Sorry, you are not allowed to change your Preferences.
</xsl:template>
	<xsl:template name="m_notfoundbody">
		<P>We're sorry, but the page you have requested does not exist. 
This could be because the URL<A xsl:use-attribute-sets="nm_notfoundbody1" TITLE="That's the address of the web page that we can't find - it should begin with http://www.bbc.co.uk{$root}" NAME="back1" HREF="#footnote1">
				<SUP>1</SUP>
			</A> is wrong, 
or because the page you are looking for has been removed from the Site.</P>
		<P>We apologise for this interruption in your surfing, and hope the tide comes back in soon.</P>
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
	<xsl:template name="m_unregprefsmessage">
		<p>Please <a href="{$sso_signinlink}">sign in</a> to change your nickname</p>
		<!--p>If you have forgotten your password, enter your BBC Login Name (<b>not</b> your nickname)
	and the email address you used to register. A new password will be created and emailed to you.
	If you can't remember your login name, use your user number (the number which came after the U on your user page).</p-->
	</xsl:template>
	<xsl:template name="m_changepasswordmessage"/>
	<xsl:template name="m_backtopageforposts"/>
	<xsl:template name="m_backtopage"/>
	<xsl:template name="m_olderentries"/>
	<xsl:template name="m_newerentries"/>
	<!-- This exists for uploading purposes - tw -->
	<xsl:variable name="m_changepasswordmessage">To change your password, 
		enter your original password, then your new password twice. 
		You will also need to enter your original password to change 
		your email address. If you can't remember your password, we 
		can <a xsl:use-attribute-sets="nm_changepasswordmessage" href="{$m_changepasswordmessageURL}">email you a new one</a>.
	</xsl:variable>
	<xsl:variable name="m_changepasswordmessageURL">
		<xsl:value-of select="$root"/>UserDetails?unregcmd=yes</xsl:variable>
	<xsl:template name="m_nameremovedfromresearchers">
	Your name has been removed from the list of Researchers for the <xsl:value-of select="$m_article"/>
		<xsl:text> </xsl:text>
		<a xsl:use-attribute-sets="nm_nameremovedfromresearchers" href="{$root}A{H2G2ID}">
			<xsl:apply-templates select="SUBJECT" mode="nosubject"/>
		</a>.
	</xsl:template>
	<xsl:template name="m_namenotremovedfromresearchers">
		Your name could not be removed from the list of Researchers for the <xsl:value-of select="$m_article"/>
		<xsl:text> </xsl:text>
		<a xsl:use-attribute-sets="nm_namenotremovedfromresearchers" href="{$root}A{H2G2ID}">
			<xsl:apply-templates select="SUBJECT" mode="nosubject"/>
		</a>
		<xsl:choose>
			<xsl:when test="@REASON='unregistered'">
			because you are not logged in.
			</xsl:when>
			<xsl:when test="@REASON='iseditor'">
			because you are the Editor of the <xsl:value-of select="$m_article"/>.
			</xsl:when>
			<xsl:when test="@REASON='notresearcher'">
			because you aren't on the Researcher list.
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="m_guideentryrestored">
		Your <xsl:value-of select="$m_article"/>
		<xsl:text> </xsl:text>
		<a xsl:use-attribute-sets="nm_guideentryrestored1" href="{$root}A{H2G2ID}">
			<xsl:apply-templates select="SUBJECT" mode="nosubject"/>
		</a> has been restored. 
		If you wish to edit this <xsl:value-of select="$m_article"/>
		<a xsl:use-attribute-sets="nm_guideentryrestored2" href="{$root}UserEdit{H2G2ID}"> click here</a>.
	</xsl:template>
	<xsl:template name="m_udbaddpassword">
		Your password could not be changed because you entered the wrong original password.

</xsl:template>
	<xsl:template name="m_udinvalidpassword">
You entered an invalid password. Passwords must be at least 6 characters long.
</xsl:template>
	<xsl:template name="m_udunmatchedpasswords">
You mistyped one of the two new passwords.
</xsl:template>
	<xsl:template name="m_udbaddpasswordforemail">
Your email address could not be changed because you have entered the wrong original password.
</xsl:template>
	<xsl:template name="m_udnewpasswordsent">
A new password has been sent to your email address.
</xsl:template>
	<xsl:template name="m_udnewpasswordfailed">
A new password could not be sent because the login name or user number you entered was not valid, or 
		did not match the email address you provided.
		</xsl:template>
	<xsl:template name="m_uddetailsupdated">
Your details have been updated
</xsl:template>
	<xsl:template name="m_udskinset">
Your new skin has been set.
</xsl:template>
	<xsl:template name="m_udrestricteduser">
You are not permitted to change your details.
</xsl:template>
	<xsl:template name="m_udinvalidemail">
The email address you typed is invalid.
</xsl:template>
  <xsl:template name="m_udusernamepremoderated">
    Your nickname change has been queued for moderation.
  </xsl:template>
	<xsl:template name="m_nopermissiontoedit">
		You do not have permission to delete this <xsl:value-of select="$m_article"/>.
  </xsl:template>
	<xsl:template name="m_spacingaboveudetails">
		<br/>
	</xsl:template>
	<xsl:template name="m_unrecognisedcommand">
The request did not contain a valid command.
</xsl:template>
	<xsl:template name="m_unspecifiederror">
An unknown error occured whilst processing your request.
</xsl:template>
	<xsl:template name="m_guideentrydeleted">
Your <xsl:value-of select="$m_article"/> has been deleted. If you want to restore any deleted <xsl:value-of select="$m_articles"/> you can view them 
<a use-attribute-sets="nm_guideentrydeleted">
			<xsl:attribute name="href">MA<xsl:value-of select="USERID"/>&amp;type=3</xsl:attribute>on this page</a>.
</xsl:template>
	<xsl:template name="m_peoplewatchingyou">
	The following people have you on their friends lists:<br/>
		<br/>
	</xsl:template>
	<xsl:template name="m_youhavenousers">
	When people add you to their friends list, their names will appear here.<br/>
	</xsl:template>
	<xsl:template name="m_userswatchingusers">
	The following people have <xsl:value-of select="/H2G2/PAGE-OWNER/USER/USERNAME"/> on their friends lists:<br/>
		<br/>
	</xsl:template>
	<xsl:template name="m_textonlylink">
		<a href="http://www.bbc.co.uk/cgi-bin/education/betsie/parser.pl" xsl:use-attribute-sets="nm_textonlylink">
			<xsl:value-of select="$m_textonly"/>
		</a>
	</xsl:template>
	<xsl:template name="m_mailtofriend">Like this page?<br/>
		<a onClick="popmailwin('http://www.bbc.co.uk/cgi-bin/navigation/mailto.pl?GO=1','Mailer')" href="http://www.bbc.co.uk/cgi-bin/navigation/mailto.pl?GO=1" target="Mailer" xsl:use-attribute-sets="nm_mailtofriend">
			<xsl:value-of select="$m_sendtofriend"/>
		</a>
	</xsl:template>
	<!-- end of templates -->
	<!-- text in the user details box on a personal space -->
	<xsl:variable name="m_userdata">
		<xsl:value-of select="$m_user"/> Data</xsl:variable>
	<xsl:variable name="m_researcher">
		<xsl:value-of select="$m_user"/>
		<xsl:text> </xsl:text>
	</xsl:variable>
	<xsl:variable name="m_namecolon">Name: </xsl:variable>
	<xsl:variable name="m_otherconv">Other <xsl:value-of select="$m_threads"/>
	</xsl:variable>
	<xsl:variable name="m_currentconv">Current <xsl:value-of select="$m_thread"/>
	</xsl:variable>
	<xsl:variable name="m_forumtitle">BBC - <xsl:value-of select="$m_forum"/>
	</xsl:variable>
	<xsl:variable name="m_currentyear">MMIV</xsl:variable>
	<xsl:variable name="m_copyright">(c) BBC <xsl:value-of select="$m_currentyear"/>
	</xsl:variable>
	<xsl:variable name="m_entrydata">
		<xsl:value-of select="$m_article"/> Data</xsl:variable>
	<xsl:variable name="m_idcolon">
		<xsl:value-of select="$m_article"/> ID: </xsl:variable>
	<xsl:variable name="m_datecolon">Date: </xsl:variable>
	<xsl:variable name="m_edited"> (Edited)</xsl:variable>
	<xsl:variable name="m_unedited"> (Unedited)</xsl:variable>
	<xsl:variable name="m_helppage"> (Help Page)</xsl:variable>
	<xsl:variable name="m_entrydatarecommendedstatus"> (Recommended)</xsl:variable>
	<xsl:variable name="m_lastposting">Last <xsl:value-of select="$m_posting"/>: </xsl:variable>
	<xsl:variable name="m_peopletalking">People have been talking about this <xsl:value-of select="$m_article"/>. Here are the most recent <xsl:value-of select="$m_threads"/>:</xsl:variable>
	<xsl:variable name="m_firsttotalk">Click here to be the first person to discuss this <xsl:value-of select="$m_article"/>
	</xsl:variable>
	<xsl:variable name="m_clickmoreconv">Click here to see more <xsl:value-of select="$m_threads"/>
	</xsl:variable>
	<xsl:variable name="m_fsubject">Subject: </xsl:variable>
	<xsl:variable name="m_posted">Posted </xsl:variable>
	<xsl:variable name="m_posteddate">Date Posted</xsl:variable>
	<xsl:variable name="m_by"> by </xsl:variable>
	<xsl:variable name="m_inreplyto">This is a reply to </xsl:variable>
	<xsl:variable name="m_thispost">this <xsl:value-of select="$m_posting"/>
	</xsl:variable>
	<xsl:variable name="m_postcolon">Post: </xsl:variable>
	<xsl:variable name="m_readthe">Read the </xsl:variable>
	<xsl:variable name="m_firstreplytothis">first reply to this message</xsl:variable>
	<xsl:variable name="m_refentries">Referenced <xsl:value-of select="$m_articles"/>
	</xsl:variable>
	<xsl:variable name="m_refresearchers">Referenced <xsl:value-of select="$m_users"/>
	</xsl:variable>
	<xsl:variable name="m_refsites">Referenced Sites</xsl:variable>
	<xsl:variable name="m_clickmorejournal">Click here to see more <xsl:value-of select="$m_journalpostings"/>
	</xsl:variable>
	<xsl:variable name="m_clickaddjournal">Click here to add <xsl:value-of select="$m_journalpostinga"/>
		<xsl:value-of select="$m_journalposting"/>
	</xsl:variable>
	<xsl:variable name="m_clickherediscuss">Click here to discuss this</xsl:variable>
	<xsl:variable name="m_replies"> replies</xsl:variable>
	<xsl:variable name="m_reply"> reply</xsl:variable>
	<xsl:variable name="m_latestreply">Latest reply: </xsl:variable>
	<xsl:variable name="m_noreplies">No replies</xsl:variable>
	<xsl:variable name="m_nosubject">No subject</xsl:variable>
	<xsl:variable name="m_postedcolon">Posted: </xsl:variable>
	<xsl:variable name="m_lastreply">Last reply: </xsl:variable>
	<xsl:variable name="m_clicknewentry">Click here to add a new <xsl:value-of select="$m_article"/>
	</xsl:variable>
	<xsl:variable name="m_clickmoreentries">Click here to see more <xsl:value-of select="$m_articles"/>
	</xsl:variable>
	<xsl:variable name="m_clickmoreedited">Click here to see more <xsl:value-of select="$m_editedarticles"/>
	</xsl:variable>
	<xsl:variable name="m_whatpostlooklike">This is what your <xsl:value-of select="$m_posting"/> will look like:</xsl:variable>
	<xsl:variable name="m_postedsoon">Posted Soon by </xsl:variable>
	<xsl:variable name="m_nicknameis">Your Nickname is </xsl:variable>
	<xsl:variable name="m_textcolon">Text: </xsl:variable>
	<xsl:variable name="m_returntoconv">Click here to return to the <xsl:value-of select="$m_thread"/> without saying anything</xsl:variable>
	<xsl:variable name="m_messageisfrom">The <xsl:value-of select="$m_posting"/> to which you are replying is from </xsl:variable>
	<xsl:variable name="m_warningcolon">Warning: </xsl:variable>
	<xsl:variable name="m_journallooklike">This is what your <xsl:value-of select="$m_journalposting"/> will look like:</xsl:variable>
	<xsl:variable name="m_soon">Soon</xsl:variable>
	<xsl:variable name="m_emailaddress">Email Address:</xsl:variable>
	<xsl:variable name="m_noolderconv">No older <xsl:value-of select="$m_threads"/> to show</xsl:variable>
	<xsl:variable name="m_changesnoeffect">None of your changes will take effect until you press the</xsl:variable>
	<xsl:variable name="m_mapchangesnoeffect">No changes will take effect (including maps) until you press the </xsl:variable>
	<xsl:variable name="m_addintroduction">Add Introduction</xsl:variable>
	<xsl:variable name="m_updateintroduction">Update Introduction</xsl:variable>
	<xsl:variable name="m_addguideentry">Add <xsl:value-of select="$m_article"/>
	</xsl:variable>
	<xsl:variable name="m_updateentry">Update <xsl:value-of select="$m_article"/>
	</xsl:variable>
	<xsl:variable name="m_deletethisentry">Delete this <xsl:value-of select="$m_article"/>
	</xsl:variable>
	<xsl:variable name="m_deletebypressing">If you created this <xsl:value-of select="$m_article"/> by mistake, or no longer require it, you can delete it by pressing this button:</xsl:variable>
	<xsl:variable name="m_delete">Delete</xsl:variable>
	<xsl:variable name="m_journalentries">
		<xsl:value-of select="$m_journalpostings"/>
	</xsl:variable>
	<xsl:variable name="m_mostrecentconv">Most Recent <xsl:value-of select="$m_threads"/>
	</xsl:variable>
	<xsl:variable name="m_recentarticlethreads">
		<xsl:value-of select="$m_threads"/> about this <xsl:value-of select="$m_article"/>
	</xsl:variable>
	<xsl:variable name="m_noposting">No <xsl:value-of select="$m_posting"/>
	</xsl:variable>
	<xsl:variable name="m_newestpost">Latest post: </xsl:variable>
	<xsl:variable name="m_cancelled"> cancelled</xsl:variable>
	<xsl:variable name="m_pending"> pending</xsl:variable>
	<xsl:variable name="m_recommended"> recommended</xsl:variable>
	<xsl:variable name="m_uncancel">uncancel</xsl:variable>
	<xsl:variable name="m_postedsoon2">Posted Soon </xsl:variable>
	<xsl:variable name="m_returntoforum">Click here to return to the <xsl:value-of select="$m_forum"/> without saying anything</xsl:variable>
	<xsl:variable name="m_unsubmit">Unsubmit <xsl:value-of select="$m_article"/>
	</xsl:variable>
	<xsl:variable name="m_recententries">Most Recent <xsl:value-of select="$m_articles"/>
	</xsl:variable>
	<xsl:variable name="m_mostrecentedited">Most Recent <xsl:value-of select="$m_editedarticles"/>
	</xsl:variable>
	<xsl:variable name="m_clickdiscussbutton">Click the 'Discuss this <xsl:value-of select="$m_article"/>' button to be the first person to discuss this <xsl:value-of select="$m_article"/>
	</xsl:variable>
	<xsl:variable name="m_memberof">Member of:</xsl:variable>
	<xsl:variable name="m_subgroup">SubEditors</xsl:variable>
	<xsl:variable name="m_acesgroup">Aces</xsl:variable>
	<xsl:variable name="m_researchersgroup">Field Researchers</xsl:variable>
	<xsl:variable name="m_sectionheadgroup">Section Heads</xsl:variable>
	<xsl:variable name="m_GurusGroup">Gurus</xsl:variable>
	<xsl:variable name="m_ScoutsGroup">Scouts</xsl:variable>
	<xsl:variable name="m_nomembers">no members</xsl:variable>
	<xsl:variable name="m_member"> member</xsl:variable>
	<xsl:variable name="m_members"> members</xsl:variable>
	<xsl:variable name="m_resultsfound">Results found</xsl:variable>
	<xsl:variable name="m_noprevresults">No Previous Results </xsl:variable>
	<xsl:variable name="m_nomoreresults">No More Results </xsl:variable>
	<xsl:variable name="m_prevresults">&lt;&lt; Previous results</xsl:variable>
	<xsl:variable name="m_nextresults">Next results &gt;&gt; </xsl:variable>
	<xsl:variable name="m_noresults">No Results Found</xsl:variable>
	<xsl:variable name="m_SearchResultsIDColumnName">ID</xsl:variable>
	<xsl:variable name="m_SearchResultsSubjectColumnName">Subject</xsl:variable>
	<xsl:variable name="m_SearchResultsStatusColumnName">Status</xsl:variable>
	<xsl:variable name="m_SearchResultsScoreColumnName">Score</xsl:variable>
  <xsl:variable name="m_SearchResultsContentRatingColumnName">Content Rating</xsl:variable>
  <xsl:variable name="m_SearchResultsDateRangeColumnName">DateRange</xsl:variable>
  <xsl:variable name="m_SearchResultsPhrasesColumnName">Phrases</xsl:variable>
	<xsl:variable name="m_editedguideentry">
		<xsl:value-of select="$m_editedarticle"/>
		<xsl:text> </xsl:text>
	</xsl:variable>
	<xsl:variable name="m_helppageentry">Help Page </xsl:variable>
	<xsl:variable name="m_recommendedentry">Recommended <xsl:value-of select="$m_article"/>
		<xsl:text> </xsl:text>
	</xsl:variable>
	<xsl:variable name="m_guideentry">
		<xsl:value-of select="$m_article"/>
		<xsl:text> </xsl:text>
	</xsl:variable>
	<xsl:variable name="m_EditedEntryStatusName">Edited</xsl:variable>
	<xsl:variable name="m_HelpPageStatusName">Help Page</xsl:variable>
	<xsl:variable name="m_RecommendedEntryStatusName">Recommended</xsl:variable>
	<xsl:variable name="m_NormalEntryStatusName">-</xsl:variable>
	<xsl:variable name="m_clickunsubscribe">Click here to unsubscribe from this <xsl:value-of select="$m_thread"/>
	</xsl:variable>
	<xsl:variable name="m_clicksubscribe">Click here to subscribe to this <xsl:value-of select="$m_thread"/>
	</xsl:variable>
	<xsl:variable name="m_clickunsubforum">Click here to stop being notified of new <xsl:value-of select="$m_threads"/> about this <xsl:value-of select="$m_article"/>
	</xsl:variable>
	<xsl:variable name="m_clicksubforum">Click here to be notified of new <xsl:value-of select="$m_threads"/> about this <xsl:value-of select="$m_article"/>
	</xsl:variable>
	<xsl:variable name="m_onlinetitle">Find Out who else is Online</xsl:variable>
	<xsl:variable name="m_useronline">
		<xsl:text> </xsl:text>
		<xsl:value-of select="$m_user"/> is logged on</xsl:variable>
	<xsl:variable name="m_usersonline">
		<xsl:text> </xsl:text>
		<xsl:value-of select="$m_users"/> are logged on</xsl:variable>
	<xsl:variable name="m_newthisweek">New this week</xsl:variable>
	<xsl:variable name="m_onlineorderby">Order by: </xsl:variable>
	<xsl:variable name="m_onlineidradiolabel">ID </xsl:variable>
	<xsl:variable name="m_onlinenameradiolabel">Name </xsl:variable>
	<xsl:variable name="m_onlineregisteredradiolabel">Registered </xsl:variable>
	<xsl:variable name="m_totalregusers">Total Registered <xsl:value-of select="$m_users"/>
	</xsl:variable>
	<!--check: -->
	<xsl:variable name="m_usershaveregistered">
		<xsl:value-of select="$m_users"/> have registered since we launched.</xsl:variable>
	<xsl:variable name="m_queuelength">Recommended <xsl:value-of select="$m_article"/> Queue Length</xsl:variable>
	<xsl:variable name="m_therearecurrently">There are currently </xsl:variable>
	<xsl:variable name="m_recinqueue"> Recommended <xsl:value-of select="$m_articles"/> in the queue.</xsl:variable>
	<xsl:variable name="m_editedentries">
		<xsl:value-of select="$m_editedarticles"/>
	</xsl:variable>
	<xsl:variable name="m_editedinguide">
		<xsl:text> </xsl:text>
		<xsl:value-of select="$m_editedarticles"/> on the Site.</xsl:variable>
	<xsl:variable name="m_uneditedinguide">
		<xsl:text> </xsl:text><xsl:value-of select="$m_uneditedarticles"/> in the Guide.
	</xsl:variable>
	<xsl:variable name="m_toptenprolific">
		<xsl:value-of select="$m_users"/> with the Most <xsl:value-of select="$m_postings"/> in 24 Hours</xsl:variable>
	<xsl:variable name="m_toptenerudite">
		<xsl:value-of select="$m_users"/> with the Longest <xsl:value-of select="$m_postings"/> in 24 Hours</xsl:variable>
	<xsl:variable name="m_toptenlongest">Top Ten Longest <xsl:value-of select="$m_postings"/> in last 24 hours</xsl:variable>
	<xsl:variable name="m_toptwentyupdated">Twenty Most Recently Updated <xsl:value-of select="$m_threads"/>
	</xsl:variable>
	<xsl:variable name="m_toptenupdatedarticles">Twenty Most Recently Created <xsl:value-of select="$m_articles"/>
	</xsl:variable>
	<xsl:variable name="m_postsaverage">
		<xsl:text> </xsl:text>
		<xsl:value-of select="$m_postings"/>, average size </xsl:variable>
	<xsl:variable name="m_postaverage">
		<xsl:text> </xsl:text>
		<xsl:value-of select="$m_postings"/>, average size </xsl:variable>
	<xsl:variable name="m_discuss">Discuss</xsl:variable>
	<xsl:variable name="m_editpagetbut">Edit Page</xsl:variable>
	<xsl:variable name="m_frontpagebut">Front page</xsl:variable>
	<xsl:variable name="m_emailthistoafriend">Email this to a friend:</xsl:variable>
	<xsl:variable name="m_researchers">Written and Researched by:</xsl:variable>
	<xsl:variable name="m_editor">Edited by:</xsl:variable>
	<xsl:variable name="m_noentryyet">The <xsl:value-of select="$m_article"/> you requested does not exist. Perhaps you mistyped it, or the link you followed was broken.</xsl:variable>
	<xsl:variable name="m_newest">Newest</xsl:variable>
	<xsl:variable name="m_newer">Newer</xsl:variable>
	<xsl:variable name="m_oldest">Oldest</xsl:variable>
	<xsl:variable name="m_older">Older</xsl:variable>
	<xsl:variable name="m_prev">Prev</xsl:variable>
	<xsl:variable name="m_next">Next</xsl:variable>
	<xsl:variable name="m_replytothispost">Write a reply to this <xsl:value-of select="$m_posting"/>
	</xsl:variable>
	<xsl:variable name="m_thisconvforentry">This is the <xsl:value-of select="$m_forum"/> for </xsl:variable>
	<xsl:variable name="m_thisjournal">This is the <xsl:value-of select="$m_journal"/> of </xsl:variable>
	<xsl:variable name="m_thisuserstatistics">These are the Statistics for </xsl:variable>
	<xsl:variable name="m_thismessagecentre">This is the Message Centre for </xsl:variable>
	<xsl:variable name="m_unsubscribe">Unsubscribe</xsl:variable>
	<xsl:variable name="m_edit">edit</xsl:variable>
	<xsl:variable name="m_previous">Previous </xsl:variable>
	<xsl:variable name="m_entries">
		<xsl:text> </xsl:text>
		<xsl:value-of select="$m_articles"/>
	</xsl:variable>
	<xsl:variable name="m_nextspace">Next </xsl:variable>
	<xsl:variable name="m_nopreventries">No Previous <xsl:value-of select="$m_articles"/>
	</xsl:variable>
	<xsl:variable name="m_nomoreentries">No More <xsl:value-of select="$m_articles"/>
	</xsl:variable>
	<xsl:variable name="m_returntoentry">Click here to return to the <xsl:value-of select="$m_article"/> without saying anything</xsl:variable>
	<xsl:variable name="m_previewjournal">Preview <xsl:value-of select="$m_journal"/>
	</xsl:variable>
	<xsl:variable name="m_storejournal">Store <xsl:value-of select="$m_journal"/>
	</xsl:variable>
	<xsl:variable name="m_letters"> letters</xsl:variable>
	<xsl:variable name="m_content">Content: </xsl:variable>
	<xsl:variable name="m_previewinskin">Preview in skin: </xsl:variable>
	<xsl:variable name="m_preview">Preview</xsl:variable>
	<xsl:variable name="m_storechanges">Store any changes you have made.</xsl:variable>
	<xsl:variable name="m_plaintext">Plain text </xsl:variable>
	<xsl:variable name="m_guideml">GuideML </xsl:variable>
	<xsl:variable name="m_html">HTML </xsl:variable>
	<xsl:variable name="m_changestyle">Change style</xsl:variable>
	<xsl:variable name="m_noneofthese">None of your changes will take effect until you press the </xsl:variable>
	<xsl:variable name="m_mapnoneofthese">None of your changes will take effect until you press the </xsl:variable>
	<xsl:variable name="m_button"> button.</xsl:variable>
	<xsl:variable name="m_recommendtitle">Recommend <xsl:value-of select="$m_articlea"/>
		<xsl:value-of select="$m_article"/> for the <xsl:value-of select="$m_editedguide"/>
	</xsl:variable>
	<xsl:variable name="m_firstnames">First Names: </xsl:variable>
	<xsl:variable name="m_lastname">Last Name: </xsl:variable>
	<xsl:variable name="m_nickname">Nickname: </xsl:variable>
	<xsl:variable name="m_emailaddr">Email Address: </xsl:variable>
	<xsl:variable name="m_skin">Skin: </xsl:variable>
	<xsl:variable name="m_usermode">User Mode: </xsl:variable>
	<xsl:variable name="m_normal">Normal</xsl:variable>
	<xsl:variable name="m_expert">Expert</xsl:variable>
	<xsl:variable name="m_passwordmessage">To change your password, enter your original password, then your new password twice.</xsl:variable>
	<xsl:variable name="m_password">Password: </xsl:variable>
	<xsl:variable name="m_newpassword">New Password: </xsl:variable>
	<xsl:variable name="m_oldpassword">Current Password: </xsl:variable>
	<xsl:variable name="m_confirmpassword">Confirm Password: </xsl:variable>
	<xsl:variable name="m_updatedetails">Update Details</xsl:variable>
	<xsl:variable name="m_backtouserpage">Click here to go back to your Personal Space</xsl:variable>
	<!-- ????????????????????? -->
	<xsl:variable name="m_frontpagetitle">
		<xsl:value-of select="$m_pagetitlestart"/>Homepage</xsl:variable>
	<xsl:variable name="m_indextitle">Index of <xsl:value-of select="$m_articles"/>
	</xsl:variable>
	<xsl:variable name="m_show">Show</xsl:variable>
	<xsl:variable name="m_awaitingappr">Recommended <xsl:value-of select="$m_articles"/>
	</xsl:variable>
	<xsl:variable name="m_guideentries">
		<xsl:value-of select="$m_articles"/>
	</xsl:variable>
	<xsl:variable name="m_pstitleowner">Welcome to your Personal Space, </xsl:variable>
	<xsl:variable name="m_pstitleviewer">Welcome to the Personal Space of <xsl:value-of select="$m_user"/>
		<xsl:text> </xsl:text>
	</xsl:variable>
	<xsl:variable name="m_mymessage">My</xsl:variable>
	<xsl:variable name="m_refresh">Refresh</xsl:variable>
	<xsl:variable name="m_posttoaforum">Post to <xsl:value-of select="$m_threada"/>
		<xsl:value-of select="$m_thread"/>
	</xsl:variable>
	<xsl:variable name="m_postsubject">Post Subject</xsl:variable>
	<xsl:variable name="m_greetingshiker">Greetings, friend</xsl:variable>
	<xsl:variable name="m_browsetheguide">Browse the Site</xsl:variable>
	<xsl:variable name="m_searchtitle">Search</xsl:variable>
	<xsl:variable name="m_searchsubject">Search the site</xsl:variable>
	<xsl:variable name="m_searchin">Search in</xsl:variable>
	<xsl:variable name="m_recommendedentries">Recommended <xsl:value-of select="$m_articles"/>
	</xsl:variable>
	<xsl:variable name="m_oruseindex">Or you can search the alphabetical index of all <xsl:value-of select="$m_articles"/>:</xsl:variable>
	<xsl:variable name="m_searchforums">Search the <xsl:value-of select="$m_forums"/>
	</xsl:variable>
	<xsl:variable name="m_searchforafriend">Search for a Friend</xsl:variable>
	<xsl:variable name="m_searchfor">Search for: </xsl:variable>
	<xsl:variable name="m_addjournal">Add <xsl:value-of select="$m_journalpostinga"/>
		<xsl:value-of select="$m_journalposting"/>
	</xsl:variable>
	<xsl:variable name="m_registrationtitle">Registration</xsl:variable>
	<xsl:variable name="m_registrationsubject">Login/Registration</xsl:variable>
	<xsl:variable name="m_enterpassword">Enter your password</xsl:variable>
	<xsl:variable name="m_alwaysremember">Always remember me on this computer</xsl:variable>
	<xsl:variable name="m_newusers">New <xsl:value-of select="$m_users"/>
	</xsl:variable>
	<xsl:variable name="m_existingusers">Existing <xsl:value-of select="$m_users"/>
	</xsl:variable>
	<xsl:variable name="m_interestingfacts">Interesting Site Statistics</xsl:variable>
	<xsl:variable name="m_h2g2stats">Site Statistics</xsl:variable>
	<xsl:variable name="m_logoutheader">Goodbye</xsl:variable>
	<xsl:variable name="m_logoutsubject">Thank you for visiting</xsl:variable>
	<xsl:variable name="m_journalforresearcher">
		<xsl:value-of select="$m_journal"/> for <xsl:value-of select="$m_user"/>
		<xsl:text> </xsl:text>
	</xsl:variable>
	<xsl:variable name="m_backtoresearcher">Back to <xsl:value-of select="$m_user"/>'s Personal Space</xsl:variable>
	<xsl:variable name="m_newemailtitle">
		<xsl:value-of select="$m_h2g2"/>
	</xsl:variable>
	<xsl:variable name="m_newemailstored">New email address stored</xsl:variable>
	<xsl:variable name="m_failedtostoreemail">Failed to store email address.</xsl:variable>
	<xsl:variable name="m_yournewemailstored">Your new email address has been stored.</xsl:variable>
	<xsl:variable name="m_unabletostoreemailbecause">We were unable to store your new email address because </xsl:variable>
	<xsl:variable name="m_morepagestitle">
		<xsl:value-of select="$m_articles"/>
	</xsl:variable>
	<xsl:variable name="m_cancelledentries">Cancelled <xsl:value-of select="$m_articles"/>
	</xsl:variable>
	<xsl:variable name="m_errortitle">Error</xsl:variable>
	<xsl:variable name="m_errorsubject">We Apologise for the Inconvenience</xsl:variable>
	<xsl:variable name="m_followingerror">The following error occurred: </xsl:variable>
	<xsl:variable name="m_morepoststitle">Forum <xsl:value-of select="$m_postings"/>
	</xsl:variable>
	<xsl:variable name="m_postingsby">Forum <xsl:value-of select="$m_postings"/> by </xsl:variable>
	<xsl:variable name="m_newerpostings"> Newer <xsl:value-of select="$m_postings"/>
	</xsl:variable>
	<xsl:variable name="m_olderpostings">Older <xsl:value-of select="$m_postings"/>
	</xsl:variable>
	<xsl:variable name="m_NewerRegistrations">Newer Registrations &gt;&gt;</xsl:variable>
	<xsl:variable name="m_OlderRegistrations">&lt;&lt; Older Registrations</xsl:variable>
	<xsl:variable name="m_RegistrationsSeparater">
		<xsl:text> | </xsl:text>
	</xsl:variable>
	<xsl:variable name="m_NoOlderRegistrations">No Older Registrations</xsl:variable>
	<xsl:variable name="m_NoNewerRegistrations">No Newer Registrations</xsl:variable>
	<xsl:variable name="m_editpagetitle">
		<xsl:value-of select="$m_pagetitlestart"/>Edit <xsl:value-of select="$m_article"/>
	</xsl:variable>
	<xsl:variable name="m_donotpress">Please do not press this button again.</xsl:variable>
	<xsl:variable name="m_atriclesubmitted">Your <xsl:value-of select="$m_article"/> has been submitted. Please be patient...</xsl:variable>
	<xsl:variable name="m_preferencestitle">
		<xsl:value-of select="$m_pagetitlestart"/>Edit Personal Settings</xsl:variable>
	<xsl:variable name="m_preferencessubject">Personal Details</xsl:variable>
	<xsl:variable name="m_regconfirm">
		<xsl:value-of select="$m_pagetitlestart"/>Registering</xsl:variable>
	<xsl:variable name="m_reginprogress">Registration in process...</xsl:variable>
	<xsl:variable name="m_NewUsersPageTitle">
		<xsl:value-of select="$m_pagetitlestart"/>New <xsl:value-of select="$m_users"/>
	</xsl:variable>
	<xsl:variable name="m_NewUsersPageHeader">New <xsl:value-of select="$m_users"/>
	</xsl:variable>
	<!-- Need to change img: -->
	<xsl:variable name="m_NewUsersPageExplanatory">Select a time period using the drop-down menus below, and then click on the 'Show <xsl:value-of select="$m_users"/>' button to get a list of the <xsl:value-of select="$m_users"/> that have registered within that period.</xsl:variable>
	<xsl:variable name="m_NewUsersPageSubmitButtonText">Show <xsl:value-of select="$m_users"/>
	</xsl:variable>
	<xsl:variable name="m_UsersAll">Show all</xsl:variable>
	<xsl:variable name="m_UsersWithIntroductions">Show users who have updated their introduction<!--Show only those with Introductions (ie those you can talk to on their Personal Spaces)--></xsl:variable>
	<xsl:variable name="m_UsersWithIntroductionsNoPostings">Show only those with Introductions without any <xsl:value-of select="$m_postings"/> made to it (ie those whom the Aces should welcome)</xsl:variable>
	<xsl:variable name="m_userhasmastheadflag">&#42;</xsl:variable>
	<xsl:variable name="m_usersintropostedtoflag">&#42;</xsl:variable>
	<xsl:variable name="m_userhasmastheadfootnote"> Indicates <xsl:value-of select="$m_user"/> has written an Introduction to their Personal Space.</xsl:variable>
	<xsl:variable name="m_usersintropostedtofootnote"> Indicates <xsl:value-of select="$m_user"/>'s Introduction has had at least one <xsl:value-of select="$m_posting"/> made to it.</xsl:variable>
	<xsl:variable name="m_showoldest"> Show Oldest</xsl:variable>
	<xsl:variable name="m_showolder"> Show Older</xsl:variable>
	<xsl:variable name="m_shownewer">Show Newer </xsl:variable>
	<xsl:variable name="m_shownewest">Show Newest </xsl:variable>
	<xsl:variable name="m_subscribedtothread">You have now subscribed to this <xsl:value-of select="$m_thread"/>.</xsl:variable>
	<xsl:variable name="m_subscribedtoforum">You have now subscribed to this <xsl:value-of select="$m_forum"/>. The 'Recent <xsl:value-of select="$m_threads"/>' list in your Personal Space will show you when new <xsl:value-of select="$m_threads"/> are started.</xsl:variable>
	<xsl:variable name="m_unsubbedfromforum">You have now unsubscribed from this <xsl:value-of select="$m_forum"/>. You will no longer be notified of new <xsl:value-of select="$m_threads"/> in your 'Recent <xsl:value-of select="$m_threads"/>' list.</xsl:variable>
	<xsl:variable name="m_unsubscribedfromthread">You are no longer subscribed to this <xsl:value-of select="$m_thread"/>.</xsl:variable>
	<xsl:variable name="m_subscriberesult">Subscribe result</xsl:variable>
	<xsl:variable name="m_close">close</xsl:variable>
	<xsl:variable name="m_removejournal">Click here to remove this <xsl:value-of select="$m_journalposting"/> from your Space</xsl:variable>
	<xsl:variable name="m_returnto">Return to </xsl:variable>
	<xsl:variable name="m_subthreadcomplete">Request to Subscribe to <xsl:value-of select="$m_thread"/> Completed</xsl:variable>
	<xsl:variable name="m_subforumcomplete">Request to Add Notification of New <xsl:value-of select="$m_threads"/> Completed</xsl:variable>
	<xsl:variable name="m_unsubforumcomplete">Request to Remove Notification of New <xsl:value-of select="$m_threads"/> Completed</xsl:variable>
	<xsl:variable name="m_journalremovecomplete">Request to Remove <xsl:value-of select="$m_journalposting"/> Completed</xsl:variable>
	<xsl:variable name="m_subrequestfailed">Request Failed</xsl:variable>
	<xsl:variable name="m_journalremoved">This <xsl:value-of select="$m_journalposting"/> has been removed from your Personal Space. It has not been deleted, however, as it may form part of <xsl:value-of select="$m_threada"/>
		<xsl:value-of select="$m_thread"/> that other <xsl:value-of select="$m_users"/> have joined in.</xsl:variable>
	<xsl:variable name="m_AddHomePageHeading">Add Introduction</xsl:variable>
	<xsl:variable name="m_AddGuideEntryHeading">Add <xsl:value-of select="$m_article"/>
	</xsl:variable>
	<xsl:variable name="m_EditGuideEntryHeading">Update <xsl:value-of select="$m_article"/>
	</xsl:variable>
	<xsl:variable name="m_EditHomePageHeading">Update Introduction</xsl:variable>
	<xsl:variable name="m_iaccept">I Accept</xsl:variable>
	<xsl:variable name="m_idonotaccept">I DO NOT Accept</xsl:variable>
	<xsl:variable name="m_problemcancelling">There was a problem while cancelling this account: </xsl:variable>
	<xsl:variable name="m_yescancelaccount">YES - cancel this account</xsl:variable>
	<xsl:variable name="m_noleaveaccountactive">NO - leave the account active</xsl:variable>
	<xsl:variable name="m_warningcancellingaccount">Warning: About to cancel account</xsl:variable>
	<xsl:variable name="m_sorrytermsrejectedtitle">We're very sorry</xsl:variable>
	<xsl:variable name="m_clicknotifynewconv">Click here to be notified of new <xsl:value-of select="$m_threads"/> about this <xsl:value-of select="$m_article"/>
	</xsl:variable>
	<xsl:variable name="m_notifynewentriesinreviewforum">Click here to be notified of new <xsl:value-of select="$m_articles"/> in this Review Forum</xsl:variable>
	<xsl:variable name="m_unmatchedpasswords">The two passwords you entered don't match.</xsl:variable>
	<xsl:variable name="m_blankpassword">You need to enter a password before you can register.</xsl:variable>
	<xsl:variable name="m_noconnectionerror">
			There is a problem with your login. It may be because you have no email 
			address set for your BBC account. The best way to fix this is to login 
			into <a xsl:use-attribute-sets="as_m_noconnectionerror" href="{$m_MyBBCHREF}">myBBC</a> with your h2g2 details, 
			and to click on the 'my profile' link. Here you should enter an email address, 
			and then you should be able to log in to h2g2. If you still have problems, 
			please email the address below.</xsl:variable>
	<xsl:variable name="m_MyBBCHREF">http://www.bbc.co.uk/mybbc</xsl:variable>
	<xsl:variable name="m_invalidEmail">The email address you supplied is invalid</xsl:variable>
	<xsl:variable name="m_confregistration">Confirm Registration</xsl:variable>
	<xsl:variable name="m_enterwordsorphrases">Enter the words or phrases to search for: </xsl:variable>
	<xsl:variable name="m_unsubthreadcomplete">Request to Unsubscribe from <xsl:value-of select="$m_thread"/> Completed</xsl:variable>
	<xsl:variable name="m_shareandenjoytitle">Share and Enjoy</xsl:variable>
	<xsl:variable name="m_welcomemessage">Welcome message:</xsl:variable>
	<!-- ???????????????????????? -->
	<xsl:variable name="m_h2g2">
		<xsl:value-of select="$sitedisplayname"/>
	</xsl:variable>
	<xsl:variable name="m_h2g2journaltitle">
		<xsl:value-of select="$m_journal"/>
	</xsl:variable>
	<xsl:variable name="m_myspacetitle">Your Personal Space</xsl:variable>
	<xsl:variable name="m_registertitle">Register Now! It's Totally Free!</xsl:variable>
	<xsl:variable name="m_readtitle">Interesting Things to Read on the Site</xsl:variable>
	<xsl:variable name="m_talktitle">Places to Talk and Things to Talk About</xsl:variable>
	<xsl:variable name="m_contributetitle">How to Contribute</xsl:variable>
	<xsl:variable name="m_feedbacktitle">Tell Us What You Think</xsl:variable>
	<xsl:variable name="m_shoptitle">Buy Some Amazing Stuff from our Shop</xsl:variable>
	<xsl:variable name="m_aboutustitle">All About the Company</xsl:variable>
	<xsl:variable name="m_logouttitle">Log Out</xsl:variable>
	<xsl:variable name="m_loginname">BBC Sign in Name: </xsl:variable>
	<xsl:variable name="m_h2g2password">Password: </xsl:variable>
	<xsl:variable name="m_badlogin">	The email address or password didn't match an existing <xsl:value-of select="$m_user"/>. Perhaps you mistyped. Make sure you haven't got the Caps Lock key on, and try again.</xsl:variable>
	<xsl:variable name="m_alreadyhaslogin">That <xsl:value-of select="$m_user"/> has a BBC Sign in name associated with it. You will have to log in using that BBC login name.</xsl:variable>
	<xsl:variable name="m_followingproblem">The following problem occurred when trying to log you in: </xsl:variable>
	<xsl:variable name="m_invalidloginname">You haven't entered a valid login name. It must be at least six characters long.</xsl:variable>
	<xsl:variable name="m_invalidpassword">You haven't entered a password.</xsl:variable>
	<xsl:variable name="m_loginfailed">The login name and password you tried have not been recognised. Make sure you haven't got the Caps Lock key on, and try again.</xsl:variable>
	<xsl:variable name="m_loginused">That login name is already used by someone else.</xsl:variable>
	<xsl:variable name="m_mustagreetoterms">You must agree to the Terms of use before you can register. Please make sure the check box is ticked.</xsl:variable>
	<xsl:variable name="m_problemwithreg">There was a problem with the registration. Please try again.</xsl:variable>
	<xsl:variable name="m_referencedsitesdisclaimer">Please note that the BBC is not responsible for the content of any external sites listed.</xsl:variable>
	<xsl:variable name="m_usercomplaintpopuptitle">
		<xsl:value-of select="$m_pagetitlestart"/>Register Complaint</xsl:variable>
	<xsl:variable name="m_complaintsuccessfullyregisteredmessage">Your complaint was successfully registered and will be looked at by a Moderator as soon as possible.</xsl:variable>
	<xsl:variable name="m_contentalreadyhiddenmessage">This content has already been hidden, but if you still wish to register a complaint regarding it then please enter the details of your complaint below and click on 'Submit Complaint', otherwise click on 'Cancel' to close this window.</xsl:variable>
	<xsl:variable name="m_contentcancelledmessage">This content has been deleted, but if you still wish to register a complaint regarding it then please enter the details of your complaint below and click on 'Submit Complaint', otherwise click on 'Cancel' to close this window.</xsl:variable>
	<xsl:variable name="m_defaultcomplainttext">Please give details of your complaint here.</xsl:variable>
	<xsl:variable name="m_complaintsformsubmitbuttonlabel">Submit Complaint</xsl:variable>
	<xsl:variable name="m_complaintsformcancelbuttonlabel">Cancel</xsl:variable>
	<xsl:variable name="m_complaintsformnextbuttonlabel">Next</xsl:variable>
	<xsl:variable name="m_noconnection">Unable to connect to BBC user database.</xsl:variable>
	<xsl:variable name="m_invalidbbcpassword">That BBC password is invalid. It must be at least six characters long and only contain letters and numbers.</xsl:variable>
	<xsl:variable name="m_invalidbbcusername">That BBC login name was invalid. It must be at least six characters long and can only contain letters and numbers.</xsl:variable>
	<xsl:variable name="m_uidused">Your details generated a non-unique ID. Please try another BBC login name.</xsl:variable>
	<xsl:variable name="m_bbcpassword">BBC Password: </xsl:variable>
	<xsl:variable name="m_confirmbbcpassword">Confirm BBC Password: </xsl:variable>
	<xsl:variable name="m_userpagemoderatesubject">Personal Space Hidden</xsl:variable>
	<xsl:variable name="m_forumstyle">Forum Style:</xsl:variable>
	<xsl:variable name="m_forumstyleframes">Frames</xsl:variable>
	<xsl:variable name="m_forumstylesingle">Single pages</xsl:variable>
	<xsl:variable name="m_forumsubject">Forum Title</xsl:variable>
	<xsl:variable name="m_pagetitlestart">BBC - <xsl:value-of select="$sitedisplayname"/> - </xsl:variable>
	<xsl:variable name="m_articlehiddentitle">
		<xsl:value-of select="$m_article"/> Hidden</xsl:variable>
	<xsl:variable name="m_bbcloginalreadyused">That login name is already used and can't be associated with another account.</xsl:variable>
	<xsl:variable name="m_newloginbutton">Sign in</xsl:variable>
	<xsl:variable name="m_newregisterbutton">Register</xsl:variable>
	<xsl:variable name="m_newreactivatebutton">Reactivate</xsl:variable>
	<xsl:variable name="m_usercomplaintnodetailsalert">Please describe the nature of your complaint in the text area provided.</xsl:variable>
	<xsl:variable name="m_articledeletedtitle">
		<xsl:value-of select="$m_article"/> Deleted</xsl:variable>
	<xsl:variable name="m_articledeletedsubject">
		<xsl:value-of select="$m_article"/> Deleted</xsl:variable>
	<xsl:variable name="m_postsubjectremoved">
		<xsl:value-of select="$m_posting"/> Hidden</xsl:variable>
	<xsl:variable name="m_awaitingmoderationsubject">Awaiting Moderation</xsl:variable>
	<xsl:variable name="m_conversationfirstsubject">
		<xsl:value-of select="$m_thread"/> First Subject</xsl:variable>
	<xsl:variable name="m_returntothreadspage">
		<xsl:value-of select="$m_thread"/> List</xsl:variable>
	<xsl:variable name="m_searchtheguide">Search the Site</xsl:variable>
	<xsl:variable name="m_showeditedentries">Show <xsl:value-of select="$m_editedarticles"/>
	</xsl:variable>
	<xsl:variable name="m_showguideentries">Show <xsl:value-of select="$m_articles"/>
	</xsl:variable>
	<xsl:variable name="m_showcancelledentries">Show Cancelled <xsl:value-of select="$m_articles"/>
	</xsl:variable>
	<xsl:variable name="m_gadgetusethiswindow">Use <B>this</B> window</xsl:variable>
	<xsl:variable name="m_gadgetusenewwindow">Use <B>new</B> window</xsl:variable>
	<xsl:variable name="m_dropdownpleasechooseone">Please choose one</xsl:variable>
	<xsl:variable name="m_ShortDateDelimiter">-</xsl:variable>
	<xsl:variable name="m_RecommendEntryPageTitle">Recommend <xsl:value-of select="$m_article"/>
	</xsl:variable>
	<xsl:variable name="m_RecommendEntryPageHeader">Recommend <xsl:value-of select="$m_articlea"/>
		<xsl:value-of select="$m_article"/>
	</xsl:variable>
	<xsl:variable name="m_RecommendEntryOwnEntryError">You are the author of this <xsl:value-of select="$m_article"/> and so you not allowed to recommend it yourself. You are however allowed to suggest it for recommendation by another Scout at the Peer Review forum.</xsl:variable>
	<xsl:variable name="m_RecommendEntryInvalidIDError">The ID number you entered is not a valid one. Perhaps you misstyped it or pressed the recommend button twice.</xsl:variable>
	<xsl:variable name="m_RecommendEntryWrongStatusError">You can only recommend normal <xsl:value-of select="$m_articles"/> for inclusion on the Site.</xsl:variable>
	<xsl:variable name="m_RecommendEntryUnspecifiedError">You were unable to recommend this <xsl:value-of select="$m_article"/> because the following error occured:</xsl:variable>
	<xsl:variable name="m_RecommendEntryFetchEntryText">Fetch <xsl:value-of select="$m_articlea"/>
		<xsl:value-of select="$m_article"/> to recommend:</xsl:variable>
	<xsl:variable name="m_RecommendEntryEntryIDBoxText">ID: </xsl:variable>
	<xsl:variable name="m_SubbedEntryPageTitle">Submit Subbed <xsl:value-of select="$m_article"/>
	</xsl:variable>
	<xsl:variable name="m_SubbedEntryInvalidIDError">The ID number you entered is not a valid one.</xsl:variable>
	<xsl:variable name="m_SubbedEntryWrongStatusError">You can only submit the subbed version of <xsl:value-of select="$m_articlea"/>
		<xsl:value-of select="$m_article"/> via the Sub Editor's copy.</xsl:variable>
	<xsl:variable name="m_SubbedEntryUnspecifiedError">An unspecified error occurred whilst attempting to process this submission.</xsl:variable>
	<xsl:variable name="m_SubbedEntrySubmitSuccessMessage">Subbed version of this <xsl:value-of select="$m_article"/> was successfully submitted.</xsl:variable>
	<xsl:variable name="m_SubbedEntryFetchEntryText">Fetch <xsl:value-of select="$m_articlea"/>
		<xsl:value-of select="$m_article"/>:</xsl:variable>
	<xsl:variable name="m_SubbedEntryEntryIDBoxText">ID: </xsl:variable>
	<xsl:variable name="m_SubAllocationPageTitle">Sub Allocation</xsl:variable>
	<xsl:variable name="m_SubAllocationPageHeader">Allocate Recommended <xsl:value-of select="$m_articles"/> to Sub Editors</xsl:variable>
	<xsl:variable name="m_SubAllocationBeingProcessedPopup">Your <xsl:value-of select="$m_article"/> allocation submission is being processed, please be patient.</xsl:variable>
	<xsl:variable name="m_articlereferredtitle">
		<xsl:value-of select="$m_article"/> Referred</xsl:variable>
	<xsl:variable name="m_articleawaitingpremoderationtitle">
		<xsl:value-of select="$m_article"/> Waiting for Moderation</xsl:variable>
	<xsl:variable name="m_legacyarticleawaitingmoderationtitle">
		<xsl:value-of select="$m_article"/> Waiting for Moderation</xsl:variable>
	<xsl:variable name="m_shortdatedelimiter">-</xsl:variable>
	<xsl:variable name="m_govolunteer">Go</xsl:variable>
	<xsl:variable name="m_thiswindow">This Window</xsl:variable>
	<xsl:variable name="m_newwindow">New Window</xsl:variable>
	<xsl:variable name="m_otherbbcsites">Related BBC Pages</xsl:variable>
	<xsl:variable name="m_editcategorisationheader">Edit Categorisation</xsl:variable>
	<xsl:variable name="m_editcategorisationsubject">Edit Categorisation</xsl:variable>
	<xsl:variable name="m_submitreviewforumheader">Submit for Review</xsl:variable>
	<xsl:variable name="m_submitreviewforumsubject">Submit for Review</xsl:variable>
	<xsl:variable name="m_whatscomingupheader">What's Coming Up on the site</xsl:variable>
	<xsl:variable name="m_cominguprecheader">Recommended by Scouts</xsl:variable>
	<xsl:variable name="m_comingupwitheditorheader">With Sub-editor</xsl:variable>
	<xsl:variable name="m_comingupreturnheader">Returned from Sub-editor</xsl:variable>
	<xsl:variable name="m_comingupid">ID</xsl:variable>
	<xsl:variable name="m_comingupsubject">Subject</xsl:variable>
	<xsl:variable name="m_rft_articlesinreviewheader">
		<xsl:value-of select="$m_articles"/> in Review</xsl:variable>
	<xsl:variable name="m_removefromreviewforumsubject">
		<xsl:value-of select="$m_article"/> Successfully Removed from Review Forum</xsl:variable>
	<!-- ????????? -->
	<xsl:variable name="m_sitetitle">
		<xsl:value-of select="$sitedisplayname"/>
	</xsl:variable>
	<xsl:variable name="m_RecommendEntryNotInReviewForum">The <xsl:value-of select="$m_article"/> must be in a recommendable Review Forum</xsl:variable>
	<xsl:variable name="m_rftnoarticlesinreviewforum">There are no <xsl:value-of select="$m_articles"/> in review for this choice</xsl:variable>
	<xsl:variable name="m_edittheresearcherlisttext">Edit the <xsl:value-of select="$m_user"/> List</xsl:variable>
	<xsl:variable name="m_editentrylinktext">Edit <xsl:value-of select="$m_article"/>
	</xsl:variable>
	<xsl:variable name="m_ReturnToEditorsLinkText">Return to Editors</xsl:variable>
	<xsl:variable name="m_reviewforumdatatitle">Review Forum Data</xsl:variable>
	<xsl:variable name="m_reviewforumdataname">Name: </xsl:variable>
	<xsl:variable name="m_reviewforumdataurl">URL: </xsl:variable>
	<xsl:variable name="m_reviewforumdata_recommend_yes">Recommendable: Yes</xsl:variable>
	<xsl:variable name="m_reviewforumdata_recommend_no">Recommendable: No</xsl:variable>
	<xsl:variable name="m_reviewforumdata_incubate">Incubate: </xsl:variable>
	<xsl:variable name="m_reviewforumdata_edit">Edit</xsl:variable>
	<xsl:variable name="m_reviewforumdata_h2g2id">
		<xsl:value-of select="$m_article"/> ID: </xsl:variable>
	<xsl:variable name="m_reviewforum_entrytarget">
		<xsl:value-of select="$m_articles"/>
	</xsl:variable>
	<xsl:variable name="m_clickmorereviewentries">Click here to see more <xsl:value-of select="$m_articles"/>
	</xsl:variable>
	<xsl:variable name="m_submittoreviewforumbutton">Submit <xsl:value-of select="$m_article"/>
	</xsl:variable>
	<xsl:variable name="m_articlelisttext">
		<xsl:value-of select="$m_article"/> List</xsl:variable>
	<xsl:variable name="m_notforreviewtext"> Not for Review </xsl:variable>
	<xsl:variable name="m_articleisinreviewtext">
		<xsl:value-of select="$m_article"/> is Currently in a Review Forum</xsl:variable>
	<xsl:variable name="m_editreviewtitle">Edit Review Forum</xsl:variable>
	<xsl:variable name="m_postingtoolong">The <xsl:value-of select="$m_posting"/> was too long. Please cut it down and try again.</xsl:variable>
	<xsl:variable name="m_entrysubmittoreviewforumsubject">
		<xsl:value-of select="$m_article"/> successfully submitted to Review Forum</xsl:variable>
	<xsl:variable name="m_clickstopnotifynewconv">Click here to stop being notified of new <xsl:value-of select="$m_threads"/> for this <xsl:value-of select="$m_article"/>.</xsl:variable>
	<xsl:variable name="m_stopnotifynewentriesreviewforum">Click here to stop being notified of new <xsl:value-of select="$m_articles"/> in this Review Forum</xsl:variable>
	<xsl:variable name="m_ptclicktostartnewconv">Click here to start a new <xsl:value-of select="$m_thread"/>
	</xsl:variable>
	<xsl:variable name="m_ptclicktowritereply">Click here to write your reply</xsl:variable>
	<xsl:variable name="m_addnewreviewforum_title">Add New Review Forum</xsl:variable>
	<xsl:variable name="m_notfoundsubject">Page Not Found</xsl:variable>
	<xsl:variable name="m_clickifnotredirected">Click here if you are not automatically redirected</xsl:variable>
	<xsl:variable name="m_RefereeShouldBeModerator">Non-moderator can not be referee</xsl:variable>
	<xsl:variable name="m_modsitename">Site Name</xsl:variable>
	<xsl:variable name="m_modnumberqueued">Number of Items in Queue</xsl:variable>
	<xsl:variable name="m_modnumbercomplaints">Number of Complaints</xsl:variable>
	<xsl:variable name="m_modcurrentlyvisible">Currently Visible</xsl:variable>
	<xsl:variable name="m_modcurrentlyvisibleyes">Yes</xsl:variable>
	<xsl:variable name="m_modcurrentlyvisibleno">No</xsl:variable>
	<xsl:variable name="m_modrejectpostingcomplaint">Reject Complaint and Leave <xsl:value-of select="$m_posting"/> Visible</xsl:variable>
	<xsl:variable name="m_modacceptpostingcomplaint">Uphold Complaint and Remove <xsl:value-of select="$m_posting"/>
	</xsl:variable>
	<xsl:variable name="m_modrejectarticlecomplaint">Reject Complaint and Leave <xsl:value-of select="$m_article"/> Visible</xsl:variable>
	<xsl:variable name="m_modacceptarticlecomplaint">Uphold Complaint and Remove <xsl:value-of select="$m_article"/>
	</xsl:variable>
	<xsl:variable name="m_modacceptgeneralcomplaint">Uphold Complaint</xsl:variable>
	<xsl:variable name="m_modrejectgeneralcomplaint">Reject Complaint</xsl:variable>
	<xsl:variable name="m_modacceptandeditarticle">Uphold Complaint and Edit <xsl:value-of select="$m_article"/>
	</xsl:variable>
	<xsl:variable name="m_modacceptandeditposting">Uphold Complaint and Edit <xsl:value-of select="$m_posting"/>
	</xsl:variable>
	<xsl:variable name="m_modrejectandeditposting">Reject Complaint and Edit <xsl:value-of select="$m_posting"/>
	</xsl:variable>
	<xsl:variable name="m_ModEnterURLandReason">Enter URLs:</xsl:variable>
	<xsl:variable name="m_premoderation">Premoderation:</xsl:variable>
	<xsl:variable name="m_offsiteallowed">Off-site links allowed:</xsl:variable>
	<xsl:variable name="m_fromsite">From</xsl:variable>
	<xsl:variable name="m_oneyes_yes">YES</xsl:variable>
	<xsl:variable name="m_oneyes_no">NO</xsl:variable>
	<xsl:variable name="m_invalidemailformat">Email address should be in format of aa@bb.cc</xsl:variable>
	<xsl:variable name="m_whichsite">Site</xsl:variable>
	<xsl:variable name="m_RemoveMeFromResearchersList">Remove My Name</xsl:variable>
	<xsl:variable name="m_jumptomoderate">Jump to the moderation section</xsl:variable>
	<xsl:variable name="m_BelongsToSite">Belongs to site: </xsl:variable>
	<xsl:variable name="m_MoveToSite">Move to site</xsl:variable>
	<xsl:variable name="m_Move">Move</xsl:variable>
	<xsl:variable name="m_Categorise">Categorise</xsl:variable>
	<xsl:variable name="m_MoveJournalToSite">
		<xsl:value-of select="$m_journal"/> - Move to site</xsl:variable>
	<xsl:variable name="m_WritingPlainTextHelpLink">
		<xsl:value-of select="$root"/>Writing-PlainText</xsl:variable>
	<xsl:variable name="m_WritingGuideMLHelpLink">
		<xsl:value-of select="$root"/>Writing-GuideML</xsl:variable>
	<xsl:variable name="m_MapLocationsHelpLink">
		<xsl:value-of select="$root"/>Adding-Maps</xsl:variable>
	<xsl:variable name="m_InspectUser">Inspect this User</xsl:variable>
	<xsl:variable name="m_oruserid">or User ID (number): </xsl:variable>
	<xsl:variable name="m_myconversationstitle">My <xsl:value-of select="$m_threads"/>
	</xsl:variable>
	<xsl:variable name="m_myconvposted">posted </xsl:variable>
	<xsl:variable name="m_myconvnoposting">No <xsl:value-of select="$m_posting"/>
	</xsl:variable>
	<xsl:variable name="m_removenamesubjsuccess">Name removed from list</xsl:variable>
	<xsl:variable name="m_removenamesubjfailure">Couldn't remove name from list</xsl:variable>
	<xsl:variable name="m_entrynotdeletedsubj">
		<xsl:value-of select="$m_article"/> could not be deleted</xsl:variable>
	<xsl:variable name="m_nopermissiontodeleteentry">You do not have permission to delete this <xsl:value-of select="$m_article"/>.</xsl:variable>
	<xsl:variable name="m_dberrordeleteentry">There was an error accessing the database and your <xsl:value-of select="$m_article"/> could not be deleted.</xsl:variable>
	<xsl:variable name="m_guideentryrestoredsubj">
		<xsl:value-of select="$m_article"/> Restored</xsl:variable>
	<xsl:variable name="m_ConfirmRemoveSelf">Please confirm that you would like to remove your name from the Researcher list for this <xsl:value-of select="$m_article"/>
	</xsl:variable>
	<xsl:variable name="m_MarkAllRead">Mark all read</xsl:variable>
	<xsl:variable name="m_MarkTillThis">&gt;&gt;</xsl:variable>
	<xsl:variable name="m_ModPerSiteTableNote">Please note: This table shows the number of items waiting for moderation in each site. The figure in brackets (if present) shows the number of items referred (or locked to you if you are also a referrer on that site).</xsl:variable>
	<xsl:variable name="m_editpermissiondenied">Permission Denied</xsl:variable>
	<xsl:variable name="m_postnumber">Post: </xsl:variable>
	<xsl:variable name="m_moderationhistory">Moderation history</xsl:variable>
	<xsl:variable name="m_editpost">Edit </xsl:variable>
	<xsl:variable name="m_dberrorguideundelete">There was an error accessing the database and your <xsl:value-of select="$m_article"/> could not be restored.</xsl:variable>
	<xsl:variable name="m_homepageerrorstatuschange">You cannot submit your homepage for consideration as an Approved <xsl:value-of select="$m_article"/>.</xsl:variable>
	<xsl:variable name="m_notentryerrorstatuschange">You cannot submit your article for consideration as an Approved <xsl:value-of select="$m_article"/> until you have first added it as an ordinary <xsl:value-of select="$m_article"/>.</xsl:variable>
	<xsl:variable name="m_generalerrorstatuschange">An error occurred whilst accessing the database and your request may not have been successfully processed.</xsl:variable>
	<xsl:variable name="m_noarticleerrorresearcherchange">You cannot add or remove researchers to <xsl:value-of select="$m_articlea"/>
		<xsl:value-of select="$m_article"/> until it has been created.</xsl:variable>
	<xsl:variable name="m_generalerrorresearcherchange">An error occurred whilst accessing the database and your request may not have been successfully processed.</xsl:variable>
	<xsl:variable name="m_initialiseerrorarticleinreview">There was a problem initialising the Review Forum.</xsl:variable>
	<xsl:variable name="m_guideentrydeletedsubj">
		<xsl:value-of select="$m_article"/> has been deleted</xsl:variable>
	<xsl:variable name="m_unrecognisedcommandsubj">Unrecognised command</xsl:variable>
	<xsl:variable name="m_unspecifiederrorsubj">Unspecified error</xsl:variable>
	<xsl:variable name="m_dberrorsubj">Error accessing database</xsl:variable>
	<xsl:variable name="m_homepageerrorstatuschangesubj">Cannot change status on homepage</xsl:variable>
	<xsl:variable name="m_notentryerrorstatuschangesubj">
		<xsl:value-of select="$m_article"/> does not exist</xsl:variable>
	<xsl:variable name="m_generalerrorstatuschangesubj">Error changing status</xsl:variable>
	<xsl:variable name="m_noarticleerrorresearcherchangesubj">Error changing researcher</xsl:variable>
	<xsl:variable name="m_generalerrorresearcherchangesubj">Error changing researcher</xsl:variable>
	<xsl:variable name="m_initialiseerrorarticleinreviewsubj">Error intialising Review Forum</xsl:variable>
	<xsl:variable name="m_ResList">Current researcher list: </xsl:variable>
	<xsl:variable name="m_ResListEdit">Type a list of researcher numbers, separated by commas, into the box below and press the Set Researchers button. If you remove any numbers from the list below they will also be removed from the researcher list.</xsl:variable>
	<xsl:variable name="m_SetResearchers">Set Researchers</xsl:variable>
	<xsl:variable name="m_ConfirmDeleteEntry">Are you sure you want to delete this entry?</xsl:variable>
	<xsl:variable name="m_GESubject">Subject of your Guide Entry</xsl:variable>
	<xsl:variable name="m_HideEntry">Hide this Entry: </xsl:variable>
	<xsl:variable name="m_PostTooManySmileys">The posting contained too many smileys. Please remove some and try again.</xsl:variable>
	<xsl:variable name="m_PleaseNoteCS">Please note: </xsl:variable>
	<xsl:variable name="m_PostYourePremod">Your <xsl:value-of select="$m_postings"/> are being pre-moderated and will only appear after they have been approved by a Moderator.</xsl:variable>
	<xsl:variable name="m_PostSitePremod">
		<xsl:value-of select="$m_TheSite"/> is currently being pre-moderated. This means that you can post normally, but your <xsl:value-of select="$m_postings"/> will not appear until they have been approved by a Moderator.</xsl:variable>
	<xsl:variable name="m_TheSite">The site</xsl:variable>
	<xsl:variable name="m_UserEditWarning">Please be very careful if you want to post an email address or instant messaging number, as you may receive lots of emails or messages. See the <A xsl:use-attribute-sets="nm_usereditwarning" HREF="{$root}HouseRules">House Rules</A> for more information.</xsl:variable>
	<xsl:variable name="m_TermsAndCondLink">
		<A xsl:use-attribute-sets="nm_usereditpagehouserulesdisclaimer" HREF="http://www.bbc.co.uk/terms/">Terms of use</A>
	</xsl:variable>
	<xsl:variable name="m_UserEditHouseRulesDiscl">Remember, when you contribute to the Site you are giving the BBC permission to use your contribution in a variety of ways. See the <xsl:copy-of select="$m_TermsAndCondLink"/> for more information.</xsl:variable>
	<xsl:variable name="m_LastPost">Last posting</xsl:variable>
	<xsl:variable name="m_MoveThread">Move thread</xsl:variable>
	<xsl:variable name="m_HideThread">Hide thread</xsl:variable>
	<xsl:variable name="m_UnhideThread">Unhide thread</xsl:variable>
	<xsl:variable name="m_NoConversations">There are no conversations to view.</xsl:variable>
	<xsl:variable name="m_morepostsothersites">All my <xsl:value-of select="$m_threads"/> from other sites</xsl:variable>
	<xsl:variable name="m_morepoststhissite">
		<xsl:value-of select="$m_clickmoreconv"/>
	</xsl:variable>
	<xsl:variable name="m_morearticlesothersites">All my <xsl:value-of select="$m_articles"/> from other sites</xsl:variable>
	<xsl:variable name="m_morearticlesthissite">
		<xsl:value-of select="$m_clickmoreentries"/>
	</xsl:variable>
	<xsl:variable name="m_norecentpostings">no recent postings</xsl:variable>
	<xsl:variable name="m_dnasignintext">This page has moved. Are you trying to <a href="{$signinlink}">sign</a> in or <a href="{$registerlink}">become a member</a>?</xsl:variable>
	<xsl:variable name="m_dnaregistertext">This page has moved. Are you trying to <a href="{$signinlink}">sign in</a> or <a href="{$registerlink}">become a member</a>?</xsl:variable>
	<!-- generic terms -->
	<xsl:variable name="m_user">Member</xsl:variable>
	<xsl:variable name="m_users">Members</xsl:variable>
	<xsl:variable name="m_usera"> a </xsl:variable>
	<xsl:variable name="m_article">Article</xsl:variable>
	<xsl:variable name="m_articles">Articles</xsl:variable>
	<xsl:variable name="m_articlea"> an </xsl:variable>
	<xsl:variable name="m_articleurl">Article</xsl:variable>
	<xsl:variable name="m_editedarticle">Edited Article</xsl:variable>
	<xsl:variable name="m_editedarticles">Edited Articles</xsl:variable>
	<xsl:variable name="m_uneditedarticles">Unedited Entries</xsl:variable>
	<xsl:variable name="m_editedarticlea"> an </xsl:variable>
	<xsl:variable name="m_editedguide">Edited Site</xsl:variable>
	<xsl:variable name="m_posting">Posting</xsl:variable>
	<xsl:variable name="m_postings">Postings</xsl:variable>
	<xsl:variable name="m_postinga"> a </xsl:variable>
	<xsl:variable name="m_postingurl">Posting</xsl:variable>
	<xsl:variable name="m_thread">Conversation</xsl:variable>
	<xsl:variable name="m_threads">Conversations</xsl:variable>
	<xsl:variable name="m_threada"> a </xsl:variable>
	<xsl:variable name="m_threadurl">Conversation</xsl:variable>
	<xsl:variable name="m_forum">Conversation Forum</xsl:variable>
	<xsl:variable name="m_forums">Conversation Forums</xsl:variable>
	<xsl:variable name="m_foruma"> a </xsl:variable>
	<xsl:variable name="m_journal">Journal</xsl:variable>
	<xsl:variable name="m_journals">Journals</xsl:variable>
	<xsl:variable name="m_journala"> a </xsl:variable>
	<xsl:variable name="m_journalposting">Journal Entry</xsl:variable>
	<xsl:variable name="m_journalpostings">Journal Entries</xsl:variable>
	<xsl:variable name="m_journalpostinga"> a </xsl:variable>
	<xsl:variable name="m_nosuchguideentry">No Such <xsl:value-of select="$m_article"/>
	</xsl:variable>
	<xsl:variable name="m_friendsblockdivider">
		<br/>
	</xsl:variable>
	<xsl:variable name="m_onlyshowusersfromthissite"> Only show users from this site.</xsl:variable>
	<xsl:variable name="m_onlyshowuserswhoupdatedpersonalspace"> Only show users who have updated their personal space.</xsl:variable>
	<xsl:variable name="m_deletemultiplefriends">Click here to delete more than one name</xsl:variable>
	<xsl:variable name="m_personalspace">Personal Space</xsl:variable>
	<xsl:variable name="m_deletethisfriend"> delete this name</xsl:variable>
	<xsl:variable name="m_my">My </xsl:variable>
	<xsl:variable name="m_friends">Friends</xsl:variable>
	<xsl:variable name="m_of"> of </xsl:variable>
	<xsl:variable name="m_friendslist">Friends List</xsl:variable>
	<xsl:variable name="m_postedby">Posted by </xsl:variable>
	<xsl:variable name="m_on"> on </xsl:variable>
	<xsl:variable name="m_onereplyposted">1 reply posted </xsl:variable>
	<xsl:variable name="m_noentriestodisplay">There are no entries to display</xsl:variable>
	<xsl:variable name="m_journalentriesbyfriends">Journal Entries by Friends</xsl:variable>
	<xsl:variable name="m_hasntaddedfriends"> hasn't added any friends to their list.</xsl:variable>
	<xsl:variable name="m_youremptyfriendslist">This is where your list of friends will appear. To add someone to your friends list, go to their Personal Space and click on 'Add to Friends'.<br/>
	</xsl:variable>
	<xsl:variable name="m_namesonyourfriendslist">The following names are on your friends list:<br/>
	</xsl:variable>
	<xsl:variable name="m_friendslistofuser">Here is the friends list of <xsl:value-of select="/H2G2/PAGE-OWNER/USER/USERNAME"/>:<br/>
	</xsl:variable>
	<xsl:variable name="m_namesaddedtofriends">You added the following name to your list of friends:</xsl:variable>
	<xsl:variable name="m_someusersdeleted">Some users deleted</xsl:variable>
	<xsl:variable name="m_deletedfollowingfriends">You have deleted the following name<xsl:if test="count(USER) &gt; 1">s</xsl:if> from your list of friends:</xsl:variable>
	<xsl:variable name="m_textonly">Text only</xsl:variable>
	<xsl:variable name="m_sendtofriend">Send it to a friend</xsl:variable>
	<xsl:variable name="m_unknownvisitor">Unknown Visitor</xsl:variable>
	<xsl:variable name="m_myconvsname">Name: </xsl:variable>
	<xsl:variable name="m_myconvslastposted">Last posted: </xsl:variable>
	<xsl:variable name="m_registernouser">If you're not a member of bbc.co.uk and do not want to become one right now you can <a href="{$root}">continue browsing</a>.</xsl:variable>
	<!-- end of messages -->
	<!-- text mostly used in Alt tags -->
	<xsl:variable name="alt_showoldest">Show Start of <xsl:value-of select="$m_thread"/>
	</xsl:variable>
	<xsl:variable name="alt_showolder">Show Older</xsl:variable>
	<xsl:variable name="alt_atstartofconv">Already at Start of <xsl:value-of select="$m_thread"/>
	</xsl:variable>
	<xsl:variable name="alt_noolderpost">No Older <xsl:value-of select="$m_postings"/> to Show</xsl:variable>
	<xsl:variable name="alt_showpostings">Show <xsl:value-of select="$m_postings"/>
		<xsl:text> </xsl:text>
	</xsl:variable>
	<xsl:variable name="alt_nonewerpost">No Newer <xsl:value-of select="$m_postings"/> to Show</xsl:variable>
	<xsl:variable name="alt_showlatestpost">Show Latest <xsl:value-of select="$m_postings"/>
	</xsl:variable>
	<xsl:variable name="alt_alreadyendconv">Already at End of <xsl:value-of select="$m_thread"/>
	</xsl:variable>
	<xsl:variable name="alt_newconversation">New <xsl:value-of select="$m_thread"/>
	</xsl:variable>
	<xsl:variable name="alt_shownewest">Show Newest <xsl:value-of select="$m_threads"/>
	</xsl:variable>
	<xsl:variable name="alt_showconvs">Show <xsl:value-of select="$m_threads"/>
		<xsl:text> </xsl:text>
	</xsl:variable>
	<xsl:variable name="alt_showposts">Show <xsl:value-of select="$m_postings"/>
		<xsl:text> </xsl:text>
	</xsl:variable>
	<xsl:variable name="alt_to"> to </xsl:variable>
	<xsl:variable name="alt_alreadynewestconv">Already Showing the Newest <xsl:value-of select="$m_threads"/>
	</xsl:variable>
	<xsl:variable name="alt_nonewconvs">No Newer <xsl:value-of select="$m_threads"/> to Show</xsl:variable>
	<xsl:variable name="alt_showoldestconv">Show Oldest <xsl:value-of select="$m_threads"/>
	</xsl:variable>
	<xsl:variable name="alt_prevpost">Previous <xsl:value-of select="$m_posting"/>
	</xsl:variable>
	<xsl:variable name="alt_noprevpost">There is no Previous <xsl:value-of select="$m_posting"/>
	</xsl:variable>
	<xsl:variable name="alt_nextpost">Next <xsl:value-of select="$m_posting"/>
	</xsl:variable>
	<xsl:variable name="alt_nonextpost">There is no Next <xsl:value-of select="$m_posting"/>
	</xsl:variable>
	<xsl:variable name="alt_prevreply">Previous Reply</xsl:variable>
	<xsl:variable name="alt_replyingtothis">Replying to this <xsl:value-of select="$m_posting"/>
	</xsl:variable>
	<xsl:variable name="alt_nextreply">Next Reply</xsl:variable>
	<xsl:variable name="alt_notareply">This is the First <xsl:value-of select="$m_posting"/> - it isn't a Reply</xsl:variable>
	<xsl:variable name="alt_nonewerreplies">No Newer Replies</xsl:variable>
	<xsl:variable name="alt_currentpost">This is the Current <xsl:value-of select="$m_posting"/>
	</xsl:variable>
	<xsl:variable name="alt_firstreply">First Reply to this <xsl:value-of select="$m_posting"/>
	</xsl:variable>
	<xsl:variable name="alt_noreplies">There are no Replies to this <xsl:value-of select="$m_posting"/>
	</xsl:variable>
	<xsl:variable name="alt_postmessage">Post Message</xsl:variable>
	<xsl:variable name="alt_storejournal">Store <xsl:value-of select="$m_journal"/>
	</xsl:variable>
	<xsl:variable name="alt_nowshowing">Now Showing </xsl:variable>
	<xsl:variable name="alt_show">Show </xsl:variable>
	<xsl:variable name="alt_discussthis">Discuss this <xsl:value-of select="$m_article"/>
	</xsl:variable>
	<xsl:variable name="alt_editthispage">Edit this Page</xsl:variable>
	<xsl:variable name="alt_editthisentry">Edit this <xsl:value-of select="$m_article"/>
	</xsl:variable>
	<xsl:variable name="alt_recommendthisentry">Recommend this <xsl:value-of select="$m_article"/>
	</xsl:variable>
	<xsl:variable name="alt_thisentrysubbed">Return this subbed <xsl:value-of select="$m_article"/> to the Editorial staff</xsl:variable>
	<xsl:variable name="alt_emailthispagetoafriend">Email this <xsl:value-of select="$m_article"/> to a Friend</xsl:variable>
	<xsl:variable name="alt_keywords">Keywords to Search for</xsl:variable>
	<xsl:variable name="alt_searchtheguide">Search the Site</xsl:variable>
	<xsl:variable name="alt_frontpage">Front Page</xsl:variable>
	<xsl:variable name="alt_register">Register</xsl:variable>
	<xsl:variable name="alt_myspace">My Space</xsl:variable>
	<xsl:variable name="alt_dontpanic">Don't Panic! Click here for Help!</xsl:variable>
	<xsl:variable name="alt_askh2g2">Ask</xsl:variable>
	<xsl:variable name="alt_tellh2g2">Tell</xsl:variable>
	<xsl:variable name="alt_feedbackforum">Feedback</xsl:variable>
	<xsl:variable name="alt_whosonline">Who is Online</xsl:variable>
	<xsl:variable name="alt_shop">Shop</xsl:variable>
	<xsl:variable name="alt_preferences">Preferences</xsl:variable>
	<xsl:variable name="alt_aboutus">About Us</xsl:variable>
	<xsl:variable name="alt_logout">Logout</xsl:variable>
	<xsl:variable name="alt_showingoldest">Already Showing the Oldest <xsl:value-of select="$m_threads"/>
	</xsl:variable>
	<xsl:variable name="alt_noolderreplies">No Older Replies</xsl:variable>
	<xsl:variable name="alt_reply">Reply</xsl:variable>
	<xsl:variable name="alt_complain">Click here to register a complaint about this <xsl:value-of select="$m_posting"/>
	</xsl:variable>
	<xsl:variable name="alt_logotext">Front Page</xsl:variable>
	<xsl:variable name="alt_addjournal">Add <xsl:value-of select="$m_journalposting"/>
	</xsl:variable>
	<xsl:variable name="alt_previewmess">Preview Message</xsl:variable>
	<xsl:variable name="alt_postmess">Post Message</xsl:variable>
	<xsl:variable name="alt_contentofguideentry">Contents of your <xsl:value-of select="$m_article"/>
	</xsl:variable>
	<xsl:variable name="alt_previewhowlook">Preview how this <xsl:value-of select="$m_article"/> will Look</xsl:variable>
	<xsl:variable name="alt_storethis">Store this as a New <xsl:value-of select="$m_article"/>
	</xsl:variable>
	<xsl:variable name="alt_clickherehelpentry">Click here for help on how to write your <xsl:value-of select="$m_article"/>
	</xsl:variable>
	<xsl:variable name="alt_mapclickhereplaintexthelpentry">How to write Entries in Plain Text</xsl:variable>
	<xsl:variable name="alt_mapclickhereguidehelpentry">How to write Entries in GuideML</xsl:variable>
	<xsl:variable name="alt_mapclickheremaphelpentry">How to add map locations to your Entry</xsl:variable>
	<xsl:variable name="alt_subreturntoconv">Return+to+the+<xsl:value-of select="$m_threadurl"/>
	</xsl:variable>
	<xsl:variable name="alt_subreturntoarticle">Return+to+the+<xsl:value-of select="$m_articleurl"/>
	</xsl:variable>
	<xsl:variable name="alt_subreturntospace">Return+to+your+Personal+Space</xsl:variable>
	<xsl:variable name="alt_subreturntopostlist">Return+to+the+<xsl:value-of select="$m_postingurl"/>+list</xsl:variable>
	<xsl:variable name="alt_login">Sign in</xsl:variable>
	<xsl:variable name="alt_searchbutton">Search</xsl:variable>
	<xsl:variable name="alt_inviteuser">Invite Someone to Join</xsl:variable>
	<xsl:variable name="alt_onlineform">Select an Ordering</xsl:variable>
	<xsl:variable name="alt_onlineorderbyid">Order by <xsl:value-of select="$m_user"/> ID</xsl:variable>
	<xsl:variable name="alt_onlineorderbyname">Order by Username</xsl:variable>
	<xsl:variable name="alt_onlineorderbyregistered">Order by Date Registered</xsl:variable>
	<xsl:variable name="alt_changepasswordlogin">Change Password and Log In</xsl:variable>
	<xsl:variable name="alt_read">Read</xsl:variable>
	<xsl:variable name="alt_talk">Talk</xsl:variable>
	<xsl:variable name="alt_contribute">Contribute</xsl:variable>
	<xsl:variable name="alt_preferencestitle">Change your Personal Details and Settings</xsl:variable>
	<xsl:variable name="alt_discussthistitle">Click here to Start a New <xsl:value-of select="$m_thread"/> for this <xsl:value-of select="$m_article"/>
	</xsl:variable>
	<xsl:variable name="alt_editentry">Edit <xsl:value-of select="$m_article"/>
	</xsl:variable>
	<xsl:variable name="alt_help">Help!</xsl:variable>
	<xsl:variable name="alt_bbconlinehome">bbc.co.uk home</xsl:variable>
	<xsl:variable name="alt_AllocateEntriesToThisSub">Allocate <xsl:value-of select="$m_articles"/> to this Sub-editor</xsl:variable>
	<xsl:variable name="alt_DeleteGE">Delete this Entry</xsl:variable>
	<!-- Was a month on h2G2: -->
	<xsl:variable name="alt_MonthSummarySub">The Last Month</xsl:variable>
	<xsl:variable name="alt_notforreview">Not for Review</xsl:variable>
	<xsl:variable name="alt_submittoreviewforum">Submit for Review</xsl:variable>
	<xsl:variable name="alt_returntoreviewforum">Return+to+the+Review+Forum</xsl:variable>
	<xsl:variable name="alt_rf_showconvs">Show <xsl:value-of select="$m_articles"/>
		<xsl:text> </xsl:text>
	</xsl:variable>
	<xsl:variable name="alt_rf_shownewest">Go to Beginning of List</xsl:variable>
	<xsl:variable name="alt_rf_alreadynewestconv">Already Showing the Latest <xsl:value-of select="$m_articles"/>
	</xsl:variable>
	<xsl:variable name="alt_rf_nonewconvs">No More <xsl:value-of select="$m_articles"/> to Show</xsl:variable>
	<xsl:variable name="alt_rf_showoldestconv">Go to End of List</xsl:variable>
	<xsl:variable name="alt_rf_noolderconv">No More <xsl:value-of select="$m_articles"/> to Show</xsl:variable>
	<xsl:variable name="alt_rf_showingoldest">Already Showing the Last <xsl:value-of select="$m_articles"/>
	</xsl:variable>
	<xsl:variable name="alt_submittoreviewforumbutton">Submit <xsl:value-of select="$m_article"/> to the chosen Review Forum</xsl:variable>
	<xsl:variable name="alt_firstpage">First Page</xsl:variable>
	<xsl:variable name="alt_lastpage">Last Page</xsl:variable>
	<xsl:variable name="alt_previouspage">Previous Page</xsl:variable>
	<xsl:variable name="alt_nextpage">Next Page</xsl:variable>
	<xsl:variable name="alt_alreadyfirstpage">Already Showing the First Page</xsl:variable>
	<xsl:variable name="alt_alreadylastpage">Already Showing the Last Page</xsl:variable>
	<xsl:variable name="alt_nopreviouspage">There is no Previous Page</xsl:variable>
	<xsl:variable name="alt_nonextpage">There is no Next Page</xsl:variable>
	<xsl:variable name="alt_showitems">Items </xsl:variable>
	<xsl:variable name="alt_RemoveSelf">Remove My Name</xsl:variable>
	<!-- end of alt tags -->
	<!-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ -->
	<!-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ -->
	<!--                                                                TAKEN FROM base-text-andy.xsl                                               -->
	<!-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ -->
	<!-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ -->
	<xsl:variable name="m_addtofriends">Add to Friends</xsl:variable>
	<xsl:variable name="m_noposters">Sorry there are no posters</xsl:variable>
	<xsl:variable name="m_nothreads">Sorry there are no threads</xsl:variable>
	<xsl:variable name="m_noarticles">Sorry there are no articles</xsl:variable>
	<xsl:variable name="m_subjectempty">&lt;No Subject&gt;</xsl:variable>
	<xsl:variable name="m_firstpagethreads">First Page</xsl:variable>
	<xsl:variable name="m_nofirstpagethreads">You are on the First Page</xsl:variable>
	<xsl:variable name="m_lastpagethreads">Last Page</xsl:variable>
	<xsl:variable name="m_nolastpagethreads">You are on the Last Page</xsl:variable>
	<xsl:variable name="m_previouspagethreads">Previous Page</xsl:variable>
	<xsl:variable name="m_nopreviouspagethreads">No Previous Pages</xsl:variable>
	<xsl:variable name="m_nextpagethreads">Next Page</xsl:variable>
	<xsl:variable name="m_nonextpagethreads">No Next Pages</xsl:variable>
	<xsl:variable name="m_forumpostingsdisclaimer">Disclaimer!!!!</xsl:variable>
	<xsl:variable name="m_lastreplyjournalpage">Latest reply:</xsl:variable>
	<xsl:variable name="m_noofrepliesjournalpage">replies</xsl:variable>
	<xsl:variable name="m_norepliesjournalpage">No replies</xsl:variable>
	<xsl:variable name="m_discusslinkjournalpage">Discuss this</xsl:variable>
	<xsl:variable name="m_removelinkjournalpage">Remove Journal Entry</xsl:variable>
	<xsl:variable name="m_newerjournalentries">Newer Posts</xsl:variable>
	<xsl:variable name="m_olderjournalentries">Older Posts</xsl:variable>
	<xsl:variable name="m_logoutblurb">
		<p>You have just logged out. The next time you visit on this computer we won't automatically recognise you.</p>
		<p>To log in again, go to the front page and follow the link.</p>
	</xsl:variable>
	<xsl:variable name="m_notfoundbody">
		<p>We're sorry, but the page you have requested does not exist. This could be because the URL
		<a xsl:use-attribute-sets="nm_notfoundbody1" TITLE="That's the address of the web page that we can't find - it should begin with http://www.bbc.co.uk{$root}" NAME="back1" HREF="#footnote1">
				<sup>1</sup>
			</a>
		is wrong, or because the page you are looking for has been removed from the Site.</p>
		<blockquote>
			<font size="-1">
				<hr/>
				<a name="footnote1">
					<a xsl:use-attribute-sets="nm_notfoundbody2" href="#back1">
						<sup>1</sup>
					</a> 
					That's the address of the web page that we can't find - it should begin with 
					http://www.bbc.co.uk<xsl:value-of select="$root"/>
				</a>
			</font>
		</blockquote>
	</xsl:variable>
	<xsl:variable name="m_previousindexentries" select="concat($m_previous, ' ', /H2G2/INDEX/@COUNT, ' ', $m_entries)"/>
	<xsl:variable name="m_moreindexentries" select="concat($m_nextspace, ' ', /H2G2/INDEX/@COUNT, ' ', $m_entries)"/>
	<xsl:variable name="m_cantpostagreedterms">You haven't agreed to the standard terms and conditions for this site.</xsl:variable>
	<xsl:variable name="m_cantpostnotregistered">We're sorry, but you can't have a journal without being registered.</xsl:variable>
	<xsl:template name="m_newuserslistempty">
		No new <xsl:value-of select="$m_users"/> have joined us in the last
		<xsl:if test="number(../@TIMEUNITS) &gt; 1">
			<xsl:text> </xsl:text>
			<xsl:value-of select="../@TIMEUNITS"/>
		</xsl:if>
		<xsl:text> </xsl:text>
		<xsl:value-of select="../@UNITTYPE"/>
		<xsl:if test="number(../@TIMEUNITS) &gt; 1">
			<xsl:text>s</xsl:text>
		</xsl:if>
		<xsl:text>.</xsl:text>
	</xsl:template>
	<xsl:variable name="m_clubcreationtitle">Club Creation</xsl:variable>
	<xsl:variable name="m_clubBodyInput">Club Body text:</xsl:variable>
	<xsl:variable name="m_clubTypeInput">Club Type selection:</xsl:variable>
	<xsl:variable name="m_clubTypeClosed">closed</xsl:variable>
	<xsl:variable name="m_clubTypeOpen">open</xsl:variable>
	<xsl:variable name="m_clubTitleInput">Club Title text:</xsl:variable>
	<xsl:variable name="m_errorMessage">This is an error:</xsl:variable>
	<xsl:variable name="m_teamlist">Team List</xsl:variable>
	<xsl:variable name="m_memberintro">This is the Member teamlist</xsl:variable>
	<xsl:variable name="m_ownerintro">This is the Owner teamlist</xsl:variable>
	<xsl:variable name="m_nousername">No Username</xsl:variable>
	<xsl:variable name="m_previousteammembers">Previous Team Members</xsl:variable>
	<xsl:variable name="m_nextteammembers">Next Team Members</xsl:variable>
	<xsl:variable name="m_nopreviousteammembers">No Previous Team Members</xsl:variable>
	<xsl:variable name="m_nonextteammembers">No Next Team Members</xsl:variable>
	<xsl:variable name="m_moreteammembers">more team members</xsl:variable>
	<xsl:variable name="m_catagoriseintroduction">Catagorise your club:</xsl:variable>
	<xsl:variable name="m_nocatagories">No catagories match your search</xsl:variable>
	<xsl:variable name="m_articlecomplaintdescription">
		Fill in this form to register a complaint about the <xsl:value-of select="$m_article"/> '<xsl:value-of select="/H2G2/USER-COMPLAINT-FORM/SUBJECT"/>', edited by <xsl:apply-templates select="/H2G2/USER-COMPLAINT-FORM/AUTHOR/USER"/>.
	</xsl:variable>
	<xsl:variable name="m_postingcomplaintdescription">
		Fill in this form to register a complaint about the <xsl:value-of select="$m_posting"/> '<xsl:value-of select="/H2G2/USER-COMPLAINT-FORM/SUBJECT"/>', written by <xsl:apply-templates select="/H2G2/USER-COMPLAINT-FORM/AUTHOR/USER"/>.
	</xsl:variable>
	<xsl:variable name="m_generalcomplaintdescription">
		Register a complaint about the content of this page.
	</xsl:variable>
	<xsl:variable name="m_reviewforuminfoheader">
		 Review Forum Data
	</xsl:variable>
	<xsl:variable name="m_recommendablereviewforum">
		 Recommendable review forum
	</xsl:variable>
	<xsl:variable name="m_notrecommendablereviewforum">
		 Not recommendable review forum
	</xsl:variable>
	<xsl:variable name="m_srfinitialtext">
		A<xsl:value-of select="/H2G2/SUBMIT-REVIEW-FORUM/ARTICLE/@H2G2ID"/> - <xsl:value-of select="/H2G2/SUBMIT-REVIEW-FORUM/ARTICLE"/>
		<br/>
		<br/>
		To put this <xsl:value-of select="$m_article"/> into review, select the relevant Review Forum and enter your comments below.
	</xsl:variable>
	<xsl:variable name="m_srffinaltext">
		For more information about Review Forums, please read the Review Forum FAQ.
		<br/>
		<br/>
		<a>
			<xsl:attribute name="href">A<xsl:value-of select="/H2G2/SUBMIT-REVIEW-FORUM/ARTICLE/@H2G2ID"/></xsl:attribute>
		Click here to return to the <xsl:value-of select="$m_article"/> without putting it into a Review Forum</a>
	</xsl:variable>
	<xsl:variable name="m_actionlistheader">Club Requests:</xsl:variable>
	<xsl:variable name="m_yourrequests">Here are some requests you have made to clubs which haven't been accepted yet:</xsl:variable>
	<xsl:variable name="m_invitations">Here are some invitations for you to join clubs which you should respond to:</xsl:variable>
	<xsl:variable name="m_previousactions">Here are some previous membership actions:</xsl:variable>
	<xsl:variable name="m_joinmember2ndperson">You asked to join </xsl:variable>
	<xsl:variable name="m_joinowner2ndperson">You asked to join </xsl:variable>
	<xsl:variable name="m_invitemember2ndperson">You were invited to join </xsl:variable>
	<xsl:variable name="m_inviteowner2ndperson">You were invited to own </xsl:variable>
	<xsl:variable name="m_ownerresignsmember2ndperson">You resigned as an owner from </xsl:variable>
	<xsl:variable name="m_ownerresignscompletely2ndperson">You resigned from </xsl:variable>
	<xsl:variable name="m_memberresigns2ndperson">You resigned from </xsl:variable>
	<xsl:variable name="m_demoteownertomember2ndperson">You were demoted from </xsl:variable>
	<xsl:variable name="m_removeowner2ndperson">You were removed from </xsl:variable>
	<xsl:variable name="m_removemember2ndperson">You were removed from </xsl:variable>
	<xsl:variable name="m_acceptlink">Accept</xsl:variable>
	<xsl:variable name="m_rejectlink">Reject</xsl:variable>
	<xsl:variable name="m_registertodiscuss">
		<p>If you <a xsl:use-attribute-sets="nm_registertodiscuss" href="{$sso_registerlink}">register</a> you can discuss this article with other users.</p>
	</xsl:variable>
	<xsl:variable name="m_useronlineflag">**</xsl:variable>
	<xsl:variable name="unregisteredslug">
		<p>
			<font xsl:use-attribute-sets="mainfont">
				<b>
					<font size="3">Add your Opinion!</font>
					<br/>
					<br/>There are many articles, written by our users. If you want to be able to add your own opinions to the Site, simply <a href="{$registerlink}">register</a> as a user.

				</b>
			</font>
		</p>
	</xsl:variable>
	<xsl:variable name="m_registernav">Register</xsl:variable>
	<xsl:variable name="m_loginnav">Login</xsl:variable>
	<xsl:variable name="m_userpagenav">User Page</xsl:variable>
	<xsl:variable name="m_contributenav">Contribute</xsl:variable>
	<xsl:variable name="m_preferencesnav">Preferences</xsl:variable>
	<xsl:variable name="m_logoutnav">Logout</xsl:variable>
	<xsl:variable name="m_moreclubs">See more clubs</xsl:variable>
	<xsl:variable name="m_morearticles">See more articles</xsl:variable>
	<xsl:variable name="m_ucinvalidemailformat">Email address should be in format of aa@bb.cc</xsl:variable>
	<xsl:variable name="m_ucdefaultcomplainttext">Please give details of your complaint here.</xsl:variable>
	<xsl:variable name="m_ucnodetailsalert">Please describe the nature of your complaint in the text area provided.</xsl:variable>
	<xsl:variable name="m_usermyclubs">Your Clubs</xsl:variable>
	<xsl:variable name="m_clubsummarytitle">Clubs Summary</xsl:variable>
	<xsl:variable name="m_nonewactivity">No Activity</xsl:variable>
	<xsl:variable name="m_newactivity">New Activity</xsl:variable>
	<xsl:variable name="m_clubreviewtitle">Clubs Review</xsl:variable>
	<xsl:variable name="m_memberstitle">Members:</xsl:variable>
	<xsl:variable name="m_membersnewtitle">New Members:</xsl:variable>
	<xsl:variable name="m_membersalltitle">All Members:</xsl:variable>
	<xsl:variable name="m_commentstitle">Comments:</xsl:variable>
	<xsl:variable name="m_commentsnewtitle">New Comments:</xsl:variable>
	<xsl:variable name="m_commentsalltitle">All Comments:</xsl:variable>
	<xsl:variable name="m_statustitle">Membership Status:</xsl:variable>
	<xsl:variable name="m_changestatus">Change Status</xsl:variable>
	<xsl:variable name="m_roletitle">Current Role:</xsl:variable>
	<xsl:variable name="m_changerole">Change Role</xsl:variable>
	<xsl:variable name="m_pendingtitle">Pending Actions:</xsl:variable>
	<xsl:variable name="m_completedtitle">Completed Actions:</xsl:variable>
	<xsl:variable name="m_editclublink">edit club</xsl:variable>
	<xsl:variable name="m_viewclublink">view club</xsl:variable>
	<xsl:variable name="m_managelinks">Manage Links</xsl:variable>
	<xsl:variable name="m_viewfolders">View Folders</xsl:variable>
	<xsl:variable name="m_backtofolders">Back to Folders</xsl:variable>
	<xsl:variable name="m_editfolder">Edit Folder</xsl:variable>
	<xsl:variable name="m_editlink">Edit Link</xsl:variable>
	<xsl:variable name="m_finishediting">Finish Editing</xsl:variable>
	<xsl:variable name="m_changefoldername">Change folder name</xsl:variable>
	<xsl:variable name="m_deletefolder">Delete Folder</xsl:variable>
	<xsl:variable name="m_agree">Agree</xsl:variable>
	<xsl:variable name="m_cancel">Cancel</xsl:variable>
	<xsl:variable name="m_leaveprivatemessage">Leave me a private message</xsl:variable>
	<xsl:variable name="m_nolinks">No Links</xsl:variable>
	<xsl:variable name="m_userpagemoreclubs">more clubs</xsl:variable>
	<xsl:variable name="m_searchpagetitle">Search</xsl:variable>
	<xsl:variable name="m_searchresultstitle">Search Results</xsl:variable>
	<xsl:variable name="m_searcharticles">Search Articles</xsl:variable>
	<xsl:variable name="m_searchusers">Search Users</xsl:variable>
	<xsl:variable name="m_searchuserforums">Search Forums</xsl:variable>
	<xsl:variable name="m_allresults">Show all articles</xsl:variable>
	<xsl:variable name="m_recommendedresults">Show recommended articles</xsl:variable>
	<xsl:variable name="m_editedresults">Show edited articles</xsl:variable>
	<xsl:variable name="m_searchresultsfor">You searched for</xsl:variable>
	<xsl:variable name="m_defaultfoldername">Default</xsl:variable>
	<!-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ -->
	<!-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ -->
	<!--                                                                 END OF base-text-andy.xsl                                                        -->
	<!-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ -->
	<!-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ -->
	<!-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ -->
	<!-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ -->
	<!--                                                                 TAKEN FROM base-extratext.xsl                                               -->
	<!-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ -->
	<!-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ -->
	<!-- TEMPORARY TEMPORARY TEMPORARY TEMPORARY TEMPORARY TEMPORARY TEMPORARY TEMPORARY  -->
	<xsl:attribute-set name="vm_clubunregisteredmessage" use-attribute-sets="clubpagelinks"/>
	<xsl:attribute-set name="clubpagelinks" use-attribute-sets="linkatt"/>
	<xsl:variable name="m_clipuserpage">add to clippings</xsl:variable>
	<xsl:variable name="m_cliparticle">add to clippings</xsl:variable>
	<xsl:variable name="m_clipcategorypage">add to clippings</xsl:variable>
	<xsl:variable name="m_unnameduser">an unnamed user</xsl:variable>
	<xsl:variable name="m_unregisteredslug"> If you want to be able to add your own opinions to the Site, simply <a href="{$registerlink}">Register</a> or <a href="{$signinlink}">Sign in</a> as a member.</xsl:variable>
	<!-- ==========================         Club           =========================== -->
	<xsl:variable name="m_removeowner">remove this owner completely</xsl:variable>
	<xsl:variable name="m_demoteownertomember">demote this owner to be a member</xsl:variable>
	<xsl:variable name="m_removemember">remove this member completely</xsl:variable>
	<xsl:variable name="m_visiblevote"> Visible</xsl:variable>
	<xsl:variable name="m_hiddenvote"> Hidden</xsl:variable>
	<xsl:variable name="m_supporting">Supporting: </xsl:variable>
	<xsl:variable name="m_opposing">Opposing: </xsl:variable>
	<xsl:variable name="m_support">Support</xsl:variable>
	<xsl:variable name="m_oppose">Oppose</xsl:variable>
	<xsl:variable name="m_votetitle">Vote on this</xsl:variable>
	<xsl:variable name="m_votetext">How would you like to vote?</xsl:variable>
	<xsl:variable name="m_clubowners">Club Owners</xsl:variable>
	<xsl:variable name="m_clubmembers">Club Members</xsl:variable>
	<xsl:variable name="m_clubsubject">Club: <xsl:value-of select="/H2G2/CLUB/CLUBINFO/TITLE"/>
	</xsl:variable>
	<xsl:variable name="m_discussclubjournalentry">Discuss this Journal entry</xsl:variable>
	<xsl:variable name="m_journalownercantread">You are not permitted to view your journal</xsl:variable>
	<xsl:variable name="m_journalviewercantread">You are not authorised to view this journal</xsl:variable>
	<xsl:variable name="m_inviteasowner">Invite as an owner</xsl:variable>
	<xsl:variable name="m_requestmembership"/>
	<xsl:variable name="m_requestownership">Request to become an owner</xsl:variable>
	<xsl:variable name="m_managemembers"/>
	<xsl:variable name="m_useronlineflagmp" select="$m_useronlineflag"/>
	<xsl:variable name="m_editpermissions">Edit Permissions</xsl:variable>
	<xsl:variable name="m_managerequests">Manage Requests</xsl:variable>
	<xsl:variable name="m_clickaddclubjournal">Add journal entry</xsl:variable>
	<xsl:variable name="m_clickmoreclubjournal">Click here to see more journal postings</xsl:variable>
	<xsl:variable name="m_clubjournalownerfull">These are your journal entries:</xsl:variable>
	<xsl:variable name="m_clubjournalviewerfull">These are the journal entries for this club: </xsl:variable>
	<xsl:variable name="m_clubjournalownercantread">You are not permitted to view your Journal.</xsl:variable>
	<xsl:variable name="m_clubjournalviewercantread">You are not permitted to view this Journal.</xsl:variable>
	<xsl:variable name="m_clubjournalownerempty">This is where the Journal entries for your club would appear.</xsl:variable>
	<xsl:variable name="m_clubjournalviewerempty">This is where this club's journal would appear</xsl:variable>
	<xsl:variable name="m_fullclubforummessage">People have been talking about this club, here are the latest conversations:</xsl:variable>
	<xsl:variable name="m_emptyclubforummessage">Be the first person to talk about this club.</xsl:variable>
	<xsl:variable name="m_clubunregisteredmessage">If you <a xsl:use-attribute-sets="vm_clubunregisteredmessage" href="{$root}register">register</a> you can discuss this club with other users.</xsl:variable>
	<xsl:variable name="m_clubreplies">replies</xsl:variable>
	<xsl:variable name="m_clubreply">reply</xsl:variable>
	<xsl:variable name="m_clubcommentby">From: </xsl:variable>
	<xsl:variable name="m_clubcommentsintro_ownerfull">Here's what people have been saying about your initiative: </xsl:variable>
	<xsl:variable name="m_clubcommentsintro_viewerfull">Here's what people are saying about this initiative: </xsl:variable>
	<xsl:variable name="m_clubcommentsintro_ownerempty">Nobody has commented on your initiative yet.</xsl:variable>
	<xsl:variable name="m_clubcommentsintro_viewerempty">Nobody has commented on this initiative yet.</xsl:variable>
	<xsl:variable name="m_makeclubcommentfull">Make your own comment</xsl:variable>
	<xsl:variable name="m_makeclubcommentempty">Make your own comment</xsl:variable>
	<xsl:variable name="m_clubcommentstitle">Comments</xsl:variable>
	<xsl:variable name="m_removeclubjournal">Remove journal</xsl:variable>
	<xsl:variable name="m_clubjournaltitle">Journal</xsl:variable>
	<xsl:variable name="m_clublastposting">Last posting: </xsl:variable>
	<xsl:variable name="m_clipissuepage">add to clippings</xsl:variable>
	<xsl:variable name="m_forumownerfull"/>
	<xsl:variable name="m_forumviewerfull"/>
	<xsl:variable name="m_forumownerempty">This section will display details of any <xsl:value-of select="$m_postings"/> you make to <xsl:value-of select="$m_threads"/>. This is really useful: by checking out this section you can keep track of <xsl:value-of select="$m_threads"/> you are involved in and can see if anyone has replied to your <xsl:value-of select="$m_postings"/>, and when.</xsl:variable>
	<xsl:variable name="m_forumviewerempty">This section will display details of any <xsl:value-of select="$m_postings"/> this <xsl:value-of select="$m_user"/> makes, when they get around to talking to the rest of the Community. <xsl:value-of select="$m_threads"/> are really fun and are the best way to meet people, as well as the best way to get people to visit your own Personal Space, so let's hope they join in soon.</xsl:variable>
	<xsl:variable name="m_artownerfull">This is a list of the most recent articles you have created.</xsl:variable>
	<xsl:variable name="m_artviewerfull">These are all the <xsl:value-of select="$m_articles"/> this <xsl:value-of select="$m_user"/> has created. If you'd like to read them, click on the link, and if you want to talk about them, use the 'Discuss this <xsl:value-of select="$m_article"/>' button when you get there.</xsl:variable>
	<xsl:variable name="m_artownerempty">Whenever you write <xsl:value-of select="$m_articlea"/>
		<xsl:value-of select="$m_article"/> it will appear here, and if you ever want to edit one of your <xsl:value-of select="$m_articles"/> you can do so simply by clicking on the 'Edit' link. Any <xsl:value-of select="$m_articles"/> you create are automatically added to the Site and will appear in search results. <a xsl:use-attribute-sets="nm_artownerempty" href="{$root}useredit">Click here if you want to get writing straight away.</a>
	</xsl:variable>
	<xsl:variable name="m_artviewerempty">When this <xsl:value-of select="$m_user"/> writes some <xsl:value-of select="$m_articles"/> they will appear here, but they haven't got round to it yet. We're sure they will soon...</xsl:variable>
	<xsl:variable name="m_editownerfull">This is a list of <xsl:value-of select="$m_editedarticles"/> to which you have contributed.</xsl:variable>
	<xsl:variable name="m_editviewerfull">These are all the <xsl:value-of select="$m_editedarticles"/> to which this <xsl:value-of select="$m_user"/> has contributed.</xsl:variable>
	<xsl:variable name="m_editownerempty">If one of your <xsl:value-of select="$m_articles"/> has been recommended for the <xsl:value-of select="$m_editedguide"/> and the Editors have given it their stamp of approval or have used a part of it in <xsl:value-of select="$m_editedarticlea"/>
		<xsl:value-of select="$m_editedarticle"/>, then the details will appear here.</xsl:variable>
	<xsl:variable name="m_editviewerempty">This <xsl:value-of select="$m_user"/> hasn't had any <xsl:value-of select="$m_articles"/> picked for editing, yet... but we're sure they soon will.</xsl:variable>
	<xsl:variable name="m_registertodiscussuserpage">If you <a xsl:use-attribute-sets="nm_registertodiscuss" href="{$root}register">register</a> you can discuss this <xsl:value-of select="$m_article"/> with other <xsl:value-of select="$m_users"/>.</xsl:variable>
	<xsl:variable name="m_clickmoreuserpageconv">Click here to see more <xsl:value-of select="$m_threads"/>
	</xsl:variable>
	<xsl:variable name="m_mustsavefirstmessage">None of your changes will take effect until you press the <xsl:choose>
			<xsl:when test="/H2G2/ARTICLE-EDIT-FORM/MASTHEAD[.='1']">
				<xsl:choose>
					<xsl:when test="/H2G2/ARTICLE-EDIT-FORM/FUNCTIONS/ADDENTRY">
						<xsl:value-of select="$m_addintroduction"/>
					</xsl:when>
					<xsl:when test="/H2G2/ARTICLE-EDIT-FORM/FUNCTIONS/UPDATE">
						<xsl:value-of select="$m_updateintroduction"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$m_updateintroduction"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="/H2G2/ARTICLE-EDIT-FORM/FUNCTIONS/ADDENTRY">
						<xsl:value-of select="$m_addguideentry"/>
					</xsl:when>
					<xsl:when test="/H2G2/ARTICLE-EDIT-FORM/FUNCTIONS/UPDATE">
						<xsl:value-of select="$m_updateentry"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$m_updateentry"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose> button.</xsl:variable>
	<xsl:variable name="m_notforreview_explanation">Tick the 'Not for Review' box if you <I>don't</I> want your <xsl:value-of select="$m_article"/> to be available for review (see the <a xsl:use-attribute-sets="nm_notforreview_explanation" href="DontPanic-ReviewForums">Review Forums FAQ</a> for more information)</xsl:variable>
	<xsl:variable name="m_inreviewtextandlink">
The <xsl:value-of select="$m_article"/> you are trying to delete is currently in the Review Forum '<xsl:value-of select="INREVIEW/REVIEWFORUM/FORUMNAME"/>'. <br/>
		<br/>
If you would like to remove the <xsl:value-of select="$m_article"/> from '<xsl:value-of select="INREVIEW/REVIEWFORUM/FORUMNAME"/>' and delete it then click <a xsl:use-attribute-sets="nm_inreviewtextandlink1">
			<xsl:attribute name="href"><xsl:value-of select="$root"/>UserEdit<xsl:value-of select="INREVIEW/ARTICLE/@H2G2ID"/>?cmd=deletereview</xsl:attribute>here</a>.<br/>
		<br/>
Alternatively you can go back to <a xsl:use-attribute-sets="nm_inreviewtextandlink2">
			<xsl:attribute name="href"><xsl:value-of select="$root"/>UserEdit<xsl:value-of select="INREVIEW/ARTICLE/@H2G2ID"/></xsl:attribute>editing the <xsl:value-of select="$m_article"/> without deleting it</a>.<br/>
	</xsl:variable>
	<xsl:variable name="m_articleuserpremodblurb">
		<p>
			<b>Please note:</b> Your <xsl:value-of select="$m_articles"/> are being pre-moderated and will only appear after they have been approved by a Moderator.
</p>
	</xsl:variable>
	<xsl:variable name="m_articlepremodblurb">
		<p>The site is currently being pre-moderated. This means that you can create and edit <xsl:value-of select="$m_articles"/> normally, but they will not be visible until they have been approved by a Moderator.</p>
	</xsl:variable>
	<xsl:variable name="m_removejournalup">Remove Journal</xsl:variable>
	<xsl:variable name="m_userpremodmessage">Please note: Your <xsl:value-of select="$m_postings"/> are being pre-moderated and will only appear after they have been approved by a Moderator.</xsl:variable>
	<xsl:variable name="m_replytothispost_tp">Write a reply to this <xsl:value-of select="$m_posting"/>
	</xsl:variable>
	<xsl:variable name="m_thisconvforentry_tp">This is the <xsl:value-of select="$m_forum"/> for </xsl:variable>
	<xsl:variable name="m_thismessagecentre_tp">This is the Message Centre for </xsl:variable>
	<xsl:variable name="m_thisjournal_tp">This is the <xsl:value-of select="$m_journal"/> of </xsl:variable>
	<xsl:variable name="m_thisconvforclub_tp">This is the conversation for the club: </xsl:variable>
	<xsl:variable name="m_returntoclub">Click here to return to the club without saying anything</xsl:variable>
	<xsl:variable name="m_privatemessages">Private Messages</xsl:variable>
	<xsl:variable name="m_privateforumfull">Here are your private messages:</xsl:variable>
	<xsl:variable name="m_privateforumempty">You have no private messages.</xsl:variable>
	<xsl:variable name="m_privateforumviewer">Here are this person's private messages: </xsl:variable>
	<xsl:variable name="m_privateforumviewerempty">This person has no private messages.</xsl:variable>
	<xsl:variable name="m_privatemessagelatestpost">Last posting: </xsl:variable>
	<xsl:variable name="m_theseprivatemessages">These are the private messages for </xsl:variable>
	<xsl:variable name="m_editmembership">Edit membership details</xsl:variable>
	<!--============================ARTICLE PAGE============================-->
	<xsl:variable name="url_complain">
		<xsl:choose>
			<xsl:when test="/H2G2/ARTICLE/ARTICLEINFO/H2G2ID &gt; 0">javascript:popupwindow('/dna/<xsl:value-of select="/H2G2/CURRENTSITEURLNAME"/>/comments/UserComplaintPage?s_start=1&amp;h2g2ID=<xsl:value-of select="/H2G2/ARTICLE/ARTICLEINFO/H2G2ID"/>', 'ComplaintPopup', 'status=1,resizable=1,scrollbars=1,width=640,height=480')</xsl:when>
			<xsl:when test="/H2G2/CLUB/ARTICLE/ARTICLEINFO/H2G2ID &gt; 0">javascript:popupwindow('/dna/<xsl:value-of select="/H2G2/CURRENTSITEURLNAME"/>/comments/UserComplaintPage?s_start=1&amp;h2g2ID=<xsl:value-of select="/H2G2/CLUB/ARTICLE/ARTICLEINFO/H2G2ID"/>', 'ComplaintPopup', 'status=1,resizable=1,scrollbars=1,width=640,height=480')</xsl:when>
			<xsl:otherwise>javascript:popupwindow('/dna/<xsl:value-of select="/H2G2/CURRENTSITEURLNAME"/>/comments/UserComplaintPage?s_start=1&amp;URL=' + escape(window.location.href), 'ComplaintPopup', 'status=1,resizable=1,scrollbars=1,width=640,height=480')</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="m_complainttext">
Most of the content on this site is created by our <xsl:value-of select="$m_users"/>, who are members of the public. The views expressed are theirs and unless specifically stated are not those of the BBC. The BBC is not responsible for the content of any external sites referenced. In the event that you consider anything on this page to be in breach of the site's <a href="{$root}HouseRules">House Rules</a>, please <a href="{$url_complain}">click here</a> to alert our Moderation Team. For any other comments, please start <xsl:value-of select="$m_threada"/>
		<xsl:value-of select="$m_thread"/> below.

	</xsl:variable>
	<xsl:variable name="m_status">Status: </xsl:variable>
	<xsl:variable name="m_linkclipped">This article has been adding to your clippings</xsl:variable>
	<xsl:variable name="m_alreadyclipped">You have already added this article to your clippings</xsl:variable>
	<xsl:variable name="m_alreadyclippedhidden">You have already added this article to your clippings</xsl:variable>
	<xsl:variable name="m_tagarticle">Tag this article to the taxonomy</xsl:variable>
	<xsl:variable name="m_editarticletags">Edit the tagging of this article</xsl:variable>
	<xsl:variable name="m_deletedarticleslink">on this page</xsl:variable>
	<xsl:variable name="m_unregisteredtypedarticle">We're sorry, but you can't create or edit articles until you've signed in. If you already have an account, please <a href="{$sso_noarticlesigninlink}">click here to sign in</a>. If you haven't already registered with us as a member, please <a href="{$sso_noarticleregisterlink}">click here to register</a>.</xsl:variable>
	<xsl:variable name="m_articlesublink">Subscribe to Article</xsl:variable>
	<xsl:variable name="m_articlesubmanagelink">Manage Article Subscription</xsl:variable>
	<xsl:variable name="m_forumsublink">Subscribe to Forum</xsl:variable>
	<xsl:variable name="m_forumsubmanagelink">Manage Forum Subscription</xsl:variable>
	<!--============================ARTICLE PAGE============================-->
	<!--============================CATEGORYPAGE============================-->
	<xsl:variable name="m_catpagememberstitle">On this page: </xsl:variable>
	<xsl:variable name="m_subjectmemberstitle">See also: </xsl:variable>
	<xsl:variable name="m_clubmemberstitle">Campaigns</xsl:variable>
	<xsl:variable name="m_articlememberstitle">Articles</xsl:variable>
	<xsl:variable name="m_numberofclubstext">Campaigns</xsl:variable>
	<xsl:variable name="m_numberofarticlestext">Articles</xsl:variable>
	<!--============================CATEGORYPAGE============================-->
	<!--============================EDITCATEGORYPAGE============================-->
	<xsl:variable name="m_EditCatRenameSubjectButton">Change Subject</xsl:variable>
	<xsl:variable name="m_EditCatRenameDesc">Add/Change Description</xsl:variable>
	<xsl:variable name="m_EditCatAddSubjectButton">Add a new subject</xsl:variable>
	<xsl:variable name="m_storearticlehere">Store the article "<xsl:value-of select="/H2G2/EDITCATEGORY/ACTIVENODE"/>" here</xsl:variable>
	<xsl:variable name="m_storeclubhere">Store the club "<xsl:value-of select="/H2G2/EDITCATEGORY/ACTIVENODE"/>" here</xsl:variable>
	<xsl:variable name="m_movelinkhere">Move the link "<xsl:value-of select="/H2G2/EDITCATEGORY/ACTIVENODE"/>" here</xsl:variable>
	<xsl:variable name="m_storesubjecthere">Store the subject "<xsl:value-of select="/H2G2/EDITCATEGORY/ACTIVENODE"/>" here</xsl:variable>
	<xsl:variable name="m_storelinkhere">Store the link "<xsl:value-of select="/H2G2/EDITCATEGORY/ACTIVENODE"/>" here</xsl:variable>
	<xsl:variable name="m_catsubjectexists">That subject already exists</xsl:variable>
	<xsl:variable name="m_deletesubjectlink">Delete Subject Link</xsl:variable>
	<xsl:variable name="m_deletearticle">Delete Article</xsl:variable>
	<xsl:variable name="m_movearticle">Move Article</xsl:variable>
	<xsl:variable name="m_moveclub">Move Club</xsl:variable>
	<xsl:variable name="m_deleteclub">Delete Club</xsl:variable>
	<xsl:variable name="m_editcatdots">........</xsl:variable>
	<xsl:variable name="m_deletesubject">Delete Subject</xsl:variable>
	<xsl:variable name="m_movesubject">Move Subject</xsl:variable>
	<xsl:variable name="m_movesubjectlink">Move Subject Link</xsl:variable>
	<xsl:variable name="m_renamesubject">New Name: </xsl:variable>
	<xsl:variable name="m_enternewname">New Subject: </xsl:variable>
	<xsl:variable name="m_changedescription">Description: <br/>
	</xsl:variable>
	<xsl:variable name="m_addclubtosubject">Add a club to this subject<br/>Club ID: </xsl:variable>
	<xsl:variable name="m_addarticletosubject">Add an article to this subject<br/>Article ID: </xsl:variable>
	<xsl:variable name="m_userdenied">The user cannot add content to this node :</xsl:variable>
	<xsl:variable name="m_userenabled">The user can add content to this node :</xsl:variable>
	<xsl:variable name="m_synonymstitle">Synonyms: </xsl:variable>
	<!--============================EDITCATEGORYPAGE============================-->
	<!-- ========================== EDIT MEMBERSHIP PAGE ==========================-->
	<xsl:variable name="m_linktoclubarticle">Read our charter</xsl:variable>
	<xsl:variable name="m_messagemembers">Send a message to all members</xsl:variable>
	<xsl:variable name="m_joinmemberrequest"> has requested to be a member of </xsl:variable>
	<xsl:variable name="m_joinownerrequest"> has requested to be promoted to an owner of </xsl:variable>
	<xsl:variable name="m_joinclub">Join club</xsl:variable>
	<xsl:variable name="m_complainclubjournal">Make a complaint about this diary entry</xsl:variable>
	<xsl:variable name="m_editmembershiplink">Edit membership details</xsl:variable>
	<xsl:variable name="m_returntoclublink">Return to the club</xsl:variable>
	<xsl:variable name="m_accept">accept</xsl:variable>
	<xsl:variable name="m_reject">reject</xsl:variable>
	<xsl:variable name="m_pendingrequests">Pending requests</xsl:variable>
	<xsl:variable name="m_completedrequests">Recently completed requests</xsl:variable>
	<xsl:variable name="m_invitedowner">has been invited to be an owner</xsl:variable>
	<xsl:variable name="m_invitedmember">has been invited to be a member</xsl:variable>
	<xsl:variable name="m_joinmember3rdperson"> asked to join.</xsl:variable>
	<xsl:variable name="m_joinownerviewer3rdperson"> asked to be an owner.</xsl:variable>
	<xsl:variable name="m_invitemember3rdperson"> was invited to join </xsl:variable>
	<xsl:variable name="m_inviteowner3rdperson"> was invited to own </xsl:variable>
	<xsl:variable name="m_ownerresignsmember3rdperson"> resigned as an owner.</xsl:variable>
	<xsl:variable name="m_ownerresignscompletely3rdperson"> resigned ownership completely.</xsl:variable>
	<xsl:variable name="m_memberresigns3rdperson"> resigned membership.</xsl:variable>
	<xsl:variable name="m_demoteownertomember3rdperson"> was demoted to member.</xsl:variable>
	<xsl:variable name="m_removeowner3rdperson"> was remove as both owner and member.</xsl:variable>
	<xsl:variable name="m_removemember3rdperson"> was removed.</xsl:variable>
	<xsl:variable name="m_editmembers_owner">Owner</xsl:variable>
	<xsl:variable name="m_editmembers_member">Member</xsl:variable>
	<xsl:variable name="m_submitmemberedit">Do it</xsl:variable>
	<xsl:variable name="m_currenttype_owner">Owner</xsl:variable>
	<xsl:variable name="m_currenttype_member">Member</xsl:variable>
	<xsl:variable name="m_teamlisttitle">Team list</xsl:variable>
	<xsl:variable name="m_membername">Name</xsl:variable>
	<xsl:variable name="m_membertype">Type</xsl:variable>
	<xsl:variable name="m_memberrole">Role</xsl:variable>
	<xsl:variable name="m_membertypetitle">Current type</xsl:variable>
	<xsl:variable name="m_memberroletitle">Current role</xsl:variable>
	<xsl:variable name="m_editmemberdetails">edit</xsl:variable>
	<!-- ========================== EDIT MEMBERSHIP PAGE ==========================-->
	<!-- ========================== EMAILALERTS PAGE ==========================-->
	<xsl:variable name="m_emailalert">Email Alerts</xsl:variable>
	<!-- ========================== EMAILALERTS PAGE ==========================-->
	<!-- ========================== EMAILALERTGROUPS PAGE ==========================-->
	<xsl:variable name="m_emailalertgroups">Email Alerts</xsl:variable>
	<!-- ========================== EMAILALERTGROUPS PAGE ==========================-->
	<!-- ========================== MISC PAGE ==========================-->
	<xsl:variable name="m_leavingsitetitle">You are now leaving us for pastures new</xsl:variable>
	<xsl:variable name="m_sitechangemessage">
		<p>
The link you clicked on will take you out of this site. Think very carefully about this. 
Are you sure you want to leave our fluffy environs? It's a big bad world out there in the
rest of DNA, and it might not be safe for everybody. Your choice.
	</p>
		<p>
			<a xsl:use-attribute-sets="nm_sitechangemessage" href="/dna/{/H2G2/SITECHANGE/SITENAME}/{/H2G2/SITECHANGE/URL}">Click here to continue on...</a>
		</p>
	</xsl:variable>
	<xsl:variable name="m_regwaittransfer">Please wait while you are transferred to your Personal Space. 
<a xsl:use-attribute-sets="nm_regwaittransfer" href="{$root}U{/H2G2/NEWREGISTER/USERID}">Click here</a> if nothing happens after a few seconds.
	</xsl:variable>
	<!-- ========================== MISC PAGE ==========================-->
	<!-- ========================== REGISTER PAGE ==========================-->
	<xsl:variable name="m_slicksubmitvote">Click here to submit your vote</xsl:variable>
	<xsl:variable name="m_clicktowritearticle">Click here to write your article</xsl:variable>
	<xsl:variable name="m_ptclicktoleaveprivatemessage">Click here to leave your private message</xsl:variable>
	<xsl:variable name="m_ptclicktoleaveguestbookmessage">Click here to leave your comment</xsl:variable>
	<xsl:variable name="m_detailsedited">Your details have been edited</xsl:variable>
	<!-- ========================== REGISTER PAGE ==========================-->
	<!-- ========================== VOTE PAGE ==========================-->
	<xsl:variable name="m_returntoclubpage">Return to club</xsl:variable>
	<xsl:variable name="m_returntorfpage">Return to review forum</xsl:variable>
	<xsl:variable name="m_returntouserpage">Return to userpage</xsl:variable>
	<xsl:variable name="m_returntoarticlepage">Return to article page</xsl:variable>
	<xsl:variable name="m_returntocategorypage">Return to category page</xsl:variable>
	<xsl:variable name="m_votecompletetitle">Vote completed</xsl:variable>
	<xsl:variable name="m_submitvotetitle">Add your vote</xsl:variable>
	<xsl:variable name="m_addvote">Add vote</xsl:variable>
	<xsl:variable name="m_votesubmitted">Your vote has been submitted</xsl:variable>
	<!-- ========================== VOTE PAGE ==========================-->
	<xsl:variable name="m_ptcreateclub">Create your club</xsl:variable>
	<xsl:variable name="m_ptsupportclub">Return to support campaign</xsl:variable>
	<xsl:variable name="m_ptopposeclub">Return to oppose campaign</xsl:variable>
	<xsl:variable name="m_unregistereduserediterror">
		<p>We're sorry, but you can't create or edit <xsl:value-of select="$m_articles"/> until you've logged in.</p>
		<p>If you already have an account, please <a href="{$sso_resources}{$sso_script}?c=login&amp;service={$sso_serviceid_link}&amp;ptrt={$sso_redirectserver}{$root}SSO%3Fpa=editpage">click here to log in</a>.</p>
		<p>If you haven't already registered with us as a 
<xsl:value-of select="$m_user"/>, please <a href="{$sso_resources}{$sso_script}?c=register&amp;service={$sso_serviceid_link}&amp;ptrt={$sso_redirectserver}{$root}SSO%3Fpa=editpage">click here to register</a>. Registering is free and will enable you to share your wisdom with the rest of the Community.</p>
	</xsl:variable>
	<!--xsl:template name="m_cantpostnotregistered">
		<p>We're sorry, but you can't post to a conversation until you've registered with us as a user.</p>
		<UL>
			<LI>
				<P>If you already have an account, please <a xsl:use-attribute-sets="nm_cantpostnotregistered1" href="{$sso_resources}{$sso_script}?c=login&amp;service={$sso_serviceid_link}&amp;ptrt={$sso_redirectserver}{$root}SSO%3Fpa=editpage">click here to log in</A>.</P>
			</LI>
			<LI>
				<P>If you haven't already registered with us as <xsl:value-of select="$m_usera"/> <xsl:value-of select="$m_user"/>, please <A xsl:use-attribute-sets="nm_cantpostnotregistered2" href="{$root}Register?pa=postforum&amp;pt=forum&amp;forum={@FORUMID}&amp;pt=thread&amp;thread={@THREADID}&amp;pt=post&amp;post={@POSTID}">click here to register</A>. Registering is free and will enable you to share your wisdom with the rest of the Community. <a xsl:use-attribute-sets="nm_cantpostnotregistered3" href="A387317">Tell me more!</a>.</P>
			</LI>
		</UL>
		<P>Alternatively, <A xsl:use-attribute-sets="nm_cantpostnotregistered4">
				<xsl:attribute name="href"><xsl:value-of select="$root"/>F<xsl:value-of select="@FORUMID"/>?thread=<xsl:value-of select="@THREADID"/>&amp;post=<xsl:value-of select="@POSTID"/>#p<xsl:value-of select="@POSTID"/></xsl:attribute>click here to return to the <xsl:value-of select="$m_thread"/> without logging in</A>.</P>
	</xsl:template-->
	<!-- ========================== NOTICEBOARD PAGE ==========================-->
	<xsl:variable name="m_returntonoticeboardpage">Return to the noticeboard</xsl:variable>
	<xsl:variable name="m_votenoticeboard">click here to register your support</xsl:variable>
	<xsl:variable name="m_emptynotices">There are no notices on this notice board</xsl:variable>
	<xsl:variable name="m_emptyevents">There are no events to display</xsl:variable>
	<xsl:variable name="m_complainnotice">Click here to register a complaint about this notice</xsl:variable>
	<xsl:variable name="m_complainwanted">Click here to register a complaint about this notice</xsl:variable>
	<xsl:variable name="m_complainalert">Click here to register a complaint about this alert</xsl:variable>
	<xsl:variable name="m_complainevent">Click here to register a complaint about this event</xsl:variable>
	<xsl:variable name="m_complainoffer">Click here to register a complaint about this notice</xsl:variable>
	<xsl:variable name="m_createnoticetitle">Create a notice</xsl:variable>
	<xsl:variable name="m_createeventtitle">Create an event</xsl:variable>
	<xsl:variable name="m_createalerttitle">Create an alert</xsl:variable>
	<xsl:variable name="m_createwantedtitle">Create a wanted message</xsl:variable>
	<xsl:variable name="m_createoffertitle">Create an offer message</xsl:variable>
	<!-- ========================== NOTICEBOARD PAGE ==========================-->
	<!-- ========================== MULTIPOSTS PAGE ==========================-->
	<xsl:variable name="m_failmessage">Fail message</xsl:variable>
	<!-- ========================== MULTIPOSTS PAGE ==========================-->
	<xsl:variable name="m_firstjournalpage">first page</xsl:variable>
	<xsl:variable name="m_lastjournalpage">last page</xsl:variable>
	<xsl:template name="noClubJournalReplies">
		(<xsl:value-of select="$m_noreplies"/>)
	</xsl:template>
	<!-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ -->
	<!-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ -->
	<!--                                                                   END OF base-extratext.xsl                                                     -->
	<!-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ -->
	<!-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ -->
	<!-- Following attribute sets are temporarily in base text, were in attributesets.xsl but caused problems when uploading -->
	<xsl:attribute-set name="mHELP_WritingGE" use-attribute-sets="linkatt">
		<xsl:attribute name="target">_blank</xsl:attribute>
		<xsl:attribute name="alt"><xsl:value-of select="$alt_clickherehelpentry"/></xsl:attribute>
		<xsl:attribute name="title"><xsl:value-of select="$alt_clickherehelpentry"/></xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="iArticleSubject">
		<xsl:attribute name="TYPE">text</xsl:attribute>
		<xsl:attribute name="TITLE"><xsl:value-of select="$m_GESubject"/></xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="iDeleteArticle">
		<xsl:attribute name="TYPE">submit</xsl:attribute>
		<xsl:attribute name="VALUE"><xsl:value-of select="$m_delete"/></xsl:attribute>
		<xsl:attribute name="ALT"><xsl:value-of select="$alt_DeleteGE"/></xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="iMoveToSite">
		<xsl:attribute name="TYPE">submit</xsl:attribute>
		<xsl:attribute name="VALUE"><xsl:value-of select="$m_Move"/></xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="iAddEntry">
		<xsl:attribute name="TYPE">submit</xsl:attribute>
		<xsl:attribute name="TITLE"><xsl:value-of select="$alt_storethis"/></xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="iUpdateEntry">
		<xsl:attribute name="TYPE">submit</xsl:attribute>
		<xsl:attribute name="TITLE"><xsl:value-of select="$m_storechanges"/></xsl:attribute>
	</xsl:attribute-set>
	<!-- begin of tests -->
	<xsl:variable name="test_MayRemoveFromResearchers" select="$ownerisviewer = 0 and /H2G2/ARTICLE/ARTICLEINFO/PAGEAUTHOR/RESEARCHERS/USER/USERID = /H2G2/VIEWING-USER/USER/USERID and /H2G2/ARTICLE/ARTICLEINFO/STATUS/@TYPE = 3"/>
	<xsl:variable name="test_ShowEditLink" select="/H2G2/PAGEUI/EDITPAGE/@VISIBLE = 1"/>
	<xsl:variable name="test_ShowEntrySubbedLink" select="/H2G2/PAGEUI/ENTRY-SUBBED/@VISIBLE = 1"/>
	<xsl:variable name="test_HasResearchers" select="/H2G2/ARTICLE/ARTICLEINFO/PAGEAUTHOR/RESEARCHERS/USER"/>
	<xsl:variable name="test_IsEditor" select="/H2G2/VIEWING-USER/USER/GROUPS/EDITOR or /H2G2/VIEWING-USER/USER/GROUPS/GROUP[NAME='EDITOR'] or ($superuser = 1)"/>
	<xsl:variable name="test_IsModerator" select="/H2G2/VIEWING-USER/USER/GROUPS/MODERATOR or /H2G2/VIEWING-USER/USER/GROUPS/GROUP[NAME='MODERATOR']"/>
	<xsl:variable name="test_IsAssetModerator" select="/H2G2/VIEWING-USER/USER/GROUPS/ASSETMODERATOR or /H2G2/VIEWING-USER/USER/GROUPS/GROUP[NAME='ASSETMODERATOR']"/>
	
	<xsl:variable name="test_CanEditMasthead" select="$ownerisviewer=1 or ($test_IsEditor and /H2G2/ARTICLE/ARTICLEINFO/H2G2ID)"/>
	<xsl:variable name="test_RefHasEntries" select="boolean((/H2G2/ARTICLE/GUIDE//LINK[@H2G2=/H2G2/ARTICLE/ARTICLEINFO/REFERENCES/ENTRIES/ENTRYLINK/@H2G2]) or (/H2G2/ARTICLE/GUIDE//LINK[@DNAID=/H2G2/ARTICLE/ARTICLEINFO/REFERENCES/ENTRIES/ENTRYLINK/@H2G2]))"/>
	<xsl:variable name="test_RefHasUsers" select="boolean((/H2G2/ARTICLE/GUIDE//LINK[@H2G2=/H2G2/ARTICLE/ARTICLEINFO/REFERENCES/USERS/USERLINK/@H2G2]) or (/H2G2/ARTICLE/GUIDE//LINK[@BIO=/H2G2/ARTICLE/ARTICLEINFO/REFERENCES/USERS/USERLINK/@H2G2]))"/>
	<xsl:variable name="test_RefHasBBCSites" select="(/H2G2/ARTICLE/GUIDE//LINK[@UINDEX=/H2G2/ARTICLE/ARTICLEINFO/REFERENCES/EXTERNAL/EXTERNALLINK[starts-with(OFFSITE, 'http://www.bbc.co.uk') or starts-with(OFFSITE, 'http://news.bbc.co.uk')]/@UINDEX])"/>
	<xsl:variable name="test_RefHasNONBBCSites" select="(/H2G2/ARTICLE/GUIDE//LINK[@UINDEX=/H2G2/ARTICLE/ARTICLEINFO/REFERENCES/EXTERNAL/EXTERNALLINK[not(starts-with(OFFSITE, 'http://www.bbc.co.uk') or starts-with(OFFSITE, 'http://news.bbc.co.uk'))]/@UINDEX])"/>
	<xsl:variable name="test_EditorOrModerator" select="/H2G2/VIEWING-USER/USER/GROUPS[EDITOR or MODERATOR] or ($superuser = 1)"/>
	<xsl:variable name="test_IsArticleMasthead" select="/H2G2/ARTICLE-EDIT-FORM/MASTHEAD = 1"/>
	<xsl:variable name="test_ShowResearchers" select="not($test_IsArticleMasthead) and H2G2/ARTICLE-EDIT-FORM/FUNCTIONS/ADD-RESEARCHERS"/>
	<xsl:variable name="test_PreviewError" select="boolean(/H2G2/POSTTHREADFORM/PREVIEWERROR)"/>
	<xsl:variable name="test_HasPreviewBody" select="boolean(/H2G2/POSTTHREADFORM/PREVIEWBODY)"/>
	<xsl:variable name="test_AllowNewConversationBtn" select="not(/H2G2/FORUMTHREADS/@JOURNALOWNER) or (number(/H2G2/FORUMTHREADS/@JOURNALOWNER) = number(/H2G2/VIEWING-USER/USER/USERID))"/>
	<xsl:variable name="test_MayAddToJournal" select="boolean($ownerisviewer = 1)"/>
	<xsl:variable name="test_MayRemoveJournalPost" select="boolean($ownerisviewer = 1)"/>
	<xsl:variable name="test_MayShowCancelledEntries" select="number(/H2G2/ARTICLES/@USERID)=number(/H2G2/VIEWING-USER/USER/USERID)"/>
	<xsl:variable name="test_NewerArticlesExist" select="boolean(/H2G2/ARTICLES/ARTICLE-LIST[@SKIPTO &gt; 0])"/>
	<xsl:variable name="test_OlderArticlesExist" select="boolean(/H2G2/ARTICLES/ARTICLE-LIST[@MORE=1])"/>
	<!-- to find out the type of ARTICLE-EDIT-FORM, ie is it an introduction: -->
	<xsl:variable name="test_AddHomePage" select="number(/H2G2/ARTICLE-EDIT-FORM/H2G2ID) = 0 and /H2G2/ARTICLE-EDIT-FORM/MASTHEAD != 0"/>
	<xsl:variable name="test_AddGuideEntry" select="number(/H2G2/ARTICLE-EDIT-FORM/H2G2ID) = 0 and /H2G2/ARTICLE-EDIT-FORM/MASTHEAD = 0"/>
	<xsl:variable name="test_EditHomePage" select="number(/H2G2/ARTICLE-EDIT-FORM/H2G2ID) != 0 and /H2G2/ARTICLE-EDIT-FORM/MASTHEAD != 0"/>
	<xsl:variable name="test_EditguideEntry" select="number(/H2G2/ARTICLE-EDIT-FORM/H2G2ID) != 0 and /H2G2/ARTICLE-EDIT-FORM/MASTHEAD = 0"/>
	<xsl:variable name="test_introarticle" select="/H2G2/ARTICLE/GUIDE[string-length(BODY) &gt; 0]"/>
	<!--xsl:variable name="test_articlenotuserpage" select="/H2G2/RECENT-ENTRIES/ARTICLE-LIST/ARTICLE[not(EXTRAINFO/TYPE/@ID=3001) and not(EXTRAINFO/TYPE/@ID=1001)]"/-->
	<xsl:variable name="test_articletypeonly" select="/H2G2/RECENT-ENTRIES/ARTICLE-LIST/ARTICLE[not(EXTRAINFO/TYPE/@ID=3001)][not(EXTRAINFO/TYPE/@ID=1001)]"/>
	<xsl:variable name="test_registererror" select="/H2G2/ERROR/@TYPE='NOUSER' or /H2G2/ERROR/@TYPE='NOTSIGNEDIN'"/>
	<xsl:template name="staf_link">
		<a xsl:use-attribute-sets="staf_link" onclick="popmailwin('/cgi-bin/navigation/mailto.pl?GO=1&amp;REF={$root}{$referrer}','Mailer')" href="/cgi-bin/navigation/mailto.pl?GO=1&amp;REF=http://www.bbc.co.uk{$root}{$referrer}" target="Mailer">Send it to a friend!</a>
	</xsl:template>
	<xsl:variable name="articlefields"/>
	<xsl:variable name="referrer">
		<!-- Double escape all '?', '&', and '=' characters. -->
		<xsl:choose>
			<xsl:when test="/H2G2/@TYPE='ADDJOURNAL'">postjournal</xsl:when>
			<xsl:when test="/H2G2/@TYPE='ADDTHREAD'">
				<xsl:choose>
					<xsl:when test="/H2G2/POSTTHREADFORM/INREPLYTO">
						<xsl:choose>
							<xsl:when test="/H2G2/SITE/IDENTITYSIGNIN = 0">
								<xsl:value-of select="concat('AddThread%253Finreplyto=', /H2G2/POSTTHREADFORM/@INREPLYTO)"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="concat('AddThread%3Finreplyto=', /H2G2/POSTTHREADFORM/@INREPLYTO)"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:when test="/H2G2/POSTTHREADFORM/RETURNTO/H2G2ID">
						<xsl:value-of select="concat('AddThread%253Fforum=', /H2G2/POSTTHREADFORM/@FORUMID, '%2526article=', /H2G2/POSTTHREADFORM/RETURNTO/H2G2ID)"/>
					</xsl:when>
					<xsl:when test="/H2G2/FORUMSOURCE/@TYPE = 'article'">
						<xsl:choose>
							<xsl:when test="/H2G2/SITE/IDENTITYSIGNIN = 1">
								<xsl:value-of select="concat('AddThread%3Fforum=', /H2G2/FORUMSOURCE/ARTICLE/ARTICLEINFO/FORUMID)"/>
							</xsl:when>
						</xsl:choose>
					</xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="/H2G2/@TYPE='ARTCHECK'">
				
			</xsl:when>
			<xsl:when test="/H2G2/@TYPE='ARTICLE'">
				<xsl:value-of select="concat('A', /H2G2/ARTICLE/ARTICLEINFO/H2G2ID)"/>
			</xsl:when>
			<xsl:when test="/H2G2/@TYPE='ARTICLESEARCH'">
			</xsl:when>
			<xsl:when test="/H2G2/@TYPE='CATEGORY'">
				<xsl:value-of select="concat('C', /H2G2/HIERARCHYDETAILS/@NODEID)"/>
			</xsl:when>
			<xsl:when test="/H2G2/@TYPE='CLUB'">
				<xsl:value-of select="concat('G', /H2G2/CLUB/CLUBINFO/@ID)"/>
			</xsl:when>
			<xsl:when test="/H2G2/@TYPE='CLUBLIST'">clublist</xsl:when>
			<xsl:when test="/H2G2/@TYPE='COMING-UP'">comingup</xsl:when>
			<xsl:when test="/H2G2/@TYPE='DIAGNOSE'">
				
			</xsl:when>
			<xsl:when test="/H2G2/@TYPE='EDITCATEGORY'">
				<!--xsl:value-of select="concat('?action=', $object, '&amp;activenode=', $active, '&amp;nodeid=', $node, '&amp;tagmode=' $mode)"/-->
			</xsl:when>
			<xsl:when test="/H2G2/@TYPE='EDITREVIEW'">editreview</xsl:when>
			<xsl:when test="/H2G2/@TYPE='EMAILALERTGROUPS'">AlertGroups</xsl:when>
			<xsl:when test="/H2G2/@TYPE='ERROR'">
				<xsl:if test="/H2G2/SITE/@ID = '66'">
					<xsl:text>moderate%3Fnewstyle=1</xsl:text>
				</xsl:if>
			</xsl:when>
			<xsl:when test="/H2G2/@TYPE='FRONTPAGE'">
				<xsl:if test="/H2G2/CURRENTSITEURLNAME = 'moderation'">moderate%253Fnewstyle=1</xsl:if>
			</xsl:when>
			<xsl:when test="/H2G2/@TYPE='FRONTPAGE-EDITOR'"/>
			<xsl:when test="/H2G2/@TYPE='GROUP-MANAGEMENT'"/>
			<xsl:when test="/H2G2/@TYPE='INDEX'">
				<xsl:variable name="indexstatus">
					<xsl:if test="/H2G2/INDEX[@APPROVED='on']">%2526official=on</xsl:if>
					<xsl:if test="/H2G2/INDEX[@UNAPPROVED='on']">%2526submitted=on</xsl:if>
					<xsl:if test="/H2G2/INDEX[@SUBMITTED='on']">%2526user=on</xsl:if>
				</xsl:variable>
				<xsl:value-of select="concat('index%253Flet=', /H2G2/INDEX/@LETTER, $indexstatus, '%2526show=', /H2G2/INDEX/@COUNT, '%2526skip=', /H2G2/INDEX/@SKIP)"/>
			</xsl:when>
			<xsl:when test="/H2G2/@TYPE='INFO'">
				<xsl:choose>
					<xsl:when test="/H2G2/SITE/IDENTITYSIGNIN = 0">
						<xsl:choose>
							<xsl:when test="/H2G2/INFO/@MODE='conversations'">info?cmd=conv</xsl:when>
							<xsl:when test="/H2G2/INFO/@MODE='articles'">info?cmd=art</xsl:when>
							<xsl:otherwise>info</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="/H2G2/@TYPE='INSPECT-USER'"/>
			<xsl:when test="/H2G2/@TYPE='JOURNAL'">
				<xsl:value-of select="concat('MJ', /H2G2/JOURNAL/@USERID, '%253FJournal=', /H2G2/JOURNAL/JOURNALPOSTS/@FORUMID, '%2526show=', /H2G2/JOURNAL/JOURNALPOSTS/@COUNT, '%2526skip=', /H2G2/JOURNAL/JOURNALPOSTS/@SKIPTO)"/>
			</xsl:when>
			<xsl:when test="/H2G2/@TYPE='KEYARTICLE-EDITOR'"/>
			<xsl:when test="/H2G2/@TYPE='LOGOUT'">logout</xsl:when>
			<xsl:when test="/H2G2/@TYPE='MANAGELINKS'">managelinks</xsl:when>
			<xsl:when test="/H2G2/@TYPE='MONTH'">month</xsl:when>
			<xsl:when test="/H2G2/@TYPE='MOREPAGES'">
				<xsl:choose>
					<xsl:when test="h2G2/SITE/IDENTITYSIGNIN = 0">
						<xsl:value-of select="concat('MA', /H2G2/ARTICLES/@USERID, '%253Ftype=', /H2G2/ARTICLES/@USERID, '%2526show=', /H2G2/ARTICLES/ARTICLE-LIST/@COUNT, '%2526skip=', /H2G2/ARTICLES/ARTICLE-LIST/@SKIPTO)"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:choose>
							<xsl:when test="/H2G2/SITE/@ID = 71">
								<xsl:value-of select="concat('MA', /H2G2/ARTICLES/@USERID)"/>
							</xsl:when>
						</xsl:choose>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="/H2G2/@TYPE='MOREPOSTS'">
				<xsl:choose>
					<xsl:when test="/H2G2/PARAMS/PARAM[NAME='s_type']/VALUE='pop'"/>
					<xsl:otherwise>
						<xsl:choose>
							<xsl:when test="/H2G2/SITE/IDENTITYSIGNIN = 0">
								<xsl:value-of select="concat('MP', /H2G2/POSTS/@USERID, '%253Fshow=', /H2G2/POSTS/POST-LIST/@COUNT, '%2526skip=', /H2G2/POSTS/POST-LIST/@SKIPTO)"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="concat('MP', /H2G2/POSTS/@USERID, '%3Fshow=', /H2G2/POSTS/POST-LIST/@COUNT, '%26skip=', /H2G2/POSTS/POST-LIST/@SKIPTO)"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="/H2G2/@TYPE='MULTIPOSTS'">
				<xsl:choose>
					<xsl:when test="/H2G2/SITE/IDENTITYSIGNIN = 0">
						<xsl:choose>
							<xsl:when test="/H2G2/PARAMS/PARAM[NAME='s_xml']">
								<xsl:value-of select="concat('F', /H2G2/FORUMTHREADPOSTS/@FORUMID, '%253Fthread=', /H2G2/FORUMTHREADPOSTS/@THREADID, '%2526latest=1')"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="concat('F', /H2G2/FORUMTHREADPOSTS/@FORUMID, '%3Fthread=', /H2G2/FORUMTHREADPOSTS/@THREADID, '%2526skip=', /H2G2/FORUMTHREADPOSTS/@SKIPTO, '%2526show=', /H2G2/FORUMTHREADPOSTS/@COUNT)"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="concat('F', /H2G2/FORUMTHREADPOSTS/@FORUMID, '%3Fthread=', /H2G2/FORUMTHREADPOSTS/@THREADID)"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="/H2G2/@TYPE='NEWEMAIL'">newemail</xsl:when>
			<xsl:when test="/H2G2/@TYPE='NEWREGISTER'">register</xsl:when>
			<xsl:when test="/H2G2/@TYPE='NEWUSERS'">newusers</xsl:when>
			<xsl:when test="/H2G2/@TYPE='NOTICEBOARD'">noticeboard</xsl:when>
			<xsl:when test="/H2G2/@TYPE='NOTICEBOARDLIST'"/>
			<xsl:when test="/H2G2/@TYPE='NOTFOUND'"/>
			<xsl:when test="/H2G2/@TYPE='ONLINE'">
				<!-- <xsl:if test="/H2G2/SITE/IDENTITYSIGNIN = 1">
					<xsl:value-of select="concat('online%3Fthissite=', /H2G2/ONLINEUSERS/@THISSITE, '%26orderby=', /H2G2/ONLINEUSERS/@ORDER-BY)"/>
				</xsl:if> -->
			</xsl:when>
			<xsl:when test="/H2G2/@TYPE='POSTCODE'">
				<xsl:value-of select="concat('postcode%253Fpostcode=', /H2G2/CIVICDATA/@POSTCODE)"/>
			</xsl:when>
			<xsl:when test="/H2G2/@TYPE='RECOMMEND-ENTRY'"/>
			<xsl:when test="/H2G2/@TYPE='REGISTER'">register</xsl:when>
			<xsl:when test="/H2G2/@TYPE='REGISTER-CONFIRMATION'"/>
			<xsl:when test="/H2G2/@TYPE='RESERVED-ARTICLES'"/>
			<xsl:when test="/H2G2/@TYPE='REVIEWFORUM'">
				<xsl:value-of select="concat('RF', /H2G2/REVIEWFORUM/@ID)"/>
			</xsl:when>
			<xsl:when test="/H2G2/@TYPE='SCOUT-RECOMMENDATIONS'"/>
			<xsl:when test="/H2G2/@TYPE='SEARCH'">
				<xsl:variable name="searchparams">
					<xsl:if test="/H2G2/SEARCH/SEARCHRESULTS">
						<xsl:value-of select="concat('%253Fsearchstring=', /H2G2/SEARCH/SEARCHRESULTS/SEARCHTERM)"/>
						<xsl:if test="/H2G2/SEARCH/FUNCTIONALITY/SEARCHARTICLES[SHOWAPPROVED=1]">%2526showapproved=1</xsl:if>
						<xsl:if test="/H2G2/SEARCH/FUNCTIONALITY/SEARCHARTICLES[SHOWNORMAL=1]">%2526shownormal=1</xsl:if>
						<xsl:if test="/H2G2/SEARCH/FUNCTIONALITY/SEARCHARTICLES[SHOWSUBMITTED=1]">%2526showsubmitted=1</xsl:if>
						<xsl:if test="/H2G2/SEARCH/SEARCHRESULTS/@TYPE">
							<xsl:value-of select="concat('%2526searchtype=', /H2G2/SEARCH/SEARCHRESULTS/@TYPE)"/>
						</xsl:if>
					</xsl:if>
				</xsl:variable>
				<xsl:value-of select="concat('Search', $searchparams)"/>
			</xsl:when>
			<xsl:when test="/H2G2/@TYPE='SHAREANDENJOY'"/>
			<xsl:when test="/H2G2/@TYPE='SIMPLEPAGE'"/>
			<xsl:when test="/H2G2/@TYPE='SITEADMIN-EDITOR'"/>
			<xsl:when test="/H2G2/@TYPE='SITECHANGE'"/>
			<xsl:when test="/H2G2/@TYPE='SITECONFIG-EDITOR'"/>
			<xsl:when test="/H2G2/@TYPE='SUB-ALLOCATION'"/>
			<xsl:when test="/H2G2/@TYPE='SUBBED-ARTICLE-STATUS'"/>
			<xsl:when test="/H2G2/@TYPE='SUBSCRIBE'"/>
			<xsl:when test="/H2G2/@TYPE='SUBMITREVIEWFORUM'">
				<xsl:value-of select="concat('SubmitReviewForum%253Faction=submitrequest%2526h2g2id=', /H2G2/SUBMIT-REVIEW-FORUM/ARTICLE/@H2G2ID)"/>
			</xsl:when>
			<xsl:when test="/H2G2/@TYPE='TAGITEM'">
				<xsl:value-of select="concat('Tagitem%253Ftagitemtype=', /H2G2/TAGITEM-PAGE/ITEM/@TYPE, '%2526tagitemid=', /H2G2/TAGITEM-PAGE/ITEM/@ID)"/>
			</xsl:when>
			<xsl:when test="/H2G2/@TYPE='TEAMLIST'">
				<xsl:value-of select="concat('Teamlist%253Fid=', /H2G2/TEAMLIST/TEAM/@ID, '%2526skip=', /H2G2/TEAMLIST/TEAM/@SKIPTO, '%2526show=', /H2G2/TEAMLIST/TEAM/@COUNT)"/>
			</xsl:when>
			<xsl:when test="/H2G2/@TYPE='THREADS'">
				<xsl:value-of select="concat('F', /H2G2/FORUMSOURCE/ARTICLE/ARTICLEINFO/FORUMID)"/>
			</xsl:when>
			<xsl:when test="/H2G2/@TYPE='THREADSEARCHPHRASE'">TSP</xsl:when>
			<xsl:when test="/H2G2/@TYPE='TOPFIVE-EDITOR'"/>
			<xsl:when test="/H2G2/@TYPE='TYPED-ARTICLE'">
				<xsl:choose>
					<xsl:when test="/H2G2/MULTI-STAGE[@TYPE='TYPED-ARTICLE-CREATE' or @TYPE='TYPED-ARTICLE-PREVIEW']">
						<xsl:value-of select="concat('TypedArticle%253Facreate=new%2526_msxsl=', $articlefields, '%2526type=', /H2G2/MULTI-STAGE/MULTI-REQUIRED[@NAME='TYPE']/VALUE)"/>
					</xsl:when>
					<xsl:when test="/H2G2/MULTI-STAGE[@TYPE='TYPED-ARTICLE-EDIT' or @TYPE='TYPED-ARTICLE-EDIT-PREVIEW']">
						<xsl:choose>
							<xsl:when test="/H2G2/SITE/IDENTITYSIGNIN = 0">
								<xsl:value-of select="concat('TypedArticle%253Faedit=new%2526h2g2id=', /H2G2/ARTICLE/ARTICLEINFO/H2G2ID)"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="concat('TypedArticle%3Faedit=new%26h2g2id=', /H2G2/ARTICLE/ARTICLEINFO/H2G2ID)" />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
				</xsl:choose>
				<!-- Defensive coding, if 606 and typed article page with user signed out  -->
				<xsl:if test="/H2G2/SITE/@ID = '67' and not(/H2G2/VIEWING-USER/USER/USERNAME)">
					<xsl:text>TypedArticle%3Facreate=new</xsl:text> 
				</xsl:if>
			</xsl:when>
			<xsl:when test="/H2G2/@TYPE='USER-COMPLAINT'"/>
			<xsl:when test="/H2G2/@TYPE='USERDETAILS'">userdetails</xsl:when>
			<xsl:when test="/H2G2/@TYPE='USEREDIT'">
				<xsl:choose>
					<xsl:when test="/H2G2/ARTICLE-EDIT-FORM[H2G2ID &gt; 0]">
						<xsl:value-of select="concat('Useredit', /H2G2/ARTICLE-EDIT-FORM/H2G2ID)"/>
					</xsl:when>
					<xsl:otherwise>Useredit</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="/H2G2/@TYPE='USERMYCLUBS'">umc</xsl:when>
			<xsl:when test="/H2G2/@TYPE='USERPAGE'">
				<xsl:value-of select="concat('U', /H2G2/PAGE-OWNER/USER/USERID)"/>
			</xsl:when>
			<xsl:when test="/H2G2/@TYPE='USERSTATISTICS'">
				<xsl:value-of select="concat('US', /H2G2/USERSTATISTICS/@USERID)"/>
			</xsl:when>
			<xsl:when test="/H2G2/@TYPE='VOTE'">
				<xsl:value-of select="concat('vote?action=', /H2G2/VOTING-PAGE/ACTION, '&amp;voteid=', /H2G2/VOTING-PAGE/VOTEID, '&amp;response=', /H2G2/VOTING-PAGE/RESPONSE, '&amp;type=', /H2G2/VOTING-PAGE/VOTETYPE)"/>
			</xsl:when>
			<xsl:when test="/H2G2/@TYPE='WATCHED-USERS'">
				<xsl:value-of select="concat('Watch', /H2G2/WATCHED-USER-LIST/@USERID)"/>
			</xsl:when>
			<xsl:otherwise/>
		</xsl:choose>
	</xsl:variable>
	<!-- end of tests -->
	<!-- Temporary: -->
	<xsl:template name="m_usereditwarning"/>
	<xsl:template name="m_usereditpagehouserulesdisclaimer"/>
	<xsl:template name="m_postpremodblurb"/>
	<xsl:template name="m_postyouarepremoderated"/>
	<!-- The following  are here for uploading purposes -->
	<xsl:template name="m_journalintro"/>
	<xsl:template name="m_changepasswordexternal"/>
	
</xsl:stylesheet>
