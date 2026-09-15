# Validation script for Beauty Bliss site — checks HTML tag balance, leftover markers, CSS braces
$ErrorActionPreference = 'Continue'
$root = 'd:\Work\Beauty Bliss'
$htmlFiles = @('index.html','about.html','services.html','contact.html','blog.html','blog-post.html','blog-post-2.html','blog-post-3.html','blog-post-4.html','blog-post-5.html','blog-post-6.html','blog-post-7.html')
$fail = 0

foreach ($f in $htmlFiles) {
  $path = Join-Path $root $f
  if (-not (Test-Path $path)) { Write-Host "MISSING: $f"; $fail++; continue }
  $c = Get-Content $path -Raw
  $pairs = @('div','article','section','ul','ol','header','footer','aside','nav')
  $issues = @()
  foreach ($t in $pairs) {
    $open = ([regex]::Matches($c, '<' + $t + '[ >]')).Count
    $close = ([regex]::Matches($c, '</' + $t + '>')).Count
    if ($open -ne $close) { $issues += "$t $open/$close" }
  }
  # span/a/p/li/h1-h4 need faster heuristics via manual counters
  $sp = ([regex]::Matches($c, '<span[ >]')).Count
  $spc = ([regex]::Matches($c, '</span>')).Count
  if ($sp -ne $spc) { $issues += "span $sp/$spc" }
  $ap = ([regex]::Matches($c, '<a[ >]')).Count
  $ac = ([regex]::Matches($c, '</a>')).Count
  if ($ap -ne $ac) { $issues += "a $ap/$ac" }
  $pp = ([regex]::Matches($c, '<p[ >]')).Count
  $pc = ([regex]::Matches($c, '</p>')).Count
  if ($pp -ne $pc) { $issues += "p $pp/$pc" }
  $lp = ([regex]::Matches($c, '<li[ >]')).Count
  $lc = ([regex]::Matches($c, '</li>')).Count
  if ($lp -ne $lc) { $issues += "li $lp/$lc" }
  for ($h = 1; $h -le 4; $h++) {
    $ho = ([regex]::Matches($c, '<h' + $h + '[ >]')).Count
    $hc = ([regex]::Matches($c, '</h' + $h + '>')).Count
    if ($ho -ne $hc) { $issues += "h$h $ho/$hc" }
  }
  $markers = ([regex]::Matches($c, '@@|\{\{|}}')).Count
  $htmlClose = ([regex]::Matches($c, '</html>')).Count
  if ($htmlClose -ne 1) { $issues += "html-close $htmlClose" }
  $lines = (Get-Content $path).Count
  if ($issues.Count -gt 0) { Write-Host ("FAIL $f : " + ($issues -join ', ')); $fail++ }
  elseif ($markers -gt 0) { Write-Host "FAIL $f : $markers leftover marker(s)"; $fail++ }
  else { Write-Host "OK   $f ($lines lines)" }
}

# CSS brace balance
$cssPath = Join-Path $root 'css\style.css'
$css = Get-Content $cssPath -Raw
$co = ([regex]::Matches($css, '\{')).Count
$cc = ([regex]::Matches($css, '\}')).Count
if ($co -ne $cc) { Write-Host "FAIL style.css braces $co/$cc"; $fail++ } else { Write-Host "OK   style.css braces $co/$cc" }

# Cross-link checks
$blog = Get-Content (Join-Path $root 'blog.html') -Raw
$cards = ([regex]::Matches($blog, '<article class="blog-card')).Count
if ($cards -ne 6) { Write-Host "FAIL blog.html card count = $cards"; $fail++ } else { Write-Host "OK   blog.html 6 cards" }
if ($blog -notmatch 'blog-post-2\.html') { Write-Host 'FAIL blog.html missing link to blog-post-2.html'; $fail++ } else { Write-Host 'OK   blog.html links to blog-post-2.html' }
if ($blog -notmatch 'blog-post-3\.html') { Write-Host 'FAIL blog.html missing link to blog-post-3.html'; $fail++ } else { Write-Host 'OK   blog.html links to blog-post-3.html' }
if ($blog -notmatch 'blog-post-4\.html') { Write-Host 'FAIL blog.html missing link to blog-post-4.html'; $fail++ } else { Write-Host 'OK   blog.html links to blog-post-4.html' }
if ($blog -notmatch 'blog-post-5\.html') { Write-Host 'FAIL blog.html missing link to blog-post-5.html'; $fail++ } else { Write-Host 'OK   blog.html links to blog-post-5.html' }
if ($blog -notmatch 'blog-post-6\.html') { Write-Host 'FAIL blog.html missing link to blog-post-6.html'; $fail++ } else { Write-Host 'OK   blog.html links to blog-post-6.html' }
if ($blog -notmatch 'blog-post-7\.html') { Write-Host 'FAIL blog.html missing link to blog-post-7.html'; $fail++ } else { Write-Host 'OK   blog.html links to blog-post-7.html' }

