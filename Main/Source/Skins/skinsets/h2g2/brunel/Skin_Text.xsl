<?xml version='1.0' encoding='ISO-8859-1' ?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]><xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0" 
                xmlns:msxsl="urn:schemas-microsoft-com:xslt" 
                xmlns:local="#local-functions" 
                xmlns:s="urn:schemas-microsoft-com:xml-data" 
                xmlns:dt="urn:schemas-microsoft-com:datatypes">

<xsl:import href="../../../base/text.xsl"/>
<!--ALTERED FOR TESTING!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
For Live/DEV: <xsl:import href="../../../base/text.xsl"/>
For LOCAL:    <xsl:import href="Q:\h2g2\dna\ref\text.xsl"/>
--> 
<!-- Attribute sets only used in Brunel text: -->
<xsl:attribute-set name="nm_enheditorhelp" use-attribute-sets="usereditlinks"/>
<xsl:attribute-set name="nm_enhemoticonhelp" use-attribute-sets="addthreadlinks"/>
<xsl:variable name="m_SearchResultsSubjectColumnName">TITLE</xsl:variable>
<xsl:variable name="m_SearchResultsIDColumnName">ID</xsl:variable>
<xsl:variable name="m_SearchResultsStatusColumnName">STATUS</xsl:variable>
<xsl:variable name="m_SearchResultsScoreColumnName">RELEVANCE</xsl:variable>
<xsl:variable name="m_SearchResultsSiteColumnName">COMMUNITY</xsl:variable>
<xsl:variable name="m_prevresults">Previous Results</xsl:variable>
<xsl:variable name="m_nextresults">Next Results</xsl:variable>
<xsl:variable name="m_prevlist">Previous List</xsl:variable>
<xsl:variable name="m_nextlist">Next List</xsl:variable>
<xsl:variable name="m_subrequestcomplete">Request completed</xsl:variable>
<xsl:variable name="m_articleawaitingpremoderationtitle">Entry Awaiting Moderation</xsl:variable>
<xsl:variable name="m_legacyarticleawaitingmoderationtitle">Entry Awaiting Moderation</xsl:variable>
<xsl:variable name="m_firsttotalk">To be the first person to discuss this entry, click on the "Start a new conversation" link above.</xsl:variable>
<xsl:variable name="m_firsttoleavemessage">To be the first person to leave a message, click on the "Leave a Message" link above.</xsl:variable>
<xsl:variable name="m_discussentry">Start a new conversation</xsl:variable>
<xsl:variable name="m_leavemessage">Leave a Message</xsl:variable>
<xsl:variable name="m_replytothispost">
														<img src="{$imagesource}arrowh_pos.gif" width="3" height="9" alt="" border="0" hspace="3" />
														<b>Reply</b>
