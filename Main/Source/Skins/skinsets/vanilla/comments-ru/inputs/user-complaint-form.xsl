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
            <h2>Пожаловаться на <xsl:call-template name="item_name"/></h2>
            <p>Эта форма должна быть использована лишь для серьезных жалоб на определенное содержание комментария, которое нарушает <a href="http://www.bbc.co.uk/russian/institutional/2011/02/000000_g_forum_rules.shtml">Правила форумов Би-би-си</a>.</p>
            <p>Если ваш комментарий носит общий характер или представляет собой вопрос, не используйте эту форму. Воспользуйтесь либо системой отправки комментариев, либо формой обратной связи.</p>
            <p>Ваша жалоба будет отправлена модератору, который решит, нарушает ли комментарий, на который вы жалуетесь <a href="http://www.bbc.co.uk/russian/institutional/2011/02/000000_g_forum_rules.shtml">Правила форумов Би-би-си</a>. Вы получите электронное письмо с решением модератора по поводу вашей жалобы.</p>
            <p class="action">
              <xsl:choose>
                <xsl:when test="@POSTID">
                  <a href="?PostId={(POST-ID | @POSTID)[1]}&amp;s_ptrt={/H2G2/PARAMS/PARAM[NAME = 's_ptrt']/VALUE}&amp;s_start=2">Зарегистрировать мою жалобу</a>
                </xsl:when>
                <xsl:when test="@H2G2ID">
                  <a href="?h2g2Id={@H2G2ID}&amp;s_ptrt={/H2G2/PARAMS/PARAM[NAME = 's_ptrt']/VALUE}&amp;s_start=2">Зарегистрировать мою жалобу</a>
                </xsl:when>
                <xsl:otherwise>
                  <a href="?url={@URL}&amp;s_ptrt={/H2G2/PARAMS/PARAM[NAME = 's_ptrt']/VALUE}&amp;s_start=2">Зарегистрировать мою жалобу</a>
                </xsl:otherwise>
              </xsl:choose>
            </p>
        </div>
        <xsl:call-template name="library_userstate">
            <xsl:with-param name="loggedin"></xsl:with-param>
            <xsl:with-param name="unauthorised"></xsl:with-param>
            <xsl:with-param name="loggedout">
                <div class="content">
                    <p>Вы не вошли в систему. Если вы зарегистрированы, введите свой логин и пароль. Это облегчит процесс регистрации жалобы.</p>
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
                          <xsl:text>Войти</xsl:text>
                      </a>
                    </p>
                </div>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>

  <xsl:template name="item_name">
    <xsl:choose>
      <xsl:when test="@POSTID">
        <xsl:text>комментарий</xsl:text>
      </xsl:when>
      <xsl:when test="@H2G2ID">
        <xsl:text>статья</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>содержание</xsl:text>
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
                
            	<h2>Отправить сообщение модераторам</h2>
            	<p>Выберите, какой из пунктов <a href="http://www.bbc.co.uk/russian/institutional/2011/02/000000_g_forum_rules.shtml">Правил форумов Би-би-си,</a> вы считаете, этот <xsl:call-template name="item_name"/> нарушил. Если вам кажется, что было нарушено несколько пунктов, выберите самый серьезный.</p>
            </div>
            
            <div class="content">
              <h2>Причина жалобы</h2>
              <p>
                Мне кажется, что этот <xsl:call-template name="item_name"/> нарушает один из пунктов <a href="http://www.bbc.co.uk/russian/institutional/2011/02/000000_g_forum_rules.shtml">Правил форумов Би-би-си,</a> потому что он:
              </p>
               
                <p class="options">
                	<p class="options">
                		<input type="radio" id="dnaacs-cq-1" value="носит клеветнический характер" name="s_complaintText"/><label for="dnaacs-cq-1">носит клеветнический характер</label>
                		<input type="radio" id="dnaacs-cq-2" value="носит расистский, сексистский, гомофобный, сексуально откровенный, насильственный или оскорбительный характер" name="s_complaintText"/><label for="dnaacs-cq-2">носит расистский, сексистский, гомофобный, сексуально откровенный, насильственный или оскорбительный характер</label>
                		<input type="radio" id="dnaacs-cq-3" value="содержит нецензурные или оскорбительные слова" name="s_complaintText"/><label for="dnaacs-cq-3">содержит нецензурные или оскорбительные слова</label>
                		<input type="radio" id="dnaacs-cq-4" value="нарушает закон или подстрекает к незаконной деятельности, как то: нарушение авторского права или неуважение к суду" name="s_complaintText"/><label for="dnaacs-cq-4">нарушает закон или подстрекает к незаконной деятельности, как то: <a href="http://www.bbc.co.uk/russian/institutional/2011/02/000000_g_terms_of_use.shtml">нарушение авторского права</a> или неуважение к суду</label>
                		<input type="radio" id="dnaacs-cq-5" value="рекламирует продукцию или услуги в целях получения прибыли" name="s_complaintText"/><label for="dnaacs-cq-5">рекламирует продукцию или услуги в целях получения прибыли</label>
                		<input type="radio" id="dnaacs-cq-7" value="выдает себя за кого-то другого" name="s_complaintText"/><label for="dnaacs-cq-7">выдает себя за кого-то другого</label>
                		<input type="radio" id="dnaacs-cq-8" value="содержит личные данные (к примеру, телефон или адрес)" name="s_complaintText"/><label for="dnaacs-cq-8">содержит личные данные (к примеру, телефон или адрес)</label>
                		<xsl:call-template name="library_userstate">
                      <xsl:with-param name="loggedin">
                        <input type="radio" id="dnaacs-cq-9" value="не имеет отношения к дискуссии" name="s_complaintText"/><label for="dnaacs-cq-9">не имеет отношения к дискуссии</label>
                      </xsl:with-param>
                    </xsl:call-template>
                		<input type="radio" id="dnaacs-cq-10" value="написан не на русском языке" name="s_complaintText"/><label for="dnaacs-cq-10">написан не на русском языке</label>
                		<input type="radio" id="dnaacs-cq-11" value="содержит ссылку на вебсайт, который нарушает Редакционные ценности Би-би-си" name="s_complaintText"/><label for="dnaacs-cq-11">содержит ссылку на вебсайт, который нарушает <a href="http://www.bbc.co.uk/russian/institutional/2011/02/000000_g_editorial_values.shtml">Редакционные ценности Би-би-си</a></label>
                		<input type="radio" id="dnaacs-cq-12" value="описывает или подстрекает к опасной деятельности, которая может повлиять на безопасность других людей" name="s_complaintText"/><label for="dnaacs-cq-12">описывает или подстрекает к опасной деятельности, которая может повлиять на безопасность других людей</label>
                		<input type="radio" id="dnaacs-cq-13" value="содержит нецензурное имя пользователя" name="s_complaintText"/><label for="dnaacs-cq-13">содержит нецензурное имя пользователя</label>
                		<input type="radio" id="dnaacs-cq-14" value="is spam" name="s_complaintText"/><label for="dnaacs-cq-14">является спамом</label>
                		<input type="radio" id="dnaacs-cq-6" value="Другое" name="s_complaintText"/><label for="dnaacs-cq-6">нарушает правила по пункту, не перечисленному выше</label>
                	</p>
                </p>

              <p class="action">
                <input type="submit" value="Следующая страница"/>
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
        alert("Выберите причину вашей жалобы");
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
           	<p>Пожалуйста, заполните эту графу, объяснив причину, по которой вы считаете, что <xsl:call-template name="item_name"/> нарушает это правило. Затем нажмите на кнопку "Отправить жалобу". Она будет переправлена модератору.</p>
               <p>
                  <xsl:if test="/H2G2/PARAMS/PARAM[NAME = 's_complaintText']/VALUE and /H2G2/PARAMS/PARAM[NAME = 's_complaintText']/VALUE = 'Другое'">
                    Я хочу пожаловаться на этот комментарий, <xsl:call-template name="item_name"/> так как
                  </xsl:if>
                   
               </p>
                <p class="options">
                    <textarea id="reason" rows="10" cols="40" name="complainttext" class="textarea">
                    	<xsl:if test="/H2G2/PARAMS/PARAM[NAME = 's_complaintText']/VALUE and /H2G2/PARAMS/PARAM[NAME = 's_complaintText']/VALUE != 'Другое'">
                        <xsl:text> </xsl:text><xsl:call-template name="item_name"/>
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
                    <h3>Ваш электронный адрес</h3>
                    <p>
                      <em>Нам нужен ваш электронный адрес, чтобы мы могли проинформировать вас о решении модератора. Мы можем написать вам, если нам нужна будет дополнительная информация по поводу вашей жалобы.</em>
                    </p>
                    <p>
                        <label for="emailaddress">Адрес электронной почты</label>
                        <input type="text" name="email" id="emailaddress" value="" class="textbox"/>
                    </p>
                </xsl:otherwise>
              </xsl:choose>
              
                <xsl:if test="(/H2G2/VIEWING-USER/USER/GROUPS/EDITOR) or (/H2G2/VIEWING-USER/USER/STATUS = 2) or (/H2G2/VIEWING-USER/USER/GROUPS/GROUP[NAME='EDITOR'])">
                    <p>
                        <input type="checkbox" value="1" name="hidepost" id="hidePost"/>
                        <label for="hidePost"> Скрыть этот <xsl:call-template name="item_name"/> немедленно</label>.
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
                    <input type="submit" value="Отправить жалобу" name="Submit" class="button"/>
                </p>
            </div>
            
        </form>
    </xsl:template>
    
    <xsl:template match="USER-COMPLAINT-FORM[ERROR] | ERROR" mode="input_user-complaint-form">
      <div class="content">
        <h2>Информация</h2>
        <xsl:choose>
          <xsl:when test="@TYPE = 'EMAILNOTALLOWED'">
            <p>
              Вы не можете использовать систему жалоб, так как вы были заблокированы. Пожалуйста, напишите сюда: <br />
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
      <h2>Подтверждение электронного адреса</h2>
      <p>
        Ваша жалоба отправлена. Модератор сможет прочесть ее лишь после того, как вы подтвердите свой электронный адрес. Эта процедура необходима для борьбы со спамом.
      </p>
      <p>
        Вы скоро получите электронное письмо со ссылкой для того, чтобы активировать вашу жалобу. Нажав на ссылку, вы отправите свою жалобу модераторам.
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
          <xsl:text>Продолжить читать сайт</xsl:text>
        </a>
      </p>
    </div>
  </xsl:template>

  <xsl:template match="USER-COMPLAINT-FORM[MESSAGE/@TYPE = 'SUBMIT-SUCCESSFUL'] | USERCOMPLAINT[@MODID]" mode="input_user-complaint-form">
    <div class="content">
      <h2>Жалоба получена</h2>
      <p>
        Ваша жалоба отправлена модератору. Модератор решит, нарушает ли комментарий <a href="http://www.bbc.co.uk/russian/institutional/2011/02/000000_g_forum_rules.shtml">Правила форумов Би-би-си,</a> и уведомит вас о своем решении по электронной почте.
      </p>
      <p>
        Ваш номер жалобы: <strong>
          <xsl:value-of select="(MODERATION-REFERENCE | @MODID)[1]"/>
        </strong>
      </p>
      <xsl:if test="@HIDDEN and @HIDDEN != 0">
        <p>Этот комментарий был скрыт.</p>
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
                    <xsl:text>http://www.bbc.co.uk/russian</xsl:text>
                  </xsl:otherwise>
                </xsl:choose>

              </xsl:with-param>
            </xsl:call-template>
          </xsl:attribute>
          <xsl:text>Продолжить читать сайт</xsl:text>
        </a>
      </p>
    </div>
  </xsl:template>

 



</xsl:stylesheet>