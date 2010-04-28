<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:doc="http://www.bbc.co.uk/dna/documentation"  exclude-result-prefixes="doc">
    
    <doc:documentation>
        <doc:purpose>
            Transforms a collection of posts to HTML 
        </doc:purpose>
        <doc:context>
            Used by a MULTIPOSTS page
        </doc:context>
        <doc:notes>
            
        </doc:notes>
    </doc:documentation>
    
    

    <xsl:template match="INSPECT-USER-FORM" mode="input_inspect-user-form">
        <form action="{$root}/InspectUser" method="post" class="dna-boards">
            <div>
                <xsl:call-template name="library_header_h3">
                    <xsl:with-param name="text">Inspect User</xsl:with-param>
                </xsl:call-template>
                
                <xsl:call-template name="library_header_h4">
                    <xsl:with-param name="text">
                        <xsl:value-of select="concat('Inspecting ', USER/USERID, ' ', USER/USERNAME)" />
                    </xsl:with-param>
                </xsl:call-template>
                
                <fieldset>
                    <legend>Inspect User</legend>
                    <p>
                        <label for="">Find user id</label>
                        <input type="text" name="FetchUserID" value="{USER/USERID}" class="text" />
                    </p>
                    <p>
                        <!--<input type="hidden" name="skin" value="purexml"/>-->
                        <input type="submit" name="FetchUser" class="submit" value="Inspect User" />
                    </p>
                </fieldset>
                
                <fieldset>
                    <legend>Update User Details</legend>
                    <p>
                        <label for="UserName">Username</label>
                        <input type="text" id="UserName" name="UserName" value="{USER/USERNAME}" class="text" />
                    </p>
                    <p>
                        <label for="EmailAddress">Email address</label>
                        <input type="text" id="EmailAddress" name="EmailAddress" value="{USER/EMAIL-ADDRESS}" class="text" />
                    </p>
                    <p>
                        <label for="LoginName">Login name</label>
                        <input type="text" id="LoginName" name="LoginName" value="{USER/LOGIN-NAME}" class="text" />
                    </p>
                    <p>
                        <label for="FirstNames">First names</label>
                        <input type="text" id="FirstNames" name="FirstNames" value="{USER/FIRST-NAMES}" class="text" />
                    </p>
                    <p>
                        <label for="LastName">Last name</label>
                        <input type="text" id="LastName" name="LastName" value="{USER/LAST-NAME}" class="text" />
                    </p>
                    <p>
                        <label for="Status">Status</label>
                        <xsl:choose>
                            <xsl:when test="/H2G2/VIEWING-USER/USER/STATUS = 2">
                                <select name="Status">
                                    <option value="1">
                                        <xsl:if test="USER/STATUS = 1">
                                            <xsl:attribute name="selected">selected</xsl:attribute>
                                        </xsl:if>
                                        <xsl:text>User</xsl:text>
                                    </option>
                                    <option value="2">
                                        <xsl:if test="USER/STATUS = 2">
                                            <xsl:attribute name="selected">selected</xsl:attribute>
                                        </xsl:if>
                                        <xsl:text>Editor</xsl:text>
                                    </option>
                                </select>
                            </xsl:when>
                            <xsl:otherwise>
                                <input type="hidden" name="Status" value="{USER/STATUS}"/>
                                <span>
                                    <xsl:choose>
                                        <xsl:when test="USER/STATUS = 1">User</xsl:when>
                                        <xsl:when test="USER/STATUS = 2">Super-User</xsl:when>
                                    </xsl:choose>
                                </span>
                            </xsl:otherwise>
                        </xsl:choose>
                    </p>
                    <p>
                        <input type="hidden" name="UserID" value="{USER/USERID}"/>
                        <input type="submit" name="UpdateDetails" id="dna-boards-submit-updatedetails" value="Update Details" class="submit" />
                    </p>
                    
                </fieldset>
                
                <fieldset>
                    <legend>Update Groups</legend>
                    
                    <xsl:apply-templates select="GROUPS-LIST" mode="object_groups-list" />  
                    
                    <p>
                        <input type="submit" name="UpdateGroups" id="dna-boards-submit-updategroups" value="Update Groups" class="submit" />
                    </p>
                    
                </fieldset>
                
                <fieldset>
                    <legend>Create a new Group</legend>
                    
                    <p>
                        <label for="GroupName">Group name</label>
                        <input type="text" id="GroupName" name="NewGroupName" value="" class="text" />
                    </p>
                    <p>
                        <input type="submit" name="CreateUserGroups" id="dna-boards-submit-createusergroup" value="Create New Group" class="submit" />
                    </p>
                    
                </fieldset>
                
                
                
                
                
                
            </div>
        </form>
    </xsl:template>

</xsl:stylesheet>