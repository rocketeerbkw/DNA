<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
	<!ENTITY space "<xsl:text xmlns:xsl='http://www.w3.org/1999/XSL/Transform'> </xsl:text>">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">


<!-- Write form 1.1 -->
<xsl:variable name="form.write.tips">
<p><div class="rightnavboxsubheading">Your work</div>
Publishing to the site will have stored your work under 'Portfolio' in 'My Space'. </p>

<p><div class="rightnavboxsubheading">Copyright</div>
By publishing your work on the site, you grant us a non-exclusive licence only. You still retain all copyright. <br/> <div class="arrow2"><a href="http://www.bbc.co.uk/dna/getwriting/copyright">more info</a></div></p>

<p><div class="rightnavboxsubheading">Strong Language</div>
Avoid excessive language and adult content, or work will be removed. If you use strong language star out all letters except the first and last. <br/><div class="arrow2"><a href="http://www.bbc.co.uk/dna/getwriting/houserules">more info</a></div></p>

</xsl:variable>

<!-- Write form 1.1.3b -->
<xsl:variable name="page.submitreview.tips">

<p><div class="rightnavboxsubheading">Submit for review</div>
You can submit your work to a Review Circle straightaway, but we recommend you sleep on it first and check your work for silly mistakes.</p>

<p><div class="rightnavboxsubheading">Introduce your work</div>
When submitting your work for review, write an introduction to your work in the box provided. You may want to ask for a particular level or type of review (e.g. gentle, general, no-holds-barred etc.)</p>

<p><div class="rightnavboxsubheading">Find your reviews</div>
Your reviews will be listed in 'My Space' under 'My Conversations'.</p>

<p><div class="rightnavboxsubheading">Give more feedback</div>
The best way to get reviews are to give them out yourself. Review at least five works before you expect the same in return.</p>

</xsl:variable>

<!-- advice 1.2 form -->
<xsl:variable name="form.advice.tips">
<p><div class="rightnavboxsubheading">Your work</div>
Publishing to the site will have stored your work under 'Portfolio' in 'My Space'. </p>

<p><div class="rightnavboxsubheading">Copyright</div>
By publishing your work on the site, you grant us a non-exclusive licence only. You still retain all copyright.<br/> <div class="arrow2"><a href="http://www.bbc.co.uk/dna/getwriting/copyright">more info</a></div> </p>

<p><div class="rightnavboxsubheading">Strong Language</div>
Please star out any strong language leaving the first and last letters.  Excessive strong language and adult content will be removed from the site.<br/><div class="arrow2"><a href="http://www.bbc.co.uk/dna/getwriting/houserules">more info</a></div> </p>



</xsl:variable>

<!-- advice 1.2.3  -->
<xsl:variable name="page.submitadvice.tips">



</xsl:variable>

<!-- challenge 1.4.1  -->
<xsl:variable name="form.challenge.tips">
<!--<div class="rightnavboxsubheading">Titles</div>
Choose a title that describes the subject of your challenge, e.g. "Rhymin' and Stealin'".  Avoid general titles like "Bob's Challenge". People are more likely to read and take part.

<p><div class="rightnavboxsubheading">Deadline</div>
You don't have to set a deadline if it's a regular challenge. But if you think you'll only be able to give it a short amount of time, it might be worthwhile.</p>

<p><div class="rightnavboxsubheading">Word limit</div>
Part of some challenges is getting your entry to fit a small number of words. It might be a good way to work on your editing skills.</p>

<p><div class="rightnavboxsubheading">Conversation challenges</div>
Some challenges take place in conversations, such as collaborative ones where each person submits a word or sentence. Let people know how you want them to submit their responses.</p>

<p><div class="rightnavboxsubheading">Linking</div>
For links to GW pages:<br /> &lt;LINK DNAID="A123456"&gt;NAME&lt;/LINK&gt;
For external links:<br /> &lt;LINK HREF="http://www.bbc.co.uk"&gt;<br />NAME&lt;/LINK&gt;<br />
<div class="arrow2"><a href="http://www.bbc.co.uk/dna/getwriting/aboutwrite#13">more info</a></div> </p>-->
</xsl:variable>

