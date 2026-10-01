# Checks a new blog post after it has been written and listed.
# Usage:  powershell -NoProfile -ExecutionPolicy Bypass -File check-post.ps1 -Site "C:\...\Website\site" -Slug "my-post-slug"
param(
  [Parameter(Mandatory = $true)][string]$Site,
  [Parameter(Mandatory = $true)][string]$Slug
)
$problems = @()
$postPath = Join-Path $Site "blog\$Slug.html"
if (-not (Test-Path $postPath)) { Write-Output "FAIL: $postPath does not exist"; exit 1 }
$post = [IO.File]::ReadAllText($postPath)

# Leftover template markers
foreach ($marker in 'EDIT:', 'Your post title goes here', 'your-photo.jpg', 'Describe the photo', 'First paragraph.') {
  if ($post.Contains($marker)) { $problems += "Post still contains template text: '$marker'" }
}
# Required structure
if ($post -notmatch 'data-root="\.\./"') { $problems += 'Post <body> is missing data-root="../" (header/footer links will break)' }
if ($post -notmatch '<script src="\.\./assets/site\.js"></script>') { $problems += 'Post is missing ../assets/site.js' }
if ($post -notmatch '<link rel="stylesheet" href="\.\./assets/style\.css">') { $problems += 'Post is missing ../assets/style.css' }
$emDash = [char]0x2014; $arrow = [char]0x2190   # written as codes: Windows PowerShell 5.1 misreads non-ASCII in scripts
if ($post -notmatch "<title>[^<]+ $emDash Bradley Wortham</title>") { $problems += "Post <title> should end with "" $emDash Bradley Wortham""" }
if ($post -notmatch '<meta name="description" content="[^"]{40,}') { $problems += 'Post meta description is missing or too short' }
if (([regex]::Matches($post, '<h1>')).Count -ne 1) { $problems += 'Post should have exactly one <h1>' }
$tagMatch = [regex]::Match($post, "$arrow Blog</a> \W ([A-Za-z]+)</p>")
$postTag = $tagMatch.Groups[1].Value
if ($postTag -notin 'Local', 'Investing', 'Landlords', 'Renters', 'Buyers') { $problems += "Post topic '$postTag' is not one of Local, Investing, Landlords, Renters, Buyers" }

# Photos: at least one, every one must load
$imgs = [regex]::Matches($post, '<img[^>]+src="([^"]+)"[^>]*>') | ForEach-Object { $_ }
if ($imgs.Count -lt 1) { $problems += 'Post has no photo' }
foreach ($m in $imgs) {
  if ($m.Value -notmatch 'alt="[^"]{5,}"') { $problems += "Photo is missing a descriptive alt text: $($m.Groups[1].Value)" }
  $src = $m.Groups[1].Value
  if ($src -match '^https?://') {
    if ($src -match 'plus\.unsplash\.com') { $problems += "Photo is Unsplash+ (paid license): $src" }
    try { $r = Invoke-WebRequest -UseBasicParsing -Method Head -Uri $src -TimeoutSec 15; if ($r.StatusCode -ne 200) { $problems += "Photo returned $($r.StatusCode): $src" } } catch { $problems += "Photo did not load: $src" }
  } else {
    $local = Join-Path (Join-Path $Site 'blog') $src
    if (-not (Test-Path $local)) { $problems += "Local photo not found: $src (looked for $local)" }
  }
}
# Internal links in the post
foreach ($m in [regex]::Matches($post, 'href="(\.\./[^"#]+)')) {
  $target = [IO.Path]::GetFullPath((Join-Path (Join-Path $Site 'blog') $m.Groups[1].Value))
  if (-not (Test-Path $target)) { $problems += "Broken link in post: $($m.Groups[1].Value)" }
}

# Listed on blog.html (outside the how-to comment) with a matching topic
$blog = [IO.File]::ReadAllText((Join-Path $Site 'blog.html'))
$blogNoComments = [regex]::Replace($blog, '<!--.*?-->', '', 'Singleline')
$row = [regex]::Match($blogNoComments, "<a class=""post-row"" href=""blog/$([regex]::Escape($Slug))\.html"" data-tag=""([A-Za-z]+)"">")
if (-not $row.Success) { $problems += 'Post is not listed on blog.html (or the listing is missing data-tag)' }
elseif ($row.Groups[1].Value -ne $postTag) { $problems += "blog.html data-tag '$($row.Groups[1].Value)' does not match the post topic '$postTag'" }
elseif ($blogNoComments -notmatch "data-filter=""$($row.Groups[1].Value)""") { $problems += "No filter button exists for topic '$($row.Groups[1].Value)'" }

# Home page shows exactly two newest posts, including this one if it's the newest
$index = [IO.File]::ReadAllText((Join-Path $Site 'index.html'))
$homeRows = ([regex]::Matches([regex]::Replace($index, '<!--.*?-->', '', 'Singleline'), 'class="post-row"')).Count
if ($homeRows -ne 2) { $problems += "Home page 'Latest writing' shows $homeRows posts (should be 2)" }

# Dates on blog.html are newest-first
$dates = [regex]::Matches($blogNoComments, '<time datetime="(\d{4}-\d{2}-\d{2})">') | ForEach-Object { $_.Groups[1].Value }
$sorted = $dates | Sort-Object -Descending
if (($dates -join ',') -ne ($sorted -join ',')) { $problems += "blog.html posts are not in newest-first order: $($dates -join ', ')" }

if ($problems.Count) { Write-Output "PROBLEMS FOUND ($($problems.Count)):"; $problems | ForEach-Object { Write-Output " - $_" }; exit 1 }
Write-Output "OK: $Slug.html passes all checks (topic: $postTag, photos: $($imgs.Count), listed on blog.html, home page shows 2 posts)."
