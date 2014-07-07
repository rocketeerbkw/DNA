<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">
    
    <doc:documentation>
        <doc:purpose>
            Defines HTML for article link on the categories page
        </doc:purpose>
        <doc:context>
            Applied in objects/collections/members.xsl
        </doc:context>
        <doc:notes>
            
        </doc:notes>
    </doc:documentation>
    
    <xsl:template match="USER-COMPLAINT-FORM[/H2G2/PARAMS/PARAM[NAME = 's_start'][VALUE = 1]] | USERCOMPLAINT[/H2G2/PARAMS/PARAM[NAME = 's_start'][VALUE = 1]]" mode="input_user-complaint-form">
        <div class="content">
            <h2>পোস্টের বিরুদ্ধে অভিযোগ করুন <xsl:call-template name="item_name"/></h2>
            <p>এই ফর্মটি শুধুমাত্র সুনির্দিষ্ট বিষয়ের ওপর অভিযোগ করার জন্য যাতে ভঙ্গ করা হয়েছে <a href="http://www.bbc.co.uk/bengali/institutional/2013/07/130724_000000_bangla_blog_house_rules.shtml">নিয়মাবলী</a></p>
            <p>যদি সাধারণ কোন মন্তব্য করতে চান কিংবা কোন প্রশ্ন থাকে, তাহলে আলোচনায় মেসেজ পাঠান।</p>
            <p>আপনার অভিযোগটি মডারেটরের কাছে পাঠানো হবে। তিনি সিদ্ধান্ত নেবেন কোথায় লঙ্ঘিত হয়েছে  <a href="http://www.bbc.co.uk/bengali/institutional/2013/07/130724_000000_bangla_blog_house_rules.shtml">নিয়মাবলী</a> ইমেইলের মাধ্যমে আপনাকে তাদের সিদ্ধান্ত জানানো হবে </p>
            <p class="action">
              <xsl:choose>
                <xsl:when test="@POSTID">
                  <a href="?PostId={(POST-ID | @POSTID)[1]}&amp;s_ptrt={/H2G2/PARAMS/PARAM[NAME = 's_ptrt']/VALUE}&amp;s_start=2">ইমেইলের মাধ্যমে আপনাকে তাদের সিদ্ধান্ত জানানো হবে</a>
                </xsl:when>
                <xsl:when test="@H2G2ID">
                  <a href="?h2g2Id={@H2G2ID}&amp;s_ptrt={/H2G2/PARAMS/PARAM[NAME = 's_ptrt']/VALUE}&amp;s_start=2">আমার অভিযোগ জানাতে চাই</a>
                </xsl:when>
                <xsl:otherwise>
                  <a href="?url={@URL}&amp;s_ptrt={/H2G2/PARAMS/PARAM[NAME = 's_ptrt']/VALUE}&amp;s_start=2">আমার অভিযোগ জানাতে চাই</a>
                </xsl:otherwise>
              </xsl:choose>
            </p>
        </div>
        <xsl:call-template name="library_userstate">
            <xsl:with-param name="loggedin"></xsl:with-param>
            <xsl:with-param name="unauthorised"></xsl:with-param>
            <xsl:with-param name="loggedout">
                <div class="content">
                    <p>এই ওয়েবসাইটের অ্যাকাউন্টে আপনি সাইনইন করেননি। আপনার কোন অ্যাকাউন্ট থাকলে তাতে সাইনইন করুন। এতে আপনার অভিযোগটি সম্পর্কে তদন্ত করতে আমাদের সুবিধে হবে।</p>
                    <p class="action">
                      <a>
                      	<xsl:attribute name="href">
                         <xsl:choose>
	                		<xsl:when test="/H2G2/SITE/IDENTITYSIGNIN != 1">
                              <xsl:apply-templates select="/H2G2/VIEWING-USER" mode="library_memberservice_loginurl">
                                  <xsl:with-param name="ptrt" select="concat($root,  '/UserComplaintPage?PostID=', (POST-ID | @POSTID)[1], '&amp;s_start=2')" />
                              </xsl:apply-templates>
		                          
		                     </xsl:when>
		                     <xsl:otherwise>
                              <xsl:apply-templates select="/H2G2/VIEWING-USER" mode="library_identity_loginurl">
                                  <xsl:with-param name="ptrt" select="concat('/UserComplaintPage?PostID=', (POST-ID | @POSTID)[1])" />
                              </xsl:apply-templates>
		                     </xsl:otherwise>
		                  </xsl:choose>
		                  </xsl:attribute>
                          <xsl:text>সাইনইন</xsl:text>
                      </a>
                    </p>
                </div>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>

  <xsl:template name="item_name">
    <xsl:choose>
      <xsl:when test="@POSTID">
        <xsl:text></xsl:text>
      </xsl:when>
      <xsl:when test="@H2G2ID">
        <xsl:text>নিবন্ধ</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>কন্টেন্ট আইটেম</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
    <xsl:template match="USER-COMPLAINT-FORM[/H2G2/PARAMS/PARAM[NAME = 's_start'][VALUE = 2]] | USERCOMPLAINT[/H2G2/PARAMS/PARAM[NAME = 's_start'][VALUE = 2]]" mode="input_user-complaint-form">
        <form action="UserComplaintPage" method="post" id="complaintForm"> 
            <div class="content">
              <xsl:choose>
                <xsl:when test="@POSTID">
                  <input type="hidden" value="{(POST-ID | @POSTID)[1]}" name="PostID"/>
                </xsl:when>
                <xsl:when test="@H2G2ID">
                  <input type="hidden" value="{@H2G2ID}" name="h2g2ID"/>
                </xsl:when>
                <xsl:otherwise>
                  <input type="hidden" value="{@URL}" name="url"/>
                </xsl:otherwise>
              </xsl:choose>
              <input type="hidden" name="s_ptrt" value="{/H2G2/PARAMS/PARAM[NAME = 's_ptrt']/VALUE}"/>
                
            	<h2>মডারেটরকে জানানো হচ্ছে</h2>
            	<p>বেছে নিন কোন্‌ <a href="http://www.bbc.co.uk/bengali/institutional/2013/07/130724_000000_bangla_blog_house_rules.shtml">নিয়মাবলী</a> আপনার মনে হয় এখানে  ভঙ্গ করা হয়েছে। যদি একাধিক নিয়মাবলী লঙ্ঘিত হয়ে থাকে, তাহলে সবচেয়ে গুরুতর অভিযোগটি বেছে নিন।</p>
            </div>
            
            <div class="content">
              <h2>অভিযোগের কারণ</h2>
              <p>
				আমার বিশ্বাস এই পোস্টটি  <xsl:call-template name="item_name"/> হয়তো ভেঙ্গেছে কোন একটি  <a href="http://www.bbc.co.uk/bengali/institutional/2013/07/130724_000000_bangla_blog_house_rules.shtml">নিয়মাবলী</a> কারণ:
              </p>
               
                <p class="options">
                	<p class="options">
                		<input type="radio" id="dnaacs-cq-1" value="এতে সুনাম ক্ষুন্ন করা হয়েছে এবং এটি মানহানিকর" name="s_complaintText"/><label for="dnaacs-cq-1">এতে সুনাম ক্ষুন্ন করা হয়েছে এবং এটি মানহানিকর</label>
                		<input type="radio" id="dnaacs-cq-2" value="এটি বর্ণবাদী, লিঙ্গবাদী, গোষ্ঠীবিদ্বেষী, যৌনতাপূর্ণ, কটূক্তিপূর্ণ কিংবা অন্য কোনভাবে অশালীন বক্তব্য" name="s_complaintText"/><label for="dnaacs-cq-2">এটি বর্ণবাদী, লিঙ্গবাদী, গোষ্ঠীবিদ্বেষী, যৌনতাপূর্ণ, কটূক্তিপূর্ণ কিংবা অন্য কোনভাবে অশালীন বক্তব্য</label>
                		<input type="radio" id="dnaacs-cq-3" value="এতে গালাগাল বা এমন বক্তব্য দেয়া হয়েছে যা অশালীন ও অপমানজনক" name="s_complaintText"/><label for="dnaacs-cq-3">এতে গালাগাল বা এমন বক্তব্য দেয়া হয়েছে যা অশালীন ও অপমানজনক</label>
                		<input type="radio" id="dnaacs-cq-4" value="এতে আইন ভঙ্গ করা হয়েছে বা অবৈধ কাজে উৎসাহ দেয়া হয়েছে, যেমন: কপিরাইট আইন অথবা আদালত অবমাননা" name="s_complaintText"/><label for="dnaacs-cq-4">এতে আইন ভঙ্গ করা হয়েছে বা অবৈধ কাজে উৎসাহ দেয়া হয়েছে, যেমন:  <a href="http://www.bbc.co.uk/messageboards/newguide/popup_copyright.html">কপিরাইট আইন</a> অথবা আদালত অবমাননা</label>
                		<input type="radio" id="dnaacs-cq-5" value="মুনাফার জন্য পণ্য বা সেবার বিজ্ঞাপন প্রচার করা হয়েছে" name="s_complaintText"/><label for="dnaacs-cq-5">মুনাফার জন্য পণ্য বা সেবার বিজ্ঞাপন প্রচার করা হয়েছে</label>
                		<input type="radio" id="dnaacs-cq-7" value="ভুয়া পরিচয় ব্যবহার করা হয়েছে" name="s_complaintText"/><label for="dnaacs-cq-7">ভুয়া পরিচয় ব্যবহার করা হয়েছে</label>
                		<input type="radio" id="dnaacs-cq-8" value="ঠিকানা, ফোন নম্বর কিংবা ইমেইল ঠিকানার মত ব্যক্তিগত তথ্য ব্যবহার করা হয়েছে" name="s_complaintText"/><label for="dnaacs-cq-8">ঠিকানা, ফোন নম্বর কিংবা ইমেইল ঠিকানার মত ব্যক্তিগত তথ্য ব্যবহার করা হয়েছে</label>
                		<xsl:call-template name="library_userstate">
                      <xsl:with-param name="loggedin">
                        <input type="radio" id="dnaacs-cq-9" value="আলোচনার বিষয়ের সঙ্গে সঙ্গতিপূর্ণ নয়" name="s_complaintText"/><label for="dnaacs-cq-9">আলোচনার বিষয়ের সঙ্গে সঙ্গতিপূর্ণ নয়</label>
                      </xsl:with-param>
                    </xsl:call-template>
                		<input type="radio" id="dnaacs-cq-10" value="বাংলা ও ইংরেজির বাইরে ভিন্ন ভাষায় লেখা হয়েছে" name="s_complaintText"/><label for="dnaacs-cq-10">বাংলা ও ইংরেজির বাইরে ভিন্ন ভাষায় লেখা হয়েছে</label>
                		<input type="radio" id="dnaacs-cq-11" value="বাইরের ওয়েবসাইটের লিংক রয়েছে যেটিতে লঙ্ঘিত হয়েছে সম্পাদকীয় নীতিমালা" name="s_complaintText"/><label for="dnaacs-cq-11">বাইরের ওয়েবসাইটের লিংক রয়েছে যেটিতে লঙ্ঘিত হয়েছে <a href="http://www.bbc.co.uk/messageboards/newguide/popup_editorial_guidelines.html">সম্পাদকীয় নীতিমালা</a></label>
                		<input type="radio" id="dnaacs-cq-12" value="এমন বর্ণনা রয়েছে বা এমন কাজে উৎসাহ দেয়া হয়েছে যাতে অন্য কারো নিরাপত্তা হুমকির মুখে পড়তে পারে" name="s_complaintText"/><label for="dnaacs-cq-12">এমন বর্ণনা রয়েছে বা এমন কাজে উৎসাহ দেয়া হয়েছে যাতে অন্য কারো নিরাপত্তা হুমকির মুখে পড়তে পারে</label>
                		<input type="radio" id="dnaacs-cq-13" value="অশোভন ইউজারনেম ব্যবহার করা হয়েছে" name="s_complaintText"/><label for="dnaacs-cq-13">অশোভন ইউজারনেম ব্যবহার করা হয়েছে</label>
                		<input type="radio" id="dnaacs-cq-14" value="এটি স্প্যাম" name="s_complaintText"/><label for="dnaacs-cq-14">এটি স্প্যাম</label>
                		<input type="radio" id="dnaacs-cq-6" value="অন্যান্য" name="s_complaintText"/><label for="dnaacs-cq-6">এমন নিয়ম ভঙ্গ করা হয়েছে যা ওপরের তালিকায় নেই</label>
                	</p>
                </p>

              <p class="action">
                <input type="submit" value="পরবর্তী পাতা"/>
              </p>
            </div>
            
        </form>
      <script>
        gloader.load(
        ["glow", "1", "glow.forms", "glow.dom"],
        {
        async: true,
        onLoad: function(glow) {
        var myForm = new glow.forms.Form("#complaintForm");
        myForm.addTests(
        "s_complaintText",
        ["custom", {
        arg: function(values, opts, callback, formData) {
        if (values[0] == "") {
        alert("অভিযোগের কারণ বেছে নিন");
        return;
        }
        else {
        callback(glow.forms.PASS, "");
        }
        }}]
        );

        glow.ready(function()
        glow.events.addListener(
        'a.close',
        'click',
        function(e) {
        e.stopPropagation();
        window.close();
        return false;
        }
        );
        )
        }
        }
        )
      </script>
    </xsl:template>
    
    <xsl:template match="USER-COMPLAINT-FORM | USERCOMPLAINT" mode="input_user-complaint-form">
        <form id="UserComplaintForm" action="UserComplaintPage" method="post"> 
           <div class="content"> 
           	<p>নীচের ঘরে লিখুন কেন আপনি মনে করছেন এতে  নিয়ম ভঙ্গ করা হয়েছে। লেখা শেষ হলে 'সেন্ড কমপ্লেইন্ট' বোতামে ক্লিক করুন, যাতে মডারেটর অভিযোগটি পর্য্যালোচনা করে দেখতে পারেন।</p>
               <p>
                  <xsl:if test="/H2G2/PARAMS/PARAM[NAME = 's_complaintText']/VALUE and /H2G2/PARAMS/PARAM[NAME = 's_complaintText']/VALUE = 'অন্যান্য'">
				আমি অভিযোগ করতে চাই <xsl:call-template name="item_name"/> নিচের কারণগুলোর জন্য:
                  </xsl:if>
                   
               </p>
                <p class="options">
                    <textarea id="reason" rows="10" cols="40" name="complainttext" class="textarea">
                    	<xsl:if test="/H2G2/PARAMS/PARAM[NAME = 's_complaintText']/VALUE and /H2G2/PARAMS/PARAM[NAME = 's_complaintText']/VALUE != 'অন্যান্য'">
                        <xsl:text>আমার বিশ্বাস </xsl:text>
                        <xsl:text xml:space="preserve"> </xsl:text>
                        <xsl:apply-templates select="/H2G2/PARAMS/PARAM[NAME = 's_complaintText']/VALUE" mode="library_string_stringtolower"/><xsl:text> এই কারণের জন্য</xsl:text>
                    	</xsl:if>
                    	<xsl:text> <!-- leave this!! --> </xsl:text>
                    </textarea> 
                </p>
           </div>
            
            <!-- Guidelines:
            Where a user is not signed In a email should be required, even for kids sites. 
            If a user is signed In, their registered email address will be used to avoid having to prompt the user for an email on an unsecure connection. 
            If a child is signed In on an account without an email, the site should use System messages to communicate with their users.
            -->
            <div class="content">
              <xsl:choose>
                <xsl:when test="/H2G2/VIEWING-USER/USER">
                  <!-- email address is not required in this instance -->
                </xsl:when>
                <xsl:otherwise>
                    <h3>আপনার ইমেইল ঠিকানা</h3>
                    <p>
                      <em>আপনার ইমেইল ঠিকানা আমাদের প্রয়োজন যাতে অভিযোগটি আমরা লিপিবদ্ধ করতে পারি এবং মডারেটর আপনাকে তার সিদ্ধান্ত সম্পর্কে জানাতে পারেন। অভিযোগ সম্পর্কে বিস্তারিত জানতে আপনার সাথে সরাসরি যোগাযোগেরও প্রয়োজন হতে পারে।</em>
                    </p>
                    <p>
                        <label for="emailaddress">ইমেইল ঠিকানা</label>
                        <input type="text" name="email" id="emailaddress" value="" class="textbox"/>
                    </p>
                </xsl:otherwise>
              </xsl:choose>
              
                <xsl:if test="(/H2G2/VIEWING-USER/USER/GROUPS/EDITOR) or (/H2G2/VIEWING-USER/USER/STATUS = 2) or (/H2G2/VIEWING-USER/USER/GROUPS/GROUP[NAME='EDITOR'])">
                    <p>
                        <input type="checkbox" value="1" name="hidepost" id="hidePost"/>
                        <label for="hidePost">পোস্টটি লুকিয়ে রাখুন <xsl:call-template name="item_name"/> এখুনি</label>
                    </p>
                </xsl:if>
                
                <p class="action">
                	<input type="hidden" name="s_complaintText" value="{/H2G2/PARAMS/PARAM[NAME = 's_complaintText']/VALUE}"/>
                    <input type="hidden" name="complaintreason" value="{/H2G2/PARAMS/PARAM[NAME = 's_complaintText']/VALUE}"/>
                    <input type="hidden" name="s_ptrt" value="{/H2G2/PARAMS/PARAM[NAME = 's_ptrt']/VALUE}"/>
                    <xsl:choose>
                      <xsl:when test="@POSTID">
                        <input type="hidden" value="{(POST-ID | @POSTID)[1]}" name="PostID"/>
                      </xsl:when>
                      <xsl:when test="@H2G2ID">
                        <input type="hidden" value="{@H2G2ID}" name="h2g2ID"/>
                      </xsl:when>
                      <xsl:otherwise>
                        <input type="hidden" value="{@URL}" name="url"/>
                      </xsl:otherwise>
                    </xsl:choose>
                    <input type="hidden" name="action" value="submit"/>
                    <input type="submit" value="অভিযোগ পাঠান" name="Submit" class="button"/>
                </p>
            </div>
            
        </form>
    </xsl:template>
    
    <xsl:template match="USER-COMPLAINT-FORM[ERROR] | ERROR" mode="input_user-complaint-form">
      <div class="content">
        <h2>তথ্য</h2>
        <xsl:choose>
          <xsl:when test="@TYPE = 'EMAILNOTALLOWED'">
            <p>
			অভিযোগ পাঠানোর অনলাইন সিস্টেম থেকে আপনাকে ব্লক করা হয়েছে। বিস্তারিত জানতে লিখুন:<br />
              BBC Central Communities Team<br />
              Broadcast Centre<br />
              201 Wood Lane<br />
              White City<br />
              London<br />
              W12 7TP
            </p>
          </xsl:when>
          <xsl:when test="@TYPE = 'REGISTERCOMPLAINT'">
            <p>
              Unable to register complaint
            </p>
          </xsl:when>
          <xsl:when test="@TYPE = 'EMAIL'">
            <p>
              Invalid email address
            </p>
          </xsl:when>
          <xsl:when test="@TYPE = 'NOTFOUND'">
            <p>
              Post not found
            </p>
          </xsl:when>
          <xsl:when test="@TYPE = 'InvalidVerificationCode'">
            <p>
              Verification Code is not valid
            </p>
          </xsl:when>
          <xsl:when test="@TYPE = 'AlreadyModerated'">
            <p>
              This post has already being moderated and removed.
            </p>
          </xsl:when>
          <xsl:when test ="@TYPE = 'COMPLAINTTEXT'">
            <p>
              No complaint text
            </p>
          </xsl:when>
          <xsl:when test ="@TYPE = 'COMPLAINTREASON'">
            <p>
              No complaint reason
            </p>
          </xsl:when>
          <xsl:when test="@TYPE = 'HIDEPOST'">
            <p>
              Unable to hide post
            </p>
            
          </xsl:when>
          <xsl:when test="@TYPE = 'URL'">
            <p>
              Invalid URL specified
            </p>
          </xsl:when>
        </xsl:choose>

      </div>
    </xsl:template>

  <xsl:template match="USERCOMPLAINT[@REQUIRESVERIFICATION = '1']" mode="input_user-complaint-form">
    <div class="content">
      <h2>ইমেইল যাচাই</h2>
      <p>
		আপনার অভিযোগ সাবমিট করা হয়েছে। আপনার ইমেইল ঠিকানা যাচাই না করা পর্যন্ত মডারেটর এটা দেখতে পারবেন না। জালিয়াতি এবং স্প্যামিং বন্ধের লক্ষ্যে এটা করা হয়েছে।
      </p>
      <p>
		আপনার অভিযোগ অ্যাক্টিভেট করতে ইমেইলে আপনার কাছে একটি লিংক পাঠানো হয়েছে। ঐ লিংক-এ ক্লিক করলে আপনার অভিযোগ মডারেটরের কাছে চলে যাবে। 
      </p>
      
      <p class="action">
        <a class="close">
          <xsl:attribute name="href">
            <xsl:call-template name="library_serialise_ptrt_out">
              <xsl:with-param name="string">
                 <xsl:value-of select="/H2G2/PARAMS/PARAM[NAME = 's_ptrt']/VALUE" />
              </xsl:with-param>
            </xsl:call-template>
          </xsl:attribute>
          <xsl:text>ব্রাউজ করতে থাকুন</xsl:text>
        </a>
      </p>
    </div>
  </xsl:template>

  <xsl:template match="USER-COMPLAINT-FORM[MESSAGE/@TYPE = 'SUBMIT-SUCCESSFUL'] | USERCOMPLAINT[@MODID]" mode="input_user-complaint-form">
    <div class="content">
      <h2>সফলভাবে অভিযোগ পাঠানো হয়েছে</h2>
      <p>
		আপনার অভিযোগ সফলভাবে মডারেশন টিমের কাছে পাঠানো হয়েছে। তারা সিদ্ধান্ত নেবে কোনভাবে <a href="http://www.bbc.co.uk/messageboards/newguide/popup_editorial_guidelines.html">নিয়মাবলী</a> লঙ্ঘিত হয়েছে কি না। ইমেইলের মাধ্যমে আপনাকে তাদের সিদ্ধান্ত জানিয়ে দেয়া হবে।
      </p>
      <p>
		আপনার মডারেশন রেফারেন্স আইডি: <strong>
          <xsl:value-of select="(MODERATION-REFERENCE | @MODID)[1]"/>
        </strong>
      </p>
      <xsl:if test="@HIDDEN and @HIDDEN != 0">
        <p>একইসাথে, এই পোস্টটি লুকিয়ে ফেলা হয়েছে।</p>
      </xsl:if>
      <p class="action">
        <a class="close">
          <xsl:attribute name="href">
            <xsl:call-template name="library_serialise_ptrt_out">
              <xsl:with-param name="string">
                <xsl:choose>
                  <xsl:when test="/H2G2/PARAMS/PARAM[NAME = 's_ptrt']">
                    <xsl:value-of select="/H2G2/PARAMS/PARAM[NAME = 's_ptrt']/VALUE" />
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:text>http://www.bbc.co.uk/bengali/</xsl:text>
                  </xsl:otherwise>
                </xsl:choose>

              </xsl:with-param>
            </xsl:call-template>
          </xsl:attribute>
          <xsl:text>ব্রাউজ করতে থাকুন</xsl:text>
        </a>
      </p>
    </div>
  </xsl:template>

 



</xsl:stylesheet>