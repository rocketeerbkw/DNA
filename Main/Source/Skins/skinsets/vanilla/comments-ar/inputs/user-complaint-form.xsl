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
            <h2>اشتكي حول <xsl:call-template name="item_name"/></h2>
            <p>هذه الاستمارة مخصصة للشكاوى الخطيرة ضد أي محتوى ينتهك <a href="http://www.bbc.co.uk/arabic/institutional/2011/09/000000_comments_houserules.shtml">شروط المشاركة</a>.</p>
            <p>إن كان لديك تعليق عام أو سؤال يرجى عدم استخدام هذه الاستمارة. أرسل تعليقك أو سؤالك ضمن حوار ما.</p>
            <p>المشاركة التي تشكو ضدها سترسل للمحرر و هو سينظر في ما إذا كانت بالفعل انتهكت <a href="http://www.bbc.co.uk/arabic/institutional/2011/09/000000_comments_houserules.shtml">شروط المشاركة</a>. سنقوم بإبالغك بالنتيجة عبر الإيميل.</p>
            <p class="action">
              <xsl:choose>
                <xsl:when test="@POSTID">
                  <a href="?PostId={(POST-ID | @POSTID)[1]}&amp;s_ptrt={/H2G2/PARAMS/PARAM[NAME = 's_ptrt']/VALUE}&amp;s_start=2">سجل شكواي</a>
                </xsl:when>
                <xsl:when test="@H2G2ID">
                  <a href="?h2g2Id={@H2G2ID}&amp;s_ptrt={/H2G2/PARAMS/PARAM[NAME = 's_ptrt']/VALUE}&amp;s_start=2">سجل شكواي</a>
                </xsl:when>
                <xsl:otherwise>
                  <a href="?url={@URL}&amp;s_ptrt={/H2G2/PARAMS/PARAM[NAME = 's_ptrt']/VALUE}&amp;s_start=2">سجل شكواي</a>
                </xsl:otherwise>
              </xsl:choose>
            </p>
        </div>
        <xsl:call-template name="library_userstate">
            <xsl:with-param name="loggedin"></xsl:with-param>
            <xsl:with-param name="unauthorised"></xsl:with-param>
            <xsl:with-param name="loggedout">
                <div class="content">
                    <p>أنت لست مسجلاً في حساب خاص على هذا الموقع. إذا كنت مسجلاً يرجى الدخول على حسابك لكي تتم عملية الشكوى بشكل صحيح.</p>
                    <p class="action">
                      <a>
                      	<xsl:attribute name="href">
                         <xsl:choose>
	                		<xsl:when test="/H2G2/SITE/IDENTITYSIGNIN != 1">
                              <xsl:apply-templates select="/H2G2/VIEWING-USER" mode="library_memberservice_loginurl">
                                  <xsl:with-param name="ptrt" select="concat($root,  '/UserComplaintPage?PostID=', (POST-ID | @POSTID)[1], '&amp;s_start=2')" />
                                <xsl:with-param name="loc">ar-SA</xsl:with-param>
                              </xsl:apply-templates>
		                     </xsl:when>
		                     <xsl:otherwise>
                              <xsl:apply-templates select="/H2G2/VIEWING-USER" mode="library_identity_loginurl">
                                  <xsl:with-param name="ptrt" select="concat('/UserComplaintPage?PostID=', (POST-ID | @POSTID)[1])" />
                                <xsl:with-param name="loc">ar-SA</xsl:with-param>
                              </xsl:apply-templates>
		                     </xsl:otherwise>
		                  </xsl:choose>
		                  </xsl:attribute>
                          <xsl:text>تسجيل الدخول</xsl:text>
                      </a>
                    </p>
                </div>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>

  <xsl:template name="item_name">
    <xsl:choose>
      <xsl:when test="@POSTID">
        <xsl:text>المشاركة</xsl:text>
      </xsl:when>
      <xsl:when test="@H2G2ID">
        <xsl:text>الموضوع</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>البند</xsl:text>
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
                
            	<h2>تنبيه المحررين</h2>
            	<p>الرجاء تحديد أي من <a href="http://www.bbc.co.uk/arabic/institutional/2011/09/000000_comments_houserules.shtml">شروط المشاركة</a> تعتقد بأنه <xsl:call-template name="item_name"/> قد خرق. إذا كنت تعتقد بأنه تم خرق أكثر من شرط واحد يرجى اختيار الخرق الأخطر.</p>
            </div>
            
            <div class="content">
              <h2>سبب الشكوى</h2>
              <p>
              	أعتقد بأن هذه المشاركةأعتقد بأن هذه المشاركة <xsl:call-template name="item_name"/> يمكن أن تكون أخلت بإحدى <a href="http://www.bbc.co.uk/arabic/institutional/2011/09/000000_comments_houserules.shtml">شروط المشاركة</a> لأنها:                
              </p>
               
                <p class="options">
                	<p class="options">
                		<input type="radio" id="dnaacs-cq-1" value="تحتوي على تشهير أو افتراء" name="s_complaintText"/><label for="dnaacs-cq-1">تحتوي على تشهير أو افتراء</label>
                		<input type="radio" id="dnaacs-cq-2" value="تشتمل على إساءة عنصرية، إساءة على أساس الجنس أو تجاه المثليين، بذيئة، أو مسيئة بشكل عام." name="s_complaintText"/><label for="dnaacs-cq-2">تشتمل على إساءة عنصرية، إساءة على أساس الجنس أو تجاه المثليين، بذيئة، أو مسيئة بشكل عام.</label>
                		<input type="radio" id="dnaacs-cq-3" value="تحتوي على ألفاظ نابية أو إساءة محتملة" name="s_complaintText"/><label for="dnaacs-cq-3">تحتوي على ألفاظ نابية أو إساءة محتملة</label>
                		<input type="radio" id="dnaacs-cq-4" value="فيها انتهاك للقانون أو تؤيد و تحرض على انتهاكه عن طريق خرق حقوق النشر أو ازدراء المحاكم." name="s_complaintText"/><label for="dnaacs-cq-4">فيها انتهاك للقانون أو تؤيد و تحرض على انتهاكه عن طريق خرق <a href="http://www.bbc.co.uk/arabic/institutional/2011/10/000000_copyright.shtml">حقوق النشر</a> أو ازدراء المحاكم.</label>
                		<input type="radio" id="dnaacs-cq-5" value="تقوم بالدعاية لسلع أو منتجات لمصلحة أو ربح شخصي" name="s_complaintText"/><label for="dnaacs-cq-5">تقوم بالدعاية لسلع أو منتجات لمصلحة أو ربح شخصي</label>
                		<input type="radio" id="dnaacs-cq-7" value="تنتحل شخصية ما." name="s_complaintText"/><label for="dnaacs-cq-7">تنتحل شخصية ما.</label>
                		<input type="radio" id="dnaacs-cq-8" value="تحتوي على معلومات شخصية كرقم الهاتف أو العنوان البريدي أو الالكتروني" name="s_complaintText"/><label for="dnaacs-cq-8">تحتوي على معلومات شخصية كرقم الهاتف أو العنوان البريدي أو الالكتروني</label>
                		<xsl:call-template name="library_userstate">
                      <xsl:with-param name="loggedin">
                        <input type="radio" id="dnaacs-cq-9" value="خارجة عن إطار الموضوع الذي يتم نقاشه" name="s_complaintText"/><label for="dnaacs-cq-9">خارجة عن إطار الموضوع الذي يتم نقاشه</label>
                      </xsl:with-param>
                    </xsl:call-template>
                		<input type="radio" id="dnaacs-cq-10" value="ليست باللغة العربية" name="s_complaintText"/><label for="dnaacs-cq-10">ليست باللغة العربية</label>
                		<input type="radio" id="dnaacs-cq-11" value="تحتوي على رابط الكتروني خارجي مما ينافي إرشادات التحرير المعمول بها" name="s_complaintText"/><label for="dnaacs-cq-11">تحتوي على رابط الكتروني خارجي مما ينافي <a href="http://www.bbc.co.uk/arabic/institutional/2011/10/000000_editorial_guidelines.shtml">إرشادات التحرير</a> المعمول بها</label>
                		<input type="radio" id="dnaacs-cq-12" value="تصف أو تشجع أنشطة قد تعرض الآخرين للخطر" name="s_complaintText"/><label for="dnaacs-cq-12">تصف أو تشجع أنشطة قد تعرض الآخرين للخطر</label>
                		<input type="radio" id="dnaacs-cq-13" value="تحتوي على اسم استخدام مخل بالذوق العام." name="s_complaintText"/><label for="dnaacs-cq-13">تحتوي على اسم استخدام مخل بالذوق العام.</label>
                		<input type="radio" id="dnaacs-cq-14" value="غير مرغوب بها من ناحية السياق أو التكرار أو الدعاية" name="s_complaintText"/><label for="dnaacs-cq-14">غير مرغوب بها من ناحية السياق أو التكرار أو الدعاية</label>
                		<input type="radio" id="dnaacs-cq-6" value="تنتهك  الشروط لسبب غير مذكور أعلاه" name="s_complaintText"/><label for="dnaacs-cq-6">تنتهك  الشروط لسبب غير مذكور أعلاه</label>
                	</p>
                </p>

              <p class="action">
                <input type="submit" value="الصفحة التالية"/>
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
        alert("الرجاء اختيار سبب للشكوى");
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
           	<p>الرجاء ملء الصندوق أدناه لإبلاغنا بالسبب الذي يجعلك تشتكي ضد المشاركة <xsl:call-template name="item_name"/>. عند انتهائك، اضغط على أرسل الشكوى لكي يتم النظر فيها من قبل المشرف.</p>
               <p>
                  <xsl:if test="/H2G2/PARAMS/PARAM[NAME = 's_complaintText']/VALUE and /H2G2/PARAMS/PARAM[NAME = 's_complaintText']/VALUE = 'Other'">
                    أود تقديم شكوى ضد هذه المشاركة <xsl:call-template name="item_name"/> للسبب الآتي:
                  </xsl:if>
                   
               </p>
                <p class="options">
                    <textarea id="reason" rows="10" cols="40" name="complainttext" class="textarea">
                    	<xsl:if test="/H2G2/PARAMS/PARAM[NAME = 's_complaintText']/VALUE and /H2G2/PARAMS/PARAM[NAME = 's_complaintText']/VALUE != 'Other'">
                    	<xsl:text>أعتقد بأن هذه المشاركة </xsl:text><xsl:call-template name="item_name"/><xsl:text> فيها إخلال لشروط المشاركة لأنها </xsl:text><xsl:apply-templates select="/H2G2/PARAMS/PARAM[NAME = 's_complaintText']/VALUE" mode="library_string_stringtolower"/><xsl:text> .</xsl:text>
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
                    <h3>بريدك الالكتروني</h3>
                    <p>
                      <em>نحتاج لبريدك الالكتروني لكي نقوم بتحويل شكواك و نخبرك بقرار المشرف. أحياناً قد نضطر للاتصال بك مباشرة إن احتجنا إلى المزيد من المعلومات حول شكواك.</em>
                    </p>
                    <p>
                        <label for="emailaddress">البريد الالكتروني</label>
                        <input type="text" name="email" id="emailaddress" value="" class="textbox"/>
                    </p>
                </xsl:otherwise>
              </xsl:choose>
              
                <xsl:if test="(/H2G2/VIEWING-USER/USER/GROUPS/EDITOR) or (/H2G2/VIEWING-USER/USER/STATUS = 2) or (/H2G2/VIEWING-USER/USER/GROUPS/GROUP[NAME='EDITOR'])">
                    <p>
                        <input type="checkbox" value="1" name="hidepost" id="hidePost"/>
                        <label for="hidePost">إخفاء هذه المشاركة <xsl:call-template name="item_name"/> فوراً.</label>.
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
                    <input type="submit" value="ارسل الشكوى" name="Submit" class="button"/>
                </p>
            </div>
            
        </form>
    </xsl:template>
    
    <xsl:template match="USER-COMPLAINT-FORM[ERROR] | ERROR" mode="input_user-complaint-form">
      <div class="content">
        <h2>للعلم</h2>
        <xsl:choose>
          <xsl:when test="@TYPE = 'EMAILNOTALLOWED'">
            <p>
              تم منعك من إرسال شكاوى عن طريق نظام الشكوى الالكتروني. يرجى توجيه رسالة لـ:<br />
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
      <h2>التأكد من البريد الالكتروني</h2>
      <p>
        تم استلام شكواك و لكنها لن تصل إلى المشرف إلا بعد أن يتم التأكد من بريدك الالكتروني. هذا سيقي من انتحال الشخصيات و التكرار.
      </p>
      <p>
        بعد قليل ستصلك رسالة إلكترونية فيها رابط لتفعيل الشكوى التي قدمتها. الضغط على الرابط سيرسل شكواك للمشرف.
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
          <xsl:text>واصل التصفح</xsl:text>
        </a>
      </p>
    </div>
  </xsl:template>

  <xsl:template match="USER-COMPLAINT-FORM[MESSAGE/@TYPE = 'SUBMIT-SUCCESSFUL'] | USERCOMPLAINT[@MODID]" mode="input_user-complaint-form">
    <div class="content">
      <h2>الشكوى ناجحة</h2>
      <p>
        تم إستلام شكواك و إرسالها لفريق الإشراف. سيقررون ما إذا كانت <a href="http://www.bbc.co.uk/arabic/institutional/2011/09/000000_comments_houserules.shtml">شروط المشاركة</a> قد انتهكت و سيطلعونك على قرارهم عن طريق بريدك الالكتروني.
      </p>
      <p>
        الرقم الخاص بمشاركتك: <strong>
          <xsl:value-of select="(MODERATION-REFERENCE | @MODID)[1]"/>
        </strong>
      </p>
      <xsl:if test="@HIDDEN and @HIDDEN != 0">
        <p>بالإضافة إلى ذلك، سيتم إخفاء هذه المشاركة.</p>
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
                    <xsl:text>http://www.bbc.co.uk/</xsl:text>
                  </xsl:otherwise>
                </xsl:choose>

              </xsl:with-param>
            </xsl:call-template>
          </xsl:attribute>
          <xsl:text>واصل التصفح</xsl:text>
        </a>
      </p>
    </div>
  </xsl:template>

 



</xsl:stylesheet>