$post = Get-Content (Join-Path $root 'blog-post-2.html') -Raw
$p1 = $post.IndexOf('blog-post.html') -ge 0
$ct = ($post -match 'contact\.html') -and ($post -match 'wa\.me')
$sections = ([regex]::Matches($post, '<h2>')).Count
$signs = ([regex]::Matches($post, 'sign-list__num')).Count
Write-Host "OK   blog-post-2 has $sections sections, $signs sign marks"
if (-not $p1) { Write-Host 'FAIL blog-post-2 missing link back to blog-post.html'; $fail++ }

$post1 = Get-Content (Join-Path $root 'blog-post.html') -Raw
if ($post1 -notmatch 'blog-post-2\.html') { Write-Host 'FAIL blog-post.html missing link to blog-post-2.html'; $fail++ } else { Write-Host 'OK   blog-post.html cross-links to blog-post-2.html' }

$post2 = Get-Content (Join-Path $root 'blog-post-2.html') -Raw
if ($post2 -notmatch 'blog-post-3\.html') { Write-Host 'FAIL blog-post-2 missing link to blog-post-3.html'; $fail++ } else { Write-Host 'OK   blog-post-2 cross-links to blog-post-3.html' }

$post3 = Get-Content (Join-Path $root 'blog-post-3.html') -Raw
$h2c = ([regex]::Matches($post3, '<h2>')).Count
if ($h2c -ne 9) { Write-Host "FAIL blog-post-3 h2 sections = $h2c (expect 9)"; $fail++ } else { Write-Host "OK   blog-post-3 has $h2c sections" }
if ($post3 -notmatch 'blog-post-2\.html') { Write-Host 'FAIL blog-post-3 missing link to blog-post-2.html'; $fail++ }
if ($post3 -notmatch 'blog-post\.html') { Write-Host 'FAIL blog-post-3 missing link to blog-post.html'; $fail++ }
if ($post3 -notmatch 'blog-post-4\.html') { Write-Host 'FAIL blog-post-3 missing link to blog-post-4.html'; $fail++ } else { Write-Host 'OK   blog-post-3 cross-links to blog-post-4.html' }

$post4 = Get-Content (Join-Path $root 'blog-post-4.html') -Raw
$h2d = ([regex]::Matches($post4, '<h2>')).Count
$steps = ([regex]::Matches($post4, 'sign-list__num')).Count
if ($h2d -ne 11) { Write-Host "FAIL blog-post-4 h2 sections = $h2d (expect 11)"; $fail++ } else { Write-Host "OK   blog-post-4 has $h2d sections" }
if ($steps -ne 5) { Write-Host "FAIL blog-post-4 step cards = $steps (expect 5)"; $fail++ } else { Write-Host "OK   blog-post-4 has $steps step cards" }
if (($post4 -notmatch 'contact\.html') -or ($post4 -notmatch 'wa\.me')) { Write-Host 'FAIL blog-post-4 missing contact / WhatsApp links'; $fail++ } else { Write-Host 'OK   blog-post-4 has contact + WhatsApp links' }
if ($post4 -notmatch 'blog-post-2\.html') { Write-Host 'FAIL blog-post-4 missing link to blog-post-2.html'; $fail++ } else { Write-Host 'OK   blog-post-4 cross-links to blog-post-2.html' }
if ($post4 -notmatch 'blog-post-3\.html') { Write-Host 'FAIL blog-post-4 missing link to blog-post-3.html'; $fail++ } else { Write-Host 'OK   blog-post-4 cross-links to blog-post-3.html' }
if ($post4 -notmatch 'Dr\. Butool Kazmi') { Write-Host 'FAIL blog-post-4 missing author attribution'; $fail++ } else { Write-Host 'OK   blog-post-4 author attribution present' }

