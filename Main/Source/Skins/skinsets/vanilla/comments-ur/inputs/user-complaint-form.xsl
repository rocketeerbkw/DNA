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
            <h2>شکایت کے لیے <xsl:call-template name="item_name"/></h2>
            <p>یہ فارم صرف ہاؤس رولز کی خلاف ورزی کی شکایات کے لیے ہے <a href="{$houserulespopupurl}">ہاؤز رولز </a></p>
            <p>برائے مہربانی عمومی تبصرے یا کسی سوال کے لیے یہ فارم استعمال نہ کریں بلکہ اپنا پیغام مباحثے میں پوسٹ کریں</p>
            <p>جس تبصرے کے بارے میں آپ نے شکایت کی ہے اسے موڈریٹر کو بھیجا جائے گا اور وہی یہ فیصلہ کریں گے کہ ہاؤس رولز کی خلاف ورزی ہوئی ہے <a href="{$houserulespopupurl}">ہاؤز رولز </a> ان کے فیصلے کے بارے میں آپ کو بذریعہ ای میل سے مطلع کیا جائے گا</p>
            <p class="action">
              <xsl:choose>
                <xsl:when test="@POSTID">
                  <a href="?PostId={(POST-ID | @POSTID)[1]}&amp;s_ptrt={/H2G2/PARAMS/PARAM[NAME = 's_ptrt']/VALUE}&amp;s_start=2">میری شکایت رجسٹر کریں</a>
                </xsl:when>
                <xsl:when test="@H2G2ID">
                  <a href="?h2g2Id={@H2G2ID}&amp;s_ptrt={/H2G2/PARAMS/PARAM[NAME = 's_ptrt']/VALUE}&amp;s_start=2">میری شکایت رجسٹر کریں</a>
                </xsl:when>
                <xsl:otherwise>
                  <a href="?url={@URL}&amp;s_ptrt={/H2G2/PARAMS/PARAM[NAME = 's_ptrt']/VALUE}&amp;s_start=2">میری شکایت رجسٹر کریں</a>
                </xsl:otherwise>
              </xsl:choose>
            </p>
        </div>
        <xsl:call-template name="library_userstate">
            <xsl:with-param name="loggedin"></xsl:with-param>
            <xsl:with-param name="unauthorised"></xsl:with-param>
            <xsl:with-param name="loggedout">
                <div class="content">
                    <p>آپ اس ویب سائٹ کے کسی اکاؤنٹ پر سائنڈ ان نہیں ہیں۔ اگر آپ رجسٹرڈ ہیں تو سائن ان کیجیے اس سے ہمیں آپ کی شکایت سے نمٹنے میں مدد ملے گی</p>
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
                          <xsl:text>سائن ان</xsl:text>
                      </a>
                    </p>
                </div>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>

  <xsl:template name="item_name">
    <xsl:choose>
      <xsl:when test="@POSTID">
        <xsl:text>بھیجیں</xsl:text>
      </xsl:when>
      <xsl:when test="@H2G2ID">
        <xsl:text>آرٹیکل</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>کانٹینٹ آئٹم</xsl:text>
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
                
            	<h2>موڈریٹرز کو مطلع کریں</h2>
            	<p>برائے مہربانی ان <a href="{$houserulespopupurl}">ہاؤز رولز </a> کا انتخاب کریں جن کی آپ کے خیال میں خلاف ورزی کی گئی ہے <xsl:call-template name="item_name"/> اگر آپ کے خیال میں ایک سے زیادہ ہاؤس رولز کی خلاف ورزی کی گئی ہے تو برائے مہربانی سب سے سنگین ترین خلاف ورزی منتخب کریں</p>
            </div>
            
            <div class="content">
              <h2>آپ کی شکایت کی وجہ</h2>
              <p>
                میرے خیال میں  <xsl:call-template name="item_name"/> اس میں <a href="{$houserulespopupurl}">ہاؤز رولز </a> کی خلاف ورزی کی نوعیت یہ ہے کہ یہ:
              </p>
               
                <p class="options">
                	<p class="options">
                		<input type="radio" id="dnaacs-cq-1" value="ہتک آمیز یا باعث رسوائی ہے" name="s_complaintText"/><label for="dnaacs-cq-1">ہتک آمیز یا باعث رسوائی ہے</label>
                		<input type="radio" id="dnaacs-cq-2" value="تسل پرستانہ، جنسی نوعیت کا ، ہم جسنیت کے خلاف، نمایاں جنسی، گالی گلوچ یا کسی کی دل آزاری کا باعث ہے" name="s_complaintText"/><label for="dnaacs-cq-2">تسل پرستانہ، جنسی نوعیت کا ، ہم جسنیت کے خلاف، نمایاں جنسی، گالی گلوچ یا کسی کی دل آزاری کا باعث ہے</label>
                		<input type="radio" id="dnaacs-cq-3" value="گالی گلوچ یا ایسی زبان کا استعمال کیا گیا ہے جس سے کسی کی دل آزاری ہو
