<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
	<!ENTITY space "<xsl:text xmlns:xsl='http://www.w3.org/1999/XSL/Transform'> </xsl:text>">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:local="#local-functions" xmlns:s="urn:schemas-microsoft-com:xml-data" xmlns:dt="urn:schemas-microsoft-com:datatypes" exclude-result-prefixes="msxsl local s dt">


<!-- addjournal.xml -->
<xsl:variable name="tips_addjournal">
<div class="write-review-hint">your weblog appears in your personal space ("my space")</div>
<div class="write-review-hint">you can use your weblog like a diary or notepad</div>
<div class="write-review-hint">remember that other members can read your weblog, so make it interesting and don't include anything you wouldn't want others to know</div>
<div class="write-review-hint">feel free to include links to other websites you think are interesting or relevent</div>
</xsl:variable>

<!-- searchpage.xml -->
<xsl:variable name="tips_search">
<div class="myspace-t">try putting quotes around the words and you'll get results for a phrase, eg, "The Coral"</div>
<div class="myspace-t">make sure you've spelt your search term correctly</div>
<div class="myspace-t">don't include any accents or unusual characters</div>
<div class="myspace-t">use the drop-down to search for a conversation or member</div>
</xsl:variable>

<!-- newusers.xml -->
<xsl:variable name="tips_newusers">
<div class="myspace-t">read peoples' introductions to find out what they're interested in</div>
<div class="myspace-t">you could invite them to take part in a conversation by leaving them a message with a link to the conversation</div>
<div class="myspace-t">try suggesting my science fiction life features or reviews they'll be interested in</div>
<div class="myspace-t">suggest some pages that would be useful to know about, eg talk or recently updated conversations.</div>
<div class="myspace-t">keep it short and friendly</div>
	</xsl:variable>

<!-- addjournal.xsl journalpage.xsl -->
<xsl:variable name="tips_myweblog">
	<xsl:choose>
	<xsl:when test="$ownerisviewer=1">
	<div class="myspace-t">this is a list of all your weblog entries</div>
	</xsl:when>
	<xsl:otherwise>
	<div class="myspace-t">this is a list of this member's weblog entries </div>
	</xsl:otherwise>
	</xsl:choose>


<div class="myspace-t">click "view comments" to see other members' comments</div>
</xsl:variable>

<!-- infopage.xsl -->
<xsl:variable name="tips_infopage_articles">
<div class="myspace-t">this is a list of all reviews and other pages that have been published on my science fiction life, with the most recent first</div>
<div class="myspace-t">if you publish a review or page then it will appear at the top of this list</div>
</xsl:variable>

<xsl:variable name="tips_infopage_conversations">
<div class="myspace-t">this is a list of all the conversations on my science fiction life, listed in chronological order with the most recently updated displayed first</div>
<div class="myspace-t">if you add a comment to a conversation it automatically moves to the top of the list<br /><br /><a href="http://www.bbc.co.uk/mysciencefictionlife/pages/houserules.shtml"><img src="{$imagesource}icons/house_rules.gif" width="8" height="9" alt="houserules" border="0" /> house rules</a></div>
</xsl:variable>

<!-- WRITE A MEMBER REVIEW TIPS -->
	<xsl:variable name="tips_memberreview">
	<div class="write-review-hint">You can edit or delete the review once it's published.</div>
	
	<div class="write-review-hint">When titling a review always begin with the artist for albums, but with a name for cinema, books, games etc.</div>

	<div class="write-review-hint">Keep your review short, you can write as much you want but we've found 100 words is a good length.</div>
	
	<div class="write-review-hint">Try to include some useful information in your review and make your opinion clear.</div> 
	
	<div class="write-review-hint">Your review will appear in the index under the category you choose, eg: an album review will appear in the "member album reviews" section.</div>

	<div class="write-review-hint">Your review will also appear in the portfolio section of your "my space" page.</div>
	
	<div class="write-review-hint">All reviews (written by UK residents) are automatically entered into the "review and WIN" competition.</div>

	<div class="write-review-hint">You can add a useful link to a band's official website or an interview with a filmmaker, or whatever you think is relevant.</div>
	</xsl:variable>
	
	<!-- WRITE A MEMBER PAGE TIPS -->
	<xsl:variable name="tips_memberpage">
	<div class="write-review-hint">You can use this area to create pages that are a bit more involved than a review. For example, people have created things like:
		<br />
	&nbsp;- Buyers' guides<br />
	&nbsp;- Guides to towns/cities<br />
	&nbsp;- Opinion pieces<br />
	&nbsp;- Art projects<br />
