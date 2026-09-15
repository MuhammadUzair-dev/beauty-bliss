# ============================================================
#  Beauty Bliss USA - Branded placeholder image generator
#  Generates labeled placeholder JPGs so the HTML/CSS demo
#  renders correctly. Overwrite these exact filenames with the
#  client's real photos when they arrive (same name, zero code
#  changes needed).
# ============================================================
Add-Type -AssemblyName System.Drawing

$dir = 'd:\Work\Beauty Bliss\images'
New-Item -ItemType Directory -Force -Path $dir | Out-Null

function Initialize-Graphics {
  param($bmp)
  $g = [System.Drawing.Graphics]::FromImage($bmp)
  $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
  $g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit
  return $g
}

function New-GradientPlaceholder {
  param(
    [string]$Path,
    [int]$W,
    [int]$H,
    [string]$ColorA,
    [string]$ColorB,
    [string]$Title,
    [string]$Subtitle,
    [string]$Hint = 'Replace with real photo'
  )
  $bmp = New-Object System.Drawing.Bitmap($W, $H)
  $g = Initialize-Graphics $bmp
  $rect = New-Object System.Drawing.Rectangle(0, 0, $W, $H)
  $c1 = [System.Drawing.ColorTranslator]::FromHtml($ColorA)
  $c2 = [System.Drawing.ColorTranslator]::FromHtml($ColorB)
  $grad = New-Object System.Drawing.Drawing2D.LinearGradientBrush($rect, $c1, $c2, 90)
  $g.FillRectangle($grad, $rect)

  $motif = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(24, 255, 255, 255))
  $g.FillEllipse($motif, -100, -80, 420, 420)
  $g.FillEllipse($motif, ($W - 260), ($H - 260), 380, 380)

  $fmt = New-Object System.Drawing.StringFormat
  $fmt.Alignment = [System.Drawing.StringAlignment]::Center
  $fmt.LineAlignment = [System.Drawing.StringAlignment]::Center

  $titleFont = New-Object System.Drawing.Font('Georgia', 60, [System.Drawing.FontStyle]::Bold, [System.Drawing.GraphicsUnit]::Pixel)
  $titleBrush = New-Object System.Drawing.SolidBrush([System.Drawing.ColorTranslator]::FromHtml('#F5EDD4'))
  $rectT = New-Object System.Drawing.RectangleF(30, ($H / 2 - 140), ($W - 60), 100)
  $g.DrawString($Title, $titleFont, $titleBrush, $rectT, $fmt)

  $subFont = New-Object System.Drawing.Font('Segoe UI', 30, [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Pixel)
  $subBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 216, 228, 246))
  $rectS = New-Object System.Drawing.RectangleF(30, ($H / 2 - 20), ($W - 60), 60)
  $g.DrawString($Subtitle, $subFont, $subBrush, $rectS, $fmt)

  $hintFont = New-Object System.Drawing.Font('Segoe UI', 18, [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Pixel)
  $hintBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(170, 232, 237, 245))
  $rectH = New-Object System.Drawing.RectangleF(30, ($H / 2 + 70), ($W - 60), 40)
  $g.DrawString($Hint, $hintFont, $hintBrush, $rectH, $fmt)

  $bmp.Save($Path, [System.Drawing.Imaging.ImageFormat]::Jpeg)
  $g.Dispose()
  $bmp.Dispose()
}

# --- Slot 1: owner applying makeup (main About photo) ---
New-GradientPlaceholder -Path (Join-Path $dir 'owner-makeup.jpeg') -W 800 -H 1000 -ColorA '#1B3A6B' -ColorB '#2C5293' -Title 'Owner Photo' -Subtitle 'Makeup artistry in action'

# --- Slot 2: second About photo (overlay card) ---
New-GradientPlaceholder -Path (Join-Path $dir 'owner-portrait.jpg') -W 800 -H 1000 -ColorA '#E8DFF5' -ColorB '#F5EDD4' -Title 'Founder Photo' -Subtitle 'Signature Beauty Bliss look'

# --- Logo chip placeholder ---
$W = 500; $H = 500
$bmp = New-Object System.Drawing.Bitmap($W, $H)
$g = Initialize-Graphics $bmp
$g.Clear([System.Drawing.Color]::White)

$gold = [System.Drawing.Color]::FromArgb(255, 201, 168, 76)
$blue = [System.Drawing.Color]::FromArgb(255, 27, 58, 107)

$penGold = New-Object System.Drawing.Pen($gold, 14)
$penBlue = New-Object System.Drawing.Pen($blue, 4)
$g.DrawEllipse($penGold, 20, 20, 460, 460)
$g.DrawEllipse($penBlue, 42, 42, 416, 416)

$fmt = New-Object System.Drawing.StringFormat
$fmt.Alignment = [System.Drawing.StringAlignment]::Center
$fmt.LineAlignment = [System.Drawing.StringAlignment]::Center

$fontBB = New-Object System.Drawing.Font('Georgia', 110, [System.Drawing.FontStyle]::Bold, [System.Drawing.GraphicsUnit]::Pixel)
$blueBrush = New-Object System.Drawing.SolidBrush($blue)
$rectBB = New-Object System.Drawing.RectangleF(0, 90, 500, 170)
$g.DrawString('BB', $fontBB, $blueBrush, $rectBB, $fmt)

$fontBrand = New-Object System.Drawing.Font('Georgia', 30, [System.Drawing.FontStyle]::Bold, [System.Drawing.GraphicsUnit]::Pixel)
$goldBrush = New-Object System.Drawing.SolidBrush($gold)
$rectBrand = New-Object System.Drawing.RectangleF(40, 300, 420, 60)
$g.DrawString('BeautyBliss USA', $fontBrand, $goldBrush, $rectBrand, $fmt)

$fontTag = New-Object System.Drawing.Font('Segoe UI', 16, [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Pixel)
$grayBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 107, 114, 128))
$rectTag = New-Object System.Drawing.RectangleF(40, 365, 420, 40)
$g.DrawString('Skincare & Makeup - Logo placeholder', $fontTag, $grayBrush, $rectTag, $fmt)

$bmp.Save((Join-Path $dir 'logo.jpeg'), [System.Drawing.Imaging.ImageFormat]::Jpeg)
$g.Dispose()
$bmp.Dispose()

Write-Host 'Placeholder images generated:'
Get-ChildItem $dir | ForEach-Object { Write-Host ("  {0}  ({1} KB)" -f $_.Name, [math]::Round($_.Length / 1KB)) }