" name="s_complaintText"/><label for="dnaacs-cq-3">گالی گلوچ یا ایسی زبان کا استعمال کیا گیا ہے جس سے کسی کی دل آزاری ہو
</label>
                		<input type="radio" id="dnaacs-cq-4" value="ایسے قانون کی خلاف ورزی یا اسے توڑنے پر اکساتا ہے جیسا کہ کاپی رائٹ یا توہین عدالت" name="s_complaintText"/><label for="dnaacs-cq-4">ایسے قانون کی خلاف ورزی یا اسے توڑنے پر اکساتا ہے جیسا کہ <a href="http://www.bbc.co.uk/messageboards/newguide/popup_copyright.html">کاپی رائٹ</a> یا توہین عدالت </label>
                		<input type="radio" id="dnaacs-cq-5" value="فائدے یا نفع دے سکنے والی اشیاء یا خدمات کی تشہیر" name="s_complaintText"/><label for="dnaacs-cq-5">فائدے یا نفع دے سکنے والی اشیاء یا خدمات کی تشہیر</label>
                		<input type="radio" id="dnaacs-cq-7" value="خود کو کوئی اور ظاہر کیا جا رہا ہے" name="s_complaintText"/><label for="dnaacs-cq-7">خود کو کوئی اور ظاہر کیا جا رہا ہے</label>
                		<input type="radio" id="dnaacs-cq-8" value="ذاتی معلومات مثلاً ٹیلیفون نمبر، پوسٹل یا ای میل پتہ وغیرہ دیے گئے ہیں" name="s_complaintText"/><label for="dnaacs-cq-8">ذاتی معلومات مثلاً ٹیلیفون نمبر، پوسٹل یا ای میل پتہ وغیرہ دیے گئے ہیں</label>
                		<xsl:call-template name="library_userstate">
                      <xsl:with-param name="loggedin">
                        <input type="radio" id="dnaacs-cq-9" value="is off-topic for the board or subject being discussed" name="s_complaintText"/><label for="dnaacs-cq-9">اس مباحثے یا فورم کے موضوع سے متعلق نہیں</label>
                      </xsl:with-param>
                    </xsl:call-template>
                		<input type="radio" id="dnaacs-cq-10" value="انگریزی میں نہیں" name="s_complaintText"/><label for="dnaacs-cq-10">انگریزی میں نہیں</label>
                		<input type="radio" id="dnaacs-cq-11" value="کسی ایسی بیرونی ویب سائٹ کا لنک شامل ہے جو ایڈیٹوریل گائیڈ لائنز کے خلاف ہے" name="s_complaintText"/><label for="dnaacs-cq-11">کسی ایسی بیرونی ویب سائٹ کا لنک شامل ہے جو <a href="http://www.bbc.co.uk/messageboards/newguide/popup_editorial_guidelines.html">ایڈیٹوریل گائیڈ لائنز کے خلاف ہے </a></label>
                		<input type="radio" id="dnaacs-cq-12" value="ایسی بات کہی گئی ہے جس سے دوسروں کی حفاظت اور بہبود کو خطرہ ہو سکتا ہے" name="s_complaintText"/><label for="dnaacs-cq-12">ایسی بات کہی گئی ہے جس سے دوسروں کی حفاظت اور بہبود کو خطرہ ہو سکتا ہے</label>
                		<input type="radio" id="dnaacs-cq-13" value="contains an inappropriate username" name="s_complaintText"/><label for="dnaacs-cq-13">contains an inappropriate username</label>
                		<input type="radio" id="dnaacs-cq-14" value="is spam" name="s_complaintText"/><label for="dnaacs-cq-14">is spam</label>
                		<input type="radio" id="dnaacs-cq-6" value="دیگر" name="s_complaintText"/><label for="dnaacs-cq-6">کسی ایسے قانون کی خلاف ورزی جو اوپر درج نہیں ہے</label>
                	</p>
                </p>

              <p class="action">
                <input type="submit" value="اگلہ صفحہ"/>
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
        alert("برائے مہربانی شکایت کی وجہ منتخب کریں");
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
           	<p>برائے مہربانی نیچے دیے گئے خانے میں وہ وجہ درج کریں جس کی وجہ سے آپ کے خیال میں <xsl:call-template name="item_name"/> ضابطے کی خلاف ورزی ہوئی ہے۔ لکھنے کے بعد ’شکایت بھیجیں‘ کے بٹن پر کلک کریں تاکہ موڈریٹر اس کا جائزہ لے سکیں </p>
               <p>
                  <xsl:if test="/H2G2/PARAMS/PARAM[NAME = 's_complaintText']/VALUE and /H2G2/PARAMS/PARAM[NAME = 's_complaintText']/VALUE = 'دیگر'">
                    مجھے مندرجہ ذیل <xsl:call-template name="item_name"/> اسباب کی بنا پر شکایت ہیں:
                  </xsl:if>
                   
               </p>
                <p class="options">
                    <textarea id="reason" rows="10" cols="40" name="complainttext" class="textarea">
                    	<xsl:if test="/H2G2/PARAMS/PARAM[NAME = 's_complaintText']/VALUE and /H2G2/PARAMS/PARAM[NAME = 's_complaintText']/VALUE != 'دیگر'">
                        <xsl:text>میرے خیال میں یہ </xsl:text><xsl:call-template name="item_name"/>
                        <xsl:text xml:space="preserve"> </xsl:text>
                        <xsl:apply-templates select="/H2G2/PARAMS/PARAM[NAME = 's_complaintText']/VALUE" mode="library_string_stringtolower"/><xsl:text> اس وجہ سے:</xsl:text>
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
                    <h3>آپ کا ای میل ایڈریس</h3>
                    <p>
                      <em>ہمیں آپ کی شکایت کا جائزہ لینے اور موڈریٹر کے فیصلے سے آپ کو آگاہ کرنے کے لیے آپ کا ای میل ایڈریس درکار ہے۔ اگر ضرورت ہوگی تو ہم شکایت سے متعلق مزید معلومات کے لیے آپ سے براہ راست  رابطہ کر سکتے ہیں  </em>
                    </p>
                    <p>
                        <label for="emailaddress">ای میل ایڈریس</label>
                        <input type="text" name="email" id="emailaddress" value="" class="textbox"/>
                    </p>
                </xsl:otherwise>
              </xsl:choose>
              
                <xsl:if test="(/H2G2/VIEWING-USER/USER/GROUPS/EDITOR) or (/H2G2/VIEWING-USER/USER/STATUS = 2) or (/H2G2/VIEWING-USER/USER/GROUPS/GROUP[NAME='EDITOR'])">
                    <p>
                        <input type="checkbox" value="1" name="hidepost" id="hidePost"/>
                        <label for="hidePost"> اسے چھپائیں <xsl:call-template name="item_name"/> فوراً</label>.
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
                    <input type="hidden" name="action" value="بھیجیں"/>
                    <input type="submit" value="شکایت بھیجیں" name="Submit" class="button"/>
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
              آپ کو ان لائن شکایت کا نظام استعمال کرنے سے روک دیا گیا ہے۔ برائے مہربانی آپ:<br />
              BBC Central Communities Team<br />
              Broadcast Centre<br />
              201 Wood Lane<br />
              White City<br />
              London<br />
              W12 7TP
            </p>
          </xsl:when>
          <xsl:otherwise>
            <p>
              <xsl:value-of select="(ERRORMESSAGE | ERROR)[1]"/>
            </p>
          </xsl:otherwise>
        </xsl:choose>

      </div>
    </xsl:template>

  <xsl:template match="USERCOMPLAINT[@REQUIRESVERIFICATION = '1']" mode="input_user-complaint-form">
    <div class="content">
      <h2>ای میل کی تصدیق</h2>
      <p>
        آپ کی شکایت جمع ہو گئی ہے۔  جب تک آپ اپنے ای میل کی تصدیق نہیں کریں گے آپ کی شکایت پر غور نہیں کیا جائے گا۔ ای میل کی تصدیق کا مقصد غلط شناخت کے استعمال اور سپیمنگ کو روکنا ہے  
      </p>
      <p>
        آپ کو جلد ہی ایک ای میل موصول ہوگی جس میں موجود لنک سے آپ اپنی شکایت کو اکٹیویٹ کر سکیں گے۔ اس لنک پر کلک کرنے سے آپ کی شکایت موڈریٹر کو موصول ہو جائے گی
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
          <xsl:text>براؤزنگ جاری رکھیں</xsl:text>
        </a>
      </p>
    </div>
  </xsl:template>

  <xsl:template match="USER-COMPLAINT-FORM[MESSAGE/@TYPE = 'SUBMIT-SUCCESSFUL'] | USERCOMPLAINT[@MODID]" mode="input_user-complaint-form">
    <div class="content">
      <h2>شکایت کامیاب</h2>
      <p>
        آپ کی شکایت موصول ہوگئی ہے اور موڈریشن ٹیم کو بھیج دی گئی ہے۔ وہی اس بات کا فیصلہ کریں گے کہ اس تبصرے میں ہاؤس رولز کی خلاف ورزی ہوئی ہے اور آپ کو ای میل کے ذریعہ مطلع کیا جائے گا
      </p>
      <p>
        آپ کا موڈریشن ریفرنس آئی ڈی: <strong>
          <xsl:value-of select="(MODERATION-REFERENCE | @MODID)[1]"/>
        </strong>
      </p>
      <xsl:if test="@HIDDEN and @HIDDEN != 0">
        <p>اس کے علاوہ یہ پوسٹ دکھائی نہیں دے گی </p>
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
                    <xsl:text>http://www.bbc.co.uk/urdu</xsl:text>
                  </xsl:otherwise>
                </xsl:choose>

              </xsl:with-param>
            </xsl:call-template>
          </xsl:attribute>
          <xsl:text>براؤزنگ جاری رکھیں</xsl:text>
        </a>
      </p>
    </div>
  </xsl:template>

 



</xsl:stylesheet>