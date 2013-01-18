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
            <h2>Khiếu nại về nội dung <xsl:call-template name="item_name"/></h2>
            <p>Đơn này chỉ dành cho khiếu nại nghiệm trọng về nội dung cụ thể nào đó đã vi phạm <a href="http://www.bbc.co.uk/vietnamese/institutional/2012/08/120809_bbc_rules.shtml">Quy định nội bộ</a>.</p>
            <p>Nếu bạn có nhận xét chung chung hay thắc mắc thì xin đừng dùng đơn này, hãy đăng thông điệp đó vào diễn đàn. </p>
            <p>Thông điệp của bạn sẽ được gửi tới người duyệt xem xét và quyết định liệu nó có vi phạm <a href="http://www.bbc.co.uk/vietnamese/institutional/2012/08/120809_bbc_rules.shtml ">Quy định nội bộ</a>. Bạn sẽ được thông báo bằng email.</p>
            <p class="action">
              <xsl:choose>
                <xsl:when test="@POSTID">
                  <a href="?PostId={(POST-ID | @POSTID)[1]}&amp;s_ptrt={/H2G2/PARAMS/PARAM[NAME = 's_ptrt']/VALUE}&amp;s_start=2">Đăng ký khiếu nại của tôi</a>
                </xsl:when>
                <xsl:when test="@H2G2ID">
                  <a href="?h2g2Id={@H2G2ID}&amp;s_ptrt={/H2G2/PARAMS/PARAM[NAME = 's_ptrt']/VALUE}&amp;s_start=2">Đăng ký khiếu nại của tôi</a>
                </xsl:when>
                <xsl:otherwise>
                  <a href="?url={@URL}&amp;s_ptrt={/H2G2/PARAMS/PARAM[NAME = 's_ptrt']/VALUE}&amp;s_start=2">Đăng ký khiếu nại của tôi</a>
                </xsl:otherwise>
              </xsl:choose>
            </p>
        </div>
        <xsl:call-template name="library_userstate">
            <xsl:with-param name="loggedin"></xsl:with-param>
            <xsl:with-param name="unauthorised"></xsl:with-param>
            <xsl:with-param name="loggedout">
                <div class="content">
                    <p>Bạn chưa đăng nhập trên trang web này. Nếu bạn đã đăng ký tài khoản, xin vui lòng đăng nhập để tiện việc xử lý khiếu nại của bạn. </p>
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
                          <xsl:text>Đăng nhập</xsl:text>
                      </a>
                    </p>
                </div>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>

  <xsl:template name="item_name">
    <xsl:choose>
      <xsl:when test="@POSTID">
        <xsl:text>bình luận</xsl:text>
      </xsl:when>
      <xsl:when test="@H2G2ID">
        <xsl:text>bài</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>bình luận này</xsl:text>
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
                
            	<h2>Báo cáo với người duyệt</h2>
            	<p>Hãy chọn xem mục nào <a href="http://www.bbc.co.uk/vietnamese/institutional/2012/08/120809_bbc_rules.shtml ">Quy định nội bộ</a> bạn tin điều này <xsl:call-template name="item_name"/> này đã bị vi phạm. Nếu bạn cho rằng nó đã vi phạm một vài quy định thì quy định nào bị vi phạm nặng nề nhất.</p>
            </div>
            
            <div class="content">
              <h2>Lý do khiếu nại của bạn</h2>
              <p>
                Tôi tin rằng <xsl:call-template name="item_name"/> đã vi phạm một điều trong <a href="http://www.bbc.co.uk/vietnamese/institutional/2012/08/120809_bbc_rules.shtml ">Quy định nội bộ</a> bởi vì nó đã:
              </p>
               
                <p class="options">
                	<p class="options">
                		<input type="radio" id="dnaacs-cq-1" value="phỉ báng" name="s_complaintText"/><label for="dnaacs-cq-1">phỉ báng</label>
                		<input type="radio" id="dnaacs-cq-2" value="mang tính kỳ thị chủng tộc, giới tính, lạm dụng hoặc gây phản cảm nói chung" name="s_complaintText"/><label for="dnaacs-cq-2">mang tính kỳ thị chủng tộc, giới tính, lạm dụng hoặc gây phản cảm nói chung</label>
                		<input type="radio" id="dnaacs-cq-3" value="chứa ngôn từ tục tĩu hoặc ngôn ngữ gây phản cảm" name="s_complaintText"/><label for="dnaacs-cq-3">chứa ngôn từ tục tĩu hoặc ngôn ngữ gây phản cảm</label>
                		<input type="radio" id="dnaacs-cq-4" value="vi phạm pháp luật hoặc khuyến khích hành vi trái pháp luật như vi phạm bản quyền không tuân theo pháp luật" name="s_complaintText"/><label for="dnaacs-cq-4">vi phạm pháp luật hoặc khuyến khích hành vi trái pháp luật như vi phạm <a href="http://www.bbc.co.uk/vietnamese/institutional/2011/07/000001_terms.shtml">bản quyền</a> không tuân theo pháp luật</label>
                		<input type="radio" id="dnaacs-cq-5" value="quảng cáo cho sản phẩm hoặc dịch vụ vì mục đích lợi nhuận" name="s_complaintText"/><label for="dnaacs-cq-5">quảng cáo cho sản phẩm hoặc dịch vụ vì mục đích lợi nhuận</label>
                		<input type="radio" id="dnaacs-cq-7" value="bắt chước ai đó" name="s_complaintText"/><label for="dnaacs-cq-7">bắt chước ai đó</label>
                		<input type="radio" id="dnaacs-cq-8" value="chứa thông tin cá nhân như số điện thoại, địa chỉ email hoặc địa chỉ nhà" name="s_complaintText"/><label for="dnaacs-cq-8">chứa thông tin cá nhân như số điện thoại, địa chỉ email hoặc địa chỉ nhà</label>
                		<xsl:call-template name="library_userstate">
                      <xsl:with-param name="loggedin">
                        <input type="radio" id="dnaacs-cq-9" value="nằm ngoài phạm vi của ban hoặc thuộc đề tài đang được xem xét" name="s_complaintText"/><label for="dnaacs-cq-9">nằm ngoài phạm vi của ban hoặc thuộc đề tài đang được xem xét</label>
                      </xsl:with-param>
                    </xsl:call-template>
                		<input type="radio" id="dnaacs-cq-10" value="không phải bằng tiếng Việt" name="s_complaintText"/><label for="dnaacs-cq-10">không phải bằng tiếng Việt</label>
                		<input type="radio" id="dnaacs-cq-11" value="chứa đường dẫn đến trang bên ngoài vi phạm Cẩm nang biên tập" name="s_complaintText"/><label for="dnaacs-cq-11">chứa đường dẫn đến trang bên ngoài vi phạm <a href="http://www.bbc.co.uk/messageboards/newguide/popup_editorial_guidelines.html">Cẩm nang biên tập</a></label>
                		<input type="radio" id="dnaacs-cq-12" value="mô tả hoặc kích động những hành vi gây nguy hiểm tới sự an toàn hoặc sức khỏe của người khác" name="s_complaintText"/><label for="dnaacs-cq-12">mô tả hoặc kích động những hành vi gây nguy hiểm tới sự an toàn hoặc sức khỏe của người khác</label>
                		<input type="radio" id="dnaacs-cq-13" value="có chứa tên người sử dụng không phù hợp" name="s_complaintText"/><label for="dnaacs-cq-13">có chứa tên người sử dụng không phù hợp</label>
                		<input type="radio" id="dnaacs-cq-14" value="là thư rác" name="s_complaintText"/><label for="dnaacs-cq-14">là thư rác</label>
                		<input type="radio" id="dnaacs-cq-6" value="Khác" name="s_complaintText"/><label for="dnaacs-cq-6">vi phạm quy định với lý do không có trong danh sách trên</label>
                	</p>
                </p>

              <p class="action">
                <input type="submit" value="Trang tiếp"/>
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
        alert("Hãy chọn ‎lý‎‎‎ do");
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
           	<p>Xin bạn vui lòng điền vào ô dưới đây lý do bạn cho rằng <xsl:call-template name="item_name"/> vi phạm quy định. Khi điền xong, mời bạn bấm nút Gửi Khiếu nại để chuyển tới người điều hành xem xét.</p>
               <p>
                  <xsl:if test="/H2G2/PARAMS/PARAM[NAME = 's_complaintText']/VALUE and /H2G2/PARAMS/PARAM[NAME = 's_complaintText']/VALUE = 'Khác'">
                    Tôi muốn khiếu nại về <xsl:call-template name="item_name"/> với lý do sau:
                  </xsl:if>
                   
               </p>
                <p class="options">
                    <textarea id="reason" rows="10" cols="40" name="complainttext" class="textarea">
                    	<xsl:if test="/H2G2/PARAMS/PARAM[NAME = 's_complaintText']/VALUE and /H2G2/PARAMS/PARAM[NAME = 's_complaintText']/VALUE != 'Khác'">
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
                    <h3>Địa chỉ email của bạn</h3>
                    <p>
                      <em>Chúng tôi cần có email của bạn để xử lý đơn khiếu nại và thông báo với bạn về quyết định của người điều hành. Thỉnh thoảng chúng tôi cũng sẽ liên hệ trực tiếp với bạn nếu cần thông tin thêm về khiếu nại của bạn.</em>
                    </p>
                    <p>
                        <label for="emailaddress">Địa chỉ email</label>
                        <input type="text" name="email" id="emailaddress" value="" class="textbox"/>
                    </p>
                </xsl:otherwise>
              </xsl:choose>
              
                <xsl:if test="(/H2G2/VIEWING-USER/USER/GROUPS/EDITOR) or (/H2G2/VIEWING-USER/USER/STATUS = 2) or (/H2G2/VIEWING-USER/USER/GROUPS/GROUP[NAME='EDITOR'])">
                    <p>
                        <input type="checkbox" value="1" name="hidepost" id="hidePost"/>
                        <label for="hidePost"> Ẩn <xsl:call-template name="item_name"/> ngay lập tức</label>.
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
                    <input type="submit" value="Gửi Phàn nàn" name="Submit" class="button"/>
                </p>
            </div>
            
        </form>
    </xsl:template>
    
    <xsl:template match="USER-COMPLAINT-FORM[ERROR] | ERROR" mode="input_user-complaint-form">
      <div class="content">
        <h2>Thông tin</h2>
        <xsl:choose>
          <xsl:when test="@TYPE = 'EMAILNOTALLOWED'">
            <p>
              Bạn đã bị chặn không được dùng phiếu khiếu nại trên mạng, hãy viết về:<br />
              Broadcast Centre<br />
              201 Wood Lane<br />
              White City<br />
              London<br />
              W12 7TP
            </p>
          </xsl:when>
          <xsl:when test="@TYPE = 'REGISTERCOMPLAINT'">
            <p>
              Không thể đăng ký‎ khiếu nại
            </p>
          </xsl:when>
          <xsl:when test="@TYPE = 'EMAIL'">
            <p>
              Địa chỉ thư điện tử vô giá trị
            </p>
          </xsl:when>
          <xsl:when test="@TYPE = 'NOTFOUND'">
            <p>
              Không tìm thấy thông điệp
            </p>
          </xsl:when>
          <xsl:when test="@TYPE = 'InvalidVerificationCode'">
            <p>
              Mã xác nhập không đúng
            </p>
          </xsl:when>
          <xsl:when test="@TYPE = 'AlreadyModerated'">
            <p>
              Thông điệp này đã được xem và xóa.
            </p>
          </xsl:when>
          <xsl:when test ="@TYPE = 'COMPLAINTTEXT'">
            <p>
              Khiếu nại không có chữ
            </p>
          </xsl:when>
          <xsl:when test ="@TYPE = 'COMPLAINTREASON'">
            <p>
              Khiếu nại không có lý do ‎
            </p>
          </xsl:when>
          <xsl:when test="@TYPE = 'HIDEPOST'">
            <p>
              Không giấu được thông điệp
            </p>
            
          </xsl:when>
          <xsl:when test="@TYPE = 'URL'">
            <p>
              Địa chỉ không tồn tại
            </p>
          </xsl:when>
        </xsl:choose>

      </div>
    </xsl:template>

  <xsl:template match="USERCOMPLAINT[@REQUIRESVERIFICATION = '1']" mode="input_user-complaint-form">
    <div class="content">
      <h2>Xác nhận email</h2>
      <p>
        Khiếu nại của bạn đã được nộp. Người điều hành sẽ không nhận được nếu bạn chưa xác nhận email của mình. Chúng tôi phải làm như vậy để ngăn chặn thư rác và nạn giả danh. 
      </p>
      <p>
        Bạn sẽ nhận một email trong giây lát để kích hoạt khiếu nại của mình. Bấm vào đường dẫn này để gửi khiếu nại của bạn về người điều hành. 
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
          <xsl:text>Tiếp tục lướt web</xsl:text>
        </a>
      </p>
    </div>
  </xsl:template>

  <xsl:template match="USER-COMPLAINT-FORM[MESSAGE/@TYPE = 'SUBMIT-SUCCESSFUL'] | USERCOMPLAINT[@MODID]" mode="input_user-complaint-form">
    <div class="content">
      <h2>Gửi khiếu nại thành công</h2>
      <p>
        Khiếu nại của bạn đã được nhận và chuyển tới nhóm điều hành. Họ sẽ quyết định xem <a href="http://www.bbc.co.uk/vietnamese/institutional/2012/08/120809_bbc_rules.shtml">Quy định nội bộ</a> có bị vi phạm không và sẽ cập nhật vào địa chỉ email của bạn.
      </p>
      <p>
        Số tham khảo trong hệ thống điều hành của bạn là: <strong>
          <xsl:value-of select="(MODERATION-REFERENCE | @MODID)[1]"/>
        </strong>
      </p>
      <xsl:if test="@HIDDEN and @HIDDEN != 0">
        <p>Thêm nữa, mục này đã bị ẩn đi.</p>
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
                    <xsl:text>http://www.bbc.co.uk/vietnamese</xsl:text>
                  </xsl:otherwise>
                </xsl:choose>

              </xsl:with-param>
            </xsl:call-template>
          </xsl:attribute>
          <xsl:text>Tiếp tục lướt web</xsl:text>
        </a>
      </p>
    </div>
  </xsl:template>

 



</xsl:stylesheet>