<?xml version="1.0" encoding="ISO-8859-1"?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0" 
                xmlns:msxsl="urn:schemas-microsoft-com:xslt" 
                xmlns:local="#local-functions" 
                xmlns:s="urn:schemas-microsoft-com:xml-data" 
                xmlns:dt="urn:schemas-microsoft-com:datatypes">

<xsl:attribute-set name="nm_forumownerempty" use-attribute-sets="recentpostslinks"/>
<xsl:attribute-set name="vm_journalremoved" use-attribute-sets="journallinks"/>
<xsl:attribute-set name="nm_clickhelpbrowse" use-attribute-sets="sidebarlinks"/>
<xsl:attribute-set name="nm_submitarticlefirst_text" use-attribute-sets="reviewforumlinks"/>
<xsl:variable name="categorydata">
<CATEGORISATION>
<CATBLOCK>
<CATEGORY> 
<NAME>Life</NAME> 
<CATID>72</CATID> 
<SUBCATEGORY> 
<NAME>Food &amp; Drink</NAME>
<CATID>69</CATID> 
</SUBCATEGORY> 
<SUBCATEGORY> 
<NAME>Human Behaviour</NAME>
<CATID>122</CATID> 
</SUBCATEGORY> 
<SUBCATEGORY> 
<NAME>Humour</NAME>
<CATID>120</CATID> 
</SUBCATEGORY> 
<SUBCATEGORY> 
<NAME>Music</NAME>
<CATID>90</CATID> 
</SUBCATEGORY> 
<SUBCATEGORY> 
<NAME>Sports &amp; Recreation</NAME>
<CATID>71</CATID> 
</SUBCATEGORY> 
</CATEGORY> 
<CATEGORY> 
<NAME>The Universe</NAME> 
<CATID>73</CATID> 
<SUBCATEGORY> 
<NAME>Oceania</NAME>
<CATID>50</CATID> 
</SUBCATEGORY> 
<SUBCATEGORY> 
<NAME>Asia</NAME>
<CATID>48</CATID> 
</SUBCATEGORY> 
<SUBCATEGORY> 
<NAME>Africa</NAME>
<CATID>44</CATID> 
</SUBCATEGORY> 
<SUBCATEGORY> 
<NAME>North America</NAME>
<CATID>46</CATID> 
</SUBCATEGORY> 
<SUBCATEGORY> 
<NAME>Europe</NAME>
<CATID>45</CATID> 
</SUBCATEGORY> 
<SUBCATEGORY> 
<NAME>Travel</NAME>
<CATID>83</CATID> 
</SUBCATEGORY> 
<SUBCATEGORY> 
<NAME>Transport</NAME>
<CATID>52</CATID> 
</SUBCATEGORY> 
</CATEGORY> 
<CATEGORY> 
<NAME>Everything</NAME> 
<CATID>74</CATID> 
<SUBCATEGORY> 
<NAME>Languages</NAME>
<CATID>37</CATID> 
</SUBCATEGORY> 
<SUBCATEGORY> 
<NAME>Science &amp; Technology</NAME>
<CATID>6</CATID> 
</SUBCATEGORY> 
<SUBCATEGORY> 
<NAME>History &amp; Politics</NAME>
<CATID>4</CATID> 
</SUBCATEGORY> 
<SUBCATEGORY> 
<NAME>Mythology &amp; Folklore</NAME>
<CATID>26</CATID> 
</SUBCATEGORY> 
<SUBCATEGORY> 
<NAME>All About h2g2</NAME>
<CATID>550</CATID> 
</SUBCATEGORY> 
</CATEGORY> 
</CATBLOCK>
</CATEGORISATION>
</xsl:variable>

<xsl:variable name="categoryroot">
<ROOTCAT>
<CATID>72</CATID>
<NAME>Life</NAME>
<DETAILS>
- This is where you can find <xsl:value-of select="$m_articles"/> about living, things like <SHOWCAT ID="69">Food &amp; Drink</SHOWCAT>, <SHOWCAT ID="122">Human Behaviour</SHOWCAT>, <SHOWCAT ID="120">Humour</SHOWCAT> and <SHOWCAT ID="90">Music</SHOWCAT>.
</DETAILS>
</ROOTCAT>
<ROOTCAT>
<CATID>73</CATID>
<NAME>The Universe</NAME>
<DETAILS>
- Search the whole universe, from <SHOWCAT ID="83">Travel</SHOWCAT> through to <SHOWCAT ID="46">North America</SHOWCAT>, <SHOWCAT ID="45">Europe</SHOWCAT>, <SHOWCAT ID="48">Asia</SHOWCAT>, <SHOWCAT ID="44">Africa</SHOWCAT>, <SHOWCAT ID="50">Oceania</SHOWCAT> and more.
</DETAILS>
</ROOTCAT>
<ROOTCAT>
<CATID>74</CATID>
<NAME>Everything</NAME>
<DETAILS>
- This is where everything else lives, such as <SHOWCAT ID="37">Languages &amp; Linguistics</SHOWCAT>, <SHOWCAT ID="6">Science &amp; Technology</SHOWCAT>, <SHOWCAT ID="4">History &amp; Politics</SHOWCAT>, <SHOWCAT ID="17">Cultures</SHOWCAT>, <SHOWCAT ID="20">Etiquette</SHOWCAT>, <SHOWCAT ID="26">Mythology &amp; Folklore</SHOWCAT> and <SHOWCAT ID="550">All About h2g2</SHOWCAT>.
</DETAILS>
</ROOTCAT>
</xsl:variable>

<xsl:template name="m_welcomebackuser">

Welcome back, 
<!-- <xsl:value-of select="substring(VIEWING-USER/USER/USERNAME,1,20)" /><xsl:if test="string-length(VIEWING-USER/USER/USERNAME) &gt; 20">..</xsl:if>. -->
<xsl:apply-templates select="VIEWING-USER/USER" mode="username">
	<xsl:with-param name="stringlimit">20</xsl:with-param>