</xsl:variable>
<xsl:variable name="m_messagecentre">Message Centre</xsl:variable>
<xsl:variable name="m_aboutme">About Me</xsl:variable>
<xsl:variable name="m_articleisinreviewsubject"><xsl:value-of select="$m_articleisinreviewtext"/></xsl:variable>
<xsl:variable name="m_articleisnew">You are now creating a new guide entry.</xsl:variable>
<xsl:variable name="m_whatentrylooklike">This is a preview of the Entry:</xsl:variable>
<xsl:variable name="m_AddHomePageHeading_sub">adding your introduction</xsl:variable>
<xsl:variable name="m_AddGuideEntryHeading_sub">adding a guide entry</xsl:variable>
<xsl:variable name="m_EditHomePageHeading_sub">updating your introduction</xsl:variable>
<xsl:variable name="m_EditGuideEntryHeading_sub">updating a guide entry</xsl:variable>
<xsl:variable name="m_urnow">You are now </xsl:variable>
<xsl:variable name="m_signupq">Become a member</xsl:variable>
<xsl:variable name="m_loginq">Sign in</xsl:variable>
<xsl:variable name="m_nologuser">No-one Logged In: </xsl:variable>
<xsl:variable name="m_barleyhome">BBC Homepage</xsl:variable>
<xsl:variable name="m_barleytext">Text only</xsl:variable>
<xsl:variable name="m_barleymybbc">my BBC</xsl:variable>
<xsl:variable name="m_barleycontact">Contact Us</xsl:variable>
<xsl:variable name="m_barleyhelp">Help</xsl:variable>
<xsl:variable name="m_barleylikeq">Like this page?</xsl:variable>
<xsl:variable name="m_nav_home"><xsl:value-of select="$alt_frontpage"/></xsl:variable>
<xsl:variable name="m_nav_perspace"><xsl:value-of select="$alt_myspace"/></xsl:variable>
<xsl:variable name="m_nav_logout"><xsl:value-of select="$alt_logout"/></xsl:variable>
<xsl:variable name="m_nav_reg"><xsl:value-of select="$alt_register"/></xsl:variable>
<xsl:variable name="m_nav_login"><xsl:value-of select="$alt_login"/></xsl:variable>
<xsl:variable name="m_nav_who">Who's Online</xsl:variable>
<xsl:variable name="m_nav_add">Add Entry</xsl:variable>
<xsl:variable name="m_nav_pref"><xsl:value-of select="$alt_preferences"/></xsl:variable>
<xsl:variable name="m_nav_help">h2g2 Help</xsl:variable>
<xsl:variable name="m_nav_feedbk"><xsl:value-of select="$alt_feedbackforum"/></xsl:variable>
<xsl:variable name="m_noagreetermsconds">You haven't agreed to the standard terms and conditions for this site.</xsl:variable>
<xsl:variable name="m_nojournalunreg">We're sorry, but you can't have a journal without being a member.</xsl:variable>
<xsl:variable name="m_jumptoreply">Jump To Reply Field</xsl:variable>
<xsl:variable name="m_jumptoedit">Jump To Edit Area</xsl:variable>
<xsl:variable name="m_enherrornojs">Sorry, the Enhanced Editor will not work on this particular browser.</xsl:variable>
<xsl:variable name="m_thread_postconv">You are posting to a conversation</xsl:variable>
<xsl:variable name="m_thread_replyto">You are replying to: </xsl:variable>
<xsl:variable name="m_thread_replytothismsg">You are replying to this message:</xsl:variable>
<xsl:variable name="m_thread_curunable">You are currently unable to post</xsl:variable>
<xsl:variable name="m_thread_dberror">There was a database error</xsl:variable>
<xsl:variable name="m_thread_postnotallow">You have attempted to post to a review forum this is not allowed.</xsl:variable>
<xsl:variable name="m_postedby">Posted By: </xsl:variable>
<xsl:variable name="m_previewurjournal">Previewing your Journal Entry</xsl:variable>
<xsl:variable name="m_previewurpost">Previewing your Post</xsl:variable>
<xsl:variable name="m_previewurentry">Previewing the Entry</xsl:variable>
<xsl:variable name="m_freply">Reply:</xsl:variable>
<xsl:variable name="m_fposting">Posting:</xsl:variable>
<xsl:variable name="m_fjournalentry">Journal Entry:</xsl:variable>
<xsl:variable name="m_edentry_title">Title of Entry</xsl:variable>
<xsl:variable name="m_edentry_body">Body of Entry</xsl:variable>
<xsl:variable name="m_aplhaindex_title">Alphabetical Index of Guide Entries</xsl:variable>
<xsl:variable name="m_aplhaindex_for">Index For: </xsl:variable>
<xsl:variable name="m_aplhaindex_head">Alphabetical Index</xsl:variable>
<xsl:variable name="m_aplhaindex_notletter"> = Entries that do not start with a letter</xsl:variable>
<xsl:variable name="m_guideid">Guide ID:</xsl:variable>
<xsl:variable name="m_created">Created: </xsl:variable>
<xsl:variable name="m_entry_convtopics">CONVERSATION TOPICS FOR THIS ENTRY:</xsl:variable>
<xsl:variable name="m_entry_moderate">MODERATE THIS ENTRY:</xsl:variable>
<xsl:variable name="m_entry_data">ENTRY DATA</xsl:variable>
<xsl:variable name="m_researcher_data">RESEARCHER DATA</xsl:variable>
<xsl:variable name="m_entry_referenced">Referenced Entries:</xsl:variable>
<xsl:variable name="m_entry_referencedusers">Referenced Researchers:</xsl:variable>
<xsl:variable name="m_entry_errorinarticle">XML Parsing Error in article</xsl:variable>
<xsl:variable name="m_entry_errorinarticlefail">Please fail this entry and continue moderating.</xsl:variable>
<xsl:variable name="m_entry_errornotypealloc">You currently have no entries of this type allocated to you for moderation. Select a type and click 'Process' to be allocated the next entry of that type waiting to be moderated.</xsl:variable>
<xsl:variable name="m_entry_errornotypeawait">Currently there are no entries of the specified type awaiting moderation.</xsl:variable>
<xsl:variable name="m_entry_errornotypeallocreq">You have no entry allocated to you for moderation currently. Click on 'Process' below to be allocated the next entry requiring moderation.</xsl:variable>
<xsl:variable name="m_entry_referredby">Referred by </xsl:variable>
<xsl:variable name="m_entry_autoreferral">Auto Referral</xsl:variable>
<xsl:variable name="m_entry_showhistory">Show History</xsl:variable>
<xsl:variable name="m_entry_complaintfrom">Complaint from </xsl:variable>
<xsl:variable name="m_entry_researcher">Researcher </xsl:variable>
<xsl:variable name="m_entry_anoncomplaint">Anonymous Complainant</xsl:variable>
<xsl:variable name="m_entry_notes">Notes</xsl:variable>
<xsl:variable name="m_entry_modhome">Moderation Home Page</xsl:variable>
<xsl:variable name="m_entry_textcustomemail">Text for Custom Email</xsl:variable>
<xsl:variable name="m_entry_brokenurllist">If this entry failed due to broken URLs, please list them here, along with the reason why the URL failed, so the user can correct the article</xsl:variable>
<xsl:variable name="m_entry_discuss">Start a new conversation</xsl:variable>
<xsl:variable name="m_entry_leavemsg">Leave a Message</xsl:variable>
<xsl:variable name="m_threadstable_title">TITLE</xsl:variable>
<xsl:variable name="m_threadstable_last">LATEST POST</xsl:variable>
<xsl:variable name="m_threadstable_prevmsg">Show More Messages</xsl:variable>
<xsl:variable name="m_threadstable_nextmsg">More Conversations</xsl:variable>
<xsl:variable name="m_threadstable_noaboutme">Sorry, but this user must write something about themself before you can leave them a message.</xsl:variable>
<xsl:variable name="m_threadstable_checklater">Please check back at a later time.</xsl:variable>
<xsl:variable name="m_threadstable_alertme"><xsl:value-of select="$m_clicksubforum"/></xsl:variable>
<xsl:variable name="m_threadstable_alertmestop"><xsl:value-of select="$m_clickunsubforum"/></xsl:variable>
<xsl:variable name="m_cat_title">Category Index of Guide Entries</xsl:variable>
<xsl:variable name="m_cat_cantfindq">Can't find what you're looking for?</xsl:variable>
<xsl:variable name="m_home_head">Welcome to h2g2</xsl:variable>
<xsl:variable name="m_home_regnow">BECOME A MEMBER NOW</xsl:variable>
<xsl:variable name="m_home_helpbuildguide">AND HELP BUILD<br />THE GUIDE</xsl:variable>
<xsl:variable name="m_home_regdetailsa">Post to Conversations</xsl:variable>
<xsl:variable name="m_home_regdetailsb">Write your own Guide Entries</xsl:variable>
<xsl:variable name="m_home_regdetailsc">Set up your own Personal Space</xsl:variable>
<xsl:variable name="m_home_regdetailsd">Tailor the site to your own tastes</xsl:variable>
<xsl:variable name="m_home_editedguide">THE EDITED GUIDE</xsl:variable>
<xsl:variable name="m_userdata">Name: </xsl:variable>
<xsl:variable name="m_userdatano">Researcher: </xsl:variable>
<xsl:variable name="m_userdataref">Researcher </xsl:variable>
<xsl:variable name="m_logouthead">Sign out</xsl:variable>
<xsl:variable name="m_researchersub">Researcher: </xsl:variable>
<xsl:variable name="m_morepages_id">ID</xsl:variable>
<xsl:variable name="m_morepages_title">TITLE</xsl:variable>
<xsl:variable name="m_morepages_status">STATUS</xsl:variable>
<xsl:variable name="m_morepages_site">COMMUNITY</xsl:variable>
<xsl:variable name="m_morepages_created">CREATED</xsl:variable>
<xsl:variable name="m_morepages_editkey"> = Edit</xsl:variable>
<xsl:variable name="m_morepages_uncancelkey"> = Uncancel</xsl:variable>
<xsl:variable name="alt_morepages_uncancel">Uncancel</xsl:variable>
<xsl:variable name="alt_morepages_edit">Edit</xsl:variable>
<xsl:variable name="m_morepages_showmore">Show more of My Edited Guide Entries</xsl:variable>
<xsl:variable name="m_moreposts_head">Forum Postings</xsl:variable>
<xsl:variable name="m_threads_msglistof">Message Listings of </xsl:variable>
<xsl:variable name="m_threads_fstitle_art"><xsl:value-of select="$m_returntothreadspage"/></xsl:variable>
<xsl:variable name="m_threads_fstitle_jour">Journal Listings</xsl:variable>
<xsl:variable name="m_threads_fstitle_user">Message Centre Listings</xsl:variable>
<xsl:variable name="m_threads_fstitle_rev"><xsl:value-of select="$m_threads_fstitle_art"/></xsl:variable>
<xsl:variable name="m_multiposts_head"><xsl:value-of select="$m_forum"/></xsl:variable>
<xsl:variable name="m_multiposts_title">A <xsl:value-of select="$m_multiposts_head"/></xsl:variable>
<xsl:variable name="alt_gadget_parent">The Parent Posting, to Which This is a Reply</xsl:variable>
<xsl:variable name="alt_gadget_oldersib">An Older Reply to the Parent Posting</xsl:variable>
<xsl:variable name="alt_gadget_this">This Posting</xsl:variable>
<xsl:variable name="alt_gadget_youngsib">A Newer Reply to the Parent Posting</xsl:variable>
<xsl:variable name="alt_gadget_gchild">The First Reply to This Posting</xsl:variable>
<xsl:variable name="alt_gadget_example">Navigation Example</xsl:variable>
<xsl:variable name="alt_gadget_complaint">Click to Make a Complaint</xsl:variable>
<xsl:variable name="m_gadget_key">Key</xsl:variable>
<xsl:variable name="m_gadget_a">A: An older reply to the parent Posting</xsl:variable>
<xsl:variable name="m_gadget_b">B: The parent Posting, to which this is a reply</xsl:variable>
<xsl:variable name="m_gadget_c">C: A newer reply to the parent posting</xsl:variable>
<xsl:variable name="m_gadget_d">D: The first reply to this Posting</xsl:variable>
<xsl:variable name="m_gadget_complaint">Click on this icon to make a complaint about a specific Posting</xsl:variable>
<xsl:variable name="m_jbartitle_conv"><xsl:value-of select="$m_jumpbar_myconv"/></xsl:variable>
<xsl:variable name="m_jbartitle_msg"><xsl:value-of select="$m_jumpbar_mymess"/></xsl:variable>
<xsl:variable name="m_jbartitle_jour"><xsl:value-of select="$m_jumpbar_myjournal"/></xsl:variable>
<xsl:variable name="m_jbartitle_ents"><xsl:value-of select="$m_jumpbar_myentries"/></xsl:variable>
<xsl:variable name="m_jbartitle_abme"><xsl:value-of select="$m_jumpbar_aboutme"/></xsl:variable>
<xsl:variable name="m_jbartitle_frie"><xsl:value-of select="$m_jumpbar_myfriends"/></xsl:variable>
<xsl:variable name="m_jbartitle_link"><xsl:value-of select="$m_jumpbar_mylinks"/></xsl:variable>
<xsl:variable name="alt_jbartitle_conv">My Conversations</xsl:variable>
<xsl:variable name="alt_jbartitle_msg">My Message Centre</xsl:variable>
<xsl:variable name="alt_jbartitle_jour">My Journal</xsl:variable>
<xsl:variable name="alt_jbartitle_ents">My Guide Entries</xsl:variable>
<xsl:variable name="alt_jbartitle_abme">About Me</xsl:variable>
<xsl:variable name="alt_badge_subed">Sub Editor</xsl:variable>
<xsl:variable name="alt_badge_ace">Ace</xsl:variable>
<xsl:variable name="alt_badge_fres">Field Researcher</xsl:variable>
<xsl:variable name="alt_badge_guru">Guru</xsl:variable>
<xsl:variable name="alt_badge_scout">Scout</xsl:variable>
<xsl:variable name="alt_badge_ed">Editor</xsl:variable>
<xsl:variable name="alt_badge_comart">Community Artist</xsl:variable>
<xsl:variable name="alt_badge_postr">Post Reporter</xsl:variable>
<xsl:variable name="alt_badge_trans">Translator</xsl:variable>
<xsl:variable name="alt_psposts_unsub">Unsubscribe</xsl:variable>
<xsl:variable name="m_psposts_topic">CONVERSATION</xsl:variable>
<xsl:variable name="m_psposts_site"><xsl:value-of select="$m_morepages_site"/></xsl:variable>
<xsl:variable name="m_psposts_lpostd">LATEST POST</xsl:variable>
<xsl:variable name="m_psposts_lreply">LATEST REPLY</xsl:variable>
<xsl:variable name="m_psposts_prevconv">Show More Conversations</xsl:variable>
<xsl:variable name="m_psposts_unsubkey"> = Unsubscribe</xsl:variable>
<xsl:variable name="m_psjour_addent">Add a journal entry</xsl:variable>
<xsl:variable name="m_psjour_showmore">Show more of My Journal Entries</xsl:variable>
<xsl:variable name="m_psjour_time">Time: </xsl:variable>
<xsl:variable name="m_psjour_delent">Remove this Journal Entry from your Space</xsl:variable>
<xsl:variable name="m_psent_recent">Recent Guide Entries:</xsl:variable>
<xsl:variable name="m_psent_titile"><xsl:value-of select="$m_morepages_title"/></xsl:variable>
<xsl:variable name="m_psent_id"><xsl:value-of select="$m_morepages_id"/></xsl:variable>
<xsl:variable name="m_psent_site"><xsl:value-of select="$m_morepages_site"/></xsl:variable>
<xsl:variable name="m_psent_status"><xsl:value-of select="$m_morepages_status"/></xsl:variable>
<xsl:variable name="m_psent_created"><xsl:value-of select="$m_morepages_created"/></xsl:variable>
<xsl:variable name="m_psent_showmore">Show more of My Guide Entries</xsl:variable>
<xsl:variable name="m_psent_createnew">Create New Entry</xsl:variable>
<xsl:variable name="m_psent_edited">Edited</xsl:variable>
<xsl:variable name="m_psaprv_recented">Recent Edited Guide Entries:</xsl:variable>
<xsl:variable name="m_psaprv_title"><xsl:value-of select="$m_morepages_title"/></xsl:variable>
<xsl:variable name="m_psaprv_id"><xsl:value-of select="$m_morepages_id"/></xsl:variable>
<xsl:variable name="m_psaprv_site"><xsl:value-of select="$m_morepages_site"/></xsl:variable>
<xsl:variable name="m_psaprv_created"><xsl:value-of select="$m_morepages_created"/></xsl:variable>
<xsl:variable name="m_psabme_welcome">Welcome to the Personal Space of </xsl:variable>
<xsl:variable name="m_psabme_welcomer">Welcome to the Personal Space of Researcher </xsl:variable>
<xsl:variable name="m_psabme_uwelcome">Welcome, </xsl:variable>
<xsl:variable name="m_psabme_uwelcomer">Welcome, Researcher </xsl:variable>
<xsl:variable name="m_psabme_name">Name: </xsl:variable>
<xsl:variable name="m_psabme_resno">Researcher Number: </xsl:variable>
<xsl:variable name="m_researcher_badges">VOLUNTEER BADGES</xsl:variable>
<xsl:variable name="m_logintitle">Sign in</xsl:variable>
<xsl:variable name="m_loginhead">h2g2 Sign in</xsl:variable>
<xsl:variable name="m_login_welcome">Welcome back.</xsl:variable>
<xsl:variable name="m_login_welcomenew">Welcome to h2g2. You're become a member now, so the 'My Space' button will take you to your personal space, where you can write something about yourself.</xsl:variable>
<xsl:variable name="m_login_a">Choose a username of at least 6 characters with no spaces and no punctuation. Please note this will also be case sensitive.</xsl:variable>
<xsl:variable name="m_login_atitle">BBC Username:</xsl:variable>
<xsl:variable name="m_login_b">Choose a password of at least 6 characters with no spaces and no punctuation. Please note this will also be case sensitive.</xsl:variable>
<xsl:variable name="m_login_btitle">BBC Password:</xsl:variable>
<xsl:variable name="m_login_c">Confirm your password.</xsl:variable>
<xsl:variable name="m_login_ctitle">Re-Enter Password:</xsl:variable>
<xsl:variable name="m_login_d">Enter your email address, so we can send you your details if you forget them.</xsl:variable>
<xsl:variable name="m_login_dtitle">Email Address:</xsl:variable>
<xsl:variable name="m_login_e"> Always remember me on this computer</xsl:variable>
<xsl:variable name="m_login_username">Username:</xsl:variable>
<xsl:variable name="m_login_password">Password:</xsl:variable>
<xsl:variable name="m_login_forgotpwd">Forgotten Password?</xsl:variable>
<xsl:variable name="m_rf_datahead">REVIEW FORUM DATA</xsl:variable>
<xsl:variable name="m_rf_subhead_name">Name:</xsl:variable>
<xsl:variable name="m_rf_subhead_url">URL:</xsl:variable>
<xsl:variable name="m_rf_subhead_reccomend">Recommendable:</xsl:variable>
<xsl:variable name="m_rf_subhead_reccomendy">Yes</xsl:variable>
<xsl:variable name="m_rf_subhead_reccomendn">No</xsl:variable>
<xsl:variable name="m_rf_subhead_incubate">Incubate period:</xsl:variable>
<xsl:variable name="m_rf_subhead_incubated"> days</xsl:variable>
<xsl:variable name="m_rf_entrev">GUIDE ENTRIES IN REVIEW:</xsl:variable>
<xsl:variable name="m_rf_entrevblurb">Listed here are the most recent Guide Entries submitted for review:</xsl:variable>
<xsl:variable name="m_search_title">Search</xsl:variable>
<xsl:variable name="m_search_titledata">Advanced</xsl:variable>
<xsl:variable name="m_search_inforesults">Results For: </xsl:variable>
<xsl:variable name="m_search_infonotalpha">Entries that do not start with a letter.</xsl:variable>
<xsl:variable name="m_search_infoblurb">Use this page to search the Guide</xsl:variable>
<xsl:variable name="m_search_resultsfoundin">The following results were found in </xsl:variable>
<xsl:variable name="m_search_resultsfoundout">These results were found in other sites:</xsl:variable>
<xsl:variable name="m_search_againq">Search Again</xsl:variable>
<xsl:variable name="skipdivider"><b> | </b></xsl:variable>
<xsl:variable name="m_home_morelink">More &gt;&gt;</xsl:variable>
<xsl:variable name="m_searchsubject">Search h2g2</xsl:variable>
<xsl:variable name="m_jumpbar_myconv"><xsl:choose><xsl:when test="$ownerisviewer=1">MY&nbsp;CONVERSATIONS</xsl:when><xsl:otherwise>CONVERSATIONS</xsl:otherwise></xsl:choose></xsl:variable>
<xsl:variable name="m_jumpbar_mymess"><xsl:choose><xsl:when test="$ownerisviewer=1">MY&nbsp;MESSAGES</xsl:when><xsl:otherwise>MESSAGES</xsl:otherwise></xsl:choose></xsl:variable>
<xsl:variable name="m_jumpbar_myjournal"><xsl:choose><xsl:when test="$ownerisviewer=1">MY&nbsp;JOURNAL</xsl:when><xsl:otherwise>JOURNAL</xsl:otherwise></xsl:choose></xsl:variable>
<xsl:variable name="m_jumpbar_myentries"><xsl:choose><xsl:when test="$ownerisviewer=1">MY&nbsp;GUIDE&nbsp;ENTRIES</xsl:when><xsl:otherwise>GUIDE&nbsp;ENTRIES</xsl:otherwise></xsl:choose></xsl:variable>
<xsl:variable name="m_jumpbar_aboutme"><xsl:choose><xsl:when test="$ownerisviewer=1">ABOUT&nbsp;ME</xsl:when><xsl:otherwise>ABOUT&nbsp;THIS&nbsp;RESEARCHER</xsl:otherwise></xsl:choose></xsl:variable>
<xsl:variable name="m_jumpbar_myfriends"><xsl:choose><xsl:when test="$ownerisviewer=1">MY&nbsp;FRIENDS</xsl:when><xsl:otherwise>FRIENDS</xsl:otherwise></xsl:choose></xsl:variable>
<xsl:variable name="m_jumpbar_mylinks"><xsl:choose><xsl:when test="$ownerisviewer=1">MY&nbsp;BOOKMARKS</xsl:when><xsl:otherwise>BOOKMARKS</xsl:otherwise></xsl:choose>
</xsl:variable>
<xsl:variable name="m_nosuchguideentry">No Such Guide Entry</xsl:variable>
<xsl:variable name="m_peerreview">Peer Review</xsl:variable>

