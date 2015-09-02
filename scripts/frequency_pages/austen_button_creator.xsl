<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0">
    <xsl:output indent="yes" omit-xml-declaration="yes"/>
    
    <xsl:variable name="title_slug">
        
        <xsl:value-of select="translate(lower-case(/TEI/teiHeader/fileDesc/titleStmt/title[@type='main']),' ','_')"></xsl:value-of>
        
    </xsl:variable>
    
    
    <!-- First, I am generating a definition list of all the characters and traits that I can more easily format -->
    <xsl:variable name="generated_definition_lists">
        <div>
        <h2>
            <xsl:value-of select="//title[@type='main']"/>
        </h2>
        
        <dl>
            <dt>
                <xsl:attribute name="id">characters</xsl:attribute>
                <xsl:text>Characters</xsl:text></dt>
            
            <xsl:for-each select="//person[@role='main']">
                <dd>
                    <xsl:attribute name="id">
                        <xsl:value-of select="@xml:id"/>
                    </xsl:attribute>
                    <xsl:value-of select="normalize-space(persName)"/>
                </dd>
            </xsl:for-each> 
        </dl>
        
        <xsl:call-template name="trait_generator">
            <xsl:with-param name="trait_type">main</xsl:with-param>
            <xsl:with-param name="trait_title">Character Type</xsl:with-param>
            <xsl:with-param name="trait_selector">trait</xsl:with-param>
        </xsl:call-template>
        <xsl:call-template name="trait_generator">
            <xsl:with-param name="trait_type">main</xsl:with-param>
            <xsl:with-param name="trait_title">Sex</xsl:with-param>
            <xsl:with-param name="trait_selector">sex</xsl:with-param>
        </xsl:call-template>
        <xsl:call-template name="trait_generator">
            <xsl:with-param name="trait_type">main</xsl:with-param>
            <xsl:with-param name="trait_title">Marriage Status</xsl:with-param>
            <xsl:with-param name="trait_selector">state</xsl:with-param>
        </xsl:call-template>
        <xsl:call-template name="trait_generator">
            <xsl:with-param name="trait_type">main</xsl:with-param>
            <xsl:with-param name="trait_title">Class status</xsl:with-param>
            <xsl:with-param name="trait_selector">socecStatus</xsl:with-param>
        </xsl:call-template>
        <xsl:call-template name="trait_generator">
            <xsl:with-param name="trait_type">main</xsl:with-param>
            <xsl:with-param name="trait_title">Age</xsl:with-param>
            <xsl:with-param name="trait_selector">age</xsl:with-param>
        </xsl:call-template>
        <xsl:call-template name="trait_generator">
            <xsl:with-param name="trait_type">main</xsl:with-param>
            <xsl:with-param name="trait_title">Occupation</xsl:with-param>
            <xsl:with-param name="trait_selector">occupation</xsl:with-param>
        </xsl:call-template>
        
        
        <!-- Listing all the traits by novel by person -->
        
        <!--  <xsl:for-each select="$files">-->
        
        <dl>
            <dt>
                <xsl:attribute name="id">indirect_diction</xsl:attribute>
                <xsl:text>Indirect Diction</xsl:text>
            </dt>
            <xsl:for-each select="//person[@role='main_nar'] | //person[@role='asanother' and @corresp] | //person[@role='asanother_nar' and @corresp]">
                <dd>
                    <xsl:attribute name="id">
                        <xsl:value-of select="@xml:id"/>
                    </xsl:attribute>
                    <xsl:value-of select="normalize-space(persName)"/>
                </dd>
            </xsl:for-each>
        </dl>
        </div>
    </xsl:variable>


