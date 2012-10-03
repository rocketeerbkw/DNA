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
            <h2>Изоҳ юзасидан шикоят <xsl:call-template name="item_name"/></h2>
            <p>Ушбу формадан фақат форум қоидаларини бузаётган изоҳ устидан жиддий шикоят қилиш учун фойдаланилади: <a href="http://www.bbc.co.uk/uzbek/institutional/2012/08/120808_house_rules.shtml">Форум қоидалари</a>.</p>
            <p>Агар сизда умумий изоҳ ёки савол бўлса, бу формадан фойдаланманг. Ё хабар йўлланг ёки қайта алоқа формасидан фойдаланинг.</p>
            <p>Сизнинг шикоятингиз модераторга етказилади. Модератор изоҳ форум қоидасини бузган-бузмаганини ўрганади <a href="http://www.bbc.co.uk/uzbek/institutional/2012/08/120808_house_rules.shtml">Форум қоидалари</a>. Сиз ўз шикоятингиз борасида қандай қарорга келингани ҳақида электрон мактуб оласиз.</p>
            <p class="action">
              <xsl:choose>
                <xsl:when test="@POSTID">
                  <a href="?PostId={(POST-ID | @POSTID)[1]}&amp;s_ptrt={/H2G2/PARAMS/PARAM[NAME = 's_ptrt']/VALUE}&amp;s_start=2">Менинг шикоятимни рўйхатга олинг</a>
                </xsl:when>
                <xsl:when test="@H2G2ID">
                  <a href="?h2g2Id={@H2G2ID}&amp;s_ptrt={/H2G2/PARAMS/PARAM[NAME = 's_ptrt']/VALUE}&amp;s_start=2">Менинг шикоятимни рўйхатга олинг</a>
                </xsl:when>
                <xsl:otherwise>
                  <a href="?url={@URL}&amp;s_ptrt={/H2G2/PARAMS/PARAM[NAME = 's_ptrt']/VALUE}&amp;s_start=2">Менинг шикоятимни рўйхатга олинг</a>
                </xsl:otherwise>
              </xsl:choose>
            </p>
        </div>
        <xsl:call-template name="library_userstate">
            <xsl:with-param name="loggedin"></xsl:with-param>
            <xsl:with-param name="unauthorised"></xsl:with-param>
            <xsl:with-param name="loggedout">
                <div class="content">
                    <p>Сиз веб-сайтга кирганингизча йўқ. Агар рўйхатдан ўтган бўлсангиз, ўз исмингиз ва очарсўзингизни киритинг. Бу нарса шикоятингиз билан боғлиқ жараённи осонлаштиради.</p>
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
                          <xsl:text>Кириш</xsl:text>
                      </a>
                    </p>
                </div>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>

  <xsl:template name="item_name">
    <xsl:choose>
      <xsl:when test="@POSTID">
        <xsl:text>изоҳ</xsl:text>
      </xsl:when>
      <xsl:when test="@H2G2ID">
        <xsl:text>мақола</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>контент</xsl:text>
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
                
            	<h2>Модераторларни огоҳ қилиш</h2>
            	<p>Сизнингча қайси банд <a href="http://www.bbc.co.uk/uzbek/institutional/2012/08/120808_house_rules.shtml">Форум қоидалари</a> зид деб ҳисоблайсиз <xsl:call-template name="item_name"/> Агар сиз бир неча қоида бузилган, деб ҳисобласангиз, улардан энг жиддийсини танланг.</p>
            </div>
            
            <div class="content">
              <h2>Шикоят сабаби</h2>
              <p>
                Менинг фикримча, бу <xsl:call-template name="item_name"/> <a href="http://www.bbc.co.uk/uzbek/institutional/2012/08/120808_house_rules.shtml">Форум қоидалари</a> бузаяпти, чунки унда: 
              </p>
               
                <p class="options">
                	<p class="options">
                		<input type="radio" id="dnaacs-cq-1" value="бўҳтон мазмун бор" name="s_complaintText"/><label for="dnaacs-cq-1">бўҳтон мазмун бор</label>
                		<input type="radio" id="dnaacs-cq-2" value="ирқчи, жинсий, очиқдан-очиқ шаҳвоний, зўравонликка асосланган ё таҳқирловчи мазмун бор" name="s_complaintText"/><label for="dnaacs-cq-2">ирқчи, жинсий, очиқдан-очиқ шаҳвоний, зўравонликка асосланган ё таҳқирловчи мазмун бор</label>
                		<input type="radio" id="dnaacs-cq-3" value="сўкиниш ёки таҳқирлаш мазмунига эга сўзлар бор" name="s_complaintText"/><label for="dnaacs-cq-3">сўкиниш ёки таҳқирлаш мазмунига эга сўзлар бор</label>
                		<input type="radio" id="dnaacs-cq-4" value="қонунни бузаяпти ёки ноқонуний амалга ундаяпти, хусусан муаллифлик ҳуқуқи, маҳкама тақиқини бузаяпти" name="s_complaintText"/><label for="dnaacs-cq-4">қонунни бузаяпти ёки ноқонуний амалга ундаяпти, хусусан <a href="http://www.bbc.co.uk/uzbek/institutional/2011/12/000001_terms.shtml">муаллифлик ҳуқуқи,</a> маҳкама тақиқини бузаяпти</label>
                		<input type="radio" id="dnaacs-cq-5" value="фойда олиш мақсадида маҳсулот ёки хизматни реклама қилаяпти" name="s_complaintText"/><label for="dnaacs-cq-5">фойда олиш мақсадида маҳсулот ёки хизматни реклама қилаяпти</label>
                		<input type="radio" id="dnaacs-cq-7" value="ўзини бошқа одам деб тақдим қилаяпти" name="s_complaintText"/><label for="dnaacs-cq-7">ўзини бошқа одам деб тақдим қилаяпти</label>
                		<input type="radio" id="dnaacs-cq-8" value="ичида шахсий маълумотлар бор, масалан телефон рақамлари ёки уй манзили" name="s_complaintText"/><label for="dnaacs-cq-8">ичида шахсий маълумотлар бор, масалан телефон рақамлари ёки уй манзили</label>
                		<xsl:call-template name="library_userstate">
                      <xsl:with-param name="loggedin">
                        <input type="radio" id="dnaacs-cq-9" value="муҳокама қилинаётган мавзуга тааллуқли эмас" name="s_complaintText"/><label for="dnaacs-cq-9">муҳокама қилинаётган мавзуга тааллуқли эмас</label>
                      </xsl:with-param>
                    </xsl:call-template>
                		<input type="radio" id="dnaacs-cq-10" value="ўзбек тилида ёзилмаган" name="s_complaintText"/><label for="dnaacs-cq-10">ўзбек тилида ёзилмаган</label>
                		<input type="radio" id="dnaacs-cq-11" value="бошқа веб-саҳифага линк берилган. У эса Би-би-си Таҳририй сиёсатига зид" name="s_complaintText"/><label for="dnaacs-cq-11">бошқа веб-саҳифага линк берилган. У эса <a href="http://www.bbc.co.uk/uzbek/institutional/2012/09/120920_editorial_values.shtml">Би-би-си Таҳририй сиёсатига зид</a></label>
                		<input type="radio" id="dnaacs-cq-12" value="бошқалар хавфсизлигига таъсир кўрсатиши мумкин бўлган хатарли ҳаракатни тасвирлаяпти ёки шунга гижгижлаяпти" name="s_complaintText"/><label for="dnaacs-cq-12">бошқалар хавфсизлигига таъсир кўрсатиши мумкин бўлган хатарли ҳаракатни тасвирлаяпти ёки шунга гижгижлаяпти</label>
                		<input type="radio" id="dnaacs-cq-13" value="фойдаланувчининг номи номақбул ном" name="s_complaintText"/><label for="dnaacs-cq-13">фойдаланувчининг номи номақбул ном</label>
                		<input type="radio" id="dnaacs-cq-14" value="бу спам" name="s_complaintText"/><label for="dnaacs-cq-14">бу спам</label>
                		<input type="radio" id="dnaacs-cq-6" value="Бошқа" name="s_complaintText"/><label for="dnaacs-cq-6">юқорида тилга олинмаган банд бўйича қоидани бузаяпти</label>
                	</p>
                </p>

              <p class="action">
                <input type="submit" value="Кейинги саҳифа"/>
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
        alert("Шикоят учун сабабни танланг");
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
           	<p>Марҳамат қилиб пастдаги бўлимни тўлдиринг. Нега сиз ушбу <xsl:call-template name="item_name"/> қоидани бузаяпти, деб ўйлайсиз. Шундан сўнг "Шикоят юбориш" тугмасини босинг. Уни модератор олади.</p>
               <p>
                  <xsl:if test="/H2G2/PARAMS/PARAM[NAME = 's_complaintText']/VALUE and /H2G2/PARAMS/PARAM[NAME = 's_complaintText']/VALUE = 'Бошқа'">
                    Мен ушбу изоҳ бўйича шикоят қилмоқчиман, <xsl:call-template name="item_name"/> чунки у
                  </xsl:if>
                   
               </p>
                <p class="options">
                    <textarea id="reason" rows="10" cols="40" name="complainttext" class="textarea">
                    	<xsl:if test="/H2G2/PARAMS/PARAM[NAME = 's_complaintText']/VALUE and /H2G2/PARAMS/PARAM[NAME = 's_complaintText']/VALUE != 'Бошқа'">
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
                    <h3>Сизнинг электрон почтангиз манзили</h3>
                    <p>
                      <em>Бизга сизнинг электрон почтангиз модераторнинг қарори ҳақида сизни хабардор этиш учун керак. Сизнинг шикоятингиз борасида бизга яна қўшимча маълумот керак бўлса, биз сизга мактуб ёзишимиз мумкин.</em>
                    </p>
                    <p>
                        <label for="emailaddress">Электрон почта манзили</label>
                        <input type="text" name="email" id="emailaddress" value="" class="textbox"/>
                    </p>
                </xsl:otherwise>
              </xsl:choose>
              
                <xsl:if test="(/H2G2/VIEWING-USER/USER/GROUPS/EDITOR) or (/H2G2/VIEWING-USER/USER/STATUS = 2) or (/H2G2/VIEWING-USER/USER/GROUPS/GROUP[NAME='EDITOR'])">
                    <p>
                        <input type="checkbox" value="1" name="hidepost" id="hidePost"/>
                        <label for="hidePost"> Буни яшир <xsl:call-template name="item_name"/> зудлик билан</label>.
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
                    <input type="submit" value="Шикоятни жўнатинг" name="Submit" class="button"/>
                </p>
            </div>
            
        </form>
    </xsl:template>
    
    <xsl:template match="USER-COMPLAINT-FORM[ERROR] | ERROR" mode="input_user-complaint-form">
      <div class="content">
        <h2>Ахборот</h2>
        <xsl:choose>
          <xsl:when test="@TYPE = 'EMAILNOTALLOWED'">
            <p>
              Сиз шикоят қилиш тизимидан фойдалана олмайсиз, чунки бунга тўсиқ қўйилган. Марҳамат қилиб мана бу ерга ёзинг:<br />
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
      <h2>Электрон почта манзили</h2>
      <p>
        Сизнинг шикоятингиз юборилди. Модератор уни сиз ўзингизнинг электрон почтангиз манзилини тасдиқлаганингиздан кейин ўқий олади. Бу нарса спамга қарши кураш учун зарур.
      </p>
      <p>
        Сиз тез орада ўз шикоятингизни активация қилиш учун линк оласиз. Бу линкка босиб ўз шикоятингизни модераторга йўллайсиз.
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
          <xsl:text>Саҳифани ўқишда давом этиш</xsl:text>
        </a>
      </p>
    </div>
  </xsl:template>

  <xsl:template match="USER-COMPLAINT-FORM[MESSAGE/@TYPE = 'SUBMIT-SUCCESSFUL'] | USERCOMPLAINT[@MODID]" mode="input_user-complaint-form">
    <div class="content">
      <h2>Шикоят қабул қилинди</h2>
      <p>
        Сизнинг шикоятингиз модераторга юборилди. Модератор изоҳ форум қоидасини бузган-бузмаганини ўрганади: <a href="http://www.bbc.co.uk/uzbek/institutional/2012/08/120808_house_rules.shtml">Форумлар қоидаси</a> сўнг модератор ўз қарори борасида сизни электрон почта орқали хабардор қилади.
      </p>
      <p>
        Сизнинг шикоятингиз рақами: <strong>
          <xsl:value-of select="(MODERATION-REFERENCE | @MODID)[1]"/>
        </strong>
      </p>
      <xsl:if test="@HIDDEN and @HIDDEN != 0">
        <p>Ушбу изоҳ яширилган.</p>
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
                    <xsl:text>http://www.bbc.co.uk/uzbek</xsl:text>
                  </xsl:otherwise>
                </xsl:choose>

              </xsl:with-param>
            </xsl:call-template>
          </xsl:attribute>
          <xsl:text>Саҳифани ўқишда давом этиш</xsl:text>
        </a>
      </p>
    </div>
  </xsl:template>

 



</xsl:stylesheet>