</div>	
	<div class="write-review-hint">Be creative and think about ideas where you can get other members involved. It's a good idea to encourage support for your project on the noticeboard before you start.</div>
	
	<div class="write-review-hint">If you have a project that requires some support from the editors (eg, putting up images) then ask them for help via the noticeboard.</div>
	
	<div class="write-review-hint">Your page will appear in the portfolio section of your "my space" page.</div>
	
	<div class="write-review-hint">You can edit or delete the page once it's published.</div>
	</xsl:variable>
	
	<!-- ADD COMMENT TIPS -->
	<xsl:variable name="tips_addcomment">
	<div class="write-review-hint">if you are addressing a particular person try using their name, eg, "Hi Rowan"</div>
	
	<div class="write-review-hint">be friendly and avoid being dismissive - remember it's easy for others to take text the wrong way</div>
	
	<div class="write-review-hint">use smileys to indicate tone but don't overuse them as they become meaningless</div>
	
	<div class="write-review-hint">see our <a href="{$root}smileys">Smileys Page</a> for how to use them</div>
	
	<div class="write-review-hint">keep your comment short and to the point - long posts are hard to reply to</div>
	
	<div class="write-review-hint">leave text-speak for mobile phones</div>
	
	<div class="write-review-hint">if you want to include a link begin it with "http://"</div> 
	
 	<div class="write-review-hint">avoid using all capital letters - it appears as if you're shouting</div>
	</xsl:variable>

	<!-- EDIT INTRO TIPS -->
	<xsl:variable name="tips_editintro">
	<div class="write-review-hint">your introduction appears in your personal space ("my profile")</div>
	
	<div class="write-review-hint">try including your favourite music, films, books, art...</div>
	
	<div class="write-review-hint">remember that other members can read your introduction so don't include anything you wouldn't want others to know</div>
	
	<div class="write-review-hint">feel free to include links to other websites you think are interesting or relevent</div>
	</xsl:variable>
	
	<!-- EDIT WEBLOG -->
	<xsl:variable name="tips_editweblog">
	<div class="write-review-hint">your weblog appears in your personal space ("my space")</div>
	
	<div class="write-review-hint">you can use your weblog like a diary or notepad</div>
	
	<div class="write-review-hint">remember that other members can read your weblog, so make it interesting and don't include anything you wouldn't want others to know</div>
	
	<div class="write-review-hint">feel free to include links to other websites you think are interesting or relevent</div>
	</xsl:variable>
	
	<!-- NOTE -->
	<xsl:variable name="tips_note">
	<div class="write-review-hint">note: please be very careful if you post an email address or instant messaging details, as you may receive lots of emails or messages. 
	
	<!-- v1 See the House Rules for more information. --> Remember, when you contribute to the site you are giving the BBC permission to use your contribution in a variety of ways. See the Terms Of Use for more information.</div>
	</xsl:variable>

	<!-- USERPAGE TIPS -->
	<xsl:variable name="tips_userpage_intro">
	<xsl:choose>
	<xsl:when test="$ownerisviewer=1">
		<div class="myspace-t">try listing your favourite albums, films, books, art, tv...</div>
		<div class="myspace-t">don't include personal information like telephone numbers or addresses</div> 
	</xsl:when>
	<xsl:otherwise>
	<!-- <div class="myspace-t">this is this members introduction - have you written yours?</div> -->
	<div class="myspace-t">click 'leave me a message' to contact the owner of this space</div> 
	</xsl:otherwise>
	</xsl:choose>	
	</xsl:variable>

	<xsl:variable name="tips_userpage_conversation">
		<xsl:choose>
		<xsl:when test="$ownerisviewer=1">
		<div class="myspace-t">this is a list of conversations you have made comments in</div>
				<div class="myspace-t">to remove a conversation from the list click "remove"</div> 
		<div class="myspace-t">the first 10 are displayed here, the most recently updated appears first</div>