<!-- page challenge   -->
<xsl:variable name="page.challenge.tips">
<!--<div class="rightnavboxsubheading">CHALLENGES ON GET WRITING</div>
<div class="rightnavboxsubheading">Be creative</div>
Try to create challenges that lots of people might want to try. Don't duplicate others challenges but draw inspiration from taking part in others on the site first.

<p><div class="rightnavboxsubheading">Copyright</div>
By publishing your work on the site, you grant us a non-exclusive licence only. You still retain all copyright.</p>-->

</xsl:variable>


<!--Groups 7.1.4 -->
<xsl:variable name="form.group.tips">
<div class="rightnavboxsubheading">FILLING IN THIS FORM</div>

<p><div class="rightnavboxsubheading">Identify yourself</div>
Choose a unique name and select a good icon.</p>

<p><div class="rightnavboxsubheading">Write your intro</div>
Describe your focus and interest clearly and succinctly.</p>

<p><div class="rightnavboxsubheading">Set a review method</div>
Ask your group their preference: general impressions and suggestions or scoring; repeated workshopping or a single review, etc.</p>

<p><div class="rightnavboxsubheading">Set a schedule</div>
Keep it realistic - one review a month is reasonable.</p>

<p><div class="rightnavboxsubheading">Linking</div>
For links to GW pages:<br/> &lt;LINK DNAID="A123456"&gt;NAME&lt;/LINK&gt;
For external links:<br/> &lt;LINK HREF="http://www.bbc.co.uk"&gt;<br/>NAME&lt;/LINK&gt; <br />
<div class="arrow2"><a href="http://www.bbc.co.uk/dna/getwriting/aboutwrite#13">more info</a></div> </p>

<p><div class="rightnavboxsubheading">HOW TO BE A GROUP OWNER</div></p>

<p><div class="rightnavboxsubheading">Spend time as a member</div>
Participate in a group and get to know how the system works. Keep an eye on how the owner manages the group. </p>

<p><div class="rightnavboxsubheading">Ask an expert</div>
Talk over the job with a current group owner. Learn what works, and what doesn't. </p>

<p><div class="rightnavboxsubheading">Share the work</div>
You can have multiple owners in a group, and it might suit you to share out the duties. Promote other members in Group Admin.</p>
</xsl:variable>

<!--Groups 7.1.3c and b -->
<xsl:variable name="page.group.tips">
<!--<div class="rightnavboxsubheading">HOW TO JOIN THIS GROUP</div>

<p><div class="rightnavboxsubheading">Check it out</div>
Read the introduction and group discussions to check they're up your street and still active. You may want to introduce yourself to the owners on their personal space.</p>

<p><div class="rightnavboxsubheading">Join up</div>
Click 'Apply for Membership'. The owner will then accept or decline your request.</p>

<p><div class="rightnavboxsubheading">Not heard anything?</div>
Check the status of your application from your Membership Bulletin on 'My Space' under 'My Groups'. Owners may forget to regularly check on applications.</p>

<p><div class="rightnavboxsubheading">It's not personal</div>
If you have been declined, it's probably because the group is too full.</p>-->

</xsl:variable>

<!--Groups 7.1.6 THIS IS NOT SHOWING UP-->
<xsl:variable name="discuss.form.group.tips">
<!--<p><div class="rightnavboxsubheading">Open to all</div>
Only owners can start new group discussions, but anyone (non-members included) can join in.</p>

<p><div class="rightnavboxsubheading">Non-members</div>
If you are a non-member, introduce yourself first. Be sensitive to entering the group space - it's a little like gatecrashing!</p>

<p><div class="rightnavboxsubheading">Be polite</div>
Don't get angry, fly off the handle, or deliberately provoke people.</p>