<xsl:template name="m_login_noaccnt">If you are not a member of H2G2 then <a xsl:use-attribute-sets="nm_login_noaccnt" href="{$registerlink}">create your membership</a>.</xsl:template>
<xsl:template name="m_login_accnt">If you are already a member of H2G2, go straight to <a xsl:use-attribute-sets="nm_login_accnt" href="{$signinlink}">Sign in</a>.</xsl:template>
<xsl:template name="m_home_lue">The only unconventional guide to <a xsl:use-attribute-sets="nm_home_lue" href="C72">Life</a>, <a xsl:use-attribute-sets="nm_home_lue" href="C73">The Universe</a> and <a xsl:use-attribute-sets="nm_home_lue" href="C74">Everything</a> which is written by thousands of people.</xsl:template>
<xsl:template name="m_home_regdetails"><a xsl:use-attribute-sets="nm_home_regdetails" href="Register">Registration</a> is free and it means you can:</xsl:template>

<!-- IL start -->
<xsl:variable name="m_UserEditHouseRulesDiscl">Remember, when you contribute to the Guide you are giving the BBC permission to use your contribution in a variety of ways. See the <a xsl:use-attribute-sets="nm_usereditpagehouserulesdisclaimer" HREF="{$root}Terms">Terms and Conditions</a> for more information.</xsl:variable>
<!--xsl:template name="m_usereditpagehouserulesdisclaimer">
Remember, when you contribute to the Guide you are giving the BBC permission to use your contribution in a variety of ways. See the <a xsl:use-attribute-sets="nm_usereditpagehouserulesdisclaimer" HREF="{$root}Terms">Terms and Conditions</a> for more information.
</xsl:template-->
<!-- IL end -->

