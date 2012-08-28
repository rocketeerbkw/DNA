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
            <h2>Скарга на <xsl:call-template name="item_name"/></h2>
            <p>Цю форму створено лише для серйозних скарг на певний контент, який порушує <a href="{$houserulespopupurl}">Правила форуму</a>.</p>
            <p>Якщо Ви маєте коментар або питання на загальну тему, будь ласка, не використовуйте цю форму. Додавайте повідомлення до загальної дискусії.</p>
            <p>Вашу скаргу буде спрямовано до модератора, і він вирішить, чи порушує коментар, на який ви поскаржилися <a href="{$houserulespopupurl}">Правила форуму</a>. Рішення буде вам повідомлено електронною поштою</p>
            <p class="action">
              <xsl:choose>
                <xsl:when test="@POSTID">
                  <a href="?PostId={(POST-ID | @POSTID)[1]}&amp;s_ptrt={/H2G2/PARAMS/PARAM[NAME = 's_ptrt']/VALUE}&amp;s_start=2">Зареєструвати мою скаргу</a>
                </xsl:when>
                <xsl:when test="@H2G2ID">
                  <a href="?h2g2Id={@H2G2ID}&amp;s_ptrt={/H2G2/PARAMS/PARAM[NAME = 's_ptrt']/VALUE}&amp;s_start=2">Зареєструвати мою скаргу</a>
                </xsl:when>
                <xsl:otherwise>
                  <a href="?url={@URL}&amp;s_ptrt={/H2G2/PARAMS/PARAM[NAME = 's_ptrt']/VALUE}&amp;s_start=2">Зареєструвати мою скаргу</a>
                </xsl:otherwise>
              </xsl:choose>
            </p>
        </div>
        <xsl:call-template name="library_userstate">
            <xsl:with-param name="loggedin"></xsl:with-param>
            <xsl:with-param name="unauthorised"></xsl:with-param>
            <xsl:with-param name="loggedout">
                <div class="content">
                    <p>Ви не увійшли в систему на цьому вебсайті. Якщо ви зареєстровані, введіть свій логін і пароль, це пришвидшить процес розгляду вашої скарги.</p>
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
                          <xsl:text>Увійти</xsl:text>
                      </a>
                    </p>
                </div>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>

  <xsl:template name="item_name">
    <xsl:choose>
      <xsl:when test="@POSTID">
        <xsl:text>повідомлення</xsl:text>
      </xsl:when>
      <xsl:when test="@H2G2ID">
        <xsl:text>стаття</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>зміст</xsl:text>
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
                
            	<h2>Повідомити модераторам</h2>
            	<p>Будь ласка, виберіть який з пунктів <a href="{$houserulespopupurl}">Правил форумів</a> на вашу думку <xsl:call-template name="item_name"/> було порушено. Якщо ви вважаєте, що було порушено більше одного пункту, будь ласка, оберіть найбільш вагоме порушення.</p>
            </div>
            
            <div class="content">
              <h2>Причина скарги</h2>
              <p>
                Я вважаю, що це <xsl:call-template name="item_name"/> може порушити одне з <a href="{$houserulespopupurl}">Правил форуму</a> тому що:
              </p>
               
                <p class="options">
                	<p class="options">
                		<input type="radio" id="dnaacs-cq-1" value="є наклепницьким чи дискредитуючим" name="s_complaintText"/><label for="dnaacs-cq-1">є наклепницьким чи дискредитуючим</label>
                		<input type="radio" id="dnaacs-cq-2" value="є расистським, сексистським, гомофобним, таким, що має сексуальний характер, лайливим чи образливим" name="s_complaintText"/><label for="dnaacs-cq-2">є расистським, сексистським, гомофобним, таким, що має сексуальний характер, лайливим чи образливим</label>
                		<input type="radio" id="dnaacs-cq-3" value="містить ненормативну лексику або інші слова, що можуть бути образливими" name="s_complaintText"/><label for="dnaacs-cq-3">містить ненормативну лексику або інші слова, що можуть бути образливими</label>
                		<input type="radio" id="dnaacs-cq-4" value="порушує закон чи провокує протизаконні дії, як то порушення авторських прав чи неповага до суду" name="s_complaintText"/><label for="dnaacs-cq-4">порушує закон чи провокує протизаконні дії, як то порушення <a href="http://www.bbc.co.uk/messageboards/newguide/popup_copyright.html">авторських прав</a> чи неповага до суду</label>
                		<input type="radio" id="dnaacs-cq-5" value="рекламування продукції чи послуг з метою отримання прибутку" name="s_complaintText"/><label for="dnaacs-cq-5">рекламування продукції чи послуг з метою отримання прибутку</label>
                		<input type="radio" id="dnaacs-cq-7" value="людина видає себе за іншу особу" name="s_complaintText"/><label for="dnaacs-cq-7">людина видає себе за іншу особу</label>
                		<input type="radio" id="dnaacs-cq-8" value="містить особисту інформацію, як то номери телефонів, поштові чи електронні адреси" name="s_complaintText"/><label for="dnaacs-cq-8">містить особисту інформацію, як то номери телефонів, поштові чи електронні адреси</label>
                		<xsl:call-template name="library_userstate">
                      <xsl:with-param name="loggedin">
                        <input type="radio" id="dnaacs-cq-9" value="не має відношення до теми обговорення" name="s_complaintText"/><label for="dnaacs-cq-9">не має відношення до теми обговорення</label>
                      </xsl:with-param>
                    </xsl:call-template>
                		<input type="radio" id="dnaacs-cq-10" value="написаний не мовою сайту" name="s_complaintText"/><label for="dnaacs-cq-10">написаний не мовою сайту</label>
                		<input type="radio" id="dnaacs-cq-11" value="містить посилання на вебсайт, який порушує Редакційні положення" name="s_complaintText"/><label for="dnaacs-cq-11">містить посилання на вебсайт, який порушує <a href="http://www.bbc.co.uk/messageboards/newguide/popup_editorial_guidelines.html">Редакційні положення</a></label>
                		<input type="radio" id="dnaacs-cq-12" value="описує чи провокує дії, що можуть зашкодити безпеці чи добробуту інших людей" name="s_complaintText"/><label for="dnaacs-cq-12">описує чи провокує дії, що можуть зашкодити безпеці чи добробуту інших людей</label>
                		<input type="radio" id="dnaacs-cq-13" value="містить недоречне ім'я користувача" name="s_complaintText"/><label for="dnaacs-cq-13">містить недоречне ім'я користувача</label>
                		<input type="radio" id="dnaacs-cq-14" value="є спамом" name="s_complaintText"/><label for="dnaacs-cq-14">є спамом</label>
                		<input type="radio" id="dnaacs-cq-6" value="Інше" name="s_complaintText"/><label for="dnaacs-cq-6">порушує правила з не зазначеної вище причини</label>
                	</p>
                </p>

              <p class="action">
                <input type="submit" value="Наступна сторінка"/>
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
        alert("Оберіть причину скарги");
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
           	<p>Будь ласка, заповніть цю форму, зазначивши причину, з якої ви вважаєте, що <xsl:call-template name="item_name"/> порушує це правило. По закінченні натисніть "Надіслати скаргу", і вона буде відправлена на розгляд модератору.</p>
               <p>
                  <xsl:if test="/H2G2/PARAMS/PARAM[NAME = 's_complaintText']/VALUE and /H2G2/PARAMS/PARAM[NAME = 's_complaintText']/VALUE = 'Інше'">
                    Я хочу поскаржитись на це <xsl:call-template name="item_name"/> тому що:
                  </xsl:if>
                   
               </p>
                <p class="options">
                    <textarea id="reason" rows="10" cols="40" name="complainttext" class="textarea">
                    	<!-- <xsl:if test="/H2G2/PARAMS/PARAM[NAME = 's_complaintText']/VALUE and /H2G2/PARAMS/PARAM[NAME = 's_complaintText']/VALUE != 'Інше'">
                        <xsl:text>Я вважаю, що це </xsl:text><xsl:call-template name="item_name"/>
                        <xsl:text xml:space="preserve"> </xsl:text>
                        <xsl:apply-templates select="/H2G2/PARAMS/PARAM[NAME = 's_complaintText']/VALUE" mode="library_string_stringtolower"/><xsl:text> Тому що:</xsl:text>
                    	</xsl:if> -->
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
                    <h3>Ваша адреса електронної пошти</h3>
                    <p>
                      <em>Нам потрібна ваша адреса електронної пошти для того, щоб розгланути вашу скаргу і повідомити вам рішення модератора. Іноді ми можемо написати вам безпосередньо, якщо ми потребуватимемо додаткову інформацію стосовно вашої скарги.</em>
                    </p>
                    <p>
                        <label for="emailaddress">Адреса електронної пошти</label>
                        <input type="text" name="email" id="emailaddress" value="" class="textbox"/>
                    </p>
                </xsl:otherwise>
              </xsl:choose>
              
                <xsl:if test="(/H2G2/VIEWING-USER/USER/GROUPS/EDITOR) or (/H2G2/VIEWING-USER/USER/STATUS = 2) or (/H2G2/VIEWING-USER/USER/GROUPS/GROUP[NAME='EDITOR'])">
                    <p>
                        <input type="checkbox" value="1" name="hidepost" id="hidePost"/>
                        <label for="hidePost"> Сховати це <xsl:call-template name="item_name"/> негайно</label>.
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
                    <input type="hidden" name="action" value="Відправити"/>
                    <input type="submit" value="Надіслати скаргу" name="Submit" class="button"/>
                </p>
            </div>
            
        </form>
    </xsl:template>
    
    <xsl:template match="USER-COMPLAINT-FORM[ERROR] | ERROR" mode="input_user-complaint-form">
      <div class="content">
        <h2>Інформація</h2>
        <xsl:choose>
          <xsl:when test="@TYPE = 'EMAILNOTALLOWED'">
            <p>
              Вам відмовлено у доступі до системи скарг, будь ласка, напишіть сюди:<br />
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
      <h2>Підтверждення адреси електронної пошти</h2>
      <p>
        Вашу скаргу було прийнято. Модератор зможе її побачити лише після того, як ви підтвердите адресу електронної пошти. Ця процедура необхідна для боротьби зі спамом.
      </p>
      <p>
        Найближчим часом ви отримаєте електронного листа з посиланням для активації вашої скарги. Натиснувши на посилання, ви надішлете свою скаргу модераторам.
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
          <xsl:text>Продовжити перегляд сайту</xsl:text>
        </a>
      </p>
    </div>
  </xsl:template>

  <xsl:template match="USER-COMPLAINT-FORM[MESSAGE/@TYPE = 'SUBMIT-SUCCESSFUL'] | USERCOMPLAINT[@MODID]" mode="input_user-complaint-form">
    <div class="content">
      <h2>Скарга успішно надіслана</h2>
      <p>
        Вашу скаргу отримано і направлено на розгляд модераторам. Вони вирішать, чи <a href="{$houserulespopupurl}">Правила форумів</a> були порушені, і повідомлять вам своє рішення електронною поштою.
      </p>
      <p>
        Номер вашої скарги: <strong>
          <xsl:value-of select="(MODERATION-REFERENCE | @MODID)[1]"/>
        </strong>
      </p>
      <xsl:if test="@HIDDEN and @HIDDEN != 0">
        <p>Цей коментар було приховано</p>
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
                    <xsl:text>http://www.bbc.co.uk/ukrainian</xsl:text>
                  </xsl:otherwise>
                </xsl:choose>

              </xsl:with-param>
            </xsl:call-template>
          </xsl:attribute>
          <xsl:text>Продовжити перегляд сайту</xsl:text>
        </a>
      </p>
    </div>
  </xsl:template>

 



</xsl:stylesheet>