$post5 = Get-Content (Join-Path $root 'blog-post-5.html') -Raw
$h2e = ([regex]::Matches($post5, '<h2>')).Count
$cards5 = ([regex]::Matches($post5, 'class="info-card"')).Count
$checks5 = ([regex]::Matches($post5, 'article-list--check')).Count
$cross5 = ([regex]::Matches($post5, 'article-list--cross')).Count
if ($h2e -ne 11) { Write-Host "FAIL blog-post-5 h2 sections = $h2e (expect 11)"; $fail++ } else { Write-Host "OK   blog-post-5 has $h2e sections" }
if ($cards5 -ne 7) { Write-Host "FAIL blog-post-5 info cards = $cards5 (expect 7)"; $fail++ } else { Write-Host "OK   blog-post-5 has $cards5 info cards" }
if (($checks5 -lt 2) -or ($cross5 -lt 1)) { Write-Host "FAIL blog-post-5 check/cross lists missing"; $fail++ } else { Write-Host "OK   blog-post-5 check + cross lists present" }
if (($post5 -notmatch 'contact\.html') -or ($post5 -notmatch 'wa\.me')) { Write-Host 'FAIL blog-post-5 missing contact / WhatsApp links'; $fail++ } else { Write-Host 'OK   blog-post-5 has contact + WhatsApp links' }
if ($post5 -notmatch 'blog-post-4\.html') { Write-Host 'FAIL blog-post-5 missing link to blog-post-4.html'; $fail++ } else { Write-Host 'OK   blog-post-5 cross-links to blog-post-4.html' }
if ($post5 -notmatch 'blog-post-3\.html') { Write-Host 'FAIL blog-post-5 missing link to blog-post-3.html'; $fail++ } else { Write-Host 'OK   blog-post-5 cross-links to blog-post-3.html' }
if ($post5 -notmatch 'Dr\. Butool Kazmi') { Write-Host 'FAIL blog-post-5 missing author attribution'; $fail++ } else { Write-Host 'OK   blog-post-5 author attribution present' }

foreach ($n in @('blog-post.html','blog-post-2.html','blog-post-3.html','blog-post-4.html')) {
  $verif = Get-Content (Join-Path $root $n) -Raw
  if ($verif -notmatch 'blog-post-5\.html') { Write-Host "FAIL $n missing link to blog-post-5.html"; $fail++ } else { Write-Host "OK   $n cross-links to blog-post-5.html" }
}

$post6 = Get-Content (Join-Path $root 'blog-post-6.html') -Raw
$h2f = ([regex]::Matches($post6, '<h2>')).Count
$cards6 = ([regex]::Matches($post6, 'class="info-card"')).Count
$checks6 = ([regex]::Matches($post6, 'article-list--check')).Count
$cross6 = ([regex]::Matches($post6, 'article-list--cross')).Count
if ($h2f -ne 11) { Write-Host "FAIL blog-post-6 h2 sections = $h2f (expect 11)"; $fail++ } else { Write-Host "OK   blog-post-6 has $h2f sections" }
if ($cards6 -ne 4) { Write-Host "FAIL blog-post-6 info cards = $cards6 (expect 4)"; $fail++ } else { Write-Host "OK   blog-post-6 has $cards6 info cards" }
if (($checks6 -lt 1) -or ($cross6 -lt 1)) { Write-Host "FAIL blog-post-6 check/cross lists missing"; $fail++ } else { Write-Host "OK   blog-post-6 check + cross lists present" }
if (($post6 -notmatch 'contact\.html') -or ($post6 -notmatch 'wa\.me')) { Write-Host 'FAIL blog-post-6 missing contact / WhatsApp links'; $fail++ } else { Write-Host 'OK   blog-post-6 has contact + WhatsApp links' }
if ($post6 -notmatch 'blog-post-5\.html') { Write-Host 'FAIL blog-post-6 missing link to blog-post-5.html'; $fail++ } else { Write-Host 'OK   blog-post-6 cross-links to blog-post-5.html' }
if ($post6 -notmatch 'blog-post-4\.html') { Write-Host 'FAIL blog-post-6 missing link to blog-post-4.html'; $fail++ } else { Write-Host 'OK   blog-post-6 cross-links to blog-post-4.html' }
if ($post6 -notmatch 'Dr\. Butool Kazmi') { Write-Host 'FAIL blog-post-6 missing author attribution'; $fail++ } else { Write-Host 'OK   blog-post-6 author attribution present' }

