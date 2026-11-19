Add-Type -AssemblyName System.Drawing

$ErrorActionPreference = 'Stop'
$outFile = Join-Path $PSScriptRoot '..\meme-draft.png'
$bmp = [System.Drawing.Bitmap]::new(1200, 1200, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
$g = [System.Drawing.Graphics]::FromImage($bmp)
$g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
$g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit

function Brush([string]$hex) { [System.Drawing.SolidBrush]::new([System.Drawing.ColorTranslator]::FromHtml($hex)) }
function Pen([string]$hex, [float]$width) { [System.Drawing.Pen]::new([System.Drawing.ColorTranslator]::FromHtml($hex), $width) }
function RoundRect([System.Drawing.Graphics]$graphics, [System.Drawing.Brush]$brush, [float]$x, [float]$y, [float]$w, [float]$h, [float]$radius) {
  $p = [System.Drawing.Drawing2D.GraphicsPath]::new()
  $d = $radius * 2
  $p.AddArc($x, $y, $d, $d, 180, 90); $p.AddArc($x + $w - $d, $y, $d, $d, 270, 90)
  $p.AddArc($x + $w - $d, $y + $h - $d, $d, $d, 0, 90); $p.AddArc($x, $y + $h - $d, $d, $d, 90, 90)
  $p.CloseFigure(); $graphics.FillPath($brush, $p); $p.Dispose()
}
function OutlineRoundRect([System.Drawing.Graphics]$graphics, [System.Drawing.Pen]$pen, [float]$x, [float]$y, [float]$w, [float]$h, [float]$radius) {
  $p = [System.Drawing.Drawing2D.GraphicsPath]::new()
  $d = $radius * 2
  $p.AddArc($x, $y, $d, $d, 180, 90); $p.AddArc($x + $w - $d, $y, $d, $d, 270, 90)
  $p.AddArc($x + $w - $d, $y + $h - $d, $d, $d, 0, 90); $p.AddArc($x, $y + $h - $d, $d, $d, 90, 90)
  $p.CloseFigure(); $graphics.DrawPath($pen, $p); $p.Dispose()
}
function Text([System.Drawing.Graphics]$graphics, [string]$value, [float]$x, [float]$y, [float]$size, [string]$color, [bool]$bold = $false) {
  $style = if ($bold) { [System.Drawing.FontStyle]::Bold } else { [System.Drawing.FontStyle]::Regular }
  $font = [System.Drawing.Font]::new('Arial', $size, $style, [System.Drawing.GraphicsUnit]::Pixel)
  $brush = Brush $color
  $format = [System.Drawing.StringFormat]::new(); $format.Alignment = [System.Drawing.StringAlignment]::Center
  $graphics.DrawString($value, $font, $brush, $x, $y, $format)
  $format.Dispose(); $brush.Dispose(); $font.Dispose()
}

$g.Clear([System.Drawing.Color]::FromArgb(17, 19, 35))
$sky = [System.Drawing.Drawing2D.LinearGradientBrush]::new([System.Drawing.Rectangle]::new(26, 26, 1148, 1148), [System.Drawing.Color]::FromArgb(17, 18, 46), [System.Drawing.Color]::FromArgb(240, 90, 145), 90)
$g.FillRectangle($sky, 26, 26, 1148, 1148); $sky.Dispose()
$edge = Pen '#c8a9db' 3; $g.DrawRectangle($edge, 27, 27, 1146, 1146); $edge.Dispose()

# Warm sunset and stylized neon Vice City skyline.
$sun = Brush '#ffbe88'; $g.FillEllipse($sun, 806, 254, 248, 248); $sun.Dispose()
$buildings = @(@(125,468,120,185), @(270,520,102,130), @(396,430,131,221), @(548,505,107,146), @(677,454,124,197), @(824,516,111,135), @(958,446,139,205))
foreach ($b in $buildings) {
  $fill = Brush '#33284a'; $outline = Pen '#f78cb2' 7
  $g.FillRectangle($fill, $b[0], $b[1], $b[2], $b[3]); $g.DrawRectangle($outline, $b[0], $b[1], $b[2], $b[3])
  $fill.Dispose(); $outline.Dispose()
  for ($wx = $b[0] + 20; $wx -lt $b[0] + $b[2] - 8; $wx += 42) {
    for ($wy = $b[1] + 28; $wy -lt $b[1] + $b[3] - 10; $wy += 42) {
      $win = Brush '#ffd16e'; $g.FillRectangle($win, $wx, $wy, 14, 18); $win.Dispose()
    }
  }
}

# Palm silhouettes and dusk road.
$palm = Pen '#191b31' 13; $palm.StartCap = [System.Drawing.Drawing2D.LineCap]::Round; $palm.EndCap = [System.Drawing.Drawing2D.LineCap]::Round
$g.DrawLine($palm, 108, 735, 120, 463); $g.DrawLine($palm, 1090, 732, 1080, 477)
$g.DrawBezier($palm, 120, 470, 70, 415, 28, 428, 20, 445); $g.DrawBezier($palm, 120, 470, 53, 438, 35, 482, 23, 495)
$g.DrawBezier($palm, 1080, 480, 1025, 418, 985, 438, 973, 451); $g.DrawBezier($palm, 1080, 480, 1025, 447, 1008, 488, 994, 501)
$palm.Dispose()
$road = [System.Drawing.Drawing2D.LinearGradientBrush]::new([System.Drawing.Rectangle]::new(26, 740, 1148, 434), [System.Drawing.Color]::FromArgb(39, 35, 68), [System.Drawing.Color]::FromArgb(16, 20, 35), 90)
$g.FillRectangle($road, 26, 740, 1148, 434); $road.Dispose()
$dash = Pen '#fff3bd' 12; $dash.StartCap = [System.Drawing.Drawing2D.LineCap]::Round; $dash.EndCap = [System.Drawing.Drawing2D.LineCap]::Round
$g.DrawLine($dash, 590, 804, 570, 877); $g.DrawLine($dash, 644, 805, 637, 878); $g.DrawLine($dash, 720, 807, 728, 880); $dash.Dispose()

# Readable caption block.
RoundRect $g (Brush '#101322') 75 82 1050 220 26
$captionBorder = Pen '#f566bd' 4; OutlineRoundRect $g $captionBorder 75 82 1050 220 26; $captionBorder.Dispose()
Text $g '13 YEARS WAITING.' 600 112 64 '#fff8ee' $true
Text $g '13% DOWNLOADED.' 600 193 64 '#ffcf63' $true

# Turquoise cab with the make.fun passenger visible through the window.
$carPath = [System.Drawing.Drawing2D.GraphicsPath]::new()
$carPath.AddBezier(204, 877, 222, 819, 230, 768, 264, 746); $carPath.AddBezier(264, 746, 282, 706, 326, 704, 384, 697)
$carPath.AddLine(384,697,593,674); $carPath.AddBezier(593,674,648,668,690,692,723,718); $carPath.AddLine(723,718,835,795)
$carPath.AddLine(835,795,948,815); $carPath.AddBezier(948,815,988,824,1005,852,1000,914); $carPath.AddLine(1000,914,183,914)
$carPath.CloseFigure(); $carFill = [System.Drawing.Drawing2D.LinearGradientBrush]::new([System.Drawing.Rectangle]::new(180, 680, 830, 240), [System.Drawing.Color]::FromArgb(78,227,219), [System.Drawing.Color]::FromArgb(20,140,170), 90)
$carLine = Pen '#101322' 17; $g.FillPath($carFill, $carPath); $g.DrawPath($carLine, $carPath); $carFill.Dispose(); $carLine.Dispose(); $carPath.Dispose()
$glass = Brush '#452c55'; $glassLine = Pen '#111323' 12
$g.FillPolygon($glass, [System.Drawing.Point[]]@([System.Drawing.Point]::new(291,770),[System.Drawing.Point]::new(335,722),[System.Drawing.Point]::new(579,695),[System.Drawing.Point]::new(638,705),[System.Drawing.Point]::new(714,770)))
$g.DrawPolygon($glassLine, [System.Drawing.Point[]]@([System.Drawing.Point]::new(291,770),[System.Drawing.Point]::new(335,722),[System.Drawing.Point]::new(579,695),[System.Drawing.Point]::new(638,705),[System.Drawing.Point]::new(714,770)))
$g.FillPolygon($glass, [System.Drawing.Point[]]@([System.Drawing.Point]::new(654,709),[System.Drawing.Point]::new(719,720),[System.Drawing.Point]::new(811,786),[System.Drawing.Point]::new(675,770)))
$g.DrawPolygon($glassLine, [System.Drawing.Point[]]@([System.Drawing.Point]::new(654,709),[System.Drawing.Point]::new(719,720),[System.Drawing.Point]::new(811,786),[System.Drawing.Point]::new(675,770)))
$glass.Dispose(); $glassLine.Dispose()
$frame = Pen '#111323' 12; $g.DrawLine($frame, 644, 704, 650, 775); $frame.Dispose()
Text $g 'make.fun' 575 824 34 '#102039' $true
$taxi = Brush '#ffd05f'; $g.FillRectangle($taxi, 425, 635, 118, 42); $taxi.Dispose(); Text $g 'TAXI' 484 642 23 '#192039' $true
$lamp = Brush '#ffedb0'; $g.FillEllipse($lamp, 215, 827, 78, 25); $g.FillEllipse($lamp, 914, 820, 78, 25); $lamp.Dispose()
$tire = Brush '#141726'; $rim = Brush '#ffcc66'; $g.FillEllipse($tire,283,852,122,122); $g.FillEllipse($tire,797,852,122,122); $g.FillEllipse($rim,324,893,40,40); $g.FillEllipse($rim,838,893,40,40); $tire.Dispose(); $rim.Dispose()

# make.fun mascot: outlined white ghost, sparkle eyes, round hand and magenta star coin.
$ghost = [System.Drawing.Drawing2D.GraphicsPath]::new()
$ghost.AddBezier(713, 770, 710, 730, 710, 636, 785, 614); $ghost.AddBezier(785, 614, 860, 590, 884, 650, 879, 710)
$ghost.AddLine(879,710,879,755); $ghost.AddBezier(879,755,863,735,851,740,842,758); $ghost.AddBezier(842,758,827,778,816,757,807,743)
$ghost.AddBezier(807,743,792,727,780,755,770,769); $ghost.AddBezier(770,769,753,787,740,751,728,772); $ghost.CloseFigure()
$white = Brush '#fffdf8'; $outline = Pen '#171629' 12; $g.FillPath($white,$ghost); $g.DrawPath($outline,$ghost); $white.Dispose(); $outline.Dispose(); $ghost.Dispose()
foreach ($cx in @(762, 817)) { $spark = [System.Drawing.Drawing2D.GraphicsPath]::new(); $spark.AddPolygon([System.Drawing.Point[]]@([System.Drawing.Point]::new($cx,620),[System.Drawing.Point]::new($cx+8,635),[System.Drawing.Point]::new($cx+23,643),[System.Drawing.Point]::new($cx+8,651),[System.Drawing.Point]::new($cx,666),[System.Drawing.Point]::new($cx-8,651),[System.Drawing.Point]::new($cx-23,643),[System.Drawing.Point]::new($cx-8,635))); $ink=Brush '#171629'; $g.FillPath($ink,$spark); $ink.Dispose(); $spark.Dispose() }
$coin = Brush '#ed3aaf'; $coinEdge = Pen '#171629' 9; $g.FillEllipse($coin,850,662,96,96); $g.DrawEllipse($coinEdge,850,662,96,96); $coin.Dispose(); $coinEdge.Dispose()
$star = Brush '#fff8e9'; $g.FillPolygon($star,[System.Drawing.Point[]]@([System.Drawing.Point]::new(898,678),[System.Drawing.Point]::new(906,696),[System.Drawing.Point]::new(926,697),[System.Drawing.Point]::new(911,710),[System.Drawing.Point]::new(916,730),[System.Drawing.Point]::new(898,719),[System.Drawing.Point]::new(880,730),[System.Drawing.Point]::new(885,710),[System.Drawing.Point]::new(870,697),[System.Drawing.Point]::new(890,696))); $star.Dispose()

RoundRect $g (Brush '#15182b') 266 1005 668 88 44
$badge = Pen '#f46fbc' 4; OutlineRoundRect $g $badge 266 1005 668 88 44; $badge.Dispose()
Text $g 'VICE CITY / LAUNCH NIGHT' 600 1024 34 '#fff4dc' $true
Text $g 'A FAN-MADE GTA 6 MEME' 600 1110 20 '#a8adcb' $false

$bmp.Save([System.IO.Path]::GetFullPath($outFile), [System.Drawing.Imaging.ImageFormat]::Png)
$g.Dispose(); $bmp.Dispose()
Write-Output "Rendered $([System.IO.Path]::GetFullPath($outFile))"