<p><div class="rightnavboxsubheading">URLs</div>
Links to websites we consider unsuitable will be removed - no ads or naughtiness, please!<br/><div class="arrow2"><a href="http://www.bbc.co.uk/dna/getwriting/houserules">more info</a></div></p>-->
</xsl:variable>


<!-- creative conversation -->
<xsl:variable name="discuss.form.creative.tips">
<!--<p><div class="rightnavboxsubheading">Be Patient</div>
People of all experience and abilities visit, so please remember this when posting.</p>

<p><div class="rightnavboxsubheading">No Spamming</div>
Don't post the same message on multiple boards - it's boring!</p>

<p><div class="rightnavboxsubheading">No Flaming or Trolling</div>
Don't get angry, fly off the handle, or deliberately provoke people.</p>

<p><div class="rightnavboxsubheading">URLs</div>
Links to websites we consider unsuitable will be removed- no ads or naughtiness, please!<br/>
<div class="arrow2"><a href="http://www.bbc.co.uk/dna/getwriting/houserules">more info</a></div></p>

<p><div class="rightnavboxsubheading">Preview</div>
Take a moment to read back what you've written before you post it. Once posted, it can not be edited or deleted unless it breaks the House Rules.</p>-->
</xsl:variable>

<!-- advice conversation -->
<xsl:variable name="discuss.form.advice.tips">
<!--<p><div class="rightnavboxsubheading">Be Patient</div>
People of all experience and abilities visit, so please remember this when posting.</p>

<p><div class="rightnavboxsubheading">No Spamming</div>
Don't post the same message on multiple boards - it's boring!</p>

<p><div class="rightnavboxsubheading">No Flaming or Trolling</div>
Don't get angry, fly off the handle, or deliberately provoke people.</p>

<p><div class="rightnavboxsubheading">URLs</div>
Links to websites we consider unsuitable will be removed- no ads or naughtiness, please!<br/>
<div class="arrow2"><a href="http://www.bbc.co.uk/dna/getwriting/houserules">more info</a></div></p>

<p><div class="rightnavboxsubheading">Preview</div>
Take a moment to read back what you've written before you post it. Once posted, it can not be edited or deleted unless it breaks the House Rules.</p>-->
</xsl:variable>

<!-- challenge conversation -->
<xsl:variable name="discuss.form.challenge.tips">
<!--<div class="rightnavboxsubheading">Be Patient</div>
People of all experience and abilities visit, so please remember this when posting.

<p><div class="rightnavboxsubheading">No Spamming</div>
Don't post the same message on multiple boards - it's boring!</p>

<p><div class="rightnavboxsubheading">No Flaming or Trolling</div>
Don't get angry, fly off the handle, or deliberately provoke people.</p>

<p><div class="rightnavboxsubheading">URLs</div>
Links to websites we consider unsuitable will be removed- no ads or naughtiness, please! <br/>
<div class="arrow2"><a href="http://www.bbc.co.uk/dna/getwriting/houserules">more info</a></div></p>

<p><div class="rightnavboxsubheading">Preview</div>
Take a moment to read back what you've written before you post it. Once posted, it can not be edited or deleted unless it breaks the House Rules.</p>-->
</xsl:variable>


<!-- conversation -->
<xsl:variable name="conversation.tips">
<!--<p><div class="rightnavboxsubheading">Be Patient</div>
People of all experience and abilities visit, so please remember this when posting.</p>

<p><div class="rightnavboxsubheading">No Spamming</div>
Don't post the same message on multiple boards - it's boring!</p>

<p><div class="rightnavboxsubheading">No Flaming or Trolling</div>
Don't get angry, fly off the handle, or deliberately provoke people.</p>

<p><div class="rightnavboxsubheading">URLs</div>
Links to websites we consider unsuitable will be removed- no ads or naughtiness, please! <br/>
<div class="arrow2"><a href="http://www.bbc.co.uk/dna/getwriting/houserules">more info</a></div></p>