<xsl:template name="m_submitentryblurb">
<font xsl:use-attribute-sets="subheaderfont" class="postxt"><b>Submitting your Guide Entry for official approval</b></font><br /><br />
<P>This Guide Entry has already been submitted to the Editors for approval. If you want to make any changes to it though, go right ahead, because they will always look at the most recent version of any entry before approving it.</P>
<P>However if you've changed your mind and don't want the Editors to consider your Guide Entry and would rather muck around with it until you're happier, then just press the button below and it will be taken off the list of submitted articles.</P>
</xsl:template>

<!-- IL start -->
<!--xsl:template name="m_usereditwarning">
Please be very careful if you want to post an email address or instant messaging number, as you may receive lots of emails or messages. See the <a xsl:use-attribute-sets="nm_usereditwarning" href="{$root}HouseRules">House Rules</a> for more information.
</xsl:template-->
<!-- IL end -->

<xsl:template name="m_welcomebackuser">
	<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>Researcher: <a xsl:use-attribute-sets="nm_welcomebackuser"><xsl:attribute name="href"><xsl:value-of select="$root"/><xsl:value-of select="$pageui_myhome"/></xsl:attribute>
<xsl:value-of select="substring(VIEWING-USER/USER/USERNAME,1,14)" /><xsl:if test="string-length(VIEWING-USER/USER/USERNAME) &gt; 14">...</xsl:if></a>
</xsl:template>



