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
            <h2>投訴主題：<xsl:call-template name="item_name"/></h2>
            <p>這個表格只適用於嚴重的投訴，所牽涉内容違反了<a href="http://www.bbc.co.uk/zhongwen/trad/institutional/2011/04/111111_moderation_rules.shtml">編輯原則</a></p>
            <p>如果你有一般評論或問題，請勿使用此表格。請在相關討論區發表評論。</p>
            <p>你所投訴的評論將會送交編輯審核。編輯將決定該評論是否違反了<a href="http://www.bbc.co.uk/zhongwen/trad/institutional/2011/04/111111_moderation_rules.shtml">編輯原則。</a>有關的決定將會通過電子郵件通知你。</p>
            <p class="action">
              <xsl:choose>
                <xsl:when test="@POSTID">
                  <a href="?PostId={(POST-ID | @POSTID)[1]}&amp;s_ptrt={/H2G2/PARAMS/PARAM[NAME = 's_ptrt']/VALUE}&amp;s_start=2">發表我的投訴</a>
                </xsl:when>
                <xsl:when test="@H2G2ID">
                  <a href="?h2g2Id={@H2G2ID}&amp;s_ptrt={/H2G2/PARAMS/PARAM[NAME = 's_ptrt']/VALUE}&amp;s_start=2">發表我的投訴</a>
                </xsl:when>
                <xsl:otherwise>
                  <a href="?url={@URL}&amp;s_ptrt={/H2G2/PARAMS/PARAM[NAME = 's_ptrt']/VALUE}&amp;s_start=2">發表我的投訴</a>
                </xsl:otherwise>
              </xsl:choose>
            </p>
        </div>
        <xsl:call-template name="library_userstate">
            <xsl:with-param name="loggedin"></xsl:with-param>
            <xsl:with-param name="unauthorised"></xsl:with-param>
            <xsl:with-param name="loggedout">
                <div class="content">
                    <p>你沒有登錄到這個網站的帳戶。如果你已經擁有註冊帳戶，請登錄進入，這樣可以幫助我們處理你的投訴。</p>
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
                          <xsl:text>登錄</xsl:text>
                      </a>
                    </p>
                </div>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>

  <xsl:template name="item_name">
    <xsl:choose>
      <xsl:when test="@POSTID">
        <xsl:text>讀者評論</xsl:text>
      </xsl:when>
      <xsl:when test="@H2G2ID">
        <xsl:text>文章</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>内容項目</xsl:text>
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
                
            	<h2>通知編輯</h2>
            	<p>請選擇其中一項<a href="http://www.bbc.co.uk/zhongwen/trad/institutional/2011/04/111111_moderation_rules.shtml">編輯原則</a>。你認爲這項原則<xsl:call-template name="item_name"/>被違反了。如果你認為違反了超過一項原則，請選擇最嚴重的違反程度。</p>
            </div>
            
            <div class="content">
              <h2>投訴原因</h2>
              <p>
                我認爲它<xsl:call-template name="item_name"/>可能違反了<a href="http://www.bbc.co.uk/zhongwen/trad/institutional/2011/04/111111_moderation_rules.shtml">編輯原則</a>，因爲它
              </p>
               
                <p class="options">
                	<p class="options">
                		<input type="radio" id="dnaacs-cq-1" value="涉及中傷或誹謗他人" name="s_complaintText"/><label for="dnaacs-cq-1">涉及中傷或誹謗他人</label>
                		<input type="radio" id="dnaacs-cq-2" value="涉及種族歧視、性別歧視、同性戀恐懼、性描寫、淩辱或其他冒犯" name="s_complaintText"/><label for="dnaacs-cq-2">涉及種族歧視、性別歧視、同性戀恐懼、性描寫、淩辱或其他冒犯</label>
                		<input type="radio" id="dnaacs-cq-3" value="包含咒駡字詞或其他可能冒犯他人的語言" name="s_complaintText"/><label for="dnaacs-cq-3">包含咒駡字詞或其他可能冒犯他人的語言</label>
                		<input type="radio" id="dnaacs-cq-4" value="違反法律、同情或鼓勵非法行爲，例如違反版權或藐視法庭" name="s_complaintText"/><label for="dnaacs-cq-4">違反法律、同情或鼓勵非法行爲，例如違反<a href="http://www.bbc.co.uk/zhongwen/trad/institutional/2011/04/111111_copyright.shtml">版權</a>或藐視法庭</label>
                		<input type="radio" id="dnaacs-cq-5" value="為商品做廣告宣傳賺取利潤" name="s_complaintText"/><label for="dnaacs-cq-5">為商品做廣告宣傳賺取利潤</label>
                		<input type="radio" id="dnaacs-cq-7" value="冒充他人" name="s_complaintText"/><label for="dnaacs-cq-7">冒充他人</label>
                		<input type="radio" id="dnaacs-cq-8" value="包含個人資料，例如電話號碼、郵遞或電郵地址" name="s_complaintText"/><label for="dnaacs-cq-8">包含個人資料，例如電話號碼、郵遞或電郵地址</label>
                		<xsl:call-template name="library_userstate">
                      <xsl:with-param name="loggedin">
                        <input type="radio" id="dnaacs-cq-9" value="與討論的題目完全無關" name="s_complaintText"/><label for="dnaacs-cq-9">與討論的題目完全無關</label>
                      </xsl:with-param>
                    </xsl:call-template>
                		<input type="radio" id="dnaacs-cq-10" value="不是中文" name="s_complaintText"/><label for="dnaacs-cq-10">不是中文</label>
                		<input type="radio" id="dnaacs-cq-11" value="含有外界鏈接，違反我們的編輯原則" name="s_complaintText"/><label for="dnaacs-cq-11">含有外界鏈接，違反我們的<a href="http://www.bbc.co.uk/zhongwen/trad/institutional/2011/04/111111_help.shtml#Top6">編輯原則</a></label>
                		<input type="radio" id="dnaacs-cq-12" value="形容或鼓勵某些危害其他人安全或福祉的行爲" name="s_complaintText"/><label for="dnaacs-cq-12">形容或鼓勵某些危害其他人安全或福祉的行爲</label>
                		<input type="radio" id="dnaacs-cq-13" value="含有不適當的用戶名" name="s_complaintText"/><label for="dnaacs-cq-13">含有不適當的用戶名</label>
                		<input type="radio" id="dnaacs-cq-14" value="是濫發的訊息" name="s_complaintText"/><label for="dnaacs-cq-14">是濫發的訊息</label>
                		<input type="radio" id="dnaacs-cq-6" value="其他" name="s_complaintText"/><label for="dnaacs-cq-6">違反原則的原因不在上列</label>
                	</p>
                </p>

              <p class="action">
                <input type="submit" value="下一頁"/>
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
        alert("請選擇投訴原因");
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
           	<p>請在以下空格填寫爲何你認爲<xsl:call-template name="item_name"/>違反這項原則。填寫完畢後，請點擊“發表投訴”，讓編輯審核。</p>
               <p>
                  <xsl:if test="/H2G2/PARAMS/PARAM[NAME = 's_complaintText']/VALUE and /H2G2/PARAMS/PARAM[NAME = 's_complaintText']/VALUE = '其他'">
                    我要投訴這個<xsl:call-template name="item_name"/>因爲下列原因：
                  </xsl:if>
                   
               </p>
                <p class="options">
                    <textarea id="reason" rows="10" cols="40" name="complainttext" class="textarea">
                    	<xsl:if test="/H2G2/PARAMS/PARAM[NAME = 's_complaintText']/VALUE and /H2G2/PARAMS/PARAM[NAME = 's_complaintText']/VALUE != '其他'">
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
                    <h3>你的電郵地址</h3>
                    <p>
                      <em>我們需要你的電郵地址來處理你的投訴，以及通知你編輯的決定。有時候，我們可能需要與你直接聯繫，以取得關於你的投訴的更多資料。</em>
                    </p>
                    <p>
                        <label for="emailaddress">電郵地址</label>
                        <input type="text" name="email" id="emailaddress" value="" class="textbox"/>
                    </p>
                </xsl:otherwise>
              </xsl:choose>
              
                <xsl:if test="(/H2G2/VIEWING-USER/USER/GROUPS/EDITOR) or (/H2G2/VIEWING-USER/USER/STATUS = 2) or (/H2G2/VIEWING-USER/USER/GROUPS/GROUP[NAME='EDITOR'])">
                    <p>
                        <input type="checkbox" value="1" name="hidepost" id="hidePost"/>
                        <label for="hidePost">隱藏這個<xsl:call-template name="item_name"/>立刻</label>.
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
                    <input type="submit" value="發表投訴" name="Submit" class="button"/>
                </p>
            </div>
            
        </form>
    </xsl:template>
    
    <xsl:template match="USER-COMPLAINT-FORM[ERROR] | ERROR" mode="input_user-complaint-form">
      <div class="content">
        <h2>資料</h2>
        <xsl:choose>
          <xsl:when test="@TYPE = 'EMAILNOTALLOWED'">
            <p>
              你已經被拒絕使用在綫投訴系統，請致函：<br />
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
      <h2>電郵核實</h2>
      <p>
        你的投訴已經提交。在你核實你的電子郵件地址之前，編輯不會予以處理。這個做法是爲了防止冒充和濫發行爲。
      </p>
      <p>
        你很快會收到一封電子郵件，當中附有一個鏈接以啓動你的投訴。點擊這個鏈接將會把你的投訴送達編輯。
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
          <xsl:text>繼續瀏覽</xsl:text>
        </a>
      </p>
    </div>
  </xsl:template>

  <xsl:template match="USER-COMPLAINT-FORM[MESSAGE/@TYPE = 'SUBMIT-SUCCESSFUL'] | USERCOMPLAINT[@MODID]" mode="input_user-complaint-form">
    <div class="content">
      <h2>投訴成立</h2>
      <p>
        你的投訴已經送達編輯團隊。他們將審核<a href="http://www.bbc.co.uk/zhongwen/trad/institutional/2011/04/111111_moderation_rules.shtml">編輯原則</a>給違背了，並將通過你的電郵地址通知你。
      </p>
      <p>
        你的編輯參考號碼是：<strong>
          <xsl:value-of select="(MODERATION-REFERENCE | @MODID)[1]"/>
        </strong>
      </p>
      <xsl:if test="@HIDDEN and @HIDDEN != 0">
        <p>此外，有關文稿已經被隱藏。</p>
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
                    <xsl:text>http://www.bbc.co.uk/zhongwen/trad</xsl:text>
                  </xsl:otherwise>
                </xsl:choose>

              </xsl:with-param>
            </xsl:call-template>
          </xsl:attribute>
          <xsl:text>繼續瀏覽</xsl:text>
        </a>
      </p>
    </div>
  </xsl:template>

 



</xsl:stylesheet>