<!-- here, I will format the HTML I generated above -->
    <xsl:template match="/">
        
        
        
        
        
        
        
        <div class="panel-group" id="accordion" role="tablist" aria-multiselectable="true">
           

        
        <xsl:for-each select="$generated_definition_lists" xpath-default-namespace="">
            <xsl:for-each select="//dl">
                
                <xsl:variable name="aria-expanded">
                    <xsl:choose>
                        <xsl:when test="dt/@id = 'characters'">true</xsl:when>
                        <xsl:otherwise>false</xsl:otherwise>
                    </xsl:choose>
                    
                </xsl:variable>
                
                <xsl:variable name="collapsed">
                    <xsl:choose>
                        <xsl:when test="dt/@id != 'characters'">collapsed</xsl:when>
                        <xsl:otherwise></xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                  
                  
                <div class="panel panel-default">
                    <div class="panel-heading" role="tab" id="{$title_slug}_{dt/@id}_heading">
                        <h4 class="panel-title">
                            <a class="{$collapsed}" role="button" data-toggle="collapse" data-parent="#accordion" href="#{$title_slug}_{dt/@id}_body" aria-expanded="{$aria-expanded}" aria-controls="{$title_slug}_{dt/@id}_body">
                                <xsl:value-of select="dt"/>
                            </a>
                        </h4>
                    </div>
                    <div>
                        <xsl:attribute name="id">
                            <xsl:value-of select="$title_slug"></xsl:value-of>
                            <xsl:text>_</xsl:text>
                            <xsl:value-of select="dt/@id"></xsl:value-of>
                            <xsl:text>_body</xsl:text>
                        </xsl:attribute>
                        <xsl:attribute name="class">
                            <xsl:text>panel-collapse collapse</xsl:text>
                            <xsl:if test="$collapsed = ''"><xsl:text> in</xsl:text></xsl:if>
                        </xsl:attribute>
                        <xsl:attribute name="role">tabpanel</xsl:attribute>
                        <xsl:attribute name="aria-labelledby">
                            <xsl:value-of select="$title_slug"></xsl:value-of>
                            <xsl:text>_</xsl:text>
                            <xsl:value-of select="dt/@id"></xsl:value-of>
                            <xsl:text>_heading</xsl:text>
                        </xsl:attribute>
                       
                        <div class="panel-body">
                            <xsl:for-each select="dd">
                                <a class="btn btn-default" href="#{@id}" role="button"><xsl:value-of select="."/></a>
                            </xsl:for-each>
                        </div>
                    </div>
                </div>
                  
                  
                  
            </xsl:for-each>
        </xsl:for-each>
        
         </div>
        
        <!-- For testing the generated code above -->
        <!--<xsl:copy-of select="$generated_definition_lists"></xsl:copy-of>-->
       
    </xsl:template>
    
    
    
    
    
    
    
    
    
    
    

    <xsl:template name="trait_generator">
        <xsl:param name="trait_type"/>
        <!-- all or individual -->
        <xsl:param name="trait_title"/>
        <xsl:param name="trait_selector"/>

        <!-- Listing the trait categories -->

        <dl>
            <dt>
                <xsl:attribute name="id" select="translate(lower-case($trait_title),' ','_')"></xsl:attribute>
                <xsl:value-of select="$trait_title"/>
            </dt>

            <xsl:for-each-group
                select="
                if ($trait_type = 'all')
                then /TEI/teiHeader/profileDesc/particDesc/listPerson/person//*[name() = $trait_selector]
                else 
                if ($trait_type = 'main')
                then /TEI/teiHeader/profileDesc/particDesc/listPerson/person[@role='main']//*[name() = $trait_selector] |
                /TEI/teiHeader/profileDesc/particDesc/listPerson/person[@role='main_nar']//*[name() = $trait_selector] |
                /TEI/teiHeader/profileDesc/particDesc/listPerson/person[@role='asanother' and @corresp]//*[name() = $trait_selector] |
                /TEI/teiHeader/profileDesc/particDesc/listPerson/person[@role='asanother_nar' and @corresp]//*[name() = $trait_selector]
                else /TEI/teiHeader/profileDesc/particDesc/listPerson/person//*[name() = $trait_selector]"
                group-by="normalize-space()">

                <xsl:sort select="current-grouping-key()" order="ascending"/>
                <xsl:if test="current-grouping-key() != ''">
                    <dd>
                        <xsl:attribute name="id">
                            <xsl:value-of select="translate(lower-case(normalize-space(.)),' .','_')"/>
                        </xsl:attribute>
                        <xsl:value-of select="current-grouping-key()"/>
                    </dd>
                </xsl:if>
            </xsl:for-each-group>

        </dl>
        
        

    </xsl:template>


</xsl:stylesheet>
