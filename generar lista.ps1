$carpeta = Read-Host "Escribí la ruta completa de la carpeta donde están las imágenes"

if (-not (Test-Path -Path $carpeta -PathType Container)) {
    Write-Host "La carpeta no existe." -ForegroundColor Red
    Read-Host "Presioná Enter para salir"
    exit
}

Get-ChildItem -Path $carpeta -File |
Where-Object { $_.Extension -in ".jpg",".jpeg",".png",".webp",".gif",".bmp" } |
Sort-Object Name |
ForEach-Object { $_.Name } |
Set-Content -Encoding UTF8 (Join-Path $carpeta "slides.txt")

Write-Host ""
Write-Host "Lista generada correctamente:" -ForegroundColor Green
Write-Host (Join-Path $carpeta "slides.txt")
Write-Host ""

Read-Host "Presioná Enter para salir"