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
            <h2>hakkında şikayette bulunun <xsl:call-template name="item_name"/></h2>
            <p>Bu form, sadece <a href="{$houserulespopupurl}">kullanım koşullarını ihlal ettiği düşünülen içeriğe ilişkin şikayetlerle ilgili olarak kullanılabilir</a>.</p>
            <p>Eğer genel bir yorum yapmak ya da soru yöneltmek isterseniz, bu formu kullanmak yerine bir mesajla tartışmaya katılın.</p>
            <p>Hakkında şikayetçi olduğunuz mesaj, <a href="{$houserulespopupurl}"> kullanım koşullarının ihlal edilip edilmediğine karar verecek olan moderatöre iletilecek</a>. Karar hakkında elektronik posta mesajı aracılığıyla bilgilendirileceksiniz.</p>
            <p class="action">
              <xsl:choose>
                <xsl:when test="@POSTID">
                  <a href="?PostId={(POST-ID | @POSTID)[1]}&amp;s_ptrt={/H2G2/PARAMS/PARAM[NAME = 's_ptrt']/VALUE}&amp;s_start=2">Şikayetimi kayda geçir</a>
                </xsl:when>
                <xsl:when test="@H2G2ID">
                  <a href="?h2g2Id={@H2G2ID}&amp;s_ptrt={/H2G2/PARAMS/PARAM[NAME = 's_ptrt']/VALUE}&amp;s_start=2">Şikayetimi kayda geçir</a>
                </xsl:when>
                <xsl:otherwise>
                  <a href="?url={@URL}&amp;s_ptrt={/H2G2/PARAMS/PARAM[NAME = 's_ptrt']/VALUE}&amp;s_start=2">Şikayetimi kayda geçir</a>
                </xsl:otherwise>
              </xsl:choose>
            </p>
        </div>
        <xsl:call-template name="library_userstate">
            <xsl:with-param name="loggedin"></xsl:with-param>
            <xsl:with-param name="unauthorised"></xsl:with-param>
            <xsl:with-param name="loggedout">
                <div class="content">
                    <p>Bu siteye giriş yapmamışsınız. Bir hesabınız varsa şikayetinizin işleme konulması için lütfen giriş yapın.</p>
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
                          <xsl:text>Giriş</xsl:text>
                      </a>
                    </p>
                </div>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>

  <xsl:template name="item_name">
    <xsl:choose>
      <xsl:when test="@POSTID">
        <xsl:text>mesaj</xsl:text>
      </xsl:when>
      <xsl:when test="@H2G2ID">
        <xsl:text>haber</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>içerik</xsl:text>
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
                
            	<h2>Moderatörleri uyarmak</h2>
            	<p>Bu yorumun ihlal ettiğini düşündüğünüz <a href="{$houserulespopupurl}">kullanım koşulunu</a> seçin.<xsl:call-template name="item_name"/> Eğer birden fazla kuralın ihlal edildiğini düşünüyorsanız en ciddi ihlali seçin.</p>
            </div>
            
            <div class="content">
              <h2>Şikayetinizin nedeni:</h2>
              <p>
                Bu mesajın <xsl:call-template name="item_name"/> ihlal etmiş olabileceğini düşünüyorum <a href="{$houserulespopupurl}">kullanım koşullarını </a> çünkü:
              </p>
               
                <p class="options">
                	<p class="options">
                		<input type="radio" id="dnaacs-cq-1" value="iftira ve hakaret içeriyor" name="s_complaintText"/><label for="dnaacs-cq-1">iftira ve hakaret içeriyor</label>
                		<input type="radio" id="dnaacs-cq-2" value="ırkçı, cinsiyet ayrımcısı, homofobik, taciz eden, küçük düşüren ve hakaret ifadeleri içeriyor" name="s_complaintText"/><label for="dnaacs-cq-2">ırkçı, cinsiyet ayrımcısı, homofobik, taciz eden, küçük düşüren ve hakaret ifadeleri içeriyor</label>
                		<input type="radio" id="dnaacs-cq-3" value="küfür ve hakaret olarak görülebilecek ifadeler içeriyor" name="s_complaintText"/><label for="dnaacs-cq-3">küfür ve hakaret olarak görülebilecek ifadeler içeriyor</label>
                		<input type="radio" id="dnaacs-cq-4" value="yasaya aykırı ya da yasadışı faaliyetlere teşvik ediyor fikri mülkiyet hakkı ihlali, mahkemeye itaatsizlik gibi" name="s_complaintText"/><label for="dnaacs-cq-4">yasaya aykırı ya da yasadışı faaliyetlere teşvik ediyor <a href="http://www.bbc.co.uk/messageboards/newguide/popup_copyright.html">fikri mülkiyet hakkı ihlali,</a> mahkemeye itaatsizlik gibi</label>
                		<input type="radio" id="dnaacs-cq-5" value="kâr ve gelir amaçlı hizmet ve ürün reklamı yapılıyor" name="s_complaintText"/><label for="dnaacs-cq-5">kâr ve gelir amaçlı hizmet ve ürün reklamı yapılıyor</label>
                		<input type="radio" id="dnaacs-cq-7" value="birilerinin taklidi yapılıyor" name="s_complaintText"/><label for="dnaacs-cq-7">birilerinin taklidi yapılıyor</label>
                		<input type="radio" id="dnaacs-cq-8" value="telefon numarası, ev ya da elektronik posta adresi gibi kişisel bilgiler içeriyor" name="s_complaintText"/><label for="dnaacs-cq-8">telefon numarası, ev ya da elektronik posta adresi gibi kişisel bilgiler içeriyor</label>
                		<xsl:call-template name="library_userstate">
                      <xsl:with-param name="loggedin">
                        <input type="radio" id="dnaacs-cq-9" value="başlık ya da tartışılan konunun dışında" name="s_complaintText"/><label for="dnaacs-cq-9">başlık ya da tartışılan konunun dışında</label>
                      </xsl:with-param>
                    </xsl:call-template>
                		<input type="radio" id="dnaacs-cq-10" value="Türkçe değil" name="s_complaintText"/><label for="dnaacs-cq-10">Türkçe değil</label>
                		<input type="radio" id="dnaacs-cq-11" value="aykırı içeriğe sahip olan bir internet sitesine link içeriyor. BBC Yayın İlkeleri'ne" name="s_complaintText"/><label for="dnaacs-cq-11">aykırı içeriğe sahip olan bir internet sitesine link içeriyor. <a href="http://www.bbc.co.uk/messageboards/newguide/popup_editorial_guidelines.html">BBC Yayın İlkeleri'ne</a></label>
                		<input type="radio" id="dnaacs-cq-12" value="başkalarının güvenliğini tehlikeye atabilecek faaliyetlere ilişkin tarif ve teşvik edici ifadeler içeriyor" name="s_complaintText"/><label for="dnaacs-cq-12">başkalarının güvenliğini tehlikeye atabilecek faaliyetlere ilişkin tarif ve teşvik edici ifadeler içeriyor</label>
                		<input type="radio" id="dnaacs-cq-13" value="uygun olmayan bir kullanıcı adı içeriyor" name="s_complaintText"/><label for="dnaacs-cq-13">uygun olmayan bir kullanıcı adı içeriyor</label>
                		<input type="radio" id="dnaacs-cq-14" value="istenmeyen elekronik posta mesajı" name="s_complaintText"/><label for="dnaacs-cq-14">istenmeyen elekronik posta mesajı</label>
                		<input type="radio" id="dnaacs-cq-6" value="Diğer" name="s_complaintText"/><label for="dnaacs-cq-6">yukarıda yer almayan bir kuralı ihlal ediyor</label>
                	</p>
                </p>

              <p class="action">
                <input type="submit" value="Sonraki sayfa"/>
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
        alert("Lütfen şikayet sebebinizi seçin");
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
           	<p>Lütfen aşağıdaki kutuya hangi nedenle kural ihlali olduğunu düşündüğünüzü yazın. <xsl:call-template name="item_name"/> Formu doldurduktan sonra da moderatör tarafından incelenmek üzere Şikayeti Gönder'e tıklayın.</p>
               <p>
                  <xsl:if test="/H2G2/PARAMS/PARAM[NAME = 's_complaintText']/VALUE and /H2G2/PARAMS/PARAM[NAME = 's_complaintText']/VALUE = 'Diğer'">
                    bu konuda şikayette bulunmak istiyorum: <xsl:call-template name="item_name"/> Aşağıdaki nedenle 
                  </xsl:if>
                   
               </p>
                <p class="options">
                    <textarea id="reason" rows="10" cols="40" name="complainttext" class="textarea">
                    	<!-- <xsl:if test="/H2G2/PARAMS/PARAM[NAME = 's_complaintText']/VALUE and /H2G2/PARAMS/PARAM[NAME = 's_complaintText']/VALUE != 'Diğer'">
                        <xsl:text>buna inanıyorum: </xsl:text><xsl:call-template name="item_name"/>
                        <xsl:text xml:space="preserve"> </xsl:text>
                        <xsl:apply-templates select="/H2G2/PARAMS/PARAM[NAME = 's_complaintText']/VALUE" mode="library_string_stringtolower"/><xsl:text> Aşağıdaki nedenle </xsl:text>
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
                    <h3>Elektronik posta adresiniz:</h3>
                    <p>
                      <em>Şikayetinizi işleme koymak ve moderatörün kararı konusunda sizi bilgilendirmek için elektronik posta adresiniz gerekli. Şikayetiniz hakkında ek bilgiye ihtiyaç olursa sizinle temas kurmamız da gerekebilir.</em>
                    </p>
                    <p>
                        <label for="emailaddress">Elektronik posta adresi:</label>
                        <input type="text" name="email" id="emailaddress" value="" class="textbox"/>
                    </p>
                </xsl:otherwise>
              </xsl:choose>
              
                <xsl:if test="(/H2G2/VIEWING-USER/USER/GROUPS/EDITOR) or (/H2G2/VIEWING-USER/USER/STATUS = 2) or (/H2G2/VIEWING-USER/USER/GROUPS/GROUP[NAME='EDITOR'])">
                    <p>
                        <input type="checkbox" value="1" name="hidepost" id="hidePost"/>
                        <label for="hidePost"> Gizleyin <xsl:call-template name="item_name"/> anında</label>.
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
                    <input type="submit" value="Şikayet et" name="Submit" class="button"/>
                </p>
            </div>
            
        </form>
    </xsl:template>
    
    <xsl:template match="USER-COMPLAINT-FORM[ERROR] | ERROR" mode="input_user-complaint-form">
      <div class="content">
        <h2>Bilgi</h2>
        <xsl:choose>
          <xsl:when test="@TYPE = 'EMAILNOTALLOWED'">
            <p>
              Site üzerinden şikayet göndermeniz engellendi, lütfen şu adrese yazın:<br />
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
      <h2>Elektronik posta doğrulama</h2>
      <p>
        Şikayetiniz gönderildi. Ancak elektronik posta doğrulaması yapılmadan moderatöre ulaşmayacak. Bu, başkalarının adına mesaj gönderilmesini ve istenmeyen mesajları engellemek için gerekli.
      </p>
      <p>
        Şikayetinizin moderatörlere ulaşmasını sağlamak için lütfen linke tıklayın.
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
          <xsl:text>Sitede gezinmeye devam edin</xsl:text>
        </a>
      </p>
    </div>
  </xsl:template>

  <xsl:template match="USER-COMPLAINT-FORM[MESSAGE/@TYPE = 'SUBMIT-SUCCESSFUL'] | USERCOMPLAINT[@MODID]" mode="input_user-complaint-form">
    <div class="content">
      <h2>Sitede gezinmeye devam edin</h2>
      <p>
        Şikayetiniz başarıyla ulaştı ve moderatör ekibine iletildi.  <a href="{$houserulespopupurl}">Kullanım koşullarına</a> uygun olup olmadığı incelendikten sonra elektronik posta adresinize gönderilecek bir mesajla bilgilendirileceksiniz.
      </p>
      <p>
        Moderasyon referans numaranız: <strong>
          <xsl:value-of select="(MODERATION-REFERENCE | @MODID)[1]"/>
        </strong>
      </p>
      <xsl:if test="@HIDDEN and @HIDDEN != 0">
        <p>Bu gönderi gizlendi.</p>
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
                    <xsl:text>http://www.bbc.co.uk/turkce</xsl:text>
                  </xsl:otherwise>
                </xsl:choose>

              </xsl:with-param>
            </xsl:call-template>
          </xsl:attribute>
          <xsl:text>Sitede gezinmeye devam edin</xsl:text>
        </a>
      </p>
    </div>
  </xsl:template>

 



</xsl:stylesheet>