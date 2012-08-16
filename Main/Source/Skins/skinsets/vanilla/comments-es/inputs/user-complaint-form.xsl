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
            <h2>Quéjese acerca de este <xsl:call-template name="item_name"/></h2>
            <p>Este formulario está destinado solamente a reclamos sobre comentarios que rompan <a href="{$houserulespopupurl}">las reglas</a>.</p>
            <p>Si usted quiere enviar su opinión o alguna pregunta por favor no utilice este formulario. Publique un comentario en la discusión.</p>
            <p>El comentario por el cual se está quejando será enviado a un moderador, quien decidirá si rompe o no.</p>
            <p class="action">
              <xsl:choose>
                <xsl:when test="@POSTID">
                  <a href="?PostId={(POST-ID | @POSTID)[1]}&amp;s_ptrt={/H2G2/PARAMS/PARAM[NAME = 's_ptrt']/VALUE}&amp;s_start=2">Enviar mi queja</a>
                </xsl:when>
                <xsl:when test="@H2G2ID">
                  <a href="?h2g2Id={@H2G2ID}&amp;s_ptrt={/H2G2/PARAMS/PARAM[NAME = 's_ptrt']/VALUE}&amp;s_start=2">Enviar mi queja</a>
                </xsl:when>
                <xsl:otherwise>
                  <a href="?url={@URL}&amp;s_ptrt={/H2G2/PARAMS/PARAM[NAME = 's_ptrt']/VALUE}&amp;s_start=2">Enviar mi queja</a>
                </xsl:otherwise>
              </xsl:choose>
            </p>
        </div>
        <xsl:call-template name="library_userstate">
            <xsl:with-param name="loggedin"></xsl:with-param>
            <xsl:with-param name="unauthorised"></xsl:with-param>
            <xsl:with-param name="loggedout">
                <div class="content">
                    <p>Usted no ha ingresado a ninguna cuenta en este sitio. Si está registrado por favor ingrese. Eso nos ayudará a procesar su reclamo.</p>
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
                          <xsl:text>Ingresar</xsl:text>
                      </a>
                    </p>
                </div>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>

  <xsl:template name="item_name">
    <xsl:choose>
      <xsl:when test="@POSTID">
        <xsl:text>comentario</xsl:text>
      </xsl:when>
      <xsl:when test="@H2G2ID">
        <xsl:text>artículo</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>contenido</xsl:text>
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
                
            	<h2>Alertando a los moderadores</h2>
            	<p>Por favor, selecciones cuál de <a href="{$houserulespopupurl}">las reglas</a> usted cree que este <xsl:call-template name="item_name"/> ha roto. Si considera que rompe más de una regla, por favor seleccione la falta que piense sea más severa.</p>
            </div>
            
            <div class="content">
              <h2>Razón de su reclamo</h2>
              <p>
                IYo considero que este <xsl:call-template name="item_name"/> estaría rompiendo una de <a href="{$houserulespopupurl}">la reglas</a> porque:
              </p>
               
                <p class="options">
                	<p class="options">
                		<input type="radio" id="dnaacs-cq-1" value="es difamatorio" name="s_complaintText"/><label for="dnaacs-cq-1">es difamatorio</label>
                		<input type="radio" id="dnaacs-cq-2" value="es insultante, obsceno, amenazante o atenta contra las creencias, la raza o la preferencia sexual de un grupo de personas." name="s_complaintText"/><label for="dnaacs-cq-2">es insultante, obsceno, amenazante o atenta contra las creencias, la raza o la preferencia sexual de un grupo de personas.</label>
                		<input type="radio" id="dnaacs-cq-3" value="contiene palabras soeces o un lenguaje que puede resultar ofensivo" name="s_complaintText"/><label for="dnaacs-cq-3">contiene palabras soeces o un lenguaje que puede resultar ofensivo</label>
                		<input type="radio" id="dnaacs-cq-4" value="es ilegal o hace apología del delito en actividades tales como infringir el derecho de autor o desacato a un tribunal de Justicia" name="s_complaintText"/><label for="dnaacs-cq-4">es ilegal o hace apología del delito en actividades tales como  <a href="http://www.bbc.co.uk/messageboards/newguide/popup_copyright.html">infringir el derecho de autor</a> o desacato a un tribunal de Justicia</label>
                		<input type="radio" id="dnaacs-cq-5" value="hacer publicidad de productos y servicios para obtener alguna ganancia o beneficio." name="s_complaintText"/><label for="dnaacs-cq-5">hacer publicidad de productos y servicios para obtener alguna ganancia o beneficio.</label>
                		<input type="radio" id="dnaacs-cq-7" value="suplanta la identidad de otra persona" name="s_complaintText"/><label for="dnaacs-cq-7">suplanta la identidad de otra persona</label>
                		<input type="radio" id="dnaacs-cq-8" value="incluye información privada, tal como números telefónicos, dirección postal o de correo electrónico" name="s_complaintText"/><label for="dnaacs-cq-8">incluye información privada, tal como números telefónicos, dirección postal o de correo electrónico</label>
                		<xsl:call-template name="library_userstate">
                      <xsl:with-param name="loggedin">
                        <input type="radio" id="dnaacs-cq-9" value="no guarda relación con el tema en discusión" name="s_complaintText"/><label for="dnaacs-cq-9">no guarda relación con el tema en discusión</label>
                      </xsl:with-param>
                    </xsl:call-template>
                		<input type="radio" id="dnaacs-cq-10" value="no está en español" name="s_complaintText"/><label for="dnaacs-cq-10">no está en español</label>
                		<input type="radio" id="dnaacs-cq-11" value="contiene un vínculo a un sitio externo que romper con nuestra línea editorial" name="s_complaintText"/><label for="dnaacs-cq-11">contiene un vínculo a un sitio externo que romper con nuestra <a href="http://www.bbc.co.uk/messageboards/newguide/popup_editorial_guidelines.html">línea editorial</a></label>
                		<input type="radio" id="dnaacs-cq-12" value="describe o incita a actividades que pueden dañar a terceros" name="s_complaintText"/><label for="dnaacs-cq-12">describe o incita a actividades que pueden dañar a terceros</label>
                		<input type="radio" id="dnaacs-cq-13" value="contiene un nombre de usuario no apropiado" name="s_complaintText"/><label for="dnaacs-cq-13">contiene un nombre de usuario no apropiado</label>
                		<input type="radio" id="dnaacs-cq-14" value="es un correo basura o en serie (spam)" name="s_complaintText"/><label for="dnaacs-cq-14">es un correo basura o en serie (spam)</label>
                		<input type="radio" id="dnaacs-cq-6" value="Otro" name="s_complaintText"/><label for="dnaacs-cq-6">rompe las reglas por un motivo que no está enumerado arriba</label>
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
        alert("Por favor seleccione el motivo de su queja");
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
           	<p>Por favor rellene la caja de abajo para decirnos el motivo por el cual usted piensa que este <xsl:call-template name="item_name"/> rompe las reglas. Cuando termine, haga clic en "Enviar su queja" para que pueda ser revisada por uno de los moderadores.</p>
               <p>
                  <xsl:if test="/H2G2/PARAMS/PARAM[NAME = 's_complaintText']/VALUE and /H2G2/PARAMS/PARAM[NAME = 's_complaintText']/VALUE = 'Otro'">
                    Deseo quejarme acerca de este <xsl:call-template name="item_name"/> por la siguiente razón:
                  </xsl:if>
                   
               </p>
                <p class="options">
                    <textarea id="reason" rows="10" cols="40" name="complainttext" class="textarea">
                    	<!-- <xsl:if test="/H2G2/PARAMS/PARAM[NAME = 's_complaintText']/VALUE and /H2G2/PARAMS/PARAM[NAME = 's_complaintText']/VALUE != 'Otro'">
                        <xsl:text>Creo que este </xsl:text><xsl:call-template name="item_name"/>
                        <xsl:text xml:space="preserve"> </xsl:text>
                        <xsl:apply-templates select="/H2G2/PARAMS/PARAM[NAME = 's_complaintText']/VALUE" mode="library_string_stringtolower"/><xsl:text> por la siguiente razón:</xsl:text>
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
                    <h3>Su dirección de correo electrónico</h3>
                    <p>
                      <em>Necesitamos su dirección de correo electrónico para procesar su queja y para informarle de la decisión de nuestros moderadores. Ocasionalmente, puede que lo contactemos si necesitamos más información acerca del motivo de esta queja.</em>
                    </p>
                    <p>
                        <label for="emailaddress">Dirección de correo electrónico:</label>
                        <input type="text" name="email" id="emailaddress" value="" class="textbox"/>
                    </p>
                </xsl:otherwise>
              </xsl:choose>
              
                <xsl:if test="(/H2G2/VIEWING-USER/USER/GROUPS/EDITOR) or (/H2G2/VIEWING-USER/USER/STATUS = 2) or (/H2G2/VIEWING-USER/USER/GROUPS/GROUP[NAME='EDITOR'])">
                    <p>
                        <input type="checkbox" value="1" name="hidepost" id="hidePost"/>
                        <label for="hidePost"> Esconder <xsl:call-template name="item_name"/> instantáneamente</label>.
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
                    <input type="hidden" name="action" value="Enviar"/>
                    <input type="submit" value="Enviar su queja" name="Submit" class="button"/>
                </p>
            </div>
            
        </form>
    </xsl:template>
    
    <xsl:template match="USER-COMPLAINT-FORM[ERROR] | ERROR" mode="input_user-complaint-form">
      <div class="content">
        <h2>Información</h2>
        <xsl:choose>
          <xsl:when test="@TYPE = 'EMAILNOTALLOWED'">
            <p>
              Usted ha sido bloqueado de usar el sistema de quejas, por favor escriba a:<br />
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
      <h2>Verificación de correo electrónico</h2>
      <p>
        Su queja ha sido enviada. No será revisada por nuestros moderadores hasta que usted haya verificado su dirección de correo electrónico. Esto servirá para evitar que se produzca una suplantación de identidad o el envío de correo no deseado.
      </p>
      <p>
        Usted recibirá en breve un correo electrónico con un vínculo para activar esta queja. Al hacer clic en el vínculo su queja será enviada a los moderadores.
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
          <xsl:text>Siga navegando</xsl:text>
        </a>
      </p>
    </div>
  </xsl:template>

  <xsl:template match="USER-COMPLAINT-FORM[MESSAGE/@TYPE = 'SUBMIT-SUCCESSFUL'] | USERCOMPLAINT[@MODID]" mode="input_user-complaint-form">
    <div class="content">
      <h2>Queja exitosa</h2>
      <p>
        Su queja ha sido recibida con éxito y enviada al equipo de moderadores. Ellos decidirán si <a href="{$houserulespopupurl}">las reglas</a> han sido rotas y le enviarán una actualización a través de su correo electrónico.
      </p>
      <p>
        Su referencia es: <strong>
          <xsl:value-of select="(MODERATION-REFERENCE | @MODID)[1]"/>
        </strong>
      </p>
      <xsl:if test="@HIDDEN and @HIDDEN != 0">
        <p>Adicionalmente, el mensaje ha sido escondido.</p>
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
                    <xsl:text>http://www.bbc.co.uk/mundo</xsl:text>
                  </xsl:otherwise>
                </xsl:choose>

              </xsl:with-param>
            </xsl:call-template>
          </xsl:attribute>
          <xsl:text>Siga navegando</xsl:text>
        </a>
      </p>
    </div>
  </xsl:template>

 



</xsl:stylesheet>