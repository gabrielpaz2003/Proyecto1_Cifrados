$ErrorActionPreference = "Stop"

$root   = Split-Path -Parent $MyInvocation.MyCommand.Path
$output = Join-Path $root "proyecto1_reporte_template.docx"
$temp   = Join-Path ([System.IO.Path]::GetTempPath()) ("proyecto1_docx_" + [System.Guid]::NewGuid().ToString("N"))

# ============================================================
#  UTILIDADES BASE
# ============================================================
function Write-Utf8NoBom {
    param([string]$Path, [string]$Content)
    $enc = New-Object System.Text.UTF8Encoding($false)
    [System.IO.File]::WriteAllText($Path, $Content, $enc)
}

function Escape-Xml {
    param([string]$Text)
    return [System.Security.SecurityElement]::Escape($Text)
}

# ============================================================
#  HELPERS DE PARRAFOS SIMPLES
# ============================================================
function New-Paragraph {
    param([string]$Text = "", [string]$Style = "Normal")
    if ([string]::IsNullOrEmpty($Text)) { return "<w:p/>" }
    $e = Escape-Xml $Text
    $s = if ($Style) { "<w:pPr><w:pStyle w:val=`"$Style`"/></w:pPr>" } else { "" }
    return "<w:p>$s<w:r><w:t xml:space=`"preserve`">$e</w:t></w:r></w:p>"
}

function New-PageBreak {
    return "<w:p><w:r><w:br w:type=`"page`"/></w:r></w:p>"
}

function New-HRule {
    return "<w:p><w:pPr><w:pStyle w:val=`"HRule`"/></w:pPr><w:r><w:t xml:space=`"preserve`"> </w:t></w:r></w:p>"
}

function New-Spacer {
    param([int]$Size = 200)
    return "<w:p><w:pPr><w:spacing w:before=`"0`" w:after=`"$Size`"/></w:pPr></w:p>"
}

function New-InfoBox {
    param([string]$Text)
    $e = Escape-Xml $Text
    return "<w:p><w:pPr><w:pStyle w:val=`"InfoBox`"/></w:pPr><w:r><w:t xml:space=`"preserve`">$e</w:t></w:r></w:p>"
}

function New-CodeBlock {
    param([string]$Text)
    $e = Escape-Xml $Text
    return "<w:p><w:pPr><w:pStyle w:val=`"CodeShaded`"/></w:pPr><w:r><w:t xml:space=`"preserve`">$e</w:t></w:r></w:p>"
}

function New-FlagLine {
    param([string]$Label)
    $e = Escape-Xml $Label
    return @"
<w:p>
  <w:pPr><w:pStyle w:val="FlagValue"/></w:pPr>
  <w:r>
    <w:rPr><w:b/><w:color w:val="334155"/></w:rPr>
    <w:t xml:space="preserve">$e</w:t>
  </w:r>
  <w:r>
    <w:rPr><w:color w:val="94A3B8"/></w:rPr>
    <w:t xml:space="preserve">  _______________________________________________</w:t>
  </w:r>
</w:p>
"@
}

function New-ScreenshotBox {
    param([string]$Caption)
    $c = Escape-Xml $Caption
    return @"
<w:p><w:pPr><w:pStyle w:val="Caption"/></w:pPr><w:r><w:t xml:space="preserve">$c</w:t></w:r></w:p>
<w:p><w:pPr><w:pStyle w:val="ScreenshotPlaceholder"/></w:pPr>
  <w:r><w:t xml:space="preserve">     Insertar captura de pantalla aqui     </w:t></w:r>
</w:p>
<w:p/>
"@
}

# ============================================================
#  TABLAS DE DISENO: PORTADA Y SECCIONES
# ============================================================

# Barra de color solido (para portada y decoracion)
function New-ColorBar {
    param([string]$BgColor, [int]$Height = 80)
    return @"
<w:tbl>
  <w:tblPr>
    <w:tblW w:w="9360" w:type="dxa"/>
    <w:tblBorders>
      <w:top    w:val="none" w:sz="0" w:space="0" w:color="auto"/>
      <w:left   w:val="none" w:sz="0" w:space="0" w:color="auto"/>
      <w:bottom w:val="none" w:sz="0" w:space="0" w:color="auto"/>
      <w:right  w:val="none" w:sz="0" w:space="0" w:color="auto"/>
    </w:tblBorders>
    <w:tblCellMar>
      <w:top    w:w="0" w:type="dxa"/>
      <w:left   w:w="0" w:type="dxa"/>
      <w:bottom w:w="0" w:type="dxa"/>
      <w:right  w:w="0" w:type="dxa"/>
    </w:tblCellMar>
  </w:tblPr>
  <w:tblGrid><w:gridCol w:w="9360"/></w:tblGrid>
  <w:tr>
    <w:trPr><w:trHeight w:val="$Height" w:hRule="exact"/></w:trPr>
    <w:tc>
      <w:tcPr>
        <w:tcW w:w="9360" w:type="dxa"/>
        <w:shd w:val="clear" w:color="auto" w:fill="$BgColor"/>
      </w:tcPr>
      <w:p><w:r><w:t xml:space="preserve"> </w:t></w:r></w:p>
    </w:tc>
  </w:tr>
</w:tbl>
"@
}

# Banner superior de portada (navy con nombre UVG y curso)
function New-CoverTopBanner {
    return @'
<w:tbl>
  <w:tblPr>
    <w:tblW w:w="9360" w:type="dxa"/>
    <w:tblBorders>
      <w:top    w:val="none" w:sz="0" w:space="0" w:color="auto"/>
      <w:left   w:val="none" w:sz="0" w:space="0" w:color="auto"/>
      <w:bottom w:val="none" w:sz="0" w:space="0" w:color="auto"/>
      <w:right  w:val="none" w:sz="0" w:space="0" w:color="auto"/>
    </w:tblBorders>
    <w:tblCellMar>
      <w:top    w:w="440" w:type="dxa"/>
      <w:left   w:w="560" w:type="dxa"/>
      <w:bottom w:w="440" w:type="dxa"/>
      <w:right  w:w="560" w:type="dxa"/>
    </w:tblCellMar>
  </w:tblPr>
  <w:tblGrid><w:gridCol w:w="9360"/></w:tblGrid>
  <w:tr>
    <w:tc>
      <w:tcPr>
        <w:tcW w:w="9360" w:type="dxa"/>
        <w:shd w:val="clear" w:color="auto" w:fill="0F2851"/>
      </w:tcPr>
      <w:p>
        <w:pPr><w:jc w:val="center"/><w:spacing w:before="0" w:after="100"/></w:pPr>
        <w:r>
          <w:rPr>
            <w:rFonts w:ascii="Calibri Light" w:hAnsi="Calibri Light"/>
            <w:b/><w:sz w:val="28"/><w:color w:val="FFFFFF"/>
          </w:rPr>
          <w:t>UNIVERSIDAD DEL VALLE DE GUATEMALA</w:t>
        </w:r>
      </w:p>
      <w:p>
        <w:pPr><w:jc w:val="center"/><w:spacing w:before="0" w:after="0"/></w:pPr>
        <w:r>
          <w:rPr>
            <w:rFonts w:ascii="Calibri" w:hAnsi="Calibri"/>
            <w:sz w:val="20"/><w:color w:val="7FB3D3"/>
          </w:rPr>
          <w:t>Facultad de Ingenieria  -  Cifrado de Informacion</w:t>
        </w:r>
      </w:p>
    </w:tc>
  </w:tr>
</w:tbl>
'@
}

# Tabla de informacion de portada (etiqueta | valor)
function New-CoverInfoTable {
    param([string[][]]$Rows)
    $rowsXml = ""
    foreach ($row in $Rows) {
        $lbl = Escape-Xml $row[0]
        $val = Escape-Xml $row[1]
        $rowsXml += @"
<w:tr>
  <w:tc>
    <w:tcPr>
      <w:tcW w:w="2600" w:type="dxa"/>
      <w:tcBorders>
        <w:bottom w:val="single" w:sz="4" w:space="0" w:color="CBD5E1"/>
      </w:tcBorders>
    </w:tcPr>
    <w:p>
      <w:pPr><w:spacing w:before="120" w:after="120"/></w:pPr>
      <w:r>
        <w:rPr>
          <w:b/><w:sz w:val="20"/><w:color w:val="0F2851"/>
        </w:rPr>
        <w:t xml:space="preserve">$lbl</w:t>
      </w:r>
    </w:p>
  </w:tc>
  <w:tc>
    <w:tcPr>
      <w:tcW w:w="6760" w:type="dxa"/>
      <w:tcBorders>
        <w:bottom w:val="single" w:sz="4" w:space="0" w:color="CBD5E1"/>
      </w:tcBorders>
    </w:tcPr>
    <w:p>
      <w:pPr><w:spacing w:before="120" w:after="120"/></w:pPr>
      <w:r>
        <w:rPr>
          <w:sz w:val="20"/><w:color w:val="334155"/>
        </w:rPr>
        <w:t xml:space="preserve">$val</w:t>
      </w:r>
    </w:p>
  </w:tc>
</w:tr>
"@
    }
    return @"
<w:tbl>
  <w:tblPr>
    <w:tblW w:w="9360" w:type="dxa"/>
    <w:tblBorders>
      <w:top    w:val="none" w:sz="0" w:space="0" w:color="auto"/>
      <w:left   w:val="none" w:sz="0" w:space="0" w:color="auto"/>
      <w:bottom w:val="none" w:sz="0" w:space="0" w:color="auto"/>
      <w:right  w:val="none" w:sz="0" w:space="0" w:color="auto"/>
      <w:insideH w:val="none" w:sz="0" w:space="0" w:color="auto"/>
      <w:insideV w:val="none" w:sz="0" w:space="0" w:color="auto"/>
    </w:tblBorders>
    <w:tblLook w:val="0000"/>
  </w:tblPr>
  <w:tblGrid>
    <w:gridCol w:w="2600"/>
    <w:gridCol w:w="6760"/>
  </w:tblGrid>
  $rowsXml
</w:tbl>
"@
}

# Banner de seccion de reto (nombre + badge de cifrado)
function New-ChallengeBanner {
    param(
        [string]$SectionNum,
        [string]$CharName,
        [string]$Cipher,
        [string]$BgColor   = "0F2851",
        [string]$BadgeColor = "1D6FA4"
    )
    $nameEsc   = Escape-Xml "Reto $SectionNum   -   $CharName"
    $cipherEsc = Escape-Xml $Cipher
    return @"
<w:tbl>
  <w:tblPr>
    <w:tblW w:w="9360" w:type="dxa"/>
    <w:tblBorders>
      <w:top    w:val="none" w:sz="0" w:space="0" w:color="auto"/>
      <w:left   w:val="none" w:sz="0" w:space="0" w:color="auto"/>
      <w:bottom w:val="none" w:sz="0" w:space="0" w:color="auto"/>
      <w:right  w:val="none" w:sz="0" w:space="0" w:color="auto"/>
      <w:insideH w:val="none" w:sz="0" w:space="0" w:color="auto"/>
      <w:insideV w:val="none" w:sz="0" w:space="0" w:color="auto"/>
    </w:tblBorders>
    <w:tblCellMar>
      <w:top    w:w="220" w:type="dxa"/>
      <w:left   w:w="400" w:type="dxa"/>
      <w:bottom w:w="220" w:type="dxa"/>
      <w:right  w:w="400" w:type="dxa"/>
    </w:tblCellMar>
  </w:tblPr>
  <w:tblGrid>
    <w:gridCol w:w="7360"/>
    <w:gridCol w:w="2000"/>
  </w:tblGrid>
  <w:tr>
    <w:tc>
      <w:tcPr>
        <w:tcW w:w="7360" w:type="dxa"/>
        <w:shd w:val="clear" w:color="auto" w:fill="$BgColor"/>
        <w:vAlign w:val="center"/>
      </w:tcPr>
      <w:p>
        <w:pPr><w:spacing w:before="0" w:after="0"/></w:pPr>
        <w:r>
          <w:rPr>
            <w:rFonts w:ascii="Calibri Light" w:hAnsi="Calibri Light"/>
            <w:b/><w:sz w:val="26"/><w:color w:val="FFFFFF"/>
          </w:rPr>
          <w:t xml:space="preserve">$nameEsc</w:t>
        </w:r>
      </w:p>
    </w:tc>
    <w:tc>
      <w:tcPr>
        <w:tcW w:w="2000" w:type="dxa"/>
        <w:shd w:val="clear" w:color="auto" w:fill="$BadgeColor"/>
        <w:vAlign w:val="center"/>
      </w:tcPr>
      <w:p>
        <w:pPr>
          <w:jc w:val="center"/>
          <w:spacing w:before="0" w:after="0"/>
        </w:pPr>
        <w:r>
          <w:rPr>
            <w:rFonts w:ascii="Consolas" w:hAnsi="Consolas"/>
            <w:b/><w:sz w:val="22"/><w:color w:val="FFFFFF"/>
          </w:rPr>
          <w:t xml:space="preserve">$cipherEsc</w:t>
        </w:r>
      </w:p>
    </w:tc>
  </w:tr>
</w:tbl>
"@
}

# Tabla de resultados con filas alternadas
function New-ResultsTable {
    $hdr = @"
<w:tr>
  <w:trPr><w:cantSplit/></w:trPr>
  <w:tc>
    <w:tcPr><w:tcW w:w="1800" w:type="dxa"/><w:shd w:val="clear" w:color="auto" w:fill="0F2851"/></w:tcPr>
    <w:p><w:pPr><w:pStyle w:val="TH"/></w:pPr><w:r><w:t>Reto</w:t></w:r></w:p>
  </w:tc>
  <w:tc>
    <w:tcPr><w:tcW w:w="1400" w:type="dxa"/><w:shd w:val="clear" w:color="auto" w:fill="0F2851"/></w:tcPr>
    <w:p><w:pPr><w:pStyle w:val="TH"/></w:pPr><w:r><w:t>Cifrado</w:t></w:r></w:p>
  </w:tc>
  <w:tc>
    <w:tcPr><w:tcW w:w="3080" w:type="dxa"/><w:shd w:val="clear" w:color="auto" w:fill="0F2851"/></w:tcPr>
    <w:p><w:pPr><w:pStyle w:val="TH"/></w:pPr><w:r><w:t>Flag</w:t></w:r></w:p>
  </w:tc>
  <w:tc>
    <w:tcPr><w:tcW w:w="3080" w:type="dxa"/><w:shd w:val="clear" w:color="auto" w:fill="0F2851"/></w:tcPr>
    <w:p><w:pPr><w:pStyle w:val="TH"/></w:pPr><w:r><w:t>Poneglyph</w:t></w:r></w:p>
  </w:tc>
</w:tr>
"@

    $challenges = @(
        @{ Name="Luffy";  Cipher="XOR";     BgAlt=$false },
        @{ Name="Zoro";   Cipher="RC4";     BgAlt=$true  },
        @{ Name="Usopp";  Cipher="PRNG";    BgAlt=$false },
        @{ Name="Nami";   Cipher="ChaCha20";BgAlt=$true  }
    )

    $dataRows = ""
    foreach ($ch in $challenges) {
        $fill  = if ($ch.BgAlt) { "F0F7FF" } else { "FFFFFF" }
        $nEsc  = Escape-Xml $ch.Name
        $cEsc  = Escape-Xml $ch.Cipher
        $dataRows += @"
<w:tr>
  <w:trPr><w:cantSplit/></w:trPr>
  <w:tc>
    <w:tcPr><w:tcW w:w="1800" w:type="dxa"/><w:shd w:val="clear" w:color="auto" w:fill="$fill"/></w:tcPr>
    <w:p>
      <w:pPr><w:spacing w:before="100" w:after="100"/></w:pPr>
      <w:r><w:rPr><w:b/><w:sz w:val="20"/><w:color w:val="0F2851"/></w:rPr>
        <w:t xml:space="preserve">$nEsc</w:t>
      </w:r>
    </w:p>
  </w:tc>
  <w:tc>
    <w:tcPr><w:tcW w:w="1400" w:type="dxa"/><w:shd w:val="clear" w:color="auto" w:fill="$fill"/></w:tcPr>
    <w:p>
      <w:pPr><w:jc w:val="center"/><w:spacing w:before="100" w:after="100"/></w:pPr>
      <w:r><w:rPr><w:rFonts w:ascii="Consolas" w:hAnsi="Consolas"/><w:sz w:val="18"/><w:color w:val="1D6FA4"/></w:rPr>
        <w:t xml:space="preserve">$cEsc</w:t>
      </w:r>
    </w:p>
  </w:tc>
  <w:tc>
    <w:tcPr><w:tcW w:w="3080" w:type="dxa"/><w:shd w:val="clear" w:color="auto" w:fill="$fill"/></w:tcPr>
    <w:p>
      <w:pPr><w:spacing w:before="100" w:after="100"/></w:pPr>
      <w:r><w:rPr><w:rFonts w:ascii="Consolas" w:hAnsi="Consolas"/><w:sz w:val="17"/><w:color w:val="475569"/></w:rPr>
        <w:t>_______________________</w:t>
      </w:r>
    </w:p>
  </w:tc>
  <w:tc>
    <w:tcPr><w:tcW w:w="3080" w:type="dxa"/><w:shd w:val="clear" w:color="auto" w:fill="$fill"/></w:tcPr>
    <w:p>
      <w:pPr><w:spacing w:before="100" w:after="100"/></w:pPr>
      <w:r><w:rPr><w:sz w:val="17"/><w:color w:val="475569"/></w:rPr>
        <w:t>_______________________</w:t>
      </w:r>
    </w:p>
  </w:tc>
</w:tr>
"@
    }

    return @"
<w:tbl>
  <w:tblPr>
    <w:tblW w:w="9360" w:type="dxa"/>
    <w:tblBorders>
      <w:top    w:val="single" w:sz="8" w:space="0" w:color="0F2851"/>
      <w:left   w:val="none"   w:sz="0" w:space="0" w:color="auto"/>
      <w:bottom w:val="single" w:sz="8" w:space="0" w:color="0F2851"/>
      <w:right  w:val="none"   w:sz="0" w:space="0" w:color="auto"/>
      <w:insideH w:val="single" w:sz="4" w:space="0" w:color="DBEAFE"/>
      <w:insideV w:val="none"   w:sz="0" w:space="0" w:color="auto"/>
    </w:tblBorders>
    <w:tblCellMar>
      <w:top    w:w="0"   w:type="dxa"/>
      <w:left   w:w="200" w:type="dxa"/>
      <w:bottom w:w="0"   w:type="dxa"/>
      <w:right  w:w="200" w:type="dxa"/>
    </w:tblCellMar>
  </w:tblPr>
  <w:tblGrid>
    <w:gridCol w:w="1800"/>
    <w:gridCol w:w="1400"/>
    <w:gridCol w:w="3080"/>
    <w:gridCol w:w="3080"/>
  </w:tblGrid>
  $hdr
  $dataRows
</w:tbl>
"@
}

# ============================================================
#  CREAR ESTRUCTURA DE DIRECTORIOS TEMPORALES
# ============================================================
New-Item -ItemType Directory -Force -Path $temp,
    (Join-Path $temp "_rels"),
    (Join-Path $temp "word"),
    (Join-Path $temp "word\_rels") | Out-Null

# ============================================================
#  [Content_Types].xml
# ============================================================
$contentTypes = @'
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types">
  <Default Extension="rels" ContentType="application/vnd.openxmlformats-package.relationships+xml"/>
  <Default Extension="xml"  ContentType="application/xml"/>
  <Override PartName="/word/document.xml"
    ContentType="application/vnd.openxmlformats-officedocument.wordprocessingml.document.main+xml"/>
  <Override PartName="/word/styles.xml"
    ContentType="application/vnd.openxmlformats-officedocument.wordprocessingml.styles+xml"/>
  <Override PartName="/word/header1.xml"
    ContentType="application/vnd.openxmlformats-officedocument.wordprocessingml.header+xml"/>
  <Override PartName="/word/footer1.xml"
    ContentType="application/vnd.openxmlformats-officedocument.wordprocessingml.footer+xml"/>
  <Override PartName="/word/headerFirst.xml"
    ContentType="application/vnd.openxmlformats-officedocument.wordprocessingml.header+xml"/>
  <Override PartName="/word/footerFirst.xml"
    ContentType="application/vnd.openxmlformats-officedocument.wordprocessingml.footer+xml"/>
</Types>
'@

# ============================================================
#  _rels/.rels
# ============================================================
$rels = @'
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
  <Relationship Id="rId1"
    Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument"
    Target="word/document.xml"/>
</Relationships>
'@

# ============================================================
#  word/_rels/document.xml.rels
# ============================================================
$documentRels = @'
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
  <Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/header"  Target="header1.xml"/>
  <Relationship Id="rId2" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/footer"  Target="footer1.xml"/>
  <Relationship Id="rId3" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/header"  Target="headerFirst.xml"/>
  <Relationship Id="rId4" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/footer"  Target="footerFirst.xml"/>
</Relationships>
'@

# ============================================================
#  word/header1.xml  (encabezado corriente desde pag 2)
# ============================================================
$header1 = @'
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<w:hdr xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">
  <w:p>
    <w:pPr><w:pStyle w:val="Header"/></w:pPr>
    <w:r>
      <w:rPr><w:b/><w:sz w:val="17"/><w:color w:val="0F2851"/></w:rPr>
      <w:t xml:space="preserve">Cifrado de Informacion  -  UVG</w:t>
    </w:r>
    <w:r>
      <w:tab/>
      <w:rPr><w:sz w:val="17"/><w:color w:val="64748B"/></w:rPr>
      <w:t>Proyecto 1: Cifrados de Flujo  -  Desafios en Seguridad</w:t>
    </w:r>
  </w:p>
</w:hdr>
'@

# ============================================================
#  word/footer1.xml  (pie con numero de pagina)
# ============================================================
$footer1 = @'
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<w:ftr xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">
  <w:p>
    <w:pPr><w:pStyle w:val="Footer"/></w:pPr>
    <w:r><w:fldChar w:fldCharType="begin"/></w:r>
    <w:r><w:instrText xml:space="preserve"> PAGE </w:instrText></w:r>
    <w:r><w:fldChar w:fldCharType="separate"/></w:r>
    <w:r><w:t>1</w:t></w:r>
    <w:r><w:fldChar w:fldCharType="end"/></w:r>
    <w:r><w:rPr><w:color w:val="94A3B8"/></w:rPr>
      <w:t xml:space="preserve">  /  </w:t>
    </w:r>
    <w:r><w:fldChar w:fldCharType="begin"/></w:r>
    <w:r><w:instrText xml:space="preserve"> NUMPAGES </w:instrText></w:r>
    <w:r><w:fldChar w:fldCharType="separate"/></w:r>
    <w:r><w:t>1</w:t></w:r>
    <w:r><w:fldChar w:fldCharType="end"/></w:r>
  </w:p>
</w:ftr>
'@

# ============================================================
#  word/headerFirst.xml / footerFirst.xml  (portada: vacios)
# ============================================================
$headerFirst = @'
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<w:hdr xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">
  <w:p><w:pPr><w:pStyle w:val="Header"/></w:pPr></w:p>
</w:hdr>
'@

$footerFirst = @'
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<w:ftr xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">
  <w:p><w:pPr><w:pStyle w:val="Footer"/></w:pPr></w:p>
</w:ftr>
'@

# ============================================================
#  word/styles.xml
# ============================================================
$styles = @'
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<w:styles xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">

  <w:style w:type="paragraph" w:default="1" w:styleId="Normal">
    <w:name w:val="Normal"/>
    <w:qFormat/>
    <w:pPr><w:spacing w:after="160" w:line="276" w:lineRule="auto"/></w:pPr>
    <w:rPr>
      <w:rFonts w:ascii="Calibri" w:hAnsi="Calibri"/>
      <w:sz w:val="22"/>
      <w:color w:val="1E293B"/>
    </w:rPr>
  </w:style>

  <w:style w:type="paragraph" w:styleId="Header">
    <w:name w:val="header"/>
    <w:basedOn w:val="Normal"/>
    <w:pPr>
      <w:tabs><w:tab w:val="right" w:pos="9360"/></w:tabs>
      <w:spacing w:before="0" w:after="0"/>
      <w:pBdr>
        <w:bottom w:val="single" w:sz="4" w:space="2" w:color="CBD5E1"/>
      </w:pBdr>
    </w:pPr>
    <w:rPr>
      <w:rFonts w:ascii="Calibri" w:hAnsi="Calibri"/>
      <w:sz w:val="17"/>
      <w:color w:val="64748B"/>
    </w:rPr>
  </w:style>

  <w:style w:type="paragraph" w:styleId="Footer">
    <w:name w:val="footer"/>
    <w:basedOn w:val="Normal"/>
    <w:pPr>
      <w:jc w:val="center"/>
      <w:spacing w:before="0" w:after="0"/>
      <w:pBdr>
        <w:top w:val="single" w:sz="4" w:space="2" w:color="CBD5E1"/>
      </w:pBdr>
    </w:pPr>
    <w:rPr>
      <w:sz w:val="17"/>
      <w:color w:val="64748B"/>
    </w:rPr>
  </w:style>

  <w:style w:type="paragraph" w:styleId="Heading1">
    <w:name w:val="heading 1"/>
    <w:basedOn w:val="Normal"/>
    <w:next w:val="Normal"/>
    <w:qFormat/>
    <w:pPr>
      <w:keepNext/>
      <w:spacing w:before="560" w:after="160"/>
      <w:pBdr>
        <w:bottom w:val="single" w:sz="4" w:space="4" w:color="CBD5E1"/>
      </w:pBdr>
    </w:pPr>
    <w:rPr>
      <w:rFonts w:ascii="Calibri Light" w:hAnsi="Calibri Light"/>
      <w:b/><w:sz w:val="30"/>
      <w:color w:val="0F2851"/>
    </w:rPr>
  </w:style>

  <w:style w:type="paragraph" w:styleId="Heading2">
    <w:name w:val="heading 2"/>
    <w:basedOn w:val="Normal"/>
    <w:next w:val="Normal"/>
    <w:qFormat/>
    <w:pPr>
      <w:keepNext/>
      <w:spacing w:before="360" w:after="100"/>
    </w:pPr>
    <w:rPr>
      <w:rFonts w:ascii="Calibri" w:hAnsi="Calibri"/>
      <w:b/><w:sz w:val="24"/>
      <w:color w:val="1D6FA4"/>
    </w:rPr>
  </w:style>

  <w:style w:type="paragraph" w:styleId="Heading3">
    <w:name w:val="heading 3"/>
    <w:basedOn w:val="Normal"/>
    <w:next w:val="Normal"/>
    <w:qFormat/>
    <w:pPr>
      <w:keepNext/>
      <w:spacing w:before="240" w:after="80"/>
    </w:pPr>
    <w:rPr>
      <w:b/><w:i/>
      <w:sz w:val="21"/>
      <w:color w:val="334155"/>
    </w:rPr>
  </w:style>

  <w:style w:type="paragraph" w:styleId="CodeShaded">
    <w:name w:val="CodeShaded"/>
    <w:basedOn w:val="Normal"/>
    <w:pPr>
      <w:shd w:val="clear" w:color="auto" w:fill="F1F5F9"/>
      <w:spacing w:before="0" w:after="0"/>
      <w:ind w:left="300" w:right="200"/>
      <w:pBdr>
        <w:top    w:val="single" w:sz="4" w:space="2" w:color="CBD5E1"/>
        <w:left   w:val="single" w:sz="12" w:space="4" w:color="1D6FA4"/>
        <w:bottom w:val="single" w:sz="4" w:space="2" w:color="CBD5E1"/>
        <w:right  w:val="single" w:sz="4" w:space="4" w:color="CBD5E1"/>
      </w:pBdr>
    </w:pPr>
    <w:rPr>
      <w:rFonts w:ascii="Consolas" w:hAnsi="Consolas"/>
      <w:sz w:val="18"/>
      <w:color w:val="0F172A"/>
    </w:rPr>
  </w:style>

  <w:style w:type="paragraph" w:styleId="InfoBox">
    <w:name w:val="InfoBox"/>
    <w:basedOn w:val="Normal"/>
    <w:pPr>
      <w:shd w:val="clear" w:color="auto" w:fill="EFF6FF"/>
      <w:spacing w:before="140" w:after="140"/>
      <w:ind w:left="400" w:right="240"/>
      <w:pBdr>
        <w:left w:val="single" w:sz="24" w:space="6" w:color="1D6FA4"/>
      </w:pBdr>
    </w:pPr>
    <w:rPr>
      <w:sz w:val="21"/>
      <w:color w:val="1E3A5F"/>
    </w:rPr>
  </w:style>

  <w:style w:type="paragraph" w:styleId="FlagValue">
    <w:name w:val="FlagValue"/>
    <w:basedOn w:val="Normal"/>
    <w:pPr>
      <w:spacing w:before="80" w:after="80"/>
      <w:ind w:left="240"/>
    </w:pPr>
    <w:rPr>
      <w:rFonts w:ascii="Consolas" w:hAnsi="Consolas"/>
      <w:sz w:val="19"/>
      <w:color w:val="334155"/>
    </w:rPr>
  </w:style>

  <w:style w:type="paragraph" w:styleId="ScreenshotPlaceholder">
    <w:name w:val="ScreenshotPlaceholder"/>
    <w:basedOn w:val="Normal"/>
    <w:pPr>
      <w:jc w:val="center"/>
      <w:shd w:val="clear" w:color="auto" w:fill="F8FAFC"/>
      <w:spacing w:before="560" w:after="560"/>
      <w:pBdr>
        <w:top    w:val="dashed" w:sz="6" w:space="6" w:color="94A3B8"/>
        <w:left   w:val="dashed" w:sz="6" w:space="6" w:color="94A3B8"/>
        <w:bottom w:val="dashed" w:sz="6" w:space="6" w:color="94A3B8"/>
        <w:right  w:val="dashed" w:sz="6" w:space="6" w:color="94A3B8"/>
      </w:pBdr>
    </w:pPr>
    <w:rPr>
      <w:i/><w:sz w:val="19"/>
      <w:color w:val="94A3B8"/>
    </w:rPr>
  </w:style>

  <w:style w:type="paragraph" w:styleId="HRule">
    <w:name w:val="HRule"/>
    <w:basedOn w:val="Normal"/>
    <w:pPr>
      <w:spacing w:before="200" w:after="200"/>
      <w:pBdr>
        <w:bottom w:val="single" w:sz="4" w:space="1" w:color="E2E8F0"/>
      </w:pBdr>
    </w:pPr>
    <w:rPr><w:color w:val="FFFFFF"/><w:sz w:val="4"/></w:rPr>
  </w:style>

  <w:style w:type="paragraph" w:styleId="TH">
    <w:name w:val="TH"/>
    <w:basedOn w:val="Normal"/>
    <w:pPr>
      <w:jc w:val="center"/>
      <w:spacing w:before="120" w:after="120"/>
    </w:pPr>
    <w:rPr>
      <w:b/><w:sz w:val="20"/>
      <w:color w:val="FFFFFF"/>
    </w:rPr>
  </w:style>

  <w:style w:type="paragraph" w:styleId="Caption">
    <w:name w:val="caption"/>
    <w:basedOn w:val="Normal"/>
    <w:qFormat/>
    <w:pPr>
      <w:spacing w:before="200" w:after="60"/>
    </w:pPr>
    <w:rPr>
      <w:i/><w:sz w:val="19"/>
      <w:color w:val="64748B"/>
    </w:rPr>
  </w:style>

</w:styles>
'@

# ============================================================
#  CUERPO DEL DOCUMENTO
# ============================================================
$body = New-Object System.Collections.Generic.List[string]

# ------------------------------------------------------------------
# PORTADA
# ------------------------------------------------------------------
$body.Add((New-CoverTopBanner))
$body.Add((New-Spacer 600))

# Titulo principal
$body.Add(@"
<w:p>
  <w:pPr>
    <w:jc w:val="center"/>
    <w:spacing w:before="0" w:after="80"/>
  </w:pPr>
  <w:r>
    <w:rPr>
      <w:rFonts w:ascii="Calibri Light" w:hAnsi="Calibri Light"/>
      <w:sz w:val="21"/><w:color w:val="94A3B8"/>
    </w:rPr>
    <w:t>PROYECTO 1</w:t>
  </w:r>
</w:p>
"@)

$body.Add(@"
<w:p>
  <w:pPr>
    <w:jc w:val="center"/>
    <w:spacing w:before="0" w:after="120"/>
  </w:pPr>
  <w:r>
    <w:rPr>
      <w:rFonts w:ascii="Calibri Light" w:hAnsi="Calibri Light"/>
      <w:b/><w:sz w:val="64"/><w:color w:val="0F2851"/>
    </w:rPr>
    <w:t>Cifrados de Flujo</w:t>
  </w:r>
</w:p>
"@)

$body.Add(@"
<w:p>
  <w:pPr>
    <w:jc w:val="center"/>
    <w:spacing w:before="0" w:after="0"/>
  </w:pPr>
  <w:r>
    <w:rPr>
      <w:rFonts w:ascii="Calibri Light" w:hAnsi="Calibri Light"/>
      <w:sz w:val="28"/><w:color w:val="475569"/>
    </w:rPr>
    <w:t>Desafios en Seguridad</w:t>
  </w:r>
</w:p>
"@)

$body.Add((New-Spacer 160))
$body.Add((New-ColorBar "1D6FA4" 60))
$body.Add((New-Spacer 160))

$body.Add(@"
<w:p>
  <w:pPr>
    <w:jc w:val="center"/>
    <w:spacing w:before="0" w:after="60"/>
  </w:pPr>
  <w:r>
    <w:rPr>
      <w:rFonts w:ascii="Calibri" w:hAnsi="Calibri"/>
      <w:sz w:val="22"/><w:color w:val="334155"/>
    </w:rPr>
    <w:t>CTF One Piece Symmetric Cipher</w:t>
  </w:r>
</w:p>
"@)

$body.Add(@"
<w:p>
  <w:pPr>
    <w:jc w:val="center"/>
    <w:spacing w:before="0" w:after="0"/>
  </w:pPr>
  <w:r>
    <w:rPr>
      <w:rFonts w:ascii="Calibri" w:hAnsi="Calibri"/>
      <w:i/><w:sz w:val="20"/><w:color w:val="64748B"/>
    </w:rPr>
    <w:t>Reporte Tecnico de Resolucion</w:t>
  </w:r>
</w:p>
"@)

$body.Add((New-Spacer 400))

$coverRows = @(
    @("Curso:",       "Cifrado de Informacion  -  Universidad del Valle de Guatemala"),
    @("Estudiante:",  "______________________________________"),
    @("Carne:",       "______________________________________"),
    @("Fecha:",       "______________________________________"),
    @("Repositorio:", "locano-uvg/ctf_onepice_symmetric_cipher")
)
$body.Add((New-CoverInfoTable $coverRows))

$body.Add((New-Spacer 600))
$body.Add((New-ColorBar "1D6FA4" 40))
$body.Add((New-ColorBar "0F2851" 120))

$body.Add((New-PageBreak))

# ------------------------------------------------------------------
# TABLA DE CONTENIDOS
# ------------------------------------------------------------------
$body.Add((New-Paragraph "Tabla de Contenidos" "Heading1"))
$body.Add((New-InfoBox "Actualizar tabla de contenidos al finalizar: clic derecho sobre esta seccion > Actualizar campo."))
$body.Add((New-Spacer 200))
$body.Add((New-PageBreak))

# ------------------------------------------------------------------
# 1. INTRODUCCION
# ------------------------------------------------------------------
$body.Add((New-Paragraph "1.  Introduccion" "Heading1"))
$body.Add((New-Paragraph "En este proyecto se resolvieron cuatro retos practicos de cifrados de flujo inspirados en One Piece. Cada reto consistio en localizar archivos dentro de una estructura de carpetas generada aleatoriamente, extraer datos cifrados, aplicar el algoritmo correspondiente y documentar la flag y el texto del poneglyph recuperado."))
$body.Add((New-Paragraph "Los algoritmos abarcados van desde el clasico XOR hasta el moderno ChaCha20, pasando por RC4 y un cifrado personalizado basado en PRNG, permitiendo comparar sus fortalezas y debilidades."))
$body.Add((New-HRule))
$body.Add((New-PageBreak))

# ------------------------------------------------------------------
# 2. ENTORNO DE TRABAJO
# ------------------------------------------------------------------
$body.Add((New-Paragraph "2.  Entorno de trabajo" "Heading1"))
$body.Add((New-Paragraph "Sistema operativo / terminal: Ubuntu WSL (Windows Subsystem for Linux)"))
$body.Add((New-Paragraph "Herramientas principales: find, 7z, exiftool, xxd, perl, python3, Docker Compose"))
$body.Add((New-Paragraph "Configuracion inicial" "Heading2"))
$body.Add((New-CodeBlock "cd <ruta del repositorio>"))
$body.Add((New-CodeBlock "python3 -m venv .venv && source .venv/bin/activate"))
$body.Add((New-CodeBlock "python3 -m pip install -r resources/requirements.txt"))
$body.Add((New-CodeBlock "python generate_challenges.py"))
$body.Add((New-CodeBlock "docker compose up -d --build"))
$body.Add((New-CodeBlock "docker ps"))
$body.Add((New-Spacer 120))
$body.Add((New-ScreenshotBox "Captura 1  -  Generacion de retos y contenedores Docker activos."))
$body.Add((New-HRule))

# ------------------------------------------------------------------
# 3. METODOLOGIA GENERAL
# ------------------------------------------------------------------
$body.Add((New-Paragraph "3.  Metodologia general" "Heading1"))
$body.Add((New-Paragraph "Para cada reto se siguio el mismo flujo de trabajo:"))
$body.Add((New-InfoBox "1  Buscar archivos flag.txt cuyo contenido sea hexadecimal puro (descartar senuelos con texto legible)."))
$body.Add((New-InfoBox "2  Localizar el ZIP correcto data_*.zip extrayendo su imagen y revisando el campo EXIF Artist."))
$body.Add((New-InfoBox "3  Si Artist contiene hex, descifrar con XOR usando el carne del estudiante para obtener el poneglyph."))
$body.Add((New-InfoBox "4  Aplicar el algoritmo del reto al ciphertext para recuperar la flag, que a su vez desbloquea el siguiente ZIP."))
$body.Add((New-HRule))
$body.Add((New-PageBreak))

# ------------------------------------------------------------------
# 4. RETO LUFFY  -  XOR
# ------------------------------------------------------------------
$body.Add((New-ChallengeBanner "4" "Monkey D. Luffy" "XOR" "0F2851" "1D6FA4"))
$body.Add((New-Spacer 80))
$body.Add((New-InfoBox "Objetivo: recuperar la flag cifrada con XOR (clave = carne). Contrasena inicial del ZIP: onepiece"))
$body.Add((New-Paragraph "Comandos principales" "Heading2"))
$body.Add((New-CodeBlock 'export CARNE="TU_CARNE_AQUI"'))
$body.Add((New-CodeBlock 'LUFFY_FLAG_FILE=$(find_real_flag luffy)'))
$body.Add((New-CodeBlock 'LUFFY_HEX=$(tr -d "\r\n" < "$LUFFY_FLAG_FILE")'))
$body.Add((New-CodeBlock 'LUFFY_FLAG=$(xor_hex "$LUFFY_HEX" "$CARNE")'))
$body.Add((New-CodeBlock 'echo "$LUFFY_FLAG"'))
$body.Add((New-CodeBlock 'LUFFY_PONEGLYPH=$(decrypt_poneglyph luffy "onepiece")'))
$body.Add((New-CodeBlock 'echo "$LUFFY_PONEGLYPH"'))
$body.Add((New-Spacer 120))
$body.Add((New-ScreenshotBox "Captura 2  -  Busqueda del flag.txt real y descifrado XOR de Luffy."))
$body.Add((New-Paragraph "Resultados" "Heading2"))
$body.Add((New-FlagLine "Flag encontrada:"))
$body.Add((New-Paragraph "Poneglyph extraido:" "Heading3"))
$body.Add((New-CodeBlock "_______________________________________________________________________"))
$body.Add((New-InfoBox "Analisis tecnico: XOR es involutivo  -  aplicarlo dos veces con la misma clave recupera el plaintext. La debilidad principal es la reutilizacion de clave: si dos mensajes usan el mismo pad se pueden combinar (crib dragging) para deducir ambos plaintexts."))
$body.Add((New-HRule))
$body.Add((New-PageBreak))

# ------------------------------------------------------------------
# 5. RETO ZORO  -  RC4
# ------------------------------------------------------------------
$body.Add((New-ChallengeBanner "5" "Roronoa Zoro" "RC4" "0F2851" "0F766E"))
$body.Add((New-Spacer 80))
$body.Add((New-InfoBox "Objetivo: descifrar la flag con RC4. Clave = carne. Contrasena del ZIP: flag de Luffy."))
$body.Add((New-Paragraph "Comandos principales" "Heading2"))
$body.Add((New-CodeBlock 'ZORO_FLAG_FILE=$(find_real_flag zoro)'))
$body.Add((New-CodeBlock 'ZORO_HEX=$(tr -d "\r\n" < "$ZORO_FLAG_FILE")'))
$body.Add((New-CodeBlock 'ZORO_FLAG=$(rc4_hex "$ZORO_HEX" "$CARNE")'))
$body.Add((New-CodeBlock 'echo "$ZORO_FLAG"'))
$body.Add((New-CodeBlock 'ZORO_PONEGLYPH=$(decrypt_poneglyph zoro "$LUFFY_FLAG")'))
$body.Add((New-CodeBlock 'echo "$ZORO_PONEGLYPH"'))
$body.Add((New-Spacer 120))
$body.Add((New-ScreenshotBox "Captura 3  -  Busqueda del flag.txt real y descifrado RC4 de Zoro."))
$body.Add((New-Paragraph "Resultados" "Heading2"))
$body.Add((New-FlagLine "Flag encontrada:"))
$body.Add((New-Paragraph "Poneglyph extraido:" "Heading3"))
$body.Add((New-CodeBlock "_______________________________________________________________________"))
$body.Add((New-InfoBox "Analisis tecnico: RC4 usa KSA para inicializar una permutacion S[256] con la clave, y PRGA para emitir el keystream. Vulnerabilidades documentadas: sesgo estadistico en los primeros bytes (ataques de Fluhrer-Mantin-Shamir) y la inseguridad de WEP que lo descontinuo."))
$body.Add((New-HRule))
$body.Add((New-PageBreak))

# ------------------------------------------------------------------
# 6. RETO USOPP  -  PRNG CUSTOM
# ------------------------------------------------------------------
$body.Add((New-ChallengeBanner "6" "Usopp" "PRNG Custom" "0F2851" "92400E"))
$body.Add((New-Spacer 80))
$body.Add((New-InfoBox "Objetivo: descifrar la flag con el PRNG de Python (semilla fija 1234). Contrasena del ZIP: flag de Zoro."))
$body.Add((New-Paragraph "Comandos principales" "Heading2"))
$body.Add((New-CodeBlock 'USOPP_FLAG_FILE=$(find_real_flag usopp)'))
$body.Add((New-CodeBlock 'USOPP_HEX=$(tr -d "\r\n" < "$USOPP_FLAG_FILE")'))
$body.Add((New-CodeBlock 'USOPP_FLAG=$(python3 - "$USOPP_HEX" <<''PY'''))
$body.Add((New-CodeBlock 'import random, sys'))
$body.Add((New-CodeBlock 'cipher = bytes.fromhex(sys.argv[1])'))
$body.Add((New-CodeBlock 'random.seed(1234)'))
$body.Add((New-CodeBlock 'ks = bytes(random.randint(0,255) for _ in range(len(cipher)))'))
$body.Add((New-CodeBlock 'print(bytes(c^k for c,k in zip(cipher,ks)).decode())'))
$body.Add((New-CodeBlock 'PY'))
$body.Add((New-CodeBlock 'echo "$USOPP_FLAG"'))
$body.Add((New-CodeBlock 'USOPP_PONEGLYPH=$(decrypt_poneglyph usopp "$ZORO_FLAG")'))
$body.Add((New-Spacer 120))
$body.Add((New-ScreenshotBox "Captura 4  -  Busqueda del flag.txt real y descifrado PRNG de Usopp."))
$body.Add((New-Paragraph "Resultados" "Heading2"))
$body.Add((New-FlagLine "Flag encontrada:"))
$body.Add((New-Paragraph "Poneglyph extraido:" "Heading3"))
$body.Add((New-CodeBlock "_______________________________________________________________________"))
$body.Add((New-InfoBox "Analisis tecnico: al usar random.seed(1234) (semilla publica y fija) cualquier atacante puede regenerar el keystream exacto sin conocer la clave. Esto hace el cifrado trivialmente rompible y ejemplifica por que los PRNGs de proposito general no son criptograficamente seguros."))
$body.Add((New-HRule))
$body.Add((New-PageBreak))

# ------------------------------------------------------------------
# 7. RETO NAMI  -  ChaCha20
# ------------------------------------------------------------------
$body.Add((New-ChallengeBanner "7" "Nami" "ChaCha20" "0F2851" "4338CA"))
$body.Add((New-Spacer 80))
$body.Add((New-InfoBox "Objetivo: descifrar con ChaCha20. Clave 32 bytes y nonce 8 bytes derivados del carne. Contrasena del ZIP: flag de Usopp."))
$body.Add((New-Paragraph "Comandos principales" "Heading2"))
$body.Add((New-CodeBlock 'NAMI_FLAG_FILE=$(find_real_flag nami)'))
$body.Add((New-CodeBlock 'NAMI_HEX=$(tr -d "\r\n" < "$NAMI_FLAG_FILE")'))
$body.Add((New-CodeBlock 'NAMI_FLAG=$(python3 - "$NAMI_HEX" "$CARNE" <<''PY'''))
$body.Add((New-CodeBlock 'import sys; from Crypto.Cipher import ChaCha20'))
$body.Add((New-CodeBlock 'c = bytes.fromhex(sys.argv[1]); sid = sys.argv[2]'))
$body.Add((New-CodeBlock 'key = (sid.encode()*32)[:32]; nonce = (sid.encode()*8)[:8]'))
$body.Add((New-CodeBlock 'print(ChaCha20.new(key=key,nonce=nonce).decrypt(c).decode())'))
$body.Add((New-CodeBlock 'PY'))
$body.Add((New-CodeBlock 'echo "$NAMI_FLAG"'))
$body.Add((New-CodeBlock 'NAMI_PONEGLYPH=$(decrypt_poneglyph nami "$USOPP_FLAG")'))
$body.Add((New-Spacer 120))
$body.Add((New-ScreenshotBox "Captura 5  -  Busqueda del flag.txt real y descifrado ChaCha20 de Nami."))
$body.Add((New-Paragraph "Resultados" "Heading2"))
$body.Add((New-FlagLine "Flag encontrada:"))
$body.Add((New-Paragraph "Poneglyph extraido:" "Heading3"))
$body.Add((New-CodeBlock "_______________________________________________________________________"))
$body.Add((New-InfoBox "Analisis tecnico: ChaCha20 usa operaciones ARX en 20 rondas sobre un estado de 512 bits, evitando ataques de cache-timing que afectan a AES. La seguridad del reto depende de una derivacion de clave adecuada: repetir el carne es funcional pero no equivale a una KDF real como HKDF."))
$body.Add((New-HRule))
$body.Add((New-PageBreak))

# ------------------------------------------------------------------
# 8. RESUMEN DE RESULTADOS
# ------------------------------------------------------------------
$body.Add((New-Paragraph "8.  Resumen de resultados" "Heading1"))
$body.Add((New-ResultsTable))
$body.Add((New-Spacer 200))
$body.Add((New-ScreenshotBox "Captura 6  -  Contenido final de flags.txt y poneglyphs.txt."))
$body.Add((New-HRule))

# ------------------------------------------------------------------
# 9. REFLEXION FINAL
# ------------------------------------------------------------------
$body.Add((New-Paragraph "9.  Reflexion final" "Heading1"))
$body.Add((New-Paragraph "La secuencia de retos ilustra la evolucion de los cifrados de flujo: desde XOR (simple, reutilizable y fragil) hasta ChaCha20 (moderno, con garantias de seguridad demostrables). RC4 ocupa un punto intermedio  -  funcionalmente correcto pero con sesgos estadisticos que lo descartaron en protocolos modernos. El reto de Usopp demuestra que la debilidad no siempre esta en el algoritmo sino en la implementacion, especialmente en la gestion de la semilla."))
$body.Add((New-InfoBox "Conclusion: la seguridad de un cifrado de flujo depende del algoritmo, de la calidad de la clave, de la unicidad del nonce y de la imprevisibilidad del keystream. Fallar en cualquiera de estos puntos invalida el esquema completo."))
$body.Add((New-HRule))

# ------------------------------------------------------------------
# 10. ANEXOS
# ------------------------------------------------------------------
$body.Add((New-Paragraph "10.  Anexos" "Heading1"))
$body.Add((New-Paragraph "flags.txt  -  incluir las cuatro flags extraidas durante la resolucion."))
$body.Add((New-Paragraph "poneglyphs.txt  -  incluir los cuatro textos recuperados de las imagenes EXIF."))
$body.Add((New-Paragraph "Referencia de comandos  -  ver GUIA_RESOLUCION_LINUX.md en la raiz del repositorio."))

# ============================================================
#  sectPr  (header/footer + first-page-different)
# ============================================================
$section = @"
<w:sectPr>
  <w:headerReference w:type="default" r:id="rId1"/>
  <w:footerReference w:type="default" r:id="rId2"/>
  <w:headerReference w:type="first"   r:id="rId3"/>
  <w:footerReference w:type="first"   r:id="rId4"/>
  <w:titlePg/>
  <w:pgSz w:w="12240" w:h="15840"/>
  <w:pgMar w:top="1440" w:right="1440" w:bottom="1440" w:left="1440"
           w:header="720" w:footer="720" w:gutter="0"/>
</w:sectPr>
"@

# ============================================================
#  word/document.xml
# ============================================================
$document = @"
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<w:document
  xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main"
  xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships">
  <w:body>
$($body -join "`n")
$section
  </w:body>
</w:document>
"@

# ============================================================
#  ESCRIBIR XML AL DIRECTORIO TEMPORAL
# ============================================================
Write-Utf8NoBom (Join-Path $temp "[Content_Types].xml")          $contentTypes
Write-Utf8NoBom (Join-Path $temp "_rels\.rels")                  $rels
Write-Utf8NoBom (Join-Path $temp "word\_rels\document.xml.rels") $documentRels
Write-Utf8NoBom (Join-Path $temp "word\styles.xml")              $styles
Write-Utf8NoBom (Join-Path $temp "word\document.xml")            $document
Write-Utf8NoBom (Join-Path $temp "word\header1.xml")             $header1
Write-Utf8NoBom (Join-Path $temp "word\footer1.xml")             $footer1
Write-Utf8NoBom (Join-Path $temp "word\headerFirst.xml")         $headerFirst
Write-Utf8NoBom (Join-Path $temp "word\footerFirst.xml")         $footerFirst

# ============================================================
#  EMPAQUETAR COMO .docx  (ZIP)
# ============================================================
if (Test-Path -LiteralPath $output) { Remove-Item -LiteralPath $output -Force }

Add-Type -AssemblyName System.IO.Compression

function Add-ZipEntry {
    param(
        [System.IO.Compression.ZipArchive]$Archive,
        [string]$EntryName,
        [string]$SourcePath
    )
    $entry       = $Archive.CreateEntry($EntryName)
    $entryStream = $entry.Open()
    $fileStream  = [System.IO.File]::OpenRead($SourcePath)
    try   { $fileStream.CopyTo($entryStream) }
    finally { $fileStream.Dispose(); $entryStream.Dispose() }
}

$zipStream = [System.IO.File]::Open($output, [System.IO.FileMode]::CreateNew)
$archive   = New-Object System.IO.Compression.ZipArchive($zipStream, [System.IO.Compression.ZipArchiveMode]::Create)
try {
    Add-ZipEntry $archive "[Content_Types].xml"          (Join-Path $temp "[Content_Types].xml")
    Add-ZipEntry $archive "_rels/.rels"                  (Join-Path $temp "_rels\.rels")
    Add-ZipEntry $archive "word/document.xml"            (Join-Path $temp "word\document.xml")
    Add-ZipEntry $archive "word/styles.xml"              (Join-Path $temp "word\styles.xml")
    Add-ZipEntry $archive "word/_rels/document.xml.rels" (Join-Path $temp "word\_rels\document.xml.rels")
    Add-ZipEntry $archive "word/header1.xml"             (Join-Path $temp "word\header1.xml")
    Add-ZipEntry $archive "word/footer1.xml"             (Join-Path $temp "word\footer1.xml")
    Add-ZipEntry $archive "word/headerFirst.xml"         (Join-Path $temp "word\headerFirst.xml")
    Add-ZipEntry $archive "word/footerFirst.xml"         (Join-Path $temp "word\footerFirst.xml")
} finally {
    $archive.Dispose()
    $zipStream.Dispose()
    Remove-Item -LiteralPath $temp -Recurse -Force
}

Write-Host "Documento generado: $output"
