<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">


    <doc:documentation>
        <doc:purpose>
            Page layout for a catergory page
        </doc:purpose>
        <doc:context>
            Applied by the kick off file  (e.g. /html.xsl, /rss.xsl etc)
        </doc:context>
        <doc:notes>
            
        </doc:notes>
    </doc:documentation>
    
    
    
    <xsl:template match="/H2G2[@TYPE = 'UITEMPLATEDEFINITION']" mode="page">
        
        <xsl:apply-templates select="ERROR" mode="object_error" />
        
        <div class="column wide">
            
            <form action="UITDT" method="post" id="thebuilder">
                
                <input type="hidden" name="uitemplateid" value="0"></input>
                <input type="hidden" name="builderguid" value="00000000-0000-0000-0000-000000000000"></input>
                <input type="hidden" name="action" value="create"></input>
                
                <div class="templatedetails">
                    <p>
                        <label>Template Name</label>
                        <input type="text"></input>
                    </p>
                    <p>
                        <label>Create this new template</label>
                        <input type="submit" value="Create Template"></input>
                    </p>
                </div>
                
                
            </form>
           
                    <div id="infoPanel">
                        
                        <input type="hidden" name="uifieldid" value="0"></input>
                        <div class="col right">
                        
                            <p>
                                <label>Name</label>
                                <input type="text" name="name" id="infoPanelName"/>
                                <span class="description">Name of the field</span>
                            </p>
                            
                            <p>
                                <label>Label</label>
                                <input type="text" name="label"/>
                                <span class="description">Label to display for the field</span>
                            </p>
                            
                            <p>
                                <label>Type</label>
                                <input type="text" name="type"/>
                                <span class="description">Type of the field, a string for the beginning</span>
                            </p>
                            
                            <p>
                            <label>Description</label>
                            <textarea name="description"></textarea>
                            <span class="description">Description for the field</span>
                            </p>
                        
                        
                            <p>
                            <input type="checkbox" name="iskeyphrase"/>
                            <label>IsKeyPhrase</label>
                            <span class="description">Whether this field is a KeyPhrase</span>
                            </p>
                            
                            <p>
                            <label>KeyPhraseNamespace</label>
                            <input type="text" name="keyphrasenamespace "/>
                            <span class="description">The Namesspace for the field if it is a keyphrase</span>
                            </p>
                            
                            <p>
                            <input type="checkbox" name="required"/>
                            <label>Required</label>
                            <span class="description">Whether the field is required by the builder in question Read Only set by the builder</span>
                            </p>
                            
                            <p>
                            <label>DefaultValue</label>
                            <input type="text" name="defaultvalue"/>
                            <span class="description">The Default Value of the field</span>
                            </p>
                            
                        </div>
                        <div class="col left">
                            <p>
                            <input type="checkbox" name="escape"/>
                            <label>Escape</label>
                            <span class="description">Whether the field needs to be escaped</span>
                            </p>
                            
                            <p>
                            <input type="checkbox" name="rawinput"/>
                            <label>RawInput</label>
                            <span class="description">Whether the input needs to be captured 'raw'</span>
                            </p>
                            
                            <p>
                            <input type="checkbox" name="includeinguideentry"/>
                            <label>IncludeInGuideEntry</label>
                            <span class="description">Whether we need to include this field in the GuideEntry</span>
                            </p>
                            
                            <p>
                            <input type="checkbox" name="validateempty"/>
                            <label>ValidateEmpty</label>
                            <span class="description">Whether the field in question is validated as not being empty</span>
                            </p>
                            
                            <p>
                            <input type="checkbox" name="validatenotequalto"/>
                            <label>ValidateNotEqualTo</label>
                            <span class="description">Whether the field in question is validated as not being equal to a value</span>
                            </p>
                            
                            <p>
                            <label>NotEqualToValue</label>
                            <input type="text" name="validatenotequalto"/>
                            <span class="description">The value that the field in question is validated as not being equal to</span>
                            </p>
                            
                            
                            <p>
                            <input type="checkbox" name="validateparsesok"/>
                            <label>ValidateParsesOK</label>
                            <span class="description">Whether the field in question is validated as parsing ok</span>
                            </p>
                            
                            <p>
                            <input type="checkbox" name="validatecustom"/>
                            <label>ValidateCustom</label>
                            <span class="description">Whether the field in question is validated in a custom builder specific way not user selectable</span>
                            </p>
                            
                            <p>
                            <label>Step</label>
                            <input type="text" name="step" value="1"/>
                            <span class="description">The entry Step number the field is in</span>
                            </p>
                            
                        </div>
                    </div>
            
        </div>
    </xsl:template>
    
    
    <xsl:template match="/H2G2[@TYPE = 'UITEMPLATEDEFINITION' and /H2G2/ERROR[@TYPE = 'ReadTemplateData']]" mode="page">
        
        <div class="column wide">
            
            <form action="" method="get">
                <p>Please select a builder</p>
                
                <xsl:apply-templates select="UISUPPORTEDBUILDERS" mode="object_uisupportedbuilders" />
                
                
            </form>
        </div>
    </xsl:template>
    
    <xsl:template match="UISUPPORTEDBUILDERS" mode="object_uisupportedbuilders">
        <select name="uitemplateid">
            <xsl:apply-templates select="BUILDER" mode="object_builder" />
        </select>
    </xsl:template>
    
    <xsl:template match="BUILDER" mode="object_builder">
        <option></option>
    </xsl:template>
    
    <xsl:template match="/H2G2[@TYPE = 'UITEMPLATEDEFINITION']" mode="head_additional">
            
            <style type="text/css">
                
                body {padding:0; margin:0;}
                h1 {margin:0 0 8px 0; background:#eee; font: 2em "Trebuchet Ms"; color: #ccc; font-weight:bold; padding:0 0 0 20px}
                
                
                span.description { display:block;  font-size: 0.8em; color:#888; font-style:italic }
                label { padding:0 6px 0 0; }
                
                .col {float:left;width:320px;padding:0 10px 0 10px}
                
                .right {text-align:right; }
                .left span {text-align:right; padding:0 20px 0 0}
                
                .left { border-left:3px solid #eee; }
                .right { }
                
                #fieldEmpty {display:none;}
                
                
                form {float:left; width:550px; margin:0 0 0 15px}
                #infoPanel {float:left}
                
                hr {clear:both;}
                
                .field {float:left; width:150px; background:#888; color:#fff; margin:4px; padding:2px; border:2px solid #ddd; text-align:center;}
                .field em {color:#bbb}
                
                
                div.selected { border: 2px solid #888; background:#ddd; color:#000}
                fieldset.selected { background:#eee;}
                
            </style>
        
        <script type="text/javascript" src="//www.bbc.co.uk/glow/0.2.0/dist/glow/glow.js"></script>
        <script type="text/javascript" src="//www.bbc.co.uk/glow/0.2.0/dist/effects/effects.js"></script>
        <script type="text/javascript" src="//www.bbc.co.uk/glow/0.2.0/dist/widgets/widgets.js"></script>
        
        <script type="text/javascript">
            <![CDATA[
            
            ]]>
            
            <xsl:text>var required = [</xsl:text>
            <xsl:apply-templates select="UITEMPLATEDEFINITION/UISUPPORTEDBUILDERS/BUILDER/UIFIELDS" mode="object_uifields_json"/>
            <xsl:text>];</xsl:text>
        </script>
        
        <script type="text/javascript">
            <![CDATA[
            
            
            var fieldObject = function(step, id, el) {
                //constructor
                
                
                //set the step it belongs to
                this.step = step;
                
                this.el = el;
                
                //I was convinced prototypes wern't working but they are...
                //  used a unique id to check
                this.id = id;
                
                this.properties = {
                    id: this.id
                };
                
            }
            fieldObject.prototype = {
                
                step: false,
                
                set: function (name, value) {
                  //  console.log('setting ' + name + ' to ' + value);
                    this.properties[name] = value;
                },
                
                get: function (name) {
                // console.log('getting ' + name + ' [' + this.properties[name] + ']');
                    if (this.properties[name]) {
                        return this.properties[name];
                    } else {
                        return '';
                    }
                }
            };
            
            
            var dna = function() {
               var g = glow;
               var $ = g.dom.get;
               var bind = g.events.addListener;
            
                var stepTemplate = '<fieldset><legend>Step {number}</legend><span class="panel"><a href="#">Remove Step</a> <a href="#" class="addField">Add a field</a></span></fieldset>';
                var fieldTemplate = '<div class="field"><em>empty</em></div>';
                
                var formElement = false;
                var infoPanelElement = false;
                
                //holder for the fields in play
                fieldBank = [];
                
                
                return {
                    step: {
                        add: function() {
                            
                            var data = {
                                number: formElement.get('fieldset').length + 1
                            }
                            
                            var newStep = g.dom.create(g.lang.interpolate(stepTemplate, data)).appendTo(formElement);
                            
                            bind(newStep.get('a.addField'), 'click', function() {
                                
                                dna.field.add($(this).parent().parent());
                                
                                return false;
                            });
                        }
                    },
                    
                    field: {
                        add: function(nodeList) {
                            
                            var data = {
                                //none at the moment
                            }
                            
                            var newField = g.dom.create(g.lang.interpolate(fieldTemplate, data)).appendTo(nodeList);
                            
                            newField[0].fieldObject = new fieldObject(nodeList.get('legend').html(), Math.round(Math.random() * 1000), newField);
                            
                            bind(newField[0], 'click', function() {
                                dna.field.select(newField);
                            });
                            
                            dna.field.select(newField);
                        },
                        
                        select: function(nodeList) {
                                //set the info panel to el fieldObject
                                dna.infoPanel.useFieldObject(nodeList[0].fieldObject);
                                
                                //var nodeList = $(el);
                                
                                nodeList.parent().parent().get('fieldset').removeClass('selected');
                                nodeList.parent().addClass('selected');
                                
                                nodeList.parent().parent().get('.field').removeClass('selected');
                                nodeList.addClass('selected');
                                
                                nodeList[0].blur();
                        },
                        
                        updateName: function(str) {
                            formElement.get('div.selected')[0].innerHTML = str;  
                        }
                    },
                    
                    set: {
                        formElement: function(str) {
                            formElement = $(str);
                        },
                        infoPanelElement: function(str) {
                            infoPanelElement = $(str);
                        }
                    },
                    
                    infoPanel: {
                        populate: function(fieldObject) {
                            //take the field object and populate all the value in the panel
                            // (use the keys to populate by input@name
                            
                            infoPanelElement.get('input').each(function(i) {
                                this.value = fieldObject.get(this.name);
                            });
                        },
                        
                        updateFieldObject: function(fieldObject) {
                        
                            if (fieldObject) {
                                infoPanelElement.get('input').each(function(i) {
                                    fieldObject.set(this.name, this.value);
                                });
                            }
                        
                        },
                        
                        addEvents: function() {
                            infoPanelElement.get('input').each(function(i) {
                                bind(this, 'change', function() {
                                  //  console.log(this.checked || this.value);
                                    
                                });
                            });
                            
                            bind('#infoPanelName', 'change', function () {
                                dna.field.updateName(this.value);
                            });
                        },
                        
                        useFieldObject: function(newFieldObject) {
                                        //console.log(infoPanelElement[0].currentFieldObject);
                                        //console.log(newFieldObject);
                            
                            if (infoPanelElement[0].currentFieldObject) {
                                //save changes to currnt one
                                dna.infoPanel.updateFieldObject(infoPanelElement[0].currentFieldObject);
                            }
                            
                            //switch to the new fieldObject
                            infoPanelElement[0].currentFieldObject = newFieldObject;
                                                        
                            //Populate with new data
                            dna.infoPanel.populate(newFieldObject);
                        }
                    }
                }
            }();
            
                glow.ready(function() {
                /*
                   
                   g.dom.create('<p><a href="#" id="addField">Add a new field</a></p>').appendTo('form div.templatedetails');
                   
                   
                   var l = bind('#addField', 'click', function() {
                       $('#fieldEmpty').clone().attr({'id': '', 'class': 'field'}).appendTo('fieldset');
                       
                       return false;
                   });
                   
                  */
                   var g = glow;
                   var $ = g.dom.get;
                   var bind = g.events.addListener;
                  
                  dna.set.formElement("#thebuilder");
                  dna.set.infoPanelElement("#infoPanel");
                  
                  dna.infoPanel.addEvents();
                  
                  g.dom.create('<div><p><a href="#" id="addStep">Add a new step</a></p></div>').appendTo('form div.templatedetails');
                  
                  bind('#addStep', 'click', function() {
                      dna.step.add();
                      
                      return false;
                  });
                  
                  //g.dom.create('<div><p><a href="#" id="addField">Add a new step</a></p></div>').appendTo('form');
                  
                  console.log(required);
                  
                });
            
            ]]>
        </script>
        
        
    </xsl:template>
    
    <xsl:template match="UIFIELDS" mode="object_uifields_json">
        <xsl:apply-templates select="UIFIELD" mode="object_uifield_json" />
    </xsl:template>
    
    <xsl:template match="UIFIELD" mode="object_uifield_json">
        <xsl:text>{</xsl:text>
        <xsl:text>name: '</xsl:text><xsl:value-of select="NAME"/><xsl:text>',</xsl:text>
        <xsl:text>label: '</xsl:text><xsl:value-of select="LABEL"/><xsl:text>',</xsl:text>
        <xsl:text>description: '</xsl:text><xsl:value-of select="DESCRIPTION"/><xsl:text>'</xsl:text>
        <xsl:text>}</xsl:text>
        <xsl:if test="position() != last()">
            <xsl:text>,</xsl:text>
        </xsl:if>
    </xsl:template>
    

</xsl:stylesheet>