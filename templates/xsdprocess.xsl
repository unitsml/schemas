<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
		xmlns:xsd="http://www.w3.org/2001/XMLSchema" 
		exclude-result-prefixes="xsd" 
		version="1.0">

	<xsl:strip-space elements="items"/>
	
	<xsl:output method="xml" encoding="UTF-8" indent="yes"/>

	<xsl:template match="@*|node()" >
		<xsl:copy>
			<xsl:apply-templates select="@*|node()" />
		</xsl:copy>
	</xsl:template>

	<xsl:template match="*[local-name() = 'boilerplate']">
		<xsl:variable name="depth" select="count(ancestor::*)"/>
		<xsl:apply-templates select="document(@href)">
			<xsl:with-param name="depth" select="$depth"/>
		</xsl:apply-templates>
	</xsl:template>
	
	<xsl:template match="*[local-name() = 'items']">
		<xsl:param name="depth"/>
		<xsl:apply-templates>
			<xsl:with-param name="depth" select="$depth"/>
		</xsl:apply-templates>
	</xsl:template>
	
	<xsl:template match="*[local-name() = 'item'][normalize-space(.) = '']" priority="2"/>
	<xsl:template match="*[local-name() = 'item']">
		<xsl:param name="depth"/>
		<xsl:if test="position() != 1">
			<xsl:call-template name="repeat"><xsl:with-param name="count" select="$depth"/></xsl:call-template>
		</xsl:if>
		<xsd:enumeration value="{.}"/>
		<xsl:if test="position() != last()">
			<xsl:text>&#xa;</xsl:text>
		</xsl:if>
	</xsl:template>
	
	<xsl:template name="repeat">
		<xsl:param name="char" select="'&#x9;'"/>
		<xsl:param name="count" />
		<xsl:if test="$count &gt; 0">
			<xsl:value-of select="$char" />
			<xsl:call-template name="repeat">
				<xsl:with-param name="char" select="$char" />
				<xsl:with-param name="count" select="$count - 1" />
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	
</xsl:stylesheet>