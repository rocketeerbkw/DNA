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
            <h2>के बारे में शिकायत <xsl:call-template name="item_name"/></h2>
            <p>ये फॉर्म केवल गंभीर शिकायतों के लिए है जो खास सामग्री के बारे में हैं <a href="{$houserulespopupurl}">आंतरिक नियम</a></p>
            <p>यदि आपकी कोई सामान्य टिप्पणी या सवाल है तो कृपया इस फॉर्म का प्रयोग न करें, चर्चा के लिए एक संदेश भेजें</p>
            <p>आपने जो शिकायती संदेश भेजा है, उसे एक संचालक को पास भेजा जाएगा जो इस बारे में तय करेंगे <a href="{$houserulespopupurl}">आंतरिक नियम</a> उनके निर्णय के बारे में आपको ई-मेल के माध्यम से सूचित किया जाएगा</p>
            <p class="action">
              <xsl:choose>
                <xsl:when test="@POSTID">
                  <a href="?PostId={(POST-ID | @POSTID)[1]}&amp;s_ptrt={/H2G2/PARAMS/PARAM[NAME = 's_ptrt']/VALUE}&amp;s_start=2">मेरी शिकायत दर्ज करें</a>
                </xsl:when>
                <xsl:when test="@H2G2ID">
                  <a href="?h2g2Id={@H2G2ID}&amp;s_ptrt={/H2G2/PARAMS/PARAM[NAME = 's_ptrt']/VALUE}&amp;s_start=2">मेरी शिकायत दर्ज करें</a>
                </xsl:when>
                <xsl:otherwise>
                  <a href="?url={@URL}&amp;s_ptrt={/H2G2/PARAMS/PARAM[NAME = 's_ptrt']/VALUE}&amp;s_start=2">मेरी शिकायत दर्ज करें</a>
                </xsl:otherwise>
              </xsl:choose>
            </p>
        </div>
        <xsl:call-template name="library_userstate">
            <xsl:with-param name="loggedin"></xsl:with-param>
            <xsl:with-param name="unauthorised"></xsl:with-param>
            <xsl:with-param name="loggedout">
                <div class="content">
                    <p>आपने इस वेबसाइट पर साइन इन नहीं किया है. यदि आपने इस वेबसाइट पर एक अकाउंट बनाया है तो कृपया साइन-इन करें क्योंकि इससे हमें आपकी शिकायत आगे बढ़ाने में मदद मिलेगी</p>
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
                          <xsl:text>साइन इन</xsl:text>
                      </a>
                    </p>
                </div>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>

  <xsl:template name="item_name">
    <xsl:choose>
      <xsl:when test="@POSTID">
        <xsl:text>भेजे</xsl:text>
      </xsl:when>
      <xsl:when test="@H2G2ID">
        <xsl:text>लेख</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>कन्टेंट आइटम</xsl:text>
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
                
            	<h2>संचालकों को सचेत कर रहा है</h2>
            	<p>कृपया चयन करें <a href="{$houserulespopupurl}">हाउस रूल्स</a> आप ये मानते हैं <xsl:call-template name="item_name"/> यदि आपको लगता है कि इससे एक से अधिक नियम टूटते हैं तो कृपया उस चूक को चुने जो सबसे अधिक गंभीर है</p>
            </div>
            
            <div class="content">
              <h2>आपकी शिकायत की वजह</h2>
              <p>
                मैं ये मानता हूं <xsl:call-template name="item_name"/> कोई नियम टूट सकता है <a href="{$houserulespopupurl}">हाउस रूल्स</a> क्योंकि ये
              </p>
               
                <p class="options">
                	<p class="options">
                		<input type="radio" id="dnaacs-cq-1" value="अपमानसूचक या निंदात्मक है" name="s_complaintText"/><label for="dnaacs-cq-1">अपमानसूचक या निंदात्मक है</label>
                		<input type="radio" id="dnaacs-cq-2" value="नस्ली, कामुक या किसी और तरह से अपमानजनक है" name="s_complaintText"/><label for="dnaacs-cq-2">नस्ली, कामुक या किसी और तरह से अपमानजनक है</label>
                		<input type="radio" id="dnaacs-cq-3" value="में ऐसी भाषा का इस्तेमाल है जो लोगों को बुरी लग सकती है" name="s_complaintText"/><label for="dnaacs-cq-3">में ऐसी भाषा का इस्तेमाल है जो लोगों को बुरी लग सकती है</label>
                		<input type="radio" id="dnaacs-cq-4" value="कानून तोड़ती है या गैर कानूनी गतिविधियों को बढ़ावा देती है कॉपीराइट या अदालत की अवमानना" name="s_complaintText"/><label for="dnaacs-cq-4">कानून तोड़ती है या गैर कानूनी गतिविधियों को बढ़ावा देती है <a href="http://www.bbc.co.uk/messageboards/newguide/popup_copyright.html">कॉपीराइट</a> या अदालत की अवमानना</label>
                		<input type="radio" id="dnaacs-cq-5" value="उत्पादों या सेवाओं का लाभ या मुनाफे के लिए विज्ञापन" name="s_complaintText"/><label for="dnaacs-cq-5">उत्पादों या सेवाओं का लाभ या मुनाफे के लिए विज्ञापन</label>
                		<input type="radio" id="dnaacs-cq-7" value="किसी और का छद्म वेश है" name="s_complaintText"/><label for="dnaacs-cq-7">किसी और का छद्म वेश है</label>
                		<input type="radio" id="dnaacs-cq-8" value="इसमें फोन नंबर, पोस्टल या ई-मेल जैसी निजी जानकारी शामिल है" name="s_complaintText"/><label for="dnaacs-cq-8">इसमें फोन नंबर, पोस्टल या ई-मेल जैसी निजी जानकारी शामिल है</label>
                		<xsl:call-template name="library_userstate">
                      <xsl:with-param name="loggedin">
                        <input type="radio" id="dnaacs-cq-9" value="इस पर चर्चा होनी चाहिए" name="s_complaintText"/><label for="dnaacs-cq-9">इस पर चर्चा होनी चाहिए</label>
                      </xsl:with-param>
                    </xsl:call-template>
                		<input type="radio" id="dnaacs-cq-10" value="ये अंग्रेजी में नहीं है" name="s_complaintText"/><label for="dnaacs-cq-10">ये अंग्रेजी में नहीं है</label>
                		<input type="radio" id="dnaacs-cq-11" value="इसमें एक बाहरी वेबसाइट की लिंक है जो हमारे नियम तोड़ती है संपादकीय दिशा-निर्देश" name="s_complaintText"/><label for="dnaacs-cq-11">इसमें एक बाहरी वेबसाइट की लिंक है जो हमारे नियम तोड़ती है <a href="http://www.bbc.co.uk/messageboards/newguide/popup_editorial_guidelines.html">संपादकीय दिशा-निर्देश</a></label>
                		<input type="radio" id="dnaacs-cq-12" value="ये ऐसी गतिविधियों को बताता है या बढ़ावा देता है जो सुरक्षा के लिए खतरा या दूसरों को नुकसान पहुंचा सकता है" name="s_complaintText"/><label for="dnaacs-cq-12">ये ऐसी गतिविधियों को बताता है या बढ़ावा देता है जो सुरक्षा के लिए खतरा या दूसरों को नुकसान पहुंचा सकता है</label>
                		<input type="radio" id="dnaacs-cq-13" value="इसमें एक अनुचित यूज़रनेम है" name="s_complaintText"/><label for="dnaacs-cq-13">इसमें एक अनुचित यूज़रनेम है</label>
                		<input type="radio" id="dnaacs-cq-14" value="ये स्पैम है" name="s_complaintText"/><label for="dnaacs-cq-14">ये स्पैम है</label>
                		<input type="radio" id="dnaacs-cq-6" value="अन्य" name="s_complaintText"/><label for="dnaacs-cq-6">ये नियम तोड़ता है जिसकी वजह इस सूची में नहीं है</label>
                	</p>
                </p>

              <p class="action">
                <input type="submit" value="अगला पेज"/>
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
        alert("शिकायत का कारण चुनें");
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
           	<p>आपको जो वजह लगती है, उसे हमें बताने के लिए कृपया नीचे दिए गए बॉक्स को भरिए <xsl:call-template name="item_name"/> नियम तोड़ता है. पूरा करने के बाद भेजे या शिकायत पर क्लिक करें ताकि संचालक इसकी समीक्षा कर सकें</p>
               <p>
                  <xsl:if test="/H2G2/PARAMS/PARAM[NAME = 's_complaintText']/VALUE and /H2G2/PARAMS/PARAM[NAME = 's_complaintText']/VALUE = 'अन्य'">
                    मैं इस बारे में शिकायत करना चाहता हूं <xsl:call-template name="item_name"/> इस वजह से
                  </xsl:if>
                   
               </p>
                <p class="options">
                    <textarea id="reason" rows="10" cols="40" name="complainttext" class="textarea">
                    	<xsl:if test="/H2G2/PARAMS/PARAM[NAME = 's_complaintText']/VALUE and /H2G2/PARAMS/PARAM[NAME = 's_complaintText']/VALUE != 'अन्य'">
                        <xsl:text>मैं मानता हूं </xsl:text><xsl:call-template name="item_name"/>
                        <xsl:text xml:space="preserve"> </xsl:text>
                        <xsl:apply-templates select="/H2G2/PARAMS/PARAM[NAME = 's_complaintText']/VALUE" mode="library_string_stringtolower"/><xsl:text> इसकी वजह ये है</xsl:text>
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
                    <h3>आपका ई मेल पता</h3>
                    <p>
                      <em>आपकी शिकायत आगे बढ़ाने और उस पर संचालक के निर्णय से आपको अवगत कराने के लिए हमें आपके ई-मेल पते की आवश्यकता है. आपकी शिकायत के बारे में अधिक जानकारी के लिए कभी-कभी हम आपसे सीधे संपर्क भी कर सकते हैं.</em>
                    </p>
                    <p>
                        <label for="emailaddress">ई-मेल पता</label>
                        <input type="text" name="email" id="emailaddress" value="" class="textbox"/>
                    </p>
                </xsl:otherwise>
              </xsl:choose>
              
                <xsl:if test="(/H2G2/VIEWING-USER/USER/GROUPS/EDITOR) or (/H2G2/VIEWING-USER/USER/STATUS = 2) or (/H2G2/VIEWING-USER/USER/GROUPS/GROUP[NAME='EDITOR'])">
                    <p>
                        <input type="checkbox" value="1" name="hidepost" id="hidePost"/>
                        <label for="hidePost"> इसे छुपाएं <xsl:call-template name="item_name"/> फौरन</label>.
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
                    <input type="hidden" name="action" value="भेजें"/>
                    <input type="submit" value="शिकायत भेजें" name="Submit" class="button"/>
                </p>
            </div>
            
        </form>
    </xsl:template>
    
    <xsl:template match="USER-COMPLAINT-FORM[ERROR] | ERROR" mode="input_user-complaint-form">
      <div class="content">
        <h2>सूचना</h2>
        <xsl:choose>
          <xsl:when test="@TYPE = 'EMAILNOTALLOWED'">
            <p>
			   शिकायतें दर्ज कराने के लिए ऑनलाइन प्रणाली का इस्तेमाल करने से आपको रोक दिया गया है. कृपया हमें लिखें<br />
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
      <h2>ई-मेल का सत्यापन</h2>
      <p>
		आपकी शिकायत दर्ज हो गई है. आप जब तक अपने ई-मेल पते का सत्यापन नहीं कराते, संचालक इसे नहीं देखेंगे. इससे झूठी शिकायतें और स्पैम रोकने में मदद मिलेगी.
      </p>
      <p>
		ई-मेल के जरिए आपको एक लिंक शीघ्र मिलेगा. इस पर क्लिक करने से आपकी शिकायत संचालक तक पहुंच जाएगी
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
          <xsl:text>ब्राउज़िंग जारी</xsl:text>
        </a>
      </p>
    </div>
  </xsl:template>

  <xsl:template match="USER-COMPLAINT-FORM[MESSAGE/@TYPE = 'SUBMIT-SUCCESSFUL'] | USERCOMPLAINT[@MODID]" mode="input_user-complaint-form">
    <div class="content">
      <h2>शिकायत सफलतापूर्वक पहुंच गई</h2>
      <p>
		   आपकी शिकायत सफलतापूर्वक सहेजी गई है और संचालकों की टीम को अग्रेषित की गई है. वे इस बारे में निर्णय करेंगे
      </p>
      <p>
            आपकी संचालन संदर्भ पहचान संख्या है <strong>
          <xsl:value-of select="(MODERATION-REFERENCE | @MODID)[1]"/>
        </strong>
      </p>
      <xsl:if test="@HIDDEN and @HIDDEN != 0">
        <p>इस पोस्ट को छुपा दिया गया है</p>
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
                    <xsl:text>http://www.bbc.co.uk/hindi</xsl:text>
                  </xsl:otherwise>
                </xsl:choose>

              </xsl:with-param>
            </xsl:call-template>
          </xsl:attribute>
          <xsl:text>ब्राउज़िंग जारी</xsl:text>
        </a>
      </p>
    </div>
  </xsl:template>

 



</xsl:stylesheet>