<p><div class="rightnavboxsubheading">Preview</div>
Take a moment to read back what you've written before you post it. Once posted, it can not be edited or deleted unless it breaks the House Rules.</p>-->
</xsl:variable>

<!-- conversation 1.1.7 -->
<xsl:variable name="threads.tips">
<!--<p><div class="rightnavboxsubheading">Be patient</div>
People of all experience and abilities visit, so please remember this when posting.</p>

<p><div class="rightnavboxsubheading">No spamming</div>
Don't post the same message on multiple boards - it's boring!</p>

<p><div class="rightnavboxsubheading">No flaming or trolling</div>
Don't get angry, fly off the handle, or deliberately provoke people.</p>

<p><div class="rightnavboxsubheading">URLs</div>
Links to websites we consider unsuitable will be removed- no ads or naughtiness, please! <br/>
<div class="arrow2"><a href="http://www.bbc.co.uk/dna/getwriting/houserules">more info</a></div></p>

<p><div class="rightnavboxsubheading">Preview</div>
Take a moment to read back what you've written before you post it. Once posted, it can not be edited or deleted unless it breaks the House Rules.</p>-->
</xsl:variable>

<!-- journal -->
<xsl:variable name="journal.tips">
<!--<p>Your journal entries are visible to all, and others can comment on each entry.</p>
<p>If you are added to someone else's Contacts list, they will be notified of new entries to your journal.</p>-->

</xsl:variable>


<xsl:variable name="user.changescreenname.tips">
<div class="rightnavboxsubheading">Your name</div>
Choose a unique name that you feel represents you online.  It might be useful to search to see if someone already has the same name as the one you'd like to use.

<p><div class="rightnavboxsubheading">Language</div>
Avoid the use of inappropriate language in your screen name. Names can be edited or removed.
</p>

<p><div class="rightnavboxsubheading">Impersonation</div>
Everyone has a unique User ID number, so you can't get away with impersonating other contributors - it's rude and unacceptable to even try</p>

<div class="rightnavboxsubheading">Other characters</div>
Don't use email addresses, instant messaging numbers and the like in your screen name.
</xsl:variable>

<!-- my space 6 -->
<xsl:variable name="user.conversation.tips">
<p>Reviews, Group Discussions and conversations from Talk are stored here.</p>
<p>If you no longer want a conversation on your space, click the 'Remove?' button.</p>
<p>You will also see links to new journal entries by people in 'My Contacts'.</p>
</xsl:variable>

<!-- all my conversations -->
<xsl:variable name="all.conversation.tips">
<p><div class="rightnavboxsubheading">What's listed</div>
Reviews, Group Discussion and conversations from Talk were stored here.</p>

<p><div class="rightnavboxsubheading">Remove conversations</div>
If you no longer want a conversation on your space, click the 'Remove?' button.</p>
</xsl:variable>

<!-- leave a message 6.2d.1 -->
<xsl:variable name="messages.form.group.tips">
<p><div class="rightnavboxsubheading">Open to all</div>
Messages are not private, though they will only be linked to from this person's space. Make sure your message is appropriate for all to see.</p>

<p><div class="rightnavboxsubheading">Be polite</div>
If you are asking for a review or to join a group, honey will get your further than vinegar.</p>

<p><div class="rightnavboxsubheading">No Flaming or Trolling</div>
Don't get angry, fly off the handle, or deliberately provoke people.</p>

<p><div class="rightnavboxsubheading">URLs</div>
Links to websites we consider unsuitable will be removed- no ads or naughtiness, please! <br/>
<div class="arrow2"><a href="http://www.bbc.co.uk/dna/getwriting/houserules">more info</a></div></p>

<p><div class="rightnavboxsubheading">Preview</div>
Take a moment to read back what you've written before you post it. Once posted, it can not be edited or deleted unless it breaks the House Rules.</p>
</xsl:variable>

