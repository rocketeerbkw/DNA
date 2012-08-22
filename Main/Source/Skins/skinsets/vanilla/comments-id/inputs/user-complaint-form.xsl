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
            <h2>Keluhan tentang <xsl:call-template name="item_name"/></h2>
            <p>Formulir ini hanya untuk keluhan serius tentang materi tertentu yang melanggar <a href="{$houserulespopupurl}">Peraturan Internal</a>.</p>
            <p>Jika Anda ingin menyampaikan komentar atau pertanyaan umum, jangan gunakan formulir ini namun kirim pesan untuk diskusi.</p>
            <p>Pesan yang Anda keluhkan akan dkirim ke moderator, yang akan menentukan apakah melanggar <a href="{$houserulespopupurl}">Peraturan Internal</a>. Anda akan mendapat informasi tentang keputusan itu melalui email. </p>
            <p class="action">
              <xsl:choose>
                <xsl:when test="@POSTID">
                  <a href="?PostId={(POST-ID | @POSTID)[1]}&amp;s_ptrt={/H2G2/PARAMS/PARAM[NAME = 's_ptrt']/VALUE}&amp;s_start=2">Daftarkan keluhan saya</a>
                </xsl:when>
                <xsl:when test="@H2G2ID">
                  <a href="?h2g2Id={@H2G2ID}&amp;s_ptrt={/H2G2/PARAMS/PARAM[NAME = 's_ptrt']/VALUE}&amp;s_start=2">Daftarkan keluhan saya</a>
                </xsl:when>
                <xsl:otherwise>
                  <a href="?url={@URL}&amp;s_ptrt={/H2G2/PARAMS/PARAM[NAME = 's_ptrt']/VALUE}&amp;s_start=2">Daftarkan keluhan saya</a>
                </xsl:otherwise>
              </xsl:choose>
            </p>
        </div>
        <xsl:call-template name="library_userstate">
            <xsl:with-param name="loggedin"></xsl:with-param>
            <xsl:with-param name="unauthorised"></xsl:with-param>
            <xsl:with-param name="loggedout">
                <div class="content">
                    <p>Anda tidak terdaftar. Jika Anda memiliki akun terdaftar, silakan masuk dan kami akan membantu untuk memproses keluhan Anda.</p>
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
                          <xsl:text>Masuk</xsl:text>
                      </a>
                    </p>
                </div>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>

  <xsl:template name="item_name">
    <xsl:choose>
      <xsl:when test="@POSTID">
        <xsl:text>pesan</xsl:text>
      </xsl:when>
      <xsl:when test="@H2G2ID">
        <xsl:text>artikel</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>materi</xsl:text>
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
                
            	<h2>Mengingatkan moderator</h2>
            	<p>Mohon pilih yang mana dari <a href="{$houserulespopupurl}">Peraturan Internal</a> yang menurut Anda <xsl:call-template name="item_name"/> sudah dilanggar. Jika menurut Anda melangar lebih dari satu peraturan, mohon pilih pelanggaran paling serius.</p>
            </div>
            
            <div class="content">
              <h2>Alasan keluhan</h2>
              <p>
                Saya yakin <xsl:call-template name="item_name"/> ini mungkin melanggar satu dari <a href="{$houserulespopupurl}">Peraturan Internal</a> karena:
              </p>
               
                <p class="options">
                	<p class="options">
                		<input type="radio" id="dnaacs-cq-1" value="memfintah atau mencemarkan nama baik" name="s_complaintText"/><label for="dnaacs-cq-1">memfintah atau mencemarkan nama baik</label>
                		<input type="radio" id="dnaacs-cq-2" value="rasis, seksis, homofobia, seksual secara terang-terangan, menghina atau menyerang" name="s_complaintText"/><label for="dnaacs-cq-2">rasis, seksis, homofobia, seksual secara terang-terangan, menghina atau menyerang</label>
                		<input type="radio" id="dnaacs-cq-3" value="mengandung kata makian atau yang mungkin menghina" name="s_complaintText"/><label for="dnaacs-cq-3">mengandung kata makian atau yang mungkin menghina</label>
                		<input type="radio" id="dnaacs-cq-4" value="melanggar hukum atau membiarkan maupun mendorong tindakan yang tidak sesuai hukum seperti melanggar hak cipta, menghina pengadilan" name="s_complaintText"/><label for="dnaacs-cq-4">melanggar hukum atau membiarkan maupun mendorong tindakan yang tidak sesuai hukum seperti melanggar <a href="http://www.bbc.co.uk/messageboards/newguide/popup_copyright.html">hak cipta,</a> menghina pengadilan</label>
                		<input type="radio" id="dnaacs-cq-5" value="mempromosikan produk atau jasa untuk mendapat keuntungan" name="s_complaintText"/><label for="dnaacs-cq-5">mempromosikan produk atau jasa untuk mendapat keuntungan</label>
                		<input type="radio" id="dnaacs-cq-7" value="berkedok sebagai orang lain" name="s_complaintText"/><label for="dnaacs-cq-7">berkedok sebagai orang lain</label>
                		<input type="radio" id="dnaacs-cq-8" value="memuat informasi pribadi seperti nomor telepon, alamat surat maupun alamat email" name="s_complaintText"/><label for="dnaacs-cq-8">memuat informasi pribadi seperti nomor telepon, alamat surat maupun alamat email</label>
                		<xsl:call-template name="library_userstate">
                      <xsl:with-param name="loggedin">
                        <input type="radio" id="dnaacs-cq-9" value="tidak sesuai dengan tema atau subyek yang didiskusikan" name="s_complaintText"/><label for="dnaacs-cq-9">tidak sesuai dengan tema atau subyek yang didiskusikan</label>
                      </xsl:with-param>
                    </xsl:call-template>
                		<input type="radio" id="dnaacs-cq-10" value="tidak dalam Bahasa Indonesia" name="s_complaintText"/><label for="dnaacs-cq-10">tidak dalam Bahasa Indonesia</label>
                		<input type="radio" id="dnaacs-cq-11" value="berisi nama pengguna yang tidak tepat Kebijakan Editorial" name="s_complaintText"/><label for="dnaacs-cq-11">berisi nama pengguna yang tidak tepat <a href="http://www.bbc.co.uk/messageboards/newguide/popup_editorial_guidelines.html">Kebijakan Editorial</a></label>
                		<input type="radio" id="dnaacs-cq-12" value="menggambarkan atau mendorong kegiatan yang bisa membahayakan keselamatan atau kesejahteraan orang lain" name="s_complaintText"/><label for="dnaacs-cq-12">menggambarkan atau mendorong kegiatan yang bisa membahayakan keselamatan atau kesejahteraan orang lain</label>
                		<input type="radio" id="dnaacs-cq-13" value="berisi nama pengguna yang tidak tepat" name="s_complaintText"/><label for="dnaacs-cq-13">berisi nama pengguna yang tidak tepat,</label>
                		<input type="radio" id="dnaacs-cq-14" value="spam" name="s_complaintText"/><label for="dnaacs-cq-14">spam</label>
                		<input type="radio" id="dnaacs-cq-6" value="Yang lain" name="s_complaintText"/><label for="dnaacs-cq-6">atau melanggar peraturan dengan alasan yang tidak terdaftar di atas</label>
                	</p>
                </p>

              <p class="action">
                <input type="submit" value="Halaman berikutnya"/>
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
        alert("Alasan mengajukan keluhan");
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
           	<p>Mohon isi kotak di bawah ini untuk menginformasikan alasan Anda <xsl:call-template name="item_name"/> bahwa peraturan dilanggar. Jika sudah selesai, klik Kirim Keluhan sehingga bisa dibaca oleh moderator.</p>
               <p>
                  <xsl:if test="/H2G2/PARAMS/PARAM[NAME = 's_complaintText']/VALUE and /H2G2/PARAMS/PARAM[NAME = 's_complaintText']/VALUE = 'Yang lain'">
                    Saya ingin menyampaikan keluhan <xsl:call-template name="item_name"/> dengan alasan berikut
                  </xsl:if>
                   
               </p>
                <p class="options">
                    <textarea id="reason" rows="10" cols="40" name="complainttext" class="textarea">
                    	<!-- <xsl:if test="/H2G2/PARAMS/PARAM[NAME = 's_complaintText']/VALUE and /H2G2/PARAMS/PARAM[NAME = 's_complaintText']/VALUE != 'Yang lain'">
                        <xsl:text>Saya yakin hal ini </xsl:text><xsl:call-template name="item_name"/>
                        <xsl:text xml:space="preserve"> </xsl:text>
                        <xsl:apply-templates select="/H2G2/PARAMS/PARAM[NAME = 's_complaintText']/VALUE" mode="library_string_stringtolower"/><xsl:text> dengan alasan berikut</xsl:text>
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
                    <h3>Alamat email Anda</h3>
                    <p>
                      <em>Kami membutuhkan email Anda untuk memproses keluhan Anda dan menginformasikan Anda tentang keputusan moderator. Dalam beberapa kesempatan, kami mungkin perlu menghubungi Anda jika kami membutuhkan lebih banyak informasi sehubungan dengan keluhan Anda.</em>
                    </p>
                    <p>
                        <label for="emailaddress">Alamat email</label>
                        <input type="text" name="email" id="emailaddress" value="" class="textbox"/>
                    </p>
                </xsl:otherwise>
              </xsl:choose>
              
                <xsl:if test="(/H2G2/VIEWING-USER/USER/GROUPS/EDITOR) or (/H2G2/VIEWING-USER/USER/STATUS = 2) or (/H2G2/VIEWING-USER/USER/GROUPS/GROUP[NAME='EDITOR'])">
                    <p>
                        <input type="checkbox" value="1" name="hidepost" id="hidePost"/>
                        <label for="hidePost"> Tutup <xsl:call-template name="item_name"/> segera</label>.
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
                    <input type="hidden" name="action" value="Kirim"/>
                    <input type="submit" value="Kirim keluhan" name="Submit" class="button"/>
                </p>
            </div>
            
        </form>
    </xsl:template>
    
    <xsl:template match="USER-COMPLAINT-FORM[ERROR] | ERROR" mode="input_user-complaint-form">
      <div class="content">
        <h2>Informasi</h2>
        <xsl:choose>
          <xsl:when test="@TYPE = 'EMAILNOTALLOWED'">
            <p>
              Anda dilarang menggunakan sistem keluhan internet, mohon tulis ke:<br />
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
      <h2>Verifikasi email</h2>
      <p>
        Keluhan anda sudah disampaikan. Mungkin moderator tidak bisa membaca sampai Anda melakukan verifikasi atas alamat email Anda. Hal ini untuk mencegah penipuan dan spam. 
      </p>
      <p>
        Anda akan segera mendapat email dengan link untuk mengaktifkan keluhan. Dengan mengklik link ini maka keluhan Anda akan terkirim kepada moderator.
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
          <xsl:text>Teruskan menjelajah</xsl:text>
        </a>
      </p>
    </div>
  </xsl:template>

  <xsl:template match="USER-COMPLAINT-FORM[MESSAGE/@TYPE = 'SUBMIT-SUCCESSFUL'] | USERCOMPLAINT[@MODID]" mode="input_user-complaint-form">
    <div class="content">
      <h2>Keluhan berhasil</h2>
      <p>
        Keluhan Anda sudah berhasil terkirim dan akan diteruskankepada Tim Moderator. Mereka akan menentukan apakah <a href="{$houserulespopupurl}">Peraturan Internal</a> sudah dilanggar dan akan memberitahu kepada Anda melalui alamat email
      </p>
      <p>
        Identifikasi rujukan Anda adalah <strong>
          <xsl:value-of select="(MODERATION-REFERENCE | @MODID)[1]"/>
        </strong>
      </p>
      <xsl:if test="@HIDDEN and @HIDDEN != 0">
        <p>Sebagai tambahan informasi, pesan ini tidak diperlihatkan</p>
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
                    <xsl:text>http://www.bbc.co.uk/indonesia</xsl:text>
                  </xsl:otherwise>
                </xsl:choose>

              </xsl:with-param>
            </xsl:call-template>
          </xsl:attribute>
          <xsl:text>Teruskan menjelajah</xsl:text>
        </a>
      </p>
    </div>
  </xsl:template>

 



</xsl:stylesheet>