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
            <h2>شکایت درباره اظهارنظر <xsl:call-template name="item_name"/></h2>
            <p>این فرم فقط برای  شکایت های جدی درباره محتوای خاصی است که ناقض مقررات است: <a href="http://www.bbc.co.uk/persian/institutional/2012/08/000000_ugc_rules_gel.shtml">مقررات صفحه</a>.</p>
            <p>اگر نظری کلی یا پرسشی دارید، لطفا از این فرم استفاده نکنید و پیام خود را به صورت اظهار نظر درباره بحث ارسال کنید.</p>
            <p>پیامی که از آن شکایت می کنید به یکی از مسئولان صفحه ارسال می شود تا احتمال نقض  مقررات را بررسی کند: <a href="http://www.bbc.co.uk/persian/institutional/2012/08/000000_ugc_rules_gel.shtml">مقررات صفحه</a>. تصمیم نهایی در این باره با ایمیل به اطلاع شما خواهد رسید.</p>
            <p class="action">
              <xsl:choose>
                <xsl:when test="@POSTID">
                  <a href="?PostId={(POST-ID | @POSTID)[1]}&amp;s_ptrt={/H2G2/PARAMS/PARAM[NAME = 's_ptrt']/VALUE}&amp;s_start=2">ثبت شکایت</a>
                </xsl:when>
                <xsl:when test="@H2G2ID">
                  <a href="?h2g2Id={@H2G2ID}&amp;s_ptrt={/H2G2/PARAMS/PARAM[NAME = 's_ptrt']/VALUE}&amp;s_start=2">ثبت شکایت</a>
                </xsl:when>
                <xsl:otherwise>
                  <a href="?url={@URL}&amp;s_ptrt={/H2G2/PARAMS/PARAM[NAME = 's_ptrt']/VALUE}&amp;s_start=2">Rثبت شکایت</a>
                </xsl:otherwise>
              </xsl:choose>
            </p>
        </div>
        <xsl:call-template name="library_userstate">
            <xsl:with-param name="loggedin"></xsl:with-param>
            <xsl:with-param name="unauthorised"></xsl:with-param>
            <xsl:with-param name="loggedout">
                <div class="content">
                    <p>شما وارد حساب کاربری در این سایت نشده اید. اگر حساب کاربری دارید لطفا وارد آن شوید زیرا در رسیدگی به شکایت شما، به ما کمک می کند.</p>
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
                          <xsl:text>ورود</xsl:text>
                      </a>
                    </p>
                </div>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>

  <xsl:template name="item_name">
    <xsl:choose>
      <xsl:when test="@POSTID">
        <xsl:text>اظهارنظر</xsl:text>
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
                
            	<h2>آگاه ساختن مسئولان</h2>
            	<p>لطفا انتخاب کنید کدامیک از <a href="http://www.bbc.co.uk/persian/institutional/2012/08/000000_ugc_rules_gel.shtml">مقررات سایت</a> به نظر شما نقض شده است.اگر فکر می کنید این نظر بیش از یکی از مقررات را نقض کرده است لطفا  موردی را که بیشتر نقض شده انتخاب کنید.</p>
            </div>
            
            <div class="content">
              <h2>دلیل شکایت شما</h2>
              <p>
                به عقیده من <xsl:call-template name="item_name"/> یکی از  مقررات را ممکن است نقض کرده باشد، زیرا: 
              </p>
               
                <p class="options">
                	<p class="options">
                		<input type="radio" id="dnaacs-cq-1" value="افترا آمیز یا توهین آمیز است" name="s_complaintText"/><label for="dnaacs-cq-1">افترا آمیز یا توهین آمیز است</label>
                		<input type="radio" id="dnaacs-cq-2" value="نژاد پرستانه، حاوی تبعیض جنسی، ضد همجنسگرایی، حاوی اشاره های آشکار جنسی، توهین آمیز و یا به هر حال اهانت آمیز است" name="s_complaintText"/><label for="dnaacs-cq-2">نژاد پرستانه، حاوی تبعیض جنسی، ضد همجنسگرایی، حاوی اشاره های آشکار جنسی، توهین آمیز و یا به هر حال اهانت آمیز است</label>
                		<input type="radio" id="dnaacs-cq-3" value="دارای فحش یا لحنی است که ممکن است توهین آمیز باشد" name="s_complaintText"/><label for="dnaacs-cq-3">دارای فحش یا لحنی است که ممکن است توهین آمیز باشد</label>
                		<input type="radio" id="dnaacs-cq-4" value="قانون را می شکند یا  اقدامی غیرقانونی را ترغیب یا از آن چشم پوشی می کند، مانند نقض حقوق انحصاری آثار یا اهانت به دادگاه" name="s_complaintText"/><label for="dnaacs-cq-4">قانون را می شکند یا  اقدامی غیرقانونی را ترغیب یا از آن چشم پوشی می کند، مانند نقض <a href="http://www.bbc.co.uk/persian/institutional/2011/04/000001_terms.shtml">حقوق انحصاری آثار</a> یا اهانت به دادگاه</label>
                		<input type="radio" id="dnaacs-cq-5" value="خدمات و کالاهایی را برای کسب سود تبلیغ می کند" name="s_complaintText"/><label for="dnaacs-cq-5">خدمات و کالاهایی را برای کسب سود تبلیغ می کند</label>
                		<input type="radio" id="dnaacs-cq-7" value="با این نظر، کسی خود را جای کس دیگری جا می  زند" name="s_complaintText"/><label for="dnaacs-cq-7">با این نظر، کسی خود را جای کس دیگری جا می  زند</label>
                		<input type="radio" id="dnaacs-cq-8" value="شامل اطلاعات شخصی است مانند شماره تلفن، نشانی پستی یا ایمیل" name="s_complaintText"/><label for="dnaacs-cq-8">شامل اطلاعات شخصی است مانند شماره تلفن، نشانی پستی یا ایمیل</label>
                		<xsl:call-template name="library_userstate">
                      <xsl:with-param name="loggedin">
                        <input type="radio" id="dnaacs-cq-9" value="غیرمرتبط با موضوع است" name="s_complaintText"/><label for="dnaacs-cq-9">غیرمرتبط با موضوع است</label>
                      </xsl:with-param>
                    </xsl:call-template>
                		<input type="radio" id="dnaacs-cq-10" value="به زبان فارسی نیست" name="s_complaintText"/><label for="dnaacs-cq-10">به زبان فارسی نیست</label>
                		<input type="radio" id="dnaacs-cq-11" value="شامل لینکی به یک سایت دیگر است که مقررات ما را نقض می کند:دستورالعمل حرفه ای بی بی سی" name="s_complaintText"/><label for="dnaacs-cq-11">شامل لینکی به یک سایت دیگر است که مقررات ما را نقض می کند:<a href="http://www.bbc.co.uk/messageboards/newguide/popup_editorial_guidelines.html">دستورالعمل حرفه ای بی بی سی</a></label>
                		<input type="radio" id="dnaacs-cq-12" value="کارهایی را توضیح می دهد یا ترغیب می کند که می تواند دیگران به خطر بیندازد" name="s_complaintText"/><label for="dnaacs-cq-12">کارهایی را توضیح می دهد یا ترغیب می کند که می تواند دیگران به خطر بیندازد</label>
                		<input type="radio" id="dnaacs-cq-13" value="شامل یک نام کاربری نامناسب است" name="s_complaintText"/><label for="dnaacs-cq-13">شامل یک نام کاربری نامناسب است</label>
                		<input type="radio" id="dnaacs-cq-14" value="هرزنامه است" name="s_complaintText"/><label for="dnaacs-cq-14">هرزنامه است</label>
                		<input type="radio" id="dnaacs-cq-6" value="دلایل دیگر" name="s_complaintText"/><label for="dnaacs-cq-6">مقررات را به دلیلی که در بالا نیامده نقض می کند</label>
                	</p>
                </p>

              <p class="action">
                <input type="submit" value="صفحه بعد"/>
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
        alert("لطفا دلیل شکایت را انتخاب کنید");
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
           	<p>لطفا در پنجره زیر دلیلی را که فکر می کنید <xsl:call-template name="item_name"/> این نظر، مقررات را نقض کرده  بنویسید و روی ارسال شکایت کلیک کنید.</p>
               <p>
                  <xsl:if test="/H2G2/PARAMS/PARAM[NAME = 's_complaintText']/VALUE and /H2G2/PARAMS/PARAM[NAME = 's_complaintText']/VALUE = 'دلایل دیگر'">
                    می خواهم در این باره شکایت کنم <xsl:call-template name="item_name"/> به دلیل زیر:
                  </xsl:if>
                   
               </p>
                <p class="options">
                    <textarea id="reason" rows="10" cols="40" name="complainttext" class="textarea">
                    	<xsl:if test="/H2G2/PARAMS/PARAM[NAME = 's_complaintText']/VALUE and /H2G2/PARAMS/PARAM[NAME = 's_complaintText']/VALUE != 'دلایل دیگر'">
                        <xsl:text> </xsl:text><!-- <xsl:call-template name="item_name"/> -->
                        <xsl:text xml:space="preserve"> </xsl:text>
                        <xsl:apply-templates select="/H2G2/PARAMS/PARAM[NAME = 's_complaintText']/VALUE" mode="library_string_stringtolower"/><xsl:text> </xsl:text>
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
                    <h3>ایمیل شما</h3>
                    <p>
                      <em>ما ایمیل شما را برای رسیدگی به شکایتتان و اطلاع رسانی به شما درباره تصمیم نهایی درباره شکایت نیاز داریم.  احتمال دارد که برای کسب اطلاعات بیشتر درباره شکایت نیز با شما تماس بگیریم.</em>
                    </p>
                    <p>
                        <label for="emailaddress">ایمیل</label>
                        <input type="text" name="email" id="emailaddress" value="" class="textbox"/>
                    </p>
                </xsl:otherwise>
              </xsl:choose>
              
                <xsl:if test="(/H2G2/VIEWING-USER/USER/GROUPS/EDITOR) or (/H2G2/VIEWING-USER/USER/STATUS = 2) or (/H2G2/VIEWING-USER/USER/GROUPS/GROUP[NAME='EDITOR'])">
                    <p>
                        <input type="checkbox" value="1" name="hidepost" id="hidePost"/>
                        <label for="hidePost"> پنهان کردن <xsl:call-template name="item_name"/> فوری این اظهارنظر</label>
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
                    <input type="submit" value="شکایت خود را بفرستید" name="Submit" class="button"/>
                </p>
            </div>
            
        </form>
    </xsl:template>
    
    <xsl:template match="USER-COMPLAINT-FORM[ERROR] | ERROR" mode="input_user-complaint-form">
      <div class="content">
        <h2>اطلاعات</h2>
        <xsl:choose>
          <xsl:when test="@TYPE = 'EMAILNOTALLOWED'">
            <p>
              شما امکان استفاده از سیستم ارسال شکایت اینترنتی را ندارید. لطفا به این نشانی نامه بنویسید<br />
              Broadcast Centre<br />
              201 Wood Lane<br />
              White City<br />
              London<br />
              W12 7TP
            </p>
          </xsl:when>
          <xsl:when test="@TYPE = 'REGISTERCOMPLAINT'">
            <p>
             ثبت شکایت امکانپذیر نیست
            </p>
          </xsl:when>
          <xsl:when test="@TYPE = 'EMAIL'">
            <p>
              نشانی ایمیل معتبر نیست
            </p>
          </xsl:when>
          <xsl:when test="@TYPE = 'NOTFOUND'">
            <p>
              مطلب پیدا نشد
            </p>
          </xsl:when>
          <xsl:when test="@TYPE = 'InvalidVerificationCode'">
            <p>
              رمز شناسایی معتبر نیست
            </p>
          </xsl:when>
          <xsl:when test="@TYPE = 'AlreadyModerated'">
            <p>
              نظرهای این مطلب بررسی شد و مطلب حذف شد
            </p>
          </xsl:when>
          <xsl:when test ="@TYPE = 'COMPLAINTTEXT'">
            <p>
              شکایتی وجود ندارد
            </p>
          </xsl:when>
          <xsl:when test ="@TYPE = 'COMPLAINTREASON'">
            <p>
             دلیل شکایت ذکر نشده
            </p>
          </xsl:when>
          <xsl:when test="@TYPE = 'HIDEPOST'">
            <p>
              پنهان شدن مطلب ممکن نیست
            </p>
            
          </xsl:when>
          <xsl:when test="@TYPE = 'URL'">
            <p>
             آدرس سایت اشتباه ذکر شده
            </p>
          </xsl:when>
        </xsl:choose>

      </div>
    </xsl:template>

  <xsl:template match="USERCOMPLAINT[@REQUIRESVERIFICATION = '1']" mode="input_user-complaint-form">
    <div class="content">
      <h2>تایید ایمیل</h2>
      <p>
        شکایت شما ارسال شد. تا زمانی که شما نشانی ایمیلتان را تایید نکنید، شکایت شما توسط مسئولان خوانده نخواهد شد. این کار برای پیشگیری از ارسال هرزنامه یا جا زدن خود به عنوان شخصی دیگر انجام می شود.
      </p>
      <p>
        شما بزودی ایمیلی دریافت می کنید که حاوی یک لینک برای فعال سازی شکایت شماست. با کلیک کردن روی این لینک شکایت شما به مسئولان ارسال خواهد شد. 
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
          <xsl:text>ادامه </xsl:text>
        </a>
      </p>
    </div>
  </xsl:template>

  <xsl:template match="USER-COMPLAINT-FORM[MESSAGE/@TYPE = 'SUBMIT-SUCCESSFUL'] | USERCOMPLAINT[@MODID]" mode="input_user-complaint-form">
    <div class="content">
      <h2>ارسال شکایت موفقیت آمیز بود</h2>
      <p>
        شکایت شما ارسال شد. تا زمانی که شما نشانی ایمیلتان را تایید نکنید، شکایت شما توسط مسئولان خوانده نخواهد شد. این کار برای پیشگیری از ارسال هرزنامه یا جا زدن خود به عنوان شخصی دیگر انجام می شود.
      </p>
      <p>
        شماره شکایت شما این است: <strong>
          <xsl:value-of select="(MODERATION-REFERENCE | @MODID)[1]"/>
        </strong>
      </p>
      <xsl:if test="@HIDDEN and @HIDDEN != 0">
        <p>همچنین این متن پنهان شده است.</p>
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
                    <xsl:text>http://www.bbc.co.uk/persian</xsl:text>
                  </xsl:otherwise>
                </xsl:choose>

              </xsl:with-param>
            </xsl:call-template>
          </xsl:attribute>
          <xsl:text>ادامه </xsl:text>
        </a>
      </p>
    </div>
  </xsl:template>

 



</xsl:stylesheet>