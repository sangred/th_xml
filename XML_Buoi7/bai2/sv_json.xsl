<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="text" encoding="UTF-8" indent="no"/>
    
    <xsl:template match="/">
        <xsl:text>{
  "students": [</xsl:text>
        <xsl:apply-templates select="school/student"/>
        <xsl:text>
  ]
}</xsl:text>
    </xsl:template>
    
    <xsl:template match="student">
        <xsl:if test="position() > 1">
            <xsl:text>,</xsl:text>
        </xsl:if>
        <xsl:text>
    {
      "ma": "</xsl:text><xsl:value-of select="id"/><xsl:text>",
      "ho_ten": "</xsl:text><xsl:value-of select="name"/><xsl:text>",
      "ngay_sinh": "</xsl:text><xsl:value-of select="date"/><xsl:text>"
    }</xsl:text>
    </xsl:template>
    
</xsl:stylesheet>