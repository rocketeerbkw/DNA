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
            <h2>Reclame sobre um <xsl:call-template name="item_name"/></h2>
            <p>Este formulário deve ser usado apenas nos casos de reclamações sérias sobre um comentário específico que viole as <a href="{$houserulespopupurl}">Regras</a>.</p>
            <p>Se você tiver alguma dúvida ou um comentário geral a fazer, não use esse formulário. Publique uma mensagem na seção de comentários.</p>
            <p>A mensagem sobre a qual você postou uma reclamação será enviada a um moderador, que decidirá se houve violação das <a href="{$houserulespopupurl}">Regras</a>. A decisão será informada a você por e-mail.</p>
            <p class="action">
              <xsl:choose>
                <xsl:when test="@POSTID">
                  <a href="?PostId={(POST-ID | @POSTID)[1]}&amp;s_ptrt={/H2G2/PARAMS/PARAM[NAME = 's_ptrt']/VALUE}&amp;s_start=2">Registre minha reclamação</a>
                </xsl:when>
                <xsl:when test="@H2G2ID">
                  <a href="?h2g2Id={@H2G2ID}&amp;s_ptrt={/H2G2/PARAMS/PARAM[NAME = 's_ptrt']/VALUE}&amp;s_start=2">Registre minha reclamação</a>
                </xsl:when>
                <xsl:otherwise>
                  <a href="?url={@URL}&amp;s_ptrt={/H2G2/PARAMS/PARAM[NAME = 's_ptrt']/VALUE}&amp;s_start=2">Registre minha reclamação</a>
                </xsl:otherwise>
              </xsl:choose>
            </p>
        </div>
        <xsl:call-template name="library_userstate">
            <xsl:with-param name="loggedin"></xsl:with-param>
            <xsl:with-param name="unauthorised"></xsl:with-param>
            <xsl:with-param name="loggedout">
                <div class="content">
                    <p>Você não está associado a uma conta neste website. Se você tiver uma conta, use-a, pois isto facilitará o processamento de sua reclamação.</p>
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
                          <xsl:text>Registre-se</xsl:text>
                      </a>
                    </p>
                </div>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>

  <xsl:template name="item_name">
    <xsl:choose>
      <xsl:when test="@POSTID">
        <xsl:text>comentário</xsl:text>
      </xsl:when>
      <xsl:when test="@H2G2ID">
        <xsl:text>artigo</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>conteúdo</xsl:text>
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
                
            	<h2>Alertando aos moderadores</h2>
            	<p>Por favor, selecione qual das <a href="{$houserulespopupurl}">Regras</a> você acha <xsl:call-template name="item_name"/> que foi violada. Se você acha que mais de uma regra foi violada, por favor, escolha a que considera mais grave.</p>
            </div>
            
            <div class="content">
              <h2>Razão para a sua reclamação</h2>
              <p>
                Eu acho que este <xsl:call-template name="item_name"/> viola uma das <a href="{$houserulespopupurl}">Regras</a> porque:
              </p>
               
                <p class="options">
                	<p class="options">
                		<input type="radio" id="dnaacs-cq-1" value="é difamatório ou calunioso" name="s_complaintText"/><label for="dnaacs-cq-1">é difamatório ou calunioso</label>
                		<input type="radio" id="dnaacs-cq-2" value="é racista, sexista, homofóbico, sexualmente explícito, abusivo ou de alguma forma ofensivo" name="s_complaintText"/><label for="dnaacs-cq-2">é racista, sexista, homofóbico, sexualmente explícito, abusivo ou de alguma forma ofensivo</label>
                		<input type="radio" id="dnaacs-cq-3" value="contém xingamentos ou outras palavras que podem ser consideradas ofensivas" name="s_complaintText"/><label for="dnaacs-cq-3">contém xingamentos ou outras palavras que podem ser consideradas ofensivas</label>
                		<input type="radio" id="dnaacs-cq-4" value="viola a lei ou incentiva ou estimula o delito criminal tal como violação de direitos autorais ou desacato a um tribunal" name="s_complaintText"/><label for="dnaacs-cq-4">viola a lei ou incentiva ou estimula o delito criminal tal como violação de <a href="http://www.bbc.co.uk/messageboards/newguide/popup_copyright.html">direitos autorais</a> ou desacato a um tribunal</label>
                		<input type="radio" id="dnaacs-cq-5" value="faz publicidade de produtos ou serviços com fins comerciais ou lucrativos" name="s_complaintText"/><label for="dnaacs-cq-5">faz publicidade de produtos ou serviços com fins comerciais ou lucrativos</label>
                		<input type="radio" id="dnaacs-cq-7" value="o comentarista está fingindo ser outra pessoa" name="s_complaintText"/><label for="dnaacs-cq-7">o comentarista está fingindo ser outra pessoa</label>
                		<input type="radio" id="dnaacs-cq-8" value="inclui informações pessoais como números de telefones, endereço postal ou de e-mail" name="s_complaintText"/><label for="dnaacs-cq-8">inclui informações pessoais como números de telefones, endereço postal ou de e-mail</label>
                		<xsl:call-template name="library_userstate">
                      <xsl:with-param name="loggedin">
                        <input type="radio" id="dnaacs-cq-9" value="não tem relação com o tema em debate" name="s_complaintText"/><label for="dnaacs-cq-9">não tem relação com o tema em debate</label>
                      </xsl:with-param>
                    </xsl:call-template>
                		<input type="radio" id="dnaacs-cq-10" value="não está escrito em português" name="s_complaintText"/><label for="dnaacs-cq-10">não está escrito em português</label>
                		<input type="radio" id="dnaacs-cq-11" value="contém um link externo para um site que viola nossos Princípios Editoriais" name="s_complaintText"/><label for="dnaacs-cq-11">contém um link externo para um site que viola nossos <a href="http://www.bbc.co.uk/messageboards/newguide/popup_editorial_guidelines.html">Princípios Editoriais</a></label>
                		<input type="radio" id="dnaacs-cq-12" value="descreve ou incentiva atividades que podem pôr em risco a segurança ou o bem-estar de outros" name="s_complaintText"/><label for="dnaacs-cq-12">descreve ou incentiva atividades que podem pôr em risco a segurança ou o bem-estar de outros</label>
                		<input type="radio" id="dnaacs-cq-13" value="contém um nome de usuário inadequado" name="s_complaintText"/><label for="dnaacs-cq-13">contém um nome de usuário inadequado</label>
                		<input type="radio" id="dnaacs-cq-14" value="é um spam" name="s_complaintText"/><label for="dnaacs-cq-14">é um spam</label>
                		<input type="radio" id="dnaacs-cq-6" value="Outra" name="s_complaintText"/><label for="dnaacs-cq-6">viola a regra por uma razão não relacionada acima</label>
                	</p>
                </p>

              <p class="action">
                <input type="submit" value="Próxima página"/>
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
        alert("Selecione a categoria da sua reclamação");
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
           	<p>Por favor, preencha os campos abaixo com o motivo pelo qual, na sua opinião, <xsl:call-template name="item_name"/> esta regra foi violada. Quando tiver terminado, clique em Enviar reclamação para que sua reclamação seja analisada por um moderador.</p>
               <p>
                  <xsl:if test="/H2G2/PARAMS/PARAM[NAME = 's_complaintText']/VALUE and /H2G2/PARAMS/PARAM[NAME = 's_complaintText']/VALUE = 'Outra'">
                    Gostaria de reclamar deste <xsl:call-template name="item_name"/> pelo seguinte motivo:
                  </xsl:if>
                   
               </p>
                <p class="options">
                    <textarea id="reason" rows="10" cols="40" name="complainttext" class="textarea">
                    	<!-- <xsl:if test="/H2G2/PARAMS/PARAM[NAME = 's_complaintText']/VALUE and /H2G2/PARAMS/PARAM[NAME = 's_complaintText']/VALUE != 'Outra'">
                        <xsl:text>Acredito que </xsl:text><xsl:call-template name="item_name"/>
                        <xsl:text xml:space="preserve"> </xsl:text>
                        <xsl:apply-templates select="/H2G2/PARAMS/PARAM[NAME = 's_complaintText']/VALUE" mode="library_string_stringtolower"/><xsl:text> pelo seguinte motivo:</xsl:text>
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
                    <h3>Seu endereço de e-mail</h3>
                    <p>
                      <em>Precisamos de seu endereço de e-mail para processar sua reclamação e informá-lo da decisão do moderador. Pode ser que precisemos contatá-lo diretamente caso necessitemos maiores informações sobre sua reclamação.</em>
                    </p>
                    <p>
                        <label for="emailaddress">endeço de e-mail</label>
                        <input type="text" name="email" id="emailaddress" value="" class="textbox"/>
                    </p>
                </xsl:otherwise>
              </xsl:choose>
              
                <xsl:if test="(/H2G2/VIEWING-USER/USER/GROUPS/EDITOR) or (/H2G2/VIEWING-USER/USER/STATUS = 2) or (/H2G2/VIEWING-USER/USER/GROUPS/GROUP[NAME='EDITOR'])">
                    <p>
                        <input type="checkbox" value="1" name="hidepost" id="hidePost"/>
                        <label for="hidePost"> Esconder <xsl:call-template name="item_name"/> instantaneamente</label>.
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
                    <input type="submit" value="Enviar reclamação" name="Submit" class="button"/>
                </p>
            </div>
            
        </form>
    </xsl:template>
    
    <xsl:template match="USER-COMPLAINT-FORM[ERROR] | ERROR" mode="input_user-complaint-form">
      <div class="content">
        <h2>Informação</h2>
        <xsl:choose>
          <xsl:when test="@TYPE = 'EMAILNOTALLOWED'">
            <p>
              Você foi bloqueado e não poderá usar o sistema de reclamações, por favor, escreva para:<br />
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
      <h2>Confirmação de endereço de e-amil</h2>
      <p>
		Sua reclamação foi enviada. Ela não será analisada por um moderador até que você confirme seu endereço de e-mail. Isto é feito para evitar spam ou uso falso de identidade alheia.      </p>
      <p>
        ^Você receberá m e-mail em breve com um link para que possa ativar sua reclamação. Clique neste link para enviar sua reclamação aos moderadores.
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
          <xsl:text>Continue navegando</xsl:text>
        </a>
      </p>
    </div>
  </xsl:template>

  <xsl:template match="USER-COMPLAINT-FORM[MESSAGE/@TYPE = 'SUBMIT-SUCCESSFUL'] | USERCOMPLAINT[@MODID]" mode="input_user-complaint-form">
    <div class="content">
      <h2>Siga navegando</h2>
      <p>
        Sua reclamação foi recebida e enviada à equipe de moderadores. Um moderador decidirá se alguma das <a href="{$houserulespopupurl}">Regras</a> foi violada e irá informá-lo por e-mail.
      </p>
      <p>
        Seu ID de Referência de Moderação é: <strong>
          <xsl:value-of select="(MODERATION-REFERENCE | @MODID)[1]"/>
        </strong>
      </p>
      <xsl:if test="@HIDDEN and @HIDDEN != 0">
        <p>Adicionalmente, este post foi escondido.</p>
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
                    <xsl:text>http://www.bbc.co.uk/brasil</xsl:text>
                  </xsl:otherwise>
                </xsl:choose>

              </xsl:with-param>
            </xsl:call-template>
          </xsl:attribute>
          <xsl:text>Continue navegando</xsl:text>
        </a>
      </p>
    </div>
  </xsl:template>

 



</xsl:stylesheet>