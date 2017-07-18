<?xml version="1.0" encoding="UTF-8"?>
<!--
 - Copyright (c) 2017 d-r-p <d-r-p@users.noreply.github.com>
 -
 - Permission to use, copy, modify, and distribute this software for any
 - purpose with or without fee is hereby granted, provided that the above
 - copyright notice and this permission notice appear in all copies.
 -
 - THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 - WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 - MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 - ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 - WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 - ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 - OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
-->

<!--
  IMPORTANT NOTICES:
    - [@TODO] THIS XSL IS DEFINITELY NOT IDEAL, NOR STATE-OF-THE-ART!!!
      ACTUALLY, IT IS QUITE OBVIOUS HOW IT SHOULD BE MODIFIED. DUE TO TIME 
      CONSTRAINTS, THIS WILL BE DONE AT A LATER STAGE. MEANWHILE, WE USE THIS...
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.1" type="text/xml">

  <xsl:output method="html" encoding="UTF-8" media-type="text/html" version="5" indent="yes" omit-xml-declaration="yes"/>

  <xsl:template name="makeref">
    <tr>
      <td><a name="{./@doraid}"/><xsl:value-of select="position()"/></td><td><xsl:element name="a"><xsl:attribute name="href"><xsl:value-of select="./dl"/></xsl:attribute><xsl:text>d:</xsl:text><xsl:value-of select="./id"/></xsl:element><xsl:if test="boolean(./@refid) and not(./@refid = '')"><br/>
      <xsl:element name="a"><xsl:attribute name="href">http://www.refworks.com/refworks2/?site=039241152255600000%2fRWWS5A549035%2fEawag+Publications<xsl:value-of select="'&#38;'" disable-output-escaping="yes"/>rn=<xsl:value-of select="./@refid"/></xsl:attribute><xsl:text>r:</xsl:text><xsl:value-of select="./@refid"/></xsl:element></xsl:if></td>
      <xsl:variable name="authorlist">
        <xsl:for-each select="./a1"><xsl:value-of select="."/>; </xsl:for-each>
      </xsl:variable>
      <td><span class="a1"><xsl:value-of select="substring($authorlist, 1, string-length($authorlist) - 2)" disable-output-escaping="yes"/></span><span class="yr"> (<xsl:value-of select="./yr"/>) </span><strong><span class="t1"><xsl:value-of select="./t1" disable-output-escaping="yes"/></span></strong><xsl:if test="boolean(./jf) and not(./jf = '')"><strong><span class="t1"><xsl:text>, </xsl:text></span></strong><em><span class="jf"><xsl:value-of select="./jf" disable-output-escaping="yes"/></span></em></xsl:if><xsl:if test="boolean(./vo) and not(./vo = '')"><span class="jf"><xsl:text>, </xsl:text></span><span class="vo"><xsl:value-of select="./vo"/></span><xsl:if test="boolean(./is) and not(./is = '')"><span class="is"><xsl:text> (</xsl:text><xsl:value-of select="./is"/><xsl:text>)</xsl:text></span></xsl:if></xsl:if><xsl:if test="boolean(./sp) and not(./sp = '')"><span class="is"><xsl:text>, </xsl:text></span><span class="sp"><xsl:value-of select="./sp"/></span><xsl:if test="boolean(./op) and not(./op = '')"><span class="op"><xsl:text>-</xsl:text><xsl:value-of select="./op"/></span></xsl:if></xsl:if><xsl:if test="boolean(./doi) and not(./doi = '')"><span class="op"><xsl:text>, </xsl:text></span><span class="doi"><xsl:element name="a"><xsl:attribute name="href"><xsl:text>https://doi.org/</xsl:text><xsl:value-of select="./doi"/></xsl:attribute><xsl:attribute name="target">_blank</xsl:attribute><xsl:attribute name="class">externallink doi</xsl:attribute><xsl:value-of select="./doi"/></xsl:element></span></xsl:if><span class="doi"><xsl:text>, </xsl:text></span><span class="dl"><xsl:element name="a"><xsl:attribute name="href"><xsl:value-of select="./dl"/></xsl:attribute><xsl:attribute name="target">_blank</xsl:attribute><xsl:attribute name="class">externallink dl</xsl:attribute>Institutional Repository</xsl:element></span></td>
    </tr>
  </xsl:template>

  <xsl:template name="makerefbygenre">
    <xsl:param name="genre"/>
    <xsl:param name="root"/>
    <tr><td colspan="3"><font size="+2"><strong><xsl:value-of select="$genre"/><xsl:text> (</xsl:text><xsl:value-of select="count($root/reference[@genre=$genre])"/><xsl:text>)</xsl:text></strong></font></td></tr>
    <xsl:for-each select="$root/reference[@genre=$genre]">
      <xsl:call-template name="makeref"/>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="/refworks">
    <tr><td colspan="3"><font size="+3"><strong><xsl:text>Reference List (</xsl:text><xsl:value-of select="count(./reference)"/><xsl:if test="not(count(./reference) = ./@count)"><xsl:text>; expected</xsl:text><xsl:value-of select="./reference/@count"/></xsl:if><xsl:text>) from </xsl:text><xsl:value-of select="./@timestamp"/></strong></font></td></tr>
    <xsl:variable name="genres">
      <genre>Journal Article</genre>
      <genre>Newspaper or Magazine Article</genre>
      <genre>Book</genre>
      <genre>Book Chapter</genre>
      <genre>Brochure</genre>
      <genre>Edited Book</genre>
      <genre>Conference Proceedings</genre>
      <genre>Conference Item</genre>
      <genre>Proceedings Paper</genre>
      <genre>Report</genre>
      <genre>Scientific Report</genre>
      <genre>Bachelor Thesis</genre>
      <genre>Master Thesis</genre>
      <genre>Dissertation</genre>
      <genre>Patent</genre>
    </xsl:variable>
    <xsl:variable name="othergenres" select="./reference[not(@genre = 'Journal Article') and not(@genre = 'Newspaper or Magazine Article') and not(@genre = 'Book') and not(@genre = 'Book Chapter') and not(@genre = 'Brochure') and not(@genre = 'Edited Book') and not(@genre = 'Conference Proceedings') and not(@genre = 'Conference Item') and not(@genre = 'Proceedings Paper') and not(@genre = 'Report') and not(@genre = 'Scientific Report') and not(@genre = 'Bachelor Thesis') and not(@genre = 'Master Thesis') and not(@genre = 'Dissertation') and not(@genre = 'Patent')]"/>
    <xsl:variable name="refworks" select="."/>
    <xsl:for-each select="document('')/*/xsl:template[@match='/refworks']/xsl:variable[@name='genres']/genre">
      <xsl:call-template name="makerefbygenre">
        <xsl:with-param name="genre" select="."/>
        <xsl:with-param name="root" select="$refworks"/>
      </xsl:call-template>
    </xsl:for-each>
    <tr><td colspan="3"><font size="+2"><strong><xsl:text>Other (</xsl:text><xsl:value-of select="count($othergenres)"/><xsl:text>)</xsl:text></strong></font></td></tr>
    <xsl:for-each select="$othergenres">
      <xsl:call-template name="makeref"/>
    </xsl:for-each>
  </xsl:template>


  <xsl:template match="/">
    <html>
      <head>
        <style>
          @font-face {
            font-family: "EawagIconFont";
            src:url('EawagIconFont.woff') format("woff");
            font-weight: normal;
            font-style: normal;
          }
          td { vertical-align: text-top; }
          a { color: #7f7f7f; text-decoration: none; }
          .a1 { color: #000066; } /* 50% medium blue 0000cd */
          .yr { color: #5c4305; } /* 50% dark goldenrod b8860b */
          .t1 { color: #114511; } /* 50% forest green 228b22 */
          .jf { color: #250041; } /* 50% indigo 4b0082 */
          .vo { color: #400000; } /* 50% maroon 800000 */
          .is { color: #004545; } /* 50% dark cyan 008b8b */
          .sp { color: #7f4600; } /* 50% dark orange ff8c00 */
          .op { color: #336655; } /* 50% medium aquamarine 66cdaa */
          a[href^='http://'].externallink:before,
          a[href^='https://'].externallink:before {
            content: "m";
            font-family: "EawagIconFont";
            padding-right: 7px;
            font-size: 15px;
            position: relative;
            line-height: 16px;
            top: 2px;
          }
          .doi { color: #450045; } /* dark magenta 8b008b */
          .dl { color: #5e5b35; } /* dark khaki bdb76b */
        </style>
      </head>
      <body bgcolor="#FFFFFF">
        <table>
          <xsl:apply-templates/>
        </table>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="*"/>

</xsl:stylesheet>
