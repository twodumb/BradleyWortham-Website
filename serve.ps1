# Local preview server: serves the site\ folder at http://localhost:8080/
param([int]$Port = 8080)
$root = Join-Path $PSScriptRoot "site"
$types = @{ ".html"="text/html; charset=utf-8"; ".css"="text/css"; ".js"="application/javascript";
            ".png"="image/png"; ".jpg"="image/jpeg"; ".jpeg"="image/jpeg"; ".svg"="image/svg+xml";
            ".webp"="image/webp"; ".ico"="image/x-icon"; ".json"="application/json" }
$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add("http://localhost:$Port/")
$listener.Start()
Write-Host "Serving $root at http://localhost:$Port/"
while ($listener.IsListening) {
  $ctx = $listener.GetContext()
  $path = [Uri]::UnescapeDataString($ctx.Request.Url.AbsolutePath.TrimStart('/'))
  if ($path -eq "" -or $path.EndsWith("/")) { $path += "index.html" }
  $file = Join-Path $root $path
  $res = $ctx.Response
  if ((Test-Path $file -PathType Leaf) -and ([IO.Path]::GetFullPath($file)).StartsWith($root)) {
    $bytes = [IO.File]::ReadAllBytes($file)
    $ext = [IO.Path]::GetExtension($file).ToLower()
    $res.ContentType = if ($types[$ext]) { $types[$ext] } else { "application/octet-stream" }
    $res.OutputStream.Write($bytes, 0, $bytes.Length)
  } else {
    $res.StatusCode = 404
  }
  $res.Close()
}
