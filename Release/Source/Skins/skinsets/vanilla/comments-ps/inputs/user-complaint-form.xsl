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
            <h2>د یوه نظر په اړه شکایت <xsl:call-template name="item_name"/></h2>
            <p>دا فورمه يوازې له هغو مطالبو څخه د کلک شکايت لپاره ده چې دا مقررات تر پښو لاندې کوي: <a href="{$houserulespopupurl}">د بي بي سي بحثونو کورني اصول</a></p>
            <p>که عمومي نظر يا پوښتنه لرئ، نو لطفا" دا فورمه مه کاروئ او  پر دې بحث خپل نظر خپور کړئ.</p>
            <p>هغه نظر به چې تاسې پرې شکايت کړى د پاڼې يوه مسوول ته استول کېږي او هغه به پرېکړه کوي چې سرغړونه شته او که نه <a href="{$houserulespopupurl}">د بي بي سي بحثونو کورني اصول</a>. په دې اړه پرېکړه به تاسې ته په برېښناليک کې در واستول شي.</p>
            <p class="action">
              <xsl:choose>
                <xsl:when test="@POSTID">
                  <a href="?PostId={(POST-ID | @POSTID)[1]}&amp;s_ptrt={/H2G2/PARAMS/PARAM[NAME = 's_ptrt']/VALUE}&amp;s_start=2">زما شکايت ثبت کړئ</a>
                </xsl:when>
                <xsl:when test="@H2G2ID">
                  <a href="?h2g2Id={@H2G2ID}&amp;s_ptrt={/H2G2/PARAMS/PARAM[NAME = 's_ptrt']/VALUE}&amp;s_start=2">زما شکايت ثبت کړئ</a>
                </xsl:when>
                <xsl:otherwise>
                  <a href="?url={@URL}&amp;s_ptrt={/H2G2/PARAMS/PARAM[NAME = 's_ptrt']/VALUE}&amp;s_start=2">زما شکايت ثبت کړئ</a>
                </xsl:otherwise>
              </xsl:choose>
            </p>
        </div>
        <xsl:call-template name="library_userstate">
            <xsl:with-param name="loggedin"></xsl:with-param>
            <xsl:with-param name="unauthorised"></xsl:with-param>
            <xsl:with-param name="loggedout">
                <div class="content">
                    <p>تاسې ددې وېبپاڼې د کارولو حساب ته نه ياست ننوتي.که ثبت شوى حساب لرئ، نو ورننوځئ چې دا به راسره ستاسې د شکايت په څېړلو کې مرسته وکړي.</p>
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
                          <xsl:text>ننوتل</xsl:text>
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
        <xsl:text>مقاله</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text></xsl:text>
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
                
            	<h2>د پاڼې د مسوولينو خبرول</h2>
            	<p>لطفاً غوره کړئ چې کوم يو <a href="{$houserulespopupurl}">د بي بي سي بحثونو کورني اصول</a> فکر کوئ دا <xsl:call-template name="item_name"/> تر پښو لاندې کړي. که فکر کوئ تر يوې ډېرې مقررې يې تر پښو لاندې کړي، نو تر ټولو جدي سرغړونه يې وښاياست</p>
            </div>
            
            <div class="content">
              <h2>د شکايت دليل مو</h2>
              <p>
                زما په باور دا نظر <xsl:call-template name="item_name"/> ښايي له مقرراتو څخه يې يوه تر پښو لاندې کړې وي <a href="{$houserulespopupurl}">د بي بي سي بحثونو کورني اصول</a> ځکه دا:
              </p>
               
                <p class="options">
                	<p class="options">
                		<input type="radio" id="dnaacs-cq-1" value="بدناموونکى يا سپکوونکى دى" name="s_complaintText"/><label for="dnaacs-cq-1">بدناموونکى يا سپکوونکى دى</label>
                		<input type="radio" id="dnaacs-cq-2" value="نژادپال، جنسيتپال، د همجنسبازۍ ضد، ډاگيز جنسي، سپکوونکى يا بل ډول سپکوونکى دى" name="s_complaintText"/><label for="dnaacs-cq-2">نژادپال، جنسيتپال، د همجنسبازۍ ضد، ډاگيز جنسي، سپکوونکى يا بل ډول سپکوونکى دى</label>
                		<input type="radio" id="dnaacs-cq-3" value="ښکنځل لري يا نور سپکوونکي ټکي پکې راغلي دي" name="s_complaintText"/><label for="dnaacs-cq-3">ښکنځل لري يا نور سپکوونکي ټکي پکې راغلي دي</label>
                		<input type="radio" id="dnaacs-cq-4" value="د محکمې سپکاوى د خپرېدو حققانون ماتوي يا نورو ناقانونه کړنو ته هڅول کوي لکه د ... ماتول" name="s_complaintText"/><label for="dnaacs-cq-4">د محکمې سپکاوى د خپرېدو حققانون ماتوي يا نورو ناقانونه کړنو ته هڅول کوي لکه د ... ماتول <a href="http://www.bbc.co.uk/messageboards/newguide/popup_copyright.html">د خپرېدو حق</a> د محکمې سپکاوى</label>
                		<input type="radio" id="dnaacs-cq-5" value="د خپلې گټې لپاره د محصولاتو يا خدماتو تبليغ کوي" name="s_complaintText"/><label for="dnaacs-cq-5">د خپلې گټې لپاره د محصولاتو يا خدماتو تبليغ کوي</label>
                		<input type="radio" id="dnaacs-cq-7" value="ځان د بل په نامه ښيي" name="s_complaintText"/><label for="dnaacs-cq-7">ځان د بل په نامه ښيي</label>
                		<input type="radio" id="dnaacs-cq-8" value="ځانگړي معلومات برسېره کوي، لکه د ټېلېفون شمېرې، پوستي يا برېښناليکي پتې" name="s_complaintText"/><label for="dnaacs-cq-8">ځانگړي معلومات برسېره کوي، لکه د ټېلېفون شمېرې، پوستي يا برېښناليکي پتې</label>
                		<xsl:call-template name="library_userstate">
                      <xsl:with-param name="loggedin">
                        <input type="radio" id="dnaacs-cq-9" value="له بحث سره تړاو نلري" name="s_complaintText"/><label for="dnaacs-cq-9">له بحث سره تړاو نلري</label>
                      </xsl:with-param>
                    </xsl:call-template>
                		<input type="radio" id="dnaacs-cq-10" value="ليکنه په پښتو نده" name="s_complaintText"/><label for="dnaacs-cq-10">ليکنه په پښتو نده</label>
                		<input type="radio" id="dnaacs-cq-11" value="خپرنيزي لارښوونې بلې وېبپاڼې ته لينک لري چې زموږ... تر پښو لاندې کوي" name="s_complaintText"/><label for="dnaacs-cq-11">بلې وېبپاڼې ته لينک لري چې زموږ... تر پښو لاندې کوي <a href="http://www.bbc.co.uk/messageboards/newguide/popup_editorial_guidelines.html">خپرنيزي لارښوونې</a></label>
                		<input type="radio" id="dnaacs-cq-12" value="داسې هڅې انځوروي يا يې هڅوي چې د نورو خونديتوب يا هوسايي زيانمنولى شي" name="s_complaintText"/><label for="dnaacs-cq-12">داسې هڅې انځوروي يا يې هڅوي چې د نورو خونديتوب يا هوسايي زيانمنولى شي</label>
                		<input type="radio" id="dnaacs-cq-13" value="ناوړه نوم پکې د کارېدو لپاره غوره شوى دى" name="s_complaintText"/><label for="dnaacs-cq-13">ناوړه نوم پکې د کارېدو لپاره غوره شوى دى</label>
                		<input type="radio" id="dnaacs-cq-14" value="سپم يا بېکاره څيز دى" name="s_complaintText"/><label for="dnaacs-cq-14">سپم يا بېکاره څيز دى</label>
                		<input type="radio" id="dnaacs-cq-6" value="هغه قاعده چې پاس ياده شوې نده، ماتوي" name="s_complaintText"/><label for="dnaacs-cq-6">هغه قاعده چې پاس ياده شوې نده، ماتوي</label>
                	</p>
                </p>

              <p class="action">
                <input type="submit" value="راتلونکې پاڼه"/>
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
        alert("لطفاً د شکايت دليل غوره کړئ");
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
           	<p>لطفاً په لاندې چوکاټ کې راته خپل دليل وليکئ ولې داسې بولئ چې <xsl:call-template name="item_name"/> دا قاعده ماتوي. چې کار مو بشپړ شو، د "شکايت استول" کېکاږئ چې د پاڼې يو مسوول يې وگوري</p>
               <p>
                  <xsl:if test="/H2G2/PARAMS/PARAM[NAME = 's_complaintText']/VALUE and /H2G2/PARAMS/PARAM[NAME = 's_complaintText']/VALUE = 'Other'">
                    غواړم چې پر دې شکايت وکړم <xsl:call-template name="item_name"/> په لاندې دليل:
                  </xsl:if>
                   
               </p>
                <p class="options">
                    <textarea id="reason" rows="10" cols="40" name="complainttext" class="textarea">
                    	<xsl:if test="/H2G2/PARAMS/PARAM[NAME = 's_complaintText']/VALUE and /H2G2/PARAMS/PARAM[NAME = 's_complaintText']/VALUE != 'Other'">
                        <xsl:text>زما باور دادى </xsl:text><xsl:call-template name="item_name"/>
                        <xsl:text xml:space="preserve"> </xsl:text>
                        <xsl:apply-templates select="/H2G2/PARAMS/PARAM[NAME = 's_complaintText']/VALUE" mode="library_string_stringtolower"/><xsl:text> په لاندې دليل:</xsl:text>
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
                    <h3>ستاسې برېښناليکي پته</h3>
                    <p>
                      <em>ستاسې برېښناليکي پته  ددې لپاره پکار ده چې شکايت مو وڅېړو او د پاڼې د مسوول له پرېکړې مو خبر کړو.کله کله چې د شکايت په اړه نورو معلوماتو ته اړتيا وي، ښايي مخامخ تماس هم درسره ونيسو.</em>
                    </p>
                    <p>
                        <label for="emailaddress">برېښناليکي پته</label>
                        <input type="text" name="email" id="emailaddress" value="" class="textbox"/>
                    </p>
                </xsl:otherwise>
              </xsl:choose>
              
                <xsl:if test="(/H2G2/VIEWING-USER/USER/GROUPS/EDITOR) or (/H2G2/VIEWING-USER/USER/STATUS = 2) or (/H2G2/VIEWING-USER/USER/GROUPS/GROUP[NAME='EDITOR'])">
                    <p>
                        <input type="checkbox" value="1" name="hidepost" id="hidePost"/>
                        <label for="hidePost"> دا منځپانګه پټه کړئ <xsl:call-template name="item_name"/> همدا اوس</label>
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
                    <input type="submit" value="شکايت مو واستوئ" name="Submit" class="button"/>
                </p>
            </div>
            
        </form>
    </xsl:template>
    
    <xsl:template match="USER-COMPLAINT-FORM[ERROR] | ERROR" mode="input_user-complaint-form">
      <div class="content">
        <h2>معلومات</h2>
        <xsl:choose>
          <xsl:when test="@TYPE = 'EMAILNOTALLOWED'">
            <p>
              You have been blocked from using the online complaints system, please write to:<br />
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
              شکایت نه ثبتول کېږي
            </p>
          </xsl:when>
          <xsl:when test="@TYPE = 'EMAIL'">
            <p>
              د برېښنالیک پته مو سمه نه ده
            </p>
          </xsl:when>
          <xsl:when test="@TYPE = 'NOTFOUND'">
            <p>
              تبصره مو نه موندل کېږي
            </p>
          </xsl:when>
          <xsl:when test="@TYPE = 'InvalidVerificationCode'">
            <p>
              تبصره مو نه موندل کېږي
            </p>
          </xsl:when>
          <xsl:when test="@TYPE = 'AlreadyModerated'">
            <p>
              دغه تبصره له ارزونې وروسته پاکه شوې ده
            </p>
          </xsl:when>
          <xsl:when test ="@TYPE = 'COMPLAINTTEXT'">
            <p>
              د شکایت متن نه شته
            </p>
          </xsl:when>
          <xsl:when test ="@TYPE = 'COMPLAINTREASON'">
            <p>
              د شکایت دلیل نه شته
            </p>
          </xsl:when>
          <xsl:when test="@TYPE = 'HIDEPOST'">
            <p>
              تبصره نه لرې کېږي
            </p>
            
          </xsl:when>
          <xsl:when test="@TYPE = 'URL'">
            <p>
              د ویبپاڼې ادرس مو سم نه دی
            </p>
          </xsl:when>
        </xsl:choose>

      </div>
    </xsl:template>

  <xsl:template match="USERCOMPLAINT[@REQUIRESVERIFICATION = '1']" mode="input_user-complaint-form">
    <div class="content">
      <h2>د برېښناليک تاييد</h2>
      <p>
        ستاسې شکايت وسپارل شو.تر هغو چې مو د خپل برېښناليک تاييد نه وي کړى، د پاڼې مسوول يې نه څېړي. دا کار ځکه کېږي چې څوک د بل په نامه ځان تېر نکړي او د بېکاره څيزونو يا سپم مخه ونيول شي.
      </p>
      <p>
        ډېر ژر به له يوه لېنک سره برېښناليک درورسېږي چې خپل شکايت پکې فعال کړئ. ددغه لېنک کېکاږل به مو شکايت د پاڼې مسوول ته ورسوي.
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
          <xsl:text>د وېبپاڼې لټون ته دوام ورکړئ</xsl:text>
        </a>
      </p>
    </div>
  </xsl:template>

  <xsl:template match="USER-COMPLAINT-FORM[MESSAGE/@TYPE = 'SUBMIT-SUCCESSFUL'] | USERCOMPLAINT[@MODID]" mode="input_user-complaint-form">
    <div class="content">
      <h2>شکايت مو ورسېد</h2>
      <p>
        شکايت مو سم را ورسېد او د مسوولينو ډلې ته واستول شو. هغوى به دا پرېکړه کوي چې آيا په دې کې <a href="{$houserulespopupurl}">د ویبپاڼې اصول</a> ناقص شوی او تاسې ته به معلومات په برېښناليک در واستول شي.
      </p>
      <p>
        ستاسې د شکايت شمېره ده: <strong>
          <xsl:value-of select="(MODERATION-REFERENCE | @MODID)[1]"/>
        </strong>
      </p>
      <xsl:if test="@HIDDEN and @HIDDEN != 0">
        <p>سربېره پرې دې، دغه متن پټ کړى شو</p>
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
                    <xsl:text>http://www.bbc.co.uk/pashto</xsl:text>
                  </xsl:otherwise>
                </xsl:choose>

              </xsl:with-param>
            </xsl:call-template>
          </xsl:attribute>
          <xsl:text>د وېبپاڼې لټون ته دوام ورکړئ</xsl:text>
        </a>
      </p>
    </div>
  </xsl:template>

 



</xsl:stylesheet>