<!-- write journal -->
<xsl:variable name="form.journal.tips">
<p><div class="rightnavboxsubheading">Open to all</div>
Your journal entries are visible to all, and others can comment on each entry. We recommend you use it for observations and sketches, rather than personal details.</p>

<p><div class="rightnavboxsubheading">Contacts and journals</div>
If you are added to someone else's Contacts list, they will be notified of new entries to your journal.</p>

<p><div class="rightnavboxsubheading">Preview</div>
Take a moment to read back what you've written before you post it. Once posted, it can not be edited or deleted unless it breaks the House Rules.</p>
</xsl:variable>

<!-- my portfolio list -->
<xsl:variable name="allmyportfolio.tips">
<p><div class="rightnavboxsubheading">All My Portfolio</div>
This is where all your creative writing, advice, challenges and exercises are stored.</p>
<p><div class="rightnavboxsubheading">Deleting work</div>
To delete work from the site click 'Remove?'</p>
<p><div class="rightnavboxsubheading">Ordering</div>
Keep clicking through the pages to show all your works on Get Writing. There may be technical incongruities in the listings.</p>
</xsl:variable>

<!-- edit my intro -->
<xsl:variable name="form.editintro.tips">
<p><div class="rightnavboxsubheading">Titles</div>
Some examples of what other people have used:<br/>
'Ian's Personal Space'<br/>
'Hello out there'<br/>
'About a girl'</p>

<p><div class="rightnavboxsubheading">Intros only</div>
Don't put your creative work in this box. If you put a story in here, you won't be able to submit it for review.</p>

<p><div class="rightnavboxsubheading">Edit your introduction</div>
You can update this whenever you want to.  Some people use this space to highlight writing achievements or their current community activity on the site.</p>

</xsl:variable> 

<!-- Mini courses - editor 1.1 CAN'T FIND WHERE THIS IS-->
<xsl:variable name="page.minicourse.tips.editor">
<p>Mini courses - editor 1.1  publishing on the site. Curabitur sit amet felis id purus accumsan porta. Duis sed nibh.</p>
<p>Mauris aliquet. Praesent magna. Pellentesque interdum pellentesque purus. Suspendisse faucibus.</p>
<p>In sollicitudin pellentesque urna. Proin odio. Cras eget pede. </p>
</xsl:variable>

<!-- page.search.tips 4 -->
<xsl:variable name="page.search.tips">

<p><div class="rightnavboxsubheading">Finding stuff</div>
You can find work to read, people and conversations using the search.</p>

<p><div class="rightnavboxsubheading">Search results</div>
Results are displayed in order of the closest match to your search and most recent publication.</p>

<p><div class="rightnavboxsubheading">Browse the index</div>
You can also browse according to category. Only work which has been given a category by the writer will be listed.</p>

<p><div class="rightnavboxsubheading">Not listed?</div>
Older work may need to be edited and given a category by the author. It may also take a bit of time to show up in the index for technical reasons. <br/>
<div class="arrow2"><a href="http://www.bbc.co.uk/dna/getwriting/postlaunchtherapy">more info</a></div></p> 

<p><div class="rightnavboxsubheading">Find a specific writer</div>
If you want to find work by a specific GW writer, you can also look at their personal space by clicking their name.</p>
</xsl:variable>

<!-- page.reviewcircle.tips -->
<xsl:variable name="page.reviewcircle.tips">
<p><div class="rightnavboxsubheading">Why remove?</div>
If you would like to remove your work from the review circle, click the 'Remove?' button. No one can do this to your work but you (and the Eds).</p>

<p><div class="rightnavboxsubheading">Author's intro</div>
Read what the author has to say about his/her work. Check what level of review they'd most like.</p>

<p><div class="rightnavboxsubheading">One month</div>
Work stays in the review circle for one month and then is removed.  We like to keep it tidy.</p>

<p><div class="rightnavboxsubheading">Be polite</div>
Creative writing is a very personal expression. Do be considerate when reviewing other people's work.</p>
</xsl:variable>