foreach ($n in @('blog-post.html','blog-post-2.html','blog-post-3.html','blog-post-4.html','blog-post-5.html')) {
  $verif = Get-Content (Join-Path $root $n) -Raw
  if ($verif -notmatch 'blog-post-6\.html') { Write-Host "FAIL $n missing link to blog-post-6.html"; $fail++ } else { Write-Host "OK   $n cross-links to blog-post-6.html" }
}

$post7 = Get-Content (Join-Path $root 'blog-post-7.html') -Raw
$h2g = ([regex]::Matches($post7, '<h2>')).Count
$h3g = ([regex]::Matches($post7, '<h3>')).Count
$cards7 = ([regex]::Matches($post7, 'class="info-card"')).Count
$cross7 = ([regex]::Matches($post7, 'article-list--cross')).Count
if ($h2g -ne 8) { Write-Host "FAIL blog-post-7 h2 sections = $h2g (expect 8)"; $fail++ } else { Write-Host "OK   blog-post-7 has $h2g sections" }
if ($h3g -lt 10) { Write-Host "FAIL blog-post-7 h3 sub-sections = $h3g (expect 10+)"; $fail++ } else { Write-Host "OK   blog-post-7 has $h3g h3 sub-sections" }
if ($cards7 -ne 1) { Write-Host "FAIL blog-post-7 info cards = $cards7 (expect 1)"; $fail++ } else { Write-Host "OK   blog-post-7 has $cards7 info card" }
if ($cross7 -lt 1) { Write-Host 'FAIL blog-post-7 cross list missing'; $fail++ } else { Write-Host 'OK   blog-post-7 cross list present' }
if (($post7 -notmatch 'contact\.html') -or ($post7 -notmatch 'wa\.me')) { Write-Host 'FAIL blog-post-7 missing contact / WhatsApp links'; $fail++ } else { Write-Host 'OK   blog-post-7 has contact + WhatsApp links' }
if ($post7 -notmatch 'blog-post-6\.html') { Write-Host 'FAIL blog-post-7 missing link to blog-post-6.html'; $fail++ } else { Write-Host 'OK   blog-post-7 cross-links to blog-post-6.html' }
if ($post7 -notmatch 'blog-post-5\.html') { Write-Host 'FAIL blog-post-7 missing link to blog-post-5.html'; $fail++ } else { Write-Host 'OK   blog-post-7 cross-links to blog-post-5.html' }
if ($post7 -notmatch 'Dr\. Butool Kazmi') { Write-Host 'FAIL blog-post-7 missing author attribution'; $fail++ } else { Write-Host 'OK   blog-post-7 author attribution present' }

foreach ($n in @('blog-post.html','blog-post-2.html','blog-post-3.html','blog-post-4.html','blog-post-5.html','blog-post-6.html')) {
  $verif = Get-Content (Join-Path $root $n) -Raw
  if ($verif -notmatch 'blog-post-7\.html') { Write-Host "FAIL $n missing link to blog-post-7.html"; $fail++ } else { Write-Host "OK   $n cross-links to blog-post-7.html" }
}

# Image reference check - every images/... path referenced in HTML must exist
$missingImgs = @()
foreach ($f in $htmlFiles) {
  $c = Get-Content (Join-Path $root $f) -Raw
  foreach ($m in [regex]::Matches($c, 'images/[A-Za-z0-9_.\-]+')) {
    if (-not (Test-Path (Join-Path $root $m.Value))) { $missingImgs += "$f -> $($m.Value)" }
  }
}
if ($missingImgs.Count -gt 0) { Write-Host ("FAIL images missing: " + ($missingImgs -join ', ')); $fail++ } else { Write-Host 'OK   all referenced images exist' }

Write-Host ''
if ($fail -eq 0) { Write-Host 'ALL CHECKS PASSED' } else { Write-Host "$fail CHECK(S) FAILED" }