</xsl:apply-templates>. 
<A xsl:use-attribute-sets="nm_welcomebackuser" HREF="{$root}Register">(Click here if this isn't you)</A>
</xsl:template>

<xsl:template name="m_welcomebackuser2line">

Welcome back, 
<!-- <xsl:value-of select="substring(VIEWING-USER/USER/USERNAME,1,20)" /><xsl:if test="string-length(VIEWING-USER/USER/USERNAME) &gt; 20">...</xsl:if> -->
<xsl:apply-templates select="VIEWING-USER/USER" mode="username">
	<xsl:with-param name="stringlimit">20</xsl:with-param>
</xsl:apply-templates>
<BR/>
<A xsl:use-attribute-sets="nm_welcomebackuser2line" HREF="{$root}Register">(Click here if this isn't you)</A>
</xsl:template>

<xsl:template name="m_registertodiscuss">
<P>If you <A xsl:use-attribute-sets="nm_registertodiscuss" HREF="{$root}register">become a member with h2g2</A> you can discuss this <xsl:value-of select="$m_article"/> with other <xsl:value-of select="$m_users"/>. You can find out more about becoming a member <A xsl:use-attribute-sets="nm_registertodiscuss" HREF="{$root}A387317">here</A>.</P>
</xsl:template>

<xsl:template name="m_journalownerfull">
<P>Welcome to your <xsl:value-of select="$m_journal"/>. <A xsl:use-attribute-sets="nm_journalownerfull" href="{$root}dontpanic-journal">Click here for more information about your <xsl:value-of select="$m_journal"/> and what you can do with it.</A></P>
</xsl:template>

<xsl:template name="m_journalownerempty">
<P>This is where any <xsl:value-of select="$m_journalpostings"/> you make will appear. <xsl:value-of select="$m_journalpostings"/> are like a diary: each <xsl:value-of select="$m_journalposting"/> is associated with a specific time, and you can use your <xsl:value-of select="$m_journal"/> to jot down thoughts and opinions as they occur to you. Other <xsl:value-of select="$m_users"/> can discuss your <xsl:value-of select="$m_journalpostings"/> and it's a great way to talk about things that aren't necessarily suited to <xsl:value-of select="$m_articlea"/> <xsl:value-of select="$m_article"/>. <A xsl:use-attribute-sets="nm_journalownerempty" href="{$root}dontpanic-journal">Click here for more information about your <xsl:value-of select="$m_journal"/> and what you can do with it</A>, or <A xsl:use-attribute-sets="nm_journalownerempty" href="{$root}postjournal">Click here to add a new <xsl:value-of select="$m_journalposting"/>.</A></P>
</xsl:template>

<xsl:template name="m_journalviewerempty">
<P>This is where any <xsl:value-of select="$m_journalpostings"/> would appear, if this <xsl:value-of select="$m_user"/> had made any. Unfortunately they haven't managed to write anything, which is a shame because their <xsl:value-of select="$m_journal"/> is where they could tell everyone what they've been up to. Is your <xsl:value-of select="$m_journal"/> empty too? If so, this is how it'll appear to other <xsl:value-of select="$m_users"/> who visit your Personal Space.</P>
</xsl:template>

<xsl:template name="m_journalviewerfull">
<P>Welcome to this <xsl:value-of select="$m_user"/>'s <xsl:value-of select="$m_journal"/>. If you'd like to comment on anything they have written here, just click the relevant 'Discuss this Entry' button.</P>
</xsl:template>

<xsl:template name="m_artownerfull">
<P>This is a list of the most recent <xsl:value-of select="$m_articles"/> you have created. <a xsl:use-attribute-sets="nm_artownerfull" href="{$root}dontpanic-entries">Click here for more information about <xsl:value-of select="$m_articles"/>.</a></P>
</xsl:template>

<xsl:template name="m_artownerempty">
<P>Whenever you write <xsl:value-of select="$m_articlea"/> <xsl:value-of select="$m_article"/> it will appear here, and if you ever want to edit one of your <xsl:value-of select="$m_articles"/> you can do so simply by clicking on the 'Edit' link. Any <xsl:value-of select="$m_articles"/> you create are automatically added to the Guide and will appear in search results. <A xsl:use-attribute-sets="nm_artownerempty" href="{$root}dontpanic-entries">Click here for more information about <xsl:value-of select="$m_articles"/></A>, or <A xsl:use-attribute-sets="nm_artownerempty" href="{$root}useredit">click here if you want to get writing straight away.</A></P>
</xsl:template>

<xsl:template name="m_artviewerfull">
<P>These are all the <xsl:value-of select="$m_articles"/> this <xsl:value-of select="$m_user"/> has created. If you'd like to read them, click on the link, and if you want to talk about them, use the 'Discuss this Entry' button when you get there.</P>
</xsl:template>

<xsl:template name="m_artviewerempty">
<P>When this <xsl:value-of select="$m_user"/> writes some <xsl:value-of select="$m_articles"/> they will appear here, but they haven't got round to it yet. We're sure they will soon...</P>
</xsl:template>

<xsl:template name="m_editownerfull">
<P>This is a list of <xsl:value-of select="$m_editedarticles"/> to which you have contributed. <a xsl:use-attribute-sets="nm_editownerfull" href="{$root}writing-guidelines">Click here if you want to know what sort of thing the Editors are looking for</a>, or <a xsl:use-attribute-sets="nm_editownerfull" href="{$root}dontpanic-contrib">click here for more information about <xsl:value-of select="$m_editedarticles"/> and the editorial process.</a></P>
</xsl:template>

<xsl:template name="m_editownerempty">
<P>If one of your <xsl:value-of select="$m_articles"/> has been recommended for the <xsl:value-of select="$m_editedguide"/> and the Editors have given it their stamp of approval or have used a part of it in <xsl:value-of select="$m_editedarticlea"/> <xsl:value-of select="$m_editedarticle"/>, then the details will appear here. <A xsl:use-attribute-sets="nm_editownerempty" href="{$root}writing-guidelines">Click here if you want to know what sort of thing the Editors are looking for</A>, or <A xsl:use-attribute-sets="nm_editownerempty" href="{$root}dontpanic-editing">click here for more information about <xsl:value-of select="$m_editedarticles"/> and the editorial process.</A></P>
</xsl:template>

<xsl:template name="m_editviewerfull">
<P>These are all the <xsl:value-of select="$m_editedarticles"/> to which this <xsl:value-of select="$m_user"/> has contributed. They obviously read the <A xsl:use-attribute-sets="nm_editviewerfull" href="{$root}writing-guidelines">Writing Guidelines</A> and submitted their <xsl:value-of select="$m_articles"/> to <a xsl:use-attribute-sets="nm_editviewerfull" href="{$root}PeerReview">Peer Review</a>: why don't you too?</P>
</xsl:template>

<xsl:template name="m_editviewerempty">
<P>This <xsl:value-of select="$m_user"/> hasn't had any <xsl:value-of select="$m_articles"/> picked for editing, yet... but we're sure they soon will.</P>
</xsl:template>

<xsl:variable name="m_journalintroUI">
	<xsl:copy-of select="$m_journalintro"/>
</xsl:variable>

<xsl:variable name="m_journalintro">
<P>We all lead interesting lives, and your <xsl:value-of select="$m_journal"/> is the place to tell everyone exactly what makes your days buzz by. Here you can talk about what you're thinking of doing, what you think about what you're thinking of doing, and when you're thinking of doing it, because, unlike <xsl:value-of select="$m_articles"/>, <xsl:value-of select="$m_journalpostings"/> are associated with specific points in time.</P>
<P>Think of your <xsl:value-of select="$m_journal"/> as your personal diary. If you want to preserve your writing in a more permanent format you might like to create <xsl:value-of select="$m_articlea"/> <xsl:value-of select="$m_article"/>, but remember that everything you write is always part of the Guide, and other visitors to your page can still read what you've said, and discuss it.</P>
</xsl:variable>

<xsl:template name="m_pserrorowner">

<P>Unfortunately the Introduction to your Personal Space cannot be displayed fully due to errors in the GuideML. Click <a xsl:use-attribute-sets="nm_pserrorowner" href="{$root}UserEdit?masthead=1">here</a> to edit this page, and then select 'Preview'; the errors will then be highlighted for you.</P>
</xsl:template>

<xsl:template name="m_pserrorviewer">
<P>Unfortunately this <xsl:value-of select="$m_user"/>'s Introduction cannot be displayed fully due to errors in the GuideML they've used.</P>
</xsl:template>

<xsl:template name="m_psintroowner">
<P>This is your Personal Space, the most useful page you could ever hope for. It's where people can come along and find out all about you, and it's also where you can write <xsl:value-of select="$m_articles"/>, keep track of your <xsl:value-of select="$m_threads"/>, update your <xsl:value-of select="$m_journal"/> and change your preferences. It is basically your personal nerve centre on h2g2.</P>
<P>You can get to this page at any time by clicking on the 'My Space' button.</P>
<P>One of the first things you'll want to do is set up your preferences, which you can do by clicking on the 'Preferences' button. That's where you can change your Nickname so you're no longer known as just another number.</P>
<P>You should also replace this text with something a bit more individual and entertaining to visitors, by clicking on the 'Edit Page' button and typing in your own Introduction. If you don't do this then visitors to your Personal Space will not be able to leave messages, so it's a good thing to do straight away.</P>
<P>If you want to find out all about your Personal Space, <a xsl:use-attribute-sets="nm_psintroowner" href="{$root}dontpanic-space">you can find lots of lovely information here</a>. And remember, you can get here at any time by clicking on the 'My Space' button.</P>
</xsl:template>

<xsl:template name="m_psintroviewer">
<P>This is the Personal Space of <xsl:apply-templates select="/H2G2/PAGE-OWNER/USER" mode="username" />. Unfortunately <xsl:apply-templates select="/H2G2/PAGE-OWNER/USER" mode="username" /> doesn't seem to have found the time to write anything by way of an introduction yet, but hopefully that will soon change.</P>
<P>By the way, if you've become a member but haven't yet written an Introduction to <I>your</I> Personal Space, then this is what your Space looks like to visitors (and, in the same way that you can't leave a message here for this <xsl:value-of select="$m_user"/>, others won't be able to leave messages for you on your Space). You can change this by clicking on the 'My Space' button, going to your Space, clicking on the 'Edit Page' button, and entering your own Introduction - it's highly recommended!</P>
</xsl:template>

<xsl:template name="m_forumownerempty">
<P>This section will display details of any <xsl:value-of select="$m_postings"/> you make to h2g2 <xsl:value-of select="$m_threads"/>. This is really useful: by checking out this section you can keep track of <xsl:value-of select="$m_threads"/> you are involved in and can see if anyone has replied to your <xsl:value-of select="$m_postings"/>, and when. <A xsl:use-attribute-sets="nm_forumownerempty" href="{$root}dontpanic-forums">Click here for more information about h2g2 <xsl:value-of select="$m_threads"/> and how to get the best from them.</A></P>
</xsl:template>

<xsl:template name="m_forumviewerfull">
<!-- <P>Here are the details of the latest <xsl:value-of select="$m_postings"/> this <xsl:value-of select="$m_user"/> has made. Feel free to check out what they've posted and join in yourself.</P> -->
</xsl:template>

<xsl:template name="m_forumownerfull">
<!-- <P>Here are the details of the latest <xsl:value-of select="$m_postings"/> you've made. href="/dontpanic-forums">Click here for more information about h2g2 Forums and how to get the best from them.</P> -->
</xsl:template>

<xsl:template name="m_forumviewerempty">
<P>This section will display details of any <xsl:value-of select="$m_postings"/> this <xsl:value-of select="$m_user"/> makes, when they get around to talking to the rest of the Community. <xsl:value-of select="$m_threads"/> are really fun and are the best way to meet people, as well as the best way to get people to visit your own Personal Space, so let's hope they join in soon.</P>
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

<a xsl:use-attribute-sets="nm_copyright2" href="/copyright"><xsl:text disable-output-escaping="yes">&amp;copy; </xsl:text>BBC MMIV</a>
</xsl:template>

<xsl:template name="m_registerslug">

<B><FONT SIZE="3">Add <I>your</I> Opinion!</FONT></B>
<P><B>There are tens of thousands of h2g2 <xsl:value-of select="$m_articles"/>, written by our <xsl:value-of select="$m_users"/>. If you want to be able to add your own opinions to the Guide, simply <a xsl:use-attribute-sets="nm_registerslug" href="{$root}Register">become a member</a> as an h2g2 <xsl:value-of select="$m_user"/>. <a xsl:use-attribute-sets="nm_registerslug" href="{$root}A387317">Tell me More!</a></B></P>
</xsl:template>

<xsl:template name="m_recommendtext">

<P>If you're not content to have created <xsl:value-of select="$m_articlea"/> <xsl:value-of select="$m_article"/> that's accessible to anyone using the h2g2 search engine, why not take that extra step and put it up for Peer Review, for possible inclusion in the <xsl:value-of select="$m_editedguide"/>? You can find out how to do this at the <a xsl:use-attribute-sets="nm_recommendtext" href="{$root}PeerReview">Peer Review Page</a>.</P> </xsl:template>

<xsl:template name="m_entryexists">
<P>The <xsl:value-of select="$m_article"/> number you asked for doesn't exist.<br/>
Perhaps you mistyped it?</P>
</xsl:template>

<xsl:template name="m_possiblealternatives">
<P>Here are some possible <xsl:value-of select="$m_articles"/> it could be:</P>
</xsl:template>

<xsl:template name="m_cantpostnotregistered">
<P>We're sorry, but you can't post to <xsl:value-of select="$m_threada"/> <xsl:value-of select="$m_thread"/> until you've logged in to h2g2.</P>
<UL>
<LI><P>If you already have an h2g2 account, please <a xsl:use-attribute-sets="nm_cantpostnotregistered1" href="{$sso_nopostsigninlink}">click here to sign in</a>.</P></LI>
<LI><P>If you haven't already become a member with us as <xsl:value-of select="$m_usera"/> <xsl:value-of select="$m_user"/>, please <A xsl:use-attribute-sets="nm_cantpostnotregistered2" href="{$sso_nopostregisterlink}">click here to become a member</A>. Becoming a member is free and will enable you to share your wisdom with the rest of the h2g2 Community. <a xsl:use-attribute-sets="nm_cantpostnotregistered3" href="A387317">Tell me more!</a>.</P></LI>
</UL>
<P>Alternatively, <A xsl:use-attribute-sets="nm_cantpostnotregistered4"><xsl:attribute name="href"><xsl:value-of select="$root"/>F<xsl:value-of select="@FORUMID"/>?thread=<xsl:value-of select="@THREADID"/>&amp;post=<xsl:value-of select="@POSTID"/>#p<xsl:value-of select="@POSTID"/></xsl:attribute>click here to return to the <xsl:value-of select="$m_thread"/> without logging in</A>.</P>
</xsl:template>

<xsl:template name="m_cantpostnoterms">
<P>We're sorry, but you can't post to <xsl:value-of select="$m_threada"/> <xsl:value-of select="$m_thread"/> until you've agreed with our specific terms of use. <A xsl:use-attribute-sets="nm_cantpostnoterms1" href="{$root}LoginTerms?pa=postforum&amp;pt=forum&amp;forum={@FORUMID}&amp;pt=thread&amp;thread={@THREADID}&amp;pt=post&amp;post={@POSTID}">Click here to complete your membership</A> - then you'll be able to share your wisdom with the rest of the h2g2 Community. <a xsl:use-attribute-sets="nm_cantpostnoterms2" href="A387317">Tell me more!</a>.</P>
<P>Alternatively, <A xsl:use-attribute-sets="nm_cantpostnoterms3"><xsl:attribute name="href"><xsl:value-of select="$root"/>F<xsl:value-of select="@FORUMID"/>?thread=<xsl:value-of select="@THREADID"/>&amp;post=<xsl:value-of select="@POSTID"/></xsl:attribute>click here to return to the <xsl:value-of select="$m_thread"/> without logging in</A>.</P>
</xsl:template>

<xsl:template name="m_clickhelpbrowse">
<A xsl:use-attribute-sets="nm_clickhelpbrowse" HREF="{$root}DontPanic-Explore">Click here</A> for help on browsing the Guide
</xsl:template>

<xsl:template name="m_regnewemail">
<P>We've just sent you an email that you'll need to read before your registration is complete... go and check your mail!</P>
<P>In the meantime, please feel free to continue exploring the Guide.</P>
<P>To return to the front page at any time, simply click on the h2g2 logo at the top left of the page, or the 'Front Page' button above.</P>
</xsl:template>

<xsl:template name="m_regwaittransfer">
<P>Please wait while you are transferred to your Personal Space. 
<A xsl:use-attribute-sets="nm_regwaittransfer" href="{$root}U{NEWREGISTER/USERID}">Click here</A> if nothing happens after a few seconds.</P>
</xsl:template>

<xsl:template name="m_regoldemail">
<P>You've already become a member with us, but it looks like you've logged out, or you're using a different browser or computer.</P>
<P>We've sent you an email, which will allow you to reset your password to something you can remember.</P>
</xsl:template>

<xsl:template name="m_regalready">
<P>You're already become a member with us as <xsl:value-of select="REGISTER/EMAILADDRESS"/>, so you probably want to go to your <a xsl:use-attribute-sets="nm_regalready1" href="{$root}U{VIEWING-USER/USER/USERID}">Personal Space</a>.</P>
<P>However, if you are trying to set a password for this account so that you can sign in from any computer, then you can do so by changing your <a xsl:use-attribute-sets="nm_regalready2" href="{$root}UserDetails">Preferences</a>.</P>
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
<P>To become an h2g2 <xsl:value-of select="$m_user"/> all you need to do is to enter your email address in the field below and press the 'Become a member' button. It's free, there's no obligation, and we promise not to give away your email address to anyone else. <a xsl:use-attribute-sets="nm_registrationblurb" href="A387317">Tell me More!</a></P>
</xsl:template>

<xsl:template name="m_loginblurb">

<P>If your email address is already registered, and you have set up a password, enter them both below to sign in instantly wherever you are. If you can't remember what your password is, 
<xsl:choose>
<xsl:when test="REGISTER/EMAILADDRESS">
<a xsl:use-attribute-sets="nm_loginblurb" href="{$root}Register?email={REGISTER/EMAILADDRESS}&amp;cmd=withpassword">click here</a> and we'll email you instructions on how to change your password.
</xsl:when>
<xsl:otherwise> just leave the password blank and we'll email you instructions on how to change your password.</xsl:otherwise>
</xsl:choose>
</P>
</xsl:template>

<xsl:template name="m_passwordintro">

Please enter your password to sign in to h2g2. If you can't remember your password,
<xsl:choose>
<xsl:when test="REGISTER/EMAILADDRESS">
<a xsl:use-attribute-sets="nm_passwordintro" href="{$root}Register?email={REGISTER/EMAILADDRESS}&amp;cmd=withpassword">click here</a> and we'll email you instructions on how to change your password.
</xsl:when>
<xsl:otherwise> just leave the password blank and we'll email you instructions on how to change your password.</xsl:otherwise>
</xsl:choose>
</xsl:template>

<xsl:template name="m_logoutblurb">
<P>You have just logged out of h2g2. The next time you visit on this computer we won't automatically recognise you.</P>
<P>To sign in again, click on the 'Sign in' button in the left-hand margin.</P>
</xsl:template>

<xsl:template name="m_logoutblurb2">
<P>You have just logged out of h2g2. The next time you visit on this computer we won't automatically recognise you.</P>
<P>To sign in again, click on the orange 'Sign in' button at the top of this screen.</P>
</xsl:template>

<xsl:template name="m_regconfirmation">

<P>Thank you for becoming an official <xsl:value-of select="$m_user"/> for h2g2: we do hope you enjoy contributing to the Guide.</P>
<P>Please wait while you are transferred to <A xsl:use-attribute-sets="nm_regconfirmation" HREF="{$root}U{REGISTERING-USER/USER/USERID}"> your Personal Space </A>... or click the link if nothing happens.</P>
</xsl:template>

<xsl:template name="m_NewUsersListingHeading">
<xsl:value-of select="$m_users"/> who have joined in the last
<xsl:if test="number(@TIMEUNITS) &gt; 1"><xsl:text> </xsl:text><xsl:value-of select="@TIMEUNITS"/></xsl:if>
<xsl:text> </xsl:text><xsl:value-of select="@UNITTYPE"/><xsl:if test="number(@TIMEUNITS) &gt; 1">s</xsl:if>:<br/><br/>
</xsl:template>

<xsl:template name="m_NewUsersListingEmpty">
No new <xsl:value-of select="$m_users"/> have joined h2g2 in the last
<xsl:if test="number(@TIMEUNITS) &gt; 1"><xsl:text> </xsl:text><xsl:value-of select="@TIMEUNITS"/></xsl:if>
<xsl:text> </xsl:text><xsl:value-of select="@UNITTYPE"/><xsl:if test="number(@TIMEUNITS) &gt; 1">s</xsl:if>.<br/><br/>
</xsl:template>

<xsl:template name="m_notcancelled">
<P>You have chosen <I>not</I> to cancel the account. <a xsl:use-attribute-sets="nm_notcancelled" href="{$root}U{REGISTER/USERID}">Click here to go to the Personal Space for this account.</a></P>
</xsl:template>

<xsl:template name="m_accountcancelled">
<P>The account has now been cancelled.</P>
</xsl:template>

<xsl:template name="m_abouttocancelaccount">
<P>You are about to cancel the h2g2 account for <xsl:value-of select="$m_user"/> number <xsl:value-of select="REGISTER/USERID"/>. This will remove any personal details from this account (including the email address) and de-activate it, meaning it can no longer be used. Any <xsl:value-of select="$m_postings"/> and <xsl:value-of select="$m_articles"/> created by this account will remain in the Guide, but if you cancel this account they will no longer be editable.</P>
<P>If you want to see what this <xsl:value-of select="$m_user"/> has said in the Guide, <A xsl:use-attribute-sets="nm_abouttocancelaccount" HREF="{$root}U{REGISTER/USERID}" TARGET="_blank">click here</A> to view their Personal Space in a new window.</P>
<P>If you're sure you wish to cancel this account, and remove the email address from h2g2, click the button marked 'YES'. If you wish to leave it alone, click on the button marked 'NO'.</P>
</xsl:template>

<xsl:template name="m_sorryrejectedterms">
<P>We're sorry you chose not to join h2g2, but thanks for your time.</P>
<P><a xsl:use-attribute-sets="nm_sorryrejectedterms" href="{$root}Register?email={REGISTER/EMAILADDRESS}">Click here if you've changed your mind and want to accept the terms</a>.</P>
</xsl:template>

<xsl:template name="m_terms"><!-- Old Terms and Conditions went here --></xsl:template>

<xsl:template name="m_acceptblurb">
<P>Please read the following terms of use. Ticking the 'I agree to these terms' check box indicates your acceptance of these terms.</P>
</xsl:template>

<xsl:template name="m_termsforregistered">
<P>You have already become a member with h2g2, but perhaps you have forgotten your password. Simply type in a new password (twice to prevent mistyping) and press the 'Change password and Sign In' button to change your password and sign in.</P>
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

<P>The person you have nominated is already a member of h2g2. <a xsl:use-attribute-sets="nm_sharealreadyjoined" href="{$root}U{SHAREANDENJOY/USERID}">Click here to visit their Personal Space.</a></P>
</xsl:template>

<xsl:template name="m_sharealreadyasked">
<P>The person you have nominated has already been asked to join but hasn't completed their registration. Hopefully they soon will!</P>
</xsl:template>

<xsl:template name="m_shareunregistered">
<P>Only members of h2g2 can invite other people to join. <a xsl:use-attribute-sets="nm_shareunregistered" href="{$root}Register">Click here to become a member with h2g2.</a></P>
</xsl:template>

<xsl:template name="m_sharesuccess">
<P>We've just sent an email to your friend inviting them to join you at h2g2. <a xsl:use-attribute-sets="nm_sharesuccess" href="{$root}U{SHAREANDENJOY/USERID}">Click here to go to their Personal Space.</a> Why not check up on them in a day or so to see if they have completed their registration?</P>
</xsl:template>

<xsl:template name="m_regwaitwelcomepage">
<P>Your registration has been completed. Please wait while we transfer you to the Welcome Page
or <a xsl:use-attribute-sets="nm_regwaitwelcomepage" href="{$root}Welcome">click here</a> if nothing happens after a few seconds.</P>
</xsl:template>

<xsl:template name="m_shareandenjoyintro">
<P>If you've got friends who you think would enjoy becoming h2g2 <xsl:value-of select="$m_users"/>, then you can save them the effort of becoming a member by sending them a special 'Share and Enjoy' invitation!</P>
<P>Simply enter their email address below and a welcome message, and we'll take care of the rest. They'll get a personalised email containing a special fast-track registration link, and a link to your Personal Space so they can let you know when they've joined.</P>
<P>Don't be a party-pooper - bring a friend!</P>
</xsl:template>

<xsl:template name="m_illegaltext">This text cannot be displayed because it contains illegal scripting.</xsl:template>
<xsl:template name="m_scriptremoved">This script section has been removed for security reasons.</xsl:template>

<xsl:template name="m_entrysidebarcomplaint">
<xsl:variable name="URL">
	<xsl:choose>
		<xsl:when test="number(/H2G2/ARTICLE/ARTICLEINFO/H2G2ID) > 0">'/dna/<xsl:value-of select="/H2G2/CURRENTSITEURLNAME"/>/comments/UserComplaintPage?s_start=1&amp;h2g2ID=<xsl:value-of select="/H2G2/ARTICLE/ARTICLEINFO/H2G2ID"/>'</xsl:when>
		<xsl:otherwise>'/dna/<xsl:value-of select="/H2G2/CURRENTSITEURLNAME"/>/comments/UserComplaintPage?s_start=1&amp;URL=' + escape(window.location.href)</xsl:otherwise>
	</xsl:choose>
</xsl:variable>
<font xsl:use-attribute-sets="mainfont" size="1">
Most of the content on this site is created by h2g2's <xsl:value-of select="$m_users"/>, who are members of the public. 
The views expressed are theirs and unless specifically stated are not those of the BBC. The BBC 
is not responsible for the content of any external sites referenced. In the event that you consider anything 
on this page to be in breach of the site's <A xsl:use-attribute-sets="nm_entrysidebarcomplaint1" HREF="{$root}HouseRules">House Rules</A>, 
please <a xsl:use-attribute-sets="nm_entrysidebarcomplaint2"><xsl:attribute name="href">javascript:popupwindow(<xsl:value-of select="$URL"/>, 'ComplaintPopup', 'status=1,resizable=1,scrollbars=1,width=640,height=480')</xsl:attribute>click here</a> to alert our Moderation Team. For any other comments, please start <xsl:value-of select="$m_threada"/> <xsl:value-of select="$m_thread"/> below.
</font>
</xsl:template>

<xsl:template name="m_pagebottomcomplaint">
<font xsl:use-attribute-sets="mainfont" size="1">
Most of the content on h2g2 is created by h2g2's <xsl:value-of select="$m_users"/>, who are members of the public. The views expressed are theirs and unless specifically stated are not those of the BBC. The BBC is not responsible for the content of any external sites referenced. In the event that you consider anything on this page to be in breach of the site's <A xsl:use-attribute-sets="nm_pagebottomcomplaint1" HREF="{$root}HouseRules">House Rules</A>, please
<a xsl:use-attribute-sets="nm_pagebottomcomplaint2">
	<xsl:attribute name="href">
		<xsl:text>javascript:popupwindow(</xsl:text>
		<xsl:choose>
			<xsl:when test="/H2G2/@TYPE='ARTICLE' or /H2G2/@TYPE='USERPAGE'">'/dna/<xsl:value-of select="/H2G2/CURRENTSITEURLNAME"/>/comments/UserComplaintPage?s_start=1&amp;h2g2ID=<xsl:value-of select="/H2G2/ARTICLE/ARTICLEINFO/H2G2ID"/>'</xsl:when>
			<xsl:otherwise>'/dna/<xsl:value-of select="/H2G2/CURRENTSITEURLNAME"/>/comments/UserComplaintPage?s_start=1&amp;URL=' + escape(window.location.href)</xsl:otherwise>
		</xsl:choose>
		<xsl:text>, 'ComplaintPopup', 'status=1,resizable=1,scrollbars=1,width=640,height=480')</xsl:text>
	</xsl:attribute>click here</a>. 
For any other comments, please 
<xsl:choose>
	<xsl:when test="/H2G2/@TYPE='ARTICLE' or /H2G2/@TYPE='USERPAGE'">start <xsl:value-of select="$m_threada"/> <xsl:value-of select="$m_thread"/> above</xsl:when>
	<xsl:otherwise>click on the Feedback button above</xsl:otherwise>
</xsl:choose>.
</font>
</xsl:template>

  <xsl:template name="m_pagebottomarticledisclaimer">
        <font xsl:use-attribute-sets="mainfont" size="1">
          The content on h2g2 is created by h2g2's <xsl:value-of select="$m_users"/>, who are members of the public. Unlike Edited Guide Entries, the content on this page has not necessarily been checked by a BBC editor. If you feel this page could be improved, why not join the community and edit the page or start a conversation? In the event that you consider anything on this page to be in breach of the site's <A xsl:use-attribute-sets="nm_entrysidebarcomplaint1" HREF="{$root}HouseRules">House Rules</A>, please
          <a xsl:use-attribute-sets="nm_pagebottomcomplaint2">
          <xsl:attribute name="href">
            <xsl:text>javascript:popupwindow(</xsl:text>
            '/dna/<xsl:value-of select="/H2G2/CURRENTSITEURLNAME"/>/comments/UserComplaintPage?s_start=1&amp;h2g2ID=<xsl:value-of select="/H2G2/ARTICLE/ARTICLEINFO/H2G2ID"/>'
            <xsl:text>, 'ComplaintPopup', 'status=1,resizable=1,scrollbars=1,width=640,height=480')</xsl:text>
          </xsl:attribute>click here
        </a>.
      </font>
  </xsl:template>

<xsl:template name="m_forumpostingsdisclaimer">

<font xsl:use-attribute-sets="mainfont" size="1">Most of the content on h2g2 is created by h2g2's <xsl:value-of select="$m_users"/>, who are members of the public. The views expressed are theirs and unless specifically stated are not those of the BBC. The BBC is not responsible for the content of any external sites referenced. In the event that you consider anything on this page to be in breach of the site's <A xsl:use-attribute-sets="nm_forumpostingsdisclaimer" TARGET="_top" HREF="{$root}HouseRules">House Rules</A>, please click on the relevant <img src="{$imagesource}buttons/complain.gif" border="0"/> button to alert our Moderation Team.</font>
</xsl:template>

<xsl:template name="m_articlecomplaintdescription">
Fill in this form to register a complaint about the <xsl:value-of select="$m_article"/> '<xsl:value-of select="USER-COMPLAINT-FORM/SUBJECT"/>', edited by <xsl:apply-templates select="USER-COMPLAINT-FORM/AUTHOR/USER"/>.
</xsl:template>

<xsl:template name="m_postingcomplaintdescription">
Fill in this form to register a complaint about the <xsl:value-of select="$m_posting"/> '<xsl:value-of select="USER-COMPLAINT-FORM/SUBJECT"/>', written by <xsl:apply-templates select="USER-COMPLAINT-FORM/AUTHOR/USER"/>.
</xsl:template>

<xsl:template name="m_generalcomplaintdescription">Register a complaint about the content of this page.</xsl:template>

<xsl:template name="m_complaintpopupseriousnessproviso">
This form is only for serious complaints about specific content on h2g2 that breaks the site's <A xsl:use-attribute-sets="nm_complaintpopupseriousnessproviso" HREF="{$root}HouseRules">House Rules</A>, such as unlawful, harassing, defamatory, abusive, threatening, harmful, obscene, profane, sexually oriented, racially offensive, or otherwise objectionable material.
<br/><xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text><br/>
For general comments please post to the relevant <xsl:value-of select="$m_thread"/> on h2g2, or the <a xsl:use-attribute-sets="nm_complaintpopupseriousnessproviso" target="_blank" href="{$root}Feedback">Feedback Forum</a> for general feedback.
<hr/><br/>
</xsl:template>

<xsl:template name="m_complaintpopupemailaddresslabel">Please enter your email address here, so we can contact you with details of the action taken:<br/></xsl:template>

<xsl:template name="m_returninguserblurb">
<P>This is where you can reactivate your pre-BBC h2g2 account. If you have already reactivated your h2g2 account, then please <A xsl:use-attribute-sets="nm_returninguserblurb1" HREF="{$root}Login">sign in here</A>. Please note you need to have cookies enabled in your browser for this to work. If you have problems, then please email <A xsl:use-attribute-sets="nm_returninguserblurb2" HREF="mailto:h2g2.support@bbc.co.uk">h2g2.support@bbc.co.uk</A> with as many details as you can give us, and we'll get back to you as soon as we can.</P>
<P>To reactivate your h2g2 account you'll have to create a new BBC member name and password which you can then use to sign in to your existing h2g2 account. <B>Both the BBC member name and password must be at least six characters long, can only contain letters and numbers, and are case sensitive.</B> In other words:</P>
<P>If you already have a BBC account (but not an h2g2 one), then you should enter the details for that account below to avoid creating a new BBC account.</P>
<P>To reactivate your account, all you need to do is fill in the form below. <B>Both the BBC member name and password must be at least six characters long, can only contain letters and numbers, and are case sensitive.</B> Don't worry if your preferred BBC member name is already taken - you'll only use it to sign in, and it won't be shown on site. Finally, don't forget to agree to the site's <A xsl:use-attribute-sets="nm_returninguserblurb3" HREF="{$root}HouseRules">House Rules</A> and <A xsl:use-attribute-sets="nm_returninguserblurb4" HREF="http://www.bbc.co.uk/copyright">Terms of use</A> by ticking the box below.</P>
</xsl:template>

<xsl:template name="m_bbcregblurb">
<P>This is where you can become a member of h2g2. If you already have an h2g2 account, then please <A xsl:use-attribute-sets="nm_bbcregblurb1"><xsl:call-template name="regpassthroughhref"><xsl:with-param name="url">Login</xsl:with-param></xsl:call-template>sign in here</A>. Please note you need to have cookies enabled in your browser for this to work. If you have problems, then please email <A xsl:use-attribute-sets="nm_bbcregblurb1" HREF="mailto:h2g2.support@bbc.co.uk">h2g2.support@bbc.co.uk</A> with as many details as you can give us, and we'll get back to you as soon as we can.</P>
<P>If you already have a BBC account (but not an h2g2 one), then you should enter the details for that account below to avoid creating a new BBC account.</P>
<P>To become a member, all you need to do is fill in the form below. <B>Both the BBC member name and password must be at least six characters long, can only contain letters and numbers, and are case sensitive.</B> Finally, don't forget to agree to the site's <A xsl:use-attribute-sets="nm_bbcregblurb2" HREF="{$root}HouseRules">House Rules</A> and <A xsl:use-attribute-sets="nm_bbcregblurb3" HREF="http://www.bbc.co.uk/copyright">Terms of use</A> by ticking the box below.</P>
</xsl:template>

<xsl:template name="m_bbcloginblurb">
<P>This is where you can sign in to h2g2 (if you want to create a new account, first you need to <a xsl:use-attribute-sets="nm_bbcloginblurb"><xsl:call-template name="regpassthroughhref"><xsl:with-param name="url">Register</xsl:with-param></xsl:call-template>become a member</a>). Please note you need to have cookies enabled in your browser for this to work. If you have problems, then please email <A xsl:use-attribute-sets="nm_bbcloginblurb" HREF="mailto:h2g2.support@bbc.co.uk">h2g2.support@bbc.co.uk</A> with as many details as you can give us, and we'll get back to you as soon as we can.</P>
<P>To sign in, simply enter your BBC member name (<I>not</I> your h2g2 Nickname) and your BBC password. <B>Your BBC member name and password are case sensitive.</B> If you have a BBC account but you haven't logged in to h2g2 before, you may be asked to accept our Terms of use.</P>
<P><B>Note:</B> If you have a pre-BBC h2g2 account, then you need to convert your account <a xsl:use-attribute-sets="nm_bbcloginblurb"><xsl:call-template name="regpassthroughhref"><xsl:with-param name="url">RegReturn</xsl:with-param></xsl:call-template>here</a>.</P>
<P>If you have forgotten your password, then we can <A xsl:use-attribute-sets="nm_bbcloginblurb" HREF="{$root}UserDetails">email you a new one</A>.</P>
</xsl:template>

<xsl:template name="m_monthsummaryblurb">
<P>Missed any of the new <xsl:value-of select="$m_articles"/> over the last month? Don't worry, you can always pop along to this page to see a summary of the last month's worth of new Entries.</P>
</xsl:template>

<xsl:template name="m_userpagehidden">
<xsl:choose>
<xsl:when test="$ownerisviewer = 1">
<P>Your Personal Space Introduction has been hidden, because it contravenes our <A xsl:use-attribute-sets="nm_userpagehidden1" HREF="{$root}HouseRules">House Rules</A> in some way - you have been sent an email explaining why.</P>
<P>You can easily re-write your Introduction so that it doesn't break the rules, which will make it appear immediately. Simply click on the 'Edit Page' button, make any changes to ensure that your Introduction doesn't break the rules, and click on 'Update Introduction'.</P>
<P>You can find out more about moderation on h2g2 <A xsl:use-attribute-sets="nm_userpagehidden1" HREF="{$root}DontPanic-Moderation">here</A>.</P>
</xsl:when>
<xsl:otherwise>
<P>This Personal Space Introduction has been hidden, because it contravenes our <A xsl:use-attribute-sets="nm_userpagehidden2" HREF="{$root}HouseRules">House Rules</A> in some way. However, the author can easily re-write their Introduction so that it doesn't break the rules, so let's hope they do just that.</P>
<P>You can find out more about moderation on h2g2 <A xsl:use-attribute-sets="nm_userpagehidden2" HREF="{$root}DontPanic-Moderation">here</A>.</P>
</xsl:otherwise>
</xsl:choose>
</xsl:template>

<xsl:template name="m_articlehiddentext">
<xsl:choose>
<xsl:when test="$ownerisviewer = 1">
<P>Your <xsl:value-of select="$m_article"/> has been hidden, because it contravenes our <A xsl:use-attribute-sets="nm_articlehiddentext1" HREF="{$root}HouseRules">House Rules</A> in some way.</P>
<P>You can easily re-write your <xsl:value-of select="$m_article"/> so that it doesn't break the rules, which will make it appear immediately. Simply click on the 'Edit Entry' button, make any changes to ensure that your <xsl:value-of select="$m_article"/> doesn't break the rules, and click on 'Update Entry'.</P>
<P>You can find out more about moderation on h2g2 <A xsl:use-attribute-sets="nm_articlehiddentext1" HREF="{$root}DontPanic-Moderation">here</A>.</P>
</xsl:when>
<xsl:otherwise>
<P>This <xsl:value-of select="$m_article"/> has been hidden, because it contravenes our <A xsl:use-attribute-sets="nm_articlehiddentext2" HREF="{$root}HouseRules">House Rules</A> in some way. However, the author can easily re-write it so that it doesn't break the rules, so let's hope they do just that.</P>
<P>You can find out more about moderation on h2g2 <A xsl:use-attribute-sets="nm_articlehiddentext2" HREF="{$root}DontPanic-Moderation">here</A>.</P>
</xsl:otherwise>
</xsl:choose>
</xsl:template>

<xsl:template name="m_articledeletedbody">
<P>This <xsl:value-of select="$m_article"/> has been deleted from the Guide by the author.</P>
<P>We apologise for this interruption to your surfing.</P>
</xsl:template>

<xsl:template name="m_postawaitingmoderation">
This <xsl:value-of select="$m_posting"/> has been temporarily hidden, because a member of our Moderation Team has referred it to the Community Team for a decision as to whether it contravenes the <A xsl:use-attribute-sets="nm_postawaitingmoderation" TARGET="_top" HREF="{$root}HouseRules">House Rules</A> in some way. We will do everything we can to ensure that a decision is made as quickly as possible.<BR/><BR/>
You can find out more about moderation on h2g2 <A xsl:use-attribute-sets="nm_postawaitingmoderation" TARGET="_top" HREF="{$root}DontPanic-Moderation">here</A>.
</xsl:template>

<xsl:template name="m_postawaitingpremoderation">
This <xsl:value-of select="$m_posting"/> is currently queued for moderation, and will be visible as soon as a member of our Moderation Team has approved it (assuming it doesn't contravene the <A xsl:use-attribute-sets="nm_postawaitingpremoderation" TARGET="_top" HREF="{$root}HouseRules">House Rules</A>). The <xsl:value-of select="$m_user"/> who posted it is currently being pre-moderated, so all new <xsl:value-of select="$m_postings"/> they make must be checked before they become visible.<BR/><BR/>
You can find out more about moderation on h2g2 <A xsl:use-attribute-sets="nm_postawaitingpremoderation" TARGET="_top" HREF="{$root}DontPanic-Moderation">here</A>.
</xsl:template>

<xsl:template name="m_postremoved">
This <xsl:value-of select="$m_posting"/> has been hidden during moderation because it broke the <A xsl:use-attribute-sets="nm_postremoved" TARGET="_top" HREF="{$root}HouseRules">House Rules</A> in some way. You can find out more about moderation on h2g2 <A xsl:use-attribute-sets="nm_postremoved" TARGET="_top" HREF="{$root}DontPanic-Moderation">here</A>.
</xsl:template>

<xsl:template name="m_changepasswordexternal"/>

<xsl:variable name="m_UserEditHouseRulesDiscl">Remember, when you contribute to the Guide you are giving the BBC permission to use your contribution in a variety of ways. See the <A xsl:use-attribute-sets="nm_usereditpagehouserulesdisclaimer" HREF="{$root}Terms">Terms of use</A> for more information.</xsl:variable>

<xsl:template name="m_unregistereduserediterror">
<P>We're sorry, but you can't create or edit <xsl:value-of select="$m_articles"/> until you've signed in to h2g2.</P>
<UL>
<LI><P>If you already have an h2g2 account, please <A xsl:use-attribute-sets="nm_unregistereduserediterror1" href="{$sso_noarticlesigninlink}">click here to sign in</A>.</P></LI>
<LI><P>If you haven't already become a member with us as <xsl:value-of select="$m_usera"/> <xsl:value-of select="$m_user"/>, please <A xsl:use-attribute-sets="nm_unregistereduserediterror2" HREF="{$sso_noarticleregisterlink}">click here to become a member</A>. Creating your membership is free and will enable you to share your wisdom with the rest of the h2g2 Community. <a xsl:use-attribute-sets="nm_unregistereduserediterror3" href="A387317">Tell me more!</a>.</P></LI>
</UL>
</xsl:template>

<xsl:template name="m_RecommendEntrySubmitSuccessMessage"><p><xsl:value-of select="$m_article"/> was submitted for recommendation successfully.</p></xsl:template>

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
<P>Your <xsl:value-of select="$m_article"/> has been temporarily hidden, because a member of our Moderation Team has referred it to the Community Team for a decision as to whether it contravenes the <A xsl:use-attribute-sets="nm_articlereferredtext1" HREF="{$root}HouseRules">House Rules</A> in some way. We will do everything we can to ensure that a decision is made as quickly as possible.</P>
<P>Please do not try to edit your <xsl:value-of select="$m_article"/> in the meantime, as this will only mean it gets checked by the Moderation Team twice.</P>
<P>You can find out more about moderation on h2g2 <A xsl:use-attribute-sets="nm_articlereferredtext1" HREF="{$root}DontPanic-Moderation">here</A>.</P>
</xsl:when>
<xsl:otherwise>
<P>This <xsl:value-of select="$m_article"/> has been temporarily hidden, because a member of our Moderation Team has referred it to the Community Team for a decision as to whether it contravenes the <A xsl:use-attribute-sets="nm_articlereferredtext2" HREF="{$root}HouseRules">House Rules</A> in some way. We will do everything we can to ensure that a decision is made as quickly as possible.</P>
<P>You can find out more about moderation on h2g2 <A xsl:use-attribute-sets="nm_articlereferredtext2" HREF="{$root}DontPanic-Moderation">here</A>.</P>
</xsl:otherwise>
</xsl:choose>
</xsl:template>

<xsl:template name="m_articleawaitingpremoderationtext">
<xsl:choose>
<xsl:when test="$ownerisviewer = 1">
<P>Your <xsl:value-of select="$m_articles"/> are being pre-moderated and will only appear after they have been approved by a Moderator. Your <xsl:value-of select="$m_article"/> is now queued for moderation, and will be visible as soon as a member of our Moderation Team has approved it (assuming it doesn't contravene the <A xsl:use-attribute-sets="nm_articleawaitingpremoderationtext1" HREF="{$root}HouseRules">House Rules</A>).</P>
<P>You can find out more about moderation on h2g2 <A xsl:use-attribute-sets="nm_articleawaitingpremoderationtext1" HREF="{$root}DontPanic-Moderation">here</A>.</P>
</xsl:when>
<xsl:otherwise>
<P>This <xsl:value-of select="$m_article"/> is currently queued for moderation, and will be visible as soon as a member of our Moderation Team has approved it (assuming it doesn't contravene the <A xsl:use-attribute-sets="nm_articleawaitingpremoderationtext2" HREF="{$root}HouseRules">House Rules</A>). The <xsl:value-of select="$m_user"/> who posted it is currently being pre-moderated, so all new <xsl:value-of select="$m_articles"/> they make must be checked before they become visible.</P>
<P>You can find out more about moderation on h2g2 <A xsl:use-attribute-sets="nm_articleawaitingpremoderationtext2" HREF="{$root}DontPanic-Moderation">here</A>.</P>
</xsl:otherwise>
</xsl:choose>
</xsl:template>

<xsl:template name="m_legacyarticleawaitingmoderationtext">
<xsl:choose>
<xsl:when test="$ownerisviewer = 1">
<P>Your <xsl:value-of select="$m_article"/> is currently hidden, because it needs to be reactivated before it's visible, as part of the new h2g2 moderation system.</P>
<P>To make it visible, simply click on the 'Edit Page' button, check that your <xsl:value-of select="$m_article"/> doesn't break the <A xsl:use-attribute-sets="nm_legacyarticleawaitingmoderationtext" HREF="{$root}HouseRules">House Rules</A>, and click on 'Update Entry'. It will appear instantly.</P>
<P>You can find out more about moderation on h2g2 <A xsl:use-attribute-sets="nm_legacyarticleawaitingmoderationtext" HREF="{$root}DontPanic-Moderation">here</A>.</P>
</xsl:when>
<xsl:otherwise>
<P>This <xsl:value-of select="$m_article"/> is currently hidden, because the author has not yet returned to h2g2 to reactivate it. If they do not return, then in time our Moderation Team will reactivate it instead, as they work through all the content that was created before moderation was introduced to h2g2.</P>
<P>You can find out more about moderation on h2g2 <A xsl:use-attribute-sets="nm_legacyarticleawaitingmoderationtext" HREF="{$root}DontPanic-Moderation">here</A>.</P>
</xsl:otherwise>
</xsl:choose>
</xsl:template>

<xsl:template name="m_userpagereferred">
<xsl:choose>
<xsl:when test="$ownerisviewer = 1">
<P>Your Personal Space Introduction has been temporarily hidden, because a member of our Moderation Team has referred it to the Community Team for a decision as to whether it contravenes the <A xsl:use-attribute-sets="nm_userpagereferred1" HREF="{$root}HouseRules">House Rules</A> in some way. We will do everything we can to ensure that a decision is made as quickly as possible.</P>
<P>Please do not try to edit your Introduction in the meantime, as this will only mean it gets checked by the Moderation Team twice.</P>
<P>You can find out more about moderation on h2g2 <A xsl:use-attribute-sets="nm_userpagereferred1" HREF="{$root}DontPanic-Moderation">here</A>.</P>
</xsl:when>
<xsl:otherwise>
<P>This Personal Space Introduction has been temporarily hidden, because a member of our Moderation Team has referred it to the Community Team for a decision as to whether it contravenes the <A xsl:use-attribute-sets="nm_userpagereferred2" HREF="{$root}HouseRules">House Rules</A> in some way. We will do everything we can to ensure that a decision is made as quickly as possible.</P>
<P>You can find out more about moderation on h2g2 <A xsl:use-attribute-sets="nm_userpagereferred2" HREF="{$root}DontPanic-Moderation">here</A>.</P>
</xsl:otherwise>
</xsl:choose>
</xsl:template>

<xsl:template name="m_userpagependingpremoderation">
<xsl:choose>
<xsl:when test="$ownerisviewer = 1">
<P>Your <xsl:value-of select="$m_articles"/> are being pre-moderated and will only appear after they have been approved by a Moderator. Your Personal Space Introduction is now queued for moderation, and will be visible as soon as a member of our Moderation Team has approved it (assuming it doesn't contravene the <A xsl:use-attribute-sets="nm_userpagependingpremoderation1" HREF="{$root}HouseRules">House Rules</A>).</P>
<P>You can find out more about moderation on h2g2 <A xsl:use-attribute-sets="nm_userpagependingpremoderation1" HREF="{$root}DontPanic-Moderation">here</A>.</P>
</xsl:when>
<xsl:otherwise>
<P>This Personal Space Introduction is currently queued for moderation, and will be visible as soon as a member of our Moderation Team has approved it (assuming it doesn't contravene the <A xsl:use-attribute-sets="nm_userpagependingpremoderation2" HREF="{$root}HouseRules">House Rules</A>). The <xsl:value-of select="$m_user"/> who edited it is currently being pre-moderated, so all new <xsl:value-of select="$m_articles"/> they make must be checked before they become visible.</P>
<P>You can find out more about moderation on h2g2 <A xsl:use-attribute-sets="nm_userpagependingpremoderation2" HREF="{$root}DontPanic-Moderation">here</A>.</P>
</xsl:otherwise>
</xsl:choose>
</xsl:template>

<xsl:template name="m_legacyuserpageawaitingmoderation">
<xsl:choose>
<xsl:when test="$ownerisviewer = 1">
<P>Your Personal Space Introduction is currently hidden, because it needs to be reactivated before it's visible, as part of the new h2g2 moderation system.</P>
<P>To make it visible, simply click on the 'Edit Page' button, check that your Introduction doesn't break the <A xsl:use-attribute-sets="nm_legacyuserpageawaitingmoderation" HREF="{$root}HouseRules">House Rules</A>, and click on 'Update Introduction'. It will appear instantly.</P>
<P>You can find out more about moderation on h2g2 <A xsl:use-attribute-sets="nm_legacyuserpageawaitingmoderation" HREF="{$root}DontPanic-Moderation">here</A>.</P>
</xsl:when>
<xsl:otherwise>
<P>This Personal Space Introduction is currently hidden, because the author has not yet returned to h2g2 to reactivate it. If they do not return, then in time our Moderation Team will reactivate it instead, as they work through all the content that was created before moderation was introduced to h2g2.</P>
<P>You can find out more about moderation on h2g2 <A xsl:use-attribute-sets="nm_legacyuserpageawaitingmoderation" HREF="{$root}DontPanic-Moderation">here</A>.</P>
</xsl:otherwise>
</xsl:choose>
</xsl:template>

<xsl:template name="m_articlepremodblurb">
<p>h2g2 is currently being pre-moderated. This means that you can create and edit <xsl:value-of select="$m_articles"/> normally, but they will not be visible until they have been approved by a Moderator. This will take less than one hour, usually much less.</p>
</xsl:template>

<xsl:template name="m_movesubject">Move Subject</xsl:template>

<xsl:template name="m_comingupintro">
<BR/>
<P>This page shows what's coming up, and currently going through our editorial process.</P>
</xsl:template>

<xsl:template name="m_cominguprecintro">
<P>These <xsl:value-of select="$m_articles"/> have been accepted from the Scouts, but haven't been sent to a Sub-editor yet.</P>
</xsl:template>

<xsl:template name="m_comingupwitheditorintro">
<P>These <xsl:value-of select="$m_articles"/> have been sent to a Sub-editor and are being edited.</P>
</xsl:template>

<xsl:template name="m_comingupreturnintro">
<P>These <xsl:value-of select="$m_articles"/> have been returned from the Sub-editor and are awaiting final polishing.</P>
</xsl:template>

<xsl:template name="m_editcatRenameSubject">Rename Subject</xsl:template>
<xsl:template name="m_editcatRenameDescription">Rename Description</xsl:template>
<xsl:template name="m_editcatMoveSubject">Move Subject</xsl:template>
<xsl:template name="m_editcatDeleteSubject">Delete Subject</xsl:template>
<xsl:template name="m_editcatAddSubject">Add a subject</xsl:template>
<xsl:template name="m_editcatDeleteSubjectLink">Delete Subject Link</xsl:template>
<xsl:template name="m_editcatMoveSubjectLink">Move Subject Link</xsl:template>
<xsl:template name="m_editcatMoveArticle">Move Article</xsl:template>
<xsl:template name="m_editcatDeleteArticle">Delete Article</xsl:template>
<xsl:template name="m_EditCatDots">........</xsl:template>
<xsl:template name="m_EditCatRenameDesc">Add/Change Description</xsl:template>
<xsl:template name="m_EditCatRenameSubjectButton">Change Subject</xsl:template>
<xsl:template name="m_EditCatAddSubjectButton">Add a new subject</xsl:template>

<xsl:template name="m_submitforreviewbutton">
<FONT size="2">Submit For Review</FONT>
</xsl:template>

<xsl:template name="m_notforreviewbutton">
<FONT xsl:use-attribute-sets="mainfont" size="1"><b><xsl:value-of select="$alt_notforreview"/></b></FONT>
</xsl:template>

<xsl:template name="m_submittedtoreviewforumbutton">
<FONT size="1"><xsl:value-of select="REVIEWFORUM/FORUMNAME"/></FONT>
</xsl:template>

<xsl:template name="m_currentlyinreviewforum">
<FONT xsl:use-attribute-sets="mainfont" size="1"><b>Currently in: </b></FONT>
</xsl:template>

<xsl:template name="m_rft_articleheader"><b>Entry</b></xsl:template>
<xsl:template name="m_rft_selectlastposted"><b><i>Last Posted</i></b></xsl:template>
<xsl:template name="m_rft_lastposted"><b>Last Posted</b></xsl:template>
<xsl:template name="m_rft_selectdateentered"><b><i>Date Entered</i></b></xsl:template>
<xsl:template name="m_rft_dateentered"><b>Date Entered</b></xsl:template>
<xsl:template name="m_rft_selectauthor"><b><i>Author</i></b></xsl:template>
<xsl:template name="m_rft_author"><b>Author</b></xsl:template>
<xsl:template name="m_rft_selecth2g2id"><b><i>Entry</i></b></xsl:template>
<xsl:template name="m_rft_h2g2id"><b>Entry</b></xsl:template>
<xsl:template name="m_rft_subject"><b>Subject</b></xsl:template>
<xsl:template name="m_rft_selectsubject"><b><i>Subject</i></b></xsl:template>
<xsl:template name="m_removefromreviewforum">Remove</xsl:template>
<xsl:template name="m_searchresultsthissite">The following results were found in <xsl:value-of select="$m_sitetitle"/></xsl:template>
<xsl:template name="m_searchresultsothersites">These results were found in other sites</xsl:template>
<xsl:template name="m_recommendentrybutton">Recommend Entry</xsl:template>

<xsl:template name="m_sitechangemessage">
<P>The link you clicked on will take you out of this site. Think very carefully about this. Are you sure you want to leave our fluffy environs? It's a big bad world out there in the rest of DNA, and it might not be safe for everybody. Your choice.</P>
<P><A xsl:use-attribute-sets="nm_sitechangemessage" href="/dna/{SITECHANGE/SITENAME}/{SITECHANGE/URL}">Click here to continue on...</A></P>
</xsl:template>

<xsl:template name="m_rft_selectauthorid"><b><i>Author ID</i></b></xsl:template>
<xsl:template name="m_rft_authorid"><b>Author ID</b></xsl:template>

<xsl:template name="m_submitarticlefirst_text">
<br/>Use this form to submit A<xsl:value-of select="../ARTICLE/@H2G2ID"/> - '<xsl:value-of select="../ARTICLE"/>' for review. Please note that, on submission, your comments below will be used as the first <xsl:value-of select="$m_posting"/> in your Review Conversation.<br/><br/>
<B>Please read the <A xsl:use-attribute-sets="nm_submitarticlefirst_text" HREF="DontPanic-ReviewForums">Review Forums FAQ</A> and <A xsl:use-attribute-sets="nm_submitarticlefirst_text" HREF="Writing-Guidelines">Writing Guidelines</A> before using this form, so you can pick the correct Review Forum:</B><br/>
<UL>
<LI>If your <xsl:value-of select="$m_article"/> meets our guidelines and is finished, choose <B>Peer Review</B></LI>
<LI>If your <xsl:value-of select="$m_article"/> meets our guidelines but is not yet finished, choose <B>Writing Workshop</B></LI>
<LI>If your <xsl:value-of select="$m_article"/> is currently just an idea, choose <B>Collaborative Writing Workshop</B></LI>
<LI>If your <xsl:value-of select="$m_article"/> doesn't meet our guidelines, choose <B>Alternative Writing Workshop</B></LI>
<LI>Don't choose <B>Flea Market</B>, unless you want your <xsl:value-of select="$m_article"/> to be ignored!</LI>
</UL>
</xsl:template>

<xsl:template name="m_submitarticlelast_text">
<A xsl:use-attribute-sets="nm_submitarticlelast_text"><xsl:attribute name="HREF">A<xsl:value-of select="../ARTICLE/@H2G2ID"/></xsl:attribute>Click here to return to the <xsl:value-of select="$m_article"/> without putting it into a Review Forum</A>
</xsl:template>

<xsl:template name="m_inreviewtextandlink">
The <xsl:value-of select="$m_article"/> you are trying to delete is currently in the Review Forum '<xsl:value-of select="INREVIEW/REVIEWFORUM/FORUMNAME"/>'. <br/><br/>
If you would like to remove the <xsl:value-of select="$m_article"/> from '<xsl:value-of select="INREVIEW/REVIEWFORUM/FORUMNAME"/>' and delete it then click <A xsl:use-attribute-sets="nm_inreviewtextandlink1"><xsl:attribute name="HREF"><xsl:value-of select="$root"/>UserEdit<xsl:value-of select="INREVIEW/ARTICLE/@H2G2ID"/>?cmd=deletereview</xsl:attribute>here</A>.<br/><br/>
Alternatively you can go back to <A xsl:use-attribute-sets="nm_inreviewtextandlink2"><xsl:attribute name="HREF"><xsl:value-of select="$root"/>UserEdit<xsl:value-of select="INREVIEW/ARTICLE/@H2G2ID"/></xsl:attribute>editing the <xsl:value-of select="$m_article"/> without deleting it</A>.<br/>
</xsl:template>

<xsl:template name="m_removefromreviewsuccesslink">
The <xsl:value-of select="$m_article"/><xsl:text> </xsl:text><A xsl:use-attribute-sets="nm_removefromreviewsuccesslink1"><xsl:attribute name="HREF"><xsl:value-of select="$root"/>A<xsl:value-of select="H2G2ID"/></xsl:attribute><xsl:value-of select="SUBJECT"/></A> has been successfully removed from the Review Forum '<A xsl:use-attribute-sets="nm_removefromreviewsuccesslink2"><xsl:attribute name="HREF"><xsl:value-of select="$root"/>RF<xsl:value-of select="REVIEWFORUM/@ID"/></xsl:attribute><xsl:value-of select="REVIEWFORUM/REVIEWFORUMNAME"/></A>'.<br/><br/>
The relevant Review Conversation has been moved to the <xsl:value-of select="$m_forum"/> for the <xsl:value-of select="$m_article"/> itself, and the <xsl:value-of select="$m_article"/> will no longer appear in any Review Forums.
</xsl:template>

<xsl:template name="m_crumbtrail_divider">|</xsl:template>

<xsl:template name="m_cantpostrestricted">
<p>We're sorry, but you are restricted from posting to this site.</p>
</xsl:template>

<xsl:template name="m_articleuserpremodblurb">
<p><b>Please note:</b> Your <xsl:value-of select="$m_articles"/> are being pre-moderated and will only appear after they have been approved by a Moderator.</p>
</xsl:template>

<xsl:template name="m_posthasbeenpremoderated">
Thank you for posting. Your <xsl:value-of select="$m_posting"/> will be checked by our Moderation Team and will appear on the site once it has been approved. If you just started a new <xsl:value-of select="$m_thread"/>, it will only appear on your Personal Space after it has been approved.<br/>
<xsl:choose>
<xsl:when test="number(@NEWCONVERSATION)=1">
<a xsl:use-attribute-sets="nm_posthasbeenpremoderated1" href="{$root}F{@FORUM}">Click here to return to the <xsl:value-of select="$m_forum"/></a><br/>
</xsl:when>
<xsl:otherwise>
<a xsl:use-attribute-sets="nm_posthasbeenpremoderated2" href="{$root}F{@FORUM}?thread={@THREAD}&amp;post={@POST}">Click here to return to the <xsl:value-of select="$m_thread"/></a><br/>
</xsl:otherwise>
</xsl:choose>
</xsl:template>

<xsl:template name="m_entrysubmittedtoreviewforum">
<p><br/>The <xsl:value-of select="$m_article"/><xsl:text> </xsl:text><A xsl:use-attribute-sets="nm_entrysubmittedtoreviewforum1"><xsl:attribute name='href'>A<xsl:value-of select="../ARTICLE/@H2G2ID"/></xsl:attribute><xsl:value-of select="../ARTICLE"/></A> has been successfully submitted to the Review Forum
'<A xsl:use-attribute-sets="nm_entrysubmittedtoreviewforum2"><xsl:attribute name='href'>RF<xsl:value-of select="REVIEWFORUM/@ID"/></xsl:attribute><xsl:value-of select="REVIEWFORUM/FORUMNAME"/></A>'. <br/><br/>
You can find the Review Conversation at 
<A xsl:use-attribute-sets="nm_entrysubmittedtoreviewforum3"><xsl:attribute name='href'>F<xsl:value-of select="@FORUMID"/>?thread=<xsl:value-of select="@THREADID"/></xsl:attribute>F<xsl:value-of select="@FORUMID"/>?thread=<xsl:value-of select="@THREADID"/></A>
</p>
</xsl:template>

<xsl:template name="m_notforreview_explanation">
<font use-attribute-sets="mainfont" size="1">Tick the 'Not for Review' box if you <I>don't</I> want your <xsl:value-of select="$m_article"/> to be available for review (see the <A xsl:use-attribute-sets="nm_notforreview_explanation" HREF="DontPanic-ReviewForums">Review Forums FAQ</A> for more information)</font>
</xsl:template>

<xsl:template name="m_passthroughwelcomeback">
<!-- This is a generic message when someone has just logged in while doing a passthrough -->
You are now logged in to h2g2 - welcome back!<br/><br/>
</xsl:template>

<xsl:template name="m_passthroughnewuser">
<!-- This is a generic message when someone has just registered while doing a passthrough -->
Welcome to h2g2. You're a member now, so the 'My Space' button will take you to your Personal Space, where you can write something about yourself.<br/>
</xsl:template>

<xsl:template name="m_ptwriteguideentry">
<!-- this is the message that is displayed after a login/registration started from the UserEdit page. -->
<a xsl:use-attribute-sets="nm_ptwriteguideentry" href="{$root}UserEdit">Click here to write your <xsl:value-of select="$m_article"/></a>
</xsl:template>

<xsl:template name="m_restricteduserpreferencesmessage">Sorry, you are not allowed to change your Preferences.</xsl:template>

<xsl:template name="m_notfoundbody">
<P>We're sorry, but the page you have requested does not exist. This could be because the URL<A xsl:use-attribute-sets="nm_notfoundbody1" TITLE="That's the address of the web page that we can't find - it should begin with http://www.bbc.co.uk/h2g2/" NAME="back1" HREF="#footnote1"><SUP>1</SUP></A> is wrong, or because the page you are looking for has been removed from the Guide.</P>
<P>If you can't work out why your URL isn't working, then please visit the <A xsl:use-attribute-sets="nm_notfoundbody1" TARGET="_top" HREF="/dna/h2g2/alabaster/A388361">Bug Report</A> section of the Feedback Forum, and tell us the URL. We'll then get back to you as soon as we can, and you'll be able to see our response on your Personal Space.</P>
<P>We apologise for this interruption in your surfing, and hope the tide comes back in soon.</P>
<blockquote><font size="-1"><hr/><A xsl:use-attribute-sets="nm_notfoundbody2" NAME="footnote1" HREF="#back1"><SUP>1</SUP></A> That's the address of the web page that we can't find - it should begin with http://www.bbc.co.uk/dna/h2g2/</font></blockquote>
</xsl:template>

<xsl:template name="m_unregprefsmessage">
<p>Please <a href="{$sso_signinlink}">sign in</a> to change your nickname</p>
<!--p>If you have forgotten your password, enter your BBC Login Name (<b>not</b> your nickname)
and the email address you used to register. A new password will be created and emailed to you.
If you can't remember your login name, use your <xsl:value-of select="$m_user"/> number (the number which came after the U on your Personal Space).</p-->
</xsl:template>

<xsl:template name="m_nameremovedfromresearchers">
Your name has been removed from the list of <xsl:value-of select="$m_users"/> for the <xsl:value-of select="$m_article"/><xsl:text> </xsl:text><a xsl:use-attribute-sets="nm_nameremovedfromresearchers" href="{$root}A{H2G2ID}"><xsl:apply-templates select="SUBJECT" mode="nosubject"/></a>.
</xsl:template>

<xsl:template name="m_namenotremovedfromresearchers">
Your name could not be removed from the list of <xsl:value-of select="$m_users"/> for the <xsl:value-of select="$m_article"/> <a xsl:use-attribute-sets="nm_namenotremovedfromresearchers" href="{$root}A{H2G2ID}"><xsl:apply-templates select="SUBJECT" mode="nosubject"/></a>
	<xsl:choose>
		<xsl:when test="@REASON='unregistered'">
		because are not logged in.
		</xsl:when>
		<xsl:when test="@REASON='iseditor'">
		because you are the Editor of the <xsl:value-of select="$m_article"/>.
		</xsl:when>
		<xsl:when test="@REASON='notresearcher'">
		because you aren't on the <xsl:value-of select="$m_user"/> list.
		</xsl:when>
	</xsl:choose>
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
A new password could not be sent because the member name or <xsl:value-of select="$m_user"/> number you entered was not valid, or 
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


  <!-- end of templates -->

<!-- text in the user details box on a personal space -->
<xsl:variable name="m_userdata"><xsl:value-of select="$m_user"/> Data</xsl:variable>
<xsl:variable name="m_researcher"><xsl:value-of select="$m_user"/> </xsl:variable>
<xsl:variable name="m_namecolon">Name: </xsl:variable>
<xsl:variable name="m_otherconv">Other <xsl:value-of select="$m_threads"/></xsl:variable>
<xsl:variable name="m_currentconv">Current <xsl:value-of select="$m_thread"/></xsl:variable>
<xsl:variable name="m_forumtitle">BBC - h2g2 - <xsl:value-of select="$m_forum"/></xsl:variable>
<xsl:variable name="m_copyright">(c) BBC MMII</xsl:variable>
<xsl:variable name="m_entrydata">Entry Data</xsl:variable>
<xsl:variable name="m_idcolon">Entry ID: </xsl:variable>
<xsl:variable name="m_datecolon">Date: </xsl:variable>
<xsl:variable name="m_edited"> (Edited)</xsl:variable>
<xsl:variable name="m_unedited"> (Normal)</xsl:variable>
<xsl:variable name="m_helppage"> (Help Page)</xsl:variable>
<xsl:variable name="m_entrydatarecommendedstatus"> (Recommended)</xsl:variable>
<xsl:variable name="m_lastposting">Last <xsl:value-of select="$m_posting"/>: </xsl:variable>
<xsl:variable name="m_peopletalking">People have been talking about this <xsl:value-of select="$m_article"/>. Here are the most recent <xsl:value-of select="$m_threads"/>:</xsl:variable>
<xsl:variable name="m_firsttotalk">Click here to be the first person to discuss this <xsl:value-of select="$m_article"/></xsl:variable>
<xsl:variable name="m_clickmoreconv">Click here to see more <xsl:value-of select="$m_threads"/></xsl:variable>
<xsl:variable name="m_fsubject">Subject: </xsl:variable>
<xsl:variable name="m_posted">Posted </xsl:variable>
<xsl:variable name="m_posteddate">Date Posted</xsl:variable>
<xsl:variable name="m_by"> by </xsl:variable>
<xsl:variable name="m_inreplyto">This is a reply to </xsl:variable>
<xsl:variable name="m_thispost">this <xsl:value-of select="$m_posting"/></xsl:variable>
<xsl:variable name="m_postcolon">Post: </xsl:variable>
<xsl:variable name="m_readthe">Read the </xsl:variable>
<xsl:variable name="m_firstreplytothis">first reply to this <xsl:value-of select="$m_posting"/></xsl:variable>
<xsl:variable name="m_refentries">Referenced <xsl:value-of select="$m_articles"/></xsl:variable>
<xsl:variable name="m_refresearchers">Referenced <xsl:value-of select="$m_users"/></xsl:variable>
<xsl:variable name="m_refsites">Referenced Sites</xsl:variable>
<xsl:variable name="m_clickmorejournal">Click here to see more <xsl:value-of select="$m_journalpostings"/></xsl:variable>
<xsl:variable name="m_clickaddjournal">Click here to add <xsl:value-of select="$m_journalpostinga"/> <xsl:value-of select="$m_journalposting"/></xsl:variable>
<xsl:variable name="m_clickherediscuss">Click here to discuss this</xsl:variable>
<xsl:variable name="m_replies"> replies</xsl:variable>
<xsl:variable name="m_reply"> reply</xsl:variable>
<xsl:variable name="m_latestreply">Latest reply: </xsl:variable>
<xsl:variable name="m_noreplies">No replies</xsl:variable>
<xsl:variable name="m_nosubject">No subject</xsl:variable>
<xsl:variable name="m_postedcolon">Posted: </xsl:variable>
<xsl:variable name="m_lastreply">Last reply: </xsl:variable>
<xsl:variable name="m_clicknewentry">Click here to add a new <xsl:value-of select="$m_article"/></xsl:variable>
<xsl:variable name="m_clickmoreentries">Click here to see more <xsl:value-of select="$m_articles"/></xsl:variable>
<xsl:variable name="m_clickmoreedited">Click here to see more <xsl:value-of select="$m_editedarticles"/></xsl:variable>
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
<xsl:variable name="m_machangesnoeffect">No changes will take effect (including maps) until you press the </xsl:variable>
<xsl:variable name="m_addintroduction">Add Introduction</xsl:variable>
<xsl:variable name="m_updateintroduction">Update Introduction</xsl:variable>
<xsl:variable name="m_addguideentry">Add <xsl:value-of select="$m_article"/></xsl:variable>
<xsl:variable name="m_updateentry">Update Entry</xsl:variable>
<xsl:variable name="m_deletethisentry">Delete this Entry</xsl:variable>
<xsl:variable name="m_deletebypressing">If you created this <xsl:value-of select="$m_article"/> by mistake, or no longer require it, you can delete it by pressing this button:</xsl:variable>
<xsl:variable name="m_delete">Delete</xsl:variable>
<xsl:variable name="m_journalentries"><xsl:value-of select="$m_journalpostings"/></xsl:variable>
<xsl:variable name="m_mostrecentconv">Most Recent <xsl:value-of select="$m_threads"/></xsl:variable>
<xsl:variable name="m_noposting">No <xsl:value-of select="$m_posting"/></xsl:variable>
<xsl:variable name="m_newestpost">Latest post: </xsl:variable>
<xsl:variable name="m_cancelled"> cancelled</xsl:variable>
<xsl:variable name="m_pending"> pending</xsl:variable>
<xsl:variable name="m_recommended"> recommended</xsl:variable>
<xsl:variable name="m_uncancel">uncancel</xsl:variable>
<xsl:variable name="m_postedsoon2">Posted Soon </xsl:variable>
<xsl:variable name="m_returntoforum">Click here to return to the <xsl:value-of select="$m_forum"/> without saying anything</xsl:variable>
<xsl:variable name="m_unsubmit">Unsubmit Entry</xsl:variable>
<xsl:variable name="m_recententries">Most Recent <xsl:value-of select="$m_articles"/></xsl:variable>
<xsl:variable name="m_mostrecentedited">Most Recent <xsl:value-of select="$m_editedarticles"/></xsl:variable>
<xsl:variable name="m_clickdiscussbutton">Click the 'Discuss this Entry' button to be the first person to discuss this <xsl:value-of select="$m_article"/></xsl:variable>
<xsl:variable name="m_nomembers">no members</xsl:variable>
<xsl:variable name="m_member"> member</xsl:variable>
<xsl:variable name="m_members"> members</xsl:variable>
<xsl:variable name="m_resultsfound">Results found</xsl:variable>
<xsl:variable name="m_noprevresults">No Previous Results </xsl:variable>
<xsl:variable name="m_nomoreresults">No More Results </xsl:variable>
<xsl:variable name="m_prevresults">&lt;&lt; Previous results</xsl:variable>
<xsl:variable name="m_nextresults">Next results &gt;&gt; </xsl:variable>
<xsl:variable name="m_SearchResultsIDColumnName">ID</xsl:variable>
<xsl:variable name="m_SearchResultsSubjectColumnName">Subject</xsl:variable>
<xsl:variable name="m_SearchResultsStatusColumnName">Status</xsl:variable>
<xsl:variable name="m_SearchResultsScoreColumnName">Score</xsl:variable>
<xsl:variable name="m_editedguideentry"><xsl:value-of select="$m_editedarticle"/> </xsl:variable>
<xsl:variable name="m_helppageentry">Help Page </xsl:variable>
<xsl:variable name="m_recommendedentry">Recommended <xsl:value-of select="$m_article"/> </xsl:variable>
<xsl:variable name="m_guideentry"><xsl:value-of select="$m_article"/> </xsl:variable>
<xsl:variable name="m_EditedEntryStatusName">Edited</xsl:variable>
<xsl:variable name="m_HelpPageStatusName">Help Page</xsl:variable>
<xsl:variable name="m_RecommendedEntryStatusName">Recommended</xsl:variable>
<xsl:variable name="m_NormalEntryStatusName">-</xsl:variable>
<xsl:variable name="m_clickunsubscribe">Click here to unsubscribe from this <xsl:value-of select="$m_thread"/></xsl:variable>
<xsl:variable name="m_clicksubscribe">Click here to subscribe to this <xsl:value-of select="$m_thread"/></xsl:variable>
<xsl:variable name="m_clickunsubforum">Click here to stop being notified of new <xsl:value-of select="$m_threads"/> about this <xsl:value-of select="$m_article"/></xsl:variable>
<xsl:variable name="m_clicksubforum">Click here to be notified of new <xsl:value-of select="$m_threads"/> about this <xsl:value-of select="$m_article"/></xsl:variable>
<xsl:variable name="m_onlinetitle">Find Out Who Else is Online on h2g2</xsl:variable>
<xsl:variable name="m_newthisweek">New this week</xsl:variable>
<xsl:variable name="m_onlineorderby">Order by: </xsl:variable>
<xsl:variable name="m_onlineidradiolabel">ID </xsl:variable>
<xsl:variable name="m_onlinenameradiolabel">Name </xsl:variable>
<xsl:variable name="m_onlineregisteredradiolabel">Member </xsl:variable>
<xsl:variable name="m_totalregusers">Total Registered Members</xsl:variable>
<xsl:variable name="m_usershaveregistered"><xsl:text> </xsl:text><xsl:value-of select="$m_users"/> have become members since we launched on April 28, 1999.</xsl:variable>
<xsl:variable name="m_queuelength">Recommended <xsl:value-of select="$m_article"/> Queue Length</xsl:variable>
<xsl:variable name="m_therearecurrently">There are currently<xsl:text> </xsl:text></xsl:variable>
<xsl:variable name="m_recinqueue"> Recommended <xsl:value-of select="$m_articles"/> in the queue.</xsl:variable>
<xsl:variable name="m_editedentries"><xsl:value-of select="$m_editedarticles"/></xsl:variable>
<xsl:variable name="m_uneditedentries"><xsl:value-of select="$m_uneditedarticles"/></xsl:variable>
<xsl:variable name="m_editedinguide"><xsl:text> </xsl:text><xsl:value-of select="$m_editedarticles"/> in the Guide.</xsl:variable>
<xsl:variable name="m_uneditedinguide"><xsl:text> </xsl:text><xsl:value-of select="$m_uneditedarticles"/> in the Guide.</xsl:variable>
<xsl:variable name="m_toptenprolific"><xsl:value-of select="$m_users"/> with the Most <xsl:value-of select="$m_postings"/> in 24 Hours</xsl:variable>
<xsl:variable name="m_toptenerudite"><xsl:value-of select="$m_users"/> with the Longest <xsl:value-of select="$m_postings"/> in 24 Hours</xsl:variable>
<xsl:variable name="m_toptenlongest">Top Ten Longest <xsl:value-of select="$m_postings"/> in last 24 hours</xsl:variable>
<xsl:variable name="m_toptwentyupdated">Twenty Most Recently Updated <xsl:value-of select="$m_threads"/></xsl:variable>
<xsl:variable name="m_toptenupdatedarticles">Twenty Most Recently Created <xsl:value-of select="$m_articles"/></xsl:variable>
<xsl:variable name="m_postsaverage"> posts, average size </xsl:variable>
<xsl:variable name="m_postaverage"> post, average size </xsl:variable>
<xsl:variable name="m_discuss">Discuss</xsl:variable>
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
<xsl:variable name="m_replytothispost">Write a reply to this <xsl:value-of select="$m_posting"/></xsl:variable>
<xsl:variable name="m_thisconvforentry">This is the <xsl:value-of select="$m_forum"/> for </xsl:variable>
<xsl:variable name="m_thisjournal">This is the <xsl:value-of select="$m_journal"/> of </xsl:variable>
<xsl:variable name="m_thisuserstatistics">This is the Statistics of </xsl:variable>
<xsl:variable name="m_thismessagecentre">This is the Message Centre for </xsl:variable>
<xsl:variable name="m_unsubscribe">Unsubscribe</xsl:variable>
<xsl:variable name="m_edit">edit</xsl:variable>
<xsl:variable name="m_previous">Previous </xsl:variable>
<xsl:variable name="m_entries"> <xsl:value-of select="$m_articles"/></xsl:variable>
<xsl:variable name="m_nextspace">Next </xsl:variable>
<xsl:variable name="m_nopreventries">No Previous <xsl:value-of select="$m_articles"/></xsl:variable>
<xsl:variable name="m_nomoreentries">No More <xsl:value-of select="$m_articles"/></xsl:variable>
<xsl:variable name="m_returntoentry">Click here to return to the <xsl:value-of select="$m_article"/> without saying anything</xsl:variable>
<xsl:variable name="m_previewjournal">Preview <xsl:value-of select="$m_journal"/></xsl:variable>
<xsl:variable name="m_storejournal">Store <xsl:value-of select="$m_journal"/></xsl:variable>
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
<xsl:variable name="m_button"> button.</xsl:variable>
<xsl:variable name="m_recommendtitle">Recommend <xsl:value-of select="$m_articlea"/> <xsl:value-of select="$m_article"/> for the <xsl:value-of select="$m_editedguide"/></xsl:variable>
<xsl:variable name="m_firstnames">First&nbsp;Names:&nbsp;</xsl:variable>
<xsl:variable name="m_lastname">Last&nbsp;Name:&nbsp;</xsl:variable>
<xsl:variable name="m_nickname">Nickname:&nbsp;</xsl:variable>
<xsl:variable name="m_emailaddr">Email&nbsp;Address:&nbsp;</xsl:variable>
<xsl:variable name="m_skin">Skin:&nbsp;</xsl:variable>
<xsl:variable name="m_usermode">User&nbsp;Mode:&nbsp;</xsl:variable>
<xsl:variable name="m_normal">Normal</xsl:variable>
<xsl:variable name="m_expert">Expert</xsl:variable>
<xsl:variable name="m_passwordmessage">To change your password, enter your original password, then your new password twice.</xsl:variable>
<xsl:variable name="m_password">Password:&nbsp;</xsl:variable>
<xsl:variable name="m_newpassword">New&nbsp;Password:&nbsp;</xsl:variable>
<xsl:variable name="m_oldpassword">Current&nbsp;Password:&nbsp;</xsl:variable>
<xsl:variable name="m_confirmpassword">Confirm&nbsp;Password:&nbsp;</xsl:variable>
<xsl:variable name="m_updatedetails">Update Details</xsl:variable>
<xsl:variable name="m_backtouserpage">Click here to go back to your Personal Space</xsl:variable>
<xsl:variable name="m_frontpagetitle"><xsl:value-of select="$m_pagetitlestart"/>The Hitchhiker's Guide to the Galaxy</xsl:variable>
<xsl:variable name="m_indextitle">Index of <xsl:value-of select="$m_articles"/></xsl:variable>
<xsl:variable name="m_show">Show</xsl:variable>
<xsl:variable name="m_awaitingappr">Recommended <xsl:value-of select="$m_articles"/></xsl:variable>
<xsl:variable name="m_guideentries"><xsl:value-of select="$m_articles"/></xsl:variable>
<xsl:variable name="m_pstitleowner">Welcome to your Personal Space, </xsl:variable>
<xsl:variable name="m_pstitleviewer">Welcome to the Personal Space of <xsl:value-of select="$m_user"/><xsl:text> </xsl:text></xsl:variable>
<xsl:variable name="m_mymessage">My</xsl:variable>
<xsl:variable name="m_refresh">Refresh</xsl:variable>
<xsl:variable name="m_posttoaforum">Post to <xsl:value-of select="$m_threada"/> <xsl:value-of select="$m_thread"/></xsl:variable>
<xsl:variable name="m_postsubject">Post Subject</xsl:variable>
<xsl:variable name="m_greetingshiker">Greetings unknown hiker</xsl:variable>
<xsl:variable name="m_browsetheguide">Browse the Guide</xsl:variable>
<xsl:variable name="m_searchtitle">Search</xsl:variable>
<xsl:variable name="m_searchsubject">Search h2g2</xsl:variable>
<xsl:variable name="m_searchin">Search in</xsl:variable>
<xsl:variable name="m_recommendedentries">Recommended <xsl:value-of select="$m_articles"/></xsl:variable>
<xsl:variable name="m_oruseindex">Or you can search the alphabetical index of all <xsl:value-of select="$m_articles"/>:</xsl:variable>
<xsl:variable name="m_searchforums">Search the <xsl:value-of select="$m_forums"/></xsl:variable>
<xsl:variable name="m_searchforafriend">Search for a Friend</xsl:variable>
<xsl:variable name="m_searchfor">Search for: </xsl:variable>
<xsl:variable name="m_addjournal">Add <xsl:value-of select="$m_journalpostinga"/> <xsl:value-of select="$m_journalposting"/></xsl:variable>
<xsl:variable name="m_registrationtitle">Registration</xsl:variable>
<xsl:variable name="m_registrationsubject">h2g2 Sign in/Registration</xsl:variable>
<xsl:variable name="m_enterpassword">Enter your password</xsl:variable>
<xsl:variable name="m_alwaysremember">Always remember me on this computer</xsl:variable>
<xsl:variable name="m_newusers">New Users</xsl:variable>
<xsl:variable name="m_existingusers">Existing Users</xsl:variable>
<xsl:variable name="m_interestingfacts">Interesting h2g2 Statistics</xsl:variable>
<xsl:variable name="m_h2g2stats">h2g2 Statistics</xsl:variable>
<xsl:variable name="m_logoutheader">Goodbye</xsl:variable>
<xsl:variable name="m_logoutsubject">Thank you for visiting h2g2</xsl:variable>
<xsl:variable name="m_journalforresearcher"><xsl:value-of select="$m_journal"/> for <xsl:value-of select="$m_user"/> </xsl:variable>
<xsl:variable name="m_backtoresearcher">Back to <xsl:value-of select="$m_user"/>'s Personal Space</xsl:variable>
<xsl:variable name="m_newemailtitle"><xsl:value-of select="$m_h2g2"/></xsl:variable>
<xsl:variable name="m_newemailstored">New email address stored</xsl:variable>
<xsl:variable name="m_failedtostoreemail">Failed to store email address.</xsl:variable>
<xsl:variable name="m_yournewemailstored">Your new email address has been stored.</xsl:variable>
<xsl:variable name="m_unabletostoreemailbecause">We were unable to store your new email address because </xsl:variable>
<xsl:variable name="m_morepagestitle"><xsl:value-of select="$m_articles"/></xsl:variable>
<xsl:variable name="m_cancelledentries">Cancelled <xsl:value-of select="$m_articles"/></xsl:variable>
<xsl:variable name="m_errortitle">h2g2 Error</xsl:variable>
<xsl:variable name="m_errorsubject">We Apologise for the Inconvenience</xsl:variable>
<xsl:variable name="m_followingerror">The following error occurred: </xsl:variable>
<xsl:variable name="m_morepoststitle"><xsl:value-of select="$m_postings"/></xsl:variable>
<xsl:variable name="m_postingsby"><xsl:value-of select="$m_postings"/> by </xsl:variable>
<xsl:variable name="m_newerpostings"> Newer <xsl:value-of select="$m_postings"/></xsl:variable>
<xsl:variable name="m_olderpostings">Older <xsl:value-of select="$m_postings"/></xsl:variable>
<xsl:variable name="m_NewerRegistrations">Newer Registrations &gt;&gt;</xsl:variable>
<xsl:variable name="m_OlderRegistrations">&lt;&lt; Older Registrations</xsl:variable>
<xsl:variable name="m_RegistrationsSeparater"><xsl:text> | </xsl:text></xsl:variable>
<xsl:variable name="m_NoOlderRegistrations">No Older Registrations</xsl:variable>
<xsl:variable name="m_NoNewerRegistrations">No Newer Registrations</xsl:variable>
<xsl:variable name="m_editpagetitle"><xsl:value-of select="$m_pagetitlestart"/>Edit <xsl:value-of select="$m_article"/></xsl:variable>
<xsl:variable name="m_donotpress">Please do not press this button again.</xsl:variable>
<xsl:variable name="m_atriclesubmitted">Your <xsl:value-of select="$m_article"/> has been submitted. Please be patient...</xsl:variable>
<xsl:variable name="m_preferencestitle"><xsl:value-of select="$m_pagetitlestart"/>Edit Personal Settings</xsl:variable>
<xsl:variable name="m_preferencessubject">Personal Details</xsl:variable>
<xsl:variable name="m_regconfirm"><xsl:value-of select="$m_pagetitlestart"/>Becoming a member</xsl:variable>
<xsl:variable name="m_reginprogress">Registration in process...</xsl:variable>
<xsl:variable name="m_NewUsersPageTitle"><xsl:value-of select="$m_pagetitlestart"/>New <xsl:value-of select="$m_users"/></xsl:variable>
<xsl:variable name="m_NewUsersPageHeader">New <xsl:value-of select="$m_users"/></xsl:variable>
<xsl:variable name="m_NewUsersPageExplanatory">Select a time period using the drop-down menus below, and then click on the 'Show <xsl:value-of select="$m_users"/>' button to get a list of the <xsl:value-of select="$m_users"/> that have become a member within that period.</xsl:variable>
<xsl:variable name="m_NewUsersPageSubmitButtonText">Show <xsl:value-of select="$m_users"/></xsl:variable>
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

<xsl:variable name="m_journalremoved">
This <xsl:value-of select="$m_journalposting"/> has been removed from your Personal Space. It has not been deleted, however, as it may form part of <xsl:value-of select="$m_threada"/> <xsl:value-of select="$m_thread"/> that other <xsl:value-of select="$m_users"/> have joined in. You can reinstate your <xsl:value-of select="$m_journalposting"/> on your Space by following the instructions in the <A xsl:use-attribute-sets="vm_journalremoved" HREF="{$root}DontPanic-Journal#2"><xsl:value-of select="$m_journal"/> section of the h2g2 FAQ</A> (click on the 'Help!' button to find the FAQ).
</xsl:variable>

<xsl:variable name="m_AddHomePageHeading">Add Introduction</xsl:variable>
<xsl:variable name="m_AddGuideEntryHeading">Add <xsl:value-of select="$m_article"/></xsl:variable>
<xsl:variable name="m_EditGuideEntryHeading">Update <xsl:value-of select="$m_article"/></xsl:variable>
<xsl:variable name="m_EditHomePageHeading">Update Introduction</xsl:variable>
<xsl:variable name="m_iaccept">I Accept</xsl:variable>
<xsl:variable name="m_idonotaccept">I DO NOT Accept</xsl:variable>
<xsl:variable name="m_problemcancelling">There was a problem while cancelling this account: </xsl:variable>
<xsl:variable name="m_yescancelaccount">YES - cancel this account</xsl:variable>
<xsl:variable name="m_noleaveaccountactive">NO - leave the account active</xsl:variable>
<xsl:variable name="m_warningcancellingaccount">Warning: About to cancel account</xsl:variable>
<xsl:variable name="m_sorrytermsrejectedtitle">We're very sorry</xsl:variable>
<xsl:variable name="m_clicknotifynewconv">Click here to be notified of new <xsl:value-of select="$m_threads"/> about this <xsl:value-of select="$m_article"/></xsl:variable>
<xsl:variable name="m_notifynewentriesinreviewforum">Click here to be notified of new <xsl:value-of select="$m_articles"/> in this Review Forum</xsl:variable>
<xsl:variable name="m_unmatchedpasswords">The two passwords you entered don't match.</xsl:variable>
<xsl:variable name="m_blankpassword">You need to enter a password before you can become a member.</xsl:variable>
<xsl:variable name="m_confregistration">Confirm Registration</xsl:variable>
<xsl:variable name="m_enterwordsorphrases">Enter the words or phrases to search for: </xsl:variable>
<xsl:variable name="m_unsubthreadcomplete">Request to Unsubscribe from <xsl:value-of select="$m_thread"/> Completed</xsl:variable>
<xsl:variable name="m_shareandenjoytitle">Share and Enjoy</xsl:variable>
<xsl:variable name="m_welcomemessage">Welcome message:</xsl:variable>
<xsl:variable name="m_h2g2">h2g2</xsl:variable>
<xsl:variable name="m_h2g2journaltitle"><xsl:value-of select="$m_journal"/></xsl:variable>
<xsl:variable name="m_myspacetitle">Your Personal Space</xsl:variable>
<xsl:variable name="m_registertitle">Become A Member Now! It's Totally Free!</xsl:variable>
<xsl:variable name="m_readtitle">Interesting Things to Read in the Guide</xsl:variable>
<xsl:variable name="m_talktitle">Places to Talk and Things to Talk About</xsl:variable>
<xsl:variable name="m_contributetitle">How to Contribute to the Guide</xsl:variable>
<xsl:variable name="m_feedbacktitle">Tell Us What You Think About h2g2</xsl:variable>
<xsl:variable name="m_shoptitle">Buy Some Amazing Stuff from the h2g2 Shop</xsl:variable>
<xsl:variable name="m_aboutustitle">All About the Company and the People Behind h2g2</xsl:variable>
<xsl:variable name="m_logouttitle">Sign Out of h2g2</xsl:variable>
<xsl:variable name="m_loginname">BBC member Name: </xsl:variable>
<xsl:variable name="m_h2g2password">h2g2 Password: </xsl:variable>
<xsl:variable name="m_badlogin">	The email address or password didn't match an existing h2g2 <xsl:value-of select="$m_user"/>. Perhaps you mistyped. Make sure you haven't got the Caps Lock key on, and try again.</xsl:variable>
<xsl:variable name="m_alreadyhaslogin">That h2g2 <xsl:value-of select="$m_user"/> has a BBC member name associated with it. You will have to sign in	using that BBC member name.</xsl:variable>
<xsl:variable name="m_followingproblem">The following problem occurred when trying to log you in: </xsl:variable>
<xsl:variable name="m_invalidloginname">You haven't entered a valid member name. It must be at least six characters long.</xsl:variable>
<xsl:variable name="m_invalidpassword">You haven't entered a password.</xsl:variable>
<xsl:variable name="m_loginfailed">The member name and password you tried have not been recognised. Make sure you haven't got the Caps Lock key on, and try again.</xsl:variable>
<xsl:variable name="m_loginused">That member name is already used by someone else.</xsl:variable>
<xsl:variable name="m_mustagreetoterms">You must agree to the Terms of use before you can register. Please make sure the check box is ticked.</xsl:variable>
<xsl:variable name="m_problemwithreg">There was a problem with the registration. Please try again.</xsl:variable>
<xsl:variable name="m_referencedsitesdisclaimer">Please note that the BBC is not responsible for the content of any external sites listed.</xsl:variable>
<xsl:variable name="m_usercomplaintpopuptitle"><xsl:value-of select="$m_pagetitlestart"/>Register Complaint</xsl:variable>
<xsl:variable name="m_complaintsuccessfullyregisteredmessage">Your complaint was successfully registered and will be looked at by a Moderator as soon as possible.</xsl:variable>
<xsl:variable name="m_contentalreadyhiddenmessage">This content has already been hidden, but if you still wish to register a complaint regarding it then please enter the details of your complaint below and click on 'Submit Complaint', otherwise click on 'Cancel' to close this window.</xsl:variable>
<xsl:variable name="m_contentcancelledmessage">This content has been deleted, but if you still wish to register a complaint regarding it then please enter the details of your complaint below and click on 'Submit Complaint', otherwise click on 'Cancel' to close this window.</xsl:variable>
<xsl:variable name="m_defaultcomplainttext">Please give details of your complaint here.</xsl:variable>
<xsl:variable name="m_complaintsformsubmitbuttonlabel">Submit Complaint</xsl:variable>
<xsl:variable name="m_complaintsformnextbuttonlabel">Next</xsl:variable>
<xsl:variable name="m_complaintsformcancelbuttonlabel">Cancel</xsl:variable>
<xsl:variable name="m_noconnection">Unable to connect to BBC user database.</xsl:variable>
<xsl:variable name="m_invalidbbcpassword">That BBC password is invalid. It must be at least six characters long and only contain letters and numbers.</xsl:variable>
<xsl:variable name="m_invalidbbcusername">That BBC member name was invalid. It must be at least six characters long and can only contain letters and numbers.</xsl:variable>
<xsl:variable name="m_uidused">Your details generated a non-unique ID. Please try another BBC member name.</xsl:variable>
<xsl:variable name="m_bbcpassword">BBC Password: </xsl:variable>
<xsl:variable name="m_confirmbbcpassword">Confirm BBC Password: </xsl:variable>
<xsl:variable name="m_userpagemoderatesubject">Personal Space Hidden</xsl:variable>
<xsl:variable name="m_forumstyle">Forum Style:&nbsp;</xsl:variable>
<xsl:variable name="m_forumstyleframes">Frames</xsl:variable>
<xsl:variable name="m_forumstylesingle">Single pages</xsl:variable>
<xsl:variable name="m_forumsubject">Forum Title</xsl:variable>
<xsl:variable name="m_pagetitlestart">BBC - h2g2 - </xsl:variable>
<xsl:variable name="m_articlehiddentitle"><xsl:value-of select="$m_article"/> Hidden</xsl:variable>
<xsl:variable name="m_bbcloginalreadyused">That member name is already used within h2g2 and can't be associated with another h2g2 account.</xsl:variable>
<xsl:variable name="m_newloginbutton">Sign in</xsl:variable>
<!--xsl:variable name="m_newregisterbutton">Register</xsl:variable-->
<xsl:variable name="m_newreactivatebutton">Reactivate</xsl:variable>
<xsl:variable name="m_usercomplaintnodetailsalert">Please describe the nature of your complaint in the text area provided.</xsl:variable>
<xsl:variable name="m_articledeletedtitle"><xsl:value-of select="$m_article"/> Deleted</xsl:variable>
<xsl:variable name="m_articledeletedsubject"><xsl:value-of select="$m_article"/> Deleted</xsl:variable>
<xsl:variable name="m_postsubjectremoved"><xsl:value-of select="$m_posting"/> Hidden</xsl:variable>
<xsl:variable name="m_awaitingmoderationsubject">Awaiting Moderation</xsl:variable>
<xsl:variable name="m_returntothreadspage"><xsl:value-of select="$m_thread"/> list</xsl:variable>
<xsl:variable name="m_conversationfirstsubject"><xsl:value-of select="$m_thread"/> First Subject</xsl:variable>
<xsl:variable name="m_searchtheguide">Search the Guide</xsl:variable>
<xsl:variable name="m_showeditedentries">Show <xsl:value-of select="$m_editedarticles"/></xsl:variable>
<xsl:variable name="m_showguideentries">Show <xsl:value-of select="$m_articles"/></xsl:variable>
<xsl:variable name="m_showcancelledentries">Show Cancelled <xsl:value-of select="$m_articles"/></xsl:variable>
<xsl:variable name="m_gadgetusethiswindow">Use <B>this</B> window</xsl:variable>
<xsl:variable name="m_gadgetusenewwindow">Use <B>new</B> window</xsl:variable>
<xsl:variable name="m_dropdownpleasechooseone">Please choose one</xsl:variable>
<xsl:variable name="m_ShortDateDelimiter">-</xsl:variable>
<xsl:variable name="m_RecommendEntryPageTitle">h2g2 Recommend <xsl:value-of select="$m_article"/></xsl:variable>
<xsl:variable name="m_RecommendEntryPageHeader">Recommend <xsl:value-of select="$m_articlea"/> <xsl:value-of select="$m_article"/></xsl:variable>
<xsl:variable name="m_RecommendEntryOwnEntryError">You are the author of this <xsl:value-of select="$m_article"/> and so you not allowed to recommend it yourself. You are however allowed to suggest it for recommendation by another Scout at the Peer Review forum.</xsl:variable>
<xsl:variable name="m_RecommendEntryInvalidIDError">The ID number you entered is not a valid one. Perhaps you misstyped it. Or perhaps the keyboard goblins have been re-arranging your numeral keys again.</xsl:variable>
<xsl:variable name="m_RecommendEntryWrongStatusError">You can only recommend normal <xsl:value-of select="$m_articles"/> for inclusion in the Guide, as opposed to <xsl:value-of select="$m_editedarticles"/>, Help Pages and so on.</xsl:variable>
<xsl:variable name="m_RecommendEntryUnspecifiedError">You were unable to recommend this <xsl:value-of select="$m_article"/> because the following error occured:</xsl:variable>
<xsl:variable name="m_RecommendEntryFetchEntryText">Fetch <xsl:value-of select="$m_articlea"/> <xsl:value-of select="$m_article"/> to recommend:</xsl:variable>
<xsl:variable name="m_RecommendEntryEntryIDBoxText">ID: </xsl:variable>
<xsl:variable name="m_SubbedEntryPageTitle">h2g2 Submit Subbed <xsl:value-of select="$m_article"/></xsl:variable>
<xsl:variable name="m_SubbedEntryInvalidIDError">The ID number you entered is not a valid one.</xsl:variable>
<xsl:variable name="m_SubbedEntryWrongStatusError">You can only submit the subbed version of <xsl:value-of select="$m_articlea"/> <xsl:value-of select="$m_article"/> via the Sub Editor's copy.</xsl:variable>
<xsl:variable name="m_SubbedEntryUnspecifiedError">An unspecified error occurred whilst attempting to process this submission.</xsl:variable>
<xsl:variable name="m_SubbedEntrySubmitSuccessMessage">Subbed version of this <xsl:value-of select="$m_article"/> was successfully submitted.</xsl:variable>
<xsl:variable name="m_SubbedEntryFetchEntryText">Fetch <xsl:value-of select="$m_articlea"/> <xsl:value-of select="$m_article"/>:</xsl:variable>
<xsl:variable name="m_SubbedEntryEntryIDBoxText">ID: </xsl:variable>
<xsl:variable name="m_SubAllocationPageTitle">h2g2 Sub Allocation</xsl:variable>
<xsl:variable name="m_SubAllocationPageHeader">Allocate Recommended <xsl:value-of select="$m_articles"/> to Sub-editors</xsl:variable>
<xsl:variable name="m_SubAllocationBeingProcessedPopup">Your <xsl:value-of select="$m_article"/> allocation submission is being processed, please be patient.</xsl:variable>
<xsl:variable name="m_articlereferredtitle"><xsl:value-of select="$m_article"/> Referred</xsl:variable>
<xsl:variable name="m_articleawaitingpremoderationtitle"><xsl:value-of select="$m_article"/> Waiting for Moderation</xsl:variable>
<xsl:variable name="m_legacyarticleawaitingmoderationtitle"><xsl:value-of select="$m_article"/> Waiting for Moderation</xsl:variable>
<xsl:variable name="m_shortdatedelimiter">-</xsl:variable>
<xsl:variable name="m_govolunteer">Go</xsl:variable>
<xsl:variable name="m_thiswindow">This Window</xsl:variable>
<xsl:variable name="m_newwindow">New Window</xsl:variable>
<xsl:variable name="m_otherbbcsites">Related BBC Pages</xsl:variable>
<xsl:variable name="m_editcategorisationheader">Edit Categorisation</xsl:variable>
<xsl:variable name="m_editcategorisationsubject">Edit Categorisation</xsl:variable>
<xsl:variable name="m_submitreviewforumheader">Submit for Review</xsl:variable>
<xsl:variable name="m_submitreviewforumsubject">Submit for Review</xsl:variable>
<xsl:variable name="m_whatscomingupheader">What's Coming Up on h2g2</xsl:variable>
<xsl:variable name="m_cominguprecheader">Recommended by Scouts</xsl:variable>
<xsl:variable name="m_comingupwitheditorheader">With Sub-editor</xsl:variable>
<xsl:variable name="m_comingupreturnheader">Returned from Sub-editor</xsl:variable>
<xsl:variable name="m_comingupid">ID</xsl:variable>
<xsl:variable name="m_comingupsubject">Subject</xsl:variable>
<xsl:variable name="m_rft_articlesinreviewheader"><xsl:value-of select="$m_articles"/> in Review</xsl:variable>
<xsl:variable name="m_removefromreviewforumsubject"><xsl:value-of select="$m_article"/> Successfully Removed from Review Forum</xsl:variable>
<xsl:variable name="m_sitetitle">h2g2</xsl:variable>
<xsl:variable name="m_RecommendEntryNotInReviewForum">The <xsl:value-of select="$m_article"/> must be in a recommendable Review Forum</xsl:variable>
<xsl:variable name="m_rftnoarticlesinreviewforum">There are no <xsl:value-of select="$m_articles"/> in review for this choice</xsl:variable>
<xsl:variable name="m_edittheresearcherlisttext">Edit the <xsl:value-of select="$m_user"/> List</xsl:variable>
<xsl:variable name="m_editentrylinktext">Edit Entry</xsl:variable>
<xsl:variable name="m_reviewforumdatatitle">Review Forum Data</xsl:variable>
<xsl:variable name="m_reviewforumdataname">Name: </xsl:variable>
<xsl:variable name="m_reviewforumdataurl">URL: </xsl:variable>
<xsl:variable name="m_reviewforumdata_recommend_yes">Recommendable: Yes</xsl:variable>
<xsl:variable name="m_reviewforumdata_recommend_no">Recommendable: No</xsl:variable>
<xsl:variable name="m_reviewforumdata_incubate">Incubate: </xsl:variable>
<xsl:variable name="m_reviewforumdata_edit">Edit</xsl:variable>
<xsl:variable name="m_reviewforumdata_h2g2id">Entry ID: </xsl:variable>
<xsl:variable name="m_reviewforum_entrytarget"><xsl:value-of select="$m_articles"/></xsl:variable>
<xsl:variable name="m_clickmorereviewentries">Click here to see more <xsl:value-of select="$m_articles"/></xsl:variable>
<xsl:variable name="m_submittoreviewforumbutton">Submit <xsl:value-of select="$m_article"/></xsl:variable>
<xsl:variable name="m_articlelisttext"><xsl:value-of select="$m_article"/> List</xsl:variable>
<xsl:variable name="m_notforreviewtext"> Not for Review </xsl:variable>
<xsl:variable name="m_articleisinreviewtext"><xsl:value-of select="$m_article"/> is Currently in a Review Forum</xsl:variable>
<xsl:variable name="m_editreviewtitle">Edit Review Forum</xsl:variable>
<xsl:variable name="m_postingtoolong">The <xsl:value-of select="$m_posting"/> was too long. Please cut it down and try again.</xsl:variable>
<xsl:variable name="m_entrysubmittoreviewforumsubject"><xsl:value-of select="$m_article"/> successfully submitted to Review Forum</xsl:variable>
<xsl:variable name="m_clickstopnotifynewconv">Click here to stop being notified of new <xsl:value-of select="$m_threads"/> for this <xsl:value-of select="$m_article"/></xsl:variable>
<xsl:variable name="m_stopnotifynewentriesreviewforum">Click here to stop being notified of new <xsl:value-of select="$m_articles"/> in this Review Forum</xsl:variable>
<xsl:variable name="m_ptclicktostartnewconv">Click here to start a new <xsl:value-of select="$m_thread"/></xsl:variable>
<xsl:variable name="m_ptclicktowritereply">Click here to write your reply</xsl:variable>
<xsl:variable name="m_addnewreviewforum_title">Add New Review Forum</xsl:variable>
<xsl:variable name="m_notfoundsubject">Page Not Found</xsl:variable>
<xsl:variable name="m_clickifnotredirected">Click here if you are not automatically redirected</xsl:variable>
<xsl:variable name="m_myconversationstitle">My <xsl:value-of select="$m_threads"/></xsl:variable>
<xsl:variable name="m_myconvposted">posted </xsl:variable>
<xsl:variable name="m_myconvnoposting">No <xsl:value-of select="$m_posting"/></xsl:variable>
<xsl:variable name="m_removenamesubjsuccess">Name removed from list</xsl:variable>
<xsl:variable name="m_removenamesubjfailure">Couldn't remove name from list</xsl:variable>
<xsl:variable name="m_entrynotdeletedsubj"><xsl:value-of select="$m_article"/> could not be deleted</xsl:variable>
<xsl:variable name="m_nopermissiontodeleteentry">You do not have permission to delete this <xsl:value-of select="$m_article"/>.</xsl:variable>
<xsl:variable name="m_dberrordeleteentry">There was an error accessing the database and your <xsl:value-of select="$m_article"/> could not be deleted.</xsl:variable>
<xsl:variable name="m_guideentryrestoredsubj"><xsl:value-of select="$m_article"/> Restored</xsl:variable>
<xsl:variable name="m_TheSite">h2g2</xsl:variable>
<xsl:variable name="m_confirmlogout">Are you sure you want to sign out?</xsl:variable>
<!-- DefaultRFID sets the default review forum for a site, this copy of the variable is in text as it is applicable to all H2G2 skins but not base. 2 is writing workshop -->

<xsl:variable name="DefaultRFID">2</xsl:variable>
<!-- generic terms -->
<xsl:variable name="m_user">Researcher</xsl:variable>
<xsl:variable name="m_users">Researchers</xsl:variable>
<xsl:variable name="m_usera"> a </xsl:variable>
<xsl:variable name="m_article">Guide Entry</xsl:variable>
<xsl:variable name="m_articles">Guide Entries</xsl:variable>
<xsl:variable name="m_articlea"> a </xsl:variable>
<xsl:variable name="m_articleurl">Guide+Entry</xsl:variable>
<xsl:variable name="m_editedarticle">Edited Entry</xsl:variable>
<xsl:variable name="m_editedarticles">Edited Entries</xsl:variable>
<xsl:variable name="m_uneditedarticles">Unedited Entries</xsl:variable>
<xsl:variable name="m_editedarticlea"> an </xsl:variable>
<xsl:variable name="m_editedguide">Edited Guide</xsl:variable>
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
<!-- end of messages -->

<!-- text mostly used in Alt tags -->
<xsl:variable name="alt_showoldest">Show Start of <xsl:value-of select="$m_thread"/></xsl:variable>
<xsl:variable name="alt_showolder">Show Older</xsl:variable>
<xsl:variable name="alt_atstartofconv">Already at Start of <xsl:value-of select="$m_thread"/></xsl:variable>
<xsl:variable name="alt_noolderpost">No Older <xsl:value-of select="$m_postings"/> to Show</xsl:variable>
<xsl:variable name="alt_showpostings">Show <xsl:value-of select="$m_postings"/><xsl:text> </xsl:text></xsl:variable>
<xsl:variable name="alt_nonewerpost">No Newer <xsl:value-of select="$m_postings"/> to Show</xsl:variable>
<xsl:variable name="alt_showlatestpost">Show Latest <xsl:value-of select="$m_postings"/></xsl:variable>
<xsl:variable name="alt_alreadyendconv">Already at End of <xsl:value-of select="$m_thread"/></xsl:variable>
<xsl:variable name="alt_newconversation">New <xsl:value-of select="$m_thread"/></xsl:variable>
<xsl:variable name="alt_shownewest">Show Newest <xsl:value-of select="$m_threads"/></xsl:variable>
<xsl:variable name="alt_showconvs">Show <xsl:value-of select="$m_threads"/><xsl:text> </xsl:text></xsl:variable>
<xsl:variable name="alt_showposts">Show <xsl:value-of select="$m_postings"/><xsl:text> </xsl:text></xsl:variable>
<xsl:variable name="alt_to"> to </xsl:variable>
<xsl:variable name="alt_alreadynewestconv">Already Showing the Newest <xsl:value-of select="$m_threads"/></xsl:variable>
<xsl:variable name="alt_nonewconvs">No Newer <xsl:value-of select="$m_threads"/> to Show</xsl:variable>
<xsl:variable name="alt_showoldestconv">Show Oldest <xsl:value-of select="$m_threads"/></xsl:variable>
<xsl:variable name="alt_prevpost">Previous <xsl:value-of select="$m_posting"/></xsl:variable>
<xsl:variable name="alt_noprevpost">There is no Previous <xsl:value-of select="$m_posting"/></xsl:variable>
<xsl:variable name="alt_nextpost">Next <xsl:value-of select="$m_posting"/></xsl:variable>
<xsl:variable name="alt_nonextpost">There is no Next <xsl:value-of select="$m_posting"/></xsl:variable>
<xsl:variable name="alt_prevreply">Previous Reply</xsl:variable>
<xsl:variable name="alt_replyingtothis">Replying to this <xsl:value-of select="$m_posting"/></xsl:variable>
<xsl:variable name="alt_nextreply">Next Reply</xsl:variable>
<xsl:variable name="alt_notareply">This is the First <xsl:value-of select="$m_posting"/> - it isn't a Reply</xsl:variable>
<xsl:variable name="alt_nonewerreplies">No Newer Replies</xsl:variable>
<xsl:variable name="alt_currentpost">This is the Current <xsl:value-of select="$m_posting"/></xsl:variable>
<xsl:variable name="alt_firstreply">First Reply to this <xsl:value-of select="$m_posting"/></xsl:variable>
<xsl:variable name="alt_noreplies">There are no Replies to this <xsl:value-of select="$m_posting"/></xsl:variable>
<xsl:variable name="alt_postmessage">Post Message</xsl:variable>
<xsl:variable name="alt_storejournal">Store <xsl:value-of select="$m_journal"/></xsl:variable>
<xsl:variable name="alt_nowshowing">Now Showing </xsl:variable>
<xsl:variable name="alt_show">Show </xsl:variable>
<xsl:variable name="alt_discussthis">Discuss this Entry</xsl:variable>
<xsl:variable name="alt_editthispage">Edit this Page</xsl:variable>
<xsl:variable name="alt_editthisentry">Edit this Entry</xsl:variable>
<xsl:variable name="alt_recommendthisentry">Recommend this Entry</xsl:variable>
<xsl:variable name="alt_thisentrysubbed">Return this subbed <xsl:value-of select="$m_article"/> to the Editorial staff</xsl:variable>
<xsl:variable name="alt_emailthispagetoafriend">Email this <xsl:value-of select="$m_article"/> to a Friend</xsl:variable>
<xsl:variable name="alt_keywords">Keywords to Search for</xsl:variable>
<xsl:variable name="alt_searchtheguide">Search the Guide</xsl:variable>
<xsl:variable name="alt_frontpage">Front Page</xsl:variable>
<xsl:variable name="alt_register">Become a member</xsl:variable>
<xsl:variable name="alt_myspace">My Space</xsl:variable>
<xsl:variable name="alt_dontpanic">Don't Panic! Click here for Help!</xsl:variable>
<xsl:variable name="alt_askh2g2">Ask h2g2</xsl:variable>
<xsl:variable name="alt_tellh2g2">Tell h2g2</xsl:variable>
<xsl:variable name="alt_feedbackforum">Feedback</xsl:variable>
<xsl:variable name="alt_whosonline">Who is Online</xsl:variable>
<xsl:variable name="alt_shop">Shop</xsl:variable>
<xsl:variable name="alt_preferences">Preferences</xsl:variable>
<xsl:variable name="alt_aboutus">About Us</xsl:variable>
<xsl:variable name="alt_logout">Sign out</xsl:variable>
<xsl:variable name="alt_showingoldest">Already Showing the Oldest <xsl:value-of select="$m_threads"/></xsl:variable>
<xsl:variable name="alt_noolderreplies">No Older Replies</xsl:variable>
<xsl:variable name="alt_reply">Reply</xsl:variable>
<xsl:variable name="alt_complain">Click here to register a complaint about this <xsl:value-of select="$m_posting"/></xsl:variable>
<xsl:variable name="alt_logotext">h2g2 Front Page</xsl:variable>
<xsl:variable name="alt_addjournal">Add <xsl:value-of select="$m_journalposting"/></xsl:variable>
<xsl:variable name="alt_previewmess">Preview Message</xsl:variable>
<xsl:variable name="alt_postmess">Post Message</xsl:variable>
<xsl:variable name="alt_contentofguideentry">Contents of your <xsl:value-of select="$m_article"/></xsl:variable>
<xsl:variable name="alt_previewhowlook">Preview how this <xsl:value-of select="$m_article"/> will Look</xsl:variable>
<xsl:variable name="alt_storethis">Store this as a New <xsl:value-of select="$m_article"/></xsl:variable>
<xsl:variable name="alt_clickherehelpentry">Click here for help on how to write your <xsl:value-of select="$m_article"/></xsl:variable>
<xsl:variable name="alt_mapclickhereplaintexthelpentry">How to write Entries in Plain Text</xsl:variable>
<xsl:variable name="alt_macplickhereguidehelpentry">How to write Entries in GuideML</xsl:variable>
<xsl:variable name="alt_mapclickheremaphelpentry">How to add map locations to your Entry</xsl:variable>
<xsl:variable name="alt_subreturntoconv">Return+to+the+<xsl:value-of select="$m_threadurl"/></xsl:variable>
<xsl:variable name="alt_subreturntoarticle">Return+to+the+<xsl:value-of select="$m_articleurl"/></xsl:variable>
<xsl:variable name="alt_subreturntospace">Return+to+your+Personal+Space</xsl:variable>
<xsl:variable name="alt_subreturntopostlist">Return+to+the+<xsl:value-of select="$m_postingurl"/>+list</xsl:variable>
<xsl:variable name="alt_login">Sign in</xsl:variable>
<xsl:variable name="alt_searchbutton">Search h2g2</xsl:variable>
<xsl:variable name="alt_inviteuser">Invite Someone to Join h2g2</xsl:variable>
<xsl:variable name="alt_onlineform">Select an Ordering</xsl:variable>
<xsl:variable name="alt_onlineorderbyid">Order by <xsl:value-of select="$m_user"/> ID</xsl:variable>
<xsl:variable name="alt_onlineorderbyname">Order by Username</xsl:variable>
<xsl:variable name="alt_onlineorderbyregistered">Order by Membership Date</xsl:variable>
<xsl:variable name="alt_changepasswordlogin">Change Password and Sign In</xsl:variable>
<xsl:variable name="alt_read">Read</xsl:variable>
<xsl:variable name="alt_talk">Talk</xsl:variable>
<xsl:variable name="alt_contribute">Contribute</xsl:variable>
<xsl:variable name="alt_preferencestitle">Change your Personal Details and Settings</xsl:variable>
<xsl:variable name="alt_discussthistitle">Click here to Start a New <xsl:value-of select="$m_thread"/> for this <xsl:value-of select="$m_article"/></xsl:variable>
<xsl:variable name="alt_editentry">Edit Entry</xsl:variable>
<xsl:variable name="alt_help">Help!</xsl:variable>
<xsl:variable name="alt_bbconlinehome">BBCi home</xsl:variable>
<xsl:variable name="alt_AllocateEntriesToThisSub">Allocate <xsl:value-of select="$m_articles"/> to this Sub-editor</xsl:variable>
<xsl:variable name="alt_MonthSummarySub">A Month of h2g2</xsl:variable>
<xsl:variable name="alt_notforreview">Not for Review</xsl:variable>
<xsl:variable name="alt_submittoreviewforum">Submit for Review</xsl:variable>
<xsl:variable name="alt_returntoreviewforum">Return+to+the+Review+Forum</xsl:variable>
<xsl:variable name="alt_rf_showconvs">Show <xsl:value-of select="$m_articles"/><xsl:text> </xsl:text></xsl:variable>
<xsl:variable name="alt_rf_shownewest">Go to Beginning of List</xsl:variable>
<xsl:variable name="alt_rf_alreadynewestconv">Already Showing the Latest <xsl:value-of select="$m_articles"/></xsl:variable>
<xsl:variable name="alt_rf_nonewconvs">No More <xsl:value-of select="$m_articles"/> to Show</xsl:variable>
<xsl:variable name="alt_rf_showoldestconv">Go to End of List</xsl:variable>
<xsl:variable name="alt_rf_noolderconv">No More <xsl:value-of select="$m_articles"/> to Show</xsl:variable>
<xsl:variable name="alt_rf_showingoldest">Already Showing the Last <xsl:value-of select="$m_articles"/></xsl:variable>
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

<!-- end of alt tags -->
</xsl:stylesheet>