<xsl:template name="m_brunelpagebottomcomplaint">
	<font xsl:use-attribute-sets="smallfont">
		<b>Disclaimer </b><br /><br />
    <xsl:choose>
      <xsl:when test="/H2G2/@TYPE='ARTICLE' and not(/H2G2/ARTICLE/ARTICLEINFO/STATUS/@TYPE='1' or /H2G2/ARTICLE/ARTICLEINFO/STATUS/@TYPE='9')">
        <xsl:call-template name="m_pagebottomarticledisclaimer"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="m_pagebottomcomplaint"/>
      </xsl:otherwise>
    </xsl:choose>
		<br /><br /><br /><br />
		
		<!--a href="http://www.bbc.co.uk/terms/">BBC <xsl:text disable-output-escaping="yes">&amp;copy;</xsl:text> MMIV</a>
		<br/><br/>
			<a href="/dna/hub/">Powered by DNA, the BBC's community website engine</a-->
			<xsl:call-template name="barley_footer"/>
	</font>
</xsl:template>

<xsl:template name="m_enheditorhelp">	<a href="{$root}DontPanic-Entries" target="_blank" xsl:use-attribute-sets="nm_enheditorhelp">How to create or edit a Guide Entry</a></xsl:template>
<xsl:template name="m_threadeditorhelp">	<a href="{$root}DontPanic-Forums" target="_blank" xsl:use-attribute-sets="nm_enheditorhelp">How to write a Conversation Posting</a></xsl:template>
<xsl:template name="m_enhemoticonhelp">For a full list of smileys you can use, please see the <a href="{$root}Smiley" target="_blank" xsl:use-attribute-sets="addthreadlinks"><b>Full Smiley Index</b></a>.</xsl:template>
<xsl:template name="m_searchfailed"><img src="{$imagesource}t.gif" width="10" height="5" alt="" />We're sorry, but your search for '<xsl:value-of select="SEARCHTERM"/>' didn't find any matches.<br /><br /><br /></xsl:template>
<xsl:template name="m_bbcloginblurb">
<P>This is where you can sign in to h2g2 (if you want to create a new account, first you need to <a xsl:use-attribute-sets="nm_bbcloginblurb"><xsl:call-template name="regpassthroughhref"><xsl:with-param name="url">Register</xsl:with-param></xsl:call-template>become a member</a>). Please note you need to have cookies enabled in your browser for this to work. If you have problems, then please email <A xsl:use-attribute-sets="nm_bbcloginblurb" HREF="mailto:h2g2.support@bbc.co.uk">h2g2.support@bbc.co.uk</A> with as many details as you can give us, and we'll get back to you as soon as we can.</P>
<P>To sign in, simply enter your BBC member name (<I>not</I> your h2g2 Nickname) and your BBC password. <B>Your BBC member name and password are case sensitive.</B> If you have a BBC account but you haven't logged in to h2g2 before, you may be asked to accept our Terms and Conditions.</P>
<P><B>Note:</B> If you have a pre-BBC h2g2 account, then you need to convert your account <a xsl:use-attribute-sets="nm_bbcloginblurb"><xsl:call-template name="regpassthroughhref"><xsl:with-param name="url">RegReturn</xsl:with-param></xsl:call-template>here</a>.</P>

