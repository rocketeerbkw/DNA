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
            <h2>आपकी शिकायत जिस पोस्ट से जुड़ी है वो <xsl:call-template name="item_name"/></h2>
            <p>ये फ़ॉर्म केवल ऐसे कमेंट के बारे में शिकायत करने के लिए है जो हमारे हाउस रूल्स तोड़ता है. हमारे <a href="http://www.bbc.co.uk/hindi/institutional/2011/09/000001_forum_rules.shtml">हाउस रूल्स</a>.</p>
            <p>अगर आप कोई सवाल पूछना चाहते हैं या टिप्पणी करना चाहते हैं तो अपना कमेंट सामान्य तरीके से पोस्ट करें.</p>
            <p>आपने जिस कमेंट के बारे में शिकायत की है उसे हमारी टीम के एक सदस्य पढ़ेगा और तय करेंगा कि कमेंट हमारे हाउस रुल्स तोड़ता है या नहीं. हमारे <a href="http://www.bbc.co.uk/hindi/institutional/2011/09/000001_forum_rules.shtml">हाउस रूल्स</a>. हमारे फ़ैसले की सूचना आपको ई-मेल से दी जाएगी.</p>
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
                    <p>आपने इस वेबसाइट पर साइन-इन नहीं किया है. यदि आपने इस वेबसाइट पर एक अकाउंट बनाया है तो कृपया साइन-इन करें क्योंकि इससे हमें आपकी शिकायत आगे बढ़ाने में मदद मिलेगी</p>
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
                          <xsl:text>साइन-इन करें</xsl:text>
                      </a>
                    </p>
                </div>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>

  <xsl:template name="item_name">
    <xsl:choose>
      <xsl:when test="@POSTID">
        <xsl:text>पोस्ट</xsl:text>
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
                
            	<h2>हमारी टीम को एलर्ट करें</h2>
            	<p>आपकी राय में हमारे <a href="http://www.bbc.co.uk/hindi/institutional/2011/09/000001_forum_rules.shtml">हाउस रूल्स</a> में कौन सा रूल तोड़ा गया है. <xsl:call-template name="item_name"/> यदि आपको लगता है कि एक से अधिक रूल तोड़े गए हैं को तो कृपया उस चूक को चुने जो सबसे अधिक गंभीर है</p>
            </div>
            
            <div class="content">
              <h2>आपकी शिकायत की वजह</h2>
              <p>
				मेरी राय में ये <xsl:call-template name="item_name"/>  कोई नियम टूट सकता है <a href="http://www.bbc.co.uk/hindi/institutional/2011/09/000001_forum_rules.shtml">हाउस रूल्स</a>  के नियमों में से एक को तोड़ रहा है क्योंकि यह
              </p>
               
                <p class="options">
                	<p class="options">
                		<input type="radio" id="dnaacs-cq-1" value="अपमानसूचक या निंदात्मक है" name="s_complaintText"/><label for="dnaacs-cq-1">अपमानसूचक या निंदात्मक है</label>
                		<input type="radio" id="dnaacs-cq-2" value="नस्ली, कामुक या किसी और तरह से अपमानजनक है" name="s_complaintText"/><label for="dnaacs-cq-2">नस्ली, कामुक या किसी और तरह से अपमानजनक है</label>
                		<input type="radio" id="dnaacs-cq-3" value="ऐसी भाषा का इस्तेमाल करता है जो लोगों को बुरी लग सकती है" name="s_complaintText"/><label for="dnaacs-cq-3">ऐसी भाषा का इस्तेमाल करता है जो लोगों को बुरी लग सकती है</label>
                		<input type="radio" id="dnaacs-cq-4" value="कानून तोड़ता है या गैर कानूनी गतिविधियों को बढ़ावा देता है कॉपीराइट या अदालत की अवमानना" name="s_complaintText"/><label for="dnaacs-cq-4">कानून तोड़ता है या गैर कानूनी गतिविधियों को बढ़ावा देता है <a href="http://www.bbc.co.uk/hindi/institutional/2011/09/000001_terms.shtml">कॉपीराइट</a> या अदालत की अवमानना</label>
                		<input type="radio" id="dnaacs-cq-5" value="उत्पादों या सेवाओं का लाभ या मुनाफे के लिए विज्ञापन करता है" name="s_complaintText"/><label for="dnaacs-cq-5">उत्पादों या सेवाओं का लाभ या मुनाफे के लिए विज्ञापन करता है</label>
                		<input type="radio" id="dnaacs-cq-7" value="किसी जानेमाने व्यक्ति की राय दिखने की कोशिश करता है" name="s_complaintText"/><label for="dnaacs-cq-7">किसी जानेमाने व्यक्ति की राय दिखने की कोशिश करता है</label>
                		<input type="radio" id="dnaacs-cq-8" value="इसमें फोन नंबर, पोस्टल या ई-मेल जैसी निजी जानकारी शामिल है" name="s_complaintText"/><label for="dnaacs-cq-8">इसमें फोन नंबर, पोस्टल या ई-मेल जैसी निजी जानकारी शामिल है</label>
                		<xsl:call-template name="library_userstate">
                      <xsl:with-param name="loggedin">
                        <input type="radio" id="dnaacs-cq-9" value="इसका चर्चा के विषय के कोई लेना-देना नहीं है" name="s_complaintText"/><label for="dnaacs-cq-9">इसका चर्चा के विषय के कोई लेना-देना नहीं है</label>
                      </xsl:with-param>
                    </xsl:call-template>
                		<input type="radio" id="dnaacs-cq-10" value="ये चर्चा के विषय की भाषा में नहीं है." name="s_complaintText"/><label for="dnaacs-cq-10">ये चर्चा के विषय की भाषा में नहीं है.</label>
                		<input type="radio" id="dnaacs-cq-11" value="इसमें एक बाहरी वेबसाइट की लिंक है जो हमारे नियम तोड़ता है हमारी एडिटोरियल गाईडलाइन्स" name="s_complaintText"/><label for="dnaacs-cq-11">इसमें एक बाहरी वेबसाइट की लिंक है जो हमारे नियम तोड़ता है <a href="http://www.bbc.co.uk/messageboards/newguide/popup_editorial_guidelines.html">हमारी एडिटोरियल गाईडलाइन्स</a></label>
                		<input type="radio" id="dnaacs-cq-12" value="ये ऐसी गतिविधियों को बताता या बढ़ावा देता है जो सुरक्षा के लिए खतरा या दूसरों को नुकसान पहुंचा सकता है" name="s_complaintText"/><label for="dnaacs-cq-12">ये ऐसी गतिविधियों को बताता या बढ़ावा देता है जो सुरक्षा के लिए खतरा या दूसरों को नुकसान पहुंचा सकता है</label>
                		<input type="radio" id="dnaacs-cq-13" value="इसमें एक अनुचित यूज़रनेम है" name="s_complaintText"/><label for="dnaacs-cq-13">इसमें एक अनुचित यूज़रनेम है</label>
                		<input type="radio" id="dnaacs-cq-14" value="ये स्पैम है" name="s_complaintText"/><label for="dnaacs-cq-14">ये स्पैम है</label>
                		<input type="radio" id="dnaacs-cq-6" value="अन्य" name="s_complaintText"/><label for="dnaacs-cq-6">ये ऐसा नियम तोड़ता है जिसकी वजह इस सूची में नहीं है</label>
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
           	<p>कृपया नीचे दिए गए बॉक्स में लिखिए कि क्यों ये <xsl:call-template name="item_name"/> नियम तोड़ता है. लिखने के बाद शिकायत भेजें पर क्लिक करें ताकि हमारी टीम इसको देख सके.</p>
               <p>
                  <xsl:if test="/H2G2/PARAMS/PARAM[NAME = 's_complaintText']/VALUE and /H2G2/PARAMS/PARAM[NAME = 's_complaintText']/VALUE = 'अन्य'">
                    मेरी राय में इस <xsl:call-template name="item_name"/> को हटाना चाहिए क्योंकि
                  </xsl:if>
                   
               </p>
                <p class="options">
                    <textarea id="reason" rows="10" cols="40" name="complainttext" class="textarea">
                    	<xsl:if test="/H2G2/PARAMS/PARAM[NAME = 's_complaintText']/VALUE and /H2G2/PARAMS/PARAM[NAME = 's_complaintText']/VALUE != 'अन्य'">
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
                    <h3>आपका ई मेल पता</h3>
                    <p>
                      <em>आपकी शिकायत आगे बढ़ाने और उस पर संचालक के निर्णय से आपको अवगत कराने के लिए हमें आपके ई-मेल पते की आवश्यकता है. आपकी शिकायत के बारे में अधिक जानकारी के लिए कभी-कभी हम आपसे सीधे संपर्क भी कर सकते हैं.</em>
                    </p>
                    <p>
                        <label for="emailaddress">आपका ई-मेल पता</label>
                        <input type="text" name="email" id="emailaddress" value="" class="textbox"/>
                    </p>
                </xsl:otherwise>
              </xsl:choose>
              
                <xsl:if test="(/H2G2/VIEWING-USER/USER/GROUPS/EDITOR) or (/H2G2/VIEWING-USER/USER/STATUS = 2) or (/H2G2/VIEWING-USER/USER/GROUPS/GROUP[NAME='EDITOR'])">
                    <p>
                        <input type="checkbox" value="1" name="hidepost" id="hidePost"/>
                        <label for="hidePost"> तत्काल <xsl:call-template name="item_name"/> फौरन</label>.
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
			   आपको शिकायतें दर्ज कराने के ऑनलाइन सिस्टम से ब्लॉक कर दिया गया है. कृपया हमें यहाँ लिखे<br />
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
      <h2>ई-मेल वेरिफ़ाइ करें</h2>
      <p>
            आपकी शिकायत दर्ज हो गई है. आप जब तक अपने ई-मेल पते को वेरिफ़ाइ नहीं करते, हमारी टीम इसे नहीं देखेगी. ऐसा झूठी शिकायतें और स्पैम रोकने के लिए किया गया है.
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
          <xsl:text>ब्राउज़िंग जारी रखें</xsl:text>
        </a>
      </p>
    </div>
  </xsl:template>

  <xsl:template match="USER-COMPLAINT-FORM[MESSAGE/@TYPE = 'SUBMIT-SUCCESSFUL'] | USERCOMPLAINT[@MODID]" mode="input_user-complaint-form">
    <div class="content">
      <h2>शिकायत सफलतापूर्वक पहुंच गई</h2>
      <p>
        आपकी शिकायत हमें मिल गई है और हमारी टीम को भेज दी गई है. वे इस बारे में निर्णय करेंगे. <a href="http://www.bbc.co.uk/hindi/institutional/2011/09/000001_forum_rules.shtml">हाउस रूल्स</a> तोड़े गए हैं और आपको ई-मेल के जरिए सूचित किया जाएगा
      </p>
      <p>
            आपकी मॉडरेशन रेफ़ेरंस आई-डी है <strong>
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
          <xsl:text>ब्राउज़िंग जारी रखें</xsl:text>
        </a>
      </p>
    </div>
  </xsl:template>

 



</xsl:stylesheet>