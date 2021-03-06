<?xml version="1.0" encoding="UTF-8"?>

<!--/*******************************************************************************
     * Copyright (C) Yutaka Matsuno 2010-2012 All rights reserved.
     *******************************************************************************/-->

<!--Transforms D-Case to GMF-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                xmlns:dcase="http://www.dependable-os.net/2013/11/dcase_model/"
                xmlns:dcase_std="http://www.dependable-os.net/2013/11/dcase"
                xmlns:dfunc="net.dependableos.dcase.diagram.common.xml.XsltExtFunctionUtil"
                xmlns:dre="http://www.dependable-os.net/dre"
                exclude-result-prefixes="dcase_std"
                extension-element-prefixes="result dfunc"
                version="1.0">

  <xsl:output method="xml" encoding="UTF-8" indent="yes" />

  <!--Root-->
  <xsl:template match="/">
    <dcase:Argument>
      <xsl:apply-templates select="dcase_std:dcase"/>
    </dcase:Argument>
  </xsl:template>

  <xsl:template match="dcase_std:dcase">
    <xsl:call-template name="BasicAttribute"/>
    <xsl:apply-templates select="dcase_std:nodes/dcase_std:node"/>
    <xsl:apply-templates select="dcase_std:links/dcase_std:link">
      <xsl:sort select="./@source" data-type="text" order="ascending"/>
      <xsl:sort select="number(./dcase_std:properties/dcase_std:property[@name='SiblingOrder']/@value)" data-type="number" order="ascending"/>
    </xsl:apply-templates>
  </xsl:template>

  <!--Node-->
  <xsl:template match="dcase_std:node">
    <rootBasicNode>
      <xsl:attribute name="xsi:type">
        <xsl:choose>
          <xsl:when test="@type='Goal'">dcase:Goal</xsl:when>
          <xsl:when test="@type='Strategy'">dcase:Strategy</xsl:when>
          <xsl:when test="@type='Evidence'">dcase:Evidence</xsl:when>
          <xsl:when test="@type='Undeveloped'">dcase:Undeveloped</xsl:when>
          <xsl:when test="@type='Context'">dcase:Context</xsl:when>
          <xsl:when test="@type='Monitor'">dcase:Monitor</xsl:when>
          <xsl:when test="@type='Justification'">dcase:Justification</xsl:when>
          <xsl:when test="@type='Userdef002'">dcase:Userdef002</xsl:when>
          <xsl:when test="@type='Userdef003'">dcase:Userdef003</xsl:when>
          <xsl:when test="@type='Assumption'">dcase:Assumption</xsl:when>
          <xsl:when test="@type='Module'">dcase:Module</xsl:when>
          <xsl:when test="@type='Contract'">dcase:Contract</xsl:when>
          <xsl:when test="@type='Action'">dcase:Action</xsl:when>
          <xsl:when test="@type='External'">dcase:External</xsl:when>
          <xsl:when test="@type='Pattern'">dcase:Pattern</xsl:when>
          <xsl:otherwise>undefined</xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <xsl:call-template name="BasicAttribute"/>
    </rootBasicNode>
  </xsl:template>


  <!--Link-->
  <xsl:template match="dcase_std:link">
    <rootBasicLink>
      <xsl:attribute name="xsi:type">
        <xsl:choose>
          <xsl:when test="@type='SupportedBy'">dcase:SupportedBy</xsl:when>
          <xsl:when test="@type='InContextOf'">dcase:InContextOf</xsl:when>
          <xsl:when test="@type='Responsibility'">dcase:Responsibility</xsl:when>
          <xsl:when test="@type='Link004'">dcase:DcaseLink004</xsl:when>
         <xsl:otherwise>dcase:DcaseLink001</xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <xsl:apply-templates select="@source|@target"/>
      <xsl:call-template name="BasicAttribute"/>
    </rootBasicLink>
  </xsl:template>

  <!--Attribute-->
  <xsl:template name="BasicAttribute">
    <xsl:apply-templates select="@id|@name|@status" mode="basic"/>
    <xsl:call-template name="Description"/>
    <xsl:apply-templates select="dcase_std:properties/dcase_std:property"></xsl:apply-templates>
    <xsl:if test="dcase_std:responsibility!='NaN'">
      <xsl:apply-templates select="dcase_std:responsibility"/>
    </xsl:if>
    <xsl:if test="dcase_std:parameters!='NaN'">
      <xsl:apply-templates select="dcase_std:parameters"/>
    </xsl:if>
    <xsl:if test="dre:d-script!='NaN'">
      <xsl:apply-templates select="dre:d-script"/>
    </xsl:if>
  </xsl:template>

  <xsl:template name="Description">
    <xsl:attribute name="desc">
      <xsl:value-of select="dcase_std:description"/>
    </xsl:attribute>
  </xsl:template>

  <!--Attribute value-->
  <xsl:template match="@*" mode="basic">
    <xsl:attribute name="{local-name()}">
      <xsl:value-of select="."/>
    </xsl:attribute>
  </xsl:template>

  <!--Source and Target of the Link-->
  <xsl:template match="@source|@target">
    <xsl:attribute name="{local-name()}">
      <xsl:value-of select="concat('#',.) "/>
    </xsl:attribute>
  </xsl:template>

  <!--Property-->
  <xsl:template match="dcase_std:property">
    <xsl:choose>
      <xsl:when test="@name='Attachment'">
        <xsl:attribute name="attachment">
          <xsl:value-of select="@value"/>
        </xsl:attribute>
      </xsl:when>
      <xsl:when test="@name='Userdef001'">
        <xsl:attribute name="userdef001">
          <xsl:value-of select="@value"/>
        </xsl:attribute>
      </xsl:when>
      <xsl:when test="@name='Userdef002'">
        <xsl:attribute name="userdef002">
          <xsl:value-of select="@value"/>
        </xsl:attribute>
      </xsl:when>
      <xsl:when test="@name='Userdef003'">
        <xsl:attribute name="userdef003">
          <xsl:value-of select="@value"/>
        </xsl:attribute>
      </xsl:when>
      <xsl:when test="@name='Userdef004'">
        <xsl:attribute name="userdef004">
          <xsl:value-of select="@value"/>
        </xsl:attribute>
      </xsl:when>
      <xsl:when test="@name='Userdef005'">
        <xsl:attribute name="userdef005">
          <xsl:value-of select="@value"/>
        </xsl:attribute>
      </xsl:when>
      <xsl:when test="@name='Userdef006'">
        <xsl:attribute name="userdef006">
          <xsl:value-of select="@value"/>
        </xsl:attribute>
      </xsl:when>
      <xsl:when test="@name='Userdef007'">
        <xsl:attribute name="userdef007">
          <xsl:value-of select="@value"/>
        </xsl:attribute>
      </xsl:when>
      <xsl:when test="@name='Userdef008'">
        <xsl:attribute name="userdef008">
          <xsl:value-of select="@value"/>
        </xsl:attribute>
      </xsl:when>
      <xsl:when test="@name='Userdef009'">
        <xsl:attribute name="userdef009">
          <xsl:value-of select="@value"/>
        </xsl:attribute>
      </xsl:when>
      <xsl:when test="@name='Userdef010'">
        <xsl:attribute name="userdef010">
          <xsl:value-of select="@value"/>
        </xsl:attribute>
      </xsl:when>
      <xsl:when test="@name='Userdef011'">
        <xsl:attribute name="userdef011">
          <xsl:value-of select="@value"/>
        </xsl:attribute>
      </xsl:when>
      <xsl:when test="@name='Userdef012'">
        <xsl:attribute name="userdef012">
          <xsl:value-of select="@value"/>
        </xsl:attribute>
      </xsl:when>
      <xsl:when test="@name='Userdef013'">
        <xsl:attribute name="userdef013">
          <xsl:value-of select="@value"/>
        </xsl:attribute>
      </xsl:when>
      <xsl:when test="@name='Userdef014'">
        <xsl:attribute name="userdef014">
          <xsl:value-of select="@value"/>
        </xsl:attribute>
      </xsl:when>
      <xsl:when test="@name='Userdef015'">
        <xsl:attribute name="userdef015">
          <xsl:value-of select="@value"/>
        </xsl:attribute>
      </xsl:when>
      <xsl:when test="@name='Userdef016'">
        <xsl:attribute name="userdef016">
          <xsl:value-of select="@value"/>
        </xsl:attribute>
      </xsl:when>
      <xsl:when test="@name='Score'">
        <xsl:attribute name="score">
          <xsl:apply-templates select="@value" mode="Decimal"></xsl:apply-templates>
        </xsl:attribute>
      </xsl:when>
      <xsl:when test="@name='Weight'">
        <xsl:attribute name="weight">
          <xsl:apply-templates select="@value" mode="Integer1orOver"></xsl:apply-templates>
        </xsl:attribute>
      </xsl:when>
      <xsl:when test="@name='NodeLink'">
        <xsl:attribute name="nodeLink">
          <xsl:value-of select="@value"/>
        </xsl:attribute>
      </xsl:when>
      <xsl:when test="@name='IsNormal'">
        <xsl:attribute name="isNormal">
          <xsl:value-of select="@value"/>
        </xsl:attribute>
      </xsl:when>
      <xsl:when test="@name='Stakeholder'">
        <xsl:attribute name="stakeholder">
          <xsl:value-of select="@value"/>
        </xsl:attribute>
      </xsl:when>
      <xsl:when test="@name='RiskAnalysis'">
        <xsl:attribute name="riskAnalysis">
          <xsl:value-of select="@value"/>
        </xsl:attribute>
      </xsl:when>
      <xsl:when test="@name='Message'">
        <xsl:attribute name="message">
          <xsl:value-of select="@value"/>
        </xsl:attribute>
      </xsl:when>
      <xsl:when test="@name='Requirement'">
        <xsl:attribute name="requirement">
          <xsl:value-of select="@value"/>
        </xsl:attribute>
      </xsl:when>
      <xsl:when test="@name='ParameterizedDesc'">
        <xsl:attribute name="parameterizedDesc">
          <xsl:value-of select="@value"/>
        </xsl:attribute>
      </xsl:when>
      <xsl:when test="@name='Parent'">
        <xsl:attribute name="parent">
          <xsl:value-of select="@value"/>
        </xsl:attribute>
      </xsl:when>
      <xsl:when test="@name='RefSource'">
        <xsl:attribute name="refSource">
          <xsl:value-of select="@value"/>
        </xsl:attribute>
      </xsl:when>
      <xsl:when test="@name='Flag'">
        <xsl:attribute name="flag">
          <xsl:value-of select="@value"/>
        </xsl:attribute>
      </xsl:when>
      <xsl:when test="@name='LeafNode'">
        <xsl:attribute name="leafNode">
          <xsl:value-of select="@value"/>
        </xsl:attribute>
      </xsl:when>
      <xsl:when test="@name='I'">
        <xsl:attribute name="i">
          <xsl:value-of select="@value"/>
        </xsl:attribute>
      </xsl:when>
      <xsl:when test="@name='J'">
        <xsl:attribute name="j">
          <xsl:value-of select="@value"/>
        </xsl:attribute>
      </xsl:when>
      <xsl:when test="@name='SiblingOrder'">
        <xsl:attribute name="siblingOrder">
          <xsl:value-of select="@value"/>
        </xsl:attribute>
      </xsl:when>
      <xsl:when test="@name='ValidUntil'">
        <xsl:attribute name="validUntil">
          <xsl:value-of select="@value"/>
        </xsl:attribute>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <!--Decimal-->
  <xsl:template match="@*" mode="Decimal">
    <xsl:choose>
      <xsl:when test="string(number(.))='NaN'">0</xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="."/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!--Integer-->
  <xsl:template match="@*" mode="Integer1orOver">
    <xsl:variable name="num" select="floor(.)"></xsl:variable>
    <xsl:choose>
      <xsl:when test="string($num)='NaN' or $num&lt;1">1</xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$num"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!--Responsibility-->
  <xsl:template match="dcase_std:responsibility">
    <xsl:if test="@name">
      <xsl:attribute name="respName">
        <xsl:value-of select="@name"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:if test="@address">
      <xsl:attribute name="respAddress">
        <xsl:value-of select="@address"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:if test="@icon">
      <xsl:attribute name="respIcon">
        <xsl:value-of select="@icon"/>
      </xsl:attribute>
    </xsl:if>
  </xsl:template>
  
  <!-- d-script -->
  <xsl:template match="dcase_std:parameters" >
    <xsl:attribute name="parameterVals">
      <xsl:value-of select="dfunc:parameterizeVals(.)"/>
    </xsl:attribute>
    <xsl:attribute name="parameterDefs">
      <xsl:value-of select="dfunc:parameterizeDefs(.)"/>
    </xsl:attribute>
  </xsl:template>

  <!-- d-script -->
  <xsl:template match="dre:d-script" >
    <xsl:attribute name="userdef011">
      <xsl:value-of select="dfunc:serialize(.)"/>
    </xsl:attribute>
  </xsl:template>

</xsl:stylesheet>
