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
            <h2>投诉主题：<xsl:call-template name="item_name"/></h2>
            <p>这个表格只适用于严重的投诉，所牵涉的内容违反了<a href="http://www.bbc.co.uk/zhongwen/simp/institutional/2011/04/111111_moderation_rules.shtml">编辑原则</a></p>
            <p>如果你有一般评论或问题，请勿使用此表格。请在相关讨论区发表评论。</p>
            <p>你所投诉的评论将会送交编辑审核。编辑将决定该评论是否违反了<a href="http://www.bbc.co.uk/zhongwen/simp/institutional/2011/04/111111_moderation_rules.shtml">编辑原则。</a>有关的决定将会通过电子邮件通知你。</p>
            <p class="action">
              <xsl:choose>
                <xsl:when test="@POSTID">
                  <a href="?PostId={(POST-ID | @POSTID)[1]}&amp;s_ptrt={/H2G2/PARAMS/PARAM[NAME = 's_ptrt']/VALUE}&amp;s_start=2">发表我的投诉</a>
                </xsl:when>
                <xsl:when test="@H2G2ID">
                  <a href="?h2g2Id={@H2G2ID}&amp;s_ptrt={/H2G2/PARAMS/PARAM[NAME = 's_ptrt']/VALUE}&amp;s_start=2">发表我的投诉</a>
                </xsl:when>
                <xsl:otherwise>
                  <a href="?url={@URL}&amp;s_ptrt={/H2G2/PARAMS/PARAM[NAME = 's_ptrt']/VALUE}&amp;s_start=2">发表我的投诉</a>
                </xsl:otherwise>
              </xsl:choose>
            </p>
        </div>
        <xsl:call-template name="library_userstate">
            <xsl:with-param name="loggedin"></xsl:with-param>
            <xsl:with-param name="unauthorised"></xsl:with-param>
            <xsl:with-param name="loggedout">
                <div class="content">
                    <p>你没有登录到这个网站的帐户。如果你已经拥有注册帐户，请登录进入，这样可以帮助我们处理你的投诉。</p>
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
                          <xsl:text>登录</xsl:text>
                      </a>
                    </p>
                </div>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>

  <xsl:template name="item_name">
    <xsl:choose>
      <xsl:when test="@POSTID">
        <xsl:text>读者评论</xsl:text>
      </xsl:when>
      <xsl:when test="@H2G2ID">
        <xsl:text>文章</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>藏此</xsl:text>
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
                
            	<h2>通知编辑</h2>
            	<p>请选择其中一项<a href="http://www.bbc.co.uk/zhongwen/simp/institutional/2011/04/111111_moderation_rules.shtml">编辑原则</a>。你认为这项原则<xsl:call-template name="item_name"/>被违反了。如果你认为违反了超过一项原则，请选择最严重的违反程度。</p>
            </div>
            
            <div class="content">
              <h2>投诉原因</h2>
              <p>
                我认为它<xsl:call-template name="item_name"/>可能违反了<a href="http://www.bbc.co.uk/zhongwen/simp/institutional/2011/04/111111_moderation_rules.shtml">编辑原则</a>，因为它
              </p>
               
                <p class="options">
                	<p class="options">
                		<input type="radio" id="dnaacs-cq-1" value="涉及中伤或诽谤他人" name="s_complaintText"/><label for="dnaacs-cq-1">涉及中伤或诽谤他人</label>
                		<input type="radio" id="dnaacs-cq-2" value="涉及种族歧视、性别歧视、同性恋恐惧、性描写、淩辱或其他冒犯" name="s_complaintText"/><label for="dnaacs-cq-2">涉及种族歧视、性别歧视、同性恋恐惧、性描写、淩辱或其他冒犯</label>
                		<input type="radio" id="dnaacs-cq-3" value="包含咒骂字词或其它可能冒犯他人的语言" name="s_complaintText"/><label for="dnaacs-cq-3">包含咒骂字词或其它可能冒犯他人的语言</label>
                		<input type="radio" id="dnaacs-cq-4" value="违反法律、同情或鼓励非法行为，例如违反版权或藐视法庭" name="s_complaintText"/><label for="dnaacs-cq-4">违反法律、同情或鼓励非法行为，例如违反<a href="http://www.bbc.co.uk/zhongwen/simp/institutional/2011/04/111111_copyright.shtml">版权</a>或藐视法庭</label>
                		<input type="radio" id="dnaacs-cq-5" value="为商品做广告宣传赚取利润" name="s_complaintText"/><label for="dnaacs-cq-5">为商品做广告宣传赚取利润</label>
                		<input type="radio" id="dnaacs-cq-7" value="冒充他人" name="s_complaintText"/><label for="dnaacs-cq-7">冒充他人</label>
                		<input type="radio" id="dnaacs-cq-8" value="包含个人资料，例如电话号码、邮递或电邮地址" name="s_complaintText"/><label for="dnaacs-cq-8">包含个人资料，例如电话号码、邮递或电邮地址</label>
                		<xsl:call-template name="library_userstate">
                      <xsl:with-param name="loggedin">
                        <input type="radio" id="dnaacs-cq-9" value="与讨论的题目完全无关" name="s_complaintText"/><label for="dnaacs-cq-9">与讨论的题目完全无关</label>
                      </xsl:with-param>
                    </xsl:call-template>
                		<input type="radio" id="dnaacs-cq-10" value="不是中文" name="s_complaintText"/><label for="dnaacs-cq-10">不是中文</label>
                		<input type="radio" id="dnaacs-cq-11" value="含有外界链接，违反我们的编辑原则" name="s_complaintText"/><label for="dnaacs-cq-11">含有外界链接，违反我们的<a href="http://www.bbc.co.uk/zhongwen/simp/institutional/2011/04/111111_help.shtml#Top6">编辑原则</a></label>
                		<input type="radio" id="dnaacs-cq-12" value="形容或鼓励某些危害其他人安全或福祉的行为" name="s_complaintText"/><label for="dnaacs-cq-12">形容或鼓励某些危害其他人安全或福祉的行为</label>
                		<input type="radio" id="dnaacs-cq-13" value="含有不适当的用户名" name="s_complaintText"/><label for="dnaacs-cq-13">含有不适当的用户名</label>
                		<input type="radio" id="dnaacs-cq-14" value="是滥发的讯息" name="s_complaintText"/><label for="dnaacs-cq-14">是滥发的讯息</label>
                		<input type="radio" id="dnaacs-cq-6" value="其他" name="s_complaintText"/><label for="dnaacs-cq-6">违反原则的原因不在上列</label>
                	</p>
                </p>

              <p class="action">
                <input type="submit" value="下一页"/>
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
        alert("请选择投诉原因");
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
           	<p>请在以下空格填写为何你认为<xsl:call-template name="item_name"/>违反这项原则。填写完毕后，请点击“发表投诉”，让编辑审核。</p>
               <p>
                  <xsl:if test="/H2G2/PARAMS/PARAM[NAME = 's_complaintText']/VALUE and /H2G2/PARAMS/PARAM[NAME = 's_complaintText']/VALUE = '其他'">
                    我要投诉这个<xsl:call-template name="item_name"/>因为下列原因：
                  </xsl:if>
                   
               </p>
                <p class="options">
                    <textarea id="reason" rows="10" cols="40" name="complainttext" class="textarea">
                    	<xsl:if test="/H2G2/PARAMS/PARAM[NAME = 's_complaintText']/VALUE and /H2G2/PARAMS/PARAM[NAME = 's_complaintText']/VALUE != '其他'">
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
                    <h3>你的电邮地址</h3>
                    <p>
                      <em>我们需要你的电邮地址来处理你的投诉，以及通知你编辑的决定。有时候，我们可能需要与你直接联系，以取得关于你的投诉的更多资料。</em>
                    </p>
                    <p>
                        <label for="emailaddress">电邮地址</label>
                        <input type="text" name="email" id="emailaddress" value="" class="textbox"/>
                    </p>
                </xsl:otherwise>
              </xsl:choose>
              
                <xsl:if test="(/H2G2/VIEWING-USER/USER/GROUPS/EDITOR) or (/H2G2/VIEWING-USER/USER/STATUS = 2) or (/H2G2/VIEWING-USER/USER/GROUPS/GROUP[NAME='EDITOR'])">
                    <p>
                        <input type="checkbox" value="1" name="hidepost" id="hidePost"/>
                        <label for="hidePost">立刻隐<xsl:call-template name="item_name"/>内容</label>.
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
                    <input type="submit" value="发表投诉" name="Submit" class="button"/>
                </p>
            </div>
            
        </form>
    </xsl:template>
    
	<xsl:template match="USER-COMPLAINT-FORM[ERROR] | ERROR" mode="input_user-complaint-form">
      <div class="content">
        <h2>资料</h2>
        <xsl:choose>
          <xsl:when test="@TYPE = 'EMAILNOTALLOWED'">
            <p>
              你已经被拒绝使用在线投诉系统，请致函：<br />
              Broadcast Centre<br />
              201 Wood Lane<br />
              White City<br />
              London<br />
              W12 7TP
            </p>
          </xsl:when>
          <xsl:when test="@TYPE = 'REGISTERCOMPLAINT'">
            <p>
              不能成功登记投诉
            </p>
          </xsl:when>
          <xsl:when test="@TYPE = 'EMAIL'">
            <p>
              无效的电邮地址
            </p>
          </xsl:when>
          <xsl:when test="@TYPE = 'NOTFOUND'">
            <p>
              找不到评论
            </p>
          </xsl:when>
          <xsl:when test="@TYPE = 'InvalidVerificationCode'">
            <p>
              验证码无效
            </p>
          </xsl:when>
          <xsl:when test="@TYPE = 'AlreadyModerated'">
            <p>
              此评论已经过审阅并已被删除。
            </p>
          </xsl:when>
          <xsl:when test ="@TYPE = 'COMPLAINTTEXT'">
            <p>
              没有投诉内容 
            </p>
          </xsl:when>
          <xsl:when test ="@TYPE = 'COMPLAINTREASON'">
            <p>
              没有投诉原因
            </p>
          </xsl:when>
          <xsl:when test="@TYPE = 'HIDEPOST'">
            <p>
              不能隐藏评论
            </p>
            
          </xsl:when>
          <xsl:when test="@TYPE = 'URL'">
            <p>
              网址无效
            </p>
          </xsl:when>
        </xsl:choose>

      </div>
    </xsl:template>

  <xsl:template match="USERCOMPLAINT[@REQUIRESVERIFICATION = '1']" mode="input_user-complaint-form">
    <div class="content">
      <h2>电邮核实</h2>
      <p>
        你的投诉已经提交。在你核实你的电子邮件地址之前，编辑不会予以处理。这个做法是为了防止冒充和滥发行为。
      </p>
      <p>
        你很快会收到一封电子邮件，当中附有一个链接以启动你的投诉。点击这个链接将会把你的投诉送达编辑。
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
          <xsl:text>继续浏览</xsl:text>
        </a>
      </p>
    </div>
  </xsl:template>

  <xsl:template match="USER-COMPLAINT-FORM[MESSAGE/@TYPE = 'SUBMIT-SUCCESSFUL'] | USERCOMPLAINT[@MODID]" mode="input_user-complaint-form">
    <div class="content">
      <h2>投诉成立</h2>
      <p>
        你的投诉已经送达编辑团队。他们将审核<a href="http://www.bbc.co.uk/zhongwen/simp/institutional/2011/04/111111_moderation_rules.shtml">编辑原则</a>给违背了，并将通过你的电邮地址通知你。
      </p>
      <p>
        你的编辑参考号码是：<strong>
          <xsl:value-of select="(MODERATION-REFERENCE | @MODID)[1]"/>
        </strong>
      </p>
      <xsl:if test="@HIDDEN and @HIDDEN != 0">
        <p>此外，有关文稿已经被隐藏。</p>
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
                    <xsl:text>http://www.bbc.co.uk/zhongwen/simp</xsl:text>
                  </xsl:otherwise>
                </xsl:choose>

              </xsl:with-param>
            </xsl:call-template>
          </xsl:attribute>
          <xsl:text>继续浏览</xsl:text>
        </a>
      </p>
    </div>
  </xsl:template>

 



</xsl:stylesheet>