<xsl:variable name="page.thecraft.tips">
<p><div class="rightnavboxsubheading">What is Flash?</div>
The Flash version allows you to collate top tips and exercises using My Pinboard.<br/>
<div class="arrow2"><a href="http://www.bbc.co.uk/webwise">get Flash</a></div></p>
<p><div class="rightnavboxsubheading">Take a Mini-Course</div>
We've combined bits from all our Craft modules with exercises to develop a mini-courses for all levels.  Created by creative writing tutors, our mini-courses set you on the path to better writing. <br/>
<div class="arrow2"><a href="http://www.bbc.co.uk/dna/getwriting/minicourse">browse mini-courses</a></div></p>
<p><div class="rightnavboxsubheading">Offline Courses &amp; Groups</div>
Want to find a writing course or group that meets in person? Want to notify people of your writing group and recruit new members? <br/>
<div class="arrow2"><a href="http://www.bbc.co.uk/learning/coursesearch/get_writing/">use our course finder</a></div></p>
</xsl:variable>


<!-- sindex minicourse tips -->
<xsl:variable name="index.minicourse.tips">
<p><div class="rightnavboxsubheading">Find your level</div>
We've separated mini-courses by level.<br/><br/>
Beginners: Most general information and tips<br/>
Intermediate: More specific information on genres and techniques.<br/>
Advanced: Very specific topics and information on getting published.</p>

<!-- <p><div class="rightnavboxsubheading">New mini-courses</div>
We will try to add new courses every few months. If there is anything particular you'd like to see, let us know.<br/>
<div class="arrow2"><a href="http://www.bbc.co.uk/feedback?mailto=getwritingfeedback@bbc.co.uk">contact us</a></div></p>

<p><div class="rightnavboxsubheading">About our mini-courses</div>
We have developed these mini-courses with creative writing tutors. You can do a mini-course with a group, follow the timetable, or do one on your own.</p> -->
</xsl:variable>

<!-- index.tools.tips  -->
<xsl:variable name="index.toolsquizzes.tips">

<div class="rightnavboxsubheading">Why should I use tools?</div>
The tools are designed to help you get creative and inspire your writing. They can be used whenever you like and results printed off for practical use.

<p><div class="rightnavboxsubheading">How do they work?</div>
The Tools are interactive, this requires a specific computer program for you to use them, called Flash.</p>

<p><div class="rightnavboxsubheading">What is Flash?</div>
Flash plug-in is a multimedia which allows interaction with animations and other rich content.</p>

<p><div class="rightnavboxsubheading">Where can I get Flash From?</div>
BBC Webwise has full details of all plug ins and downloads, along with other helpful information. <br/>
<div class="arrow2"><a href="http://www.bbc.co.uk/webwise">get Flash</a></div></p>

</xsl:variable>


<!-- key.tips -->
<xsl:variable name="key.tips">
<xsl:element name="{$text.heading}" use-attribute-sets="text.heading">	
<div class="heading2">KEY</div>
</xsl:element>
<br/>
<img src="{$graphics}icons/iconkey_online.gif" height="28" width="29" alt="the user is online" align="left" /> the user is online
<br/><br/><br/>
<img src="{$graphics}icons/iconkey_alert.gif" height="28" width="29" alt="alert a moderator" align="left"  /> alert a moderator
</xsl:variable>

<xsl:variable name="form.excercise.tips">
<p><div class="rightnavboxsubheading">Exercises for you</div>
Exercises saved to the site will not be included in the index and they can not be submitted for review. They will be stored in 'My Space' in your portfolio.</p>
<p><div class="rightnavboxsubheading">Share your exercises</div>
Talk more about your learning experience and give each other support. <br/>
<a href="http://www.bbc.co.uk/dna/getwriting/talklearning">Talk: Learning</a></p>
<p><div class="rightnavboxsubheading">Working online</div>
By writing your exercises online, you'll create a link to this mini-course from 'My Space' so you can find it again easily. </p>
</xsl:variable>


</xsl:stylesheet>
