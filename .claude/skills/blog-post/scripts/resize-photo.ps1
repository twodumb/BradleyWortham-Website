# Resizes a user-supplied JPG/PNG photo for the web and saves it as a JPEG in site\assets\blog\.
# Usage:  powershell -NoProfile -ExecutionPolicy Bypass -File resize-photo.ps1 -Source "C:\path\photo.jpg" -Dest "C:\...\site\assets\blog\my-post.jpg"
# Works with JPG, PNG, BMP, GIF (Windows built-in imaging). WEBP/HEIC are not supported here; copy those as-is instead.
param(
  [Parameter(Mandatory = $true)][string]$Source,
  [Parameter(Mandatory = $true)][string]$Dest,
  [int]$MaxWidth = 1600,
  [int]$Quality = 80
)
Add-Type -AssemblyName System.Drawing
$img = [System.Drawing.Image]::FromFile((Resolve-Path $Source))
try {
  # Respect camera rotation (EXIF orientation) so phone photos aren't sideways
  $orientId = 0x0112
  if ($img.PropertyIdList -contains $orientId) {
    switch ([int]$img.GetPropertyItem($orientId).Value[0]) {
      3 { $img.RotateFlip([System.Drawing.RotateFlipType]::Rotate180FlipNone) }
      6 { $img.RotateFlip([System.Drawing.RotateFlipType]::Rotate90FlipNone) }
      8 { $img.RotateFlip([System.Drawing.RotateFlipType]::Rotate270FlipNone) }
    }
  }
  $w = [Math]::Min($MaxWidth, $img.Width); $h = [int]($img.Height * $w / $img.Width)
  $bmp = New-Object System.Drawing.Bitmap $w, $h
  $g = [System.Drawing.Graphics]::FromImage($bmp)
  $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
  $g.DrawImage($img, 0, 0, $w, $h)
  $codec = [System.Drawing.Imaging.ImageCodecInfo]::GetImageEncoders() | Where-Object { $_.MimeType -eq 'image/jpeg' }
  $params = New-Object System.Drawing.Imaging.EncoderParameters 1
  $params.Param[0] = New-Object System.Drawing.Imaging.EncoderParameter ([System.Drawing.Imaging.Encoder]::Quality), ([long]$Quality)
  New-Item -ItemType Directory -Force -Path (Split-Path $Dest) | Out-Null
  $bmp.Save($Dest, $codec, $params)
  $g.Dispose(); $bmp.Dispose()
  Write-Output ("Saved {0} ({1}x{2}, {3:N0} KB)" -f $Dest, $w, $h, ((Get-Item $Dest).Length / 1KB))
} finally { $img.Dispose() }
