$exiftool = "C:\Users\serde\Downloads\exiftool-13.59_64\exiftool-13.59_64\exiftool.exe"
$pathPorDefecto = "C:\Users\serde\Downloads\slideshow-utherverse\assets\slides"

# Pedir la ruta de las imágenes al usuario
Write-Host "--- Corrector Automático de Orientación de Imágenes ---" -ForegroundColor Yellow
$inputCarpeta = Read-Host "Ingresa la ruta de la carpeta de imágenes [Presiona ENTER para usar '$pathPorDefecto']"

# Si el usuario presiona Enter sin escribir nada, usa la ruta por defecto
if ([string]::IsNullOrWhiteSpace($inputCarpeta)) {
    $carpeta = $pathPorDefecto
} else {
    $carpeta = $inputCarpeta.Trim('"') # Limpia comillas si se arrastra la carpeta a la consola
}

# Validar que la carpeta exista
if (-not (Test-Path $carpeta)) {
    Write-Error "La carpeta especificada no existe: $carpeta"
    exit
}

Add-Type -AssemblyName System.Drawing

Write-Host "`nAnalizando imágenes en $carpeta..." -ForegroundColor Cyan

# Filtrar únicamente las imágenes con orientación EXIF 6
$archivosRotar = & $exiftool -n -if "`$Orientation == 6" -p '$Directory/$FileName' "$carpeta\*.jpg" 2>$null

if ($archivosRotar) {
    Write-Host "Se encontraron $($archivosRotar.Count) imágenes para corregir.`n" -ForegroundColor Green

    foreach ($ruta in $archivosRotar) {
        if ([string]::IsNullOrWhiteSpace($ruta)) { continue }
        
        $archivo = $ruta.Replace('/', '\')
        Write-Host "Rotando: $archivo"

        $img = [System.Drawing.Image]::FromFile($archivo)
        
        # Rotación física de 90°
        $img.RotateFlip([System.Drawing.RotateFlipType]::Rotate90FlipNone)

        # Borrar metadato EXIF para fijar el cambio
        if ($img.PropertyIdList -contains 274) {
            $img.RemovePropertyItem(274)
        }

        $temporal = "$archivo.tmp.jpg"
        $img.Save($temporal, [System.Drawing.Imaging.ImageFormat]::Jpeg)
        $img.Dispose()

        Move-Item -Force $temporal $archivo
    }
    Write-Host "`n¡Proceso de rotación completado con éxito!" -ForegroundColor Green
}
else {
    Write-Host "No se encontraron imágenes con orientación 6 para corregir." -ForegroundColor Yellow
}

# Verificación de estado final manteniendo la salida detallada de ExifTool
Write-Host "`nEstado actual de orientación en la carpeta:" -ForegroundColor Cyan
& $exiftool -Orientation -n "$carpeta\*.jpg"