</xsl:template>

<xsl:template name="m_notforreview_explanation">Tick the 'Not for Review' box if you <I>don't</I> want your entry to be available for review (see the <A xsl:use-attribute-sets="nm_notforreview_explanation" HREF="DontPanic-ReviewForums">Review Forums FAQ</A> for more information)</xsl:template>
<xsl:template name="m_recommendentrybutton">Recommend Entry</xsl:template>
<xsl:template name="m_submitforreviewbutton">Submit For Review</xsl:template>
<xsl:template name="m_notforreviewbutton"><xsl:value-of select="$alt_notforreview"/></xsl:template>
<xsl:template name="m_currentlyinreviewforum">Currently in:</xsl:template>
<xsl:template name="m_submittedtoreviewforumbutton"><xsl:value-of select="REVIEWFORUM/FORUMNAME"/></xsl:template>
<xsl:template name="m_registertodiscuss">If you <a xsl:use-attribute-sets="nm_registertodiscuss" href="{$root}register">become a member of h2g2</a> you can discuss this entry with other Researchers. You can find out more about becoming a member <a xsl:use-attribute-sets="nm_registertodiscuss" href="{$root}A387317">here</a>.</xsl:template>
<xsl:template name="m_newerentries">Newer entries</xsl:template>
<xsl:template name="m_olderentries">Older Entries</xsl:template>
<xsl:template name="m_cantpostrestricted">We're sorry, but you are restricted from posting to this site.</xsl:template>
<xsl:template name="m_thread_postnotallowspecific">Sorry but you have attempted to add a post to the <xsl:value-of select="ERROR/REVIEWFORUM/REVIEWFORUMNAME"/> Forum. This is not allowed.</xsl:template>

<xsl:template name="m_perspace_nointro">
		You haven't filled in any details about yourself, so other Researchers can't leave you messages. 
		Why not <a href="{$root}UserEdit?masthead=1">write something about yourself</a> so that other users can talk to you. What you write will appear in the 'About Me' section 
		which you will see at the bottom of your page, but other people will see at the top.
</xsl:template>

</xsl:stylesheet>