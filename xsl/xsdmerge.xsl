<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xsd="http://www.w3.org/2001/XMLSchema"
  xmlns:exslt="http://exslt.org/common"
  version="1.0">
	
  <xsl:output method="xml" encoding="UTF-8"/>
    
	<!-- XSD file name -->
  <xsl:param name="rootxsd"/>
  
  <xsl:variable name="rootxsd_includes">
    <xsl:value-of select="$rootxsd"/>
    <xsl:text> </xsl:text>
    <xsl:for-each select="//xsd:include">
      <xsl:call-template name="getFileName">
        <xsl:with-param name="path" select="@schemaLocation"/>
      </xsl:call-template>
      <xsl:text> </xsl:text>
    </xsl:for-each>
  </xsl:variable>
  
  
  <!-- Merge XSDs into one -->
 
  <xsl:template match="/" mode="merge_list">
    <xsl:param name="schemas"/>
    <xsl:param name="position"/>
    <xsl:apply-templates mode="merge_list">
      <xsl:with-param name="schemas" select="concat($schemas, ' ', $rootxsd)"/>
      <xsl:with-param name="position" select="$position"/>
    </xsl:apply-templates>
  </xsl:template>
   
  <xsl:template match="node()|@*" mode="merge_list">
    <xsl:param name="schemas"/>
    <xsl:apply-templates mode="merge_list">
      <xsl:with-param name="schemas" select="$schemas"/>
    </xsl:apply-templates>
  </xsl:template>
    
  <xsl:template match="xsd:include" mode="merge_list">
    <xsl:param name="schemas"/>
    <xsl:variable name="schemaFile">
      <xsl:call-template name="getFileName">
        <xsl:with-param name="path" select="@schemaLocation"/>
      </xsl:call-template>
    </xsl:variable>
      
    <xsl:if test="not(contains($schemas, $schemaFile))">
      <item pos="{generate-id()}" schemaFile="{$schemaFile}">
        <xsl:apply-templates select="document(@schemaLocation)" mode="content_only"/>
      </item>
      <xsl:apply-templates select="document(@schemaLocation)" mode="merge_list">
        <xsl:with-param name="schemas" select="concat($schemas, ' ', $schemaFile, ' ', $rootxsd_includes)"/>
      </xsl:apply-templates>
    </xsl:if>
  </xsl:template>
   
   
  <xsl:template match="node()|@*" mode="content_only">      
    <xsl:copy>
      <xsl:apply-templates select="node()|@*" mode="content_only"/>
    </xsl:copy>
  </xsl:template>
   
  <xsl:template match="xsd:include" mode="content_only"/>
  <xsl:template match="xsd:schema" mode="content_only">
    <xsl:apply-templates mode="content_only"/>
  </xsl:template>
   
  <xsl:template match="xsd:schema" mode="merge">      
    <xsl:param name="xsd_list"/>
    <xsl:copy>
      <xsl:apply-templates select="node()|@*" mode="merge"/>
      <xsl:for-each select="exslt:node-set($xsd_list)/*[local-name() = 'item']">
        <xsl:variable name="curr_schemaFile" select="@schemaFile"/>
        <xsl:if test="not(preceding-sibling::*[@schemaFile = $curr_schemaFile])">
          <xsl:copy-of select="./*"/>
        </xsl:if>
      </xsl:for-each>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="node()|@*" mode="merge">      
    <xsl:copy>
      <xsl:apply-templates select="node()|@*" mode="merge"/>
    </xsl:copy>
  </xsl:template>
  <xsl:template match="xsd:include" mode="merge"/>

  
  <xsl:template match="/">
    <xsl:variable name="xsd_list">
      <xsl:variable name="schemaFile">
        <xsl:call-template name="getFileName">
          <xsl:with-param name="path" select="$rootxsd"/>
        </xsl:call-template>
      </xsl:variable>
      <item schemaFile="{$schemaFile}"></item>
      <xsl:apply-templates mode="merge_list">
        <xsl:with-param name="position">1</xsl:with-param>
      </xsl:apply-templates>
    </xsl:variable>
    <xsl:variable name="mergedDoc">
      <xsl:apply-templates mode="merge">
        <xsl:with-param name="xsd_list" select="$xsd_list"/>
      </xsl:apply-templates>
    </xsl:variable>
    <xsl:copy-of select="$mergedDoc"/>
  </xsl:template>
  
  <xsl:template name="getFileName">
    <xsl:param name="path"/>
    <xsl:choose>
      <xsl:when test="contains($path, '/')">
        <xsl:call-template name="substring-after-last">
          <xsl:with-param name="value" select="$path"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="contains($path, '\')">
        <xsl:call-template name="substring-after-last">
          <xsl:with-param name="value" select="$path"/>
          <xsl:with-param name="delimiter" select="'\'"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise><xsl:value-of select="$path"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="substring-after-last">
    <xsl:param name="value"/>
    <xsl:param name="delimiter" select="'/'"/>
    <xsl:choose>
      <xsl:when test="contains($value, $delimiter)">
        <xsl:call-template name="substring-after-last">
          <xsl:with-param name="value" select="substring-after($value, $delimiter)" />
          <xsl:with-param name="delimiter" select="$delimiter" />
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$value" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
    
   <!-- END Merge XSDs into one -->
   
</xsl:stylesheet>