<div class="myspace-t">click "all my conversations" to see a full list of conversations</div>
		</xsl:when>
		<xsl:otherwise>
		<div class="myspace-t">the first 10 are displayed here, the most recently updated appears first</div> 
		<div class="myspace-t">click "all my conversations" to see a full list of conversations </div>
		</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	
	<xsl:variable name="tips_userpage_mymessages">
		<xsl:choose>
		<xsl:when test="$ownerisviewer=1">
		<div class="myspace-t">these have been left for you by other members</div>
			<div class="myspace-t">click on the title to view the message</div> 
		<div class="myspace-t">you can reply in the same way as using a conversation</div>
		<div class="myspace-t">to leave a message for someone you visit their space by clicking on their name</div>
		</xsl:when>
		<xsl:otherwise>
		<div class="myspace-t">these are messages that have been by other members</div>
			<div class="myspace-t">click on the title to view the message</div> 
		<div class="myspace-t">If you want to leave a message for this person click "leave me a message"</div>
		</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
		
	<xsl:variable name="tips_userpage_myportfolio">
		<xsl:choose>
		<xsl:when test="$ownerisviewer=1">
		<div class="myspace-t">these are the 10 most recent reviews and other pages you have published. click "all my portfolio" for older ones</div>
			<div class="myspace-t">click "all my portfolio" to see a full list of reviews and pages</div> 
<div class="myspace-t">click "edit" to amend pages</div>
		</xsl:when>
		<xsl:otherwise>
		<div class="myspace-t">these are the 10 most recent reviews and other pages this members have published.</div>
			<div class="myspace-t">click "all my portfolio" to see a full list of reviews and pages</div> 
		</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<xsl:variable name="tips_userpage_myweblog">
		<xsl:choose>
		<xsl:when test="$ownerisviewer=1">
		<div class="myspace-t">this is your most recent weblog entry</div>
				<div class="myspace-t">click "view comments" to see other members' comments</div> 
				<div class="myspace-t">click "all my weblog entries" for a full list</div> 
		</xsl:when>
		<xsl:otherwise>
		<div class="myspace-t">this is this member's most recent weblog entry </div>
		<div class="myspace-t">click "view comments" to see other members' comments </div> 
		<div class="myspace-t">click "all member's weblog entries" for a full list</div> 
		</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>


	<xsl:variable name="tips_allconversations">
		<div class="myspace-t">this is a list of conversations you have made comments in</div>
		<div class="myspace-t">to remove a conversation from the list click "remove"</div>
	
	</xsl:variable>
	
		<xsl:variable name="tips_conversations">
		
		<div class="myspace-t">click "latest" to see the most recent comment</div>
		
		<div class="myspace-t">new comments will appear at the end of the conversation</div>
		
		<div class="myspace-t">if you think a comment breaks the house rules because it is offensive or breaks the law, click to alert our moderators</div>
		
		<div class="myspace-t">if you add a comment in this conversation, it will automatically be added to your "my conversations" list which appears in "my space"</div>
		
		<div class="myspace-t">if you would like to keep track of this conversation without commenting, click the "add to my conversations" link</div>
	   
	</xsl:variable>
	
		<xsl:variable name="tips_forum">
		<div class="myspace-t">this is a list of all the conversations related to a particular page</div>
		<div class="myspace-t">click the title to see the beginning of the conversation or "last comment" to see the most recent contribution</div>
	   	</xsl:variable>

</xsl:stylesheet>
