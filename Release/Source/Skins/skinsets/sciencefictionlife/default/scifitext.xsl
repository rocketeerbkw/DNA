<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
	<!ENTITY space "<xsl:text xmlns:xsl='http://www.w3.org/1999/XSL/Transform'> </xsl:text>">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">
<xsl:variable name="m_frontpagetitle">
<xsl:value-of select="$m_pagetitlestart"/> 
	<xsl:choose>
	<xsl:when test="/H2G2[@TYPE='FRONTPAGE']/ARTICLE/FRONTPAGE/PAGETITLE"><xsl:value-of select="/H2G2[@TYPE='FRONTPAGE']/ARTICLE/FRONTPAGE/PAGETITLE" /></xsl:when>
	<xsl:otherwise>Homepage</xsl:otherwise>
	</xsl:choose>
</xsl:variable>

<xsl:template name="m_passthroughwelcomeback">
<!-- If you've just created your membership you might want to visit your <a href="{$root}U{/H2G2/VIEWING-USER/USER/USERID}">member space</a> before doing anything else, it's the centre of your existence on Collective. changed TW -->
You're now signed in to My Science Fiction Life. To continue and add your recollection, please <a href="http://www.bbc.co.uk/mysciencefictionlife/"><strong>return to the homepage</strong></a>.
</xsl:template>

<xsl:template name="m_passthroughnewuser">
<!-- If you've just created your membership you might want to visit your <a href="{$root}U{/H2G2/VIEWING-USER/USER/USERID}">member space</a> before doing anything else, it's the centre of your existence on Collective. TW -->
You're now signed in to My Science Fiction Life. To continue and add your recollection, please <a href="http://www.bbc.co.uk/mysciencefictionlife/"><strong>return to the homepage</strong></a>.
</xsl:template>



<xsl:variable name="m_clicktowritearticle">write your review.</xsl:variable>
<xsl:variable name="m_ptclicktostartnewconv">write your reply.</xsl:variable>
<xsl:variable name="m_ptclicktoleaveprivatemessage">leave a message</xsl:variable>

<xsl:variable name="m_newerjournalentries">previous</xsl:variable>
<xsl:variable name="m_olderjournalentries">next</xsl:variable>

<xsl:variable name="m_discusslinkjournalpage">view and add comments</xsl:variable>
<xsl:variable name="m_thismessagecentre_tp">all my messages</xsl:variable>
<xsl:variable name="m_thisconvforentry_tp">This conversation is related to</xsl:variable>
<xsl:variable name="m_noentryyet">The page you requested does not exist. Perhaps you mistyped it, or the link you followed was broken.</xsl:variable>

<xsl:variable name="m_firstpagethreads">back to newest</xsl:variable>
<xsl:variable name="m_nofirstpagethreads">back to newest</xsl:variable>
<xsl:variable name="m_lastpagethreads">oldest</xsl:variable>
<xsl:variable name="m_nolastpagethreads">oldest</xsl:variable>
<xsl:variable name="m_previouspagethreads"><img  src="{$imageRoot}images/previous.gif" border="0" alt="previous" width="4" height="7" /> Previous entries</xsl:variable>
<xsl:variable name="m_nopreviouspagethreads"><img  src="{$imageRoot}images/previous.gif" border="0" alt="previous" width="4" height="7" /> Previous entries</xsl:variable>
<xsl:variable name="m_nextpagethreads">Next entries <img  src="{$imageRoot}images/next.gif" border="0" alt="next" width="4" height="7" /></xsl:variable>
<xsl:variable name="m_nonextpagethreads">Next entries <img  src="{$imageRoot}images/next.gif" border="0" alt="next" width="4" height="7" /></xsl:variable>

<xsl:template name="m_NewUsersListingHeading">
		say hello to our new members from the last
		<xsl:if test="number(@TIMEUNITS) &gt; 1">
		<xsl:text/>
		<xsl:value-of select="@TIMEUNITS"/>
		</xsl:if>
		<xsl:text/>
		<xsl:value-of select="@UNITTYPE"/>
		<xsl:if test="number(@TIMEUNITS) &gt; 1">s</xsl:if>:<br/>
		<br/>
	</xsl:template>
	
	<xsl:variable name="m_removetaggednode">remove from index</xsl:variable>
	<xsl:variable name="m_Categorise">edit the categories</xsl:variable>
	<xsl:variable name="m_user">member</xsl:variable>
	<xsl:variable name="m_users">members</xsl:variable>
	<xsl:variable name="m_usera"> a </xsl:variable>
	<xsl:variable name="m_article"><xsl:value-of select="$article_type_group" /></xsl:variable>
	<xsl:variable name="m_articles">reviews</xsl:variable>
	<xsl:variable name="m_articlea"> a </xsl:variable>
	<xsl:variable name="m_articleurl">Article</xsl:variable>
	<xsl:variable name="m_editme">edit</xsl:variable>
	<xsl:variable name="m_removeme">remove</xsl:variable>
	<xsl:variable name="m_editedarticle">editorial</xsl:variable>
	<xsl:variable name="m_editedarticles">editorial</xsl:variable>
	<xsl:variable name="m_editedarticlea"> an </xsl:variable>
	<xsl:variable name="m_editedguide">Edited Site</xsl:variable>
	<xsl:variable name="m_posting">Posting</xsl:variable>
	<xsl:variable name="m_postings">Postings</xsl:variable>
	<xsl:variable name="m_postinga"> a </xsl:variable>
	<xsl:variable name="m_postingurl">Posting</xsl:variable>
	<xsl:variable name="m_thread">conversation</xsl:variable>
	<xsl:variable name="m_threads">entries</xsl:variable>
	<xsl:variable name="m_threada"> a </xsl:variable>
	<xsl:variable name="m_threadurl">conversation</xsl:variable>
	<xsl:variable name="m_forum">conversation forum</xsl:variable>
	<xsl:variable name="m_forums">conversation forums</xsl:variable>
	<xsl:variable name="m_foruma"> a </xsl:variable>
	<xsl:variable name="m_firsttotalk">no conversations</xsl:variable>
	<xsl:variable name="m_journal">weblog</xsl:variable>
	<xsl:variable name="m_journals">weblogs</xsl:variable>
	<xsl:variable name="m_journala"> a </xsl:variable>
	<xsl:variable name="m_journalposting">weblog entry</xsl:variable>
	<xsl:variable name="m_journalpostings">weblog entries</xsl:variable>
	<xsl:variable name="m_journalpostinga"> a </xsl:variable>
	<xsl:variable name="smileylist">smiley, biggrin, cool, sadface, winkeye, doh, ok, tongueout, yawn, zzz, wow, hangover, cross, hug, blush, headhurts, grr, drunk, erm, silly, disco,</xsl:variable>
	<xsl:variable name="m_emailaddress">email address :</xsl:variable>
	<xsl:variable name="m_oruserid">or user id (number) :</xsl:variable>
	<!-- Used on User details unreg -->
	<xsl:variable name="m_postnumber"/>
	<xsl:variable name="m_userpagenav">my space</xsl:variable>
	<xsl:variable name="m_contributenav">talk</xsl:variable>
	<xsl:variable name="m_preferencesnav">my details</xsl:variable>
	<xsl:variable name="alt_showingoldest">first post</xsl:variable>
	<xsl:variable name="alt_nonewerpost">latest post</xsl:variable>
	<xsl:variable name="alt_showoldestconv">first post</xsl:variable>
	<xsl:variable name="alt_shownewest">latest post</xsl:variable>
	<xsl:variable name="alt_shownext">next</xsl:variable>
	<xsl:variable name="alt_showprevious">previous</xsl:variable>
	<xsl:variable name="alt_register">register</xsl:variable>
	<xsl:variable name="alt_newsletter">newsletter</xsl:variable>
	<xsl:variable name="alt_ask">free for all</xsl:variable>
	<xsl:variable name="alt_helpfaqs">help</xsl:variable>
	<xsl:variable name="alt_goingout">more culture</xsl:variable>
	<xsl:variable name="alt_stayingin">staying in</xsl:variable>
	<xsl:variable name="alt_film">film</xsl:variable>
	<xsl:variable name="alt_music">music</xsl:variable>
	<xsl:variable name="alt_frontpage">front page</xsl:variable>
	<xsl:variable name="alt_myconversations">launch pop up</xsl:variable>
	<xsl:variable name="alt_links">links</xsl:variable>
	<xsl:variable name="alt_talk">talk</xsl:variable>
	<xsl:variable name="alt_index">index</xsl:variable>
	<xsl:variable name="alt_nearyou">near you</xsl:variable>
	<xsl:variable name="alt_community">community</xsl:variable>
	<xsl:variable name="m_filmnavcopy"><img src="{$imagesource}nav_film.gif" alt="" width="103" height="30"/></xsl:variable>
	<xsl:variable name="m_musicnavcopy"><img src="{$imagesource}nav_music.gif" alt="" width="103" height="30"/></xsl:variable>
	<xsl:variable name="m_therestnavcopy"><img src="{$imagesource}nav_more.gif" alt="" width="103" height="30"/></xsl:variable>
	<xsl:variable name="alt_feedbackforum">feedback</xsl:variable>
	<xsl:variable name="alt_makemyhomepage">make this my homepage</xsl:variable>
	<xsl:variable name="alt_newconversation">start new <xsl:value-of select="$m_thread"/>
	</xsl:variable>
	<xsl:variable name="m_clicknewentry">write a </xsl:variable>
	<xsl:variable name="m_clicknewreview">write </xsl:variable>
	<xsl:variable name="m_clicknewpage">create a page</xsl:variable>
	<xsl:variable name="m_browsetheguide">
		or browse the <a href="{$root}C0" class="bluelink">index</a>
	</xsl:variable>
	<xsl:variable name="m_recentarticlethreads">
		<!-- <xsl:value-of select="$m_memberormy"/>  -->messages</xsl:variable>
	<xsl:variable name="m_recentarticlethreads2">related conversations</xsl:variable>
	<xsl:variable name="alt_discussthis">Add a recollection</xsl:variable>
	<xsl:variable name="alt_addyourown">Add your own recollection</xsl:variable>
	<xsl:variable name="alt_suggestnewwork">Suggest a new work for the site</xsl:variable>
	<xsl:variable name="alt_dontpanic">
		<b>
			help with this page</b>
	</xsl:variable>
	<xsl:variable name="m_thisconvforentry">topic: </xsl:variable>
	<xsl:variable name="m_thisjournal">weblog: </xsl:variable>
	<xsl:variable name="m_thismessagecentre">messages for: </xsl:variable>
	<xsl:variable name="m_houserules">house rules</xsl:variable>
	<xsl:variable name="m_resultsfound">search results</xsl:variable>
	<xsl:variable name="m_enterwordsorphrases">search for</xsl:variable>
	<xsl:variable name="m_searchsubject">search the site</xsl:variable>
	<xsl:variable name="m_wheretosearch">an <b>article</b>, a <b>conversation</b> or a <b>member</b>
	</xsl:variable>
	<xsl:variable name="m_oruseindex">or click on a letter:</xsl:variable>
	<xsl:variable name="m_addguideentry">send</xsl:variable>
	<xsl:variable name="m_searchtheguide">send</xsl:variable>
	<xsl:variable name="m_preview">preview</xsl:variable>
	<xsl:variable name="m_AddGuideEntryHeading">make a <xsl:value-of select="$m_article"/>
	</xsl:variable>
	<xsl:variable name="coll_leavemessage">leave me a message</xsl:variable>
	<xsl:variable name="m_replytothispost">add comment</xsl:variable>
	<xsl:variable name="alt_complain"><img src="{$imagesource}icons/complain_white.gif" alt="complain about this page" width="16" height="13" border="0" /></xsl:variable>
	<xsl:variable name="m_nickname">enter new screen name: </xsl:variable>
	<xsl:variable name="m_emailaddr">email address :</xsl:variable>
	<xsl:variable name="m_password">password :</xsl:variable>
	<xsl:variable name="m_newpassword">new password :</xsl:variable>
	<xsl:variable name="m_oldpassword">current password :</xsl:variable>
	<xsl:variable name="m_confirmpassword">confirm new password :</xsl:variable>
	<xsl:variable name="m_confirmbbcpassword">confirm password :</xsl:variable>
	<xsl:variable name="m_lastposting">last posting: </xsl:variable>
	<xsl:variable name="m_lastposted">last posted: </xsl:variable>
	<xsl:variable name="m_lastreply">last comment </xsl:variable>
	<xsl:variable name="m_LastPost">message from</xsl:variable>
	<xsl:variable name="m_postedcolon"> 
	<xsl:choose>
	<xsl:when test="$ownerisviewer = 1">your</xsl:when>
	<xsl:otherwise>member's</xsl:otherwise>
	</xsl:choose>
	 last comment 
	</xsl:variable>
	<xsl:variable name="m_noposting"></xsl:variable>
	<xsl:variable name="m_latestreply">latest reply: </xsl:variable>
	<xsl:variable name="m_newestpost">last comment </xsl:variable>
	<xsl:variable name="m_posted">comment </xsl:variable>
	<xsl:variable name="m_noreplies">no new comments</xsl:variable>
	<xsl:variable name="m_nosubject">no subject</xsl:variable>
	<xsl:variable name="m_clickherediscuss">add comment</xsl:variable>
	<xsl:variable name="m_removejournal">delete<!--xsl:value-of select="$m_journalposting"/-->
	</xsl:variable>
	<xsl:variable name="m_EditGuideEntryHeading">update <xsl:value-of select="$m_article"/>
	</xsl:variable>
	<xsl:variable name="m_updateentry">send</xsl:variable>
	<xsl:variable name="m_clickunsubscribe">remove from my <xsl:value-of select="$m_threads"/>
	</xsl:variable>
	<xsl:variable name="m_clicksubscribe">add to my <xsl:value-of select="$m_threads"/>
	</xsl:variable>
	<!-- <xsl:variable name="m_peopletalking"></xsl:variable> -->
	<xsl:variable name="m_clickunsubforum">remove from my conversation list</xsl:variable>
	<xsl:variable name="m_clicksubforum">add to my conversation list</xsl:variable>
	<xsl:template name="m_forumpostingsdisclaimer">
	Most of the content on this site is created by our <xsl:value-of select="$m_users"/>, who are members of the public. The views expressed are theirs and unless specifically stated are not those of the BBC. The BBC is not responsible for the content of any external sites referenced. In the event that you consider anything on this page to be in breach of the site's <A xsl:use-attribute-sets="nm_forumpostingsdisclaimer" TARGET="_top" HREF="http://www.bbc.co.uk/mysciencefictionlife/pages/houserules.shtml">House Rules</A>, please click on the relevant <img src="{$imagesource}buttons/complain.gif" border="0"/> button to alert our Moderation Team.
	</xsl:template>
	<xsl:variable name="m_mostrecentedited">
		<xsl:value-of select="$m_memberormy"/> recent editorial</xsl:variable>
	<xsl:variable name="m_newusers">new <xsl:value-of select="$m_users"/>
	</xsl:variable>
	<xsl:variable name="m_userhasmastheadflag"><xsl:copy-of select="$member.has_intro.orange" /></xsl:variable>
	<xsl:variable name="m_usersintropostedtoflag"><xsl:copy-of select="$member.left_message.orange" /></xsl:variable>
	<xsl:variable name="m_postingsby">all <xsl:value-of select="$m_memberormy"/> conversations</xsl:variable>
	<xsl:variable name="m_MABackTo">back to </xsl:variable>
	<xsl:variable name="m_MAPSpace">'s space</xsl:variable>
	<xsl:variable name="m_PostsBackTo">back </xsl:variable>
	<xsl:variable name="m_PostsPSpace">'s space</xsl:variable>
	<xsl:variable name="m_editor">by:</xsl:variable>
	<xsl:variable name="m_researchers">and:</xsl:variable>
	<xsl:variable name="m_MarkAllRead">mark all as old</xsl:variable>
	<xsl:variable name="m_deletesubject">Delete Subject</xsl:variable>
	<xsl:variable name="m_movesubject">Move Subject</xsl:variable>
	<xsl:variable name="alt_nonewconvs">next</xsl:variable>
	<xsl:variable name="m_noolderconv">previous</xsl:variable>
	<xsl:variable name="toplevelcats">
		<name>music</name>
		<name>film</name>
		<name>going out</name>
		<name>where I live</name>
	</xsl:variable>
	<!--xsl:variable name="m_mostrecentconv">my recent <xsl:value-of select="$m_threads"/>
	</xsl:variable>
	<xsl:variable name="m_recententries">my recent <xsl:value-of select="$m_articles"/>
	</xsl:variable-->
	 
	 <xsl:variable name="m_editviewerfull"><xsl:value-of select="$m_memberormy"/> editorial</xsl:variable>
	<xsl:variable name="m_editownerfull"><xsl:value-of select="$m_memberormy"/> editorial</xsl:variable>
		<xsl:variable name="m_mostrecentconv">
		<!-- <xsl:value-of select="$m_memberormy"/><xsl:text>  </xsl:text> --><xsl:value-of select="$m_threads"/>
	</xsl:variable>
	<xsl:variable name="m_recentapprovals">
		<!-- <xsl:value-of select="$m_memberormy"/>  -->editorial
	</xsl:variable>
	<xsl:variable name="m_recententries">
		<!-- <xsl:value-of select="$m_memberormy"/>  -->portfolio
	</xsl:variable>
	<xsl:variable name="m_clickmorereviewentries">all <xsl:value-of select="$m_memberormy"/>&space;<xsl:value-of select="$m_articles"/>
	</xsl:variable>
	
	<xsl:variable name="m_clickmoreconv">
	<xsl:choose>
	<xsl:when test="H2G2/@TYPE='USERPAGE'"><xsl:value-of select="concat('View all ', $m_threads)"/>
	</xsl:when>
	<xsl:otherwise>all related <xsl:value-of select="$m_threads"/>
	</xsl:otherwise>
	</xsl:choose>
	</xsl:variable>
	
	<xsl:variable name="coll_allmyconvs">all <xsl:value-of select="$m_memberormy"/>&space;<xsl:value-of select="$m_threads"/>
	</xsl:variable>
	<xsl:variable name="m_intro"><!-- <xsl:value-of select="$m_memberormy"/> -->&space;intro</xsl:variable>
	<xsl:variable name="m_weblog"><!-- <xsl:value-of select="$m_memberormy"/>&space; --><xsl:value-of select="$m_journal"/></xsl:variable>
	<xsl:variable name="m_clickmoreuserpageconv">all <xsl:value-of select="$m_memberormy"/> messages</xsl:variable>
	<xsl:variable name="m_clickmoreentries">all <xsl:value-of select="$m_memberormy"/> portfolio</xsl:variable>
	<xsl:variable name="m_clickmorejournal">all <xsl:value-of select="$m_memberormy"/>&space;<xsl:value-of select="$m_journalpostings"/>
	</xsl:variable>
	
	<xsl:variable name="alt_editentry">edit <xsl:value-of select="$m_article"/>
	</xsl:variable>
	<xsl:variable name="m_editentrylinktext">edit <xsl:value-of select="$m_article"/>
	</xsl:variable>
	<xsl:variable name="m_subforumcomplete">request to add notification of new conversations completed</xsl:variable>
	<xsl:variable name="m_unsubforumcomplete">request to remove notification of new conversations completed</xsl:variable>
	<xsl:variable name="m_journalremovecomplete">request to remove <xsl:value-of select="$m_journalposting"/> completed</xsl:variable>
	<xsl:variable name="m_showeditedentries">show <xsl:value-of select="$m_editedarticles"/>
	</xsl:variable>
	<xsl:variable name="m_showguideentries">show <xsl:value-of select="$m_articles"/>
	</xsl:variable>
	<xsl:variable name="m_showcancelledentries">show deleted</xsl:variable>
	<xsl:template name="m_searchresultsthissite">Here are your search results for "<xsl:value-of select="$test_SearchTerm"/>" <!--xsl:value-of select="$m_sitetitle"/-->
	</xsl:template>
	<xsl:variable name="m_searchbbci">
		<a href="http://www.bbc.co.uk/cgi-bin/search/results.pl?q={$test_SearchTerm}&amp;tab=allbbc" class="bluelink">search bbc.co.uk</a> for "<xsl:value-of select="$test_SearchTerm"/>"</xsl:variable>
	<xsl:variable name="m_searchtheweb">
		<a href="http://www.bbc.co.uk/cgi-bin/search/results.pl?q={$test_SearchTerm}&amp;tab=www" class="bluelink">search the web</a> for "<xsl:value-of select="$test_SearchTerm"/>"</xsl:variable>
	<xsl:variable name="alt_audiovideo">broadband</xsl:variable>
	<xsl:variable name="alt_login">sign in</xsl:variable>
	<xsl:variable name="alt_myspace">my space</xsl:variable>
	<xsl:variable name="alt_preferences">my details</xsl:variable>
	<xsl:variable name="alt_logout">sign out</xsl:variable>
	<xsl:variable name="alt_editthispage">edit introduction</xsl:variable>
	<xsl:variable name="alt_editthispage2"/>
	<xsl:variable name="alt_introduction">introduction :</xsl:variable>
	<xsl:variable name="coll_allarticles">editorial / review</xsl:variable>
	<xsl:variable name="m_preferencessubject">my details</xsl:variable>
	<xsl:variable name="m_addjournal">new <xsl:value-of select="$m_journal"/> entry</xsl:variable>
	<xsl:variable name="m_fsubject">title :</xsl:variable>
	<xsl:variable name="m_content">review :</xsl:variable>
	<xsl:variable name="m_textcolon">comment :</xsl:variable>
	<xsl:variable name="m_AddHomePageHeading">add introduction</xsl:variable>
	<xsl:variable name="m_inreplyto">in reply to </xsl:variable>
	<xsl:variable name="m_thispost">this</xsl:variable>
	<xsl:variable name="m_postedsoon">posted soon </xsl:variable>
	<xsl:variable name="m_readthe"> or read </xsl:variable>
	<xsl:variable name="m_firstreplytothis">first reply</xsl:variable>
	<xsl:variable name="m_returntothreadspage">all related <xsl:value-of select="$m_threads"/>
	</xsl:variable>
	<xsl:variable name="m_newerpostings"> previous
		<!-- <img src="{$imagesource}icon_left.gif" alt="previous" width="12" height="20" border="0"/> -->
	</xsl:variable>
	<xsl:variable name="m_olderpostings"> next
		<!-- <img src="{$imagesource}icon_right.gif" alt="next" width="12" height="20" border="0"/> -->
	</xsl:variable>
	<xsl:variable name="m_EditHomePageHeading">update introduction</xsl:variable>
	<xsl:variable name="m_prevresults">previous</xsl:variable>
	<xsl:variable name="m_nextresults">next</xsl:variable>
	<xsl:variable name="m_memberormy">
		<xsl:choose>
			<xsl:when test="$ownerisviewer=1">my</xsl:when>
			<xsl:otherwise>member's</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="m_noprevresults">previous</xsl:variable>
	<xsl:variable name="m_nomoreresults">next</xsl:variable>
	<xsl:variable name="skipdivider"/>
	<xsl:variable name="coll_usefullinkdisclaimer">note: The BBC is not responsible for the content of external internet sites.</xsl:variable>
	<xsl:variable name="coll_preferencesintro">This is where you can make changes to your details.</xsl:variable>
	<xsl:variable name="coll_categoryhint">Click on a
		<b>category</b>
	</xsl:variable>
	<xsl:variable name="coll_allmymessages">all <xsl:value-of select="$m_memberormy"/> messages</xsl:variable>
	<xsl:variable name="coll_sendtoafriend">
		<div class="icon-send-to-friend"><a onClick="popmailwin('/cgi-bin/navigation/mailto.pl?GO=1','Mailer')" href="/cgi-bin/navigation/mailto.pl?GO=1" target="Mailer"><img src="{$imagesource}icons/send_to_friend.gif" border="0" align="middle" /> send to a friend</a></div>
	</xsl:variable>
	<xsl:variable name="messhighlightcolour">#cc0000</xsl:variable>
	<xsl:variable name="coll_messagehighlight">*</xsl:variable>
	<xsl:variable name="registerast">*</xsl:variable>
	<xsl:variable name="m_morepostsothersites">all <xsl:value-of select="$m_memberormy"/>&space;<xsl:value-of select="$m_threads"/> from other sites</xsl:variable>
	<xsl:variable name="m_morearticlesothersites">all <xsl:value-of select="$m_memberormy"/> articles from other sites</xsl:variable>
	<xsl:variable name="coll_changenickname">change screen name</xsl:variable>
	<xsl:variable name="coll_changeemail">change email address</xsl:variable>
	<xsl:variable name="coll_changepassword">change password</xsl:variable>
	<xsl:variable name="coll_unregisteredwelcome">New to this site? Find out more <a href="{$root}about" class="bluelink">about My Science Fiction Life</a>.
	</xsl:variable>
	<xsl:variable name="coll_relevance">relevance</xsl:variable>
	<xsl:variable name="coll_convsothersites">all <xsl:value-of select="$m_threads"/> from other sites</xsl:variable>
	<xsl:variable name="coll_convsothersites2">
		<xsl:value-of select="$m_threads"/> from other sites</xsl:variable>
	<xsl:variable name="coll_articlesothersites">all articles from other sites</xsl:variable>
	<xsl:variable name="coll_changenicknametext">Your screen name appears next to all your posts.</xsl:variable>
	<xsl:variable name="coll_bottomloginblurb">Having problems? See our <a href="{$root}faq" class="bluelink">help FAQs</a> or <a href="mailto:collective.support@bbc.co.uk" class="bluelink">email us</a>. We'll contact you as soon as we can.</xsl:variable>
	<xsl:variable name="coll_bottomregblurb">Having problems? See our <a href="{$root}faq" class="bluelink">help section</a> or <a href="mailto:collective.support@bbc.co.uk" class="bluelink">email us</a>. We'll contact you as soon as we can.</xsl:variable>
	<xsl:variable name="coll_conversationtitle">conversation:</xsl:variable>
	<xsl:variable name="coll_houserules">house rules</xsl:variable>
	<xsl:variable name="coll_othersearches">other searches</xsl:variable>
	<xsl:variable name="coll_allmy">all <xsl:value-of select="$m_memberormy"/>
	</xsl:variable>
	<xsl:variable name="coll_realmediatext">to access audio and video on my science fiction life you need <a href="http://www.bbc.co.uk/webwise/categories/plug/real/real.shtml?intro" target="realplayer" onClick="popup_scroll(this.href,this.target,  645, 350);return false;" class="bluelink">real player</a>.</xsl:variable>
	<xsl:variable name="coll_realmedialogo">
		<a href="http://www.bbc.co.uk/webwise/categories/plug/real/real.shtml?intro" target="realplayer" onClick="popup_scroll(this.href,this.target,  645, 350);return false;">
			<img src="{$imagesource}icon_real.gif" alt="Real Player" width="20" height="20" border="0"/>
		</a>
	</xsl:variable>
	<!-- coll: only exists in collective -->
	<xsl:variable name="m_startnewconv">new <xsl:value-of select="$m_thread"/>
	</xsl:variable>
	<xsl:variable name="m_newerentries">previous</xsl:variable>
	<xsl:variable name="m_olderentries">next</xsl:variable>
	<xsl:variable name="m_posttoaforum">post new comment</xsl:variable>
	<xsl:variable name="m_previewjournal">preview</xsl:variable>
	<xsl:variable name="m_newloginbutton">send</xsl:variable>
	<xsl:variable name="m_newregisterbutton">send</xsl:variable>
	<xsl:variable name="m_storejournal">send</xsl:variable>
	<!--xsl:variable name="m_clicknotifynewconv">alert me of new <xsl:value-of select="$m_threads"/> about this <xsl:value-of select="$m_article"/>
	</xsl:variable>
	<xsl:variable name="m_clickstopnotifynewconv">stop alerting me of new <xsl:value-of select="$m_threads"/> for this <xsl:value-of select="$m_article"/>.</xsl:variable-->
	<xsl:variable name="m_changepasswordmessage">
		<a xsl:use-attribute-sets="nm_changepasswordmessage" href="{$m_changepasswordmessageURL}">Forgotten your password?</a> We'll email you a new one.</xsl:variable>
	<xsl:variable name="m_loginname">sign in (won't be your screen name) :</xsl:variable>
	<xsl:variable name="m_bbcpassword">password :</xsl:variable>
	<xsl:variable name="m_backtouserpage">go back to my space without editing</xsl:variable>
	<xsl:variable name="m_unsubthreadcomplete">remove from my conversations</xsl:variable>
	<xsl:variable name="m_subthreadcomplete">add to my conversations</xsl:variable>
	<xsl:variable name="m_subscribedtothread">You have added this conversation to <xsl:value-of select="$alt_myconversations"/>
	</xsl:variable>
	<xsl:variable name="m_UserEditHouseRulesDiscl">Remember, when you contribute to the site you are giving the BBC permission to use your contribution in a variety of ways. See the <xsl:copy-of select="$m_TermsAndCondLink"/> for more information.</xsl:variable>
	<xsl:variable name="m_unsubscribedfromthread">you have removed this conversation from <xsl:value-of select="$alt_myconversations"/>. </xsl:variable>
	<xsl:variable name="m_clickmoreedited">all <xsl:value-of select="$m_memberormy"/>&space;<xsl:value-of select="$m_editedarticles"/>
	</xsl:variable>
	<xsl:variable name="m_WritingPlainTextHelpLink">
		<xsl:choose>
			<xsl:when test="$test_AddHomePage or $test_EditHomePage">egintroduction</xsl:when>
			<xsl:otherwise>egrecommendation</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="m_WritingGuideMLHelpLink">
		<!-- Functionality for this still exists if collective want it in the future -->
		<xsl:value-of select="$m_WritingPlainTextHelpLink"/>
	</xsl:variable>
	<xsl:variable name="m_returntoconv"><xsl:element name="img" use-attribute-sets="anchor.seelastcomments" /></xsl:variable>
	<xsl:variable name="coll_withoutposting">without posting</xsl:variable>
	<xsl:variable name="m_returntoentry"><img src="{$imagesource}/buttons/see_last_comment.gif" width="146" height="23" alt="show last comment" border="0" /></xsl:variable>
	<!--xsl:variable name="coll_backtoentry2">without posting</xsl:variable-->
	<xsl:variable name="m_returntoforum">back<!-- here to return to the <xsl:value-of select="$m_forum"/> without saying anything-->
	</xsl:variable>
	<!--xsl:variable name="coll_backtoforum2">without posting</xsl:variable-->
	<xsl:variable name="m_messageisfrom">posted by </xsl:variable>
	<xsl:variable name="alt_previewmess">preview</xsl:variable>
	<xsl:variable name="alt_postmess">send</xsl:variable>
	<xsl:variable name="m_addintroduction">send</xsl:variable>
	<xsl:variable name="m_updateintroduction">send</xsl:variable>
	<xsl:variable name="m_moreconversations"></xsl:variable>
	<xsl:variable name="m_recentconvs">new conversations</xsl:variable>
	<xsl:variable name="m_recentrevs">latest member reviews</xsl:variable>
	<xsl:variable name="m_morearticles"><a href="{$root}info" class="bluelink">more</a> latest reviews</xsl:variable>
	<xsl:variable name="m_moreconvs"><a href="{$root}info" class="bluelink">latest conversations</a></xsl:variable>
	<xsl:variable name="m_regorlogin"><a href="{$root}register" class="bluelink">register</a> or <a href="{$root}login" class="bluelink">sign in</a> and contribute to my science fiction life</xsl:variable>
	<xsl:variable name="m_nopreventries">previous</xsl:variable>
	<xsl:variable name="m_nomoreentries">next</xsl:variable>

	
	<xsl:variable name="listmemberarts">Here is a list of <xsl:value-of select="$reviewored"/> beginning with the letter <xsl:value-of select="translate(/H2G2/INDEX/@LETTER, $uppercase, $lowercase)"/>.</xsl:variable>
	<xsl:variable name="m_memberreview">member's reviews</xsl:variable>
	<xsl:variable name="m_refresh">send</xsl:variable>
<xsl:variable name="m_indextitle">a to z</xsl:variable>
<xsl:variable name="m_indextitle2">a to z</xsl:variable>
<xsl:variable name="m_indextitle3"><!--index of <xsl:value-of select="$reviewored"/>-->a to z</xsl:variable>
<xsl:variable name="membersreviewtext">This is a list of the twenty most recently written member's reviews.</xsl:variable>
<xsl:variable name="clickonletter">Click to see a list of member's reviews beginning with each letter.</xsl:variable>
<xsl:variable name="clickonletter2">Click to see a list of editorial beginning with each letter.</xsl:variable>
<xsl:variable name="clickonletter3">Click to see a list of <xsl:value-of select="$reviewored"/> beginning with each letter.</xsl:variable>
<xsl:variable name="m_notfoundsubject">page not found</xsl:variable>
<xsl:variable name="m_previous">previous&space;</xsl:variable>
<xsl:variable name="m_nextspace">next&space;</xsl:variable>
<xsl:variable name="reviewored">
	<xsl:choose>
		<xsl:when test="/H2G2/INDEX/INDEXENTRY[STATUSNUMBER=1] and not(/H2G2/INDEX/INDEXENTRY[STATUSNUMBER=3])">editorial</xsl:when>
		<xsl:when test="/H2G2/INDEX/INDEXENTRY[STATUSNUMBER=3] and not(/H2G2/INDEX/INDEXENTRY[STATUSNUMBER=1])">member's reviews</xsl:when>
		<xsl:otherwise>editorial and member's reviews</xsl:otherwise>
	</xsl:choose>
</xsl:variable>
<xsl:variable name="indexfor">index for </xsl:variable>
<xsl:variable name="m_noresults">no results found</xsl:variable>
<xsl:variable name="alt_win">win</xsl:variable>
<xsl:variable name="m_clicknotifynewconv">add to my conversations</xsl:variable>
<xsl:variable name="m_clickstopnotifynewconv">remove from my conversations</xsl:variable>
<xsl:variable name="m_memberofothersite">This member is also a member of <a class="bluelink" href="/dna/{/H2G2/SITE-LIST/SITE[@ID=/H2G2/ARTICLE/ARTICLEINFO/SITEID]/NAME}/"><xsl:value-of select="/H2G2/SITE-LIST/SITE[@ID=/H2G2/ARTICLE/ARTICLEINFO/SITEID]/SHORTNAME"/></a>, where messages for them will be left.</xsl:variable>
	<xsl:template name="UserPageEditIntro">
		<p>See an <xsl:apply-templates select="/H2G2/HELP" mode="WritingGE"/>.</p>
		<p>- You can edit your introduction whenever you want.<br/>
- Don't include anything you don't want others to read.<br/>
- Changes will not take effect until you press send.<br/>
		</p>
	</xsl:template>
	<xsl:template name="ArticlePageEditIntro">
		<p>See an <xsl:apply-templates select="/H2G2/HELP" mode="WritingGE"/>.</p>
		<p>- You can edit your review later.<br/>
- Try reviewing a film, book, album or place to go.<br/>
- Your review will appear in my space.<br/>
- We may feature your review on the category pages.
<!--- By making a review you will be eligible to win this week's prize. Please read the <a href="{$root}competition" class="bluelink">competition rules</a>.-->
		</p>
	</xsl:template>
	<xsl:variable name="alt_clickherehelpentry">example</xsl:variable>
	<xsl:variable name="m_NormalEntryStatusName">review</xsl:variable>
	<xsl:variable name="m_EditedEntryStatusName">editorial</xsl:variable>
	<xsl:variable name="m_HelpPageStatusName">help faqs</xsl:variable>
	<xsl:template name="m_searchlink">
		<a xsl:use-attribute-sets="nm_searchlink" target="_top" href="{$root}Search">search</a> collective
	</xsl:template>
	<xsl:variable name="m_forgottenpassword">forgotten your password</xsl:variable>
	<xsl:template name="m_welcomebackuser">
		<table border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td>
					
Signed in: <xsl:value-of select="substring(VIEWING-USER/USER/USERNAME,1,40)"/>
						<xsl:if test="string-length(VIEWING-USER/USER/USERNAME) &gt; 40">..</xsl:if>
					
				</td>
				<td>
					<img src="{$imagesource}tiny.gif" alt="" width="7" height="1"/>
				</td>
				<td>
					<a href="{$root}Logout" xsl:use-attribute-sets="nm_welcomebackuser">
						<img src="{$imagesource}icon_logout.gif" alt="sign out" width="10" height="11" border="0"/>
					</a>
				</td>
				<td>
					<img src="{$imagesource}tiny.gif" alt="" width="3" height="1"/>
				</td>
				<td>
					
						<a href="{$root}Logout" xsl:use-attribute-sets="nm_welcomebackuser">
						 sign out</a>
					
				</td>
			</tr>
		</table>
		<!--a xsl:use-attribute-sets="nm_welcomebackuser" HREF="{$root}Register">(Click here if this isn't you)</a-->
	</xsl:template>
	<xsl:variable name="m_artownerempty">
		This is where reviews that you publish on Collective will be displayed.  After publishing a review you can go back and edit it if you want to.  All member reviews published by UK residents are entered for our weekly competition.  See this week's winning reviews on the <a href="{$root}">front page</a>.
	</xsl:variable>
		<xsl:variable name="m_artviewerempty">
		This is where reviews that <xsl:value-of select="/H2G2/PAGE-OWNER/USER/USERNAME"/> publishes on Collective will be displayed.  All member reviews published by UK residents are entered for our weekly competition.  See this week's winning reviews on the <a href="{$root}">front page</a>.
	</xsl:variable>
		<xsl:variable name="m_pageownerempty">
		This is where your portfolio pages will be displayed.  Portfolio pages are pieces that go beyond the realms of an ordinary review.  Other people have used this to create city guides, buyers' guides and short stories.  You can see examples on the <a href="{$root}memberprojects">member projects</a> page.
	</xsl:variable>
		<xsl:variable name="m_pageviewerempty">
		This is where <xsl:value-of select="/H2G2/PAGE-OWNER/USER/USERNAME"/>'s portfolio pages will be displayed.  Portfolio pages are pieces that go beyond the realms of an ordinary review.  Other people have used this to create city guides, buyers' guides and short stories.  You can see examples on the member projects page.
	</xsl:variable>
	<xsl:template name="m_forumownerfull">
		<!-- this is a list of your most recent <xsl:value-of select="$m_threads"/>-->
	</xsl:template>
	<xsl:template name="m_artownerfull"/>
	<xsl:template name="m_journalownerfull">
		Welcome to your <xsl:value-of select="$m_journal"/>.
	</xsl:template>
	
	<!-- conversations -->
	<xsl:variable name="m_forumownerempty">
	Your recollections will appear here. 
	</xsl:variable>
	<xsl:variable name="m_forumviewerempty">
	<xsl:value-of select="/H2G2/PAGE-OWNER/USER/USERNAME"/>'s recollections will appear here. 
	</xsl:variable>
	
	<!-- reviews -->
	<xsl:variable name="m_reviewempty">
	Links to reviews <xsl:value-of select="/H2G2/PAGE-OWNER/USER/USERNAME"/> writes will appear here.
	</xsl:variable>
	
	<!-- pages -->
	<xsl:variable name="m_pageempty">
	Links to other pages that <xsl:value-of select="/H2G2/PAGE-OWNER/USER/USERNAME"/> publishes on Collective will appear here. 
	</xsl:variable>
	
	<!--  owner reviews -->
	<xsl:variable name="m_ownerreviewempty">
	Links to reviews you write will appear here.
	</xsl:variable>
	
	<!-- owner pages -->
	<xsl:variable name="m_ownerpageempty">
	Links to other pages that you publish on Collective will appear here. 
	</xsl:variable>

	<!-- messages -->
	<xsl:variable name="m_nomessagesowner">Messages that other members have left for you will appear here.  To leave a message for someone else click on their name and then "leave me a message". 
	</xsl:variable>
	<xsl:variable name="m_nomessages">
	Messages that other members have left for <xsl:value-of select="/H2G2/PAGE-OWNER/USER/USERNAME"/> will appear here.  To leave a message for them click "leave me a message" on the right of this page. 
	</xsl:variable>
	
	<!-- weblogs -->
	<xsl:template name="m_journalownerempty">Your latest weblog entry will appear here.  To write a weblog click the link below.
	</xsl:template>
	<xsl:template name="m_journalviewerempty">
	<xsl:value-of select="/H2G2/PAGE-OWNER/USER/USERNAME"/>'s latest weblog entry will appear here.
	</xsl:template>
	
	<xsl:template name="m_journalviewerfull"> by<br/><xsl:value-of select="/H2G2/PAGE-OWNER/USER/USERNAME"/></xsl:template>
	<xsl:template name="m_registerslug">
		
	<span class="title">add your opinion</span>
		
		<br/>
		
			To add your comments simply <a xsl:use-attribute-sets="nm_registerslug" href="/cgi-perl/signon/mainscript.pl?service=collective&amp;c=register">create your membership</a> - we only need your email address.
			
		
	</xsl:template>

<xsl:template name="m_psintroowner">
	<!-- SC --><!-- Removed text below for site closure CV 28/02/07 -->
	<p class="info">This is your personal space on My Science Fiction Life. Click here to explore the <a href="http://www.bbc.co.uk/mysciencefictionlife/timeline/"><strong>Science Fiction timeline</strong></a>.</p><p class="info">This site is now closed to further contributions.</p>
	<!-- To add your recollections of your favourite science fiction, <a href="http://www.bbc.co.uk/mysciencefictionlife/timeline/"><strong>visit the timeline</strong></a>. -->

	<xsl:if test="$test_IsEditor">
	<p class="info">Select "<a href="{$root}useredit{/H2G2/ARTICLE/ARTICLEINFO/H2G2ID}">Edit your intro</a>" to replace this text with something about yourself.  Most members tell us about their favourite films, books etc.</p>
	<br /> 
	</xsl:if>

</xsl:template>
	

<xsl:template name="m_psintroviewer">
<p>Welcome to <xsl:value-of select="/H2G2/PAGE-OWNER/USER/USERNAME"/>'s personal space.</p> 

<!--
They have yet to write a personal introduction.  

<p>If you are a Collective member and have not written your introduction your space will appear like this too.</p>

<p><xsl:value-of select="/H2G2/PAGE-OWNER/USER/USERNAME"/>'s reviews and conversations are linked to from this page.</p>

<p>To find out more about using Collective go to <a href="{$root}about">about</a> - Have fun, Collective Editors.</p>-->
</xsl:template>
	

	
	<xsl:template name="m_searchresultsothersites">These results were found in other <a href="http://www.bbc.co.uk/dna/hub/A785298" class="bluelink">DNA</a> sites:</xsl:template>
	<xsl:variable name="m_clickaddjournal">add <xsl:value-of select="$m_journalpostinga"/>
		<xsl:value-of select="$m_journalposting"/>
	</xsl:variable>
	<xsl:variable name="m_logoutblurb">
		<strong>You have just signed out. The next time you visit on this computer we won't automatically recognise you.<br />
		<xsl:if test="$registered=1"><p>If you came to this page directly (by a bookmarked link or by typing in the address yourself), please click on the "sign out" link on your <a href="{$root}/H2G2/PAGE-OWNER/USER/USERID" class="bluelink" target="_top">my space</a> page to sign out.</p></xsl:if><br />
		To sign in again, go to <a>
							<xsl:attribute name="href"><xsl:value-of select="$sso_signinlink" /><xsl:value-of select="$referrer" /></xsl:attribute>
							My profile
						</a>.</strong>

	</xsl:variable>
	<xsl:template name="m_bbcloginblurb">
		<p>This is where you sign in to my science fiction life. You need to <a xsl:use-attribute-sets="nm_bbcloginblurb">
				<xsl:call-template name="regpassthroughhref">
					<xsl:with-param name="url">Register</xsl:with-param>
				</xsl:call-template>register</a> with my science fiction life before you can sign in.</p>
		<p>- Your sign in and password are case sensitive.</p>
		<p>- If you have <a xsl:use-attribute-sets="nm_bbcloginblurb" href="{$root}UserDetails?unregcmd=yes">forgotten your password</a>, then we can email you a new one.
		</p>
	</xsl:template>
	<xsl:template name="m_bbcregblurb">
		<p>This is where you register with my science fiction life. If you've <b>already registered</b> please use the <a xsl:use-attribute-sets="nm_bbcregblurb1">
				<xsl:call-template name="regpassthroughhref">
					<xsl:with-param name="url">Login</xsl:with-param>
				</xsl:call-template>sign in page</a>.</p>
		<p>- Your member name and password must both have at least 6 characters and no spaces.</p>
		<p>- You must accept the House Rules, Privacy Policy and <xsl:copy-of select="$m_TermsAndCondLink"/>.</p>
		<p>- You must complete fields marked with an asterisk [*].</p>
		<!--p>- You should provide an email address in case we need to contact you about a post you've made.</p>
		<p>- Please agree to our <a xsl:use-attribute-sets="nm_bbcregblurb2" href="http://www.bbc.co.uk/mysciencefictionlife/pages/houserules.shtml">House Rules</a> and <a xsl:use-attribute-sets="nm_bbcregblurb3" href="http://www.bbc.co.uk/copyright">Terms and Conditions</a> by ticking the box below.</p-->
	</xsl:template>
	<xsl:template name="m_bbcregblurb2">
		<p class="brownongrey">Your registration information will be used to:<br/>
- verify your access to bbc.co.uk services which require registration.<br/>
- allow us to contact you for <a href="http://www.bbc.co.uk/privacy/#4" xsl:use-attribute-sets="nm_bbcregblurb2">service administration purposes</a>.<br/>
- personalise your experience on bbc.co.uk.<br/>
		</p>
	</xsl:template>
	<xsl:template name="m_agreetoterms">I agree to the <a xsl:use-attribute-sets="nm_agreetoterms1" href="http://www.bbc.co.uk/mysciencefictionlife/pages/houserules.shtml">House Rules</a>, <a href="http://www.bbc.co.uk/privacy" xsl:use-attribute-sets="nm_agreetoterms1">Privacy Policy</a> and <a href="http://www.bbc.co.uk/terms/" xsl:use-attribute-sets="nm_bbcregblurb2"><xsl:copy-of select="$m_TermsAndCondLink"/></a>.
	</xsl:template>
	<xsl:variable name="m_alwaysremember">Always remember me on this computer.</xsl:variable>
	<xsl:template name="m_artviewerfull">
		<p>reviews by <xsl:value-of select="/H2G2/PAGE-OWNER/USER/USERNAME"/>
		</p>
	</xsl:template>
	<xsl:template name="m_registertodiscuss">
		<p class="brownongrey">If you <a xsl:use-attribute-sets="nm_registertodiscuss" href="{$root}register">register</a> you can discuss this <xsl:value-of select="$m_article"/> with other <xsl:value-of select="$m_users"/>.</p>
	</xsl:template>
	<xsl:template name="m_unregprefsmessage">
		<p>Please <a href="{$sso_signinlink}" class="bluelink">sign in</a> to change your nickname</p>
		<!--p>- Enter your login (not your screen name) or your user number if you know it.</p>
		<p>- Enter the email address that you used to register.</p>
		<p>- We will then email you a new password.</p-->
	</xsl:template>
	<xsl:variable name="m_journalintro">
		<p>See an <a href="{$root}U199016" class="bluelink" target="blank">example</a>.</p>
		<p>- Try including ideas and links or what you're up to each day.<br/>
- Your weblog entries will appear in my space.<br/>
- Don't include anything you don't want others to read.</p>
	</xsl:variable>
	<xsl:variable name="m_journalintroUI">
		<xsl:copy-of select="$m_journalintro"/>
	</xsl:variable>

	<xsl:template name="m_unregistereduserediterror">
		<p>Sorry, but you can't create or edit <xsl:value-of select="$m_articles"/> until you've signed in.</p>
		<p>- If you have an account, please <a xsl:use-attribute-sets="nm_unregistereduserediterror1" href="{$sso_noarticlesigninlink}">sign in</a>.</p>
		<p>- If you don't have an account please <a xsl:use-attribute-sets="nm_unregistereduserediterror2" href="{$sso_noarticleregisterlink}">click here to become a member</a>. It's quick and easy and will enable you to make comments and reviews whenever you wish.</p>
		<!--	If you haven't already registered with us as a 
<xsl:value-of select="$m_user"/>, please <a xsl:use-attribute-sets="nm_unregistereduserediterror2" href="{$root}Register?pa=editpage">click here to register</a>. Registering is free and will enable you to Share your wisdom with the rest of the Community. <a xsl:use-attribute-sets="nm_unregistereduserediterror3" href="A387317">Tell me more!</a>.-->
	</xsl:template>

	<xsl:variable name="m_postsubjectremoved">comment removed: breaks the <A xsl:use-attribute-sets="nm_postremoved" TARGET="_top" HREF="http://www.bbc.co.uk/mysciencefictionlife/pages/houserules.shtml">house rules</A></xsl:variable>
<xsl:variable name="m_awaitingmoderationsubject">this comment is awaiting moderation</xsl:variable>
	<xsl:template name="m_postawaitingmoderation"></xsl:template>
	<xsl:template name="m_postawaitingpremoderation"></xsl:template>
	<xsl:template name="m_postremoved"></xsl:template>	
	<xsl:variable name="m_ptclicktowritereply">write your reply</xsl:variable>
	<xsl:template name="m_ptwriteguideentry">

		<a xsl:use-attribute-sets="nm_ptwriteguideentry" href="{$root}UserEdit" class="bluelink">write your <xsl:value-of select="$m_article"/></a>
	</xsl:template>

	<xsl:variable name="m_greetingshiker">sorry, please sign in first</xsl:variable>
	<xsl:template name="m_cantpostnotregistered">
		<p class="info"><!-- We're sorry, but you can't post to <xsl:value-of select="$m_threada"/>
			<xsl:value-of select="$m_thread"/> until you've registered with us as <xsl:value-of select="$m_usera"/>
			<xsl:value-of select="$m_user"/>. -->
			This site closed to new contributions in April 2007. You can still browse all of the content and recollections here on the site as an archive for the foreseeable future.</p>
		<p class="info">- If you already have an account, please <A xsl:use-attribute-sets="nm_cantpostnotregistered1" href="{$sso_nopostsigninlink}">sign in</A>.</p>
		<p class="info">- If you don't have an account please <A xsl:use-attribute-sets="nm_cantpostnotregistered2" href="{$sso_nopostregisterlink}">click here to become a member</A>. <!-- It's quick and easy and will enable you to make comments and reviews whenever you wish. --></p>
		<!-- <p class="info">Alternatively, <A xsl:use-attribute-sets="nm_cantpostnotregistered4">  Chelsea put this back comment in TW (and the womment above "It's quick and easy...) TW
				<xsl:attribute name="href"><xsl:value-of select="$root"/>F<xsl:value-of select="@FORUMID"/>?thread=<xsl:value-of select="@THREADID"/>&amp;post=<xsl:value-of select="@POSTID"/>#p<xsl:value-of select="@POSTID"/></xsl:attribute>back</A> to the conversation without signing in.</p> -->
	</xsl:template>
	<xsl:template name="m_searchfailed">
		<p>Sorry, no results for '<xsl:value-of select="SEARCHTERM"/>' were found, please check the spelling and try again OR search elsewhere using the options below.</p>
	</xsl:template>
	<!--xsl:template name="m_ptwriteguideentry">

		you can now write your <a xsl:use-attribute-sets="nm_ptwriteguideentry" href="{$root}UserEdit">reply</a>
	</xsl:template-->
	<xsl:template name="m_notfoundbody">
	We're sorry, but the page you have requested does not exist. 
	This could be because the URL is wrong, or because the page you are looking for has been removed from the Site.
	</xsl:template>
	<xsl:variable name="ownerisviewer">
	<xsl:choose>
		<xsl:when test="string(/H2G2/@TYPE) = 'USERPAGE' and number(/H2G2/VIEWING-USER/USER/USERID) = number(/H2G2/PAGE-OWNER/USER/USERID)">1</xsl:when>
		<xsl:when test="string(/H2G2/@TYPE) = 'MOREPOSTS' and number(/H2G2/VIEWING-USER/USER/USERID) = number(/H2G2/POSTS/@USERID)">1</xsl:when>
		<xsl:when test="string(/H2G2/@TYPE) = 'ARTICLE'and number(/H2G2/VIEWING-USER/USER/USERID) = number(/H2G2/ARTICLE/ARTICLEINFO/PAGEAUTHOR/EDITOR/USER/USERID)">1</xsl:when>
		<xsl:otherwise><xsl:choose><xsl:when test="number(/H2G2/VIEWING-USER/USER/USERID) = number(/H2G2/PAGE-OWNER/USER/USERID)">1</xsl:when><xsl:otherwise>0</xsl:otherwise></xsl:choose></xsl:otherwise>
	</xsl:choose>
</xsl:variable>

	<xsl:template name="m_articledeletedbody">
	<xsl:element name="{$text.base}" use-attribute-sets="text.base">This <xsl:value-of select="$m_article"/> has been deleted from the Site by the author.</xsl:element>
	</xsl:template>
	
	<xsl:template name="m_articlehiddentext">
	<xsl:element name="{$text.base}" use-attribute-sets="text.base">
		<xsl:choose>
			<xsl:when test="$ownerisviewer = 1">
				This article has been hidden by the person who wrote it.
				
			<xsl:call-template name="editorbox" />
			</xsl:when>
			<xsl:when test="$test_IsEditor">
			This article has been hidden by the person who wrote it.<br/>
				<xsl:call-template name="editorbox" />
			</xsl:when>
			<xsl:otherwise>
				<p xsl:use-attribute-sets="ArticleText">This page is currently hidden either because it's not ready for you yet or because it breaks the  <a xsl:use-attribute-sets="nm_articlehiddentext2" href="http://www.bbc.co.uk/mysciencefictionlife/pages/houserules.shtml">house rules</a>.</p>
<xsl:call-template name="editorbox" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:element>	
	</xsl:template>

	<xsl:variable name="m_unsubscribe">remove<!-- from my conversations-->
	</xsl:variable>
	<xsl:variable name="helpwiththispagelink">
		<xsl:choose>
			<xsl:when test="$test_Frontpage">
				<xsl:value-of select="concat($root, 'helpfaqs')"/>
			</xsl:when>
			<xsl:when test="/H2G2/ARTICLE/GUIDE/@ID='MUSIC'">
				<xsl:value-of select="concat($root, 'helpfaqseditorial#one')"/>
			</xsl:when>
			<xsl:when test="/H2G2/ARTICLE/GUIDE/@ID='FILM'">
				<xsl:value-of select="concat($root, 'helpfaqseditorial#one')"/>
			</xsl:when>
			<xsl:when test="/H2G2/ARTICLE/GUIDE/@ID='GOINGOUT'">
				<xsl:value-of select="concat($root, 'helpfaqseditorial#one')"/>
			</xsl:when>
			<xsl:when test="/H2G2/ARTICLE/GUIDE/@ID='STAYINGIN'">
				<xsl:value-of select="concat($root, 'helpfaqseditorial#one')"/>
			</xsl:when>
			<xsl:when test="/H2G2/ARTICLE/GUIDE/@ID='AUDIOVIDEO'">
				<xsl:value-of select="concat($root, 'helpfaqseditorial#three')"/>
			</xsl:when>
			<xsl:when test="/H2G2/ARTICLE/GUIDE/@ID='SMILEYS'">
				<xsl:value-of select="concat($root, 'faqsconversations#seven')"/>
			</xsl:when>
			<xsl:when test="/H2G2/ARTICLE/GUIDE/@ID='NEWSLETTER'">
				<xsl:value-of select="concat($root, 'faqsnewsletter')"/>
			</xsl:when>
			<xsl:when test="/H2G2/ARTICLE/GUIDE/@ID='HOUSERULES'">
				<xsl:value-of select="concat($root, 'faqsbasics#three')"/>
			</xsl:when>
			<xsl:when test="$test_UserPage">
				<xsl:value-of select="concat($root, 'faqsmyspace#one')"/>
			</xsl:when>
			<xsl:when test="$test_UserEditPage and ($test_AddHomePage or $test_EditHomePage)">
				<xsl:value-of select="concat($root, 'faqsmyspace#two')"/>
			</xsl:when>
			<xsl:when test="$test_UserEditPage and not($test_AddHomePage or $test_EditHomePage)">
				<xsl:value-of select="concat($root, 'faqsrecommendations')"/>
			</xsl:when>
			<xsl:when test="$test_UserDetailsPage">
				<xsl:value-of select="concat($root, 'faqsyouraccount#eight')"/>
			</xsl:when>
			<xsl:when test="$test_MorePagesPage">
				<xsl:value-of select="concat($root, 'faqsrecommendations')"/>
			</xsl:when>
			<xsl:when test="$test_MorePostsPage">
				<xsl:value-of select="concat($root, 'faqsconversations')"/>
			</xsl:when>
			
			<xsl:when test="$test_MultipostsPage">
				<xsl:value-of select="concat($root, 'faqsconversations')"/>
			</xsl:when>
			<xsl:when test="$test_AddThreadPage">
				<xsl:value-of select="concat($root, 'faqsconversations#five')"/>
			</xsl:when>
			<xsl:when test="$test_SearchPage">
				<xsl:value-of select="concat($root, 'faqsgettingaround#one')"/>
			</xsl:when>
			<xsl:when test="$test_CategoryPage">
				<xsl:value-of select="concat($root, 'faqsgettingaround#two')"/>
			</xsl:when>
			<xsl:when test="$test_LogoutPage">
				<xsl:value-of select="concat($root, 'faqsyouraccount#four')"/>
			</xsl:when>
			<xsl:when test="$test_RegisterPage">
				<xsl:value-of select="concat($root, 'faqsyouraccount#one')"/>
			</xsl:when>
			<xsl:when test="$test_LoginPage">
				<xsl:value-of select="concat($root, 'faqsyouraccount#four')"/>
			</xsl:when>
			<xsl:when test="$test_UserEditPage">
				<xsl:value-of select="concat($root, 'faqsrecommendations#five')"/>
			</xsl:when>
			<xsl:when test="$test_AddJournal">
				<xsl:value-of select="concat($root, 'faqsmyspace#four')"/>
			</xsl:when>
			<xsl:when test="$test_AddThreadPage">
				<xsl:value-of select="concat($root, 'faqsconversations#three')"/>
			</xsl:when>
			<xsl:when test="$test_ArticlePage">
				<xsl:value-of select="concat($root, 'faqsrecommendations')"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="concat($root, 'helpfaqs')"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="m_login2">sign in :</xsl:variable>
	<xsl:variable name="test_ancestorname" select="/H2G2/HIERARCHYDETAILS/ANCESTRY/ANCESTOR/NAME"/>
	<xsl:variable name="m_nomembers">no items</xsl:variable>
	<xsl:variable name="m_member"> item</xsl:variable>
	<xsl:variable name="m_members"> items</xsl:variable>
	<xsl:variable name="m_toptwentyupdated">all my science fiction life conversations</xsl:variable>
	<xsl:variable name="m_toptenupdatedarticles">all member reviews and pages</xsl:variable>
	<xsl:variable name="m_noconnectionerror">
			We are currently experiencing technical difficulties with the sign in/register process. 
			We are working hard to resolve this problem. Please bear with us and apologies 
			for the inconvenience caused.<br/><br/> 
			The My Science Fiction Life team.
</xsl:variable>
		<xsl:variable name="m_dnasignintext">This page has moved. Are you trying to <a href="{$sso_signinlink}" class="bluelink">sign</a> in or <a href="{$sso_registerlink}" class="bluelink">become a member</a>?</xsl:variable>
	<xsl:variable name="m_dnaregistertext">This page has moved. Are you trying to <a href="{$sso_signinlink}" class="bluelink">sign in</a> or <a href="{$sso_registerlink}" class="bluelink">become a member</a>?</xsl:variable>
<xsl:variable name="m_registernouser">If you're not a bbc.co.uk member and do not want to become one right now you can continue <a href="{$root}" class="bluelink">browsing</a>.</xsl:variable>
	<xsl:variable name="test_ElementFilter" select="/H2G2/ARTICLE/GUIDE/@TYPE='FRONTPAGE'"/>
	<xsl:variable name="test_UserIsEditor" select="/H2G2/PAGE-OWNER/USER/GROUPS/EDITOR"/>
	<xsl:variable name="test_MultiFrontpage" select="(/H2G2/ARTICLE/GUIDE/@TYPE='FRONTPAGE') or (/H2G2/@TYPE='FRONTPAGE')"/>
	<xsl:variable name="test_registerstatus" select="/H2G2/NEWREGISTER/@STATUS"/>
	<xsl:variable name="test_Frontpageeditor" select="/H2G2[@TYPE='FRONTPAGE-EDITOR']"/>
	<xsl:variable name="test_simFrontpageeditor" select="/H2G2/ARTICLE-PREVIEW/ARTICLE/GUIDE[@TYPE='FRONTPAGE']"/>
	<xsl:variable name="test_simFrontpageTopfive" select="H2G2/ARTICLE-PREVIEW/ARTICLE/GUIDE/TOP-FIVES"/>
	<xsl:variable name="test_ArticleHasTopFives" select="/H2G2/ARTICLE/GUIDE/TOP-FIVES"/>
	<!--xsl:variable name="test_FrontpageHasTopFives" select="/H2G2/ARTICLE/FRONTPAGE/TOP-FIVES"/-->
	<xsl:variable name="test_FrontpageHasTopFives" select="/H2G2/TOP-FIVES"/>
	<xsl:variable name="test_PageUserID" select="/H2G2/PAGE-OWNER/USER/USERID"/>
	<xsl:variable name="test_banner" select="/H2G2/ARTICLE/GUIDE/FURNITURE/BANNER"/>
	<xsl:variable name="test_frontpagebanner" select="/H2G2/ARTICLE/FRONTPAGE/MAIN-SECTIONS/EDITORIAL/BANNER"/>
	<xsl:variable name="test_simfrontpagebanner" select="/H2G2/ARTICLE/GUIDE/FRONTPAGE/MAIN-SECTIONS/EDITORIAL/BANNER"/>
	<xsl:variable name="test_simfrontpageeditorbanner" select="/H2G2/ARTICLE-PREVIEW/ARTICLE/GUIDE/FRONTPAGE/MAIN-SECTIONS/EDITORIAL/BANNER"/>
	<xsl:variable name="test_CollectiveSiteID" select="/H2G2/SITE-LIST/SITE[NAME='collective']/@ID"/>
	<xsl:variable name="test_UserHasPosts" select="/H2G2/RECENT-POSTS/POST-LIST/POST"/>
	<xsl:variable name="test_UserHasArticles" select="/H2G2/RECENT-ENTRIES/ARTICLE-LIST/ARTICLE"/>
	<xsl:variable name="test_UserHasCollectiveEditorial" select="/H2G2/RECENT-APPROVALS/ARTICLE-LIST/ARTICLE[SITEID=$test_CollectiveSiteID]"/>
	<xsl:variable name="test_ArticleHasConversation" select="/H2G2/ARTICLEFORUM/FORUMTHREADS/THREAD"/>
	<xsl:variable name="test_IsNotAReply" select="/H2G2/POSTTHREADFORM/@INREPLYTO='0'"/>
	<xsl:variable name="test_IsAReply" select="/H2G2/POSTTHREADFORM/INREPLYTO"/>
	<xsl:variable name="test_ArticlePreview" select="/H2G2/ARTICLE-PREVIEW"/>
	<xsl:variable name="test_Articlestatus" select="/H2G2/ARTICLES/ARTICLE-LIST/ARTICLE/STATUS"/>
	<xsl:variable name="test_ArticlePreviewSnippet" select="/H2G2/ARTICLE-PREVIEW/ARTICLE/GUIDE/FURNITURE/SNIPPET[not(@VALIGN)]"/>
	<xsl:variable name="test_Frontpage" select="/H2G2[@TYPE='FRONTPAGE']"/>
	<xsl:variable name="test_ArticlePage" select="/H2G2[@TYPE='ARTICLE']"/>
	<xsl:variable name="test_UserPage" select="/H2G2[@TYPE='USERPAGE']"/>
	<xsl:variable name="test_UserEditPage" select="/H2G2[@TYPE='USEREDIT']"/>
	<xsl:variable name="test_MultipostsPage" select="/H2G2/@TYPE='MULTIPOSTS'"/>
	<xsl:variable name="test_UserDetailsPage" select="/H2G2[@TYPE='USERDETAILS']"/>
	<xsl:variable name="test_MorePagesPage" select="/H2G2[@TYPE='MOREPAGES']"/>
	<xsl:variable name="test_MorePostsPage" select="/H2G2[@TYPE='MOREPOSTS']"/>
	<xsl:variable name="test_AddThreadPage" select="/H2G2[@TYPE='ADDTHREAD']"/>
	<xsl:variable name="test_SearchPage" select="/H2G2[@TYPE='SEARCH']"/>
	<xsl:variable name="test_CategoryPage" select="/H2G2[@TYPE='CATEGORY']"/>
	<xsl:variable name="test_LogoutPage" select="/H2G2[@TYPE='LOGOUT']"/>
	<xsl:variable name="test_AddJournal" select="/H2G2[@TYPE='ADDJOURNAL']"/>
	<xsl:variable name="test_RegisterPage" select="/H2G2[@TYPE='NEWREGISTER']/NEWREGISTER[@COMMAND='normal']"/>
	<xsl:variable name="test_LoginPage" select="/H2G2[@TYPE='NEWREGISTER']/NEWREGISTER[@COMMAND='fasttrack']"/>
	<xsl:variable name="test_UserHasOtherConvs" select="/H2G2/RECENT-POSTS/POST-LIST/POST/SITEID!=$test_CollectiveSiteID"/>
	<xsl:variable name="test_UserHasOtherArticles" select="/H2G2/RECENT-ENTRIES/ARTICLE-LIST/ARTICLE/SITEID!=$test_CollectiveSiteID"/>
	<xsl:variable name="test_OmitSite" select="/H2G2/PARAMS/PARAM/NAME[text()='s_omitsiteid']"/>
	<xsl:variable name="test_IncludeSite" select="/H2G2/PARAMS/PARAM/NAME[text()='s_includesiteid']"/>
	<xsl:variable name="test_ChangeNickname" select="/H2G2/PARAMS/PARAM/NAME[text()='s_nickname']"/>
	<xsl:variable name="test_ChangeEmail" select="/H2G2/PARAMS/PARAM/NAME[text()='s_email']"/>
	<xsl:variable name="test_ChangePassword" select="/H2G2/PARAMS/PARAM/NAME[text()='s_password']"/>
	<xsl:variable name="test_ShowSearchResultsOtherSites" select="/H2G2/PARAMS/PARAM/NAME[text()='s_displaynoncollective']"/>
	<xsl:variable name="test_SearchTerm" select="/H2G2/SEARCH/SEARCHRESULTS/SAFESEARCHTERM"/>
	<xsl:variable name="test_SearchResPrimarySite" select="/H2G2/SEARCH/SEARCHRESULTS/ARTICLERESULT[PRIMARYSITE=1]"/>
	<xsl:variable name="test_SearchResOtherSites" select="/H2G2/SEARCH/SEARCHRESULTS/ARTICLERESULT[PRIMARYSITE!=1]"/>
	<xsl:variable name="test_SearchType" select="/H2G2/SEARCH/SEARCHRESULTS/@TYPE"/>
	<xsl:variable name="test_SearchCount" select="/H2G2/SEARCH/SEARCHRESULTS/COUNT"/>
	<xsl:variable name="test_SearchSkip" select="/H2G2/SEARCH/SEARCHRESULTS/SKIP"/>
	<xsl:variable name="test_SearchMore" select="/H2G2/SEARCH/SEARCHRESULTS/MORE"/>
	<xsl:variable name="test_ArticleStatusUserEntry" select="/H2G2/ARTICLE/ARTICLEINFO/STATUS[@TYPE='3']"/>
	<xsl:variable name="test_ArticleStatusEdited" select="/H2G2/ARTICLE/ARTICLEINFO/STATUS[@TYPE='1']"/>
	<xsl:variable name="text_SubscribeToThread" select="/H2G2/SUBSCRIBE-RESULT[@TOTHREAD]"/>
	<xsl:variable name="text_UnsubscribeFromThread" select="/H2G2/SUBSCRIBE-RESULT[@FROMTHREAD]"/>
	<xsl:variable name="test_SearchWhere">
		<xsl:if test="/H2G2/SEARCH/FUNCTIONALITY/SEARCHARTICLES[SHOWAPPROVED=1]">&amp;showapproved=1</xsl:if>
		<xsl:if test="/H2G2/SEARCH/FUNCTIONALITY/SEARCHARTICLES[SHOWNORMAL=1]">&amp;shownormal=1</xsl:if>
		<xsl:if test="/H2G2/SEARCH//FUNCTIONALITY/SEARCHARTICLES[SHOWSUBMITTED=1]">&amp;showsubmitted=1</xsl:if>
	</xsl:variable>
	<xsl:variable name="test_userdetailspositivemessage" select="/H2G2/USER-DETAILS-FORM/MESSAGE[@TYPE='detailsupdated']"/>
<xsl:variable name="test_IsFromEdit" select="/H2G2/PARAMS/PARAM/NAME[text()='s_fromedit']"/>


<xsl:variable name="m_seealso">
	<xsl:choose>
	<xsl:when test="$article_type_user='member' and $article_type_group='review' or $current_article_type=1 and number(/H2G2/ARTICLE/ARTICLEINFO/STATUS/@TYPE) = 3">
	<div class="like-this"><xsl:element name="{$text.base}" use-attribute-sets="text.base"><strong>more reviews</strong></xsl:element></div>
		<div class="icon-bullet"><xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall"><a href="MA{/H2G2/ARTICLE/ARTICLEINFO/PAGEAUTHOR/EDITOR/USER/USERID}?type=4" class="article-title">more reviews by this member</a></xsl:element></div>
	<div class="icon-bullet"><xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall"><a href="C1074" class="article-title">music archive</a></xsl:element></div>
	<div class="icon-bullet"><xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall"><a href="C1073" class="article-title">film archive</a></xsl:element></div> 
	<div class="icon-bullet"><xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall"><a href="C974" class="article-title">games archive</a></xsl:element></div> 
	<div class="icon-bullet"><xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall"><a href="C54668" class="article-title">art archive</a></xsl:element></div>
	<div class="icon-bullet"><xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall"><a href="C54667" class="article-title">book archive</a></xsl:element></div>
	<div class="icon-bullet"><xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall"><a href="C970" class="article-title">comedy archive</a></xsl:element></div>
	<div class="icon-bullet"><xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall"><a href="C1075" class="article-title">more culture</a></xsl:element></div>
	</xsl:when>
	<xsl:when test="$article_subtype='music' and $article_type_group='feature'">
	<!-- On music features -->
	<div class="like-this"><xsl:element name="{$text.base}" use-attribute-sets="text.base"><strong>more music and features</strong></xsl:element></div>
		<div class="icon-bullet"><xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall"><a href="C1074" class="article-title">music archive</a></xsl:element></div>
	<div class="icon-bullet"><xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall"><a href="singles" class="article-title">this week's singles and downloads</a></xsl:element></div>
	<div class="icon-bullet"><xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall"><a href="C961" class="article-title">music interview archive</a></xsl:element></div>
	<div class="icon-bullet"><xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall"><a href="C962" class="article-title">music feature archive</a></xsl:element></div>
	<div class="icon-bullet"><xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall"><a href="C967" class="article-title">film features archive</a></xsl:element></div>
	</xsl:when>
	<xsl:when test="$article_subtype='music' and $article_type_group='interviews'">
	<!-- On music interviews -->
	<div class="like-this"><xsl:element name="{$text.base}" use-attribute-sets="text.base"><strong>more music and interviews</strong></xsl:element></div>
	<div class="icon-bullet"><xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall"><a href="C1074" class="article-title">music archive</a></xsl:element></div>
	<div class="icon-bullet"><xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall"><a href="singles" class="article-title">this week's singles and downloads</a></xsl:element></div>
	<div class="icon-bullet"><xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall"><a href="C961" class="article-title">music interview archive</a></xsl:element></div>
	<div class="icon-bullet"><xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall"><a href="C962" class="article-title">music feature archive</a></xsl:element></div>
	<div class="icon-bullet"><xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall"><a href="C966" class="article-title">film interviews archive</a></xsl:element></div>
	</xsl:when>
	<xsl:when test="$article_subtype='film' and $article_type_group='feature'">
	<!-- On film features -->
	<div class="like-this"><xsl:element name="{$text.base}" use-attribute-sets="text.base"><strong>more film and features</strong></xsl:element></div>
	<div class="icon-bullet"><xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall"><a href="C1073" class="article-title">film archive</a></xsl:element></div>
	<div class="icon-bullet"><xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall"><a href="tinseltown" class="article-title">this week's hollywood spy</a></xsl:element></div>
	<div class="icon-bullet"><xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall"><a href="C967" class="article-title">film features archive</a></xsl:element></div>
	<div class="icon-bullet"><xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall"><a href="C966" class="article-title">film interviews archive</a></xsl:element></div>
	<div class="icon-bullet"><xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall"><a href="C962" class="article-title">music feature archive</a></xsl:element></div>
	</xsl:when>
	<xsl:when test="$article_subtype='film' and $article_type_group='interviews'">
	<!-- On film interviews -->
	<div class="like-this"><xsl:element name="{$text.base}" use-attribute-sets="text.base"><strong>More film and interviews</strong></xsl:element></div>
	<div class="icon-bullet"><xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall"><a href="C1073" class="article-title">film archive</a></xsl:element></div>
	<div class="icon-bullet"><xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall"><a href="tinseltown" class="article-title">this week's hollywood spy</a></xsl:element></div>
	<div class="icon-bullet"><xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall"><a href="C966" class="article-title">film interviews archive</a></xsl:element></div>
	<div class="icon-bullet"><xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall"><a href="C967" class="article-title">film features archive</a></xsl:element></div>
	<div class="icon-bullet"><xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall"><a href="C961" class="article-title">music interviews archive</a></xsl:element></div>
	</xsl:when>
	<xsl:when test="$current_article_type=55">
	<!-- On other features -->
	<div class="like-this"><xsl:element name="{$text.base}" use-attribute-sets="text.base"><strong>more features</strong></xsl:element></div>
	<div class="icon-bullet"><xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall"><a href="C962" class="article-title">music feature archive</a></xsl:element></div>
	<div class="icon-bullet"><xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall"><a href="C967" class="article-title">film features archive </a></xsl:element></div>
	<div class="icon-bullet"><xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall"><a href="C54668" class="article-title">art archive</a></xsl:element></div>
	<div class="icon-bullet"><xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall"><a href="C54667" class="article-title">books archive</a></xsl:element></div>
	<div class="icon-bullet"><xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall"><a href="C974" class="article-title">games archive</a></xsl:element></div>
	<div class="icon-bullet"><xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall"><a href="C970" class="article-title">comedy archive</a></xsl:element></div>
	<div class="icon-bullet"><xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall"><a href="C1075" class="article-title">more culture archive</a></xsl:element></div>
	</xsl:when>
	<xsl:when test="$current_article_type=70">
	<!-- On other interviews -->
	<div class="like-this"><xsl:element name="{$text.base}" use-attribute-sets="text.base"><strong>more music and features</strong></xsl:element></div>
	<div class="icon-bullet"><xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall"><a href="C961" class="article-title">music interviews archive</a></xsl:element></div>
	<div class="icon-bullet"><xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall"><a href="C966" class="article-title">film interviews archive</a></xsl:element></div>
	<div class="icon-bullet"><xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall"><a href="C54668" class="article-title">art archive</a></xsl:element></div>
	<div class="icon-bullet"><xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall"><a href="C54667" class="article-title">books archive</a></xsl:element></div>
	<div class="icon-bullet"><xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall"><a href="C974" class="article-title">games archive</a></xsl:element></div>
	<div class="icon-bullet"><xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall"><a href="C970" class="article-title">comedy archive</a></xsl:element></div>
	<div class="icon-bullet"><xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall"><a href="C1075" class="article-title">more culture archive</a></xsl:element></div>
	</xsl:when>
	<xsl:when test="$current_article_type=87">
	<!-- On Hollywood Spy column (movie news/tinseltown) -->
	<div class="like-this"><xsl:element name="{$text.base}" use-attribute-sets="text.base"><strong>more film and columns</strong></xsl:element></div>
	<div class="icon-bullet"><xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall"><a href="C1231" class="article-title">Hollywood spy archive</a></xsl:element></div>
	<div class="icon-bullet"><xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall"><a href="C1073" class="article-title">film archive</a></xsl:element></div>
	<div class="icon-bullet"><xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall"><a href="singles" class="article-title">this week's singles and downloads</a></xsl:element></div>
	<div class="icon-bullet"><xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall"><a href="whatsontv" class="article-title">this week's what's on tv</a></xsl:element></div>
	<div class="icon-bullet"><xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall"><a href="games" class="article-title">this week's gaming</a></xsl:element></div>
	</xsl:when>
	<xsl:when test="$current_article_type=86">
	<!-- On Singles And Downloads column (singles) -->
	<div class="like-this"><xsl:element name="{$text.base}" use-attribute-sets="text.base"><strong>more music and columns</strong></xsl:element></div>
	<div class="icon-bullet"><xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall"><a href="C982" class="article-title">singles archive</a></xsl:element></div>
	<div class="icon-bullet"><xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall"><a href="C1074" class="article-title">music archive</a></xsl:element></div>
	<div class="icon-bullet"><xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall"><a href="tinseltown" class="article-title">this week's hollywood spy</a></xsl:element></div>
	<div class="icon-bullet"><xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall"><a href="whatsontv" class="article-title">this week's what's on tv </a></xsl:element></div>
	<div class="icon-bullet"><xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall"><a href="games" class="article-title">this week's gaming</a></xsl:element></div>
	</xsl:when>
	<xsl:when test="$current_article_type=88">
	<!-- On Gaming column (games) -->
	<div class="like-this"><xsl:element name="{$text.base}" use-attribute-sets="text.base"><strong>more games and columns</strong></xsl:element></div>
	<div class="icon-bullet"><xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall"><a href="C974" class="article-title">games archive</a></xsl:element></div>
	<div class="icon-bullet"><xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall"><a href="singles" class="article-title">this week's singles and downloads</a></xsl:element></div>
	<div class="icon-bullet"><xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall"><a href="tinseltown" class="article-title">this week's hollywood spy</a></xsl:element></div>
	<div class="icon-bullet"><xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall"><a href="whatsontv" class="article-title">this week's what's on tv</a></xsl:element></div>
	</xsl:when>
	<xsl:when test="$article_subtype='tv' and $article_type_group='column'">
	<!-- On What's On TV column (games) -->
	<div class="like-this"><xsl:element name="{$text.base}" use-attribute-sets="text.base"><strong>more tv and columns</strong></xsl:element></div>
	<div class="icon-bullet"><xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall"><a href="C1227" class="article-title">what's on tv archive</a></xsl:element></div>
	<div class="icon-bullet"><xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall"><a href="C1075" class="article-title">more culture archive</a></xsl:element></div>
	<div class="icon-bullet"><xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall"><a href="singles" class="article-title">this week's singles and downloads</a></xsl:element></div>
	<div class="icon-bullet"><xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall"><a href="tinseltown" class="article-title">this week's hollywood spy </a></xsl:element></div>
	<div class="icon-bullet"><xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall"><a href="games" class="article-title">this week's gaming </a></xsl:element></div>
	</xsl:when>
	<xsl:when test="$current_article_type=41">
	<!-- On editor's album reviews -->
	<div class="like-this"><xsl:element name="{$text.base}" use-attribute-sets="text.base"><strong>more music</strong></xsl:element></div>
	<div class="icon-bullet"><xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall"><a href="c1074" class="article-title">music archive</a></xsl:element></div>
	<div class="icon-bullet"><xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall"><a href="c959" class="article-title">editor's album reviews archive</a></xsl:element></div>
	<div class="icon-bullet"><xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall"><a href="c961" class="article-title">music interview archive</a></xsl:element></div>
	<div class="icon-bullet"><xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall"><a href="c962" class="article-title">music feature archive</a></xsl:element></div> 
	<div class="icon-bullet"><xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall"><a href="singles" class="article-title">this week's singles and downloads</a></xsl:element></div> 
	</xsl:when>
	<xsl:when test="$current_article_type=42 or $current_article_type=49">
	<!-- On editor's cinema AND DVD reviews -->
	<div class="like-this"><xsl:element name="{$text.base}" use-attribute-sets="text.base"><strong>more film</strong></xsl:element></div>
	<div class="icon-bullet"><xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall"><a href="C1073" class="article-title">film archive</a></xsl:element></div>
	<div class="icon-bullet"><xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall"><a href="C963" class="article-title">editor's cinema reviews archive</a></xsl:element></div>
	<div class="icon-bullet"><xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall"><a href="C963" class="article-title">editor's dvd reviews archive</a></xsl:element></div>
	<div class="icon-bullet"><xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall"><a href="C967" class="article-title">film features archive</a></xsl:element></div>
	<div class="icon-bullet"><xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall"><a href="C966" class="article-title">film interviews archive</a></xsl:element></div>
	<div class="icon-bullet"><xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall"><a href="tinseltown" class="article-title">this week's hollywood spy </a></xsl:element></div>
	</xsl:when>
	<xsl:when test="$current_article_type=43 or $current_article_type=44 or $current_article_type=47 or $current_article_type=40">
	<!-- On editor's book/art/comedy/other reviews -->
	<div class="like-this"><xsl:element name="{$text.base}" use-attribute-sets="text.base"><strong>more reviews</strong></xsl:element></div>
	<div class="icon-bullet"><xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall"><a href="C54667" class="article-title">books archive</a></xsl:element></div>
	<div class="icon-bullet"><xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall"><a href="C54668" class="article-title">art archive</a></xsl:element></div>
	<div class="icon-bullet"><xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall"><a href="C970" class="article-title">comedy archive</a></xsl:element></div>
	<div class="icon-bullet"><xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall"><a href="C974" class="article-title">game archive</a></xsl:element></div>
	<div class="icon-bullet"><xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall"><a href="C1075" class="article-title">more culture archive</a></xsl:element></div>
	</xsl:when>
	<xsl:when test="$current_article_type=45">
	<!-- On editor's game reviews -->
	<div class="like-this"><xsl:element name="{$text.base}" use-attribute-sets="text.base"><strong>more games and reviews</strong></xsl:element></div>
	<div class="icon-bullet"><xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall"><a href="games" class="article-title">this week's gaming</a></xsl:element></div>
	<div class="icon-bullet"><xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall"><a href="C54667" class="article-title">books archive</a></xsl:element></div>
	<div class="icon-bullet"><xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall"><a href="C54668" class="article-title">art archive</a></xsl:element></div>
	<div class="icon-bullet"><xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall"><a href="C970" class="article-title">comedy archive</a></xsl:element></div>
	<div class="icon-bullet"><xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall"><a href="C974" class="article-title">game archive</a></xsl:element></div>
	<div class="icon-bullet"><xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall"><a href="C1075" class="article-title">more culture archive</a></xsl:element></div>
	</xsl:when>
	<xsl:when test="$current_article_type=46">
	<!-- On editor's TV reviews -->
	<div class="like-this"><xsl:element name="{$text.base}" use-attribute-sets="text.base"><strong>more reviews</strong></xsl:element></div>
	<div class="icon-bullet"><xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall"><a href="C976" class="article-title">tv reviews</a></xsl:element></div>
	<div class="icon-bullet"><xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall"><a href="C54667" class="article-title">books archive</a></xsl:element></div>
	<div class="icon-bullet"><xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall"><a href="C54668" class="article-title">art archive </a></xsl:element></div>
	<div class="icon-bullet"><xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall"><a href="C970" class="article-title">comedy archive</a></xsl:element></div>
	<div class="icon-bullet"><xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall"><a href="C974" class="article-title">game archive</a></xsl:element></div>
	<div class="icon-bullet"><xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall"><a href="C1075" class="article-title">more culture archive</a></xsl:element></div>
	</xsl:when>
	<xsl:when test="$current_article_type=2">
	<!-- more member pages -->
	<div class="like-this"><xsl:element name="{$text.base}" use-attribute-sets="text.base"><strong>more member pages</strong></xsl:element></div>
	<div class="icon-bullet"><xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall"><a href="MA{/H2G2/ARTICLE/ARTICLEINFO/PAGEAUTHOR/EDITOR/USER/USERID}?type=4" class="article-title">more reviews by this member</a></xsl:element></div>
	<div class="icon-bullet"><xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall"><a href="browse" class="article-title">member page a-z</a></xsl:element></div>
	<div class="icon-bullet"><xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall"><a href="memberprojects" class="article-title">other member projects</a></xsl:element></div>
	<div class="icon-bullet"><xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall"><a href="community" class="article-title">community front page</a></xsl:element></div>
	<div class="icon-bullet"><xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall"><a href="essentialalbums" class="article-title">essential albums</a></xsl:element></div>
	<div class="icon-bullet"><xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall"><a href="essentialfilms" class="article-title">essential films</a></xsl:element></div>
	<div class="icon-bullet"><xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall"><a href="essentialbooks" class="article-title">essential books</a></xsl:element></div>
	<div class="icon-bullet"><xsl:element name="{$text.medsmall}" use-attribute-sets="text.medsmall"><a href="noticeboard" class="article-title">community noticeboard</a></xsl:element></div>
	</xsl:when>
	</xsl:choose>
</xsl:variable>



	<xsl:variable name="m_talkaboutthis">
	<xsl:choose>
	<!-- On ALL member reviews (selected/normal) member reviews -->
	<xsl:when test="$article_type_user='member' and $article_type_group='review'">Do you agree with this review? Share your thoughts with us.</xsl:when>
	<!-- On member pages -->
	<xsl:when test="$current_article_type=2">Have you got something to add? Share your thoughts with us.</xsl:when>
	<!-- On music features -->
	<xsl:when test="$current_article_type=56">Have you got something to add? Share your thoughts with us.</xsl:when>
	<!-- On music interviews -->
	<xsl:when test="$current_article_type=71">Have you listened to this? What did you think?</xsl:when>
	<!-- On film features -->
	<xsl:when test="$current_article_type=57">Have you got something to add? Share your thoughts with us.</xsl:when>
	<!-- On film interviews -->
	<xsl:when test="$current_article_type=72">Have you seen this film? What did you think?</xsl:when>
	<!-- On other features -->
	<xsl:when test="$current_article_type=55">Have you got something to add? Share your thoughts with us.</xsl:when>
	<!-- On other interviews -->
	<xsl:when test="$current_article_type=70">Have you got something to add? Share your thoughts with us.</xsl:when>
	<!-- On Hollywood Spy column (movie news/tinseltown) -->
	<xsl:when test="$current_article_type=87">Do you agree with Jade? Share your thoughts with us.</xsl:when>
	<!-- On Singles And Downloads column (singles) -->
	<xsl:when test="$current_article_type=86">Do you agree with Matt? Share your thoughts with us.</xsl:when>
	<!-- On Gaming column (games) -->
	<xsl:when test="$current_article_type=88">Do you agree with Daniel? Share your thoughts with us.</xsl:when>
	<!-- On What's On TV column (games) -->
	<xsl:when test="$current_article_type=89">Do you agree with Richard? Share your thoughts with us.</xsl:when>
	<!-- old -->
	<xsl:when test="$current_article_type=1">Do you agree with this review? What do you think?</xsl:when>

	</xsl:choose>
	</xsl:variable>

<!-- stuff matt added 2004-03-19 -->


<!-- columns -->
<xsl:attribute-set name="column.1">
		<xsl:attribute name="valign">top</xsl:attribute>
		<xsl:attribute name="width">410</xsl:attribute>
		<xsl:attribute name="class">page-column-1</xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="column.2">
		<xsl:attribute name="valign">top</xsl:attribute>
		<xsl:attribute name="width">190</xsl:attribute>
		<xsl:attribute name="class">page-column-2</xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="column.3">
		<xsl:attribute name="width">15</xsl:attribute>
		<xsl:attribute name="class">page-column-3</xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="column.4">
		<xsl:attribute name="valign">top</xsl:attribute>
		<xsl:attribute name="width">615</xsl:attribute>
		<xsl:attribute name="class">page-column-4</xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="column.spacer.1">
		<xsl:attribute name="width">410</xsl:attribute>
		<xsl:attribute name="height">1</xsl:attribute>
		<xsl:attribute name="border">0</xsl:attribute>
		<xsl:attribute name="src">/t/f.gif</xsl:attribute>
		<xsl:attribute name="alt"></xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="column.spacer.2">
		<xsl:attribute name="width">188</xsl:attribute>
		<xsl:attribute name="height">1</xsl:attribute>
		<xsl:attribute name="border">0</xsl:attribute>
		<xsl:attribute name="src">/t/f.gif</xsl:attribute>
		<xsl:attribute name="alt"></xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="column.spacer.3">
		<xsl:attribute name="width">15</xsl:attribute>
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


 <!-- fonts -->
 <xsl:variable name="text.heading">span</xsl:variable>
	<xsl:attribute-set name="text.heading">
		<!-- <xsl:attribute name="size">5</xsl:attribute> -->
		<xsl:attribute name="class">textbase</xsl:attribute>
	</xsl:attribute-set>
 <xsl:variable name="text.subheading">span</xsl:variable>
	<xsl:attribute-set name="text.subheading">
		<!-- <xsl:attribute name="size">4</xsl:attribute> -->
		<xsl:attribute name="class">textbase</xsl:attribute>
	</xsl:attribute-set>
 <xsl:variable name="text.base">font</xsl:variable>
	<xsl:attribute-set name="text.base">
	<!-- <xsl:attribute name="class">textbase</xsl:attribute> -->
	<xsl:attribute name="size">2</xsl:attribute>
	</xsl:attribute-set>
 <xsl:variable name="text.small">font</xsl:variable>
	<xsl:attribute-set name="text.small"><xsl:attribute name="size">1</xsl:attribute></xsl:attribute-set>

<!-- css fonts -->
 <xsl:variable name="text.medsmall">span</xsl:variable>
	<xsl:attribute-set name="text.medsmall">
		<xsl:attribute name="class">textsmall</xsl:attribute>
</xsl:attribute-set>
 <xsl:variable name="text.medheading">span</xsl:variable>
	<xsl:attribute-set name="text.medheading">
		<xsl:attribute name="class">textheading</xsl:attribute>
</xsl:attribute-set>

 <xsl:variable name="text.frontheading">span</xsl:variable>
	<xsl:attribute-set name="text.frontheading">
		<xsl:attribute name="class">frontheading</xsl:attribute>
</xsl:attribute-set>

<!-- structural things -->


<xsl:template name="box.step">
	<xsl:param name="box.step.title" />
	<xsl:param name="box.step.text" />
	<!-- -->
	<div>
	<xsl:element name="{$text.subheading}" use-attribute-sets="text.subheading"><strong><xsl:value-of select="$box.step.title" /></strong></xsl:element><br />
	<xsl:element name="{$text.base}" use-attribute-sets="text.base"><xsl:copy-of select="$box.step.text" /></xsl:element>
	</div>
</xsl:template>


<xsl:template name="box.heading">
	<xsl:param name="box.heading.value" />
	<!-- -->
	<div>
	<xsl:element name="{$text.heading}" use-attribute-sets="text.heading">
	<strong><xsl:value-of select="$box.heading.value" /></strong>
	</xsl:element>
	</div>
</xsl:template>


<xsl:template name="box.crumb">
	<xsl:param name="box.crumb.href" select="0" />
	<xsl:param name="box.crumb.value"  />
	<xsl:param name="box.crumb.title" select="0" /><!-- i.e. pass false param if crumb has +1 levels -->

	<xsl:if test="$box.crumb.href and $box.crumb.value">
		
			<a><xsl:attribute name="href"><xsl:value-of select="$box.crumb.href" /></xsl:attribute><xsl:value-of select="$box.crumb.value" /></a>&nbsp;/&nbsp;
	
	</xsl:if>
	
	<xsl:if test="$box.crumb.title">
		<strong><xsl:value-of select="$box.crumb.title" /></strong>
	</xsl:if>
</xsl:template>




<!-- sidebars etc... -->
<xsl:template name="icon.heading">
	<xsl:param name="icon.heading.icon" select="0" />
	<xsl:param name="icon.heading.text" />
	<xsl:param name="icon.heading.colour" />
	
	<div class="generic-e-{$icon.heading.colour}">	
	<xsl:if test="$icon.heading.icon"><img src="{$imagesource}icons/{$icon.heading.icon}.gif" height="21" width="20" border="0" alt="" /></xsl:if>
	<xsl:element name="{$text.subheading}" use-attribute-sets="text.subheading">
		&nbsp;<strong><xsl:value-of select="$icon.heading.text" /></strong>
	</xsl:element>	
	</div>
</xsl:template>


<xsl:template name="sidebar.box">
	<xsl:param name="sidebar.box.icon" />
	<xsl:param name="sidebar.box.title" />
	<xsl:param name="sidebar.box.text" />
	<xsl:param name="sidebar.box.link" select="0" />
	<div class="generic-g">
	 	<xsl:call-template name="icon.heading">
			<xsl:with-param name="icon.heading.icon" select="$sidebar.box.icon" />
			<xsl:with-param name="icon.heading.text" select="$sidebar.box.title" />
			<xsl:with-param name="icon.heading.colour">DA8A42</xsl:with-param>
		</xsl:call-template>
		<div class="generic-h"><xsl:element name="{$text.base}" use-attribute-sets="text.base"><xsl:copy-of select="$sidebar.box.text" /></xsl:element></div>
		<xsl:if test="$sidebar.box.link">
			<div class="generic-i">
			<xsl:element name="{$text.base}" use-attribute-sets="text.base">
				<xsl:copy-of select="$sidebar.box.link" />	
			</xsl:element>
			</div>
		</xsl:if>
	</div>
</xsl:template>

<xsl:template name="sidebar.box.full">
	<xsl:param name="sidebar.box.icon" />
	<xsl:param name="sidebar.box.title" />
	<xsl:param name="sidebar.box.text" />
	<xsl:param name="sidebar.box.link" select="0" />
	<div class="generic-j">
	
	 	<xsl:call-template name="icon.heading">
			<xsl:with-param name="icon.heading.icon" select="$sidebar.box.icon" />
			<xsl:with-param name="icon.heading.text" select="$sidebar.box.title" />
			<xsl:with-param name="icon.heading.colour">DA8A42</xsl:with-param>
		</xsl:call-template>
		<div class="generic-h"><xsl:element name="{$text.base}" use-attribute-sets="text.base"><xsl:copy-of select="$sidebar.box.text" /></xsl:element></div>
		<xsl:if test="$sidebar.box.link">
			<div class="generic-i">
			<xsl:element name="{$text.base}" use-attribute-sets="text.base">
				<xsl:copy-of select="$sidebar.box.link" />	
			</xsl:element>
			</div>
		</xsl:if>
	</div>
</xsl:template>


<xsl:template name="m_complaintpopupseriousnessproviso">This form is only for serious complaints about specific content that
breaks the site's House Rules, such as unlawful, harassing, defamatory,
abusive, threatening, harmful, obscene, profane, sexually oriented,
racially offensive, or otherwise objectionable material. 

If this comment doesn't break the <a HREF="http://www.bbc.co.uk/mysciencefictionlife/pages/houserules.shtml">house rules</a>, please reply on site. 

 

<hr/><br/>
</xsl:template>


<!-- stuff to move to config ? -->

<!-- TODO:7 -->
<xsl:template name="body.arrow">
	<xsl:param name="body.arrow.style" select="'1B3C69'" /><span class="arrow-{$body.arrow.style}"><script>document.write('&#38;#9658;');</script></span>
</xsl:template>

<!-- TODO:9 -->
<xsl:variable name="m_footerdisclaimer">
<span class="bold">Note:</span> some of the content on My Science Fiction Life is generated by members of the public. The views expressed are theirs and unless specifically stated are not those of the BBC. The BBC is not responsible for the content of any external sites referenced. 

<!-- If you consider this content to be in breach of the <a href="http://www.bbc.co.uk/mysciencefictionlife/pages/houserules.shtml">House Rules</a> please alert our moderators. -->
</xsl:variable>

<xsl:variable name="m_UserEditWarning">Please be very careful if you want to post an email address or instant messaging number, as you may receive lots of emails or messages. 
<!-- v1 See the <A xsl:use-attribute-sets="nm_usereditwarning" HREF="http://www.bbc.co.uk/mysciencefictionlife/pages/houserules.shtml">House Rules</A> for more information. -->
</xsl:variable>

<xsl:variable name="alt_contentofguideentry">Contents of your introduction
	<!-- v1 <xsl:value-of select="$m_article"/>  -->
</xsl:variable>

<!-- TODO:12 -->



<xsl:template name="form.element">
	<xsl:param name="form.element.label" />
	<xsl:param name="form.element.class" />
	<xsl:param name="form.element.sequence" />
	<xsl:param name="form.element.content" />
	<xsl:param name="form.element.eg" />
	<xsl:param name="form.element.eg.placement" />

		<div class="{$form.element.class}{$form.element.sequence}">
			<xsl:call-template name="icon.number">
				<xsl:with-param name="icon.number.image" select="concat($form.element.sequence,'_000')" />
				<xsl:with-param name="icon.number.alt" select="concat('Step',$form.element.sequence)" />
				<xsl:with-param name="icon.number.label" select="concat($form.element.class,$form.element.sequence)" />
			</xsl:call-template>
		<xsl:element name="{$text.base}" use-attribute-sets="text.base"><label for="{$form.element.class}{$form.element.sequence}"><xsl:value-of select="$form.element.label" /></label></xsl:element>
		<xsl:if test="$form.element.eg.placement='above'"><div class="{$form.element.class}copy"><xsl:element name="{$text.base}" use-attribute-sets="text.base"><xsl:value-of select="$form.element.eg" /></xsl:element></div></xsl:if>
		<xsl:copy-of select="$form.element.content" />
		<xsl:if test="$form.element.eg.placement='below'"><div class="{$form.element.class}copy"><xsl:element name="{$text.base}" use-attribute-sets="text.base"><xsl:value-of select="$form.element.eg" /></xsl:element></div></xsl:if>
		</div>	
</xsl:template>
	
	<!-- used in htmloutput for left hand navs - i think this is a duplicate of something -->
	<xsl:variable name="user_owns_page" select="/H2G2/VIEWING-USER/USER/USERID = /H2G2/PAGE-OWNER/USER/USERID" />


<!-- newusers -->
<xsl:variable name="m_NoNewerRegistrations">next</xsl:variable>
<xsl:variable name="m_NoOlderRegistrations">previous</xsl:variable>
<xsl:variable name="m_NewerRegistrations">next</xsl:variable>
<xsl:variable name="m_OlderRegistrations">previous</xsl:variable>

	<xsl:variable name="m_previousindexentries" select="$m_previous"/>
	<xsl:variable name="m_moreindexentries" select="$m_nextspace"/>


<xsl:template name="m_posthasbeenpremoderated">
<p class="info">Thank you for contribution. Your Posting will be checked by our
Moderation Team and will appear on the site once it has gone live in
early November.</p>
<!-- Thank you for posting. Your <xsl:value-of select="$m_posting"/> will be checked by our Moderation Team and will appear on the site once it has been approved. If you just started a new <xsl:value-of select="$m_thread"/>, it will only appear on your Personal Space after it has been approved. --><br/>
	<!-- chelsea add this back in please -->
	<xsl:if test="$test_IsEditor">
	<xsl:choose>
	<xsl:when test="number(@NEWCONVERSATION)=1">
	<a xsl:use-attribute-sets="nm_posthasbeenpremoderated1" href="{$root}F{@FORUM}">Click here to return to the <xsl:value-of select="$m_forum"/></a><br/>
	</xsl:when>
	<xsl:otherwise>
	<a xsl:use-attribute-sets="nm_posthasbeenpremoderated2" href="{$root}F{@FORUM}?thread={@THREAD}&amp;post={@POST}">Click here to return to the <xsl:value-of select="$m_thread"/></a><br/>
	</xsl:otherwise>
	</xsl:choose>
	</xsl:if>
</xsl:template>


</xsl:stylesheet>
